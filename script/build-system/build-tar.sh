#!/bin/bash

# using     : build tar
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


# variables
package_name="tar"
source_file="tar-1.28.tar.xz"
source_dir="tar-1.28"

# change working directory to sources directory
cd /sources

# verify
if [ -f $source_file ]; then
    log_auto "$package_name.verify" 0
else
    log_auto "$package_name.verify" 1
fi

# extract source code and change to source directory
if [ -d $source_dir ]; then
    log_auto "$package_name.extract.idle" 0
else
    log_auto "$package_name.extract.start" 0
    tar -vxf $source_file
    log_auto "$package_name.extract.finish" $?
fi
cd $source_dir

# configure
log_auto "$package_name.configure.start" 0
FORCE_UNSAFE_CONFIGURE=1  \
./configure --prefix=/usr \
   --bindir=/bin
log_auto "$package_name.configure.finish" $?

# build
log_auto "$package_name.make.start" 0
make
log_auto "$package_name.make.finish" $?

# test
log_auto "$package_name.test.start" 0
make check
log_auto "$package_name.test.finish" $?

# install
log_auto "$package_name.install.start" 0
make install &&
make -C doc install-html docdir=/usr/share/doc/tar-1.28
log_auto "$package_name.install.finish" $?

# successfully
log_auto "$package_name.setup.finish" $?
exit 0
