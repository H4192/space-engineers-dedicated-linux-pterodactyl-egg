FROM mmmaxwwwell/wine6:latest

RUN groupadd -g 867 sededicated && useradd -u 867 -g 867 sededicated && mkdir -p /home/sededicated && chown -R sededicated:sededicated /home/sededicated
COPY install-winetricks /scripts/
RUN \
  mkdir /wineprefix &&\
  chown -R sededicated:sededicated /wineprefix &&\
  chmod +x /scripts/install-winetricks
WORKDIR /scripts
RUN runuser sededicated bash -c ./install-winetricks
RUN \
  mkdir -p /appdata/space-engineers/bin &&\
  mkdir -p /appdata/space-engineers/config
COPY entrypoint.bash /entrypoint.bash
COPY entrypoint-space_engineers.bash /entrypoint-space_engineers.bash
RUN chmod +x /entrypoint.bash && chmod +x /entrypoint-space_engineers.bash

CMD /entrypoint.bash

  

