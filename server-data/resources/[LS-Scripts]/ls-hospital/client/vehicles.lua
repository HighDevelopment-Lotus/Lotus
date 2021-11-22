local CurrentGarage, ShowingGarageInteract = false, false

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(4)
        if LoggedIn then
            local NearAnything = false
            local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
            for k, v in pairs(Config.Locations['Garages']) do
                local Distance = #(PlayerCoords - v['Coords'])
                if Distance < 5.0 then
                    NearAnything, CurrentGarage = true, k
                    if not ShowingGarageInteract then
                        ShowingGarageInteract = true
                        exports['ls-ui']:ShowInteraction('[F1] Garage')
                    end
                end
            end
            if not NearAnything then
                if ShowingGarageInteract then
                    ShowingGarageInteract = false
                    exports['ls-ui']:HideInteraction()
                end
                NearGarage, CurrentGarage = false, nil
                Citizen.Wait(450)
            end
        else
            Citizen.Wait(450)
        end
    end
end)

-- // Events \\ --

RegisterNetEvent('ls-hospital:client:spawn:vehicle')
AddEventHandler('ls-hospital:client:spawn:vehicle', function(VehicleModel)
    if VehicleModel == 'AmbulanceHeli' and CurrentGarage == 2 then
        local CoordTable = {x = 351.79, y = -588.09, z = 74.16, a = 253.27}
        LSCore.Functions.TriggerCallback('LSCore:server:spawn:vehicle', function(Veh)
            while not NetworkDoesEntityExistWithNetworkId(Veh) do
                Citizen.Wait(1000)
            end
            local Vehicle = NetToVeh(Veh)
            SetVehicleDirtLevel(Vehicle, 0.0)
            exports['ls-vehiclekeys']:SetVehicleKeys(GetVehicleNumberPlateText(Vehicle), true, false)
            exports['ls-fuel']:SetFuelLevel(Vehicle, GetVehicleNumberPlateText(Vehicle), 100, false)
            LSCore.Functions.Notify("Helicopter op de helipad geplaatst..", "success", 5000)
        end, 'AmbulanceHeli', CoordTable, false)
    else
        local RandomCoords = Config.Locations['Garages'][CurrentGarage]['Spawns'][math.random(1, #Config.Locations['Garages'][CurrentGarage]['Spawns'])]['Coords']
        local CoordTable = {x = RandomCoords.x, y = RandomCoords.y, z = RandomCoords.z, a = RandomCoords.w}
        LSCore.Functions.TriggerCallback('LSCore:server:spawn:vehicle', function(Veh)
            while not NetworkDoesEntityExistWithNetworkId(Veh) do
                Citizen.Wait(1000)
            end
            local Vehicle = NetToVeh(Veh)
            SetVehicleDirtLevel(Vehicle, 0.0)
            exports['ls-emergencylights']:SetupEmergencyVehicle(Vehicle, GetVehicleNumberPlateText(Vehicle))
            exports['ls-vehiclekeys']:SetVehicleKeys(GetVehicleNumberPlateText(Vehicle), true, false)
            exports['ls-fuel']:SetFuelLevel(Vehicle, GetVehicleNumberPlateText(Vehicle), 100, false)
            LSCore.Functions.Notify("Voertuig op een parkeer vak geplaatst..", "success", 5000)
        end, VehicleModel, CoordTable, false)
    end
end)

-- // Functions \\ --

function GetGarageShit()
    if CurrentGarage == 1 then
        return {'ambulance:garage:touran', 'ambulance:garage:sprinter', 'vehicle:delete'}
    elseif CurrentGarage == 2 then
        return {'ambulance:garage:heli', 'vehicle:delete'}
    else
        return false
    end
end