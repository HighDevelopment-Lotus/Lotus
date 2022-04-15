RegisterServerEvent('framework-sound:server:play')
AddEventHandler('framework-sound:server:play', function(clientNetId, soundFile, soundVolume)
    TriggerClientEvent('framework-sound:client:play', clientNetId, soundFile, soundVolume)
end)

RegisterServerEvent('framework-sound:server:play:source')
AddEventHandler('framework-sound:server:play:source', function(soundFile, soundVolume)
    TriggerClientEvent('framework-sound:client:play', source, soundFile, soundVolume)
end)

RegisterServerEvent('framework-sound:server:play:distance')
AddEventHandler('framework-sound:server:play:distance', function(maxDistance, soundFile, soundVolume)
    TriggerClientEvent('framework-sound:client:play:distance', -1, source, maxDistance, soundFile, soundVolume)
end)