local LoggedIn, LSCore = false, exports['ls-core']:GetCoreObject()    

RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1250, function()
        LoggedIn = true
    end)
end)

RegisterNetEvent('LSCore:Client:OnPlayerUnload')
AddEventHandler('LSCore:Client:OnPlayerUnload', function()
    LoggedIn = false
end)

-- Citizen.CreateThread(function()
--     Citizen.SetTimeout(1, function()
--         LoggedIn = true
--     end)
-- end)

-- Code

-- // Loops \\ --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            local Weapon = GetSelectedPedWeapon(GetPlayerPed(-1))
            if Config.WeaponsList[Weapon] ~= nil and Config.WeaponsList[Weapon]['AmmoType'] ~= nil then
                if Config.WeaponsList[Weapon]['IdName'] ~= 'weapon_unarmed' and Config.WeaponsList[Weapon]['AmmoType'] == 'AMMO_FIRE'  then 
                    if (IsPedInAnyVehicle(GetPlayerPed(-1)) and IsControlJustPressed(0, 24) and IsPedWeaponReadyToShoot(GetPlayerPed(-1))) or IsPedShooting(GetPlayerPed(-1)) then
                        Citizen.SetTimeout(400, function()
                            if Config.WeaponsList[Weapon]['IdName'] == 'weapon_molotov' then
                                LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, 'weapon_molotov', 1, false)
                                TriggerEvent('ls-weapons:client:set:current:weapon', nil)
                                TriggerEvent('ls-inventory-new:client:reset:weapon')
                            elseif Config.WeaponsList[Weapon]['IdName'] == 'weapon_brick' then
                                LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, 'weapon_brick', 1, false)
                                TriggerEvent('ls-weapons:client:set:current:weapon', nil)
                                TriggerEvent('ls-inventory-new:client:reset:weapon')
                            elseif Config.WeaponsList[Weapon]['IdName'] == 'weapon_shoe' then
                                LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, 'weapon_shoe', 1, false)
                                TriggerEvent('ls-weapons:client:set:current:weapon', nil)
                                TriggerEvent('ls-inventory-new:client:reset:weapon')
                            elseif Config.WeaponsList[Weapon]['IdName'] == 'weapon_flare' then
                                LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, 'weapon_flare', 1, false)
                                TriggerEvent('ls-weapons:client:set:current:weapon', nil)
                                TriggerEvent('ls-inventory-new:client:reset:weapon')
                            elseif Config.WeaponsList[Weapon]['IdName'] == 'weapon_smokegrenade' then
                                LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, 'weapon_smokegrenade', 1, false)
                                TriggerEvent('ls-weapons:client:set:current:weapon', nil)
                                TriggerEvent('ls-inventory-new:client:reset:weapon')
                            end
                        end)
                    end
                else
                    Citizen.Wait(450)
                end
            else
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
            local Weapon = GetSelectedPedWeapon(GetPlayerPed(-1))
            local WeaponBullets = GetAmmoInPedWeapon(GetPlayerPed(-1), Weapon)
            if Config.WeaponsList[Weapon] ~= nil and Config.WeaponsList[Weapon]['AmmoType'] ~= nil then
                if Config.WeaponsList[Weapon]['IdName'] ~= 'weapon_unarmed' then 
                    if IsPedShooting(GetPlayerPed(-1)) or IsPedPerformingMeleeAction(GetPlayerPed(-1)) and IsPedArmed(GetPlayerPed(-1), 1) then
                        TriggerServerEvent("ls-weapons:server:update:quality", Config.CurrentWeaponData, 1)
                        if WeaponBullets == 1 then
                          TriggerServerEvent("ls-weapons:server:update:weapon:ammo", Config.CurrentWeaponData, 1)
                        else
                          TriggerServerEvent("ls-weapons:server:update:weapon:ammo", Config.CurrentWeaponData, tonumber(WeaponBullets))
                        end
                    end
                    if Config.WeaponsList[Weapon]['AmmoType'] ~= 'AMMO_FIRE' then
                        if IsPedArmed(GetPlayerPed(-1), 6) then
                            if WeaponBullets == 1 then
                                DisableControlAction(0, 24, true) 
                                DisableControlAction(0, 257, true)
                                if IsPedInAnyVehicle(GetPlayerPed(-1), true) then
                                    SetPlayerCanDoDriveBy(PlayerId(), false)
                                end
                            else
                                EnableControlAction(0, 24, true) 
                                EnableControlAction(0, 257, true)
                                if IsPedInAnyVehicle(GetPlayerPed(-1), true) then
                                    SetPlayerCanDoDriveBy(PlayerId(), true)
                                end
                            end
                        else
                            Citizen.Wait(450)
                        end
                    else
                        Citizen.Wait(450)
                    end
                else
                    Citizen.Wait(450)
                end
            else
                Citizen.Wait(450)
            end
        end
    end
end)

local ShowingScope = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            if IsPedArmed(GetPlayerPed(-1), 6) then
                if IsPlayerFreeAiming(PlayerId()) then
                    if not ShowingScope then
                        local Weapon = GetSelectedPedWeapon(GetPlayerPed(-1))
                        if Config.WeaponsList[Weapon]['IdName'] == 'weapon_sniperrifle2' then
                            ShowingScope = true
                            exports['ls-ui']:ToggleScope(true)
                            NetworkSetFriendlyFireOption(false)
                            SetCanAttackFriendly(GetPlayerPed(-1), false, false)
                        else
                            ShowingScope = true
                            SendNUIMessage({
                                action = "toggle",
                                show = true,
                            })
                        end
                    end
                else
                    if ShowingScope then
                        ShowingScope = false
                        SendNUIMessage({
                            action = "toggle",
                            show = false,
                        })
                        exports['ls-ui']:ToggleScope(false)
                        NetworkSetFriendlyFireOption(true)
                        SetCanAttackFriendly(GetPlayerPed(-1), true, true)
                    end
                    Citizen.Wait(250)
                end
            else
                if ShowingScope then
                    ShowingScope = false
                    SendNUIMessage({
                        action = "toggle",
                        show = false,
                    })
                    exports['ls-ui']:ToggleScope(false)
                    NetworkSetFriendlyFireOption(true)
                    SetCanAttackFriendly(GetPlayerPed(-1), true, true)
                end
                Citizen.Wait(450)
            end
        else
            Citizen.Wait(450)
        end
    end
end)

-- // Events \\ --

RegisterNetEvent('ls-weapons:client:set:current:weapon')
AddEventHandler('ls-weapons:client:set:current:weapon', function(data)
    if data ~= false then
        Config.CurrentWeaponData = data
    else
        Config.CurrentWeaponData = {}
    end
end)

RegisterNetEvent('ls-weapons:client:reload:ammo')
AddEventHandler('ls-weapons:client:reload:ammo', function(AmmoType, AmmoName)
    local Weapon = GetSelectedPedWeapon(GetPlayerPed(-1))
    local WeaponBullets = GetAmmoInPedWeapon(GetPlayerPed(-1), Weapon)
    if Config.WeaponsList[Weapon] ~= nil and Config.WeaponsList[Weapon]['AmmoType'] ~= nil then
       if Config.WeaponsList[Weapon]['AmmoType'] == AmmoType then
           if WeaponBullets <= Config.WeaponsList[Weapon]['MaxAmmo'] then
                TriggerEvent('ls-inventory-new:client:set:inventory:state', false)
                LSCore.Functions.Progressbar("taking_bullets", "Kogels inladen..", Config.WeaponsList[Weapon]['Wait'], false, true, {
                    disableMovement = false,
                    disableCarMovement = false,
                    disableMouse = false,
                    disableCombat = true,
                }, {}, {}, {}, function() -- Done
                    -- Remove Item Trigger.
                    TriggerEvent('ls-inventory-new:client:set:inventory:state', true)
                    LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function(DidRemove) 
                        if DidRemove then
                            SetAmmoInClip(GetPlayerPed(-1), Weapon, 0)
                            SetPedAmmo(GetPlayerPed(-1), Weapon, Config.WeaponsList[Weapon]['MaxAmmo'] + 1)
                            TriggerServerEvent("ls-weapons:server:update:weapon:ammo", Config.CurrentWeaponData, tonumber(Config.WeaponsList[Weapon]['MaxAmmo'] + 1))
                            LSCore.Functions.Notify("+ "..(Config.WeaponsList[Weapon]['MaxAmmo'] + 1).."x kogels ("..Config.WeaponsList[Weapon]['Name']..")", "success")
                        else
                            LSCore.Functions.Notify("Hmm volgensmij mis je het item..", "error")
                        end
                    end, AmmoName, 1, false)
                end, function()
                    TriggerEvent('ls-inventory-new:client:set:inventory:state', true)
                    LSCore.Functions.Notify("Geannuleerd..", "error")
                end)
           else
               LSCore.Functions.Notify("Je hebt al kogels in geladen..", "error")
           end
       end
    end
end)

RegisterNetEvent('ls-weapons:client:set:ammo')
AddEventHandler('ls-weapons:client:set:ammo', function(Amount)
    local Weapon = GetSelectedPedWeapon(GetPlayerPed(-1))
    local WeaponBullets = GetAmmoInPedWeapon(GetPlayerPed(-1), Weapon)
    local NewAmmo = WeaponBullets + tonumber(Amount)
    if Config.WeaponsList[Weapon] ~= nil and Config.WeaponsList[Weapon]['AmmoType'] ~= nil then
       SetAmmoInClip(GetPlayerPed(-1), Weapon, 0)
       SetPedAmmo(GetPlayerPed(-1), Weapon, tonumber(NewAmmo))
       TriggerServerEvent("ls-weapons:server:update:weapon:ammo", Config.CurrentWeaponData, tonumber(NewAmmo))
       LSCore.Functions.Notify("Succesvol "..Amount..'x kogels ontvangen ('..Config.WeaponsList[Weapon]['Name']..')', "success", 4500)
    end
end)

RegisterNetEvent('ls-weapons:client:remove:dot')
AddEventHandler('ls-weapons:client:remove:dot', function()
    if not IsPlayerFreeAiming(PlayerId()) then
        ShowingScope = false
        exports['ls-ui']:ToggleScope(false)
        SendNUIMessage({
            action = "toggle",
            show = false,
        })
    end
end)

-- // Functions \\ --

function GetAmmoType(Weapon)
    if Config.WeaponsList[Weapon] ~= nil then
        return Config.WeaponsList[Weapon]['AmmoType']
    end
end

function GetWeaponList(Weapon)
    return Config.WeaponsList[Weapon]
end