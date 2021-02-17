FROM mmmaxwwwell/wine6:latest

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

COPY entrypoint.bash /entrypoint.bash
COPY entrypoint-space_engineers.bash /entrypoint-space_engineers.bash

RUN chmod +x /entrypoint.bash
RUN chmod +x /entrypoint-space_engineers.bash

ENV  USER=container HOME=/home/container
USER container

CMD /entrypoint.bash