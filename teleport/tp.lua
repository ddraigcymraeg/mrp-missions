
local maxplayerdistance = 300.0 --cant teleport to a location further than 300m from another player
function GetClosestPlayerToCoord(cx,cy,cz)
	--local players = GetPlayers()
	local closestDistance = -1
	local closestPlayer = -1
	local ply = GetPlayerPed(-1)
	local plyCoords = GetEntityCoords(ply, 0)

	for index,value in ipairs(GetActivePlayers()) do
		local target = GetPlayerPed(value)
		
		--if(target ~= ply) then
			local targetCoords = GetEntityCoords(target, 0)
			--local distance = Vdist(cx, cy, cz, targetCoords["x"], targetCoords["y"], targetCoords["z"])
			local distance = Vdist(cx, cy, 0, targetCoords["x"], targetCoords["y"], 0)
			if(closestDistance == -1 or closestDistance > distance) then
				closestPlayer = value
				closestDistance = distance
			end
		--end
	end
	return closestPlayer, closestDistance
end


--teleport called by keybinds that forces within 300m of another player. 
RegisterCommand("tpp", function(source, args, rawCommand)


	local waypointBlip = GetFirstBlipInfoId(GetWaypointBlipEnumId())
	
	if waypointBlip == 0 then 
	
		--Notify("~h~~r~No waypoint blip set to teleport to.")
		
		SetNotificationTextEntry('STRING')
		AddTextComponentSubstringPlayerName("~h~~r~No waypoint blip set to teleport to.")
		DrawNotification(false, true)		
		
		
		return 
	end
	
	local blipPos = GetBlipInfoIdCoord(waypointBlip) -- GetGpsWaypointRouteEnd(false, 0, 0)
	
	local closestPlayer, closestDistance = GetClosestPlayerToCoord(blipPos.x, blipPos.y,0);
	
	if closestDistance < maxplayerdistance then 
		local z = GetHeightmapTopZForPosition(blipPos.x, blipPos.y)
		local _, gz = GetGroundZFor_3dCoord(blipPos.x, blipPos.y, z, true)
		
		local vehicle = GetVehiclePedIsIn(PlayerPedId(), false) 
		if vehicle == 0 then
			

			SetEntityCoords(PlayerPedId(), blipPos.x, blipPos.y, z, true, false, false, false)
			FreezeEntityPosition(PlayerPedId(), true)

			repeat
				Citizen.Wait(50)
				_, gz = GetGroundZFor_3dCoord(blipPos.x, blipPos.y, z, true)
			until gz ~= 0
			
		

			SetEntityCoords(PlayerPedId(), blipPos.x, blipPos.y, gz, true, false, false, false)
			FreezeEntityPosition(PlayerPedId(), false)
			
			SetNotificationTextEntry('STRING')
			AddTextComponentSubstringPlayerName("~h~~g~Teleported to player")
			DrawNotification(false, true)			
			
			
		else 
		

			SetEntityCoords(vehicle, blipPos.x, blipPos.y, z, true, false, false, false)
			FreezeEntityPosition(vehicle, true)
			
			repeat
				Citizen.Wait(50)
				_, gz = GetGroundZFor_3dCoord(blipPos.x, blipPos.y, z, true)
			until gz ~= 0
			
			

			SetEntityCoords(vehicle, blipPos.x, blipPos.y, gz, true, false, false, false)
			FreezeEntityPosition(vehicle, false)
			
			SetNotificationTextEntry('STRING')
			AddTextComponentSubstringPlayerName("~h~~g~Teleported to player")
			DrawNotification(false, true)						
			
			
		end
	else
		--Notify("~h~~r~Waypoint location need to be within "..maxplayerdistance.."m of a player to teleport.")
		SetNotificationTextEntry('STRING')
		AddTextComponentSubstringPlayerName("~h~~r~Waypoint location needs to be within "..maxplayerdistance.."m of a player to teleport.")
		DrawNotification(false, true)			
		
	end
	
end, false)



RegisterCommand("tp", function(source, args, rawCommand)

	local waypointBlip = GetFirstBlipInfoId(GetWaypointBlipEnumId())
	local blipPos = GetBlipInfoIdCoord(waypointBlip) -- GetGpsWaypointRouteEnd(false, 0, 0)
	
	local z = GetHeightmapTopZForPosition(blipPos.x, blipPos.y)
	local _, gz = GetGroundZFor_3dCoord(blipPos.x, blipPos.y, z, true)
	
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false) 
	print ("vehicle"..tostring(vehicle ))
	if vehicle == 0 then
		
		SetEntityCoords(PlayerPedId(), blipPos.x, blipPos.y, z, true, false, false, false)
		FreezeEntityPosition(PlayerPedId(), true)

		repeat
			Citizen.Wait(50)
			_, gz = GetGroundZFor_3dCoord(blipPos.x, blipPos.y, z, true)
		until gz ~= 0

		SetEntityCoords(PlayerPedId(), blipPos.x, blipPos.y, gz, true, false, false, false)
		FreezeEntityPosition(PlayerPedId(), false)
		
	else 
	
		
		SetEntityCoords(vehicle, blipPos.x, blipPos.y, z, true, false, false, false)
		FreezeEntityPosition(vehicle, true)
		
		repeat
			Citizen.Wait(50)
			_, gz = GetGroundZFor_3dCoord(blipPos.x, blipPos.y, z, true)
		until gz ~= 0

		SetEntityCoords(vehicle, blipPos.x, blipPos.y, gz, true, false, false, false)
		FreezeEntityPosition(vehicle, false)
		
	
	end
	
	
end, false)


RegisterCommand("tpv", function(source, args, rawCommand)
	local waypointBlip = GetFirstBlipInfoId(GetWaypointBlipEnumId())
	local blipPos = GetBlipInfoIdCoord(waypointBlip) -- GetGpsWaypointRouteEnd(false, 0, 0)

	local z = GetHeightmapTopZForPosition(blipPos.x, blipPos.y)
	local _, gz = GetGroundZFor_3dCoord(blipPos.x, blipPos.y, z, true)

	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false) 
	SetEntityCoords(vehicle, blipPos.x, blipPos.y, z, true, false, false, false)
	FreezeEntityPosition(vehicle, true)
	
	repeat
		Citizen.Wait(50)
		_, gz = GetGroundZFor_3dCoord(blipPos.x, blipPos.y, z, true)
	until gz ~= 0

	SetEntityCoords(vehicle, blipPos.x, blipPos.y, gz, true, false, false, false)
	FreezeEntityPosition(vehicle, false)
	
        --if IsPedInAnyVehicle(PlayerPedId(), false) then
        --	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		--if GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId()), -1) == PlayerPedId() then 
  		--	SetEntityCoords(vehicle, X, Y, Z)
		--else
  		--	SetEntityCoords(PlayerPedId(), X, Y, Z)
		--end
        --	else
        	--	SetEntityCoords(PlayerPedId(), X, Y, Z)
       -- end
		
		
end)


Citizen.CreateThread(function()
  
   while true do
		Citizen.Wait(0)
		-- teleport to another player: Right stick down + Dpad up 
		if IsControlPressed(0, 27) and IsControlPressed(0, 26) then
			--print('tpp made it')
			ExecuteCommand("tpp")
				
			Wait(3500)
				
		end
	end 
 
 
end)