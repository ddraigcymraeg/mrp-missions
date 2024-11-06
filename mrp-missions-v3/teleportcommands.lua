RegisterCommand("tp", function(source, args, rawCommand)
	local waypointBlip = GetFirstBlipInfoId(GetWaypointBlipEnumId())
	local blipPos = GetBlipInfoIdCoord(waypointBlip) -- GetGpsWaypointRouteEnd(false, 0, 0)

	local z = GetHeightmapTopZForPosition(blipPos.x, blipPos.y)
	local _, gz = GetGroundZFor_3dCoord(blipPos.x, blipPos.y, z, true)

	SetEntityCoords(PlayerPedId(), blipPos.x, blipPos.y, z, true, false, false, false)
	FreezeEntityPosition(PlayerPedId(), true)

	repeat
		Citizen.Wait(50)
		_, gz = GetGroundZFor_3dCoord(blipPos.x, blipPos.y, z, true)
	until gz ~= 0

	SetEntityCoords(PlayerPedId(), blipPos.x, blipPos.y, gz, true, false, false, false)
	FreezeEntityPosition(PlayerPedId(), false)
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