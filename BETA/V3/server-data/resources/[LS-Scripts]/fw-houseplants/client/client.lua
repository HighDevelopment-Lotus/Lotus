local LSCore, LoggedIn = exports['fw-base']:GetCoreObject(), false
local CurrentShownPlants, PlacedPlant = {}, false
local CurrentHouse, NearPlant = nil, false

RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1250, function()
        LSCore.Functions.TriggerCallback('framework-houseplants:server:get:config', function(ConfigData)
          Config = ConfigData
        end)
        LoggedIn = true
    end)
end)

RegisterNetEvent('LSCore:Client:OnPlayerUnload')
AddEventHandler('LSCore:Client:OnPlayerUnload', function()
    UnloadHousePlants()
    Citizen.SetTimeout(150, function()
        CurrentHouse = nil
        NearPlant = false
        LoggedIn = false
    end)
end)

-- Citizen.CreateThread(function()
--     Citizen.SetTimeout(1, function()
--         TriggerEvent("LSCore:GetObject", function(obj) LSCore = obj end)
--         Citizen.Wait(150)
--         LSCore.Functions.TriggerCallback('framework-houseplants:server:get:config', function(ConfigData)
--           Config = ConfigData
--         end)
--         LoggedIn = true
--     end)
-- end)

-- Code

Citizen.CreateThread(function()
    while true do
    Citizen.Wait(4)
        if CurrentHouse ~= nil then
            if Config.Plants[CurrentHouse] ~= nil then
                NearPlant = false
                if PlacedPlant then
                    for k, v in pairs(Config.Plants[CurrentHouse]) do
                        local PlayerCoords = GetEntityCoords(PlayerPedId())
                        local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'], true)
                        if Distance < 0.8 then
                            NearPlant = true
                            ClosestPlant = k
                            if v['Gender'] == 'Man' then
                                if v['Health'] == 0 then
                                    DrawText3D(v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'], '[~r~E~s~] - Kapot Maken')
                                elseif v['Progress'] >= 100 then
                                    DrawText3D(v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'], '[~g~E~s~] - Plukken')
                                else
                                    DrawText3D(v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'], '[~p~'..v['Name']..'~s~] ~r~Voeding:~s~ ' ..v['Food']..'%; ~g~Gezondheid:~s~ '..v['Health']..'%')
                                end
                            else
                                if v['Health'] == 0 then
                                    DrawText3D(v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'], '[~r~E~s~] - Kapot Maken')
                                elseif v['Progress'] >= 100 then
                                    DrawText3D(v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'], '[~g~E~s~] - Plukken')
                                else
                                    DrawText3D(v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'], '[~b~'..v['Name']..'~s~] ~r~Voeding:~s~ ' ..v['Food']..'%; ~g~Gezondheid:~s~ '..v['Health']..'%')
                                end
                            end
                            if IsControlJustReleased(0, 38) then
                                if v['Health'] == 0 then
                                    DestroyDeadPlant(ClosestPlant)
                                elseif v['Progress'] >= 100 then
                                    PickSelectedPlant(ClosestPlant)
                                end
                            end
                        end
                    end
                end
                if not NearPlant then
                    ClosestPlant = nil
                    Citizen.Wait(1500)
                end
            end
        end
    end
end)

RegisterNetEvent('framework-houseplants:client:sync:plant:data')
AddEventHandler('framework-houseplants:client:sync:plant:data', function(HouseId, ConfigData)
    Config.Plants[HouseId] = ConfigData
end)

RegisterNetEvent('framework-houseplants:client:sync:plants')
AddEventHandler('framework-houseplants:client:sync:plants', function(HouseId)
    if CurrentHouse ~= nil then
        if CurrentHouse == HouseId then
            PlacedPlant = false
            for k, v in pairs(CurrentShownPlants) do
                DeleteEntity(v)
                Citizen.Wait(50)
            end
            CurrentShownPlants = {}
            Citizen.SetTimeout(750, function()
                LoadHousePlants(CurrentHouse)
            end)
        end
    end
end)

RegisterNetEvent('framework-houseplants:client:feed:plants')
AddEventHandler('framework-houseplants:client:feed:plants', function()
    if CurrentHouse ~= nil then
        if ClosestPlant ~= nil then
            if Config.Plants[CurrentHouse][ClosestPlant]['Food'] < 100 then
                FeedSelectedPlant(ClosestPlant)
            else
                LSCore.Functions.Notify("Jij wel wil je dat deze plant verdrinkt ofzo..", "error")
            end 
        else
            LSCore.Functions.Notify("En waar zie jij een plant dan?!", "error")
        end
    else
        LSCore.Functions.Notify("Zit jij wel in een huis?!?", "error")
    end
end)

RegisterNetEvent('framework-houseplants:client:use:sheer')
AddEventHandler('framework-houseplants:client:use:sheer', function()
    if CurrentHouse ~= nil then
        if ClosestPlant ~= nil then
            DestroyDeadPlant(ClosestPlant)
        else
            LSCore.Functions.Notify("En waar zie jij een plant dan?!", "error")
        end
    else
        LSCore.Functions.Notify("Zit jij wel in een huis?!?", "error")
    end
end)

RegisterNetEvent('framework-houseplants:client:plant')
AddEventHandler('framework-houseplants:client:plant', function(PlantName, PlantType, ItemName)
    if CurrentHouse ~= nil then
        if ClosestPlant == nil then
            PlantPlantHere(PlantName, PlantType, ItemName)
        else
            LSCore.Functions.Notify("Geen plek joh!", "error")
        end
    else
        LSCore.Functions.Notify("Zit jij wel in een huis?!?", "error")
    end
end)

function PlantPlantHere(PlantName, PlantType, ItemName)
    TriggerEvent('framework-inv:client:set:inventory:state', false)
    LSCore.Functions.Progressbar("plant-weed", "Planten..", 10000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "amb@world_human_gardener_plant@male@base",
        anim = "base",
        flags = 16,
    }, {}, {}, function() -- Done
        AddPlant(PlantName, PlantType)
        TriggerEvent('framework-inv:client:set:inventory:state', true)
        LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, ItemName, 1, false)
        StopAnimTask(PlayerPedId(), "amb@world_human_gardener_plant@male@base", "base", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
    end, function()
        TriggerEvent('framework-inv:client:set:inventory:state', true)
        StopAnimTask(PlayerPedId(), "amb@world_human_gardener_plant@male@base", "base", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
        LSCore.Functions.Notify("Geannuleerd..", "error")
    end)
end

function PickSelectedPlant(PlantId)
    if Config.Plants[CurrentHouse][PlantId]['Progress'] >= 100 then
        LSCore.Functions.TriggerCallback('LSCore:HasItem', function(HasItem)
            if HasItem then
                LSCore.Functions.Progressbar("pick-weed", "Plukken..", 10000, false, true, {
                    disableMovement = false,
                    disableCarMovement = false,
                    disableMouse = false,
                    disableCombat = true,
                }, {
                    animDict = "amb@world_human_gardener_plant@male@base",
                    anim = "base",
                    flags = 16,
                }, {}, {}, function() -- Done
                    TriggerServerEvent('framework-houseplants:server:harvest:plant', CurrentHouse, PlantId, math.random(1, 5))
                    StopAnimTask(PlayerPedId(), "amb@world_human_gardener_plant@male@base", "base", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
                end, function()
                    StopAnimTask(PlayerPedId(), "amb@world_human_gardener_plant@male@base", "base", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
                    LSCore.Functions.Notify("Geannuleerd..", "error")
                end)
            else
                LSCore.Functions.Notify("Ik denk dat je iets mist..", "error")
            end
        end, 'empty_weed_bag')
    end
end

function DestroyDeadPlant(PlantId)
    if Config.Plants[CurrentHouse][PlantId]['Health'] <= 0 then
        LSCore.Functions.Progressbar("destroy-weed", "Vernietigen..", 10000, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "amb@world_human_gardener_plant@male@base",
            anim = "base",
            flags = 16,
        }, {}, {}, function() -- Done
            StopAnimTask(PlayerPedId(), "amb@world_human_gardener_plant@male@base", "base", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
            TriggerServerEvent('framework-houseplants:server:destroy:plant', CurrentHouse, PlantId, true)
        end, function()
            StopAnimTask(PlayerPedId(), "amb@world_human_gardener_plant@male@base", "base", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
            LSCore.Functions.Notify("Geannuleerd..", "error")
        end)
    end
end

function FeedSelectedPlant(PlantId)
    exports['fw-assets']:RequestAnimationDict("weapon@w_sp_jerrycan")
    TaskPlayAnim( PlayerPedId(), "weapon@w_sp_jerrycan", "fire", 8.0, 1.0, -1, 1, 0, 0, 0, 0 )
    LSCore.Functions.Progressbar("feed-weed", "Voeden..", 10000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerServerEvent('framework-houseplants:server:feed:plant', CurrentHouse, PlantId)
        StopAnimTask(PlayerPedId(), "weapon@w_sp_jerrycan", "fire", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
    end, function()
        StopAnimTask(PlayerPedId(), "weapon@w_sp_jerrycan", "fire", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
        LSCore.Functions.Notify("Geannuleerd..", "error")
    end)
end

function LoadHousePlants(HouseId)
    CurrentHouse = HouseId
    if not PlacedPlant then
       PlacedPlant = true
       Citizen.SetTimeout(650, function()
           if Config.Plants[CurrentHouse] ~= nil then
               for k, v in pairs(Config.Plants[CurrentHouse]) do
                    local PlantObject = CreateObject(GetHashKey(Config.StageProps[v["Stage"]]), v["Coords"]["X"], v["Coords"]["Y"], v["Coords"]["Z"], false, false, false)
                    FreezeEntityPosition(PlantObject, true)
                    PlaceObjectOnGroundProperly(PlantObject)
                    Citizen.Wait(30)
                    PlaceObjectOnGroundProperly(PlantObject)
                    table.insert(CurrentShownPlants, PlantObject)
                    Citizen.Wait(15)
               end
           end
       end)
    end
 end
  
function UnloadHousePlants()
    if PlacedPlant then
        PlacedPlant = false
        CurrentHouse = nil
        for k, v in pairs(CurrentShownPlants) do
            DeleteEntity(v)
            Citizen.Wait(50)
        end
        CurrentShownPlants = {}
    end
end

function AddPlant(PlantName, PlantType)
    local PlayerCoords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 0.75, 0) GetEntityCoords(PlayerPedId())
    local RandomNum = math.random(1, 2)
    local Gender = 'Man'
    if RandomNum == 2 then Gender = 'Vrouw' end
    if CurrentHouse ~= nil then
        if Config.Plants[CurrentHouse] ~= nil then
            local Data = {['Name'] = PlantName, ['PlantId'] = math.random(1111,9999), ['Stage'] = 'Stage-A', ['Sort'] = PlantType, ['Gender'] = Gender, ['Food'] = 100, ['Health'] = 100, ['Progress'] = 0, ['SpeedMultiplier'] = 1, ['Coords'] = {['X'] = PlayerCoords.x, ['Y'] = PlayerCoords.y, ['Z'] = PlayerCoords.z}}
            table.insert(Config.Plants[CurrentHouse], Data)
            TriggerServerEvent('framework-houseplants:server:add:plant', CurrentHouse, Config.Plants[CurrentHouse])
        else
            Config.Plants[CurrentHouse] = {[1] = {['Name'] = PlantName, ['PlantId'] = math.random(1111,9999), ['Stage'] = 'Stage-A', ['Sort'] = PlantType, ['Gender'] = Gender, ['Food'] = 100, ['Health'] = 100, ['Progress'] = 0, ['SpeedMultiplier'] = 1, ['Coords'] = {['X'] = PlayerCoords.x, ['Y'] = PlayerCoords.y, ['Z'] = PlayerCoords.z}}}
            TriggerServerEvent('framework-houseplants:server:add:plant', CurrentHouse, Config.Plants[CurrentHouse])
        end
    end
end

function DrawText3D(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end