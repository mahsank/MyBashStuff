#! /usr/bin/env bash

# This script counts total number of files in a given directory
# Version 0.1
# Author: M. Ahsan
# Last updated: 2018-04-03 23:42PM EEST


usage() {
    echo "Usage: $0 [directory-path]"
}

setpath() {
    if [ "$#" -ne 1 ]
    then
        echo "Directory path is needed."
        usage
        exit 1
    fi
}

checkdirexistence() {
    if [ ! -d "$1" ]
    then
        echo "Directory $1 does not exist."
        exit 1
    else
        DIRNAME="$1"
    fi
}

countfiles() {
    echo
    echo -n "Total number of files in $DIRNAME are:"
    find "${DIRNAME}" -type f | wc -l
    echo
}

setpath "$@"
checkdirexistence $1
countfiles
