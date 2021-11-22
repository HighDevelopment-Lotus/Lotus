local CurrentTow, TowBlips, CurrentTowVehicle, HasVehicleSpawned = nil, nil, nil, false

-- Code

-- // Loops \\ --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            if PlayerJob.name == 'tow' then
                local NearAnything = false
                local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
                if CurrentTow ~= nil then
                    local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.TowLocations[CurrentTow]['Coords']['X'], Config.TowLocations[CurrentTow]['Coords']['Y'], Config.TowLocations[CurrentTow]['Coords']['Z'], true)
                    if Distance < 200.0 and not HasVehicleSpawned then
                        NearAnything = true
                        HasVehicleSpawned = true
                        SpawnTowVehicle(Config.TowLocations[CurrentTow]['Coords'], Config.TowLocations[CurrentTow]['Model'])
                    end
                end
                if not NearAnything then
                    Citizen.Wait(1000)
                end
            else
                Citizen.Wait(1000)
            end
        else
            Citizen.Wait(1000)
        end
    end
end)

-- // Events \\ --

RegisterNetEvent('ls-jobmanager:client:request:vehicle:tow')
AddEventHandler('ls-jobmanager:client:request:vehicle:tow', function()
    if not HasJobVehicle then
        LSCore.Functions.TriggerCallback("ls-jobmanager:server:do:bail", function(DidBail)
            if DidBail then
                SpawnJobTowVehicle()
                TriggerServerEvent('ls-jobmanager:server:set:duty', true)
                TriggerServerEvent('ls-jobmanager:server:add:payment', 350)  
            else
              LSCore.Functions.Notify('Je hebt niet genoeg contant geld..', 'error', 5500)
            end
        end, 350)
    else
        LSCore.Functions.Notify('Je hebt al een werk voertuig..', 'error', 5500)
    end
end)

RegisterNetEvent('ls-jobmanager:client:toggle:npc:tow')
AddEventHandler('ls-jobmanager:client:toggle:npc:tow', function()
    if not DoingJob then
        local RandomVehicle = math.random(1, #Config.TowLocations)
        DoingJob, CurrentTow = true, RandomVehicle
        CreateTowBlip()
        LSCore.Functions.Notify('Je bent begonnen met een takel opdracht rij naar de locatie om het voertuig op te halen..', 'success', 5500)
    else
        if CurrentTowVehicle ~= nil then
            LSCore.Functions.Notify('Je bent nog bezig met een voertuig..', 'error', 5500)
        else
            ResetTowJob()
            LSCore.Functions.Notify('Je bent gestopt met je takel opdracht..', 'error', 5500)
        end
    end
end)

RegisterNetEvent('ls-jobmanager:client:hook:car:tow')
AddEventHandler('ls-jobmanager:client:hook:car:tow', function()
    local TowVehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)
    if IsVehicleValid(TowVehicle, 'flatbed') then
        local Vehicle, Distance = LSCore.Functions.GetClosestVehicle()
        if CurrentTowVehicle == nil then
            if Distance <= 4.0 then
                if Vehicle ~= TowVehicle then
                    LSCore.Functions.Progressbar("towing-vehicle", "Voertuig erop zetten..", 5000, false, true, {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    }, {
                        animDict = "mini@repair",
                        anim = "fixing_a_ped",
                        flags = 16,
                    }, {}, {}, function() -- Done
                        CurrentTowVehicle = Vehicle
                        TriggerEvent('ls-sound:client:play', 'tow', 0.5)
                        StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_ped", 1.0)
                        AttachEntityToEntity(Vehicle, TowVehicle, GetEntityBoneIndexByName(TowVehicle, 'bodyshell'), 0.0, -1.5 + -0.85, 0.0 + 1.15, 0, 0, 0, 1, 1, 0, 1, 0, 1)
                        Citizen.Wait(150)
                        FreezeEntityPosition(Vehicle, true)
                        if DoingJob then
                            RemoveBlip(JobBlip)
                            LSCore.Functions.Notify("Voertuig succesvol opgetakelt, breng hem nu naar Hayes Depot", "success")
                        end
                    end, function() -- Cancel
                        CurrentTowVehicle = nil
                        StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_ped", 1.0)
                        LSCore.Functions.Notify("Mislukt!", "error")
                    end)
                end
            end
        else
            LSCore.Functions.Progressbar("untowing_vehicle", "Voertuig eraf halen..", 5000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {
                animDict = "mini@repair",
                anim = "fixing_a_ped",
                flags = 16,
            }, {}, {}, function() -- Done
                TriggerEvent('ls-sound:client:play', 'tow', 0.5)
                StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_ped", 1.0)
                FreezeEntityPosition(CurrentTowVehicle, false)
                Citizen.Wait(250)
                AttachEntityToEntity(CurrentTowVehicle, TowVehicle, 20, -0.0, -15.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
                DetachEntity(CurrentTowVehicle, true, true)
                if DoingJob and IsNearDepot() then
                    LSCore.Functions.Notify("Voertuig ingeleverd!", 'success')
                    LSCore.Functions.DeleteVehicle(CurrentTowVehicle)
                    TriggerServerEvent('ls-jobmanager:server:add:payment', math.random(325, 400))
                    ResetTowJob()
                end
                LSCore.Functions.Notify("Voertuig eraf gehaald!")
                CurrentTowVehicle = nil
            end, function() -- Cancel
                StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_ped", 1.0)
                LSCore.Functions.Notify("Mislukt!", "error")
            end)
        end
    else
        LSCore.Functions.Notify("Dit is geen flatbed nerd..", "error")
    end
end)

-- // Functions \\ --

function SpawnJobTowVehicle()
    HasJobVehicle = true
    local Plate = "TOWR"..tostring(math.random(1000, 9999))
    local CoordsTable = {x = Config.JobLocations['FlatBed']['X'], y = Config.JobLocations['FlatBed']['Y'], z = Config.JobLocations['FlatBed']['Z'], a = Config.JobLocations['FlatBed']['H']}
    LSCore.Functions.TriggerCallback('LSCore:server:spawn:vehicle', function(Veh)
        while not NetworkDoesEntityExistWithNetworkId(Veh) do
            Citizen.Wait(1000)
        end
        local Vehicle = NetToVeh(Veh)
        exports['ls-vehiclekeys']:SetVehicleKeys(GetVehicleNumberPlateText(Vehicle), true, false)
        exports['ls-fuel']:SetFuelLevel(Vehicle, GetVehicleNumberPlateText(Vehicle), 100, false)
        Citizen.SetTimeout(1000, function()
            LSCore.Functions.SetVehiclePlate(Vehicle, Plate)
        end)
    end, 'flatbed', CoordsTable, false, Plate)
end

function SpawnTowVehicle(Coords, Model)
    local CoordsTable = {x = Coords['X'], y = Coords['Y'], z = Coords['Z'], a = Coords['H']}
    LSCore.Functions.TriggerCallback('LSCore:server:spawn:vehicle', function(Veh)
        while not NetworkDoesEntityExistWithNetworkId(Veh) do
            Citizen.Wait(1000)
        end
        local Vehicle = NetToVeh(Veh)
        exports['ls-fuel']:SetFuelLevel(Vehicle, GetVehicleNumberPlateText(Vehicle), 0.0, false)
        DoCarDamage(Vehicle)
    end, Model, CoordsTable, false, "TOWR"..tostring(math.random(1000, 9999)))
end

function CreateTowBlip()
    TowBlip = AddBlipForCoord(Config.TowLocations[CurrentTow]['Coords']['X'], Config.TowLocations[CurrentTow]['Coords']['Y'], Config.TowLocations[CurrentTow]['Coords']['Z'])
    SetBlipSprite(TowBlip, 595)
    SetBlipDisplay(TowBlip, 4)
    SetBlipScale(TowBlip, 0.48)
    SetBlipAsShortRange(TowBlip, true)
    SetBlipColour(TowBlip, 1)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName('Takel Werk')
    EndTextCommandSetBlipName(TowBlip)
    TowBlips = TowBlip
end

function ResetTowJob()
    RemoveBlip(TowBlips)
    DoingJob = false
    TowBlips = nil
    CurrentTow = nil
    HasVehicleSpawned = false
    CurrentTowVehicle = nil
end

function IsNearDepot()
    local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
    local DepotCoords = vector3(-209.65, -1169.32, 23.04)
    if #(PlayerCoords - DepotCoords) < 10.0 then
        return true
    else
        return false
    end
end

function DoCarDamage(Vehicle)
	local SmashWindows, DamageOutside, DamageOutside2 = false, false, false
	local Engine = 199.0
	local Body = 149.0
	if Engine < 200.0 then
		Engine = 200.0
	end
	if Body < 150.0 then
		Body = 150.0
	end
	if Body < 950.0 then
		SmashWindows = true
	end
	if Body < 920.0 then
		DamageOutside = true
	end
	if Body < 920.0 then
		DamageOutside2 = true
	end
	Citizen.Wait(100)
	SetVehicleEngineHealth(Vehicle, Engine)
    SetVehicleBodyHealth(Vehicle, Body)
	if SmashWindows then
		SmashVehicleWindow(Vehicle, 0)
		SmashVehicleWindow(Vehicle, 1)
		SmashVehicleWindow(Vehicle, 2)
		SmashVehicleWindow(Vehicle, 3)
		SmashVehicleWindow(Vehicle, 4)
	end
	if DamageOutside then
		SetVehicleDoorBroken(Vehicle, 1, true)
		SetVehicleDoorBroken(Vehicle, 6, true)
		SetVehicleDoorBroken(Vehicle, 4, true)
	end
	if DamageOutside2 then
		SetVehicleTyreBurst(Vehicle, 1, false, 990.0)
		SetVehicleTyreBurst(Vehicle, 2, false, 990.0)
		SetVehicleTyreBurst(Vehicle, 3, false, 990.0)
		SetVehicleTyreBurst(Vehicle, 4, false, 990.0)
    end
end