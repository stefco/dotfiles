#!/bin/bash
# (c) Stefan Countryman 2017
# Configure a MacOS machine just the way I like it

set -o errexit

log=provision-macos.out.log
errlog=provision-macos.err.log

logdate () {
    date | tee -a $log $errlog
}

echo "Checking for xcode command line tools and installing if necessary." \
    | tee -a $log
xcode-select --install || echo "xcode command line tools already installed."

echo "Checking for anaconda install." | tee -a $log
if ! type conda 1>/dev/null 2>&1 conda; then
    echo "Conda not found; please install miniconda first"
    exit 1
fi

echo "Creating emacs conda env"
conda create -n emacs
conda activate emacs
conda install -y python pip

# install latest brew
if ! type -f 1>/dev/null 2>&1 brew; then
    logdate
    echo "Installing HomeBrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "Updating path to include homebrew"
    eval `/usr/libexec/path_helper -s`
fi

logdate
echo "Installing tools." | tee -a $log
brew -f install >$log 2>$errlog \
    bash \
    coreutils \
    vim \
    neovim \
    curl \
    git \
    git-lfs \
    hdf5 \
    ffmpeg \
        +nonfree \
    ncdu \
    pstree \
    tree \
    readline \
    bash-completion@2 \
    poppler \
    djvulibre \
    jp2a \
    findutils \
    ripgrep \
    fzf \
    fd \
    imagemagick-full \
    cowsay \
    libcaca \
    fortune \
    shellcheck \
    qrencode \
    wget \
    tmux \
    tpm \
    heroku/brew/heroku \
# end
# install dotnet for C# LSP
brew install dotnet-sdk@8 mono
# install C++ mode deps
brew install llvm clang-format
brew tap railwaycat/emacsmacport
brew install --cask \
    font-gohufont-nerd-font \
    font-symbols-only-nerd-font \
    mactex \
    emacs-mac \
# end
# add the brew bash binary to the list of shells
bash -c "echo /opt/homebrew/bin/bash >>/etc/shells"
# MacVim
# mpv
# task
# vit
# youtube-dl
#    julia \
#    mc \
#    qt5-qtcreator \
#    emacs-mac-app \
#    emacs \
#    gforth \
#    libgcc9 \
#    aewan \
#    psutils \
#    tiff \
#    optipng \
#    OpenBLAS \
#    packer \
# FOR MUTT EMAIL:
#    msmtp \
#    offlineimap \
#    neomutt \
#    notmuch \

# install rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# install WGSL (WebGPU Shader Language) LSP support
cargo install --git https://github.com/wgsl-analyzer/wgsl-analyzer wgsl_analyzer

# install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash
nvm install 22

logdate
echo "Installing ffmpeg"
brew install pkg-config automake autoconf libtool fdk-aac
mkdir ~/dev
pushd ~/dev
git clone https://github.com/FFmpeg/FFmpeg.git
pushd FFmpeg
./configure \
  --enable-gpl \
  --enable-nonfree \
  --enable-libfdk-aac
make -j$(sysctl -n hw.ncpu)
make install
popd
popd

logdate
tee -a <<"__EOF__"
To set newest version of bash as default, run:

  chsh -s /opt/homebrew/bin/bash

Initialize git lfs with:

  git lfs install

Set up emacs magit forge for PR reviews with github.com using instructions at:

  https://docs.magit.vc/forge/Setup-for-Githubcom.html

__EOF__
