local LSCore = exports['ls-core']:GetCoreObject()

-- Code

RegisterServerEvent('ls-trains:server:set:busy')
AddEventHandler('ls-trains:server:set:busy', function(Bool)
    Config.TrainData['Busy'] = Bool
    TriggerClientEvent('ls-trains:client:sync:busy', -1, Bool)
end)