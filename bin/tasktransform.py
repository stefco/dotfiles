#!/usr/bin/env python
# (c) Stefan Countryman (2018)

"""
Read in a list of taskwarrior JSON-formatted tasks (as produced by `task
export`) and apply Stef's desired transformations to them. Provides methods to
read and write from taskwarrior's CLI.
"""

import sys
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

    def filtered(self):
        """Return the list of tasks that will be modified. By default, act on
        all tasks."""
        return self.tasks

    @abc.abstractproperty
    def modifier(self):
        """A function that modifies a single task. Most likely doesn't actually
        depend on `self`."""

    def transform(self):
        """Return a modified (deep copied) list of `self.tasks` with `modifier`
        applied to the tasks downselected by `filtered`."""
        taskdict = {t['uuid']: t for t in deepcopy(self.tasks)}
        for task in deepcopy(self.filtered()):
            taskdict[task['uuid']] = self.modifier(task)
            taskdict[task['uuid']]['modified'] = now()
        return list(taskdict.values())


class SortTinderMatches(Transform):
    """Takes tasks added from Tinder and sorts them into the Tinder list."""

    def filtered(self):
        """Identify Tinder exports by the way the description starts."""
        return [t for t in self.tasks
                if t['description'].startswith("What do you think about")]

    @property
    def modifier(self):
        """Change the task's Trello Board List to 'Tinder' and add 'tinder'
        tag."""
        def modify(task):
            task["intheamtrellolistname"] = "Tinder"
            task["tags"] = list(set(task.get("tags", [])).union(["tinder"]))
            return task
        return modify


class TrelloTagTransform(Transform):
    """Associate a certain trello list name with a specific tag."""

    @abc.abstractproperty
    def trello_list(self):
        """The trello list to check."""

    @abc.abstractproperty
    def tag(self):
        """The tag that corresponds to ``self.trello_list``."""


class AddTag(TrelloTagTransform):
    """If a task is in the Trello list ``self.trello_list``, tag it as
    ``self.tag``."""

    __metaclass__ = abc.ABCMeta

    def filtered(self):
        """Get tasks in Trello list 'doing' that don't have the 'doing' tag
        yet."""
        return [t for t in self.tasks
                if (self.tag not in t.get("tags", []) and
                    t.get("intheamtrellolistname", "") == self.trello_list)]

    @property
    def modifier(self):
        """Add the 'doing' tag."""
        def modify(task):
            task["tags"] = list(set(task.get("tags", [])).union([self.tag]))
            return task
        return modify


class RemoveTag(TrelloTagTransform):
    """If a task is not in the Trello list ``self.trello_list``, remove tag
    ``self.tag``."""

    __metaclass__ = abc.ABCMeta

    def filtered(self):
        """Get tasks with the 'doing' tag that are not in the Trello 'Doing'
        list."""
        return [t for t in self.tasks
                if (self.tag in t.get("tags", []) and
                    t.get("intheamtrellolistname", "") != self.trello_list)]

    @property
    def modifier(self):
        """Remove the 'doing' tag."""
        def modify(task):
            task["tags"] = list(set(task["tags"]).remove(self.tag))
            return task
        return modify


def associate_trello_list_with_tag(trello_list_name, tag_name):
    """Return classes ``(AddTheTag, RemoveTheTag)`` that make sure that if a
    task is in ``trello_list`` it is also tagged with ``tag``."""

    def trello_list(_self):
        """The trello list to check."""
        return trello_list_name

    def tag(_self):
        """The tag that corresponds to ``self.trello_list``."""
        return tag_name

    add = type(
        "Add{}Tag".format(tag_name.capitalize()),
        (AddTag,),
        {
            'trello_list': property(trello_list),
            'tag': property(tag),
        }
    )

    remove = type(
        "Remove{}Tag".format(tag_name.capitalize()),
        (RemoveTag,),
        {
            'trello_list': property(trello_list),
            'tag': property(tag),
        }
    )

    return add, remove


# pylint: disable=invalid-name
AddDoingTag, RemoveDoingTag = associate_trello_list_with_tag("Doing", "doing")
# pylint: disable=invalid-name
AddPieSkyTag, RemovePieSkyTag = associate_trello_list_with_tag(
    "Pie in the Sky",
    "skypie"
)


# Transforms to run after syncing
SYNC_TRANSFORMS = (
    SortTinderMatches,
    AddDoingTag,
    RemoveDoingTag,
    AddPieSkyTag,
    RemovePieSkyTag,
)


def main():
    original_tasks = read(*sys.argv[1:])
    tasks = deepcopy(original_tasks)
    for transform_class in SYNC_TRANSFORMS:
        tasks = transform_class(tasks).transform()
    taskdict = {t['uuid']: t for t in original_tasks}
    write([t for t in tasks
           if taskdict[t['uuid']]['modified'] != t['modified']])

if __name__ == "__main__":
    main()
