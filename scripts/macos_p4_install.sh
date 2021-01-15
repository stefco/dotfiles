#!/bin/bash

set -o errexit
set -o nounset

echo "Downloading P4 CLI for MacOS..."
url='https://www.perforce.com/downloads/perforce/r20.2/bin.macosx1015x86_64/helix-core-server.tgz'
echo "Installing P4 CLI to $HOME/bin ..."
tmp="`mktemp -d`"
cd "$tmp"
curl -L "$url" | tar -xz
mkdir -p ~/bin
mv p4* ~/bin
cd ~/bin
rm -rf "$tmp"
echo "Configuring P4 environment variables..."
sed <<<"$PATH" 's/\([^\]\):/\1\'$'\n/g' | grep -q ~/bin \
    || echo 'export PATH="$PATH":~/bin' >>~/.bash_profile
read -p "Enter the Perforce server and port (e.g. example.com:1666): " port
read -p "Enter your Perforce username: " uname
read -sp "Enter your Perforce password: " pword
echo
cat >>~/.bash_profile <<__EOF__
export P4PORT='$port'
export P4USER='$uname'
export P4PASSWD='$pword'
__EOF__
echo "DONE. Restart your terminal for changes to take effect."
