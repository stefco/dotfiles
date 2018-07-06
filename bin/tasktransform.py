#!/usr/bin/env python
# (c) Stefan Countryman (2018)

"""
Read in a list of taskwarrior JSON-formatted tasks (as produced by `task
export`) and apply Stef's desired transformations to them. Provides methods to
read and write from taskwarrior's CLI.
"""

from subprocess import Popen, PIPE
import json
import datetime
import abc
from copy import deepcopy

STRFTIME = "%Y%m%dT%H%M%SZ"


def now():
    """Get the current UTC time in a string format understood by
    taskwarrior."""
    return datetime.datetime.utcnow().strftime(STRFTIME)


def read(*filters):
    """Read taskwarrior tasks via the command line interface. Returns a list of
    task dictionaries. Positional arguments to use as filters for `task` can be
    provided (no filters by default)."""
    proc = Popen(('task',) + filters + ('export',), stdout=PIPE, stderr=PIPE)
    out, err = proc.communicate()
    if proc.returncode:
        raise IOError("Something went wrong while exporting tasks. Got "
                      "returncode {} with\nSTDOUT:\n{}\n"
                      "STDERR:\n{}".format(proc.returncode, out, err))
    return json.loads(out)


def write(tasks):
    """Write a list of task dictionaries to taskwarrior via the CLI."""
    proc = Popen(['task', 'import'], stdin=PIPE)
    json.dump(tasks, proc.stdin)
    out, err = proc.communicate()
    if proc.returncode:
        raise IOError("Something went wrong while importing tasks. Got "
                      "returncode {} with\nSTDOUT:\n{}\nSTDERR:\n{}\nTASKS"
                      "\n{}".format(proc.returncode, out, err, tasks))


class Transform(object):
    """A type of transformation that can be run on a bunch of tasks. Includes a
    filter (specifying which tasks will be modified) and a modifier (specifying
    what change will be made)."""

    __metaclass__ = abc.ABCMeta

    def __init__(self, tasks):
        self.tasks = tasks

    @abc.abstractmethod
    def filtered(self):
        """Return the list of tasks that will be modified."""

    @abc.abstractproperty
    def modifier(self):
        """A function that modifies a single task."""

    def transform(self):
        """Return a modified (deep copied) list of `self.tasks` with `modifier`
        applied to the tasks downselected by `filtered`."""
        taskdict = {t['uuid']: t for t in deepcopy(self.tasks)}
        for task in deepcopy(self.filtered):
            taskdict[task['uuid']] = self.modifier(task)
        return list(taskdict.values())
