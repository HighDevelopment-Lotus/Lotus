RegisterServerEvent('framework-heists:server:bobcat:set:door:thermited')
AddEventHandler('framework-heists:server:bobcat:set:door:thermited', function(Bool)
    Config.MainDoorsThermited = Bool
    if Bool then
        TriggerEvent('framework-doors:server:set:door:locks', 107, 0)
        TriggerEvent('framework-doors:server:set:door:locks', 108, 0)
        TriggerEvent('framework-heists:server:bobcat:start:reset')
        TriggerEvent('framework-heists:server:do:police:alert')
    else
        TriggerEvent('framework-doors:server:set:door:locks', 107, 1)
        TriggerEvent('framework-doors:server:set:door:locks', 108, 1)
    end
    TriggerClientEvent('framework-heists:server:bobcat:set:door:thermited', -1, Config.MainDoorsThermited)
end)

RegisterServerEvent('framework-heists:server:bobcat:set:door:card')
AddEventHandler('framework-heists:server:bobcat:set:door:card', function(Bool)
    Config.SecondDoorsUsedCard = Bool
    if Bool then
        TriggerClientEvent('framework-heists:server:bobcat:set:trollys', source)
        TriggerEvent('framework-doors:server:set:door:locks', 110, 0)
        TriggerEvent('framework-doors:server:set:door:locks', 111, 0)
        TriggerEvent('framework-heists:server:do:police:alert')
    else
        TriggerEvent('framework-doors:server:set:door:locks', 110, 1)
        TriggerEvent('framework-doors:server:set:door:locks', 111, 1)
    end
    TriggerClientEvent('framework-heists:server:bobcat:set:door:card', -1, Config.SecondDoorsUsedCard)
end)

RegisterServerEvent('framework-heists:server:bobcat:set:vault:door')
AddEventHandler('framework-heists:server:bobcat:set:vault:door', function(Bool)
    if Bool then
        TriggerClientEvent('framework-heists:client:bobcat:set:map', -1, 'Exploded')
    else
        TriggerClientEvent('framework-heists:client:bobcat:set:map', -1, 'Clean')
    end
    Config.IsBobcatExploded = Bool
end)

RegisterServerEvent('framework-heists:server:do:police:alert')
AddEventHandler('framework-heists:server:do:police:alert', function()
    TriggerEvent('framework-police:server:send:bobcat:alert', vector3(Config.MainDoorsCoords.x, Config.MainDoorsCoords.y, Config.MainDoorsCoords.z), 'Cypress Flats')
end)

RegisterServerEvent('framework-heists:server:bobcat:explosion')
AddEventHandler('framework-heists:server:bobcat:explosion', function()
    TriggerClientEvent('framework-heists:client:bobcat:explosion', -1)
end)

RegisterServerEvent('framework-heists:server:bobcat:start:reset')
AddEventHandler('framework-heists:server:bobcat:start:reset', function()
    Citizen.SetTimeout((1000 * 60) * 300, function() -- 5 Uur cooldown
        TriggerEvent('framework-heists:server:bobcat:set:vault:door', false)
        TriggerEvent('framework-heists:server:bobcat:set:door:thermited', false)
        TriggerEvent('framework-heists:server:bobcat:set:door:card', false)
        TriggerEvent('framework-doors:server:set:door:locks', 109, 1)
    end)
end)