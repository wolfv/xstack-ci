#!/bin/sh
set -e

export WORKDIR=`pwd`

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install cmake g++ wget git gzip libcurl4-openssl-dev libssl-dev r-base-dev r-cran-devtools -y

export CC=gcc
export CXX=g++

export CI=true 

cd rray

git clone https://github.com/DavisVaughan/rray.git
cd rray

Rscript -e 'install.packages(c("remotes", "rcmdcheck"))'
Rscript -e 'remotes::install_github("DavisVaughan/Xtensor.R", ref = "dev", force = TRUE)'
Rscript -e 'remotes::install_deps(dependencies = TRUE)'
Rscript -e 'rcmdcheck::rcmdcheck(args = "--no-manual", error_on = "warning")'