local LSCore = exports['ls-core']:GetCoreObject()

-- Code

RegisterServerEvent('ls-unicorn:server:set:effect')
AddEventHandler('ls-unicorn:server:set:effect', function(data)
    Config.CurrentEffect = {['Dict'] = data['Dict'], ['Effect'] = data['Effect']}
    TriggerClientEvent('ls-unicorn:client:sync:config', -1, Config)
end)

RegisterServerEvent('ls-stripclub:server:close:effect')
AddEventHandler('ls-stripclub:server:close:effect', function()
    Config.CurrentEffect = {['Dict'] = nil, ['Effect'] = nil}
    TriggerClientEvent('ls-unicorn:client:stop:effects', -1)
    TriggerClientEvent('ls-unicorn:client:sync:config', -1, Config)
end)