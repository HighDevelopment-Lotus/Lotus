local AppartmentData, OffSets, ShowingInteraction = nil, nil, false
local LSCore, LoggedIn, IsInAppartment, UsingDoor = exports['fw-base']:GetCoreObject(), false, false, false

RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(450, function()  
        LoggedIn = true
    end)
end)

RegisterNetEvent('LSCore:Client:OnPlayerUnload')
AddEventHandler('LSCore:Client:OnPlayerUnload', function()
    exports['fw-ui']:HideInteraction()
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
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            if not IsInAppartment then
                local Distance = #(PlayerCoords - Config.Locations[1]['Coords'])
                if Distance < 1.5 then
                    NearAnything = true
                    if not ShowingInteraction then
                        ShowingInteraction = true
                        exports['fw-ui']:ShowInteraction('[E] Appartement', 'primary')
                    end
                    if IsControlJustReleased(0, 38) then
                        TriggerEvent('framework-appartments:client:enter:appartment', false)
                    end
                end
            else
                if OffSets ~= nil then
                    local Distance = #(PlayerCoords - vector3(Config.Locations[1]['Coords'].x - OffSets.exit.x, Config.Locations[1]['Coords'].y - OffSets.exit.y, Config.Locations[1]['Coords'].z - OffSets.exit.z))
                    if Distance < 1.3 then
                        NearAnything = true
                        if not ShowingInteraction then
                            ShowingInteraction = true
                            exports['fw-ui']:ShowInteraction('[E] Verlaten', 'primary')
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
                            exports['fw-ui']:ShowInteraction('[E] Stash', 'primary')
                        end
                        if IsControlJustReleased(0, 38) then
                            if exports['fw-inv']:CanOpenInventory() then
                                TriggerServerEvent('framework-inv:server:open:inventory:other', LSCore.Functions.GetPlayerData().metadata['appartment-id'], 'Stash', 30, 700000)
                                TriggerEvent("framework-sound:client:play", "stash-open", 0.6)
                            end
                        end
                    end
                    local Distance = #(PlayerCoords - vector3(Config.Locations[1]['Coords'].x - OffSets.closet.x, Config.Locations[1]['Coords'].y - OffSets.closet.y, Config.Locations[1]['Coords'].z - OffSets.closet.z))
                    if Distance < 1.3 then
                        NearAnything = true
                        if not ShowingInteraction then
                            ShowingInteraction = true
                            exports['fw-ui']:ShowInteraction('[E] Kledingkast', 'primary')
                        end
                        if IsControlJustReleased(0, 38) then
                            TriggerEvent('framework-clothing:client:openOutfitMenu')
                            --  TriggerEvent('fivem-appearance:outfitsMenu')
                        end
                    end
                    local Distance = #(PlayerCoords - vector3(Config.Locations[1]['Coords'].x - OffSets.logout.x, Config.Locations[1]['Coords'].y - OffSets.logout.y, Config.Locations[1]['Coords'].z - OffSets.logout.z))
                    if Distance < 1.3 then
                        NearAnything = true
                        if not ShowingInteraction then
                            ShowingInteraction = true
                            exports['fw-ui']:ShowInteraction('[E] Slapen', 'primary')
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
                    exports['fw-ui']:HideInteraction()
                end
                Citizen.Wait(500)
            end
        else
            Citizen.Wait(500)
        end
    end
end)

-- // Events \\ --

RegisterNetEvent('framework-appartments:client:enter:appartment')
AddEventHandler('framework-appartments:client:enter:appartment', function(IsNew)
    if IsNew then
        Citizen.SetTimeout(450, function()
            local Appartment = {}
            local CoordsTable = {x = Config.Locations[1]['Coords'].x, y = Config.Locations[1]['Coords'].y, z = Config.Locations[1]['Coords'].z - 35.0}
            TriggerEvent("framework-sound:client:play", "house-door-open", 0.7)
            Citizen.Wait(350)
            CurrentAppartment = AppartmentName
            Appartment = exports['fw-interiors']:CreateAppartement(CoordsTable)
            NetworkSetEntityInvisibleToNetwork(PlayerPedId(), true)
            SetEntityHealth(PlayerPedId(), 200.0)
            SetEntityNoCollisionEntity(PlayerPedId(), PlayerPedId(), true)
            exports['fw-weathersync']:SetClientSync(false)
            TriggerEvent("framework-sound:client:play", "house-door-close", 0.1)
            IsInAppartment = true
            AppartmentData, OffSets = Appartment[1], Appartment[2]
            Citizen.Wait(500)
           TriggerEvent('framework-clothing:client:CreateFirstCharacter', IsNew)
        --    TriggerEvent('fivem-appearance:client:CreateFirstCharacter')
        end)
    else
        if not UsingDoor then
            UsingDoor = true
            local Appartment = {}
            local CoordsTable = {x = Config.Locations[1]['Coords'].x, y = Config.Locations[1]['Coords'].y, z = Config.Locations[1]['Coords'].z - 35.0}
            TriggerEvent("framework-sound:client:play", "house-door-open", 0.7)
            OpenDoorAnim()
            Citizen.Wait(350)
            Appartment = exports['fw-interiors']:CreateAppartement(CoordsTable)
            NetworkSetEntityInvisibleToNetwork(PlayerPedId(), true)
            SetEntityNoCollisionEntity(PlayerPedId(), PlayerPedId(), true)
            exports['fw-weathersync']:SetClientSync(false)
            TriggerEvent("framework-sound:client:play", "house-door-close", 0.1)
            IsInAppartment = true
            AppartmentData, OffSets = Appartment[1], Appartment[2]
            UsingDoor = false
        end
    end
end)

RegisterNetEvent('framework-appartments:client:open:appartment:stash')
AddEventHandler('framework-appartments:client:open:appartment:stash', function(AppartmentId)
    if AppartmentId ~= nil then
        if exports['fw-inv']:CanOpenInventory() then
            TriggerServerEvent('framework-inv:server:open:inventory:other', AppartmentId, 'Stash', 30, 700000)
        end
    end
end)

-- // Functions \\ --

function LeaveAppartment()
    TriggerEvent("framework-sound:client:play", "house-door-open", 0.7)
    OpenDoorAnim()
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
    exports['fw-interiors']:DespawnInterior(AppartmentData, function()
        NetworkSetEntityVisibleToNetwork(PlayerPedId(), true)
        SetEntityNoCollisionEntity(PlayerPedId(), PlayerPedId(), false)
        SetEntityCoords(PlayerPedId(), Config.Locations[1]['Coords'])
        exports['fw-weathersync']:SetClientSync(true)
        Citizen.Wait(1000)
        Other = nil
        IsInAppartment = false
        IsNearAppartment = false
        CurrentAppartment = nil
        AppartmentData, OffSets = nil, nil
        DoScreenFadeIn(1000)
        TriggerEvent("framework-sound:client:play", "house-door-close", 0.1)
    end)
end

function LogoutPlayer()
    TriggerEvent("framework-sound:client:play", "house-door-open", 0.7)
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
    exports['fw-interiors']:DespawnInterior(AppartmentData, function()
        NetworkSetEntityVisibleToNetwork(PlayerPedId(), true)
        SetEntityNoCollisionEntity(PlayerPedId(), PlayerPedId(), false)
        SetEntityCoords(PlayerPedId(), Config.Locations[1]['Coords'])
        exports['fw-weathersync']:SetClientSync(true)
        Citizen.Wait(1000)
        Other = nil
        IsInAppartment = false
        CurrentAppartment = nil
        AppartmentData, OffSets = nil, nil
        TriggerEvent("framework-sound:client:play", "house-door-close", 0.1)
        Citizen.Wait(450)
        TriggerServerEvent('framework-appartments:server:logout')
    end)
end

function OpenDoorAnim()
    exports['fw-assets']:RequestAnimationDict('anim@heists@keycard@')
    TaskPlayAnim( PlayerPedId(), "anim@heists@keycard@", "exit", 5.0, 1.0, -1, 16, 0, 0, 0, 0 )
    Citizen.Wait(400)
    ClearPedTasks(PlayerPedId())
end