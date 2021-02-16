FROM debian:buster



RUN dpkg --add-architecture i386 &&\
    apt-get update && apt-get upgrade -y &&\
    apt-get install apt-utils curl gnupg2 software-properties-common libstb0 libavcodec58 libsdl2-2.0-0 libavutil56 libc6 -y

RUN curl https://dl.winehq.org/wine-builds/winehq.key | apt-key add - &&\
    apt-add-repository https://dl.winehq.org/wine-builds/debian/ &&\
    apt-add-repository non-free &&\
    apt-get update &&\
    curl -L https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_10/i386/libfaudio0_20.01-0~buster_i386.deb > libfaudio0_20.01-0~buster_i386.deb &&\
    curl -L https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_10/amd64/libfaudio0_20.01-0~buster_amd64.deb > libfaudio0_20.01-0~buster_amd64.deb &&\
    dpkg -i --force-depends libfaudio0_20.01-0~buster_i386.deb &&\
    dpkg -i --force-depends libfaudio0_20.01-0~buster_amd64.deb &&\
    apt-get update &&\
    apt-get install -f -y &&\
    apt-get install --install-recommends winehq-stable -y &&\
    rm *.deb &&\
    echo steam steam/question select "I AGREE" | debconf-set-selections &&\
    apt-get install steamcmd xvfb cabextract unzip -y &&\
    apt-get purge software-properties-common gnupg2 python* -y &&\
    apt-get autoclean &&\
    apt-get autoremove -y

RUN mkdir /scripts &&\
    curl -L https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks > /scripts/winetricks &&\
    chmod +x /scripts/winetricks 


COPY install-winetricks /scripts/

RUN adduser container --uid 998 --disabled-password --gecos "" 

RUN mkdir /wineprefix &&\
    chown -R container:container /wineprefix &&\
    chmod +x /scripts/install-winetricks

WORKDIR /scripts

RUN runuser container bash -c ./install-winetricks

RUN \
    mkdir -p /appdata/space-engineers/bin &&\
    mkdir -p /appdata/space-engineers/config &&\
    chown -R container:container /wineprefix &&\
    chown -R container:container /appdata

RUN ls -la /appdata &&\
    ls -la /wineprefix

COPY entrypoint.bash /entrypoint.bash
COPY entrypoint-space_engineers.bash /entrypoint-space_engineers.bash

RUN chmod +x /entrypoint.bash
RUN chmod +x /entrypoint-space_engineers.bash

ENV  USER=container HOME=/home/container
USER container

CMD /entrypoint.bash