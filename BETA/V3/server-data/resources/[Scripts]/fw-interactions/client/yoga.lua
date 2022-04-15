-- // Yoga \\ --

RegisterNetEvent('framework-nteractions:client:yoga')
AddEventHandler('framework-nteractions:client:yoga', function()
    local EntityCoords = GetEntityCoords(PlayerPedId())
    local Heading = GetEntityHeading(PlayerPedId())
    TaskStartScenarioAtPosition(PlayerPedId(), "WORLD_HUMAN_YOGA", EntityCoords.x, EntityCoords.y, EntityCoords.z, (Heading), 25000, false, true)
    LSCore.Functions.Progressbar("yoga", "Adem in, Adem uit..", 25000, false, true, {
        disableMovement = true,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        ClearPedTasks(PlayerPedId())
        TriggerServerEvent('hud:server:RelieveStress', math.random(1,5))
    end, function()
        LSCore.Functions.Notify("Cancelled..", "error")
        ClearPedTasks(PlayerPedId())
    end)
end)