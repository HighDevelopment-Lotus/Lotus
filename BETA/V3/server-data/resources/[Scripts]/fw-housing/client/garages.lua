local LSCore, LoggedIn, CurrentParkingSlot, CurrentParking, TempVehicles = exports['fw-base']:GetCoreObject(), false, nil, nil, {}

RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(950, function()
        LSCore.Functions.TriggerCallback('framework-garages:server:get:config', function(ConfigData)
            Config = ConfigData
        end)    
       	LoggedIn = true 
    end)
end)    

RegisterNetEvent('LSCore:Client:OnPlayerUnload')
AddEventHandler('LSCore:Client:OnPlayerUnload', function()
    if TempVehicle ~= nil then
        for k, v in pairs(TempVehicles) do
            LSCore.Functions.DeleteVehicle(v)
        end
        TempVehicles = {}
    end
    CurrentParking, CurrentParkingSlot = nil, nil
    LoggedIn = false
end)

-- Code

-- // Loops \\ --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            local NearGarage = false
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            for k, v in pairs(Config.GarageSpots) do
                local Distance = #(PlayerCoords - v['Coords'])
                if Distance < 30.0 then
                    NearGarage = true
                    CurrentParking = k
                    SetClosestParkSlot()
                end
            end
            if not NearGarage then
                CurrentParking, CurrentParkingSlot = nil, nil
            end
            Citizen.Wait(450)
        else
            Citizen.Wait(450)
        end
    end
end)

-- // Events \\ --

RegisterNetEvent('framework-garages:client:try:park:vehicle')
AddEventHandler('framework-garages:client:try:park:vehicle', function(Nothing, Entity)
    -- local Vehicle = Entity['Entity']
    local Vehicle = LSCore.Functions.GetClosestVehicle()
    local Plate = GetVehicleNumberPlateText(Vehicle)
    LSCore.Functions.TriggerCallback("framework-garage:server:is:vehicle:owner", function(IsVehicleOwner)
        if IsVehicleOwner then
            local GarageData = {['Garage'] = Config.GarageSpots[CurrentParking]['Garage'], ['MetaData'] = {Fuel = exports['fw-vehicles']:GetFuelLevel(Plate), Body = GetVehicleBodyHealth(Vehicle), Engine = GetVehicleEngineHealth(Vehicle)}}
            NetworkRequestControlOfEntity(Vehicle)
            exports['fw-autocare']:RemoveVehicleData(Plate)
            --TriggerServerEvent("framework-garage:server:save:vehicle:mods", Plate, LSCore.Functions.GetVehicleProperties(Vehicle))
            TriggerServerEvent('framework-garages:server:set:vehicle:state', Plate, 'in', GarageData)
            LSCore.Functions.DeleteVehicle(Vehicle)
        end
    end, Plate)
end)

RegisterNetEvent('framework-garages:client:try:park:house:vehicle')
AddEventHandler('framework-garages:client:try:park:house:vehicle', function(HouseName)
    local Vehicle = GetVehiclePedIsIn(PlayerPedId())
    local Plate = GetVehicleNumberPlateText(Vehicle)
    LSCore.Functions.TriggerCallback("framework-garage:server:is:vehicle:owner", function(IsVehicleOwner)
        if IsVehicleOwner then
            local GarageData = {['Garage'] = HouseName, ['MetaData'] = {Fuel = exports['fw-vehicles']:GetFuelLevel(Plate), Body = GetVehicleBodyHealth(Vehicle), Engine = GetVehicleEngineHealth(Vehicle)}}
            NetworkRequestControlOfEntity(Vehicle)
            TaskLeaveAnyVehicle(PlayerPedId())
            Citizen.SetTimeout(650, function()
                exports['fw-autocare']:RemoveVehicleData(Plate)
                --TriggerServerEvent("framework-garage:server:save:vehicle:mods", Plate, LSCore.Functions.GetVehicleProperties(Vehicle))
                TriggerServerEvent('framework-garages:server:set:vehicle:state', Plate, 'in', GarageData)
                LSCore.Functions.DeleteVehicle(Vehicle)
            end)
        end
    end, Plate)
end)

RegisterNetEvent('framework-garage:client:open:garage:menu')
AddEventHandler('framework-garage:client:open:garage:menu', function()
    LSCore.Functions.TriggerCallback("framework-garage:server:get:my:vehicles", function(MyVehicles)
        if #MyVehicles > 0 then
            local MenuItems = {}
            for k, v in pairs(MyVehicles) do
                if Config.GarageSpots[CurrentParking] ~= nil and Config.GarageSpots[CurrentParking]['Garage'] == v['VehicleGarage'] and v['VehicleGarageState'] == 'in' then
                    local MenuData = {}
                    MenuData['Title'] = v['VehicleLabel']..' ['..v['VehiclePlate']..']'
                    MenuData['Image'] = v['VehicleImage']
                    MenuData['Desc'] = 'Motor: '..math.ceil(v['VehicleStatus'].Engine / 1000 * 100)..'% Body: '..math.ceil(v['VehicleStatus'].Body / 1000 * 100)..'% Fuel: '..math.ceil(v['VehicleStatus'].Fuel)..'%'
                    MenuData['Data'] = {['Event'] = 'framework-garages:client:take:out', ['Type'] = 'Client', ['GType'] = 'Garage', ['Plate'] = v['VehiclePlate'], ['Model'] = v['VehicleName'], ['Motor'] = v['VehicleStatus'].Engine, ['Body'] = v['VehicleStatus'].Body, ['Fuel'] = v['VehicleStatus'].Fuel}
                    table.insert(MenuItems, MenuData)
                end
            end
            if #MenuItems > 0 then
                local Data = {['Title'] = Config.GarageSpots[CurrentParking]['Garage'], ['MainMenuItems'] = MenuItems, ['ReturnEvent'] = {['Event'] = 'framework-garages:client:remove:temp', ['Type'] = 'Client'}, ['CloseEvent'] = {['Event'] = 'framework-garages:client:remove:temp', ['Type'] = 'Client'}}
                LSCore.Functions.OpenMenu(Data)
            else
                LSCore.Functions.Notify("Er zijn geen voertuigen in deze garage..", "error", 5000)
            end
        else
            LSCore.Functions.Notify("Je hebt geen voertuigen..", "error", 5000)
        end
    end)
end)

RegisterNetEvent('framework-garage:client:open:depot:menu')
AddEventHandler('framework-garage:client:open:depot:menu', function()
    LSCore.Functions.TriggerCallback("framework-garage:server:get:my:vehicles", function(MyVehicles)
        if #MyVehicles > 0 then
            local MenuItems = {}
            for k, v in pairs(MyVehicles) do
                if v['VehicleGarageState'] == 'out' then
                    local MenuData = {}
                    MenuData['Title'] = v['VehicleLabel']..' ['..v['VehiclePlate']..']'
                    MenuData['Image'] = v['VehicleImage']
                    MenuData['Desc'] = 'Motor: '..math.ceil(v['VehicleStatus'].Engine / 1000 * 100)..'% Body: '..math.ceil(v['VehicleStatus'].Body / 1000 * 100)..'% Fuel: '..math.ceil(v['VehicleStatus'].Fuel)..'%<br> Kosten: €'.. v['VehiclePrice']
                    MenuData['Data'] = {['Event'] = 'framework-garages:client:take:out', ['Type'] = 'Client', ['GType'] = 'Depot', ['Plate'] = v['VehiclePlate'], ['Model'] = v['VehicleName'], ['Motor'] = v['VehicleStatus'].Engine, ['Body'] = v['VehicleStatus'].Body, ['Fuel'] = v['VehicleStatus'].Fuel, ['DepotPrice'] = v['VehiclePrice']}
                    table.insert(MenuItems, MenuData)
                end
            end
            if #MenuItems > 0 then
                local Data = {['Title'] = 'Depot', ['MainMenuItems'] = MenuItems}
                LSCore.Functions.OpenMenu(Data)
            else
                LSCore.Functions.Notify("Er zijn geen voertuigen in deze garage..", "error", 5000)
            end
        else
            LSCore.Functions.Notify("Je hebt geen voertuigen..", "error", 5000)
        end
    end)
end)

RegisterNetEvent('framework-garages:client:open:house:menu')
AddEventHandler('framework-garages:client:open:house:menu', function(HouseName)
    LSCore.Functions.TriggerCallback("framework-garage:server:get:house:vehicles", function(MyVehicles)
        if #MyVehicles > 0 then
            local MenuItems = {}
            for k, v in pairs(MyVehicles) do
                if v['VehicleGarageState'] == 'in' then
                    local MenuData = {}
                    MenuData['Title'] = v['VehicleLabel']..' ['..v['VehiclePlate']..']'
                    MenuData['Image'] = v['VehicleImage']
                    MenuData['Desc'] = 'Motor: '..math.ceil(v['VehicleStatus'].Engine / 1000 * 100)..'% Body: '..math.ceil(v['VehicleStatus'].Body / 1000 * 100)..'% Fuel: '..math.ceil(v['VehicleStatus'].Fuel)..'%'
                    MenuData['Data'] = {['Event'] = 'framework-garages:client:take:out', ['Type'] = 'Client', ['GType'] = 'HouseGarage', ['Plate'] = v['VehiclePlate'], ['Model'] = v['VehicleName'], ['Motor'] = v['VehicleStatus'].Engine, ['Body'] = v['VehicleStatus'].Body, ['Fuel'] = v['VehicleStatus'].Fuel, ['HouseName'] = HouseName}
                    table.insert(MenuItems, MenuData)
                end
            end
            if #MenuItems > 0 then
                local Data = {['Title'] = '<i class="fas fa-warehouse"></i> '..HouseName, ['MainMenuItems'] = MenuItems, ['ReturnEvent'] = {['Event'] = 'Cancel spawn', ['Type'] = 'Client'}}
                LSCore.Functions.OpenMenu(Data)
            else
                LSCore.Functions.Notify("Er zijn geen voertuigen in deze garage..", "error", 5000)
            end
        else
            LSCore.Functions.Notify("Je hebt geen voertuigen..", "error", 5000)
        end
    end, HouseName)
end)

RegisterNetEvent('framework-garages:client:open:impound:menu')
AddEventHandler('framework-garages:client:open:impound:menu', function()
    LSCore.Functions.TriggerCallback("framework-garage:server:all:vehicles", function(MyVehicles)
        if #MyVehicles > 0 then
            local MenuItems = {}
            for k, v in pairs(MyVehicles) do
                if v['VehicleGarageState'] == 'impounded' then
                    local MenuData = {}
                    MenuData['Title'] = v['VehicleLabel']..' ['..v['VehiclePlate']..']'
                    MenuData['Image'] = v['VehicleImage']
                    MenuData['Desc'] = 'Motor: '..math.ceil(v['VehicleStatus'].Engine / 1000 * 100)..'% Body: '..math.ceil(v['VehicleStatus'].Body / 1000 * 100)..'% Fuel: '..math.ceil(v['VehicleStatus'].Fuel)..'%<br>Reden: '..v['VehicleReason']
                    MenuData['Data'] = {['Event'] = 'framework-garages:client:take:out', ['Type'] = 'Client', ['GType'] = 'Impound', ['Plate'] = v['VehiclePlate'], ['Model'] = v['VehicleName'], ['Motor'] = v['VehicleStatus'].Engine, ['Body'] = v['VehicleStatus'].Body, ['Fuel'] = v['VehicleStatus'].Fuel}
                    table.insert(MenuItems, MenuData)
                end
            end
            if #MenuItems > 0 then
                local Data = {['Title'] = 'Beslag Opslag', ['MainMenuItems'] = MenuItems}
                LSCore.Functions.OpenMenu(Data)
            else
                LSCore.Functions.Notify("Er zijn geen voertuigen in deze garage..", "error", 5000)
            end
        else
            LSCore.Functions.Notify("Je hebt geen voertuigen..", "error", 5000)
        end
    end)
end)

RegisterNetEvent('framework-garages:client:take:out')
AddEventHandler('framework-garages:client:take:out', function(Data)
    if Data['GType'] == 'Impound' then
        local CoordTable = {x = -209.04, y = -1167.77, z = 23.04 - 0.5, a = 182.05}           
        local CanSpawn = LSCore.Functions.IsSpawnPointClear(vector3(CoordTable.x, CoordTable.y, CoordTable.z), 2.0)
        if CanSpawn then
            LSCore.Functions.TriggerCallback('LSCore:server:spawn:vehicle', function(Veh)
                while not NetworkDoesEntityExistWithNetworkId(Veh) do
                    Citizen.Wait(350)
                end
                local Vehicle = NetToVeh(Veh)
                while not DoesEntityExist(Vehicle) do
                    Citizen.Wait(100)
                end
                NetworkFadeInEntity(Vehicle, true)
                NetworkRequestControlOfEntity(Vehicle)
                ClearAreaOfPeds(CoordTable.x, CoordTable.y, CoordTable.z, 3.5)
                exports['fw-autocare']:SetupVehicleData(Data['Plate'])
                exports['fw-vehicles']:SetVehicleKeys(Data['Plate'], true, false)
                exports['fw-vehicles']:SetFuelLevel(Vehicle, Data['Plate'], Data['Fuel'], false)
                Citizen.SetTimeout(1000, function()
                    LSCore.Functions.TriggerCallback('framework-garages:server:get:vehicle:mods', function(Mods)
                        LSCore.Functions.SetVehicleProperties(Vehicle, Mods)
                        DoCarDamage(Vehicle, Data['Motor'], Data['Body'])
                        NetworkFadeInEntity(Vehicle, true)	
                        NetworkRegisterEntityAsNetworked(Vehicle)
                        LSCore.Functions.SetVehiclePlate(Vehicle, Data['Plate'])
                        TriggerServerEvent('framework-garages:server:set:vehicle:state', Data['Plate'], 'out')
                        LSCore.Functions.Notify("Voertuig staat om de hoek!", "success")
                    end, Data['Plate'])
                end)
            end, Data['Model'], CoordTable, false, Data['Plate'])
        else
            LSCore.Functions.Notify("Volgensmij staat hier al een voertuig..", "error", 5000)
        end
    elseif Data['GType'] == 'Depot' then
        if not DoesEntityExist(NetToVeh(Config.OutsideVehicles[Data['Plate']])) then
            LSCore.Functions.TriggerCallback('LSCore:RemoveCash', function(DidPay)
                if DidPay then
                    local RandomCoords = Config.DepotSpots[math.random(1, #Config.DepotSpots)]
                    local CoordTable = {x = RandomCoords.x, y = RandomCoords.y, z = RandomCoords.z - 0.5, a = RandomCoords.w}           
                    local CanSpawn = LSCore.Functions.IsSpawnPointClear(vector3(CoordTable.x, CoordTable.y, CoordTable.z), 2.0)
                    if CanSpawn then
                        LSCore.Functions.TriggerCallback('LSCore:server:spawn:vehicle', function(Veh)
                            while not NetworkDoesEntityExistWithNetworkId(Veh) do
                                Citizen.Wait(350)
                            end
                            local Vehicle = NetToVeh(Veh)
                            while not DoesEntityExist(Vehicle) do
                                Citizen.Wait(100)
                            end
                            NetworkFadeInEntity(Vehicle, true)
                            NetworkRequestControlOfEntity(Vehicle)
                            ClearAreaOfPeds(CoordTable.x, CoordTable.y, CoordTable.z, 3.5)
                            exports['fw-autocare']:SetupVehicleData(Data['Plate'])
                            exports['fw-vehicles']:SetVehicleKeys(Data['Plate'], true, false)
                            exports['fw-vehicles']:SetFuelLevel(Vehicle, Data['Plate'], Data['Fuel'], false)
                            Citizen.SetTimeout(1000, function()
                                LSCore.Functions.TriggerCallback('framework-garages:server:get:vehicle:mods', function(Mods)
                                    LSCore.Functions.SetVehicleProperties(Vehicle, Mods)
                                    DoCarDamage(Vehicle, Data['Motor'], Data['Body'])
                                    NetworkFadeInEntity(Vehicle, true)	
                                    NetworkRegisterEntityAsNetworked(Vehicle)
                                    LSCore.Functions.SetVehiclePlate(Vehicle, Data['Plate'])
                                    TriggerServerEvent('framework-garages:server:set:vehicle:state', Data['Plate'], 'out', nil, VehToNet(Vehicle))
                                    LSCore.Functions.Notify("Voertuig staat op een parkeervak!", "success")
                                end, Data['Plate'])
                            end)
                        end, Data['Model'], CoordTable, false, Data['Plate'])
                    else
                        LSCore.Functions.Notify("Volgensmij staat hier al een voertuig..", "error", 5000)
                    end
                else
                    LSCore.Functions.Notify("Je hebt niet genoeg contant..", "error", 5000)
                end
            end, Data['DepotPrice'])
        else
            LSCore.Functions.Notify('Dit voertuig staat al ergens in de wereld..', 'error')
        end
    elseif Data['GType'] == 'HouseGarage' then
            local VehicleSpawn = exports['fw-radio']:GetGarageCoords()
            local CoordTable = {x = VehicleSpawn['X'], y = VehicleSpawn['Y'], z = VehicleSpawn['Z'], a = VehicleSpawn['H']}
            local CanSpawn = LSCore.Functions.IsSpawnPointClear(vector3(CoordTable.x, CoordTable.y, CoordTable.z), 2.5)
            if CanSpawn then
                LSCore.Functions.TriggerCallback('LSCore:server:spawn:vehicle', function(Veh)
                    while not NetworkDoesEntityExistWithNetworkId(Veh) do
                        Citizen.Wait(350)
                    end
                    local Vehicle = NetToVeh(Veh)
                    table.insert(TempVehicles, Veh)
                    while not DoesEntityExist(Vehicle) do
                        Citizen.Wait(100)
                    end
                    NetworkFadeInEntity(Vehicle, true)
                    NetworkRequestControlOfEntity(Vehicle)
                    ClearAreaOfPeds(CoordTable.x, CoordTable.y, CoordTable.z, 3.5)
                    exports['fw-vehicles']:SetFuelLevel(Vehicle, Data['Plate'], Data['Fuel'], false)
                    Citizen.SetTimeout(1000, function()
                        LSCore.Functions.TriggerCallback('framework-garages:server:get:vehicle:mods', function(Mods)
                            LSCore.Functions.SetVehicleProperties(Vehicle, Mods)
                            DoCarDamage(Vehicle, Data['Motor'], Data['Body'])
                            NetworkFadeInEntity(Vehicle, true)	
                            NetworkRegisterEntityAsNetworked(Vehicle)
                            LSCore.Functions.SetVehiclePlate(Vehicle, Data['Plate'])
                            exports['fw-autocare']:SetupVehicleData(Data['Plate'])
                            exports['fw-vehicles']:SetVehicleKeys(Data['Plate'], true, false)
                            TriggerServerEvent('framework-garages:server:set:vehicle:state', Data['Plate'], 'out', nil, NetToVeh(Vehicle))
                        end, Data['Plate'])
                    end)
                end, Data['Model'], CoordTable, false, Data['Plate'])
            else
                LSCore.Functions.Notify("Volgensmij staat hier al een voertuig..", "error", 5000)
            end
    elseif Data['GType']  == 'Garage' then
        local CoordTable = {x = Config.GarageSpots[CurrentParking]['Spots'][CurrentParkingSlot].x, y = Config.GarageSpots[CurrentParking]['Spots'][CurrentParkingSlot].y, z = Config.GarageSpots[CurrentParking]['Spots'][CurrentParkingSlot].z - 0.5, a = Config.GarageSpots[CurrentParking]['Spots'][CurrentParkingSlot].w}
        local CanSpawn = LSCore.Functions.IsSpawnPointClear(vector3(CoordTable.x, CoordTable.y, CoordTable.z), 2.5)
        if CanSpawn then
            LSCore.Functions.TriggerCallback('LSCore:server:spawn:vehicle', function(Veh)
                while not NetworkDoesEntityExistWithNetworkId(Veh) do
                    Citizen.Wait(350)
                end
                local Vehicle = NetToVeh(Veh)
                table.insert(TempVehicles, Veh)
                while not DoesEntityExist(Vehicle) do
                    Citizen.Wait(100)
                end
                NetworkFadeInEntity(Vehicle, true)
                NetworkRequestControlOfEntity(Vehicle)
                ClearAreaOfPeds(CoordTable.x, CoordTable.y, CoordTable.z, 3.5)
                exports['fw-vehicles']:SetFuelLevel(Vehicle, Data['Plate'], Data['Fuel'], false)
                Citizen.SetTimeout(1000, function()
                    LSCore.Functions.TriggerCallback('framework-garages:server:get:vehicle:mods', function(Mods)
                        LSCore.Functions.SetVehicleProperties(Vehicle, Mods)
                        DoCarDamage(Vehicle, Data['Motor'], Data['Body'])
                        NetworkFadeInEntity(Vehicle, true)	
                        NetworkRegisterEntityAsNetworked(Vehicle)
                        LSCore.Functions.SetVehiclePlate(Vehicle, Data['Plate'])
                        exports['fw-autocare']:SetupVehicleData(Data['Plate'])
                        exports['fw-vehicles']:SetVehicleKeys(Data['Plate'], true, false)
                        TriggerServerEvent('framework-garages:server:set:vehicle:state', Data['Plate'], 'out', nil, NetToVeh(Vehicle))
                    end, Data['Plate'])
                end)
            end, Data['Model'], CoordTable, false, Data['Plate'])
        end
    end
end)

RegisterNetEvent('framework-garages:client:sync:outside:vehicles')
AddEventHandler('framework-garages:client:sync:outside:vehicles', function(Plate, ConfigData)
    Config.OutsideVehicles[Plate] = ConfigData
end)

-- // Functions \\ --

function SetClosestParkSlot()
    local Distance, Current = nil, nil
    if CurrentParking ~= nil then
        for k, v in pairs(Config.GarageSpots[CurrentParking]['Spots']) do
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            if Config.GarageSpots[CurrentParking]['Spots'][k] ~= nil then
                if Current ~= nil then
                    if #(PlayerCoords - vector3(Config.GarageSpots[CurrentParking]['Spots'][k].x, Config.GarageSpots[CurrentParking]['Spots'][k].y, Config.GarageSpots[CurrentParking]['Spots'][k].z)) < Distance then
                        Current = k
                        Distance = #(PlayerCoords - vector3(Config.GarageSpots[CurrentParking]['Spots'][k].x, Config.GarageSpots[CurrentParking]['Spots'][k].y, Config.GarageSpots[CurrentParking]['Spots'][k].z))
                    end
                else
                   Distance = #(PlayerCoords - vector3(Config.GarageSpots[CurrentParking]['Spots'][k].x, Config.GarageSpots[CurrentParking]['Spots'][k].y, Config.GarageSpots[CurrentParking]['Spots'][k].z))
                   Current = k
                end
            end
        end
        CurrentParkingSlot = Current
    end
end

function IsPlayerOnAParkingSpot()
    if CurrentParking ~= nil and CurrentParkingSlot ~= nil then
        local PlayerCoords = GetEntityCoords(PlayerPedId())
        local Distance = #(PlayerCoords - vector3(Config.GarageSpots[CurrentParking]['Spots'][CurrentParkingSlot].x, Config.GarageSpots[CurrentParking]['Spots'][CurrentParkingSlot].y, Config.GarageSpots[CurrentParking]['Spots'][CurrentParkingSlot].z))
        if Distance < 2.65 then
            return true
        else
            return false
        end
    else
        return false
    end
end

function IsInsideDepot()
    local PlayerCoords = GetEntityCoords(PlayerPedId())
    local Distance = #(PlayerCoords - vector3(-191.93, -1161.90, 23.67))
    if Distance < 3.0 then
        return true
    else
        return false
    end
end

function DoCarDamage(Vehicle, EngineHealth, BodyHealth)
	local SmashWindows, DamageOutside, DamageOutside2 = false, false, false
	local Engine = EngineHealth + 0.0
	local Body = BodyHealth + 0.0
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