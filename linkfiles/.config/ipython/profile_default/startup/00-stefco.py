# (c) Stefan Countryman 2017
# get some basic config just the way i like it, no heavy stuff
import sys
import os
import psutil
import datetime
from glob import glob
import IPython.core.magic
import IPython.utils.path
sys.path.append(os.path.expanduser('~/dev/geco_data'))
# some custom python tools I store in submodules of ``stefco``
sys.path.append(os.path.expanduser('~/dev/dotfiles/python_tools'))

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
get_ipython().run_line_magic('alias', 'ql ql')

@IPython.core.magic.register_line_magic
def shel(line):
    """shell it; make ipython act more like a system shell by making it add
    all executables to the path and by activating autocall."""
    get_ipython().run_line_magic('autocall', '1')
    get_ipython().run_line_magic('rehashx', '')
del shel

@IPython.core.magic.register_line_magic
def gicp(line):
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
del gicp

@IPython.core.magic.register_line_magic
def giw(line):
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
del giw

@IPython.core.magic.register_line_magic
def gip(line):
    """Run input from file; default to ~/.ipyscratch."""
    import os
    import shlex
    import textwrap
    args = shlex.split(line)
    if len(args) == 0:
        path = '~/.ipyscratch'
    else:
        try:
            path = eval(line)
        except:
            path = args[0]
    with open(os.path.expanduser(path)) as f:
        cmd = textwrap.dedent(f.read())
    get_ipython().run_line_magic('pycat', path)
    # update history
    In[-1] = cmd
    get_ipython().run_code(cmd)
del gip

@IPython.core.magic.register_line_magic
def gih(line):
    """Write all history to a file. Defaults to ``~/.ipyhist.py.`` Just a
    shortcut for ``write_hist``."""
    import shlex
    args = shlex.split(line)
    if len(args) == 0:
        write_hist()
    else:
        write_hist(line)
del gih

def write_hist(fname='~/.ipyhist.py'):
    """Write all history from this IPython session to a file. Defaults to
    ``~/.ipyhist.py``."""
    import os
    vseparator = '#' + '#'*62 + '#\n'
    nextcmdfmt = vseparator + '# In[{}]:\n{}\n'
    outputfmt = '#' + '-'*62 + '#\n# Out[{}]:\n# {}\n'
    with open(os.path.expanduser(fname), 'w') as outfile:
        for i in range(len(In)):
            outfile.write(nextcmdfmt.format(i, In[i]))
            if Out.has_key(i):
                out = repr(Out[i]).replace('\n', '\n# ')
                outfile.write(outputfmt.format(i, out))

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
    from stefco.get_terminal_size import get_terminal_size
    import textwrap
    cmd, paths = _cmd_path_lex(line)
    pids, cmds, procs = _psa(cmd, allmatching=True, paths=paths)
    print("Matching processes:\nPID\tCOMMAND\n" + 80*"~" + "\n\n")
    procdict = dict()
    termwidth = get_terminal_size().columns
    for i, pid in enumerate(pids):
        procdict[pid] = procs[i]
        wrappedcmd = textwrap.wrap(str(cmds[i]), width=(termwidth - 8))
        # print pid on first line of command
        print("{}\t{}".format(pid, wrappedcmd.pop(0)))
        # print any remaining lines of the command
        if not len(wrappedcmd) == 0:
            print("\t" + "\n\t".join(wrappedcmd))
        # print an extra blank line after each process
        print("")
    return procdict
del psa

def _psa(cmd, allmatching=True, paths=None):
    """Get processes whose command lines include binaries (according to the PATH
    variable) for the given command. Optionally, only look for the top result,
    or only look for results in given path directories.
    
    Returns a tuple of the form ``(pids, cmdlines, procs)``, where ``pids`` is
    a list of matching pids and ``cmdlines`` is the corresponding list of their
    command lines. The structure is redundant but is optimized for easy
    reading."""
    import psutil
    pids = list()
    cmdlines = list()
    procs = list()
    cmdline = ''
    bins = _whicha(cmd, paths)
    if not allmatching:
        bins = bins[:1]
    for pid in psutil.pids():
        try:
            proc = psutil.Process(pid)
            cmdline = proc.cmdline()
            if any([bin in cmdline for bin in bins]):
                cmdlines.append(cmdline)
                pids.append(pid)
                procs.append(proc)
        except psutil.ZombieProcess:
            pass
        except psutil.AccessDenied:
            pass
    return (pids, cmdlines, procs)
