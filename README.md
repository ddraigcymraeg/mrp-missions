# mrp-missions
Crackdown Mission Resource for FiveM

See the README.TXT for installation, controls and other information about this resource. 
See the SHADOW STATE MISSION PACK README.txt file in shadowstate-missionpack.zip for information 
specfic to the 12 missions that are also incorporated in Missions.lua and use DLC areas. 
See Config_Guide.lua.txt for how to edit Missions.lua to edit and create your own missions.
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

DESIGNING MISSIONS FOR PUBLIC SERVER SUPPORT VS LOCAL SERVER: Most of this was designed for my private local server. Something I noticed during testing is that some mission designs may not work as well on a public server with more users and more latency etc... Sixsens who tested this resource on his public server helped me add better support for situations where entities stopped existing for peers when they were outside collision/streaming range (approx. 300m), but will come back into existence when a player is within 300m. You should use the MissionTriggerRadius setting to be around this value or less to make sure that the entities exist and are within range of a player to show any blips, and peform any mission tasks, etc.. During testing, on my local server, with much fewer players and less latency this was not a problem. Missions like Mission20 and Mission21 which spawn entities all around the map, *may* not be well suited to a public server, since players may not see the blips/locations of the entities, due to not being close enough. Many missions in Missions.lua were re-done with public server support in mind, where the mission entities only spawn when a player is nearby. Also using IndoorsMission=true with IndoorsMissionSpawnRadius (doesnt have to be an indoor mission) (see Missions.lua, Config_Guide.lua.txt and further down) can be extremely helpful, which Sixsens verified. Also, if you are having problems with mission quirkiness, set the MissionTriggerRadius to be <= 300. There are other missions too, like Mission16 which spawn entities around the map, and IsDefendTarget
 missions like Mission25 that use TaskPlaneChase,TaskHeliChase, TaskPlaneMission, TaskHeliMission etc... that the target uses to chase a dummy vehicle created by  the resource that can be across the map. If that does not work well, use the coordinate arguments for TaskPlaneMission, TaskHeliMission etc.. natives instead, which may work better in case the dummy vehicle does not exist due to being out of collision range. Verfied: In SpawnProps and SpawnRandomProp, you can change TaskHeliChase with TaskHeliMission using coords and mission flag 9 tested, and you can change TaskPlaneChase with TaskPlaneMission, but the mission flag will need to be 6. 

ONESYNC SUPPORT: 
This resource may have problems with OneSync servers. Depending on the mission, the server side script asks each client to return NetworkIsHost() and spawn missions entities on the one that is true. I gather with OneSync this will return true for all clients(?).
If that is a problem, you will need to change that code to either pick a random client, or use another solution to pick 
which client will be the host. Sixsens on forum.fivem.net has used this resource for his public RP server fine, but 
had to make some changes when he went to OneSync. One of the changes he made was to set IndoorsMission=true for 
missions, which will spawn entities dynamically on any player's machine which is closest to where the entity should spawn. 
He changed the hardcoded value for distance check (IndoorsMissionSpawnRadius) from 30m to 300m. Hopefully you will not 
need to do this if you are on OneSync. 

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



