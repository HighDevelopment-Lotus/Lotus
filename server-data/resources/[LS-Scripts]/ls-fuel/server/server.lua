local LSCore = exports['ls-core']:GetCoreObject()

-- Code

LSCore.Functions.CreateCallback("ls-fuel:server:get:fuel:config", function(source, cb)
    cb(Config)
end)

RegisterServerEvent('ls-fuel:server:set:fuel')
AddEventHandler('ls-fuel:server:set:fuel', function(Plate, Vehicle, Amount)
    Config.VehicleFuel[Plate] = Amount
    TriggerClientEvent('ls-fuel:client:sync:vehicle:fuel', -1, Plate, Config.VehicleFuel[Plate])
end)