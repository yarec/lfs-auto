#!/bin/bash

# using     : build binutils
# params    : none
# return    : 0 on success, 1 on error
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
# use util
source $script_dir/configuration.sh
source $script_dir/util.sh

# define variables
package_name="binutils"
source_file="binutils-2.25.1.tar.bz2"
source_dir="binutils-2.25.1"
build_dir="binutils-build"

# log start
log "$package_name.setup.start" 0

# change working directory to sources directory
cd /sources

# verify
if [ -f $source_file ]; then
    log "$package_name.verify" 0
else
    log "$package_name.verify" 1
fi

# extract source code and change to source directory
if [ -d $source_dir ]; then
    log "$package_name.extract.idle" 0
else
    log "$package_name.extract.start" 0
    tar -vxf $source_file
    log "$package_name.extract.finish" $?
fi
cd $source_dir

# verify that ptys are workig
expect -c "spawn ls"
log "ptys.verify" $?

# create build directory
cd ../
rm -rfv $build_dir
mkdir -v $build_dir
cd $build_dir

# configure
log "$package_name.configure.start" 0
../binutils-2.25.1/configure --prefix=/usr   \
   --enable-shared \
   --disable-werror
log "$package_name.configure.finish" $?

# build
log "$package_name.make.start" 0
make tooldir=/usr
log "$package_name.make.finish" $?

# test
log "$package_name.test.start" 0
make check
log "$package_name.test.finish" $?

# install
log "$package_name.install.start" 0
make tooldir=/usr install
log "$package_name.install.finish" $?

# successfully
log "$package_name.setup.finish" $?
exit 0
