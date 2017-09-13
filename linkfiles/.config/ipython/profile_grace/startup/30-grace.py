# (c) Stefan Countryman 2017
# set up an interactive environment with gracedb rest api access.
import ligo.gracedb.rest
client = ligo.gracedb.rest.GraceDb()

def gcn_notice_filenames(graceids):
    """Take a list of GraceIDs and check whether they have LVC GCN-notices. If
    so, print those notice filenames for GraceDB."""
    for gid in graceids:
        print("GraceID: {}".format(gid))
        f = client.files(gid).json()
        print filter(lambda k: 'Initial' in k, f.keys())
