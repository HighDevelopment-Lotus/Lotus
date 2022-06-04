local LSCore, LoggedIn, CurrentDealer = exports['fw-base']:GetCoreObject(), false, nil

RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(450, function() 
        LSCore.Functions.TriggerCallback("framework-dealers:server:get:config", function(ConfigData)
            Config.Dealers = ConfigData
        end)
        LoggedIn = true
    end)
end)

RegisterNetEvent('LSCore:Client:OnPlayerUnload')
AddEventHandler('LSCore:Client:OnPlayerUnload', function()
    LoggedIn = false
end)

-- Code

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            NearDealer = false
            for k, v in pairs(Config.Dealers) do 
                local PlayerCoords = GetEntityCoords(PlayerPedId())
                local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'], true)
                if Distance < 2.0 then 
                    NearDealer = true
	    	        DrawMarker(2, v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                    CurrentDealer = k
                end
            end
            if not NearDealer then
               Citizen.Wait(2500)
               CurrentDealer = nil
            end
        end
    end
end)

RegisterNetEvent('framework-dealers:client:open:dealer')
AddEventHandler('framework-dealers:client:open:dealer', function()
    Citizen.SetTimeout(350, function()
        if CurrentDealer ~= nil then 
            if exports['fw-inv']:CanOpenInventory() then
                local Shop = {['Type'] = 'Store', ['ExtraData'] = CurrentDealer, ['SubType'] = 'DealerDealer', ['InvName'] = Config.Dealers[CurrentDealer]['Name'], ['Items'] = Config.Dealers[CurrentDealer]['Products']}
                TriggerServerEvent('framework-inv:server:open:inventory:other', Shop, 'Store')
            end
        end
    end)
end)

RegisterNetEvent('framework-oudeheer:client:openmenu')
AddEventHandler('framework-oudeheer:client:openmenu', function()
    -- Citizen.SetTimeout(350, function()
        local player, distance = LSCore.Functions.GetClosestPlayer()
        if player ~= -1 and distance < 5.0 then
            local playerId = GetPlayerServerId(player)
            isHealingPerson = true
            LSCore.Functions.Progressbar("hospital_revive", "Persoon omhoog helpen..", 5000, false, true, {
                disableMovement = false,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = true,
            }, {
                animDict = healAnimDict,
                anim = healAnim,
                flags = 16,
            }, {}, {}, function() -- Done
                isHealingPerson = false
                StopAnimTask(PlayerPedId(), healAnimDict, "exit", 1.0)
                LSCore.Functions.Notify("Je hebt de persoon geholpen!")
                TriggerServerEvent("framework-hospital:server:revive:player", playerId, true)
            end, function() -- Cancel
                isHealingPerson = false
                StopAnimTask(PlayerPedId(), healAnimDict, "exit", 1.0)
                LSCore.Functions.Notify("Mislukt!", "error")
            end)
        else
            LSCore.Functions.Notify("Er is niemand in de buurt..", "error")
        end
    -- end)
end)

RegisterNetEvent('framework-dealers:client:set:dealer:items')
AddEventHandler('framework-dealers:client:set:dealer:items', function(ItemData)
    Config.Dealers = ItemData
end)

function CanOpenDealerShop()
    if CurrentDealer ~= nil then
        return true
    end
end