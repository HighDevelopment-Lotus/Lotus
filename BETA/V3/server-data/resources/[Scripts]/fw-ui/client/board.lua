-- LSCore = exports["fw-base"]:GetCoreObject()

-- RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
-- AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
--     -- isLoggedIn = true

--     LSCore.Functions.TriggerCallback('framework-board:server:GetConfig', function(config)
--         Config.IllegalActions = config
--     end)
-- end)

local scoreboardOpen = false

local PlayerOptin = {}
DrawText3D = function(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

GetClosestPlayer = function()
    local closestPlayers = LSCore.Functions.GetPlayersFromCoords()
    local closestDistance = -1
    local closestPlayer = -1
    local coords = GetEntityCoords(PlayerPedId())

    for i=1, #closestPlayers, 1 do
        if closestPlayers[i] ~= PlayerId() then
            local pos = GetEntityCoords(GetPlayerPed(closestPlayers[i]))
            local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, coords.x, coords.y, coords.z, true)

            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = closestPlayers[i]
                closestDistance = distance
            end
        end
	end

	return closestPlayer, closestDistance
end

GetPlayers = function()
    local players = {}
    for _, player in ipairs(GetActivePlayers()) do
        local ped = GetPlayerPed(player)
        if DoesEntityExist(ped) then
            table.insert(players, player)
        end
    end
    return players
end

GetPlayersFromCoords = function(coords, distance)
    local players = GetPlayers()
    local closePlayers = {}

    if coords == nil then
		coords = GetEntityCoords(PlayerPedId())
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

RegisterKeyMapping('scoreboard', 'Scoreboard', 'keyboard', 'HOME')

RegisterCommand('scoreboard', function()
    if not scoreboardOpen then
        LSCore.Functions.TriggerCallback('framework-board:server:GetPlayersArrays', function(playerList)
            LSCore.Functions.TriggerCallback('kwk-scoreboard:server:GetActivity', function(cops, ambulance, autocare)
                    PlayerOptin = playerList
                    Config.CurrentCops = cops
                    Config.CurrentAmbus = ambulance

                    SendNUIMessage({
                        action = "open",
                        players = GetCurrentPlayers(),
                        maxPlayers = Config.MaxPlayers,
                        requiredCops = Config.IllegalActions,
                        currentCops = Config.CurrentCops,
                        currentAmbus = Config.CurrentAmbus,
                    })
                    scoreboardOpen = true
            end)
        end)
    end
    if scoreboardOpen then
            SendNUIMessage({
                action = "close",
            })
            scoreboardOpen = false
    end

    if scoreboardOpen then
        for _, player in pairs(GetPlayersFromCoords(GetEntityCoords(PlayerPedId()), 10.0)) do
            local PlayerId = GetPlayerServerId(player)
            local PlayerPed = GetPlayerPed(player)
            local PlayerName = GetPlayerName(player)
            local PlayerCoords = GetEntityCoords(PlayerPed)
            
            if not PlayerOptin[PlayerId].permission then
                DrawText3D(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z + 1.0, '['..PlayerId..']')
            end
        end
    end
end, false)

function GetCurrentPlayers()
    local TotalPlayers = 0

    for _, player in ipairs(GetActivePlayers()) do
        TotalPlayers = TotalPlayers + 1
    end
    -- LSCore.Functions.TriggerCallback('framework-board:server:GetPlayers', function()
    -- end) 
    return TotalPlayers
end

RegisterNetEvent('framework-board:client:SetActivityBusy')
AddEventHandler('framework-board:client:SetActivityBusy', function(activity, busy)
    Config.IllegalActions[activity].busy = busy
end)