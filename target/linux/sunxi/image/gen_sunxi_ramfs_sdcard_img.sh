#!/usr/bin/env bash
#
# Copyright (C) 2013 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

set -ex
[ $# -eq 4 ] || {
    echo "SYNTAX: $0 <file> <bootfs image> <bootfs size> <u-boot image>"
    exit 1
}

OUTPUT="$1"
BOOTFS="$2"
BOOTFSSIZE="$3"
UBOOT="$4"

head=4
sect=63

set `ptgen -o $OUTPUT -h $head -s $sect -l 1024 -t c -p ${BOOTFSSIZE}M`

BOOTOFFSET="$(($1 / 512))"
BOOTSIZE="$(($2 / 512))"

dd bs=1024 if="$UBOOT" of="$OUTPUT" seek=8 conv=notrunc
dd bs=512 if="$BOOTFS" of="$OUTPUT" seek="$BOOTOFFSET" conv=notrunc
