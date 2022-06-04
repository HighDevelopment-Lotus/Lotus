local HasVehiclesSpawned, SavedVehicleId, ShowingInfo = false, 0, false
local CurrentVehicle, ActiveVehicles, ShowingInteraction = nil, {}, false
local LSCore, LoggedIn = exports['fw-base']:GetCoreObject(), false 

RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1250, function()
        LSCore.Functions.TriggerCallback("framework-vehicleshop:server:get:config", function(config)
            Config = config
        end)
        LoggedIn = true
    end)
end)

RegisterNetEvent('LSCore:Client:OnPlayerUnload')
AddEventHandler('LSCore:Client:OnPlayerUnload', function()
    if HasVehiclesSpawned then
        DespawnShopVehicles()
        HasVehiclesSpawned = false
    end
    LoggedIn = false
end)

-- Code

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            local Distance = #(PlayerCoords - Config.InsideStoreCoords)
            if Distance < 35.0 then
                if not HasVehiclesSpawned then
                    HasVehiclesSpawned = true
                    SpawnShopVehicles()
                end
                Citizen.Wait(4000)
            else
                if HasVehiclesSpawned then
                    DespawnShopVehicles()
                    HasVehiclesSpawned = false
                end
                Citizen.Wait(450)
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
            local Distance = #(PlayerCoords - Config.InsideStoreCoords)
            if Distance < 15.0 then
                if not Config.InsideStore then
                    Config.InsideStore = true
                end
                SetClosestVehicle()
                NearVehicle = false
                if SavedVehicleId ~= CurrentVehicle then
                    exports['fw-ui']:RemoveInfo()
                    ShowedInfo = false
                    Citizen.Wait(50)
                    SavedVehicleId = CurrentVehicle
                else
                    local Distance = #(PlayerCoords - vector3(Config.StoreVehicles[CurrentVehicle]['Coords'].x, Config.StoreVehicles[CurrentVehicle]['Coords'].y, Config.StoreVehicles[CurrentVehicle]['Coords'].z))
                    if Distance < 3.0 then
                        NearVehicle = true
                        if not ShowingInfo then
                            ShowingInfo = true
                            SavedVehicleId = CurrentVehicle
                            if LSCore.Shared.HashVehicles[GetHashKey(Config.StoreVehicles[CurrentVehicle]['Vehicle'])] ~= nil then
                                local VehicleData = LSCore.Shared.HashVehicles[GetHashKey(Config.StoreVehicles[CurrentVehicle]['Vehicle'])]
                                local Data = {['Title'] = VehicleData['Brand']..' '..VehicleData['Name'], ['Items'] = {[1] = {['Text'] = 'Voertuig kosten: €'..VehicleData['Price']..',-'}}}
                                exports['fw-ui']:ShowInfo(Data)
                            else
                                local Data = {['Title'] = 'ERROR', ['Items'] = {[1] = {['Text'] = 'Meld support dit voertuig model!'}}}
                                exports['fw-ui']:ShowInfo(Data)
                            end
                        end
                    end
                end
                if not NearVehicle then
                    if ShowingInfo then
                        exports['fw-ui']:RemoveInfo()
                        ShowingInfo = false
                    end
                    Citizen.Wait(450)
                end
            else
                if Config.InsideStore then
                    Config.InsideStore = false
                    CurrentVehicle = nil
                end
                if ShowingInfo then
                    exports['fw-ui']:RemoveInfo()
                    ShowingInfo = false
                end
                Citizen.Wait(450)
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
            NearVehicleSell = false
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            local Distance = #(PlayerCoords - Config.QuickSellCoords)
            if Distance < 5.0 and IsPedSittingInAnyVehicle(PlayerPedId()) then
                NearVehicleSell = true
                if not ShowingInteraction then
                    ShowingInteraction = true
                    exports['fw-ui']:ShowInteraction('[E] Voertuig Verkopen (50%)', 'primary')
                end
                if IsControlJustReleased(0, 38) then
                    local Vehicle = GetVehiclePedIsIn(PlayerPedId())
                    local Plate = GetVehicleNumberPlateText(Vehicle)
                    LSCore.Functions.TriggerCallback('framework-garage:server:is:vehicle:owner', function(IsOwner)
                        if IsOwner then
                            local VehicleData = LSCore.Shared.HashVehicles[GetEntityModel(Vehicle)]
                            if VehicleData ~= nil then
                                TriggerServerEvent('framework-vehicleshop:server:quick:sell', Plate, VehicleData)
                                LSCore.Functions.DeleteVehicle(Vehicle)
                            else
                                LSCore.Functions.Notify('Sorry, we kunnen dit voertuig niet overkopen van je...', 'error', 5500)
                            end
                        else
                            LSCore.Functions.Notify('Dit voertuig is niet van jou...', 'error', 5500)
                        end
                    end, Plate)
                end
            end
            if not NearVehicleSell then
                if ShowingInteraction then
                    ShowingInteraction = false
                    exports['fw-ui']:HideInteraction()
                end
                Citizen.Wait(450)
            end
        else
            Citizen.Wait(450)
        end
    end
end)

-- // Events \\ -- 
RegisterNetEvent('framework-vehicleshop:client:open:select:menu')
AddEventHandler('framework-vehicleshop:client:open:select:menu', function()
    local MenuItems = {}
    for k, v in pairs(Config.PDMCardealerMenu) do
        local TempData = {}
        TempData['Title'] = v['Label']
        TempData['Desc'] = 'Selecteer Categorie'
        TempData['Data'] = {['Event'] = 'framework-vehicleshop:client:open:vehicle:menu', ['Type'] = 'Client', ['Category'] = v['Category']}
        table.insert(MenuItems, TempData)
    end
    if (#MenuItems > 0) then
        local Data = {['Title'] = 'Selecteer Categorie', ['MainMenuItems'] = MenuItems}
        LSCore.Functions.OpenMenu(Data)
    end
end)

RegisterNetEvent('framework-vehicleshop:client:open:vehicle:menu')
AddEventHandler('framework-vehicleshop:client:open:vehicle:menu', function(data)
    Citizen.SetTimeout(500, function()
        local MenuItems = {}
        LSCore.Functions.TriggerCallback('framework-vehicleshop:server:get:cardealer:vehicles', function(ReturnValue) 
            for k, v in pairs(ReturnValue) do
                local TempData = {}
                TempData['Title'] = LSCore.Shared.Vehicles[v['Vehicle']]['Name']..' (€'..v['Price']..')'
                TempData['Image'] = LSCore.Shared.Vehicles[v['Vehicle']]['Image']
                TempData['Desc'] = 'Voertuig Voorraad: '..v['Stock']
                TempData['Data'] = {['Event'] = 'framework-vehicleshop:client:open:place:menu', ['Type'] = 'Client', ['Price'] = v['Price'], ['Vehicle'] = v['Vehicle']}
                table.insert(MenuItems, TempData)
            end
            if (#MenuItems > 0) then
                local Data = {['Title'] = 'Categorie: '..data['Category'], ['MainMenuItems'] = MenuItems}
                LSCore.Functions.OpenMenu(Data)
            end
        end, data['Category'])
    end)
end)

RegisterNetEvent('framework-vehicleshop:client:open:place:menu')
AddEventHandler('framework-vehicleshop:client:open:place:menu', function(data)
    Citizen.SetTimeout(500, function()
        local MenuItems = {}
        for k, v in pairs(Config.PDMCardealerSpots) do
            local TempData = {}
            TempData['Title'] = 'Locatie: '..k
            TempData['Desc'] = 'Zet het voertuig op deze locatie'
            TempData['Data'] = {['Event'] = 'framework-vehicleshop:server:set:vehicle', ['Type'] = 'Server', ['Location'] = k, ['Vehicle'] = data['Vehicle']}
            table.insert(MenuItems, TempData)
        end
        if (#MenuItems > 0) then
            local Data = {['Title'] = 'Voertuig Locatie Toewijzen', ['MainMenuItems'] = MenuItems}
            LSCore.Functions.OpenMenu(Data)
        end
    end)
end)


RegisterNetEvent('framework-vehicleshop:client:open:place:question', function()
    Citizen.SetTimeout(500, function()
        local MenuItems = {
            [1] = {['Title'] = 'Ja', ['Desc'] = 'Koop dit voertuig', ['Data'] = { ['Event'] = 'framework-vehicleshop:client:buy:vehicle', ['Type'] = 'Client', ['args'] = 'jawohl'} }, 
            [2] = {['Title'] = 'Nee', ['Desc'] = 'Koop dit voertuig', ['Data'] = { ['Event'] = '', ['Type'] = 'Client', ['args'] = 'nein'} }, 
            }
            local Data = {['Title'] = 'Wil je dit voertuig kopen ?', ['Desc'] = 'Maak hieronder je keuze', ['MainMenuItems'] = MenuItems}
        LSCore.Functions.OpenMenu(Data)
    end)
end)

RegisterNetEvent('framework-vehicleshop:client:buy:vehicle')
AddEventHandler('framework-vehicleshop:client:buy:vehicle', function(data)
    if data['args'] == 'jawohl' then
        if GetEntityModel(LSCore.Functions.GetClosestVehicle()) == GetHashKey(Config.StoreVehicles[CurrentVehicle]['Vehicle']) then
            LSCore.Functions.TriggerCallback("framework-vehicleshop:server:can:purchase", function(CanBuy)
                if CanBuy then
                    LSCore.Functions.Progressbar("lockpick-door", "Voertuig Kopen..", 5500, false, false, {
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
                        TriggerServerEvent('framework-vehicleshop:server:buy:vehicle', GetEntityModel(LSCore.Functions.GetClosestVehicle()))
                        StopAnimTask(PlayerPedId(), "missheistdockssetup1clipboard@base", "base", 1.0)
                    end, function()
                        LSCore.Functions.Notify("Geannuleerd..", "error")
                        StopAnimTask(PlayerPedId(), "missheistdockssetup1clipboard@base", "base", 1.0)
                    end)
                else
                    LSCore.Functions.Notify('Volgensmij heb je nog niet genoeg geld..', 'error')
                end
            end, LSCore.Shared.HashVehicles[GetEntityModel(LSCore.Functions.GetClosestVehicle())]['Price'])
        else
            LSCore.Functions.Notify('Dit is niet het goeie model om te kopen..', 'error')
        end
    end
end)

RegisterNetEvent('framework-vehicleshop:client:spawn:bought:vehicle')
AddEventHandler('framework-vehicleshop:client:spawn:bought:vehicle', function(VehicleName, Plate)
    local CoordTable = {x = -7.429858, y = -1083.14, z = 27.047233, a = 147.67189}
    LSCore.Functions.TriggerCallback('LSCore:server:spawn:vehicle', function(Veh)
        while not NetworkDoesEntityExistWithNetworkId(Veh) do
          Citizen.Wait(1000)
        end
        local Vehicle = NetToVeh(Veh)
        exports['fw-vehicles']:SetVehicleKeys(Plate, true, false)
        exports['fw-vehicles']:SetFuelLevel(Vehicle, Plate, 100.0, false)
        -- exports['fw-autocare']:SetupVehicleData(Plate)
        LSCore.Functions.SetVehiclePlate(Vehicle, Plate)
        Citizen.Wait(125)
        TaskWarpPedIntoVehicle(PlayerPedId(), Vehicle, -1)
    end, VehicleName, CoordTable, false, Plate)
end)

RegisterNetEvent('framework-vehicleshop:server:sync:config')
AddEventHandler('framework-vehicleshop:server:sync:config', function(ConfigData)
    Config.StoreVehicles = ConfigData
    if HasVehiclesSpawned then
        DespawnShopVehicles()
        Citizen.SetTimeout(500, function()
            SpawnShopVehicles()
        end)
    end
end)

-- // Functions \\ --

function SpawnShopVehicles()
    for k, v in pairs(Config.StoreVehicles) do
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

function DespawnShopVehicles()
    for k, v in pairs(ActiveVehicles) do
        DeleteVehicle(v)
    end
    ActiveVehicles = {}
end

function IsInsideDealer()
    return Config.InsideStore
end

function SetClosestVehicle()
    local Distance = nil
    local Current = nil
    if Config.InsideStore then
        for k, v in pairs(Config.StoreVehicles) do
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            if Config.StoreVehicles[k] ~= nil and Config.StoreVehicles[k]['Coords'] ~= nil then
                if Current ~= nil then
                    if #(PlayerCoords - vector3(Config.StoreVehicles[k]['Coords'].x, Config.StoreVehicles[k]['Coords'].y, Config.StoreVehicles[k]['Coords'].z)) < Distance then
                        Current = k
                        Distance = #(PlayerCoords - vector3(Config.StoreVehicles[k]['Coords'].x, Config.StoreVehicles[k]['Coords'].y, Config.StoreVehicles[k]['Coords'].z))
                    end
                else
                   Distance = #(PlayerCoords - vector3(Config.StoreVehicles[k]['Coords'].x, Config.StoreVehicles[k]['Coords'].y, Config.StoreVehicles[k]['Coords'].z))
                   Current = k
                end
            end
        end
        CurrentVehicle = Current
    end
end