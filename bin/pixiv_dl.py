# coding: utf-8
import os
import logging
from netrc import netrc
from random import random
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
    return api


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


def download_bookmarks(userid, force_all=False):
    """Download all bookmarks for this userid. Stop iterating through
    URLs once we encounter a file that has been downloaded unless
    `force_all` is True. Returns the last processed URL."""
    for bookmark in bookmark_gen(userid):
        for url in get_urls(bookmark):
            name = os.path.basename(url)
            path = os.path.join(DIRNAME, name)
            if os.path.exists(path) and not force_all:
                return url
            LOG.info("Downloading %s to %s then sleeping", url, path)
            api().download(url, path=DIRNAME, name=name)
            sleep(0.3*random() + 0.15)
    return url


def main():
    """Download bookmarks."""
    download_bookmarks(USERID)


if __name__ == "__main__":
    main()
