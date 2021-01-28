------------------------------------------------------------------------------------------------
---------------------------------- DON'T EDIT THESE LINES --------------------------------------
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
---------------------------------- DON'T EDIT THESE LINES --------------------------------------
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
---------------------------------- DON'T EDIT THESE LINES --------------------------------------
------------------------------------------------------------------------------------------------

--show 'WASTED' message on player death?
local SHOWWASTEDMESSAGE = true

local MissionName = "N/A"
local Active      = 0
local PedsSpawned = 0
local securing    = false
local securingRescue   = 0
local securingRescueType = -1
local buying    = false
local playerSecured = false
local playerSafeHouse = -1000000 --records game time
local playerUpgraded = false --safehouse crackdown mode
local SafeHouseBlip
local SafeHouseBlipOn = true
local playerMissionMoney = 0
local MissionTimeOut = false
local MilliSecondsLeft = -1
local MissionStartTime = 0
local MissionEndTime = 0
local MissionNoTimeout = false


MissionIsDefendTargetGoalDestIndex = nil
GlobalGotoGoalX = nil
GlobalGotoGoalY = nil
GlobalGotoGoalZ = nil
GlobalTargetPed=nil
PlayingAnimL=false
PlayingAnimD=false
PedLeaderModel=nil
PedDoctorModel=nil	
GlobalBackup=nil
GlobalBackupIndex=0

--[[
local entitys = {} --entitys table
Citizen.CreateThread(function()			 

while true do
Wait(0)		

local player = GetPlayerPed(-1)
local pos = GetEntityCoords(player,1)
local ground 

if #entitys < 30 then--repeat until 15 entitys are spawned

RequestModel("STRATUM")
while not HasModelLoaded("STRATUM") or not HasCollisionForModelLoaded("STRATUM") do --for each types of entity
Wait(1)
end			    

--RequestModel("A_F_M_BODYBUILD_01")
--while not HasModelLoaded("A_F_M_BODYBUILD_01") or not HasCollisionForModelLoaded("A_F_M_BODYBUILD_01") do
--Wait(1)
--end	

--RequestModel("prop_barbell_100kg")
--while not HasModelLoaded("prop_drug_package") or not HasCollisionForModelLoaded("prop_barbell_100kg") do
--Wait(1)
--end					

posX = pos.x+math.random(-5000,5000)--radius example
posY = pos.y+math.random(-5000,5000)--radius example
Z = pos.z+999.0

ground,posZ = GetGroundZFor_3dCoord(posX+.0,posY+.0,Z,1)--set Z pos as on ground

--if(ground) then--if ground find
--print("found ground")	  
entity = CreateVehicle("STRATUM",posX,posY,posZ,0.0, true, true)--vehicle example
--entity = CreatePed(4,"A_F_M_BODYBUILD_01",posX,posY,posZ,0.0, true, true)--peds example
--entity = CreateObject(GetHashKey("prop_barbell_100kg"),posX,posY,posZ,true, false, true)--object example
SetEntityAsMissionEntity(entity, true, true)--for it to don't be delete if too far from players

if posZ  == 0.0 then 
DecorSetInt(entity,"mrpcheckspawn",0)
print("entity at 0.0")
FreezeEntityPosition(entity,true)
else
print("entity at "..posZ)
DecorSetInt(entity,"mrpcheckspawn",1)
TriggerServerEvent("sv:rescuehostage",DecorGetInt(entity,"mrpcheckspawn"),"mrpcheckspawn")
end

table.insert(entitys,entity)--insert entity in tables

local blip = AddBlipForEntity(entity)--add blip for entity
SetBlipSprite(blip,66)
SetBlipColour(blip,46)
BeginTextCommandSetBlipName("STRING")
AddTextComponentString("Spawned entity")
EndTextCommandSetBlipName(blip)


--end	
--else 
--print("posZ"..posZ)	
--print("not found ground")	              			   
--end
end	

 --this part avoid entity to spawn in water
 for i, entity in pairs(entitys) do
     if IsEntityInWater(entity) then--detect if entity is in water.If in water the entity is deleted and the loop restart until the 15 entitys are well on ground
	    print("entity in water...deleted")
		local model = GetEntityModel(entity)
	    SetEntityAsNoLongerNeeded(entity)
		SetModelAsNoLongerNeeded(model)
	    DeleteEntity(entity)
	    table.remove(entitys,i)	
	 end
	 local checkpoint = GetEntityCoords(entity)
	
	 if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, checkpoint.x, checkpoint.y, 0, false) < 300 and DecorGetInt(entity,"mrpcheckspawn") == 0 then
		 
		 --if checkpoint.z == 0.0 then
		 print(checkpoint.z)
		-- Z = 1999.0
		 --ground,posZ = GetGroundZFor_3dCoord(checkpoint.x, checkpoint.y,Z,1)
		 --print(posZ)
		
			Z = 1999.0
			ground,posZ = GetGroundZFor_3dCoord(checkpoint.x, checkpoint.y,Z,1)
			if ground then
				FreezeEntityPosition(entity,false)
				SetEntityCoords(entity,checkpoint.x, checkpoint.y, posZ)
				print(i.." grounded:"..posZ)
				DecorSetInt(entity,"mrpcheckspawn",1)
			else
				print(i.." grounded:"..tostring(ground))
			end
			
		--end
	 end
 end
 ------------------------------------------
end
end)
]]--


local MissionDoneSMS=false

local MissionSpawnedSafeHouseProps = false
--used with Config.Missions[input].MissionTriggerRadius:
local MissionTriggered = false
--used with Config.Missions[input].MissionTriggerRadius:
local BLHOSTFLAG = false
local blRemoveRescuedHostage = false --used due to a bug where they can be rescued more than once atm

local GlobalKillTargetPed = false

local isHostageRescueCount = 0
local isObjectiveRescueCount = 0

local DoingMissionTeleport = false

local showNativeMoneyGUI = false 
local _,currentplayerNmoney = StatGetInt('MP0_WALLET_BALANCE', -1)
local blKeepPropsOnGround = true --**turn to false if you are experiencing desync**

--NOT NEEDED ANYMORE:
local checkspawns = false --used to make sure ped/veh spawns OK in IsRandom missions

--experimental, used to make sure that NPC blips show up for players,
--when the connect and starting new missions:
local blForceCheckForBlips = true
local blForceCheckForBlipsTimeout = 30000 --30 seconds default

--used to keep track of certain mission stats after ped death
local mrpvehsafehousemaxG = 0
local mrpplayermissioncountG = 0
local mrpplayermoneyG = 0
local mrprescuecountG = 0
local mrpcheckpointG = 0
local mrpcheckpointsclaimedG = 0
local playerwasinmissionG = 0

--Used for Type="HostageRescue" when IsRandom=true
local IsRandomMissionHostageCount = 0
local IsRandomMissionAllHostagesRescued = false

local IsRandomDoEvent = false

local IsRandomDoEventRadius = 1000.0

--1 Paradrop, 2 Squad, 3 Aircraft, 4 Vehicle 
local IsRandomDoEventType = 0

--used to keep track of whether the mission is IsRandom=true only, 
--with RandomMissionPositions location where force=true which means NPCs (probably) spawning underground
--This is used by rogue spawn checking code. force means to not ray trace check the groundz when they spawn
local IsRandomMissionForceSpawning = false

--used to draw markers for enemy targets, ObjectiveRescue props, and Hostages
local RescueMarkers = {}

--for GTAO sounds
SetAudioFlag("LoadMPData", true)

--Disable Flight music?
SetAudioFlag("DisableFlightMusic", true)

Blips = {}

local MissionDropBlip
local MissionDropMarker
local MissionDropHeading
local MissionDropBlipCoords={x=-50000,y=-50000,z=-50000}
local MissionDropDid=false

DecorRegister("mrppedid",1)
DecorRegister("mrpvpedid",1)
DecorRegister("mrpvpeddriverid",1)
DecorRegister("mrpvehdid",1)
DecorRegister("mrppickupid",1)
DecorRegister("mrpmpickupid",1)
DecorRegister("mrppropid",1)
DecorRegister("mrppropobj",1) --used in IsRandom Objective Mission
DecorRegister("mrpproprescue",1) --"ObjectiveRescue" type missions
DecorRegister("mrppedtarget",1)
DecorRegister("mrppedfriend",1)
DecorRegister("mrppedboss",1)
DecorRegister("mrppedmonster",1)
DecorRegister("mrppedhostilezone",1)
DecorRegister("mrpcheckspawn",1) --used to make sure ped/veh spawns OK in IsRandom missions
DecorRegister("mrpcheckspawnset",1) --used for debug
DecorRegister("mrppedconqueror",1) --used for .conqueror and .attacker npcs
DecorRegister("mrprescuecount",1) --used on player for hostage rescue count
DecorRegister("mrpobjrescuecount",1) --used on player for object(ive) rescue count
DecorRegister("mrppedead",1) --used to track dead NPCs (may not be needed)
DecorRegister("mrppedsafehouse",1) --safehouse npcs
DecorRegister("mrpvehsafehouse",1)  --safehouse vehicle
DecorRegister("mrpvehsafehouseowner",1) --safehouse vehicle owner
DecorRegister("mrpvehsafehousemax",1) --used for max safehouse vehicles a player can claim
DecorRegister("mrppeddefendtarget",1) --used for isdefendtarget
DecorRegister("mrprescuetarget",1) --used for isdefendtarget on player who rescued them when IsDefend = true & IsDefendTarget = true & IsDefendTargetRescue = true
DecorRegister("mrpplayermoney",1) --used to keep track of the total money earned for the session of play... until /stop or resource restarts
DecorRegister("mrpplayermissioncount",1) --used to keep track of the money earned per mission
DecorRegister("mrpsafehousepropid",1) 
DecorRegister("mrpsafehousecrateid",1) 
DecorRegister("mrppedkilledbyplayervehicle",1) --need to keep track of peds killed by player vehicles, which source the killer as the vehicle, not the player
DecorRegister("mrppedskydiver",1) --used to single out parachuting enemies
DecorRegister("mrppedskydiverexplode",1) --used to single out enemies who left aircraft but never opened chute
DecorRegister("mrppedskydivertarget",1) --used to single out which client the parachuting ped targets

DecorRegister("mrpvehdidGround",1) --used for zgrounding peds and vehicles in random missions

DecorRegister("mrpoptin",1)
DecorRegister("mrpoptout",1)
DecorRegister("mrpcheckpoint",1) --used for checkpoint races
DecorRegister("mrpcheckpointsclaimed",1) --used for checkpoint races

--DecorRegister("mrpoptin_teleportcheck",1) --bit of a hack

--DecorRegisterLock()

---enumerate functions

--[[Usage:
for ped in EnumeratePeds() do
  <do something with 'ped'>
end
]]

local entityEnumerator = {
  __gc = function(enum)
    if enum.destructor and enum.handle then
      enum.destructor(enum.handle)
    end
    enum.destructor = nil
    enum.handle = nil
  end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
  return coroutine.wrap(function()
    local iter, id = initFunc()
    if not id or id == 0 then
      disposeFunc(iter)
      return
    end
    
    local enum = {handle = iter, destructor = disposeFunc}
    setmetatable(enum, entityEnumerator)
    
    local next = true
    repeat
      coroutine.yield(id)
      next, id = moveFunc(iter)
    until not next
    
    enum.destructor, enum.handle = nil, nil
    disposeFunc(iter)
  end)
end

function EnumerateObjects()
  return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

function EnumeratePeds()
  return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function EnumerateVehicles()
  return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function EnumeratePickups()
  return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
end


---
---ESX SUPPORT
---
local UseESX=false
if UseESX then
	ESX = nil
	Citizen.CreateThread(function()
		while ESX == nil do
		TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
		Citizen.Wait(1)
		end
	end)
		RegisterNetEvent("esx:playerLoaded")
		AddEventHandler("esx:playerLoaded", function(xPlayer)
		PlayerData = xPlayer
	end)

end




---
---
---

----------------------------
--------- Commands ---------
----------------------------

--looks for setting within a mission, else looks at global setting
function getMissionConfigProperty(MissionName, PropName) 
	--print('MissionName'..MissionName)
	--print('PropName'..PropName)
	for i, v in pairs(Config.Missions[MissionName]) do
        if PropName == i then
			return v
			
        end
    end

	for i, v in pairs(Config) do
		if PropName == i then
			return v
			
        end
    end
	
			
end

--For Random Missions
--dont want the safe house too close either
function findBestSafeHouseLocation(randomlocation)

	local closestindex = 0
	local closest = 20000.0
	local current = 20000.0
	--print("MISSIONNAME:"..MissionName)
	local missionspawnRadius = getMissionConfigProperty(MissionName, "RandomMissionSpawnRadius")
    for i, v in ipairs(Config.SafeHouseLocations) do
		local coords = Config.SafeHouseLocations[i].BlipS.Position
		--spawn radius + 250m
		
		current  = 	GetDistanceBetweenCoords(coords.x,coords.y,coords.z, randomlocation.x,randomlocation.y,randomlocation.z, true)
		if current > missionspawnRadius + 500  and current < closest then
			--print("current:"..current)
			closest = current
			closestindex = i

		end 
	end
	if closestindex == 0 then closestindex = math.random(1,#Config.SafeHouseLocations) end
	--print("closestindex:"..closestindex)
	return closestindex

end


RegisterNetEvent("mt:getmillisecondsleft")
AddEventHandler("mt:getmillisecondsleft", function()
local timeLeft = MilliSecondsLeft
--print("mt:getmillisecondsleft called:"..MilliSecondsLeft)
TriggerEvent('mrpStreetRaces:getmillisecondsleft', timeLeft) --how to get source?

end)



RegisterCommand("mission", function(source, args, rawCommand)
    input = args[1]

	
        for i, v in pairs(Config.Missions) do
            if input == i then
				local rMissionLocationIndex = 0
				local rMissionDestinationIndex = 0
				local rSafeHouseLocationIndex = 0
				local rMissionType = getMissionConfigProperty(input, "RandomMissionTypes")[math.random(1, #getMissionConfigProperty(input, "RandomMissionTypes"))]	
				local rIsRandomSpawnAnywhereInfo = {x=0.0,y=0.0,z=0.0}
			
                if Active == 1 then
                    TriggerEvent('chatMessage', "^1[MISSIONS]: ^2There is a mission already in progress.")
                else
					Active = 1
					MissionName = input
					MilliSecondsLeft = getMissionLength(MissionName)*60*1000
					MissionNoTimeout = getMissionConfigProperty(MissionName, "MissionNoTimeout")
					MissionStartTime = GetGameTimer() 
					MissionEndTime = MissionStartTime + MilliSecondsLeft	
					--print(getMissionConfigProperty(input, "RandomMissionPositions")[1].z)
					time = 10000
					if(Config.Missions[MissionName].IsRandom) then 
					
						rMissionLocationIndex = math.random(1, #getMissionConfigProperty(MissionName, "RandomMissionPositions"))
						
						if(getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].force) then
							
							rMissionType = "Objective" --NPCs have a chance of spawning hidden in buildings with forced = true, so Assassinate may hang
							
							
						end	

						if Config.Missions[input].IsDefendTarget and Config.Missions[input].IsVehicleDefendTargetGotoGoal
						and getMissionConfigProperty(input,"IsRandom") then 
							local randomlocation = Config.Missions[input].RandomMissionPositions[1].Blip2.Position
							rMissionDestinationIndex = setBestRandomDestination(randomlocation,input,MissionIsDefendTargetGoalDestIndex)
						end
						
						
						--this overrides regular IsRandom missions that use defined random positions:
						if(getMissionConfigProperty(MissionName, "IsRandomSpawnAnywhere")) then 
							if (getMissionConfigProperty(MissionName, "RandomMissionDoLandBattle")) then
								rIsRandomSpawnAnywhereInfo = doLandBattle(MissionName)
							else
								rIsRandomSpawnAnywhereInfo = getRandomAnywhereLocation(MissionName)
							end
							--print('rIsRandomSpawnAnywhereInfo[1].x: '..rIsRandomSpawnAnywhereInfo[1].x)
							if rIsRandomSpawnAnywhereInfo[2] then 
								--if a water/boat mission, make it only Assassinate
								rMissionType = "Assassinate"
							end
							
							if Config.Missions[MissionName].Type=="Checkpoint" then 
								if getMissionConfigProperty(MissionName, "CheckpointsDoLand") and 
								getMissionConfigProperty(MissionName, "SpawnCheckpointsOnRoadsOnly") then
								
									rIsRandomSpawnAnywhereInfo = doLandBattle(MissionName)
									local retval1, coords1 = GetClosestVehicleNode(rIsRandomSpawnAnywhereInfo[1].x,rIsRandomSpawnAnywhereInfo[1].y, rIsRandomSpawnAnywhereInfo[1].z, 1)
									rIsRandomSpawnAnywhereInfo[1]=coords1
								elseif getMissionConfigProperty(MissionName, "CheckpointsDoLand") then
								
									rIsRandomSpawnAnywhereInfo = doLandBattle(MissionName)
								elseif getMissionConfigProperty(MissionName, "CheckpointsDoWater") then
									rIsRandomSpawnAnywhereInfo = doBoatBattle(MissionName)
								elseif  getMissionConfigProperty(MissionName, "CheckpointsDoWaterAndLand") then
									rIsRandomSpawnAnywhereInfo = getRandomAnywhereLocation(MissionName)
									
									--not on water...
									if not rIsRandomSpawnAnywhereInfo[2] and getMissionConfigProperty(MissionName, "SpawnCheckpointsOnRoadsOnly") then 
										local retval1, coords1 = GetClosestVehicleNode(rIsRandomSpawnAnywhereInfo[1].x,rIsRandomSpawnAnywhereInfo[1].y, rIsRandomSpawnAnywhereInfo[1].z, 1)
										rIsRandomSpawnAnywhereInfo[1]=coords1
									
									end
								
								
								end	

							end							
						
						end
						--[[
						if(getMissionConfigProperty(input, "RandomLocation")) then
							--find if in water
							local x = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].x
							local y = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].y
							local z = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].z
							
							--local zGround = checkAndGetGroundZ(500.0,4200.0,z,true)
							
							--print("RandomLocation:zGround"..tostring(zGround))
							--local isWater = Citizen.InvokeNative( 0x8974647ED222EA5F,4200.0, 500.0, 1000.0,4200.0, 500.0,-500.0,Citizen.ReturnResultAnyway())
							
							--print(isWater.z)
							
							--if TestVerticalProbeAgainstAllWater(-1200.0,2700.0,500.0,0) then --TestVerticalProbeAgainstAllWater(500.0,4200.0,0.0,1,500)
								--print("RandomLocation:FOUND WATER")
							--end
							
						
						end 
						]]--
						if getMissionConfigProperty(input, "UseSafeHouse") and getMissionConfigProperty(input, "UseSafeHouseLocations") then
							
							--rSafeHouseLocationIndex = math.random(1, #getMissionConfigProperty(input, "SafeHouseLocations"))
							if(getMissionConfigProperty(MissionName, "IsRandomSpawnAnywhere")) then 	
								rSafeHouseLocationIndex = findBestSafeHouseLocation(rIsRandomSpawnAnywhereInfo[1])
							else
								rSafeHouseLocationIndex = findBestSafeHouseLocation(getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex])
							end 
						
						end			
						
						--print("rMissionType: "..rMissionType)
						--print("FIRSTrSafeHouseLocationIndex: "..rSafeHouseLocationIndex)
						
						SetRandomMissionAttributes(MissionName,rMissionType,getMissionConfigProperty(MissionName, "RandomMissionPositions")[rMissionLocationIndex],rIsRandomSpawnAnywhereInfo) 
						--need to trigger mission blips here for the host as well for random IsDefend missions
						TriggerEvent('missionBlips',MissionName,rMissionLocationIndex,rMissionType,rIsRandomSpawnAnywhereInfo,rSafeHouseLocationIndex,true,rMissionDestinationIndex)	
					else 
						
						rMissionType = Config.Missions[MissionName].Type
					
					end
					
					--print("MISSION COMMAND rSafeHouseLocationIndex:"..rSafeHouseLocationIndex)
					TriggerServerEvent("sv:one",input, Config.Missions[MissionName].MissionTitle, time,rMissionLocationIndex,rMissionType,rIsRandomSpawnAnywhereInfo,rSafeHouseLocationIndex,rMissionDestinationIndex)
					
					if(Config.Missions[MissionName].IsRandom) then 
						--MissionName,MissionType,NumPeds,NumVehicles,locationIndex
						
						--print("DONE:"..math.random(getMissionConfigProperty(MissionName "RandomMissionMinVehicleSpawns"),getMissionConfigProperty(MissionName, "RandomMissionMaxVehicleSpawns"))
						--print(getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].z)
						TriggerEvent("SpawnRandomPed", input,rMissionType, math.random(getMissionConfigProperty(MissionName, "RandomMissionMinPedSpawns"), getMissionConfigProperty(MissionName, "RandomMissionMaxPedSpawns")), math.random(getMissionConfigProperty(MissionName, "RandomMissionMinVehicleSpawns"),getMissionConfigProperty(MissionName, "RandomMissionMaxVehicleSpawns")),rMissionLocationIndex,rIsRandomSpawnAnywhereInfo)
						

						--NEW CHECKPOINT CODE. 
						--print("chk1")
						--print(rSafeHouseLocationIndex)
						if(rMissionType=="Checkpoint") then 
							generateExtraRandomEvents(MissionName,rSafeHouseLocationIndex)
							generateCheckpointsAndEvents(MissionName,rSafeHouseLocationIndex,rIsRandomSpawnAnywhereInfo)		
						else
							generateExtraRandomEvents(MissionName,rSafeHouseLocationIndex)
									
						end
					else
					--print("hey")
						generateExtraRandomEvents(MissionName,rSafeHouseLocationIndex)
						
						if Config.Missions[MissionName].Type=="Checkpoint" then 
							TriggerServerEvent("mrpStreetRaces:createRace_sv",1, 300000, Config.Missions[MissionName].CheckpointsStartPos, Config.Missions[MissionName].RecordedCheckpoints, 360000)				
						end					
					
						TriggerEvent("SpawnPed", input)
					end
					
					
					--Wait 5 seconds for peds to spawn on client/host and migrate to other clients.
					--before spawning NPC blips etc..
					--Wait(5000)					
					
					--TriggerServerEvent("sv:one",input, Config.Missions[MissionName].MissionTitle, time,rMissionLocationIndex,rMissionType)
				
				end
				
            end
        end
    
end, false)

RegisterCommand("stop", function(source, args, rawCommand)
    
	if Active == 0 then
        TriggerEvent('chatMessage', "^1[MISSIONS]: ^2There is not a Mission in Progress.")
    else
		
		--if not Config.Missions[MissionName].IsDefendTarget then 
			Active = 0
			message2 = "^1[MISSIONS]: ^2'".. Config.Missions[MissionName].MissionTitle .."'^0 has been stopped"
			TriggerServerEvent("sv:two", message2)
			TriggerServerEvent("sv:done", MissionName,true,false,"")
			--TriggerEvent("DONE", MissionName) --ghk needed?
			aliveCheck()
			MissionName = "N/A"
			
		--else
			--print("made it 4")
			--Active = 0
			--TriggerServerEvent("sv:KillTargetPed")
			--SetEntityHealth(GlobalTargetPed, 0.0)
			--TriggerEvent("DONE", MissionName) --ghk needed?
			--aliveCheck()
			--MissionName = "N/A"
			--GlobalKillTargetPed = true

		--end
    end
end, false)


function getIsDefendTargetSeatId(input,vehmodel)
	
	local IsDefendTargetSeatIds = getMissionConfigProperty(input, "IsDefendTargetSeatIds")
	if not IsDefendTargetSeatIds then 
		return
	end
	for i, v in pairs(IsDefendTargetSeatIds) do
		
        if vehmodel == i then
			--print("hey")
			--print(v)
			return v
			
        end
    end
	
	return

end 

--when joining a vehicle in IsDefendTarget mission vehicle, 
--or when a player backup ped tries to join
--where should the player or backup go go to?
--overrides  the turrets first logic... for vehicles like apcs.
function getPreferrableSeatId(input,vehmodel)

	local PreferrableSeatIds = getMissionConfigProperty(input, "PreferrableSeatIds")
	
	if not PreferrableSeatIds then 
		return
	end
	--print("vehmodel:"..vehmodel)
	for i, v in pairs(PreferrableSeatIds) do
		--print("i:"..GetHashKey(i))
        if vehmodel == GetHashKey(i) then
			--print("hey")
			--print(v)
			return v
			
        end
    end
	
	return

end 


RegisterNetEvent("mt:generateCheckpointsAndEvents")
AddEventHandler("mt:generateCheckpointsAndEvents", function(MissionName,recordedCheckpoints,Events)
	--print(#Events)
	Config.Missions[MissionName].Events=Events
	--[[
	for index, data in ipairs(Events) do
    print(index)

    for key, value in pairs(data) do
        print('\t', key, value)
		if key=="Position" then
		print("Position size:"..#value)
		--print("coordsx="..value.x)
		--print("coordsy="..value.y)
		--print("coordsz="..value.z)
		end
    end
end
]]--
end)


RegisterNetEvent("mt:dotargetpassenger")
AddEventHandler('mt:dotargetpassenger', function(ped,pvehicle,tseatid)
	--print("hey:"..tostring(tseatid))
	local seatid  = 0
	if tseatid then 
		seatid = tseatid
		
	end
	--print("heyddd:"..tostring(seatid))
	while Active ==1 and MissionName ~= "N/A" do
	
		Citizen.Wait(0)
		--local ped = GetPlayerPed( -1 )
		local vehicle = GetVehiclePedIsIn( ped, false )
		local passenger = GetPedInVehicleSeat(vehicle, seatid)

		  if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then 
			--if ( IsPedSittingInAnyVehicle( ped ) ) then
				
				--if IsVehicleSeatFree(vehicle, -1) then
					if ped == passenger then
						--print("hey")
						SetPedIntoVehicle(ped, vehicle, seatid)
					end
				--end
			--end
		  else 
			--lets break out of loop then to finish the event
			break
		  end
	end
	
end)

RegisterNetEvent('mt:EndMissionFailSound')
AddEventHandler('mt:EndMissionFailSound', function()
	Wait(750)
	PlaySoundFrontend(-1, "Crash", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1) 

end)

RegisterNetEvent('mt:EndMissionPassSound')
AddEventHandler('mt:EndMissionPassSound', function()
	Wait(750)
	PlaySoundFrontend(-1, "MEDAL_UP", "HUD_MINI_GAME_SOUNDSET", 1)

end)

RegisterNetEvent('mt:TriggerMission')
AddEventHandler('mt:TriggerMission', function(input)

	MissionTriggered = true
	if getMissionConfigProperty(input, "MissionTriggerRadius") and DecorGetInt(GetPlayerPed(i),"mrpoptout")==0 then 
		Notify("~h~~w~Mission: ~r~"..Config.Missions[input].MissionTitle.."~w~ has started")
		
		TriggerServerEvent("sv:message", "~h~~w~Mission: ~r~"..Config.Missions[input].MissionTitle.."~w~ has started")
		PlaySoundFrontend(-1, "ROUND_ENDING_STINGER_CUSTOM", "CELEBRATION_SOUNDSET", 1)	
	end
	
end)


RegisterNetEvent('mt:CheckMissionHost')
AddEventHandler('mt:CheckMissionHost', function()
	TriggerServerEvent("sv:CheckHostFlag",BLHOSTFLAG) 
end)

RegisterNetEvent('mt:KillTargetPed')
AddEventHandler('mt:KillTargetPed', function()
		if GlobalTargetPed then
			--SetEntityHealth(GlobalTargetPed, 0.0)
			GlobalKillTargetPed=true
		end
end)

RegisterCommand("list", function(source, rawCommand)
    for i, v in pairs(Config.Missions) do
        TriggerEvent('chatMessage', "^1[MISSION LIST]: ^2".. i ..": '"..Config.Missions[i].MissionTitle.."'")
    end 
end, false)

--------------------------
--------- Events ---------
--------------------------
--working:??
AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
		if Active == 1 and MissionName ~="N/A" then
			TriggerEvent('DONE',MissionName,true,false,"Resource was stopped") --GHK
		end 

    end
end)

AddEventHandler("onResourceStart", function(resource)
   
	if resource == GetCurrentResourceName() then
		
		--reset player upgrade mode
		if GetEntityMaxHealth(GetPlayerPed(-1)) == Config.SafeHouseCrackDownModeHealthAmount and Config.SafeHouseCrackDownMode then 
			playerUpgraded = true
			
			--probably not needed:
			SetPedMoveRateOverride(PlayerId(),10.0)
			SetRunSprintMultiplierForPlayer(PlayerId(),1.49)
			SetSwimMultiplierForPlayer(PlayerId(),1.49)
		end

    end
end)

--used to set that an indoor spawn location has been used
RegisterNetEvent("mt:spawned")
AddEventHandler("mt:spawned", function(input,i,isVehicle)
	--print("Mission spawned called"..i.." isVehicle:"..tostring(isVehicle))
	
	if isVehicle then 
		Config.Missions[input].Vehicles[i].spawned = true
	else 
		Config.Missions[input].Peds[i].spawned = true
	end
	
end)



RegisterNetEvent("mt:IsRandomDoEvent")
AddEventHandler("mt:IsRandomDoEvent", function(svIsRandomDoEvent,svIsRandomDoEventRadius,svIsRandomDoEventType)
	--print("IsRandomDoEvent called:"..svIsRandomDoEventType)
	
	IsRandomDoEvent = svIsRandomDoEvent
	IsRandomDoEventRadius = svIsRandomDoEventRadius
	IsRandomDoEventType = svIsRandomDoEventType
	
end)


--used to set that an indoor spawn location has been used
RegisterNetEvent("mt:UpdateEvents")
AddEventHandler("mt:UpdateEvents", function(k,PlayerServerId,MissionName)
	--print("mt:UpdateEvents called")
	--print("made it:".. k)
	--doParaDrop=false
	if DecorGetInt(GetPlayerPed(-1),"mrpoptout") == 0 then 
		
		Config.Missions[MissionName].Events[k].done = PlayerServerId
		if getMissionConfigProperty(MissionName, "AnnounceEvents") then 	
			if Config.Missions[MissionName].Events[k].Type=="Paradrop" then 
				if not Config.Missions[MissionName].Events[k].Message then 
					Notify("~r~An enemy paradrop has deployed!")
				else 
					Notify("~r~"..Config.Missions[MissionName].Events[k].Message)
				end
				
			elseif Config.Missions[MissionName].Events[k].Type=="Aircraft" then
				if not Config.Missions[MissionName].Events[k].Message then 
					Notify("~r~An enemy aircraft has deployed!")
				else 
					Notify("~r~"..Config.Missions[MissionName].Events[k].Message)
				end			
				
			elseif Config.Missions[MissionName].Events[k].Type=="Vehicle" then
				if not Config.Missions[MissionName].Events[k].Message then 			
					Notify("~r~An enemy vehicle has deployed!")	
				else 
					Notify("~r~"..Config.Missions[MissionName].Events[k].Message)
				end		
				
			elseif Config.Missions[MissionName].Events[k].Type=="Squad" then
				if not Config.Missions[MissionName].Events[k].Message then 			
					Notify("~r~An enemy squad has deployed!")
				else 
					Notify("~r~"..Config.Missions[MissionName].Events[k].Message)
				end			
				
				
			elseif Config.Missions[MissionName].Events[k].Type=="Boat" then
				if not Config.Missions[MissionName].Events[k].Message then 			
					Notify("~r~An enemy boat has deployed!")
				else 
					Notify("~r~"..Config.Missions[MissionName].Events[k].Message)
				end
				
			end
		end 
	end
	
end)

--used to set what indoor locations have been used
--when a client connects to join a mission
--ALSO used to see what peds have been rescued for Type="HostageRescue"
function checkSpawnLocations(MissionName, Peds, Vehicles,Props,Events)
	--print("Mission spawned called"..i.." isVehicle:"..tostring(isVehicle))
	
		if (Active == 1) and  MissionName ~="N/A" and (not Config.Missions[MissionName].IsRandom) and (Config.Missions[MissionName].IndoorsMission or Config.Missions[MissionName].Type=="HostageRescue" or Config.Missions[MissionName].Type=="ObjectiveRescue") then 
		
			if Config.Missions[MissionName].Peds then 
				for i, v in pairs(Peds) do
					if Peds[i].spawned then
						--print("ped already spawned"..i)
						Config.Missions[MissionName].Peds[i].spawned=true
					end
					
					if Peds[i].rescued then 
						Config.Missions[MissionName].Peds[i].rescued=true
					end
					
					if Peds[i].friendly and not Peds[i].dead and not Config.Missions[MissionName].Peds[i].rescued then 
						isHostageRescueCount = isHostageRescueCount + 1
					end					
					
				end
			end 
		
			if Config.Missions[MissionName].Vehicles then 			
				for i, v in pairs(Vehicles) do
					if Vehicles[i].spawned then
						--print("vehicle already spawned"..i)
						Config.Missions[MissionName].Vehicles[i].spawned=true
					end			
				end	
			end
			if Config.Missions[MissionName].Props then 
				for i, v in pairs(Props) do
					if Props[i].rescued then 
						Config.Missions[MissionName].Props[i].rescued=true
					end
					--now count up remaining isObjective props left to rescue
					if Props[i].isObjective and not Props[i].rescued then 
						isObjectiveRescueCount = isObjectiveRescueCount + 1
					end
				end
				
			end
			
		end
		--print("Events type:"..type(Events))
		if (Active == 1) and  MissionName ~="N/A" then 
		if Config.Missions[MissionName].Events then 			
				for i, v in pairs(Events) do
					if Events[i].done then
						--print("Event done:"..i)
						Config.Missions[MissionName].Events[i].done=true
					end			
				end	
			end		
		
		end
		
		--get the amount of hostages left
		if (Active == 1) and  MissionName ~="N/A" and Config.Missions[MissionName].IsRandom and Config.Missions[MissionName].Type=="HostageRescue" then 
			TriggerServerEvent('sv:UpdateisHostageRescueCount')
			
		end
		
	
end

RegisterNetEvent("mt:setmissionTimeout")
AddEventHandler("mt:setmissionTimeout", function(settimeout)
	print("MISSION TIMOUT CLIENT EVENT")
	MissionTimeOut = true
end)

--for IsRandom HostageRescue:
RegisterNetEvent("mt:IsRandomMissionAllHostagesRescued")
AddEventHandler("mt:IsRandomMissionAllHostagesRescued", function(svIsRandomMissionAllHostagesRescued)
	IsRandomMissionAllHostagesRescued = svIsRandomMissionAllHostagesRescued
	--print("IsRandomMissionAllHostagesRescued:"..IsRandomMissionAllHostagesRescued)
end)

--for Regular and IsRandom HostageRescue:
RegisterNetEvent("mt:UpdateisHostageRescueCount")
AddEventHandler("mt:UpdateisHostageRescueCount", function(svHostagesRescued)
	isHostageRescueCount = svHostagesRescued
	--print("UpdateisHostageRescueCount:"..isHostageRescueCount)
end)

--for Regular ObjectiveRescue:
RegisterNetEvent("mt:UpdateisObectiveRescueCount")
AddEventHandler("mt:UpdateisObectiveRescueCount", function(svObjectsRescued)
	isObjectiveRescueCount = svObjectsRescued
	--print("UpdateisHostageRescueCount:"..isHostageRescueCount)
end)

RegisterNetEvent("mt:checkIfIAmHost")
AddEventHandler("mt:checkIfIAmHost", function(newMission)
	print("mt:checkIfIAmHost called")
	TriggerServerEvent("sv:getClientWhoIsHostAndStartNextMission",(NetworkIsHost() and NetworkIsPlayerActive(PlayerId())),newMission)
	
end)

RegisterNetEvent("mt:setmissiontimeleft")
AddEventHandler("mt:setmissiontimeleft", function(mtimeleft)
	MilliSecondsLeft = mtimeleft
end)

--tells client to check for suspicious spawns looking for the mrpcheckspawn decor value > 0
RegisterNetEvent("mt:checkspawns")
AddEventHandler("mt:checkspawns", function(docheckspawns)

	checkspawns = docheckspawns
		
end)

--setting decor values on NPCs on non-host clients do not seem to propogate
--like when on the host, so when non-host changes a value on an 
--NPC make sure everyone does it, most importantly the host as well
RegisterNetEvent("mt:rescuehostage")
AddEventHandler("mt:rescuehostage", function(hostageid,decorval)

	if decorval ~="mrpproprescue" then
		for ped in EnumeratePeds() do
		
			if DecorGetInt(ped, decorval) > 0 then
				if DecorGetInt(ped, decorval) == hostageid then
					
					
					DecorSetInt(ped, decorval,-1)
					--print("decorval: "..decorval.." set")
					--print("hostageid: "..hostageid.." set")
					
					local oldblip = GetBlipFromEntity(ped)

					if DoesBlipExist(oldblip) then 
						RemoveBlip(oldblip)
					end
					
					if getMissionConfigProperty(MissionName,"DrawRescueMarker") and  RescueMarkers['f'..hostageid] then
						--print("hostageid: "..hostageid.." set")
						RescueMarkers['f'..hostageid] = nil
					end
					
					break
				end
			end

		end	
	else 
		--rescue object(ive) missions
		for obj in EnumerateObjects() do
			if DecorGetInt(obj, decorval) > 0 then
				if DecorGetInt(obj, decorval) == hostageid then
					DecorSetInt(obj, decorval,0)
					--DecorRemove(obj, "mrppropid")
					DecorRemove(obj, "mrpproprescue")
					DeleteObject(obj)
					--print("hostageid: "..hostageid.." set")
					break
				end
			end

		end	
	
	
	end

	if((Config.Missions[MissionName].Type=="HostageRescue" and not Config.Missions[MissionName].IsRandom) and decorval=="mrppedfriend") then 
		Config.Missions[MissionName].Peds[hostageid].rescued=true
		isHostageRescueCount = isHostageRescueCount - 1
	end 
	
	if((Config.Missions[MissionName].Type=="ObjectiveRescue" and not Config.Missions[MissionName].IsRandom) and decorval=="mrpproprescue") then 
		Config.Missions[MissionName].Props[hostageid].rescued=true
		isHostageRescueCount = isHostageRescueCount - 1
	end	
	
		
end)



--server tells the host player to start a new mission
RegisterNetEvent("mt:startnextmission")
AddEventHandler("mt:startnextmission", function(nextmission)
	print("mt:startnextmission called")
	local rMissionLocationIndex = 0
	local rSafeHouseLocationIndex = 0
	local rMissionDestinationIndex = 0
	local rMissionType =getMissionConfigProperty(nextmission, "RandomMissionTypes")[math.random(1, #getMissionConfigProperty(nextmission, "RandomMissionTypes"))]
	local rIsRandomSpawnAnywhereInfo = {x=0.0,y=0.0,z=0.0}
			for i, v in pairs(Config.Missions) do
				if nextmission == i then
					if Active == 1 then
						TriggerEvent('chatMessage', "^1[MISSIONS]: ^2Next Mission...There is a mission already in progress.")
					else
					Active = 1
					MissionName = nextmission
					MilliSecondsLeft =  getMissionLength(MissionName)*60*1000
					MissionNoTimeout = getMissionConfigProperty(MissionName, "MissionNoTimeout")
					MissionStartTime = GetGameTimer() 
					MissionEndTime = MissionStartTime + MilliSecondsLeft	
					--MissionName = MissionName
					time = 10000
					--TriggerServerEvent("sv:one", nextmission, Config.Missions[nextmission].MissionTitle, time,rMissionLocationIndex)
						--print("mt:startnextmission called PART 2:"..getMissionConfigProperty(nextmission, "IsRandom"))
					if(Config.Missions[nextmission].IsRandom) then 
						--print("mt:startnextmission called IS RANDOM")
						
						rMissionLocationIndex = math.random(1, #getMissionConfigProperty(nextmission, "RandomMissionPositions"))
						
						if Config.Missions[MissionName].IsDefendTarget and Config.Missions[MissionName].IsVehicleDefendTargetGotoGoal
						and getMissionConfigProperty(MissionName,"IsRandom") then 
							local randomlocation = Config.Missions[MissionName].RandomMissionPositions[1].Blip2.Position
							rMissionDestinationIndex = setBestRandomDestination(randomlocation,MissionName,MissionIsDefendTargetGoalDestIndex)
						end						
						
						
						if(getMissionConfigProperty(nextmission, "RandomMissionPositions")[rMissionLocationIndex].force) then
							
							rMissionType = "Objective" --NPCs have a chance of spawning in buildings with forced = true, so Assassinate may hang
						end	

						--this overrides regular IsRandom missions that use defined random positions:
						if(getMissionConfigProperty(MissionName, "IsRandomSpawnAnywhere")) then 
						
							if (getMissionConfigProperty(MissionName, "RandomMissionDoLandBattle")) then
								rIsRandomSpawnAnywhereInfo = doLandBattle(MissionName)
							else
								rIsRandomSpawnAnywhereInfo = getRandomAnywhereLocation(MissionName)
							end
							
							if rIsRandomSpawnAnywhereInfo[2] then 
								--if a water/boat mission, make it only Assassinate
								rMissionType = "Assassinate"
							end
							
							if Config.Missions[MissionName].Type=="Checkpoint" then 
								if getMissionConfigProperty(MissionName, "CheckpointsDoLand") and 
								getMissionConfigProperty(MissionName, "SpawnCheckpointsOnRoadsOnly") then
								
									rIsRandomSpawnAnywhereInfo = doLandBattle(MissionName)
									local retval1, coords1 = GetClosestVehicleNode(rIsRandomSpawnAnywhereInfo[1].x,rIsRandomSpawnAnywhereInfo[1].y, rIsRandomSpawnAnywhereInfo[1].z, 1)
									rIsRandomSpawnAnywhereInfo[1]=coords1
								elseif getMissionConfigProperty(MissionName, "CheckpointsDoLand") then
								
									rIsRandomSpawnAnywhereInfo = doLandBattle(MissionName)
								elseif getMissionConfigProperty(MissionName, "CheckpointsDoWater") then
									rIsRandomSpawnAnywhereInfo = doBoatBattle(MissionName)
								elseif  getMissionConfigProperty(MissionName, "CheckpointsDoWaterAndLand") then
									rIsRandomSpawnAnywhereInfo = getRandomAnywhereLocation(MissionName)
									
									--not on water...
									if not rIsRandomSpawnAnywhereInfo[2] and getMissionConfigProperty(MissionName, "SpawnCheckpointsOnRoadsOnly") then 
										local retval1, coords1 = GetClosestVehicleNode(rIsRandomSpawnAnywhereInfo[1].x,rIsRandomSpawnAnywhereInfo[1].y, rIsRandomSpawnAnywhereInfo[1].z, 1)
										rIsRandomSpawnAnywhereInfo[1]=coords1
									
									end
								
								
								end	

							end											
							
							
						
						end
						
						
						if getMissionConfigProperty(MissionName, "UseSafeHouse") and getMissionConfigProperty(MissionName, "UseSafeHouseLocations") then
							
							--rSafeHouseLocationIndex = math.random(1, #getMissionConfigProperty(input, "SafeHouseLocations"))
							if(getMissionConfigProperty(MissionName, "IsRandomSpawnAnywhere")) then 	
								rSafeHouseLocationIndex = findBestSafeHouseLocation(rIsRandomSpawnAnywhereInfo[1])
							else
								rSafeHouseLocationIndex = findBestSafeHouseLocation(getMissionConfigProperty(MissionName, "RandomMissionPositions")[rMissionLocationIndex])
								
							end 
						
						end		
						
						

						SetRandomMissionAttributes(nextmission,rMissionType, getMissionConfigProperty(nextmission, "RandomMissionPositions")[rMissionLocationIndex],rIsRandomSpawnAnywhereInfo) 
							
						--local chosenLocation = Config.RandomMissionPositions[math.random(1, rIndex)]		
						--need to trigger this directly on host before spawning peds for random IsDefend missions
						TriggerEvent('missionBlips',nextmission,rMissionLocationIndex,rMissionType,rIsRandomSpawnAnywhereInfo,rSafeHouseLocationIndex,true,rMissionDestinationIndex)				
					end 
					
					TriggerServerEvent("sv:one",nextmission, Config.Missions[nextmission].MissionTitle, time,rMissionLocationIndex,rMissionType,rIsRandomSpawnAnywhereInfo,rSafeHouseLocationIndex,rMissionDestinationIndex)
					
					if(Config.Missions[nextmission].IsRandom) then 
						TriggerEvent("SpawnRandomPed", nextmission,rMissionType, math.random(getMissionConfigProperty(MissionName, "RandomMissionMinPedSpawns"), getMissionConfigProperty(MissionName, "RandomMissionMaxPedSpawns")), math.random(getMissionConfigProperty(MissionName, "RandomMissionMinVehicleSpawns"),getMissionConfigProperty(MissionName, "RandomMissionMaxVehicleSpawns")),rMissionLocationIndex,rIsRandomSpawnAnywhereInfo)
						
						if(rMissionType=="Checkpoint") then
						
							generateExtraRandomEvents(MissionName,rSafeHouseLocationIndex)						
							generateCheckpointsAndEvents(MissionName,rSafeHouseLocationIndex,rIsRandomSpawnAnywhereInfo)	
							
						else	
						
							generateExtraRandomEvents(MissionName,rSafeHouseLocationIndex)	
						end						
						
					else
						generateExtraRandomEvents(MissionName,rSafeHouseLocationIndex)	
						if Config.Missions[MissionName].Type=="Checkpoint" then 
							TriggerServerEvent("mrpStreetRaces:createRace_sv",1, 300000, Config.Missions[MissionName].CheckpointsStartPos, Config.Missions[MissionName].RecordedCheckpoints, 360000)				
						end							
						TriggerEvent("SpawnPed", nextmission)
					end					
					
					--Wait 5 seconds for peds to spawn on client/host and migrate to other clients.
					--before spawning NPC blips etc..
					--Wait(5000)
					--TriggerServerEvent("sv:one",nextmission, Config.Missions[nextmission].MissionTitle, time,rMissionLocationIndex,rMissionType)
					
					
					
					--TriggerEvent("SpawnPed", nextmission)
					end
				end
			end

		
end)





--called from server when player first logs in
RegisterNetEvent("mt:setactive")
AddEventHandler("mt:setactive", function(activeflag,input,onlineplayers,docheckspawns,mtimeleft,IsMissionCurrentlyActive,MissionType,MissionLocationIndex,IsRandomSpawnAnywhereInfo,SafeHouseLocationIndex,Peds,Vehicles,Props,Events,svIsRandomDoEvent,svIsRandomDoEventRadius,svIsRandomDoEventType,MissionDestinationIndex)
    local currentplayercount = onlineplayers
	local rMissionLocationIndex = 0
	local rSafeHouseLocationIndex = 0
	local rMissionDestinationIndex  = 0
	local rIsRandomSpawnAnywhereInfo = {x=0.0,y=0.0,z=0.0}
	local rMissionType = getMissionConfigProperty(input, "RandomMissionTypes")[math.random(1, #getMissionConfigProperty(input, "RandomMissionTypes"))]
	
	if activeflag == 1 then
		
		--print("mt setactive: currentplayercount:"..currentplayercount)
		--print("mt setactive: mtimeleft:"..mtimeleft)
		
		Active = activeflag
		MissionName = input
		MilliSecondsLeft = mtimeleft --getMissionLength(MissionName)
		MissionStartTime = GetGameTimer() 
		MissionEndTime = MissionStartTime + MilliSecondsLeft	
		MissionNoTimeout = getMissionConfigProperty(MissionName, "MissionNoTimeout")
		
		
		--MissionNumber = tonumber(string.sub(MissionName, -1))
		TriggerEvent('chatMessage',"^1[MISSIONS]: ^2'".. Config.Missions[MissionName].MissionTitle.."'^0 has been launched.")
		
		TriggerEvent("mt:missiontext", MissionName, 10000)
		
		--print("1mrpoptin_teleportcheck"..DecorGetInt(GetPlayerPed(-1),"mrpoptin_teleportcheck"))
		--check if currently active mission from server, and get those variables instead.
		if (IsMissionCurrentlyActive and currentplayercount ~= 1 ) then 
			rMissionType =MissionType
			
			if(Config.Missions[MissionName].IsRandom) then 
			
				rMissionLocationIndex = MissionLocationIndex
				rIsRandomSpawnAnywhereInfo = IsRandomSpawnAnywhereInfo
				rSafeHouseLocationIndex  = SafeHouseLocationIndex
				SetRandomMissionAttributes(input,rMissionType, getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex],rIsRandomSpawnAnywhereInfo) 
				rMissionDestinationIndex = MissionDestinationIndex				
			end
			
			--Events generated on the server for Checkpoint mission. NOT ANYMORE
			--if(Config.Missions[MissionName].Type == "Checkpoint") then 
				--print("events;")
				--print(#Events)
				Config.Missions[MissionName].Events=Events
			--end
			--check if we need to update spawn locations if an IndoorsMission=true mission
			checkSpawnLocations(MissionName, Peds, Vehicles,Props,Events)
			--update IsRandomDoEvent
			IsRandomDoEvent = svIsRandomDoEvent
			IsRandomDoEventRadius = svIsRandomDoEventRadius
			IsRandomDoEventType = svIsRandomDoEventType
			--print("IsRandomDoEvent set active called:"..IsRandomDoEventType)
	
		else
			--print("MADE1 IT")
			--let this client be 'host' and start a new mission
			--Maybe turn this off???
			if(Config.Missions[MissionName].IsRandom) then 
				rMissionLocationIndex = math.random(1, #getMissionConfigProperty(input, "RandomMissionPositions"))
				
				
						if Config.Missions[input].IsDefendTarget and Config.Missions[input].IsVehicleDefendTargetGotoGoal
						and getMissionConfigProperty(input,"IsRandom") then 
							local randomlocation = Config.Missions[input].RandomMissionPositions[1].Blip2.Position
							rMissionDestinationIndex = setBestRandomDestination(randomlocation,input,MissionIsDefendTargetGoalDestIndex)
						end							
				
										
				
					if(getMissionConfigProperty(MissionName, "RandomMissionPositions")[rMissionLocationIndex].force) then
						
						rMissionType = "Objective" --NPCs have a chance of spawning in buildings with forced = true, so Assassinate may hang
					end

						--this overrides regular IsRandom missions that use defined random positions:
					if(getMissionConfigProperty(MissionName, "IsRandomSpawnAnywhere")) then 
							
						if (getMissionConfigProperty(MissionName, "RandomMissionDoLandBattle")) then
							rIsRandomSpawnAnywhereInfo = doLandBattle(MissionName)
						else
							rIsRandomSpawnAnywhereInfo = getRandomAnywhereLocation(MissionName)
						end					
								
						if rIsRandomSpawnAnywhereInfo[2] then 
							--if a water/boat mission, make it only Assassinate
							rMissionType = "Assassinate"
						end
						
							if Config.Missions[MissionName].Type=="Checkpoint" then 
								if getMissionConfigProperty(MissionName, "CheckpointsDoLand") and 
								getMissionConfigProperty(MissionName, "SpawnCheckpointsOnRoadsOnly") then
								
									rIsRandomSpawnAnywhereInfo = doLandBattle(MissionName)
									local retval1, coords1 = GetClosestVehicleNode(rIsRandomSpawnAnywhereInfo[1].x,rIsRandomSpawnAnywhereInfo[1].y, rIsRandomSpawnAnywhereInfo[1].z, 1)
									rIsRandomSpawnAnywhereInfo[1]=coords1
								elseif getMissionConfigProperty(MissionName, "CheckpointsDoLand") then
								
									rIsRandomSpawnAnywhereInfo = doLandBattle(MissionName)
								elseif getMissionConfigProperty(MissionName, "CheckpointsDoWater") then
									rIsRandomSpawnAnywhereInfo = doBoatBattle(MissionName)
								elseif  getMissionConfigProperty(MissionName, "CheckpointsDoWaterAndLand") then
									rIsRandomSpawnAnywhereInfo = getRandomAnywhereLocation(MissionName)
									
									--not on water...
									if not rIsRandomSpawnAnywhereInfo[2] and getMissionConfigProperty(MissionName, "SpawnCheckpointsOnRoadsOnly") then 
										local retval1, coords1 = GetClosestVehicleNode(rIsRandomSpawnAnywhereInfo[1].x,rIsRandomSpawnAnywhereInfo[1].y, rIsRandomSpawnAnywhereInfo[1].z, 1)
										rIsRandomSpawnAnywhereInfo[1]=coords1
									
									end
								
								
								end	

							end										
						
							
					end
					
					
					
						if getMissionConfigProperty(MissionName, "UseSafeHouse") and getMissionConfigProperty(MissionName, "UseSafeHouseLocations") then
							
							--rSafeHouseLocationIndex = math.random(1, #getMissionConfigProperty(input, "SafeHouseLocations"))
							if(getMissionConfigProperty(MissionName, "IsRandomSpawnAnywhere")) then 	
								rSafeHouseLocationIndex = findBestSafeHouseLocation(rIsRandomSpawnAnywhereInfo[1])
							else
								rSafeHouseLocationIndex = findBestSafeHouseLocation(getMissionConfigProperty(MissionName, "RandomMissionPositions")[rMissionLocationIndex])
							end 
						
						end		
				
				
				SetRandomMissionAttributes(input,rMissionType, getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex],rIsRandomSpawnAnywhereInfo,rMissionDestinationIndex)
							
			end 
		end


		
		TriggerEvent('missionBlips',MissionName,rMissionLocationIndex,rMissionType,rIsRandomSpawnAnywhereInfo,rSafeHouseLocationIndex,false,rMissionDestinationIndex) 
		--print("2mrpoptin_teleportcheck"..DecorGetInt(GetPlayerPed(-1),"mrpoptin_teleportcheck"))				
		if(currentplayercount == 1) then 
			--mission is currently running on server (ActiveMission=true), and they are only player
			--start mission for them and spawn peds, set mission blip, and NPC blips
			--print("MADE IT")
			if(Config.Missions[MissionName].IsRandom) then 
				TriggerEvent("SpawnRandomPed", input,rMissionType, math.random(getMissionConfigProperty(MissionName, "RandomMissionMinPedSpawns"), getMissionConfigProperty(MissionName, "RandomMissionMaxPedSpawns")), math.random(getMissionConfigProperty(MissionName, "RandomMissionMinVehicleSpawns"),getMissionConfigProperty(MissionName, "RandomMissionMaxVehicleSpawns")),rMissionLocationIndex,rIsRandomSpawnAnywhereInfo)
					
				--NEW CHECKPOINT CODE. 
				--print("chk1")
				--print(rSafeHouseLocationIndex)
				--SHOULD BE FINE
				if(rMissionType=="Checkpoint") then 
					generateExtraRandomEvents(MissionName,rSafeHouseLocationIndex)
					generateCheckpointsAndEvents(MissionName,rSafeHouseLocationIndex,rIsRandomSpawnAnywhereInfo)
				else 
					generateExtraRandomEvents(MissionName,rSafeHouseLocationIndex)
				end							
				
				
				
			else
				--print("chk1b")
				generateExtraRandomEvents(MissionName,rSafeHouseLocationIndex)
									
				if Config.Missions[MissionName].Type=="Checkpoint" then 
					TriggerServerEvent("mrpStreetRaces:createRace_sv",1, 300000, Config.Missions[MissionName].CheckpointsStartPos, Config.Missions[MissionName].RecordedCheckpoints, 360000)				
				end				
				TriggerEvent("SpawnPed", input)		
			end	
			--wait 5 seconds for the peds to spawn
			--Wait(5000)
			--print('SETACTIVE')
			--TriggerEvent('missionBlips',  MissionName,rMissionLocationIndex,rMissionType)		
			TriggerEvent("SpawnPedBlips", input)
			TriggerServerEvent("sv:one",input, Config.Missions[MissionName].MissionTitle, time,rMissionLocationIndex,rMissionType,rIsRandomSpawnAnywhereInfo,rSafeHouseLocationIndex,
			rMissionDestinationIndex)
			
			
			
			
		elseif(currentplayercount > 0) then 
		
			--mission is running on server (ActiveMission=true) and there are other players
			--enable mission for them, dont spawn peds, but set mission blip and NPC blips
			--also set whether suspicious spawns need to be checked
			checkspawns = docheckspawns
			--make joining players wait 5seconds too
			--Wait(5000)
			--TriggerEvent('missionBlips',  MissionName,rMissionLocationIndex,rMissionType)		
			TriggerEvent("SpawnPedBlips", input)
		
		else 
			--SHOULD NEVER HAPPEN
			print('FOUND 0 PLAYERS: NO MISSIONS')
			Active = 0
			MissionName = "N/A"
		
		end
		--print("MADE IT")
		--DecorSetInt(GetPlayerPed(-1),"mrpoptin_teleportcheck",0)
		
		--Citizen.Wait(500)
		--TriggerEvent('chatMessage', "^1[MISSIONS]: ^2Mission already in progress. Wait till it is completed or use '/stop' command")
		--Citizen.Wait(500)
		--TriggerEvent('chatMessage', "^1[MISSIONS]: ^2 Use '/list' to find missions. To start a mission use '/mission Mission1' (etc..)")				
		
	else 
		
		TriggerEvent('chatMessage', "^1[MISSIONS]: ^2 Use '/list' to find missions. To start a mission use '/mission Mission1' (etc..)")
		TriggerEvent('chatMessage', "^1[MISSIONS]: ^2 Use '/stop' command to stop a mission ")	
	end
	   
end)

RegisterNetEvent("mt:missiongeneraltext")
AddEventHandler("mt:missiongeneraltext", function(input,message, timet)
	--Active = 1 --GHK Make sure this is set for all clients for mission start
		MissionName = input  --GHK Make sure this is set for all clients for mission start
        local text = message
        ClearPrints()
        SetTextEntry_2("STRING")
        AddTextComponentString(text)
        DrawSubtitleTimed(timet, 1)
		
end)

--=CREDIT TO VenomXNL: 
--https://github.com/VenomXNL/XNL-FiveM-Trains-U3/blob/master/XNL-FiveM-Trains-U3/client.lua
function SMS_Message(NotiPic, SenderName, Subject, MessageText, PlaySound)

	RequestStreamedTextureDict(NotiPic,1)
	while not HasStreamedTextureDictLoaded(NotiPic)  do
		Wait(1)
	end

   Citizen.InvokeNative(0x202709F4C58A0424,"STRING")
   AddTextComponentString(MessageText)
    Citizen.InvokeNative(0x92F0DA1E27DB96DC,140)
    Citizen.InvokeNative(0x1CCD9A37359072CF,NotiPic, NotiPic, true, 4, SenderName, Subject, MessageText)
   Citizen.InvokeNative(0xAA295B6F28BD587D,false, true)
	if PlaySound then
		PlaySoundFrontend(GetSoundId(), "Text_Arrive_Tone", "Phone_SoundSet_Default", true)
	end
end

RegisterNetEvent("mt:doEndSMS")
AddEventHandler("mt:doEndSMS", function(input, isfail) 
		
		local sms_pos = math.random(1, #getMissionConfigProperty(input, "SMS_ContactNames"))
	
		local sms_subjext 
		local sms_message 
		
		if not isfail then
		
			if getMissionConfigProperty(input, "SMS_NoPassedMessage") then 
				return
			end
		
			sms_subjext = getMissionConfigProperty(input, "SMS_ContactPassedSubjects")[sms_pos]
			sms_message = getMissionConfigProperty(input, "SMS_ContactPassedMessages")[sms_pos]
		
			--check actual mission message.
			if getMissionConfigProperty(input, "SMS_PassedSubject") then 
				sms_subjext= Config.Missions[input].SMS_PassedSubject
			end
			if  getMissionConfigProperty(input, "SMS_PassedMessage") then 
				sms_message= Config.Missions[input].SMS_PassedMessage
			end			
		
		
		else 
			if getMissionConfigProperty(input, "SMS_NoFailedMessage") then 
				return
			end
		
			sms_subjext = getMissionConfigProperty(input, "SMS_ContactFailedSubjects")[sms_pos]
			sms_message = getMissionConfigProperty(input, "SMS_ContactFailedMessages")[sms_pos]
				
			--check actual mission message.
			if getMissionConfigProperty(input, "SMS_FailedSubject") then 
				sms_subjext= Config.Missions[input].SMS_FailedSubject
			end
			if  getMissionConfigProperty(input, "SMS_FailedMessage") then 
				sms_message= Config.Missions[input].SMS_FailedMessage
			end					
		
		end
		
		Wait(5000)
		SMS_Message(getMissionConfigProperty(input, "SMS_ContactPics")[sms_pos], getMissionConfigProperty(input, "SMS_ContactNames")[sms_pos], sms_subjext,  sms_message, getMissionConfigProperty(input, "SMS_PlaySound"))



end)

RegisterNetEvent("mt:missiontext")
AddEventHandler("mt:missiontext", function(input, timet)
	Active = 1 --GHK Make sure this is set for all clients for mission start
	MissionName = input  --GHK Make sure this is set for all clients for mission start
	
	if DecorGetInt(GetPlayerPed(-1),"mrpoptout") == 0 and getMissionConfigProperty(input, "ShowMissionIntroText") then 
		--for i=1, #Config.Missions[input].StartMessage do
			local text = Config.Missions[input].StartMessage
			ClearPrints()
			SetTextEntry_2("STRING")
			AddTextComponentString(text)
			DrawSubtitleTimed(timet, 1)
				
			--Notify("~w~Mission: ~r~"..Config.Missions[input].MissionTitle.."~w~ has launched")	
		--end
	end
	
	--global here since this can be called twice sometimes. 
	--also show for all players, including those opted out.
	if not MissionDoneSMS then 
		--RequestStreamedTextureDict("CHAR_WE",1)
		--while not HasStreamedTextureDictLoaded("CHAR_WE")  do
				--Wait(1)
		--end	
		MissionDoneSMS=true
	
		local sms_pos = math.random(1, #getMissionConfigProperty(input, "SMS_ContactNames"))
	
		local sms_subjext = getMissionConfigProperty(input, "SMS_ContactSubjects")[sms_pos]
		local sms_message = getMissionConfigProperty(input, "SMS_ContactMessages")[sms_pos]
		
		
		--check booleans
		if getMissionConfigProperty(input, "SMS_MissionTitle") then 
			sms_subjext= Config.Missions[input].MissionTitle
		end
		if  getMissionConfigProperty(input, "SMS_MissionMessage") then 
			sms_message= Config.Missions[input].MissionMessage
		end
		
		--check actual mission message.
		if getMissionConfigProperty(input, "SMS_Subject") then 
			sms_subjext= Config.Missions[input].SMS_Subject
		end
		if  getMissionConfigProperty(input, "SMS_Message") then 
			sms_message= Config.Missions[input].SMS_Message
		end	
		
		SMS_Message(getMissionConfigProperty(input, "SMS_ContactPics")[sms_pos], getMissionConfigProperty(input, "SMS_ContactNames")[sms_pos], sms_subjext,  sms_message, getMissionConfigProperty(input, "SMS_PlaySound"))
		
		if getMissionConfigProperty(input, "SMS_Message2") then 
			Wait(math.random(3)*1000)
			sms_message= Config.Missions[input].SMS_Message2
			SMS_Message(getMissionConfigProperty(input, "SMS_ContactPics")[sms_pos], getMissionConfigProperty(input, "SMS_ContactNames")[sms_pos], sms_subjext,  sms_message, getMissionConfigProperty(input, "SMS_PlaySound"))		
		
		end
		
		if getMissionConfigProperty(input, "SMS_Message3") then
			Wait(math.random(3)*1000)
			sms_message= Config.Missions[input].SMS_Message3
			SMS_Message(getMissionConfigProperty(input, "SMS_ContactPics")[sms_pos], getMissionConfigProperty(input, "SMS_ContactNames")[sms_pos], sms_subjext,  sms_message, getMissionConfigProperty(input, "SMS_PlaySound"))		
		
		end		
		
		--Notify("~h~~b~Check your map for mission data.~n~Hold DPAD DOWN or '[' key to view mission information.")
		
		--SetTextComponentFormat("STRING")
		--AddTextComponentString("Check your map for mission data. Press ~INPUT_SNIPER_ZOOM_OUT_SECONDARY~ to view mission info.")
		--DisplayHelpTextFromStringLabel(0, 0, 1, 5000)
		
		
		
		if getMissionConfigProperty(input, "IsDefendTargetVehiclePassengerRadius") > 0 and getMissionConfigProperty(input, "IsDefendTarget") then 
			--Notify("~h~~b~Within "..getMissionConfigProperty(input, "IsDefendTargetVehiclePassengerRadius")  
			--.."m of the target's vehicle, you can press ~INPUT_WEAPON_WHEEL_PREV~ AND ~INPUT_PICKUP~ to enter it")
			--print("made it")
			--lineTwo ="Within " 
			
			TriggerEvent("mt:doisDefendVehicleHelp")
			
		end
		
		   
		Wait(7000)
		
		
		--do it again, to bypass mission chat messages on mission launch
		HelpMessage("Check your map for mission data. Press ~INPUT_SNIPER_ZOOM_OUT_SECONDARY~ to view mission info.",true,5000)
		
		
		
		--if DecorGetInt(GetPlayerPed(-1),"mrpoptout") == 0 then
			Wait(5000)
			HelpMessage("Press ~INPUT_LOOK_BEHIND~ and ~INPUT_PICKUP~ for a quick tutorial on controls and mission help",false,5000)
			
			--[[			
			if blDoNightVisionToggleStates > 0 then
				Wait(5000)
				HelpMessage("Press ~INPUT_DUCK~ and ~INPUT_LOOK_BEHIND~ to toggle night vision modes",false,5000)

			end	
			
			if(getMissionConfigProperty(input, "UseSafeHouseCrateDrop")) then 
				Wait(5000)
				HelpMessage("Call in an air supply drop using ~INPUT_WEAPON_WHEEL_PREV~ and ~INPUT_COVER~. Cost: $"..getMissionConfigProperty(input, "SafeHouseCostCrate"),false,5000)
				Wait(5000)
				HelpMessage("The safe house needs to be open to call in an air supply drop",false,5000)
				
			end
			
			if getMissionConfigProperty(MissionName, "UseMissionDrop") then 
				Wait(5000)
				HelpMessage("Press~INPUT_DUCK~ and ~INPUT_COVER~ to create a Mission Reinforcement Drop",false,5000)
				Wait(5000)
				HelpMessage("Mission Reinforcement Drops allow for fast travel after you respawn",false,5000)				
			end			
			
			if(getMissionConfigProperty(input, "UseSafeHouseBanditoDrop")) then 
				Wait(5000)
				HelpMessage("Deploy an explosive drone car with ~INPUT_WEAPON_WHEEL_NEXT~ and ~INPUT_COVER~.",true,5000)
				Wait(5000)
				HelpMessage("Press ~INPUT_PICKUP~ to explode the drone car once activated. Cost to deploy: $"..getMissionConfigProperty(input, "SafeHouseCostCrate"),false,5000)
				Wait(5000)
				HelpMessage("The safe house needs to be open to deploy, and it will count towards a safe house vehicle",false,5000)		
				
			end	
			]]--
		--end
		
		--SetTextComponentFormat("STRING")
		--AddTextComponentString("Hit ~INPUT_CONTEXT~ to do shit!")
		--DisplayHelpTextFromStringLabel(0, 0, 1, 5000)
		
		
	end
	
	
end)

RegisterNetEvent("mt:doMissionHelpText")
AddEventHandler("mt:doMissionHelpText", function(input)


		--do it again, to bypass mission chat messages on mission launch
		HelpMessage("This is the help guide for this mission",false,5000)
		Wait(5000)
		
		if((getMissionConfigProperty(input, "EnableOptIn")) or 
			(getMissionConfigProperty(input, "EnableSafeHouseOptIn")))
			and 
			DecorGetInt(GetPlayerPed(-1),"mrpoptout") == 1
			then 
			HelpMessage("You are not in the mission. Press ~INPUT_SNIPER_ZOOM_OUT_SECONDARY~ on how to join",false,5000)
			Wait(5000)
		end		
		
		HelpMessage("Check your map for mission data. Press ~INPUT_SNIPER_ZOOM_OUT_SECONDARY~ to view mission info.",false,5000)
		
		
		--if DecorGetInt(GetPlayerPed(-1),"mrpoptout") == 0 then 
		
			if(getMissionConfigProperty(input, "UseSafeHouse")) then 
				Wait(5000)
				HelpMessage("Use the safe house for equipment and upgrades for the mission, whenever it is open. Cost: $"..getMissionConfigProperty(input, "SafeHouseCost"),false,5000)
				Wait(5000)
				HelpMessage("Use the boat and vehicle safe houses for mission vehicles. Cost per vehicle: $"..getMissionConfigProperty(input, "SafeHouseCostVehicle"),false,5000)
				Wait(5000)
				HelpMessage("When a mission is activated, any mission vehicle you drive, will be claimed by you",false,5000)	
				Wait(5000)
				HelpMessage("Only you will be able to drive it, but other players can be passengers. You can claim "..getMissionConfigProperty(input, "SafeHouseVehiclesMaxClaim").." vehicles",false,5000)						
			end
		
		
			if blDoNightVisionToggleStates > 0 then
				Wait(5000)
				HelpMessage("Press ~INPUT_DUCK~ and ~INPUT_LOOK_BEHIND~ to toggle night vision modes",false,5000)

			end	
			
			if(getMissionConfigProperty(input, "UseSafeHouseCrateDrop")) then 
				Wait(5000)
				HelpMessage("Call in an air supply drop using ~INPUT_DUCK~ and ~INPUT_SELECT_WEAPON~. Cost: $"..getMissionConfigProperty(input, "SafeHouseCostCrate"),false,5000)
				Wait(5000)
				HelpMessage("It's the same equipment and upgrades. The safe house needs to be open to call in an air supply drop",false,5000)
				
			end
			
			if getMissionConfigProperty(MissionName, "UseMissionDrop") then 
				Wait(5000)
				HelpMessage("Press~INPUT_DUCK~ and ~INPUT_COVER~ to toggle a Mission Reinforcement Drop (MRD) at your location",false,5000)
				Wait(5000)
				HelpMessage("MRDs allow for fast travel after you respawn. Cost: $"..getMissionConfigProperty(input, "UseMissionDropFee"),false,5000)	
				Wait(5000)
				HelpMessage("If an MRD is set, after you respawn, press ~INPUT_LOOK_BEHIND~ and ~INPUT_COVER~ to move there",false,5000)			
			end			
			
			if(getMissionConfigProperty(input, "UseSafeHouseBanditoDrop")) then 
				Wait(5000)
				HelpMessage("Deploy an explosive drone car with ~INPUT_WEAPON_WHEEL_NEXT~ and ~INPUT_COVER~.",false,5000)
				Wait(5000)
				HelpMessage("Press ~INPUT_PICKUP~ to explode the drone car once activated. Cost to deploy: $"..getMissionConfigProperty(input, "SafeHouseCostCrate"),false,5000)
				Wait(5000)
				HelpMessage("The safe house needs to be open to deploy, and it will count towards a safe house vehicle",false,5000)		
				
			end
			
			if(getMissionConfigProperty(input, "MissionDoBackup")) then 
				Wait(5000)
				HelpMessage("Call for safe house mission backup with ~INPUT_WEAPON_WHEEL_PREV~ and ~INPUT_LOOK_BEHIND~",false,5000)
				Wait(5000)
				HelpMessage("An ally from the safe house will quickly arrive to help. Cost $"..getMissionConfigProperty(input, "BackupPedFee"),false,5000)
				Wait(5000)
				HelpMessage("You can have one ally at a time. They will help with combat but they will not earn you money",false,5000)	
				
				Wait(5000)				
				HelpMessage("You can dismiss an ally by pressing ~INPUT_MULTIPLAYER_INFO~ and ~INPUT_LOOK_BEHIND~",false,5000)				
				
				if(getMissionConfigProperty(input, "BackupPedHeavyMunitionsAllow")) then 
				Wait(5000)				
				HelpMessage("Select allies with different weapons by pressing ~INPUT_WEAPON_WHEEL_NEXT~ and ~INPUT_LOOK_BEHIND~",false,5000)			
				
				end
				
				Wait(5000)
				HelpMessage("Press ~INPUT_PICKUP~ and ~INPUT_COVER~ when in a vehicle to swap seats with your backup",false,0)
				
				Wait(5000)
				HelpMessage("This can be useful for vehicles like the barrage when you want to swap a turret seat, etc..",false,0)
				
				--Wait(5000)
				--HelpMessage("To see this tutorial again, press ~INPUT_LOOK_BEHIND~ and ~INPUT_PICKUP~",false,5000)						
				
			
				
			end			
			
			Wait(5000)
			HelpMessage("Some Escort/Transport/Rescue/Defend missions can allow you to enter the target vehicle, if in range",false,0)
			Wait(5000)
			HelpMessage("Press ~INPUT_WEAPON_WHEEL_PREV~ and ~INPUT_PICKUP~ to enter the target's vehicle, if a seat is free",false,0)
			
			Wait(5000)
			HelpMessage("To see this tutorial again, press ~INPUT_LOOK_BEHIND~ and ~INPUT_PICKUP~",false,5000)	


				
			
		--end


end)

RegisterNetEvent("mt:doisDefendVehicleHelp")
AddEventHandler("mt:doisDefendVehicleHelp", function()

	 while MissionName ~="N/A" and Active == 1  do
       
			
			if GlobalTargetPed then 
			
			local pcoords = GetEntityCoords(GetPlayerPed(-1),true)
				local GTVehicle = GetVehiclePedIsIn(GlobalTargetPed, false)
				if Config.Missions[MissionName].IsDefendTarget and GlobalTargetPed and GTVehicle and 
				DecorGetInt(GetPlayerPed(-1),"mrpoptout") == 0 then	
					local v = GetEntityCoords(GTVehicle,true)
					--print("made it:"..tostring(GetDistanceBetweenCoords(pcoords.x,pcoords.y,pcoords.z, v.x, v.y, v.z, true)))
					if GTVehicle ~= GetVehiclePedIsIn(GetPlayerPed(-1), false)
					and getMissionConfigProperty(MissionName, "IsDefendTargetVehiclePassengerRadius") > 0 
					and 
					
					GetDistanceBetweenCoords(pcoords.x,pcoords.y,pcoords.z, v.x, v.y, v.z, true) <  
	getMissionConfigProperty(MissionName, "IsDefendTargetVehiclePassengerRadius")
					then

						--print("hey")
						HelpMessage("Press ~INPUT_WEAPON_WHEEL_PREV~ and ~INPUT_PICKUP~ to enter the target's vehicle",true,0)
					
					
					
					end

				end
			end
			
		 Wait(0)
				
	end
				
end)

--credit to Vespura:
function HelpMessage(lineOne,doBeep,duration)
    --SetTextComponentFormat("THREESTRINGS")
	SetTextComponentFormat("STRING")
	AddTextComponentString(lineOne)
	--AddTextComponentString(lineTwo or "rgg")
   -- AddTextComponentString(lineThree or "")

    -- shape (always 0), loop (bool), makeSound (bool), duration (5000 max 5 sec)
   DisplayHelpTextFromStringLabel(0, false, doBeep, duration or 5000)
end

RegisterNetEvent("mt:removepickups")
AddEventHandler("mt:removepickups", function(oldmission)
	if(Config.CleanupPickups) then	
		CleanupPickups(oldmission,false)
	end
end)

RegisterNetEvent("mt:missiontext2")
AddEventHandler("mt:missiontext2", function(input, timet)
    if DecorGetInt(GetPlayerPed(-1),"mrpoptout") == 0 then 
		local text = input
		ClearPrints()
		SetTextEntry_2("STRING")
		AddTextComponentString(text)
		DrawSubtitleTimed(timet, 1)
	end 
end)

--MUCH MORE THAN MISSION BLIPS, DOES A LOT OF INITIALIZING FOR NON-HOST CLIENTS
RegisterNetEvent('missionBlips') --**added SpawnMissionPickups to this for clients**
AddEventHandler('missionBlips', function(input,rMissionLocationIndex,rMissionType,rIsRandomSpawnAnywhereInfo,rSafeHouseLocationIndex,blNewMissionFlag,rMissionDestinationIndex)
	local blip
	local btitle --= Config.Missions[input].Blip.Title
	
	--WHERE ELSE TO SET THIS BAck to 0? 
	--THIS IS SAFE ENOUGH PLACE, SHOULD ALWAYS GET CALLED FOR EVERY MISSION
	playerwasinmissionG = 0
	
	--print("FIRSTmissionBlips rIsRandomSpawnAnywhereInfo: "..rIsRandomSpawnAnywhereInfo.x)
	--print("FIRSTmissionBlips rSafeHouseLocationIndex: "..rSafeHouseLocationIndex)

	--INITIALIZE NON-HOST CLIENTS HERE
	Active = 1
	MissionName = input
	--allow the mission to be active
	GlobalKillTargetPed  = false
	
	
	
	if getMissionConfigProperty(input, "RemoveWeaponsAndUpgradesAtMissionStart") then 
		Notify("~r~Any previous weapons and upgrades have been removed for this mission")
		if (Config.EnableOptIn or Config.EnableSafeHouseOptIn) and DecorGetInt(GetPlayerPed(-1),"mrpoptout") == 0 then 
			--print("made 1 it")
			RemoveAllPedWeapons(GetPlayerPed(-1))
			playerUpgraded = false
			SetPedMaxHealth(GetPlayerPed(-1),200)
			SetEntityHealth(GetPlayerPed(-1),200)					
			SetPedMoveRateOverride(PlayerId(),1.0) --1.0 is default?
			SetRunSprintMultiplierForPlayer(PlayerId(),1.0)
			SetSwimMultiplierForPlayer(PlayerId(),1.0)
			SetNightvision(false)
			SetSeethrough(false)
			blDoNightVisionToggleState = 0
			blDoNightVisionToggleStates = 0
			blDoNightVision = false
		elseif not(Config.EnableOptIn or Config.EnableSafeHouseOptIn) then
			--print("made 2 it")		
			RemoveAllPedWeapons(GetPlayerPed(-1))
			playerUpgraded = false
			SetPedMaxHealth(GetPlayerPed(-1),200)	
			SetEntityHealth(GetPlayerPed(-1),200)					
			SetPedMoveRateOverride(PlayerId(),1.0) --1.0 is default?
			SetRunSprintMultiplierForPlayer(PlayerId(),1.0)
			SetSwimMultiplierForPlayer(PlayerId(),1.0)	
			SetNightvision(false)	
			SetSeethrough(false)
			blDoNightVisionToggleState = 0
			blDoNightVisionToggleStates = 0
			blDoNightVision = false			
		
		end
	
	end		
	
	
	
	--initialize the toggle states for the mission
	blDoNightVision = false
	blDoNightVisionToggleState = 0
	blDoNightVisionToggleStates = 0
	if getMissionConfigProperty(MissionName, "EnableNightVision")  then
		blDoNightVisionToggleStates = blDoNightVisionToggleStates + 1 
		
		if getMissionConfigProperty(MissionName, "DoHelpScreens") then 
			Notify("~g~Night Vision~b~ Enabled for Mission")
		end
	end
	if getMissionConfigProperty(MissionName, "EnableThermalVision") then 
		blDoNightVisionToggleStates = blDoNightVisionToggleStates + 1
		
		if getMissionConfigProperty(MissionName, "DoHelpScreens") then 
			Notify("~r~Thermal Vision~b~ Enabled for Mission")
		end 
	end
	
	if blDoNightVisionToggleStates > 0 then 
	
		if getMissionConfigProperty(MissionName, "DoHelpScreens") then 
			Notify("~b~Press and hold left stick down & right stick down together or C & LCTRL together to toggle modes")
		end
	end
			
--print("mission1blips:"..DecorGetInt(GetPlayerPed(-1),"mrpoptin_teleportcheck",1))
	if Config.EnableOptIn and DecorGetInt(GetPlayerPed(-1),"mrpoptout") == 1  then 
		--print("mission2blips:"..DecorGetInt(GetPlayerPed(-1),"mrpoptout"))
		--Notify("Mission: ~r~"..Config.Missions[MissionName].MissionTitle.."~g~")
		
		--Notify("~b~Press '~o~Q~b~' and '~o~]~b~' or ~o~RB + DPAD UP~b~ to join the mission")
		
		--return
	--elseif Config.EnableOptIn then
		--Notify("~g~You can leave the mission anytime with ~o~'Q' and '[' ~g~keys or ~o~RB + DPAD DOWN")
	end
	
	if Config.EnableSafeHouseOptIn and DecorGetInt(GetPlayerPed(-1),"mrpoptout") == 1 then 
		--print("mission2blips:"..DecorGetInt(GetPlayerPed(-1),"mrpoptout"))
		--Notify("Mission: ~r~"..Config.Missions[MissionName].MissionTitle.."~g~")
		
		--Notify("~b~Go to the mission's safehouse and then press '~o~]~b~' key or ~o~DPAD UP~b~ to join the mission")
		--return
	--elseif Config.EnableSafeHouseOptIn then
		--Notify("~g~You can leave the mission anytime with ~o~'Q' and '[' ~g~keys or ~o~RB + DPAD DOWN")
	end
	
	if(blNewMissionFlag)then
		--print("blNewMissionFlag true")
		MilliSecondsLeft =  getMissionLength(MissionName)*60*1000
		MissionStartTime = GetGameTimer() 
		MissionEndTime = MissionStartTime + MilliSecondsLeft	
		MissionNoTimeout = getMissionConfigProperty(MissionName, "MissionNoTimeout")
	--else
		--print("blNewMissionFlag false")
	end 
	

	
	
	if Config.Missions[input].IsRandom then
		Config.Missions[input].Type = rMissionType

		--random spawn anywhere missions
		if(getMissionConfigProperty(MissionName, "IsRandomSpawnAnywhere")) then 

				Config.Missions[input].Blip.Position.x = rIsRandomSpawnAnywhereInfo[1].x
				Config.Missions[input].Blip.Position.y = rIsRandomSpawnAnywhereInfo[1].y
				Config.Missions[input].Blip.Position.z = rIsRandomSpawnAnywhereInfo[1].z
				Config.Missions[input].Marker.Position.x = rIsRandomSpawnAnywhereInfo[1].x
				Config.Missions[input].Marker.Position.y = rIsRandomSpawnAnywhereInfo[1].y
				Config.Missions[input].Marker.Position.z = rIsRandomSpawnAnywhereInfo[1].z - 1		
				
				--print("blip position:"..Config.Missions[input].Blip.Position.x..", "..Config.Missions[input].Blip.Position.y..", "..Config.Missions[input].Blip.Position.z)
			
			 
			--give support for a Safehouse blip for random anywhere locations if the Mission and mission location supports it
			--use a random RandomMissionPositions BlipS for this
			--these means they all need to be populated with BlipS OR generate a random safehouse, OR have one in the center of the map
			--OR random safehouse location array?
			if getMissionConfigProperty(input, "UseSafeHouse") and getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].BlipS and Config.Missions[input].BlipS then
				Config.Missions[input].BlipS.Position.x = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].BlipS.Position.x
				Config.Missions[input].BlipS.Position.y = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].BlipS.Position.y
				Config.Missions[input].BlipS.Position.z = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].BlipS.Position.z
				Config.Missions[input].BlipS.Icon = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].BlipS.Icon
				Config.Missions[input].BlipS.Display = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].BlipS.Display
				Config.Missions[input].BlipS.Size = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].BlipS.Size
				Config.Missions[input].BlipS.Color = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].BlipS.Color	
				Config.Missions[input].BlipS.Title = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].BlipS.Title
				Config.Missions[input].BlipS.Alpha = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].BlipS.Alpha
				--btitle2 = Config.Missions[input].BlipS.Title			
			end										
				
					
		
		else 
		
		--allow custom blips each random location
			if getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].Blip then
				Config.Missions[input].Blip.Position.x = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].Blip.Position.x
				Config.Missions[input].Blip.Position.y = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].Blip.Position.y
				Config.Missions[input].Blip.Position.z = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].Blip.Position.z
				Config.Missions[input].Blip.Icon = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].Blip.Icon
				Config.Missions[input].Blip.Display = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].Blip.Display
				Config.Missions[input].Blip.Size = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].Blip.Size
				Config.Missions[input].Blip.Color = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].Blip.Color	
				Config.Missions[input].Blip.Title = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].Blip.Title
				Config.Missions[input].Blip.Alpha = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].Blip.Alpha
				--btitle = Config.Missions[input].Blip.Title			
			else
				--this is a random mission so set blip and marker values per random mission called
				Config.Missions[input].Blip.Position.x = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].x
				Config.Missions[input].Blip.Position.y = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].y
				Config.Missions[input].Blip.Position.z = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].z
			
			end
			
			
			--give support for a Blip2 for random locations if the Mission and mission location supports it. Like IsDefend = true missions
			if getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].Blip2 and Config.Missions[input].Blip2 then
			
				Config.Missions[input].Blip2.Position.x = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].Blip2.Position.x
				Config.Missions[input].Blip2.Position.y = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].Blip2.Position.y
				Config.Missions[input].Blip2.Position.z = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].Blip2.Position.z
				Config.Missions[input].Blip2.Icon = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].Blip2.Icon
				Config.Missions[input].Blip2.Display = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].Blip2.Display
				Config.Missions[input].Blip2.Size = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].Blip2.Size
				Config.Missions[input].Blip2.Color = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].Blip2.Color	
				Config.Missions[input].Blip2.Title = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].Blip2.Title
				Config.Missions[input].Blip2.Alpha = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].Blip2.Alpha
				--btitle2 = Config.Missions[input].Blip2.Title			
			end	
			
			
			if Config.Missions[input].MissionTriggerStartPoint and getMissionConfigProperty(input,"MissionTriggerRadius") and  
				getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].MissionTriggerStartPoint
				then
					Config.Missions[input].MissionTriggerStartPoint = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].MissionTriggerStartPoint
				if getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].MissionTriggerRadius
					then					
						Config.Missions[input].MissionTriggerRadius=getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].MissionTriggerRadius
				end
		
			end


			
			--allow custom markers each random location
			if getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].Marker then

				Config.Missions[input].Marker.Position.x = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].Marker.Position.x
				Config.Missions[input].Marker.Position.y = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].Marker.Position.y
				Config.Missions[input].Marker.Position.z = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].Marker.Position.z - 1 --Markers seem to need to come down by 1 unit from the z coordinate to be on the ground, same with props			
				Config.Missions[input].Marker.Type = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].Marker.Type
				Config.Missions[input].Marker.DrawDistance = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].Marker.DrawDistance 
				
				Config.Missions[input].Marker.Size.x = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].Marker.Size.x
				Config.Missions[input].Marker.Size.y = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].Marker.Size.y
				Config.Missions[input].Marker.Size.z = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].Marker.Size.z 

				Config.Missions[input].Marker.Color.r = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].Marker.Color.r
				Config.Missions[input].Marker.Color.g = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].Marker.Color.g
				Config.Missions[input].Marker.Color.b = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].Marker.Color.b 
			else
					--this is a random mission so set blip and marker values per random mission called
				Config.Missions[input].Marker.Position.x = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].x
				Config.Missions[input].Marker.Position.y = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].y
				Config.Missions[input].Marker.Position.z = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].z - 1 --Markers seem to need to come down by 1 unit from the z coordinate to be on the ground, same with props
			
				
			end
			
			
			--give support for a Safehouse blip for random locations if the Mission and mission location supports it
			if getMissionConfigProperty(input, "UseSafeHouse") and getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].BlipS and Config.Missions[input].BlipS then
				Config.Missions[input].BlipS.Position.x = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].BlipS.Position.x
				Config.Missions[input].BlipS.Position.y = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].BlipS.Position.y
				Config.Missions[input].BlipS.Position.z = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].BlipS.Position.z
				Config.Missions[input].BlipS.Icon = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].BlipS.Icon
				Config.Missions[input].BlipS.Display = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].BlipS.Display
				Config.Missions[input].BlipS.Size = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].BlipS.Size
				Config.Missions[input].BlipS.Color = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].BlipS.Color	
				Config.Missions[input].BlipS.Title = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].BlipS.Title
				Config.Missions[input].BlipS.Alpha = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].BlipS.Alpha
			end

			--give support for a Safehouse vehicle land and sea blips for random locations if the Mission and mission location supports it
			if getMissionConfigProperty(input, "UseSafeHouse") and getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].BlipSL and Config.Missions[input].BlipSL then
				Config.Missions[input].BlipSL.Position.x = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].BlipSL.Position.x
				Config.Missions[input].BlipSL.Position.y = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].BlipSL.Position.y
				Config.Missions[input].BlipSL.Position.z = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].BlipSL.Position.z
				Config.Missions[input].BlipSL.Icon = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].BlipSL.Icon
				Config.Missions[input].BlipSL.Display = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].BlipSL.Display
				Config.Missions[input].BlipSL.Size = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].BlipSL.Size
				Config.Missions[input].BlipSL.Color = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].BlipSL.Color	
				Config.Missions[input].BlipSL.Title = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].BlipSL.Title
				Config.Missions[input].BlipSL.Alpha = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].BlipSL.Alpha
			end

			--give support for a Safehouse vehicle land and sea blips for random locations if the Mission and mission location supports it
			if getMissionConfigProperty(input, "UseSafeHouse") and getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].BlipS and Config.Missions[input].BlipSB then
				Config.Missions[input].BlipSB.Position.x = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].BlipSB.Position.x
				Config.Missions[input].BlipSB.Position.y = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].BlipSB.Position.y
				Config.Missions[input].BlipSB.Position.z = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].BlipSB.Position.z
				Config.Missions[input].BlipSB.Icon = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].BlipSB.Icon
				Config.Missions[input].BlipSB.Display = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].BlipSB.Display
				Config.Missions[input].BlipSB.Size = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].BlipSB.Size
				Config.Missions[input].BlipSB.Color = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].BlipSB.Color	
				Config.Missions[input].BlipSB.Title = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].BlipSB.Title
				Config.Missions[input].BlipSB.Alpha = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].BlipSB.Alpha
			end							
			

			--allow custom safehouse markers each random location
			if getMissionConfigProperty(input, "UseSafeHouse") and getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].MarkerS then
			--print('FOUND MISSION SAFEHOUSE MARKER')
				Config.Missions[input].MarkerS.Position.x = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].MarkerS.Position.x
				Config.Missions[input].MarkerS.Position.y = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].MarkerS.Position.y
				Config.Missions[input].MarkerS.Position.z = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].MarkerS.Position.z - 1 --Markers seem to need to come down by 1 unit from the z coordinate to be on the ground, same with props			
				Config.Missions[input].MarkerS.Type = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].MarkerS.Type
				Config.Missions[input].MarkerS.DrawDistance = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].MarkerS.DrawDistance 
				
				Config.Missions[input].MarkerS.Size.x = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].MarkerS.Size.x
				Config.Missions[input].MarkerS.Size.y = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].MarkerS.Size.y
				Config.Missions[input].MarkerS.Size.z = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].MarkerS.Size.z 

				Config.Missions[input].MarkerS.Color.r = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].MarkerS.Color.r
				Config.Missions[input].MarkerS.Color.g = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].MarkerS.Color.g
				Config.Missions[input].MarkerS.Color.b = getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex].MarkerS.Color.b 
			end			
			
		end
		
			--for IsRandom=true
			--For Below:
			--set to true to use Config.SafeHouseLocations
			--overrides normal mission and IsRandom
			--location BlipS and MarkerS.
	
			if getMissionConfigProperty(input, "UseSafeHouse") and getMissionConfigProperty(input, "UseSafeHouseLocations") then
			
			

				--print("rSafeHouseLocationIndex:"..rSafeHouseLocationIndex)
				local randomSafeHousePosition = getMissionConfigProperty(input, "SafeHouseLocations")[rSafeHouseLocationIndex]
				Config.Missions[input].MarkerS.Position.x = randomSafeHousePosition.MarkerS.Position.x
				Config.Missions[input].MarkerS.Position.y = randomSafeHousePosition.MarkerS.Position.y
				Config.Missions[input].MarkerS.Position.z = randomSafeHousePosition.MarkerS.Position.z - 1 --Markers seem to need to come down by 1 unit from the z coordinate to be on the ground, same with props			
				Config.Missions[input].MarkerS.Type = randomSafeHousePosition.MarkerS.Type
				Config.Missions[input].MarkerS.DrawDistance = randomSafeHousePosition.MarkerS.DrawDistance 
						
				Config.Missions[input].MarkerS.Size.x = randomSafeHousePosition.MarkerS.Size.x
				Config.Missions[input].MarkerS.Size.y = randomSafeHousePosition.MarkerS.Size.y
				Config.Missions[input].MarkerS.Size.z = randomSafeHousePosition.MarkerS.Size.z 

				Config.Missions[input].MarkerS.Color.r = randomSafeHousePosition.MarkerS.Color.r
				Config.Missions[input].MarkerS.Color.g = randomSafeHousePosition.MarkerS.Color.g
				Config.Missions[input].MarkerS.Color.b = randomSafeHousePosition.MarkerS.Color.b 	

				Config.Missions[input].BlipS.Position.x = randomSafeHousePosition.BlipS.Position.x
				Config.Missions[input].BlipS.Position.y = randomSafeHousePosition.BlipS.Position.y
				Config.Missions[input].BlipS.Position.z = randomSafeHousePosition.BlipS.Position.z
				Config.Missions[input].BlipS.Icon = randomSafeHousePosition.BlipS.Icon
				Config.Missions[input].BlipS.Display = randomSafeHousePosition.BlipS.Display
				Config.Missions[input].BlipS.Size = randomSafeHousePosition.BlipS.Size
				Config.Missions[input].BlipS.Color = randomSafeHousePosition.BlipS.Color	
				Config.Missions[input].BlipS.Title = randomSafeHousePosition.BlipS.Title
				Config.Missions[input].BlipS.Alpha = randomSafeHousePosition.BlipS.Alpha
				
				
				Config.Missions[input].BlipSL.Position.x = randomSafeHousePosition.BlipSL.Position.x
				Config.Missions[input].BlipSL.Position.y = randomSafeHousePosition.BlipSL.Position.y
				Config.Missions[input].BlipSL.Position.z = randomSafeHousePosition.BlipSL.Position.z
				Config.Missions[input].BlipSL.Icon = randomSafeHousePosition.BlipSL.Icon
				Config.Missions[input].BlipSL.Display = randomSafeHousePosition.BlipSL.Display
				Config.Missions[input].BlipSL.Size = randomSafeHousePosition.BlipSL.Size
				Config.Missions[input].BlipSL.Color = randomSafeHousePosition.BlipSL.Color	
				Config.Missions[input].BlipSL.Title = randomSafeHousePosition.BlipSL.Title
				Config.Missions[input].BlipSL.Alpha = randomSafeHousePosition.BlipSL.Alpha
				
				
				Config.Missions[input].BlipSB.Position.x = randomSafeHousePosition.BlipSB.Position.x
				Config.Missions[input].BlipSB.Position.y = randomSafeHousePosition.BlipSB.Position.y
				Config.Missions[input].BlipSB.Position.z = randomSafeHousePosition.BlipSB.Position.z
				Config.Missions[input].BlipSB.Icon = randomSafeHousePosition.BlipSB.Icon
				Config.Missions[input].BlipSB.Display = randomSafeHousePosition.BlipSB.Display
				Config.Missions[input].BlipSB.Size = randomSafeHousePosition.BlipSB.Size
				Config.Missions[input].BlipSB.Color = randomSafeHousePosition.BlipSB.Color	
				Config.Missions[input].BlipSB.Title = randomSafeHousePosition.BlipSB.Title
				Config.Missions[input].BlipSB.Alpha = randomSafeHousePosition.BlipSB.Alpha

						
			end		
		
			SetRandomMissionAttributes(input,rMissionType, getMissionConfigProperty(input, "RandomMissionPositions")[rMissionLocationIndex],rIsRandomSpawnAnywhereInfo) 		

		
	end 
	
	
	--local blip
	--local btitle = Config.Missions[input].Blip.Title
	if Config.Missions[input].IsDefend and Config.Missions[input].Blip2 then --and Config.Missions[input].Type == "Assassinate" then

		if(Config.Missions[input].IsDefendTarget) then
			
			blip = AddBlipForCoord(Config.Missions[input].Blip2.Position.x, Config.Missions[input].Blip2.Position.y, Config.Missions[input].Blip2.Position.z)
			SetBlipSprite (blip, Config.Missions[input].Blip2.Icon)
			SetBlipDisplay(blip, Config.Missions[input].Blip2.Display)
			SetBlipScale  (blip, Config.Missions[input].Blip2.Size)
			SetBlipColour (blip, Config.Missions[input].Blip2.Color)
			SetBlipAsShortRange(blip, false)
			local btitle = Config.Missions[input].Blip2.Title
			BeginTextCommandSetBlipName("STRING")
			
			---if tostring(getObjectiveReward(input)) ~= "N/A" then 
				AddTextComponentString(btitle)
			--else 
			--	AddTextComponentString(btitle)
			--end
			EndTextCommandSetBlipName(blip)				
		
		else
			--print("FOUND BLIP2 ISDEFEND RADIUS")
			-- IsDefend Zone 
			blip = AddBlipForRadius(Config.Missions[input].Marker.Position.x, Config.Missions[input].Marker.Position.y, Config.Missions[input].Marker.Position.z,Config.Missions[MissionName].Marker.Size.x / 2)
			
			SetBlipColour (blip, Config.Missions[input].Blip2.Color)
			SetBlipAlpha(blip,80)
			local btitle = Config.Missions[input].Blip2.Title
			BeginTextCommandSetBlipName("STRING")
			
			if tostring(getObjectiveReward(input)) ~= "N/A" then 
				AddTextComponentString(btitle.." ($"..getObjectiveReward(input)..")")
			else 
				AddTextComponentString(btitle)
			end
			EndTextCommandSetBlipName(blip)	
		end

		
		--print("WHOLE CIRCLE BLIP")
		
		table.insert(Blips, blip)
		
	elseif (not Config.Missions[input].IsDefend) and Config.Missions[input].Blip2 then
		--if(Config.Missions[input].HostileZoneRadius and  Config.Missions[input].HostileZoneRadius > 0) then 
			--print("hostilezone radius")
		--	blip = AddBlipForRadius(Config.Missions[input].Marker.Position.x, Config.Missions[input].Marker.Position.y, Config.Missions[input].Marker.Position.z,Config.Missions[MissionName].HostileZoneRadius*2 / 2)
			
		--	SetBlipColour (blip, Config.Missions[input].Blip2.Color)
		--	SetBlipAlpha(blip,80)
		--	local btitle = Config.Missions[input].Blip2.Title
		--	BeginTextCommandSetBlipName("STRING")
			
		--	if tostring(getObjectiveReward(input)) ~= "N/A" then 
		--		AddTextComponentString(btitle.." ($"..getObjectiveReward(input)..")")
		--	else 
		--		AddTextComponentString(btitle)
		--	end
		--	EndTextCommandSetBlipName(blip)			
		
		--else 
			blip = AddBlipForCoord(Config.Missions[input].Blip2.Position.x, Config.Missions[input].Blip2.Position.y, Config.Missions[input].Blip2.Position.z)
			SetBlipSprite (blip, Config.Missions[input].Blip2.Icon)
			SetBlipDisplay(blip, Config.Missions[input].Blip2.Display)
			SetBlipScale  (blip, Config.Missions[input].Blip2.Size)
			SetBlipColour (blip, Config.Missions[input].Blip2.Color)
			SetBlipAsShortRange(blip, false)
			local btitle = Config.Missions[input].Blip2.Title
			BeginTextCommandSetBlipName("STRING")
			
			---if tostring(getObjectiveReward(input)) ~= "N/A" then 
				AddTextComponentString(btitle)
			--else 
			--	AddTextComponentString(btitle)
			--end
			EndTextCommandSetBlipName(blip)	

		--end
	
		 table.insert(Blips, blip)
	

	
	end
	




	if Config.Missions[input].Blip then
			
		if Config.Missions[input].IsDefendTarget and Config.Missions[input].IsVehicleDefendTargetGotoGoal
		and getMissionConfigProperty(input,"IsRandom") then 

			--for IsRandom & IsDefendTarget and IsVehicleDefendTargetGotoGoal random destinations
			--determine where the Config.Missions[input].Blip should be, its an intercept.
			if Config.Missions[input].IsDefendTarget and Config.Missions[input].IsVehicleDefendTargetGotoGoal
			and getMissionConfigProperty(input,"IsRandom") then 
				--print("made it dest")
				local randomlocation = Config.Missions[input].RandomMissionPositions[1].Blip2.Position
				--print("made it dest"..randomlocation.x)
				MissionIsDefendTargetGoalDestIndex = setBestRandomDestination(randomlocation,input,rMissionDestinationIndex,MissionIsDefendTargetGoalDestIndex)
					
			end		
		
		

		else 
			
			blip = AddBlipForCoord(Config.Missions[input].Blip.Position.x, Config.Missions[input].Blip.Position.y, Config.Missions[input].Blip.Position.z)
			SetBlipSprite (blip, Config.Missions[input].Blip.Icon)
			SetBlipDisplay(blip, Config.Missions[input].Blip.Display)
			SetBlipScale  (blip, Config.Missions[input].Blip.Size)
			SetBlipColour (blip, Config.Missions[input].Blip.Color)
			SetBlipAsShortRange(blip, false)
			
			--override "Objective" default text when IsBountyHunt random mission
			--if getMissionConfigProperty(input, "IsBountyHunt") then
				--Config.Missions[input].Blip.Title = getMissionConfigProperty(input, "MissionTitle")
			--end
			
			local btitle = Config.Missions[input].Blip.Title
			BeginTextCommandSetBlipName("STRING")
			
			if tostring(getObjectiveReward(input)) ~= "N/A" then 
				AddTextComponentString(btitle.." ($"..getObjectiveReward(input)..")")
			else 
				AddTextComponentString(btitle)
			end
			EndTextCommandSetBlipName(blip)	
	
			table.insert(Blips, blip)
			
		end	
			
			
	end
	
	--allow for multiple blips as well
	if Config.Missions[input].Blips then 
		local mBlips = Config.Missions[input].Blips
		for i, v in pairs(mBlips) do
			blip = AddBlipForCoord(mBlips[i].Position.x, mBlips[i].Position.y, mBlips[i].Position.z)
			SetBlipSprite (blip,mBlips[i].Icon)
			SetBlipDisplay(blip,mBlips[i].Display)
			SetBlipScale  (blip,mBlips[i].Size)
			SetBlipColour (blip,mBlips[i].Color)
			SetBlipAsShortRange(blip, false)
			local btitle = mBlips[i].Title
			BeginTextCommandSetBlipName("STRING")
			
			if tostring(getObjectiveReward(input)) ~= "N/A" then 
				AddTextComponentString(btitle.." ($"..getObjectiveReward(input)..")")
			else 
				AddTextComponentString(btitle)
			end
			EndTextCommandSetBlipName(blip)	
	
			table.insert(Blips, blip)
				
		end
	

	end
	
	
	if getMissionConfigProperty(input, "UseSafeHouse") and Config.Missions[input].BlipS then 
	
		blip = AddBlipForCoord(Config.Missions[input].BlipS.Position.x, Config.Missions[input].BlipS.Position.y, Config.Missions[input].BlipS.Position.z)
		SetBlipSprite (blip, Config.Missions[input].BlipS.Icon)
		SetBlipDisplay(blip, Config.Missions[input].BlipS.Display)
		SetBlipScale  (blip, Config.Missions[input].BlipS.Size)
		SetBlipColour (blip, Config.Missions[input].BlipS.Color)
		SetBlipAsShortRange(blip, false)
		local btitle = Config.Missions[input].BlipS.Title
		BeginTextCommandSetBlipName("STRING")
		
		--if tostring(getObjectiveReward(input)) ~= "N/A" then 
		local shbliptitle = btitle.. " ($-"..getMissionConfigProperty(MissionName, "SafeHouseCost")..")" 
		if getMissionConfigProperty(MissionName, "MissionRejuvenationFee") > 0 then 
				shbliptitle = shbliptitle ..", Respawn: ($-"..getMissionConfigProperty(MissionName, "MissionRejuvenationFee")..")" 
		end
	 
			AddTextComponentString(shbliptitle)
		--else 
			--AddTextComponentString(btitle)
		--end
		EndTextCommandSetBlipName(blip)		
	
		 table.insert(Blips, blip)
		 SafeHouseBlip = blip
	end
	
	
	if getMissionConfigProperty(input, "UseSafeHouse") and Config.Missions[input].BlipSL then 
	
		blip = AddBlipForCoord(Config.Missions[input].BlipSL.Position.x, Config.Missions[input].BlipSL.Position.y, Config.Missions[input].BlipSL.Position.z)
		SetBlipSprite (blip, Config.Missions[input].BlipSL.Icon)
		SetBlipDisplay(blip, Config.Missions[input].BlipSL.Display)
		SetBlipScale  (blip, Config.Missions[input].BlipSL.Size)
		SetBlipColour (blip, Config.Missions[input].BlipSL.Color)
		SetBlipAsShortRange(blip, false)
		local btitle = Config.Missions[input].BlipSL.Title
		BeginTextCommandSetBlipName("STRING")
		
		--if tostring(getObjectiveReward(input)) ~= "N/A" then 
			AddTextComponentString(btitle.. " ($-"..getMissionConfigProperty(MissionName, "SafeHouseCostVehicle")..")")
		--else 
			--AddTextComponentString(btitle)
		--end
		EndTextCommandSetBlipName(blip)		
	
		 table.insert(Blips, blip)
		 SafeHouseBlip = blip
	end
	
	
	if getMissionConfigProperty(input, "UseSafeHouse") and Config.Missions[input].BlipSB then 
	
		blip = AddBlipForCoord(Config.Missions[input].BlipSB.Position.x, Config.Missions[input].BlipSB.Position.y, Config.Missions[input].BlipSB.Position.z)
		SetBlipSprite (blip, Config.Missions[input].BlipSB.Icon)
		SetBlipDisplay(blip, Config.Missions[input].BlipSB.Display)
		SetBlipScale  (blip, Config.Missions[input].BlipSB.Size)
		SetBlipColour (blip, Config.Missions[input].BlipSB.Color)
		SetBlipAsShortRange(blip, false)
		local btitle = Config.Missions[input].BlipSB.Title
		BeginTextCommandSetBlipName("STRING")
		
		--if tostring(getObjectiveReward(input)) ~= "N/A" then 
			AddTextComponentString(btitle.. " ($-"..getMissionConfigProperty(MissionName, "SafeHouseCostVehicle")..")")
		--else 
			--AddTextComponentString(btitle)
		--end
		EndTextCommandSetBlipName(blip)		
	
		 table.insert(Blips, blip)
		 SafeHouseBlip = blip
	end
	
	
	--set mission start blip here. Hardcoded to 'M' and green color
	if getMissionConfigProperty(input,"MissionTriggerStartPoint") and getMissionConfigProperty(input,"MissionTriggerRadius") then
			
			blip = AddBlipForCoord(getMissionConfigProperty(input,"MissionTriggerStartPoint").x, getMissionConfigProperty(input,"MissionTriggerStartPoint").y, getMissionConfigProperty(input,"MissionTriggerStartPoint").z)
			SetBlipSprite (blip, 78) --'M'
			SetBlipDisplay(blip, 4)
			SetBlipScale  (blip, 1.2)
			SetBlipColour (blip,69)
			SetBlipAsShortRange(blip, false)
			

			
			local btitle = "Mission Start"
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(btitle)
			EndTextCommandSetBlipName(blip)	
	
			table.insert(Blips, blip)		
		
	end	
	
	--set the Marker to be where the IsDefendTargetRewardBlip is and make the size the goal radius
	if Config.Missions[input].IsDefendTarget and Config.Missions[input].IsDefendTargetRewardBlip and Config.Missions[input].Marker then 
		--[[
		Config.Missions[input].Marker.Position.x = Config.Missions[input].Blip.Position.x
		Config.Missions[input].Marker.Position.y = Config.Missions[input].Blip.Position.y
		Config.Missions[input].Marker.Position.z = Config.Missions[input].Blip.Position.z
		
		Config.Missions[input].Marker.Size.x =  getMissionConfigProperty(input,"IsDefendTargetGoalDistance")
		Config.Missions[input].Marker.Size.y =  getMissionConfigProperty(input,"IsDefendTargetGoalDistance")
		Config.Missions[input].Marker.Size.z =  getMissionConfigProperty(input,"IsDefendTargetGoalDistance")
		]]--
		
		--these are done in findBestSafeHouseLocation called for Blip above:
		if not (Config.Missions[input].IsVehicleDefendTargetGotoGoal
		and getMissionConfigProperty(input,"IsRandom"))  then 
		
			Config.Missions[input].Marker.Position.x = Config.Missions[input].Blip.Position.x
			Config.Missions[input].Marker.Position.y = Config.Missions[input].Blip.Position.y
			Config.Missions[input].Marker.Position.z = Config.Missions[input].Blip.Position.z
			
			Config.Missions[input].Marker.Size.x =  getMissionConfigProperty(input,"IsDefendTargetGoalDistance")
			Config.Missions[input].Marker.Size.y =  getMissionConfigProperty(input,"IsDefendTargetGoalDistance")
			Config.Missions[input].Marker.Size.z =  getMissionConfigProperty(input,"IsDefendTargetGoalDistance")	
		
	

		end
		
	end
	
	
	TriggerEvent("mt:missiontext", input, 10000)
	--***********
	SpawnMissionPickups(input)
	
	--blNewMissionFlag means that this is client who just joined during an active mission
	--or is the only one on the server and just started a new mission.

	if DecorGetInt(GetPlayerPed(-1),"mrpoptout") == 0 then 
		if(not blNewMissionFlag) then
			
			DoingMissionTeleport = true
			doTeleportToSafeHouse(false)	
			DoingMissionTeleport = false
			
		elseif getMissionConfigProperty(input, "TeleportToSafeHouseOnMissionStart") then 
			Wait(getMissionConfigProperty(MissionName, "TeleportToSafeHouseOnMissionStartDelay"))
			DoingMissionTeleport = true
			doTeleportToSafeHouse(false)	
			DoingMissionTeleport =false
			
		end
	end 
	
	if MissionName ~="N/A" and Active == 1 and DecorGetInt(GetPlayerPed(-1),"mrpoptout") == 0 then
		
		if getMissionConfigProperty(MissionName, "DoHelpScreens") then 
		
			if(getMissionConfigProperty(MissionName, "UseSafeHouse")) then 
				Notify("~b~Use safe houses to get upgrades and supplies. Cost~c~: $"..getMissionConfigProperty(MissionName, "SafeHouseCost"))
			end
			if(getMissionConfigProperty(MissionName, "UseSafeHouseCrateDrop")) then 
				Notify("~b~You can also get upgrades and supplies dropped to you with safe house air drops")
				Notify("~b~Press gamepad RB + DPAD LEFT together or Q & SCROLLWHEEL UP together to get them dropped. Cost~c~: $"..getMissionConfigProperty(MissionName, "SafeHouseCostCrate"))
			end
			if(getMissionConfigProperty(MissionName, "UseSafeHouseBanditoDrop")) then 
				Notify("~b~You can also deploy and use a number of rc detonate bombs, like drones")
				Notify("~b~Press gamepad RB & DPAD RIGHT together or A & D together to deploy. Cost~c~: $"..getMissionConfigProperty(MissionName, "SafeHouseCostCrate"))
			end
		end 
		--Notify("~h~~b~Check your map for mission data.~n~Hold DPAD DOWN or '[' key to view mission information.")
	end 
end)


--For Random isDefendtarget Missions with a rewardblip (destination)
--dont want the destination too close either
function setBestRandomDestination(randomlocation,input,currentfound)
	--print("currentfound:"..tostring(currentfound))
	local closestindex = currentfound
	local current = 0.0
	
	
	if currentfound and not MissionIsDefendTargetGoalDestIndex then 
		--print("made find dest")
		Config.Missions[input].RandomMissionPositions[1].x = getMissionConfigProperty(input,"RandomMissionDestinations")[closestindex].x
		Config.Missions[input].RandomMissionPositions[1].y = getMissionConfigProperty(input,"RandomMissionDestinations")[closestindex].y
		Config.Missions[input].RandomMissionPositions[1].z = getMissionConfigProperty(input,"RandomMissionDestinations")[closestindex].z
		
			Config.Missions[input].Marker.Position.x = getMissionConfigProperty(input,"RandomMissionDestinations")[closestindex].x
			Config.Missions[input].Marker.Position.y = getMissionConfigProperty(input,"RandomMissionDestinations")[closestindex].y
			Config.Missions[input].Marker.Position.z = getMissionConfigProperty(input,"RandomMissionDestinations")[closestindex].z  - 1.0		
	
			
			Config.Missions[input].Marker.Size.x =  getMissionConfigProperty(input,"IsDefendTargetGoalDistance")
			Config.Missions[input].Marker.Size.y =  getMissionConfigProperty(input,"IsDefendTargetGoalDistance")
			Config.Missions[input].Marker.Size.z =  getMissionConfigProperty(input,"IsDefendTargetGoalDistance")	
			
			GlobalGotoGoalX =  getMissionConfigProperty(input,"RandomMissionDestinations")[closestindex].x
			GlobalGotoGoalY =  getMissionConfigProperty(input,"RandomMissionDestinations")[closestindex].y
			GlobalGotoGoalZ =  getMissionConfigProperty(input,"RandomMissionDestinations")[closestindex].z
		
	
			local blip = AddBlipForCoord(getMissionConfigProperty(input,"RandomMissionDestinations")[closestindex].x, getMissionConfigProperty(input,"RandomMissionDestinations")[closestindex].y, getMissionConfigProperty(input,"RandomMissionDestinations")[closestindex].z)
			SetBlipSprite (blip, Config.Missions[input].Blip.Icon)
			SetBlipDisplay(blip, Config.Missions[input].Blip.Display)
			SetBlipScale  (blip, Config.Missions[input].Blip.Size)
			SetBlipColour (blip, Config.Missions[input].Blip.Color)
			SetBlipAsShortRange(blip, false)
			
			--override "Objective" default text when IsBountyHunt random mission
			if getMissionConfigProperty(input, "IsBountyHunt") then
				Config.Missions[input].Blip.Title = getMissionConfigProperty(input, "MissionTitle")
			end
			
			local btitle = Config.Missions[input].Blip.Title
			BeginTextCommandSetBlipName("STRING")
			
			if tostring(getObjectiveReward(input)) ~= "N/A" then 
				AddTextComponentString(btitle.." ($"..getObjectiveReward(input)..")")
			else 
				AddTextComponentString(btitle)
			end
			EndTextCommandSetBlipName(blip)	
	
			table.insert(Blips, blip)

			MissionIsDefendTargetGoalDestIndex	= currentfound	

			return MissionIsDefendTargetGoalDestIndex
	
	end
	
	if MissionIsDefendTargetGoalDestIndex then 
		--print("wtf:"..MissionIsDefendTargetGoalDestIndex)
		
	closestindex = MissionIsDefendTargetGoalDestIndex
	--Config.Missions[input].Blip.Position = getMissionConfigProperty(input,"RandomMissionDestinations")[closestindex]
	
	--print("WTF find psot:"..Config.Missions[input].Blip.Position.x)
	--Config.Missions[input].RandomMissionPositions[1].x = getMissionConfigProperty(input,"RandomMissionDestinations")[closestindex].x
	--Config.Missions[input].RandomMissionPositions[1].y = getMissionConfigProperty(input,"RandomMissionDestinations")[closestindex].y
	--Config.Missions[input].RandomMissionPositions[1].z = getMissionConfigProperty(input,"RandomMissionDestinations")[closestindex].z
	
	--print("WTF after psot:"..Config.Missions[input].RandomMissionPositions[1].x)
		return MissionIsDefendTargetGoalDestIndex
	
	end
	
	
	--print("MISSIONNAME:"..MissionName)
	
	--[[
    for i, v in ipairs(getMissionConfigProperty(input,"RandomMissionDestinations")) do
		local coords = getMissionConfigProperty(input,"RandomMissionDestinations")[i]
		--spawn radius + 250m
		
		current  = 	GetDistanceBetweenCoords(coords.x,coords.y,coords.z, randomlocation.x,randomlocation.y,randomlocation.z, true)
		if current >  2000  and current < closest then
			--print("current:"..current)
			closest = current
			closestindex = i
			--print("made it find "..current)
			--print("made it find "..getMissionConfigProperty(input,"RandomMissionDestinations")[closestindex].x)
			
		end 
	
		
	end
	]]--
	
	--print("hey:"..tostring(MissionIsDefendTargetGoalDestIndex))
	
	closestindex = 1
	
	if not currentfound then
		--print("hey calc")
		local currentpos
		local tries = 0
		repeat
				currentpos  = math.random(1, #getMissionConfigProperty(input, "RandomMissionDestinations"))
				
				local coords = getMissionConfigProperty(input, "RandomMissionDestinations")[currentpos]
				current  = 	GetDistanceBetweenCoords(coords.x,coords.y,coords.z, randomlocation.x,randomlocation.y,randomlocation.z, true)
			tries = tries + 1
		until current >  1000 or tries > 1000 
		
		if tries > getMissionConfigProperty(input, "RandomMissionGoalDestinationMinDistance") then 
			currentpos  = math.random(1, #getMissionConfigProperty(input, "RandomMissionDestinations"))
		end
		
		closestindex = currentpos
		--print("hey cur:"..closestindex)
		--if not closestindex  then closestindex = math.random(1,#getMissionConfigProperty(input,"RandomMissionDestinations")) end	
	end 
	
	--print("curafter:"..tostring(closestindex))
	--print("closestindex:"..closestindex)
	--return closestindex
	--print("made it find pre:"..Config.Missions[input].Blip.Position.x)
	Config.Missions[input].Blip.Position = getMissionConfigProperty(input,"RandomMissionDestinations")[closestindex]
	
	--print("made it find psot:"..Config.Missions[input].Blip.Position.x)
	
	--also spawn enemies around this destination
	
	
	
	--print("closestindex:"..tostring(closestindex))
	--print("hey just before after:"..tostring(Config.Missions[input].RandomMissionPositions[1].x))
	if not currentfound then
	
		Config.Missions[input].RandomMissionPositions[1].x = getMissionConfigProperty(input,"RandomMissionDestinations")[closestindex].x
		Config.Missions[input].RandomMissionPositions[1].y = getMissionConfigProperty(input,"RandomMissionDestinations")[closestindex].y
		Config.Missions[input].RandomMissionPositions[1].z = getMissionConfigProperty(input,"RandomMissionDestinations")[closestindex].z
		
			Config.Missions[input].Marker.Position.x = getMissionConfigProperty(input,"RandomMissionDestinations")[closestindex].x
			Config.Missions[input].Marker.Position.y = getMissionConfigProperty(input,"RandomMissionDestinations")[closestindex].y
			Config.Missions[input].Marker.Position.z = getMissionConfigProperty(input,"RandomMissionDestinations")[closestindex].z  - 1.0
		
			
			Config.Missions[input].Marker.Size.x =  getMissionConfigProperty(input,"IsDefendTargetGoalDistance")
			Config.Missions[input].Marker.Size.y =  getMissionConfigProperty(input,"IsDefendTargetGoalDistance")
			Config.Missions[input].Marker.Size.z =  getMissionConfigProperty(input,"IsDefendTargetGoalDistance")	
			
			GlobalGotoGoalX =  getMissionConfigProperty(input,"RandomMissionDestinations")[closestindex].x
			GlobalGotoGoalY =  getMissionConfigProperty(input,"RandomMissionDestinations")[closestindex].y
			GlobalGotoGoalZ =  getMissionConfigProperty(input,"RandomMissionDestinations")[closestindex].z
		
	
			local blip = AddBlipForCoord(Config.Missions[input].Blip.Position.x, Config.Missions[input].Blip.Position.y, Config.Missions[input].Blip.Position.z)
			SetBlipSprite (blip, Config.Missions[input].Blip.Icon)
			SetBlipDisplay(blip, Config.Missions[input].Blip.Display)
			SetBlipScale  (blip, Config.Missions[input].Blip.Size)
			SetBlipColour (blip, Config.Missions[input].Blip.Color)
			SetBlipAsShortRange(blip, false)
			
			--override "Objective" default text when IsBountyHunt random mission
			if getMissionConfigProperty(input, "IsBountyHunt") then
				Config.Missions[input].Blip.Title = getMissionConfigProperty(input, "MissionTitle")
			end
			
			local btitle = Config.Missions[input].Blip.Title
			BeginTextCommandSetBlipName("STRING")
			
			if tostring(getObjectiveReward(input)) ~= "N/A" then 
				AddTextComponentString(btitle.." ($"..getObjectiveReward(input)..")")
			else 
				AddTextComponentString(btitle)
			end
			EndTextCommandSetBlipName(blip)	
	
			table.insert(Blips, blip)	
	
			
			MissionIsDefendTargetGoalDestIndex = closestindex 
			--print("hey after:"..tostring(MissionIsDefendTargetGoalDestIndex))
		return closestindex
	end
	
end

RegisterNetEvent('DONE')
AddEventHandler('DONE', function(input,isstop,isfail,reasontext,blGoalReached,checkpointdata)

	
		local targetPedsKilledByPlayer = 0
		local nontargetPedsKilledByPlayer = 0
		local hostagePedsKilledByPlayer = 0
		local totalDeadHostages = 0
		local rescuedHostages = 0
		local rescuedIsDefendTarget = 0
		local isDefendTargetKilledByPlayer = 0
		local vehiclePedsKilledByPlayer = 0
		local bossPedsKilledByPlayer = 0
		local rescuedObjectives = 0
		local results
		MissionDoneSMS=false
		GlobalKillTargetPed  = false
		MissionSpawnedSafeHouseProps = false
		MissionIsDefendTargetGoalDestIndex = nil
		GlobalGotoGoalX = nil
		GlobalGotoGoalY = nil
		GlobalGotoGoalZ = nil
		GlobalTargetPed=nil
		PlayingAnimL=false
		PlayingAnimD=false
		PedLeaderModel=nil
		PedDoctorModel=nil
		GlobalBackup=nil		
		
	if(not isstop) then --allow bonuses for isfail as well
		if DecorGetInt(GetPlayerPed(-1),"mrpoptout") == 0 then 
			results = calcMissionStats()
			nontargetPedsKilledByPlayer = results[1]
			targetPedsKilledByPlayer = results[2]
			hostagePedsKilledByPlayer = results[3]
			totalDeadHostages = results[6]
			vehiclePedsKilledByPlayer = results[12]
			bossPedsKilledByPlayer = results[13]
		end
		
		--get hostage rescues as well 
		if DecorGetInt(GetPlayerPed(-1),"mrprescuecount") > 0 then 
			rescuedHostages = DecorGetInt(GetPlayerPed(-1),"mrprescuecount")
		end	
		
		if DecorGetInt(GetPlayerPed(-1),"mrpobjrescuecount") > 0 then 
			rescuedObjectives = DecorGetInt(GetPlayerPed(-1),"mrpobjrescuecount")
		end	

		if DecorGetInt(GetPlayerPed(-1),"mrprescuetarget") > 0 then 
			rescuedIsDefendTarget = 1
		end	

		local GoalReached = blGoalReached
	    
		--checkpoint mission data 
		local claimedcheckpoints = DecorGetInt(GetPlayerPed(-1),"mrpcheckpointsclaimed") --0
		local claimedwin = false
		
		if (Config.Missions[input].Type=="Checkpoint") and checkpointdata and checkpointdata[#checkpointdata] and checkpointdata[#checkpointdata].PlayerServerId ==GetPlayerServerId(PlayerId()) then 
			claimedwin = true
		end
		
		
		--[[ OLDER CODE:
		if checkpointdata then 
			for i = 1,#checkpointdata do
		
				if ( checkpointdata[i] and checkpointdata[i].checkpointnum and checkpointdata[i].PlayerServerId ==GetPlayerServerId(PlayerId())) then
					claimedcheckpoints = claimedcheckpoints + 1
				end
			end
			
			if checkpointdata[#checkpointdata] and checkpointdata[#checkpointdata].PlayerServerId ==GetPlayerServerId(PlayerId()) then 
				claimedwin = true
			end
			
			--in case is nil, for the calcCompletionRewards to take all args
			if not GoalReached then 
				GoalReached = false
			end
		end
		--]]
		
		
		calcCompletionRewards(nontargetPedsKilledByPlayer,targetPedsKilledByPlayer,hostagePedsKilledByPlayer,totalDeadHostages,vehiclePedsKilledByPlayer,bossPedsKilledByPlayer,GoalReached,claimedcheckpoints,claimedwin)
		if DecorGetInt(GetPlayerPed(-1),"mrpoptout") == 0 then 
			local msg = ""
			if(targetPedsKilledByPlayer+nontargetPedsKilledByPlayer) > 0 then
				msg = "~r~Enemies Killed~c~:"..(targetPedsKilledByPlayer+nontargetPedsKilledByPlayer)
				Notify(msg)
			end
			if(vehiclePedsKilledByPlayer) > 0 then
				msg = "~p~Vehicles Taken Out~c~:"..vehiclePedsKilledByPlayer
				Notify(msg)
			end	
			if(bossPedsKilledByPlayer) > 0  then
				msg ="~q~Bosses Killed~c~:"..bossPedsKilledByPlayer
				Notify(msg)
			end			
			if(rescuedHostages) > 0 then
				msg = "~o~Hostages Rescued~c~:"..rescuedHostages
				Notify(msg)
			end
			if(rescuedObjectives) > 0 then
				msg = "~o~Objectives Captured~c~:"..rescuedObjectives
				Notify(msg)
			end		
			if(hostagePedsKilledByPlayer) > 0  then
				msg = "~r~Hostages Killed~c~:"..hostagePedsKilledByPlayer
				Notify(msg)
			end
			
			if(claimedcheckpoints) > 0  then
				msg = "~y~Claimed Checkpoints~c~:"..claimedcheckpoints
				Notify(msg)
			end
			
			if not getMissionConfigProperty(MissionName, "MissionShareMoney")  then 
				Notify("~g~Money Earned~c~: $"..playerMissionMoney)
			end

			
		end	
		
	end
	
	if(Config.Missions[input].Type=="Checkpoint") then 
		TriggerEvent('mrpStreetRaces:RemoveMissionBlip_cl')		
	end
	--[[
	if (isfail) then 
		results = calcMissionStats()
		hostagePedsKilledByPlayer = results[3]
		totalDeadHostages = results[6]
		isDefendTargetKilledByPlayer = results[11]
		calcHostageKillPenalty(hostagePedsKilledByPlayer,totalDeadHostages,isDefendTargetKilledByPlayer)
	end
	]]--
	if not isstop and DecorGetInt(GetPlayerPed(-1),"mrpoptout") == 0 then
		--for simple scoreboard for $ per mission stat
		DecorSetInt(GetPlayerPed(-1),"mrpplayermissioncount",(DecorGetInt(GetPlayerPed(-1),"mrpplayermissioncount")+1))
		mrpplayermissioncountG = DecorGetInt(GetPlayerPed(-1),"mrpplayermissioncount")
	end
	
	--print("mrpplayermissioncount:"..DecorGetInt(GetPlayerPed(-1),"mrpplayermissioncount"))
	
	if(Config.Missions[input].IsRandom) then 
		--HACK,'remove' the old up the old Marker before new mission
		--workaround for now for with the old marker blinking in
		--between random missions
		Config.Missions[input].Marker.Position.x = -10000.0
		Config.Missions[input].Marker.Position.y = -10000.0
		Config.Missions[input].Marker.Position.z = 0.0
	
	end
	
	if DecorGetInt(GetPlayerPed(-1),"mrpoptout") == 0 then
		local rewardPlayer=false
		if(not isstop and not isfail) then
			
			if (nontargetPedsKilledByPlayer > 0 or targetPedsKilledByPlayer > 0  or (Config.Missions[input].Type == "Objective" and playerSecured) or rescuedHostages > 0 or rescuedObjectives > 0) then
				--regen health and armour after reward?
				if(getMissionConfigProperty(input, "RegenHealthAndArmourOnReward")) then
					if getMissionConfigProperty(MissionName, "SafeHouseCrackDownMode") and playerUpgraded then 
						
						SetPedMaxHealth(GetPlayerPed(-1), getMissionConfigProperty(MissionName, "SafeHouseCrackDownModeHealthAmount"))
						SetEntityHealth(GetPlayerPed(-1), getMissionConfigProperty(MissionName, "SafeHouseCrackDownModeHealthAmount"))
						SetPlayerMaxArmour(GetPlayerPed(-1),100)
						AddArmourToPed(GetPlayerPed(-1), 100)
						SetPedArmour(GetPlayerPed(-1), 100)				
					else
						--DOES THIS WORK? IT DOES NOT FOR ARMOR BELOW
						SetPedMaxHealth(GetPlayerPed(-1), Config.DefaultPlayerMaxHealthAmount)
						SetEntityHealth(GetPlayerPed(-1),Config.DefaultPlayerMaxHealthAmount)
						--AddArmourToPed(GetPlayerPed(-1), GetPlayerMaxArmour(GetPlayerPed(-1)))
						--SetPedArmour(GetPlayerPed(-1), GetPlayerMaxArmour(GetPlayerPed(-1)))
						AddArmourToPed(GetPlayerPed(-1), 100)
						SetPedArmour(GetPlayerPed(-1), 100)	
					end
				end			
				
				rewardPlayer=true
			end 
			SpawnPickups(input,rewardPlayer) 
			--PlaySoundFrontend(-1, "MEDAL_UP", "HUD_MINI_GAME_SOUNDSET", 1)
			TriggerEvent('mt:EndMissionPassSound')			
			
		else 
			CleanupPickups(input,false) --cleanup mission pickups
		end	
		
		if (not isstop and isfail) then 
			--PlaySoundFrontend(-1, "LOOSE_MATCH", "HUD_MINI_GAME_SOUNDSET", 1)
			--PlaySoundFrontend(-1, "Crash", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1) 
			TriggerEvent('mt:EndMissionFailSound')			
			
		end
	
	end
	
	--remove any random events
	local REvents = Config.Missions[input].Events
	local rem_key = {}
	
	--print("REvents"..#REvents)
	for index, irevent in pairs(REvents) do
		--print(index)
          if irevent.revent or irevent.checkpoint then
                        -- Matches existing checkpoint, remove blip and checkpoint from table
			--print("r"..index)
             --table.remove(REvents, index)
			-- print("t"..index)
			 table.insert(rem_key, index)
  
          end
     end
	for i = #rem_key, 1, -1 do
		value = rem_key[i]
		table.remove(REvents, value)
	end	 
	 
	Config.Missions[input].Events = REvents
	 
	
	for ped in EnumeratePeds() do
		
		--need to remove dead prop NPCs first.
		if DecorGetInt(ped,"mrppedead") > 0 then 
			DecorRemove(ped, "mrppedead")
			DecorRemove(ped, "mrppedid")
			DecorRemove(ped, "mrppedboss")
			DecorRemove(ped, "mrppedmonster")
			DecorRemove(ped, "mrppedtarget")
			DecorRemove(ped, "mrppedsafehouse")
			DecorRemove(ped, "mrppedfriend")
			DecorRemove(ped, "mrppedconqueror")
			DecorRemove(ped, "mrppeddefendtarget")
			DecorRemove(ped, "mrprescuetarget")
			DecorRemove(ped, "mrppedkilledbyplayervehicle")
			DecorRemove(ped, "mrppedconqueror")
			DecorRemove(ped, "mrpvpedid")
			DecorRemove(ped, "mrppeddefendtarget")
			DecorRemove(ped, "mrprescuetarget")
			DecorRemove(ped, "mrppedskydiver")
			DecorRemove(ped, "mrppedskydivertarget")
			DecorRemove(ped, "mrpvehdidGround")
			
			DeleteEntity(ped)
			
			--print("del dead")
		end		
		
		
		if DecorGetInt(ped, "mrppedid") > 0  then
			local blip = GetBlipFromEntity(ped)
			
			RemoveBlip(blip)
			--SetBlockingOfNonTemporaryEvents(ped, false) 
			ClearPedTasksImmediately(ped)
			DecorRemove(ped, "mrppedid")
			DecorRemove(ped, "mrppedboss")
			DecorRemove(ped, "mrppedmonster")
			DecorRemove(ped, "mrppedtarget")
			DecorRemove(ped, "mrppedsafehouse")
			DecorRemove(ped, "mrppedfriend")
			DecorRemove(ped, "mrppedconqueror")
			DecorRemove(ped, "mrppedead")
			DecorRemove(ped, "mrppeddefendtarget")
			DecorRemove(ped, "mrprescuetarget")
			DecorRemove(ped, "mrppedkilledbyplayervehicle")
			DecorRemove(ped, "mrpvehdidGround")
			
			DeleteEntity(ped)
			
			--print("del id")
			
			
		end

		if  DecorGetInt(ped, "mrpvpedid") > 0 then
			local blip = GetBlipFromEntity(ped)
			RemoveBlip(blip)
			--SetBlockingOfNonTemporaryEvents(ped, false) 
			ClearPedTasksImmediately(ped)			
			DecorRemove(ped, "mrppedconqueror")
			DecorRemove(ped, "mrpvpedid")
			DecorRemove(ped, "mrppedead")
			DecorRemove(ped, "mrppeddefendtarget")
			DecorRemove(ped, "mrprescuetarget")
			DecorRemove(ped, "mrppedkilledbyplayervehicle")
			DecorRemove(ped, "mrpvehdidGround")
			DeleteEntity(ped)
			
			--print("del id2")
			
		end		
		

		--[[
		
		if DecorGetInt(ped,"mrppedtarget") > 0 then 
			DecorRemove(ped, "mrppedead")
			DecorRemove(ped, "mrppedid")
			DecorRemove(ped, "mrppedboss")
			DecorRemove(ped, "mrppedmonster")
			DecorRemove(ped, "mrppedtarget")
			DecorRemove(ped, "mrppedsafehouse")
			DecorRemove(ped, "mrppedfriend")
			DecorRemove(ped, "mrppedconqueror")
			DecorRemove(ped, "mrppeddefendtarget")
			DecorRemove(ped, "mrprescuetarget")
			DecorRemove(ped, "mrppedkilledbyplayervehicle")
			DecorRemove(ped, "mrppedconqueror")
			DecorRemove(ped, "mrpvpedid")
			DecorRemove(ped, "mrppeddefendtarget")
			DecorRemove(ped, "mrprescuetarget")
			DecorRemove(ped, "mrppedskydiver")
			DecorRemove(ped, "mrppedskydivertarget")
			DeleteEntity(ped)
			
			--print("del target")
		end		
		
		]]--


	end	

	
	for veh in EnumerateVehicles() do

		if DecorGetInt(veh, "mrpvehdid") > 0 then
			
			--not using these vehicle blips anymore
			local blip = GetBlipFromEntity(veh)
			RemoveBlip(blip)
			
			DecorRemove(veh, "mrpvehsafehouseowner")
			DecorRemove(veh, "mrpvehsafehouse")
			--we cant delete vehicles that the player is in
			--since they could be in the air or far out to sea
			if (veh ~= GetVehiclePedIsIn(GetPlayerPed(-1), false)) and not IsEntityAtEntity( veh, GetPlayerPed(-1), 1.0, 1.0, 2.0, 0, 1, 0) then
				DeleteEntity(veh)
			
				DecorRemove(veh, "mrpvehdid")
				DecorRemove(veh, "mrpvehdidGround")
			--else
				
			end 
			
			--print("del veh")
		end

	end	
	
	for obj in EnumerateObjects() do

		if DecorGetInt(obj, "mrppropid") > 0 then
			DecorRemove(obj, "mrppropid")
			DecorRemove(obj, "mrpsafehousepropid")
			DecorRemove(obj, "mrpproprescue")
			DecorRemove(obj, "mrppropobj")
			DeleteObject(obj)	
		end
	end		
	
	--[[
    for i=1, #Config.Missions[input].Peds do
        local ped  = Config.Missions[input].Peds[i].id
        local blip = GetBlipFromEntity(ped)
        RemoveBlip(blip)
        DeleteEntity(Config.Missions[input].Peds[i].id)
    end
    for i=1, #Config.Missions[input].Vehicles do
        local veh  = Config.Missions[input].Vehicles[i].id
        local ped  = Config.Missions[input].Vehicles[i].id2
        --local blip = GetBlipFromEntity(veh)
		local blip = GetBlipFromEntity(ped)
        RemoveBlip(blip)
        DeleteEntity(ped)
        DeleteEntity(veh)
    end
	
	]]--
	
	
	--player can be out in the water with boat missions so see if they
	--are in water and if so teleport back to the safe house
	--since their boat will be deleted.
	--[[if getMissionConfigProperty(MissionName, "UseSafeHouse") then 
		local coords = GetEntityCoords(GetPlayerPed(-1))
		local watertest = GetWaterHeight(coords.x,coords.y,coords.z)
		if watertest  == 1 or watertest  == true then 
			--water mission
			--print("water mission at:") 
			--print(randomplace.x..","..randomplace.y..","..randomplace.z)
			
				doBoatMission = true
		else
			--print("land mission at:") 
			--print(randomplace.x..","..randomplace.y..","..randomplace.z)	
	
		end 
	end
	]]--
		
	--print('DONE CALLED playerMissionMoney is:'..playerMissionMoney)
    for i, blip in pairs(Blips) do
		RemoveBlip(blip)
    end
	
	if(not isstop) and DecorGetInt(GetPlayerPed(-1),"mrpoptout") == 0 then 
		local reasonmessage = ""
		if string.len(reasontext) > 0 then 
			reasonmessage = "~n~"..reasontext
		end
		
		if not getMissionConfigProperty(MissionName, "MissionShareMoney") then 
			ClearPrints()
			SetTextColour(99, 209, 62, 255)
			SetTextEntry_2("STRING")
			if (not isfail) then 
				AddTextComponentString(getMissionConfigProperty(input, "FinishMessage")..reasonmessage.."~n~You Earned ~g~$"..playerMissionMoney)
				MISSIONSHOWTEXT="~g~MISSION PASSED"
				MISSIONSHOWMESSAGE=getMissionConfigProperty(input, "FinishMessage")..reasonmessage.."~n~You Earned ~g~$"..playerMissionMoney
			else 
				if(reasontext =="cancel") then  --cancelled via a vote
					AddTextComponentString("The mission was voted as finished by the players".."~n~You Earned ~g~$"..playerMissionMoney)
					
					MISSIONSHOWTEXT="~r~MISSION CANCELED"
					MISSIONSHOWMESSAGE="The mission was voted as finished by the players".."~n~You Earned ~g~$"..playerMissionMoney					
				else 
					AddTextComponentString(getMissionConfigProperty(input, "FailedMessage")..reasonmessage.."~n~You Earned ~g~$"..playerMissionMoney)
					MISSIONSHOWTEXT="~r~MISSION FAILED"
					MISSIONSHOWMESSAGE=getMissionConfigProperty(input, "FailedMessage")..reasonmessage.."~n~You Earned ~g~$"..playerMissionMoney							
				end
			end
			BLDIDTIMEOUT = false
			MISSIONSHOWRESULT = true
			MISSIONSHAREMONEYAMOUNT	= " "
			--USE SCALEFORM NOW:
			DrawSubtitleTimed(10000, 1)	--time = 10000
		else 
			ClearPrints()
			SetTextColour(99, 209, 62, 255)
			SetTextEntry_2("STRING")
			if (not isfail) then 
				AddTextComponentString(getMissionConfigProperty(input, "FinishMessage")..reasonmessage)
				
				MISSIONSHOWTEXT="~g~MISSION PASSED"
				MISSIONSHOWMESSAGE=getMissionConfigProperty(input, "FinishMessage")..reasonmessage				
			else 
				if(reasontext =="cancel") then  --cancelled via a vote
					AddTextComponentString("The mission was voted as finished by the players")
					MISSIONSHOWTEXT="~r~MISSION CANCELED"
					MISSIONSHOWMESSAGE="The mission was voted as finished by the players"							
					
				else 
					AddTextComponentString(getMissionConfigProperty(input, "FailedMessage")..reasonmessage)
					MISSIONSHOWTEXT="~r~MISSION FAILED"
					MISSIONSHOWMESSAGE=getMissionConfigProperty(input, "FailedMessage")..reasonmessage	
					
				end
			end
			BLDIDTIMEOUT = false
			MISSIONSHOWRESULT = true
			--USE SCALEFORM NOW:
			DrawSubtitleTimed(10000, 1)	--time = 10000		
		
		end
		
		TriggerEvent("mt:doEndSMS",input,isfail)
		
	end 
	
	--reset any safehouse vehicle restrictions
	DecorSetInt(GetPlayerPed(-1),"mrpvehsafehousemax",0)
	mrpvehsafehousemaxG = 0
	--same with hostage count
	DecorSetInt(GetPlayerPed(-1),"mrprescuecount",0)
	DecorSetInt(GetPlayerPed(-1),"mrpobjrescuecount",0)
	DecorSetInt(GetPlayerPed(-1),"mrprescuetarget",0)
	DecorSetInt(GetPlayerPed(-1),"mrpcheckpoint",0)
	DecorSetInt(GetPlayerPed(-1),"mrpcheckpointsclaimed",0)
	--print("DONE...mrprescuecount:"..DecorGetInt(GetPlayerPed(-1),"mrprescuecount"))
	playerMissionMoney = 0
	--print('playerMissionMoney is:'..playerMissionMoney)
	CleanupProps(input) 
	    --aliveCheck()
	checkspawns = false
	PedsSpawned = 0
	playerSecured = false
	
	if (isstop or (getMissionConfigProperty(input, "ResetSafeHouseOnNewMission") ~=nil and getMissionConfigProperty(input, "ResetSafeHouseOnNewMission")) == true) then 
		playerSafeHouse = -1000000 --records game time
	end 
	
	--RESET INDOOR MISSIONS and rescued hostages and objects
	if Config.Missions[input].IndoorsMission or Config.Missions[input].Type == "HostageRescue" or Config.Missions[input].Type == "ObjectiveRescue" then 
		if Config.Missions[input].Peds then 
			for i, v in pairs(Config.Missions[input].Peds) do
				Config.Missions[input].Peds[i].spawned=false
				Config.Missions[input].Peds[i].rescued=false
				--print("reset ped"..i)
			end
		end 
		if Config.Missions[input].Vehicles then 
			for i, v in pairs(Config.Missions[input].Vehicles) do
				Config.Missions[input].Vehicles[i].spawned = false
			end	
		end
		
		if Config.Missions[input].Props then 
			for i, v in pairs(Config.Missions[input].Props) do
				Config.Missions[input].Props[i].rescued=false
			end	
		end
	end
	
	--cleanup RescueMarkers table:
	 for k in ipairs(RescueMarkers) do table[k] = nil end
	 
	--cleanup events
	if Config.Missions[input].Events then 
		for k,v in pairs(Config.Missions[input].Events) do
			Config.Missions[input].Events[k].done=false
		end
	end
	--print("DONE2 MADE IT"..tostring(Config.Missions[input].Events))
	--'reset' IsRandom default event
	if Config.Missions[input].IsRandom and Config.Missions[input].IsRandomEvent and Config.Missions[input].Events and Config.Missions[input].Events[1] and Config.Missions[input].Events[1].Position then 
		--print("DONE MADE IT")
		Config.Missions[input].Events[1].Position.x = 50000.0
		Config.Missions[input].Events[1].Position.y = 50000.0
		Config.Missions[input].Events[1].Position.z = 50000.0
		--'reset' blip as well which is used to define the Events[1].Position
		Config.Missions[input].Blip.Position.x = 50000.0
		Config.Missions[input].Blip.Position.y = 50000.0
		Config.Missions[input].Blip.Position.z = 50000.0
	
	end
	
	
	IsRandomDoEvent = false
	IsRandomDoEventRadius = 1000.0
	IsRandomDoEventType = 0
	isHostageRescueCount = 0
	isObjectiveRescueCount = 0
	IsRandomMissionAllHostagesRescued = false
	IsRandomMissionHostageCount = 0
	securingRescue = 0
	securingRescueType = -1
    securing    = false
	buying    = false
	MissionTimeOut = false
	MilliSecondsLeft = -1
	MissionNoTimeout = false
	DoingMissionTeleport = false
	IsRandomMissionForceSpawning = false
	MissionTriggered=false
	BLHOSTFLAG=false
	Active = 0 --GHK Make sure this is set for all clients for mission end
	MissionName = "N/A"  --GHK Make sure this is set for all clients for mission end
	
	--reset nightvision after every mission
	SetNightvision(false)
	SetSeethrough(false)
	blDoNightVisionToggleState = 0
	blDoNightVisionToggleStates = 0
	blDoNightVision = false
	
	--reset reinforcement drop
	if(DoesBlipExist(MissionDropBlip)) then 
		RemoveBlip(MissionDropBlip)
	end
	MissionDropDid=false
	MissionDropBlip=nil
	MissionDropBlipCoords={x=-50000,y=-50000,z=-50000}
	
	if getMissionConfigProperty(input, "RemoveWeaponsAndUpgradesAtMissionEnd") then 
		--print("made  it"..DecorGetInt(GetPlayerPed(-1),"mrpoptout"))
		if (Config.EnableOptIn or Config.EnableSafeHouseOptIn) and DecorGetInt(GetPlayerPed(-1),"mrpoptout") == 0 then 
			--print("made 1 it")
			RemoveAllPedWeapons(GetPlayerPed(-1))
			playerUpgraded = false
			SetPedMaxHealth(GetPlayerPed(-1),200)
			SetEntityHealth(GetPlayerPed(-1),200)					
			SetPedMoveRateOverride(PlayerId(),1.0) --1.0 is default?
			SetRunSprintMultiplierForPlayer(PlayerId(),1.0)
			SetSwimMultiplierForPlayer(PlayerId(),1.0)
			SetNightvision(false)
			SetSeethrough(false)
			blDoNightVisionToggleState = 0
			blDoNightVisionToggleStates = 0
			blDoNightVision = false
		elseif not(Config.EnableOptIn or Config.EnableSafeHouseOptIn) then
			--print("made 2 it")		
			RemoveAllPedWeapons(GetPlayerPed(-1))
			playerUpgraded = false
			SetPedMaxHealth(GetPlayerPed(-1),200)	
			SetEntityHealth(GetPlayerPed(-1),200)					
			SetPedMoveRateOverride(PlayerId(),1.0) --1.0 is default?
			SetRunSprintMultiplierForPlayer(PlayerId(),1.0)
			SetSwimMultiplierForPlayer(PlayerId(),1.0)	
			SetNightvision(false)	
			SetSeethrough(false)
			blDoNightVisionToggleState = 0
			blDoNightVisionToggleStates = 0
			blDoNightVision = false			
		
		end
	
	end	
	
	if Config.ForceOptOutAtMissionEnd then 
		DecorSetInt(GetPlayerPed(-1),"mrpoptout",1)
		DecorSetInt(GetPlayerPed(-1),"mrpoptin",0)
		playerUpgraded = false
		SetPedMaxHealth(GetPlayerPed(-1),200)	
		SetEntityHealth(GetPlayerPed(-1),200)				
		SetPedMoveRateOverride(PlayerId(),1.0) --1.0 is default?
		SetRunSprintMultiplierForPlayer(PlayerId(),1.0)
		SetSwimMultiplierForPlayer(PlayerId(),1.0)	
		SetNightvision(false)	
		SetSeethrough(false)
		blDoNightVisionToggleState = 0
		blDoNightVisionToggleStates = 0
		blDoNightVision = false					
	end
	

	
	if DecorGetInt(GetPlayerPed(-1),"mrpoptin") == 1 and Config.EnableOptIn then 
		--Notify("~b~You can opt out of missions now with the '~o~Q~b~' and '~o~[~b~' keys or ~o~RB + DPAD DOWN")
		
		HelpMessage("You can opt out of missions now with ~INPUT_SNIPER_ZOOM_OUT_SECONDARY~ and ~INPUT_COVER~",false,5000)		
		--Notify("~o~'Q' and '[' ~g~keys or ~o~RB + DPAD DOWN")	
	elseif DecorGetInt(GetPlayerPed(-1),"mrpoptin") == 1 and Config.EnableSafeHouseOptIn then
		--Notify("~b~You can opt out of missions now by pressing the '~o~[~b~' key or ~o~DPAD DOWN")
		HelpMessage("You can opt out of missions now with ~INPUT_SNIPER_ZOOM_OUT_SECONDARY~",false,5000)	
	end
	
	
	
end)


RegisterNetEvent('SpawnPedBlips')
AddEventHandler('SpawnPedBlips', function(input)
	--SpawnProps(input)
	--SpawnMissionPickups(input) 
	--print('spawnpedblips2 called')
	
	--if DecorGetInt(GetPlayerPed(-1),"mrpoptout") == 0 then 
		--return
	--end
	
	if getMissionConfigProperty(input, "MissionTriggerRadius") then 
		
		local mcoords = {x=0,y=0,z=0}
		if getMissionConfigProperty(input, "MissionTriggerStartPoint") then 
			
			mcoords.x = getMissionConfigProperty(input, "MissionTriggerStartPoint").x
			mcoords.y = getMissionConfigProperty(input, "MissionTriggerStartPoint").y
			mcoords.z = getMissionConfigProperty(input, "MissionTriggerStartPoint").z
		
		elseif Config.Missions[input].Blip then
			mcoords.x = Config.Missions[input].Blip.Position.x
			mcoords.y = Config.Missions[input].Blip.Position.y
			mcoords.z = Config.Missions[input].Blip.Position.z		
			
		elseif Config.Missions[input].Blips and Config.Missions[input].Blips[1] then
			mcoords.x = Config.Missions[input].Blips[1].Position.x
			mcoords.y = Config.Missions[input].Blips[1].Position.y
			mcoords.z = Config.Missions[input].Blips[1].Position.z
		
		end	
		
		local playerTriggered = false
		 --BLHOSTFLAG = false
		repeat
		local coords = GetEntityCoords(GetPlayerPed(-1))
			 --BLHOSTFLAG = false
			if GetDistanceBetweenCoords(coords.x,coords.y,coords.z, 
				mcoords.x,
				mcoords.y,
				mcoords.z, false) <= getMissionConfigProperty(input, "MissionTriggerRadius") and DecorGetInt(GetPlayerPed(i),"mrpoptout")==0 then 
				playerTriggered = true
				
			end 
			Wait(1)
			--BLHOSTFLAG = false
			 
			 --if mission is stopped, exit out of the event:
			if Active == 0 or MissionName =="N/A" then
				
				return
			end	
					 --print('spawnpedblips2 called1')
		until playerTriggered or MissionTriggered or MissionTimeOut
		
		if MissionTimeOut then 
		
			Active = 0
			message2 = "^1[MISSIONS]: ^2'".. Config.Missions[MissionName].MissionTitle .."'^0 has been canceled"
			TriggerServerEvent("sv:two", message2)
			TriggerServerEvent("sv:done", MissionName,true,false,"")
			--TriggerEvent("DONE", MissionName) --ghk needed?
			aliveCheck() --<-- NEEDED?
			MissionName = "N/A"			
			--print('spawnpedblips2 called2')
			return
		
		end
		

		
		if playerTriggered and not MissionTriggered then 
			TriggerServerEvent("sv:CheckMissionHost") 
			--wait 1 second and check again. 
			--if no mission host where  BLHOSTFLAG = true
			--that triggers the mission with MissionTriggered=true
			--then we need to cancel the mission. 
			Wait(1000)
			--if mission is stopped, exit out of the event:
			if Active == 0 or MissionName =="N/A" then
				--print('spawnpedblips2 called3')
				return
			end	
					 			
			if playerTriggered and not MissionTriggered then

				Active = 0
				message2 = "^1[MISSIONS]: ^2'".. Config.Missions[MissionName].MissionTitle .."'^0 has been canceled"
				TriggerServerEvent("sv:two", message2)
				TriggerServerEvent("sv:done", MissionName,true,false,"")
				--TriggerEvent("DONE", MissionName) --ghk needed?
				aliveCheck() --<-- NEEDED?
				MissionName = "N/A"	
--print('spawnpedblips2 called4')
				return
				
			end 			
			
		end
	
	
	
	end
	
	if(isHostageRescueCount ==0 and Config.Missions[MissionName].Type == "HostageRescue" and not Config.Missions[MissionName].IsRandom) then 
		for i=1, #Config.Missions[input].Peds do
			if Config.Missions[MissionName].Peds[i].friendly and not Config.Missions[MissionName].Peds[i].dead and not Config.Missions[MissionName].Peds[i].rescued then
						--print("hey")
				isHostageRescueCount = isHostageRescueCount + 1
			end
		end
	
	end
	
	if(isObjectiveRescueCount ==0 and Config.Missions[MissionName].Type == "ObjectiveRescue" and not Config.Missions[MissionName].IsRandom) then 
		for i=1, #Config.Missions[input].Props do
			if Config.Missions[MissionName].Props[i].isObjective and not Config.Missions[MissionName].Props[i].rescued then
				isObjectiveRescueCount = isObjectiveRescueCount + 1
			end
		end
	
	end
	
		--get the amount of hostages left.. DONE VIA SPAWNING CLIENT NOW, SINCE THIS DOESNT GET CALLED IN TIME AT MISSION START
	--if Config.Missions[input].IsRandom and Config.Missions[input].Type=="HostageRescue" then 
		--TriggerServerEvent('sv:UpdateisHostageRescueCount')
			
	--end	
	
	--if(blForceCheckForBlips) then
--[[	
	if(false) then 
	
		local i = 0
		local lastfound = GetGameTimer() 
		repeat 
			
			for ped in EnumeratePeds() do
			
				if ((DecorGetInt(ped, "mrppedid") > 0  or DecorGetInt(ped, "mrpvpedid") > 0) and not (IsEntityDead(ped) == 1)) then
			
					--for client that called SpawnPeds, blips already added
					local oldblip = GetBlipFromEntity(ped)
					--RemoveBlip(oldblip)
					if oldblip == 0 then 
						local Size     = 0.9
						local pedblip = AddBlipForEntity(ped)
						SetBlipScale  (pedblip, Size)
						SetBlipAsShortRange(pedblip, false)
						
						
						if DecorGetInt(ped, "mrppedtarget") > 0 then
							--print('ENEMY PEDT')
							--SetBlipSprite(pedblip, 433)
							SetBlipColour(pedblip, 1)
							BeginTextCommandSetBlipName("STRING")
							AddTextComponentString("Enemy Target ($"..getTargetKillReward(input)..")")
							EndTextCommandSetBlipName(pedblip)	
								
						elseif DecorGetInt(ped, "mrppedfriend") > 0 then
							--SetBlipSprite(pedblip, 280)
							--print('ENEMY PEDF')
							SetBlipColour(pedblip, 2)	
							BeginTextCommandSetBlipName("STRING")
							AddTextComponentString("Friendly Rescue: ($"..getMissionConfigProperty(input, "HostageRescueReward").."), Kill:($-"..getHostageKillPenalty(input)..")")
							EndTextCommandSetBlipName(pedblip)	
						elseif DecorGetInt(ped, "mrppedsafehouse") > 0 then
							--SetBlipSprite(pedblip, 280)
							--print('ENEMY PEDF')
							SetBlipColour(pedblip, 3)	
							BeginTextCommandSetBlipName("STRING")
							AddTextComponentString("Mission Safe House Support")
							EndTextCommandSetBlipName(pedblip)											
							
						elseif DecorGetInt(ped, "mrppeddefendtarget") > 0 then
							--SetBlipSprite(pedblip, 280)
							--print('ENEMY PEDF')
							SetBlipColour(pedblip, 5)	
							BeginTextCommandSetBlipName("STRING")
							AddTextComponentString("Rescue Target: ($"..getMissionConfigProperty(MissionName, "IsDefendTargetRescueReward").."), Kill:($-"..getMissionConfigProperty(MissionName, "IsDefendTargetKillPenalty")..")")
							EndTextCommandSetBlipName(pedblip)											
						
						else
							--print('ENEMY1 PED')
							BeginTextCommandSetBlipName("STRING")
							AddTextComponentString("Enemy ($"..getKillReward(input)..")")
							EndTextCommandSetBlipName(pedblip)	
							
						
						end			
						--lastfound = GetGameTimer()
						i = i + 1
					end 
				end

			end	
			--print('looking for enemy peds...'..i)
			Wait(1000)
		until (GetGameTimer() - lastfound > blForceCheckForBlipsTimeout) --defauly wait 30 seconds to stop looking 
		
		--print('found enemy peds..'..i)
	else 
			for ped in EnumeratePeds() do
			
				if DecorGetInt(ped, "mrppedid") > 0  or DecorGetInt(ped, "mrpvpedid") > 0 and not (IsEntityDead(ped) == 1) then
			
					--for client that called SpawnPeds, blips already added
					local oldblip = GetBlipFromEntity(ped)
					--RemoveBlip(oldblip)
					if oldblip == 0 then 
						local Size     = 0.9
						local pedblip = AddBlipForEntity(ped)
						SetBlipScale  (pedblip, Size)
						SetBlipAsShortRange(pedblip, false)
						
						
						if DecorGetInt(ped, "mrppedtarget") > 0 then
							--print('ENEMY PEDT')
							--SetBlipSprite(pedblip, 433)
							SetBlipColour(pedblip, 1)
							BeginTextCommandSetBlipName("STRING")
							AddTextComponentString("Enemy Target ($"..getTargetKillReward(input)..")")
							EndTextCommandSetBlipName(pedblip)	
								
						elseif DecorGetInt(ped, "mrppedfriend") > 0 then
							--SetBlipSprite(pedblip, 280)
							--print('ENEMY PEDF')
							SetBlipColour(pedblip, 2)	
							BeginTextCommandSetBlipName("STRING")
							AddTextComponentString("Friendly Rescue: ($"..getMissionConfigProperty(input, "HostageRescueReward").."), Kill:($-"..getHostageKillPenalty(input)..")")
							EndTextCommandSetBlipName(pedblip)	
						elseif DecorGetInt(ped, "mrppedsafehouse") > 0 then
							--SetBlipSprite(pedblip, 280)
							--print('ENEMY PEDF')
							SetBlipColour(pedblip, 3)	
							BeginTextCommandSetBlipName("STRING")
							AddTextComponentString("Mission Safe House Support")
							EndTextCommandSetBlipName(pedblip)	
						
						elseif DecorGetInt(ped, "mrppeddefendtarget") > 0 then
							--SetBlipSprite(pedblip, 280)
							--print('ENEMY PEDF')
							SetBlipColour(pedblip, 5)	
							BeginTextCommandSetBlipName("STRING")
							AddTextComponentString("Rescue Target: ($"..getMissionConfigProperty(MissionName, "IsDefendTargetRescueReward").."), Kill:($-"..getMissionConfigProperty(MissionName, "IsDefendTargetKillPenalty")..")")
							EndTextCommandSetBlipName(pedblip)								
							
							
						else
							--print('ENEMY2 PED')
							BeginTextCommandSetBlipName("STRING")
							AddTextComponentString("Enemy ($"..getKillReward(input)..")")
							EndTextCommandSetBlipName(pedblip)						
						
						end			
						--lastfound = GetGameTimer()
					end 
				end

			end		
	
	
	end
	]]--
	--print("spawnpedblips")
	PedsSpawned = 1 --needed for other clients
    aliveCheck()
end)


AddRelationshipGroup('HOSTAGES') 
AddRelationshipGroup('TRUENEUTRAL')
AddRelationshipGroup('ISDEFENDTARGET')
AddRelationshipGroup('SAFEHOUSE')  --need to make these guys neutral to NPCs as well, since NPCs can focus on them from 10000m away based on AI settings.  

function Notify(msg)
  SetNotificationTextEntry("STRING")
  AddTextComponentString(msg)
  DrawNotification(true, false)
end

local function roundToNthDecimal(num, n)
  local mult = 10^(n or 0)
  return math.floor(num * mult + 0.5) / mult
end


function checkAndGetGroundZ(x, y, z,blFindGroundZ)
local groundFound = false
local groundCheckHeights = {0.0, 50.0, 100.0, 150.0, 200.0, 250.0, 300.0, 350.0, 400.0,450.0, 500.0, 550.0, 600.0, 650.0, 700.0, 750.0, 800.0}
local ground
			

	local unused,zGround = GetGroundZFor_3dCoord(x, y, z)
	--print("checkAndGetGroundZ: Groundz:"..zGround)
	--print("checkAndGetGroundZ:blFindGroundZ:"..tostring(blFindGroundZ)) 
	if zGround == 0.0 then 
		if blFindGroundZ then 
			
			for i,height in ipairs(groundCheckHeights) do
			
			--for i=0, 800 do
			--print("i"..i)
				RequestCollisionAtCoord(x, y, i*1.0)
				--Wait(0) --< NEEDED?
				--SetEntityCoordsNoOffset(Ped, rXoffset,rYoffset,height, 0, 0, 1)
				ground,zGround = GetGroundZFor_3dCoord(x,y,i*1.0)
				if(ground) then
					zGround = zGround + 3
					groundFound = true
					break;
				end
			--end
			 --Citizen.Wait(5)
			end
			if(not groundFound) or zGround < 0.0 then --zGround < 0.0 is water. turn off for boat missions
				--print("checkAndGetGroundZ: findZoffset:"..zGround) 
				--print("checkAndGetGroundZ: groundFound:"..tostring(groundFound)) 
				--print("zground = 0.0")
				zGround = 0.0 
			else 
				--print("checkAndGetGroundZ: findZoffset:"..zGround) 
				--print("checkAndGetGroundZ: groundFound:"..tostring(groundFound)) 
				
			end
		end
	end
--[[
	groundCheckHeights = {1000, 900, 800, 700, 600, 500,
            400, 300, 200, 100, 0, -100, -200, -300, -400, -500 }
	
	if zGround == 0.0 then 
		if blFindGroundZ then 
			
			for i,height in ipairs(groundCheckHeights) do
				RequestCollisionAtCoord(x, y, height)
				Wait(0) --< NEEDED?
				--SetEntityCoordsNoOffset(Ped, rXoffset,rYoffset,height, 0, 0, 1)
				ground,zGround = GetGroundZFor_3dCoord(x,y,height)
				if(ground) then
					zGround = zGround + 3
					groundFound = true
					break;
				end
			end
			if(not groundFound) or zGround < 0.0 then --zGround < 0.0 is water. turn off for boat missions
				--print("checkAndGetGroundZ: findZoffset:"..zGround) 
				--print("checkAndGetGroundZ: groundFound:"..tostring(groundFound)) 
				zGround = 0.0 
			else 
				--print("checkAndGetGroundZ: findZoffset:"..zGround) 
				--print("checkAndGetGroundZ: groundFound:"..tostring(groundFound)) 
				
			end
		end
	end

	groundCheckHeights = { -500, -400, -300, -200, -100, 0,
            100, 200, 300, 400, 500, 600, 700, 800, 900, 1000}
	
	if zGround == 0.0 then 
		if blFindGroundZ then 
			
			for i,height in ipairs(groundCheckHeights) do
				RequestCollisionAtCoord(x, y, height)
				Wait(0) --< NEEDED?
				--SetEntityCoordsNoOffset(Ped, rXoffset,rYoffset,height, 0, 0, 1)
				ground,zGround = GetGroundZFor_3dCoord(x,y,height)
				if(ground) then
					zGround = zGround + 3
					groundFound = true
					break;
				end
			end
			if(not groundFound) or zGround < 0.0 then --zGround < 0.0 is water. turn off for boat missions
				--print("checkAndGetGroundZ: findZoffset:"..zGround) 
				--print("checkAndGetGroundZ: groundFound:"..tostring(groundFound)) 
				zGround = 0.0 
			else 
				--print("checkAndGetGroundZ: findZoffset:"..zGround) 
				--print("checkAndGetGroundZ: groundFound:"..tostring(groundFound)) 
				
			end
		end
	end	
]]--	
	
	--print("checkAndGetGroundZ: FinalGroundz:"..zGround) 
	return zGround

end

--EventTypes: flag 1 = land only, 2 = water and land, 3 = water only 
function generateExtraRandomEvents(MissionName,SafeHouseLocationIndex)
 
 	local Events = {}
	local EventTypes = getMissionConfigProperty(MissionName, "ExtraRandomEventsType")
	
	if Config.Missions[MissionName].Events then 
		Events = Config.Missions[MissionName].Events
	end
	if getMissionConfigProperty(MissionName, "GenerateExtraRandomEventsNum") > 0 then 
	
	
		for i = 1,getMissionConfigProperty(MissionName, "GenerateExtraRandomEventsNum"),1 
		do 
			local rIsRandomSpawnAnywhereInfo
			if EventTypes ==  1 then
				rIsRandomSpawnAnywhereInfo = doLandBattle(MissionName)
			elseif EventTypes ==  2 then
				rIsRandomSpawnAnywhereInfo = getRandomAnywhereLocation(MissionName)
			elseif EventTypes ==  3 then
				rIsRandomSpawnAnywhereInfo = doBoatBattle(MissionName)
			end
			
			--create events around each checkpoint
			for j=1,math.random(1,3),1
			do
			 Events = createRandomEvents(rIsRandomSpawnAnywhereInfo[1],Events,0,rIsRandomSpawnAnywhereInfo[2])
			end	
		end
		Config.Missions[MissionName].Events = Events
			--print(#Events)
		if((Config.Missions[MissionName].Type ~= "Checkpoint") and Config.Missions[MissionName].IsRandom) or not Config.Missions[MissionName].IsRandom then 
			--print("made send")
			
			TriggerServerEvent("sv:generateCheckpointsAndEvents",MissionName, {},Config.Missions[MissionName].Events,{})
		end 
	 
	end


end

function generateCheckpointsAndEvents(MissionName,SafeHouseLocationIndex,MissionInfo)

    local recordedCheckpoints = {}
	local Events = {}
	
	if Config.Missions[MissionName].Events then 
		Events = Config.Missions[MissionName].Events
	end
	--print(#Events)
	local waypointCoords = getMissionConfigProperty(MissionName, "SafeHouseLocations")[SafeHouseLocationIndex].BlipSL.Position
	
	local retval, coords = GetClosestVehicleNode(waypointCoords.x, waypointCoords.y, waypointCoords.z, 1)
	
	
	if getMissionConfigProperty(MissionName, "CheckpointsDoWater") then 
		--print("SAFE HOUSE SB START")
		waypointCoords = getMissionConfigProperty(MissionName, "SafeHouseLocations")[SafeHouseLocationIndex].BlipSB.Position
	
	end
	
	
	--coords = waypointCoords
	--local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    --SetBlipColour(blip, 5)
    --SetBlipAsShortRange(blip, true)
    --ShowNumberOnBlip(blip, #recordedCheckpoints+1)
	 -- Add checkpoint to array
    --table.insert(recordedCheckpoints, {blip = blip, coords = coords})
	--print("generateCheckpointsAndEvents")
	local checkpoints = math.random(getMissionConfigProperty(MissionName, "MaxCheckpoints")) --MissionInfo has the last checkpoint
	--Get last checkpoint index:
	local k
	for i = 1,checkpoints,1 
	do 
		local retval 
		local coords
		
			
		if getMissionConfigProperty(MissionName, "CheckpointsDoLand") then 
			retval = doLandBattle(MissionName)
			coords = retval[1]
		
			if getMissionConfigProperty(MissionName, "SpawnCheckpointsOnRoadsOnly") then
				--print("closestroad")
				local retval1, coords1 = GetClosestVehicleNode(coords.x,coords.y, coords.z, 1)
				coords = coords1
			end
		
		elseif getMissionConfigProperty(MissionName, "CheckpointsDoWater") then 
			retval = doBoatBattle(MissionName)
			coords = retval[1]	

		elseif getMissionConfigProperty(MissionName, "CheckpointsDoWaterAndLand") then
			retval = getRandomAnywhereLocation(MissionName)
			coords = retval[1]	
			
			
			--spawned on land...
			if not retval[2] and getMissionConfigProperty(MissionName, "SpawnCheckpointsOnRoadsOnly") then
				local retval1, coords1 = GetClosestVehicleNode(coords.x,coords.y, coords.z, 1)
				coords = coords1			
			
			end
			
		end
		
		--print("i=.."..i)
		--print("coordsx="..coords.x)
		--print("coordsy="..coords.y)
		--print("coordsz="..coords.z)
		
		--local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
		--SetBlipColour(blip, 5)
		--SetBlipAsShortRange(blip, true)
		--ShowNumberOnBlip(blip, #recordedCheckpoints+1)	   
	    table.insert(recordedCheckpoints, {blip = blip, coords = coords})
		local numEventsForCheckpoint = math.random(1,3)
		--create events around each checkpoint
		k=i
		for j=1,math.random(2),1
		do
			Events = createEvents(coords,Events,i,retval[2])
			
		end
		
		k=k+1
		--print("k:"..k)
	end
	
	--last checkpoint for mission end:
	coords = MissionInfo[1]
	--local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
	--SetBlipColour(blip, 5)
	--SetBlipAsShortRange(blip, true)
	--ShowNumberOnBlip(blip, #recordedCheckpoints+1)	   
	table.insert(recordedCheckpoints, {blip = blip, coords = coords})
	local numEventsForCheckpoint = math.random(1,3)
		--create events around each checkpoint
		
		for j=1,math.random(3,3),1
		do
		 Events = createEvents(coords,Events,k,MissionInfo[2])
		end	
	
	
	Config.Missions[MissionName].Events = Events
	--print(#Events)
	--print("sv:generateCheckpointsAndEvents CALLED")
	TriggerServerEvent("sv:generateCheckpointsAndEvents",MissionName, recordedCheckpoints,Config.Missions[MissionName].Events,waypointCoords)
	 


end

function createEvents(coords,Events,checkpoint,isWater)
local eventtypes = {"Squad","Vehicle","Paradrop","Aircraft"}
local eventtype= eventtypes[math.random(#eventtypes)]

	if isWater then
		eventtypes = {"Boat","Boat","Boat","Boat","Aircraft"}
		eventtype= eventtypes[math.random(#eventtypes)]
	end
	
	if getMissionConfigProperty(MissionName, "CheckpointsAirBattle") then 
		
		eventtype = "Aircraft"
	
	end
	
	

	--print("evt"..eventtype)
	--print("checkpoint"..checkpoint)
	--print("iswater:"..tostring(isWater))
	if eventtype=="Squad" and not isWater then
		local isBoss = false
		local NumberPeds = math.random(10,25)
		if math.random(4) > 3 then
			isBoss = true
			NumberPeds = math.random(5,10)
		end
		local radius =math.random(200.0,300.0)*1.0
		table.insert(Events, {Type="Squad", Position = {x=coords.x,y=coords.y,z=coords.z},
		 Size     = {radius=radius},
		 NumberPeds=NumberPeds,isBoss=isBoss, CheckGroundZ=true,
		 SquadSpawnRadius=math.random(20,100),checkpoint=checkpoint,Message=nil})	
		 
		 --local blip = AddBlipForRadius(coords.x, coords.y, coords.z,radius)
		--SetBlipColour(blip, 1)
		--SetBlipAlpha(blip,80)
	
	elseif eventtype=="Vehicle" and not isWater then
		local radius =math.random(200.0,1000.0)*1.0
		table.insert(Events, {Type="Vehicle", Position = {x=coords.x+math.random(-10,10),y=coords.y + math.random(-10,10), z=coords.z},
		Size     = {radius=radius},
		FacePlayer = true,checkpoint=checkpoint,Message=nil}
		)	
	
		--local blip = AddBlipForRadius(coords.x, coords.y, coords.z,radius)
		--SetBlipColour(blip, 1)
		--SetBlipAlpha(blip,80)

	elseif eventtype=="Paradrop" and not isWater then
		local radius = math.random(200.0,300.0)*1.0
		table.insert(Events, {Type="Paradrop", Position = {x=coords.x,y=coords.y,z=coords.z},
		 Size     = {radius=radius},
		NumberPeds=math.random(10,25),checkpoint=checkpoint,
		SpawnAt =  {x=coords.x,y=coords.y,z=coords.z},Message=nil}
		 )
		 
		 --print("paraz:"..coords.z)
		-- local blip = AddBlipForRadius(coords.x, coords.y, coords.z,radius)
		--SetBlipColour(blip, 1)
		--SetBlipAlpha(blip,80)
	
	elseif eventtype=="Aircraft" then
		local radius = math.random(1000.0,3000.0)*1.0
		table.insert(Events, {Type="Aircraft", Position = {x=coords.x+math.random(-50,50),y=coords.y+math.random(-50,50),z=coords.z},
		SpawnAt =  {x=coords.x,y=coords.y,z=coords.z},
		Size     = {radius=radius},
		SpawnHeight =math.random(200.0,400.0),
		FacePlayer = true,checkpoint=checkpoint,Message=nil}
		)
		
		--local blip = AddBlipForRadius(coords.x, coords.y, coords.z,radius)
		--SetBlipColour(blip, 1)
		--SetBlipAlpha(blip,80)
		
	elseif eventtype=="Boat" and isWater then
		local radius = math.random(200.0,500.0)*1.0
		table.insert(Events, {Type="Boat", Position = {x=coords.x+math.random(-10,10),y=coords.y+math.random(-10,10),z=coords.z + 5.0},
		Size     = {radius=radius},
		FacePlayer = true,checkpoint=checkpoint,Message=nil}
		)
		
		--local blip = AddBlipForRadius(coords.x, coords.y, coords.z,radius)
		--SetBlipColour(blip, 1)
		--SetBlipAlpha(blip,80)		
		
	end
	
	


	return Events
end

function createRandomEvents(coords,Events,checkpoint,isWater)
local eventtypes = {"Squad","Squad","Vehicle","Vehicle","Paradrop","Aircraft"}
local eventtype= eventtypes[math.random(#eventtypes)]

	if isWater then
		eventtypes = {"Boat","Boat","Boat","Boat","Aircraft"}
		eventtype= eventtypes[math.random(#eventtypes)]
	end
	
	if getMissionConfigProperty(MissionName, "CheckpointsAirBattle") then 
		
		eventtype = "Aircraft"
	
	end
	
	

	--print("evt"..eventtype)
	--print("checkpoint"..checkpoint)
	--print("iswater:"..tostring(isWater))
	if eventtype=="Squad" and not isWater then
		local isBoss = false
		local NumberPeds = math.random(5,10)
		if math.random(4) > 3 then
			isBoss = true
			NumberPeds = math.random(2,5)
		end
		local radius =math.random(200.0,300.0)*1.0
		table.insert(Events, {Type="Squad", Position = {x=coords.x,y=coords.y,z=coords.z},
		 Size     = {radius=radius},
		 NumberPeds=NumberPeds,isBoss=isBoss, CheckGroundZ=true,
		 SquadSpawnRadius=math.random(20,100),Message=nil,revent=true})	
	
	
	elseif eventtype=="Vehicle" and not isWater then
		local radius =math.random(200.0,300.0)*1.0
		table.insert(Events, {Type="Vehicle", Position = {x=coords.x+math.random(-10,10),y=coords.y + math.random(-10,10), z=coords.z},
		Size     = {radius=radius},
		FacePlayer = true,Message=nil,revent=true}
		)	
	
	

	elseif eventtype=="Paradrop" and not isWater then
		local radius = math.random(200.0,300.0)*1.0
		table.insert(Events, {Type="Paradrop", Position = {x=coords.x,y=coords.y,z=coords.z},
		 Size     = {radius=radius},
		NumberPeds=math.random(5,10),
		SpawnAt =  {x=coords.x,y=coords.y,z=coords.z},Message=nil,revent=true}
		 )
		 
	
	elseif eventtype=="Aircraft" then
		local radius = math.random(1000.0,3000.0)*1.0
		table.insert(Events, {Type="Aircraft", Position = {x=coords.x+math.random(-50,50),y=coords.y+math.random(-50,50),z=coords.z},
		SpawnAt =  {x=coords.x,y=coords.y,z=coords.z},
		Size     = {radius=radius},
		SpawnHeight =math.random(200.0,400.0),
		FacePlayer = true,Message=nil,revent=true}
		)
		
		
		
	elseif eventtype=="Boat" and isWater then
		local radius = math.random(200.0,500.0)*1.0
		table.insert(Events, {Type="Boat", Position = {x=coords.x+math.random(-10,10),y=coords.y+math.random(-10,10),z=coords.z + 5.0},
		Size     = {radius=radius},
		FacePlayer = true,Message=nil,revent=true}
		)
		
	
	end
	
	


	return Events
end


--finds only locations where there is water
function doBoatBattle(MissionName)

	local doBoatMission = false
	local tries = 0
	local retval -- = {false,{x=0.0,y=0.0,z=0.0}}
	repeat
		retval = getRandomAnywhereLocation(MissionName)
		doBoatMission = retval[2]
		tries = tries + 1
		Wait(0)

	until( doBoatMission == true or tries > 100 )

	return retval
end

--finds only locations where there is land
function doLandBattle(MissionName)

	local doBoatMission = true
	local tries = 0
	local retval -- = {false,{x=0.0,y=0.0,z=0.0}}
	repeat
		retval = getRandomAnywhereLocation(MissionName)
		doBoatMission = retval[2]
		tries = tries + 1
		Wait(0)

	until( doBoatMission == false or tries > 100 )

	return retval
end

function getRandomAnywhereLocation(MissionName) 
	local randomplace = {x=0.0,y=0.0,z=0.0}
	local doBoatMission = false
	local onlyLand = false 
	local raytracesuccess = false 
		
	if(getMissionConfigProperty(MissionName, "IsRandomSpawnAnywhereCoordRange")) then
		local xrange = getMissionConfigProperty(MissionName, "IsRandomSpawnAnywhereCoordRange").xrange
		local yrange = getMissionConfigProperty(MissionName, "IsRandomSpawnAnywhereCoordRange").yrange
		randomplace.x = math.random(xrange[1], xrange[2])*1.0
		randomplace.y = math.random(yrange[1], yrange[2])*1.0
		--print('found IsRandomSpawnAnywhereCoordRange')
	else
		--whole map
		randomplace.x = math.random(-3500, 4200)*1.0
		randomplace.y = math.random(-3700, 7700)*1.0
	end	
	--randomplace.x = math.random(100,1000)*1.0
	--randomplace.y = math.random(3700,4100)*1.0
	
	--TEST
	--randomplace.x =  -1128.0
	--randomplace.y =  -3488.0
	--randomplace.z = 34.0269
		
	--lets get the ground z:
	randomplace.z = checkAndGetGroundZ(randomplace.x,randomplace.y,0.0,true)
	--print("groundz at:"..randomplace.z)
	randomplace.z = checkAndGetGroundZ(randomplace.x,randomplace.y,randomplace.z,true)
	--print("groundz2 at:"..randomplace.z)
	
	--TEST
	--randomplace.x =  1056.0
	--randomplace.y =  -2220.0
	--randomplace.z = 32.264
	
	
	--experimental:
	--if randomplace.z ~= 0.0 then
		--randomplace.z = randomplace.z - 3 --**take away the + 3 that checkAndGetGroundZ added**
	--end
	
	

	--randomplace.z = checkAndGetGroundZ(randomplace.x,randomplace.y,randomplace.z,true)
	--print("groundz3 at:"..randomplace.z)
	
	local watertest = GetWaterHeight(randomplace.x,randomplace.y,randomplace.z)
	if watertest  == 1 or watertest  == true then 
			--water mission
			--print("water mission at:") 
			--print(randomplace.x..","..randomplace.y..","..randomplace.z)
			
			doBoatMission = true
	else
			--print("land mission at:") 
			--print(randomplace.x..","..randomplace.y..","..randomplace.z)	
	
	end 
	--Just for Objective Missions? Determine if the objective is 
	--below a roof. If it is, find a new location. 
	--do for doBoatMission as well, due to yachts and other potential objects...
	local ray = Citizen.InvokeNative( 0x377906D8A31E5586, vector3(randomplace.x, randomplace.y, randomplace.z) + vector3(0.0, 0.0, 1000.0), vector3(randomplace.x, randomplace.y, randomplace.z), -1, -1, 0)
		--local ray = StartShapeTestRay(vector3(rXoffset, rYoffset, rZoffset) + vector3(0.0, 0.0, 500.0), vector3(rXoffset, rYoffset, rZoffset), -1, -1, 0)
		-- local _, hit, impactCoords  = Citizen.InvokeNative( 0x3D87450E15D98694, ray,hit)
	local _, hit, impactCoords = GetRaycastResult(ray) --GetShapeTesResult(ray)
			
		-- print("HIT: " .. hit)
		-- print(("IMPACT COORDS: X = %.4f; Y = %.4f; Z = %.4f"):format(impactCoords.x, impactCoords.y, impactCoords.z))
		-- print("DISTANCE BETWEEN DROP AND IMPACT COORDS: " ..  #(vector3(dropCoords.x, dropCoords.y, dropCoords.z) - vector3(impactCoords)))
	if hit == 0 or (hit == 1 and #(vector3(randomplace.x, randomplace.y, randomplace.z) - vector3(impactCoords)) < 0.5) then -- ± 0.5 units
		--print("ROOFCHECK: success")
		--raytestsuccess = true
	else
		--print("ROOFCHECK: fail")
		--raytestsuccess = false
			   
	end
	
	
	
	return {randomplace,doBoatMission}

end



--Add AA Trailer?
--tow functions not working. 
--attaching it as entity makes the AA trailer freeze.
--**not being used**
function AddTrailer(modelhash,PedVehicle,MissionName) 
	if DoesEntityExist(PedVehicle) then 
		for i, v in pairs(Config.TowVehicles) do
			print(v)
			 if modelhash == v then
			 	local randomPedModelHash = getMissionConfigProperty(MissionName, "RandomMissionPeds")[math.random(1, #getMissionConfigProperty(MissionName, "RandomMissionPeds"))]
				local randomPedWeaponHash = getMissionConfigProperty(MissionName, "RandomMissionVehicleWeapons")[math.random(1, #getMissionConfigProperty(MissionName, "RandomMissionVehicleWeapons"))]
				--print("towed by:"..i)
				local vcoords = GetEntityCoords(PedVehicle,true)
				vehiclehash = GetHashKey("trailersmall2")
				RequestModel(vehiclehash)
				RequestModel(randomPedModelHash)
				while not HasModelLoaded(vehiclehash) do
					Wait(1)
				end
				
				local TrailerVehicle = CreateVehicle("trailersmall2", vcoords.x+5, vcoords.y+5, vcoords.z + 0.0,  0.0, 1, 0)
				--now attach the trailer to the vehicle
				--AttachVehicleToTowTruck(PedVehicle, TrailerVehicle, true, 0.0, 0.0, 0.0)
				--print("IsVehicleAttachedToTowTruck(towTruck, vehicle):"..tostring(IsVehicleAttachedToTowTruck(PedVehicle, TrailerVehicle)))
				AttachEntityToEntity(TrailerVehicle, PedVehicle, GetEntityBoneIndexByName(PedVehicle, 'bodyshell'), 0.0 , -4.0, 0.0 + 0.35, 0, 0, 0, 1, 1, 0, 1, 0, 1)
				ProcessEntityAttachments(PedVehicle)
				--DetachEntity(TrailerVehicle, true, true) 
				--AttachVehicleToTowTruck(PedVehicle, TrailerVehicle, true, 0.0, 0.0, 0.0)
				--print("IsVehicleAttachedToTowTruck(towTruck, vehicle):"..tostring(IsVehicleAttachedToTowTruck(PedVehicle, TrailerVehicle)))
				DecorSetInt(TrailerVehicle,"mrpvehdid",i)
				SetEntityAsMissionEntity(TrailerVehicle,true,true)
				doVehicleMods("trailersmall2",TrailerVehicle,MissionName) 
				
				while not HasModelLoaded(randomPedModelHash) do
					Wait(1)
				end
				Ped = CreatePed(2, randomPedModelHash,  vcoords.x, vcoords.y, vcoords.z + 0.0, 0.0, true, true)
				SetModelAsNoLongerNeeded(randomPedModelHash)
				SetEntityAsMissionEntity(Ped,true,true)	
				SetPedRelationshipGroupHash(Ped, GetHashKey("HATES_PLAYER"))
				SetRelationshipBetweenGroups(5, GetHashKey("HATES_PLAYER"), GetHashKey("PLAYER"))
				SetRelationshipBetweenGroups(0, GetHashKey("HATES_PLAYER"), GetHashKey("HATES_PLAYER"))
				SetRelationshipBetweenGroups(5, GetHashKey("HATES_PLAYER"), GetHashKey("ISDEFENDTARGET"))
				SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("HATES_PLAYER"))	
				SetRelationshipBetweenGroups(0, GetHashKey("HATES_PLAYER"), GetHashKey("TRUENEUTRAL"))
				SetPedAccuracy(Ped,math.random(getMissionConfigProperty(input, "SetPedMinAccuracy"),getMissionConfigProperty(input, "SetPedMaxAccuracy")))				
				SetPedFleeAttributes(Ped, 0, 0)
				SetPedCombatAttributes(Ped, 5, true)	
				SetPedCombatAttributes(Ped, 16, true)
				SetPedCombatAttributes(Ped, 46, true)
				SetPedCombatAttributes(Ped, 26, true)
				SetPedCombatAttributes(Ped, 3, false)
				SetPedCombatAttributes(Ped, 2, true)
				SetPedCombatAttributes(Ped, 1, true) --can use vehicles	
				SetPedSeeingRange(Ped, 10000.0)
				SetPedHearingRange(Ped, 10000.0)		
				
				--if not getMissionConfigProperty(MissionName, "NerfDriverTurrets") then 
					--SetPedFiringPattern(Ped, 0x914E786F) --FIRING_PATTERN_BURST_FIRE_HELI
				--end 					
				SetPedDropsWeaponsWhenDead(Ped, getMissionConfigProperty(MissionName, "SetPedDropsWeaponsWhenDead"))
				SetPedDiesWhenInjured(Ped, true)
					
				--GIVE WEAPONS TO PED DRIVERS
				GiveWeaponToPed(Ped, randomPedWeaponHash, 2800, false, true)
				SetPedInfiniteAmmo(Ped, true, randomPedWeaponHash)	
				SetPedAlertness(Ped,3)
				ResetAiWeaponDamageModifier()
				SetPedIntoVehicle(Ped, TrailerVehicle, -1)
				DecorSetInt(Ped,"mrpvpedid",33333)
				DecorSetInt(Ped,"mrpvpeddriverid",33333)
				if MissionType=="Assassinate" then --if ped is a target in assassinate
					DecorSetInt(Ped,"mrppedtarget",33333)
				end
				AddArmourToPed(Ped, 100)
				SetPedArmour(Ped, 100)				
				SetAiWeaponDamageModifier(1.0) 				
				
				
				
			end
		end 
	end

end


--specfic mods to arm and amor vehicles that have the option
--https://wiki.rage.mp/index.php?title=Vehicle_Mods

-- FIRING_PATTERN_BURST_FIRE = 0xD6FF6D61 ( 1073727030 ) FIRING_PATTERN_BURST_FIRE_IN_COVER = 0x026321F1 ( 40051185 ) FIRING_PATTERN_BURST_FIRE_DRIVEBY = 0xD31265F2 ( -753768974 ) FIRING_PATTERN_FROM_GROUND = 0x2264E5D6 ( 577037782 ) FIRING_PATTERN_DELAY_FIRE_BY_ONE_SEC = 0x7A845691 ( 2055493265 ) FIRING_PATTERN_FULL_AUTO = 0xC6EE6B4C ( -957453492 ) FIRING_PATTERN_SINGLE_SHOT = 0x5D60E4E0 ( 1566631136 ) FIRING_PATTERN_BURST_FIRE_PISTOL = 0xA018DB8A ( -1608983670 ) FIRING_PATTERN_BURST_FIRE_SMG = 0xD10DADEE ( 1863348768 ) FIRING_PATTERN_BURST_FIRE_RIFLE = 0x9C74B406 ( -1670073338 ) FIRING_PATTERN_BURST_FIRE_MG = 0xB573C5B4 ( -1250703948 ) FIRING_PATTERN_BURST_FIRE_PUMPSHOTGUN = 0x00BAC39B ( 12239771 ) FIRING_PATTERN_BURST_FIRE_HELI = 0x914E786F ( -1857128337 ) FIRING_PATTERN_BURST_FIRE_MICRO = 0x42EF03FD ( 1122960381 ) FIRING_PATTERN_SHORT_BURSTS = 0x1A92D7DF ( 445831135 ) FIRING_PATTERN_SLOW_FIRE_TANK = 0xE2CA3A71 ( -490063247 )  if anyone is interested firing pattern info: pastebin.com/Px036isB
function doVehicleMods(vehiclename,PedVehicle,input) 
	
	

	--also change firing here?
	if(DoesEntityExist(PedVehicle)) then 
	
		if(getMissionConfigProperty(input, "MissionVehicleRandomizeLiveries")) then 
				
			SetVehicleModKit(PedVehicle, 0)
			
			local liveryCount = GetNumVehicleMods(PedVehicle,48)
			
			if liveryCount > 0 then 
				local livery = math.random(1,liveryCount)
				local customWheels = GetVehicleModVariation(PedVehicle, 23)
				SetVehicleMod(PedVehicle, 48,livery, customWheels) 
				--print(vehiclename.." : "..livery)
			end
			
		end
		
		if(getMissionConfigProperty(input, "SetVehicleTyresCanBurst")) then 
			SetVehicleModKit(PedVehicle, 0)
			SetVehicleTyresCanBurst(PedVehicle, true)
		
		else
			SetVehicleModKit(PedVehicle, 0)
			SetVehicleTyresCanBurst(PedVehicle, false)		
		
		end
		
		
		
		if (vehiclename=="pounder2") then
			SetVehicleModKit(PedVehicle, 0)
			local customWheels = GetVehicleModVariation(PedVehicle, 23)
			SetVehicleMod(PedVehicle, 2,0, customWheels) --grenade launcher
			--SetVehicleMod(PedVehicle, 10,1, customWheels)
			SetVehicleMod(PedVehicle, 5,2, customWheels) --armor plating
			SetVehicleMod(PedVehicle, 10,1, customWheels) --missiles
			SetVehicleMod(PedVehicle, 16,4, customWheels) --armor
			SetVehicleMod(PedVehicle, 9,0, customWheels) --proximity mine
			SetVehicleMod(PedVehicle, 0,0, customWheels) --barbed wire
			SetVehicleMod(PedVehicle, 11,3, customWheels) --maxed engine
			return {driverfiringpattern = false,turretfiringpattern = 0x914E786F} --fast grenade launcher
		elseif(vehiclename=="mule4") then
		
			SetVehicleModKit(PedVehicle, 0)
			local customWheels = GetVehicleModVariation(PedVehicle, 23)
			SetVehicleMod(PedVehicle, 1,1, customWheels) --missiles
			SetVehicleMod(PedVehicle, 5,2, customWheels) --armor plating
			SetVehicleMod(PedVehicle, 9,0, customWheels) --proximity mine
			SetVehicleMod(PedVehicle, 10,0, customWheels) --grenade launcher
			SetVehicleMod(PedVehicle, 11,3, customWheels) --maxed engine
			SetVehicleMod(PedVehicle, 16,4, customWheels) --armor

			return {driverfiringpattern = false,turretfiringpattern = 0x914E786F} --fast grenade launcher
			
		elseif(vehiclename=="kuruma2") then
			SetVehicleModKit(PedVehicle, 0)
			local customWheels = GetVehicleModVariation(PedVehicle, 23)
			SetVehicleMod(PedVehicle, 1,0, customWheels)
			SetVehicleMod(PedVehicle, 4,1, customWheels)
			SetVehicleMod(PedVehicle, 4,1, customWheels)
			SetVehicleMod(PedVehicle, 5,0, customWheels)
			SetVehicleMod(PedVehicle, 11,3, customWheels) --maxed engine
			SetVehicleMod(PedVehicle, 16,4, customWheels) --armor	
			SetVehicleMod(PedVehicle, 12,2, customWheels)
			SetVehicleMod(PedVehicle, 13,2, customWheels)		
			
			SetVehicleMod(PedVehicle, 5,2, customWheels) --armor plating
			SetVehicleMod(PedVehicle, 9,0, customWheels) --proximity mine
			SetVehicleMod(PedVehicle, 10,0, customWheels) --grenade launcher
			SetVehicleMod(PedVehicle, 11,3, customWheels) --maxed engine
			SetVehicleMod(PedVehicle, 16,4, customWheels) --armor

			ToggleVehicleMod(PedVehicle, 22, true) --xenon headlights 
			--ToggleVehicleMod(PedVehicle, 18, true) --turbo
			
			--SetVehicleTyresCanBurst(PedVehicle, false)
			
			return {driverfiringpattern = false,turretfiringpattern = 0x914E786F} 
			

		elseif(vehiclename=="rcbandito") then
		
			SetVehicleModKit(PedVehicle, 0)
			local customWheels = GetVehicleModVariation(PedVehicle, 23)
			SetVehicleMod(PedVehicle, 8,0, customWheels) --missiles
			SetVehicleMod(PedVehicle, 11,3, customWheels) --maxed engine
			SetVehicleMod(PedVehicle, 12,2, customWheels) --maxed brakes			
			SetVehicleMod(PedVehicle, 16,4, customWheels) --armor
			SetVehicleMod(PedVehicle, 41,2, customWheels) --jump
			
			SetVehicleMod(PedVehicle, 1,1, customWheels) --missiles
			SetVehicleMod(PedVehicle, 5,2, customWheels) --armor plating
			SetVehicleMod(PedVehicle, 9,0, customWheels) --proximity mine
			SetVehicleMod(PedVehicle, 10,0, customWheels) --grenade launcher
			SetVehicleMod(PedVehicle, 11,3, customWheels) --maxed engine
			SetVehicleMod(PedVehicle, 16,4, customWheels) --armor
			
			ToggleVehicleMod(PedVehicle, 18, true) --turbo		
			
			--SetVehicleTyresCanBurst(PedVehicle, false)

			return {driverfiringpattern = 0xC6EE6B4C,turretfiringpattern = 0xC6EE6B4C}		
			
		elseif (vehiclename=="dune3") then
			SetVehicleModKit(PedVehicle, 0)
			local customWheels = GetVehicleModVariation(PedVehicle, 23)
			SetVehicleMod(PedVehicle, 9,0, customWheels) --proximity mine
			local chance = math.random(1,3) 
			SetVehicleMod(PedVehicle, 11,3, customWheels) --maxed engine
			SetVehicleMod(PedVehicle, 13,2, customWheels) --maxed trans
			SetVehicleMod(PedVehicle, 12,2, customWheels) --maxed brakes
			SetVehicleMod(PedVehicle, 12,2, customWheels) --maxed brakes
			SetVehicleMod(PedVehicle, 16,4, customWheels) --armor
			SetVehicleMod(PedVehicle, 3,1, customWheels) 
			SetVehicleMod(PedVehicle, 5,1, customWheels)
			--SetVehicleMod(PedVehicle, 48,0, customWheels) --livery
			--SetVehicleLivery(PedVehicle,0) --camo
			--ToggleVehicleMod(PedVehicle, 18, true) --turbo		
			if chance == 1 then 
				SetVehicleMod(PedVehicle, 10,0, customWheels) --grenade launcher
				return {false,false} 
			elseif chance == 2 then
				SetVehicleMod(PedVehicle, 10,1, customWheels) --minigun
				return {driverfiringpattern = 0xC6EE6B4C,turretfiringpattern = 0xC6EE6B4C} 
			else --stock 
				return {driverfiringpattern = 0xC6EE6B4C,turretfiringpattern = 0xC6EE6B4C} 
			end
			
		elseif (vehiclename=="stromberg") then
			SetVehicleModKit(PedVehicle, 0)
			local customWheels = GetVehicleModVariation(PedVehicle, 23)
			SetVehicleMod(PedVehicle, 9,0, customWheels) --proximity mine
			local chance = math.random(1,3) 
			SetVehicleMod(PedVehicle, 11,3, customWheels) --maxed engine
			SetVehicleMod(PedVehicle, 13,2, customWheels) --maxed trans
			SetVehicleMod(PedVehicle, 12,2, customWheels) --maxed brakes
			--SetVehicleMod(PedVehicle, 12,2, customWheels) --maxed brakes
			SetVehicleMod(PedVehicle, 16,4, customWheels) --armor
			SetVehicleMod(PedVehicle, 3,1, customWheels) 
			SetVehicleMod(PedVehicle, 5,1, customWheels)
			
			ToggleVehicleMod(PedVehicle, 22, true) --xenon headlights 
			--ToggleVehicleMod(PedVehicle, 18, true) --turbo			
			--SetVehicleMod(PedVehicle, 48,0, customWheels) --livery
			--SetVehicleLivery(PedVehicle,0) --camo
			if chance == 1 then 
				SetVehicleMod(PedVehicle, 10,0, customWheels) --grenade launcher
				return {false,false} 
			elseif chance == 2 then
				SetVehicleMod(PedVehicle, 10,1, customWheels) --minigun
				return {driverfiringpattern = 0xC6EE6B4C,turretfiringpattern = 0xC6EE6B4C} 
			else --stock 
				return {driverfiringpattern = 0xC6EE6B4C,turretfiringpattern = 0xC6EE6B4C} 
			end			

			
		elseif (vehiclename=="apc") then 
		
			SetVehicleModKit(PedVehicle, 0)
			local customWheels = GetVehicleModVariation(PedVehicle, 23)
			
			math.randomseed(GetGameTimer())
			if math.random(1,2) > 1 then 
				SetVehicleMod(PedVehicle, 10,0, customWheels) --SAM Launcher
				return {driverfiringpattern = false,turretfiringpattern = false} --no mods
			else 
				--default 
				return {driverfiringpattern = false,turretfiringpattern = false} --no mods
			end
			
		elseif (vehiclename=="hunter") then 
		
			SetVehicleModKit(PedVehicle, 0)
			local customWheels = GetVehicleModVariation(PedVehicle, 23)
			SetVehicleMod(PedVehicle, 1,0, customWheels) --chaff
			SetVehicleMod(PedVehicle, 9,3, customWheels) --cluster bombs
			SetVehicleMod(PedVehicle, 10,0, customWheels) --explosive turret	
			SetVehicleMod(PedVehicle, 11,3, customWheels) --maxed engine
			SetVehicleMod(PedVehicle, 16,4, customWheels) --armor			
			
			OpenVehicleBombBay(PedVehicle) --does it really drop bombs?
			return {driverfiringpattern = 0xE2CA3A71,turretfiringpattern = 0xE2CA3A71} --slow tank
			
		elseif (vehiclename=="akula") then 
		
			SetVehicleModKit(PedVehicle, 0)
			local customWheels = GetVehicleModVariation(PedVehicle, 23)
			--dont work:
			--SetVehicleMod(PedVehicle, 5,1, customWheels) --homing missiles
			--SetVehicleMod(PedVehicle, 1,0, customWheels) --chaff
			SetVehicleMod(PedVehicle, 9,3, customWheels) --cluster bombs
			if math.random(1,2) > 1 then 
				SetVehicleMod(PedVehicle, 10,0, customWheels) --dual mini	
			end
			SetVehicleMod(PedVehicle, 11,3, customWheels) --maxed engine
			SetVehicleMod(PedVehicle, 16,4, customWheels) --armor			
			
			OpenVehicleBombBay(PedVehicle) --does it really drop bombs?
			return {driverfiringpattern = 0x914E786F,turretfiringpattern = 0x914E786F}

		elseif (vehiclename=="avenger") then 
			--turrets do not work...no seatids > 1?
			SetVehicleModKit(PedVehicle, 0)
			local customWheels = GetVehicleModVariation(PedVehicle, 23)
			SetVehicleMod(PedVehicle, 1,0, customWheels) --chaff
			SetVehicleMod(PedVehicle, 9,3, customWheels) --cluster bombs
			
			SetVehicleMod(PedVehicle, 10,1, customWheels) --all turrets
		
			SetVehicleMod(PedVehicle, 11,3, customWheels) --maxed engine
			SetVehicleMod(PedVehicle, 16,4, customWheels) --armor			
			
			OpenVehicleBombBay(PedVehicle) --does it really drop bombs?
			return {driverfiringpattern = 0x914E786F,turretfiringpattern = 0x914E786F}		
						
		elseif (vehiclename=="strikeforce") then 
			
			SetVehicleModKit(PedVehicle, 0)
			local customWheels = GetVehicleModVariation(PedVehicle, 23)
			SetVehicleMod(PedVehicle, 1,0, customWheels) --chaff
			SetVehicleMod(PedVehicle, 9,3, customWheels) --cluster bombs
			
			SetVehicleMod(PedVehicle, 10,1, customWheels) --all turrets
		
			SetVehicleMod(PedVehicle, 11,3, customWheels) --maxed engine
			SetVehicleMod(PedVehicle, 16,4, customWheels) --armor			
			
			--OpenVehicleBombBay(PedVehicle) --does it really drop bombs?
			return {driverfiringpattern = 0xC6EE6B4C,turretfiringpattern = 0xC6EE6B4C}					
		
		elseif (vehiclename=="brutus") then 
			SetVehicleModKit(PedVehicle, 0)
			local customWheels = GetVehicleModVariation(PedVehicle, 23)
			SetVehicleMod(PedVehicle, 1,2, customWheels) 
			SetVehicleMod(PedVehicle, 2,2, customWheels) 
			SetVehicleMod(PedVehicle, 3,1, customWheels) 
			SetVehicleMod(PedVehicle, 5,2, customWheels) 
			SetVehicleMod(PedVehicle, 6,1, customWheels)
			SetVehicleMod(PedVehicle, 7,2, customWheels)
			SetVehicleMod(PedVehicle, 8,1, customWheels)
			SetVehicleMod(PedVehicle, 9,0, customWheels)
			SetVehicleMod(PedVehicle, 10,3, customWheels)
			SetVehicleMod(PedVehicle, 42,3, customWheels)
			SetVehicleMod(PedVehicle, 45,1, customWheels) --50 cal
			SetVehicleMod(PedVehicle, 11,3, customWheels) --maxed engine
			SetVehicleMod(PedVehicle, 16,4, customWheels) --armor
			return {driverfiringpattern = 0xC6EE6B4C,turretfiringpattern = 0xC6EE6B4C} --driver is default
		elseif (vehiclename=="nightshark") then 
			SetVehicleModKit(PedVehicle, 0)
			local customWheels = GetVehicleModVariation(PedVehicle, 23)
			SetVehicleMod(PedVehicle, 16,4, customWheels) --armor
			SetVehicleMod(PedVehicle, 11,3, customWheels) --maxed engine
			return {driverfiringpattern = 0xC6EE6B4C,turretfiringpattern = 0xC6EE6B4C} --driver is default			
		elseif (vehiclename=="bruiser") then 
			SetVehicleModKit(PedVehicle, 0)
			local customWheels = GetVehicleModVariation(PedVehicle, 23)
			SetVehicleMod(PedVehicle, 45,0, customWheels) --50 cal
			SetVehicleMod(PedVehicle, 16,4, customWheels) --armor
			SetVehicleMod(PedVehicle, 5,2, customWheels) --armor plating
			SetVehicleMod(PedVehicle, 6,2, customWheels) --armor plating
			SetVehicleMod(PedVehicle, 7,8, customWheels) --armor plating
			SetVehicleMod(PedVehicle, 9,0, customWheels) --kinetic
			SetVehicleMod(PedVehicle, 10,2, customWheels) --armor plating
			SetVehicleMod(PedVehicle, 11,3, customWheels) --maxed engine
			SetVehicleMod(PedVehicle, 42,3, customWheels) --scoop
			return {driverfiringpattern = 0xC6EE6B4C,turretfiringpattern = 0xC6EE6B4C} 	
		elseif (vehiclename=="dominator4") then 
			SetVehicleModKit(PedVehicle, 0)
			local customWheels = GetVehicleModVariation(PedVehicle, 23)
			SetVehicleMod(PedVehicle, 45,1, customWheels) --50 cal
			SetVehicleMod(PedVehicle, 16,4, customWheels) --armor
			SetVehicleMod(PedVehicle, 42,1, customWheels) --scoop
			SetVehicleMod(PedVehicle, 9,0, customWheels) --kinetic
			SetVehicleMod(PedVehicle, 11,3, customWheels) --maxed engine
			SetVehicleMod(PedVehicle, 5,2, customWheels) --armor plating
			SetVehicleMod(PedVehicle, 7,1, customWheels) --armor plating
			SetVehicleMod(PedVehicle, 6,5, customWheels) --armor plating
		
			return {driverfiringpattern = 0xC6EE6B4C,turretfiringpattern = 0xC6EE6B4C}
		elseif (vehiclename=="impaler2") then 
			SetVehicleModKit(PedVehicle, 0)
			local customWheels = GetVehicleModVariation(PedVehicle, 23)
			SetVehicleMod(PedVehicle, 45,1, customWheels) --50 cal
			SetVehicleMod(PedVehicle, 0,1, customWheels) --armor plating
			SetVehicleMod(PedVehicle, 5,2, customWheels) --armor plating
			SetVehicleMod(PedVehicle, 7,1, customWheels) --armor plating
			SetVehicleMod(PedVehicle, 10,0, customWheels) --armor plating
			SetVehicleMod(PedVehicle, 11,3, customWheels) --maxed engine
			SetVehicleMod(PedVehicle, 9,0, customWheels) --kinetic
			SetVehicleMod(PedVehicle, 16,4, customWheels) --armor
			SetVehicleMod(PedVehicle, 42,0, customWheels) --scoop
		
			return {driverfiringpattern = 0xC6EE6B4C,turretfiringpattern = 0xC6EE6B4C}
		elseif (vehiclename=="imperator") then 
			SetVehicleModKit(PedVehicle, 0)
			local customWheels = GetVehicleModVariation(PedVehicle, 23)
			SetVehicleMod(PedVehicle, 45,1, customWheels) --50 cal
			SetVehicleMod(PedVehicle, 4,0, customWheels)
			SetVehicleMod(PedVehicle, 5,2, customWheels) --armor plating
			SetVehicleMod(PedVehicle, 7,0, customWheels)
			SetVehicleMod(PedVehicle, 9,0, customWheels) --kinetic
			SetVehicleMod(PedVehicle, 10,0, customWheels) --kinetic mortar
			SetVehicleMod(PedVehicle, 11,3, customWheels) --maxed engine
			SetVehicleMod(PedVehicle, 42,0, customWheels) --scoop
			SetVehicleMod(PedVehicle, 16,4, customWheels) --armor
			
			return {driverfiringpattern = 0xC6EE6B4C,turretfiringpattern = 0xC6EE6B4C} 
		
		elseif (vehiclename=="zr380") then 
			SetVehicleModKit(PedVehicle, 0)
			local customWheels = GetVehicleModVariation(PedVehicle, 23)
			SetVehicleMod(PedVehicle, 16,4, customWheels) --armor
			SetVehicleMod(PedVehicle, 45,1, customWheels) --50 cal
			SetVehicleMod(PedVehicle, 1,0, customWheels) 
			SetVehicleMod(PedVehicle, 2,0, customWheels) 
			SetVehicleMod(PedVehicle, 7,4, customWheels) 
			SetVehicleMod(PedVehicle, 8,1, customWheels) 
			SetVehicleMod(PedVehicle, 9,0, customWheels) --kinetic
			SetVehicleMod(PedVehicle, 11,3, customWheels) --maxed engine
			
			return {driverfiringpattern = 0xC6EE6B4C,turretfiringpattern = 0xC6EE6B4C} 			
			
		elseif (vehiclename=="issi4") then 
			SetVehicleModKit(PedVehicle, 0)
			local customWheels = GetVehicleModVariation(PedVehicle, 23)
			SetVehicleMod(PedVehicle, 16,4, customWheels) --armor
			SetVehicleMod(PedVehicle, 0,1, customWheels) --armor plating
			SetVehicleMod(PedVehicle, 1,2, customWheels) --armor plating
			SetVehicleMod(PedVehicle, 3,1, customWheels) --armor plating
			SetVehicleMod(PedVehicle, 4,3, customWheels) --armor plating
			SetVehicleMod(PedVehicle, 5,2, customWheels) --armor plating
			SetVehicleMod(PedVehicle, 6,3, customWheels) --armor plating
			SetVehicleMod(PedVehicle, 9,0, customWheels) --kinetic
			SetVehicleMod(PedVehicle, 10,0, customWheels) --kinetic mortar
			SetVehicleMod(PedVehicle, 11,3, customWheels) --maxed engine
			SetVehicleMod(PedVehicle, 45,1, customWheels) --50 cal
			return {driverfiringpattern = 0xC6EE6B4C,turretfiringpattern = 0xC6EE6B4C} 		
			
		elseif (vehiclename=="technical3") then 
			SetVehicleModKit(PedVehicle, 0)
			local customWheels = GetVehicleModVariation(PedVehicle, 23)
			SetVehicleMod(PedVehicle, 10,0, customWheels) --50 cal minigun?	
			SetVehicleMod(PedVehicle, 16,4, customWheels) --armor
			--SetVehicleMod(PedVehicle, 5,2, customWheels) --armor plating
			SetVehicleMod(PedVehicle, 6,2, customWheels) --armor plating
			SetVehicleMod(PedVehicle, 9,0, customWheels) --prox mine
			return {driverfiringpattern = 0xC6EE6B4C,turretfiringpattern = 0xC6EE6B4C}
		elseif (vehiclename=="deluxo") then 
			SetVehicleModKit(PedVehicle, 0)
			local customWheels = GetVehicleModVariation(PedVehicle, 23)
			SetVehicleMod(PedVehicle, 0,6, customWheels)
			SetVehicleMod(PedVehicle, 1,2, customWheels)
			SetVehicleMod(PedVehicle, 3,1, customWheels)
			SetVehicleMod(PedVehicle, 4,2, customWheels)
			SetVehicleMod(PedVehicle, 7,2, customWheels)
			--SetVehicleMod(PedVehicle, 10,0, customWheels) --disable weapons	
			SetVehicleMod(PedVehicle, 11,3, customWheels) --maxed engine
			SetVehicleMod(PedVehicle, 16,4, customWheels) --armor
			return {driverfiringpattern = false,turretfiringpattern = false}			
		elseif (vehiclename=="thruster") then --thruster ped does not use weapons
			SetVehicleModKit(PedVehicle, 0)
			local customWheels = GetVehicleModVariation(PedVehicle, 23)
			SetVehicleMod(PedVehicle, 10,1, customWheels) --missiles
			SetVehicleMod(PedVehicle, 1,0, customWheels) --chaff
			SetVehicleMod(PedVehicle, 4,0, customWheels) 
			SetVehicleMod(PedVehicle, 11,3, customWheels) --maxed engine
			SetVehicleMod(PedVehicle, 16,4, customWheels) --armor
			SetVehicleMod(PedVehicle, 12,2, customWheels) --brakes
			
			return {driverfiringpattern = false,turretfiringpattern = 0x914E786F} --driver is default
		elseif (vehiclename=="bombushka") then 
			SetVehicleModKit(PedVehicle, 0)
			local customWheels = GetVehicleModVariation(PedVehicle, 23)	
			SetVehicleMod(PedVehicle, 5,2, customWheels) --armor plating
			SetVehicleMod(PedVehicle, 1,0, customWheels) --chaff
			SetVehicleMod(PedVehicle, 5,0, customWheels) --30mm explosive rounds
			SetVehicleMod(PedVehicle, 9,3, customWheels) --cluster bombs
			SetVehicleMod(PedVehicle, 10,0, customWheels) --30mm explosive rounds
			SetVehicleMod(PedVehicle, 11,3, customWheels) --maxed engine
			SetVehicleMod(PedVehicle, 16,4, customWheels) --armor
			--OpenVehicleBombBay(PedVehicle) --does it really drop bombs?
			return {driverfiringpattern = 0xE2CA3A71,turretfiringpattern = 0xE2CA3A71} --slow tank
		elseif (vehiclename=="volatol") then 
			SetVehicleModKit(PedVehicle, 0)
			local customWheels = GetVehicleModVariation(PedVehicle, 23)	
			SetVehicleMod(PedVehicle, 1,0, customWheels) --chaff
			SetVehicleMod(PedVehicle, 9,3, customWheels) --cluster bombs
			SetVehicleMod(PedVehicle, 11,3, customWheels) --maxed engine
			SetVehicleMod(PedVehicle, 16,4, customWheels) --armor
			--OpenVehicleBombBay(PedVehicle) --does it really drop bombs?
			--full auto OTT?
			return {driverfiringpattern = 0xC6EE6B4C,turretfiringpattern = 0xC6EE6B4C} --heli			
			
		elseif (vehiclename=="trailerlarge") then
			SetVehicleModKit(PedVehicle, 0)
			local customWheels = GetVehicleModVariation(PedVehicle, 23)	
			SetVehicleMod(PedVehicle, 10,1, customWheels)
			SetVehicleMod(PedVehicle, 16,4, customWheels)
			return {driverfiringpattern = 0xC6EE6B4C,turretfiringpattern = 0xC6EE6B4C} --full auto 
		elseif (vehiclename=="cerberus") then
			SetVehicleModKit(PedVehicle, 0)
			local customWheels = GetVehicleModVariation(PedVehicle, 23)	
			SetVehicleMod(PedVehicle, 10,0, customWheels)
			SetVehicleMod(PedVehicle, 16,4, customWheels)
			SetVehicleMod(PedVehicle, 9,0, customWheels) --kinetic
			SetVehicleMod(PedVehicle, 4,6, customWheels) --exhaust
			return {driverfiringpattern = 0xC6EE6B4C,turretfiringpattern = 0xC6EE6B4C} --full auto 	
		elseif (vehiclename=="deathbike") then
			SetVehicleModKit(PedVehicle, 0)
			local customWheels = GetVehicleModVariation(PedVehicle, 23)	
			SetVehicleMod(PedVehicle, 5,2, customWheels) --plated armor
			SetVehicleMod(PedVehicle, 16,4, customWheels)
			SetVehicleMod(PedVehicle, 27,0, customWheels) --blades
			SetVehicleMod(PedVehicle, 45,0, customWheels) --2 miniguns
			return {driverfiringpattern = 0xC6EE6B4C,turretfiringpattern = 0xC6EE6B4C} 
		elseif (vehiclename=="oppressor") then
			SetVehicleModKit(PedVehicle, 0)
			local customWheels = GetVehicleModVariation(PedVehicle, 23)	
			SetVehicleMod(PedVehicle, 16,4, customWheels)
			SetVehicleMod(PedVehicle, 10,0, customWheels) --missiles
			SetVehicleMod(PedVehicle, 11,3, customWheels) --maxed engine
			return {driverfiringpattern = false,turretfiringpattern = false} 
		
		elseif (vehiclename=="scarab") then
			SetVehicleModKit(PedVehicle, 0)
			local customWheels = GetVehicleModVariation(PedVehicle, 23)	
			SetVehicleMod(PedVehicle, 16,4, customWheels)
			SetVehicleMod(PedVehicle, 1,6, customWheels) 
			SetVehicleMod(PedVehicle, 3,10, customWheels) 
			SetVehicleMod(PedVehicle, 5,2, customWheels) 
			--SetVehicleMod(PedVehicle, 5,2, customWheels) 
			SetVehicleMod(PedVehicle, 6,1, customWheels) 
			SetVehicleMod(PedVehicle, 9,0, customWheels) --kinetic
			SetVehicleMod(PedVehicle, 10,6, customWheels) 
			SetVehicleMod(PedVehicle, 11,3, customWheels) --maxed engine
			SetVehicleMod(PedVehicle, 41,2, customWheels) 
			SetVehicleMod(PedVehicle, 45,1, customWheels) --50 cal
			
			return {driverfiringpattern = 0xC6EE6B4C,turretfiringpattern = 0xC6EE6B4C} 			
		
		elseif (vehiclename=="slamvan4") then
			SetVehicleModKit(PedVehicle, 0)
			local customWheels = GetVehicleModVariation(PedVehicle, 23)	
			SetVehicleMod(PedVehicle, 16,4, customWheels)
			SetVehicleMod(PedVehicle, 2,2, customWheels) 
			SetVehicleMod(PedVehicle, 5,1, customWheels) 
			SetVehicleMod(PedVehicle, 6,0, stomWheels) 
			SetVehicleMod(PedVehicle, 9,0, customWheels) --kinetic
			SetVehicleMod(PedVehicle, 45,1, customWheels) --50 cal
			SetVehicleMod(PedVehicle, 11,3, customWheels) --maxed engine
			SetVehicleMod(PedVehicle, 41,2, customWheels) 
			
			return {driverfiringpattern = 0xC6EE6B4C,turretfiringpattern = 0xC6EE6B4C} 

		elseif (vehiclename=="speedo4") then
			SetVehicleModKit(PedVehicle, 0)
			local customWheels = GetVehicleModVariation(PedVehicle, 23)	
			SetVehicleMod(PedVehicle, 16,4, customWheels)
			SetVehicleMod(PedVehicle, 5,2, customWheels) 
			SetVehicleMod(PedVehicle, 9,0, customWheels) --prox mine
			SetVehicleMod(PedVehicle, 11,3, customWheels) --maxed engine
			
			
			if math.random(1,2) > 1 then 
				SetVehicleMod(PedVehicle, 10,1, customWheels) --50 cal
				return {driverfiringpattern = 0xC6EE6B4C,turretfiringpattern = 0xC6EE6B4C} 
			else 
				SetVehicleMod(PedVehicle, 10,2, customWheels) --minigun
				return {driverfiringpattern = 0xC6EE6B4C,turretfiringpattern = 0xC6EE6B4C} 
			end			
			
			
			SetVehicleMod(PedVehicle, 2,2, customWheels) 
			SetVehicleMod(PedVehicle, 5,1, customWheels) 
			SetVehicleMod(PedVehicle, 6,0, stomWheels) 
			SetVehicleMod(PedVehicle, 9,0, customWheels) --kinetic
			SetVehicleMod(PedVehicle, 45,1, customWheels) --50 cal
			SetVehicleMod(PedVehicle, 11,3, customWheels) --maxed engine
			SetVehicleMod(PedVehicle, 41,2, customWheels) 
			
			return {driverfiringpattern = 0x914E786F,turretfiringpattern = 0x914E786F} 						

		elseif (vehiclename=="oppressor2") then
			SetVehicleModKit(PedVehicle, 0)
			local customWheels = GetVehicleModVariation(PedVehicle, 23)	
			
			SetVehicleMod(PedVehicle, 16,4, customWheels)
			SetVehicleMod(PedVehicle, 11,3, customWheels) --maxed engine
			
			SetVehicleMod(PedVehicle, 6,0, customWheels) --chaff
			
			if math.random(1,2) > 1 then 
				SetVehicleMod(PedVehicle, 10,0, customWheels) --explosive MG
				return {driverfiringpattern = false,turretfiringpattern = false} 
			else 
				--default 
				SetVehicleMod(PedVehicle, 10,1, customWheels) --missiles
				return {driverfiringpattern = false,turretfiringpattern = false} 
			end			
			
			
			return {driverfiringpattern = false,turretfiringpattern = false}

		elseif (vehiclename=="halftrack") then
			SetVehicleModKit(PedVehicle, 0)
			local customWheels = GetVehicleModVariation(PedVehicle, 23)	
			
			SetVehicleMod(PedVehicle, 16,4, customWheels)
			SetVehicleMod(PedVehicle, 11,3, customWheels) --maxed engine
			SetVehicleMod(PedVehicle, 5,2, customWheels) 
			
			if math.random(1,2) > 1 then 
				SetVehicleMod(PedVehicle, 10,0, customWheels) --quad guns
				return {driverfiringpattern = 0x914E786F,turretfiringpattern = 0x914E786F} 
			else 
				return {driverfiringpattern = 0x914E786F,turretfiringpattern = 0x914E786F} 
			end

		elseif (vehiclename=="insurgent3") then
			SetVehicleModKit(PedVehicle, 0)
			local customWheels = GetVehicleModVariation(PedVehicle, 23)	
			
			SetVehicleMod(PedVehicle, 16,4, customWheels)
			SetVehicleMod(PedVehicle, 11,3, customWheels) --maxed engine
			SetVehicleMod(PedVehicle, 5,2, customWheels) 
			
			if math.random(1,2) > 1 then 
				SetVehicleMod(PedVehicle, 10,0, customWheels) --quad guns
				return {driverfiringpattern = 0x914E786F,turretfiringpattern = 0x914E786F} 
			else 
				return {driverfiringpattern = 0x914E786F,turretfiringpattern = 0x914E786F} 
			end			
												
		elseif (vehiclename=="trailersmall2") then
			SetVehicleModKit(PedVehicle, 0)
			local customWheels = GetVehicleModVariation(PedVehicle, 23)	
			SetVehicleMod(PedVehicle, 10,1, customWheels) --flak rounds
			SetVehicleMod(PedVehicle, 16,4, customWheels) --armor
			return {driverfiringpattern = 0xC6EE6B4C,turretfiringpattern = 0xC6EE6B4C} --full auto

		elseif (vehiclename=="havok") then
			--does not shoot for NPCs
			SetVehicleModKit(PedVehicle, 0)
			local customWheels = GetVehicleModVariation(PedVehicle, 23)	
			SetVehicleMod(PedVehicle, 1,0, customWheels) --chaff
			SetVehicleMod(PedVehicle, 10,0, customWheels) --50 cal
			SetVehicleMod(PedVehicle, 16,4, customWheels) --armor
			SetVehicleMod(PedVehicle, 11,3, customWheels) --maxed engine
			return {driverfiringpattern = 0xC6EE6B4C,turretfiringpattern =  0xC6EE6B4C} --full auto 
			
		elseif (vehiclename=="microlight") then
			--does not shoot for NPCs
			SetVehicleModKit(PedVehicle, 0)
			local customWheels = GetVehicleModVariation(PedVehicle, 23)	
			SetVehicleMod(PedVehicle, 1,0, customWheels) --chaff
			SetVehicleMod(PedVehicle, 10,0, customWheels) --guns
			SetVehicleMod(PedVehicle, 16,4, customWheels) --armor
			SetVehicleMod(PedVehicle, 11,3, customWheels) --maxed engine
			return {driverfiringpattern = 0xC6EE6B4C,turretfiringpattern =  0xC6EE6B4C} --full auto 			
			

		elseif (vehiclename=="starling") then
			SetVehicleModKit(PedVehicle, 0)
			local customWheels = GetVehicleModVariation(PedVehicle, 23)	
			SetVehicleMod(PedVehicle, 1,0, customWheels) --chaff
			SetVehicleMod(PedVehicle, 4,0, customWheels)
			SetVehicleMod(PedVehicle, 10,0, customWheels) --homing missiles
			SetVehicleMod(PedVehicle, 16,4, customWheels) --armor
			SetVehicleMod(PedVehicle, 11,3, customWheels) --maxed engine
			return {driverfiringpattern = 0xC6EE6B4C,turretfiringpattern =  0xC6EE6B4C} --full auto 				
 		elseif (vehiclename=="mogul") then
			SetVehicleModKit(PedVehicle, 0)
			local customWheels = GetVehicleModVariation(PedVehicle, 23)	
			SetVehicleMod(PedVehicle, 1,0, customWheels) --chaff
			SetVehicleMod(PedVehicle, 5,0, customWheels) --dual machine guns
			SetVehicleMod(PedVehicle, 10,0, customWheels) --turret
			SetVehicleMod(PedVehicle, 16,4, customWheels) --armor
			SetVehicleMod(PedVehicle, 11,3, customWheels) --maxed engine
			return {driverfiringpattern = 0xC6EE6B4C,turretfiringpattern =  0xC6EE6B4C} --full auto 
		elseif (vehiclename=="rogue") then
			SetVehicleModKit(PedVehicle, 0)
			local customWheels = GetVehicleModVariation(PedVehicle, 23)	
			SetVehicleMod(PedVehicle, 1,0, customWheels) --chaff
			SetVehicleMod(PedVehicle, 16,4, customWheels) --armor
			SetVehicleMod(PedVehicle, 11,3, customWheels) --maxed engine
			
			
			SetVehicleMod(PedVehicle, 5,0, customWheels) --homing missiles
			return {driverfiringpattern = 0xC6EE6B4C,turretfiringpattern =  0xC6EE6B4C} --full auto 		
			
			
			--SetVehicleMod(PedVehicle, 10,1, customWheels) --
			--return {driverfiringpattern = 0xC6EE6B4C,turretfiringpattern =  0xC6EE6B4C} --full auto 			
			
		elseif (vehiclename=="nokota") then
			SetVehicleModKit(PedVehicle, 0)
			local customWheels = GetVehicleModVariation(PedVehicle, 23)	
			SetVehicleMod(PedVehicle, 1,0, customWheels) --chaff
			SetVehicleMod(PedVehicle, 10,0, customWheels) --homing missiles
			SetVehicleMod(PedVehicle, 16,4, customWheels) --armor
			SetVehicleMod(PedVehicle, 11,3, customWheels) --maxed engine
			return {driverfiringpattern = 0xC6EE6B4C,turretfiringpattern =  0xC6EE6B4C} --full auto
		elseif (vehiclename=="molotok") then
			--works but pilot flys over unless it hears something
			SetVehicleModKit(PedVehicle, 0)
			local customWheels = GetVehicleModVariation(PedVehicle, 23)	
			SetVehicleMod(PedVehicle, 1,0, customWheels) --chaff
			SetVehicleMod(PedVehicle, 10,0, customWheels) --homing missiles
			SetVehicleMod(PedVehicle, 16,4, customWheels) --armor
			SetVehicleMod(PedVehicle, 11,3, customWheels) --maxed engine
			return {driverfiringpattern = 0xC6EE6B4C,turretfiringpattern =  0xC6EE6B4C} --full auto			
		elseif (vehiclename=="tula") then
			SetVehicleModKit(PedVehicle, 0)
			local customWheels = GetVehicleModVariation(PedVehicle, 23)	
			SetVehicleMod(PedVehicle, 1,0, customWheels) --chaff
			SetVehicleMod(PedVehicle, 10,1, customWheels) --7.62 turret
			SetVehicleMod(PedVehicle, 16,4, customWheels) --armor
			SetVehicleMod(PedVehicle, 11,3, customWheels) --maxed engine
			--put these on full auto, and it is a little OTT?
			return {driverfiringpattern = 0xC6EE6B4C,turretfiringpattern =  0xC6EE6B4C} --heli 			
		elseif (vehiclename=="pyro") then
			SetVehicleModKit(PedVehicle, 0)
			local customWheels = GetVehicleModVariation(PedVehicle, 23)	
			SetVehicleMod(PedVehicle, 1,0, customWheels) --chaff
			SetVehicleMod(PedVehicle, 10,0, customWheels) --homing missiles
			SetVehicleMod(PedVehicle, 16,4, customWheels) --armor
			SetVehicleMod(PedVehicle, 11,3, customWheels) --maxed engine
			return {driverfiringpattern = 0xC6EE6B4C,turretfiringpattern =  0xC6EE6B4C} --full auto 
		elseif (vehiclename=="seasparrow") then
			--does not shoot for NPCs
			SetVehicleModKit(PedVehicle, 0)
			local customWheels = GetVehicleModVariation(PedVehicle, 23)	
			SetVehicleMod(PedVehicle, 10,0, customWheels) --50 cal
			SetVehicleMod(PedVehicle, 16,4, customWheels) --armor
			SetVehicleMod(PedVehicle, 11,3, customWheels) --maxed engine
			return {driverfiringpattern = 0x914E786F,turretfiringpattern = 0x914E786F} --full auto
		elseif (vehiclename=="seabreeze") then
			SetVehicleModKit(PedVehicle, 0)
			local customWheels = GetVehicleModVariation(PedVehicle, 23)	
			SetVehicleMod(PedVehicle, 1,0, customWheels) --chaff
			SetVehicleMod(PedVehicle, 10,0, customWheels) --machine guns
			SetVehicleMod(PedVehicle, 16,4, customWheels) --armor
			SetVehicleMod(PedVehicle, 11,3, customWheels) --maxed engine
			return {driverfiringpattern = 0xC6EE6B4C,turretfiringpattern =  0xC6EE6B4C} --full auto  			
			
		elseif (vehiclename=="boxville5") then 
			return {driverfiringpattern = 0xC6EE6B4C,turretfiringpattern = 0xC6EE6B4C} 
		elseif (vehiclename=="blazer5") then 
			return {driverfiringpattern = 0xC6EE6B4C,turretfiringpattern = 0xC6EE6B4C} 			
		elseif (vehiclename=="valkyrie") then 
			return {driverfiringpattern = 0x914E786F,turretfiringpattern = 0x914E786F} --valkyrie cannon gets nerfed via Config.NerfValkyrieHelicopterCannon 
		elseif (vehiclename=="valkyrie2") then 
			return {driverfiringpattern = false,turretfiringpattern = 0x914E786F} --fast turrets		
		elseif (vehiclename=="rhino") then 
				return {driverfiringpattern = false,turretfiringpattern = false} --default
		elseif (vehiclename=="lazer") then 
				return {driverfiringpattern = 0xC6EE6B4C,turretfiringpattern = 0xC6EE6B4C} --full auto				
		elseif (vehiclename=="hydra") then 
				return {driverfiringpattern = 0xC6EE6B4C,turretfiringpattern = 0xC6EE6B4C} --full auto
		elseif (vehiclename=="technical") then 
				return {driverfiringpattern = 0xC6EE6B4C,turretfiringpattern = 0xC6EE6B4C}
		elseif (vehiclename=="technical2") then 
				return {driverfiringpattern = 0xC6EE6B4C,turretfiringpattern = 0xC6EE6B4C}	
		elseif (vehiclename=="limo2") then 
				return {driverfiringpattern = 0xC6EE6B4C,turretfiringpattern = 0xC6EE6B4C}					
		elseif (vehiclename=="caracara") then 
				return {driverfiringpattern = 0xC6EE6B4C,turretfiringpattern = 0xC6EE6B4C}		
		elseif (vehiclename=="insurgent") then 
				return {driverfiringpattern = false,turretfiringpattern = 0x914E786F}
		elseif (vehiclename=="predator") then 
				return {driverfiringpattern = false,turretfiringpattern = 0x914E786F}
		elseif (vehiclename=="khanjali") then 
				SetVehicleMod(PedVehicle, 16,4, customWheels) --armor
				SetVehicleMod(PedVehicle, 11,3, customWheels) --maxed engine
				SetVehicleMod(PedVehicle, 5,0, customWheels) 
				SetVehicleMod(PedVehicle, 9,0, customWheels) 
				if math.random(1,2) > 1 then 
					SetVehicleMod(PedVehicle, 10,0, customWheels) --rail cannon
				end				
				return {driverfiringpattern = false,turretfiringpattern = 0xC6EE6B4C}				
		elseif (vehiclename=="menacer") then
			SetVehicleModKit(PedVehicle, 0)
			local customWheels = GetVehicleModVariation(PedVehicle, 23)	
			SetVehicleMod(PedVehicle, 16,4, customWheels) --armor	
			SetVehicleMod(PedVehicle, 11,3, customWheels) --maxed engine
			if math.random(1,2) > 1 then 
				SetVehicleMod(PedVehicle, 5,0, customWheels) --minigun
			end
			return {driverfiringpattern = false,turretfiringpattern = 0x914E786F} 
		elseif (vehiclename=="barrage") then
			SetVehicleModKit(PedVehicle, 0)
			local customWheels = GetVehicleModVariation(PedVehicle, 23)	
			SetVehicleMod(PedVehicle, 16,4, customWheels) --armor	
			SetVehicleMod(PedVehicle, 11,3, customWheels) --maxed engine
			local chance = math.random(1,3)
			if chance == 2 then 
				SetVehicleMod(PedVehicle, 0,0, customWheels) --minigun
			elseif chance ==3 then 
				SetVehicleMod(PedVehicle, 0,1, customWheels) --g. launcher
			end
			Wait(1)
			math.randomseed(GetGameTimer())
			local chance = math.random(1,2)
			if chance > 1 then 
				SetVehicleMod(PedVehicle, 10,0, customWheels) --minigun
			end
			
			return {driverfiringpattern = false,turretfiringpattern = 0x914E786F}
		
		elseif (vehiclename=="tampa3") then
			SetVehicleModKit(PedVehicle, 0)
			local customWheels = GetVehicleModVariation(PedVehicle, 23)	
			SetVehicleMod(PedVehicle, 16,4, customWheels) --armor	
			SetVehicleMod(PedVehicle, 11,3, customWheels) --maxed engine
			--SetVehicleMod(PedVehicle, 2,0, customWheels) --rear mortar
			SetVehicleMod(PedVehicle, 5,2, customWheels) 
			SetVehicleMod(PedVehicle, 7,2, customWheels) 
			local chance = math.random(1,2)
			if chance == 2 then 
				SetVehicleMod(PedVehicle, 1,0, customWheels) --front missiles
				return {driverfiringpattern = false,turretfiringpattern = false} 	
			end
			--Wait(1)
			--math.randomseed(GetGameTimer())
			--local chance = math.random(1,2)
			--if chance == 2 then 
				SetVehicleMod(PedVehicle, 10,0, customWheels) --dual minigun
			--end
			
			return {driverfiringpattern = 0xC6EE6B4C,turretfiringpattern = 0xC6EE6B4C} 	

		end
	end
	
		--return {driverfiringpattern = false,turretfiringpattern = false}
		return {driverfiringpattern = 0xC6EE6B4C,turretfiringpattern = 0xC6EE6B4C} --return full auto by default
		--{driver fire pattern, passenger turret/cannon fire pattern}
end

--give boss special rounds like incendiary, fmj or explosive
--DIFFERENT AMMO TYPES NOT WORKING, JUST GIVE THEM MINIGUN,RAILGUN ETC.. FOR NOW
function doBossBuff(Ped,modelHash,MissionName,bossWeapon)
	--local weapon = "weapon_heavysniper_mk2"
	
	--local component = "COMPONENT_HEAVYSNIPER_MK2_CLIP_EXPLOSIVE"
	--local component_remove = "COMPONENT_HEAVYSNIPER_MK2_CLIP_01"
	
	--bossWeapon will already be hashed.
	local weapon = bossWeapon
	
	if not bossWeapon then 
		if modelHash=="u_m_y_juggernaut_01" then 
			SetPedPropIndex(Ped, 0, 0, 0, 1)
			Wait(1)
			math.randomseed(GetGameTimer())
			local chance = math.random(1,100)
			if chance <= 50 then 
				--weapon = "weapon_heavysniper_mk2"
				--component = "COMPONENT_HEAVYSNIPER_MK2_CLIP_EXPLOSIVE
			--weapon ="weapon_rayminigun"
			weapon ="weapon_railgun"
			elseif chance > 50 then
				--weapon = "weapon_smg_mk2"
				--component = "COMPONENT_SMG_MK2_CLIP_HOLLOWPOINT"
				weapon ="weapon_rayminigun"
			end
			SetPedCanRagdoll(Ped, false)
			SetAmbientVoiceName(Ped, "ALIENS")
			DisablePedPainAudio(Ped,true)

		elseif modelHash == "s_m_m_movalien_01" then 
			SetPedDefaultComponentVariation(Ped)
			Wait(1)
			math.randomseed(GetGameTimer())
			local chance = math.random(1,100)
			if chance <= 25 then 
			--weapon ="weapon_rayminigun"
			weapon ="weapon_raypistol"
			elseif chance > 25 and chance <= 75 then
				weapon ="weapon_raycarbine"
			elseif chance > 75 then
				weapon ="weapon_rayminigun"
			--elseif chance > 85 then
				--weapon ="weapon_railgun"				
			end
			SetPedCanRagdoll(Ped, false)
			SetAmbientVoiceName(Ped, "ALIENS")
			DisablePedPainAudio(Ped,true)		
		
		else
			weapon ="weapon_minigun"
		end
		
		GiveWeaponToPed(Ped, GetHashKey(weapon), 2800, false, true)
		SetPedInfiniteAmmo(Ped, true, GetHashKey(weapon))			
		
	else 
		weapon = bossWeapon
		--print('bossWeapon')
		if modelHash=="u_m_y_juggernaut_01" then 
			SetPedPropIndex(Ped, 0, 0, 0, 1)
			SetPedCanRagdoll(Ped, false)
			SetAmbientVoiceName(Ped, "ALIENS")
			DisablePedPainAudio(Ped,true)
		elseif modelHash == "s_m_m_movalien_01" then 			
			SetPedDefaultComponentVariation(Ped)
			SetPedCanRagdoll(Ped, false)
			SetAmbientVoiceName(Ped, "ALIENS")
			DisablePedPainAudio(Ped,true)			
		end
		GiveWeaponToPed(Ped, weapon, 2800, false, true)
		SetPedInfiniteAmmo(Ped, true, weapon)				
		
	end
	
		SetPedSuffersCriticalHits(Ped, 0) 
		SetPedDiesWhenInjured(Ped, false) 
		--SetPedCanRagdoll(Ped, false) 
		--SetBlockingOfNonTemporaryEvents(Ped, true)
		
		SetPedAlertness(Ped,3)	
		
		SetPedMaxHealth(Ped, getMissionConfigProperty(MissionName, "BossHealth"))
		SetEntityHealth(Ped, getMissionConfigProperty(MissionName, "BossHealth"))		
	
	--[[
	--do it twice for custom ammo
	
	
	RemoveAllPedWeapons(Ped, true)
	weapon = "weapon_heavysniper_mk2"
	
	component = "COMPONENT_HEAVYSNIPER_MK2_CLIP_EXPLOSIVE"	
	

	--ammo types different from regular do not seem to work
	GiveWeaponComponentToPed(Ped, GetHashKey(weapon), GetHashKey(component))
	GiveWeaponToPed(Ped, GetHashKey(weapon), 0, false, true)
	--SetPedAmmo(Ped, GetHashKey(weapon), 0) 
	--RemoveWeaponComponentFromPed(Ped,  GetHashKey(weapon), GetHashKey(component_remove))
	GiveWeaponComponentToPed(Ped, GetHashKey(weapon), GetHashKey(component))
	
	GiveWeaponToPed(Ped, GetHashKey(weapon), 0, false, true)
	--SetPedAmmo(Ped, GetHashKey(weapon), 0) 
	--RemoveWeaponComponentFromPed(Ped,  GetHashKey(weapon), GetHashKey(component_remove))
	--SetPedAmmo(ped, GetHashKey(weapon), 0) 
	GiveWeaponComponentToPed(Ped, GetHashKey(weapon), GetHashKey(component))
	--SetPedFiringPattern(Ped, 0x914E786F) --FIRING_PATTERN_BURST_FIRE_HELI
	SetPedAmmoByType(Ped, 0x4C98087B, 0)
	SetPedAmmoByType(Ped, 0xADD16CB9, 40)
	
	print("ammo count1:"..GetPedAmmoByType(Ped, 0x4C98087B))
	print("ammo count2:"..GetPedAmmoByType(Ped, 0xADD16CB9))
	--print("HasPedGotWeaponComponent:"..tostring(HasPedGotWeaponComponent(Ped, GetHashKey(weapon), GetHashKey(component))))
	]]--
	SetPedFiringPattern(Ped, 0xC6EE6B4C) --FIRING_PATTERN_FULL_AUTO
end

RegisterNetEvent('SpawnRandomPed')
AddEventHandler('SpawnRandomPed', function(input,MissionType, NumPeds,NumVehicles,rIndex,IsRandomSpawnAnywhereInfo)


	if getMissionConfigProperty(input, "MissionTriggerRadius") then 
	
		local mcoords = {x=0,y=0,z=0}
		if getMissionConfigProperty(input, "MissionTriggerStartPoint") then 
			
			mcoords.x = getMissionConfigProperty(input, "MissionTriggerStartPoint").x
			mcoords.y = getMissionConfigProperty(input, "MissionTriggerStartPoint").y
			mcoords.z = getMissionConfigProperty(input, "MissionTriggerStartPoint").z
		
		else 
			mcoords.x = Config.Missions[input].Blip.Position.x
			mcoords.y = Config.Missions[input].Blip.Position.y
			mcoords.z = Config.Missions[input].Blip.Position.z		
		
		end
		
		local playerTriggered = false
		 BLHOSTFLAG = true

		--spawn safe house props: 
		if getMissionConfigProperty(input, "UseSafeHouse") then
			SpawnSafeHouseProps(input,rIndex,IsRandomSpawnAnywhereInfo) 	
		end		

		MissionSpawnedSafeHouseProps = true			 
		 
		 
		repeat
		local coords = GetEntityCoords(GetPlayerPed(-1))
			 BLHOSTFLAG = true
			if GetDistanceBetweenCoords(coords.x,coords.y,coords.z, 
				mcoords.x,
				mcoords.y,
				mcoords.z, false) <= getMissionConfigProperty(input, "MissionTriggerRadius") and DecorGetInt(GetPlayerPed(i),"mrpoptout")==0 then 
				playerTriggered = true
				
			end 
			Wait(1)
			BLHOSTFLAG = true
			 
			 --if mission is stopped, exit out of the event:
			if Active == 0 or MissionName =="N/A" then
				return
			end	
					 
		until playerTriggered or MissionTriggered or MissionTimeOut
		
		if MissionTimeOut then 
		
			Active = 0
			message2 = "^1[MISSIONS]: ^2'".. Config.Missions[MissionName].MissionTitle .."'^0 has been canceled"
			TriggerServerEvent("sv:two", message2)
			TriggerServerEvent("sv:done", MissionName,true,false,"")
			--TriggerEvent("DONE", MissionName) --ghk needed?
			aliveCheck() --<-- NEEDED?
			MissionName = "N/A"			
		
		
		end
		

		
		if playerTriggered and not MissionTriggered then 
			TriggerServerEvent("sv:CheckHostFlag",BLHOSTFLAG)
			MissionTriggered = true			
			--wait 1 second and check again. 
			--if no mission host where  BLHOSTFLAG = true
			--that triggers the mission with MissionTriggered=true
			--then we need to cancel the mission. 
			--NOTE: THIS SHOULD NEVER HAPPEN HERE, SINCE THIS IS MISSION HOST
			--WHERE BLHOSTFLAG = true
			--Wait(1000)
			--if mission is stopped, exit out of the event:
			--if Active == 1 and MissionName ~="N/A" then
				--return
			--end	
					
			--NOTE: THIS SHOULD NEVER HAPPEN HERE, SINCE THIS IS MISSION HOST
			--WHERE BLHOSTFLAG = true:		
			if playerTriggered and not MissionTriggered then

				Active = 0
				message2 = "^1[MISSIONS]: ^2'".. Config.Missions[MissionName].MissionTitle .."'^0 has been canceled"
				TriggerServerEvent("sv:two", message2)
				TriggerServerEvent("sv:done", MissionName,true,false,"")
				--TriggerEvent("DONE", MissionName) --ghk needed?
				aliveCheck() --<-- NEEDED?
				MissionName = "N/A"	

				return
				
			end 			
			
		end
	
	
	end



	--if MissionType == "Objective" and not getMissionConfigProperty(input, "HostageRescue") then 
		--doing check inside the function now
		
		local IsDefendTargets = SpawnRandomProp(input,rIndex,IsRandomSpawnAnywhereInfo) --returns {TargetPed,TargetPedVehicle}
		local TargetPed = IsDefendTargets[1]
		local TargetPedVehicle = IsDefendTargets[2]
		
		local doBoatMission = false
		
		--print(input)
		
		
	--print(dump(Blips))
		
	--end 
	local randomLocation 
	
	local rXoffset, rYoffset,rZoffset, rHeading, _ --spawn within 40 metres of the randomlocation
	
	if getMissionConfigProperty(input, "IsRandomSpawnAnywhere") then
		--local randomplace = {x=0.0,y=0.0,z=0.0}
		
		--randomplace.x = IsRandomSpawnAnywhereInfo[1].x
		--randomplace.y = IsRandomSpawnAnywhereInfo[1].y
		--randomplace.y = IsRandomSpawnAnywhereInfo[1].z
	
		doBoatMission = IsRandomSpawnAnywhereInfo[2]
		
		randomLocation = IsRandomSpawnAnywhereInfo[1] --randomplace
		
	else 
		if getMissionConfigProperty(input, "RandomMissionPositions")[rIndex].SpawnAt then 
			
			randomLocation = getMissionConfigProperty(input, "RandomMissionPositions")[rIndex].SpawnAt
		else 
			randomLocation = getMissionConfigProperty(input, "RandomMissionPositions")[rIndex]
		end
		--print(randomLocation.x)
		--only for isdefendtarget, goto goal missions, override for SpawnAt for random detination:
		if MissionIsDefendTargetGoalDestIndex and
		getMissionConfigProperty(input,"RandomMissionDestinations")[MissionIsDefendTargetGoalDestIndex] and 
		getMissionConfigProperty(input,"RandomMissionDestinations")[MissionIsDefendTargetGoalDestIndex].SpawnAt then 
		local ind = MissionIsDefendTargetGoalDestIndex
		--print("made it")
		randomLocation.x = getMissionConfigProperty(input,"RandomMissionDestinations")[ind].SpawnAt.x
		randomLocation.y = getMissionConfigProperty(input,"RandomMissionDestinations")[ind].SpawnAt.y
		randomLocation.z = getMissionConfigProperty(input,"RandomMissionDestinations")[ind].SpawnAt.z
			--print("made it:"..randomLocation.x)
		end
		
		--print(rIndex)
		--print(randomLocation.x)
		--print("spawnradnomped:".. tostring(MissionIsDefendTargetGoalDestIndex))
		--spawn at destination if available:
		--[[
		if Config.Missions[input].IsDefendTarget and Config.Missions[input].IsVehicleDefendTargetGotoGoal
			and getMissionConfigProperty(input,"IsRandom") and MissionIsDefendTargetGoalDestIndex then  
			print("spawnradnomped:".. tostring(MissionIsDefendTargetGoalDestIndex))
			 randomLocation = getMissionConfigProperty(input, "RandomMissionDestinations")[MissionIsDefendTargetGoalDestIndex]
			 print(randomLocation.x)
		end
		]]--
		
	end
	

	--determine if a random event gets spawned when a player gets witin 500m to 1000m of the Blip coordinate
	if math.random(1,100) <=  getMissionConfigProperty(input, "IsRandomEventChance") and not doBoatMission then
	
		IsRandomDoEvent = true
		
		IsRandomDoEventType = math.random(1,4)
		if IsRandomDoEventType == 1 then --paradrop
			IsRandomDoEventRadius = math.random(200, 1000)
		elseif IsRandomDoEventType == 2 then --squad
			IsRandomDoEventRadius = math.random(200, 500)
		elseif IsRandomDoEventType == 3 then --aircraft
			IsRandomDoEventRadius = math.random(1000, 1500)
		elseif IsRandomDoEventType == 4 then  -- vehicle	
			IsRandomDoEventRadius = math.random(200, 500)
		end
	
		
		TriggerServerEvent("sv:IsRandomDoEvent",IsRandomDoEvent,IsRandomDoEventRadius,IsRandomDoEventType)
	end	
	
	math.randomseed(GetGameTimer())	
	
if not doBoatMission then
	for i=1, NumPeds do
		
		local randomPedModelHash = getMissionConfigProperty(input, "RandomMissionPeds")[math.random(1, #getMissionConfigProperty(input, "RandomMissionPeds"))]
		local randomPedWeapon = getMissionConfigProperty(input, "RandomMissionWeapons")[math.random(1, #getMissionConfigProperty(input, "RandomMissionWeapons"))]
		local Ped
		local spawnFriendly = false
		
		
		--check if we are doing a 'boss', basically they have exploding rounds etc...  
		local doBoss = false
		if getMissionConfigProperty(input, "RandomMissionBossChance")  >= math.random(100) then 
			doBoss = true
			randomPedModelHash = getMissionConfigProperty(input, "RandomMissionBossPeds")[math.random(1, #getMissionConfigProperty(input, "RandomMissionBossPeds"))]
		else 
			if math.random(5) > 4 and (not getMissionConfigProperty(input, "IsDefend") and not getMissionConfigProperty(input, "IsDefendTarget")) and not getMissionConfigProperty(input, "IsBountyHunt") then 
				spawnFriendly = true
				randomPedModelHash = getMissionConfigProperty(input, "RandomMissionFriendlies")[math.random(1, #getMissionConfigProperty(input, "RandomMissionFriendlies"))]
			end 
		end		
		
		
        RequestModel(GetHashKey(randomPedModelHash))
        while not HasModelLoaded(GetHashKey(randomPedModelHash)) do
          Wait(1)
        end
		local raytestsuccess = true
		local spawnRadius = getMissionConfigProperty(input, "RandomMissionSpawnRadius")
		--local _unused
		
		
		local checkthisspawn = false
		
			--rXoffset = randomLocation.x + roundToNthDecimal(math.random() + math.random(-1*spawnRadius,spawnRadius - 1),4)
			
			--rYoffset = randomLocation.y + roundToNthDecimal(math.random() + math.random(-1*spawnRadius,spawnRadius - 1),4)		
	
		
		if not getMissionConfigProperty(input, "IsRandomSpawnAnywhere") and not randomLocation.force then --force is on, means we are OK to not check. 

				--print("FORCE OFF")
				--if spawnAircraft == 0 then --Also dont check for aircraft, they spawn + 200 above
				

				
				local tries = 0
				local RandomMissionDoLandBattle = getMissionConfigProperty(input, "RandomMissionDoLandBattle")
				repeat
					rXoffset = randomLocation.x + roundToNthDecimal(math.random() + math.random(-1*spawnRadius,spawnRadius - 1),4)
			
					rYoffset = randomLocation.y + roundToNthDecimal(math.random() + math.random(-1*spawnRadius,spawnRadius - 1),4)	
					
					
					rZoffset = checkAndGetGroundZ(rXoffset, rYoffset,randomLocation.z,false) --LAST ARG: blFindGroundZ 
						if rZoffset == 0.0 then --flag for checkspawn
							checkspawns = true --global for all clients and mission
							checkthisspawn=true
							--rZoffset = randomLocation.z   --***SPAWN AT THE DEFAULT Z POSITION? YES It will be corrected later
							
							--print("NOT AIRCRAFT")
						end
					--else 
					--print("AIRCRAFT")
						--rZoffset = randomLocation.z
					--end
					--if spawnAircraft == 0 then --Also dont check for aircraft, they spawn + 200 above
					local ray = Citizen.InvokeNative( 0x377906D8A31E5586, vector3(rXoffset, rYoffset, rZoffset) + vector3(0.0, 0.0, 1000.0), vector3(rXoffset, rYoffset, rZoffset), -1, -1, 0)
					--local ray = StartShapeTestRay(vector3(rXoffset, rYoffset, rZoffset) + vector3(0.0, 0.0, 500.0), vector3(rXoffset, rYoffset, rZoffset), -1, -1, 0)
					-- local _, hit, impactCoords  = Citizen.InvokeNative( 0x3D87450E15D98694, ray,hit)
					local _, hit, impactCoords = GetRaycastResult(ray) --GetShapeTesResult(ray)
					-- print("HIT: " .. hit)
					-- print(("IMPACT COORDS: X = %.4f; Y = %.4f; Z = %.4f"):format(impactCoords.x, impactCoords.y, impactCoords.z))
					-- print("DISTANCE BETWEEN DROP AND IMPACT COORDS: " ..  #(vector3(dropCoords.x, dropCoords.y, dropCoords.z) - vector3(impactCoords)))
					if hit == 0 or (hit == 1 and #(vector3(rXoffset, rYoffset, rZoffset) - vector3(impactCoords)) < 0.5) then -- ± 0.5 units
						--print("ROOFCHECK: vehicle success")
						raytestsuccess = true
					else
						--print("ROOFCHECK: vehicles fail")
						raytestsuccess = false
					   
					end	
					
					if RandomMissionDoLandBattle then 
						local watertest = GetWaterHeight(rXoffset, rYoffset, rZoffset)
						if watertest  == 1 or watertest  == true then 
							--water mission
							--print("water mission at:") 
							--print(randomplace.x..","..randomplace.y..","..randomplace.z)
							
							raytestsuccess = false
						end
					end 									
					

				tries = tries + 1
				--end				
				until( raytestsuccess == true or tries > 250 )
			
			
		elseif not getMissionConfigProperty(input, "IsRandomSpawnAnywhere") and randomLocation.force then 
				IsRandomMissionForceSpawning=true
				rXoffset = randomLocation.x + roundToNthDecimal(math.random() + math.random(-1*spawnRadius,spawnRadius - 1),4)
			
				rYoffset = randomLocation.y + roundToNthDecimal(math.random() + math.random(-1*spawnRadius,spawnRadius - 1),4)	

					--dont spawn on water if a land battle.
				if getMissionConfigProperty(input, "RandomMissionDoLandBattle") then 
					local watertest = GetWaterHeight(rXoffset, rYoffset, rZoffset)
					if watertest  == 1 or watertest  == true then 
							--water mission
							--print("water mission at:") 
							--print(randomplace.x..","..randomplace.y..","..randomplace.z)
							
						raytestsuccess = false
					end
				end 													
			
				--print("FORCE ON")
				rZoffset = randomLocation.z
				
		elseif getMissionConfigProperty(input, "IsRandomSpawnAnywhere") then 
				local tries = 0
				local RandomMissionDoLandBattle = getMissionConfigProperty(input, "RandomMissionDoLandBattle")
				repeat
					rXoffset = randomLocation.x + roundToNthDecimal(math.random() + math.random(-1*spawnRadius,spawnRadius - 1),4)
			
					rYoffset = randomLocation.y + roundToNthDecimal(math.random() + math.random(-1*spawnRadius,spawnRadius - 1),4)	
					
					
					
					

					
					rZoffset = checkAndGetGroundZ(rXoffset, rYoffset,randomLocation.z,false) --LAST ARG: blFindGroundZ 
						if rZoffset == 0.0 then --flag for checkspawn
							checkspawns = true --global for all clients and mission
							checkthisspawn=true
							--rZoffset = randomLocation.z   --***SPAWN AT THE DEFAULT Z POSITION? YES It will be corrected later
							--print("NOT AIRCRAFT")
						end
					--else 
					--print("AIRCRAFT")
						--rZoffset = randomLocation.z
					--end
					--if spawnAircraft == 0 then --Also dont check for aircraft, they spawn + 200 above
					local ray = Citizen.InvokeNative( 0x377906D8A31E5586, vector3(rXoffset, rYoffset, rZoffset) + vector3(0.0, 0.0, 1000.0), vector3(rXoffset, rYoffset, rZoffset), -1, -1, 0)
					--local ray = StartShapeTestRay(vector3(rXoffset, rYoffset, rZoffset) + vector3(0.0, 0.0, 500.0), vector3(rXoffset, rYoffset, rZoffset), -1, -1, 0)
					-- local _, hit, impactCoords  = Citizen.InvokeNative( 0x3D87450E15D98694, ray,hit)
					local _, hit, impactCoords = GetRaycastResult(ray) --GetShapeTesResult(ray)
					-- print("HIT: " .. hit)
					-- print(("IMPACT COORDS: X = %.4f; Y = %.4f; Z = %.4f"):format(impactCoords.x, impactCoords.y, impactCoords.z))
					-- print("DISTANCE BETWEEN DROP AND IMPACT COORDS: " ..  #(vector3(dropCoords.x, dropCoords.y, dropCoords.z) - vector3(impactCoords)))
					if hit == 0 or (hit == 1 and #(vector3(rXoffset, rYoffset, rZoffset) - vector3(impactCoords)) < 0.5) then -- ± 0.5 units
						--print("ROOFCHECK: vehicle success")
						raytestsuccess = true
					else
						--print("ROOFCHECK: vehicles fail")
						raytestsuccess = false
					   
					end	
					
					if RandomMissionDoLandBattle then 
						local watertest = GetWaterHeight(rXoffset, rYoffset, rZoffset)
						if watertest  == 1 or watertest  == true then 
							--water mission
							--print("water mission at:") 
							--print(randomplace.x..","..randomplace.y..","..randomplace.z)
							
							raytestsuccess = false
						end
					end 									
					

				tries = tries + 1
				--end				
				until( raytestsuccess == true or tries > 250 )		
		
		end 

		--if(rZoffset <= 0.0) then 
			--print ("bad spawn")
			--raytestsuccess = false
		--end
		
		
		--[[
		local ground 
		
		local Z = 999.0
		--print("trying:"..i)
		local tries = 0
		repeat
			rXoffset = randomLocation.x + roundToNthDecimal(math.random() + math.random(-1*spawnRadius,spawnRadius - 1),4)
			
			rYoffset = randomLocation.y + roundToNthDecimal(math.random() + math.random(-1*spawnRadius,spawnRadius - 1),4)	

			
			ground,rZoffset = GetGroundZFor_3dCoord(rXoffset+.0,rYoffset+.0,Z,1)--set Z data as on ground
			Wait(1)
			tries = tries + 1
					
		until( ground == true or tries > 250 )		
		
		--print(tostring(ground).."rZoffset:"..rZoffset)
		]]--
		
		--[[
		if raytestsuccess and getMissionConfigProperty(input, "RandomMissionSpawnOnRoof") then
		
		local Z = 999.0
			local temprZoffset
			ground,temprZoffset = GetGroundZFor_3dCoord(rXoffset+.0,rYoffset+.0,Z,1)--set Z data as on ground
			
			if ground then
				rZoffset = temprZoffset
				print("rZoffset"..rZoffset)
			end
			

		end	
	--]]
		
		if raytestsuccess then 
			--print("spawned:"..i)
			rHeading = roundToNthDecimal(math.random() + math.random(0,359),2)
			
			--for BountyHunt Assassinate missions, we are going to spawn squads
			if (getMissionConfigProperty(input, "IsBountyHunt")) then
				--print(i)
				TriggerEvent("doRandomSquad",i, rXoffset, rYoffset, rZoffset,input)
			end
		
			Ped = CreatePed(2, randomPedModelHash, rXoffset, rYoffset, rZoffset, rHeading, true, true)
			SetModelAsNoLongerNeeded(randomPedModelHash)
			
			if rZoffset ==0.0 then 
				DecorSetInt(Ped,"mrpvehdidGround",1)
				FreezeEntityPosition(Ped,true)
			end
			
			SetEntityAsMissionEntity(Ped,true,true)
			
			if getMissionConfigProperty(input,"IsDefendTargetEnemySetBlockingOfNonTemporaryEvents") then 
				SetBlockingOfNonTemporaryEvents(Ped,true)
			end			
			
			
			if not getMissionConfigProperty(input,"IsDefendTarget") or (getMissionConfigProperty(input,"IsDefendTarget") and getMissionConfigProperty(input,"IsDefendTargetOnlyPlayersDamagePeds") ) then
				--Stop AI from blowing themselves up!
				SetEntityOnlyDamagedByPlayer(Ped, true) 
			end
			
			if getMissionConfigProperty(input,"MissionDoBackup") then
				SetEntityOnlyDamagedByPlayer(Ped, false) 
				SetEntityCanBeDamagedByRelationshipGroup(Ped,false,"HATES_PLAYER")
				SetEntityCanBeDamagedByRelationshipGroup(Ped,true,"PLAYER")
				SetEntityCanBeDamagedByRelationshipGroup(Ped,true,"ISDEFENDTARGET")
			end			
			
			SetPedAccuracy(Ped,math.random(getMissionConfigProperty(input, "SetPedMinAccuracy"),getMissionConfigProperty(input, "SetPedMaxAccuracy")))
			--Add DoesEntityExist check here? 
			--[[
			if checkthisspawn then 
				DecorSetInt(Ped,"mrpcheckspawn",1) --flag Ped to be checked to readjust if necessary later 
			else 
				DecorSetInt(Ped,"mrpcheckspawn",0)
			end
			]]--
			
			if(randomPedModelHash == "s_m_m_movalien_01") then
				SetPedDefaultComponentVariation(Ped) --GHK for s_m_m_movalien_01
			end
			
			--Create 'conqueror' type NPCs 25% of the time if default IsDefend mission, not subtype IsDefendTarget
			--UNLIKE VEHICLE DRIVERS, WHERE THEY WILL BE TRUENEUTRAL IN ALL ISDEFEND TYPES
			if not getMissionConfigProperty(input, "IsDefend") or ((getMissionConfigProperty(input, "IsDefend") and not getMissionConfigProperty(input, "IsDefendTarget")) and math.random(1,4) > 2)
			or (getMissionConfigProperty(input, "IsDefend") and getMissionConfigProperty(input, "IsDefendTarget")) then 
				
				if (randomPedModelHash == "u_m_y_zombie_01" or randomPedModelHash == "s_m_m_movalien_01") then  --or randomPedModelHash ==  "ig_orleans") then --movie zed
						SetPedFleeAttributes(Ped, 0, 0)
						SetPedCombatAttributes(Ped, 16, true)
						SetPedCombatAttributes(Ped, 46, true)
						SetPedCombatAttributes(Ped, 26, true)
						SetAmbientVoiceName(Ped, "ALIENS")
						SetPedEnableWeaponBlocking(Ped, true)			
						DisablePedPainAudio(Ped,true)
						
					--if not Config.Missions[input].Peds[i].modelHash == "ig_orleans" then
						ApplyPedBlood(Ped, 3, math.random(0, 4) + 0.0, math.random(-0, 4) + 0.0, math.random(-0, 4) + 0.0, "wound_sheet")
						SetPedIsDrunk(Ped, true)
						RequestAnimSet("move_m@drunk@verydrunk")
						while not HasAnimSetLoaded("move_m@drunk@verydrunk") do
							Wait(1)
						end
						SetPedMovementClipset(Ped, "move_m@drunk@verydrunk", 1.0)						
					--end		
						
					--SetPedCombatRange(Ped, 2)
				  --	SetPedSeeingRange(Ped, 100000000.0)
					--SetPedHearingRange(Ped, 100000000.0)
				  --SetPedCombatAttributes(Ped, 46, true);
				 -- SetPedCombatAttributes(Ped, 5, true);
				  --SetPedCombatAttributes(Ped, 1, false);
				  --SetPedCombatAttributes(Ped, 0, false);
				  --SetPedCombatAbility(Ped, 0);
				
				  --SetPedRagdollBlockingFlags(Ped, 4);
				  --SetPedCanPlayAmbientAnims(Ped, false);	
				  -- SetAmbientVoiceName(Ped,"ALIENS")
				   --DisablePedPainAudio(Ped,true)
				  -- RequestAnimSet("move_m@drunk@verydrunk");
				   --SetPedMovementClipset(Ped, "move_m@drunk@verydrunk",1.0);				
				
				else 
					if not spawnFriendly then
						SetPedCombatAttributes(Ped, 5, true)
						SetPedCombatAttributes(Ped, 46, true);
					end
					SetPedCombatAttributes(Ped, 0, true);
					SetPedCombatAttributes(Ped, 1, true) --can use vehicles
				end

			
				--1 in 5 chance of spawning a  hostagePedsKilledByPlayer
			
				if not spawnFriendly then
					SetPedRelationshipGroupHash(Ped, GetHashKey("HATES_PLAYER"))
					SetRelationshipBetweenGroups(5, GetHashKey("HATES_PLAYER"), GetHashKey("PLAYER"))
					SetRelationshipBetweenGroups(0, GetHashKey("HATES_PLAYER"), GetHashKey("HATES_PLAYER"))
					SetRelationshipBetweenGroups(5, GetHashKey("HATES_PLAYER"), GetHashKey("ISDEFENDTARGET"))
					SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("HATES_PLAYER"))
					SetRelationshipBetweenGroups(0, GetHashKey("HATES_PLAYER"), GetHashKey("TRUENEUTRAL"))
				else 
					SetPedRelationshipGroupHash(Ped, GetHashKey("HOSTAGES"))
					SetRelationshipBetweenGroups(1, GetHashKey("HOSTAGES"), GetHashKey("HATES_PLAYER"))
					SetRelationshipBetweenGroups(1, GetHashKey("HOSTAGES"), GetHashKey("PLAYER"))
					
					if getMissionConfigProperty(input, "DelicateHostages") then 
						SetEntityOnlyDamagedByPlayer(Ped, false)

					else			
						SetEntityOnlyDamagedByPlayer(Ped, true)							
					
					end
				end
				
				--they will combat but also try and keep to the task
				if getMissionConfigProperty(input, "IsDefend") and math.random(1,2)>1 then 
					DecorSetInt(Ped,"mrppedconqueror",i)
					--print('spawned Ped attacker')
				end 
			
			else
			
				-- is there a better way to make an NPC true neutral?
				--does not handle custom groups from other resources
				SetPedFleeAttributes(Ped, 0, 0)
				SetPedRelationshipGroupHash(Ped, GetHashKey("TRUENEUTRAL"))
				SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("PLAYER"))
				SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("HATES_PLAYER"))
				SetRelationshipBetweenGroups(0, GetHashKey("HATES_PLAYER"), GetHashKey("TRUENEUTRAL"))
				SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("HOSTAGES"))
				
				SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("CIVMALE"))
				SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("CIVFEMALE"))
				SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("COP"))
				SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("SECURITY_GUARD"))
				SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("PRIVATE_SECURITY"))
				SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("FIREMAN"))
				SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("GANG_1"))
				SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("GANG_2"))
				SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("GANG_9"))
				SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("GANG_10"))
				SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_LOST"))
				SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_MEXICAN"))
				SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_FAMILY"))
				SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_BALLAS"))
				SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_MARABUNTE"))
				SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_CULT"))
				SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_SALVA"))
				SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_WEICHENG"))
				SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_HILLBILLY"))
				SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("DEALER"))
				SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("WILD_ANIMAL"))
				SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("SHARK"))
				--SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("HATES_PLAYER"))
				SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("COUGAR"))
				SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("NO_RELATIONSHIP"))
				SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("SPECIAL"))
				SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION2"))		
				SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("NO_RELATIONSHIP"))
				SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("SPECIAL"))
				SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION2"))			
				SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION3"))
				SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION4"))
				SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION5"))			
				SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION6"))
				SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION7"))
				SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION8"))			
				SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("ARMY"))
				SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("GUARD_DOG"))
				SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AGGRESSIVE_INVESTIGATE"))						
				SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MEDIC"))
				SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("PRISONER"))	
				SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("DOMESTIC_ANIMAL"))	
				SetRelationshipBetweenGroups(5, GetHashKey("TRUENEUTRAL"), GetHashKey("ISDEFENDTARGET"))
				
				--SetPedCombatAttributes(Ped, 5, true)
				--SetPedCombatAttributes(Ped, 46, true);
				--SetPedCombatAttributes(Ped, 2, true)
				--SetPedCombatAttributes(Ped, 0, false);
				DecorSetInt(Ped,"mrppedconqueror",i)
				--print('spawned Ped Conqueror')
			
			end
			--SetEntityAsMissionEntity(Ped,true,true)
			SetPedSeeingRange(Ped, 10000.0)
			SetPedHearingRange(Ped, 10000.0)

			--SetEntityAsMissionEntity(Ped,true,true)
			DecorSetInt(Ped,"mrppedid",i)
			
			SetPedPathAvoidFire(Ped,1)
			SetPedPathCanUseLadders(Ped,1)
			SetPedPathCanDropFromHeight(Ped,1)
			SetPedPathCanUseClimbovers(Ped,1)
			
			--if Config.Missions[input].Peds[i].invincible then
				--SetEntityInvincible(Ped, true)
			--end
			
			--if Config.Missions[input].Peds[i].dead then
				--SetEntityHealth(Ped, 0.0)
			--end
			
			SetPedDropsWeaponsWhenDead(Ped, getMissionConfigProperty(input, "SetPedDropsWeaponsWhenDead"))
			SetPedDiesWhenInjured(Ped, true)
			if not spawnFriendly then
				if not doBoss then 
				
					GiveWeaponToPed(Ped, randomPedWeapon, 2800, false, true)
					SetPedInfiniteAmmo(Ped, true, randomPedWeapon)	
					SetPedAlertness(Ped,3)	
					if(randomPedWeapon == 0x42BF8A85) then 
						--minigun
						SetPedFiringPattern(Ped, 0x914E786F) --FIRING_PATTERN_BURST_FIRE_HELI
					end
					
				else 
					DecorSetInt(Ped,"mrppedboss",1)
					doBossBuff(Ped,randomPedModelHash,input)
					if getMissionConfigProperty(input, "Type") == "BossRush" then 
						DecorSetInt(Ped,"mrppedtarget",i)
					end
					
				end
			
				if getMissionConfigProperty(input, "FastFiringPeds") then 
					SetPedFiringPattern(Ped, 0xC6EE6B4C) --FIRING_PATTERN_AUTO
				end 							

			end
			ResetAiWeaponDamageModifier()
			if randomPedModelHash  == "mp_m_boatstaff_01" then --L. Ron
				SetPedPropIndex(Ped, 0, 0, 0, 2)
				--SetPedPropIndex(Ped, 0, 8, 0, 2) 
			end 
			--if Config.Missions[input].Peds[i].invincible then
				--SetEntityInvincible(Ped, true)
			--end
				
			--50% chance of wandering in area
			if math.random(2) > 1 and not spawnFriendly then
				--TaskWanderStandard(Ped,10.0, 10)
				TaskWanderInArea(Ped, rXoffset, rYoffset, rZoffset,spawnRadius,0.0,0.0)
			end		
			
			--local pedb = AddBlipForEntity(Ped)
			--local Size     = 0.9
			--SetBlipScale  (pedb, Size)
			--SetBlipAsShortRange(pedb, false)
			
			if spawnFriendly then --if ped is a target in assassinate
				--SetBlipColour(ped, 66)
				TaskCower(Ped,360000) -- 1hour
				--SetBlipSprite(pedb, 280)
				--SetBlipColour(pedb, 2)
				--BeginTextCommandSetBlipName("STRING")
				--AddTextComponentString("Friend ($-"..getHostageKillPenalty(input)..")")
				--EndTextCommandSetBlipName(pedb)									
				DecorSetInt(Ped,"mrppedfriend",i)
				if getMissionConfigProperty(input, "Type") == "HostageRescue" then
					IsRandomMissionHostageCount = IsRandomMissionHostageCount + 1
				end 				
				
				--print("spawned a friendly")
			elseif MissionType=="Assassinate" then --if ped is a target in assassinate
				--SetBlipColour(ped, 66)
				--SetBlipSprite(pedb, 433)
				--SetBlipColour(pedb, 27)
				--BeginTextCommandSetBlipName("STRING")
				--AddTextComponentString("Target ($"..getTargetKillReward(input)..")")
				--EndTextCommandSetBlipName(pedb)						
				DecorSetInt(Ped,"mrppedtarget",i)
			else
				--BeginTextCommandSetBlipName("STRING")
				--AddTextComponentString("Enemy ($"..getKillReward(input)..")")
				--EndTextCommandSetBlipName(pedb)								
			end
			
			--1 in 5 chance of dead friendly
			--except when HostageRescue is on
			if spawnFriendly and math.random(5) > 4 and not (getMissionConfigProperty(input, "HostageRescue") or getMissionConfigProperty(input, "Type") == "HostageRescue") then
				DecorSetInt(Ped,"mrppedfriend",0) --make them not friendly so the player is not penalized!
				DecorSetInt(Ped,"mrppedid",0) --remove all decor 
				DecorSetInt(Ped,"mrppedtarget",0) --remove all decor 
				DecorSetInt(Ped,"mrppedead",1)
				ApplyDamageToPed(Ped,90,true)
				SetEntityHealth(Ped, 0.0)		
			end							
			

			local movespeed = 2.0 --How fast can peds move?
			--everyone including friendlies move toward target, Marker's center
			if Config.Missions[input].IsDefend  then 
			
				if Config.Missions[input].IsDefendTarget then 
					if TargetPed ==nil then
						print("NIL TargetPed for IsDefendTarget")
					end					
					
					if(Config.Missions[input].IsDefendTargetChase) then
						ClearPedTasksImmediately(Ped)
						--print('TASK MOVE TO ENTITY')
						--TaskGoToEntity(Ped,TargetPed, -1, 5.0, movespeed,1073741824, 0)
						--SetPedKeepTask(Ped,true) 
						local _, sequence = OpenSequenceTask(0)
							TaskGoToEntity(0, TargetPed, -1, 5.0, movespeed,1073741824, 0)
					
							--RegisterTarget(Config.Missions[input].Peds[i].id, TargetPed)
					
							TaskCombatPed(0, TargetPed, 0, 16)
							CloseSequenceTask(sequence)
							ClearPedTasks(Ped)
							ClearPedTasksImmediately(Ped)

							-- execute sequence on cop2
							TaskPerformSequence(Ped, sequence)
							ClearSequenceTask(sequence)											
						
						
					end	

					if (not Config.Missions[input].IsDefendTargetChase) and (Config.Missions[input].IsDefendTargetGotoBlip) then 
						ClearPedTasksImmediately(Ped)
						TaskGoStraightToCoord(Ped,Config.Missions[input].Blip.Position.x, Config.Missions[input].Blip.Position.y,Config.Missions[input].Blip.Position.z, movespeed, 100000, 0.0, 0.0) 
						SetPedKeepTask(Ped,true) 					
					end
						
				
				else
					--print("PED GOES TO x:"..Config.Missions[input].Marker.Position.x..", y:".. Config.Missions[input].Marker.Position.y..",z:"..Config.Missions[input].Marker.Position.z)
					ClearPedTasksImmediately(Ped)
					TaskGoStraightToCoord(Ped,Config.Missions[input].Marker.Position.x, Config.Missions[input].Marker.Position.y,Config.Missions[input].Marker.Position.z, movespeed, 100000, 0.0, 0.0) 
					SetPedKeepTask(Ped,true) 
				end
			
			end		
			

			--if Config.Missions[input].Peds[i].armor then --if ped has armor
				AddArmourToPed(Ped, 100) --<**is 100 max for npc???**
				SetPedArmour(Ped, 100)
			--end				
			--blip = GetBlipFromEntity(pedb)
			
			SetAiWeaponDamageModifier(1.0) -- 1.0 == Normal Damage. 
			if (randomPedModelHash == "u_m_y_zombie_01" or randomPedModelHash == "s_m_m_movalien_01" or randomPedModelHash == "ig_orleans") then --movie zed
				SetAiMeleeWeaponDamageModifier(50.0)
				SetPedSuffersCriticalHits(Ped, 0) 
				SetPedDiesWhenInjured(Ped, false) 
				SetPedCanRagdoll(Ped, false) 	
				DecorSetInt(Ped,"mrppedmonster",i)				
				if (randomPedModelHash == "s_m_m_movalien_01" or randomPedModelHash == "ig_orleans") then
					--DOES NOT SEEM TO WORK FOR NPCS
					
					SetPedMaxHealth(Ped, 1000)
					SetEntityHealth(Ped, 1000)
					--SetPlayerMaxArmour(Ped,100)
					AddArmourToPed(Ped, 100)
					SetPedArmour(Ped, 100)
					
				end
			else 
				SetAiMeleeWeaponDamageModifier(1.0)
			end 
			-- ^ Sets Custom NPC Damage. ^
		end
    end
end	

	
	if getMissionConfigProperty(input, "RandomMissionGuardAircraft") then
		NumVehicles = NumVehicles + 1
		
	end
	--for random anywhere missions on water, since no peds spawn
	--we need make sure at least one boat spawns. 
	if doBoatMission and NumVehicles == 0 then 
		NumVehicles = 1
	end
	local lastrandomplayer = -1
    for i=1, NumVehicles do
		
		--how rare are vehicles?
		if doBoatMission or getMissionConfigProperty(input, "RandomMissionChanceToSpawnVehiclePerTry")  >= math.random(100) then 
	
			local randomPedModelHash = getMissionConfigProperty(input, "RandomMissionPeds")[math.random(1, #getMissionConfigProperty(input, "RandomMissionPeds"))]
			local randomPedWeaponHash = getMissionConfigProperty(input, "RandomMissionVehicleWeapons")[math.random(1, #getMissionConfigProperty(input, "RandomMissionVehicleWeapons"))]
			local randomPedVehicleHash = getMissionConfigProperty(input, "RandomMissionVehicles")[math.random(1, #getMissionConfigProperty(input, "RandomMissionVehicles"))]
			local randomPedAircraftHash = getMissionConfigProperty(input, "RandomMissionAircraft")[math.random(1, #getMissionConfigProperty(input, "RandomMissionAircraft"))]
			--used for IsRandomSpawnAnywhere missions, for when the random position is on water.
			local randomPedBoatHash = getMissionConfigProperty(input, "RandomMissionBoat")[math.random(1, #getMissionConfigProperty(input, "RandomMissionBoat"))]
			
			
			local Ped
			local PedVehicle
			local spawnFriendly = false
			local spawnAircraft = 0
			
			--if math.random(5) > 4 then 
			--	spawnFriendly = true
			--	randomPedModelHash = Config.RandomMissionFriendlies [math.random(1, #Config.RandomMissionFriendlies )]
			--end
			
			if doBoatMission then 
				randomPedVehicleHash = randomPedBoatHash
				--print('spawning boat')
			end

			--chance of spawning an Aircraft
			if getMissionConfigProperty(input, "RandomMissionAircraftChance") >= math.random(100) then 
				
				spawnAircraft = math.random(200,300) 
				randomPedVehicleHash = randomPedAircraftHash
			end 

			if getMissionConfigProperty(input, "RandomMissionGuardAircraft") and i == 1 then
				randomPedVehicleHash = getMissionConfigProperty(input, "RandomMissionGuardAircraftSpawns")[math.random(1, #getMissionConfigProperty(input, "RandomMissionGuardAircraftSpawns"))]
				spawnAircraft = math.random(200,300) 
				--print("made it")
			end			
		
			veh         =  randomPedVehicleHash
			--print("veh1:"..veh)
			vehiclehash = GetHashKey(veh)
			RequestModel(vehiclehash)
			RequestModel(randomPedModelHash)
			while not HasModelLoaded(vehiclehash) do
			  Wait(1)
			end
			
			--lower height for helis, since they go after host player no matter what if too high altitude
			if IsThisModelAHeli(vehiclehash) then 
				spawnAircraft = math.random(200,300) 
			end
			
			local raytestsuccess = true
			local checkthisspawn = false
			--local _unused
			local spawnRadius = getMissionConfigProperty(input, "RandomMissionSpawnRadius")
			
			
			
			--_unused, rZoffset = GetGroundZFor_3dCoord(rXoffset, rYoffset, randomLocation.z) 
			
			--print("SPAWNPEDRANDOMVEH")
		
			local IsBountyHuntDoBoatsFoundWater = false
			if not getMissionConfigProperty(input, "IsRandomSpawnAnywhere") and not randomLocation.force then --force is on, means we are OK to not check. 
				--print("FORCE OFF")
				--if spawnAircraft == 0 then --Also dont check for aircraft, they spawn + 200 above
				
				--rXoffset = randomLocation.x + roundToNthDecimal(math.random() + math.random(-1*spawnRadius,spawnRadius - 1),4)
			
				--rYoffset = randomLocation.y + roundToNthDecimal(math.random() + math.random(-1*spawnRadius,spawnRadius - 1),4)		
				
				local tries = 0
				local RandomMissionDoLandBattle = getMissionConfigProperty(input, "RandomMissionDoLandBattle")
				repeat
					Wait(1)
					rXoffset = randomLocation.x + roundToNthDecimal(math.random() + math.random(-1*spawnRadius,spawnRadius - 1),4)
			
					rYoffset = randomLocation.y + roundToNthDecimal(math.random() + math.random(-1*spawnRadius,spawnRadius - 1),4)
					
					rZoffset = checkAndGetGroundZ(rXoffset, rYoffset,randomLocation.z,false) --LAST ARG: blFindGroundZ 
						if rZoffset == 0.0 then --flag for checkspawn
							checkspawns = true --global for all clients and mission
							checkthisspawn=true
							--rZoffset = randomLocation.z   --***SPAWN AT THE DEFAULT Z POSITION? YES It will be corrected later
							--print("NOT AIRCRAFT")
						end
					--else 
					--print("AIRCRAFT")
						--rZoffset = randomLocation.z
					--end
					--if spawnAircraft == 0 then --Also dont check for aircraft, they spawn + 200 above
					local ray = Citizen.InvokeNative( 0x377906D8A31E5586, vector3(rXoffset, rYoffset, rZoffset) + vector3(0.0, 0.0, 1000.0), vector3(rXoffset, rYoffset, rZoffset), -1, -1, 0)
					--local ray = StartShapeTestRay(vector3(rXoffset, rYoffset, rZoffset) + vector3(0.0, 0.0, 500.0), vector3(rXoffset, rYoffset, rZoffset), -1, -1, 0)
					-- local _, hit, impactCoords  = Citizen.InvokeNative( 0x3D87450E15D98694, ray,hit)
					local _, hit, impactCoords = GetRaycastResult(ray) --GetShapeTesResult(ray)
					-- print("HIT: " .. hit)
					-- print(("IMPACT COORDS: X = %.4f; Y = %.4f; Z = %.4f"):format(impactCoords.x, impactCoords.y, impactCoords.z))
					-- print("DISTANCE BETWEEN DROP AND IMPACT COORDS: " ..  #(vector3(dropCoords.x, dropCoords.y, dropCoords.z) - vector3(impactCoords)))
					if hit == 0 or (hit == 1 and #(vector3(rXoffset, rYoffset, rZoffset) - vector3(impactCoords)) < 0.5) then -- ± 0.5 units
						--print("ROOFCHECK: vehicle success")
						raytestsuccess = true
					else
						--print("ROOFCHECK: vehicles fail")
						raytestsuccess = false
					   
					end
					--local IsBountyHuntDoBoatsFoundWater = false
					if RandomMissionDoLandBattle then 
						local watertest = GetWaterHeight(rXoffset, rYoffset, rZoffset)
						--print("water mission at:"..watertest)
						if watertest  == 1 or watertest  == true then 
							--water mission
							 
							--print(rXoffset..","..rYoffset..","..rZoffset)
						
						--override for IsBountyHunt

						if not (getMissionConfigProperty(input, "IsBountyHunt") and getMissionConfigProperty(input, "IsBountyHuntDoBoats") ) and not (getMissionConfigProperty(input, "RandomMissionDoBoats")) then
							
							raytestsuccess = false
						else
							
							if (rXoffset > -3500 and rXoffset < 4000) and (rYoffset > -4000 and rYoffset < 7700) then
								--do boat swap...only if not too far out in water
								IsBountyHuntDoBoatsFoundWater = true
								SetModelAsNoLongerNeeded(vehiclehash)							
								randomPedVehicleHash = randomPedBoatHash
								veh         =  randomPedVehicleHash
								vehiclehash = GetHashKey(veh)
								RequestModel(vehiclehash)
								RequestModel(randomPedModelHash)
								while not HasModelLoaded(vehiclehash)  do
								  Wait(1)
								end
								
								local zGround = checkAndGetGroundZ(rXoffset, rYoffset,  rZoffset + 800.0,true)
								--print("water mission Z:"..zGround) 
								if zGround > 0.0 then --flag for checkspawn
									--randomLocation.z = zGround
									--rZoffset = zGround	
										watertest = zGround								
								end													
							--print("water mission at:") 
							rZoffset = 1.0*watertest + 5.0
							--print(rXoffset..","..rYoffset..","..rZoffset)
													
								
							else
								raytestsuccess = false
							end	
						end	
							
						end
					end
					

					rHeading = roundToNthDecimal(math.random() + math.random(0,359),2)	
					
					--
					if not (getMissionConfigProperty(input, "IsBountyHunt")) and 
					IsThisModelABoat(vehiclehash) then 
						rZoffset = rZoffset + 1.0
						--print("found boat")
					end
					
					if getMissionConfigProperty(input, "IsDefendTarget") and 
						spawnAircraft ==0 and not IsThisModelABoat(vehiclehash) then 
						--print("made it path 1")
						
						--LoadAllPathNodes(true)
						--print("loading path nodes1")
						--while not AreAllNavmeshRegionsLoaded() do
							--print("loading path nodes2")
							--Wait(1)
						--end					
						--does not seem to work in city/downtown, vehicles 
						--get placed in odd places, above commented out code did not seem to help
						local boolval, npos, heading = GetNthClosestVehicleNodeWithHeading(rXoffset,rYoffset,rZoffset,1,9,3.0,2.5)
						
						
						
						--local boolval2, npos2, headin2g GetNthClosestVehicleNodeIdWithHeading(rXoffset,rYoffset,rZoffset,1,9,3.0,2.5)
						
						--print(IsVehicleNodeIdValid(npos2))
						
						if boolval then 
						
							--print("made it path")
							rXoffset = npos.x
							rYoffset = npos.y
							rZoffset = npos.z
							rHeading = heading
						
						
						end 
					end
					
					if raytestsuccess then 
						--print("hey"..i)
						PedVehicle = CreateVehicle(vehiclehash, rXoffset, rYoffset, rZoffset + spawnAircraft,  rHeading, 1, 0)
						
						if rZoffset ==0.0 and not (IsThisModelABoat(vehiclehash) or IsThisModelAPlane(vehiclehash) or IsThisModelAHeli(vehiclehash)) then 
							DecorSetInt(PedVehicle,"mrpvehdidGround",1)
							FreezeEntityPosition(PedVehicle,true)
						end						
						
					end 
					
					if not DoesEntityExist(PedVehicle) then 
						--print("veh retry:"..veh)
						--print("spawnaircraft:"..rXoffset..", "..rYoffset..",".. rZoffset + spawnAircraft)
						Wait(1)
						raytestsuccess = false
					end	

					tries = tries + 1
				--end				
				until( raytestsuccess == true or tries > 250 )
			
			
			elseif not getMissionConfigProperty(input, "IsRandomSpawnAnywhere") and randomLocation.force then
				IsRandomMissionForceSpawning=true
				rXoffset = randomLocation.x + roundToNthDecimal(math.random() + math.random(-1*spawnRadius,spawnRadius - 1),4)
			
				rYoffset = randomLocation.y + roundToNthDecimal(math.random() + math.random(-1*spawnRadius,spawnRadius - 1),4)	

					--dont spawn on water if a land battle.
				if getMissionConfigProperty(input, "RandomMissionDoLandBattle") then 
					local watertest = GetWaterHeight(rXoffset, rYoffset, rZoffset)
					if watertest  == 1 or watertest  == true then 
							--water mission
							--print("water mission at:") 
							--print(randomplace.x..","..randomplace.y..","..randomplace.z)
							
						raytestsuccess = false
					end
				end 

			
				--print("FORCE ON"..)
				rZoffset = randomLocation.x
				--print("FORCE ON"..randomLocation.z)
				rHeading = roundToNthDecimal(math.random() + math.random(0,359),2)	
				if raytestsuccess then 
						--print("hey"..i)
						PedVehicle = CreateVehicle(vehiclehash, rXoffset, rYoffset, rZoffset + spawnAircraft,  rHeading, 1, 0)
						
						
					if rZoffset ==0.0 and not (IsThisModelABoat(vehiclehash) or IsThisModelAPlane(vehiclehash) or IsThisModelAHeli(vehiclehash)) then 
							DecorSetInt(PedVehicle,"mrpvehdidGround",1)
							FreezeEntityPosition(PedVehicle,true)
					end						
						
				end
			elseif  getMissionConfigProperty(input, "IsRandomSpawnAnywhere") then --force is on, means we are OK to not check. 
				--print("FORCE OFF")
				--if spawnAircraft == 0 then --Also dont check for aircraft, they spawn + 200 above
				
				--rXoffset = randomLocation.x + roundToNthDecimal(math.random() + math.random(-1*spawnRadius,spawnRadius - 1),4)
			
				--rYoffset = randomLocation.y + roundToNthDecimal(math.random() + math.random(-1*spawnRadius,spawnRadius - 1),4)		
				
				local tries = 0
				local RandomMissionDoLandBattle = getMissionConfigProperty(input, "RandomMissionDoLandBattle")
				repeat
					Wait(1)
					rXoffset = randomLocation.x + roundToNthDecimal(math.random() + math.random(-1*spawnRadius,spawnRadius - 1),4)
			
					rYoffset = randomLocation.y + roundToNthDecimal(math.random() + math.random(-1*spawnRadius,spawnRadius - 1),4)
					

					
					
					rZoffset = checkAndGetGroundZ(rXoffset, rYoffset,randomLocation.z,false) --LAST ARG: blFindGroundZ 
						if rZoffset == 0.0 then --flag for checkspawn
							checkspawns = true --global for all clients and mission
							checkthisspawn=true
							--rZoffset = randomLocation.z   --***SPAWN AT THE DEFAULT Z POSITION? YES It will be corrected later
							--print("NOT AIRCRAFT")
						end
					--else 
					--print("AIRCRAFT")
						--rZoffset = randomLocation.z
					--end
					--if spawnAircraft == 0 then --Also dont check for aircraft, they spawn + 200 above
					local ray = Citizen.InvokeNative( 0x377906D8A31E5586, vector3(rXoffset, rYoffset, rZoffset) + vector3(0.0, 0.0, 1000.0), vector3(rXoffset, rYoffset, rZoffset), -1, -1, 0)
					--local ray = StartShapeTestRay(vector3(rXoffset, rYoffset, rZoffset) + vector3(0.0, 0.0, 500.0), vector3(rXoffset, rYoffset, rZoffset), -1, -1, 0)
					-- local _, hit, impactCoords  = Citizen.InvokeNative( 0x3D87450E15D98694, ray,hit)
					local _, hit, impactCoords = GetRaycastResult(ray) --GetShapeTesResult(ray)
					-- print("HIT: " .. hit)
					-- print(("IMPACT COORDS: X = %.4f; Y = %.4f; Z = %.4f"):format(impactCoords.x, impactCoords.y, impactCoords.z))
					-- print("DISTANCE BETWEEN DROP AND IMPACT COORDS: " ..  #(vector3(dropCoords.x, dropCoords.y, dropCoords.z) - vector3(impactCoords)))
					if hit == 0 or (hit == 1 and #(vector3(rXoffset, rYoffset, rZoffset) - vector3(impactCoords)) < 0.5) then -- ± 0.5 units
						--print("ROOFCHECK: vehicle success")
						raytestsuccess = true
					else
						--print("ROOFCHECK: vehicles fail")
						raytestsuccess = false
					   
					end
					--local IsBountyHuntDoBoatsFoundWater = false
					if RandomMissionDoLandBattle then 
						local watertest = GetWaterHeight(rXoffset, rYoffset, rZoffset)
						--print("water mission at:"..watertest)
						if watertest  == 1 or watertest  == true then 
							--water mission
							 
							--print(rXoffset..","..rYoffset..","..rZoffset)
						
						--override for IsBountyHunt

						if not (getMissionConfigProperty(input, "IsBountyHunt") and getMissionConfigProperty(input, "IsBountyHuntDoBoats") ) and not (getMissionConfigProperty(input, "RandomMissionDoBoats")) then
							
							raytestsuccess = false
						else
							
							if (rXoffset > -3500 and rXoffset < 4000) and (rYoffset > -4000 and rYoffset < 7700) then
								--do boat swap...only if not too far out in water
								IsBountyHuntDoBoatsFoundWater = true
								SetModelAsNoLongerNeeded(vehiclehash)							
								randomPedVehicleHash = randomPedBoatHash
								veh         =  randomPedVehicleHash
								vehiclehash = GetHashKey(veh)
								RequestModel(vehiclehash)
								RequestModel(randomPedModelHash)
								while not HasModelLoaded(vehiclehash)  do
								  Wait(1)
								end
								
								local zGround = checkAndGetGroundZ(rXoffset, rYoffset,  rZoffset + 800.0,true)
								--print("water mission Z:"..zGround) 
								if zGround > 0.0 then --flag for checkspawn
									--randomLocation.z = zGround
									--rZoffset = zGround	
										watertest = zGround								
								end													
							--print("water mission at:") 
							rZoffset = 1.0*watertest + 5.0
							--print(rXoffset..","..rYoffset..","..rZoffset)
													
								
							else
								raytestsuccess = false
							end	
						end	
							
						end
					end
					

					rHeading = roundToNthDecimal(math.random() + math.random(0,359),2)	
					
					--
					if not (getMissionConfigProperty(input, "IsBountyHunt")) and 
					IsThisModelABoat(vehiclehash) then 
						rZoffset = rZoffset + 1.0
						--print("found boat")
					end
					
					if getMissionConfigProperty(input, "IsDefendTarget") and 
						spawnAircraft ==0 and not IsThisModelABoat(vehiclehash) then 
						--print("made it path 1")
						
						--LoadAllPathNodes(true)
						--print("loading path nodes1")
						--while not AreAllNavmeshRegionsLoaded() do
							--print("loading path nodes2")
							--Wait(1)
						--end					
						--does not seem to work in city/downtown, vehicles 
						--get placed in odd places, above commented out code did not seem to help
						local boolval, npos, heading = GetNthClosestVehicleNodeWithHeading(rXoffset,rYoffset,rZoffset,1,9,3.0,2.5)
						
						
						
						--local boolval2, npos2, headin2g GetNthClosestVehicleNodeIdWithHeading(rXoffset,rYoffset,rZoffset,1,9,3.0,2.5)
						
						--print(IsVehicleNodeIdValid(npos2))
						
						if boolval then 
						
							--print("made it path")
							rXoffset = npos.x
							rYoffset = npos.y
							rZoffset = npos.z
							rHeading = heading
						
						
						end 
					end
					
					if raytestsuccess then 
						--print("hey"..i)
						PedVehicle = CreateVehicle(vehiclehash, rXoffset, rYoffset, rZoffset + spawnAircraft,  rHeading, 1, 0)
						
						if rZoffset ==0.0 and not (IsThisModelABoat(vehiclehash) or IsThisModelAPlane(vehiclehash) or IsThisModelAHeli(vehiclehash)) then 
							DecorSetInt(PedVehicle,"mrpvehdidGround",1)
							FreezeEntityPosition(PedVehicle,true)
						end
					end 
					
					if not DoesEntityExist(PedVehicle) then 
						--print("veh retry:"..veh)
						--print("spawnaircraft:"..rXoffset..", "..rYoffset..",".. rZoffset + spawnAircraft)
						Wait(1)
						raytestsuccess = false
					end	

					tries = tries + 1
				--end				
				until( raytestsuccess == true or tries > 250 )			
			
			
					
			end 
			
			--print("rZoffset:"..rZoffset)
			--print("checkthisspawn:"..tostring(checkthisspawn))
			--print("checkspawns:"..tostring(checkspawns))
			
			--if(rZoffset <= 0.0) then 
				--print ("bad spawn v")
				--raytestsuccess = false
			--end

			
			rHeading = roundToNthDecimal(math.random() + math.random(0,359),2)
			
			
			
			if raytestsuccess then 
				--print("yeh"..i)
					--for BountyHunt Assassinate missions, we are going to spawn squads
					if not IsBountyHuntDoBoatsFoundWater and (getMissionConfigProperty(input, "IsBountyHunt")) then
						--print("do"..i)
						TriggerEvent("doRandomSquad",NumPeds + i, rXoffset, rYoffset, rZoffset,input)
					end
	
			
				--Wait(1)
				--print("veh:"..veh)
				--print("randomPedWeaponHash"..randomPedWeaponHash)
				--PedVehicle = CreateVehicle(vehiclehash, rXoffset, rYoffset, rZoffset + spawnAircraft,  rHeading, 1, 0)
				--SetModelAsNoLongerNeeded(vehiclehash)
				
				--Stop AI from blowing themselves up!
				--SetEntityCanBeDamagedByRelationshipGroup(PedVehicle, false, GetHashKey("HATES_PLAYER"))
				--SetEntityCanBeDamagedByRelationshipGroup(PedVehicle, false, GetHashKey("TRUENEUTRAL"))
				if not getMissionConfigProperty(input,"IsDefendTarget") or (getMissionConfigProperty(input,"IsDefendTarget") and getMissionConfigProperty(input,"IsDefendTargetOnlyPlayersDamagePeds") ) then				
					SetEntityOnlyDamagedByPlayer(PedVehicle, true)
				end
				
				if getMissionConfigProperty(input,"MissionDoBackup") then
					SetEntityOnlyDamagedByPlayer(PedVehicle, false)
					SetEntityCanBeDamagedByRelationshipGroup(PedVehicle,false,"HATES_PLAYER")
					SetEntityCanBeDamagedByRelationshipGroup(PedVehicle,true,"PLAYER")
					SetEntityCanBeDamagedByRelationshipGroup(PedVehicle,true,"ISDEFENDTARGET")
				end				
							
				--if DoesEntityExist(PedVehicle) then 
					--print("spawned:"..veh)
					--print("spawnaircraft:"..rXoffset..", "..rYoffset..",".. rZoffset + spawnAircraft)
				--end
				
				local firingpatterns = doVehicleMods(randomPedVehicleHash,PedVehicle,input) 
				
				--make planes head towards safe house if turned on and teleport is turned on too
				--a bit of a workaround to make up for planes crashing when spawned
				local pmodel = GetEntityModel(PedVehicle) 
				if getMissionConfigProperty(input, "SafeHousePlaneAttack") and (IsThisModelAPlane(pmodel)) and getMissionConfigProperty(input, "UseSafeHouse") and getMissionConfigProperty(input, "TeleportToSafeHouseOnMissionStart") and Config.Missions[input].MarkerS then 
					
					local origx =  Config.Missions[input].MarkerS.Position.x
					local origy =  Config.Missions[input].MarkerS.Position.y
					local p1 = GetEntityCoords(PedVehicle, true)
					
					local dx = origx - p1.x
					local dy = origy - p1.y
						
					local heading = GetHeadingFromVector_2d(dx, dy)				 
					SetEntityHeading(PedVehicle,heading) 
				elseif IsThisModelAPlane(pmodel) or IsThisModelAHeli(pmodel)  then --let hydras be more like helicopters --and not tostring(pmodel) == '970385471'
					--lets select random players to head towards so planes dont just head out to sea. TaskPlaneMission/TaskHeliMission does not seem to work for me to make them circle/guard mission Blip (at least from long distance)
					
					local cnt = 0
					local tries = 0
					local foundplayer=false
					math.randomseed(GetGameTimer())
					ptable = GetPlayers()
					for _, k in ipairs(ptable) do
						cnt = cnt + 1 
						--print('player num:'..k)
					end
					--print('player count'..cnt)
					
					-- i.e. 8 players, then 1 in 8 chance per player
					if(cnt > 1) then
						local chance = cnt - 1
						repeat 
							
							for _, k in ipairs(ptable) do
								Wait(1)
								math.randomseed(GetGameTimer())
								if(math.random(1,cnt) > chance and k ~=lastrandomplayer) then
									makeEntityFaceEntity(PedVehicle,GetPlayerPed(k))
									foundplafer = true
									lastrandomplayer = k
									break
								end						
								tries = tries + 1
							end	
						until (foundplayer or tries > 25)
					else 
						makeEntityFaceEntity(PedVehicle,GetPlayerPed(-1))
					end				
				end
				
				
				SetEntityAsMissionEntity(PedVehicle,true,true)
				
				--DoesEntityExist check here?
				--[[
				if checkthisspawn then 
					--print('VEHICLECHECKTHISSPAWN')
					DecorSetInt(PedVehicle,"mrpcheckspawn",1) --flag Vehicle to be checked to readjust if necessary later 
				else 
					DecorSetInt(PedVehicle,"mrpcheckspawn",0)
				end
				]]--
				DecorSetInt(PedVehicle,"mrpvehdid",i)
				if randomPedModelHash ~=nil then 
					
					--START IsBountyHunt HACK 
					--this is a HACK to not have the same 
					--identical 'boss' models like in a multi-seat vehicle
					--since the turrets subroutine I never felt
					--I fixed correctly to place random passengers
					local maxseatid = GetVehicleMaxNumberOfPassengers(PedVehicle) 
					--see if a driver only vehicle is defined in VehicleTurretSeatIds
					--i.e..,apc = {},..
					--if #getMissionConfigProperty(input, "VehicleTurretSeatIds")[veh]==0 then 
						--print("turret made it"..getMissionConfigProperty(input, "VehicleTurretSeatIds")[veh])
						--maxseatid = 1
					--end
					if maxseatid > 1 and getMissionConfigProperty(input, "IsBountyHunt") then 
						--print("bounty hack"..randomPedModelHash)
						SetModelAsNoLongerNeeded(randomPedModelHash)
						randomPedModelHash = getMissionConfigProperty(input, "RandomMissionIsBountyOverrideVehPeds")[math.random(1, #getMissionConfigProperty(input, "RandomMissionIsBountyOverrideVehPeds"))]
						RequestModel(randomPedModelHash)
					end
					--END IsBountyHunt HACK
					while not HasModelLoaded(randomPedModelHash)  do
						Wait(1)
					end
					Ped = CreatePed(2, randomPedModelHash, rXoffset, rYoffset,rZoffset, rHeading, true, true)
					SetModelAsNoLongerNeeded(randomPedModelHash)
					SetEntityAsMissionEntity(Ped,true,true)
					
					if getMissionConfigProperty(input,"IsDefendTargetEnemySetBlockingOfNonTemporaryEvents") then 
						SetBlockingOfNonTemporaryEvents(Ped,true)
					end							
					
					--Stop AI from blowing themselves up!
					--SetEntityCanBeDamagedByRelationshipGroup(Ped, false, GetHashKey("HATES_PLAYER"))
					--SetEntityCanBeDamagedByRelationshipGroup(Ped, false, GetHashKey("TRUENEUTRAL"))
					SetPedAccuracy(Ped,math.random(getMissionConfigProperty(input, "SetPedMinAccuracy"),getMissionConfigProperty(input, "SetPedMaxAccuracy")))
					
					if not getMissionConfigProperty(input,"IsDefendTarget") or (getMissionConfigProperty(input,"IsDefendTarget") and getMissionConfigProperty(input,"IsDefendTargetOnlyPlayersDamagePeds") ) then			
						SetEntityOnlyDamagedByPlayer(Ped, true)
					end
					
					if getMissionConfigProperty(input,"MissionDoBackup") then
						SetEntityOnlyDamagedByPlayer(Ped, false)
						SetEntityCanBeDamagedByRelationshipGroup(Ped,false,"HATES_PLAYER")
						SetEntityCanBeDamagedByRelationshipGroup(Ped,true,"PLAYER")
						SetEntityCanBeDamagedByRelationshipGroup(Ped,true,"ISDEFENDTARGET")
					end											

					
					if(randomPedModelHash  == "s_m_m_movalien_01") then
						SetPedDefaultComponentVariation(Ped) --GHK for s_m_m_movalien_01
					end
					
					DecorSetInt(Ped,"mrpvpedid",i)
					DecorSetInt(Ped,"mrpvpeddriverid",i)
					
					--make all vehicle drivers TRUENUTRAL 'Conqueror' NPCs, so they make a beeline to the Marker
					--except for aircraft peds which need default to fly
					if not getMissionConfigProperty(input, "IsDefend")  or spawnAircraft > 0 then --or ( getMissionConfigProperty(input, "IsDefend") and getMissionConfigProperty(input, "IsDefendTarget"))
						
						
						SetPedRelationshipGroupHash(Ped, GetHashKey("HATES_PLAYER"))
						SetRelationshipBetweenGroups(5, GetHashKey("HATES_PLAYER"), GetHashKey("PLAYER"))
						SetRelationshipBetweenGroups(0, GetHashKey("HATES_PLAYER"), GetHashKey("HATES_PLAYER"))
						SetRelationshipBetweenGroups(5, GetHashKey("HATES_PLAYER"), GetHashKey("ISDEFENDTARGET"))
						SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("HATES_PLAYER"))	
						SetRelationshipBetweenGroups(0, GetHashKey("HATES_PLAYER"), GetHashKey("TRUENEUTRAL"))
						
						if MissionType == "Assassination" then 
								--50% chance to flee
							if math.random(2) > 1  then --flee
								
								
								SetPedFleeAttributes(Ped, 0, 0)
								SetPedCombatAttributes(Ped, 5, true)	
								SetPedCombatAttributes(Ped, 16, true)
								SetPedCombatAttributes(Ped, 46, true)
								SetPedCombatAttributes(Ped, 26, true)
							
							
							end 
							
						else 
							SetPedFleeAttributes(Ped, 0, 0)
							SetPedCombatAttributes(Ped, 5, true)	
							SetPedCombatAttributes(Ped, 16, true)
							SetPedCombatAttributes(Ped, 46, true)
							SetPedCombatAttributes(Ped, 26, true)
							
						end	
						SetPedCombatAttributes(Ped, 3, false)
						SetPedCombatAttributes(Ped, 2, true)
						
						SetPedCombatAttributes(Ped, 1, true) --can use vehicles
						
					else 
					
						-- is there a better way to make an NPC true neutral?
						--does not handle custom groups from other resources
						SetPedFleeAttributes(Ped, 0, 0)
						SetPedCombatAttributes(Ped, 3, false)
						
						SetPedCombatAttributes(Ped, 1, true) --can use vehicles
						SetPedCombatAttributes(Ped, 2, true) --can do drivebys
						
						SetPedRelationshipGroupHash(Ped, GetHashKey("TRUENEUTRAL"))
						SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("PLAYER"))
						SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("HATES_PLAYER"))
						SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("HOSTAGES"))
						SetRelationshipBetweenGroups(0, GetHashKey("HATES_PLAYER"), GetHashKey("TRUENEUTRAL"))
						
						SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("CIVMALE"))
						SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("CIVFEMALE"))
						SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("COP"))
						SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("SECURITY_GUARD"))
						SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("PRIVATE_SECURITY"))
						SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("FIREMAN"))
						SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("GANG_1"))
						SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("GANG_2"))
						SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("GANG_9"))
						SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("GANG_10"))
						SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_LOST"))
						SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_MEXICAN"))
						SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_FAMILY"))
						SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_BALLAS"))
						SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_MARABUNTE"))
						SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_CULT"))
						SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_SALVA"))
						SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_WEICHENG"))
						SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_HILLBILLY"))
						SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("DEALER"))
						SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("WILD_ANIMAL"))
						SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("SHARK"))
						--SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("HATES_PLAYER"))
						SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("COUGAR"))
						SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("NO_RELATIONSHIP"))
						SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("SPECIAL"))
						SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION2"))		
						SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("NO_RELATIONSHIP"))
						SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("SPECIAL"))
						SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION2"))			
						SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION3"))
						SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION4"))
						SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION5"))			
						SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION6"))
						SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION7"))
						SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION8"))			
						SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("ARMY"))
						SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("GUARD_DOG"))
						SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AGGRESSIVE_INVESTIGATE"))						
						SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MEDIC"))
						SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("PRISONER"))	
						SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("DOMESTIC_ANIMAL"))	
						SetRelationshipBetweenGroups(5, GetHashKey("TRUENEUTRAL"), GetHashKey("ISDEFENDTARGET"))
					
					end 	
						
					 SetPedSeeingRange(Ped, 10000.0)
					 SetPedHearingRange(Ped, 10000.0)

					
					
					if firingpatterns.driverfiringpattern then
						--print("firingpatterns.driverfiringpattern"..tostring(firingpatterns.driverfiringpattern))
						SetPedFiringPattern(Ped, firingpatterns.driverfiringpattern) 
					end
							
					
					--[[
					if not getMissionConfigProperty(input, "NerfDriverTurrets") then 
						SetPedFiringPattern(Ped, 0x914E786F) --FIRING_PATTERN_BURST_FIRE_HELI
					end 					
					
					
					--if rhino or khanjali, nerf them to be slower fire rate?
					--local vehicleModel = GetEntityModel(PedVehicle)
					if tostring(pmodel) == "782665360" or tostring(pmodel) == "-1435527158" then 
						--nerf tank cannon?
						if getMissionConfigProperty(input, "NerfTankCannon") then 
							SetPedFiringPattern(Ped,  0xE2CA3A71) --FIRING_PATTERN_SLOW_FIRE_TANK
						end 
					end
					]]--
					
					SetPedDropsWeaponsWhenDead(Ped, getMissionConfigProperty(input, "SetPedDropsWeaponsWhenDead"))
					SetPedDiesWhenInjured(Ped, true)
					
					--GIVE WEAPONS TO PED DRIVERS
					--override for boats,bikes and quads...
					if IsThisModelABike(pmodel) or IsThisModelABicycle(pmodel) or IsThisModelAQuadbike(pmodel) or  IsThisModelABoat(pmodel) then
						randomPedWeaponHash = getMissionConfigProperty(input, "RandomMissionBikeQuadBoatWeapons")[math.random(1, #getMissionConfigProperty(input, "RandomMissionBikeQuadBoatWeapons"))]
					end
					
					GiveWeaponToPed(Ped, randomPedWeaponHash, 2800, false, true)
					SetPedInfiniteAmmo(Ped, true, randomPedWeaponHash)
					SetPedAlertness(Ped,3)	
					ResetAiWeaponDamageModifier()
					SetPedIntoVehicle(Ped, PedVehicle, -1)
					
					--if Config.Missions[input].Vehicles[i].invincible then
						--SetEntityInvincible(Ped, true)
					--end
					
					--if Config.Missions[input].Vehicles[i].dead then
						--SetEntityHealth(Ped, 0.0)
						
					--end							
					
					---**Just Driver Ped**
					--ExtraPeds
					--if Config.Missions[input].Vehicles[i].ExtraPeds then
				
						--for j, v in pairs(Config.Missions[input].Vehicles[i].ExtraPeds) do
				
							--SetPedIntoVehicle(Config.Missions[input].Peds[v.id].id, PedVehicle, v.seatid)
						--end
					
					--end 	
					
					--50% to be driving, unless a plane, so always drives
					--SetBlockingOfNonTemporaryEvents(Ped, true)
					local movespeed = GetVehicleMaxSpeed(pmodel) --1200.0 --how fast can a vehicle go?
					if math.random(2) > 1 or spawnAircraft > 0  then
							--if Config.Missions[input].Vehicles[i].movespeed ~= nil then

								--TaskVehicleDriveWander(Ped, GetVehiclePedIsIn(Ped, false), Config.Missions[input].Vehicles[i].movespeed, 0)
							--else
						
						
						if spawnAircraft > 0 then
						
							SetHeliBladesFullSpeed(PedVehicle) -- works for planes I guess
							SetVehicleEngineOn(PedVehicle, true, true, false)
							SetVehicleForwardSpeed(PedVehicle, 60.0)
							SetVehicleLandingGear(PedVehicle, 3) --make sure landing gear is retracted
							if(IsThisModelAPlane(pmodel)) and tostring(pmodel) ~= '970385471' then --treat hydra like a heli
								SetVehicleForwardSpeed(PedVehicle, movespeed)
								--TaskPlaneMission(Ped,PedVehicle,0, 0, Config.Missions[MissionName].Blip.Position.x,Config.Missions[MissionName].Blip.Position.y, Config.Missions[MissionName].Blip.Position.z, 9, 0.0, 0.0, 0.0, 3000.0, 200.0) 

								--make sure a reasonable speed 
								TaskVehicleDriveWander(Ped, GetVehiclePedIsIn(Ped, false), 240.0, 0) --PedVehicle
								
								--TaskCombatHatedTargetsAroundPed(Ped,12000.0)
								
								
							else
								--dont have helicopters fly away if possible, they will defend the Objective
								if Config.Missions[input].Type =="Assassinate" then
									--TaskVehicleDriveWander(Ped, GetVehiclePedIsIn(Ped, false), movespeed, 0) --PedVehicle
									--TaskCombatHatedTargetsAroundPed(Ped,12000.0)
								else 
									--TaskCombatHatedTargetsAroundPed(Ped,12000.0)
								end
								--SetCurrentPedVehicleWeapon(Ped,GetHashKey("VEHICLE_WEAPON_PLAYER_BUZZARD"))
								--SetMountedWeaponTarget(Ped,GetPlayerPed(-1),0)
								--print("made it")
								--TaskVehicleShootAtPed(Ped,GetPlayerPed(-1),1.0)
								--do a check for heli model to use below:
								--TaskHeliMission(Ped, PedVehicle, 0, 0, Config.Missions[MissionName].Blip.Position.x,Config.Missions[MissionName].Blip.Position.y, Config.Missions[MissionName].Blip.Position.z, 4, 1.0, -1.0, -1.0, 10, 10, 5.0, 0)
							end
						else 
							--dont have vehicles drive away if possible, they will defend the Objective
							if Config.Missions[input].Type =="Assassinate" then		
								--print('ok')
								TaskVehicleDriveWander(Ped, GetVehiclePedIsIn(Ped, false), movespeed, 0)
								--TaskBoatMission(Ped, GetVehiclePedIsIn(Ped, false), 0, 0, 0.0, 0.0, 0.0, 4, vehicleMaxSpeed, 786469, -1.0, 7)								
								--SetBlockingOfNonTemporaryEvents(Ped, true)

							end
							if IsThisModelABoat(pmodel) and math.random(2) > 1 then 
								TaskVehicleDriveWander(Ped, GetVehiclePedIsIn(Ped, false), movespeed, 0)
							end								
							
						end
						--end
						
							--else 
							--TaskVehicleFollow(Ped, GetVehiclePedIsIn(Ped, false), GetPlayerPed(-1), 0, 20.0, 5)
					end
					
					
					
					if true then  --if spawnAircraft == 0 then 
					
						if getMissionConfigProperty(input, "RandomMissionGuardAircraft") and i == 1 then
										
						--print("made it")
										local vehname = "TRAILERSMALL"
								
										RequestModel(GetHashKey(vehname))
										while not HasModelLoaded(GetHashKey(vehname))   do
											Wait(1)
										end
									
										
										local tveh = CreateVehicle(GetHashKey(vehname), Config.Missions[input].Blip.Position.x-20.0, Config.Missions[input].Blip.Position.y-20.0,Config.Missions[input].Blip.Position.z,  0.0, 1, 0)	
										DecorSetInt(tveh,"mrpvehdid",99997755)
										SetEntityVisible(tveh,false,0)
										SetEntityCollision(tveh,false,true)		
				
										FreezeEntityPosition(tveh,true)
			

										-- is there a better way to make an NPC true neutral?
										--does not handle custom groups from other resources
										--[[
										SetPedFleeAttributes(Ped, 0, 0)
										SetPedCombatAttributes(Ped, 3, false)
										
										SetPedCombatAttributes(Ped, 1, true) --can use vehicles
										SetPedCombatAttributes(Ped, 2, true) --can do drivebys
										
										SetPedRelationshipGroupHash(Ped, GetHashKey("TRUENEUTRAL"))
										SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("PLAYER"))
										SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("HATES_PLAYER"))
										SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("HOSTAGES"))
										SetRelationshipBetweenGroups(0, GetHashKey("HATES_PLAYER"), GetHashKey("TRUENEUTRAL"))
										
										SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("CIVMALE"))
										SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("CIVFEMALE"))
										SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("COP"))
										SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("SECURITY_GUARD"))
										SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("PRIVATE_SECURITY"))
										SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("FIREMAN"))
										SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("GANG_1"))
										SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("GANG_2"))
										SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("GANG_9"))
										SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("GANG_10"))
										SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_LOST"))
										SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_MEXICAN"))
										SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_FAMILY"))
										SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_BALLAS"))
										SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_MARABUNTE"))
										SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_CULT"))
										SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_SALVA"))
										SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_WEICHENG"))
										SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_HILLBILLY"))
										SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("DEALER"))
										SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("WILD_ANIMAL"))
										SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("SHARK"))
										--SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("HATES_PLAYER"))
										SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("COUGAR"))
										SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("NO_RELATIONSHIP"))
										SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("SPECIAL"))
										SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION2"))		
										SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("NO_RELATIONSHIP"))
										SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("SPECIAL"))
										SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION2"))			
										SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION3"))
										SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION4"))
										SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION5"))			
										SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION6"))
										SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION7"))
										SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION8"))			
										SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("ARMY"))
										SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("GUARD_DOG"))
										SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AGGRESSIVE_INVESTIGATE"))						
										SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MEDIC"))
										SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("PRISONER"))	
										SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("DOMESTIC_ANIMAL"))	
										SetRelationshipBetweenGroups(5, GetHashKey("TRUENEUTRAL"), GetHashKey("ISDEFENDTARGET"))

]]--
										
						
									if IsThisModelAPlane(pmodel) then 
										--print("hey")
										--print("guard aircraft spawned:"..veh)
										SetVehicleForwardSpeed(PedVehicle,movespeed)
										SetHeliBladesFullSpeed(PedVehicle) -- works for planes I guess
										SetVehicleEngineOn(PedVehicle, true, true, false)	
										SetBlockingOfNonTemporaryEvents(Ped,true)										
										TaskPlaneChase(Ped,tveh,0.0, 0.0, 5.0)
										local tcoords = GetEntityCoords(tveh)
										
										--TaskPlaneMission(Ped,PedVehicle,0,0,tcoords.x,tcoords.y,tcoords.z,6,
								--0.0,0.0,0.0,2500.0, -1500.0)
										
										--TaskCombatPed(Ped,GetPlayerPed(-1),0, 16)
										

									elseif IsThisModelAHeli(pmodel) then
										--print("made it")
										--print("hey2")
										--print("guard heli spawned:"..veh)
										--ClearPedTasks(Config.Missions[input].Vehicles[i].id2)
										SetVehicleForwardSpeed(PedVehicle,60.0)
										SetHeliBladesFullSpeed(PedVehicle) -- works for planes I guess
										SetVehicleEngineOn(PedVehicle, true, true, false)
										SetBlockingOfNonTemporaryEvents(Ped,true)												
										--TaskHeliChase(Ped,tveh,0.0, 0.0, 5.0)
										
										TaskHeliMission(Ped,PedVehicle,tveh,0,0.0,0.0,0.0,9,movespeed,0.0,1.0, -1, -1, -1, 0)	
										
										--TaskCombatPed(Ped,GetPlayerPed(-1),0, 16)						
						
									end
									
						elseif Config.Missions[input].IsDefend and not Config.Missions[input].IsDefendTarget and spawnAircraft  == 0 then -- and spawnAircraft  == 0 then ? --AIRCRAFT TOO?
								
								--aircraft peds dont like the task
									--print("VEHICLE PED GOES TO x:"..Config.Missions[input].Marker.Position.x..", y:".. Config.Missions[input].Marker.Position.y..",z:"..Config.Missions[input].Marker.Position.z)
					
									--ClearPedTasksImmediately(Ped)
									--TaskVehicleDriveToCoordLongrange(Ped,  PedVehicle, Config.Missions[input].Marker.Position.x, Config.Missions[input].Marker.Position.y,--Config.Missions[input].Marker.Position.z, movespeed, 0, 0.0) --drive mode is zero
									--SetPedKeepTask(Ped,true) 									
						elseif 	Config.Missions[input].IsDefend and Config.Missions[input].IsDefendTarget then
							--print("made it")
								if(Config.Missions[input].IsVehicleDefendTargetChase) then
									if TargetPed ==nil then
										print("NIL TargetPed for IsDefendTarget")
									end
								
									--print('TASK TaskVehicleChase')
									--ClearPedTasksImmediately(Ped)
									--TaskVehicleChase(Config.Missions[input].Vehicles[i].id2, TargetPed, false))
									--TaskGoToEntity(Config.Missions[input].Peds[i].id, TargetPed, 360000, 5.0, movespeed,1073741824, 0)
									--TaskVehicleEscort(Ped, PedVehicle, TargetPedVehicle, 0, movespeed, 0, 5.0, -1, 2000)
									--TaskGoStraightToCoord(Config.Missions[input].Peds[i].id,Config.Missions[input].Marker.Position.x, Config.Missions[input].Marker.Position.y,Config.Missions[input].Marker.Position.z, movespeed, 100000, 0.0, 0.0) 
									--SetPedKeepTask(Ped,true)
									
									if IsThisModelAPlane(pmodel) then 
										--print("hey")
										
										SetVehicleForwardSpeed(PedVehicle,movespeed)
										SetHeliBladesFullSpeed(PedVehicle) -- works for planes I guess
										SetVehicleEngineOn(PedVehicle, true, true, false)			
										--TaskPlaneChase(Ped,TargetPedVehicle,0.0, 0.0, 5.0)
										--TaskCombatPed(Ped,TargetPed,0, 16)
										
										--use vehicle to target:
										--print("hey")
										SetBlockingOfNonTemporaryEvents(Ped,true)
										TaskPlaneMission(Ped,PedVehicle,TargetPedVehicle,0,0,0,0,6,
										0.0,0.0,0.0,2500.0, -1500.0)										
										

									elseif IsThisModelAHeli(pmodel) then
										--print("made it")
										--print("hey2")
										--ClearPedTasks(Config.Missions[input].Vehicles[i].id2)
										SetVehicleForwardSpeed(PedVehicle,60.0)
										SetHeliBladesFullSpeed(PedVehicle) -- works for planes I guess
										SetVehicleEngineOn(PedVehicle, true, true, false)										
										--TaskHeliChase(Ped,TargetPedVehicle,0.0, 0.0, 5.0)
										--TaskCombatPed(Ped,TargetPed,0, 16)
										SetBlockingOfNonTemporaryEvents(Ped,true)
										TaskHeliMission(Ped,PedVehicle,TargetPedVehicle,0,0.0,0.0,0.0,9,movespeed,0.0,1.0, -1, -1, -1, 0)											
										
									elseif IsThisModelABoat(pmodel) then	
										SetBlockingOfNonTemporaryEvents(Ped,true)
										--TaskCombatPed(Ped,TargetPed,0, 16)

										TaskVehicleMissionPedTarget(Ped,PedVehicle,TargetPed,7, movespeed, 0, 300.0, 15.0, 1)
										--print("made it")										
									else
										--print("made it")
										
										SetBlockingOfNonTemporaryEvents(Ped,true)
										--TaskVehicleMissionPedTarget(Ped,PedVehicle,TargetPed,7, movespeed, 0, 300.0, 15.0, 1)
										--seems to be better driving AI:?
										TaskVehicleMissionPedTarget(Ped,PedVehicle,TargetPed,7, movespeed, 786469, 15.0, -1, 1)
										
										--local _, sequence = OpenSequenceTask(0)
										
										--TaskEnterVehicle( 0,  PedVehicle, 20000,-1, 1.5, 1, 0)
										--TaskVehicleChase(0, TargetPed)
										
										--if IsThisModelAHeli(pmodel) then 
											--TaskHeliChase(0,TargetPedVehicle,0.0, 0.0, 5.0)
										--else 
										
										--TaskVehicleEscort(0,PedVehicle, TargetPedVehicle, 0, movespeed, 0, 5.0, -1, 2000)						
										
										--end

										--TaskCombatHatedTargetsAroundPed(0,1000.0,0)
										
										--NEEDED???
										--TaskCombatPed(Ped,TargetPed,0, 16)
									
									
										--TaskVehicleShootAtPed(0,TargetPed,100.0)							
										
										--RegisterTarget(Config.Missions[input].Peds[i].id, TargetPed)
										
										--TaskCombatPed(0, TargetPed, 0, 16)
										--next line was needed in this case:
										
										--SetSequenceToRepeat(sequence, 1)
										--CloseSequenceTask(sequence)
										--ClearPedTasks(Ped)
										--ClearPedTasksImmediately(Ped)

												
										--TaskPerformSequence(Ped, sequence)
										--ClearSequenceTask(sequence)							
									
									end 



								
								
								end
								
								if (not Config.Missions[input].IsVehicleDefendTargetChase) and (Config.Missions[input].IsVehicleDefendTargetGotoBlip) and spawnAircraft  == 0 then
									ClearPedTasksImmediately(Ped)
									
									TaskVehicleDriveToCoordLongrange(Ped, PedVehicle, Config.Missions[input].Blip.Position.x, Config.Missions[input].Blip.Position.y,Config.Missions[input].Blip.Position.z, movespeed, 0, 0.0) --drive mode is zero
									SetPedKeepTask(Ped,true) 		
								
								end						 
						--else
						end
					else
					--print("spawn aircraft =0")
					end
					--end					
					
					
					--SetPedIntoVehicle(Config.Missions[input].Peds[1].id, PedVehicle, -2)
					--ped = AddBlipForEntity(PedVehicle)
					--Add blip to actual ped, not vehicles
					--local pedb = AddBlipForEntity(Ped)
					--target=true --<----??????
					--local Size     = 0.9
					--SetBlipScale(pedb, Size)
					--SetBlipAsShortRange(pedb, false)
					
					if spawnFriendly then --disabled
						--SetBlipSprite(pedb, 280)
						--SetBlipColour(pedb, 2)
						DecorSetInt(Ped,"mrppedfriend",i)
						if getMissionConfigProperty(input, "Type") == "HostageRescue" then
							IsRandomMissionHostageCount = IsRandomMissionHostageCount + 1
						end

						if getMissionConfigProperty(input, "DelicateHostages") then 
							SetEntityOnlyDamagedByPlayer(Ped, false)

						else			
							SetEntityOnlyDamagedByPlayer(Ped, true)							
						
						end					
						--BeginTextCommandSetBlipName("STRING")
						--AddTextComponentString("Friend ($-"..getHostageKillPenalty(input)..")")
						--EndTextCommandSetBlipName(pedb)				        
					elseif MissionType=="Assassinate" then --if ped is a target in assassinate
						--SetBlipColour(ped, 66)
						--SetBlipSprite(pedb, 433)
						--SetBlipColour(pedb, 27)
						DecorSetInt(Ped,"mrppedtarget",i)
						--BeginTextCommandSetBlipName("STRING")
						--AddTextComponentString("Target ($"..getTargetKillReward(input)..")")
						--EndTextCommandSetBlipName(pedb)						
					else
					--	SetBlipColour(pedb, 1)
					--	BeginTextCommandSetBlipName("STRING")
					--	AddTextComponentString("Enemy ($"..getKillReward(input)..")")
					--	EndTextCommandSetBlipName(pedb)							
					
					end	

					--if Config.Missions[input].Vehicles[i].armor then --if ped has armor
						AddArmourToPed(Ped, 100)
						SetPedArmour(Ped, 100)
					--end						
					
					SetAiWeaponDamageModifier(1.0) -- 1.0 == Normal Damage. 
					-- ^ Sets Custom NPC Damage. ^
					
					--Now check if Vehicle has turrets and fill those positions...
					--local randomPedWeaponHash = getMissionConfigProperty(input, "RandomMissionWeapons")[math.random(1, #getMissionConfigProperty(input, "RandomMissionWeapons"))]
					PutPedsIntoTurrets(PedVehicle,randomPedVehicleHash,randomPedModelHash,randomPedWeaponHash,MissionType,firingpatterns.turretfiringpattern,input,i)
					
					--check if we need to add an AA trailer
					--Not working
					--AddTrailer(veh,PedVehicle,input) 
					
				--Wait(1)
				end
			end
		end
    end
	--DEPRECATED: NEED TO REMOVE:
	if checkspawns then --tell other clients to check as well looking for the mrpcheckspawn decor value > 0
		TriggerServerEvent("sv:checkspawns",checkspawns)
	end 
	
	if getMissionConfigProperty(input, "Type") == "HostageRescue" then
		--print("IsRandomMissionHostageCount"..IsRandomMissionHostageCount)
		isHostageRescueCount = IsRandomMissionHostageCount
		TriggerServerEvent("sv:IsRandomMissionHostageCount",IsRandomMissionHostageCount)
	end
	
	--SPAWN SAFE HOUSE PEDS TOO
	if getMissionConfigProperty(input, "UseSafeHouse") then
		SpawnSafeHouseProps(input,rIndex,IsRandomSpawnAnywhereInfo) 	
	end
	PedsSpawned = 1
    aliveCheck()
end)




RegisterNetEvent('SpawnPed')
AddEventHandler('SpawnPed', function(input)


	if getMissionConfigProperty(input, "MissionTriggerRadius") then 
	
		local mcoords = {x=0,y=0,z=0}
		if getMissionConfigProperty(input, "MissionTriggerStartPoint") then 
			
			mcoords.x = getMissionConfigProperty(input, "MissionTriggerStartPoint").x
			mcoords.y = getMissionConfigProperty(input, "MissionTriggerStartPoint").y
			mcoords.z = getMissionConfigProperty(input, "MissionTriggerStartPoint").z
		
		elseif Config.Missions[input].Blip then
			mcoords.x = Config.Missions[input].Blip.Position.x
			mcoords.y = Config.Missions[input].Blip.Position.y
			mcoords.z = Config.Missions[input].Blip.Position.z		
			
		elseif Config.Missions[input].Blips and Config.Missions[input].Blips[1] then
			mcoords.x = Config.Missions[input].Blips[1].Position.x
			mcoords.y = Config.Missions[input].Blips[1].Position.y
			mcoords.z = Config.Missions[input].Blips[1].Position.z
		
		end	
		
		local playerTriggered = false
		 BLHOSTFLAG = true
		 
		--spawn safe house props: 
		if getMissionConfigProperty(input, "UseSafeHouse") then
			SpawnSafeHouseProps(input,rIndex,IsRandomSpawnAnywhereInfo) 	
		end		

		MissionSpawnedSafeHouseProps = true		
		 
		repeat
	
		local coords = GetEntityCoords(GetPlayerPed(-1))
		
			--print(GetDistanceBetweenCoords(coords.x,coords.y,coords.z, 
			--	mcoords.x,
			--	mcoords.y,
			--	mcoords.z, false))
			 BLHOSTFLAG = true
			if GetDistanceBetweenCoords(coords.x,coords.y,coords.z, 
				mcoords.x,
				mcoords.y,
				mcoords.z, false) <= getMissionConfigProperty(input, "MissionTriggerRadius") and DecorGetInt(GetPlayerPed(i),"mrpoptout")==0 then 
				playerTriggered = true
				
			end 
			Wait(1)
			BLHOSTFLAG = true
			 
			 --if mission is stopped, exit out of the event:
			if Active == 0 or MissionName =="N/A" then
			
				return
			end	
					 
		until playerTriggered or MissionTriggered  or MissionTimeOut
		
		if MissionTimeOut then 
		
			Active = 0
			message2 = "^1[MISSIONS]: ^2'".. Config.Missions[MissionName].MissionTitle .."'^0 has been canceled"
			TriggerServerEvent("sv:two", message2)
			TriggerServerEvent("sv:done", MissionName,true,false,"")
			--TriggerEvent("DONE", MissionName) --ghk needed?
			aliveCheck() --<-- NEEDED?
			MissionName = "N/A"			
		
		
		end
		

		
		if playerTriggered and not MissionTriggered then 
			
			TriggerServerEvent("sv:CheckHostFlag",BLHOSTFLAG)
			MissionTriggered = true			
			--wait 1 second and check again. 
			--if no mission host where  BLHOSTFLAG = true
			--that triggers the mission with MissionTriggered=true
			--then we need to cancel the mission. 
			--NOTE: THIS SHOULD NEVER HAPPEN HERE, SINCE THIS IS MISSION HOST
			--WHERE BLHOSTFLAG = true
			--Wait(1000)
			--if mission is stopped, exit out of the event:
			--if Active == 1 and MissionName ~="N/A" then
				--return
			--end	
					
			--NOTE: THIS SHOULD NEVER HAPPEN HERE, SINCE THIS IS MISSION HOST
			--WHERE BLHOSTFLAG = true:		
			if playerTriggered and not MissionTriggered then
				--print("made it")
				Active = 0
				message2 = "^1[MISSIONS]: ^2'".. Config.Missions[MissionName].MissionTitle .."'^0 has been canceled"
				TriggerServerEvent("sv:two", message2)
				TriggerServerEvent("sv:done", MissionName,true,false,"")
				--TriggerEvent("DONE", MissionName) --ghk needed?
				aliveCheck() --<-- NEEDED?
				MissionName = "N/A"	

				return
				
			end 			
			
		end
	
	
	end



	
	--get any target ped for IsDefendTarget missions
	local IsDefendTargets = SpawnProps(input) --returns {TargetPed,TargetPedVehicle}
	local TargetPed = IsDefendTargets[1]
	local TargetPedVehicle = IsDefendTargets[2]
	
	--let SpawnAPed function take care of the spawning if IndoorsMission
	if Config.Missions[input].IndoorsMission then 
	
		for i=1, #Config.Missions[input].Peds do
			if Config.Missions[input].Type == "HostageRescue" and Config.Missions[input].Peds[i].friendly and not Config.Missions[input].Peds[i].dead and not Config.Missions[input].Peds[i].rescued then
						
				isHostageRescueCount = isHostageRescueCount + 1
			end
		end
		--SPAWN SAFE HOUSE PEDS TOO, for other missions types, this happens at the bottom of his function
		if getMissionConfigProperty(input, "UseSafeHouse") then
			SpawnSafeHouseProps(input,rIndex,IsRandomSpawnAnywhereInfo) 
		end
		return true
	end
	
	--SpawnMissionPickups(input) --called in missionhb
    for i=1, #Config.Missions[input].Peds do
		
        RequestModel(GetHashKey(Config.Missions[input].Peds[i].modelHash))
        while not HasModelLoaded(GetHashKey(Config.Missions[input].Peds[i].modelHash))  do
          Wait(1)
        end
		
        Config.Missions[input].Peds[i].id = CreatePed(2, Config.Missions[input].Peds[i].modelHash, Config.Missions[input].Peds[i].x, Config.Missions[input].Peds[i].y, Config.Missions[input].Peds[i].z, Config.Missions[input].Peds[i].heading, true, true)
        SetModelAsNoLongerNeeded(Config.Missions[input].Peds[i].modelHash)
		SetEntityAsMissionEntity(Config.Missions[input].Peds[i].id,true,true)
		
		--SetEntityCoords(Config.Missions[input].Peds[i].id,Config.Missions[input].Peds[i].x,Config.Missions[input].Peds[i].y,Config.Missions[input].Peds[i].z)
		
		--Stop AI from blowing themselves up!
		--SetEntityCanBeDamagedByRelationshipGroup(Config.Missions[input].Peds[i].id, false, GetHashKey("HATES_PLAYER"))
		--SetEntityCanBeDamagedByRelationshipGroup(Config.Missions[input].Peds[i].id, false, GetHashKey("TRUENEUTRAL"))	
		if  not getMissionConfigProperty(input,"IsDefendTarget") or (getMissionConfigProperty(input,"IsDefendTarget") and getMissionConfigProperty(input,"IsDefendTargetOnlyPlayersDamagePeds") ) then	
			SetEntityOnlyDamagedByPlayer(Config.Missions[input].Peds[i].id, true)
		end 
		
		if getMissionConfigProperty(input,"MissionDoBackup") then
			SetEntityOnlyDamagedByPlayer(Config.Missions[input].Peds[i].id, false)
			SetEntityCanBeDamagedByRelationshipGroup(Config.Missions[input].Peds[i].id,false,"HATES_PLAYER")
			SetEntityCanBeDamagedByRelationshipGroup(Config.Missions[input].Peds[i].id,true,"PLAYER")
			SetEntityCanBeDamagedByRelationshipGroup(Config.Missions[input].Peds[i].id,true,"ISDEFENDTARGET")
		end		
		
		
		if(Config.Missions[input].Peds[i].modelHash == "s_m_m_movalien_01") then
			SetPedDefaultComponentVariation(Config.Missions[input].Peds[i].id) --GHK for s_m_m_movalien_01
		end
		
		--for IsDefend, they beeline to the objective
		if not Config.Missions[input].Peds[i].conqueror then 
			--use 'notzed' attribute to remove extra zombietype characteristics for these models
			if (Config.Missions[input].Peds[i].modelHash == "u_m_y_zombie_01" or Config.Missions[input].Peds[i].modelHash == "s_m_m_movalien_01" or Config.Missions[input].Peds[i].modelHash ==  "ig_orleans") and not Config.Missions[input].Peds[i].notzed then  --or Config.Missions[input].Peds[i].modelHash ==  "ig_orleans") then --movie zed
					SetPedFleeAttributes(Config.Missions[input].Peds[i].id, 0, 0)
					SetPedCombatAttributes(Config.Missions[input].Peds[i].id, 16, true)
					SetPedCombatAttributes(Config.Missions[input].Peds[i].id, 46, true)
					SetPedCombatAttributes(Config.Missions[input].Peds[i].id, 26, true)
					SetAmbientVoiceName(Config.Missions[input].Peds[i].id, "ALIENS")
					SetPedEnableWeaponBlocking(Config.Missions[input].Peds[i].id, true)			
					DisablePedPainAudio(Config.Missions[input].Peds[i].id,true)
					
				--if not Config.Missions[input].Peds[i].modelHash == "ig_orleans" then
					ApplyPedBlood(Config.Missions[input].Peds[i].id, 3, math.random(0, 4) + 0.0, math.random(-0, 4) + 0.0, math.random(-0, 4) + 0.0, "wound_sheet")
					SetPedIsDrunk(Config.Missions[input].Peds[i].id, true)
					RequestAnimSet("move_m@drunk@verydrunk")
					while not HasAnimSetLoaded("move_m@drunk@verydrunk") do
						Wait(1)
					end
					SetPedMovementClipset(Config.Missions[input].Peds[i].id, "move_m@drunk@verydrunk", 1.0)						
				--end		
					
				--SetPedCombatRange(Config.Missions[input].Peds[i].id, 2)
			  --	SetPedSeeingRange(Config.Missions[input].Peds[i].id, 100000000.0)
				--SetPedHearingRange(Config.Missions[input].Peds[i].id, 100000000.0)
			  --SetPedCombatAttributes(Config.Missions[input].Peds[i].id, 46, true);
			 -- SetPedCombatAttributes(Config.Missions[input].Peds[i].id, 5, true);
			  --SetPedCombatAttributes(Config.Missions[input].Peds[i].id, 1, false);
			  --SetPedCombatAttributes(Config.Missions[input].Peds[i].id, 0, false);
			  --SetPedCombatAbility(Config.Missions[input].Peds[i].id, 0);
			
			  --SetPedRagdollBlockingFlags(Config.Missions[input].Peds[i].id, 4);
			  --SetPedCanPlayAmbientAnims(Config.Missions[input].Peds[i].id, false);	
			  -- SetAmbientVoiceName(Config.Missions[input].Peds[i].id,"ALIENS")
			   --DisablePedPainAudio(Config.Missions[input].Peds[i].id,true)
			  -- RequestAnimSet("move_m@drunk@verydrunk");
			   --SetPedMovementClipset(Config.Missions[input].Peds[i].id, "move_m@drunk@verydrunk",1.0);				
			else 
				if not Config.Missions[input].Peds[i].friendly then
					SetPedCombatAttributes(Config.Missions[input].Peds[i].id, 5, true)
					SetPedCombatAttributes(Config.Missions[input].Peds[i].id, 46, true);
					SetPedCombatAttributes(Config.Missions[input].Peds[i].id, 2, true)
				end
				--SetPedCombatAttributes(Config.Missions[input].Peds[i].id, 0, false);
				SetPedCombatAttributes(Config.Missions[input].Peds[i].id, 0, true);
				SetPedCombatAttributes(Config.Missions[input].Peds[i].id, 1, true) --can use vehicles
				SetPedCombatAttributes(Config.Missions[input].Peds[i].id, 2, true) --can do drivebys
				--SetPedCombatAttributes(Config.Missions[input].Peds[i].id, 1424, true)
				--SetPedCombatAttributes(Config.Missions[input].Peds[i].id, 20, false)
				--TaskCombatPed(Config.Missions[input].Peds[i].id, GetPlayerPed(-1), 0,16)
				--TaskVehicleShootAtPed(Config.Missions[input].Peds[i].id,GetPlayerPed(-1))
			end
		
			if not Config.Missions[input].Peds[i].friendly then
				SetPedRelationshipGroupHash(Config.Missions[input].Peds[i].id, GetHashKey("HATES_PLAYER"))
				SetRelationshipBetweenGroups(5, GetHashKey("HATES_PLAYER"), GetHashKey("PLAYER"))
				SetRelationshipBetweenGroups(0, GetHashKey("HATES_PLAYER"), GetHashKey("HATES_PLAYER"))
				SetRelationshipBetweenGroups(5, GetHashKey("HATES_PLAYER"), GetHashKey("ISDEFENDTARGET"))	
				SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("HATES_PLAYER"))
				SetRelationshipBetweenGroups(0, GetHashKey("HATES_PLAYER"), GetHashKey("TRUENEUTRAL"))
				SetRelationshipBetweenGroups(5, GetHashKey("TRUENEUTRAL"), GetHashKey("ISDEFENDTARGET"))	
			else 
				SetPedRelationshipGroupHash(Config.Missions[input].Peds[i].id, GetHashKey("HOSTAGES"))
				SetRelationshipBetweenGroups(1, GetHashKey("HOSTAGES"), GetHashKey("HATES_PLAYER"))
				SetRelationshipBetweenGroups(1, GetHashKey("HOSTAGES"), GetHashKey("PLAYER"))
	

				if getMissionConfigProperty(input, "DelicateHostages") then 
					SetEntityOnlyDamagedByPlayer(Config.Missions[input].Peds[i].id, false)
				else			
					SetEntityOnlyDamagedByPlayer(Config.Missions[input].Peds[i].id, true)								
				end
				
			end
			
		else  
			-- is there a better way to make an NPC true neutral?
			--does not handle custom groups from other resources
			SetPedFleeAttributes(Config.Missions[input].Peds[i].id, 0, 0)
			SetPedRelationshipGroupHash(Config.Missions[input].Peds[i].id, GetHashKey("TRUENEUTRAL"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("PLAYER"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("HATES_PLAYER"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("HOSTAGES"))
			SetRelationshipBetweenGroups(0, GetHashKey("HATES_PLAYER"), GetHashKey("TRUENEUTRAL"))
			
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("CIVMALE"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("CIVFEMALE"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("COP"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("SECURITY_GUARD"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("PRIVATE_SECURITY"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("FIREMAN"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("GANG_1"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("GANG_2"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("GANG_9"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("GANG_10"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_LOST"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_MEXICAN"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_FAMILY"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_BALLAS"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_MARABUNTE"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_CULT"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_SALVA"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_WEICHENG"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_HILLBILLY"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("DEALER"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("WILD_ANIMAL"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("SHARK"))
			--SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("HATES_PLAYER"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("COUGAR"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("NO_RELATIONSHIP"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("SPECIAL"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION2"))		
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("NO_RELATIONSHIP"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("SPECIAL"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION2"))			
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION3"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION4"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION5"))			
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION6"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION7"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION8"))			
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("ARMY"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("GUARD_DOG"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AGGRESSIVE_INVESTIGATE"))						
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MEDIC"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("PRISONER"))	
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("DOMESTIC_ANIMAL"))
			--For IsDefendTarget Missions:
			SetRelationshipBetweenGroups(5, GetHashKey("TRUENEUTRAL"), GetHashKey("ISDEFENDTARGET"))	
			
			DecorSetInt(Config.Missions[input].Peds[i].id,"mrppedconqueror",i)
			--print('spawned Ped Conqueror')
			
		end
		
		if Config.Missions[input].Peds[i].SetBlockingOfNonTemporaryEvents then 
			SetBlockingOfNonTemporaryEvents(Config.Missions[input].Peds[i].id,true)
		end
		
		--they weill combat but also try and keep to the task
		if Config.Missions[input].Peds[i].attacker then 
			DecorSetInt(Config.Missions[input].Peds[i].id,"mrppedconqueror",i)
		end
		
		--SetEntityAsMissionEntity(Config.Missions[input].Peds[i].id,true,true)
		 SetPedSeeingRange(Config.Missions[input].Peds[i].id, 10000.0)
         SetPedHearingRange(Config.Missions[input].Peds[i].id, 10000.0)
		 
		SetPedAccuracy(Config.Missions[input].Peds[i].id,math.random(getMissionConfigProperty(input, "SetPedMinAccuracy"),getMissionConfigProperty(input, "SetPedMaxAccuracy")))
		
		SetPedPathAvoidFire(Config.Missions[input].Peds[i].id,  1)
		SetPedPathCanUseLadders(Config.Missions[input].Peds[i].id,1)
		SetPedPathCanDropFromHeight(Config.Missions[input].Peds[i].id, 1)
		SetPedPathCanUseClimbovers(Config.Missions[input].Peds[i].id,1)		

		--SetEntityAsMissionEntity(Config.Missions[input].Peds[i].id,true,true)
		DecorSetInt(Config.Missions[input].Peds[i].id,"mrppedid",i)
		
        SetPedDropsWeaponsWhenDead(Config.Missions[input].Peds[i].id, getMissionConfigProperty(input, "SetPedDropsWeaponsWhenDead"))
        SetPedDiesWhenInjured(Config.Missions[input].Peds[i].id, true)
        
		if not Config.Missions[input].Peds[i].friendly then
			
			if Config.Missions[input].Peds[i].isBoss then 
				DecorSetInt(Config.Missions[input].Peds[i].id,"mrppedboss",1)
				doBossBuff(Config.Missions[input].Peds[i].id,Config.Missions[input].Peds[i].modelHash,input,Config.Missions[input].Peds[i].Weapon)					
			else 
				GiveWeaponToPed(Config.Missions[input].Peds[i].id, Config.Missions[input].Peds[i].Weapon, 2800, false, true)
				SetPedInfiniteAmmo(Config.Missions[input].Peds[i].id, true, Config.Missions[input].Peds[i].Weapon)
				if(Config.Missions[input].Peds[i].Weapon == 0x42BF8A85) then 
					--minigun
					SetPedFiringPattern(Config.Missions[input].Peds[i].id, 0x914E786F) --FIRING_PATTERN_BURST_FIRE_HELI
				end	
			end
		
			if getMissionConfigProperty(input, "FastFiringPeds") then 
				SetPedFiringPattern(Config.Missions[input].Peds[i].id, 0xC6EE6B4C) --FIRING_PATTERN_BURST_FIRE_HELI
			end 	
			SetPedAlertness(Config.Missions[input].Peds[i].id,3)	
			
	   end 
		ResetAiWeaponDamageModifier()
		if Config.Missions[input].Peds[i].modelHash == "mp_m_boatstaff_01" then --L. Ron
			SetPedPropIndex(Config.Missions[input].Peds[i].id, 0, 0, 0, 2)
			--SetPedPropIndex(Config.Missions[input].Peds[i].id, 0, 8, 0, 2) 
		end 
		if Config.Missions[input].Peds[i].invincible then
			SetEntityInvincible(Config.Missions[input].Peds[i].id, true)
		end
		
		if Config.Missions[input].Peds[i].dead then
			--ApplyDamageToPed(Config.Missions[input].Peds[i].id,90,true)
			
			--ExplodePedHead(Config.Missions[input].Peds[i].id,0x7F7497E5)
			SetEntityHealth(Config.Missions[input].Peds[i].id, 0.0)
			DecorSetInt(Config.Missions[input].Peds[i].id,"mrppedfriend",0) --make them not friendly so the player is not penalized!
			DecorSetInt(Config.Missions[input].Peds[i].id,"mrppedid",0) --remove all decor 
			DecorSetInt(Config.Missions[input].Peds[i].id,"mrppedtarget",0) --remove all decor 
			DecorSetInt(Config.Missions[input].Peds[i].id,"mrppedead",1) --is dead
			
		end				
		
		if Config.Missions[input].Peds[i].wander then
			TaskWanderStandard(Config.Missions[input].Peds[i].id,10.0, 10)
		elseif Config.Missions[input].Peds[i].wanderinarea then
			TaskWanderInArea(Config.Missions[input].Peds[i].id,Config.Missions[input].Peds[i].x,Config.Missions[input].Peds[i].y,Config.Missions[input].Peds[i].z,25.0,0.0,0.0) --wanderinarea within 25 meters 
		end		
		
      --  local ped = AddBlipForEntity(Config.Missions[input].Peds[i].id)
      --  local Size     = 0.9
      --  SetBlipScale  (ped, Size)
      --  SetBlipAsShortRange(ped, false)
		
		if Config.Missions[input].Peds[i].friendly then 
			TaskCower(Config.Missions[input].Peds[i].id,360000) -- 1hour
			--SetBlipColour(ped, 66)
			--SetBlipSprite(ped, 280)
		--	SetBlipColour(ped, 2)
			--BeginTextCommandSetBlipName("STRING")
			--AddTextComponentString("Friend ($-"..getHostageKillPenalty(input)..")")
			--EndTextCommandSetBlipName(ped)		
				--print("spawned hostage")
			DecorSetInt(Config.Missions[input].Peds[i].id,"mrppedfriend",i)
			if getMissionConfigProperty(input, "Type") == "HostageRescue"  and not Config.Missions[input].Peds[i].dead then
				isHostageRescueCount = isHostageRescueCount + 1
			end 				
			
		elseif Config.Missions[input].Peds[i].target then --if ped is a target in assassinate
			--SetBlipColour(ped, 66)
			--SetBlipSprite(ped, 433)
			--SetBlipColour(ped, 27)
			--BeginTextCommandSetBlipName("STRING")
			--AddTextComponentString("Target ($"..getTargetKillReward(input)..")")
			--EndTextCommandSetBlipName(ped)						
			DecorSetInt(Config.Missions[input].Peds[i].id,"mrppedtarget",i)
		else
		--	BeginTextCommandSetBlipName("STRING")
		--	AddTextComponentString("Enemy ($"..getKillReward(input)..")")
		--	EndTextCommandSetBlipName(ped)								
		end	
		
		
		local movespeed = 2.0 --How fast can peds move?
		if(Config.Missions[input].Peds[i]) then 
			if Config.Missions[input].Peds[i].movespeed ~= nil then
				movespeed = Config.Missions[input].Peds[i].movespeed
			end				
		end 
		--conqueror bee-lines to objective and is neutral, attacker will combat
		--everyone, friendlies as well move
		if Config.Missions[input].IsDefend  then 
			if Config.Missions[input].IsDefendTarget then 
				if TargetPed ==nil then
					print("NIL TargetPed for IsDefendTarget")
				end
				
				if(Config.Missions[input].IsDefendTargetChase) then
					ClearPedTasksImmediately(Config.Missions[input].Peds[i].id)
					--print('TASK MOVE TO ENTITY')
					--print('TASK MOVE TO entity movespeed:'..movespeed)
					local _, sequence = OpenSequenceTask(0)
					TaskGoToEntity(0, TargetPed, -1, 5.0, movespeed,1073741824, 0)
					
					--RegisterTarget(Config.Missions[input].Peds[i].id, TargetPed)
					
					TaskCombatPed(0, TargetPed, 0, 16)
					CloseSequenceTask(sequence)
					ClearPedTasks(Config.Missions[input].Peds[i].id)
					ClearPedTasksImmediately(Config.Missions[input].Peds[i].id)

					-- execute sequence on cop2
					TaskPerformSequence(Config.Missions[input].Peds[i].id, sequence)
					ClearSequenceTask(sequence)					
					--TaskCombatHatedTargetsAroundPed(Config.Missions[input].Peds[i].id,1000.0)					
					
					--TaskFollowToOffsetOfEntity(ped, entity, 0.0, 0.0, 0.0, 10.0, -1, 10.0, true)
					--SetPedKeepTask(Config.Missions[input].Peds[i].id,true) 
				end
				
				if (not Config.Missions[input].IsDefendTargetChase) and (Config.Missions[input].IsDefendTargetGotoBlip) then 
	
					ClearPedTasksImmediately(Config.Missions[input].Peds[i].id)
					TaskGoStraightToCoord(Config.Missions[input].Peds[i].id,Config.Missions[input].Blip.Position.x, Config.Missions[input].Blip.Position.y,Config.Missions[input].Blip.Position.z, movespeed, 100000, 0.0, 0.0) 
					SetPedKeepTask(Config.Missions[input].Peds[i].id,true) 					
				end
				
			else
				ClearPedTasksImmediately(Config.Missions[input].Peds[i].id)
				TaskGoStraightToCoord(Config.Missions[input].Peds[i].id,Config.Missions[input].Marker.Position.x, Config.Missions[input].Marker.Position.y,Config.Missions[input].Marker.Position.z, movespeed, 100000, 0.0, 0.0) 
				SetPedKeepTask(Config.Missions[input].Peds[i].id,true) 
			end
		
		end		

		--override everything with movetocoord
		if Config.Missions[input].Peds[i].movetocoord then 
			ClearPedTasksImmediately(Config.Missions[input].Peds[i].id)
			TaskGoStraightToCoord(Config.Missions[input].Peds[i].id,Config.Missions[input].Peds[i].movetocoord.x, Config.Missions[input].Peds[i].movetocoord.y,Config.Missions[input].Peds[i].movetocoord.y, movespeed, 100000, 0.0, 0.0) 
			SetPedKeepTask(Config.Missions[input].Vehicles[i].id2,true) 
		end			
		
		if Config.Missions[input].Peds[i].armor then --if ped has armor
			AddArmourToPed(Config.Missions[input].Peds[i].id, Config.Missions[input].Peds[i].armor)
			SetPedArmour(Config.Missions[input].Peds[i].id, Config.Missions[input].Peds[i].armor)
		end				
       -- blip = GetBlipFromEntity(ped)
		
        SetAiWeaponDamageModifier(1.0) -- 1.0 == Normal Damage. 
		
		--use 'notzed' attribute to remove extra zombietype characteristics for these models
		if (Config.Missions[input].Peds[i].modelHash == "u_m_y_zombie_01" or Config.Missions[input].Peds[i].modelHash == "s_m_m_movalien_01" or Config.Missions[input].Peds[i].modelHash == "ig_orleans") and not Config.Missions[input].Peds[i].notzed then --movie zed
			SetAiMeleeWeaponDamageModifier(50.0)
			SetPedSuffersCriticalHits(Config.Missions[input].Peds[i].id, 0) 
			SetPedDiesWhenInjured(Config.Missions[input].Peds[i].id, false) 
			SetPedCanRagdoll(Config.Missions[input].Peds[i].id, false) 					
			DecorSetInt(Config.Missions[input].Peds[i].id,"mrppedmonster",i)
			if (Config.Missions[input].Peds[i].modelHash == "s_m_m_movalien_01" or Config.Missions[input].Peds[i].modelHash == "ig_orleans") then
				--DOES NOT SEEM TO WORK FOR NPCS
				SetPedMaxHealth(Config.Missions[input].Peds[i].id, 1000)
				SetEntityHealth(Config.Missions[input].Peds[i].id, 1000)
				--SetPlayerMaxArmour(Config.Missions[input].Peds[i].id,100)
				AddArmourToPed(Config.Missions[input].Peds[i].id, 100)
				SetPedArmour(Config.Missions[input].Peds[i].id, 100)
			end		
		
		
		else 
			SetAiMeleeWeaponDamageModifier(1.0)
			-- ^ Sets Custom NPC Damage. ^
		end 
		
		--print("accuracy:"..GetPedAccuracy(Config.Missions[input].Peds[i].id))
    end
	--used to even out which players planes go to
	local lastrandomplayer=-1
    for i=1, #Config.Missions[input].Vehicles do
        veh         =  Config.Missions[input].Vehicles[i].Vehicle
        vehiclehash = GetHashKey(veh)
        RequestModel(vehiclehash)
        RequestModel(GetHashKey(Config.Missions[input].Vehicles[i].modelHash))
        while not HasModelLoaded(vehiclehash)  do
          Wait(1)
        end
 
        Config.Missions[input].Vehicles[i].id = CreateVehicle(vehiclehash, Config.Missions[input].Vehicles[i].x, Config.Missions[input].Vehicles[i].y, Config.Missions[input].Vehicles[i].z,  Config.Missions[input].Vehicles[i].heading, 1, 0)
		SetModelAsNoLongerNeeded(vehiclehash)
		SetEntityAsMissionEntity(Config.Missions[input].Vehicles[i].id,true,true)
		DecorSetInt(Config.Missions[input].Vehicles[i].id,"mrpvehdid",i)
		
		if Config.Missions[input].Vehicles[i].notvisible then 
			--print("heh made it")
			SetEntityVisible(Config.Missions[input].Vehicles[i].id,false,0)
			SetEntityCollision(Config.Missions[input].Vehicles[i].id,false,true)
		end
		
		--Stop AI from blowing themselves up!
		--SetEntityCanBeDamagedByRelationshipGroup(Config.Missions[input].Vehicles[i].id, false, GetHashKey("HATES_PLAYER"))
		--SetEntityCanBeDamagedByRelationshipGroup(Config.Missions[input].Vehicles[i].id, false, GetHashKey("TRUENEUTRAL"))		
		if not getMissionConfigProperty(input,"IsDefendTarget") or (getMissionConfigProperty(input,"IsDefendTarget") and getMissionConfigProperty(input,"IsDefendTargetOnlyPlayersDamagePeds") ) then			
			SetEntityOnlyDamagedByPlayer(Config.Missions[input].Vehicles[i].id, true)
		end

		if getMissionConfigProperty(input,"MissionDoBackup") then
			SetEntityOnlyDamagedByPlayer(Config.Missions[input].Vehicles[i].id, false)
			SetEntityCanBeDamagedByRelationshipGroup(Config.Missions[input].Vehicles[i].id,false,"HATES_PLAYER")
			SetEntityCanBeDamagedByRelationshipGroup(Config.Missions[input].Vehicles[i].id,true,"PLAYER")
			SetEntityCanBeDamagedByRelationshipGroup(Config.Missions[input].Vehicles[i].id,true,"ISDEFENDTARGET")
		end		
		
		local firingpatterns = {driverfiringpattern = false,turretfiringpattern = false}
		if(not Config.Missions[input].Vehicles[i].nomods) then 
			firingpatterns = doVehicleMods(veh,Config.Missions[input].Vehicles[i].id,input) 
		end
		--allow firing pattern override per vehicle
		if(Config.Missions[input].Vehicles[i].driverfiringpattern) then
			firingpatterns.driverfiringpattern = Config.Missions[input].Vehicles[i].driverfiringpattern
		end
		if(Config.Missions[input].Vehicles[i].turretfiringpattern) then
			firingpatterns.turretfiringpattern = Config.Missions[input].Vehicles[i].turretfiringpattern
		end		
				
		
		if Config.Missions[input].Vehicles[i].id2 ~=nil then 
			while not HasModelLoaded(GetHashKey(Config.Missions[input].Vehicles[i].modelHash))  do
				Wait(1)
			end
			--Config.Missions[input].Vehicles[i].id2 = CreatePed(2, Config.Missions[input].Vehicles[i].modelHash, Config.Missions[input].Vehicles[i].x, Config.Missions[input].Vehicles[i].y, Config.Missions[input].Vehicles[i].z, Config.Missions[input].Vehicles[i].heading, true, true)
			
			Config.Missions[input].Vehicles[i].id2 = CreatePedInsideVehicle(Config.Missions[input].Vehicles[i].id,2, Config.Missions[input].Vehicles[i].modelHash,-1, true, true)			
			
			SetModelAsNoLongerNeeded(Config.Missions[input].Vehicles[i].modelHash)
			SetEntityAsMissionEntity(Config.Missions[input].Vehicles[i].id2,true,true)
			
			--Stop AI from blowing themselves up!
			--SetEntityCanBeDamagedByRelationshipGroup(Config.Missions[input].Vehicles[i].id2, false, GetHashKey("HATES_PLAYER"))
			--SetEntityCanBeDamagedByRelationshipGroup(Config.Missions[input].Vehicles[i].id2, false, GetHashKey("TRUENEUTRAL"))		
			if not getMissionConfigProperty(input,"IsDefendTarget") or (getMissionConfigProperty(input,"IsDefendTarget") and getMissionConfigProperty(input,"IsDefendTargetOnlyPlayersDamagePeds") ) then				
				SetEntityOnlyDamagedByPlayer(Config.Missions[input].Vehicles[i].id2, true)
			end	
			
			if getMissionConfigProperty(input,"MissionDoBackup") then
				SetEntityOnlyDamagedByPlayer(Config.Missions[input].Vehicles[i].id2, false)
				SetEntityCanBeDamagedByRelationshipGroup(Config.Missions[input].Vehicles[i].id2,false,"HATES_PLAYER")
				SetEntityCanBeDamagedByRelationshipGroup(Config.Missions[input].Vehicles[i].id2,true,"PLAYER")
				SetEntityCanBeDamagedByRelationshipGroup(Config.Missions[input].Vehicles[i].id2,true,"ISDEFENDTARGET")
			end			
			
			
			SetPedAccuracy(Config.Missions[input].Vehicles[i].id2,math.random(getMissionConfigProperty(input, "SetPedMinAccuracy"),getMissionConfigProperty(input, "SetPedMaxAccuracy")))
			
			if(Config.Missions[input].Vehicles[i].modelHash == "s_m_m_movalien_01") then
				SetPedDefaultComponentVariation(Config.Missions[input].Vehicles[i].id2) --GHK for s_m_m_movalien_01
			end
			
			DecorSetInt(Config.Missions[input].Vehicles[i].id2,"mrpvpedid",i)
			DecorSetInt(Config.Missions[input].Vehicles[i].id2,"mrpvpeddriverid",i)
			
			
			if Config.Missions[input].Vehicles[i].SetBlockingOfNonTemporaryEvents then 
			
				SetBlockingOfNonTemporaryEvents(Config.Missions[input].Vehicles[i].id2,true)
			end
			
			
			--for IsDefend, they beeline to the objective
			--except aircraft peds which require 
			if (not Config.Missions[input].Vehicles[i].conqueror) or Config.Missions[input].Vehicles[i].isAircraft then 
				if not Config.Missions[input].Vehicles[i].friendly then
					--if not Config.Missions[input].Vehicles[i].pilot then 
						SetPedRelationshipGroupHash(Config.Missions[input].Vehicles[i].id2, GetHashKey("HATES_PLAYER"))
						SetRelationshipBetweenGroups(5, GetHashKey("HATES_PLAYER"), GetHashKey("PLAYER"))
						SetRelationshipBetweenGroups(0, GetHashKey("HATES_PLAYER"), GetHashKey("HATES_PLAYER"))
						SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("HATES_PLAYER"))
						SetRelationshipBetweenGroups(5, GetHashKey("TRUENEUTRAL"), GetHashKey("ISDEFENDTARGET"))
						SetRelationshipBetweenGroups(0, GetHashKey("HATES_PLAYER"), GetHashKey("TRUENEUTRAL"))						
					
					--end
					if not Config.Missions[input].Vehicles[i].flee then --and not Config.Missions[input].Vehicles[i].pilot then 
						--print('MADE IT TO FLEE VEHPED')
						SetPedFleeAttributes(Config.Missions[input].Vehicles[i].id2, 0, 0)
						SetPedCombatAttributes(Config.Missions[input].Vehicles[i].id2, 3, false)
						SetPedCombatAttributes(Config.Missions[input].Vehicles[i].id2, 16, true)
						SetPedCombatAttributes(Config.Missions[input].Vehicles[i].id2, 46, true)
						SetPedCombatAttributes(Config.Missions[input].Vehicles[i].id2, 26, true)
						SetPedCombatAttributes(Config.Missions[input].Vehicles[i].id2, 1, true) --can use vehicles
						SetPedCombatAttributes(Config.Missions[input].Vehicles[i].id2, 2, true) --can do drivebys						
					end 
				else 
					SetPedRelationshipGroupHash(Config.Missions[input].Vehicles[i].id2, GetHashKey("HOSTAGES"))
					SetRelationshipBetweenGroups(1, GetHashKey("HOSTAGES"), GetHashKey("HATES_PLAYER"))
					SetRelationshipBetweenGroups(1, GetHashKey("HOSTAGES"), GetHashKey("PLAYER"))	
					SetRelationshipBetweenGroups(5, GetHashKey("HATES_PLAYER"), GetHashKey("ISDEFENDTARGET"))	


					if getMissionConfigProperty(input, "DelicateHostages") then 
						SetEntityOnlyDamagedByPlayer(Config.Missions[input].Vehicles[i].id2, false)

					else			
						SetEntityOnlyDamagedByPlayer(Config.Missions[input].Vehicles[i].id2, true)							
					
					end	
					
					--SetPedRelationshipGroupHash(Config.Missions[input].Vehicles[i].id2, GetHashKey("NO_RELATIONSHIP"))
				end	
				SetPedCombatAttributes(Config.Missions[input].Vehicles[i].id2, 2, true)
				SetPedCombatAttributes(Config.Missions[input].Vehicles[i].id2, 3, false)	
				
				
				
				SetPedSeeingRange(Config.Missions[input].Vehicles[i].id2, 10000.0)
				SetPedHearingRange(Config.Missions[input].Vehicles[i].id2, 10000.0)	
			else 
			-- is there a better way to make an NPC true neutral?
			--does not handle custom groups from other resources
			SetPedFleeAttributes(Config.Missions[input].Vehicles[i].id2, 0, 0)
			SetPedCombatAttributes(Config.Missions[input].Vehicles[i].id2, 3, false)
			
			--SetPedCombatAttributes(Config.Missions[input].Vehicles[i].id2, 1, true) --can use vehicles
			--SetPedCombatAttributes(Config.Missions[input].Vehicles[i].id2, 2, true) --can do drivebys
			
			SetPedRelationshipGroupHash(Config.Missions[input].Vehicles[i].id2, GetHashKey("TRUENEUTRAL"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("PLAYER"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("HATES_PLAYER"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("HOSTAGES"))
			SetRelationshipBetweenGroups(0, GetHashKey("HATES_PLAYER"), GetHashKey("TRUENEUTRAL"))
			
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("CIVMALE"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("CIVFEMALE"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("COP"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("SECURITY_GUARD"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("PRIVATE_SECURITY"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("FIREMAN"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("GANG_1"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("GANG_2"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("GANG_9"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("GANG_10"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_LOST"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_MEXICAN"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_FAMILY"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_BALLAS"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_MARABUNTE"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_CULT"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_SALVA"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_WEICHENG"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_HILLBILLY"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("DEALER"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("WILD_ANIMAL"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("SHARK"))
			--SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("HATES_PLAYER"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("COUGAR"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("NO_RELATIONSHIP"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("SPECIAL"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION2"))		
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("NO_RELATIONSHIP"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("SPECIAL"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION2"))			
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION3"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION4"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION5"))			
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION6"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION7"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION8"))			
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("ARMY"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("GUARD_DOG"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AGGRESSIVE_INVESTIGATE"))						
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MEDIC"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("PRISONER"))	
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("DOMESTIC_ANIMAL"))			
			SetRelationshipBetweenGroups(5, GetHashKey("TRUENEUTRAL"), GetHashKey("ISDEFENDTARGET"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("TRUENEUTRAL"))			
			--print('VEH PED IS CONQUEROR')
		
		end
			
			
			--SetPedFiringPattern(Config.Missions[input].Vehicles[i].id2, 0x914E786F) --FIRING_PATTERN_BURST_FIRE_HELI
			SetPedDropsWeaponsWhenDead(Config.Missions[input].Vehicles[i].id2, getMissionConfigProperty(input, "SetPedDropsWeaponsWhenDead"))
			SetPedDiesWhenInjured(Config.Missions[input].Vehicles[i].id2, true)
			if not Config.Missions[input].Vehicles[i].friendly then
				if Config.Missions[input].Vehicles[i].isBoss then 
					DecorSetInt(Config.Missions[input].Vehicles[i].id2,"mrppedboss",1)
					doBossBuff(Config.Missions[input].Vehicles[i].id2,Config.Missions[input].Vehicles[i].modelHash,input,Config.Missions[input].Vehicles[i].Weapon)					
				else 
					GiveWeaponToPed(Config.Missions[input].Vehicles[i].id2, Config.Missions[input].Vehicles[i].Weapon, 2800, false, true)	
					SetPedInfiniteAmmo(Config.Missions[input].Vehicles[i].id2, true, Config.Missions[input].Vehicles[i].Weapon)
				
				end				
				
			end
			SetPedAlertness(Config.Missions[input].Vehicles[i].id2,3)	
			ResetAiWeaponDamageModifier()
			--SetPedIntoVehicle(Config.Missions[input].Vehicles[i].id2, Config.Missions[input].Vehicles[i].id, -1)
			
			if Config.Missions[input].Vehicles[i].invincible then
				SetEntityInvincible(Config.Missions[input].Vehicles[i].id2, true)
			end
			
			if Config.Missions[input].Vehicles[i].dead then
				--ApplyDamageToPed(Config.Missions[input].Peds[i].id,90,true)
				SetEntityHealth(Config.Missions[input].Vehicles[i].id2, 0.0)
				DecorSetInt(Config.Missions[input].Vehicles[i].id2,"mrppedfriend",0) --make them not friendly so the player is not penalized!
				DecorSetInt(Config.Missions[input].Vehicles[i].id2,"mrpvpedid",0) --remove all decor 
				DecorSetInt(Config.Missions[input].Vehicles[i].id2,"mrppedid",0) --remove all decor 
				DecorSetInt(Config.Missions[input].Vehicles[i].id2,"mrppedtarget",0) --remove all decor 
				DecorSetInt(Config.Missions[input].Vehicles[i].id2,"mrpvpeddriverid",0)
				DecorSetInt(Config.Missions[input].Vehicles[i].id2,"mrppedead",1)
				
			end	
			
			if firingpatterns.driverfiringpattern then
				SetPedFiringPattern(Config.Missions[input].Vehicles[i].id2, firingpatterns.driverfiringpattern) 
			end		
			
			local vehicleModel = GetEntityModel(Config.Missions[input].Vehicles[i].id)	
			--if rhino or khanjali, nerf them to be slower fire rate?
			--[[
			local vehicleModel = GetEntityModel(Config.Missions[input].Vehicles[i].id)	
			if not getMissionConfigProperty(input, "NerfDriverTurrets") then 
				SetPedFiringPattern(Config.Missions[input].Vehicles[i].id2, 0x914E786F) --FIRING_PATTERN_BURST_FIRE_HELI
			end 								
			
			
			if tostring(vehicleModel) == "782665360" or tostring(vehicleModel) == "-1435527158" then 
						--nerf tank cannon?
				if getMissionConfigProperty(input, "NerfTankCannon") then 
					SetPedFiringPattern(Config.Missions[input].Vehicles[i].id2,  0xE2CA3A71) --FIRING_PATTERN_SLOW_FIRE_TANK
				end 
			end			
			]]--
			--ExtraPeds
			if Config.Missions[input].Vehicles[i].ExtraPeds then
		
				for j, v in pairs(Config.Missions[input].Vehicles[i].ExtraPeds) do
		
					SetPedIntoVehicle(Config.Missions[input].Peds[v.id].id, Config.Missions[input].Vehicles[i].id, v.seatid)
					
					if firingpatterns.turretfiringpattern then
						SetPedFiringPattern(Config.Missions[input].Peds[v.id].id, firingpatterns.turretfiringpattern)
					end				
					
					local vehicleModel = GetEntityModel(Config.Missions[input].Vehicles[i].id)
					if tostring(vehicleModel) =="-1600252419" and v.seatid == 0 then 
						--nerf valkyrie cannon?
						if getMissionConfigProperty(input, "NerfValkyrieHelicopterCannon") then 
							SetPedFiringPattern(Config.Missions[input].Peds[v.id].id,  0xE2CA3A71) --FIRING_PATTERN_SLOW_FIRE_TANK
						end
					end
					--[[
					elseif tostring(vehicleModel) =="562680400" and v == 0 then 	
						--leave apc cannon as is?
						if getMissionConfigProperty(input, "NerfAPCCannon") then 
							SetPedFiringPattern(Config.Missions[input].Peds[v.id].id,  0xE2CA3A71) --FIRING_PATTERN_SLOW_FIRE_TANK
						end 
					else
						if not getMissionConfigProperty(input, "NerfTurrets") then 
							SetPedFiringPattern(Config.Missions[input].Peds[v.id].id, 0x914E786F) --FIRING_PATTERN_BURST_FIRE_HELI
						end 
					end 					
					]]--
				end
			
			end
			
			
			local pmodel = vehicleModel
			if(IsThisModelAPlane(pmodel) or IsThisModelAHeli(pmodel)) then 
			
	
				if getMissionConfigProperty(input, "SafeHousePlaneAttack") and getMissionConfigProperty(input, "UseSafeHouse") and getMissionConfigProperty(input, "TeleportToSafeHouseOnMissionStart") and Config.Missions[input].MarkerS then 
					
					local origx =  Config.Missions[input].MarkerS.Position.x
					local origy =  Config.Missions[input].MarkerS.Position.y
					local p1 = GetEntityCoords(Config.Missions[input].Vehicles[i].id, true)
					
					local dx = origx - p1.x
					local dy = origy - p1.y
						
					local heading = GetHeadingFromVector_2d(dx, dy)				 
					SetEntityHeading(Config.Missions[input].Vehicles[i].id,heading) 
				else 
					--lets select random players to head towards so planes dont just head out to sea. TaskPlaneMission/TaskHeliMission does not seem to work for me to make them circle/guard mission Blip (at least from long distance)

					local cnt = 0
					local tries = 0
					local foundplayer=false
					math.randomseed(GetGameTimer())
					ptable = GetPlayers()
					for _, k in ipairs(ptable) do
						cnt = cnt + 1 
						--print('player num:'..k)
					end
					--print('player count'..cnt)
					-- i.e. 8 players, then 1 in 8 chance per player
					
					if(cnt > 1) then
						local chance = cnt - 1
						repeat 
							
							for _, k in ipairs(ptable) do
								Wait(1)
								math.randomseed(GetGameTimer())
								if(math.random(1,cnt) > chance and k ~=lastrandomplayer) then
									makeEntityFaceEntity(Config.Missions[input].Vehicles[i].id,GetPlayerPed(k))
									foundplayer = true
									lastrandomplayer = k
									break
								end						
								tries = tries + 1
							end	
						until (foundplayer or tries > 25)
					else 
						makeEntityFaceEntity(Config.Missions[input].Vehicles[i].id,GetPlayerPed(-1))
					end
					
				end							
				--make sure landing gear is retracted, since all planes should be spawned in the air with an NPC
				SetVehicleLandingGear(Config.Missions[input].Vehicles[i].id, 3) 
				
			end	

			local aircraft = false
			
			if (IsThisModelAPlane(pmodel) or IsThisModelAHeli(pmodel)) and Config.Missions[input].Vehicles[i].driving then 
				aircraft = true
				if IsThisModelAPlane(pmodel) and tostring(pmodel) ~= '970385471' then --treat hydra like heli
					SetVehicleForwardSpeed(Config.Missions[input].Vehicles[i].id, 60.0)
				end 
				SetHeliBladesFullSpeed(Config.Missions[input].Vehicles[i].id) -- works for planes I guess
				SetVehicleEngineOn(Config.Missions[input].Vehicles[i].id, true, true, false)			
			end
			
			if (Config.Missions[input].Vehicles[i].Freeze) then 
				
				FreezeEntityPosition(Config.Missions[input].Vehicles[i].id,true)
			end
			if Config.Missions[input].Vehicles[i].id2 then
				local movespeed = GetVehicleMaxSpeed(pmodel)  --1200.0 --default is fast
				--if Config.Missions[input].Vehicles[i] then
					if Config.Missions[input].Vehicles[i].movespeed ~= nil then
					 movespeed = Config.Missions[input].Vehicles[i].movespeed
					end		
				--end
				
				--print("hey2")

				if (Config.Missions[input].VehicleGotoMissionTarget or  
				Config.Missions[input].VehicleGotoMissionTargetPed or
				Config.Missions[input].VehicleGotoMissionTargetVehicle
				) and Config.Missions[input].Vehicles[i].VehicleGotoMissionTarget then 
							local TargetMissionVehicle 
							--print("made it")
							TargetMissionVehicle = Config.Missions[input].VehicleGotoMissionTarget
							--VehicleGotoMissionTargetPed or VehicleGotoMissionTargetVehicle
							--are the ids of the Ped of vehicle that needs to be targetted. 
							--So the vehicle doing the targetting should be a larger "i" 
							--than the vehicle being targetted.
							
							local dotargetped
							if Config.Missions[input].VehicleGotoMissionTargetPed then 
								local j = Config.Missions[input].VehicleGotoMissionTargetPed
								TargetMissionVehicle = Config.Missions[input].Peds[j].id
							--print("made it2")
								dotargetped = true
							elseif Config.Missions[input].VehicleGotoMissionTargetVehicle then 
								local j = Config.Missions[input].VehicleGotoMissionTargetVehicle
								TargetMissionVehicle = Config.Missions[input].Vehicles[j].id
								--print("made it3")
								dotargetped = false
							end
							--also allow individual targets per vehicle:
							if Config.Missions[input].Vehicles[i].VehicleGotoMissionTargetPed then 
								local j = Config.Missions[input].Vehicles[i].VehicleGotoMissionTargetPed
								TargetMissionVehicle = Config.Missions[input].Peds[j].id
								dotargetped = true
							--print("made it2")
							elseif Config.Missions[input].Vehicles[i].VehicleGotoMissionTargetVehicle then 
								local j = Config.Missions[input].Vehicles[i].VehicleGotoMissionTargetVehicle
								TargetMissionVehicle = Config.Missions[input].Vehicles[j].id
								--print("made it3")
								dotargetped = false
							end							
							
							--print("hey")
							if IsThisModelAPlane(pmodel) then 
								--print("hey")
								
								SetVehicleForwardSpeed(Config.Missions[input].Vehicles[i].id,movespeed)
								SetHeliBladesFullSpeed(Config.Missions[input].Vehicles[i].id) -- works for planes I guess
								SetVehicleEngineOn(Config.Missions[input].Vehicles[i].id, true, true, false)			
								TaskPlaneChase(Config.Missions[input].Vehicles[i].id2,TargetMissionVehicle,0.0, 0.0, 5.0)
								--TaskCombatPed(Config.Missions[input].Vehicles[i].id2,TargetPed,0, 16)
							elseif IsThisModelABoat(pmodel) then
								
								TaskBoatMission(Config.Missions[input].Vehicles[i].id2,Config.Missions[input].Vehicles[i].id, 0, 0, 
										Config.Missions[input].VehicleGotoMissionTargetCoords.x, 
										Config.Missions[input].VehicleGotoMissionTargetCoords.y, 
										Config.Missions[input].VehicleGotoMissionTargetCoords.z,
										4, movespeed, 0, -1.0, 7)
										--> needed -->:
								--SetBlockingOfNonTemporaryEvents(TargetPed,true)
								
								
							elseif IsThisModelAHeli(pmodel) then
								--print("made ith")
								--ClearPedTasks(Config.Missions[input].Vehicles[i].id2)
								SetVehicleForwardSpeed(Config.Missions[input].Vehicles[i].id,60.0)
								SetHeliBladesFullSpeed(Config.Missions[input].Vehicles[i].id) -- works for planes I guess
								SetVehicleEngineOn(Config.Missions[input].Vehicles[i].id, true, true, false)										
								
								if not dotargetped then 
									
									TaskHeliMission(Config.Missions[input].Vehicles[i].id2,Config.Missions[input].Vehicles[i].id,TargetMissionVehicle,0,0.0,0.0,0.0,9,movespeed,0.0,1.0, -1, -1, -1, 0)
								
								else 
									TaskHeliChase(Config.Missions[input].Vehicles[i].id2,TargetMissionVehicle,0.0, 0.0, 5.0)
								end
								--TaskHeliChase(Config.Missions[input].Vehicles[i].id2,TargetMissionVehicle,0.0, 0.0, 5.0)
								
									
								
								--SetPedKeepTask(Config.Missions[input].Vehicles[i].id2,true)
								--TaskCombatPed(Config.Missions[input].Vehicles[i].id2,TargetPed,0, 16)
								--print(GetIsTaskActive(Config.Missions[MissionName].Vehicles[i].id2,373))
							else
							--**MISSION TARGET FOR VEHICLE SHOULD HAVE A PED AS TARGET**
							
								--local _, sequence = OpenSequenceTask(0)
								
								--TaskEnterVehicle( 0,  Config.Missions[input].Vehicles[i].id, 20000,-1, 1.5, 1, 0)
								
								--TaskVehicleChase(0, TargetPed)
								
								--if IsThisModelAHeli(pmodel) then 
									--TaskHeliChase(0,TargetPedVehicle,0.0, 0.0, 5.0)
								--else 
								--TaskVehicleEscort(0, Config.Missions[input].Vehicles[i].id, TargetMissionVehicle, 0, movespeed, 0, 5.0, -1, 2000)
								
								--TaskVehicleEscort(Config.Missions[input].Vehicles[i].id2, Config.Missions[input].Vehicles[i].id, TargetMissionVehicle, 0, movespeed, 0, 5.0, -1, 2000)		
								
								--end

								--TaskCombatPed(0,TargetPed,0, 16)
							
								--TaskVehicleShootAtPed(0,TargetPed,100.0)							
								
								--RegisterTarget(Config.Missions[input].Peds[i].id, TargetPed)
								
								--TaskCombatPed(0, TargetPed, 0, 16)
								--next line was needed in this case:
								
								--SetSequenceToRepeat(sequence, 1)
								--CloseSequenceTask(sequence)
								--ClearPedTasks(Config.Missions[input].Vehicles[i].id2)
								--ClearPedTasksImmediately(Config.Missions[input].Vehicles[i].id2)

										
								--TaskPerformSequence(Config.Missions[input].Vehicles[i].id2, sequence)
								--ClearSequenceTask(sequence)
								--print("1")
								if TargetMissionVehicle then 
								--print("2")
									if not dotargetped then
										--print("3")
										TargetMissionVehicle = GetPedInVehicleSeat(TargetMissionVehicle,-1)
									end

									if TargetMissionVehicle and not dotargetped then 
										TaskVehicleMissionPedTarget(Config.Missions[input].Vehicles[i].id2,Config.Missions[input].Vehicles[i].id,TargetMissionVehicle,7, movespeed, 0, 300.0, 15.0, 1)
									else 
										--TaskVehicleMissionCoorsTarget()
										local _, sequence = OpenSequenceTask(0)
										
										TaskEnterVehicle( 0,  Config.Missions[input].Vehicles[i].id, 20000,-1, 1.5, 1, 0)
										--TaskVehicleChase(0, TargetPed)
										
										--if IsThisModelAHeli(pmodel) then 
											--TaskHeliChase(0,TargetPedVehicle,0.0, 0.0, 5.0)
										--else 
										TaskVehicleEscort(0, Config.Missions[input].Vehicles[i].id, TargetMissionVehiclee, 0, movespeed, 0, 5.0, -1, 2000)						
										--end

										--TaskCombatPed(0,TargetPed,0, 16)
									
										--TaskVehicleShootAtPed(0,TargetPed,100.0)							
										
										--RegisterTarget(Config.Missions[input].Peds[i].id, TargetPed)
										
										--TaskCombatPed(0, TargetPed, 0, 16)
										--next line was needed in this case:
										SetSequenceToRepeat(sequence, 1)
										CloseSequenceTask(sequence)
										ClearPedTasks(Config.Missions[input].Vehicles[i].id2)
										ClearPedTasksImmediately(Config.Missions[input].Vehicles[i].id2)

												
										TaskPerformSequence(Config.Missions[input].Vehicles[i].id2, sequence)
										ClearSequenceTask(sequence)													
									
									
									end 
								end
									
							
							end 				
				
				
				
				elseif Config.Missions[input].Vehicles[i].driving then
					--print("TASK DRIVE WANDER:"..movespeed)
					if (aircraft and not (Config.Missions[input].Vehicles[i].conqueror or Config.Missions[input].Vehicles[i].SetBlockingOfNonTemporaryEvents)) then 
						TaskCombatHatedTargetsAroundPed(Config.Missions[input].Vehicles[i].id2,12000.0)
					else 
						TaskVehicleDriveWander(Config.Missions[input].Vehicles[i].id2, GetVehiclePedIsIn(Config.Missions[input].Vehicles[i].id2, false), movespeed, 0)
					end
				elseif Config.Missions[input].Vehicles[i].movetocoord then 
					TaskVehicleDriveToCoordLongrange(Config.Missions[input].Vehicles[i].id2, Config.Missions[input].Vehicles[i].id, Config.Missions[input].Vehicles[i].movetocoord.x, Config.Missions[input].Vehicles[i].movetocoord.y,  Config.Missions[input].Vehicles[i].movetocoord.z, movespeed, 0, 5.0) --drive mode is zero
					SetPedKeepTask(Config.Missions[input].Vehicles[i].id2,true) 
				elseif Config.Missions[input].IsDefend --and not Config.Missions[input].Vehicles[i].isAircraft
				then 
					--print("MADE IT")
					if Config.Missions[input].IsDefendTarget then 
						if TargetPed ==nil then
							print("NIL TargetPed for IsDefendTarget")
						end
						
						if(Config.Missions[input].IsVehicleDefendTargetChase) then
							
			
							
							if IsThisModelAPlane(pmodel) then 
							--print("hey")
								
								SetVehicleForwardSpeed(Config.Missions[input].Vehicles[i].id,movespeed)
								SetHeliBladesFullSpeed(Config.Missions[input].Vehicles[i].id) -- works for planes I guess
								SetVehicleEngineOn(Config.Missions[input].Vehicles[i].id, true, true, false)			
								if not Config.Missions[input].IsDefendTargetDoPlaneMission then 
									--print("hey1")
									TaskPlaneChase(Config.Missions[input].Vehicles[i].id2,TargetPedVehicle,0.0, 0.0, 5.0)
									
								else 
								--print("hey2")
									TaskPlaneMission(Config.Missions[input].Vehicles[i].id2,Config.Missions[input].Vehicles[i].id,TargetPedVehicle,0,0,0,0,6,
								0.0,0.0,0.0,2500.0, -1500.0)
								
								end
								--TaskCombatPed(Config.Missions[input].Vehicles[i].id2,TargetPed,0, 16)
								
								--use vehicle to target:
								--TaskPlaneMission(Config.Missions[input].Vehicles[i].id2,		Config.Missions[input].Vehicles[i].id,TargetPedVehicle,0,0,0,0,6,
								--0.0,0.0,0.0,2500.0, -1500.0)
								
								--TaskCombatPed(Config.Missions[input].Vehicles[i].id2,TargetPed,0, 16)
								
								
								
							elseif IsThisModelABoat(pmodel) then									
								--TaskCombatPed(Config.Missions[input].Vehicles[i].id2,TargetPed,0, 16)
								
								--SetBlockingOfNonTemporaryEvents(Ped,true)
								--TaskCombatPed(Ped,TargetPed,0, 16)

								TaskVehicleMissionPedTarget(Config.Missions[input].Vehicles[i].id2,PedVehicle,TargetPed,7, movespeed, 0, 300.0, 15.0, 1)								
								
							elseif IsThisModelAHeli(pmodel) then
								--print("made it")
								--ClearPedTasks(Config.Missions[input].Vehicles[i].id2)
								SetVehicleForwardSpeed(Config.Missions[input].Vehicles[i].id,60.0)
								SetHeliBladesFullSpeed(Config.Missions[input].Vehicles[i].id) -- works for planes I guess
								SetVehicleEngineOn(Config.Missions[input].Vehicles[i].id, true, true, false)										
								--TaskHeliChase(Config.Missions[input].Vehicles[i].id2,TargetPedVehicle,0.0, 0.0, 5.0)
								--TaskCombatPed(Config.Missions[input].Vehicles[i].id2,TargetPed,0, 16)
							
								TaskHeliMission(Config.Missions[input].Vehicles[i].id2,Config.Missions[input].Vehicles[i].id,TargetPedVehicle,0,0.0,0.0,0.0,9,movespeed,0.0,1.0, -1, -1, -1, 0)								
							else
								--print("made it")
								local _, sequence = OpenSequenceTask(0)
								
								TaskEnterVehicle( 0,  Config.Missions[input].Vehicles[i].id, 20000,-1, 1.5, 1, 0)
								
								TaskVehicleEscort(0, Config.Missions[input].Vehicles[i].id, TargetPedVehicle, 0, movespeed, 0, 5.0, -1, 2000)						
								--end

								TaskCombatPed(0,TargetPed,0, 16)
							
								
								--next line was needed in this case:
								SetSequenceToRepeat(sequence, 1)
								CloseSequenceTask(sequence)
								ClearPedTasks(Config.Missions[input].Vehicles[i].id2)
								ClearPedTasksImmediately(Config.Missions[input].Vehicles[i].id2)

										
								TaskPerformSequence(Config.Missions[input].Vehicles[i].id2, sequence)
								ClearSequenceTask(sequence)	
										
								--TaskVehicleMissionPedTarget(Config.Missions[input].Vehicles[i].id2,Config.Missions[input].Vehicles[i].id2,TargetPed,7, movespeed, 0, 300.0, 15.0, 1)								
							
							end 
							
						end
						
						if (not Config.Missions[input].IsVehicleDefendTargetChase) and (Config.Missions[input].IsVehicleDefendTargetGotoBlip) then
							TaskVehicleDriveToCoordLongrange(Config.Missions[input].Vehicles[i].id2, Config.Missions[input].Vehicles[i].id, Config.Missions[input].Blip.Position.x, Config.Missions[input].Blip.Position.y,Config.Missions[input].Blip.Position.z, movespeed, 0, 0.0) --drive mode is zero
							SetPedKeepTask(Config.Missions[input].Vehicles[i].id2,true) 		
						
						end						
						
					else
						--[[ TEST CODE
						local bRoutes = {
						{ ["x"] = 1185.18, ["y"] = -310.64, ["z"] = 69.19}, -- market place
						{ ["x"] = 375.62, ["y"] = 316.74, ["z"] = 103.27}, --clintin ave/liqor store
						{ ["x"] = 220.79, ["y"] = 216.19, ["z"] = 105.4}, -- Pacific Standard Bank
						{ ["x"] = -559.21, ["y"] = 208.14, ["z"] = 158.97}, -- Tequila-la
						{ ["x"] = -1498.9, ["y"] = -392.95, ["z"] = 39.55}, -- Prosperity Street/liqor
						{ ["x"] = -1392.79, ["y"] = -582.16, ["z"] = 30.11}, -- bahama mamas
						}
					for i=1, #bRoutes, 1 do
					Citizen.Wait(5)
					TaskVehicleDriveToCoordLongrange(Config.Missions[input].Vehicles[i].id2, Config.Missions[input].Vehicles[i].id, bRoutes[i].x, bRoutes[i].y, bRoutes[i].z, movespeed, 0, 0.0)
					end
					]]--
					
						TaskVehicleDriveToCoordLongrange(Config.Missions[input].Vehicles[i].id2, Config.Missions[input].Vehicles[i].id, Config.Missions[input].Marker.Position.x, Config.Missions[input].Marker.Position.y,Config.Missions[input].Marker.Position.z, movespeed, 0, 0.0) --drive mode is zero
						SetPedKeepTask(Config.Missions[input].Vehicles[i].id2,true) 		
					end
					--TaskVehicleFollow(Config.Missions[input].Vehicles[i].id2, GetVehiclePedIsIn(Config.Missions[input].Vehicles[i].id2, false), GetPlayerPed(-1), 0, 20.0, 5)
				elseif Config.Missions[input].Vehicles[i].isAircraft then 
					
					--if IsThisModelAHeli(pmodel) then 
						--print("made it")
						--SetPedFiringPattern(Config.Missions[input].Vehicles[i].id2, 0x914E786F) 
						--SetVehicleForwardSpeed(Config.Missions[input].Vehicles[i].id,50.0)
						--TaskCombatPed(Config.Missions[input].Vehicles[i].id2,GetPlayerPed(-1),0, 16)
						--TaskHeliChase(Config.Missions[input].Vehicles[i].id2,GetPlayerPed(-1),0.0, 0.0, 5.0)
						--print("made it")
					--end
				
				end
			else 
				--no NPC in it, a Player vehicle, so if isboat=true, then anchor it
				if Config.Missions[input].Vehicles[i] and Config.Missions[input].Vehicles[i].isboat then
					SetBoatAnchor(Config.Missions[input].Vehicles[i],true)
				end
	
			end
			
			
			--SetPedIntoVehicle(Config.Missions[input].Peds[1].id, Config.Missions[input].Vehicles[i].id, -2)
			--ped = AddBlipForEntity(Config.Missions[input].Vehicles[i].id)
			--Add blip to actual ped, not vehicles
			--local ped = AddBlipForEntity(Config.Missions[input].Vehicles[i].id2)
			--target=true --<----??????
			--local Size     = 0.9
			--SetBlipScale(ped, Size)
			--SetBlipAsShortRange(ped, false)
			--blip = GetBlipFromEntity(ped)
			--SetBlipSprite(blip, 58)
			if Config.Missions[input].Vehicles[i].friendly then
				--SetBlipSprite(ped, 280)
			--	SetBlipColour(ped, 2)
				DecorSetInt(Config.Missions[input].Vehicles[i].id2,"mrppedfriend",i)
				if getMissionConfigProperty(input, "Type") == "HostageRescue"  and not Config.Missions[input].Vehicles[i].dead then
					isHostageRescueCount = isHostageRescueCount + 1
				end 				
			--	BeginTextCommandSetBlipName("STRING")
			--	AddTextComponentString("Friend ($-"..getHostageKillPenalty(input)..")")
			--	EndTextCommandSetBlipName(ped)	
			
			elseif Config.Missions[input].Vehicles[i].target then --if ped is a target in assassinate
				--SetBlipColour(ped, 66)
				--SetBlipSprite(ped, 433)
			--	SetBlipColour(ped, 27)
				DecorSetInt(Config.Missions[input].Vehicles[i].id2,"mrppedtarget",i)
			--	BeginTextCommandSetBlipName("STRING")
			--	AddTextComponentString("Target ($"..getTargetKillReward(input)..")")
			--	EndTextCommandSetBlipName(ped)						
			else
			--	SetBlipColour(ped, 1)
			--	BeginTextCommandSetBlipName("STRING")
			--	AddTextComponentString("Enemy ($"..getKillReward(input)..")")
			--	EndTextCommandSetBlipName(ped)							
			
			end	

			if Config.Missions[input].Vehicles[i].armor then --if ped has armor
				AddArmourToPed(Config.Missions[input].Vehicles[i].id2, Config.Missions[input].Vehicles[i].armor)
				SetPedArmour(Config.Missions[input].Vehicles[i].id2, Config.Missions[input].Vehicles[i].armor)
			end						
			
			SetAiWeaponDamageModifier(1.0) -- 1.0 == Normal Damage. 
			-- ^ Sets Custom NPC Damage. ^
				--Now check if Vehicle has turrets and fill those positions...
				--SHOULD THIS EVEN BE CALLED IN SPAWNPEDS?, since ExtraPeds attribute can define this
			
			if Config.Missions[input].Vehicles[i].id2 ~=nil and not Config.Missions[input].Vehicles[i].noFill then 
				--only add peds to turrets if an id2 NPC driver
				PutPedsIntoTurrets(Config.Missions[input].Vehicles[i].id,Config.Missions[input].Vehicles[i].Vehicle,Config.Missions[input].Vehicles[i].modelHash,Config.Missions[input].Vehicles[i].Weapon,Config.Missions[input].Type,firingpatterns.turretfiringpattern,input,i)
				
	
			end	
		else 
			--print("MADE IT SPAWN PED VEH")
			--no NPC driver, so must be a vehicle for the player, add a safehouse var to it. 
			
			DecorSetInt(Config.Missions[input].Vehicles[i].id,"mrpvehsafehouse",i)
			--also make it not invulnerable to NPCs
			SetEntityOnlyDamagedByPlayer(Config.Missions[input].Vehicles[i].id, false)
			if getMissionConfigProperty(input,"MissionDoBackup") then
				SetEntityCanBeDamagedByRelationshipGroup(Config.Missions[input].Vehicles[i].id,true,"HATES_PLAYER")
				SetEntityCanBeDamagedByRelationshipGroup(Config.Missions[input].Vehicles[i].id,true,"PLAYER")
				SetEntityCanBeDamagedByRelationshipGroup(Config.Missions[input].Vehicles[i].id,true,"ISDEFENDTARGET")
			end			
			
										
		end
    end
	--SPAWN SAFE HOUSE PEDS TOO
	if getMissionConfigProperty(input, "UseSafeHouse") then
		SpawnSafeHouseProps(input,rIndex,IsRandomSpawnAnywhereInfo) 
	end
	PedsSpawned = 1
    aliveCheck()
end)

--FOR: Config.Missions[MissionName].IndoorsMission=true
--spawn NPCs nearby (30m) as players progress, to stop invisible peds showing up
--used with SpawnAPed, which is derived from the default SpawnPed event
Citizen.CreateThread(function()
    while true do
		if (Active == 1) and  MissionName ~="N/A" and Config.Missions[MissionName].IndoorsMission and MissionTriggered then 
			for i, v in pairs(Config.Missions[MissionName].Peds) do
				
				
				if Config.Missions[MissionName].Peds[i].spawned then --DoesEntityExist(Config.Missions[MissionName].Peds[i].id) then
					--print("ped already spawned")
					
				else
					--allow for 'outside' peds to spawn right away, but let host do that
					if(Config.Missions[MissionName].Peds[i].outside and NetworkIsHost()) then 
						--print("spawn outside ped"..i)
						SpawnAPed(MissionName,i,false)
						Config.Missions[MissionName].Peds[i].spawned = true
						TriggerServerEvent("sv:spawned",MissionName, i, false)	
						
					end
				
					local p1 = GetEntityCoords(GetPlayerPed(-1), true)
					if GetDistanceBetweenCoords(p1.x,p1.y,p1.z,Config.Missions[MissionName].Peds[i].x,Config.Missions[MissionName].Peds[i].y,Config.Missions[MissionName].Peds[i].z,true) <= getMissionConfigProperty(MissionName, "IndoorsMissionSpawnRadius") and not Config.Missions[MissionName].Peds[i].spawned then 
						--print("spawn ped"..i)
						local spawnentity = true
						
						if (Config.Missions[MissionName].IndoorsMissionStrongSpawnCheck and GetPlayersInLineOfSight(Config.Missions[MissionName].Peds[i].x,Config.Missions[MissionName].Peds[i].y,Config.Missions[MissionName].Peds[i].z)) then
							spawnentity = false
						end
						if spawnentity then 
						
							SpawnAPed(MissionName,i,false)
						end
						
						Config.Missions[MissionName].Peds[i].spawned = true
						TriggerServerEvent("sv:spawned",MissionName, i, false)						
						
					end
				end
			end
			for i, v in pairs(Config.Missions[MissionName].Vehicles) do
				if Config.Missions[MissionName].Vehicles[i].spawned then --DoesEntityExist(Config.Missions[MissionName].Peds[i].id) then
					--print("vehicle already spawned")
					
				else
				
					--allow for 'outside' vehicles to spawn right away, but let host do that
					if(Config.Missions[MissionName].Vehicles[i].outside and NetworkIsHost()) then 
						--print("spawn outside vehicle"..i)
						SpawnAPed(MissionName,i,true)
						Config.Missions[MissionName].Vehicles[i].spawned = true
						TriggerServerEvent("sv:spawned",MissionName, i, true)	
						
					end				
					local p1 = GetEntityCoords(GetPlayerPed(-1), true)
					if GetDistanceBetweenCoords(p1.x,p1.y,p1.z,Config.Missions[MissionName].Vehicles[i].x,Config.Missions[MissionName].Vehicles[i].y,Config.Missions[MissionName].Vehicles[i].z,true) <= getMissionConfigProperty(MissionName, "IndoorsMissionSpawnRadius") and not Config.Missions[MissionName].Vehicles[i].spawned then 
						--print("spawn vehicle"..i)
						local spawnentity = true
						
						if (Config.Missions[MissionName].IndoorsMissionStrongSpawnCheck and GetPlayersInLineOfSight(Config.Missions[MissionName].Vehicles[i].x,Config.Missions[MissionName].Vehicles[i].y,Config.Missions[MissionName].Vehicles[i].z)) then
							spawnentity = false
						end
						if spawnentity then 
							SpawnAPed(MissionName,i,true)
						end						
						
						Config.Missions[MissionName].Vehicles[i].spawned = true
						TriggerServerEvent("sv:spawned",MissionName, i, true)
					end
				end
			end			
			
		end
    		Citizen.Wait(1)
	end
end)

--does ray cast on all players for the spawn position to see if 
--the spawn position can spawn a vehicle/ped
--need to check for all players per client, not just for local player, since other players can be > 30m but in line of sight
function GetPlayersInLineOfSight(px,py,pz)
	local players = GetPlayers()
	for index,value in ipairs(players) do
		local target = GetPlayerPed(value)
			
	
			local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
			--only raycast for players within 300m
			if GetDistanceBetweenCoords(px, py, pz,targetCoords["x"], targetCoords["y"], targetCoords["z"],true) <= 300 then 
				local RayHandle = CastRayPointToPoint(px, py, pz,targetCoords["x"], targetCoords["y"], targetCoords["z"], -1, -1, 0) --10
				local _,_,_,_,Ent = GetRaycastResult(RayHandle)
				
				if(DoesEntityExist(Ent) and (Ent == target or Ent==GetVehiclePedIsIn(target, false))) then 
					--we have a direct line of sight. return true
					--print("found player ped, dont spawn")
					
					return true
				--elseif DoesEntityExist(Ent) then
					--not working as explected returns 1, but getentitytype is 0?
					--there is another entity in between spawn position and target(could be another ped, object or vehicle), dont spawn to be safe 
					--print("found entity in between, dont spawn:"..GetEntityType(Ent))
					--return true
				end
			end
			
			
	end
	--print("did not find player ped, spawn")
	return false
end


--used (for Events) to have Peds target the 
--IsDefendTarget Ped
function TargetIsDefendtargetPed(Ped) 
	
	for tped in EnumeratePeds() do
		if(DecorGetInt(tped,"mrppeddefendtarget")) > 0 then 	
			RegisterTarget(Ped,tped)
			
			--should only ever be one atm.
			return tped
		end 
	end
	return nil
end

function GetIsDefendtargetPed() 
	
	for tped in EnumeratePeds() do
		if(DecorGetInt(tped,"mrppeddefendtarget")) > 0 then 	
			--should only ever be one atm.
			return tped
		end 
	end
	return nil
end


--used (for Events) to have
--IsDefendTarget Ped trigger events if Event has IsDefendTargetTriggersEvent
--is set to true
function EventIsDefendtargetPedDistance(pcoords,k) 
	
	for ped in EnumeratePeds() do
		if(DecorGetInt(ped,"mrppeddefendtarget")) > 0 then 	
			
			local pIsDefendTargetCoords = GetEntityCoords(ped, true)
			--print('hey2')
			if(GetDistanceBetweenCoords(pIsDefendTargetCoords.x,pIsDefendTargetCoords.y,pIsDefendTargetCoords.z, Config.Missions[MissionName].Events[k].Position.x, Config.Missions[MissionName].Events[k].Position.y, Config.Missions[MissionName].Events[k].Position.z, true) < Config.Missions[MissionName].Events[k].Size.radius) and not Config.Missions[MissionName].Events[k].done then
				--print('made it')
				return pIsDefendTargetCoords
			
			end
			
			
			--should only ever be one atm.
			return pcoords
		end 
	end
	
	return pcoords
	
end

function SpawnAPed(input,i,isVehicle,EventName,DoIsDefendBehavior,DoBlockingOfNonTemporaryEvents)
	--get any target ped for IsDefendTarget missions
	local IsDefendTargets --= SpawnProps(input) --returns {TargetPed,TargetPedVehicle}
	local TargetPed --= IsDefendTargets[1]
	local TargetPedVehicle --= IsDefendTargets[2]
	
	if getMissionConfigProperty(input, "IsBountyHunt") and not Config.Missions[input].Peds[i] and EventName == "RandomSquadEvent" then
		print("no ped found in SpawnAPed")
		return
	end
	
	--SpawnMissionPickups(input) --called in missionhb
    if not isVehicle then 
		
		--support for wide area spawn radius when using doSquad, do some checking. 
		if(Config.Missions[input].Peds[i].CheckGroundZ) then
			local success = true
			local x = Config.Missions[input].Peds[i].x
			local y = Config.Missions[input].Peds[i].y
			local z = Config.Missions[input].Peds[i].z
			local zGround = checkAndGetGroundZ(x, y, z + 800.0,true)
			if zGround > 0.0 then --flag for checkspawn
				z =  zGround
				
				if getMissionConfigProperty(input, "IsBountyHunt") and not Config.Missions[input].Peds[i] and EventName == "RandomSquadEvent" then
					print("no ped found in SpawnAPed")
					return
				end				
				Config.Missions[input].Peds[i].z = z		
			end
			
			--maybe not do ray trace?
			local ray = Citizen.InvokeNative( 0x377906D8A31E5586, vector3(x, y, z) + vector3(0.0, 0.0, 1000.0), vector3(x, y, z), -1, -1, 0)
					--local ray = StartShapeTestRay(vector3(rXoffset, rYoffset, rZoffset) + vector3(0.0, 0.0, 500.0), vector3(rXoffset, rYoffset, rZoffset), -1, -1, 0)
					-- local _, hit, impactCoords  = Citizen.InvokeNative( 0x3D87450E15D98694, ray,hit)
			local _, hit, impactCoords = GetRaycastResult(ray) --GetShapeTesResult(ray)
					-- print("HIT: " .. hit)
					-- print(("IMPACT COORDS: X = %.4f; Y = %.4f; Z = %.4f"):format(impactCoords.x, impactCoords.y, impactCoords.z))
					-- print("DISTANCE BETWEEN DROP AND IMPACT COORDS: " ..  #(vector3(dropCoords.x, dropCoords.y, dropCoords.z) - vector3(impactCoords)))
			if hit == 0 or (hit == 1 and #(vector3(x, y, z) - vector3(impactCoords)) < 0.5) then -- ± 0.5 units
						--print("ROOFCHECK: vehicle success")
				success = true
			else
						--print("ROOFCHECK: vehicles fail")
				success = false
					   
			end	
					
			local watertest = GetWaterHeight(x, y, z)
			if watertest  == 1 or watertest  == true then 
				success = false
			end				
			
			if not success then 
				return false
			end
			
		
		end
		
		
		--print("post:")
		--print(i)
		if getMissionConfigProperty(input, "IsBountyHunt") and (not Config.Missions[input].Peds[i] or not Config.Missions[input].Peds[i].modelHash) and EventName == "RandomSquadEvent" then 
			print("no ped modelhash found in SpawnAPed")
			return 
		end
		--print(Config.Missions[input].Peds[i].modelHash)
		local rModelHash = Config.Missions[input].Peds[i].modelHash
        RequestModel(GetHashKey(rModelHash))
        while not HasModelLoaded(GetHashKey(rModelHash))  do
          Wait(1)
		  --extra checks for IsBountyHunt doRandomSquad
		  --if not Config.Missions[input].Peds[i] then return end
        end
		
		if getMissionConfigProperty(input, "IsBountyHunt") and (not Config.Missions[input].Peds[i] or not Config.Missions[input].Peds[i].modelHash) and EventName == "RandomSquadEvent" then 
			print("no ped modelhash found in SpawnAPed")
			 SetModelAsNoLongerNeeded(rModelHash)
			return 
		end		
		
        Config.Missions[input].Peds[i].id = CreatePed(2, rModelHash, Config.Missions[input].Peds[i].x, Config.Missions[input].Peds[i].y, Config.Missions[input].Peds[i].z, Config.Missions[input].Peds[i].heading, true, true)
        SetModelAsNoLongerNeeded(rModelHash)
		SetEntityAsMissionEntity(Config.Missions[input].Peds[i].id,true,true)
		
		if Config.Missions[input].Peds[i].z ==0.0 and getMissionConfigProperty(input, "IsRandom") then 
				DecorSetInt(Config.Missions[input].Peds[i].id,"mrpvehdidGround",1)
				FreezeEntityPosition(Config.Missions[input].Peds[i].id,true)
		end
		
		
		if DoBlockingOfNonTemporaryEvents then
			
			SetBlockingOfNonTemporaryEvents(Config.Missions[input].Peds[i].id, true) 
		end		
		
		--SetEntityCoords(Config.Missions[input].Peds[i].id,Config.Missions[input].Peds[i].x,Config.Missions[input].Peds[i].y,Config.Missions[input].Peds[i].z)
		
		--Stop AI from blowing themselves up!
		--SetEntityCanBeDamagedByRelationshipGroup(Config.Missions[input].Peds[i].id, false, GetHashKey("HATES_PLAYER"))
		--SetEntityCanBeDamagedByRelationshipGroup(Config.Missions[input].Peds[i].id, false, GetHashKey("TRUENEUTRAL"))	
		if not getMissionConfigProperty(input,"IsDefendTarget") or (getMissionConfigProperty(input,"IsDefendTarget") and getMissionConfigProperty(input,"IsDefendTargetOnlyPlayersDamagePeds") ) then	
			--print("hey")
			SetEntityOnlyDamagedByPlayer(Config.Missions[input].Peds[i].id, true)
		end 
		
		if getMissionConfigProperty(input,"MissionDoBackup") then
			--print("hey2")
			SetEntityOnlyDamagedByPlayer(Config.Missions[input].Peds[i].id, false)
			SetEntityCanBeDamagedByRelationshipGroup(Config.Missions[input].Peds[i].id,false,"HATES_PLAYER")
			SetEntityCanBeDamagedByRelationshipGroup(Config.Missions[input].Peds[i].id,true,"PLAYER")
			SetEntityCanBeDamagedByRelationshipGroup(Config.Missions[input].Peds[i].id,true,"ISDEFENDTARGET")
		end		
		
		if(Config.Missions[input].Peds[i].modelHash == "s_m_m_movalien_01") then
			SetPedDefaultComponentVariation(Config.Missions[input].Peds[i].id) --GHK for s_m_m_movalien_01
		end
		
		--for IsDefend, they beeline to the objective
		if not Config.Missions[input].Peds[i].conqueror then 
			--use 'notzed' attribute to remove extra zombietype characteristics for these models
			if (Config.Missions[input].Peds[i].modelHash == "u_m_y_zombie_01" or Config.Missions[input].Peds[i].modelHash == "s_m_m_movalien_01" or Config.Missions[input].Peds[i].modelHash ==  "ig_orleans") and not Config.Missions[input].Peds[i].notzed then  --or Config.Missions[input].Peds[i].modelHash ==  "ig_orleans") then --movie zed
					SetPedFleeAttributes(Config.Missions[input].Peds[i].id, 0, 0)
					SetPedCombatAttributes(Config.Missions[input].Peds[i].id, 16, true)
					SetPedCombatAttributes(Config.Missions[input].Peds[i].id, 46, true)
					SetPedCombatAttributes(Config.Missions[input].Peds[i].id, 26, true)
					SetAmbientVoiceName(Config.Missions[input].Peds[i].id, "ALIENS")
					SetPedEnableWeaponBlocking(Config.Missions[input].Peds[i].id, true)			
					DisablePedPainAudio(Config.Missions[input].Peds[i].id,true)
					
				--if not Config.Missions[input].Peds[i].modelHash == "ig_orleans" then
					ApplyPedBlood(Config.Missions[input].Peds[i].id, 3, math.random(0, 4) + 0.0, math.random(-0, 4) + 0.0, math.random(-0, 4) + 0.0, "wound_sheet")
					SetPedIsDrunk(Config.Missions[input].Peds[i].id, true)
					RequestAnimSet("move_m@drunk@verydrunk")
					while not HasAnimSetLoaded("move_m@drunk@verydrunk") do
						Wait(1)
					end
					SetPedMovementClipset(Config.Missions[input].Peds[i].id, "move_m@drunk@verydrunk", 1.0)						
				--end		
					
				--SetPedCombatRange(Config.Missions[input].Peds[i].id, 2)
			  --	SetPedSeeingRange(Config.Missions[input].Peds[i].id, 100000000.0)
				--SetPedHearingRange(Config.Missions[input].Peds[i].id, 100000000.0)
			  --SetPedCombatAttributes(Config.Missions[input].Peds[i].id, 46, true);
			 -- SetPedCombatAttributes(Config.Missions[input].Peds[i].id, 5, true);
			  --SetPedCombatAttributes(Config.Missions[input].Peds[i].id, 1, false);
			  --SetPedCombatAttributes(Config.Missions[input].Peds[i].id, 0, false);
			  --SetPedCombatAbility(Config.Missions[input].Peds[i].id, 0);
			
			  --SetPedRagdollBlockingFlags(Config.Missions[input].Peds[i].id, 4);
			  --SetPedCanPlayAmbientAnims(Config.Missions[input].Peds[i].id, false);	
			  -- SetAmbientVoiceName(Config.Missions[input].Peds[i].id,"ALIENS")
			   --DisablePedPainAudio(Config.Missions[input].Peds[i].id,true)
			  -- RequestAnimSet("move_m@drunk@verydrunk");
			   --SetPedMovementClipset(Config.Missions[input].Peds[i].id, "move_m@drunk@verydrunk",1.0);				
			else 
				if not Config.Missions[input].Peds[i].friendly then
					SetPedCombatAttributes(Config.Missions[input].Peds[i].id, 5, true)
					SetPedCombatAttributes(Config.Missions[input].Peds[i].id, 46, true);
					SetPedCombatAttributes(Config.Missions[input].Peds[i].id, 2, true)
				end
				--SetPedCombatAttributes(Config.Missions[input].Peds[i].id, 0, false);
				SetPedCombatAttributes(Config.Missions[input].Peds[i].id, 0, true);
				SetPedCombatAttributes(Config.Missions[input].Peds[i].id, 1, true) --can use vehicles
				SetPedCombatAttributes(Config.Missions[input].Peds[i].id, 2, true) --can do drivebys
				--SetPedCombatAttributes(Config.Missions[input].Peds[i].id, 1424, true)
				--SetPedCombatAttributes(Config.Missions[input].Peds[i].id, 20, false)
				--TaskCombatPed(Config.Missions[input].Peds[i].id, GetPlayerPed(-1), 0,16)
				--TaskVehicleShootAtPed(Config.Missions[input].Peds[i].id,GetPlayerPed(-1))
			end
		
			if not Config.Missions[input].Peds[i].friendly then
				SetPedRelationshipGroupHash(Config.Missions[input].Peds[i].id, GetHashKey("HATES_PLAYER"))
				SetRelationshipBetweenGroups(5, GetHashKey("HATES_PLAYER"), GetHashKey("PLAYER"))
				SetRelationshipBetweenGroups(0, GetHashKey("HATES_PLAYER"), GetHashKey("HATES_PLAYER"))
				SetRelationshipBetweenGroups(5, GetHashKey("HATES_PLAYER"), GetHashKey("ISDEFENDTARGET"))	
				SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("HATES_PLAYER"))
				SetRelationshipBetweenGroups(0, GetHashKey("HATES_PLAYER"), GetHashKey("TRUENEUTRAL"))
				SetRelationshipBetweenGroups(5, GetHashKey("TRUENEUTRAL"), GetHashKey("ISDEFENDTARGET"))	
			else 
				SetPedRelationshipGroupHash(Config.Missions[input].Peds[i].id, GetHashKey("HOSTAGES"))
				SetRelationshipBetweenGroups(1, GetHashKey("HOSTAGES"), GetHashKey("HATES_PLAYER"))
				SetRelationshipBetweenGroups(1, GetHashKey("HOSTAGES"), GetHashKey("PLAYER"))
				if getMissionConfigProperty(input, "DelicateHostages") then 
					SetEntityOnlyDamagedByPlayer(Config.Missions[input].Peds[i].id, false)
				else			
					SetEntityOnlyDamagedByPlayer(Config.Missions[input].Peds[i].id, true)								
				end		
				
			end
			
		else 	
			-- is there a better way to make an NPC true neutral?
			--does not handle custom groups from other resources
			SetPedFleeAttributes(Config.Missions[input].Peds[i].id, 0, 0)
			SetPedRelationshipGroupHash(Config.Missions[input].Peds[i].id, GetHashKey("TRUENEUTRAL"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("PLAYER"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("HATES_PLAYER"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("HOSTAGES"))
			SetRelationshipBetweenGroups(0, GetHashKey("HATES_PLAYER"), GetHashKey("TRUENEUTRAL"))
			
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("CIVMALE"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("CIVFEMALE"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("COP"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("SECURITY_GUARD"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("PRIVATE_SECURITY"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("FIREMAN"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("GANG_1"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("GANG_2"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("GANG_9"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("GANG_10"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_LOST"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_MEXICAN"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_FAMILY"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_BALLAS"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_MARABUNTE"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_CULT"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_SALVA"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_WEICHENG"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_HILLBILLY"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("DEALER"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("WILD_ANIMAL"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("SHARK"))
			--SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("HATES_PLAYER"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("COUGAR"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("NO_RELATIONSHIP"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("SPECIAL"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION2"))		
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("NO_RELATIONSHIP"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("SPECIAL"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION2"))			
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION3"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION4"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION5"))			
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION6"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION7"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION8"))			
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("ARMY"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("GUARD_DOG"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AGGRESSIVE_INVESTIGATE"))						
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MEDIC"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("PRISONER"))	
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("DOMESTIC_ANIMAL"))
			--For IsDefendTarget Missions:
			SetRelationshipBetweenGroups(5, GetHashKey("TRUENEUTRAL"), GetHashKey("ISDEFENDTARGET"))	
			
			DecorSetInt(Config.Missions[input].Peds[i].id,"mrppedconqueror",i)
			--print('spawned Ped Conqueror')
			
		end
		
		--they weill combat but also try and keep to the task
		if Config.Missions[input].Peds[i].attacker then 
			DecorSetInt(Config.Missions[input].Peds[i].id,"mrppedconqueror",i)
		end
		
		--SetEntityAsMissionEntity(Config.Missions[input].Peds[i].id,true,true)
		 SetPedSeeingRange(Config.Missions[input].Peds[i].id, 10000.0)
         SetPedHearingRange(Config.Missions[input].Peds[i].id, 10000.0)
		 
		SetPedAccuracy(Config.Missions[input].Peds[i].id,math.random(getMissionConfigProperty(input, "SetPedMinAccuracy"),getMissionConfigProperty(input, "SetPedMaxAccuracy")))
		 
		SetPedPathAvoidFire(Config.Missions[input].Peds[i].id,  1)
		SetPedPathCanUseLadders(Config.Missions[input].Peds[i].id,1)
		SetPedPathCanDropFromHeight(Config.Missions[input].Peds[i].id, 1)
		SetPedPathCanUseClimbovers(Config.Missions[input].Peds[i].id,1)		

		--SetEntityAsMissionEntity(Config.Missions[input].Peds[i].id,true,true)
		DecorSetInt(Config.Missions[input].Peds[i].id,"mrppedid",i)
		
        SetPedDropsWeaponsWhenDead(Config.Missions[input].Peds[i].id, getMissionConfigProperty(input, "SetPedDropsWeaponsWhenDead"))
        SetPedDiesWhenInjured(Config.Missions[input].Peds[i].id, true)
        
		if not Config.Missions[input].Peds[i].friendly then
			
			if Config.Missions[input].Peds[i].isBoss then 
				DecorSetInt(Config.Missions[input].Peds[i].id,"mrppedboss",1)
				doBossBuff(Config.Missions[input].Peds[i].id,Config.Missions[input].Peds[i].modelHash,input,Config.Missions[input].Peds[i].Weapon)
			
			if Config.Missions[input].Type=="BossRush" then 
				DecorSetInt(Config.Missions[input].Peds[i].id,"mrppedtarget",445566)
			end
				
			else 
				GiveWeaponToPed(Config.Missions[input].Peds[i].id, Config.Missions[input].Peds[i].Weapon, 2800, false, true)
				SetPedInfiniteAmmo(Config.Missions[input].Peds[i].id, true, Config.Missions[input].Peds[i].Weapon)
				if(Config.Missions[input].Peds[i].Weapon == 0x42BF8A85) then 
					--minigun
					SetPedFiringPattern(Config.Missions[input].Peds[i].id, 0x914E786F) --FIRING_PATTERN_BURST_FIRE_HELI
				end	
			end
		
			if getMissionConfigProperty(input, "FastFiringPeds") then 
				SetPedFiringPattern(Config.Missions[input].Peds[i].id, 0xC6EE6B4C) --FIRING_PATTERN_BURST_FIRE_HELI
			end 	
			SetPedAlertness(Config.Missions[input].Peds[i].id,3)	
			
	   end 
		ResetAiWeaponDamageModifier()
		if Config.Missions[input].Peds[i].modelHash == "mp_m_boatstaff_01" then --L. Ron
			SetPedPropIndex(Config.Missions[input].Peds[i].id, 0, 0, 0, 2)
			--SetPedPropIndex(Config.Missions[input].Peds[i].id, 0, 8, 0, 2) 
		end 
		if Config.Missions[input].Peds[i].invincible then
			SetEntityInvincible(Config.Missions[input].Peds[i].id, true)
		end
		
		if Config.Missions[input].Peds[i].dead then
			--ApplyDamageToPed(Config.Missions[input].Peds[i].id,90,true)
			
			--ExplodePedHead(Config.Missions[input].Peds[i].id,0x7F7497E5)
			SetEntityHealth(Config.Missions[input].Peds[i].id, 0.0)
			DecorSetInt(Config.Missions[input].Peds[i].id,"mrppedfriend",0) --make them not friendly so the player is not penalized!
			DecorSetInt(Config.Missions[input].Peds[i].id,"mrppedid",0) --remove all decor 
			DecorSetInt(Config.Missions[input].Peds[i].id,"mrppedtarget",0) --remove all decor
			DecorSetInt(Config.Missions[input].Peds[i].id,"mrppedead",1)	
			--print("dead ped")
		end				
		
		if Config.Missions[input].Peds[i].wander then
			TaskWanderStandard(Config.Missions[input].Peds[i].id,10.0, 10)
		elseif Config.Missions[input].Peds[i].wanderinarea then
			TaskWanderInArea(Config.Missions[input].Peds[i].id,Config.Missions[input].Peds[i].x,Config.Missions[input].Peds[i].y,Config.Missions[input].Peds[i].z,25.0,0.0,0.0) --wanderinarea within 25 meters 
		end		
		
      --  local ped = AddBlipForEntity(Config.Missions[input].Peds[i].id)
      --  local Size     = 0.9
      --  SetBlipScale  (ped, Size)
      --  SetBlipAsShortRange(ped, false)
		
		if Config.Missions[input].Peds[i].friendly then 
			TaskCower(Config.Missions[input].Peds[i].id,360000) -- 1hour
			--SetBlipColour(ped, 66)
			--SetBlipSprite(ped, 280)
		--	SetBlipColour(ped, 2)
			--BeginTextCommandSetBlipName("STRING")
			--AddTextComponentString("Friend ($-"..getHostageKillPenalty(input)..")")
			--EndTextCommandSetBlipName(ped)	
			--print("spawned hostage")			
			DecorSetInt(Config.Missions[input].Peds[i].id,"mrppedfriend",i)
			--GHK 
			--if getMissionConfigProperty(input, "Type") == "HostageRescue"  and not Config.Missions[input].Peds[i].dead then
				--isHostageRescueCount = isHostageRescueCount + 1
			--end 

			if getMissionConfigProperty(input, "Type") == "HostageRescue" 
			and getMissionConfigProperty(input, "IsRandom") then
				IsRandomMissionHostageCount = IsRandomMissionHostageCount + 1
			end			
			
		elseif Config.Missions[input].Peds[i].target then --if ped is a target in assassinate
			--SetBlipColour(ped, 66)
			--SetBlipSprite(ped, 433)
			--SetBlipColour(ped, 27)
			--BeginTextCommandSetBlipName("STRING")
			--AddTextComponentString("Target ($"..getTargetKillReward(input)..")")
			--EndTextCommandSetBlipName(ped)						
			DecorSetInt(Config.Missions[input].Peds[i].id,"mrppedtarget",i)
		else
		--	BeginTextCommandSetBlipName("STRING")
		--	AddTextComponentString("Enemy ($"..getKillReward(input)..")")
		--	EndTextCommandSetBlipName(ped)								
		end	
		
	
			local movespeed = 2.0 --How fast can peds move?
			if(Config.Missions[input].Peds[i]) then 
				if Config.Missions[input].Peds[i].movespeed ~= nil then
					movespeed = Config.Missions[input].Peds[i].movespeed
				end				
			end

			if EventName and EventName=="SquadEvent" then 
					
				if not Config.Missions[input].Peds[i].faceplayer then 
					SetEntityHeading(Config.Missions[input].Peds[i].id,Config.Missions[input].Peds[i].heading)
				else
					makeEntityFaceEntity(Config.Missions[input].Peds[i].id,GetPlayerPed(-1))
				end									
					
				ptable = GetPlayers()
				
				TargetPed = TargetIsDefendtargetPed(Config.Missions[input].Peds[i].id) 
				for _, k in ipairs(ptable) do
					RegisterTarget(Config.Missions[input].Peds[i].id,GetPlayerPed(k))
				end									
				TaskCombatHatedTargetsAroundPed(Config.Missions[input].Peds[i].id,1000.0)
							
			end
			
			--conqueror bee-lines to objective and is neutral, attacker will combat
			--everyone, friendlies as well move
			if DoIsDefendBehavior and Config.Missions[input].IsDefend  then 
				
				if Config.Missions[input].IsDefendTarget then 
					if TargetPed ==nil then
						print("NIL TargetPed for IsDefendTarget")
					end
					
					if(Config.Missions[input].IsDefendTargetChase) then
					
						--ClearPedTasksImmediately(Config.Missions[input].Peds[i].id)
						--print('TASK MOVE TO ENTITY')
						--print('TASK MOVE TO entity movespeed:'..movespeed)
						--TaskGoToEntity(Config.Missions[input].Peds[i].id, TargetPed, -1, 5.0, movespeed,1073741824, 0)
						--TaskFollowToOffsetOfEntity(ped, entity, 0.0, 0.0, 0.0, 10.0, -1, 10.0, true)
						--SetPedKeepTask(Config.Missions[input].Peds[i].id,true) 
						
						local _, sequence = OpenSequenceTask(0)
						TaskGoToEntity(0, TargetPed, -1, 5.0, movespeed,1073741824, 0)
					
					--RegisterTarget(Config.Missions[input].Peds[i].id, TargetPed)
					
						TaskCombatPed(0, TargetPed, 0, 16)
						CloseSequenceTask(sequence)
						ClearPedTasks(Config.Missions[input].Peds[i].id)
						ClearPedTasksImmediately(Config.Missions[input].Peds[i].id)

						-- execute sequence on cop2
						TaskPerformSequence(Config.Missions[input].Peds[i].id, sequence)
						ClearSequenceTask(sequence)					
						--TaskCombatHatedTargetsAroundPed(Config.Missions[input].Peds[i].id,1000.0)					
					
						--TaskFollowToOffsetOfEntity(ped, entity, 0.0, 0.0, 0.0, 10.0, -1, 10.0, true)
						--SetPedKeepTask(Config.Missions[input].Peds[i].id,true) 						
					end
					
					if (not Config.Missions[input].IsDefendTargetChase) and (Config.Missions[input].IsDefendTargetGotoBlip) then 
						
						ClearPedTasksImmediately(Config.Missions[input].Peds[i].id)
						TaskGoStraightToCoord(Config.Missions[input].Peds[i].id,Config.Missions[input].Blip.Position.x, Config.Missions[input].Blip.Position.y,Config.Missions[input].Blip.Position.z, movespeed, 100000, 0.0, 0.0) 
						SetPedKeepTask(Config.Missions[input].Peds[i].id,true) 					
					end
					
				else
				
					ClearPedTasksImmediately(Config.Missions[input].Peds[i].id)
					TaskGoStraightToCoord(Config.Missions[input].Peds[i].id,Config.Missions[input].Marker.Position.x, Config.Missions[input].Marker.Position.y,Config.Missions[input].Marker.Position.z, movespeed, 100000, 0.0, 0.0) 
					SetPedKeepTask(Config.Missions[input].Peds[i].id,true) 
				end
			
			end		

			--override everything with movetocoord
			if Config.Missions[input].Peds[i].movetocoord then 
				
				ClearPedTasksImmediately(Config.Missions[input].Peds[i].id)
				TaskGoStraightToCoord(Config.Missions[input].Peds[i].id,Config.Missions[input].Peds[i].movetocoord.x, Config.Missions[input].Peds[i].movetocoord.y,Config.Missions[input].Peds[i].movetocoord.y, movespeed, 100000, 0.0, 0.0) 
				SetPedKeepTask(Config.Missions[input].Vehicles[i].id2,true) 
			end			
		
		if Config.Missions[input].Peds[i].armor then --if ped has armor
			AddArmourToPed(Config.Missions[input].Peds[i].id, Config.Missions[input].Peds[i].armor)
			SetPedArmour(Config.Missions[input].Peds[i].id, Config.Missions[input].Peds[i].armor)
		end				
       -- blip = GetBlipFromEntity(ped)
		
        SetAiWeaponDamageModifier(1.0) -- 1.0 == Normal Damage. 
		
		--use 'notzed' attribute to remove extra zombietype characteristics for these models
		if (Config.Missions[input].Peds[i].modelHash == "u_m_y_zombie_01" or Config.Missions[input].Peds[i].modelHash == "s_m_m_movalien_01" or Config.Missions[input].Peds[i].modelHash == "ig_orleans") and not Config.Missions[input].Peds[i].notzed then --movie zed
			SetAiMeleeWeaponDamageModifier(50.0)
			SetPedSuffersCriticalHits(Config.Missions[input].Peds[i].id, 0) 
			SetPedDiesWhenInjured(Config.Missions[input].Peds[i].id, false) 
			SetPedCanRagdoll(Config.Missions[input].Peds[i].id, false) 					
			DecorSetInt(Config.Missions[input].Peds[i].id,"mrppedmonster",i)
			if (Config.Missions[input].Peds[i].modelHash == "s_m_m_movalien_01" or Config.Missions[input].Peds[i].modelHash == "ig_orleans") then
				--DOES NOT SEEM TO WORK FOR NPCS
				SetPedMaxHealth(Config.Missions[input].Peds[i].id, 1000)
				SetEntityHealth(Config.Missions[input].Peds[i].id, 1000)
				--SetPlayerMaxArmour(Config.Missions[input].Peds[i].id,100)
				AddArmourToPed(Config.Missions[input].Peds[i].id, 100)
				SetPedArmour(Config.Missions[input].Peds[i].id, 100)
			end		
		
		
		else 
			SetAiMeleeWeaponDamageModifier(1.0)
			-- ^ Sets Custom NPC Damage. ^
		end 
		
		--print("accuracy:"..GetPedAccuracy(Config.Missions[input].Peds[i].id))
    end
	--used to even out which players planes go to
	--print("hey")
	--if true then 
		--return true 
	--end
	
	 
	local lastrandomplayer=-1
    if isVehicle then
		--needs to be a stagger here with a Wait(1), to block async Events being called at the same time
		--which can mix up what spawns where: (probably should get rid of veh and vehiclehash)
		
		--Wait(1)
        --veh         =  Config.Missions[input].Vehicles[i].Vehicle
		
       -- vehiclehash = GetHashKey(veh)
        RequestModel(GetHashKey(Config.Missions[input].Vehicles[i].Vehicle))
       -- RequestModel(GetHashKey(Config.Missions[input].Vehicles[i].modelHash))
        while not HasModelLoaded(GetHashKey(Config.Missions[input].Vehicles[i].Vehicle))  do
          Wait(1)
        end
		--print("veh"..i..":"..veh)
        Config.Missions[input].Vehicles[i].id = CreateVehicle(GetHashKey(Config.Missions[input].Vehicles[i].Vehicle), Config.Missions[input].Vehicles[i].x, Config.Missions[input].Vehicles[i].y, Config.Missions[input].Vehicles[i].z,  Config.Missions[input].Vehicles[i].heading, 1, 0)
		SetModelAsNoLongerNeeded(GetHashKey(Config.Missions[input].Vehicles[i].Vehicle))
		SetEntityAsMissionEntity(Config.Missions[input].Vehicles[i].id,true,true)
		DecorSetInt(Config.Missions[input].Vehicles[i].id,"mrpvehdid",i)
		
		
		if Config.Missions[input].Vehicles[i].notvisible then 
			--print("heh made it")
			SetEntityVisible(Config.Missions[input].Vehicles[i].id,false,0)
			SetEntityCollision(Config.Missions[input].Vehicles[i].id,false,true)
		end		
		
		--local vcoords = GetEntityCoords(Config.Missions[input].Vehicles[i].id)
		--print("vcoordsz"..i..":"..vcoords.z)
		
		--Stop AI from blowing themselves up!
		--SetEntityCanBeDamagedByRelationshipGroup(Config.Missions[input].Vehicles[i].id, false, GetHashKey("HATES_PLAYER"))
		--SetEntityCanBeDamagedByRelationshipGroup(Config.Missions[input].Vehicles[i].id, false, GetHashKey("TRUENEUTRAL"))	
		if  not getMissionConfigProperty(input,"IsDefendTarget") or (getMissionConfigProperty(input,"IsDefendTarget") and getMissionConfigProperty(input,"IsDefendTargetOnlyPlayersDamagePeds") ) then			
			
			SetEntityOnlyDamagedByPlayer(Config.Missions[input].Vehicles[i].id, true)
		end

		if getMissionConfigProperty(input,"MissionDoBackup") then
			SetEntityOnlyDamagedByPlayer(Config.Missions[input].Vehicles[i].id, false)
			SetEntityCanBeDamagedByRelationshipGroup(Config.Missions[input].Vehicles[i].id,false,"HATES_PLAYER")
			SetEntityCanBeDamagedByRelationshipGroup(Config.Missions[input].Vehicles[i].id,true,"PLAYER")
			SetEntityCanBeDamagedByRelationshipGroup(Config.Missions[input].Vehicles[i].id,true,"ISDEFENDTARGET")
		end		
		
		local firingpatterns = {driverfiringpattern = false,turretfiringpattern = false}
		if(not Config.Missions[input].Vehicles[i].nomods) then 
			firingpatterns = doVehicleMods(Config.Missions[input].Vehicles[i].Vehicle,Config.Missions[input].Vehicles[i].id,input) 
		end
		
		--allow firing pattern override per vehicle
		if(Config.Missions[input].Vehicles[i].driverfiringpattern) then
		--print("made 1 "..Config.Missions[input].Vehicles[i].Vehicle)
			firingpatterns.driverfiringpattern = Config.Missions[input].Vehicles[i].driverfiringpattern
		end
		if(Config.Missions[input].Vehicles[i].turretfiringpattern) then
			firingpatterns.turretfiringpattern = Config.Missions[input].Vehicles[i].turretfiringpattern
		end		
		
		if Config.Missions[input].Vehicles[i].id2 ~=nil then 
			RequestModel(GetHashKey(Config.Missions[input].Vehicles[i].modelHash))
			while not HasModelLoaded(GetHashKey(Config.Missions[input].Vehicles[i].modelHash))  do
				Wait(1)
			end
			Config.Missions[input].Vehicles[i].id2 = CreatePed(2, Config.Missions[input].Vehicles[i].modelHash, Config.Missions[input].Vehicles[i].x, Config.Missions[input].Vehicles[i].y, Config.Missions[input].Vehicles[i].z, Config.Missions[input].Vehicles[i].heading, true, true)
			SetModelAsNoLongerNeeded(Config.Missions[input].Vehicles[i].modelHash)
			SetEntityAsMissionEntity(Config.Missions[input].Vehicles[i].id2,true,true)
			
			--local vcoords = GetEntityCoords(Config.Missions[input].Vehicles[i].id)
			--print("vcoordsz"..i..":"..vcoords.z)
			--Stop AI from blowing themselves up!
			--SetEntityCanBeDamagedByRelationshipGroup(Config.Missions[input].Vehicles[i].id2, false, GetHashKey("HATES_PLAYER"))
			--SetEntityCanBeDamagedByRelationshipGroup(Config.Missions[input].Vehicles[i].id2, false, GetHashKey("TRUENEUTRAL"))	
			if  not getMissionConfigProperty(input,"IsDefendTarget") or (getMissionConfigProperty(input,"IsDefendTarget") and getMissionConfigProperty(input,"IsDefendTargetOnlyPlayersDamagePeds") ) then				
				
				SetEntityOnlyDamagedByPlayer(Config.Missions[input].Vehicles[i].id2, true)
			end	
			
			if getMissionConfigProperty(input,"MissionDoBackup") then
				SetEntityOnlyDamagedByPlayer(Config.Missions[input].Vehicles[i].id2, false)
				SetEntityCanBeDamagedByRelationshipGroup(Config.Missions[input].Vehicles[i].id2,false,"HATES_PLAYER")
				SetEntityCanBeDamagedByRelationshipGroup(Config.Missions[input].Vehicles[i].id2,true,"PLAYER")
				SetEntityCanBeDamagedByRelationshipGroup(Config.Missions[input].Vehicles[i].id2,true,"ISDEFENDTARGET")
			end			
			
			DecorSetInt(Config.Missions[input].Vehicles[i].id2,"mrpvpedid",i)
			DecorSetInt(Config.Missions[input].Vehicles[i].id2,"mrpvpeddriverid",i)
			
			
			if DoBlockingOfNonTemporaryEvents then 
				--print(tostring(Config.Missions[input].Vehicles[i].id2))
				SetBlockingOfNonTemporaryEvents(Config.Missions[input].Vehicles[i].id2, true) 
			end						
			
			
			--for IsDefend, they beeline to the objective
			--except aircraft peds which require 
			if (not Config.Missions[input].Vehicles[i].conqueror) or Config.Missions[input].Vehicles[i].isAircraft then 
				if not Config.Missions[input].Vehicles[i].friendly then
					--if not Config.Missions[input].Vehicles[i].pilot then 
						SetPedRelationshipGroupHash(Config.Missions[input].Vehicles[i].id2, GetHashKey("HATES_PLAYER"))
						SetRelationshipBetweenGroups(5, GetHashKey("HATES_PLAYER"), GetHashKey("PLAYER"))
						SetRelationshipBetweenGroups(0, GetHashKey("HATES_PLAYER"), GetHashKey("HATES_PLAYER"))
						SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("HATES_PLAYER"))
						SetRelationshipBetweenGroups(5, GetHashKey("TRUENEUTRAL"), GetHashKey("ISDEFENDTARGET"))
						SetRelationshipBetweenGroups(0, GetHashKey("HATES_PLAYER"), GetHashKey("TRUENEUTRAL"))						
					
					--end
					if not Config.Missions[input].Vehicles[i].flee then --and not Config.Missions[input].Vehicles[i].pilot then 
						--print('MADE IT TO FLEE VEHPED')
						SetPedFleeAttributes(Config.Missions[input].Vehicles[i].id2, 0, 0)
						SetPedCombatAttributes(Config.Missions[input].Vehicles[i].id2, 3, false)
						SetPedCombatAttributes(Config.Missions[input].Vehicles[i].id2, 16, true)
						SetPedCombatAttributes(Config.Missions[input].Vehicles[i].id2, 46, true)
						SetPedCombatAttributes(Config.Missions[input].Vehicles[i].id2, 26, true)
						SetPedCombatAttributes(Config.Missions[input].Vehicles[i].id2, 1, true) --can use vehicles
						SetPedCombatAttributes(Config.Missions[input].Vehicles[i].id2, 2, true) --can do drivebys						
					end 
				else 
					SetPedRelationshipGroupHash(Config.Missions[input].Vehicles[i].id2, GetHashKey("HOSTAGES"))
					SetRelationshipBetweenGroups(1, GetHashKey("HOSTAGES"), GetHashKey("HATES_PLAYER"))
					SetRelationshipBetweenGroups(1, GetHashKey("HOSTAGES"), GetHashKey("PLAYER"))	
					SetRelationshipBetweenGroups(5, GetHashKey("HATES_PLAYER"), GetHashKey("ISDEFENDTARGET"))
					if getMissionConfigProperty(input, "DelicateHostages") then 
						SetEntityOnlyDamagedByPlayer(Config.Missions[input].Vehicles[i].id2, false)

					else			
						SetEntityOnlyDamagedByPlayer(Config.Missions[input].Vehicles[i].id2, true)							
					
					end					
					--SetPedRelationshipGroupHash(Config.Missions[input].Vehicles[i].id2, GetHashKey("NO_RELATIONSHIP"))
				end	
				SetPedCombatAttributes(Config.Missions[input].Vehicles[i].id2, 2, true)
				SetPedCombatAttributes(Config.Missions[input].Vehicles[i].id2, 3, false)	
				
				
				
				SetPedSeeingRange(Config.Missions[input].Vehicles[i].id2, 10000.0)
				SetPedHearingRange(Config.Missions[input].Vehicles[i].id2, 10000.0)	
			else 
			-- is there a better way to make an NPC true neutral?
			--does not handle custom groups from other resources
			
			SetPedAccuracy(Config.Missions[input].Vehicles[i].id2,math.random(getMissionConfigProperty(input, "SetPedMinAccuracy"),getMissionConfigProperty(input, "SetPedMaxAccuracy")))
			SetPedFleeAttributes(Config.Missions[input].Vehicles[i].id2, 0, 0)
			SetPedCombatAttributes(Config.Missions[input].Vehicles[i].id2, 3, false)
			
			--SetPedCombatAttributes(Config.Missions[input].Vehicles[i].id2, 1, true) --can use vehicles
			--SetPedCombatAttributes(Config.Missions[input].Vehicles[i].id2, 2, true) --can do drivebys
			
			SetPedRelationshipGroupHash(Config.Missions[input].Vehicles[i].id2, GetHashKey("TRUENEUTRAL"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("PLAYER"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("HATES_PLAYER"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("HOSTAGES"))
			SetRelationshipBetweenGroups(0, GetHashKey("HATES_PLAYER"), GetHashKey("TRUENEUTRAL"))
			
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("CIVMALE"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("CIVFEMALE"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("COP"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("SECURITY_GUARD"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("PRIVATE_SECURITY"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("FIREMAN"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("GANG_1"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("GANG_2"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("GANG_9"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("GANG_10"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_LOST"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_MEXICAN"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_FAMILY"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_BALLAS"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_MARABUNTE"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_CULT"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_SALVA"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_WEICHENG"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_HILLBILLY"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("DEALER"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("WILD_ANIMAL"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("SHARK"))
			--SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("HATES_PLAYER"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("COUGAR"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("NO_RELATIONSHIP"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("SPECIAL"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION2"))		
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("NO_RELATIONSHIP"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("SPECIAL"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION2"))			
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION3"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION4"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION5"))			
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION6"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION7"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION8"))			
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("ARMY"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("GUARD_DOG"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AGGRESSIVE_INVESTIGATE"))						
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MEDIC"))
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("PRISONER"))	
			SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("DOMESTIC_ANIMAL"))			
			SetRelationshipBetweenGroups(5, GetHashKey("TRUENEUTRAL"), GetHashKey("ISDEFENDTARGET"))	
			--print('VEH PED IS CONQUEROR')
		
		end
			
			
			--SetPedFiringPattern(Config.Missions[input].Vehicles[i].id2, 0x914E786F) --FIRING_PATTERN_BURST_FIRE_HELI
			SetPedDropsWeaponsWhenDead(Config.Missions[input].Vehicles[i].id2, getMissionConfigProperty(input, "SetPedDropsWeaponsWhenDead"))
			SetPedDiesWhenInjured(Config.Missions[input].Vehicles[i].id2, true)
			if not Config.Missions[input].Vehicles[i].friendly then
				if Config.Missions[input].Vehicles[i].isBoss then 
					DecorSetInt(Config.Missions[input].Vehicles[i].id2,"mrppedboss",1)
					doBossBuff(Config.Missions[input].Vehicles[i].id2,Config.Missions[input].Vehicles[i].modelHash,input,Config.Missions[input].Vehicles[i].Weapon)					
				else
					GiveWeaponToPed(Config.Missions[input].Vehicles[i].id2, Config.Missions[input].Vehicles[i].Weapon, 2800, false, true)	
					SetPedInfiniteAmmo(Config.Missions[input].Vehicles[i].id2, true, Config.Missions[input].Vehicles[i].Weapon)
					
				end				
				
			end
			SetPedAlertness(Config.Missions[input].Vehicles[i].id2,3)	
			ResetAiWeaponDamageModifier()
			SetPedIntoVehicle(Config.Missions[input].Vehicles[i].id2, Config.Missions[input].Vehicles[i].id, -1)
			
			if Config.Missions[input].Vehicles[i].invincible then
				SetEntityInvincible(Config.Missions[input].Vehicles[i].id2, true)
			end
			
			if Config.Missions[input].Vehicles[i].dead then
				--ApplyDamageToPed(Config.Missions[input].Peds[i].id,90,true)
				SetEntityHealth(Config.Missions[input].Vehicles[i].id2, 0.0)
				DecorSetInt(Config.Missions[input].Vehicles[i].id2,"mrppedfriend",0) --make them not friendly so the player is not penalized!
				DecorSetInt(Config.Missions[input].Vehicles[i].id2,"mrpvpedid",0) --remove all decor 
				DecorSetInt(Config.Missions[input].Vehicles[i].id2,"mrppedid",0) --remove all decor 
				DecorSetInt(Config.Missions[input].Vehicles[i].id2,"mrppedtarget",0) --remove all decor 
				DecorSetInt(Config.Missions[input].Vehicles[i].id2,"mrpvpeddriverid",0)
				DecorSetInt(Config.Missions[input].Vehicles[i].id2,"mrppedead",1)	
			end	
			
			if firingpatterns.driverfiringpattern then
				SetPedFiringPattern(Config.Missions[input].Vehicles[i].id2, firingpatterns.driverfiringpattern) 
			end		
			
			--local vehicleModel = GetEntityModel(Config.Missions[input].Vehicles[i].id)	
			--if rhino or khanjali, nerf them to be slower fire rate?
			--[[
			local vehicleModel = GetEntityModel(Config.Missions[input].Vehicles[i].id)	
			if not getMissionConfigProperty(input, "NerfDriverTurrets") then 
				SetPedFiringPattern(Config.Missions[input].Vehicles[i].id2, 0x914E786F) --FIRING_PATTERN_BURST_FIRE_HELI
			end 								
			
			
			if tostring(vehicleModel) == "782665360" or tostring(vehicleModel) == "-1435527158" then 
						--nerf tank cannon?
				if getMissionConfigProperty(input, "NerfTankCannon") then 
					SetPedFiringPattern(Config.Missions[input].Vehicles[i].id2,  0xE2CA3A71) --FIRING_PATTERN_SLOW_FIRE_TANK
				end 
			end			
			]]--
			
			local vehicleModel = GetEntityModel(Config.Missions[input].Vehicles[i].id)
			--ExtraPeds
			if Config.Missions[input].Vehicles[i].ExtraPeds then
		
				for j, v in pairs(Config.Missions[input].Vehicles[i].ExtraPeds) do
		
					SetPedIntoVehicle(Config.Missions[input].Peds[v.id].id, Config.Missions[input].Vehicles[i].id, v.seatid)
					
					if firingpatterns.turretfiringpattern then
						SetPedFiringPattern(Config.Missions[input].Peds[v.id].id, firingpatterns.turretfiringpattern)
					end				
					
					--local vehicleModel = GetEntityModel(Config.Missions[input].Vehicles[i].id)
					if tostring(vehicleModel) =="-1600252419" and v.seatid == 0 then 
						--nerf valkyrie cannon?
						if getMissionConfigProperty(input, "NerfValkyrieHelicopterCannon") then 
							SetPedFiringPattern(Config.Missions[input].Peds[v.id].id,  0xE2CA3A71) --FIRING_PATTERN_SLOW_FIRE_TANK
						end
					end
					--[[
					elseif tostring(vehicleModel) =="562680400" and v == 0 then 	
						--leave apc cannon as is?
						if getMissionConfigProperty(input, "NerfAPCCannon") then 
							SetPedFiringPattern(Config.Missions[input].Peds[v.id].id,  0xE2CA3A71) --FIRING_PATTERN_SLOW_FIRE_TANK
						end 
					else
						if not getMissionConfigProperty(input, "NerfTurrets") then 
							SetPedFiringPattern(Config.Missions[input].Peds[v.id].id, 0x914E786F) --FIRING_PATTERN_BURST_FIRE_HELI
						end 
					end 					
					]]--
				end
			
			end
			
			local AircraftEvent = false 
			
			--Events
			if EventName and EventName == "AircraftEvent" then 
			
				AircraftEvent = true
			end
			local pmodel = vehicleModel
			if(IsThisModelAPlane(pmodel) or IsThisModelAHeli(pmodel)) then 
				
				--print("aircraft event")
				if getMissionConfigProperty(input, "SafeHousePlaneAttack") and getMissionConfigProperty(input, "UseSafeHouse") and getMissionConfigProperty(input, "TeleportToSafeHouseOnMissionStart") and Config.Missions[input].MarkerS and not AircraftEvent then 
					
					local origx =  Config.Missions[input].MarkerS.Position.x
					local origy =  Config.Missions[input].MarkerS.Position.y
					local p1 = GetEntityCoords(Config.Missions[input].Vehicles[i].id, true)
					
					local dx = origx - p1.x
					local dy = origy - p1.y
						
					local heading = GetHeadingFromVector_2d(dx, dy)				 
					SetEntityHeading(Config.Missions[input].Vehicles[i].id,heading) 
				else 
					--lets select random players to head towards so planes dont just head out to sea. TaskPlaneMission/TaskHeliMission does not seem to work for me to make them circle/guard mission Blip (at least from long distance)
						
					local cnt = 0
					local tries = 0
					local foundplayer=false
					math.randomseed(GetGameTimer())
					ptable = GetPlayers()
					for _, k in ipairs(ptable) do
						cnt = cnt + 1 
						--print('player num:'..k)
					end
					--print('player count'..cnt)
					-- i.e. 8 players, then 1 in 8 chance per player
					
					if(cnt > 1) then
						local chance = cnt - 1
						repeat 
							
							for _, k in ipairs(ptable) do
								Wait(1)
								math.randomseed(GetGameTimer())
								if(math.random(1,cnt) > chance and k ~=lastrandomplayer) then
									makeEntityFaceEntity(Config.Missions[input].Vehicles[i].id,GetPlayerPed(k))
									foundplayer = true
									lastrandomplayer = k
									break
								end						
								tries = tries + 1
							end	
						until (foundplayer or tries > 25)
					else 
						makeEntityFaceEntity(Config.Missions[input].Vehicles[i].id,GetPlayerPed(-1))
					end
					
					if AircraftEvent then 
						TargetPed = TargetIsDefendtargetPed(Config.Missions[input].Vehicles[i].id2)
						ptable = GetPlayers()
						for _, k in ipairs(ptable) do
							RegisterTarget(Config.Missions[input].Vehicles[i].id2,GetPlayerPed(k))
						end						
					end
					
				end							
				--make sure landing gear is retracted, since all planes should be spawned in the air with an NPC
				SetVehicleLandingGear(Config.Missions[input].Vehicles[i].id, 3) 
				

				if AircraftEvent and not Config.Missions[input].Vehicles[i].faceplayer then 
					SetEntityHeading(Config.Missions[input].Vehicles[i].id,Config.Missions[input].Vehicles[i].heading)
				end
				
			end	

			local aircraft = false
			
			if (IsThisModelAPlane(pmodel) or IsThisModelAHeli(pmodel)) and Config.Missions[input].Vehicles[i].driving then 
				aircraft = true
				if IsThisModelAPlane(pmodel) and tostring(pmodel) ~= '970385471' then --treat hydra like heli
					SetVehicleForwardSpeed(Config.Missions[input].Vehicles[i].id, 60.0)
				end 
				SetHeliBladesFullSpeed(Config.Missions[input].Vehicles[i].id) -- works for planes I guess
				SetVehicleEngineOn(Config.Missions[input].Vehicles[i].id, true, true, false)			
			end
			
			if Config.Missions[input].Vehicles[i].id2 then
				local movespeed = GetVehicleMaxSpeed(pmodel) --1200.0 --default is fast
				--if Config.Missions[input].Vehicles[i] then
					if Config.Missions[input].Vehicles[i].movespeed ~= nil then
					 movespeed = Config.Missions[input].Vehicles[i].movespeed
					end		
				--end
				
				if EventName and EventName=="VehicleEvent" then 
					
					if not Config.Missions[input].Vehicles[i].faceplayer then 
						SetEntityHeading(Config.Missions[input].Vehicles[i].id,Config.Missions[input].Vehicles[i].heading)
					else
						makeEntityFaceEntity(Config.Missions[input].Vehicles[i].id,GetPlayerPed(-1))
					end									
					TargetPed = TargetIsDefendtargetPed(Config.Missions[input].Vehicles[i].id2) 
					--print("TargetPed:"..tostring(TargetPed))
					ptable = GetPlayers()
					for _, k in ipairs(ptable) do
						RegisterTarget(Config.Missions[input].Vehicles[i].id2,GetPlayerPed(k))
					end									
					TaskCombatHatedTargetsAroundPed(Config.Missions[input].Vehicles[i].id2,1000.0)
						
				
				end
					--print("made it3")
				if (Config.Missions[input].VehicleGotoMissionTarget or  
				Config.Missions[input].VehicleGotoMissionTargetPed or
				Config.Missions[input].VehicleGotoMissionTargetVehicle
				) and Config.Missions[input].Vehicles[i].VehicleGotoMissionTarget then 
							local TargetMissionVehicle 
							
							--print("made it")
							TargetMissionVehicle = Config.Missions[input].VehicleGotoMissionTarget
							--VehicleGotoMissionTargetPed or VehicleGotoMissionTargetVehicle
							--are the ids of the Ped of vehicle that needs to be targetted. 
							--So the vehicle doing the targetting should be a larger "i" 
							--than the vehicle being targetted.
							local dotargetped
							if Config.Missions[input].VehicleGotoMissionTargetPed then 
								local j = Config.Missions[input].VehicleGotoMissionTargetPed
								TargetMissionVehicle = Config.Missions[input].Peds[j].id
								dotargetped = true
							elseif Config.Missions[input].VehicleGotoMissionTargetVehicle then 
								local j = Config.Missions[input].VehicleGotoMissionTargetVehicle
								TargetMissionVehicle = Config.Missions[input].Vehicles[j].id
								--print("made it2")
								dotargetped = false
							end
							
							
							if IsThisModelAPlane(pmodel) then 
								--print("hey")
								
							
								SetVehicleForwardSpeed(Config.Missions[input].Vehicles[i].id,movespeed)
								SetHeliBladesFullSpeed(Config.Missions[input].Vehicles[i].id) -- works for planes I guess
								SetVehicleEngineOn(Config.Missions[input].Vehicles[i].id, true, true, false)			
								TaskPlaneChase(Config.Missions[input].Vehicles[i].id2,TargetMissionVehicle,0.0, 0.0, 5.0)			
								
								--TaskPlaneMission(Config.Missions[input].Vehicles[i].id2,Config.Missions[input].Vehicles[i].id,TargetPedVehicle,0,0,0,0,6,
								--0.0,0.0,0.0,2500.0, -1500.0)								
								--TaskCombatPed(Config.Missions[input].Vehicles[i].id2,TargetPed,0, 16)
							elseif IsThisModelABoat(pmodel) then
								
								TaskBoatMission(Config.Missions[input].Vehicles[i].id2,Config.Missions[input].Vehicles[i].id, 0, 0, 
										Config.Missions[input].VehicleGotoMissionTargetCoords.x, 
										Config.Missions[input].VehicleGotoMissionTargetCoords.y, 
										Config.Missions[input].VehicleGotoMissionTargetCoords.z,
										4, movespeed, 0, -1.0, 7)
							
							
							elseif IsThisModelAHeli(pmodel) then
								--print("made it")
								--ClearPedTasks(Config.Missions[input].Vehicles[i].id2)
								SetVehicleForwardSpeed(Config.Missions[input].Vehicles[i].id,60.0)
								SetHeliBladesFullSpeed(Config.Missions[input].Vehicles[i].id) -- works for planes I guess
								SetVehicleEngineOn(Config.Missions[input].Vehicles[i].id, true, true, false)
								
								if not dotargetped then 
									
									TaskHeliMission(Config.Missions[input].Vehicles[i].id2,Config.Missions[input].Vehicles[i].id,TargetMissionVehicle,0,0.0,0.0,0.0,9,movespeed,0.0,1.0, -1, -1, -1, 0)
								
								else 
									TaskHeliChase(Config.Missions[input].Vehicles[i].id2,TargetMissionVehicle,0.0, 0.0, 5.0)
								end
								--TaskCombatPed(Config.Missions[input].Vehicles[i].id2,TargetPed,0, 16)
							else
								if TargetMissionVehicle then 
								--print("2")
									if not dotargetped then
										--print("3")
										TargetMissionVehicle = GetPedInVehicleSeat(TargetMissionVehicle,-1)
									end

									if TargetMissionVehicle and not dotargetped then 
										TaskVehicleMissionPedTarget(Config.Missions[input].Vehicles[i].id2,Config.Missions[input].Vehicles[i].id,TargetMissionVehicle,7, movespeed, 0, 300.0, 15.0, 1)
									else 
										--TaskVehicleMissionCoorsTarget()
										local _, sequence = OpenSequenceTask(0)
										
										TaskEnterVehicle( 0,  Config.Missions[input].Vehicles[i].id, 20000,-1, 1.5, 1, 0)
										--TaskVehicleChase(0, TargetPed)
										
										--if IsThisModelAHeli(pmodel) then 
											--TaskHeliChase(0,TargetPedVehicle,0.0, 0.0, 5.0)
										--else 
										TaskVehicleEscort(0, Config.Missions[input].Vehicles[i].id, TargetMissionVehiclee, 0, movespeed, 0, 5.0, -1, 2000)						
										--end

										--TaskCombatPed(0,TargetPed,0, 16)
									
										--TaskVehicleShootAtPed(0,TargetPed,100.0)							
										
										--RegisterTarget(Config.Missions[input].Peds[i].id, TargetPed)
										
										--TaskCombatPed(0, TargetPed, 0, 16)
										--next line was needed in this case:
										SetSequenceToRepeat(sequence, 1)
										CloseSequenceTask(sequence)
										ClearPedTasks(Config.Missions[input].Vehicles[i].id2)
										ClearPedTasksImmediately(Config.Missions[input].Vehicles[i].id2)

												
										TaskPerformSequence(Config.Missions[input].Vehicles[i].id2, sequence)
										ClearSequenceTask(sequence)													
									
									
									end 
								end				
							
							end 				
				
				
				
				elseif Config.Missions[input].Vehicles[i].driving then
					--print("TASK DRIVE WANDER:"..movespeed)
					if not AircraftEvent then

					--print("TASK DRIVE WANDER:"..movespeed)
						if (aircraft and not (Config.Missions[input].Vehicles[i].conqueror or Config.Missions[input].Vehicles[i].SetBlockingOfNonTemporaryEvents)) then 
							TaskCombatHatedTargetsAroundPed(Config.Missions[input].Vehicles[i].id2,12000.0)
						else 					
							TaskVehicleDriveWander(Config.Missions[input].Vehicles[i].id2, GetVehiclePedIsIn(Config.Missions[input].Vehicles[i].id2, false), movespeed, 0)
						end
					--[[elseif AircraftEvent and IsThisModelAPlane(pmodel) then 
						--print("plane mission")
						TaskPlaneMission(Config.Missions[input].Vehicles[i].id2,Config.Missions[input].Vehicles[i].id,0, 0, Config.Missions[input].Vehicles[i].x,Config.Missions[input].Vehicles[i].y, Config.Missions[input].Vehicles[i].z, 9, 0.0, 0.0, 0.0, 3000.0, 200.0) 						
					elseif AircraftEvent and IsThisModelAHeli(pmodel) then 
						--print("heli mission")
						TaskHeliMission(Config.Missions[input].Vehicles[i].id2, Config.Missions[input].Vehicles[i].id, 0, 0, Config.Missions[input].Vehicles[i].x,Config.Missions[input].Vehicles[i].y, Config.Missions[input].Vehicles[i].z, 4, 1.0, -1.0, -1.0, 10, 10, 5.0, 0)		
					]]--
					elseif AircraftEvent then 
						--print("heli mission")
						TaskCombatHatedTargetsAroundPed(Config.Missions[input].Vehicles[i].id2,1000.0)
						--TaskVehicleDriveWander(Config.Missions[input].Vehicles[i].id2, GetVehiclePedIsIn(Config.Missions[input].Vehicles[i].id2, false), movespeed, 0)
					end
				
				elseif Config.Missions[input].Vehicles[i].movetocoord then 
					TaskVehicleDriveToCoordLongrange(Config.Missions[input].Vehicles[i].id2, Config.Missions[input].Vehicles[i].id, Config.Missions[input].Vehicles[i].movetocoord.x, Config.Missions[input].Vehicles[i].movetocoord.y,  Config.Missions[input].Vehicles[i].movetocoord.z, movespeed, 0, 5.0) --drive mode is zero
					SetPedKeepTask(Config.Missions[input].Vehicles[i].id2,true) 
				elseif (Config.Missions[input].IsDefend and DoIsDefendBehavior) and not Config.Missions[input].Vehicles[i].isAircraft then 
					--print("MADE IT")
					if Config.Missions[input].IsDefendTarget then 
						if TargetPed ==nil then
							print("NIL TargetPed for IsDefendTarget")
						end
						
						if(Config.Missions[input].IsVehicleDefendTargetChase) then

							if IsThisModelAPlane(pmodel) then 
								--print("hey")
								SetVehicleForwardSpeed(Config.Missions[input].Vehicles[i].id,movespeed)
								SetHeliBladesFullSpeed(Config.Missions[input].Vehicles[i].id) -- works for planes I guess
								SetVehicleEngineOn(Config.Missions[input].Vehicles[i].id, true, true, false)			
								if not Config.Missions[input].IsDefendTargetDoPlaneMission then 
									--print("hey1")
									TaskPlaneChase(Config.Missions[input].Vehicles[i].id2,TargetPedVehicle,0.0, 0.0, 5.0)
									
								else 
								--print("hey2")
									TaskPlaneMission(Config.Missions[input].Vehicles[i].id2,Config.Missions[input].Vehicles[i].id,TargetPedVehicle,0,0,0,0,6,
								0.0,0.0,0.0,2500.0, -1500.0)
								
								end
							
								
								
								
							elseif IsThisModelABoat(pmodel) then									
								--TaskCombatPed(Config.Missions[input].Vehicles[i].id2,TargetPed,0, 16)
								--print("hey")
								TaskVehicleMissionPedTarget(Config.Missions[input].Vehicles[i].id2,PedVehicle,TargetPed,7, movespeed, 0, 300.0, 15.0, 1)								
								
							elseif IsThisModelAHeli(pmodel) then
								--print("made it")
								--ClearPedTasks(Config.Missions[input].Vehicles[i].id2)
								SetVehicleForwardSpeed(Config.Missions[input].Vehicles[i].id,60.0)
								SetHeliBladesFullSpeed(Config.Missions[input].Vehicles[i].id) -- works for planes I guess
								SetVehicleEngineOn(Config.Missions[input].Vehicles[i].id, true, true, false)										
								
								--TaskHeliChase(Config.Missions[input].Vehicles[i].id2,TargetPedVehicle,0.0, 0.0, 5.0)
								
								TaskHeliMission(Config.Missions[input].Vehicles[i].id2,Config.Missions[input].Vehicles[i].id,TargetPedVehicle,0,0.0,0.0,0.0,9,movespeed,0.0,1.0, -1, -1, -1, 0)								
								
								--TaskCombatPed(Config.Missions[input].Vehicles[i].id2,TargetPed,0, 16)
							else
								
								local _, sequence = OpenSequenceTask(0)
								
								TaskEnterVehicle( 0,  Config.Missions[input].Vehicles[i].id, 20000,-1, 1.5, 1, 0)
								
								TaskVehicleEscort(0, Config.Missions[input].Vehicles[i].id, TargetPedVehicle, 0, movespeed, 0, 5.0, -1, 2000)						
								--end

								TaskCombatPed(0,TargetPed,0, 16)
							
								
								--next line was needed in this case:
								SetSequenceToRepeat(sequence, 1)
								CloseSequenceTask(sequence)
								ClearPedTasks(Config.Missions[input].Vehicles[i].id2)
								ClearPedTasksImmediately(Config.Missions[input].Vehicles[i].id2)

										
								TaskPerformSequence(Config.Missions[input].Vehicles[i].id2, sequence)
								ClearSequenceTask(sequence)	
										
								--TaskVehicleMissionPedTarget(Config.Missions[input].Vehicles[i].id2,Config.Missions[input].Vehicles[i].id2,TargetPed,7, movespeed, 0, 300.0, 15.0, 1)								
							
							end 						

							
							
							
						end
						
						if (not Config.Missions[input].IsVehicleDefendTargetChase) and (Config.Missions[input].IsVehicleDefendTargetGotoBlip) then
							TaskVehicleDriveToCoordLongrange(Config.Missions[input].Vehicles[i].id2, Config.Missions[input].Vehicles[i].id, Config.Missions[input].Blip.Position.x, Config.Missions[input].Blip.Position.y,Config.Missions[input].Blip.Position.z, movespeed, 0, 0.0) --drive mode is zero
							SetPedKeepTask(Config.Missions[input].Vehicles[i].id2,true) 
							
							--print('hey')		
	
						end	
									
						
					else				
					
						TaskVehicleDriveToCoordLongrange(Config.Missions[input].Vehicles[i].id2, Config.Missions[input].Vehicles[i].id, Config.Missions[input].Marker.Position.x, Config.Missions[input].Marker.Position.y,Config.Missions[input].Marker.Position.z, movespeed, 0, 0.0) --drive mode is zero
						SetPedKeepTask(Config.Missions[input].Vehicles[i].id2,true) 		
					end
					--TaskVehicleFollow(Config.Missions[input].Vehicles[i].id2, GetVehiclePedIsIn(Config.Missions[input].Vehicles[i].id2, false), GetPlayerPed(-1), 0, 20.0, 5)
				
				end
				
			else 
				--no NPC in it, a Player vehicle, so if isboat=true, then anchor it
				if Config.Missions[input].Vehicles[i] and Config.Missions[input].Vehicles[i].isboat then
					SetBoatAnchor(Config.Missions[input].Vehicles[i],true)
				end
	
			end
			
			
			--SetPedIntoVehicle(Config.Missions[input].Peds[1].id, Config.Missions[input].Vehicles[i].id, -2)
			--ped = AddBlipForEntity(Config.Missions[input].Vehicles[i].id)
			--Add blip to actual ped, not vehicles
			--local ped = AddBlipForEntity(Config.Missions[input].Vehicles[i].id2)
			--target=true --<----??????
			--local Size     = 0.9
			--SetBlipScale(ped, Size)
			--SetBlipAsShortRange(ped, false)
			--blip = GetBlipFromEntity(ped)
			--SetBlipSprite(blip, 58)
			if Config.Missions[input].Vehicles[i].friendly then
				--SetBlipSprite(ped, 280)
			--	SetBlipColour(ped, 2)
				DecorSetInt(Config.Missions[input].Vehicles[i].id2,"mrppedfriend",i)
			--if getMissionConfigProperty(input, "Type") == "HostageRescue"  and not Config.Missions[input].Peds[i].dead then
				--isHostageRescueCount = isHostageRescueCount + 1
			--end				
			--	BeginTextCommandSetBlipName("STRING")
			--	AddTextComponentString("Friend ($-"..getHostageKillPenalty(input)..")")
			--	EndTextCommandSetBlipName(ped)				        
			elseif Config.Missions[input].Vehicles[i].target then --if ped is a target in assassinate
				--SetBlipColour(ped, 66)
				--SetBlipSprite(ped, 433)
			--	SetBlipColour(ped, 27)
				DecorSetInt(Config.Missions[input].Vehicles[i].id2,"mrppedtarget",i)
			--	BeginTextCommandSetBlipName("STRING")
			--	AddTextComponentString("Target ($"..getTargetKillReward(input)..")")
			--	EndTextCommandSetBlipName(ped)						
			else
			--	SetBlipColour(ped, 1)
			--	BeginTextCommandSetBlipName("STRING")
			--	AddTextComponentString("Enemy ($"..getKillReward(input)..")")
			--	EndTextCommandSetBlipName(ped)							
			
			end	

			if Config.Missions[input].Vehicles[i].armor then --if ped has armor
				AddArmourToPed(Config.Missions[input].Vehicles[i].id2, Config.Missions[input].Vehicles[i].armor)
				SetPedArmour(Config.Missions[input].Vehicles[i].id2, Config.Missions[input].Vehicles[i].armor)
			end						
			
			SetAiWeaponDamageModifier(1.0) -- 1.0 == Normal Damage. 
			-- ^ Sets Custom NPC Damage. ^
				--Now check if Vehicle has turrets and fill those positions...
				--SHOULD THIS EVEN BE CALLED IN SPAWNPEDS?, since ExtraPeds attribute can define this
			
			if Config.Missions[input].Vehicles[i].id2 ~=nil and not Config.Missions[input].Vehicles[i].noFill then 
				--only add peds to turrets if an id2 NPC driver
				PutPedsIntoTurrets(Config.Missions[input].Vehicles[i].id,Config.Missions[input].Vehicles[i].Vehicle,Config.Missions[input].Vehicles[i].modelHash,Config.Missions[input].Vehicles[i].Weapon,Config.Missions[input].Type,firingpatterns.turretfiringpattern,input,i)
			end	
		else 
			--print("MADE IT SPAWN PED VEH")
			--no NPC driver, so must be a vehicle for the player, add a safehouse var to it. 
			DecorSetInt(Config.Missions[input].Vehicles[i].id,"mrpvehsafehouse",i)
										
		end
   end
   
	if getMissionConfigProperty(input, "Type") == "HostageRescue" and getMissionConfigProperty(input, "IsRandom") then
		--print("IsRandomMissionHostageCount"..IsRandomMissionHostageCount)
		isHostageRescueCount = IsRandomMissionHostageCount
		TriggerServerEvent("sv:IsRandomMissionHostageCount",IsRandomMissionHostageCount)
	end   
   
	--SPAWN SAFE HOUSE PEDS TOO
	--if getMissionConfigProperty(input, "UseSafeHouse") then
		--SpawnSafeHouseProps(input,rIndex,IsRandomSpawnAnywhereInfo) 
	--end
	PedsSpawned = 1
    --aliveCheck()
end


----FUNCTIONS


--Now in missions.lua
--[[local VehicleTurretSeatIds = {
	apc = {0},
	barrage = {1,2},
	halftrack = {1},
	dune3 = {0},
	insurgent = {7},
	insurgent3 = {7},
	technical = {1},
	technical2 = {1},
	technical3 = {1},
	limo2 = {3}
}
]]--




--checks if vehicle has a turret, how many, then puts 
--peds into them
--**vehicle does not require turret, can be used to add any type of passenger**
function PutPedsIntoTurrets(PedVehicle,vehicleHash,modelHash,weaponHash,MissionType,firingPattern,MissionName,vi)
	
	--local modelHash = modelHash
	if getMissionConfigProperty(MissionName, "VehicleTurretSeatIds")[vehicleHash] then 
		local VehicleTurretSeatIds = getMissionConfigProperty(MissionName, "VehicleTurretSeatIds")
		for i, v in pairs(VehicleTurretSeatIds[vehicleHash]) do
		
			--[[
			if (getMissionConfigProperty(MissionName, "IsRandom")) then 
				modelHash = getMissionConfigProperty(MissionName, "RandomMissionPeds")[math.random(1, #getMissionConfigProperty(MissionName, "RandomMissionPeds"))]
				--print(modelHash)
			end
		]]--
		
			--in SpawnPeds event, ExtraPeds might have these seats full
			--Should this function even be called in SpawnPeds, since ExtraPeds
			--can do this, and its more specific. 
			if modelHash ~=nil and IsVehicleSeatFree(PedVehicle, v) then 
				--print("found seat:"..v)
				local Ped
				local coords = GetEntityCoords(vehicle)
				while not HasModelLoaded(modelHash)  do
					Wait(1)
				end
				
				Ped = CreatePed(2, modelHash, coords.x, coords.y,coords.z, 180.0, true, true)
				SetModelAsNoLongerNeeded(modelHash)
				SetEntityAsMissionEntity(Ped,true,true)
				
				--Stop AI from blowing themselves up!
				--SetEntityCanBeDamagedByRelationshipGroup(Ped, false, GetHashKey("HATES_PLAYER"))
				--SetEntityCanBeDamagedByRelationshipGroup(Ped, false, GetHashKey("TRUENEUTRAL"))
			if not getMissionConfigProperty(MissionName,"IsDefendTarget") or (getMissionConfigProperty(MissionName,"IsDefendTarget") and getMissionConfigProperty(MissionName,"IsDefendTargetOnlyPlayersDamagePeds") ) then
				--Stop AI from blowing themselves up!
				SetEntityOnlyDamagedByPlayer(Ped, true) 
			end
			
			if getMissionConfigProperty(MissionName,"MissionDoBackup") then
				SetEntityOnlyDamagedByPlayer(Ped, false) 
				SetEntityCanBeDamagedByRelationshipGroup(Ped,false,"HATES_PLAYER")
				SetEntityCanBeDamagedByRelationshipGroup(Ped,true,"PLAYER")
				SetEntityCanBeDamagedByRelationshipGroup(Ped,true,"ISDEFENDTARGET")
			end	
				SetPedAccuracy(Ped,math.random(getMissionConfigProperty(MissionName, "SetPedMinAccuracy"),getMissionConfigProperty(MissionName, "SetPedMaxAccuracy")))
				--if DoesEntityExist(PedVehicle) then 
					--print("spawned:"..modelHash)
				--end
				
				if(modelHash  == "s_m_m_movalien_01") then
					SetPedDefaultComponentVariation(Ped) --GHK for s_m_m_movalien_01
				end
				 
				--keep this as mrpvpedid ,AI does not act correct if set to mrppedid
				DecorSetInt(Ped,"mrpvpedid",1) --**Should not matter what value, as long as we set one**
				--DecorSetInt(Ped,"mrppedid",1)
				
				--if not Config.Missions[input].Vehicles[i].friendly then
					
				SetPedRelationshipGroupHash(Ped, GetHashKey("HATES_PLAYER"))
				--SetPedRelationshipGroupHash(Ped, GetHashKey("TRUENEUTRAL"))
				SetRelationshipBetweenGroups(5, GetHashKey("HATES_PLAYER"), GetHashKey("PLAYER"))
				SetRelationshipBetweenGroups(0, GetHashKey("HATES_PLAYER"), GetHashKey("HATES_PLAYER"))
				SetRelationshipBetweenGroups(5, GetHashKey("TRUENEUTRAL"), GetHashKey("ISDEFENDTARGET"))	
				SetRelationshipBetweenGroups(5, GetHashKey("HATES_PLAYER"), GetHashKey("ISDEFENDTARGET"))
				SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("HATES_PLAYER"))	
				SetRelationshipBetweenGroups(0, GetHashKey("HATES_PLAYER"), GetHashKey("TRUENEUTRAL"))
				SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("TRUENEUTRAL"))
				
				if MissionType == "Assassination" then 
						--50% chance to flee
					if math.random(2) > 1  then --flee
					--No fleeing for turret guys
						--SetPedFleeAttributes(Ped, 0, 0)
						--SetPedCombatAttributes(Ped, 16, true)
						--SetPedCombatAttributes(Ped, 46, true)
						--SetPedCombatAttributes(Ped, 26, true)
					else
					SetPedFleeAttributes(Ped, 0, 0)
					--SetPedCombatAttributes(Ped, 3, false)
					SetPedCombatAttributes(Ped, 16, true)
					SetPedCombatAttributes(Ped, 46, true)
					SetPedCombatAttributes(Ped, 26, true)
										
				
					end 
					
				else 
					SetPedFleeAttributes(Ped, 0, 0)
					--SetPedCombatAttributes(Ped, 3, false)
					SetPedCombatAttributes(Ped, 16, true)
					SetPedCombatAttributes(Ped, 46, true)
					SetPedCombatAttributes(Ped, 26, true)
					
				end			
				
				SetPedCombatAttributes(Ped, 3, false)
				SetPedCombatAttributes(Ped, 2, true)
				--SetPedCombatAttributes(Ped, 0, true);
				SetPedCombatAttributes(Ped, 1, true) --can use vehicles		
				
				 SetPedSeeingRange(Ped, 10000.0)
				 SetPedHearingRange(Ped, 10000.0)		
				
				SetPedDropsWeaponsWhenDead(Ped, getMissionConfigProperty(MissionName, "SetPedDropsWeaponsWhenDead"))
				SetPedDiesWhenInjured(Ped, true)
				
				--GIVE WEAPONS TO PED turret guys?
				--print("weaponHash"..weaponHash)
				
				if getMissionConfigProperty(MissionName, "RandomizePassengerWeapons") then
					--override for boats,bikes and quads...
					local pmodel = GetEntityModel(PedVehicle)

					weaponHash = getMissionConfigProperty(MissionName, "RandomMissionVehicleWeapons")[math.random(1, #getMissionConfigProperty(MissionName, "RandomMissionVehicleWeapons"))]
					
					if IsThisModelABike(pmodel) or IsThisModelABicycle(pmodel) or IsThisModelAQuadbike(pmodel) or  IsThisModelABoat(pmodel) then
							weaponHash = getMissionConfigProperty(MissionName, "RandomMissionBikeQuadBoatWeapons")[math.random(1, #getMissionConfigProperty(MissionName, "RandomMissionBikeQuadBoatWeapons"))]
							--print("weaponHash"..weaponHash)
					end
					
				end
				
				GiveWeaponToPed(Ped, weaponHash, 2800, false, true)
				SetPedInfiniteAmmo(Ped, true, weaponHash)
				SetPedAlertness(Ped,3)
				ResetAiWeaponDamageModifier()
				
				--**HERE IS WHERE THE TURRET GUY SITS**
				SetPedIntoVehicle(Ped, PedVehicle, v)
				
				--Add blip to actual ped, not vehicles
				--local pedb = AddBlipForEntity(Ped)
				--target=true --<----??????
				--local Size     = 0.9
				--SetBlipScale(pedb, Size)
				--SetBlipAsShortRange(pedb, false)
				
				spawnFriendly =false --no friendly turret guys
				if spawnFriendly then --disabled
					--SetBlipSprite(pedb, 280)
				--	SetBlipColour(pedb, 2)
					--give a buffer for their own unique ids (hack):
					DecorSetInt(Ped,"mrppedfriend",(tonumber(tostring(7)..tostring(vi)..tostring(i))))			
				--	BeginTextCommandSetBlipName("STRING")
				--	AddTextComponentString("Friend ($-"..getHostageKillPenalty(input)..")")
				--	EndTextCommandSetBlipName(pedb)				        
				elseif MissionType=="Assassinate" then --if ped is a target in assassinate
					--SetBlipColour(ped, 66)
					--SetBlipSprite(pedb, 433)
				--	SetBlipColour(pedb, 27)
					--give a buffer for their own unique ids (hack):
					--print("made:"..(tonumber(tostring(3)..tostring(vi)..tostring(i))))
					DecorSetInt(Ped,"mrppedtarget",(tonumber(tostring(3)..tostring(vi)..tostring(i))))
					--BeginTextCommandSetBlipName("STRING")
				--	AddTextComponentString("Target ($"..getTargetKillReward(input)..")")
				--	EndTextCommandSetBlipName(pedb)						
				else
					--SetBlipColour(pedb, 1)
					--BeginTextCommandSetBlipName("STRING")
					--AddTextComponentString("Enemy ($"..getKillReward(input)..")")
					--EndTextCommandSetBlipName(pedb)							
				
				end	

				--if Config.Missions[input].Vehicles[i].armor then --if ped has armor
					AddArmourToPed(Ped, 100)
					SetPedArmour(Ped, 100)
				--end						
				
				if firingPattern then 
					SetPedFiringPattern(Ped, firingPattern)
				end
				
				local vehicleModel = GetEntityModel(PedVehicle)
				if tostring(vehicleModel) =="-1600252419" and v == 0 then 
					--nerf valkyrie cannon?
					if getMissionConfigProperty(MissionName, "NerfValkyrieHelicopterCannon") then 
						SetPedFiringPattern(Ped,  0xE2CA3A71) --FIRING_PATTERN_SLOW_FIRE_TANK
					end 
				end
				
				--[[
				
				elseif tostring(vehicleModel) =="562680400" and v == 0 then 	
					--leave apc cannon as is?
					if getMissionConfigProperty(MissionName, "NerfAPCCannon") then 
						SetPedFiringPattern(Ped,  0xE2CA3A71) --FIRING_PATTERN_SLOW_FIRE_TANK
					end 
				else
					if not getMissionConfigProperty(MissionName, "NerfTurrets") then 
						SetPedFiringPattern(Ped, 0x914E786F) --FIRING_PATTERN_BURST_FIRE_HELI
					end
				end 
				]]--
				SetAiWeaponDamageModifier(1.0) -- 1.0 == Normal Damage. 
				-- ^ Sets Custom NPC Damage. ^
			end

		end
		
	else --then max out the vehicle with passengers. 
		
		local maxseatid = GetVehicleMaxNumberOfPassengers(PedVehicle) - 1
		--print(vehicleHash.."  maxseatid:"..maxseatid)
		
		for v = 0,maxseatid,1 
		do
			--print("vehicleseatid:"..v)
			
			
			--if(getMissionConfigProperty(MissionName, "IsRandom")) then 
				--modelHash = getMissionConfigProperty(MissionName, "RandomMissionPeds")[math.random(1, #getMissionConfigProperty(MissionName, "RandomMissionPeds"))]
			--end
			
			
			--in SpawnPeds event, ExtraPeds might have these seats full
			--Should this function even be called in SpawnPeds, since ExtraPeds
			--can do this, and its more specific. 
			if modelHash ~=nil and IsVehicleSeatFree(PedVehicle, v) then

				--print("found seat2")
				local Ped
				local coords = GetEntityCoords(vehicle)
				while not HasModelLoaded(modelHash) do
					Wait(1)
				end
				
				Ped = CreatePed(2, modelHash, coords.x, coords.y,coords.z, 180.0, true, true)
				SetModelAsNoLongerNeeded(modelHash)
				SetEntityAsMissionEntity(Ped,true,true)
				
				--Stop AI from blowing themselves up!
				--SetEntityCanBeDamagedByRelationshipGroup(Ped, false, GetHashKey("HATES_PLAYER"))
				--SetEntityCanBeDamagedByRelationshipGroup(Ped, false, GetHashKey("TRUENEUTRAL"))
				
				SetPedAccuracy(Ped,math.random(getMissionConfigProperty(MissionName, "SetPedMinAccuracy"),getMissionConfigProperty(MissionName, "SetPedMaxAccuracy")))
				if not getMissionConfigProperty(MissionName,"IsDefendTarget") or (getMissionConfigProperty(MissionName,"IsDefendTarget") and getMissionConfigProperty(MissionName,"IsDefendTargetOnlyPlayersDamagePeds") ) then
					--Stop AI from blowing themselves up!
					SetEntityOnlyDamagedByPlayer(Ped, true) 
				end
				
				if getMissionConfigProperty(MissionName,"MissionDoBackup") then
					SetEntityOnlyDamagedByPlayer(Ped, false) 
					SetEntityCanBeDamagedByRelationshipGroup(Ped,false,"HATES_PLAYER")
					SetEntityCanBeDamagedByRelationshipGroup(Ped,true,"PLAYER")
					SetEntityCanBeDamagedByRelationshipGroup(Ped,true,"ISDEFENDTARGET")
				end	
				if(modelHash  == "s_m_m_movalien_01") then
					SetPedDefaultComponentVariation(Ped) --GHK for s_m_m_movalien_01
				end
				 
				--keep this as mrpvpedid ,AI does not act correct if set to mrppedid
				DecorSetInt(Ped,"mrpvpedid",1) --**Should not matter what value, as long as we set one**
				--DecorSetInt(Ped,"mrppedid",1)
				
				--if not Config.Missions[input].Vehicles[i].friendly then
					
				SetPedRelationshipGroupHash(Ped, GetHashKey("HATES_PLAYER"))
				--SetPedRelationshipGroupHash(Ped, GetHashKey("TRUENEUTRAL"))
				SetRelationshipBetweenGroups(5, GetHashKey("HATES_PLAYER"), GetHashKey("PLAYER"))
				SetRelationshipBetweenGroups(0, GetHashKey("HATES_PLAYER"), GetHashKey("HATES_PLAYER"))
				SetRelationshipBetweenGroups(5, GetHashKey("TRUENEUTRAL"), GetHashKey("ISDEFENDTARGET"))	
				SetRelationshipBetweenGroups(5, GetHashKey("HATES_PLAYER"), GetHashKey("ISDEFENDTARGET"))
				SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("HATES_PLAYER"))	
				SetRelationshipBetweenGroups(0, GetHashKey("HATES_PLAYER"), GetHashKey("TRUENEUTRAL"))
				SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("TRUENEUTRAL"))
				
				if MissionType == "Assassination" then 
						--50% chance to flee
					if math.random(2) > 1  then --flee
					--No fleeing for turret guys
						--SetPedFleeAttributes(Ped, 0, 0)
						--SetPedCombatAttributes(Ped, 16, true)
						--SetPedCombatAttributes(Ped, 46, true)
						--SetPedCombatAttributes(Ped, 26, true)
					else
					SetPedFleeAttributes(Ped, 0, 0)
					--SetPedCombatAttributes(Ped, 3, false)
					SetPedCombatAttributes(Ped, 16, true)
					SetPedCombatAttributes(Ped, 46, true)
					SetPedCombatAttributes(Ped, 26, true)
										
				
					end 
					
				else 
					SetPedFleeAttributes(Ped, 0, 0)
					--SetPedCombatAttributes(Ped, 3, false)
					SetPedCombatAttributes(Ped, 16, true)
					SetPedCombatAttributes(Ped, 46, true)
					SetPedCombatAttributes(Ped, 26, true)
					
				end			
	
				SetPedCombatAttributes(Ped, 3, false);
				SetPedCombatAttributes(Ped, 2, true)
				--SetPedCombatAttributes(Ped, 0, true);
				SetPedCombatAttributes(Ped, 1, true) --can use vehicles		
				
				 SetPedSeeingRange(Ped, 10000.0)
				 SetPedHearingRange(Ped, 10000.0)		
				
				SetPedDropsWeaponsWhenDead(Ped, getMissionConfigProperty(MissionName, "SetPedDropsWeaponsWhenDead"))
				SetPedDiesWhenInjured(Ped, true)
				
				--GIVE WEAPONS TO PED turret guys?
				--print("weaponHash"..weaponHash)
				if getMissionConfigProperty(MissionName, "RandomizePassengerWeapons") then
					--override for boats,bikes and quads...
					local pmodel = GetEntityModel(PedVehicle)
					
					weaponHash = getMissionConfigProperty(MissionName, "RandomMissionVehicleWeapons")[math.random(1, #getMissionConfigProperty(MissionName, "RandomMissionVehicleWeapons"))]
					
					if IsThisModelABike(pmodel) or IsThisModelABicycle(pmodel) or IsThisModelAQuadbike(pmodel) or  IsThisModelABoat(pmodel) then
							weaponHash = getMissionConfigProperty(MissionName, "RandomMissionBikeQuadBoatWeapons")[math.random(1, #getMissionConfigProperty(MissionName, "RandomMissionBikeQuadBoatWeapons"))]
					end
					
				end				
				
				GiveWeaponToPed(Ped, weaponHash, 2800, false, true)
				SetPedInfiniteAmmo(Ped, true, weaponHash)
				SetPedAlertness(Ped,3)
				ResetAiWeaponDamageModifier()
				
				--**HERE IS WHERE THE TURRET GUY SITS**
				SetPedIntoVehicle(Ped, PedVehicle, v)
				
				--Add blip to actual ped, not vehicles
				--local pedb = AddBlipForEntity(Ped)
				--target=true --<----??????
				--local Size     = 0.9
				--SetBlipScale(pedb, Size)
				--SetBlipAsShortRange(pedb, false)
				
				spawnFriendly =false --no friendly turret guys
				if spawnFriendly then --disabled
					--SetBlipSprite(pedb, 280)
				--	SetBlipColour(pedb, 2)
					--give a buffer for their own unique ids (hack):
					DecorSetInt(Ped,"mrppedfriend",(tonumber(tostring(9)..tostring(vi)..tostring(v))))
				--	BeginTextCommandSetBlipName("STRING")
				--	AddTextComponentString("Friend ($-"..getHostageKillPenalty(input)..")")
				--	EndTextCommandSetBlipName(pedb)				        
				elseif MissionType=="Assassinate" then --if ped is a target in assassinate
					--SetBlipColour(ped, 66)
					--SetBlipSprite(pedb, 433)
				--	SetBlipColour(pedb, 27)
					--give a buffer for their own unique ids (hack):
					--print("made:"..(tonumber(tostring(5)..tostring(vi)..tostring(v))))
					DecorSetInt(Ped,"mrppedtarget",(tonumber(tostring(5)..tostring(vi)..tostring(v))))
					--BeginTextCommandSetBlipName("STRING")
				--	AddTextComponentString("Target ($"..getTargetKillReward(input)..")")
				--	EndTextCommandSetBlipName(pedb)						
				else
					--SetBlipColour(pedb, 1)
					--BeginTextCommandSetBlipName("STRING")
					--AddTextComponentString("Enemy ($"..getKillReward(input)..")")
					--EndTextCommandSetBlipName(pedb)							
				
				end	

				--if Config.Missions[input].Vehicles[i].armor then --if ped has armor
					AddArmourToPed(Ped, 100)
					SetPedArmour(Ped, 100)
				--end						
				
				if firingPattern then 
					SetPedFiringPattern(Ped, firingPattern)
				end
				
				
				local vehicleModel = GetEntityModel(PedVehicle)
				if tostring(vehicleModel) =="-1600252419" and v == 0 then 
					--nerf valkyrie cannon?
					if getMissionConfigProperty(MissionName, "NerfValkyrieHelicopterCannon") then 
						SetPedFiringPattern(Ped,  0xE2CA3A71) --FIRING_PATTERN_SLOW_FIRE_TANK
					end 
				end
				--[[
				elseif tostring(vehicleModel) =="562680400" and v == 0 then 	
					--leave apc cannon as is?
					if getMissionConfigProperty(MissionName, "NerfAPCCannon") then 
						SetPedFiringPattern(Ped,  0xE2CA3A71) --FIRING_PATTERN_SLOW_FIRE_TANK
					end 
				else
					if not getMissionConfigProperty(MissionName, "NerfTurrets") then 
						SetPedFiringPattern(Ped, 0x914E786F) --FIRING_PATTERN_BURST_FIRE_HELI
					end
				end 
				]]--
				SetAiWeaponDamageModifier(1.0) -- 1.0 == Normal Damage. 
				-- ^ Sets Custom NPC Damage. ^
			end
		end 
	
	end

end

--place player into the target's vehicle 
--first look for turrets, then non-turret seatids
--only place if the seatid is free
function PutPlayerIntoTargetVehicle(PedVehicle,input)
	--already in the vehicle
	if PedVehicle == GetVehiclePedIsIn(GetPlayerPed(-1),false) or getMissionConfigProperty(input, "IsDefendTargetVehiclePassengerRadius") <= 0 then 
		return
	end

	local coords = GetEntityCoords(GetPlayerPed(-1),true)
	local v = GetEntityCoords(PedVehicle,true)

	if GetDistanceBetweenCoords(coords.x,coords.y,coords.z, v.x, v.y, v.z, true) >  
	getMissionConfigProperty(input, "IsDefendTargetVehiclePassengerRadius")
	then
		Notify("~h~~r~You need to be within "..getMissionConfigProperty(input, "IsDefendTargetVehiclePassengerRadius").."m of the target's vehicle to enter")
		TriggerEvent("mt:missiontext2","~r~You need to be within "..getMissionConfigProperty(input, "IsDefendTargetVehiclePassengerRadius").."m of the target's vehicle to enter", 4000)
		Wait(3500)
		return
		
	end
	
	local maxseatid = GetVehicleMaxNumberOfPassengers(PedVehicle) - 1
		--print(vehicleHash.."  maxseatid:"..maxseatid)
	local setPed=false
	
		--if target is the passenger lets check driver's seat first
		if  getMissionConfigProperty(input, "IsDefendTargetPassenger")
		and IsVehicleSeatFree(PedVehicle, -1) then 
			SetPedIntoVehicle(GetPlayerPed(-1), PedVehicle, -1)
			setPed=true
					
			Notify("~h~~g~You moved to the target's vehicle as the driver")
			TriggerEvent("mt:missiontext2","~g~You moved to the target's vehicle as the driver", 4000)
			Wait(3500)
			return
		
		end
		
		--get override, like for apc gun, which is not a turret...
		local prefseat = getPreferrableSeatId(input,GetEntityModel(PedVehicle))
	
		if prefseat ~=nil and IsVehicleSeatFree(PedVehicle, prefseat) then
			SetPedIntoVehicle(GetPlayerPed(-1), PedVehicle, prefseat)
			setPed=true
			--print("prefseat:"..prefseat)
			Wait(3500)
			return 
		
		end		
		
		
		for v = -1,maxseatid,1 
		do
			--print("vehicleseatid:"..v)
			--look for turret seats first...IsTurretSeat...
			if  Citizen.InvokeNative(0xE33FFA906CE74880,PedVehicle, v) and IsVehicleSeatFree(PedVehicle, v) then
				SetPedIntoVehicle(GetPlayerPed(-1), PedVehicle, v)
				setPed=true
			
				Notify("~h~~g~You moved to a turret on the target's vehicle")
				TriggerEvent("mt:missiontext2","~g~You moved to a turret on the target's vehicle", 4000)
				Wait(3500)
				return 
			end
			
		end
		
		if not setPed then 
		
			for v = -1,maxseatid,1 
			do
				--print("vehicleseatid:"..v)
			
				if IsVehicleSeatFree(PedVehicle, v) then
					SetPedIntoVehicle(GetPlayerPed(-1), PedVehicle, v)
					setPed=true
					if v == -1 then 
						Notify("~h~~g~You moved to the target's vehicle as the driver")
						TriggerEvent("mt:missiontext2","~g~You moved to the target's vehicle as the driver", 4000)
					else 
						Notify("~h~~g~You moved to the target's vehicle as a passenger")
						TriggerEvent("mt:missiontext2","~g~You moved to the target's vehicle as a passenger", 4000)
					end 
				
					Wait(3500)
					return
				end
				
			end		
		
		end
		
		if not setPed then--print
			Notify("~h~~r~All seats are taken in the target's vehicle")
			TriggerEvent("mt:missiontext2","~r~All seats are taken in the target's vehicle", 4000)
			Wait(3500)
		end
		
		
		return setPed


end

function getFailedMessage(currentmission) 

	if Config.Missions[currentmission].FailedMessage ~= nil then
		return Config.Missions[currentmission].FailedMessage
	else
		return Config.FailedMessage
	end


end

function getMissionLength(currentmission) 

	if Config.Missions[currentmission].MissionLengthMinutes ~= nil then
		return Config.Missions[currentmission].MissionLengthMinutes
	else
		return Config.MissionLengthMinutes
	end


end


--Used only for a mission with IsRandom flag set to true
function SetRandomMissionAttributes(MissionName,rMissionType,locationInfo,IsRandomSpawnAnywhereInfo) --,rIsRandomSpawnAnywhereInfo) 
	
	
	Config.Missions[MissionName].Type = rMissionType
	
	if rMissionType	 == "Objective" then 
		Config.Missions[MissionName].MissionTitle = getMissionConfigProperty(MissionName, "MissionTitleObj")
		Config.Missions[MissionName].StartMessage = getMissionConfigProperty(MissionName, "StartMessageObj")
		Config.Missions[MissionName].FinishMessage = getMissionConfigProperty(MissionName, "FinishMessageObj")
		Config.Missions[MissionName].MissionMessage = getMissionConfigProperty(MissionName, "MissionMessageObj")	
		
		--allow random location overrides
		if not getMissionConfigProperty(MissionName, "IsRandomSpawnAnywhere") then
			if(locationInfo.MissionTitleObj) then 
				Config.Missions[MissionName].MissionTitle = locationInfo.MissionTitleObj
			end
			if(locationInfo.StartMessageObj) then 
				Config.Missions[MissionName].StartMessage = locationInfo.StartMessageObj
			end
			if(locationInfo.MissionMessageObj) then 
				Config.Missions[MissionName].MissionMessage = locationInfo.MissionMessageObj
			end	
		end
		
							

	elseif rMissionType	 == "Assassinate" then  
		Config.Missions[MissionName].MissionTitle = getMissionConfigProperty(MissionName, "MissionTitleAss")
		Config.Missions[MissionName].StartMessage = getMissionConfigProperty(MissionName, "StartMessageAss")
		Config.Missions[MissionName].FinishMessage = getMissionConfigProperty(MissionName, "FinishMessageAss")
		Config.Missions[MissionName].MissionMessage = getMissionConfigProperty(MissionName, "MissionMessageAss")	
		
		--allow random location overrides
		
		if not getMissionConfigProperty(MissionName, "IsRandomSpawnAnywhere") then
			if(locationInfo.MissionTitleAss) then 
				Config.Missions[MissionName].MissionTitle = locationInfo.MissionTitleAss
			end
			if(locationInfo.StartMessageAss) then 
				Config.Missions[MissionName].StartMessage = locationInfo.StartMessageAss
			end
			if(locationInfo.MissionMessageAss) then 
				Config.Missions[MissionName].MissionMessage = locationInfo.MissionMessageAss
			end	
		end
	end	
	
	--allow random location overrides
	if not getMissionConfigProperty(MissionName, "IsRandomSpawnAnywhere") then
		if(locationInfo.MissionTitle) then 
				Config.Missions[MissionName].MissionTitle = locationInfo.MissionTitle
		end
		if(locationInfo.StartMessage) then 
				Config.Missions[MissionName].StartMessage = locationInfo.StartMessage
		end
		if(locationInfo.MissionMessage) then 
				Config.Missions[MissionName].MissionMessage = locationInfo.MissionMessage
		end	
	end
	



end

-- Face entity1 to entity2 
function makeEntityFaceEntity( entity1, entity2 )
    local p1 = GetEntityCoords(entity1, true)
    local p2 = GetEntityCoords(entity2, true)

    local dx = p2.x - p1.x
    local dy = p2.y - p1.y

    local heading = GetHeadingFromVector_2d(dx, dy)
    SetEntityHeading( entity1, heading )
	
end

function getGoodSpawnSpot(pos)


		local ray = Citizen.InvokeNative( 0x377906D8A31E5586, vector3(pos.x, pos.y,pos.z) + vector3(0.0, 0.0, 1000.0), vector3(pos.x, pos.y,pos.z), 10, -1, 0)
			 --local ray = StartShapeTestRay(vector3(rXoffset, rYoffset, rZoffset) + vector3(0.0, 0.0, 500.0), vector3(rXoffset, rYoffset, rZoffset), -1, -1, 0)
		   -- local _, hit, impactCoords  = Citizen.InvokeNative( 0x3D87450E15D98694, ray,hit)
			local _, hit, impactCoords = GetRaycastResult(ray) --GetShapeTesResult(ray)
			
				-- print("HIT: " .. hit)
				-- print(("IMPACT COORDS: X = %.4f; Y = %.4f; Z = %.4f"):format(impactCoords.x, impactCoords.y, impactCoords.z))
				-- print("DISTANCE BETWEEN DROP AND IMPACT COORDS: " ..  #(vector3(dropCoords.x, dropCoords.y, dropCoords.z) - vector3(impactCoords)))
			if hit == 0 then --or (hit == 1 and #(vector3(pos.x, pos.y,pos.z) - vector3(impactCoords)) < 0.5) then -- ± 0.5 units
					--print("ROOFCHECK: success")
					raytestsuccess = true
			else
					--print("ROOFCHECK: fail")
					raytestsuccess = false
			   
			end

			return raytestsuccess

--[[
 local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, pos.x, pos.y, pos.z+100, 10,GetPlayerPed(-1), 0)
    local a, b, c, d, vehicleHandle = GetRaycastResult(rayHandle)

    if vehicleHandle ~= nil then
		--print('bad spot')
		return false
	else
		print('good spot')
		return true
    end
]]--

end


RegisterNetEvent("mt:playvoicesound")
AddEventHandler("mt:playvoicesound",function(decorid,decorval,greetspeech,voicename)
	--print(decorid..decorval..greetspeech..voicename)
	for ped in EnumeratePeds() do
		
			if DecorGetInt(ped, decorval) > 0 then
				if DecorGetInt(ped, decorval) == decorid then
					--print("made it")
					PlayAmbientSpeechWithVoice(ped, greetspeech, voicename, "SPEECH_PARAMS_STANDARD", false)
					break
				end
				
			end
	end



end)


RegisterNetEvent("mt:setgroundingdecor")
AddEventHandler("mt:setgroundingdecor",function(decorid,decorval)
	--print(decorid..decorval..greetspeech..voicename)
	
	if (decorval =="mrppedid" or decorval=="mrpvpedid") then
		for ped in EnumeratePeds() do
			
				if DecorGetInt(ped, decorval) > 0 then
					if DecorGetInt(ped, decorval) == decorid then
						DecorSetInt(ped,"mrpvehdidGround",0)
						FreezeEntityPosition(ped,false)
						--print("set mrppedid:"..DecorGetInt(ped, decorval))
						break
					end
				end
		end
	elseif decorval =="mrpvehdid" then
	
		for ped in EnumerateVehicles() do
			
				if DecorGetInt(ped, decorval) > 0 then
					if DecorGetInt(ped, decorval) == decorid then
						DecorSetInt(ped,"mrpvehdidGround",0)
						FreezeEntityPosition(ped,false)
						--print("set mrpvehdid:"..DecorGetInt(ped, decorval))
						break
					end
				end
		end	
	
	end



end)



RegisterNetEvent("SafeHouseAnims")
AddEventHandler("SafeHouseAnims",function(entD,entL,input)
	
	

		
	
	local PedDoctor = entD.ent
	local PedLeader = entL.ent
	local PedDoctorModelL = entD.model
	local PedLeaderModelL = entL.model
	
	if PedLeader and not getMissionConfigProperty(input, "SafeHouseDoAnimsAndGreetsLeader") then 
		return
	end 
	
	if PedDoctor and not getMissionConfigProperty(input, "SafeHouseDoAnimsAndGreetsDoctor") then 
		return
	end 
	
	while (PedDoctor or PedLeader)  do
    Citizen.Wait(0)
	
		--if PedDoctor or PedLeader then 
			
			RequestAnimDict("random@shop_gunstore")
			while (not HasAnimDictLoaded("random@shop_gunstore")) do 
				Citizen.Wait(0) 
			end
			
			
			local ply = GetPlayerPed(-1)
			local plyCoords = GetEntityCoords(ply, 0)
			
			if PedLeader and not PlayingAnimL then 
				local voicename 
				local greetspeech
				
				local doGreet = (math.random(1,100) <= getMissionConfigProperty(input, "SafeHousePedLeaderChanceToGreet"))
			
				
				
				if string.sub(string.lower(PedLeaderModelL),3,3) == 'f' or 
				getMissionConfigProperty(input, "SafeHouseLeaderForceFemale")
				then
					local index = math.random(1, #getMissionConfigProperty(input, "SafeHousePedFemaleLeaderVoiceNames"))
					voicename =  getMissionConfigProperty(input, "SafeHousePedFemaleLeaderVoiceNames")[index]
					greetspeech =  getMissionConfigProperty(input, "SafeHousePedFemaleLeaderGreetSpeech")[index]
				else
					local index = math.random(1, #getMissionConfigProperty(input, "SafeHousePedMaleLeaderVoiceNames"))
					voicename =  getMissionConfigProperty(input, "SafeHousePedMaleLeaderVoiceNames")[index]
						
					greetspeech =  getMissionConfigProperty(input, "SafeHousePedMaleLeaderGreetSpeech")[index]	
				end
				
				local ped = PedLeader
				local pcoords =  GetEntityCoords(ped, 0)
				
			
				distance = GetDistanceBetweenCoords(pcoords.x, pcoords.y, pcoords.z, GetEntityCoords(GetPlayerPed(-1)))
				if PlayingAnimL ~= true then
					
					 local anim = getMissionConfigProperty(input, "SafeHousePedLeaderAnims")[math.random(1, #getMissionConfigProperty(input, "SafeHousePedLeaderAnims"))]
					
					--TaskPlayAnim(ped,"random@shop_gunstore","_idle_b", 1.0, -1.0, -1, 0, 1, true, true, true)
					TaskStartScenarioInPlace(ped, anim, 0, true)
					Citizen.Wait(math.random(1000,6000))
					ClearPedTasks(ped)
					PlayingAnimL = true
					
					anim = getMissionConfigProperty(input, "SafeHousePedLeaderAnims")[math.random(1, #getMissionConfigProperty(input, "SafeHousePedLeaderAnims"))]
					TaskStartScenarioInPlace(ped, anim, 0, true)
					if doGreet then
							--TaskPlayAnim(ped,"random@shop_gunstore","_greeting", 1.0, -1.0, 4000, 0, 1, true, true, true)
							
							TriggerServerEvent("sv:playvoicesound",1,"mrppedsafehouse", greetspeech,voicename)
							--PlayAmbientSpeechWithVoice(ped, greetspeech, voicename, "SPEECH_PARAMS_STANDARD", false);
					end 					
					Citizen.Wait(4000)
					ClearPedTasks(ped)
					if PlayingAnimL == true then
						
						--TaskPlayAnim(ped,"random@shop_gunstore","_positive_b", 1.0, -1.0, -1, 0, 1, true, true, true)
						anim = getMissionConfigProperty(input, "SafeHousePedLeaderAnims")[math.random(1, #getMissionConfigProperty(input, "SafeHousePedLeaderAnims"))]
						TaskStartScenarioInPlace(ped, anim, 0, true)
						Citizen.Wait(math.random(1000,6000))
						ClearPedTasks(ped)
						
					end
				else
					--TaskPlayAnim(ped,"random@shop_gunstore","_impatient_b", 1.0, -1.0, -1, 0, 1, true, true, true)
				end
							
			end
			
			
			if PedDoctor and not PlayingAnimD then 
			
				local ped = PedDoctor
				local pcoords =  GetEntityCoords(ped, 0)

				local voicename 
				local greetspeech 
			
				local doGreet = (math.random(1,100) <= getMissionConfigProperty(input, "SafeHousePedDoctorChanceToGreet"))
				
				if string.sub(string.lower(PedDoctorModelL),3,3) == 'f' or 
				getMissionConfigProperty(input, "SafeHouseDoctorForceFemale")
				then
					local index = math.random(1, #getMissionConfigProperty(input, "SafeHousePedFemaleDoctorVoiceNames"))
					voicename =  getMissionConfigProperty(input, "SafeHousePedFemaleDoctorVoiceNames")[index]
					greetspeech =  getMissionConfigProperty(input, "SafeHousePedFemaleDoctorGreetSpeech")[index]
				else
					local index = math.random(1, #getMissionConfigProperty(input, "SafeHousePedMaleDoctorVoiceNames"))
					voicename =  getMissionConfigProperty(input, "SafeHousePedMaleDoctorVoiceNames")[index]
					greetspeech =  getMissionConfigProperty(input, "SafeHousePedMaleDoctorGreetSpeech")[index]
							
				end				
				
				
				
				
				distance = GetDistanceBetweenCoords(pcoords.x, pcoords.y, pcoords.z, GetEntityCoords(GetPlayerPed(-1)))
				if PlayingAnimD ~= true then
					--TaskPlayAnim(ped,"random@shop_gunstore","_impatient_a", 1.0, -1.0, -1, 0, 1, true, true, true)
					 local anim = getMissionConfigProperty(input, "SafeHousePedDoctorAnims")[math.random(1, #getMissionConfigProperty(input, "SafeHousePedDoctorAnims"))]
					 TaskStartScenarioInPlace(ped, anim, 0, true)
					
					Citizen.Wait(math.random(1000,6000))
					ClearPedTasks(ped)
					PlayingAnimD = true
					
					anim = getMissionConfigProperty(input, "SafeHousePedDoctorAnims")[math.random(1, #getMissionConfigProperty(input, "SafeHousePedDoctorAnims"))]
					TaskStartScenarioInPlace(ped, anim, 0, true)
					if doGreet then
						--TaskPlayAnim(ped,"random@shop_gunstore","_greeting", 1.0, -1.0, 4000, 0, 1, true, true, true)
						--PlayAmbientSpeechWithVoice(ped, greetspeech, voicename, "SPEECH_PARAMS_STANDARD", false);
						TriggerServerEvent("sv:playvoicesound",2,"mrppedsafehouse", greetspeech,voicename)
					end
					
					PlayingAnimD = true
					Citizen.Wait(4000)
					ClearPedTasks(ped)
					if PlayingAnimD == true  then
						
						
						--TaskPlayAnim(ped,"random@shop_gunstore","_positive_a", 1.0, -1.0, -1, 0, 1, true, true, true)
						
						anim = getMissionConfigProperty(input, "SafeHousePedDoctorAnims")[math.random(1, #getMissionConfigProperty(input, "SafeHousePedDoctorAnims"))]
						TaskStartScenarioInPlace(ped, anim, 0, true)						
						Citizen.Wait(math.random(1000,6000))
						ClearPedTasks(ped)
					end
				
				else
					--TaskPlayAnim(ped,"random@shop_gunstore","_impatient_a", 1.0, -1.0, -1, 0, 1, true, true, true)
				end
				
				
			end			
			
			Citizen.Wait(math.random(10000,30000))
		
		--end 
			--only want to run this once... lets break out
			--if PlayingAnimD and PlayingAnimL then
				--print("break")
				--break
			--end
			
			--reset to loop
			PlayingAnimD = false
			PlayingAnimL = false
		end 

end)


--[[
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
	
	
		RequestAnimDict("random@shop_gunstore")
		while (not HasAnimDictLoaded("random@shop_gunstore")) do 
			Citizen.Wait(0) 
		end
		
		local ply = GetPlayerPed(-1)
		local plyCoords = GetEntityCoords(ply, 0)
		local pcoords =  GetEntityCoords(ply, 0)
		
			distance = GetDistanceBetweenCoords(ShopClerk[i].x, ShopClerk[i].y, ShopClerk[i].z, GetEntityCoords(GetPlayerPed(-1)))
			if distance < 5.5 and PlayingAnim ~= true then
				TaskPlayAnim(ShopClerk[i].id,"random@shop_gunstore","_greeting", 1.0, -1.0, 4000, 0, 1, true, true, true)
				PlayingAnim = true
				Citizen.Wait(4000)
				if PlayingAnim == true then
					TaskPlayAnim(ShopClerk[i].id,"random@shop_gunstore","_idle_b", 1.0, -1.0, -1, 0, 1, true, true, true)
				end
			else
				TaskPlayAnim(ShopClerk[i].id,"random@shop_gunstore","_idle_b", 1.0, -1.0, -1, 0, 1, true, true, true)
			end
		
		
  end
end)
]]--

--Spawn Safe House Props
--Only for non IsRandom atm
function SpawnSafeHouseProps(input,rIndex,IsRandomSpawnAnywhereInfo) 

		local randomLocation
		local Prop
		local PedLeader
		local PedDoctor

		
		
		--if we have already spawned props at the mission launch. 
		if MissionSpawnedSafeHouseProps then
			
			return
		end
		--if(getMissionConfigProperty(MissionName, "IsRandomSpawnAnywhere")) then 
			--print("spawn random prop:"..IsRandomSpawnAnywhereInfo[1].x..","..IsRandomSpawnAnywhereInfo[1].y..","..IsRandomSpawnAnywhereInfo[1].z)
			--randomLocation = IsRandomSpawnAnywhereInfo[1]
		--else
			--if(getMissionConfigProperty(MissionName, "IsRandom")) then
				--randomLocation = getMissionConfigProperty(input, "RandomMissionPositions")[rIndex]
			--else

			randomLocation = Config.Missions[input].MarkerS.Position --{ x = -1828.32, y = -1218.22, z = 13.03 } --{ x = 302.75, y = 4374.07, z = 51.62, heading = 287.83 } -- Config.Missions[input].MarkerS.Position
			--end
			--print("SAFEHOUSE_X"..randomLocation.x)
		
		--end
		
		ClearAreaOfObjects(randomLocation.x, randomLocation.y, randomLocation.z, 10.0, 0)
		--ClearAreaOfVehicles(randomLocation.x, randomLocation.y, randomLocation.z, 1000.0, 0)
		local rHeading = roundToNthDecimal(math.random() + math.random(0,359),2)
		
		--spawn prop
		
		if #getMissionConfigProperty(input, "SafeHouseProps") > 0 then 
			local randomPropModelHash = getMissionConfigProperty(input, "SafeHouseProps")[math.random(1, #getMissionConfigProperty(input, "SafeHouseProps"))]		

			if randomPropModelHash then 		
				RequestModel(randomPropModelHash)
				while not HasModelLoaded(randomPropModelHash) do
					Wait(1)
				end
				
			
				Prop = CreateObject(randomPropModelHash,  randomLocation.x, randomLocation.y, randomLocation.z, true, false, true)

				SetModelAsNoLongerNeeded(randomPropModelHash)
				DecorSetInt(Prop,"mrppropid",1)
				DecorSetInt(Prop,"mrpsafehousepropid",1)
				SetEntityAsMissionEntity(Prop,true,true)
				--print("PROP SPAWNED: ID:"..Config.Missions[input].Props[1].id)
				SetEntityHeading(Prop,rHeading)
				SetEntityDynamic(Prop, true)
				SetEntityRecordsCollisions(Prop, true)
				SetEntityHasGravity(Prop, true)		
				--PlaceObjectOnGroundProperly(object)
				--add the san andreas map for garnish if using the defautl table.
				if randomPropModelHash == "v_ilev_liconftable_sml" then 
					RequestModel("hei_prop_dlc_heist_map")
					while not HasModelLoaded("hei_prop_dlc_heist_map")  do
						Wait(1)
					end
					local PropMap = CreateObject("hei_prop_dlc_heist_map",  randomLocation.x, randomLocation.y, randomLocation.z-0.25, true, false, true)
					SetModelAsNoLongerNeeded("hei_prop_dlc_heist_map")
					SetEntityRotation(PropMap,90.0,0.0,rHeading,true,true)

					DecorSetInt(PropMap,"mrppropid",2)
					DecorSetInt(PropMap,"mrpsafehousepropid",2)
					SetEntityAsMissionEntity(PropMap,true,true)
					--print("PROP SPAWNED: ID:"..Config.Missions[input].Props[1].id)
					SetEntityDynamic(PropMap, true)
					SetEntityRecordsCollisions(PropMap, true)
					SetEntityHasGravity(PropMap, true)		
					--PlaceObjectOnGroundProperly(object)				
				end			
				
			
			end
		end
		
			if #getMissionConfigProperty(input, "SafeHousePedLeaders")  > 0 then 
			--spawn leader
				randomPropModelHash = getMissionConfigProperty(input, "SafeHousePedLeaders")[math.random(1, #getMissionConfigProperty(input, "SafeHousePedLeaders"))]
				PedLeaderModel = randomPropModelHash
				local randomPedWeapon = getMissionConfigProperty(input, "SafeHousePedWeapons")[math.random(1, #getMissionConfigProperty(input, "SafeHousePedWeapons"))]
					
				if randomPropModelHash then 	
					RequestModel(randomPropModelHash)
					while not HasModelLoaded(randomPropModelHash)  do
						Wait(1)
					end
					
					local spawnRadius = (Config.Missions[input].MarkerS.Size.x/4)
					
					local yoffset = 1.0
					local xoffset = 1.0
					if math.random(1,2) > 1  then
						 yoffset = -1.0
					end 
					if math.random(1,2) > 1  then
						 xoffset = -1.0
					end 
					
					local rXoffset = randomLocation.x + (xoffset*spawnRadius)
					
					local rYoffset = randomLocation.y + (yoffset*spawnRadius)
					
					
					--lets forget about ground z checks, since they will be close to the center of the marker
					PedLeader = CreatePed(2, randomPropModelHash,  rXoffset, rYoffset, randomLocation.z, rHeading, true, true)
					SetModelAsNoLongerNeeded(randomPropModelHash)
					DecorSetInt(PedLeader,"mrppedsafehouse",1)
					DecorSetInt(PedLeader,"mrppedid",1)	
					SetPedPropIndex(PedLeader, 0, 0, 0, 2) --give him a hat
					SetPedFleeAttributes(PedLeader, 0, 0)
					SetEntityInvincible(PedLeader, true)
					GiveWeaponToPed(PedLeader, randomPedWeapon, 2800, false, true)
					makeEntityFaceEntity(PedLeader,Prop)
					TaskLookAtEntity(PedLeader,GetPlayerPed(-1),-1) 
					SetPedKeepTask(PedLeader,true) 
					
					
					SetPedRelationshipGroupHash(PedLeader, GetHashKey("SAFEHOUSE"))
					SetRelationshipBetweenGroups(1, GetHashKey("SAFEHOUSE"), GetHashKey("HATES_PLAYER"))
					SetRelationshipBetweenGroups(1, GetHashKey("HATES_PLAYER"), GetHashKey("SAFEHOUSE"))		
					SetRelationshipBetweenGroups(0, GetHashKey("SAFEHOUSE"), GetHashKey("PLAYER"))
					SetRelationshipBetweenGroups(0, GetHashKey("PLAYER"), GetHashKey("SAFEHOUSE"))
					SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("SAFEHOUSE"))
					SetRelationshipBetweenGroups(0, GetHashKey("SAFEHOUSE"), GetHashKey("TRUENEUTRAL"))	

			end		
				
			if #getMissionConfigProperty(input, "SafeHousePedDoctors")  > 0 then 
				--spawn doctor
				randomPropModelHash = getMissionConfigProperty(input, "SafeHousePedDoctors")[math.random(1, #getMissionConfigProperty(input, "SafeHousePedDoctors"))]
				randomPedWeapon = getMissionConfigProperty(input, "SafeHousePedWeapons")
				PedDoctorModel = randomPropModelHash
				RequestModel(randomPropModelHash)
				while not HasModelLoaded(randomPropModelHash)  do
					Wait(1)
				end
				
				local yoffset = 1.0
				local xoffset = 1.0
				if math.random(1,2) > 1  then
					 yoffset = -1.0
				end 
				if math.random(1,2) > 1  then
					 xoffset = -1.0
				end 
				
				spawnRadius = (Config.Missions[input].MarkerS.Size.x/4)
				rXoffset = randomLocation.x + (xoffset*spawnRadius)
				
				rYoffset = randomLocation.y + (yoffset*spawnRadius)
				
				
				--lets forget about ground z checks, since they will be close to the center of the marker
				PedDoctor = CreatePed(2, randomPropModelHash,  rXoffset, rYoffset, randomLocation.z, rHeading, true, true)
				SetModelAsNoLongerNeeded(randomPropModelHash)
				DecorSetInt(PedDoctor,"mrppedsafehouse",2)
				DecorSetInt(PedDoctor,"mrppedid",1)	
				SetPedFleeAttributes(PedDoctor, 0, 0)
				SetEntityInvincible(PedDoctor, true)
				--GiveWeaponToPed(PedDoctor, randomPedWeapon, 2800, false, true)
				makeEntityFaceEntity(PedDoctor,Prop)
				TaskLookAtEntity(PedDoctor,GetPlayerPed(-1),-1)
				SetPedKeepTask(PedDoctor,true) 
				
				SetPedRelationshipGroupHash(PedDoctor, GetHashKey("SAFEHOUSE"))
				SetRelationshipBetweenGroups(1, GetHashKey("SAFEHOUSE"), GetHashKey("HATES_PLAYER"))
				SetRelationshipBetweenGroups(1, GetHashKey("HATES_PLAYER"), GetHashKey("SAFEHOUSE"))		
				SetRelationshipBetweenGroups(0, GetHashKey("SAFEHOUSE"), GetHashKey("PLAYER"))
				SetRelationshipBetweenGroups(0, GetHashKey("PLAYER"), GetHashKey("SAFEHOUSE"))
				SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("SAFEHOUSE"))
				SetRelationshipBetweenGroups(0, GetHashKey("SAFEHOUSE"), GetHashKey("TRUENEUTRAL"))			
			
			end
			
		end
		
		if getMissionConfigProperty(input, "SafeHouseDoAnimsAndGreets") then
			TriggerEvent('SafeHouseAnims',{ent=PedDoctor,model=PedDoctorModel},{ent=nil,model=PedLeaderModel},input)
		
			TriggerEvent('SafeHouseAnims',{ent=nil,model=PedDoctorModel},{ent=PedLeader,model=PedLeaderModel},input)
		end
		
		--lets spawn vehicles now on both land and sea 
		--find flat open places to spawn 50.0 meter radius
		local NumVehicles = getMissionConfigProperty(input, "SafeHouseVehicleCount")
		local NumAircraft = getMissionConfigProperty(input, "SafeHouseAircraftCount")
		local NumBoat = getMissionConfigProperty(input, "SafeHouseBoatCount")
		local PedVehicle
		
		
		
		--Define a BlipSL to spawn vehicles and aicraft
		if (Config.Missions[input].BlipSL) then 
			 for i=1, NumVehicles do
				rHeading = roundToNthDecimal(math.random() + math.random(0,359),2)
				
				--spawn vehicle
				local randomPropModelHash = getMissionConfigProperty(input, "SafeHouseVehicles")[math.random(1, #getMissionConfigProperty(input, "SafeHouseVehicles"))]
				
				randomLocation = Config.Missions[input].BlipSL.Position
				local spawnRadius = 50
				
				--local goodspawn = false
				--local tries = 0
				--repeat
				
				rXoffset = randomLocation.x + roundToNthDecimal(math.random() + math.random(-1*spawnRadius,spawnRadius - 1),4)
					
				rYoffset = randomLocation.y + roundToNthDecimal(math.random() + math.random(-1*spawnRadius,spawnRadius - 1),4)
				
				rZoffset =  randomLocation.z
					
				--goodspawn = getGoodSpawnSpot(randomLocation)
				--tries  = tries  + 1
				--until( goodspawn == true or tries > 100)
				
				local vehiclehash = GetHashKey(randomPropModelHash)
				RequestModel(vehiclehash)
				while not HasModelLoaded(vehiclehash) do
					Wait(1)
				end			
				
				PedVehicle = CreateVehicle(randomPropModelHash, rXoffset, rYoffset, rZoffset,  rHeading, 1, 0)
				SetModelAsNoLongerNeeded(vehiclehash)
				SetEntityHeading(PedVehicle, rHeading) 
				SetEntityAsMissionEntity(PedVehicle,true,true)
				DecorSetInt(PedVehicle,"mrpvehdid",i)
				DecorSetInt(PedVehicle,"mrpvehsafehouse",i)
				
				if getMissionConfigProperty(input, "SafeHouseDoInvincibleVehicles") then
					SetEntityInvincible(PedVehicle,true)
				end 
				
				--stop player griefing
				SetEntityCanBeDamagedByRelationshipGroup(PedVehicle, false, GetHashKey("PLAYER"))
				Wait(1)
				doVehicleMods(randomPropModelHash,PedVehicle,input) 
				
			end
			
			 for i=1,  NumAircraft do
				rHeading = roundToNthDecimal(math.random() + math.random(0,359),2)
				
				--spawn aircraft
				local randomPropModelHash = getMissionConfigProperty(input, "SafeHouseAircraft")[math.random(1, #getMissionConfigProperty(input, "SafeHouseAircraft"))]
				
				randomLocation = Config.Missions[input].BlipSL.Position
				local spawnRadius = 50
				rXoffset = randomLocation.x + roundToNthDecimal(math.random() + math.random(-1*spawnRadius,spawnRadius - 1),4)
					
				rYoffset = randomLocation.y + roundToNthDecimal(math.random() + math.random(-1*spawnRadius,spawnRadius - 1),4)
				
				rZoffset =  randomLocation.z
				
				local vehiclehash = GetHashKey(randomPropModelHash)
				RequestModel(vehiclehash)
				while not HasModelLoaded(vehiclehash)   do
					Wait(1)
				end			
				
				PedVehicle = CreateVehicle(vehiclehash, rXoffset, rYoffset, rZoffset,  rHeading, 1, 0)
				SetModelAsNoLongerNeeded(vehiclehash)
				SetEntityHeading(PedVehicle, rHeading) 
				SetEntityAsMissionEntity(PedVehicle,true,true)
				DecorSetInt(PedVehicle,"mrpvehdid",i)
				DecorSetInt(PedVehicle,"mrpvehsafehouse",i)
				
				if getMissionConfigProperty(input, "SafeHouseDoInvincibleVehicles") then
					SetEntityInvincible(PedVehicle,true)
				end 
				
				--stop player griefing
				SetEntityCanBeDamagedByRelationshipGroup(PedVehicle, false, GetHashKey("PLAYER"))				
				Wait(1)
				doVehicleMods(randomPropModelHash,PedVehicle,input) 
				
			end
		end
		--Define a BlipSB to spawn vehicles and aicraft
		if(Config.Missions[input].BlipSB) then
			for i=1,  NumBoat do
				rHeading = roundToNthDecimal(math.random() + math.random(0,359),2)
				
				--spawn boat
				local randomPropModelHash = getMissionConfigProperty(input, "SafeHouseBoat")[math.random(1, #getMissionConfigProperty(input, "SafeHouseBoat"))]
				
				randomLocation = Config.Missions[input].BlipSB.Position
				local spawnRadius = 50
				rXoffset = randomLocation.x + roundToNthDecimal(math.random() + math.random(-1*spawnRadius,spawnRadius - 1),4)
					
				rYoffset = randomLocation.y + roundToNthDecimal(math.random() + math.random(-1*spawnRadius,spawnRadius - 1),4)
				
				rZoffset =  randomLocation.z
				
				local vehiclehash = GetHashKey(randomPropModelHash)
				RequestModel(vehiclehash)
				while not HasModelLoaded(vehiclehash) do --or not  HasCollisionForModelLoaded(vehiclehash) do
					Wait(1)
				end			
				
				PedVehicle = CreateVehicle(vehiclehash, rXoffset, rYoffset, rZoffset,  rHeading, 1, 0)
				SetModelAsNoLongerNeeded(vehiclehash)
				SetEntityHeading(PedVehicle, rHeading) 	
				SetEntityAsMissionEntity(PedVehicle,true,true)
				SetBoatAnchor(PedVehicle,true)
				DecorSetInt(PedVehicle,"mrpvehdid",i)
				DecorSetInt(PedVehicle,"mrpvehsafehouse",i)
				
				if getMissionConfigProperty(input, "SafeHouseDoInvincibleVehicles") then
					SetEntityInvincible(PedVehicle,true)
				end 				
				
				
				--stop player griefing
				SetEntityCanBeDamagedByRelationshipGroup(PedVehicle, false, GetHashKey("PLAYER"))				
				Wait(1)
				doVehicleMods(randomPropModelHash,PedVehicle,input) 
			
			end				
		end
		
		

end



--for IsRandom Missions places 1 prop at the Marker position for Objective Missions
--if HostageRescue and Type = "Assassinate" then spawn at least one hostage as a prop
--if IsDefend and IsDefendTarget, spawn either targetped or targetped/targetpedvehicle: DOES NOT SUPPORT IsRandomSpawnAnywhereInfo
function SpawnRandomProp(input,rIndex,IsRandomSpawnAnywhereInfo) 

		local randomLocation

		if(getMissionConfigProperty(input, "IsRandomSpawnAnywhere")) then 
			--print("spawn random prop:"..IsRandomSpawnAnywhereInfo[1].x..","..IsRandomSpawnAnywhereInfo[1].y..","..IsRandomSpawnAnywhereInfo[1].z)
			randomLocation = IsRandomSpawnAnywhereInfo[1]
		else
			randomLocation= getMissionConfigProperty(input, "RandomMissionPositions")[rIndex]
		end
		local rHeading = roundToNthDecimal(math.random() + math.random(0,359),2)
		
		if Config.Missions[input].Type =="Objective" and not getMissionConfigProperty(input, "HostageRescue") then 
			--print('Config.Missions[input].Type: '..Config.Missions[input].Type)
			local randomPropModelHash = getMissionConfigProperty(input, "RandomMissionProps")[math.random(1, #getMissionConfigProperty(input, "RandomMissionProps"))]		
			
			RequestModel(randomPropModelHash)
			while not HasModelLoaded(randomPropModelHash)  do
				Wait(1)
			end
			
			if(getMissionConfigProperty(input, "IsRandomSpawnAnywhere")) then 
				local zGround = checkAndGetGroundZ(randomLocation.x, randomLocation.y, randomLocation.z + 800.0,true)
				if zGround > 0.0 then --flag for checkspawn
					randomLocation.z = zGround		
				end					
			end 
			
			Config.Missions[input].Props[1].Position.x = randomLocation.x
			Config.Missions[input].Props[1].Position.y = randomLocation.y
			Config.Missions[input].Props[1].Position.z = randomLocation.z

			
			if Config.Missions[input].Props[1].id and randomPropModelHash then 
				--local _, worldZ = GetGroundZFor_3dCoord(Config.Missions[input].Props[1].Position.x, Config.Missions[input].Props[1].Position.y, Config.Missions[input].Props[1].Position.z)
				--Config.Missions[input].Props[1].id = CreateObject(Config.Missions[input].Props[1].Name, Config.Missions[input].Props[1].Position.x, Config.Missions[input].Props[1].Position.y, worldZ, true, true, true)
				
				if randomLocation.Marker then 
				--place object in marker if it is defined for the mission
					--print("PROP SPAWNED MARKER LOCATION: ID:"..Config.Missions[input].Props[1].id)
					Config.Missions[input].Props[1].id = CreateObject(randomPropModelHash,  randomLocation.Marker.Position.x, randomLocation.Marker.Position.y, randomLocation.Marker.Position.z-1, true, false, true)
				else 
					--print("PROP SPAWNED: ID:"..Config.Missions[input].Props[1].id)
					Config.Missions[input].Props[1].id = CreateObject(randomPropModelHash, randomLocation.x, randomLocation.y, randomLocation.z - 1, true, false, true)
				end
				SetModelAsNoLongerNeeded(randomPropModelHash)
				SetEntityAsMissionEntity(Config.Missions[input].Props[1].id,true,true)
				--print("PROP SPAWNED: ID:"..Config.Missions[input].Props[1].id)
				SetEntityHeading(Config.Missions[input].Props[1].id,rHeading)
				
				SetEntityDynamic(Config.Missions[input].Props[1].id, true)
				SetEntityRecordsCollisions(Config.Missions[input].Props[1].id, true)
				SetEntityHasGravity(Config.Missions[input].Props[1].id, true) --was true
				PlaceObjectOnGroundProperly(Config.Missions[input].Props[1].id) --was not using this
				local newcoords = GetEntityCoords(Config.Missions[input].Props[1].id)
				Config.Missions[input].Props[1].Position.x = newcoords.x
				Config.Missions[input].Props[1].Position.y = newcoords.y
				Config.Missions[input].Props[1].Position.z = newcoords.z
				
				Config.Missions[input].Marker.Position.x = Config.Missions[input].Props[1].Position.x
				Config.Missions[input].Marker.Position.y = Config.Missions[input].Props[1].Position.y
				Config.Missions[input].Marker.Position.z = Config.Missions[input].Props[1].Position.z
				
				if(randomPropModelHash =="prop_amb_phone") or (randomPropModelHash =="prop_c4_final_green") then 
					SetEntityRotation(Config.Missions[input].Props[1].id,-90.0,0.0,rHeading,true,true)
				end				
				
				--print("PROP SPAWNED: DISTANCE FROM PLAYER:"..#(vector3(randomLocation.x, randomLocation.y, randomLocation.z) - vector3(coords.x,coords.y,coords.z)))
				
				DecorSetInt(Config.Missions[input].Props[1].id,"mrppropid",1)
				
				DecorSetInt(Config.Missions[input].Props[1].id,"mrppropobj",1)
				
				--if DoesEntityExist(Config.Missions[input].Props[1].id) then	
					--print("prop exists")
				--end
				--PlaceObjectOnGroundProperly(Config.Missions[input].Props[1].id) -- This function doesn't seem to work.
						--SetEntityAsMissionEntity(Config.Missions[input].Props[i].id, true, true)
			end
		elseif (Config.Missions[input].Type =="Objective" and getMissionConfigProperty(input, "HostageRescue")) or getMissionConfigProperty(input, "Type") =="HostageRescue" then
			local randomPropModelHash = getMissionConfigProperty(input, "RandomMissionFriendlies")[math.random(1, #getMissionConfigProperty(input, "RandomMissionFriendlies"))]		
			
			RequestModel(randomPropModelHash)
			while not HasModelLoaded(randomPropModelHash)  do
				Wait(1)
			end
			
			Config.Missions[input].Peds[1].Position.x = randomLocation.x
			Config.Missions[input].Peds[1].Position.y = randomLocation.y
			Config.Missions[input].Peds[1].Position.z = randomLocation.z
			
			if Config.Missions[input].Peds[1].id and randomPropModelHash then 
				--local _, worldZ = GetGroundZFor_3dCoord(Config.Missions[input].Props[1].Position.x, Config.Missions[input].Props[1].Position.y, Config.Missions[input].Props[1].Position.z)
				--Config.Missions[input].Props[1].id = CreateObject(Config.Missions[input].Props[1].Name, Config.Missions[input].Props[1].Position.x, Config.Missions[input].Props[1].Position.y, worldZ, true, true, true)
				if randomLocation.Marker  then 
					--place hostage in marker if it is defined for the mission
					Config.Missions[input].Peds[1].id = CreatePed(2, randomPropModelHash,  randomLocation.Marker.Position.x, randomLocation.Marker.Position.y, randomLocation.Marker.Position.z-1, rHeading, true, true)
				else
					Config.Missions[input].Peds[1].id = CreatePed(2, randomPropModelHash, randomLocation.x, randomLocation.y, randomLocation.z-1, rHeading, true, true)
				end
				SetModelAsNoLongerNeeded(randomPropModelHash)
				SetEntityAsMissionEntity(Config.Missions[input].Peds[1].id,true,true)
				
				--print("PROP SPAWNED: ID:"..Config.Missions[input].Props[1].id)
				SetEntityHeading(Config.Missions[input].Peds[1].id,rHeading)
				--print("PROP SPAWNED: DISTANCE FROM PLAYER:"..#(vector3(randomLocation.x, randomLocation.y, randomLocation.z) - vector3(coords.x,coords.y,coords.z))
				--print("spawned hostage rescue ped")
				DecorSetInt(Config.Missions[input].Peds[1].id,"mrppedfriend",100000) --Make the id large to not conflict with spawn random peds event
				IsRandomMissionHostageCount = IsRandomMissionHostageCount + 1
				DecorSetInt(Config.Missions[input].Peds[1].id,"mrppedid",100000)
				SetPedRelationshipGroupHash(Config.Missions[input].Peds[1].id, GetHashKey("HOSTAGES"))
				SetRelationshipBetweenGroups(1, GetHashKey("HOSTAGES"), GetHashKey("HATES_PLAYER"))
				SetRelationshipBetweenGroups(1, GetHashKey("HOSTAGES"), GetHashKey("PLAYER"))
				
				--if not getMissionConfigProperty(input,"IsDefendTarget") or (getMissionConfigProperty(input,"IsDefendTarget") and getMissionConfigProperty(input,"IsDefendTargetOnlyPlayersDamagePeds") ) then	
				
				SetEntityOnlyDamagedByPlayer(Config.Missions[input].Peds[1].id, true) 
				--end
				
				if getMissionConfigProperty(input, "DelicateHostages") then 
					SetEntityOnlyDamagedByPlayer(Config.Missions[input].Peds[1].id, false) 
				end						
				
				TaskCower(Config.Missions[input].Peds[1].id,360000)
				
				--local pedb = AddBlipForEntity(Config.Missions[input].Peds[1].id)
				--local Size     = 0.9
				--SetBlipScale  (pedb, Size)
				--SetBlipAsShortRange(pedb, false)				
				
				--SetBlipColour(pedb, 2)
				--BeginTextCommandSetBlipName("STRING")
				--AddTextComponentString("Friend ($-"..getHostageKillPenalty(input)..")")
				--EndTextCommandSetBlipName(pedb)									
				
				
				--if DoesEntityExist(Config.Missions[input].Peds[1].id) then	
					--print("prop exists")
				--end
				--PlaceObjectOnGroundProperly(Config.Missions[input].Props[1].id) -- This function doesn't seem to work.
						--SetEntityAsMissionEntity(Config.Missions[input].Props[i].id, true, true)
			end
		elseif getMissionConfigProperty(input, "Type") =="BossRush" or (getMissionConfigProperty(input, "Type") =="Assassinate" and getMissionConfigProperty(input, "IsBountyHunt"))then
			local randomPropModelHash = getMissionConfigProperty(input, "RandomMissionBossPeds")[math.random(1, #getMissionConfigProperty(input, "RandomMissionBossPeds"))]	
			local rx
			local ry
			local rz
			local rh = rHeading
			if randomLocation.Marker then 
					--place hostage in marker if it is defined for the mission
				rx = randomLocation.Marker.Position.x 
				ry = randomLocation.Marker.Position.y 
				rz = randomLocation.Marker.Position.z-1
			else
				rx = randomLocation.x
				ry = randomLocation.y
				rz = randomLocation.z-1
			end	
			--get next available ped		
			local i = #Config.Missions[input].Peds + 1 
			Config.Missions[input].Peds[i]={id=i,modelHash=randomPropModelHash, x=rx,y=ry,z=rz,heading=rh,spawned=true,isBoss=true,outside=true,target=true} 
			SpawnAPed(input,i,false)									
			Config.Missions[input].Peds[i]=nil			
									
			
		end 
			
			local TargetPed
			local TargetPedVehicle			
			--spawn IsDefendTarget Entity and vehicle
			if Config.Missions[input].IsDefend and Config.Missions[input].IsDefendTarget and (not getMissionConfigProperty(input, "IsRandomSpawnAnywhere")) then 
				
				--need Blip2 defined on the random location
				if(randomLocation.Blip2) then 
					--do we add ped in vehicle?
					--NOTE: THESE SPAWN AT Blip2
					local x =  randomLocation.Blip2.Position.x
					local y =  randomLocation.Blip2.Position.y
					local z =  randomLocation.Blip2.Position.z
					local spawnedAircraft = 0
					if(randomLocation.DefendTargetInVehicle) then
						--print('SPAWN TargetPedRandomVehicle')
							
							local veh = getMissionConfigProperty(input, "IsDefendTargetRandomVehicles")[math.random(1, #getMissionConfigProperty(input, "IsDefendTargetRandomVehicles"))]		
							--local veh  =  Config.Missions[input].IsDefendTargetEntity[1].Vehicle
							if(randomLocation.DefendTargetVehicleIsAircraft) then
								veh = getMissionConfigProperty(input, "IsDefendTargetRandomAircraft")[math.random(1, #getMissionConfigProperty(input, "IsDefendTargetRandomAircraft"))]
								
								
								if not Config.Missions[input].IsDefendTargetPassenger then	
									spawnedAircraft = math.random(200,500)--give aircraft a height boost
								end
							elseif (randomLocation.DefendTargetVehicleIsBoat) then 
								veh = getMissionConfigProperty(input, "IsDefendTargetRandomBoat")[math.random(1, #getMissionConfigProperty(input, "IsDefendTargetRandomBoat"))]
							end
							
							local modelHash = getMissionConfigProperty(input, "IsDefendTargetRandomPeds")[math.random(1, #getMissionConfigProperty(input, "IsDefendTargetRandomPeds"))]
							
							
							local vehiclehash = GetHashKey(veh)
							RequestModel(vehiclehash)
							RequestModel(modelHash)
							while not HasModelLoaded(vehiclehash) do
							  Wait(1)
							end
							
							local rHeading = roundToNthDecimal(math.random() + math.random(0,359),2)
							print("z"..z)
							TargetPedVehicle = CreateVehicle(vehiclehash, x, y, z + 1.0*spawnedAircraft, rHeading , 1, 0)
							SetModelAsNoLongerNeeded(vehiclehash)
							--print('SPAWNED TargetRandomPedVehicle')
							SetEntityAsMissionEntity(TargetPedVehicle,true,true)
							DecorSetInt(TargetPedVehicle,"mrpvehdid",22222222)	
							doVehicleMods(veh,TargetPedVehicle,input)
								while not HasModelLoaded(modelHash)  do
									Wait(1)
								end
								TargetPed = CreatePed(2, modelHash, x, y, z,rHeading, true, true)
								
								GlobalTargetPed = TargetPed
								SetModelAsNoLongerNeeded(modelHash)
								
								if(DoesEntityExist(TargetPed)) then
									--print('TargetPed DOES NOT EXIST')
								end
								
							--hack:	
							Config.Missions[input].Blip.Position.x = GlobalGotoGoalX
							Config.Missions[input].Blip.Position.y = GlobalGotoGoalY
							Config.Missions[input].Blip.Position.z = GlobalGotoGoalZ

							if getMissionConfigProperty(input,"IsDefendTargetSetBlockingOfNonTemporaryEvents") then 
								SetBlockingOfNonTemporaryEvents(TargetPed,true)
							end											
								
								
								SetEntityAsMissionEntity(TargetPed,true,true)
								DecorSetInt(TargetPed,"mrppedid",111111111) --high value to not conflict
								DecorSetInt(TargetPed,"mrppeddefendtarget",1)
								SetPedMaxHealth(TargetPed, getMissionConfigProperty(input, "IsDefendTargetMaxHealth"))
								SetEntityHealth(TargetPed, getMissionConfigProperty(input, "IsDefendTargetMaxHealth"))
								SetPlayerMaxArmour(TargetPed,100)
								AddArmourToPed(TargetPed, 100)
								SetPedArmour(TargetPed, 100)
								SetPedCombatAttributes(TargetPed, 3, false)	
								
								--buff up the target
								SetPedDiesWhenInjured(TargetPed, false)
								SetPedSuffersCriticalHits(TargetPed, 0) 
								--SetPedCanRagdoll(TargetPed, false)
										
								SetPedRelationshipGroupHash(TargetPed, GetHashKey("ISDEFENDTARGET"))
								SetRelationshipBetweenGroups(5, GetHashKey("HATES_PLAYER"), GetHashKey("ISDEFENDTARGET"))
								SetRelationshipBetweenGroups(5, GetHashKey("TRUENEUTRAL"), GetHashKey("ISDEFENDTARGET"))
								SetRelationshipBetweenGroups(0, GetHashKey("ISDEFENDTARGET"), GetHashKey("PLAYER"))	
								
								

								if not Config.Missions[input].IsDefendTargetPassenger then
									SetPedIntoVehicle(TargetPed,TargetPedVehicle, -1)
								else
									--check where the targetped passenger should go:
									
									local passengerseatid = getIsDefendTargetSeatId(input,veh)
									if not Config.Missions[input].IsDefendTargetPassengerSeatId then
										if not passengerseatid then 
											SetPedIntoVehicle(TargetPed,TargetPedVehicle, 0)
										else 
											SetPedIntoVehicle(TargetPed,TargetPedVehicle,  passengerseatid)
										end
									else
										passengerseatid = Config.Missions[input].IsDefendTargetPassengerSeatId
										SetPedIntoVehicle(TargetPed,TargetPedVehicle, Config.Missions[input].IsDefendTargetPassengerSeatId)
									end
									--print(GetVehicleMaxNumberOfPassengers(TargetPedVehicle))
									--local passengerseatid = getIsDefendTargetSeatId(input,veh)
									
									--override when seatid is explicity set:
									--if Config.Missions[input].IsDefendTargetPassengerSeatId then 
										 --passengerseatid = Config.Missions[input].IsDefendTargetPassengerSeatId
								
									--end		
								
									
									TriggerEvent("mt:dotargetpassenger",TargetPed,TargetPedVehicle,passengerseatid)
									-- TriggerEvent("mt:missiontext2", "You are the driver. Protect the target.", 1000)
								end				
								--SetPedIntoVehicle(TargetPed,TargetPedVehicle, -1)
								local movespeed = GetVehicleMaxSpeed(GetEntityModel(TargetPedVehicle))
								
								--have vehicle move at a fraction of its top speed.
								if randomLocation.DefendTargetVehicleMoveSpeedRatio then  
									movespeed =  movespeed * randomLocation.DefendTargetVehicleMoveSpeedRatio
								end 
								--print(movespeed)
								
								if(randomLocation.DefendTargetVehicleIsAircraft) then
								
								if not Config.Missions[input].IsDefendTargetPassenger then
									SetVehicleLandingGear(TargetPedVehicle, 3) 
									SetVehicleForwardSpeed(TargetPedVehicle,movespeed)
									SetHeliBladesFullSpeed(PedVehicle) -- works for planes I guess
									SetVehicleEngineOn(PedVehicle, true, true, false)
								end
									
									local vehname = "TRAILERSMALL"
								--end
										RequestModel(GetHashKey(vehname))
										while not HasModelLoaded(GetHashKey(vehname))  do
											Wait(1)
										end
									
										
										local tveh = CreateVehicle(GetHashKey(vehname), Config.Missions[input].Blip.Position.x+20.0, Config.Missions[input].Blip.Position.y+20.0,Config.Missions[input].Blip.Position.z,  0.0, 1, 0)	
										DecorSetInt(tveh,"mrpvehdid",99887766)
										
										SetEntityVisible(tveh,false,0)
										SetEntityCollision(tveh,false,true)
										
										FreezeEntityPosition(tveh,true)
										
										if IsThisModelAPlane(GetEntityModel(TargetPedVehicle)) then
										--print("made it plane")
											TaskPlaneChase(TargetPed,tveh,0.0, 0.0, 5.0)
											--> needed -->:
											SetBlockingOfNonTemporaryEvents(TargetPed,true)										
										elseif IsThisModelAHeli(GetEntityModel(TargetPedVehicle)) then
										
											TaskHeliChase(TargetPed,tveh,0.0, 0.0, 5.0)
											--> needed -->:
											SetBlockingOfNonTemporaryEvents(TargetPed,true)
										
										end
									
								elseif(randomLocation.DefendTargetVehicleIsBoat) then	
									if not Config.Missions[input].IsVehicleDefendTargetGotoGoal then
 										TaskVehicleDriveWander(TargetPed, GetVehiclePedIsIn(TargetPed, false), movespeed, 0)					
									else
										SetBlockingOfNonTemporaryEvents(TargetPed,true)	
										TaskBoatMission(TargetPed,TargetPedVehicle, 0, 0, 
										Config.Missions[input].Blip.Position.x, 
										Config.Missions[input].Blip.Position.y, 
										Config.Missions[input].Blip.Position.z,
										4, movespeed, 0, -1.0, 7)
										--SetPedKeepTask(TargetPed,true)
										--> needed -->:
										--print(Config.Missions[input].Blip.Position.x)
										SetBlockingOfNonTemporaryEvents(TargetPed,true)									
									end									
								else 
									--whats going with this logic below?:
									if not Config.Missions[input].IsVehicleDefendTargetGotoGoal then 
										if ( Config.Missions[input].IsDefendTargetSetBlockingOfNonTemporaryEvents) then
										
											TaskVehicleDriveWander(TargetPed, GetVehiclePedIsIn(TargetPed, false), movespeed, 0)
										elseif ( math.random(2) > 1 and not randomLocation.DefendTargetVehicleIsAircraft) then
			
											TaskVehicleDriveWander(TargetPed, GetVehiclePedIsIn(TargetPed, false), movespeed, 0)

										end
									end
									

									
									--if Config.Missions[input].IsDefendTargetEntity[1].armor then --if ped has armor
										AddArmourToPed(TargetPed, 100)
										SetPedArmour(TargetPed, 100)
									--end	
									
									if (Config.Missions[input].IsVehicleDefendTargetGotoBlip) or (Config.Missions[input].IsVehicleDefendTargetGotoBlipTargetOnly)  
									or Config.Missions[input].IsVehicleDefendTargetGotoGoal	and not (randomLocation.DefendTargetVehicleIsAircraft)						
									then
										--ClearPedTasksImmediately(TargetPed)
										--print("TargetPed drive to blip:"..Config.Missions[input].Blip.Position.x)
										TaskVehicleDriveToCoordLongrange(TargetPed,TargetPedVehicle, Config.Missions[input].Blip.Position.x, Config.Missions[input].Blip.Position.y,Config.Missions[input].Blip.Position.z, movespeed, 0, 0.0) --drive mode is zero
										SetPedKeepTask(TargetPed,true) 
									

									end											

									
								
								end
								
												
					
					else
						local modelHash = getMissionConfigProperty(input, "IsDefendTargetRandomPeds")[math.random(1, #getMissionConfigProperty(input, "IsDefendTargetRandomPeds"))]
							
						local rHeading = roundToNthDecimal(math.random() + math.random(0,359),2)
						
						local Weapon = getMissionConfigProperty(input, "IsDefendTargetRandomPedWeapons")[math.random(1, #getMissionConfigProperty(input, "IsDefendTargetRandomPedWeapons"))]
						
						--print("ISDEFENTARGET WEAPON:"..Weapon)
						
						RequestModel(modelHash)
						while not HasModelLoaded(modelHash)  do
							Wait(1)
						end
					
						TargetPed = CreatePed(2, modelHash, x, y, z, rHeading, true, true)
						GlobalTargetPed = TargetPed
						SetModelAsNoLongerNeeded(modelHash)
						SetEntityAsMissionEntity(TargetPed,true,true)
						DecorSetInt(TargetPed,"mrppedid",111111111) --high value to not conflict
						DecorSetInt(TargetPed,"mrppeddefendtarget",1)
						SetPedMaxHealth(TargetPed, getMissionConfigProperty(input, "IsDefendTargetMaxHealth"))
						SetEntityHealth(TargetPed, getMissionConfigProperty(input, "IsDefendTargetMaxHealth"))
						SetPlayerMaxArmour(TargetPed,100)
						AddArmourToPed(TargetPed, 100)
						SetPedArmour(TargetPed, 100)						
						
						--buff up the target
						SetPedDiesWhenInjured(TargetPed, false)
						SetPedSuffersCriticalHits(TargetPed, 0) 
						SetPedCanRagdoll(TargetPed, false)
						
						if getMissionConfigProperty(input,"IsDefendTargetSetBlockingOfNonTemporaryEvents") then 
							SetBlockingOfNonTemporaryEvents(TargetPed,true)
						end				
						
						
						SetPedDropsWeaponsWhenDead(TargetPed, getMissionConfigProperty(input, "SetPedDropsWeaponsWhenDead"))
						SetPedRelationshipGroupHash(TargetPed, GetHashKey("ISDEFENDTARGET"))
						SetRelationshipBetweenGroups(5, GetHashKey("HATES_PLAYER"), GetHashKey("ISDEFENDTARGET"))
						SetRelationshipBetweenGroups(5, GetHashKey("TRUENEUTRAL"), GetHashKey("ISDEFENDTARGET"))
						SetRelationshipBetweenGroups(0, GetHashKey("ISDEFENDTARGET"), GetHashKey("PLAYER"))		
						--only way so far to make them enemy but not flee on foot
						--at risk of running at enemies!:
						--SetPedFleeAttributes(TargetPed, 0, 0)
						--SetPedCombatAttributes(TargetPed, 16, true)
						SetPedCombatAttributes(TargetPed, 5, true)
						SetPedCombatAttributes(TargetPed, 46, true)
						--SetPedCombatAttributes(TargetPed, 16, true)
						--SetPedCombatAttributes(TargetPed, 1424, true)
						
						--if Config.Missions[input].IsDefendTargetEntity[1].wander then
							--TaskWanderStandard(TargetPed,10.0, 10)
						--elseif Config.Missions[input].IsDefendTargetEntity[1].wanderinarea then
							
						if Config.Missions[input].RandomIsDefendTargetWander then --math.random(2) > 1  then
						--print("hey")
							TaskWanderInArea(TargetPed,x,y,z,200.0,0.0,0.0) --wanderinarea within 300 meters 
							SetPedKeepTask(TargetPed,true) 		
						end
						
						
						--end
						
						local movespeed = 20.0 --How fast can peds move?
	
						AddArmourToPed(TargetPed, 100)
						SetPedArmour(TargetPed, 100)
						
						--buggy?						
						GiveWeaponToPed(TargetPed,Weapon, 2800, false, true)	
						
						ResetAiWeaponDamageModifier()
						SetAiWeaponDamageModifier(1.0) -- 1.0 == Normal Damage. 
						SetAiMeleeWeaponDamageModifier(1.0)						
						
						if  (Config.Missions[input].IsDefendTargetGotoBlip) or (Config.Missions[input].IsDefendTargetGotoBlipTargetOnly)  then 
							ClearPedTasksImmediately(TargetPed)
							TaskGoStraightToCoord(TargetPed,Config.Missions[input].Blip.Position.x, Config.Missions[input].Blip.Position.y,Config.Missions[input].Blip.Position.z, movespeed, 100000, 0.0, 0.0) 
							SetPedKeepTask(TargetPed,true) 					
						end							
						
						
						--for now make them not flee but stay still
						--ClearPedTasksImmediately(TargetPed)
						--TaskStandStill(TargetPed,360000)
						--SetPedKeepTask(TargetPed,true) 
					
					end
				
				end
			
			
			end
			
			return {TargetPed,TargetPedVehicle}		
		

end

--[[
function SpawnRandomPropsTest(input,rIndex) 
		
		local randomLocation = getMissionConfigProperty(input, "RandomMissionPositions")[rIndex]
		local rHeading = roundToNthDecimal(math.random() + math.random(0,359),2)
		
		local dif = 0
		for i, v in pairs(getMissionConfigProperty(input, "RandomMissionProps")) do
			print("spawning prop"..v)
			local randomPropModelHash = v	
			RequestModel(randomPropModelHash)
			while not HasModelLoaded(randomPropModelHash) do
				Wait(1)
			end			
			
			Config.Missions[input].Props[1].Position.x = randomLocation.x
			Config.Missions[input].Props[1].Position.y = randomLocation.y
			Config.Missions[input].Props[1].Position.z = randomLocation.z
				if Config.Missions[input].Props[1].id and randomPropModelHash then 
					print("spawned prop"..v)
					--local _, worldZ = GetGroundZFor_3dCoord(Config.Missions[input].Props[1].Position.x, Config.Missions[input].Props[1].Position.y, Config.Missions[input].Props[1].Position.z)
					--Config.Missions[input].Props[1].id = CreateObject(Config.Missions[input].Props[1].Name, Config.Missions[input].Props[1].Position.x, Config.Missions[input].Props[1].Position.y, worldZ, true, true, true)
					Config.Missions[input].Props[1].id = CreateObject(randomPropModelHash, randomLocation.x + dif, randomLocation.y, randomLocation.z -1.0, true, true, true)
					
					SetEntityHeading(Config.Missions[input].Props[1].id,rHeading)
				
					DecorSetInt(Config.Missions[input].Props[1].id,"mrppropid",1)
					PlaceObjectOnGroundProperly(Config.Missions[input].Props[1].id) -- This function doesn't seem to work.
						--SetEntityAsMissionEntity(Config.Missions[input].Props[i].id, true, true)
				end	
			 dif = dif + 5		
			
		end	
		
	

end
]]--

function SpawnProps(input) 
		--[[
	if not HasNamedPtfxAssetLoaded("core") then
		RequestNamedPtfxAsset("core")
		while not HasNamedPtfxAssetLoaded("core") do
			Wait(1)
		end
	end

	SetPtfxAssetNextCall("core")
	local part = StartParticleFxLoopedAtCoord("ent_col_electrical", 2022.58, 3020.78, -72.79, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
	--StartParticleFxLoopedOnEntity_2("fire_wrecked_tank_cockpit",0.0,0.0,0.0, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
	]]--
				
			if(Config.Missions[input].Props) then 
				 for i=1, #Config.Missions[input].Props do     
					RequestModel(Config.Missions[input].Props[i].Name)
					while not HasModelLoaded(Config.Missions[input].Props[i].Name)  do
						Wait(1)
					end
					
					--local _, worldZ = GetGroundZFor_3dCoord(Config.Missions[input].Props[i].Position.x, Config.Missions[input].Props[i].Position.y, Config.Missions[input].Props[i].Position.z)
					--Config.Missions[input].Props[i].id = CreateObject(Config.Missions[input].Props[i].Name, Config.Missions[input].Props[i].Position.x, Config.Missions[input].Props[i].Position.y, worldZ, true, true, true)
					Config.Missions[input].Props[i].id = CreateObject(Config.Missions[input].Props[i].Name, Config.Missions[input].Props[i].Position.x, Config.Missions[input].Props[i].Position.y, Config.Missions[input].Props[i].Position.z -1.0, true, true, true)
					SetModelAsNoLongerNeeded(Config.Missions[input].Props[i].Name)
					SetEntityAsMissionEntity(Config.Missions[input].Props[i].id,true,true)
					if not Config.Missions[input].Props[i].dontsetheading then 
						
						SetEntityHeading(Config.Missions[input].Props[i].id,Config.Missions[input].Props[i].Position.heading)
					end 
					SetEntityAsMissionEntity(Config.Missions[input].Props[i].id,true,true)
					DecorSetInt(Config.Missions[input].Props[i].id,"mrppropid",i)
					
					if(Config.Missions[input].Props[i].Name =="prop_amb_phone") or (Config.Missions[input].Props[i].Name =="prop_c4_final_green") then 
						SetEntityRotation(Config.Missions[input].Props[i].id,-90.0,0.0,rHeading,true,true)
					end
					
					
					if Config.Missions[input].Props[i].isObjective then
						DecorSetInt(Config.Missions[input].Props[i].id,"mrpproprescue",i)
					end
					
					if Config.Missions[input].Props[i].Freeze then
						FreezeEntityPosition(Config.Missions[input].Props[i].id,true)
					end
					
					--PlaceObjectOnGroundProperly(Config.Missions[input].Props[i].id) -- This function doesn't seem to work.
					--SetEntityAsMissionEntity(Config.Missions[input].Props[i].id, true, true)
					--StartParticleFxLoopedOnEntity("fire_wrecked_tank_cockpit",Config.Missions[input].Props[i].id,0.0,0.0,0.0, 0.0, 0.0, 0.0, 1.0, false, false, false)
					--Citizen.InvokeNative(0x6F60E89A7B64EE1D,"fire_wrecked_tank_cockpit",Config.Missions[input].Props[i].id,0.0,0.0,0.0, 0.0, 0.0, 0.0, 1.0, false, false, false)
				end
				
				--can get called in spawnpedblips first
				local checkisObjectiveRescueCount = isObjectiveRescueCount	
				--print("isObjectiveRescueCount:"..isObjectiveRescueCount)
				--print("checkisObjectiveRescueCount:"..checkisObjectiveRescueCount)				
				--needs to be here, not above loop, due to timing with spawnpedblips:
				for i=1, #Config.Missions[input].Props do

					if(checkisObjectiveRescueCount ==0 and Config.Missions[input].Props[i].isObjective) then
						--DecorSetInt(Config.Missions[input].Props[i].id,"mrpproprescue",i)
						isObjectiveRescueCount = isObjectiveRescueCount + 1 
					end				
				end
				
				
			end
			
			
			

			local TargetPed
			local TargetPedVehicle			
			--spawn IsDefendTarget Entity and vehicle
			if Config.Missions[input].IsDefend and Config.Missions[input].IsDefendTarget then 
	
				if(Config.Missions[input].IsDefendTargetEntity) then 
			
					--do we add ped in vehicle?
					--NOTE: THESE SPAWN AT Blip2
					local x =  Config.Missions[input].Blip2.Position.x
					local y =  Config.Missions[input].Blip2.Position.y
					local z =  Config.Missions[input].Blip2.Position.z
					
					if Config.Missions[input].IsDefendTargetEntity[1].SpawnAt then 
						x =  Config.Missions[input].IsDefendTargetEntity[1].SpawnAt.x
						y =  Config.Missions[input].IsDefendTargetEntity[1].SpawnAt.y
						z =  Config.Missions[input].IsDefendTargetEntity[1].SpawnAt.z
						--print("spawnat")

					end
					
					if(Config.Missions[input].IsDefendTargetEntity[1].id2 and Config.Missions[input].IsDefendTargetEntity[1].Vehicle) then
						--print('SPAWN TargetPedVehicle')
							local veh  =  Config.Missions[input].IsDefendTargetEntity[1].Vehicle
							local vehiclehash = GetHashKey(veh)
							RequestModel(vehiclehash)
							RequestModel(GetHashKey(Config.Missions[input].IsDefendTargetEntity[1].modelHash))
							while not HasModelLoaded(vehiclehash) do
							  Wait(1)
							end
					 
							TargetPedVehicle = CreateVehicle(vehiclehash, x, y, z, Config.Missions[input].IsDefendTargetEntity[1].heading, 1, 0)
							SetModelAsNoLongerNeeded(vehiclehash)
							--print('SPAWNED TargetPedVehicle')
							SetEntityAsMissionEntity(TargetPedVehicle,true,true)
							DecorSetInt(TargetPedVehicle,"mrpvehdid",11111111)	
							
							local firingpatterns = {driverfiringpattern = false,turretfiringpattern = false}
							if(not Config.Missions[input].IsDefendTargetEntity[1].nomods) then 
								firingpatterns = doVehicleMods(veh,TargetPedVehicle,input) 
							end							
							--doVehicleMods(veh,TargetPedVehicle)
							
								while not HasModelLoaded(GetHashKey(Config.Missions[input].IsDefendTargetEntity[1].modelHash))  do
									Wait(1)
								end
								TargetPed = CreatePed(2, Config.Missions[input].IsDefendTargetEntity[1].modelHash, x, y, z,Config.Missions[input].IsDefendTargetEntity[1].heading, true, true)
								GlobalTargetPed = TargetPed
								SetModelAsNoLongerNeeded(Config.Missions[input].IsDefendTargetEntity[1].modelHash)
								if(DoesEntityExist(TargetPed)) then
									--print('TargetPed DOES NOT EXIST')
								end
								
								SetEntityAsMissionEntity(TargetPed,true,true)
								DecorSetInt(TargetPed,"mrppedid",111111111) --high value to not conflict
								DecorSetInt(TargetPed,"mrppeddefendtarget",1)
								SetPedMaxHealth(TargetPed, getMissionConfigProperty(input, "IsDefendTargetMaxHealth"))
								SetEntityHealth(TargetPed, getMissionConfigProperty(input, "IsDefendTargetMaxHealth"))
								SetPlayerMaxArmour(TargetPed,100)
								AddArmourToPed(TargetPed, 100)
								SetPedArmour(TargetPed, 100)								
								SetPedCombatAttributes(TargetPed, 3, false)	
								
								--buff up the target
								SetPedDiesWhenInjured(TargetPed, false)
								SetPedSuffersCriticalHits(TargetPed, 0) 
								SetPedCanRagdoll(TargetPed, false)
								
								
								SetPedRelationshipGroupHash(TargetPed, GetHashKey("ISDEFENDTARGET"))
								SetRelationshipBetweenGroups(5, GetHashKey("HATES_PLAYER"), GetHashKey("ISDEFENDTARGET"))
								SetRelationshipBetweenGroups(5, GetHashKey("TRUENEUTRAL"), GetHashKey("ISDEFENDTARGET"))
								SetRelationshipBetweenGroups(0, GetHashKey("ISDEFENDTARGET"), GetHashKey("PLAYER"))

								if getMissionConfigProperty(input,"IsDefendTargetSetBlockingOfNonTemporaryEvents") then 
									SetBlockingOfNonTemporaryEvents(TargetPed,true)
								end	
									
								if not Config.Missions[input].IsDefendTargetPassenger then
									SetPedIntoVehicle(TargetPed,TargetPedVehicle, -1)
								else
									--check where the targetped passenger should go:
									
									local passengerseatid = getIsDefendTargetSeatId(input,veh)
									if not Config.Missions[input].IsDefendTargetPassengerSeatId then
										if not passengerseatid then 
											SetPedIntoVehicle(TargetPed,TargetPedVehicle, 0)
										else 
											SetPedIntoVehicle(TargetPed,TargetPedVehicle,  passengerseatid)
										end
									else
										passengerseatid = Config.Missions[input].IsDefendTargetPassengerSeatId
										SetPedIntoVehicle(TargetPed,TargetPedVehicle, Config.Missions[input].IsDefendTargetPassengerSeatId)
									end								
									TriggerEvent("mt:dotargetpassenger",TargetPed,TargetPedVehicle,passengerseatid)
									-- TriggerEvent("mt:missiontext2", "You are the driver. Protect the target.", 1000)
								end
								local movespeed = GetVehicleMaxSpeed(GetEntityModel(TargetPedVehicle))
									
								if Config.Missions[input].IsDefendTargetEntity[1].movespeed ~= nil then
									movespeed =Config.Missions[input].IsDefendTargetEntity[1].movespeed
								end	
								if Config.Missions[input].IsDefendTargetEntity[1].driving then
									
									TaskVehicleDriveWander(TargetPed, TargetPedVehicle, movespeed, 0)
								
								elseif Config.Missions[input].IsDefendTargetEntity[1].movetocoord then 
									local vehicleModel = GetEntityModel(TargetPedVehicle)
									--local vehicleMaxSpeed = GetVehicleMaxSpeed(vehicleModel)
									--print("made it:")
									if IsThisModelABoat(vehicleModel) then 
									
										--print(vehicleMaxSpeed)
										--SetBlockingOfNonTemporaryEvents(TargetPed,true)
										TaskBoatMission(TargetPed,TargetPedVehicle, 0, 0, 
										Config.Missions[input].IsDefendTargetEntity[1].movetocoord.x, 
										Config.Missions[input].IsDefendTargetEntity[1].movetocoord.y, 
										Config.Missions[input].IsDefendTargetEntity[1].movetocoord.z,
										4, movespeed, 0, -1.0, 7)
										SetBlockingOfNonTemporaryEvents(TargetPed,true)

									elseif IsThisModelAHeli(vehicleModel) then
										
										--since TaskHeliMission doesnt work, use a bogus vehicle to chase
										local vehname = "TRAILERSMALL"
										if Config.Missions[input].IsDefendTargetEntity[1].movetovehicle then 
											vehname = Config.Missions[input].IsDefendTargetEntity[1].movetovehicle
										end
										RequestModel(GetHashKey(vehname))
										while not HasModelLoaded(GetHashKey(vehname))  do
											Wait(1)
										end										
										
										local tveh = CreateVehicle(GetHashKey(vehname), Config.Missions[input].IsDefendTargetEntity[1].movetocoord.x, Config.Missions[input].IsDefendTargetEntity[1].movetocoord.y,Config.Missions[input].IsDefendTargetEntity[1].movetocoord.z,  0.0, 1, 0)
										
										SetEntityVisible(tveh,false,0)
										FreezeEntityPosition(tveh,true)
										SetEntityCollision(tveh,false,true)
										
										
										
										DecorSetInt(tveh,"mrpvehdid",99887766)
										
										
										if not Config.Missions[input].IsDefendTargetPassenger then
											SetVehicleLandingGear(TargetPedVehicle, 3) 
											SetHeliBladesFullSpeed(TargetPedVehicle) -- works for planes I guess
											SetVehicleEngineOn(TargetPedVehicle, true, true, false)
										end										
										TaskHeliChase(TargetPed,tveh,0.0, 0.0, 5.0)
										SetBlockingOfNonTemporaryEvents(TargetPed,true)
									
									elseif IsThisModelAPlane(vehicleModel) then
									--print("made it:")
											
										--since TaskHeliMission doesnt work, use a bogus vehicle to chase
										local vehname = "TRAILERSMALL"
										if Config.Missions[input].IsDefendTargetEntity[1].movetovehicle then 
											vehname = Config.Missions[input].IsDefendTargetEntity[1].movetovehicle
										end
										RequestModel(GetHashKey(vehname))
										while not HasModelLoaded(GetHashKey(vehname))   do
											Wait(1)
										end											
										
										local tveh = CreateVehicle(GetHashKey(vehname), Config.Missions[input].IsDefendTargetEntity[1].movetocoord.x, Config.Missions[input].IsDefendTargetEntity[1].movetocoord.y,Config.Missions[input].IsDefendTargetEntity[1].movetocoord.z,  0.0, 1, 0)
										
										SetEntityVisible(tveh,false,0)
										SetEntityCollision(tveh,false,true)
										FreezeEntityPosition(tveh,true)
										
										DecorSetInt(tveh,"mrpvehdid",99887766)
										if not Config.Missions[input].IsDefendTargetPassenger then
											SetVehicleLandingGear(TargetPedVehicle, 3) 
											SetVehicleForwardSpeed(TargetPedVehicle,movepseed)
											SetHeliBladesFullSpeed(TargetPedVehicle) -- works for planes I guess
											SetVehicleEngineOn(TargetPedVehicle, true, true, false)
										end											
										TaskPlaneChase(TargetPed,tveh,0.0, 0.0, 500.0)
										--print("hey2")
										SetBlockingOfNonTemporaryEvents(TargetPed,true)
																		
										
									
									else 
									
										TaskVehicleDriveToCoordLongrange(TargetPed, TargetPedVehicle, Config.Missions[input].IsDefendTargetEntity[1].movetocoord.x,  Config.Missions[input].IsDefendTargetEntity[1].movetocoord.y,  Config.Missions[input].IsDefendTargetEntity[1].movetocoord.z, movespeed, 0, 5.0) --drive mode is zero
										--print("made it")
										
									
									end 
									
									
									SetPedKeepTask( TargetPed,true) 
			
								end
								
								if Config.Missions[input].IsDefendTargetEntity[1].armor then --if ped has armor
									AddArmourToPed(TargetPed, Config.Missions[input].IsDefendTargetEntity[1].armor)
									SetPedArmour(TargetPed, Config.Missions[input].IsDefendTargetEntity[1].armor)
								end	
								
								if (Config.Missions[input].IsVehicleDefendTargetGotoBlip) or (Config.Missions[input].IsVehicleDefendTargetGotoBlipTargetOnly) then
									TaskVehicleDriveToCoordLongrange(TargetPed,TargetPedVehicle, Config.Missions[input].Blip.Position.x, Config.Missions[input].Blip.Position.y,Config.Missions[input].Blip.Position.z, movespeed, 0, 0.0) --drive mode is zero
									SetPedKeepTask(TargetPed,true) 		
						
								end											

		
													
					
					else
						RequestModel(GetHashKey(Config.Missions[input].IsDefendTargetEntity[1].modelHash))
						while not HasModelLoaded(Config.Missions[input].IsDefendTargetEntity[1].modelHash)  do
							Wait(1)
						end
					
						TargetPed = CreatePed(2, Config.Missions[input].IsDefendTargetEntity[1].modelHash, x, y, z, Config.Missions[input].IsDefendTargetEntity[1].heading, true, true)
						GlobalTargetPed = TargetPed
						SetModelAsNoLongerNeeded(Config.Missions[input].IsDefendTargetEntity[1].modelHash)
						SetEntityAsMissionEntity(TargetPed,true,true)
						DecorSetInt(TargetPed,"mrppedid",111111111) --high value to not conflict
						DecorSetInt(TargetPed,"mrppeddefendtarget",1)
						
						--SetPedDiesWhenInjured(TargetPed, true)
						--buff up the target
						SetPedDiesWhenInjured(TargetPed, false)
						SetPedSuffersCriticalHits(TargetPed, 0) 
						--SetPedCanRagdoll(TargetPed, false)
						
						if getMissionConfigProperty(input,"IsDefendTargetSetBlockingOfNonTemporaryEvents") then 
							SetBlockingOfNonTemporaryEvents(TargetPed,true)
						end								
						
						SetPedDropsWeaponsWhenDead(TargetPed, getMissionConfigProperty(input, "SetPedDropsWeaponsWhenDead"))
						SetPedRelationshipGroupHash(TargetPed, GetHashKey("ISDEFENDTARGET"))
						SetRelationshipBetweenGroups(5, GetHashKey("HATES_PLAYER"), GetHashKey("ISDEFENDTARGET"))
						SetRelationshipBetweenGroups(5, GetHashKey("TRUENEUTRAL"), GetHashKey("ISDEFENDTARGET"))
						SetRelationshipBetweenGroups(0, GetHashKey("ISDEFENDTARGET"), GetHashKey("PLAYER"))		
						--only way so far to make them enemy but not flee on foot
						--at risk of running at enemies!:
						SetPedFleeAttributes(TargetPed, 0, 0)
						SetPedCombatAttributes(TargetPed, 5, true)
						SetPedCombatAttributes(TargetPed, 46, true)
						
						SetPedCombatAttributes(TargetPed, 0, false);
						SetPedCombatAttributes(TargetPed, 2, true)
						
						if Config.Missions[input].IsDefendTargetEntity[1].wander then
							TaskWanderStandard(TargetPed,10.0, 10)
						elseif Config.Missions[input].IsDefendTargetEntity[1].wanderinarea then
							TaskWanderInArea(TargetPed,x,y,z,25.0,0.0,0.0) --wanderinarea within 25 meters 
						end
						
						local movespeed = 5.0 --How fast can peds move?
						if(Config.Missions[input].IsDefendTargetEntity[1]) then 
							if Config.Missions[input].IsDefendTargetEntity[1].movespeed ~= nil then
								movespeed = Config.Missions[input].IsDefendTargetEntity[1].movespeed
							end				
						end 					
						
						if Config.Missions[input].IsDefendTargetEntity[1].movetocoord then 
							ClearPedTasksImmediately(TargetPed)
							TaskGoStraightToCoord(TargetPed,Config.Missions[input].IsDefendTargetEntity[1].movetocoord.x, Config.Missions[input].IsDefendTargetEntity[1].movetocoord.y,Config.Missions[input].IsDefendTargetEntity[1].movetocoord.y, movespeed, 100000, 0.0, 0.0) 
							SetPedKeepTask(TargetPed,true) 
						end			
						
						if Config.Missions[input].IsDefendTargetEntity[1].armor then --if ped has armor
							AddArmourToPed(TargetPed, Config.Missions[input].IsDefendTargetEntity[1].armor)
							SetPedArmour(TargetPed, Config.Missions[input].IsDefendTargetEntity[1].armor)
						end	
						--buggy?
						GiveWeaponToPed(TargetPed,Config.Missions[input].IsDefendTargetEntity[1].Weapon, 2800, false, true)	
						
						
						if  (Config.Missions[input].IsDefendTargetGotoBlip) or (Config.Missions[input].IsDefendTargetGotoBlipTargetOnly) then 
							ClearPedTasksImmediately(TargetPed)
							TaskGoStraightToCoord(TargetPed,Config.Missions[input].Blip.Position.x, Config.Missions[input].Blip.Position.y,Config.Missions[input].Blip.Position.z, movespeed, 100000, 0.0, 0.0) 
							SetPedKeepTask(TargetPed,true) 	

						elseif Config.Missions[input].IsDefendTargetGotoEntity then
						
							ClearPedTasksImmediately(Ped)
						--print('TASK MOVE TO ENTITY')
							if (Config.Missions[input].Props[1] and Config.Missions[input].Props[1].id) then 
								TaskGoToEntity(TargetPed, Config.Missions[input].Props[1].id, -1, 5.0, 20.0,1073741824, 0)
								SetPedKeepTask(Ped,true) 	
							else
								print("no Config.Missions["..input.."].Props[1].id found for IsDefendTarget to follow")
							end 
						end							
						
						
						--for now make them not flee but stay still
						--ClearPedTasksImmediately(TargetPed)
						--TaskStandStill(TargetPed,360000)
						--SetPedKeepTask(TargetPed,true) 
					
					end
				
				end
			
			
			end
			
			
			if Config.Missions[input].VehicleGotoMissionTarget 
			and VehicleGotoMissionTargetCoords
			then 
				local VehicleGotoMissionTarget = Config.Missions[input].VehicleGotoMissionTarget
				local VehicleGotoMissionTargetCoords = Config.Missions[input].VehicleGotoMissionTargetCoords
				
				--since TaskHeliMission doesnt work, use a bogus vehicle to chase
				local vehname = "TRAILERSMALL"
				if Config.Missions[input].VehicleGotoMissionTarget then 
					vehname = Config.Missions[input].VehicleGotoMissionTarget
				end
				RequestModel(GetHashKey(vehname))
				while not HasModelLoaded(GetHashKey(vehname))  do
					Wait(1)
				end										
										
				local tveh = CreateVehicle(GetHashKey(vehname), VehicleGotoMissionTargetCoords.x, VehicleGotoMissionTargetCoords.y,VehicleGotoMissionTargetCoords.z,  0.0, 1, 0)
				SetEntityVisible(tveh,false,0)	
				SetEntityCollision(tveh,false,true)		
				FreezeEntityPosition(tveh,true)						
				DecorSetInt(tveh,"mrpvehdid",99887755)	
				
				
				

			end			
			
			return {TargetPed,TargetPedVehicle}

end


function CleanupProps(input) 
	
	
	for obj in EnumerateObjects() do
		if(DecorGetInt(obj,"mrppropid")) > 0 then 
			
			DeleteObject(obj)
		
		end
	end

			
		--[[
			if(Config.Missions[input].Props) then 			
				 for i=1, #Config.Missions[input].Props do  
					if Config.Missions[input].Props[i].id and DoesEntityExist(Config.Missions[input].Props[i].id) then
							DeleteObject(Config.Missions[input].Props[i].id)
					end
				end
			end 
		]]--
			

end


function SpawnMissionPickupsOnPlayer(oldmission)

	if Config.Missions[oldmission].SpawnMissionPickupsOnPlayer ~=nil then

		return Config.Missions[oldmission].SpawnMissionPickupsOnPlayer
	else
		return Config.SpawnMissionPickupsOnPlayer
	end 


end

function SpawnMissionComponentsOnPlayer(oldmission)

	if Config.Missions[oldmission].SpawnMissionComponentsOnPlayer ~=nil then

		return Config.Missions[oldmission].SpawnMissionComponentsOnPlayer
	else
		return Config.SpawnMissionComponentsOnPlayer
	end 


end

function SpawnRewardPickupsOnPlayer(oldmission)

	if Config.Missions[oldmission].SpawnRewardPickupsOnPlayer ~=nil then

		return Config.Missions[oldmission].SpawnRewardPickupsOnPlayer
	else
		return Config.SpawnRewardPickupsOnPlayer
	end  


end

function SpawnRewardComponentsOnPlayer(oldmission)

	if Config.Missions[oldmission].SpawnRewardComponentsOnPlayer ~=nil then

		return Config.Missions[oldmission].SpawnRewardComponentsOnPlayer
	else
		return Config.SpawnRewardComponentsOnPlayer
	end 


end

function getSpawnMissionPickups(oldmission)

	local weaponlist = {}
	if Config.Missions[oldmission].SpawnMissionPickups ~=nil then
		weaponlist = Config.Missions[oldmission].SpawnMissionPickups

	else
		weaponlist = Config.SpawnMissionPickups
		
	end 
	giveWeaponsToPlayer(weaponlist) 
end

function getSpawnMissionComponents(oldmission)

	local weaponlist = {}
	if Config.Missions[oldmission].SpawnMissionComponents ~=nil then
		weaponlist = Config.Missions[oldmission].SpawnMissionComponents

	else
		weaponlist = Config.SpawnMissionComponents
		
	end 
	giveComponentsToPlayer(weaponlist) 
end


function getSpawnSafeHousePickups(oldmission)

	local weaponlist = {}
	if Config.Missions[oldmission].SpawnSafeHousePickups ~=nil then
		weaponlist = Config.Missions[oldmission].SpawnSafeHousePickups

	else
		weaponlist = Config.SpawnSafeHousePickups
		
	end 
	giveWeaponsToPlayer(weaponlist) 
end

function getSpawnSafeHouseComponents(oldmission)

	local weaponlist = {}
	if Config.Missions[oldmission].SpawnSafeHouseComponents ~=nil then
		weaponlist = Config.Missions[oldmission].SpawnSafeHouseComponents

	else
		weaponlist = Config.SpawnSafeHouseComponents
		
	end 
	giveComponentsToPlayer(weaponlist) 
end



function getSpawnRewardPickups(oldmission)
	local weaponlist = {}
	if Config.Missions[oldmission].SpawnRewardPickups ~=nil then

		weaponlist = Config.Missions[oldmission].SpawnRewardPickups
	
	else
		weaponlist = Config.SpawnRewardPickups
	
	end 

	giveWeaponsToPlayer(weaponlist) 
end

function getSpawnRewardComponents(oldmission)
	local weaponlist = {}
	if Config.Missions[oldmission].SpawnRewardComponents ~=nil then

		weaponlist = Config.Missions[oldmission].SpawnRewardComponents
	
	else
		weaponlist = Config.SpawnRewardComponents
	
	end 

	giveComponentsToPlayer(weaponlist) 
end


function giveWeaponsToPlayer(weaponlist) 
	for i, v in pairs(weaponlist) do
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(v), 1000, false)
	end

end

function giveComponentsToPlayer(weaponlist) 
	
	for i, v in pairs(weaponlist) do
		local component
		local weapon
		for token in string.gmatch(v, "[^%s]+") do
			if(component) then
				weapon=token
			else 
				component=token
			end
		end
		if HasPedGotWeapon(PlayerPedId(), GetHashKey(weapon), false) then
			GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey(weapon), GetHashKey(component))
			
		end
	end

end



--Use RANDOM anymore?
function SpawnMissionPickups(oldmission) 
	--not used anymore, unless 'RANDOM' is used...
	local choosenWeapon = getMissionConfigProperty(oldmission, "EnemySpawnedPickups")[math.random(1, #getMissionConfigProperty(oldmission, "EnemySpawnedPickups"))]
	local pickupamount = 1.0
	
	
			if(SpawnMissionPickupsOnPlayer(oldmission)) then 
				--local coords = GetEntityCoords(GetPlayerPed(-1))
				--Config.Missions[oldmission].MissionPickups[i].id = CreatePickupRotate(GetHashKey(choosenWeapon),  coords.x,  coords.y, coords.z, 0.0, 0.0, 0.0, 8, pickupamount, 24, 24, true, GetHashKey(choosenWeapon))	
				 getSpawnMissionPickups(oldmission)
			end
			
			if(SpawnMissionComponentsOnPlayer(oldmission)) then 
				--local coords = GetEntityCoords(GetPlayerPed(-1))
				--Config.Missions[oldmission].MissionPickups[i].id = CreatePickupRotate(GetHashKey(choosenWeapon),  coords.x,  coords.y, coords.z, 0.0, 0.0, 0.0, 8, pickupamount, 24, 24, true, GetHashKey(choosenWeapon))	
				 getSpawnMissionComponents(oldmission)
			end			

			
			
			if(Config.Missions[oldmission].MissionPickups) then 					
				
				 for i=1, #Config.Missions[oldmission].MissionPickups do  
					
					if(Config.Missions[oldmission].MissionPickups[i].Name ~="RANDOM") then 
						choosenWeapon = Config.Missions[oldmission].MissionPickups[i].Name 
					end
					
					if(Config.Missions[oldmission].MissionPickups[i].Amount) then 
						pickupamount = Config.Missions[oldmission].MissionPickups[i].Amount 
					end
					
					Config.Missions[oldmission].MissionPickups[i].id = CreatePickupRotate(GetHashKey(choosenWeapon),  Config.Missions[oldmission].MissionPickups[i].Position.x,  Config.Missions[oldmission].MissionPickups[i].Position.y, Config.Missions[oldmission].MissionPickups[i].Position.z, 0.0, 0.0, 0.0, 8, pickupamount, 24, 24, true, GetHashKey(choosenWeapon))

					SetEntityDynamic(Config.Missions[oldmission].MissionPickups[i].id, true)
					SetEntityRecordsCollisions(Config.Missions[oldmission].MissionPickups[i].id, true)
					SetEntityHasGravity(Config.Missions[oldmission].MissionPickups[i].id, true)
					FreezeEntityPosition(Config.Missions[oldmission].MissionPickups[i].id, false)
					SetEntityVelocity(Config.Missions[oldmission].MissionPickups[i].id, 0.0, 0.0, -0.2)
					--DecorSetInt(Config.Missions[input].MissionPickups[i].id,"mrpmpickupid",i)
					
				end
			end			
					

end

--Use RANDOM anymore?
local pedpickups = {}
local pedvpickups = {}
function SpawnPickups(oldmission,rewardPlayer) 
	--not used anymore unlesss 'RANDOM' is used
	local choosenWeapon = getMissionConfigProperty(oldmission, "EnemySpawnedPickups")[math.random(1, #getMissionConfigProperty(oldmission, "EnemySpawnedPickups"))]
	local pickupamount = 1.0
	
		if rewardPlayer then 

			if(SpawnRewardPickupsOnPlayer(oldmission)) then 
				getSpawnRewardPickups(oldmission)
			end

			if(SpawnRewardComponentsOnPlayer(oldmission)) then 
				getSpawnRewardComponents(oldmission)
			end
			--NEED TO DO TWICE TO GET COMPONENTS TO WORK..
			if(SpawnRewardPickupsOnPlayer(oldmission)) then 
				getSpawnRewardPickups(oldmission)
			end

			if(SpawnRewardComponentsOnPlayer(oldmission)) then 
				getSpawnRewardComponents(oldmission)
			end			

			--default in game is 40 rounds for explosive heavy sniper rounds. Alter this for some balance:
			SetPedAmmoByType(GetPlayerPed(-1), 0xADD16CB9, getMissionConfigProperty(oldmission, "SafeHouseSniperExplosiveRoundsGiven"))
			
		end
				
			if(Config.Missions[oldmission].Pickups) then 					
				
				 for i=1, #Config.Missions[oldmission].Pickups do  
					
					if(Config.Missions[oldmission].Pickups[i].Name ~="RANDOM") then 
						choosenWeapon = Config.Missions[oldmission].Pickups[i].Name 
					end
					
					if(Config.Missions[oldmission].Pickups[i].Amount) then 
						pickupamount = Config.Missions[oldmission].Pickups[i].Amount 
					end
					
					Config.Missions[oldmission].Pickups[i].id = CreatePickupRotate(GetHashKey(choosenWeapon),  Config.Missions[oldmission].Pickups[i].Position.x,  Config.Missions[oldmission].Pickups[i].Position.y, Config.Missions[oldmission].Pickups[i].Position.z, 0.0, 0.0, 0.0, 8, pickupamount, 24, 24, true, GetHashKey(choosenWeapon))
					SetEntityDynamic(Config.Missions[oldmission].Pickups[i].id, true)
					SetEntityRecordsCollisions(Config.Missions[oldmission].Pickups[i].id, true)
					SetEntityHasGravity(Config.Missions[oldmission].Pickups[i].id, true)
					FreezeEntityPosition(Config.Missions[oldmission].Pickups[i].id, false)
					SetEntityVelocity(Config.Missions[oldmission].Pickups[i].id, 0.0, 0.0, -0.2)
					--DecorSetInt(Config.Missions[input].Pickups[i].id,"mrppickupid",i)
					
					
				end
			end
			
		--Dead enemies give pickups if enabled
		--Maybe allow for friendly peds to give  pickups as well?
		local pedcnt = 1
		if getPedsCanSpawnPickups(oldmission) then 
			local EnemyChanceToSpawn = getMissionConfigProperty(oldmission, "EnemySpawnedPickupsChance")
			for ped in EnumeratePeds() do
				
				if DecorGetInt(ped, "mrppedid") > 0 and IsEntityDead(ped) and not (DecorGetInt(ped, "mrppedfriend") > 0) then 
					if EnemyChanceToSpawn >= math.random(100) then  
						local choosenWeapon = getMissionConfigProperty(oldmission, "EnemySpawnedPickups")[math.random(1, #getMissionConfigProperty(oldmission, "EnemySpawnedPickups"))]
						local coords = GetEntityCoords(ped)
						--print("choosenWeapon:"..choosenWeapon)
						--chosenWeapon = GetBestPedWeapon(ped,0) --or GetSelectedPedWeapon(ped) --either does not seem to give the weapon they carry
						pedpickups[pedcnt] = CreatePickupRotate(GetHashKey(choosenWeapon), coords.x,  coords.y, coords.z, 0.0, 0.0, 0.0, 8, pickupamount, 24, 24, true, GetHashKey(choosenWeapon))
						pedcnt = pedcnt + 1
					end
				
				end

				if  DecorGetInt(ped, "mrpvpedid") > 0 and IsEntityDead(ped) and not (DecorGetInt(ped, "mrppedfriend") > 0) then
					if EnemyChanceToSpawn >= math.random(100) then  
						local coords = GetEntityCoords(ped)
						local choosenWeapon = getMissionConfigProperty(oldmission, "EnemySpawnedPickups")[math.random(1, #getMissionConfigProperty(oldmission, "EnemySpawnedPickups"))]
						--chosenWeapon = GetBestPedWeapon(ped,0) --GetSelectedPedWeapon(ped) --either does not seem to give the weapon they carry
						pedvpickups[pedcnt] = CreatePickupRotate(GetHashKey(choosenWeapon), coords.x,  coords.y, coords.z, 0.0, 0.0, 0.0, 8, pickupamount, 24, 24, true, GetHashKey(choosenWeapon))			
						pedcnt = pedcnt + 1
					end
					
				end
				
			end		
		end
		
			
			

end

function getPedsCanSpawnPickups(oldmission) 

	
if Config.Missions[oldmission].EnemiesCanSpawnPickups ~= nil then
		return Config.Missions[oldmission].EnemiesCanSpawnPickups
	else
		return Config.EnemiesCanSpawnPickups
	end


end

function RemoveMissionPickup(x,y,z)
		
		for pickup in EnumeratePickups() do
			local coords = GetEntityCoords(pickup)

			if DoesEntityExist(pickup) and GetDistanceBetweenCoords(coords.x,coords.y,coords.z, x, y, z, true) < 1 then
			   --ugh, will not delete no matter what I try, so teleport off map for now
				--for ped drop pickups
				SetEntityCoords(pickup, -10000.647, -10000.97, 0.7186, 0.968)
				RemovePickup(pickup)
			end		

		end	
end


--decor does not work for pickups
function CleanupPickups(oldmission,ishost) 


		
	if ishost then
		if(Config.Missions[oldmission].Pickups and Config.CleanupPickups) then 				
			 for i=1, #Config.Missions[oldmission].Pickups do     
						
				if Config.Missions[oldmission].Pickups[i].id and (DoesPickupExist(Config.Missions[oldmission].Pickups[i].id)) then
						
						SetEntityCoords(Config.Missions[oldmission].Pickups[i].id, -10000.647, -10000.97, 0.7186, 0.968)
						SetEntityAsNoLongerNeeded(Config.Missions[oldmission].Pickups[i].id)
						RemovePickup(Config.Missions[oldmission].Pickups[i].id)
						DeleteObject(Config.Missions[oldmission].Pickups[i].id)				
						
									
				end								
			end
			
			 for i=1, #Config.Missions[oldmission].MissionPickups do     
				if Config.Missions[oldmission].MissionPickups[i].id and (DoesPickupExist(Config.Missions[oldmission].MissionPickups[i].id)) then
						SetEntityCoords(Config.Missions[oldmission].MissionPickups[i].id, -10000.647, -10000.97, 0.7186, 0.968)
						SetEntityAsNoLongerNeeded(Config.Missions[oldmission].MissionPickups[i].id)
						RemovePickup(Config.Missions[oldmission].MissionPickups[i].id)
						DeleteObject(Config.Missions[oldmission].MissionPickups[i].id)				
										
					
								
				end				
				
			end					
		end

	end
	--[[
		if(Config.CleanupPickups and Config.Missions[oldmission].Pickups) then 				
			 for i=1, #Config.Missions[oldmission].Pickups do     
				
					RemoveMissionPickup(Config.Missions[oldmission].Pickups[i].Position.x,Config.Missions[oldmission].Pickups[i].Position.y,Config.Missions[oldmission].Pickups[i].Position.z)
							
			end
			
		end	
		
		if(Config.CleanupPickups and Config.Missions[oldmission].MissionPickups) then 	
			
				 for i=1, #Config.Missions[oldmission].MissionPickups do     
					
						RemoveMissionPickup(Config.Missions[oldmission].MissionPickups[i].Position.x,Config.Missions[oldmission].MissionPickups[i].Position.y,Config.Missions[oldmission].MissionPickups[i].Position.z)		
					
				end
		end
]]--
		--ped drop pickup removal
			if(pedpickups) then 
			--remove ped dropped pickups too	
				for i, v in pairs(pedpickups) do
					SetEntityAsNoLongerNeeded(v)
					RemovePickup(v)
					DeleteObject(v)							
				end
			end
			
			if(pedvpickups) then 
			--remove ped dropped pickups too	
				for i, v in pairs(pedvpickups) do
					SetEntityAsNoLongerNeeded(v)
					RemovePickup(v)
					DeleteObject(v)								
					
				end
			end			
			
			pedpickups = {}
			pedvpickups = {}		

		
end



--MAKE THIS A SERVER EVENT TO MANAGE
AddEventHandler('ExitOldMissionAndStartNewMission',function(oldmission,isfail,reasontext,blGoalReached)
	--choose random mission that is not the old one. 
	--***Config.Missions keys in mission.lua need to be Mission1, Mission2, ....MissionN, MissionN+1***

	--#Config.Missions gives 0, so lets do this: 
	local missioncount = 0;
	for i, v in pairs(Config.Missions) do
		missioncount = missioncount + 1
	end

	local nextmission = ""

	if Config.RandomMissions then
		nextmission = "Mission"..tostring(math.random(1,missioncount))
	else 
		local oldMissionNumber, _ = oldmission:gsub("%D+", "")
		if (tonumber(oldMissionNumber) + 1 > missioncount) then 
			nextmission = "Mission1"
		 else
			nextmission =  "Mission" .. tostring(math.floor((tonumber(oldMissionNumber))) + 1)
		
		end
	end 
	

	if missioncount > 1 then 
		while( nextmission == oldmission )
		do
		   nextmission = "Mission"..tostring( math.random(1,missioncount))
		end
	else 
		nextmission = oldmission 
	end
	
	--finish off old mission
    Active = 0
	TriggerServerEvent("sv:done", MissionName,false,isfail,reasontext,blGoalReached)
   -- TriggerEvent("DONE", MissionName)
    --aliveCheck()
	
	--SpawnPickups(oldmission) 
	--MissionName = "N/A" --GHK DOESNT NEED TO BE CALLED
	

	--do this on the server.
	TriggerServerEvent("sv:checkhostandremovepickups",oldmission, nextmission, Config.MissionSpaceTime)
	--wait for old mission to wrap up. Host player could disconnect here, before new mission starts, whereby another player will need to use /mission , 
	--'sv:checkhostandremovepickups' tries to alert other players of this, if so and start another mission, if the server flag is set
	Citizen.Wait(getMissionSpaceTime(oldmission)) 
	--'host' (mission starter) player can reliably delete the pickups as well, 'sv:checkhostandremovepickups' and might be a better solution to the code between  ----------
	CleanupPickups(oldmission,true)
	
	--Allow the server to do all the work now in getting the next mission
	--It should now call the same code below on the proper NetworkIsHost() client.
	TriggerServerEvent("sv:getHostForNextMission", MissionName)
	--[[
	local rMissionLocationIndex = 0
	local rMissionType = Config.RandomMissionTypes[math.random(1, #Config.RandomMissionTypes)]
	local rIsRandomSpawnAnywhereInfo
			for i, v in pairs(Config.Missions) do
				if nextmission == i then
					if Active == 1 then
						TriggerEvent('chatMessage', "^1[MISSIONS]: ^2Next Mission...There is a mission already in progress.")
					else
					Active = 1
					MissionName = nextmission
					MilliSecondsLeft = getMissionLength(MissionName)
					--MissionName = MissionName
					time = 10000
					--TriggerServerEvent("sv:one", nextmission, Config.Missions[nextmission].MissionTitle, time,rMissionLocationIndex)
					
					if(Config.Missions[nextmission].IsRandom) then 
						
						rMissionLocationIndex = math.random(1, #getMissionConfigProperty(nextmission, "RandomMissionPositions"))
						
						if(getMissionConfigProperty(nextmission, "RandomMissionPositions")[rMissionLocationIndex].force) then
							
							rMissionType = "Objective" --NPCs have a chance of spawning in buildings with forced = true, so Assassinate may hang
						end	

						--this overrides regular IsRandom missions that use defined random positions:
						if(getMissionConfigProperty(MissionName, "IsRandomSpawnAnywhere")) then 
						
							rIsRandomSpawnAnywhereInfo = getRandomAnywhereLocation(MissionName)
							if rIsRandomSpawnAnywhereInfo[2] then 
								--if a water/boat mission, make it only Assassinate
								rMissionType = "Assassinate"
							end
						
						end
						
						

						SetRandomMissionAttributes(nextmission,rMissionType, getMissionConfigProperty(nextmission, "RandomMissionPositions")[rMissionLocationIndex],rIsRandomSpawnAnywhereInfo) 
							
						--local chosenLocation = Config.RandomMissionPositions[math.random(1, rIndex)]					
					end 
					
					TriggerServerEvent("sv:one",nextmission, Config.Missions[nextmission].MissionTitle, time,rMissionLocationIndex,rMissionType,rIsRandomSpawnAnywhereInfo)
					
					if(Config.Missions[nextmission].IsRandom) then 
						TriggerEvent("SpawnRandomPed", nextmission,rMissionType, math.random(getMissionConfigProperty(MissionName, "RandomMissionMinPedSpawns"), getMissionConfigProperty(MissionName, "RandomMissionMaxPedSpawns")), math.random(getMissionConfigProperty(MissionName, "RandomMissionMinVehicleSpawns"),getMissionConfigProperty(MissionName, "RandomMissionMaxVehicleSpawns")),rMissionLocationIndex,rIsRandomSpawnAnywhereInfo)
					else
						TriggerEvent("SpawnPed", nextmission)
					end					
					
					--Wait 5 seconds for peds to spawn on client/host and migrate to other clients.
					--before spawning NPC blips etc..
					--Wait(5000)
					--TriggerServerEvent("sv:one",nextmission, Config.Missions[nextmission].MissionTitle, time,rMissionLocationIndex,rMissionType)
					
					
					
					--TriggerEvent("SpawnPed", nextmission)
					end
				end
			end
			--SpawnProps(oldmission)
			
			]]--
end)

--get the time in milliseconds for reward pickups to be around (if CleanPickups = true) and until next mission is started
function getMissionSpaceTime(oldmission) 

	if Config.Missions[oldmission].MissionSpaceTime ~=nil then

		return Config.Missions[oldmission].MissionSpaceTime
	else
		return Config.MissionSpaceTime
	end


end

function aliveCheck()
    MissionName = MissionName
   
   while Active == 1 do
   --print("alivecheck")
   
		for ped in EnumeratePeds() do

			if ((DecorGetInt(ped, "mrppedid") > 0 or DecorGetInt(ped, "mrpvpedid") > 0)) and IsEntityDead(ped) == 1 then
				local blip = GetBlipFromEntity(ped)
				RemoveBlip(blip)
			end
				
		end
			
			
      
	--[[
	  for i=1, #Config.Missions[MissionName].Peds do
            if IsEntityDead(Config.Missions[MissionName].Peds[i].id) then
                local ped  = Config.Missions[MissionName].Peds[i].id
                local blip = GetBlipFromEntity(ped)
                RemoveBlip(blip)
            end
        end
        for i=1, #Config.Missions[MissionName].Vehicles do
            if IsEntityDead(Config.Missions[MissionName].Vehicles[i].id2) then --change to id2, the ped
                local veh  = Config.Missions[MissionName].Vehicles[i].id2
                local blip = GetBlipFromEntity(veh)
                RemoveBlip(blip)
            end
        end
		]]--
		
        Citizen.Wait(2500)
    end
	

end

--DEBUG CODE
--[[
local Melee = { -1569615261, 1737195953, 1317494643, -1786099057, 1141786504, -2067956739, -868994466 }
  local Knife = { -1716189206, 1223143800, -1955384325, -1833087301, 910830060, }
  local Bullet = { 453432689, 1593441988, 584646201, -1716589765, 324215364, 736523883, -270015777, -1074790547, -2084633992, -1357824103, -1660422300, 2144741730, 487013001, 2017895192, -494615257, -1654528753, 100416529, 205991906, 1119849093 }
  local Animal = { -100946242, 148160082 }
  local FallDamage = { -842959696 }
  local Explosion = { -1568386805, 1305664598, -1312131151, 375527679, 324506233, 1752584910, -1813897027, 741814745, -37975472, 539292904, 341774354, -1090665087 }
  local Gas = { -1600701090 }
  local Burn = { 615608432, 883325847, -544306709 }
  local Drown = { -10959621, 1936677264 }
  local Car = { 133987706, -1553120962 }

  function checkArray (array, val)
	  for name, value in ipairs(array) do
		  if value == val then
			  return true
		  end
	  end
  
	  return false
  end
  ]]--
 -- 
 
 function MakeNeutral(ped)
	if DoesEntityExist(ped) and (not (IsEntityDead(ped) == 1)) then
		--print("MakeNeutral")
		SetPedRelationshipGroupHash(ped, hash)
		SetPedRelationshipGroupHash(Ped, GetHashKey("TRUENEUTRAL"))
		SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("PLAYER"))
		SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("HATES_PLAYER"))
		SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("HOSTAGES"))
		SetRelationshipBetweenGroups(0, GetHashKey("HATES_PLAYER"), GetHashKey("TRUENEUTRAL"))
						
		SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("CIVMALE"))
		SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("CIVFEMALE"))
		SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("COP"))
		SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("SECURITY_GUARD"))
		SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("PRIVATE_SECURITY"))
		SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("FIREMAN"))
		SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("GANG_1"))
		SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("GANG_2"))
		SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("GANG_9"))
		SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("GANG_10"))
		SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_LOST"))
		SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_MEXICAN"))
		SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_FAMILY"))
		SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_BALLAS"))
		SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_MARABUNTE"))
		SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_CULT"))
		SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_SALVA"))
		SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_WEICHENG"))
		SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AMBIENT_GANG_HILLBILLY"))
		SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("DEALER"))
		SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("WILD_ANIMAL"))
		SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("SHARK"))
		--SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("HATES_PLAYER"))
		SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("COUGAR"))
		SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("NO_RELATIONSHIP"))
		SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("SPECIAL"))
		SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION2"))		
		SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("NO_RELATIONSHIP"))
		SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("SPECIAL"))
		SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION2"))			
		SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION3"))
		SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION4"))
		SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION5"))			
		SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION6"))
		SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION7"))
		SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MISSION8"))			
		SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("ARMY"))
		SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("GUARD_DOG"))
		SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("AGGRESSIVE_INVESTIGATE"))						
		SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("MEDIC"))
		SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("PRISONER"))	
		SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("DOMESTIC_ANIMAL"))	
		SetRelationshipBetweenGroups(5, GetHashKey("TRUENEUTRAL"), GetHashKey("ISDEFENDTARGET"))		
		--ClearPedTasksImmediately(ped)
	end
 
 end
 
 
 
 --parachute debug:
--[[
Citizen.CreateThread(function()
	
	
	while true do
	
		--Citizen.Wait(60000) -- check minute
		Citizen.Wait(1) 
		for ped in EnumeratePeds() do
			if(IsPedFalling(ped) and not (IsEntityDead(ped) == 1) and DecorGetInt(ped, "mrppedskydiver") > 0) then 
					--GiveWeaponToPed(ped, GetHashKey("GADGET_PARACHUTE"), true)
					if(GetPedParachuteState(ped)==-1) then 
					
						GiveWeaponToPed(ped, GetHashKey("GADGET_PARACHUTE"), 1, false, true)
						SetCurrentPedWeapon(ped, GetHashKey("GADGET_PARACHUTE"), true)
						SetPedGadget(ped, 0xFBAB5776, true) --prachute
						ClearPedTasksImmediately(ped)
						SetPedParachuteTintIndex(ped, 6)
						ForcePedToOpenParachute(ped)
						print("give para")
						
					end
					--print("PARACHUTE equip:"..tostring(GetCurrentPedWeapon(ped, 0xFBAB5776, 1)))
					--print("PARACHUTE:"..GetPedParachuteState(ped))
					--TaskParachute(ped)
				end
				
				if(IsPedInParachuteFreeFall(ped) and not (IsEntityDead(ped) == 1) and DecorGetInt(ped, "mrppedskydiver") > 0) then
					--ClearPedTasksImmediately(ped)
					if(GetPedParachuteState(ped)==0) then 
						--DecorSetInt(ped,"mrppedskydiver",1)
						SetPedParachuteTintIndex(ped, 6)
						ForcePedToOpenParachute(ped)
					--elseif(GetPedParachuteState(ped)==2) then
						--equip with micro-smg
						print("has para")
						--SetCurrentPedWeapon(ped, GetHashKey("WEAPON_MICROSMG"), true) --GetBestPedWeapon(ped, p1)
					end
					
					--print("PARACHUTE equip:"..tostring(GetCurrentPedWeapon(ped, 0xFBAB5776, 1)))
					--print("PARACHUTE:"..GetPedParachuteState(ped))
				end
				
				
				if(not (IsPedFalling(ped) or IsPedInParachuteFreeFall(ped)) and not (IsEntityDead(ped) == 1) and not IsPedInAnyVehicle(ped)) then 
					if(DecorGetInt(ped, "mrppedskydiver") > 0) then
							makeEntityFaceEntity(ped,playerPed)
							--TaskWanderStandard(ped,10.0, 10)
							TaskCombatPed(ped, playerPed, 0, 16)
							DecorSetInt(ped,"mrppedskydiver",0)
							print("other")
						
					end
				--elseif (IsPedFalling(ped) or IsPedInParachuteFreeFall(ped)) then 
					--DecorSetInt(ped,"mrppedskydiver",1)
				end
				
				if (IsEntityDead(ped) == 1) and not IsPedInAnyVehicle(ped) and (DecorGetInt(ped, "mrppedskydiverexplode") > 0) then --and (DecorGetInt(ped, "mrppedskydiverexplode") > 0) then
					local pos = GetEntityCoords(ped)
					print("explode")
					NetworkExplodeVehicle(nil,true,true,true) 
					AddExplosion(PlayerPed,pos.x, pos.y, pos.z, 60, 1.0, true, false,0.0)
					AddExplosion(PlayerPed,pos.x, pos.y, pos.z, 59, 1.0, true, false,0.0)
					AddExplosion(PlayerPed,pos.x, pos.y, pos.z, 31, 1.0, true, false,0.0)
					DecorSetInt(ped,"mrppedskydiver",0)
					DecorSetInt(ped,"mrppedskydiverexplode",0)			
				end
				
				--dont allow NPCs in parachutes to conquer, until they hit the ground
				if(GetPedParachuteState(ped)==2 and not (IsEntityDead(ped) == 1)) then
					--ideally send to server like hostage rescue to be set on all clients, if non-host
					--but it might be too much/inefficient? 
					SetPedParachuteTintIndex(ped, 6)
					DecorSetInt(ped,"mrppedskydiverexplode",0)
					DecorSetInt(ped,"mrppedskydiver",1)
					--ClearPedTasksImmediately(ped)
						print("parachute deployed")
						--SetCurrentPedWeapon(ped, GetHashKey("WEAPON_MICROSMG"), true) --GetBestPedWeapon(ped, p1)
				end						
	
		
		end
		
	end
		
	
end)

 ]]--
 
 
 local relationshipTypes = {
"PLAYER",
"CIVMALE",
"CIVFEMALE",
"COP",
"SECURITY_GUARD",
"PRIVATE_SECURITY",
"FIREMAN",
"GANG_1",
"GANG_2",
"GANG_9",
"GANG_10",
"AMBIENT_GANG_LOST",
"AMBIENT_GANG_MEXICAN",
"AMBIENT_GANG_FAMILY",
"AMBIENT_GANG_BALLAS",
"AMBIENT_GANG_MARABUNTE",
"AMBIENT_GANG_CULT",
"AMBIENT_GANG_SALVA",
"AMBIENT_GANG_WEICHENG",
"AMBIENT_GANG_HILLBILLY",
"DEALER",
"HATES_PLAYER",
--"HEN",
--"WILD_ANIMAL",
--"SHARK",
--"COUGAR",
"NO_RELATIONSHIP",
"SPECIAL",
"MISSION2",
"MISSION3",
"MISSION4",
"MISSION5",
"MISSION6",
"MISSION7",
"MISSION8",
"ARMY",
--"GUARD_DOG",
"AGGRESSIVE_INVESTIGATE",
"MEDIC",
--"CAT",
}

local RELATIONSHIP_HATE = 5
local RELATIONSHIP_COMPANION = 0

Citizen.CreateThread(function()
    while true do
        Wait(50)
		
		if Config.HostileAmbientPeds and Config.HostileAmbientPeds > 0 then 
		   for _, group in ipairs(relationshipTypes) do
				-- not sure about argument order, players don't have AI so only one of these should be needed
				--SetRelationshipBetweenGroups(RELATIONSHIP_HATE, GetHashKey('PLAYER'), GetHashKey(group))
				SetRelationshipBetweenGroups(RELATIONSHIP_HATE, GetHashKey(group), GetHashKey('PLAYER'))
				SetRelationshipBetweenGroups(RELATIONSHIP_COMPANION,  GetHashKey(group), GetHashKey(group))
				
				--try to minimize infighting on the whole: 
				if Config.HostileAmbientPeds == 1 then
					
					SetRelationshipBetweenGroups(RELATIONSHIP_COMPANION,  GetHashKey('CIVMALE'), GetHashKey('CIVFEMALE'))
					SetRelationshipBetweenGroups(RELATIONSHIP_COMPANION,  GetHashKey('CIVFEMALE'), GetHashKey('CIVMALE'))
					SetRelationshipBetweenGroups(RELATIONSHIP_COMPANION,  GetHashKey('CIVMALE'), GetHashKey("HATES_PLAYER"))
					SetRelationshipBetweenGroups(RELATIONSHIP_COMPANION,  GetHashKey('CIVFEMALE'), GetHashKey("HATES_PLAYER"))
					SetRelationshipBetweenGroups(RELATIONSHIP_COMPANION,  GetHashKey('CIVMALE'), GetHashKey('TRUENEUTRAL'))
					SetRelationshipBetweenGroups(RELATIONSHIP_COMPANION,  GetHashKey('CIVFEMALE'), GetHashKey('TRUENEUTRAL'))
				elseif  Config.HostileAmbientPeds == 3 then --riot mode, virtually all ambient peds hate each other.
					SetRelationshipBetweenGroups(RELATIONSHIP_HATE,  GetHashKey('CIVMALE'), GetHashKey('CIVFEMALE'))
					SetRelationshipBetweenGroups(RELATIONSHIP_HATE,  GetHashKey('CIVFEMALE'), GetHashKey('CIVMALE'))
					SetRelationshipBetweenGroups(RELATIONSHIP_HATE,  GetHashKey('CIVMALE'), GetHashKey('CIVMALE'))
					SetRelationshipBetweenGroups(RELATIONSHIP_HATE,  GetHashKey('CIVFEMALE'), GetHashKey('CIVFEMALE'))
					
				end
			end
		end	
	
		
    end
end)
 
 
 --IsPedArmed is not working, so had to do workarounds
 function doHostileZone(Ped) 
 
 	--if armed with anything other than fists or if a mrp specific ped, exit
	--print("unarmed:"..tostring(GetBestPedWeapon(Ped,0)==GetHashKey("WEAPON_UNARMED")))
	--IsPedArmed(Ped, 7)
	
	if (not IsPedHuman(Ped)) or DecorGetInt(Ped,"mrppedhostilezone") > 0 or DecorGetInt(Ped,"mrppedid") > 0 or DecorGetInt(Ped,"mrpvpedid") > 0 or DecorGetInt(Ped,"mrppedsafehouse") > 0 
	or(GetPedRelationshipGroupDefaultHash(Ped)==GetHashKey('PLAYER') or GetPedRelationshipGroupHash(Ped)==GetHashKey('PLAYER')) or (GetBestPedWeapon(Ped,0)~=GetHashKey("WEAPON_UNARMED"))
	then 
		return
	end
	--print("do hostile made it")
	--print(GetPedRelationshipGroupDefaultHash(Ped))
	local randomPedWeapon = getMissionConfigProperty(MissionName, "RandomHostileZoneWeapons")[math.random(1, #getMissionConfigProperty(MissionName, "RandomHostileZoneWeapons"))]
	local randomVehiclePedWeaponHash = getMissionConfigProperty(MissionName, "RandomHostileZoneVehicleWeapons")[math.random(1, #getMissionConfigProperty(MissionName, "RandomHostileZoneVehicleWeapons"))]
	
	--SetPedRelationshipGroupDefaultHash(Ped,GetHashKey("HATES_PLAYER"))
	--print("new:"..GetPedRelationshipGroupDefaultHash(Ped))
	--SetPedRelationshipGroupHash(Ped, GetHashKey("HATES_PLAYER"))

	--DecorSetInt(Ped,"mrppedhostilezone",1)
	--if true then
		--return
	--end
	if(not IsPedInAnyVehicle(Ped)) then 
		SetPedCombatAttributes(Ped, 5, true)
		SetPedCombatAttributes(Ped, 46, true)
		SetPedDiesWhenInjured(Ped, true)
		GiveWeaponToPed(Ped, randomPedWeapon, 2800, false, true)
		SetPedInfiniteAmmo(Ped, true, randomPedWeapon)	
		
	else --must be in vehicle
		SetPedCombatAttributes(Ped, 5, true)	
		SetPedCombatAttributes(Ped, 16, true)
		SetPedCombatAttributes(Ped, 46, true)
		SetPedCombatAttributes(Ped, 26, true)
		SetPedCombatAttributes(Ped, 2, true)
		SetPedCombatAttributes(Ped, 1, true) --can use vehicles
		--50% chance to leave vehicle if armed with neither (melee or explosive):
		SetPedDiesWhenInjured(Ped, true)
		
		local PedVehicle = GetVehiclePedIsIn(Ped, false)
		local pmodel = GetEntityModel(PedVehicle)
		
		local hasDriveByWeapon = false
		
		
		
		if IsThisModelABike(pmodel) or IsThisModelABicycle(pmodel) or IsThisModelAQuadbike(pmodel) or  IsThisModelABoat(pmodel) then
			randomVehiclePedWeaponHash = getMissionConfigProperty(MissionName, "RandomHostileZoneBikeQuadBoatVehicleWeapons")[math.random(1, #getMissionConfigProperty(MissionName, "RandomHostileZoneBikeQuadBoatVehicleWeapons"))]
			
			if 
			(randomVehiclePedWeaponHash == 0x1B06D571 or randomVehiclePedWeaponHash == 0xBFE256D4 or randomVehiclePedWeaponHash == 0x5EF9FEC4 or randomVehiclePedWeaponHash == 0x22D8FE39 or randomVehiclePedWeaponHash == 0x3656C8C1 or
			randomVehiclePedWeaponHash == 0x99AEEB3B or randomVehiclePedWeaponHash ==  0xBFD21232 or randomVehiclePedWeaponHash == 0x88374054 or randomVehiclePedWeaponHash == 0xD205520E or randomVehiclePedWeaponHash ==  0x83839C4 or 
			randomVehiclePedWeaponHash == 0x47757124 or randomVehiclePedWeaponHash == 0xDC4DB296 or randomVehiclePedWeaponHash == 0xC1B3C3D1 or randomVehiclePedWeaponHash == 0xCB96392F or randomVehiclePedWeaponHash == 0x97EA20B8 or 
			randomVehiclePedWeaponHash == 0x13532244 or randomVehiclePedWeaponHash == 0xDB1AA450 or randomVehiclePedWeaponHash == 0xBD248B55 or randomVehiclePedWeaponHash == 0x0781FE4A or randomVehiclePedWeaponHash == 0x624FE830 or randomVehiclePedWeaponHash == 0x12E82D3D
			)
			then
				hasDriveByWeapon = true
			end			
							
		
		else
		
			if 
			(randomVehiclePedWeaponHash == 0x1B06D571 or randomVehiclePedWeaponHash == 0xBFE256D4 or randomVehiclePedWeaponHash == 0x5EF9FEC4 or randomVehiclePedWeaponHash == 0x22D8FE39 or randomVehiclePedWeaponHash == 0x3656C8C1 or
			randomVehiclePedWeaponHash == 0x99AEEB3B or randomVehiclePedWeaponHash ==  0xBFD21232 or randomVehiclePedWeaponHash == 0x88374054 or randomVehiclePedWeaponHash == 0xD205520E or randomVehiclePedWeaponHash ==  0x83839C4 or 
			randomVehiclePedWeaponHash == 0x47757124 or randomVehiclePedWeaponHash == 0xDC4DB296 or randomVehiclePedWeaponHash == 0xC1B3C3D1 or randomVehiclePedWeaponHash == 0xCB96392F or randomVehiclePedWeaponHash == 0x97EA20B8 or 
			randomVehiclePedWeaponHash == 0x13532244 or randomVehiclePedWeaponHash == 0xDB1AA450 or randomVehiclePedWeaponHash == 0xBD248B55 
			)
			then
				hasDriveByWeapon = true
			end
			
		end		
		
		GiveWeaponToPed(Ped, randomVehiclePedWeaponHash, 2800, false, true)
		SetPedInfiniteAmmo(Ped, true, randomVehiclePedWeaponHash)	
		--print(" IsPedArmed(Ped, 7):".. tostring(Citizen.InvokeNative(0x475768A975D5AD17, Ped, 7)))
		
		--is ped carrying any drive-by compatible weapons? if so, 1 in 2 chance of staying in the vehicle
		if math.random(1,2) > 1 and hasDriveByWeapon then
		--( IsPedArmed(Ped, 3)) then 
			SetPedCombatAttributes(Ped, 3, false)
		end
		
	end
	
	SetPedFleeAttributes(Ped, 0, 0)
	SetPedPathAvoidFire(Ped,1)
	SetPedPathCanUseLadders(Ped,1)
	SetPedPathCanDropFromHeight(Ped,1)
	SetPedPathCanUseClimbovers(Ped,1)
	SetPedDropsWeaponsWhenDead(Ped, getMissionConfigProperty(MissionName, "SetPedDropsWeaponsWhenDead"))
	SetPedAlertness(Ped,3)	
	if(randomPedWeapon == 0x42BF8A85) then 
		--minigun
		SetPedFiringPattern(Ped, 0x914E786F) --FIRING_PATTERN_BURST_FIRE_HELI
	end	
	if getMissionConfigProperty(MissionName, "FastFiringPeds") then 
		SetPedFiringPattern(Ped, 0xC6EE6B4C) --FIRING_PATTERN_AUTO
	end 			
	ResetAiWeaponDamageModifier()
	SetAiWeaponDamageModifier(1.0) -- 1.0 == Normal Damage. 
	AddArmourToPed(Ped, 100) --<**is 100 max for npc???**
	SetPedArmour(Ped, 100)
	
	--instigate a fight: no need!
	--if(math.random(1,10)> 9) then 
		--TaskCombatPed(Ped,GetPlayerPed(-1))
		--print("do hostile made it")
	--end
	--SetEntityCanBeDamagedByRelationshipGroup(Ped, false, GetHashKey("HATES_PLAYER"))
	--SetEntityCanBeDamagedByRelationshipGroup(Ped, false, GetHashKey("TRUENEUTRAL"))
	
 
 
 end
 --[[
 function doHostileZone(Ped) 
 
	--if armed with anything other than fists or if a mrp specific ped, exit
	if IsPedArmed(Ped, 7) or DecorGetInt(Ped,"mrppedhostilezone") > 0 or DecorGetInt(Ped,"mrppedid") > 0 or DecorGetInt(Ped,"mrpvpedid") > 0 or DecorGetInt(Ped,"mrppedsafehouse") > 0 then 
		return
	end
	print("do hostile made it")
	--print(GetPedRelationshipGroupDefaultHash(Ped))
	local randomPedWeapon = getMissionConfigProperty(MissionName, "RandomHostileZoneWeapons")[math.random(1, #getMissionConfigProperty(MissionName, "RandomHostileZoneWeapons"))]
	local randomVehiclePedWeaponHash = getMissionConfigProperty(MissionName, "RandomHostileZoneVehicleWeapons")[math.random(1, #getMissionConfigProperty(MissionName, "RandomHostileZoneVehicleWeapons"))]
	SetPedAsEnemy(Ped)
	
	SetPedRelationshipGroupDefaultHash(Ped,GetHashKey("HATES_PLAYER"))
	--print("new:"..GetPedRelationshipGroupDefaultHash(Ped))
	SetPedRelationshipGroupHash(Ped, GetHashKey("HATES_PLAYER")) --SetPedRelationshipGroupDefaultHash
	SetRelationshipBetweenGroups(5, GetHashKey("HATES_PLAYER"), GetHashKey("PLAYER"))
	SetRelationshipBetweenGroups(0, GetHashKey("HATES_PLAYER"), GetHashKey("HATES_PLAYER"))
	SetRelationshipBetweenGroups(5, GetHashKey("HATES_PLAYER"), GetHashKey("ISDEFENDTARGET"))
	SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("HATES_PLAYER"))	
	SetRelationshipBetweenGroups(0, GetHashKey("HATES_PLAYER"), GetHashKey("TRUENEUTRAL"))		
	--DecorSetInt(Ped,"mrppedhostilezone",1)
	if(not IsPedInAnyVehicle(Ped)) then 
		SetPedCombatAttributes(Ped, 5, true)
		SetPedCombatAttributes(Ped, 46, true)
		SetPedDiesWhenInjured(Ped, true)
		GiveWeaponToPed(Ped, randomPedWeapon, 2800, false, true)
		SetPedInfiniteAmmo(Ped, true, randomPedWeapon)	
		
	else --must be in vehicle
		SetPedCombatAttributes(Ped, 5, true)	
		SetPedCombatAttributes(Ped, 16, true)
		SetPedCombatAttributes(Ped, 46, true)
		SetPedCombatAttributes(Ped, 26, true)
		SetPedCombatAttributes(Ped, 2, true)
		SetPedCombatAttributes(Ped, 1, true) --can use vehicles
		--50% chance to leave vehicle:
		if math.random(1,2) > 1 then 
			SetPedCombatAttributes(Ped, 3, false)
		end
		SetPedDiesWhenInjured(Ped, true)
		GiveWeaponToPed(Ped, randomVehiclePedWeaponHash, 2800, false, true)
		SetPedInfiniteAmmo(Ped, true, randomVehiclePedWeaponHash)		
	end
	SetPedFleeAttributes(Ped, 0, 0)
	SetPedPathAvoidFire(Ped,1)
	SetPedPathCanUseLadders(Ped,1)
	SetPedPathCanDropFromHeight(Ped,1)
	SetPedPathCanUseClimbovers(Ped,1)
	SetPedDropsWeaponsWhenDead(Ped, getMissionConfigProperty(MissionName, "SetPedDropsWeaponsWhenDead"))
	SetPedAlertness(Ped,3)	
	if(randomPedWeapon == 0x42BF8A85) then 
		--minigun
		SetPedFiringPattern(Ped, 0x914E786F) --FIRING_PATTERN_BURST_FIRE_HELI
	end	
	if getMissionConfigProperty(MissionName, "FastFiringPeds") then 
		SetPedFiringPattern(Ped, 0xC6EE6B4C) --FIRING_PATTERN_AUTO
	end 			
	ResetAiWeaponDamageModifier()
	SetAiWeaponDamageModifier(1.0) -- 1.0 == Normal Damage. 
	AddArmourToPed(Ped, 100) --<**is 100 max for npc???**
	SetPedArmour(Ped, 100)
	--SetEntityCanBeDamagedByRelationshipGroup(Ped, false, GetHashKey("HATES_PLAYER"))
	--SetEntityCanBeDamagedByRelationshipGroup(Ped, false, GetHashKey("TRUENEUTRAL"))
	
	
 end
 ]]
 --DEBUG:
 local resetZcount = 0 
 -- 
function calcMissionStats() 
	local totalTargets = 0
	local totalDeadTargets = 0
	local targetPedsKilledByPlayer = 0
	local nontargetPedsKilledByPlayer = 0
	local hostagesKilledByPlayer = 0
	local totalDeadHostages = 0
	local totalRescuedHostages = 0
	local hasBeenConquered = 0
	local isDefendTargetDead = 0
	local isDefendTargetRescued = 0
	local isDefendTargetKilledByPlayer = 0
	local vehiclePedsKilledByPlayer = 0
	local bossPedsKilledByPlayer = 0
	local totalRescuedObjects = 0
	local isDefendGoalReached = 0
	
	
	local playerPed = GetPlayerPed(-1)
	local pcoords = GetEntityCoords(playerPed,true)
	
	
	
	
		for ped in EnumerateVehicles() do
		
		
		
		if DecorGetInt(ped, "mrpvehdid") > 0 and DecorGetInt(ped, "mrpvehdidGround") > 0  then 
			local ecoords = GetEntityCoords(ped,true)
			
			if ecoords.z == 0.0 then
				--print("vehped at 0.0.."..DecorGetInt(ped, "mrpvehdid"))
			end
			
			if GetDistanceBetweenCoords(pcoords,ecoords,false) <= 600 then
				
				
				local Z =ecoords.z+999.0
				local ground,posZ = GetGroundZFor_3dCoord(ecoords.x+.0,ecoords.y+.0,Z,1)
				
				if ground then 
					if IsThisModelAPlane(GetEntityModel(ped)) or IsThisModelAHeli(GetEntityModel(ped)) then 
						posZ = posZ + ecoords.z
						SetHeliBladesFullSpeed(ped) -- works for planes I guess
						SetVehicleEngineOn(ped, true, true, false)
						SetVehicleForwardSpeed(ped, 90.0)
						SetVehicleLandingGear(ped, 3) --make sure landing gear is retracted						
						
					end
					FreezeEntityPosition(ped,false)
					SetEntityCoords(ped,ecoords.x+.0, ecoords.y+.0,posZ)
					DecorSetInt(ped,"mrpvehdidGround",0)
					
					TriggerServerEvent("sv:setgroundingdecor",DecorGetInt(ped, "mrpvehdid"),"mrpvehdid")
				end	
			end
			
		end
		
		end
		for ped in EnumeratePeds() do
			
			local isNPCDead = (IsEntityDead(ped) ==1 or GetEntityHealth(ped) < 100 or DecorGetInt(ped, "mrppedead") > 0) 
			
			
			if  DecorGetInt(ped, "mrppeddefendtarget") > 0  then
			
				 GlobalTargetPed = ped
				
			
			end
			
			
			--[[
			if  DecorGetInt(ped, "mrppedsafehouse") == 1 and not PlayingAnimL and PedLeaderModel  then
			
		
				 TriggerEvent('SafeHouseAnims',{ent=nil,model=PedDoctorModel},{ent=ped,model=PedLeaderModel},input)
				
			
			end
			
			if  DecorGetInt(ped, "mrppedsafehouse") == 2 and not PlayingAnimD and PedDoctorModel then
			print("hey2")
				 TriggerEvent('SafeHouseAnims',{ent=ped,model=PedDoctorModel},{ent=nil,model=PedLeaderModel},input)
		
				
			
			end			
			]]--
			if not isNPCDead and DecorGetInt(ped, "mrpvpeddriverid") > 0 and GlobalTargetPed then 
			
			
				if  Active == 1 and MissionName ~="N/A" and (not IsPedOnFoot(otherped)) and Config.Missions[MissionName].IsVehicleDefendTargetChase then 
					
					local pedveh = GetVehiclePedIsIn(ped, false)
					local vmodel =  GetEntityModel(pedveh)
					if not (IsThisModelAPlane(vmodel) or IsThisModelAHeli(vmodel)) then 	
								
						local otherpc  = GetEntityCoords(GlobalTargetPed)
						local pc  = GetEntityCoords(ped)											
												
						if GetDistanceBetweenCoords(otherpc.x,otherpc.y,otherpc.z,pc.x,pc.y,pc.z,true) <= getMissionConfigProperty(MissionName,"IsDefendTargetVehicleAttackDistance") then 
													--SetBlockingOfNonTemporaryEvents(otherped,false)
													
							TaskCombatPed(ped,GlobalTargetPed,0, 16)
						else																
													--TaskVehicleEscort(otherped, GetVehiclePedIsIn(otherped, false), GetVehiclePedIsIn(ped, false), 0,1200.0, 0, 5.0, -1, 2000)
						end
					end 
				end									
			
				
			
			end

			
			if (DecorGetInt(ped, "mrppedid") > 0 or DecorGetInt(ped, "mrpvpedid") > 0)  then
			
	
			
			
				if DecorGetInt(ped, "mrppedid") > 0 and DecorGetInt(ped, "mrpvehdidGround") > 0  then 
					local ecoords = GetEntityCoords(ped,true)
					--print("set ")
				if ecoords.z == 0.0 then
					--print("mrppedid at 0.0.."..DecorGetInt(ped, "mrppedid"))
				end
					if GetDistanceBetweenCoords(pcoords,ecoords,false) <= 300 then
				
				
						local Z =ecoords.z+999.0
						local ground,posZ = GetGroundZFor_3dCoord(ecoords.x+.0,ecoords.y+.0,Z,1)
					
						if ground then 

							FreezeEntityPosition(ped,false)
							SetEntityCoords(ped,ecoords.x+.0, ecoords.y+.0,posZ)
							DecorSetInt(ped,"mrpvehdidGround",0)
							
							TriggerServerEvent("sv:setgroundingdecor",DecorGetInt(ped, "mrppedid"),"mrppedid")
						end	
					end
			
				end
				
				--[[
				if DecorGetInt(ped, "mrpvpedid") > 0 and DecorGetInt(ped, "mrpvehdidGround") > 0  then 
					local ecoords = GetEntityCoords(ped,true)
					
					if GetDistanceBetweenCoords(pcoords,ecoords,true) <= 300 then
				
				
						local Z =ecoords.z+999.0
						local ground,posZ = GetGroundZFor_3dCoord(ecoords.x+.0,ecoords.y+.0,Z,1)
					
						if ground then 

							FreezeEntityPosition(ped,false)
							SetEntityCoords(ped,ecoords.x+.0, ecoords.y+.0,posZ)
							DecorSetInt(ped,"mrpvehdidGround",0)
							
							TriggerServerEvent("sv:setgroundingdecor",DecorGetInt(ped, "mrpvpedid"),"mrpvpedid")
						end
					end
			
				end				
				
			]]--
			
				--SetEntityVisible(ped,true)
				--SetEntityAlpha(ped, 255, false)
				--SetEntityAlpha(ped, 255, true)
				--need to keep track of peds killed by player vehicles, which source the killer as the vehicle, not the player
				if(GetPedKiller(ped)==GetVehiclePedIsIn(playerPed, false) and not IsPedOnFoot(playerPed)) then 
					--print("KILLED BY PLAYER PED VEHICLE:"..GetPedKiller(ped))
					DecorSetInt(ped,"mrppedkilledbyplayervehicle",1)
				end	
			
				if (DecorGetInt(ped, "mrppedtarget") > 0) then	
					totalTargets = totalTargets + 1
					--[[if(getMissionConfigProperty(MissionName, "DrawText3D")) and not IsEntityDead(ped)  then
						
							local o1 = GetEntityCoords(ped, true)
							if(GetDistanceBetweenCoords(o1.x,o1.y,o1.z, pcoords.x, pcoords.y, pcoords.z, true) < 30) then						
								
								--DrawText3D({x = o1.x, y =o1.y, z = o1.z}, "~r~Enemy Target ($"..getTargetKillReward(MissionName)..")", 0.6)	
							
								DrawText3D({x = o1.x, y =o1.y, z = o1.z + 1.0}, "~r~Target", 1.0)		
							end
						
		
					end
					]]--
				end
				
				--[[ DISABLED FOR NOW
				--check for rogue spawns that have z < GroundZ within collision range of the player. Reset them if so. 
				--Only on land.	Only for IsRandom = true, IsRandomSpawnAnywhere = true	missions
				--regular IsRandom will allow spawning in 
				--NetworkIsHost() only?
				if(getMissionConfigProperty(MissionName, "CheckAndFixRandomSpawns")) and  (getMissionConfigProperty(MissionName, "IsRandom")) and not (DecorGetInt(ped, "mrpcheckspawn") > 0) then --and getMissionConfigProperty(MissionName, "IsRandomSpawnAnywhere")) then 
					local NPCcoords = GetEntityCoords(ped)
					local PCcoords = GetEntityCoords(playerPed)
					local watertest = GetWaterHeight(NPCcoords.x,NPCcoords.y,NPCcoords.z)
					local raytestsuccess=false
					--print("watertest:"..tostring(watertest))
					--only care about x, y distance, also NPC may be very -z as well
					if not(isNPCDead) and GetDistanceBetweenCoords(NPCcoords.x,NPCcoords.y,0.0, PCcoords.x, PCcoords.y, 0.0, true) < 100 and not(watertest  == 1 or watertest  == true)  
					then 
						
						if not IsRandomMissionForceSpawning then
							local unusedBool, spawnZ = GetGroundZFor_3dCoord(NPCcoords.x,NPCcoords.y, 9999.0, 0)
							--print("NPCcoords.z:"..NPCcoords.z)
							--print("spawnZ:"..spawnZ)							
							
							if(NPCcoords.z < spawnZ) then 
									
								if(not IsPedInAnyVehicle(ped, false)) then 
									resetZcount =  resetZcount + 1
									--dont do for vehicles
									--local pedveh =  GetVehiclePedIsIn(ped, false)
									--SetEntityCoords(pedveh,NPCcoords.x,NPCcoords.y,spawnZ+3.0)
									--print("found "..resetZcount.." rogue spawn, reseting the z coord spawnZ:"..spawnZ)
									--Notify("~r~found "..resetZcount.." rogue spawn, reseting the z coord spawnZ:"..spawnZ)				
								--else
									--print("found "..resetZcount.." rogue spawn, reseting the z coord spawnZ:"..spawnZ)
									--Notify("found "..resetZcount.." rogue spawn, reseting the z coord spawnZ:"..spawnZ)							
									SetEntityCoords(ped,NPCcoords.x,NPCcoords.y,spawnZ+1.0)
									DecorSetInt(ped, "mrpcheckspawnset",1)
								end
								
							end
							DecorSetInt(ped, "mrpcheckspawn",1)
							--print("mrpcheckspawn"..resetZcount)
							
							
							
						else 
							DecorSetInt(ped, "mrpcheckspawn",1)
						
						end
						
					end
				end 
				]]--
				--[[
				if getMissionConfigProperty(MissionName, "IsRandom") and getMissionConfigProperty(MissionName, "IsRandomSpawnAnywhere") then
					if(GetDistanceBetweenCoords(coords.x,coords.y,0.0, Config.Missions[MissionName].Marker.Position.x, Config.Missions[MissionName].Marker.Position.y, 0.0, true) <250) then
						
						local unusedBool, groundZ = GetGroundZFor_3dCoord(Config.Missions[MissionName].Marker.Position.x,Config.Missions[MissionName].Marker.Position.y, Config.Missions[MissionName].Marker.Position.z, 0)
						print("1setz")
						if(groundZ ~=Config.Missions[MissionName].Marker.Position.z) then
							Config.Missions[MissionName].Marker.Position.z = groundz
							print("2setz")
							if(Config.Missions[MissionName].Props[1].id) then
								Config.Missions[MissionName].Props[1].Position.x = groundz
							end
						end
							
					end
				end
				]]--
				if IsEntityDead(ped)  == 1 then
					--DEBUG CODE
					--[[local d = GetPedCauseOfDeath(ped)
					  if checkArray(Melee, d) then
						  Notify('hardmeele')
					  elseif checkArray(Bullet, d) then
						  Notify('bullet')
					  elseif checkArray(Knife, d) then
						  Notify('knifes')
					  elseif checkArray(Animal, d) then
						  Notify('bitten')
					  elseif checkArray(FallDamage, d) then
						  Notify('brokenlegs')
					  elseif checkArray(Explosion, d) then
						  Notify('explosive')
					  elseif checkArray(Gas, d) then
						  Notify('gas')
					  elseif checkArray(Burn, d) then
						  Notify('fire')
					  elseif checkArray(Drown, d) then
						  Notify('drown')
					  elseif checkArray(Car, d) then
						  Notify('caraccident')
					  else
						  Notify('unknown')
					  end
					  ]]--
					-- 
					 
					if (DecorGetInt(ped, "mrppedtarget") > 0) then	
						totalDeadTargets = totalDeadTargets + 1

						if(GetPedKiller(ped)==playerPed) or (DecorGetInt(ped,"mrppedkilledbyplayervehicle") > 0) then
							targetPedsKilledByPlayer = targetPedsKilledByPlayer + 1
						end	

					elseif(DecorGetInt(ped, "mrppedfriend") > 0)  then
							totalDeadHostages = totalDeadHostages + 1
						if(GetPedKiller(ped)==playerPed)  or (DecorGetInt(ped,"mrppedkilledbyplayervehicle") > 0) then
							hostagesKilledByPlayer = hostagesKilledByPlayer +1
						end	
					elseif(DecorGetInt(ped, "mrppeddefendtarget") > 0)  then
							--totalDeadHostages = totalDeadHostages + 1
						if(GetPedKiller(ped)==playerPed)  or (DecorGetInt(ped,"mrppedkilledbyplayervehicle") > 0) then
							isDefendTargetKilledByPlayer = 1
						end			
						
			
					elseif IsEntityDead(ped) == 1 then 
					
						if(GetPedKiller(ped)==playerPed) or (DecorGetInt(ped,"mrppedkilledbyplayervehicle") > 0) then
							nontargetPedsKilledByPlayer = nontargetPedsKilledByPlayer + 1
						end	
					
					end
					
					if(DecorGetInt(ped, "mrpvpeddriverid") > 0)   then
						if(GetPedKiller(ped)==playerPed) or (DecorGetInt(ped,"mrppedkilledbyplayervehicle") > 0) then
								
							vehiclePedsKilledByPlayer = vehiclePedsKilledByPlayer + 1
						end
					end 
					if(DecorGetInt(ped, "mrppedboss") > 0)   then
						if(GetPedKiller(ped)==playerPed) or (DecorGetInt(ped,"mrppedkilledbyplayervehicle") > 0) then
								
							bossPedsKilledByPlayer = bossPedsKilledByPlayer + 1
						end
					end 					
					
				end	
				--print("made it")
				if (DecorGetInt(ped, "mrppedfriend") > 0 and not (IsEntityDead(ped) == 1) )  then
						--print("found friendly")
					
					--[[
						if getMissionConfigProperty(MissionName, "DrawText3D") then  --and getMissionConfigProperty(MissionName, "HostageRescueReward") ~= 0 or getHostageKillPenalty(MissionName) ~=0 )then
								local o1 = GetEntityCoords(ped, true)
								if(GetDistanceBetweenCoords(o1.x,o1.y,o1.z, pcoords.x, pcoords.y, pcoords.z, true) < 30) then												
								
								--DrawText3D({x = o1.x, y =o1.y, z = o1.z}, "~g~Friendly Rescue: ($"..getMissionConfigProperty(MissionName, "HostageRescueReward").."), Kill:($-"..getHostageKillPenalty(MissionName)..")", 0.6)
									DrawText3D({x = o1.x, y =o1.y, z = o1.z + 1.0}, "~g~Friendly Rescue", 1.0)
								end
						end							
						]]--
						if IsEntityAtEntity(playerPed, ped, 1.0, 1.0, 2.0, 0, 1, 0) and IsPedOnFoot(playerPed) then
							
							if not (securingRescue == DecorGetInt(ped, "mrppedfriend") and securingRescueType == 0)then 								
								securingRescue = DecorGetInt(ped, "mrppedfriend")
								securingRescueType = 0
								--print(type(RescueMarkers))
								TriggerEvent("SecureObjRescue",playerPed,ped,securingRescueType)
							end
							--print("rescued friendly")
							--TriggerServerEvent("sv:rescuehostage",DecorGetInt(ped,"mrppedfriend"))
							--[[
							TriggerServerEvent("sv:rescuehostage",DecorGetInt(ped,"mrppedfriend"),"mrppedfriend")
							SetEntityInvincible(ped,true)
							ClearPedTasksImmediately(ped)
							DecorSetInt(ped,"mrppedfriend", 0)
							TaskSmartFleePed(ped, playerPed, 10000.0, -1) 
							if blRemoveRescuedHostage then 
								DeleteEntity(ped)
							end
							if not DecorGetInt(playerPed,"mrprescuecount") then 
								DecorSetInt(playerPed,"mrprescuecount", 1)
							else 
								DecorSetInt(playerPed,"mrprescuecount",(DecorGetInt(playerPed,"mrprescuecount") + 1))
							end
							
							--print("mrprescuecount:"..DecorGetInt(playerPed,"mrprescuecount"))
							
							
							totalRescuedHostages = totalRescuedHostages + 1
							]]--
						elseif securingRescue == DecorGetInt(ped, "mrppedfriend") and securingRescueType == 0 then 
							securingRescue = 0
							securingRescueType = -1
						end			
				
				end
				
				
				if getMissionConfigProperty(MissionName, "IsDefend") and (not getMissionConfigProperty(MissionName, "IsDefendTarget"))  and (not (IsEntityDead(ped) == 1)) and (DecorGetInt(ped, "mrppedfriend") == 0 and DecorGetInt(ped, "mrppeddefendtarget") == 0 and DecorGetInt(ped, "mrppedsafehouse") == 0  and DecorGetInt(ped, "mrppedskydiver") == 0) then 
					--print("2hasBeenConquered CHECK")
					local coords  --= vector3(0.0,0.0,0.0)
					
					local pvehicle = GetVehiclePedIsUsing(ped)
					
					local aircraft = false
					
					if pvehicle ~= 0 then --GetVehiclePedIsIn(ped, false)
						--print("hasBeenConquered vped")
					
						coords =  GetEntityCoords(GetVehiclePedIsUsing(ped))
						--print("vehcoords:"..coords.x.."|"..coords.y.."|"..coords.z)
						local pmodel = GetEntityModel(pvehicle)
						
						if IsThisModelAHeli(pmodel) or IsThisModelAPlane(pmodel) then
							aircraft = true
						end
						
					else 
						--print("hasBeenConquered ped")
						coords =  GetEntityCoords(ped)
						--print("pedcoords:"..coords.x.."|"..coords.y.."|"..coords.z)
					end
					
					--workaround for random anywhere missions where ground z was not found.
					if (Config.Missions[MissionName].Marker.Position.z <=0.0) then 
					
						if(GetDistanceBetweenCoords(coords.x,coords.y,0.0, Config.Missions[MissionName].Marker.Position.x, Config.Missions[MissionName].Marker.Position.y, 0.0, true) < Config.Missions[MissionName].Marker.Size.x / 2) and not aircraft then--print("coords:"..coords.x.."|"..coords.y.."|"..coords.z)
							--print("markercoords:"..Config.Missions[MissionName].Marker.Position.x.."|".. Config.Missions[MissionName].Marker.Position.y.."|".. Config.Missions[MissionName].Marker.Position.z)
							--print("distance:"..GetDistanceBetweenCoords(coords.x,coords.y,coords.z, Config.Missions[MissionName].Marker.Position.x, Config.Missions[MissionName].Marker.Position.y, Config.Missions[MissionName].Marker.Position.z, true))
							--print("hasBeenConquered true")
							hasBeenConquered = 1 

						end
					else
						if(GetDistanceBetweenCoords(coords.x,coords.y,coords.z, Config.Missions[MissionName].Marker.Position.x, Config.Missions[MissionName].Marker.Position.y, Config.Missions[MissionName].Marker.Position.z, true) < Config.Missions[MissionName].Marker.Size.x / 2) and not aircraft then
							--print("coords:"..coords.x.."|"..coords.y.."|"..coords.z)
							--print("markercoords:"..Config.Missions[MissionName].Marker.Position.x.."|".. Config.Missions[MissionName].Marker.Position.y.."|".. Config.Missions[MissionName].Marker.Position.z)
							--print("distance:"..GetDistanceBetweenCoords(coords.x,coords.y,coords.z, Config.Missions[MissionName].Marker.Position.x, Config.Missions[MissionName].Marker.Position.y, Config.Missions[MissionName].Marker.Position.z, true))
							--print("hasBeenConquered true")
							hasBeenConquered = 1 

						end			
					
					end
						
				end	
				
				--IsDefendTarget is dead?
				if getMissionConfigProperty(MissionName, "IsDefend") and getMissionConfigProperty(MissionName, "IsDefendTarget") and (DecorGetInt(ped, "mrppeddefendtarget") > 0) then 
						
							--print("isdefendetarget found")
					if(IsEntityDead(ped) == 1) then
						isDefendTargetDead = 1
					
					elseif (getMissionConfigProperty(MissionName, "IsDefendTargetRescue")) then  
							--print("isdefendetarget rescue found")
						if IsEntityAtEntity(playerPed, ped, 1.0, 1.0, 2.0, 0, 1, 0) and IsPedOnFoot(playerPed) then
								
							if not (securingRescue == DecorGetInt(ped, "mrppeddefendtarget") and securingRescueType == 1)then 						
							
								securingRescue = DecorGetInt(ped, "mrppeddefendtarget")							
								securingRescueType = 1
								TriggerEvent("SecureObjRescue",playerPed,ped,securingRescueType)
							end
							--[[
							--print("rescued isdefendetarget")
							TriggerServerEvent("sv:rescuehostage",DecorGetInt(ped,"mrppeddefendtarget"),"mrppeddefendtarget")
							SetEntityInvincible(ped,true)
							ClearPedTasksImmediately(ped)
							DecorSetInt(ped,"mrppeddefendtarget", 0)
							TaskSmartFleePed(ped, playerPed, 10000.0, -1) 
							if blRemoveRescuedHostage then 
								DeleteEntity(ped)
							end
							if not DecorGetInt(playerPed,"mrprescuetarget") then 
								DecorSetInt(playerPed,"mrprescuetarget", 1)
							else 
								DecorSetInt(playerPed,"mrprescuetarget",(DecorGetInt(playerPed,"mrprescuetarget") + 1))
							end
							--print("mrprescuecount:"..DecorGetInt(playerPed,"mrprescuecount"))
							isDefendTargetRescued = 1
							]]--
						elseif securingRescue == DecorGetInt(ped, "mrppeddefendtarget") and securingRescueType == 1 then 
							asecuringRescueType = -1
							securingRescue = 0							
						
						end

					elseif (getMissionConfigProperty(MissionName, "IsDefendTargetRewardBlip")) then
						local otherpc  = GetEntityCoords(ped)
						
						if GetDistanceBetweenCoords(otherpc.x,otherpc.y,otherpc.z,Config.Missions[MissionName].Blip.Position.x, Config.Missions[MissionName].Blip.Position.y,Config.Missions[MissionName].Blip.Position.z,true) <= getMissionConfigProperty(MissionName,"IsDefendTargetGoalDistance") then			
							isDefendGoalReached=1
								--print ("made it calc")		
							
						end
					
					
					end
					--[[
					if isDefendTargetDead ~= 1 then 
						--print("isdefendetarget found")
						if getMissionConfigProperty(MissionName, "DrawText3D") then --and getMissionConfigProperty(MissionName, "IsDefendTargetRescueReward") ~= 0 or getMissionConfigProperty(MissionName, "IsDefendTargetKillPenalty") ~=0 )then
							local o1 = GetEntityCoords(ped, true)
							if(GetDistanceBetweenCoords(o1.x,o1.y,o1.z, pcoords.x, pcoords.y, pcoords.z, true) < 30) then									
								--DrawText3D({x = o1.x, y =o1.y, z = o1.z}, "~y~Rescue Target: ($"..getMissionConfigProperty(MissionName, "IsDefendTargetRescueReward").."), 		Kill:($-"..getMissionConfigProperty(MissionName, "IsDefendTargetKillPenalty")..")", 0.6)
								DrawText3D({x = o1.x, y =o1.y, z = o1.z +1.0}, "~y~Rescue Target", 1.0)	
							end
						end				
						
					end					
					]]--
				
				end
				
				
				if ((DecorGetInt(ped, "mrppedboss")) > 0 or (DecorGetInt(ped, "mrppedmonster")) > 0 ) then --and not (IsEntityDead(ped) == 1)   then
					--make bosses have a chance of dying with ragdoll
					if(GetEntityHealth(ped)< 125) then 
						SetPedCanRagdoll(ped, true) 
					end
				
				end				
				
				--[[ removed parachutes and enemy rcbandito
				--see '--parachute debug' section further down in file. 
				--may act funky on clients who did not call
				if(IsPedFalling(ped) and not (IsEntityDead(ped) == 1) and DecorGetInt(ped, "mrppedskydiver") > 0) then 
					--GiveWeaponToPed(ped, GetHashKey("GADGET_PARACHUTE"), true)
					if(GetPedParachuteState(ped)==-1) then 
					
						GiveWeaponToPed(ped, GetHashKey("GADGET_PARACHUTE"), 1, false, true)
						SetCurrentPedWeapon(ped, GetHashKey("GADGET_PARACHUTE"), true)
						SetPedGadget(ped, 0xFBAB5776, true) --prachute
						ClearPedTasksImmediately(ped)
						SetPedParachuteTintIndex(ped, 6)
						ForcePedToOpenParachute(ped)
						--print("give para")
						
					end
					--print("PARACHUTE equip:"..tostring(GetCurrentPedWeapon(ped, 0xFBAB5776, 1)))
					--print("PARACHUTE:"..GetPedParachuteState(ped))
					--TaskParachute(ped)
				end
				
				if(IsPedInParachuteFreeFall(ped) and not (IsEntityDead(ped) == 1) and DecorGetInt(ped, "mrppedskydiver") > 0) then
					--ClearPedTasksImmediately(ped)
					if(GetPedParachuteState(ped)==0) then 
						--DecorSetInt(ped,"mrppedskydiver",1)
						SetPedParachuteTintIndex(ped, 6)
						ForcePedToOpenParachute(ped)
					--elseif(GetPedParachuteState(ped)==2) then
						--equip with micro-smg
						--print("has para")
						--SetCurrentPedWeapon(ped, GetHashKey("WEAPON_MICROSMG"), true) --GetBestPedWeapon(ped, p1)
					end
					
					--print("PARACHUTE equip:"..tostring(GetCurrentPedWeapon(ped, 0xFBAB5776, 1)))
					--print("PARACHUTE:"..GetPedParachuteState(ped))
				end
				
				
				if(not (IsPedFalling(ped) or IsPedInParachuteFreeFall(ped)) and not (IsEntityDead(ped) == 1) and not IsPedInAnyVehicle(ped)) then 
					if(DecorGetInt(ped, "mrppedskydiver") > 0) then
							makeEntityFaceEntity(ped,playerPed)
							--TaskWanderStandard(ped,10.0, 10)
							TaskCombatPed(ped, playerPed, 0, 16)
							DecorSetInt(ped,"mrppedskydiver",0)
							--print("other"..tostring(IsPedOnFoot(ped)))
							
						
					end
				--elseif (IsPedFalling(ped) or IsPedInParachuteFreeFall(ped)) then 
					--DecorSetInt(ped,"mrppedskydiver",1)
				end
				
				if (IsEntityDead(ped) == 1) and not IsPedInAnyVehicle(ped) and (DecorGetInt(ped, "mrppedskydiverexplode") > 0) then --and (DecorGetInt(ped, "mrppedskydiverexplode") > 0) then
					local ppos = GetEntityCoords(playerPed)
					local pos = GetEntityCoords(ped)
					--print("explode")
					--StartScriptFire(pos.x, pos.y, pos.z,25, false)
					--NetworkExplodeVehicle(nil,true,true,true) 
					--AddExplosion(PlayerPed,pos.x, pos.y, pos.z, 60, 1.0, true, false,0.0)
					--AddExplosion(PlayerPed,pos.x, pos.y, pos.z, 59, 1.0, true, false,0.0)
					--AddExplosion(PlayerPed,pos.x, pos.y, pos.z, 31, 1.0, true, false,0.0)
					DecorSetInt(ped,"mrppedskydiver",0)
					DecorSetInt(ped,"mrppedskydiverexplode",0)			
				end
				
				--dont allow NPCs in parachutes to conquer, until they hit the ground
				if(GetPedParachuteState(ped)==2 and not (IsEntityDead(ped) == 1)) then
					--ideally send to server like hostage rescue to be set on all clients, if non-host
					--but it might be too much/inefficient? 
					SetPedParachuteTintIndex(ped, 6)
					DecorSetInt(ped,"mrppedskydiverexplode",0)
					DecorSetInt(ped,"mrppedskydiver",1)
					local randomPedWeaponHash = getMissionConfigProperty(MissionName, "RandomMissionVehicleWeapons")[math.random(1, #getMissionConfigProperty(MissionName, "RandomMissionVehicleWeapons"))]
					GiveWeaponToPed(ped, randomPedWeaponHash, 2800, false, true)	
					--ClearPedTasksImmediately(ped)
						--print("parachute deployed")
						--SetCurrentPedWeapon(ped, GetHashKey("WEAPON_MICROSMG"), true) --GetBestPedWeapon(ped, p1)
				end	
				

				
				
				
				--transport vehicles para-drop and get out of vehicles
				if(IsPedInAnyVehicle(ped)) and  (not (IsEntityDead(ped) == 1)) then 
					local pedVeh = GetVehiclePedIsIn(ped,false)
					if ped ~= GetPedInVehicleSeat(pedVeh,-1) and getMissionConfigProperty(MissionName, "RandomMissionTransportVehicles")[GetDisplayNameFromVehicleModel(GetEntityModel(pedVeh))]  then --and in transport vehicle
						local coords = GetEntityCoords(ped)
						local pcoords = GetEntityCoords(playerPed)
					
						--if x, y distance 150 meters from the player, then deploy
						if(GetDistanceBetweenCoords(coords.x,coords.y,0.0, pcoords.x, pcoords.y, 0.0, true) < 250) then 
							--print("less than 250")
							if getMissionConfigProperty(MissionName, "FastFiringPeds") then 
								SetPedFiringPattern(ped, 0xC6EE6B4C) --FIRING_PATTERN_AUTO
							 end
			
							if(IsPedInFlyingVehicle(ped)) then 
								--TaskRappelFromHeli(ped, 1)
								--ideally send to server like hostage rescue to be set on all clients, if non-host
								--but it might be too much/inefficient? 
								SetPedCombatAttributes(ped, 3, true)
								TaskLeaveVehicle(ped, pedVeh, 4160) --or 4160? ==16
								DecorSetInt(ped,"mrppedskydiver",1)
								DecorSetInt(ped,"mrppedskydiverexplode",1)
								--make them fly away
								--MakeNeutral(GetPedInVehicleSeat(pedVeh, -1))
								
							--else
								--if(DecorGetInt(ped,"mrppedskydiver") > 0) then
								--	print("get out of vehicle")
									
								--	SetPedCombatAttributes(ped, 3, true)
								--	TaskLeaveVehicle(ped, pedVeh, 4160) --or 4160?	16
								--	DecorSetInt(ped,"mrppedskydiver",1)
								--	TaskGoToEntity(ped,playerPed, -1, 5.0, 20.0,1073741824, 0)
								--	SetPedKeepTask(ped,true) 	
								--end
										
							end
						end
						
					end

					--NPC rcbandito, explode if < 5m away from playerPed
					if(tostring(GetEntityModel(GetVehiclePedIsIn(ped, false))) == "-286046740") then	
						local coords =  GetEntityCoords(pedVeh, true)
						local pcoords = GetEntityCoords(playerPed,true)
						--if(GetDistanceBetweenCoords(coords.x,coords.y,0.0, pcoords.x, pcoords.y, 0.0, true) < 250) then 
							--TaskVehicleDriveToCoordLongrange(ped, pedVeh, pcoords.x, pcoords.y, pcoords.z, 120.0, 0, 0.0)
							--TaskVehicleMissionPedTarget(ped, pedVeh, playerPed, 1, 120.0, 0, 0.0, 0.0, 1) 
							
						--end
						if(GetDistanceBetweenCoords(coords.x,coords.y,0.0, pcoords.x, pcoords.y, 0.0, true) < 5) then 
							NetworkExplodeVehicle(pedVeh,true,true,true) 
							AddExplosion(coords.x, coords.y, coords.z, 60, 1.0, true, false,0.0)
							AddExplosion(coords.x, coords.y, coords.z, 59, 1.0, true, false,0.0)
							AddExplosion(coords.x, coords.y, coords.z, 31, 1.0, true, false,0.0)
							
						end
					end			
						
					
				end	
				

				]]--
				

				--[[
				if doParaDrop then 
					print("doparadrop")
					TriggerEvent("doParadrop",pcoords)
					TriggerServerEvent("sv:doParadrop")
					doParaDrop=false
					thisClientDidParadrop=true
				end
				]]--
				
				--deal with blips for all clients
				--check remove alive check?
				if not isNPCDead then 
				
					--parachute code v2 
					--[[
					if DecorGetInt(ped, "mrppedid") > 0 and thisClientDidParadrop then
				
						local height = GetEntityHeightAboveGround(ped)
						local paraState = GetPedParachuteState(ped) 
						if paraState == -1 then 
							--SetEntityRecordsCollisions(ped,true)
						end	
						
						if height > 10 and (not IsPedOnFoot(ped) and not IsPedInAnyVehicle(ped,false)) or IsPedFalling(ped) then 
							--SetPedCanRagdoll(ped,true)
							SetPedSeeingRange(ped, 10.0)
							SetPedHearingRange(ped, 10.0)
							SetPedKeepTask(ped,1)
							
							if paraState ~= 2 and paraState ~=1 then 
								print("hey1")
								GiveDelayedWeaponToPed(ped,GetHashKey("GADGET_PARACHUTE"),300,1)
								SetPedParachuteTintIndex(ped, 6)
								
								TaskParachuteToTarget(ped,pcoords.x,pcoords.y,pcoords.z)
								
								RegisterTarget(ped,playerPed)
							else 
								--print("hey2")
								SetParachuteTaskTarget(ped,pcoords.x,pcoords.y,pcoords.z)
							end
					
						elseif height > 10 and paraState == 1 then --print
							--SetPedParachuteTintIndex(ped, 6)
										
						elseif height > 10 and paraState == 2 and DecorGetInt(ped, "mrppedskydiver") < 1 then --print
							print("hey3")
							--SetPedParachuteTintIndex(ped, 6)
							SetParachuteTaskTarget(ped,pcoords.x,pcoords.y,pcoords.z)
							TaskCombatPed(playerPed,0,16)
							DecorSetInt(ped, "mrppedskydiver",1)
						end
						
						if DecorGetInt(ped, "mrppedskydiver") > 0 and  paraState ~= 2 and paraState ~=1 then 
							--print("hey 4")
							SetPedSeeingRange(ped, 10000.0)
							SetPedHearingRange(ped, 10000.0)
							ClearPedTasks(ped)
							TaskCombatHatedTargetsAroundPed(ped,500.0,0)
							DecorSetInt(ped, "mrppedskydiver",0)
							--DecorRemove
						end						
						
						
					end
					]]--
					
				--Do Paradrop Peds
				if Config.Missions[MissionName].Events then 
					for k,v in pairs(Config.Missions[MissionName].Events) do
						if Config.Missions[MissionName].Events[k].Type =="Paradrop" and Config.Missions[MissionName].Events[k].done == GetPlayerServerId(PlayerId()) then 
							doParadropPeds(isNPCDead,ped,k,playerPed,pcoords)
						end					
					end
				end
				
					local oldblip = GetBlipFromEntity(ped)
					--RemoveBlip(oldblip)
					--if oldblip == 0 then 
					--if not DoesBlipExist(oldblip) then
						--print('does blip exist')
						--print('blip?:'..tostring(DoesBlipExist(oldblip)))
						--print('ped:'..tostring(DecorGetInt(ped, "mrppedid")))
						--print('vped'..tostring(DecorGetInt(ped, "mrpvpedid")))
					--end
					
					
					
					if not DoesBlipExist(oldblip) and DecorGetInt(ped, "mrppedfriend") ~= -1 then 


						if DecorGetInt(ped, "mrppedtarget") > 0 and GetBlipColour(oldblip) ~= 7 then
							--print('fixed target')
							SetBlipColour(oldblip, 7) --purple
							
						end
						
						local Size     = 0.9
						local pedblip = AddBlipForEntity(ped)
						SetBlipScale  (pedblip, Size)
						SetBlipAsShortRange(pedblip, false)
						
						
						if DecorGetInt(ped, "mrppedtarget") > 0 then
						--if DecorGetInt(ped, "mrppedtarget") > 0 then
							--print('ENEMY PEDT')
							--SetBlipSprite(pedblip, 433)
							SetBlipColour(pedblip, 7) --purple
							BeginTextCommandSetBlipName("STRING")
							if DecorGetInt(ped, "mrppedboss") > 0 then 
								rtotal = getTargetKillReward(MissionName) + getMissionConfigProperty(MissionName, "KillBossPedBonus")
								AddTextComponentString("Enemy Target ($"..rtotal..")")							
							else
								AddTextComponentString("Enemy Target ($"..getTargetKillReward(MissionName)..")")
							end
							
							
							
							EndTextCommandSetBlipName(pedblip)	
							
							--if(Config.DrawText3D and getTargetKillReward(MissionName) ~= 0 )then
								--local o1 = GetEntityCoords(ped, true)
							--	DrawText3D({x = o1.x, y =o1.y, z = o1.z}, "~r~Enemy Target ($"..getTargetKillReward(MissionName)..")", 0.6)							
							--end
										
						elseif DecorGetInt(ped, "mrppedfriend") > 0 then
							--SetBlipSprite(pedblip, 280)
							--print('ENEMY PEDF')
							SetBlipColour(pedblip, 2)	
							BeginTextCommandSetBlipName("STRING")
							--AddTextComponentString("Friend ($-"..getHostageKillPenalty(MissionName)..")")
							AddTextComponentString("Friendly Rescue: ($"..getMissionConfigProperty(MissionName, "HostageRescueReward").."), Kill:($-"..getHostageKillPenalty(MissionName)..")")
							EndTextCommandSetBlipName(pedblip)	
						
									
						elseif DecorGetInt(ped, "mrppedsafehouse") > 0 then
							--SetBlipSprite(pedblip, 280)
							--print('ENEMY PEDF')
							SetBlipColour(pedblip, 3)	
							BeginTextCommandSetBlipName("STRING")
							AddTextComponentString("Mission Safe House Support")
							EndTextCommandSetBlipName(pedblip)	
						
						elseif DecorGetInt(ped, "mrppeddefendtarget") > 0 then
							--SetBlipSprite(pedblip, 280)
							--print('ENEMY PEDF')
							
							local atext = "Rescue Target: ($"..getMissionConfigProperty(MissionName, "IsDefendTargetRescueReward").."),"
							if getMissionConfigProperty(MissionName, "IsDefendTargetRewardBlip") then 
								
								atext = "Help Asset to Destination: ($"..getMissionConfigProperty(MissionName, "GoalReachedReward").."),"
							
							elseif  getMissionConfigProperty(MissionName, "IsDefendTargetRescue") then 
								atext = "Rescue Asset: ($"..getMissionConfigProperty(MissionName, "IsDefendTargetRescueReward").."),"
							
							end
							
							SetBlipColour(pedblip, 5)	
							BeginTextCommandSetBlipName("STRING")
							AddTextComponentString(atext .. " Kill:($-"..getMissionConfigProperty(MissionName, "IsDefendTargetKillPenalty")..")")
							EndTextCommandSetBlipName(pedblip)	
							
							--if(Config.DrawText3D and getMissionConfigProperty(MissionName, "IsDefendTargetRescueReward") ~= 0 or getMissionConfigProperty(MissionName, "IsDefendTargetKillPenalty") ~=0 )then
								--local o1 = GetEntityCoords(ped, true)
								--DrawText3D({x = o1.x, y =o1.y, z = o1.z}, "~y~Rescue Target: ($"..getMissionConfigProperty(MissionName, "IsDefendTargetRescueReward").."), Kill:($-"..getMissionConfigProperty(MissionName, "IsDefendTargetKillPenalty")..")", 0.6)							
							--end													
							
								
						--exclude rescued hostages that are set to -1		
						else
							--print('ENEMY PED'.. DecorGetInt(ped, "mrppedfriend"))
							BeginTextCommandSetBlipName("STRING")
							if DecorGetInt(ped, "mrppedboss") > 0 then 
								rtotal = getKillReward(MissionName) + getMissionConfigProperty(MissionName, "KillBossPedBonus")
								AddTextComponentString("Enemy ($"..rtotal..")")
							else
								AddTextComponentString("Enemy ($"..getKillReward(MissionName)..")")
							end
							--AddTextComponentString("Enemy ($"..getKillReward(MissionName)..")")
							EndTextCommandSetBlipName(pedblip)	

							--if(Config.DrawText3D and getKillReward(MissionName) ~= 0 )then
								--local o1 = GetEntityCoords(ped, true)
								--DrawText3D({x = o1.x, y =o1.y, z = o1.z}, "~r~Enemy ($"..getKillReward(MissionName)..")", 0.6)							
							--end							
								
						end			
						--lastfound = GetGameTimer()
						--i = i + 1
					
					--DEBUG:
					--else
					
						--[[
						--DEBUG:
						 if DecorGetInt(ped, "mrpcheckspawnset") > 0 then
								local pedblip = GetBlipFromEntity(ped)
								print('RESET Z')
								--SetBlipSprite(pedblip, 433)
								SetBlipColour(pedblip, 46)
								--BeginTextCommandSetBlipName("STRING")
								--AddTextComponentString("RESET Z")
								--EndTextCommandSetBlipName(pedblip)	
							
						 end													
						]]--
					end 				
				
				elseif isNPCDead then
				
					if(DecorGetInt(ped, "mrppedead") == 0) then
						
						DecorSetInt(ped, "mrppedead",1) 
					end
					local oldblip = GetBlipFromEntity(ped)
					if  DoesBlipExist(oldblip) then 
		
						RemoveBlip(oldblip)
					end				
				
				
				
				end
			
			--elseif Config.HostileAmbientPeds and Config.HostileAmbientPeds > 0 then 
				--local pcoords = GetEntityCoords(ped) --(GetPlayerPed(-1))
				--print("do 1 hostile zone")
				
				--local coords = GetEntityCoords(GetPlayerPed(-1)) --(GetPlayerPed(-1))
				--local pcoords = GetEntityCoords(ped) --(GetPlayerPed(-1))
				
				--print(GetDistanceBetweenCoords(pcoordsx,pcoords.y,pcoords.z,coordsx,coords.y,coords.z,true))
				
				--print(GetDistanceBetweenCoords(pcoords.x,pcoords.y,pcoords.z,Config.Missions[MissionName].Marker.Position.x,Config.Missions[MissionName].Marker.Position.y,Config.Missions[MissionName].Marker.Position.z,false))
				
				--if GetDistanceBetweenCoords(coords.x,coords.y,coords.z,Config.Missions[MissionName].Marker.Position.x,Config.Missions[MissionName].Marker.Position.y,Config.Missions[MissionName].Marker.Position.z,false) <= getMissionConfigProperty(MissionName, "HostileZoneRadius") then 
					--print("do hostile zone")
					--doHostileZone(ped)
				--end
			end
			
			--START SHOW OTHER PLAYER BLIPS----
			if IsPedAPlayer(ped) and ped ~= playerPed and IsEntityDead(ped) ~=1 then
				local oldblip = GetBlipFromEntity(ped)
				if not DoesBlipExist(oldblip) then 
					local Size     = 0.9
					local pedblip = AddBlipForEntity(ped)
					SetBlipScale  (pedblip, Size)
					SetBlipAsShortRange(pedblip, false)
					SetBlipColour(pedblip, 4)	
					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString("Player")
					EndTextCommandSetBlipName(pedblip)							
				end
			
			elseif IsPedAPlayer(ped) and ped ~= playerPed and IsEntityDead(ped) ==1 then 
				local oldblip = GetBlipFromEntity(ped)
				if  DoesBlipExist(oldblip) then 
					--print("hey")
					RemoveBlip(oldblip)
				end				
			
			end
			--END SHOW OTHER PLAYER BLIPS----
		end	
	
	--if getMissionConfigProperty(MissionName, "Type") == "ObjectiveRescue" then
		
		for obj in EnumerateObjects() do
						
					playerPed = GetPlayerPed(-1)
					
					if getMissionConfigProperty(MissionName, "Type") == "Objective" and getMissionConfigProperty(MissionName, "IsRandom") and  (DecorGetInt(obj, "mrppropobj") > 0  )  then
						
						--local ObjectivePos = GetEntityCoords(obj)
						--print(ObjectivePos.z)
						--local testz = GetGroundZFor_3dCoord(ObjectivePos.x,ObjectivePos.y,ObjectivePos.z)
						
						--local foundGZ, testz = GetGroundZFor_3dCoord(ObjectivePos.x,ObjectivePos.y,99999.0) 
						
						--print(math.abs(testz - ObjectivePos.z))
						--if ObjectivePos.z < 0.0 then 
					
					local ObjectivePos = GetEntityCoords(obj)
					local p1 = GetEntityCoords(playerPed, true)
					if (DecorGetInt(obj, "mrppropobj") == 1 )  then
						--print("found object")
						local p1 = GetEntityCoords(playerPed, true)
						if GetDistanceBetweenCoords(p1.x,p1.y,p1.z,ObjectivePos.x,ObjectivePos.y,ObjectivePos.z,false) <= 250 then
							
							local ground,posZ = GetGroundZFor_3dCoord(ObjectivePos.x,ObjectivePos.y,ObjectivePos.z + 999.0)
							if ground then 
								--print('found ground and posz:'..posZ)
								DecorSetInt(obj,"mrppropobj",2)
								--DecorSetFloat(obj,"mrppropobjz",posZ)
								--print("obj xyz:")
								--print(ObjectivePos.x)
								--print(ObjectivePos.y)
								--print(ObjectivePos.z)
								if ObjectivePos and ObjectivePos.x and ObjectivePos.y and posZ then
								--	print('SET OBECTIVE: '..posZ)
									SetEntityCoords(obj,ObjectivePos.x,ObjectivePos.y,posZ)
								end
								PlaceObjectOnGroundProperly(obj)
								---print('object placed')
							end
							
							--PlaceObjectOnGroundProperly(obj)
							
							ObjectivePos = GetEntityCoords(obj)
							--print('object placed')
						end
					end 
					
					--HACK only show for host within 100m, like non-hosts
					if GetDistanceBetweenCoords(p1.x,p1.y,p1.z,ObjectivePos.x,ObjectivePos.y,ObjectivePos.z,false) <= 100 then					
						--[[
						local ocoords = GetEntityCoords(obj,true)
						print("obj z is:"..ocoords.z)
						print("decor z is:"..DecorGetFloat(obj,"mrppropobjz"))
						if ocoords.z < DecorGetFloat(obj,"mrppropobjz") then
							print ('setting to :'.. tostring(DecorGetFloat(obj,"mrppropobjz")))
							SetEntityCoords(obj,ObjectivePos.x,ObjectivePos.y,DecorGetFloat(obj,"mrppropobjz"))
							PlaceObjectOnGroundProperly(obj)
							--DecorSetFloat(obj,"mrppropobjz")
						elseif DecorGetFloat(obj,"mrppropobjz") <=0.0 then 
							local ground,posZ = GetGroundZFor_3dCoord(ObjectivePos.x,ObjectivePos.y,ObjectivePos.z + 999.0)
							if ground then 
								SetEntityCoords(ObjectivePos.x,ObjectivePos.y,posZ)
								print ('now setting to :'.. tostring(posZ))
							end
						
						
						end 
						
						]]--
						local oldblip = GetBlipFromEntity(obj)
						if not DoesBlipExist(oldblip) then 
							local Size     = 0.9
							local pedblip = AddBlipForEntity(obj)
							SetBlipScale  (pedblip, Size)
							SetBlipAsShortRange(pedblip, false)
							SetBlipColour(pedblip, 70)	
							BeginTextCommandSetBlipName("STRING")
							AddTextComponentString("Objective ($"..getMissionConfigProperty(MissionName, "FinishedObjectiveReward")..")")
							EndTextCommandSetBlipName(pedblip)							
						end	
					end
					
						--if foundGZ == 1 and (math.abs(testz - ObjectivePos.z) > 1.0  or ObjectivePos.z < 0)
						--then 
						--	print("UNDER 0.0: "..testz)
						--	print("old:"..ObjectivePos.z)
							--ObjectivePos.z = GetGroundZFor_3dCoord(ObjectivePos.x,ObjectivePos.y,800.0)
							--PlaceObjectOnGroundProperly(obj)
							--SetEntityCoords(obj,ObjectivePos.x,ObjectivePos.y,1.0*testz)
								--PlaceObjectOnGroundProperly(obj)
							--print("new:"..ObjectivePos.z)
						--end
						
						Config.Missions[MissionName].Marker.Position.x = ObjectivePos.x
						Config.Missions[MissionName].Marker.Position.y = ObjectivePos.y
						Config.Missions[MissionName].Marker.Position.z = ObjectivePos.z
						
						--Config.Missions[MissionName].Blip.Position.x = ObjectivePos.x
						--Config.Missions[MissionName].Blip.Position.y = ObjectivePos.y
						--Config.Missions[MissionName].Blip.Position.z = ObjectivePos.z						
		
					end
					
					if (DecorGetInt(obj, "mrpproprescue") > 0)  then
						  --PlaceObjectOnGroundProperly(obj)
						
			--if Config.Missions[MissionName].Props[1].id then 
				--local o1 = GetEntityCoords(obj, true)
				--DrawText3D({x = o1.x, y =o1.y, z = o1.z}, 'Press [~g~SHIFT~w~] and [~g~E~w~] to push the vehicle', 0.6)
				
			--end
			
	
						local o1 = GetEntityCoords(obj, true)
						--[[
						if(getMissionConfigProperty(MissionName, "DrawText3D"))then
							if GetDistanceBetweenCoords(pcoords.x,pcoords.y,pcoords.z,o1.x,o1.y,o1.z,true) <= 30 then	
								--DrawText3D({x = o1.x, y =o1.y, z = o1.z}, "~o~Objective ($"..getMissionConfigProperty(MissionName, "ObjectRescueReward")..")", 0.6)
								DrawText3D({x = o1.x, y =o1.y, z = o1.z + 1.0}, "~o~Objective", 1.0)								
							end
						end
								]]--					
										
						if getMissionConfigProperty(MissionName, "ObjectiveRescueShortRangeBlip")  then
							
							--local p1 = GetEntityCoords(GetPlayerPed(-1), true)
							local o1 = GetEntityCoords(obj, true)
							if GetDistanceBetweenCoords(pcoords.x,pcoords.y,pcoords.z,o1.x,o1.y,o1.z,true) <= 100 then	
								--if(Config.DrawText3D and getKillReward(MissionName) ~= 0 )then
								--local o1 = GetEntityCoords(obj, true)
								--DrawText3D({x = o1.x, y =o1.y, z = o1.z}, "~o~Objective ($"..getMissionConfigProperty(MissionName, "ObjectRescueReward")..")", 0.6)						
								--end
							
								local oldblip = GetBlipFromEntity(obj)
								if not DoesBlipExist(oldblip) then 
									local Size     = 0.9
									local pedblip = AddBlipForEntity(obj)
									SetBlipScale  (pedblip, Size)
									SetBlipAsShortRange(pedblip, false)
									SetBlipColour(pedblip, 70)	
									BeginTextCommandSetBlipName("STRING")
									AddTextComponentString("Objective ($"..getMissionConfigProperty(MissionName, "ObjectRescueReward")..")")
									EndTextCommandSetBlipName(pedblip)							
								end	
							end
						else
						
						--local First = vector3(0.0, 0.0, 0.0)
						--local Second = vector3(500.0, 500.0, 500.0)
						--local dimension = GetModelDimensions(GetEntityModel(obj), First, Second)
						--print("dim.x"..dimension.x..",dim.y:"..dimension.y..",dim.z:"..dimension.z)
							local oldblip = GetBlipFromEntity(obj)
							if not DoesBlipExist(oldblip) then 
								local Size     = 0.9
								local pedblip = AddBlipForEntity(obj)
								SetBlipScale  (pedblip, Size)
								SetBlipAsShortRange(pedblip, false)
								SetBlipColour(pedblip, 70)	
								BeginTextCommandSetBlipName("STRING")
								AddTextComponentString("Objective ($"..getMissionConfigProperty(MissionName, "ObjectRescueReward")..")")
								EndTextCommandSetBlipName(pedblip)												
							end
						
						end
						
						local First = vector3(0.0, 0.0, 0.0)
						local Second = vector3(500.0, 500.0, 500.0)
						local dimension = GetModelDimensions(GetEntityModel(obj), First, Second)
						local ox = 1.0
						local oy = 1.0 
						local oz = 1.0 
						if math.abs(dimension.x) > ox then ox = math.abs(dimension.x) end
						if math.abs(dimension.y) > oy then oy = math.abs(dimension.y) end
						if math.abs(dimension.z) > oz then oz = math.abs(dimension.z) end
						
							
						--print("found friendly")
						if IsEntityAtEntity(playerPed, obj, ox+0.5, oy+0.5, oz+0.5, 0, 1, 0) and IsPedOnFoot(playerPed) then
																
							--securingRescueType = 2
							if not (securingRescueType == 2 and securingRescue == DecorGetInt(obj, "mrpproprescue"))then 
								securingRescueType = 2
								securingRescue = DecorGetInt(obj, "mrpproprescue")
								TriggerEvent("SecureObjRescue",playerPed,obj,securingRescueType)
								
							end
	
						elseif securingRescue == DecorGetInt(obj, "mrpproprescue") and securingRescueType == 2 then
							
							securingRescueType = -1
							securingRescue = 0
						end			
				
				end
			
		end
		
	--end
				--print(type(Config.Missions[MissionName].Events))
				if Config.Missions[MissionName].Events then 
				--print("num events:")
					--print(#Config.Missions[MissionName].Events)
					for k,v in pairs(Config.Missions[MissionName].Events) do
					
						if Config.Missions[MissionName].Events[k].revent then
							--print("revent:"..k)
						end
						
						--print("event.."..k)
						--print("made it:".. Config.Missions[MissionName].Events[k].Position.x)
						--if Config.Missions[MissionName].Events[k].Type =="Aircraft" then 
							
							--print("made it:".. Config.Missions[MissionName].Events[k].Position.x)
						--end
						
						local ecoords = pcoords
						
						
						--does IsDefendTarget trigger an event?
						--if so, check if they will trigger
						--if so return their coords, else, return player's
						--player can always trigger the event, if the isdefendtarget
						--does not
						if Config.Missions[MissionName].Events[k].IsDefendTargetTriggersEvent then
							
							ecoords = EventIsDefendtargetPedDistance(ecoords,k) 
						
						end
						
						--Checkpoint support
						local eventOK=true
						if(Config.Missions[MissionName].Type=="Checkpoint" and Config.Missions[MissionName].Events[k].checkpoint and Config.Missions[MissionName].IsRandom==true and DecorGetInt(GetPlayerPed(-1),"mrpcheckpoint") ~= Config.Missions[MissionName].Events[k].checkpoint) 
						or getMissionConfigProperty(MissionName, "CheckpointsNoEvents")
						
						then
							 eventOK=false
							 
							
							--print('oventok:'..k)
							--print("decor:"..DecorGetInt(GetPlayerPed(-1),"mrpcheckpoint"))
							 --print(tostring(eventOK))
						--else
							--print('oventnotok:'..k)
							--print("decor:"..DecorGetInt(GetPlayerPed(-1),"mrpcheckpoint"))
						--support for random events with checkpoint races
						elseif (Config.Missions[MissionName].Type=="Checkpoint" and Config.Missions[MissionName].IsRandom==true and Config.Missions[MissionName].Events[k].revent) then
							--print("OK MADE IT REVENT")
							 eventOK=true
						end
						
						
						--dont trigger event if 
						local pvehicle = GetVehiclePedIsIn( GetPlayerPed(-1), false )
						
						--if player ped is in a vehicle, is a passenger, which has a driver
						--then dont trigger event, allow the driver to do that, who will 
						--invariably be a player. Need this check to stop multiple event triggers
						if pvehicle ~= 0 and not IsVehicleSeatFree(-1) and GetPlayerPed(-1) ~= GetPedInVehicleSeat(pvehicle, -1) then 
							--print("Triggered event is false")
							eventOK=false
						end
					
						if(GetDistanceBetweenCoords(ecoords.x,ecoords.y,ecoords.z, Config.Missions[MissionName].Events[k].Position.x, Config.Missions[MissionName].Events[k].Position.y, Config.Missions[MissionName].Events[k].Position.z, true) < Config.Missions[MissionName].Events[k].Size.radius) and not Config.Missions[MissionName].Events[k].done and eventOK
						
						then
						
						
						--print("made it:".. k)
							--[[
							local aircraft = false
							if (IsPedInAnyVehicle(playerPed,false)) then 
								local vehiclehash = GetEntityModel(GetVehiclePedIsIn(playerPed, false))
								if IsThisModelAHeli(vehiclehash) or IsThisModelAPlane(vehiclehash) then
									aircraft = true
								end
							end
							if not aircraft then 
							]]--
							--does this work for rooftops on hollow buildings???
							if  Config.Missions[MissionName].Events[k].Type =="Paradrop" then 
								local height = GetEntityHeightAboveGround(playerPed)	
								if height < 10 then --if the player is not flying in an aircraft or skydiving themselves
									TriggerEvent("doParadrop",ecoords,k)
									TriggerServerEvent("sv:UpdateEvents",k,GetPlayerServerId(PlayerId()))
									Config.Missions[MissionName].Events[k].done=GetPlayerServerId(PlayerId())
								end
								
							elseif Config.Missions[MissionName].Events[k].Type =="Squad" then 
								TriggerEvent("doSquad",k)
								TriggerServerEvent("sv:UpdateEvents",k,GetPlayerServerId(PlayerId()))
								Config.Missions[MissionName].Events[k].done=GetPlayerServerId(PlayerId())
							elseif Config.Missions[MissionName].Events[k].Type =="Aircraft" then
									--print("aircraft event called"..k)
									TriggerEvent("doAircraft",k)		
									TriggerServerEvent("sv:UpdateEvents",k,GetPlayerServerId(PlayerId()))
									Config.Missions[MissionName].Events[k].done=GetPlayerServerId(PlayerId())
							elseif Config.Missions[MissionName].Events[k].Type =="Vehicle" then
									--print("vehicle event called"..k)
									TriggerEvent("doVehicle",k)		
									TriggerServerEvent("sv:UpdateEvents",k,GetPlayerServerId(PlayerId()))
									Config.Missions[MissionName].Events[k].done=GetPlayerServerId(PlayerId())	
							elseif Config.Missions[MissionName].Events[k].Type =="Boat" then
									--print("boat event called"..k)
									TriggerEvent("doBoat",k)		
									TriggerServerEvent("sv:UpdateEvents",k,GetPlayerServerId(PlayerId()))
									Config.Missions[MissionName].Events[k].done=GetPlayerServerId(PlayerId())									
																							
														
							end
						
						end 
						
						
						--if Config.Missions[MissionName].Events[k].Type =="Paradrop" and Config.Missions[MissionName].Events[k].done == GetPlayerServerId(PlayerId()) then 
							--doParadropPeds(isNPCDead,ped,k,playerPed,pcoords)
						--end
					
					end
					
					--allow a random event with id=1 to happen at Blip coordinate (center/objective) of the random mission
					--not for IsDefend though. Default 500m->1000m away to accommodate for aircraft
					if Config.Missions[MissionName].IsRandomEvent and Config.Missions[MissionName].IsRandom and not Config.Missions[MissionName].IsDefend and not Config.Missions[MissionName].Events[1].done and 
					(GetDistanceBetweenCoords(pcoords.x,pcoords.y,pcoords.z, Config.Missions[MissionName].Blip.Position.x, Config.Missions[MissionName].Blip.Position.y, Config.Missions[MissionName].Blip.Position.z, true) < IsRandomDoEventRadius) 

					then 
						
						if IsRandomDoEvent then
							--print(tostring(not Config.Missions[MissionName].Events[1].done))
							--print(tostring(Config.Missions[MissionName].Events[1].done))
							local eventype = IsRandomDoEventType--math.random(1,4)
							
							--print("eventtype:"..eventype)
							
						--dont spawn on top of the blip which can be on a mission entity, make it 5 meters away.
							 local rHeading = math.random(0, 360) + 0.0
							local theta = (rHeading / 180.0) * 3.14
							Config.Missions[MissionName].Events[1].Position.x = Config.Missions[MissionName].Blip.Position.x - math.cos(theta) * 5
							Config.Missions[MissionName].Events[1].Position.y = Config.Missions[MissionName].Blip.Position.y - math.sin(theta) * 5
							
							local ground,zGround = GetGroundZFor_3dCoord(Config.Missions[MissionName].Events[1].Position.x, Config.Missions[MissionName].Events[1].Position.y, 999.0)
							if not ground then 
								Config.Missions[MissionName].Events[1].Position.z = Config.Missions[MissionName].Blip.Position.z
							else 
								Config.Missions[MissionName].Events[1].Position.z = zGround
							end
						
							if  eventype == 1 then --paradrop
								local height = GetEntityHeightAboveGround(playerPed)	
								if height < 10 then --if the player is not flying in an aircraft or skydiving themselves
									Config.Missions[MissionName].Events[1].Type = "Paradrop"
									TriggerEvent("doParadrop",pcoords,1)
									TriggerServerEvent("sv:UpdateEvents",1,GetPlayerServerId(PlayerId()))
									Config.Missions[MissionName].Events[1].done=GetPlayerServerId(PlayerId())
									--print("done:"..Config.Missions[MissionName].Events[1].done)
								end
								
							elseif eventype == 2  then --squad
								Config.Missions[MissionName].Events[1].Type = "Squad"
								TriggerEvent("doSquad",1)
								TriggerServerEvent("sv:UpdateEvents",1,GetPlayerServerId(PlayerId()))
								Config.Missions[MissionName].Events[1].done=GetPlayerServerId(PlayerId())
							elseif eventype == 3 then --aircraft
									Config.Missions[MissionName].Events[1].Type = "Aircraft"
									--print("aircraft event called"..k)
									TriggerEvent("doAircraft",1)		
									TriggerServerEvent("sv:UpdateEvents",1,GetPlayerServerId(PlayerId()))
									Config.Missions[MissionName].Events[1].done=GetPlayerServerId(PlayerId())
							elseif eventype == 4  then --vehicle
									--print("aircraft event called"..k)
									Config.Missions[MissionName].Events[1].Type = "Vehicle"
									TriggerEvent("doVehicle",1)		
									TriggerServerEvent("sv:UpdateEvents",1,GetPlayerServerId(PlayerId()))
									Config.Missions[MissionName].Events[1].done=GetPlayerServerId(PlayerId())															
							end					
						
						
						end
						
					
					end
					
				end	
		
	
	--print("totalRescuedHostages"..totalRescuedHostages.."hpeds:"..hostagesKilledByPlayer.." regpeds:"..nontargetPedsKilledByPlayer.." targetpeds:"..targetPedsKilledByPlayer.." totpeds:"..totalTargets.." totdeadtargpeds:"..totalDeadTargets.." vehpeds:"..vehiclePedsKilledByPlayer)
	
	return {nontargetPedsKilledByPlayer,targetPedsKilledByPlayer,hostagesKilledByPlayer,totalTargets,totalDeadTargets,totalDeadHostages,totalRescuedHostages,hasBeenConquered,isDefendTargetDead,isDefendTargetRescued,isDefendTargetKilledByPlayer,vehiclePedsKilledByPlayer,bossPedsKilledByPlayer,totalRescuedObjects,isDefendGoalReached}

end


function calcSafeHouseCost(billPlayer,isVehicle,isCrate,MissionName)
		
		local currentmoney = 0
		local safehousecost = 0
		local totalmoney = 0
		--StatSetInt('MP0_WALLET_BALANCE', 0, true)
		--StatSetInt('BANK_BALANCE', 0, true)
		
		if isVehicle then 
		
			if Config.Missions[MissionName].SafeHouseCostVehicle then
				 safehousecost = Config.Missions[MissionName].SafeHouseCostVehicle
				
			else 
				safehousecost = Config.SafeHouseCostVehicle
				
			end		
		
		elseif isCrate then
			if Config.Missions[MissionName].SafeHouseCostCrate then
				 safehousecost = Config.Missions[MissionName].SafeHouseCostCrate
				
			else 
				safehousecost = Config.SafeHouseCostCrate
				
			end			
		
		
		else
			if Config.Missions[MissionName].SafeHouseCost then
				 safehousecost = Config.Missions[MissionName].SafeHouseCost
				
			else 
				safehousecost = Config.SafeHouseCost
				
			end	
		end
		--playerSecured = false
		local _,currentmoney = StatGetInt('MP0_WALLET_BALANCE',-1)
		playerMissionMoney =  0 - safehousecost
		totalmoney =  currentmoney - safehousecost
		--print('HOSTAGE KILLED PENALTY:'..playerMissionMoney)
		--ESX Support, else use Native Money
		
		--set local player decor for simple scoreboard

		
		if billPlayer then
			if UseESX then 
				TriggerServerEvent("paytheplayer", totalmoney)
				TriggerServerEvent("UpdateUserMoney", totalmoney)
			else
				--DecorSetInt(GetPlayerPed(-1),"mrpplayermoney",totalmoney)
				DecorSetInt(GetPlayerPed(-1),"mrpplayermoney",DecorGetInt(GetPlayerPed(-1),"mrpplayermoney") + playerMissionMoney)			
				mrpplayermoneyG = DecorGetInt(GetPlayerPed(-1),"mrpplayermoney")	
				
				StatSetInt('MP0_WALLET_BALANCE',totalmoney, true)
			end 
		end
		
		return math.abs(playerMissionMoney)
		
end



function calcHostageKillPenalty(hostagePedsKilledByPlayer,totalDeadHostages,isDefendTargetKilledByPlayer)
		
		local targetmoney = 0
		local regularmoney = 0
		local objectivemoney = 0
		local penaltymoney = 0
		local totalmoney = 0
		--local currentmoney = 0
		--StatSetInt('MP0_WALLET_BALANCE', 0, true)
		--StatSetInt('BANK_BALANCE', 0, true)
		
		if Config.Missions[MissionName].HostageKillPenalty then
			 penaltymoney = Config.Missions[MissionName].HostageKillPenalty*hostagePedsKilledByPlayer
			 --penaltymoney = Config.Missions[MissionName].HostageKillPenalty*totalDeadHostages
		else 
			penaltymoney = Config.HostageKillPenalty*hostagePedsKilledByPlayer
			--penaltymoney = Config.HostageKillPenalty*totalDeadHostages
		end	
		
		if isDefendTargetKilledByPlayer > 0 then 
			if Config.Missions[MissionName].IsDefendTargetKillPenalty then
				 penaltymoney =  penaltymoney + Config.Missions[MissionName].IsDefendTargetKillPenalty
				 --penaltymoney = Config.Missions[MissionName].HostageKillPenalty*totalDeadHostages
			else 
				penaltymoney = penaltymoney + Config.IsDefendTargetKillPenalty
				--penaltymoney = Config.HostageKillPenalty*totalDeadHostages
			end		
		end 
		--playerSecured = false
		local _,currentmoney = StatGetInt('MP0_WALLET_BALANCE',-1)
		playerMissionMoney =  0 - penaltymoney
		totalmoney =  currentmoney - penaltymoney
		--print('HOSTAGE KILLED PENALTY:'..playerMissionMoney)
		--ESX Support, else use Native Money
		--set local scoreboard money
		
		--DecorSetInt(GetPlayerPed(-1),"mrpplayermoney",totalmoney)
		DecorSetInt(GetPlayerPed(-1),"mrpplayermoney",DecorGetInt(GetPlayerPed(-1),"mrpplayermoney") + playerMissionMoney)
		mrpplayermoneyG = DecorGetInt(GetPlayerPed(-1),"mrpplayermoney")
		
		if UseESX then 
			TriggerServerEvent("paytheplayer", totalmoney)
			TriggerServerEvent("UpdateUserMoney", totalmoney)
		else
			StatSetInt('MP0_WALLET_BALANCE',totalmoney, true)
		end 
		


end

function calcCompletionRewards(nonTargetPedsKilledByPlayer,targetPedsKilledByPlayer,hostagePedsKilledByPlayer,totalDeadHostages,vehiclePedsKilledByPlayer,bossPedsKilledByPlayer,blGoalReached,claimedCheckpoints,claimedWin)
		
		local targetmoney = 0
		local regularmoney = 0
		local objectivemoney = 0
		local penaltymoney = 0
		local totalmoney = 0
		local hostagerecuemoney = 0
		local objectrecuemoney = 0
		local isdefendtargetrescuemoney = 0
		local vehiclepedbonusmoney = 0
		local bosspedbonusmoney = 0
		local goalreachedmoney = 0
		local racemoney = 0
		--local currentmoney = 0
		--StatSetInt('MP0_WALLET_BALANCE', 0, true)
		--StatSetInt('BANK_BALANCE', 0, true)
		
		
		if claimedCheckpoints > 0 then
			if Config.Missions[MissionName].CheckPointClaimdReward  then
				 racemoney = Config.Missions[MissionName].CheckPointClaimdReward*claimedCheckpoints
			else 
				racemoney = Config.CheckPointClaimdReward*claimedCheckpoints
			end
		end
		
		if claimedWin then
			if Config.Missions[MissionName].CheckPointClaimdReward  then
				 racemoney = racemoney+Config.Missions[MissionName].RaceWinReward
			else 
				racemoney = racemoney+Config.RaceWinReward
			end
		end	
		
		
		if blGoalReached then
			if Config.Missions[MissionName].GoalReachedReward  then
				 goalreachedmoney = Config.Missions[MissionName].GoalReachedReward
			else 
				goalreachedmoney = Config.GoalReachedReward
			end
		end
		
		if Config.Missions[MissionName].TargetKillReward  then
			 targetmoney = Config.Missions[MissionName].TargetKillReward*targetPedsKilledByPlayer
		else 
			targetmoney = Config.TargetKillReward*targetPedsKilledByPlayer
		end
		
		if Config.Missions[MissionName].KillReward  then
			 regularmoney = Config.Missions[MissionName].KillReward*nonTargetPedsKilledByPlayer
		else 
			regularmoney = Config.KillReward*nonTargetPedsKilledByPlayer
		end
		
		if Config.Missions[MissionName].KillVehiclePedBonus  then
			 vehiclepedbonusmoney = Config.Missions[MissionName].KillVehiclePedBonus*vehiclePedsKilledByPlayer
		else 
			vehiclepedbonusmoney = Config.KillVehiclePedBonus*vehiclePedsKilledByPlayer
		end		
		--print("vehiclepedbonusmoney:"..vehiclepedbonusmoney)
		
		if Config.Missions[MissionName].KillBossPedBonus then
			 bosspedbonusmoney = Config.Missions[MissionName].KillBossPedBonus*bossPedsKilledByPlayer
		else 
			bosspedbonusmoney = Config.KillBossPedBonus*bossPedsKilledByPlayer
		end				
		
		
		if Config.Missions[MissionName].HostageKillPenalty then
			 penaltymoney = Config.Missions[MissionName].HostageKillPenalty*hostagePedsKilledByPlayer
			 --penaltymoney = Config.Missions[MissionName].HostageKillPenalty*totalDeadHostages
		else 
			penaltymoney = Config.HostageKillPenalty*hostagePedsKilledByPlayer
			--penaltymoney = Config.HostageKillPenalty*totalDeadHostages
		end	
		
		if playerSecured then 
			
			if Config.Missions[MissionName].FinishedObjectiveReward  then
				objectivemoney = Config.Missions[MissionName].FinishedObjectiveReward
			else 
				objectivemoney = Config.FinishedObjectiveReward
			end		
		
		end 
		
		if DecorGetInt(GetPlayerPed(-1),"mrprescuecount") then 
		
			if DecorGetInt(GetPlayerPed(-1),"mrprescuecount") > 0 then 
				local hostagerescues = DecorGetInt(GetPlayerPed(-1),"mrprescuecount")
				if Config.Missions[MissionName].HostageRescueReward  then
					hostagerecuemoney =  Config.Missions[MissionName].HostageRescueReward*hostagerescues
				else 
					hostagerecuemoney =  Config.HostageRescueReward*hostagerescues
				end					
				--reset rescue count
				DecorSetInt(GetPlayerPed(-1),"mrprescuecount",0)
			
			end
		
		end
		
		if DecorGetInt(GetPlayerPed(-1),"mrpobjrescuecount") then 
		
			if DecorGetInt(GetPlayerPed(-1),"mrpobjrescuecount") > 0 then 
				local objrescues = DecorGetInt(GetPlayerPed(-1),"mrpobjrescuecount")
				if Config.Missions[MissionName].ObjectRescueReward  then
					objectrecuemoney =  Config.Missions[MissionName].ObjectRescueReward*objrescues
				else 
					objectrecuemoney =  Config.ObjectRescueReward*objrescues
				end					
				--reset rescue count
				DecorSetInt(GetPlayerPed(-1),"mrpobjrescuecount",0)
			
			end
		
		end		
		
		if DecorGetInt(GetPlayerPed(-1),"mrprescuetarget") then 
		
			if DecorGetInt(GetPlayerPed(-1),"mrprescuetarget") > 0 then 
				local hostagerescues = DecorGetInt(GetPlayerPed(-1),"mrprescuetarget")
				if Config.Missions[MissionName].HostageRescueReward  then
					isdefendtargetrescuemoney =  Config.Missions[MissionName].IsDefendTargetRescueReward
				else 
					isdefendtargetrescuemoney =  Config.IsDefendTargetRescueReward
				end					
				--reset rescue count
				DecorSetInt(GetPlayerPed(-1),"mrprescuetarget",0)
			
			end
		
		end		
		
		
		--print('hostagerecuemoney'..hostagerecuemoney)
		--print('objectivemoney'..objectivemoney)
		--print('penaltymoney'..penaltymoney)
		--print('regularmoney'..regularmoney)
		--print('targetmoney'..targetmoney)
		--print("vehiclepedbonusmoney:"..vehiclepedbonusmoney)
		--print("playerMissionMoney:"..playerMissionMoney)

		
		--playerSecured = false
		local _,currentmoney = StatGetInt('MP0_WALLET_BALANCE',-1)
		playerMissionMoney = targetmoney + regularmoney + objectivemoney + hostagerecuemoney + isdefendtargetrescuemoney + vehiclepedbonusmoney + bosspedbonusmoney + objectrecuemoney + goalreachedmoney + racemoney - penaltymoney
		totalmoney =  currentmoney + targetmoney + regularmoney + objectivemoney + hostagerecuemoney + isdefendtargetrescuemoney + vehiclepedbonusmoney + bosspedbonusmoney + objectrecuemoney + goalreachedmoney + racemoney - penaltymoney
		

		--set local player decor for simple scoreboard
		--DecorSetInt(GetPlayerPed(-1),"mrpplayermoney",totalmoney)
		
		if getMissionConfigProperty(MissionName, "MissionShareMoney")  then 
			playerwasinmissionG = 0
			--print("playerMissionMoney:"..playerMissionMoney)
			local players = {}
			local totalplayersinmission = 0
			ptable = GetPlayers()
			for _, i in ipairs(ptable) do
				
				if (Config.EnableOptIn or Config.EnableSafeHouseOptIn) then 
					if DecorGetInt(GetPlayerPed(i),"mrpoptout")==0 and DecorGetInt(GetPlayerPed(i),"mrpoptin") == 1 then
						totalplayersinmission = totalplayersinmission + 1
						if(GetPlayerPed(-1) == GetPlayerPed(i)) then
							
							playerwasinmissionG = 1
						end
					end
				else 
					
					playerwasinmissionG = 1
					totalplayersinmission = totalplayersinmission + 1
				end
			end	
			if totalplayersinmission == 0 then 
				totalplayersinmission = 1 
			end
			
			--print("totalplayersinmission:"..totalplayersinmission)
			--give a fraction to everyone including myself based on total players.
			local moneytogive = playerMissionMoney/totalplayersinmission
			
			--need to share 0 dollars as well, to not break MISSIONSHAREMONEYAMOUNT
			--global
			if playerwasinmissionG == 1 then --and moneytogive ~= 0 then 
				--print("moneytogive:"..moneytogive)
				TriggerServerEvent("sharemoney", math.ceil(moneytogive))
			
			end 
					
		else 
			DecorSetInt(GetPlayerPed(-1),"mrpplayermoney",DecorGetInt(GetPlayerPed(-1),"mrpplayermoney") + playerMissionMoney)
			mrpplayermoneyG = DecorGetInt(GetPlayerPed(-1),"mrpplayermoney")
			
			
			
			--ESX Support, else use Native Money
			if UseESX then 
				TriggerServerEvent("paytheplayer", totalmoney)
				TriggerServerEvent("UpdateUserMoney", totalmoney)
			else
				StatSetInt('MP0_WALLET_BALANCE',totalmoney, true)
			end 
		end 


end

RegisterNetEvent("mt:updatePlayerCheckpoints")
AddEventHandler("mt:updatePlayerCheckpoints",function(checkpointnum)
	--print("checkpoint update called"..checkpointnum)
	DecorSetInt(GetPlayerPed(-1),"mrpcheckpoint",checkpointnum)
	
	local player = GetPlayerPed(-1)

	--send previous checkpoint...
	
	--send previous checkpoint...
	--only give claimed checkpoints to a driver
	local vehicle = GetVehiclePedIsIn(player, false )
	if vehicle ~= 0 and player == GetPedInVehicleSeat(vehicle,-1) then
	
		if checkpointnum > 1 then 
			DecorSetInt(player,"mrpcheckpointsclaimed",DecorGetInt(player,"mrpcheckpointsclaimed") + 1)
			--print("mrpcheckpointsclaimed:"..DecorGetInt(player,"mrpcheckpointsclaimed"))
		end	
	
		TriggerServerEvent("sv:updatePlayerCheckpoints",MissionName,checkpointnum-1,GetPlayerServerId(PlayerId()))
	end
end)

--checks to see if a passenger at a checkpoint
RegisterNetEvent("mt:rewardPassengers")
AddEventHandler("mt:rewardPassengers",function(playerserverid)
	
	--DecorSetInt(GetPlayerPed(-1),"mrpcheckpoint",checkpointnum)
	
	local player = GetPlayerPed(-1)
	local scoringplayer = GetPlayerPed(GetPlayerFromServerId(playerserverid))
	local svehicle = GetVehiclePedIsIn(scoringplayer, false )
	local pvehicle = GetVehiclePedIsIn(player, false )
	
	--are we a passenger in the scoring player's vehicle?
	if pvehicle == svehicle and GetPedInVehicleSeat(pvehicle,-1) ~= player then
		--print("rewarded passenger")
		DecorSetInt(player,"mrpcheckpointsclaimed",DecorGetInt(player,"mrpcheckpointsclaimed") + 1)
		
	end
	
end)

--players share money?
--local sharedmoney = 0
RegisterNetEvent("mt:sharemoney")
AddEventHandler("mt:sharemoney",function(playermissionmoney)
	
	
	--[[if (Config.EnableOptIn or Config.EnableSafeHouseOptIn) and playerwasinmissionG == 1 then 
	
		if DecorGetInt(GetPlayerPed(-1),"mrpoptout") == 0 
		and DecorGetInt(GetPlayerPed(-1),"mrpoptin") == 1 then 
			print("mt:sharemoney called:$"..playermissionmoney)
			local _,currentmoney = StatGetInt('MP0_WALLET_BALANCE',-1)
			local totalmoney =  currentmoney + playermissionmoney
			DecorSetInt(GetPlayerPed(-1),"mrpplayermoney",DecorGetInt(GetPlayerPed(-1),"mrpplayermoney") + playermissionmoney)
			mrpplayermoneyG = DecorGetInt(GetPlayerPed(-1),"mrpplayermoney")
					
					
			--ESX Support, else use Native Money
			if UseESX then 
				TriggerServerEvent("paytheplayer", totalmoney)
				TriggerServerEvent("UpdateUserMoney", totalmoney)
			else
				StatSetInt('MP0_WALLET_BALANCE',totalmoney, true)
			end 
		end
	else ]]--
	--print("mt shared money called")
	if playerwasinmissionG == 1 then 
	
			--print("mt:sharemoney called:$"..playermissionmoney)
			local _,currentmoney = StatGetInt('MP0_WALLET_BALANCE',-1)
			local totalmoney =  currentmoney + playermissionmoney
			DecorSetInt(GetPlayerPed(-1),"mrpplayermoney",DecorGetInt(GetPlayerPed(-1),"mrpplayermoney") + playermissionmoney)
			mrpplayermoneyG = DecorGetInt(GetPlayerPed(-1),"mrpplayermoney")
			
			Notify("~h~~w~Shared mission money. You earned:~g~ $"..playermissionmoney)	

			MISSIONSHAREMONEYAMOUNT	= "~n~~w~Shared mission money. You earned:~g~ $"..playermissionmoney	
					
			--ESX Support, else use Native Money
			if UseESX then 
				TriggerServerEvent("paytheplayer", totalmoney)
				TriggerServerEvent("UpdateUserMoney", totalmoney)
			else
				StatSetInt('MP0_WALLET_BALANCE',totalmoney, true)
			end 	
	
	
	end
	
	
end)

function getObjectiveReward(MissionName) 
	local retval = "N/A"
	if Config.Missions[MissionName].Type=="Objective" then 
		if Config.Missions[MissionName].FinishedObjectiveReward  then
			return Config.Missions[MissionName].FinishedObjectiveReward
		else 
			return Config.FinishedObjectiveReward
		end
	else
		return retval
	end
end

function getHostageKillPenalty(MissionName) 
			
	if Config.Missions[MissionName].HostageKillPenalty then
		return Config.Missions[MissionName].HostageKillPenalty	 
	else 
		return Config.HostageKillPenalty		
	end	

end


function getKillReward(MissionName) 

		if Config.Missions[MissionName].KillReward  then
			 return Config.Missions[MissionName].KillReward
		else 
			return Config.KillReward
		end
	

end

function getTargetKillReward(MissionName) 
			
		if Config.Missions[MissionName].TargetKillReward  then
			 return Config.Missions[MissionName].TargetKillReward
		else 
			return Config.TargetKillReward
		end
	

end

--Used in Assassinate which has IsDefend = true
--Checks to see if 
function hasBeenConquered(MissionName) 
	--loop through to see if the marker area has an enemy in it
	--print("hasBeenConquered CHECK")
	for ped in EnumeratePeds() do
		
		if (DecorGetInt(ped, "mrppedid") > 0 or DecorGetInt(ped, "mrpvpedid") > 0) and (not (IsEntityDead(ped) == 1)) and (DecorGetInt(ped, "mrppedfriend") == 0) then 
			--print("2hasBeenConquered CHECK")
			local coords  --= vector3(0.0,0.0,0.0)
			if GetVehiclePedIsUsing(ped) ~= 0 then --GetVehiclePedIsIn(ped, false)
				--print("hasBeenConquered vped")
			
				coords =  GetEntityCoords(GetVehiclePedIsUsing(ped))
				--print("vehcoords:"..coords.x.."|"..coords.y.."|"..coords.z)
			else 
				--print("hasBeenConquered ped")
				coords =  GetEntityCoords(ped)
				--print("pedcoords:"..coords.x.."|"..coords.y.."|"..coords.z)
			end
			
			--workaround for random anywhere missions where ground z was not found.
			if (Config.Missions[MissionName].Marker.Position.z <=0.0) then 
			
			--if(GetDistanceBetweenCoords(coords.x,coords.y,coords.z, Config.Missions[MissionName].Marker.Position.x, Config.Missions[MissionName].Marker.Position.y, Config.Missions[MissionName].Marker.Position.z, true) < Config.Missions[MissionName].Marker.Size.x / 2) then
					
			
				if(GetDistanceBetweenCoords(coords.x,coords.y,0.0, Config.Missions[MissionName].Marker.Position.x, Config.Missions[MissionName].Marker.Position.y, 0.0, true) < Config.Missions[MissionName].Marker.Size.x / 2) then  --print("coords:"..coords.x.."|"..coords.y.."|"..coords.z)
					--print("markercoords:"..Config.Missions[MissionName].Marker.Position.x.."|".. Config.Missions[MissionName].Marker.Position.y.."|".. Config.Missions[MissionName].Marker.Position.z)
					--print("distance:"..GetDistanceBetweenCoords(coords.x,coords.y,coords.z, Config.Missions[MissionName].Marker.Position.x, Config.Missions[MissionName].Marker.Position.y, Config.Missions[MissionName].Marker.Position.z, true))
					--print("hasBeenConquered true")
					return true 

				end
			else
				if(GetDistanceBetweenCoords(coords.x,coords.y,coords.z, Config.Missions[MissionName].Marker.Position.x, Config.Missions[MissionName].Marker.Position.y, Config.Missions[MissionName].Marker.Position.z, true) < Config.Missions[MissionName].Marker.Size.x / 2) then
					--print("coords:"..coords.x.."|"..coords.y.."|"..coords.z)
					--print("markercoords:"..Config.Missions[MissionName].Marker.Position.x.."|".. Config.Missions[MissionName].Marker.Position.y.."|".. Config.Missions[MissionName].Marker.Position.z)
					--print("distance:"..GetDistanceBetweenCoords(coords.x,coords.y,coords.z, Config.Missions[MissionName].Marker.Position.x, Config.Missions[MissionName].Marker.Position.y, Config.Missions[MissionName].Marker.Position.z, true))
					--print("hasBeenConquered true")
					return true 

				end			
			
			end
				
		end

	end	

		--print("hasBeenConquered falsse")
		return false


end

function rescuingHostage() 

	for ped in EnumeratePeds() do
		
		if (DecorGetInt(ped, "mrppedfriend") > 0 and not (IsEntityDead(ped) == 1) )  then
		
				if IsEntityAtEntity(GetPlayerPed(-1), ped, 1.0, 1.0, 2.0, 0, 1, 0) then
					SetEntityInvincible(ped,true)
					ClearPedTasksImmediately(ped)
					DecorSetInt(ped,"mrppedfriend", -1)
					TaskSmartFleePed(ped, GetPlayerPed(-1), 10000.0, -1) 
					--decor value doesnt seem to propogate fast enough to other players
					--to prevent multiple rescues on already rescued hostage
					--so remove quickly for now, while maintaining some gravitas
					if blRemoveRescuedHostage then 
						DeleteEntity(ped)
					end
					if not DecorGetInt(GetPlayerPed(-1),"mrprescuecount") then 
						DecorSetInt(GetPlayerPed(-1),"mrprescuecount", 1)
					else 
						DecorSetInt(GetPlayerPed(-1),"mrprescuecount",(DecorGetInt(GetPlayerPed(-1),"mrprescuecount") + 1))
					end
					
					return true
				end			
		
		end

	end	
	return false

end

function drawMessage(message,timet)
	--print('draw Message time'..timet .."message:"..message)
	ClearPrints()
	SetTextColour(99, 209, 62, 255)
	SetTextEntry("STRING")
	--message
	AddTextComponentString(message)
	DrawSubtitleTimed(timet, 1)	--time = 10000


end

function MissionCheck()
	local totalTargets = 0
	local totalDeadTargets = 0
	local targetPedsKilledByPlayer = 0
	local nontargetPedsKilledByPlayer = 0
	local hostagePedsKilledByPlayer = 0
	local results
	local isfail = false
	
	local totalRescuedHostages = 0
	local hasBeenConquered = 0
	local isDefendTargetDead = 0
	local isDefendTargetRescued = 0
	local isDefendTargetKilledByPlayer = 0
	local totalRescuedObjects = 0
	local isDefendGoalReached = 0
	--[[
	if (Active == 1) and  MissionName ~="N/A" then 
		 for i=1, #Config.Missions[MissionName].Vehicles do 
			if Config.Missions[MissionName].Vehicles[i].id2 and 
			GetSequenceProgress(Config.Missions[MissionName].Vehicles[i].id2) > 0 then 
				print(GetSequenceProgress(Config.Missions[MissionName].Vehicles[i].id2))
			end
		end
	end
	]]--
	--print(GetIsTaskActive(Config.Missions[MissionName].Vehicles[6].id2,373))
	PLY = PlayerId()
	PLYN = GetPlayerName(PLY)
		--Wait called in loop now:
		--Citizen.Wait(1000)
		results = calcMissionStats()
		totalTargets = results[4]
		totalDeadTargets = results[5]
		totalDeadHostages = results[6]
		nontargetPedsKilledByPlayer = results[1]
		targetPedsKilledByPlayer = results[2]
		hostagePedsKilledByPlayer = results[3]
		
		totalRescuedHostages = results[7]
		hasBeenConquered = results[8]
		isDefendTargetDead = results[9]
		
		isDefendTargetRescued = results[10]
		isDefendTargetKilledByPlayer = results[11]
		
		totalRescuedObjects = results[14]
		
		isDefendGoalReached = results[15]
		
		--print("totalRescuedHostages:"..totalRescuedHostages)
		--print("mcheck...isDefendTargetRescued:"..isDefendTargetRescued)
		
		if (Active == 1) and  MissionName ~="N/A" then 
			--print("MISSIONCHECK:"..MissionName)
			--print("MISSIONCHECK:"..tostring(getMissionConfigProperty(MissionName, "IsDefend")))
			
			if MissionTimeOut then --and Config.Missions[MissionName].Type == "Assassinate" then
				--print("MISSIONCHECK TIMEOUT")
				isfail = true
				PLY = PlayerId()
				PLYN = GetPlayerName(PLY)
				local reasontext = "The mission timed out"
				if Config.Missions[MissionName].IsDefend and not Config.Missions[MissionName].IsDefendTarget then
					reasontext = "The defense held"
					
				elseif Config.Missions[MissionName].IsDefend and Config.Missions[MissionName].IsDefendTarget then
					reasontext = "You failed to protect the target"
				end
				
				
				message = "^1[MISSIONS]: ^1 Mission Timeout"
				message2 = "^1[MISSIONS]: ^2'".. Config.Missions[MissionName].MissionTitle .."'^0 mission has failed!"
			   -- TriggerServerEvent("sv:two", message)
				
				TriggerEvent('chatMessage', message)
				TriggerEvent('chatMessage', message2)				
				
				--TriggerServerEvent("sv:two", message)
				--TriggerServerEvent("sv:two", message2)
				Active = 0
				--TriggerServerEvent("sv:done", MissionName)
				--TriggerEvent("DONE", MissionName)
				aliveCheck()
				local oldmission = MissionName
				--MissionName = "N/A"
				TriggerEvent('ExitOldMissionAndStartNewMission',oldmission,isfail,reasontext) --GHK Start New Mission									
				
			elseif(totalTargets  == totalDeadTargets) and (totalTargets > 0 and totalDeadTargets > 0) and (Config.Missions[MissionName].Type == "Assassinate" or Config.Missions[MissionName].Type == "BossRush") then --and PedsSpawned == 1 then --need at least 1 target, or the mission will autocomplete on start
				--print("MISSIONCHECK DONE1")
				securing = false --needed?
				buying = false
				
				--message  = "^1[MISSIONS]: ^2".. PLYN .."^0 has assassinated all the targets!"
	
				message2 = "^1[MISSIONS]: ^2'".. Config.Missions[MissionName].MissionTitle .."'^0 has been completed!"
				
			   -- TriggerServerEvent("sv:two", message)
				--TriggerServerEvent("sv:two", message2)
				TriggerEvent('chatMessage', message2)
				Active = 0
				--TriggerServerEvent("sv:done", MissionName)
				--TriggerEvent("DONE", MissionName)
				aliveCheck()
				local oldmission = MissionName
				--MissionName = "N/A"
				TriggerEvent('ExitOldMissionAndStartNewMission',oldmission,isfail,"") --GHK Start New Mission
			
			--IsDefend requires Assassinate Type?
			elseif getMissionConfigProperty(MissionName, "IsDefend") and (not getMissionConfigProperty(MissionName, "IsDefendTarget"))  and hasBeenConquered > 0 then   --and hasBeenConquered(MissionName) then --and Config.Missions[MissionName].Type == "Assassinate" and hasBeenConquered(MissionName) then
				--print("MISSIONCHECK ISDEFEND")
				isfail = true
				PLY = PlayerId()
				PLYN = GetPlayerName(PLY)
				local reasontext = "Enemies have reached the objective"
				message = "^1[MISSIONS]: ^1 Enemies have reached the objective"
				message2 = "^1[MISSIONS]: ^2'".. Config.Missions[MissionName].MissionTitle .."'^0 mission has failed!"
			   -- TriggerServerEvent("sv:two", message)
				
				TriggerEvent('chatMessage', message)
				TriggerEvent('chatMessage', message2)
				
				--TriggerServerEvent("sv:two", message)
				--TriggerServerEvent("sv:two", message2)
				Active = 0
				--TriggerServerEvent("sv:done", MissionName)
				--TriggerEvent("DONE", MissionName)
				aliveCheck()
				local oldmission = MissionName
				--MissionName = "N/A"
				TriggerEvent('ExitOldMissionAndStartNewMission',oldmission,isfail,reasontext) --GHK Start New Mission


			elseif getMissionConfigProperty(MissionName, "IsDefend") and getMissionConfigProperty(MissionName, "IsDefendTarget") then   --and hasBeenConquered(MissionName) then --and Config.Missions[MissionName].Type == "Assassinate" and hasBeenConquered(MissionName) then
				--print("mcheck2...isDefendTargetRescued:"..isDefendTargetRescued)
				if (isDefendTargetDead > 0) then 
					--print("mcheck3...TARGETDEAD")
				--print("MISSIONCHECK ISDEFEND")
					isfail = true
					local reasontext = "The target you were defending has died"
					message = "^1[MISSIONS]: ^1 The target you were defending has died"
					message2 = "^1[MISSIONS]: ^2'".. Config.Missions[MissionName].MissionTitle .."'^0 mission has failed!"
					if isDefendTargetKilledByPlayer > 0  then
						PLY = PlayerId()
						PLYN = GetPlayerName(PLY)						
						--reasontext = PLYN.." has killed the target you were defending!"
						reasontext = "The target you were defending has died"
						message = "^1[MISSIONS]: ^2 "..PLYN.."^1 has killed the target you were defending!"
						message2 = "^1[MISSIONS]: ^2'".. Config.Missions[MissionName].MissionTitle .."'^0 mission has failed!"					
					
					end 
					
					TriggerEvent('chatMessage', message)
					TriggerEvent('chatMessage', message2)					
					--TriggerServerEvent("sv:two", message)
					--TriggerServerEvent("sv:two", message2)
					Active = 0
					--TriggerServerEvent("sv:done", MissionName)
					--TriggerEvent("DONE", MissionName)
					aliveCheck()
					local oldmission = MissionName
					--MissionName = "N/A"
					TriggerEvent('ExitOldMissionAndStartNewMission',oldmission,isfail,reasontext) --GHK Start New Mission
				elseif getMissionConfigProperty(MissionName, "IsDefendTargetRescue") and isDefendTargetRescued > 0 then 
					--print("mcheck3...isDefendTargetRescued:"..isDefendTargetRescued)
				--print("MISSIONCHECK DONE2")
					--[[
					isfail = false
					PLY = PlayerId()
					PLYN = GetPlayerName(PLY)
					local reasontext = PLYN.." has rescued the target you were protecting!"
					message = "^1[MISSIONS]: ^2 "..PLYN.."^1 has rescued the target you were protecting!"
					message2 = "^1[MISSIONS]: ^2'".. Config.Missions[MissionName].MissionTitle .."'^0 mission complete!"
				   -- TriggerServerEvent("sv:two", message)
					
					TriggerEvent('chatMessage', message)
					TriggerEvent('chatMessage', message2)					
					
					--TriggerServerEvent("sv:two", message)
					--TriggerServerEvent("sv:two", message2)
					Active = 0
					--TriggerServerEvent("sv:done", MissionName)
					--TriggerEvent("DONE", MissionName)
					aliveCheck()
					local oldmission = MissionName
					--MissionName = "N/A"
					ExitOldMissionAndStartNewMission(oldmission,isfail,reasontext) --GHK Start New Mission						 --rescue
					
					]]--
				elseif getMissionConfigProperty(MissionName, "IsDefendTargetRewardBlip") and isDefendGoalReached == 1 then 
							--print ("made it mc")
							local reasontext = "The target has reached the destination"
							message = "^1[MISSIONS]: ^1 The target you were defending has reached the destination"
							message2 = "^1[MISSIONS]: ^2'".. Config.Missions[MissionName].MissionTitle .."'^0 mission completed!"
							
							
							TriggerEvent('chatMessage', message)
							TriggerEvent('chatMessage', message2)					
							--TriggerServerEvent("sv:two", message)
							--TriggerServerEvent("sv:two", message2)
							Active = 0
							--TriggerServerEvent("sv:done", MissionName)
							--TriggerEvent("DONE", MissionName)
							aliveCheck()
							local oldmission = MissionName
							--MissionName = "N/A"
							local goalreached = true
							TriggerEvent('ExitOldMissionAndStartNewMission',oldmission,isfail,reasontext,goalreached)							
				

				
				end 
				if getMissionConfigProperty(MissionName, "IsVehicleDefendTargetGotoBlip") or getMissionConfigProperty(MissionName, "IsDefendTargetGotoBlip") or getMissionConfigProperty(MissionName, "IsVehicleDefendTargetGotoBlipTargetOnly") or  
				 getMissionConfigProperty(MissionName, "IsDefendTargetGotoBlipTargetOnly")
				then 
				
					--REVISIT THIS CODE RUNS TOO SLOW? 
					local tped = GetIsDefendtargetPed() 
					
					if tped and not isfail then 
						local otherpc  = GetEntityCoords(tped)
						if GetDistanceBetweenCoords(otherpc.x,otherpc.y,otherpc.z,Config.Missions[MissionName].Blip.Position.x, Config.Missions[MissionName].Blip.Position.y,Config.Missions[MissionName].Blip.Position.z,true) <= getMissionConfigProperty(MissionName,"IsDefendTargetGoalDistance") then			

							local reasontext = "The target has reached the destination"
							message = "^1[MISSIONS]: ^1 The target you were defending has reached the destination"
							message2 = "^1[MISSIONS]: ^2'".. Config.Missions[MissionName].MissionTitle .."'^0 mission completed!"
							
							
							TriggerEvent('chatMessage', message)
							TriggerEvent('chatMessage', message2)					
							--TriggerServerEvent("sv:two", message)
							--TriggerServerEvent("sv:two", message2)
							Active = 0
							--TriggerServerEvent("sv:done", MissionName)
							--TriggerEvent("DONE", MissionName)
							aliveCheck()
							local oldmission = MissionName
							--MissionName = "N/A"
							local goalreached = true
							TriggerEvent('ExitOldMissionAndStartNewMission',oldmission,isfail,reasontext,goalreached)						
							
						end
					
					end
				end
			elseif Config.Missions[MissionName].Type == "HostageRescue" and Config.Missions[MissionName].IsRandom and totalRescuedHostages == 0 and hostagePedsKilledByPlayer == 0 and totalDeadHostages == 0 and IsRandomMissionAllHostagesRescued then
				securing = false --needed?
				buying = false
				message2 = "^1[MISSIONS]: ^2'".. Config.Missions[MissionName].MissionTitle .."'^0 has been completed!"					
				TriggerEvent('chatMessage', message2)
				Active = 0
				aliveCheck()
				local oldmission = MissionName
				TriggerEvent('ExitOldMissionAndStartNewMission',oldmission,isfail,"") --GHK Start New Mission							
			
			elseif Config.Missions[MissionName].Type == "HostageRescue" and not Config.Missions[MissionName].IsRandom and totalRescuedHostages == 0 and hostagePedsKilledByPlayer == 0 and totalDeadHostages == 0 and totalRescuedObjects == 0 then
				local totalhostages = 0
				local rescuedhostages = 0
				for i, v in pairs(Config.Missions[MissionName].Peds) do
					if Config.Missions[MissionName].Peds[i].friendly and not Config.Missions[MissionName].Peds[i].dead then 
						totalhostages = totalhostages + 1
					end
					
					if Config.Missions[MissionName].Peds[i].rescued then 
						rescuedhostages =  rescuedhostages + 1
					end
					
				end
				
				if totalhostages > 0 and rescuedhostages > 0 and (rescuedhostages==totalhostages) then 
					securing = false --needed?
					buying = false
					message2 = "^1[MISSIONS]: ^2'".. Config.Missions[MissionName].MissionTitle .."'^0 has been completed!"					
					TriggerEvent('chatMessage', message2)
					Active = 0
					aliveCheck()
					local oldmission = MissionName
					TriggerEvent('ExitOldMissionAndStartNewMission',oldmission,isfail,"") --GHK Start New Mission					
				end
				
			elseif Config.Missions[MissionName].Type == "ObjectiveRescue" and totalRescuedObjects == 0 and totalRescuedHostages == 0 
			
			--and hostagePedsKilledByPlayer == 0 and totalDeadHostages == 0 
			
			then
				local totalobjects = 0
				local rescuedobjects = 0
				for i, v in pairs(Config.Missions[MissionName].Props) do
					if Config.Missions[MissionName].Props[i].isObjective  then 
						totalobjects = totalobjects + 1
					end
					
					if Config.Missions[MissionName].Props[i].rescued then 
						rescuedobjects =  rescuedobjects + 1
					end
					
				end
				
				if totalobjects > 0 and rescuedobjects > 0 and (rescuedobjects==totalobjects) then 
					securing = false --needed?
					buying = false
					message2 = "^1[MISSIONS]: ^2'".. Config.Missions[MissionName].MissionTitle .."'^0 has been completed!"					
					TriggerEvent('chatMessage', message2)
					Active = 0
					aliveCheck()
					local oldmission = MissionName
					TriggerEvent('ExitOldMissionAndStartNewMission',oldmission,isfail,"") --GHK Start New Mission					
				end
				
				--should be OK to be here, rathee than above objects logic?
				
				if (getMissionConfigProperty(MissionName, "HostageRescue")) and (totalDeadHostages > 0 or hostagePedsKilledByPlayer > 0) then --and Config.Missions[MissionName].Type == "Assassinate" then
					--print("MISSIONCHECK DONE2")
					isfail = true
					PLY = PlayerId()
					PLYN = GetPlayerName(PLY)
					local reasontext = "A hostage has died"
					message = "^1[MISSIONS]: ^1 A hostage has died"
					message2 = "^1[MISSIONS]: ^2'".. Config.Missions[MissionName].MissionTitle .."'^0 mission has failed!"
				   -- TriggerServerEvent("sv:two", message)
					
					TriggerEvent('chatMessage', message)
					TriggerEvent('chatMessage', message2)				
					
					--TriggerServerEvent("sv:two", message)
					--TriggerServerEvent("sv:two", message2)
					Active = 0
					--TriggerServerEvent("sv:done", MissionName)
					--TriggerEvent("DONE", MissionName)
					aliveCheck()
					local oldmission = MissionName
					--MissionName = "N/A"
					TriggerEvent('ExitOldMissionAndStartNewMission',oldmission,isfail,reasontext) --GHK Start New Mission						
				end  

				
				
			elseif (getMissionConfigProperty(MissionName, "HostageRescue") or Config.Missions[MissionName].Type == "HostageRescue") and hostagePedsKilledByPlayer > 0 then --and Config.Missions[MissionName].Type == "Assassinate" then
				--print("MISSIONCHECK DONE2")
				isfail = true
				PLY = PlayerId()
				PLYN = GetPlayerName(PLY)
				local reasontext = PLYN.." has killed a hostage"
				message = "^1[MISSIONS]: ^2 "..PLYN.."^1 has killed a hostage"
				message2 = "^1[MISSIONS]: ^2'".. Config.Missions[MissionName].MissionTitle .."'^0 mission has failed!"
			   -- TriggerServerEvent("sv:two", message)
				
				TriggerEvent('chatMessage', message)
				TriggerEvent('chatMessage', message2)				
				
				--TriggerServerEvent("sv:two", message)
				--TriggerServerEvent("sv:two", message2)
				Active = 0
				--TriggerServerEvent("sv:done", MissionName)
				--TriggerEvent("DONE", MissionName)
				aliveCheck()
				local oldmission = MissionName
				--MissionName = "N/A"
				TriggerEvent('ExitOldMissionAndStartNewMission',oldmission,isfail,reasontext) --GHK Start New Mission				
				
			elseif (getMissionConfigProperty(MissionName, "HostageRescue") or Config.Missions[MissionName].Type == "HostageRescue") and totalDeadHostages > 0 then --and Config.Missions[MissionName].Type == "Assassinate" then
				--print("MISSIONCHECK DONE2")
				isfail = true
				PLY = PlayerId()
				PLYN = GetPlayerName(PLY)
				local reasontext = "A hostage has died"
				message = "^1[MISSIONS]: ^1 A hostage has died"
				message2 = "^1[MISSIONS]: ^2'".. Config.Missions[MissionName].MissionTitle .."'^0 mission has failed!"
			   -- TriggerServerEvent("sv:two", message)
				
				TriggerEvent('chatMessage', message)
				TriggerEvent('chatMessage', message2)				
				
				--TriggerServerEvent("sv:two", message)
				--TriggerServerEvent("sv:two", message2)
				Active = 0
				--TriggerServerEvent("sv:done", MissionName)
				--TriggerEvent("DONE", MissionName)
				aliveCheck()
				local oldmission = MissionName
				--MissionName = "N/A"
				TriggerEvent('ExitOldMissionAndStartNewMission',oldmission,isfail,reasontext) --GHK Start New Mission		
			
			elseif totalRescuedHostages > 0 then--rescuingHostage() then --and Config.Missions[MissionName].Type == "Assassinate" then
				--[[
				--isfail = true
				--print("rescued hostage")
				PLY = PlayerId()
				PLYN = GetPlayerName(PLY)
				--local reasontext = PLYN.." has rescued a hostage"
				--message = ""..PLYN.." has rescued a hostage"
				message = "~g~You have rescued a hostage!"
				message2 = "^1[MISSIONS]: ^2 "..PLYN.."^0 has rescued a hostage"
				
				TriggerEvent('chatMessage', message2)				
				--TriggerServerEvent("sv:two", message2)
				--TriggerServerEvent("sv:message", message)
				TriggerEvent("mt:missiontext2", message, 1000)
				
				--WdrawMessage(message,10000)
				PlaySoundFrontend(-1, "ROUND_ENDING_STINGER_CUSTOM", "CELEBRATION_SOUNDSET", 1)
				--TriggerServerEvent("sv:two", message2)
				--Active = 0
				--TriggerServerEvent("sv:done", MissionName)
				--TriggerEvent("DONE", MissionName)
				--aliveCheck()
				--local oldmission = MissionName
				--MissionName = "N/A"
				--ExitOldMissionAndStartNewMission(oldmission,isfail,reasontext) --GHK Start New Mission
				]]--
			elseif totalRescuedObjects > 0 then--rescuingHostage() then --and Config.Missions[MissionName].Type == "Assassinate" then
				--isfail = true
				--print("rescued hostage")
				--[[
				PLY = PlayerId()
				PLYN = GetPlayerName(PLY)
				--local reasontext = PLYN.." has rescued a hostage"
				--message = ""..PLYN.." has rescued a hostage"
				message = "~g~You have secured an objective!"
				message2 = "^1[MISSIONS]: ^2 "..PLYN.."^0 has secured an objective"
				
				TriggerEvent('chatMessage', message2)				
				--TriggerServerEvent("sv:two", message2)
				--TriggerServerEvent("sv:message", message)
				TriggerEvent("mt:missiontext2", message, 1000)
				
				--WdrawMessage(message,10000)
				PlaySoundFrontend(-1, "ROUND_ENDING_STINGER_CUSTOM", "CELEBRATION_SOUNDSET", 1)
				--TriggerServerEvent("sv:two", message2)
				--Active = 0
				--TriggerServerEvent("sv:done", MissionName)
				--TriggerEvent("DONE", MissionName)
				--aliveCheck()
				--local oldmission = MissionName
				--MissionName = "N/A"
				--ExitOldMissionAndStartNewMission(oldmission,isfail,reasontext) --GHK Start New Mission				
				
				]]--
						
			end
		end
   -- end

end

--for ObjectRescue and HostageRescue
AddEventHandler('SecureObjRescue',function(playerPed,Ent,intType) --0 hostage, 1 defendtarget, 2 objective
	local SecureStartTime = 5
    local SecureTime = SecureStartTime
    while securingRescue > 0 do
		
        PLY = PlayerId()
        PLYN = GetPlayerName(PLY)
        if SecureTime > 0 and SecureTime < SecureStartTime then
	
   
           
			local messageProgress  = "~u~(~g~Rescue Progress: ~r~".. SecureTime .."~u~)"
		
			if intType == 2 then 
				messageProgress  = "~u~(~g~Capture Progress: ~r~".. SecureTime .."~u~)"
			end
			
			--TriggerEvent('chatMessage', "^1[MISSIONS]: ^0 Capture Progress: ^1"..(SecureTime))
			 SecureTime = SecureTime - 1
			--drawMessage(messageProgress,1000) 
			--for some reason not working all the time for non host clients so use drawMessage above as well
			message = messageProgress
           TriggerEvent("mt:missiontext2", message, 1000)
            Citizen.Wait(1000)
			PlaySoundFrontend(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET", 1)
        end
        if SecureTime == 0 then
            securingRescue = 0
			securingRescueType = -1
			
			if intType == 0  then 
				if Active == 1 and MissionName ~="N/A" and DecorGetInt(Ent,"mrppedfriend") > 0 then 
					TriggerServerEvent("sv:rescuehostage",DecorGetInt(Ent,"mrppedfriend"),"mrppedfriend")
					SetEntityInvincible(Ent,true)
					ClearPedTasksImmediately(Ent)
					
					local oldblip = GetBlipFromEntity(Ent)

					if DoesBlipExist(oldblip) then
						
						RemoveBlip(oldblip)
					end					
					
					
					if RescueMarkers['f'..DecorGetInt(Ent, "mrppedfriend")] then
						--print("made it")
						RescueMarkers['f'..DecorGetInt(Ent, "mrppedfriend")] = nil						
					end						
					
					DecorSetInt(Ent,"mrppedfriend", -1)
									
					
					TaskSmartFleePed(Ent, playerPed, 10000.0, -1) 
					if blRemoveRescuedHostage then 
						DeleteEntity(Ent)
					end
					if not DecorGetInt(playerPed,"mrprescuecount") then 
						DecorSetInt(playerPed,"mrprescuecount", 1)
					else 
						DecorSetInt(playerPed,"mrprescuecount",(DecorGetInt(playerPed,"mrprescuecount") + 1))
					end	

					message = "~g~You have rescued a hostage!"
					message2 = "^1[MISSIONS]: ^2 "..PLYN.."^0 has rescued a hostage"
						
					TriggerEvent('chatMessage', message2)				
					TriggerEvent("mt:missiontext2", message, 1000)
					PlaySoundFrontend(-1, "ROUND_ENDING_STINGER_CUSTOM", "CELEBRATION_SOUNDSET", 1)		
				end
			elseif intType == 1  then 
				if Active == 1 and MissionName ~="N/A" and DecorGetInt(Ent,"mrppeddefendtarget") > 0 then 
					TriggerServerEvent("sv:rescuehostage",DecorGetInt(Ent,"mrppeddefendtarget"),"mrppeddefendtarget")
					SetEntityInvincible(Ent,true)
					ClearPedTasksImmediately(Ent)
					
					if RescueMarkers['d'..DecorGetInt(Ent, "mrppeddefendtarget")] then 
						RescueMarkers['d'..DecorGetInt(Ent, "mrppeddefendtarget")] = nil
					end									
					DecorSetInt(Ent,"mrppeddefendtarget", 0)
						
					
					TaskSmartFleePed(Ent, playerPed, 10000.0, -1) 
					if blRemoveRescuedHostage then 
						DeleteEntity(Ent)
					end
					if not DecorGetInt(playerPed,"mrprescuetarget") then 
						DecorSetInt(playerPed,"mrprescuetarget", 1)
					else 
						DecorSetInt(playerPed,"mrprescuetarget",(DecorGetInt(playerPed,"mrprescuetarget") + 1))
					end
					local isfail = false
					
					local reasontext = PLYN.." has rescued the target you were protecting!"
					message = "^1[MISSIONS]: ^2 "..PLYN.."^1 has rescued the target you were protecting!"
					message2 = "^1[MISSIONS]: ^2'".. Config.Missions[MissionName].MissionTitle .."'^0 mission complete!"
					   -- TriggerServerEvent("sv:two", message)
						
					TriggerEvent('chatMessage', message)
					TriggerEvent('chatMessage', message2)					
					Active = 0
					aliveCheck()
					local oldmission = MissionName
					TriggerEvent('ExitOldMissionAndStartNewMission',oldmission,isfail,reasontext) --GHK Start New Mission				
				end
			elseif intType == 2  then
				if Active == 1 and MissionName ~="N/A" and DecorGetInt(Ent,"mrpproprescue") > 0 then		
					TriggerServerEvent("sv:rescuehostage",DecorGetInt(Ent,"mrpproprescue"),"mrpproprescue")
					
					if(RescueMarkers['o'..DecorGetInt(Ent, "mrpproprescue")]) then 
						RescueMarkers['o'..DecorGetInt(Ent, "mrpproprescue")] = nil
					end
					DecorSetInt(Ent,"mrpproprescue", 0)						
					DecorRemove(Ent, "mrpproprescue")
					DeleteObject(Ent)
					

					
					if not DecorGetInt(playerPed,"mrpobjrescuecount") then 
						DecorSetInt(playerPed,"mrpobjrescuecount", 1)
					else 
						DecorSetInt(playerPed,"mrpobjrescuecount",(DecorGetInt(playerPed,"mrpobjrescuecount") + 1))
					end
					message = "~g~You have secured an objective!"
					message2 = "^1[MISSIONS]: ^2 "..PLYN.."^0 has secured an objective"
					
					TriggerEvent('chatMessage', message2)			
					TriggerEvent("mt:missiontext2", message, 1000)
					PlaySoundFrontend(-1, "ROUND_ENDING_STINGER_CUSTOM", "CELEBRATION_SOUNDSET", 1)				
				end
			end
	
        end
        
        if SecureTime == SecureStartTime then
			if intType == 0 then 
				TriggerEvent("chatMessage", "You are now rescuing a hostage.")
				TriggerEvent("mt:missiontext2", "~u~(~g~Rescue Progress: ~r~".. SecureTime .."~u~)", 1000)
			elseif intType == 1 then 
				TriggerEvent("chatMessage", "You are now rescuing the target.")
				TriggerEvent("mt:missiontext2", "~u~(~g~Rescue Progress: ~r~".. SecureTime .."~u~)", 1000)			
			elseif intType == 2 then 
				
				TriggerEvent("chatMessage", "You are now securing an objective.")
				TriggerEvent("mt:missiontext2", "~u~(~g~Capture Progress: ~r~".. SecureTime .."~u~)", 1000)						
			end
			
			PlaySoundFrontend(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET", 1)
            SecureTime = SecureTime - 1
            Citizen.Wait(1000)
			PlaySoundFrontend(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET", 1)
        end
    end
end)

function SecureObj()
	local SecureStartTime = 10 --5
    local SecureTime = SecureStartTime
    while securing == true do
		
        PLY = PlayerId()
        PLYN = GetPlayerName(PLY)
		
			--UGGH... FIX FOR WHEN PLAYER LEAVES MARKER, STOP SECURING
			for k,v in pairs(Config.Missions[MissionName].Marker) do
					--print("hey")
					ply = PlayerId()
					coords = GetEntityCoords(GetPlayerPed(ply))
					if (Config.Missions[MissionName].Marker.Position.z <= 0.0) then

						
						--print("heya")
						--workaround for when ground z is not found in random anywhere missions
							if(GetDistanceBetweenCoords(coords.x,coords.y,0.0, Config.Missions[MissionName].Marker.Position.x, Config.Missions[MissionName].Marker.Position.y, 0.0, true) > Config.Missions[MissionName].Marker.Size.x / 2) then
								--print("hey1")
								securing = false
							end						
						
					else
						--print("heyb")
						--workaround for when groun
								if(GetDistanceBetweenCoords(coords.x,coords.y,coords.z, Config.Missions[MissionName].Marker.Position.x, Config.Missions[MissionName].Marker.Position.y, Config.Missions[MissionName].Marker.Position.z, true) > Config.Missions[MissionName].Marker.Size.x / 2) then
								--print("hey2")
								securing = false
							end
						
					end
				end		
		
        if SecureTime > 0 and SecureTime < SecureStartTime then
	
   
			
			local messageProgress  = "~u~(~g~Capture Progress: ~r~".. SecureTime .."~u~)"
			--TriggerEvent('chatMessage', "^1[MISSIONS]: ^0 Capture Progress: ^1"..(SecureTime))
			 SecureTime = SecureTime - 1
			--drawMessage(messageProgress,1000) 
			--for some reason not working all the time for non host clients so use drawMessage above as well
			message = messageProgress
           TriggerEvent("mt:missiontext2", message, 1000)
            Citizen.Wait(1000)
			PlaySoundFrontend(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET", 1)
        end
        if SecureTime == 0 then
            securing = false
			local reasontext = PLYN .." has captured the objective!"
            message  = "^1[MISSIONS]: ^2".. PLYN .."^0 has captured the objective!"
            message2 = "^1[MISSIONS]: ^2'".. Config.Missions[MissionName].MissionTitle .."'^0 has been completed!"
            TriggerServerEvent("sv:two", message)
            TriggerServerEvent("sv:two", message2)
           -- Active = 0
			--TriggerServerEvent("sv:done", MissionName)
            ----TriggerEvent("DONE", MissionName)
            --aliveCheck()
			local oldmission = MissionName
			--MissionName = "N/A"
		    --Reward player
			local objectivemoney
			if Config.Missions[MissionName].FinishedObjectiveReward then
				objectivemoney = Config.Missions[MissionName].FinishedObjectiveReward
			else 
				objectivemoney = Config.FinishedObjectiveReward
			end

			playerSecured = true
			
			TriggerEvent('ExitOldMissionAndStartNewMission',oldmission,false,reasontext) --GHK Start New Mission
            --MissionName = "N/A"
        end
        
        if SecureTime == SecureStartTime then
            TriggerEvent("chatMessage", "You are now capturing the objective.")
           -- message  = "^1[MISSIONS]: ^2".. PLYN .."^0 is now capturing the objective."
          --  message2  = "^1[MISSIONS]: ^0Capture Progress: ^1".. SecureTime
           -- TriggerServerEvent("sv:two", message)
           -- TriggerEvent("chatMessage", message2)
			TriggerEvent("mt:missiontext2", "~u~(~g~Capture Progress: ~r~".. SecureTime .."~u~)", 1000)
			PlaySoundFrontend(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET", 1)
            SecureTime = SecureTime - 1
            Citizen.Wait(1000)
			PlaySoundFrontend(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET", 1)
        end
    end
end

--Used for safehouses to 'buy'/buy mission critical pickups 
--and get max health/armor
function BuyObj()

	local BuyStartTime = 30
    local BuyTime = BuyStartTime
    while buying == true do
		
		if not (Active == 1 and MissionName ~="N/A") then 
			buying = false
			return
		end		
	
	
		if(getMissionConfigProperty(MissionName, "SafeHouseGiveImmediately")) then 
			BuyTime = 0
		end
		
				for k,v in pairs(Config.Missions[MissionName].MarkerS) do
				
						if Active == 1 and MissionName ~="N/A" and Config.Missions[MissionName].MarkerS  and ((GetGameTimer() - getMissionConfigProperty(MissionName, "SafeHouseTimeTillNextUse")) > playerSafeHouse) then
								--print("heya")
							ply = PlayerId()
							coords = GetEntityCoords(GetPlayerPed(ply))
							--workaround for when ground z is not found in random anywhere missions
							if (Config.Missions[MissionName].MarkerS.Position.z <= 0.0) then 
								--print("hey1")
								if(GetDistanceBetweenCoords(coords.x,coords.y,0.0, Config.Missions[MissionName].MarkerS.Position.x, Config.Missions[MissionName].MarkerS.Position.y, 0.0, true) > Config.Missions[MissionName].MarkerS.Size.x / 2) then
									--print("hey4")
									buying = false
									return
									
								end						
							
							else
								--print("heyb:"..coords.x)
								--hack for small radius missions
								local testradius = Config.Missions[MissionName].MarkerS.Size.x / 2
								if Config.Missions[MissionName].MarkerS.Size.x <= 2.0 then 
									testradius = 1.5
								end
								if(GetDistanceBetweenCoords(coords.x,coords.y,coords.z, Config.Missions[MissionName].MarkerS.Position.x, Config.Missions[MissionName].MarkerS.Position.y, Config.Missions[MissionName].MarkerS.Position.z, true) > testradius) then
										--print("hey3")
										buying = false
										return
									
								end
							end
						end
				end	

			--if DecorGetInt(GetPlayerPed(ply),"mrpoptout") == 1 then 
				--print("hey buy no optin")
				
			--end				
		
		
        PLY = PlayerId()
        PLYN = GetPlayerName(PLY)
        if BuyTime > 0 and BuyTime < BuyStartTime then
           -- message  = "~u~(~g~Receiving Equipment and Attention: ~r~".. BuyTime .."~u~)"
           -- BuyTime = BuyTime - 1
           -- TriggerEvent("mt:missiontext2", message, 1000)
            --Citizen.Wait(1000)
			if Active == 1 and MissionName ~="N/A" then
				local upgrademessage = "Receiving Equipment~n~and Medical Attention"
				if getMissionConfigProperty(MissionName, "SafeHouseCrackDownMode") then
					upgrademessage = "Receiving Equipment~n~and Cybernetic Upgrades"
				end
				
				BuyTime = BuyTime - 1
				message  = "~g~"..upgrademessage.."~n~".. (BuyTime+1)
				TriggerEvent("mt:missiontext2", message, 250)
				Citizen.Wait(250)
				message  = "~g~"..upgrademessage.."~n~".. (BuyTime+1)
				TriggerEvent("mt:missiontext2", message, 250)
				Citizen.Wait(250)
				message  = "~g~"..upgrademessage.."~n~".. (BuyTime+1)
				TriggerEvent("mt:missiontext2", message, 250)
				Citizen.Wait(250)
				message  = "~g~"..upgrademessage.."~n~".. (BuyTime+1)
				TriggerEvent("mt:missiontext2", message, 250)
				Citizen.Wait(250)
				PlaySoundFrontend(-1, "MP_5_SECOND_TIMER", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
			end
			--message  = "~g~Receiving Equipment~n~and Medical Attention~n~. . . ."
			--TriggerEvent("mt:missiontext2", message, 200)
			--Citizen.Wait(200)
			--message  = "~g~Receiving Equipment~n~and Medical Attention~n~. . . . ."
			--TriggerEvent("mt:missiontext2", message, 200)
			--Citizen.Wait(200)
			--print("props:"..GetNumberOfPedPropDrawableVariations(GetPlayerPed(-1),0))
			
        end
        if BuyTime <= 0 then
			--max out health and armor
			 if Active == 1 and MissionName ~="N/A" then

				
				if getMissionConfigProperty(MissionName, "SafeHouseCrackDownMode") then
					SetPedMaxHealth(GetPlayerPed(-1), getMissionConfigProperty(MissionName, "SafeHouseCrackDownModeHealthAmount"))
					SetEntityHealth(GetPlayerPed(-1), getMissionConfigProperty(MissionName, "SafeHouseCrackDownModeHealthAmount"))
					SetPlayerMaxArmour(GetPlayerPed(-1),100)
					AddArmourToPed(GetPlayerPed(-1), 100)
					SetPedArmour(GetPlayerPed(-1), 100)
					
					SetPedMoveRateOverride(PlayerId(),10.0)
					SetRunSprintMultiplierForPlayer(PlayerId(),1.49)
					SetSwimMultiplierForPlayer(PlayerId(),1.49)
					--SetPedPropIndex(GetPlayerPed(-1), 0, 0, 0, 2) --give hat
					--SetPedPropIndex(GetPlayerPed(-1), 0, 0, 4,2)
					--SetPedComponentVariation(GetPlayerPed(-1), 9, 4, 1, 2) --give armor
					--SetPedComponentVariation(player, 9, 6, 1, 2)
					playerUpgraded = true
					Notify("~b~Nano-bio upgrades given...")
					Notify("~b~You can run and swim much faster")
					Notify("~b~You can jump much higher")
					Notify("~b~Your health is greatly increased")
					if(getMissionConfigProperty(MissionName, "RegenHealthAndArmour")) then
						Notify("~b~You will regenerate health more quickly")
					end
				else
					--DOES THIS WORK? IT DOES NOT FOR ARMOR BELOW
					SetPedMaxHealth(GetPlayerPed(-1), Config.DefaultPlayerMaxHealthAmount)
					SetEntityHealth(GetPlayerPed(-1),Config.DefaultPlayerMaxHealthAmount)
					AddArmourToPed(GetPlayerPed(-1),100)
					SetPedArmour(GetPlayerPed(-1), 100)						
					--AddArmourToPed(GetPlayerPed(-1), GetPlayerMaxArmour(GetPlayerPed(-1)))
					--SetPedArmour(GetPlayerPed(-1), GetPlayerMaxArmour(GetPlayerPed(-1)))				
				
				end
			
			--give players
				getSpawnSafeHousePickups(MissionName)
				getSpawnSafeHouseComponents(MissionName)
				--call twice, to make sure all custom rounds get added. Not sure why it doesnt work first time.
				getSpawnSafeHousePickups(MissionName)
				getSpawnSafeHouseComponents(MissionName)	
				
				--default in game is 40 rounds for explosive heavy sniper rounds. Alter this for some balance:
				SetPedAmmoByType(GetPlayerPed(-1), 0xADD16CB9, getMissionConfigProperty(MissionName, "SafeHouseSniperExplosiveRoundsGiven"))
				
				local safehousecost = calcSafeHouseCost(true,false,false,MissionName)
				--if safehousecost ~= 0 then 
					--message  = "You have received your mission equipment and health~n~Check your inventory~n~Cost: $"..safehousecost	
				--else 
					message  = "You have received your mission equipment and upgrades~n~Check your inventory~n~Good luck!"		
				--end	
				TriggerEvent("mt:missiontext2", message, 10000)
				playerSafeHouse = GetGameTimer()
				PlaySoundFrontend(-1, "GO", "HUD_MINI_GAME_SOUNDSET", 1)			
				
			end
				buying = false
        end
        
        if BuyTime == BuyStartTime then
           -- TriggerEvent("chatMessage", "You have reached the mission safehouse.")
            --message  = "^1[MISSIONS]: ^2".. PLYN .."^0 is now capturing the objective."
            --message2  = "^1[MISSIONS]: ^1(Capture Progress: ".. BuyTime .." )"
			PlaySoundFrontend(-1, "MP_RANK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
			if Active == 1 and MissionName ~="N/A" then
				if(calcSafeHouseCost(false,false,false,MissionName) > 0) then 
					message = "You have reached the mission safe house!~n~You will get health, armor, upgrades and supplies here"
					TriggerEvent("mt:missiontext2", message, 5000)
					Citizen.Wait(4000)
					if Active == 1 and MissionName ~="N/A" then
						message = "Cost will be: $"..calcSafeHouseCost(false,false,false,MissionName).."~n~Claiming a vehicle will cost: $"..calcSafeHouseCost(false,true,false,MissionName)
						TriggerEvent("mt:missiontext2", message, 5000)
						Citizen.Wait(3000)
					end
					if Active == 1 and MissionName ~="N/A" then
						message = "You can claim a total of ".. getMissionConfigProperty(MissionName, "SafeHouseVehiclesMaxClaim") .." vehicles~n~for this mission"
						TriggerEvent("mt:missiontext2", message, 5000)
						Citizen.Wait(3000)					
					end 
					BuyTime = BuyTime - 10				
				else 
					message = "You have reached the mission safe house!~n~You will get health, armor, upgrades and supplies here"
					TriggerEvent("mt:missiontext2", message, 5000)
					Citizen.Wait(5000)
					BuyTime = BuyTime - 5
				end
				if Active == 1 and MissionName ~="N/A" then
					TriggerEvent("mt:missiontext2", message, 5000)
				
					if(getMissionConfigProperty(MissionName, "SafeHouseGiveNoCountDown")) then 
						BuyTime = 0
					end
				end
			end
            --TriggerServerEvent("sv:two", message)
            --TriggerEvent("chatMessage", message2)
            
           
        end
    end
end


function DrawText3D(coords, text, size)
	local onScreen, x, y = World3dToScreen2d(coords.x, coords.y, coords.z)
	local camCoords      = GetGameplayCamCoords()
	local dist           = GetDistanceBetweenCoords(camCoords, coords.x, coords.y, coords.z, true)
	local size           = size

	if size == nil then
		size = 1
	end

	local scale = (size / dist) * 2
	local fov   = (1 / GetGameplayCamFov()) * 100
	local scale = scale * fov

	if onScreen then
		SetTextScale(0.0 * scale, 0.55 * scale)
		SetTextFont(0)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 255)
		SetTextDropshadow(0, 0, 0, 0, 255)
		SetTextEdge(2, 0, 0, 0, 150)
		SetTextDropShadow()
		SetTextOutline()
		SetTextEntry('STRING')
		SetTextCentre(1)

		AddTextComponentString(text)
		DrawText(x, y)
	end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
		
        if MissionName ~= "N/A" then
			
			--if Config.Missions[MissionName].Props[1].id then 
				
				--DrawText3D({x = Config.Missions[MissionName].Props[1].Position.x, y = Config.Missions[MissionName].Props[1].Position.y, z = Config.Missions[MissionName].Props[1].Position.z}, 'Press [~g~SHIFT~w~] and [~g~E~w~] to push the vehicle', 0.6)
				
			--end
		   if Config.Missions[MissionName].Type == "Objective" or (Config.Missions[MissionName].Type == "Assassinate" and Config.Missions[MissionName].IsDefend and not Config.Missions[MissionName].IsDefendTarget) or
			(Config.Missions[MissionName].Type == "Assassinate" and Config.Missions[MissionName].IsDefend and Config.Missions[MissionName].IsDefendTarget
			and Config.Missions[MissionName].IsDefendTargetRewardBlip 
			)

		   then 
				for k,v in pairs(Config.Missions[MissionName].Marker) do
					local coords = GetEntityCoords(GetPlayerPed(-1))
					if(GetDistanceBetweenCoords(coords.x,coords.y,coords.z, Config.Missions[MissionName].Marker.Position.x, Config.Missions[MissionName].Marker.Position.y, Config.Missions[MissionName].Marker.Position.z, true) < Config.Missions[MissionName].Marker.DrawDistance) then
						DrawMarker(Config.Missions[MissionName].Marker.Type, Config.Missions[MissionName].Marker.Position.x, Config.Missions[MissionName].Marker.Position.y, Config.Missions[MissionName].Marker.Position.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.Missions[MissionName].Marker.Size.x, Config.Missions[MissionName].Marker.Size.y, Config.Missions[MissionName].Marker.Size.z, Config.Missions[MissionName].Marker.Color.r, Config.Missions[MissionName].Marker.Color.g, Config.Missions[MissionName].Marker.Color.b, 100, false, true, 2, false, false, false, false)
						
						if (Config.Missions[MissionName].Type == "Objective" or (Config.Missions[MissionName].Type == "Assassinate" and Config.Missions[MissionName].IsDefendTargetRewardBlip ) ) and getMissionConfigProperty(MissionName, "DrawObjectiveMarker")  then 
							--if(getMissionConfigProperty(MissionName, "DrawObjectiveMarker")) then
								
							DrawMarker(2, Config.Missions[MissionName].Marker.Position.x, Config.Missions[MissionName].Marker.Position.y, Config.Missions[MissionName].Marker.Position.z + Config.Missions[MissionName].Marker.Size.z, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 1.0, 1.0, 1.0, 240, 203, 88, 100, true, true, 2, false, false, false, false)								
								
								--DrawText3D({x =  Config.Missions[MissionName].Marker.Position.x, y = Config.Missions[MissionName].Marker.Position.y, z = Config.Missions[MissionName].Marker.Position.z + Config.Missions[MissionName].Marker.Size.z}, "~g~Objective",2.0)  --($"..getObjectiveReward(MissionName)..")", 1.6)						
							--end
						elseif (Config.Missions[MissionName].Type == "Assassinate" and Config.Missions[MissionName].IsDefend and getMissionConfigProperty(MissionName, "DrawIsDefendMarker")) then 
							--if(getMissionConfigProperty(MissionName, "DrawIsDefendMarker")) then
							--DrawMarker(2, Config.Missions[MissionName].Marker.Position.x, Config.Missions[MissionName].Marker.Position.y, Config.Missions[MissionName].Marker.Position.z + 25, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 15.6, 15.6, 15.6, 255, 59, 59, 100, true, true, 2, false, false, false, false)								
								DrawText3D({x =  Config.Missions[MissionName].Marker.Position.x, y = Config.Missions[MissionName].Marker.Position.y, z = Config.Missions[MissionName].Marker.Position.z + 25}, "~r~Defend Zone", 15.6)						
							--end				
						
						
						end
										
					
					end
					
				end
			end
			
			if getMissionConfigProperty(MissionName, "UseMissionDrop") then 
				if MissionDropBlip then
					DrawMarker(40, MissionDropBlipCoords.x, MissionDropBlipCoords.y, MissionDropBlipCoords.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.0,3.0, 3.0, 117, 218, 255, 100, true, true, 2, true, false, false, false)					
				
				end
			
			end
			if getMissionConfigProperty(MissionName, "UseSafeHouse") then 
			   if (GetGameTimer() - getMissionConfigProperty(MissionName, "SafeHouseTimeTillNextUse")) > playerSafeHouse then
					for k,v in pairs(Config.Missions[MissionName].MarkerS) do
						local coords = GetEntityCoords(GetPlayerPed(-1))
						if(GetDistanceBetweenCoords(coords.x,coords.y,coords.z, Config.Missions[MissionName].MarkerS.Position.x, Config.Missions[MissionName].MarkerS.Position.y, Config.Missions[MissionName].MarkerS.Position.z, true) < Config.Missions[MissionName].MarkerS.DrawDistance) then
							DrawMarker(Config.Missions[MissionName].MarkerS.Type, Config.Missions[MissionName].MarkerS.Position.x, Config.Missions[MissionName].MarkerS.Position.y, Config.Missions[MissionName].MarkerS.Position.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.Missions[MissionName].MarkerS.Size.x, Config.Missions[MissionName].MarkerS.Size.y, Config.Missions[MissionName].MarkerS.Size.z, Config.Missions[MissionName].MarkerS.Color.r, Config.Missions[MissionName].MarkerS.Color.g, Config.Missions[MissionName].MarkerS.Color.b, 100, false, true, 2, false, false, false, false)
						end
					end
					if not SafeHouseBlipOn then 
						SafeHouseBlipOn = (not SafeHouseBlipOn) 
						--SetBlipSprite (SafeHouseBlip, 417)
						SetBlipColour(SafeHouseBlip, 2)
						 TriggerEvent('chatMessage', "^1[MISSIONS]: ^2the mission safe house is open.")
						
					end
				else 
					if SafeHouseBlipOn then 
						SafeHouseBlipOn = (not SafeHouseBlipOn) 
						SetBlipColour(SafeHouseBlip, 40)
						 TriggerEvent('chatMessage', "^1[MISSIONS]: ^2the mission safe house is closed.")
					end
				
				end			
			end
        end
    end
end)

--get Player value based on 
function DecorValueInt(ply,decorvar) 

    if not DecorGetInt(GetPlayerPed(ply), decorvar) then
        return 0
    elseif DecorGetInt(GetPlayerPed(ply), decorvar) then
        return DecorGetInt(GetPlayerPed(ply), decorvar)
    end

end

--night vision toggle
blDoNightVision = false
blDoNightVisionToggleState = 0
blDoNightVisionToggleStates = 0
--[[
if getMissionConfigProperty(MissionName, "EnableNightVision")  then
	blDoNightVisionToggleStates = blDoNightVisionToggleStates + 1 
end
if getMissionConfigProperty(MissionName, "EnableThermalVision") then 
	blDoNightVisionToggleStates = blDoNightVisionToggleStates + 1
end
]]--
--deals with safehouse vehicles + night vision modes
--hopefully GetPlayerServerId(PlayerId()) always returns > 0
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
		
		
	--Left stick down + right stick down ( C + Left Ctrl)
		if (IsControlPressed(0, 36) and IsControlPressed(0, 26)) and DecorGetInt(GetPlayerPed(-1),"mrpoptout") == 0 and true then
			
		
			if  Active == 1 and MissionName ~="N/A" then
				
				if blDoNightVisionToggleStates == 1 then
					if blDoNightVision then 
						if getMissionConfigProperty(MissionName, "EnableNightVision")  then
							SetNightvision(false)  -- disables the night vision
						end
						if getMissionConfigProperty(MissionName, "EnableThermalVision") then 
							SetSeethrough(false) -- disables the thermal 
						end
						blDoNightVision	= false
						
					else 
						if getMissionConfigProperty(MissionName, "EnableNightVision") then
							SetNightvision(true)  -- Enables the night vision
						end
						if getMissionConfigProperty(MissionName, "EnableThermalVision") then 
							SetSeethrough(true) -- Enables the thermal vision.
						end
						blDoNightVision	= true
					end
				elseif blDoNightVisionToggleStates == 2 then 
					
					if(blDoNightVisionToggleState == 0) then
						SetSeethrough(false) -- disables the thermal 
						SetNightvision(true)  -- Enables the night vision
						blDoNightVisionToggleState = blDoNightVisionToggleState + 1
					elseif (blDoNightVisionToggleState == 1) then 
						SetNightvision(false)  -- disables the night vision
						SetSeethrough(true) -- Enables the thermal vision.
						
						blDoNightVisionToggleState = blDoNightVisionToggleState + 1
					elseif (blDoNightVisionToggleState == 2) then 						
						SetSeethrough(false) -- disables the thermal 
						SetNightvision(false)  -- disables the night vision
						blDoNightVisionToggleState = 0
					end 
					
				end
				
				
			end

			
		end 
		
		
		if Active == 1 and MissionName ~="N/A" then
			if PedsSpawned == 1 then
			local PlayerPed = GetPlayerPed(-1)
				if IsPedInAnyVehicle(PlayerPed, false) then
					local PedVeh = GetVehiclePedIsIn(PlayerPed,false)
					--in drivers seat?
					--print("PED IN VEHICLE")
					if(PlayerPed == GetPedInVehicleSeat(PedVeh,-1)) then 
						--print("PED IN DRIVERS SEAT")
						--print("playerserverid:"..GetPlayerServerId(PlayerId()))	
						if(DecorGetInt(PedVeh,"mrpvehsafehouse") > 0) then
							
							if DecorGetInt(GetPlayerPed(-1),"mrpoptout") == 0 then 
								--does safehouse vehicle have an owner?
								if(DecorGetInt(PedVeh,"mrpvehsafehouseowner")) > 0 then 
									
									--is the owner not the player?
									if (GetPlayerServerId(PlayerId()) ~= DecorGetInt(PedVeh,"mrpvehsafehouseowner")) then
										TaskLeaveVehicle(PlayerPed, PedVeh, 0)
										
										TriggerEvent("mt:missiontext2", "This mission vehicle is~n~owned by another player",10000)
										Notify("~b~This mission vehicle is~n~owned by another player")
									end
							
								else 
									--bill the player and give ownership to them 
									--if they have not maxed out on max claims per mission
									--stops grieving. 
									if DecorGetInt(PlayerPed,"mrpvehsafehousemax") < getMissionConfigProperty(MissionName, "SafeHouseVehiclesMaxClaim") then
									
										calcSafeHouseCost(true,true,false,MissionName)
										DecorSetInt(PedVeh,"mrpvehsafehouseowner",GetPlayerServerId(PlayerId()))
										local mrpvehsafehousemax =  DecorValueInt(-1,"mrpvehsafehousemax") + 1
										--print("mrpvehsafehousemax:"..mrpvehsafehousemax)
										DecorSetInt(PlayerPed,"mrpvehsafehousemax",mrpvehsafehousemax)
										mrpvehsafehousemaxG = mrpvehsafehousemax  
										--print("mrpvehsafehousemax:"..tostring(DecorGetInt(PlayerPed,"mrpvehsafehousemax")))
										local messageOwner = "You claimed yourself a mission vehicle!~n~Cost is: $"..calcSafeHouseCost(false,true,false,MissionName)
										TriggerEvent("mt:missiontext2", messageOwner,10000)
										--print("vehicle server id:"..DecorGetInt(PedVeh,"mrpvehsafehouseowner"))
										Notify("~b~You claimed yourself a mission vehicle!~n~Cost is: $"..calcSafeHouseCost(false,true,false,MissionName))
										
									else
										TaskLeaveVehicle(PlayerPed, PedVeh, 0)
										local messageOwner = "Your available mission vehicles have maxed out!~n~Use a non mission vehicle. Or ride with another"
										TriggerEvent("mt:missiontext2", messageOwner,10000)
										--print("player mrpvehsafehousemax:"..DecorGetInt("mrpvehsafehousemax",PlayerPed))
										Notify("~b~Your available mission vehicles have maxed out!")
										Notify("~b~Use a non mission vehicle. Or ride with another")
									end
								end
							else
								local messageOwner =  "This is a mission vehicle. Join the mission to be able to use it"
								TriggerEvent("mt:missiontext2", messageOwner,10000)
								Notify("~b~This is a mission vehicle. Join the mission to be able to use it")
								--TriggerEvent("chatMessage", "^1^*[MISSIONS]: ^1This is a mission vehicle. Join the mission to be able to use it")
								TaskLeaveVehicle(PlayerPed, PedVeh, 0)
								
							end
							
						end
					end
	
				end
				
				
			end
		
			
		end	
		

	
    end
end)

Citizen.CreateThread(function()
    while true do
       
	   Wait(1000)
	
		if Active == 1 and MissionName ~="N/A" then
		
		
			if PedsSpawned == 1 then
				local playerPed = GetPlayerPed(-1)
				local pcoords = GetEntityCoords(playerPed,true)			
				for ped in EnumeratePeds() do
					if (DecorGetInt(ped, "mrppedtarget") > 0) then	
						if not IsEntityDead(ped)  then
						
							local o1 = GetEntityCoords(ped, true)
							local distance = GetDistanceBetweenCoords(o1.x,o1.y,o1.z, pcoords.x, pcoords.y, pcoords.z,true)
							if(distance <= 300) then	
								--DrawText3D({x = o1.x, y =o1.y, z = o1.z + 1.0}, "~r~Target", 1.0)
								
								o1 = o1 + vector3(0.0,0.0,1.0)
								--print("Add:"..DecorGetInt(ped, "mrppedtarget"))
								RescueMarkers['t'..DecorGetInt(ped, "mrppedtarget")] = {entity=ped,coords=o1,dist=distance,rtype=0}
							else 
								RescueMarkers['t'..DecorGetInt(ped, "mrppedtarget")] = nil										  
							end
						else 
							if RescueMarkers['t'..DecorGetInt(ped, "mrppedtarget")] then
								RescueMarkers['t'..DecorGetInt(ped, "mrppedtarget")] = nil	
							end
						end									
					end 
					
					if (DecorGetInt(ped, "mrppedfriend") > 0 and not (IsEntityDead(ped) == 1) )  then					
						--if getMissionConfigProperty(MissionName, "DrawText3D") then  
								local o1 = GetEntityCoords(ped, true)
								local distance = GetDistanceBetweenCoords(o1.x,o1.y,o1.z, pcoords.x, pcoords.y, pcoords.z,true)
								if(distance <= 300)  then									
									--DrawText3D({x = o1.x, y =o1.y, z = o1.z + 1.0}, "~g~Friendly Rescue", 1.0)
									o1 = o1 + vector3(0.0,0.0,1.0)
								
									RescueMarkers['f'..DecorGetInt(ped, "mrppedfriend")] = {entity=ped,coords=o1,dist=distance,rtype=1}
								else 
									RescueMarkers['f'..DecorGetInt(ped, "mrppedfriend")] = nil									
								end
						--end
					else
						if RescueMarkers['f'..DecorGetInt(ped, "mrppedfriend")] then
							RescueMarkers['f'..DecorGetInt(ped, "mrppedfriend")] = nil						
						end
					end
					if getMissionConfigProperty(MissionName, "IsDefend") and getMissionConfigProperty(MissionName, "IsDefendTarget") and (DecorGetInt(ped, "mrppeddefendtarget") > 0) then 
						if  not (IsEntityDead(ped) == 1)  then
							local o1 = GetEntityCoords(ped, true)
							local distance = GetDistanceBetweenCoords(o1.x,o1.y,o1.z, pcoords.x, pcoords.y, pcoords.z,true)
							if(distance <= 300) then
								--DrawText3D({x = o1.x, y =o1.y, z = o1.z +1.0}, "~y~Rescue Target", 1.0)
								o1 = o1 + vector3(0.0,0.0,1.0)
								RescueMarkers['d'..DecorGetInt(ped, "mrppeddefendtarget")] = {entity=ped,coords=o1,dist=distance,rtype=2}
							else 
								RescueMarkers['d'..DecorGetInt(ped, "mrppeddefendtarget")] = nil								
							end
						else 
							if RescueMarkers['d'..DecorGetInt(ped, "mrppeddefendtarget")] then 
								RescueMarkers['d'..DecorGetInt(ped, "mrppeddefendtarget")] = nil
							end
						end				
					
					
					end
					
					
				end	
				
				for obj in EnumerateObjects() do
					
					if (DecorGetInt(obj, "mrpproprescue") > 0)  then

						local o1 = GetEntityCoords(obj, true)
						local distance = GetDistanceBetweenCoords(o1.x,o1.y,o1.z, pcoords.x, pcoords.y, pcoords.z,true)
						if(distance <= 300) then	
								--DrawText3D({x = o1.x, y =o1.y, z = o1.z}, "~o~Objective ($"..getMissionConfigProperty(MissionName, "ObjectRescueReward")..")", 0.6)
							--DrawText3D({x = o1.x, y =o1.y, z = o1.z + 1.0}, "~o~Objective", 1.0)
							--print("ADD OBJECT")
							
							local First = vector3(0.0, 0.0, 0.0)
							local Second = vector3(500.0, 500.0, 500.0)
							local dimension = GetModelDimensions(GetEntityModel(obj), First, Second)
							local ox = 1.0
							local oy = 1.0 
							local oz = 1.0 
							if math.abs(dimension.x) > ox then ox = math.abs(dimension.x) end
							if math.abs(dimension.y) > oy then oy = math.abs(dimension.y) end
							if math.abs(dimension.z) > oz then oz = math.abs(dimension.z) end	
							
							if false then
								if ox > oy then oy = ox end 
								if oy > oz then oz = oy end
							end
							
							--ughh, just make the marker 2x the height of the model, else 2m if z < 1m
							--dimension.z does not seem to get the roof of hollow (ish) models or the peak height, just the middle of model height, sans roof if hollow in middle
							o1 = o1 + vector3(0,0,2*oz)
							--print(oz)
							RescueMarkers['o'..DecorGetInt(obj, "mrpproprescue")] = {entity=obj,coords=o1,dist=distance,rtype=3}								
						else
							if(RescueMarkers['o'..DecorGetInt(obj, "mrpproprescue")]) then 
								RescueMarkers['o'..DecorGetInt(obj, "mrpproprescue")] = nil
							end
						end
						--end					
					end

				end
				
			end
		
		end	
		

	
    end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
		--print(DecorGetInt(GetPlayerPed(-1),"mrpoptout"))
		if DecorGetInt(GetPlayerPed(-1),"mrpoptin") == 0 and Config.EnableOptIn then 
			DecorSetInt(GetPlayerPed(-1),"mrpoptout",1)
			

			--RB + DPAD UP or 'Q' and ']' keys --opt in
			if  Active == 1 and MissionName ~="N/A" then			
				if (IsControlPressed(0, 44) and IsControlPressed(0, 42)) then 
					DecorSetInt(GetPlayerPed(-1),"mrpoptout",0)
					DecorSetInt(GetPlayerPed(-1),"mrpoptin",1)
					--DecorSetInt(GetPlayerPed(-1),"mrpoptin_teleportcheck",1)
					--Notify("~g~You can leave the mission anytime with ~o~'Q' and '[' ~g~keys or ~o~RB + DPAD DOWN")
					Notify("~g~You have joined the fight!")
					--Notify("~b~You can opt out after the mission is over with the '~o~Q~b~' and '~o~[~b~' keys or ~o~RB + DPAD DOWN")
					
					HelpMessage("You can opt out after the mission is over with ~INPUT_SNIPER_ZOOM_OUT_SECONDARY~ and ~INPUT_COVER~",false,5000)
					
					if getMissionConfigProperty(MissionName,"TeleportToSafeHouseOnMissionStart") then 
						doTeleportToSafeHouse(false)
					end
					--if  Active == 1 and MissionName ~="N/A" then
						--local players = {}
						--local cnt = 0
						--ptable = GetPlayers()
						--for _, i in ipairs(ptable) do
							--cnt = cnt + 1 
						--end	
						--playerSafeHouse = -1000000 --records game time
						--if cnt == 1 then
							--TriggerServerEvent("sv:checkmission",true)
							--print("sv:checkmission,true")
						--else
							--TriggerServerEvent("sv:checkmission",false)
							--print("sv:checkmission,false")
						--end					
						
					--end
				end
			end
		elseif DecorGetInt(GetPlayerPed(-1),"mrpoptin") == 1 and Config.EnableOptIn then 
			--RB + DPAD DOWN or 'Q' and '[' keys--opt out
			if  Active == 0 and MissionName =="N/A" then			
				if (IsControlPressed(0, 44) and IsControlPressed(0, 43))  then 
					DecorSetInt(GetPlayerPed(-1),"mrpoptout",1)
					DecorSetInt(GetPlayerPed(-1),"mrpoptin",0)
					playerUpgraded = false
					SetPedMaxHealth(GetPlayerPed(-1),200)
					SetEntityHealth(GetPlayerPed(-1),200)		
					SetPedMoveRateOverride(PlayerId(),1.0) --1.0 is default?
					SetRunSprintMultiplierForPlayer(PlayerId(),1.0)
					SetSwimMultiplierForPlayer(PlayerId(),1.0)
					SetNightvision(false)	
					SetSeethrough(false)
					blDoNightVisionToggleState = 0
					blDoNightVisionToggleStates = 0
					blDoNightVision = false								
					Notify("~r~You have left the fight")
					--Notify("~b~Press '~o~Q~b~' and '~o~]~b~' or ~o~RB + DPAD UP~b~ to join a mission")
					HelpMessage("Press ~INPUT_SNIPER_ZOOM_IN_SECONDARY~ and ~INPUT_COVER~ to join a mission",false,5000)
				end	
			end
			
		end
		--print(Config.EnableSafeHouseOptIn)
		if DecorGetInt(GetPlayerPed(-1),"mrpoptin") == 0 and Config.EnableSafeHouseOptIn then 
			DecorSetInt(GetPlayerPed(-1),"mrpoptout",1)
			


			--DPAD UP or  ']' keys --opt in
			if  Active == 1 and MissionName ~="N/A" then
				
				--when player is within safehouse marker
				if buying then 
					Notify("Mission: ~r~"..Config.Missions[MissionName].MissionTitle.."~g~")
					--Notify("~b~Press ~o~']'~b~key or ~o~DPAD UP~b~ to join the mission")
					--print("hey")
				HelpMessage("Press ~INPUT_SNIPER_ZOOM_IN_SECONDARY~ to join the mission",false,5000)					
				end			
				if (IsControlPressed(0, 42)) and buying then 
					DecorSetInt(GetPlayerPed(-1),"mrpoptout",0)
					DecorSetInt(GetPlayerPed(-1),"mrpoptin",1)
					--DecorSetInt(GetPlayerPed(-1),"mrpoptin_teleportcheck",1)
					Notify("~g~You have joined the fight!")
					--Notify("~b~You can opt out of missions after the mission is over with the '~o~[~b~' key or ~o~DPAD DOWN")
					HelpMessage("You can opt out of missions after the mission is over with ~INPUT_SNIPER_ZOOM_OUT_SECONDARY~ ",false,5000)
					buying = false
					--print("MADE IT")
					if(getMissionConfigProperty(MissionName, "UseSafeHouse")) then 
						Notify("~b~Use safe houses to get upgrades and supplies. Cost~c~: $"..getMissionConfigProperty(MissionName, "SafeHouseCost"))
					end
					if(getMissionConfigProperty(MissionName, "UseSafeHouseCrateDrop")) then 
						Notify("~b~You can also get upgrades and supplies dropped to you with safe house air drops")
						Notify("~b~Press gamepad RB + DPAD LEFT together or Q & SCROLLWHEEL UP together to get them dropped. Cost~c~: $"..getMissionConfigProperty(MissionName, "SafeHouseCostCrate"))
					end
					if(getMissionConfigProperty(MissionName, "UseSafeHouseBanditoDrop")) then 
						Notify("~b~You can also deploy and use a number of rc detonate bombs, like drones")
						Notify("~b~Press gamepad RB & DPAD RIGHT together or A & D together to deploy. Cost~c~: $"..getMissionConfigProperty(MissionName, "SafeHouseCostCrate"))
					end
					Notify("~b~Check your map for mission data")					
					
					--if  Active == 1 and MissionName ~="N/A" then
						--local players = {}
						--local cnt = 0
						--ptable = GetPlayers()
						--for _, i in ipairs(ptable) do
							--cnt = cnt + 1 
						--end	
						--playerSafeHouse = -1000000 --records game time
						--if cnt == 1 then
							--TriggerServerEvent("sv:checkmission",true)
							--print("sv:checkmission,true")
						--else
							--TriggerServerEvent("sv:checkmission",false)
							--print("sv:checkmission,false")
						--end					
						
					--end
				end
			end
			--allow opt outs when no mission running or between missions
			elseif DecorGetInt(GetPlayerPed(-1),"mrpoptin") == 1 and Config.EnableSafeHouseOptIn then 
			--print(DecorGetInt(GetPlayerPed(-1),"mrpoptout"))
			--RB + DPAD DOWN or 'Q' and '[' keys--opt out
			if  Active == 0 and MissionName =="N/A" then			
				if (IsControlPressed(0, 43))  then 
					DecorSetInt(GetPlayerPed(-1),"mrpoptout",1)
					DecorSetInt(GetPlayerPed(-1),"mrpoptin",0)
					playerUpgraded = false
					SetPedMaxHealth(GetPlayerPed(-1),200)
					SetEntityHealth(GetPlayerPed(-1),200)							
					SetPedMoveRateOverride(PlayerId(),1.0) --1.0 is default?
					SetRunSprintMultiplierForPlayer(PlayerId(),1.0)
					SetSwimMultiplierForPlayer(PlayerId(),1.0)
					SetNightvision(false)	
					SetSeethrough(false)
					blDoNightVisionToggleState = 0
					blDoNightVisionToggleStates = 0
					blDoNightVision = false								
					Notify("~r~You have left the fight")
					--Notify("~b~Go to a mission's safehouse and then press ~o~]~b~' key or ~o~DPAD UP~b~ to join the mission")
					HelpMessage("Go to a mission's safehouse and then press ~INPUT_SNIPER_ZOOM_IN_SECONDARY~ to join the mission",false,5000)
					--Notify("'~o~]~g~' key or ~o~DPAD UP~g~ to join the mission")
				end	
			end
			
		end		
		
		
		
	end 
end) 
	

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
			
		
        if MissionName ~= "N/A" then
			for k,v in pairs(RescueMarkers) do	
				--print(k)
				if(RescueMarkers[k]) then 
					--print(k..":.."..type(v["dist"]))
					 
					 if getMissionConfigProperty(MissionName, "DrawTargetMarker") and DoesEntityExist(v["entity"]) and v["dist"] <= 300 and v["rtype"] == 0 then 
					--	print(k)
						local ecoords = GetEntityCoords(v["entity"])
						DrawMarker(2, ecoords.x, ecoords.y, ecoords.z + 1.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.25, 0.25, 0.25, 255, 59, 59, 100, true, true, 2, false, false, false, false)											 
					 elseif getMissionConfigProperty(MissionName, "DrawRescueMarker") and DoesEntityExist(v["entity"]) and v["dist"] <= 300 and v["rtype"] == 1 then  
						--print(k..":.."..v["dist"])
						local ecoords = GetEntityCoords(v["entity"])
						DrawMarker(2, ecoords.x, ecoords.y, ecoords.z + 1.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.25, 0.25, 0.25, 121, 206, 121, 100, true, true, 2, false, false, false, false)
					 --target ped:
					 elseif getMissionConfigProperty(MissionName, "DrawIsDefendTargetMarker") and  DoesEntityExist(v["entity"]) and v["dist"] <= 300 and v["rtype"] == 2 then  
						--print(k..":.."..v["dist"])
						local ecoords = GetEntityCoords(v["entity"])
						DrawMarker(2, ecoords.x, ecoords.y, ecoords.z + 1.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.25, 0.25, 0.25, 240, 203, 88, 100, true, true, 2, false, false, false, false)
					 elseif getMissionConfigProperty(MissionName, "DrawObjectiveRescueMarker") and  DoesEntityExist(v["entity"]) and v["dist"] <= 300 and v["rtype"] == 3 then  
						--print(k..":.."..v["dist"])
						DrawMarker(2, v["coords"].x, v["coords"].y, v["coords"].z, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.25, 0.25, 0.25, 240, 203, 88, 100, true, true, 2, false, false, false, false)					
					
					else
						--print(tostring(k).." is nil")
						RescueMarkers[k] = nil
					 end
				end

			end
			
        end
    end
end)


--[[
Citizen.CreateThread(function()
    while true do
       
	   Wait(5)
	
		if Active == 1 and MissionName ~="N/A" then
		
		
			if PedsSpawned == 1 then
				local playerPed = GetPlayerPed(-1)
				local pcoords = GetEntityCoords(playerPed,true)			
				for ped in EnumeratePeds() do
					if (DecorGetInt(ped, "mrppedtarget") > 0) then	
						if not IsEntityDead(ped)  then
						
							local o1 = GetEntityCoords(ped, true)
							if( Vdist2(o1.x,o1.y,o1.z, pcoords.x, pcoords.y, pcoords.z) < 30) then	
								DrawText3D({x = o1.x, y =o1.y, z = o1.z + 1.0}, "~r~Target", 1.0)		
							end
						end									
					end 
					
					if (DecorGetInt(ped, "mrppedfriend") > 0 and not (IsEntityDead(ped) == 1) )  then					
						--if getMissionConfigProperty(MissionName, "DrawText3D") then  
								local o1 = GetEntityCoords(ped, true)
								if(Vdist2(o1.x,o1.y,o1.z, pcoords.x, pcoords.y, pcoords.z) < 30) then									
									DrawText3D({x = o1.x, y =o1.y, z = o1.z + 1.0}, "~g~Friendly Rescue", 1.0)
								end
						--end
					end
					if getMissionConfigProperty(MissionName, "IsDefend") and getMissionConfigProperty(MissionName, "IsDefendTarget") and (DecorGetInt(ped, "mrppeddefendtarget") > 0) and not IsEntityDead(ped) then 
						--if getMissionConfigProperty(MissionName, "DrawText3D") then
							local o1 = GetEntityCoords(ped, true)
							if(Vdist2(o1.x,o1.y,o1.z, pcoords.x, pcoords.y, pcoords.z) < 30) then
								DrawText3D({x = o1.x, y =o1.y, z = o1.z +1.0}, "~y~Rescue Target", 1.0)	
							end
						--end				
					
					
					end
					
					
				end	
				for obj in EnumerateObjects() do
					if (DecorGetInt(obj, "mrpproprescue") > 0)  then

						local o1 = GetEntityCoords(obj, true)

						--if(getMissionConfigProperty(MissionName, "DrawText3D"))then
							if  Vdist2(pcoords.x,pcoords.y,pcoords.z,o1.x,o1.y,o1.z) <= 30 then	
								--DrawText3D({x = o1.x, y =o1.y, z = o1.z}, "~o~Objective ($"..getMissionConfigProperty(MissionName, "ObjectRescueReward")..")", 0.6)
								DrawText3D({x = o1.x, y =o1.y, z = o1.z + 1.0}, "~o~Objective", 1.0)								
							end
						--end					
					end

				end
				
	
			end
		
		end	
		

	
    end
end)
]]--

Citizen.CreateThread(function()
    while true do
       
	   Wait(5)
	
		if Active == 1 and MissionName ~="N/A" then
		
			--if not getMissionConfigProperty(MissionName, "DrawText3D") then	
				--995 (+ 5 above) = 1 second 
				--if not drawing text, then 1 second is fine
				--Citizen.Wait(995)
				Citizen.Wait(245)
			--end		
		
			--Update GUI if enabled.
			if showNativeMoneyGUI and not UseESX then 
			
				_,currentplayerNmoney = StatGetInt('MP0_WALLET_BALANCE',-1)
				
			end 
		
		
			if Active == 1 and MissionName ~="N/A" and PedsSpawned == 1 then
				--print("START MISSION CHECK")
				--local start = GetGameTimer()
				--if Active == 1 and MissionName ~="N/A" then	
				if DecorGetInt(GetPlayerPed(-1),"mrpoptout") == 0	then 
					MissionCheck()
					
				elseif MissionTimeOut then 
					--check for MissionTimeOut to allow the mission to end
					isfail = true
					--PLY = PlayerId()
					--PLYN = GetPlayerName(PLY)
					local reasontext = "The mission timed out"
					if Config.Missions[MissionName].IsDefend and not Config.Missions[MissionName].IsDefendTarget then
						reasontext = "The defense held"
						
					elseif Config.Missions[MissionName].IsDefend and Config.Missions[MissionName].IsDefendTarget then
						reasontext = "You failed to protect the target"
					end
					
					
					message = "^1[MISSIONS]: ^1 Mission Timeout"
					message2 = "^1[MISSIONS]: ^2'".. Config.Missions[MissionName].MissionTitle .."'^0 mission has failed!"
				   -- TriggerServerEvent("sv:two", message)
					
					TriggerEvent('chatMessage', message)
					TriggerEvent('chatMessage', message2)				
					
					--TriggerServerEvent("sv:two", message)
					--TriggerServerEvent("sv:two", message2)
					Active = 0
					--TriggerServerEvent("sv:done", MissionName)
					--TriggerEvent("DONE", MissionName)
					aliveCheck()
					local oldmission = MissionName
					--MissionName = "N/A"
					TriggerEvent('ExitOldMissionAndStartNewMission',oldmission,isfail,reasontext) --GHK Start New 					
					
				end 
				--print("MissionCheck()time:"..(GetGameTimer() - start))
				--print("END MISSION CHECK")
				--end		
			end
		
		end	
		

	
    end
end)


--mission timer for client
Citizen.CreateThread(function()
	local starttick = GetGameTimer()
	local lastActiveMissionTime = starttick
	
	while true do
	
		--Citizen.Wait(60000) -- check minute
		Citizen.Wait(1000) 
		local tick = GetGameTimer()
		--MissionTime = -1, turn off timed mission checks
		if Active == 1 and MissionName ~="N/A" then
			
			lastActiveMissionTime = tick
			
			MilliSecondsLeft = MissionEndTime - lastActiveMissionTime			
		
			if tick >  MissionEndTime then 
				--send client event to fail the current mission
				--TriggerClientEvent('DONE', -1, input,false,true,"Mission Timeout") 
				--print('MISSION TIMEOUT')
				--TriggerClientEvent('mt:setmissionTimeout', -1,true)
			else 
				--send minutes left to clients
				local currmissionminutesleft = math.floor((MilliSecondsLeft)/60000) % 60
				local currmissionsecondsleft = math.floor((MilliSecondsLeft)/1000) % 60
				--print ("currmissionMilliSecondsLeft:"..MilliSecondsLeft)
				--print("currmissionminutesleft:"..currmissionminutesleft)
				
			end
			
		
		end 
	
		
		-- if you want days then use this:
		-- local uptimeDay = math.floor((tick-starttick)/86400000)
		-- if you use day then change the hour to this:
		-- local uptimeHour = math.floor((tick-starttick)/3600000) % 24
		--local uptimeHour = math.floor((tick-starttick)/3600000)
		--if you want seconds then use this:
		--local uptimeMinute = math.floor((tick-starttick)/60000) % 60
		--local uptimeSecond = math.floor((tick-starttick)/1000) % 60
		--ExecuteCommand(string.format("sets Uptime \"%02dh %02dm\"", uptimeHour, uptimeMinute))
	end
end)







Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if Active == 1 and MissionName ~="N/A" then
		
			if Config.Missions[MissionName].Type == "Objective" then 
				for k,v in pairs(Config.Missions[MissionName].Marker) do
					if Active == 1 and MissionName ~="N/A" then

						ply = PlayerId()
						coords = GetEntityCoords(GetPlayerPed(ply))
						--workaround for when ground z is not found in random anywhere missions
						if (Config.Missions[MissionName].Marker.Position.z <= 0.0) then 				
							if(GetDistanceBetweenCoords(coords.x,coords.y,0.0, Config.Missions[MissionName].Marker.Position.x, Config.Missions[MissionName].Marker.Position.y, 0.0, true) < Config.Missions[MissionName].Marker.Size.x / 2) and not securing then
								if IsPedOnFoot(GetPlayerPed(ply)) then 
									if DecorGetInt(GetPlayerPed(ply),"mrpoptout") == 0 then
										securing = true
										SecureObj()
									end
								else
									securing = false
								end
								
							end						
						
						else
							if(GetDistanceBetweenCoords(coords.x,coords.y,coords.z, Config.Missions[MissionName].Marker.Position.x, Config.Missions[MissionName].Marker.Position.y, Config.Missions[MissionName].Marker.Position.z, true) < Config.Missions[MissionName].Marker.Size.x / 2) and not securing then
								if IsPedOnFoot(GetPlayerPed(ply)) then 
									if DecorGetInt(GetPlayerPed(ply),"mrpoptout") == 0 then
										securing = true
										SecureObj()
									end
								else
									securing = false
								end
							
							
								
							end
						end
					end
				end
			--elseif Config.Missions[MissionName].Type == "Assassinate" and PedsSpawned == 1 then --assassinate mission
				--MissionCheck()
			end
			--print("MissionName:"..MissionName.." str len: "..tostring(Active == 1 and MissionName ~="N/A"))
			  if Active == 1 and MissionName ~="N/A" then
				if getMissionConfigProperty(MissionName, "UseSafeHouse") and Config.Missions[MissionName].MarkerS then
					for k,v in pairs(Config.Missions[MissionName].MarkerS) do
						if Active == 1 and MissionName ~="N/A" and Config.Missions[MissionName].MarkerS  and ((GetGameTimer() - getMissionConfigProperty(MissionName, "SafeHouseTimeTillNextUse")) > playerSafeHouse) then

							ply = PlayerId()
							coords = GetEntityCoords(GetPlayerPed(ply))
							--workaround for when ground z is not found in random anywhere missions
							if (Config.Missions[MissionName].MarkerS.Position.z <= 0.0) then 				
								if(GetDistanceBetweenCoords(coords.x,coords.y,0.0, Config.Missions[MissionName].MarkerS.Position.x, Config.Missions[MissionName].MarkerS.Position.y, 0.0, true) < Config.Missions[MissionName].MarkerS.Size.x / 2) and not buying then
									if IsPedOnFoot(GetPlayerPed(ply)) then 
										buying = true
										if DecorGetInt(GetPlayerPed(ply),"mrpoptout") == 0 then 
											--print("hey")
											BuyObj()
										end
									else
										buying = false
									end
									
								end						
							
							else
								--hack for small radius missions
								local testradius = Config.Missions[MissionName].MarkerS.Size.x / 2
								if Config.Missions[MissionName].MarkerS.Size.x <= 2.0 then 
									testradius = 1.5
								end
								if(GetDistanceBetweenCoords(coords.x,coords.y,coords.z, Config.Missions[MissionName].MarkerS.Position.x, Config.Missions[MissionName].MarkerS.Position.y, Config.Missions[MissionName].MarkerS.Position.z, true) < testradius) and not buying then
									if IsPedOnFoot(GetPlayerPed(ply)) then 
										buying = true
										--print("BUYING")
										if DecorGetInt(GetPlayerPed(ply),"mrpoptout") == 0 then 
											--print("hey buy")
											BuyObj()
										end
									else
										--print("hey false")
										buying = false
									end
									
								else
								
									if DecorGetInt(GetPlayerPed(-1),"mrpoptout") == 1 then
										--print("hey out")
										buying = false
									end
									
								end
							end
						end
					end			
				end
			end
			
        end
    end
end) 

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

		if showNativeMoneyGUI and not UseESX then
		
			SetTextFont(0)
            SetTextProportional(1)
            SetTextScale(0.0, 0.3)
            SetTextColour(0, 128, 0, 255)
            SetTextDropshadow(0, 0, 0, 0, 255)
            SetTextEdge(1, 0, 0, 0, 255)
            SetTextDropShadow()
            SetTextOutline()
            SetTextEntry("STRING")
            AddTextComponentString("$"..currentplayerNmoney)
            DrawText(0.175, 0.955)		
		

		end		

		
		
	
	--if DPAD LEFT AND LB PRESSED ('E' key and 'SCROLLWHEEL UP' key)
		 if Active == 1 and MissionName ~="N/A" and IsControlPressed(0, 15) and  IsControlPressed(0, 38) then
			
			if Config.Missions[MissionName].IsDefendTarget and GlobalTargetPed and GetVehiclePedIsIn(GlobalTargetPed, false) and 
			DecorGetInt(GetPlayerPed(-1),"mrpoptout") == 0 then
				
				PutPlayerIntoTargetVehicle(GetVehiclePedIsIn(GlobalTargetPed, false),MissionName)
			
			else
				if Config.Missions[MissionName].IsDefendTarget and GlobalTargetPed then 
					Notify("~r~Cannot find the target's vehicle to enter")
					Wait(3500)
				end
			end
		end	

			
		
        if Active == 1 and MissionName ~="N/A" and IsControlPressed(0, 43) and not IsPlayerFreeAiming(PlayerId()) then
			if DecorGetInt(GetPlayerPed(-1),"mrpoptout") == 0 then
			
			HelpMessage("Press ~INPUT_LOOK_BEHIND~ and ~INPUT_PICKUP~ for a quick tutorial on controls and mission help",false,0)
				
				local currmissionminutesleft = string.format("%02d", tostring(math.floor((MilliSecondsLeft)/60000) % 60))
				local currmissionsecondsleft = string.format("%02d", tostring(math.floor((MilliSecondsLeft)/1000) % 60))
			
				if Config.Missions[MissionName].Type == "HostageRescue" and isHostageRescueCount > 0 then
					SetTextFont(0)
					SetTextProportional(1)
					SetTextScale(0.0, 0.3)
					SetTextColour(255, 255, 255, 255)
					SetTextDropshadow(0, 0, 0, 0, 255)
					SetTextEdge(1, 0, 0, 0, 255)
					SetTextDropShadow()
					SetTextOutline()
					SetTextEntry("STRING")
					--if MilliSecondsLeft <= 0 then
						--now what?
						--server will respond to time out the mission
						--AddTextComponentString("~r~Mission Over")
					--else
						AddTextComponentString("Hostages Remaining : ~g~"..isHostageRescueCount)
					--end
					DrawText(0.705, 0.875)
				end 

				if Config.Missions[MissionName].Type == "ObjectiveRescue" and isObjectiveRescueCount > 0 then
					SetTextFont(0)
					SetTextProportional(1)
					SetTextScale(0.0, 0.3)
					SetTextColour(255, 255, 255, 255)
					SetTextDropshadow(0, 0, 0, 0, 255)
					SetTextEdge(1, 0, 0, 0, 255)
					SetTextDropShadow()
					SetTextOutline()
					SetTextEntry("STRING")
					--if MilliSecondsLeft <= 0 then
						--now what?
						--server will respond to time out the mission
						--AddTextComponentString("~r~Mission Over")
					--else
						AddTextComponentString("Objectives Remaining : ~o~"..isObjectiveRescueCount)
					--end
					DrawText(0.705, 0.875)
				end 						
				
				
				if (not MissionNoTimeout) and MilliSecondsLeft >= 0 then
					SetTextFont(0)
					SetTextProportional(1)
					SetTextScale(0.0, 0.3)
					SetTextColour(255, 255, 255, 255)
					SetTextDropshadow(0, 0, 0, 0, 255)
					SetTextEdge(1, 0, 0, 0, 255)
					SetTextDropShadow()
					SetTextOutline()
					SetTextEntry("STRING")
					--if MilliSecondsLeft <= 0 then
						--now what?
						--server will respond to time out the mission
						--AddTextComponentString("~r~Mission Over")
					--else
						AddTextComponentString("Time Left: ~r~"..currmissionminutesleft.."~w~min~r~"..currmissionsecondsleft.."~w~sec")
					--end
					DrawText(0.705, 0.895)
				end 

				if getMissionConfigProperty(MissionName, "UseSafeHouse") or getMissionConfigProperty(MissionName, "UseSafeHouseCrateDrop") then
					SetTextFont(0)
					SetTextProportional(1)
					SetTextScale(0.0, 0.3)
					SetTextColour(255, 255, 255, 255)
					SetTextDropshadow(0, 0, 0, 0, 255)
					SetTextEdge(1, 0, 0, 0, 255)
					SetTextDropShadow()
					SetTextOutline()
					SetTextEntry("STRING")
					local nextTimeOpen = (GetGameTimer() - getMissionConfigProperty(MissionName, "SafeHouseTimeTillNextUse"))
					local nextTimeOpenminutesleft =  string.format("%02d", tostring(math.floor((playerSafeHouse - nextTimeOpen)/60000) % 60))
					local nextTimeOpensecondsleft = string.format("%02d", tostring(math.floor((playerSafeHouse - nextTimeOpen)/1000) % 60))			
					if (nextTimeOpen >= playerSafeHouse) then
						AddTextComponentString("Safehouse: ~g~Open")
					else
						AddTextComponentString("Safehouse: ~b~Closed ~b~("..nextTimeOpenminutesleft.."min"..nextTimeOpensecondsleft.."sec)")
					end
					
						--AddTextComponentString("Safehouse: ~b~Closed ~b~("..((math.floor((playerSafeHouse - nextTimeOpen)/60000) % 60) + 1).." Minute)")
					DrawText(0.815, 0.895) 		
				end 
				
				SetTextFont(0)
				SetTextProportional(1)
				SetTextScale(0.0, 0.3)
				SetTextColour(255, 255, 255, 255)
				SetTextDropshadow(0, 0, 0, 0, 255)
				SetTextEdge(1, 0, 0, 0, 255)
				SetTextDropShadow()
				SetTextOutline()
				SetTextEntry("STRING")
				AddTextComponentString("Mission: ~r~"..Config.Missions[MissionName].MissionTitle)
				DrawText(0.705, 0.915)		
			
				SetTextFont(0)
				SetTextProportional(1)
				SetTextScale(0.0, 0.3)
				SetTextColour(99, 209, 62, 255)
				SetTextDropshadow(0, 0, 0, 0, 255)
				SetTextEdge(1, 0, 0, 0, 255)
				SetTextDropShadow()
				SetTextOutline()
				SetTextEntry("STRING")
				AddTextComponentString(Config.Missions[MissionName].MissionMessage)
				DrawText(0.705, 0.955)	
			else

				if Config.EnableOptIn and Config.EnableOptInHUD then 
			
					SetTextFont(0)
					SetTextProportional(1)
					SetTextScale(0.0, 0.3)
					SetTextColour(255, 255, 255, 255)
					SetTextDropshadow(0, 0, 0, 0, 255)
					SetTextEdge(1, 0, 0, 0, 255)
					SetTextDropShadow()
					SetTextOutline()
					SetTextEntry("STRING")
					AddTextComponentString("Current Mission: ~r~"..Config.Missions[MissionName].MissionTitle)
					DrawText(0.705, 0.895)
					
					--[[
					SetTextFont(0)
					SetTextProportional(1)
					SetTextScale(0.0, 0.3)
					SetTextColour(255, 255, 255, 255)
					SetTextDropshadow(0, 0, 0, 0, 255)
					SetTextEdge(1, 0, 0, 0, 255)
					SetTextDropShadow()
					SetTextOutline()
					SetTextEntry("STRING")
					AddTextComponentString("~b~Press '~o~Q~b~' and '~o~]~b~' or ~o~RB + DPAD UP~b~ to join")
					DrawText(0.705, 0.955)
					]]--
					HelpMessage("Press ~INPUT_SNIPER_ZOOM_IN_SECONDARY~ and ~INPUT_COVER~ to join the mission",false,0)
					
				elseif Config.EnableSafeHouseOptIn and Config.EnableOptInHUD then
					
					SetTextFont(0)
					SetTextProportional(1)
					SetTextScale(0.0, 0.3)
					SetTextColour(255, 255, 255, 255)
					SetTextDropshadow(0, 0, 0, 0, 255)
					SetTextEdge(1, 0, 0, 0, 255)
					SetTextDropShadow()
					SetTextOutline()
					SetTextEntry("STRING")
					AddTextComponentString("Current Active Mission: ~r~"..Config.Missions[MissionName].MissionTitle)
					DrawText(0.705, 0.915)
					--[[
					SetTextFont(0)
					SetTextProportional(1)
					SetTextScale(0.0, 0.3)
					SetTextColour(255, 255, 255, 255)
					SetTextDropshadow(0, 0, 0, 0, 255)
					SetTextEdge(1, 0, 0, 0, 255)
					SetTextDropShadow()
					SetTextOutline()
					SetTextEntry("STRING")
					AddTextComponentString("~b~Go to the mission's safehouse and then press '~o~]~b~' key or ~o~DPAD UP~b~ to join the mission")
					DrawText(0.705, 0.955)
					]]--
					HelpMessage("Go to the mission's safehouse and then press ~INPUT_SNIPER_ZOOM_IN_SECONDARY~ to join the mission",false,0)					
					
					
				end
				
							
			end
		
            for k,v in pairs(Config.Missions[MissionName].Marker) do
                if Active == 1 and MissionName ~="N/A" then
                    ply = PlayerId()
                    coords = GetEntityCoords(GetPlayerPed(ply))
					--***workaround for when ground z is not found in random anywhere missions
					if (Config.Missions[MissionName].Marker.Position.z <= 0.0) then 
						if(GetDistanceBetweenCoords(coords.x,coords.y,0.0, Config.Missions[MissionName].Marker.Position.x, Config.Missions[MissionName].Marker.Position.y, 0.0, true) > Config.Missions[MissionName].Marker.Size.x / 2)  then
							securing = false
						end					
					
					else 
						if(GetDistanceBetweenCoords(coords.x,coords.y,coords.z, Config.Missions[MissionName].Marker.Position.x, Config.Missions[MissionName].Marker.Position.y, Config.Missions[MissionName].Marker.Position.z, true) > Config.Missions[MissionName].Marker.Size.x / 2)  then
							securing = false
						end
					end
					
					
                end
            end
			
			
			
			
			if getMissionConfigProperty(MissionName, "UseSafeHouse") and Config.Missions[MissionName].MarkerS then			
				for k,v in pairs(Config.Missions[MissionName].MarkerS) do 
					if Active == 1 and MissionName ~="N/A" and Config.Missions[MissionName].MarkerS and ((GetGameTimer() - getMissionConfigProperty(MissionName, "SafeHouseTimeTillNextUse")) > playerSafeHouse) then
						ply = PlayerId()
						coords = GetEntityCoords(GetPlayerPed(ply))
						--***workaround for when ground z is not found in random anywhere missions
						if (Config.Missions[MissionName].MarkerS.Position.z <= 0.0) then 
							if(GetDistanceBetweenCoords(coords.x,coords.y,0.0, Config.Missions[MissionName].MarkerS.Position.x, Config.Missions[MissionName].MarkerS.Position.y, 0.0, true) > Config.Missions[MissionName].MarkerS.Size.x / 2)  then
								buying = false
							end					
						
						else 
							if(GetDistanceBetweenCoords(coords.x,coords.y,coords.z, Config.Missions[MissionName].MarkerS.Position.x, Config.Missions[MissionName].MarkerS.Position.y, Config.Missions[MissionName].MarkerS.Position.z, true) > Config.Missions[MissionName].MarkerS.Size.x / 2)  then
								buying = false
							end
						end
						
						
					end
				end			
			end
			
			
        end
    end
end)


--Make Hostage Friendlies cower

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10000)
		
        if Active == 1 and MissionName ~="N/A" then
		
	
			for ped in EnumeratePeds() do
				
				
				if DecorGetInt(ped, "mrppedfriend") > 0 and not getMissionConfigProperty(MissionName, "IsDefend")  then
				
					if not GetIsTaskActive(ped, 222) then
						
						ClearPedTasks(ped)
						TaskCower(ped,360000)
		
					end
				end
			end
		end
	end 
end)



--TaskFollowToOffsetOfEntity(passenger, player, -1.0, -1.5, 0, 2, -1, 0, 1) --last arg is persist
--TaskSmartFleeCoord(ped, x, y, z, distance, time, p6, p7) --218 --cower : 222
--TaskSeekCoverFromPos(ped, x, y, z, duration, p5)
--359 - CTaskStayInCover, 309 - CTaskInCover
--

Citizen.CreateThread(function()
    while true do
        
		
		Citizen.Wait(1000) --10000
		
		for ped in EnumeratePeds() do
			if not((DecorGetInt(ped, "mrppedid") > 0 or DecorGetInt(ped, "mrpvpedid") > 0)) 
			and Config.HostileAmbientPeds and Config.HostileAmbientPeds > 0
			and Active == 1 and MissionName ~="N/A"  
			
			then
			
				--print("do hostile zone")
				doHostileZone(ped)
			end
		end
		
        if Active == 1 and MissionName ~="N/A" and getMissionConfigProperty(MissionName, "IsDefendTargetCheckLoop") then
		
			
			for ped in EnumeratePeds() do
				
				--[[
				if DecorGetInt(ped, "mrppedfriend") > 0 and not getMissionConfigProperty(MissionName, "IsDefend")  then
				
					if not GetIsTaskActive(ped, 222) then
						
						ClearPedTasks(ped)
						TaskCower(ped,360000)
		
					end
				end
				
				]]--			
				--used for this case to make sure they follow the target when the player ped gets close. 
				if(Config.Missions[MissionName].IsDefend and Config.Missions[MissionName].IsDefendTarget and DecorGetInt(ped, "mrppeddefendtarget") > 0 and not (IsEntityDead(ped) == 1)) then
					
					if Config.Missions[MissionName].IsDefendTargetChase or Config.Missions[MissionName].IsVehicleDefendTargetChase then
						for otherped in EnumeratePeds() do
						
							if GetRelationshipBetweenPeds(otherped, ped) == 5 and DecorGetInt(otherped, "mrppedid") > 0 and not (IsEntityDead(otherped) == 1)  then
									if IsPedOnFoot(otherped) and Config.Missions[MissionName].IsDefendTargetChase then 
										local otherpc  = GetEntityCoords(otherped)
										local pc  = GetEntityCoords(ped)
										
										if GetDistanceBetweenCoords(otherpc.x,otherpc.y,otherpc.z,pc.x,pc.y,pc.z,true) <= getMissionConfigProperty(MissionName,"IsDefendTargetAttackDistance") then 
											SetBlockingOfNonTemporaryEvents(otherped,false)
											--[[
											if not GetIsTaskActive(otherped,44) then
												ClearPedTasks(otherped)
												--TaskSetBlockingOfNonTemporaryEvents(otherped,false)
												TaskSetBlockingOfNonTemporaryEvents(otherped,false)
												--print("made it:"..DecorGetInt(otherped, "mrppedid"))
											end
											]]--
											--print("made it:"..DecorGetInt(otherped, "mrppedid"))
											--ClearPedTasks(otherped)
											--RegisterTarget(ped)
											--RegisterTarget(GetPlayerPed(-1))
											--TaskCombatHatedTargetsAroundPed(otherped,getMissionConfigProperty(MissionName,"IsDefendTargetAttackDistance"))
											--TaskCombatPed(otherped,ped,0, 16)
											
											--print(getMissionConfigProperty(MissionName,"MissionLengthMinutes")*60000-(MilliSecondsLeft))
										else
											--ClearPedTasks(otherped)
											
											if not GetIsTaskActive(otherped,307) then
												ClearPedTasks(otherped)
												--ClearPedTasksImmediately(otherped)
												--TaskGoToEntity(otherped, ped, -1, 5.0, 20.0,1073741824, 0)
												--TaskGotoEntityOffsetXy(otherped, ped, -1,0.0,0.0,0.0,1,0)
												--TaskCombatPed(otherped, ped)
												RegisterTarget(otherped,ped)
												TaskCombatHatedTargetsInArea(otherped,otherpc.x,otherpc.y,otherpc.z,300.0,0)
												--print("second made it:"..DecorGetInt(otherped, "mrppedid"))
											end
											
											--print("movetoentity..is goto task active:"..
											--tostring(GetIsTaskActive(otherped,307) or GetIsTaskActive(otherped,308) or GetIsTaskActive(otherped,239) or GetIsTaskActive(otherped,246) or GetIsTaskActive(otherped,253) or GetIsTaskActive(otherped,509)))
										end
									else
									
										if(not IsPedOnFoot(otherped)) and Config.Missions[MissionName].IsVehicleDefendTargetChase then 
											--WORKS FOR AIRCRAFT?:
											--print("FOLLOW PED IN VEHICLE")
											--> GetPedInVehicleSeat(PedVeh,-1)) <--USE THIS FOR PED IN VEHICLE?
											
											local otherpc  = GetEntityCoords(otherped)
											local pc  = GetEntityCoords(ped)											
											
											if GetDistanceBetweenCoords(otherpc.x,otherpc.y,otherpc.z,pc.x,pc.y,pc.z,true) <= getMissionConfigProperty(MissionName,"IsDefendTargetVehicleAttackDistance") then 
												--SetBlockingOfNonTemporaryEvents(otherped,false)
												
												TaskCombatPed(otherped,ped,0, 16)
											else																
												--TaskVehicleEscort(otherped, GetVehiclePedIsIn(otherped, false), GetVehiclePedIsIn(ped, false), 0,1200.0, 0, 5.0, -1, 2000)
											end
										end						
									end
							end
							
						end
						
					--[[ --DEPRECATED:	
					elseif Config.Missions[MissionName].IsDefendTargetGotoBlip or Config.Missions[MissionName].IsVehicleDefendTargetGotoBlip then --only needed for peds, not vehicles who use longrange drive to 
						if IsPedOnFoot(ped) and Config.Missions[MissionName].IsDefendTargetGotoBlip then
							
							local otherpc  = GetEntityCoords(otherped)
							local pc  = GetEntityCoords(ped)
										
							if GetDistanceBetweenCoords(otherpc.x,otherpc.y,otherpc.z,pc.x,pc.y,pc.z,true) <= getMissionConfigProperty(MissionName,"IsDefendTargetAttackDistance") then 
								SetBlockingOfNonTemporaryEvents(otherped,false)
								TaskCombatPed(otherped,ped,0, 16)
							else							
								TaskGoStraightToCoord(ped,Config.Missions[MissionName].Blip.Position.x, Config.Missions[MissionName].Blip.Position.y,Config.Missions[MissionName].Blip.Position.z, 20.0, 100000, 0.0, 0.0) 
							end
							
						elseif not IsPedOnFoot(ped) and Config.Missions[MissionName].IsVehicleDefendTargetGotoBlip then
							
							local otherpc  = GetEntityCoords(otherped)
							local pc  = GetEntityCoords(ped)
										
							if GetDistanceBetweenCoords(otherpc.x,otherpc.y,otherpc.z,pc.x,pc.y,pc.z,true) <= getMissionConfigProperty(MissionName,"IsDefendTargetVehicleAttackDistance") then 
								SetBlockingOfNonTemporaryEvents(otherped,false)
								TaskCombatPed(otherped,ped,0, 16)
							end														
							
							
							
						end 
						for otherped in EnumeratePeds() do
						
							if GetRelationshipBetweenPeds(otherped, ped) == 5 and DecorGetInt(otherped, "mrppedid") > 0 and not (IsEntityDead(otherped) == 1) then
							
									if IsPedOnFoot(otherped) then 
										local otherpc  = GetEntityCoords(otherped)
										local pc  = GetEntityCoords(ped)
													
										if GetDistanceBetweenCoords(otherpc.x,otherpc.y,otherpc.z,pc.x,pc.y,pc.z,true) <= getMissionConfigProperty(MissionName,"IsDefendTargetAttackDistance") then 
											SetBlockingOfNonTemporaryEvents(otherped,false)
											TaskCombatPed(otherped,ped,0, 16)
										else																
																			
											TaskGoStraightToCoord(otherped,Config.Missions[MissionName].Blip.Position.x, Config.Missions[MissionName].Blip.Position.y,Config.Missions[MissionName].Blip.Position.z, 20.0, 100000, 0.0, 0.0) 
										end
									--else
										--if(not IsPedOnFoot(ped)) then 
											--print("FOLLOW PED IN VEHICLE")
											--> GetPedInVehicleSeat(PedVeh,-1)) <--USE THIS FOR PED IN VEHICLE?
												--TaskVehicleEscort(otherped, GetVehiclePedIsIn(otherped, false), GetVehiclePedIsIn(ped, false), 0,1200.0, 0, 5.0, -1, 2000)
											
										--end						
									end
							end
							
						end					
					
					]]--
					end
				
				
				end
				
				--if DecorGetInt(ped, "mrppeddefendtarget") > 0 and IsPedOnFoot(ped)  then
					--print('TASK STAND STILL')
					--if not GetIsTaskActive(ped, 17) then
						
						--ClearPedTasks(ped)
						--TaskStandStill(ped,360000)
		
					--end
				--end
				
				
				
				--if DecorGetInt(ped, "mrppedconqueror") > 0 and getMissionConfigProperty(MissionName, "IsDefend")  then

					--ClearPedTasks(ped)
					--TaskGoStraightToCoord(ped,Config.Missions[MissionName].Marker.Position.x, Config.Missions[MissionName].Marker.Position.y,Config.Missions[MissionName].Marker.Position.z,1200.0 , 100000, 0.0, 0.0) --movespeed = 1200.0
					--SetPedKeepTask(ped,true) 
					
				--end				
				
				
				
			end
						
							
        end
    end
end)



Citizen.CreateThread(function()
	local player = GetPlayerPed(-1)
	local healthtimer = 0
	local armourtimer = 0
	local lastarmour = 0
	local lasthealth = 0
	local lasthealthcheck = 0
	local RegenHealthAndArmour = Config.RegenHealthAndArmour
	local IsCrackDownMode = Config.SafeHouseCrackDownMode
	local CrackDownModeHealthAmount = Config.SafeHouseCrackDownModeHealthAmount
	
	local UpgradeMultiplier = 1
	local multiplier = 1
	
	if IsCrackDownMode then
		UpgradeMultiplier= math.floor(CrackDownModeHealthAmount/200) --default health is 200
	else 
		UpgradeMultiplier = 1 --default health is 200
	end
	
	
    while true do
		
		lasthealthcheck = GetEntityHealth(player)
       
		Citizen.Wait(150)
		player = GetPlayerPed(-1)
		-- if Active == 1 and MissionName ~="N/A" then
			if playerUpgraded and IsCrackDownMode then 
				 multiplier = UpgradeMultiplier
			else 
				 multiplier = 1
			end
			
			--print("multiplier:"..multiplier)
			--print(string.format("%02d", tostring(math.floor((GetGameTimer())/1000) % 60)))
			--print("regen"..tostring(player))
			
			--print("statement:"..tostring(RegenHealthAndArmour and player and not IsEntityDead(player)))
			
			if RegenHealthAndArmour and player and not IsEntityDead(player) and DecorGetInt(GetPlayerPed(-1),"mrpoptout") == 0 then
			
				--print("timer")
				if GetPedArmour(player) < GetPlayerMaxArmour(player) then
						healthtimer = 0
						--print("armour timer")
						if lastarmour == GetPedArmour(player) then
							if lasthealth == GetEntityHealth(player) then
								armourtimer = armourtimer +3
								if armourtimer > 99 then						--Initial delay before armour starts to regenerate
														
									AddArmourToPed(player, 5*multiplier)			--Armour regen amount. Must be an integer(+1,+2,+3 etc.)
									lastarmour =  GetPedArmour(player)
									armourtimer = 50							--Armour regen rate. 1200 = instant
								end
								else
								lasthealth = GetEntityHealth(player)
								armourtimer = 0
							end
							else
							lastarmour = GetPedArmour(player)
							armourtimer = 0
						end
				else
					
						armourtimer = 0
						if GetEntityHealth(player) < GetEntityMaxHealth(player) then
							
							--reset timer if injured since last check or busy
							if ((GetEntityHealth(player) < lasthealthcheck)  or IsPedShooting(player) or IsPedInMeleeCombat(player) or
						IsPedRagdoll(player) or IsPedSwimmingUnderWater(player) or IsEntityOnFire(player) or
						IsEntityInAir(player) or IsPedRunning(player) or IsPedSprinting(player)) then
								healthtimer =  0
									
							else
								healthtimer = healthtimer + 5 --+10
								
							end
							if healthtimer > 99 then							--Health regen rate
										
								SetEntityHealth(player, GetEntityHealth(player)+5*multiplier)	--Health regen amount. Must be an integer
								healthtimer = 50 --0
							end
						else
							ClearPedBloodDamage(player)
							healthtimer = 0
						end
				end		
			
			end
		--end

    end
end) 



--Cleanup mission pickups

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
		
	--	print("ARMOR"..GetPedArmour(GetPlayerPed(-1)))
		--print("MAXARMOR"..GetPlayerMaxArmour(GetPlayerPed(-1)))
		--print("HEALTH"..GetEntityHealth(GetPlayerPed(-1)))
			--print("MAXHEALTH"..GetEntityMaxHealth(GetPlayerPed(-1)))
		--print("GET_RELATIONSHIP_BETWEEN_GROUPS:"..GetRelationshipBetweenGroups(GetHashKey("TRUENEUTRAL"),GetHashKey("HATES_PLAYER")))
		--SetRelationshipBetweenGroups(0, GetHashKey("TRUENEUTRAL"), GetHashKey("HATES_PLAYER"))	
	   if Active == 1 and MissionName ~="N/A" then
				--print("blip position:"..Config.Missions[input].Blip.Position.x..", "..Config.Missions[input].Blip.Position.y..", "..Config.Missions[input].Blip.Position.z)
					
					if(Config.Missions[MissionName].MissionPickups) then 	
						
							 for i=1, #Config.Missions[MissionName].MissionPickups do     
								
								--RemoveCollectedPickup(Config.Missions[MissionName].MissionPickups[i].Position.x,Config.Missions[MissionName].MissionPickups[i].Position.y,Config.Missions[MissionName].MissionPickups[i].Position.z)	

								if (DoesPickupExist(Config.Missions[MissionName].MissionPickups[i].id)) then
									if (HasPickupBeenCollected(Config.Missions[MissionName].MissionPickups[i].id)) then
										SetEntityCoords(Config.Missions[MissionName].MissionPickups[i].id, -10000.647, -10000.97, 0.7186, 0.968)
										SetEntityAsNoLongerNeeded(Config.Missions[MissionName].MissionPickups[i].id)
										RemovePickup(Config.Missions[MissionName].MissionPickups[i].id)
										DeleteObject(Config.Missions[MissionName].MissionPickups[i].id)				
						
									end							
					
								
								end
			
							end
					end
					
        end
    end
end)

--safehouse crackdown mode
Citizen.CreateThread(function()
    while true do
		Citizen.Wait(0)
		if playerUpgraded then
			SetSuperJumpThisFrame(PlayerId())
		end 
    end
end)


--remove wanted level
Citizen.CreateThread(function()

   for i = 1, 32 do
        Citizen.InvokeNative(0xDC0F817884CDD856, i, false)
    end
    while true do
        Citizen.Wait(0)
        if GetPlayerWantedLevel(PlayerId()) ~= 0 then
            ClearPlayerWantedLevel(PlayerId())
        end
    end
	
end)

--remove vehicles at military base safe house
Citizen.CreateThread(function()
    local player = PlayerPedId()

    while true do
        RemovePeskyVehicles({x = -2108.16, y = 3275.45, z = 38.73}, 5000.0)
        Citizen.Wait(1)
	end
end)

function RemovePeskyVehicles(player, range)
    local pos = GetEntityCoords(playerPed) 

    RemoveVehiclesFromGeneratorsInArea(
        pos.x - range, pos.y - range, pos.z - range, 
        pos.x + range, pos.y + range, pos.z + range
    );
end

--testing
function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end


function TeleportIntoInterior(locationdata, ent)
	local x,y,z,h = table.unpack(locationdata)
	DoScreenFadeOut(1000)
	while IsScreenFadingOut() do Citizen.Wait(0) end
	NetworkFadeOutEntity(GetPlayerPed(-1), true, false)
	Wait(1000)
	SetEntityCoords(GetPlayerPed(-1), x, y, z)
	--SetEntityHeading(GetPlayerPed(-1), h)
	NetworkFadeInEntity(GetPlayerPed(-1), 0)
	Wait(1000)
	FreezeEntityPosition(PlayerPedId(), false)
	SetGameplayCamRelativeHeading(0.0)
	DoScreenFadeIn(1000)
	while IsScreenFadingIn() do Citizen.Wait(0)	end
end

function doTeleportToSafeHouse(isOnSpawn)
	--if currently teleporting..

	if (isOnSpawn and DoingMissionTeleport) then --or DecorGetInt(GetPlayerPed(-1),"mrpoptout") == 1 then 
		return
	end

	if MissionName ~="N/A" and Active == 1 then
		if getMissionConfigProperty(MissionName, "UseSafeHouse") and getMissionConfigProperty(MissionName, "TeleportToSafeHouseOnSpawn") and Config.Missions[MissionName].MarkerS then
			local locationdata = {x=0.0,y=0.0,z=0.0}
			
			local cInitial = GetEntityCoords(GetPlayerPed(-1))
			local watertest = GetWaterHeight(cInitial.x,cInitial.y,cInitial.z)
			--local leaveWaterVehicle = false 
			--if (watertest  == 1 or watertest  == true) and not IsPedOnFoot(GetPlayerPed(-1))  then 
			
			
			local rndx =math.random(-1,1)
			local rndy =math.random(-1,1) 			
			if rndx ==0 then
				rndx = 1
			end
			if rndy ==0 then
				rndy = 1
			end	
			
			local EntityToTeleport = GetPlayerPed(-1)
			local onFoot = true
			if not getMissionConfigProperty(MissionName, "TeleportToSafeHouseOnMissionStartNoVehicle") and  (not IsPedOnFoot(GetPlayerPed(-1))) and (not IsThisModelABoat(GetEntityModel(GetVehiclePedIsIn(PlayerPedId(), false)))) then --and IsEntityInWater(boat)) then 
				EntityToTeleport = GetVehiclePedIsIn(PlayerPedId(), false)
				onFoot = false
			end
			
			local origx
			local origy 
			
			--lets not accidently teleport boats onto land
			if onFoot then
				rndx = (rndx*Config.Missions[MissionName].MarkerS.Size.x)/2  
				rndy = (rndy*Config.Missions[MissionName].MarkerS.Size.y)/2
				
				
				origx = Config.Missions[MissionName].MarkerS.Position.x
				origy = Config.Missions[MissionName].MarkerS.Position.y
				
				locationdata.x = Config.Missions[MissionName].MarkerS.Position.x --+ rndx
				locationdata.y = Config.Missions[MissionName].MarkerS.Position.y --+ rndy
				locationdata.z = Config.Missions[MissionName].MarkerS.Position.z
				
				local rHeading = math.random(0, 360) + 0.0
				local theta = (rHeading / 180.0) * 3.14		
				locationdata = vector3(locationdata.x, locationdata.y, locationdata.z) - vector3(math.cos(theta) *  math.floor(Config.Missions[MissionName].MarkerS.Size.x/2 + 1.0), math.sin(theta) * math.floor(Config.Missions[MissionName].MarkerS.Size.x/2 + 1.0), 0.0)
				
				local coords = GetEntityCoords(EntityToTeleport)
				if GetDistanceBetweenCoords(coords.x,coords.y,coords.z, locationdata.x,locationdata.y,locationdata.z, true) < getMissionConfigProperty(MissionName, "TeleportToSafeHouseMinDistance") then--print
					-- no point teleporting when so close
				
					return
					
				end				
				
				
			else
				--if in vehicle then teleport to the SL
				--diameter is 100m
				rndx = rndx*((100/2) + math.random(1,30)) 
				rndy = rndy*((100/2) + math.random(1,30))
				
				
				origx = Config.Missions[MissionName].BlipSL.Position.x
				origy = Config.Missions[MissionName].BlipSL.Position.y
				
				locationdata.x = Config.Missions[MissionName].BlipSL.Position.x + rndx
				locationdata.y = Config.Missions[MissionName].BlipSL.Position.y + rndy
				locationdata.z = Config.Missions[MissionName].BlipSL.Position.z		

				local coords = GetEntityCoords(EntityToTeleport)
				if GetDistanceBetweenCoords(coords.x,coords.y,coords.z, locationdata.x,locationdata.y,locationdata.z, true) < getMissionConfigProperty(MissionName, "TeleportToSafeHouseMinVehicleDistance") then--print
					-- no point teleporting when so close
					return
					
				end
				
				local model = GetEntityModel(EntityToTeleport) 
				if(IsThisModelAHeli(model) or IsThisModelAPlane(model)) then 
					SetVehicleLandingGear(EntityToTeleport, 0)
				end
			
			end
			--print('teleportto x'..locationdata.x ..' y:'..locationdata.y ..' z:'..locationdata.z )
			
	
			
			
			FreezeEntityPosition(EntityToTeleport, true)
			DoScreenFadeOut(1000)
			while IsScreenFadingOut() do Citizen.Wait(0) end
			NetworkFadeOutEntity(GetPlayerPed(-1), true, false)
			--TriggerEvent("chatMessage", "^1[MISSIONS]: ^0Travelling to the mission safehouse...")
			--TriggerEvent("mt:missiontext2","Travelling to the mission safehouse...", 3000)
			Wait(1000)
			--print("spawning at"..locationdata.x)
			SetEntityCoords(EntityToTeleport,locationdata.x, locationdata.y,locationdata.z)
			--SetEntityHeading(GetPlayerPed(-1), h)
			NetworkFadeInEntity(GetPlayerPed(-1), 0)
			Wait(1000)
			FreezeEntityPosition(EntityToTeleport, false)
			
			
			--for obj in EnumerateObjects() do
				--if DecorGetInt(obj, "mrpsafehousepropid") > 0 then
					local p1 = GetEntityCoords(GetPlayerPed(-1), true)
					--local p2 = GetEntityCoords(obj, true)
					
					
					--local dx = p2.x - p1.x
					--local dy = p2.y - p1.y
					
					local dx = origx - p1.x
					local dy = origy - p1.y
					
					local heading = GetHeadingFromVector_2d(dx, dy)				 
					SetEntityHeading(EntityToTeleport,heading) 
					SetGameplayCamRelativeHeading(0.0) 
					--break
				--end
			--end					
			
			--SetGameplayCamRelativeHeading(0.0)
			DoScreenFadeIn(1000)
			while IsScreenFadingIn() do Citizen.Wait(0)	end
		
			TriggerEvent("chatMessage", "^1[MISSIONS]: ^0Traveled to the mission safehouse...")
			TriggerEvent("mt:missiontext2","Traveled to the mission safehouse...", 4000)
			
			
		
			

			--local zGround = checkAndGetGroundZ(locationdata.x,locationdata.y,locationdata.z,true)
			--if zGround = 0.0 then 
				-- zGround = locationdata.z
			--end
			--SetEntityCoords(GetPlayerPed(-1),locationdata.x, locationdata.y,locationdata.z)
			--TriggerEvent("mt:missiontext2","Taken to the mission safehouse", 250)
			--makeEntityFaceEntity( entity1, entity2 )
		end
	end


end

--does a toggle on/off everytime it is called
RegisterNetEvent("doMissionDrop")
AddEventHandler("doMissionDrop",function()
	
	
	if (IsEntityDead(GetPlayerPed(-1)) or DoingMissionTeleport) 
	or not (MissionName ~="N/A" and Active == 1)
	
	then --or DecorGetInt(GetPlayerPed(-1),"mrpoptout") == 1 then 
		return
	end
	PlaySoundFrontend(-1, "Apt_Style_Purchase", "DLC_APT_Apartment_SoundSet", 0)
	if not MissionDropBlip then 
		
		local pcoords = GetEntityCoords(GetPlayerPed(-1))
		MissionDropHeading = GetEntityHeading(GetPlayerPed(-1))
		MissionDropBlipCoords.x=pcoords.x
		MissionDropBlipCoords.y=pcoords.y
		MissionDropBlipCoords.z=pcoords.z+1
		MissionDropBlip = AddBlipForCoord(pcoords.x, pcoords.y, pcoords.z)
		
		SetBlipSprite (MissionDropBlip, 94)
		SetBlipDisplay(MissionDropBlip, 4)
		SetBlipScale  (MissionDropBlip, 1.2)
		SetBlipColour (MissionDropBlip, 3)
		SetBlipAsShortRange(MissionDropBlip, false)	

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Mission Reinforcement Drop ($-"..getMissionConfigProperty(MissionName, "UseMissionDropFee")..")")
		EndTextCommandSetBlipName(MissionDropBlip)
		MissionDropDid=true
		
		TriggerEvent("mt:missiontext2","Mission Reinforcement Drop created", 4000)
		
		HelpMessage("Mission Reinforcement Drop created. Press~INPUT_DUCK~ and ~INPUT_COVER~ to remove",false,5000)
		Wait(5000)
		HelpMessage("To fast travel here after respawn, Press ~INPUT_LOOK_BEHIND~ and ~INPUT_COVER~. Cost: $"..getMissionConfigProperty(MissionName, "UseMissionDropFee"),false,5000)
		--print("MissionDropDid")
	else 
		
		RemoveBlip(MissionDropBlip)
		MissionDropBlip=nil
		MissionDropBlipCoords={x=-50000,y=-50000,z=-50000}
		HelpMessage("Mission Reinforcement Drop Removed. Press~INPUT_DUCK~ and ~INPUT_COVER~ to add another",false,5000)
		
		TriggerEvent("mt:missiontext2","Mission Reinforcement Drop removed", 4000)
		
	
	end

end)

RegisterNetEvent("doMissionDropTeleport")
AddEventHandler("doMissionDropTeleport",function()
	--if currently teleporting..
	
	
	if (IsEntityDead(GetPlayerPed(-1)) or DoingMissionTeleport) 
	or not (MissionName ~="N/A" and Active == 1)
	
	then --or DecorGetInt(GetPlayerPed(-1),"mrpoptout") == 1 then 
		return
	end
	
	

	if MissionName ~="N/A" and Active == 1 then
	
		if not MissionDropBlip then 
			TriggerEvent("mt:missiontext2","No Mission Reinforcement Drop set", 4000)
			HelpMessage("Press~INPUT_DUCK~ and ~INPUT_COVER~ to create a Mission Reinforcement Drop at your location",true,5000)
			return
		end
		--print(MissionDropDid)
		if MissionDropDid then 
			TriggerEvent("mt:missiontext2","Mission Reinforcement Drop only available after you respawn", 4000)
			HelpMessage("Press~INPUT_DUCK~ and ~INPUT_COVER~ to remove the Mission Reinforcement Drop",false,5000)
			return
		end
	
	
		if getMissionConfigProperty(MissionName, "UseMissionDrop")  and MissionDropBlip then
		
			local locationdata = {x=0.0,y=0.0,z=0.0}
			
			--local cInitial = GetEntityCoords(GetPlayerPed(-1))
			--local watertest = GetWaterHeight(cInitial.x,cInitial.y,cInitial.z)
			--local leaveWaterVehicle = false 
			--if (watertest  == 1 or watertest  == true) and not IsPedOnFoot(GetPlayerPed(-1))  then 
			
		
			
			
			local EntityToTeleport = GetPlayerPed(-1)
			local onFoot = true
			if (not IsPedOnFoot(GetPlayerPed(-1))) and not getMissionConfigProperty(MissionName, "UseMissionDropNoVehicle")  then --and IsEntityInWater(boat)) then 
				EntityToTeleport = GetVehiclePedIsIn(PlayerPedId(), false)
				onFoot = false
			end
			
			--local origx
			--local origy 
			
			--lets not accidently teleport boats onto land
			if onFoot then
				
				locationdata.x = MissionDropBlipCoords.x --+ rndx
				locationdata.y = MissionDropBlipCoords.y --+ rndy
				locationdata.z = MissionDropBlipCoords.z
				
			
				--local rHeading = math.random(0, 360) + 0.0
				--local theta = (rHeading / 180.0) * 3.14		
				--locationdata = vector3(locationdata.x, locationdata.y, locationdata.z) - vector3(math.cos(theta) *  math.floor(Config.Missions[MissionName].MarkerS.Size.x/2 + 1.0), math.sin(theta) * math.floor(Config.Missions[MissionName].MarkerS.Size.x/2 + 1.0), 0.0)
				
				
				local coords = GetEntityCoords(EntityToTeleport)
				if GetDistanceBetweenCoords(coords.x,coords.y,coords.z, locationdata.x,locationdata.y,locationdata.z, true) < 5 then--print
					-- no point teleporting when so close
				
					return
					
				end				
			
				
			else
			
				locationdata.x = MissionDropBlipCoords.x --+ rndx
				locationdata.y = MissionDropBlipCoords.y --+ rndy
				locationdata.z = MissionDropBlipCoords.z

				local coords = GetEntityCoords(EntityToTeleport)
				
				
				
				if GetDistanceBetweenCoords(coords.x,coords.y,coords.z, locationdata.x,locationdata.y,locationdata.z, true) < 5 then--print
					-- no point teleporting when so close
					return
					
				end 
				
				local model = GetEntityModel(EntityToTeleport) 
				if(IsThisModelAHeli(model) or IsThisModelAPlane(model)) then 
					SetVehicleLandingGear(EntityToTeleport, 0)
				end
			
			end
			--print('teleportto x'..locationdata.x ..' y:'..locationdata.y ..' z:'..locationdata.z )
			
			TriggerEvent("mt:missiontext2","Traveling to Mission Reinforcement Drop...", 4000)
			MissionDropDid=true
			

			
			

			if getMissionConfigProperty(MissionName, "UseMissionDropFee") > 0 then

					local currentmoney = 0
					local rejuvcost = getMissionConfigProperty(MissionName, "UseMissionDropFee")
					local totalmoney = 0		
					
					local _,currentmoney = StatGetInt('MP0_WALLET_BALANCE',-1)
					playerMissionMoney =  0 - rejuvcost
					totalmoney =  currentmoney - rejuvcost		
						
					if UseESX then 
						TriggerServerEvent("paytheplayer", totalmoney)
						TriggerServerEvent("UpdateUserMoney", totalmoney)
					else
							--DecorSetInt(GetPlayerPed(-1),"mrpplayermoney",totalmoney)
						DecorSetInt(GetPlayerPed(-1),"mrpplayermoney",DecorGetInt(GetPlayerPed(-1),"mrpplayermoney") + playerMissionMoney)			
						mrpplayermoneyG = DecorGetInt(GetPlayerPed(-1),"mrpplayermoney")			
						StatSetInt('MP0_WALLET_BALANCE',totalmoney, true)
					end	

					Notify("~h~~b~Mission Reinforcement Drop Fee: ~g~$"..getMissionConfigProperty(MissionName, "UseMissionDropFee"))
					
			end
			
			
			FreezeEntityPosition(EntityToTeleport, true)
			DoScreenFadeOut(1000)
			while IsScreenFadingOut() do Citizen.Wait(0) end
			NetworkFadeOutEntity(GetPlayerPed(-1), true, false)
			--TriggerEvent("chatMessage", "^1[MISSIONS]: ^0Travelling to the mission safehouse...")
			--TriggerEvent("mt:missiontext2","Travelling to the mission safehouse...", 3000)
			Wait(1000)
			--print("spawning at"..locationdata.x)
			SetEntityCoords(EntityToTeleport,locationdata.x, locationdata.y,locationdata.z)
			--SetEntityHeading(GetPlayerPed(-1), h)
			NetworkFadeInEntity(GetPlayerPed(-1), 0)
			Wait(1000)
			FreezeEntityPosition(EntityToTeleport, false)
			
			
			--for obj in EnumerateObjects() do
				--if DecorGetInt(obj, "mrpsafehousepropid") > 0 then
					local p1 = GetEntityCoords(GetPlayerPed(-1), true)
					--local p2 = GetEntityCoords(obj, true)
					
					
					--local dx = p2.x - p1.x
					--local dy = p2.y - p1.y
					
					--local dx = origx - p1.x
					--local dy = origy - p1.y
					
					--local heading = GetHeadingFromVector_2d(dx, dy)				 
					SetEntityHeading(EntityToTeleport,MissionDropHeading) 
					SetGameplayCamRelativeHeading(0.0) 
					--break
				--end
			--end					
			
			--SetGameplayCamRelativeHeading(0.0)
			PlaySoundFrontend(-1, "CHECKPOINT_AHEAD", "HUD_MINI_GAME_SOUNDSET", 0)
			DoScreenFadeIn(1000)
			while IsScreenFadingIn() do Citizen.Wait(0)	end
		
			--TriggerEvent("chatMessage", "^1[MISSIONS]: ^0Traveled to your mission respawn location...")
			TriggerEvent("mt:missiontext2","Traveled to Mission Reinforcement Drop...", 4000)
			
			
			--SPAWN DROP Aircraft
		--[[	
		local aircraftmodel = getMissionConfigProperty(MissionName, "UseMissionDropAircraft")[math.random(1, #getMissionConfigProperty(MissionName, "UseMissionDropAircraft"))]
		local planeSpawnDistance = 50.0
           RequestModel(GetHashKey(aircraftmodel))
		  
           while not HasModelLoaded(GetHashKey(aircraftmodel)) do
              Wait(0)
           end
		   
        local rHeading = math.random(0, 360) + 0.0
		
		local spawnx = MissionDropBlipCoords.x
		local spawny = MissionDropBlipCoords.y
		local spawnz = MissionDropBlipCoords.z
			


        local planeSpawnDistance = (planeSpawnDistance and tonumber(planeSpawnDistance) + 0.0) or 400.0 -- this defines how far away the plane is spawned
        local theta = (rHeading / 180.0) * 3.14
        local rPlaneSpawn = vector3(spawnx, spawny, spawnz) - vector3(math.cos(theta) * planeSpawnDistance, math.sin(theta) * planeSpawnDistance, -150.0)
		
        local dx = spawnx - rPlaneSpawn.x
        local dy = spawny - rPlaneSpawn.y
        local heading = GetHeadingFromVector_2d(dx, dy) -- determine plane heading from coordinates
		
		local doingDrop = true

        local aircraft = CreateVehicle(GetHashKey(aircraftmodel), rPlaneSpawn, heading, true, true)
		
		doVehicleMods(aircraftmodel,aircraft,MissionName)
		DecorSetInt(aircraft,"mrpvehdid",65432) --not really needed
        SetEntityHeading(aircraft, heading)
        SetVehicleDoorsLocked(aircraft, 2) -- lock the doors so pirates don't get in
        SetEntityDynamic(aircraft, true)
        ActivatePhysics(aircraft)
        SetVehicleForwardSpeed(aircraft, 60.0)
        SetHeliBladesFullSpeed(aircraft) -- works for planes I guess
        SetVehicleEngineOn(aircraft, true, true, false)
        SetVehicleLandingGear(aircraft, 3) -- retract the landing gear
        OpenVehicleBombBay(aircraft) -- opens the hatch below the plane for added realism
        SetEntityProofs(aircraft, true, false, true, false, false, false, false, false)

         RequestModel(GetHashKey("s_m_m_pilot_02"))
		  
           while not HasModelLoaded(GetHashKey("s_m_m_pilot_02")) do
              Wait(0)
           end		
		
        local pilot = CreatePedInsideVehicle(aircraft, 1, GetHashKey("s_m_m_pilot_02"), -1, true, true)
		DecorSetInt(pilot,"mrpvpedid",65432) --only used to show blip on radar
		
		--local pilot = CreatePed(2, "s_m_m_pilot_02", rPlaneSpawn.x, rPlaneSpawn.y, rPlaneSpawn.z, heading, true, true)
		--print(tostring(DoesEntityExist(pilot)))
		
		--CreatePedInsideVehicle(aircraft, 1, GetHashKey("s_m_m_pilot_02"), -1, true, true) 
		--SetPedIntoVehicle(pilot,aircraft, -1)
			
        SetBlockingOfNonTemporaryEvents(pilot, true) -- ignore explosions and other shocking events
        SetPedRandomComponentVariation(pilot, false)
        SetPedKeepTask(pilot, true)
        --SetPlaneMinHeightAboveGround(aircraft, 50) -- the plane shouldn't dip below the defined altitude
		Citizen.InvokeNative( 0xB893215D8D4C015B, airplane, 50)

        TaskVehicleDriveToCoord(pilot, aircraft, vector3(spawnx, spawny, spawnz) + vector3(0.0, 0.0, 150.0), 60.0, 0, GetHashKey(aircraftmodel), 262144, 15.0, -1.0) -- to the dropsite, could be replaced with a task sequence

        local droparea = vector2(spawnx, spawny)
        local planeLocation = vector2(GetEntityCoords(aircraft).x, GetEntityCoords(aircraft).y)
		
        while not IsEntityDead(pilot) and #(planeLocation - droparea) > 5.0 do -- wait for when the plane reaches the dropCoords ± 5 units
            Wait(100)
            planeLocation = vector2(GetEntityCoords(aircraft).x, GetEntityCoords(aircraft).y) -- update plane coords for the loop
        end

        if IsEntityDead(pilot) then -- I think this will end the script if the pilot dies, no idea how to return works
            print("PILOT: dead")
			doingDrop=false
           -- do return end -- <--still allow the paradrop to happen even if the plane is not there or the pilot.
        end
		--Notify("~r~Enemy paradrop on its way!")
		if not doingDrop then 
			TaskVehicleDriveToCoord(pilot, aircraft, 0.0, 0.0, 500.0, 60.0, 0, GetHashKey(aircraftmodel), 262144, -1.0, -1.0) -- disposing of the plane like Rockstar does, send it to 0; 0 coords with -1.0 stop range, so the plane won't be able to achieve its task
		end
        SetEntityAsNoLongerNeeded(pilot) 
        SetEntityAsNoLongerNeeded(aircraft)					
			
			]]--
			
			---END DROP AIRCRAFT			
			
			
		
			

			--local zGround = checkAndGetGroundZ(locationdata.x,locationdata.y,locationdata.z,true)
			--if zGround = 0.0 then 
				-- zGround = locationdata.z
			--end
			--SetEntityCoords(GetPlayerPed(-1),locationdata.x, locationdata.y,locationdata.z)
			--TriggerEvent("mt:missiontext2","Taken to the mission safehouse", 250)
			--makeEntityFaceEntity( entity1, entity2 )
		end
	end


end)

function GetPlayers()
    local players = {}

    for i = 0, 31 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end

    return players
end


function GetClosestPlayer()
	local players = GetPlayers()
	local closestDistance = -1
	local closestPlayer = -1
	local ply = GetPlayerPed(-1)
	local plyCoords = GetEntityCoords(ply, 0)

	for index,value in ipairs(players) do
		local target = GetPlayerPed(value)
		if(target ~= ply) then
			local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
			local distance = Vdist(targetCoords["x"], targetCoords["y"], targetCoords["z"], plyCoords["x"], plyCoords["y"], plyCoords["z"])
			if(closestDistance == -1 or closestDistance > distance) then
				closestPlayer = value
				closestDistance = distance
			end
		end
	end
	return closestPlayer, closestDistance
end

--Do MissionRejuvenationFee
--which merely acts as a penalty for players dying during a mission
--when > 0
function doMissionRejuvenationFee()
	if (Active == 1) and  MissionName ~="N/A" then
		if getMissionConfigProperty(MissionName, "MissionRejuvenationFee") > 0 then

			local currentmoney = 0
			local rejuvcost = getMissionConfigProperty(MissionName, "MissionRejuvenationFee")
			local totalmoney = 0		
			
			local _,currentmoney = StatGetInt('MP0_WALLET_BALANCE',-1)
			playerMissionMoney =  0 - rejuvcost
			totalmoney =  currentmoney - rejuvcost		
				
			if UseESX then 
				TriggerServerEvent("paytheplayer", totalmoney)
				TriggerServerEvent("UpdateUserMoney", totalmoney)
			else
					--DecorSetInt(GetPlayerPed(-1),"mrpplayermoney",totalmoney)
				DecorSetInt(GetPlayerPed(-1),"mrpplayermoney",DecorGetInt(GetPlayerPed(-1),"mrpplayermoney") + playerMissionMoney)			
				mrpplayermoneyG = DecorGetInt(GetPlayerPed(-1),"mrpplayermoney")			
				StatSetInt('MP0_WALLET_BALANCE',totalmoney, true)
			end
			if SHOWWASTEDMESSAGE then 
				--print("HEY")
				MISSIONSHOWMESSAGE="~r~Mission Rejuvenation Fee: ~g~$"..getMissionConfigProperty(MissionName, "MissionRejuvenationFee")
			else 
				
				--TriggerEvent("mt:missiontext2","~r~Mission Rejuvenation Fee: ~g~$"..getMissionConfigProperty(MissionName, "MissionRejuvenationFee"), 4000)
				Notify("~h~~r~Mission Rejuvenation Fee: ~g~$"..getMissionConfigProperty(MissionName, "MissionRejuvenationFee"))
			end
			
		else 			

			MISSIONSHOWMESSAGE=" "
		end
	else 
		MISSIONSHOWMESSAGE=" "
	end

	
end

--being hassled by mission contact :-)
function doSMSRejuvenationMessage(input) 
	
	local sms_pos = math.random(1, #getMissionConfigProperty(input, "SMS_ContactNames"))
	
	local sms_subpos = math.random(1, #getMissionConfigProperty(input, "SMS_RejuvenationSubjects"))
	local sms_mespos = math.random(1, #getMissionConfigProperty(input, "SMS_RejuvenationMessages"))
	
	
	SMS_Message(getMissionConfigProperty(input, "SMS_ContactPics")[sms_pos], getMissionConfigProperty(input, "SMS_ContactNames")[sms_pos], getMissionConfigProperty(input, "SMS_RejuvenationSubjects")[sms_subpos], getMissionConfigProperty(input, "SMS_RejuvenationMessages")[sms_mespos], getMissionConfigProperty(input, "SMS_PlaySound"))	
	

end

--"start baseevents" needs to be on in server.cfg:
AddEventHandler("baseevents:onPlayerDied", function(player, reason, pos)

	if GlobalBackup then 
		TriggerEvent("RemoveBackup",true)
	end
     --  print("mrprescuecount"..DecorGetInt(GetPlayerPed(-1),"mrprescuecount"))
	mrprescuecountG = DecorGetInt(GetPlayerPed(-1),"mrprescuecount")
	mrpobjectivecountG = DecorGetInt(GetPlayerPed(-1),"mrpobjrescuecount")
	mrpcheckpointG = DecorGetInt(GetPlayerPed(-1),"mrpcheckpoint")
	mrpcheckpointsclaimedG = DecorGetInt(GetPlayerPed(-1),"mrpcheckpointsclaimed")
	--print("made it died")
	if (Active == 1) and  MissionName ~="N/A" and DecorGetInt(GetPlayerPed(-1),"mrpoptout") == 0 then
		if SHOWWASTEDMESSAGE  then 
			MISSIONSHOWRESULT = true
			BLDIDTIMEOUT = false
			MISSIONSHOWTEXT="WASTED"
			if getMissionConfigProperty(MissionName, "MissionRejuvenationFee") > 0 then
				doMissionRejuvenationFee()		
			else 
				MISSIONSHOWMESSAGE=" "
			end
		elseif getMissionConfigProperty(MissionName, "MissionRejuvenationFee") > 0 then 
			doMissionRejuvenationFee()	
		end
		
		--MissionRejuvenationSMSChance % chance per death of being harrassed by a mission contact!
		if getMissionConfigProperty(MissionName, "MissionRejuvenationSMS") and math.random(1,100) <= getMissionConfigProperty(MissionName, "MissionRejuvenationSMSChance")  then 
			local input = MissionName
			Wait(math.random(3000,7000))
			doSMSRejuvenationMessage(input) 
		end		
		
		
	end 
end)
--"start baseevents" needs to be on in server.cfg:
AddEventHandler("baseevents:onPlayerKilled", function(player, killer, reason, pos)
	-- print("mrp2rescuecount"..DecorGetInt(GetPlayerPed(-1),"mrprescuecount"))
	if GlobalBackup then 
		TriggerEvent("RemoveBackup",true)
	end
	
	mrprescuecountG = DecorGetInt(GetPlayerPed(-1),"mrprescuecount")
	mrpobjectivecountG = DecorGetInt(GetPlayerPed(-1),"mrpobjrescuecount")
	mrpcheckpointG = DecorGetInt(GetPlayerPed(-1),"mrpcheckpoint")
	mrpcheckpointsclaimedG = DecorGetInt(GetPlayerPed(-1),"mrpcheckpointsclaimed")
	--print("made it killed")
	if (Active == 1) and  MissionName ~="N/A" and DecorGetInt(GetPlayerPed(-1),"mrpoptout") == 0 then
		if SHOWWASTEDMESSAGE  then 
			MISSIONSHOWRESULT = true
			BLDIDTIMEOUT = false
			MISSIONSHOWTEXT="WASTED"
			if getMissionConfigProperty(MissionName, "MissionRejuvenationFee") > 0 then
				doMissionRejuvenationFee()		
			else 
				MISSIONSHOWMESSAGE=" "
			end
		elseif getMissionConfigProperty(MissionName, "MissionRejuvenationFee") > 0 then 
			doMissionRejuvenationFee()	
		end
		
		--MissionRejuvenationSMSChance % chance per death of being harrassed by a mission contact!
		if getMissionConfigProperty(MissionName, "MissionRejuvenationSMS") and math.random(1,100) <= getMissionConfigProperty(MissionName, "MissionRejuvenationSMSChance")  then 
			local input = MissionName
			Wait(math.random(3000,7000))
			doSMSRejuvenationMessage(input) 
		end				
		
	end 
	
	
end)


local firstjoin = true
AddEventHandler("playerSpawned", function(spawn)
	--remove any safehouse crackdown mode upgrades
	SetPedMoveRateOverride(PlayerId(),1.0)
	SetRunSprintMultiplierForPlayer(PlayerId(),1.0)	
	SetSwimMultiplierForPlayer(PlayerId(),1.0)	
	SetPedMaxHealth(GetPlayerPed(-1), Config.DefaultPlayerMaxHealthAmount)
	SetEntityHealth(GetPlayerPed(-1), Config.DefaultPlayerMaxHealthAmount)
	--SetPedComponentVariation(GetPlayerPed(-1), 9, 0, 1, 2) --take away armor		
	playerUpgraded = false

	--reset any MissionDrop Availability
	MissionDropDid=false	
	
	--Make sure safe house vehicle claims are kept when player respawns
	--as well as mission money for the session
	DecorSetInt(GetPlayerPed(-1),"mrpvehsafehousemax",mrpvehsafehousemaxG)
	DecorSetInt(GetPlayerPed(-1),"mrpplayermoney",mrpplayermoneyG)	
	DecorSetInt(GetPlayerPed(-1),"mrpplayermissioncount",mrpplayermissioncountG)
	--carry over hostage & object rescue counts?
	DecorSetInt(GetPlayerPed(-1),"mrprescuecount",mrprescuecountG)
	DecorSetInt(GetPlayerPed(-1),"mrpobjrescuecount",mrpobjectivecountG)	
	DecorSetInt(GetPlayerPed(-1),"mrpcheckpoint",mrpcheckpointG)	
	DecorSetInt(GetPlayerPed(-1),"mrpcheckpointsclaimed",mrpcheckpointsclaimedG)		
	
	local ped  = GetPlayerPed(-1)
		--GHK Add blackops preferred variations
		math.randomseed(GetGameTimer())
		if IsPedModel(ped, "s_m_y_blackops_01") then 
			--add vest
			if math.random(1,4)> 2 then 
				SetPedPropIndex(GetPlayerPed(-1), 0, 1, 0, 1)
			end 
			
			if math.random(1,4)> 2 then 
				SetPedPropIndex(GetPlayerPed(-1), 1, 0, 0, 1)
			end 			
			
			SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 1)
		elseif IsPedModel(ped, "s_m_y_blackops_02") then 
			SetPedComponentVariation(GetPlayerPed(-1), 0, 1, 0, 0)
			SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 0)
			if math.random(1,4)> 2 then 
				SetPedPropIndex(GetPlayerPed(-1), 0,1,0,1)
			end
			if math.random(1,4)> 2 then 
				SetPedPropIndex(GetPlayerPed(-1), 1,0,1,1)
			end
		elseif IsPedModel(ped, "s_m_y_blackops_03") then 
			--add glasses
			SetPedComponentVariation(GetPlayerPed(-1), 0, 1, 0, 0)
			if math.random(1,4)> 2 then 
				SetPedComponentVariation(GetPlayerPed(-1), 2, 1, 0, 0)
			end 
			if math.random(1,4)> 2 then 
				SetPedPropIndex(GetPlayerPed(-1), 1,0,0,1)
			end
		elseif IsPedModel(ped, "s_m_y_swat_01") then 
			SetPedComponentVariation(GetPlayerPed(-1), 10, 0, 1, 0)	
		end
		--GHK End blackops preferred variations	
	
	
	if MissionName ~="N/A" and Active == 1 then
		--Wait(7000)
		
		HelpMessage("Check your map for mission data. Press ~INPUT_SNIPER_ZOOM_OUT_SECONDARY~ to view mission info.",true,5000)	
	end	

	 if(firstjoin) then --should be a first time connecting player
		--lets see if this is the only player and if a mission is running
		
		local players = {}
		local cnt = 0
        ptable = GetPlayers()
        for _, i in ipairs(ptable) do
			cnt = cnt + 1 
        end	
		--if cnt = 1, then only 1 player, this player, 
		--so have server handle to start or restart a mission
		--print("player spawned firstjoin is true")
		firstjoin = false
		
		if not (Config.EnableOptIn or Config.EnableSafeHouseOptIn)then
			DecorSetInt(GetPlayerPed(-1),"mrpoptout",0)
			DecorSetInt(GetPlayerPed(-1),"mrpoptin",1)
		elseif cnt == 1 and (Config.EnableOptIn) and Config.StartMissionsOnSpawn then 
			--first player starts the missions
			DecorSetInt(GetPlayerPed(-1),"mrpoptout",0)
			DecorSetInt(GetPlayerPed(-1),"mrpoptin",1)	
		elseif cnt == 1 and (Config.EnableSafeHouseOptIn) and Config.StartMissionsOnSpawn then 
			DecorSetInt(GetPlayerPed(-1),"mrpoptout",0)
			DecorSetInt(GetPlayerPed(-1),"mrpoptin",1)	
		
		end
		
		--make sure we are respawning not during mid-game
		if MissionName =="N/A" and Active == 0 then
			playerSafeHouse = -1000000 --records game time
			if cnt == 1 then
				TriggerServerEvent("sv:checkmission",true)
				print("sv:checkmission,true")
			else 
				TriggerServerEvent("sv:checkmission",false)
				print("sv:checkmission,false")
			end
		end

		
	else 
	
		
		--reset safehouse access when player respawns?
		--really need to use ESX& database to stop 
		--players disconnecting and reconnecting
		--to record.
		--print("player spawned firstjoin is false"..tostring(getMissionConfigProperty(MissionName, "ResetSafeHouseOnRespawn")))
		if Config.ResetSafeHouseOnRespawn then 
		
		--if(getMissionConfigProperty(MissionName, "ResetSafeHouseOnRespawn") ~=nil and getMissionConfigProperty(MissionName, "ResetSafeHouseOnRespawn")) == true then 
			--print("ResetSafeHouseOnRespawn is not nil and true")
			playerSafeHouse = -1000000 --records game time
		end 
		
	 
	end 
--do we teleport?
--Wait(1000)
	if not firstjoin then --already taken care of in missionblips event
		doTeleportToSafeHouse(true)
	
	end
	
	if MissionName ~="N/A" and Active == 1 then
		local mname = MissionName
		Wait(7000)
		
		--do it again, to bypass mission chat messages on mission launch
		HelpMessage("Check your map for mission data. Press ~INPUT_SNIPER_ZOOM_OUT_SECONDARY~ to view mission info.",false,5000)	
		Wait(5000)
		
		HelpMessage("Press ~INPUT_LOOK_BEHIND~ and ~INPUT_PICKUP~ for a quick tutorial on controls and mission help",false,5000)
		Wait(5000)
		
		if getMissionConfigProperty(mname, "UseMissionDrop") and MissionDropBlip 
		and not MissionDropDid
		then 
			HelpMessage("Mission Reinforcement Drop available. Press ~INPUT_LOOK_BEHIND~ and ~INPUT_COVER~ to move there",true,5000)
			TriggerEvent("mt:missiontext2","~g~Mission Reinforcement Drop available for fast travel. Cost: $"..getMissionConfigProperty(mname, "UseMissionDropFee"), 4000)
		end
		
	end		
	  
end)

--start rcbandito--

local playerorigpos
local playerorigheading
local playerrcbandito
local playerrcbanditoexit=false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
		if((not playerrcbandito) and playerrcbanditoexit) then --exiting vehicle
			local PlayerPed = GetPlayerPed(-1)
			StartScreenEffect("MP_OrbitalCannon", 1000, false)
			DoScreenFadeOut(1000)
			Wait(1000)
			ClearPedTasksImmediately(PlayerPed)
			SetEntityCoords(PlayerPed,playerorigpos.x,playerorigpos.y,playerorigpos.z)
			SetEntityHeading(PlayerPed,playerorigheading)
			SetGameplayCamRelativeHeading(0.0)
			DoScreenFadeIn(2000)
			playerrcbanditoexit=false
			SetEntityInvincible(PlayerPed, false)
		end
	end

end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
		local PlayerPed = GetPlayerPed(-1)
		if IsPedInAnyVehicle(PlayerPed, false) then
			local PedVeh = GetVehiclePedIsIn(PlayerPed,false)
			if(tostring(GetEntityModel(GetVehiclePedIsIn(PlayerPed, false))) == "-286046740") then	
				if(not playerrcbandito) and IsVehicleDriveable(PedVeh) then 
					playerorigpos = GetEntityCoords(PedVeh, true)
					playerorigheading = GetEntityHeading(PedVeh)
					playerrcbandito = PedVeh
					--SetEntityInvincible(PlayerPed, true)
					Notify("~b~Remote control vehicle")
					Notify("~b~Use LB on the gamepad or the E key to remotely detonate the attached bomb")
				end
				SetEntityInvincible(PlayerPed, true)
				if (IsControlPressed(0, 38) and IsVehicleDriveable(PedVeh)) then 
					--SetEntityInvincible(PlayerPed, true)
					local pos = GetEntityCoords(PedVeh, true)
					
					playerrcbanditoexit=true
					AddOwnedExplosion(PlayerPed,pos.x, pos.y, pos.z, 60, 1000.0, true, false,0.0)
					AddOwnedExplosion(PlayerPed,pos.x, pos.y, pos.z, 59, 1000.0, true, false,0.0)
					AddOwnedExplosion(PlayerPed,pos.x, pos.y, pos.z, 31, 1000.0, true, false,0.0)
					NetworkExplodeVehicle(PedVeh,true,true,true) 
					Notify("~b~Remote bomb detonated")
				end
				
				if(PedVeh and not IsVehicleDriveable(PedVeh) and playerrcbandito ~= nil) then	
					--SetEntityInvincible(PlayerPed, true)
					local pos = GetEntityCoords(PedVeh, true)
					if (not playerrcbanditoexit) then
						Notify("~b~Remote control vehicle destroyed. Remote bomb detonated")
						SetEntityCoords(PlayerPed,playerorigpos.x,playerorigpos.y,playerorigpos.z)
						SetEntityHeading(PlayerPed,playerorigheading)
						playerrcbanditoexit=false
					end 
					AddOwnedExplosion(PlayerPed,pos.x, pos.y, pos.z, 60, 1000.0, true, false,0.0)
					AddOwnedExplosion(PlayerPed,pos.x, pos.y, pos.z, 59, 1000.0, true, false,0.0)
					AddOwnedExplosion(PlayerPed,pos.x, pos.y, pos.z, 31, 1000.0, true, false,0.0)
					NetworkExplodeVehicle(PedVeh,true,true,true) 			
					playerrcbandito = nil
					SetEntityInvincible(PlayerPed, false)
				end				
			
			end
		
		else 
			playerrcbandito = nil
		end
		if(playerrcbandito or playerrcbanditoexit) then 
			SetEntityInvincible(PlayerPed, true)
		end
		
		
    end
end)

--end rcbandito--



--all credit below to FAXES for his Vote-To-Kick resource: https://forum.fivem.net/t/release-vote-to-kick-vote-players-out-fax-vote2kick-1-0/191676
-----------------------------------
--- BASED ON: Vote to Kick, Made by FAXES ---
-----------------------------------
local playerVoted = false

RegisterNetEvent('mrp:SubmitVote')
AddEventHandler('mrp:SubmitVote', function(vote)
    local src = source
    if playerVoted then
        TriggerEvent("chatMessage", "^*^1You have already voted!")
    else
        if vote == "yes" then
            TriggerServerEvent("mrp:SendVote")
            TriggerEvent("chatMessage", "^2You have voted!")
        elseif vote == "no" then
            TriggerEvent("chatMessage", "^2You have voted!")
        end
        playerVoted = true
    end
end)

RegisterNetEvent('mrp:ResetVotes')
AddEventHandler('mrp:ResetVotes', function()
    playerVoted = false
end)


--------Vehcro Crate Drop : https://forum.fivem.net/t/release-crate-drop/113125

local pilot, aircraft, parachute, crate, pickup, blip, soundID, doingDrop
local requiredModels = {"p_cargo_chute_s", "ex_prop_adv_case_sm", "volatol", "s_m_m_pilot_02", "prop_box_wood02a_pu"} -- parachute, pickup case, plane, pilot, crate

--[[
RegisterCommand("cratedropmrp", function(playerServerID, args, rawString)
    local playerCoords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 10.0, 0.0) -- ISN'T THIS A TABLE ALREADY?
    TriggerEvent("crateDropMRP", args[1], tonumber(args[2]), args[3] or false, args[4] or 400.0, {["x"] = playerCoords.x, ["y"] = playerCoords.y, ["z"] = playerCoords.z})
end, false)
]]--
RegisterNetEvent("crateDropMRP")

doingDrop=false
AddEventHandler("crateDropMRP", function(weapon, ammo, roofCheck, planeSpawnDistance, dropCoords) -- all of the error checking is done here before passing the parameters to the function itself
    Citizen.CreateThread(function()
	
	if MissionName =="N/A" or Active == 0 then
		message  = "You can request a supplies drop after a mission starts" 		
		TriggerEvent("mt:missiontext2", message, 10000)
		
	end 
		
		--do not allow more than 1 drop at a time
		if (doingDrop) then
			message  = "There is a supplies drop already in progress" 		
			TriggerEvent("mt:missiontext2", message, 10000)
			return
		end
		
		doingDrop=true
		
		local thisMission = MissionName
        if IsWeaponValid(GetHashKey(weapon)) then -- only supports weapon pickups for now, use the function directly to bypass this
            weapon = "pickup_" .. weapon
            -- print("WEAPON VALIDITY: true, after concatenating 'pickup_'")
        elseif IsWeaponValid(GetHashKey("weapon_" .. weapon)) then
            weapon = "pickup_weapon_" .. weapon
            -- print("WEAPON VALIDITY: true, after concatenating 'pickup_weapon_'")
        elseif IsWeaponValid(GetHashKey(weapon:sub(8))) then
            -- print("WEAPON VALIDITY: true")
        else
            -- print("WEAPON VALIDITY: false")
            return
        end

        -- print("WEAPON: " .. string.lower(weapon))

        local ammo = (ammo and tonumber(ammo)) or 250
        if ammo > 9999 then
            ammo = 9999
        elseif ammo < -1 then
            ammo = -1
        end

        -- print("AMMO: " .. ammo)

        if dropCoords.x and dropCoords.y and dropCoords.z and tonumber(dropCoords.x) and tonumber(dropCoords.y) and tonumber(dropCoords.z) then
            -- print(("DROP COORDS: success, X = %.4f; Y = %.4f; Z = %.4f"):format(dropCoords.x, dropCoords.y, dropCoords.z))
        else
            dropCoords = {0.0, 0.0, 72.0}
            -- print("DROP COORDS: fail, defaulting to X = 0; Y = 0")
        end
		 --if Active == 1 and MissionName ~="N/A" then
			if roofCheck and roofCheck ~= "false" then  -- if roofCheck is not false then a check will be performed if a plane can drop a crate to the specified location before actually spawning a plane, if it can't, function won't be called
				-- print("ROOFCHECK: true")
				local ray = CastRayPointToPoint(vector3(dropCoords.x, dropCoords.y, dropCoords.z) + vector3(0.0, 0.0, 500.0), vector3(dropCoords.x, dropCoords.y, dropCoords.z), -1, -1, 0)
				local _, hit, impactCoords = GetRaycastResult(ray)
				-- print("HIT: " .. hit)
				-- print(("IMPACT COORDS: X = %.4f; Y = %.4f; Z = %.4f"):format(impactCoords.x, impactCoords.y, impactCoords.z))
				-- print("DISTANCE BETWEEN DROP AND IMPACT COORDS: " ..  #(vector3(dropCoords.x, dropCoords.y, dropCoords.z) - vector3(impactCoords)))
				if hit == 0 or (hit == 1 and #(vector3(dropCoords.x, dropCoords.y, dropCoords.z) - vector3(impactCoords)) < 10.0) then -- ± 10 units
					-- print("ROOFCHECK: success")
					message  = "You have requested mission equipment and upgrades~n~They are on there way~n~Cost: $"..calcSafeHouseCost(true,false,true,thisMission)		
					TriggerEvent("mt:missiontext2", message, 10000)
					playerSafeHouse = GetGameTimer()				
					CrateDropMRP(weapon, ammo, planeSpawnDistance, dropCoords,thisMission)
				else
					message  = "You need to be outside to receive your air drop of supplies and upgrades" 		
					TriggerEvent("mt:missiontext2", message, 10000)
					doingDrop=false
					-- print("ROOFCHECK: fail")
					return
				end
			else
				-- print("ROOFCHECK: false")
				message  = "You have requested mission equipment and upgrades~n~They are on there way~n~Cost: $"..calcSafeHouseCost(true,false,true,thisMission)		
				TriggerEvent("mt:missiontext2", message, 5000)
				message  = "Stay close to the drop zone"		
				TriggerEvent("mt:missiontext2", message, 5000)
				playerSafeHouse = GetGameTimer()
				CrateDropMRP(weapon, ammo, planeSpawnDistance, dropCoords,thisMission)
			end
		--end
    end)
end)

function doParadropPeds(isNPCDead,ped,k,playerPed,pcoords) 
				if not isNPCDead then 
				
				--make pilot and passengers parachute or leave vehicle:
					--may not work if on clients that did not spawn the ped: 
					--did not seem to get called, needs more testing.
					--[[if DecorGetInt(ped, "mrppedid") > 0 or DecorGetInt(ped, "mrpvpedid") > 0 and DecorGetInt(ped, "mrppedskydivertarget") == 0 then 
							if IsPedInAnyVehicle(ped) and not IsVehicleDriveable(GetVehiclePedIsIn(ped,false)) then 
								--print("MADE IT BAIL")
								SetPedParachuteTintIndex(ped, 6)
								SetPedCombatAttributes(ped, 3, true)
								DecorSetInt(ped, "mrppedskydivertarget",GetPlayerServerId(PlayerId()))
								GiveDelayedWeaponToPed(ped,GetHashKey("GADGET_PARACHUTE"),300,1)
								TaskLeaveVehicle(ped, GetVehiclePedIsIn(ped,false), 4160)
								
							end
						
					end]]--
									
				
					--parachute code v2 
					if DecorGetInt(ped, "mrppedid") > 0 and  DecorGetInt(ped, "mrppedskydivertarget") ==  GetPlayerServerId(PlayerId()) 
					and ped and playerPed and pcoords and k
					then
				
						local height = GetEntityHeightAboveGround(ped)
						local paraState = GetPedParachuteState(ped) 
						--print('height'..height)
						--if height < -1.0 then 
							--print('para less than ground')
							--local coords = GetEntityCoords(ped)
							--local ground,zGround = GetGroundZFor_3dCoord(coords.x, coords.y, 999.0)
							--if ground then
							--print('paraplaced on ground')
							--	SetEntityCoords(ped, coords.x, coords.y, zGround + 3.0)
							--end
						--end
						
						if paraState == -1 then 
							--SetEntityRecordsCollisions(ped,true)
						end	
						
						if height > 5 and (not IsPedOnFoot(ped) and not IsPedInAnyVehicle(ped,false)) or IsPedFalling(ped) then 
							--SetPedCanRagdoll(ped,true)
							SetPedSeeingRange(ped, 1.0)
							SetPedHearingRange(ped, 1.0)
							SetPedKeepTask(ped,1)
							
							if paraState ~= 2 and paraState ~=1 then 
								--print("hey1")
								SetPedParachuteTintIndex(ped, 6)
								GiveDelayedWeaponToPed(ped,GetHashKey("GADGET_PARACHUTE"),300,1)
								SetPedParachuteTintIndex(ped, 6)
								
								TaskParachuteToTarget(ped,pcoords.x,pcoords.y,pcoords.z)
								
								RegisterTarget(ped,playerPed)
							else 
								--print("hey2")
								SetParachuteTaskTarget(ped,pcoords.x,pcoords.y,pcoords.z)
							end
					
						elseif height > 5 and paraState == 1 then --print
							SetPedParachuteTintIndex(ped, 6)
										
						elseif height > 5 and paraState == 2 and DecorGetInt(ped, "mrppedskydiver") < 1 then --print
							--print("hey3")
							SetPedParachuteTintIndex(ped, 6)
							SetParachuteTaskTarget(ped,pcoords.x,pcoords.y,pcoords.z)
							TaskCombatPed(playerPed,0,16)
							DecorSetInt(ped, "mrppedskydiver",1)
						end
						
						if DecorGetInt(ped, "mrppedskydiver") > 0 and  paraState ~= 2 and paraState ~=1 then 
							--print("hey 4")
							SetPedSeeingRange(ped, 10000.0)
							SetPedHearingRange(ped, 10000.0)
							ClearPedTasks(ped)
							--target any IsDefendTarget Ped
							TargetIsDefendtargetPed(ped)
							TaskCombatHatedTargetsAroundPed(ped,500.0,0)
							DecorSetInt(ped, "mrppedskydiver",0)
							--DecorRemove
						end						
						
						
					end
				end


end


AddEventHandler("doSquad",function(k)
		--for targets markers to show up need unique integers, sortof a hack
		--print("made it")
		local basei = tonumber(tostring(k).."00000")
		if Active == 1 and MissionName ~="N/A" then
			
			local number = math.random(4,10)
			--print(k)
			if Config.Missions[MissionName].Events[k].NumberPeds then 
				number = Config.Missions[MissionName].Events[k].NumberPeds
			end
		
			local nextPed = #Config.Missions[MissionName].Peds + 1 + basei
			local totalPeds = nextPed + (number-1) 
			local pIsBoss=false
			
			local ptarget = false
			
			local spawnradius = 25.0
			if Config.Missions[MissionName].Events[k].Target then	
				ptarget = true
			end	
			
			if Config.Missions[MissionName].IsRandom and Config.Missions[MissionName].Type=="Assassinate" then 
				ptarget = true
			end
			
			if Config.Missions[MissionName].Events[k].SquadSpawnRadius then 
				spawnradius = Config.Missions[MissionName].Events[k].SquadSpawnRadius
			end
			
			local GroundZ = false
			if Config.Missions[MissionName].Events[k].CheckGroundZ then 
				GroundZ = true
			end	
			
			local facePlayer = false
			if Config.Missions[MissionName].Events[k].FacePlayer then--print
				facePlayer = true 
			end
			
			local spawnx = Config.Missions[MissionName].Events[k].Position.x
			local spawny = Config.Missions[MissionName].Events[k].Position.y
			local spawnz = Config.Missions[MissionName].Events[k].Position.z
			

			if Config.Missions[MissionName].Events[k].SpawnAt then 
				spawnx = Config.Missions[MissionName].Events[k].SpawnAt.x
				spawny = Config.Missions[MissionName].Events[k].SpawnAt.y
				spawnz = Config.Missions[MissionName].Events[k].SpawnAt.z
			
			end
					
			--drop peds to parachute
			for i=nextPed, totalPeds do
				--print(i)
				local lptarget = ptarget
				local rHeading = math.random(0, 360) + 0.0
				local theta = (rHeading / 180.0) * 3.14		
				local exactWeapon = false				
				local rPedSpawn = vector3(spawnx,spawny, spawnz) - vector3(math.cos(theta) *  math.random(0,math.floor(spawnradius)), math.sin(theta) * math.random(0,math.floor(spawnradius)), 0.0)
				local rPheading = roundToNthDecimal(math.random() + math.random(0,359),2)
				
				local pweapon = getMissionConfigProperty(MissionName, "RandomMissionWeapons")[math.random(1, #getMissionConfigProperty(MissionName, "RandomMissionWeapons"))]
				local para = getMissionConfigProperty(MissionName, "RandomMissionPeds")[math.random(1, #getMissionConfigProperty(MissionName, "RandomMissionPeds"))]	

				if getMissionConfigProperty(MissionName, "RandomMissionBossChance") >= math.random(100) and not Config.Missions[MissionName].Events[k].isBoss then 
					para = getMissionConfigProperty(MissionName, "RandomMissionBossPeds")[math.random(1, #getMissionConfigProperty(MissionName, "RandomMissionBossPeds"))]	
					pIsBoss=true
				elseif not Config.Missions[MissionName].Events[k].isBoss then  
					pIsBoss=false
				end
				
				if Config.Missions[MissionName].Events[k].isBoss then
					para = getMissionConfigProperty(MissionName, "RandomMissionBossPeds")[math.random(1, #getMissionConfigProperty(MissionName, "RandomMissionBossPeds"))]	
					pIsBoss=true
				end 
				if Config.Missions[MissionName].Events[k].modelHash then 
					para= Config.Missions[MissionName].Events[k].modelHash
				end
				if Config.Missions[MissionName].Events[k].Weapon then 
					pweapon = Config.Missions[MissionName].Events[k].Weapon
					exactWeapon = true
				end	
				

				if pIsBoss and not lptarget and Config.Missions[MissionName].Type=="BossRush" then 
					lptarget = true
				end
				
					--Config.Missions[MissionName].Peds[i]={id=i,Weapon=pweapon,modelHash=para, x=rPedSpawn.x,y= rPedSpawn.y,z=rPedSpawn.z,heading=rPheading,spawned=true,isBoss=pIsBoss,target=ptarget} --set spawned=true, so it is not sent to the server, which does not know about these new Peds
					
					if(not pIsBoss) then 
						Config.Missions[MissionName].Peds[i]={id=i,Weapon=pweapon,modelHash=para, x=rPedSpawn.x,y=rPedSpawn.y,z=rPedSpawn.z,heading=rPheading,spawned=true,target=lptarget,CheckGroundZ=GroundZ,faceplayer=facePlayer} --set spawned=true, so it is not sent to the server, which does not know about these new Peds
					else
						if exactWeapon then
							Config.Missions[MissionName].Peds[i]={id=i,modelHash=para, Weapon=pweapon,x=rPedSpawn.x,y= rPedSpawn.y,z=rPedSpawn.z,heading=rPheading,spawned=true,isBoss=pIsBoss,target=lptarget,CheckGroundZ=GroundZ,faceplayer=facePlayer} --set spawned=true, so it is not sent to the server, which does not know about these new Peds	
						else 
							Config.Missions[MissionName].Peds[i]={id=i,modelHash=para, x=rPedSpawn.x,y= rPedSpawn.y,z=rPedSpawn.z,heading=rPheading,spawned=true,isBoss=pIsBoss,target=lptarget,CheckGroundZ=GroundZ,faceplayer=facePlayer} --set spawned=true, so it is not sent to the server, which does not know about these new Peds							
						end
					end 					
					
					SpawnAPed(MissionName,i,false,"SquadEvent",Config.Missions[MissionName].Events[k].DoIsDefendBehavior,Config.Missions[MissionName].Events[k].DoBlockingOfNonTemporaryEvents)
					Config.Missions[MissionName].Peds[i]=nil
				
			end
		end



end)

--[[
function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ',\n'
      end
      return s .. '} \n'
   else
      return tostring(o)
   end
end
]]--
--special event for IsRandom missions. 
AddEventHandler("doRandomSquad",function(k,rX, rY, rZ,MissionName)
		--for targets markers to show up need unique integers, sortof a hack
		--print("made it")
		local basei = tonumber(tostring(k).."00000") +  math.random(25,750)
		if Active == 1 and MissionName ~="N/A" then
			
			local number = math.random(getMissionConfigProperty(MissionName, "IsBountyHuntMinSquadSize"),getMissionConfigProperty(MissionName, "IsBountyHuntMaxSquadSize"))
			--print(k)
			--if Config.Missions[MissionName].Events[k].NumberPeds then 
			--	number = Config.Missions[MissionName].Events[k].NumberPeds
			--end
		
			local nextPed = #Config.Missions[MissionName].Peds + 1 + basei
			local totalPeds = nextPed + (number-1) 
			local pIsBoss=false
			--print("nextPed:")
			--print(nextPed)
			local ptarget = false
			
			local spawnradius = 1.0*math.random(getMissionConfigProperty(MissionName, "IsBountySquadMinRadius"),getMissionConfigProperty(MissionName, "IsBountySquadMaxRadius")) --default 25.0
			--if Config.Missions[MissionName].Events[k].Target then	
				--ptarget = true
			--end	
			
			if Config.Missions[MissionName].IsRandom and (Config.Missions[MissionName].Type=="Assassinate" and ((not Config.Missions[MissionName].IsBountyHunt) or (Config.Missions[MissionName].IsBountyHunt and Config.Missions[MissionName].IsBountyHuntAssassinateAll)) ) then 
				ptarget = true
			end
			
			--if Config.Missions[MissionName].Events[k].SquadSpawnRadius then 
				--spawnradius = Config.Missions[MissionName].Events[k].SquadSpawnRadius
			--end
			
			local GroundZ = false
			--if Config.Missions[MissionName].Events[k].CheckGroundZ then 
				GroundZ = true
			--end	
			
			local facePlayer = false
			--if Config.Missions[MissionName].Events[k].FacePlayer then--print
				--facePlayer = true 
			--end
			
			local spawnx = rX
			local spawny = rY
			local spawnz = rZ
			

			--if Config.Missions[MissionName].Events[k].SpawnAt then 
				--spawnx = Config.Missions[MissionName].Events[k].SpawnAt.x
				--spawny = Config.Missions[MissionName].Events[k].SpawnAt.y
				--spawnz = Config.Missions[MissionName].Events[k].SpawnAt.z
			
			--end
					
			--drop peds to parachute
			for i=nextPed, totalPeds do
				--print(i)
				local lptarget = ptarget
				local rHeading = math.random(0, 360) + 0.0
				local theta = (rHeading / 180.0) * 3.14		
				local exactWeapon = false				
				local rPedSpawn = vector3(spawnx,spawny, spawnz) - vector3(math.cos(theta) *  math.random(0,math.floor(spawnradius)), math.sin(theta) * math.random(0,math.floor(spawnradius)), 0.0)
				local rPheading = roundToNthDecimal(math.random() + math.random(0,359),2)
				
				local pweapon = getMissionConfigProperty(MissionName, "RandomMissionWeapons")[math.random(1, #getMissionConfigProperty(MissionName, "RandomMissionWeapons"))]
				local para = getMissionConfigProperty(MissionName, "RandomMissionBountyPeds")[math.random(1, #getMissionConfigProperty(MissionName, "RandomMissionBountyPeds"))]	
				--print(getMissionConfigProperty(MissionName, "RandomMissionBountyBossChance"))
				if getMissionConfigProperty(MissionName, "RandomMissionBountyBossChance") >= math.random(100) then --and not Config.Missions[MissionName].Events[k].isBoss then 
				--print("made it")
					para = getMissionConfigProperty(MissionName, "RandomMissionBossPeds")[math.random(1, #getMissionConfigProperty(MissionName, "RandomMissionBossPeds"))]	
					pIsBoss=true
				--elseif not Config.Missions[MissionName].Events[k].isBoss then  
					--pIsBoss=false
				end
				
				--for first spawn for IsBountyHunt lets create a bounty target override for the squad
				if i==nextPed and Config.Missions[MissionName].Type=="Assassinate" and getMissionConfigProperty(MissionName, "IsBountyHunt") then
					para = getMissionConfigProperty(MissionName, "RandomMissionPeds")[math.random(1, #getMissionConfigProperty(MissionName, "RandomMissionPeds"))]	
					lptarget = true
					pIsBoss=true
					exactWeapon=true
				elseif i==nextPed and Config.Missions[MissionName].Type=="HostageRescue" and getMissionConfigProperty(MissionName, "IsBountyHunt") then
					para = getMissionConfigProperty(MissionName, "RandomMissionFriendlies")[math.random(1, #getMissionConfigProperty(MissionName, "RandomMissionFriendlies"))]	
					lptarget = false
					pIsBoss=false
					exactWeapon=false				
				elseif i==nextPed and Config.Missions[MissionName].Type=="BossRush" and getMissionConfigProperty(MissionName, "IsBountyHunt") then
					para = getMissionConfigProperty(MissionName, "RandomMissionBossPeds")[math.random(1, #getMissionConfigProperty(MissionName, "RandomMissionBossPeds"))]	
					pIsBoss=true
					exactWeapon=false
					lptarget=true					
				end
				
				--print(#getMissionConfigProperty(MissionName, "Blip"))
				--getMissionConfigProperty(MissionName, "Blip").Title = "Hunt Targets"
				
				--if Config.Missions[MissionName].Events[k].isBoss then
					--para = getMissionConfigProperty(MissionName, "RandomMissionBossPeds")[math.random(1, #getMissionConfigProperty(MissionName, "RandomMissionBossPeds"))]	
					--pIsBoss=true
				--end 
				--if Config.Missions[MissionName].Events[k].modelHash then 
				--	para= Config.Missions[MissionName].Events[k].modelHash
				--end
				--if Config.Missions[MissionName].Events[k].Weapon then 
				--	pweapon = Config.Missions[MissionName].Events[k].Weapon
				--	exactWeapon = true
				--end	
				

				if pIsBoss and not lptarget and Config.Missions[MissionName].Type=="BossRush" then 
					lptarget = true
				end
				
					--Config.Missions[MissionName].Peds[i]={id=i,Weapon=pweapon,modelHash=para, x=rPedSpawn.x,y= rPedSpawn.y,z=rPedSpawn.z,heading=rPheading,spawned=true,isBoss=pIsBoss,target=ptarget} --set spawned=true, so it is not sent to the server, which does not know about these new Peds
					
					if(not pIsBoss) then 
						Config.Missions[MissionName].Peds[i]={id=i,Weapon=pweapon,modelHash=para, x=rPedSpawn.x,y=rPedSpawn.y,z=rPedSpawn.z,heading=rPheading,spawned=true,target=lptarget,CheckGroundZ=GroundZ,faceplayer=facePlayer} --set spawned=true, so it is not sent to the server, which does not know about these new Peds
						
						if i==nextPed and Config.Missions[MissionName].Type=="HostageRescue" and getMissionConfigProperty(MissionName, "IsBountyHunt") then
							Config.Missions[MissionName].Peds[i]={id=i,modelHash=para, x=rPedSpawn.x,y=rPedSpawn.y,z=rPedSpawn.z,heading=rPheading,spawned=true,target=lptarget,CheckGroundZ=GroundZ,faceplayer=facePlayer,friendly=true} --set spawned=true, so it is not sent to the server, which does not know about these new Peds							
						end						
						
					
					else
						if exactWeapon then
							Config.Missions[MissionName].Peds[i]={id=i,modelHash=para, Weapon=pweapon,x=rPedSpawn.x,y= rPedSpawn.y,z=rPedSpawn.z,heading=rPheading,spawned=true,isBoss=pIsBoss,target=lptarget,CheckGroundZ=GroundZ,faceplayer=facePlayer} --set spawned=true, so it is not sent to the server, which does not know about these new Peds	
						else 
							Config.Missions[MissionName].Peds[i]={id=i,modelHash=para, x=rPedSpawn.x,y= rPedSpawn.y,z=rPedSpawn.z,heading=rPheading,spawned=true,isBoss=pIsBoss,target=lptarget,CheckGroundZ=GroundZ,faceplayer=facePlayer} --set spawned=true, so it is not sent to the server, which does not know about these new Peds
					--print("bosspree:")					
					--print(i)
							
						end
						
					end 	
					--print("lptarget:"..tostring(lptarget))
					SpawnAPed(MissionName,i,false,"RandomSquadEvent")
					pIsBoss = false
					--Wait(5)
					--extra checks due to Wait code in SpawnAPed..
					if Active == 1 and MissionName ~="N/A" then
						if i and Config.Missions[MissionName].Peds[i] then 
							Config.Missions[MissionName].Peds[i]=nil
						end
					end
			end
		end


	--print("finished")
end)

--spawn landvehicle
AddEventHandler("doVehicle",function(k)
	--for targets markers to show up need unique integers, sortof a hack
	local basei = tonumber(tostring(k).."00000")
	local nextVehicle = #Config.Missions[MissionName].Vehicles + 1 + basei
	local totalVehicles = nextVehicle -- + 1 --just 1 aircraft
	local aircraft = getMissionConfigProperty(MissionName, "RandomMissionVehicles")[math.random(1, #getMissionConfigProperty(MissionName, "RandomMissionVehicles"))]
	local pilot = getMissionConfigProperty(MissionName, "RandomMissionPeds")[math.random(1, #getMissionConfigProperty(MissionName, "RandomMissionPeds"))]
	local pilotweapon = getMissionConfigProperty(MissionName, "RandomMissionVehicleWeapons")[math.random(1, #getMissionConfigProperty(MissionName, "RandomMissionVehicleWeapons"))]
	local facePlayer = false
	
	local Nomods = false
	local Driverfiringpattern = false
	local Turretfiringpattern = false
	local ptarget = false
	
	
	if Config.Missions[MissionName].Events[k].nomods then--print
		NoMods = Config.Missions[MissionName].Events[k].nomods
	end		
	
	if Config.Missions[MissionName].Events[k].driverfiringpattern then--print
		Driverfiringpattern = Config.Missions[MissionName].Events[k].driverfiringpattern
	end		

	if Config.Missions[MissionName].Events[k].turretfiringpattern then--print
		Turretfiringpattern = Config.Missions[MissionName].Events[k].turretfiringpattern
	end			
	
	if Config.Missions[MissionName].Events[k].Target then	
		ptarget = true
	end	

	if Config.Missions[MissionName].IsRandom and Config.Missions[MissionName].Type=="Assassinate" then 
		ptarget = true
	end	
	
	if Config.Missions[MissionName].Events[k].Vehicle then--print
		aircraft = Config.Missions[MissionName].Events[k].Vehicle 
		--print("MADE IT"..aircraft)
	end
	
	if Config.Missions[MissionName].Events[k].modelHash then--print
		pilot = Config.Missions[MissionName].Events[k].modelHash 
	end
	
	if Config.Missions[MissionName].Events[k].Weapon then--print
		pilotweapon = Config.Missions[MissionName].Events[k].Weapon 
	end	
	
	if Config.Missions[MissionName].Events[k].FacePlayer then--print
		facePlayer = true 
	end		
	--heading will get set in SpawnAPed below
	local rPHeading = roundToNthDecimal(math.random() + math.random(0,359),2)
	
	--print("doAircraft event called nv:"..nextVehicle..",lv:"..totalVehicles)
	--if true then 
	--return
	--end
	
	local spawnx = Config.Missions[MissionName].Events[k].Position.x
	local spawny = Config.Missions[MissionName].Events[k].Position.y
	local spawnz = Config.Missions[MissionName].Events[k].Position.z
			

	if Config.Missions[MissionName].Events[k].SpawnAt then 
		spawnx = Config.Missions[MissionName].Events[k].SpawnAt.x
		spawny = Config.Missions[MissionName].Events[k].SpawnAt.y
		spawnz = Config.Missions[MissionName].Events[k].SpawnAt.z
			
	end
	
	
	
	if Active == 1 and MissionName ~="N/A" then
		for i=nextVehicle, totalVehicles  do
			--print(i)
			--print("MADE IT"..aircraft)
			Config.Missions[MissionName].Vehicles[i]={id=i,id2=i,Vehicle=aircraft, Weapon=pilotweapon,modelHash=pilot, x=spawnx,y=spawny,z=spawnz,heading=rPheading,spawned=true,faceplayer=facePlayer,target=ptarget,nomods=NoMods,driverfiringpattern=Driverfiringpattern,turretfiringpattern=Turretfiringpattern} --set spawned=true, so it is not sent to the server, which does not know about these new Vehicles
			SpawnAPed(MissionName,i,true,"VehicleEvent",Config.Missions[MissionName].Events[k].DoIsDefendBehavior,Config.Missions[MissionName].Events[k].DoBlockingOfNonTemporaryEvents)
			Config.Missions[MissionName].Vehicles[i]=nil
		end
	end



end)


--spawn boat

AddEventHandler("doBoat",function(k)
	--print("made it")
	--for targets markers to show up need unique integers, sortof a hack
	local basei = tonumber(tostring(k).."00000")
	local nextVehicle = #Config.Missions[MissionName].Vehicles + 1 + basei
	local totalVehicles = nextVehicle -- + 1 --just 1 aircraft
	local aircraft = getMissionConfigProperty(MissionName, "RandomMissionBoat")[math.random(1, #getMissionConfigProperty(MissionName, "RandomMissionBoat"))]
	local pilot = getMissionConfigProperty(MissionName, "RandomMissionPeds")[math.random(1, #getMissionConfigProperty(MissionName, "RandomMissionPeds"))]
	local pilotweapon = getMissionConfigProperty(MissionName, "RandomMissionVehicleWeapons")[math.random(1, #getMissionConfigProperty(MissionName, "RandomMissionVehicleWeapons"))]
	local facePlayer = false
	local Nomods = false
	local Driverfiringpattern = false
	local Turretfiringpattern = false	
	
	local ptarget = false
	
	if Config.Missions[MissionName].Events[k].nomods then--print
		NoMods = Config.Missions[MissionName].Events[k].nomods
	end		
	
	if Config.Missions[MissionName].Events[k].driverfiringpattern then--print
		Driverfiringpattern = Config.Missions[MissionName].Events[k].driverfiringpattern
	end		

	if Config.Missions[MissionName].Events[k].turretfiringpattern then--print
		Turretfiringpattern = Config.Missions[MissionName].Events[k].turretfiringpattern
	end			
	
	if Config.Missions[MissionName].Events[k].Target then	
		ptarget = true
	end	

	if Config.Missions[MissionName].IsRandom and Config.Missions[MissionName].Type=="Assassinate" then 
		ptarget = true
	end	
	
	if Config.Missions[MissionName].Events[k].Vehicle then--print
		aircraft = Config.Missions[MissionName].Events[k].Vehicle 
	end
	
	if Config.Missions[MissionName].Events[k].modelHash then--print
		pilot = Config.Missions[MissionName].Events[k].modelHash 
	end
	
	if Config.Missions[MissionName].Events[k].Weapon then--print
		pilotweapon = Config.Missions[MissionName].Events[k].Weapon 
	end	
	
	if Config.Missions[MissionName].Events[k].FacePlayer then--print
		facePlayer = true 
	end		
	--heading will get set in SpawnAPed below
	local rPHeading = roundToNthDecimal(math.random() + math.random(0,359),2)
	
	--print("doAircraft event called nv:"..nextVehicle..",lv:"..totalVehicles)
	--if true then 
	--return
	--end
	local spawnx = Config.Missions[MissionName].Events[k].Position.x
	local spawny = Config.Missions[MissionName].Events[k].Position.y
	local spawnz = Config.Missions[MissionName].Events[k].Position.z
			

	if Config.Missions[MissionName].Events[k].SpawnAt then 
		spawnx = Config.Missions[MissionName].Events[k].SpawnAt.x
		spawny = Config.Missions[MissionName].Events[k].SpawnAt.y
		spawnz = Config.Missions[MissionName].Events[k].SpawnAt.z
			
	end	
	if Config.Missions[MissionName].IsRandom then
	local isWater
		isWater,spawnz = GetWaterHeight(spawnx,spawny,0.0) -- + 5
		--print("doboat isWater="..tostring(isWater))
		--print("doboat spawnz="..spawnz)
		spawnz = spawnz + 1.0
	end
	
	if Active == 1 and MissionName ~="N/A" then
		for i=nextVehicle, totalVehicles  do
			--print(i)
			Config.Missions[MissionName].Vehicles[i]={id=i,id2=i,Vehicle=aircraft, Weapon=pilotweapon,modelHash=pilot, x=spawnx,y=spawny,z=spawnz,heading=rPheading,spawned=true,faceplayer=facePlayer,target=ptarget,nomods=NoMods,driverfiringpattern=Driverfiringpattern,turretfiringpattern=Turretfiringpattern} --set spawned=true, so it is not sent to the server, which does not know about these new Vehicles
			SpawnAPed(MissionName,i,true,"VehicleEvent",Config.Missions[MissionName].Events[k].DoIsDefendBehavior,Config.Missions[MissionName].Events[k].DoBlockingOfNonTemporaryEvents)
			Config.Missions[MissionName].Vehicles[i]=nil
		end
	end



end)

AddEventHandler("doAircraft",function(k)
	--for targets markers to show up need unique integers, sortof a hack
	local basei = tonumber(tostring(k).."00000")
	local nextVehicle = #Config.Missions[MissionName].Vehicles + 1 + basei
	local totalVehicles = nextVehicle -- + 1 --just 1 aircraft
	local aircraft = getMissionConfigProperty(MissionName, "RandomMissionAircraft")[math.random(1, #getMissionConfigProperty(MissionName, "RandomMissionAircraft"))]
	local pilot = getMissionConfigProperty(MissionName, "RandomMissionPeds")[math.random(1, #getMissionConfigProperty(MissionName, "RandomMissionPeds"))]
	local pilotweapon = getMissionConfigProperty(MissionName, "RandomMissionVehicleWeapons")[math.random(1, #getMissionConfigProperty(MissionName, "RandomMissionVehicleWeapons"))]
	local facePlayer = false
	
	local Nomods = false
	local Driverfiringpattern = false
	local Turretfiringpattern = false	
	local ptarget = false
	
	
	if Config.Missions[MissionName].Events[k].nomods then--print
		NoMods = Config.Missions[MissionName].Events[k].nomods
	end		
	
	if Config.Missions[MissionName].Events[k].driverfiringpattern then--print
		Driverfiringpattern = Config.Missions[MissionName].Events[k].driverfiringpattern
	end		

	if Config.Missions[MissionName].Events[k].turretfiringpattern then--print
		Turretfiringpattern = Config.Missions[MissionName].Events[k].turretfiringpattern
	end		
	
	if Config.Missions[MissionName].Events[k].Target then	
		ptarget = true
	end	
	
	if Config.Missions[MissionName].IsRandom and Config.Missions[MissionName].Type=="Assassinate" then 
		ptarget = true
	end	
	
	if Config.Missions[MissionName].Events[k].Vehicle then--print
		aircraft = Config.Missions[MissionName].Events[k].Vehicle 
	end
	
	if Config.Missions[MissionName].Events[k].modelHash then--print
		pilot = Config.Missions[MissionName].Events[k].modelHash 
	end
	
	if Config.Missions[MissionName].Events[k].Weapon then--print
		pilotweapon = Config.Missions[MissionName].Events[k].Weapon 
	end	
	
	if Config.Missions[MissionName].Events[k].FacePlayer then--print
		facePlayer = true 
	end		
	--heading will get set in SpawnAPed below
	local rPHeading = roundToNthDecimal(math.random() + math.random(0,359),2)
	
	--print("doAircraft event called nv:"..nextVehicle..",lv:"..totalVehicles)
	--if true then 
	--return
	--end
	
	local spawnx = Config.Missions[MissionName].Events[k].Position.x
	local spawny = Config.Missions[MissionName].Events[k].Position.y
	local spawnz = Config.Missions[MissionName].Events[k].Position.z
			

	if Config.Missions[MissionName].Events[k].SpawnAt then 
		spawnx = Config.Missions[MissionName].Events[k].SpawnAt.x
		spawny = Config.Missions[MissionName].Events[k].SpawnAt.y
		spawnz = Config.Missions[MissionName].Events[k].SpawnAt.z
			
	end	
	
	if Active == 1 and MissionName ~="N/A" then
		for i=nextVehicle, totalVehicles  do
			--print(i)
			Config.Missions[MissionName].Vehicles[i]={id=i,id2=i,Vehicle=aircraft, Weapon=pilotweapon,modelHash=pilot, x=spawnx,y=spawny,z=spawnz+Config.Missions[MissionName].Events[k].SpawnHeight,heading=rPheading,pilot=true,spawned=true,driving=true,isAircraft=true,faceplayer=facePlayer,pilot=true,target=ptarget,nomods=NoMods,driverfiringpattern=Driverfiringpattern,turretfiringpattern=Turretfiringpattern} --set spawned=true, so it is not sent to the server, which does not know about these new Vehicles
			SpawnAPed(MissionName,i,true,"AircraftEvent",Config.Missions[MissionName].Events[k].DoIsDefendBehavior,Config.Missions[MissionName].Events[k].DoBlockingOfNonTemporaryEvents)
			Config.Missions[MissionName].Vehicles[i]=nil
		end
	end



end)

AddEventHandler("doParadrop",function(dropCoords,k)
	-- print("spawned paraplane")
		local aircraftmodel = getMissionConfigProperty(MissionName, "RandomParadropAircraft")[math.random(1, #getMissionConfigProperty(MissionName, "RandomParadropAircraft"))]
		local planeSpawnDistance = 400.0
           RequestModel(GetHashKey(aircraftmodel))
		  
           while not HasModelLoaded(GetHashKey(aircraftmodel)) do
              Wait(0)
           end
        local rHeading = math.random(0, 360) + 0.0
		
		local spawnx = dropCoords.x
		local spawny = dropCoords.y
		local spawnz = dropCoords.z
		
		--print("spawnz:"..tostring(dropCoords.z))
		

			if Config.Missions[MissionName].Events[k].SpawnAt then 
				spawnx = Config.Missions[MissionName].Events[k].SpawnAt.x
				spawny = Config.Missions[MissionName].Events[k].SpawnAt.y
				spawnz = Config.Missions[MissionName].Events[k].SpawnAt.z
			end	
	
		
		--print("spawnz:"..tostring(spawnz))
		
		if spawnz == 0.0 then
			local ground,zGround = GetGroundZFor_3dCoord(spawnx, spawny, 999.0)
			if (not ground) or zGround == 0.0  then 
					--print('paradrop too low. ground not found')
					if GetEntityHeightAboveGround(GetPlayerPed(-1)) < 10 then 
						local coords = GetEntityCoords(GetPlayerPed(-1))
						spawnz = coords.z +  150
						--print('paradrop too low. ground not found adding 150 to playerpos')
					end
			else 
					--print('paradrop too low. ground found adding 150')
					spawnz = zGround + 150
			end
			
		end 
        local planeSpawnDistance = (planeSpawnDistance and tonumber(planeSpawnDistance) + 0.0) or 400.0 -- this defines how far away the plane is spawned
        local theta = (rHeading / 180.0) * 3.14
        local rPlaneSpawn = vector3(spawnx, spawny, spawnz) - vector3(math.cos(theta) * planeSpawnDistance, math.sin(theta) * planeSpawnDistance, -150.0)
		
        local dx = spawnx - rPlaneSpawn.x
        local dy = spawny - rPlaneSpawn.y
        local heading = GetHeadingFromVector_2d(dx, dy) -- determine plane heading from coordinates
		
		local doingDrop = true

        local aircraft = CreateVehicle(GetHashKey(aircraftmodel), rPlaneSpawn, heading, true, true)
		
		doVehicleMods(aircraftmodel,aircraft,MissionName)
		DecorSetInt(aircraft,"mrpvehdid",65432) --not really needed
		doVehicleMods(aircraftmodel,aircraft,MissionName) 
        SetEntityHeading(aircraft, heading)
        SetVehicleDoorsLocked(aircraft, 2) -- lock the doors so pirates don't get in
        SetEntityDynamic(aircraft, true)
        ActivatePhysics(aircraft)
        SetVehicleForwardSpeed(aircraft, 60.0)
        SetHeliBladesFullSpeed(aircraft) -- works for planes I guess
        SetVehicleEngineOn(aircraft, true, true, false)
        SetVehicleLandingGear(aircraft, 3) -- retract the landing gear
        OpenVehicleBombBay(aircraft) -- opens the hatch below the plane for added realism
        SetEntityProofs(aircraft, true, false, true, false, false, false, false, false)

         RequestModel(GetHashKey("s_m_m_pilot_02"))
		  
           while not HasModelLoaded(GetHashKey("s_m_m_pilot_02"))  do
              Wait(0)
           end		
		
        local pilot = CreatePedInsideVehicle(aircraft, 1, GetHashKey("s_m_m_pilot_02"), -1, true, true)
		DecorSetInt(pilot,"mrpvpedid",65432) --only used to show blip on radar
		
		--local pilot = CreatePed(2, "s_m_m_pilot_02", rPlaneSpawn.x, rPlaneSpawn.y, rPlaneSpawn.z, heading, true, true)
		--print(tostring(DoesEntityExist(pilot)))
		
		--CreatePedInsideVehicle(aircraft, 1, GetHashKey("s_m_m_pilot_02"), -1, true, true) 
		--SetPedIntoVehicle(pilot,aircraft, -1)
			
        SetBlockingOfNonTemporaryEvents(pilot, true) -- ignore explosions and other shocking events
        SetPedRandomComponentVariation(pilot, false)
        SetPedKeepTask(pilot, true)
        --SetPlaneMinHeightAboveGround(aircraft, 50) -- the plane shouldn't dip below the defined altitude
		Citizen.InvokeNative( 0xB893215D8D4C015B, airplane, 50)

        TaskVehicleDriveToCoord(pilot, aircraft, vector3(spawnx, spawny, spawnz) + vector3(0.0, 0.0, 150.0), 60.0, 0, GetHashKey(aircraftmodel), 262144, 15.0, -1.0) -- to the dropsite, could be replaced with a task sequence

        local droparea = vector2(spawnx, spawny)
        local planeLocation = vector2(GetEntityCoords(aircraft).x, GetEntityCoords(aircraft).y)
		
        while not IsEntityDead(pilot) and #(planeLocation - droparea) > 5.0 do -- wait for when the plane reaches the dropCoords ± 5 units
            Wait(100)
            planeLocation = vector2(GetEntityCoords(aircraft).x, GetEntityCoords(aircraft).y) -- update plane coords for the loop
        end

        if IsEntityDead(pilot) then -- I think this will end the script if the pilot dies, no idea how to return works
            print("PILOT: dead")
			doingDrop=false
           -- do return end -- <--still allow the paradrop to happen even if the plane is not there or the pilot.
        end
		--if getMissionConfigProperty(MissionName, "AnnounceEvents") then  
		 --Notify("~r~Enemy paradrop on its way!")
		--end
		if not doingDrop then 
			TaskVehicleDriveToCoord(pilot, aircraft, 0.0, 0.0, 500.0, 60.0, 0, GetHashKey(aircraftmodel), 262144, -1.0, -1.0) -- disposing of the plane like Rockstar does, send it to 0; 0 coords with -1.0 stop range, so the plane won't be able to achieve its task
		end
        SetEntityAsNoLongerNeeded(pilot) 
        SetEntityAsNoLongerNeeded(aircraft)		
		
		
		
		
		if Active == 1 and MissionName ~="N/A" then
			
			local number = math.random(4,10)
			local pIsBoss=false
			
			local ptarget=false
			
			if Config.Missions[MissionName].Events[k].target then 
				number = Config.Missions[MissionName].Events[k].NumberPeds
			end
			
			if Config.Missions[MissionName].Events[k].Target then	
				ptarget = true
			end
			
			if Config.Missions[MissionName].IsRandom and Config.Missions[MissionName].Type=="Assassinate" then 
				ptarget = true
			end				
			--for targets markers to show up need unique integers, sortof a hack
			local basei = tonumber(tostring(k).."00000")
			local nextPed = #Config.Missions[MissionName].Peds + 1 + basei
			local totalPeds = nextPed + (number-1) 
			--drop peds to parachute
			for i=nextPed, totalPeds do
				--print(i)
				--rHeading = math.random(0, 360) + 0.0
       
				--theta = (rHeading / 180.0) * 3.14		
				local lptarget = ptarget
				local rPedSpawn = vector3(spawnx, spawny, spawnz) - vector3(math.cos(theta) * 25, math.sin(theta) * 25, -150.0)
				
				--print('rPedSpawn.z'..rPedSpawn.z)
				local ground,zGround = GetGroundZFor_3dCoord(rPedSpawn.y, rPedSpawn.y, 999.0)				
				--if ground then 
					--print('zGround: '..zGround)
				--else
				--	print('zGround: 0')
				--end
				local rPHeading = roundToNthDecimal(math.random() + math.random(0,359),2)
				
				local exactWeapon = false
				
				local pweapon = getMissionConfigProperty(MissionName, "RandomParadropWeapons")[math.random(1, #getMissionConfigProperty(MissionName, "RandomParadropWeapons"))]
				local para = getMissionConfigProperty(MissionName, "RandomParadropPeds")[math.random(1, #getMissionConfigProperty(MissionName, "RandomParadropPeds"))]				
				
				if Config.Missions[MissionName].Events[k].modelHash then 
					para= Config.Missions[MissionName].Events[k].modelHash
				end
				if Config.Missions[MissionName].Events[k].Weapon then 
					pweapon = Config.Missions[MissionName].Events[k].Weapon
					exactWeapon = true
				end
				
				if getMissionConfigProperty(MissionName, "RandomMissionBossChance") >= math.random(100) and not Config.Missions[MissionName].Events[k].isBoss then 
					para = getMissionConfigProperty(MissionName, "RandomMissionBossPeds")[math.random(1, #getMissionConfigProperty(MissionName, "RandomMissionBossPeds"))]	
					pIsBoss=true
				elseif not Config.Missions[MissionName].Events[k].isBoss then  
					pIsBoss=false
				end

				if Config.Missions[MissionName].Events[k].isBoss then
					para = getMissionConfigProperty(MissionName, "RandomMissionBossPeds")[math.random(1, #getMissionConfigProperty(MissionName, "RandomMissionBossPeds"))]	
					pIsBoss=true
				end 


				if pIsBoss and not lptarget and Config.Missions[MissionName].Type=="BossRush" then 
					lptarget = true
				end				
				
					if(not pIsBoss) then 
						Config.Missions[MissionName].Peds[i]={id=i,Weapon=pweapon,modelHash=para, x=rPedSpawn.x,y= rPedSpawn.y,z=rPedSpawn.z,heading=rPheading,spawned=true,target=lptarget} --set spawned=true, so it is not sent to the server, which does not know about these new Peds
					else
						if exactWeapon then 
							Config.Missions[MissionName].Peds[i]={id=i,modelHash=para,Weapon=pweapon, x=rPedSpawn.x,y= rPedSpawn.y,z=rPedSpawn.z,heading=rPheading,spawned=true,isBoss=pIsBoss,target=lptarget} --set spawned=true, so it is not sent to the server, which does not know about these new Peds	
						else 
							Config.Missions[MissionName].Peds[i]={id=i,modelHash=para, x=rPedSpawn.x,y= rPedSpawn.y,z=rPedSpawn.z,heading=rPheading,spawned=true,isBoss=pIsBoss,target=lptarget} --set spawned=true, so it is not sent to the server, which does not know about these new Peds							
						end						
					end 
					
					SpawnAPed(MissionName,i,false,Config.Missions[MissionName].Events[k].DoIsDefendBehavior,Config.Missions[MissionName].Events[k].DoBlockingOfNonTemporaryEvents)
					SetPedParachuteTintIndex(Config.Missions[MissionName].Peds[i].id, 6)
					DecorSetInt(Config.Missions[MissionName].Peds[i].id,"mrppedskydivertarget",GetPlayerServerId(PlayerId())) 
					Config.Missions[MissionName].Peds[i]=nil
				
			end
		end
		   

end)


function CrateDropMRP(weapon, ammo, planeSpawnDistance, dropCoords,thisMission)
    Citizen.CreateThread(function()

        for i = 1, #requiredModels do
            RequestModel(GetHashKey(requiredModels[i]))
            while not HasModelLoaded(GetHashKey(requiredModels[i]))  do
                Wait(0)
            end
        end

        --[[
        RequestAnimDict("P_cargo_chute_S")
        while not HasAnimDictLoaded("P_cargo_chute_S") do -- wasn't able to get animations working
            Wait(0)
        end
        ]]

        RequestWeaponAsset(GetHashKey("weapon_flare")) -- flare won't spawn later in the script if we don't request it right now
        while not HasWeaponAssetLoaded(GetHashKey("weapon_flare")) do
            Wait(0)
        end

        local rHeading = math.random(0, 360) + 0.0
        local planeSpawnDistance = (planeSpawnDistance and tonumber(planeSpawnDistance) + 0.0) or 400.0 -- this defines how far away the plane is spawned
        local theta = (rHeading / 180.0) * 3.14
        local rPlaneSpawn = vector3(dropCoords.x, dropCoords.y, dropCoords.z) - vector3(math.cos(theta) * planeSpawnDistance, math.sin(theta) * planeSpawnDistance, -500.0) -- the plane is spawned at

        -- print(("PLANE COORDS: X = %.4f; Y = %.4f; Z = %.4f"):format(rPlaneSpawn.x, rPlaneSpawn.y, rPlaneSpawn.z))
        -- print("PLANE SPAWN DISTANCE: " .. #(vector2(rPlaneSpawn.x, rPlaneSpawn.y) - vector2(dropCoords.x, dropCoords.y)))

        local dx = dropCoords.x - rPlaneSpawn.x
        local dy = dropCoords.y - rPlaneSpawn.y
        local heading = GetHeadingFromVector_2d(dx, dy) -- determine plane heading from coordinates

        aircraft = CreateVehicle(GetHashKey("volatol"), rPlaneSpawn, heading, true, true) --volatol
		if MissionName ~="N/A" and Active == 1 then
			doVehicleMods("volatol",aircraft,MissionName)
		end
        SetEntityHeading(aircraft, heading)
        SetVehicleDoorsLocked(aircraft, 2) -- lock the doors so pirates don't get in
        SetEntityDynamic(aircraft, true)
        ActivatePhysics(aircraft)
        SetVehicleForwardSpeed(aircraft, 60.0)
        SetHeliBladesFullSpeed(aircraft) -- works for planes I guess
        SetVehicleEngineOn(aircraft, true, true, false)
        SetVehicleLandingGear(aircraft, 3) -- retract the landing gear
        OpenVehicleBombBay(aircraft) -- opens the hatch below the plane for added realism
        SetEntityProofs(aircraft, true, false, true, false, false, false, false, false)

        pilot = CreatePedInsideVehicle(aircraft, 1, GetHashKey("s_m_m_pilot_02"), -1, true, true)
        SetBlockingOfNonTemporaryEvents(pilot, true) -- ignore explosions and other shocking events
        SetPedRandomComponentVariation(pilot, false)
        SetPedKeepTask(pilot, true)
        --SetPlaneMinHeightAboveGround(aircraft, 50) -- the plane shouldn't dip below the defined altitude
		Citizen.InvokeNative( 0xB893215D8D4C015B, airplane, 50)

        TaskVehicleDriveToCoord(pilot, aircraft, vector3(dropCoords.x, dropCoords.y, dropCoords.z) + vector3(0.0, 0.0, 500.0), 60.0, 0, GetHashKey("volatol"), 262144, 15.0, -1.0) -- to the dropsite, could be replaced with a task sequence

        local droparea = vector2(dropCoords.x, dropCoords.y)
        local planeLocation = vector2(GetEntityCoords(aircraft).x, GetEntityCoords(aircraft).y)
        while not IsEntityDead(pilot) and #(planeLocation - droparea) > 5.0 do -- wait for when the plane reaches the dropCoords ± 5 units
            Wait(100)
            planeLocation = vector2(GetEntityCoords(aircraft).x, GetEntityCoords(aircraft).y) -- update plane coords for the loop
        end

        if IsEntityDead(pilot) then -- I think this will end the script if the pilot dies, no idea how to return works
            print("PILOT: dead")
			doingDrop=false
            do return end
        end
		Notify("~b~Supply drop on its way")
        TaskVehicleDriveToCoord(pilot, aircraft, 0.0, 0.0, 500.0, 60.0, 0, GetHashKey("volatol"), 262144, -1.0, -1.0) -- disposing of the plane like Rockstar does, send it to 0; 0 coords with -1.0 stop range, so the plane won't be able to achieve its task
        SetEntityAsNoLongerNeeded(pilot) 
        SetEntityAsNoLongerNeeded(aircraft)

        local crateSpawn = vector3(dropCoords.x, dropCoords.y, GetEntityCoords(aircraft).z - 5.0) -- crate will drop to the exact position as planned, not at the plane's current position

        crate = CreateObject(GetHashKey("prop_box_wood02a_pu"), crateSpawn, true, true, true) -- a breakable crate to be spawned directly under the plane, probably could be spawned closer to the plane
        DecorSetInt(crate,"mrpsafehousecrateid",1) --Tag this as a safehouse crate
		SetEntityLodDist(crate, 1000) -- so we can see it from the distance
        ActivatePhysics(crate)
        SetDamping(crate, 2, 0.1) -- no idea but Rockstar uses it
        SetEntityVelocity(crate, 0.0, 0.0, -0.2) -- I think this makes the crate drop down, not sure if it's needed as many times in the script as I'm using

        parachute = CreateObject(GetHashKey("p_cargo_chute_s"), crateSpawn, true, true, true) -- create the parachute for the crate, location isn't too important as it'll be later attached properly
        SetEntityLodDist(parachute, 1000)
        SetEntityVelocity(parachute, 0.0, 0.0, -0.2)

        -- PlayEntityAnim(parachute, "P_cargo_chute_S_deploy", "P_cargo_chute_S", 1000.0, false, false, false, 0, 0)
        -- ForceEntityAiAndAnimationUpdate(parachute)

        pickup = CreateAmbientPickup(GetHashKey(weapon), crateSpawn, 0, ammo, GetHashKey("ex_prop_adv_case_sm"), true, true) -- create the pickup itself, location isn't too important as it'll be later attached properly
        ActivatePhysics(pickup)
        SetDamping(pickup, 2, 0.0245)
        SetEntityVelocity(pickup, 0.0, 0.0, -0.2)

        soundID = GetSoundId() -- we need a sound ID for calling the native below, otherwise we won't be able to stop the sound later
        PlaySoundFromEntity(soundID, "Crate_Beeps", pickup, "MP_CRATE_DROP_SOUNDS", true, 0) -- crate beep sound emitted from the pickup

        blip = AddBlipForEntity(pickup)
        SetBlipSprite(blip, 408) -- 351 or 408 are both fine, 408 is just bigger
        --SetBlipNameFromTextFile(blip, "AMD_BLIPN")
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Safehouse Supplies Drop")
		EndTextCommandSetBlipName(blip)	
        SetBlipScale(blip, 0.9)
        SetBlipColour(blip, 3)
        SetBlipAlpha(blip, 120) -- blip will be semi-transparent

        -- local crateBeacon = StartParticleFxLoopedOnEntity_2("scr_crate_drop_beacon", pickup, 0.0, 0.0, 0.2, 0.0, 0.0, 0.0, 1065353216, 0, 0, 0, 1065353216, 1065353216, 1065353216, 0)--1.0, false, false, false)
        -- SetParticleFxLoopedColour(crateBeacon, 0.8, 0.18, 0.19, false)

        AttachEntityToEntity(parachute, pickup, 0, 0.0, 0.0, 0.1, 0.0, 0.0, 0.0, false, false, false, false, 2, true) -- attach the crate to the pickup
        AttachEntityToEntity(pickup, crate, 0, 0.0, 0.0, 0.3, 0.0, 0.0, 0.0, false, false, true, false, 2, true) -- attach the pickup to the crate, doing it in any other order makes the crate drop spazz out
		
		SetEntityAsMissionEntity(crate,true,true)
		local timetowaittilldrop = GetGameTimer() + 120000 --2 minutes
        while HasObjectBeenBroken(crate) == false and (GetGameTimer() <= timetowaittilldrop) do -- wait till the crate gets broken (probably on impact), then continue with the script
            Wait(0)
			--print("waiting for drop..."..(timetowaittilldrop-GetGameTimer()))
        end
		
		--player most likely moved away too far, delete it, since it stays in the air.
		if(GetGameTimer() > timetowaittilldrop) then 
			message  = "You lost your supplies"		
			PlaySoundFrontend(-1, "Crash", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1) 	
			TriggerEvent("mt:missiontext2", message, 10000)
			SetEntityAsMissionEntity(pilot, false, true)
			DeleteEntity(pilot)
			SetEntityAsMissionEntity(aircraft, false, true)
			DeleteEntity(aircraft)
			DeleteEntity(parachute)
			DeleteEntity(crate)
			SetEntityCoords(pickup, -10000.647, -10000.97, 0.7186, 0.968)
			SetEntityAsNoLongerNeeded(pickup)
			RemovePickup(pickup)
			DeleteObject(pickup)				
			RemoveBlip(blip)
			StopSound(soundID)
			ReleaseSoundId(soundID)

			for i = 1, #requiredModels do
				Wait(0)
				SetModelAsNoLongerNeeded(GetHashKey(requiredModels[i]))
			end
			doingDrop=false
			return	
		end
		
		
        local parachuteCoords = vector3(GetEntityCoords(parachute)) -- we get the parachute dropCoords so we know where to drop the flare
        ShootSingleBulletBetweenCoords(parachuteCoords, parachuteCoords - vector3(0.0001, 0.0001, 0.0001), 0, false, GetHashKey("weapon_flare"), 0, true, false, -1.0) -- flare needs to be dropped with dropCoords like that, otherwise it remains static and won't remove itself later
        DetachEntity(parachute, true, true)
        -- SetEntityCollision(parachute, false, true) -- pointless right now but would be cool if animations would work and you'll be able to walk through the parachute while it's disappearing
        -- PlayEntityAnim(parachute, "P_cargo_chute_S_crumple", "P_cargo_chute_S", 1000.0, false, false, false, 0, 0)
        DeleteEntity(parachute)
        DetachEntity(pickup) -- will despawn on its own
        SetBlipAlpha(blip, 255) -- make the blip fully visible

		
		message  = "Your mission equipment and upgrades have landed. You have one minute to claim it"		
		TriggerEvent("mt:missiontext2", message, 10000)
		
       -- while DoesEntityExist(pickup) do -- wait till the pickup gets picked up, then the script can continue
            --Wait(0)
        --end
		local timetowaittill = GetGameTimer() + 60000 --1 minute
		repeat 
			Wait(1000)
		until (IsEntityAtEntity(GetPlayerPed(-1), crate, 1.0, 1.0, 2.0, 0, 1, 0) or GetGameTimer() > timetowaittill)
		
		if(GetGameTimer() <= timetowaittill) then 
			--player picked it up in time.
			-- if Active == 1 and MissionName ~="N/A" then
				if getMissionConfigProperty(thisMission, "SafeHouseCrackDownMode") then
					SetPedMaxHealth(GetPlayerPed(-1), getMissionConfigProperty(thisMission, "SafeHouseCrackDownModeHealthAmount"))
					SetEntityHealth(GetPlayerPed(-1), getMissionConfigProperty(thisMission, "SafeHouseCrackDownModeHealthAmount"))
					SetPlayerMaxArmour(GetPlayerPed(-1),100)
					AddArmourToPed(GetPlayerPed(-1), 100)
					SetPedArmour(GetPlayerPed(-1), 100)
					
					SetPedMoveRateOverride(PlayerId(),10.0)
					SetRunSprintMultiplierForPlayer(PlayerId(),1.49)
					SetSwimMultiplierForPlayer(PlayerId(),1.49)					
					--SetPedPropIndex(GetPlayerPed(-1), 0, 0, 0, 2) --give hat
					--SetPedPropIndex(GetPlayerPed(-1), 0, 0, 4,2)
					--SetPedComponentVariation(GetPlayerPed(-1), 9, 4, 1, 2) --give armor
					--SetPedComponentVariation(player, 9, 6, 1, 2)
					playerUpgraded = true
					Notify("~b~Nano-bio upgrades given...")
					Notify("~b~You can run and swim much faster")
					Notify("~b~You can jump much higher")
					
					
					if(getMissionConfigProperty(thisMission, "RegenHealthAndArmour")) then
						Notify("~b~You will regenerate health more quickly")
					end					
				else
					--DOES THIS WORK? IT DOES NOT FOR ARMOR BELOW
					SetPedMaxHealth(GetPlayerPed(-1), Config.DefaultPlayerMaxHealthAmount)
					SetEntityHealth(GetPlayerPed(-1),Config.DefaultPlayerMaxHealthAmount)
					AddArmourToPed(GetPlayerPed(-1),100)
					SetPedArmour(GetPlayerPed(-1), 100)						
					--AddArmourToPed(GetPlayerPed(-1), GetPlayerMaxArmour(GetPlayerPed(-1)))
					--SetPedArmour(GetPlayerPed(-1), GetPlayerMaxArmour(GetPlayerPed(-1)))				
				
				end
				
			--give players
				getSpawnSafeHousePickups(thisMission)
				getSpawnSafeHouseComponents(thisMission)
				--call twice, to make sure all custom rounds get added. Not sure why it doesnt work first time.
				getSpawnSafeHousePickups(thisMission)
				getSpawnSafeHouseComponents(thisMission)
				--default in game is 40 rounds for explosive heavy sniper rounds. Alter this for some balance:
				SetPedAmmoByType(GetPlayerPed(-1), 0xADD16CB9, getMissionConfigProperty(thisMission, "SafeHouseSniperExplosiveRoundsGiven"))
				
				SetEntityCoords(pickup, -10000.647, -10000.97, 0.7186, 0.968)
				--local safehousecost = calcSafeHouseCost(true,false,true,thisMission)
				--if safehousecost ~= 0 then 
					--message  = "You have received your mission equipment and health~n~Check your inventory~n~Cost: $"..safehousecost	
				--else 
				message  = "You have received your mission equipment and upgrades~n~Check your inventory~n~Good luck!"		
				--end	
				TriggerEvent("mt:missiontext2", message, 10000)
				PlaySoundFrontend(-1, "GO", "HUD_MINI_GAME_SOUNDSET", 1)			
				
			--end			
		else 
			--player didnt get there in time
			--else 
				message  = "The mission equipment drop has self destructed!~n~You did not claim it on time"		
				--end	
				TriggerEvent("mt:missiontext2", message, 10000)
				PlaySoundFrontend(-1, "Crash", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1) 					
			
		end
		
		doingDrop=false
        while DoesObjectOfTypeExistAtCoords(parachuteCoords, 10.0, GetHashKey("w_am_flare"), true) do
            Wait(0)
            local prop = GetClosestObjectOfType(parachuteCoords, 10.0, GetHashKey("w_am_flare"), false, false, false)
            RemoveParticleFxFromEntity(prop)
            SetEntityAsMissionEntity(prop, true, true)
            DeleteObject(prop)
        end
		SetEntityCoords(pickup, -10000.647, -10000.97, 0.7186, 0.968)
		SetEntityAsNoLongerNeeded(pickup)
		RemovePickup(pickup)
		DeleteObject(pickup)
		DeleteEntity(crate)		

        if DoesBlipExist(blip) then -- remove the blip, should get removed when the pickup gets picked up anyway, but isn't a bad idea to make sure of it
            RemoveBlip(blip)
        end

        StopSound(soundID) -- stop the crate beeping sound
        ReleaseSoundId(soundID) -- won't need this sound ID any longer

        for i = 1, #requiredModels do
            Wait(0)
            SetModelAsNoLongerNeeded(GetHashKey(requiredModels[i]))
        end

        RemoveWeaponAsset(GetHashKey("weapon_flare"))
    end)
end


--event for upgrade drop call
Citizen.CreateThread(function()
while true do

	Citizen.Wait(0)
	
	
		--swap seat with backup LB + RB 
		 if Active == 1 and MissionName ~="N/A" and IsControlPressed(0, 44) and  IsControlPressed(0, 38) then
			
			if DecorGetInt(GetPlayerPed(-1),"mrpoptout") == 0 then
				
				
				TriggerEvent("SwapSeatWithBackup")
			
				Wait(3500)
				
			end
		end				
	
	
		--Left stick down + RB: drop/remove MissionDrop marker
		if (IsControlPressed(0, 36) and IsControlPressed(0, 44)) and DecorGetInt(GetPlayerPed(-1),"mrpoptout") == 0 and true then
			
			TriggerEvent("doMissionDrop")
			
			Wait(3500)
		end
		
		
		--Right stick down + RB: teleport to MissionDrop
		if (IsControlPressed(0, 26) and IsControlPressed(0, 44)) and DecorGetInt(GetPlayerPed(-1),"mrpoptout") == 0 and true then
			
			TriggerEvent("doMissionDropTeleport")
			
			Wait(3500)
		end	

		--Right stick down + LB: Mission Help
		if (IsControlPressed(0, 26) and IsControlPressed(0, 38)) and DecorGetInt(GetPlayerPed(-1),"mrpoptout") == 0 and true then
			if MissionName ~="N/A" and Active == 1  then 
				TriggerEvent("mt:doMissionHelpText",MissionName)
			
					Wait(3500)
				end
		end	

		--DPAD LEFT + RIGHT STICK DOWN
		if (IsControlPressed(0, 15) and IsControlPressed(0, 26)) and DecorGetInt(GetPlayerPed(-1),"mrpoptout") == 0 and true then
			if MissionName ~="N/A" and Active == 1 and not GlobalBackup then 
				
				TriggerEvent("SpawnBackup",MissionName)
					
					Wait(3500)
					
			end
		end	
		
		--DPAD DOWN + RIGHT STICK DOWN
		if (IsControlPressed(0, 20) and IsControlPressed(0, 26)) and DecorGetInt(GetPlayerPed(-1),"mrpoptout") == 0 and true then
			if MissionName ~="N/A" and Active == 1 and GlobalBackup then 
				

				TriggerEvent("RemoveBackup",MissionName,true)
				
				Wait(2000)
				Notify("~h~~r~Mission backup has left")
				TriggerEvent("mt:missiontext2","~r~Mission backup has left", 4000)				
				
				Wait(1500)
					
			end
		end			

		--DPAD RIGHT + RIGHT STICK DOWN
		if (IsControlPressed(0, 14) and IsControlPressed(0, 26)) and DecorGetInt(GetPlayerPed(-1),"mrpoptout") == 0 and true then
			if MissionName ~="N/A" and Active == 1 and not GlobalBackup then 
				if getMissionConfigProperty(MissionName, "BackupPedHeavyMunitionsAllow") then 
					--TriggerEvent("ToggleBackup",MissionName)
					GlobalBackupIndex=GlobalBackupIndex + 1
					
					if GlobalBackupIndex > #getMissionConfigProperty(MissionName, "BackupPedHeavyMunitions") then 
						GlobalBackupIndex = 0
						HelpMessage("Regular Backup selected. Cost: $"..getMissionConfigProperty(MissionName, "BackupPedFee"),true,5000)
					else 
				
						HelpMessage("Backup with "..getMissionConfigProperty(MissionName, "BackupPedHeavyMunitionsText")[GlobalBackupIndex] .." selected. Cost: $"..getMissionConfigProperty(MissionName, "BackupPedHeavyMunitionsCost")[GlobalBackupIndex],true,5000)				
						
						
					end
					
					
				end	
					Wait(1500)
					
			end
		end					
	
		if (IsControlPressed(0, 36) and IsControlPressed(0, 37)) and DecorGetInt(GetPlayerPed(-1),"mrpoptout") == 0 then 
			if  Active == 1 and MissionName ~="N/A" then
				
				if (getMissionConfigProperty(MissionName, "UseSafeHouseCrateDrop") and (GetGameTimer() - getMissionConfigProperty(MissionName, "SafeHouseTimeTillNextUse")) > playerSafeHouse) then
					
					--if IsPedOnFoot(GetPlayerPed(-1)) then
						--Citizen.Wait(500)
						--print("crate drop called")
						--weapon, ammo, roofCheck, planeSpawnDistance, dropCoords
						if(doingDrop) then 
							--message  = "There is a supplies drop already in progress" 		
							--TriggerEvent("mt:missiontext2", message, 10000)
						else
							local playerCoords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 10.0, 0.0) -- ISN'T THIS A TABLE ALREADY?
							TriggerEvent("crateDropMRP", "flashlight", tonumber(1),true,400.0, {["x"] = playerCoords.x, ["y"] = playerCoords.y, ["z"] = playerCoords.z})
						end 
						--message  = "You have requested your mission equipment and upgrades~n~It's on it's way~n~Cost: $"..calcSafeHouseCost(true,false,true)		
						--end	
						--TriggerEvent("mt:missiontext2", message, 10000)
						--playerSafeHouse = GetGameTimer()
					--else 
					
						--message  = "You need to be outside of a vehicle~n~to receive your supply drop"		
						--TriggerEvent("mt:missiontext2", message, 10000)				
					
					--end
				end
			else 
				message  = "You may request a supplies drop after a mission has started" 		
				TriggerEvent("mt:missiontext2", message, 10000)
			
			end
			Wait(3500)	
		elseif (IsControlPressed(0, 44) and IsControlPressed(0, 14)) 
		
		and DecorGetInt(GetPlayerPed(-1),"mrpoptout") == 0 then
			
		--RB and dpad left (E + SCROLLWHEEL DOWN)
			if  Active == 1 and MissionName ~="N/A" then
				if (getMissionConfigProperty(MissionName, "UseSafeHouseBanditoDrop") and (GetGameTimer() - getMissionConfigProperty(MissionName, "SafeHouseTimeTillNextUse")) > playerSafeHouse) then
					if DecorGetInt(GetPlayerPed(-1),"mrpvehsafehousemax") < getMissionConfigProperty(MissionName, "SafeHouseVehiclesMaxClaim") then
						if(IsPedOnFoot(GetPlayerPed(-1))) then 
						
							local pheading =  GetEntityHeading(GetPlayerPed(-1))
							local x = math.cos(math.rad(pheading+90))
							local y = math.sin(math.rad(pheading+90))
							local pcoords = GetEntityCoords(GetPlayerPed(-1))
							RequestModel(0xEEF345EC)
							while not HasModelLoaded(0xEEF345EC)  do
								Wait(1)
							end			
							local rcbandito = CreateVehicle(0xEEF345EC, pcoords.x + x,pcoords.y + y,pcoords.z, pheading, 1, 0)
							if DoesEntityExist(rcbandito) then 
								doVehicleMods("rcbandito",rcbandito,MissionName)
								DecorSetInt(rcbandito,"mrpvehsafehouseowner",GetPlayerServerId(PlayerId()))
								DecorSetInt(rcbandito,"mrpvehsafehouse",121212)
								DecorSetInt(rcbandito,"mrpvehdid",121212)
								local mrpvehsafehousemax =  DecorValueInt(-1,"mrpvehsafehousemax") + 1
								DecorSetInt(GetPlayerPed(-1),"mrpvehsafehousemax",mrpvehsafehousemax)
								mrpvehsafehousemaxG = mrpvehsafehousemax
								playerSafeHouse = GetGameTimer()
								local messageOwner = "You claimed yourself a mission vehicle!~n~Cost is: $"..calcSafeHouseCost(true,true,false,MissionName)
								TriggerEvent("mt:missiontext2", messageOwner,10000)									
							else 
									local messageOwner = "Please try again to deploy a rc remote detonate bomb"
									TriggerEvent("mt:missiontext2", messageOwner,10000)						
							end
						
						end
					
					else
						local messageOwner = "Your available mission vehicles have maxed out!~n~Use a non mission vehicle. Or ride with another"
						TriggerEvent("mt:missiontext2", messageOwner,10000)
					end
				end
				
			else 
				message  = "You may request a rc remote detonate bomb after a mission has started" 		
				TriggerEvent("mt:missiontext2", message, 10000)
			
			end				
		
		end
		
	end
end)


--

AddEventHandler("SpawnBackup", function(input)
   if not GlobalBackup and getMissionConfigProperty(input, "MissionDoBackup") then 
		--print("made it")
		Notify("~h~~g~Backup is on it's way")
		TriggerEvent("mt:missiontext2","~g~Backup is on it's way", 4000)
	
		local modelHash = getMissionConfigProperty(input, "BackupPeds")[math.random(1, #getMissionConfigProperty(input, "BackupPeds"))]
		--print("hey1")
		RequestModel(GetHashKey(modelHash))
		while not HasModelLoaded(GetHashKey(modelHash))  do
			Wait(1)
		end
		--print("hey3")
		local locationdata=GetEntityCoords(GetPlayerPed(-1),true)
		
		if getMissionConfigProperty(input, "BackupPedSpawnAtRoad") then
			--get the first, or second? if first and player is in vehicle, may run over the ped?
			local boolval, npos, pheading = GetNthClosestVehicleNodeWithHeading(locationdata.x,locationdata.y,locationdata.z,1,9,3.0,2.5)
			locationdata = npos
		end 
		
		
		local rHeading = math.random(0, 360) + 0.0
		local theta = (rHeading / 180.0) * 3.14		
		local pcoords = vector3(locationdata.x, locationdata.y, locationdata.z) - vector3(math.cos(theta) *  math.floor(1.0), math.sin(theta) * math.floor( 1.0), 0.0)

		local dx = locationdata.x - pcoords.x
		local dy = locationdata.y - pcoords.y
		rHeading = GetHeadingFromVector_2d(dx, dy)		
		
	    GlobalBackup = CreatePed(2, modelHash, pcoords.x, pcoords.y, pcoords.z,rHeading, true, true)
		
		--print("spawn")
		
		SetEntityHeading(GlobalBackup,rHeading) 
		SetModelAsNoLongerNeeded(modelHash)
		
		SetEntityAsMissionEntity(GlobalBackup,true,true)
		DecorSetInt(GlobalBackup,"mrppedid",9789789878) --high value to not conflict
		DecorSetInt(GlobalBackup,"mrppedsafehouse",GetPlayerServerId(PlayerId()) + 4) 
		--DecorSetInt(GlobalBackup,"mrppeddefendtarget",1)
		SetPedMaxHealth(GlobalBackup, getMissionConfigProperty(input, "BackupPedHealth"))
		SetEntityHealth(GlobalBackup, getMissionConfigProperty(input, "BackupPedHealth"))
		SetPlayerMaxArmour(GlobalBackup,100)
		AddArmourToPed(GlobalBackup, 100)
		SetPedArmour(GlobalBackup, 100)		
		
		SetPedRelationshipGroupHash(GlobalBackup, GetHashKey("PLAYER"))
		SetRelationshipBetweenGroups(5, GetHashKey("HATES_PLAYER"), GetHashKey("PLAYER"))
		SetRelationshipBetweenGroups(5, GetHashKey("PLAYER"), GetHashKey("HATES_PLAYER"))
		SetRelationshipBetweenGroups(0, GetHashKey("PLAYER"), GetHashKey("ISDEFENDTARGET"))
		SetRelationshipBetweenGroups(0, GetHashKey("ISDEFENDTARGET"), GetHashKey("PLAYER"))			
		
		
		SetPedFleeAttributes(GlobalBackup, 0, 0)
		SetPedCombatAttributes(GlobalBackup, 5, true)	
		SetPedCombatAttributes(GlobalBackup, 16, true)
		SetPedCombatAttributes(GlobalBackup, 46, true)
		SetPedCombatAttributes(GlobalBackup, 26, true)
		SetPedCombatAttributes(GlobalBackup, 3, false) --dont leave vehicles
		SetPedCombatAttributes(GlobalBackup, 2, true)
		SetPedCombatAttributes(GlobalBackup, 1, true) --can use vehicles			
		SetPedAlertness(GlobalBackup,3)
		SetPedAccuracy(GlobalBackup,100)
		
		SetPedSeeingRange(GlobalBackup, getMissionConfigProperty(input, "BackupPedSensesDistance"))
		SetPedHearingRange(GlobalBackup, getMissionConfigProperty(input, "BackupPedSensesDistance"))

		SetPedPathAvoidFire(GlobalBackup,  1)
		SetPedPathCanUseLadders(GlobalBackup,1)
		SetPedPathCanDropFromHeight(GlobalBackup, 1)
		SetPedPathCanUseClimbovers(GlobalBackup,1)			
		
		--add these 2 for other peds:
		SetPedCanEvasiveDive(GlobalBackup,1)	
		SetPedCanPeekInCover(GlobalBackup,1)
		
		local BackupPedFee = getMissionConfigProperty(input, "BackupPedFee")
 		
		if GlobalBackupIndex == 0 then 
			getBackupSafeHousePickups(input)
			getBackupSafeHouseComponents(input)
		else 
			local v = getMissionConfigProperty(input, "BackupPedHeavyMunitions")[GlobalBackupIndex]
			GiveWeaponToPed(GlobalBackup, GetHashKey(v), 1000, false)
			SetPedInfiniteAmmo(GlobalBackup, true, GetHashKey(v))
			BackupPedFee = getMissionConfigProperty(input, "BackupPedHeavyMunitionsCost")[GlobalBackupIndex]
		end
		
		--default in game is 40 rounds for explosive heavy sniper rounds. Alter this for some balance:
		SetPedAmmoByType(GlobalBackup, 0xADD16CB9, getMissionConfigProperty(input, "SafeHouseSniperExplosiveRoundsGiven"))	

		SetAiWeaponDamageModifier(1.0) 
		--full auto:
		SetPedFiringPattern(GlobalBackup, 0xC6EE6B4C)
		--buff up:
		SetPedDiesWhenInjured(GlobalBackup, false)
		SetPedSuffersCriticalHits(GlobalBackup, 0) 
		
		local ambientVoiceName = getMissionConfigProperty(input, "BackupVoiceName")
		--GHK Add blackops preferred variations
		math.randomseed(GetGameTimer())
		if IsPedModel(GlobalBackup, "s_m_y_blackops_01") then 
			--add vest
			if math.random(1,4)> 2 then 
				SetPedPropIndex(GlobalBackup, 0, 1, 0, 1)
			end 
			
			if math.random(1,4)> 2 then 
				SetPedPropIndex(GlobalBackup, 1, 0, 0, 1)
			end 			
			
			SetPedComponentVariation(GlobalBackup, 3, 0, 0, 1)
			
			ambientVoiceName="S_M_Y_BLACKOPS_01_WHITE_MINI_01"
			--SetAmbientVoiceName(GlobalBackup, "S_M_Y_BLACKOPS_01_WHITE_MINI_01")
			--print("hey1")
		
		elseif IsPedModel(GlobalBackup, "s_m_y_blackops_02") then 
			SetPedComponentVariation(GlobalBackup, 0, 1, 0, 0)
			SetPedComponentVariation(GlobalBackup, 3, 1, 0, 0)
			if math.random(1,4)> 2 then 
				SetPedPropIndex(GlobalBackup, 0,1,0,1)
			end
			if math.random(1,4)> 2 then 
				SetPedPropIndex(GlobalBackup, 1,0,1,1)
			end
			ambientVoiceName="S_M_Y_BLACKOPS_02_WHITE_MINI_01"
			--SetAmbientVoiceName(GlobalBackup, "S_M_Y_BLACKOPS_02_WHITE_MINI_01")
			--print("hey2")
		elseif IsPedModel(GlobalBackup, "s_m_y_blackops_03") then 
			--add glasses
			SetPedComponentVariation(GlobalBackup, 0, 1, 0, 0)
			if math.random(1,4)> 2 then 
				SetPedComponentVariation(GlobalBackup, 2, 1, 0, 0)
			end 
			if math.random(1,4)> 2 then 
				SetPedPropIndex(GlobalBackup, 1,0,0,1)
			end
			--print("hey3")
			--no _03 voice....so use _02
			ambientVoiceName="S_M_Y_BLACKOPS_02_WHITE_MINI_01"
		--	SetAmbientVoiceName(GlobalBackup, "S_M_Y_BLACKOPS_02_WHITE_MINI_01")
		elseif IsPedModel(GlobalBackup, "s_m_y_swat_01") then 
			SetPedComponentVariation(GlobalBackup, 10, 0, 1, 0)
			ambientVoiceName="S_M_Y_SWAT_01_WHITE_FULL_01"
			--SetAmbientVoiceName(GlobalBackup, "S_M_Y_SWAT_01_WHITE_FULL_01")
			--print("hey4")
		end
		--GHK End blackops preferred variations			
		--print(ambientVoiceName)
		

		--put Backup in a free seat if Playerped is in one.
		if GetVehiclePedIsIn(GetPlayerPed(-1), false ) ~= 0 then PutBackupIntoPlayerVehicle(GetVehiclePedIsIn(GetPlayerPed(-1), false ),input) end
		
			if BackupPedFee > 0 then

					local currentmoney = 0
					local rejuvcost = BackupPedFee
					local totalmoney = 0		
					
					local _,currentmoney = StatGetInt('MP0_WALLET_BALANCE',-1)
					playerMissionMoney =  0 - rejuvcost
					totalmoney =  currentmoney - rejuvcost		
						
					if UseESX then 
						TriggerServerEvent("paytheplayer", totalmoney)
						TriggerServerEvent("UpdateUserMoney", totalmoney)
					else
							--DecorSetInt(GetPlayerPed(-1),"mrpplayermoney",totalmoney)
						DecorSetInt(GetPlayerPed(-1),"mrpplayermoney",DecorGetInt(GetPlayerPed(-1),"mrpplayermoney") + playerMissionMoney)			
						mrpplayermoneyG = DecorGetInt(GetPlayerPed(-1),"mrpplayermoney")			
						StatSetInt('MP0_WALLET_BALANCE',totalmoney, true)
					end	

					Notify("~h~~b~Mission Backup Fee: ~g~$"..BackupPedFee)
					
			end		
				--arm rpgs if the ped has them...
				--AI will not use them
				
				--[[--not going to
				if HasPedGotWeapon(GlobalBackup,GetHashKey("weapon_hominglauncher"),false) then 
					SetCurrentPedWeapon(GlobalBackup,GetHashKey("weapon_hominglauncher"),true)
					print("HEY")
				elseif HasPedGotWeapon(GlobalBackup,GetHashKey("weapon_rpg"),false)  then
					SetCurrentPedWeapon(GlobalBackup,GetHashKey("weapon_rpg"),true)
				--elseif then
					
				else
					SetCurrentPedWeapon(GlobalBackup,GetBestPedWeapon(GlobalBackup,0),true)
				end
				]]--
				--The Ped will switch weapons once fighting, so no point in having the above./\
		SetCurrentPedWeapon(GlobalBackup,GetBestPedWeapon(GlobalBackup,0),true)
		
		--Wait(1000)
		PlaySoundFrontend(-1, "GO", "HUD_MINI_GAME_SOUNDSET", 1)
		Wait(1000)
		TriggerServerEvent("sv:playvoicesound",GetPlayerServerId(PlayerId()) + 4,"mrppedsafehouse", getMissionConfigProperty(input, "BackupVoiceGreet"), ambientVoiceName)
   else 
	--Wait(3500)
   --message that player has used their backup
		Notify("~h~~g~Mission backup is not available")
		TriggerEvent("mt:missiontext2","~g~Mission backup is not available", 4000)
		
   end
   
end)


AddEventHandler("MoveBackupToPlayer", function()
		local locationdata=GetEntityCoords(GetPlayerPed(-1),true)
		local rHeading = math.random(0, 360) + 0.0
		local theta = (rHeading / 180.0) * 3.14		
		
		--local pcoords = vector3(locationdata.x, locationdata.y, locationdata.z) - vector3(math.cos(theta) *  math.floor(1.0), math.sin(theta) * math.floor( 1.0), 0.0)
		local pcoords = GetOffsetFromEntityInWorldCoords( GetPlayerPed(-1), 0, -1.0, 0 )
		--pcoords = locationdata
		--wait a little not to be right on top of the player
		Wait(1000)
		SetEntityCoords(GlobalBackup,pcoords.x,pcoords.y,pcoords.z)
		local dx = locationdata.x - pcoords.x
		local dy = locationdata.y - pcoords.y
		rHeading = GetHeadingFromVector_2d(dx, dy) --+180 face away from player?
		SetEntityHeading(GlobalBackup,rHeading) 		
		--print("teleported")
end)



Citizen.CreateThread(function()
		
	local taskfollow = false
	local taskLeaveVehicle = false
	local taskDied = false
	while true do
		--Wait(0)
		
		if (Active == 1) and  MissionName ~="N/A" and GlobalBackup then
			local input = MissionName
			local playerped = GetPlayerPed(-1)
			local vehicle = GetVehiclePedIsIn(playerped, false )
			local bvehicle = GetVehiclePedIsIn(GlobalBackup, false )
			local pcoords = GetEntityCoords(playerped,true)
			local bcoords = GetEntityCoords(GlobalBackup,true)
			
			
			
			
			Wait(0)
			
			
			if (Active == 1) and  MissionName ~="N/A" and GlobalBackup and IsEntityDead(GlobalBackup) then 
			--ped died
				taskfollow = false
				taskLeaveVehicle = false
				
				--print("backup died")
				if not taskDied then 
					Notify("~h~~r~Your mission backup has died")
					TriggerEvent("mt:missiontext2","~h~~r~Your mission backup has died", 4000)
					TriggerEvent("RemoveBackup")
					taskDied = true
				end
				
				Wait(0)			
			
			elseif vehicle~=0 and vehicle ~= bvehicle then 
				--player is now in vehicle, place GlobalBackup in vehicle as passenger, if a free seat. 
				--ClearPedtasks first?
					--print("not in the same vehicle as the player")
				
				taskLeaveVehicle = false
				taskfollow = false
				taskDied = false
				--print(IsEntityDead(GlobalBackup))
				if Citizen.InvokeNative(0x2D34FC3BC4ADB780,vehicle) and not IsPedRagdoll(GlobalBackup) 
				and not IsPedFatallyInjured(GlobalBackup) and not IsPedProne(GlobalBackup)
				
				then --AreAnyVehicleSeatsFree
					--print(IsPedProne(GlobalBackup))
					PutBackupIntoPlayerVehicle(GetVehiclePedIsIn(playerped, false),input)
				else
					--cannot get in the vehicle, so try and follow
					if not taskfollow then 
						--taskfollow = true
						--TaskGoToEntity below DOES NOT WORK, not sure why...						
						--ClearPedTasksImmediately(GlobalBackup, true)
						
						--TaskGoToEntity(GlobalBackup, playerped, -1, 5.0, 2.0,1073741824, 0)
						
						--TaskGoToCoordAnyMeans(GlobalBackup, pcoords.x,pcoords.y,pcoords.z, 2.0, 0, 0, 786603, 0xbf800000)
						
					end				
				end
			elseif vehicle==0 and vehicle ~= bvehicle  then
				--player not in vehicle, so get out as well, if I am in a vehicle
				--combat attribute of the backup is not to leave vehicle, so hopefully this works,
				--may need to use secon arg as 16
				--print("player not in vehicle, but I am")
				taskfollow = false
				taskDied = false
				--ClearPedtasks first?
				--SetPedCombatAttributes(GlobalBackup, 3, true)
				--SetPedCombatAttributes(GlobalBackup, 1, false)
				--ClearPedTasks(GlobalBackup)
				if not taskLeaveVehicle then 
					--print("task leave vehicle")
					--SetPedCombatAttributes(GlobalBackup, 3, true)
					ClearPedTasksImmediately(GlobalBackup, true)
					TaskLeaveVehicle(GlobalBackup,64)
					--Wait(10000)
					taskLeaveVehicle= true
				end
			--elseif vehicle ~=0 and GetVehiclePedIsIn(playerped, false )~=0 and  GetVehiclePedIsIn(playerped, false ) ~= vehicle then
				--player left old vehicle and is in new one (via teleport probably)... 
				--taskfollow = false
				--print("player switched vehicles")
				--ClearPedtasks first?
				--PutPlayerIntoTargetVehicle(GetVehiclePedIsIn(playerped, false),MissionName)
			
			elseif vehicle==0 and GetDistanceBetweenCoords(bcoords,pcoords,true) >= getMissionConfigProperty(input, "BackupPedTeleportDistance") 
			and not IsPedClimbing(playerped) and not IsPedJumping(playerped)
			and not IsPedRagdoll(playerped) --and not IsPedInParachuteFreeFall(playerped)
			then 
				
				--teleport backup to the player, if player is on foot, and distance > BackupPedTeleportDistance
				taskfollow = false
				taskLeaveVehicle = false
				taskDied = false
				--print("teleport")
				TriggerEvent("MoveBackupToPlayer")

				--print("teleport")
				
			elseif GetDistanceBetweenCoords(pcoords,bcoords,true) >=  getMissionConfigProperty(input, "BackupPedMaxDistance") and bvehicle == 0
			
			and not IsPedShooting(GlobalBackup)
			
			--[[and not IsPedReloading(GlobalBackup) <-- returning 1 all the time, due to infinite ammo?]]--

			and not IsPedGettingIntoAVehicle(GlobalBackup)
			and not IsPedClimbing(GlobalBackup)and not IsPedGoingIntoCover(GlobalBackup) and not IsPedInMeleeCombat(GlobalBackup)
			and not Citizen.InvokeNative(0x26AF0E8E30BD2A2C,GlobalBackup) --[[opening a door]]-- 
			and not IsPedInCover(GlobalBackup,true) 
			
			and not Citizen.InvokeNative(0x6A03BF943D767C93,GlobalBackup) --[[in high cover]]-- 
			
			then 
				--print(">maxdistance and shooting:"..tostring(IsPedShooting(GlobalBackup)))
				--print(">maxdistance and reloaing:"..tostring(IsPedReloading(GlobalBackup)))
				--backup is 100m away from the player, lets have them move closer.
				--ClearPedTasks(GlobalBackup)
				taskLeaveVehicle = false
				taskDied = false
				if not taskfollow then 
					
					taskfollow = true
					TaskGoToEntity(GlobalBackup, playerped, -1, 5.0, 2.0,1073741824, 0)
				end

			
			--[[
			elseif GetDistanceBetweenCoords(pcoords,bcoords,true) < 5 and not GetVehiclePedIsIn(GlobalBackup, false) 
			and not IsPedShooting(GlobalBackup) and not IsPedReloading(GlobalBackup) and not IsPedGettingIntoAVehicle(GlobalBackup)
			and not IsPedClimbing(GlobalBackup)and IsPedGoingIntoCover(GlobalBackup) and not IsPedInMeleeCombat(GlobalBackup)
			and not IsPedOpeningADoor(GlobalBackup) and not IsPedInCover(GlobalBackup,true) and not IsPedInHighCover(GlobalBackup)
			then 
				--lets clear TaskGoToEntity if active. I could not work out what taskid that is for GetIsTaskActive
				--even from this list: https://pastebin.com/2gFqJ3Px
				--may not be needed, since the soon as the ped  sees enemies, task will break.
				ClearPedTasks(GlobalBackup)
							
			]]--
			--end
		

			else 
				taskfollow = false	
				taskLeaveVehicle = false
				taskDied = false				
				--print("other:"..tostring(GetVehiclePedIsIn(GlobalBackup, false)))
				Wait(0)
			end
		else 
			taskfollow = false
			taskLeaveVehicle = false
			taskDied = false
			--print("no mission OR GLOBALBACKUP?")
			Wait(0)
		end
		
	end
	
end)


AddEventHandler("RemoveBackup", function(nowait)
		
		if not GlobalBackup then 
			return
		end
		
		if not nowait then 
			Wait(5000)
		end 
		
		local oldblip = GetBlipFromEntity(GlobalBackup)
		if DoesBlipExist(oldblip) then 
			
			RemoveBlip(GlobalBackup)
		end
			--print("remove")
			DecorRemove(GlobalBackup, "mrppedid")
			DecorRemove(GlobalBackup, "mrppedsafehouse")
			DeleteEntity(GlobalBackup)
			GlobalBackup=nil		

end)


--if in vehicle and want to switch seats with backup
AddEventHandler("SwapSeatWithBackup",function()


		if GlobalBackup and not IsEntityDead(GlobalBackup) then
		
			local playerPed = GetPlayerPed(-1)
			local pveh = GetVehiclePedIsIn(playerPed,false)
			local bveh = GetVehiclePedIsIn(GlobalBackup,false)
			local pseat = -2
			local bseat = -2
			if pveh == bveh and pveh ~= 0 then
				maxseatid = GetVehicleMaxNumberOfPassengers(pveh) - 1
				for v = -1,maxseatid,1 
					do
					
					if GlobalBackup == GetPedInVehicleSeat(pveh,v) then
						bseat = v
					end
					if playerPed == GetPedInVehicleSeat(pveh,v) then
						pseat = v
					end				
					if pseat > -2 and bseat > -2 then
						break
					end
				end
				--swap:
				--if pseat ~= -1 then 
					--SetPedIntoVehicle(playerPed,pveh,bseat)
					--SetPedIntoVehicle(GlobalBackup,pveh,pseat)
					--TaskLeaveVehicle(GlobalBackup, pveh, 16)
					SetEntityCoords(GlobalBackup,0.0,0.0,1000.0)
					
					--TaskLeaveVehicle(GlobalBackup, pveh, 16)
					
					--print("bHEY"..bseat)
					--print("pHEY"..pseat)
					--print("leave vehicle")
					--Wait(500)
					SetPedIntoVehicle(playerPed,pveh,bseat)
					SetPedIntoVehicle(GlobalBackup,pveh,pseat)
					Notify("~h~~g~You swapped seats with your backup") 
				--else 
					--Notify("~h~~r~Cannot swap seats. Your backup can only be a passenger, not a driver") 
				--end
			else 
				if pveh == 0 then
					Notify("~h~~r~To swap a seat with your backup you need to be in a vehicle")
				else 
					Notify("~h~~r~To swap a seat with your backup you need to be in the same vehicle")
				end
			end
		else 
			Notify("~h~~r~No backup to swap a seat with")
		end

end)

--place player into the target's vehicle 
--first look for turrets, then non-turret seatids
--only place if the seatid is free
function PutBackupIntoPlayerVehicle(PedVehicle,input)
	--already in the vehicle
	if PedVehicle == GetVehiclePedIsIn(GlobalBackup,false) then 
		return
	end

	local vcoords = GetEntityCoords(PedVehicle,true)
	local bcoords = GetEntityCoords(GlobalBackup,true)
	local closeenough = (GetDistanceBetweenCoords(bcoords,vcoords,true) < 10)
	
	
	--print("made it")
	local maxseatid = GetVehicleMaxNumberOfPassengers(PedVehicle) - 1
		--print(vehicleHash.."  maxseatid:"..maxseatid)
	local setPed=false
	--get override, like for apc gun, which is not a turret...
	local prefseat = getPreferrableSeatId(input,GetEntityModel(PedVehicle))
	
	if prefseat ~=nil and IsVehicleSeatFree(PedVehicle, prefseat) then
			
			
			if closeenough then 
				TaskEnterVehicle( GlobalBackup, PedVehicle, 20000,prefseat, 1.5, 1, 0)
			else
				SetPedIntoVehicle(GlobalBackup, PedVehicle, prefseat)
			end						
			
			--SetPedIntoVehicle(GlobalBackup, PedVehicle, prefseat)
			
			setPed=true
			--print("prefseat:"..prefseat)
			Wait(3500)
			return 
		
	end
	
		
		for v = 0,maxseatid,1 
		do
			--print("vehicleseatid:"..v)
			--look for turret seats first...IsTurretSeat...
			if  Citizen.InvokeNative(0xE33FFA906CE74880,PedVehicle, v) and IsVehicleSeatFree(PedVehicle, v) then
				
					if closeenough then 
						TaskEnterVehicle( GlobalBackup, PedVehicle, 20000,v, 1.5, 1, 0)
					else
						SetPedIntoVehicle(GlobalBackup, PedVehicle, v)
					end			
				--SetPedIntoVehicle(GlobalBackup, PedVehicle, v)
				setPed=true
			
				Wait(3500)
				return 
			end
			
		end
		
		if not setPed then 
		
			for v = 0,maxseatid,1 
			do
				--print("vehicleseatid:"..v)
			
				if IsVehicleSeatFree(PedVehicle, v) then
					
					if closeenough then 
						TaskEnterVehicle( GlobalBackup, PedVehicle, 20000,v, 1.5, 1, 0)
					else
						SetPedIntoVehicle(GlobalBackup, PedVehicle, v)
					end
					--SetPedIntoVehicle(GlobalBackup, PedVehicle, v)
					setPed=true
				
					Wait(3500)
					return
				end
				
			end		
		
		end
		
		if not setPed then--print
			--Notify("~h~~r~All seats are taken in the target's vehicle")
			--TriggerEvent("mt:missiontext2","~r~All seats are taken in the target's vehicle", 4000)
			--Wait(3500)
		end
		
		
		return setPed


end


function getBackupSafeHousePickups(oldmission)

	local weaponlist = {}
	if Config.Missions[oldmission].SpawnSafeHousePickups ~=nil then
		weaponlist = Config.Missions[oldmission].SpawnSafeHousePickups

	else
		weaponlist = Config.SpawnSafeHousePickups
		
	end 
	giveWeaponsToBackup(weaponlist) 
end

function giveWeaponsToBackup(weaponlist) 
	for i, v in pairs(weaponlist) do
		GiveWeaponToPed(GlobalBackup, GetHashKey(v), 1000, false)
		SetPedInfiniteAmmo(GlobalBackup, true, GetHashKey(v))
	end

end


function getBackupSafeHouseComponents(oldmission)

	local weaponlist = {}
	if Config.Missions[oldmission].SpawnSafeHouseComponents ~=nil then
		weaponlist = Config.Missions[oldmission].SpawnSafeHouseComponents

	else
		weaponlist = Config.SpawnSafeHouseComponents
		
	end 
	giveComponentsToBackup(weaponlist) 
end


function giveComponentsToBackup(weaponlist) 
	
	for i, v in pairs(weaponlist) do
		local component
		local weapon
		for token in string.gmatch(v, "[^%s]+") do
			if(component) then
				weapon=token
			else 
				component=token
			end
		end
		if HasPedGotWeapon(GlobalBackup, GetHashKey(weapon), false) then
			GiveWeaponComponentToPed(GlobalBackup, GetHashKey(weapon), GetHashKey(component))
			
		end
	end

end


Citizen.CreateThread(function()
	local player = GlobalBackup
	local healthtimer = 0
	local armourtimer = 0
	local lastarmour = 0
	local lasthealth = 0
	local lasthealthcheck = 0
	local RegenHealthAndArmour = Config.BackupPedRegen
	--local IsCrackDownMode = Config.SafeHouseCrackDownMode
	--local CrackDownModeHealthAmount = Config.SafeHouseCrackDownModeHealthAmount
	
	local UpgradeMultiplier = 1
	local multiplier = 1
	
	--if IsCrackDownMode then
		UpgradeMultiplier = math.floor(Config.BackupPedHealth/200) --default health is 200
	--else 
		--UpgradeMultiplier = 1 --default health is 200
	--end
	
	
    while true do
		if GlobalBackup and not IsEntityDead(GlobalBackup) then 
			lasthealthcheck = GetEntityHealth(player)
		   --print("pedhealth:"..GetEntityHealth(player))
			Citizen.Wait(150)
			player =  GlobalBackup
			-- if Active == 1 and MissionName ~="N/A" then
				--if playerUpgraded and IsCrackDownMode then 
					 multiplier = UpgradeMultiplier
				--else 
					 --multiplier = 1
				--end
				
				--print("multiplier:"..multiplier)
				--print(string.format("%02d", tostring(math.floor((GetGameTimer())/1000) % 60)))
				--print("regen"..tostring(player))
				
				--print("statement:"..tostring(RegenHealthAndArmour and player and not IsEntityDead(player)))
			
				if RegenHealthAndArmour and player and not IsEntityDead(player) then
				
					--print("timer")
					if GetPedArmour(player) < GetPlayerMaxArmour(player) then
							healthtimer = 0
							--print("armour timer")
							if lastarmour == GetPedArmour(player) then
								if lasthealth == GetEntityHealth(player) then
									armourtimer = armourtimer +3
									if armourtimer > 99 then						--Initial delay before armour starts to regenerate
															
										AddArmourToPed(player, 5*multiplier)			--Armour regen amount. Must be an integer(+1,+2,+3 etc.)
										lastarmour =  GetPedArmour(player)
										armourtimer = 50							--Armour regen rate. 1200 = instant
									end
									else
									lasthealth = GetEntityHealth(player)
									armourtimer = 0
								end
								else
								lastarmour = GetPedArmour(player)
								armourtimer = 0
							end
					else
						
							armourtimer = 0
							if GetEntityHealth(player) < GetEntityMaxHealth(player) then
								--print("pedhealth:"..GetEntityHealth(player))
								--reset timer if injured since last check or busy
								if ((GetEntityHealth(player) < lasthealthcheck)  or IsPedShooting(player) or IsPedInMeleeCombat(player) or
							IsPedRagdoll(player) or IsPedSwimmingUnderWater(player) or IsEntityOnFire(player) or
							IsEntityInAir(player) or IsPedRunning(player) or IsPedSprinting(player)) then
									healthtimer =  0
										
								else
									healthtimer = healthtimer + 5 --+10
									
								end
								if healthtimer > 99 then							--Health regen rate
											--print("made it:"..GetEntityHealth(player)+5*multiplier)
									SetEntityHealth(player, GetEntityHealth(player)+5*multiplier)	--Health regen amount. Must be an integer
									healthtimer = 50 --0
								end
							else
								ClearPedBloodDamage(player)
								healthtimer = 0
							end
					end		
				
				end
			--end
			
		else
			
		
			
			Wait(150)
		end
    end
end) 







AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then

     --  print("RESOURCE: crate drop stopped")

        SetEntityAsMissionEntity(pilot, false, true)
        DeleteEntity(pilot)
        SetEntityAsMissionEntity(aircraft, false, true)
        DeleteEntity(aircraft)
        DeleteEntity(parachute)
        DeleteEntity(crate)
		SetEntityCoords(pickup, -10000.647, -10000.97, 0.7186, 0.968)
		SetEntityAsNoLongerNeeded(pickup)
		RemovePickup(pickup)
		DeleteObject(pickup)				
        RemoveBlip(blip)
        StopSound(soundID)
        ReleaseSoundId(soundID)

        for i = 1, #requiredModels do
            Wait(0)
            SetModelAsNoLongerNeeded(GetHashKey(requiredModels[i]))
        end

    end
end)


--SCALEFORM FUNCTIONS: 
--CREDITS: Illusivee
-- https://github.com/Illusivee/scaleform-wrapper/tree/master/scaleforms

Scaleform = {}

local scaleform = {}
scaleform.__index = scaleform

function Scaleform.Request(Name)
	local ScaleformHandle = Citizen.InvokeNative( 0x11FE353CF9733E6F,Name) --RequestScaleformMovie(Name)
	local StartTime = GetGameTimer()
	while not Citizen.InvokeNative( 0x85F01B8D5B90570E,ScaleformHandle) do Citizen.Wait(0) 
		if GetGameTimer() - StartTime >= 5000 then
			print("loading failed")
			return
		end 
	end
	--print("Loaded")
	local data = {name = Name, handle = ScaleformHandle}
	return setmetatable(data, scaleform)
end

function Scaleform.RequestHud(id)
	local ScaleformHandle = Citizen.InvokeNative( 0x9304881D6F6537EA,id)
	local StartTime = GetGameTimer()
	while not Citizen.InvokeNative( 0xDF6E5987D2B4D140,ScaleformHandle) do 
		Citizen.Wait(0) 
		if GetGameTimer() - StartTime >= 5000 then
			print("loading failed")
			return
		end
	end
	--print("Loaded")
	local data = {Name = id, handle = ScaleformHandle}
	return setmetatable(data, scaleform)
end

function scaleform:CallScaleFunction(scType, theFunction, ...)
	if scType == "hud" then
		Citizen.InvokeNative( 0x98C494FD5BDFBFD5,self.handle, theFunction)
	elseif scType == "normal" then
		Citizen.InvokeNative(0xF6E48914C7A8694E,self.handle, theFunction)
	end
    local arg = {...}

    if arg ~= nil then
        for i=1,#arg do
            local sType = type(arg[i])
            if sType == "boolean" then
               Citizen.InvokeNative(0xC58424BA936EB458,arg[i])
			elseif sType == "number" then
				if math.type(arg[i]) == "integer" then
					--PushScaleformMovieMethodParameterInt(arg[i])
					--print("hey:"..arg[i])
					Citizen.InvokeNative(0xC3D0841A0CC546A6,arg[i])
				else
					 Citizen.InvokeNative(0xD69736AAE04DB51A,arg[i])
				end
            elseif sType == "string" then
                --PushScaleformMovieMethodParameterString(arg[i])
					Citizen.InvokeNative( 0xBA7148484BD90365,arg[i])
            else
                Citizen.InvokeNative(0xC3D0841A0CC546A6)
            end
		end
	end
	return   Citizen.InvokeNative(0xC6796A8FFA375E53)
end

function scaleform:CallHudFunction(theFunction, ...)
    self:CallScaleFunction("hud", theFunction, ...)
end

function scaleform:CallFunction(theFunction, ...)
    self:CallScaleFunction("normal", theFunction, ...)
end

function scaleform:Draw2D()
	 Citizen.InvokeNative(0x0DF606929C105BE1,self.handle, 255, 255, 255, 255)
end

function scaleform:Draw2DNormal(x, y, width, height)
	 Citizen.InvokeNative(0x54972ADAF0294A93,self.handle, x, y, width, height, 255, 255, 255, 255)
end

function scaleform:Draw2DScreenSpace(locx, locy, sizex, sizey)
	local Width, Height = GetScreenResolution()
	local x = locy / Width
	local y = locx / Height
	local width = sizex / Width
	local height = sizey / Height
	 Citizen.InvokeNative(0x54972ADAF0294A93,self.handle, x + (width / 2.0), y + (height / 2.0), width, height, 255, 255, 255, 255)
end

function scaleform:Render3D(x, y, z, rx, ry, rz, scalex, scaley, scalez)
	 Citizen.InvokeNative(0x1CE592FDC749D6F5,self.handle, x, y, z, rx, ry, rz, 2.0, 2.0, 1.0, scalex, scaley, scalez, 2)
end

function scaleform:Render3DAdditive(x, y, z, rx, ry, rz, scalex, scaley, scalez)
	 Citizen.InvokeNative(0x87D51D72255D4E78,self.handle, x, y, z, rx, ry, rz, 2.0, 2.0, 1.0, scalex, scaley, scalez, 2)
end

function scaleform:Dispose()
	 SetScaleformMovieAsNoLongerNeeded(self.handle)
	self = nil
end

function scaleform:IsValid()
	return self and true or false
end

MISSIONSHOWRESULT = false
BLDIDTIMEOUT = false
MISSIONSHOWTEXT=""
MISSIONSHOWMESSAGE=""
MISSIONSHAREMONEYAMOUNT=nil

Citizen.CreateThread(function()
	  -- Citizen.Wait(1000)
    local s
	local s2
   while true do
		--print("hey")
        Citizen.Wait(0)
		if MISSIONSHOWRESULT then
			
			if s == nil then 
			

				if string.len(MISSIONSHOWTEXT) > 0 and MISSIONSHOWTEXT ~="WASTED" then
				-- print("hey")
					local starttime= GetGameTimer()
					while not MISSIONSHAREMONEYAMOUNT do
						Wait(1)
						
						if GetGameTimer() - starttime >= 1000 then
							--print("break")
							break
						end
						
					end
					MISSIONSHOWMESSAGE = MISSIONSHOWMESSAGE .. MISSIONSHAREMONEYAMOUNT	
					MISSIONSHAREMONEYAMOUNT=nil
				end
				
					
				
				
				--print("hey3")
				s = Scaleform.Request("mp_big_message_freemode")
				s:CallScaleFunction("normal","SHOW_SHARD_WASTED_MP_MESSAGE", MISSIONSHOWTEXT, MISSIONSHOWMESSAGE, 5)	
				
				--USING THIS FOR COOL SOUNDS ONLY ATM: 
				s2 = Scaleform.Request("mp_celebration")
				s2:CallScaleFunction("normal","CLEANUP","MR")
				s2:CallScaleFunction("normal","CREATE_STAT_WALL","MR","HUD_COLOR_BLACK")
				s2:CallScaleFunction("normal","SET_PAUSE_DURATION",5)
				s2:CallScaleFunction("normal","ADD_MISSION_RESULT_TO_WALL", "MR","TEST MISSION","Mission Passed","DID WELL",
				true,true,true,0,"HUD_COLOR_GREEN")
				s2:CallScaleFunction("normal","ADD_BACKGROUND_TO_WALL","MR",75,1)
				s2:CallScaleFunction("normal","SHOW_STAT_WALL","MR")
				
			end
			s:Draw2D()
			s2:Draw2D()
			if not BLDIDTIMEOUT then
				
				BLDIDTIMEOUT = true
				SetTimeout(5000,function()MISSIONSHOWRESULT = false;end)
			end
		else
			if s then 
				s:Dispose()
				s=nil
				s2:Dispose()
				s2=nil
			end
		
		end
   end
end)

--END SCALEFORM FUNCTIONS

--weather/time 
--[[
Citizen.CreateThread(function()
    while true do
		SetWeatherTypePersist("EXTRASUNNY")
        	SetWeatherTypeNowPersist("EXTRASUNNY")
       		SetWeatherTypeNow("EXTRASUNNY")
       		SetOverrideWeather("EXTRASUNNY")
    		Citizen.Wait(1)
	end
end)

Citizen.CreateThread(function()
    while true do
        Wait(1)
        NetworkOverrideClockTime(12, 1, 1)
    end
end)

]]--
