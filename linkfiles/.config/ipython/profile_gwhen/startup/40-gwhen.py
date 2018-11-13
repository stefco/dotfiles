# (c) Stefan Countryman 2017
# Set up an interactive environment for handling GWHEN work.
import sys
import os
# used to save data in matlab format
import IPython.core.magic
import scipy.io.matlab
import subprocess
# look in both places where GWHEN software tends to hide
GWHEN_DIRS = ['~/multimessenger-pipeline', '~/dev/multimessenger-pipeline']
for gwhendir in [os.path.expanduser(d) for d in GWHEN_DIRS]:
    if os.path.exists(gwhendir):
        print('GWHEN dir found: {}'.format(gwhendir))
        sys.path.append(gwhendir)
        sys.path.append(os.path.join(gwhendir, 'gwhen', 'bin'))
        sys.path.append(os.path.join(gwhendir, 'gwhen', 'file_handlers'))
import gwhen
try:
    from gwhen.file_handlers.icecube_utils import realtime_tools
except ImportError:
    print("Failed to load IceCube realtime_tools.")

try:
    from icecube_neutrino_list_txt import zen_az2ra_dec, ra_dec2zen_az
except ImportError:
    print("Failed to load icecube_neutrino_list_txt coordinate conversions.")
# coordinate conversions for IceCube zenith/azimuth <-> RA/Dec
from gwhen.utils import zen_az2ra_dec
from gwhen.utils import ra_dec2zen_az

# initialize an event here with variable name "e" for quick work.
print('Setting `e` to an event in the current working directory...')
try:
    e = gwhen.Event.fromdir()
except AttributeError as e:
    print('Failed, looks like an old version of GWHEN sans fromdir.')

@IPython.core.magic.register_line_magic
def gopen(line):
    """Open a gwhen file handler. If a valid filehandler object name is
    provided, then that file handler is opened."""
    fh = eval(line)
    subprocess.Popen(['open', fh.fullpath])
del gopen

@IPython.core.magic.register_line_magic
def gql(line):
    """Open a gwhen file handler file in quicklook. If a valid filehandler
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
