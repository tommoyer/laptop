#!/bin/bash

# $1 - vm name
# $2 - iso image
# $3 - iso volume name

incus storage volume import default $2 $3 --type=iso

incus init $1 --empty --vm

incus config device override $1 root size=100GiB
incus config set $1 limits.cpu=4 limits.memory=8GiB
incus config device add $1 installer disk pool=default source=$3 boot.priority=10

incus start $1 --console=vga

echo "incus config device remove $1 installer"
echo "incus storage volume delete default $3"
