#!/usr/bin/env bash
### every exit != 0 fails the script
set -e

echo "Add repositroy for Tor-Browser"
echo "deb http://deb.debian.org/debian buster-backports main contrib" > /etc/apt/sources.list.d/buster-backports.list


echo "Install some common tools for further installation"
apt-get update 
apt-get install -y vim wget net-tools locales bzip2 python-numpy vlc sudo openvpn unzip screen watch conky-all curl
apt-get install -y torbrowser-launcher -t buster-backports
apt-get clean -y

echo "generate locales für en_US.UTF-8"
locale-gen en_US.UTF-8