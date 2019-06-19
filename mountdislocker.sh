#!/usr/bin/env bash
# This script finds and mounts all the windows bitlocker partitions in Linux.
# The motivation comes from the fact that I have certain number of partitions
# whom I need to access in Linux. Mounting these partitions manually every time
# Linux starts is cumbersome hence I decided to automate the process and wrote
# the script below. The script is tested on Fedora 30 and is expected to work
# on other distributions as well though no guarantees are provided.
# Author: Muhammad Ahsan
# Last updated: 2019-06-19 10:50 PM EEST


set -xv

if [ $UID -ne 0 ]
then
    echo "Script needs to run with root privileges preferably with sudo."
    exit 1
fi

usage()
{
    echo "Usage: $0 \"<Bitlocker_Password>\"" 2>&1
    exit
}

checkargs()
{
    if [ "$#" -ne 1 ]
    then
        echo "Decryption password is required."
        usage
        exit 1
    fi
}

checkcmds()
{
    CMDS="lsblk grep awk mkdir dislocker-fuse mount"
    for i in $CMDS
    do
        if [ ! -x "/bin/$i" ]
        then
            echo "Command $i not found in the path."
            echo "Cannot continue."
            exit 1
        fi
    done
}

unlockpartitions()
{
    # count bitlocked partitions
    PARTNUMS=$(/bin/lsblk -lf | /bin/grep -i bitlocker | /bin/awk -vORS=' '  '{print $1}' )

    # mount bitlocker partitions
    if [ -n "$PARTNUMS" ]
    then
        PASSWORD=$1
        #echo $PASSWORD
        #echo $PARTNUMS
        Uid=$(stat -c '%u' $PWD)
        Gid=$(stat -c '%g' $PWD)
        for i in $PARTNUMS
        do
            if [ ! -d $PWD/Disks/$i -a ! -d /tmp/$i ]
            then
                    mkdir -p $PWD/Disks/$i /tmp/$i
            fi
            dislocker-fuse -vV /dev/$i -u"$PASSWORD" -- /tmp/$i
            mount -o umask=0022,gid=$Gid,uid=$Uid /tmp/$i/dislocker-file ${PWD}/Disks/$i/
            sleep 5
        done
    else
        echo "No bitlocker based partition found!"
        echo "exiting!"
        exit 1
    fi
}

# function calling
checkargs "$@"
checkcmds
unlockpartitions "$@"

