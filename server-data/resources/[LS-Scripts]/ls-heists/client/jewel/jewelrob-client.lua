local CurrentVitrine, ShowingInteraction, InsideJewerlley = nil, false, false
local CurrentVent, CurrentJewelObjects = nil, {}
-- Code

-- // Loops \\ --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
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
            local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
            for k, v in pairs(Config.Vitrines) do
                local Distance = #(PlayerCoords - v['Coords'])
                if Distance < 0.65 and not v['Robbed'] and not v['Busy'] and not Config.JewelAlarmOn then
                    NearAnything = true
                    CurrentVitrine = k
                    if not ShowingInteraction then
                        ShowingInteraction = true
                        exports['ls-ui']:ShowInteraction('[<i class="far fa-eye"></i>] Vitrine', 'primary')
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
                        exports['ls-ui']:ShowInteraction('[<i class="far fa-eye"></i>] Juwelier Ventilator', 'primary')
                    end
                end
            end
            if not NearAnything then
                CurrentVitrine, CurrentVent = nil, nil
                if ShowingInteraction then
                    ShowingInteraction = false
                    exports['ls-ui']:HideInteraction()
                end
                Citizen.Wait(1100)
            end
        end
    end
end)

-- // Events \\ --

RegisterNetEvent('ls-heists:client:jewel:hack:doors')
AddEventHandler('ls-heists:client:jewel:hack:doors', function()
    if CurrentVent ~= nil then
        if CurrentCops >= Config.CopsNeeded then
            if not Config.JewelHack[CurrentVent]['HackDone'] then
                LSCore.Functions.TriggerCallback('ls-heists:has:jewerlley:items', function(ReturnValue) 
                    if ReturnValue then 
                        exports['ls-ui']:StartBlocksGame(function(Outcome)
                            if Outcome then
                                TriggerServerEvent('ls-heists:server:set:doors:data', CurrentVent, true)
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

RegisterNetEvent('ls-heists:client:grab:jewels')
AddEventHandler('ls-heists:client:grab:jewels', function()
    local Smashing, SavedId = false, CurrentVitrine
    if CurrentVitrine ~= nil and CurrentCops >= Config.CopsNeeded then
        if HasValidWeapon() then
            Smashing = true
            TriggerServerEvent('ls-jewellery:server:set:jewellery:data', SavedId, 'Busy', true)
            if math.random(1, 100) <= 65 and not IsWearingHandshoes() then
                TriggerServerEvent("ls-police:server:create:evidence", 'Finger', GetEntityCoords(GetPlayerPed(-1)))
            end
            LSCore.Functions.Progressbar("smash_vitrine", "Vitrine Inslaan..", 15000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function() -- Done
                Smashing = false
                TriggerServerEvent('ls-jewellery:vitrine:reward')
                TriggerServerEvent('ls-jewellery:server:set:jewellery:data', SavedId, 'Robbed', true)
                TriggerServerEvent('ls-jewellery:server:set:jewellery:data', SavedId, 'Busy', false)
                StopAnimTask(GetPlayerPed(-1), "missheist_jewel", "smash_case", 1.0)
            end, function() -- Cancel
                Smashing = false
                TriggerServerEvent('ls-jewellery:server:set:jewellery:data', SavedId, 'Busy', false)
                StopAnimTask(GetPlayerPed(-1), "missheist_jewel", "smash_case", 1.0)
            end)
            while Smashing do
                exports['ls-assets']:RequestAnimationDict("missheist_jewel")
                TaskPlayAnim(GetPlayerPed(-1), "missheist_jewel", "smash_case", 3.0, 3.0, -1, 2, 0, 0, 0, 0 )
                Citizen.Wait(500)
                TriggerEvent("ls-sound:client:play", "jewellery-glass", 0.25)
                TriggerServerEvent('ls-ui:server:gain:stress', math.random(1, 3))
                Citizen.Wait(2500)
            end
        else
            LSCore.Functions.Notify('Dit glas is wel erg sterk..', 'error')
        end
    end
end)

RegisterNetEvent('ls-jewellery:client:disable:alarm')
AddEventHandler('ls-jewellery:client:disable:alarm', function()
    exports['minigame-shape']:StartShapeGame(function(Outcome)
        if Outcome then
            TriggerServerEvent('ls-jewellery:server:set:alarm', false)
        end
    end)
end)

RegisterNetEvent('ls-jewellery:client:sync:jewellery')
AddEventHandler('ls-jewellery:client:sync:jewellery', function(ConfigData)
    Config.Vitrines = ConfigData
end)

RegisterNetEvent('ls-jewellery:client:sync:jewellery:doors')
AddEventHandler('ls-jewellery:client:sync:jewellery:doors', function(ConfigData)
    Config.JewelHack = ConfigData
end)

RegisterNetEvent('ls-jewellery:client:sync:jewellery:alarm')
AddEventHandler('ls-jewellery:client:sync:jewellery:alarm', function(ConfigData)
    Config.JewelAlarmOn = ConfigData
end)

-- // Functions \\ --

function SetupJewelProps()
    for k, v in pairs(Config.JewelProps) do
        exports['ls-assets']:RequestModelHash(v['Prop'])
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
    local CurrentWeapon = GetSelectedPedWeapon(GetPlayerPed(-1))
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