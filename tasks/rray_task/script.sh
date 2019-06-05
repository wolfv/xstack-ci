#!/bin/sh
set -e

export WORKDIR=`pwd`

export DEBIAN_FRONTEND=noninteractive


# libcurl4-openssl-dev required for curl package
# libssl-dev required for openssl package
# locales required for R CMD check setting to en_US.UTF-8 locale
apt-get update
apt-get install -y cmake g++ wget git gzip r-base-dev r-cran-devtools \
				   libcurl4-openssl-dev libssl-dev locales

# Set default locale, as done with rocker/r-base
# https://hub.docker.com/r/rocker/r-base/dockerfile
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
	&& locale-gen en_US.utf8 \
	&& /usr/sbin/update-locale LANG=en_US.UTF-8

# More R CMD check locale variables
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export CC=gcc
export CXX=g++

# To use bundled remotes GitHub PAT
export CI=true 

cd rray

Rscript -e 'install.packages(c("remotes", "rcmdcheck"))'

# Always forcibly install development versions of xtensor-r and xtensor
Rscript -e 'remotes::install_github("DavisVaughan/Xtensor.R", ref = "dev", force = TRUE)'

# Install all other rray dependency packages
Rscript -e 'remotes::install_deps(dependencies = TRUE)'

# Build and check!
Rscript -e 'rcmdcheck::rcmdcheck(args = "--no-manual", error_on = "warning")'