#!/bin/sh
set -e

export WORKDIR=`pwd`

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install cmake g++ wget git gzip r-base-dev r-cran-devtools -y

# Required for curl package
apt-get install libcurl4-openssl-dev -y

# Required for openssl package
apt-get install libssl-dev -y

# Required for R CMD check setting to en_US.UTF-8 locale
apt-get install locales -y

# Set default locale, as done with rocker/r-base
# https://hub.docker.com/r/rocker/r-base/dockerfile
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
	&& locale-gen en_US.utf8 \
	&& /usr/sbin/update-locale LANG=en_US.UTF-8

export CC=gcc
export CXX=g++

# To use bundled remotes GitHub PAT
export CI=true 

cd rray

# Clone rray and move to its directory
git clone https://github.com/DavisVaughan/rray.git
cd rray

Rscript -e 'install.packages(c("remotes", "rcmdcheck"))'

# Always forcibly install development versions of xtensor-r and xtensor
Rscript -e 'remotes::install_github("DavisVaughan/Xtensor.R", ref = "dev", force = TRUE)'

# Install all other rray dependency packages
Rscript -e 'remotes::install_deps(dependencies = TRUE)'

# Build and check!
Rscript -e 'rcmdcheck::rcmdcheck(args = "--no-manual", error_on = "warning")'