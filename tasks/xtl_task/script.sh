#!/bin/sh
set -e

apt update
apt install g++

export CC=gcc
export CXX=g++

export MINICONDA_VERSION="latest"
export MINICONDA_LINUX="Linux-x86_64"
export MINICONDA_OSX="MacOSX-x86_64"

wget "http://repo.continuum.io/miniconda/Miniconda3-$MINICONDA_VERSION-$MINICONDA_LINUX.sh" -O miniconda.sh;
bash miniconda.sh -b -u -p ./miniconda
export PATH="./miniconda/bin:$PATH"
hash -r
conda config --set always_yes yes --set changeps1 no
conda update -q conda gtest=1.8.0 cmake -c conda-forge
conda install nlohmann_json -c QuantStack

cd xtl
mkdir build
cd build

cmake .. -DDOWNLOAD_GTEST=ON -DCMAKE_INSTALL_PREFIX=../miniconda/