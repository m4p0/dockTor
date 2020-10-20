FROM debian:latest

## Connection ports for controlling the UI:
# VNC port:5901
# noVNC webport, connect via http://IP:6901/?password=vncpassword
ENV VNC_PORT=5901 \
    NO_VNC_PORT=6901
EXPOSE $VNC_PORT $NO_VNC_PORT $SSH_PORT

### Envrionment config
ENV HOME=/headless \
    TERM=xterm \
    STARTUPDIR=/dockerstartup \
    INST_SCRIPTS=/headless/install \
    NO_VNC_HOME=/headless/noVNC \
    DEBIAN_FRONTEND=noninteractive

WORKDIR $HOME

### Add all install scripts for further steps
ADD ./src/common/install/ $INST_SCRIPTS/
ADD ./src/debian/install/ $INST_SCRIPTS/
RUN find $INST_SCRIPTS -name '*.sh' -exec chmod a+x {} +

#### Add the startup script
ADD ./src/common/scripts/vnc_startup.sh $STARTUPDIR/
ADD ./src/common/scripts/startup.sh $STARTUPDIR/

### Install some common tools
RUN $INST_SCRIPTS/tools.sh
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

### Install custom fonts
RUN $INST_SCRIPTS/install_custom_fonts.sh

### Install xvnc-server & noVNC - HTML5 based VNC viewer
RUN $INST_SCRIPTS/tigervnc.sh
RUN $INST_SCRIPTS/no_vnc.sh

### Install firefox and chrome browser
RUN $INST_SCRIPTS/firefox.sh
#RUN $INST_SCRIPTS/chrome.sh

### Install xfce UI
RUN $INST_SCRIPTS/xfce_ui.sh
ADD ./src/common/xfce/ $HOME/

### Install NordVPN OpenVPN configs
RUN mkdir /opt/nordvpn
RUN cd /opt/nordvpn && \
    wget "https://downloads.nordcdn.com/configs/archives/servers/ovpn.zip" && \
    unzip ovpn.zip

##  Change Root password.
RUN echo "root:Docker!" | chpasswd
RUN useradd -d /headless  -u 1000 -ms /bin/bash default
RUN echo "default:SuperSecurePassword$123" | chpasswd

## Configure Conky
RUN mkdir /headless/.conky
RUN cp $INST_SCRIPTS/conkyrc /headless/.conky/
RUN chown -R default:default /headless/.conky

#### configure startup
RUN $INST_SCRIPTS/set_user_permission.sh $STARTUPDIR $HOME

ENTRYPOINT ["/dockerstartup/startup.sh"]
CMD ["--wait"]
