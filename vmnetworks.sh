#!/bin/bash
# Just throw a bunch of commands at VMware
# it usually makes networking work for CyberPatriot
# I have no idea why
# TODO: decrease witchcraft
if [[ $(id -u) != 0 ]]; then
    echo "Must be run as root!" >&2
    exit 1
fi
#pacman -S vmmon
#yaourt -S vmware-systemd-services
systemctl restart vmmon
vmware-patch -f
sudo systemctl restart vmware
sudo systemctl restart vmware-usbarbitrator
sudo systemctl restart vmware-workstation-server
sudo systemctl restart vmware-networks
sudo systemctl restart vmnet
modprobe -a vmw_vmci vmmon
modprobe vmnet
vmware-networks --start
