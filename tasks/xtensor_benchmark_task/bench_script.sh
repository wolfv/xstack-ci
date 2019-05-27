#!/bin/sh
set -e

cd ~
export WORKDIR=`pwd`

sudo apt-get update
sudo apt-get install cmake g++ wget git ninja-build -y

export CC=gcc
export CXX=g++

# CONDA INSTALLATION

export MINICONDA_VERSION="latest"
export MINICONDA_LINUX="Linux-x86_64"
export MINICONDA_OSX="MacOSX-x86_64"

wget "http://repo.continuum.io/miniconda/Miniconda3-$MINICONDA_VERSION-$MINICONDA_LINUX.sh" -O miniconda.sh;
bash miniconda.sh -b -u -p $WORKDIR/miniconda
export PATH="$WORKDIR/miniconda/bin:$PATH"
hash -r
conda config --set always_yes yes --set changeps1 no
conda update -q conda
conda install pybind11 asv -c conda-forge

# SOME SYSTEM FIDDLING

sudo mount -t /dev/sdb /benchresults

mkdir -p ~/.ssh/

cat >> ~/.ssh/config <<EOL
Host gitkey.com
    Hostname github.com
    User git
    IdentityFile /benchresults/git_key
EOL

ssh-keyscan github.com >> ~/.ssh/known_hosts

# RUN THE BENCHMARKS

cd /benchresults

if [ ! -d "xtensor-asv" ]; then
    git clone git@gitkey.com:wolfv/xtensor-asv
fi

cd /benchresults/xtensor-asv

git pull origin master

asv run

asv gh-pages