local NearPaintball, CurrentPaintball = false, nil
local PaintballObjects, IsInside, ShowingInteraction, SecondInteraction = {}, false, false, false

LSCore, LoggedIn = exports['fw-base']:GetCoreObject(), false

RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1250, function()
        LoggedIn = true
    end)
end)

RegisterNetEvent('LSCore:Client:OnPlayerUnload')
AddEventHandler('LSCore:Client:OnPlayerUnload', function()
    LoggedIn = false
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
         local PlayerCoords = GetEntityCoords(PlayerPedId())
         NearPaintball = false
         for k, v in pairs(Config.PaintballLocations) do 
             local Area = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['X'], v['Y'], v['Z'], true)
             if Area < 7.5 then
                CurrentPaintball = k
                NearPaintball = true
             end
         end
         if not NearPaintball then
            Citizen.Wait(2500)
            CurrentPaintball = false
         end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            NearAnything = false
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            local Distance = #(PlayerCoords - Config.Paintball['Outside'])
            if not IsInside and Distance <= 5.0 then
                NearAnything = true
                if not ShowingInteraction then
                    ShowingInteraction = true
                    exports['fw-ui']:ShowInteraction('[E] Enter Paintball', 'primary')
                end
                if IsControlJustReleased(0, 38) then
                    TriggerEvent('framework-paintball:client:enter:paintball', PlayerCoords)
                end
            end
            local Distance = #(PlayerCoords - Config.Paintball['Inside'])
            if IsInside and Distance <= 5.0 then
                NearAnything = true
                if not ShowingInteraction then
                    ShowingInteraction = true
                    exports['fw-ui']:ShowInteraction('[E] Stop Paintball', 'primary')
                end
                if IsControlJustReleased(0, 38) then
                    TriggerEvent('framework-paintball:client:leave:paintball', PlayerCoords)
                    RemovePropFromHands()
                end
            end
            if not NearAnything then
                if ShowingInteraction then
                    ShowingInteraction = false
                    exports['fw-ui']:HideInteraction()
                end
                Citizen.Wait(1000)
            end
        else
            Citizen.Wait(1000)
        end
    end
end)

RegisterNetEvent('framework-paintball:client:enter:paintball')
AddEventHandler('framework-paintball:client:enter:paintball', function(PlayerCoords)
    TriggerServerEvent("framework-paintball:server:recieve:gun")
    DoScreenFadeOut(250)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
    SetEntityVisible(PlayerPedId(), false)
    SetEntityCoords(PlayerPedId(), PlayerCoords.x, PlayerCoords.y, PlayerCoords.z - 10.0)
    Citizen.Wait(5500)
    SetEntityCoords(PlayerPedId(), Config.Paintball['Inside'])
    SetEntityVisible(PlayerPedId(), true)
    DoScreenFadeIn(250)
    IsInside = true
end)
RegisterNetEvent('framework-paintball:client:removegun')
AddEventHandler('framework-paintball:client:removegun', function(wapenprop)

end)
RegisterNetEvent('framework-paintball:client:leave:paintball')
AddEventHandler('framework-paintball:client:leave:paintball', function(PlayerCoords)
    IsInside = false
    TriggerServerEvent("framework-paintball:server:remove:gun")
    Citizen.SetTimeout(350, function()
        SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
        RemoveAllPedWeapons(PlayerPedId(), true)
        TriggerEvent('framework-weapons:client:set:current:weapon', nil)
        CurrentWeapon = nil
    end)
    DeleteObject(Obj)
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
    SetEntityVisible(PlayerPedId(), false)
    SetEntityCoords(PlayerPedId(), PlayerCoords.x, PlayerCoords.y, PlayerCoords.z + 10.0)
    Citizen.Wait(250)
    SetEntityCoords(PlayerPedId(), Config.Paintball['Outside'])
    SetEntityVisible(PlayerPedId(), true)
    DoScreenFadeIn(250)
end)

function RemovePropFromHands()
    HasItem = false
    exports['fw-assets']:RemoveProp()
    StopAnimTask(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 1.0)
end
