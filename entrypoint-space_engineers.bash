#!/bin/bash

cd /home/container/space-engineers/SpaceEngineersDedicated/DedicatedServer64/
env WINEARCH=win64 WINEDEBUG=-all WINEPREFIX=/home/container/wineprefix wine /home/container/space-engineers/SpaceEngineersDedicated/DedicatedServer64/SpaceEngineersDedicated.exe -noconsole -path Z:\\home\\container\\space-engineers\\SpaceEngineersDedicated -ignorelastsession