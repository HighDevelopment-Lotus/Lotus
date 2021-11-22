local LSCore = exports['ls-core']:GetCoreObject()

-- Code

RegisterServerEvent('ls-flightschool:server:add:brevet')
AddEventHandler('ls-flightschool:server:add:brevet', function(PlayerId)
    local SourcePlayer = LSCore.Functions.GetPlayer(source)
    local TargetPlayer = LSCore.Functions.GetPlayer(PlayerId)
    if TargetPlayer ~= nil then
        if TargetPlayer.PlayerData.metadata['licences']['flying'] == false or TargetPlayer.PlayerData.metadata['licences']['flying'] == nil then
            TargetPlayer.Functions.SetMetaDataTable('licences', 'flying', true)
            TriggerClientEvent('LSCore:Notify', TargetPlayer.PlayerData.source, "Je ontving een vlieg brevet!", "success")
            TriggerClientEvent('LSCore:Notify', source, "Succesvol een brevet gegeven!", "success")
        else
            TriggerClientEvent('LSCore:Notify', source, "Deze persoon heeft al een brevet..", "error")
        end
    end
end)

LSCore.Commands.Add("setflight", "Neem neen vliegschool medewerker aan", {{name="id", help="Speler ID"}}, true, function(source, args)
    local Player = LSCore.Functions.GetPlayer(source)
    local TargetPlayer = LSCore.Functions.GetPlayer(tonumber(args[1]))
    if Player.PlayerData.metadata['ishighcommand'] and Player.PlayerData.job.name == 'flightschool' then
        if TargetPlayer ~= nil then
            TriggerClientEvent('LSCore:Notify', TargetPlayer.PlayerData.source, 'Je bent aangenomen als vliegschool medewerker! gefeliciteerd!', 'success')
            TriggerClientEvent('LSCore:Notify', Player.PlayerData.source, 'Je hebt '..TargetPlayer.PlayerData.charinfo.firstname..' '..TargetPlayer.PlayerData.charinfo.lastname..' aangenomen als vliegschool medewerker!', 'success')
            TargetPlayer.Functions.SetJob('flightschool')
        end
    end
end)

LSCore.Commands.Add("fireflight", "Ontsla een vliegschool medewerker", {{name="id", help="Speler ID"}}, true, function(source, args)
    local Player = LSCore.Functions.GetPlayer(source)
    local TargetPlayer = LSCore.Functions.GetPlayer(tonumber(args[1]))
    if Player.PlayerData.metadata['ishighcommand'] and Player.PlayerData.job.name == 'flightschool' then
        if TargetPlayer ~= nil and TargetPlayer.PlayerData.job.name == 'flightschool' then
            TriggerClientEvent('LSCore:Notify', TargetPlayer.PlayerData.source, 'Je bent ontslagen!', 'error')
            TriggerClientEvent('LSCore:Notify', Player.PlayerData.source, 'Je hebt '..TargetPlayer.PlayerData.charinfo.firstname..' '..TargetPlayer.PlayerData.charinfo.lastname..' ontslagen!', 'success')
            TargetPlayer.Functions.SetJob('unemployed')
        end
    end
end)