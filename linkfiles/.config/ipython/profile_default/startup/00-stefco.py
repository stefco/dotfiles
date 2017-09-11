# (c) Stefan Countryman 2017
# get some basic config just the way i like it, no heavy stuff
import sys
import os
import IPython.core.magic
import IPython.utils.path
sys.path.append(os.path.expanduser('~/dev/geco_data'))

# get the location of the ipython directory
# ipydir = IPython.utils.path.get_ipython_dir()

# aliases for my fav commands; more ideas at
# https://gist.github.com/taldcroft/547c0b6e0ae15e0c970d
get_ipython().run_line_magic('alias', 'vim vim')
get_ipython().run_line_magic('alias', 'imgcat imgcat')
get_ipython().run_line_magic('alias', 'find find')
get_ipython().run_line_magic('alias', 'git git')
get_ipython().run_line_magic('alias', 'pstree pstree')
get_ipython().run_line_magic('alias', 'mutt mutt')

@IPython.core.magic.register_line_magic
def shit(line):
    """shell it; make ipython act more like a system shell by making it add
    all executables to the path and by activating autocall."""
    get_ipython().run_line_magic('autocall', '1')
    get_ipython().run_line_magic('rehashx', '')
del shit

@IPython.core.magic.register_line_magic
def cpin(line):
    """Read from ``In[-n-2]`` and copy it to the system clipboard
    using ``pyperclip``. Indexing starts at 1. So to get the most recent
    input text, run ``cpin 1`` or ``cpin`` etc."""
    import pyperclip
    import shlex
    args = shlex.split(line)
    if len(args) == 0:
        num_lines_prior = 1
    else:
        num_lines_prior = int(args[1])
    pyperclip.copy(In[-1-num_lines_prior])
del cpin

@IPython.core.magic.register_line_magic
def win(line):
    """Write contents of ``In[-n-2]`` to ``~/.ipyscratch`` (or some other
    file) for easy use elsewhere. Use caution; will overwrite contents of
    this scratch file.

    Usage:
      %win
      %win 1
      %win 1 ~/foo.py
      %win ~/foo.py

    CAUTION: Positive integers are assumed to specify the number of lines
    prior in the interpreter to read from. The first positive integer in
    the argument list will be thus interpreted. If you need to write to a
    file whose name is also a positive integer, make sure to explicitly
    specify the number of lines back before specifying the file name, even if
    you just want the last line. For example, to write the most recent line
    to a file called ``5``, call:

      %win 1 5

    Omitting the ``1`` will imply that the default scratch file should be
    used and that the command 5 lines prior in the interpreter should be
    copied.
    """
    import shlex
    import os
    args = shlex.split(line)
    # get the number of lines prior as the first positive integer
    if len(args) == 0:
        num_lines_prior = 1
    for arg in args:
        try:
            num_lines_prior = int(arg)
            if num_lines_prior > 0:
                args.remove(arg)
                continue
        except ValueError:
            pass
    # get the first remaining argument and use that as the text file. if no
    # args remain, use the default path.
    if len(args) == 0:
        fname = '~/.ipyscratch'
    else:
        fname = args[0]
    with open(os.path.expanduser(fname), 'w') as outfile:
        outfile.write(In[-1-num_lines_prior])
del win

# functions for working with processes
def _cmd_path_lex(line):
    """Split a ``magic`` input line so that ``%which`` and ``%ps`` can
    interpret a command name and a path in a convenient manner."""
    import os
    args = line.split(' ', 1)
    cmd = args.pop(0)
    if len(args) == 0:
        paths = os.environ["PATH"].split(":")
    else:
        pathstr = args[0].strip()
        try:
            paths = eval(pathstr)
        except:
            paths = pathstr
        if isinstance(paths, unicode) or isinstance(paths, str):
            if ":" in paths:
                paths = paths.split(":")
            else:
                paths = [paths]
    return cmd, paths

@IPython.core.magic.register_line_magic
def whicha(line):
    """Get an array of all matching executable files in PATH; same as UNIX
    which -a. Optionally specify a custom list of executable paths like that
    returned by ``os.environ["PATH"].split(":")``. You don't have to quote the
    command name (first arg).

    If you choose to specify the path, you must leave a space between the
    command name and the path. For the path, you can either:

      1. Provide a list whose elements are directories in $PATH
      2. Provide a string resembling the shell $PATH format (no need to
         escape spaces in the middle of the path, though leading and
         trailing spaces are stripped)
      3. Leave the shell-formatted $PATH literal unquoted, in which case it
         will be interpreted exactly the same as a shell $PATH, colons and all;
         note that this variant will be masked by variable names that are the
         same as the path due to ``eval()``, though this is an edge case.
    """
    return _whicha(*_cmd_path_lex(line))
del whicha

def _whicha(cmd, paths=None):
    """Get an array of all matching executable files in PATH; same as UNIX
    which -a. ``paths`` must be a list of dirs like that returned by
    ``os.environ['PATH'].split(':')."""
    import os
    if paths is None:
        paths = os.environ['PATH'].split(':')
    possibilities = [os.path.expanduser(os.path.join(p, cmd)) for p in paths]
    return filter(lambda bin: os.path.exists(bin), possibilities)

@IPython.core.magic.register_line_magic
def psa(line):
    """Get all matching processees for a command, searching for executable
    names along either the OS $PATH or along a custom specified path (see
    ``%which`` documentation for syntax)"""
    cmd, paths = _cmd_path_lex(line)
    return _psa(cmd, allmatching=True, paths=paths)
del psa

def _psa(cmd, allmatching=True, paths=None):
    """Get processes whose command lines include binaries (according to the PATH
    variable) for the given command. Optionally, only look for the top result,
    or only look for results in given path directories.
    
    Returns a tuple of the form ``(pids, cmdlines)``, where ``pids`` is a list
    of matching pids and ``cmdlines`` is the corresponding list of their
    command lines."""
    import psutil
    pids = list()
    cmdlines = list()
    cmdline = ''
    bins = _whicha(cmd, paths)
    if not allmatching:
        bins = bins[:1]
    for pid in psutil.pids():
        try:
            cmdline = psutil.Process(pid).cmdline()
            if any([bin in cmdline for bin in bins]):
                cmdlines.append(cmdline)
                pids.append(pid)
        except psutil.ZombieProcess:
            pass
        except psutil.AccessDenied:
            pass
    return (pids, cmdlines)
