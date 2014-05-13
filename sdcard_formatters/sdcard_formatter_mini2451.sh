#!/bin/sh
#######################################################################
#    sdcard_formatter_mini210.sh Format SD Card for Mini2451 SuperBoot
#    Copyright (C) 2014 Jason Pruitt
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
##########################################################################
# Version 0.1

SDDEV=$1
SDPART="1"
SB=$2
BLOCKSIZE=512
# All sizes are in 512byte blocks.
BL1SIZE=16
GAPSIZE=256
RSVSIZE=2

help(){
echo "Usage:";
echo "	sdcard_formatter_mini2451.sh /dev/sd[x] /path/to/SuperBoot2451.bin";
echo "	Formats SD Card, makes FAT32 partition, and copies Superboot to end of card.";
echo "  !Destroys all data on disk!";
exit 0;
}

if [ $# -lt 2 ] || [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
	help
fi

if ! [ -a $SDDEV ]; then
	echo "Device does not exist."
	exit 1;
fi

if ! [ -a $SB ]; then
	echo "File does not exist."
	exit 1;
fi

SDNAME=`sed -e "s/\/dev//" <<< $SDDEV`;
SDSIZE=`cat /sys/block$SDNAME/size`;
SBSIZE=$(expr `stat -c %s $SB` / $BLOCKSIZE);
SBAREASIZE=$(($SBSIZE + $GAPSIZE + $BL1SIZE + $RSVSIZE));
STARTBLOCK=$(($SDSIZE - $SBAREASIZE));

# Zero out end of sdcard
dd if=/dev/zero of=$SDDEV bs=$BLOCKSIZE skip=$STARTBLOCK count=$SBAREASIZE;

(echo o; echo n; echo p; echo 1; echo ; echo $(($STARTBLOCK - $BLOCKSIZE)); echo t; echo c;  echo w;) | sudo /sbin/fdisk $SDDEV > /dev/null 2>&1

sudo /sbin/mkfs.msdos -n "FriendlyARM" $SDDEV$SDPART #> /dev/null 2>&1

START=$STARTBLOCK
dd if=$SB of=$SDDEV bs=$BLOCKSIZE seek=$START count=$SBSIZE > /dev/null 2>&1

START=$(($START + $GAPSIZE + $SBSIZE))
dd if=$SB of=$SDDEV bs=$BLOCKSIZE seek=$START count=$BL1SIZE > /dev/null 2>&1





