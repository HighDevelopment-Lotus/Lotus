-- Banktruck
local ShowingInteraction = false
local HeistBag, HeistThermite, HeistBagScene = nil, nil, nil
-- Code

RegisterNetEvent('framework-items:client:use:heavy-thermite')
AddEventHandler('framework-items:client:use:heavy-thermite', function()
    local Vehicle, Distance = LSCore.Functions.GetClosestVehicle()
    local VehicleModel = LSCore.Shared.HashVehicles[GetEntityModel(Vehicle)]
    if VehicleModel ~= nil and GetEntityModel(Vehicle) == GetHashKey('stockade') and Distance < 5.5 then
        if CurrentCops >= Config.CopsNeeded then
            local Plate = GetVehicleNumberPlateText(Vehicle)
            if not Config.RobbedPlates[Plate] then
                local Coords = GetOffsetFromEntityInWorldCoords(Vehicle, 0.0, -3.55, 0.5)
                LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, 'heavy-thermite', 1, false)
                TriggerServerEvent('framework-police:server:send:banktruck:alert', GetEntityCoords(PlayerPedId()), Plate, LSCore.Functions.GetStreetLabel())
                if math.random(1, 100) <= 65 and not IsWearingHandshoes() then
                    TriggerServerEvent("framework-police:server:create:evidence", 'Finger', GetEntityCoords(PlayerPedId()))
                end
                TriggerEvent('framework-assets:client:thermite:anim', Coords)
                Citizen.SetTimeout(6500, function()
                    exports['fw-ui']:StartBlocksGame(function(Outcome)
                        if Outcome then
                            -- TriggerServerEvent('framework-banktruck:server:update:plates', Plate)
                            RequestNamedPtfxAsset("scr_ornate_heist")
                            SetPtfxAssetNextCall("scr_ornate_heist")
                            local Effect = StartParticleFxLoopedAtCoord("scr_heist_ornate_thermal_burn", Coords, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
                            Citizen.Wait(10000)
                            StopParticleFxLooped(Effect, 0)
                            TriggerEvent('framework-assets:client:reset:thermite:anim')
                            SpawnProtection(Vehicle)
                            TruckLoop(Vehicle)
                        else
                            TriggerEvent('framework-assets:client:reset:thermite:anim')
                        end
                    end)
                end)   
            else
                LSCore.Functions.Notify("Deze truck is recent overvallen..", "error")
            end
        end
    end
end)

RegisterNetEvent('framework-banktruck:sync')
AddEventHandler('framework-banktruck:sync', function(PlateData)
    Config.RobbedPlates = PlateData
end)

-- // Functions \\ --

function SpawnProtection(Vehicle)
    exports['fw-assets']:RequestModelHash('s_m_m_strpreach_01')
    for i = -1, 4 do
        local Protection = CreatePedInsideVehicle(Vehicle, 5, "s_m_m_strpreach_01", i, 1, 1)
        SetPedShootRate(Protection, 750)
        SetPedCombatAttributes(Protection, 46, true)
        SetPedFleeAttributes(Protection, 0, 0)
        SetPedAsEnemy(Protection, true)
        SetPedArmour(Protection, 200.0)
        SetPedMaxHealth(Protection, 900.0)
        SetPedAlertness(Protection, 3)
        SetPedCombatRange(Protection, 0)
        SetPedCombatMovement(Protection, 3)
        TaskCombatPed(Protection, PlayerPedId(), 0,16)
        TaskLeaveVehicle(Protection, Vehicle, 0)
        GiveWeaponToPed(Protection, GetHashKey("WEAPON_SMG"), 5000, true, true)
        SetPedRelationshipGroupHash(Protection, GetHashKey("HATES_PLAYER"))
    end
end

function TruckLoop(Vehicle)
    local RobbingTruck, Stealing = false, false
    Citizen.CreateThread(function()
        while not RobbingTruck do
            Citizen.Wait(4)
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            local TruckCoords = GetOffsetFromEntityInWorldCoords(Vehicle, 0.0, -3.5, 0.5)
            local Distance = #(PlayerCoords - TruckCoords)
            local Plate = GetVehicleNumberPlateText(Vehicle)
            if Distance < 3.0 then
                if not ShowingInteraction then
                    ShowingInteraction = true
                    exports['fw-ui']:ShowInteraction('[E] Bank Truck', 'primary')
                end
                if IsControlJustReleased(0, 38) then
                    
                    if not Config.RobbedPlates[Plate] then
                        if not exports['fw-progressbar']:GetTaskBarStatus() then
                            RobbingTruck, Stealing = false, true
                            TriggerServerEvent('framework-hud:Server:gain:stress', math.random(2, 3))
                            if math.random(1, 100) <= 85 and not IsWearingHandshoes() then
                                TriggerServerEvent("framework-police:server:create:evidence", 'Finger', GetEntityCoords(PlayerPedId()))
                            end
                            ShowingInteraction = false
                            exports['fw-ui']:HideInteraction()
                            LSCore.Functions.Progressbar("open_locker", "Spullen Stelen..", math.random(24000, 38000), false, false, {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            }, {
                                animDict = "anim@heists@ornate_bank@grab_cash_heels",
                                anim = "grab",
                                flags = 16,
                            }, {
                            model = "prop_cs_heist_bag_02",
                            bone = 57005,
                            coords = { x = -0.005, y = 0.00, z = -0.16 },
                            rotation = { x = 250.0, y = -30.0, z = 0.0 },
                            }, {}, function() -- Done
                                TriggerServerEvent('framework-banktruck:server:update:plates', Plate)
                                Stealing = false
                                StopAnimTask(PlayerPedId(), "anim@heists@ornate_bank@grab_cash_heels", "grab", 1.0)
                            end)
                            Citizen.CreateThread(function()
                                while Stealing do
                                    Citizen.Wait(4)
                                    -- TriggerServerEvent('framework-banktruck:server:rewards')
                                    LSCore.Functions.TriggerCallback('framework-banktruck:server:rewards', function()
                                    end)  
                                    Citizen.Wait(6500)
                                end
                            end)
                        end
                    end
                end
            else
                if ShowingInteraction then
                    exports['fw-ui']:HideInteraction()
                    ShowingInteraction = false
                end
            end
        end
    end)
end