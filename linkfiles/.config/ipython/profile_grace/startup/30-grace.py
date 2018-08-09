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

def get_event_times(triggers):
    """Take a GraceDB event iterator and return a list of GPS times for
    milestones in each trigger in the ``triggers`` iterable."""
    return {
        e['graceid']: {
            'emready': [
                utc2gps(dateutil.parser.parse(l['created']))
                for l in client.labels(e['graceid']).json()['labels']
                if l['name'] == 'EM_READY'
            ][0],
            'created': utc2gps(dateutil.parser.parse(e['created'])),
            'gpstime': float(e['gpstime']),
            'lvcinitial': min([
                utc2gps(dateutil.parser.parse(log['created']))
                for log in client.logs(e['graceid']).json()['log']
                if 'Initial.xml' in log['filename']
            ]),
        } for e in triggers
    }
