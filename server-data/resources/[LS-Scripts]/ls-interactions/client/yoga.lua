-- // Yoga \\ --

RegisterNetEvent('ls-interactions:client:yoga')
AddEventHandler('ls-interactions:client:yoga', function(Params, Entity)
    local EntityCoords = GetEntityCoords(Entity['Entity'])
    local Heading = GetEntityHeading(Entity['Entity'])
    TaskStartScenarioAtPosition(GetPlayerPed(-1), "WORLD_HUMAN_YOGA", EntityCoords.x, EntityCoords.y, EntityCoords.z, (Heading + 90.0), 25000, false, true)
    LSCore.Functions.Progressbar("yoga", "Adem in..", 25000, false, true, {
        disableMovement = true,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        ClearPedTasks(GetPlayerPed(-1))
        TriggerServerEvent('ls-ui:server:remove:stress', math.random(1,5))
    end, function()
        LSCore.Functions.Notify("Geannuleerd..", "error")
        ClearPedTasks(GetPlayerPed(-1))
    end)
end)