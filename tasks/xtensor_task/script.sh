#!/bin/sh
set -e

export WORKDIR=`pwd`

apt update
apt install cmake g++ wget git rsync -y

export CC=gcc
export CXX=g++

rsync -a -H -X -A miniconda_xtl/ miniconda/

find miniconda/

export PATH="$WORKDIR/miniconda/bin:$PATH"


cd xtensor
mkdir build
cd build

cmake .. -DDOWNLOAD_GTEST=ON -DCMAKE_INSTALL_PREFIX=$WORKDIR/miniconda/
make xtest -j16
make install -j16