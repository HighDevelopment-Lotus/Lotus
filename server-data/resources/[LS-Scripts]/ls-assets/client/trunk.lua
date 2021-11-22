local TrunkCam, InTrunk = nil, false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            if InTrunk then
                if IsEntityDead(GetPlayerPed(-1)) then
                    local Vehicle = GetEntityAttachedTo(PlayerPedId())
                    local VehicleCoords = GetOffsetFromEntityInWorldCoords(Vehicle, 0, -5.0, 0)
                    local Plate = GetVehicleNumberPlateText(Vehicle)
                    TrunkCams(false)
                    SetEntityVisible(GetPlayerPed(-1), true)
                    DetachEntity(GetPlayerPed(-1), true, true)
                    ClearPedTasks(GetPlayerPed(-1))
                    SetEntityCoords(GetPlayerPed(-1), VehicleCoords.x, VehicleCoords.y, VehicleCoords.z + 5.0)
                    SetEntityCollision(PlayerPedId(), true, true)
                    TriggerServerEvent('ls-assets:server:set:trunk:data', Plate, false)
                    InTrunk = false
                end
                Citizen.Wait(150)
            else
                Citizen.Wait(1500)
            end
        else
            Citizen.Wait(1500)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        local Vehicle = GetEntityAttachedTo(PlayerPedId())
        local CameraCoords = GetOffsetFromEntityInWorldCoords(Vehicle, 0, -5.5, 0)
        local VehicleHeading = GetEntityHeading(Vehicle)
        if TrunkCam ~= nil then
            SetCamRot(TrunkCam, -2.5, 0.0, VehicleHeading, 0.0)
            SetCamCoord(TrunkCam, CameraCoords.x, CameraCoords.y, CameraCoords.z + 2)
        else
            Citizen.Wait(1000)
        end
    end
end)

RegisterNetEvent('ls-assets:client:sync:trunk:data')
AddEventHandler('ls-assets:client:sync:trunk:data', function(Plate, ConfigData)
    Config.TrunkData[Plate] = ConfigData
end)

RegisterNetEvent('ls-assets:client:getin:trunk')
AddEventHandler('ls-assets:client:getin:trunk', function()
    local Vehicle, Distance = LSCore.Functions.GetClosestVehicle()
    if Vehicle ~= 0 and Distance < 5.0 then
        local VehicleClass = GetVehicleClass(Vehicle)
        local Plate = GetVehicleNumberPlateText(Vehicle)
        if Config.TrunkData[Plate] == nil then
            TriggerServerEvent('ls-assets:server:setup:trunk:data', Plate)
            Citizen.Wait(150)
            if not Config.TrunkData[Plate]['Busy'] then
                if GetVehicleDoorAngleRatio(Vehicle, 5) > 0 then
                    local ClassData = Config.VehicleOFfsets[VehicleClass]
                    if ClassData['CanEnter'] then
                        InTrunk = true
                        exports['ls-assets']:RequestAnimationDict("fin_ext_p1-7")
                        TriggerServerEvent('ls-assets:server:set:trunk:data', Plate, true)
                        TaskPlayAnim(GetPlayerPed(-1), "fin_ext_p1-7", "cs_devin_dual-7", 8.0, 8.0, -1, 1, 999.0, 0, 0, 0)
                        AttachEntityToEntity(GetPlayerPed(-1), Vehicle, 0, ClassData['X-Offset'], ClassData['Y-Offset'], ClassData['Z-Offset'], 0, 0, 40.0, 1, 1, 1, 1, 1, 1)
                        SetVehicleDoorShut(Vehicle, 5, false)
                        SetEntityVisible(GetPlayerPed(-1), false)
                        TrunkCams(true)
                    else
                        LSCore.Functions.Notify('Dit kan niet eens bij een motor..', 'error', 2500)
                    end
                else
                    LSCore.Functions.Notify('Is de kofferbak wel open?', 'error', 2500)
                end
            else
                LSCore.Functions.Notify('Er zit al iemand in de kofferbak..', 'error', 2500)
            end
        else
            if not Config.TrunkData[Plate]['Busy'] then
                if GetVehicleDoorAngleRatio(Vehicle, 5) > 0 then
                    local ClassData = Config.VehicleOFfsets[VehicleClass]
                    if ClassData['CanEnter'] then
                        InTrunk = true
                        exports['ls-assets']:RequestAnimationDict("fin_ext_p1-7")
                        TriggerServerEvent('ls-assets:server:set:trunk:data', Plate, true)
                        TaskPlayAnim(GetPlayerPed(-1), "fin_ext_p1-7", "cs_devin_dual-7", 8.0, 8.0, -1, 1, 999.0, 0, 0, 0)
                        AttachEntityToEntity(GetPlayerPed(-1), Vehicle, 0, ClassData['X-Offset'], ClassData['Y-Offset'], ClassData['Z-Offset'], 0, 0, 40.0, 1, 1, 1, 1, 1, 1)
                        SetVehicleDoorShut(Vehicle, 5, false)
                        SetEntityVisible(GetPlayerPed(-1), false)
                        TrunkCams(true)
                    else
                        LSCore.Functions.Notify('Dit kan niet eens bij een motor..', 'error', 2500)
                    end
                else
                    LSCore.Functions.Notify('Is de kofferbak wel open?', 'error', 2500)
                end
            else
                LSCore.Functions.Notify('Er zit al iemand in de kofferbak..', 'error', 2500)
            end
        end
    else
        LSCore.Functions.Notify('Geen voertuig gevonden..', 'error', 2500)
    end
end)

RegisterNetEvent('ls-assets:client:getout:trunk')
AddEventHandler('ls-assets:client:getout:trunk', function()
    local Vehicle = GetEntityAttachedTo(PlayerPedId())
    local VehicleCoords = GetOffsetFromEntityInWorldCoords(Vehicle, 0, -5.0, 0)
    local Plate = GetVehicleNumberPlateText(Vehicle)
    if GetVehicleDoorAngleRatio(Vehicle, 5) > 0 then
        TrunkCams(false)
        SetEntityVisible(GetPlayerPed(-1), true)
        DetachEntity(GetPlayerPed(-1), true, true)
        ClearPedTasks(GetPlayerPed(-1))
        SetEntityCoords(GetPlayerPed(-1), VehicleCoords.x, VehicleCoords.y, VehicleCoords.z)
        SetEntityCollision(PlayerPedId(), true, true)
        TriggerServerEvent('ls-assets:server:set:trunk:data', Plate, false)
        InTrunk = false
    else
        LSCore.Functions.Notify('Is de kofferbak wel open?', 'error', 2500)
    end
end)

function TrunkCams(bool)
    local Vehicle = GetEntityAttachedTo(PlayerPedId())
    local CamCoords = GetOffsetFromEntityInWorldCoords(Vehicle, 0, -5.5, 0)
    local VehicleHeading = GetEntityHeading(Vehicle)
    if bool then
        TrunkCam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
        SetCamActive(TrunkCam, true)
        SetCamCoord(TrunkCam, CamCoords.x, CamCoords.y, CamCoords.z + 2)
        SetCamRot(TrunkCam, -2.5, 0.0, VehicleHeading, 0.0)
        RenderScriptCams(true, false, 0, true, true)
    else
        RenderScriptCams(false, false, 0, 1, 0)
        DestroyCam(TrunkCam, false)
        TrunkCam = nil
    end
end

function GetInTrunkState()
    return InTrunk
end