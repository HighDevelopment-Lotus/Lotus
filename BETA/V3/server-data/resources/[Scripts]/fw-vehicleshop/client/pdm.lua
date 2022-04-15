local LSCore, LoggedIn, PlayerJob = exports['fw-base']:GetCoreObject(), false, nil
local NearCardealer, ActiveVehicles, ShowedInfo = false, {}, false

RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1250, function()  
        PlayerJob = LSCore.Functions.GetPlayerData().job
        LSCore.Functions.TriggerCallback("framework-cardealer:server:get:config", function(config)
            Config = config
        end)
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

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            NearCardealer = false
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            local Distance = #(PlayerCoords - Config.CardealerLocation)
            if Distance < 50.0 then
                NearCardealer = true
                if not SpawnedVehicles then
                    SpawnedVehicles = true
                    SetupDealerVehicles()
                end
            end
            if not NearCardealer then
                if SpawnedVehicles then
                    SpawnedVehicles = false
                    RemoveDealerVehicles()
                end
                Citizen.Wait(1500)
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
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            local DDistance = #(PlayerCoords - vector3(-779.23, -222.54, 37.69))
            if DDistance < 25.0 then
                local NearVehicle = false
                local Vehicle, Distance = LSCore.Functions.GetClosestVehicle()
                if Vehicle ~= 0 and Distance < 3.5 then
                    NearVehicle = true
                    if not ShowedInfo then
                        ShowedInfo = true
                        local VehicleData = LSCore.Shared.HashVehicles[GetEntityModel(Vehicle)]
                        if VehicleData ~= nil then
                            LSCore.Functions.TriggerCallback('framework-cardealer:server:get:vehicle:stock', function(ReturnValue) 
                                local Data = {['Title'] = VehicleData['Brand']..' '..VehicleData['Name'], ['Items'] = {[1] = {['Text'] = 'Voertuig kosten: €'..VehicleData['Price']..',-'}, [2] = {['Text'] = 'Voertuig Voorraad: '..ReturnValue}}}
                                exports['fw-ui']:ShowInfo(Data)
                            end, VehicleData['Vehicle'])
                        end
                    end
                end
                if not NearVehicle then
                    if ShowedInfo then
                        ShowedInfo = false
                        exports['fw-ui']:RemoveInfo()
                    end
                    Citizen.Wait(450)
                end
            else
                if ShowedInfo then
                    ShowedInfo = false
                    exports['fw-ui']:RemoveInfo()
                end
                Citizen.Wait(450)
            end
        else
            Citizen.Wait(450)
        end
    end
end)

-- // Events \\ --

RegisterNetEvent('framework-cardealer:client:open:select:menu')
AddEventHandler('framework-cardealer:client:open:select:menu', function()
    local MenuItems = {}
    for k, v in pairs(Config.CardealerMenu) do
        local TempData = {}
        TempData['Title'] = v['Label']
        TempData['Desc'] = 'Selecteer Categorie'
        TempData['Data'] = {['Event'] = 'framework-cardealer:client:open:vehicle:menu', ['Type'] = 'Client', ['Category'] = v['Category']}
        table.insert(MenuItems, TempData)
    end
    if (#MenuItems > 0) then
        local Data = {['Title'] = 'Selecteer Categorie', ['MainMenuItems'] = MenuItems}
        LSCore.Functions.OpenMenu(Data)
    end
end)

RegisterNetEvent('framework-cardealer:client:open:vehicle:menu')
AddEventHandler('framework-cardealer:client:open:vehicle:menu', function(data)
    Citizen.SetTimeout(500, function()
        local MenuItems = {}
        LSCore.Functions.TriggerCallback('framework-cardealer:server:get:cardealer:vehicles', function(ReturnValue) 
            for k, v in pairs(ReturnValue) do
                local TempData = {}
                TempData['Title'] = LSCore.Shared.Vehicles[v['Vehicle']]['Name']..' (€'..v['Price']..')'
                TempData['Image'] = LSCore.Shared.Vehicles[v['Vehicle']]['Image']
                TempData['Desc'] = 'Voertuig Voorraad: '..v['Stock']
                TempData['Data'] = {['Event'] = 'framework-cardealer:client:open:place:menu', ['Type'] = 'Client', ['Price'] = v['Price'], ['Vehicle'] = v['Vehicle']}
                table.insert(MenuItems, TempData)
            end
            if (#MenuItems > 0) then
                local Data = {['Title'] = 'Categorie: '..data['Category'], ['MainMenuItems'] = MenuItems}
                LSCore.Functions.OpenMenu(Data)
            end
        end, data['Category'])
    end)
end)

RegisterNetEvent('framework-cardealer:client:open:place:menu')
AddEventHandler('framework-cardealer:client:open:place:menu', function(data)
    Citizen.SetTimeout(500, function()
        local MenuItems = {}
        for k, v in pairs(Config.CardealerSpots) do
            local TempData = {}
            TempData['Title'] = 'Locatie: '..k
            TempData['Desc'] = 'Zet het voertuig op deze locatie'
            TempData['Data'] = {['Event'] = 'framework-cardealer:server:set:vehicle', ['Type'] = 'Server', ['Location'] = k, ['Vehicle'] = data['Vehicle']}
            table.insert(MenuItems, TempData)
        end
        if (#MenuItems > 0) then
            local Data = {['Title'] = 'Voertuig Locatie Toewijzen', ['MainMenuItems'] = MenuItems}
            LSCore.Functions.OpenMenu(Data)
        end
    end)
end)

RegisterNetEvent('framework-cardealer:client:test:closest:vehicle')
AddEventHandler('framework-cardealer:client:test:closest:vehicle', function(Niks, Entity)
    if IsModelASellVehicle(LSCore.Functions.GetClosestVehicle()) then
        local Plate = tostring('CARDEL'..math.random(11,99))
        local CoordTable = {x = -764.87, y = -243.95, z = 37.24, a = 109.77}
        local VehicleData = LSCore.Shared.HashVehicles[GetEntityModel(LSCore.Functions.GetClosestVehicle())]
        LSCore.Functions.TriggerCallback('LSCore:server:spawn:vehicle', function(Veh)
            while not NetworkDoesEntityExistWithNetworkId(Veh) do
              Citizen.Wait(1000)
            end
            local Vehicle = NetToVeh(Veh)
            exports['fw-vehicles']:SetVehicleKeys(Plate, true, false)
            exports['fw-vehicles']:SetFuelLevel(Vehicle, Plate, 100, false)
            LSCore.Functions.SetVehiclePlate(Vehicle, Plate)
            LSCore.Functions.Notify("Voertuig staat buiten klaar!", "success")
        end, VehicleData['Vehicle'], CoordTable, false, Plate)
    else
        LSCore.Functions.Notify("Dit is geen verkoop voertuig..", "error")
    end 
end)

RegisterNetEvent('framework-cardealer:client:sell:clossest:vehicle')
AddEventHandler('framework-cardealer:client:sell:clossest:vehicle', function(Niks, Entity)
    local Player, Distance = LSCore.Functions.GetClosestPlayer()
    if IsModelASellVehicle(LSCore.Functions.GetClosestVehicle()) then
        if Player ~= -1 and Distance < 2.5 then
            LSCore.Functions.Progressbar("lockpick-door", "Voertuig Verkopen..", 5500, false, false, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {
                animDict = "missheistdockssetup1clipboard@base",
                anim = "base",
                flags = 49,
            }, {
                model = "p_amb_clipboard_01",
                bone = 18905,
                coords = { x = 0.10, y = 0.02, z = 0.08 },
                rotation = { x = -80.0, y = 0.0, z = 0.0 },
            }, {
                model = "prop_pencil_01",
                bone = 58866,
                coords = { x = 0.12, y = 0.0, z = 0.001 },
                rotation = { x = -150.0, y = 0.0, z = 0.0 },
            }, function() -- Done
                TriggerServerEvent('framework-cardealer:server:sell:closest', GetPlayerServerId(Player), GetEntityModel(LSCore.Functions.GetClosestVehicle()))
                StopAnimTask(PlayerPedId(), "missheistdockssetup1clipboard@base", "base", 1.0)
            end, function()
                LSCore.Functions.Notify("Geannuleerd..", "error")
                StopAnimTask(PlayerPedId(), "missheistdockssetup1clipboard@base", "base", 1.0)
            end)
        else
            LSCore.Functions.Notify("Niemand in de buurt!", "error")
        end
    else
        LSCore.Functions.Notify("Dit is geen verkoop voertuig..", "error")
    end 
end)

RegisterNetEvent('framework-cardealer:client:spawn:vehicle')
AddEventHandler('framework-cardealer:client:spawn:vehicle', function(Model, Plate)
    local CoordTable = {x = -759.09, y = -233.87, z = 37.28, a = 209.51}
    LSCore.Functions.TriggerCallback('LSCore:server:spawn:vehicle', function(Veh)
        while not NetworkDoesEntityExistWithNetworkId(Veh) do
          Citizen.Wait(1000)
        end
        local Vehicle = NetToVeh(Veh)
        exports['fw-autocare']:SetupVehicleData(Plate)
        exports['fw-vehicles']:SetVehicleKeys(Plate, true, false)
        exports['fw-vehicles']:SetFuelLevel(Vehicle, Plate, 100, false)
        LSCore.Functions.SetVehiclePlate(Vehicle, Plate)
        LSCore.Functions.Notify("Voertuig staat buiten in de steeg klaar!", "success")
    end, Model, CoordTable, false, Plate)
end)

RegisterNetEvent('framework-cardealer:client:sync:data')
AddEventHandler('framework-cardealer:client:sync:data', function(ConfigData)
    Config.CardealerSpots = ConfigData
    if NearCardealer then
        RemoveDealerVehicles()
        Citizen.SetTimeout(2000, function()
            SetupDealerVehicles()
        end)
    end
end)

-- // Functions \\ --

function SetupDealerVehicles()
    for k, v in pairs(Config.CardealerSpots) do
        if v['Vehicle'] ~= nil then
            exports['fw-assets']:RequestModelHash(v['Vehicle'])
            local ShowroomCar = CreateVehicle(v['Vehicle'], v['Coords'].x, v['Coords'].y, v['Coords'].z, v['Coords'].w, false)
            SetModelAsNoLongerNeeded(ShowroomCar)
            SetVehicleOnGroundProperly(ShowroomCar)
            SetEntityInvincible(ShowroomCar, true)
            SetVehicleDoorsLocked(ShowroomCar, 3)
            FreezeEntityPosition(ShowroomCar, true)
            SetVehicleNumberPlateText(ShowroomCar, k .. "CARSALE")
            table.insert(ActiveVehicles, ShowroomCar)
        end
    end
end

function RemoveDealerVehicles()
    if ActiveVehicles ~= nil then
        for k, v in pairs(ActiveVehicles) do
            NetworkRequestControlOfEntity(v)
            DeleteVehicle(v)
        end
    end
end

function IsModelASellVehicle(Entity)
    for k, v in pairs(LSCore.Shared.HashVehicles) do
        if k == GetEntityModel(Entity) and v['Class'] == 'custom' then
            return true
        end
    end
    return false
end

function GetTotalCategoryNumber(Category)
    local ReturnData = 0
    LSCore.Functions.TriggerCallback('framework-cardealer:server:get:cardealer:vehicles', function(ReturnValue) 
        ReturnData = #ReturnValue
    end, Category)
    return ReturnData
end

function InsideCardealer()
    return NearCardealer
end