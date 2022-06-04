LSCore = exports['fw-base']:GetCoreObject()

-- Events

RegisterNetEvent('framework-copper:server:set:palen:busy', function(PlantId, bool)
    Config.Places['palen'][PlantId]['IsBezig'] = bool
    TriggerClientEvent('framework-copper:client:set:palen:busy', -1, PlantId, bool)
end)

RegisterNetEvent('framework-copper:server:set:picked:state', function(PlantId, bool)
    Config.Places['palen'][PlantId]['Geknipt'] = bool
    TriggerClientEvent('framework-copper:client:set:picked:state', -1, PlantId, bool)
end)

RegisterNetEvent('framework-copper:server:give:copper', function()
    local Player = LSCore.Functions.GetPlayer(source)
    Player.Functions.AddItem('copper', math.random(2,4), false, false, true)
end)

-- Threads

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        for k, v in pairs(Config.Places['palen']) do
            if Config.Places['palen'][k]['Geknipt'] then
                Citizen.Wait(30000)
                Config.Places['palen'][k]['Geknipt'] = false
                TriggerClientEvent('framework-copper:client:set:picked:state', -1, k, false)
            end
        end
    end
end)