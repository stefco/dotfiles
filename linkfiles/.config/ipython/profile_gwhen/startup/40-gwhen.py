# (c) Stefan Countryman 2017
# Set up an interactive environment for handling GWHEN work.
import sys
import os
# used to save data in matlab format
import IPython.core.magic
import scipy.io.matlab
import subprocess
import llama
try:
    from llama.file_handlers.icecube_utils import realtime_tools
except ImportError:
    print("Failed to load IceCube realtime_tools.")

try:
    from llama.files.i3.utils import zen_az2ra_dec, ra_dec2zen_az
except ImportError:
    print("Failed to load llama.utils coordinate conversions.")

# initialize an event here with variable name "e" for quick work.
print('Setting `e` to an event in the current working directory...')
try:
    e = llama.Event.fromdir()
except AttributeError as e:
    print('Failed, looks like an old version of GWHEN sans fromdir.')

@IPython.core.magic.register_line_magic
def gopen(line):
    """Open a llama file handler. If a valid filehandler object name is
    provided, then that file handler is opened."""
    fh = eval(line)
    subprocess.Popen(['open', fh.fullpath])
del gopen

@IPython.core.magic.register_line_magic
def gql(line):
    """Open a llama file handler file in quicklook. If a valid filehandler
    object name is provided, then that file handler is opened."""
    fh = eval(line)
    subprocess.Popen(['ql', fh.fullpath])
del gql

@IPython.core.magic.register_line_magic
def gcat(line):
    """Imgcat this file to the command line. Good for a very quick preview."""
    fh = eval(line)
    subprocess.Popen(['imgcat', fh.fullpath])
del gcat
