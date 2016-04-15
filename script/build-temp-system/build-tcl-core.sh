#!/bin/bash

# using     : build tcl-core
# params    : none
# return    : 0 on successfull, 1 on error
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
# use util
source $script_dir/configuration.sh
source $script_dir/util.sh

# variables
package_name="tcl-core"
source_file="tcl-core8.6.4-src.tar.gz"
source_dir="tcl8.6.4"

# log start setup
log "$package_name.setup.start" 0

# change working directory to sources directory
cd $root_sources

# verify
if [ -f $source_file ]; then
    log "$package_name.verify" 0
else
    log "$package_name.verify" $?
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

# configure
log "$package_name.configure.start" 0
cd unix
./configure --prefix=/tools
log "$package_name.configure.finish" $?

# build
log "$package_name.make.start" 0
make
log "$package_name.make.finish" $?

# test
log "$package_name.test.start" 0
TZ=UTC make test
log "$package_name.test.finish" $?

# install
log "$package_name.install.start" 0
make install
log "$package_name.install.finish" $?

# make library writeable, so can removed later
chmod -v u+x /tools/lib/libtcl8.6.so
log "$package_name.lib.chmod" $?

# install tcl headers
log "$package_name.headers.install.start" 0
make install-private-headers
log "$package_name.headers.install.finish" $?

# link
ln -sv tclsh8.6 /tools/bin/tclsh
log "$package_name.link.finish" $?

# successfull
log "$package_name.setup.finish" $?
exit 0
