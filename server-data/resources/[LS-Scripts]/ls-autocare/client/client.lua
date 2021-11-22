local MechanicProps = {}
local LSCore, LoggedIn, PlayerJob = exports['ls-core']:GetCoreObject(), false, {}
local InVehicle, NearTow = false, false
local CurrentMotorDamage, CurrentBodyDamage = 0, 0

RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1250, function()	 
        LSCore.Functions.TriggerCallback('ls-autocare:server:get:config', function(ConfigData)
           Config = ConfigData
        end)
        PlayerJob = LSCore.Functions.GetPlayerData().job
        SetupMechanicProps()
        LoggedIn = true
    end)
end)

RegisterNetEvent('LSCore:Client:OnPlayerUnload')
AddEventHandler('LSCore:Client:OnPlayerUnload', function()
    RemoveMechanicProps()
    LoggedIn = false
end)

RegisterNetEvent('LSCore:Client:OnJobUpdate')
AddEventHandler('LSCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

-- Citizen.CreateThread(function()
--     Citizen.SetTimeout(1250, function()
--         TriggerEvent("LSCore:GetObject", function(obj) LSCore = obj end) 
--         Citizen.Wait(250)
--         LSCore.Functions.TriggerCallback('ls-autocare:server:get:config', function(ConfigData)
--            Config = ConfigData
--         end)
--         SetupMechanicProps()
--         LoggedIn = true
--     end)
-- end)

-- Code

-- // Loops \\ --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                local Vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
                local CurrentMotor = GetVehicleEngineHealth(Vehicle)
                local CurrentBody = GetVehicleBodyHealth(Vehicle)
                local VehicleClass = GetVehicleClass(Vehicle)
                local Plate = GetVehicleNumberPlateText(Vehicle)
                if Config.VehiclePartData[Plate] ~= nil then
                    if not InVehicle then
                        InVehicle = true
                        CurrentBodyDamage = GetVehicleBodyHealth(Vehicle)
                        CurrentMotorDamage = GetVehicleEngineHealth(Vehicle)
                    end
                    if GetPedInVehicleSeat(Vehicle, -1) == PlayerPedId() and VehicleClass ~= 13 then
                        if CurrentBody < CurrentBodyDamage or CurrentBody > CurrentBodyDamage and CurrentBody ~= CurrentBodyDamage then
                            if math.ceil(CurrentBodyDamage - CurrentBody) > 35 then
                                TriggerServerEvent('ls-autocare:server:do:damage', Plate)
                            end
                            --print('Body Damage', CurrentBodyDamage, math.ceil(CurrentBodyDamage - CurrentBody))
                            CurrentBodyDamage = CurrentBody
                        end
                        if CurrentMotor < CurrentMotorDamage or CurrentMotor > CurrentMotorDamage and CurrentMotor ~= CurrentMotorDamage then
                            if math.ceil(CurrentMotorDamage - CurrentMotor) > 45 then
                                TriggerServerEvent('ls-autocare:server:do:damage', Plate)
                            end
                            --print('Motor Damage', CurrentMotorDamage, math.ceil(CurrentMotorDamage - CurrentMotor))
                            CurrentMotorDamage = CurrentMotor
                        end
                    end
                    Citizen.Wait(250)
                end
            else
                Citizen.Wait(450)
                InVehicle = false
                CurrentMotorDamage = 0
                CurrentBodyDamage = 0
            end
        else
            Citizen.Wait(1500)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                local Vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
                local Plate = GetVehicleNumberPlateText(Vehicle)
                local Speed = GetEntitySpeed(Vehicle) * 3.6
                local VehicleClass = GetVehicleClass(Vehicle)
                if GetPedInVehicleSeat(Vehicle, -1) == PlayerPedId() and VehicleClass ~= 13 then
                    if Config.VehiclePartData[Plate] ~= nil then
                        if Config.VehiclePartData[Plate]['Aandrijfas']['Procent'] < 10 then
                            if Speed > 10 then
                                local RandomValue = math.random(1,2)
                                if RandomValue == 1 then
                                    TaskVehicleTempAction(GetPlayerPed(-1), Vehicle, 10, 1250)
                                else
                                    TaskVehicleTempAction(GetPlayerPed(-1), Vehicle, 11, 1250)
                                end
                            end
                        end
                        if Config.VehiclePartData[Plate]['Brandstof Injectoren']['Procent'] < 10 then
                            local CurrentFuel = exports['ls-fuel']:GetFuelLevel(Plate)
                            exports['ls-fuel']:SetFuelLevel(Vehicle, Plate, math.random(5,10), false)
                            Citizen.Wait(1500)
                            exports['ls-fuel']:SetFuelLevel(Vehicle, Plate, CurrentFuel, false)
                        end
                        if Config.VehiclePartData[Plate]['Motor']['Procent'] < 10 then
                            SetVehicleEngineOn(Vehicle, false, true, true)
                            Citizen.Wait(2500)
                            SetVehicleEngineOn(Vehicle, true, true, true)
                        end
                        if Config.VehiclePartData[Plate]['Remmen']['Procent'] < 10 then
                            if Config.VehicleBrakes[Plate] == nil or GetVehicleHandlingFloat(Vehicle, "CHandlingData", "fBrakeForce") == Config.VehicleBrakes[Plate] then
                                Config.VehicleBrakes[Plate] = GetVehicleHandlingFloat(Vehicle, "CHandlingData", "fBrakeForce")
                                SetVehicleHandlingFloat(Vehicle, "CHandlingData", "fBrakeForce", 0.0)
                            end
                        else
                            if Config.VehicleBrakes[Plate] ~= nil then
                                SetVehicleHandlingFloat(Vehicle, "CHandlingData", "fBrakeForce", Config.VehicleBrakes[Plate])
                                Config.VehicleBrakes[Plate] = nil
                            end
                        end
                        if Config.VehiclePartData[Plate]['Koppeling']['Procent'] < 10 then
                            SetEntityMaxSpeed(Vehicle, 15.0)
                        else
                            SetEntityMaxSpeed(Vehicle, GetVehicleHandlingFloat(Vehicle, "CHandlingData", "fInitialDriveMaxFlatVel"))
                        end
                    end
                end
                Citizen.Wait(25000)
            end
        else
            Citizen.Wait(1500)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn and PlayerJob.name == 'mechanic' or PlayerJob.name == 'repairshop' then
            local NearTow = false
            local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
            for k, v in pairs(Config.Locations['TowVeh']) do
                local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['X'], v['Y'], v['Z'], true)
                if Distance < 4.0 then
                    NearTow = true
                    DrawMarker(2, v['X'], v['Y'], v['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 242, 148, 41, 255, false, false, false, 1, false, false, false)
                    if IsPedInAnyVehicle(GetPlayerPed(-1)) then
                        DrawText3D(v['X'], v['Y'], v['Z'] + 0.15, '~g~E~s~ - Takelvoertuig Opbergen')
                        if IsControlJustReleased(0, 38) then 
                            local Vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
                            LSCore.Functions.DeleteVehicle(Vehicle)
                        end
                    else
                        DrawText3D(v['X'], v['Y'], v['Z'] + 0.15, '~g~E~s~ - Takelvoertuig')
                        if IsControlJustReleased(0, 38) then 
                            local Plate = math.random(11,99)..'TOW'..math.random(111,999)
                            local CoordTable = {x = v['X'], y = v['Y'], z = v['Z'], a = v['H']}
                            LSCore.Functions.TriggerCallback('LSCore:server:spawn:vehicle', function(Veh)
                                while not NetworkDoesEntityExistWithNetworkId(Veh) do
                                    Citizen.Wait(1000)
                                end
                                local Vehicle = NetToVeh(Veh)
                                exports['ls-vehiclekeys']:SetVehicleKeys(GetVehicleNumberPlateText(Vehicle), true, false)
                                exports['ls-fuel']:SetFuelLevel(Vehicle, GetVehicleNumberPlateText(Vehicle), 100, false)
                                LSCore.Functions.SetVehiclePlate(Vehicle, Plate)
                                Citizen.Wait(125)
                                TaskWarpPedIntoVehicle(GetPlayerPed(-1), Vehicle, -1)
                            end, 'towtruck', CoordTable, false, Plate)
                        end
                    end
                end
            end
            if not NearTow then
                Citizen.Wait(450)
            end
        else
            Citizen.Wait(450)
        end
    end
end)

-- // Events \\ --

RegisterNetEvent('ls-autocare:client:open:storage')
AddEventHandler('ls-autocare:client:open:storage', function(StashType)
    if exports['ls-inventory-new']:CanOpenInventory() then
        TriggerServerEvent('ls-inventory-new:server:open:inventory:other', StashType, 'Stash', 20, 20000000)
    end
end)

RegisterNetEvent('ls-autocare:client:open:craft')
AddEventHandler('ls-autocare:client:open:craft', function()
    if exports['ls-inventory-new']:CanOpenInventory() then
        local CraftingData = {['Type'] = 'Crafting', ['InvName'] = 'Autocare Workbench', ['Items'] = Config.MechanicCrafting}
		TriggerServerEvent('ls-inventory-new:server:open:inventory:other', CraftingData, 'Crafting')
    end
end)

RegisterNetEvent('ls-autocare:client:check:vehicle')
AddEventHandler('ls-autocare:client:check:vehicle', function()
    local Vehicle, Distance = LSCore.Functions.GetClosestVehicle()
    local Plate = GetVehicleNumberPlateText(Vehicle)
    if Distance < 3.5 then
        if Config.VehiclePartData[Plate] ~= nil then
            OpenVehicleServiceMenu(Plate)
            NetworkRequestControlOfEntity(Vehicle)
        else
            LSCore.Functions.Notify("Dit voertuig heeft geen onderdelen..", "error")
        end
    end
end)

RegisterNetEvent('ls-autocare:client:repair:part')
AddEventHandler('ls-autocare:client:repair:part', function(data)
    if not exports['ls-progressbar']:GetTaskBarStatus() and not Config.BusyVehicles[Plate] then
        if Config.VehiclePartData[data['Plate']] ~= nil then
            if Config.VehiclePartData[data['Plate']][data['Part']]['Procent'] < 100 then
                LSCore.Functions.TriggerCallback('ls-autocare:server:has:repair:parts', function(HasParts)
                    if HasParts then
                        TriggerEvent('ls-inventory-new:client:set:inventory:state', false)
                        LSCore.Functions.Progressbar("repait", data['Part'].." Repareren..", 10000, false, true, {
                            disableMovement = false,
                            disableCarMovement = false,
                            disableMouse = false,
                            disableCombat = true,
                        }, {
                            animDict = "mini@repair",
                            anim = "fixing_a_player",
                            flags = 16,
                        }, {}, {}, function() -- Done
                            TriggerServerEvent('ls-autocare:server:set:part:data', data['Plate'], data['Part'], 100)
                            TriggerEvent('ls-inventory-new:client:set:inventory:state', true)
                            StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_player", 1.0)
                            LSCore.Functions.Notify(data['Part'].." gerepareed!", "success")
                        end, function()
                           TriggerEvent('ls-inventory-new:client:set:inventory:state', true)
                           LSCore.Functions.Notify("Geannuleerd..", "error")
                           StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_player", 1.0)
                        end)
                    else
                        LSCore.Functions.Notify("Je hebt deze spullen niet..", "error")
                    end
                end, Config.RepairCosts[data['Part']], data['Class'])
            end
        end
    end
end)

RegisterNetEvent('ls-autocare:client:use:part')
AddEventHandler('ls-autocare:client:use:part', function(Part, Class, ItemName)
    local Vehicle, Distance = LSCore.Functions.GetClosestVehicle()
    local Plate = GetVehicleNumberPlateText(Vehicle)
    if not exports['ls-progressbar']:GetTaskBarStatus() and not Config.BusyVehicles[Plate] then
        if Distance < 3.5 then
            if Config.VehiclePartData[Plate] ~= nil then
                if Config.VehiclePartData[Plate][Part]['Class'] ~= Class then
                    TriggerEvent('ls-inventory-new:client:set:inventory:state', false)
                    LSCore.Functions.Progressbar("apply", Part.." Monteren..", 10000, false, true, {
                        disableMovement = false,
                        disableCarMovement = false,
                        disableMouse = false,
                        disableCombat = true,
                    }, {
                        animDict = "mini@repair",
                        anim = "fixing_a_player",
                        flags = 16,
                    }, {}, {}, function() -- Done
                        TriggerEvent('ls-inventory-new:client:set:inventory:state', true)
                        LSCore.Functions.Notify(Part.." gemonteerd!", "success")
                        LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, ItemName, 1, false)
                        StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_player", 1.0)
                        TriggerServerEvent('ls-autocare:server:set:new:part', Plate, Part, Class)
                    end, function()
                       TriggerEvent('ls-inventory-new:client:set:inventory:state', true)
                       LSCore.Functions.Notify("Geannuleerd..", "error")
                       StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_player", 1.0)
                    end)
                else
                    LSCore.Functions.Notify("Deze klasse zit al op het voertuig..", "error")
                end
            end
        end
    end
end)

RegisterNetEvent('ls-autocare:client:use:repair')
AddEventHandler('ls-autocare:client:use:repair', function()
    local Vehicle, Distance = LSCore.Functions.GetClosestVehicle()
    local Plate = GetVehicleNumberPlateText(Vehicle)
    if not exports['ls-progressbar']:GetTaskBarStatus() and not Config.BusyVehicles[Plate] then
        if Distance < 4.0 then
            LSCore.Functions.Progressbar("apply", "Repareren..", 10000, false, true, {
                disableMovement = false,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = true,
            }, {
                animDict = "mini@repair",
                anim = "fixing_a_player",
                flags = 16,
            }, {}, {}, function() -- Done
                NetworkRequestControlOfEntity(Vehicle)
                while not NetworkHasControlOfEntity(Vehicle) do
                    Wait(10)
                end
                SetVehicleFixed(Vehicle)
                TriggerEvent('ls-inventory-new:client:set:inventory:state', true)
                LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, 'big-repair', 1, false)
                StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_player", 1.0)
            end, function()
               TriggerEvent('ls-inventory-new:client:set:inventory:state', true)
               LSCore.Functions.Notify("Geannuleerd..", "error")
               StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_player", 1.0)
            end)
        end
    end
end)

RegisterNetEvent('ls-autocare:client:open:hood')
AddEventHandler('ls-autocare:client:open:hood', function()
    local Vehicle, Distance = LSCore.Functions.GetClosestVehicle()
    NetworkRequestControlOfEntity(Vehicle)
    while not NetworkHasControlOfEntity(Vehicle) do
        Wait(10)
    end
    if GetVehicleDoorAngleRatio(Vehicle, 4) > 0 then
        SetVehicleDoorShut(Vehicle, 4, false)
    else
        SetVehicleDoorOpen(Vehicle, 4, false, false)
    end
end)

RegisterNetEvent('ls-autocare:server:sync:parts:config')
AddEventHandler('ls-autocare:server:sync:parts:config', function(ConfigData)
    Config.VehiclePartData = ConfigData
end)

-- // Functions \\ --

function SetupMechanicProps()
    for k, v in pairs(Config.MechanicProps) do
        local Prop = GetHashKey(v['Prop'])
        exports['ls-assets']:RequestModelHash(Prop)
        local Object = CreateObject(Prop, v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'], false, false, false)
        SetEntityHeading(Object, 211.78)
        FreezeEntityPosition(Object, true)
        SetEntityInvincible(Object, true)
        SetEntityVisible(Object, false)
        table.insert(MechanicProps, Object)
    end
end

function RemoveMechanicProps()
    for k, v in pairs(MechanicProps) do
        DeleteEntity(v)
        DeleteObject(v)
    end
    MechanicProps = {}
end

function OpenVehicleServiceMenu(Plate)
    local MenuItems = {}
    for k, v in pairs(Config.VehiclePartData[Plate]) do
      local NewData = {}
      NewData['Title'] = k
      NewData['Desc'] = 'Klasse: '..v['Class']..' Percentage: '..v['Procent']..'% <br>Kosten: '..Config.RepairCosts[k][v['Class']]['Amount']..'x '..Config.RepairCosts[k]['Label']
      NewData['Data'] = {['Event'] = 'ls-autocare:client:repair:part', ['Type'] = 'Client', ['Plate'] = Plate, ['Class'] = v['Class'], ['Procent'] = v['Procent'], ['Part'] = k}
      table.insert(MenuItems, NewData)
    end
    local Data = {['Title'] = 'Reparatie Acties ['..Plate..']', ['MainMenuItems'] = MenuItems}
    LSCore.Functions.OpenMenu(Data)
end

function SetupVehicleData(Plate)
    LSCore.Functions.TriggerCallback('ls-autocare:server:get:vehicle:part', function(PartResult)
        if PartResult ~= nil and PartResult ~= false then
            TriggerServerEvent('ls-autocare:server:register:vehicle', Plate, PartResult)
        end
    end, Plate)
end

function RemoveVehicleData(Plate)
    if Config.VehiclePartData[Plate] ~= nil then
        TriggerServerEvent('ls-autocare:server:delete:vehicle:data', Plate)
    end
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