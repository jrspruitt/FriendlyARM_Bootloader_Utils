Friendlyarm Bootloader Utils
===========================

A collection of Linux scripts for use with FriendlyARM's SuperBoot bootloader.

## SD Card Formatters ##
These Linux scripts are used for formatting an SD Card to FAT32 and fusing SuperBoot.bin to the proper location. The SD Card can then be used for updating the firmware on their respective boards.

To use, you must know the dev name of your sd card, since you will be deleting all data on the card, this is very important to get right. It will probably be something like /dev/sdf, check the output of dmesg after mounting your card for the proper name. Run the script as such

    ./sdcard_formatter_mini210.sh /dev/sdf /path/to/SuperBoot.bin


