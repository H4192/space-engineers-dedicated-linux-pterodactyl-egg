FROM ubuntu:focal
WORKDIR /root
RUN mkdir /scripts


RUN \
  dpkg --add-architecture i386 &&\
  apt update && apt upgrade -y &&\
  apt install curl gnupg2 software-properties-common -y &&\
  curl https://dl.winehq.org/wine-builds/winehq.key | apt-key add - &&\
  add-apt-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main'  &&\
  apt update &&\
  apt install libfaudio0:amd64 libfaudio0:i386 -y &&\
  apt install -f -y &&\
  apt install --install-recommends winehq-stable -y &&\
  echo steam steam/question select "I AGREE" | debconf-set-selections &&\
  apt install steamcmd xvfb cabextract unzip -y &&\
  apt purge software-properties-common gnupg2 python* -y &&\
  apt autoclean &&\
  apt autoremove -y &&\
  curl -L https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks > /scripts/winetricks &&\
  chmod +x /scripts/winetricks 
  ##adduser wine --disabled-password --gecos ""

RUN  useradd -m container 

COPY install-winetricks /scripts/
RUN \
  mkdir /wineprefix &&\
  chown -R container:container /wineprefix &&\
  chmod +x /scripts/install-winetricks
WORKDIR /scripts
RUN runuser container bash -c ./install-winetricks
RUN \
  mkdir -p /home/container/space-engineers/bin &&\
  mkdir -p /home/container/space-engineers/config
COPY entrypoint.bash /entrypoint.bash
COPY entrypoint-space_engineers.bash /entrypoint-space_engineers.bash
RUN chmod +x /entrypoint.bash && chmod +x /entrypoint-space_engineers.bash

CMD /entrypoint.bash