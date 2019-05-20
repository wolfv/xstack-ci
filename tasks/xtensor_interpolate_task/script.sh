#!/bin/sh
set -e

export WORKDIR=`pwd`

apt update
apt install cmake g++ wget git -y

export CC=gcc
export CXX=g++

# install xtl
cd xtl
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=$WORKDIR/miniconda/
make install
cd $WORKDIR

# install xtensor
cd xtensor
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=$WORKDIR/miniconda/
make install -j$(nproc)
cd $WORKDIR

cd xtensor-interpolate
mkdir build
cd build

cmake .. -DDOWNLOAD_GTEST=ON -DCMAKE_INSTALL_PREFIX=$WORKDIR/miniconda/
make -j$(nproc)
./test/test_xtensor-fftw