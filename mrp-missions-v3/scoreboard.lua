local listOn = false

--1 = By Total Money, 2 = Money per Mission
local sortType=2

function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end


function getKeysSortedByValue(tbl, sortFunction)
  local keys = {}
  for key in pairs(tbl) do
    table.insert(keys, key)
  end

  table.sort(keys, function(a, b)
	if sortType==2 then
		return sortFunction(tonumber(tbl[a]["MoneyPerMission"]), tonumber(tbl[b]["MoneyPerMission"]))
	elseif sortType==1 then
		return sortFunction(tonumber(tbl[a]["TotalMoney"]), tonumber(tbl[b]["TotalMoney"]))
	end
  end)

  return keys
end

Citizen.CreateThread(function()
    listOn = false
    while true do
        Wait(0)

        if IsControlPressed(0, 27)--[[ INPUT_PHONE ]] then
            if not listOn then
                
				if not IsPlayerFreeAiming(PlayerId()) then
				
					local players = {}
					local allstats = {}
					ptable = GetPlayers()
					for _, i in ipairs(ptable) do
						
						--local wantedLevel = GetPlayerWantedLevel(i)
						local totalMoney = DecorGetInt(GetPlayerPed(i),"mrpplayermoney")
						local totalMissions = DecorGetInt(GetPlayerPed(i),"mrpplayermissioncount")
						if totalMissions == 0 then totalMissions = 1 end
						local moneypermission = round((totalMoney/totalMissions),2) 
						--if 
						--r, g, b = GetPlayerRgbColour(i)
						--table.insert(players, 
					--	'<tr style=\"color: rgb(' .. r .. ', ' .. g .. ', ' .. b .. ')\"><td>' .. sanitize(GetPlayerName(i)) .. '</td><td>' .. tostring(totalMissions) .. '</td><td>$' .. (tostring(totalMoney)) .. '</td><td>$' .. (string.format("%.2f",tostring(moneypermission))) .. '</td></tr>'
					--	)
						-- player name, total money, totalmissions, moneypermission,isplayer 
						local isplayer = 0 
						if GetPlayerPed(i) == GetPlayerPed(-1) then
							isplayer=1
						end
						local stats = {Name=sanitize(GetPlayerName(i)),TotalMoney=tostring(totalMoney),TotalMissions=tostring(totalMissions),MoneyPerMission=(string.format("%.2f",tostring(moneypermission))),isplayer=isplayer,playerindex=i}
						table.insert(allstats,stats)
					end
					
					
					local sortedKeys = getKeysSortedByValue(allstats, function(a, b) return a > b end)
					for _, key in ipairs(sortedKeys) do
						print(key, allstats[key]["MoneyPerMission"])
					r, g, b = GetPlayerRgbColour(allstats[key]["playerindex"])
					table.insert(players, 
						'<tr style=\"color: rgb(' .. r .. ', ' .. g .. ', ' .. b .. ')\"><td>' .. allstats[key]["Name"] .. '</td><td>' .. allstats[key]["TotalMissions"] .. '</td><td>$' .. allstats[key]["TotalMoney"] .. '</td><td>$' .. allstats[key]["MoneyPerMission"] .. '</td></tr>'
						)
					
					end
					
					SendNUIMessage({ text = table.concat(players) })

					listOn = true
					while listOn do
						Wait(0)
						if(IsControlPressed(0, 27) == false) then
							listOn = false
							SendNUIMessage({
								meta = 'close'
							})
							break
						end
					end
				end
            end
			
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

function sanitize(txt)
    local replacements = {
        ['&' ] = '&amp;', 
        ['<' ] = '&lt;', 
        ['>' ] = '&gt;', 
        ['\n'] = '<br/>'
    }
    return txt
        :gsub('[&<>\n]', replacements)
        :gsub(' +', function(s) return ' '..('&nbsp;'):rep(#s-1) end)
end
