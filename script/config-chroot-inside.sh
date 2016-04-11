#!/bin/bash

# using     : enter root user with chroot
# author    : kevin.leptons@gmail.com

# locate location of this script
cd /lfs-script
__dir__="$(dirname "$0")"

# use configuration
# use util
source $__dir__/configuration.sh
source $__dir__/util.sh

# define variables
task_name="config-chroot-inside"

# log start
log_auto "$task_name.start" 0

# config
touch /var/log/{btmp,lastlog,wtmp} &&
chgrp -v utmp /var/log/lastlog &&
chmod -v 664  /var/log/lastlog &&
chmod -v 600  /var/log/btmp
log_auto "$task_name.finish" $?