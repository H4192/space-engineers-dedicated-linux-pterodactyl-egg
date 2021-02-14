#!/bin/bash
source ~/.profile
source ~/.bash_profile
cd /home/container/space-engineers/SpaceEngineersDedicated/DedicatedServer64/
env WINEARCH=win64 WINEDEBUG=-all WINEPREFIX=/wineprefix wine /home/container/space-engineers/SpaceEngineersDedicated/DedicatedServer64/SpaceEngineersDedicated.exe -noconsole -path Z:\\home\\container\\space-engineers\\SpaceEngineersDedicated -ignorelastsession