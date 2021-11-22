local AppartmentData, OffSets, ShowingInteraction = nil, nil, false
local LSCore, LoggedIn, IsInAppartment, UsingDoor = exports['ls-core']:GetCoreObject(), false, false, false

RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(450, function()  
        LoggedIn = true
    end)
end)

RegisterNetEvent('LSCore:Client:OnPlayerUnload')
AddEventHandler('LSCore:Client:OnPlayerUnload', function()
    exports['ls-ui']:HideInteraction()
    ShowingInteraction = false
    LoggedIn = false
end)

-- Citizen.CreateThread(function()
--     Citizen.SetTimeout(1, function()
--         TriggerEvent("LSCore:GetObject", function(obj) LSCore = obj end)    
--         Citizen.Wait(150)
--         LoggedIn = true
--     end)
-- end)

-- Code

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            local NearAnything = false
            local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
            if not IsInAppartment then
                local Distance = #(PlayerCoords - Config.Locations[1]['Coords'])
                if Distance < 1.5 then
                    NearAnything = true
                    if not ShowingInteraction then
                        ShowingInteraction = true
                        exports['ls-ui']:ShowInteraction('[E] Appartement', 'primary')
                    end
                    if IsControlJustReleased(0, 38) then
                        TriggerEvent('ls-appartments:client:enter:appartment', false)
                    end
                end
            else
                if OffSets ~= nil then
                    local Distance = #(PlayerCoords - vector3(Config.Locations[1]['Coords'].x - OffSets.exit.x, Config.Locations[1]['Coords'].y - OffSets.exit.y, Config.Locations[1]['Coords'].z - OffSets.exit.z))
                    if Distance < 1.3 then
                        NearAnything = true
                        if not ShowingInteraction then
                            ShowingInteraction = true
                            exports['ls-ui']:ShowInteraction('[E] Verlaten', 'primary')
                        end
                        if IsControlJustReleased(0, 38) then
                            LeaveAppartment()
                        end
                    end
                    local Distance = #(PlayerCoords - vector3(Config.Locations[1]['Coords'].x - OffSets.stash.x, Config.Locations[1]['Coords'].y - OffSets.stash.y, Config.Locations[1]['Coords'].z - OffSets.stash.z))
                    if Distance < 1.3 then
                        NearAnything = true
                        if not ShowingInteraction then
                            ShowingInteraction = true
                            exports['ls-ui']:ShowInteraction('[E] Stash', 'primary')
                        end
                        if IsControlJustReleased(0, 38) then
                            if exports['ls-inventory-new']:CanOpenInventory() then
                                TriggerServerEvent('ls-inventory-new:server:open:inventory:other', LSCore.Functions.GetPlayerData().metadata['appartment-id'], 'Stash', 30, 700000)
                                TriggerEvent("ls-sound:client:play", "stash-open", 0.6)
                            end
                        end
                    end
                    local Distance = #(PlayerCoords - vector3(Config.Locations[1]['Coords'].x - OffSets.closet.x, Config.Locations[1]['Coords'].y - OffSets.closet.y, Config.Locations[1]['Coords'].z - OffSets.closet.z))
                    if Distance < 1.3 then
                        NearAnything = true
                        if not ShowingInteraction then
                            ShowingInteraction = true
                            exports['ls-ui']:ShowInteraction('[E] Kledingkast', 'primary')
                        end
                        if IsControlJustReleased(0, 38) then
                            TriggerEvent('ls-clothing:client:openOutfitMenu')
                        end
                    end
                    local Distance = #(PlayerCoords - vector3(Config.Locations[1]['Coords'].x - OffSets.logout.x, Config.Locations[1]['Coords'].y - OffSets.logout.y, Config.Locations[1]['Coords'].z - OffSets.logout.z))
                    if Distance < 1.3 then
                        NearAnything = true
                        if not ShowingInteraction then
                            ShowingInteraction = true
                            exports['ls-ui']:ShowInteraction('[E] Slapen', 'primary')
                        end
                        if IsControlJustReleased(0, 38) then
                            LogoutPlayer()
                        end
                    end
                end
            end
            if not NearAnything then
                if ShowingInteraction then
                    ShowingInteraction = false
                    exports['ls-ui']:HideInteraction()
                end
                Citizen.Wait(500)
            end
        else
            Citizen.Wait(500)
        end
    end
end)

-- // Events \\ --

RegisterNetEvent('ls-appartments:client:enter:appartment')
AddEventHandler('ls-appartments:client:enter:appartment', function(IsNew)
    if IsNew then
        Citizen.SetTimeout(450, function()
            local Appartment = {}
            local CoordsTable = {x = Config.Locations[1]['Coords'].x, y = Config.Locations[1]['Coords'].y, z = Config.Locations[1]['Coords'].z - 35.0}
            TriggerEvent("ls-sound:client:play", "house-door-open", 0.7)
            Citizen.Wait(350)
            CurrentAppartment = AppartmentName
            Appartment = exports['ls-interiors']:CreateAppartement(CoordsTable)
            NetworkSetEntityInvisibleToNetwork(PlayerPedId(), true)
            SetEntityHealth(PlayerPedId(), 200.0)
            SetEntityNoCollisionEntity(GetPlayerPed(-1), GetPlayerPed(-1), true)
            exports['ls-weathersync']:SetClientSync(false)
            TriggerEvent("ls-sound:client:play", "house-door-close", 0.1)
            IsInAppartment = true
            AppartmentData, OffSets = Appartment[1], Appartment[2]
            Citizen.Wait(500)
            TriggerEvent('ls-clothing:client:CreateFirstCharacter')
        end)
    else
        if not UsingDoor then
            UsingDoor = true
            local Appartment = {}
            local CoordsTable = {x = Config.Locations[1]['Coords'].x, y = Config.Locations[1]['Coords'].y, z = Config.Locations[1]['Coords'].z - 35.0}
            TriggerEvent("ls-sound:client:play", "house-door-open", 0.7)
            OpenDoorAnim()
            Citizen.Wait(350)
            Appartment = exports['ls-interiors']:CreateAppartement(CoordsTable)
            NetworkSetEntityInvisibleToNetwork(PlayerPedId(), true)
            SetEntityNoCollisionEntity(GetPlayerPed(-1), GetPlayerPed(-1), true)
            exports['ls-weathersync']:SetClientSync(false)
            TriggerEvent("ls-sound:client:play", "house-door-close", 0.1)
            IsInAppartment = true
            AppartmentData, OffSets = Appartment[1], Appartment[2]
            UsingDoor = false
        end
    end
end)

RegisterNetEvent('ls-appartments:client:open:appartment:stash')
AddEventHandler('ls-appartments:client:open:appartment:stash', function(AppartmentId)
    if AppartmentId ~= nil then
        if exports['ls-inventory-new']:CanOpenInventory() then
            TriggerServerEvent('ls-inventory-new:server:open:inventory:other', AppartmentId, 'Stash', 30, 700000)
        end
    end
end)

-- // Functions \\ --

function LeaveAppartment()
    TriggerEvent("ls-sound:client:play", "house-door-open", 0.7)
    OpenDoorAnim()
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
    exports['ls-interiors']:DespawnInterior(AppartmentData, function()
        NetworkSetEntityVisibleToNetwork(PlayerPedId(), true)
        SetEntityNoCollisionEntity(GetPlayerPed(-1), GetPlayerPed(-1), false)
        SetEntityCoords(GetPlayerPed(-1), Config.Locations[1]['Coords'])
        exports['ls-weathersync']:SetClientSync(true)
        Citizen.Wait(1000)
        Other = nil
        IsInAppartment = false
        IsNearAppartment = false
        CurrentAppartment = nil
        AppartmentData, OffSets = nil, nil
        DoScreenFadeIn(1000)
        TriggerEvent("ls-sound:client:play", "house-door-close", 0.1)
    end)
end

function LogoutPlayer()
    TriggerEvent("ls-sound:client:play", "house-door-open", 0.7)
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
    exports['ls-interiors']:DespawnInterior(AppartmentData, function()
        NetworkSetEntityVisibleToNetwork(PlayerPedId(), true)
        SetEntityNoCollisionEntity(GetPlayerPed(-1), GetPlayerPed(-1), false)
        SetEntityCoords(GetPlayerPed(-1), Config.Locations[1]['Coords'])
        exports['ls-weathersync']:SetClientSync(true)
        Citizen.Wait(1000)
        Other = nil
        IsInAppartment = false
        CurrentAppartment = nil
        AppartmentData, OffSets = nil, nil
        TriggerEvent("ls-sound:client:play", "house-door-close", 0.1)
        Citizen.Wait(450)
        TriggerServerEvent('ls-appartments:server:logout')
    end)
end

function OpenDoorAnim()
    exports['ls-assets']:RequestAnimationDict('anim@heists@keycard@')
    TaskPlayAnim( GetPlayerPed(-1), "anim@heists@keycard@", "exit", 5.0, 1.0, -1, 16, 0, 0, 0, 0 )
    Citizen.Wait(400)
    ClearPedTasks(GetPlayerPed(-1))
end