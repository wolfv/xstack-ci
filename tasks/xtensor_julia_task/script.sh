#!/bin/sh
set -e

export WORKDIR=`pwd`

apt update
apt install cmake g++ git -y

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
make install -j$(nprocs)
cd $WORKDIR

# test xtensor-julia

julia -E "using Pkg; Pkg.add(PackageSpec(name=\"CxxWrap\", version=\"0.8.1\"))"
echo "CxxWrap Installed"
export JlCxx_DIR=$(julia -E "using CxxWrap; joinpath(dirname(pathof(CxxWrap)), \"..\", \"deps\", \"usr\", \"lib\", \"cmake\", \"JlCxx\")")

# removing double quotes with JlCxx_DIR=${JlCxx_DIR//\"/} doesn't work with
# that potato-shell in debian, so using `tr` here
export JlCxx_DIR=`echo $JlCxx_DIR | tr -d '"'`

cd xtensor-julia
mkdir build
cd build
cmake .. -DDOWNLOAD_GTEST=ON -DJlCxx_DIR=$JlCxx_DIR -DCMAKE_INSTALL_PREFIX=$WORKDIR/miniconda/
make xtest -j$(nprocs)
