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

RegisterNetEvent('framework-vehicleshop:client:buy:vehicle')
AddEventHandler('framework-vehicleshop:client:buy:vehicle', function(Nothing, Entity)
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
end)

RegisterNetEvent('framework-vehicleshop:client:spawn:bought:vehicle')
AddEventHandler('framework-vehicleshop:client:spawn:bought:vehicle', function(VehicleName, Plate)
    local CoordTable = {x = -28.66, y = -1085.17, z = 26.56, a = 9.72}
    LSCore.Functions.TriggerCallback('LSCore:server:spawn:vehicle', function(Veh)
        while not NetworkDoesEntityExistWithNetworkId(Veh) do
          Citizen.Wait(1000)
        end
        local Vehicle = NetToVeh(Veh)
        exports['fw-vehicles']:SetVehicleKeys(Plate, true, false)
        exports['fw-vehicles']:SetFuelLevel(Vehicle, Plate, 100.0, false)
        exports['fw-autocare']:SetupVehicleData(Plate)
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