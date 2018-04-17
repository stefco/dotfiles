#!/usr/bin/env python
# (c) Stefan Countryman 2018

"""
Print a nicely formatted list of git commits that I can put into my update
emails for Szabi and Zsuzsa.
"""

import sys
import os
from subprocess import Popen, PIPE
import argparse
from textwrap import fill

DESC = """Print commit messages between the specified dates in a text format
that can be readily dumped into a text email. Pipe to ``pbcopy`` to immediately
copy the result to the clipboard (on MacOS at least)."""
COMMIT_DELIMITER = "NEXT COMMIT STARTING NOW!"
DEFAULT_INDENT = 4
COL_NUM = 79
PRETTY_FORMAT = '--pretty=format:{}%ad: %B'.format(COMMIT_DELIMITER)

PARSER = argparse.ArgumentParser(description=DESC)
ARG = PARSER.add_argument
ARG("start", help='The earliest commit time to include, e.g. "APR 2 2018".')
ARG("end", help='The latest commit time to include, e.g. "APR 9 2018".')
ARG("-d", "--dir", help='Path to git repo (DEFAULT: current directory)')


def git_remote(workingdir=None):
    """Get the ``origin`` remote directory URL for the git repo contained in
    ``workingdir``. If ``workingdir`` is not provided, default to the current
    directory."""
    if workingdir:
        olddir = os.getcwd()
        os.chdir(workingdir)
    cmd = ['git', 'remote', 'get-url', 'origin']
    proc = Popen(cmd, stdout=PIPE, stderr=PIPE)
    commitlog, err = proc.communicate()
    if proc.returncode != 0:
        fmt = 'Problem while acquiring git remote.\nSTDOUT:\n{}\nSTDERR:\n{}\n'
        raise IOError(fmt.format(commitlog, err))
    if workingdir:
        os.chdir(olddir)
    return commitlog.strip()


def git_log(start, end, workingdir=None):
    """Run a ``git log`` command that will provide a nicely formatted list of
    commits between ``start`` and ``end`` times. If ``workingdir`` is provided,
    change to that directory before running the command."""
    if workingdir:
        olddir = os.getcwd()
        os.chdir(workingdir)
    cmd = ['git', 'log', '--since', start, '--until', end, PRETTY_FORMAT]
    proc = Popen(cmd, stdout=PIPE, stderr=PIPE)
    commitlog, err = proc.communicate()
    if proc.returncode != 0:
        fmt = 'Problem while acquiring git log.\nSTDOUT:\n{}\nSTDERR:\n{}\n'
        raise IOError(fmt.format(commitlog, err))
    if workingdir:
        os.chdir(olddir)
    return commitlog


def parse(commitlog):
    """Split raw output of ``git_log`` up into a list of commits + descriptions
    (leaving no newlines)."""
    lines = commitlog.split('\n')
    commits = []
    nextcommit = lines[0].strip().replace(COMMIT_DELIMITER, '', 1)
    for line in lines[1:]:
        line = line.strip()
        if line.startswith(COMMIT_DELIMITER):
            commits.append(nextcommit)
            nextcommit = line.replace(COMMIT_DELIMITER, '', 1)
        else:
            nextcommit += ' ' + line
    commits.append(nextcommit)
    return commits


def reformat(commits, indentation=DEFAULT_INDENT):
    """Take a list of commits + messages (each on a single line) and
    fill/indent them by ``indentation``. Add a "-" to the beginning of each
    commit within the indented whitespace before the first line.
    (``indentation`` must be >2 to allow for this "-" character and the space
    that follows it.)"""
    if indentation < 2:
        raise ValueError("Indentation must be >= 2 to allow for bullets.")
    if commits == ['']:
        return ''
    width = COL_NUM - indentation
    bullet = ' '*(indentation-2) + '-' + ' '
    spaces = '\n' + (' '*indentation)
    commits = [bullet + fill(c, width).replace('\n', spaces) for c in commits]
    return '\n'.join(commits)


def main():
    """Main body of the script."""
    args = PARSER.parse_args()
    commitlog = reformat(parse(git_log(args.start, args.end, args.dir)))
    if commitlog:
        sys.stdout.write("(Remote URL: {})\n".format(git_remote(args.dir)))
        sys.stdout.write(commitlog)


if __name__ == "__main__":
    main()
