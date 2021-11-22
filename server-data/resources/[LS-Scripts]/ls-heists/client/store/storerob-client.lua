local CurrentSafe, CurrentRegister, NearAnything = nil, nil, nil

-- Code

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(4)
        if LoggedIn then
            local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
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

RegisterNetEvent('ls-storerobbery:client:sync:registers')
AddEventHandler('ls-storerobbery:client:sync:registers', function(RegisterId, ConfigData)
    Config.Registers[RegisterId] = ConfigData
end)

RegisterNetEvent('ls-storerobbery:client:sync:safes')
AddEventHandler('ls-storerobbery:client:sync:safes', function(SafeId, ConfigData)
    Config.Safes[SafeId] = ConfigData
end)

RegisterNetEvent('ls-items:client:use:lockpick')
AddEventHandler('ls-items:client:use:lockpick', function(IsAdvanced)
    local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
    if NearAnything == 'Safe' and CurrentSafe ~= nil then
        local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Safes[CurrentSafe]['X'], Config.Safes[CurrentSafe]['Y'], Config.Safes[CurrentSafe]['Z'], true)
        if Distance < 1.3 and not Config.Safes[CurrentSafe]['Robbed'] and not Config.Safes[CurrentSafe]['Busy'] then
            if CurrentCops >= Config.StoreCopsNeeded then
                if IsAdvanced then
                    CrackSafe(CurrentSafe, true)
                else
                    LSCore.Functions.TriggerCallback('ls-storerobbery:server:HasItem', function(HasItem)
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

RegisterNetEvent('ls-stores:client:rob:register')
AddEventHandler('ls-stores:client:rob:register', function()
    if CurrentRegister ~= nil then
        if CurrentCops >= Config.StoreCopsNeeded then
            if not IsWearingHandshoes() then
                TriggerServerEvent("ls-police:server:create:evidence", 'Finger', GetEntityCoords(GetPlayerPed(-1)))
            end
            if not Config.Registers[CurrentRegister]['Robbed'] then
                local SaveId = CurrentRegister
                TriggerServerEvent('ls-ui:server:gain:stress', math.random(1, 6))
                exports['ls-ui']:StartSkillTest(4, 'Normal', function(Outcome)
                    if Outcome then
                        TriggerServerEvent('ls-storerobbery:server:set:register:robbed', SaveId, true)
                        TriggerEvent('ls-assets:client:lockpick:animation', true)
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
                            StopAnimTask(GetPlayerPed(-1), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 1.0)
                            TriggerEvent('ls-assets:client:lockpick:animation', false)
                            TriggerServerEvent('ls-storerobbery:server:rob:register:new', SaveId, true)
                        end, function() -- Cancel
                            StopAnimTask(GetPlayerPed(-1), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 1.0)
                            TriggerEvent('ls-assets:client:lockpick:animation', false)
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
        TriggerServerEvent("ls-police:server:create:evidence", 'Finger', GetEntityCoords(GetPlayerPed(-1)))
    end
    if math.random(1,100) < 40 then
        local StreetLabel = LSCore.Functions.GetStreetLabel()
        TriggerServerEvent('ls-police:server:send:alert:store', GetEntityCoords(GetPlayerPed(-1)), StreetLabel, SafeId)
    end
    FreezeEntityPosition(GetPlayerPed(-1), true)
    TriggerServerEvent('ls-ui:server:gain:stress', math.random(1, 8))
    TriggerServerEvent('ls-storerobbery:server:safe:busy', SafeId, true)
    exports['minigame-safecrack']:StartSafeCrack(8, function(OutCome)
        if OutCome == true then
            TriggerServerEvent("ls-storerobbery:server:safe:reward:new:new", SafeId)
            TriggerServerEvent('ls-storerobbery:server:safe:busy', SafeId, false)
            TriggerServerEvent("ls-storerobbery:server:safe:robbed", SafeId, true)
            FreezeEntityPosition(GetPlayerPed(-1), false)
            TakeAnimation()
        elseif OutCome == false and OutCome ~= 'Escaped' then
            if IsAdvanced then
                local RemoveChance = LSCore.Functions.GetMiniGameSkill('Lockpick')
                if math.random(1,100) <= RemoveChance then
                  TriggerServerEvent("ls-police:server:create:evidence", 'Blood', GetEntityCoords(GetPlayerPed(-1)))
                  LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, 'advancedlockpick', 1, false)
                end
            else
                if math.random(1,100) <= (RemoveChance + 3) then
                  TriggerServerEvent("ls-police:server:create:evidence", 'Blood', GetEntityCoords(GetPlayerPed(-1)))
                  LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, 'lockpick', 1, false)
                end
            end
            LSCore.Functions.Notify("Mislukt..", "error")
            TriggerServerEvent('ls-storerobbery:server:safe:busy', SafeId, false)
            FreezeEntityPosition(GetPlayerPed(-1), false)
        else
            LSCore.Functions.Notify("Mislukt..", "error")
            TriggerServerEvent('ls-storerobbery:server:safe:busy', SafeId, false)
            FreezeEntityPosition(GetPlayerPed(-1), false)
        end
    end)
end

function TakeAnimation()
    exports['ls-assets']:RequestAnimationDict("amb@prop_human_bum_bin@idle_b")
    TaskPlayAnim(GetPlayerPed(-1), "amb@prop_human_bum_bin@idle_b", "idle_d", 8.0, 8.0, -1, 50, 0, false, false, false)
    Citizen.Wait(1500)
    TaskPlayAnim(GetPlayerPed(-1), "amb@prop_human_bum_bin@idle_b", "exit", 8.0, 8.0, -1, 50, 0, false, false, false)
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