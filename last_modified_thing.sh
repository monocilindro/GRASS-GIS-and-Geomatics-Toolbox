#! /bin/bash
#
# Prints out just the name of the last thing you modified in the currecnt
# directory. This differs from 'ls -1r' in that only the last file modified is
# printed, not a full directory listing.
#
# Created: February 1, 2021
# Modified: January 27, 2022
#
# by Eric Patton
#
##############################################################################

SCRIPT=$(basename $0)

if [ "$1" == "-H" -o "$1" == "-h" -o "$1" == "--help" -o "$1" == "-help" ] ; then
	echo -e "\n$SCRIPT: Prints out just the name of the last thing you modified in the currecnt directory. This differs from 'ls -1r' in that only the last file modified is printed, not a full directory listing."
	exit 1
fi

PATTERN=$1

ls -ltrh ${PATTERN} | tail -n1 | awk '{print $9}'

exit 0