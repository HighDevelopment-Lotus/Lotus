local LSCore = exports['ls-core']:GetCoreObject()

LSCore.Functions.CreateCallback('ls-emergencylights:server:get:config', function(source, cb)
    cb(Config)
end)

RegisterServerEvent('ls-emergencylights:server:setup:first:time')
AddEventHandler('ls-emergencylights:server:setup:first:time', function(Plate)
    Config.ButtonData[Plate] = {
        ['Blue'] = false,
        ['Orange'] = false,
        ['Green'] = false,
        ['Stop'] = false,
        ['Follow'] = false,
        ['Siren'] = false,
        ['Pit'] = false,
    }
    TriggerClientEvent('ls-emergencylights:client:sync', -1, Config.ButtonData)
end)

RegisterServerEvent('ls-emergencylights:server:update:button')
AddEventHandler('ls-emergencylights:server:update:button', function(Data, Plate)
    Config.ButtonData[Plate][Data.Type] = Data.State
    TriggerClientEvent('ls-emergencylights:client:update:button', -1, Data, Plate)
end)

RegisterServerEvent('ls-emergencylights:server:toggle:sounds')
AddEventHandler('ls-emergencylights:server:toggle:sounds', function(State)
    TriggerClientEvent('ls-emergencylights:client:toggle:sounds', -1, source, State)
end)

RegisterServerEvent('ls-emergencylights:server:set:sounds:disabled')
AddEventHandler('ls-emergencylights:server:set:sounds:disabled', function()
    TriggerClientEvent('ls-emergencylights:client:set:sounds:disabled', -1, source)
end)

RegisterServerEvent('ls-emergencylights:server:set:lights')
AddEventHandler('ls-emergencylights:server:set:lights', function(Vehicle, Plate, Data)
    TriggerClientEvent('ls-emergencylights:client:set:lights', -1, Vehicle, Plate, Data)
end)