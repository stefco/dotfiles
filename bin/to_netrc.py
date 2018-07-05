#!/usr/bin/env python
# (c) Stefan Countryman (2018)

"""
Take my heirarchically-organized passwords directory and dump everything to a
.netrc-formatted file.
"""

import os

SECRETPATH = os.path.expanduser("~/secrets")
OUTFILE = os.path.join(SECRETPATH, ".netrc")


def load_secrets(secretpath):
    """Load passwords and logins from my heirarchically-organized passwords
    directory."""
    secrets = dict()
    tiers = (t for t in os.listdir(secretpath) if os.path.isdir(t))
    for tier in tiers:
        secrets[tier] = list()
        for fname in os.listdir(tier):
            secret = dict()
            if "@" in fname:
                secret['machine'] = fname.split("@")[-1]
                secret['login'] = "@".join(fname.split("@")[0:-1])
            else:
                secret['machine'] = fname
            with open(os.path.join(tier, fname)) as infile:
                password = infile.read().strip().encode('string_escape')
                secret['password'] = '"' + password + '"'
            secrets[tier].append(secret)
    return secrets


def save_secrets(secrets, outfile):
    """Write the secrets to a .netrc file named "outfile"."""
    with open(outfile, 'w') as outf:
        for tier in sorted(secrets):
            # it seems that problems sometimes arise with comments in .netrc
            # files.  try to avoid this by just creating a spurious machine
            # definition that will not actually conflict with real machine
            # names and use that as a comment.
            comment_fmt = 'machine The.Following.Are.{}.Credentials\n\n'
            outf.write(comment_fmt.format(tier))
            for secret in secrets[tier]:
                for key in ('machine', 'login', 'password'):
                    if key in secret:
                        outf.write("{} {}\n".format(key, secret[key]))
                outf.write("\n")


def main():
    """Dump passwords located in ~/secrets to ~/secrets/.netrc."""
    save_secrets(load_secrets(SECRETPATH), OUTFILE)


if __name__ == "__main__":
    main()
