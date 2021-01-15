-- DEFINITIONS AND CONSTANTS
local RACE_STATE_NONE = 0
local RACE_STATE_JOINED = 1
local RACE_STATE_RACING = 2
local RACE_STATE_RECORDING = 3
local RACE_CHECKPOINT_TYPE = 45
local RACE_CHECKPOINT_FINISH_TYPE = 9

local RACE_STATE_JOINING = 4

-- Races and race status
local races = {}
local raceStatus = {
    state = RACE_STATE_NONE,
    index = 0,
    checkpoint = 0
}

--ghk mission start blip
local blipM


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
-- Recorded checkpoints
local recordedCheckpoints = {}

-- Main command for races
RegisterCommand("race", function(source, args)
    if args[1] == "clear" or args[1] == "leave" then
        -- If player is part of a race, clean up map and send leave event to server
        if raceStatus.state == RACE_STATE_JOINED or raceStatus.state == RACE_STATE_RACING then
            cleanupRace()
            TriggerServerEvent('mrpStreetRaces:leaveRace_sv', raceStatus.index)
        end

        -- Reset state
        raceStatus.index = 0
        raceStatus.checkpoint = 0
        raceStatus.state = RACE_STATE_NONE
		
	--elseif args[1] == "random" and raceStatus.state == RACE_STATE_NONE and args[2] then
	--	local isargok = (tostring(args[2]) == "false" or tostring(args[2]) == "true")
    --    if raceStatus.state == RACE_STATE_NONE and isargok then
	--		config_cl.randomCheckpoints= args[2]
	--		TriggerServerEvent('mrpStreetRaces:random_sv', name)
	--	else
		
	--		TriggerEvent('chatMessage', "^1[MISSIONS]: ^2There is not a Mission in Progress.")
	--	end 
        
    elseif args[1] == "record" then
        -- Clear waypoint, cleanup recording and set flag to start recording
        SetWaypointOff()
        cleanupRecording()
        raceStatus.state = RACE_STATE_RECORDING
    elseif args[1] == "save" then
        -- Check name was provided and checkpoints are recorded
        local name = args[2]
        if name ~= nil and #recordedCheckpoints > 0 then
            -- Send event to server to save checkpoints
            TriggerServerEvent('mrpStreetRaces:saveRace_sv', name, recordedCheckpoints)
        end
    elseif args[1] == "delete" then
        -- Check name was provided and send event to server to delete saved race
        local name = args[2]
        if name ~= nil then
            TriggerServerEvent('mrpStreetRaces:deleteRace_sv', name)
        end
    elseif args[1] == "list" then
        -- Send event to server to list saved races
        TriggerServerEvent('mrpStreetRaces:listRaces_sv')
    elseif args[1] == "load" then
        -- Check name was provided and send event to server to load saved race
        local name = args[2]
		
        if name ~= nil then
			
            TriggerServerEvent('mrpStreetRaces:loadRace_sv', name,config_cl.randomCheckpoints)
        end
    elseif args[1] == "start" then
        -- Parse arguments and create race
        local amount = tonumber(args[2])
        if amount then
            -- Get optional start delay argument and starting coordinates
            local startDelay = tonumber(args[3])
            startDelay = startDelay and startDelay*1000 or config_cl.joinDuration
            local startCoords = GetEntityCoords(GetPlayerPed(-1))

            -- Create a race using checkpoints or waypoint if none set
            if #recordedCheckpoints > 0 then
                -- Create race using custom checkpoints
				--print('create race 1')
                TriggerServerEvent('mrpStreetRaces:createRace_sv', amount, startDelay, startCoords, recordedCheckpoints)
            elseif IsWaypointActive() then
			--print('create race 2')
                -- Create race using waypoint as the only checkpoint
                local waypointCoords = GetBlipInfoIdCoord(GetFirstBlipInfoId(8))
                local retval, nodeCoords = GetClosestVehicleNode(waypointCoords.x, waypointCoords.y, waypointCoords.z, 1)
                table.insert(recordedCheckpoints, {blip = nil, coords = nodeCoords})
                TriggerServerEvent('mrpStreetRaces:createRace_sv', amount, startDelay, startCoords, recordedCheckpoints)
            end

            -- Set state to none to cleanup recording blips while waiting to join
            raceStatus.state = RACE_STATE_NONE
        end
    elseif args[1] == "cancel" then
        -- Send cancel event to server
        TriggerServerEvent('mrpStreetRaces:cancelRace_sv')
    else
        return
    end
end)


-- Client event for when a race is created
RegisterNetEvent("mrpStreetRaces:createRace_cl")
AddEventHandler("mrpStreetRaces:createRace_cl", function(index, amount, startDelay, startCoords, checkpoints)
 --print('createRace_cl'..index)
    -- Create race struct and add to array
    local race = {
        amount = amount,
        started = false,
        startTime = GetGameTimer() + startDelay,
        startCoords = startCoords,
        checkpoints = checkpoints
    }
    races[index] = race
	
	--print(startCoords.x)
	--print(startCoords.y)
	--print(startCoords.z)
	
	TriggerEvent('mt:getmillisecondsleft')
	
	--local blip = AddBlipForCoord(startCoords.x, startCoords.y, startCoords.z)
	--SetBlipColour(blip, 1)
	--SetBlipAsShortRange(blip, true)
	
			blipM = AddBlipForCoord(startCoords.x, startCoords.y, startCoords.z)
			SetBlipSprite (blipM, 78) --'M'
			SetBlipDisplay(blipM, 4)
			SetBlipScale  (blipM, 1.2)
			SetBlipColour (blipM,69)
			SetBlipAsShortRange(blipM, false)
			local btitle = "Mission Start"
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(btitle)
			EndTextCommandSetBlipName(blipM)	
			
	
end)

RegisterNetEvent("mrpStreetRaces:getmillisecondsleft")
AddEventHandler("mrpStreetRaces:getmillisecondsleft", function(millisecondsleft)
--("mrpStreetRaces:getmillisecondsleft called:".. millisecondsleft)
--races[1].MissionStartTime = GetGameTimer()
races[1].endTime = millisecondsleft + GetGameTimer()
end)



-- Client event for loading a race
RegisterNetEvent("mrpStreetRaces:loadRace_cl")
AddEventHandler("mrpStreetRaces:loadRace_cl", function(checkpoints)
    -- Cleanup recording, save checkpoints and set state to recording
    cleanupRecording()
	
    recordedCheckpoints = checkpoints
	
    raceStatus.state = RACE_STATE_RECORDING

    -- Add map blips
    for index, checkpoint in pairs(recordedCheckpoints) do
        checkpoint.blip = AddBlipForCoord(checkpoint.coords.x, checkpoint.coords.y, checkpoint.coords.z)
        SetBlipColour(checkpoint.blip, config_cl.checkpointBlipColor)
        SetBlipAsShortRange(checkpoint.blip, true)
        ShowNumberOnBlip(checkpoint.blip, index)
    end

    -- Clear waypoint and add route for first checkpoint blip
    SetWaypointOff()
    SetBlipRoute(checkpoints[1].blip, true)
    SetBlipRouteColour(checkpoints[1].blip, config_cl.checkpointBlipColor)
end)

-- Client event for when a race is joined
RegisterNetEvent("mrpStreetRaces:joinedRace_cl")
AddEventHandler("mrpStreetRaces:joinedRace_cl", function(index)

	--lets get the missin time left again
	TriggerEvent('mt:getmillisecondsleft')
    -- Set index and state to joined
    raceStatus.index = index
    raceStatus.state = RACE_STATE_JOINED
	PlaySoundFrontend(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET", 1)

    -- Add map blips
    local race = races[index]
	--print("joined")
    local checkpoints = race.checkpoints
    for index, checkpoint in pairs(checkpoints) do
        checkpoint.blip = AddBlipForCoord(checkpoint.coords.x, checkpoint.coords.y, checkpoint.coords.z)
        SetBlipColour(checkpoint.blip, config_cl.checkpointBlipColor)
        SetBlipAsShortRange(checkpoint.blip, true)
        ShowNumberOnBlip(checkpoint.blip, index)
    end

    -- Clear waypoint and add route for first checkpoint blip
    SetWaypointOff()
    SetBlipRoute(checkpoints[1].blip, true)
    SetBlipRouteColour(checkpoints[1].blip, config_cl.checkpointBlipColor)
end)

-- Client event for when a race is removed
RegisterNetEvent("mrpStreetRaces:removeRace_cl")
AddEventHandler("mrpStreetRaces:removeRace_cl", function(index)
    -- Check if index matches active race
    if index == raceStatus.index then
        -- Cleanup map blips and checkpoints
        cleanupRace()

        -- Reset racing state
        raceStatus.index = 0
        raceStatus.checkpoint = 0
        raceStatus.state = RACE_STATE_NONE
    elseif index < raceStatus.index then
        -- Decrement raceStatus.index to match new index after removing race
        raceStatus.index = raceStatus.index - 1
    end
    
    -- Remove race from table
    table.remove(races, index)
end)

-- Client event for when a race is removed
RegisterNetEvent("mrpStreetRaces:RemoveMissionBlip_cl")
AddEventHandler("mrpStreetRaces:RemoveMissionBlip_cl", function(index)
    	if DoesBlipExist(blipM) then
			RemoveBlip(blipM)
		end
end)


function Notify(msg)
  SetNotificationTextEntry("STRING")
  AddTextComponentString(msg)
  DrawNotification(true, false)
end

local nextBlip
-- Main thread
Citizen.CreateThread(function()
    -- Loop forever and update every frame
    while true do
        Citizen.Wait(0)

        -- Get player and check if they're in a vehicle
        local player = GetPlayerPed(-1)
        if IsPedInAnyVehicle(player, false) then
            -- Get player position and vehicle
            local position = GetEntityCoords(player)
            local vehicle = GetVehiclePedIsIn(player, false)
			
            -- Player is racing
            if raceStatus.state == RACE_STATE_RACING then
			
                -- Initialize first checkpoint if not set
                local race = races[raceStatus.index]
                if raceStatus.checkpoint == 0 then
                    -- Increment to first checkpoint
                    raceStatus.checkpoint = 1
					TriggerEvent("mt:updatePlayerCheckpoints", raceStatus.checkpoint)
                    local checkpoint = race.checkpoints[raceStatus.checkpoint]

                    -- Create checkpoint when enabled
                    if config_cl.checkpointRadius > 0 then
                        local checkpointType = raceStatus.checkpoint < #race.checkpoints and RACE_CHECKPOINT_TYPE or RACE_CHECKPOINT_FINISH_TYPE
						
						--local temp, zCoord = GetGroundZFor_3dCoord(race.startCoords.x, race.startCoords.y, 9999.9, 1)
                        checkpoint.checkpoint = CreateCheckpoint(checkpointType, checkpoint.coords.x,  checkpoint.coords.y, checkpoint.coords.z, 0, 0, 0, config_cl.checkpointRadius, 255, 255, 0, 127, 0)
                        SetCheckpointCylinderHeight(checkpoint.checkpoint, config_cl.checkpointHeight, config_cl.checkpointHeight, config_cl.checkpointRadius)
                    end
					
					--GHK add long range blip
					nextBlip = AddBlipForCoord(checkpoint.coords.x, checkpoint.coords.y,checkpoint.coords.z)
					SetBlipColour(nextBlip, config_cl.checkpointBlipColor)
					SetBlipScale(nextBlip,2.0)
					SetBlipAsShortRange(nextBlip, false)
					ShowNumberOnBlip(nextBlip,raceStatus.checkpoint)					

                    -- Set blip route for navigation
                    SetBlipRoute(checkpoint.blip, true)
                    SetBlipRouteColour(checkpoint.blip, config_cl.checkpointBlipColor)
                else
                    -- Check player distance from current checkpoint
                    local checkpoint = race.checkpoints[raceStatus.checkpoint]
					
					
					
                    if GetDistanceBetweenCoords(position.x, position.y, position.z, checkpoint.coords.x, checkpoint.coords.y, 0, false) < config_cl.checkpointProximity 
					
					and position.z < 1000.0 --for planes not to go too high
					then
                        -- Passed the checkpoint, delete map blip and checkpoint
                        RemoveBlip(checkpoint.blip)
                        if config_cl.checkpointRadius > 0 then
							--print("DELETE CHECKPOINT")
                            DeleteCheckpoint(checkpoint.checkpoint)
                        end
                        
                        -- Check if at finish line
                        if raceStatus.checkpoint == #(race.checkpoints) then
							print('finish')
                            -- Play finish line sound
                            PlaySoundFrontend(-1, "ScreenFlash", "WastedSounds")
							----GHK remove long range blip
							RemoveBlip(nextBlip)
							
							TriggerEvent("mt:updatePlayerCheckpoints", raceStatus.checkpoint+1)
                            -- Send finish event to server
                            local currentTime = (GetGameTimer() - race.startTime)
                            TriggerServerEvent('mrpStreetRaces:finishedRace_sv', raceStatus.index, currentTime)
                            cleanupRace()
                            -- Reset state
                            raceStatus.index = 0
                            raceStatus.state = RACE_STATE_NONE
                        else
							----GHK remove long range blip
							--print("remove long range blip")
							RemoveBlip(nextBlip)
                            -- Play checkpoint sound
                            PlaySoundFrontend(-1, "RACE_PLACED", "HUD_AWARDS")

                            -- Increment checkpoint counter and get next checkpoint
                            raceStatus.checkpoint = raceStatus.checkpoint + 1
							TriggerEvent("mt:updatePlayerCheckpoints", raceStatus.checkpoint)
                            local nextCheckpoint = race.checkpoints[raceStatus.checkpoint]

                            -- Create checkpoint when enabled
                            if config_cl.checkpointRadius > 0 then
                                local checkpointType = raceStatus.checkpoint < #race.checkpoints and RACE_CHECKPOINT_TYPE or RACE_CHECKPOINT_FINISH_TYPE
								
								
                                nextCheckpoint.checkpoint = CreateCheckpoint(checkpointType, nextCheckpoint.coords.x,  nextCheckpoint.coords.y, nextCheckpoint.coords.z, 0, 0, 0, config_cl.checkpointRadius, 255, 255, 0, 127, 0)
                                SetCheckpointCylinderHeight(nextCheckpoint.checkpoint, config_cl.checkpointHeight, config_cl.checkpointHeight, config_cl.checkpointRadius)
                            end

							--GHK add long range blip
							nextBlip = AddBlipForCoord(nextCheckpoint.coords.x, nextCheckpoint.coords.y, 	nextCheckpoint.coords.z)
							SetBlipColour(nextBlip, config_cl.checkpointBlipColor)
							SetBlipAsShortRange(nextBlip, false)
							SetBlipScale(nextBlip,2.0)
							ShowNumberOnBlip(nextBlip,raceStatus.checkpoint)
							
                            -- Set blip route for navigation
                            SetBlipRoute(nextCheckpoint.blip, true)
                            SetBlipRouteColour(nextCheckpoint.blip, config_cl.checkpointBlipColor)
                        end
                    end
                end

                -- Draw HUD when it's enabled
                if config_cl.hudEnabled then
                    -- Draw time and checkpoint HUD above minimap
                    --local timeSeconds = (GetGameTimer() - race.startTime)/1000.0
					if race.endTime then
						local timeSeconds = (race.endTime-GetGameTimer())/1000.0
						local timeMinutes = math.floor(timeSeconds/60.0)
						timeSeconds = timeSeconds - 60.0*timeMinutes
						Draw2DText(config_cl.hudPosition.x, config_cl.hudPosition.y, ("~y~Time Left %02d:%06.3f"):format(timeMinutes, timeSeconds), 0.7)
                    end
					
					local checkpoint = race.checkpoints[raceStatus.checkpoint]
					local checkpointDist = math.floor(GetDistanceBetweenCoords(position.x, position.y, position.z, checkpoint.coords.x, checkpoint.coords.y, 0, false))
				   Draw2DText(config_cl.hudPosition.x, config_cl.hudPosition.y + 0.04, ("~y~CHECKPOINT %d/%d (%dm)"):format(raceStatus.checkpoint, #race.checkpoints, checkpointDist), 0.5)
                end
            -- Player has joined a race
            elseif raceStatus.state == RACE_STATE_JOINED then
			
                -- Check countdown to race start
                local race = races[raceStatus.index]
                local currentTime = GetGameTimer()
                local count = 0--GHK, lets start race asap... race.startTime - currentTime
                if count <= 0 then
                    -- Race started, set racing state and unfreeze vehicle position
                    raceStatus.state = RACE_STATE_RACING
                    raceStatus.checkpoint = 0
                    FreezeEntityPosition(vehicle, false)
                elseif count <= config_cl.freezeDuration then
                    -- Display countdown text and freeze vehicle position
                    Draw2DText(0.5, 0.4, ("~y~%d"):format(math.ceil(count/1000.0)), 3.0)
                    FreezeEntityPosition(vehicle, true)
                else
                    -- Draw 3D start time and join text
                    local temp, zCoord = GetGroundZFor_3dCoord(race.startCoords.x, race.startCoords.y, 9999.9, 1)
                    Draw3DText(race.startCoords.x, race.startCoords.y, zCoord+1.0, ("Race for ~g~$%d~w~ starting in ~y~%d~w~s"):format(race.amount, math.ceil(count/1000.0)))
                    Draw3DText(race.startCoords.x, race.startCoords.y, zCoord+0.80, "Joined")
											
                end
            -- Player is not in a race
            else
                -- Loop through all races
				--print("p:")
                for index, race in pairs(races) do
                    -- Get current time and player proximity to start
                    local currentTime = GetGameTimer()
                    local proximity = GetDistanceBetweenCoords(position.x, position.y, position.z, race.startCoords.x, race.startCoords.y, race.startCoords.z, true)
					--print("p:"..tostring(proximity))
					--print("t:"..tostring(currentTime < race.startTime))
					--print("tl:"..tostring(race.startTime-currentTime))
                    -- When in proximity and race hasn't started draw 3D text and prompt to join
                    if proximity < config_cl.joinProximity then -- GHK: and currentTime < race.startTime then
					--print("can join race"..math.random(100))
                        -- Draw 3D text
                        local count = math.ceil((race.startTime - currentTime)/1000.0)
                        local temp, zCoord = GetGroundZFor_3dCoord(race.startCoords.x, race.startCoords.y, 9999.9, 0)
                        Draw3DText(race.startCoords.x, race.startCoords.y, zCoord+1.0, ("Race for ~g~$%d~w~ starting in ~y~%d~w~s"):format(race.amount, count))
                        Draw3DText(race.startCoords.x, race.startCoords.y, zCoord+0.80, "Press [~g~E~w~] to join")
						
						--DrawMarker(1, race.startCoords.x,race.startCoords.y, race.startCoords.z, config_cl.joinProximity, config_cl.joinProximity, 1000.0, 0, 0.0, 0.0, 3.0,3.0, 3.0, 117, 218, 255, 100, true, true, 2, true, false, false, false)			

                        -- Check if player enters the race and send join event to server
                       -- if IsControlJustReleased(1, config_cl.joinKeybind) then
					   if raceStatus.state==RACE_STATE_NONE then
							raceStatus.state=RACE_STATE_JOINING
							Notify("~h~~g~You joined the race!")
							TriggerServerEvent("sv:message", "~h~~r~"..GetPlayerName(PlayerId()).."~w~ has joined the race")
                            TriggerServerEvent('mrpStreetRaces:joinRace_sv', index)
                            break
						end
                        --end
					else 
					--print (race.startCoords.x)
					DrawMarker(1, race.startCoords.x,race.startCoords.y, race.startCoords.z-1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, config_cl.joinProximity+5,config_cl.joinProximity+5, 1000.0, 100, 100, 204, 100, false, true, 2, true, false, false, false)					
					
                    end
                end
            end  
        end
    end
end)

-- Checkpoint recording thread
Citizen.CreateThread(function()
    -- Loop forever and record checkpoints every 100ms
    while true do
        Citizen.Wait(100)
        
        -- When recording flag is set, save checkpoints
        if raceStatus.state == RACE_STATE_RECORDING then
            -- Create new checkpoint when waypoint is set
            if IsWaypointActive() then
                -- Get closest vehicle node to waypoint coordinates and remove waypoint
                
				local waypointCoords = GetBlipInfoIdCoord(GetFirstBlipInfoId(8))
               
			   local retval, coords = GetClosestVehicleNode(waypointCoords.x, waypointCoords.y, waypointCoords.z, 1)
               
			   if config_cl.snapToNearestRoad == false then
				coords = waypointCoords
			   end
				SetWaypointOff()

                -- Check if coordinates match any existing checkpoints
                for index, checkpoint in pairs(recordedCheckpoints) do
                    if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, checkpoint.coords.x, checkpoint.coords.y, checkpoint.coords.z, false) < 1.0 then
                        -- Matches existing checkpoint, remove blip and checkpoint from table
                        RemoveBlip(checkpoint.blip)
                        table.remove(recordedCheckpoints, index)
                        coords = nil

                        -- Update existing checkpoint blips
                        for i = index, #recordedCheckpoints do
                            ShowNumberOnBlip(recordedCheckpoints[i].blip, i)
                        end
                        break
                    end
                end

                -- Add new checkpoint
                if (coords ~= nil) then
                    -- Add numbered checkpoint blip
                    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
                    SetBlipColour(blip, config_cl.checkpointBlipColor)
                    SetBlipAsShortRange(blip, true)
                    ShowNumberOnBlip(blip, #recordedCheckpoints+1)

                    -- Add checkpoint to array
                    table.insert(recordedCheckpoints, {blip = blip, coords = coords})
                end
            end
        else
            -- Not recording, do cleanup
            cleanupRecording()
        end
    end
end)

-- Helper function to clean up race blips, checkpoints and status
function cleanupRace()
    -- Cleanup active race
	--remove mission blip
		if DoesBlipExist(blipM) then
			RemoveBlip(blipM)
		end
    if raceStatus.index ~= 0 then
        -- Cleanup map blips and checkpoints
        local race = races[raceStatus.index]
        local checkpoints = race.checkpoints
        for _, checkpoint in pairs(checkpoints) do
            if checkpoint.blip then
                RemoveBlip(checkpoint.blip)
            end
            if checkpoint.checkpoint then
                DeleteCheckpoint(checkpoint.checkpoint)
            end
        end
		
		if DoesBlipExist(nextBlip) then
			RemoveBlip(nextBlip)
		end

        -- Set new waypoint to finish if racing
        if raceStatus.state == RACE_STATE_RACING then
            local lastCheckpoint = checkpoints[#checkpoints]
            SetNewWaypoint(lastCheckpoint.coords.x, lastCheckpoint.coords.y)
        end

        -- Unfreeze vehicle
        local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
        FreezeEntityPosition(vehicle, false)
    end
end

-- Helper function to clean up recording blips
function cleanupRecording()
    -- Remove map blips and clear recorded checkpoints
    for _, checkpoint in pairs(recordedCheckpoints) do
        RemoveBlip(checkpoint.blip)
        checkpoint.blip = nil
    end
    recordedCheckpoints = {}
end

-- Draw 3D text at coordinates
function Draw3DText(x, y, z, text)
    -- Check if coords are visible and get 2D screen coords
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if onScreen then
        -- Calculate text scale to use
        local dist = GetDistanceBetweenCoords(GetGameplayCamCoords(), x, y, z, 1)
        local scale = 1.8*(1/dist)*(1/GetGameplayCamFov())*100

        -- Draw text on screen
        SetTextScale(scale, scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropShadow(0, 0, 0, 0,255)
        SetTextDropShadow()
        SetTextEdge(4, 0, 0, 0, 255)
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

-- Draw 2D text on screen
function Draw2DText(x, y, text, scale)
    -- Draw text on screen
    SetTextFont(4)
    SetTextProportional(7)
    SetTextScale(scale, scale)
    SetTextColour(255, 255, 255, 255)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextDropShadow()
    SetTextEdge(4, 0, 0, 0, 255)
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end
