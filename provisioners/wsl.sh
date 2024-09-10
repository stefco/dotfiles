sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install \
    gcc \
    g++ \
    neovim \
    fd-find \
    python3 \
    unzip \
    fzf \
    ripgrep
mkdir -p ~/.local/bin
ln -s "$(which fdfind)" ~/.local/bin/fd
git clone https://github.com/NvChad/NvChad ~/.config/nvchad --depth 1
git clone https://github.com/LazyVim/starter ~/.config/lazyvim --depth 1
mkdir ~/.tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# install dotnet for C# LSP
sudo apt install -y dotnet-sdk-8.0
sudo apt install -y mono-devel

# install new emacs + doom
sudo snap install emacs --classic
git clone https://github.com/hlissner/doom-emacs ~/.emacs.d
~/.emacs.d/bin/doom install
~/.emacs.d/bin/doom sync

cat <<__EOF__
YOU'LL STILL HAVE TO RUN THE FOLLOWING TO GET DOOM EMACS FULLY WORKING:
# install fonts for unicode
M-x emacs --batch -f nerd-icons-install-fonts
$ fc-cache -f -v

# install GitHub Copilot for emacs
#   https://github.com/copilot-emacs/copilot.el
M-x copilot-install-server

# create a GitHub classic auth token for emacs magit/forge (PRs) with 'repo',
# 'user', and 'read:org' permissions
#   https://github.com/settings/tokens
#   https://magit.vc/manual/forge/Token-Creation.html#Token-Creation
# and store in ~/.authinfo.gpg
#   https://www.emacswiki.org/emacs/GnusAuthinfo
$ gpg --quick-generate-key "My Name <my@email.address>"
$ echo 'machine api.github.com login stefco^forge password <...>' >.authinfo
M-x epa-encrypt-file  ;; input ~/.authinfo and choose your key
__EOF__

