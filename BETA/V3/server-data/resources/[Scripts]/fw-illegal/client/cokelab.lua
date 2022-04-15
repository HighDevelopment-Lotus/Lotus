local NearAction = false
local CokeCrafting = {['X'] = 1093.03, ['Y'] = -3196.56, ['Z'] = -38.99}

-- Threads

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            NearAction = false
            if InsideLab and Config.Labs[CurrentLab]['Name'] == 'Cokelab' then
                local PlayerCoords = GetEntityCoords(PlayerPedId())
                local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Labs[CurrentLab]['Coords']['Action']['X'], Config.Labs[CurrentLab]['Coords']['Action']['Y'], Config.Labs[CurrentLab]['Coords']['Action']['Z'], true)
                if Distance < 2.0 then
                    NearAction = true
                    if not ShowInteraction2 then
                        ShowInteraction2 = true
                        exports['fw-ui']:ShowInteraction('[E] Gebruiken', 'primary')
                    end
                    
                    if IsControlJustReleased(0, 38) then
                        LSCore.Functions.TriggerCallback('framework-illegal:server:has:coke:items', function(HasItem)
                            if HasItem then
                                TriggerEvent('framework-inv:client:set:inventory:state', true)
                                exports['fw-ui']:StartSkillTest(2, 'Fast', function(Success)
                                    if Success then
                                        TriggerEvent("framework-sound:client:play", "unwrap", 0.25)
                                        LSCore.Functions.Progressbar("action-cokelab", "Uitpakken..", 7500, false, true, {
                                            disableMovement = false,
                                            disableCarMovement = false,
                                            disableMouse = false,
                                            disableCombat = true,
                                        }, {
                                            animDict = "amb@world_human_clipboard@male@idle_a",
                                            anim = "idle_c",
                                            flags = 49,
                                        }, {}, {}, function() -- Done
                                            TriggerEvent('framework-sound:client:play', 'cutting', 0.25)
                                            LSCore.Functions.Progressbar("action-cokelab", "Cocaine Versnijden..", 7500, false, true, {
                                                disableMovement = false,
                                                disableCarMovement = false,
                                                disableMouse = false,
                                                disableCombat = true,
                                            }, {
                                                animDict = "amb@world_human_clipboard@male@idle_a",
                                                anim = "idle_c",
                                                flags = 49,
                                            }, {}, {}, function() -- Done
                                                TriggerEvent('framework-inv:client:set:inventory:state', false)
                                                -- TriggerServerEvent('framework-illegal:server:cutting:coke:brick')
                                                LSCore.Functions.TriggerCallback('framework-illegal:server:cutting:coke:brick', function() end)
                                                StopAnimTask(PlayerPedId(), "amb@world_human_clipboard@male@idle_a", "idle_c", 1.0)
                                            end)
                                        end, function()
                                            TriggerEvent('framework-inv:client:set:inventory:state', false)
                                            StopAnimTask(PlayerPedId(), "amb@world_human_clipboard@male@idle_a", "idle_c", 1.0)
                                        end)
                                    else
                                        TriggerEvent('framework-inv:client:set:inventory:state', false)
                                        LSCore.Functions.Notify("Gefaald", "error")
                                    end
                                end)
                            else
                                TriggerEvent('framework-inv:client:set:inventory:state', false)
                                LSCore.Functions.Notify("Je mist iets", "error")
                            end
                        end, 'packed-coke-brick')
                    end
                end
                if not NearAction then
                    if ShowInteraction2 then
                        ShowInteraction2 = false
                        exports['fw-ui']:HideInteraction()
                    end
                    Citizen.Wait(1500)
                end
            else
                Citizen.Wait(1000)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            if InsideLab and Config.Labs[CurrentLab]['Name'] == 'Cokelab' then
                local PlayerCoords = GetEntityCoords(PlayerPedId())
                local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, CokeCrafting['X'], CokeCrafting['Y'], CokeCrafting['Z'], true)
                NearCraft = false
                if Distance < 1.2 then
                    NearCraft = true
                    if not ShowingInteraction2 then
                        ShowingInteraction2 = true
                        exports['fw-ui']:ShowInteraction('[E] Verpakken', 'primary')
                    end
                    
                    if IsControlJustReleased(0, 38) then
                        local CraftingData = {['Type'] = 'Crafting', ['InvName'] = 'Coke', ['Items'] = Config.CokeCrafting}
		                TriggerServerEvent('framework-inv:server:open:inventory:other', CraftingData, 'Crafting')
                        exports['fw-ui']:HideInteraction()
                    end
                end
                if not NearCraft then
                    if ShowingInteraction2 then
                        ShowingInteraction2 = false
                        exports['fw-ui']:HideInteraction()
                    end
                    Citizen.Wait(1500)
                end
            end
        end
    end
end)

-- Events

-- RegisterNetEvent('framework-illegal:client:start:burner-call', function()
--     if not DoingSomething then
--         DoingSomething = true
--         local RandomObjective = {}
--         local RandomValue = math.random(1, 4)
--         Citizen.SetTimeout(1250, function()
--             TriggerEvent('framework-inv:client:set:inventory:state', false)
--             exports['fw-assets']:RequestAnimationDict("cellphone@")
--             TaskPlayAnim(PlayerPedId(), 'cellphone@', 'cellphone_text_to_call', 3.0, 3.0, -1, 50, 0, false, false, false)
--             local Time = 5
--             repeat
--               Time = Time -1
--               TriggerEvent("framework-sound:client:play", "death", 0.2)
--               Citizen.Wait(3500)
--             until Time == 0
--             if RandomValue == 1 then
--                 TriggerEvent("framework-sound:client:play", "call-1", 0.25) 
--             elseif RandomValue == 2 then
--                 TriggerEvent("framework-sound:client:play", "call-1", 0.25) 
--             elseif RandomValue == 3 then
--                 TriggerEvent("framework-sound:client:play", "call-1", 0.25) 
--             elseif RandomValue == 4 then
--                 TriggerEvent("framework-sound:client:play", "call-1", 0.25) 
--             end
--             Citizen.SetTimeout(14000, function()
--                 RandomObjective = Config.RandomLocation[math.random(1, #Config.RandomLocation)]
--                 RandomObjective['Name'] = 'Lola Bunny'
--                 RandomObjective['Amount'] = 1
--                 LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, 'burner-phone', 1, false)
--                 TriggerServerEvent('framework-phone:server:sendNewMail', {
--                     sender = RandomObjective['Name'],
--                     subject = "Pick up Location",
--                     message = "Here is all the information about the order, <br><br>Location: <b>"..RandomObjective["Street"].."</b><br>Stuff: <b>"..RandomObjective['Amount'].."x</b><br><br> Come alone and be quick! <br><br>Kisses,<br><br><b>"..RandomObjective['Name']..'</b>',
--                     button = {
--                         enabled = true,
--                         buttonEvent = "framework-illegal:client:start:pickup",
--                         buttonData = RandomObjective
--                     }
--                 })
--                 TriggerEvent('framework-inv:client:set:inventory:state', true)
--                 ClearPedTasks(PlayerPedId())
--             end)
--         end)
--     end
-- end)

-- RegisterNetEvent('framework-illegal:client:start:pickup', function(PickupData)
--     local DoingJob = true
--     local JobData = PickupData
--     SetNewWaypoint(JobData['Coords']['X'], JobData['Coords']['Y'])
--     while DoingJob do
--         Citizen.Wait(4)
--         local PlayerCoords = GetEntityCoords(PlayerPedId())
--         local Distance = GetDistanceBetweenCoords(PlayerCoords, JobData['Coords']['X'], JobData['Coords']['Y'], JobData['Coords']['Z'], true)
--         if Distance <= 2.0 then
--             DrawText3D(JobData['Coords']['X'], JobData['Coords']['Y'], JobData['Coords']['Z'] + 0.1, '[E] Order')
--             DrawMarker(2, JobData['Coords']['X'], JobData['Coords']['Y'], JobData['Coords']['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
--             if IsControlJustReleased(0, 38) then
--                 DoingJob = false
--                 TriggerServerEvent('framework-illegal:server:pickup:order')
--                 DoingSomething = false
--             end
--         end
--     end
-- end)