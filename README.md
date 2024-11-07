# mrp-missions (OUT OF DATE but still somewhat playable)
# Crackdown Mission Resource for FiveM

# This resource is glitchy with more than 1 player for some missions. Only recommended for playing on a server just to play these missions. 

# I am not longer supporting this, but after some playtesting added some fixes and tips to for anyone wanting to play. Best for a server that is set up to run this and coordinated players. 

# WORKAROUND FIXES ADDED in release 3.2.8.7. If you see mission A.I. etc.. acting wierd not responding etc.. A workaround fix can be enabled  globally for all missions or per mission. See 'IgnoreMissionStarterFix' at the top of Missions.lua file). 

# STEPS
# NOTE: whether the workaround is enabled or not, following the STEPS  below will minimize/remove glitches and should make all 62 missions playable:
# 1. players should always stick together as much as possible. I added a teleport resource where players can teleport to a  waypoint set near another player (wihtin 300m) using right stick down and dpad up simultaenously (or keyboard equivalents) Control Indexes 26 & 27. https://docs.fivem.net/docs/game-references/controls/ Mission resource drops for fast travel can be used too.
# also a /tp command where players can teleport anywhere on the map regardless where any other player is. With both if a player is in a vehicle they will teleport in the vehicle.
# 2. It's REQUIRED that the first player to join the server use '/mission missionname'  (i.e. /mission Mission1). to start a mission (they become the MISSIONSTARTER in the code). The first player to join should also trigger the mission (spawns mission entities). This is when a player comes within  a certain amount of distance from the mission blip.
# 3. If mission and mission A.I. is still  janky set IgnoreMissionStarterFix=false, for the mission. and restart the resource and follow 1. and 2. above. This forces the first player ''host' to spawn entities on behalf of the other players. (except for indoorsMission=true mission types and mission events which should work fine)
# 4. Try restarting the server and reconnecting may fix it if that doesnt help (with IgnoreMissionStarterFix either false or true). 
# 5. if you get crashes then try setting  game build to1604 on server. 
# 6. The resource will not work with regular onesync. set  onesync  to off or onesync set to legacy in server.cfg and txadmin. If onesync is set to legacy, copy the server.lua in the root of the repo/zip archive and put it into mrp-missions.v3 directory, backing up server.lua already there. Then at the top of Missions.lua set Config.UsingOneSync = true

# NOTE: some missions get started and triggered at the same time just make sure FIRST player is starting it.

# NOTE: :The main resource 'mrp-missions-v3' requires an non-supported out date manifest for it to work. resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'. using a newer manifest will break it and cause missions to not work at all.

# Other notes: Make sure 'start baseevents' is in the server.cfg (as well as one sync set to off or set to legacy in server.cfg and txadmin). Also for this to work properly either comment out or remove 'ensure basic-gamemode' (default freeroam gametype) in server.cfg (if vanilla server). Else and also if you are using other gametypes, you will need to change the code and/or manifest in the mrp-missions-v3 resource to behave better with other gametypes.


# This resource is OUT OF DATE. One issue with newer clients and servers is for missions that use long range NPC blips. For more than 1 player games, these blips can and probably will turn off until you are within streaming range of the NPC (300+meteres). This can make some of the missions more challenging. 

# See rest of README.md and README.TXT for installation instructions


See the README.TXT for installation, controls and other information about this resource. 
See the SHADOW STATE MISSION PACK README.txt file in shadowstate-missionpack.zip for information 
specfic to the 12 missions that are also incorporated in Missions.lua and use DLC areas. 
See Config_Guide.lua.txt for how to edit Missions.lua to edit and create your own missions. Missions.lua check out too.
See the new thread here for the latest videos and other information: https://forum.cfx.re/t/release-crackdown-missions-system-v3-github-for-your-own-missions/961763
See first post in the following link as well for this and other information about the default game mode,
including videos/screenshots (older beta thread):
https://forum.cfx.re/t/release-fivem-crackdown-game-mode-and-mission-generator-creation-beta/275613

ABOUT: 
This resource mutated over time, adding many new features, to be used as a mission system for my local 
FiveM server. Development has basically finished, so wanted to share with others who want to use or adapt 
it for their own servers. The resource is very configurable and can be configured to meet a vast majority 
of types of servers (public, RP etc...). Saying that, I wanted to give some guidance on making some code 
changes that people requested that was out of the scope of my project for what I wanted. You are welcome 
to use this resource as a reference for your own resource, just give credit to me and also to the people I 
credit in the fivem forum link above. 

ESX Support:
Should work fine, but some people have reported problems. The 2 ESX hooks one in  client.lua the other in server.lua may need to be updated. Search on 'ESX' to find the hook code. 

fxmanifest.lua and resource.lua 
This resource uses resource.lua which should work still, byt may become deprecated. If you need to update the code to use FXManifest, set it to adamant (thanks Nocteau) and set every occurance of a prop spawn to be like Prop = CreateObject(GetHashKey(randomPropModelHash), randomLocation.x, randomLocation.y, randomLocation.z, true, true, true) Believe the difference is in the last booleans.  


DESIGNING MISSIONS FOR PUBLIC SERVER SUPPORT VS LOCAL SERVER: Most of this was designed for my private local server. Something I noticed during testing is that some mission designs may not work as well on a public server with more users and more latency etc... Sixsens who tested this resource on his public server helped me add better support for situations where entities stopped existing for peers when they were outside collision/streaming range (approx. 300m), but will come back into existence when a player is within 300m. You should use the MissionTriggerRadius setting to be around this value or less to make sure that the entities exist and are within range of a player to show any blips, and peform any mission tasks, etc.. During testing, on my local server, with much fewer players and less latency this was not a problem. Missions like Mission20 and Mission21 which spawn entities all around the map, *may* not be well suited to a public server, since players may not see the blips/locations of the entities, due to not being close enough. Many missions in Missions.lua were re-done with public server support in mind, where the mission entities only spawn when a player is nearby. Also using IndoorsMission=true with IndoorsMissionSpawnRadius (doesnt have to be an indoor mission) (see Missions.lua, Config_Guide.lua.txt and further down) can be extremely helpful, which Sixsens verified. Also, if you are having problems with mission quirkiness, set the MissionTriggerRadius to be <= 300. There are other missions too, like Mission16 which spawn entities around the map, and IsDefendTarget
 missions like Mission25 that use TaskPlaneChase,TaskHeliChase, TaskPlaneMission, TaskHeliMission etc... that the target uses to chase a dummy vehicle created by  the resource that can be across the map. If that does not work well, use the coordinate arguments for TaskPlaneMission, TaskHeliMission etc.. natives instead, which may work better in case the dummy vehicle does not exist due to being out of collision range. Verfied: In SpawnProps and SpawnRandomProp, you can change TaskHeliChase with TaskHeliMission using coords and mission flag 9 tested, and you can change TaskPlaneChase with TaskPlaneMission, but the mission flag will need to be 6. 

ONESYNC SUPPORT: 
Added experimental ONESYNC support server.lua in the root of the repo, which you can replac with the one in the repo.
This resource may have problems with OneSync servers. Depending on the mission, the server side script asks each client to return NetworkIsHost() and spawn missions entities on the one that is true. I gather with OneSync this will return true for all clients(?).
If that is a problem, you will need to change that code to either pick a random client, or use another solution to pick 
which client will be the host. Sixsens on forum.fivem.net has used this resource for his public RP server fine, but 
had to make some changes when he went to OneSync. One of the changes he made was to set IndoorsMission=true for 
missions, which will spawn entities dynamically on any player's machine which is closest to where the entity should spawn. 
He changed the hardcoded value for distance check (IndoorsMissionSpawnRadius) from 30m to 300m. Hopefully you will not 
need to do this if you are on OneSync. 

*UPDATE*: This resource by default is meant to be played with onesync off (preferable), but has reportedly worked fine/ok with onesync legacy turned on with the onesync server.lua provided, as well as setting Config.UsingOneSync = true in missions.lua. Regular onesync turned on may make the resource unstable. These onesync settings are done in server.cfg
(If you are experiencing issues, after turning off other custom resources and doing the above try running on gamebuild 1604. If that is still an issue try running on the server artifact here: https://www.mediafire.com/file/aahzl5yslqhwpbv/FXServer_jan19.zip/file (very old server version, defaults to 1604 and default to onesync off).)

MIGRATION: There is no built in support for when a player whose machine spawned mission entities disconnects mid-mission. No NetIDs 
or calls to native Migration functions. Behavior can be unpredictable. NPCs may become inert etc... It does seem that there is some 
migration of the host's session to other connected peers built into the platform without calling these natives. 
If there are problems with the mission after a host leaves, then players can use the /vote commands to restart the mission, see the README.TXT. (I did test this on my local/private server, and regardless of which player left, the host, the non-host, the one who spawned the entities or not, the mission continued for the other player fine). 

RELATIONSHIP GROUPS AND MISSION PLAYERS: 
You may want to have it so that enemy npcs in missions only attack players that are in missions, rather than any player they see. 
You would need to add code that creates a new relationship group called "MISSION_PLAYER" or something, and add the players 
who are in the mission (See EnableOptIn and EnableSafeHouseOptIn settings, and the decor values: mrpoptin, mrpoptout) to that 
group. You would need to find and replace every instance of "HATES_PLAYER" with "MISSION_PLAYER". When players opt out of doing 
missions, you would remove them from the "MISSION_PLAYER" relationship group. Thats basically how you would do it. 

ONLY CERTAIN SKINS LIKE POLICE CAN TAKE MISSIONS: 
Similar to 'Relationship groups and Mission Players' check out EnableOptIn and EnableSafeHouseOptIn settings, and the decor values: mrpoptin, mrpoptout. You would need to add an extra check on the player's skin to see if the can accept the mission. 

CODE CLEANUP AND RE-WRITES: 
The code can do with a major cleanup. Much of the code in SpawnPed, SpawnAPed and SpawnRandomPed can be merged. 
Some functions that are no longer used can be removed. MissionBlips code can be improved, and probably a lot of other 
areas too. This was a huge learning curve over the last year playing with this tech and I can see how a re-write using more 
native GTA5/GTAO mp mission specific functions could be used from the start. A lot of stuff was bolted on. From the get-go 
I would start with focusing on triggering entites to spawn dynamically for only nearby players, which this resource will do,
but without the extra fluff. There will probably be benefits in adding NetworkGetNetworkIdFromEntity, NetToEnt etc.. calls using 
network id handle as well. This thread as some informative comments from a cfx/fivem project lead: https://forum.cfx.re/t/problem-with-vehicle-network-id/771619 , specifically the SetNetworkIdSyncToPlayer native mentioned that may fix the 300m streaming/collision range 
behavior that can be exhibited (see DESIGNING MISSIONS FOR PUBLIC SERVER SUPPORT VS LOCAL SERVER above)

Duplicate Spawning in Multiplayer.
The resource has been tested to work in MP. This should not happen, but if you are noticing duplicate spawns for Events in MP, some tidy up could probably happen around where sv:UpdateEvents
is called in client.lua. Instead of the client calling TriggerEvent doSquad etc... then calling sv:UpdateEvents, call sv:UpdateEvents first, and let that server function determine who should spawn the following: TriggerEvent doSquad etc.
Same with where sv:spawned is called in client.lua. SpawnAPed is called first, instead let logic on server side sv:spawned function decide who calls SpawnAPed.

Crashing with 'Object Pool'... errors
This should not happen, the resource has been tested and coded to not cause these errors (due to too many entitities spawned) but some missions like Mission60 can potentially have a lot of peds spawned. If this error happens, lower the peds spawned for the mission. peds vehicles spawned via Events would be the first choice to alter. 



