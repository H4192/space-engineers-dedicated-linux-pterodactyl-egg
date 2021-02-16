#!/bin/bash

echo "Start of entrypoint-space_engineers.bash"
cd /home/container/space-engineers/SpaceEngineersDedicated/DedicatedServer64/
echo "Starting server"
env WINEARCH=win64 WINEDEBUG=-all WINEPREFIX=/wineprefix wine /home/container/space-engineers/SpaceEngineersDedicated/DedicatedServer64/SpaceEngineersDedicated.exe -noconsole  -path Z:\\home\\container\\space-engineers\\SpaceEngineersDedicated -ignorelastsession