
# DockTor

DockTor will provide a debian based container with Tor and OpenVPN on it.

## Getting Started

First of all this container was originally based on the configurations and scripts of (https://github.com/ConSol/docker-headless-vnc-container).

If you want to build it from scratch or modify the dockerfile or any configurations/scripts 
you could use the repository on github:

* [GitHub](https://github.com/m4p0/dockTor)

Out of the box this docker builds a VPN to a random chosen location of NordVPN (https://www.nordvpn.com) by default if the credentials are given. The Tor-Browser could be installed from the menu.


### Prerequisities


In order to run this container you'll need docker installed.

* [Windows](https://docs.docker.com/windows/started)
* [OS X](https://docs.docker.com/mac/started/)
* [Linux](https://docs.docker.com/linux/started/)

### Usage

#### Basic usage

##### Linux/OSX:

- Default password for VNC: `vncpassword`
- Default root password: `Docker!`

With VNC Client:

- Connect with SSH: `ssh -L 5901:127.0.0.1:5901 -P 2222 <your user>@<your dockerhost>`
- Use your default vnc client: and open `localhost:5901`

With NOVNC in your browser:

- Connect with SSH: `ssh -L 6901:127.0.0.1:6901 -P 2222 <your user>@<your dockerhost>`
- Open your browser and open http://127.0.0.1:6901

#### Windows:

- Configure portworwarding with putty: [here](https://ccrma.stanford.edu/guides/sshtunnel/puttyforward.html)
- Connection to NoVNC or VNC is identical to Linux/OSX

#### Container Parameters

The following parameters are needed to make everything fully work:

Following ports are forwarded to the docker:

- `5901 for VNC` 
- `6901 for NoVNC`

Additional parameters are set to establish a VPN tunnel:

- `--cap-add=NET_ADMIN`
- `--device /dev/net/tun`

I don't need IPv6 therefore I disabled it:

- `--sysctl net.ipv6.conf.all.disable_ipv6=0`
```shell
docker run -dit -p 5901:5901 -p 6901:6901 --cap-add=NET_ADMIN -v $(pwd)/keys:/keys:ro --device /dev/net/tun --sysctl net.ipv6.conf.all.disable_ipv6=0 docktor
```

#### Known Problems

If you can see that you are still online with your public IP-address (check: www.ifconfig.io), just restart the docker to reconnect to another configuration or login as root, attach to the screen
session and restart openvpn.

#### Useful File Locations

* `/keys/` - Contains the authentication file (vpnauth.txt) for openvpn [what?](https://forums.openvpn.net/viewtopic.php?t=11342)

## Authors

* **m4p0**

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

## Acknowledgments

* Thanks to [ConSol](https://github.com/ConSol/docker-headless-vnc-container) for the awesome work.
