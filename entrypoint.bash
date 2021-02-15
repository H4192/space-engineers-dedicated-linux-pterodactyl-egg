#!/bin/bash


## errorcode start 110
server_directory="/home/container/space-engineers"
server_dir_win=${server_directory//\//\\\\}
unzip=false
zipfound=false
mounted=false
files_missing=false

## Check if resources are mounted
if [ -d "/ronly" ]; then 
  echo "Mount directory found"
  mounted=true
else
  echo "Mount directory unavailable"
fi

## Check for star system package
if [ $mounted = true ] && [ -f "/ronly/star-system.zip" ]; then
    echo "Star system package found"
    zipfound=true
elif [ $mounted = true ] && [ ! -f "/ronly/star-system.zip" ]; then
    echo "Star system package missing"
fi


## Check if files already exist
sandbox="${server_directory}/config/World/Sandbox.sbc" 
config="${server_directory}/SpaceEngineersDedicated/SpaceEngineers-Dedicated.cfg"


if [ ! -f $sandbox ]; then
  echo "Sandbox.sbc file missing!"
  files_missing=true
fi

if [ $mounted = false ] && [ $files_missing = true ]; then
  exit 111
fi

if [ $mounted = true ] && [ $files_missing = true ]; then
    echo "World not found, initalizing star system from package..."
    mkdir -p ${server_directory}/config
    mkdir -p ${server_directory}/SpaceEngineersDedicated
    mkdir -p ${server_directory}/bins/steamcmd
    mkdir -p ${server_directory}/config/World
    mkdir -p ${server_directory}/config/Plugins

    /usr/bin/unzip -n /ronly/star-system.zip -d ${server_directory}/config
    mv ${server_directory}/config/SpaceEngineers-Dedicated.cfg ${server_directory}/SpaceEngineersDedicated/SpaceEngineers-Dedicated.cfg
fi




#set <LoadWorld> to the correct value
cat ${server_directory}/SpaceEngineersDedicated/SpaceEngineers-Dedicated.cfg | sed -E "/.*LoadWorld.*/c\  <LoadWorld>Z:${server_dir_win}\\config\\World</LoadWorld>" > /tmp/SpaceEngineers-Dedicated.cfg && cat /tmp/SpaceEngineers-Dedicated.cfg > ${server_directory}/SpaceEngineersDedicated/SpaceEngineers-Dedicated.cfg

#set game port to the correct value
#cat ${server_directory}/SpaceEngineersDedicated/SpaceEngineers-Dedicated.cfg | sed -E '/.*ServerPort.*/c\  <ServerPort>27016</ServerPort>' > /tmp/SpaceEngineers-Dedicated.cfg && cat /tmp/SpaceEngineers-Dedicated.cfg > ${server_directory}/SpaceEngineersDedicated/SpaceEngineers-Dedicated.cfg

#configure plugins section in SpaceEngineers-Dedicated.cfg
#get new plugins string

if [ "$(ls -1 ${server_directory}/config/Plugins/*.dll | wc -l)" -gt "0" ]; then
  PLUGINS_STRING=$(ls -1 ${server_directory}/config/Plugins/*.dll |\
  awk '{ print "<string>" $0 "</string>" }' |\
  tr -d '\n' |\
  awk '{ print "<Plugins>" $0 "</Plugins>" }' )
else
  PLUGINS_STRING="<Plugins />"
fi

SED_EXPRESSION_EMPTY="s/<Plugins \/>/${PLUGINS_STRING////\\/} /g"
SED_EXPRESSION_FULL="s/<Plugins>.*<\/Plugins>/${PLUGINS_STRING////\\/} /g"

#find and replace in SpaceEngineers-Dedicated.cfg for empty "<Plugins />" element
cat ${server_directory}/SpaceEngineersDedicated/SpaceEngineers-Dedicated.cfg | sed -E "$SED_EXPRESSION_EMPTY" > /tmp/SpaceEngineers-Dedicated.cfg && cat /tmp/SpaceEngineers-Dedicated.cfg > ${server_directory}/SpaceEngineersDedicated/SpaceEngineers-Dedicated.cfg

#find and replace in SpaceEngineers-Dedicated.cfg for filled out "<Plugins>...</Plugins>" element
# sed can't handle multiple lines easily, so everything needs to be on a single line.
cat ${server_directory}/SpaceEngineersDedicated/SpaceEngineers-Dedicated.cfg | sed -E "$SED_EXPRESSION_FULL" > /tmp/SpaceEngineers-Dedicated.cfg && cat /tmp/SpaceEngineers-Dedicated.cfg > ${server_directory}/SpaceEngineersDedicated/SpaceEngineers-Dedicated.cfg

cd /home/container

USER=container 
HOME=/home/container

/usr/games/steamcmd +login anonymous +@sSteamCmdForcePlatformType windows +force_install_dir /home/container/space-engineers/SpaceEngineersDedicated +app_update 298740 +quit

echo "End of entrypoint"
/entrypoint-space_engineers.bash