#!/bin/bash

# using     : build grub
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
package_name="grub"
source_file="grub-2.02~beta2.tar.xz"
source_dir="grub-2.02~beta2"

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

# configure
log "$package_name.configure.start" 0
./configure --prefix=/usr          \
   --sbindir=/sbin        \
   --sysconfdir=/etc      \
   --disable-grub-emu-usb \
   --disable-efiemu       \
   --disable-werror
log "$package_name.configure.finish" $?

# build
log "$package_name.make.start" 0
make
log "$package_name.make.finish" $?

# install
log "$package_name.install.start" 0
make install
log "$package_name.install.finish" $?

# successfully
log "$package_name.setup.finish" $?
exit 0
