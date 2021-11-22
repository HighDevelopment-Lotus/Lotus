local LSCore = exports['ls-core']:GetCoreObject()

-- Code


LSCore.Commands.Add("c-dance", "stop met dansen", {}, false, function(source, args)
    TriggerClientEvent('ls-dances:client:clear:dance', source)
end)

LSCore.Commands.Add("dance", "Eventjes lekker dansen", {{name="number", help="een nummer of gewoon niks"}}, false, function(source, args)
    if args[1] ~= nil then
        local DanceNumber = tonumber(args[1])
        TriggerClientEvent('ls-dances:client:dance', source, DanceNumber)
    else
        TriggerClientEvent('ls-dances:client:dance', source, -1)
    end
end)