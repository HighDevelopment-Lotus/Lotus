local LoggedIn, LSCore = false, exports['fw-base']:GetCoreObject()    

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
            local Weapon = GetSelectedPedWeapon(PlayerPedId())
            if Config.WeaponsList[Weapon] ~= nil and Config.WeaponsList[Weapon]['AmmoType'] ~= nil then
                if Config.WeaponsList[Weapon]['IdName'] ~= 'weapon_unarmed' and Config.WeaponsList[Weapon]['AmmoType'] == 'AMMO_FIRE'  then 
                    if (IsPedInAnyVehicle(PlayerPedId()) and IsControlJustPressed(0, 24) and IsPedWeaponReadyToShoot(PlayerPedId())) or IsPedShooting(PlayerPedId()) then
                        Citizen.SetTimeout(400, function()
                            if Config.WeaponsList[Weapon]['IdName'] == 'weapon_molotov' then
                                LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, 'weapon_molotov', 1, false)
                                TriggerEvent('framework-weapons:client:set:current:weapon', nil)
                                TriggerEvent('framework-inv:client:reset:weapon')
                            elseif Config.WeaponsList[Weapon]['IdName'] == 'weapon_brick' then
                                LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, 'weapon_brick', 1, false)
                                TriggerEvent('framework-weapons:client:set:current:weapon', nil)
                                TriggerEvent('framework-inv:client:reset:weapon')
                            elseif Config.WeaponsList[Weapon]['IdName'] == 'weapon_stickybomb' then
                                LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, 'weapon_stickybomb', 1, false)
                                TriggerEvent('framework-weapons:client:set:current:weapon', nil)
                                TriggerEvent('framework-inv:client:reset:weapon')
                            elseif Config.WeaponsList[Weapon]['IdName'] == 'weapon_shoe' then
                                LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, 'weapon_shoe', 1, false)
                                TriggerEvent('framework-weapons:client:set:current:weapon', nil)
                                TriggerEvent('framework-inv:client:reset:weapon')
                            elseif Config.WeaponsList[Weapon]['IdName'] == 'weapon_flare' then
                                LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, 'weapon_flare', 1, false)
                                TriggerEvent('framework-weapons:client:set:current:weapon', nil)
                                TriggerEvent('framework-inv:client:reset:weapon')
                            elseif Config.WeaponsList[Weapon]['IdName'] == 'weapon_smokegrenade' then
                                LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, 'weapon_smokegrenade', 1, false)
                                TriggerEvent('framework-weapons:client:set:current:weapon', nil)
                                TriggerEvent('framework-inv:client:reset:weapon')
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
            local Weapon = GetSelectedPedWeapon(PlayerPedId())
            local WeaponBullets = GetAmmoInPedWeapon(PlayerPedId(), Weapon)
            if Config.WeaponsList[Weapon] ~= nil and Config.WeaponsList[Weapon]['AmmoType'] ~= nil then
                if Config.WeaponsList[Weapon]['IdName'] ~= 'weapon_unarmed' then 
                    if IsPedShooting(PlayerPedId()) or IsPedPerformingMeleeAction(PlayerPedId()) and IsPedArmed(PlayerPedId(), 1) then
                        TriggerServerEvent("framework-weapons:server:update:quality", Config.CurrentWeaponData, 1)
                        if WeaponBullets == 1 then
                          TriggerServerEvent("framework-weapons:server:update:weapon:ammo", Config.CurrentWeaponData, 1)
                        else
                          TriggerServerEvent("framework-weapons:server:update:weapon:ammo", Config.CurrentWeaponData, tonumber(WeaponBullets))
                        end
                    end
                    if Config.WeaponsList[Weapon]['AmmoType'] ~= 'AMMO_FIRE' then
                        if IsPedArmed(PlayerPedId(), 6) then
                            if WeaponBullets == 1 then
                                DisableControlAction(0, 24, true) 
                                DisableControlAction(0, 257, true)
                                if IsPedInAnyVehicle(PlayerPedId(), true) then
                                    SetPlayerCanDoDriveBy(PlayerId(), false)
                                end
                            else
                                EnableControlAction(0, 24, true) 
                                EnableControlAction(0, 257, true)
                                if IsPedInAnyVehicle(PlayerPedId(), true) then
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
            if IsPedArmed(PlayerPedId(), 6) then
                if IsPlayerFreeAiming(PlayerId()) then
                    if not ShowingScope then
                        local Weapon = GetSelectedPedWeapon(PlayerPedId())
                        if Config.WeaponsList[Weapon]['IdName'] == 'weapon_sniperrifle2' then
                            ShowingScope = true
                            exports['fw-ui']:ToggleScope(true)
                            NetworkSetFriendlyFireOption(false)
                            SetCanAttackFriendly(PlayerPedId(), false, false)
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
                        exports['fw-ui']:ToggleScope(false)
                        NetworkSetFriendlyFireOption(true)
                        SetCanAttackFriendly(PlayerPedId(), true, true)
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
                    exports['fw-ui']:ToggleScope(false)
                    NetworkSetFriendlyFireOption(true)
                    SetCanAttackFriendly(PlayerPedId(), true, true)
                end
                Citizen.Wait(450)
            end
        else
            Citizen.Wait(450)
        end
    end
end)

-- // Events \\ --

RegisterNetEvent('framework-weapons:client:set:current:weapon')
AddEventHandler('framework-weapons:client:set:current:weapon', function(data)
    if data ~= false then
        Config.CurrentWeaponData = data
    else
        Config.CurrentWeaponData = {}
    end
end)

RegisterNetEvent('framework-weapons:client:reload:ammo')
AddEventHandler('framework-weapons:client:reload:ammo', function(AmmoType, AmmoName)
    local Weapon = GetSelectedPedWeapon(PlayerPedId())
    local WeaponBullets = GetAmmoInPedWeapon(PlayerPedId(), Weapon)
    if Config.WeaponsList[Weapon] ~= nil and Config.WeaponsList[Weapon]['AmmoType'] ~= nil then
       if Config.WeaponsList[Weapon]['AmmoType'] == AmmoType then
           if WeaponBullets <= Config.WeaponsList[Weapon]['MaxAmmo'] then
                TriggerEvent('framework-inv:client:set:inventory:state', false)
                LSCore.Functions.Progressbar("taking_bullets", "Kogels inladen..", Config.WeaponsList[Weapon]['Wait'], false, true, {
                    disableMovement = false,
                    disableCarMovement = false,
                    disableMouse = false,
                    disableCombat = true,
                }, {}, {}, {}, function() -- Done
                    -- Remove Item Trigger.
                    TriggerEvent('framework-inv:client:set:inventory:state', true)
                    LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function(DidRemove) 
                        if DidRemove then
                            SetAmmoInClip(PlayerPedId(), Weapon, 0)
                            SetPedAmmo(PlayerPedId(), Weapon, Config.WeaponsList[Weapon]['MaxAmmo'] + 1)
                            TriggerServerEvent("framework-weapons:server:update:weapon:ammo", Config.CurrentWeaponData, tonumber(Config.WeaponsList[Weapon]['MaxAmmo'] + 1))
                            LSCore.Functions.Notify("+ "..(Config.WeaponsList[Weapon]['MaxAmmo'] + 1).."x kogels ("..Config.WeaponsList[Weapon]['Name']..")", "success")
                        else
                            LSCore.Functions.Notify("Hmm volgensmij mis je het item..", "error")
                        end
                    end, AmmoName, 1, false)
                end, function()
                    TriggerEvent('framework-inv:client:set:inventory:state', true)
                    LSCore.Functions.Notify("Geannuleerd..", "error")
                end)
           else
               LSCore.Functions.Notify("Je hebt al kogels in geladen..", "error")
           end
       end
    end
end)

RegisterNetEvent('framework-weapons:client:set:ammo')
AddEventHandler('framework-weapons:client:set:ammo', function(Amount)
    local Weapon = GetSelectedPedWeapon(PlayerPedId())
    local WeaponBullets = GetAmmoInPedWeapon(PlayerPedId(), Weapon)
    local NewAmmo = WeaponBullets + tonumber(Amount)
    if Config.WeaponsList[Weapon] ~= nil and Config.WeaponsList[Weapon]['AmmoType'] ~= nil then
       SetAmmoInClip(PlayerPedId(), Weapon, 0)
       SetPedAmmo(PlayerPedId(), Weapon, tonumber(NewAmmo))
       TriggerServerEvent("framework-weapons:server:update:weapon:ammo", Config.CurrentWeaponData, tonumber(NewAmmo))
       LSCore.Functions.Notify("Succesvol "..Amount..'x kogels ontvangen ('..Config.WeaponsList[Weapon]['Name']..')', "success", 4500)
    end
end)

RegisterNetEvent('framework-weapons:client:remove:dot')
AddEventHandler('framework-weapons:client:remove:dot', function()
    if not IsPlayerFreeAiming(PlayerId()) then
        ShowingScope = false
        exports['fw-ui']:ToggleScope(false)
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