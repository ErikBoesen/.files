#!/bin/bash
# Just throw a bunch of commands at VMware
# it usually makes networking work for CyberPatriot
# I have no idea why
# TODO: decrease witchcraft
if [[ $(id -u) != 0 ]]; then
    echo "Must be run as root!" >&2
    exit 1
fi

vmware-modconfig --console --install-all
xauth=~erik/.Xauthority
touch $xauth
chmod u+rw $xauth
chown erik:erik $xauth
mkdir ~erik/vmware
#pacman -S vmmon
#yaourt -S vmware-systemd-services
systemctl restart vmmon
vmware-patch -f
systemctl restart vmware
systemctl restart vmware-usbarbitrator
systemctl restart vmware-workstation-server
systemctl restart vmware-networks
systemctl restart vmnet
modprobe -a vmw_vmci vmmon
modprobe vmnet
vmware-networks --start
