local CurrentSafe, CurrentRegister, NearAnything = nil, nil, nil

-- Code

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(4)
        if LoggedIn then
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            NearAnything = nil
            for k, v in pairs(Config.Registers) do
                local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['X'], v['Y'], v['Z'], true)
                if Distance < 1.2 then
                  NearAnything = 'Register'
                  CurrentRegister = k
               end
            end
            for k, v in pairs(Config.Safes) do
                local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['X'], v['Y'], v['Z'], true)
                if Distance < 1.5 then
                    NearAnything = 'Safe'
                    CurrentSafe = k
                    if v['Robbed'] then
                        DrawText3D(v['X'], v['Y'], v['Z'] - 0.3, '~r~De kluis is leeg...')
                    elseif v['Busy'] then
                        DrawText3D(v['X'], v['Y'], v['Z'] - 0.3, '~o~De kluis is bezig..')
                    else
                        DrawText3D(v['X'], v['Y'], v['Z'] - 0.3, '~s~De kluis')
                    end
                end
            end
            if NearAnything ~= 'Safe' and NearAnything ~= 'Register' then
                CurrentRegister, CurrentSafe = nil, nil
                Citizen.Wait(450)
            end
        else
            Citizen.Wait(450)
        end
    end
end)

-- // Events \\ --

RegisterNetEvent('framework-storerobbery:client:sync:registers')
AddEventHandler('framework-storerobbery:client:sync:registers', function(RegisterId, ConfigData)
    Config.Registers[RegisterId] = ConfigData
end)

RegisterNetEvent('framework-storerobbery:client:sync:safes')
AddEventHandler('framework-storerobbery:client:sync:safes', function(SafeId, ConfigData)
    Config.Safes[SafeId] = ConfigData
end)

RegisterNetEvent('framework-items:client:use:lockpick')
AddEventHandler('framework-items:client:use:lockpick', function(IsAdvanced)
    local PlayerCoords = GetEntityCoords(PlayerPedId())
    if NearAnything == 'Safe' and CurrentSafe ~= nil then
        local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Safes[CurrentSafe]['X'], Config.Safes[CurrentSafe]['Y'], Config.Safes[CurrentSafe]['Z'], true)
        if Distance < 1.3 and not Config.Safes[CurrentSafe]['Robbed'] and not Config.Safes[CurrentSafe]['Busy'] then
            if CurrentCops >= Config.StoreCopsNeeded then
                if IsAdvanced then
                    CrackSafe(CurrentSafe, true)
                else
                    LSCore.Functions.TriggerCallback('framework-storerobbery:server:HasItem', function(HasItem)
                        if HasItem then
                            CrackSafe(CurrentSafe, false)
                        else
                            LSCore.Functions.Notify("Je mist iets..", "error")
                        end
                    end, "screwdriverset") 
                end
            else
                LSCore.Functions.Notify("Niet genoeg agenten!", "info")
            end
        end
    end
end)

RegisterNetEvent('framework-stores:client:rob:register')
AddEventHandler('framework-stores:client:rob:register', function()
    if CurrentRegister ~= nil then
        if CurrentCops >= Config.StoreCopsNeeded then
            if not IsWearingHandshoes() then
                TriggerServerEvent("framework-police:server:create:evidence", 'Finger', GetEntityCoords(PlayerPedId()))
            end
            if not Config.Registers[CurrentRegister]['Robbed'] then
                local SaveId = CurrentRegister
                TriggerServerEvent('framework-ui:server:gain:stress', math.random(1, 6))
                exports['fw-ui']:StartSkillTest(4, 'Normal', function(Outcome)
                    if Outcome then
                        TriggerServerEvent('framework-storerobbery:server:set:register:robbed', SaveId, true)
                        TriggerEvent('framework-assets:client:lockpick:animation', true)
                        LSCore.Functions.Progressbar("search_register", "Kassa leeghalen..", 40000, false, true, {
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true,
                        }, {
                            animDict = "veh@break_in@0h@p_m_one@",
                            anim = "low_force_entry_ds",
                            flags = 16,
                        }, {}, {}, function() -- Done    
                            StopAnimTask(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 1.0)
                            TriggerEvent('framework-assets:client:lockpick:animation', false)
                            TriggerServerEvent('framework-storerobbery:server:rob:register:new', SaveId, true)
                        end, function() -- Cancel
                            StopAnimTask(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 1.0)
                            TriggerEvent('framework-assets:client:lockpick:animation', false)
                        end)
                    else
                        LSCore.Functions.Notify("Gefaalt!", "error")
                    end
                end)
            else
                LSCore.Functions.Notify("De kassa is al leeg!", "error")
            end
        else
            LSCore.Functions.Notify("Niet genoeg agenten!", "info")
        end
    else
        LSCore.Functions.Notify("Geen kassa?", "error")
    end
end)

-- Function

function CrackSafe(SafeId, IsAdvanced)
    if not IsWearingHandshoes() then
        TriggerServerEvent("framework-police:server:create:evidence", 'Finger', GetEntityCoords(PlayerPedId()))
    end
    if math.random(1,100) < 40 then
        local StreetLabel = LSCore.Functions.GetStreetLabel()
        TriggerServerEvent('framework-police:server:send:alert:store', GetEntityCoords(PlayerPedId()), StreetLabel, SafeId)
    end
    FreezeEntityPosition(PlayerPedId(), true)
    TriggerServerEvent('framework-ui:server:gain:stress', math.random(1, 8))
    TriggerServerEvent('framework-storerobbery:server:safe:busy', SafeId, true)
    exports['minigame-safecrack']:StartSafeCrack(8, function(OutCome)
        if OutCome == true then
            TriggerServerEvent("framework-storerobbery:server:safe:reward:new:new", SafeId)
            TriggerServerEvent('framework-storerobbery:server:safe:busy', SafeId, false)
            TriggerServerEvent("framework-storerobbery:server:safe:robbed", SafeId, true)
            FreezeEntityPosition(PlayerPedId(), false)
            TakeAnimation()
        elseif OutCome == false and OutCome ~= 'Escaped' then
            if IsAdvanced then
                local RemoveChance = LSCore.Functions.GetMiniGameSkill('Lockpick')
                if math.random(1,100) <= RemoveChance then
                  TriggerServerEvent("framework-police:server:create:evidence", 'Blood', GetEntityCoords(PlayerPedId()))
                  LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, 'advancedlockpick', 1, false)
                end
            else
                if math.random(1,100) <= (RemoveChance + 3) then
                  TriggerServerEvent("framework-police:server:create:evidence", 'Blood', GetEntityCoords(PlayerPedId()))
                  LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, 'lockpick', 1, false)
                end
            end
            LSCore.Functions.Notify("Mislukt..", "error")
            TriggerServerEvent('framework-storerobbery:server:safe:busy', SafeId, false)
            FreezeEntityPosition(PlayerPedId(), false)
        else
            LSCore.Functions.Notify("Mislukt..", "error")
            TriggerServerEvent('framework-storerobbery:server:safe:busy', SafeId, false)
            FreezeEntityPosition(PlayerPedId(), false)
        end
    end)
end

function TakeAnimation()
    exports['fw-assets']:RequestAnimationDict("amb@prop_human_bum_bin@idle_b")
    TaskPlayAnim(PlayerPedId(), "amb@prop_human_bum_bin@idle_b", "idle_d", 8.0, 8.0, -1, 50, 0, false, false, false)
    Citizen.Wait(1500)
    TaskPlayAnim(PlayerPedId(), "amb@prop_human_bum_bin@idle_b", "exit", 8.0, 8.0, -1, 50, 0, false, false, false)
end

function GetStoreNumber()
    if CurrentRegister ~= nil then
        return Config.Registers[CurrentRegister]['Store']
    end
end

function IsNearStoreRob()
    if NearAnything == 'Register' and CurrentRegister ~= nil then
        return true
    end
end