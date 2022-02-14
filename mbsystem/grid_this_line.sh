#!/bin/bash
#
#
# grid_this_line.sh - A script to grid one swath bathymetry file and import it
# into GRASS GIS.
#
#
# Script Created: February 11, 2022
# Last modified: February 11, 2022
#
###############################################################################

# Check to see if GRASS is running; abort if not.
if  [ -z "$GISBASE" ] ; then
    echo "You must be in GRASS GIS to run this program."
    exit 1
fi

SCRIPT=`basename $0`

# Setup clean exit for Ctrl-C or similar breaks.
trap 'echo -e "\n\nUser break or similar caught; Exiting.\n" ; exit 1' 2 3 15

if [ "$#" -gt 2 -o "$1" == "-H" -o "$1" == "-h" -o "$1" == "--help" -o "$1" == "-help" ] ; then
	echo -e "\nusage: $SCRIPT swathfile [resolution] \n"
	exit 1
fi

INPUT=$1
RES=$2

# Assign a default raster resolution if none was given on the command line.
[[ -z ${RES} ]] && RES=10

OUTPUT=`echo $INPUT | cut -f1 -d'.'`
XYZ_OUTPUT=${OUTPUT}.xyz
FORMAT_ID=`mbformat -I $INPUT -K | awk '{print $2}'`	

mblist -F${FORMAT_ID} -I ${INPUT} -D2 | awk '{print $1, $2, -$3}' | proj `g.proj -jf` | pv | awk '{print $1, $2, $3}' > ${XYZ_OUTPUT}

import_xyz.sh ${XYZ_OUTPUT} ${RES}
r.colors map=${OUTPUT}_${RES}m color=bof_unb --v
r.csr ${OUTPUT}_${RES}m

exit 0
