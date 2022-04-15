local ShowingInteraction = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn and PlayerJob.name == 'flightschool' then
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            local Distance = #(PlayerCoords - Config.Storage)
            if Distance < 2.0 then
                if not ShowingInteraction then
                    ShowingInteraction = true
                    exports['fw-ui']:ShowInteraction('[E] Opslag', 'primary')
                end
                if IsControlJustReleased(0, 38) then
                    if exports['fw-inventory']:CanOpenInventory() then
                        TriggerServerEvent('framework-inv:server:open:inventory:other', "flightschool", 'Stash', 20, 10000000)
                    end
                end
            else
                if ShowingInteraction then
                    ShowingInteraction = false
                    exports['fw-ui']:HideInteraction()
                end
                Citizen.Wait(400)
            end
        else
            Citizen.Wait(450)
        end
    end
end)

-- // Events \\ --

RegisterNetEvent('framework-flightschool:client:open:license')
AddEventHandler('framework-flightschool:client:open:license', function()
    local Data = {['Title'] = 'Paypal?', ['Type'] = 'number', ['Logo'] = '<i class="fab fa-paypal"></i>'}
    LSCore.Functions.OpenInput(Data, function(ReturnData)
        if ReturnData ~= false then
            local PlayerId = tonumber(ReturnData)
            TriggerServerEvent('framework-flightschool:server:add:license', PlayerId)
        end
    end)
end)

RegisterNetEvent('framework-flightschool:client:open:rental')
AddEventHandler('framework-flightschool:client:open:rental', function()
    local MenuItems = {}
    for k, v in pairs(Config.RentalVehicles) do
        local TempData = {}
        TempData['Title'] = v['Label']..' (€'..v['Price']..')'
        TempData['Image'] = v['Image']
        TempData['Desc'] = 'Klik om te huren'
        TempData['Data'] = {['Event'] = 'framework-flightschool:client:spawn', ['Type'] = 'Client', ['Price'] = v['Price'], ['Vehicle'] = v['Vehicle'], ['VType'] = 'Rental'}
        table.insert(MenuItems, TempData)
    end
    if (#MenuItems > 0) then
        local Data = {['Title'] = 'Rent Vehicle', ['MainMenuItems'] = MenuItems}
        LSCore.Functions.OpenMenu(Data)
    end
end)

RegisterNetEvent('framework-flightschool:client:open:learn')
AddEventHandler('framework-flightschool:client:open:learn', function()
    local MenuItems = {}
    for k, v in pairs(Config.SchoolVehicles) do
        local TempData = {}
        TempData['Title'] = v['Label']
        TempData['Image'] = v['Image']
        TempData['Desc'] = 'Klik om te gebruiken'
        TempData['Data'] = {['Event'] = 'framework-flightschool:client:spawn', ['Type'] = 'Client', ['Vehicle'] = v['Vehicle'], ['VType'] = 'Learn'}
        table.insert(MenuItems, TempData)
    end
    if (#MenuItems > 0) then
        local Data = {['Title'] = 'Practicing Vehicles', ['MainMenuItems'] = MenuItems}
        LSCore.Functions.OpenMenu(Data)
    end
end)

RegisterNetEvent('framework-flightschool:client:spawn')
AddEventHandler('framework-flightschool:client:spawn', function(data)
    local RandomSpawn = GetParkingSlot()
    if RandomSpawn ~= false then
        if data['VType'] == 'Rental' then
            LSCore.Functions.TriggerCallback('LSCore:RemoveCash', function(HasPaid) 
                if HasPaid then
                    local Plate = 'RE'..math.random(1111,9999)..'NT'
                    local CoordsTable = {x = RandomSpawn['Coords'].x, y = RandomSpawn['Coords'].y, z = RandomSpawn['Coords'].z, a = RandomSpawn['Coords'].w}
                    LSCore.Functions.TriggerCallback('LSCore:server:spawn:vehicle', function(Veh)
                        while not NetworkDoesEntityExistWithNetworkId(Veh) do
                            Citizen.Wait(1000)
                        end
                        local Vehicle = NetToVeh(Veh)
                        
                        exports['fw-vehicles']:SetVehicleKeys(GetVehicleNumberPlateText(Vehicle), true, false)
                        exports['fw-vehicles']:SetFuel(Vehicle, 100)
                        LSCore.Functions.SetVehiclePlate(Vehicle, Plate)
                        TriggerServerEvent('framework-vehicles:server:recieve:papers', GetVehicleNumberPlateText(Vehicle))
                        TriggerServerEvent('framework-banking:server:set:business:accounts', 'Add', (data['Price'] / 100) * 20, 'FLIGHTSCHOOL', 'Vehicle rented.')
                    end, data['Vehicle'], CoordsTable, false, Plate)
                else
                    LSCore.Functions.Notify("Je hebt niet genoeg contant", "error")
                end
            end, data['Price'])
        else
            local CoordsTable = {x = RandomSpawn['Coords'].x, y = RandomSpawn['Coords'].y, z = RandomSpawn['Coords'].z, a = RandomSpawn['Coords'].w}
            LSCore.Functions.TriggerCallback('LSCore:server:spawn:vehicle', function(Veh)
                while not NetworkDoesEntityExistWithNetworkId(Veh) do
                    Citizen.Wait(1000)
                end
                local Vehicle = NetToVeh(Veh)
                exports['fw-vehicles']:SetVehicleKeys(GetVehicleNumberPlateText(Vehicle), true, false)
                exports['fw-vehicles']:SetFuel(Vehicle, 100)
            end, data['Vehicle'], CoordsTable, false, false)
        end
    else
        LSCore.Functions.Notify("Er is geen plaats", "error")
    end
end)

-- // Functions \\ --

function GetParkingSlot()
    local RandomParking = {}
    for i = 1, #Config.VehicleSpawns do
        local RandomSpawn = Config.VehicleSpawns[i]
        local CanSpawn = LSCore.Functions.IsSpawnPointClear(RandomSpawn['Coords'], 2.0)
        if CanSpawn ~= nil and CanSpawn then
            table.insert(RandomParking, i)
        end
    end
    return Config.VehicleSpawns[RandomParking[math.random(1, #RandomParking)]]
end

function HasBrevet()
    local PlayerData = LSCore.Functions.GetPlayerData()
    return PlayerData.metadata['licences']['flying']
end