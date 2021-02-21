# CrackDown: Missions and Mission Generator/Mission Creation Resource. 
See first post at the link below for all the information about mission types and the primary game mode:
https://forum.cfx.re/t/release-fivem-crackdown-game-mode-and-mission-generator-creation-beta/275613

NOTE: There seems to be a bug when the resource is started and set to automatically spawn the first mission when a player joins, and 2 or more players 
join at the same time. There can be sync issues. This could well be an issue with FiveM instead of this resource. This only happens when the FiveM server is started 
and 2 or more players join at the same time to be the first player joining the server, that there can be sync issues.  

Installation:
Install like any other FiveM Server Resource. Both mrp-missions-v3 and mrpStreetRaces need to be installed. 

'mrp-missions_spawn' is purely optional, and has defined player skins to spawn as. 

To build your own missions, check out the Config_Guide.lua.txt, and see notes below.

NOTE: If there is a problem with a checkpoint mission, BOTH mrp-missions-v3 and mrpStreetRaces may need to be restarted. 

NOTE: Sometimes there can synch issues when a server is started and  2 or more clients connect simultaneously, when the mission system is autostarted when server is up. 

NOTE: MORE CHALLENGING AI: AI mission backups can be summoned 1 per player at a $ cost (see below). This is turned on on missions.lua with DoMissionBackup=true. 
Unfortunately to get the enemy AI to work with friendly AI, the enemy AI can damage themselves. The solution I tried looks like it should work, but does not. 
To make the AI tougher much more fun and challening set DoMissionBackup=false to remove the AI backup. 

NOTE: $ GIVEN FOR MISSIONS: MissionShareMoney = true by default, where players share the mission $ rewards . This was added because the peer that spawned a ped or vehicle will
get a kill reward even when the peds kill themselves via crashing or whatever, not making it fair to other players. 
Causes of death provided by the natives will not cover all cases either, sometimes the ped seems to vanish, which is scored as a kill for the host. Setting this to false 
will bring up the old $ scoring, where players score for themselves. For both, $ losses come from player deaths, 
or buying vehicles/weapons/upgrades or killing hostages/protect targets etc…


CONTROLS (which can be turned on/off depending on mission config settings, and based on DEFAULT GTA5 binds): 

Mission Help in-game, which has all the control information below + more, can be viewed by pressing RIGHT STICK DOWN & LB.

Mission Stats can be viewed in the lower right hand side by pressing DPAD DOWN or '[' key

Players can press  (LEFT STICK & LB) of their gamepad oe equivalent keys,  to call in an air drop of mission weapons and upgrades for a $ cost. If they dont want to make it to the safe house.
The safe house has to be open for this work.

Players can press  (LEFT STICK DOWN & RB) of their gamepad or equivalent keys, to toggle a Mission Reinforcement Drop at their location. When on, players can fast travel there after they respawn using the  (RIGHT STICK DOWN & RB) or equivalent keys.

Players can press  (RIGHT STICK DOWN & DPAD LEFT) of their gamepad or equivalent keys, to spawn a mission ally nearby to help with combat and ride in turrets etc... 
Players can press  (RIGHT STICK DOWN & DPAD RIGHT) of their gamepad or equivalent keys, to cycle through different ally types, like 
regular which gets same equipment as player for mission, as well as by default: RPG, Homing Launcher and Minigun.
Players can press  (RIGHT STICK DOWN & DPAD DOWN) of their gamepad or equivalent keys to dismiss an ally. 
Players can press  (LB & RB) of their gamepad or equivalent keys to swap seats with their backup if they are both in the vehicle.

Players can press (RB + DPAD DOWN) of their gamepad or equivalent keys to repair their vehicle at a $ cost, if they are within 5 meters of it, or inside it. The safehouse has to be open though.
Players can press (RB + DPAD LEFT) of their gamepad or equivalent keys to heal the character they are defending at a $ cost, if they are  within 2 meters of them. The safehouse has to be open though.

There is a working RC Bandito remote detonation vehicle as well to use on missions. Use LB on the gamepad, or E key to detonate it. Holding the button/key or repeatedly pressing 
the buttons/keys will repeatedly causes explosions until the rcbandito blows up.

Players can spawn/deploy rcbandito remote detonate vehicles on the fly using RB+DPAD-RIGHT or A + D keys. This will use one of their safe house vehicles for the mission though, will cost same $ amount 
as a safehouse vehicle, and players will need to wait until the safehouse is open to be able to deploy.

Players can toggle night vision and thermal vision if enabled. Player will press and hold both Left stick down + right stick down ( C + Left Ctrl by default) to cycle through.

For IsDefendTarget missions, where the target is a vehicle, and the player is within a range of the vehicle, Pressing 
DPAD LEFT AND LB PRESSED ('E' key and 'SCROLLWHEEL UP' key) will have the player enter (teleport to) the drivers seat if empty,
else any turret seat if empty, else any passanger seat if empty. This can make some escort/transport missions more fun.

When in a vehicle, and an AI Backup is the vehicle with the player, pressing LB + RB or Q + E keys (default) will swap the seat you are in with you backup's seat. This can
be helpful for switching to a turret, or letting AI drive etc...

If EnableOptIn or EnableSafeHouseOptIn is turned on:
Players press ‘Q’ and ‘]’ keys or RB + DPAD UP together to join an active mission. (with EnableSafeHouseOptIn player has to be 
at the safehouse marker.)
Players Press RB + DPAD DOWN or 'Q' and '[' keys together to stop particpating in missions, only after a mission is over and 
another has not started. 

COMMANDS FOR ADMINS AND PLAYERS:
In the chat you can use “/stop” to stop missions running. “/list” to list all available mission names. Then “/mission ‘MissionName’” 
(i.e. /mission Mission9) to start the mission. NOTE: These commands can be run by any player, so you need to provide your own security/permissions. Again, you can configure the resource to not teleport players to the safe house on mission start, turn crate drops on/off etc… (see paste link above)

Players can create a ballot to cancel the the current mission using “/votefinish”. Players can then vote using /voteyes and /voteno See the bottom of server.lua to configure voting settings, if you run a public server you will need to configure it. (All credit to FAXES for his Vote-to-Kick voting system which I used and adapted, see credits below.)
You can also create a vote to cancel a mission to start a new one.
If you are on mission 12 and want to create a ballot for Mission9, you can type in chat:
‘/votefinish Mission9’ or just use ‘/votefinish’ to create a ballot to cancel the mission.
By default, the server will wait 10 seconds before starting a new mission if the vote passes.


ESX SUPPORT:
For ESX money support, in client.lua and server.lua set UseESX=true

MISSION INFORMATION AND MAKING YOUR OWN MISSIONS:



'missions.lua' has 52 example missions of various types. 

I added all 12 of the Shadow State Mission Pack missions to Missions.lua. If you have problems with any of these 12 missions not working, 
see below, and the readme in the shadowstate-missionpack.zip. YOU WILL NEED AN IPL LOADER AND TELEPORTAION RESOURCE TO GET TO AREAS FOR THESE MISSIONS TO WORK, which is provided in the zip above.


NOTE: To complete the ‘Killing Floor’ Mission30 at Humane Labs, you will need to have a teleport resource enabled to allow players to go up and down between the 2 levels (or add submergibles or water breathers to come through the tunnel.) . The “doombunkers” resource included in the Shadow State Mission Pack archive in the zip file will do that.

NOTE: To Complete 'Ghostbusters' Mission33 its the same thing, you will also need an ipl loader that loads a loft/apt/condo at Maze Bank Tower. The “fivem-ipl” resource included in the Shadow State Mission Pack archive in the zip file will do that. OR, add some aicraft to the safe house or the map, the former is what the mission is designed for. 

NOTE: I have now included all 12 of the Shadow State Mission Pack missions in Missions.lua. These missions need an ipl loader 
like fivem-ipl resource and a teleportation resource like 'doombunkers', both which are included in the shadowstate-missionpack.zip
Since these missions are mainly in DLC areas. If you already have and ipl loader with teleportation markers, you may still need to edit 
the mission Blip coordinates and maybe other coordinates too, or the missions may not work. 
These are missions 30 and 33, and 35 -> 42. If you can get a mission to work, remove it from Missions.lua, but make sure that 
the mission names are reordered... so if you remove Mission39 say, Mission40 will need to be Mission39 now and so on.



See link above for more details and how to use. 

Mission comments for building your missions: 

Mission1 is a standard 1 Objective mission, that also has events added. 
Mission2 is a HostageRescue mission that also has an event with a custom notify message
Mission3 is an Assassinate mission that has a vehicle following/chasing another vehicle,
this one stationary.
Mission4 is an Assassinate mission that has a vehicle following/chasing another vehicle 
that is moving.
Mission5 is an Assassinate mission that also has a friendly to rescue
Mission6 is a multi-objective mission that has 3 objectives to capture and 1 hostage to 
(optionally) rescue. It also has custom props added, and events, one which will spawn a 
random enemy vehicle, another random enemy peds.
Mission7 is a standard 1 Objective mission, that also has an event with a custom notify message 
and custom props.
Mission8 is a standard 1 Objective mission, that also has events, custom props and a vehicle 
chasing/following another vehicle, this one stationary.
Mission9 is a standard 1 Objective mission, that also has events and custom props, and a vehicle 
chasing/following another vehicle, this one stationary.
Mision10 is an Assassinate + IsDefend mission where players have to stop enemies making it to a zone they must 
defend. It has a custom mission start point, and a few custom safehouse options which alter the 
default safe house behaviour. 
Mission11 is a standard 1 Objective mission, that has custom reward pickups defined for mission completion. 
Mission12 is a randomly generated mission (IsRandom) that is a standard 1 objective mission that uses RandomMissionPositions array to spawn a mission. 

Mission13 is an Assassinate + IsDefend + IsDefendTarget mission that has players defending a target on foot. It has SetBlockingOfNonTemporaryEvents attribute set to true for 1/2 the enemies. All enemies will chase the 
target due to IsDefendTargetChase=true, and the ones with SetBlockingOfNonTemporaryEvents=true, will attack 
the target when within 10m of them, due to IsDefendTargetAttackDistance = 10.0. Also other settings as well,
like removing all weapons from mission players at mission start, and a custom mission start point, etc... 
Also, custom movespeed attribute is set 1.0 for walking, 2.0 for running for NPCs
IsDefendTargetEntity defined the target ped. Blip2 and Blip are at the same, since target ped is stationary, 
and has IsDefendTargetSetBlockingOfNonTemporaryEvents=true set to true, so they dont run off. 

Mission14 is an Assassinate + IsDefend + IsDefendTarget mission, similar to Mission13, but for vehicles. The target ped to defend is in 
a vehicle. Of note: IsVehicleDefendTargetChase=true makes enemy NPCs in vehicles chase the target. IsDefendTargetEntity defines the target NPC and vehicle, and they have movetocoord set to make them drive at a movespeed rate. 
Blip2 is where the target spawns, but you can also use SpawnAt={x=...,y=...,z=...} inside IsDefendTargetEntity to 
have the target + vehicle spawn at a custom position. Blip is the destination, where their movetocoord points to, and since IsDefendTargetRewardBlip = true, a marker with IsDefendTargetGoalDistance radius, and money reward of
GoalReachedReward = 1000 if the target makes it there, to complete the mission. 
The mission can also be completed if all enemies are eliminated, like any other IsDefend/IsDefendTarget mission. 
IsDefendTargetDoPlaneMission=true, makes planes AI slightly different than if it is false, worth experimenting with, 
may not make a difference. 
It also has custom safe house mission vehicles spawn in the mission's Vehicles array. These must come after any enemy 
NPC vehicles, and not have id2 attribute defined. 

Mission15 is basically the same as Mission14, except there is no destination (So Blip and Blip2 are the same), the 
target to defend (IsDefendTargetEntity) has driving=true which basically makes them wander, or drive from the enemy NPCs. 
IsDefendTargetRescue = true in this case so the target can be rescued to complete the mission without killing all the enemy NPCs.
It also has npcs with conqueror=true, which is basically the same as having SetBlockingOfNonTemporaryEvents=true

Mission16 Assassinate + IsDefend mission, where players have to defend a zone from enemy incursion. This highlights how you 
can define each specific vehicle driver to follow/escort/defend another vehicle, with via attributes like:
VehicleGotoMissionTarget=true,VehicleGotoMissionTargetVehicle=2
where the 2 is the vehicle index of a vehicle that is defined BEFORE the vehicle with the attributes. 
It also has a mission defined VehicleGotoMissionTargetVehicle=9, which is the default mission vehicle id to follow. 
See the bombushka, which just has VehicleGotoMissionTarget=true set. If no VehicleGotoMissionTarget attribute is set, 
the vehicle will do default behavior. 
This mission also has a  event, with the attributes, that spawns a vehicle: 		
DoIsDefendBehavior=true, <-- Tells the vehicle driver spawned to act like other AI driver in an IsDefend/IsDefendTarget mission.
IsDefendTargetTriggersEvent = true, <-- this event can be triggered by an IsDefendTarget ped (none in Mission16)
There is also DoBlockingOfNonTemporaryEvents=true, which is the same as setting SetBlockingOfNonTemporaryEvents=true for the ped

Mission17 is a HostageRescue IsRandom + IsRandomSpawnAnywhere randomly generated mission. See RandomMissionTypes attribute.
It means that it will spawn a mission anywhere within IsRandomSpawnAnywhereCoordRange. Since RandomMissionDoLandBattle is true,
it will only spawn ped/vehicles on land. IsRandomEvent=true, means that a single random event will spawn when players get close 
enough. RandomMissionGuardAircraft=true, means that a random, aircraft will spawn that will guard the mission object blip area. 
There are a lot of other random mission settings as well. See missions.lua and Config_Guide.lua.txt for more information.  

Mission18 is basically the same as Mission17, except RandomMissionTypes ={"BossRush"}, where Boss peds that are tougher are made 
the targets to eliminate to complete the mission. 

Mission19, is the same as Mission13, except randomly generated: IsRandom=true and RandomMissionTypes ={"Assassinate"}. 
RandomMissionPositions is defined on Mission19 at a specific location. 
IsDefendTargetOnlyPlayersDamagePeds=false, overrides the default whereby enemy NPCs are only damage by peds, since the 
target to defend will be fighting back this time. There are a lot more mission specific overrides set as well. 

Mission20 is similar in many ways to random missions 17 and 18, except IsBountyHunt=true. Since RandomMissionTypes ={"Assassinate"}, 
it will spawn targets to eliminate via RandomMissionMinPedSpawns... etc..., but since IsBountyHunt=true, it will spawn squads or 
protectors and at least one other target to eliminate with each main ped/vehicle.  See the other *Bounty* attributes 
which define squad size and range etc... also missions.lua and Config_Guide.lua.txt for more information.
NOTE, RandomMissionSpawnRadius = 6000.0, So it will spawn groups of peds/vehicles around the map. 
Also, IsBountyHuntDoBoats=true, which means if water is found when spawn a vehicle, spawn a boat. 

NOTE: Missions 17 + 18 spawn in a way not to spawn on rooftops, via ray tracing, but doesnt always work great around mountains, where 
you can get peds in the air sometimes or under the map, until they become aware of the players. 
Mission20 spawning with squads, I find works great around mountains, and if you want to spawn on rooftops more, use that in cities 
as well. 

Mission21 is pretty much the same as Mission20, except rescuing hostages, RandomMissionTypes ={"HostageRescue"}, where squads are defending the hostages. 

Mission22 is in some ways the same as Mission12, a randomly generated  1 Objective mission, RandomMissionTypes ={"Objective"}, 
except, IsRandomSpawnAnywhere=true, so spawns anywhere on the map and IsBountyHunt=true, so squads of peds will spawn around default 
defined peds in a way, similar to Mission20 and Mission21, except the RandomMissionSpawnRadius = 250.0, is much smaller and localized.

Mission23 is the same as Mission22, except RandomMissionTypes ={"Assassinate"},	where targets peds to eliminate are spawned, with 
regular squads of body guards.

Mission24 is a random mission version of Mission14. Since IsRandom=true, we use
 IsDefendTargetSetBlockingOfNonTemporaryEvents=true, to make the target ped driver to stick to the task. It uses similar attributes as Mission14, except IsVehicleDefendTargetGotoGoal=true, is set as well.  
 IsVehicleDefendTargetGotoGoal=true, makes the target ped drive/fly to one of the 
 RandomMissionDestinations randomly chosen. 
 Blip2 gets set to RandomMissionPositions[N].Postion, the start, where the target ped starts. 
 Enemies spawn around RandomMissionDestinations[M].x etc... by default. 
 
 Also, RandomMissionPositions also has 
 DefendTargetInVehicle = true,
DefendTargetVehicleMoveSpeedRatio = 0.5, --have vehicle move at 1/2 top speed

telling the mission system to set the target ped to drive a land vehicle, defined in 
IsDefendTargetRandomVehicles array, at 1/2 top speed. 


Mission25 is the same as Mission24, except for aircraft, where in 
	RandomMissionPositions: 
	DefendTargetInVehicle = true,
	DefendTargetVehicleIsAircraft=true,

	and an aircraft is randomly chosen from IsDefendTargetRandomAircraft array


Mission26 is the same as Mission24, exept we have in
RandomMissionPositions: 
	DefendTargetInVehicle = true,
	DefendTargetVehicleIsBoat=true,
	
and a boat is randomly chosen fromIsDefendTargetRandomBoat array

Mission27 is the same as Mission24, except IsDefendTargetPassenger=true. So the target ped to defend 
is a passenger that the player must drive to the destination. Default seatid is 0 for target passenger.
This can be overidden by using IsDefendTargetPassengerSeatId to define what seat id to go in. 

Mission28 is the same as Mission25, except the player ped must fly the target to the destination, since 
IsDefendTargetPassenger=true

Mission29 is the same as Mission26, except the player ped must drive/sail the target to the destination, since 
IsDefendTargetPassenger=true

NOTE: RandomMissionDestinations in this case has a SpawnAt={x=...,y=...,z=...} attribute which will force the 
random enemies to spawn around a different location instead of at the destination location (default)

Mission30 is a multi-objective mission, but with IndoorsMission = true, This means that ped and vehicles will 
only spawn when a player is nearby. This was needed to be added for places like Humane Labs and DLC indoor areas, 
where NPC skins would be invisble otherwise for some reason(?). SafeHouseSniperExplosiveRoundsGiven is set to 0,
which is a way to nerf exposive round amounts= given at the safe house, for the heavy sniper rifle, this case 0.
Events are used as well. 

Mission31 is a Multi-objective mission that has a lot of events.

Mission32 is a Multi-objective mission with 1 objective, with a lot of events. Also a lot of custom safe house settings,
to teleport mission players into the bank vault, so they can fight their way out. A large custom prop as objective too.

Mission33 is a standard 1 objective mission with a lot of events, and custom props. 

Mission34 is a version of Mission24, except similar to Mission15, in that there is no destination, the target to defend 
 drives and wanders, or evades enemies, which you must eliminate to save the target. 
 

Mission39 is an example of a mission that uses Blips array to have multi objective mission blips

Mission42 is an example of the use of  NextMission and NextMissionIfFailed mission attributes to combine missions into 
stages, where if a mission is passed the next is loaded right away, else if failed, you need to restart the mission. 
This can be done to create campaigns/multi stage missions that join together.

Mission43 is the same as Mission25, except all aircraft are helicopters 
Mission44 is the same as Mission28, except all the aircraft are helicopters

Mission45 is the first Type=Checkpoint mission, which is random, meaning checkpoints are spawned randomly around the whole map. 
For Mission45, these checkpoints are only spawned on land, and anywhere on land, not just roads.
so IsRandom = true, & IsRandomSpawnAnywhere=true is set. and so can IsRandomSpawnAnywhereCoordRange = {xrange={-1000,3000},yrange={3000,5000}},
where like any IsRandom = true, & IsRandomSpawnAnywhere=true mission, it can can specify a part of the map to spawn within.
https://drive.google.com/file/d/0B-zvE86DVcv2MXhVSHZnc01QWm8/view

Various enemies are spawned at each checkpoint, which is also randomized. The rewards set for killing enemies should be set to 
0 for Checkpoint missions, and set  MissionShareMoney=false, -preferrable to set this to false, since players are competing more in Checkpoint missions, and that 
should be the main source of money. 



The following settings are used by random checkpoint races:
MaxCheckpoints=10, --Min is 2, so here between 2 and 10 checkpoints can be spawned randomly around the map for the race
CheckpointsDoLand=true, --force checkpoints to only spawn on land, if true other 2 settings need to be set to false.
CheckpointsStartPos={x=0.0,y=0.0,z=0.0}, --leave as this for random checkpoint races
RecordedCheckpoints={}, --leave as this for random checkpoint races
CheckpointsDoWater=false, --force checkpoints to only spawn on water, if true other 2 settings need to be set to false.
CheckpointsDoWaterAndLand=false, --force checkpoints to spawn on both water and land, if true other 2 settings need to be set to false.
SpawnCheckpointsOnRoadsOnly=false,  --force generated checkpoints to spawn only on roads/trails. if CheckpointsDoLand=true or  CheckpointsDoWaterAndLand=true
CheckpointsAirBattle=false, --only spawn enemy aicraft from each checkpoint, good for flying missions.
CheckPointClaimdReward=1000, --drivers and passengers get this $ if the vehicle reaches the checkpoint first
RaceWinReward=20000, --only driver gets this in the winning vehicle
CheckpointRaceJoinTime=3600, --not used
MissionShareMoney=false, --preferrable to set this to false, since players are competing more in Checkpoint missions. 

Mission46 A non-random, regular Checkpoint race mission around Mt Chiliad. For this type of mission, most of the Checkpoint mission settings in Mission45 are not used. 
All that needs to be defined is: 
Type = "Checkpoint"
CheckpointsStartPos={ x = 2526.39, y = 5154.27, z = 55.24}, --where the race starts
Events = {...} --your own created events to generate enemies for the race. 
RecordedCheckpoints={{blip=blip,coords={x = 2474.65, y = 5238.01, z = 68.19}}, etc... --the checkpoints themselves (include blip=blip for now for each checkpoint, 
 though it may work without it)
 There is a safehouse and vehicle safe house both defined for the mission to spawn near the start of the race
 You can also use Peds={} and Vehicles={} like any regular mission... for spawning enemies/hostages, extra vehicles for players or enemy vehicles
CheckPointClaimdReward=1000, --drivers and passengers get this $ if the vehicle reaches the checkpoint first
RaceWinReward=20000, --only driver gets this in the winning vehicle

Mission47 is the same as Mission46, except there are no enemies (Events is blank) 
 
Mission48 is the same as Mission45, except that CheckpointsAirBattle=true so all enemies that spawn are aircraft guarding checkpoints. 
CheckpointsDoLand=true is set so all checkpoints are on land
 The players get hydras and the enemy planes are defined as so.. so it is an air battle check point race mission: 
 SafeHouseAircraft = 
{
"Hydra",
},
RandomMissionAircraft = {
	"hydra",
	"lazer",
	"strikeforce",
	"starling",
	"rogue",
	"nokota",
	"molotok",
	"pyro",
},

 
Mission49 is the same as Mission45, but SpawnCheckpointsOnRoadsOnly=true, so all  checkpoints spawn on road/trail nodes. 
Also IsRandomSpawnAnywhereCoordRange is set to only spawn checkpoints in the lower part of San Andreas, basically in the city and up to vinewood.

Mission50 is the same as Mission45 but CheckpointsDoWater=true, and IsRandomSpawnAnywhereCoordRange is set to only spawn checkpoints in The Alamo Sea. 
when CheckpointsDoWater=true, only boats or amphibious enemys are spawned. A mission boat safehouse is used for the mission as well and is the near the race start.

Mission51 is the same as Mission50, except CheckpointsDoWaterAndLand=true and IsRandomSpawnAnywhereCoordRange is set to be around the Alamo Sea to include land. 
So checkpoints are spawned in land and sea. Players will need to use the mission boat safehouse and mission land safehouse (or steal vehicles) to finish the race.

Mission52 is another ObjectRescue mission this time every ebemy spawned is through events.


	









 







