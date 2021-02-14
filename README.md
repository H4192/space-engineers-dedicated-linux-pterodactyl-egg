## Fork of mmmaxwwwell's SEDS docker image
This is my attempt to wrangle it into a Pterodactyl egg

Original repo at [mmmaxwwwell/space-engineers-dedicated-docker-linux](https://github.com/mmmaxwwwell/space-engineers-dedicated-docker-linux)
 


## Exit Codes:
| Exit Code | Reason |
| - | - |
| 129 | Container is missing /appdata/space-engineers/World folder, volume mounts are mounted incorrectly. |
| 130 | Container is missing /appdata/space-engineers/World/Sandbox.sbc, World is not placed in the right folder, or the volume mounts are mounted incorrectly. Ensure your world is in ```./appdata/space-engineers/config/World/```.|
| 131 | Container is missing the dedicated server config file SpaceEngineers-Dedicated.cfg. Ensure that you have placed SpaceEngineers-Dedicated.cfg at ```./appdata/space-engineers/config/SpaceEngineers-Dedicated.cfg```. |

## Directory Structure:
```
SpaceEngineersDedicated contains the dedicated server files
steamcmd contains steamcmd
config contains all the user configurable files for the game instance
World contains the world files

appdata
└── space-engineers
    ├── bins
    │   ├── SpaceEngineersDedicated 
    │   └── steamcmd 
    └── config 
        ├── SpaceEngineers-Dedicated.cfg
        └── World
            ├── Alien-291759539d120000.vx2
            ├── EarthLike-1779144428d120000.vx2
            ├── Europa-595048092d19000.vx2
            ├── Mars-2044023682d120000.vx2
            ├── Moon-1353915701d19000.vx2
            ├── SANDBOX_0_0_0_.sbs
            ├── Sandbox.sbc
            ├── Sandbox_config.sbc
            ├── Titan-2124704365d19000.vx2
            ├── Triton-12345d80253.vx2
            └── thumb.jpg

```