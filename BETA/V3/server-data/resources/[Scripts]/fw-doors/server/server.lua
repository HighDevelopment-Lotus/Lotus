local LSCore = exports['fw-base']:GetCoreObject()

-- Code

LSCore.Functions.CreateCallback("framework-doors:server:get:config", function(source, cb)
    cb(Config)
end)

RegisterServerEvent('framework-doors:server:set:door:locks')
AddEventHandler('framework-doors:server:set:door:locks', function(DoorId, DoorState)
    Config.Doors[DoorId]['LockState'] = DoorState
    TriggerClientEvent('framework-doors:client:sync:doors', -1, DoorId, DoorState, Config.Doors[DoorId])
end)