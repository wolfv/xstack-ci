#!/bin/sh
set -e

export WORKDIR=`pwd`

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install cmake g++ wget git gzip r-base-dev r-cran-devtools -y

export CC=gcc
export CXX=g++

# export MINICONDA_VERSION="latest"
# export MINICONDA_LINUX="Linux-x86_64"
# export MINICONDA_OSX="MacOSX-x86_64"

# wget "http://repo.continuum.io/miniconda/Miniconda3-$MINICONDA_VERSION-$MINICONDA_LINUX.sh" -O miniconda.sh;
# bash miniconda.sh -b -u -p $WORKDIR/miniconda
# export PATH="$WORKDIR/miniconda/bin:$PATH"
# hash -r
# conda config --set always_yes yes --set changeps1 no
# conda update -q conda
# conda install r r-rcpp r-base r-covr r-devtools ncurses readline -c conda-forge

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

Rscript -e 'install.packages("devtools", repos="http://cran.us.r-project.org")'
Rscript -e 'install.packages("covr", repos="http://cran.us.r-project.org")'
Rscript -e 'remotes::install_github("DavisVaughan/Xtensor.R", ref = "dev", force = TRUE)'
Rscript -e 'covr::codecov()'