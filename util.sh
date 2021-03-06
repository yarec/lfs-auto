#!/bin/bash

# using     : contains util functions
# author    : kevin.leptons@gmail.com

# variables
log_file=log/process.log

# create directory to store log file
mkdir -vp log

# using     : current time by format
# return    : date time string format by %Y-%m-%d %H:%M:%S
current_time() {
    echo $(date +"%Y-%m-%d %H:%M:%S")
}

# write information into file and console
# log file in ./log/process.log
# prams:
#   $1: message
#   $2: result in enum { true, false }. true is successfull, false is error
# return: 0 on successfull, 1 on error
log() {

    # get time
    log_time=$(current_time)

    # convert result
    result="?"

    if [[ $2 == 0 ]]; then
        result="ok"
    else
        result="no"
    fi

    # log to file
    printf "%s\n" "$log_time" >> "$log_build_file"
    printf "%-78s%2s\n\n" "$1" "$result" >> "$log_build_file"

    # log to console
    printf "%s\n" "$log_time"
    printf "%-78s%2s\n\n" "$1" "$result"

    # exit if error
    if [[ $2 != 0 ]]; then
        exit 1
    fi

    # successfull
    return 0
}

# clear log file
# log file in ./log/process.log
# return: 0 on successfull, 1 on error
clear_log() {

    if [ -f $log_file ]; then
        > $log_file
    fi

    # check error
    if [[ $? != 0 ]]; then
        return 1
    fi

    # successfull
    return 0
}

# exit process when error
# params:
#   $1: exit code
exit_on_error() {
    if [[ $? != 0 ]]; then
        exit 1
    fi
}

# escape string
# params
#   $1: string to escape
# stdout
#   string escaped
escape_str() {
    echo $1 | sed -e 's/[]\/$*.^|[]/\\&/g'
}
