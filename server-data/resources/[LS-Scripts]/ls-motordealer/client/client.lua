local LSCore, LoggedIn, PlayerJob = exports['ls-core']:GetCoreObject(), false, nil
local NearMotorShop, ActiveVehicles, ShowedInfo = false, {}, false

RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1250, function()
        PlayerJob = LSCore.Functions.GetPlayerData().job
        Citizen.Wait(1200)
        LSCore.Functions.TriggerCallback("ls-motordealer:server:get:config", function(ConfigData)
            Config = ConfigData
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
            NearMotorShop = false
            local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
            local Distance = #(PlayerCoords - Config.MotorShopLocation)
            if Distance < 50.0 then
                NearMotorShop = true
                if not SpawnedVehicles then
                    SpawnedVehicles = true
                    SetupDealerVehicles()
                end
            end
            if not NearMotorShop then
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
            local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
            local DDistance = #(PlayerCoords - vector3(988.66, -129.98, 74.06))
            if DDistance < 25.0 then
                local NearVehicle = false
                local Vehicle, Distance = LSCore.Functions.GetClosestVehicle()
                if Vehicle ~= 0 and Distance < 3.5 then
                    NearVehicle = true
                    if not ShowedInfo then
                        ShowedInfo = true
                        local VehicleData = LSCore.Shared.HashVehicles[GetEntityModel(Vehicle)]
                        if VehicleData ~= nil then
                            local Data = {['Title'] = VehicleData['Brand']..' '..VehicleData['Name'], ['Items'] = {[1] = {['Text'] = 'Voertuig kosten: €'..VehicleData['Price']..',-'}}}
                            exports['ls-ui']:ShowInfo(Data)
                        end
                    end
                end
                if not NearVehicle then
                    if ShowedInfo then
                        ShowedInfo = false
                        exports['ls-ui']:RemoveInfo()
                    end
                    Citizen.Wait(450)
                end
            else
                if ShowedInfo then
                    ShowedInfo = false
                    exports['ls-ui']:RemoveInfo()
                end
                Citizen.Wait(450)
            end
        else
            Citizen.Wait(450)
        end
    end
end)

-- // Events \\ --

RegisterNetEvent('ls-motordealer:client:open:select:menu')
AddEventHandler('ls-motordealer:client:open:select:menu', function()
    local MenuItems = {}
    for k, v in pairs(Config.MotorShopMenu) do
        local TempData = {}
        TempData['Title'] = v['Label']
        TempData['Desc'] = 'Selecteer Categorie'
        TempData['Data'] = {['Event'] = 'ls-motordealer:client:open:vehicle:menu', ['Type'] = 'Client', ['Category'] = v['Category']}
        table.insert(MenuItems, TempData)
    end
    if (#MenuItems > 0) then
        local Data = {['Title'] = 'Selecteer Categorie', ['MainMenuItems'] = MenuItems}
        LSCore.Functions.OpenMenu(Data)
    end
end)

RegisterNetEvent('ls-motordealer:client:open:vehicle:menu')
AddEventHandler('ls-motordealer:client:open:vehicle:menu', function(data)
    Citizen.SetTimeout(500, function()
        local MenuItems = {}
        LSCore.Functions.TriggerCallback('ls-motordealer:server:get:motordealer:vehicles', function(ReturnValue) 
            for k, v in pairs(ReturnValue) do
                local TempData = {}
                TempData['Title'] = LSCore.Shared.Vehicles[v['Vehicle']]['Name']..' (€'..v['Price']..')'
                TempData['Image'] = LSCore.Shared.Vehicles[v['Vehicle']]['Image']
                TempData['Data'] = {['Event'] = 'ls-motordealer:client:open:place:menu', ['Type'] = 'Client', ['Price'] = v['Price'], ['Vehicle'] = v['Vehicle']}
                table.insert(MenuItems, TempData)
            end
            if (#MenuItems > 0) then
                local Data = {['Title'] = 'Categorie: '..data['Category'], ['MainMenuItems'] = MenuItems}
                LSCore.Functions.OpenMenu(Data)
            end
        end, data['Category'])
    end)
end)

RegisterNetEvent('ls-motordealer:client:open:place:menu')
AddEventHandler('ls-motordealer:client:open:place:menu', function(data)
    Citizen.SetTimeout(500, function()
        local MenuItems = {}
        for k, v in pairs(Config.MotorShopSpots) do
            local TempData = {}
            TempData['Title'] = 'Locatie: '..k
            TempData['Desc'] = 'Zet het voertuig op deze locatie'
            TempData['Data'] = {['Event'] = 'ls-motordealer:server:set:vehicle', ['Type'] = 'Server', ['Location'] = k, ['Vehicle'] = data['Vehicle']}
            table.insert(MenuItems, TempData)
        end
        if (#MenuItems > 0) then
            local Data = {['Title'] = 'Voertuig Locatie Toewijzen', ['MainMenuItems'] = MenuItems}
            LSCore.Functions.OpenMenu(Data)
        end
    end)
end)

RegisterNetEvent('ls-motordealer:client:test:closest:vehicle')
AddEventHandler('ls-motordealer:client:test:closest:vehicle', function(Niks, Entity)
    if IsModelASellVehicle(Entity['Entity']) then
        local VehicleData = LSCore.Shared.HashVehicles[GetEntityModel(Entity['Entity'])]
        local CoordTable = {x = 976.91, y = -127.18, z = 74.12, a = 61.33}
        local Plate = tostring('CARDEL'..math.random(11,99))
        LSCore.Functions.TriggerCallback('LSCore:server:spawn:vehicle', function(Veh)
            while not NetworkDoesEntityExistWithNetworkId(Veh) do
              Citizen.Wait(1000)
            end
            local Vehicle = NetToVeh(Veh)
            exports['ls-vehiclekeys']:SetVehicleKeys(Plate, true, false)
            exports['ls-fuel']:SetFuelLevel(Vehicle, Plate, 100, false)
            LSCore.Functions.SetVehiclePlate(Vehicle, Plate)
            LSCore.Functions.Notify("Voertuig staat buiten klaar!", "success")
        end, VehicleData['Vehicle'], CoordTable, false, Plate)
    else
        LSCore.Functions.Notify("Dit is geen verkoop voertuig..", "error")
    end 
end)

RegisterNetEvent('ls-motordealer:client:sell:clossest:vehicle')
AddEventHandler('ls-motordealer:client:sell:clossest:vehicle', function(Niks, Entity)
    local Player, Distance = LSCore.Functions.GetClosestPlayer()
    if IsModelASellVehicle(Entity['Entity']) then
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
                TriggerServerEvent('ls-motordealer:server:sell:closest', GetPlayerServerId(Player), GetEntityModel(Entity['Entity']))
                StopAnimTask(GetPlayerPed(-1), "missheistdockssetup1clipboard@base", "base", 1.0)
            end, function()
                LSCore.Functions.Notify("Geannuleerd..", "error")
                StopAnimTask(GetPlayerPed(-1), "missheistdockssetup1clipboard@base", "base", 1.0)
            end)
        else
            LSCore.Functions.Notify("Niemand in de buurt!", "error")
        end
    else
        LSCore.Functions.Notify("Dit is geen verkoop voertuig..", "error")
    end 
end)

RegisterNetEvent('ls-motordealer:client:spawn:vehicle')
AddEventHandler('ls-motordealer:client:spawn:vehicle', function(Model, Plate)
    local CoordTable = {x = 979.08, y = -118.37, z = 74.03, a = 135.22}
    LSCore.Functions.TriggerCallback('LSCore:server:spawn:vehicle', function(Veh)
        while not NetworkDoesEntityExistWithNetworkId(Veh) do
          Citizen.Wait(1000)
        end
        local Vehicle = NetToVeh(Veh)
        exports['ls-autocare']:SetupVehicleData(Plate)
        exports['ls-vehiclekeys']:SetVehicleKeys(Plate, true, false)
        exports['ls-fuel']:SetFuelLevel(Vehicle, Plate, 100, false)
        LSCore.Functions.SetVehiclePlate(Vehicle, Plate)
        LSCore.Functions.Notify("Voertuig staat buiten klaar!", "success")
    end, Model, CoordTable, false, Plate)
end)

RegisterNetEvent('ls-motordealer:client:sync:data')
AddEventHandler('ls-motordealer:client:sync:data', function(ConfigData)
    Config.MotorShopSpots = ConfigData
    if NearMotorShop then
        RemoveDealerVehicles()
        Citizen.SetTimeout(2000, function()
            SetupDealerVehicles()
        end)
    end
end)

-- // Functions \\ --

function SetupDealerVehicles()
    for k, v in pairs(Config.MotorShopSpots) do
        if v['Vehicle'] ~= nil then
            exports['ls-assets']:RequestModelHash(v['Vehicle'])
            local ShowroomMotor = CreateVehicle(v['Vehicle'], v['Coords'].x, v['Coords'].y, v['Coords'].z, v['Coords'].w, false)
            SetModelAsNoLongerNeeded(ShowroomMotor)
            SetVehicleOnGroundProperly(ShowroomMotor)
            SetEntityInvincible(ShowroomMotor, true)
            SetVehicleDoorsLocked(ShowroomMotor, 3)
            FreezeEntityPosition(ShowroomMotor, true)
            SetVehicleNumberPlateText(ShowroomMotor, k .. "MTRSALE")
            table.insert(ActiveVehicles, ShowroomMotor)
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
        if k == GetEntityModel(Entity) and v['Class'] == 'motor' then
            return true
        end
    end
    return false
end

function GetTotalCategoryNumber(Category)
    local ReturnData = 0
    LSCore.Functions.TriggerCallback('ls-motordealer:server:get:motordealer:vehicles', function(ReturnValue) 
        ReturnData = #ReturnValue
    end, Category)
    return ReturnData
end

function IsInsideMotorDealer()
    return NearMotorShop
end