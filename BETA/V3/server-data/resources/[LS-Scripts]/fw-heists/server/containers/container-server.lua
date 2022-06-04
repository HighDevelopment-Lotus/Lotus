LSCore = exports['fw-base']:GetCoreObject()

-- Events

RegisterNetEvent('framework-containers:server:set:containers:busy', function(PlantId, bool)
    Config.Places['containers'][PlantId]['IsBezig'] = bool
    TriggerClientEvent('framework-containers:client:set:containers:busy', -1, PlantId, bool)
end)

RegisterNetEvent('framework-containers:server:set:picked:state', function(PlantId, bool)
    Config.Places['containers'][PlantId]['Geknipt'] = bool
    TriggerClientEvent('framework-containers:client:set:picked:state', -1, PlantId, bool)
end)

RegisterNetEvent('framework-containers:server:give:copper', function()
    local Player = LSCore.Functions.GetPlayer(source)
    Player.Functions.AddItem('copper', math.random(2,4), false, false, true)
end)

-- Threads

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        for k, v in pairs(Config.Places['containers']) do
            if Config.Places['containers'][k]['Geknipt'] then
                Citizen.Wait(30000)
                Config.Places['containers'][k]['Geknipt'] = false
                TriggerClientEvent('framework-containers:client:set:picked:state', -1, k, false)
            end
        end
    end
end)