# dotfiles

Personal dotfiles maintained since ~2017. Runs across macOS, Linux, and WSL on many machines. Bash-first (not zsh); modular init via a home-grown `dotsource` mechanism; per-host specialization keyed on hostname.

## Toolchain preferences

- **GNU over BSD.** On macOS, Homebrew's `coreutils`, `findutils`, `grep`, etc. are installed and their `gnubin` dirs are promoted in PATH so `ls`, `grep`, `find`, etc. behave like Linux.
- **Homebrew on macOS.** `provisioners/macos-new.sh` is the current provisioner. The older MacPorts-based `macos.sh` is kept only as a reference for the LIGO/scientific stack — not run on new machines.
- **Language toolchains via their own managers, never the system package manager.** Python via Anaconda/Miniconda; Node via nvm; Rust via rustup (`~/.cargo`). Brew/apt are for portable system tools only. This keeps machines portable across macOS and Linux.
- **Cross-platform editors/tools:** Emacs (Doom) is the primary editor, Alacritty the terminal, tmux, vim. All configured to work identically on macOS, Linux, and WSL.
- **Shell:** bash (`set -o vi`). On macOS the brew bash binary is added to `/etc/shells` and set as the login shell.

## Install flow

`./install` (idempotent; `-f` to overwrite):

1. Symlinks every dotfile under `linkfiles/.*` into `~` (so `linkfiles/.bashrc` becomes `~/.bashrc`, `linkfiles/.config/` becomes `~/.config`, etc.).
2. Copies `copyfiles/.*` into `~` (these hold files that will accumulate secrets; must not be version-controlled after copy).
3. Runs `git submodule update --init`.
4. Bootstraps `vim-plug` for vim and neovim.

Because `~/.local` is symlinked into the repo, **anything a tool writes under `~/.local/` lands inside `linkfiles/.local/`** (e.g. the Claude CLI installs itself there, Doom writes profile state there). This is intentional — state files that come along with the tool are fine to ride in the repo as untracked — but be aware when committing: don't `git add` broad globs.

## Bash init model

`~/.bashrc` defines a `dotsource <name>` helper that sources `bashfuncs/<name>` and records which functions and aliases that file contributed (via `_func_sources` and `_alias_sources` associative arrays — useful for debugging where a function came from).

Load order:

1. **OS branch.** `macos`, or `linux` (+ `wsl` if `$WSL_DISTRO_NAME` is set).
2. **Per-host file** from inside the OS branch: `bashfuncs/macos` looks at `scutil --get ComputerName` and dotsources a matching file — `motoko`, `melchior`, etc. Linux/WSL use similar hostname checks.
3. **Generic modules:** `emacsd`, `emc`, `sessiontype`, `tokens`, `colors`, `iterm`, `pathinit`, `navigate`, `aliases`, `promptline`, `condas`, and a grab-bag of small utilities.

See `bashfuncs/CLAUDE.md` for naming conventions and how to add a new per-host file.

## PATH

`bashfuncs/pathinit` calls `bin/pathsorter` — a Python script that takes named path groups as arguments and reorders `$PATH` so that the **leftmost argument wins**. Groups are defined at the top of `bin/pathsorter`:

- `brew`: `/opt/homebrew/bin` plus `coreutils`, `findutils`, `grep`, `llvm`, etc. `libexec/gnubin` directories — this is how GNU tooling takes priority.
- `llama`: `/opt/anaconda/bin` (the canonical Anaconda location for the current host pattern).
- `user`: `~/bin`, `~/dev/dotfiles/linkfiles/.iterm2`.
- `cargo`, `mactex`, `sys`, `doom` (= `~/.config/emacs/bin`), and a handful of legacy Python/Port ones.

To change priority, edit the argument list in `bashfuncs/pathinit`, not the code. New machines typically just need the group added to `bin/pathsorter`.

## Editor: Doom Emacs

**Install layout.** Doom source lives at `~/.config/emacs` (cloned from upstream `doomemacs/doomemacs`). User config lives at `~/.config/doom/{init.el,config.el,packages.el}`. `~/.config` is a symlink into `linkfiles/.config/`, so edits to `linkfiles/.config/doom/*.el` and `~/.config/doom/*.el` are the same file — changes propagate both ways.

**The three config files:**

- `init.el` — which Doom modules are enabled (`:lang python`, `:tools lsp`, etc.). After editing: `doom sync` (then restart Emacs).
- `packages.el` — third-party package declarations (e.g. `copilot`, `wgsl-mode`). After editing: `doom sync`.
- `config.el` — private customization. After editing: no restart needed, or `M-x doom/reload`.

**Daemon workflow.** Preferred over one-off Emacs invocations.

- `emacsd` — start the daemon. Inside a subshell it probes candidate conda install roots (`/opt/miniconda3`, `/opt/anaconda3`, `~/anaconda3`, `~/miniconda3`) and `conda activate emacs` (required for the cmake LSP server). It also bumps node to ≥20 via `nvm use` if the current node is too old, so LSP servers that rely on node work.
- `emacsd list` / `emacsd l` — list running daemons.
- `emacsd kill` / `emacsd k` — kill all running daemons.
- `emc <file>` — `emacsclient -n` (opens in the running daemon, no wait).
- `emacsg <file>` — macOS only; opens `EmacsMac.app` via `open -a`. Used when a proper GUI window is wanted instead of the client.

**LSP/external dependencies Emacs expects.** These come from the provisioner, not Doom itself:
- `clangd`, `clang-format` (C/C++).
- `wgsl_analyzer` via `cargo install` (WebGPU Shader Language).
- A conda env named `emacs` with python + pip (used by the cmake LSP).
- node ≥20 via nvm (for JS/TS/web LSP servers and copilot).

## Provisioners

One script per target platform. Run on a fresh machine, once.

- `provisioners/macos-new.sh` — **current** macOS provisioner (Homebrew). Installs GNU tooling, emacs-mac via `railwaycat/emacsmacport`, mactex cask. Builds ffmpeg with `--enable-libfdk-aac` from source.
- `provisioners/macos.sh` — **legacy** MacPorts-based provisioner. Kept for reference / quick revival of the LIGO scientific stack (lalsuite, nds2, etc.). Not run on new machines.
- `provisioners/wsl.sh` — current WSL (Ubuntu) provisioner. Most up-to-date reference for what actually gets installed: neovim, fzf, ripgrep, Anaconda, clang + clangd, a from-source Emacs 30.1 build with native-comp + tree-sitter + pgtk, Doom, rustup, wgsl_analyzer.
- `provisioners/deb.sh` — older Debian provisioner (LIGO-flavored).
- `provisioners/win.ps1` — Windows PowerShell provisioner.

After the provisioner, run `./install` from the repo root.

## Repository layout

- `bashfuncs/` — bash modules loaded by `dotsource`. See `bashfuncs/CLAUDE.md`.
- `bin/` — user-land scripts, placed on PATH via the `user` group. `pathsorter` is the important one.
- `linkfiles/` — files and directories that get symlinked into `~` by `./install`. Includes `.bashrc`, `.vimrc`, `.tmux.conf`, `.config/{doom,emacs,alacritty,…}`, `.local/` (see note above).
- `copyfiles/` — files copied (not linked) into `~` because they will accumulate secrets.
- `provisioners/` — one script per platform.
- `submodules/` — vendored git submodules.
- `static/` — ASCII art and other static assets (welcome banners per-host, etc.).
- `bookmarks/`, `~/bookmarks/` — named symlinks used by `nd -b <name>` / `bcd` for quick directory jumps (see `bashfuncs/navigate`).
- `scripts/`, `winscripts/`, `automator/`, `python_tools/`, `prefs/` — one-off platform scripts and app preference plists.

## Current host

A `SessionStart` hook (configured in `.claude/settings.json`) injects a line of the form:

```
Host context: hostname=<name> | OSTYPE=<darwin*|linux-gnu|...> | uname=<uname -srm> | WSL=<distro|no>
```

into the session context. **Use that line** to decide which OS branch file in `bashfuncs/` applies (`macos` / `linux` / `wsl`) and whether a per-host file exists (`ls bashfuncs/` then match the hostname). If the hook hasn't fired (older session, hook disabled), run `scutil --get ComputerName 2>/dev/null || hostname -s` and `echo $OSTYPE` yourself.

List currently-specialized hosts by reading the host-check branches in `bashfuncs/macos`, `bashfuncs/linux`, `bashfuncs/wsl`.

## Adding a new per-host file

1. Get the machine name (macOS: `scutil --get ComputerName`, or System Settings → General → About → Name; Linux/WSL: `hostname -s`).
2. Create `bashfuncs/<computername>` with host-specific init only — conda init blocks, NVM init, welcome banner, machine-specific PATH additions. Anything portable should go in a generic module instead.
3. Add an `elif [ "$COMPUTERNAME" = "<computername>" ]` branch in `bashfuncs/macos` (or the hostname-check block in `bashfuncs/linux` / `bashfuncs/wsl`) that `dotsource`s it.

If a generic helper needs to differ by host (e.g. conda install path), prefer making the helper probe candidate paths over per-host shadowing — see how `bashfuncs/condas` and `bashfuncs/emacsd` iterate over `/opt/miniconda3`, `/opt/anaconda3`, `~/anaconda3`, `~/miniconda3`.
