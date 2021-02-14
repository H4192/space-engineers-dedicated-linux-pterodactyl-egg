#!/bin/bash


## errorcode start 110

unzip=false
zipfound=false
mounted=false
ERRORMSG=""
files_missing=false

## Check if resources are mounted
if [ -d "/ronly" ]; then 
  echo "Mount directory found"
  mounted=true
else
  echo "Mount directory unavailable"
  ERRORMSG="${ERRORMSG}Mount directory unavailable \n"
fi

## Check for star system package
if [ $mounted = true ] && [ -f "/ronly/star-system.zip" ]; then
    echo "Star system package found"
    zipfound=true
elif [ $mounted = true ] && [ ! -f "/ronly/star-system.zip" ]; then
    echo "Star system package missing"
    ERRORMSG="${ERRORMSG}Star system package missing \n"
fi


## Check if files already exist
world="/home/container/space-engineers/World" 
sandbox="/home/container/space-engineers/World/Sandbox.sbc" 
config="/home/container/space-engineers/SpaceEngineersDedicated/SpaceEngineers-Dedicated.cfg"

if [ ! -d $world ]; then
  echo "World directory missing!"
  ERRORMSG="${ERRORMSG}World directory missing!\n"
  files_missing=true
fi

if [ ! -f $sandbox ]; then
  echo "Sandbox.sbc file missing!"
  ERRORMSG="${ERRORMSG}Sandbox.sbc file missing!\n"
  files_missing=true
fi

if [ ! -f $sandbox ]; then
  echo "SpaceEngineers-Dedicated.cfg file missing!"
  ERRORMSG="${ERRORMSG}SpaceEngineers-Dedicated.cfg file missing!\n"
  files_missing=true
fi

if [ $mounted = false ] && [ $files_missing = true ]; then
  exit 111
fi

if [ $mounted = true ] && [ $files_missing = false ]; then
    echo "World not found, initalizing star system from package..."
    /usr/bin/unzip -n /readonly/star-system.zip -d /home/container/space-engineers/SpaceEngineersDedicated
fi




#set <LoadWorld> to the correct value
cat /home/container/space-engineers/SpaceEngineersDedicated/SpaceEngineers-Dedicated.cfg | sed -E '/.*LoadWorld.*/c\  <LoadWorld>Z:\\home\\container\\space-engineers\\World</LoadWorld>' > /tmp/SpaceEngineers-Dedicated.cfg && cat /tmp/SpaceEngineers-Dedicated.cfg > /home/container/space-engineers/SpaceEngineersDedicated/SpaceEngineers-Dedicated.cfg

#set game port to the correct value
#cat /home/container/space-engineers/SpaceEngineersDedicated/SpaceEngineers-Dedicated.cfg | sed -E '/.*ServerPort.*/c\  <ServerPort>27016</ServerPort>' > /tmp/SpaceEngineers-Dedicated.cfg && cat /tmp/SpaceEngineers-Dedicated.cfg > /home/container/space-engineers/SpaceEngineersDedicated/SpaceEngineers-Dedicated.cfg

#configure plugins section in SpaceEngineers-Dedicated.cfg
#get new plugins string

if [ "$(ls -1 /home/container/space-engineers/Plugins/*.dll | wc -l)" -gt "0" ]; then
  PLUGINS_STRING=$(ls -1 /home/container/space-engineers/Plugins/*.dll |\
  awk '{ print "<string>" $0 "</string>" }' |\
  tr -d '\n' |\
  awk '{ print "<Plugins>" $0 "</Plugins>" }' )
else
  PLUGINS_STRING="<Plugins />"
fi

SED_EXPRESSION_EMPTY="s/<Plugins \/>/${PLUGINS_STRING////\\/} /g"
SED_EXPRESSION_FULL="s/<Plugins>.*<\/Plugins>/${PLUGINS_STRING////\\/} /g"

#find and replace in SpaceEngineers-Dedicated.cfg for empty "<Plugins />" element
cat /home/container/space-engineers/SpaceEngineersDedicated/SpaceEngineers-Dedicated.cfg | sed -E "$SED_EXPRESSION_EMPTY" > /tmp/SpaceEngineers-Dedicated.cfg && cat /tmp/SpaceEngineers-Dedicated.cfg > /home/container/space-engineers/SpaceEngineersDedicated/SpaceEngineers-Dedicated.cfg

#find and replace in SpaceEngineers-Dedicated.cfg for filled out "<Plugins>...</Plugins>" element
# sed can't handle multiple lines easily, so everything needs to be on a single line.
cat /home/container/space-engineers/SpaceEngineersDedicated/SpaceEngineers-Dedicated.cfg | sed -E "$SED_EXPRESSION_FULL" > /tmp/SpaceEngineers-Dedicated.cfg && cat /tmp/SpaceEngineers-Dedicated.cfg > /home/container/space-engineers/SpaceEngineersDedicated/SpaceEngineers-Dedicated.cfg


runuser -l wine bash -c 'steamcmd +login anonymous +@sSteamCmdForcePlatformType windows +force_install_dir /home/container/space-engineers/SpaceEngineersDedicated +app_update 298740 +quit'
runuser -l wine bash -c '/entrypoint-space_engineers.bash'