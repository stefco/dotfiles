# (c) Stefan Countryman 2017
# Set up an interactive environment for handling GWHEN work.
import sys
import os
# used to save data in matlab format
import scipy.io.matlab
# look in both places where GWHEN software tends to hide
GWHEN_DIRS = ['~/multimessenger-pipeline', '~/dev/multimessenger-pipeline']
for gwhendir in [os.path.expanduser(d) for d in GWHEN_DIRS]:
    if os.path.exists(gwhendir):
        sys.path.append(gwhendir)
        sys.path.append(os.path.join(gwhendir, 'gwhen', 'bin'))
        sys.path.append(os.path.join(gwhendir, 'gwhen', 'file_handlers'))
    import gwhen
    from gwhen.file_handlers.icecube_utils import realtime_tools
    from IceCubeNeutrinoList_txt import zen_az2ra_dec, ra_dec2zen_az

# initialize an event here with variable name "e" for quick work.
print('Setting `e` to an event in the current working directory...')
try:
    e = gwhen.Event.fromdir()
except AttributeError as e:
    print('Failed, looks like an old version of GWHEN sans fromdir.')
