local LSCore, LoggedIn, PlayerJob = exports['ls-core']:GetCoreObject(), false, {}
local ShowingInteraction = false

RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1250, function()
        Citizen.Wait(2000)
        PlayerJob = LSCore.Functions.GetPlayerData().job
        LoggedIn = true
    end)
end)

RegisterNetEvent('LSCore:Client:OnPlayerUnload')
AddEventHandler('LSCore:Client:OnPlayerUnload', function()
    LoggedIn = false
end)

RegisterNetEvent('LSCore:Client:OnJobUpdate')
AddEventHandler('LSCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

-- Code

-- // Loops \\ --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn and PlayerJob.name == 'flightschool' then
            local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
            local Distance = #(PlayerCoords - Config.Storage)
            if Distance < 2.0 then
                if not ShowingInteraction then
                    ShowingInteraction = true
                    exports['ls-ui']:ShowInteraction('[E] Opslag', 'primary')
                end
                if IsControlJustReleased(0, 38) then
                    if exports['ls-inventory-new']:CanOpenInventory() then
                        TriggerServerEvent('ls-inventory-new:server:open:inventory:other', "flightschool", 'Stash', 20, 10000000)
                    end
                end
            else
                if ShowingInteraction then
                    ShowingInteraction = false
                    exports['ls-ui']:HideInteraction()
                end
                Citizen.Wait(400)
            end
        else
            Citizen.Wait(450)
        end
    end
end)

-- // Events \\ --

RegisterNetEvent('ls-flightschool:client:open:brevet')
AddEventHandler('ls-flightschool:client:open:brevet', function()
    local Data = {['Title'] = 'Paypal Nummer?', ['Type'] = 'number', ['Logo'] = '<i class="fab fa-paypal"></i>'}
    LSCore.Functions.OpenInput(Data, function(ReturnData)
        if ReturnData ~= false then
            local PlayerId = tonumber(ReturnData)
            TriggerServerEvent('ls-flightschool:server:add:brevet', PlayerId)
        end
    end)
end)

RegisterNetEvent('ls-flightschool:client:open:rental')
AddEventHandler('ls-flightschool:client:open:rental', function()
    local MenuItems = {}
    for k, v in pairs(Config.RentalVehicles) do
        local TempData = {}
        TempData['Title'] = v['Label']..' (€'..v['Price']..')'
        TempData['Image'] = v['Image']
        TempData['Desc'] = 'Klik om voertuig huren'
        TempData['Data'] = {['Event'] = 'ls-flightschool:client:spawn', ['Type'] = 'Client', ['Price'] = v['Price'], ['Vehicle'] = v['Vehicle'], ['VType'] = 'Rental'}
        table.insert(MenuItems, TempData)
    end
    if (#MenuItems > 0) then
        local Data = {['Title'] = 'Voertuig Huren', ['MainMenuItems'] = MenuItems}
        LSCore.Functions.OpenMenu(Data)
    end
end)

RegisterNetEvent('ls-flightschool:client:open:learn')
AddEventHandler('ls-flightschool:client:open:learn', function()
    local MenuItems = {}
    for k, v in pairs(Config.SchoolVehicles) do
        local TempData = {}
        TempData['Title'] = v['Label']
        TempData['Image'] = v['Image']
        TempData['Desc'] = 'Klik om voertuig te gebruiken'
        TempData['Data'] = {['Event'] = 'ls-flightschool:client:spawn', ['Type'] = 'Client', ['Vehicle'] = v['Vehicle'], ['VType'] = 'Learn'}
        table.insert(MenuItems, TempData)
    end
    if (#MenuItems > 0) then
        local Data = {['Title'] = 'Oefen Voertuigen', ['MainMenuItems'] = MenuItems}
        LSCore.Functions.OpenMenu(Data)
    end
end)

RegisterNetEvent('ls-flightschool:client:spawn')
AddEventHandler('ls-flightschool:client:spawn', function(data)
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
                        exports['ls-vehiclekeys']:SetVehicleKeys(GetVehicleNumberPlateText(Vehicle), true, false)
                        exports['ls-fuel']:SetFuelLevel(Vehicle, GetVehicleNumberPlateText(Vehicle), 100, false)
                        LSCore.Functions.SetVehiclePlate(Vehicle, Plate)
                        TriggerServerEvent('ls-vehicles:server:recieve:papers', GetVehicleNumberPlateText(Vehicle))
                        TriggerServerEvent('ls-banking:server:set:business:accounts', 'Add', (data['Price'] / 100) * 20, 'VLIEGSCHOOL', 'Voertuig gehuurd.')
                    end, data['Vehicle'], CoordsTable, false, Plate)
                else
                    LSCore.Functions.Notify("Je hebt niet genoeg cash..", "error")
                end
            end, data['Price'])
        else
            local CoordsTable = {x = RandomSpawn['Coords'].x, y = RandomSpawn['Coords'].y, z = RandomSpawn['Coords'].z, a = RandomSpawn['Coords'].w}
            LSCore.Functions.TriggerCallback('LSCore:server:spawn:vehicle', function(Veh)
                while not NetworkDoesEntityExistWithNetworkId(Veh) do
                    Citizen.Wait(1000)
                end
                local Vehicle = NetToVeh(Veh)
                exports['ls-vehiclekeys']:SetVehicleKeys(GetVehicleNumberPlateText(Vehicle), true, false)
                exports['ls-fuel']:SetFuelLevel(Vehicle, GetVehicleNumberPlateText(Vehicle), 100, false)
            end, data['Vehicle'], CoordsTable, false, false)
        end
    else
        LSCore.Functions.Notify("Er is geen lege parkeer plek..", "error")
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