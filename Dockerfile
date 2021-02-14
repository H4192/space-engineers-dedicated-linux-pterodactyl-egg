FROM mmmaxwwwell/wine6:latest

COPY install-winetricks /scripts/
RUN \
  mkdir /wineprefix &&\
  chown -R wine:wine /wineprefix &&\
  chmod +x /scripts/install-winetricks
WORKDIR /scripts
RUN runuser wine bash -c ./install-winetricks
RUN \
  mkdir -p /home/container/space-engineers/bin &&\
  mkdir -p /home/container/space-engineers/config
COPY entrypoint.bash /root/entrypoint.bash
COPY entrypoint-space_engineers.bash /entrypoint-space_engineers.bash
RUN chmod +x /root/entrypoint.bash && chmod +x /entrypoint-space_engineers.bash

CMD /root/entrypoint.bash

  

