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

# install deps for emacs build
sudo apt install -y \
    build-essential \
    autoconf \
    automake \
    libtool \
    texinfo \
    pkg-config \
    make \
    ;

# install deps for emacs build features
sudo apt install -y \
    libgtk-3-dev \
    libcairo2-dev \
    libharfbuzz-dev \
    librsvg2-dev \
    libgnutls28-dev \
    libxml2-dev \
    libsqlite3-dev \
    libgif-dev \
    libtiff-dev \
    libjpeg-dev \
    libpng-dev \
    libtree-sitter-dev \
    ;

# find supported GCC native compilation version for emacs
LIBGCCJIT_VERSION="$(apt-cache search libgccjit- | sed -n 's/libgccjit-\([0-9]*\)-dev.*$/\1/p' | sort -nr | head -1)"
if [ -z $LIBGCCJIT_VERSION ]; then
    echo >&2 "COULD NOT FIND LIBGCCJIT, EXITING"
    exit 1
fi
sudo apt install -y libgccjit-"${LIBGCCJIT_VERSION}"-dev gcc-"${LIBGCCJIT_VERSION}"
export CC=gcc-"${LIBGCCJIT_VERSION}"  # use same gcc for emacs build as libgccjit version
# Workaround for v12 on debian 22.04; normally should just figure it out with the .pc config file
export LIBGCCJIT_CFLAGS="-I/usr/lib/gcc/x86_64-linux-gnu/{$LIBGCCJIT_VERSION}/include"
export LIBGCCJIT_LIBS="-L/usr/lib/gcc/x86_64-linux-gnu/${LIBGCCJIT_VERSION} -lgccjit"

# get emacs 30.1 source
mkdir -p ~/dev
pushd ~/dev
git clone https://git.savannah.gnu.org/git/emacs.git --depth 1 --branch emacs-30.1
pushd emacs
./autogen.sh
mkdir -p build && pushd build
../configure \
    --prefix=/usr/local \
    --with-pgtk \
    --with-native-compilation \
    --with-tree-sitter \
    --with-modules \
    --with-cairo \
    --disable-gc-mark-trace \
    --without-x \
    ;
# build
make -j"$(nproc)"
sudo make install
hash -r  # refresh shell's command cache
popd
popd
popd

# make emacs window have minimize/maximize/close buttons
gsettings set org.gnome.desktop.wm.preferences button-layout ':minimize,maximize,close'

# add icons for emacs
pushd ~/dev/emacs
for size in 16 24 32 48 128; do
    sudo install -Dm644 \
        etc/images/icons/hicolor/${size}x${size}/apps/emacs.png \
        /usr/local/share/icons/hicolor/${size}x${size}/apps/emacs.png
done
sudo install -Dm644 etc/emacs.desktop /usr/local/share/applications/emacs.desktop
#sudo update-desktop-database /usr/local/share/applications
#sudo gtk-update-icon-cache /usr/local/share/icons/hicolor

# install emacs with snap
# sudo snap install emacs --classic

# install new doom for emacs
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

