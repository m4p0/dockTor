#!/usr/bin/env bash

# screen session with ovpn
/bin/bash -c "/usr/bin/screen -S ovpn -d -m /usr/sbin/openvpn --config /opt/nordvpn/ovpn_udp/$(ls /opt/nordvpn/ovpn_udp/ | shuf -n1) --auth-user-pass /keys/vpnauth.txt"
/usr/bin/sudo -u default /dockerstartup/vnc_startup.sh
/bin/bash