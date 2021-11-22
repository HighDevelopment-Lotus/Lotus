RegisterServerEvent('ls-sound:server:play')
AddEventHandler('ls-sound:server:play', function(clientNetId, soundFile, soundVolume)
    TriggerClientEvent('ls-sound:client:play', clientNetId, soundFile, soundVolume)
end)

RegisterServerEvent('ls-sound:server:play:source')
AddEventHandler('ls-sound:server:play:source', function(soundFile, soundVolume)
    TriggerClientEvent('ls-sound:client:play', source, soundFile, soundVolume)
end)

RegisterServerEvent('ls-sound:server:play:distance')
AddEventHandler('ls-sound:server:play:distance', function(maxDistance, soundFile, soundVolume)
    TriggerClientEvent('ls-sound:client:play:distance', -1, source, maxDistance, soundFile, soundVolume)
end)