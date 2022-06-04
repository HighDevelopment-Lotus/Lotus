local CurrentTrash, CurrentTrashBlip, TrashRoundAmount, JobVehicle, HasGarbage, TrashBagsAmount = nil, nil, 0, nil, false, 0

-- Code

-- // Loops \\ --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            local NearAnythings = false
            if PlayerJob.name == 'garbage' then
                local PlayerCoords = GetEntityCoords(PlayerPedId())
                    local Distance = #(PlayerCoords - vector3(-349.7829, -1569.798, 25.223709))
                    if Distance < 1.5 then
                        NearAnythings = true
                            if not ShowingInteraction then
                                ShowingInteraction = true
                                exports['fw-ui']:ShowInteraction('[G] Werken', 'primary')
                            end
                    end
                if not NearAnythings then
                    if ShowingInteraction then
                        ShowingInteraction = false
                        exports['fw-ui']:HideInteraction()
                    end
                    Citizen.Wait(450)
                end
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
            if PlayerJob.name == 'garbage' then
                if DoingJob and CurrentTrash ~= nil then
                    local NearAnything = false
                    local PlayerCoords = GetEntityCoords(PlayerPedId())
                    local VehicleCoords = GetOffsetFromEntityInWorldCoords(JobVehicle, 0.0, -4.5, 0.0)
                    local VDistance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, VehicleCoords.x, VehicleCoords.y, VehicleCoords.z, true)
                    if VDistance < 5.0 and HasGarbage then
                        NearAnything = true
                        DrawText3D(VehicleCoords.x, VehicleCoords.y, VehicleCoords.z + 0.1, '~g~E~s~ - Gooi in de wagen')
                        DrawMarker(2, VehicleCoords.x, VehicleCoords.y, VehicleCoords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 86, 232, 93, 255, false, false, false, 1, false, false, false)
                        if IsControlJustReleased(0, 38) then
                            if HasGarbage then
                                HasGarbage = false
                                exports['fw-assets']:RequestAnimationDict("missfbi4prepp1")
                                SetVehicleDoorOpen(JobVehicle, 5, false, false)
                                TaskPlayAnim(PlayerPedId(), 'missfbi4prepp1', '_bag_throw_garbage_man', 8.0, 8.0, 1100, 48, 0.0, 0, 0, 0)
                                Citizen.Wait(1250)
                                TaskPlayAnim(PlayerPedId(), 'missfbi4prepp1', 'exit', 8.0, 8.0, 1100, 48, 0.0, 0, 0, 0)
                                exports['fw-assets']:RemoveProp()
                                SetVehicleDoorShut(JobVehicle, 5, false)
                                TrashBagsAmount = TrashBagsAmount - 1
                                if TrashBagsAmount == 0 then
                                    TrashRoundAmount = TrashRoundAmount - 1
                                    if TrashRoundAmount ~= 0 then
                                        CurrentTrash = math.random(1, #Config.GarbageLocations) 
                                        TrashBagsAmount = math.random(1, 4)
                                        LSCore.Functions.Notify('Ga naar de volgende locatie', 'success', 5500)
                                        TriggerServerEvent('framework-jobmanager:server:add:payment', math.random(160, 350))
                                        -- TriggerServerEvent('framework-jobmanager:server:receive:materials')
                                        LSCore.Functions.TriggerCallback('framework-jobmanager:server:receive:materials', function()
                                        end)
                                        SetGarbageBlip(CurrentTrash)
                                    else
                                        CurrentTrash = nil
                                        RemoveBlip(CurrentTrashBlip)
                                        TriggerServerEvent('framework-jobmanager:server:add:payment', math.random(160, 350))
                                        LSCore.Functions.Notify('Je bent klaar. Breng je voertuig terug en ontvang je salaris!', 'success', 5500)
                                    end
                                else
                                    LSCore.Functions.Notify('Je bent nog niet klaar er ligt meer', 'info', 5500)
                                end
                            end
                        end 
                    end
                    if not NearAnything then
                        Citizen.Wait(1000)
                    end
                else
                    Citizen.Wait(1000)
                end
            end
        else
            Citizen.Wait(1000)
        end
    end
end)

-- // Events \\ --

RegisterNetEvent('framework-jobmanager:client:get:trash')
AddEventHandler('framework-jobmanager:client:get:trash', function()
    local PlayerCoords = GetEntityCoords(PlayerPedId())
    if CurrentTrash ~= nil then
        local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.GarbageLocations[CurrentTrash]['Coords']['X'], Config.GarbageLocations[CurrentTrash]['Coords']['Y'], Config.GarbageLocations[CurrentTrash]['Coords']['Z'], true)
        if Distance < 3.0 then
            if not HasGarbage then
                HasGarbage = true
                exports['fw-assets']:AddProp('Trash')
                exports['fw-assets']:RequestAnimationDict("missfbi4prepp1")
                TaskPlayAnim(PlayerPedId(), 'missfbi4prepp1', '_bag_walk_garbage_man', 6.0, -6.0, -1, 49, 0, 0, 0, 0)
            end
        else
            LSCore.Functions.Notify('Geen afval te vinden hiero', 'error', 5500)
        end  
    end
end)

RegisterNetEvent('framework-jobmanager:client:request:vehicle:trash')
AddEventHandler('framework-jobmanager:client:request:vehicle:trash', function()
    LoggedIn = true
    if not HasJobVehicle then
        -- LSCore.Functions.TriggerCallback("framework-jobmanager:server:do:bail", function(DidBail)
        --     if DidBail then
                StartGarbageRun()
                SpawnJobTrashVehicle()
                TriggerServerEvent('framework-jobmanager:server:set:duty', true)
                TriggerServerEvent('framework-jobmanager:server:add:payment', 350)
            -- else
            --   LSCore.Functions.Notify('Je hebt niet genoeg contant geld', 'error', 5500)
            -- end
        -- end, 350)
    else
        LSCore.Functions.Notify('Je hebt al een werk voertuig', 'error', 5500)
    end
end)

-- // Functions \\ --

function StartGarbageRun()
    DoingJob = true
    CurrentTrash = math.random(1, #Config.GarbageLocations) 
    TrashRoundAmount = math.random(7, 12)
    TrashBagsAmount = math.random(1, 4)
    SetGarbageBlip(CurrentTrash)
    LSCore.Functions.Notify('Je bent aan je shift begonnen', 'success', 5500)
end

function SpawnJobTrashVehicle()
    HasJobVehicle = true
    local Plate = "GARB"..tostring(math.random(1000, 9999))
    local CoordsTable = {x = Config.JobLocations['TrashVeh']['X'], y = Config.JobLocations['TrashVeh']['Y'], z = Config.JobLocations['TrashVeh']['Z'], a = Config.JobLocations['TrashVeh']['H']}
    LSCore.Functions.TriggerCallback('LSCore:server:spawn:vehicle', function(Veh)
        while not NetworkDoesEntityExistWithNetworkId(Veh) do
            Citizen.Wait(1000)
        end
        local Vehicle = NetToVeh(Veh)
        exports['fw-vehicles']:SetVehicleKeys(GetVehicleNumberPlateText(Vehicle), true, false)
        exports['fw-vehicles']:SetFuelLevel(Vehicle, GetVehicleNumberPlateText(Vehicle), 100, false)
        SetVehicleBodyHealth(Vehicle, 1000.0)
        Citizen.SetTimeout(1000, function()
            LSCore.Functions.SetVehiclePlate(Vehicle, Plate)
            JobVehicle = Vehicle
        end)
    end, 'trash2', CoordsTable, false, Plate)
end 

function SetGarbageBlip(CurrentTrashLoc)
    if CurrentTrashBlip ~= nil then
        RemoveBlip(CurrentTrashBlip)
    end
    local Coords = Config.GarbageLocations[CurrentTrashLoc]
    local TrashBlip = AddBlipForCoord(Coords['Coords']['X'], Coords['Coords']['Y'], Coords['Coords']['Z'])
    SetBlipSprite(TrashBlip, 306)
    SetBlipDisplay(TrashBlip, 4)
    SetBlipScale(TrashBlip, 0.48)
    SetBlipAsShortRange(TrashBlip, true)
    SetBlipColour(TrashBlip, 1)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName('Vuilniswerk')
    EndTextCommandSetBlipName(TrashBlip)
    CurrentTrashBlip = TrashBlip
    SetNewWaypoint(Coords['Coords']['X'], Coords['Coords']['Y'])
end

function ResetTrash()
    DoingJob = false
    CurrentTrash = nil
    TrashRoundAmount = 0
    RemoveBlip(CurrentTrashBlip)
    CurrentTrashBlip = nil
    JobVehicle = nil
end

function ReturnTrashVehicle()
    local veh = GetVehiclePedIsIn(PlayerPedId())
    LSCore.Functions.DeleteVehicle(veh)
end