#!/bin/bash

# using     : build lfs-bootscripts
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# libs
source $script_dir/configuration.sh
source $script_dir/util.sh

# veriables
package_name="sys.lfs-bootscripts"
source_file="../lfs-bootscripts-20150222.tar.bz2"
source_dir="lfs-bootscripts-20150222"

# step.verify
step_verify() {
    [ -f $source_file ]
}

# step.extract
step_extract() {
    tar -vxf $source_file
}

# step.install
step_install() {
    make install
}

# run
cd $root_system_sources
run_step "$package_name.verify" step_verify
run_step "$package_name.extract" step_extract
cd $source_dir
run_step "$package_name.install" step_install
exit 0
