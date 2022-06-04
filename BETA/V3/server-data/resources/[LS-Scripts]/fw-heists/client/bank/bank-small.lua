-- // Loops \\ --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            if NearBank and CurrentBank ~= nil then
                if Config.Banks[CurrentBank]['BankOpen'] then
                    for k, v in pairs(Config.Banks[CurrentBank]['Lockers']) do
                        local LockerDistance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v['Coords']["X"], v['Coords']["Y"], v['Coords']["Z"], true)
                        if LockerDistance < 0.5 then
                            if v['Busy'] then
                                DrawText3D(v['Coords']["X"], v['Coords']["Y"], v['Coords']["Z"] + 0.1, '~o~Niets Beschikbaar..')
                                DrawMarker(2, v['Coords']["X"], v['Coords']["Y"], v['Coords']["Z"], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 242, 148, 41, 255, false, false, false, 1, false, false, false)
                            elseif v['Open'] then
                                DrawText3D(v['Coords']["X"], v['Coords']["Y"], v['Coords']["Z"] + 0.1, '~r~Geopend..')
                                DrawMarker(2, v['Coords']["X"], v['Coords']["Y"], v['Coords']["Z"], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 72, 48, 255, false, false, false, 1, false, false, false)
                            else
                                DrawText3D(v['Coords']["X"], v['Coords']["Y"], v['Coords']["Z"] + 0.1, '~g~E~s~ - Kluis Openbreken')
                                DrawMarker(2, v['Coords']["X"], v['Coords']["Y"], v['Coords']["Z"], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 48, 255, 58, 255, false, false, false, 1, false, false, false)
                                if IsControlJustReleased(0, 38) then
                                    LockpickLocker(k)
                                end
                            end
                        end
                    end
                else
                    Citizen.Wait(150)
                end
            else
                Citizen.Wait(150)
            end
        else
            Citizen.Wait(100)
        end
    end
end)

function LockpickLocker(LockerId)
    local Type = Config.Banks[CurrentBank]['Lockers'][LockerId]['Type']
    TriggerEvent('framework-inv:client:set:inventory:state', false)
    TriggerServerEvent('framework-ui:server:gain:stress', math.random(1, 8))
    if math.random(1, 100) <= 65 and not IsWearingHandshoes() then
        TriggerServerEvent("framework-police:server:create:evidence", 'Finger', GetEntityCoords(PlayerPedId()))
    end
    if Type == 'lockpick' then
        LSCore.Functions.TriggerCallback("framework-bankrobbery:server:has:lockpick:items", function(HasItems)
            if HasItems then
                TriggerServerEvent('framework-bankrobbery:server:set:locker:state', CurrentBank, LockerId, 'Busy', true)
                exports['fw-lockpick']:OpenLockpickGame(function(Success)
                    if Success then
                        LSCore.Functions.Progressbar("break-safe", "Open breken..", math.random(10000, 15000), false, true, {
                            disableMovement = false,
                            disableCarMovement = false,
                            disableMouse = false,
                            disableCombat = true,
                        }, {
                            animDict = "anim@gangops@facility@servers@",
                            anim = "hotwire",
                            flags = 8,
                        }, {}, {}, function() -- Done
                             TriggerEvent('framework-inv:client:set:inventory:state', true)
                             StopAnimTask(PlayerPedId(), "anim@gangops@facility@servers@", "hotwire", 1.0)
                             TriggerServerEvent('framework-bankrobbery:server:set:locker:state', CurrentBank, LockerId, 'Busy', false)
                             TriggerServerEvent('framework-bankrobbery:server:set:locker:state', CurrentBank, LockerId, 'Open', true)
                             LSCore.Functions.TriggerCallback('framework-bankrobbery:server:bank:reward', function()
                            end, CurrentBank)
                             LSCore.Functions.Notify("Gelukt", "success")
                        end, function()
                            TriggerEvent('framework-inv:client:set:inventory:state', true)
                            StopAnimTask(PlayerPedId(), "anim@gangops@facility@servers@", "hotwire", 1.0)
                            TriggerServerEvent('framework-bankrobbery:server:set:locker:state', CurrentBank, LockerId, 'Busy', false)
                            LSCore.Functions.Notify("Geannuleerd..", "error")
                        end)
                    else
                        TriggerEvent('framework-inv:client:set:inventory:state', true)
                        LSCore.Functions.Notify("Geannuleerd..", "error")
                        TriggerServerEvent('framework-bankrobbery:server:set:locker:state', CurrentBank, LockerId, 'Busy', false)
                    end
                end)
            else
                LSCore.Functions.Notify("Je mist lockpick spullen..", "error")
            end
        end)
    elseif Type == 'safe' then
        TriggerServerEvent('framework-bankrobbery:server:set:locker:state', CurrentBank, LockerId, 'Busy', true)
        exports['minigame-safecrack']:StartSafeCrack(10, function(LSuccess)
            if LSuccess == true then
                TriggerEvent('framework-inv:client:set:inventory:state', true)
                TriggerServerEvent('framework-bankrobbery:server:set:locker:state', CurrentBank, LockerId, 'Busy', false)
                TriggerServerEvent('framework-bankrobbery:server:set:locker:state', CurrentBank, LockerId, 'Open', true)
                -- TriggerServerEvent('framework-bankrobbery:server:bank:reward', CurrentBank)
                LSCore.Functions.TriggerCallback('framework-bankrobbery:server:bank:reward', function(result) end, CurrentBank)  
                LSCore.Functions.Notify("Gelukt", "success")
            elseif LSuccess == false and LSuccess ~= 'Escaped' then
                TriggerEvent('framework-inv:client:set:inventory:state', true)
                LSCore.Functions.Notify("Je hebt gefaalt..", "error")
                TriggerServerEvent('framework-bankrobbery:server:set:locker:state', CurrentBank, LockerId, 'Busy', false)
            else
                TriggerEvent('framework-inv:client:set:inventory:state', true)
                LSCore.Functions.Notify("Je hebt gefaalt..", "error")
                TriggerServerEvent('framework-bankrobbery:server:set:locker:state', CurrentBank, LockerId, 'Busy', false)
            end
        end)
    else
        LSCore.Functions.TriggerCallback("framework-bankrobbery:server:has:drill:items", function(HasItems)
            if HasItems then
                TriggerServerEvent('framework-ui:server:gain:stress', math.random(1, 8))
                LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, 'drill-bit', 1, false)
                exports['fw-assets']:RequestAnimationDict("anim@heists@fleeca_bank@drilling")
                TaskPlayAnim(PlayerPedId(), 'anim@heists@fleeca_bank@drilling', 'drill_straight_idle' , 3.0, 3.0, -1, 1, 0, false, false, false)
                exports['fw-assets']:AddProp('Drill')
                TriggerServerEvent('framework-bankrobbery:server:set:locker:state', CurrentBank, LockerId, 'Busy', true)
                exports['minigame-drill']:StartDrilling(function(Success)
                   if Success then
                       exports['fw-assets']:RemoveProp()
                       TriggerEvent('framework-inv:client:set:inventory:state', true)
                       StopAnimTask(PlayerPedId(), "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 1.0)
                       TriggerServerEvent('framework-bankrobbery:server:set:locker:state', CurrentBank, LockerId, 'Busy', false)
                       TriggerServerEvent('framework-bankrobbery:server:set:locker:state', CurrentBank, LockerId, 'Open', true)
                    --    TriggerServerEvent('framework-bankrobbery:server:bank:reward', CurrentBank)
                       LSCore.Functions.TriggerCallback('framework-bankrobbery:server:bank:reward', function(result) end, CurrentBank)  
                       LSCore.Functions.Notify("Gelukt", "success")
                   else
                       exports['fw-assets']:RemoveProp()
                       TriggerEvent('framework-inv:client:set:inventory:state', true)
                       LSCore.Functions.Notify("Geannuleerd..", "error")
                       StopAnimTask(PlayerPedId(), "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 1.0)
                       TriggerServerEvent('framework-bankrobbery:server:set:locker:state', CurrentBank, LockerId, 'Busy', false)
                   end
                end)
            end
        end)
    end
end