#!/bin/bash
# (c) Stefan Countryman 2017
# Configure a MacOS machine just the way I like it

set -o errexit

log=provision-macos.out.log
errlog=provision-macos.err.log

logdate () {
    date | tee -a $log $errlog
}

if ! type -f 1>/dev/null 2>&1 port; then
    echo "Error: MacPorts must be installed to proceed. Get it from:"
    echo "  https://www.macports.org/install.php"
    echo "Exiting."
    exit 1
fi

echo "Checking for xcode command line tools and installing if necessary." \
    | tee -a $log
xcode-select --install || echo "xcode command line tools already installed."

logdate
echo "Updating MacPorts. If you didn't run this script as root, it'll fail." \
    | tee -a $log
port selfupdate >$log 2>$errlog

logdate
echo "Installing tools." | tee -a $log
port -f install >$log 2>$errlog \
    bash \
    coreutils \
    vim \
    curl \
    the_silver_searcher \
    ack \
    git \
    git-lfs \
    hdf5 \
    ffmpeg \
        +nonfree \
    msmtp \
    offlineimap \
    ncdu \
    neomutt \
    notmuch \
    pstree \
    psutils \
    tree \
    readline \
    bash-completion \
    poppler \
    djvulibre \
    unrar \
    tiff \
    jp2a \
    findutils \
    youtube-dl \
    ripgrep \
    optipng \
    ImageMagick \
    latexmk \
    OpenBLAS \
    packer \
    cowsay \
    mc \
    julia \
    libcaca \
    fortune \
    shellcheck \
    p5.24-term-readline-gnu \
    qrencode \
    npm6 \
    emacs-mac-app \
    emacs \
    MacVim \
    task \
    vit \
# end
# add the MacPorts bash binary to the list of shells
bash -c "echo /opt/local/bin/bash >>/etc/shells"

logdate
echo "Installing python 2 stuff." | tee -a $log
port -f install >$log 2>$errlog \
    py27-ipython \
    py27-numpy \
    py27-matplotlib \
        +latex \
        +dvipng \
    py27-scipy \
    py27-healpy \
    py27-astropy \
    py27-gnureadline \
    py27-pykerberos \
    py27-pygments \
    py27-jupyter \
    py27-h5py \
    py27-dateutil \
    py27-cython \
    py27-cairo \
    py27-pip \
    py27-pylint \
    py27-pyflakes \
    py27-greenlet \
    py27-neovim \
    py27-gobject3 \
    py27-pytest \
    py27-psutil \
    py27-pytest-cov \
    py27-jupyterlab \
# end

logdate
echo "Installing python 3 stuff." | tee -a $log
port -f install >$log 2>$errlog \
    py37-ipython \
    py37-numpy \
    py37-matplotlib \
    py37-scipy \
    py37-healpy \
    py37-astropy \
    py37-gnureadline \
    py37-pykerberos \
    py37-pygments \
    py37-jupyter \
    py37-h5py \
    py37-dateutil \
    py37-cython \
    py37-cairo \
    py37-pip \
    py37-pylint \
    py37-pyflakes \
    py37-greenlet \
    py37-neovim \
    py37-gobject3 \
    py37-pytest \
    py37-taskw \
    py37-psutil \
    py37-pytest-cov \
    py37-jupyterlab \
# end

logdate
echo "Installing IceCube dependencies." | tee -a $log
port -f install >$log 2>$errlog \
    cmake \
    boost \
        +python27 \
    gsl \
        +doc_python27 \
    hdf5 \
    libarchive \
    qt5 \
    py27-pyqt5 \
        +graceful \
        +webkit \
    doxygen \
        +docs \
        +wizard \
    wget \
    # pal \
# end

logdate
echo "Setting default python, ipython, and pip binaries." | tee -a $log
port select --set python python37 >$log 2>$errlog
port select --set ipython py37-ipython >$log 2>$errlog
port select --set ipython3 py37-ipython >$log 2>$errlog
port select --set pip pip37 >$log 2>$errlog
port select --set pylint pylint37 >$log 2>$errlog
port select --set pyflakes py37-pyflakes >$log 2>$errlog

logdate
echo "Installing LIGO environment. Details here:" | tee -a $log
echo "  https://wiki.ligo.org/Computing/DASWG/MacPorts" | tee -a $log
port -f install >$log 2>$errlog \
    lscsoft-deps \
    ligo-gracedb \
    nds2-client \
        +swig_java \
        +swig_python \
    glue \
    lalapps \
    pylal \
    ldas-tools-framecpp \
    lalframe \
# end

logdate
echo "Installing GWpy dependencies. Details here:" | tee -a $log
echo "  https://gist.github.com/stefco/5956a92cfb4394255c637471334a7984" \
    | tee -a $log
port -f install >$log 2>$errlog \
    py27-ipython \
    py27-numpy \
    py27-scipy \
    py27-matplotlib \
        +latex \
        +dvipng \
    texlive-latex-extra \
    py27-astropy \
    glue \
    kerberos5 \
    py27-pykerberos \
    nds2-client \
    py27-lalframe \
    py27-gwpy \
        +gwf \
        +hdf5 \
        +nds2 \
        +segments \
# end

logdate
echo "Installing LaTeX packages." | tee -a $log
port -f install >$log 2>$errlog texlive-publishers

logdate
echo "Installing GWpy with all options. Details here:" | tee -a $log
echo "  https://gwpy.github.io/docs/stable/install/index.html" | tee -a $log
pip install gwpy[all] >$log 2>$errlog

echo "Installing jupyter extensions." | tee -a $log
jupyter labextension install \
    jupyterlab_vim
logdate

echo "Installing MEDM screens. Details here:" | tee -a $log
echo "  https://wiki.ligo.org/RemoteAccess/RemoteEPICS" | tee -a $log
sudo port install -f xorg-libXt +flat_namespace
sudo port install -f ligo-remote-access
logdate

echo "Installing pip packages for python 2 and 3." | tee -a $log
for PIP in pip2 pip3; do
    $PIP install \
        PyForms \
        itermplot \
        ffmpeg-python \
        untangle \
        twilio \
        visidata \
        svgutils \
        svglib \
        reportlab \
# end
done

logdate
tee -a <<"__EOF__"
To set newest version of bash as default, run:

  chsh -s /opt/local/bin/bash

To get LIGO Data Grid access, run the installer found at:

  - https://www.lsc-group.phys.uwm.edu/lscdatagrid/doc/installclient-mac.html

You probably also want to install:

  - iTerm2 <https://www.iterm2.com/downloads.html>
  - Google Chrome <https://www.google.com/chrome/browser/desktop/index.html>
  - LibreOffice <https://www.libreoffice.org/download/download/>
  - k2pdfopt <http://willus.com/k2pdfopt/help/mac.shtml>
