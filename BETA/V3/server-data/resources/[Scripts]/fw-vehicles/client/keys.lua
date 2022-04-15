local LSCore, LoggedIn, CurrentPlate = exports['fw-base']:GetCoreObject(), false, nil
local Clicked, IsRobbing, LastVehicle = false, false, nil

RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1250, function()
        LSCore.Functions.TriggerCallback("framework-vehiclekeys:server:get:config", function(ConfigData)
           Config = ConfigData
        end)
        LoggedIn = true
    end)
end)

RegisterNetEvent('LSCore:Client:OnPlayerUnload')
AddEventHandler('LSCore:Client:OnPlayerUnload', function()
    LoggedIn = false
end)

-- Citizen.CreateThread(function()
--     Citizen.SetTimeout(1, function() 
--         Citizen.Wait(250)
--         LSCore.Functions.TriggerCallback("framework-vehiclekeys:server:get:config", function(ConfigData)
--            Config = ConfigData
--         end)
--         LoggedIn = true
--     end)
-- end)

-- Code

-- // Loops \\ --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            if IsPedInAnyVehicle(PlayerPedId()) then
                local Vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                if GetPedInVehicleSeat(Vehicle, -1) == PlayerPedId() then
                    local Plate = GetVehicleNumberPlateText(Vehicle)
                    CurrentPlate = Plate
                    if LastVehicle ~= Vehicle then
                        if HasVehicleKey(Plate) then
                            SetVehicleEngineOn(Vehicle, true, false, true)
                            HasCurrentKey = true
                        else
                            HasCurrentKey = false
                            SetVehicleEngineOn(Vehicle, false, false, true)
                        end
                        LastVehicle = Vehicle
                    else
                        Citizen.Wait(100)
                    end
                else
                    Citizen.Wait(100)
                end
                if not HasCurrentKey and GetPedInVehicleSeat(Vehicle, -1) == PlayerPedId() then
                    SetVehicleEngineOn(Vehicle, false, false, true)
                end
            else
                CurrentPlate = nil
                Citizen.Wait(100)
            end
        else
            Citizen.Wait(1000)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2)
        if LoggedIn then
            DisableControlAction(0, 14, true)
            DisableControlAction(0, 15, true)
            DisableControlAction(0, 16, true)
            DisableControlAction(0, 17, true)
            DisableControlAction(0, 99, true)
            DisableControlAction(0, 115, true)
            DisableControlAction(0, 261, true)
            DisableControlAction(0, 262, true)
            if IsPedInAnyVehicle(PlayerPedId(), false) then
                local Vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
                local Plate = GetVehicleNumberPlateText(Vehicle)
                if IsControlPressed(2, 75) and GetIsVehicleEngineRunning(Vehicle) then
                    if GetPedInVehicleSeat(Vehicle, -1) == PlayerPedId() then
                        if IsPedInAnyVehicle(PlayerPedId(), false) and not IsEntityDead(PlayerPedId()) then
                            if HasVehicleKey(Plate) then
                                TaskLeaveVehicle(PlayerPedId(), Vehicle, 0)
                                Citizen.Wait(100)
                                SetVehicleEngineOn(Vehicle, true, true, true)
                                LastVehicle = nil
                            else
                                TaskLeaveVehicle(PlayerPedId(), Vehicle, 0)
                            end
                        end
                    end
                end
                if not IsPauseMenuActive() then
                    if IsDisabledControlJustPressed(0, 14) then
                        if GetPedInVehicleSeat(Vehicle, -1) == PlayerPedId() then
                            TriggerEvent('framework-vehiclekeys:client:toggle:engine', false)
                        end
                    end
                    if IsDisabledControlJustPressed(0, 15) then
                        if GetPedInVehicleSeat(Vehicle, -1) == PlayerPedId() then
                            TriggerEvent('framework-vehiclekeys:client:toggle:engine', true)
                        end
                    end
                end
            else
                Citizen.Wait(350)
            end
        else
            Citizen.Wait(350)
        end
    end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(7)
        if LoggedIn then
            if not IsRobbing then 
                if GetVehiclePedIsTryingToEnter(PlayerPedId()) ~= nil and GetVehiclePedIsTryingToEnter(PlayerPedId()) ~= 0 then
                    local Vehicle = GetVehiclePedIsTryingToEnter(PlayerPedId())
                    local Driver = GetPedInVehicleSeat(Vehicle, -1)
                    if Driver ~= 0 and not IsPedAPlayer(Driver) then
                       if IsEntityDead(Driver) then
                           IsRobbing = true
                           LSCore.Functions.Progressbar("rob_keys", "Sleutels pakken..", 3000, false, true,
                            {}, {}, {}, {}, function()
                                local VehicleNet = NetworkGetNetworkIdFromEntity(Vehicle)
                                SetNetworkIdCanMigrate(VehicleNet, true)
                                SetVehicleHasBeenOwnedByPlayer(Vehicle, true)
                                SetEntityAsMissionEntity(Vehicle, false, false)
                                SetNetworkIdExistsOnAllMachines(VehicleNet, true)
                                NetworkRegisterEntityAsNetworked(Vehicle)
                                SetVehicleKeys(GetVehicleNumberPlateText(Vehicle), true, false)
                                IsRobbing = false
                           end) 
                       end
                    end
                else
                    Citizen.Wait(10)
                end
             else
                Citizen.Wait(10)
            end
        else
            Citizen.Wait(1000)
        end
    end
end)


RegisterKeyMapping('vehlock', 'Voertuig slot', 'keyboard', 'L')

RegisterCommand('vehlock', function()
    TriggerEvent('framework-vehiclekeys:client:toggle:locks')
end)

-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(7)
--         if LoggedIn then
--             if IsControlJustReleased(1, 182) then
--                 TriggerEvent('framework-vehiclekeys:client:toggle:locks')
--             end
--         else
--             Citizen.Wait(450)
--         end
--     end
-- end)

-- // Events \\ --

RegisterNetEvent('framework-vehiclekeys:client:sync:keys')
AddEventHandler('framework-vehiclekeys:client:sync:keys', function(Plate, KeyData)
    Config.VehicleKeys[Plate] = KeyData
    local Vehicle, Distance = LSCore.Functions.GetClosestVehicle()
    local ClosestPlate = GetVehicleNumberPlateText(Vehicle)
    if CurrentPlate ~= nil and CurrentPlate == Plate or Distance < 4.5 and ClosestPlate == Plate then
        LastVehicle = 0
    end
end)

RegisterNetEvent('framework-vehiclekeys:client:give:key')
AddEventHandler('framework-vehiclekeys:client:give:key', function()
    local Vehicle = LSCore.Functions.GetClosestVehicle()
    local Plate = GetVehicleNumberPlateText(Vehicle)
    local Player = LSCore.Functions.GetPlayerData()
    local Data = {['Title'] = 'Speler Id?', ['Type'] = 'number', ['Logo'] = '<i class="fas fa-user-alt"></i>'}
    if Config.VehicleKeys[Plate] ~= nil and Config.VehicleKeys[Plate][Player.citizenid] then
        LSCore.Functions.OpenInput(Data, function(ReturnData)
            if ReturnData ~= false then
                local PlayerCoords = GetEntityCoords(PlayerPedId())
                local Target = GetPlayerFromServerId(tonumber(ReturnData))
                local TargetPlayer = GetPlayerPed(Target)
                local TargetCoords = GetEntityCoords(TargetPlayer)
                local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, TargetCoords.x, TargetCoords.y, TargetCoords.z, true)
                if TargetPlayer ~= PlayerPedId() and Distance < 3.0 then
                    SetVehicleKeys(Plate, true, ReturnData)
                else
                    LSCore.Functions.Notify('Er is iets fout gegaan..', 'error')
                end
            end
        end)
    end
end)

RegisterNetEvent('framework-vehiclekeys:client:toggle:engine')
AddEventHandler('framework-vehiclekeys:client:toggle:engine', function(Type)
    local Vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    local EngineOn = IsVehicleEngineOn(Vehicle)
    local Plate = GetVehicleNumberPlateText(Vehicle)
    if HasVehicleKey(Plate) then 
        if Type ~= nil then
            if Type then
                SetVehicleEngineOn(Vehicle, true, false, true)
            else
                SetVehicleEngineOn(Vehicle, false, false, true)
            end
        else
            if EngineOn then
                SetVehicleEngineOn(Vehicle, false, false, true)
            else
                SetVehicleEngineOn(Vehicle, true, false, true)
            end
        end
    end
end)

RegisterNetEvent('framework-vehiclekeys:client:toggle:locks')
AddEventHandler('framework-vehiclekeys:client:toggle:locks', function()
    local TargetEntity, EntityType, TargetCoords = exports['fw-ui']:GetEntityPlayerIsLookingAt(1.0, 0.2, 2)
    if EntityType == 2 then
        local Distance = #(GetEntityCoords(PlayerPedId()) - TargetCoords)
        if Distance < 1.9 then
            local VehicleLocks = GetVehicleDoorLockStatus(TargetEntity)
            local Plate = GetVehicleNumberPlateText(TargetEntity)
            if HasVehicleKey(Plate) then
                if VehicleLocks == 1 then
                    SetVehicleDoorsLocked(TargetEntity, 2)
                    ClearPedTasks(PlayerPedId())
                    TriggerEvent('framework-vehicleley:client:blink:lights', TargetEntity)
                    TriggerServerEvent("framework-sound:server:play:distance", 4.5, "car-lock", 0.2)
                else
                    SetVehicleDoorsLocked(TargetEntity, 1)
                    ClearPedTasks(PlayerPedId())
                    TriggerEvent('framework-vehicleley:client:blink:lights', TargetEntity)
                    TriggerServerEvent("framework-sound:server:play:distance", 4.5, "car-unlock", 0.2)
                end
                exports['fw-assets']:RequestAnimationDict("anim@heists@keycard@")
                TaskPlayAnim(PlayerPedId(), "anim@heists@keycard@", "exit", 8.0, 1.0, -1, 48, 0, 0, 0, 0)
                Citizen.Wait(500)
                ClearPedTasks(PlayerPedId())
            end
        end
    end
end)

RegisterNetEvent('framework-items:client:use:lockpick')
AddEventHandler('framework-items:client:use:lockpick', function(IsAdvanced)
    local Vehicle, VehDistance = LSCore.Functions.GetClosestVehicle()
    local Plate = GetVehicleNumberPlateText(Vehicle)
    if VehDistance <= 4.5 then
        if not HasVehicleKey(Plate) then
            if IsPedInAnyVehicle(PlayerPedId()) and GetPedInVehicleSeat(Vehicle, -1) == PlayerPedId() then
                exports['fw-assets']:RequestAnimationDict("anim@amb@clubhouse@tutorial@bkr_tut_ig3@")
                TaskPlayAnim(PlayerPedId(), 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer' ,3.0, 3.0, -1, 16, 0, false, false, false)
                exports['fw-ui']:StartSkillTest(4, 'Normal', function(Outcome)
                    if Outcome then
                        local VehicleNet = NetworkGetNetworkIdFromEntity(Vehicle)
                        SetVehicleKeys(Plate, true, false)
                        SetNetworkIdCanMigrate(VehicleNet, true)
                        SetVehicleHasBeenOwnedByPlayer(Vehicle, true)
                        SetEntityAsMissionEntity(Vehicle, false, false)
                        SetNetworkIdExistsOnAllMachines(VehicleNet, true)
                        NetworkRegisterEntityAsNetworked(Vehicle)
                        StopAnimTask(PlayerPedId(), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
                    else
                        local RemoveChance = LSCore.Functions.GetMiniGameSkill('Lockpick')
                        if IsAdvanced then
                            if math.random(1, 100) < (RemoveChance - 10) then
                                LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, 'advancedlockpick', 1, false)
                            end
                        else
                            if math.random(1, 100) < (RemoveChance + 10) then
                                LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, 'lockpick', 1, false)
                            end
                        end
                        LSCore.Functions.Notify("Mislukt..", 'error')
                        StopAnimTask(PlayerPedId(), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
                    end
                end)
            else
                local VehicleLocks = GetVehicleDoorLockStatus(Vehicle)
                if VehicleLocks == 2 then
                exports['fw-assets']:RequestAnimationDict("anim@amb@clubhouse@tutorial@bkr_tut_ig3@")
                TaskPlayAnim(PlayerPedId(), 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer' ,3.0, 3.0, -1, 16, 0, false, false, false)
                TriggerEvent('ultra-voltlab', 60, function(outcome ,reason)
                -- exports['fw-ui']:StartSkillTest(3, 'Normal', function(Outcome)
                        -- if Outcome then
                        if outcome == 1 then
                            SetVehicleDoorsLocked(Vehicle, 1)
                            TriggerEvent('framework-vehicleley:client:blink:lights', Vehicle)
                            TriggerServerEvent("framework-sound:server:play:distance", 5, "car-unlock", 0.2)
                            StopAnimTask(PlayerPedId(), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
                        else
                            local RemoveChance = LSCore.Functions.GetMiniGameSkill('Lockpick')
                            if IsAdvanced then
                                if math.random(1, 100) < (RemoveChance - 8) then
                                    LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, 'advancedlockpick', 1, false)
                                end
                            else
                                if math.random(1, 100) < (RemoveChance + 10) then
                                    LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, 'lockpick', 1, false)
                                end
                            end
                            LSCore.Functions.Notify("Mislukt..", 'error')
                            StopAnimTask(PlayerPedId(), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
                        end
                    end)
                end
            end
        end
    end
end)

RegisterNetEvent('framework-vehicleley:client:blink:lights')
AddEventHandler('framework-vehicleley:client:blink:lights', function(Vehicle)
  SetVehicleLights(Vehicle, 2)
  SetVehicleBrakeLights(Vehicle, true)
  SetVehicleInteriorlight(Vehicle, true)
  SetVehicleIndicatorLights(Vehicle, 0, true)
  SetVehicleIndicatorLights(Vehicle, 1, true)
  Citizen.Wait(450)
  SetVehicleIndicatorLights(Vehicle, 0, false)
  SetVehicleIndicatorLights(Vehicle, 1, false)
  Citizen.Wait(450)
  SetVehicleInteriorlight(Vehicle, true)
  SetVehicleIndicatorLights(Vehicle, 0, true)
  SetVehicleIndicatorLights(Vehicle, 1, true)
  Citizen.Wait(450)
  SetVehicleLights(Vehicle, 0)
  SetVehicleBrakeLights(Vehicle, false)
  SetVehicleInteriorlight(Vehicle, false)
  SetVehicleIndicatorLights(Vehicle, 0, false)
  SetVehicleIndicatorLights(Vehicle, 1, false)
end)

-- // Functions \\ --

function SetVehicleKeys(Plate, Bool, CitizenId)
    local Cid = CitizenId ~= nil and CitizenId or false
    TriggerServerEvent('framework-vehiclekeys:server:set:keys', Plate, Bool, Cid)
end

function HasVehicleKey(Plate)
    if Config.VehicleKeys[Plate] ~= nil then
        if Config.VehicleKeys[Plate][LSCore.Functions.GetPlayerData().citizenid] then
            return true
        else
            return false
        end
    else
        return false
    end
end