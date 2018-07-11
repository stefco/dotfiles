#!/usr/bin/env python
# (c) Stefan Countryman (2018)

"""
Download videos from youtube playlists in a format suitable for PLEX. Taken
from:

https://diyfuturism.com/index.php/2017/12/14/auto-downloading-youtube-videos-for-plex-media-server/
"""

from subprocess import Popen, PIPE
import os
import sys
import datetime
from argparse import ArgumentParser, ArgumentDefaultsHelpFormatter

if os.name == "posix":
    VOLUME_PREFIX = "/mnt/d"
    DEFAULT_YOUTUBEDL = "youtube-dl.exe"
elif os.name == "nt":
    VOLUME_PREFIX = "D:\\"
    DEFAULT_YOUTUBEDL = r"C:\Users\Stefan\bin\youtube-dl.exe"
else:
    raise ValueError("Unidentified OS.")

DEFAULT_OUTPUTDIR = os.path.join(
    VOLUME_PREFIX,
    "media-library",
    "youtube",
)
DEFAULT_CHANNEL_LIST = os.path.join(
    os.path.expanduser("~"),
    "dev",
    "dotfiles",
    "static",
    "youtube-dl-channel-list.txt",
)
DEFAULT_DOWNLOAD_RECORD = os.path.join(DEFAULT_OUTPUTDIR, "downloads.txt")
DEFAULT_LOGFILE = os.path.join(DEFAULT_OUTPUTDIR, "youtube-dl-log.txt")
FILENAME_FORMAT = os.path.join(
    '%(uploader)s',
    '%(playlist)s',
    '%(playlist)s - S01E%(playlist_index)s - %(title)s [%(id)s].%(ext)s',
)
PARSER = ArgumentParser(description=__doc__,
                        formatter_class=ArgumentDefaultsHelpFormatter)
ARG = PARSER.add_argument


ARG("-o", "--oudir", default=DEFAULT_OUTPUTDIR, help="""
    The directory where files are saved. Should be the root of the Plex library
    for your youtube videos.""")
ARG("-y", "--youtubedl", default=DEFAULT_YOUTUBEDL, help="""
    Path to the youtube-dl executable that this script should use.""")
ARG("-r", "--download-record", default=DEFAULT_DOWNLOAD_RECORD, help="""
    Path to the text file that will record which files have already been
    downloaded (and therefore can be skipped on successive invocations of
    youtube-dl).""")
ARG("-c", "--channel-list", default=DEFAULT_CHANNEL_LIST, help="""
    Path to the file containing a list of YouTube channels/playlists to
    download (see the `--batch-file` youtube-dl option for details).""")
ARG("-l", "--logfile", default=DEFAULT_LOGFILE, help="""
    Path to the logfile where the STDERR/STDOUT of each youtube-dl invocation
    will be dumped. Make sure you have access permission if you're setting this
    to something like /var/log/...""")
    


def download(outdir=DEFAULT_OUTPUTDIR, youtubedl=DEFAULT_YOUTUBEDL,
             download_record=DEFAULT_DOWNLOAD_RECORD,
             channel_list=DEFAULT_CHANNEL_LIST, logfile=DEFAULT_LOGFILE):
    """Get the youtube-dl command (as a list that can be passed to
    `subprocess.Popen`) with the given parameters.
    
    Parameters
    ----------
    outdir : `str`, optional
        Where the files should be saved

    youtubedl : `str`, optional
        The name of the executable to call. If it's not in your path, you will
        need to specify the full path to the executable.
        
    download_record : `str`, optional
        The filename of a text file where downloaded videos will be recorded
        (to avoid redownloading them when the script is rerun).

    channel_list : `str`, optional
        The path to the list of youtube channel URLs to try to fetch.

    logfile : `str`, optional
        The path to the file where STDOUT/STDERR will be written by youtube-dl
        and this script.
    """
    cmd = [
        youtubedl,
        '--playlist-reverse',
        '--download-archive',
        download_record,
        '--ignore-errors',
        '--output',
        os.path.join(outdir, FILENAME_FORMAT),
        '--format',
        'bestvideo[ext=mp4]+bestaudio[ext=m4a]',
        '--merge-output-format',
        'mp4',
        '--write-description',
        '--add-metadata',
        '--write-thumbnail',
        '--embed-subs',
        '--batch-file={}'.format(channel_list),
    ]
    with open(logfile, 'a') as log:
        log.write("\n" + "-"*79 + "\n\n")
        log.write("Starting at " + datetime.datetime.now().isoformat() + "\n")
        log.write("Script that produced this:\n")
        log.write("{}\n".format(os.path.realpath(__file__)))
    proc = Popen(cmd, stdout=PIPE, stderr=PIPE)
    out, err = proc.communicate()
    with open(logfile, 'a') as log:
        log.write("Finished at " + datetime.datetime.now().isoformat() + "\n")
        log.write("Return value: {}\n".format(proc.returncode))
        log.write("stdout:\n{}\n".format(out))
        log.write("stderr:\n{}\n".format(err))
        log.write("-"*79 + "\n\n")
    return proc.returncode


def main():
    """Run with default settings."""
    args = PARSER.parse_args()
    download(
        outdir=args.outdir,
        youtubedl=args.youtubedl,
        download_record=args.download_record,
        channel_list=args.channel_list,
        logfile=args.logfile,
    )


if __name__ == "__main__":
    main()
