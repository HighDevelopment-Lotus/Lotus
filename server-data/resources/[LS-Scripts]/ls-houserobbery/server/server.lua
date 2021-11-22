local LSCore = exports['ls-core']:GetCoreObject()

-- Code

RegisterServerEvent('ls-houserobbery:server:set:door:state')
AddEventHandler('ls-houserobbery:server:set:door:state', function(HouseId, Bool)
    Config.Houses[HouseId]['DoorState'] = Bool
    TriggerClientEvent('ls-houserobbery:client:sync:data', -1, HouseId, Config.Houses[HouseId])
end)

RegisterServerEvent('ls-houserobbery:server:set:cabin:state')
AddEventHandler('ls-houserobbery:server:set:cabin:state', function(HouseId, CabinId, Type, Bool)
    Config.Houses[HouseId]['Cabins'][CabinId][Type] = Bool
    if Type == 'Open' and Bool then
        local Count = 0
        for k, v in pairs(Config.Houses[HouseId]['Cabins']) do
            if v['Open'] then
                Count = Count + 1
            end
        end
        if Count == #Config.Houses[HouseId]['Cabins'] then
            TriggerClientEvent('ls-houseobbery:client:next:leave:stop:job', source)
        end
    end
    TriggerClientEvent('ls-houserobbery:client:sync:data', -1, HouseId, Config.Houses[HouseId])
end)

RegisterServerEvent('ls-houserobbery:server:set:house:busy')
AddEventHandler('ls-houserobbery:server:set:house:busy', function(HouseId, Bool)
    local src = source
    Config.Houses[HouseId]['Busy'] = Bool
    TriggerClientEvent('ls-houserobbery:client:sync:data', -1, HouseId, Config.Houses[HouseId])
    Citizen.SetTimeout((60 * 1000) * 15, function()
        Config.Houses[HouseId]['DoorState'] = false
        Config.Houses[HouseId]['Busy'] = false
        if Config.Houses[HouseId]['Tier'] == 1 then
            Config.Houses[HouseId]['RobbableItems']['Tv'] = false
            Config.Houses[HouseId]['RobbableItems']['Micro'] = false
        end
        for k,v in pairs(Config.Houses[HouseId]['Cabins']) do
            v['Busy'] = false
            v['Open'] = false
        end
        TriggerClientEvent('ls-houserobbery:client:stop:job', src)
        TriggerClientEvent('ls-houserobbery:client:sync:data', -1, HouseId, Config.Houses[HouseId])
    end)
end)

RegisterServerEvent('ls-houserobbery:server:get:house:reward')
AddEventHandler('ls-houserobbery:server:get:house:reward', function()
    local RandomValue = math.random(1,100)
    local Player = LSCore.Functions.GetPlayer(source)
    if RandomValue >= 0 and RandomValue <= 15 then
        Player.Functions.AddMoney('cash', math.random(450, 550), "House Robbery")
    elseif RandomValue > 16 and RandomValue <= 34 then
        Player.Functions.AddItem('heirloom', math.random(3,6), false, false, true)
    elseif RandomValue > 35 and RandomValue <= 54 then
        Player.Functions.AddItem('rolex', math.random(4,12), false, false, true)
    elseif RandomValue > 55 and RandomValue <= 74 then
        Player.Functions.AddItem('goldchain', math.random(5,13), false, false, true)
    elseif RandomValue > 75 and RandomValue <= 77 then
        Player.Functions.AddItem('black-card', 1, false, false, true)
    elseif RandomValue > 78 and RandomValue <= 86 then
        Player.Functions.AddItem('gold-record', 1, false, false, true)
    elseif RandomValue > 87 and RandomValue <= 93 then
        Player.Functions.AddItem('platinum-record', 1, false, false, true)
    elseif RandomValue > 94 and RandomValue <= 100 then
        Player.Functions.AddItem('diamond-record', 1, false, false, true)
    end
end)

RegisterServerEvent('ls-houserobbert:server:add:steal:item')
AddEventHandler('ls-houserobbert:server:add:steal:item', function(Type)
    local Player = LSCore.Functions.GetPlayer(source)
    if Type == 'Tv' then
        Player.Functions.AddItem('stolen-tv', 1, false, false, true)
    elseif Type == 'Micro' then
        Player.Functions.AddItem('stolen-micro', 1, false, false, true)
    end
end)