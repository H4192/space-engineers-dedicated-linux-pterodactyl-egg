FROM ubuntu:focal
WORKDIR /home/container
RUN mkdir /home/container/scripts

RUN  useradd -m -u 1000 container 


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
  curl -L https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks > /home/container/scripts/winetricks &&\
  chmod +x /home/container/scripts/winetricks
  ##adduser wine --disabled-password --gecos ""

RUN apt-get install curl -y

COPY install-winetricks /home/container/scripts
RUN \
  mkdir /home/container/wineprefix &&\
  chown -R container:container /home/container/wineprefix &&\
  chmod +x /home/container/scripts/install-winetricks
WORKDIR /home/container/scripts
RUN runuser container bash -c ./install-winetricks
RUN \
  mkdir -p /home/container/space-engineers/bin &&\
  mkdir -p /home/container/space-engineers/config
COPY entrypoint.bash /entrypoint.bash
RUN chmod +x /entrypoint.bash 

RUN chown -R container:container /home/container

USER container
ENV  USER=container HOME=/home/container

CMD /entrypoint.bash