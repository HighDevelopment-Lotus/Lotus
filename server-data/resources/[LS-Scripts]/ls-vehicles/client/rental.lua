
-- // Events \\ --

RegisterNetEvent('ls-vehicles:client:open:rental')
AddEventHandler('ls-vehicles:client:open:rental', function()
    local MenuItems = {}
    for k, v in pairs(Config.RentalVehicles) do
        local TempData = {}
        TempData['Title'] = v['Label']..' (€'..v['Price']..')'
        TempData['Image'] = LSCore.Shared.Vehicles[v['Vehicle']]['Image']
        TempData['Desc'] = 'Klik om voertuig huren'
        TempData['Data'] = {['Event'] = 'ls-vehicles:client:try:rental', ['Type'] = 'Client'}
        TempData['SecondMenu'] = {[1] = {['Title'] = 'Bevestigen', ['GoBack'] = false, ['CloseMenu'] = true, ['DoCloseEvent'] = false, ['Event'] = {['Event'] = 'ls-vehicles:client:try:rental', ['Type'] = 'Client', ['Price'] = v['Price'], ['Vehicle'] = v['Vehicle']}}}
        table.insert(MenuItems, TempData)
    end
    if (#MenuItems > 0) then
        local Data = {['Title'] = 'Voertuig Huren', ['MainMenuItems'] = MenuItems}
        
        LSCore.Functions.OpenMenu(Data)
    end
end)

RegisterNetEvent('ls-vehicles:client:try:rental')
AddEventHandler('ls-vehicles:client:try:rental', function(data)
    local RandomSpawn = GetParkingSlot()
    if RandomSpawn ~= false then
        LSCore.Functions.TriggerCallback('LSCore:RemoveCash', function(HasPaid) 
            if HasPaid then
                local Plate = 'RE'..math.random(1111,9999)..'NT'
                local CoordsTable = {x = RandomSpawn['Coords'].x, y = RandomSpawn['Coords'].y, z = RandomSpawn['Coords'].z, a = RandomSpawn['Coords'].w}
                LSCore.Functions.TriggerCallback('LSCore:server:spawn:vehicle', function(Veh)
                    while not NetworkDoesEntityExistWithNetworkId(Veh) do
                        Citizen.Wait(1000)
                    end
                    local Vehicle = NetToVeh(Veh)
                    exports['ls-vehiclekeys']:SetVehicleKeys(Plate, true, false)
                    exports['ls-fuel']:SetFuelLevel(Vehicle, Plate, 100, false)
                    LSCore.Functions.SetVehiclePlate(Vehicle, Plate)
                    TriggerServerEvent('ls-vehicles:server:recieve:papers', Plate)
                end, data['Vehicle'], CoordsTable, false, Plate)
            else
                LSCore.Functions.Notify("Je hebt niet genoeg cash..", "error")
            end
        end, data['Price'])
    else
        LSCore.Functions.Notify("Er is geen lege parkeer plek..", "error")
    end
end)

RegisterNetEvent('ls-vehicles:client:recieve:extra:keys')
AddEventHandler('ls-vehicles:client:recieve:extra:keys', function(Plate)
    exports['ls-vehiclekeys']:SetVehicleKeys(Plate, true, false)
    LSCore.Functions.Notify("Je ontving een extra set met sleutels!", "success")
end)

-- // Functions \\ --

function GetParkingSlot()
    local Found, Count = false, 0
    while not Found do
        Citizen.Wait(1)
        local RandomSpawn = Config.RentalSpawns[math.random(1, #Config.RentalSpawns)]
        local CanSpawn = LSCore.Functions.IsSpawnPointClear(RandomSpawn['Coords'], 2.0)
        Count = Count + 1
        if CanSpawn then
            Found = true
            return RandomSpawn
        else
            if Count == #Config.RentalSpawns then
                Found = true
                return false
            end
        end
    end
end