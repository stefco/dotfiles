#!/bin/sh
# (c) Stefan Countryman 2020
# Configure a debian machine... just the way i like it.....

set -o errexit

log=provision-deb.out.log
errlog=provision-deb.err.log

logdate () {
	date | tee -a $log $errlog
}

logdate
apt-get -y update >>$log 2>>$errlog
logdate
apt-get -yf install >>$log 2>>$errlog\
        cargo \
        software-properties-common \
        texlive \
        psmisc \
        procps \
        ca-certificates \
        curl \
        bzip2 \
        vim \
        git \
        graphviz \
        htop \
        ncdu \
        ssh-client \
        certbot \
# END

logdate
echo Fetching LIGO DataGrid install script...
curl \
    -o ~/ldg-client.sh \
    https://computing.docs.ligo.org/lscdatagridweb/doc/ldg-client.sh
echo 'ldg-client.sh contents:'
cat ~/ldg-client.sh
echo Installing LIGO DataGrid
bash -c '
    v=1;
    count=1;
    until [ $v -eq 0 ]; do
        if [ $count -gt 5 ]; then
            echo "FIVE FAILED LDG INSTALL ATTEMPTS. GIVING UP!";
            exit 1;
        fi;
        echo "LDG INSTALLATION ATTEMPT: $count";
        bash ~/ldg-client.sh;
        v=$?;
        count=$((count+1));
    done
'
rm -rf /var/lib/apt/lists/*

logdate
echo "Installing conda"
curl https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh >~/anaconda.sh
head -50 ~/anaconda.sh
bash ~/anaconda.sh -b -f -p ~/miniconda3
rm ~/anaconda.sh
~/miniconda3/bin/conda update conda
~/miniconda3/bin/conda config --set channel_priority strict
~/miniconda3/bin/conda update --all
~/miniconda3/bin/conda config --add channels conda-forge
echo 'export PATH=~/miniconda3/bin:"$PATH"' >/etc/profile.d/conda.sh
~/miniconda3/bin/conda clean -y --all

echo "Done."

logdate
echo "Installing GitHub CLI..."
apt-key adv --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0
apt-add-repository https://cli.github.com/packages
apt update
apt install gh
