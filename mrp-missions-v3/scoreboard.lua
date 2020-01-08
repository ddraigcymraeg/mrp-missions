local listOn = false
function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

Citizen.CreateThread(function()
    listOn = false
    while true do
        Wait(0)

        if IsControlPressed(0, 27)--[[ INPUT_PHONE ]] then
            if not listOn then
                
				if not IsPlayerFreeAiming(PlayerId()) then
				
					local players = {}
					ptable = GetPlayers()
					for _, i in ipairs(ptable) do
						--local wantedLevel = GetPlayerWantedLevel(i)
						local totalMoney = DecorGetInt(GetPlayerPed(i),"mrpplayermoney")
						local totalMissions = DecorGetInt(GetPlayerPed(i),"mrpplayermissioncount")
						if totalMissions == 0 then totalMissions = 1 end
						local moneypermission = round((totalMoney/totalMissions),2) 
						r, g, b = GetPlayerRgbColour(i)
						table.insert(players, 
						'<tr style=\"color: rgb(' .. r .. ', ' .. g .. ', ' .. b .. ')\"><td>' .. sanitize(GetPlayerName(i)) .. '</td><td>' .. tostring(totalMissions) .. '</td><td>$' .. (tostring(totalMoney)) .. '</td><td>$' .. (string.format("%.2f",tostring(moneypermission))) .. '</td></tr>'
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
