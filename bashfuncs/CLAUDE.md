# bashfuncs

Bash modules sourced from `~/.bashrc` via the `dotsource` helper. Each file is a self-contained unit; they're loaded in a specific order (see `linkfiles/.bashrc`).

## `dotsource` and provenance tracking

`dotsource foo bar baz` sources `bashfuncs/foo`, `bashfuncs/bar`, `bashfuncs/baz` and records which functions and aliases came from each file in two associative arrays:

- `_func_sources[<funcname>]` → path of the file that first defined it
- `_alias_sources[<alias>]` → path of the file that first defined it

Useful when debugging "where did this function come from?" — e.g. `echo "${_func_sources[emacsd]}"`. If a later file overrides a function, the *first* source wins in the map (by design — you usually want to know where the original came from, not the last override).

`dotlist` (defined in `.bashrc`) prints `ls ~/dev/dotfiles/bashfuncs` — a quick way to see what's available to dotsource.

## Naming convention

Files fall into four buckets:

1. **OS-branch files** — one per OS, always dotsourced first from `.bashrc`:
   - `macos`, `linux`, `wsl`
2. **Per-host files** — named after the machine's `ComputerName` (macOS) or `hostname` (Linux/WSL). Dotsourced from the OS-branch file after a hostname check:
   - `motoko`, `melchior` (macOS hosts)
   - others referenced inline in `wsl`, `linux`
3. **Functional modules** — named after the main function or feature they provide. Dotsourced unconditionally from `.bashrc`:
   - `emacsd`, `emc`, `emacsg`, `condas`, `pathinit`, `path`, `navigate`, `aliases`, `colors`, `promptline`, `iterm`, `sessiontype`, `tokens`, `cpln`, `vimex`, …
4. **Network/org-specific files** — only dotsourced when a specific hostname pattern matches:
   - `uwm` (University of Wisconsin–Milwaukee LIGO dev hosts)
   - `fulab` (loaded from `motoko` only)

## Load order

Exact order in `linkfiles/.bashrc` (skip comments):

1. OS branch: `macos` → per-host (via `ComputerName`) → `emacsg opent` (macOS only). Or: `linux` → `wsl` + `open` (WSL only).
2. `emacsd`, `emc` — Emacs daemon tooling (needed everywhere).
3. `sessiontype`, `tokens`, `colors`, `iterm`, `pathinit`, `navigate`, `aliases`, `promptline`, `condas`.
4. Grab-bag: `path`, `cpln`, `vimex`.
5. `uwm` — only if `hostname -f` matches the UWM pcdev pattern.

## Adding a new per-host file

```bash
# 1. Create the file
cat > ~/dev/dotfiles/bashfuncs/newhost <<'EOF'
#!/bin/bash
# Host-specific init for `newhost`.
# e.g. conda init block, nvm init, welcome banner.
EOF

# 2. Wire it into the OS-branch file (bashfuncs/macos for macOS):
#   elif [ "$COMPUTERNAME" = "newhost" ]; then
#       dotsource newhost
```

Host-specific files should contain only things that truly differ between hosts:

- `conda init` blocks (these reference a specific install path, which varies — but prefer calling `condas` on demand; see below).
- NVM setup (install path varies).
- Host-specific PATH additions.
- Welcome banner.

Things that should **not** go in a per-host file: anything derivable or portable. If a helper function needs to know about multiple possible paths, make it probe candidates (see `condas`, `emacsd`) rather than having a different version per host.

## Conventions worth knowing

- **Subshell semantics.** `dotsource` runs `source`, so everything runs in the current shell. But helpers that spawn daemons (e.g. `emacsd`) use a subshell `( … )` to contain `conda activate` / `nvm use` side effects. Functions defined in the parent shell are **not** inherited by the subshell — path lookups must be reconstructed (this is why `emacsd` probes conda roots itself rather than assuming `conda` is a callable function).
- **`CONDAS=1`** — set by `condas` (and honored by motoko's `llamas` helper) to avoid re-running the conda shell hook unnecessarily.
- **Alias sourcing.** If you want an alias to be attributed to your file by `record_alias_source`, define it in the file — don't define it inside a function that is later called.
- **Don't rely on global ordering.** If your file needs something from another file (e.g. color variables from `colors`), state the dependency in a comment; don't assume load order except for OS branch → per-host.
