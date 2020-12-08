-- Server side array of active races
local races = {}

-- Cleanup thread
Citizen.CreateThread(function()
    -- Loop forever and check status every 100ms
    while true do
        Citizen.Wait(100)

        -- Check active races and remove any that become inactive
        for index, race in pairs(races) do
            -- Get time and players in race
            local time = GetGameTimer()
            local players = race.players

            -- Check start time and player count
            if (time > race.startTime) and (#players == 0) then
                -- Race past start time with no players, remove race and send event to all clients
                table.remove(races, index)
                TriggerClientEvent("mrpStreetRaces:removeRace_cl", -1, index)
            -- Check if race has finished and expired
            elseif (race.finishTime ~= 0) and (time > race.finishTime + race.finishTimeout) then
                -- Did not finish, notify players still racing
                for _, player in pairs(players) do
                    notifyPlayer(player, "DNF (timeout)")
                end

                -- Remove race and send event to all clients
                table.remove(races, index)
                TriggerClientEvent("mrpStreetRaces:removeRace_cl", -1, index)
            end
        end
    end
end)

-- Server event for creating a race
RegisterNetEvent("mrpStreetRaces:createRace_sv")
AddEventHandler("mrpStreetRaces:createRace_sv", function(amount, startDelay, startCoords, checkpoints, finishTimeout)
    -- Add fields to race struct and add to races array
    local race = {
        owner = source,
        amount = amount,
        startTime = GetGameTimer() + startDelay,
        startCoords = startCoords,
        checkpoints = checkpoints,
        finishTimeout = config_sv.finishTimeout,
        players = {},
        prize = 0,
        finishTime = 0
    }
    table.insert(races, race)
	--print('sv create race')
    -- Send race data to all clients
    local index = #races
    TriggerClientEvent("mrpStreetRaces:createRace_cl", -1, index, amount, startDelay, startCoords, checkpoints)
end)

-- Server event for canceling a race
RegisterNetEvent("mrpStreetRaces:cancelRace_sv")
AddEventHandler("mrpStreetRaces:cancelRace_sv", function()
    -- Iterate through races
    for index, race in pairs(races) do
        -- Find if source player owns a race that hasn't started
        local time = GetGameTimer()
       -- if source == race.owner and time < race.startTime then
            -- Send notification and refund money for all entered players
            --for _, player in pairs(race.players) do
                -- Refund money to player and remove from prize pool
                --addMoney(player, race.amount)
              --  race.prize = race.prize - race.amount

                -- Notify player race has been canceled
               -- local msg = "Race canceled"
               -- notifyPlayer(player, msg)
            --end

            -- Remove race from table and send client event
            table.remove(races, index)
            TriggerClientEvent("mrpStreetRaces:removeRace_cl", -1, index)
       -- end
    end
end)

-- Server event for joining a race
RegisterNetEvent("mrpStreetRaces:joinRace_sv")
AddEventHandler("mrpStreetRaces:joinRace_sv", function(index)
    -- Validate and deduct player money
    local race = races[index]
    local amount = race.amount
    local playerMoney = getMoney(source)
    if playerMoney >= amount then
        -- Deduct money from player and add to prize pool
        removeMoney(source, amount)
        race.prize = race.prize + amount

        -- Add player to race and send join event back to client
        table.insert(races[index].players, source)
        TriggerClientEvent("mrpStreetRaces:joinedRace_cl", source, index)
    else
        -- Insufficient money, send notification back to client
        local msg = "Insuffient funds to join race"
        notifyPlayer(source, msg)
    end
end)

-- Server event for leaving a race
RegisterNetEvent("mrpStreetRaces:leaveRace_sv")
AddEventHandler("mrpStreetRaces:leaveRace_sv", function(index)
    -- Validate player is part of the race
    local race = races[index]
    local players = race.players
    for index, player in pairs(players) do
        if source == player then
            -- Remove player from race and break
            table.remove(players, index)
            break
        end
    end
end)

-- Server event for finishing a race
RegisterNetEvent("mrpStreetRaces:finishedRace_sv")
AddEventHandler("mrpStreetRaces:finishedRace_sv", function(index, time)
    -- Check player was part of the race
    local race = races[index]
	if not race then
		return
	end
	
    local players = race.players
    for index, player in pairs(players) do
        if source == player then 
            -- Calculate finish time
            local time = GetGameTimer()
            local timeSeconds = (time - race.startTime)/1000.0
            local timeMinutes = math.floor(timeSeconds/60.0)
            timeSeconds = timeSeconds - 60.0*timeMinutes

            -- If race has not finished already
            if race.finishTime == 0 then
                -- Winner, set finish time and award prize money
                race.finishTime = time
                --addMoney(source, race.prize)
				
                -- Send winner notification to players
                for _, pSource in pairs(players) do
                    if pSource == source then
                        local msg = ("You won [%02d:%06.3f]"):format(timeMinutes, timeSeconds)
                        notifyPlayer(pSource, msg)
						
                    elseif config_sv.notifyOfWinner then
                        local msg = ("%s won [%02d:%06.3f]"):format(getName(source), timeMinutes, timeSeconds)
                        notifyPlayer(pSource, msg)
                    end
					
					local messagestr = "~h~~r~"..GetPlayerName(source).."~y~ has won"
					TriggerClientEvent("mt:missiontext2",-1,messagestr,5000)
					--Put in a Wait, to make sure other Triggers finish
					--so any passengers get rewarded. 
					Citizen.Wait(1000)
					TriggerEvent("sv:done",'',false,false,messagestr,false)
					-- Remove race from table and send client event
					if races and index > 0 then 
						table.remove(races, index)
					end 
					TriggerClientEvent("mrpStreetRaces:removeRace_cl",-1,1)
					
                end
            else
                -- Loser, send notification to only the player
                local msg = ("You lost [%02d:%06.3f]"):format(timeMinutes, timeSeconds)
                notifyPlayer(source, msg)
            end

            -- Remove player form list and break
            table.remove(players, index)
            break
        end
    end
end)

-- Server event for saving recorded checkpoints as a race
RegisterNetEvent("mrpStreetRaces:saveRace_sv")
AddEventHandler("mrpStreetRaces:saveRace_sv", function(name, checkpoints)
    -- Cleanup data so it can be serialized
    for _, checkpoint in pairs(checkpoints) do
        checkpoint.blip = nil
        checkpoint.coords = {x = checkpoint.coords.x, y = checkpoint.coords.y, z = checkpoint.coords.z}
    end

    -- Get saved player races, add race and save
    local playerRaces = loadPlayerData(source)
    playerRaces[name] = checkpoints
    savePlayerData(source, playerRaces)

    -- Send notification to player
    local msg = "Saved " .. name
    notifyPlayer(source, msg)
end)

-- Server event for deleting recorded race
RegisterNetEvent("mrpStreetRaces:deleteRace_sv")
AddEventHandler("mrpStreetRaces:deleteRace_sv", function(name)
    -- Get saved player races
    local playerRaces = loadPlayerData(source)

    -- Check if race with name exists
    if playerRaces[name] ~= nil then
        -- Delete race and save data
        playerRaces[name] = nil
        savePlayerData(source, playerRaces)

        -- Send notification to player
        local msg = "Deleted " .. name
        notifyPlayer(source, msg)
    else
        local msg = "No race found with name " .. name
        notifyPlayer(source, msg)
    end
end)

-- Server event for listing recorded races
RegisterNetEvent("mrpStreetRaces:listRaces_sv")
AddEventHandler("mrpStreetRaces:listRaces_sv", function()
    -- Get saved player races and iterate through saved races
    local msg = "Saved races: "
    local count = 0
    local playerRaces = loadPlayerData(source)
    for name, race in pairs(playerRaces) do
        msg = msg .. name .. ", "
        count = count + 1
    end

    -- Fix string formatting
    if count > 0 then
        msg = string.sub(msg, 1, -3)
    end

    -- Send notification to player with listing
    notifyPlayer(source, msg)
end)

function shuffle(array)
    -- fisher-yates
    local output = { }
    local random = math.random

    for index = 1, #array do
        local offset = index - 1
        local value = array[index]
        local randomIndex = offset*random()
        local flooredIndex = randomIndex - randomIndex%1

        if flooredIndex == offset then
            output[#output + 1] = value
        else
            output[#output + 1] = output[flooredIndex + 1]
            output[flooredIndex + 1] = value
        end
    end

    return output
end

local playerrandomrace={}
-- Server event for loaded recorded race
RegisterNetEvent("mrpStreetRaces:loadRace_sv")
AddEventHandler("mrpStreetRaces:loadRace_sv", function(name,isRandom)
    -- Get saved player races and load race
    local playerRaces = loadPlayerData(source)
    local race = playerRaces[name]
   
	if isRandom then
		
		math.randomseed(GetGameTimer())
		race = shuffle(race) 
		playerRaces[name]=race
	end 
    -- If race was found send it to the client
    if race ~= nil then
        -- Send race data to client
        TriggerClientEvent("mrpStreetRaces:loadRace_cl", source, race)

        -- Send notification to player
        local msg = "Loaded " .. name
        notifyPlayer(source, msg)
    else
        local msg = "No race found with name " .. name
        notifyPlayer(source, msg)
    end
end)
