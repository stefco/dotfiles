#!/bin/bash
# (c) Stefan Countryman 2017
# link and copy things from the dotfiles folder.
# assumes dotfiles are in ~/dev/dotfiles.

# if "-f" flag is provided, overwrite everything
if [ "$1"z = -fz ]; then
    F=f
else
    F=""
fi

# these files should be symlinked
for rcfile in $(find linkfiles -iname '.*' -exec basename {} \; ); do
    if [ -L ~/"${rcfile}" ] || [ -e ~/"${rcfile}" ] && ! [ "$1"z = -fz ]; then
        echo "${rcfile} exists, skipping (delete to link it or use -f flag)"
    else
        echo "linking ${rcfile}..."
	ln -${F}s {dev/dotfiles/linkfiles,~}/"${rcfile}"
    fi
done

# for now, these files should be copied, since they will be populated with
# sensitive information (TODO: fix this with auto-redact git hooks)
for rcfile in $(find ~/dev/dotfiles/copyfiles -iname '.*' -exec basename {} \; ); do
    if [ -L ~/"${rcfile}" ] || [ -e ~/"${rcfile}" ] && ! [ "$1"z = -fz ]; then
        echo "${rcfile} exists, skipping (delete to copy it or use -f flag)"
    else
        echo "copying ${rcfile}..."
	cp -${F}R ~/{dev/dotfiles/copyfiles/,}"${rcfile}"
    fi
done
