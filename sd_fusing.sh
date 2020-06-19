#
# Copyright (C) 2011 Samsung Electronics Co., Ltd.
#              http://www.samsung.com/
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2 as
# published by the Free Software Foundation.
#
####################################

if [ -z $1 ]
then
    echo "usage: ./sd_fusing.sh <SD Reader's device file>"
    exit 0
fi

if [ -b $1 ]
then
    echo "$1 reader is identified."
else
    echo "$1 is NOT identified."
    exit 0
fi

####################################
# fusing images

signed_bl1_position=1
bl2_position=31
uboot_position=63
tzsw_position=719
kernel_position=1063

#<BL1 fusing>
echo "BL1 fusing"
dd iflag=dsync oflag=dsync if=./E4412_S.bl1.SMDK.MR3.bin of=$1 seek=$signed_bl1_position

#<BL2 fusing>
echo "BL2 fusing"
dd iflag=dsync oflag=dsync if=./E4412_S.bl2.SMDK.MR3.bin.signed of=$1 seek=$bl2_position

#<u-boot fusing>
echo "u-boot fusing"
dd iflag=dsync oflag=dsync if=./u-boot.bin of=$1 seek=$uboot_position

#<TrustZone S/W fusing>
echo "TrustZone S/W fusing"
dd iflag=dsync oflag=dsync if=./E4412_S.tzsw.SMDK.MR3.bin.signed of=$1 seek=$tzsw_position

#<zImage fusing>
echo "kernel fusing"
dd iflag=dsync oflag=dsync if=./zImage of=$1 seek=$kernel_position

####################################
#<Message Display>
echo "U-boot image is fused successfully."
echo "Eject SD card and insert it again."

#
# CHECK BOARD'S BOOTLOADER ENV DATA!!!!
#

#setenv  bootcmd "movi read kernel 0 40008000;bootm 40008000"
#setenv  bootargs "root=/dev/mmcblk0p2 rootfstype=ext4  console=ttySAC1,115200 rootwait"
