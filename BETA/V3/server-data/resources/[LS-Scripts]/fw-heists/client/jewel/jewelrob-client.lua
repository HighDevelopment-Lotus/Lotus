local CurrentVitrine, ShowingInteraction, InsideJewerlley = nil, false, false
local CurrentVent, CurrentJewelObjects = nil, {}
-- Code

-- // Loops \\ --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            local Distance = #(PlayerCoords - vector3(-622.10, -230.744, 38.05))
            if Distance < 10.5 then
                if not InsideJewerlley then
                    InsideJewerlley = true
                    SetupJewelProps()
                end
            else
                if InsideJewerlley then
                    InsideJewerlley = false
                    RemoveJewelProps()
                end
            end
            Citizen.Wait(500)
        end
    end  
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            local NearAnything = false
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            for k, v in pairs(Config.Vitrines) do
                local Distance = #(PlayerCoords - v['Coords'])
                if Distance < 0.65 and not v['Robbed'] and not v['Busy'] and not Config.JewelAlarmOn then
                    NearAnything = true
                    CurrentVitrine = k
                    if not ShowingInteraction then
                        ShowingInteraction = true
                        exports['fw-ui']:ShowInteraction('[<i class="far fa-eye"></i>] Vitrine', 'primary')
                    end
                end
            end
            for k, v in pairs(Config.JewelHack) do
                local Distance = #(PlayerCoords - v['Coords'])
                if Distance < 2.7 and not v['HackDone'] then
                    NearAnything = true
                    CurrentVent = k
                    if not ShowingInteraction then
                        ShowingInteraction = true
                        exports['fw-ui']:ShowInteraction('[<i class="far fa-eye"></i>] Juwelier Ventilator', 'primary')
                    end
                end
            end
            if not NearAnything then
                CurrentVitrine, CurrentVent = nil, nil
                if ShowingInteraction then
                    ShowingInteraction = false
                    exports['fw-ui']:HideInteraction()
                end
                Citizen.Wait(1100)
            end
        end
    end
end)

-- // Events \\ --

RegisterNetEvent('framework-heists:client:jewel:hack:doors')
AddEventHandler('framework-heists:client:jewel:hack:doors', function()
    if CurrentVent ~= nil then
        if CurrentCops >= Config.CopsNeeded then
            if not Config.JewelHack[CurrentVent]['HackDone'] then
                LSCore.Functions.TriggerCallback('framework-heists:has:jewerlley:items', function(ReturnValue) 
                    if ReturnValue then 
                        exports['fw-ui']:StartBlocksGame(function(Outcome)
                            if Outcome then
                                TriggerServerEvent('framework-heists:server:set:doors:data', CurrentVent, true)
                            else
                                if math.random(1, 15) < 6 then
                                    LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, 'electronickit', 1, false)
                                    LSCore.Functions.Notify('Oef je electronische kit is door gebrand..', 'error')
                                end
                                LSCore.Functions.Notify('Je faalde..', 'error')
                            end
                        end)
                    end
                end)      
            end
        end
    end
end)

RegisterNetEvent('framework-heists:client:grab:jewels')
AddEventHandler('framework-heists:client:grab:jewels', function()
    local Smashing, SavedId = false, CurrentVitrine
    if CurrentVitrine ~= nil and CurrentCops >= Config.CopsNeeded then
        if HasValidWeapon() then
            Smashing = true
            TriggerServerEvent('framework-jewellery:server:set:jewellery:data', SavedId, 'Busy', true)
            if math.random(1, 100) <= 65 and not IsWearingHandshoes() then
                TriggerServerEvent("framework-police:server:create:evidence", 'Finger', GetEntityCoords(PlayerPedId()))
            end
            LSCore.Functions.Progressbar("smash_vitrine", "Vitrine Inslaan..", 15000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function() -- Done
                Smashing = false
                LSCore.Functions.TriggerCallback('framework-jewellery:vitrine:reward', function()
                end)
                TriggerServerEvent('framework-jewellery:server:set:jewellery:data', SavedId, 'Robbed', true)
                TriggerServerEvent('framework-jewellery:server:set:jewellery:data', SavedId, 'Busy', false)
                StopAnimTask(PlayerPedId(), "missheist_jewel", "smash_case", 1.0)
            end, function() -- Cancel
                Smashing = false
                TriggerServerEvent('framework-jewellery:server:set:jewellery:data', SavedId, 'Busy', false)
                StopAnimTask(PlayerPedId(), "missheist_jewel", "smash_case", 1.0)
            end)
            while Smashing do
                exports['fw-assets']:RequestAnimationDict("missheist_jewel")
                TaskPlayAnim(PlayerPedId(), "missheist_jewel", "smash_case", 3.0, 3.0, -1, 2, 0, 0, 0, 0 )
                Citizen.Wait(500)
                TriggerEvent("framework-sound:client:play", "jewellery-glass", 0.25)
                TriggerServerEvent('framework-ui:server:gain:stress', math.random(1, 3))
                Citizen.Wait(2500)
            end
        else
            LSCore.Functions.Notify('Dit glas is wel erg sterk..', 'error')
        end
    end
end)

RegisterNetEvent('framework-jewellery:client:disable:alarm')
AddEventHandler('framework-jewellery:client:disable:alarm', function()
        exports['minigame-phone']:ShowHack()
        exports['minigame-phone']:StartHack(math.random(1,2), math.random(9, 13), function(Success)
        if Success then
            exports['minigame-phone']:HideHack()
            Wait(250)
            exports['minigame-shape']:StartShapeGame(function(Outcome)
                if Outcome then
                TriggerServerEvent('framework-jewellery:server:set:alarm', false)
                end
            end)
        else
            exports['minigame-phone']:HideHack()
        end
    end)
end)

RegisterNetEvent('framework-jewellery:client:sync:jewellery')
AddEventHandler('framework-jewellery:client:sync:jewellery', function(ConfigData)
    Config.Vitrines = ConfigData
end)

RegisterNetEvent('framework-jewellery:client:sync:jewellery:doors')
AddEventHandler('framework-jewellery:client:sync:jewellery:doors', function(ConfigData)
    Config.JewelHack = ConfigData
end)

RegisterNetEvent('framework-jewellery:client:sync:jewellery:alarm')
AddEventHandler('framework-jewellery:client:sync:jewellery:alarm', function(ConfigData)
    Config.JewelAlarmOn = ConfigData
end)

-- // Functions \\ --

function SetupJewelProps()
    for k, v in pairs(Config.JewelProps) do
        exports['fw-assets']:RequestModelHash(v['Prop'])
        JewelObjects = CreateObject(GetHashKey(v['Prop']), v["Coords"], false, true, false)
        SetEntityHeading(JewelObjects, v['Heading'])
        if v['PutOnTheGround'] then
            PlaceObjectOnGroundProperly(JewelObjects)
        end
        SetEntityVisible(JewelObjects, false)
        FreezeEntityPosition(JewelObjects, true)
        SetEntityInvincible(JewelObjects, true)
        table.insert(CurrentJewelObjects, JewelObjects)
    end
end

function RemoveJewelProps()
    for k, v in pairs(CurrentJewelObjects) do 
        NetworkRequestControlOfEntity(v)
        DeleteEntity(v)
    end
end

function HasValidWeapon()
    local CurrentWeapon = GetSelectedPedWeapon(PlayerPedId())
    for k, v in pairs(Config.VitrineWeapons) do
        if CurrentWeapon == v then
           return true
        end
    end
end

function IsNearVent()
    if CurrentVent ~= nil then
        return true
    end
end

function CanRobVitrine()
    if CurrentVitrine ~= nil and not Config.JewelAlarmOn then
        return true
    end
end

function CanDisableAlarm()
    if Config.JewelAlarmOn then
        return true
    end
end

function IsInsideJewel()
    return InsideJewerlley
end