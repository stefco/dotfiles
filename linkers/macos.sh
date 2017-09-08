#!/bin/bash
# (c) Stefan Countryman 2017
# link and copy things from the dotfiles folder.
# assumes dotfiles are in ~/dev/dotfiles.

cd ~

# these files should be symlinked
for rcfile in .bashrc .vimrc .tmux.conf .muttrc .mailrc .gitignore_global .inputrc; do
    if [ -e "${rcfile}" ]; then
        echo "${rcfile} exists, skipping (delete and rerun to link it)"
    else
        echo "linking ${rcfile}..."
        ln -s {dev/dotfiles/,}"${rcfile}"
    fi
done

# for now, these files should be copied, since they will be populated with
# sensitive information (TODO: fix this with auto-redact git hooks)
for rcfile in .pypirc .gitconfig .msmtprc .offlineimaprc; do
    if [ -e "${rcfile}" ]; then
        echo "${rcfile} exists, skipping (delete and rerun to recopy it)"
    else
        echo "copying ${rcfile}..."
        cp {dev/dotfiles/,}"${rcfile}"
    fi
done
