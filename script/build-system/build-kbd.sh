#!/bin/bash

# using     : build kbd
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
package_name="kbd"
source_file="kbd-2.0.3.tar.xz"
source_dir="kbd-2.0.3"

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

# path
patch -Np1 -i ../kbd-2.0.3-backspace-1.patch
log "$package_name.patch" $?

# remove the redundant
sed -i 's/\(RESIZECONS_PROGS=\)yes/\1no/g' configure &&
sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in
log "$package_name.redundant.remove" $?

# configure
log "$package_name.configure.start" 0
PKG_CONFIG_PATH=/tools/lib/pkgconfig ./configure \
   --prefix=/usr --disable-vlock
log "$package_name.configure.finish" $?

# build
log "$package_name.make.start" 0
make
log "$package_name.make.finish" $?

# test
log "$package_name.test.start" 0
make check
log "$package_name.test.finish" $?

# install
log "$package_name.install.start" 0
make install
log "$package_name.install.finish" $?

# install documents
mkdir -v       /usr/share/doc/kbd-2.0.3 &&
cp -R -v docs/doc/* /usr/share/doc/kbd-2.0.3
log "$package_name.doc.install" $?

# successfully
log "$package_name.setup.finish" $?
exit 0
