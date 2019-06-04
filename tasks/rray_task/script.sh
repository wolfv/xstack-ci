#!/bin/sh
set -e

export WORKDIR=`pwd`

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install cmake g++ wget git gzip r-base-dev r-cran-devtools -y

export CC=gcc
export CXX=g++

cd rray

git clone https://github.com/DavisVaughan/rray.git

Rscript -e 'remotes::install_github("DavisVaughan/Xtensor.R", ref = "dev", force = TRUE)'
Rscript -e 'devtools::install_dev_deps()'
R CMD build rray --no-manual
R CMD check rray_0.0.0.9000.tar.gz --as-cran