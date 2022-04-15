local CurrentTaxiVehicle, MeterOpen, MeterActive, DistanceCoords, SpawnedNpc, GettingIn, GettingOut = nil, false, false, nil, false, false, false
local MeterData = {['Distance'] = 0, ['FareAmount'] = 3, ['CurrentFare'] = 10.0}
local NpcData = {['Model'] = nil, ['CurrentNpc'] = nil, ['DoingNpc'] = false, ['Payment'] = 1, ['StartCoords'] = vector3(1, 1, 1), ['EndCoords'] = vector3(1, 1, 1), ['IsSpecial'] = false}

-- Code

-- // Loops \\ --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            if MeterOpen and MeterActive then
                local PlayerCoords = GetEntityCoords(PlayerPedId())
                local Distance = CalculateTravelDistanceBetweenPoints(DistanceCoords.x, DistanceCoords.y, DistanceCoords.z, PlayerCoords.x, PlayerCoords.y, PlayerCoords.z)
                MeterData['Distance'] = MeterData['Distance'] + Distance
                MeterData['CurrentFare'] = MeterData['CurrentFare'] + math.ceil((Distance / 400.00) * MeterData['FareAmount'])
                SendNUIMessage({
                    action = "UpdateMeter",
                    meterdata = MeterData
                })
                DistanceCoords = GetEntityCoords(PlayerPedId())
                Citizen.Wait(1500)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            if NpcData['DoingNpc'] then
                local PlayerCoords = GetEntityCoords(PlayerPedId())
                if not MeterActive then
                    local Distance = #(PlayerCoords - vector3(NpcData['StartCoords'].x, NpcData['StartCoords'].y, NpcData['StartCoords'].z))
                    if Distance < 100.0 then
                        if not SpawnedNpc then
                            SpawnedNpc = true
                            CreateTaxiNpc(NpcData['Model'], NpcData['StartCoords'])
                        end
                        if Distance < 5.0 and IsPedInAnyTaxi(PlayerPedId()) and GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId())) < 5.0 and not GettingIn then
                            local Vehicle = GetVehiclePedIsIn(PlayerPedId())
                            GettingIn = true
                            TaskEnterVehicle(NpcData['CurrentNpc'], Vehicle, 10000, GetFreeVehicleSeat(Vehicle), 1.0, false, false)
                            SetNewWaypoint(NpcData['EndCoords'].x, NpcData['EndCoords'].y)
                            DistanceCoords = GetEntityCoords(PlayerPedId())
                            TriggerEvent('framework-jobmanager:client:add:temp:blip', NpcData['EndCoords'], 'Taxi Bestemming')
                        end
                    end
                else
                    local Distance = #(PlayerCoords - vector3(NpcData['EndCoords'].x, NpcData['EndCoords'].y, NpcData['EndCoords'].z))
                    if Distance < 20.0 and IsPedInAnyTaxi(PlayerPedId()) and GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId())) < 5.0 and not GettingOut then
                        GettingOut = true
                        TaskLeaveAnyVehicle(NpcData['CurrentNpc'])
                        TriggerServerEvent('framework-jobmanager:server:add:payment', math.random(350, 450)) 
                        SendNUIMessage({action = "ToggleMeterActive", toggle = false})
                        Citizen.SetTimeout(500, function()
                            TaskWanderStandard(NpcData['CurrentNpc'])
                            ResetNpcData()
                        end)
                    end
                end
            else
                Citizen.Wait(400)
            end
        else
            Citizen.Wait(400)
        end
    end
end)

-- // Events \\ --

RegisterNetEvent('framework-taxi:client:openMenu')
AddEventHandler('framework-taxi:client:openMenu', function()
        local MenuItems = {
            [1] = {['Title'] = 'Mercedes', ['Desc'] = 'Premium Drivers', ['Data'] = { ['Event'] = 'framework-jobmanager:client:request:vehicle:taxi', ['Type'] = 'Client', ['args'] = 'qtax'} }
        }

        local Data = {['Title'] = 'Dienstvoertuigen', ['Desc'] = '', ['MainMenuItems'] = MenuItems}
        LSCore.Functions.OpenMenu(Data)
end)

RegisterNetEvent('framework-jobmanager:client:request:vehicle:taxi')
AddEventHandler('framework-jobmanager:client:request:vehicle:taxi', function(data)
    if not HasJobVehicle then
        LSCore.Functions.TriggerCallback("framework-jobmanager:server:do:bail", function(DidBail)
            if DidBail then
                SpawnJobTaxiVehicle(data['args'])
                LSCore.Functions.Notify('Je voertuig staat klaar in de garage', 'success', 5500)
                TriggerServerEvent('framework-jobmanager:server:set:duty', true)
                TriggerServerEvent('framework-jobmanager:server:add:payment', 350)  
            else
              LSCore.Functions.Notify('Je hebt niet genoeg contant geld', 'error', 5500)
            end
        end, 350)
    else
        LSCore.Functions.Notify('Je hebt al een werk voertuig', 'error', 5500)
    end
end)

RegisterNetEvent('framework-jobmanager:client:reset:taxi:meter')
AddEventHandler('framework-jobmanager:client:reset:taxi:meter', function()
    local Vehicle = GetVehiclePedIsIn(PlayerPedId())
    if IsVehicleValid(Vehicle, 'qtax') then
        if MeterOpen then
            MeterActive, MeterData = false, {['Distance'] = 0, ['FareAmount'] = 3, ['CurrentFare'] = 10.0}
            PlaySoundFrontend(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET", 1)
            SendNUIMessage({action = "ResetMeter"})
        else
            LSCore.Functions.Notify('Je meter staat nog uit', 'error', 5500)
        end
    else
        LSCore.Functions.Notify('Dit is geen taxi voertuig', 'error', 5500)
    end
end)

RegisterNetEvent('framework-jobmanager:client:toggle:taxi:meter')
AddEventHandler('framework-jobmanager:client:toggle:taxi:meter', function()
    local Vehicle = GetVehiclePedIsIn(PlayerPedId())
    if IsVehicleValid(Vehicle, 'qtax') then
        if not MeterActive then
            if MeterOpen then
                MeterOpen = false
            else
                MeterOpen = true
            end
            PlaySoundFrontend(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET", 1)
            SendNUIMessage({action = "ToggleMeter", toggle = MeterOpen})
        else
            LSCore.Functions.Notify('Je meter is nog aan', 'error', 5500)
        end
    else
        LSCore.Functions.Notify('Dit is geen taxi voertuig', 'error', 5500)
    end
end)

RegisterNetEvent('framework-jobmanager:client:start:taxi:meter')
AddEventHandler('framework-jobmanager:client:start:taxi:meter', function()
    local Vehicle = GetVehiclePedIsIn(PlayerPedId())
    if IsVehicleValid(Vehicle, 'qtax') then
        if MeterOpen then
            if MeterActive then
                MeterActive = false
            else
                MeterActive = true
                DistanceCoords = GetEntityCoords(PlayerPedId())
            end
            PlaySoundFrontend(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET", 1)
            SendNUIMessage({action = "ToggleMeterActive", toggle = MeterActive})
        else
            LSCore.Functions.Notify('Je meter staat nog uit', 'error', 5500)
        end
    else
        LSCore.Functions.Notify('Dit is geen taxi voertuig', 'error', 5500)
    end
end)

RegisterNetEvent('framework-jobmanager:client:taxi:npc')
AddEventHandler('framework-jobmanager:client:taxi:npc', function()
    local Vehicle = GetVehiclePedIsIn(PlayerPedId())
    if not NpcData['DoingNpc'] then
        if HasJobVehicle and IsVehicleValid(Vehicle, 'qtax') then
            NpcData['DoingNpc'] = true
            LSCore.Functions.Notify('Wachten op een klant', 'success', 5500)
            Citizen.SetTimeout(math.random(10000, 20000), function()
                local RandomJob = GetRandomNpcLocation()
                if math.random(1, 100) < RandomJob['SpecialChance'] then
                    NpcData['IsSpecial'] = true
                    -- Sound Special
                else
                    NpcData['IsSpecial'] = false
                    -- Sound not special
                end
                NpcData['Model'] = Config.RandomNpcModel[math.random(1, #Config.RandomNpcModel)]
                NpcData['StartCoords'] = RandomJob['PickupCoords']
                NpcData['EndCoords'] = Config.TaxiEndCoords[math.random(1, #Config.TaxiEndCoords)]
                SetNewWaypoint(RandomJob['PickupCoords'].x, RandomJob['PickupCoords'].y)
                ShowTempBlip(RandomJob['PickupCoords'], 'Taxi Klant')
            end)
        else
            LSCore.Functions.Notify('Dit is geen taxi voertuig', 'error', 5500)
        end
    end
end)

-- // Functions \\ --

function SpawnJobTaxiVehicle(voertuig)
    HasJobVehicle, DoingJob = true, true
    local Plate = "TAXI"..tostring(math.random(1000, 9999))
    local CoordsTable = {x = Config.JobLocations['TaxiVeh']['X'], y = Config.JobLocations['TaxiVeh']['Y'], z = Config.JobLocations['TaxiVeh']['Z'], a = Config.JobLocations['TaxiVeh']['H']}
    LSCore.Functions.TriggerCallback('LSCore:server:spawn:vehicle', function(Veh)
        while not NetworkDoesEntityExistWithNetworkId(Veh) do
            Citizen.Wait(1000)
        end
        local Vehicle = NetToVeh(Veh)
        exports['fw-vehicles']:SetVehicleKeys(GetVehicleNumberPlateText(Vehicle), true, false)
        exports['fw-vehicles']:SetFuel(Vehicle, 100)
        Citizen.SetTimeout(1000, function()
            LSCore.Functions.SetVehiclePlate(Vehicle, Plate)
        end)
    end, voertuig, CoordsTable, false, Plate)
end

function ResetNpcData()
    NpcData = {
        ['DoingNpc'] = true, 
        ['CurrentNpc'] = 1, 
        ['Payment'] = 1, 
        ['StartCoords'] = vector3(1, 1, 1), 
        ['EndCoords'] = vector3(1, 1, 1), 
        ['IsSpecial'] = false
    }
    GettingOut, GettingIn = false, false
    Citizen.SetTimeout(60000, function()
        NpcData['DoingNpc'] = false
    end)
end

function GetRandomNpcLocation()
    local RandomNPC = Config.TaxiLocations[math.random(1, #Config.TaxiLocations)]
    return RandomNPC
end

function CreateTaxiNpc(Model, Coords)
    exports['fw-assets']:RequestModelHash(Model)
    local NpcPed = CreatePed(4, Model, Coords.x, Coords.y, Coords.z, Coords.w, false, false)
    SetEntityInvincible(NpcPed, true)
    SetBlockingOfNonTemporaryEvents(NpcPed, true)
    NpcData['CurrentNpc'] = NpcPed
    print(NpcPed, Model, Coords)
end

function GetFreeVehicleSeat(Vehicle)
    for i = GetVehicleMaxNumberOfPassengers(Vehicle), -1, -1 do
        if IsVehicleSeatFree(Vehicle, i) then
            return i
        end
    end 
end
