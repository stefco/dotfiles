# (c) Stefan Countryman 2017
# set up an interactive environment with gracedb rest api access.
import ligo.gracedb.rest
client = ligo.gracedb.rest.GraceDb()
import dateutil

def gcn_notice_filenames(graceids):
    """Take a list of GraceIDs and check whether they have LVC GCN-notices. If
    so, print those notice filenames for GraceDB."""
    for gid in graceids:
        print("GraceID: {}".format(gid))
        f = client.files(gid).json()
        print filter(lambda k: 'Initial' in k, f.keys())

def get_event_times(triggers, subtractgpstime=True):
    """Take a GraceDB event iterator and return a list of GPS times for
    milestones in each trigger in the ``triggers`` iterable (of the sort
    returned by ``ligo.gracedb.rest.GraceDb().events()``). If
    ``subtractgpstime`` is ``True``, return seconds past GPS time for each
    milestone time (except ``gpstime``, which remains the absolute gps time of
    the reconstructed event)."""
    times = dict()
    for e in triggers:
        gpstime = float(e['gpstime'])
        if subtractgpstime:
            t0 = gpstime
        else:
            t0 = 0.
        logs = client.logs(e['graceid']).json()['log']
        times[e['graceid']] = {
            'emready': ([
                utc2gps(dateutil.parser.parse(l['created'])) - t0
                for l in client.labels(e['graceid']).json()['labels']
                if l['name'] == 'EM_READY'
            ] or [None])[0],
            'created': utc2gps(dateutil.parser.parse(e['created'])) - t0,
            'gpstime': gpstime,
            'gcn': {
                'lvcinitial': min([
                    utc2gps(dateutil.parser.parse(log['created'])) - t0
                    for log in logs
                    if 'Initial.xml' in log['filename']
                ] or None),
                'gcncirc': min([
                    utc2gps(dateutil.parser.parse(log['created'])) - t0
                    for log in logs
                    if log['filename'].startswith("gcncirc")
                ] or [None]),
            },
            'gwhenuploads': {
                'neutrinos': min([
                    utc2gps(dateutil.parser.parse(log['created'])) - t0
                    for log in logs
                    if log['filename'] == 'IceCubeNeutrinoList.json'
                ] or [None]),
                'skymap': min([
                    utc2gps(dateutil.parser.parse(log['created'])) - t0
                    for log in logs
                    if
                    log['filename'].startswith('coinc_skymap_initial_icecube')
                ] or [None]),
            },
        }
    return times
