local Mining, NearMiningSpot, CurrentMiningSpot = false, false, nil

-- // Loops \\ --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            NearMiningSpot = false
            for k, v in pairs(Config.MiningSpots) do
                local PlayerCoords = GetEntityCoords(PlayerPedId())
                local Distance = #(PlayerCoords -  v['Coords'])
                if Distance < 1.5 then
                    NearMiningSpot, CurrentMiningSpot = true, k
                end
            end
            if not NearMiningSpot then
               CurrentMiningSpot = nil
               Citizen.Wait(450)
            end
        else
            Citizen.Wait(450)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            local NearLamps = false
            for k, v in pairs(Config.MineshaftLights) do
                local PlayerCoords = GetEntityCoords(PlayerPedId())
                local Distance = #(PlayerCoords - v)
                if Distance < 30.0 then
                    NearLamps = true
                    DrawLightWithRange(v.x, v.y, v.z, 173, 157, 113, 4.0, 0.1)
                end
            end
            if not NearLamps then
                Citizen.Wait(450)
            end
        else
            Citizen.Wait(1000)
        end
    end
end)

-- // Events \\ --

RegisterNetEvent('framework-jobmanager:client:use:scanner')
AddEventHandler('framework-jobmanager:client:use:scanner', function()
    if CurrentMiningSpot ~= nil and Config.MiningSpots[CurrentMiningSpot] ~= nil then
        local SavedSpot = CurrentMiningSpot
        LSCore.Functions.Progressbar("scanning", "Grond Scannen..", 4000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            if not Config.MiningSpots[SavedSpot]['Mined'] and not Config.MiningSpots[SavedSpot]['Busy'] then
                LSCore.Functions.Notify("Meui plekkie heur!!", "success")
            else
                LSCore.Functions.Notify("Iemand heeft hier al zitten beuken met zijn handel", "error")
            end
        end, function() -- Cancel
            -- No Cancel
        end)
    end
end)

RegisterNetEvent('framework-jobmanager:client:use:pickaxe')
AddEventHandler('framework-jobmanager:client:use:pickaxe', function()
    if CurrentMiningSpot ~= nil then
        if Config.MiningSpots[CurrentMiningSpot] ~= nil and not Config.MiningSpots[CurrentMiningSpot]['Busy'] then
            if not Mining then
                local SavedSpot = CurrentMiningSpot
                TriggerEvent('framework-jobmanager:client:do:mining:anim', RandomTime)
                TriggerServerEvent('framework-jobmanager:server:mining:set:state', SavedSpot, 'Busy', true)
                Citizen.SetTimeout(math.random(1500, 10000), function()
                    exports['fw-ui']:StartSkillTest(3, 'Fast', function(Outcome)
                        if Outcome then
                            Mining = false
                            exports['fw-assets']:RemoveProp()
                            TriggerServerEvent('framework-jobmanager:server:get:rewards', Config.MiningSpots[SavedSpot]['Mined'])
                            TriggerServerEvent('framework-jobmanager:server:mining:set:state', SavedSpot, 'Mined', true)
                            TriggerServerEvent('framework-jobmanager:server:mining:set:state', SavedSpot, 'Busy', false)
                            StopAnimTask(PlayerPedId(), 'melee@large_wpn@streamed_core', 'ground_attack_on_spot', 1.0)
                        else
                            Mining = false
                            exports['fw-assets']:RemoveProp()
                            LSCore.Functions.Notify("You failed.", "error")
                            TriggerServerEvent('framework-jobmanager:server:mining:set:state', SavedSpot, 'Busy', false)
                            StopAnimTask(PlayerPedId(), 'melee@large_wpn@streamed_core', 'ground_attack_on_spot', 1.0)
                        end
                    end)
                end)
            end
        else
            LSCore.Functions.Notify("Er is hier al gemined", "error")
        end
    end
end)

RegisterNetEvent('framework-jobmanager:client:do:mining:anim')
AddEventHandler('framework-jobmanager:client:do:mining:anim', function()
    if not Mining then
        exports['fw-assets']:AddProp('Pickaxe')
        exports['fw-assets']:RequestAnimationDict('melee@large_wpn@streamed_core')
        TaskPlayAnim(PlayerPedId(), 'melee@large_wpn@streamed_core', 'ground_attack_on_spot', 3.0, -8.0, -1, 8, 0, false, false, false)
        Mining = true
        Citizen.CreateThread(function()
            while Mining do
                Citizen.Wait(4)
                TaskPlayAnim(PlayerPedId(), 'melee@large_wpn@streamed_core', 'ground_attack_on_spot', 3.0, -8.0, -1, 8, 0, false, false, false)
                Citizen.Wait(450)
                TriggerEvent('framework-sound:client:play', 'Pickaxe', 0.5)
                Citizen.Wait(1650)
            end
        end)
    end
end)

RegisterNetEvent('framework-jobmanager:client:sync:spots')
AddEventHandler('framework-jobmanager:client:sync:spots', function(SpotId, ConfigData)
    Config.MiningSpots[SpotId] = ConfigData
end)