LSCore, LoggedIn = exports['ls-core']:GetCoreObject(), false

RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1250, function()
        LSCore.Functions.TriggerCallback('ls-illegal:server:get:config', function(ConfigData)
            Config = ConfigData
        end)
        Citizen.Wait(350)
        LoggedIn = true
    end)
end)

RegisterNetEvent('LSCore:Client:OnPlayerUnload')
AddEventHandler('LSCore:Client:OnPlayerUnload', function()
    LoggedIn = false
end)

-- Code

-- // Loops \\ --


-- // Events \\ --

RegisterNetEvent('ls-illegal:client:open:selling:other')
AddEventHandler('ls-illegal:client:open:selling:other', function()
    if exports['ls-inventory-new']:CanOpenInventory() then
        TriggerServerEvent('ls-inventory-new:server:open:inventory:other', "Inkoper: 2", 'TempStashes', 5, 1000000)
    end
end)

-- // Functions \\ --

function GetActiveServerPlayers()
    local PlayerPeds = {}
    if next(PlayerPeds) == nil then
        for _, Player in ipairs(GetActivePlayers()) do
            local PlayerPed = GetPlayerPed(Player)
            table.insert(PlayerPeds, PlayerPed)
        end
        return PlayerPeds
    end
end

