RegisterServerEvent('ls-heists:server:bobcat:set:door:thermited')
AddEventHandler('ls-heists:server:bobcat:set:door:thermited', function(Bool)
    Config.MainDoorsThermited = Bool
    if Bool then
        TriggerEvent('ls-doors:server:set:door:locks', 107, 0)
        TriggerEvent('ls-doors:server:set:door:locks', 108, 0)
        TriggerEvent('ls-heists:server:bobcat:start:reset')
        TriggerEvent('ls-heists:server:do:police:alert')
    else
        TriggerEvent('ls-doors:server:set:door:locks', 107, 1)
        TriggerEvent('ls-doors:server:set:door:locks', 108, 1)
    end
    TriggerClientEvent('ls-heists:server:bobcat:set:door:thermited', -1, Config.MainDoorsThermited)
end)

RegisterServerEvent('ls-heists:server:bobcat:set:door:card')
AddEventHandler('ls-heists:server:bobcat:set:door:card', function(Bool)
    Config.SecondDoorsUsedCard = Bool
    if Bool then
        TriggerClientEvent('ls-heists:server:bobcat:set:trollys', source)
        TriggerEvent('ls-doors:server:set:door:locks', 110, 0)
        TriggerEvent('ls-doors:server:set:door:locks', 111, 0)
        TriggerEvent('ls-heists:server:do:police:alert')
    else
        TriggerEvent('ls-doors:server:set:door:locks', 110, 1)
        TriggerEvent('ls-doors:server:set:door:locks', 111, 1)
    end
    TriggerClientEvent('ls-heists:server:bobcat:set:door:card', -1, Config.SecondDoorsUsedCard)
end)

RegisterServerEvent('ls-heists:server:bobcat:set:vault:door')
AddEventHandler('ls-heists:server:bobcat:set:vault:door', function(Bool)
    if Bool then
        TriggerClientEvent('ls-heists:client:bobcat:set:map', -1, 'Exploded')
    else
        TriggerClientEvent('ls-heists:client:bobcat:set:map', -1, 'Clean')
    end
    Config.IsBobcatExploded = Bool
end)

RegisterServerEvent('ls-heists:server:do:police:alert')
AddEventHandler('ls-heists:server:do:police:alert', function()
    TriggerEvent('ls-police:server:send:bobcat:alert', vector3(Config.MainDoorsCoords.x, Config.MainDoorsCoords.y, Config.MainDoorsCoords.z), 'Cypress Flats')
end)

RegisterServerEvent('ls-heists:server:bobcat:explosion')
AddEventHandler('ls-heists:server:bobcat:explosion', function()
    TriggerClientEvent('ls-heists:client:bobcat:explosion', -1)
end)

RegisterServerEvent('ls-heists:server:bobcat:start:reset')
AddEventHandler('ls-heists:server:bobcat:start:reset', function()
    Citizen.SetTimeout((1000 * 60) * 300, function() -- 5 Uur cooldown
        TriggerEvent('ls-heists:server:bobcat:set:vault:door', false)
        TriggerEvent('ls-heists:server:bobcat:set:door:thermited', false)
        TriggerEvent('ls-heists:server:bobcat:set:door:card', false)
        TriggerEvent('ls-doors:server:set:door:locks', 109, 1)
    end)
end)