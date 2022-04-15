local LSCore = exports['fw-base']:GetCoreObject()

LSCore.Functions.CreateCallback('framework-emergencylights:server:get:config', function(source, cb)
    cb(Config)
end)

RegisterServerEvent('framework-emergencylights:server:setup:first:time')
AddEventHandler('framework-emergencylights:server:setup:first:time', function(Plate)
    Config.ButtonData[Plate] = {
        ['Blue'] = false,
        ['Orange'] = false,
        ['Green'] = false,
        ['Stop'] = false,
        ['Follow'] = false,
        ['Siren'] = false,
        ['Pit'] = false,
    }
    TriggerClientEvent('framework-emergencylights:client:sync', -1, Config.ButtonData)
end)

RegisterServerEvent('framework-emergencylights:server:update:button')
AddEventHandler('framework-emergencylights:server:update:button', function(Data, Plate)
    Config.ButtonData[Plate][Data.Type] = Data.State
    TriggerClientEvent('framework-emergencylights:client:update:button', -1, Data, Plate)
end)

RegisterServerEvent('framework-emergencylights:server:toggle:sounds')
AddEventHandler('framework-emergencylights:server:toggle:sounds', function(State)
    TriggerClientEvent('framework-emergencylights:client:toggle:sounds', -1, source, State)
end)

RegisterServerEvent('framework-emergencylights:server:set:sounds:disabled')
AddEventHandler('framework-emergencylights:server:set:sounds:disabled', function()
    TriggerClientEvent('framework-emergencylights:client:set:sounds:disabled', -1, source)
end)

RegisterServerEvent('framework-emergencylights:server:set:lights')
AddEventHandler('framework-emergencylights:server:set:lights', function(Vehicle, Plate, Data)
    TriggerClientEvent('framework-emergencylights:client:set:lights', -1, Vehicle, Plate, Data)
end)