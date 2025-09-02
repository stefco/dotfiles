sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install \
    git \
    git-lfs \
    curl \
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

# install anaconda
curl -O https://repo.anaconda.com/archive/Anaconda3-2024.10-1-Linux-x86_64.sh
bash ~/Anaconda3-2024.10-1-Linux-x86_64.sh -b -p $HOME/anaconda3
source ~/anaconda3/bin/activate
conda create -n emacs
conda activate emacs
conda install -y python pip

# install dotnet for C# LSP
sudo apt install -y dotnet-sdk-8.0
sudo apt install -y mono-devel

# install C++ mode deps
sudo apt install -y clang clangd clang-format
sudo apt install -y glslang-dev glslang-tools

# install new emacs + doom
sudo snap install emacs --classic
git clone https://github.com/hlissner/doom-emacs ~/.emacs.d
~/.emacs.d/bin/doom install
~/.emacs.d/bin/doom sync

# install cargo
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# install WGSL (WebGPU Shader Language) LSP support
cargo install --git https://github.com/wgsl-analyzer/wgsl-analyzer wgsl_analyzer

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

