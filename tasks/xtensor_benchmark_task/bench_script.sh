#!/bin/sh
set -e -v

cd ~
export WORKDIR=`pwd`

# SOME SYSTEM FIDDLING
sudo mkdir /benchresults
sudo mount -t ext4 /dev/sdb /benchresults

mkdir -p ~/.ssh/

cat >> ~/.ssh/config <<EOL
Host gitkey.com
    Hostname github.com
    User git
    IdentityFile /benchresults/git_key
EOL


# install requirements
sudo apt-get update
sudo apt-get install cmake g++ wget git ninja-build -y

# add github to known hosts
ssh-keyscan github.com >> ~/.ssh/known_hosts

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

# RUN THE BENCHMARKS

cd /benchresults

if [ ! -d "xtensor-asv" ]; then
    git clone git@gitkey.com:wolfv/xtensor-asv
fi

cd /benchresults/xtensor-asv

git config --global user.email "benchmachineV1@quantstack.net"
git config --global user.name "Benchmachine V1"

git pull origin master
git fetch -u origin gh-pages:gh-pages -f

asv machine --yes

if [ $1 ]; then
	git clone https://github.com/QuantStack/xtensor ~/check_xtensor_versions
	python3 scripts/get_historical_tags.py ~/check_xtensor_versions $1 > tags.txt
	cat tags.txt
	sh loop_tags.sh tags.txt
else
	asv run
fi;
asv gh-pages