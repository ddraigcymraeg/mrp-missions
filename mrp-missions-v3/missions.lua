Config = {}
Config.RandomMissions = true --set false for linear progression
Config.MissionSpaceTime = 30000 --milliseconds between missions
--these below can be overriden per mission
Config.MissionLengthMinutes = 60
Config.MissionNoTimeout = false

--whole map
Config.MissionTriggerRadius = 15000.0

--spawn a mission on first player join?
Config.StartMissionsOnSpawn = true
Config.TargetKillReward = 250 --cash
Config.KillReward = 100 --cash
Config.KillVehiclePedBonus = 50 --cash
Config.KillBossPedBonus = 100 --cash
Config.FinishedObjectiveReward = 5000 --cash
Config.HostageKillPenalty = 1000  --cash
Config.HostageRescueReward = 200  --cash
Config.IsDefendTargetRescueReward = 20000
Config.IsDefendTargetKillPenalty = 2000
Config.ObjectRescueReward = 3000

Config.GoalReachedReward = 2000

--Spawn mission vehicles with a random livery
--provides more variety in how vehicles look
Config.MissionVehicleRandomizeLiveries=true

--show help notifications on how to play and controls at mission start?
Config.DoHelpScreens = false

--show bottom of the screen mission description text when mission starts?
--now replaced by SMS texts.
Config.ShowMissionIntroText=false

--THESE MISSION SMS SETTINGS SHOULD BE SET PER MISSION:
--LENGTH OF SMS_ContactPics, SMS_ContactNames, etc... NEED TO BE THE SAME LENGTH:
--ONE WILL BE CHOSEN RANDOMLY, BUT SAME INDEX FOR ALL ARRAYS
Config.SMS_ContactNames={"Military Contact","Agency Contact","Military Contact",
"Agency Contact","Agency Contact"
}

--see: https://wiki.rage.mp/index.php?title=Notification_Pictures
Config.SMS_ContactPics={"CHAR_MP_ARMY_CONTACT","CHAR_AGENT14","CHAR_BOATSITE2",
"DIA_PRINCESS","CHAR_STEVE"
}



Config.SMS_ContactSubjects={"New Mission","New Mission","New Mission","New Mission","New Mission",}

Config.SMS_ContactMessages={"Need Help with a mission","Need Help with a mission",
"Need Help with a mission","Need Help with a mission","Need Help with a mission"}


Config.SMS_ContactPassedSubjects={"Great Job!","Great Job!","Great Job!","Great Job!","Great Job!",}

Config.SMS_ContactPassedMessages={"Good working with you","Good working with you",
"Good working with you","Good working with you","Good working with you"}

Config.SMS_ContactFailedSubjects={"What happened?","What happened?","What happened?","What happened?","What happened?",}

Config.SMS_ContactFailedMessages={"This is terrible news!","This is terrible news!",
"This is terrible news!","This is terrible news!","This is terrible news!"}

Config.SMS_PlaySound = true

--Make mission title the sms subject, ignoring SMS_ContactSubjects array?
Config.SMS_MissionTitle = true
--Make mission message the sms message, ignoring SMS_ContactMessages array?
Config.SMS_MissionMessage = true


--Do players that are in the mission (see Config.EnableOptIn/Config.EnableSafeHouseOptIn) 
--share the money between them? if optin in is not set, and this is true, then all players share money
Config.MissionShareMoney = true


-- OPT-OUT/OPT-IN SETTINGS. NOT PER MISSION, ONLY GLOBAL:

--IF EITHER EnableOptIn OR EnableSafeHouseOptIn IS true, THE OTHER HAS TO BE false:
--This allows players to simply press ‘Q’ and ‘[’ keys or RB + DPAD DOWN together to join an active mission:
Config.EnableOptIn = false
--requires the player to journey to the safehouse marker (they will see the safehouse blip on the map) 
--and press either ‘]’ key or DPAD UP in order to join the mission:
Config.EnableSafeHouseOptIn = false
--When set to true, when a mission is active and a player is not opted in, it displays text in the lower RHS 
--that there is an active mission with directions on how to join:
Config.EnableOptInHUD = false
--This forces all players to opt out of the mission system at mission end, forcing them to opt back in for the next mission. 
--Does not remove weapons, but removes buffs:
Config.ForceOptOutAtMissionEnd = false

--END OPT-OUT/OPT-IN SETTINGS

--Set this to true to remove all weapons and upgrades (Crackdown mode buffs if enabled) at the mission end. 
--This should be used with one of the 2 OptIn bove settings set to true, else it will remove weapons from everyone.
Config.RemoveWeaponsAndUpgradesAtMissionEnd = false

--Similar: Remove any previous upgrades/weapons before
--supplying new upgrades/equipment for the mission
--players need to be opted in if OptIn is enabled
Config.RemoveWeaponsAndUpgradesAtMissionStart = false


--Player will press and hold both Left stick down + right stick down ( C + Left Ctrl by default) (CROUCH/STEALTH + BEHIND VIEW) to toggle
Config.EnableNightVision=true
Config.EnableThermalVision=true


Config.DrawText3D = true

Config.DrawTargetMarker = true

Config.DrawRescueMarker = true

Config.DrawIsDefendTargetMarker = true

Config.DrawObjectiveRescueMarker = true

Config.DrawObjectiveMarker = true

Config.DrawIsDefendMarker = true

--set to true, to turn off only damaged by player
--Makes HostageRescue missions quite a bit harder
Config.DelicateHostages = false


--**Set this to true if you encounter any 'hidden' NPCs (behind walls) that are not accessible in random mission generator missions
--This will happen very occasionally, and this will/should fix that occuring. 
--The upshot when this is set to true, is that NPCs will not spawn underneath structures as much, like in tunnels,
--or under the pier say. 
--You can use RandomMissionPositions with force=true to make NPCs spawn underneath 
--structures and in tunnels, but only Objective type missions (not Assasinate missions) will be generated 
--since the codebase does not stop NPCs spawning behind walls in this case. 
--This only applies to Random Mission Generator missions, not Regular, where you can have NPCs spawn wherever you want. 
--Config.CheckAndFixRandomSpawns=false --DISABLED
--**--

Config.CleanupPickups = true --cleanup any remaining pickups when a new mission starts?

Config.EnemiesCanSpawnPickups = false --< experimental
										--  now will try to spawn a weapon from the what the ped had, does not seem to spawn the same weapon, *seems* to be random.
Config.EnemySpawnedPickupsChance = 10 --Percent Chance to spawn a pickup
Config.EnemySpawnedPickups = {
	"PICKUP_HEALTH_SNACK",
	"PICKUP_HEALTH_STANDARD",
}	

Config.SetPedDropsWeaponsWhenDead = true

--accuracy range of peds, default is 60, max is 100
Config.SetPedMinAccuracy = 60 
Config.SetPedMaxAccuracy = 60
								 
														 
----THESE ARE NOT SUPPORTED PER MISSION ONLY GLOBAL:
--Default Player MaxHealth Amount:
Config.DefaultPlayerMaxHealthAmount = 200									 
--give player health and armor back when they win mission?	
Config.RegenHealthAndArmourOnReward = true	
--Turn on Regen like Halo for Health and Armor?
Config.RegenHealthAndArmour = true	
----
								 
--TURNING ON MEANS THAT WHEN A HOSTAGE IS KILLED MISSION IS OVER							 									 
Config.HostageRescue = false	

Config.FailedMessage = "Mission Failed!"						 

--can be used with safehouses...but are meant as an alternative			
Config.SpawnMissionPickupsOnPlayer = false
Config.SpawnMissionComponentsOnPlayer = false 

--used with safe houses or by themselves
Config.SpawnRewardPickupsOnPlayer = true
Config.SpawnRewardComponentsOnPlayer = true 

Config.SpawnMissionPickups = {"WEAPON_COMBATPISTOL","weapon_heavysniper_mk2","weapon_marksmanrifle_mk2","weapon_heavysniper","weapon_combatmg_mk2","weapon_combatmg",
"weapon_carbinerifle_mk2","weapon_assaultrifle_mk2","weapon_specialcarbine_mk2","weapon_bullpuprifle_mk2","weapon_advancedrifle","weapon_pumpshotgun_mk2","weapon_assaultshotgun",
"weapon_smg_mk2","weapon_assaultsmg","weapon_pistol_mk2","weapon_snspistol_mk2","weapon_revolver_mk2","WEAPON_KNIFE","GADGET_NIGHTVISION","WEAPON_GRENADE","WEAPON_PROXMINE","WEAPON_STICKYBOMB","WEAPON_PIPEBOMB","WEAPON_FLARE",
"weapon_molotov","weapon_hominglauncher","WEAPON_RPG","GADGET_PARACHUTE","weapon_microsmg"
}

Config.SpawnMissionComponents = {"COMPONENT_AT_PI_SUPP WEAPON_COMBATPISTOL","COMPONENT_COMBATPISTOL_CLIP_02 WEAPON_COMBATPISTOL","COMPONENT_HEAVYSNIPER_MK2_CLIP_EXPLOSIVE weapon_heavysniper_mk2",
"COMPONENT_AT_SCOPE_MAX weapon_heavysniper_mk2",
"COMPONENT_HEAVYSNIPER_MK2_CLIP_EXPLOSIVE weapon_heavysniper_mk2",
--"COMPONENT_AT_SCOPE_THERMAL weapon_heavysniper_mk2",
"COMPONENT_AT_SCOPE_LARGE_FIXED_ZOOM_MK2 weapon_marksmanrifle_mk2","COMPONENT_MARKSMANRIFLE_MK2_CLIP_FMJ weapon_marksmanrifle_mk2","COMPONENT_AT_SCOPE_MAX weapon_heavysniper",
"COMPONENT_AT_SCOPE_MEDIUM_MK2 weapon_combatmg_mk2","COMPONENT_COMBATMG_MK2_CLIP_INCENDIARY weapon_combatmg_mk2","COMPONENT_COMBATMG_CLIP_02 weapon_combatmg","COMPONENT_AT_SCOPE_MEDIUM weapon_combatmg",
"COMPONENT_CARBINERIFLE_MK2_CLIP_ARMORPIERCING weapon_carbinerifle_mk2","COMPONENT_AT_SCOPE_MEDIUM_MK2 weapon_carbinerifle_mk2",
"COMPONENT_ASSAULTRIFLE_MK2_CLIP_FMJ weapon_assaultrifle_mk2","COMPONENT_AT_SCOPE_MEDIUM_MK2 weapon_assaultrifle_mk2",
"COMPONENT_SPECIALCARBINE_MK2_CLIP_INCENDIARY weapon_specialcarbine_mk2","COMPONENT_AT_SCOPE_MEDIUM_MK2 weapon_specialcarbine_mk2",
"COMPONENT_BULLPUPRIFLE_MK2_CLIP_ARMORPIERCING weapon_bullpuprifle_mk2","COMPONENT_AT_SCOPE_SMALL_MK2 weapon_bullpuprifle_mk2",
"COMPONENT_ADVANCEDRIFLE_CLIP_02 weapon_advancedrifle","COMPONENT_AT_SCOPE_SMALL weapon_advancedrifle",
"COMPONENT_PUMPSHOTGUN_MK2_CLIP_EXPLOSIVE weapon_pumpshotgun_mk2","COMPONENT_AT_SCOPE_SMALL_MK2 weapon_pumpshotgun_mk2",
"COMPONENT_ASSAULTSHOTGUN_CLIP_02 weapon_assaultshotgun",
"COMPONENT_SMG_MK2_CLIP_HOLLOWPOINT weapon_smg_mk2","COMPONENT_AT_SCOPE_SMALL_SMG_MK2 weapon_smg_mk2",
"COMPONENT_ASSAULTSMG_CLIP_02 weapon_assaultsmg","COMPONENT_AT_SCOPE_MACRO weapon_assaultsmg",
"COMPONENT_PISTOL_MK2_CLIP_HOLLOWPOINT weapon_pistol_mk2","COMPONENT_AT_PI_RAIL weapon_pistol_mk2",
"COMPONENT_SNSPISTOL_MK2_CLIP_FMJ weapon_snspistol_mk2","COMPONENT_AT_PI_RAIL_02 weapon_snspistol_mk2",
"COMPONENT_REVOLVER_MK2_CLIP_INCENDIARY weapon_revolver_mk2","COMPONENT_AT_SCOPE_MACRO_MK2 weapon_revolver_mk2",
"COMPONENT_MICROSMG_CLIP_02 weapon_microsmg"
} --space between attachment/component and weapon it goes on





Config.SpawnRewardPickups = {"WEAPON_COMBATPISTOL","weapon_heavysniper_mk2","weapon_marksmanrifle_mk2","weapon_heavysniper","weapon_combatmg_mk2","weapon_combatmg",
"weapon_carbinerifle_mk2","weapon_assaultrifle_mk2","weapon_specialcarbine_mk2","weapon_bullpuprifle_mk2","weapon_advancedrifle","weapon_pumpshotgun_mk2","weapon_assaultshotgun",
"weapon_smg_mk2","weapon_assaultsmg","weapon_pistol_mk2","weapon_snspistol_mk2","weapon_revolver_mk2","WEAPON_KNIFE","GADGET_NIGHTVISION","WEAPON_GRENADE","WEAPON_PROXMINE","WEAPON_STICKYBOMB","WEAPON_PIPEBOMB","WEAPON_FLARE",
"weapon_molotov","weapon_hominglauncher","WEAPON_RPG","GADGET_PARACHUTE","weapon_microsmg"
}

Config.SpawnRewardComponents = {"COMPONENT_AT_PI_SUPP WEAPON_COMBATPISTOL","COMPONENT_COMBATPISTOL_CLIP_02 WEAPON_COMBATPISTOL","COMPONENT_HEAVYSNIPER_MK2_CLIP_EXPLOSIVE weapon_heavysniper_mk2",
"COMPONENT_AT_SCOPE_MAX weapon_heavysniper_mk2",
"COMPONENT_HEAVYSNIPER_MK2_CLIP_EXPLOSIVE weapon_heavysniper_mk2",
--"COMPONENT_AT_SCOPE_THERMAL weapon_heavysniper_mk2",
"COMPONENT_AT_SCOPE_LARGE_FIXED_ZOOM_MK2 weapon_marksmanrifle_mk2","COMPONENT_MARKSMANRIFLE_MK2_CLIP_FMJ weapon_marksmanrifle_mk2","COMPONENT_AT_SCOPE_MAX weapon_heavysniper",
"COMPONENT_AT_SCOPE_MEDIUM_MK2 weapon_combatmg_mk2","COMPONENT_COMBATMG_MK2_CLIP_INCENDIARY weapon_combatmg_mk2","COMPONENT_COMBATMG_CLIP_02 weapon_combatmg","COMPONENT_AT_SCOPE_MEDIUM weapon_combatmg",
"COMPONENT_CARBINERIFLE_MK2_CLIP_ARMORPIERCING weapon_carbinerifle_mk2","COMPONENT_AT_SCOPE_MEDIUM_MK2 weapon_carbinerifle_mk2",
"COMPONENT_ASSAULTRIFLE_MK2_CLIP_FMJ weapon_assaultrifle_mk2","COMPONENT_AT_SCOPE_MEDIUM_MK2 weapon_assaultrifle_mk2",
"COMPONENT_SPECIALCARBINE_MK2_CLIP_INCENDIARY weapon_specialcarbine_mk2","COMPONENT_AT_SCOPE_MEDIUM_MK2 weapon_specialcarbine_mk2",
"COMPONENT_BULLPUPRIFLE_MK2_CLIP_ARMORPIERCING weapon_bullpuprifle_mk2","COMPONENT_AT_SCOPE_SMALL_MK2 weapon_bullpuprifle_mk2",
"COMPONENT_ADVANCEDRIFLE_CLIP_02 weapon_advancedrifle","COMPONENT_AT_SCOPE_SMALL weapon_advancedrifle",
"COMPONENT_PUMPSHOTGUN_MK2_CLIP_EXPLOSIVE weapon_pumpshotgun_mk2","COMPONENT_AT_SCOPE_SMALL_MK2 weapon_pumpshotgun_mk2",
"COMPONENT_ASSAULTSHOTGUN_CLIP_02 weapon_assaultshotgun",
"COMPONENT_SMG_MK2_CLIP_HOLLOWPOINT weapon_smg_mk2","COMPONENT_AT_SCOPE_SMALL_SMG_MK2 weapon_smg_mk2",
"COMPONENT_ASSAULTSMG_CLIP_02 weapon_assaultsmg","COMPONENT_AT_SCOPE_MACRO weapon_assaultsmg",
"COMPONENT_PISTOL_MK2_CLIP_HOLLOWPOINT weapon_pistol_mk2","COMPONENT_AT_PI_RAIL weapon_pistol_mk2",
"COMPONENT_SNSPISTOL_MK2_CLIP_FMJ weapon_snspistol_mk2","COMPONENT_AT_PI_RAIL_02 weapon_snspistol_mk2",
"COMPONENT_REVOLVER_MK2_CLIP_INCENDIARY weapon_revolver_mk2","COMPONENT_AT_SCOPE_MACRO_MK2 weapon_revolver_mk2",
"COMPONENT_MICROSMG_CLIP_02 weapon_microsmg"
}    --space between attachment/component and weapon it goes on




--turn safehouses off/on
Config.UseSafeHouse = true
Config.UseSafeHouseCrateDrop = true
Config.UseSafeHouseBanditoDrop = true
Config.SafeHouseCost = 500
Config.SafeHouseCostVehicle = 500
Config.SafeHouseCostCrate = 500
Config.SafeHouseSniperExplosiveRoundsGiven = 8 --default in game is 40. Alter this for some balance
Config.SafeHouseVehiclesMaxClaim = 3 --how many vehicles a player can claim per mission
Config.SafeHouseTimeTillNextUse = 120000 --2 minutes default 
Config.SafeHouseGiveNoCountDown = true --disable countdown
Config.SafeHouseGiveImmediately = false --No wait
Config.SafeHousePedDoctors = {"s_m_m_doctor_01","a_f_y_business_02","u_f_y_princess"}
Config.SafeHousePedLeaders = {"s_m_y_blackops_02","s_m_y_blackops_01","s_m_y_blackops_03"}
Config.SafeHouseProps = {"v_ilev_liconftable_sml"}--{"ex_prop_crate_expl_bc"}
Config.SafeHousePedWeapons = {0x83BF0278,0x05FC3C11}

--pawns player to the current mission safehouse when they spawn/respawn
Config.TeleportToSafeHouseOnSpawn = true
Config.TeleportToSafeHouseOnMissionStart = false
--Will teleport all mission players OUT of vehicles 
--to the safehouse marker (useful as well if no BlipSL set):
Config.TeleportToSafeHouseOnMissionStartNoVehicle = false
--Time after mission start to teleport, default is 5000 (5 seconds to read the mission text)
Config.TeleportToSafeHouseOnMissionStartDelay = 5000
--minimum distance from safehouse in order to teleport Player to safehouse
Config.TeleportToSafeHouseMinDistance = 50
--minimum distance from vehicle safe house zone (BlipSL) in order to teleport Player + Vehicle to safehouse
Config.TeleportToSafeHouseMinVehicleDistance = 200


--NOTE, WHEN SAFEHOUSES TURNED ON. For regular missions, place vehicles without 'id2' attribute in Vehicles= {} to also create safehouse vehicles for players
--**They need to be placed after any 'id2' NPC vehicles**
Config.SafeHouseVehicleCount = 6
Config.SafeHouseAircraftCount = 3
Config.SafeHouseBoatCount = 3

--Makes NPC planes (not helis) head towards to the safe house location if UseSafe=true and TeleportToSafeHouseOnMissionStart=true
--This is a little hack to make spawned planes stay in the air.
Config.SafeHousePlaneAttack = true

--combat pistol ->supressor, extended clip
--weapon_pistol_mk2 -> hollow point, scope
--weapon_snspistol_mk2 ->fmj rounds, scope
--weapon_revolver_mk2 -> incendiary, scope
--heavysniper_mk2 ->  explosive rounds, advanced scope
--marksmanrifle_mk2 ->  fmj (anti-vehicle) rounds
--heaversniper ->  advanced scope
--combatmg_mk2 -> scope, incendiary rounds
--combatmg,-> extend clip, scope
--weapon_carbinerifle_mk2 -> armor piercing rounds, scope
--weapon_assaultrifle_mk2 -> fmj rounds, scope
--weapon_specialcarbine_mk2 -> incendiary, scope
--weapon_bullpuprifle_mk2 -> armor piercing, scope
--weapon_advancedrifle --> extended, scope
--weapon_pumpshotgun_mk2 --> explosive, scope
--weapon_assaultshotgun -->, extended clip
--weapon_smg_mk2 -> hollow point,scope,
--weapon_assaultsmg -> extended clip, scope
--weapon_microsmg -> extended clip

Config.SpawnSafeHousePickups = {"WEAPON_COMBATPISTOL","weapon_heavysniper_mk2","weapon_marksmanrifle_mk2","weapon_heavysniper","weapon_combatmg_mk2","weapon_combatmg",
"weapon_carbinerifle_mk2","weapon_assaultrifle_mk2","weapon_specialcarbine_mk2","weapon_bullpuprifle_mk2","weapon_advancedrifle","weapon_pumpshotgun_mk2","weapon_assaultshotgun",
"weapon_smg_mk2","weapon_assaultsmg","weapon_pistol_mk2","weapon_snspistol_mk2","weapon_revolver_mk2","WEAPON_KNIFE","GADGET_NIGHTVISION","WEAPON_GRENADE","WEAPON_PROXMINE","WEAPON_STICKYBOMB","WEAPON_PIPEBOMB","WEAPON_FLARE",
"weapon_molotov","weapon_hominglauncher","WEAPON_RPG","GADGET_PARACHUTE","weapon_microsmg"
}
Config.SpawnSafeHouseComponents = {"COMPONENT_AT_PI_SUPP WEAPON_COMBATPISTOL","COMPONENT_COMBATPISTOL_CLIP_02 WEAPON_COMBATPISTOL","COMPONENT_HEAVYSNIPER_MK2_CLIP_EXPLOSIVE weapon_heavysniper_mk2",
"COMPONENT_AT_SCOPE_MAX weapon_heavysniper_mk2",
"COMPONENT_HEAVYSNIPER_MK2_CLIP_EXPLOSIVE weapon_heavysniper_mk2",
--"COMPONENT_AT_SCOPE_THERMAL weapon_heavysniper_mk2",
"COMPONENT_AT_SCOPE_LARGE_FIXED_ZOOM_MK2 weapon_marksmanrifle_mk2","COMPONENT_MARKSMANRIFLE_MK2_CLIP_FMJ weapon_marksmanrifle_mk2","COMPONENT_AT_SCOPE_MAX weapon_heavysniper",
"COMPONENT_AT_SCOPE_MEDIUM_MK2 weapon_combatmg_mk2","COMPONENT_COMBATMG_MK2_CLIP_INCENDIARY weapon_combatmg_mk2","COMPONENT_COMBATMG_CLIP_02 weapon_combatmg","COMPONENT_AT_SCOPE_MEDIUM weapon_combatmg",
"COMPONENT_CARBINERIFLE_MK2_CLIP_ARMORPIERCING weapon_carbinerifle_mk2","COMPONENT_AT_SCOPE_MEDIUM_MK2 weapon_carbinerifle_mk2",
"COMPONENT_ASSAULTRIFLE_MK2_CLIP_FMJ weapon_assaultrifle_mk2","COMPONENT_AT_SCOPE_MEDIUM_MK2 weapon_assaultrifle_mk2",
"COMPONENT_SPECIALCARBINE_MK2_CLIP_INCENDIARY weapon_specialcarbine_mk2","COMPONENT_AT_SCOPE_MEDIUM_MK2 weapon_specialcarbine_mk2",
"COMPONENT_BULLPUPRIFLE_MK2_CLIP_ARMORPIERCING weapon_bullpuprifle_mk2","COMPONENT_AT_SCOPE_SMALL_MK2 weapon_bullpuprifle_mk2",
"COMPONENT_ADVANCEDRIFLE_CLIP_02 weapon_advancedrifle","COMPONENT_AT_SCOPE_SMALL weapon_advancedrifle",
"COMPONENT_PUMPSHOTGUN_MK2_CLIP_EXPLOSIVE weapon_pumpshotgun_mk2","COMPONENT_AT_SCOPE_SMALL_MK2 weapon_pumpshotgun_mk2",
"COMPONENT_ASSAULTSHOTGUN_CLIP_02 weapon_assaultshotgun",
"COMPONENT_SMG_MK2_CLIP_HOLLOWPOINT weapon_smg_mk2","COMPONENT_AT_SCOPE_SMALL_SMG_MK2 weapon_smg_mk2",
"COMPONENT_ASSAULTSMG_CLIP_02 weapon_assaultsmg","COMPONENT_AT_SCOPE_MACRO weapon_assaultsmg",
"COMPONENT_PISTOL_MK2_CLIP_HOLLOWPOINT weapon_pistol_mk2","COMPONENT_AT_PI_RAIL weapon_pistol_mk2",
"COMPONENT_SNSPISTOL_MK2_CLIP_FMJ weapon_snspistol_mk2","COMPONENT_AT_PI_RAIL_02 weapon_snspistol_mk2",
"COMPONENT_REVOLVER_MK2_CLIP_INCENDIARY weapon_revolver_mk2","COMPONENT_AT_SCOPE_MACRO_MK2 weapon_revolver_mk2",
"COMPONENT_MICROSMG_CLIP_02 weapon_microsmg"
} 


Config.SafeHouseVehicles = 

{
	"dune3",
	"kuruma2",
	"insurgent3",
	"khanjali",
	"blazer5",
	--"oppressor2",
	"oppressor",
	"apc",
}


Config.SafeHouseAircraft = 

{
"hydra",
"havok",
"thruster",
"avenger",
"microlight",
"strikeforce"

}
--used for IsRandomSpawnAnywhere missions, for when the random position is on water.
Config.SafeHouseBoat = 

{
"dinghy4",
"seashark",
"toro2",
"jetmax",
}


--vehicles where NPC passengers get out of near players or IsDefendPlayerObjectives
--NEEDS TO BE IN UPPERCASE:
--[[Config.RandomMissionTransportVehicles = {
BRICKADE={},
BUS={},
COACH={},
WASTELANDER={},
TITAN={},
LUXOR={},
LUXOR2={},
MILJET={},
BARRACKS={},
BARRACKS3={},
CARGOBOB={},
CARGOBOB2={},
CARGOBOB3={},
CARGOBOB4={}
}
]]--


--reset safehouse access when player respawns?
--really need to use ESX& database to stop 
--players disconnecting and reconnecting
--to record.
----THESE ARE NOT SUPPORTED PER MISSION ONLY GLOBAL:
Config.ResetSafeHouseOnRespawn = false
--do we also reset the safe house for the next mission?
Config.ResetSafeHouseOnNewMission = false

--when going to safehouse for mission equipment armor and 
--health will also add armor to model, give super jump 
-- and fast sprint
----THESE ARE NOT SUPPORTED PER MISSION ONLY GLOBAL:
Config.SafeHouseCrackDownMode = true
Config.SafeHouseCrackDownModeHealthAmount = 5000
----
--for IsRandom=true
--For Below:
--set to true to use Config.SafeHouseLocations
--overrides normal mission and IsRandom
--location BlipS and MarkerS.
Config.UseSafeHouseLocations = true
Config.SafeHouseLocations = {

	--Los Santos Airport
	{
		BlipS = { --safehouse blip 
		  Title = "Mission Safehouse",
		  Position = { x = -1694.94, y = -3152.18, z = 23.32}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 417,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 2,
		  Alpha	 =80, 
		},	
		 MarkerS = { --safehouse marker
		  Type     = 1,
		  Position = { x = -1694.94, y = -3152.18, z = 24.32},  --{  x = 1944.96, y = 3150.6, z = 46.77}, 
		  Size     = {x = 6.0, y = 6.0, z = 2.0},
		  Color    = {r = 117, g = 218, b = 255},
		  DrawDistance = 200.0,
		},
		BlipSL = { --safehouse Vehicle blip 
		  Title = "Mission Vehicle Safehouse",
		  Position = { x = -1469.37, y = -2967.27, z = 13.3}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 421,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},
		BlipSB = { --safehouse boat blip 
		  Title = "Mission Boat Safehouse",
		  Position = {x = 413.98, y = -3411.47, z = 0.23}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		 Icon     = 404,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},
	},
	
	--Desert Airstrip
	{
		BlipS = { --safehouse blip 
		  Title = "Mission Safehouse",
		  Position = { x = 1731.94, y = 3308.24, z = 41.22}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 417,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 2,
		  Alpha	 =80, 
		},	
		 MarkerS = { --safehouse marker
		  Type     = 1,
		  Position = { x = 1731.94, y = 3308.24, z = 41.22},  --{  x = 1944.96, y = 3150.6, z = 46.77}, 
		  Size     = {x = 6.0, y = 6.0, z = 2.0},
		  Color    = {r = 117, g = 218, b = 255},
		  DrawDistance = 200.0,
		},
		BlipSL = { --safehouse Vehicle blip 
		  Title = "Mission Vehicle Safehouse",
		  Position = { x = 1480.63, y = 3167.93, z = 40.99}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 421,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},
		BlipSB = { --safehouse boat blip 
		  Title = "Mission Boat Safehouse",
		  Position = {x = 1481.84, y = 3873.37, z = 30.04}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		 Icon     = 404,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},
	},	
	
	--Military Base
	
	{
		BlipS = { --safehouse blip 
		  Title = "Mission Safehouse",
		  Position = {x = -2108.16, y = 3275.45, z = 38.73}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 417,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 2,
		  Alpha	 =80, 
		},	
		 MarkerS = { --safehouse marker
		  Type     = 1,
		  Position = { x = -2108.16, y = 3275.45, z = 38.73},  --{  x = 1944.96, y = 3150.6, z = 46.77}, 
		  Size     = {x = 6.0, y = 6.0, z = 2.0},
		  Color    = {r = 117, g = 218, b = 255},
		  DrawDistance = 200.0,
		},
		BlipSL = { --safehouse Vehicle blip 
		  Title = "Mission Vehicle Safehouse",
		  Position = { x = -2451.21, y = 3134.29, z = 32.82, heading = 156.25}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 421,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},
		BlipSB = { --safehouse boat blip 
		  Title = "Mission Boat Safehouse",
		  Position = {x = -3238.09, y = 3380.0, z = 0.18}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		 Icon     = 404,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},
	},	

	
}


--Config.UseESX=false    

--List of vehicles with their seatids
--**You can seatids to auto-fill passengers as well, not just turrets**
--**All vehicle seats for all vehicles get auto-populated for NPCs**
--**Use this to override that, to set only certain seatids**
Config.VehicleTurretSeatIds = {
	--[[
	apc = {0},
	barrage = {0,1,2},
	halftrack = {0,1},
	dune3 = {0},
	insurgent = {0,1,2,3,4,5,6,7},
	insurgent3 = {0,1,2,3,4,5,6,7},
	technical = {0,1},
	technical2 = {0,1},
	technical3 = {0,1},
	limo2 = {0,1,2,3},
	menacer = {0,1,2,3},
	boxville5 = {0,1,2,3},
	toro2={0,1,2,3},
	--tampa3={0},
	valkyrie={0,1,2,3,4}, --how many seatids? 
	valkyrie2={0,1,2,3,4}, --how many seatids? 
	buzzard2={0,1,2,3,4}, --how many seatids? 
	maverick={0,1,2,3,4}, --how many seatids? 
	akula={0,1}, --how many seatids? 
	caracara = {0,1,2,3},
	ruiner2 = {0},
	nightshark = {0,1,2},
	dinghy4 = {0,1,2,3},
	pounder2 = {0,1,2,3,4,5,6,7},
	brutus = {0},
	bombushka = {0,1,2,3,4},
	--avenger = {0,1,2,3},
	]]--
}


--will spawn with AA trailer
--has to be these vehicles: https://gta.fandom.com/wiki/Anti-Aircraft_Trailer
Config.TowVehicles = {
"nightshark"

} 


--**Nerfs are DEPRECATED EXCEPT FOR NerfValkyrieHelicopterCannon**, all fire patterns are done per vehicle in doVehicleMods function now in client.lua:
--make the cannon on the Valkyrie Helicopter shoot much slower
Config.NerfValkyrieHelicopterCannon = true
--make the cannon on the APC shoot much slower like a tank
Config.NerfAPCCannon = false
--make the cannon on the khanjali and rhino tanks shooter more like a tank
Config.NerfTankCannon = false
--make all other turrets in any other vehicle nerfed? (burst shots vs 30-50 rounds at a time)
Config.NerfTurrets = false
--make any driver control weapons nerfed?
Config.NerfDriverTurrets = false
---


--Fast firing peds
Config.FastFiringPeds = true

--Configure Boss health. Chance to appear in IsRandom missions with RandomMissionBossChance
--in regular missions, use isBoss=true
Config.BossHealth = 1000 

--**START RANDOM MISSION GENERATOR SETTINGS**--
Config.RandomMissionSpawnRadius = 50.0 --keep a float for enemy ped wandering to work
Config.RandomMissionMaxPedSpawns = 30
Config.RandomMissionMinPedSpawns = 15
Config.RandomMissionBossChance = 5
Config.RandomMissionMaxVehicleSpawns = 4
Config.RandomMissionMinVehicleSpawns = 1
Config.RandomMissionChanceToSpawnVehiclePerTry = 100
Config.RandomMissionAircraftChance = 25


Config.RandomMissionGoalDestinationMinDistance=1000.0

--forces only land spawns for random anywhere missions
Config.RandomMissionDoLandBattle = true

Config.StartMessageObj = "Capture the objective!"
Config.FinishMessageObj = "Mission Completed!"
Config.MissionTitleObj = "Takeover"
Config.MissionMessageObj = "Capture the objective!"	
	
Config.StartMessageAss = "Eliminate the targets!"
Config.FinishMessageAss = "Mission Completed!"
Config.MissionTitleAss = "Elimination"
Config.MissionMessageAss = "Eliminate the targets"	

--chance that an Event will happen within 500 to 1000m away from the mission epicenter (Blip)
Config.IsRandomEventChance= 100	

Config.RandomMissionTypes = {"Assassinate","Objective","HostageRescue","BossRush"}


--START HOSTILE AMBIENT PEDS

--VALUES: 0: no hostiles, 1: hostiles have less infighting (most dangerous)
--2: a little more infighthing between hostiles.
--3: riot mode, virtually all peds hate each other as well. 
Config.HostileAmbientPeds = 0

--mostly melee weapons and pistols, with a few heavier weapons, also rpg + homing launcher
Config.RandomHostileZoneWeapons = {0xDD5DF8D9,0xDFE37640,0x958A4A8F,0x92A27487,0x84BD7BFD,0xF9E6AA4B,0x440E4788,0x4E875F73,
0xF9DCBF2D,0xD8DF3C3C,0x99B507EA,0x19044EE0,0xCD274149,0x94117305,0x3813FC08,
0xBFE256D4,0x22D8FE39,0x99AEEB3B,0x88374054,0xD205520E,0xCB96392F,0xEF951FBB,0xA89CB99E,0x7846A318,0xBD248B55,0x394F415C,0x05FC3C11,
0x63AB0442,0xB1CA77B1,0x84D6FAFD,0x0781FE4A,0x42BF8A85
 }
 --melee, pistols and some micro smg, and rpg and homing missile
 --**they will get out of the vehicle if they have non-drive by weapons**
Config.RandomHostileZoneVehicleWeapons = {
0xDD5DF8D9,0xDFE37640,0x958A4A8F,0x92A27487,0x84BD7BFD,0xF9E6AA4B,0x440E4788,0x4E875F73,
0xF9DCBF2D,0xD8DF3C3C,0x99B507EA,0x19044EE0,0xCD274149,0x94117305,0x3813FC08,
0xBFE256D4,0x22D8FE39,0x99AEEB3B,0x88374054,0xCB96392F,0x13532244,0x13532244,0xD205520E,
0xB1CA77B1,0x63AB0442,0x0781FE4A,0x42BF8A85 
}
--END HOSTILE AMBIENT PEDS


--START PARADROPS

Config.RandomParadropPeds = {"s_m_y_ammucity_01","s_m_y_xmech_02","U_M_Y_Tattoo_01","g_m_m_chicold_01","s_m_y_dealer_01","g_m_y_lost_01","g_m_y_lost_02","g_m_y_lost_03","s_m_y_xmech_02_mp","s_m_y_robber_01","g_f_y_lost_01","u_f_y_bikerchic","mp_g_m_pros_01"}

Config.RandomParadropWeapons = {0x1B06D571,0xBFE256D4,0x88374054,0xCB96392F,0x5EF9FEC4,0xE284C527,0x83BF0278,0xBFEFFF6D,0xD205520E,0x13532244,
0x2BE6766B, 0x2BE6766B, 0xEFE7E2DF,0x0A3D4D34,0xDB1AA450,0xBD248B55,0x1D073A89,0x555AF99A,0x7846A318,0xE284C527,0x9D61E50F,0x3AABBBAA,0xEF951FBB,
 0x12E82D3D,0x42BF8A85,0x42BF8A85,0x42BF8A85,0xC734385A,0xBFEFFF6D,0x42BF8A85,
 0xBFEFFF6D,0xBFEFFF6D,0x394F415C,0x394F415C,0x83BF0278,0x83BF0278,0xFAD1F1C9,0xFAD1F1C9,0xAF113F99,0xC0A3098D,0x969C3D67,0x7F229F94,0x84D6FAFD,
 0x624FE830,0x9D07F764,0x7FD62962,0xDBBD7280,0x61012683,0x83BF0278,0x83BF0278,0x83BF0278,0xBFEFFF6D,0xBFEFFF6D,0x394F415C,0x394F415C,0xC0A3098D,
 0x969C3D67,0x05FC3C11,0x05FC3C11,0x05FC3C11,0xB1CA77B1,0xB1CA77B1,0xB1CA77B1,0x63AB0442,0x63AB0442,0x63AB0442,0xB1CA77B1,0x0781FE4A,0x0781FE4A,
 0x0C472FE2,0x0C472FE2,0xC1B3C3D1,0xC1B3C3D1,0xEFE7E2DF,0xEFE7E2DF
 
 }
 
 Config.RandomParadropAircraft = {
 "avenger","titan","cargobob"--,"cargoplane",
 }

--END PARADROPS


Config.RandomMissionWeapons = {0x1B06D571,0xBFE256D4,0x88374054,0xCB96392F,0x5EF9FEC4,0xE284C527,0x83BF0278,0xBFEFFF6D,0xD205520E,0x13532244,
0x2BE6766B, 0x2BE6766B, 0xEFE7E2DF,0x0A3D4D34,0xDB1AA450,0xBD248B55,0x1D073A89,0x555AF99A,0x7846A318,0xE284C527,0x9D61E50F,0x3AABBBAA,0xEF951FBB,
 0x12E82D3D,0x42BF8A85,0x42BF8A85,0x42BF8A85,0xC734385A,0xBFEFFF6D,0x42BF8A85,
 0xBFEFFF6D,0xBFEFFF6D,0x394F415C,0x394F415C,0x83BF0278,0x83BF0278,0xFAD1F1C9,0xFAD1F1C9,0xAF113F99,0xC0A3098D,0x969C3D67,0x7F229F94,0x84D6FAFD,
 0x624FE830,0x9D07F764,0x7FD62962,0xDBBD7280,0x61012683,0x83BF0278,0x83BF0278,0x83BF0278,0xBFEFFF6D,0xBFEFFF6D,0x394F415C,0x394F415C,0xC0A3098D,
 0x969C3D67,0x05FC3C11,0x05FC3C11,0x05FC3C11,0xB1CA77B1,0xB1CA77B1,0xB1CA77B1,0x63AB0442,0x63AB0442,0x63AB0442,0xB1CA77B1,0x0781FE4A,0x0781FE4A,
 0x0C472FE2,0x0C472FE2,0xC1B3C3D1,0xC1B3C3D1,0xEFE7E2DF,0xEFE7E2DF
 
 }
 
 --what do peds in vehicles carry? Use drive-by weapons like micro-smg
Config.RandomMissionVehicleWeapons = {0x13532244,0xBD248B55,0xDB1AA450}

--override for bike,quad,Boat only drivebyweapons
Config.RandomMissionBikeQuadBoatWeapons = {0x13532244,0xBD248B55,0xDB1AA450,0x12E82D3D,0x624FE830,0x0781FE4A}

--Randomize passenger drive by weapons?
Config.RandomizePassengerWeapons = true

--****START IsRandom -> IsDefend -> IsDefendTarget configuration
Config.IsDefendTargetRescue = true
Config.IsDefendTargetMaxHealth = 600 --need to make this a little higher
--How close to the target will peds on feet finally attack? Useful when SetBlockingOfNonTemporaryEvents is set for a ped.
Config.IsDefendTargetAttackDistance = 10.0

Config.IsDefendTargetVehicleAttackDistance = 150.0
--not used:
Config.IsDefendTargetCheckLoop=false

--Make the target keep to set task, usually driving...
Config.IsDefendTargetSetBlockingOfNonTemporaryEvents=false

--Make the target enemies keep to set task
--Used for IsRandom Missions only
Config.IsDefendTargetEnemySetBlockingOfNonTemporaryEvents=false

--Used for IsVehicleDefendTargetGotoBlip and IsDefendTargetGotoBlip
--missions, where the target reaches a goal.
--NOTE: IsDefendTargetEnemySetBlockingOfNonTemporaryEvents should be true
Config.IsDefendTargetGoalDistance=30.0

--Config.IsDefendTargetMaxArmor = 100 --just give armor = 100

--by default IsDefendTarget missions disable player only damage
--to allow target ped to fight back. Set this to true to override
Config.IsDefendTargetOnlyPlayersDamagePeds=false

Config.IsDefendTargetRandomPeds = {"ig_bankman","a_f_y_business_02","u_f_y_princess","ig_tomepsilon"}

Config.IsDefendTargetRandomPedWeapons = {0xE284C527,0x83BF0278,0xBFEFFF6D}



Config.IsDefendTargetRandomVehicles = {	
"kuruma2",
"insurgent3"
}


Config.IsDefendTargetRandomAircraft = {

"hydra",
"lazer",
"strikeforce"
}

Config.IsDefendTargetRandomBoat = {
"dinghy4",
"seashark",
"toro2",
"marquis",
"jetmax"
}

--****END IsRandom -> IsDefend -> IsDefendTarget configuration

 --randomlocation.DefendTargetInVehicle
--.DefendTargetVehicleIsAircraft
--.DefendTargetVehicleIsBoat

Config.RandomMissionPositions = { 

{ x = -973.87, y = -273.67, z = 38.26, MissionTitle="Arcade"}, --cul de sac near studios
 
{ x = -1102.97, y = -424.98, z = 44.37, MissionTitle="News Studio" }, --news channel/studio building roof
{ x = -1223.9, y = -493.83, z = 31.51, MissionTitle="Back Alley" }, --news channel/studio in cul de sac

{ x = 2840.52, y = -1449.96, z = 11.95, MissionTitle="The Island"}, --island

{ x = 1074.41, y = 3072.94, z = 40.82, MissionTitle="Desert Airstrip"}, --desert airstrip

{x = -149.29, y = -960.51, z = 269.13, MissionTitle="High Rise"}, --construction tower

{ x = -1393.62, y = -2562.09, z = 13.95, MissionTitle="Airport" }, --airport

{ x = 137.07, y = -3204.05, z = 5.86,  MissionTitle="Docks" }, --walkers docks
{ x = -1828.32, y = -1218.22, z = 13.03, MissionTitle="The Pier" }, --pier

{ x = -547.74, y = -1477.3, z = 10.14, MissionTitle="Freeway Hideaway" }, --center greenery	

{ x = 1485.24, y = -2358.31, z = 72.44, MissionTitle="Oil Fields" }, --oilfields


{ x = 58.43, y = -1133.28, z = 29.34, MissionTitle="Street Smart"}, --los santos road
{ x = -808.9, y = -1302.95, z = 5.0, MissionTitle="Marina" }, --yacht club

{ x = 31.0, y = -767.1, z = 44.24, MissionTitle="Business District" }, --center los santos

{ x = 1874.74, y = 299.22, z = 162.82, MissionTitle="Resevoir" }, --resevoir

{ x = 1373.59, y = -739.58, z = 67.23, MissionTitle="Suburban Sprawl"}, --cul de sac

{ x = 1150.09, y = 124.3, z = 82.12, MissionTitle="Race Track"}, --race track

--'force = true' stops ray trace checking for spawn points for peds and vehicles, so peds/vehicles can spawn underneath structures... near the spawn location 
--this also means that peds/vehicles can spawn hidden in buildings, so this forces the mission type to be "Objective"
{ x = -177.69, y = -165.11, z = 44.03, MissionTitle="Concierge Service", force=true}, --hotel north los santos 

{ x = -2237.38, y = 266.45, z = 174.62, MissionTitle="The Ritz" },
 --ritz hotel

{ x = -412.9, y = 1170.53, z = 325.84, MissionTitle="Observatory"}, --observatory

{ x = 756.1, y = 1284.89, z = 360.3, MissionTitle="Vinewood" }, --vinewood sign

{ x = -1907.85, y = 2037.05, z = 140.74, MissionTitle="Wine Country"}, --vineyard

{ x = -1833.24, y = 2152.89, z = 115.7, MissionTitle="Vinery"}, --vineyard 2

{ x = -2548.21, y = 2705.28, z = 2.84, MissionTitle="Secret Bunker" }, --outside base

{ x = -2405.68, y = 4253.63, z = 9.82, MissionTitle="Point Break"}, --nw beach

{ x = 57.0, y = 3717.01, z = 39.75, MissionTitle="Trailer Park"},--lost caravans
{ x = 1816.42, y = 3794.64, z = 33.65, MissionTitle="Dust Bowl"}, --south salton
{ x = 1313.35, y = 4327.67, z = 38.21, MissionTitle="Fish Monger" }, --north salton

{ x = 3572.73, y = 3665.03, z = 33.89, MissionTitle="The Complex"}, --humane labs

{ x = 3803.26, y = 4462.52, z = 4.75, MissionTitle="Getaway" }, --north east coast

{ x = -1122.74, y = 4924.89, z = 218.67, MissionTitle="Compound"  }, --cult

{ x = -578.96, y = 5321.1, z = 70.21, MissionTitle="Sawmill" }, --sawmill

{ x = -31.49, y = 6441.9, z = 31.43, MissionTitle="Community Chest"  }, --parking lot uppoer NW

{ x = 28.76, y = 6216.7, z = 31.54, MissionTitle="Railyard"  }, --by railyard upper nw
{ x = 1429.43, y = 6517.94, z = 18.91, MissionTitle="Scenic Route"  }, --uppper coast


}




Config.RandomMissionDestinations = { 

{ x = -973.87, y = -273.67, z = 38.26, MissionTitle="Arcade"}, --cul de sac near studios
 
{ x = -1102.97, y = -424.98, z = 44.37, MissionTitle="News Studio" }, --news channel/studio building roof
{ x = -1223.9, y = -493.83, z = 31.51, MissionTitle="Back Alley" }, --news channel/studio in cul de sac

{ x = 2840.52, y = -1449.96, z = 11.95, MissionTitle="The Island"}, --island

{ x = 1074.41, y = 3072.94, z = 40.82, MissionTitle="Desert Airstrip"}, --desert airstrip

--{x = -149.29, y = -960.51, z = 269.13, MissionTitle="High Rise"}, --construction tower

{ x = -1393.62, y = -2562.09, z = 13.95, MissionTitle="Airport" }, --airport

{ x = 137.07, y = -3204.05, z = 5.86,  MissionTitle="Docks" }, --walkers docks
{ x = -1828.32, y = -1218.22, z = 13.03, MissionTitle="The Pier" }, --pier

{ x = -547.74, y = -1477.3, z = 10.14, MissionTitle="Freeway Hideaway" }, --center greenery	

{ x = 1485.24, y = -2358.31, z = 72.44, MissionTitle="Oil Fields" }, --oilfields


{ x = 58.43, y = -1133.28, z = 29.34, MissionTitle="Street Smart"}, --los santos road
{ x = -808.9, y = -1302.95, z = 5.0, MissionTitle="Marina" }, --yacht club

{ x = 31.0, y = -767.1, z = 44.24, MissionTitle="Business District" }, --center los santos

{ x = 1874.74, y = 299.22, z = 162.82, MissionTitle="Resevoir" }, --resevoir

{ x = 1373.59, y = -739.58, z = 67.23, MissionTitle="Suburban Sprawl"}, --cul de sac

{ x = 1150.09, y = 124.3, z = 82.12, MissionTitle="Race Track"}, --race track

--'force = true' stops ray trace checking for spawn points for peds and vehicles, so peds/vehicles can spawn underneath structures... near the spawn location 
--this also means that peds/vehicles can spawn hidden in buildings, so this forces the mission type to be "Objective"
{ x = -177.69, y = -165.11, z = 44.03, MissionTitle="Concierge Service", force=true}, --hotel north los santos 

--{ x = -2237.38, y = 266.45, z = 174.62, MissionTitle="The Ritz" },
 --ritz hotel

{ x = -412.9, y = 1170.53, z = 325.84, MissionTitle="Observatory"}, --observatory

{ x = 756.1, y = 1284.89, z = 360.3, MissionTitle="Vinewood" }, --vinewood sign

{ x = -1907.85, y = 2037.05, z = 140.74, MissionTitle="Wine Country"}, --vineyard

{ x = -1833.24, y = 2152.89, z = 115.7, MissionTitle="Vinery"}, --vineyard 2

{ x = -2548.21, y = 2705.28, z = 2.84, MissionTitle="Secret Bunker" }, --outside base

{ x = -2405.68, y = 4253.63, z = 9.82, MissionTitle="Point Break"}, --nw beach

{ x = 57.0, y = 3717.01, z = 39.75, MissionTitle="Trailer Park"},--lost caravans
{ x = 1816.42, y = 3794.64, z = 33.65, MissionTitle="Dust Bowl"}, --south salton
{ x = 1313.35, y = 4327.67, z = 38.21, MissionTitle="Fish Monger" }, --north salton

--{ x = 3572.73, y = 3665.03, z = 33.89, MissionTitle="The Complex"}, --humane labs

{ x = 3803.26, y = 4462.52, z = 4.75, MissionTitle="Getaway" }, --north east coast

{ x = -1122.74, y = 4924.89, z = 218.67, MissionTitle="Compound"  }, --cult

{ x = -578.96, y = 5321.1, z = 70.21, MissionTitle="Sawmill" }, --sawmill

{ x = -31.49, y = 6441.9, z = 31.43, MissionTitle="Community Chest"  }, --parking lot uppoer NW

{ x = 28.76, y = 6216.7, z = 31.54, MissionTitle="Railyard"  }, --by railyard upper nw
{ x = 1429.43, y = 6517.94, z = 18.91, MissionTitle="Scenic Route"  }, --uppper coast


}



--{{ x = 1074.41, y = 3072.94, z = 40.82},{ x = 302.86, y = 4373.86, z = 51.61 }, { x = -2074.59, y = 1475.03, z = 275.15 }, {x = 1657.106, y = 428.6742, z = 245.6912}}
Config.RandomMissionPeds = {"s_m_y_ammucity_01","s_m_y_xmech_02","U_M_Y_Tattoo_01","g_m_m_chicold_01","s_m_y_dealer_01","g_m_y_lost_01","g_m_y_lost_02","g_m_y_lost_03","s_m_y_xmech_02_mp","s_m_y_robber_01","g_f_y_lost_01","u_f_y_bikerchic","mp_g_m_pros_01"}

--juggernauts will spawn with railgun others minigun:
Config.RandomMissionBossPeds = {"ig_clay","mp_m_exarmy_01","ig_josef","ig_ramp_mex","ig_terry","mp_m_bogdangoon","mp_m_weapexp_01","csb_jackhowitzer","u_m_y_juggernaut_01","u_m_y_juggernaut_01","ig_cletus","u_m_y_juggernaut_01"} --csb_jackhowitzer, u_m_y_juggernaut_01 
Config.RandomMissionFriendlies = {"a_f_m_tourist_01","a_m_y_vinewood_03","a_m_m_tourist_01","a_m_y_genstreet_01","a_f_o_genstreet_01","a_m_y_genstreet_02","a_f_y_genhot_01"}

--**START IsBountyHunt mission type of Assassinate missions Settings
--IsBountyHunt=true guardian Peds, since when this is true, RandomMissionPeds should be set
--per mission for special peds that are the actual bounty/targets
Config.RandomMissionBountyPeds = {"s_m_y_ammucity_01","s_m_y_xmech_02","U_M_Y_Tattoo_01","g_m_m_chicold_01","s_m_y_dealer_01","g_m_y_lost_01","g_m_y_lost_02","g_m_y_lost_03","s_m_y_xmech_02_mp","s_m_y_robber_01","g_f_y_lost_01","u_f_y_bikerchic","mp_g_m_pros_01"}

Config.RandomMissionBountyBossChance=15 -- % of squad that will be bosses, 
										--set RandomMissionBossChance =0 for the mission to not make Bosses a bounty/target
Config.IsBountyHuntMaxSquadSize = 12	--squad will be a max of this size, 
										--spawned with a bounty target

Config.IsBountyHuntMinSquadSize = 1	--squad will be a min of this size, 
										--spawned with a bounty target		

Config.IsBountySquadMinRadius = 25	--squad will spawn around a min radius  of this size, 
										

Config.IsBountySquadMaxRadius = 150	--squad will spawn around a max radius of this size, 

Config.IsBountyHuntDoBoats = false --spawn enemies in boats as well as on land?

Config.IsBountyHuntAssassinateAll = false --set this on an IsBountyHunt=true mission to 
										  --allow force all non-friendly NPCs to be targets
										--when Type=Assassinate
																				
--this is a HACK to not have the same 
					--identical 'boss' models like in a multi-seat vehicle
					--since the turrets subroutine I never felt
					--I fixed correctly to place random passengers										
Config.RandomMissionIsBountyOverrideVehPeds = {"hc_hacker","hc_gunman","u_m_m_bankman","u_m_m_jewelsec_01","s_m_m_highsec_02","a_m_m_og_boss_01","u_m_m_jewelthief","s_m_m_movprem_01","g_m_m_korboss_01","g_m_m_armboss_01","g_m_m_chiboss_01","g_m_m_mexboss_01","g_m_m_mexboss_02","g_m_y_salvaboss_01","s_m_m_ammucountry","u_m_y_babyd","u_m_y_militarybum","a_m_y_musclbeac_02","s_m_y_pestcont_01","u_m_o_taphillbilly","a_f_y_femaleagent","g_m_importexport_01","g_f_importexport_01","mp_f_cardesign_01","mp_f_chbar_01","mp_f_cocaine_01","mp_f_execpa_01","mp_f_forgery_01","mp_f_meth_01","mp_f_weed_01","mp_m_cocaine_01","mp_m_counterfeit_01","mp_m_execpa_01","mp_m_forgery_0","mp_m_meth_01","mp_m_weapwork_01","mp_m_weed_01","a_m_y_breakdance_01","g_f_y_vagos_01","mp_m_g_vagfun_01","a_m_y_vindouche_01","a_m_m_tranvest_01","g_m_y_strpunk_01","g_m_y_strpunk_02","s_m_m_strpreach_01","a_m_y_gay_01","a_f_m_bodybuild_01",
		}	
									
										
--**END IsBountyHunt mission type of Assassinate missions Settings

Config.RandomMissionVehicles = {	
	"apc",
	"apc",
	"barrage",
	"halftrack",
	"dune3",
	"insurgent",
	"insurgent3",
	"technical",
	"technical2",
	"technical3",
	"limo2",
	"menacer",
	"rhino",
	"khanjali",
	"trailersmall2",
	"tampa3",
	"caracara",
	"blazer4",
	"bf400",
	"mule4",
	"kuruma2",
	"brutus",
	"nightshark",
	"bruiser",
	"dominator4",
	"impaler2",
	"imperator",
	"zr380",
	"issi4",
	"deathbike",
	"oppressor",
	"scarab",
	"slamvan4",
	"speedo4",
	"oppressor2",
	"boxville5",
	"crusader",
	"pounder2",
	"trailerlarge",
}

--Config.RandomMissionVehicles = {

	--"thruster",
--}


Config.RandomMissionAircraft = {
"hydra",
"lazer",
"strikeforce",
"valkyrie",
"valkyrie2",
"buzzard2",
"maverick",
"hunter",
"akula",
"starling",
"mogul",
"rogue",
"nokota",
"molotok",
"tula",
"pyro",
"bombushka",
"seabreeze",
"volatol",
"microlight"
}


Config.RandomMissionGuardAircraftSpawns = {
"valkyrie",
"valkyrie2",
"buzzard2",
"maverick",
"hunter",
"akula",
"mogul",
"tula",
"bombushka",
"volatol",
"buzzard2",
"blimp"
}

--Config.RandomMissionGuardAircraftSpawns = {"strikeforce"}

--used for IsRandomSpawnAnywhere missions, for when the random position is on water.
Config.RandomMissionBoat = {
"dinghy4",
"seashark",
"toro2",
"jetmax",
"technical2",
"blazer5",
"apc",
}

Config.RandomMissionProps = {
	"ba_prop_battle_crate_m_hazard",
	"imp_prop_impexp_boxcoke_01",
	"ex_prop_crate_expl_sc",
	"sm_prop_smug_crate_l_narc",
	"ex_prop_crate_money_sc",
	"ex_prop_crate_jewels_racks_sc",
	"prop_large_gold",
	"xm_prop_crates_sam_01a",
	"prop_drop_crate_01_set",
	"prop_box_ammo03a_set2",
	"prop_biotech_store",
	"prop_air_cargo_04c",
	"prop_air_cargo_04a",
	"hei_prop_carrier_bombs_1",
	"ex_prop_crate_narc_sc",
	"prop_weed_pallet",
	"prop_cash_crate_01",
	"prop_box_ammo03a_set",
	"hei_prop_heist_weed_pallet_02",
	"hei_prop_carrier_cargo_05b"
	
	
	}


--**END RANDOM MISSION GENERATOR SETTINGS**--


Config.Missions = {

  Mission1 = {
    --only around 98 characters will display for these messages
    StartMessage = "Mercenaries for hire have taken over a construction site~n~for ransom. Secure it!",
	FinishMessage = "Mission Completed!",
	MissionTitle = "Blackwater",
	MissionMessage = "Go to the construction site and secure it from the mercenaries",
	MissionSpaceTime = 10000,
	MissionTriggerRadius = 1000.0,
	Type = "Objective",
	SMS_Subject="Mission: Blackwater",
	SMS_Message="Mercenaries for hire have taken over a construction site for ransom. We need help to secure it",
	SMS_Message2="Make it to the middle of the top level of the structure in downtown to secure it.",
	SMS_Message3="They are well armed and have heavy vehicular ordinance, so do not go down there naked",		
		
	SMS_ContactPics={"CHAR_MP_ARMY_CONTACT",
	},
	SMS_ContactNames={"Military Contact",
	},
	
	SMS_FailedSubject="What Happened?",
	SMS_FailedMessage="What happened? Time to send in the big boys to get the job done I guess",
	SMS_PassedSubject="Great Job Soldier!",
	SMS_PassedMessage="Those goons learned a lesson. Reinforcements have arrived. Enjoy the spoils!",		
	
	--FinishedObjectiveReward = 10000,
	--KillReward = 150,
	--SpawnMissionPickups = {"WEAPON_CARBINERIFLE","WEAPON_COMBATPISTOL","WEAPON_KNIFE","GADGET_NIGHTVISION"},
	--SpawnRewardPickups = {"WEAPON_RPG","WEAPON_COMBATPISTOL","WEAPON_KNIFE","GADGET_PARACHUTE"},    
	--SpawnMissionComponents = {"COMPONENT_AT_PI_SUPP WEAPON_COMBATPISTOL"}, --space between attachment/component and weapon it goes on
	--SpawnRewardComponents = {"COMPONENT_AT_PI_FLSH WEAPON_COMBATPISTOL"},   --space between attachment/component and weapon it goes on


    Blip = {
      Title = "Mission Objective",
      Position = { x = -146.84, y = -1080.72, z = 42.02 },
      Icon     = 58,
      Display  = 4,
      Size     = 1.2,
      Color    = 1,
    },

    Marker = {
      Type     = 1,
      Position = { x = -146.84, y = -1080.72, z = 41.02 },
      Size     = {x = 5.0, y = 5.0, z = 2.0},
      Color    = {r = 100, g = 100, b = 204},
      DrawDistance = 100.0,
    },
	BlipS = { --safehouse blip 
		  Title = "Mission Safehouse",
		  Position = { x = -1694.94, y = -3152.18, z = 23.32}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 417,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 2,
		  Alpha	 =80, 
	},	
		MarkerS = { --safehouse marker
		  Type     = 1,
		  Position = { x = -1694.94, y = -3152.18, z = 23.32},  --{  x = 1944.96, y = 3150.6, z = 46.77}, 
		  Size     = {x = 6.0, y = 6.0, z = 2.0},
		  Color    = {r = 117, g = 218, b = 255},
		  DrawDistance = 200.0,
	},
	BlipSL = { --safehouse Vehicle blip 
		  Title = "Mission Vehicle Safehouse",
		  Position = { x = -1469.37, y = -2967.27, z = 13.3}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 421,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
	},
	BlipSB = { --safehouse boat blip 
		  Title = "Mission Boat Safehouse",
		  Position = {x = 413.98, y = -3411.47, z = 0.23}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		 Icon     = 404,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
	},
	
	Events = {

	   { 
		  Type="Paradrop",
		  Position = {  x = -146.84, y = -1080.72, z = 42.02 }, 
		  Size     = {radius=100.0},
		  SpawnHeight = 200.0,
		  FacePlayer = true,
		  modelHash="s_m_y_ammucity_01",
		  NumberPeds=10,
		},
	
	},	
	
    Peds = {
        -- ID: id of NPC | name: Name of Blip | BlipID: Icone of Blip | VoiceName: NPC Talk When near it | Ambiance: Ambiance of Shop | Weapon: Hash of Weapon | modelHash: Model | X: Position x | Y: Position Y | Z: Position Z | heading: Where Npc look
        {id = 1, Weapon = 0x83BF0278, modelHash = "s_m_y_ammucity_01", x = -187.2, y = -1091.96, z = 27.16, heading = 27.16},
        {id = 2, Weapon = 0x83BF0278, modelHash = "s_m_y_ammucity_01", x = -179.47, y = -1078.39, z = 30.14, heading = 82.01,wanderinarea=true},
        {id = 3, Weapon = 0x83BF0278, modelHash = "s_m_y_ammucity_01", x = -173.8, y = -1062.78, z = 30.14, heading = 60.94,wanderinarea=true},
        {id = 4, Weapon = 0x83BF0278, modelHash = "s_m_y_ammucity_01", x = -160.2, y = -1067.93, z = 30.14, heading = 3.31448912620544,},
        {id = 5, Weapon = 0x83BF0278, modelHash = "s_m_y_ammucity_01", x = -165.83, y = -1083.26, z = 30.14, heading = 3.31448912620544},
        {id = 6, Weapon = 0xB1CA77B1, modelHash = "s_m_y_ammucity_01", x = -179.47, y = -1078.39, z = 36.13, heading = 82.01,},
        {id = 7, Weapon = 0x83BF0278, modelHash = "s_m_y_ammucity_01", x = -173.8, y = -1062.78, z = 36.13, heading = 60.94,wanderinarea=true},
        {id = 8, Weapon = 0x83BF0278, modelHash = "s_m_y_ammucity_01", x = -160.2, y = -1067.93, z = 36.13, heading = 3.31448912620544},
        {id = 9, Weapon = 0x83BF0278, modelHash = "s_m_y_ammucity_01", x = -165.83, y = -1083.26, z = 36.13, heading = 3.31448912620544,wanderinarea=true},
        {id = 10, Weapon = 0x83BF0278, modelHash = "s_m_y_ammucity_01", x = -179.47, y = -1078.39, z = 42.13, heading = 82.01,wanderinarea=true},
        {id = 11, Weapon = 0x83BF0278, modelHash = "s_m_y_ammucity_01", x = -173.8, y = -1062.78, z = 42.13, heading = 60.94,},
        {id = 12, Weapon = 0x63AB0442, modelHash = "s_m_y_ammucity_01", x = -160.2, y = -1067.93, z = 42.13, heading = 3.31448912620544},
        {id = 13, Weapon = 0x83BF0278, modelHash = "s_m_y_ammucity_01", x = -165.83, y = -1083.26, z = 42.13, heading = 3.31448912620544},
		
    },

    Vehicles = {
      -- ID: id of NPC | name: Name of Blip | BlipID: Icone of Blip | VoiceName: NPC Talk When near it | Ambiance: Ambiance of Shop | Weapon: Hash of Weapon | modelHash: Model | X: Position x | Y: Position Y | Z: Position Z | heading: Where Npc look
      {id = 1, id2 = 1, Vehicle = "rhino", modelHash = "s_m_y_ammucity_01", x = -203.92, y = -1096.21, z = 21.16, heading = 143.9},
	  {id = 2, id2 = 2, Vehicle = "trailersmall2",nomods=true, modelHash = "s_m_y_ammucity_01", x = -187.1, y = -1100.09, z = 42.14, heading = 68.51},
	 {id = 3, id2 = 3, Vehicle = "trailersmall2",nomods=true, modelHash = "s_m_y_ammucity_01", x = -140.47, y = -1091.98, z = 42.14, heading = 250.11},
	  {id = 4, id2 = 4, Vehicle = "hydra", modelHash = "s_m_y_ammucity_01",x = -161.65, y = -1077.89, z = 42.14+20, heading = 70.54,driving=true,pilot=true,isAircraft=true},
	  {id = 5, id2 = 5, Vehicle = "trailersmall2", nomods=true, modelHash = "s_m_y_ammucity_01", x = -175.84, y = -1060.36, z = 42.14, heading = 20.14},
	  -- {id = 6, id2 = 5, Vehicle = "savage", modelHash = "s_m_y_ammucity_01",  x = -1409.41, y = -2391.27, z = 14.73, heading = 160.04,isAircraft=true,pilot=true},
	  
	  
   
   	  --{id = 6,  Vehicle = "insurgent",x = 2929.89, y = 4715.79, z = 50.24, heading = -27.45},
	 -- {id = 7,  Vehicle = "blazer4",  x = 2907.93, y = 4703.54, z = 49.38, heading = 287.97},
   
   }
  },
  Mission2 = {
    
    StartMessage = "The Church of Chantixology are holding~n~TV nature specialist Des Proud captive~n~Go rescue him!",
	FinishMessage = "Des Proud is free!",
	MissionTitle = "OT VIII",
	MissionMessage = "Rescue TV celebrity Des Proud. He is being held captive at a Church of Chantixology mansion",	
	Type = "HostageRescue",	
	MissionTriggerRadius = 500.0,
	SMS_Subject="Help Me!!",
	SMS_Message="Hey man, this is Des Proud. Im being held captive by the Church of Chantixology",
	SMS_Message2="They are holding me and my pet coyote indefinitely at one of their mansions in the Vinewood Hills",
	SMS_Message3="Break us out of here so I can get back on TV to complete my nature special",		
		
	SMS_ContactPics={"DIA_SAS1_HUNTER",
	},
	SMS_ContactNames={"Des Proud",
	},
	--SMS_NoFailedMessage=true,
	--SMS_NoPassedMessage=true,
	SMS_FailedSubject="Oh No!",
	SMS_FailedMessage="This is terrible! I was counting on you bro!",
	SMS_PassedSubject="Aho!",
	SMS_PassedMessage="Thank you brother. Take the reward money, its well deserved. Peace.",	

    Blip = {
      Title = "Mission: OT VIII",
      Position = { x = -138.08, y = 869.04, z = 232.69},
      Icon     = 58,
      Display  = 4,
      Size     = 1.2,
      Color    = 1,
    },
	


    Marker = {
      Type     = 1,
      Position = { x = -138.08, y = 869.04, z = 231.69}, -- x = -138.08, y = 869.04, z = 231.69 --{ x = -2953.18, y = 9.74, z = 7.5 }, x = -2948.57, y = 2.08, z = 7.45
      Size     = {x = 5.0, y = 5.0, z = 2.0},
      Color    = {r = 100, g = 100, b = 204},
      DrawDistance = 100.0,
    },
	BlipS = { --safehouse blip 
		  Title = "Mission Safehouse",
		  Position = { x = 1731.94, y = 3308.24, z = 41.22}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 417,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 2,
		  Alpha	 =80, 
	},	
	MarkerS = { --safehouse marker
		  Type     = 1,
		  Position = { x = 1731.94, y = 3308.24, z = 40.22},  --{  x = 1944.96, y = 3150.6, z = 46.77}, 
		  Size     = {x = 6.0, y = 6.0, z = 2.0},
		  Color    = {r = 117, g = 218, b = 255},
		  DrawDistance = 200.0,
	},
	BlipSL = { --safehouse Vehicle blip 
		  Title = "Mission Vehicle Safehouse",
		  Position = { x = 1480.63, y = 3167.93, z = 40.99}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 421,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
	},
	BlipSB = { --safehouse boat blip 
		  Title = "Mission Boat Safehouse",
		  Position = {x = 1481.84, y = 3873.37, z = 30.04}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		 Icon     = 404,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
	},
	
	Events = {

	   { 
		  Type="Squad",
		  Position = {  x = -137.68, y = 883.01, z = 233.76, heading = 297.23}, 
		  Size     = {radius=300.0},
		  SpawnHeight = 200.0,
		  FacePlayer = true,
		  NumberPeds=25,
		  SquadSpawnRadius=50.0,
		  modelHash="mp_m_boatstaff_01",
		  CheckGroundZ=true,	
		 Message =  "Ocean Org reinforcements deployed. Its a trap!"		  
		},
	
	},		
	
	--***Must Set 'realId' too, which must is always the same as 'id' for props to not float***
	Props = {
	
    },

	Pickups = {
		--{ id=1, Name = "PICKUP_WEAPON_ASSAULTRIFLE", Amount = 1.0, Position = { x = -2953.06, y = 10.81, z = 7.96, heading = 232.22 }},
	},
	MissionPickups = {
	--{ id=1, Name = "PICKUP_WEAPON_COMBATMG", Amount = 1.0, Position = { x = -2944.06, y = 10.81, z = 7.96, heading = 232.22 }},
		
		
	},	
		
	

    Peds = {
        
        {id = 1, modelHash = "a_c_coyote", x = -131.59, y = 867.9, z = 232.69, heading = 118.57,friendly=true,invincible=true},
		{id = 2,   modelHash = "ig_hunter",x = -134.69, y = 870.42, z = 232.69, heading = 120.14,friendly=true,invincible=true},
		
		{id = 3,  Weapon= 0xE284C527,  modelHash = "mp_m_boatstaff_01",x = -139.44, y = 869.89, z = 232.7, heading = 234.04,wanderinarea=true},
		
		{id = 4,Weapon= 0x83BF0278,   modelHash = "mp_m_boatstaff_01",x = -131.01, y = 858.56, z = 232.7, heading = 83.48},
		
		{id = 5, Weapon= 0x05FC3C11,  modelHash = "mp_m_boatstaff_01",x = -152.33, y = 885.71, z = 233.46, heading = 204.08 },
		
		{id = 6, Weapon= 0x05FC3C11, modelHash = "mp_m_boatstaff_01",x = -169.3, y = 895.02, z = 233.47, heading = 75.65,wanderinarea=true},
		
		{id = 7, Weapon= 0x63AB0442,  modelHash = "mp_m_boatstaff_01",x = -133.26, y = 899.14, z = 235.66, heading = 272.01},
		
		{id = 8, Weapon= 0xBFEFFF6D,  modelHash = "mp_m_boatstaff_01",x = -128.11, y = 903.51, z = 235.76, heading = 247.05,wanderinarea=true},
		
   
    },

    Vehicles = {
    
   	  --**IMPORTANT: make sure the id of the ped starts from 1, each Peds id in above, increments by 1 and matches that entries index if it were in an array***
	  --vehicles are not consistent, so use ExtraPeds at your own discretion.
	  --Below takes a ped with id=1 from Peds above and will put it in seatid = -2  
		{id = 1, id2 = 1, Vehicle = "trailersmall2", nomods=true, modelHash = "mp_m_boatstaff_01",  x = -180.47, y = 854.62, z = 232.7, heading = 136.03},	  
	  --{id = 1, id2 = 1, Vehicle = "khanjali", modelHash = "s_m_y_ammucity_01",  x = -2970.94, y = 5.36, z = 6.6, heading = 244.62,driving=true,pilot=true},
	  --{id = 1, id2 = 1, Vehicle = "hydra", modelHash = "s_m_y_ammucity_01",  x = -2970.94, y = 5.36, z = 6.6, heading = 244.62,driving=true,pilot=true},
	  --{id = 2, id2 = 2, Vehicle = "toro2", modelHash = "s_m_y_ammucity_01",  x = -3014.83, y = -43.5, z = 0.13, heading = 151.19, driving=true,flee=true},
    }
  } ,
  Mission3 = {
    
    StartMessage = "Mercenaries are assembling~n~to take over Fort Zancudo!~n~Eliminate them",
	FinishMessage = "Mission Accomplished!",
	Type = "Assassinate",
	MissionTitle = "Battle for Fort Zancudo",
	MissionMessage = "Stop the mercenaries from taking over Fort Zancudo",
	MissionTriggerRadius = 1500.0,
	VehicleGotoMissionTargetVehicle=6,
	--VehicleGotoMissionTargetCoords={x = -2084.59, y = 1465.03, z = 275.15},
	
	SMS_Subject="Battle for Fort Zancudo",
	SMS_Message="Mercenaries are assembling to take over Fort Zancudo!~n~Eliminate them",
		
	SMS_ContactPics={"CHAR_MP_ARMY_CONTACT",
	},
	SMS_ContactNames={"Military Contact",
	},
	SMS_NoFailedMessage=true,
	--SMS_NoPassedMessage=true,
	SMS_FailedSubject="",
	SMS_FailedMessage="",
	SMS_PassedSubject="Great Job",
	SMS_PassedMessage="Thank you for your service",		
	
	
	SafeHouseVehicles = 
	{
	"rhino",
	"khanjali",
	"apc",
	"insurgent3",
	"barrage"

	},
	SafeHouseAircraft = 
	{
	"hydra",
	"lazer",
	"strikeforce"

	},
	--TargetKillReward = 1500, 
	--KillReward = 150,

    Blip = {
      Title = "Mission Objective",
      Position = { x = -2074.59, y = 1475.03, z = 275.15 },
      Icon     = 58,
      Display  = 4,
      Size     = 1.2,
      Color    = 1,
    },

    Marker = {
      Type     = 1,
      Position = { x = -2074.59, y = 1475.03, z = 274.15  },
      Size     = {x = 5.0, y = 5.0, z = 2.0},
      Color    = {r = 100, g = 100, b = 204},
      DrawDistance = 100.0,
    },
	BlipS = { --safehouse blip 
		  Title = "Mission Safehouse",
		  Position = {x = -2108.16, y = 3275.45, z = 38.73}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 417,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 2,
		  Alpha	 =80, 
	},	
	MarkerS = { --safehouse marker
		  Type     = 1,
		  Position = { x = -2108.16, y = 3275.45, z = 37.73},  --{  x = 1944.96, y = 3150.6, z = 46.77}, 
		  Size     = {x = 6.0, y = 6.0, z = 2.0},
		  Color    = {r = 117, g = 218, b = 255},
		  DrawDistance = 200.0,
	},
	BlipSL = { --safehouse Vehicle blip 
		  Title = "Mission Vehicle Safehouse",
		  Position = { x = -2451.21, y = 3134.29, z = 32.82, heading = 156.25}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 421,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
	},
	BlipSB = { --safehouse boat blip 
		  Title = "Mission Boat Safehouse",
		  Position = {x = -3238.09, y = 3380.0, z = 0.18}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		 Icon     = 404,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
	},
	
	Events = {

	   { 
		  Type="Squad",
		  Position = { x = -2074.59, y = 1475.03, z = 275.15}, 
		  Size     = {radius=1000.0},
		  --SpawnHeight = 200.0,
		 -- FacePlayer = true,
		  NumberPeds=25,
		  SquadSpawnRadius=50.0,
		  modelHash="s_m_y_ammucity_01",
		  CheckGroundZ=true,
		  Target=true,
		},
	

	   { 
		  Type="Aircraft",
		  Position = {  x = -2096.12, y = 1483.89, z = 279.16, heading = 97.67}, 
		  Size     = {radius=1000.0},
		  SpawnHeight = 50.0,
		 FacePlayer = true,
		 -- NumberPeds=25,
		  --SquadSpawnRadius=50.0,
		  modelHash="s_m_y_ammucity_01",
		  Vehicle="lazer",
		  Target=true,
		  --CheckGroundZ=true,		  
		},
		
	 --[[  { 
		  Type="Aircraft",
		  Position = {  x = -1971.82, y = 1460.12, z = 268.38, heading = 252.11}, 
		  Size     = {radius=1000.0},
		  SpawnHeight = 50.0,
		 -- FacePlayer = true,
		 -- NumberPeds=25,
		  --SquadSpawnRadius=50.0,
		  modelHash="s_m_y_ammucity_01",
		  Vehicle="valkyrie",
		  Target=true,
		  --CheckGroundZ=true,		  
		},	
		]]--		
	
	},			

    Peds = {
        
        {id = 1, Weapon = 0x687652CE, modelHash = "s_m_y_ammucity_01", x = -1980.96, y = 1469.05, z = 268.92, heading = 265.89, target=true,wanderinarea=true},
		{id = 2, Weapon = 0x687652CE, modelHash = "s_m_y_ammucity_01", x = -2022.59, y = 1478.8, z = 272.15, heading = 104.57, target=true,wanderinarea=true},
		{id = 3, Weapon = 0x687652CE, modelHash = "s_m_y_ammucity_01", x = -2014.97, y = 1451.01, z = 271.92, heading = 206.34, target=true,wanderinarea=true},
		
   
    },

    Vehicles = {
      -- ID: id of NPC | name: Name of Blip | BlipID: Icone of Blip | VoiceName: NPC Talk When near it | Ambiance: Ambiance of Shop | Weapon: Hash of Weapon | modelHash: Model | X: Position x | Y: Position Y | Z: Position Z | heading: Where Npc look
	  
	  --id2 is the primary ped for the vehicles, which gets set to seatid=-1, which is typically the default for a vehicle for the driver.
	  --ExtraPeds will take Peds from the Peds array above and put them in a seatid in this vehicle to partner with the primary ped, as a passenger. 
	  --**IMPORTANT: make sure the id of the ped starts from 1, each Peds id in above, increments by 1 and matches that entries index if it were in an array***
	  --vehicles are not consistent, so use ExtraPeds at your own discretion.
	  --Below takes a ped with id=1 from Peds above and will put it in seatid = -2
      {id = 1, id2 = 1, Vehicle = "trailersmall2",nomods=true, modelHash = "s_m_y_ammucity_01", x = -2060.33, y = 1522.0, z = 281.4, heading = 347.35, target=true},
	  {id = 2, id2 = 2, Vehicle = "trailersmall2",nomods=true, modelHash = "s_m_y_ammucity_01",  x = -2049.6, y = 1430.96, z = 275.81, heading = 212.78, target=true},
	  {id = 3, id2 = 3, Vehicle = "trailersmall2", nomods=true,modelHash = "s_m_y_ammucity_01",  x = -2127.29, y = 1470.08, z = 284.56, heading = 240.86, target=true},
	  
	  {id = 4, id2 = 4, Vehicle = "khanjali", modelHash = "s_m_y_ammucity_01",  x = -2103.88, y = 1494.37, z = 282.54, heading = 240.44, target=true,driving=true},
	  {id = 5, id2 = 5, Vehicle = "rhino", modelHash = "s_m_y_ammucity_01",  x = -2034.77, y = 1497.24, z = 276.13, heading = 147.64, target=true,driving=true},
	  
	  {id = 6, id2 = 6, Vehicle = "trailersmall", modelHash = "s_m_y_ammucity_01",  x = -2084.59, y = 1465.03, z = 275.15, heading = 147.64, target=true,driving=true},
	  
	  {id = 7, id2 = 7, Vehicle = "bombushka", modelHash = "s_m_y_ammucity_01",  x = -1971.82, y = 1460.12, z = 268.38 + 50, heading = 252.11,driving=true,pilot=true, target=true,isAircraft=true,VehicleGotoMissionTarget=true,SetBlockingOfNonTemporaryEvents=true,},
	 -- {id = 7, id2 = 7, Vehicle = "hydra", modelHash = "s_m_y_ammucity_01",  x = -2096.12, y = 1483.89, z = 279.16 + 50, heading = 97.67,driving=true,pilot=true, target=true,isAircraft=true},
	 -- {id = 6, Vehicle = "barrage", modelHash = "s_m_y_ammucity_01",  x = -2053.69, y = 1557.33, z = 274.87, heading = 70.73},	  --leave out the id2, and the vehicle the player can use. It will disappear when the mission is over.
	  
	 
    }
  },
  
   Mission4 = {
    
    StartMessage = "Mercenaries for hire have captured another~n~construction site for ransom. Eliminate them!",
	FinishMessage = "Mission Completed!",
	MissionTitle = "Takedown",
	MissionMessage = "Eliminate the mercenaries who have held the construction site for ransom",	
	Type = "Assassinate",
	VehicleGotoMissionTargetVehicle=1,
	MissionTriggerRadius = 500.0,

	SMS_Subject="Takedown",
	SMS_Message="Mercenaries for hire have captured another~n~construction site for ransom. Eliminate them!",
		
	SMS_ContactPics={"CHAR_MP_ARMY_CONTACT",
	},
	SMS_ContactNames={"Military Contact",
	},
	SMS_NoFailedMessage=true,
	--SMS_NoPassedMessage=true,
	SMS_FailedSubject="",
	SMS_FailedMessage="",
	SMS_PassedSubject="Great Job",
	SMS_PassedMessage="Thank you for your service",		

    Blip = {
      Title = "Mission: Takedown",
      Position = { x = 0.30, y = -399.48, z = 39.43 },
      Icon     = 58,
      Display  = 4,
      Size     = 1.2,
      Color    = 1,
    },

    Marker = {
      Type     = 1,
      Position = { x = 0.30, y = -399.48, z = 38.43 },
      Size     = {x = 5.0, y = 5.0, z = 2.0},
      Color    = {r = 100, g = 100, b = 204},
      DrawDistance = 100.0,
    },
		BlipS = { --safehouse blip 
		  Title = "Mission Start",
		  Position = { x = -1694.94, y = -3152.18, z = 23.32}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 417,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 2,
		  Alpha	 =80, 
		},	
		 MarkerS = { --safehouse marker
		  Type     = 1,
		  Position = { x = -1694.94, y = -3152.18, z = 23.32},  --{  x = 1944.96, y = 3150.6, z = 46.77}, 
		  Size     = {x = 6.0, y = 6.0, z = 2.0},
		  Color    = {r = 117, g = 218, b = 255},
		  DrawDistance = 200.0,
		},
		BlipSL = { --safehouse Vehicle blip 
		  Title = "Mission Vehicle Safehouse",
		  Position = { x = -1469.37, y = -2967.27, z = 13.3}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 421,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},
		BlipSB = { --safehouse boat blip 
		  Title = "Mission Boat Safehouse",
		  Position = {x = 413.98, y = -3411.47, z = 0.23}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		 Icon     = 404,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},

    Peds = {
        -- ID: id of NPC | name: Name of Blip | BlipID: Icone of Blip | VoiceName: NPC Talk When near it | Ambiance: Ambiance of Shop | Weapon: Hash of Weapon | modelHash: Model | X: Position x | Y: Position Y | Z: Position Z | heading: Where Npc look
        {id = 1, Weapon = 0x63AB0442, modelHash = "s_m_y_ammucity_01", x = 4.82, y = -393.00, z = 39.40, heading = 338.78, armor=100, target=true},
       {id = 2, Weapon =  0xB1CA77B1, modelHash = "s_m_y_ammucity_01", x = 3.56, y = -387.80, z = 39.43, heading = 289.46, heading = 82.01, armor=100,target=true},
        {id = 3, Weapon = 0x83BF0278, modelHash = "s_m_y_ammucity_01", x = 7.51, y = -386.08, z = 39.33, heading = 308.95, armor=100, target=true},
		{id = 4, Weapon = 0x83BF0278, modelHash = "s_m_y_ammucity_01", x = 8.51, y = -386.08, z = 39.33, heading = 308.95, armor=100, target=true},
		{id = 5, Weapon = 0x83BF0278, modelHash = "s_m_y_ammucity_01", x = 9.51, y = -386.08, z = 39.33, heading = 308.95, armor=100, target=true},
		{id = 6, Weapon = 0x83BF0278, modelHash = "s_m_y_ammucity_01", x = 10.51, y = -386.08, z = 39.33, heading = 308.95, armor=100, target=true},
		{id = 7, Weapon = 0x83BF0278, modelHash = "s_m_y_ammucity_01", x = 11.51, y = -386.08, z = 39.33, heading = 308.95, armor=100, target=true},
		{id = 7, Weapon = 0x83BF0278, modelHash = "s_m_y_ammucity_01", x = 11.51, y = -386.08, z = 39.33, heading = 308.95, armor=100, target=true},
		{id = 8, Weapon = 0x63AB0442, modelHash = "s_m_y_ammucity_01", x = 12.51, y = -386.08, z = 39.33, heading = 308.95, armor=100, target=true},
 
    },

    Vehicles = {
      -- ID: id of NPC | name: Name of Blip | BlipID: Icone of Blip | VoiceName: NPC Talk When near it | Ambiance: Ambiance of Shop | Weapon: Hash of Weapon | modelHash: Model | X: Position x | Y: Position Y | Z: Position Z | heading: Where Npc look
	  
	  --id2 is the primary ped for the vehicles, which gets set to seatid=-1, which is typically the default for a vehicle for the driver.
	  --ExtraPeds will take Peds from the Peds array above and put them in a seatid in this vehicle to partner with the primary ped, as a passenger. 
	  --**IMPORTANT: make sure the id of the ped starts from 1, each Peds id in above, increments by 1 and matches that entries index if it were in an array***
	  --vehicles are not consistent, so use ExtraPeds at your own discretion.
	  --Below takes a ped with id=1 from Peds above and will put it in seatid = -2
      {id = 1, id2 = 1, Vehicle = "insurgent3",Weapon=0x13532244, modelHash = "s_m_y_ammucity_01", x = 0.30, y = -399.48, z = 39.43, heading = 10.41, armor=100, movespeed=20.0, target=true, flee=true, driving=true, conqueror=true},
	 {id = 2, id2 = 2, Vehicle = "akula", modelHash = "s_m_y_ammucity_01",  x = 0.30, y = -399.48, z = 39.43+30.0, heading = 10.41,driving=true,pilot=true, target=true,isAircraft=true,VehicleGotoMissionTarget=true,SetBlockingOfNonTemporaryEvents=true,},	  
    }
  },
  
  Mission5 = {
    
    StartMessage = "A maniac on coke has stolen a supercar~n~and an exotic dancer and is running over people~n~Stop him!",
	FinishMessage = "Mission Completed!",
	MissionTitle = "Wonderland",
	MissionMessage = "Take out the maniac hit and run driver and rescue the stripper if possible",		
	Type = "Assassinate",
	MissionTriggerRadius = 500.0,
	--VehicleGotoMissionTarget=true,
	--HostageRescue=true,
	
	SMS_Subject="Help!",
	SMS_Message="Help me! I've been kidnapped by a maniac in a sports car. He's coked up and running over people!",
		
	SMS_ContactPics={"CHAR_STRIPPER_INFERNUS",
	},
	SMS_ContactNames={"Juliet",
	},
	SMS_NoFailedMessage=true,
	SMS_NoPassedMessage=true,
	SMS_FailedSubject="",
	SMS_FailedMessage="",
	SMS_PassedSubject="Thank you",
	SMS_PassedMessage="You are my hero",			
	

    Blip = {
      Title = "Mission: Wonderland",
      Position = {x = 275.7607, y = 1686.501, z = 237.8363},
      Icon     = 58,
      Display  = 4,
      Size     = 1.2,
      Color    = 1,
    },

    Marker = {
      Type     = 1,
      Position = { x = 275.7607, y = 1686.501, z = 236.8363 },
      Size     = {x = 5.0, y = 5.0, z = 2.0},
      Color    = {r = 100, g = 100, b = 204},
      DrawDistance = 100.0,
    },
		BlipS = { --safehouse blip 
		  Title = "Mission Safehouse",
		  Position = { x = 1731.94, y = 3308.24, z = 41.22}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 417,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 2,
		  Alpha	 =80, 
		},	
		 MarkerS = { --safehouse marker
		  Type     = 1,
		  Position = { x = 1731.94, y = 3308.24, z = 40.22},  --{  x = 1944.96, y = 3150.6, z = 46.77}, 
		  Size     = {x = 6.0, y = 6.0, z = 2.0},
		  Color    = {r = 117, g = 218, b = 255},
		  DrawDistance = 200.0,
		},
		BlipSL = { --safehouse Vehicle blip 
		  Title = "Mission Vehicle Safehouse",
		  Position = { x = 1480.63, y = 3167.93, z = 40.99}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 421,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},
		BlipSB = { --safehouse boat blip 
		  Title = "Mission Boat Safehouse",
		  Position = {x = 1481.84, y = 3873.37, z = 30.04}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		 Icon     = 404,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},

    Peds = {
        -- ID: id of NPC | name: Name of Blip | BlipID: Icone of Blip | VoiceName: NPC Talk When near it | Ambiance: Ambiance of Shop | Weapon: Hash of Weapon | modelHash: Model | X: Position x | Y: Position Y | Z: Position Z | heading: Where Npc look
        {id = 1, modelHash = "S_F_Y_StripperLite", x = 275.7607, y = 1686.501, z = 237.8363, heading = 338.78, armor=100, friendly=true},
 
    },

    Vehicles = {
      -- ID: id of NPC | name: Name of Blip | BlipID: Icone of Blip | VoiceName: NPC Talk When near it | Ambiance: Ambiance of Shop | Weapon: Hash of Weapon | modelHash: Model | X: Position x | Y: Position Y | Z: Position Z | heading: Where Npc look
	  
	  --id2 is the primary ped for the vehicles, which gets set to seatid=-1, which is typically the default for a vehicle for the driver.
	  --ExtraPeds will take Peds from the Peds array above and put them in a seatid in this vehicle to partner with the primary ped, as a passenger. 
	  --**IMPORTANT: make sure the id of the ped starts from 1, each Peds id in above, increments by 1 and matches that entries index if it were in an array***
	  --vehicles are not consistent, so use ExtraPeds at your own discretion.
	  --Below takes a ped with id=1 from Peds above and will put it in seatid = -2
      {id = 1, id2 = 1, Weapon =0x2BE6766B, Vehicle = "kuruma2", noFill=true, modelHash = "IG_TylerDix",ExtraPeds={{id=1,seatid=0}}, x = 275.7607, y = 1686.501, z = 237.8363, heading = 162.26272, armor=100, target=true, driving=true, movespeed=120.0, flee=true,conqueror=true},
	 -- {id = 2, id2 = 2, Weapon =0x2BE6766B, Vehicle = "kuruma2", noFill=true, modelHash = "IG_TylerDix",ExtraPeds={{id=1,seatid=0}},x = -155.82, y = 1954.74, z = 193.84, heading = 143.31, armor=100,  driving=true, movespeed=120.0, flee=true,conqueror=true,VehicleGotoMissionTargetVehicle=1,VehicleGotoMissionTarget=true,SetBlockingOfNonTemporaryEvents=true},
    }
  },
  
  Mission6 = {
    
    StartMessage = "Rescue the Governor!~n~Secure his secret dossier before the radicals do!",
	FinishMessage = "Mission Completed!",
	MissionTitle = "Escape From Los Santos",
	MissionMessage = "The Governor's plane was brought down by radicals. Retrieve his secret dossier for ransom",	
	Type = "ObjectiveRescue",	
	--TargetKillReward = 1500, 
	--KillReward = 150,
	HostageKillPenalty=5000,
	HostageRescueReward = 5000,
	ObjectiveRescueShortRangeBlip = true,
	MissionTriggerRadius = 500.0,
	
	SMS_Subject="DECODE: AIRFORCE ONE",
	SMS_Message="Tell this to the people, when they asked where their Governor went...",
	SMS_Message2="We, The Liberation Front of San Andreas, in the name of the oppressed, have struck a fatal blow",
	SMS_Message3="The Governor's plane was brought down. We have captured him and obtained his secret files.",	
		
	SMS_ContactPics={"CHAR_MOLLY",
	},
	SMS_ContactNames={"The LFSA",
	},
	--SMS_NoFailedMessage=true,
	--SMS_NoPassedMessage=true,
	SMS_FailedSubject="Pigs",
	SMS_FailedMessage="You should have stayed away, this is much bigger than you",
	SMS_PassedSubject="Pigs",
	SMS_PassedMessage="You stole the secret files and sold them for ransom yourself.",			
	
	
    Blip = {
      Title = "Mission: Governor's Crashed Plane",
      Position = {x = -184.57, y = -893.92, z = 29.34}, 
      Icon     = 58,
      Display  = 4,
      Size     = 1.2,
      Color    = 1,
    },

    Marker = {
      Type     = 1,
      Position = {x = -184.57, y = -893.92, z = 27.34}, 
      Size     = {x = 7.0, y = 7.0, z = 4.5},
      Color    = {r = 100, g = 100, b = 204},
      DrawDistance = 100.0,
    },
		BlipS = { --safehouse blip 
		  Title = "Mission Safehouse",
		  Position = { x = -1694.94, y = -3152.18, z = 23.32}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 417,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 2,
		  Alpha	 =80, 
		},	
		 MarkerS = { --safehouse marker
		  Type     = 1,
		  Position = { x = -1694.94, y = -3152.18, z = 23.32},  --{  x = 1944.96, y = 3150.6, z = 46.77}, 
		  Size     = {x = 6.0, y = 6.0, z = 2.0},
		  Color    = {r = 117, g = 218, b = 255},
		  DrawDistance = 200.0,
		},
		BlipSL = { --safehouse Vehicle blip 
		  Title = "Mission Vehicle Safehouse",
		  Position = { x = -1469.37, y = -2967.27, z = 13.3}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 421,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},
		BlipSB = { --safehouse boat blip 
		  Title = "Mission Boat Safehouse",
		  Position = {x = 413.98, y = -3411.47, z = 0.23}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		 Icon     = 404,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},
		
	--***Must Set 'realId' too, which must is always the same as 'id' for props to not float***
	Props = {
		{ id=1,  Name = "apa_mp_apa_crashed_usaf_01a", Position = { x = -184.57, y = -893.92, z = 29.34, heading = 67.37 },dontsetheading=true},
		{ id=2,  Name = "prop_jet_bloodsplat_01", Position = { x = -184.96, y = -901.75, z = 29.34, heading = 361.48 },dontsetheading=true},
		{ id=3,  Name = "bkr_prop_biker_case_shut",isObjective=true, Position = { x = -187.42, y = -892.78, z = 29.34, heading = 257.95 },dontsetheading=true},
		{ id=3,  Name = "xm_prop_x17_corpse_01", Position = {x = -182.48, y = -891.75, z = 29.34, heading = -1.28 },dontsetheading=true},
		{ id=4,  Name = "xm_prop_x17_bag_01c",isObjective=true, Position = {x = -126.28, y = -872.33, z = 44.22, heading = 229.71}},
		{ id=5,  Name = "prop_amb_phone",isObjective=true, Position = {x = -232.15, y = -913.48, z = 32.31, heading = 337.21}},
    },

	Pickups = {
	},
	MissionPickups = {
		
	},
Events = {

	   { 
		  Type="Squad",
		  Position = {x = -184.57, y = -893.92, z = 29.34}, 
		  Size     = {radius=500.0},
		  --SpawnHeight = 200.0,
		 -- FacePlayer = true,
		  NumberPeds=20,
		  SquadSpawnRadius=100.0,
		 -- modelHash="s_m_y_ammucity_01",
		  CheckGroundZ=true,		  
		},
	

	   { 
		  Type="Vehicle",
		  Position = { x = -193.63, y = -874.79, z = 29.26}, 
		  Size     = {radius=500.0},
		  --SpawnHeight = 50.0,
		 FacePlayer = true,
		 -- NumberPeds=25,
		  --SquadSpawnRadius=50.0,
		  --modelHash="s_m_y_ammucity_01",
		 -- Vehicle="hydra"
		  --CheckGroundZ=true,		  
		},
		
	
	},				
		

    Peds = {
        -- ID: id of NPC | name: Name of Blip | BlipID: Icone of Blip | VoiceName: NPC Talk When near it | Ambiance: Ambiance of Shop | Weapon: Hash of Weapon | modelHash: Model | X: Position x | Y: Position Y | Z: Position Z | heading: Where Npc look
        {id = 1,  modelHash = "IG_Paper",  x = -186.03, y = -891.08, z = 29.34, heading = 49.44, friendly=true},
		{id = 2,  realId=2, Weapon = 0x05FC3C11, modelHash = "G_M_M_ChiCold_01", x = -228.69, y = -914.71, z = 32.31, heading = 295.14},
		{id = 3,  realId=3, Weapon = 0xBFEFFF6D, modelHash = "s_m_y_xmech_02", x = -228.69, y = -914.71, z = 32.31, heading = 295.14},
       {id = 4, Weapon = 0x05FC3C11, modelHash = "G_M_M_ChiCold_01",  x = -134.69, y = -873.15, z = 44.21, heading = 103.3},
      {id = 5, Weapon = 0xB1CA77B1, modelHash = "s_m_y_xmech_02",x = -137.42, y = -867.44, z = 44.21, heading = 97.35},
	   {id = 6, Weapon = 0x83BF0278, modelHash = "U_M_Y_Tattoo_01", x = -149.76, y = -855.38, z = 45.03, heading = 4.42},
       {id = 7, Weapon = 0xEFE7E2DF, modelHash = "G_M_M_ChiCold_01", x = -141.88, y = -835.48, z = 44.14, heading = 59.95},
       {id = 8, Weapon = 0xBFEFFF6D, modelHash = "IG_Terry",x = -146.09, y = -857.15, z = 44.24, heading = 149.91},
        {id = 9, Weapon = 0xAF113F99, modelHash = "G_M_M_ChiCold_01", x = -126.59, y = -889.57, z = 44.2, heading = 180.91},
        {id = 10, Weapon = 0x63AB0442, modelHash = "U_M_Y_MilitaryBum", x = -106.92, y = -896.75, z = 45.58, heading = 212.85},
        {id = 11, Weapon = 0x83BF0278, modelHash = "U_M_Y_Tattoo_01",  x = -91.24, y = -905.26, z = 44.34, heading = 179.98},
       {id = 12, Weapon = 0x83BF0278, modelHash = "s_m_y_xmech_02",  x = -222.45, y = -925.26, z = 30.15, heading = 247.56},
       {id = 13, Weapon =  0x83BF0278, modelHash = "G_M_M_ChiCold_01", x = -165.96, y = -931.28, z = 32.99, heading = 134.78},
       
	   {id = 14, Weapon =  0x0C472FE2, modelHash = "CSB_Chin_goon", x = -91.79, y = -893.78, z = 44.22, heading = 331.01 },
        {id = 15, Weapon = 0x83BF0278, modelHash = "G_M_M_ChiCold_01", x = -129.99, y = -852.73, z = 44.22, heading = 307.19},
		
       {id = 16, Weapon = 0x05FC3C11, modelHash = "U_M_Y_Tattoo_01", x = -192.68, y = -830.22, z = 30.83, heading = 309.78},		
		{id = 17, Weapon = 0xAF113F99, modelHash = "CSB_Cletus", x = -202.63, y = -860.75, z = 30.27, heading = 231.88},		
		{id = 18, Weapon = 0x05FC3C11, modelHash = "U_M_Y_MilitaryBum", x = -231.49, y = -851.53, z = 30.68, heading = 154.04},		
		 {id = 19, Weapon = 0x42BF8A85, modelHash = "CSB_Chin_goon", x = -162.67, y = -924.13, z = 29.29, heading = 41.64},		
		 {id = 20, Weapon = 0x687652CE, modelHash = "s_m_y_xmech_02", x = -135.33, y = -928.82, z = 29.24, heading = 280.32},		
		 {id = 21, Weapon = 0xB1CA77B1, modelHash = "U_M_Y_Tattoo_01", x = -101.75, y = -898.91, z = 29.26, heading = 169.85 },		
		 {id = 22, Weapon = 0x05FC3C11, modelHash = "U_M_Y_MilitaryBum",  x = -122.46, y = -888.78, z = 29.33, heading = 111.7},

		 {id = 23, Weapon = 0x05FC3C11, modelHash = "IG_Wade", x = -176.88, y = -892.69, z = 29.34, heading = 253.02},	
		 {id = 24, Weapon = 0x5EF9FEC4, modelHash = "A_M_Y_SouCent_03",   x = -188.44, y = -888.66, z = 29.35, heading = 80.19},	
		 {id = 25, Weapon = 0x05FC3C11, modelHash = "G_M_M_ChiCold_01",   x = -188.3, y = -905.77, z = 29.36, heading = 162.03},

		 {id = 25, Weapon = 0x7FD62962, modelHash = "CSB_Cletus",  x = -143.8, y = -862.58, z = 29.99, heading = 129.62},
		{id = 26, Weapon =  0x2BE6766B, modelHash = "A_M_Y_SouCent_03",  x = -133.85, y = -878.61, z = 29.58, heading = 125.04},	
		
		{id = 27, Weapon =  0x2BE6766B, modelHash = "s_m_y_ammucity_01",  x = -190.4, y = -891.32, z = 29.34, heading = 312.46, dead=true },	
		{id = 28, Weapon =  0x2BE6766B, modelHash = "s_m_y_ammucity_01", x = -187.69, y = -885.32, z = 29.4, heading = 1.64,dead=true},	
		{id = 29, Weapon =  0x2BE6766B, modelHash = "s_m_y_ammucity_01",  x = -178.75, y = -901.38, z = 29.36, heading = 186.85,dead=true},	
		
		
		
    },


    Vehicles = {
      -- ID: id of NPC | name: Name of Blip | BlipID: Icone of Blip | VoiceName: NPC Talk When near it | Ambiance: Ambiance of Shop | Weapon: Hash of Weapon | modelHash: Model | X: Position x | Y: Position Y | Z: Position Z | heading: Where Npc look
   	  --**IMPORTANT: make sure the id of the ped starts from 1, each Peds id in above, increments by 1 and matches that entries index if it were in an array***
	  --vehicles are not consistent, so use ExtraPeds at your own discretion.
	  --Below takes a ped with id=1 from Peds above and will put it in seatid = -2   
	  --{id = 1, id2 = 1, Vehicle = "cavalcade", modelHash = "s_m_y_ammucity_01",  x = -2970.94, y = 5.36, z = 6.6, heading = 244.62},
	 -- {id = 2, id2 = 2, Vehicle = "toro2", modelHash = "s_m_y_ammucity_01",  x = -3014.83, y = -43.5, z = 0.13, heading = 151.19, driving=true},
    }
  } ,
  
   Mission7 = {
    
    StartMessage = "A UFO crashed where that UFO cult worships~n~Check it out before the FIB does!",
	FinishMessage = "Mission Completed!",
	MissionTitle = "Bad Taste",
	MissionMessage = "Investigate the UFO crash site and take what you can before the FIB gets there",	
	Type = "Objective",	
	--TargetKillReward = 1500, 
	--KillReward = 150,
	--SpawnRewardPickups = {"weapon_railgun"},
	MissionTriggerRadius = 500.0,  

	SMS_Subject="MIB",
	SMS_Message="Ok, we need some help. Believe it or not, A UFO crashed where that UFO cult worships",
	SMS_Message2="Investigate the UFO crash site and take what you can before the FIB gets there. Hurry!",
	--SMS_Message3="The Governor's plane was brought down. We have captured him and obtained his secret files.",	
		
	SMS_ContactPics={"CHAR_AGENT14",
	},
	SMS_ContactNames={"Agency Contact",
	},
	SMS_NoFailedMessage=true,
	SMS_NoPassedMessage=true,
	SMS_FailedSubject="Pigs",
	SMS_FailedMessage="You should have stayed away, this is much bigger than you",
	SMS_PassedSubject="Pigs",
	SMS_PassedMessage="You stole the secret files and sold them for ransom yourself.",	
	

    Blip = {
      Title = "Mission: UFO Crash",
      Position = {x = 1657.106, y = 428.6742, z = 245.6912},
      Icon     = 58,
      Display  = 4,
      Size     = 1.2,
      Color    = 1,
    },

    Marker = {
      Type     = 1,
      Position = {x = 1657.106, y = 428.6742, z = 244.6912}, 
      Size     = {x = 7.0, y = 7.0, z = 10.5},
      Color    = {r = 100, g = 100, b = 204},
      DrawDistance = 100.0,
    },
		BlipS = { --safehouse blip 
		  Title = "Mission Safehouse",
		  Position = { x = 1731.94, y = 3308.24, z = 41.22}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 417,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 2,
		  Alpha	 =80, 
		},	
		 MarkerS = { --safehouse marker
		  Type     = 1,
		  Position = { x = 1731.94, y = 3308.24, z = 40.22},  --{  x = 1944.96, y = 3150.6, z = 46.77}, 
		  Size     = {x = 6.0, y = 6.0, z = 2.0},
		  Color    = {r = 117, g = 218, b = 255},
		  DrawDistance = 200.0,
		},
		BlipSL = { --safehouse Vehicle blip 
		  Title = "Mission Vehicle Safehouse",
		  Position = { x = 1480.63, y = 3167.93, z = 40.99}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 421,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},
		BlipSB = { --safehouse boat blip 
		  Title = "Mission Boat Safehouse",
		  Position = {x = 1481.84, y = 3873.37, z = 30.04}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		 Icon     = 404,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},
		Events = {
	   {  
		  Type="Aircraft",
		  Position = { x = 1657.106, y = 428.6742, z = 244.6912},
		 SpawnAt =  { x = 765.36, y = 1431.71, z = 343.3}, 		  
		  Size     = {radius=150.0},
		  SpawnHeight = 200.0,
		  FacePlayer = true,
		  modelHash="s_m_m_fibsec_01",
		  Vehicle="buzzard2",
		  Message="FIB Helicopter on it's way. Hurry Up!",
		 --SpawnAt = {x = -1162.49, y = -669.87, z = 22.75, },
		},	
		},		
	--***Must Set 'realId' too, which must is always the same as 'id' for props to not float***
	Props = {
		{ id=1, realId=1, Name = "gr_prop_damship_01a", Position = {x = 1657.106, y = 428.6742, z = 245.6912, heading = 224.7846},dontsetheading=true},
		
		--gibs
		{ id=2, Name = "v_ilev_body_parts", Position = { x = 1630.22, y = 428.15, z = 251.69, heading = 353.62}},
		{ id=3, Name = "xm_prop_x17_corpse_03", Position = {x = 1635.0, y = 438.27, z = 250.07, heading = 79.43}},
		{ id=4,  Name = "v_ilev_body_parts", Position = {x = 1664.32, y = 428.17, z = 244.51, heading = 248.94}},
		{ id=5,  Name = "xm_prop_x17_corpse_03", Position = {x = 1673.0, y = 402.67, z = 245.63, heading = 238.18 }},
		{ id=6, Name = "v_ilev_body_parts", Position = {x = 1661.93, y = 437.68, z = 245.38, heading = 261.63 }},
		{ id=7, Name = "v_ilev_body_parts", Position = { x = 1652.93, y = 443.85, z = 247.71, heading = 73.47}},
		{ id=8, Name = "xm_prop_x17_corpse_03", Position = {x = 1656.9, y = 418.33, z = 246.06, heading = 170.5}},
		{ id=9,  Name = "prop_alien_egg_01", Position = { x = 1655.69, y = 427.67, z = 245.93, heading = 378.88}},
		{ id=10,  Name = "prop_alien_egg_01", Position = {x = 1657.02, y = 431.15, z = 245.82, heading = 225.31 }},
		{ id=11, Name = "prop_alien_egg_01", Position = { x = 1659.31, y = 428.12, z = 245.31, heading = 54.46 }},		
    },
	
	Pickups = {
	},
	MissionPickups = {
		
	},	
		
    Peds = {
	


	
	
	
        -- ID: id of NPC | name: Name of Blip | BlipID: Icone of Blip | VoiceName: NPC Talk When near it | Ambiance: Ambiance of Shop | Weapon: Hash of Weapon | modelHash: Model | X: Position x | Y: Position Y | Z: Position Z | heading: Where Npc look
		{id = 1,  Weapon = 0xB62D1F67,  modelHash = "s_m_m_movalien_01",   x = 1659.31, y = 428.12, z = 245.31, heading = 54.46 },
		{id = 2,  Weapon = 0x476BF155,  modelHash = "s_m_m_movalien_01",   x = 1645.85, y = 423.42, z = 248.08, heading = 114.23},
		{id = 3,  Weapon = 0xAF3696A1,  modelHash = "s_m_m_movalien_01",   x = 1655.56, y = 436.08, z = 246.49, heading = 377.0},
		{id = 4,  Weapon = 0xB62D1F67,  modelHash = "s_m_m_movalien_01",   x = 1666.97, y = 426.35, z = 244.23, heading = 258.76},
		{id = 5,  Weapon = 0x476BF155,  modelHash = "s_m_m_movalien_01",   x = 1707.88, y = 374.8, z = 235.5, heading = 163.28},
		{id = 6,  Weapon = 0xAF3696A1,  modelHash = "s_m_m_movalien_01",   x = 1636.67, y = 390.01, z = 254.54, heading = 231.38},
		{id = 7,  Weapon = 0xB62D1F67,  modelHash = "s_m_m_movalien_01",   x= 1632.32, y = 458.72, z = 250.38, heading = 36.5},
		{id = 8,  Weapon = 0x476BF155,  modelHash = "s_m_m_movalien_01",   x = 1664.22, y = 462.28, z = 247.59, heading = 317.14},
		
		{id = 9,  modelHash = "A_F_M_FatCult_01",  x = 1649.88, y = 436.38, z = 247.5, heading = 265.43, dead=true},
		{id = 10,  modelHash = "A_M_M_ACult_01",  x = 1649.88, y = 436.38, z = 247.5, heading = 265.43, dead=true},
		{id = 11,  modelHash = "A_M_Y_ACult_02",  x = 1649.88, y = 436.38, z = 247.5, heading = 265.43, dead=true},
		{id = 12,  modelHash = "A_M_Y_ACult_02",  x = 1649.88, y = 436.38, z = 247.5, heading = 265.43, dead=true},
		{id = 13,  modelHash = "A_M_M_ACult_01",  x = 1649.88, y = 436.38, z = 247.5, heading = 265.43, dead=true},
		
		
   
		
    },
	
    Vehicles = {
      -- ID: id of NPC | name: Name of Blip | BlipID: Icone of Blip | VoiceName: NPC Talk When near it | Ambiance: Ambiance of Shop | Weapon: Hash of Weapon | modelHash: Model | X: Position x | Y: Position Y | Z: Position Z | heading: Where Npc look
   	  --**IMPORTANT: make sure the id of the ped starts from 1, each Peds id in above, increments by 1 and matches that entries index if it were in an array***
	  --vehicles are not consistent, so use ExtraPeds at your own discretion.
	  --Below takes a ped with id=1 from Peds above and will put it in seatid = -2   
    }
  } ,
  
   Mission8 = {
    
    StartMessage = "A corporate jet trafficking drugs was shot down~n~by a rival faction~n~Secure the narcotics!",
	FinishMessage = "Mission Completed!",
	MissionTitle = "Contra III: The Drug Wars",
	MissionMessage = "Secure the narcotics from the smuggler's jet that was shot down",	
	Type = "Objective",	
	MissionTriggerRadius = 1000.0,
	VehicleGotoMissionTargetVehicle=2,	
	--TargetKillReward = 1500, 
	--KillReward = 150,
	
	SMS_Subject="Contraband",
	SMS_Message="Hi, I need someone to get on this. A corporate jet trafficking drugs was shot down by competition",
	SMS_Message2="Secure the narcotics from the smuggler's jet that was downed",
	--SMS_Message3="The Governor's plane was brought down. We have captured him and obtained his secret files.",	
		
	SMS_ContactPics={"DIA_AGENT14",
	},
	SMS_ContactNames={"Agency Contact",
	},
	SMS_NoFailedMessage=true,
	SMS_NoPassedMessage=true,
	SMS_FailedSubject="Pigs",
	SMS_FailedMessage="You should have stayed away, this is much bigger than you",
	SMS_PassedSubject="Pigs",
	SMS_PassedMessage="You stole the secret files and sold them for ransom yourself.",	

    Blip = {
      Title = "Mission: Secure narcotics from crashed plane",
      Position = {x = 302.86, y = 4373.86, z = 51.61},
      Icon     = 58,
      Display  = 4,
      Size     = 1.2,
      Color    = 1,
    },

    Marker = {
      Type     = 1,
      Position = {x = 302.86, y = 4373.86, z = 50.61}, 
      Size     = {x = 7.0, y = 7.0, z = 4.0},
      Color    = {r = 100, g = 100, b = 204},
      DrawDistance = 100.0,
    },
		BlipS = { --safehouse blip 
		  Title = "Mission Safehouse",
		  Position = { x = 1731.94, y = 3308.24, z = 41.22}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 417,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 2,
		  Alpha	 =80, 
		},	
		 MarkerS = { --safehouse marker
		  Type     = 1,
		  Position = { x = 1731.94, y = 3308.24, z = 40.22},  --{  x = 1944.96, y = 3150.6, z = 46.77}, 
		  Size     = {x = 6.0, y = 6.0, z = 2.0},
		  Color    = {r = 117, g = 218, b = 255},
		  DrawDistance = 200.0,
		},
		BlipSL = { --safehouse Vehicle blip 
		  Title = "Mission Vehicle Safehouse",
		  Position = { x = 1480.63, y = 3167.93, z = 40.99}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 421,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},
		BlipSB = { --safehouse boat blip 
		  Title = "Mission Boat Safehouse",
		  Position = {x = 1481.84, y = 3873.37, z = 30.04}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		 Icon     = 404,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},	
	--***Must Set 'realId' too, which must is always the same as 'id' for props to not float***
	Props = {
	
	{ id=1,  Name = "prop_shamal_crash", Position = {x = 302.86, y = 4373.86, z = 51.61, heading = 68.35},dontsetheading=true},
	{ id=2,  Name = "prop_drug_package", Position = { x = 299.68, y = 4376.15, z = 51.39, heading = 84.56 }},	
	{ id=3,  Name = "prop_drug_package", Position = { x = 300.2, y = 4374.17, z = 51.38, heading = 33.03 }},
	{ id=4,  Name = "prop_drug_package", Position = { x = 305.34, y = 4374.89, z = 52.0, heading = 209.16 }},	

    },
	Events = {

	   { 
		  Type="Paradrop",
		  Position = { x = 302.86, y = 4373.86, z = 51.61 }, 
		  Size     = {radius=100.0},
		  SpawnHeight = 200.0,
		  --FacePlayer = true,
		  NumberPeds=15,
		},
	
	},		
	

	Pickups = {
	},
	MissionPickups = {
		
	},	
		
    Peds = {
	
        -- ID: id of NPC | name: Name of Blip | BlipID: Icone of Blip | VoiceName: NPC Talk When near it | Ambiance: Ambiance of Shop | Weapon: Hash of Weapon | modelHash: Model | X: Position x | Y: Position Y | Z: Position Z | heading: Where Npc look
		{id = 1,  Weapon = 0x687652CE,  modelHash = "G_M_M_ChiCold_01",   x = 308.16, y = 4385.77, z = 55.02, heading = 156.5,wanderinarea=true },
		{id = 2,  Weapon = 0x83BF0278,  modelHash = "A_M_M_EastSA_02",   x = 308.16, y = 4385.77, z = 55.02, heading = 156.5 },
		
		{id = 3,  Weapon = 0x83BF0278,  modelHash = "s_m_y_xmech_02",   x = 285.49, y = 4351.96, z = 49.05, heading = 326.71 },
		
		{id = 4,  Weapon = 0x05FC3C11,  modelHash = "A_M_M_EastSA_02",   x = 307.16, y = 4385.77, z = 55.02, heading = 156.5,wanderinarea=true },
		
		{id = 5,  Weapon = 0x63AB0442,  modelHash = "CSB_Chin_goon",   x = 305.16, y = 4385.77, z = 55.02, heading = 56.5 },
		
		{id = 6,  Weapon = 0xB1CA77B1,  modelHash = "A_M_Y_SouCent_03",   x = 308.16, y = 4382.77, z = 55.02, heading = 156.5 },
	
    },
	
    Vehicles = {
	
      
   	  --**IMPORTANT: make sure the id of the ped starts from 1, each Peds id in above, increments by 1 and matches that entries index if it were in an array***
	  --vehicles are not consistent, so use ExtraPeds at your own discretion.
	  --Below takes a ped with id=1 from Peds above and will put it in seatid = -2   
	  {id = 1, id2 = 1, Weapon = 0x687652CE, Vehicle = "barrage", modelHash = "G_M_M_ChiCold_01", x = 295.32, y = 4350.68, z = 49.71, heading = 366.66},
	  {id = 2, id2 = 2, Weapon = 0x687652CE, Vehicle = "trailersmall", modelHash = "G_M_M_ChiCold_01", x = 308.16, y = 4368.13, z = 51.69, heading = 374.67},
	  {id = 3, id2 = 3, Weapon = 0x687652CE, Vehicle = "tula", modelHash = "G_M_M_ChiCold_01", x = 308.16, y = 4368.13, z = 151.69, heading = 374.67,VehicleGotoMissionTarget=true,SetBlockingOfNonTemporaryEvents=true,pilot=true,isAircraft=true, },		  
	  
	
    }
  } ,
  
  Mission9 = {
    
    StartMessage = "A mercenary helicoptor was shot down hauling ammo~n~Get the ammunition before the mercs do!",
	FinishMessage = "Mission Completed!",
	MissionTitle = "Anyone in Cherno?",
	MissionMessage = "Get the supplies from the crashed helicopter before the mercs secure it",	
	Type = "Objective",
	MissionTriggerRadius = 500.0,
	VehicleGotoMissionTargetVehicle=2,
	
	SMS_Subject="Merc Helicopter",
	SMS_Message="Got a mission for you, if you are up for it.",
	SMS_Message2="A mercenary helicoptor was shot down hauling ammo~n~Get the ammunition before the mercs do!",
	--SMS_Message3="The Governor's plane was brought down. We have captured him and obtained his secret files.",	
		
	SMS_ContactPics={"CHAR_MP_ARMY_CONTACT",
	},
	SMS_ContactNames={"Miltary Contact",
	},
	SMS_NoFailedMessage=true,
	SMS_NoPassedMessage=true,
	SMS_FailedSubject="Pigs",
	SMS_FailedMessage="You should have stayed away, this is much bigger than you",
	SMS_PassedSubject="Pigs",
	SMS_PassedMessage="You stole the secret files and sold them for ransom yourself.",
	
	--TargetKillReward = 1500, 
	--KillReward = 150,

    Blip = {
      Title = "Mission: Secure the ammo from the crashed helicopter",
      Position = { x = -1161.0, y = 4569.94, z = 142.64},
      Icon     = 58,
      Display  = 4,
      Size     = 1.2,
      Color    = 1,
    },

    Marker = {
      Type     = 1,
      Position = { x = -1161.0, y = 4569.94, z = 141.64}, 
      Size     = {x = 6.0, y = 6.0, z = 4.0},
      Color    = {r = 100, g = 100, b = 204},
      DrawDistance = 100.0,
    },
		BlipS = { --safehouse blip 
		  Title = "Mission Safehouse",
		  Position = {x = -2108.16, y = 3275.45, z = 38.73}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 417,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 2,
		  Alpha	 =80, 
		},	
		 MarkerS = { --safehouse marker
		  Type     = 1,
		  Position = { x = -2108.16, y = 3275.45, z = 37.73},  --{  x = 1944.96, y = 3150.6, z = 46.77}, 
		  Size     = {x = 6.0, y = 6.0, z = 2.0},
		  Color    = {r = 117, g = 218, b = 255},
		  DrawDistance = 200.0,
		},
		BlipSL = { --safehouse Vehicle blip 
		  Title = "Mission Vehicle Safehouse",
		  Position = { x = -2451.21, y = 3134.29, z = 32.82, heading = 156.25}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 421,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},
		BlipSB = { --safehouse boat blip 
		  Title = "Mission Boat Safehouse",
		  Position = {x = -3238.09, y = 3380.0, z = 0.18}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		 Icon     = 404,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},
	--***Must Set 'realId' too, which must is always the same as 'id' for props to not float***
	Props = {
	
		{ id=1,  Name = "sm_prop_smug_heli", Position = { x = -1161.0, y = 4569.94, z = 142.64, heading = 145.22 }},
		{ id=2,  Name = "hei_prop_heist_ammo_box", Position = { x = -1159.15, y = 4568.47, z = 142.55, heading = 150.05 }},
		{ id=3,  Name = "hei_prop_heist_ammo_box", Position = { x = -1162.83, y = 4571.43, z = 142.91, heading = 337.43 }},
		{ id=4,  Name = "hei_prop_heist_ammo_box", Position = { x = -1163.04, y = 4568.09, z = 142.67, heading = 254.89 }},
	
	
    },
	
	
	Events = {

	   { 
		  Type="Paradrop",
		  Position = { x = -1161.0, y = 4569.94, z = 142.64 }, 
		  Size     = {radius=200.0},
		  SpawnHeight = 200.0,
		  --FacePlayer = true,
		  NumberPeds=15,
		},
	
	},			



	
	Pickups = {
	},
	MissionPickups = {
		
	},	
		
	

    Peds = {
	
		{id = 1,  Weapon = 0x05FC3C11,  modelHash = "S_M_M_ChemSec_01",   x = -1170.34, y = 4597.04, z = 177.27, heading = 280.45 },
		{id = 2,  Weapon = 0x05FC3C11,  modelHash = "S_M_M_ChemSec_01",   x = -1209.82, y = 4585.97, z = 196.22, heading = 37.46},
		{id = 3,  Weapon = 0x05FC3C11,  modelHash = "S_M_M_ChemSec_01",   x = -1181.61, y = 4611.21, z = 172.68, heading = 57.46 },
		{id = 4,  Weapon = 0x687652CE,  modelHash = "S_M_M_ChemSec_01",  x = -1127.46, y = 4617.7, z = 153.66, heading = 161.84},
		{id = 5,  Weapon = 0x63AB0442,  modelHash = "S_M_M_ChemSec_01",  x = -1122.56, y = 4585.95, z = 137.82, heading = 234.6},
		{id = 6,  Weapon = 0xBFEFFF6D,  modelHash = "S_M_M_ChemSec_01",   x = -1159.03, y = 4555.89, z = 140.66, heading = 283.2},
		{id = 7,  Weapon = 0xAF113F99,  modelHash = "S_M_M_ChemSec_01",  x = -1173.78, y = 4564.25, z = 140.33, heading = 273.92 },
		{id = 8,  Weapon = 0x83BF0278,  modelHash = "S_M_M_ChemSec_01",    x = -1165.78, y = 4570.29, z = 142.66, heading = 254.67},
		{id = 9,  Weapon = 0xBFEFFF6D,  modelHash = "S_M_M_ChemSec_01",    x = -1157.42, y = 4573.4, z = 142.85, heading = 204.36},

		
    },
	
	

    Vehicles = {
      -- ID: id of NPC | name: Name of Blip | BlipID: Icone of Blip | VoiceName: NPC Talk When near it | Ambiance: Ambiance of Shop | Weapon: Hash of Weapon | modelHash: Model | X: Position x | Y: Position Y | Z: Position Z | heading: Where Npc look
   	  --**IMPORTANT: make sure the id of the ped starts from 1, each Peds id in above, increments by 1 and matches that entries index if it were in an array***
	  --vehicles are not consistent, so use ExtraPeds at your own discretion.
	  --Below takes a ped with id=1 from Peds above and will put it in seatid = -2   
	  {id = 1, id2 = 1, Vehicle = "valkyrie", modelHash = "S_M_M_ChemSec_01",  x = -1166.42, y = 4641.5, z = 155.11, heading = 210.07,driving=true,pilot=true,isAircraft=true},
	  {id = 2, id2 = 2, Weapon = 0x687652CE, Vehicle = "trailersmall", modelHash = "S_M_M_ChemSec_01", x = -1161.43, y = 4555.78, z = 140.76, heading = 206.26,Freeze=true},
	  {id = 3, id2 = 3, Vehicle = "valkyrie", modelHash = "S_M_M_ChemSec_01",  x = -1166.42, y = 4641.5, z = 165.11, heading = 210.07,driving=true,pilot=true,isAircraft=true,VehicleGotoMissionTarget=true,SetBlockingOfNonTemporaryEvents=true,},
	 -- {id = 2, id2 = 2, Vehicle = "toro2", modelHash = "s_m_y_ammucity_01",  x = -3014.83, y = -43.5, z = 0.13, heading = 151.19, driving=true},
    }
  } ,
  
  Mission10 = {
    
	StartMessage = "Stop the bandits from taking over the oil fields!~n~~r~Hurry!!",
	FinishMessage = "Mission Completed!",
	MissionTitle = "Fury Road",
	MissionMessage = "Stop the bandits from taking over the oil fields",	
	MissionTriggerStartPoint = {x = 1300.91, y = 2985.67, z = 40.28},
	MissionTriggerRadius = 10.0,
	--Type = "Assassinate",	
	Type = "Assassinate",	
	TeleportToSafeHouseOnMissionStartNoVehicle = true,
	--SafeHouseTimeTillNextUse=10000, --10 seconds
	SafeHousePedDoctors = {},
	SafeHousePedLeaders = {},
	SafeHouseProps = {"hei_prop_carrier_crate_01a"},
	SafeHouseGiveImmediately = true,
	TeleportToSafeHouseOnMissionStartDelay=2000,
	SafeHouseTimeTillNextUse=10000, --10 seconds
	--TeleportToSafeHouseMinDistance = 5,
	--RemoveWeaponsAndUpgradesAtMissionStart = true,
	--SpawnSafeHousePickups = {"WEAPON_COMBATPISTOL"},
	--SpawnSafeHouseComponents = {"COMPONENT_AT_PI_SUPP WEAPON_COMBATPISTOL","COMPONENT_COMBATPISTOL_CLIP_02 WEAPON_COMBATPISTOL"},
	--SpawnSafeHouseComponents = {"COMPONENT_COMBATPISTOL_CLIP_02 WEAPON_COMBATPISTOL"},	
	--TargetKillReward = 150, 
	--KillReward = 150,
	IsDefend = true,
	
	SMS_Subject="Fury Road",
	SMS_Message="We are taking over the oil field, and you better step out of the way",
	SMS_Message2="I salute my half-life War Boys who will ride with me eternal on the highways of Valhalla.",
	--SMS_Message3="The Governor's plane was brought down. We have captured him and obtained his secret files.",	
		
	SMS_ContactPics={"DIA_BRAD",
	},
	SMS_ContactNames={"Immortan Joe",
	},
	SMS_NoFailedMessage=true,
	SMS_NoPassedMessage=true,
	SMS_FailedSubject="HAHA",
	SMS_FailedMessage="You should have stayed away, this is much bigger than you",
	SMS_PassedSubject="Valhalla!",
	SMS_PassedMessage="Return my treasures to me, and I myself will carry you through the gates of Valhalla.",
	

    Blip2 = {
      Title = "Mission End: Defend Zone",
      Position = {x = 1453.72, y = -2282.69, z = 67.47}, --{ x = 1944.96, y = 3150.6, z = 46.77},
      Icon     = 58,
      Display  = 4,
      Size     = 1.2,
      Color    = 1,
	  Alpha	 =80, --Used for AddBlipForRadius with IsDefend Missions
    },
	Blip = {
      Title = "Mission End: Defend Zone",
      Position = { x = 1453.72, y = -2282.69, z = 67.47}, --{ x = 1944.96, y = 3150.6, z = 46.77},
      Icon     = 58,
      Display  = 4,
      Size     = 1.2,
      Color    = 1,
	  Alpha	 =80, --Used for AddBlipForRadius with IsDefend Missions
    },
		BlipS = { --safehouse blip 
		  Title = "Mission Safehouse",
		  Position = { x = 1300.91, y = 2985.67, z = 40.28}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 417,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 2,
		  Alpha	 =80, 
		},	
		 MarkerS = { --safehouse marker
		  Type     = 1,
		  Position = { x = 1300.91, y = 2985.67, z = 40.28},  --{  x = 1944.96, y = 3150.6, z = 46.77}, 
		  Size     = {x = 2.0, y = 2.0, z = 2.0},
		  Color    = {r = 117, g = 218, b = 255},
		  DrawDistance = 200.0,
		},
	--[[	BlipSL = { --safehouse Vehicle blip 
		  Title = "Mission Vehicle Safehouse",
		  Position = { x = -1469.37, y = -2967.27, z = 13.3}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 421,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},
		BlipSB = { --safehouse boat blip 
		  Title = "Mission Boat Safehouse",
		  Position = {x = 413.98, y = -3411.47, z = 0.23}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		 Icon     = 404,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},]]--

    Marker = {
      Type     = 1,
      Position = {x = 1453.72, y = -2282.69, z = 67.47},  --{  x = 1944.96, y = 3150.6, z = 46.77}, 
      Size     = {x = 150.0, y = 150.0, z = 2.0},
      Color    = {r = 100, g = 100, b = 204},
      DrawDistance = 200.0,
    },
	--***Must Set 'realId' too, which must is always the same as 'id' for props to not float***
	Props = {
	
	--{ id=1,  Name = "csx_coastrok4_", Position = { x = 1398.18, y = 3270.69, z = 38.39, heading = 165.7,Freeze=true, }},
    },
	

	
	Pickups = {
	},
	MissionPickups = {
		
	},	
		
	

    Peds = {
	--[[
		{id = 1,  Weapon = 0x13532244,  modelHash = "u_m_y_zombie_01",  x = 1046.11, y = 3061.58, z = 41.93, heading = 372.55,notzed=true,target=true,},
		{id = 2,  Weapon = 0x13532244,  modelHash = "u_m_y_zombie_01",   x = 1047.11, y = 3061.58, z = 41.93, heading = 372.55,notzed=true,target=true},
		{id = 3,  Weapon = 0x13532244, modelHash = "u_m_y_zombie_01",  x = 1048.11, y = 3061.58, z = 41.93, heading = 372.55 ,notzed=true,target=true},
		{id = 4,  Weapon = 0x13532244, modelHash = "u_m_y_zombie_01",  x = 1049.11, y = 3061.58, z = 41.93, heading = 372.55,notzed=true,target=true},
		{id = 5,  Weapon = 0x13532244, modelHash = "u_m_y_zombie_01",  x = 1050.11, y = 3061.58, z = 41.93, heading = 372.55,notzed=true,target=true},
		{id = 6,  Weapon = 0x13532244,  modelHash = "u_m_y_zombie_01",  x = 1051.11, y = 3061.58, z = 41.93, heading = 372.55 ,notzed=true,target=true},
		{id = 7, Weapon = 0x13532244, modelHash = "u_m_y_zombie_01",   x = 1052.11, y = 3061.58, z = 41.93, heading = 372.55 ,notzed=true,target=true},
		]]--
		--{id = 8, Weapon = 0x13532244, modelHash = "u_m_y_zombie_01",   x = 1053.11, y = 3061.58, z = 41.93, heading = 372.55 ,notzed=true,target=true,conqueror=true},
		--{id = 9, Weapon = 0x2BE6766B, modelHash = "u_m_y_zombie_01",   x = 1054.11, y = 3061.58, z = 41.93, heading = 372.55 ,notzed=true,target=true,conqueror=true},
		--{id = 10, Weapon = 0x2BE6766B, modelHash = "u_m_y_zombie_01",   x = 1055.11, y = 3061.58, z = 41.93, heading = 372.55 ,notzed=true,target=true,conqueror=true},
			

		
		
    },
	
	

    Vehicles = {
      -- ID: id of NPC | name: Name of Blip | BlipID: Icone of Blip | VoiceName: NPC Talk When near it | Ambiance: Ambiance of Shop | Weapon: Hash of Weapon | modelHash: Model | X: Position x | Y: Position Y | Z: Position Z | heading: Where Npc look
   	  --**IMPORTANT: make sure the id of the ped starts from 1, each Peds id in above, increments by 1 and matches that entries index if it were in an array***
	  --vehicles are not consistent, so use ExtraPeds at your own discretion.
	  --Below takes a ped with id=1 from Peds above and will put it in seatid = -2   
	{id = 1, id2 = 1, Weapon= 0x13532244, Vehicle = "phantom2", modelHash = "u_m_y_zombie_01", x = 1747.84, y = 3250.61, z = 41.55, heading = 262.09,notzed=true,target=true,conqueror=true}, --movetocoord={ x = 1453.72, y = -2282.69, z = 67.47},
	{id = 2, id2 = 2, Weapon= 0x13532244, Vehicle = "barrage", modelHash = "u_m_y_zombie_01",  x = 1716.09, y = 3263.64, z = 41.14, heading = 287.06,notzed=true,nomods=true ,target=true,conqueror=true},
	{id = 3, id2 = 3, Weapon= 0x13532244, Vehicle = "dune", modelHash = "u_m_y_zombie_01",x = 1675.94, y = 3235.49, z = 40.71, heading = 280.06, notzed=true,target=true,conqueror=true},
	{id = 4, id2 = 4, Weapon= 0x13532244, Vehicle = "gargoyle", modelHash = "u_m_y_zombie_01",  x = 1633.08, y = 3235.96, z = 40.41, heading = 280.53, notzed=true,target=true,conqueror=true},
	{id = 5, id2 = 5, Weapon= 0x13532244, Vehicle = "dukes2", modelHash = "u_m_y_zombie_01",  x = 1601.39, y = 3219.89, z = 40.41, heading = 281.29, notzed=true,target=true,conqueror=true},
	{id = 6, id2 = 6, Weapon= 0x13532244, Vehicle = "tampa3", modelHash = "u_m_y_zombie_01", x = 1564.8, y = 3221.98, z = 40.44, heading = 279.78, notzed=true,target=true,conqueror=true},
	{id = 7, id2 = 7, Weapon= 0x13532244, Vehicle = "ratbike", modelHash = "u_m_y_zombie_01",  x = 1530.94, y = 3195.49, z = 40.43, heading = 283.06, notzed=true,target=true,conqueror=true},
	{id = 8, id2 = 8, Weapon= 0x13532244, Vehicle = "sanctus", modelHash = "u_m_y_zombie_01",  x = 1507.08, y = 3207.04, z = 40.45, heading = -80.67, notzed=true,target=true,conqueror=true},
{id = 9, id2 = 9, Weapon= 0x13532244, Vehicle = "dune4", modelHash = "u_m_y_zombie_01",  x = 1718.96, y = 3258.17, z = 41.13, heading = 284.77 , notzed=true,target=true,conqueror=true},
		{id = 10, id2 = 10, Weapon= 0x13532244, Vehicle = "dune3", modelHash = "u_m_y_zombie_01", x = 1480.56, y = 3181.15, z = 40.44, heading = 279.9, notzed=true,target=true,conqueror=true},
		{id = 11, id2 = 11, Weapon= 0x13532244, Vehicle = "dune2", modelHash = "u_m_y_zombie_01",x = 1443.97, y = 3190.27, z = 40.45, heading = 281.69, notzed=true,target=true,conqueror=true},
		{id = 12, id2 = 12, Weapon= 0x13532244, Vehicle = "limo2", modelHash = "u_m_y_zombie_01", x = 1257.43, y = 3056.12, z = 40.53, heading = 280.06, notzed=true,target=true,conqueror=true},
		{id = 13, id2 = 13, Weapon= 0x13532244, Vehicle = "technical2", modelHash = "u_m_y_zombie_01",  x = 1421.18, y = 3162.42, z = 40.47, heading = 280.8 , notzed=true,target=true,conqueror=true},
		{id = 14, id2 = 14, Weapon= 0x13532244, Vehicle = "technical2", modelHash = "u_m_y_zombie_01", x = 1376.34, y = 3172.96, z = 40.46, heading = 280.96, notzed=true,target=true,conqueror=true},
	{id = 15, id2 = 15, Weapon= 0x13532244, Vehicle = "boxville5", modelHash = "u_m_y_zombie_01",x = 1345.56, y = 3142.1, z = 40.47, heading = -78.9, notzed=true,target=true,conqueror=true},
	
	{id = 16,  Vehicle = "insurgent3",x = 1286.39, y = 2965.3, z = 40.92, heading = 257.85, },
	{id = 17,  Vehicle = "insurgent3",x = 1285.51, y = 2961.29, z = 40.91, heading = 262.97, },
	
	{id = 18,  Vehicle = "insurgent3",x = 1298.0, y = 2959.82, z = 40.85, heading = 265.57, },
	{id = 19,  Vehicle = "insurgent3", x = 1298.98, y = 2965.39, z = 40.9, heading = 257.72, },
	
	{id = 20,  Vehicle = "insurgent3",x = 1307.46, y = 2964.46, z = 41.02, heading = 264.26,},
	{id = 21,  Vehicle = "insurgent3",x = 1308.04, y = 2960.45, z = 40.99, heading = 262.0, },
	
	{id = 22,  Vehicle = "insurgent3",x = 1278.94, y = 2962.29, z = 40.92, heading = 256.86, },
	{id = 23,  Vehicle = "insurgent3",x = 1279.25, y = 2966.05, z = 40.97, heading = 257.38, },
	
	 -- {id = 2, id2 = 2, Vehicle = "toro2", modelHash = "s_m_y_ammucity_01",  x = -3014.83, y = -43.5, z = 0.13, heading = 151.19, driving=true},
    }
  },
  

  
   Mission11 = {
    
	StartMessage = "The miners dug too greedily.~n~They awoke something in the darkness~n~Find the lost treasure!",
	FinishMessage = "Mission Completed!",
	MissionTitle = "Hollow Earth Theory",
	MissionMessage = "Find and retrieve the legendary lost treasure from the abandoned mine",	
	Type = "Objective",	
	--TargetKillReward = 150, 
	--KillReward = 150,
	SpawnRewardPickups = {"weapon_rayminigun","weapon_raypistol","weapon_firework"}, 
	MissionTriggerRadius = 10.0,

	SMS_Subject="Hollow Earth Theory",
	SMS_Message="Hi. May I ask you? Do you believe in fables? I need some adventurerous types to help me.",
	SMS_Message2="There is a mine, it's abandoned and sealed now. The miners dug too greedily.",
	SMS_Message3="They awoke something in the darkness. Legends have it of a lost treasure. Will you find it for me?",	
		
	SMS_ContactPics={"DIA_CAR3_DIRECTOR",
	},
	SMS_ContactNames={"Henry Jones, Sr",
	},
	SMS_NoFailedMessage=true,
	--SMS_NoPassedMessage=true,
	SMS_FailedSubject="HAHA",
	SMS_FailedMessage="You should have stayed away, this is much bigger than you",
	SMS_PassedSubject="It Exists!",
	SMS_PassedMessage="The legends were true afterall! Enjoy your reimbursement",	

    Blip = {
      Title = "Mission: Find the lost treasure",
      Position = {  x = -595.88, y = 2088.7, z = 131.41},
      Icon     = 58,
      Display  = 4,
      Size     = 1.2,
      Color    = 1,
    },

    Marker = {
      Type     = 1,
      Position = { x = -423.38, y = 2064.82, z = 118.99}, 
      Size     = {x = 6.0, y = 6.0, z = 2.0},
      Color    = {r = 100, g = 100, b = 204},
      DrawDistance = 100.0,
    },
	BlipS = { --safehouse blip 
		  Title = "Mission Safehouse",
		  Position = { x = 1731.94, y = 3308.24, z = 41.22}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 417,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 2,
		  Alpha	 =80, 
		},	
		 MarkerS = { --safehouse marker
		  Type     = 1,
		  Position = { x = 1731.94, y = 3308.24, z = 40.22},  --{  x = 1944.96, y = 3150.6, z = 46.77}, 
		  Size     = {x = 6.0, y = 6.0, z = 2.0},
		  Color    = {r = 117, g = 218, b = 255},
		  DrawDistance = 200.0,
		},
		BlipSL = { --safehouse Vehicle blip 
		  Title = "Mission Vehicle Safehouse",
		  Position = { x = 1480.63, y = 3167.93, z = 40.99}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 421,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},
		BlipSB = { --safehouse boat blip 
		  Title = "Mission Boat Safehouse",
		  Position = {x = 1481.84, y = 3873.37, z = 30.04}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		 Icon     = 404,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},
	--***Must Set 'realId' too, which must is always the same as 'id' for props to not float***
	Props = {
		{ id=1, realId=1, Name = "prop_idol_01_error", Position = {x = -423.91, y = 2064.71, z = 120.03, heading = 278.44}}, --prop_idol_case
	
    },
	

	
	Pickups = {
	},
	MissionPickups = {
		
	},	
		
	

    Peds = {
	
		{id = 1,  Weapon = 0x476BF155,  modelHash = "ig_orleans",  x = -461.9, y = 2057.86, z = 121.63, heading = 203.57,armor=500},
		{id = 2,  Weapon = 0xAF3696A1,  modelHash = "ig_orleans",  x = -463.17, y = 2056.08, z = 121.79, heading = 205.38,armor=500},
		{id = 3,  Weapon = 0x476BF155, modelHash = "ig_orleans",   x = -456.42, y = 2052.18, z = 122.36, heading = 154.51,armor=500 },
		{id = 4,  Weapon = 0xAF3696A1, modelHash = "ig_orleans",   x = -449.67, y = 2057.85, z = 122.07, heading = 120.81,armor=500},
		{id = 5,  Weapon = 0x476BF155, modelHash = "ig_orleans",   x = -436.34, y = 2062.19, z = 121.36, heading = 101.34 ,armor=500},
	{id = 6,  Weapon = 0xAF3696A1,  modelHash = "ig_orleans",x = -428.27, y = 2064.24, z = 120.64, heading = 106.58 ,armor=500},
		{id = 7, Weapon = 0x476BF155, modelHash = "ig_orleans", x = -428.8, y = 2063.0, z = 120.72, heading = 100.6,armor=500},

		
    },
	
	

    Vehicles = {

	 -- {id = 2, id2 = 2, Vehicle = "toro2", modelHash = "s_m_y_ammucity_01",  x = -3014.83, y = -43.5, z = 0.13, heading = 151.19, driving=true},
    }
  },


	
 Mission12 = {
    
	StartMessage = "Capture the objective!",
	FinishMessage = "Mission Completed!",
	MissionTitle = "Takeover",
	MissionMessage = "Capture the goods!",
	MissionTriggerRadius = 1000.0,		
	
	--Obj/Ass values are the messages used depending on which random Type is selected Objective or Assassinate
	--The real messages (values above), will be set to the below, based on which Type
	StartMessageObj = "Capture the goods!",
	FinishMessageObj = "Mission Completed!",
	MissionTitleObj = "Takeover",
	MissionMessageObj = "Capture the goods!",	
	--RandomMissionTypes ={"Objective","Assassinate"},
	RandomMissionTypes ={"Objective"},
	StartMessageAss = "Eliminate the targets!",
	FinishMessageAss = "Mission Completed!",
	MissionTitleAss = "Elimination",
	MissionMessageAss = "Eliminate the targets",	
	RandomMissionDoLandBattle=false, --needed for pier npcs to spawn!
	Type = "Objective",	
	--RandomMissionSpawnGuardAircraft=true,
	--RandomMissionTypes ={"Objective","HostageRescue"},
	IsRandomEvent=true,
	IsRandom = true,
	--IsRandomSpawnAnywhere=true,
	--IsBountyHunt=true,
	RandomMissionMaxVehicleSpawns = 3,
	RandomMissionMinVehicleSpawns = 0,
	RandomMissionAircraftChance = 20,
	
	RandomMissionGuardAircraft=true,
	--RandomMissionBossChance =  0,
	--RandomMissionMaxVehicleSpawns = 4,
	--RandomMissionMinVehicleSpawns = 2,
	--RandomMissionSpawnRadius = 250.0,
	--IsBountyHuntMinSquadSize=1,
	--IsBountyHuntMaxSquadSize=5,
	--IsBountySquadMinRadius=15,
	--IsBountySquadMinRadius=150,
	--RandomMissionBountyBossChance=10,
	
--IsRandomSpawnAnywhereCoordRange = {xrange={-30,30},yrange={1970,2030}},	
	--RandomMissionSpawnRadius = 6000.0, --keep a float for enemy ped wandering to work
	--IsBountyHuntAssassinateAll = true,
	
	--RandomMissionTypes ={"Objective"},	
	--Config.RandomMissionPositions = { 
--{ x = 57.0, y = 3717.01, z = 39.75, MissionTitle="Trailer Park"},--lost caravans
--}
	--IsDefend = true,
	--IsDefendTarget = true,
	--IsDefendTargetChase = true,
	--IsDefendTargetGotoBlip=true,
	--IsRandomSpawnAnywhere = true,
	--what x and y coordinate range should these mission spawn in?
	--IsRandomSpawnAnywhereCoordRange = {xrange={-3500,4200},yrange={-3700,7700}},
	--RandomLocation = true, --for completely random location..


	SMS_Subject="Capture the goods",
	SMS_Message="We need someone to help us reclaim some stolen goods and secure any contrabands. You up for that?",
	--SMS_Message2="There is a mine, it's abandoned and sealed now. The miners dug too greedily.",
	--SMS_Message3="They awoke something in the darkness. Legends have it of a lost treasure. Will you find it for me?",	
		
	--SMS_ContactPics={"DIA_PRINCESS",
	--},
	--SMS_ContactNames={"Agency Contact",
	--},
	SMS_NoFailedMessage=true,
	SMS_NoPassedMessage=true,
	SMS_FailedSubject="HAHA",
	SMS_FailedMessage="You should have stayed away, this is much bigger than you",
	SMS_PassedSubject="It Exists!",
	SMS_PassedMessage="The legends were true afterall! Enjoy your reimbursement",		
	
	Blip = {
      Title = "Objective",
      Position = { x = -10000, y = 0, z =  0},
      Icon     = 58,
      Display  = 4,
      Size     = 1.2,
      Color    = 1,
    },
	
	

    Marker = {
      Type     = 1,
      Position = { x = -10000, y = 0, z = 0}, 
      Size     = {x = 6.0, y = 6.0, z = 2.0},
      Color    = {r = 100, g = 100, b = 204},
      DrawDistance = 100.0,
    },
	BlipS = { --safehouse blip
      Title = "Mission Safehouse",
      Position = { x = 137.06, y = -3093.18, z = 4.9}, --{ x = 1944.96, y = 3150.6, z = 46.77},
      Icon     = 417,
      Display  = 4,
      Size     = 1.2,
      Color    = 2,
	  Alpha	 =80, --Used for AddBlipForRadius with IsDefend Missions
    },	
	 MarkerS = { --safehouse marker
      Type     = 1,
      Position = { x = 137.06, y = -3093.18, z = 4.9},  --{  x = 1944.96, y = 3150.6, z = 46.77}, 
      Size     = {x = 6.0, y = 6.0, z = 2.0},
      Color    = {r = 117, g = 218, b = 255},
      DrawDistance = 200.0,
    },
	BlipSL = { --safehouse Vehicle blip 
		  Title = "Mission Vehicle Safehouse",
		  Position = { x = -1228.1, y = -2267.77, z = 13.94}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 421,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},
	BlipSB = { --safehouse boat blip 
		  Title = "Mission Boat Safehouse",
		  Position = {x = 413.98, y = -3411.47, z = 0.23}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		 Icon     = 404,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},
	
	Props = { 
		--**need a stub entry set for the random prop**
		{ id=1, Name="",Position = { x = 0, y = 0, z = 0, heading = 0 }},
	
    },
	
	Peds = {
		--**need a stub entry set for the random ped hostage for HostageRescue=true**
      {id = 1, Position = { x = 0, y = 0, z = 0, heading = 0 }},
     },
	 Vehicles = { 
		--**need a stub entry set for the random prop**
		
	
    },	 
	Events = {
		--**need a stub entry set for the random default event**
		--add custom events for mission with id=1 onwards
      {id = 1, 
		Position = { x = 50000.0, y = 50000.0, z = 50000.0, heading = 0 },
	  	  Size     = {radius=1000.0},
		  SpawnHeight = 200.0,
		  FacePlayer = true,
		  --NumberPeds=1,
		  isBoss=false,
		  Target=false,
		  SquadSpawnRadius=25.0,
		  
	  
	  },
     },	

	Pickups = {
		
	},
	MissionPickups = {
		
		
	}

  

  },
  
  
   Mission13 = {
    
	StartMessage = "Protect Sarah Conner!~n~~r~Hurry!",
	FinishMessage = "Mission Completed!",
	MissionTitle = "Assault on Precinct 13",
	MissionMessage = "Protect Sarah Conner from being terminated",
	MissionTriggerStartPoint = {x = 439.07, y = -993.21, z = 29.69},
	MissionTriggerRadius = 5.0,	
	Type = "Assassinate",	
	--TargetKillReward = 150, 
	--KillReward = 150,
	IsDefend = true,
	IsDefendTarget = true,
	IsDefendTargetRescue = false,
	IsDefendTargetChase = true,	
	IsDefendTargetAttackDistance = 10.0,
	--IsVehicleDefendTargetGotoBlip=true,
	IsDefendTargetOnlyPlayersDamagePeds=true,
	TeleportToSafeHouseOnMissionStartNoVehicle = true,
	SafeHouseTimeTillNextUse=10000, --10 seconds
	TeleportToSafeHouseOnMissionStartDelay=2000,
	SafeHousePedDoctors = {},
	SafeHousePedLeaders = {},
	SafeHouseProps = {},
	SafeHouseGiveImmediately = true,
	TeleportToSafeHouseMinDistance = 5,
	RemoveWeaponsAndUpgradesAtMissionStart = true,
	IsDefendTargetSetBlockingOfNonTemporaryEvents=true,
	SafeHouseCrackDownModeHealthAmount=1000,
	SpawnSafeHousePickups = {"WEAPON_COMBATPISTOL"},
	--SpawnSafeHouseComponents = {"COMPONENT_AT_PI_SUPP WEAPON_COMBATPISTOL","COMPONENT_COMBATPISTOL_CLIP_02 WEAPON_COMBATPISTOL"},
	SpawnSafeHouseComponents = {"COMPONENT_COMBATPISTOL_CLIP_02 WEAPON_COMBATPISTOL"},
	
	SMS_Subject="Protect the Asset",
	SMS_Message="An asset is being held at Los Santos Police Station in a cell. She is in severe danger though",
	SMS_Message2="Hostiles are assaulting the police station to take her out. Stop them at all cost",
	--SMS_Message3="They awoke something in the darkness. Legends have it of a lost treasure. Will you find it for me?",	
		
	SMS_ContactPics={"HC_N_GUS",
	},
	SMS_ContactNames={"Kyle Reese",
	},
	--SMS_NoFailedMessage=true,
	--SMS_NoPassedMessage=true,
	SMS_FailedSubject="Oh No!",
	SMS_FailedMessage="The fate of humanity lied in her survival. What are we going to do now?",
	SMS_PassedSubject="Thank you!",
	SMS_PassedMessage="The fate of humanity lied in her survival. You just saved mankind!",
	
	
	--[[
	Events = {

	   { 
		  Type="Vehicle",
		  Position = { x = -1060.16, y = -745.39, z = 19.22, heading = 127.5 }, 
		  Size     = {radius=200.0},
		  SpawnHeight = 200.0,
		 Vehicle="halftrack",
		 Weapon=0xBD248B55,
		  --FacePlayer = true,
		  NumberPeds=10,
		 -- DoIsDefendBehavior=true,
		  --IsDefendTargetTriggersEvent = true,
		  --DoBlockingOfNonTemporaryEvents = true,
		  
		},
	
	},	
	
]]--
  
	 Blip2 = {
      Title = "Mission: Protect Sarah Conner",
      Position = { x = 459.26, y = -997.97, z = 24.91},
      Icon     = 58,
      Display  = 4,
      Size     = 1.2,    
      Color    = 1,
    },  
	
	Blip = {
      Title = "Mission: Protect Sarah Conner",
      Position = { x = 459.26, y = -997.97, z = 24.91},
      Icon     = 58,
      Display  = 4,
      Size     = 1.2,
      Color    = 1,
    },


    Marker = {
      Type     = 1,
      Position = { x = -423.38, y = 2064.82, z = 118.99}, 
      Size     = {x = 6.0, y = 6.0, z = 2.0},
      Color    = {r = 100, g = 100, b = 204},
      DrawDistance = 100.0,
    },
		BlipS = { --safehouse blip 
		  Title = "Mission Safehouse",
		  Position = { x = 439.07, y = -993.21, z = 30.69}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 417,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 2,
		  Alpha	 =80, 
		},	
		 MarkerS = { --safehouse marker
		  Type     = 1,
		  Position = { x = 439.07, y = -993.21, z = 29.69},  --{  x = 1944.96, y = 3150.6, z = 46.77}, 
		  Size     = {x = 2.0, y = 2.0, z = 2.0},
		  Color    = {r = 117, g = 218, b = 255},
		  DrawDistance = 200.0,
		},
	
	--***Must Set 'realId' too, which must is always the same as 'id' for props to not float***
	Props = {
		{ id=1, realId=1, Name = "prop_idol_01_error", Position = {x = -423.91, y = 2064.71, z = 120.03, heading = 278.44}}, --prop_idol_case
	
    },
	

	
	Pickups = {
	},
	MissionPickups = {
		
	},
	IsDefendTargetEntity = { --**Uses Blip2 location to spawn... except for heading**
		--Only define 1, Add 'id2' w. 'Vehicle' to add ped to vehicle.
		{id = 1,  Weapon = 0x2BE6766B,  modelHash = "u_f_y_princess", heading = 258.54},
		--{id = 1, id2 = 1, Weapon= 0x2BE6766B, Vehicle = "windsor", modelHash = "ig_bankman",heading = 283.22,}, --movetocoord={  x = 1564.8, y = 3221.98, z = 40.4}
	
	},	
		


    Peds = {
	
		{id = 1,  Weapon =0xAF113F99,  modelHash = "g_m_y_lost_01", x = 392.22, y = -948.11, z = 29.4, heading = 235.57,armor=500,movespeed=2.0,target=true,},
		{id = 2,  Weapon = 0x99B507EA,  modelHash = "g_m_y_lost_02", x = 452.02, y = -939.25, z = 28.52, heading = 174.14,armor=500,movespeed=2.0,target=true,SetBlockingOfNonTemporaryEvents=true ,isBoss=true},
		{id = 3,  Weapon = 0xCD274149, modelHash = "g_m_y_lost_03", x = 491.22, y = -962.64, z = 27.24, heading = 121.6,armor=500,movespeed=2.0,target=true,SetBlockingOfNonTemporaryEvents=true ,isBoss=true},
		{id = 4,  Weapon = 0xAF113F99, modelHash = "g_f_y_lost_01", x = 504.32, y = -1019.43, z = 28.01, heading = 90.92,armor=500,movespeed=2.0,target=true,},
		{id = 5,  Weapon = 0x99B507EA,  modelHash = "g_m_y_lost_01", x = 479.23, y = -1067.98, z = 29.21, heading = 69.27,armor=500,movespeed=2.0,target=true,SetBlockingOfNonTemporaryEvents=true ,isBoss=true},
		{id = 6,  Weapon = 0xCD274149,  modelHash = "g_m_y_lost_02",x = 407.46, y = -1068.29, z = 29.36, heading = 355.52 ,armor=500,movespeed=2.0,target=true,SetBlockingOfNonTemporaryEvents=true ,isBoss=true},
		{id = 7,  Weapon = 0xAF113F99, modelHash = "g_m_y_lost_03", x = 379.15, y = -1033.22, z = 29.31, heading = 313.98,armor=500,movespeed=2.0,target=true, },
		
		{id = 8,  Weapon = 0xDD5DF8D9, modelHash = "g_m_y_lost_01",  x = 474.57, y = -982.95, z = 41.01, heading = 202.47,armor=500,movespeed=2.0,target=true,SetBlockingOfNonTemporaryEvents=true ,isBoss=true },	
		{id = 9,  Weapon = 0xAF113F99, modelHash = "g_m_y_lost_02", x = 462.54, y = -1015.79, z = 41.01, heading = 343.58,armor=500,movespeed=2.0,target=true,},
		{id = 10,  Weapon = 0xAF113F99, modelHash = "g_m_y_lost_03", x = 430.22, y = -997.28, z = 43.69, heading = 324.98,armor=500,movespeed=2.0,target=true, },



		{id = 11,  Weapon = 0x42BF8A85, modelHash = "g_m_y_lost_01",  x = 271.08, y = -964.57, z = 29.29, heading = 305.27 ,armor=500,movespeed=2.0,target=true, },	
		{id = 12,  Weapon = 0xDD5DF8D9, modelHash = "g_f_y_lost_01", x = 279.46, y = -939.84, z = 29.24, heading = 220.45,armor=500,movespeed=2.0,target=true,SetBlockingOfNonTemporaryEvents=true ,isBoss=true },
		
		{id = 13,  Weapon =  0xAF113F99, modelHash = "g_m_y_lost_03",x = 228.51, y = -1121.89, z = 29.24, heading = 266.81,armor=500,movespeed=2.0,target=true,},				
		{id = 14,  Weapon = 0xDD5DF8D9, modelHash = "g_m_y_lost_01",  x = 232.09, y = -1139.9, z = 29.23, heading = 279.81 ,armor=500,movespeed=2.0,target=true,SetBlockingOfNonTemporaryEvents=true ,isBoss=true },	
		
		{id = 15,  Weapon = 0xAF113F99, modelHash = "g_m_y_lost_02", x = 514.69, y = -1171.1, z = 29.34, heading = 359.2,armor=500,movespeed=2.0,target=true, },
		{id = 16,  Weapon = 0xDD5DF8D9, modelHash = "g_m_y_lost_03",x = 494.61, y = -1169.28, z = 29.14, heading = -0.03,armor=500,movespeed=2.0,target=true,SetBlockingOfNonTemporaryEvents=true ,isBoss=true },				
		

		{id = 17,  Weapon = 0x0781FE4A, modelHash = "g_m_y_lost_03",  x = 490.39, y = -865.89, z = 38.15, heading = 103.2,armor=500,movespeed=2.0,target=true, },	
		{id = 18,  Weapon = 0xDD5DF8D9, modelHash = "g_f_y_lost_01", x = 492.5, y = -837.94, z = 38.37, heading = 111.48,armor=500,movespeed=2.0,target=true,SetBlockingOfNonTemporaryEvents=true ,isBoss=true },
		
		{id = 19,  Weapon = 0x42BF8A85, modelHash = "u_m_y_juggernaut_01",  x = 276.08, y = -839.91, z = 29.13, heading = 199.88,armor=500,movespeed=1.0,target=true,isBoss=true },	
		{id = 20,  Weapon = 0xDD5DF8D9, modelHash = "u_m_y_juggernaut_01", x = 451.49, y = -900.95, z = 28.46, heading = 184.75,armor=500,movespeed=1.0,target=true,SetBlockingOfNonTemporaryEvents=true ,isBoss=true },		
		
				
		
		
		
		--{id = 4,  Weapon = 0x2BE6766B, modelHash = " g_f_y_lost_01",   x = 451.2, y = -984.93, z = 43.69, heading = 274.59,armor=500,movespeed=1},
		--{id = 5,  Weapon = 0x476BF155, modelHash = "ig_orleans",   x = -436.34, y = 2062.19, z = 121.36, heading = 101.34 ,armor=500},
	--{id = 6,  Weapon = 0xAF3696A1,  modelHash = "ig_orleans",x = -428.27, y = 2064.24, z = 120.64, heading = 106.58 ,armor=500},
		--{id = 7, Weapon = 0x476BF155, modelHash = "ig_orleans", x = -428.8, y = 2063.0, z = 120.72, heading = 100.6,armor=500},

		
    },
	

    Vehicles = {

	-- {id = 1, id2 = 1, Vehicle = "sanctus", modelHash = "g_m_y_lost_02",  x = 494.52, y = -1019.94, z = 28.08, heading = 80.2,target=true, },
    }
  },


  Mission14 = {
    
	StartMessage = "Escort the road warrior to the destination!~n~~r~Hurry!",
	FinishMessage = "Mission Completed!",
	MissionTitle = "The Road Warrior",
	MissionMessage = "Escort the road warrior to the destination",	
	--Type = "Assassinate",	
	Type = "Assassinate",	
	--TargetKillReward = 150, 
	--KillReward = 150,
	IsDefend = true,
	IsDefendTarget = true,
	--IsDefendTargetChase = true, --**Peds and vehicles chase target. NOTE: for vehicles to chase, target needs to be in a vehicle**
	IsDefendTargetRescue = false, --**Rescuing the target wins the mission, like a hostage rescue
	--Makes NPCs go to Blip location, and Target go from Blip2 to Blip location, when IsDefendTargetChase=true, NPCs chase Target instead
	IsVehicleDefendTargetChase = true, 
	IsDefendTargetSetBlockingOfNonTemporaryEvents=true,
	IsDefendTargetCheckLoop=false,
	IsDefendTargetOnlyPlayersDamagePeds=true,
	--IsDefendTargetDoPlaneMission=true,
	--IsDefendTargetGotoBlipTargetOnly=true,
	TeleportToSafeHouseOnMissionStartNoVehicle = true,
	--IsVehicleDefendTargetGotoBlipTargetOnly=true,
	SafeHouseTimeTillNextUse=60000, --60 seconds
	--SafeHouseTimeTillNextUse=10000, --10 seconds
	SafeHousePedDoctors = {},
	SafeHousePedLeaders = {},
	SafeHouseProps = {"hei_prop_carrier_crate_01a"},
	SafeHouseGiveImmediately = true,
	TeleportToSafeHouseOnMissionStartDelay=5000,
	IsDefendTargetRewardBlip = true,
	GoalReachedReward = 1000,
	--IsDefendTargetPassenger=true,
	--MissionLengthMinutes =1,
	--safehouse:
	MissionTriggerStartPoint = {x = 1326.07, y = 3301.77, z = 35.91},
	MissionTriggerRadius = 10.0,
	--airplanes attack w.o. need for TaskCombatPed:
	IsDefendTargetDoPlaneMission=true,
	
	
	SMS_Subject="The Road Warrior",
	SMS_Message="The Road Warrior cannot escape! Capture him! Resistance is futile!",
	SMS_Message2="I salute my half-life War Boys who will ride with me eternal on the highways of Valhalla.",
	--SMS_Message3="You will ride eternal, shiny and chrome",	
		
	SMS_ContactPics={"DIA_BRAD",
	},
	SMS_ContactNames={"Immortan Joe",
	},
	SMS_NoFailedMessage=true,
	SMS_NoPassedMessage=true,
	SMS_FailedSubject="HAHA",
	SMS_FailedMessage="You should have stayed away, this is much bigger than you",
	SMS_PassedSubject="Valhalla!",
	SMS_PassedMessage="Return my treasures to me, and I myself will carry you through the gates of Valhalla.",

    Blip2 = {
      Title = "Protect the road warrior",
      Position = { x = 1511.08, y = 3485.06, z = 36.37}, --{x = 1453.72, y = -2282.69, z = 67.47},  x = 1872.28, y = 3219.21, z = 45.4
      Icon     = 58,
      Display  = 4,
      Size     = 1.2,
      Color    = 1,
	  Alpha	 =80, --Used for AddBlipForRadius with IsDefend Missions
    },
	Blip = {
      Title = "Destination ($2000)",
      Position = {x = 1416.86, y = 6591.29, z = 12.92}, --{ x = 1453.72, y = -2282.69, z = 67.47}, --{ x = 1944.96, y = 3150.6, z = 46.77},
      Icon     = 38,
      Display  = 4,
      Size     = 1.2,
      Color    = 1,
	  Alpha	 =80, --Used for AddBlipForRadius with IsDefend Missions
    },
    Marker = {
      Type     = 1,
      Position = {x = 1453.72, y = -2282.69, z = 67.47},  --{  x = 1944.96, y = 3150.6, z = 46.77}, 
      Size     = {x = 150.0, y = 150.0, z = 2.0},
      Color    = {r = 100, g = 100, b = 204},
      DrawDistance = 1000.0,
    },
		BlipS = { --safehouse blip 
		  Title = "Mission Safehouse",
		  Position = { x = 1326.07, y = 3301.77, z = 36.91}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 417,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 2,
		  Alpha	 =80, 
		},	
		 MarkerS = { --safehouse marker
		  Type     = 1,
		  Position = { x = 1326.07, y = 3301.77, z = 35.91},  --{  x = 1944.96, y = 3150.6, z = 46.77}, 
		  Size     = {x = 2.0, y = 2.0, z = 2.0},
		  Color    = {r = 117, g = 218, b = 255},
		  DrawDistance = 200.0,
		},
		--[[BlipSL = { --safehouse Vehicle blip 
		  Title = "Mission Vehicle Safehouse",
		  Position = { x = 1480.63, y = 3167.93, z = 40.99}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 421,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},
		BlipSB = { --safehouse boat blip 
		  Title = "Mission Boat Safehouse",
		  Position = {x = 1481.84, y = 3873.37, z = 30.04}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		 Icon     = 404,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},
		]]--
	--***Must Set 'realId' too, which must is always the same as 'id' for props to not float***
	Props = {
	
	
    },
	IsDefendTargetEntity = { --**Uses Blip2 location to spawn... except for heading**
		--Only define 1, Add 'id2' w. 'Vehicle' to add ped to vehicle.
		--{id = 1,  Weapon = 0x2BE6766B,  modelHash = "u_f_y_princess", heading = 372.55},
		{id = 1, id2 = 1, movetocoord={ x = 1416.86, y = 6591.29, z = 12.92}, Weapon= 0x2BE6766B, Vehicle = "insurgent3", modelHash = "ig_mp_agent14",heading =  -106.02,armor=100,movespeed=20.0}, --movetocoord={ x = 1416.86, y = 6591.29, z = 12.92}
	
	},


	Pickups = {
	},
	MissionPickups = {
		
	},	
		
	

    Peds = {
	--[[
		{id = 1,  Weapon = 0x13532244,  modelHash = "u_m_y_zombie_01",  x = 1046.11, y = 3061.58, z = 41.93, heading = 372.55,notzed=true,target=true,},
		{id = 2,  Weapon = 0x13532244,  modelHash = "u_m_y_zombie_01",   x = 1047.11, y = 3061.58, z = 41.93, heading = 372.55,notzed=true,target=true},
		{id = 3,  Weapon = 0x13532244, modelHash = "u_m_y_zombie_01",  x = 1048.11, y = 3061.58, z = 41.93, heading = 372.55 ,notzed=true,target=true},
		{id = 4,  Weapon = 0x13532244, modelHash = "u_m_y_zombie_01",  x = 1049.11, y = 3061.58, z = 41.93, heading = 372.55,notzed=true,target=true},
		{id = 5,  Weapon = 0x13532244, modelHash = "u_m_y_zombie_01",  x = 1050.11, y = 3061.58, z = 41.93, heading = 372.55,notzed=true,target=true},
		{id = 6,  Weapon = 0x13532244,  modelHash = "u_m_y_zombie_01",  x = 1051.11, y = 3061.58, z = 41.93, heading = 372.55 ,notzed=true,target=true},
		{id = 7, Weapon = 0x13532244, modelHash = "u_m_y_zombie_01",   x = 1052.11, y = 3061.58, z = 41.93, heading = 372.55 ,notzed=true,target=true},
				
		]]--
		
    },
	
	

    Vehicles = {
      -- ID: id of NPC | name: Name of Blip | BlipID: Icone of Blip | VoiceName: NPC Talk When near it | Ambiance: Ambiance of Shop | Weapon: Hash of Weapon | modelHash: Model | X: Position x | Y: Position Y | Z: Position Z | heading: Where Npc look
   	  --**IMPORTANT: make sure the id of the ped starts from 1, each Peds id in above, increments by 1 and matches that entries index if it were in an array***
	  --vehicles are not consistent, so use ExtraPeds at your own discretion.
	  --Below takes a ped with id=1 from Peds above and will put it in seatid = -2   
	  
{id = 1, id2 = 1, Weapon= 0x13532244, Vehicle = "cerberus", modelHash = "u_m_y_zombie_01",  x = 1205.98, y = 3116.36, z = 40.41, heading = 279.76,notzed=true,target=true,SetBlockingOfNonTemporaryEvents=true}, --movetocoord={ x = 1453.72, y = -2282.69, z = 67.47},
	{id = 2, id2 = 2, Weapon= 0x13532244, Vehicle = "boxville5", modelHash = "u_m_y_zombie_01",  x = 1280.12, y = 3133.17, z = 40.41, heading = 284.82,notzed=true,target=true,SetBlockingOfNonTemporaryEvents=true},
	{id = 3, id2 = 3, Weapon= 0x13532244, Vehicle = "barrage", modelHash = "u_m_y_zombie_01",x = 1675.94, y = 3235.49, z = 40.71, heading = 280.06, notzed=true,target=true,SetBlockingOfNonTemporaryEvents=true},
	{id = 4, id2 = 4, Weapon= 0x13532244, Vehicle = "gargoyle", modelHash = "u_m_y_zombie_01",  x = 1633.08, y = 3235.96, z = 40.41, heading = 280.53, notzed=true,target=true,SetBlockingOfNonTemporaryEvents=true},
	{id = 5, id2 = 5, Weapon= 0x13532244, Vehicle = "dukes2", modelHash = "u_m_y_zombie_01",  x = 1601.39, y = 3219.89, z = 40.41, heading = 281.29, notzed=true,target=true,SetBlockingOfNonTemporaryEvents=true},
	{id = 6, id2 = 6, Weapon= 0x13532244, Vehicle = "tampa3", modelHash = "u_m_y_zombie_01", x = 1564.8, y = 3221.98, z = 40.44, heading = 279.78, notzed=true,target=true,SetBlockingOfNonTemporaryEvents=true},
	{id = 7, id2 = 7, Weapon= 0x13532244, Vehicle = "ratbike", modelHash = "u_m_y_zombie_01",  x = 1530.94, y = 3195.49, z = 40.43, heading = 283.06, notzed=true,target=true,SetBlockingOfNonTemporaryEvents=true},
	{id = 8, id2 = 8, Weapon= 0x13532244, Vehicle = "sanctus", modelHash = "u_m_y_zombie_01",  x = 1507.08, y = 3207.04, z = 40.45, heading = -80.67, notzed=true,target=true,SetBlockingOfNonTemporaryEvents=true},
{id = 9, id2 = 9, Weapon= 0x13532244, Vehicle = "dune", modelHash = "u_m_y_zombie_01",  x = 1718.96, y = 3258.17, z = 41.13, heading = 284.77 , notzed=true,target=true,SetBlockingOfNonTemporaryEvents=true},
		{id = 10, id2 = 10, Weapon= 0x13532244, Vehicle = "dune3", modelHash = "u_m_y_zombie_01", x = 1480.56, y = 3181.15, z = 40.44, heading = 279.9, notzed=true,target=true,SetBlockingOfNonTemporaryEvents=true},
		{id = 11, id2 = 11, Weapon= 0x13532244, Vehicle = "dune2", modelHash = "u_m_y_zombie_01",x = 1443.97, y = 3190.27, z = 40.45, heading = 281.69, notzed=true,target=true,SetBlockingOfNonTemporaryEvents=true},
		{id = 12, id2 = 12, Weapon= 0x13532244, Vehicle = "issi4", modelHash = "u_m_y_zombie_01", x = 1257.43, y = 3056.12, z = 40.53, heading = 280.06, notzed=true,target=true,SetBlockingOfNonTemporaryEvents=true},
		{id = 13, id2 = 13, Weapon= 0x13532244, Vehicle = "technical2", modelHash = "u_m_y_zombie_01",  x = 1421.18, y = 3162.42, z = 40.47, heading = 280.8 , notzed=true,target=true,SetBlockingOfNonTemporaryEvents=true},
		--{id = 14, id2 = 14, Weapon= 0x13532244, Vehicle = "technical2", modelHash = "u_m_y_zombie_01", x = 1376.34, y = 3172.96, z = 40.46, heading = 280.96, notzed=true,target=true,SetBlockingOfNonTemporaryEvents=true},
	{id = 14, id2 = 14, Weapon= 0x13532244, Vehicle = "bruiser", modelHash = "u_m_y_zombie_01",x = 1345.56, y = 3142.1, z = 40.47, heading = -78.9, notzed=true,target=true,SetBlockingOfNonTemporaryEvents=true},
	
	{id = 15, id2 = 15, Weapon= 0x13532244, Vehicle = "microlight", modelHash = "u_m_y_zombie_01",x = 1170.49, y = 3072.24, z = 40.91, heading = 285.49, notzed=true,target=true,SetBlockingOfNonTemporaryEvents =true},	
	
	{id = 16, id2 = 16, Weapon= 0x13532244, Vehicle = "microlight", modelHash = "u_m_y_zombie_01",x = 1343.02, y = 3119.32, z = 41.31, heading = 285.45 , notzed=true,target=true,SetBlockingOfNonTemporaryEvents =true},	
	
	 -- {id = 2, id2 = 2, Vehicle = "toro2", modelHash = "s_m_y_ammucity_01",  x = -3014.83, y = -43.5, z = 0.13, heading = 151.19, driving=true},
	
	{id = 17,  Vehicle = "insurgent3", x = 1326.89, y = 3308.39, z = 36.94, heading = 282.25, },
	{id = 18,  Vehicle = "insurgent3",x = 1325.57, y = 3313.55, z = 36.77, heading = 278.75, },
	
	{id = 19,  Vehicle = "insurgent3",x = 1316.85, y = 3310.83, z = 36.76, heading = 282.03, },
	{id = 20,  Vehicle = "insurgent3", x = 1316.36, y = 3305.78, z = 36.9, heading = 274.14, },
	
	{id = 21,  Vehicle = "insurgent3",x = 1334.42, y = 3311.68, z = 37.2, heading = 282.2,},
	{id = 22,  Vehicle = "insurgent3",x = 1334.38, y = 3316.9, z = 37.07, heading = 284.3, },
	
	{id = 23,  Vehicle = "insurgent3",x = 1341.76, y = 3319.51, z = 37.3, heading = 288.21, },
	{id = 24,  Vehicle = "insurgent3",x = 1342.55, y = 3315.58, z = 37.38, heading = 282.35, },
	
	
	 
	 
    }
  },
  
  
    Mission15 = {
    
	StartMessage = "Rescue the secret agent from the terrorists!",
	FinishMessage = "Mission Completed!",
	MissionTitle = "Fast and Furious",
	MissionMessage = "Stop the terrorists from eliminating the secret agent who stole their secrets",	
	Type = "Assassinate",	
	--TargetKillReward = 150, 
	--KillReward = 150,
	IsDefend = true,
	IsDefendTarget = true,
	IsDefendTargetRescue = true,
	IsVehicleDefendTargetChase = true,	
	TeleportToSafeHouseOnMissionStartNoVehicle = true,
	--SafeHouseTimeTillNextUse=10000, --10 seconds
	SafeHousePedDoctors = {},
	SafeHousePedLeaders = {},
	SafeHouseProps = {"hei_prop_carrier_crate_01a"},
	SafeHouseGiveImmediately = true,
	TeleportToSafeHouseOnMissionStartDelay=2000,
	SafeHouseTimeTillNextUse=60000, --1 minute	
	RemoveWeaponsAndUpgradesAtMissionStart = true,
	MissionTriggerStartPoint = {x = 88.67, y = 6336.96, z = 31.23},
	MissionTriggerRadius = 5.0,
	
	SMS_Subject="Fast and Furious",
	SMS_Message="Hey. I could use a hand here, to evade some terrorists hot on my tail",
	SMS_Message2="They are none too happy they were inflitrated and I got their secret files. I need evac ASAP!",
	--SMS_Message3="The Governor's plane was brought down. We have captured him and obtained his secret files.",	
		
	SMS_ContactPics={"CHAR_STEVE",
	},
	SMS_ContactNames={"Agency Contact",
	},
	SMS_NoFailedMessage=true,
	--SMS_NoPassedMessage=true,
	SMS_FailedSubject="HAHA",
	SMS_FailedMessage="You should have stayed away, this is much bigger than you",
	SMS_PassedSubject="Thank you",
	SMS_PassedMessage="The data is safe and sound",	
	

    Blip = {
      Title = "Mission: Rescue the Secret Agent",
      Position = {   x = 44.29, y = 6423.54, z = 31.3},
      Icon     = 58,
      Display  = 4,
      Size     = 1.2,
      Color    = 1,
    },
	 Blip2 = {
      Title = "Mission: Rescue the Secret Agent",
      Position = { x = 44.29, y = 6423.54, z = 30.3},
      Icon     = 58,
      Display  = 4,
      Size     = 1.2,
      Color    = 1,
    },

    Marker = {
      Type     = 1,
      Position = { x = -423.38, y = 2064.82, z = 118.99}, 
      Size     = {x = 6.0, y = 6.0, z = 2.0},
      Color    = {r = 100, g = 100, b = 204},
      DrawDistance = 100.0,
    },
	BlipS = { --safehouse blip 
		  Title = "Mission Safehouse",
		  Position = {x = 88.67, y = 6336.96, z = 31.23}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 417,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 2,
		  Alpha	 =80, 
		},	
		 MarkerS = { --safehouse marker
		  Type     = 1,
		  Position = {x = 88.67, y = 6336.96, z = 30.23},  --{  x = 1944.96, y = 3150.6, z = 46.77}, 
		  Size     = {x = 2.0, y = 2.0, z = 2.0},
		  Color    = {r = 117, g = 218, b = 255},
		  DrawDistance = 200.0,
		},
		BlipSL = { --safehouse Vehicle blip 
		  Title = "Mission Vehicle Safehouse",
		  Position = { x = -2451.21, y = 3134.29, z = 32.82, heading = 156.25}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 421,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},
		BlipSB = { --safehouse boat blip 
		  Title = "Mission Boat Safehouse",
		  Position = {x = -3238.09, y = 3380.0, z = 0.18}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		 Icon     = 404,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},
	--***Must Set 'realId' too, which must is always the same as 'id' for props to not float***
	Props = {
		--{ id=1, realId=1, Name = "prop_idol_01_error", Position = {x = -423.91, y = 2064.71, z = 120.03, heading = 278.44}}, --prop_idol_case
	
    },
	

	
	Pickups = {
	},
	MissionPickups = {
		
	},
	IsDefendTargetEntity = { --**Uses Blip2 location to spawn... except for heading**
		--Only define 1, Add 'id2' w. 'Vehicle' to add ped to vehicle.
		--{id = 1,  Weapon = 0x2BE6766B,  modelHash = "ig_mp_agent14", heading = 258.54},
		{id = 1, id2 = 1, Weapon= 0x2BE6766B, Vehicle = "cognoscenti2", modelHash = "ig_mp_agent14",heading = 132.01,armor=100,driving=true,}, --movetocoord={  x = 1564.8, y = 3221.98, z = 40.4}
	
	},	
		


    Peds = {
	
	{id = 1,  Weapon = 0x2BE6766B,  modelHash = "g_m_y_lost_01", x = 392.22, y = -948.11, z = 29.4, heading = 235.57,armor=500,movespeed=1},
		--{id = 1,  Weapon = 0x13532244, Vehicle = "tampa3", modelHash = "g_m_y_lost_03", x = 67.76, y = 6444.12, z = 31.3, heading = 133.24,},
		--{id = 2,  Weapon = 0x13532244, Vehicle = "tampa3", modelHash = "g_m_y_lost_02",x = 78.04, y = 6419.11, z = 31.29, heading = 44.07, },
		--{id = 3, Weapon = 0x13532244, Vehicle = "tampa3", modelHash = "g_m_y_lost_01",x = 50.66, y = 6458.93, z = 31.41, heading = 183.7, },
		
	
	--[[
		{id = 1,  Weapon = 0x2BE6766B,  modelHash = "g_m_y_lost_01", x = 392.22, y = -948.11, z = 29.4, heading = 235.57,armor=500,movespeed=1},
		{id = 2,  Weapon = 0x2BE6766B,  modelHash = "g_m_y_lost_02", x = 452.02, y = -939.25, z = 28.52, heading = 174.14,armor=500,movespeed=1},
		{id = 3,  Weapon = 0x2BE6766B, modelHash = "g_m_y_lost_03", x = 491.22, y = -962.64, z = 27.24, heading = 121.6,armor=500,movespeed=1 },
		{id = 4,  Weapon = 0x2BE6766B, modelHash = "g_f_y_lost_01", x = 504.32, y = -1019.43, z = 28.01, heading = 90.92,armor=500,movespeed=1},
		{id = 5,  Weapon = 0x2BE6766B,  modelHash = "g_m_y_lost_01", x = 479.23, y = -1067.98, z = 29.21, heading = 69.27,armor=500,movespeed=1},
		{id = 6,  Weapon = 0x2BE6766B,  modelHash = "g_m_y_lost_02",x = 407.46, y = -1068.29, z = 29.36, heading = 355.52 ,armor=500,movespeed=1},
		{id = 7,  Weapon = 0x2BE6766B, modelHash = "g_m_y_lost_03", x = 379.15, y = -1033.22, z = 29.31, heading = 313.98,armor=500,movespeed=1 },
		]]--
		--{id = 4,  Weapon = 0x2BE6766B, modelHash = " g_f_y_lost_01",   x = 451.2, y = -984.93, z = 43.69, heading = 274.59,armor=500,movespeed=1},
		--{id = 5,  Weapon = 0x476BF155, modelHash = "ig_orleans",   x = -436.34, y = 2062.19, z = 121.36, heading = 101.34 ,armor=500},
	--{id = 6,  Weapon = 0xAF3696A1,  modelHash = "ig_orleans",x = -428.27, y = 2064.24, z = 120.64, heading = 106.58 ,armor=500},
		--{id = 7, Weapon = 0x476BF155, modelHash = "ig_orleans", x = -428.8, y = 2063.0, z = 120.72, heading = 100.6,armor=500},

		
    },
	
	

    Vehicles = {

	 {id = 1, id2 = 1, Weapon = 0x13532244, Vehicle = "cognoscenti2", nomods=true, modelHash = "g_m_y_lost_03", x = 67.76, y = 6444.12, z = 31.3, heading = 133.24,  conqueror=true,driving=true,target=true},
	 {id = 2, id2 = 2, Weapon = 0x13532244, Vehicle = "cognoscenti2", nomods=true,  modelHash = "g_m_y_lost_02",x = 134.65, y = 6543.84, z = 31.62, heading = 225.14 , conqueror=true,driving=true,target=true},
	 {id = 3, id2 = 3, Weapon = 0x13532244, Vehicle = "cognoscenti2",  nomods=true,  modelHash = "g_m_y_lost_01",x = 50.66, y = 6458.93, z = 31.41, heading =  147.24, conqueror=true,driving=true,target=true},
	 {id = 4, id2 = 4, Vehicle = "buzzard", modelHash = "s_m_y_ammucity_01", x = 50.66, y = 6458.93, z = 71.41, heading =  147.24,isAircraft=true,pilot=true,SetBlockingOfNonTemporaryEvents=true,target=true},
	 {id = 5, id2 = 5, Vehicle = "seabreeze", modelHash = "s_m_y_ammucity_01", x = 427.14, y = 6663.39, z = 108.93,  heading = 114.8,isAircraft=true,pilot=true,SetBlockingOfNonTemporaryEvents=true,target=true},	 

	{id = 4,  Vehicle = "cognoscenti2",  x = 78.54, y = 6326.45, z = 31.23, heading = 24.23 },
	{id = 5,  Vehicle = "cognoscenti2",   x = 82.93, y = 6328.09, z = 31.23, heading = 23.45 },	
	{id = 6,  Vehicle = "cognoscenti2",    x = 80.33, y = 6335.67, z = 31.23, heading = 24.22 },
	{id = 7,  Vehicle = "cognoscenti2",   x = 76.28, y = 6332.76, z = 31.23, heading = 27.98 },		 
	 
    }
  },
  
  
   Mission16 = {
    
	StartMessage = "Stop the mercenaries from taking over Los Santos!~n~ Defend the perimeter!",
	FinishMessage = "Mission Completed!",
	MissionTitle = "Battle for Los Santos",
	MissionMessage = "Stop the mercenaries from taking over Los Santos!~n~Defend the perimeter!",

	TeleportToSafeHouseOnMissionStartNoVehicle = true,
	--SafeHouseTimeTillNextUse=10000, --10 seconds
	SafeHousePedDoctors = {},
	SafeHousePedLeaders = {},
	SafeHouseProps = {"hei_prop_carrier_crate_01a"},
	SafeHouseGiveImmediately = true,
	--TeleportToSafeHouseOnMissionStartDelay=2000,
	SafeHouseTimeTillNextUse=60000, --1 minute
	--VehicleGotoMissionTarget="trailersmall",
	--VehicleGotoMissionTargetCoords={x = -29.44, y = -950.3, z = 29.41},
	VehicleGotoMissionTargetVehicle=9,
	MissionTriggerStartPoint = {x = -29.44, y = -950.3, z = 29.41},
	MissionTriggerRadius = 20.0,
	
	--Type = "Assassinate",	
	Type = "Assassinate",	
	--TargetKillReward = 150, 
	--KillReward = 150,
	IsDefend = true,
	
	SMS_Subject="Battle for Los Santos",
	SMS_Message="Los Santos is under attack from renegade mercenaries. They took out our infrastructure with an EMP",
	SMS_Message2="We need help to defend Los Santos. Can anyone willing to help, come downtown to help stop them?",
	SMS_Message3="Go to the defend zone and there will be supplies there. Dont let any enermy in",	
		
	SMS_ContactPics={"CHAR_BOATSITE2",
	},
	SMS_ContactNames={"Military Contact",
	},
	SMS_NoFailedMessage=true,
	--SMS_NoPassedMessage=true,
	SMS_FailedSubject="HAHA",
	SMS_FailedMessage="You should have stayed away, this is much bigger than you",
	SMS_PassedSubject="Thank you",
	SMS_PassedMessage="Los Santos is safe and sound from the attack",		
	
	
    Blip2 = {
      Title = "Mission End",
      Position = { x = -29.44, y = -950.3, z = 29.41}, --{ x = 1944.96, y = 3150.6, z = 46.77},
      Icon     = 58,
      Display  = 4,
      Size     = 1.2,
      Color    = 1,
	  Alpha	 =80, --Used for AddBlipForRadius with IsDefend Missions
    },
	Blip = {
      Title = "Mission: Defend Los Santos from the Mercenaries",
      Position = { x = -29.44, y = -950.3, z = 29.41}, --{ x = 1944.96, y = 3150.6, z = 46.77},
      Icon     = 58,
      Display  = 4,
      Size     = 1.2,
      Color    = 1,
	  Alpha	 =80, --Used for AddBlipForRadius with IsDefend Missions
    },


    Marker = {
      Type     = 1,
      Position = { x = -29.44, y = -950.3, z = 29.41},  --{  x = 1944.96, y = 3150.6, z = 46.77}, 
      Size     = {x = 150.0, y = 150.0, z = 2.0},
      Color    = {r = 100, g = 100, b = 204},
      DrawDistance = 200.0,
    },
		BlipS = { --safehouse blip 
		  Title = "Mission Safehouse",
		  Position = { x = -68.33, y = -954.18, z = 29.37}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 417,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 2,
		  Alpha	 =80, 
		},	
		 MarkerS = { --safehouse marker
		  Type     = 1,
		  Position = {  x = -68.33, y = -954.18, z = 28.37},  --{  x = 1944.96, y = 3150.6, z = 46.77}, 
		  Size     = {x = 2.0, y = 2.0, z = 2.0},
		  Color    = {r = 117, g = 218, b = 255},
		  DrawDistance = 200.0,
		},
		BlipSL = { --safehouse Vehicle blip 
		  Title = "Mission Vehicle Safehouse",
		  Position = { x = -1469.37, y = -2967.27, z = 13.3}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 421,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},
		BlipSB = { --safehouse boat blip 
		  Title = "Mission Boat Safehouse",
		  Position = {x = 413.98, y = -3411.47, z = 0.23}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		 Icon     = 404,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},
		
		Events = {

	  { 
		  Type="Vehicle",
		  Position = { x = -1060.16, y = -745.39, z = 19.22, heading = 127.5 }, 
		  Size     = {radius=1500.0},
		  SpawnHeight = 200.0,
		 Vehicle="halftrack",
		 Weapon=0xBD248B55,
		  --FacePlayer = true,
		  NumberPeds=10,
		  Target=true,
		 DoIsDefendBehavior=true,
		  IsDefendTargetTriggersEvent = true,
		  --DoBlockingOfNonTemporaryEvents = true,
		  
		},
		
	},		
		
	--***Must Set 'realId' too, which must is always the same as 'id' for props to not float***
	Props = {
	
	
    },
	

	
	Pickups = {
	},
	MissionPickups = {
		
	},	
		
	

    Peds = {
	

    },
	
	
	
	

    Vehicles = {
      -- ID: id of NPC | name: Name of Blip | BlipID: Icone of Blip | VoiceName: NPC Talk When near it | Ambiance: Ambiance of Shop | Weapon: Hash of Weapon | modelHash: Model | X: Position x | Y: Position Y | Z: Position Z | heading: Where Npc look
   	  --**IMPORTANT: make sure the id of the ped starts from 1, each Peds id in above, increments by 1 and matches that entries index if it were in an array***
	  --vehicles are not consistent, so use ExtraPeds at your own discretion.
	  --Below takes a ped with id=1 from Peds above and will put it in seatid = -2   
	{id = 1, id2 = 1, Weapon= 0x2BE6766B, Vehicle = "halftrack", modelHash = "s_m_y_ammucity_01",x = -909.58, y = -3472.0, z = 13.94, heading = 320.58,target=true,SetBlockingOfNonTemporaryEvents=true}, --movetocoord={ x = 1453.72, y = -2282.69, z = 67.47},
	{id = 2, id2 = 2, Weapon= 0x2BE6766B, Vehicle = "khanjali", modelHash = "s_m_y_ammucity_01",  x = 1255.7, y = -3334.67, z = 5.8, heading = 357.43,target=true,SetBlockingOfNonTemporaryEvents=true},
	{id = 3, id2 = 3, Weapon= 0x2BE6766B, Vehicle = "apc", modelHash = "s_m_y_ammucity_01",  x = 285.41, y = -3304.03, z = 5.62, heading = 352.1, target=true,SetBlockingOfNonTemporaryEvents=true},
	
	{id = 4, id2 = 4, Weapon= 0x2BE6766B, Vehicle = "insurgent3", modelHash = "s_m_y_ammucity_01", x = -2616.08, y = 2971.87, z = 16.68, heading = 172.79, target=true,SetBlockingOfNonTemporaryEvents=true},
	{id = 5, id2 = 5, Weapon= 0x2BE6766B, Vehicle = "khanjali", modelHash = "s_m_y_ammucity_01",x = 216.18, y = 3134.58, z = 42.35, heading = 184.52, target=true,SetBlockingOfNonTemporaryEvents=true},
	{id = 6, id2 = 6, Weapon= 0x2BE6766B, Vehicle = "barrage", modelHash = "s_m_y_ammucity_01",x = 2906.09, y = 4446.63, z = 48.17, heading = 107.07,target=true,SetBlockingOfNonTemporaryEvents=true},
	
	{id = 7, id2 = 7, Weapon= 0x2BE6766B, Vehicle = "apc", modelHash = "s_m_y_ammucity_01", x = -385.54, y = 5994.55, z = 31.47, heading = 134.79, target=true,conqueror=true},
	
	{id = 8, id2 = 8, Weapon= 0x2BE6766B, Vehicle = "apc", modelHash = "s_m_y_ammucity_01",  x = 1323.05, y = 6485.61, z = 19.99, heading = 256.07, target=true,conqueror=true},
	
	{id = 9, id2 = 9, Weapon= 0x2BE6766B, Vehicle = "trailersmall", modelHash = "s_m_y_ammucity_01", x = -51.33, y = -909.57, z = 29.5, heading = 295.67,Freeze=true,},
	
	
	{id = 10, id2 = 10, Weapon= 0x2BE6766B, Vehicle = "bombushka", modelHash = "s_m_y_ammucity_01",   x = -2931.88, y = 176.18, z = 163.44, heading = 244.69,driving=true,isAircraft=true,target=true,VehicleGotoMissionTarget=true,SetBlockingOfNonTemporaryEvents=true,},
	
	{id = 10, id2 = 10, Weapon= 0x2BE6766B, Vehicle = "akula", modelHash = "s_m_y_ammucity_01",  x = 2344.27, y = -946.09, z = 143.16, heading = 139.0,driving=true,isAircraft=true,target=true,VehicleGotoMissionTarget=true,SetBlockingOfNonTemporaryEvents=true,},
	
	{id = 12, id2 = 12, Weapon= 0x2BE6766B, Vehicle = "lazer", modelHash = "s_m_y_ammucity_01", x = -1052.89, y = -3305.87, z = 113.94, heading = 340.33, driving=true,isAircraft=true,target=true,},
	
	{id = 13, id2 = 13, Weapon= 0x2BE6766B, Vehicle = "valkyrie", modelHash = "s_m_y_ammucity_01",   x = 216.18, y = 3134.58, z = 142.35, heading = 184.52, driving=true,isAircraft=true,target=true,VehicleGotoMissionTarget=true,VehicleGotoMissionTargetVehicle=5,SetBlockingOfNonTemporaryEvents=true,},
	{id = 14, id2 = 14, Weapon= 0x2BE6766B, Vehicle = "tula", modelHash = "s_m_y_ammucity_01",   x = 1255.7, y = -3334.67, z = 105.8, heading = 357.43, driving=true,isAircraft=true,target=true,VehicleGotoMissionTarget=true,VehicleGotoMissionTargetVehicle=2,SetBlockingOfNonTemporaryEvents=true,},
	
	
	
	
	{id = 15,  Vehicle = "insurgent3",x = -54.42, y = -960.3, z = 29.37, heading = 293.93, },
	{id = 16,  Vehicle = "khanjali",x = -51.88, y = -917.84, z = 29.35, heading = 104.73 },	
	{id = 17,  Vehicle = "barrage", x = -6.46, y = -939.28, z = 29.33, heading = 115.69 },
	{id = 18,  Vehicle = "rhino",  x = -19.15, y = -967.67, z = 29.35, heading = 28.92 },	

	 -- {id = 2, id2 = 2, Vehicle = "toro2", modelHash = "s_m_y_ammucity_01",  x = -3014.83, y = -43.5, z = 0.13, heading = 151.19, driving=true},
    }
  },
  
  Mission17 = {
    
	StartMessage = "Rescue the hostages",
	FinishMessage = "Mission Completed!",
	MissionTitle = "Rescue",
	MissionMessage = "Rescue the hostages!",	
	
	--Obj/Ass values are the messages used depending on which random Type is selected Objective or Assassinate
	--The real messages (values above), will be set to the below, based on which Type
	StartMessageObj = "Capture the objective!",
	FinishMessageObj = "Mission Completed!",
	MissionTitleObj = "Rescue",
	MissionMessageObj = "Rescue the hostages!",	
	
	StartMessageAss = "Eliminate the targets!",
	FinishMessageAss = "Mission Completed!",
	MissionTitleAss = "Elimination",
	MissionMessageAss = "Eliminate the targets",
	Type = "Objective",	 --placeholder
	RandomMissionTypes ={"HostageRescue"},	
	RandomMissionDoLandBattle = true,
	IsRandom = true,
	IsRandomEvent=true,
	RandomMissionSpawnRadius = 150.0, --keep a float for enemy ped wandering to work
	RandomMissionMaxPedSpawns = 75,
	RandomMissionMinPedSpawns = 50,
	RandomMissionMaxVehicleSpawns = 6,
	RandomMissionMinVehicleSpawns = 3,
	RandomMissionChanceToSpawnVehiclePerTry = 100,
	RandomMissionAircraftChance = 20,
	MissionLengthMinutes = 60,
	SafeHouseVehiclesMaxClaim = 3,
	SafeHouseVehicleCount = 9,
	SafeHouseAircraftCount = 3,
	SafeHouseBoatCount = 3,
	
	--RandomMissionBoat={"apc"},
	--IsDefend = true,
	--IsDefendTarget = true,
	--IsDefendTargetChase = true,
	--IsDefendTargetGotoBlip=true,
	IsRandomSpawnAnywhere = true,
	--what x and y coordinate range should these mission spawn in?
	IsRandomSpawnAnywhereCoordRange = {xrange={-3500,4200},yrange={-3700,7700}},
	--RandomLocation = true, --for completely random location.. 
	MissionTriggerRadius = 1000.0,
	--RandomMissionSpawnGuardAircraft=true,
	RandomMissionGuardAircraft=true,
	
	SMS_Subject="Hostage Rescue",
	SMS_Message="Our Intel shows where hostages are being held by a heavily armed group. Can someone help free them?",
	--SMS_Message2="We need help to defend Los Santos. Can anyone willing to help, go to downtown to stop them?",
	--SMS_Message3="The Governor's plane was brought down. We have captured him and obtained his secret files.",	
		
	--SMS_ContactPics={"DIA_PRINCESS",
	--},
	--SMS_ContactNames={"Agency Contact",
	--},
	SMS_NoFailedMessage=true,
	SMS_NoPassedMessage=true,
	SMS_FailedSubject="HAHA",
	SMS_FailedMessage="You should have stayed away, this is much bigger than you",
	SMS_PassedSubject="Thank you",
	SMS_PassedMessage="Los Santos is safe and sound from the attack",			
	
	
	Blip = {
      Title = "Mission: Rescue the Hostages",
      Position = { x = -10000, y = 0, z =  0},
      Icon     = 58,
      Display  = 4,
      Size     = 1.2,
      Color    = 1,
    },
	

    Marker = {
      Type     = 1,
      Position = { x = -10000, y = 0, z = 0}, 
      Size     = {x = 6.0, y = 6.0, z = 2.0},
      Color    = {r = 100, g = 100, b = 204},
      DrawDistance = 100.0,
    },
	BlipS = { --safehouse blip
      Title = "Mission Safehouse",
      Position = { x = 137.06, y = -3093.18, z = 4.9}, --{ x = 1944.96, y = 3150.6, z = 46.77},
      Icon     = 417,
      Display  = 4,
      Size     = 1.2,
      Color    = 2,
	  Alpha	 =80, --Used for AddBlipForRadius with IsDefend Missions
    },	
	 MarkerS = { --safehouse marker
      Type     = 1,
      Position = { x = 137.06, y = -3093.18, z = 4.9},  --{  x = 1944.96, y = 3150.6, z = 46.77}, 
      Size     = {x = 6.0, y = 6.0, z = 2.0},
      Color    = {r = 117, g = 218, b = 255},
      DrawDistance = 200.0,
    },
	BlipSL = { --safehouse Vehicle blip 
		  Title = "Mission Vehicle Safehouse",
		  Position = { x = -1228.1, y = -2267.77, z = 13.94}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 421,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},
	BlipSB = { --safehouse boat blip 
		  Title = "Mission Boat Safehouse",
		  Position = {x = 413.98, y = -3411.47, z = 0.23}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		 Icon     = 404,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},
	
	Props = { 
		--**need a stub entry set for the random prop**
		{ id=1, Name="",Position = { x = 0, y = 0, z = 0, heading = 0 }},
	
    },
	
	 Vehicles = { 
		--**need a stub entry set for the random prop**
		
	
    },	
	Events = {
		--**need a stub entry set for the random default event**
		--add custom events for mission with id=1 onwards
      {id = 1, 
		Position = { x = 50000.0, y = 50000.0, z = 50000.0, heading = 0 },
	  	  Size     = {radius=1000.0},
		  SpawnHeight = 200.0,
		  FacePlayer = true,
		  --NumberPeds=1,
		  isBoss=false,
		  Target=false,
		  SquadSpawnRadius=25.0,
		  
	  
	  },
     },	
	
	Peds = {
		--**need a stub entry set for the random ped hostage for HostageRescue=true**
      {id = 1, Position = { x = 0, y = 0, z = 0, heading = 0 }},
     },
	

	Pickups = {
		
	},
	MissionPickups = {
		
		
	}

  

  },
  --[[
  Mission18 = {
    
 	StartMessage = "New Mission",
	FinishMessage = "Mission Completed!",
	MissionTitle = "Extraction",
	MissionMessage = "New Mission",	
	
	--Obj/Ass values are the messages used depending on which random Type is selected Objective or Assassinate
	--The real messages (values above), will be set to the below, based on which Type
	StartMessageObj = "Capture the objective!",
	FinishMessageObj = "Mission Completed!",
	MissionTitleObj = "Takeover",
	MissionMessageObj = "Capture the objective!",	
	
	StartMessageAss = "Rescue the target!",
	FinishMessageAss = "Mission Completed!",
	MissionTitleAss = "Extraction",
	MissionMessageAss = "Rescue the target!",		
	Type = "Assassinate",
	RandomMissionTypes ={"Assassinate"},	
	IsRandom = true,
	IsDefend = true,
	IsDefendTarget = true,
	IsVehicleDefendTargetChase = true,
	IsVehicleDefendTargetGotoBlipTargetOnly=true,
	IsDefendTargetEnemySetBlockingOfNonTemporaryEvents=true,
	IsDefendTargetSetBlockingOfNonTemporaryEvents=true,
	--RandomMissionTypes = {"Assassinate"},
	--IsRandomSpawnAnywhere = true,
	--what x and y coordinate range should these mission spawn in?
	--IsRandomSpawnAnywhereCoordRange = {xrange={-3500,4200},yrange={-3700,7700}},
	--RandomLocation = true, --for completely random location.. 
	
	Events = {

	  { 
		  Type="Vehicle",
		  Position = { x = -1060.16, y = -745.39, z = 19.22, heading = 127.5 }, 
		  Size     = {radius=1500.0},
		  SpawnHeight = 200.0,
		 Vehicle="halftrack",
		 Weapon=0xBD248B55,
		  --FacePlayer = true,
		  NumberPeds=10,
		  Target=true,
		 -- DoIsDefendBehavior=true,
		  IsDefendTargetTriggersEvent = true,
		  --DoBlockingOfNonTemporaryEvents = true,
		  
		},	

	},
	Vehicles = { 
		--**need a stub entry set for the random prop**
		
	
    },	
	
	Blip = {
      Title = "Objective",
      Position = { x = -10000, y = 0, z =  0},
      Icon     = 58,
      Display  = 4,
      Size     = 1.2,
      Color    = 1,
    },
	
	Blip2 = {
      Title = "Objective",
      Position = { x = -10000, y = 0, z =  0},
      Icon     = 58,
      Display  = 4,
      Size     = 1.2,
      Color    = 1,
    },

    Marker = {
      Type     = 1,
      Position = { x = -10000, y = 0, z = 0}, 
      Size     = {x = 6.0, y = 6.0, z = 2.0},
      Color    = {r = 100, g = 100, b = 204},
      DrawDistance = 100.0,
    },
	BlipS = { --safehouse blip
      Title = "Mission Safehouse",
      Position = { x = 137.06, y = -3093.18, z = 4.9}, --{ x = 1944.96, y = 3150.6, z = 46.77},
      Icon     = 417,
      Display  = 4,
      Size     = 1.2,
      Color    = 2,
	  Alpha	 =80, --Used for AddBlipForRadius with IsDefend Missions
    },	
	 MarkerS = { --safehouse marker
      Type     = 1,
      Position = { x = 137.06, y = -3093.18, z = 4.9},  --{  x = 1944.96, y = 3150.6, z = 46.77}, 
      Size     = {x = 6.0, y = 6.0, z = 2.0},
      Color    = {r = 117, g = 218, b = 255},
      DrawDistance = 200.0,
    },
	BlipSL = { --safehouse Vehicle blip 
		  Title = "Mission Vehicle Safehouse",
		  Position = { x = -1228.1, y = -2267.77, z = 13.94}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 421,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},
	BlipSB = { --safehouse boat blip 
		  Title = "Mission Boat Safehouse",
		  Position = {x = 413.98, y = -3411.47, z = 0.23}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		 Icon     = 404,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},
	
	Props = { 
		--**need a stub entry set for the random prop**
		{ id=1, Name="",Position = { x = 0, y = 0, z = 0, heading = 0 }},
	
    },
	
	Peds = {
		--**need a stub entry set for the random ped hostage for HostageRescue=true**
      {id = 1, Position = { x = 0, y = 0, z = 0, heading = 0 }},
     },
	

	Pickups = {
		
	},
	MissionPickups = {
		
		
	},
	
	RandomMissionPositions = { 
	
	{ x = 58.43, y = -1133.28, z = 29.34, MissionTitle="Extraction",
	Blip2 = {
      Title = "Mission Start",
      Position = { x = -1389.86, y = -388.47, z = 36.7}, -- x = 2365.07, y = 2958.56, z = 49.06 --{ x = 1944.96, y = 3150.6, z = 46.77}, --x = 1345.43, y = 3152.51, z = 40.41
      Icon     = 309,
      Display  = 4,
      Size     = 1.2,
      Color    = 1,
	  Alpha	 =80, --Used for AddBlipForRadius with IsDefend Missions
    },

	Blip = { 
      Title = "Defend The Target",
      Position = {x = 103.87, y = -1001.07, z = 29.4}, --{ x = 1944.96, y = 3150.6, z = 46.77},
      Icon     = 58,
      Display  = 4,
      Size     = 1.2,
      Color    = 1,
	  Alpha	 =80, --Used for AddBlipForRadius with IsDefend Missions
    },	

	DefendTargetInVehicle = true,
	
	
	},
	
	
{ x = 1074.41, y = 3072.94, z = 40.82, MissionTitle="Extraction", 
 
	Blip2 = { 
      Title = "Mission Start",
      Position = { x = 2365.07, y = 2958.56, z = 49.06}, -- x = 2365.07, y = 2958.56, z = 49.06 --{ x = 1944.96, y = 3150.6, z = 46.77}, --x = 1345.43, y = 3152.51, z = 40.41
      Icon     = 309,
      Display  = 4,
      Size     = 1.2,
      Color    = 1,
	  Alpha	 =80, --Used for AddBlipForRadius with IsDefend Missions
    },

	Blip = { 
      Title = "Defend The Target",
      Position = {x = 1155.28, y = 3031.23, z = 40.3}, --{ x = 1944.96, y = 3150.6, z = 46.77},
      Icon     = 58,
      Display  = 4,
      Size     = 1.2,
      Color    = 1,
	  Alpha	 =80, --Used for AddBlipForRadius with IsDefend Missions
    },	

	DefendTargetInVehicle = true,
	--DefendTargetVehicleIsAircraft = true,
	

},  

}
	
	
 },
 ]]--

 Mission18 = {
    
 	StartMessage = "Take out enemy targets!",
	FinishMessage = "Mission Completed!",
	MissionTitle = "Boss Rush",
	MissionMessage = "Take out the enemy targets!",	
	MissionTriggerRadius = 500.0,
	
	--Obj/Ass values are the messages used depending on which random Type is selected Objective or Assassinate
	--The real messages (values above), will be set to the below, based on which Type
	StartMessageObj = "Capture the objective!",
	FinishMessageObj = "Mission Completed!",
	MissionTitleObj = "Boss Rush",
	MissionMessageObj = "Capture the objective!",	
	
	StartMessageAss = "Eliminate the targets!",
	FinishMessageAss = "Mission Completed!",
	MissionTitleAss = "Boss Rush",
	MissionMessageAss = "Eliminate the targets",
	--RandomMissionWeapons = {0x63AB0442},
	RandomMissionTypes ={"BossRush"},	
	Type = "Objective",	
	IsRandom = true,
	IsRandomEvent=true,
	--IsDefend = true,
	--IsDefendTarget = true,
	--IsDefendTargetChase = true,
	--IsDefendTargetGotoBlip=true,
	IsRandomSpawnAnywhere = true,
	RandomMissionSpawnRadius = 150.0, --keep a float for enemy ped wandering to work
	RandomMissionMaxPedSpawns = 75,
	RandomMissionMinPedSpawns = 50,
	RandomMissionMaxVehicleSpawns = 6,
	RandomMissionMinVehicleSpawns = 3,
	RandomMissionChanceToSpawnVehiclePerTry = 100,
	RandomMissionAircraftChance = 20,
	MissionLengthMinutes = 60,
	SafeHouseVehiclesMaxClaim = 3,
	SafeHouseVehicleCount = 9,
	SafeHouseAircraftCount = 3,
	SafeHouseBoatCount = 3,
	--SafeHouseVehicles ={'rcbandito'},
	--RandomMissionVehicles={"tampa3"},
	--RandomMissionAircraft={"volatol"},	
	--what x and y coordinate range should these mission spawn in?
	IsRandomSpawnAnywhereCoordRange = {xrange={-3500,4200},yrange={-3700,7700}},
	--RandomLocation = true, --for completely random location.. 
	--RandomMissionPeds = {"mp_m_freemode_01"},
	--RandomMissionAircraft = {"bombushka"},
	--RandomMissionVehicles = {"pounder2"},
	MissionTriggerRadius = 1000.0,
	RandomMissionGuardAircraft=true,
	
	SMS_Subject="Take out the targets",
	SMS_Message="Our Intel shows where the leaders of a heavily armed  mercenary group are",
	SMS_Message2="We need help to eliminate the danger. They are very dangerous and well protected",
	SMS_Message3="You think you can handle this?",	
		
	--SMS_ContactPics={"DIA_PRINCESS",
	--},
	--SMS_ContactNames={"Agency Contact",
	--},
	SMS_NoFailedMessage=true,
	SMS_NoPassedMessage=true,
	SMS_FailedSubject="HAHA",
	SMS_FailedMessage="You should have stayed away, this is much bigger than you",
	SMS_PassedSubject="Thank you",
	SMS_PassedMessage="Los Santos is safe and sound from the attack",				
	
	Blip = {
      Title = "Mission: Take out the targets",
      Position = { x = -10000, y = 0, z =  0},
      Icon     = 58,
      Display  = 4,
      Size     = 1.2,
      Color    = 1,
    },
	

    Marker = {
      Type     = 1,
      Position = { x = -10000, y = 0, z = 0}, 
      Size     = {x = 6.0, y = 6.0, z = 2.0},
      Color    = {r = 100, g = 100, b = 204},
      DrawDistance = 100.0,
    },
	BlipS = { --safehouse blip
      Title = "Mission Safehouse",
      Position = { x = 137.06, y = -3093.18, z = 4.9}, --{ x = 1944.96, y = 3150.6, z = 46.77},
      Icon     = 417,
      Display  = 4,
      Size     = 1.2,
      Color    = 2,
	  Alpha	 =80, --Used for AddBlipForRadius with IsDefend Missions
    },	
	 MarkerS = { --safehouse marker
      Type     = 1,
      Position = { x = 137.06, y = -3093.18, z = 4.9},  --{  x = 1944.96, y = 3150.6, z = 46.77}, 
      Size     = {x = 6.0, y = 6.0, z = 2.0},
      Color    = {r = 117, g = 218, b = 255},
      DrawDistance = 200.0,
    },
	BlipSL = { --safehouse Vehicle blip 
		  Title = "Mission Vehicle Safehouse",
		  Position = { x = -1228.1, y = -2267.77, z = 13.94}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 421,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},
	BlipSB = { --safehouse boat blip 
		  Title = "Mission Boat Safehouse",
		  Position = {x = 413.98, y = -3411.47, z = 0.23}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		 Icon     = 404,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},
	
	Props = { 
		--**need a stub entry set for the random prop**
		{ id=1, Name="",Position = { x = 0, y = 0, z = 0, heading = 0 }},
	
    },
	
	Peds = {
		--**need a stub entry set for the random ped hostage for HostageRescue=true**
      {id = 1, Position = { x = 0, y = 0, z = 0, heading = 0 }},
     },
	Events = {
		--**need a stub entry set for the random default event**
		--add custom events for mission with id=1 onwards
      {id = 1, 
		Position = { x = 50000.0, y = 50000.0, z = 50000.0, heading = 0 },
	  	  Size     = {radius=1000.0},
		  SpawnHeight = 200.0,
		  FacePlayer = true,
		  --NumberPeds=1,
		  isBoss=false,
		  Target=false,
		  SquadSpawnRadius=25.0,
		  
	  
	  },
     },	 
	 
	 Vehicles = { 
		--**need a stub entry set for the random prop**
		
	
    },	

	Pickups = {
		
	},
	MissionPickups = {
		
		
	}

  

  },

Mission19 = {
    
 	StartMessage = "A person you are protecting is being attacked~n~Help them!~n~~r~Hurry!",
	FinishMessage = "Mission Completed!",
	MissionTitle = "Extraction",
	MissionMessage = "New Mission",	
	
	--Obj/Ass values are the messages used depending on which random Type is selected Objective or Assassinate
	--The real messages (values above), will be set to the below, based on which Type
	StartMessageObj = "Capture the objective!",
	FinishMessageObj = "Mission Completed!",
	MissionTitleObj = "Takeover",
	MissionMessageObj = "Capture the objective!",	
	
	StartMessageAss = "Help a field operative whose cover was blown~n~~r~Hurry!",
	FinishMessageAss = "Mission Completed!",
	MissionTitleAss = "Extraction",
	MissionMessageAss = "Protect the operative from harm. Take out all targets",		
	Type = "Assassinate",	
	IsRandom = true,
	RandomMissionTypes ={"Assassinate"},
	IsDefend = true,
	IsDefendTarget = true,
	IsDefendTargetRescue = false,
	IsDefendTargetChase = true,
	--IsVehicleDefendTargetChase = true,
	--IsDefendTargetSetBlockingOfNonTemporaryEvents=true,
	--IsDefendTargetEnemySetBlockingOfNonTemporaryEvents=true,
	IsDefendTargetOnlyPlayersDamagePeds=false,
	--IsVehicleDefendTargetGotoGoal=true,
	--IsDefendTargetRewardBlip = true,
	--GoalReachedReward = 1000,	
	TeleportToSafeHouseOnMissionStartNoVehicle = true,
	SafeHouseTimeTillNextUse=30000, --10 seconds
	--TeleportToSafeHouseOnMissionStartDelay=2000,
	SafeHousePedDoctors = {},
	SafeHousePedLeaders = {},
	SafeHouseProps = {"hei_prop_carrier_crate_01a"},
	SafeHouseGiveImmediately = true,
	--RandomMissionDoLandBattle=false, 
	TeleportToSafeHouseMinDistance = 30,
	RemoveWeaponsAndUpgradesAtMissionStart = true,
	--IsDefendTargetOnlyPlayersDamagePeds=true,
	SpawnSafeHousePickups = {"WEAPON_COMBATPISTOL"},
	--SpawnSafeHouseComponents = {"COMPONENT_AT_PI_SUPP WEAPON_COMBATPISTOL","COMPONENT_COMBATPISTOL_CLIP_02 WEAPON_COMBATPISTOL"},
	SpawnSafeHouseComponents = {"COMPONENT_COMBATPISTOL_CLIP_02 WEAPON_COMBATPISTOL"},

	SafeHouseCrackDownModeHealthAmount=600,
	--IsDefendTargetDrivetoBlip=true,
	--TeleportToSafeHouseOnMissionStart = false,
	RandomMissionSpawnRadius = 250.0, --keep a float for enemy ped wandering to work
	RandomMissionMaxPedSpawns = 50,
	RandomMissionMinPedSpawns = 45,
	RandomMissionMaxVehicleSpawns = 2,
	RandomMissionMinVehicleSpawns = 1,
	RandomMissionChanceToSpawnVehiclePerTry = 100,
	RandomMissionAircraftChance = 0,
	RandomMissionBossChance=0,
	RandomMissionWeapons = {0xDD5DF8D9,0x99B507EA,0xCD274149,0x1B06D571},
	IsDefendTargetRandomPedWeapons = {0x1B06D571},
	UseSafeHouseLocations = false,
	--IsDefendTargetGoalDistance=50.0,
	RandomMissionDoBoats = false,
	MissionTriggerStartPoint = { x = 1791.91, y = 3806.26, z = 33.68,},
	MissionTriggerRadius = 5.0,
	--RandomMissionAircraft = {"microlight"},
	RandomMissionVehicles = {"scorcher","blazer","sanchez","caracara2"},
	RandomMissionBoats = {"blazer5"},
	RandomMissionBossPeds = {"ig_cletus"},
	RandomIsDefendTargetWander=true,
RandomMissionBikeQuadBoatWeapons = {0x1B06D571},
RandomMissionVehicleWeapons = {0x1B06D571},


	SMS_Subject="Extraction",
	SMS_Message="An undercover agent got compromised. We need someone to protect her ASAP",
	SMS_Message2="You will need to take out all the hostiles you encounter. Anyone up for this?",
	--SMS_Message3="Anyone up for this?",	
		
	SMS_ContactPics={"CHAR_STEVE",
	},
	SMS_ContactNames={"Agency Contact",
	},
	SMS_NoFailedMessage=true,
	SMS_NoPassedMessage=true,
	SMS_FailedSubject="HAHA",
	SMS_FailedMessage="You should have stayed away, this is much bigger than you",
	SMS_PassedSubject="Thank you",
	SMS_PassedMessage="Los Santos is safe and sound from the attack",				

	
	--UseSafeHouseLocations=true,
	
	
	
	--IsRandomSpawnAnywhere = true,
	
	--what x and y coordinate range should these mission spawn in?
	--RandomLocation = true, --for completely random location..

	
	Blip = {
      Title = "Objective",
      Position = { x = -10000, y = 0, z =  0},
      Icon     = 58,
      Display  = 4,
      Size     = 1.2,
      Color    = 1,
    },
	
	Blip2 = {
      Title = "Objective",
      Position = { x = -10000, y = 0, z =  0},
      Icon     = 58,
      Display  = 4,
      Size     = 1.2,
      Color    = 1,
    },

    Marker = {
      Type     = 1,
      Position = { x = -10000, y = 0, z = 0}, 
      Size     = {x = 6.0, y = 6.0, z = 2.0},
      Color    = {r = 100, g = 100, b = 204},
      DrawDistance = 1000.0,
    },
		BlipS = { --safehouse blip 
		  Title = "Mission Safehouse",
		  Position = {x = 1856.69, y = 3762.72, z = 32.11}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 417,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 2,
		  Alpha	 =80, 
		},	
		 MarkerS = { --safehouse marker
		  Type     = 1,
		  Position = { x = 1856.69, y = 3762.72, z = 32.11},  --{  x = 1944.96, y = 3150.6, z = 46.77}, 
		  Size     = {x = 2.0, y = 2.0, z = 2.0},
		  Color    = {r = 117, g = 218, b = 255},
		  DrawDistance = 200.0,
		},

	
	
	--[[	BlipS = { --safehouse blip
		  Title = "Mission Safehouse",
		  Position = {   x = 1258.8, y = 3118.75, z = 40.47}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 417,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 2,
		  Alpha	 =80, --Used for AddBlipForRadius with IsDefend Missions
		},	
		 MarkerS = { --safehouse marker
		  Type     = 1,
		  Position = {  x = 1258.8, y = 3118.75, z = 40.47 },  --{  x = 1944.96, y = 3150.6, z = 46.77}, 
		  Size     = {x = 2.0, y = 2.0, z = 2.0},
		  Color    = {r = 117, g = 218, b = 255},
		  DrawDistance = 200.0,
		},		
	
]]--
	
	Props = { 
		--**need a stub entry set for the random prop**
		{ id=1, Name="",Position = { x = 0, y = 0, z = 0, heading = 0 }},
	
    },
	
	Peds = {
		--**need a stub entry set for the random ped hostage for HostageRescue=true**
      {id = 1, Position = { x = 0, y = 0, z = 0, heading = 0 }},
     },
	 
	Vehicles = { 
		
	
    },	 
	

	Pickups = {
		
	},
	MissionPickups = {
		
		
	},
	
	RandomMissionPositions = { 
	
	{  x = 1791.91, y = 3806.26, z = 33.68,  MissionTitle="Extraction",
		Blip2 = { --safehouse blip
		  Title = "Mission: Extraction",
		  Position = {x = 1791.91, y = 3806.26, z = 33.68}, -- x = 2365.07, y = 2958.56, z = 49.06 --{ x = 1944.96, y = 3150.6, z = 46.77}, --x = 1345.43, y = 3152.51, z = 40.41
		  Icon     = 58,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 1,
		  Alpha	 =80,

		  --Used for AddBlipForRadius with IsDefend Missions
		},
		Blip = { --safehouse blip
		  Title = "Mission: Extraction",
		  Position = { x = 1791.91, y = 3806.26, z = 33.68}, -- x = 2365.07, y = 2958.56, z = 49.06 --{ x = 1944.96, y = 3150.6, z = 46.77}, --x = 1345.43, y = 3152.51, z = 40.41
		  Icon     = 58,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 1,
		  Alpha	 =80,

		  --Used for AddBlipForRadius with IsDefend Missions
		},		
		
		
		
		
		
		
		
		
	--DefendTargetInVehicle = true,
	--DefendTargetVehicleIsBoat=true,

	

	}, 

	},	

},
Mission20 = {
    
	StartMessage = "Locate and take out the enemy targets",
	FinishMessage = "Mission Completed!",
	MissionTitle = "Bounty Hunt",
	MissionMessage = "Locate and take out the enemy targets",		
	
	--Obj/Ass values are the messages used depending on which random Type is selected Objective or Assassinate
	--The real messages (values above), will be set to the below, based on which Type
	StartMessageObj = "Capture the objective!",
	FinishMessageObj = "Mission Completed!",
	MissionTitleObj = "Bounty Hunt",
	MissionMessageObj = "Capture the objective!",	
	
	StartMessageAss = "Locate and take out the enemy targets",
	FinishMessageAss = "Mission Completed!",
	MissionTitleAss = "Bounty Hunt",
	MissionMessageAss = "Locate and take out the enemy targets",
	--RandomMissionWeapons = {0x63AB0442},
	TargetKillReward = 300,
	KillReward = 100,
	KillBossPedBonus = 100, --stacks with both above
	Type = "Assassinate",	
	RandomMissionTypes ={"Assassinate"},	
	--RandomMissionTypes ={"HostageRescue"},
	IsRandom = true,
	IsRandomEvent=true,
	IsBountyHunt=true, --SET UP SQUADS TO RANDOM SPAWN IN GROUPS
	IsBountyHuntDoBoats=true,
	RandomMissionGuardAircraft=true,
	RandomMissionBossChance =  0, --bosses are spawned differently when IsBountyHunt = TRUE
								  --See Config.RandomMissionBountyBossChance
	RandomMissionPeds ={"hc_hacker","hc_gunman","ig_tomepsilon","u_m_m_bankman","u_m_m_jewelsec_01","ig_bankman","s_m_m_highsec_02","a_m_m_og_boss_01","u_m_m_jewelthief","s_m_m_movprem_01","ig_fbisuit_01","g_m_m_korboss_01","g_m_m_armboss_01","g_m_m_chiboss_01","g_m_m_mexboss_01","g_m_m_mexboss_02","g_m_y_salvaboss_01","ig_siemonyetarian","ig_solomon","s_m_m_ammucountry","ig_ballasog","ig_andreas","ig_barry","u_m_y_babyd","ig_benny","ig_brad","ig_chef2","ig_chef","ig_claypain","ig_chrisformage","ig_davenorton","ig_devin","ig_dreyfuss","ig_fabien","ig_g","ig_hao","ig_jewelass","ig_jimmyboston","ig_jimmydisanto","ig_joeminuteman","ig_josh","ig_kerrymcintosh","ig_lamardavis","u_m_y_militarybum","ig_milton","a_m_y_musclbeac_02","ig_natalia","ig_nigel","ig_omega","ig_ortega","ig_paige","ig_paper","s_m_y_pestcont_01","ig_popov","ig_ramp_gang","ig_rashcosvki","ig_ramp_mex","ig_roccopelosi","ig_russiandrunk","ig_stevehains","ig_stretch","ig_talina","ig_tanisha","ig_taocheng","ig_taostranslator","u_m_o_taphillbilly","ig_tenniscoach","ig_tracydisanto","ig_tylerdix","ig_vagspeak","ig_wade","ig_chengsr","ig_agent","a_f_y_femaleagent","g_m_importexport_01","g_f_importexport_01","ig_malc","mp_f_cardesign_01","mp_f_chbar_01","mp_f_cocaine_01","mp_f_execpa_01","mp_f_forgery_01","mp_f_meth_01","mp_f_weed_01","mp_m_cocaine_01","mp_m_counterfeit_01","mp_m_execpa_01","mp_m_forgery_01","mp_m_meth_01","mp_m_weapwork_01","mp_m_weed_01","ig_lestercrest_2","ig_avon","a_m_y_breakdance_01","mp_m_g_vagfun_01","a_m_y_vindouche_01","csb_undercover","a_m_m_tranvest_01","g_m_y_strpunk_01","g_m_y_strpunk_02","s_m_m_strpreach_01","a_m_y_gay_01","u_m_m_edtoh","s_m_m_doctor_01","u_m_m_edtoh","a_f_m_bodybuild_01","g_f_y_families_01",
	},
	RandomMissionIsBountyOverrideVehPeds = {"hc_hacker","hc_gunman","u_m_m_bankman","u_m_m_jewelsec_01","s_m_m_highsec_02","a_m_m_og_boss_01","u_m_m_jewelthief","s_m_m_movprem_01","g_m_m_korboss_01","g_m_m_armboss_01","g_m_m_chiboss_01","g_m_m_mexboss_01","g_m_m_mexboss_02","g_m_y_salvaboss_01","s_m_m_ammucountry","u_m_y_babyd","u_m_y_militarybum","a_m_y_musclbeac_02","s_m_y_pestcont_01","u_m_o_taphillbilly","a_f_y_femaleagent","g_m_importexport_01","g_f_importexport_01","mp_f_cardesign_01","mp_f_chbar_01","mp_f_cocaine_01","mp_f_execpa_01","mp_f_forgery_01","mp_f_meth_01","mp_f_weed_01","mp_m_cocaine_01","mp_m_counterfeit_01","mp_m_execpa_01","mp_m_forgery_01","mp_m_meth_01","mp_m_weapwork_01","mp_m_weed_01","a_m_y_breakdance_01","g_f_y_vagos_01","mp_m_g_vagfun_01","a_m_y_vindouche_01","a_m_m_tranvest_01","g_m_y_strpunk_01","g_m_y_strpunk_02","s_m_m_strpreach_01","a_m_y_gay_01","a_f_m_bodybuild_01","g_f_y_families_01",
		},	
	--RandomMissionVehicles = {	
	--"apc",},
	IsBountyHuntMinSquadSize=10,
	IsBountyHuntMaxSquadSize=10,
	IsBountySquadMinRadius=25,
	IsBountySquadMinRadius=150,
	RandomMissionBountyBossChance=10,
	--IsDefend = true,
	--IsDefendTarget = true,
	--IsDefendTargetChase = true,
	--IsDefendTargetGotoBlip=true,
	IsRandomSpawnAnywhere = true,
	--RandomMissionDoLandBattle=false,
	--little box at the center of the map, let randomized spawn radius take care of whole map
	IsRandomSpawnAnywhereCoordRange = {xrange={-30,30},yrange={1970,2030}},	
	RandomMissionSpawnRadius = 6000.0, --keep a float for enemy ped wandering to work
	RandomMissionMaxPedSpawns = 4,
	RandomMissionMinPedSpawns = 4,
	RandomMissionMaxVehicleSpawns = 2,
	RandomMissionMinVehicleSpawns = 2,
	RandomMissionChanceToSpawnVehiclePerTry = 100,
	RandomMissionAircraftChance = 20,
	--RandomMissionVehicles = {
	--"brutus",
	--"rcbandito",
	--},
	--RandomMissionAircraft = {
	--"titan",
	--"luxor",
	--"luxor2",
	--"miljet",
	--"cargobob",
	--"cargobob2",
	--"cargobob3",
	--"cargobob4"
	--},
	--RandomMissionAircraft = {
	--"akula",
	--},
	
	MissionLengthMinutes = 60,
	SafeHouseVehiclesMaxClaim = 3,
	SafeHouseVehicleCount = 9,
	SafeHouseAircraftCount = 3,
	SafeHouseBoatCount = 3,
	--SafeHouseVehicles ={'barrage'},
	--RandomMissionVehicles={"tampa3"},
	--RandomMissionAircraft={"valkyrie"},	
	--what x and y coordinate range should these mission spawn in?
	IsRandomSpawnAnywhereCoordRange = {xrange={-3500,4200},yrange={-3700,7700}}, --FULL MAP
	--IsRandomSpawnAnywhereCoordRange = {xrange={-2000,1500},yrange={ -3500,0}},
	--RandomLocation = true, --for completely random location.. 
	--RandomMissionPeds = {"mp_m_freemode_01"},
	--RandomMissionAircraft = {"bombushka"},
	--RandomMissionVehicles = {"barrage"},
	

	SMS_Subject="Bounty Hunt",
	SMS_Message="We need help to find and eliminate various hostile targets running rampant around San Andreas",
	--SMS_Message2="",
	--SMS_Message3="Anyone up for this?",	
		
	--SMS_ContactPics={"CHAR_STEVE",
	--},
	--SMS_ContactNames={"Agency Contact",
	--},
	SMS_NoFailedMessage=true,
	SMS_NoPassedMessage=true,
	SMS_FailedSubject="HAHA",
	SMS_FailedMessage="You should have stayed away, this is much bigger than you",
	SMS_PassedSubject="Thank you",
	SMS_PassedMessage="Los Santos is safe and sound from the attack",					
	
	
	Blip = {
      Title = "Objective",
      Position = { x = -10000, y = 0, z =  0},
      Icon     = 58,
      Display  = 4,
      Size     = 1.2,
      Color    = 1,
    },
	

    Marker = {
      Type     = 1,
      Position = { x = -10000, y = 0, z = 0}, 
      Size     = {x = 6.0, y = 6.0, z = 2.0},
      Color    = {r = 100, g = 100, b = 204},
      DrawDistance = 100.0,
    },
	BlipS = { --safehouse blip
      Title = "Mission Safehouse",
      Position = { x = 137.06, y = -3093.18, z = 4.9}, --{ x = 1944.96, y = 3150.6, z = 46.77},
      Icon     = 417,
      Display  = 4,
      Size     = 1.2,
      Color    = 2,
	  Alpha	 =80, --Used for AddBlipForRadius with IsDefend Missions
    },	
	 MarkerS = { --safehouse marker
      Type     = 1,
      Position = { x = 137.06, y = -3093.18, z = 4.9},  --{  x = 1944.96, y = 3150.6, z = 46.77}, 
      Size     = {x = 6.0, y = 6.0, z = 2.0},
      Color    = {r = 117, g = 218, b = 255},
      DrawDistance = 200.0,
    },
	BlipSL = { --safehouse Vehicle blip 
		  Title = "Mission Vehicle Safehouse",
		  Position = { x = -1228.1, y = -2267.77, z = 13.94}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 421,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},
	BlipSB = { --safehouse boat blip 
		  Title = "Mission Boat Safehouse",
		  Position = {x = 413.98, y = -3411.47, z = 0.23}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		 Icon     = 404,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},
	
	Props = { 
		--**need a stub entry set for the random prop**
		{ id=1, Name="",Position = { x = 0, y = 0, z = 0, heading = 0 }},
	
    },
	
	Vehicles = { 
		--**need a stub entry set for the random prop**
		
	
    },
	
	Peds = {
		--**need a stub entry set for the random ped hostage for HostageRescue=true**
      {id = 1, Position = { x = 0, y = 0, z = 0, heading = 0 }},
     },
	 
	Events = {
		--**need a stub entry set for the random default event**
		--add custom events for mission with id=1 onwards
      {id = 1, 
		Position = { x = 50000.0, y = 50000.0, z = 50000.0, heading = 0 },
	  	  Size     = {radius=1000.0},
		  SpawnHeight = 200.0,
		  FacePlayer = true,
		  --NumberPeds=1,
		  isBoss=false,
		  Target=false,
		  SquadSpawnRadius=25.0,
		  
	  
	  },
     }, 
	

	Pickups = {
		
	},
	MissionPickups = {
		
		
	}

  

  },
  Mission21 = {
    
	StartMessage = "Locate and rescue the hostages",
	FinishMessage = "Mission Completed!",
	MissionTitle = "Missing 411",
	MissionMessage = "Locate and rescue the hostages",		
	
	--Obj/Ass values are the messages used depending on which random Type is selected Objective or Assassinate
	--The real messages (values above), will be set to the below, based on which Type
	StartMessageObj = "Locate and rescue the hostages",
	FinishMessageObj = "Mission Completed!",
	MissionTitleObj = "Missing 411",
	MissionMessageObj = "Locate and rescue the hostages",	
	
	StartMessageAss = "Locate and rescue the hostages",
	FinishMessageAss = "Mission Completed!",
	MissionTitleAss = "Missing 411",
	MissionMessageAss = "Locate and rescue the hostages",
	--RandomMissionWeapons = {0x63AB0442},
	TargetKillReward = 200,
	KillReward = 100,
	HostageRescueReward = 300,
	KillBossPedBonus = 100, --stacks with both above
	Type = "Objective",	
	RandomMissionTypes ={"HostageRescue"},	
	--RandomMissionTypes ={"HostageRescue"},
	IsRandom = true,
	IsRandomEvent=true,
	IsBountyHunt=true, --SET UP SQUADS TO RANDOM SPAWN IN GROUPS
	IsBountyHuntDoBoats=true,
	RandomMissionBossChance =  0, --bosses are spawned differently when IsBountyHunt = TRUE
								  --See Config.RandomMissionBountyBossChance

	--RandomMissionVehicles = {	
	--"apc",},
	IsBountyHuntMinSquadSize=10,
	IsBountyHuntMaxSquadSize=10,
	IsBountySquadMinRadius=25,
	IsBountySquadMinRadius=150,
	RandomMissionBountyBossChance=10,
	--IsDefend = true,
	--IsDefendTarget = true,
	--IsDefendTargetChase = true,
	--IsDefendTargetGotoBlip=true,
	IsRandomSpawnAnywhere = true,
	--RandomMissionDoLandBattle=false,
	--little box at the center of the map, let randomized spawn radius take care of whole map
	IsRandomSpawnAnywhereCoordRange = {xrange={-30,30},yrange={1970,2030}},	
	RandomMissionSpawnRadius = 6000.0, --keep a float for enemy ped wandering to work
	RandomMissionMaxPedSpawns = 4,
	RandomMissionMinPedSpawns = 4,
	RandomMissionMaxVehicleSpawns = 2,
	RandomMissionMinVehicleSpawns = 2,
	RandomMissionChanceToSpawnVehiclePerTry = 100,
	RandomMissionAircraftChance = 20,
	RandomMissionGuardAircraft=true,
	--RandomMissionVehicles = {
	--"brutus",
	--"rcbandito",
	--},
	--RandomMissionAircraft = {
	--"titan",
	--"luxor",
	--"luxor2",
	--"miljet",
	--"cargobob",
	--"cargobob2",
	--"cargobob3",
	--"cargobob4"
	--},
	--RandomMissionAircraft = {
	--"akula",
	--},
	
	MissionLengthMinutes = 60,
	SafeHouseVehiclesMaxClaim = 3,
	SafeHouseVehicleCount = 9,
	SafeHouseAircraftCount = 3,
	SafeHouseBoatCount = 3,
	--SafeHouseVehicles ={'barrage'},
	--RandomMissionVehicles={"tampa3"},
	--RandomMissionAircraft={"valkyrie"},	
	--what x and y coordinate range should these mission spawn in?
	IsRandomSpawnAnywhereCoordRange = {xrange={-3500,4200},yrange={-3700,7700}}, --FULL MAP
	--IsRandomSpawnAnywhereCoordRange = {xrange={-2000,1500},yrange={ -3500,0}},
	--RandomLocation = true, --for completely random location.. 
	--RandomMissionPeds = {"mp_m_freemode_01"},
	--RandomMissionAircraft = {"bombushka"},
	--RandomMissionVehicles = {"barrage"},
	
	SMS_Subject="Bounty Hunt",
	SMS_Message="We need help to find and rescue various people who have been kidnapped around San Andreas",
	--SMS_Message2="",
	--SMS_Message3="Anyone up for this?",	
		
	--SMS_ContactPics={"CHAR_STEVE",
	--},
	--SMS_ContactNames={"Agency Contact",
	--},
	SMS_NoFailedMessage=true,
	SMS_NoPassedMessage=true,
	SMS_FailedSubject="HAHA",
	SMS_FailedMessage="You should have stayed away, this is much bigger than you",
	SMS_PassedSubject="Thank you",
	SMS_PassedMessage="Los Santos is safe and sound from the attack",
	
	
	Blip = {
      Title = "Objective",
      Position = { x = -10000, y = 0, z =  0},
      Icon     = 58,
      Display  = 4,
      Size     = 1.2,
      Color    = 1,
    },
	

    Marker = {
      Type     = 1,
      Position = { x = -10000, y = 0, z = 0}, 
      Size     = {x = 6.0, y = 6.0, z = 2.0},
      Color    = {r = 100, g = 100, b = 204},
      DrawDistance = 100.0,
    },
	BlipS = { --safehouse blip
      Title = "Mission Safehouse",
      Position = { x = 137.06, y = -3093.18, z = 4.9}, --{ x = 1944.96, y = 3150.6, z = 46.77},
      Icon     = 417,
      Display  = 4,
      Size     = 1.2,
      Color    = 2,
	  Alpha	 =80, --Used for AddBlipForRadius with IsDefend Missions
    },	
	 MarkerS = { --safehouse marker
      Type     = 1,
      Position = { x = 137.06, y = -3093.18, z = 4.9},  --{  x = 1944.96, y = 3150.6, z = 46.77}, 
      Size     = {x = 6.0, y = 6.0, z = 2.0},
      Color    = {r = 117, g = 218, b = 255},
      DrawDistance = 200.0,
    },
	BlipSL = { --safehouse Vehicle blip 
		  Title = "Mission Vehicle Safehouse",
		  Position = { x = -1228.1, y = -2267.77, z = 13.94}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 421,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},
	BlipSB = { --safehouse boat blip 
		  Title = "Mission Boat Safehouse",
		  Position = {x = 413.98, y = -3411.47, z = 0.23}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		 Icon     = 404,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},
	
	Props = { 
		--**need a stub entry set for the random prop**
		{ id=1, Name="",Position = { x = 0, y = 0, z = 0, heading = 0 }},
	
    },
	
	Vehicles = { 
		--**need a stub entry set for the random prop**
		
	
    },
	
	Peds = {
		--**need a stub entry set for the random ped hostage for HostageRescue=true**
      {id = 1, Position = { x = 0, y = 0, z = 0, heading = 0 }},
     },
	 
	Events = {
		--**need a stub entry set for the random default event**
		--add custom events for mission with id=1 onwards
      {id = 1, 
		Position = { x = 50000.0, y = 50000.0, z = 50000.0, heading = 0 },
	  	  Size     = {radius=1000.0},
		  SpawnHeight = 200.0,
		  FacePlayer = true,
		  --NumberPeds=1,
		  isBoss=false,
		  Target=false,
		  SquadSpawnRadius=25.0,
		  
	  
	  },
     }, 
	

	Pickups = {
		
	},
	MissionPickups = {
		
		
	}

  

  },

Mission22 = {
    
	StartMessage = "Reclaim the very important assets",
	FinishMessage = "Mission Completed!",
	MissionTitle = "Very Important Assets",
	MissionMessage = "Reclaim the stolen goods",	
	
	KillReward = 100,
	KillBossPedBonus = 100, --stacks with both above
	FinishedObjectiveReward =20000,
	
	--Obj/Ass values are the messages used depending on which random Type is selected Objective or Assassinate
	--The real messages (values above), will be set to the below, based on which Type
	StartMessageObj = "Reclaim the very important assets",
	FinishMessageObj = "Mission Completed!",
	MissionTitleObj = "Very Important Assets",
	MissionMessageObj = "Reclaim the stolen goods",	
	--RandomMissionTypes ={"Objective","Assassinate"},
	RandomMissionTypes ={"Objective"},
	StartMessageAss = "Reclaim the very important assets",
	FinishMessageAss = "Mission Completed!",
	MissionTitleAss = "Important Assets",
	MissionMessageAss = "Reclaim the stolen goods",	
	RandomMissionDoLandBattle=true, --needed for pier npcs to spawn!
	Type = "Objective",	
	--RandomMissionTypes ={"Objective","HostageRescue"},
	IsRandomEvent=true,
	IsRandom = true,
	IsRandomSpawnAnywhere=true,
	IsBountyHunt=true,
	RandomMissionMaxPedSpawns = 6,
	RandomMissionMinPedSpawns = 6,
	RandomMissionBossChance =  0,
	RandomMissionMaxVehicleSpawns = 4,
	RandomMissionMinVehicleSpawns = 4,
	RandomMissionSpawnRadius = 250.0,
	IsBountyHuntMinSquadSize=4,
	IsBountyHuntMaxSquadSize=4,
	IsBountySquadMinRadius=15,
	IsBountySquadMinRadius=150,
	RandomMissionBountyBossChance=5,
	RandomMissionGuardAircraft=true,
	MissionTriggerRadius = 1000.0,
	
	
	SMS_Subject="Important Assets",
	SMS_Message="We need help to reclaim important stolen assets, as well as to secure any contrabands",
	SMS_Message2="These assets are extremely valuable and well protected. Are you interested? The reward is great",
	--SMS_Message3="Anyone up for this?",	
		
	--SMS_ContactPics={"CHAR_STEVE",
	--},
	--SMS_ContactNames={"Agency Contact",
	--},
	SMS_NoFailedMessage=true,
	SMS_NoPassedMessage=true,
	SMS_FailedSubject="HAHA",
	SMS_FailedMessage="You should have stayed away, this is much bigger than you",
	SMS_PassedSubject="Thank you",
	SMS_PassedMessage="Los Santos is safe and sound from the attack",
	
	
--IsRandomSpawnAnywhereCoordRange = {xrange={-30,30},yrange={1970,2030}},	
	--RandomMissionSpawnRadius = 6000.0, --keep a float for enemy ped wandering to work
	--IsBountyHuntAssassinateAll = true,
	
	--RandomMissionTypes ={"Objective"},	
	--Config.RandomMissionPositions = { 
--{ x = 57.0, y = 3717.01, z = 39.75, MissionTitle="Trailer Park"},--lost caravans
--}
	--IsDefend = true,
	--IsDefendTarget = true,
	--IsDefendTargetChase = true,
	--IsDefendTargetGotoBlip=true,
	--IsRandomSpawnAnywhere = true,
	--what x and y coordinate range should these mission spawn in?
	--IsRandomSpawnAnywhereCoordRange = {xrange={-3500,4200},yrange={-3700,7700}},
	--RandomLocation = true, --for completely random location.. 
	
	Blip = {
      Title = "Objective",
      Position = { x = -10000, y = 0, z =  0},
      Icon     = 58,
      Display  = 4,
      Size     = 1.2,
      Color    = 1,
    },
	
	

    Marker = {
      Type     = 1,
      Position = { x = -10000, y = 0, z = 0}, 
      Size     = {x = 6.0, y = 6.0, z = 2.0},
      Color    = {r = 100, g = 100, b = 204},
      DrawDistance = 100.0,
    },
	BlipS = { --safehouse blip
      Title = "Mission Safehouse",
      Position = { x = 137.06, y = -3093.18, z = 4.9}, --{ x = 1944.96, y = 3150.6, z = 46.77},
      Icon     = 417,
      Display  = 4,
      Size     = 1.2,
      Color    = 2,
	  Alpha	 =80, --Used for AddBlipForRadius with IsDefend Missions
    },	
	 MarkerS = { --safehouse marker
      Type     = 1,
      Position = { x = 137.06, y = -3093.18, z = 4.9},  --{  x = 1944.96, y = 3150.6, z = 46.77}, 
      Size     = {x = 6.0, y = 6.0, z = 2.0},
      Color    = {r = 117, g = 218, b = 255},
      DrawDistance = 200.0,
    },
	BlipSL = { --safehouse Vehicle blip 
		  Title = "Mission Vehicle Safehouse",
		  Position = { x = -1228.1, y = -2267.77, z = 13.94}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 421,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},
	BlipSB = { --safehouse boat blip 
		  Title = "Mission Boat Safehouse",
		  Position = {x = 413.98, y = -3411.47, z = 0.23}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		 Icon     = 404,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},
	
	Props = { 
		--**need a stub entry set for the random prop**
		{ id=1, Name="",Position = { x = 0, y = 0, z = 0, heading = 0 }},
	
    },
	
	Peds = {
		--**need a stub entry set for the random ped hostage for HostageRescue=true**
      {id = 1, Position = { x = 0, y = 0, z = 0, heading = 0 }},
     },
	 Vehicles = { 
		--**need a stub entry set for the random prop**
		
	
    },	 
	Events = {
		--**need a stub entry set for the random default event**
		--add custom events for mission with id=1 onwards
      {id = 1, 
		Position = { x = 50000.0, y = 50000.0, z = 50000.0, heading = 0 },
	  	  Size     = {radius=1000.0},
		  SpawnHeight = 200.0,
		  FacePlayer = true,
		  --NumberPeds=1,
		  isBoss=false,
		  Target=false,
		  SquadSpawnRadius=25.0,
		  
	  
	  },
     },	

	Pickups = {
		
	},
	MissionPickups = {
		
		
	}

  

  },

Mission23 = {
    
	StartMessage = "Take out enemy targets!",
	FinishMessage = "Mission Completed!",
	MissionTitle = "Warfare",
	MissionMessage = "Take out the enemy targets",		
	
	--Obj/Ass values are the messages used depending on which random Type is selected Objective or Assassinate
	--The real messages (values above), will be set to the below, based on which Type
	StartMessageObj = "Capture the objective!",
	FinishMessageObj = "Mission Completed!",
	MissionTitleObj = "Warfare",
	MissionMessageObj = "Capture the objective!",	
	
	StartMessageAss = "Eliminate the targets!",
	FinishMessageAss = "Mission Completed!",
	MissionTitleAss = "Warfare",
	MissionMessageAss = "Take out the enemy targets",
	--RandomMissionWeapons = {0x63AB0442},
	TargetKillReward = 100,
	Type = "Assassinate",	
	RandomMissionTypes ={"Assassinate"},	
	--RandomMissionTypes ={"HostageRescue"},
	IsRandom = true,
	IsRandomEvent=true,
	IsBountyHunt=true, --SET UP SQUADS TO RANDOM SPAWN IN GROUPS
	IsBountyHuntDoBoats=true,
	RandomMissionBossChance =  0, --bosses are spawned differently when IsBountyHunt = TRUE
	RandomMissionGuardAircraft=true,
	MissionTriggerRadius = 1000.0,
								  --See Config.RandomMissionBountyBossChance
RandomMissionPeds ={"hc_hacker","hc_gunman","ig_tomepsilon","u_m_m_bankman","u_m_m_jewelsec_01","ig_bankman","s_m_m_highsec_02","a_m_m_og_boss_01","u_m_m_jewelthief","s_m_m_movprem_01","ig_fbisuit_01","g_m_m_korboss_01","g_m_m_armboss_01","g_m_m_chiboss_01","g_m_m_mexboss_01","g_m_m_mexboss_02","g_m_y_salvaboss_01","ig_siemonyetarian","ig_solomon","s_m_m_ammucountry","ig_ballasog","ig_andreas","ig_barry","u_m_y_babyd","ig_benny","ig_brad","ig_chef2","ig_chef","ig_claypain","ig_chrisformage","ig_davenorton","ig_devin","ig_dreyfuss","ig_fabien","ig_g","ig_hao","ig_jewelass","ig_jimmyboston","ig_jimmydisanto","ig_joeminuteman","ig_josh","ig_kerrymcintosh","ig_lamardavis","u_m_y_militarybum","ig_milton","a_m_y_musclbeac_02","ig_natalia","ig_nigel","ig_omega","ig_ortega","ig_paige","ig_paper","s_m_y_pestcont_01","ig_popov","ig_ramp_gang","ig_rashcosvki","ig_ramp_mex","ig_roccopelosi","ig_russiandrunk","ig_stevehains","ig_stretch","ig_talina","ig_tanisha","ig_taocheng","ig_taostranslator","u_m_o_taphillbilly","ig_tenniscoach","ig_tracydisanto","ig_tylerdix","ig_vagspeak","ig_wade","ig_chengsr","ig_agent","a_f_y_femaleagent","g_m_importexport_01","g_f_importexport_01","ig_malc","mp_f_cardesign_01","mp_f_chbar_01","mp_f_cocaine_01","mp_f_execpa_01","mp_f_forgery_01","mp_f_meth_01","mp_f_weed_01","mp_m_cocaine_01","mp_m_counterfeit_01","mp_m_execpa_01","mp_m_forgery_0","mp_m_meth_01","mp_m_weapwork_01","mp_m_weed_01","ig_lestercrest_2","ig_avon","a_m_y_breakdance_01","mp_m_g_vagfun_01","a_m_y_vindouche_01","csb_undercover","a_m_m_tranvest_01","g_m_y_strpunk_01","g_m_y_strpunk_02","s_m_m_strpreach_01","a_m_y_gay_01","u_m_m_edtoh","s_m_m_doctor_01","u_m_m_edtoh","a_f_m_bodybuild_01","g_f_y_families_01",
	},
	RandomMissionIsBountyOverrideVehPeds = {"hc_hacker","hc_gunman","u_m_m_bankman","u_m_m_jewelsec_01","s_m_m_highsec_02","a_m_m_og_boss_01","u_m_m_jewelthief","s_m_m_movprem_01","g_m_m_korboss_01","g_m_m_armboss_01","g_m_m_chiboss_01","g_m_m_mexboss_01","g_m_m_mexboss_02","g_m_y_salvaboss_01","s_m_m_ammucountry","u_m_y_babyd","u_m_y_militarybum","a_m_y_musclbeac_02","s_m_y_pestcont_01","u_m_o_taphillbilly","a_f_y_femaleagent","g_m_importexport_01","g_f_importexport_01","mp_f_cardesign_01","mp_f_chbar_01","mp_f_cocaine_01","mp_f_execpa_01","mp_f_forgery_01","mp_f_meth_01","mp_f_weed_01","mp_m_cocaine_01","mp_m_counterfeit_01","mp_m_execpa_01","mp_m_forgery_0","mp_m_meth_01","mp_m_weapwork_01","mp_m_weed_01","a_m_y_breakdance_01","g_f_y_vagos_01","mp_m_g_vagfun_01","a_m_y_vindouche_01","a_m_m_tranvest_01","g_m_y_strpunk_01","g_m_y_strpunk_02","s_m_m_strpreach_01","a_m_y_gay_01","a_f_m_bodybuild_01","g_f_y_families_01",
		},	
	--RandomMissionVehicles = {	
	--"apc",},
	
	--IsDefend = true,
	--IsDefendTarget = true,
	--IsDefendTargetChase = true,
	--IsDefendTargetGotoBlip=true,
	IsRandomSpawnAnywhere = true,
	--RandomMissionDoLandBattle=false,
	--little box at the center of the map, let randomized spawn radius take care of whole map
	--IsRandomSpawnAnywhereCoordRange = {xrange={-30,30},yrange={1970,2030}},	
	RandomMissionMaxPedSpawns = 6,
	RandomMissionMinPedSpawns = 6,
	RandomMissionBossChance =  0,
	RandomMissionMaxVehicleSpawns = 4,
	RandomMissionMinVehicleSpawns = 4,
	RandomMissionSpawnRadius = 250.0,
	IsBountyHuntMinSquadSize=6,
	IsBountyHuntMaxSquadSize=6,
	IsBountySquadMinRadius=15,
	IsBountySquadMinRadius=150,
	RandomMissionBountyBossChance=5,
	--RandomMissionVehicles = {
	--"brutus",
	--"rcbandito",
	--},
	--RandomMissionAircraft = {
	--"titan",
	--"luxor",
	--"luxor2",
	--"miljet",
	--"cargobob",
	--"cargobob2",
	--"cargobob3",
	--"cargobob4"
	--},
	--RandomMissionAircraft = {
	--"akula",
	--},
	
	MissionLengthMinutes = 60,
	SafeHouseVehiclesMaxClaim = 3,
	SafeHouseVehicleCount = 9,
	SafeHouseAircraftCount = 3,
	SafeHouseBoatCount = 3,
	--SafeHouseVehicles ={'barrage'},
	--RandomMissionVehicles={"tampa3"},
	--RandomMissionAircraft={"valkyrie"},	
	--what x and y coordinate range should these mission spawn in?
	IsRandomSpawnAnywhereCoordRange = {xrange={-3500,4200},yrange={-3700,7700}}, --FULL MAP
	--IsRandomSpawnAnywhereCoordRange = {xrange={-2000,1500},yrange={ -3500,0}},
	--RandomLocation = true, --for completely random location.. 
	--RandomMissionPeds = {"mp_m_freemode_01"},
	--RandomMissionAircraft = {"bombushka"},
	--RandomMissionVehicles = {"barrage"},
	
	
	SMS_Subject="Warfare",
	SMS_Message="Our intel shows that various mercenary factions are meeting up to plot an attack on Los Santos",
	SMS_Message2="Take the fight to them first and surprise them. Are you interested?",
	--SMS_Message3="Anyone up for this?",	
		
	--SMS_ContactPics={"CHAR_STEVE",
	--},
	--SMS_ContactNames={"Agency Contact",
	--},
	SMS_NoFailedMessage=true,
	SMS_NoPassedMessage=true,
	SMS_FailedSubject="HAHA",
	SMS_FailedMessage="You should have stayed away, this is much bigger than you",
	SMS_PassedSubject="Thank you",
	SMS_PassedMessage="Los Santos is safe and sound from the attack",
	
	Blip = {
      Title = "Objective",
      Position = { x = -10000, y = 0, z =  0},
      Icon     = 58,
      Display  = 4,
      Size     = 1.2,
      Color    = 1,
    },
	

    Marker = {
      Type     = 1,
      Position = { x = -10000, y = 0, z = 0}, 
      Size     = {x = 6.0, y = 6.0, z = 2.0},
      Color    = {r = 100, g = 100, b = 204},
      DrawDistance = 100.0,
    },
	BlipS = { --safehouse blip
      Title = "Mission Safehouse",
      Position = { x = 137.06, y = -3093.18, z = 4.9}, --{ x = 1944.96, y = 3150.6, z = 46.77},
      Icon     = 417,
      Display  = 4,
      Size     = 1.2,
      Color    = 2,
	  Alpha	 =80, --Used for AddBlipForRadius with IsDefend Missions
    },	
	 MarkerS = { --safehouse marker
      Type     = 1,
      Position = { x = 137.06, y = -3093.18, z = 4.9},  --{  x = 1944.96, y = 3150.6, z = 46.77}, 
      Size     = {x = 6.0, y = 6.0, z = 2.0},
      Color    = {r = 117, g = 218, b = 255},
      DrawDistance = 200.0,
    },
	BlipSL = { --safehouse Vehicle blip 
		  Title = "Mission Vehicle Safehouse",
		  Position = { x = -1228.1, y = -2267.77, z = 13.94}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 421,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},
	BlipSB = { --safehouse boat blip 
		  Title = "Mission Boat Safehouse",
		  Position = {x = 413.98, y = -3411.47, z = 0.23}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		 Icon     = 404,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},
	
	Props = { 
		--**need a stub entry set for the random prop**
		{ id=1, Name="",Position = { x = 0, y = 0, z = 0, heading = 0 }},
	
    },
	
	Vehicles = { 
		--**need a stub entry set for the random prop**
		
	
    },
	
	Peds = {
		--**need a stub entry set for the random ped hostage for HostageRescue=true**
      {id = 1, Position = { x = 0, y = 0, z = 0, heading = 0 }},
     },
	 
	Events = {
		--**need a stub entry set for the random default event**
		--add custom events for mission with id=1 onwards
      {id = 1, 
		Position = { x = 50000.0, y = 50000.0, z = 50000.0, heading = 0 },
	  	  Size     = {radius=1000.0},
		  SpawnHeight = 200.0,
		  FacePlayer = true,
		  --NumberPeds=1,
		  isBoss=false,
		  Target=false,
		  SquadSpawnRadius=25.0,
		  
	  
	  },
     }, 
	

	Pickups = {
		
	},
	MissionPickups = {
		
		
	}

  

  },
  
Mission24 = {
    
StartMessage = "Ensure that the asset and their vehicle~n~ make it to the destination~n~~r~Hurry!",
	FinishMessage = "Mission Completed!",
	MissionTitle = "The Gauntlet",
	MissionMessage = "New Mission",	
	
	--Obj/Ass values are the messages used depending on which random Type is selected Objective or Assassinate
	--The real messages (values above), will be set to the below, based on which Type
	StartMessageObj = "Capture the objective!",
	FinishMessageObj = "Mission Completed!",
	MissionTitleObj = "Takeover",
	MissionMessageObj = "Capture the objective!",	
	
	StartMessageAss = "Ensure that the asset and their vehicle~n~ make it to the destination~n~~r~Hurry!",
	FinishMessageAss = "Mission Completed!",
	MissionTitleAss = "The Gauntlet",
	MissionMessageAss = "Make sure the asset and their vehicle~n~make it to the destination",		
	Type = "Assassinate",	
	IsRandom = true,
	RandomMissionTypes ={"Assassinate"},
	IsDefend = true,
	IsDefendTarget = true,
	IsDefendTargetRescue = false,
	IsDefendTargetChase = true,
	IsVehicleDefendTargetChase = true,
	IsDefendTargetSetBlockingOfNonTemporaryEvents=true,
	--IsDefendTargetEnemySetBlockingOfNonTemporaryEvents=true,
	IsDefendTargetOnlyPlayersDamagePeds=false,
	IsVehicleDefendTargetGotoGoal=true,
	IsDefendTargetRewardBlip = true,
	GoalReachedReward = 5000,	
	TeleportToSafeHouseOnMissionStartNoVehicle = true,
	SafeHouseTimeTillNextUse=30000, --10 seconds
	--TeleportToSafeHouseOnMissionStartDelay=2000,
	SafeHousePedDoctors = {},
	SafeHousePedLeaders = {},
	SafeHouseProps = {"hei_prop_carrier_crate_01a"},
	SafeHouseGiveImmediately = true,
	
	--RandomMissionDoLandBattle=false, 
	TeleportToSafeHouseMinDistance = 30,
	--RemoveWeaponsAndUpgradesAtMissionStart = true,
	IsDefendTargetOnlyPlayersDamagePeds=true,
	--SpawnSafeHousePickups = {"WEAPON_COMBATPISTOL"},
	--SpawnSafeHouseComponents = {"COMPONENT_AT_PI_SUPP WEAPON_COMBATPISTOL","COMPONENT_COMBATPISTOL_CLIP_02 WEAPON_COMBATPISTOL"},
	SpawnSafeHouseComponents = {"COMPONENT_COMBATPISTOL_CLIP_02 WEAPON_COMBATPISTOL"},

	--SafeHouseCrackDownModeHealthAmount=200,
	--IsDefendTargetDrivetoBlip=true,
	--TeleportToSafeHouseOnMissionStart = false,
	RandomMissionSpawnRadius = 300.0, --keep a float for enemy ped wandering to work
	RandomMissionMaxPedSpawns = 15,
	RandomMissionMinPedSpawns = 5,
	RandomMissionMaxVehicleSpawns = 9,
	RandomMissionMinVehicleSpawns = 4,
	RandomMissionChanceToSpawnVehiclePerTry = 100,
	RandomMissionAircraftChance = 10,
	RandomMissionBossChance=20,
	--RandomMissionWeapons = {0xDD5DF8D9,0x99B507EA,0xCD274149,0x1B06D571},
	IsDefendTargetRandomPedWeapons = {0x1B06D571},
	UseSafeHouseLocations = false,
	IsDefendTargetPassenger=false,
	IsDefendTargetGoalDistance=50.0,
	--RandomMissionDoBoats = true,
	MissionTriggerRadius = 20.0,
	
	MissionTriggerStartPoint = { x = 1515.16, y = 3064.27, z = 41.3},
	
	
	
	--IsRandomSpawnAnywhere = true,
	
	--what x and y coordinate range should these mission spawn in?
	--RandomLocation = true, --for completely random location..
	
	SMS_Subject="The Gauntlet",
	SMS_Message="We need help to ensure that an asset and their vehicle make it to the destination",
	SMS_Message2="They will need an escort. Are you up for this?",
	--SMS_Message3="Anyone up for this?",	
		
	--SMS_ContactPics={"CHAR_STEVE",
	--},
	--SMS_ContactNames={"Agency Contact",
	--},
	SMS_NoFailedMessage=true,
	SMS_NoPassedMessage=true,
	SMS_FailedSubject="HAHA",
	SMS_FailedMessage="You should have stayed away, this is much bigger than you",
	SMS_PassedSubject="Thank you",
	SMS_PassedMessage="Los Santos is safe and sound from the attack",	

	
	Blip = {
      Title = "Objective",
      Position = { x = -10000, y = 0, z =  0},
      Icon     = 58,
      Display  = 4,
      Size     = 1.2,
      Color    = 1,
    },
	
	Blip2 = {
      Title = "Objective",
      Position = { x = -10000, y = 0, z =  0},
      Icon     = 58,
      Display  = 4,
      Size     = 1.2,
      Color    = 1,
    },

    Marker = {
      Type     = 1,
      Position = { x = -10000, y = 0, z = 0}, 
      Size     = {x = 6.0, y = 6.0, z = 2.0},
      Color    = {r = 100, g = 100, b = 204},
      DrawDistance = 500.0,
    },
		BlipS = { --safehouse blip
		  Title = "Mission Safehouse",
		  Position = {  x = 1532.73, y = 3093.11, z = 41.08}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 417,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 2,
		  Alpha	 =80, --Used for AddBlipForRadius with IsDefend Missions
		},	
		 MarkerS = { --safehouse marker
		  Type     = 1,
		  Position = { x = 1532.73, y = 3093.11, z = 40.08 },  --{  x = 1944.96, y = 3150.6, z = 46.77}, 
		  Size     = {x = 2.0, y = 2.0, z = 2.0},
		  Color    = {r = 117, g = 218, b = 255},
		  DrawDistance = 200.0,
		},
		BlipSL = { --safehouse Vehicle blip 
		  Title = "Mission Vehicle Safehouse",
		  Position = { x = 1480.63, y = 3167.93, z = 40.99}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 421,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},
		BlipSB = { --safehouse boat blip 
		  Title = "Mission Boat Safehouse",
		  Position = {x = 1481.84, y = 3873.37, z = 30.04}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		 Icon     = 404,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},		
	

	
	Props = { 
		--**need a stub entry set for the random prop**
		{ id=1, Name="",Position = { x = 0, y = 0, z = 0, heading = 0 }},
	
    },
	
	Peds = {
		--**need a stub entry set for the random ped hostage for HostageRescue=true**
      {id = 1, Position = { x = 0, y = 0, z = 0, heading = 0 }},
     },
	 
	Vehicles = { 
		
	
    },	 
	

	Pickups = {
		
	},
	MissionPickups = {
		
		
	},
	
	RandomMissionPositions = { 
	
	{  x = 1318.13, y = 3624.67, z = 33.5,  MissionTitle="The Gauntlet",
		Blip2 = { --safehouse blip
		  Title = "Mission Start",
		  Position = { x = 1515.16, y = 3064.27, z = 41.3}, -- x = 2365.07, y = 2958.56, z = 49.06 --{ x = 1944.96, y = 3150.6, z = 46.77}, --x = 1345.43, y = 3152.51, z = 40.41
		  Icon     = 58,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 1,
		  Alpha	 =80,

		  --Used for AddBlipForRadius with IsDefend Missions
		},
		Blip = { --safehouse blip
		  Title = "Destination",
		  Position = { x = 890.31, y = 3717.53, z = 29.66}, -- x = 2365.07, y = 2958.56, z = 49.06 --{ x = 1944.96, y = 3150.6, z = 46.77}, --x = 1345.43, y = 3152.51, z = 40.41
		  Icon     = 38,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 1,
		  Alpha	 =80,

		  --Used for AddBlipForRadius with IsDefend Missions
		},		
		
	DefendTargetInVehicle = true,
	--DefendTargetVehicleIsBoat=true,
	DefendTargetVehicleMoveSpeedRatio = 0.5, --have vehicle move at 1/2 top speed

	}, 

	},
RandomMissionDestinations = { 

{ x = -973.87, y = -273.67, z = 38.26, MissionTitle="Arcade"}, --cul de sac near studios
 
{ x = -1102.97, y = -424.98, z = 44.37, MissionTitle="News Studio" }, --news channel/studio building roof
{ x = -1223.9, y = -493.83, z = 31.51, MissionTitle="Back Alley" }, --news channel/studio in cul de sac

--{ x = 2840.52, y = -1449.96, z = 11.95, MissionTitle="The Island"}, --island

{ x = 1074.41, y = 3072.94, z = 40.82, MissionTitle="Desert Airstrip"}, --desert airstrip

--{x = -149.29, y = -960.51, z = 269.13, MissionTitle="High Rise"}, --construction tower

{ x = -1393.62, y = -2562.09, z = 13.95, MissionTitle="Airport" }, --airport

{ x = 137.07, y = -3204.05, z = 5.86,  MissionTitle="Docks" }, --walkers docks
{ x = -1828.32, y = -1218.22, z = 13.03, MissionTitle="The Pier" }, --pier

{ x = -547.74, y = -1477.3, z = 10.14, MissionTitle="Freeway Hideaway" }, --center greenery	

{ x = 1485.24, y = -2358.31, z = 72.44, MissionTitle="Oil Fields" }, --oilfields


{ x = 58.43, y = -1133.28, z = 29.34, MissionTitle="Street Smart"}, --los santos road
{ x = -808.9, y = -1302.95, z = 5.0, MissionTitle="Marina" }, --yacht club

{ x = 31.0, y = -767.1, z = 44.24, MissionTitle="Business District" }, --center los santos

{ x = 1874.74, y = 299.22, z = 162.82, MissionTitle="Resevoir" }, --resevoir

{ x = 1373.59, y = -739.58, z = 67.23, MissionTitle="Suburban Sprawl"}, --cul de sac

{ x = 1150.09, y = 124.3, z = 82.12, MissionTitle="Race Track"}, --race track

--'force = true' stops ray trace checking for spawn points for peds and vehicles, so peds/vehicles can spawn underneath structures... near the spawn location 
--this also means that peds/vehicles can spawn hidden in buildings, so this forces the mission type to be "Objective"
{ x = -177.69, y = -165.11, z = 44.03, MissionTitle="Concierge Service", force=true}, --hotel north los santos 

--{ x = -2237.38, y = 266.45, z = 174.62, MissionTitle="The Ritz" },
 --ritz hotel

{ x = -412.9, y = 1170.53, z = 325.84, MissionTitle="Observatory"}, --observatory

{ x = 756.1, y = 1284.89, z = 360.3, MissionTitle="Vinewood" }, --vinewood sign

{ x = -1907.85, y = 2037.05, z = 140.74, MissionTitle="Wine Country"}, --vineyard

{ x = -1833.24, y = 2152.89, z = 115.7, MissionTitle="Vinery"}, --vineyard 2

{ x = -2548.21, y = 2705.28, z = 2.84, MissionTitle="Secret Bunker" }, --outside base

{ x = -2405.68, y = 4253.63, z = 9.82, MissionTitle="Point Break"}, --nw beach

{ x = 57.0, y = 3717.01, z = 39.75, MissionTitle="Trailer Park"},--lost caravans
{ x = 1816.42, y = 3794.64, z = 33.65, MissionTitle="Dust Bowl"}, --south salton
{ x = 1313.35, y = 4327.67, z = 38.21, MissionTitle="Fish Monger" }, --north salton

--{ x = 3572.73, y = 3665.03, z = 33.89, MissionTitle="The Complex"}, --humane labs

{ x = 3803.26, y = 4462.52, z = 4.75, MissionTitle="Getaway" }, --north east coast

{ x = -1122.74, y = 4924.89, z = 218.67, MissionTitle="Compound"  }, --cult

{ x = -578.96, y = 5321.1, z = 70.21, MissionTitle="Sawmill" }, --sawmill

{ x = -31.49, y = 6441.9, z = 31.43, MissionTitle="Community Chest"  }, --parking lot uppoer NW

{ x = 28.76, y = 6216.7, z = 31.54, MissionTitle="Railyard"  }, --by railyard upper nw
{ x = 1429.43, y = 6517.94, z = 18.91, MissionTitle="Scenic Route"  }, --uppper coast


}


	
  },



Mission25 = {
    
StartMessage = "Ensure that the asset and their plane~n~ make it to the destination~n~~r~Hurry!",
	FinishMessage = "Mission Completed!",
	MissionTitle = "Top Gun",
	MissionMessage = "New Mission",	
	
	--Obj/Ass values are the messages used depending on which random Type is selected Objective or Assassinate
	--The real messages (values above), will be set to the below, based on which Type
	StartMessageObj = "Capture the objective!",
	FinishMessageObj = "Mission Completed!",
	MissionTitleObj = "Takeover",
	MissionMessageObj = "Capture the objective!",	
	
	StartMessageAss = "Ensure that the asset and their plane~n~ make it to the destination~n~~r~Hurry!",
	FinishMessageAss = "Mission Completed!",
	MissionTitleAss = "Top Gun",
	MissionMessageAss = "Ensure that the asset and their plane~n~ make it to the destination",		
	Type = "Assassinate",	
	IsRandom = true,
	RandomMissionTypes ={"Assassinate"},
	IsDefend = true,
	IsDefendTarget = true,
	IsDefendTargetRescue = false,
	IsDefendTargetChase = true,
	IsVehicleDefendTargetChase = true,
	IsDefendTargetSetBlockingOfNonTemporaryEvents=true,
	--IsDefendTargetEnemySetBlockingOfNonTemporaryEvents=true,
	IsDefendTargetOnlyPlayersDamagePeds=false,
	IsVehicleDefendTargetGotoGoal=true,
	IsDefendTargetRewardBlip = true,
	GoalReachedReward = 5000,	
	TeleportToSafeHouseOnMissionStartNoVehicle = true,
	SafeHouseTimeTillNextUse=30000, --10 seconds
	--TeleportToSafeHouseOnMissionStartDelay=2000,
	SafeHousePedDoctors = {},
	SafeHousePedLeaders = {},
	SafeHouseProps = {"hei_prop_carrier_crate_01a"},
	SafeHouseGiveImmediately = true,
	
	--RandomMissionDoLandBattle=false, 
	TeleportToSafeHouseMinDistance = 30,
	--RemoveWeaponsAndUpgradesAtMissionStart = true,
	IsDefendTargetOnlyPlayersDamagePeds=true,
	--SpawnSafeHousePickups = {"WEAPON_COMBATPISTOL"},
	--SpawnSafeHouseComponents = {"COMPONENT_AT_PI_SUPP WEAPON_COMBATPISTOL","COMPONENT_COMBATPISTOL_CLIP_02 WEAPON_COMBATPISTOL"},
	SpawnSafeHouseComponents = {"COMPONENT_COMBATPISTOL_CLIP_02 WEAPON_COMBATPISTOL"},

	SafeHouseCrackDownModeHealthAmount=200,
	--IsDefendTargetDrivetoBlip=true,
	--TeleportToSafeHouseOnMissionStart = false,
	RandomMissionSpawnRadius = 250.0, --keep a float for enemy ped wandering to work
	RandomMissionMaxPedSpawns = 15,
	RandomMissionMinPedSpawns = 5,
	RandomMissionMaxVehicleSpawns = 9,
	RandomMissionMinVehicleSpawns = 4,
	SafeHouseVehicleCount = 6,
	SafeHouseAircraftCount = 6,
	RandomMissionChanceToSpawnVehiclePerTry = 100,
	RandomMissionAircraftChance = 100,
	RandomMissionBossChance=20,
	--RandomMissionWeapons = {0xDD5DF8D9,0x99B507EA,0xCD274149,0x1B06D571},
	--IsDefendTargetRandomPedWeapons = {0x1B06D571},
	UseSafeHouseLocations = false,
	IsDefendTargetPassenger=false,
	IsDefendTargetGoalDistance=100.0,
	--RandomMissionDoBoats = true,
	MissionTriggerRadius = 20.0,
	MissionTriggerStartPoint = { x = 1515.16, y = 3064.27, z = 41.3},
   IsDefendTargetGoalDistance=100.0,
	IsDefendTargetRandomAircraft = {
	"pyro", "rogue","tula"
	},
	SafeHouseAircraft = 
	{
	"hydra",
	"lazer",
	"tula",
	"pyro",
	"rogue",

	},
	
	
	--IsRandomSpawnAnywhere = true,
	
	--what x and y coordinate range should these mission spawn in?
	--RandomLocation = true, --for completely random location..
	
	
	SMS_Subject="Top Gun",
	SMS_Message="We need help to ensure that an asset and their aircraft make it to the destination",
	SMS_Message2="They will need an escort. Are you up for this?",
	--SMS_Message3="Anyone up for this?",	
		
	--SMS_ContactPics={"CHAR_STEVE",
	--},
	--SMS_ContactNames={"Agency Contact",
	--},
	SMS_NoFailedMessage=true,
	SMS_NoPassedMessage=true,
	SMS_FailedSubject="HAHA",
	SMS_FailedMessage="You should have stayed away, this is much bigger than you",
	SMS_PassedSubject="Thank you",
	SMS_PassedMessage="Los Santos is safe and sound from the attack",	
	
	Blip = {
      Title = "Objective",
      Position = { x = -10000, y = 0, z =  0},
      Icon     = 58,
      Display  = 4,
      Size     = 1.2,
      Color    = 1,
    },
	
	Blip2 = {
      Title = "Objective",
      Position = { x = -10000, y = 0, z =  0},
      Icon     = 58,
      Display  = 4,
      Size     = 1.2,
      Color    = 1,
    },

    Marker = {
      Type     = 1,
      Position = { x = -10000, y = 0, z = 0}, 
      Size     = {x = 6.0, y = 6.0, z = 2.0},
      Color    = {r = 100, g = 100, b = 204},
      DrawDistance = 500.0,
    },
		BlipS = { --safehouse blip
		  Title = "Mission Safehouse",
		  Position = {  x = 1532.73, y = 3093.11, z = 41.08}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 417,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 2,
		  Alpha	 =80, --Used for AddBlipForRadius with IsDefend Missions
		},	
		 MarkerS = { --safehouse marker
		  Type     = 1,
		  Position = { x = 1532.73, y = 3093.11, z = 40.08 },  --{  x = 1944.96, y = 3150.6, z = 46.77}, 
		  Size     = {x = 2.0, y = 2.0, z = 2.0},
		  Color    = {r = 117, g = 218, b = 255},
		  DrawDistance = 200.0,
		},
		BlipSL = { --safehouse Vehicle blip 
		  Title = "Mission Vehicle Safehouse",
		  Position = { x = 1480.63, y = 3167.93, z = 40.99}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 421,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},
		BlipSB = { --safehouse boat blip 
		  Title = "Mission Boat Safehouse",
		  Position = {x = 1481.84, y = 3873.37, z = 30.04}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		 Icon     = 404,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},		
	

	
	Props = { 
		--**need a stub entry set for the random prop**
		{ id=1, Name="",Position = { x = 0, y = 0, z = 0, heading = 0 }},
	
    },
	
	Peds = {
		--**need a stub entry set for the random ped hostage for HostageRescue=true**
      {id = 1, Position = { x = 0, y = 0, z = 0, heading = 0 }},
     },
	 
	Vehicles = { 
		
	
    },	 
	

	Pickups = {
		
	},
	MissionPickups = {
		
		
	},
	
	RandomMissionPositions = { 
	
	{  x = 1318.13, y = 3624.67, z = 33.5,  MissionTitle="Top Gun",
		Blip2 = { --safehouse blip
		  Title = "Mission Start",
		  Position = { x = 1515.16, y = 3064.27, z = 41.3}, -- x = 2365.07, y = 2958.56, z = 49.06 --{ x = 1944.96, y = 3150.6, z = 46.77}, --x = 1345.43, y = 3152.51, z = 40.41
		  Icon     = 58,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 1,
		  Alpha	 =80,

		  --Used for AddBlipForRadius with IsDefend Missions
		},
		Blip = { --safehouse blip
		  Title = "Destination",
		  Position = { x = 890.31, y = 3717.53, z = 29.66}, -- x = 2365.07, y = 2958.56, z = 49.06 --{ x = 1944.96, y = 3150.6, z = 46.77}, --x = 1345.43, y = 3152.51, z = 40.41
		  Icon     = 38,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 1,
		  Alpha	 =80,

		  --Used for AddBlipForRadius with IsDefend Missions
		},		
		
	DefendTargetInVehicle = true,
	DefendTargetVehicleIsAircraft=true,

	}, 

	},
RandomMissionDestinations = { 

{ x = -973.87, y = -273.67, z = 38.26, MissionTitle="Arcade"}, --cul de sac near studios
 
{ x = -1102.97, y = -424.98, z = 44.37, MissionTitle="News Studio" }, --news channel/studio building roof
{ x = -1223.9, y = -493.83, z = 31.51, MissionTitle="Back Alley" }, --news channel/studio in cul de sac

{ x = 2840.52, y = -1449.96, z = 11.95, MissionTitle="The Island"}, --island

{ x = 1074.41, y = 3072.94, z = 40.82, MissionTitle="Desert Airstrip"}, --desert airstrip

--{x = -149.29, y = -960.51, z = 269.13, MissionTitle="High Rise"}, --construction tower

{ x = -1393.62, y = -2562.09, z = 13.95, MissionTitle="Airport" }, --airport

{ x = 137.07, y = -3204.05, z = 5.86,  MissionTitle="Docks" }, --walkers docks
{ x = -1828.32, y = -1218.22, z = 13.03, MissionTitle="The Pier" }, --pier

{ x = -547.74, y = -1477.3, z = 10.14, MissionTitle="Freeway Hideaway" }, --center greenery	

{ x = 1485.24, y = -2358.31, z = 72.44, MissionTitle="Oil Fields" }, --oilfields


{ x = 58.43, y = -1133.28, z = 29.34, MissionTitle="Street Smart"}, --los santos road
{ x = -808.9, y = -1302.95, z = 5.0, MissionTitle="Marina" }, --yacht club

{ x = 31.0, y = -767.1, z = 44.24, MissionTitle="Business District" }, --center los santos

{ x = 1874.74, y = 299.22, z = 162.82, MissionTitle="Resevoir" }, --resevoir

{ x = 1373.59, y = -739.58, z = 67.23, MissionTitle="Suburban Sprawl"}, --cul de sac

{ x = 1150.09, y = 124.3, z = 82.12, MissionTitle="Race Track"}, --race track

--'force = true' stops ray trace checking for spawn points for peds and vehicles, so peds/vehicles can spawn underneath structures... near the spawn location 
--this also means that peds/vehicles can spawn hidden in buildings, so this forces the mission type to be "Objective"
--{ x = -177.69, y = -165.11, z = 44.03, MissionTitle="Concierge Service", force=true}, --hotel north los santos 

{ x = -2237.38, y = 266.45, z = 174.62, MissionTitle="The Ritz" },
 --ritz hotel

{ x = -412.9, y = 1170.53, z = 325.84, MissionTitle="Observatory"}, --observatory

{ x = 756.1, y = 1284.89, z = 360.3, MissionTitle="Vinewood" }, --vinewood sign

{ x = -1907.85, y = 2037.05, z = 140.74, MissionTitle="Wine Country"}, --vineyard

{ x = -1833.24, y = 2152.89, z = 115.7, MissionTitle="Vinery"}, --vineyard 2

{ x = -2548.21, y = 2705.28, z = 2.84, MissionTitle="Secret Bunker" }, --outside base

{ x = -2405.68, y = 4253.63, z = 9.82, MissionTitle="Point Break"}, --nw beach

{ x = 57.0, y = 3717.01, z = 39.75, MissionTitle="Trailer Park"},--lost caravans
{ x = 1816.42, y = 3794.64, z = 33.65, MissionTitle="Dust Bowl"}, --south salton
{ x = 1313.35, y = 4327.67, z = 38.21, MissionTitle="Fish Monger" }, --north salton

{ x = 3572.73, y = 3665.03, z = 33.89, MissionTitle="The Complex"}, --humane labs

{ x = 3803.26, y = 4462.52, z = 4.75, MissionTitle="Getaway" }, --north east coast

{ x = -1122.74, y = 4924.89, z = 218.67, MissionTitle="Compound"  }, --cult

{ x = -578.96, y = 5321.1, z = 70.21, MissionTitle="Sawmill" }, --sawmill

{ x = -31.49, y = 6441.9, z = 31.43, MissionTitle="Community Chest"  }, --parking lot uppoer NW

{ x = 28.76, y = 6216.7, z = 31.54, MissionTitle="Railyard"  }, --by railyard upper nw
{ x = 1429.43, y = 6517.94, z = 18.91, MissionTitle="Scenic Route"  }, --uppper coast


}


	
 },


Mission26 = {
    
StartMessage = "Ensure that the asset and their boat~n~ make it to the destination~n~~r~Hurry!",
	FinishMessage = "Mission Completed!",
	MissionTitle = "I'm On A Boat",
	MissionMessage = "New Mission",	
	
	--Obj/Ass values are the messages used depending on which random Type is selected Objective or Assassinate
	--The real messages (values above), will be set to the below, based on which Type
	StartMessageObj = "Capture the objective!",
	FinishMessageObj = "Mission Completed!",
	MissionTitleObj = "Takeover",
	MissionMessageObj = "Capture the objective!",	
	
	StartMessageAss = "Ensure that the asset and their boat~n~ make it to the destination~n~~r~Hurry!",
	FinishMessageAss = "Mission Completed!",
	MissionTitleAss = "I'm On A Boat",
	MissionMessageAss = "Ensure that the asset and their boat~n~ make it to the destination",		
	Type = "Assassinate",	
	IsRandom = true,
	RandomMissionTypes ={"Assassinate"},
	IsDefend = true,
	IsDefendTarget = true,
	IsDefendTargetRescue = false,
	IsDefendTargetChase = true,
	IsVehicleDefendTargetChase = true,
	IsDefendTargetSetBlockingOfNonTemporaryEvents=true,
	--IsDefendTargetEnemySetBlockingOfNonTemporaryEvents=true,
	IsDefendTargetOnlyPlayersDamagePeds=false,
	IsVehicleDefendTargetGotoGoal=true,
	IsDefendTargetRewardBlip = true,
	GoalReachedReward = 5000,	
	TeleportToSafeHouseOnMissionStartNoVehicle = true,
	SafeHouseTimeTillNextUse=30000, --10 seconds
	--TeleportToSafeHouseOnMissionStartDelay=2000,
	SafeHousePedDoctors = {},
	SafeHousePedLeaders = {},
	SafeHouseProps = {"hei_prop_carrier_crate_01a"},
	SafeHouseGiveImmediately = true,
	
	--RandomMissionDoLandBattle=false, 
	TeleportToSafeHouseMinDistance = 30,
	--RemoveWeaponsAndUpgradesAtMissionStart = true,
	IsDefendTargetOnlyPlayersDamagePeds=true,
	--SpawnSafeHousePickups = {"WEAPON_COMBATPISTOL"},
	--SpawnSafeHouseComponents = {"COMPONENT_AT_PI_SUPP WEAPON_COMBATPISTOL","COMPONENT_COMBATPISTOL_CLIP_02 WEAPON_COMBATPISTOL"},
	SpawnSafeHouseComponents = {"COMPONENT_COMBATPISTOL_CLIP_02 WEAPON_COMBATPISTOL"},

	SafeHouseCrackDownModeHealthAmount=200,
	--IsDefendTargetDrivetoBlip=true,
	--TeleportToSafeHouseOnMissionStart = false,
	RandomMissionSpawnRadius = 150.0, --keep a float for enemy ped wandering to work
	RandomMissionMaxPedSpawns = 15,
	RandomMissionMinPedSpawns = 5,
	RandomMissionMaxVehicleSpawns = 9,
	RandomMissionMinVehicleSpawns = 6,
	SafeHouseVehicleCount = 6,
	SafeHouseAircraftCount = 2,
	SafeHouseBoatCount = 6,
	RandomMissionChanceToSpawnVehiclePerTry = 100,
	RandomMissionAircraftChance = 10,
	RandomMissionBossChance=20,
	--RandomMissionWeapons = {0xDD5DF8D9,0x99B507EA,0xCD274149,0x1B06D571},
	--IsDefendTargetRandomPedWeapons = {0x1B06D571},
	UseSafeHouseLocations = false,
	IsDefendTargetPassenger=false,
	IsDefendTargetGoalDistance=50.0,
	RandomMissionDoBoats = true,
	MissionTriggerRadius = 30.0,
	MissionTriggerStartPoint = { x = 2378.29, y = 4505.14, z = 31.25},
    IsDefendTargetGoalDistance=30.0,

	
	--IsRandomSpawnAnywhere = true,
	
	--what x and y coordinate range should these mission spawn in?
	--RandomLocation = true, --for completely random location..
	
	
	SMS_Subject="Adrift",
	SMS_Message="We need help to ensure that an asset and their boat make it to the destination",
	SMS_Message2="They will need an escort. Are you up for this?",
	--SMS_Message3="Anyone up for this?",	
		
	--SMS_ContactPics={"CHAR_STEVE",
	--},
	--SMS_ContactNames={"Agency Contact",
	--},
	SMS_NoFailedMessage=true,
	SMS_NoPassedMessage=true,
	SMS_FailedSubject="HAHA",
	SMS_FailedMessage="You should have stayed away, this is much bigger than you",
	SMS_PassedSubject="Thank you",
	SMS_PassedMessage="Los Santos is safe and sound from the attack",	
	
		Events = {
		--**need a stub entry set for the random default event**
		--add custom events for mission with id=1 onwards
      {id = 1, 
		Position = { x = 50000.0, y = 50000.0, z = 50000.0, heading = 0 },
	  	  Size     = {radius=1000.0},
		  SpawnHeight = 200.0,
		  FacePlayer = true,
		  --NumberPeds=1,
		  isBoss=false,
		  Target=false,
		  SquadSpawnRadius=25.0,
		  
	  
	  },
    {id = 2, 
		Position = {x = 1264.24, y = 4039.11, z = 29.91, heading = 159.45  },
	  	  Type="Boat",
		  Size     = {radius=4000.0},
		  SpawnHeight = 200.0,
		  FacePlayer = true,
		  Vehicle="dinghy3",
		  modelHash="a_m_y_breakdance_01",
		  DoIsDefendBehavior=true,
		  DoBlockingOfNonTemporaryEvents=true,
		  --NumberPeds=1,
		  isBoss=false,
		  Target=true,
		  SquadSpawnRadius=25.0,
		  
	  
	  },	  
	  
     },	

	
	Blip = {
      Title = "Objective",
      Position = { x = -10000, y = 0, z =  0},
      Icon     = 58,
      Display  = 4,
      Size     = 1.2,
      Color    = 1,
    },
	
	Blip2 = {
      Title = "Objective",
      Position = { x = -10000, y = 0, z =  0},
      Icon     = 58,
      Display  = 4,
      Size     = 1.2,
      Color    = 1,
    },

    Marker = {
      Type     = 1,
      Position = { x = -10000, y = 0, z = 0}, 
      Size     = {x = 6.0, y = 6.0, z = 2.0},
      Color    = {r = 100, g = 100, b = 204},
      DrawDistance = 500.0,
    },
		BlipS = { --safehouse blip
		  Title = "Mission Safehouse",
		  Position = { x = 2378.29, y = 4505.14, z = 31.25}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 417,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 2,
		  Alpha	 =80, --Used for AddBlipForRadius with IsDefend Missions
		},	
		 MarkerS = { --safehouse marker
		  Type     = 1,
		  Position = {x = 2378.29, y = 4505.14, z = 30.25 },  --{  x = 1944.96, y = 3150.6, z = 46.77}, 
		  Size     = {x = 2.0, y = 2.0, z = 2.0},
		  Color    = {r = 117, g = 218, b = 255},
		  DrawDistance = 200.0,
		},
		BlipSL = { --safehouse Vehicle blip 
		  Title = "Mission Vehicle Safehouse",
		  Position = {x = 2444.73, y = 4517.71, z = 35.85}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 421,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},
		BlipSB = { --safehouse boat blip 
		  Title = "Mission Boat Safehouse",
		  Position = { x = 2308.56, y = 4443.0, z = 28.8}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		 Icon     = 404,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},		
	

	
	Props = { 
		--**need a stub entry set for the random prop**
		{ id=1, Name="",Position = { x = 0, y = 0, z = 0, heading = 0 }},
	
    },
	
	Peds = {
		--**need a stub entry set for the random ped hostage for HostageRescue=true**
      {id = 1, Position = { x = 0, y = 0, z = 0, heading = 0 }},
     },
	 
	Vehicles = { 
		
	
    },	 
	

	Pickups = {
		
	},
	MissionPickups = {
		
		
	},
	
	RandomMissionPositions = { 
	
	{  x = 1318.13, y = 3624.67, z = 33.5,  MissionTitle="I'm On A Boat",
		Blip2 = { --safehouse blip
		  Title = "Mission Start",
		  Position = { x = 2317.1, y = 4543.08, z = 29.35}, -- x = 2365.07, y = 2958.56, z = 49.06 --{ x = 1944.96, y = 3150.6, z = 46.77}, --x = 1345.43, y = 3152.51, z = 40.41
		  Icon     = 58,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 1,
		  Alpha	 =80,

		  --Used for AddBlipForRadius with IsDefend Missions
		},
		Blip = { --safehouse blip
		  Title = "Destination",
		  Position = { x = -150.2, y = 4233.38, z = 29.52}, -- x = 2365.07, y = 2958.56, z = 49.06 --{ x = 1944.96, y = 3150.6, z = 46.77}, --x = 1345.43, y = 3152.51, z = 40.41
		  Icon     = 38,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 1,
		  Alpha	 =80,

		  --Used for AddBlipForRadius with IsDefend Missions
		},		
		
	DefendTargetInVehicle = true,
	DefendTargetVehicleIsBoat=true,

	}, 

	},
RandomMissionDestinations = { 

{ x = -150.2, y = 4233.38, z = 29.52, SpawnAt={x = 10.12, y = 4113.27, z = 31.62}}, --river's end Salton Sea
 

}


	
 },     
  
  
Mission27 = {
    
StartMessage = "Drive the asset and their vehicle~n~ to the destination~n~~r~Hurry!",
	FinishMessage = "Mission Completed!",
	MissionTitle = "The Gauntlet v2",
	MissionMessage = "New Mission",	
	
	--Obj/Ass values are the messages used depending on which random Type is selected Objective or Assassinate
	--The real messages (values above), will be set to the below, based on which Type
	StartMessageObj = "Capture the objective!",
	FinishMessageObj = "Mission Completed!",
	MissionTitleObj = "Takeover",
	MissionMessageObj = "Capture the objective!",	
	
	StartMessageAss = "Drive the asset and their vehicle~n~ to the destination~n~~r~Hurry!",
	FinishMessageAss = "Mission Completed!",
	MissionTitleAss = "The Gauntlet v2",
	MissionMessageAss = "Drive the asset and their vehicle~n~ to the destination",		
	Type = "Assassinate",	
	IsRandom = true,
	RandomMissionTypes ={"Assassinate"},
	IsDefend = true,
	IsDefendTarget = true,
	IsDefendTargetRescue = false,
	IsDefendTargetChase = true,
	IsVehicleDefendTargetChase = true,
	IsDefendTargetSetBlockingOfNonTemporaryEvents=true,
	--IsDefendTargetEnemySetBlockingOfNonTemporaryEvents=true,
	IsDefendTargetOnlyPlayersDamagePeds=false,
	IsVehicleDefendTargetGotoGoal=true,
	IsDefendTargetRewardBlip = true,
	GoalReachedReward = 5000,	
	TeleportToSafeHouseOnMissionStartNoVehicle = true,
	SafeHouseTimeTillNextUse=30000, --10 seconds
	--TeleportToSafeHouseOnMissionStartDelay=2000,
	SafeHousePedDoctors = {},
	SafeHousePedLeaders = {},
	SafeHouseProps = {"hei_prop_carrier_crate_01a"},
	SafeHouseGiveImmediately = true,
	
	--RandomMissionDoLandBattle=false, 
	TeleportToSafeHouseMinDistance = 30,
	--RemoveWeaponsAndUpgradesAtMissionStart = true,
	IsDefendTargetOnlyPlayersDamagePeds=true,
	--SpawnSafeHousePickups = {"WEAPON_COMBATPISTOL"},
	--SpawnSafeHouseComponents = {"COMPONENT_AT_PI_SUPP WEAPON_COMBATPISTOL","COMPONENT_COMBATPISTOL_CLIP_02 WEAPON_COMBATPISTOL"},
	SpawnSafeHouseComponents = {"COMPONENT_COMBATPISTOL_CLIP_02 WEAPON_COMBATPISTOL"},

	--SafeHouseCrackDownModeHealthAmount=200,
	--IsDefendTargetDrivetoBlip=true,
	--TeleportToSafeHouseOnMissionStart = false,
	RandomMissionSpawnRadius = 500.0, --keep a float for enemy ped wandering to work
	RandomMissionMaxPedSpawns = 15,
	RandomMissionMinPedSpawns = 5,
	RandomMissionMaxVehicleSpawns = 9,
	RandomMissionMinVehicleSpawns = 9,
	RandomMissionChanceToSpawnVehiclePerTry = 100,
	RandomMissionAircraftChance = 10,
	RandomMissionBossChance=20,
	--RandomMissionWeapons = {0xDD5DF8D9,0x99B507EA,0xCD274149,0x1B06D571},
	IsDefendTargetRandomPedWeapons = {0x1B06D571},
	UseSafeHouseLocations = false,
	IsDefendTargetPassenger=true,
	IsDefendTargetGoalDistance=50.0,
	--RandomMissionDoBoats = true,
	MissionTriggerRadius = 20.0,
	
	MissionTriggerStartPoint = { x = 1515.16, y = 3064.27, z = 41.3},
	
	
	SMS_Subject="The Gauntlet v2",
	SMS_Message="We need help to ensure that an asset and their vehicle make it to the destination",
	SMS_Message2="They will need a driver and escorts. Are you up for this?",
	--SMS_Message3="Anyone up for this?",	
		
	--SMS_ContactPics={"CHAR_STEVE",
	--},
	--SMS_ContactNames={"Agency Contact",
	--},
	SMS_NoFailedMessage=true,
	SMS_NoPassedMessage=true,
	SMS_FailedSubject="HAHA",
	SMS_FailedMessage="You should have stayed away, this is much bigger than you",
	SMS_PassedSubject="Thank you",
	SMS_PassedMessage="Los Santos is safe and sound from the attack",	
	
	
	
	--IsRandomSpawnAnywhere = true,
	
	--what x and y coordinate range should these mission spawn in?
	--RandomLocation = true, --for completely random location..

	
	Blip = {
      Title = "Objective",
      Position = { x = -10000, y = 0, z =  0},
      Icon     = 58,
      Display  = 4,
      Size     = 1.2,
      Color    = 1,
    },
	
	Blip2 = {
      Title = "Objective",
      Position = { x = -10000, y = 0, z =  0},
      Icon     = 58,
      Display  = 4,
      Size     = 1.2,
      Color    = 1,
    },

    Marker = {
      Type     = 1,
      Position = { x = -10000, y = 0, z = 0}, 
      Size     = {x = 6.0, y = 6.0, z = 2.0},
      Color    = {r = 100, g = 100, b = 204},
      DrawDistance = 500.0,
    },
		BlipS = { --safehouse blip
		  Title = "Mission Safehouse",
		  Position = {  x = 1532.73, y = 3093.11, z = 41.08}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 417,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 2,
		  Alpha	 =80, --Used for AddBlipForRadius with IsDefend Missions
		},	
		 MarkerS = { --safehouse marker
		  Type     = 1,
		  Position = { x = 1532.73, y = 3093.11, z = 40.08 },  --{  x = 1944.96, y = 3150.6, z = 46.77}, 
		  Size     = {x = 2.0, y = 2.0, z = 2.0},
		  Color    = {r = 117, g = 218, b = 255},
		  DrawDistance = 200.0,
		},
		BlipSL = { --safehouse Vehicle blip 
		  Title = "Mission Vehicle Safehouse",
		  Position = { x = 1480.63, y = 3167.93, z = 40.99}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 421,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},
		BlipSB = { --safehouse boat blip 
		  Title = "Mission Boat Safehouse",
		  Position = {x = 1481.84, y = 3873.37, z = 30.04}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		 Icon     = 404,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},		
	

	
	Props = { 
		--**need a stub entry set for the random prop**
		{ id=1, Name="",Position = { x = 0, y = 0, z = 0, heading = 0 }},
	
    },
	
	Peds = {
		--**need a stub entry set for the random ped hostage for HostageRescue=true**
      {id = 1, Position = { x = 0, y = 0, z = 0, heading = 0 }},
     },
	 
	Vehicles = { 
		
	
    },	 
	

	Pickups = {
		
	},
	MissionPickups = {
		
		
	},
	
	RandomMissionPositions = { 
	
	{  x = 1318.13, y = 3624.67, z = 33.5,  MissionTitle="The Gauntlet v2",
		Blip2 = { --safehouse blip
		  Title = "Mission Start",
		  Position = { x = 1515.16, y = 3064.27, z = 41.3}, -- x = 2365.07, y = 2958.56, z = 49.06 --{ x = 1944.96, y = 3150.6, z = 46.77}, --x = 1345.43, y = 3152.51, z = 40.41
		  Icon     = 58,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 1,
		  Alpha	 =80,

		  --Used for AddBlipForRadius with IsDefend Missions
		},
		Blip = { --safehouse blip
		  Title = "Destination",
		  Position = { x = 890.31, y = 3717.53, z = 29.66}, -- x = 2365.07, y = 2958.56, z = 49.06 --{ x = 1944.96, y = 3150.6, z = 46.77}, --x = 1345.43, y = 3152.51, z = 40.41
		  Icon     = 38,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 1,
		  Alpha	 =80,

		  --Used for AddBlipForRadius with IsDefend Missions
		},		
		
	DefendTargetInVehicle = true,
	--DefendTargetVehicleIsBoat=true,

	}, 

	},
RandomMissionDestinations = { 

{ x = -973.87, y = -273.67, z = 38.26, MissionTitle="Arcade"}, --cul de sac near studios
 
{ x = -1102.97, y = -424.98, z = 44.37, MissionTitle="News Studio" }, --news channel/studio building roof
{ x = -1223.9, y = -493.83, z = 31.51, MissionTitle="Back Alley" }, --news channel/studio in cul de sac

--{ x = 2840.52, y = -1449.96, z = 11.95, MissionTitle="The Island"}, --island

{ x = 1074.41, y = 3072.94, z = 40.82, MissionTitle="Desert Airstrip"}, --desert airstrip

--{x = -149.29, y = -960.51, z = 269.13, MissionTitle="High Rise"}, --construction tower

{ x = -1393.62, y = -2562.09, z = 13.95, MissionTitle="Airport" }, --airport

{ x = 137.07, y = -3204.05, z = 5.86,  MissionTitle="Docks" }, --walkers docks
{ x = -1828.32, y = -1218.22, z = 13.03, MissionTitle="The Pier" }, --pier

{ x = -547.74, y = -1477.3, z = 10.14, MissionTitle="Freeway Hideaway" }, --center greenery	

{ x = 1485.24, y = -2358.31, z = 72.44, MissionTitle="Oil Fields" }, --oilfields


{ x = 58.43, y = -1133.28, z = 29.34, MissionTitle="Street Smart"}, --los santos road
{ x = -808.9, y = -1302.95, z = 5.0, MissionTitle="Marina" }, --yacht club

{ x = 31.0, y = -767.1, z = 44.24, MissionTitle="Business District" }, --center los santos

{ x = 1874.74, y = 299.22, z = 162.82, MissionTitle="Resevoir" }, --resevoir

{ x = 1373.59, y = -739.58, z = 67.23, MissionTitle="Suburban Sprawl"}, --cul de sac

{ x = 1150.09, y = 124.3, z = 82.12, MissionTitle="Race Track"}, --race track

--'force = true' stops ray trace checking for spawn points for peds and vehicles, so peds/vehicles can spawn underneath structures... near the spawn location 
--this also means that peds/vehicles can spawn hidden in buildings, so this forces the mission type to be "Objective"
{ x = -177.69, y = -165.11, z = 44.03, MissionTitle="Concierge Service", force=true}, --hotel north los santos 

--{ x = -2237.38, y = 266.45, z = 174.62, MissionTitle="The Ritz" },
 --ritz hotel

{ x = -412.9, y = 1170.53, z = 325.84, MissionTitle="Observatory"}, --observatory

{ x = 756.1, y = 1284.89, z = 360.3, MissionTitle="Vinewood" }, --vinewood sign

{ x = -1907.85, y = 2037.05, z = 140.74, MissionTitle="Wine Country"}, --vineyard

{ x = -1833.24, y = 2152.89, z = 115.7, MissionTitle="Vinery"}, --vineyard 2

{ x = -2548.21, y = 2705.28, z = 2.84, MissionTitle="Secret Bunker" }, --outside base

{ x = -2405.68, y = 4253.63, z = 9.82, MissionTitle="Point Break"}, --nw beach

{ x = 57.0, y = 3717.01, z = 39.75, MissionTitle="Trailer Park"},--lost caravans
{ x = 1816.42, y = 3794.64, z = 33.65, MissionTitle="Dust Bowl"}, --south salton
{ x = 1313.35, y = 4327.67, z = 38.21, MissionTitle="Fish Monger" }, --north salton

--{ x = 3572.73, y = 3665.03, z = 33.89, MissionTitle="The Complex"}, --humane labs

{ x = 3803.26, y = 4462.52, z = 4.75, MissionTitle="Getaway" }, --north east coast

{ x = -1122.74, y = 4924.89, z = 218.67, MissionTitle="Compound"  }, --cult

{ x = -578.96, y = 5321.1, z = 70.21, MissionTitle="Sawmill" }, --sawmill

{ x = -31.49, y = 6441.9, z = 31.43, MissionTitle="Community Chest"  }, --parking lot uppoer NW

{ x = 28.76, y = 6216.7, z = 31.54, MissionTitle="Railyard"  }, --by railyard upper nw
{ x = 1429.43, y = 6517.94, z = 18.91, MissionTitle="Scenic Route"  }, --uppper coast


}


	
  },



Mission28 = {
    
StartMessage = "Fly the asset and their plane~n~ to the destination~n~~r~Hurry!",
	FinishMessage = "Mission Completed!",
	MissionTitle = "Top Gun v2",
	MissionMessage = "New Mission",	
	
	--Obj/Ass values are the messages used depending on which random Type is selected Objective or Assassinate
	--The real messages (values above), will be set to the below, based on which Type
	StartMessageObj = "Capture the objective!",
	FinishMessageObj = "Mission Completed!",
	MissionTitleObj = "Takeover",
	MissionMessageObj = "Capture the objective!",	
	
	StartMessageAss = "Fly the asset and their plane~n~ to the destination~n~~r~Hurry!",
	FinishMessageAss = "Mission Completed!",
	MissionTitleAss = "Top Gun v2",
	MissionMessageAss = "Fly the asset and their plane~n~ to the destination",		
	Type = "Assassinate",	
	IsRandom = true,
	RandomMissionTypes ={"Assassinate"},
	IsDefend = true,
	IsDefendTarget = true,
	IsDefendTargetRescue = false,
	IsDefendTargetChase = true,
	IsVehicleDefendTargetChase = true,
	IsDefendTargetSetBlockingOfNonTemporaryEvents=true,
	--IsDefendTargetEnemySetBlockingOfNonTemporaryEvents=true,
	IsDefendTargetOnlyPlayersDamagePeds=false,
	IsVehicleDefendTargetGotoGoal=true,
	IsDefendTargetRewardBlip = true,
	GoalReachedReward = 5000,	
	TeleportToSafeHouseOnMissionStartNoVehicle = true,
	SafeHouseTimeTillNextUse=30000, --10 seconds
	--TeleportToSafeHouseOnMissionStartDelay=2000,
	SafeHousePedDoctors = {},
	SafeHousePedLeaders = {},
	SafeHouseProps = {"hei_prop_carrier_crate_01a"},
	SafeHouseGiveImmediately = true,
	
	--RandomMissionDoLandBattle=false, 
	TeleportToSafeHouseMinDistance = 30,
	--RemoveWeaponsAndUpgradesAtMissionStart = true,
	IsDefendTargetOnlyPlayersDamagePeds=true,
	--SpawnSafeHousePickups = {"WEAPON_COMBATPISTOL"},
	--SpawnSafeHouseComponents = {"COMPONENT_AT_PI_SUPP WEAPON_COMBATPISTOL","COMPONENT_COMBATPISTOL_CLIP_02 WEAPON_COMBATPISTOL"},
	SpawnSafeHouseComponents = {"COMPONENT_COMBATPISTOL_CLIP_02 WEAPON_COMBATPISTOL"},

	SafeHouseCrackDownModeHealthAmount=200,
	--IsDefendTargetDrivetoBlip=true,
	--TeleportToSafeHouseOnMissionStart = false,
	RandomMissionSpawnRadius = 250.0, --keep a float for enemy ped wandering to work
	RandomMissionMaxPedSpawns = 15,
	RandomMissionMinPedSpawns = 5,
	RandomMissionMaxVehicleSpawns = 9,
	RandomMissionMinVehicleSpawns = 4,
	SafeHouseVehicleCount = 6,
	SafeHouseAircraftCount = 6,
	RandomMissionChanceToSpawnVehiclePerTry = 100,
	RandomMissionAircraftChance = 100,
	RandomMissionBossChance=20,
	--RandomMissionWeapons = {0xDD5DF8D9,0x99B507EA,0xCD274149,0x1B06D571},
	--IsDefendTargetRandomPedWeapons = {0x1B06D571},
	UseSafeHouseLocations = false,
	IsDefendTargetPassenger=true,
	IsDefendTargetGoalDistance=50.0,
	--RandomMissionDoBoats = true,
	MissionTriggerRadius = 20.0,
	MissionTriggerStartPoint = { x = 1515.16, y = 3064.27, z = 41.3},
   IsDefendTargetGoalDistance=50.0,
	IsDefendTargetRandomAircraft = {
	"pyro", "rogue","tula"
	},
	SafeHouseAircraft = 
	{
	"hydra",
	"lazer",
	"tula",
	"pyro",
	"rogue",

	},
	
	
	--IsRandomSpawnAnywhere = true,
	
	--what x and y coordinate range should these mission spawn in?
	--RandomLocation = true, --for completely random location..
	
	SMS_Subject="Top Gun v2",
	SMS_Message="We need help to ensure that an asset and their aircraft make it to the destination",
	SMS_Message2="They will need a pilot and escorts. Are you up for this?",
	--SMS_Message3="Anyone up for this?",	
		
	--SMS_ContactPics={"CHAR_STEVE",
	--},
	--SMS_ContactNames={"Agency Contact",
	--},
	SMS_NoFailedMessage=true,
	SMS_NoPassedMessage=true,
	SMS_FailedSubject="HAHA",
	SMS_FailedMessage="You should have stayed away, this is much bigger than you",
	SMS_PassedSubject="Thank you",
	SMS_PassedMessage="Los Santos is safe and sound from the attack",	

	
	Blip = {
      Title = "Objective",
      Position = { x = -10000, y = 0, z =  0},
      Icon     = 58,
      Display  = 4,
      Size     = 1.2,
      Color    = 1,
    },
	
	Blip2 = {
      Title = "Objective",
      Position = { x = -10000, y = 0, z =  0},
      Icon     = 58,
      Display  = 4,
      Size     = 1.2,
      Color    = 1,
    },

    Marker = {
      Type     = 1,
      Position = { x = -10000, y = 0, z = 0}, 
      Size     = {x = 6.0, y = 6.0, z = 2.0},
      Color    = {r = 100, g = 100, b = 204},
      DrawDistance = 500.0,
    },
		BlipS = { --safehouse blip
		  Title = "Mission Safehouse",
		  Position = {  x = 1532.73, y = 3093.11, z = 41.08}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 417,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 2,
		  Alpha	 =80, --Used for AddBlipForRadius with IsDefend Missions
		},	
		 MarkerS = { --safehouse marker
		  Type     = 1,
		  Position = { x = 1532.73, y = 3093.11, z = 40.08 },  --{  x = 1944.96, y = 3150.6, z = 46.77}, 
		  Size     = {x = 2.0, y = 2.0, z = 2.0},
		  Color    = {r = 117, g = 218, b = 255},
		  DrawDistance = 200.0,
		},
		BlipSL = { --safehouse Vehicle blip 
		  Title = "Mission Vehicle Safehouse",
		  Position = { x = 1480.63, y = 3167.93, z = 40.99}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 421,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},
		BlipSB = { --safehouse boat blip 
		  Title = "Mission Boat Safehouse",
		  Position = {x = 1481.84, y = 3873.37, z = 30.04}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		 Icon     = 404,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},		
	

	
	Props = { 
		--**need a stub entry set for the random prop**
		{ id=1, Name="",Position = { x = 0, y = 0, z = 0, heading = 0 }},
	
    },
	
	Peds = {
		--**need a stub entry set for the random ped hostage for HostageRescue=true**
      {id = 1, Position = { x = 0, y = 0, z = 0, heading = 0 }},
     },
	 
	Vehicles = { 
		
	
    },	 
	

	Pickups = {
		
	},
	MissionPickups = {
		
		
	},
	
	RandomMissionPositions = { 
	
	{  x = 1318.13, y = 3624.67, z = 33.5,  MissionTitle="Top Gun v2",
		Blip2 = { --safehouse blip
		  Title = "Mission Start",
		  Position = { x = 1515.16, y = 3064.27, z = 41.3}, -- x = 2365.07, y = 2958.56, z = 49.06 --{ x = 1944.96, y = 3150.6, z = 46.77}, --x = 1345.43, y = 3152.51, z = 40.41
		  Icon     = 58,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 1,
		  Alpha	 =80,

		  --Used for AddBlipForRadius with IsDefend Missions
		},
		Blip = { --safehouse blip
		  Title = "Destination",
		  Position = { x = 890.31, y = 3717.53, z = 29.66}, -- x = 2365.07, y = 2958.56, z = 49.06 --{ x = 1944.96, y = 3150.6, z = 46.77}, --x = 1345.43, y = 3152.51, z = 40.41
		  Icon     = 38,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 1,
		  Alpha	 =80,

		  --Used for AddBlipForRadius with IsDefend Missions
		},		
		
	DefendTargetInVehicle = true,
	DefendTargetVehicleIsAircraft=true,

	}, 

	},
RandomMissionDestinations = { 

{ x = -973.87, y = -273.67, z = 38.26, MissionTitle="Arcade"}, --cul de sac near studios
 
{ x = -1102.97, y = -424.98, z = 44.37, MissionTitle="News Studio" }, --news channel/studio building roof
{ x = -1223.9, y = -493.83, z = 31.51, MissionTitle="Back Alley" }, --news channel/studio in cul de sac

{ x = 2840.52, y = -1449.96, z = 11.95, MissionTitle="The Island"}, --island

{ x = 1074.41, y = 3072.94, z = 40.82, MissionTitle="Desert Airstrip"}, --desert airstrip

--{x = -149.29, y = -960.51, z = 269.13, MissionTitle="High Rise"}, --construction tower

{ x = -1393.62, y = -2562.09, z = 13.95, MissionTitle="Airport" }, --airport

{ x = 137.07, y = -3204.05, z = 5.86,  MissionTitle="Docks" }, --walkers docks
{ x = -1828.32, y = -1218.22, z = 13.03, MissionTitle="The Pier" }, --pier

{ x = -547.74, y = -1477.3, z = 10.14, MissionTitle="Freeway Hideaway" }, --center greenery	

{ x = 1485.24, y = -2358.31, z = 72.44, MissionTitle="Oil Fields" }, --oilfields


{ x = 58.43, y = -1133.28, z = 29.34, MissionTitle="Street Smart"}, --los santos road
{ x = -808.9, y = -1302.95, z = 5.0, MissionTitle="Marina" }, --yacht club

{ x = 31.0, y = -767.1, z = 44.24, MissionTitle="Business District" }, --center los santos

{ x = 1874.74, y = 299.22, z = 162.82, MissionTitle="Resevoir" }, --resevoir

{ x = 1373.59, y = -739.58, z = 67.23, MissionTitle="Suburban Sprawl"}, --cul de sac

{ x = 1150.09, y = 124.3, z = 82.12, MissionTitle="Race Track"}, --race track

--'force = true' stops ray trace checking for spawn points for peds and vehicles, so peds/vehicles can spawn underneath structures... near the spawn location 
--this also means that peds/vehicles can spawn hidden in buildings, so this forces the mission type to be "Objective"
--{ x = -177.69, y = -165.11, z = 44.03, MissionTitle="Concierge Service", force=true}, --hotel north los santos 

{ x = -2237.38, y = 266.45, z = 174.62, MissionTitle="The Ritz" },
 --ritz hotel

{ x = -412.9, y = 1170.53, z = 325.84, MissionTitle="Observatory"}, --observatory

{ x = 756.1, y = 1284.89, z = 360.3, MissionTitle="Vinewood" }, --vinewood sign

{ x = -1907.85, y = 2037.05, z = 140.74, MissionTitle="Wine Country"}, --vineyard

{ x = -1833.24, y = 2152.89, z = 115.7, MissionTitle="Vinery"}, --vineyard 2

{ x = -2548.21, y = 2705.28, z = 2.84, MissionTitle="Secret Bunker" }, --outside base

{ x = -2405.68, y = 4253.63, z = 9.82, MissionTitle="Point Break"}, --nw beach

{ x = 57.0, y = 3717.01, z = 39.75, MissionTitle="Trailer Park"},--lost caravans
{ x = 1816.42, y = 3794.64, z = 33.65, MissionTitle="Dust Bowl"}, --south salton
{ x = 1313.35, y = 4327.67, z = 38.21, MissionTitle="Fish Monger" }, --north salton

{ x = 3572.73, y = 3665.03, z = 33.89, MissionTitle="The Complex"}, --humane labs

{ x = 3803.26, y = 4462.52, z = 4.75, MissionTitle="Getaway" }, --north east coast

{ x = -1122.74, y = 4924.89, z = 218.67, MissionTitle="Compound"  }, --cult

{ x = -578.96, y = 5321.1, z = 70.21, MissionTitle="Sawmill" }, --sawmill

{ x = -31.49, y = 6441.9, z = 31.43, MissionTitle="Community Chest"  }, --parking lot uppoer NW

{ x = 28.76, y = 6216.7, z = 31.54, MissionTitle="Railyard"  }, --by railyard upper nw
{ x = 1429.43, y = 6517.94, z = 18.91, MissionTitle="Scenic Route"  }, --uppper coast


}


	
 },


Mission29 = {
    
StartMessage = "Drive the asset and their boat~n~ to the destination~n~~r~Hurry!",
	FinishMessage = "Mission Completed!",
	MissionTitle = "I'm On A Boat v2",
	MissionMessage = "New Mission",	
	
	--Obj/Ass values are the messages used depending on which random Type is selected Objective or Assassinate
	--The real messages (values above), will be set to the below, based on which Type
	StartMessageObj = "Capture the objective!",
	FinishMessageObj = "Mission Completed!",
	MissionTitleObj = "Takeover",
	MissionMessageObj = "Capture the objective!",	
	
	StartMessageAss = "Drive the asset and their boat~n~ to the destination~n~~r~Hurry!",
	FinishMessageAss = "Mission Completed!",
	MissionTitleAss = "I'm On A Boat",
	MissionMessageAss = "Drive the asset and their boat~n~ to the destination",		
	Type = "Assassinate",	
	IsRandom = true,
	RandomMissionTypes ={"Assassinate"},
	IsDefend = true,
	IsDefendTarget = true,
	IsDefendTargetRescue = false,
	IsDefendTargetChase = true,
	IsVehicleDefendTargetChase = true,
	IsDefendTargetSetBlockingOfNonTemporaryEvents=true,
	--IsDefendTargetEnemySetBlockingOfNonTemporaryEvents=true,
	IsDefendTargetOnlyPlayersDamagePeds=false,
	IsVehicleDefendTargetGotoGoal=true,
	IsDefendTargetRewardBlip = true,
	GoalReachedReward = 5000,	
	TeleportToSafeHouseOnMissionStartNoVehicle = true,
	SafeHouseTimeTillNextUse=30000, --10 seconds
	--TeleportToSafeHouseOnMissionStartDelay=2000,
	SafeHousePedDoctors = {},
	SafeHousePedLeaders = {},
	SafeHouseProps = {"hei_prop_carrier_crate_01a"},
	SafeHouseGiveImmediately = true,
	
	--RandomMissionDoLandBattle=false, 
	TeleportToSafeHouseMinDistance = 30,
	--RemoveWeaponsAndUpgradesAtMissionStart = true,
	IsDefendTargetOnlyPlayersDamagePeds=true,
	--SpawnSafeHousePickups = {"WEAPON_COMBATPISTOL"},
	--SpawnSafeHouseComponents = {"COMPONENT_AT_PI_SUPP WEAPON_COMBATPISTOL","COMPONENT_COMBATPISTOL_CLIP_02 WEAPON_COMBATPISTOL"},
	SpawnSafeHouseComponents = {"COMPONENT_COMBATPISTOL_CLIP_02 WEAPON_COMBATPISTOL"},

	SafeHouseCrackDownModeHealthAmount=200,
	--IsDefendTargetDrivetoBlip=true,
	--TeleportToSafeHouseOnMissionStart = false,
	RandomMissionSpawnRadius = 150.0, --keep a float for enemy ped wandering to work
	RandomMissionMaxPedSpawns = 15,
	RandomMissionMinPedSpawns = 5,
	RandomMissionMaxVehicleSpawns = 9,
	RandomMissionMinVehicleSpawns = 6,
	SafeHouseVehicleCount = 6,
	SafeHouseAircraftCount = 2,
	SafeHouseBoatCount = 6,
	RandomMissionChanceToSpawnVehiclePerTry = 100,
	RandomMissionAircraftChance = 10,
	RandomMissionBossChance=20,
	--RandomMissionWeapons = {0xDD5DF8D9,0x99B507EA,0xCD274149,0x1B06D571},
	--IsDefendTargetRandomPedWeapons = {0x1B06D571},
	UseSafeHouseLocations = false,
	IsDefendTargetPassenger=true,
	IsDefendTargetGoalDistance=50.0,
	RandomMissionDoBoats = true,
	MissionTriggerRadius = 30.0,
	MissionTriggerStartPoint = { x = 2378.29, y = 4505.14, z = 31.25},
   IsDefendTargetGoalDistance=30.0,

	
	--IsRandomSpawnAnywhere = true,
	
	--what x and y coordinate range should these mission spawn in?
	--RandomLocation = true, --for completely random location..
	
	SMS_Subject="Adrift v2",
	SMS_Message="We need help to ensure that an asset and their boat make it to the destination",
	SMS_Message2="They will need a driver and escorts. Are you up for this?",
	--SMS_Message3="Anyone up for this?",	
		
	--SMS_ContactPics={"CHAR_STEVE",
	--},
	--SMS_ContactNames={"Agency Contact",
	--},
	SMS_NoFailedMessage=true,
	SMS_NoPassedMessage=true,
	SMS_FailedSubject="HAHA",
	SMS_FailedMessage="You should have stayed away, this is much bigger than you",
	SMS_PassedSubject="Thank you",
	SMS_PassedMessage="Los Santos is safe and sound from the attack",		
	
	
		Events = {
		--**need a stub entry set for the random default event**
		--add custom events for mission with id=1 onwards
      {id = 1, 
		Position = { x = 50000.0, y = 50000.0, z = 50000.0, heading = 0 },
	  	  Size     = {radius=1000.0},
		  SpawnHeight = 200.0,
		  FacePlayer = true,
		  --NumberPeds=1,
		  isBoss=false,
		  Target=false,
		  SquadSpawnRadius=25.0,
		  
	  
	  },
    {id = 2, 
		Position = {x = 1264.24, y = 4039.11, z = 29.91, heading = 159.45  },
	  	  Type="Boat",
		  Size     = {radius=4000.0},
		  SpawnHeight = 200.0,
		  FacePlayer = true,
		  Vehicle="dinghy3",
		  modelHash="a_m_y_breakdance_01",
		  DoIsDefendBehavior=true,
		  DoBlockingOfNonTemporaryEvents=true,
		  --NumberPeds=1,
		  isBoss=false,
		  Target=true,
		  SquadSpawnRadius=25.0,
		  
	  
	  },	  
	  
     },	

	
	Blip = {
      Title = "Objective",
      Position = { x = -10000, y = 0, z =  0},
      Icon     = 58,
      Display  = 4,
      Size     = 1.2,
      Color    = 1,
    },
	
	Blip2 = {
      Title = "Objective",
      Position = { x = -10000, y = 0, z =  0},
      Icon     = 58,
      Display  = 4,
      Size     = 1.2,
      Color    = 1,
    },

    Marker = {
      Type     = 1,
      Position = { x = -10000, y = 0, z = 0}, 
      Size     = {x = 6.0, y = 6.0, z = 2.0},
      Color    = {r = 100, g = 100, b = 204},
      DrawDistance = 500.0,
    },
		BlipS = { --safehouse blip
		  Title = "Mission Safehouse",
		  Position = { x = 2378.29, y = 4505.14, z = 31.25}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 417,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 2,
		  Alpha	 =80, --Used for AddBlipForRadius with IsDefend Missions
		},	
		 MarkerS = { --safehouse marker
		  Type     = 1,
		  Position = {x = 2378.29, y = 4505.14, z = 30.25 },  --{  x = 1944.96, y = 3150.6, z = 46.77}, 
		  Size     = {x = 2.0, y = 2.0, z = 2.0},
		  Color    = {r = 117, g = 218, b = 255},
		  DrawDistance = 200.0,
		},
		BlipSL = { --safehouse Vehicle blip 
		  Title = "Mission Vehicle Safehouse",
		  Position = {x = 2444.73, y = 4517.71, z = 35.85}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 421,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},
		BlipSB = { --safehouse boat blip 
		  Title = "Mission Boat Safehouse",
		  Position = { x = 2308.56, y = 4443.0, z = 28.8}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		 Icon     = 404,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},		
	

	
	Props = { 
		--**need a stub entry set for the random prop**
		{ id=1, Name="",Position = { x = 0, y = 0, z = 0, heading = 0 }},
	
    },
	
	Peds = {
		--**need a stub entry set for the random ped hostage for HostageRescue=true**
      {id = 1, Position = { x = 0, y = 0, z = 0, heading = 0 }},
     },
	 
	Vehicles = { 
		
	
    },	 
	

	Pickups = {
		
	},
	MissionPickups = {
		
		
	},
	
	RandomMissionPositions = { 
	
	{  x = 1318.13, y = 3624.67, z = 33.5,  MissionTitle="I'm On A Boat v2",
		Blip2 = { --safehouse blip
		  Title = "Mission Start",
		  Position = { x = 2317.1, y = 4543.08, z = 29.35}, -- x = 2365.07, y = 2958.56, z = 49.06 --{ x = 1944.96, y = 3150.6, z = 46.77}, --x = 1345.43, y = 3152.51, z = 40.41
		  Icon     = 58,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 1,
		  Alpha	 =80,

		  --Used for AddBlipForRadius with IsDefend Missions
		},
		Blip = { --safehouse blip
		  Title = "Destination",
		  Position = { x = -150.2, y = 4233.38, z = 29.52}, -- x = 2365.07, y = 2958.56, z = 49.06 --{ x = 1944.96, y = 3150.6, z = 46.77}, --x = 1345.43, y = 3152.51, z = 40.41
		  Icon     = 38,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 1,
		  Alpha	 =80,

		  --Used for AddBlipForRadius with IsDefend Missions
		},		
		
	DefendTargetInVehicle = true,
	DefendTargetVehicleIsBoat=true,

	}, 

	},
RandomMissionDestinations = { 

{ x = -150.2, y = 4233.38, z = 29.52, SpawnAt={x = 10.12, y = 4113.27, z = 31.62}}, --river's end Salton Sea
 

}


	
 },

 Mission30 = {
    
	StartMessage = "Stop the mercs from stealing~n~bio nanotechnology to sell on the black market",
	FinishMessage = "Mission Completed!",
	MissionTitle = "Killing Floor",
	MissionMessage = "Stop the mercs from stealing bio nanotechnology to sell on the black market",	
	Type = "ObjectiveRescue",	
	ObjectiveRescueShortRangeBlip = true,
	IndoorsMission = true,
	SafeHouseVehicleCount = 6,
	SafeHouseAircraftCount = 4,
	SafeHouseBoatCount = 3,
	SafeHouseSniperExplosiveRoundsGiven=0,
	MissionTriggerRadius = 1000.0,
	SafeHouseVehicles = {
	"kuruma2",
	"insurgent3",
	},
	SafeHouseAircraft = 
	{
	"hydra",
	"havok",
	"thruster",

	},
	
	SMS_Subject="Killing Floor",
	SMS_Message="Mercenaries have infiltrated Humane Labs to steal bio nanotechnology to sell on the black market",
	SMS_Message2="We need someone to stop them. Can you help us?",
	--SMS_Message3="Anyone up for this?",	
		
	SMS_ContactPics={"CHAR_STEVE",
	},
	SMS_ContactNames={"Agency Contact",
	},
	SMS_NoFailedMessage=true,
	--SMS_NoPassedMessage=true,
	SMS_FailedSubject="HAHA",
	SMS_FailedMessage="You should have stayed away, this is much bigger than you",
	SMS_PassedSubject="Thank you",
	SMS_PassedMessage="Los Santos is safer now",		

    Blip = {
      Title = "Mission: Humane Labs Entrance",
      Position = { x = 3623.61, y = 3754.3, z =  28.52},
      Icon     = 58,
      Display  = 4,
      Size     = 1.2,
      Color    = 1,
    },

    Marker = {
      Type     = 1,
      Position = { x = 3524.76, y = 3707.86, z = 19.99}, 
      Size     = {x = 6.0, y = 6.0, z = 2.0},
      Color    = {r = 100, g = 100, b = 204},
      DrawDistance = 100.0,
    },
	BlipS = { --safehouse blip 
		  Title = "Mission Safehouse",
		  Position = { x = 1731.94, y = 3308.24, z = 41.22}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 417,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 2,
		  Alpha	 =80, 
	},	
	MarkerS = { --safehouse marker
		  Type     = 1,
		  Position = { x = 1731.94, y = 3308.24, z = 40.22},  --{  x = 1944.96, y = 3150.6, z = 46.77}, 
		  Size     = {x = 6.0, y = 6.0, z = 2.0},
		  Color    = {r = 117, g = 218, b = 255},
		  DrawDistance = 200.0,
	},
	BlipSL = { --safehouse Vehicle blip 
		  Title = "Mission Vehicle Safehouse",
		  Position = { x = 1480.63, y = 3167.93, z = 40.99}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 421,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
	},
	BlipSB = { --safehouse boat blip 
		  Title = "Mission Boat Safehouse",
		  Position = {x = 1481.84, y = 3873.37, z = 30.04}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		 Icon     = 404,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
	},	
	
	--***Must Set 'realId' too, which must is always the same as 'id' for props to not float***
	Props = {
		{ id=1,  Name = "prop_barrel_exp_01a", Position = { x = 3614.75, y = 3747.91, z = 28.69, heading = 122.62 }},
		{ id=2,  Name = "prop_barrel_exp_01b", Position = { x = 3609.18, y = 3740.13, z = 28.69, heading = 164.03 }},
		{ id=3,  Name = "prop_barrel_exp_01c", Position = { x = 3615.09, y = 3734.99, z = 28.69, heading = 194.87 }},
		{ id=4,  Name = "prop_barrel_exp_01a", Position = { x = 3614.75, y = 3726.15, z = 28.69, heading = 155.23 }},
		
		{ id=5,  Name = "prop_barrel_exp_01b", Position = { x = 3605.65, y = 3729.52, z = 29.69, heading = 160.13 }},
		{ id=6,  Name = "prop_barrel_exp_01c", Position = { x = 3601.47, y = 3706.07, z = 29.69, heading = 326.51 }},
		{ id=7,  Name = "prop_barrel_exp_01a", Position = { x = 3599.05, y = 3717.99, z = 29.69, heading = -24.46 }},
		{ id=8,  Name = "prop_barrel_exp_01b", Position = { x = 3592.93, y = 3705.9, z = 29.69, heading = 237.64 }},
		
		{ id=9,  Name = "prop_barrel_exp_01c", Position = { x = 3593.42, y = 3690.41, z = 28.82, heading = 243.09 }},
		{ id=10,  Name = "prop_barrel_exp_01a", Position = { x = 3603.79, y = 3687.89, z = 28.82, heading = 150.95 }},
		{ id=11,  Name = "prop_barrel_exp_01b", Position = { x = 3569.03, y = 3700.77, z = 28.12, heading = -37.27 }},
		{ id=12,  Name = "prop_barrel_exp_01c", Position = { x = 3566.83, y = 3702.27, z = 28.12, heading = 170.67 }},

		{ id=13,  Name = "prop_barrel_exp_01a", Position = { x = 3561.57, y = 3665.82, z = 28.12, heading = 70.78 }},
		{ id=14,  Name = "prop_barrel_exp_01b", Position = { x = 3541.91, y = 3641.82, z = 28.12, heading = 394.39 }},
		{ id=15,  Name = "prop_barrel_exp_01c", Position = { x = 3535.68, y = 3666.66, z = 28.12, heading = 106.65 }},
		{ id=16,  Name = "prop_barrel_exp_01a", Position = { x = 3519.75, y = 3673.39, z = 20.99, heading = 346.55 }},
		{ id=17,  Name = "prop_barrel_exp_01b", Position = { x = 3527.08, y = 3693.7, z = 20.99, heading = 228.84 }},
		{ id=18,  Name = "prop_barrel_exp_01c", Position = { x = 3526.85, y = 3710.68, z = 20.99, heading = 235.64 }},
		{ id=19,  Name = "prop_barrel_exp_01a", Position = { x = 3521.7, y = 3712.3, z = 20.99, heading = 56.34 }},
		{ id=20,  Name = "v_ilev_body_parts", Position = { x = 3527.89, y = 3697.44, z = 20.99, heading = 104.79 }},
		{ id=21,  Name = "xm_prop_x17_corpse_03", Position = { x = 3551.93, y = 3662.89, z = 28.12, heading = 30.7 }},
		{ id=22,  Name = "v_ilev_body_parts", Position = { x = 3597.09, y = 3727.58, z = 29.69, heading = 106.46 }},

		{ id=23,  Name = "v_ilev_body_parts", Position = { x = 3522.95, y = 3707.81, z = 20.99, heading = 121.43  }},
		{ id=24,  Name = "v_ilev_body_parts", Position = { x = 3588.04, y = 3682.53, z = 27.62, heading = 99.84 }},
		{ id=25,  Name = "xm_prop_x17_corpse_03", Position = { x = 3594.12, y = 3714.44, z = 29.69, heading = 233.54 }},
		{ id=26,  Name = "v_ilev_body_parts", Position = { x = 3613.47, y = 3723.51, z = 29.69, heading = 414.03 }},
		{ id=27,  Name = "prop_barrel_exp_01a", Position = {x = 3617.64, y = 3728.41, z = 28.69, heading = 357.21 }},
		{ id=28,  Name = "ba_prop_battle_crate_m_hazard", isObjective=true, Position = {x = 3524.76, y = 3707.86, z = 20.99, heading = 172.28 }},
		{ id=29,  Name = "prop_barrel_exp_01a", Position = {x = 3617.64, y = 3728.41, z = 28.69, heading = 357.21 }},
		{ id=30,  Name = "xm_prop_x17_labvats", isObjective=true, Position = {x = 3607.51, y = 3719.96, z = 29.69, heading = 54.77}},
		{ id=31,  Name = "xm_prop_x17_ld_case_01", isObjective=true, Position = {x = 3559.45, y = 3675.06, z = 28.12, heading = 80.54 }},
		{ id=32,  Name = "xm_prop_x17_lap_top_01", isObjective=true, Position = {x = 3540.69, y = 3664.04, z = 28.12, heading = 233.06 }},
	
    },
	Pickups = {
	},
	MissionPickups = {
		
	},	
		
	

    Peds = {
	
		{id = 1,  Weapon = 0x05FC3C11,  modelHash = "S_M_M_ChemSec_01",  x = 3526.19, y = 3710.34, z = 20.99, heading = 3.53, dead=true},
		{id = 2,  Weapon = 0x05FC3C11,  modelHash = "S_M_M_ChemSec_01",   x = 3530.37, y = 3704.78, z = 20.99, heading = 267.28,dead=true},
		{id = 3,   modelHash = "g_m_m_chemwork_01",  x = 3526.79, y = 3673.34, z = 28.12, heading = 54.53 ,dead=true },
		{id = 4,   modelHash = "s_m_m_scientist_01",  x = 3539.46, y = 3664.12, z = 28.12, heading = 343.71, dead=true},
		{id = 5,   modelHash = "s_m_m_scientist_01",  x = 3563.64, y = 3688.87, z = 28.12, heading = 16.29,dead=true},
		{id = 6,  Weapon = 0xBFEFFF6D,  modelHash = "S_M_M_ChemSec_01",   x = 3620.66, y = 3731.14, z = 28.69, heading = 298.3,dead=true },
		{id = 7, modelHash = "a_c_chimp",    x = 3607.87, y = 3745.12, z = 28.69, heading = 264.35, wander=true,friendly=true},
		{id = 8, Weapon = 0xBFEFFF6D,  modelHash = "s_m_y_robber_01",    x = 3612.36, y = 3742.82, z = 28.69, heading = 316.25  ,},
		{id = 9,  modelHash = "u_m_y_juggernaut_01", isBoss=true,   x = 3620.38, y = 3743.84, z = 28.69, heading = 138.39 },
		--{id = 10, Weapon = 0xBFEFFF6D,  modelHash = "g_m_y_lost_01",  x = 3622.78, y = 3744.73, z = 28.69, heading = 143.37  ,},
		{id = 10, Weapon =0x7846A318,  modelHash = "s_m_y_xmech_02",    x = 3623.65, y = 3741.76, z = 28.69, heading = 318.45  },
		{id = 11,Weapon = 0xBFEFFF6D,   modelHash = "g_m_y_lost_02",     x = 3625.98, y = 3736.97, z = 28.69, heading = 72.05  ,},
		--{id = 13, Weapon =0xE284C527,  modelHash = "U_M_Y_Tattoo_01",    x = 3617.07, y = 3736.34, z = 28.69, heading = 4.08 },
		{id = 12,  Weapon = 0xDBBD7280,  modelHash = "s_m_y_dealer_01",     x = 3621.54, y = 3732.85, z = 28.69, heading = 389.56  ,},
		
		{id = 13, Weapon =0xEFE7E2DF,  modelHash = "mp_m_exarmy_01",    x = 3610.95, y = 3742.67, z = 28.69, heading = 259.69 },
		{id = 14,  Weapon = 0xBFEFFF6D, modelHash = "g_m_y_lost_03",    x = 3610.96, y = 3734.39, z = 28.69, heading = 316.39  ,},
		
		{id = 15, Weapon =0x83BF0278,  modelHash = "ig_josef",    x = 3615.56, y = 3729.56, z = 28.69, heading = 313.9  },
		--{id =18,   Weapon =0x83BF0278, modelHash = "u_f_y_bikerchic",     x = 3608.35, y = 3730.52, z = 29.69, heading = 328.71 ,},
		
		{id = 16,  Weapon =0x83BF0278, modelHash = "ig_Cletus",     x = 3612.11, y = 3724.65, z = 29.69, heading = 291.04 },
		{id = 17,   Weapon = 0xBFEFFF6D,  modelHash = "g_f_y_lost_01",    x = 3608.14, y = 3721.37, z = 29.69, heading = 313.19  ,},
		
		{id = 18, Weapon =0xE284C527,  modelHash = "G_M_M_ChiCold_01",     x = 3603.05, y = 3707.52, z = 29.69, heading = 312.44  },
		--{id = 22,  Weapon =0x83BF0278, modelHash = "s_m_y_xmech_02_mp",    x = 3607.35, y = 3709.07, z = 29.69, heading = 313.05  ,},
		
		{id = 19, Weapon =0xEFE7E2DF,  modelHash = "ig_terry",    x = 3596.54, y = 3702.11, z = 29.69, heading = 333.55 },
		{id = 20, Weapon = 0xDBBD7280,  modelHash = "ig_clay",   x = 3597.34, y = 3709.02, z = 29.69, heading = 213.63  ,},
		
		{id = 21,  Weapon =0x83BF0278, modelHash = "mp_m_weapexp_01",    x = 3602.85, y = 3720.5, z = 29.69, heading = 127.06  },
		--{id = 26,  Weapon =0x83BF0278, modelHash = "mp_m_weapexp_01",      x = 3605.29, y = 3722.86, z = 29.69, heading = 117.92  ,},
		
		{id = 22,  Weapon =0x7846A318, modelHash = "s_m_y_xmech_02",     x = 3597.49, y = 3728.78, z = 29.69, heading = 185.09  },
		{id = 23,  Weapon =0x7846A318, modelHash = "U_M_Y_Tattoo_01",    x = 3599.14, y = 3721.5, z = 29.69, heading = 366.78  ,},
		
		{id = 24, Weapon =0x83BF0278,  modelHash = "u_f_y_bikerchic",    x = 3592.46, y = 3717.54, z = 29.69, heading = 319.06  },
		--{id = 30, Weapon =0x7846A318, modelHash = "csb_jackhowitzer",    x = 3594.58, y = 3705.83, z = 29.69, heading = 37.51  ,},
		
		{id = 25, Weapon =0x83BF0278,  modelHash = "U_M_Y_Tattoo_01",     x = 3583.5, y = 3700.23, z = 28.82, heading = 254.28  },
		--{id = 32,  Weapon = 0xBFEFFF6D,  modelHash = "G_M_M_ChiCold_01",     x = 3590.45, y = 3694.82, z = 28.82, heading = 56.95  ,},
		{id = 26, Weapon =0xE284C527,  modelHash = "s_m_y_dealer_01",    x = 3594.69, y = 3696.06, z = 28.82, heading = 152.86  , wander=true,},
		
		--{id = 34,  Weapon =0xE284C527,  modelHash = "s_m_y_dealer_01",     x = 3595.62, y = 3691.26, z = 28.82, heading = 48.78  ,},
		
		{id = 27, Weapon =0xEFE7E2DF,  modelHash = "G_M_M_ChiCold_01",    x = 3604.55, y = 3689.28, z = 28.82, heading = 83.36  , wander=true,},
		{id = 28,  Weapon = 0xBFEFFF6D,  modelHash = "g_m_y_lost_01",     x = 3600.31, y = 3691.59, z = 28.82, heading = 193.99  ,},
		--{id = 37,  Weapon =0x83BF0278, modelHash = "G_M_M_ChiCold_01",    x = 3592.17, y = 3681.08, z = 27.62, heading = 330.71  , wander=true},
		{id = 29,  Weapon = 0xBFEFFF6D,  modelHash = "g_m_y_lost_02",   x = 3595.62, y = 3684.42, z = 27.62, heading = 351.13  ,},
		--{id = 39, Weapon =0xE284C527,  modelHash = "s_m_y_robber_01",    x = 3586.29, y = 3683.54, z = 27.62, heading = 236.35  , wander=true,},
		{id = 30, Weapon = 0xBFEFFF6D,  modelHash = "g_m_y_lost_03",     x = 3585.98, y = 3691.95, z = 27.12, heading = 90.01  ,},
		--{id = 41, Weapon =0xE284C527,  modelHash = "G_M_M_ChiCold_01",    x = 3577.21, y = 3691.32, z = 27.12, heading = 278.91  , wander=true,},
		{id = 31, Weapon = 0xBFEFFF6D,  modelHash = "s_m_y_ammucity_01",   x = 3568.48, y = 3701.5, z = 28.12, heading = 155.69  ,},
		
		--{id = 43,  Weapon =0x83BF0278, modelHash = "s_m_y_xmech_02",    x = 3566.67, y = 3699.71, z = 28.12, heading = 183.55  , wander=true,},
		{id = 32,  Weapon = 0x0781FE4A, modelHash = "s_m_y_xmech_02_mp",    x = 3560.11, y = 3695.33, z = 30.12, heading = 252.14  ,},
		
		{id = 33, Weapon =0x83BF0278,  modelHash = "U_M_Y_Tattoo_01",    x = 3568.26, y = 3690.12, z = 28.12, heading = 34.65  , wander=true,},
		{id = 34,  Weapon =0xDBBD7280,  modelHash = "s_m_y_ammucity_01",    x = 3562.11, y = 3690.99, z = 28.12, heading = 231.7  ,},
		--{id = 47, Weapon =0x7846A318,  modelHash = "s_m_y_ammucity_01",    x = 3558.75, y = 3683.78, z = 28.12, heading = 208.97  , wander=true,},
		{id = 35, Weapon = 0xBFEFFF6D,  modelHash = "g_f_y_lost_01",    x = 3562.24, y = 3672.44, z = 28.12, heading = 155.5  ,},
		{id = 36, Weapon =0xEFE7E2DF,  modelHash = "u_f_y_bikerchic",    x = 3554.45, y = 3670.03, z = 28.12, heading = 371.73  , wander=true,},
		--{id = 50, Weapon = 0xBFEFFF6D,  modelHash = "g_f_y_lost_01",   x = 3550.43, y = 3660.96, z = 28.12, heading = 267.42  ,},
		
		{id = 37,Weapon =0xE284C527,   modelHash = "s_m_y_xmech_02",    x = 3553.06, y = 3656.39, z = 28.12, heading = 87.65  , wander=true,},
		{id = 38, Weapon =0x83BF0278, modelHash = "s_m_y_xmech_02_mp",   x = 3548.44, y = 3641.4, z = 28.12, heading = 71.85  ,},
		--{id = 53, Weapon =0x83BF0278,  modelHash = "ig_josef",     x = 3530.73, y = 3649.31, z = 27.52, heading = 214.56  , wander=true,},
		{id = 39, Weapon = 0xBFEFFF6D,  modelHash = "s_m_y_robber_01",    x = 3529.29, y = 3654.43, z = 27.52, heading = 152.78  ,},
		
		{id = 40, Weapon =0x83BF0278,  modelHash = "U_M_Y_Tattoo_01",    x = 3536.76, y = 3665.0, z = 28.12, heading = 88.18  , wander=true},
		{id = 41,   Weapon = 0x0781FE4A,  modelHash = "g_f_y_lost_01",    x = 3527.02, y = 3672.52, z = 28.12, heading = 228.4  ,},
		{id = 42, Weapon =0x0781FE4A,  modelHash = "s_m_y_ammucity_01",    x = 3531.2, y = 3674.0, z = 28.12, heading = 223.67  , wander=true,},
		{id = 43,   modelHash = "mp_m_bogdangoon", isBoss=true,   x = 3540.19, y = 3671.29, z = 28.12, heading = 72.07  ,wander=true},
		--{id = 59,   modelHash = "U_M_Y_Zombie_01",    x = 3530.21, y = 3673.36, z = 20.99, heading = 273.58  ,},
		{id = 45, Weapon =0x7846A318,  modelHash = "G_M_M_ChiCold_01",    x = 3525.63, y = 3672.7, z = 20.99, heading = 254.06  , wander=true,},
		--{id = 61,   modelHash = "U_M_Y_Zombie_01",     x = 3521.6, y = 3678.05, z = 20.99, heading = 204.68 ,},
		{id = 46, Weapon =0xEFE7E2DF,  modelHash = "U_M_Y_Tattoo_01",     x = 3524.9, y = 3681.71, z = 20.99, heading = 115.88  , wander=true,},
		--{id = 63,   modelHash = "U_M_Y_Zombie_01",    x = 3528.33, y = 3698.45, z = 20.99, heading = 97.41  ,},
		{id = 47, Weapon =0x83BF0278,  modelHash = "G_M_M_ChiCold_01",     x = 3524.24, y = 3698.26, z = 20.99, heading = 144.75  , wander=true,},
		--{id = 65,   modelHash = "U_M_Y_Zombie_01",     x = 3526.08, y = 3693.92, z = 20.99, heading = 154.52  ,},
		{id = 48, Weapon =0xE284C527,  modelHash = "mp_m_exarmy_01",    x = 3523.45, y = 3711.96, z = 20.99, heading = 142.97  , wander=true,},
		--{id = 67,   modelHash = "U_M_Y_Zombie_01",    x = 3519.2, y = 3706.84, z = 20.99, heading = 249.19  ,},
		{id = 49,  modelHash = "u_m_y_juggernaut_01", isBoss=true,   x = 3526.88, y = 3707.32, z = 20.99, heading = 214.36  , wander=true,},
		--{id = 50, Weapon =0xEFE7E2DF,  modelHash = "ig_Cletus",    x = 3528.11, y = 3714.45, z = 17.31, heading = 73.09  ,wander=true,},
		
		{id = 50,   modelHash = "mp_m_bogdangoon", isBoss=true,  x = 3595.62, y = 3691.26, z = 28.82, heading = 48.78  ,},
		{id = 51,   modelHash = "mp_m_bogdangoon", isBoss=true,   x = 3527.02, y = 3672.52, z = 28.12, heading = 228.4  ,},
		{id = 52,   modelHash = "a_c_chimp",    x = 3562.11, y = 3690.99, z = 28.12, heading = 231.7  ,wander=true,friendly=true},
		{id = 53,   modelHash = "a_c_chimp",    x = 3528.33, y = 3698.45, z = 20.99, heading = 97.41  ,wander=true,friendly=true},
		--{id = 40,   modelHash = "U_M_Y_Zombie_01",    x = 3525.66, y = 3721.34, z = 17.13, heading = 301.46 ,target=true},
		--{id = 41,   modelHash = "U_M_Y_Zombie_01",    x = 3607.87, y = 3745.12, z = 28.69, heading = 264.35 ,target=true},
		--{id = 42,   modelHash = "U_M_Y_Zombie_01",    x = 3529.71, y = 3717.15, z = 16.88, heading = 195.27  ,target=true},
		
		
		
    },
	
	Events = {
	
		
	
		{ 
		  Type="Aircraft",
		  Position = {  x = 3588.96, y = 3766.57, z = 29.94, heading = 307.76, }, 
		  Size     = {radius=1000.0},
		  SpawnHeight =50.0,
		  FacePlayer = true,
		  --NumberPeds=10,
		  isBoss=false,
		  Target=false,
		  Vehicle="valkyrie",
		 Weapon=0x13532244,
		  SquadSpawnRadius=1.0,
		  --CheckGroundZ=true,
		},	
		{ 
		  Type="Aircraft",
		  Position = { x = 3565.92, y = 3791.76, z = 30.06, heading = 364.31 }, 
		  Size     = {radius=1000.0},
		  SpawnHeight =50.0,
		  FacePlayer = true,
		  --NumberPeds=10,
		  isBoss=false,
		  Target=false,
		  Vehicle="valkyrie",
		 -- Weapon=0x0781FE4A,
		  SquadSpawnRadius=1.0,
		  --CheckGroundZ=true,
		},
		
		{ 
		  Type="Vehicle",
		  Position = {x = 3617.5, y = 3738.11, z = 28.69, heading = 28.27 }, 
		  Size     = {radius=100.0},
		  SpawnHeight =200.0,
		  FacePlayer = true,
		  --NumberPeds=10,
		  isBoss=false,
		  Target=false,
		  Vehicle="insurgent3",
		  Weapon=0xBD248B55,
		  SquadSpawnRadius=1.0,
		  --CheckGroundZ=true,
		},	

		{ 
		  Type="Boat",
		  Position = {  x = 3852.25, y = 3684.51, z = 0.02, heading = 53.07  }, 
		  Size     = {radius=200.0},
		  SpawnHeight =200.0,
		  FacePlayer = true,
		  --NumberPeds=10,
		  isBoss=false,
		  Target=false,
		  --Vehicle="insurgent3",
		  Weapon=0x0781FE4A,
		  SquadSpawnRadius=1.0,
		  --CheckGroundZ=true,
		},
		{ 
		  Type="Paradrop",
		  Position = { x = 3725.24, y = 3679.36, z = 39.31, heading = -53.8  }, 
		  Size     = {radius=200.0},
		  --SpawnHeight =200.0,
		  --FacePlayer = true,
		  NumberPeds=10,
		  --isBoss=false,
		  --Target=false,
		  --Vehicle="insurgent3",
		  --Weapon=0x0781FE4A,
		  SquadSpawnRadius=1.0,
		  --CheckGroundZ=true,
		},					
		
	},
	
	

    Vehicles = {
      -- ID: id of NPC | name: Name of Blip | BlipID: Icone of Blip | VoiceName: NPC Talk When near it | Ambiance: Ambiance of Shop | Weapon: Hash of Weapon | modelHash: Model | X: Position x | Y: Position Y | Z: Position Z | heading: Where Npc look
   	  --**IMPORTANT: make sure the id of the ped starts from 1, each Peds id in above, increments by 1 and matches that entries index if it were in an array***
	  --vehicles are not consistent, so use ExtraPeds at your own discretion.
	  --Below takes a ped with id=1 from Peds above and will put it in seatid = -2   
	 -- {id = 1, id2 = 1, Vehicle = "annihilator", modelHash = "S_M_M_ChemSec_01",  x = -1166.42, y = 4641.5, z = 145.11, heading = 210.07,driving=true,pilot=true},
	 -- {id = 2, id2 = 2, Vehicle = "toro2", modelHash = "s_m_y_ammucity_01",  x = -3014.83, y = -43.5, z = 0.13, heading = 151.19, driving=true},
	 --{id = 1, id2 = 1, Vehicle = "insurgent3", modelHash = "s_m_y_ammucity_01",  x = 3617.5, y = 3738.11, z = 28.69, heading = 28.27, Weapon=0x13532244,outside=true},
	-- {id = 2, id2 = 2, Vehicle = "valkyrie", modelHash = "s_m_y_ammucity_01", x = 3588.96, y = 3766.57, z = 29.94 + 50, heading = 307.76,pilot=true, isAircraft=true,outside=true,Weapon=0x13532244},
	-- {id = 3, id2 = 3, Vehicle = "valkyrie", modelHash = "s_m_y_ammucity_01", x = 3565.92, y = 3791.76, z = 30.06 + 50, heading = 364.31,pilot=true, isAircraft=true,outside=true,Weapon=0x13532244},
    },
	
  }, 
  
  Mission31 = {
    
	StartMessage = "Stop the mercenaries from blowing up the~n~Land Act Dam in order to flood Los Santos",
	FinishMessage = "Mission Completed!",
	MissionTitle = "Evian Almighty",
	MissionMessage = "Stop the mercenaries from blowing up the~n~Land Act Dam in order to flood Los Santos",	
	Type = "ObjectiveRescue",	
	IndoorsMission = true,
	SafeHouseSniperExplosiveRoundsGiven=4,
	--IndoorsMissionStrongSpawnCheck = true,
	ObjectiveRescueShortRangeBlip = true,
	MissionTriggerRadius=1500.0,
	
	SMS_Subject="Land Act Dam",
	SMS_Message="Mercenaries are trying to blow up the Land Act Dam in order to flood Los Santos",
	SMS_Message2="We need someone to stop them. Can you help us?",
	--SMS_Message3="Anyone up for this?",	
		
	SMS_ContactPics={"CHAR_AGENT14",
	},
	SMS_ContactNames={"Agency Contact",
	},
	SMS_NoFailedMessage=true,
	--SMS_NoPassedMessage=true,
	SMS_FailedSubject="HAHA",
	SMS_FailedMessage="You should have stayed away, this is much bigger than you",
	SMS_PassedSubject="Thank you",
	SMS_PassedMessage="Los Santos is safe and sound from the attack",			
	
    Blips = {{
		  Title = "Mission: Land Act Dam",
		  Position =  { x = 1665.55, y = -12.93, z = 173.77},
		  Icon     = 58,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 1,
		},
		
	},
	--[[
	 Blip = {
		  Title = "Land Act Dam",
		  Position =  { x = 1665.55, y = -12.93, z = 173.77},
		  Icon     = 58,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 1,
		},
	]]--	

    Marker = {
      Type     = 1,
      Position = { x = 2358.2, y = 2920.95, z = -85.78}, 
      Size     = {x = 6.0, y = 6.0, z = 2.0},
      Color    = {r = 100, g = 100, b = 204},
      DrawDistance = 100.0,
    },
	
	Events = {
	
		
		 { --Dam front landing
		  Type="Squad",
		  Position = {  x = 1662.41, y = -49.59, z = 168.31}, 
		  Size     = {radius=300.0},
		  SpawnHeight = 300.0,
		  --FacePlayer = true,
		  NumberPeds=7,
		  isBoss=false,
		  Target=false,
		  --Vehicle="deathbike",
		  SquadSpawnRadius=1.0,
		  --CheckGroundZ=true,
		},
		 { --Dam middle
		  Type="Squad",
		  Position = { x = 1660.16, y = -0.24, z = 173.77, heading = 25.29}, 
		  Size     = {radius=300.0},
		  SpawnHeight = 200.0,
		  --FacePlayer = true,
		  NumberPeds=7,
		  isBoss=false,
		  Target=false,
		  --Vehicle="deathbike",
		  SquadSpawnRadius=1.0,
		  --CheckGroundZ=true,
		},
		
		{ --Dam north
		  Type="Squad",
		  Position = { x = 1644.02, y = 25.83, z = 173.55, heading = 335.9}, 
		  Size     = {radius=300.0},
		  SpawnHeight = 200.0,
		  --FacePlayer = true,
		  NumberPeds=7,
		  isBoss=false,
		  Target=false,
		  --Vehicle="deathbike",
		  SquadSpawnRadius=1.0,
		  --CheckGroundZ=true,
		},
		{ --Dam south
		  Type="Squad",
		  Position = { x = 1674.93, y = -63.13, z = 173.78, heading = 188.55}, 
		  Size     = {radius=300.0},
		  SpawnHeight = 200.0,
		  --FacePlayer = true,
		  NumberPeds=7,
		  isBoss=false,
		  Target=false,
		  --Vehicle="deathbike",
		  SquadSpawnRadius=2.0,
		  --CheckGroundZ=true,
		},
		{ --Dam top
		  Type="Squad",
		  Position = { x = 1662.39, y = -27.24, z = 182.77, heading = 189.14 }, 
		  Size     = {radius=300.0},
		  SpawnHeight = 200.0,
		  --FacePlayer = true,
		  NumberPeds=3,
		  isBoss=false,
		  Target=false,
		  --Vehicle="deathbike",
		  SquadSpawnRadius=0.5,
		  --CheckGroundZ=true,
		},		

		{ --Dam top
		  Type="Squad",
		  Position = { x = 1670.96, y = -22.98, z = 182.77, heading = 268.17}, 
		  Size     = {radius=300.0},
		  SpawnHeight = 200.0,
		  --FacePlayer = true,
		  NumberPeds=3,
		  isBoss=false,
		  Target=false,
		  --Vehicle="deathbike",
		  SquadSpawnRadius=0.5,
		  --CheckGroundZ=true,
		},	

		{ --Dam bottom
		  Type="Squad",
		  Position = { x = 1653.82, y = -21.52, z = 134.11, heading = 126.79 }, 
		  Size     = {radius=300.0},
		  SpawnHeight = 200.0,
		  --FacePlayer = true,
		  NumberPeds=7,
		  isBoss=false,
		  Target=false,
		  --Vehicle="deathbike",
		  SquadSpawnRadius=1.0,
		  --CheckGroundZ=true,
		},

		{ 
		  Type="Boat",
		  Position = {  x = 1674.16, y = 20.41, z = 159.81, heading = 266.75 }, 
		  Size     = {radius=300.0},
		  SpawnHeight = 400.0,
		  FacePlayer = true,
		  --NumberPeds=10,
		  isBoss=false,
		  Target=false,
		  Vehicle="seashark3",
		  Weapon=0x0781FE4A,
		  SquadSpawnRadius=1.0,
		  --CheckGroundZ=true,
		},
		{
		  Type="Boat",
		  Position = { x = 1690.17, y = -10.63, z = 159.91, heading = 295.3 }, 
		  Size     = {radius=300.0},
		  SpawnHeight = 400.0,
		  FacePlayer = true,
		  --NumberPeds=10,
		  isBoss=false,
		  Target=false,
		  Vehicle="dinghy4",
		  Weapon=0x624FE830,
		  SquadSpawnRadius=1.0,
		  --CheckGroundZ=true,
		},

		{ 
		  Type="Boat",
		  Position = { x = 1703.86, y = -37.21, z = 160.45, heading = 292.92 }, 
		  Size     = {radius=300.0},
		  SpawnHeight = 400.0,
		  FacePlayer = true,
		  --NumberPeds=10,
		  isBoss=false,
		  Target=false,
		  Vehicle="seashark3",
		  Weapon=0x0781FE4A,
		  SquadSpawnRadius=1.0,
		  --CheckGroundZ=true,
		},
		{ 
		  Type="Vehicle",
		  Position = {x = 1652.44, y = 44.98, z = 172.45, heading = 308.21 }, 
		  Size     = {radius=400.0},
		  SpawnHeight =300.0,
		  FacePlayer = true,
		  --NumberPeds=10,
		  isBoss=false,
		  Target=false,
		  --Vehicle="seashark3",
		  --Weapon=0x0781FE4A,
		  SquadSpawnRadius=1.0,
		  --CheckGroundZ=true,
		},	
		{ 
		  Type="Vehicle",
		  Position = { x = 1691.3, y = -74.77, z = 175.45, heading = 64.69 }, 
		  Size     = {radius=400.0},
		  SpawnHeight = 300.0,
		  FacePlayer = true,
		  --NumberPeds=10,
		  isBoss=false,
		  Target=false,
		  --Vehicle="seashark3",
		  --Weapon=0x0781FE4A,
		  SquadSpawnRadius=1.0,
		  --CheckGroundZ=true,
		},

		{ 
		  Type="Aircraft",
		  Position = {x = 1671.42, y = -42.34, z = 173.77, heading = 450.58 }, 
		  Size     = {radius=1000.0},
		  SpawnHeight = 200.0,
		  FacePlayer = true,
		  --NumberPeds=10,
		  isBoss=false,
		  Target=false,
		  --Vehicle="seashark3",
		  --Weapon=0x0781FE4A,
		  SquadSpawnRadius=1.0,
		  --CheckGroundZ=true,
		},	
		{ 
		  Type="Aircraft",
		  Position = { x = 1652.8, y = 9.15, z = 173.77, heading = 131.97 }, 
		  Size     = {radius=1000.0},
		  SpawnHeight = 200.0,
		  FacePlayer = true,
		  --NumberPeds=10,
		  isBoss=false,
		  Target=false,
		  --Vehicle="seashark3",
		  --Weapon=0x0781FE4A,
		  SquadSpawnRadius=1.0,
		  --CheckGroundZ=true,
		},
		{ 
		  Type="Paradrop",
		  Position = { x = 1669.83, y = -24.99, z = 173.77, heading = 178.79 }, 
		  Size     = {radius=20.0},
		  SpawnHeight = 200.0,
		  --FacePlayer = true,
		  NumberPeds=10,
		  isBoss=false,
		  Target=false,
		  --Vehicle="seashark3",
		  --Weapon=0x0781FE4A,
		  SquadSpawnRadius=1.0,
		  --CheckGroundZ=true,
		},				

	  
--[[	  { --west airstrip
		  Type="Vehicle",
		  Position = {  x = 1213.96, y = 3117.46, z = 40.41}, 
		  Size     = {radius=1000.0},
		  SpawnHeight = 200.0,
		  FacePlayer = true,
		 -- NumberPeds=50,
		  isBoss=false,
		  Target=false,
		  --Vehicle="deathbike",
		  SquadSpawnRadius=25.0,
		  --CheckGroundZ=true,
		},
	   { --aistrip hanger outside
		  Type="Aircraft",
		  Position = {   x = 1741.05, y = 3287.54, z = 40.84}, 
		  Size     = {radius=1000.0},
		  SpawnHeight = 200.0,
		  FacePlayer = true,
		},
	   { --Maze Bank Downtown
		  Type="Squad",
		  Position = { x = -145.67, y = -904.38, z = 29.35}, 
		  Size     = {radius=1000.0},
		  SpawnHeight = 200.0,
		  --FacePlayer = true,
		  NumberPeds=50,
		  isBoss=false,
		  Target=false,
		  --Vehicle="deathbike",
		  SquadSpawnRadius=100.0,
		  CheckGroundZ=true,
		},		
		]]--
	},	
	
	BlipS = { --safehouse blip 
		  Title = "Mission Safehouse",
		  Position = { x = 1731.94, y = 3308.24, z = 41.22}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 417,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 2,
		  Alpha	 =80, 
	},	
	MarkerS = { --safehouse marker
		  Type     = 1,
		  Position = { x = 1731.94, y = 3308.24, z = 40.22},  --{  x = 1944.96, y = 3150.6, z = 46.77}, 
		  Size     = {x = 6.0, y = 6.0, z = 2.0},
		  Color    = {r = 117, g = 218, b = 255},
		  DrawDistance = 200.0,
	},
	BlipSL = { --safehouse Vehicle blip 
		  Title = "Mission Vehicle Safehouse",
		  Position = { x = 1480.63, y = 3167.93, z = 40.99}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 421,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
	},
	BlipSB = { --safehouse boat blip 
		  Title = "Mission Boat Safehouse",
		  Position = {x = 1481.84, y = 3873.37, z = 30.04}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		 Icon     = 404,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
	},
	SafeHouseVehicles = {
	"insurgent3",
	"kuruma2",
	},
	SafeHouseAircraft = 
	{
	"hydra",
	"valkyrie",
	"thruster",
	},
	SafeHouseBoat = 
	{
	"dinghy4",
	"seashark",
	"toro2",
	"jetmax",
	"submersible2",
	"submersible",
	},		
	
	
	Props = {
		--{ id=1,  Name = "prop_c4_final_green", isObjective=true,Position = { x = 1723.83, y = 3308.42, z = 41.22, heading = 95.18 }},
		{ id=1,  Name = "prop_c4_final_green",isObjective=true, Position =  {x = 1659.04, y = -18.92, z = 135.39, heading = 293.05  }},
		{ id=2,  Name = "prop_c4_final_green", isObjective=true,Position = {x = 1664.75, y = 2.19, z = 173.70, heading = 305.03 }},
		{ id=3,  Name = "hei_prop_heist_thermite_flash", isObjective=true,Position = {x = 1667.07, y = -27.17, z = 184.77, heading = 196.24 }},
		{ id=4,  Name = "prop_c4_final_green", isObjective=true,Position = {x = 1656.85, y = -45.03, z = 165.12, heading = 344.29 }},
		{ id=5,  Name = "hei_prop_heist_thermite_flash", isObjective=true,Position = {x = 1665.69, y = -60.84, z = 180.16, heading = 255.64 }},
		{ id=6,  Name = "hei_prop_heist_thermite_flash", isObjective=true,Position = {x = 1652.26, y = 24.9, z = 180.88, heading = 179.83 }},
		{ id=7,  Name = "prop_c4_final_green", isObjective=true,Position = {x = 1659.73, y = 0.68, z = 166.12, heading = 125.98 }},
		{ id=8,  Name = "prop_c4_final_green", isObjective=true,Position = {x = 1661.8, y = -27.48, z = 173.77, heading = 107.3 }},
		--{ id=10,  Name = "prop_c4_final_green", isObjective=true,Position = {x = 1678.75, y = -13.86, z = 143.57, heading = 130.17 }},
		{ id=9,  Name = "prop_c4_final_green", isObjective=true,Position = {x = 1679.03, y = -12.58, z = 142.89, heading = 181.5 }},
	
    },
	
	

	
	Pickups = {
	},
	MissionPickups = {
		
	},	
		
	

    Peds = {
	
			{id = 1, Weapon =0x6D544C99,  modelHash ="u_m_y_juggernaut_01",isBoss=true, x = 1665.13, y = -28.0, z = 196.94, heading = 103.98,outside=true},
			{id = 2, Weapon = 0xA914799,  modelHash = "mp_g_m_pros_01",  x = 1660.43, y = -58.66, z = 180.16, heading = 78.03,outside=true},	
			{id = 3, Weapon = 0xA914799,  modelHash = "mp_g_m_pros_01",  x = 1662.09, y = 24.89, z = 180.88, heading = 273.77,outside=true},
			{id = 4,  modelHash = "ig_terry",  x = 1663.47, y = -26.84, isBoss=true, z = 173.77, heading = 211.63 },	
			{id = 5, modelHash = "mp_m_weapexp_01", x = 1659.81, y = 29.28, z = 168.61, heading = 170.94, isBoss=true},	
			{id = 6, modelHash = "mp_m_exarmy_01",x = 1666.03, y = 1.28, z = 166.12, heading = 84.31, isBoss=true},					
			--{id = 3, Weapon =0x13532244,  modelHash = "s_m_y_ammucity_01", x = 1738.55, y = 3275.43, z = 41.14+100.0, heading = 181.86,outside=true}-- x = 1732.15, y = 3320.26, z = 41.22, heading = 283.82,},
			--[[{id = 2, Weapon =0x7FD62962,  modelHash = "G_M_M_ChiCold_01",x = 2168.32, y = 2921.33, z = -84.8, heading = 81.96 },
			{id = 3, Weapon =0xAF113F99,  modelHash = "s_m_y_ammucity_01", x = 2159.98, y = 2920.99, z = -84.8, heading = 268.03  },
			
			{id = 4, Weapon =0xDBBD7280,  modelHash = "s_m_y_dealer_01", x = 2178.14, y = 2916.55, z = -84.79, heading = 108.35  },
			{id = 5, Weapon =0xFAD1F1C9,  modelHash = "s_m_y_ammucity_01", x = 2176.58, y = 2927.84, z = -84.8, heading = 105.77 },
			{id = 6, Weapon =0xE284C527,  modelHash = "U_M_Y_Tattoo_01",  x = 2176.14, y = 2922.38, z = -84.8, heading = 57.45   },
			{id = 7, modelHash = "mp_m_bogdangoon",isBoss=true,x = 2178.74, y = 2920.77, z = -84.8, heading = 264.61 },			
			{id = 8, modelHash = "mp_m_exarmy_01",isBoss=true,x = 2358.06, y = 2894.02, z = -84.8, heading = 82.86 },	
			
			{id = 9, modelHash = "mp_m_weapexp_01",isBoss=true, x = 2358.26, y = 2948.02, z = -84.8, heading = 90.65  },	
			
			{id = 10, Weapon =0x7FD62962,  modelHash = "s_m_y_ammucity_01", x = 2355.61, y = 2944.01, z = -84.8, heading = 267.41, },
			{id = 11, Weapon =0x7FD62962,  modelHash = "s_m_y_ammucity_01", x = 2355.53, y = 2898.05, z = -84.8, heading = -98.46  },
			
			{id = 12, Weapon =0x7FD62962,  modelHash = "G_M_M_ChiCold_01",x = 2357.36, y = 2902.62, z = -84.8, heading = 86.09 },
			{id = 13, Weapon =0x7FD62962,  modelHash = "U_M_Y_Tattoo_01",x = 2357.45, y = 2906.46, z = -84.8, heading = 85.96 },
			
			{id = 14, Weapon =0x7FD62962,  modelHash = "s_m_y_ammucity_01", x = 2357.49, y = 2940.11, z = -84.8, heading = 85.39 },
			
			{id = 15, Weapon =0x7FD62962,  modelHash = "s_m_y_robber_01",x = 2357.09, y = 2936.33, z = -84.8, heading = 86.47 },	
			
			{id = 16, modelHash = "u_m_y_juggernaut_01",isBoss=true, x = 2357.74, y = 2931.17, z = -84.8, heading = 87.94   },
			
			{id = 17, modelHash = "u_m_y_juggernaut_01",isBoss=true,x = 2357.67, y = 2911.07, z = -84.8, heading = 84.42 },
			{id = 18, modelHash = "u_m_y_juggernaut_01",isBoss=true,x = 2357.98, y = 2915.69, z = -84.65, heading = 185.38 },			
			{id = 19, modelHash = "u_m_y_juggernaut_01",isBoss=true, x = 2358.04, y = 2925.98, z = -84.65, heading = 358.89 },
			
			
			{id = 20, Weapon =0x63AB0442,  modelHash = "s_m_y_xmech_02", x = 2185.14, y = 2904.4, z = -84.8, heading = 81.81 },
			{id = 21, Weapon =0x63AB0442,  modelHash = "G_M_M_ChiCold_01", x = 2193.53, y = 2912.41, z = -84.8, heading = 86.44 },
			
			{id = 22, Weapon =0xAF113F99,  modelHash = "g_m_y_lost_03", x = 2204.32, y = 2928.5, z = -84.8, heading = 183.6  },
			{id = 23, Weapon =0xDBBD7280,  modelHash = "s_m_y_dealer_01", x = 2192.8, y = 2937.65, z = -84.8, heading = 96.16 },
			{id = 24, Weapon =0xFAD1F1C9,  modelHash = "s_m_y_ammucity_01", x = 2209.21, y = 2919.18, z = -84.8, heading = 176.13 },
			{id = 25, Weapon =0xEFE7E2DF,  modelHash = "u_f_y_bikerchic", x = 2209.7, y = 2922.72, z = -84.8, heading = -5.35    },
			{id = 26, modelHash = "mp_m_bogdangoon",isBoss=true,x = 2225.64, y = 2928.69, z = -84.79, heading = 1.55 },			
			{id = 27, modelHash = "mp_m_exarmy_01",isBoss=true,x = 2225.5, y = 2912.78, z = -84.8, heading = -9.91 },	
			{id = 28, modelHash = "mp_m_weapexp_01",isBoss=true, x = 2225.52, y = 2905.73, z = -84.8, heading = 169.79   },	
			{id = 29, Weapon =0xE284C527,  modelHash = "g_f_y_lost_01", x = 2241.55, y = 2897.49, z = -84.8, heading = 46.64 },
			{id = 30, Weapon =0xA914799,  modelHash = "g_m_y_lost_02", x = 2234.77, y = 2906.12, z = -84.8, heading = -7.76  },
			{id = 31, Weapon =0xE284C527,  modelHash = "G_M_M_ChiCold_01",x = 2240.36, y = 2939.79, z = -84.8, heading = 357.43 },
			{id = 32, Weapon =0xA914799,  modelHash = "U_M_Y_Tattoo_01", x = 2259.19, y = 2928.08, z = -84.8, heading = 172.99 },
			{id = 33, Weapon =0xAF113F99,  modelHash = "s_m_y_ammucity_01", x = 2259.3, y = 2930.8, z = -84.8, heading = 358.78 },
			
			{id = 34, Weapon =0xAF113F99,  modelHash = "s_m_y_robber_01",x = 2278.91, y = 2919.22, z = -84.8, heading = 176.71 },	
			{id = 35, Weapon = 0xC0A3098D,  modelHash = "g_m_y_lost_01",x = 2278.62, y = 2922.68, z = -84.8, heading = -5.34 },	
			{id = 36, Weapon = 0x7F229F94,  modelHash = "u_f_y_bikerchic",x = 2298.73, y = 2930.61, z = -84.8, heading = -5.04   },	
			
			{id = 37, Weapon = 0x3AABBBAA,  modelHash = "s_m_y_xmech_02_mp",x = 2298.15, y = 2927.76, z = -84.8, heading = 179.47  },
			{id = 38, Weapon = 0x2BE6766B,  modelHash = "s_m_y_dealer_01",x = 2317.56, y = 2910.98, z = -84.8, heading = 174.82  },
			{id = 39, Weapon = 0x83BF0278,  modelHash = "s_m_y_ammucity_01",x = 2319.11, y = 2914.45, z = -84.8, heading = 356.29  },
			
			{id = 40, Weapon = 0xDBBD7280,  modelHash = "g_m_y_lost_03", x = 2338.4, y = 2922.53, z = -84.8, heading = -14.96 },	
			{id = 41, Weapon = 0xDBBD7280,  modelHash = "g_m_y_lost_02",x = 2338.46, y = 2918.88, z = -84.8, heading = 178.1 },	
			{id = 42, Weapon = 0xDBBD7280,  modelHash = "G_M_M_ChiCold_01", x = 2338.45, y = 2902.36, z = -84.8, heading = 170.43  },	
			{id = 43, Weapon = 0xDBBD7280,  modelHash = "g_f_y_lost_01", x = 2338.92, y = 2905.81, z = -84.8, heading = -1.24 },				
			
			{id = 44, Weapon = 0xBFEFFF6D,  modelHash = "s_m_y_xmech_02", x = 2339.25, y = 2939.49, z = -84.8, heading = 0.76  },	
			{id = 45, Weapon = 0xBFEFFF6D,  modelHash = "s_m_y_xmech_02_mp", x = 2338.32, y = 2935.93, z = -84.8, heading = 175.75 },
			{id = 46, Weapon = 0xDBBD7280,  modelHash = "U_M_Y_Tattoo_01",  x = 2318.46, y = 2939.14, z = -84.8, heading = -3.03   },
			
			{id = 47, Weapon = 0xBFEFFF6D,  modelHash = "s_m_y_xmech_02",x = 2318.35, y = 2935.99, z = -84.8, heading = 174.93  },	
			{id = 48, Weapon = 0xBFEFFF6D,  modelHash = "s_m_y_xmech_02_mp",x = 2318.04, y = 2902.6, z = -84.8, heading = 177.97 },
			{id = 49, Weapon = 0xDBBD7280,  modelHash = "U_M_Y_Tattoo_01",  x = 2318.43, y = 2905.8, z = -84.8, heading = 6.77   },			
			
			{id = 50, Weapon = 0x63AB0442,  modelHash = "U_M_Y_Tattoo_01",  x = 2191.59, y = 2938.88, z = -84.8, heading = 348.99   },	
			{id = 51, Weapon = 0x63AB0442,  modelHash = "g_m_y_lost_01", x = 2192.4, y = 2936.59, z = -84.8, heading = 190.64 },
			{id = 52, modelHash = "u_m_y_juggernaut_01",isBoss=true,x = 2354.72, y = 2912.29, z = -84.72, heading = 273.7 },			
			{id = 53, modelHash = "u_m_y_juggernaut_01",isBoss=true, x = 2354.19, y = 2929.48, z = -84.72, heading = 265.63 },

			{id = 54, Weapon = 0x83BF0278,  modelHash = "mp_m_boatstaff_01",  x = 1727.53, y = 3321.49, z = 41.22, heading = 344.98,friendly=true,},			
			{id = 55, Weapon = 0x83BF0278,  modelHash = "mp_m_boatstaff_01", x = 1736.15, y = 3322.26, z = 41.22, heading = 283.82,friendly=true,},						
			]]--
			
    },
	
	

    Vehicles = {
		-- {id = 1, id2 = 1, Vehicle = "bmx", modelHash = "s_m_y_dealer_01", x = 2338.23, y = 2914.42, z = -84.8, heading = 174.26, Weapon=0x624FE830},
		--{id = 2, id2 = 2, Vehicle = "bmx", modelHash = "s_m_y_robber_01", x = 2338.5, y = 2930.59, z = -84.8, heading = 355.12,Weapon=0x624FE830},
      -- ID: id of NPC | name: Name of Blip | BlipID: Icone of Blip | VoiceName: NPC Talk When near it | Ambiance: Ambiance of Shop | Weapon: Hash of Weapon | modelHash: Model | X: Position x | Y: Position Y | Z: Position Z | heading: Where Npc look
   	  --**IMPORTANT: make sure the id of the ped starts from 1, each Peds id in above, increments by 1 and matches that entries index if it were in an array***
	  --vehicles are not consistent, so use ExtraPeds at your own discretion.
	  --Below takes a ped with id=1 from Peds above and will put it in seatid = -2   
	 -- {id = 1, id2 = 1, Vehicle = "annihilator", modelHash = "S_M_M_ChemSec_01",  x = -1166.42, y = 4641.5, z = 145.11, heading = 210.07,driving=true,pilot=true},
	 -- {id = 2, id2 = 2, Vehicle = "toro2", modelHash = "s_m_y_ammucity_01",  x = -3014.83, y = -43.5, z = 0.13, heading = 151.19, driving=true},
    }
  },  

Mission32 = {
    
	StartMessage = "Take the secret files to the submarine~n~to be secured, so they can be publicized",
	FinishMessage = "Mission Completed!",
	MissionTitle = "Heat",
	MissionMessage = "Take the secret files to the submarine, to be secured, so they can be publicized",	
	Type = "ObjectiveRescue",	
	IndoorsMission = true,
	--MissionLengthMinutes = 1,
	--IndoorsMissionStrongSpawnCheck = true,
	ObjectiveRescueShortRangeBlip = true,
	--TeleportToSafeHouseOnMissionStart = false,
	SafeHousePedDoctors = {},
	SafeHouseProps = {},
	
	--SafeHouseCostVehicle = 2000,
	--SafeHouseCost = 2000,
	ObjectRescueReward = 10000,
	--NEW SETTING: Will teleport all mission players OUT of vehicles 
	--to the safehouse marker:
	TeleportToSafeHouseOnMissionStartNoVehicle = true,
	TeleportToSafeHouseOnMissionStartDelay = 5000,
	TeleportToSafeHouseMinDistance = 5,
	TeleportToSafeHouseMinVehicleDistance = 5,
	MissionTriggerRadius=10000.0,
	TeleportToSafeHouseOnMissionStart = true,
	SafeHouseGiveImmediately=true,
	
	SMS_Subject="Heat",
	SMS_Message="Take the secret files from the bank vault to the submarine to be secured, so they can be publicized",
	--SMS_Message2="We need someone to stop them. Can you help us?",
	--SMS_Message3="Anyone up for this?",	
		
	--SMS_ContactPics={"CHAR_AGENT14",
	--},
	--SMS_ContactNames={"Agency Contact",
	--},
	SMS_NoFailedMessage=true,
	SMS_NoPassedMessage=true,
	SMS_FailedSubject="HAHA",
	SMS_FailedMessage="You should have stayed away, this is much bigger than you",
	SMS_PassedSubject="Thank you",
	SMS_PassedMessage="Los Santos is safe and sound from the attack",			
	
    Blips = {{
		  Title = "Mission: Bank Vault",
		  Position =  {  x = 249.67, y = 219.57, z = 101.68 },
		  Icon     = 58,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 1,
		},
		{
		Title = "Mission: Submarine",
		Position = {  x = -3596.51, y = 968.78, z = -10.27},
		Icon     = 58,
		Display  = 4,
		Size     = 1.2,
		Color    = 1,
		},
		},

    Marker = {
      Type     = 1,
      Position = { x = 2358.2, y = 2920.95, z = -85.78}, 
      Size     = {x = 6.0, y = 6.0, z = 2.0},
      Color    = {r = 100, g = 100, b = 204},
      DrawDistance = 100.0,
    },
	Events = {
	
		
	   { --outside bank
		  Type="Squad",
		  Position = {x = 240.78, y = 193.2, z = 105.1 }, 
		  Size     = {radius=30.0},
		 -- SpawnHeight = 200.0,
		  FacePlayer = true,
		  NumberPeds=10,
		  isBoss=false,
		  Target=false,
		  --Vehicle="deathbike",
		  SquadSpawnRadius=200.0,
		  --SpawnAt = {  x = 199.4, y = 190.87, z = 105.57},
		  CheckGroundZ=true,
		},
	   { --outside bank
		  Type="Squad",
		  Position = {x = 235.76, y = 217.0, z = 106.29 }, 
		  Size     = {radius=30.0},
		 -- SpawnHeight = 200.0,
		  FacePlayer = true,
		  NumberPeds=5,
		  isBoss=false,
		  Target=false,
		  --Vehicle="deathbike",
		  SquadSpawnRadius=200.0,
		  SpawnAt = {  x = 199.4, y = 190.87, z = 105.57},
		  CheckGroundZ=true,
		},
	   { --outside bank
		  Type="Squad",
		  Position = {x = 260.13, y = 205.5, z = 106.28 }, 
		  Size     = {radius=30.0},
		 -- SpawnHeight = 200.0,
		  FacePlayer = true,
		  NumberPeds=5,
		  isBoss=false,
		  Target=false,
		  --Vehicle="deathbike",
		  SquadSpawnRadius=200.0,
		  SpawnAt = {  x = 271.57, y = 158.96, z = 104.44},
		  CheckGroundZ=true,
		},

	   { --outside bank
		  Type="Vehicle",
		  Position = {x = 247.75, y = 215.06, z = 106.29}, 
		  Size     = {radius=10.0},
		 -- SpawnHeight = 200.0,
		  FacePlayer = true,
		--  NumberPeds=10,
		  isBoss=false,
		  Target=false,
		  --Vehicle="deathbike",
		  SquadSpawnRadius=10.0,
		  SpawnAt = { x = 866.34, y = -99.86, z = 79.44},
		  CheckGroundZ=true,
		},		

	   { --outside bank
		  Type="Vehicle",
		  Position = {x = 251.4, y = 216.87, z = 106.29}, 
		  Size     = {radius=10.0},
		 -- SpawnHeight = 200.0,
		  FacePlayer = true,
		 -- NumberPeds=10,
		  isBoss=false,
		  Target=false,
		  --Vehicle="deathbike",
		  SquadSpawnRadius=10.0,
		  SpawnAt = {  x = 313.27, y = 1004.46, z = 210.54},
		  CheckGroundZ=true,
		},		


	   { --outside bank
		  Type="Vehicle",
		  Position = {x = 249.49, y = 220.7, z = 106.29 }, 
		  Size     = {radius=10.0},
		 -- SpawnHeight = 200.0,
		  FacePlayer = true,
		  --NumberPeds=10,
		  isBoss=false,
		  Target=false,
		  --Vehicle="deathbike",
		  SquadSpawnRadius=10.0,
		  SpawnAt = { x = -542.65, y = 250.98, z = 83.05},
		  CheckGroundZ=true,
		},		

	   { --outside bank
		  Type="Vehicle",
		  Position = { x = 246.02, y = 218.97, z = 106.29 }, 
		  Size     = {radius=10.0},
		 -- SpawnHeight = 200.0,
		  FacePlayer = true,
		  --NumberPeds=10,
		  isBoss=false,
		  Target=false,
		  --Vehicle="deathbike",
		  SquadSpawnRadius=10.0,
		  SpawnAt = {  x = -49.39, y = -528.09, z = 40.39},
		  CheckGroundZ=true,
		},
		
----

   { --outside bank
		  Type="Squad",
		  Position = {x = 247.75, y = 215.06, z = 106.29}, 
		  Size     = {radius=10.0},
		 -- SpawnHeight = 200.0,
		  FacePlayer = true,
		  NumberPeds=1,
		  isBoss=false,
		  Target=false,
		  --Vehicle="deathbike",
		  SquadSpawnRadius=10.0,
		  SpawnAt = {x = -111.34, y = 254.49, z = 97.57},
		  CheckGroundZ=true,
		},		

	   { --outside bank
		  Type="Squad",
		  Position = {x = 251.4, y = 216.87, z = 106.29}, 
		  Size     = {radius=10.0},
		 -- SpawnHeight = 200.0,
		  FacePlayer = true,
		 NumberPeds=1,
		  isBoss=false,
		  Target=false,
		  --Vehicle="deathbike",
		  SquadSpawnRadius=10.0,
		  SpawnAt = {   x = 104.04, y = -86.77, z = 62.42},
		  CheckGroundZ=true,
		},		


	   { --outside bank
		  Type="Squad",
		  Position = {x = 249.49, y = 220.7, z = 106.29 }, 
		  Size     = {radius=10.0},
		 -- SpawnHeight = 200.0,
		  FacePlayer = true,
		 NumberPeds=1,
		  isBoss=false,
		  Target=false,
		  --Vehicle="deathbike",
		  SquadSpawnRadius=10.0,
		  SpawnAt = { x = 506.81, y = 84.09, z = 96.38},
		  CheckGroundZ=true,
		},		

	   { --outside bank
		  Type="Squad",
		  Position = { x = 246.02, y = 218.97, z = 106.29 }, 
		  Size    = {radius=10.0},
		 -- SpawnHeight = 200.0,
		  FacePlayer = true,
		  NumberPeds=1,
		  isBoss=false,
		  Target=false,
		  --Vehicle="deathbike",
		  SquadSpawnRadius=10.0,
		  SpawnAt = {  x = 243.63, y = 431.38, z = 120.32},
		  CheckGroundZ=true,
		},
			
	   {  --outside bank
		  Type="Aircraft",
		  Position = {  x = 244.2, y = 201.35, z = 105.2}, 
		  Size     = {radius=30.0},
		  SpawnHeight = 200.0,
		  FacePlayer = true,
		 SpawnAt = {x = -1162.49, y = -669.87, z = 22.75, },
		},

	   { --outside bank
		  Type="Aircraft",
		  Position = { x = 243.2, y = 200.35, z = 105.2}, 
		  Size     = {radius=30.0},
		  SpawnHeight = 200.0,
		  FacePlayer = true,
		 SpawnAt = { x = -1484.63, y = 2018.09, z = 65.24},
		},	

		--pier:
	   { 
		  Type="Squad",
		  Position = { x = -3410.64, y = 967.44, z = 8.35 }, 
		  Size    = {radius=300.0},
		 -- SpawnHeight = 200.0,
		  FacePlayer = true,
		  NumberPeds=1,
		  isBoss=true,
		  Target=false,
		  modelHash="u_m_y_juggernaut_01",
		  --Vehicle="deathbike",
		  SquadSpawnRadius=1.0,
		  CheckGroundZ=true,
		},
		
	   { 
		  Type="Squad",
		  Position = { x = -3427.12, y = 975.07, z = 8.35 }, 
		  Size    = {radius=300.0},
		 -- SpawnHeight = 200.0,
		  FacePlayer = true,
		  NumberPeds=1,
		  isBoss=true,
		  Target=false,
		  modelHash="u_m_y_juggernaut_01",
		  --Vehicle="deathbike",
		  SquadSpawnRadius=1.0,
		  CheckGroundZ=true,
		},

	   { 
		  Type="Squad",
		  Position = { x = -3427.09, y = 960.73, z = 8.35 }, 
		  Size    = {radius=300.0},
		 -- SpawnHeight = 200.0,
		  FacePlayer = true,
		  NumberPeds=1,
		  isBoss=true,
		  Target=false,
		  modelHash="u_m_y_juggernaut_01",
		  --Vehicle="deathbike",
		  SquadSpawnRadius=1.0,
		  CheckGroundZ=true,
		},

	   { 
		  Type="Squad",
		  Position = {x = -3422.28, y = 961.26, z = 11.91 }, 
		  Size    = {radius=300.0},
		 -- SpawnHeight = 200.0,
		  FacePlayer = true,
		  NumberPeds=1,
		  isBoss=true,
		  Target=false,
		  --Vehicle="deathbike",
		  modelHash="ig_clay",
		  SquadSpawnRadius=1.0,
		  CheckGroundZ=true,
		},

	   { 
		  Type="Squad",
		  Position = {x = -3422.26, y = 975.51, z = 11.9 }, 
		  Size    = {radius=300.0},
		 -- SpawnHeight = 200.0,
		  FacePlayer = true,
		  NumberPeds=1,
		  isBoss=true,
		  Target=false,
		  modelHash="mp_m_bogdangoon",
		  --Vehicle="deathbike",
		  SquadSpawnRadius=1.0,
		  CheckGroundZ=true,
		},		

	   { 
		  Type="Squad",
		  Position = {x = -3414.03, y = 974.89, z = 11.9 }, 
		  Size    = {radius=300.0},
		 -- SpawnHeight = 200.0,
		  FacePlayer = true,
		  NumberPeds=1,
		  isBoss=true,
		  Target=false,
		  modelHash="ig_josef",
		  --Vehicle="deathbike",
		  SquadSpawnRadius=1.0,
		  CheckGroundZ=true,
		},		

	   { 
		  Type="Squad",
		  Position = { x = -3416.06, y = 957.24, z = 11.91 }, 
		  Size    = {radius=300.0},
		 -- SpawnHeight = 200.0,
		  FacePlayer = true,
		  NumberPeds=1,
		  isBoss=true,
		  Target=false,
		   modelHash="ig_terry",
		  --Vehicle="deathbike",
		  SquadSpawnRadius=1.0,
		  CheckGroundZ=true,
		},				
		
		
	   { 
		  Type="Paradrop",
		  Position = {  x = -3596.51, y = 968.78, z = -10.27}, 
		  Size     = {radius=300.0},
		  SpawnHeight = 200.0,
		  NumberPeds=5,
		  --FacePlayer = true,
		 SpawnAt = {x = -3596.51, y = 968.78, z = -10.27},
		},
	   { 
		  Type="Boat",
		  Position = { x = -3382.06, y = 917.54, z = 0.04 }, 
		  Size     = {radius=300.0},
		 -- SpawnHeight = 200.0,
		  FacePlayer = true,
		  --NumberPeds=10,
		  isBoss=false,
		  Target=false,
		  --Vehicle="deathbike",
		  --SquadSpawnRadius=10.0,
		  --SpawnAt = {  x = -49.39, y = -528.09, z = 40.39},
		  
		},		
		
	   { 
		  Type="Boat",
		  Position = { x = -3386.86, y = 1020.92, z = -1.26, heading = -99.03}, 
		  Size     = {radius=300.0},
		 -- SpawnHeight = 200.0,
		  FacePlayer = true,
		  --NumberPeds=10,
		  isBoss=false,
		  Target=false,
		  --Vehicle="deathbike",
		 -- SquadSpawnRadius=10.0,
		  --SpawnAt = {  x = -49.39, y = -528.09, z = 40.39},
		 
		},
	   { --outside bank
		  Type="Aircraft",
		  Position = { x = -3474.6, y = 966.61, z = -0.42}, 
		  Size     = {radius=750.0},
		  SpawnHeight = 200.0,
		  FacePlayer = true,
		 --SpawnAt = { x = -1484.63, y = 2018.09, z = 65.24},
		},			
		
		
	},	
	
	BlipS = { --safehouse blip 
		  Title = "Mission Safehouse",
		  Position = {  x = 249.67, y = 219.57, z = 101.68}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 417,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 2,
		  Alpha	 =80, 
	},	
	MarkerS = { --safehouse marker
		  Type     = 1,
		  Position = {x = 264.09, y = 214.2, z = 100.68},  --{  x = 1944.96, y = 3150.6, z = 46.77}, 
		  Size     = {x = 3.0, y = 3.0, z = 2.0},
		  Color    = {r = 117, g = 218, b = 255},
		  DrawDistance = 200.0,
	},
	--[[
	BlipSL = { --safehouse Vehicle blip 
		  Title = "Mission Vehicle Safehouse",
		  Position = { x = 1480.63, y = 3167.93, z = 40.99}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 421,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
	},
	BlipSB = { --safehouse boat blip 
		  Title = "Mission Boat Safehouse",
		  Position = {x = 1481.84, y = 3873.37, z = 30.04}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		 Icon     = 404,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
	},	
	]]--
	
	Props = {
		{ id=1,  Name = "xm_prop_x17_sub", isObjective=true,Position = { x = -3596.51, y = 968.78, z = -10.27, heading = -182.9}},
		
	
    },
	
	

	
	Pickups = {
	},
	MissionPickups = {
		
	},	
		
	

    Peds = {
	
			{id = 1, Weapon = 0xAF113F99,  modelHash = "s_m_y_ammucity_01",x = 265.24, y = 221.85, z = 101.68, heading = 53.71},
			{id = 2, Weapon = 0x12E82D3D,  modelHash = "U_M_Y_Tattoo_01", x = 263.31, y = 220.13, z = 101.68, heading = 6.69,},	
			{id = 3, Weapon = 0xAF113F99,  modelHash = "s_m_y_xmech_02_mp",x = 267.03, y = 218.72, z = 104.88, heading = 335.04},
			{id = 4, Weapon = 0x12E82D3D,  modelHash = "G_M_M_ChiCold_01",  x = 262.65, y = 220.6, z = 106.28, heading = 238.58},	

			{id = 5, Weapon = 0xAF113F99,  modelHash = "s_m_y_dealer_01",x = 260.06, y = 226.34, z = 107.08, heading = 148.25},
			{id = 6, Weapon = 0x12E82D3D,  modelHash = "u_f_y_bikerchic",  x = 267.8, y = 223.25, z = 110.28, heading = 71.64},	
			{id = 7, Weapon = 0xAF113F99,  modelHash = "s_m_y_xmech_02",x = 262.2, y = 217.28, z = 110.28, heading = 256.97},
			{id = 8, Weapon = 0x12E82D3D,  modelHash = "g_m_y_lost_01", x = 264.01, y = 213.75, z = 110.29, heading = 67.73 },		
			
			{id = 9, Weapon = 0xAF113F99,  modelHash = "g_m_y_lost_02", x = 262.63, y = 208.02, z = 110.29, heading = 50.69},
			{id = 10, Weapon = 0x12E82D3D,  modelHash = "g_m_y_lost_03",x = 258.17, y = 205.89, z = 110.28, heading = 49.79},	
			{id = 11, Weapon = 0xAF113F99,  modelHash = "g_f_y_lost_01",x = 251.08, y = 209.62, z = 110.28, heading = -32.81},
			{id = 12, Weapon = 0x12E82D3D,  modelHash = "s_m_y_robber_01",   x = 244.8, y = 211.82, z = 110.28, heading = 309.24},		

			{id = 13, Weapon = 0xAF113F99,  modelHash = "mp_g_m_pros_01",x = 238.29, y = 214.31, z = 110.28, heading = 294.41},
			{id = 14, Weapon = 0x12E82D3D,  modelHash = "U_M_Y_Tattoo_01", x = 235.09, y = 221.13, z = 110.28, heading = 274.7},	
			{id = 15, Weapon = 0xAF113F99,  modelHash = "s_m_y_xmech_02_mp", x = 236.69, y = 229.95, z = 110.28, heading = 238.13},
			{id = 16, Weapon = 0x12E82D3D,  modelHash = "G_M_M_ChiCold_01", x = 239.53, y = 229.62, z = 106.28, heading = 120.8},		
			
	
			{id = 17, Weapon = 0x0781FE4A,  modelHash = "s_m_y_ammucity_01", x = 235.42, y = 222.77, z = 106.29, heading = 251.52},
			{id = 18,  modelHash = "mp_m_exarmy_01",isBoss=true,x = 236.04, y = 217.16, z = 106.29, heading = 261.72},	
			{id = 19, Weapon = 0xB1CA77B1,  modelHash = "s_m_y_xmech_02_mp", x = 244.39, y = 212.2, z = 106.29, heading = 307.19},
			{id = 10, Weapon = 0x12E82D3D,  modelHash = "G_M_M_ChiCold_01",  x = 250.55, y = 208.95, z = 106.29, heading = -43.33},

	
			{id = 21, Weapon = 0xAF113F99,  modelHash = "s_m_y_ammucity_01",x = 262.24, y = 204.89, z = 106.28, heading = 52.92},
			{id = 22, Weapon = 0xB1CA77B1,  modelHash = "U_M_Y_Tattoo_01",x = 257.73, y = 206.59, z = 106.28, heading = 252.17 },	
			{id = 23,  modelHash = "mp_m_weapexp_01",isBoss=true,x = 259.92, y = 209.64, z = 106.28, heading = 339.59},
			{id = 24, Weapon = 0x0781FE4A,  modelHash = "G_M_M_ChiCold_01", x = 262.86, y = 216.2, z = 106.28, heading = 126.82},					

			
			
			--{id = 3, Weapon =0x13532244,  modelHash = "s_m_y_ammucity_01", x = 1738.55, y = 3275.43, z = 41.14+100.0, heading = 181.86,outside=true}-- x = 1732.15, y = 3320.26, z = 41.22, heading = 283.82,},
		
			
    },
	
	

    Vehicles = {
	
	  {id = 1, Vehicle = "insurgent3", modelHash = "s_m_y_ammucity_01", x = 260.57, y = 187.38, z = 104.73, heading = 68.48},	
	  {id = 2, Vehicle = "insurgent3", modelHash = "s_m_y_ammucity_01",   x = 248.52, y = 192.14, z = 104.95, heading = 68.78},	
	  {id = 3, Vehicle = "insurgent3", modelHash = "s_m_y_ammucity_01", x = 235.45, y = 196.46, z = 105.18, heading = 62.33},	
		-- {id = 1, id2 = 1, Vehicle = "bmx", modelHash = "s_m_y_dealer_01", x = 2338.23, y = 2914.42, z = -84.8, heading = 174.26, Weapon=0x624FE830},
		--{id = 2, id2 = 2, Vehicle = "bmx", modelHash = "s_m_y_robber_01", x = 2338.5, y = 2930.59, z = -84.8, heading = 355.12,Weapon=0x624FE830},
      -- ID: id of NPC | name: Name of Blip | BlipID: Icone of Blip | VoiceName: NPC Talk When near it | Ambiance: Ambiance of Shop | Weapon: Hash of Weapon | modelHash: Model | X: Position x | Y: Position Y | Z: Position Z | heading: Where Npc look
   	  --**IMPORTANT: make sure the id of the ped starts from 1, each Peds id in above, increments by 1 and matches that entries index if it were in an array***
	  --vehicles are not consistent, so use ExtraPeds at your own discretion.
	  --Below takes a ped with id=1 from Peds above and will put it in seatid = -2   
	 -- {id = 1, id2 = 1, Vehicle = "annihilator", modelHash = "S_M_M_ChemSec_01",  x = -1166.42, y = 4641.5, z = 145.11, heading = 210.07,driving=true,pilot=true},
	 -- {id = 2, id2 = 2, Vehicle = "toro2", modelHash = "s_m_y_ammucity_01",  x = -3014.83, y = -43.5, z = 0.13, heading = 151.19, driving=true},
    }
  },  


  Mission33 = {
    
	StartMessage = "Shut down an interdimensional portal~n~opened by aliens before it is too late!",
	FinishMessage = "~q~You saved San Andreas!",
	MissionTitle = "Ghostbusters",
	MissionMessage = "Shut down an interdimensional portal~n~opened by aliens before it is too late!",	
	Type = "Objective",	
	IndoorsMission = true,
	FinishedObjectiveReward = 10000, --cash
	--MissionLengthMinutes = 1,
	--IndoorsMissionStrongSpawnCheck = true,
	ObjectiveRescueShortRangeBlip = true,
	--TeleportToSafeHouseOnMissionStart = false,
	--SafeHouseCostVehicle = 1000,
	SafeHouseAircraftCount = 2,
	MissionTriggerRadius=1000.0,
	
	SMS_Subject="Ghostbusters",
	SMS_Message="Looks like some rich powerful assholes have been playing with alien tech",
	SMS_Message2="Head downtown and shut down the interdimensional portal opened by them before it is too late!",
	--SMS_Message3="Anyone up for this?",	
		
	--SMS_ContactPics={"CHAR_AGENT14",
	--},
	--SMS_ContactNames={"Agency Contact",
	--},
	SMS_NoFailedMessage=true,
	SMS_NoPassedMessage=true,
	SMS_FailedSubject="HAHA",
	SMS_FailedMessage="You should have stayed away, this is much bigger than you",
	SMS_PassedSubject="Thank you",
	SMS_PassedMessage="Los Santos is safe and sound from the attack",		
	
	
	SafeHouseVehicles = 
	{
		"insurgent3",
	},
	--hack to get only 2 khanjalis to spawn
	SafeHouseAircraft = 
	{
		"khanjali",
	},
	
    Blips = {	{
		Title = "Mission: Cabal Headquarters",
		Position = {x = -81.74, y = -837.28, z = 40.56},
		Icon     = 58,
		Display  = 4,
		Size     = 1.2,
		Color    = 1,
		},
		},

   Marker = {
      Type     = 1,
      Position = {x = -75.16, y = -818.96, z = 325.19}, 
      Size     = {x = 5.0, y = 5.0, z = 325.0},
      Color    = {r = 237, g = 41, b = 57},
      DrawDistance = 3000.0,
    },
	
		BlipS = { --safehouse blip 
		  Title = "Mission Safehouse",
		  Position = { x = -1694.94, y = -3152.18, z = 23.32}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 417,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 2,
		  Alpha	 =80, 
		},	
		 MarkerS = { --safehouse marker
		  Type     = 1,
		  Position = { x = -1694.94, y = -3152.18, z = 23.32},  --{  x = 1944.96, y = 3150.6, z = 46.77}, 
		  Size     = {x = 6.0, y = 6.0, z = 2.0},
		  Color    = {r = 117, g = 218, b = 255},
		  DrawDistance = 200.0,
		},
		BlipSL = { --safehouse Vehicle blip 
		  Title = "Mission Vehicle Safehouse",
		  Position = { x = -1469.37, y = -2967.27, z = 13.3}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 421,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},
		BlipSB = { --safehouse boat blip 
		  Title = "Mission Boat Safehouse",
		  Position = {x = 413.98, y = -3411.47, z = 0.23}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		 Icon     = 404,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},
	
	
	Props = {
		{ id=3,  Name = "p_spinning_anus_s", Freeze=true, Position = {x = -75.16, y = -818.96, z = 646.19, heading = 302.43}},
		{ id=4,  Name = "xm_prop_orbital_cannon_table", Freeze=true, Position = {x = -75.16, y = -818.96, z = 326.19, heading = 302.43}},
	
    },
	
	Events = {
	
	
	
	   { --outside bank
		  Type="Vehicle",
		  Position = { x = -82.72, y = -852.69, z = 40.56,}, 
		  Size     = {radius=300.0},
		 -- SpawnHeight = 200.0,
		  FacePlayer = true,
		--  NumberPeds=10,
		  isBoss=false,
		  Target=false,
		  Vehicle="khanjali",
		  modelHash="mp_m_avongoon",
		  SquadSpawnRadius=10.0,
		  --SpawnAt = { x = 866.34, y = -99.86, z = 79.44},
		  --CheckGroundZ=true,
		},
	   { --outside bank
		  Type="Vehicle",
		  Position = {  x = -154.14, y = -885.04, z = 29.3, }, 
		  Size     = {radius=300.0},
		 -- SpawnHeight = 200.0,
		  FacePlayer = true,
		--  NumberPeds=10,
		  isBoss=false,
		  Target=false,
		  Vehicle="halftrack",
		  modelHash="mp_m_avongoon",
		  SquadSpawnRadius=10.0,
		  --SpawnAt = { x = 866.34, y = -99.86, z = 79.44},
		  --CheckGroundZ=true,
		},
		{ --outside bank
		  Type="Vehicle",
		  Position = {  x = -23.99, y = -779.42, z = 44.26,}, 
		  Size     = {radius=300.0},
		 -- SpawnHeight = 200.0,
		  FacePlayer = true,
		--  NumberPeds=10,
		  isBoss=false,
		  Target=false,
		  Vehicle="khanjali",
		  modelHash="mp_m_avongoon",
		  SquadSpawnRadius=10.0,
		  --SpawnAt = { x = 866.34, y = -99.86, z = 79.44},
		 -- CheckGroundZ=true,
		},
		
	   { --outside bank
		  Type="Vehicle",
		  Position = {  x = -9.47, y = -841.88, z = 30.41,}, 
		  Size     = {radius=300.0},
		 -- SpawnHeight = 200.0,
		  FacePlayer = true,
		--  NumberPeds=10,
		  isBoss=false,
		  Target=false,
		  Vehicle="insurgent3",
		  modelHash="mp_m_avongoon",
		  SquadSpawnRadius=10.0,
		  --SpawnAt = { x = 866.34, y = -99.86, z = 79.44},
		  --CheckGroundZ=true,
		},
		{ --outside bank
		  Type="Vehicle",
		  Position = {  x = -58.52, y = -757.2, z = 33.14, }, 
		  Size     = {radius=300.0},
		 -- SpawnHeight = 200.0,
		  FacePlayer = true,
		--  NumberPeds=10,
		  isBoss=false,
		  Target=false,
		  Vehicle="apc",
		  modelHash="mp_m_avongoon",
		  SquadSpawnRadius=10.0,
		  --SpawnAt = { x = 866.34, y = -99.86, z = 79.44},
		 -- CheckGroundZ=true,
		},
	   { --Maze Bank Downtown
		  Type="Squad",
		  Position = { x = -74.87, y = -818.75, z = 326.2}, 
		  Size     = {radius=200.0},
		  SpawnHeight = 200.0,
		  --FacePlayer = true,
		  NumberPeds=10,
		  isBoss=true,
		  Target=true,
		  modelHash="s_m_m_movalien_01",
		 -- Weapon=0x476BF155,
		  SquadSpawnRadius=5.0,
		 -- CheckGroundZ=true,
		},
	   {  --outside bank
		  Type="Aircraft",
		  Position = { x = -183.35, y = -889.09, z = 29.35}, 
		  Size     = {radius=1000.0},
		  SpawnHeight = 200.0,
		  FacePlayer = true,
		  modelHash="mp_m_avongoon",
		 --SpawnAt = {x = -1162.49, y = -669.87, z = 22.75, },
		},

		{ 
		  Type="Squad",
		  Position = { x = -92.08, y = -873.21, z = 40.58, heading = 430.58 }, 
		  Size     = {radius=300.0},
		  SpawnHeight = 200.0,
		  --FacePlayer = true,
		  NumberPeds=15,
		  isBoss=false,
		  Target=false,
		   modelHash="mp_m_avongoon",
		  --Vehicle="deathbike",
		  SquadSpawnRadius=25.0,
		  --CheckGroundZ=true,
		},	

		{ 
		  Type="Squad",
		  Position = {x = -52.37, y = -777.03, z = 44.16, heading = 66.4 }, 
		  Size     = {radius=300.0},
		  SpawnHeight = 200.0,
		  --FacePlayer = true,
		  NumberPeds=15,
		  isBoss=false,
		  Target=false,
		  modelHash="mp_m_avongoon",
		  --Vehicle="deathbike",
		  SquadSpawnRadius=25.0,
		  --CheckGroundZ=true,
		},	

		{ --Dam bottom
		  Type="Squad",
		  Position = {x = -80.83, y = -787.03, z = 44.23, heading = -103.86 }, 
		  Size     = {radius=300.0},
		  SpawnHeight = 200.0,
		  --FacePlayer = true,
		  NumberPeds=5,
		  isBoss=false,
		  Target=false,
		  modelHash="mp_m_avongoon",
		  --Vehicle="deathbike",
		  SquadSpawnRadius=5.0,
		  --CheckGroundZ=true,
		},

		{ 
		  Type="Paradrop",
		  Position = { x = -85.58, y = -864.91, z = 40.58, heading = 250.8 }, 
		  Size     = {radius=200.0},
		  SpawnHeight = 200.0,
		  --FacePlayer = true,
		  NumberPeds=10,
		  isBoss=false,
		  Target=false,
		  modelHash="mp_m_avongoon",
		  --Vehicle="seashark3",
		  --Weapon=0x0781FE4A,
		  --SquadSpawnRadius=1.0,
		  --CheckGroundZ=true,
		  SpawnAt = { x = -85.58, y = -864.91, z = 40.58, heading = 250.8},
		},				
		
		
	},		

	
	Pickups = {
	},
	MissionPickups = {
		
	},	
		
	

    Peds = {
	
			{id = 1,  modelHash = "s_m_m_movalien_01", isBoss=true,x = -74.61, y = -809.67, z = 321.31, heading = 100.14, target=true,},	
			{id = 2,  modelHash = "s_m_m_movalien_01", isBoss=true,  x = -68.89, y = -811.82, z = 321.29, heading = 212.75, target=true,  },	
			--{id = 3, Weapon =0x13532244,  modelHash = "s_m_y_ammucity_01", x = 1738.55, y = 3275.43, z = 41.14+100.0, heading = 181.86,outside=true}-- x = 1732.15, y = 3320.26, z = 41.22, heading = 283.82,},
		
			
    },
	
	

    Vehicles = {
		-- {id = 1, id2 = 1, Vehicle = "bmx", modelHash = "s_m_y_dealer_01", x = 2338.23, y = 2914.42, z = -84.8, heading = 174.26, Weapon=0x624FE830},
		--{id = 2, id2 = 2, Vehicle = "bmx", modelHash = "s_m_y_robber_01", x = 2338.5, y = 2930.59, z = -84.8, heading = 355.12,Weapon=0x624FE830},
      -- ID: id of NPC | name: Name of Blip | BlipID: Icone of Blip | VoiceName: NPC Talk When near it | Ambiance: Ambiance of Shop | Weapon: Hash of Weapon | modelHash: Model | X: Position x | Y: Position Y | Z: Position Z | heading: Where Npc look
   	  --**IMPORTANT: make sure the id of the ped starts from 1, each Peds id in above, increments by 1 and matches that entries index if it were in an array***
	  --vehicles are not consistent, so use ExtraPeds at your own discretion.
	  --Below takes a ped with id=1 from Peds above and will put it in seatid = -2   
	 -- {id = 1, id2 = 1, Vehicle = "annihilator", modelHash = "S_M_M_ChemSec_01",  x = -1166.42, y = 4641.5, z = 145.11, heading = 210.07,driving=true,pilot=true},
	 -- {id = 2, id2 = 2, Vehicle = "toro2", modelHash = "s_m_y_ammucity_01",  x = -3014.83, y = -43.5, z = 0.13, heading = 151.19, driving=true},
    }
  },

Mission34 = {
    
StartMessage = "Defend the asset and their vehicle~n~eliminate all hostiles~n~~r~Hurry!",
	FinishMessage = "Mission Completed!",
	MissionTitle = "The Gauntlet v3",
	MissionMessage = "New Mission",	
	
	--Obj/Ass values are the messages used depending on which random Type is selected Objective or Assassinate
	--The real messages (values above), will be set to the below, based on which Type
	StartMessageObj = "Capture the objective!",
	FinishMessageObj = "Mission Completed!",
	MissionTitleObj = "Takeover",
	MissionMessageObj = "Capture the objective!",	
	
	StartMessageAss = "Defend the asset and their vehicle~n~eliminate all hostiles~n~~r~Hurry!",
	FinishMessageAss = "Mission Completed!",
	MissionTitleAss = "The Gauntlet v3",
	MissionMessageAss = "Defend the asset and their vehicle~n~eliminate all hostiles",		
	Type = "Assassinate",	
	IsRandom = true,
	RandomMissionTypes ={"Assassinate"},
	IsDefend = true,
	IsDefendTarget = true,
	IsDefendTargetRescue = false,
	IsDefendTargetChase = true,
	IsVehicleDefendTargetChase = true,
	IsDefendTargetSetBlockingOfNonTemporaryEvents=true,
	--IsDefendTargetEnemySetBlockingOfNonTemporaryEvents=true,
	IsDefendTargetOnlyPlayersDamagePeds=false,
	--IsVehicleDefendTargetGotoGoal=true,
	--IsDefendTargetRewardBlip = true,
	GoalReachedReward = 5000,	
	TeleportToSafeHouseOnMissionStartNoVehicle = true,
	SafeHouseTimeTillNextUse=30000, --10 seconds
	--TeleportToSafeHouseOnMissionStartDelay=2000,
	SafeHousePedDoctors = {},
	SafeHousePedLeaders = {},
	SafeHouseProps = {"hei_prop_carrier_crate_01a"},
	SafeHouseGiveImmediately = true,
	
	--RandomMissionDoLandBattle=false, 
	TeleportToSafeHouseMinDistance = 30,
	--RemoveWeaponsAndUpgradesAtMissionStart = true,
	IsDefendTargetOnlyPlayersDamagePeds=true,
	--SpawnSafeHousePickups = {"WEAPON_COMBATPISTOL"},
	--SpawnSafeHouseComponents = {"COMPONENT_AT_PI_SUPP WEAPON_COMBATPISTOL","COMPONENT_COMBATPISTOL_CLIP_02 WEAPON_COMBATPISTOL"},
	SpawnSafeHouseComponents = {"COMPONENT_COMBATPISTOL_CLIP_02 WEAPON_COMBATPISTOL"},

	--SafeHouseCrackDownModeHealthAmount=200,
	--IsDefendTargetDrivetoBlip=true,
	--TeleportToSafeHouseOnMissionStart = false,
	RandomMissionSpawnRadius = 300.0, --keep a float for enemy ped wandering to work
	RandomMissionMaxPedSpawns = 0,
	RandomMissionMinPedSpawns = 0,
	RandomMissionMaxVehicleSpawns = 9,
	RandomMissionMinVehicleSpawns = 4,
	RandomMissionChanceToSpawnVehiclePerTry = 100,
	RandomMissionAircraftChance = 10,
	RandomMissionBossChance=20,
	--RandomMissionWeapons = {0xDD5DF8D9,0x99B507EA,0xCD274149,0x1B06D571},
	IsDefendTargetRandomPedWeapons = {0x1B06D571},
	UseSafeHouseLocations = false,
	IsDefendTargetPassenger=false,
	IsDefendTargetGoalDistance=50.0,
	--RandomMissionDoBoats = true,
	MissionTriggerRadius = 20.0,
	RemoveWeaponsAndUpgradesAtMissionStart = true,
	SafeHouseCrackDownModeHealthAmount=1000,
	
	
	SMS_Subject="The Gauntlet v3",
	SMS_Message="We need help to ensure that an asset and their vehicle survive an attack",
	SMS_Message2="They will need an escort. Are you up for this?",
	--SMS_Message3="Anyone up for this?",	
		
	--SMS_ContactPics={"CHAR_AGENT14",
	--},
	--SMS_ContactNames={"Agency Contact",
	--},
	SMS_NoFailedMessage=true,
	SMS_NoPassedMessage=true,
	SMS_FailedSubject="HAHA",
	SMS_FailedMessage="You should have stayed away, this is much bigger than you",
	SMS_PassedSubject="Thank you",
	SMS_PassedMessage="Los Santos is safe and sound from the attack",			
	
	
	MissionTriggerStartPoint = { x = 1515.16, y = 3064.27, z = 41.3},
	SafeHouseVehicles = 

{
	"dune3",
	"kuruma2",
	"insurgent3",
	--"khanjali",
	"blazer5",
	--"oppressor2",
	"oppressor",
	--"apc",
	"barrage",
	"menacer",
},
--RandomMissionVehicles={"blazer"},

SpawnSafeHousePickups = {"WEAPON_COMBATPISTOL","weapon_heavysniper_mk2","weapon_marksmanrifle_mk2","weapon_heavysniper","weapon_combatmg_mk2","weapon_combatmg",
"weapon_carbinerifle_mk2","weapon_assaultrifle_mk2","weapon_specialcarbine_mk2","weapon_bullpuprifle_mk2","weapon_advancedrifle","weapon_pumpshotgun_mk2","weapon_assaultshotgun",
"weapon_smg_mk2","weapon_assaultsmg","weapon_pistol_mk2","weapon_snspistol_mk2","weapon_revolver_mk2","WEAPON_KNIFE","GADGET_NIGHTVISION","WEAPON_GRENADE","WEAPON_PROXMINE","WEAPON_STICKYBOMB","WEAPON_PIPEBOMB","WEAPON_FLARE",
"weapon_molotov","WEAPON_RPG","GADGET_PARACHUTE","weapon_microsmg"
},
SpawnSafeHouseComponents = {"COMPONENT_AT_PI_SUPP WEAPON_COMBATPISTOL","COMPONENT_COMBATPISTOL_CLIP_02 WEAPON_COMBATPISTOL","COMPONENT_HEAVYSNIPER_MK2_CLIP_EXPLOSIVE weapon_heavysniper_mk2",
"COMPONENT_AT_SCOPE_MAX weapon_heavysniper_mk2",
"COMPONENT_HEAVYSNIPER_MK2_CLIP_EXPLOSIVE weapon_heavysniper_mk2",
--"COMPONENT_AT_SCOPE_THERMAL weapon_heavysniper_mk2",
"COMPONENT_AT_SCOPE_LARGE_FIXED_ZOOM_MK2 weapon_marksmanrifle_mk2","COMPONENT_MARKSMANRIFLE_MK2_CLIP_FMJ weapon_marksmanrifle_mk2","COMPONENT_AT_SCOPE_MAX weapon_heavysniper",
"COMPONENT_AT_SCOPE_MEDIUM_MK2 weapon_combatmg_mk2","COMPONENT_COMBATMG_MK2_CLIP_INCENDIARY weapon_combatmg_mk2","COMPONENT_COMBATMG_CLIP_02 weapon_combatmg","COMPONENT_AT_SCOPE_MEDIUM weapon_combatmg",
"COMPONENT_CARBINERIFLE_MK2_CLIP_ARMORPIERCING weapon_carbinerifle_mk2","COMPONENT_AT_SCOPE_MEDIUM_MK2 weapon_carbinerifle_mk2",
"COMPONENT_ASSAULTRIFLE_MK2_CLIP_FMJ weapon_assaultrifle_mk2","COMPONENT_AT_SCOPE_MEDIUM_MK2 weapon_assaultrifle_mk2",
"COMPONENT_SPECIALCARBINE_MK2_CLIP_INCENDIARY weapon_specialcarbine_mk2","COMPONENT_AT_SCOPE_MEDIUM_MK2 weapon_specialcarbine_mk2",
"COMPONENT_BULLPUPRIFLE_MK2_CLIP_ARMORPIERCING weapon_bullpuprifle_mk2","COMPONENT_AT_SCOPE_SMALL_MK2 weapon_bullpuprifle_mk2",
"COMPONENT_ADVANCEDRIFLE_CLIP_02 weapon_advancedrifle","COMPONENT_AT_SCOPE_SMALL weapon_advancedrifle",
"COMPONENT_PUMPSHOTGUN_MK2_CLIP_EXPLOSIVE weapon_pumpshotgun_mk2","COMPONENT_AT_SCOPE_SMALL_MK2 weapon_pumpshotgun_mk2",
"COMPONENT_ASSAULTSHOTGUN_CLIP_02 weapon_assaultshotgun",
"COMPONENT_SMG_MK2_CLIP_HOLLOWPOINT weapon_smg_mk2","COMPONENT_AT_SCOPE_SMALL_SMG_MK2 weapon_smg_mk2",
"COMPONENT_ASSAULTSMG_CLIP_02 weapon_assaultsmg","COMPONENT_AT_SCOPE_MACRO weapon_assaultsmg",
"COMPONENT_PISTOL_MK2_CLIP_HOLLOWPOINT weapon_pistol_mk2","COMPONENT_AT_PI_RAIL weapon_pistol_mk2",
"COMPONENT_SNSPISTOL_MK2_CLIP_FMJ weapon_snspistol_mk2","COMPONENT_AT_PI_RAIL_02 weapon_snspistol_mk2",
"COMPONENT_REVOLVER_MK2_CLIP_INCENDIARY weapon_revolver_mk2","COMPONENT_AT_SCOPE_MACRO_MK2 weapon_revolver_mk2",
"COMPONENT_MICROSMG_CLIP_02 weapon_microsmg"
} ,

	
	
	
	--IsRandomSpawnAnywhere = true,
	
	--what x and y coordinate range should these mission spawn in?
	--RandomLocation = true, --for completely random location..

	
	Blip = {
      Title = "Objective",
      Position = { x = -10000, y = 0, z =  0},
      Icon     = 58,
      Display  = 4,
      Size     = 1.2,
      Color    = 1,
    },
	
	Blip2 = {
      Title = "Objective",
      Position = { x = -10000, y = 0, z =  0},
      Icon     = 58,
      Display  = 4,
      Size     = 1.2,
      Color    = 1,
    },

    Marker = {
      Type     = 1,
      Position = { x = -10000, y = 0, z = 0}, 
      Size     = {x = 6.0, y = 6.0, z = 2.0},
      Color    = {r = 100, g = 100, b = 204},
      DrawDistance = 500.0,
    },
		BlipS = { --safehouse blip
		  Title = "Mission Safehouse",
		  Position = {  x = 1532.73, y = 3093.11, z = 41.08}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 417,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 2,
		  Alpha	 =80, --Used for AddBlipForRadius with IsDefend Missions
		},	
		 MarkerS = { --safehouse marker
		  Type     = 1,
		  Position = { x = 1532.73, y = 3093.11, z = 40.08 },  --{  x = 1944.96, y = 3150.6, z = 46.77}, 
		  Size     = {x = 2.0, y = 2.0, z = 2.0},
		  Color    = {r = 117, g = 218, b = 255},
		  DrawDistance = 200.0,
		},
		BlipSL = { --safehouse Vehicle blip 
		  Title = "Mission Vehicle Safehouse",
		  Position = { x = 1480.63, y = 3167.93, z = 40.99}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 421,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},
		BlipSB = { --safehouse boat blip 
		  Title = "Mission Boat Safehouse",
		  Position = {x = 1481.84, y = 3873.37, z = 30.04}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		 Icon     = 404,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},		
	

	
	Props = { 
		--**need a stub entry set for the random prop**
		{ id=1, Name="",Position = { x = 0, y = 0, z = 0, heading = 0 }},
	
    },
	
	Peds = {
		--**need a stub entry set for the random ped hostage for HostageRescue=true**
      {id = 1, Position = { x = 0, y = 0, z = 0, heading = 0 }},
     },
	 
	Vehicles = { 
		
	
    },	 
	

	Pickups = {
		
	},
	MissionPickups = {
		
		
	},
	
	RandomMissionPositions = { 
	
	{  x = 1318.13, y = 3624.67, z = 33.5,  MissionTitle="The Gauntlet v3",
		Blip2 = { --safehouse blip
		  Title = "Mission Start",
		  Position = { x = 1515.16, y = 3064.27, z = 41.3}, -- x = 2365.07, y = 2958.56, z = 49.06 --{ x = 1944.96, y = 3150.6, z = 46.77}, --x = 1345.43, y = 3152.51, z = 40.41
		  Icon     = 58,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 1,
		  Alpha	 =80,

		  --Used for AddBlipForRadius with IsDefend Missions
		},
		--[[Blip = { --safehouse blip
		  Title = "Destination",
		  Position = { x = 890.31, y = 3717.53, z = 29.66}, -- x = 2365.07, y = 2958.56, z = 49.06 --{ x = 1944.96, y = 3150.6, z = 46.77}, --x = 1345.43, y = 3152.51, z = 40.41
		  Icon     = 38,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 1,
		  Alpha	 =80,

		  --Used for AddBlipForRadius with IsDefend Missions
		},		]]--
		
	DefendTargetInVehicle = true,
	--DefendTargetVehicleIsBoat=true,
	DefendTargetVehicleMoveSpeedRatio = 0.5, --have vehicle move at 1/2 top speed

	}, 

	},

  }, 

 Mission35 = {
    
	StartMessage = "Penetrate the mercenaries bunker to stop them~n~launching a nuke at Los Santos",
	FinishMessage = "Mission Completed!",
	MissionTitle = "Warhead Crisis",
	MissionMessage = "Penetrate the mercenaries bunker to stop them launching~n~a nuke at Los Santos",	
	Type = "ObjectiveRescue",
	ObjectiveRescueShortRangeBlip = true,	
	IndoorsMission = true,
	SafeHouseVehicleCount = 6,
	SafeHouseAircraftCount = 4,
	SafeHouseBoatCount = 3,
	MissionTriggerRadius = 1000.0,
	
	SMS_Subject="Warhead Crisis",
	SMS_Message="Mercenaries have a stolen nuke which they will be launching at Los Santor from their bunker",
	SMS_Message2="We need someone to penetrate the bunker in order to stop them and secure the nuke",
	SMS_Message3="Can we rely on you?",	
		
	--SMS_ContactPics={"CHAR_AGENT14",
	--},
	--SMS_ContactNames={"Agency Contact",
	--},
	SMS_NoFailedMessage=true,
	SMS_NoPassedMessage=true,
	SMS_FailedSubject="HAHA",
	SMS_FailedMessage="You should have stayed away, this is much bigger than you",
	SMS_PassedSubject="Thank you",
	SMS_PassedMessage="Los Santos is safe and sound from the attack",	
	
	SafeHouseVehicles = {
	"kuruma2",
	"insurgent3",
	},
	SafeHouseAircraft = 
	{
	"hydra",
	"havok",
	"thruster",
	},

    Blip = {
      Title = "Mission: Bunker Entrance",
      Position = { x = -359.51, y = 4827.02, z = 143.34},
      Icon     = 58,
      Display  = 4,
      Size     = 1.2,
      Color    = 1,
    },

    Marker = {
      Type     = 1,
      Position = { x = 370.85, y = 6307.4, z = -161.54}, 
      Size     = {x = 6.0, y = 6.0, z = 2.0},
      Color    = {r = 100, g = 100, b = 204},
      DrawDistance = 100.0,
    },
		BlipS = { --safehouse blip 
		  Title = "Mission Safehouse",
		  Position = {x = -2108.16, y = 3275.45, z = 38.73}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 417,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 2,
		  Alpha	 =80, 
		},	
		 MarkerS = { --safehouse marker
		  Type     = 1,
		  Position = { x = -2108.16, y = 3275.45, z = 37.73},  --{  x = 1944.96, y = 3150.6, z = 46.77}, 
		  Size     = {x = 6.0, y = 6.0, z = 2.0},
		  Color    = {r = 117, g = 218, b = 255},
		  DrawDistance = 200.0,
		},
		BlipSL = { --safehouse Vehicle blip 
		  Title = "Mission Vehicle Safehouse",
		  Position = { x = -2451.21, y = 3134.29, z = 32.82, heading = 156.25}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 421,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},
		BlipSB = { --safehouse boat blip 
		  Title = "Mission Boat Safehouse",
		  Position = {x = -3238.09, y = 3380.0, z = 0.18}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		 Icon     = 404,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},
	
	--***Must Set 'realId' too, which must is always the same as 'id' for props to not float***
	Props = {
			{ id=1,  Name = "xm_prop_x17_torpedo_case_01", isObjective=true, Position = {x = 524.72, y = 5907.4, z = -157.23, heading = 319.23}},
			{ id=2,  Name = "xm_prop_x17_torpedo_case_01", isObjective=true, Position = {x = 381.88, y = 5943.55, z = -158.27, heading = 267.15}},
			{ id=3,  Name = "xm_prop_x17_torpedo_case_01", isObjective=true, Position = {x = 419.08, y = 5941.99, z = -158.27, heading = -0.28}},
			{ id=4,  Name = "xm_prop_x17_torpedo_case_01", isObjective=true, Position = {x = 330.03, y = 5942.03, z = -158.27, heading = 180.28}},
			{ id=5,  Name = "xm_prop_x17_res_pctower", isObjective=true, Position = {x = 260.62, y = 6162.75, z = -146.42, heading = 90.24}},						
			{ id=6,  Name = "xm_prop_x17_res_pctower", isObjective=true, Position = {x = 227.77, y = 6162.75, z = -146.42, heading = 270.8}},	
			{ id=7,  Name = "xm_prop_x17_res_pctower", isObjective=true, Position = {x = 245.43, y = 6146.75, z = -146.42, heading = 360.42}},	
			{ id=8,  Name = "xm_prop_x17_res_pctower", isObjective=true, Position = {x = 245.49, y = 6181.11, z = -146.42, heading = 183.89}},	
			{ id=9,  Name = "hei_prop_mini_sever_01", isObjective=true, Position = { x = 282.99, y = 6194.19, z = -154.42, heading = -0.00 }},			
			{ id=10,  Name = "hei_prop_mini_sever_01", isObjective=true, Position = { x = 205.4, y = 6194.25, z = -154.42, heading = 0.00 }},
			{ id=11,  Name = "hei_prop_mini_sever_01", isObjective=true, Position = { x = 205.57, y = 6133.5, z = -154.42, heading = 180.00 }},
			{ id=12,  Name = "hei_prop_mini_sever_01", isObjective=true, Position = { x = 283.02, y = 6133.54, z = -154.42, heading = 180.00 }},
			{ id=13,  Name = "hei_prop_hst_usb_drive", isObjective=true,Position = {x = 370.94, y = 6307.35, z = -160.54, heading = 124.42 }},
			{ id=14,  Name = "hei_prop_hst_usb_drive_light", Position = {x = 370.94, y = 6307.35, z = -160.54, heading = 124.42}},	
			{ id=15,  Name = "xm_prop_x17_torpedo_case_01", isObjective=true, Position = {x = 398.08, y = 5913.13, z = -157.3, heading = 258.16}},	
			{ id=16,  Name = "xm_prop_x17_torpedo_case_01",  isObjective=true,Position = {x = 419.43, y = 5906.71, z = -157.31, heading = 367.45}},	
    },
	
	
	



	
	Pickups = {
	},
	MissionPickups = {
		
	},	
		
	

    Peds = {
		{id = 1,  Weapon = 0xFAD1F1C9,  modelHash = "U_M_Y_Tattoo_01",  x = 581.79, y = 5965.57, z = -153.32, heading = 168.52  },
		{id = 2,  Weapon = 0xAF113F99,  modelHash = "s_m_y_xmech_02", x = 572.16, y = 5972.09, z = -153.32, heading = 171.29  },
		{id = 3,  Weapon = 0xAF113F99,  modelHash = "s_m_y_ammucity_01", x = 558.19, y = 5956.11, z = -157.99, heading = 201.44 },
		{id = 4,  Weapon = 0xEFE7E2DF,  modelHash = "G_M_M_ChiCold_01", x = 553.66, y = 5956.71, z = -158.09, heading = 307.29},
		{id = 5,  Weapon = 0xAF113F99,  modelHash = "s_m_y_xmech_02_mp", x = 555.68, y = 5922.74, z = -157.9, heading = 46.62  },
		{id = 6,  Weapon = 0xEFE7E2DF,  modelHash = "s_m_y_robber_01", x = 559.63, y = 5926.0, z = -157.9, heading = 50.34},	
		{id = 7,  Weapon = 0xE284C527,  modelHash = "g_m_y_lost_01",x = 533.99, y = 5937.42, z = -158.07, heading = 230.11 },
		{id = 8,  Weapon = 0xFAD1F1C9,  modelHash = "g_m_y_lost_02",x = 533.07, y = 5933.18, z = -158.07, heading = 226.83 },
		{id = 9,  Weapon = 0x7F229F94,  modelHash = "g_m_y_lost_03",x = 553.16, y = 5917.31, z = -157.9, heading = 54.23 },	
		{id = 10,  Weapon = 0xDBBD7280,  modelHash = "s_m_y_dealer_01",x = 531.54, y = 5898.68, z = -158.09, heading = 367.19},	
		{id = 11,  Weapon = 0x7F229F94,  modelHash = "g_f_y_lost_01",x = 527.91, y = 5923.28, z = -158.06, heading = 193.17 },		
		{id = 12,   modelHash = "mp_m_bogdangoon",isBoss=true, x = 498.41, y = 5938.22, z = -158.28, heading = 165.79},	
		{id = 13,   modelHash = "mp_m_weapexp_01",isBoss=true,x = 495.46, y = 5930.97, z = -158.29, heading = 306.82 },	
		{id = 14,  Weapon = 0xBFE256D4,  modelHash = "u_f_y_bikerchic", x = 512.07, y = 5920.63, z = -158.28, heading = 326.23},	
		{id = 15,  Weapon = 0xCB96392F,  modelHash = "U_M_Y_Tattoo_01",x = 518.65, y = 5925.72, z = -158.28, heading = 80.67  },				
		{id = 16,  Weapon = 0xA914799,  modelHash = "s_m_y_xmech_02",x = 480.19, y = 5948.9, z = -158.46, heading = 152.35 },		
		{id = 17,  Weapon = 0xB1CA77B1,  modelHash = "s_m_y_ammucity_01",x = 447.83, y = 5923.51, z = -158.27, heading = 329.33 },
		{id = 18,  Weapon = 0xA914799,  modelHash = "G_M_M_ChiCold_01",x = 437.75, y = 5918.56, z = -158.46, heading = 274.5 },		
		{id = 19,  Weapon = 0x2BE6766B,  modelHash = "s_m_y_robber_01",x = 438.25, y = 5915.35, z = -158.46, heading = 298.82 },
		{id = 20,  Weapon = 0x0A3D4D34,  modelHash = "g_m_y_lost_01",x = 455.18, y = 5956.97, z = -158.46, heading = 155.12 },
		{id = 21,  Weapon = 0x3AABBBAA,  modelHash = "g_m_y_lost_02",x = 442.1, y = 5948.76, z = -158.26, heading = 327.64  },
		{id = 22,  Weapon = 0x0781FE4A,  modelHash = "g_m_y_lost_03", x = 442.32, y = 5957.02, z = -158.25, heading = 168.52   },
		{id = 23,  Weapon = 0x7FD62962,  modelHash = "g_m_y_lost_02",x = 437.84, y = 5908.51, z = -158.25, heading = 255.04  },
		{id = 24,  Weapon = 0x394F415C,  modelHash = "g_m_y_lost_01", x = 445.57, y = 5906.75, z = -158.26, heading = 45.31   },
		{id = 25,  Weapon = 0xC0A3098D,  modelHash = "s_m_y_xmech_02_mp", x = 422.52, y = 5900.66, z = -157.99, heading = 253.6  },
		{id = 26,  Weapon = 0xC0A3098D,  modelHash = "g_f_y_lost_01",  x = 409.39, y = 5912.44, z = -158.11, heading = 205.92  },	
		{id = 27,  Weapon = 0xFAD1F1C9,  modelHash = "U_M_Y_Tattoo_01",  x = 390.21, y = 5920.91, z = -158.12, heading = 176.35  },	
		{id = 28,  Weapon = 0x12E82D3D,  modelHash = "G_M_M_ChiCold_01",  x = 361.72, y = 5924.72, z = -158.09, heading = 181.13   },	
		{id = 29,  Weapon = 0xAF113F99,  modelHash = "s_m_y_robber_01", x = 437.81, y = 5941.94, z = -158.27, heading = 83.27  },	
		{id = 30,  Weapon = 0xAF113F99,  modelHash = "u_f_y_bikerchic", x = 436.26, y = 5938.74, z = -158.27, heading = 77.63   },	
		{id = 31,  Weapon = 0xAF113F99,  modelHash = "s_m_y_xmech_02", x = 423.87, y = 5957.48, z = -158.27, heading = 260.58   },	
		{id = 32,  Weapon = 0xA914799,  modelHash = "s_m_y_dealer_01", x = 401.32, y = 5957.08, z = -158.27, heading = 178.04  },
		{id = 33,  Weapon = 0x7F229F94,  modelHash = "g_m_y_lost_03", x = 417.77, y = 5931.07, z = -158.27, heading = -4.24  },
		{id = 34,  Weapon = 0x7F229F94,  modelHash = "g_m_y_lost_01", x = 356.84, y = 5957.28, z = -158.27, heading = 208.07  },
		{id = 35,  Weapon = 0xFAD1F1C9,  modelHash = "g_m_y_lost_02",  x = 374.5, y = 5955.93, z = -158.27, heading = 177.73  },
		{id = 36,  Weapon = 0x9D61E50F,  modelHash = "g_f_y_lost_01", x = 397.02, y = 5929.28, z = -158.27, heading = -3.57  },		
		{id = 37,  Weapon = 0xFAD1F1C9,  modelHash = "s_m_y_ammucity_01", x = 342.42, y = 5955.82, z = -158.27, heading = 176.93  },
		{id = 38,  Weapon = 0xAF113F99,  modelHash = "s_m_y_ammucity_01",  x = 307.53, y = 5947.39, z = -158.27, heading = 270.88  },
		{id = 39,  Weapon = 0xB1CA77B1,  modelHash = "s_m_y_ammucity_01", x = 307.3, y = 5934.72, z = -158.27, heading = 258.44  },		
		{id = 40,   modelHash = "mp_m_bogdangoon",isBoss=true, x = 333.81, y = 5925.85, z = -158.25, heading = 62.01},	
		{id = 41,   modelHash = "mp_m_weapexp_01",isBoss=true,x = 315.12, y = 5965.36, z = -158.24, heading = 50.65 },	
		{id = 42,  Weapon = 0x7FD62962,  modelHash = "s_m_y_dealer_01", x = 318.72, y = 5908.81, z = -158.24, heading = 369.01  },	
		{id = 43,  Weapon = 0x7FD62962,  modelHash = "s_m_y_xmech_02_mp", x = 286.33, y = 5908.76, z = -158.98, heading = -29.67  },	
		{id = 44,  Weapon = 0x0781FE4A,  modelHash = "g_m_y_lost_03", x = 244.4, y = 5942.8, z = -159.5, heading = 284.28  },
		{id = 45,  Weapon = 0xFAD1F1C9,  modelHash = "s_m_y_ammucity_01", x = 250.6, y = 5966.11, z = -156.57, heading = 174.67  },	
		{id = 46,  Weapon = 0x969C3D67,  modelHash = "s_m_y_ammucity_01", x = 250.13, y = 5966.02, z = -159.45, heading = 180.79  },
		{id = 47,  Weapon =  0xDBBD7280,  modelHash = "s_m_y_ammucity_01", x = 314.44, y = 5996.67, z = -158.71, heading = 284.49  },
		{id = 48,  Weapon =  0x0781FE4A,  modelHash = "s_m_y_ammucity_01", x = 324.14, y = 6000.8, z = -157.84, heading = 83.24 },
		{id = 49,  modelHash = "ig_clay",isBoss=true,x = 241.95, y = 6054.34, z = -159.42, heading = 86.28 },
		{id = 50,  modelHash = "mp_m_exarmy_01",isBoss=true,x = 233.7, y = 6052.02, z = -159.41, heading = 306.18  },
		{id = 51,  modelHash = "ig_josef",isBoss=true,x = 242.1, y = 6096.22, z = -159.43, heading = 272.52 },
		{id = 52,  modelHash = "ig_terry",isBoss=true,x = 242.18, y = 6099.55, z = -159.43, heading = 237.63 },	
		{id = 53,  modelHash = "csb_jackhowitzer",isBoss=true, x = 254.25, y = 6105.82, z = -159.42, heading = 267.22 },
		{id = 54,  modelHash = "ig_cletus",isBoss=true, x = 262.78, y = 6106.07, z = -159.41, heading = 84.32 },
		{id = 55,  Weapon = 0xB1CA77B1,  modelHash = "g_f_y_lost_01", x = 247.77, y = 6124.75, z = -159.42, heading = 263.25 },	
		{id = 56,  Weapon = 0x0781FE4A,  modelHash = "u_f_y_bikerchic", x = 269.75, y = 6124.41, z = -159.42, heading = 63.9    },		
		{id = 57,  Weapon = 0xC734385A,  modelHash = "U_M_Y_Tattoo_01",x = 269.44, y = 6130.19, z = -159.42, heading = 81.01    },
		{id = 58,  modelHash = "u_m_y_juggernaut_01",isBoss=true, x = 245.48, y = 6165.79, z = -159.42, heading = 1.54 },
		{id = 59,  modelHash = "u_m_y_juggernaut_01",isBoss=true, x = 245.23, y = 6162.3, z = -159.42, heading = 160.7 },
		{id = 60,  Weapon = 0xAF113F99,  modelHash = "s_m_y_ammucity_01",x = 230.25, y = 6130.93, z = -159.42, heading = 352.29    },
		{id = 61,  Weapon = 0xAF113F99,  modelHash = "s_m_y_ammucity_01",x = 230.15, y = 6195.9, z = -159.42, heading = 174.76    },
		{id = 62,  Weapon = 0xDBBD7280,  modelHash = "s_m_y_ammucity_01",x = 250.25, y = 6139.56, z = -160.42, heading = 298.6    },
		{id = 63,  Weapon = 0xDBBD7280,  modelHash = "s_m_y_ammucity_01",x = 272.24, y = 6175.06, z = -158.42, heading = 73.7     },
		{id = 63,  Weapon = 0xAF113F99,  modelHash = "s_m_y_ammucity_01",x = 258.42, y = 6196.61, z = -159.42, heading = 170.84     },
		{id = 64,  Weapon = 0xAF113F99,  modelHash = "s_m_y_ammucity_01",x = 269.08, y = 6202.07, z = -159.42, heading = 82.96     },
		{id = 65,  Weapon = 0xDBBD7280,  modelHash = "s_m_y_ammucity_01",x = 248.76, y = 6206.18, z = -159.42, heading = 266.57     },
		{id = 66,  Weapon = 0xDBBD7280,  modelHash = "s_m_y_ammucity_01",x = 268.73, y = 6207.06, z = -159.42, heading = 87.61     },
		{id = 67,  Weapon = 0xAF113F99,  modelHash = "s_m_y_ammucity_01",x = 277.19, y = 6144.67, z = -154.42, heading = 55.84   },	
		{id = 68,  Weapon = 0xAF113F99,  modelHash = "s_m_y_ammucity_01", x = 251.56, y = 6147.15, z = -154.42, heading = 279.44   },	
		{id = 69,  Weapon = 0xAF113F99,  modelHash = "s_m_y_ammucity_01", x = 211.85, y = 6142.91, z = -154.42, heading = 295.94    },
		{id = 70,  Weapon = 0xAF113F99,  modelHash = "s_m_y_ammucity_01", x = 277.54, y = 6143.21, z = -154.42, heading = 48.84   },	
		{id = 71,  Weapon = 0xAF113F99,  modelHash = "s_m_y_ammucity_01", x = 264.91, y = 6191.9, z = -154.42, heading = 168.46    },
		{id = 72,  modelHash = "u_m_y_juggernaut_01",isBoss=true, x = 244.17, y = 6162.7, z = -152.42, heading = 363.01 },
		{id = 73,  Weapon = 0xDBBD7280,  modelHash = "s_m_y_ammucity_01", x = 251.85, y = 6245.01, z = -160.02, heading = 259.79    },
		{id = 74,  Weapon = 0xAF113F99,  modelHash = "s_m_y_ammucity_01", x = 265.91, y = 6223.58, z = -160.02, heading = 86.45    },
		{id = 75,  Weapon = 0xB1CA77B1,  modelHash = "s_m_y_ammucity_01", x = 266.56, y = 6258.29, z = -160.02, heading = 88.54    },
		{id = 76,  Weapon = 0xDBBD7280,  modelHash = "s_m_y_ammucity_01", x = 273.18, y = 6255.65, z = -160.22, heading = 4.43    },
		{id = 77,  Weapon = 0xDBBD7280,  modelHash = "s_m_y_ammucity_01", x = 292.27, y = 6257.57, z = -160.02, heading = 80.63    },
		{id = 78,  modelHash = "mp_m_exarmy_01",isBoss=true, x = 303.91, y = 6260.23, z = -160.22, heading = 112.79  },
		{id = 79,  Weapon = 0xAF113F99,  modelHash = "s_m_y_ammucity_01", x = 305.82, y = 6278.97, z = -160.02, heading = 172.81    },	
		{id = 80,  modelHash = "u_m_y_juggernaut_01",isBoss=true, x = 308.0, y = 6292.6, z = -160.15, heading = 119.61 },	
		{id = 81,  Weapon = 0xAF113F99,  modelHash = "s_m_y_ammucity_01",x = 307.37, y = 6309.54, z = -160.22, heading = 135.18   },	
		{id = 82,  Weapon = 0xAF113F99,  modelHash = "s_m_y_ammucity_01",x = 305.14, y = 6311.45, z = -160.22, heading = 166.73    },
		{id = 83,  Weapon = 0xDBBD7280,  modelHash = "s_m_y_ammucity_01",x = 319.32, y = 6310.63, z = -160.02, heading = 69.27   },	
		{id = 84,  Weapon = 0xDBBD7280,  modelHash = "s_m_y_ammucity_01",x = 336.25, y = 6310.65, z = -160.02, heading = 77.44    },
		{id = 85,   modelHash = "mp_m_bogdangoon",isBoss=true, x = 350.03, y = 6308.19, z = -160.05, heading = 35.51},	
		{id = 86,   modelHash = "mp_m_weapexp_01",isBoss=true,x = 352.06, y = 6308.61, z = -160.05, heading = 13.71 },	
		{id = 87,  modelHash = "u_m_y_juggernaut_01",isBoss=true,  x = 371.81, y = 6299.45, z = -159.93, heading = 358.11 },
		{id = 88,  modelHash = "u_m_y_juggernaut_01",isBoss=true, x = 373.71, y = 6315.31, z = -159.93, heading = 152.0 },
		{id = 89,  modelHash = "u_m_y_juggernaut_01",isBoss=true, x = 376.57, y = 6308.87, z = -159.96, heading = 89.42 },
		
		--{id = 90,  Weapon = 0xAF113F99,  modelHash = "s_m_y_ammucity_01", x = 691.52, y = 5953.8, z = -150.12, heading = 57.28 },
		--{id = 91,  Weapon = 0xAF113F99,  modelHash = "s_m_y_ammucity_01",  x = 254.06, y = 6197.55, z = -146.42, heading = 179.66 },	
		{id = 90, modelHash = "mp_m_exarmy_01",isBoss=true, x = 234.29, y = 6197.41, z = -146.42, heading = 177.52 },			
		--{id = 93,  Weapon = 0xAF113F99,  modelHash = "s_m_y_ammucity_01",  x = 209.65, y = 6181.04, z = -146.42, heading = 267.79 },
		{id = 91, modelHash = "mp_m_weapexp_01",isBoss=true, x = 209.69, y = 6146.65, z = -146.42, heading = 269.99},	
		--{id = 95,  Weapon = 0xAF113F99,  modelHash = "s_m_y_ammucity_01", x = 234.58, y = 6130.29, z = -146.42, heading = 359.2 },	
		{id = 92, modelHash = "ig_clay",isBoss=true, x = 253.93, y = 6130.59, z = -146.42, heading = 359.55},
		--{id = 97, Weapon = 0xAF113F99,  modelHash = "s_m_y_ammucity_01", x = 278.96, y = 6146.95, z = -146.42, heading = 94.76},
		{id = 93, modelHash = "mp_m_bogdangoon",isBoss=true, x = 278.4, y = 6181.14, z = -146.42, heading = 94.71},	
		
		{id = 94, Weapon = 0xAF113F99,  modelHash = "s_m_y_ammucity_01", x = 246.21, y = 6167.28, z = -146.42, heading = 84.25},
		{id = 95, Weapon = 0xAF113F99,  modelHash = "s_m_y_ammucity_01", x = 246.15, y = 6160.48, z = -146.42, heading = 103.41},
		
		{id = 96, Weapon = 0xAF113F99,  modelHash = "s_m_y_ammucity_01",  x = 222.18, y = 6198.53, z = -154.42, heading = 184.16},
		--{id = 102, Weapon = 0xAF113F99,  modelHash = "s_m_y_ammucity_01", x = 202.82, y = 6185.02, z = -154.42, heading = 273.87},
		
		{id = 97, Weapon = 0xAF113F99,  modelHash = "s_m_y_ammucity_01", x = 206.7, y = 6168.99, z = -154.42, heading = 267.23},
		--{id = 104, Weapon = 0xAF113F99,  modelHash = "s_m_y_ammucity_01", x = 206.79, y = 6158.61, z = -154.42, heading = 262.51},
		
		{id = 98, Weapon = 0xAF113F99,  modelHash = "s_m_y_ammucity_01", x = 222.52, y = 6129.43, z = -154.42, heading = -1.06},
		--{id = 106, Weapon = 0xAF113F99,  modelHash = "s_m_y_ammucity_01", x = 251.47, y = 6128.29, z = -154.42, heading = 88.04},
		
		{id = 99, Weapon = 0xAF113F99,  modelHash = "s_m_y_ammucity_01", x = 235.54, y = 6128.7, z = -154.42, heading = 255.16 },
		--{id = 108, Weapon = 0xAF113F99,  modelHash = "s_m_y_ammucity_01", x = 284.98, y = 6142.86, z = -154.42, heading = 91.26},
		
		{id = 100, Weapon = 0xAF113F99,  modelHash = "s_m_y_ammucity_01", x = 281.86, y = 6158.76, z = -154.42, heading = 89.53},
		--{id = 110, Weapon = 0xAF113F99,  modelHash = "s_m_y_ammucity_01", x = 282.14, y = 6169.25, z = -154.42, heading = 84.6},
		
		{id = 101, Weapon = 0xAF113F99,  modelHash = "s_m_y_ammucity_01", x = 266.09, y = 6198.87, z = -154.42, heading = 187.28},
		--{id = 112, Weapon = 0xAF113F99,  modelHash = "s_m_y_ammucity_01",x = 252.79, y = 6199.4, z = -154.42, heading = 84.16},
		
		{id = 102, Weapon = 0xAF113F99,  modelHash = "s_m_y_ammucity_01",x = 235.98, y = 6199.7, z = -154.42, heading = 262.12},
		--{id = 114, Weapon = 0xAF113F99,  modelHash = "s_m_y_ammucity_01",x = 285.19, y = 6185.27, z = -154.42, heading = 90.87},
		{id = 103, Weapon = 0xAF113F99,  modelHash = "s_m_y_ammucity_01",x = 266.36, y = 6129.33, z = -154.42, heading = 360.31},		

		
    },
	
	Events = {
	
		--[[{ 
		  Type="Vehicle",
		  Position = { x = -103.41, y = -438.73, z = 36.02, heading = 167.51 }, 
		  Size     = {radius=10000},
		  SpawnHeight =200.0,
		  FacePlayer = true,
		  --NumberPeds=10,
		  isBoss=false,
		  Target=false,
		  Vehicle="trailersmall",
		  Weapon=0xBD248B55,
		  SquadSpawnRadius=1.0,
		  Message="~h~~r~Warning: Psychotronic countermeasures deployed. Civilians may be hostile.",
		  --CheckGroundZ=true,
		},	]]--
	
		{ 
		  Type="Aircraft",
		  Position = {  x = -501.22, y = 4933.34, z = 147.31,heading = 50.39 }, 
		  Size     = {radius=1000.0},
		  SpawnHeight =50.0,
		  FacePlayer = true,
		  --NumberPeds=10,
		  isBoss=false,
		  Target=false,
		  Vehicle="valkyrie",
		 Weapon=0x13532244,
		  SquadSpawnRadius=1.0,
		  --CheckGroundZ=true,
		},	
		{ 
		  Type="Aircraft",
		  Position = { x = -121.25, y = 4604.54, z = 124.0,heading = 233.79 }, 
		  Size     = {radius=1000.0},
		  SpawnHeight =50.0,
		  FacePlayer = true,
		  --NumberPeds=10,
		  isBoss=false,
		  Target=false,
		  Vehicle="valkyrie",
		 -- Weapon=0x0781FE4A,
		  SquadSpawnRadius=1.0,
		  --CheckGroundZ=true,
		},
		
		{ 
		  Type="Vehicle",
		  Position = {  x = 1310.61, y = 5214.2, z = -79.13,heading = 88.94 }, 
		  Size     = {radius=100.0},
		  SpawnHeight =50.0,
		  FacePlayer = true,
		  --NumberPeds=10,
		  isBoss=false,
		  Target=false,
		  Vehicle="insurgent3",
		 Weapon=0x13532244,
		  SquadSpawnRadius=1.0,
		  --CheckGroundZ=true,
		},
		{ 
		  Type="Vehicle",
		  Position = {  x = 1310.61, y = 5214.2, z = -79.13,heading = 88.94 }, 
		  Size     = {radius=100.0},
		  SpawnHeight =50.0,
		  FacePlayer = true,
		  --NumberPeds=10,
		  isBoss=false,
		  Target=false,
		  Vehicle="insurgent3",
		 Weapon=0xBD248B55,
		  SquadSpawnRadius=1.0,
		  --CheckGroundZ=true,
		},
		{ 
		  Type="Vehicle",
		  Position = {  x = 1301.03, y = 5229.62, z = -79.23, heading = 154.26,}, 
		  Size     = {radius=100.0},
		  SpawnHeight =50.0,
		  FacePlayer = true,
		  --NumberPeds=10,
		  isBoss=false,
		  Target=false,
		  Vehicle="scarab",
		 Weapon=0xBD248B55,
		  SquadSpawnRadius=1.0,
		  --CheckGroundZ=true,
		},
		{ 
		  Type="Vehicle",
		  Position = {  x = 1104.4, y = 5521.81, z = -101.33,heading = 336.59 }, 
		  Size     = {radius=100.0},
		  SpawnHeight =50.0,
		  FacePlayer = true,
		  --NumberPeds=10,
		  isBoss=false,
		  Target=false,
		  nomods=true,
		  Vehicle="barrage",
		 Weapon=0xBD248B55,
		  SquadSpawnRadius=1.0,
		  --CheckGroundZ=true,
		},		
		
		{ 
		  Type="Vehicle",
		  Position = {x = 1150.65, y = 5504.15, z = -100.13, heading = 116.35 }, 
		  Size     = {radius=100.0},
		  SpawnHeight =50.0,
		  FacePlayer = true,
		  --NumberPeds=10,
		  isBoss=false,
		  Target=false,
		  Vehicle="halftrack",
		 Weapon=0xBD248B55,
		  SquadSpawnRadius=1.0,
		  --CheckGroundZ=true,
		},
		{ 
		  Type="Vehicle",
		  Position = { x = 576.26, y = 5959.26, z = -158.08, heading = 45.8 }, 
		  Size     = {radius=100.0},
		  SpawnHeight =50.0,
		  FacePlayer = true,
		  --NumberPeds=10,
		  isBoss=false,
		  Target=false,
		  Vehicle="khanjali",
		 Weapon=0xBD248B55,
		  SquadSpawnRadius=1.0,
		  --CheckGroundZ=true,
		},
		{ 
		  Type="Vehicle",
		  Position = { x = 713.23, y = 5866.99, z = -150.92, heading = 117.57 }, 
		  Size     = {radius=100.0},
		  SpawnHeight =50.0,
		  FacePlayer = true,
		  --NumberPeds=10,
		  isBoss=false,
		  Target=false,
		  Vehicle="bf400",
		 Weapon=0x0781FE4A,
		  SquadSpawnRadius=1.0,
		  --CheckGroundZ=true,
		},	
		{ 
		  Type="Vehicle",
		  Position = { x = 714.71, y = 5875.14, z = -150.79, heading = 125.06 }, 
		  Size     = {radius=100.0},
		  SpawnHeight =50.0,
		  FacePlayer = true,
		  --NumberPeds=10,
		  isBoss=false,
		  Target=false,
		  Vehicle="bf400",
		 Weapon=0x0781FE4A,
		  SquadSpawnRadius=1.0,
		  --CheckGroundZ=true,
		},				
		
	},	

    Vehicles = {
      -- ID: id of NPC | name: Name of Blip | BlipID: Icone of Blip | VoiceName: NPC Talk When near it | Ambiance: Ambiance of Shop | Weapon: Hash of Weapon | modelHash: Model | X: Position x | Y: Position Y | Z: Position Z | heading: Where Npc look
   	  --**IMPORTANT: make sure the id of the ped starts from 1, each Peds id in above, increments by 1 and matches that entries index if it were in an array***
	  --vehicles are not consistent, so use ExtraPeds at your own discretion.
	  --Below takes a ped with id=1 from Peds above and will put it in seatid = -2   
	 -- {id = 1, id2 = 1, Vehicle = "annihilator", modelHash = "S_M_M_ChemSec_01",  x = -1166.42, y = 4641.5, z = 145.11, heading = 210.07,driving=true,pilot=true},
	 -- {id = 2, id2 = 2, Vehicle = "toro2", modelHash = "s_m_y_ammucity_01",  x = -3014.83, y = -43.5, z = 0.13, heading = 151.19, driving=true},
	 --{id = 1, id2 = 1, Vehicle = "insurgent3", modelHash = "s_m_y_ammucity_01",  x = 3617.5, y = 3738.11, z = 28.69, heading = 28.27, Weapon=0x13532244,outside=true},
	 --{id = 1, id2 = 1, Vehicle = "valkyrie", modelHash = "s_m_y_ammucity_01", x = -501.22, y = 4933.34, z = 147.31 + 50,heading = 50.39,pilot=true, isAircraft=true,outside=true,Weapon=0x13532244},
	 --{id = 2, id2 = 2, Vehicle = "valkyrie", modelHash = "s_m_y_ammucity_01",x = -121.25, y = 4604.54, z = 124.0 + 50,heading = 233.79,pilot=true, isAircraft=true,outside=true,Weapon=0x13532244},
	--[[ {id = 1, id2 = 1, Vehicle = "insurgent3", modelHash = "s_m_y_ammucity_01",  x = 1310.61, y = 5214.2, z = -79.13,heading = 88.94, Weapon=0x13532244,},
	 {id = 2, id2 = 2, Vehicle = "scarab", modelHash = "s_m_y_ammucity_01", x = 1301.03, y = 5229.62, z = -79.23, heading = 154.26, Weapon=0x13532244,},
	 {id = 3, id2 = 3, Vehicle = "barrage", modelHash = "s_m_y_ammucity_01",   x = 1104.4, y = 5521.81, z = -101.33,heading = 336.59, Weapon=0x13532244,nomods=true},
	 {id = 4, id2 = 4, Vehicle = "halftrack", modelHash = "s_m_y_ammucity_01",x = 1150.65, y = 5504.15, z = -100.13, heading = 116.35, Weapon=0x13532244,},
	 {id = 5, id2 = 5, Vehicle = "khanjali", modelHash = "s_m_y_ammucity_01",x = 576.26, y = 5959.26, z = -158.08, heading = 45.8, Weapon=0x13532244,},
	{id = 6, id2 = 6, Vehicle = "bf400", modelHash = "g_m_y_lost_01",x = 713.23, y = 5866.99, z = -150.92, heading = 117.57, Weapon=0x0781FE4A,driving=true},
	 {id = 7, id2 = 7, Vehicle = "bf400", modelHash = "g_m_y_lost_02",x = 714.71, y = 5875.14, z = -150.79, heading = 125.06 , Weapon=0x0781FE4A,driving=true},
	 ]]--
    }
  },

  
  Mission36 = {
    
	StartMessage = "Infiltrate the Oligarch's yacht to obtain secret data~n~of the next terrorist attack",
	FinishMessage = "Mission Completed!",
	MissionTitle = "Chelsea",
	MissionMessage = "Infiltrate the Oligarch's yacht to obtain secret data~n~of the next terrorist attack",	
	Type = "ObjectiveRescue",	
	IndoorsMission = true,
	ObjectiveRescueShortRangeBlip = true,
	SafeHouseVehicleCount = 4,
	SafeHouseAircraftCount = 6,
	SafeHouseBoatCount = 6,
	SafeHouseSniperExplosiveRoundsGiven=2,
	MissionTriggerRadius = 1000.0,
	
	SMS_Subject="Chelsea",
	SMS_Message="We need someone to infiltrate an Oligarch's yacht, to seach for, and obtain secret data",
	SMS_Message2="We believe that he and his mercenaries have knowledge of an upcoming attack",
	SMS_Message3="Are you in?",	
		
	--SMS_ContactPics={"CHAR_AGENT14",
	--},
	--SMS_ContactNames={"Agency Contact",
	--},
	SMS_NoFailedMessage=true,
	SMS_NoPassedMessage=true,
	SMS_FailedSubject="HAHA",
	SMS_FailedMessage="You should have stayed away, this is much bigger than you",
	SMS_PassedSubject="Thank you",
	SMS_PassedMessage="Los Santos is safe and sound from the attack",	
	
	SafeHouseVehicles = {
	"insurgent3",
	"kuruma2",
	"stromberg",
	},
	SafeHouseAircraft = 
	{
	"hydra",
	"valkyrie",
	"thruster",
	},
	SafeHouseBoat = 
	{
	"dinghy4",
	"seashark",
	"toro2",
	"jetmax",
	"submersible2",
	"submersible",
	},

    Blip = {
      Title = "Mission: Oligarch's Yacht",
      Position = {x = -2084.08, y = -1018.0, z = 12.78},
      Icon     = 58,
      Display  = 4,
      Size     = 1.2,
      Color    = 1,
    },

    Marker = {
      Type     = 1,
      Position = {x = -2084.08, y = -1018.0, z = 11.78,}, 
      Size     = {x = 6.0, y = 6.0, z = 2.0},
      Color    = {r = 100, g = 100, b = 204},
      DrawDistance = 100.0,
    },
		BlipS = { --safehouse blip 
		  Title = "Mission Safehouse",
		  Position = { x = -1694.94, y = -3152.18, z = 23.32}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 417,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 2,
		  Alpha	 =80, 
		},	
		 MarkerS = { --safehouse marker
		  Type     = 1,
		  Position = { x = -1694.94, y = -3152.18, z = 23.32},  --{  x = 1944.96, y = 3150.6, z = 46.77}, 
		  Size     = {x = 6.0, y = 6.0, z = 2.0},
		  Color    = {r = 117, g = 218, b = 255},
		  DrawDistance = 200.0,
		},
		BlipSL = { --safehouse Vehicle blip 
		  Title = "Mission Vehicle Safehouse",
		  Position = { x = -1469.37, y = -2967.27, z = 13.3}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 421,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},
		BlipSB = { --safehouse boat blip 
		  Title = "Mission Boat Safehouse",
		  Position = {x = 413.98, y = -3411.47, z = 0.23}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		 Icon     = 404,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},
	
	--***Must Set 'realId' too, which must is always the same as 'id' for props to not float***
	Props = {
		{ id=1,  Name = "bkr_prop_biker_case_shut",isObjective=true, Position = { x = -2084.26, y = -1018.13, z = 12.78, heading = 58.1 }},
		{ id=2,  Name = "prop_laptop_lester2", isObjective=true,Position = {x = -2079.27, y = -1016.46, z = 9.59, heading = -27.21 }},
		{ id=3,  Name = "prop_cs_duffel_01b",isObjective=true, Position = {x = -2089.26, y = -1009.63, z = 5.88, heading = 68.97}},			
		{ id=4,  Name = "prop_dyn_pc",isObjective=true, Position = { x = -2072.00, y = -1020.89, z = 3.05, heading = 71.53}},	
    },
	
	
	



	
	Pickups = {
	},
	MissionPickups = {
		
	},	
		
	

    Peds = {
	
			{id = 1, Weapon =0xBFEFFF6D,  modelHash = "s_m_y_xmech_02",  x = -2048.04, y = -1036.54, z = 2.59, heading = 270.56  },
			{id = 2, Weapon =0x9D61E50F,  modelHash = "G_M_M_ChiCold_01",  x = -2044.84, y = -1025.85, z = 2.58, heading = 231.03  },
			{id = 3, Weapon =0xAF113F99,  modelHash = "g_m_y_lost_03",  x = -2060.84, y = -1032.4, z = 3.06, heading = 248.48  },
			{id = 4, Weapon =0xDBBD7280,  modelHash = "s_m_y_dealer_01", x = -2055.69, y = -1022.05, z = 3.06, heading = 248.06  },
			{id = 5, Weapon =0xFAD1F1C9,  modelHash = "s_m_y_ammucity_01", x = -2027.11, y = -1031.56, z = 2.57, heading = 190.13 },
			{id = 6, Weapon =0xEFE7E2DF,  modelHash = "u_f_y_bikerchic", x = -2030.22, y = -1041.19, z = 2.57, heading = 315.57  },
			{id = 7, Weapon =0xE284C527,  modelHash = "g_f_y_lost_01", x = -2021.23, y = -1043.44, z = 2.45, heading = 267.66,outside=true },
			{id = 8, Weapon =0xA914799,  modelHash = "g_m_y_lost_02", x = -2018.34, y = -1035.37, z = 2.45, heading = 262.8,outside=true  },
			{id = 9, Weapon =0xE284C527,  modelHash = "G_M_M_ChiCold_01", x = -2024.15, y = -1037.81, z = 5.57, heading = 253.58,outside=true },
			{id = 10, Weapon =0xA914799,  modelHash = "U_M_Y_Tattoo_01", x = -2032.06, y = -1035.2, z = 5.88, heading = 246.41,outside=true  },
			{id = 11, Weapon =0xAF113F99,  modelHash = "s_m_y_ammucity_01", x = -2066.45, y = -1031.31, z = 5.88, heading = 154.94, },
			{id = 12, Weapon =0xAF113F99,  modelHash = "s_m_y_robber_01",x = -2054.07, y = -1020.62, z = 5.88, heading = 338.94, },	
			{id = 13, Weapon = 0xC0A3098D,  modelHash = "g_m_y_lost_01",x = -2079.33, y = -1019.49, z = 5.88, heading = 292.28 },	
			{id = 14, Weapon = 0x7F229F94,  modelHash = "u_f_y_bikerchic",x = -2083.51, y = -1025.56, z = 5.88, heading = 361.8  },	
			{id = 15, Weapon = 0x3AABBBAA,  modelHash = "s_m_y_xmech_02_mp",x = -2090.3, y = -1013.8, z = 5.88, heading = 225.88  },
			{id = 16, Weapon = 0x2BE6766B,  modelHash = "s_m_y_dealer_01",x = -2101.03, y = -1013.82, z = 5.88, heading = 334.08  },
			{id = 17, Weapon = 0x83BF0278,  modelHash = "s_m_y_ammucity_01",x = -2093.58, y = -1009.93, z = 5.88, heading = 163.77  },
			{id = 18, Weapon = 0x0781FE4A,  modelHash = "g_m_y_lost_03", x = -2106.86, y = -1013.54, z = 5.89, heading = 306.24  },	
			{id = 19, Weapon = 0x63AB0442,  modelHash = "g_m_y_lost_02", x = -2100.66, y = -1012.6, z = 9.02, heading = 67.15,outside=true },	
			{id = 20, Weapon = 0xDBBD7280,  modelHash = "G_M_M_ChiCold_01",  x = -2088.51, y = -1016.63, z = 8.97, heading = 71.49  },	
			{id = 21, Weapon = 0xDBBD7280,  modelHash = "g_f_y_lost_01", x = -2083.01, y = -1018.83, z = 8.97, heading = 245.68 },				
			{id = 22, Weapon = 0xBFEFFF6D,  modelHash = "s_m_y_xmech_02",  x = -2063.7, y = -1031.6, z = 8.97, heading = 162.79  },	
			{id = 23, Weapon = 0xBFEFFF6D,  modelHash = "s_m_y_xmech_02_mp", x = -2059.47, y = -1019.64, z = 8.97, heading = 331.86 },
			{id = 24, modelHash = "mp_m_exarmy_01",isBoss=true,x = -2052.45, y = -1028.76, z = 8.97, heading = 244.38 },
			{id = 25, Weapon = 0x63AB0442,  modelHash = "U_M_Y_Tattoo_01",  x = -2062.84, y = -1032.35, z = 11.91, heading = 157.02   },	
			{id = 26, Weapon = 0x63AB0442,  modelHash = "g_m_y_lost_01", x = -2063.95, y = -1017.83, z = 11.91, heading = 338.6 },
			{id = 27, modelHash = "mp_m_bogdangoon",isBoss=true,x = -2076.31, y = -1025.27, z = 11.91, heading = 337.11 },
			{id = 28, modelHash = "mp_m_weapexp_01",isBoss=true,x = -2074.02, y = -1018.44, z = 11.91, heading = 159.52  },			
			{id = 29, Weapon = 0x83BF0278,  modelHash = "ig_milton", x = -2084.45, y = -1018.05, z = 12.78, heading = 239.9,target=true},
			{id = 30, Weapon = 0x83BF0278,  modelHash = "mp_m_boatstaff_01", x = -2083.54, y = -1023.17, z = 12.78, heading = 301.87},			
			{id = 31, Weapon = 0x83BF0278,  modelHash = "mp_m_boatstaff_01", x = -2080.91, y = -1014.95, z = 12.78, heading = 218.2},	
			{id = 32, Weapon = 0xDBBD7280,  modelHash = "s_m_y_ammucity_01", x = -2088.75, y = -1016.42, z = 12.78, heading = 66.51},				
			{id = 33, modelHash = "u_m_y_juggernaut_01",isBoss=true,x = -2069.8, y = -1018.86, z = 3.07, heading = 240.51  },	
		
    },
	
		Events = {
		
	--[[	{ 
		  Type="Vehicle",
		  Position = { x = -103.41, y = -438.73, z = 36.02, heading = 167.51 }, 
		  Size     = {radius=10000},
		  SpawnHeight =200.0,
		  FacePlayer = true,
		  --NumberPeds=10,
		  isBoss=false,
		  Target=false,
		  Vehicle="trailersmall",
		  Weapon=0xBD248B55,
		  SquadSpawnRadius=1.0,
		  Message="~h~~r~Warning: Psychotronic countermeasures deployed. Civilians may be hostile.",
		  --CheckGroundZ=true,
		},	
	]]--
		{ 
		  Type="Aircraft",
		  Position = {   x = -2048.15, y = -1029.45, z = 11.91, heading = 330.09,}, 
		  Size     = {radius=1000.0},
		  SpawnHeight =50.0,
		  FacePlayer = true,
		  --NumberPeds=10,
		  isBoss=false,
		  Target=false,
		  Vehicle="valkyrie",
		 Weapon=0x13532244,
		  SquadSpawnRadius=1.0,
		  --CheckGroundZ=true,
		}
		},	
		
	

    Vehicles = {
      -- ID: id of NPC | name: Name of Blip | BlipID: Icone of Blip | VoiceName: NPC Talk When near it | Ambiance: Ambiance of Shop | Weapon: Hash of Weapon | modelHash: Model | X: Position x | Y: Position Y | Z: Position Z | heading: Where Npc look
   	  --**IMPORTANT: make sure the id of the ped starts from 1, each Peds id in above, increments by 1 and matches that entries index if it were in an array***
	  --vehicles are not consistent, so use ExtraPeds at your own discretion.
	  --Below takes a ped with id=1 from Peds above and will put it in seatid = -2   
	 -- {id = 1, id2 = 1, Vehicle = "annihilator", modelHash = "S_M_M_ChemSec_01",  x = -1166.42, y = 4641.5, z = 145.11, heading = 210.07,driving=true,pilot=true},
	 -- {id = 2, id2 = 2, Vehicle = "toro2", modelHash = "s_m_y_ammucity_01",  x = -3014.83, y = -43.5, z = 0.13, heading = 151.19, driving=true},
	 --{id = 1, id2 = 1, Vehicle = "valkyrie", modelHash = "s_m_y_ammucity_01", x = -2048.15, y = -1029.45, z = 11.91 + 50, heading = 330.09, Weapon=0x13532244,outside=true,pilot=true, isAircraft=true,},
	 {id = 1, id2 = 1, Vehicle = "trailersmall2", modelHash = "s_m_y_ammucity_01",x = -2044.16, y = -1031.4, z = 11.98, heading = 247.32,outside=true,Weapon=0x13532244,nomods=true,driverfiringpattern=0xC6EE6B4C},
	 {id = 2, id2 = 2, Vehicle = "speeder2", modelHash = "U_M_Y_Tattoo_01", x = -1999.4, y = -1046.97, z = 0.27, heading = 322.71,outside=true,Weapon=0x624FE830},
	 {id = 3, id2 = 3, Vehicle = "toro2", modelHash = "g_m_y_lost_02",x = -2155.46, y = -1000.21, z = -0.22, heading = 170.18,outside=true,Weapon=0x624FE830},
	 {id = 4, id2 = 4, Vehicle = "seashark2", modelHash = "U_M_Y_Tattoo_01",  x = -2085.42, y = -1046.81, z = 0.25, heading = 248.53 ,outside=true,Weapon=0x624FE830},
	 {id = 5, id2 = 5, Vehicle = "seashark3", modelHash = "g_m_y_lost_02",x = -2053.59, y = -1005.43, z = -0.12, heading = 65.37,outside=true,Weapon=0x624FE830},
	 {id = 6, id2 = 6, Vehicle = "blazer5", modelHash = "s_m_y_robber_01",  x = -2005.63, y = -1017.83, z = 0.54, heading = 318.25 ,outside=true,Weapon=0x624FE830},
	 {id = 7, id2 = 7, Vehicle = "blazer5", modelHash = "s_m_y_xmech_02_mp",x = -2037.28, y = -986.47, z = 0.39, heading = -58.6,outside=true,Weapon=0x624FE830},
	 {id = 8, id2 = 8, Vehicle = "technical2", modelHash = "s_m_y_dealer_01", x = -1987.26, y = -1018.85, z = 0.38, heading = 281.22 ,outside=true,Weapon=0x13532244},
	 {id = 9, id2 = 9, Vehicle = "technical2", modelHash = "g_f_y_lost_01",x = -2024.86, y = -1079.19, z = 0.1, heading = 360.77,outside=true,Weapon=0x13532244},	 
	 --{id = 11, id2 = 11, Vehicle = "oppressor2", modelHash = "s_m_y_dealer_01", x = -2018.57, y = -1039.86, z = 2.45, heading = 245.53 ,outside=true,Weapon=0x13532244},
	 --{id = 12, id2 = 12, Vehicle = "oppressor2", modelHash = "g_f_y_lost_01",x = -2083.84, y = -1017.88, z = 15.99, heading = 70.03,outside=true,Weapon=0x13532244},	 
    }
  },  
  
 Mission37 = {
    
	StartMessage = "Stop the mercenaries from unleashing~n~bio-nanotechnology weapons on San Andreas",
	FinishMessage = "Mission Completed!",
	MissionTitle = "Deus Ex",
	MissionMessage = "Stop the mercenaries from unleashing bio-nanotechnology weapons on San Andreas",	
	Type = "ObjectiveRescue",
	ObjectiveRescueShortRangeBlip = true,	
	IndoorsMission = true,
	SafeHouseVehicleCount = 4,
	SafeHouseAircraftCount = 6,
	SafeHouseBoatCount = 6,
	MissionTriggerRadius = 1500.0,
	
	SMS_Subject="Deus Ex",
	SMS_Message="Mercs have captured an aircraft carrier and obtained the bio-nanotechnology weapons stored onboard",
	SMS_Message2="Stop the mercenaries from unleashing the bio-nanotechnology weapons on San Andreas",
	SMS_Message3="This will be a very difficult mission. Are you in?",	
		
	--SMS_ContactPics={"CHAR_AGENT14",
	--},
	--SMS_ContactNames={"Agency Contact",
	--},
	SMS_NoFailedMessage=true,
	SMS_NoPassedMessage=true,
	SMS_FailedSubject="HAHA",
	SMS_FailedMessage="You should have stayed away, this is much bigger than you",
	SMS_PassedSubject="Thank you",
	SMS_PassedMessage="Los Santos is safe and sound from the attack",		
	
	
	SafeHouseVehicles = {
	"stromberg",
	},
	SafeHouseAircraft = 
	{
	"hydra",
	},
	SafeHouseBoat = 
	{
	"dinghy4",
	"seashark",
	"toro2",
	"jetmax",
	"submersible2",
	"submersible",
	},

    Blip = {
      Title = "Mission: Aircraft Carrier",
      Position =  {x = 3072.42, y = -4740.15, z = 6.08},
      Icon     = 58,
      Display  = 4,
      Size     = 1.2,
      Color    = 1,
    },

    Marker = {
      Type     = 1,
      Position = { x = 3072.42, y = -4740.15, z = 5.08}, 
      Size     = {x = 6.0, y = 6.0, z = 2.0},
      Color    = {r = 100, g = 100, b = 204},
      DrawDistance = 100.0,
    },
		BlipS = { --safehouse blip 
		  Title = "Mission Safehouse",
		  Position = { x = -1694.94, y = -3152.18, z = 23.32}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 417,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 2,
		  Alpha	 =80, 
		},	
		 MarkerS = { --safehouse marker
		  Type     = 1,
		  Position = { x = -1694.94, y = -3152.18, z = 23.32},  --{  x = 1944.96, y = 3150.6, z = 46.77}, 
		  Size     = {x = 6.0, y = 6.0, z = 2.0},
		  Color    = {r = 117, g = 218, b = 255},
		  DrawDistance = 200.0,
		},
		BlipSL = { --safehouse Vehicle blip 
		  Title = "Mission Vehicle Safehouse",
		  Position = { x = -1469.37, y = -2967.27, z = 13.3}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 421,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},
		BlipSB = { --safehouse boat blip 
		  Title = "Mission Boat Safehouse",
		  Position = {x = 413.98, y = -3411.47, z = 0.23}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		 Icon     = 404,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},
	
	
	Props = {
		{ id=1,  Name = "hei_prop_carrier_bombs_1",isObjective=true, Position = { x = 3072.42, y = -4740.15, z = 6.08,heading=90.0 }},
		{ id=2,  Name = "hei_prop_carrier_bombs_1",isObjective=true, Position = { x = 3068.39, y = -4611.01, z = 15.26, heading = 282.07 }},
		{ id=3,  Name = "hei_prop_carrier_bombs_1",isObjective=true, Position = { x = 3115.99, y = -4787.75, z = 15.26, heading = 278.17 }},	
		{ id=4,  Name = "hei_prop_carrier_bombs_1",isObjective=true, Position = { x = 3041.6, y = -4629.31, z = 6.08, heading = 10.86}},
		{ id=5,  Name = "hei_prop_carrier_bombs_1",isObjective=true, Position = { x = 3036.53, y = -4678.63, z = 6.08, heading = 100.46}},
		{ id=6,  Name = "hei_prop_carrier_bombs_1",isObjective=true, Position = { x = 3065.11, y = -4709.08, z = 6.08, heading = 190.75}},	
		{ id=7,  Name = "hei_prop_carrier_bombs_1",isObjective=true, Position = {x = 3082.59, y = -4768.27, z = 6.08, heading = 14.79}},	
		{ id=8,  Name = "hei_prop_carrier_bombs_1",isObjective=true, Position = {x = 3089.63, y = -4705.97, z = 30.26, heading = 283.72}},		
    },
	
	
	



	
	Pickups = {
	},
	MissionPickups = {
		
	},	
		
	

    Peds = {
	
			{id = 1, Weapon =0x63AB0442,  modelHash = "s_m_y_xmech_02", x = 3088.16, y = -4706.76, z = 30.26, heading = 106.01,outside=true  },
			{id = 2, Weapon =0x63AB0442,  modelHash = "G_M_M_ChiCold_01", x = 3091.76, y = -4705.52, z = 30.26, heading = 284.58,outside=true  },
			
			{id = 3, Weapon =0xAF113F99,  modelHash = "g_m_y_lost_03", x = 3084.43, y = -4708.79, z = 15.25, heading = 247.05  },
			{id = 4, Weapon =0xDBBD7280,  modelHash = "s_m_y_dealer_01", x = 3083.55, y = -4706.85, z = 15.25, heading = 39.21  },
			{id = 5, Weapon =0xFAD1F1C9,  modelHash = "s_m_y_ammucity_01", x = 3096.05, y = -4706.88, z = 12.24, heading = 77.04 },
			{id = 6, Weapon =0xEFE7E2DF,  modelHash = "u_f_y_bikerchic", x = 3092.05, y = -4704.8, z = 12.24, heading = 101.64   },
			{id = 7, modelHash = "mp_m_bogdangoon",isBoss=true,x = 3091.7, y = -4702.23, z = 18.32, heading = 101.97 },			
			{id = 8, modelHash = "mp_m_exarmy_01",isBoss=true,x = 3082.98, y = -4704.87, z = 10.73, heading = 281.82 },	
			{id = 9, modelHash = "mp_m_weapexp_01",isBoss=true,x = 3077.56, y = -4706.22, z = 10.74, heading = 103.0  },	
			{id = 10, Weapon =0xE284C527,  modelHash = "g_f_y_lost_01", x = 3081.69, y = -4706.44, z = 10.73, heading = 291.81, },
			{id = 11, Weapon =0xA914799,  modelHash = "g_m_y_lost_02", x = 3079.39, y = -4706.09, z = 10.73, heading = 93.02,  },
			{id = 12, Weapon =0xE284C527,  modelHash = "G_M_M_ChiCold_01",x = 3088.95, y = -4739.59, z = 10.74, heading = 49.33, },
			{id = 13, Weapon =0xA914799,  modelHash = "U_M_Y_Tattoo_01", x = 3086.06, y = -4732.45, z = 10.74, heading = 187.15, },
			{id = 14, Weapon =0xAF113F99,  modelHash = "s_m_y_ammucity_01", x = 3086.81, y = -4736.64, z = 10.74, heading = 289.9, },
			
			{id = 15, Weapon =0xAF113F99,  modelHash = "s_m_y_robber_01",x = 3069.77, y = -4670.55, z = 10.74, heading = 185.65 },	
			{id = 16, Weapon = 0xC0A3098D,  modelHash = "g_m_y_lost_01",x = 3070.44, y = -4675.05, z = 10.74, heading = 284.44 },	
			{id = 17, Weapon = 0x7F229F94,  modelHash = "u_f_y_bikerchic",x = 3072.24, y = -4679.51, z = 10.74, heading = 2.52  },	
			
			{id = 18, Weapon = 0x3AABBBAA,  modelHash = "s_m_y_xmech_02_mp",x = 3081.36, y = -4684.39, z = 6.08, heading = 132.61  },
			{id = 19, Weapon = 0x2BE6766B,  modelHash = "s_m_y_dealer_01",x = 3080.37, y = -4687.03, z = 6.08, heading = 119.18  },
			{id = 20, Weapon = 0x83BF0278,  modelHash = "s_m_y_ammucity_01",x = 3074.24, y = -4694.85, z = 6.08, heading = 383.81  },
			
			{id = 21, Weapon = 0xDBBD7280,  modelHash = "g_m_y_lost_03", x = 3036.09, y = -4689.21, z = 6.08, heading = 269.75  },	
			{id = 22, Weapon = 0xDBBD7280,  modelHash = "g_m_y_lost_02", x = 3037.32, y = -4673.27, z = 6.08, heading = 184.25 },	
			{id = 23, Weapon = 0xDBBD7280,  modelHash = "G_M_M_ChiCold_01",  x = 3039.87, y = -4681.24, z = 6.08, heading = 376.41  },	
			{id = 24, Weapon = 0xDBBD7280,  modelHash = "g_f_y_lost_01", x = 3039.34, y = -4693.21, z = 6.08, heading = 303.15 },				
			
			{id = 25, Weapon = 0xBFEFFF6D,  modelHash = "s_m_y_xmech_02", x = 3037.77, y = -4679.34, z = 10.74, heading = 184.49  },	
			{id = 26, Weapon = 0xBFEFFF6D,  modelHash = "s_m_y_xmech_02_mp", x = 3039.48, y = -4687.93, z = 10.74, heading = 6.09 },
			{id = 27, Weapon = 0xDBBD7280,  modelHash = "U_M_Y_Tattoo_01",  x = 3038.79, y = -4682.33, z = 10.74, heading = 96.37   },
			
			{id = 28, Weapon = 0xBFEFFF6D,  modelHash = "s_m_y_xmech_02",x = 3026.27, y = -4625.69, z = 6.08, heading = 232.01  },	
			{id = 29, Weapon = 0xBFEFFF6D,  modelHash = "s_m_y_xmech_02_mp",x = 3047.74, y = -4622.28, z = 6.08, heading = 176.06 },
			{id = 30, Weapon = 0xDBBD7280,  modelHash = "U_M_Y_Tattoo_01",  x = 3046.45, y = -4680.04, z = 6.08, heading = 348.3   },			
			
			{id = 31, Weapon = 0x63AB0442,  modelHash = "U_M_Y_Tattoo_01",  x = 3078.81, y = -4805.84, z = 7.08, heading = 272.45   },	
			{id = 32, Weapon = 0x63AB0442,  modelHash = "g_m_y_lost_01", x = 3078.76, y = -4808.58, z = 7.08, heading = 288.53 },
			{id = 33, modelHash = "mp_m_bogdangoon",isBoss=true,x = 3088.89, y = -4802.77, z = 7.08, heading = 282.8 },
			{id = 34, modelHash = "mp_m_weapexp_01",isBoss=true,x = 3091.94, y = -4802.34, z = 7.08, heading = 264.01  },			
			{id = 35, modelHash = "u_m_y_juggernaut_01",isBoss=true, x = 3095.22, y = -4802.53, z = 7.08, heading = 242.39  },
			
			{id = 36, modelHash = "mp_m_exarmy_01",isBoss=true,x = 3100.59, y = -4804.48, z = 2.04, heading = 81.11 },
			{id = 37, modelHash = "ig_josef",isBoss=true,x = 3101.24, y = -4801.71, z = 2.04, heading = 88.7  },			
			{id = 38, modelHash = "u_m_y_juggernaut_01",isBoss=true, x = 3101.73, y = -4803.02, z = 2.04, heading = 87.84  },
			
			{id = 39, modelHash = "u_m_y_juggernaut_01",isBoss=true,x = 3084.87, y = -4746.29, z = 6.08, heading = 101.26 },
			{id = 40, modelHash = "u_m_y_juggernaut_01",isBoss=true,x = 3064.79, y = -4762.5, z = 6.08, heading = 293.0 },			
			{id = 41, modelHash = "u_m_y_juggernaut_01",isBoss=true, x = 3088.51, y = -4797.39, z = 6.08, heading = 6.96 },
			
			{id = 42, Weapon = 0xDBBD7280,  modelHash = "s_m_y_ammucity_01",  x = 3051.75, y = -4716.35, z = 6.24, heading = 11.43   },
			{id = 43, Weapon = 0xDBBD7280,  modelHash = "s_m_y_ammucity_01",  x = 3052.74, y = -4718.99, z = 6.24, heading = 190.86   },

			{id = 44, Weapon = 0xBFEFFF6D,  modelHash = "s_m_y_ammucity_01",  x = 3053.65, y = -4740.8, z = 10.74, heading = 189.14   },
			{id = 45, Weapon = 0xDBBD7280,  modelHash = "s_m_y_ammucity_01",  x = 3055.32, y = -4744.33, z = 10.74, heading = 465.8   },	
			{id = 46, Weapon = 0xBFEFFF6D,  modelHash = "s_m_y_ammucity_01", x = 3055.65, y = -4748.23, z = 10.74, heading = 370.68   },	

			{id = 47, Weapon = 0xB1CA77B1,  modelHash = "s_m_y_ammucity_01",  x = 3059.15, y = -4794.96, z = 6.07, heading = 100.8,outside=true   },
			{id = 48, Weapon = 0xA914799,  modelHash = "s_m_y_ammucity_01", x = 3056.83, y = -4802.4, z = 6.07, heading = 95.79,outside=true   },	
			{id = 49, Weapon = 0xA914799,  modelHash = "s_m_y_ammucity_01", x = 3054.79, y = -4790.17, z = 6.07, heading = 88.23,outside=true    },	
			
			{id = 50, Weapon = 0x7FD62962,  modelHash = "s_m_y_ammucity_01", x = 3093.14, y = -4752.91, z = 11.57, heading = 185.12   },
			{id = 51, Weapon = 0x7FD62962,  modelHash = "s_m_y_ammucity_01", x = 3062.18, y = -4639.25, z = 11.58, heading = 163.77   },	

			{id = 52, Weapon = 0xB1CA77B1,  modelHash = "s_m_y_ammucity_01", x = 3077.06, y = -4645.96, z = 6.07, heading = 281.53,outside=true   },
			{id = 53, Weapon = 0xA914799,  modelHash = "s_m_y_ammucity_01", x = 3081.49, y = -4638.62, z = 6.08, heading = 289.03,outside=true   },	
			{id = 54, Weapon = 0xA914799,  modelHash = "s_m_y_ammucity_01", x = 3080.68, y = -4650.49, z = 6.07, heading = 274.85,outside=true    },	

			{id = 55, Weapon = 0x7FD62962,  modelHash = "s_m_y_ammucity_01",x = 3093.84, y = -4705.09, z = 18.32, heading = 45.94   },		
			{id = 56, Weapon =0x83BF0278,  modelHash = "U_M_Y_Tattoo_01",x = 3086.59, y = -4706.5, z = 21.27, heading = 273.53},			
			
			{id = 57, Weapon = 0x83BF0278,  modelHash = "mp_m_boatstaff_01",  x = 3090.6, y = -4723.34, z = 27.28, heading = 341.1},			
			{id = 58, Weapon = 0x83BF0278,  modelHash = "mp_m_boatstaff_01", x = 3090.02, y = -4690.63, z = 27.25, heading = 109.06},
			{id = 59, Weapon = 0x83BF0278,  modelHash = "mp_m_boatstaff_01",   x = 3085.15, y = -4688.39, z = 27.25, heading = 181.35,friendly=true,},			
			{id = 60, Weapon = 0x83BF0278,  modelHash = "mp_m_boatstaff_01", x = 3092.43, y = -4723.04, z = 27.28, heading = 163.78,friendly=true,},

			{id = 61, Weapon = 0x624FE830,  modelHash = "s_m_y_xmech_02",x = 3091.61, y = -4713.36, z = 15.26, heading = 127.42,outside=true  },	
			{id = 62, Weapon = 0xAF113F99,  modelHash = "s_m_y_xmech_02_mp",x = 3091.69, y = -4716.12, z = 15.26, heading = 141.15,outside=true },
			{id = 63, Weapon = 0x63AB0442,  modelHash = "U_M_Y_Tattoo_01",  x = 3092.98, y = -4719.9, z = 15.26, heading = 161.19,outside=true   },
			{id = 64, Weapon = 0xB1CA77B1,  modelHash = "G_M_M_ChiCold_01", x = 3088.38, y = -4718.44, z = 15.26, heading = 111.62,outside=true  },			
			{id = 65, Weapon =0xAF113F99,  modelHash = "mp_g_m_pros_01",x = 3093.71, y = -4722.65, z = 15.26, heading = 204.62,outside=true },	

			{id = 66, Weapon = 0xAF113F99,  modelHash = "s_m_y_xmech_02_mp", x = 3112.3, y = -4789.37, z = 15.26, heading = 78.83,outside=true },
			{id = 67, Weapon = 0x624FE830,  modelHash = "U_M_Y_Tattoo_01",  x = 3115.69, y = -4781.82, z = 15.26, heading = 32.64,outside=true  },
			{id = 68, Weapon = 0xB1CA77B1,  modelHash = "G_M_M_ChiCold_01", x = 3119.05, y = -4793.04, z = 15.26, heading = 217.24,outside=true },	
			{id = 69, Weapon = 0xB1CA77B1,  modelHash = "g_m_y_lost_01", x = 3061.8, y = -4613.64, z = 15.26, heading = 108.66,outside=true },
			{id = 70, Weapon = 0x624FE830,  modelHash = "g_m_y_lost_02", x = 3066.3, y = -4606.7, z = 15.26, heading = 2.09,outside=true  },
			{id = 71, Weapon = 0xAF113F99,  modelHash = "g_m_y_lost_03",x = 3074.66, y = -4609.24, z = 15.26, heading = 244.44,outside=true },
			{id = 72, modelHash = "mp_m_weapexp_01",isBoss=true,x = 3082.87, y = -4706.12, z = 27.26, heading = 103.23 },			
			{id = 73, modelHash = "mp_m_exarmy_01",isBoss=true,x = 3096.44, y = -4702.97, z = 27.26, heading = 278.67 },
		
    },
	
	
	Events = {
	
		--[[{ 
		  Type="Vehicle",
		  Position = { x = -103.41, y = -438.73, z = 36.02, heading = 167.51 }, 
		  Size     = {radius=10000},
		  SpawnHeight =200.0,
		  FacePlayer = true,
		  --NumberPeds=10,
		  isBoss=false,
		  Target=false,
		  Vehicle="trailersmall",
		  Weapon=0xBD248B55,
		  SquadSpawnRadius=1.0,
		  Message="~h~~r~Warning: Psychotronic countermeasures deployed. Civilians may be hostile.",
		  --CheckGroundZ=true,
		},	
	]]--
		{ 
		  Type="Aircraft",
		  Position = {  x = 3012.79, y = -4520.81, z = 15.26+50, heading = 10.42,}, 
		  Size     = {radius=1000.0},
		  SpawnHeight =50.0,
		  FacePlayer = true,
		  --NumberPeds=10,
		  isBoss=false,
		  Target=false,
		  Vehicle="hydra",
		  modelhash="s_m_y_ammucity_01",
		 Weapon=0x13532244,
		  SquadSpawnRadius=1.0,
		  --CheckGroundZ=true,
		},
		{ 
		  Type="Aircraft",
		  Position = { x = 3101.06, y = -4815.26, z = 15.26 + 50, heading = 204.23, }, 
		  Size     = {radius=1000.0},
		  SpawnHeight =50.0,
		  FacePlayer = true,
		  --NumberPeds=10,
		  isBoss=false,
		  Target=false,
		  Vehicle="hydra",
		   modelhash="s_m_y_ammucity_01",
		 Weapon=0x13532244,
		  SquadSpawnRadius=1.0,
		  --CheckGroundZ=true,
		},
				{ 
		  Type="Aircraft",
		  Position = {  x = 3067.53, y = -4652.76, z = 15.26 + 50, heading = 281.4,}, 
		  Size     = {radius=1000.0},
		  SpawnHeight =50.0,
		  FacePlayer = true,
		  --NumberPeds=10,
		  isBoss=false,
		  Target=false,
		  Vehicle="hydra",
		   modelhash="s_m_y_ammucity_01",
		 Weapon=0x13532244,
		  SquadSpawnRadius=1.0,
		  --CheckGroundZ=true,
		},
				{ 
		  Type="Aircraft",
		  Position = {  x = 3037.34, y = -4737.51, z = 15.26 + 50, heading = 94.82,}, 
		  Size     = {radius=1000.0},
		  SpawnHeight =50.0,
		  FacePlayer = true,
		  --NumberPeds=10,
		  isBoss=false,
		  Target=false,
		  Vehicle="hydra",
		  modelhash="s_m_y_ammucity_01",
		  Weapon=0x13532244,
		  SquadSpawnRadius=1.0,
		  --CheckGroundZ=true,
		},
				
		
	},	
	

    Vehicles = {
      -- ID: id of NPC | name: Name of Blip | BlipID: Icone of Blip | VoiceName: NPC Talk When near it | Ambiance: Ambiance of Shop | Weapon: Hash of Weapon | modelHash: Model | X: Position x | Y: Position Y | Z: Position Z | heading: Where Npc look
   	  --**IMPORTANT: make sure the id of the ped starts from 1, each Peds id in above, increments by 1 and matches that entries index if it were in an array***
	  --vehicles are not consistent, so use ExtraPeds at your own discretion.
	  --Below takes a ped with id=1 from Peds above and will put it in seatid = -2   
	 -- {id = 1, id2 = 1, Vehicle = "annihilator", modelHash = "S_M_M_ChemSec_01",  x = -1166.42, y = 4641.5, z = 145.11, heading = 210.07,driving=true,pilot=true},
	 -- {id = 2, id2 = 2, Vehicle = "toro2", modelHash = "s_m_y_ammucity_01",  x = -3014.83, y = -43.5, z = 0.13, heading = 151.19, driving=true},
	 --{id = 1, id2 = 1, Vehicle = "hydra", modelHash = "s_m_y_ammucity_01", x = 3012.79, y = -4520.81, z = 15.26+50, heading = 10.42, Weapon=0x13532244,outside=true,pilot=true, isAircraft=true,},
	 {id = 1, id2 = 1, Vehicle = "trailersmall2", modelHash = "s_m_y_ammucity_01", x = 3072.88, y = -4619.79, z = 15.26, heading = 381.44,outside=true,Weapon=0x13532244,nomods=true,driverfiringpattern=0xC6EE6B4C},
	 {id = 2, id2 = 2, Vehicle = "apc", modelHash = "U_M_Y_Tattoo_01", x = 3047.24, y = -4697.32, z = 15.26, heading = 106.64,outside=true,Weapon=0x13532244},
	 --{id = 4, id2 = 4, Vehicle = "hydra", modelHash = "s_m_y_ammucity_01",x = 3101.06, y = -4815.26, z = 15.26 + 50, heading = 204.23, Weapon=0x13532244,outside=true,pilot=true, isAircraft=true,},
	-- {id = 5, id2 = 5, Vehicle = "hydra", modelHash = "s_m_y_ammucity_01", x = 3067.53, y = -4652.76, z = 15.26 + 50, heading = 281.4, Weapon=0x13532244,outside=true,pilot=true, isAircraft=true,},
	 --{id = 6, id2 = 6, Vehicle = "hydra", modelHash = "s_m_y_ammucity_01", x = 3037.34, y = -4737.51, z = 15.26 + 50, heading = 94.82, Weapon=0x13532244,outside=true,pilot=true, isAircraft=true,},
	 {id = 3, id2 = 3, Vehicle = "trailersmall2", modelHash = "s_m_y_ammucity_01",x = 3065.51, y = -4815.59, z = 15.26, heading = 97.46,outside=true,Weapon=0x13532244,nomods=true,driverfiringpattern=0xC6EE6B4C},
	 {id = 4, id2 = 4, Vehicle = "apc", modelHash = "U_M_Y_Tattoo_01",x = 3092.12, y = -4816.5, z = -0.68, heading = 197.38,outside=true,Weapon=0x13532244},
	 {id = 5, id2 = 5, Vehicle = "scarab", modelHash = "g_m_y_lost_02",x = 3078.66, y = -4757.66, z = 6.08, heading = 94.86,outside=true,Weapon=0x13532244},	
	 {id = 6, id2 = 6, Vehicle = "menacer", modelHash = "G_M_M_ChiCold_01",x = 3070.3, y = -4729.55, z = 6.08, heading = 188.47,outside=true,Weapon=0x13532244},
	 {id = 7, id2 = 7, Vehicle = "trailersmall2", modelHash = "s_m_y_ammucity_01", x = 3095.41, y = -4763.96, z = 6.08, heading = 285.23,outside=true,Weapon=0x13532244,nomods=true,driverfiringpattern=0xC6EE6B4C},
	 {id = 8, id2 = 8, Vehicle = "trailersmall2", modelHash = "s_m_y_ammucity_01", x = 3068.78, y = -4792.58, z = 6.08, heading = 96.11,outside=true,Weapon=0x13532244,nomods=true,driverfiringpattern=0xC6EE6B4C},
	 {id = 9, id2 = 9, Vehicle = "trailersmall2", modelHash = "s_m_y_ammucity_01",x = 3070.31, y = -4649.15, z = 6.08, heading = 283.28,outside=true,Weapon=0x13532244,nomods=true,driverfiringpattern=0xC6EE6B4C},
    }
  }, 
  
  
  Mission38 = {
    
	StartMessage = "Shut down the AI the mercenaries have enabled~n~before it takes over the internet",
	FinishMessage = "Mission Completed!",
	MissionTitle = "Skynet",
	MissionMessage = "Shut down the AI the mercenaries have enabled~n~before it takes over the internet",	
	Type = "Objective",	
	IndoorsMission = true,
	IndoorsMissionStrongSpawnCheck = true,
	SafeHouseSniperExplosiveRoundsGiven=0,
	MissionTriggerRadius = 20.0,
	
	SMS_Subject="Skynet",
	SMS_Message="Mercs have taken over an AI at NOOSE Headquarters and weaponized it.",
	SMS_Message2="Shut down the AI the mercenaries have enabled before it takes over the internet. Can you help?",
	--SMS_Message3="",	
		
	--SMS_ContactPics={"CHAR_AGENT14",
	--},
	--SMS_ContactNames={"Agency Contact",
	--},
	SMS_NoFailedMessage=true,
	SMS_NoPassedMessage=true,
	SMS_FailedSubject="HAHA",
	SMS_FailedMessage="You should have stayed away, this is much bigger than you",
	SMS_PassedSubject="Thank you",
	SMS_PassedMessage="Los Santos is safe and sound from the attack",			
	
    Blip = {
      Title = "Mission: AI Central Hub",
      Position =  { x = 2478.55, y = -403.24, z = 94.56 },
      Icon     = 58,
      Display  = 4,
      Size     = 1.2,
      Color    = 1,
    },

    Marker = {
      Type     = 1,
      Position = { x = 2358.2, y = 2920.95, z = -85.78}, 
      Size     = {x = 6.0, y = 6.0, z = 2.0},
      Color    = {r = 100, g = 100, b = 204},
      DrawDistance = 100.0,
    },
	BlipS = { --safehouse blip 
		  Title = "Mission Safehouse",
		  Position = { x = 1731.94, y = 3308.24, z = 41.22}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 417,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 2,
		  Alpha	 =80, 
	},	
	MarkerS = { --safehouse marker
		  Type     = 1,
		  Position = { x = 1731.94, y = 3308.24, z = 40.22},  --{  x = 1944.96, y = 3150.6, z = 46.77}, 
		  Size     = {x = 6.0, y = 6.0, z = 2.0},
		  Color    = {r = 117, g = 218, b = 255},
		  DrawDistance = 200.0,
	},
	BlipSL = { --safehouse Vehicle blip 
		  Title = "Mission Vehicle Safehouse",
		  Position = { x = 1480.63, y = 3167.93, z = 40.99}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 421,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
	},
	BlipSB = { --safehouse boat blip 
		  Title = "Mission Boat Safehouse",
		  Position = {x = 1481.84, y = 3873.37, z = 30.04}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		 Icon     = 404,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
	},	
	
	
	Props = {
		{ id=1,  Name = "xm_base_cia_serverhub_02", Position = { x = 2358.2, y = 2920.95, z = -84.78, heading = 450.0 }},
		
	
    },
	
	
	
Events = {
	--[[	{ 
		  Type="Vehicle",
		  Position = { x = -103.41, y = -438.73, z = 36.02, heading = 167.51 }, 
		  Size     = {radius=10000},
		  SpawnHeight =200.0,
		  FacePlayer = true,
		  --NumberPeds=10,
		  isBoss=false,
		  Target=false,
		  Vehicle="trailersmall",
		  Weapon=0xBD248B55,
		  SquadSpawnRadius=1.0,
		  Message="~h~~r~Warning: Psychotronic countermeasures deployed. Civilians may be hostile.",
		  --CheckGroundZ=true,
		},	
]]--
},


	
	Pickups = {
	},
	MissionPickups = {
		
	},	
		
	

    Peds = {
	
			{id = 1, Weapon =0x7FD62962,  modelHash = "s_m_y_ammucity_01", x = 2153.92, y = 2920.81, z = -84.8, heading = 263.18, },
			{id = 2, Weapon =0x7FD62962,  modelHash = "G_M_M_ChiCold_01",x = 2168.32, y = 2921.33, z = -84.8, heading = 81.96 },
			{id = 3, Weapon =0xAF113F99,  modelHash = "s_m_y_ammucity_01", x = 2159.98, y = 2920.99, z = -84.8, heading = 268.03  },
			
			{id = 4, Weapon =0xDBBD7280,  modelHash = "s_m_y_dealer_01", x = 2178.14, y = 2916.55, z = -84.79, heading = 108.35  },
			{id = 5, Weapon =0xFAD1F1C9,  modelHash = "s_m_y_ammucity_01", x = 2176.58, y = 2927.84, z = -84.8, heading = 105.77 },
			{id = 6, Weapon =0xE284C527,  modelHash = "U_M_Y_Tattoo_01",  x = 2176.14, y = 2922.38, z = -84.8, heading = 57.45   },
			{id = 7, modelHash = "mp_m_bogdangoon",isBoss=true,x = 2178.74, y = 2920.77, z = -84.8, heading = 264.61 },			
			{id = 8, modelHash = "mp_m_exarmy_01",isBoss=true,x = 2358.06, y = 2894.02, z = -84.8, heading = 82.86 },	
			
			{id = 9, modelHash = "mp_m_weapexp_01",isBoss=true, x = 2358.26, y = 2948.02, z = -84.8, heading = 90.65  },	
			
			{id = 10, Weapon =0x7FD62962,  modelHash = "s_m_y_ammucity_01", x = 2355.61, y = 2944.01, z = -84.8, heading = 267.41, },
			{id = 11, Weapon =0x7FD62962,  modelHash = "s_m_y_ammucity_01", x = 2355.53, y = 2898.05, z = -84.8, heading = -98.46  },
			
			{id = 12, Weapon =0x7FD62962,  modelHash = "G_M_M_ChiCold_01",x = 2357.36, y = 2902.62, z = -84.8, heading = 86.09 },
			{id = 13, Weapon =0x7FD62962,  modelHash = "U_M_Y_Tattoo_01",x = 2357.45, y = 2906.46, z = -84.8, heading = 85.96 },
			
			{id = 14, Weapon =0x7FD62962,  modelHash = "s_m_y_ammucity_01", x = 2357.49, y = 2940.11, z = -84.8, heading = 85.39 },
			
			{id = 15, Weapon =0x7FD62962,  modelHash = "s_m_y_robber_01",x = 2357.09, y = 2936.33, z = -84.8, heading = 86.47 },	
			
			{id = 16, modelHash = "u_m_y_juggernaut_01",isBoss=true, x = 2357.74, y = 2931.17, z = -84.8, heading = 87.94   },
			
			{id = 17, modelHash = "u_m_y_juggernaut_01",isBoss=true,x = 2357.67, y = 2911.07, z = -84.8, heading = 84.42 },
			{id = 18, modelHash = "u_m_y_juggernaut_01",isBoss=true,x = 2357.98, y = 2915.69, z = -84.65, heading = 185.38 },			
			{id = 19, modelHash = "u_m_y_juggernaut_01",isBoss=true, x = 2358.04, y = 2925.98, z = -84.65, heading = 358.89 },
			
			
			{id = 20, Weapon =0x63AB0442,  modelHash = "s_m_y_xmech_02", x = 2185.14, y = 2904.4, z = -84.8, heading = 81.81 },
			{id = 21, Weapon =0x63AB0442,  modelHash = "G_M_M_ChiCold_01", x = 2193.53, y = 2912.41, z = -84.8, heading = 86.44 },
			
			{id = 22, Weapon =0xAF113F99,  modelHash = "g_m_y_lost_03", x = 2204.32, y = 2928.5, z = -84.8, heading = 183.6  },
			{id = 23, Weapon =0xDBBD7280,  modelHash = "s_m_y_dealer_01", x = 2192.8, y = 2937.65, z = -84.8, heading = 96.16 },
			{id = 24, Weapon =0xFAD1F1C9,  modelHash = "s_m_y_ammucity_01", x = 2209.21, y = 2919.18, z = -84.8, heading = 176.13 },
			{id = 25, Weapon =0xEFE7E2DF,  modelHash = "u_f_y_bikerchic", x = 2209.7, y = 2922.72, z = -84.8, heading = -5.35    },
			{id = 26, modelHash = "mp_m_bogdangoon",isBoss=true,x = 2225.64, y = 2928.69, z = -84.79, heading = 1.55 },			
			{id = 27, modelHash = "mp_m_exarmy_01",isBoss=true,x = 2225.5, y = 2912.78, z = -84.8, heading = -9.91 },	
			{id = 28, modelHash = "mp_m_weapexp_01",isBoss=true, x = 2225.52, y = 2905.73, z = -84.8, heading = 169.79   },	
			{id = 29, Weapon =0xE284C527,  modelHash = "g_f_y_lost_01", x = 2241.55, y = 2897.49, z = -84.8, heading = 46.64 },
			{id = 30, Weapon =0xA914799,  modelHash = "g_m_y_lost_02", x = 2234.77, y = 2906.12, z = -84.8, heading = -7.76  },
			{id = 31, Weapon =0xE284C527,  modelHash = "G_M_M_ChiCold_01",x = 2240.36, y = 2939.79, z = -84.8, heading = 357.43 },
			{id = 32, Weapon =0xA914799,  modelHash = "U_M_Y_Tattoo_01", x = 2259.19, y = 2928.08, z = -84.8, heading = 172.99 },
			{id = 33, Weapon =0xAF113F99,  modelHash = "s_m_y_ammucity_01", x = 2259.3, y = 2930.8, z = -84.8, heading = 358.78 },
			
			{id = 34, Weapon =0xAF113F99,  modelHash = "s_m_y_robber_01",x = 2278.91, y = 2919.22, z = -84.8, heading = 176.71 },	
			{id = 35, Weapon = 0xC0A3098D,  modelHash = "g_m_y_lost_01",x = 2278.62, y = 2922.68, z = -84.8, heading = -5.34 },	
			{id = 36, Weapon = 0x7F229F94,  modelHash = "u_f_y_bikerchic",x = 2298.73, y = 2930.61, z = -84.8, heading = -5.04   },	
			
			{id = 37, Weapon = 0x3AABBBAA,  modelHash = "s_m_y_xmech_02_mp",x = 2298.15, y = 2927.76, z = -84.8, heading = 179.47  },
			{id = 38, Weapon = 0x2BE6766B,  modelHash = "s_m_y_dealer_01",x = 2317.56, y = 2910.98, z = -84.8, heading = 174.82  },
			{id = 39, Weapon = 0x83BF0278,  modelHash = "s_m_y_ammucity_01",x = 2319.11, y = 2914.45, z = -84.8, heading = 356.29  },
			
			{id = 40, Weapon = 0xDBBD7280,  modelHash = "g_m_y_lost_03", x = 2338.4, y = 2922.53, z = -84.8, heading = -14.96 },	
			{id = 41, Weapon = 0xDBBD7280,  modelHash = "g_m_y_lost_02",x = 2338.46, y = 2918.88, z = -84.8, heading = 178.1 },	
			{id = 42, Weapon = 0xDBBD7280,  modelHash = "G_M_M_ChiCold_01", x = 2338.45, y = 2902.36, z = -84.8, heading = 170.43  },	
			{id = 43, Weapon = 0xDBBD7280,  modelHash = "g_f_y_lost_01", x = 2338.92, y = 2905.81, z = -84.8, heading = -1.24 },				
			
			{id = 44, Weapon = 0xBFEFFF6D,  modelHash = "s_m_y_xmech_02", x = 2339.25, y = 2939.49, z = -84.8, heading = 0.76  },	
			{id = 45, Weapon = 0xBFEFFF6D,  modelHash = "s_m_y_xmech_02_mp", x = 2338.32, y = 2935.93, z = -84.8, heading = 175.75 },
			{id = 46, Weapon = 0xDBBD7280,  modelHash = "U_M_Y_Tattoo_01",  x = 2318.46, y = 2939.14, z = -84.8, heading = -3.03   },
			
			{id = 47, Weapon = 0xBFEFFF6D,  modelHash = "s_m_y_xmech_02",x = 2318.35, y = 2935.99, z = -84.8, heading = 174.93  },	
			{id = 48, Weapon = 0xBFEFFF6D,  modelHash = "s_m_y_xmech_02_mp",x = 2318.04, y = 2902.6, z = -84.8, heading = 177.97 },
			{id = 49, Weapon = 0xDBBD7280,  modelHash = "U_M_Y_Tattoo_01",  x = 2318.43, y = 2905.8, z = -84.8, heading = 6.77   },			
			
			{id = 50, Weapon = 0x63AB0442,  modelHash = "U_M_Y_Tattoo_01",  x = 2191.59, y = 2938.88, z = -84.8, heading = 348.99   },	
			{id = 51, Weapon = 0x63AB0442,  modelHash = "g_m_y_lost_01", x = 2192.4, y = 2936.59, z = -84.8, heading = 190.64 },
			{id = 52, modelHash = "u_m_y_juggernaut_01",isBoss=true,x = 2354.72, y = 2912.29, z = -84.72, heading = 273.7 },			
			{id = 53, modelHash = "u_m_y_juggernaut_01",isBoss=true, x = 2354.19, y = 2929.48, z = -84.72, heading = 265.63 },			
			
			
    },
	
	

    Vehicles = {
		-- {id = 1, id2 = 1, Vehicle = "bmx", modelHash = "s_m_y_dealer_01", x = 2338.23, y = 2914.42, z = -84.8, heading = 174.26, Weapon=0x624FE830},
		--{id = 2, id2 = 2, Vehicle = "bmx", modelHash = "s_m_y_robber_01", x = 2338.5, y = 2930.59, z = -84.8, heading = 355.12,Weapon=0x624FE830},
      -- ID: id of NPC | name: Name of Blip | BlipID: Icone of Blip | VoiceName: NPC Talk When near it | Ambiance: Ambiance of Shop | Weapon: Hash of Weapon | modelHash: Model | X: Position x | Y: Position Y | Z: Position Z | heading: Where Npc look
   	  --**IMPORTANT: make sure the id of the ped starts from 1, each Peds id in above, increments by 1 and matches that entries index if it were in an array***
	  --vehicles are not consistent, so use ExtraPeds at your own discretion.
	  --Below takes a ped with id=1 from Peds above and will put it in seatid = -2   
	 -- {id = 1, id2 = 1, Vehicle = "annihilator", modelHash = "S_M_M_ChemSec_01",  x = -1166.42, y = 4641.5, z = 145.11, heading = 210.07,driving=true,pilot=true},
	 -- {id = 2, id2 = 2, Vehicle = "toro2", modelHash = "s_m_y_ammucity_01",  x = -3014.83, y = -43.5, z = 0.13, heading = 151.19, driving=true},
    }
  }, 
  
  
  Mission39 = {
    
	StartMessage = "Take out the Mercenaries infrastructure and clients~n~to help finish off the threat",
	FinishMessage = "Mission Completed!",
	MissionTitle = "OmniCorp",
	MissionMessage = "Take out the Mercenaries infrastructure and clients~n~to help finish off the threat",	
	Type = "ObjectiveRescue",	
	IndoorsMission = true,
	IndoorsMissionStrongSpawnCheck = true,
	ObjectiveRescueShortRangeBlip = true,
	SafeHouseSniperExplosiveRoundsGiven=8,
	--MissionTriggerRadius = 10.0,
	
	SMS_Subject="OmniCorp",
	SMS_Message="Our intel have revealed the clients of renegade mercenaries terrorizing San Andreas.",
	SMS_Message2="We are calling them The Cabal. We need someone to take out the mercs infrastructure and clients",
	SMS_Message3="This will help finish off thre threat. Can you help?",	
		
	--SMS_ContactPics={"CHAR_AGENT14",
	--},
	--SMS_ContactNames={"Agency Contact",
	--},
	SMS_NoFailedMessage=true,
	SMS_NoPassedMessage=true,
	SMS_FailedSubject="HAHA",
	SMS_FailedMessage="You should have stayed away, this is much bigger than you",
	SMS_PassedSubject="Thank you",
	SMS_PassedMessage="Los Santos is safe and sound from the attack",			
	
    Blips = {{
		  Title = "Mission: Mercenaries Supplies Bunker",
		  Position =  { x = -3031.13, y = 3333.6, z = 10.16 },
		  Icon     = 58,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 1,
		},
		{
		Title = "Mission: Cabal Headquarters",
		Position = {x = -81.74, y = -837.28, z = 40.56},
		Icon     = 58,
		Display  = 4,
		Size     = 1.2,
		Color    = 1,
		},
		{
		Title = "Mission: Submarine Base",
		Position = {x = 493.65, y = -3224.14, z = 6.07},
		Icon     = 58,
		Display  = 4,
		Size     = 1.2,
		Color    = 1,
		},		
		
	},

    Marker = {
      Type     = 1,
      Position = { x = 2358.2, y = 2920.95, z = -85.78}, 
      Size     = {x = 6.0, y = 6.0, z = 2.0},
      Color    = {r = 100, g = 100, b = 204},
      DrawDistance = 100.0,
    },
	SafeHouseVehicles = {
	"insurgent3",
	"kuruma2",
	},
	SafeHouseAircraft = 
	{
	"hydra",
	"valkyrie",
	"thruster",
	},
	SafeHouseBoat = 
	{
	"dinghy4",
	"seashark",
	"toro2",
	"jetmax",
	"submersible2",
	"submersible",
	},	
	
	BlipS = { --safehouse blip 
		  Title = "Mission Safehouse",
		  Position = { x = 1731.94, y = 3308.24, z = 41.22}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 417,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 2,
		  Alpha	 =80, 
	},	
	MarkerS = { --safehouse marker
		  Type     = 1,
		  Position = { x = 1731.94, y = 3308.24, z = 40.22},  --{  x = 1944.96, y = 3150.6, z = 46.77}, 
		  Size     = {x = 6.0, y = 6.0, z = 2.0},
		  Color    = {r = 117, g = 218, b = 255},
		  DrawDistance = 200.0,
	},
	BlipSL = { --safehouse Vehicle blip 
		  Title = "Mission Vehicle Safehouse",
		  Position = { x = 1480.63, y = 3167.93, z = 40.99}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 421,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
	},
	BlipSB = { --safehouse boat blip 
		  Title = "Mission Boat Safehouse",
		  Position = {x = 1481.84, y = 3873.37, z = 30.04}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		 Icon     = 404,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
	},	
	
	
	Props = {
		--MAZE BANK
		{ id=1,  Name = "prop_amb_phone", isObjective=true,Position = {x = -81.39, y = -801.15, z = 243.4, heading = 161.82 }},
		{ id=2,  Name = "prop_cs_duffel_01b", isObjective=true,Position = {x = -75.06, y = -819.3, z = 326.18, heading = 161.82 }},
		--SUBMARINE
		{ id=3,  Name = "prop_biotech_store", isObjective=true,Position = {x = 514.24, y = 4817.39, z = -68.99, heading = 180.00 }},
		--{ id=2,  Name = "prop_large_gold",isObjective=true, Position = {x = 1724.91, y = 3303.87, z = 41.22, heading = 174.83  }},
		--gun bunker
		{ id=4,  Name = "prop_cheetah_covered", isObjective=true,Position = { x = 831.03, y = -3233.17, z = -98.7, heading = 270.18 }},
		{ id=5,  Name = "hei_prop_hst_usb_drive", isObjective=true,Position = {x = 903.32, y = -3199.5, z = -97.19, heading = 51.29 }},
		{ id=6,  Name = "hei_prop_hst_usb_drive_light", Position = {x = 903.32, y = -3199.5, z = -97.19, heading = 51.29}},	
		{ id=7,  Name = "hei_prop_mini_sever_02", Position = { x = 863.33, y = -3185.66, z = -96.13, heading = 106.19  }},	
		{ id=8,  Name = "hei_prop_mini_sever_02", Position = { x = 864.19, y = -3188.15, z = -96.12, heading = 106.19}},	
		{ id=9,  Name = "hei_prop_mini_sever_01", isObjective=true,Position = {x = 863.76, y = -3186.95, z = -96.13, heading = 108.43}},	
		{ id=10,  Name = "prop_air_cargo_04c", isObjective=true,Position = {x = 943.68, y = -3202.92, z = -98.27, heading = -97.21}},	
		{ id=11,  Name = "prop_air_cargo_04a", isObjective=true,Position = {x = 947.83, y = -3237.04, z = -98.3, heading = 274.68}},
		{ id=12,  Name = "prop_weight_bench_02", Position = {x = 941.63, y = -3238.72, z = -98.3, heading = 185.49 }},	
		{ id=13,  Name = "prop_barbell_02", Position = {x = 939.24, y = -3239.3, z = -98.3, heading = 87.15 }},
		{ id=14,  Name = "prop_barbell_01", Position = {x = 939.81, y = -3238.57, z = -98.3, heading = 209.37  }},
		{ id=15,  Name = "xm_prop_x17_bag_01c", isObjective=true,Position = {x = 901.7, y = -3182.18, z = -97.07, heading = 116.16  }},						
		--{ id=4,  Name = "hei_prop_hst_usb_drive", isObjective=true,Position = {x = 827.1, y = -3232.84, z = -98.83, heading = 264.05 }},
		--{ id=5,  Name = "hei_prop_hst_usb_drive_light", Position = {x = 827.1, y = -3232.84, z = -98.83, heading = 264.05 }},
    },
	
	
	



	
	Pickups = {
	},
	MissionPickups = {
		
	},	
		 
	

    Peds = {
			--MAZE BANK
			{id = 1, modelHash = "u_m_y_juggernaut_01",isBoss=true,x = -84.47, y = -836.25, z = 40.56, heading = 144.41,outside=true, },
			{id = 2, modelHash = "u_m_y_juggernaut_01",isBoss=true,x = -79.44, y = -838.36, z = 40.56, heading = 161.16 ,outside=true, },
			{id = 3, modelHash = "ig_bankman",Weapon =0xAF113F99,x = -67.55, y = -819.04, z = 243.39, heading = 71.12,target=true },
			{id = 3, modelHash = "cs_gurk",Weapon =0xEFE7E2DF,x = -66.49, y = -821.17, z = 243.39, heading = 5.69,target=true },
			{id = 4, modelHash = "a_m_m_og_boss_01",Weapon =0x624FE830,x = -59.64, y = -811.5, z = 243.39, heading = 62.49 ,target=true },
			{id = 5, modelHash = "u_m_m_jewelsec_01",Weapon =0x624FE830,x = -61.03, y = -806.27, z = 243.39, heading = 137.08 },
			{id = 6, modelHash = "s_m_m_highsec_01",Weapon =0x624FE830,x = -68.2, y = -802.81, z = 243.39, heading = 156.97 },
			{id = 7, modelHash = "s_m_m_highsec_02",Weapon =0x624FE830, x = -78.85, y = -799.25, z = 243.39, heading = 199.56 },
			{id = 8, modelHash = "u_m_m_jewelthief",Weapon =0x476BF155, x = -81.85, y = -803.06, z = 243.4, heading = 255.7,target=true  },
			{id = 9, modelHash = "s_f_y_movprem_01",Weapon =0xEFE7E2DF, x = -78.97, y = -805.71, z = 243.39, heading = 269.25,target=true  },
			{id = 10, modelHash = "s_m_m_movprem_01",Weapon =0xEFE7E2DF,x = -76.93, y = -806.97, z = 243.39, heading = 155.01 ,target=true  },
			{id = 11, modelHash = "s_f_y_movprem_01",Weapon =0xEFE7E2DF, x = -77.05, y = -815.37, z = 243.39, heading = 233.4,target=true  },
			{id = 12, modelHash = "ig_fbisuit_01",Weapon =0xEFE7E2DF, x = -63.24, y = -808.46, z = 243.39, heading = 70.18},
			{id = 13, modelHash = "u_m_m_bankman",Weapon =0xAF113F99,  x = -69.1, y = -807.43, z = 243.4, heading = 60.02,target=true},
			{id = 14, modelHash = "u_m_y_juggernaut_01",isBoss=true,x = -68.89, y = -811.86, z = 321.29, heading = 215.79,outside=true, },
			{id = 15, modelHash = "u_m_y_juggernaut_01",isBoss=true,x = -75.53, y = -809.63, z = 321.31, heading = 95.35,outside=true, },	
			{id = 16, modelHash = "ig_tomepsilon",Weapon =0xAF3696A1,x = -75.06, y = -819.3, z = 326.18, heading = 377.86,outside=true,target=true },	
			{id = 17, modelHash = "u_m_m_jewelsec_01",Weapon =0x476BF155,x = -75.57, y = -814.75, z = 326.18, heading = 16.99,outside=true, },
			{id = 18, modelHash = "s_m_m_highsec_02",Weapon =0x476BF155,x = -75.95, y = -823.88, z = 326.18, heading = 165.75,outside=true, },
			{id = 19, modelHash = "s_m_m_highsec_01",Weapon =0x63AB0442,x = -70.99, y = -820.38, z = 326.18, heading = 239.87,outside=true, },
			{id = 20, modelHash = "s_m_m_highsec_02",Weapon =0x63AB0442,x = -80.06, y = -817.32, z = 326.18, heading = 61.46,outside=true, },
			--SUBMARINE
			{id = 21, modelHash = "u_m_y_juggernaut_01",isBoss=true,x = 493.8, y = -3230.39, z = 6.07, heading = 235.03,outside=true, },	
			{id = 22, modelHash = "mp_g_m_pros_01",Weapon =0xAF113F99,x = 516.22, y = 4886.22, z = -66.19, heading = 86.66},
			{id = 23, modelHash = "s_m_y_ammucity_01",Weapon =0xAF113F99,x = 514.85, y = 4890.48, z = -66.14, heading = 84.92},
			{id = 24, modelHash = "G_M_M_ChiCold_01",Weapon =0xAF113F99,x = 516.64, y = 4890.54, z = -66.14, heading = 246.68},		

			{id = 25, modelHash = "U_M_Y_Tattoo_01",Weapon =0xAF113F99,x = 514.96, y = 4901.41, z = -65.77, heading = 158.71 },
			{id = 26, modelHash = "s_m_y_robber_01",Weapon =0xAF113F99,x = 517.06, y = 4906.03, z = -66.14, heading = 165.82},
			{id = 27, modelHash = "s_m_y_dealer_01",Weapon =0xAF113F99,x = 515.52, y = 4888.05, z = -68.99, heading = 145.73},
			{id = 28, modelHash = "s_m_y_xmech_02",Weapon =0xAF113F99,x = 512.48, y = 4876.5, z = -68.99, heading = 265.71},
			{id = 29, modelHash = "mp_m_weapexp_01",isBoss=true, x = 515.89, y = 4855.31, z = -68.99, heading = 98.32  },
			{id = 30, modelHash = "ig_josef",isBoss=true,x = 512.87, y = 4869.54, z = -68.99, heading = -97.11  },	
			{id = 31, modelHash = "g_m_y_lost_01",Weapon =0xAF113F99,x = 515.89, y = 4850.1, z = -68.99, heading = 142.67  },	
			{id = 32, modelHash = "g_m_y_lost_02",Weapon =0xAF113F99,x = 513.97, y = 4843.78, z = -68.99, heading = 364.44 },
			{id = 33, modelHash = "g_m_y_lost_03",Weapon =0x624FE830, x = 514.36, y = 4835.97, z = -68.99, heading = 97.82 },	
			{id = 34, modelHash = "s_m_y_xmech_02_mp",Weapon =0x624FE830, x = 515.75, y = 4827.56, z = -68.99, heading = 76.78 },	
			{id = 35, modelHash = "mp_m_bogdangoon",isBoss=true, x = 514.25, y = 4818.86, z = -68.99, heading = 2.03 },	
			{id = 36, modelHash = "u_f_y_bikerchic",Weapon =0xAF113F99, x = 512.77, y = 4840.49, z = -68.99, heading = 271.79  },

			{id = 37, modelHash = "mp_g_m_pros_01",Weapon =0xAF113F99,x = 516.69, y = 4877.04, z = -62.59, heading = 354.25},
			{id = 38, modelHash = "s_m_y_ammucity_01",Weapon =0xAF113F99, x = 514.28, y = 4878.45, z = -62.59, heading = 232.69},

			{id = 39, modelHash = "ig_terry",isBoss=true, x = 515.91, y = 4869.63, z = -62.56, heading = 90.52  },
			{id = 40, modelHash = "mp_m_exarmy_01",isBoss=true,x = 512.55, y = 4855.17, z = -62.56, heading = 270.37  },	
			{id = 41, modelHash = "G_M_M_ChiCold_01",Weapon =0xAF113F99,x = 512.6, y = 4849.9, z = -62.59, heading = 187.76},
			{id = 42, modelHash = "mp_m_boatstaff_01",Weapon =0xAF113F99,x = 514.29, y = 4838.81, z = -62.59, heading = 81.42, target=true },
			{id = 43, modelHash = "U_M_Y_Tattoo_01",Weapon =0xAF113F99,x = 515.3, y = 4826.94, z = -62.59, heading = 24.18 },
			
			{id = 44, modelHash = "s_m_y_robber_01",Weapon =0x624FE830,x = 510.89, y = 4826.76, z = -66.19, heading = 312.67  },	
			{id = 45, modelHash = "s_m_y_dealer_01",Weapon =0xAF113F99,x = 517.12, y = 4835.62, z = -66.19, heading = 170.86 },
			{id = 46, modelHash = "g_f_y_lost_01",Weapon =0x624FE830,x = 510.94, y = 4836.59, z = -66.19, heading = 176.34 },
			{id = 47, modelHash = "s_m_y_ammucity_01",Weapon =0xAF113F99,x = 514.29, y = 4845.12, z = -66.19, heading = 169.4 },
			--gun bunker			
			{id = 48, modelHash = "s_m_y_ammucity_01",Weapon =0xAF113F99, x = 870.21, y = -3232.62, z = -98.29, heading = 210.3 },	
			{id = 49, modelHash = "mp_g_m_pros_01",Weapon =0xAF113F99, x = 870.07, y = -3232.71, z = -98.29, heading = -3.39 },		

			{id = 50, modelHash = "U_M_Y_Tattoo_01",Weapon =0xAF113F99, x = 857.37, y = -3241.11, z = -98.49, heading = 185.53  },
			{id = 51, modelHash = "s_m_y_robber_01",Weapon =0x624FE830,x = 850.7, y = -3236.79, z = -98.7, heading = 272.96 },	
			{id = 52, modelHash = "s_m_y_dealer_01",Weapon =0xAF113F99,x = 841.21, y = -3231.27, z = -98.32, heading = 232.52 },
			{id = 53, modelHash = "g_f_y_lost_01",Weapon =0x624FE830,x = 827.36, y = -3243.45, z = -98.99, heading = 276.2 }, 
			{id = 54, modelHash = "s_m_y_ammucity_01",Weapon =0xAF113F99,x = 835.6, y = -3227.94, z = -98.23, heading = 205.49 },
			{id = 55, modelHash = "mp_m_exarmy_01",isBoss=true,x = 829.07, y = -3243.24, z = -98.7, heading = 269.12  },
			{id = 56, modelHash = "s_m_y_xmech_02",Weapon =0x624FE830,x = 851.62, y = -3231.35, z = -98.37, heading = 263.11},	
			{id = 57, modelHash = "G_M_M_ChiCold_01",Weapon =0x624FE830,x = 861.41, y = -3216.01, z = -98.36, heading = 89.81},	
			{id = 58, modelHash = "g_m_y_lost_01",Weapon =0x624FE830,x = 866.38, y = -3217.59, z = -97.86, heading = 250.43},
			{id = 59, modelHash = "g_m_y_lost_02",Weapon =0x624FE830,x = 878.72, y = -3204.9, z = -97.82, heading = 257.29},	
			{id = 60, modelHash = "g_m_y_lost_03",Weapon =0xAF113F99,x = 877.2, y = -3204.7, z = -97.39, heading = 73.57},	

			{id = 61, modelHash = "mp_m_bogdangoon",isBoss=true, x = 866.63, y = -3190.59, z = -96.19, heading = 351.22 },	
			{id = 62, modelHash = "g_f_y_lost_01",Weapon =0x0781FE4A,x = 865.34, y = -3190.89, z = -96.15, heading = 350.41 },	
			{id = 63, modelHash = "s_m_y_ammucity_01",Weapon =0x624FE830,x = 868.71, y = -3190.46, z = -96.25, heading = 351.96 },	

			{id = 64, modelHash = "u_m_y_babyd",isBoss=true, x = 935.19, y = -3232.66, z = -98.29, heading = 166.27 },	
			{id = 65, modelHash = "s_m_y_ammucity_01",Weapon =0x0781FE4A,x = 933.53, y = -3232.52, z = -98.29, heading = 178.36 },	
			{id = 66, modelHash = "G_M_M_ChiCold_01",Weapon =0x624FE830,x = 936.97, y = -3232.37, z = -98.29, heading = 176.55 },	
			{id = 67, modelHash = "s_m_y_xmech_02_mp",Weapon =0x624FE830,x = 938.29, y = -3229.97, z = -98.29, heading = 261.14},	
			{id = 68, modelHash = "mp_g_m_pros_01",Weapon =0xB1CA77B1,x = 946.52, y = -3219.99, z = -98.29, heading = 265.52},
			{id = 69,modelHash = "u_m_y_juggernaut_01",isBoss=true,x = 933.49, y = -3192.47, z = -98.26, heading = -136.71},

			{id = 70, modelHash = "U_M_Y_Tattoo_01",Weapon =0x0781FE4A,x = 933.3, y = -3198.72, z = -98.26, heading = 87.74},	
			{id = 71, modelHash = "g_m_y_lost_01",Weapon =0x624FE830,x = 935.17, y = -3198.61, z = -98.26, heading = 277.79},
			{id = 72, modelHash = "g_m_y_lost_02",Weapon =0x624FE830,x = 945.1, y = -3211.91, z = -98.28, heading = 182.33 },	
			{id = 73, modelHash = "g_m_y_lost_03",Weapon =0xAF113F99,x = 944.83, y = -3208.88, z = -98.27, heading = 7.01},	
			
			{id = 74,modelHash = "mp_m_weapexp_01",isBoss=true,x = 900.46, y = -3202.18, z = -97.51, heading = 210.69},
			{id = 75, modelHash = "s_m_y_robber_01",Weapon =0x0781FE4A, x = 891.51, y = -3198.75, z = -98.19, heading = 240.35},
			{id = 76, modelHash = "s_m_y_dealer_01",Weapon =0xAF113F99, x = 907.53, y = -3230.65, z = -98.29, heading = 34.66},	
			{id = 77, modelHash = "u_f_y_bikerchic",Weapon =0xAF113F99, x = 904.02, y = -3230.79, z = -98.29, heading = 334.81},
			{id = 78, modelHash = "u_f_y_bikerchic",Weapon =0x624FE830,  x = 906.75, y = -3219.15, z = -98.25, heading = 281.28},
			{id = 79, modelHash = "s_m_y_xmech_02",Weapon =0xAF113F99,  x = 898.13, y = -3211.43, z = -98.22, heading = 187.56},	
			{id = 80, modelHash = "s_m_y_ammucity_01",Weapon =0xAF113F99, x = 886.71, y = -3212.3, z = -98.2, heading = 333.94},	
			{id = 81, modelHash = "g_m_y_lost_01",Weapon =0xAF113F99,  x = 885.84, y = -3199.93, z = -98.19, heading = 340.02},	
			{id = 82, modelHash = "g_m_y_lost_02",Weapon =0x624FE830,  x = 891.02, y = -3190.81, z = -97.03, heading = 90.02},
			{id = 83, modelHash = "g_m_y_lost_03",Weapon =0x624FE830, x = 894.17, y = -3190.26, z = -97.03, heading = 25.13},	

			{id = 84, modelHash = "s_m_y_ammucity_01",Weapon =0xB1CA77B1,  x = 887.8, y = -3188.1, z = -97.01, heading = -13.02},	
			{id = 85, modelHash = "s_m_y_ammucity_01",Weapon =0x624FE830,  x = 890.92, y = -3188.07, z = -96.99, heading = -7.69},
			{id = 86, modelHash = "ig_terry",isBoss=true, x = 889.8, y = -3174.14, z = -97.12, heading = 231.67},

			{id = 87, modelHash = "mp_g_m_pros_01",Weapon =0x624FE830, x = 930.83, y = -3230.27, z = -98.29, heading = 49.7},	

			{id = 88, modelHash = "U_M_Y_Tattoo_01",Weapon =0xB1CA77B1,  x = 933.46, y = -3219.61, z = -98.28, heading = 39.17},	
			{id = 89, modelHash = "s_m_y_ammucity_01",Weapon =0x624FE830,x = 919.77, y = -3197.17, z = -98.26, heading = 230.99},
			{id = 90, modelHash = "ig_cletus",isBoss=true,x = 929.29, y = -3208.12, z = -98.26, heading = 231.47},								
			
		
    },
	
	Events = {
	
		--[[	{ 
		  Type="Vehicle",
		  Position = { x = -103.41, y = -438.73, z = 36.02, heading = 167.51 }, 
		  Size     = {radius=10000},
		  SpawnHeight =200.0,
		  FacePlayer = true,
		  --NumberPeds=10,
		  isBoss=false,
		  Target=false,
		  Vehicle="trailersmall",
		  Weapon=0xBD248B55,
		  SquadSpawnRadius=1.0,
		  Message="~h~~r~Warning: Psychotronic countermeasures deployed. Civilians may be hostile.",
		  --CheckGroundZ=true,
		},	]]--
	
		{ 
		  Type="Aircraft",
		  Position = {x = -2981.75, y = 3277.26, z = 9.91, heading = 284.19 }, 
		  Size     = {radius=1000.0},
		  SpawnHeight =200.0,
		  FacePlayer = true,
		  --NumberPeds=10,
		  isBoss=false,
		  Target=false,
		  Vehicle="tula",
		 Weapon=0x13532244,
		  SquadSpawnRadius=1.0,
		  --CheckGroundZ=true,
		},	
		{ 
		  Type="Aircraft",
		  Position = { x = -3009.96, y = 3398.75, z = 10.44, heading = 265.66 }, 
		  Size     = {radius=1000.0},
		  SpawnHeight =200.0,
		  FacePlayer = true,
		  --NumberPeds=10,
		  isBoss=false,
		  Target=false,
		  Vehicle="starling",
		 -- Weapon=0x0781FE4A,
		  SquadSpawnRadius=1.0,
		  --CheckGroundZ=true,
		},

		{ 
		  Type="Aircraft",
		  Position = { x = -2941.0, y = 3514.49, z = 8.3, heading = 238.99}, 
		  Size     = {radius=1000.0},
		  SpawnHeight =200.0,
		  FacePlayer = true,
		  --NumberPeds=10,
		  isBoss=false,
		  Target=false,
		  Vehicle="pyro",
		 -- Weapon=0x0781FE4A,
		  SquadSpawnRadius=1.0,
		  --CheckGroundZ=true,
		},

		{ 
		  Type="Aircraft",
		  Position = { x = -75.06, y = -819.3, z = 326.18, heading = 377.86,}, 
		  Size     = {radius=500.0},
		  SpawnHeight =60.0,
		  FacePlayer = true,
		  --NumberPeds=10,
		  isBoss=false,
		  Target=false,
		  Vehicle="akula",
		  Weapon=0x13532244,
		  SquadSpawnRadius=1.0,
		  --CheckGroundZ=true,
		},
		{ 
		  Type="Aircraft",
		  Position = {x = 501.9, y = -3032.73, z = 6.08, heading = 356.03,}, 
		  Size     = {radius=1000.0},
		  SpawnHeight =300.0,
		  FacePlayer = true,
		  --NumberPeds=10,
		  isBoss=false,
		  Target=false,
		  Vehicle="bombushka",
		  Weapon=0x13532244,
		  SquadSpawnRadius=1.0,
		  --CheckGroundZ=true,
		},
		{ 
		  Type="Aircraft",
		  Position = {x = 576.48, y = -3028.14, z = 6.07,heading = 360.01,}, 
		  Size     = {radius=750.0},
		  SpawnHeight =300.0,
		  FacePlayer = true,
		  --NumberPeds=10,
		  isBoss=false,
		  Target=false,
		  Vehicle="hunter",
		  Weapon=0x13532244,
		  SquadSpawnRadius=1.0,
		  --CheckGroundZ=true,
		},	
		{ Type="Vehicle",
		  Position = {x = 492.26, y = -3244.5, z = 6.07, heading = 178.93}, 
		  Size     = {radius=300.0},
		  SpawnHeight =300.0,
		  FacePlayer = true,
		  --NumberPeds=10,
		  isBoss=false,
		  Target=false,
		  Vehicle="barrage",
		  Weapon=0x13532244,
		  SquadSpawnRadius=1.0,
		  --CheckGroundZ=true,
		},

		{Type="Vehicle",
		  Position = {x = 576.48, y = -3028.14, z = 6.07,heading = 360.01,}, 
		  Size     = {radius=300.0},
		  SpawnHeight =300.0,
		  FacePlayer = true,
		  --NumberPeds=10,
		  isBoss=false,
		  Target=false,
		  Vehicle="menacer",
		  Weapon=0x13532244,
		  SquadSpawnRadius=1.0,
		  --CheckGroundZ=true,
		},

		{ Type="Vehicle",
		  Position = {x = -3030.34, y = 3343.55, z = 9.67, heading = 269.4}, 
		  Size     = {radius=300.0},
		  SpawnHeight =500.0,
		  FacePlayer = true,
		  --NumberPeds=10,
		  isBoss=false,
		  Target=false,
		  Vehicle="trailersmall2",
		  Weapon=0x13532244,
		  SquadSpawnRadius=1.0,
		  nomods=true,
		  driverfiringpattern=0xC6EE6B4C,
		  --CheckGroundZ=true,
		},

		{Type="Vehicle",
		  Position = {x = -3037.55, y = 3321.99, z = 10.49, heading = 267.36}, 
		  Size     = {radius=500.0},
		  SpawnHeight =300.0,
		  FacePlayer = true,
		  --NumberPeds=10,
		  isBoss=false,
		  Target=false,
		  Vehicle="trailersmall2",
		  Weapon=0x13532244,
		  SquadSpawnRadius=1.0,
		  nomods=true,
		  driverfiringpattern=0xC6EE6B4C,
		  --CheckGroundZ=true,
		},		

	},	

    Vehicles = {
		--maze bank
		 --{id = 1, id2 = 1, Vehicle = "akula", modelHash = "s_m_y_ammucity_01",x = -75.06, y = -819.3, z = 326.18+60, heading = 377.86, Weapon=0x13532244,outside=true,pilot=true, isAircraft=true,},
		 --SUBMARINE
		-- {id = 2, id2 = 2, Vehicle = "barrage", modelHash = "s_m_y_ammucity_01",x = 492.26, y = -3244.5, z = 6.07, heading = 178.93, Weapon=0x13532244,outside=true,},
		 --{id = 3, id2 = 3, Vehicle = "menacer", modelHash = "s_m_y_ammucity_01",x = 500.2, y = -3219.9, z = 6.07, heading = 355.45, Weapon=0x13532244,outside=true,},
		 --{id = 4, id2 = 4, Vehicle = "bombushka", modelHash = "s_m_y_ammucity_01",x = 501.9, y = -3032.73, z = 6.08+1000, heading = 356.03, Weapon=0x13532244,outside=true,pilot=true, isAircraft=true,},
		 --{id = 5, id2 = 5, Vehicle = "hunter", modelHash = "s_m_y_ammucity_01",x = 576.48, y = -3028.14, z = 6.07+1000, heading = 360.01, Weapon=0x13532244,outside=true,pilot=true, isAircraft=true,},
		 
		 --gun bunker
		 --{id = 6, id2 = 6, Vehicle = "trailersmall2", modelHash = "s_m_y_ammucity_01",  x = -3045.66, y = 3332.0, z = 11.93, heading = 275.61, Weapon=0x13532244,outside=true,nomods=true,driverfiringpattern=0xC6EE6B4C},
		 --{id = 7, id2 = 7, Vehicle = "trailersmall2", modelHash = "s_m_y_ammucity_01",x = -3057.6, y = 3329.54, z = 12.31, heading = 277.92, Weapon=0x13532244,outside=true,nomods=true,driverfiringpattern=0xC6EE6B4C},
		 
		 --{id = 8, id2 = 8, Vehicle = "tula", modelHash = "s_m_y_ammucity_01",x = -2981.75, y = 3277.26, z = 9.91+1000.0, heading = 284.19,Weapon=0x13532244,outside=true,pilot=true, isAircraft=true,},
		--{id = 9, id2 = 9, Vehicle = "starling", modelHash = "s_m_y_ammucity_01", x = -3009.96, y = 3398.75, z = 10.44+1500, heading = 265.66,Weapon=0x13532244,outside=true,pilot=true, isAircraft=true,},
		-- {id = 10, id2 = 10, Vehicle = "pyro", modelHash = "s_m_y_ammucity_01",x = -2941.0, y = 3514.49, z = 8.3+1250, heading = 238.99,Weapon=0x13532244,outside=true,pilot=true, isAircraft=true,},
		 
		-- {id = 1, id2 = 1, Vehicle = "bmx", modelHash = "s_m_y_dealer_01", x = 2338.23, y = 2914.42, z = -84.8, heading = 174.26, Weapon=0x624FE830},
		--{id = 2, id2 = 2, Vehicle = "bmx", modelHash = "s_m_y_robber_01", x = 2338.5, y = 2930.59, z = -84.8, heading = 355.12,Weapon=0x624FE830},
      -- ID: id of NPC | name: Name of Blip | BlipID: Icone of Blip | VoiceName: NPC Talk When near it | Ambiance: Ambiance of Shop | Weapon: Hash of Weapon | modelHash: Model | X: Position x | Y: Position Y | Z: Position Z | heading: Where Npc look
   	  --**IMPORTANT: make sure the id of the ped starts from 1, each Peds id in above, increments by 1 and matches that entries index if it were in an array***
	  --vehicles are not consistent, so use ExtraPeds at your own discretion.
	  --Below takes a ped with id=1 from Peds above and will put it in seatid = -2   
	 -- {id = 1, id2 = 1, Vehicle = "annihilator", modelHash = "S_M_M_ChemSec_01",  x = -1166.42, y = 4641.5, z = 145.11, heading = 210.07,driving=true,pilot=true},
	 -- {id = 2, id2 = 2, Vehicle = "toro2", modelHash = "s_m_y_ammucity_01",  x = -3014.83, y = -43.5, z = 0.13, heading = 151.19, driving=true},
    }
  },

 
Mission40 = {
    
	StartMessage = "Infiltrate the secret underground facility~n~that you learned about from a vault heist",
	FinishMessage = "~q~Interdimensional portal secured!",
	MissionTitle = "They Live",
	MissionMessage = "Infiltrate the secret underground facility~n~that you learned about from a vault heist",	
	Type = "ObjectiveRescue",	
	IndoorsMission = true,
	--MissionLengthMinutes = 1,
	--IndoorsMissionStrongSpawnCheck = true,
	ObjectiveRescueShortRangeBlip = true,
	--TeleportToSafeHouseOnMissionStart = false,
	ObjectRescueReward = 3000,
	MissionTriggerRadius=20.0,
	HostageRescue = true,
	
	SMS_Subject="They Live",
	SMS_Message="Intel has revealed a deep secret underground facility that needs to be investigated",
	SMS_Message2="There are rumors of secret experiments. Would you like to take the mission?",
	--SMS_Message3="This will help finish off thre threat. Can you help?",	
		
	--SMS_ContactPics={"CHAR_AGENT14",
	--},
	--SMS_ContactNames={"Agency Contact",
	--},
	SMS_NoFailedMessage=true,
	SMS_NoPassedMessage=true,
	SMS_FailedSubject="HAHA",
	SMS_FailedMessage="You should have stayed away, this is much bigger than you",
	SMS_PassedSubject="Thank you",
	SMS_PassedMessage="Los Santos is safe and sound from the attack",		
	
	
    Blips = {{
		  Title = "Mission: Secret Underground Facility",
		  Position =  { x = 2051.47, y = 2949.48, z = 47.74},
		  Icon     = 58,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 1,
		},
	
		},

    Marker = {
      Type     = 1,
      Position = {x = -75000.16, y = -818000.96, z = 325000.19}, 
      Size     = {x = 5.0, y = 5.0, z = 325.0},
      Color    = {r = 237, g = 41, b = 57},
      DrawDistance = 3000.0,
    },
	
	
	BlipS = { --safehouse blip 
		  Title = "Mission Safehouse",
		  Position = { x = 1731.94, y = 3308.24, z = 41.22}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 417,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 2,
		  Alpha	 =80, 
	},	
	MarkerS = { --safehouse marker
		  Type     = 1,
		  Position = { x = 1731.94, y = 3308.24, z = 40.22},  --{  x = 1944.96, y = 3150.6, z = 46.77}, 
		  Size     = {x = 6.0, y = 6.0, z = 2.0},
		  Color    = {r = 117, g = 218, b = 255},
		  DrawDistance = 200.0,
	},
	--[[
	BlipSL = { --safehouse Vehicle blip 
		  Title = "Mission Vehicle Safehouse",
		  Position = { x = 1480.63, y = 3167.93, z = 40.99}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 421,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
	},
	BlipSB = { --safehouse boat blip 
		  Title = "Mission Boat Safehouse",
		  Position = {x = 1481.84, y = 3873.37, z = 30.04}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		 Icon     = 404,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
	},	
	]]--
	Events = {
		--[[	{ 
		  Type="Vehicle",
		  Position = { x = -103.41, y = -438.73, z = 36.02, heading = 167.51 }, 
		  Size     = {radius=10000},
		  SpawnHeight =200.0,
		  FacePlayer = true,
		  --NumberPeds=10,
		  isBoss=false,
		  Target=false,
		  Vehicle="trailersmall",
		  Weapon=0xBD248B55,
		  SquadSpawnRadius=1.0,
		  Message="~h~~r~Warning: Psychotronic countermeasures deployed. Civilians may be hostile.",
		  --CheckGroundZ=true,
		},	
	
	]]--
	},
	
	Props = {
	--[[
		{ id=1,  Name = "prop_c4_final_green", isObjective=true,Position = { x = 1723.83, y = 3308.42, z = 41.22, heading = 95.18 }},
		{ id=2,  Name = "sm_prop_smug_crate_l_narc",isObjective=true, Position = {x = 1724.91, y = 3303.87, z = 41.22, heading = 174.83  }},
		--maze building:
		{ id=3,  Name = "p_spinning_anus_s", Freeze=true, Position = {x = -75.16, y = -818.96, z = 646.19, heading = 302.43}},
		{ id=4,  Name = "xm_prop_orbital_cannon_table", Freeze=true, Position = {x = -75.16, y = -818.96, z = 326.19, heading = 302.43}},
		--{ id=5,  Name = "xs_prop_arena_turret_01a_sf", Position = {x = -75.16, y = -818.96, z = 326.19, heading = 302.43}},
		--{ id=5,  Name = "xs_prop_ar_buildingx_01a_sf", Position = {x = -75.16, y = -818.96, z = 326.19, heading = 302.43}},
		--facility1:
		{ id=6,  Name = "xm_prop_orbital_cannon_table",Freeze=true, Position = {x = 352.38, y = 4874.60, z = -60.79, heading = 294.43}},
		{ id=7,  Name = "hei_prop_hst_usb_drive",isObjective=true, Freeze=true, Position = {x = 352.38, y = 4874.60, z = -60.89, heading = 294.43}},
		--table: 
		{ id=8,  Name = "hei_prop_hst_usb_drive",isObjective=true, Freeze=true,Position = { x = 328.46, y = 4828.83, z = -58.60, heading = 294.43}},
		]]--
		--facility2:
		{ id=1,  Name = "hei_prop_hst_usb_drive",isObjective=true, Freeze=true,  Position = {x = 2022.58, y = 3020.78, z = -72.79, heading = 50.16}},
		{ id=2,  Name = "xm_prop_orbital_cannon_table",  Freeze=true, Position = {x = 2022.58, y = 3020.78, z = -72.69, heading = 50.16}},
		
	
    },
	
	

	
	Pickups = {
	},
	MissionPickups = {
		
	},	
		
	

    Peds = {
	
			{id = 1, Weapon =0x3AABBBAA,  modelHash = "mp_m_avongoon",x = 2135.93, y = 2926.16, z = -61.9, heading = 178.5},
			{id = 2, Weapon =0x3AABBBAA,  modelHash = "mp_m_avongoon", x = 2136.46, y = 2916.63, z = -61.9, heading = 4.6 },	
			{id = 3, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon", x = 2132.99, y = 2926.4, z = -61.9, heading = 242.13 },
			
			{id = 4, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon",x = 2117.72, y = 2928.85, z = -61.9, heading = 208.79},
			{id = 5, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon",  x = 2117.46, y = 2931.18, z = -61.9, heading = 191.57 },	
			{id = 6, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon", x = 2117.37, y = 2933.08, z = -61.9, heading = 190.14 },		
			{id = 7, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon",x = 2104.15, y = 2931.8, z = -61.9, heading = 219.83 },
			{id = 8, Weapon =0xB1CA77B1,  modelHash = "mp_m_avongoon", x = 2104.64, y = 2932.77, z = -61.9, heading = 171.82},	
			{id = 9, Weapon =0x7FD62962,  modelHash = "mp_m_avongoon", x = 2081.53, y = 2933.22, z = -61.9, heading = 247.38  },	
			{id = 10, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon",x = 2079.43, y = 2934.16, z = -61.9, heading = 222.3},
			{id = 11, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon", x = 2076.24, y = 2927.98, z = -61.9, heading = 248.19  },	
			{id = 12, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon", x = 2076.42, y = 2932.66, z = -61.9, heading = 253.94 },		
			{id = 13, Weapon =0x624FE830,  modelHash = "mp_m_avongoon", x = 2076.4, y = 2933.57, z = -61.9, heading = 253.73 },	
			{id = 14, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon",  x = 2116.47, y = 2934.97, z = -65.5, heading = 81.76   },	
			{id = 15, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon",x = 2094.18, y = 2935.12, z = -65.5, heading = 108.32 },		
			{id = 16, Weapon =0x624FE830,  modelHash = "mp_m_avongoon", x = 2106.09, y = 2935.19, z = -65.5, heading = 104.47 },
			{id = 17, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon",x = 2025.61, y = 2964.75, z = -65.5, heading = 283.09 },		
			{id = 18, Weapon =0x624FE830,  modelHash = "mp_m_avongoon", x = 2020.17, y = 2978.04, z = -65.5, heading = 218.14 },
			{id = 19, Weapon =0xB1CA77B1,  modelHash = "mp_m_avongoon", x = 2033.42, y = 2963.56, z = -65.5, heading = 63.62 },	
			{id = 20, Weapon =0x624FE830,  modelHash = "mp_m_avongoon", x = 2020.17, y = 2978.04, z = -65.5, heading = 218.14 },
			{id = 21, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon", x = 2049.26, y = 2943.85, z = -61.9, heading = 232.09 },	
			{id = 22, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon",x = 2047.64, y = 2945.56, z = -61.9, heading = 180.96 },				
			{id = 23,   modelHash = "u_m_y_juggernaut_01", isBoss=true, x = 2048.35, y = 2943.44, z = -61.9, heading = 206.87 },
			{id = 24, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon",x = 2051.23, y = 2965.27, z = -61.9, heading = 106.89 },	
			{id = 25, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon",x = 2047.08, y = 2968.28, z = -61.9, heading = 178.25 },	
			{id = 26, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon",x = 2044.7, y = 2979.32, z = -61.9, heading = 236.36  },	
			{id = 27, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon",x = 2048.83, y = 2986.73, z = -61.9, heading = 222.22 },			
			{id = 28,   modelHash = "u_m_y_juggernaut_01", isBoss=true,  x = 2064.36, y = 2987.65, z = -62.5, heading = 130.48 },			
			{id = 29, Weapon =0xAF113F99,  modelHash = "mp_m_boatstaff_01", x = 2065.81, y = 2996.5, z = -63.5, heading = 156.67,target=true },	
			{id = 30, Weapon =0xAF113F99,  modelHash = "s_m_m_pilot_01", x = 2072.19, y = 2992.51, z = -63.5, heading = 116.02,target=true },			
			{id = 31, Weapon =0x0781FE4A,  modelHash = "mp_m_avongoon", x = 2064.55, y = 2994.03, z = -63.3, heading = 186.66 },		
			{id = 32, Weapon =0xB1CA77B1,  modelHash = "mp_m_avongoon",  x = 2065.86, y = 2984.1, z = -62.3, heading = 61.96},	
			{id = 23, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon",x = 2045.68, y = 2969.99, z = -61.9, heading = 298.84 },	
			{id = 34, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon", x = 2041.42, y = 2977.34, z = -67.3, heading = 213.74 },	
			{id = 35, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon",x = 2040.55, y = 2974.02, z = -67.3, heading = 245.23 },

			{id = 36, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon", x = 2052.71, y = 2963.62, z = -67.3, heading = 42.43},	
			{id = 37, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon", x = 2054.56, y = 2960.9, z = -67.3, heading = 30.19 },	
			{id = 38, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon",x = 2057.57, y = 2968.52, z = -67.3, heading = 36.57 },			
			{id = 39, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon",x = 2059.42, y = 2966.41, z = -67.3, heading = 45.99},	
			{id = 40, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon", x = 2048.59, y = 2976.55, z = -67.3, heading = 230.29 },	
			{id = 41, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon",x = 2044.73, y = 2979.52, z = -67.3, heading = 231.73 },			
			{id = 42, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon",x = 2052.04, y = 2982.98, z = -67.3, heading = 230.11  },	
			{id = 43, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon",x = 2048.66, y = 2985.56, z = -67.3, heading = 231.37 },	
			{id = 44, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon",x = 2062.14, y = 2976.01, z = -67.3, heading = 419.09 },						
			{id = 45, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon",x = 2063.49, y = 2978.89, z = -67.3, heading = 73.66 },	
			
			{id = 46, Weapon =0xAF113F99,  modelHash = "s_m_m_fiboffice_01",x = 2072.51, y = 2994.85, z = -67.7, heading = 116.19,target=true  },	
			{id = 47, Weapon =0xAF113F99,  modelHash = "mp_m_boatstaff_01",x = 2069.71, y = 2997.88, z = -67.7, heading = 150.84,target=true  },	
			{id = 48, Weapon =0xAF113F99,  modelHash = "s_m_m_fiboffice_02",x = 2065.0, y = 2997.58, z = -67.7, heading = 160.05,target=true },						
			{id = 49, Weapon =0xAF113F99,  modelHash = "s_m_m_pilot_01",x = 2071.08, y = 2991.87, z = -67.7, heading = 127.15,target=true },
			{id = 50,  modelHash = "u_m_y_juggernaut_01", isBoss=true,  x = 2063.86, y = 2987.89, z = -67.7, heading = 147.19 },	
			{id = 51, Weapon =0x0781FE4A,  modelHash = "mp_m_avongoon",x = 2067.65, y = 2986.05, z = -67.7, heading = 104.73 },						
			{id = 52, Weapon =0xB1CA77B1,  modelHash = "mp_m_avongoon",x = 2060.1, y = 2990.17, z = -67.7, heading = 192.66 },				
			{id = 53, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon",x = 2067.64, y = 2973.48, z = -72.7, heading = 35.64 },						
			{id = 54, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon",x = 2070.0, y = 2974.28, z = -72.7, heading = 36.31},	
			{id = 55, Weapon =0xB1CA77B1,  modelHash = "mp_m_avongoon",x = 2054.7, y = 2984.83, z = -72.7, heading = 228.82 },				
			{id = 56, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon",x = 2059.72, y = 2988.19, z = -72.7, heading = 167.6 },						
			{id = 57, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon", x = 2059.85, y = 2993.04, z = -72.7, heading = 120.17},	
			{id = 58,  modelHash = "s_m_m_movalien_01", isBoss=true,  x = 2029.85, y = 3027.48, z = -72.71, heading = 156.27 },	
			{id = 59,  modelHash = "s_m_m_movalien_01", isBoss=true,  x = 2026.52, y = 3033.33, z = -72.71, heading = 171.98 },	
			{id = 60,  modelHash = "s_m_m_movalien_01", isBoss=true,  x = 2029.01, y = 3028.73, z = -72.71, heading = 143.73 },	
			{id = 61,  modelHash = "s_m_m_movalien_01", isBoss=true,  x = 2025.2, y = 3034.68, z = -72.71, heading = 190.51 },
			{id = 62, Weapon =0xB1CA77B1,  modelHash = "s_m_m_scientist_01",x = 2035.63, y = 2989.43, z = -72.7, heading = 298.96,friendly=true },				
			{id = 63, Weapon =0xAF113F99,  modelHash = "ig_milton",x = 2036.04, y = 2987.19, z = -72.7, heading = 40.78 ,target=true },						
			{id = 64, Weapon =0xAF113F99,  modelHash = "s_m_m_scientist_01", x = 2033.77, y = 2989.52, z = -72.7, heading = 209.3,friendly=true},				
			{id = 65, Weapon =0xAF113F99,  modelHash = "mp_m_boatstaff_01", x = 2053.53, y = 2997.73, z = -72.7, heading = 124.18,target=true },	
			{id = 66, Weapon =0xAF113F99,  modelHash = "s_m_m_pilot_01",  x = 2047.6, y = 2994.13, z = -72.7, heading = 278.22,target=true },	
			{id = 67, modelHash = "ig_bankman",Weapon =0xAF113F99,x = 2035.77, y = 3005.87, z = -72.7, heading = 233.93,target=true },			
			{id = 68, modelHash = "s_f_y_movprem_01",Weapon =0xAF113F99, x = 2040.95, y = 2996.41, z = -72.7, heading = 260.05,target=true },	
			{id = 69, modelHash = "u_m_m_bankman",Weapon =0xAF113F99,x = 2035.73, y = 2996.84, z = -72.7, heading = 257.63,target=true },	
			{id = 70, modelHash = "s_m_m_movprem_01",Weapon =0xAF113F99, x = 2032.21, y = 2997.28, z = -72.7, heading = 258.56,target=true },
			{id = 71, modelHash = "ig_milton",Weapon =0xAF113F99, x = 2031.18, y = 3014.54, z = -72.7, heading = 224.9,target=true },
			{id = 72, modelHash = "cs_gurk",Weapon =0xAF113F99,x = 2038.48, y = 2991.41, z = -72.7, heading = 288.07,target=true },
			{id = 73, modelHash = "u_m_m_jewelthief",Weapon =0xAF113F99, x = 2037.57, y = 2994.8, z = -72.7, heading = 271.14 ,target=true },
			{id = 74, modelHash = "s_m_m_movprem_01",Weapon =0xAF113F99,  x = 2026.5, y = 3023.13, z = -72.71, heading = 202.27 ,target=true },
			{id = 75, modelHash = "s_f_y_movprem_01",Weapon =0xAF113F99, x = 2021.56, y = 3031.89, z = -72.71, heading = 199.34 ,target=true },
			
			--{id = 3, Weapon =0x13532244,  modelHash = "s_m_y_ammucity_01", x = 1738.55, y = 3275.43, z = 41.14+100.0, heading = 181.86,outside=true}-- x = 1732.15, y = 3320.26, z = 41.22, heading = 283.82,},
		
			
    },
	
	

    Vehicles = {
		-- {id = 1, id2 = 1, Vehicle = "bmx", modelHash = "s_m_y_dealer_01", x = 2338.23, y = 2914.42, z = -84.8, heading = 174.26, Weapon=0x624FE830},
		--{id = 2, id2 = 2, Vehicle = "bmx", modelHash = "s_m_y_robber_01", x = 2338.5, y = 2930.59, z = -84.8, heading = 355.12,Weapon=0x624FE830},
      -- ID: id of NPC | name: Name of Blip | BlipID: Icone of Blip | VoiceName: NPC Talk When near it | Ambiance: Ambiance of Shop | Weapon: Hash of Weapon | modelHash: Model | X: Position x | Y: Position Y | Z: Position Z | heading: Where Npc look
   	  --**IMPORTANT: make sure the id of the ped starts from 1, each Peds id in above, increments by 1 and matches that entries index if it were in an array***
	  --vehicles are not consistent, so use ExtraPeds at your own discretion.
	  --Below takes a ped with id=1 from Peds above and will put it in seatid = -2   
	 -- {id = 1, id2 = 1, Vehicle = "annihilator", modelHash = "S_M_M_ChemSec_01",  x = -1166.42, y = 4641.5, z = 145.11, heading = 210.07,driving=true,pilot=true},
	 -- {id = 2, id2 = 2, Vehicle = "toro2", modelHash = "s_m_y_ammucity_01",  x = -3014.83, y = -43.5, z = 0.13, heading = 151.19, driving=true},
    }
  }, 
  
  Mission41 = {
    
	StartMessage = "Investigate the secret facility",
	FinishMessage = "~q~Interdimensional portals secured!",
	MissionTitle = "Ong's Hat",
	MissionMessage = "Investigate the secret facility",	
	Type = "ObjectiveRescue",	
	IndoorsMission = true,
	--MissionLengthMinutes = 1,
	--IndoorsMissionStrongSpawnCheck = true,
	ObjectiveRescueShortRangeBlip = true,
	--TeleportToSafeHouseOnMissionStart = false,
	ObjectRescueReward = 3000,
	HostageRescueReward = 2000,  --cash
	MissionTriggerRadius=20.0,
	HostageRescue = true,
	
	SMS_Subject="Ong's Hat",
	SMS_Message="Intel has revealed a secret facility that needs to be investigated",
	SMS_Message2="There are rumors of secret experiments. Would you like to take the mission?",
	--SMS_Message3="This will help finish off thre threat. Can you help?",	
		
	--SMS_ContactPics={"CHAR_AGENT14",
	--},
	--SMS_ContactNames={"Agency Contact",
	--},
	SMS_NoFailedMessage=true,
	SMS_NoPassedMessage=true,
	SMS_FailedSubject="HAHA",
	SMS_FailedMessage="You should have stayed away, this is much bigger than you",
	SMS_PassedSubject="Thank you",
	SMS_PassedMessage="Los Santos is safe and sound from the attack",	
	
    Blips = {{
		  Title = "Secret Underground Facility",
		  Position =  {x = 1285.94, y = 2847.34, z = 49.36},
		  Icon     = 58,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 1,
		},
	
		},

    Marker = {
      Type     = 1,
      Position = {x = -75000.16, y = -81800.96, z = 32500.19}, 
      Size     = {x = 5.0, y = 5.0, z = 325.0},
      Color    = {r = 237, g = 41, b = 57},
      DrawDistance = 3000.0,
    },
	
	
	BlipS = { --safehouse blip 
		  Title = "Mission Safehouse",
		  Position = { x = 1731.94, y = 3308.24, z = 41.22}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 417,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 2,
		  Alpha	 =80, 
	},	
	MarkerS = { --safehouse marker
		  Type     = 1,
		  Position = { x = 1731.94, y = 3308.24, z = 40.22},  --{  x = 1944.96, y = 3150.6, z = 46.77}, 
		  Size     = {x = 6.0, y = 6.0, z = 2.0},
		  Color    = {r = 117, g = 218, b = 255},
		  DrawDistance = 200.0,
	},
	
	Events={
			--[[{ 
		  Type="Vehicle",
		  Position = { x = -103.41, y = -438.73, z = 36.02, heading = 167.51 }, 
		  Size     = {radius=10000},
		  SpawnHeight =200.0,
		  FacePlayer = true,
		  --NumberPeds=10,
		  isBoss=false,
		  Target=false,
		  Vehicle="trailersmall",
		  Weapon=0xBD248B55,
		  SquadSpawnRadius=1.0,
		  Message="~h~~r~Warning: Psychotronic countermeasures deployed. Civilians may be hostile.",
		  --CheckGroundZ=true,
		},	
	]]--
	
	},
	--[[
	BlipSL = { --safehouse Vehicle blip 
		  Title = "Mission Vehicle Safehouse",
		  Position = { x = 1480.63, y = 3167.93, z = 40.99}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 421,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
	},
	BlipSB = { --safehouse boat blip 
		  Title = "Mission Boat Safehouse",
		  Position = {x = 1481.84, y = 3873.37, z = 30.04}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		 Icon     = 404,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
	},	
	]]--
	
	Props = {
	--[[
	
		--maze building:
		{ id=3,  Name = "p_spinning_anus_s", Freeze=true, Position = {x = -75.16, y = -818.96, z = 646.19, heading = 302.43}},
		{ id=4,  Name = "xm_prop_orbital_cannon_table", Freeze=true, Position = {x = -75.16, y = -818.96, z = 326.19, heading = 302.43}},
		--{ id=5,  Name = "xs_prop_arena_turret_01a_sf", Position = {x = -75.16, y = -818.96, z = 326.19, heading = 302.43}},
		--{ id=5,  Name = "xs_prop_ar_buildingx_01a_sf", Position = {x = -75.16, y = -818.96, z = 326.19, heading = 302.43}},
		]]--
		--facility1:
		{ id=1,  Name = "xm_prop_orbital_cannon_table",Freeze=true, Position = {x = 352.38, y = 4874.60, z = -60.79, heading = 294.43}},
		{ id=2,  Name = "hei_prop_hst_usb_drive",isObjective=true, Freeze=true, Position = {x = 352.38, y = 4874.60, z = -60.89, heading = 294.43}},
		--table: 
		{ id=3,  Name = "hei_prop_hst_usb_drive",isObjective=true, Freeze=true,Position = { x = 328.46, y = 4828.83, z = -58.60, heading = 294.43}},
		
		--facility2:
		--{ id=1,  Name = "hei_prop_hst_usb_drive",isObjective=true, Freeze=true,  Position = {x = 2022.58, y = 3020.78, z = -72.79, heading = 50.16}},
		--{ id=2,  Name = "xm_prop_orbital_cannon_table",  Freeze=true, Position = {x = 2022.58, y = 3020.78, z = -72.69, heading = 50.16}},
		
	
    },
	
	

	
	Pickups = {
	},
	MissionPickups = {
		
	},	
		
	

    Peds = {
	
			{id = 1, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon",x = 418.43, y = 4826.94, z = -59.0, heading = 172.3},
			{id = 2, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon", x = 423.88, y = 4826.37, z = -59.0, heading = 250.73 },	
			
			{id = 3, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon",  x = 483.71, y = 4776.78, z = -58.99, heading = 58.72},
			{id = 4, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon",x = 486.38, y = 4775.73, z = -58.99,  heading = 244.2},
			
			{id = 5, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon",  x = 471.15, y = 4829.62, z = -58.99, heading = 322.3 },	
			{id = 6, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon",  x = 470.14, y = 4828.25, z = -58.99, heading = 145.59 },		
			
			{id = 7, Weapon =0x3AABBBAA,  modelHash = "mp_m_avongoon",x = 434.79, y = 4817.19, z = -59.0, heading = 349.03 },
			{id = 8, Weapon =0x3AABBBAA,  modelHash = "mp_m_avongoon", x = 434.62, y = 4826.06, z = -59.0, heading = 180.97},	
		
			{id = 9,  modelHash = "u_m_y_juggernaut_01", isBoss=true, x = 417.23, y = 4828.0, z = -59.0, heading = 254.09  },	
			
			{id = 10, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon",x = 423.04, y = 4813.94, z = -59.0, heading = -4.91},
			{id = 11, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon", x = 415.13, y = 4815.33, z = -59.0, heading = 323.67  },	
			{id = 12, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon", x = 416.31, y = 4810.79, z = -59.0, heading = 339.71 },		
			{id = 13, Weapon =0x624FE830,  modelHash = "mp_m_avongoon", x = 421.23, y = 4810.02, z = -59.0, heading = 359.66 },	
			
			
			{id = 14, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon",  x = 416.05, y = 4829.29, z = -59.0, heading = 185.68   },	
			{id = 15, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon",x = 415.63, y = 4831.95, z = -59.0, heading = 167.77 },

			
			{id = 16, Weapon =0xB1CA77B1,  modelHash = "mp_m_avongoon",x = 401.75, y = 4833.51, z = -59.0, heading = 224.19 },
			{id = 17, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon", x = 401.75, y = 4831.97, z = -59.0, heading = 239.35 },
			
			{id = 18, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon", x = 379.04, y = 4833.36, z = -59.0, heading = 223.83  },
			{id = 19, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon", x = 379.34, y = 4834.63, z = -59.0, heading = 232.76  },	
			{id = 20, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon", x = 377.36, y = 4834.47, z = -59.0, heading = 206.25 },
			
			
			{id = 21, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon", x = 374.46, y = 4833.6, z = -59.0, heading = 255.23 },			
			{id = 22, Weapon =0x781FE4A,  modelHash = "mp_m_avongoon",x = 374.54, y = 4832.68, z = -59.0, heading = 224.96 },	

			{id = 23,Weapon =0xAF113F99,  modelHash = "s_m_m_scientist_01",x = 364.61, y = 4820.89, z = -59.0, heading = 46.65,friendly=true },
			{id = 24, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon",x = 371.61, y = 4822.01, z = -59.0, heading = 336.27 },	
			{id = 25, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon",x = 368.02, y = 4822.25, z = -59.0, heading = 349.82 },	
			
			{id = 26, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon",x = 346.84, y = 4842.58, z = -59.0, heading = 223.98  },	
			{id = 27, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon", x = 346.26, y = 4843.89, z = -59.0, heading = 211.47 },			
			{id = 28,   modelHash = "u_m_y_juggernaut_01", isBoss=true, x = 347.48, y = 4843.89, z = -59.0, heading = 215.54 },
			{id = 29, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon", x = 338.92, y = 4848.97, z = -59.0, heading = 74.33 },	
			
			{id = 30, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon", x = 405.49, y = 4834.97, z = -62.6, heading = 156.21 },		
			{id = 31, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon",  x = 408.88, y = 4834.96, z = -62.6, heading = 115.94},	
			{id = 32, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon",x = 415.05, y = 4835.54, z = -62.6, heading = 108.61 },	
			{id = 33, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon", x = 396.73, y = 4835.59, z = -62.6, heading = 104.03 },	
			{id = 34, Weapon =0x0781FE4A,  modelHash = "mp_m_avongoon", x = 322.9, y = 4864.5, z = -62.6, heading = 261.25 },	

			{id = 35, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon",x = 331.33, y = 4863.57, z = -62.6, heading = 238.51 },
			{id = 36, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon",  x = 333.02, y = 4871.4, z = -62.6, heading = 192.26},	
			{id = 37, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon", x = 331.46, y = 4873.17, z = -62.6, heading = 154.6 },	
			{id = 38, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon", x = 329.21, y = 4874.96, z = -62.6, heading = 190.25 },			
			{id = 39, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon",x = 327.0, y = 4877.87, z = -62.6, heading = 186.4},	
			{id = 40, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon",x = 324.99, y = 4880.69, z = -62.6, heading = 190.53 },	


			{id = 41,  modelHash = "s_m_m_movalien_01", isBoss=true, x = 348.35, y = 4865.06, z = -59.4, heading = 105.84 },	
			{id = 42,  modelHash = "s_m_m_movalien_01", isBoss=true,  x = 344.42, y = 4867.3, z = -59.4, heading = 166.58 },	
			{id = 43,  modelHash = "s_m_m_movalien_01", isBoss=true,  x = 346.54, y = 4866.23, z = -59.4, heading = 133.09 },	
			{id = 44,  modelHash = "s_m_m_movalien_01", isBoss=true,  x = 350.83, y = 4872.34, z = -60.79, heading = 138.11},						
			
			{id = 45, Weapon =0xAF113F99,  modelHash = "mp_m_boatstaff_01", x = 355.87, y = 4872.92, z = -60.79, heading = 112.07,target=true },	
			{id = 46, Weapon =0xAF113F99,  modelHash = "ig_milton", x = 349.72, y = 4876.35, z = -60.79, heading = 160.28,target=true },
			{id = 47, modelHash = "u_m_m_jewelthief",Weapon =0xAF113F99,x = 355.24, y = 4874.98, z = -60.79, heading = 116.32,target=true },
			{id = 48, modelHash = "s_f_y_movprem_01",Weapon =0xAF113F99,x = 349.24, y = 4875.37, z = -60.79, heading = 148.94,target=true },
			
			{id = 49,  modelHash = "s_m_m_movalien_01", isBoss=true,x = 335.11, y = 4829.94, z = -59.4, heading = 347.17},	
			{id = 50,  modelHash = "s_m_m_movalien_01", isBoss=true,  x = 333.16, y = 4832.07, z = -59.4, heading = 295.3 },	
			{id = 51,  modelHash = "s_m_m_movalien_01", isBoss=true, x = 331.98, y = 4834.78, z = -59.4, heading = 273.46 },	
			{id = 52,  modelHash = "s_m_m_movalien_01", isBoss=true,   x = 323.03, y = 4823.94, z = -59.4, heading = 303.58},	

			{id = 53, Weapon =0xAF113F99,  modelHash = "s_m_m_fiboffice_01",x = 324.07, y = 4832.11, z = -59.4, heading = 296.21,target=true },	
			{id = 54, Weapon =0xAF113F99,  modelHash = "s_m_m_movprem_01",x = 322.78, y = 4828.95, z = -59.4, heading = 286.79,target=true },
			{id = 55, modelHash = "cs_gurk",Weapon =0xAF113F99,x = 325.77, y = 4821.66, z = -59.4, heading = 339.26,target=true },
			{id = 56, modelHash = "ig_bankman",Weapon =0xAF113F99,x = 333.02, y = 4823.15, z = -59.4, heading = 365.87,target=true },			
			
			
			{id = 57, Weapon =0xB1CA77B1,  modelHash = "mp_m_avongoon", x = 323.79, y = 4882.12, z = -62.6, heading = 197.45 },	

			{id = 58, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon",x = 418.73, y = 4814.2, z = -59.0, heading = 338.57 },	
			{id = 59, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon", x = 419.24, y = 4810.84, z = -59.0, heading = -14.14  },	
			
			{id = 60, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon",x = 366.57, y = 4824.48, z = -59.0, heading = 301.95 },
			{id = 61, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon", x = 373.24, y = 4820.35, z = -59.0, heading = -7.12 },

			
			{id = 62, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon", x = 370.44, y = 4824.93, z = -59.0, heading = 336.27  },	
			
			{id = 63, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon",x = 368.47, y = 4825.24, z = -59.0, heading = 332.08 },			
			
			{id = 64, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon",x = 373.08, y = 4825.9, z = -59.0, heading = 354.28},

			{id = 65, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon",x = 433.18, y = 4826.05, z = -59.0, heading = 220.35},	
			
			{id = 66, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon", x = 421.91, y = 4827.93, z = -59.0, heading = 258.5},	
			
			{id = 67, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon",x = 425.62, y = 4827.56, z = -59.0, heading = 153.41},	
			
			{id = 68, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon",x = 430.67, y = 4826.39, z = -59.0, heading = 253.05},	
			
			{id = 69, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon", x = 415.84, y = 4827.94, z = -59.0, heading = 244.86},	
			

			{id = 70, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon", x = 357.09, y = 4839.97, z = -59.0, heading = 317.95},	
			
			{id = 71, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon",x = 356.48, y = 4838.24, z = -58.54, heading = 223.22},	
			
			{id = 72, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon",x = 356.35, y = 4837.13, z = -58.54, heading = 175.03},	
			
			{id = 73, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon",x = 355.59, y = 4835.43, z = -59.0, heading = 249.23},	
						
			
			
			--{id = 68, Weapon =0xAF113F99,  modelHash = "mp_m_avongoon",x = 433.18, y = 4826.05, z = -59.0, heading = 220.35},	
						
			
			--{id = 3, Weapon =0x13532244,  modelHash = "s_m_y_ammucity_01", x = 1738.55, y = 3275.43, z = 41.14+100.0, heading = 181.86,outside=true}-- x = 1732.15, y = 3320.26, z = 41.22, heading = 283.82,},
		
			
    },
	
	

    Vehicles = {
		-- {id = 1, id2 = 1, Vehicle = "bmx", modelHash = "s_m_y_dealer_01", x = 2338.23, y = 2914.42, z = -84.8, heading = 174.26, Weapon=0x624FE830},
		--{id = 2, id2 = 2, Vehicle = "bmx", modelHash = "s_m_y_robber_01", x = 2338.5, y = 2930.59, z = -84.8, heading = 355.12,Weapon=0x624FE830},
      -- ID: id of NPC | name: Name of Blip | BlipID: Icone of Blip | VoiceName: NPC Talk When near it | Ambiance: Ambiance of Shop | Weapon: Hash of Weapon | modelHash: Model | X: Position x | Y: Position Y | Z: Position Z | heading: Where Npc look
   	  --**IMPORTANT: make sure the id of the ped starts from 1, each Peds id in above, increments by 1 and matches that entries index if it were in an array***
	  --vehicles are not consistent, so use ExtraPeds at your own discretion.
	  --Below takes a ped with id=1 from Peds above and will put it in seatid = -2   
	 -- {id = 1, id2 = 1, Vehicle = "annihilator", modelHash = "S_M_M_ChemSec_01",  x = -1166.42, y = 4641.5, z = 145.11, heading = 210.07,driving=true,pilot=true},
	 -- {id = 2, id2 = 2, Vehicle = "toro2", modelHash = "s_m_y_ammucity_01",  x = -3014.83, y = -43.5, z = 0.13, heading = 151.19, driving=true},
    }
  },
  
  
Mission42 = {
    
	StartMessage = "Go to the Pacific Standard Bank and capture~n~secret details to expose to San Andreas",
	FinishMessage = "~r~Enemies Incoming!~n~Meet up at the bank vault",
	MissionTitle = "Prelude",
	MissionMessage = "Go to the Pacific Standard Bank and capture secret details to expose to San Andreas",	
	Type = "ObjectiveRescue",	
	IndoorsMission = true,
	--MissionLengthMinutes = 60,
	--IndoorsMissionStrongSpawnCheck = true,
	ObjectiveRescueShortRangeBlip = true,
	TeleportToSafeHouseOnMissionStart = true,
	--SafeHouseCostVehicle = 2000,
	SafeHouseAircraftCount = 0,
	ObjectRescueReward = 5000,
	MissionSpaceTime = 3000,
	HostageRescue = true,
	NextMission="Mission32",
	NextMissionIfFailed="Mission42",
	--ProgressToNextMissionIfFail=true,
	MissionTriggerRadius=300.0,

	
	SMS_Message="We need someone to go to the Pacific Standard Bank and capture secret intel from the vault",
	SMS_Message2="We hope to expose this information to the public of San Andreas. Will you help us?",
	--SMS_Message3="This will help finish off thre threat. Can you help?",	
		
	--SMS_ContactPics={"CHAR_AGENT14",
	--},
	--SMS_ContactNames={"Agency Contact",
	--},
	SMS_NoFailedMessage=true,
	SMS_NoPassedMessage=true,
	SMS_FailedSubject="HAHA",
	SMS_FailedMessage="You should have stayed away, this is much bigger than you",
	SMS_PassedSubject="Thank you",
	SMS_PassedMessage="Los Santos is safe and sound from the attack",		
	
	SafeHouseVehicles = 
	{
		"insurgent3",
	},

    Blips = {
		{
		  Title = "Pacific Standard Public Deposit Bank",
		  Position =  {  x = 249.67, y = 219.57, z = 101.68 },
		  Icon     = 58,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 1,
		},

	},

    Marker = {
      Type     = 1,
      Position = { x = 2358.2, y = 2920.95, z = -85.78}, 
      Size     = {x = 6.0, y = 6.0, z = 2.0},
      Color    = {r = 100, g = 100, b = 204},
      DrawDistance = 100.0,
    },
	
		BlipS = { --safehouse blip 
		  Title = "Mission Safehouse",
		  Position = { x = -1694.94, y = -3152.18, z = 23.32}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 417,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 2,
		  Alpha	 =80, 
		},	
		 MarkerS = { --safehouse marker
		  Type     = 1,
		  Position = { x = -1694.94, y = -3152.18, z = 23.32},  --{  x = 1944.96, y = 3150.6, z = 46.77}, 
		  Size     = {x = 6.0, y = 6.0, z = 2.0},
		  Color    = {r = 117, g = 218, b = 255},
		  DrawDistance = 200.0,
		},
		BlipSL = { --safehouse Vehicle blip 
		  Title = "Mission Vehicle Safehouse",
		  Position = { x = -1469.37, y = -2967.27, z = 13.3}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 421,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},
	Events = {
	
		--[[	{ 
		  Type="Vehicle",
		  Position = { x = -103.41, y = -438.73, z = 36.02, heading = 167.51 }, 
		  Size     = {radius=10000},
		  SpawnHeight =200.0,
		  FacePlayer = true,
		  --NumberPeds=10,
		  isBoss=false,
		  Target=false,
		  Vehicle="trailersmall",
		  Weapon=0xBD248B55,
		  SquadSpawnRadius=1.0,
		  Message="~h~~r~Warning: Psychotronic countermeasures deployed. Civilians may be hostile.",
		  --CheckGroundZ=true,
		},	]]--
	
	   { --outside bank
		  Type="Vehicle",
		  Position = { x = 235.06, y = 186.02, z = 105.3}, 
		  Size     = {radius=300.0},
		 -- SpawnHeight = 200.0,
		  FacePlayer = true,
		--  NumberPeds=10,
		  isBoss=false,
		  Target=false,
		  Vehicle="khanjali",
		  modelHash="s_m_y_ammucity_01",
		  SquadSpawnRadius=10.0,
		  --SpawnAt = { x = 866.34, y = -99.86, z = 79.44},
		  CheckGroundZ=true,
		},		
		
	},	

	
	Props = {
		{ id=1,  Name = "bkr_prop_biker_case_shut", isObjective=true,Position = { x = 264.08, y = 213.74, z = 102.53, heading = 248.63}},
		
	
    },
	
	

	
	Pickups = {
	},
	MissionPickups = {
		
	},	
		
	

    Peds = {
			{id = 1, Weapon = 0xB62D1F67, modelHash = "u_m_y_juggernaut_01",isBoss=true,x = 253.63, y = 228.58, z = 101.68, heading = 239.84},	
			{id = 2,  modelHash = "mp_m_bogdangoon",isBoss=true,x = 260.21, y = 224.26, z = 101.68, heading = 262.21},
			{id = 3, Weapon = 0x0781FE4A,  modelHash = "s_m_y_ammucity_01",x = 263.0, y = 220.91, z = 101.68, heading = 335.68},
			{id = 4, Weapon = 0xAF113F99,  modelHash = "s_m_y_ammucity_01",x = 265.33, y = 219.18, z = 110.28, heading = 67.04},
			{id = 5, Weapon = 0xAF113F99,  modelHash = "s_m_y_ammucity_01",x = 245.52, y = 211.79, z = 110.28, heading = 341.61},
			{id = 6, Weapon = 0xAF113F99,  modelHash = "s_m_y_ammucity_01", x = 238.9, y = 228.99, z = 110.28, heading = 32.23},
			{id = 7, modelHash = "ig_andreas",x = 253.76, y = 225.01, z = 106.29, heading = 162.54,friendly=true},
			{id = 8, modelHash = "a_f_y_business_01",x = 242.73, y = 228.11, z = 106.29, heading = 247.26,friendly=true},
			{id = 9, modelHash = "ig_amandatownley",x = 246.7, y = 221.4, z = 106.29, heading = 338.23,friendly=true},
			{id = 10, modelHash = "ig_barry", x = 253.2, y = 213.71, z = 106.29, heading = 252.86,friendly=true},			
		--[[
			{id = 1, Weapon = 0xAF113F99,  modelHash = "s_m_y_ammucity_01",x = 265.24, y = 221.85, z = 101.68, heading = 53.71},
			{id = 2, Weapon = 0x12E82D3D,  modelHash = "U_M_Y_Tattoo_01", x = 263.31, y = 220.13, z = 101.68, heading = 6.69,},	
			{id = 3, Weapon = 0xAF113F99,  modelHash = "s_m_y_xmech_02_mp",x = 267.03, y = 218.72, z = 104.88, heading = 335.04},
			{id = 4, Weapon = 0x12E82D3D,  modelHash = "G_M_M_ChiCold_01",  x = 262.65, y = 220.6, z = 106.28, heading = 238.58},	

			{id = 5, Weapon = 0xAF113F99,  modelHash = "s_m_y_dealer_01",x = 260.06, y = 226.34, z = 107.08, heading = 148.25},
			{id = 6, Weapon = 0x12E82D3D,  modelHash = "u_f_y_bikerchic",  x = 267.8, y = 223.25, z = 110.28, heading = 71.64},	
			{id = 7, Weapon = 0xAF113F99,  modelHash = "s_m_y_xmech_02",x = 262.2, y = 217.28, z = 110.28, heading = 256.97},
			{id = 8, Weapon = 0x12E82D3D,  modelHash = "g_m_y_lost_01", x = 264.01, y = 213.75, z = 110.29, heading = 67.73 },		
			
			{id = 9, Weapon = 0xAF113F99,  modelHash = "g_m_y_lost_02", x = 262.63, y = 208.02, z = 110.29, heading = 50.69},
			{id = 10, Weapon = 0x12E82D3D,  modelHash = "g_m_y_lost_03",x = 258.17, y = 205.89, z = 110.28, heading = 49.79},	
			{id = 11, Weapon = 0xAF113F99,  modelHash = "g_f_y_lost_01",x = 251.08, y = 209.62, z = 110.28, heading = -32.81},
			{id = 12, Weapon = 0x12E82D3D,  modelHash = "s_m_y_robber_01",   x = 244.8, y = 211.82, z = 110.28, heading = 309.24},		

			{id = 13, Weapon = 0xAF113F99,  modelHash = "mp_g_m_pros_01",x = 238.29, y = 214.31, z = 110.28, heading = 294.41},
			{id = 14, Weapon = 0x12E82D3D,  modelHash = "U_M_Y_Tattoo_01", x = 235.09, y = 221.13, z = 110.28, heading = 274.7},	
			{id = 15, Weapon = 0xAF113F99,  modelHash = "s_m_y_xmech_02_mp", x = 236.69, y = 229.95, z = 110.28, heading = 238.13},
			{id = 16, Weapon = 0x12E82D3D,  modelHash = "G_M_M_ChiCold_01", x = 239.53, y = 229.62, z = 106.28, heading = 120.8},		
			
	
			{id = 17, Weapon = 0x0781FE4A,  modelHash = "s_m_y_ammucity_01", x = 235.42, y = 222.77, z = 106.29, heading = 251.52},
			{id = 18, Weapon = 0x12E82D3D, modelHash = "mp_m_exarmy_01",isBoss=true,x = 236.04, y = 217.16, z = 106.29, heading = 261.72},	
			{id = 19, Weapon = 0xB1CA77B1,  modelHash = "s_m_y_xmech_02_mp", x = 244.39, y = 212.2, z = 106.29, heading = 307.19},
			{id = 10, Weapon = 0x12E82D3D,  modelHash = "G_M_M_ChiCold_01",  x = 250.55, y = 208.95, z = 106.29, heading = -43.33},

	
			{id = 21, Weapon = 0xAF113F99,  modelHash = "s_m_y_ammucity_01",x = 262.24, y = 204.89, z = 106.28, heading = 52.92},
			{id = 22, Weapon = 0xB1CA77B1,  modelHash = "U_M_Y_Tattoo_01",x = 257.73, y = 206.59, z = 106.28, heading = 252.17 },	
			{id = 23, Weapon = 0xAF113F99,  modelHash = "mp_m_weapexp_01",isBoss=true,x = 259.92, y = 209.64, z = 106.28, heading = 339.59},
			{id = 24, Weapon = 0x0781FE4A,  modelHash = "G_M_M_ChiCold_01", x = 262.86, y = 216.2, z = 106.28, heading = 126.82},					

		--]]	
			
		
		
			
    },
	
	

    Vehicles = {
	
		-- {id = 1, id2 = 1, Vehicle = "bmx", modelHash = "s_m_y_dealer_01", x = 2338.23, y = 2914.42, z = -84.8, heading = 174.26, Weapon=0x624FE830},
		--{id = 2, id2 = 2, Vehicle = "bmx", modelHash = "s_m_y_robber_01", x = 2338.5, y = 2930.59, z = -84.8, heading = 355.12,Weapon=0x624FE830},
      -- ID: id of NPC | name: Name of Blip | BlipID: Icone of Blip | VoiceName: NPC Talk When near it | Ambiance: Ambiance of Shop | Weapon: Hash of Weapon | modelHash: Model | X: Position x | Y: Position Y | Z: Position Z | heading: Where Npc look
   	  --**IMPORTANT: make sure the id of the ped starts from 1, each Peds id in above, increments by 1 and matches that entries index if it were in an array***
	  --vehicles are not consistent, so use ExtraPeds at your own discretion.
	  --Below takes a ped with id=1 from Peds above and will put it in seatid = -2   
	 -- {id = 1, id2 = 1, Vehicle = "annihilator", modelHash = "S_M_M_ChemSec_01",  x = -1166.42, y = 4641.5, z = 145.11, heading = 210.07,driving=true,pilot=true},
	 -- {id = 2, id2 = 2, Vehicle = "toro2", modelHash = "s_m_y_ammucity_01",  x = -3014.83, y = -43.5, z = 0.13, heading = 151.19, driving=true},
    }
  },     
 

--[[
 Mission25 = {
    
 	StartMessage = "Protect the Witness. Escort them to the FIB Office",
	FinishMessage = "Mission Completed!",
	MissionTitle = "Protect the Witness. Escort them to the FIB Office",
	MissionMessage = "New Mission",	
	
	--Obj/Ass values are the messages used depending on which random Type is selected Objective or Assassinate
	--The real messages (values above), will be set to the below, based on which Type
	StartMessageObj = "Capture the objective!",
	FinishMessageObj = "Mission Completed!",
	MissionTitleObj = "Takeover",
	MissionMessageObj = "Capture the objective!",	
	
	StartMessageAss = "Rescue the target!",
	FinishMessageAss = "Mission Completed!",
	MissionTitleAss = "Extraction",
	MissionMessageAss = "Rescue the target!",		
	Type = "Assassinate",	
	--IsRandom = true,
	--RandomMissionTypes ={"Assassinate"},
	IsDefend = true,
	IsDefendTarget = true,
	IsDefendTargetChase = true,
	IsDefendTargetRescue = false,
	--IsDefendTargetGotoBlipTargetOnly=true,
	IsDefendTargetGotoEntity=true,
	SafeHouseTimeTillNextUse=10000, --10 seconds
	--SafeHouseTimeTillNextUse=10000, --10 seconds
	SafeHousePedDoctors = {},
	SafeHousePedLeaders = {},
	SafeHouseProps = {},
	SafeHouseGiveImmediately = true,
	TeleportToSafeHouseOnMissionStartDelay=2000,	
	--IsDefendTargetEnemySetBlockingOfNonTemporaryEvents=true,
	--IsDefendTargetOnlyPlayersDamagePeds=false,

	
	--IsDefendTargetDrivetoBlip=true,
	--TeleportToSafeHouseOnMissionStart = false,
	--RandomMissionSpawnRadius = 100.0, --keep a float for enemy ped wandering to work
	--RandomMissionMaxPedSpawns = 10,
	--RandomMissionMinPedSpawns = 10,
	--RandomMissionMaxVehicleSpawns = 0,
	--RandomMissionMinVehicleSpawns = 0,
	--RandomMissionChanceToSpawnVehiclePerTry = 100,
	--RandomMissionAircraftChance = 0,
	--RandomMissionWeapons = {0xDD5DF8D9,0x99B507EA,0xCD274149,0x1B06D571},
	--IsRandomSpawnAnywhere = true,
	--what x and y coordinate range should these mission spawn in?
	--RandomLocation = true, --for completely random location..
	
	IsDefendTargetEntity = { --**Uses Blip2 location to spawn... except for heading**
		--Only define 1, Add 'id2' w. 'Vehicle' to add ped to vehicle.
		{id = 1,  Weapon = 0x2BE6766B,  modelHash = "u_f_y_princess", heading = -27.2},
		--{id = 1, id2 = 1, Weapon= 0x2BE6766B, Vehicle = "windsor", modelHash = "ig_bankman",heading = 283.22,}, --movetocoord={  x = 1564.8, y = 3221.98, z = 40.4}
	
	},	
	
   Blip2 = {
      Title = "Mission Start",
      Position = { x = -307.29, y = -711.71, z = 28.59}, --{x = 1453.72, y = -2282.69, z = 67.47},  x = 1872.28, y = 3219.21, z = 45.4
      Icon     = 58,
      Display  = 4,
      Size     = 1.2,
      Color    = 1,
	  Alpha	 =80, --Used for AddBlipForRadius with IsDefend Missions
    },
	Blip = {
      Title = "FIB Office",
      Position = {x = 102.67, y = -744.16, z = 45.75}, --{ x = 1453.72, y = -2282.69, z = 67.47}, --{ x = 1944.96, y = 3150.6, z = 46.77},
      Icon     = 38,
      Display  = 4,
      Size     = 1.2,
      Color    = 1,
	  Alpha	 =80, --Used for AddBlipForRadius with IsDefend Missions
    },

    Marker = {
      Type     = 1,
      Position = { x = -10000, y = 0, z = 0}, 
      Size     = {x = 6.0, y = 6.0, z = 2.0},
      Color    = {r = 100, g = 100, b = 204},
      DrawDistance = 100.0,
    },
	BlipS = { --safehouse blip
      Title = "Mission Safehouse",
      Position = {  x = -307.29, y = -711.71, z = 28.59}, --{ x = 1944.96, y = 3150.6, z = 46.77},
      Icon     = 417,
      Display  = 4,
      Size     = 1.2,
      Color    = 2,
	  Alpha	 =80, --Used for AddBlipForRadius with IsDefend Missions
    },	
	 MarkerS = { --safehouse marker
      Type     = 1,
      Position = { x = -307.29, y = -711.71, z = 27.59},  --{  x = 1944.96, y = 3150.6, z = 46.77}, 
      Size     = {x = 2.0, y = 2.0, z = 2.0},
      Color    = {r = 117, g = 218, b = 255},
      DrawDistance = 200.0,
    },
	BlipSL = { --safehouse Vehicle blip 
		  Title = "Mission Vehicle Safehouse",
		  Position = { x = -1228.1, y = -2267.77, z = 13.94}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 421,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},
	BlipSB = { --safehouse boat blip 
		  Title = "Mission Boat Safehouse",
		  Position = {x = 413.98, y = -3411.47, z = 0.23}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		 Icon     = 404,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},
	
	Props = { 
		{ id=1,  Name = "prop_amb_phone",Position = {x = -287.8, y = -678.31, z = 33.29, heading = 245.84}}
	
    },
	
	Peds = {
		--**need a stub entry set for the random ped hostage for HostageRescue=true**
     {id = 1,  Weapon =0xAF113F99,  modelHash = "g_m_y_lost_01", x = 102.67, y = -744.16, z = 45.75, heading = 235.57,armor=500,movespeed=1.0,target=true,},
     },
	 
	Vehicles = { 
		
	
    },	 
	

	Pickups = {
		
	},
	MissionPickups = {
		
		
	},
	

},   
  ]]--
-- uncomment if you have red dead desert map installed:  https://github.com/KSA01/Red-Dead-Desert 
--[[
Mission25 = {
    
 	StartMessage = "Recapture the prison colony Westworld from the convict uprising!",
	FinishMessage = "Mission Completed!",
	MissionTitle = "Westworld",
	MissionMessage = "Recapture the prison colony Westworld from the convict uprising",	
	
	--Obj/Ass values are the messages used depending on which random Type is selected Objective or Assassinate
	--The real messages (values above), will be set to the below, based on which Type
	StartMessageObj = "Recapture the prison colony Westworld from the convict uprising!",
	FinishMessageObj = "Mission Completed!",
	MissionTitleObj = "Westworld",
	MissionMessageObj = "Recapture the prison colony Westworld from the convict uprising",	
	
	StartMessageAss = "Recapture the prison colony Westworld from the convict uprising!",
	FinishMessageAss = "Mission Completed!",
	MissionTitleAss = "Westworld",
	MissionMessageAss = "Recapture the prison colony Westworld from the convict uprising",
	--RandomMissionWeapons = {0x63AB0442},
	
	Type = "Objective",	
	IsRandom = true,
	RandomMissionTypes ={"Objective"},
	--IsDefend = true,
	--IsDefendTarget = true,
	--IsDefendTargetChase = true,
	--IsDefendTargetGotoBlip=true,
	IsRandomSpawnAnywhere = true,
	UseSafeHouseLocations = false,
	RandomMissionDoLandBattle = true,
	RandomMissionSpawnRadius = 150.0, --keep a float for enemy ped wandering to work
	RandomMissionMaxPedSpawns = 75,
	RandomMissionMinPedSpawns = 50,
	RandomMissionMaxVehicleSpawns = 6,
	RandomMissionMinVehicleSpawns = 3,
	RandomMissionChanceToSpawnVehiclePerTry = 100,
	RandomMissionAircraftChance = 25,
	MissionLengthMinutes = 60,
	SafeHouseVehiclesMaxClaim = 3,
	SafeHouseVehicleCount = 9,
	SafeHouseAircraftCount = 3,
	SafeHouseBoatCount = 3,
	RandomMissionPeds = {"s_m_y_prismuscl_01","u_m_y_prisoner_01","s_m_y_prisoner_01"},
	--what x and y coordinate range should these mission spawn in?
	IsRandomSpawnAnywhereCoordRange = {xrange={4647,7756},yrange={-1181,1950}},
	--RandomLocation = true, --for completely random location.. 
	
	Blip = {
      Title = "Objective",
      Position = { x = -10000, y = 0, z =  0},
      Icon     = 58,
      Display  = 4,
      Size     = 1.2,
      Color    = 1,
    },
	

    Marker = {
      Type     = 1,
      Position = { x = -10000, y = 0, z = 0}, 
      Size     = {x = 6.0, y = 6.0, z = 2.0},
      Color    = {r = 100, g = 100, b = 204},
      DrawDistance = 100.0,
    },
	BlipS = { --safehouse blip
      Title = "Mission Safehouse",
      Position = {x = 6605.16, y = -787.53, z = 23.78}, --{ x = 1944.96, y = 3150.6, z = 46.77},
      Icon     = 417,
      Display  = 4,
      Size     = 1.2,
      Color    = 2,
	  Alpha	 =80, --Used for AddBlipForRadius with IsDefend Missions
    },	
	 MarkerS = { --safehouse marker
      Type     = 1,
      Position = { x = 6605.16, y = -787.53, z = 22.78},  --{  x = 1944.96, y = 3150.6, z = 46.77}, 
      Size     = {x = 6.0, y = 6.0, z = 2.0},
      Color    = {r = 117, g = 218, b = 255},
      DrawDistance = 200.0,
    },
	BlipSL = { --safehouse Vehicle blip 
		  Title = "Mission Vehicle Safehouse",
		  Position = {x = 6837.65, y = -942.43, z = 31.4}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		  Icon     = 421,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},
	BlipSB = { --safehouse boat blip 
		  Title = "Mission Boat Safehouse",
		  Position = {x = 6992.71, y = -1301.72, z = 0.28}, --{ x = 1944.96, y = 3150.6, z = 46.77},
		 Icon     = 404,
		  Display  = 4,
		  Size     = 1.2,
		  Color    = 3,
		  Alpha	 =80, 
		},
	
	
	Props = { 
		--**need a stub entry set for the random prop**
		{ id=1, Name="",Position = { x = 0, y = 0, z = 0, heading = 0 }},
	
    },
	
	Peds = {
		--**need a stub entry set for the random ped hostage for HostageRescue=true**
      {id = 1, Position = { x = 0, y = 0, z = 0, heading = 0 }},
     },
	

	Pickups = {
		
	},
	MissionPickups = {
		
		
	}

  

  },
  ]]--

}
