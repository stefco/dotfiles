# Dotfiles

Clone into `~/dev/dotfiles` (path assumed by scripts):

```bash
mkdir -p ~/dev && git clone <repo> ~/dev/dotfiles && cd ~/dev/dotfiles
```

## Setup order

1. **Run the provisioner first** (installs system packages, brew/apt/etc.):
   - macOS: `./provisioners/macos-new.sh`
   - WSL (Ubuntu): `./provisioners/wsl.sh`
   - Debian (legacy): `./provisioners/deb.sh`
   - Windows: `./provisioners/win.ps1`
2. **Then run `./install`** to wire the dotfiles into `~`.
3. **macOS only:** `chsh -s /opt/homebrew/bin/bash` and `git lfs install`.
4. **WSL only:** finish the Doom Emacs steps printed by `wsl.sh` (install nerd-icons fonts, `copilot-install-server`, create GitHub token for magit/forge in `~/.authinfo.gpg`).

To see exactly what packages the provisioner installs, **read the provisioner script** — there's no separate manifest. `macos-new.sh` is the current macOS reference; `macos.sh` is kept only as a legacy MacPorts / scientific-stack reference and is not run on new machines.

## What `./install` does

- **`linkfiles/.*`** — symlinks each entry into `~` (so `linkfiles/.bashrc` → `~/.bashrc`, `linkfiles/.config` → `~/.config`, etc.). Skips if the target exists; pass `-f` to force-overwrite.
- **`copyfiles/.*`** — *copies* into `~` (not symlinks). Use this for files that will accumulate secrets and must not be version-controlled.
- Runs `git submodule update --init` and bootstraps vim-plug for vim + neovim.

Re-running is safe; each entry is skip-if-exists unless `-f`.

## Post-install smoke test

After `./install` (and a fresh shell), confirm:

- [ ] `bash --version` shows a 5.x from `/opt/homebrew/bin/bash` on macOS (not `/bin/bash`).
- [ ] `which ls grep find` point at brew's `gnubin` dirs on macOS (GNU, not BSD).
- [ ] `echo $PATH | tr : '\n' | head` shows brew / conda / cargo / user ahead of system.
- [ ] `declare -F | grep -E 'emacsd|nd|dotsource'` → functions are loaded.
- [ ] `emacsd` starts a daemon; `emc <somefile>` attaches a client.
- [ ] `vim` opens and plugins are installed (`:PlugStatus`).
- [ ] `tmux` starts with the expected keybindings.

## Adding a new machine

1. `scutil --get ComputerName` (macOS) or `hostname -s` (Linux/WSL).
2. Create `bashfuncs/<hostname>` for host-specific init (conda path, nvm, welcome banner, etc.). Generic/portable things belong in a regular `bashfuncs/<feature>` module, not in the per-host file.
3. Add an `elif [ "$COMPUTERNAME" = "<hostname>" ]` branch in `bashfuncs/macos` (or the Linux/WSL equivalent) that `dotsource`s it.

See `CLAUDE.md` and `bashfuncs/CLAUDE.md` for the full map — layout, PATH model, Doom Emacs setup, provisioner differences.

## Email (legacy)

Old reason this repo existed. Notes kept for occasional revival.

### Install

```bash
sudo port -f install neomutt +idn +lmdb +notmuch +ssl
sudo port -f install offlineimap
```

### Configure

Copy `.offlineimaprc` to the home directory. Replace the `<REDACTED>` line with a gmail device password.

Export the macOS trust store: Keychain Access → *System Roots* → *Certificates* → `CMD-A` → `CMD-SHIFT-E` to a single `.pem`. Place at `~/ca-certs/certs.pem` (matches the path in `.offlineimaprc`).

On Linux, use `sslcacertfile = /etc/ssl/certs/ca-certificates.crt` instead.

Run `offlineimap -o` to fetch first time. If you have an offline copy of your mail, rsync that first — far faster than a cold sync. Put `offlineimap` in cron to restart it on crash (acts as a daemon, so it no-ops if already running).

### Utils worth knowing

- `pdftotext` via brew `poppler`
- `atool` (archives), `w3m`, `elinks`
