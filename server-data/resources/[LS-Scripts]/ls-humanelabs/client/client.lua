local LSCore, LoggedIn, ShowingInteraction = exports['ls-core']:GetCoreObject(), false, false
local CurrentCops, LockPicking = 0, false
local NearAnything, ShowingItems = false, false
local NearExplosive, NearHack, CurrentLocker = false, false, nil
local ExplosiveData = exports['ls-inventory-new']:GetItemData('explosive')
local KitData = exports['ls-inventory-new']:GetItemData('electronickit')
local CardData = exports['ls-inventory-new']:GetItemData('black-card')
local RequirdItems = {[1] = {['Label'] = ExplosiveData['label'], ['Image'] = ExplosiveData["image"]}}
local RequirdHackItems = {[1] = {['Label'] = KitData['label'], ['Image'] = KitData["image"]}, [2] = {['Label'] = CardData["label"], ['Image'] = CardData["image"]}}
       
RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1250, function()
       LSCore.Functions.TriggerCallback("ls-humanelabs:server:get:config", function(config)
            Config = config
       end)
       LoggedIn = true
    end)
end)

RegisterNetEvent('LSCore:Client:OnPlayerUnload')
AddEventHandler('LSCore:Client:OnPlayerUnload', function()
    LoggedIn = false
end)

RegisterNetEvent('ls-police:SetCopCount')
AddEventHandler('ls-police:SetCopCount', function(Amount)
    CurrentCops = Amount
end)

-- Citizen.CreateThread(function()
--     Citizen.SetTimeout(1, function()
--         TriggerEvent("LSCore:GetObject", function(obj) LSCore = obj end)    
--         Citizen.Wait(250)
--         LSCore.Functions.TriggerCallback("ls-humanelabs:server:get:config", function(config)
--            Config = config
--         end)
--         local ExplosiveData = exports['ls-inventory-new']:GetItemData('explosive')
--         local KitData = exports['ls-inventory-new']:GetItemData('electronickit')
--         local CardData = exports['ls-inventory-new']:GetItemData('black-card')
--         RequirdItems = {[1] = {['Label'] = ExplosiveData['label'], ['Image'] = ExplosiveData["image"]}}
--         RequirdHackItems = {[1] = {['Label'] = KitData['label'], ['Image'] = KitData["image"]}, [2] = {['Label'] = CardData["label"], ['Image'] = CardData["image"]}}
--         LoggedIn = true
--      end)
-- end)


-- Code

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then 
            local NearElevator = false
            local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
            local LabElevatorDistance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.LabElevator['ToLab']['X'], Config.LabElevator['ToLab']['Y'], Config.LabElevator['ToLab']['Z'], true)
            local WaterdoorDistance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.LabElevator['ToWater']['X'], Config.LabElevator['ToWater']['Y'], Config.LabElevator['ToWater']['Z'], true)
            if LabElevatorDistance < 1.5 then
                NearElevator = true
                DrawText3D(Config.LabElevator['ToLab']['X'], Config.LabElevator['ToLab']['Y'], Config.LabElevator['ToLab']['Z'] + 0.1, '~g~E~s~ - Lift')
                DrawMarker(2, Config.LabElevator['ToLab']['X'], Config.LabElevator['ToLab']['Y'], Config.LabElevator['ToLab']['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                if IsControlJustReleased(0, 38) then
                    ElevatorToWater()
                end
            end
            if WaterdoorDistance < 1.5 then
                NearElevator = true
                DrawText3D(Config.LabElevator['ToWater']['X'], Config.LabElevator['ToWater']['Y'], Config.LabElevator['ToWater']['Z'] + 0.1, '~g~E~s~ - Lift')
                DrawMarker(2, Config.LabElevator['ToWater']['X'], Config.LabElevator['ToWater']['Y'], Config.LabElevator['ToWater']['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                if IsControlJustReleased(0, 38) then
                    ElevatorToLab()
                end
            end
            if not NearElevator then 
                Citizen.Wait(1000)
            end
        else
            Citizen.Wait(1000)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then 
            local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
            local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.HumanLabs['Coords']['Explosion']['X'], Config.HumanLabs['Coords']['Explosion']['Y'], Config.HumanLabs['Coords']['Explosion']['Z'], true)
            NearAnything = false
            if not Config.HumanLabs['BeingRobbed'] then
                if Distance < 1.25 then 
                    NearAnything = true
                    if not ShowingItems then
                        ShowingItems = true
                        NearExplosive = true
                        TriggerEvent('ls-inventory-new:client:set:required', RequirdItems, true)
                    end
                end
            end
            if Config.HumanLabs['BeingRobbed'] and not Config.HumanLabs['Hacked'] then
                local HDistance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.HumanLabs['Coords']['Hack']['X'], Config.HumanLabs['Coords']['Hack']['Y'], Config.HumanLabs['Coords']['Hack']['Z'], true)
                if HDistance < 1.5 then
                    NearAnything = true
                    if not ShowingItems then
                        ShowingItems = true
                        NearHack = true
                        TriggerEvent('ls-inventory-new:client:set:required', RequirdHackItems, true)
                    end
                end
            end
            if Config.HumanLabs['BeingRobbed'] then
                for k, v in pairs(Config.HumanLabs['Lockers']) do 
                    local LDistance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'], true)
                    if LDistance < 1.7 and not v['Busy'] and not v['IsOpen'] then
                        CurrentLocker = k
                        NearAnything = true
                        if not ShowingInteraction then
                            ShowingInteraction = true
                            exports['ls-ui']:ShowInteraction('[Lockpick] Kastje', 'primary')
                        end
                    end
                end
            end
            if not NearAnything then 
                NearExplosive, NearHack, CurrentLocker = false, false, nil
                if ShowingItems then
                    ShowingItems = false
                    TriggerEvent('ls-inventory-new:client:set:required', RequirdItems, false)
                    TriggerEvent('ls-inventory-new:client:set:required', RequirdHackItems, false)
                end
                if ShowingInteraction then
                    ShowingInteraction = false
                    exports['ls-ui']:HideInteraction()
                end
                Citizen.Wait(950)
            end
        else
            Citizen.Wait(1500)
        end
    end
end)

-- Events 

RegisterNetEvent('ls-humanelabs:client:set:lab:robbed')
AddEventHandler('ls-humanelabs:client:set:lab:robbed', function()
    Config.HumanLabs['BeingRobbed'] = true
    Citizen.SetTimeout(15000, function()
        TriggerServerEvent('ls-doors:server:set:door:locks', 51, 1)
    end)
end)

RegisterNetEvent('ls-items:client:use:explosive')
AddEventHandler('ls-items:client:use:explosive', function()
    if NearExplosive then
        if not Config.HumanLabs['BeingRobbed'] then
            if CurrentCops >= Config.CopsNeeded then
                local Time = 0
                local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
                TriggerEvent('ls-inventory-new:client:set:inventory:state', false)
                GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("weapon_stickybomb"), 1, false, true)
                Citizen.Wait(1000)
                TaskPlantBomb(GetPlayerPed(-1), PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, 218.5)
                LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, 'explosive', 1, false)
                TriggerEvent('ls-inventory-new:client:set:inventory:state', true)
                repeat
                    Time = Time + 1
                    Citizen.Wait(1000)
                until Time == 7
                AddExplosion(Config.HumanLabs['Coords']['Explosion']['X'], Config.HumanLabs['Coords']['Explosion']['Y'], Config.HumanLabs['Coords']['Explosion']['Z'], EXPLOSION_STICKYBOMB, 4.0, true, false, 20.0)
                LSCore.Functions.Notify("De deur is open geknald ga snel naar binnen!!", "success")
                TriggerServerEvent('ls-humanelabs:server:set:lab:robbed')
                StartLockdownEvent()
            else
                LSCore.Functions.Notify("Niet genoeg agenten! ("..Config.CopsNeeded.." Nodig)", "info")
            end
        end
    end
end)

RegisterNetEvent('ls-items:client:use:black-card')
AddEventHandler('ls-items:client:use:black-card', function()
    if NearHack then
        if Config.HumanLabs['BeingRobbed'] then
            LSCore.Functions.TriggerCallback('LSCore:HasItem', function(HasItem)
                if HasItem then
                    TriggerEvent('ls-inventory-new:client:set:inventory:state', false)
                    exports['minigame-shape']:StartShapeGame(function(Outcome)
                        if Outcome then
                            LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, 'black-card', 1, false)
                            TriggerEvent('ls-inventory-new:client:set:inventory:state', true)
                            TriggerServerEvent('ls-humanelabs:server:end:lockdown')
                            TriggerServerEvent("ls-sound:server:play:distance", 200.0, "Lock-Down-End", 1.0)
                        else
                            LSCore.Functions.Notify("Je hebt gefaalt..", "error")
                            TriggerEvent('ls-inventory-new:client:set:inventory:state', true)
                        end
                    end)
                end
            end, 'electronickit')
        end
    end 
end)

RegisterNetEvent('ls-items:client:use:lockpick')
AddEventHandler('ls-items:client:use:lockpick', function(IsAdvanced)
    if CurrentLocker ~= nil then
        if IsAdvanced then
            TriggerServerEvent('ls-humanelabs:server:set:locker:state', CurrentLocker, 'Busy', true)
            exports['ls-lockpick']:OpenLockpickGame(function(Success)
                if Success then
                    LockpickLocker()
                else
                    local RemoveChance = LSCore.Functions.GetMiniGameSkill('Lockpick')
                    if math.random(1, 100) < RemoveChance then
                        LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, 'advancedlockpick', 1, false)
                    end
                    TriggerServerEvent('ls-humanelabs:server:set:locker:state', CurrentLocker, 'Busy', false)
                end
            end)
        else
            LSCore.Functions.TriggerCallback('LSCore:HasItem', function(HasItem)
                if HasItem then
                    exports['ls-lockpick']:OpenLockpickGame(function(Success)
                        if Success then
                            TriggerServerEvent('ls-humanelabs:server:set:locker:state', CurrentLocker, 'Busy', true)
                            LockpickLocker()
                        else
                            local RemoveChance = LSCore.Functions.GetMiniGameSkill('Lockpick')
                            if math.random(1, 100) < (RemoveChance + 5) then
                                LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, 'lockpick', 1, false)
                            end
                            TriggerServerEvent('ls-humanelabs:server:set:locker:state', CurrentLocker, 'Busy', false)
                        end
                    end)
                end
            end, 'screwdriverset')
        end
    end
end)

RegisterNetEvent('ls-humanelabs:server:sync:lockers')
AddEventHandler('ls-humanelabs:server:sync:lockers', function(SyncData)
    Config.HumanLabs['Lockers'] = SyncData
end)

RegisterNetEvent('ls-humanelabs:server:end:lockdown')
AddEventHandler('ls-humanelabs:server:end:lockdown', function()
    Config.HumanLabs['Hacked'] = true
end)

-- Functions 

function StartLockdownEvent()
    SpawnHumaneLabsSecurity()
    TriggerServerEvent("ls-sound:server:play:distance", 200.0, "Lock-Down", 1.0)
    TriggerServerEvent('ls-police:server:alert:humanelabs', GetEntityCoords(GetPlayerPed(-1)), 'Chianski Passage')
    Citizen.Wait(2500)
    TriggerServerEvent('ls-police:server:alert:humanelabs', GetEntityCoords(GetPlayerPed(-1)), 'Chianski Passage')
end

function SpawnHumaneLabsSecurity()
    for k, v in pairs(Config.SecurityPeds) do
        exports['ls-assets']:RequestModelHash(v['Model'])
        local Security = CreatePed(7, v['Model'], v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'], v['Coords']['H'], 1, 1)
        SetPedShootRate(Security,  750)
        SetPedCombatAttributes(Security, 46, true)
        SetPedFleeAttributes(Security, 0, 0)
        SetPedAsEnemy(Security,true)
        SetPedMaxHealth(Security, 900)
        SetPedAlertness(Security, 3)
        SetPedCombatRange(Security, 0)
        SetPedCombatMovement(Security, 3)
        TaskCombatPed(Security, GetPlayerPed(-1), 0,16)
        GiveWeaponToPed(Security, GetHashKey("WEAPON_SMG"), 5000, true, true)
        SetPedRelationshipGroupHash( Security, GetHashKey("HATES_PLAYER"))
        SetPedDropsWeaponsWhenDead(Security, false)
        FreezeEntityPosition(Security, false)
    end
    exports['ls-assets']:RequestModelHash('cs_orleans')
    CreatePed(5, 'cs_orleans', 3553.53, 3685.28, 27.121, 257.27, 1, 1)
    CreatePed(5, 'cs_orleans', 3557.88, 3659.94, 28.12, 78.99, 1, 1)
end

function LockpickLocker()
    if not IsWearingHandshoes() then
        TriggerServerEvent("ls-police:server:create:evidence", 'Finger', GetEntityCoords(GetPlayerPed(-1)))
    end
    LockPicking = true
    LockPickAnimation()
    LSCore.Functions.Progressbar("open_locker", "Lockpicken..", math.random(34000, 58000), false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerServerEvent('ls-humanelabs:server:locker:reward:new:2021')
        TriggerServerEvent('ls-humanelabs:server:set:locker:state', CurrentLocker, 'IsOpen', true)
        TriggerServerEvent('ls-humanelabs:server:set:locker:state', CurrentLocker, 'Busy', false)
        StopAnimTask(GetPlayerPed(-1), "anim@gangops@facility@servers@", "hotwire", 1.0)
        LockPicking = false
    end, function() -- Cancel
        TriggerServerEvent('ls-humanelabs:server:set:locker:state', CurrentLocker, 'Busy', false)
        StopAnimTask(GetPlayerPed(-1), "anim@gangops@facility@servers@", "hotwire", 1.0)
        LSCore.Functions.Notify("Geannuleerd..", "error")
        LockPicking = false
    end)
    Citizen.CreateThread(function()
       while LockPicking do
           TriggerServerEvent('ls-ui:server:gain:stress', math.random(1, 3))
           Citizen.Wait(10000)
       end
   end)
end

function LockPickAnimation()
    exports['ls-assets']:RequestAnimationDict("veh@break_in@0h@p_m_one@")
    TaskPlayAnim(GetPlayerPed(-1), "veh@break_in@0h@p_m_one@", "low_force_entry_ds" ,3.0, 3.0, -1, 16, 0, false, false, false)
    Citizen.CreateThread(function()
        while LockPicking do
            TaskPlayAnim(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 3.0, 3.0, -1, 16, 0, 0, 0, 0)
            Citizen.Wait(1000)
        end
    end)
end

function ElevatorToWater()
    DoScreenFadeOut(450)
    Citizen.Wait(450)
    TriggerEvent("ls-sound:client:play", "hospital-elevator", 0.25)
    SetEntityCoords(GetPlayerPed(-1), Config.LabElevator['ToWater']['X'], Config.LabElevator['ToWater']['Y'], Config.LabElevator['ToWater']['Z'])
    Citizen.Wait(250)
    DoScreenFadeIn(450)
end

function ElevatorToLab()
    DoScreenFadeOut(450)
    Citizen.Wait(450)
    TriggerEvent("ls-sound:client:play", "hospital-elevator", 0.25)
    SetEntityCoords(GetPlayerPed(-1), Config.LabElevator['ToLab']['X'], Config.LabElevator['ToLab']['Y'], Config.LabElevator['ToLab']['Z'])
    Citizen.Wait(250)
    DoScreenFadeIn(450)
end

function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

function IsWearingHandshoes()
  local armIndex = GetPedDrawableVariation(GetPlayerPed(-1), 3)
  local model = GetEntityModel(GetPlayerPed(-1))
  local retval = true
  if model == GetHashKey("mp_m_freemode_01") then
      if Config.MaleNoHandshoes[armIndex] ~= nil and Config.MaleNoHandshoes[armIndex] then
          retval = false
      end
  else
      if Config.FemaleNoHandshoes[armIndex] ~= nil and Config.FemaleNoHandshoes[armIndex] then
          retval = false
      end
  end
  return retval
end