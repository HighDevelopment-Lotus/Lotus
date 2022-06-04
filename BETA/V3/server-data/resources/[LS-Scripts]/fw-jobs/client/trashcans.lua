RegisterNetEvent('framework-materials:client:search:trash')
AddEventHandler('framework-materials:client:search:trash', function()
                    LSCore.Functions.Progressbar("search-trash", "Graaien..", math.random(10000, 12500), false, true, {
                        disableMovement = true,
                        disableCarMovement = false,
                        disableMouse = false,
                        disableCombat = true,
                    }, {
                        animDict = 'mini@repair',
                        anim = 'fixing_a_ped',
                        flags = 16,
                    }, {}, {}, function() -- Done
                        table.insert(searched, dumpster)
                        LSCore.Functions.TriggerCallback('framework-materials:server:get:reward', function()
                        end)
                        StopAnimTask(PlayerPedId(), 'mini@repair', "fixing_a_ped", 1.0)
                    end, function() -- Cancel
                        StopAnimTask(PlayerPedId(), 'mini@repair', "fixing_a_ped", 1.0)
                        LSCore.Functions.Notify("Mislukt!", "error")
                    end)
end)