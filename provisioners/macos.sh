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
    bash mc ranger coreutils cowsay curl the_silver_searcher git git-lfs hdf5 \
    julia libcaca msmtp offlineimap vim ncdu neomutt notmuch OpenBLAS pstree \
    psutils tree readline dtrx fortune bash-completion poppler djvulibre \
    unrar tiff jp2a shellcheck p5.24-term-readline-gnu \
    findutils youtube-dl qrencode ripgrep optipng npm6 emacs-mac-app emacs
# add the MacPorts bash binary to the list of shells
bash -c "echo /opt/local/bin/bash >>/etc/shells"

logdate
echo "Installing python 2 stuff." | tee -a $log
port -f install >$log 2>$errlog \
    py27-ipython py27-numpy py27-matplotlib py27-scipy py27-healpy \
    py27-astropy py27-gnureadline py27-pykerberos py27-pygments py27-jupyter \
    py27-h5py py27-dateutil py27-cython py27-cairo py27-pip py27-pylint \
    py27-pyflakes py27-greenlet py27-neovim py27-gobject3 py27-pytest

logdate
echo "Installing python 3 stuff." | tee -a $log
port -f install >$log 2>$errlog \
    py36-ipython py36-numpy py36-matplotlib py36-scipy py36-healpy \
    py36-astropy py36-gnureadline py36-pykerberos py36-pygments py36-jupyter \
    py36-h5py py36-dateutil py36-cython py36-cairo py36-pip py36-pylint \
    py36-pyflakes py36-greenlet py36-neovim py36-gobject3 py36-pytest \
    py36-taskw py36-psutil

logdate
echo "Installing IceCube dependencies." | tee -a $log
port -f install >$log 2>$errlog \
    cmake boost +python27 gsl +doc_python27 hdf5 libarchive \
    qt5 py27-pyqt5 +graceful +webkit doxygen +docs +wizard wget # pal

logdate
echo "Setting default python, ipython, and pip binaries." | tee -a $log
port select --set python python36 >$log 2>$errlog
port select --set ipython py36-ipython >$log 2>$errlog
port select --set ipython3 py36-ipython >$log 2>$errlog
port select --set pip pip36 >$log 2>$errlog
port select --set pylint pylint36 >$log 2>$errlog
port select --set pyflakes py36-pyflakes >$log 2>$errlog

logdate
echo "Installing LIGO environment. Details here:" | tee -a $log
echo "  https://wiki.ligo.org/DASWG/MacPorts" | tee -a $log
port -f install >$log 2>$errlog \
    lscsoft-deps ligo-gracedb nds2-client +swig_java +swig_python glue \
    lalapps pylal ldas-tools-framecpp lalframe

logdate
echo "Installing GWpy dependencies. Details here:" | tee -a $log
echo "  https://gist.github.com/stefco/5956a92cfb4394255c637471334a7984" \
    | tee -a $log
port -f install >$log 2>$errlog \
    py27-ipython py27-numpy py27-scipy py27-matplotlib +latex +dvipng \
    texlive-latex-extra py27-astropy glue kerberos5 py27-pykerberos \
    nds2-client py27-lalframe py27-gwpy +gwf +hdf5 +nds2 +segments

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

echo "Installing pip packages." | tee -a $log
pip install \
    yolk PyForms itermplot ffmpeg-python untangle twilio visidata pytest-cov \
    jupyterlab task

logdate
tee -a <<"__EOF__"
To set newest version of bash as default, run:

  chsh -s /opt/local/bin/bash

You probably also want to install:

  - iTerm2 <https://www.iterm2.com/downloads.html>
  - Google Chrome <https://www.google.com/chrome/browser/desktop/index.html>
  - LibreOffice <https://www.libreoffice.org/download/download/>
  - k2pdfopt <http://willus.com/k2pdfopt/help/mac.shtml>
