local HasScoreboardOpen = false
Framework = nil

-- Code

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
          if IsControlJustPressed(0, 213) then
              if not HasScoreboardOpen then
                  HasScoreboardOpen = true
              end
          end
          if IsControlJustReleased(0, 213) then
              if HasScoreboardOpen then
                  HasScoreboardOpen = false
              end
          end
          if HasScoreboardOpen then
              for _, player in pairs(GetPlayersFromCoords(GetEntityCoords(GetPlayerPed(-1)), 10.0)) do
                  local PlayerId = GetPlayerServerId(player)
                  local PlayerPed = GetPlayerPed(player)
                  local PlayerName = GetPlayerName(player)
                  local PlayerCoords = GetEntityCoords(PlayerPed)
                  DrawText3D(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z + 1.0, '['..PlayerId..']')
              end
          end
        end
    end
end)

function GetPlayers()
    local players = {}
    for _, player in ipairs(GetActivePlayers()) do
        local ped = GetPlayerPed(player)
        if DoesEntityExist(ped) then
            table.insert(players, player)
        end
    end
    return players
end

function GetPlayersFromCoords(coords, distance)
    local players = GetPlayers()
    local closePlayers = {}
    if coords == nil then
		coords = GetEntityCoords(GetPlayerPed(-1))
    end
    if distance == nil then
        distance = 5.0
    end
    for _, player in pairs(players) do
		local target = GetPlayerPed(player)
		local targetCoords = GetEntityCoords(target)
		local targetdistance = GetDistanceBetweenCoords(targetCoords, coords.x, coords.y, coords.z, true)
		if targetdistance <= distance then
			table.insert(closePlayers, player)
		end
    end
    return closePlayers
end

function DrawText3D(x, y, z, text)
  SetTextScale(0.35, 0.35)
  SetTextFont(4)
  SetTextProportional(1)
  SetTextColour(255, 255, 255, 215)
  SetTextEntry("STRING")
  SetTextCentre(true)
  AddTextComponentString(text)
  SetDrawOrigin(x,y,z, 0)
  DrawText(0.0, 0.0)
  ClearDrawOrigin()
end