local LSCore = exports['ls-core']:GetCoreObject()

-- Code

LSCore.Functions.CreateCallback("ls-doors:server:get:config", function(source, cb)
    cb(Config)
end)

RegisterServerEvent('ls-doors:server:set:door:locks')
AddEventHandler('ls-doors:server:set:door:locks', function(DoorId, DoorState)
    Config.Doors[DoorId]['LockState'] = DoorState
    TriggerClientEvent('ls-doors:client:sync:doors', -1, DoorId, DoorState, Config.Doors[DoorId])
end)