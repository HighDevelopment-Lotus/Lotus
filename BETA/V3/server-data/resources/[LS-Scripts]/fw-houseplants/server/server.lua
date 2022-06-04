local LSCore = exports['fw-base']:GetCoreObject()

-- Code

LSCore.Functions.CreateCallback("framework-houseplants:server:get:config", function(source, cb)
    cb(Config)
end)

Citizen.CreateThread(function()
    LSCore.Functions.ExecuteSql(false, "SELECT * FROM `player_house_plants`", function(result)
        for k, v in pairs(result) do
            Config.Plants[v.houseid] = json.decode(v.plants)
            TriggerClientEvent('framework-houseplants:client:sync:plant:data', -1, v.houseid, Config.Plants[v.houseid])
        end
    end)
end)

RegisterServerEvent('framework-houseplants:server:destroy:plant')
AddEventHandler('framework-houseplants:server:destroy:plant', function(HouseId, RemoveId, IsDead)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    if HouseId ~= nil then
        LSCore.Functions.ExecuteSql(false, "SELECT * FROM `player_house_plants` WHERE `houseid` = '"..HouseId.."'", function(result)
            local PlantData = json.decode(result[1].plants)
            local NewPlants = {}
            for k, v in pairs(PlantData) do
                if k ~= RemoveId then
                  table.insert(NewPlants, v)
                end
            end
            LSCore.Functions.ExecuteSql(false, "UPDATE `player_house_plants` SET `plants` = '"..json.encode(NewPlants).."' WHERE `houseid` = '"..HouseId.."'")
            Citizen.SetTimeout(500, function()
                RefreshPlants(HouseId)
                if IsDead then
                    Player.Functions.AddItem('wet-tak', math.random(1, 13), false, false, true)
                end
            end)
        end)
    end
end)

RegisterServerEvent('framework-houseplants:server:add:plant')
AddEventHandler('framework-houseplants:server:add:plant', function(HouseId, NewPlant)
    if HouseId ~= nil then
        LSCore.Functions.ExecuteSql(false, "SELECT * FROM `player_house_plants` WHERE `houseid` = '"..HouseId.."'", function(result)
            if result[1] ~= nil then
                Config.Plants[HouseId] = NewPlant
                SaveCurrentHousePlants(HouseId)
            else
                LSCore.Functions.InsertSql(false, "INSERT INTO `player_house_plants` (`houseid`, `plants`) VALUES ('"..HouseId.."', '"..json.encode(NewPlant).."')")
                Citizen.SetTimeout(150, function()
                    RefreshPlants(HouseId)
                end)
            end
        end)
    end
end)

RegisterServerEvent('framework-houseplants:server:feed:plant')
AddEventHandler('framework-houseplants:server:feed:plant', function(HouseId, PlantId)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    if Config.Plants[HouseId] ~= nil then
       if Config.Plants[HouseId][PlantId]['Food'] < 100 then
            local RandomPlusAmouont = math.random(35, 45)
            if Config.Plants[HouseId][PlantId]['Food'] + RandomPlusAmouont < 100 then
                Config.Plants[HouseId][PlantId]['Food'] = Config.Plants[HouseId][PlantId]['Food'] + RandomPlusAmouont
                SaveCurrentHousePlants(HouseId)
            else
                Config.Plants[HouseId][PlantId]['Food'] = 100
                SaveCurrentHousePlants(HouseId)
            end
            Player.Functions.RemoveItem('weed-nutrition', 1, false, false, true)
       end
    end
end)

RegisterServerEvent('framework-houseplants:server:harvest:plant')
AddEventHandler('framework-houseplants:server:harvest:plant', function(HouseId, PlantId, Amount)
   local src = source
   local Player = LSCore.Functions.GetPlayer(src)
   local RandomWeedAmount = math.random(6, 12)
   local PlasticBag = Player.Functions.GetItemByName('empty_weed_bag')
   if Config.Plants[HouseId] ~= nil and Config.Plants[HouseId][PlantId] ~= nil then
        if PlasticBag.amount >= RandomWeedAmount then
            Player.Functions.RemoveItem('empty_weed_bag', RandomWeedAmount, false, true)
            if Config.Plants[HouseId][PlantId]['Sort'] == 'White-Widow' then
                Player.Functions.AddItem('weed_white-widow', RandomWeedAmount)
                if math.random(1,5) <= 2 and Config.Plants[HouseId][PlantId]['Gender'] == 'Man' then
                    Player.Functions.AddItem('weed_skunk_seed', Amount, false, false, true)
                end
            elseif Config.Plants[HouseId][PlantId]['Sort'] == 'Skunk' then
                Player.Functions.AddItem('weed_skunk', RandomWeedAmount, false, false, true)
                if math.random(1,5) <= 2 and Config.Plants[HouseId][PlantId]['Gender'] == 'Man' then
                    Player.Functions.AddItem('weed_purple-haze_seed', Amount, false, false, true)
                end
            elseif Config.Plants[HouseId][PlantId]['Sort'] == 'Purple-Haze' then
                Player.Functions.AddItem('weed_purple-haze', RandomWeedAmount, false, false, true)
                if math.random(1,5) <= 2 and Config.Plants[HouseId][PlantId]['Gender'] == 'Man' then
                    Player.Functions.AddItem('weed_og-kush_seed', Amount, false, false, true)
                end
            elseif Config.Plants[HouseId][PlantId]['Sort'] == 'Og-Kush' then
                Player.Functions.AddItem('weed_og-kush', RandomWeedAmount, false, false, true)
                if math.random(1,5) <= 2 and Config.Plants[HouseId][PlantId]['Gender'] == 'Man' then
                    Player.Functions.AddItem('weed_amnesia_seed', Amount, false, false, true)
                end
            elseif Config.Plants[HouseId][PlantId]['Sort'] == 'Amnesia' then
                Player.Functions.AddItem('weed_amnesia', RandomWeedAmount)
                if math.random(1,5) <= 2 and Config.Plants[HouseId][PlantId]['Gender'] == 'Man' then
                    Player.Functions.AddItem('weed_ak47_seed', Amount, false, false, true)
                end
            elseif Config.Plants[HouseId][PlantId]['Sort'] == 'AK47' then
                Player.Functions.AddItem('weed_ak47', RandomWeedAmount)
                if math.random(1,5) <= 2 and Config.Plants[HouseId][PlantId]['Gender'] == 'Man' then
                    Player.Functions.AddItem('weed_ak47_seed', Amount, false, false, true)
                end
            end
            TriggerEvent('framework-houseplants:server:destroy:plant', HouseId, PlantId, false)
        else
            TriggerClientEvent('LSCore:Notify', src, 'Je hebt niet genoeg zakjes..', 'error', 3500)
        end
    end
end)

Citizen.CreateThread(function()
    Citizen.SetTimeout(750, function()
        while true do
            local RandomValue = math.random(1, 3)
            for k, v in pairs(Config.Plants) do
                for weed, plant in pairs(v) do
                    if plant['Food'] > 0 and plant['Food'] - RandomValue > 0 then
                        plant['Food'] = plant['Food'] - RandomValue
                    else
                        plant['Food'] = 0
                    end
                    if plant['Food'] < 50 then
                        if plant['Health'] > 0 then
                            plant['Health'] = plant['Health'] - 5
                        else
                            plant['Health'] = 0
                        end
                    elseif plant['Food'] > 50 then
                        if plant['Health'] < 100 and plant['Health'] ~= 0 then
                            plant['Health'] = plant['Health'] + 5
                        else
                            plant['Health'] = 100
                        end
                    end
                    if plant['Health'] > 0 then
                        if plant['Progress'] < 100 then
                            local RandomGrowth = math.random(1, 3)
                            plant['Progress'] = plant['Progress'] + RandomGrowth
                            if plant['Progress'] >= 10 and plant['Progress'] < 20 then
                                plant['Stage'] = 'Stage-B'
                            elseif plant['Progress'] >= 20 and plant['Progress'] < 30 then
                                plant['Stage'] = 'Stage-C'
                            elseif plant['Progress'] >= 30 and plant['Progress'] < 40 then
                                plant['Stage'] = 'Stage-D'
                            elseif plant['Progress'] >= 40 and plant['Progress'] < 65 then
                                plant['Stage'] = 'Stage-E'
                            elseif plant['Progress'] >= 65 and plant['Progress'] < 70 then
                                plant['Stage'] = 'Stage-F'
                            elseif plant['Progress'] >= 70 and plant['Progress'] < 100 then
                                plant['Stage'] = 'Stage-G'
                            end
                        end
                    end
                end
            end
            SaveAllPlants()
            Citizen.Wait((60 * 1000) * 30)
        end
    end)
end)

function SaveCurrentHousePlants(HouseId)
    LSCore.Functions.ExecuteSql(false, "UPDATE `player_house_plants` SET `plants` = '"..json.encode(Config.Plants[HouseId]).."' WHERE `houseid` = '"..HouseId.."'")
    Citizen.SetTimeout(150, function()
        RefreshPlants(HouseId)
    end)
end

function SaveAllPlants()
    for k, v in pairs(Config.Plants) do
        LSCore.Functions.ExecuteSql(false, "UPDATE `player_house_plants` SET `plants` = '"..json.encode(Config.Plants[k]).."' WHERE `houseid` = '"..k.."'")
        Citizen.SetTimeout(150, function()
            RefreshPlants(k)
        end)
    end
end

function RefreshPlants(HouseId)
    LSCore.Functions.ExecuteSql(false, "SELECT * FROM `player_house_plants` WHERE `houseid` = '"..HouseId.."'", function(result)
        Config.Plants[HouseId] = json.decode(result[1].plants)
        TriggerClientEvent('framework-houseplants:client:sync:plant:data', -1, HouseId, Config.Plants[HouseId])
        TriggerClientEvent('framework-houseplants:client:sync:plants', -1, HouseId)
    end)
end