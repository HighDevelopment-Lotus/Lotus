local LSCore = exports['ls-core']:GetCoreObject()

-- Code

LSCore.Functions.CreateCallback('ls-materials:server:is:vehicle:owned', function(source, cb, plate)
    LSCore.Functions.ExecuteSql(false, "SELECT * FROM `player_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        if plate ~= nil and result[1] ~= nil then
            cb(true)
        else
            cb(false)
        end
    end)
end)

RegisterServerEvent('ls-materials:server:get:reward')
AddEventHandler('ls-materials:server:get:reward', function()
    local Player = LSCore.Functions.GetPlayer(source)
    local RandomValue = math.random(1, 100)
    local RandomItems = Config.BinItems[math.random(#Config.BinItems)]
    if RandomValue <= 55 then
        Player.Functions.AddItem(RandomItems, math.random(8, 20), false, false, true)
    elseif RandomValue >= 87 and RandomValue <= 89 then
        local SubValue = math.random(1, 2)
        if SubValue == 1 then
            Player.Functions.AddItem('knife-part-1', 1, false, false, true)
        elseif SubValue == 2 then
            Player.Functions.AddItem('switch-part-1', 1, false, false, true)
        end
    else
        TriggerClientEvent('LSCore:Notify', Player.PlayerData.source, 'Je vond niks..', 'error')
    end
end)

RegisterServerEvent('ls-materials:server:recyclenew:reward')
AddEventHandler('ls-materials:server:recyclenew:reward', function()
    local Player = LSCore.Functions.GetPlayer(source)
    Player.Functions.AddItem('recycle-mats', math.random(3,5), false, false, true)
end)

RegisterServerEvent('ls-materials:server:scrap:reward')
AddEventHandler('ls-materials:server:scrap:reward', function()
    local Player = LSCore.Functions.GetPlayer(source)
    for i = 1, math.random(4, 8), 1 do
        local Items = Config.CarItems[math.random(1, #Config.CarItems)]
        local RandomNum = math.random(60, 95)
        Player.Functions.AddItem(Items, RandomNum, false, false, true)
        Citizen.Wait(500)
    end
    if math.random(1, 100) <= 35 then
        Player.Functions.AddItem('rubber', math.random(10, 30), false, false, true)
    end
end)

function GetRecycleCrafting(ItemId)
    return Config.RecycleCrafting[ItemId]
end