#!/usr/bin/env python
"""
Archive bookmarked post metadata from pixiv.net to a SQL database and download
the corresponding images.
"""

import os
import logging
import argparse
import sqlite3
from dateutil.parser import parse
from collections import namedtuple
from textwrap import dedent
from random import random
from netrc import netrc
from time import sleep
import pixivpy3
logging.basicConfig(
    # level=logging.DEBUG,
    level=logging.INFO
)
LOG = logging.getLogger(__name__)
SIZES = {'large', 'original'}
DIRNAME = os.path.expanduser(os.path.join("~", "Downloads", "pixiv"))
if not os.path.isdir(DIRNAME):
    os.makedirs(DIRNAME)
USERID = 38913802
DB_PATH = os.path.join(DIRNAME, 'bookmarks.db')
CONNECTION = sqlite3.connect(DB_PATH)
CURSOR = CONNECTION.cursor()
SIZE_PRIORITY = {
    'original': 1,
    'large': 2,
    'medium': 3,
    'square_medium': 4,
}


def dedent_sql(command):
    """Dedent a SQL command string."""
    lines = command.split('\n')
    return dedent('\n'.join([l for l in lines if not set(l).issubset({' '})]))


TABLE_DEFINITIONS = namedtuple(
    'namespace',
    (
        'bookmarks',
        'tags',
        'urls',
    ),
)(
    bookmarks=dedent_sql("""
        CREATE TABLE IF NOT EXISTS bookmarks (
            pk                      integer PRIMARY KEY,
            title                   text    NOT NULL,
            caption                 text    NOT NULL,
            user_pk                 integer NOT NULL,
            create_timestamp        integer NOT NULL
        );
    """),
    tags=dedent_sql("""
        CREATE TABLE IF NOT EXISTS tags (
            name                    text    NOT NULL,
            bookmark_pk             integer NOT NULL,
            PRIMARY KEY (name, bookmark_pk),
            FOREIGN KEY (bookmark_pk) REFERENCES bookmarks (pk)
                ON DELETE CASCADE ON UPDATE NO ACTION
        );
    """),
    urls=dedent_sql("""
        CREATE TABLE IF NOT EXISTS urls (
            url                     text    PRIMARY KEY,
            bookmark_pk             integer NOT NULL,
            page_number             integer NOT NULL,
            size                    text    NOT NULL,
            size_priority           integer NOT NULL,
            FOREIGN KEY (bookmark_pk) REFERENCES bookmarks (pk)
                ON DELETE CASCADE ON UPDATE NO ACTION
        );
    """),
)


def init_tables():
    """Initialize tables in the local pixiv bookmark database if they don't
    already exist."""
    for command in TABLE_DEFINITIONS:
        CURSOR.execute(command)
    CONNECTION.commit()


def save_bookmark(bookmark):
    """Save a pixiv bookmark to the local database."""
    CURSOR.execute(
        'INSERT OR REPLACE INTO bookmarks VALUES (?, ?, ?, ?, ?)',
        (
            bookmark['id'],
            bookmark['title'],
            bookmark['caption'],
            bookmark['user']['id'],
            parse(bookmark['create_date']).timestamp(),
        )
    )
    pgs = bookmark['meta_pages'] if bookmark['meta_pages'] else [bookmark]
    for page_number, page in enumerate(pgs):
        for size, url in page['image_urls'].items():
            url_row = (url, bookmark['id'], page_number, size,
                       SIZE_PRIORITY.get(size, 10))
            LOG.debug(url_row)
            CURSOR.execute(
                'INSERT OR REPLACE INTO urls VALUES (?, ?, ?, ?, ?)',
                url_row
            )
    for tag in bookmark['tags']:
        CURSOR.execute('INSERT OR REPLACE INTO tags VALUES (?, ?)',
                       (tag['name'], bookmark['id']))
    CONNECTION.commit()


def parse_args():
    """Parse CLI arguments."""
    parser = argparse.ArgumentParser("{}\nOutput dir: {}".format(__doc__,
                                                                 DIRNAME))
    arg = parser.add_argument
    arg("-f", "--fetch", action="store_true", help="""
        Fetch the latest bookmark JSON data from the pixiv API and save it to
        the local database. Does not prune local bookmarks that have been
        removed on the server.""")
    arg("-d", "--download-missing", action="store_true", help="""
        Download any images listed in bookmarks on the local database. By
        default, does not refresh the contents of the database.""")
    arg("-p", "--prune-local", action="store_true", help="""
        Fetch latest bookmark JSON data from the pixiv API (like `-f`),
        but also delete any local database entries and image files
        corresponding to bookmarks that have been deleted on pixiv.""")
    return parser.parse_args()


def api_factory():
    """Return a function that returns a logged-in pixiv API instance. Keeps
    returning the same API after initialization to avoid repeated logins. If
    you need to refresh your login credentials, run `api().login(username,
    password)` again."""
    api_closure = []
    def api_wrapper():
        if api_closure:
            return api_closure[0]
        LOG.debug("Creating new AppPixivAPI instance and logging in.")
        api_closure.append(pixivpy3.AppPixivAPI())
        username, _, password = netrc().authenticators("pixiv.net")
        api_closure[0].login(username, password)
        return api_closure[0]
    return api_wrapper


api = api_factory()  # pylint: disable=invalid-name


def bookmark_gen(userid):
    """Iterate through bookmarks, fetching the next page as necessary."""
    # get the first 30
    LOG.info("Getting the first bookmarks page.")
    count = 0
    bookmarks_json = api().user_bookmarks_illust(userid)
    for bookmark in bookmarks_json['illusts']:
        count += 1
        yield bookmark
    # get the next page and keep going
    while bookmarks_json.next_url is not None:
        LOG.info("Fetching another bookmarks page; %s bookmarks done.",
                 count)
        next_qs = api().parse_qs(bookmarks_json.next_url)
        bookmarks_json = api().user_bookmarks_illust(**next_qs)
        for bookmark in bookmarks_json['illusts']:
            count += 1
            yield bookmark


def get_urls(bookmark):
    pgs = bookmark['meta_pages'] if bookmark['meta_pages'] else [bookmark]
    return [p['image_urls'].get('original', p['image_urls']['large'])
            for p in pgs if SIZES.intersection(p['image_urls'])]


def fetch_bookmarks(userid, prune=False):
    """Download bookmarks from pixiv API and save them to the local database.
    If `prune` is true, delete missing entries."""
    if prune:
        raise NotImplementedError("Pruning not yet implemented.")
    init_tables()
    for bookmark in bookmark_gen(userid):
        save_bookmark(bookmark)


def load_local_url_info():
    """Load all locally-saved URLs, returning the highest-resolution available
    URL per page per bookmark and returning the SQL cursor, which can be
    iterated over to retrieve results of the format
    (bookmark_id, user_id, page_no, url, size_priority)."""
    return CURSOR.execute(dedent_sql("""
        SELECT
            bookmarks.pk,
            bookmarks.user_pk,
            urls.page_number,
            urls.url,
            MIN(urls.size_priority)
        FROM urls
        JOIN bookmarks ON bookmarks.pk = urls.bookmark_pk
        GROUP BY bookmarks.pk, urls.page_number
    """))


def get_path_and_filename(user_id, url):
    """Get the name of the directory where an image should be saved as well as
    the filename to be used."""
    return os.path.join(DIRNAME, str(user_id)), os.path.basename(url)


def download_bookmarks(userid, force_all=False):
    """Download all bookmarks for this userid. Stop iterating through
    URLs once we encounter a file that has been downloaded unless
    `force_all` is True. Returns the last processed URL or None if none were
    processed."""
    url = None
    for bookmark in bookmark_gen(userid):
        for url in get_urls(bookmark):
            name = os.path.basename(url)
            path = os.path.join(DIRNAME, bookmark['user']['id'])
            if not os.path.isdir(path):
                os.makedirs(path)
            fullpath = os.path.join(path, name)
            if os.path.exists(fullpath) and not force_all:
                LOG.info("Encountered a previously-downloaded image, "
                         "quitting.")
                return url
            LOG.info("Downloading %s to %s then sleeping", url, fullpath)
            api().download(url, path=path, name=name)
            sleep(0.3*random() + 0.15)
    return url


def main():
    """Download bookmarks."""
    args = parse_args()
    if args.fetch or args.prune_local:
        fetch_bookmarks(USERID, args.prune_local)
    if args.download_missing:
        for _bid, user_id, _pno, url, _sprio in load_local_url_info():
            path, name = get_path_and_filename(user_id, url)
            if os.path.exists(os.path.join(path, name)):
                LOG.debug("File %s already found in %s.", name, path)
            else:
                if not os.path.isdir(path):
                    os.makedirs(path)
                LOG.info("Downloading %s to %s and then sleeping.", url, path)
                api().download(url, path=path, name=name)
                sleep(0.3*random() + 0.15)


if __name__ == "__main__":
    main()
