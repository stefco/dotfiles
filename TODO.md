# TODO

Some features I would like to add.

## Vim

- [ ] Add a nerdtree feature for previewing image files with imgcat

## Vim + IPython

- [ ] Add an async thread to ipython that listens for a file and runs it in
      ipython when it is written to, then appends output to it (or somehow
      alerts vim to the result)
- [ ] Add a vim binding that writes to a file that IPython is watching (easy)
- [ ] See if there is a way to print history on demand from vim for a given
      profile
- [ ] Use BFG to remove my email from dotfiles to make it marginally less easy
      for spammers to find my shit
- [ ] Add ipython profiles with some nice env checks to make em portable
- [ ] Add some vim features:
      - [ ] Add TeX-to-unicode
      - [ ] Add vim-orgmode, maybe
      - [ ] Add better python indentation
      - [ ] Add some markdown mode regexs for better indentation
- [ ] Add a CLI tool for managing my environment and dev repos
      - [ ] Should be able to do the following for dotfiles and ergodox using
            partial completion (only executes in unambiguous matching cases):
            - [ ] fetch (from origin)
            - [ ] pull (checkout latest)
            - [ ] cd (pushd to this directory)
            - [ ] status
            - [ ] diff
            - [ ] commit
            - [ ] push
            - [ ] save (add all changes, commit, and push)
            - [ ] clone
                  - [ ] try github by default
                  - [ ] try stefco by default
                  - [ ] try ssh by default, fall back to https on error
                  - [ ] can specify a full url
      - [ ] Should also be possible to specify files using globs
      - [ ] Add option to recursively act on git submodules
- [ ] Add a cronscripts directory
- [ ] Add software I use in a "dependencies" subdir as git submodules
