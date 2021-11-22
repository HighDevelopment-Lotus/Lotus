local LSCore, LoggedIn, CurrentDealer = exports['ls-core']:GetCoreObject(), false, nil

RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(450, function() 
        LSCore.Functions.TriggerCallback("ls-dealers:server:get:config", function(ConfigData)
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
                local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
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

RegisterNetEvent('ls-dealers:client:open:dealer')
AddEventHandler('ls-dealers:client:open:dealer', function()
    Citizen.SetTimeout(350, function()
        if CurrentDealer ~= nil then 
            if exports['ls-inventory-new']:CanOpenInventory() then
                local Shop = {['Type'] = 'Store', ['ExtraData'] = CurrentDealer, ['SubType'] = 'DealerDealer', ['InvName'] = Config.Dealers[CurrentDealer]['Name'], ['Items'] = Config.Dealers[CurrentDealer]['Products']}
                TriggerServerEvent('ls-inventory-new:server:open:inventory:other', Shop, 'Store')
            end
        end
    end)
end)

RegisterNetEvent('ls-dealers:client:set:dealer:items')
AddEventHandler('ls-dealers:client:set:dealer:items', function(ItemData)
    Config.Dealers = ItemData
end)

function CanOpenDealerShop()
    if CurrentDealer ~= nil then
        return true
    end
end