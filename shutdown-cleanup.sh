#!/bin/bash

###############################################################################
# Service name:   shutdown-cleanup.sh
# Description:    An example shutdown cleanup script
# Author:         Brian Geis
# GitHub:         https://github.com/briangeis/systemd-shutdown-cleanup
# Copyright:      GNU General Public License v3.0
###############################################################################

# Output a message to systemd journal
echo Performing system cleanup...

# Creating a variable of the absolute path to the home directory
# as $HOME and ~/ will not work. Replace 'user' with your username.
HOMEDIR=/home/user

# Using the $HOMEDIR variable to backup the script and service we
# created in this tutorial to the Documents folder in our home directory.
cp --force /usr/local/bin/shutdown-cleanup.sh $HOMEDIR/Documents/
cp --force /etc/systemd/system/shutdown-cleanup.service $HOMEDIR/Documents/

# Deleting the thumbnail cache. Note how we are using the --force
# option for both the above cp command and this rm command. This
# will ensure the commands execute without ever prompting the user.
rm --recursive --force $HOMEDIR/.cache/thumbnails/*

# Suppress unwanted output to the systemd journal by directing
# it to /dev/null. By adding the '>/dev/null' to the end of this
# echo statement, the output will not appear in the journal.
echo Suppress the output from this command >/dev/null
