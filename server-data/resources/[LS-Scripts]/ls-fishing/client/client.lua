local LSCore, LoggedIn = exports['ls-core']:GetCoreObject(), false
local IsSelling, DoingSomething, CanSell = false, false, true
local CurrentBlip, CurrentRadiusBlip, LastLocation = {}, {}, nil
local CurrentLocation = {['Name'] = 'Fish1', ['Coords'] = {['X'] = 241.00, ['Y'] = 3993.00, ['Z'] = 30.40}}

RegisterNetEvent("LSCore:Client:OnPlayerLoaded")
AddEventHandler("LSCore:Client:OnPlayerLoaded", function()
    Citizen.SetTimeout(750, function()
        LSCore.Functions.TriggerCallback('ls-fishing:server:get:location', function(LocationData)
            CurrentLocation = LocationData
            TriggerEvent('ls-fishing:client:sync:location', LocationData)
        end)
        Citizen.Wait(250)
        LoggedIn = true
    end)
end)

RegisterNetEvent('LSCore:Client:OnPlayerUnload')
AddEventHandler('LSCore:Client:OnPlayerUnload', function()
    LoggedIn = false
end)

-- Citizen.CreateThread(function()
--     Citizen.SetTimeout(1, function()
--         TriggerEvent("LSCore:GetObject", function(obj) LSCore = obj end)    
--         LSCore.Functions.TriggerCallback('ls-fishing:server:get:location', function(LocationData)
--             CurrentLocation = LocationData
--             TriggerEvent('ls-fishing:client:sync:location', LocationData)
--         end)  
--         Citizen.Wait(250)
--         LoggedIn = true
--     end)
-- end)

-- Code

Citizen.CreateThread(function()
    Citizen.Wait(15000)
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            NearFishArea = false
            local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
            local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, CurrentLocation['Coords']['X'], CurrentLocation['Coords']['Y'], CurrentLocation['Coords']['Z'], true)
            if Distance <= 75.0 then
                NearFishArea = true
                Config.CanFish = true
            end
            if not NearFishArea then
                Citizen.Wait(1500)
                Config.CanFish = false
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            NearArea = false
            local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
            local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations['Boat']['X'], Config.Locations['Boat']['Y'], Config.Locations['Boat']['Z'], true)
            if Distance <= 2.0 then
                NearArea = true
                DrawMarker(2, Config.Locations['Boat']['X'], Config.Locations['Boat']['Y'], Config.Locations['Boat']['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 48, 255, 58, 255, false, false, false, 1, false, false, false)
                DrawText3D(Config.Locations['Boat']['X'], Config.Locations['Boat']['Y'], Config.Locations['Boat']['Z'] + 0.15, '~g~E~s~ - Boot Huren ~g~€~s~500')
                if IsControlJustReleased(0, 38) then
                    LSCore.Functions.TriggerCallback("ls-fishing:server:can:pay", function(DidPay)
                        if DidPay then
                            HasPayedForBoat = true
                            SpawnFishBoat()
                        end
                    end, Config.BoatPrice)
                end
            end
            local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, 1476.4, 3781.60, 29.85, true)
            if Distance <= 15.5 and IsPedInAnyBoat(GetPlayerPed(-1)) then
                NearArea = true
                DrawMarker(2, 1476.4, 3781.60, 29.85, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 48, 255, 58, 255, false, false, false, 1, false, false, false)
                DrawText3D(1476.4, 3781.60, 29.85 + 0.15, '~g~E~s~ - Boot Terug Brengen ~g~€~s~500')
                if IsControlJustReleased(0, 38) then
                    if HasPayedForBoat then
                        local Vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
                        HasPayedForBoat = false
                        LSCore.Functions.DeleteVehicle(Vehicle)
                        TriggerServerEvent('ls-fishing:server:repay:bail')
                        SetEntityCoords(GetPlayerPed(-1), 1552.42, 3797.91, 34.25)
                    else
                        LSCore.Functions.Notify('Je hebt niet voor deze boot betaald..', 'error')
                    end
                end
            end
            if not NearArea then
                Citizen.Wait(1500)
            end
        end
    end
end)

RegisterNetEvent('ls-fishing:client:sell:fish')
AddEventHandler('ls-fishing:client:sell:fish', function()
    if CanSell then
        CanSell = false
        TriggerServerEvent('ls-fishing:server:sell:items')
        Citizen.SetTimeout((60 * 1000) * 1, function()
            CanSell = true
        end)
    end
end)

RegisterNetEvent('ls-fishing:client:rod:anim')
AddEventHandler('ls-fishing:client:rod:anim', function()
    exports['ls-assets']:AddProp('FishingRod')
    exports['ls-assets']:RequestAnimationDict('amb@world_human_stand_fishing@idle_a')
    TaskPlayAnim(GetPlayerPed(-1), "amb@world_human_stand_fishing@idle_a", "idle_a", 3.0, 3.0, -1, 49, 0, 0, 0, 0)
end)

RegisterNetEvent('ls-fishing:client:use:box')
AddEventHandler('ls-fishing:client:use:box', function(ItemName)
    if not DoingSomething then
        DoingSomething = true
        if ItemName == 'fish-box' then
            LSCore.Functions.TriggerCallback('LSCore:HasItem', function(HasItem)
                if HasItem then
                    TriggerEvent('ls-inventory-new:client:set:inventory:state', false)
                    exports['ls-ui']:StartSkillTest(2, 'Normal', function(Outcome)
                        if Outcome then
                            DoingSomething = false
                            LSCore.Functions.Progressbar("open-box", "Doos Openbreken..", 20000, false, true, {
                                disableMovement = false,
                                disableCarMovement = false,
                                disableMouse = false,
                                disableCombat = true,
                            }, {}, {}, {}, function() -- Done
                                DoingSomething = false
                                TriggerServerEvent('ls-fishing:server:unbox', ItemName)
                                TriggerEvent('ls-inventory-new:client:set:inventory:state', true)
                            end, function()
                               DoingSomething = false
                               TriggerEvent('ls-inventory-new:client:set:inventory:state', true)
                               LSCore.Functions.Notify("Geannuleerd..", "error")
                            end)
                        else
                            DoingSomething = false
                            TriggerEvent('ls-inventory-new:client:set:inventory:state', true)
                            LSCore.Functions.Notify("Gefaalt..", "error")
                        end
                    end) 
                else
                    LSCore.Functions.Notify("Je hebt geen grote lockpick..", "error")
                end
            end, "advancedlockpick") 
        else
            LSCore.Functions.TriggerCallback("ls-fishing:server:HasFishItem", function(HasFishItems)
                if HasFishItems then
                    LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, 'drill-bit', 1, false)
                    TriggerEvent('ls-inventory-new:client:set:inventory:state', false)
                    exports['ls-assets']:RequestAnimationDict("anim@heists@fleeca_bank@drilling")
                    TaskPlayAnim(GetPlayerPed(-1), 'anim@heists@fleeca_bank@drilling', 'drill_straight_idle' , 3.0, 3.0, -1, 1, 0, false, false, false)
                    exports['ls-assets']:AddProp('Drill')
                    exports['minigame-drill']:StartDrilling(function(Success)
                        if Success then
                            LSCore.Functions.Progressbar("open-box", "Doos Openbreken..", 20000, false, true, {
                                disableMovement = false,
                                disableCarMovement = false,
                                disableMouse = false,
                                disableCombat = true,
                            }, {}, {}, {}, function() -- Done
                                DoingSomething = false
                                exports['ls-assets']:RemoveProp()
                                TriggerServerEvent('ls-fishing:server:unbox', ItemName)
                                StopAnimTask(GetPlayerPed(-1), "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 1.0)
                                TriggerEvent('ls-inventory-new:client:set:inventory:state', true)
                            end, function()
                               DoingSomething = false
                               exports['ls-assets']:RemoveProp()
                               TriggerEvent('ls-inventory-new:client:set:inventory:state', true)
                               StopAnimTask(GetPlayerPed(-1), "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 1.0)
                               LSCore.Functions.Notify("Geannuleerd..", "error")
                            end)
                        else
                            DoingSomething = false
                            exports['ls-assets']:RemoveProp()
                            TriggerEvent('ls-inventory-new:client:set:inventory:state', true)
                            StopAnimTask(GetPlayerPed(-1), "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 1.0)
                            LSCore.Functions.Notify("Gefaalt..", "error")
                        end
                    end) 
                else
                    LSCore.Functions.Notify('Je mist iets..', 'error', 2500)
                end
            end)
        end
    end
end)

RegisterNetEvent('ls-fishing:client:use:fishingrod')
AddEventHandler('ls-fishing:client:use:fishingrod', function()
    Citizen.SetTimeout(1200, function()
        if not Config.UsingRod then
            if Config.CanFish then
                if not IsPedInAnyVehicle(GetPlayerPed(-1)) then
                    if not IsEntityInWater(GetPlayerPed(-1)) then
                        Config.UsingRod = true
                        FreezeEntityPosition(GetPlayerPed(-1), true)
                        TriggerEvent('ls-fishing:client:rod:anim')
                        LSCore.Functions.Notify('Wachten op vis..', 'info')
                        Citizen.Wait(math.random(4000, 10000))
                        exports['ls-ui']:StartSkillTest(4, 'Normal', function(Outcome)
                            if Outcome then
                                FreezeEntityPosition(GetPlayerPed(-1), false)
                                exports['ls-assets']:RemoveProp()
                                Config.UsingRod = false
                                SucceededAttempts = 0
                                TriggerServerEvent('ls-fishing:server:fish:154:reward:new:55')
                                StopAnimTask(GetPlayerPed(-1), "amb@world_human_stand_fishing@idle_a", "idle_a", 1.0)
                            else
                                FreezeEntityPosition(GetPlayerPed(-1), false)
                                exports['ls-assets']:RemoveProp()
                                Config.UsingRod = false
                                LSCore.Functions.Notify('Je faalde..', 'error')
                                SucceededAttempts = 0
                                StopAnimTask(GetPlayerPed(-1), "amb@world_human_stand_fishing@idle_a", "idle_a", 1.0)
                            end
                        end)
                    else
                        LSCore.Functions.Notify('Je bent aan het zwemmen nerd..', 'error')
                    end
                else
                    LSCore.Functions.Notify('Je zit in een voertuig..', 'error')
                end
            else
                LSCore.Functions.Notify('Je bent niet eens in een vis gebied..', 'error')
            end
        end
    end)
end)

RegisterNetEvent('ls-fishing:client:sync:location')
AddEventHandler('ls-fishing:client:sync:location', function(RandomLocation)
    CurrentLocation = RandomLocation
    if CurrentBlip ~= nil and CurrentRadiosBlip ~= nil then
        RemoveBlip(CurrentBlip)
        RemoveBlip(CurrentRadiosBlip)
    end
    Citizen.SetTimeout(250, function()
        CurrentRadiosBlip = AddBlipForRadius(RandomLocation['Coords']['X'], RandomLocation['Coords']['Y'], RandomLocation['Coords']['Z'], 75.0)        
        SetBlipRotation(CurrentRadiosBlip, 0)
        SetBlipColour(CurrentRadiosBlip, 19)
        
        CurrentBlip = AddBlipForCoord(RandomLocation['Coords']['X'], RandomLocation['Coords']['Y'], RandomLocation['Coords']['Z'])
        SetBlipSprite(CurrentBlip, 68)
        SetBlipDisplay(CurrentBlip, 4)
        SetBlipScale(CurrentBlip, 0.7)
        SetBlipColour(CurrentBlip, 0)
        SetBlipAsShortRange(CurrentBlip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName('Visgebied')
        EndTextCommandSetBlipName(CurrentBlip)
    end)
end)

function SpawnFishBoat()
    local CoordTable = {x = 1517.25, y = 3836.86, z = 29.60, a = 37.31}
    LSCore.Functions.TriggerCallback('LSCore:server:spawn:vehicle', function(Veh)
        while not NetworkDoesEntityExistWithNetworkId(Veh) do
            Citizen.Wait(1000)
        end
        local Vehicle = NetToVeh(Veh)
        exports['ls-vehiclekeys']:SetVehicleKeys(GetVehicleNumberPlateText(Vehicle), true, false)
        exports['ls-fuel']:SetFuelLevel(vehicle, GetVehicleNumberPlateText(Vehicle), 100, true)
        Citizen.Wait(125)
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), Vehicle, -1)
    end, 'dinghy', CoordTable, false, nil)
end

-- // Functions \\ --

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