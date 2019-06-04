#!/bin/sh
set -e

export WORKDIR=`pwd`

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install cmake g++ wget git gzip r-base-dev r-cran-devtools -y

export CC=gcc
export CXX=g++

cd rray
Rscript -e 'install.packages("remotes", repos="http://cran.us.r-project.org")'
Rscript -e 'remotes::install_github("DavisVaughan/Xtensor.R", ref = "dev", force = TRUE)'
Rscript -e 'remotes::install_github("DavisVaughan/rray")'
Rscript -e 'devtools::check()'