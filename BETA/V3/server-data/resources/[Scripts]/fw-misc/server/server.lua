local LSCore = exports['fw-base']:GetCoreObject()

RegisterNetEvent('framework-ui:server:addskill')
AddEventHandler('framework-ui:server:addskill', function(skill, punten)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
	if Player ~= nil then
        -- if skill ~= nil and punten ~= nil then
            Player.Functions.SetMetaData(skill, Player.PlayerData.metadata[skill] + punten)
            TriggerClientEvent('LSCore:Notify', src, 'Reputatie gekregen', 'primary')
        -- end
    end
end)

RegisterNetEvent('framework-ui:server:removeskill')
AddEventHandler('framework-ui:server:removeskill', function(skill, punten)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
	if Player ~= nil then
        -- if skill ~= nil and punten ~= nil then
            Player.Functions.SetMetaData(skill, Player.PlayerData.metadata[skill] - punten)
            TriggerClientEvent('LSCore:Notify', src, 'Reputatie verloren', 'primary')
        -- end
    end
end)

LSCore.Commands.Add("c-dance", "stop met dansen", {}, false, function(source, args)
    TriggerClientEvent('framework-dances:client:clear:dance', source)
end)

LSCore.Commands.Add("dance", "Eventjes lekker dansen", {{name="number", help="een nummer of gewoon niks"}}, false, function(source, args)
    if args[1] ~= nil then
        local DanceNumber = tonumber(args[1])
        TriggerClientEvent('framework-dances:client:dance', source, DanceNumber)
    else
        TriggerClientEvent('framework-dances:client:dance', source, -1)
    end
end)