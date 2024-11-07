local ActiveMission=false
local MissionName="N/A"

local MissionType = ""
local IsRandomSpawnAnywhereInfo = {x=0,y=0,z=0}
local SafeHouseLocationIndex = 0
local MissionLocationIndex = 0
local MissionDestinationIndex = 0



local servercheckspawns = false

local MissionTriggered = false

--for mission timeouts
local MissionStartTime = 0
local MissionEndTime = 0
local MissionSpaceTime = 0
local MilliSecondsLeft = 0
local MissionNoTimeout = false
--used to see if we are in the time between missions, when one ends, and another starts
local blInSpaceTime = false 

--local variable used to keep track of when the server should send another mission based on 
--ExtraTimeToWaitToStartNextMission value
local blMadeIt = false

--used with NextMission and NextMissionIfFailed values if set
--if ProgressToNextMissionIfFail
local blFailedMission = false

--This is in minutes. How long to wait, when there are players online 
--for the server to find the host and trigger a new mission
local ExtraTimeToWaitToStartNextMission = 2

--Set this to true in case there are mutiple missions being started
--or duplicate NPC peds. 
--Experimental.
local blActiveMissionCheck=false

--The time between missions, is where the player who will trigger the next mission 
--can disconnect. Enable this value to true if you find the missions 
--stopping when this happens. Players or admins can use /mission Mission1 etc... though to start
--if this is turned off and it happens
--Experimental
local blHelpWithDisconnects=false

--Used for Type="HostageRescue" when IsRandom=true
local IsRandomMissionHostageCount = 0
local IsRandomMissionHostageRescued= 0

local IsRandomDoEvent = false
local IsRandomDoEventRadius = 1000.0
local IsRandomDoEventType = 0


--ESX Support
local UseESX=false
if UseESX then
	TriggerEvent("esx:getSharedObject", function(obj)
	ESX = obj
	end)

	RegisterServerEvent("paytheplayer")
	AddEventHandler("paytheplayer",function(totalmoney)

	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	--xPlayer.addMoney(totalmoney)
	--FIX courtesy of HMB_Frost:
	if (totalmoney >= 0) then
		xPlayer.addMoney(totalmoney)
	else
		xPlayer.removeMoney(totalmoney * -1)
	end	

	end)

end

--players share money?
--local sharedmoney = 0
RegisterServerEvent("sharemoney")
AddEventHandler("sharemoney",function(playermissionmoney)
--print("sharemoney called:"..playermissionmoney)
	TriggerClientEvent("mt:sharemoney",-1, playermissionmoney)
	
end)

RegisterServerEvent("sv:repairvehicle")
AddEventHandler("sv:repairvehicle",function()
	
	TriggerClientEvent("mt:doRepairVehicle",-1)
	
end)

RegisterServerEvent("sv:repairtarget")
AddEventHandler("sv:repairtarget",function(MissionName)
	TriggerClientEvent("mt:doRepairTarget",-1,MissionName)
	
end)

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

--used to tell all clients that an indoor spawn location has been used
RegisterServerEvent("sv:spawned")
AddEventHandler("sv:spawned", function(input,i,isVehicle)
	--print("Mission spawned called"..i.." isVehicle:"..tostring(isVehicle))
	if isVehicle then 
		Config.Missions[input].Vehicles[i].spawned = true
	else 
		Config.Missions[input].Peds[i].spawned = true
	end
	TriggerClientEvent("mt:spawned",-1, input,i,isVehicle)
	
end)

RegisterServerEvent("sv:playvoicesound")
AddEventHandler("sv:playvoicesound", function(decorid,decorval,greetspeech,voicename)
	
	--print(decorid..decorval..greetspeech..voicename)
	TriggerClientEvent("mt:playvoicesound",-1, decorid, decorval,greetspeech,voicename)

end)

RegisterServerEvent("sv:setgroundingdecor")
AddEventHandler("sv:setgroundingdecor", function(decorid,decorval)
	
	--print(decorid..decorval..greetspeech..voicename)
	TriggerClientEvent("mt:setgroundingdecor",-1, decorid, decorval)

end)


RegisterServerEvent("sv:generateCheckpointsAndEvents")
AddEventHandler("sv:generateCheckpointsAndEvents", function(MissionName,recordedCheckpoints,Events,startCoords)
	--print("chk3")
	--if Events then 
		--print(#Events)
		--else
		--print("no events found!")
	--end 
	TriggerClientEvent("mt:generateCheckpointsAndEvents",-1, MissionName,recordedCheckpoints,Events)
	--trigger StreetRaces createrace event
	
	--print(#recordedCheckpoints)
	--local startCoords = recordedCheckpoints[1].coords
	--print(startCoords.x)
	if Config.Missions[MissionName].Type=="Checkpoint" and Config.Missions[MissionName].IsRandom then 
	--print("made it sv ")
		TriggerEvent("mrpStreetRaces:createRace_sv",1, 300000, startCoords, recordedCheckpoints, 360000)
		--print("made it sv2 ")
		Config.Missions[MissionName].TotalCheckpoints=#recordedCheckpoints
		
		Config.Missions[MissionName].CheckpointsStartPos=startCoords
		
		Config.Missions[MissionName].RecordedCheckpoints=recordedCheckpoints
	end	
	
	--used for saving which player completed which checkpoint first
	Config.Missions[MissionName].Checkpoints={}
	--print("chk4")
	Config.Missions[MissionName].Events=Events

end)

--make global
local checkpointdata

RegisterServerEvent("sv:updatePlayerCheckpoints")
AddEventHandler("sv:updatePlayerCheckpoints", function(MissionName,checkpointnum,PlayerServerId)
	--print("chk"..checkpointnum)
	
	--dont care about start of race
	if checkpointnum == 0 then
		--print("chkreturn"..checkpointnum)
		return
	end
	local claimedcheckpoint = {checkpointnum=checkpointnum,PlayerServerId=PlayerServerId}
	
	checkpointdata = Config.Missions[MissionName].Checkpoints
	local checkpointclaimed = false
	for i = 1,#checkpointdata do
	
		if ( checkpointdata[i] and checkpointdata[i].checkpointnum and checkpointdata[i].checkpointnum ==checkpointnum) then
			checkpointclaimed = true
			break; --checkpoint already claimed by a player. 
		
		end
	end
	
	if checkpointclaimed == false then
		--print("checkpoint claimed")
		table.insert(checkpointdata,claimedcheckpoint)
		local messagestr = "~h~~r~"..GetPlayerName(source).."~y~ has claimed checkpoint "..checkpointnum.. " and earned ~g~$"..getMissionConfigProperty(MissionName, "CheckPointClaimdReward")
		TriggerClientEvent("mt:missiontext2",-1,messagestr,5000)
		TriggerClientEvent("mt:rewardPassengers",-1,PlayerServerId)
		
	end 
	Config.Missions[MissionName].Checkpoints=checkpointdata
	
end)





RegisterServerEvent("sv:one")
AddEventHandler("sv:one", function(input,input2, timet,rMissionLocationIndex,rMissionType,rIsRandomSpawnAnywhereInfo,rSafeHouseLocationIndex,rMissionDestinationIndex)
	print("sv:one called to start new mission")
	if blActiveMissionCheck then 
		if(not ActiveMission) then 
			TriggerClientEvent('chatMessage', -1, "^1[MISSIONS]: ^2'".. input2 .."'^0 has been launched. Mission Name is: ^2'"..input.."'^0")
			--TriggerClientEvent("mt:missiontext", -1, input, timet)
			TriggerClientEvent('missionBlips', -1, input,rMissionLocationIndex,rMissionType,rIsRandomSpawnAnywhereInfo,rSafeHouseLocationIndex,true,rMissionDestinationIndex)
			TriggerClientEvent("SpawnPedBlips",-1, input)
			ActiveMission=true
			MissionName=input
			MissionType = rMissionType
			MissionLocationIndex = rMissionLocationIndex
			MissionDestinationIndex = rMissionDestinationIndex
			IsRandomSpawnAnywhereInfo = rIsRandomSpawnAnywhereInfo
			SafeHouseLocationIndex = rSafeHouseLocationIndex
			blInSpaceTime = false
			MissionStartTime = GetGameTimer() 
			MissionEndTime = MissionStartTime + getMissionConfigProperty(MissionName, "MissionLengthMinutes")*60*1000	
			MissionSpaceTime = getMissionConfigProperty(MissionName, "MissionSpaceTime")
			MilliSecondsLeft = MissionEndTime - MissionStartTime
			MissionNoTimeout = getMissionConfigProperty(MissionName, "MissionNoTimeout")
			blMadeIt = false
			blFailedMission=false

		end
		
	else 
		--print("rMissionType:"..rMissionType)
		--print("rMissionLocationIndex:"..rMissionLocationIndex)
		
					TriggerClientEvent('chatMessage', -1, "^1[MISSIONS]: ^2'".. input2 .."'^0 has been launched. Mission Name is: ^2'"..input.."'^0")
		
		TriggerClientEvent("mt:missiontext", -1, input, timet)
		--print("sv:one rSafeHouseLocationIndex"..rSafeHouseLocationIndex)
		--if(rSafeHouseLocationIndex) then
		--	print("sv:one rSafeHouseLocationIndex found:"..rSafeHouseLocationIndex)
		--else
		--	print("sv:one rSafeHouseLocationIndex not found:")
		--end
		--print("sv:one rIsRandomSpawnAnywhereInfo.x found:".. rIsRandomSpawnAnywhereInfo.x)
		--print("hey:"..timet)
		TriggerClientEvent('missionBlips', -1, input,rMissionLocationIndex,rMissionType,rIsRandomSpawnAnywhereInfo,rSafeHouseLocationIndex,true,rMissionDestinationIndex) 
		
		TriggerClientEvent("SpawnPedBlips",-1, input)
		

		
		ActiveMission=true
		MissionName=input
		MissionType = rMissionType
		MissionLocationIndex = rMissionLocationIndex
		MissionDestinationIndex = rMissionDestinationIndex
		IsRandomSpawnAnywhereInfo = rIsRandomSpawnAnywhereInfo
		SafeHouseLocationIndex = rSafeHouseLocationIndex		
		blInSpaceTime = false
		MissionStartTime = GetGameTimer() 
		MissionEndTime = MissionStartTime + getMissionConfigProperty(MissionName, "MissionLengthMinutes")*60*1000
		MissionSpaceTime = getMissionConfigProperty(MissionName, "MissionSpaceTime")
		MilliSecondsLeft = MissionEndTime - MissionStartTime
		MissionNoTimeout = getMissionConfigProperty(MissionName, "MissionNoTimeout")
		blMadeIt = false
		blFailedMission=false
		--used for saving which player completed which checkpoint first
		Config.Missions[MissionName].Checkpoints={}
	end 
	
	
end)


--move this to bottom of file:
function doPlayersExist()
	local players = GetNumPlayerIndices() 
	local foundplayer = false
	for i = 0, players - 1 do
		if type(GetPlayerFromIndex(i))  ~=  "nil" then 
			foundplayer = true
		end		
	end
	--print("found player:"..tostring(foundplayer))
	--[[
	if not foundplayer then 
		ActiveMission=false
		--MissionName="N/A" --< **Leave the mission as is, so the missions will rotate**
		servercheckspawns = false
		blInSpaceTime = false
		IsRandomMissionHostageCount = 0
		IsRandomMissionHostageRescued = 0
		IsRandomDoEvent = false
		IsRandomDoEventRadius = 1000.0
		IsRandomDoEventType = 0
		if MissionName~="N/A" then 
			ResetIndoorSpawns (MissionName)	
		end
	end
	]]--
	
	return foundplayer

end

--used to determine what missions are left to use
--to stop repetition:
local randomMissionBucket={}
function getIndex(tab, val)
    local index = nil
    for i, v in ipairs (tab) do 
        if (v == val) then
          index = i 
        end
    end
    return index
end

function getNextMission(MissionName,InitRandom) 
	local missioncount = 0
	local nextmission = ""
	
	if #randomMissionBucket ==0 then 
		for i, v in pairs(Config.Missions) do
			table.insert(randomMissionBucket, i)
			
			
		end
	
		--print("randomMissionBucke[1]:"..randomMissionBucket[1])
	end
	
	
	
	if MissionName ~= "N/A" then 
	
		for i, v in pairs(Config.Missions) do
			missioncount = missioncount + 1
		end

		if Config.RandomMissions then
		
		
		--	math.randomseed(GetGameTimer())
		--	local randomNum = math.random(1,missioncount)
		--nextmission = "Mission"..tostring(randomNum)
			
				--get nextmission from bucket and then
				--remove the old mission from it, only if we are 
				--passed initializing: not InitRandom=true
				local rndMissionIndex = math.random(1,#randomMissionBucket)
				local rndMission = randomMissionBucket[rndMissionIndex]
			
				local OldMissionIndex = getIndex(randomMissionBucket, MissionName)
			
				nextmission = rndMission
			
			
				--print("rndMission:"..tostring(rndMission))
				--print("OldMissionIndex:"..tostring(OldMissionIndex))
			
				if OldMissionIndex and not InitRandom then 
					table.remove(randomMissionBucket, OldMissionIndex) 
					--print("randomMissionBucket len:"..#randomMissionBucket)
				end			
			
			
		else 
			local oldMissionNumber, _ = MissionName:gsub("%D+", "")
			if (tonumber(oldMissionNumber) + 1 > missioncount) then 
				nextmission = "Mission1"
			 else
				nextmission =  "Mission" .. tostring(math.floor((tonumber(oldMissionNumber))) + 1)
			
			end
		end 
		
		--dont let old random mission re-spawn
		if missioncount > 1 then 
			
			while( nextmission == MissionName )
			do
			   nextmission = "Mission"..tostring( math.random(1,missioncount))
			end
		else 
			nextmission = oldmission 
		end
		
		--override if MissionName mission has a NextMission attribute:
		--to allow joined missions
		if getMissionConfigProperty(MissionName, "NextMission") then
			
			if getMissionConfigProperty(MissionName, "ProgressToNextMissionIfFail") then 
				nextmission = getMissionConfigProperty(MissionName, "NextMission")
			elseif not blFailedMission then 
				nextmission = getMissionConfigProperty(MissionName, "NextMission")
			end
		end 
		
		if getMissionConfigProperty(MissionName, "NextMissionIfFailed") and blFailedMission then 
			
			if not (getMissionConfigProperty(MissionName, "NextMission") and 
				getMissionConfigProperty(MissionName, "ProgressToNextMissionIfFail")) then
				nextmission = getMissionConfigProperty(MissionName, "NextMissionIfFailed")
			end
		
		end 
	else 
		if Config.RandomMissions then
			nextmission = getNextMission("Mission1",true) --"Mission1"
		else
			nextmission = "Mission1"
		end
	end
	--print("nextmission:"..nextmission)
	

	
	return nextmission

end

Citizen.CreateThread(function()
	local starttick = GetGameTimer()
	local lastActiveMissionTime = starttick
	
	local TimeLeft = GetGameTimer()
	while true do
	
		--Citizen.Wait(60000) -- check minute
		Citizen.Wait(1000) 
		local tick = GetGameTimer()
		--MissionTime = -1, turn off timed mission checks
		if ActiveMission then 
			
			lastActiveMissionTime = tick
			
			MilliSecondsLeft = MissionEndTime - lastActiveMissionTime
		
			if tick >  MissionEndTime and (not MissionNoTimeout) then 
				--send client event to fail the current mission
				--TriggerClientEvent('DONE', -1, input,false,true,"Mission Timeout") 
				--print('MISSION TIMEOUT')
				TriggerClientEvent('mt:setmissionTimeout', -1,true)
			else 
				--send minutes left to clients
				--print("MissionStartTime:"..MissionStartTime)
				--local currmissionminutesleft = math.floor((MilliSecondsLeft)/60000) % 60
				--local currmissionsecondsleft = math.floor((MilliSecondsLeft)/1000) % 60
				--local extraseconds = currmissionsecondsleft - currmissionminutesleft*60
				local currmissionminutesleft = string.format("%02d", tostring(math.floor((MilliSecondsLeft)/60000) % 60))
				local currmissionsecondsleft = string.format("%02d", tostring(math.floor((MilliSecondsLeft)/1000) % 60))
				--print ("currmissionMilliSecondsLeft:"..MilliSecondsLeft)
				--print("currmissionminutesleft:"..currmissionminutesleft)
				--print("currmissionsecondsleft:"..currmissionsecondsleft)

				
				--TriggerClientEvent('mt:setmissiontimeleft', -1, MilliSecondsLeft) 
				
			end
			
		
		end 
		
		--check if we are not in space between missions or an active mission, 
		--and there are active players, and the extra time waited beyond the end of the last mission + spacetime has occured.
		--this code is for when the mission system first starts up:
		--if (MissionEndTime == 0 and  MissionSpaceTime == 0) then 
			--MissionEndTime = tick
		--end

		
		
		
		if (not ActiveMission and not blInSpaceTime and not blMadeIt) then 
			if (((MissionEndTime + MissionSpaceTime) + ExtraTimeToWaitToStartNextMission*60*1000))- tick > ExtraTimeToWaitToStartNextMission*60*1000 then
				TimeLeft = tick + ExtraTimeToWaitToStartNextMission*60*1000
				blMadeIt = true
				--print("h1")
			end
		elseif not blMadeIt then
			TimeLeft = ((MissionEndTime + MissionSpaceTime) + ExtraTimeToWaitToStartNextMission*60*1000)
			blMadeIt = true
			--print("h2")
		end

		--print("SERVER:Next time to send a mission:"..(TimeLeft - tick))		
		
		if (not ActiveMission and not blInSpaceTime and ((tick) >= TimeLeft)) and doPlayersExist() then
				
				Wait(10000)
				
				if not ActiveMission then 
					print("Server Start Mission")
					TriggerClientEvent("mt:checkIfIAmHost", -1)
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


--used for joining client for IsRandom HostageRescue mission
RegisterServerEvent("sv:UpdateisHostageRescueCount")
AddEventHandler("sv:UpdateisHostageRescueCount", function()
	--print("remaininHostageRescued"..(IsRandomMissionHostageCount - IsRandomMissionHostageRescued))
	TriggerClientEvent('mt:UpdateisHostageRescueCount', source, (IsRandomMissionHostageCount - IsRandomMissionHostageRescued))
	
end)

--setting decor values on NPCs on non-host clients do not seem to propogate
--like when on the host, so when non-host changes a value on an 
--NPC make sure everyone does it, most importantly the host as well
--ALSO USED FOR OBJECTIVE RESCUE MISSIONS:
RegisterServerEvent("sv:rescuehostage")
AddEventHandler("sv:rescuehostage", function(hostageid,decorval)
	--print("sv:rescuehostage:"..hostageid)
	
	TriggerClientEvent('mt:rescuehostage', -1, hostageid,decorval)
	
	if(Config.Missions[MissionName].Type=="HostageRescue" and not Config.Missions[MissionName].IsRandom and decorval=="mrppedfriend") then 
		Config.Missions[MissionName].Peds[hostageid].rescued=true
		
		local isHostageRescueCount = 0
		for i, v in pairs(Config.Missions[MissionName].Peds) do
			if Config.Missions[MissionName].Peds[i].friendly and not Config.Missions[MissionName].Peds[i].dead and not Config.Missions[MissionName].Peds[i].rescued then 
				isHostageRescueCount = isHostageRescueCount + 1
			end
		end
		
		TriggerClientEvent('mt:UpdateisHostageRescueCount', -1, isHostageRescueCount)
	end
	
	if(Config.Missions[MissionName].Type=="ObjectiveRescue" and not Config.Missions[MissionName].IsRandom and decorval=="mrpproprescue") then 
		Config.Missions[MissionName].Props[hostageid].rescued=true
		
		--now count up remaining isObective props left to rescue
		local isObjectiveRescueCount = 0
		for i, v in pairs(Config.Missions[MissionName].Props) do
			if Config.Missions[MissionName].Props[i].isObjective and not Config.Missions[MissionName].Props[i].rescued then 
				isObjectiveRescueCount = isObjectiveRescueCount + 1
			end
		end
		TriggerClientEvent('mt:UpdateisObectiveRescueCount', -1, isObjectiveRescueCount)
		
	end
 	if MissionType=="HostageRescue" and Config.Missions[MissionName].IsRandom then 
		IsRandomMissionHostageRescued = IsRandomMissionHostageRescued + 1
		--print((IsRandomMissionHostageCount - IsRandomMissionHostageRescued))
		TriggerClientEvent('mt:UpdateisHostageRescueCount', -1, (IsRandomMissionHostageCount - IsRandomMissionHostageRescued))
		if IsRandomMissionHostageRescued == IsRandomMissionHostageCount then 
			TriggerClientEvent('mt:IsRandomMissionAllHostagesRescued', -1, true)
		end
	end

	
end)

RegisterServerEvent("sv:two")
AddEventHandler("sv:two", function(message)
    TriggerClientEvent('chatMessage', -1, message)
	
end)

RegisterServerEvent("sv:message")
AddEventHandler("sv:message", function(message)
    TriggerClientEvent("mt:missiontext2", -1, message, 10000)
	
end)

RegisterServerEvent("sv:messagetosource")
AddEventHandler("sv:messagetosource", function(message)
    TriggerClientEvent("mt:missiontext2", source, message, 10000)
	
end)

--called by the/a client at mission end when completed
--for server to find the NetworkIsHost() to start the next mission
RegisterServerEvent("sv:getHostForNextMission")
AddEventHandler("sv:getHostForNextMission", function(input)
	print('sv:getHostForNextMission called')
   TriggerClientEvent("mt:checkIfIAmHost", -1)
	
end)

--capture replies from mt:checkIfIAmHost in order to find the host
--to spawn the NPCs and vehicles on, who will start the mission
RegisterServerEvent("sv:getClientWhoIsHostAndStartNextMission")
AddEventHandler("sv:getClientWhoIsHostAndStartNextMission", function(isHost,newMission)
  
  --print("made it")
  local nextmission = getNextMission(MissionName)
  if newMission then 
    --TEST 
	--print("newMission" ..newMission)
	nextmission = newMission
  end
  
  print("sv:getClientWhoIsHostAndStartNextMission called")
  if(isHost) then 
		print("found Host:"..source)
			print("next mission:"..nextmission)
		--triggerclient event to start next mission
		TriggerClientEvent("mt:startnextmission", source,nextmission)
   end
	
end)

--called by a client, to set Events as done on clients so they do not have to do them
--for Type="HostageRescue" missions
RegisterServerEvent("sv:UpdateEvents")
AddEventHandler("sv:UpdateEvents", function(k,PlayerServerId)
 --print("event called"..k)
 --print("length:"..#Config.Missions[MissionName].Events)
	Config.Missions[MissionName].Events[k].done=true
   TriggerClientEvent('mt:UpdateEvents',-1,k,PlayerServerId,MissionName)
  
	
end)



--called by a client, to set Events as done on clients so they do not have to do them
--for Type="HostageRescue" missions
RegisterServerEvent("sv:IsRandomDoEvent")
AddEventHandler("sv:IsRandomDoEvent", function(clIsRandomDoEvent,clIsRandomDoEventRadius,clIsRandomDoEventType)
 --print("IsRandomDoEvent called:"..clIsRandomDoEventType)
	IsRandomDoEvent = clIsRandomDoEvent
	IsRandomDoEventRadius = clIsRandomDoEventRadius
	IsRandomDoEventType = clIsRandomDoEventType
   TriggerClientEvent('mt:IsRandomDoEvent',-1,IsRandomDoEvent,IsRandomDoEventRadius,IsRandomDoEventType)
  
	
end)

--called by host, to set IsRandomMissionHostageCount
--for Type="HostageRescue" missions
RegisterServerEvent("sv:IsRandomMissionHostageCount")
AddEventHandler("sv:IsRandomMissionHostageCount", function(clIsRandomMissionHostageCount)
   -- TriggerClientEvent("mt:IsRandomMissionHostageCount", -1, IsRandomMissionHostageCount)
   IsRandomMissionHostageCount = clIsRandomMissionHostageCount
   
   TriggerClientEvent('mt:UpdateisHostageRescueCount',-1,IsRandomMissionHostageCount)
  
 --print("IsRandomMissionHostageCount:"..IsRandomMissionHostageCount)
	
end)


--called by host, to have other clients readjust suspicious spawns
RegisterServerEvent("sv:checkspawns")
AddEventHandler("sv:checkspawns", function(checkspawns)
	servercheckspawns = checkspawns
    TriggerClientEvent("mt:checkspawns", -1, checkspawns)
	
	
end)

--called by connecting client, to see if they have to readjust suspicious spawns
--RegisterServerEvent("sv:getcheckspawns")
--AddEventHandler("sv:getcheckspawns", function()
   -- TriggerClientEvent("mt:checkspawns", source, servercheckspawns)
--end)

--ALSO resets rescued flags for Type="HostageRescue"
--& "ObjectiveRescue"
function ResetIndoorSpawns (input)

	--RESET INDOOR MISSION SPAWNS 
	if Config.Missions[input].IndoorsMission then 
		if Config.Missions[input].Peds then 
			for i, v in pairs(Config.Missions[input].Peds) do
				Config.Missions[input].Peds[i].spawned=false
			end
		end 
		if Config.Missions[input].Vehicles then
			for i, v in pairs(Config.Missions[input].Vehicles) do
				Config.Missions[input].Vehicles[i].spawned = false
			end
		end
	end 
	
	if Config.Missions[input].Type=="HostageRescue" then 
			if Config.Missions[input].Peds then 			
				for i, v in pairs(Config.Missions[input].Peds) do
					Config.Missions[input].Peds[i].rescued=false
				end		
			end 
	end

	if Config.Missions[input].Type=="ObjectiveRescue" then 
		if Config.Missions[input].Props then 
			for i, v in pairs(Config.Missions[input].Props) do
				Config.Missions[input].Props[i].rescued=false
		
			end	
		end
	end
	if Config.Missions[input].Events then 
		for i, v in pairs(Config.Missions[input].Events) do
		
			--print("Event done:"..i)
			Config.Missions[input].Events[i].done=false		
		end			
	end
end


RegisterServerEvent("sv:CheckMissionHost")
AddEventHandler("sv:CheckMissionHost", function()
	TriggerClientEvent('mt:CheckMissionHost', -1) 
end)

RegisterServerEvent("sv:CheckHostFlag")
AddEventHandler("sv:CheckHostFlag", function(BLHOSTFLAG)
	--found the mission host, trigger the mission
	if(BLHOSTFLAG) then 
		MissionTriggered=true
		TriggerClientEvent('mt:TriggerMission', -1,MissionName) 
	end
	
	
end)


--HACK for now
RegisterServerEvent("sv:KillTargetPed")
AddEventHandler("sv:KillTargetPed", function()
	TriggerClientEvent('mt:KillTargetPed', -1) 
end)
  
RegisterServerEvent("sv:done")
AddEventHandler("sv:done", function(input,isstop,isfail,reasontext,blGoalReached)
	--make sure not multiple done messages
	if ActiveMission and MissionName~="N/A" then
	
			if Config.Missions[MissionName].Type=="Checkpoint" then 
				--print("cance race")
				TriggerEvent("mrpStreetRaces:cancelRace_sv")
			end	
			
		--remove any random events
		local REvents = Config.Missions[MissionName].Events
		local rem_key = {}
		
		--print("REvents"..#REvents)
		if REvents then	
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

			Config.Missions[MissionName].Events = REvents
		end
	
			--used for mrpStreetRaces:
			local MName = input
			if MName == '' then
			  MName = MissionName
			end
			ActiveMission=false
			--MissionName="N/A" --< **Leave the mission as is, so the missions will rotate**
			servercheckspawns = false
			blInSpaceTime = false
			IsRandomMissionHostageCount = 0
			IsRandomMissionHostageRescued = 0
			IsRandomDoEvent = false
			IsRandomDoEventRadius = 1000.0
			IsRandomDoEventType = 0
			MissionTriggered = false
			ResetIndoorSpawns (MName)
			TriggerClientEvent('DONE', -1, MName,isstop,isfail,reasontext,blGoalReached,checkpointdata) --GHK
			blMadeIt = false
			
			if not isstop and isfail then 
				blFailedMission = true
			end
			
	end
	
end)

RegisterServerEvent("sv:checkhostandremovepickups")
AddEventHandler("sv:checkhostandremovepickups", function(oldmission,nextmission,timetowait)
 local sourceplayer = source
	blInSpaceTime = true
	Citizen.Wait(timetowait)
	blInSpaceTime = false
	TriggerClientEvent('mt:removepickups', -1, oldmission) 
	--check if player index is still online
	local foundplayer = false
	local players = GetNumPlayerIndices()
	
	for i = 0, players - 1 do
	
		if tonumber(GetPlayerFromIndex(i))  ==  tonumber(sourceplayer) then 
			foundplayer = true
		end 
	
	end
	
	--can probaaly remove this code now:
	if not foundplayer and blHelpWithDisconnects then
	 --'host' player disconnected
		local newplayers = GetNumPlayerIndices() 
		local foundnewplayer = false
		local newindex = 0
		for i = 0, newplayers - 1 do
	
			if type(GetPlayerFromIndex(i))  ~=  "nil" then 
				foundnewplayer = true
				newindex = i
			end		
		
			if(foundnewplayer) then 
				--find another player to start the nextmission with
				--and 'hack' the client call for now, which is used for the first player on server 
				--blHelpWithDisconnects 
				--***DOUBLE CHECK THIS LOGIC ON CLIENT SIDE***
				--NEW MISSION...
				MilliSecondsLeft = getMissionConfigProperty(MissionName, "MissionLengthMinutes")*60*1000
				TriggerClientEvent('mt:setactive', GetPlayerFromIndex(newindex), 1,nextmission,1,false,MilliSecondsLeft)
				
				--be consistent and send host the mission triggered flag if it is true
				--for some reason, should never be though in this case.
				if MissionTriggered then 
					TriggerClientEvent('mt:TriggerMission', -1,MissionName) 
				end
			end 
		end

	end 
	
end)


RegisterServerEvent("sv:getmillisecondsleft")
AddEventHandler("sv:getmillisecondsleft", function()
local timeLeft = MilliSecondsLeft
TriggerClientEvent('mrpStreetRaces:getmillisecondsleft', source,timeLeft) 

end)






--called when a player joins
--if mission is currently running on server (ActiveMission=true), and they are only player
	--enable mission for them and spawn peds, set mission blip, and NPC blips
--if mission is running on server (ActiveMission=true) and there are other players
	--enable mission for them, dont spawn peds, but set mission blip and NPC blips
--if mission is not running on server (ActiveMission=false), and they are the only player
   --set Mission to 'Mission1' and enable mission for them and spawn peds, set mission blips, and NPC blips
   
RegisterServerEvent("sv:checkmission")
AddEventHandler("sv:checkmission", function(blfirstplayer)

print('sv:checkmission')
local onlinePlayers = GetNumPlayerIndices()


	if onlinePlayers > 0  then
	
		if ActiveMission then
			print('mt:setactive activemission')
		--print("sv:one rSafeHouseLocationIndex"..SafeHouseLocationIndex)
		--if(SafeHouseLocationIndex) then
			--print("sv:one rSafeHouseLocationIndex found:"..SafeHouseLocationIndex)
		--else
			--print("sv:one rSafeHouseLocationIndex not found:")
		--end
		--print("sv:one IsRandomSpawnAnywhereInfo.x found:".. IsRandomSpawnAnywhereInfo.x)
			
			TriggerClientEvent('mt:setactive', source, 1,MissionName,onlinePlayers,servercheckspawns,MilliSecondsLeft,ActiveMission,MissionType,MissionLocationIndex,IsRandomSpawnAnywhereInfo,SafeHouseLocationIndex,Config.Missions[MissionName].Peds,Config.Missions[MissionName].Vehicles,Config.Missions[MissionName].Props,Config.Missions[MissionName].Events,IsRandomDoEvent,IsRandomDoEventRadius,IsRandomDoEventType,MissionDestinationIndex)
			blInSpaceTime = false
			
			--do checkpoint mission stuff
			if Config.Missions[MissionName].Type=="Checkpoint" then 
				--this just generates Events
				--TriggerClientEvent("mt:generateCheckpointsAndEvents",-1, MissionName,Config.Missions[MissionName].RecordedCheckpoints,Config.Missions[MissionName].Events)
				TriggerClientEvent("mrpStreetRaces:createRace_cl", source, 1, 1, 300000, Config.Missions[MissionName].CheckpointsStartPos, Config.Missions[MissionName].RecordedCheckpoints)
			end
			--send host the mission triggered flag if it is true
			if MissionTriggered then 
				TriggerClientEvent('mt:TriggerMission', -1,MissionName)  
			end			
			
		else 
			if onlinePlayers == 1 and Config.StartMissionsOnSpawn then
				
				if MissionName == "N/A" then
					
				if Config.RandomMissions then
					MissionName = getNextMission("Mission1",true) --"Mission1"
				else
					MissionName = "Mission1"
				end
					
					
				end
				print('mt:setactive newmission')
				ActiveMission=true
				servercheckspawns = false
				blInSpaceTime = false
				--NEW MISSION...
				MissionStartTime = GetGameTimer() 
				MissionEndTime = MissionStartTime + getMissionConfigProperty(MissionName, "MissionLengthMinutes")*60*1000	
				MissionSpaceTime = getMissionConfigProperty(MissionName, "MissionSpaceTime")
				--both lines below are the same:
				--MilliSecondsLeft = MissionEndTime - MissionStartTime				
				MilliSecondsLeft = getMissionConfigProperty(MissionName, "MissionLengthMinutes")*60*1000
				MissionNoTimeout = getMissionConfigProperty(MissionName, "MissionNoTimeout")
				
				TriggerClientEvent('mt:setactive', source, 1,MissionName,onlinePlayers,servercheckspawns,MilliSecondsLeft,ActiveMission,MissionType,MissionLocationIndex,IsRandomSpawnAnywhereInfo,SafeHouseLocationIndex,Config.Missions[MissionName].Peds,Config.Missions[MissionName].Vehicles,Config.Missions[MissionName].Props,Config.Missions[MissionName].Events,IsRandomDoEvent,IsRandomDoEventRadius,IsRandomDoEventType,MissionDestinationIndex)
				
				
				--be consistent and send host the mission triggered flag if it is true
				--for some reason, should never be though in this case.
				if MissionTriggered then 
					TriggerClientEvent('mt:TriggerMission', -1,MissionName) 
				end							
				
			end 
		end 	
	
	end 
end)


--all credit below to FAXES for his Vote-To-Kick resource: https://forum.fivem.net/t/release-vote-to-kick-vote-players-out-fax-vote2kick-1-0/191676
-----------------------------------
--- BASED ON: Vote to Kick, Made by FAXES ---
-----------------------------------

local voteCount = 0
local canStartVote = true
local voteActive = false
local tPlayer = nil

local svrSeconds = 0
local svrMinutes = 0

minVoteAmt = 1 -- Amount of 'yes' votes needed to cancel the mission

voteWaitTime = 1 -- Time in MINUTES that players must wait before using the voteCmd again

voteCmd = "votefinish" -- Command that starts the vote to cancel mission process

voteYesCmd = "voteyes" -- Command to vote yes on the kick.

voteNoCmd = "voteno" -- Command to vote no on the kick.

local newMission 


RegisterCommand(voteCmd, function(source, args, rawCommand)
    newMission = args[1]
	local foundmission = false
	    for i, v in pairs(Config.Missions) do
            if newMission == i then
				foundmission = true
			end
		end 

	if newMission and not foundmission then 
		 TriggerClientEvent("chatMessage", source, "^1[MISSIONS]:Please specify a valid mission like '/votefinish Mission1' or just use '/votefinish'. Use '/list' to view all available missions")
		  --TriggerClientEvent("chatMessage", source, "^1[MISSIONS]:Use '/list' to view all available missions")
		 newMission = nil
		
	elseif newMission and foundmission then
	
		if canStartVote == true then
			TriggerClientEvent("chatMessage", -1, "^*^1[MISSIONS]: VOTE TO FINISH THE MISSION RIGHT NOW AND START THE NEW MISSION:")
			TriggerClientEvent("chatMessage", -1, "^*^1[MISSIONS]: ^2"..newMission..": '"..Config.Missions[newMission].MissionTitle.."'^7?")
			TriggerClientEvent("chatMessage", -1, "^*^1[MISSIONS]: ^7? Use /" .. voteYesCmd .. " & /" .. voteNoCmd)
			voteActive = true
			voteCount = 0
			canStartVote = false
			svrSeconds = 0
			svrMinutes = 0
		else
			TriggerClientEvent("chatMessage", source, "^1[MISSIONS]:Please wait before starting a vote to finish a mission.")
			 newMission = nil
		end	
	else  
		if canStartVote == true then
		  
			TriggerClientEvent("chatMessage", -1, "^*^1[MISSIONS]: VOTE TO FINISH THE MISSION RIGHT NOW^7? Use /" .. voteYesCmd .. " & /" .. voteNoCmd)
			voteActive = true
			voteCount = 0
			canStartVote = false
			svrSeconds = 0
			svrMinutes = 0
		else
			TriggerClientEvent("chatMessage", source, "Please wait before starting a vote to finish a mission.")
		end
	end
	
end)

RegisterCommand(voteYesCmd, function(source, args, rawCommand)
    if voteActive then
        TriggerClientEvent("mrp:SubmitVote", source, "yes")
    else
        TriggerClientEvent("chatMessage", source, "There is no active vote-to-finish.")
    end
end)

RegisterCommand(voteNoCmd, function(source, args, rawCommand)
    if voteActive then
        TriggerClientEvent("mrp:SubmitVote", source, "no")
    else
        TriggerClientEvent("chatMessage", source, "There is no active vote-to-finish.")
    end
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		svrSeconds = svrSeconds + 1
		if svrSeconds == 60 then
			svrSeconds = 0
            svrMinutes = svrMinutes + 1
        end
        if svrMinutes == voteWaitTime then
            canStartVote = true
            svrSeconds = 0
            svrMinutes = 0
        end
	end
end)

RegisterServerEvent("mrp:SendVote")
AddEventHandler("mrp:SendVote", function()
    voteCount = voteCount + 1
end)

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(1000)
        if voteActive then
            if voteCount == minVoteAmt then
				if ActiveMission and MissionName~="N/A" then
					if Config.Missions[MissionName].Type=="Checkpoint" then 
						--print("cance race")
						TriggerEvent("mrpStreetRaces:cancelRace_sv")
					end					
				
					ActiveMission=false
					--MissionName="N/A" --< **Leave the mission as is, so the missions will rotate**
					IsRandomMissionHostageCount = 0
					IsRandomMissionHostageRescued = 0
					servercheckspawns = false
					blInSpaceTime = false
					ResetIndoorSpawns (MissionName)
					TriggerClientEvent('DONE', -1, MissionName,false,true,"cancel") --GHK
				end   
                voteActive = false
                voteCount = 0
                TriggerClientEvent("mrp:ResetVotes", -1)
				--start next mission after 10 seconds:
				Wait(10000)
				if not ActiveMission then 
					print("Server Start Mission After Vote")
					if newMission then 
						TriggerClientEvent("mt:checkIfIAmHost", -1,newMission)
					else 
						TriggerClientEvent("mt:checkIfIAmHost", -1)
					end
				end				
            end
        end
	end
end)


