local CurrentGarage, NearGarage, ShowingInteractionss = nil, false, false

-- Code

-- // Loops \\ --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            if PlayerJob.name == 'police' and PlayerJob.onduty then
                NearGarage = false
                local PlayerCoords = GetEntityCoords(PlayerPedId())
                for k, v in pairs(Config.PoliceGarages) do
                    local Distance = #(PlayerCoords -  v['Coords'])
                    if Distance < v['Distance'] then
                        NearGarage, CurrentGarage = true, k
                        if not ShowingInteractionss then
                            ShowingInteractionss = true
                            if k == 'P1' or k == 'P2' then
                                exports['fw-ui']:ShowInteraction('[<i class="far fa-eye"></i>] Politie Garage', 'primary')
                            else
                                exports['fw-ui']:ShowInteraction('[F1] Politie Garage', 'primary')
                            end
                        end
                    end
                end
                if not NearGarage then
                    if ShowingInteractionss then
                        ShowingInteractionss = false
                        exports['fw-ui']:HideInteraction()
                    end
                    Citizen.Wait(500)
                    CurrentGarage = nil
                end
            else
                Citizen.Wait(500)
            end
        else
            Citizen.Wait(500)
        end
    end
end)

-- // Events \\ --

RegisterNetEvent('framework-police:client:open:garage')
AddEventHandler('framework-police:client:open:garage', function()
    local MenuItems = {}
    if CurrentGarage == 'P1' or CurrentGarage == 'P2' then
        for k, v in pairs(Config.PoliceVehicles) do
            if CanUseVehicle(v['Vehicle']) then
                local NewData = {}
                NewData['Title'] = LSCore.Shared.Vehicles[v['Vehicle']]['Name']..' ['..LSCore.Functions.GetPlayerData().job.plate..']'
                NewData['Desc'] = 'Motor: 100% Body: 100% Fuel: 100%'
                NewData['Data'] = {['Event'] = 'framework-police:client:take:out:vehicle', ['Type'] = 'Client', ['Plate'] = LSCore.Functions.GetPlayerData().job.plate, ['Model'] = v['Vehicle']}
                table.insert(MenuItems, NewData)
            end
        end
    else
        for k, v in pairs(Config.PoliceHelis) do
            if CanUseVehicle(v['Vehicle']) then
                local NewData = {}
                NewData['Title'] = v['Name']
                NewData['Desc'] = 'Motor: 100% Body: 100% Fuel: 100%'
                NewData['Data'] = {['Event'] = 'framework-police:client:take:out:vehicle', ['Type'] = 'Client', ['Plate'] = LSCore.Functions.GetPlayerData().job.plate, ['Model'] = v['Vehicle']}
                table.insert(MenuItems, NewData)
            end
        end
    end
    if (#MenuItems > 0) then
        local Data = {['Title'] = 'Politie Garage', ['MainMenuItems'] = MenuItems}
        LSCore.Functions.OpenMenu(Data)
    else
        LSCore.Functions.Notify("Er zitten geen politie voertuigen in deze garage..", "error", 5000)
    end
end)

RegisterNetEvent('framework-police:client:take:out:vehicle')
AddEventHandler('framework-police:client:take:out:vehicle', function(data)
    if CurrentGarage == 'P1' or CurrentGarage == 'P2' then
        local RandomCoords = Config.PoliceGarages[CurrentGarage]['Spawns'][math.random(1, #Config.PoliceGarages[CurrentGarage]['Spawns'])]['Coords']
        local CoordTable = {x = RandomCoords['X'], y = RandomCoords['Y'], z = RandomCoords['Z'], a = RandomCoords['H']}
        LSCore.Functions.TriggerCallback('LSCore:server:spawn:vehicle', function(Veh)
            while not NetworkDoesEntityExistWithNetworkId(Veh) do
                Citizen.Wait(1000)
            end
            local Vehicle = NetToVeh(Veh)
            -- Citizen.SetTimeout(750, function()
                SetVehicleDirtLevel(Vehicle, 0.0)
                exports['fw-els']:SetupEmergencyVehicle(Vehicle, GetVehicleNumberPlateText(Vehicle))
                exports['fw-vehicles']:SetVehicleKeys(data['Plate'], true, false)
                exports['fw-vehicles']:SetFuelLevel(Vehicle, data['Plate'], 100, false)
            -- end)
            LSCore.Functions.SetVehiclePlate(Vehicle, data['Plate'])
            LSCore.Functions.Notify("Je voertuig staat zo klaar..", "success", 5000)
        end, data['Model'], CoordTable, false, data['Plate'])
    else
        local Coords = Config.PoliceGarages[CurrentGarage]['Spawns'][1]['Coords']
        local CoordTable = {x = Coords['X'], y = Coords['Y'], z = Coords['Z'], a = Coords['H']}
        LSCore.Functions.TriggerCallback('LSCore:server:spawn:vehicle', function(Veh)
            while not NetworkDoesEntityExistWithNetworkId(Veh) do
                Citizen.Wait(1000)
            end
            local Vehicle = NetToVeh(Veh)
            SetVehicleDirtLevel(Vehicle, 0.0)
            exports['fw-vehicles']:SetVehicleKeys(data['Plate'], true, false)
            exports['fw-vehicles']:SetFuelLevel(Vehicle, data['Plate'], 100, false)
            LSCore.Functions.SetVehiclePlate(Vehicle, data['Plate'])
            Citizen.Wait(125)
            TaskWarpPedIntoVehicle(PlayerPedId(), Vehicle, -1)
        end, data['Model'], CoordTable, false, data['Plate'])
    end
end)

RegisterNetEvent('framework-police:client:delete:vehicle')
AddEventHandler('framework-police:client:delete:vehicle', function(Niks, Entity)
    LSCore.Functions.DeleteVehicle(Entity['Entity'])
end)

RegisterNetEvent('framework-police:client:spawn:boat')
AddEventHandler('framework-police:client:spawn:boat', function()
    local PlayerCoords = GetEntityCoords(PlayerPedId())
    local Plate = LSCore.Functions.GetPlayerData().job.plate
    local CoordTable = {x = PlayerCoords.x, y = PlayerCoords.y, z = PlayerCoords.z, a = GetEntityHeading(PlayerPedId())}
    LSCore.Functions.TriggerCallback('LSCore:server:spawn:vehicle', function(Veh)
        while not NetworkDoesEntityExistWithNetworkId(Veh) do
            Citizen.Wait(1000)
        end
        local Vehicle = NetToVeh(Veh)
        exports['fw-vehicles']:SetVehicleKeys(Plate, true, false)
        exports['fw-vehicles']:SetFuelLevel(Vehicle, Plate, 100, false)
        LSCore.Functions.SetVehiclePlate(Vehicle, Plate)
        Citizen.Wait(125)
        TaskWarpPedIntoVehicle(PlayerPedId(), Vehicle, -1)
    end, 'PolitieBoot', CoordTable, false, Plate)
end)

-- // Functions \\ --

function IsNearGarage()
    return NearGarage
end

function IsNearHeli()
    if CurrentGarage == 'P3' or CurrentGarage == 'P4' then
        return true
    end
end

function CanUseVehicle(VehicleName)
    local VehicleData = LSCore.Functions.GetPlayerData().metadata['duty-vehicle']
    if (VehicleName == 'PolitieTouran' or VehicleName == 'PolitieKlasse' or VehicleName == 'PolitieVito' or VehicleName == 'PolitieAmarok' or VehicleName == 'riot' or VehicleName == 'police2') and VehicleData['STANDAARD'] then
        return true
    elseif (VehicleName == 'PolitieVelar' or VehicleName == 'PolitieBmw' or VehicleName == 'PolitieAudiUnmarked') and VehicleData['UNMARKED'] then
        return true
    elseif (VehicleName == 'PolitieAudi' or VehicleName == 'PolitieRS6') and VehicleData['AUDI'] then
        return true
    elseif (VehicleName == 'PolitieZulu' or VehicleName == 'DsiZulu') and VehicleData['HELI'] then
        return true
    elseif (VehicleName == 'PolitieMotor') and VehicleData['MOTOR'] then
        return true
    else
        return false
    end
end
