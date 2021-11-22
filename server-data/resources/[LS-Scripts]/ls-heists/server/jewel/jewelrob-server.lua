-- // Jewerley \\ --

LSCore.Functions.CreateCallback("ls-heists:has:jewerlley:items", function(source, cb)
    local Player = LSCore.Functions.GetPlayer(source)
    local ItemCard = Player.Functions.GetItemByName('yellow-card')
    local ItemKit = Player.Functions.GetItemByName('electronickit')
    if ItemCard ~= nil and ItemKit ~= nil then
        cb(true)
    else
        if ItemCard == nil then
            TriggerClientEvent('LSCore:Notify', source, "Je hebt niet de juiste kaart..", "error", 4500)
        elseif ItemKit == nil then
            TriggerClientEvent('LSCore:Notify', source, "Je hebt geen electronickit..", "error", 4500)
        end
        cb(false)
    end
end)

RegisterServerEvent('ls-jewellery:server:set:jewellery:data')
AddEventHandler('ls-jewellery:server:set:jewellery:data', function(VitrineId, Type, Bool)
    Config.Vitrines[VitrineId][Type] = Bool
    TriggerClientEvent('ls-jewellery:client:sync:jewellery', -1, Config.Vitrines)
end)

RegisterServerEvent('ls-jewellery:server:set:alarm')
AddEventHandler('ls-jewellery:server:set:alarm', function(Bool)
    Config.JewelAlarmOn = Bool
    TriggerClientEvent('ls-jewellery:client:sync:jewellery:alarm', -1, Config.JewelAlarmOn)
end)

RegisterServerEvent('ls-heists:server:set:doors:data')
AddEventHandler('ls-heists:server:set:doors:data', function(VentId, Bool)
    local Player = LSCore.Functions.GetPlayer(source)
    Config.JewelHack[VentId]['HackDone'] = Bool
    Player.Functions.RemoveItem('yellow-card', 1, false, true)
    TriggerClientEvent('ls-jewellery:client:sync:jewellery:doors', -1, Config.JewelHack)
    if Config.JewelHack[1]['HackDone'] and Config.JewelHack[2]['HackDone'] then
        TriggerEvent('ls-doors:server:set:door:locks', 42, 0)
        TriggerEvent('ls-doors:server:set:door:locks', 43, 0)
        TriggerEvent('ls-police:server:send:alert:jewellery', GetEntityCoords(GetPlayerPed(source)), 'Rockford Hills')
        TriggerClientEvent('LSCore:Notify', source, "Deuren opengebroken! Je hebt 30 minuten..", "success", 6500)
        StartRestart()
    end
end)

RegisterServerEvent('ls-jewellery:vitrine:reward')
AddEventHandler('ls-jewellery:vitrine:reward', function()
    local Player = LSCore.Functions.GetPlayer(source)
    local RandomValue = math.random(1,100)
    if RandomValue <= 10 then
        Player.Functions.AddItem('white-pearl', math.random(8,11), false, false, true)
    elseif RandomValue >= 11 and RandomValue <= 35 then
        Player.Functions.AddItem('cult-necklace', math.random(5,7), false, false, true)
    elseif RandomValue >= 36 and RandomValue <= 45 then
        Player.Functions.AddItem('rolex', math.random(5,7), false, false, true)
    elseif RandomValue >= 46 and RandomValue <= 65 then
        Player.Functions.AddItem('diamond-skull', math.random(5,6), false, false, true)
    elseif RandomValue >= 66 and RandomValue <= 75 then
        Player.Functions.AddItem('goldchain', math.random(4,6), false, false, true)
    elseif RandomValue >= 76 and RandomValue <= 95 then
        if math.random(1,2) == 1 then
            Player.Functions.AddItem('diamond-blue', math.random(6,8), false, false, true)
        else
            Player.Functions.AddItem('diamond-red', math.random(6,8), false, false, true)
        end
    else
        Player.Functions.AddItem('diamond-chessboard', math.random(1,2), false, false, true)
    end
end)

function StartRestart()
    Citizen.SetTimeout((1000 * 60) * 30, function()
        TriggerEvent('ls-doors:server:set:door:locks', 42, 4)
        TriggerEvent('ls-doors:server:set:door:locks', 43, 4)
        for k,v in pairs(Config.Vitrines) do
            Config.Vitrines[k]["Robbed"] = false
            Config.Vitrines[k]["Busy"] = false
        end
        Config.JewelHack[1]['HackDone'] = false
        Config.JewelHack[2]['HackDone'] = false
        TriggerEvent('ls-jewellery:server:set:alarm', true)
        TriggerClientEvent('ls-jewellery:client:sync:jewellery:doors', -1, Config.JewelHack)
        TriggerClientEvent('ls-jewellery:client:sync:jewellery', -1, Config.Vitrines)
    end)
end
