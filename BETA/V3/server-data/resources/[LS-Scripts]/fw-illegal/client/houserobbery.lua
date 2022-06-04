local LSCore, LoggedIn, RemoveHouseData = exports['fw-base']:GetCoreObject(), false, false
local NeededItems, Showing = {}, false
local ShowingInteraction, CurrentCops = false, 0
local HouseData, OffSets, InsideHouse = nil, nil, false
local DoingJob, JobHouseId, NearAnything, PlayerJob = false, nil, false, {}

-- Code

RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1250, function()
        local LockpickData = exports['fw-inv']:GetItemData('lockpick')
        local ToolkitData = exports['fw-inv']:GetItemData('screwdriverset')
        NeededItems = {[1] = {['Label'] = LockpickData['label'], ['Image'] = LockpickData["image"]}, [2] = {['Label'] = ToolkitData["label"], ['Image'] = ToolkitData["image"]}}
        PlayerJob = LSCore.Functions.GetPlayerData().job
        LoggedIn = true
    end)
end)

RegisterNetEvent('LSCore:Client:OnPlayerUnload')
AddEventHandler('LSCore:Client:OnPlayerUnload', function()
    LoggedIn = false
end)

RegisterNetEvent('framework-police:SetCopCount')
AddEventHandler('framework-police:SetCopCount', function(Amount)
    CurrentCops = Amount
end)

RegisterNetEvent('LSCore:Client:OnJobUpdate')
AddEventHandler('LSCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

RegisterNetEvent('LSCore:Client:SetDuty')
AddEventHandler('LSCore:Client:SetDuty', function()
    PlayerJob = LSCore.Functions.GetPlayerData().job
end)

-- Citizen.CreateThread(function()
--     Citizen.SetTimeout(1, function()
--         TriggerEvent("LSCore:GetObject", function(obj) LSCore = obj end)    
--         Citizen.Wait(250)
--         local LockpickData = exports['fw-inv']:GetItemData('lockpick')
--         local ToolkitData = exports['fw-inv']:GetItemData('lockpick')
--         NeededItems = {[1] = {['Label'] = LockpickData['label'], ['Image'] = LockpickData["image"]}, [2] = {['Label'] = ToolkitData["label"], ['Image'] = ToolkitData["image"]}}
--         PlayerJob = LSCore.Functions.GetPlayerData().job
--         LoggedIn = true
--     end)
-- end)

-- Code

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            if PlayerJob.name == 'police' then
                local NearAnytingP = false
                local PlayerCoords = GetEntityCoords(PlayerPedId())
                for k, v in pairs(Config.Houses) do
                    if InsideHouse and JobHouseId ~= nil and OffSets ~= nil then
                        local Distance = #(PlayerCoords - vector3(Config.Houses[JobHouseId]['Coords'].x - OffSets.exit.x, Config.Houses[JobHouseId]['Coords'].y - OffSets.exit.y, Config.Houses[JobHouseId]['Coords'].z - Config.Houses[JobHouseId]['ZOffset']))
                        if Distance < 2.0 then
                            NearAnytingP = true
                            if not ShowingInteraction then
                                ShowingInteraction = true
                                exports['fw-ui']:ShowInteraction('[E] Verlaten', 'primary')
                            end
                            if IsControlJustReleased(0, 38) then
                                LeaveHouseRob(JobHouseId)
                            end
                        end
                    else
                        -- if v['Busy'] then
                            local Distance = #(PlayerCoords - v['Coords'])
                            if Distance < 1.0 then
                                NearAnytingP = true
                                JobHouseId = k
                                if not ShowingInteraction then
                                    ShowingInteraction = true
                                    exports['fw-ui']:ShowInteraction('[E] Naar Binnen', 'primary')
                                end
                                if IsControlJustReleased(0, 38) then
                                    if JobHouseId ~= nil then
                                        EnterHouseRob()
                                    end
                                end
                            end
                        -- end
                    end
                end
                if not NearAnytingP then
                    if ShowingInteraction then
                        ShowingInteraction = false
                        exports['fw-ui']:HideInteraction()
                    end
                    if not InsideHouse then
                        JobHouseId = nil
                    end
                    Citizen.Wait(450)
                end
            else
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
            if DoingJob and JobHouseId ~= nil then
                local PlayerCoords = GetEntityCoords(PlayerPedId())
                if InsideHouse then
                    local NearAnythings = false
                    if OffSets ~= nil then
                        local Distance = #(PlayerCoords - vector3(Config.Houses[JobHouseId]['Coords'].x - OffSets.exit.x, Config.Houses[JobHouseId]['Coords'].y - OffSets.exit.y, Config.Houses[JobHouseId]['Coords'].z - Config.Houses[JobHouseId]['ZOffset']))
                        if Distance < 2.0 then
                            NearAnythings = true
                            if not ShowingInteraction then
                                ShowingInteraction = true
                                exports['fw-ui']:ShowInteraction('[E] Verlaten', 'primary')
                            end
                            if IsControlJustReleased(0, 38) then
                                LeaveHouseRob(JobHouseId)
                            end
                        end
                        for k, v in pairs(Config.Houses[JobHouseId]['Cabins']) do
                            local Distance = #(PlayerCoords - vector3(Config.Houses[JobHouseId]['Coords'].x - v['Coords-Offset']['X'], Config.Houses[JobHouseId]['Coords'].y - v['Coords-Offset']['Y'], Config.Houses[JobHouseId]['Coords'].z - v['Coords-Offset']['Z']))
                            if Distance < 1.0 and not v['Busy'] and not v['Open'] then
                                NearAnythings = true
                                if not ShowingInteraction then
                                    ShowingInteraction = true
                                    exports['fw-ui']:ShowInteraction('[E] Zoeken', 'primary')
                                end
                                if IsControlJustReleased(0, 38) then
                                    SearchCabin(JobHouseId, k)
                                end
                            end
                        end
                    end
                    if not NearAnythings then
                        if ShowingInteraction then
                            ShowingInteraction = false
                            exports['fw-ui']:HideInteraction()
                        end
                        Citizen.Wait(450)
                    end
                else
                    NearAnything = false
                    local HouseData = Config.Houses[JobHouseId]
                    local Distance = #(PlayerCoords - HouseData['Coords'])
                    if not HouseData['DoorState'] then
                        if Distance < 1.0  then
                            NearAnything = true
                            if not Showing then
                                Showing = true
                                TriggerEvent('framework-inv:client:set:required', NeededItems, true)
                            end
                        end
                    else
                        if Distance < 1.0 then
                            NearAnything = true
                            -- if HouseData['DoorState'] then
                                if not ShowingInteraction then
                                    ShowingInteraction = true
                                    exports['fw-ui']:ShowInteraction('[E] Naar Binnen', 'primary')
                                end
                                if IsControlJustReleased(0, 38) then
                                    EnterHouseRob()
                                end
                            -- end
                        end
                    end
                    if not NearAnything then
                        if Showing then
                            Showing = false
                            TriggerEvent('framework-inv:client:set:required', NeededItems, false)
                        end
                        if ShowingInteraction then
                            ShowingInteraction = false
                            exports['fw-ui']:HideInteraction()
                        end
                        Citizen.Wait(750)
                    end
                end
            else
                Citizen.Wait(450)
            end
        end
    end
end)

-- // Events \\ --

RegisterNetEvent('framework-items:client:use:lockpick')
AddEventHandler('framework-items:client:use:lockpick', function(Advanced)
    print(JobHouseId)
    if JobHouseId ~= nil and not Config.Houses[JobHouseId]['DoorState'] and NearAnything then
        if not Advanced then
            LSCore.Functions.TriggerCallback('LSCore:HasItem', function(HasItem) 
                if HasItem then
                    TriggerEvent('framework-inv:client:set:required', NeededItems, false)
                    TriggerEvent('framework-assets:client:lockpick:animation', true)
                    if math.random(1, 100) <= 35 and not IsWearingHandshoes() then
                        TriggerServerEvent("framework-police:server:create:evidence", 'Finger', GetEntityCoords(PlayerPedId()))
                    end
                    exports['fw-ui']:StartSkillTest(3, 'Normal', function(Outcome)
                        if Outcome then
                            TriggerServerEvent('framework-houserobbery:server:set:door:state', JobHouseId, true)
                            TriggerEvent('framework-assets:client:lockpick:animation', false)
                        else
                            local RemoveChance = LSCore.Functions.GetMiniGameSkill('Lockpick')
                            if math.random(1, 100) < (RemoveChance + 10) then
                                LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, 'lockpick', 1, false)
                                if math.random(1, 5) < 2 then
                                    TriggerServerEvent("framework-police:server:create:evidence", 'Blood', GetEntityCoords(PlayerPedId()))
                                else
                                    TriggerServerEvent('framework-police:server:send:house:alert', GetEntityCoords(PlayerPedId()), LSCore.Functions.GetStreetLabel())
                                end
                            end
                            TriggerEvent('framework-assets:client:lockpick:animation', false)
                            TriggerEvent('framework-inv:client:set:required', NeededItems, true)
                        end 
                    end)
                end
            end, 'screwdriverset')
        else
            TriggerEvent('framework-inv:client:set:required', NeededItems, false)
            TriggerEvent('framework-assets:client:lockpick:animation', true)
            if math.random(1, 100) <= 35 and not IsWearingHandshoes() then
                TriggerServerEvent("framework-police:server:create:evidence", 'Finger', GetEntityCoords(PlayerPedId()))
            end
            exports['fw-ui']:StartSkillTest(3, 'Normal', function(Outcome)
                if Outcome then
                    TriggerServerEvent('framework-houserobbery:server:set:door:state', JobHouseId, true)
                    TriggerEvent('framework-assets:client:lockpick:animation', false)
                else
                    local RemoveChance = LSCore.Functions.GetMiniGameSkill('Lockpick')
                    if math.random(1, 100) < (RemoveChance - 10) then
                        LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, 'advancedlockpick', 1, false)
                        if math.random(1, 5) < 2 then
                            TriggerServerEvent("framework-police:server:create:evidence", 'Blood', GetEntityCoords(PlayerPedId()))
                        else
                            TriggerServerEvent('framework-police:server:send:house:alert', GetEntityCoords(PlayerPedId()), LSCore.Functions.GetStreetLabel())
                        end
                    end
                    TriggerEvent('framework-assets:client:lockpick:animation', false)
                    TriggerEvent('framework-inv:client:set:required', NeededItems, true)
                end 
            end)
        end
    end
end)

RegisterNetEvent('framework-houseobbery:client:steal:item:tv')
AddEventHandler('framework-houseobbery:client:steal:item:tv', function()
    if not Config.Houses[JobHouseId]['RobbableItems']['Tv'] then
        Config.Houses[JobHouseId]['RobbableItems']['Tv'] = true
        NetworkRequestControlOfEntity(GetHashKey('prop_tv_flat_01'))
        DeleteEntity(GetHashKey('prop_tv_flat_01'))
        -- TriggerServerEvent('framework-houserobbert:server:add:steal:item', 'Tv')
        LSCore.Functions.TriggerCallback('framework-houserobbery:server:add:steal:item', function() end, 'Tv')
    end
end)
RegisterNetEvent('framework-houseobbery:client:steal:item:micro')
AddEventHandler('framework-houseobbery:client:steal:item:micro', function()
    if not Config.Houses[JobHouseId]['RobbableItems']['Micro'] then
        Config.Houses[JobHouseId]['RobbableItems']['Micro'] = true
        NetworkRequestControlOfEntity(GetHashKey('prop_tv_flat_01'))
        DeleteEntity(GetHashKey('prop_tv_flat_01'))
        -- TriggerServerEvent('framework-houserobbert:server:add:steal:item', 'Micro')
        LSCore.Functions.TriggerCallback('framework-houserobbery:server:add:steal:item', function() end, 'Micro')
    end
end)
-- RegisterNetEvent('framework-houseobbery:client:steal:item')
-- AddEventHandler('framework-houseobbery:client:steal:item', function(ItemType, Entity)
--     if LSCore.Functions.GetClosestObject() == GetHashKey('prop_tv_flat_01') then
--         if not Config.Houses[JobHouseId]['RobbableItems']['Tv'] then
--             Config.Houses[JobHouseId]['RobbableItems']['Tv'] = true
--             NetworkRequestControlOfEntity('prop_tv_flat_01')
--             DeleteEntity('prop_tv_flat_01')
--             TriggerServerEvent('framework-houserobbert:server:add:steal:item', 'Tv')
--         end
--     elseif LSCore.Functions.GetClosestObject() == GetHashKey('prop_micro_01') then
--         if not Config.Houses[JobHouseId]['RobbableItems']['Micro'] then
--             Config.Houses[JobHouseId]['RobbableItems']['Micro'] = true
--             NetworkRequestControlOfEntity('prop_micro_01')
--             DeleteEntity('prop_micro_01')
--             TriggerServerEvent('framework-houserobbert:server:add:steal:item', 'Micro')
--         end
--     end
-- end)

RegisterNetEvent('framework-houseobbery:client:next:leave:stop:job')
AddEventHandler('framework-houseobbery:client:next:leave:stop:job', function()
    RemoveHouseData = true
end)

RegisterNetEvent('framework-houserobbery:client:stop:job')
AddEventHandler('framework-houserobbery:client:stop:job', function()
    if InsideHouse then
        LeaveHouseRob(JobHouseId)
        Wait(700)
        exports['fw-ui']:ForceStopSkill()
        TriggerEvent('framework-assets:client:lockpick:animation', false)
        LSCore.Functions.Notify("Je deed er telang over en bent naar buiten gegaan", "error")
    end
    DoingJob, JobHouseId = false, nil
end)

RegisterNetEvent('framework-houserobbery:client:start:job')
AddEventHandler('framework-houserobbery:client:start:job', function()
    if CurrentCops >= Config.CopsNeeded then
        local CurrentHour = exports['fw-weathersync']:GetCurrentTime()
        if CurrentHour >= 0 and CurrentHour <= 6 then
            if not DoingJob then
                local RandomHouse = GetAvailableHouse()
                if RandomHouse ~= nil and RandomHouse ~= false then
                    local MenuItems = {
                        [1] = {
                            ['Title'] = 'Werken (€350)',
                            ['Desc'] = 'Klik om werken',
                            ['Data'] = {['Event'] = 'framework-houserobbery:client:get:random:house', ['Type'] = 'Client'},
                        }
                    }
                    local Data = {['Title'] = 'Jessica', ['MainMenuItems'] = MenuItems}
                    LSCore.Functions.OpenMenu(Data)
                else
                    LSCore.Functions.Notify("Ik heb geen werk voor je op het moment..", "error")
                end
            else
                LSCore.Functions.Notify("Volgensmij werk je al voor mij..", "error")
            end
        else
            LSCore.Functions.Notify("Ik heb geen werk voor je op het moment kom later terug ;)", "error")
        end
    else
        LSCore.Functions.Notify("Nou er zijn niet genoeg agenten..", "error")
    end 
end)

RegisterNetEvent('framework-houserobbery:client:get:random:house')
AddEventHandler('framework-houserobbery:client:get:random:house', function(data)
    if CurrentCops >= Config.CopsNeeded then
        local RandomHouse = GetAvailableHouse()
        if RandomHouse ~= nil and RandomHouse ~= false then
            LSCore.Functions.TriggerCallback('LSCore:RemoveCash', function(DidPay) 
                if DidPay then
                    DoingJob, JobHouseId = true, RandomHouse
                    SetNewWaypoint(Config.Houses[JobHouseId]['Coords'].x, Config.Houses[JobHouseId]['Coords'].y)
                    TriggerServerEvent('framework-houserobbery:server:set:house:busy', RandomHouse, true)
                    LSCore.Functions.Notify("Locatie op de gps gezet!", "success")
                end
            end, 350)
        else
            LSCore.Functions.Notify("Ik heb geen werk voor je op het moment..", "error")
        end
    else
        LSCore.Functions.Notify("Nou er zijn niet genoeg agenten..", "error")
    end
end)

RegisterNetEvent('framework-houserobbery:client:sync:data')
AddEventHandler('framework-houserobbery:client:sync:data', function(HouseNumber, ConfigData)
    Config.Houses[HouseNumber] = ConfigData
end)

-- // Functions \\ --

function EnterHouseRob()
    if JobHouseId ~= nil then
        InsideHouse = true
        ShowingInteraction = false
        exports['fw-ui']:HideInteraction()
        local CoordsTable = {x = Config.Houses[JobHouseId]['Coords'].x, y = Config.Houses[JobHouseId]['Coords'].y, z = Config.Houses[JobHouseId]['Coords'].z - 35.0}
        TriggerEvent("framework-sound:client:play", "house-door-open", 0.7)
        if Config.Houses[JobHouseId]['Tier'] == 1 then
            Housing = exports['fw-interiors']:HouseRobTierOne(CoordsTable, Config.Houses[JobHouseId]['RobbableItems']['Tv'], Config.Houses[JobHouseId]['RobbableItems']['Micro'])
        elseif Config.Houses[JobHouseId]['Tier'] == 2 then
            Housing = exports['fw-interiors']:CreateAppartement(CoordsTable)
        elseif Config.Houses[JobHouseId]['Tier'] == 3 then
            Housing = exports['fw-interiors']:HouseRobTierThree(CoordsTable)
        end
        Citizen.SetTimeout(450, function()
            exports['fw-weathersync']:SetClientSync(false)
            HouseData, OffSets = Housing[1], Housing[2]
            TriggerEvent("framework-sound:client:play", "house-door-close", 0.1)
        end)
    end
end

function LeaveHouseRob(HouseId)
    if HouseId ~= nil then
        TriggerEvent("framework-sound:client:play", "house-door-open", 0.7)
        DoScreenFadeOut(500)
        while not IsScreenFadedOut() do
            Citizen.Wait(10)
        end
        exports['fw-interiors']:DespawnInterior(HouseData, function()
            SetEntityCoords(PlayerPedId(), Config.Houses[HouseId]['Coords'].x, Config.Houses[HouseId]['Coords'].y, Config.Houses[HouseId]['Coords'].z)
            exports['fw-weathersync']:SetClientSync(true)
            Citizen.Wait(1000)
            InsideHouse = false
            HouseData, OffSets = nil, nil
            if RemoveHouseData then
                Showing, RemoveHouseData = false, false
                DoingJob, JobHouseId = false, nil
                LSCore.Functions.Notify("Je bent klaar met werken..", "success")
            end
            if PlayerJob.name == 'police' then 
                JobHouseId = nil
            end
            DoScreenFadeIn(1000)
            TriggerEvent("framework-sound:client:play", "house-door-close", 0.1)
        end)
    end
end

function SearchCabin(HouseNumber, CabinNumber)
    if HouseNumber ~= nil and CabinNumber ~= nil then
        TriggerEvent('framework-assets:client:lockpick:animation', true)
        TriggerServerEvent('framework-houserobbery:server:set:cabin:state', HouseNumber, CabinNumber, 'Busy', true)
        exports['fw-ui']:StartSkillTest(4, 'Normal', function(Outcome)
            if Outcome then
                TriggerEvent('framework-assets:client:lockpick:animation', false)
                LSCore.Functions.Progressbar("lockpick-door", "Spullen pakken..", 2500, false, false, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {
                    animDict = "missexile3",
                    anim = "ex03_dingy_search_case_a_michael",
                    flags = 49,
                }, {}, {}, function() -- Done
                    TriggerServerEvent('framework-houserobbery:server:set:cabin:state', HouseNumber, CabinNumber, 'Open', true)
                    TriggerServerEvent('framework-houserobbery:server:set:cabin:state', HouseNumber, CabinNumber, 'Busy', false)
                    LSCore.Functions.TriggerCallback('framework-houserobbery:server:get:house:reward', function()
                    end)
                end, function() -- Cancel
                    TriggerServerEvent('framework-houserobbery:server:set:cabin:state', HouseNumber, CabinNumber, 'Busy', false)
                    LSCore.Functions.Notify("Proces geannuleerd..", "error")
                end)
            else
                TriggerEvent('framework-assets:client:lockpick:animation', false)
                TriggerServerEvent('framework-houserobbery:server:set:cabin:state', HouseNumber, CabinNumber, 'Busy', false)
            end 
        end)
    end
end

function CanRobItems()
    if JobHouseId ~= nil and InsideHouse then
        return true
    end
end

function IsWearingHandshoes()
    local armIndex = GetPedDrawableVariation(PlayerPedId(), 3)
    local model = GetEntityModel(PlayerPedId())
    local retval = true
    if model == GetHashKey("mp_m_freemode_01") then
        if Config.MaleNoHandshoes[armIndex] ~= nil and Config.MaleNoHandshoes[armIndex] then
            retval = false
        end
    else
        if Config.FemaleNoHandshoes[armIndex] ~= nil and Config.FemaleNoHandshoes[armIndex] then
            retval = false
        end
    end
    return retval
end

function GetAvailableHouse()
    local RandomHouses = {}
    for i = 1, #Config.Houses do
        local RandomHouse = Config.Houses[i]
        if RandomHouse ~= nil and RandomHouse and not RandomHouse['Busy'] then
            table.insert(RandomHouses, i)
        end
    end
    if RandomHouses ~= nil and #RandomHouses > 0 then
        return RandomHouses[math.random(1, #RandomHouses)]
    else
        return false
    end
end