#!/bin/bash

# using     : create status build
# author    : kevin.leptons@gmail.com

# libs
source util.sh

# variables
task_name="sys.build-status.config"

config_build_status() {
    # create /etc/lfs-release
    echo 7.8 > /etc/lfs-release

    # create /etc/lsb-release
    cp -vp /lfs-script/asset/etc.lsb-release /etc/lsb-release
}

run_step "$task_name" config_build_status
