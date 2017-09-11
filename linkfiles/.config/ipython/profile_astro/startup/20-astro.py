# (c) Stefan Countryman 2017
# Import tools for astrophysics into ipython. Assumes other things have been
# imported already for max utility, but should work alone.
import IPython.core.magic
import astropy.time
import astropy.io.fits
import astropy.wcs
import healpy


# some common time conversions. 
def mjd2utc(mjd=None):
    """Convert MJD time to UTC string. If no argument is provided, return the
    current UTC time."""
    if mjd is None:
        time = astropy.time.Time.now()
    else:
        time = astropy.time.Time(mjd, format='mjd')
    return time.isot

def mjd2gps(mjd=None):
    """Convert MJD time to GPS seconds. If no argument is provided, return the
    current GPS time."""
    if mjd is None:
        time = astropy.time.Time.now()
    else:
        time = astropy.time.Time(mjd, format='mjd')
    return time.gps

def utc2mjd(utc=None):
    """Convert UTC time string to MJD time. If no argument is provided, return
    the current MJD time."""
    if utc is None:
        time = astropy.time.Time.now()
    else:
        time = astropy.time.Time(utc)
    return time.mjd

def utc2gps(utc=None):
    """Convert UTC time string to GPS seconds. If no argument is provided,
    return the current GPS time."""
    if utc is None:
        time = astropy.time.Time.now()
    else:
        time = astropy.time.Time(utc)
    return time.gps

def gps2mjd(gps=None):
    """Convert GPS seconds to MJD time. If no argument is provided, return the
    current MJD time."""
    if gps is None:
        time = astropy.time.Time.now()
    else:
        time = astropy.time.Time(gps, format='gps')
    return time.mjd

def gps2utc(gps):
    """Convert GPS seconds to MJD time. If no argument is provided, return the
    current UTC time."""
    if gps is None:
        time = astropy.time.Time.now()
    else:
        time = astropy.time.Time(gps, format='gps')
    return time.isot
