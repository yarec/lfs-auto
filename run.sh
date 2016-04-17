#!/bin/bash

# using     : run docker and build lfs inside docker
# params    :
# author    : kevin.leptons@gmail.com

# locate locatin of this script
__dir__="$(dirname "$0")"
script_dir="$(readlink -f $__dir__/script)"

# find all bug of bash script
./find-bug.sh

# use configuration
# use util
source configuration.sh
source util.sh

# define variables
task_name="lfs-auto"
lfs_disk_path="disk/$lfs_disk_file"

# clear log file
# and log start run
clear_log
log "$task_name.start" 0

# prepare packages
./prepare-package.sh
exit_on_error

# prepare virtual disk
./prepare-disk.sh
exit_on_error

# build container
log "container.setup.start" 0
cd container
docker build -t $docker_name ./
log "container.setup.finish" $?
cd ..

# run docker
# mount hard disk use to build lfs into docker
# $root:root is mean <host-file-system>:<docker-file-system>
log "$task_name.docker.start" 0
docker run -ti --privileged -v $root:$root \
    -v $script_dir:$docker_script_dir $docker_name \
    bash /lfs-script/entry-lfs.sh
log "$task_name.docker.finish" $?

# successfull
log "$task_name.finish" $?
exit 0
