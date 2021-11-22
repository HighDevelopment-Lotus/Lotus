local DoingOxy, Delivering, OutOfZoneTime, DoingTimer = false, false, 10000, false
local OxyData = {['CurrentOxyLocation'] = nil, ['CurrentOxyVehicle'] = nil, ['CurrentOxyPed'] = nil, ['VehicleActive'] = false, ['InsideZone'] = false, ['StartedJob'] = false, ['DeliverBoxes'] = 0, ['TimesNeeded'] = 0}

-- // Loops \\ --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn and OxyData['CurrentOxyLocation'] ~= nil then
            local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
            local Distance = #(PlayerCoords - vector3(Config.OxyLocations[OxyData['CurrentOxyLocation']]['Coords'].x, Config.OxyLocations[OxyData['CurrentOxyLocation']]['Coords'].y, Config.OxyLocations[OxyData['CurrentOxyLocation']]['Coords'].z))
            if Distance < 17.5 then
                DrawMarker(2, Config.OxyLocations[OxyData['CurrentOxyLocation']]['Coords'].x, Config.OxyLocations[OxyData['CurrentOxyLocation']]['Coords'].y, Config.OxyLocations[OxyData['CurrentOxyLocation']]['Coords'].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                if not OxyData['InsideZone'] then
                    OxyData['InsideZone'] = true
                    OutOfZoneTime = 10000
                    DoingTimer = false
                end
                if not OxyData['StartedJob'] then
                    LSCore.Functions.Notify('Blijf zoveel mogelijk op deze plek tot je klaar bent!', 'success', 5000)
                    OxyData['StartedJob'] = true
                    StartJobAtLocation()
                end
            else
                if OxyData['InsideZone'] then
                    OxyData['InsideZone'] = false
                end
                if OxyData['StartedJob'] then
                    OxyData['StartedJob'] = false
                    LittleReset()
                    StartTimer()
                end
            end
        else
            Citizen.Wait(450)
        end
    end
end)

-- // Events \\ --

RegisterNetEvent('ls-illegal:client:start:oxy')
AddEventHandler('ls-illegal:client:start:oxy', function()
    LSCore.Functions.TriggerCallback('LSCore:RemoveCash', function(DidPay)
        if DidPay then
            DoingOxy = true
            Citizen.SetTimeout(1000, function()
                StartOxyRun()
            end)
        else
            LSCore.Functions.Notify('Je hebt niet genoeg contant..', 'error', 5000)
        end
    end, 1000)
end)

RegisterNetEvent('ls-illegal:client:try:deliver')
AddEventHandler('ls-illegal:client:try:deliver', function()
    if not exports['ls-progressbar']:GetTaskBarStatus() then
        Delivering = true
        TriggerEvent('ls-inventory-new:client:set:inventory:state', false)
        LSCore.Functions.Progressbar("oxy-box", "Afgeven..", 5000, false, false, {
            disableMovement = true,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
         }, {}, {}, {}, function() -- Done
            Delivering = false
            LSCore.Functions.TriggerCallback('ls-illegal:server:deliver:oxy', function(DidDeliver)
                if DidDeliver then
                    TriggerEvent('ls-inventory-new:client:set:inventory:state', true)
                    if math.random(1,100) <= 13 then
                        TriggerServerEvent('ls-police:server:send:oxy:alert', GetEntityCoords(GetPlayerPed(-1)), LSCore.Functions.GetStreetLabel())
                    end
                    if OxyData['DeliverBoxes'] - 1 > 0 then
                        OxyData['DeliverBoxes'] = OxyData['DeliverBoxes'] - 1
                        OxyData['VehicleActive'] = false
                        TaskVehicleDriveWander(OxyData['CurrentOxyPed'], OxyData['CurrentOxyVehicle'], 15.0, 786603)
                        Citizen.Wait(8000)
                        DeleteVehicle(OxyData['CurrentOxyVehicle'])
                        DeletePed(OxyData['CurrentOxyPed'])
                        OxyData['CurrentOxyVehicle'] = nil
                        OxyData['CurrentOxyPed'] = nil
                        StartJobAtLocation()
                    else
                        if OxyData['TimesNeeded'] - 1 > 0 then
                            OxyData['VehicleActive'] = false
                            OxyData['DeliverBoxes'] = 0
                            OxyData['TimesNeeded'] = OxyData['TimesNeeded'] - 1
                            TaskVehicleDriveWander(OxyData['CurrentOxyPed'], OxyData['CurrentOxyVehicle'], 15.0, 786603)
                            Citizen.Wait(8000)
                            DeleteVehicle(OxyData['CurrentOxyVehicle'])
                            DeletePed(OxyData['CurrentOxyPed'])
                            OxyData['CurrentOxyVehicle'] = nil
                            OxyData['CurrentOxyPed'] = nil
                            GetNewOxyLocation()
                        else
                            TaskVehicleDriveWander(OxyData['CurrentOxyPed'], OxyData['CurrentOxyVehicle'], 15.0, 786603)
                            Citizen.Wait(8000)
                            DeleteVehicle(OxyData['CurrentOxyVehicle'])
                            DeletePed(OxyData['CurrentOxyPed'])
                            StopOxyRun()
                        end
                    end
                end
            end, OxyData['CurrentOxyLocation'])
         end, function()
            -- Cant Cancel
        end)
    end
end)

-- // Function \\ --

function StartJobAtLocation()
    local Timer = 2500
    local VehicleCoords = Config.OxyLocations[OxyData['CurrentOxyLocation']]['SpawnCoords']
    local DriveCoords = Config.OxyLocations[OxyData['CurrentOxyLocation']]['DriveCoords']
    Citizen.SetTimeout(math.random(10000, 17500), function()
        if OxyData['InsideZone'] then
            local RandomPed = Config.DefaultOxyData['Peds'][math.random(1, #Config.DefaultOxyData['Peds'])]
            local RandomVehicle = Config.DefaultOxyData['Vehicles'][math.random(1, #Config.DefaultOxyData['Vehicles'])]
            exports['ls-assets']:RequestModelHash(RandomPed)
            exports['ls-assets']:RequestModelHash(RandomVehicle)
            local OxyCar = CreateVehicle(RandomVehicle, VehicleCoords.x, VehicleCoords.y, VehicleCoords.z, VehicleCoords.w, true)
            local OxyPed = CreatePedInsideVehicle(OxyCar, 4, RandomPed, -1, true, true)
            SetVehicleOnGroundProperly(OxyCar)
            SetEntityInvincible(OxyCar, true)
            SetEntityInvincible(OxyPed, true)
            SetBlockingOfNonTemporaryEvents(OxyPed, true)
            TaskVehicleDriveToCoord(OxyPed, OxyCar, DriveCoords.x, DriveCoords.y, DriveCoords.z, 10.0, 1, GetEntityModel(OxyCar), 786603, 2.0, true)
            OxyData['CurrentOxyVehicle'] = OxyCar
            OxyData['CurrentOxyPed'] = OxyPed
            OxyData['VehicleActive'] = true
            Citizen.CreateThread(function()
                while OxyData['VehicleActive'] and not Delivering do
                    Citizen.Wait(4)
                    local VehicleCoords = GetEntityCoords(OxyData['CurrentOxyVehicle'])
                    local Distance = #(VehicleCoords - vector3(DriveCoords.x, DriveCoords.y, DriveCoords.z))
                    if Distance < 8.0 then
                        Timer = Timer - 1
                        if Timer == 0 then
                            OxyData['VehicleActive'] = false
                            LSCore.Functions.Notify('Dan niet he..', 'error', 5000)
                            TaskVehicleDriveWander(OxyData['CurrentOxyPed'], OxyData['CurrentOxyVehicle'], 15.0, 786603)
                            Citizen.Wait(8000)
                            DeleteVehicle(OxyData['CurrentOxyVehicle'])
                            DeletePed(OxyData['CurrentOxyPed'])
                            OxyData['CurrentOxyVehicle'] = nil
                            OxyData['CurrentOxyPed'] = nil
                            StartJobAtLocation()
                        end
                    end
                end
            end)
        end
    end)
end

function GetNewOxyLocation()
    OxyData['CurrentOxyLocation'] = math.random(1, #Config.OxyLocations)
    OxyData['DeliverBoxes'] = 5
    OxyData['StartedJob'] = false
    SetNewWaypoint(Config.OxyLocations[OxyData['CurrentOxyLocation']]['Coords'].x, Config.OxyLocations[OxyData['CurrentOxyLocation']]['Coords'].y)
    LSCore.Functions.Notify('Ga naar de volgende locatie..', 'success', 5000)
end

function StartOxyRun()
    DoingOxy = true
    OxyData['DeliverBoxes'] = 5
    OxyData['TimesNeeded'] = math.random(2,3)
    OxyData['CurrentOxyLocation'] = math.random(1, #Config.OxyLocations)
    TriggerServerEvent('ls-illegal:server:recieve:boxes', (OxyData['TimesNeeded'] * Config.DefaultOxyData['BoxAmount']))
    SetNewWaypoint(Config.OxyLocations[OxyData['CurrentOxyLocation']]['Coords'].x, Config.OxyLocations[OxyData['CurrentOxyLocation']]['Coords'].y)
end

function LittleReset()
    OxyData['VehicleActive'] = false
    DeleteVehicle(OxyData['CurrentOxyVehicle'])
    DeletePed(OxyData['CurrentOxyPed'])
    OxyData['CurrentOxyVehicle'] = nil
    OxyData['CurrentOxyPed'] = nil
end

function StopOxyRun()
    DoingOxy, Delivering, OutOfZoneTime, DoingTimer = false, false, 10000, false
    OxyData = {['CurrentOxyLocation'] = nil, ['CurrentOxyVehicle'] = nil, ['CurrentOxyPed'] = nil, ['VehicleActive'] = false, ['InsideZone'] = false, ['StartedJob'] = false, ['DeliverBoxes'] = 0, ['TimesNeeded'] = 0}
    LSCore.Functions.Notify('Je bent gestopt met werken..', 'error', 5000)
end

function StartTimer()
    DoingTimer = true
    Citizen.CreateThread(function()
        while DoingTimer do
            Citizen.Wait(4)
            OutOfZoneTime = OutOfZoneTime - 1
            if OutOfZoneTime == 0 then
                DoingTimer = false
                StopOxyRun()
            end
            --print(OutOfZoneTime)
        end
    end)
end

function CanStartOxy()
    if not DoingOxy then
        return true
    end 
end

function CanDeliverOxyBox(Entity)
    local HasPackage = exports['ls-inventory-new']:HasEnoughOfItem('oxy-box', 1)
    if HasPackage and OxyData['InsideZone'] and not Delivering then
        if Entity['Entity'] == OxyData['CurrentOxyVehicle'] then
            return true
        else
            return false
        end
    else
        return false
    end
end