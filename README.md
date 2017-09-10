# Dotfiles

## Configuring Email

### Install Neomutt

```bash
sudo port -f install neomutt +idn +lmdb +notmuch +ssl
```

### Install offlineimap

```bash
sudo port -f install offlineimap
```

### Configure Email

Copy `.offlineimaprc` to the home directory. Replace the `<REDACTED>` line in
`.offlineimaprc` with a device password for gmail.

Open up the *Keychain Access* app, go to *System Roots* and then
*Certificates*, hit `CMD-A` to select all, and hit `CMD-SHIFT-E` to export all
certificates into a single `.pem` file. Place this at the path indicated in
`.offlineimaprc`, which should be `~/ca-certs/certs.pem`.

On Linux, you should be able to use something like

```
sslcacertfile = /etc/ssl/certs/ca-certificates.crt
```

in `.offlineimaprc`.

Run `offlineimap -o` to fetch email for the first time. Will probably take a
while. If you have an offline copy of your email, it will be much quicker to
rsync that whole thing and then go from there with `offlineimap`.

Put `offlineimap` in a cron script to periodically restart it in case it
crashes. It acts as a daemon, so it will just quit immediately if an instance
is running already. I have read old testimony claiming that `offlineimap`
tends to hang, but in my experience, it just crashes when it messes up. I will
update as necessary if the hanging problem rears its ugly head.

## Some nice utils

- pdftotext, via poppler package on brew
- atool (for archives)
- w3m
- elinks
