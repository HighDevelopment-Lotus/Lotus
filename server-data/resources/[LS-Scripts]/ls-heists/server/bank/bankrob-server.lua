-- // Bank Robbery \\ --

LSCore.Functions.CreateCallback("ls-bankrobbery:has:bank:items", function(source, cb, card)
    local Player = LSCore.Functions.GetPlayer(source)
    if Player ~= nil then
        local ItemCard = Player.Functions.GetItemByName(card)
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
    end
end)

LSCore.Functions.CreateCallback("ls-bankrobbery:server:has:drill:items", function(source, cb, card)
    local Player = LSCore.Functions.GetPlayer(source)
    if Player ~= nil then
        local ItemDrillBit = Player.Functions.GetItemByName('drill-bit')
        local ItemDrill = Player.Functions.GetItemByName('drill')
        if ItemDrill ~= nil and ItemDrillBit ~= nil then
            cb(true)
        else
            if ItemDrill == nil then
                TriggerClientEvent('LSCore:Notify', source, "Je mist een boor..", "error", 4500)
            elseif ItemDrillBit == nil then
                TriggerClientEvent('LSCore:Notify', source, "Je mist een bitje..", "error", 4500)
            end
            cb(false)
        end
    end
end)

LSCore.Functions.CreateCallback("ls-bankrobbery:server:has:lockpick:items", function(source, cb, card)
    local Player = LSCore.Functions.GetPlayer(source)
    if Player ~= nil then
        local ItemAdvLockpick = Player.Functions.GetItemByName('advancedlockpick')
        local ItemLockpick = Player.Functions.GetItemByName('lockpick')
        local ItemToolkit = Player.Functions.GetItemByName('screwdriverset')
        if ItemLockpick ~= nil and ItemToolkit ~= nil or ItemAdvLockpick ~= nil then
            cb(true)
        else
            cb(false)
        end
    end
end)

LSCore.Functions.CreateCallback("ls-bankrobbery:server:has:special:items", function(source, cb)
    local Player = LSCore.Functions.GetPlayer(source)
    if Player ~= nil then
        local ItemUsb = Player.Functions.GetItemByName('usb-device')
        local ItemKit = Player.Functions.GetItemByName('electronickit')
        if ItemUsb ~= nil and ItemKit ~= nil then
            cb(true)
        else
            if ItemUsb == nil then
                TriggerClientEvent('LSCore:Notify', source, "Je mist een usb apparaat..", "error", 4500)
            elseif ItemKit == nil then
                TriggerClientEvent('LSCore:Notify', source, "Je mist een electronickit..", "error", 4500)
            end
            cb(false)
        end
    end
end)

RegisterServerEvent('ls-bankrobbery:server:set:bank:card')
AddEventHandler('ls-bankrobbery:server:set:bank:card', function(BankId, Bool)
    local RandomBankCard = Config.CardTypes[math.random(1, #Config.CardTypes)]
    local ItemData = exports['ls-inventory-new']:GetItemData(RandomBankCard)
    Config.Banks[BankId]['Menus'][1]['Name'] = 'Bank Kaart: '..ItemData['label']
    Config.Banks[BankId]['Menus'][1]['Desc'] = 'De bank kaart is bekent.'
    Config.Banks[BankId]['Menus'][1]['Card'] = RandomBankCard
    Config.Banks[BankId]['Menus'][1]['Event'] = '' 
    Config.Banks[BankId]['Menus'][2]['Active'] = Bool
    TriggerClientEvent('ls-bankrobbery:client:sync:bank:config', -1, Config.Banks)
    Citizen.SetTimeout((1000 * 60) * math.random(25, 30), function()
        Config.Banks[BankId]['Menus'][1]['Name'] = 'Welke kaart?'
        Config.Banks[BankId]['Menus'][1]['Desc'] = 'Kom erachter welke kaart je nodig hebt..'
        Config.Banks[BankId]['Menus'][1]['Event'] = 'ls-bankrobbery:client:hack:card' 
        Config.Banks[BankId]['Menus'][1]['Card'] = nil
        Config.Banks[BankId]['Menus'][2]['Active'] = false
        TriggerClientEvent('ls-bankrobbery:client:sync:bank:config', -1, Config.Banks)
    end)
end)

RegisterServerEvent('ls-bankrobbery:server:set:bank')
AddEventHandler('ls-bankrobbery:server:set:bank', function(BankId)
    Config.BankBeingRobbed = true
    TriggerClientEvent('ls-bankrobbery:client:set:robbed', -1, true)
    TriggerClientEvent('ls-bankrobbery:client:sync:bank:config', -1, Config.Banks)
    Citizen.SetTimeout(25000, function()
        Config.Banks[BankId]['BankOpen'] = true
        TriggerClientEvent('ls-bankrobbery:client:sync:bank:config', -1, Config.Banks)
    end)
    Citizen.SetTimeout((1000 * 60) * math.random(25, 30), function()
        for k, v in pairs(Config.Banks[BankId]['Lockers']) do
          v['Open'] = false
          v['Busy'] = false
        end
        Config.BankBeingRobbed = false
        Config.Banks[BankId]['BankOpen'] = false
        if Config.Banks[BankId]['Prop'][2] ~= nil then
            Config.Banks[BankId]['Prop'][2]['Available'] = true
        end
        for k, v in pairs(Config.Banks[BankId]['DoorReset']) do
            TriggerEvent('ls-doors:server:set:door:locks', v, 1)
        end
        TriggerClientEvent('ls-bankrobbery:client:set:robbed', -1, false)
        TriggerClientEvent('ls-bankrobbery:client:sync:bank:config', -1, Config.Banks)
        print('Restet Bank', BankId)
    end)
end)

RegisterServerEvent('ls-bankrobbery:server:set:locker:state')
AddEventHandler('ls-bankrobbery:server:set:locker:state', function(BankId, LockerId, Type, Bool)
    Config.Banks[BankId]['Lockers'][LockerId][Type] = Bool
    TriggerClientEvent('ls-bankrobbery:client:sync:bank:config', -1, Config.Banks)
end)

RegisterServerEvent('ls-bankrobbery:server:grab:box')
AddEventHandler('ls-bankrobbery:server:grab:box', function(BankId)
    local Player = LSCore.Functions.GetPlayer(source)
    Config.Banks[BankId]['Prop'][2]['Available'] = false
    Player.Functions.AddItem('bank-box', 1, false, false, true)
    TriggerClientEvent('ls-bankrobbery:client:sync:bank:config', -1, Config.Banks)
end)

RegisterServerEvent('ls-bankrobbery:server:bank:reward')
AddEventHandler('ls-bankrobbery:server:bank:reward', function(BankId)
    local RandomValue = math.random(1, 100)
    local Player = LSCore.Functions.GetPlayer(source)
    if BankId < 7 then
        if RandomValue >= 1 and RandomValue < 7 then
            Player.Functions.AddItem('yellow-card', 1, false, false, true)
        elseif RandomValue > 7 and RandomValue < 12 then
            Player.Functions.AddItem('money-roll', math.random(30, 85), false, false, true)
        elseif RandomValue > 12 and RandomValue < 27 then
            Player.Functions.AddItem('rolex', math.random(5, 13), false, false, true)
        elseif RandomValue > 27 and RandomValue < 69 then
            Player.Functions.AddItem('markedbills', 1, false, {worth = math.random(6500, 9500)})
        elseif RandomValue > 69 and RandomValue < 84 then
            Player.Functions.AddItem('goldchain', math.random(8, 25), false, false, true)
        elseif RandomValue > 84 and RandomValue < 85 then
            Player.Functions.AddItem('snspistol_part_3', 1, false, false, true)
        elseif RandomValue > 85 and RandomValue < 100 then
            Player.Functions.AddItem('goldbar', math.random(1, 4), false, false, true)
        end
    else
        if RandomValue >= 1 and RandomValue < 7 then
            local SubValue = math.random(1, 2)
            Player.Functions.AddItem('money-roll', math.random(60, 110), false, false, true)
            if SubValue == 1 then
                Player.Functions.AddItem('black-card', 1, false, false, true)
            elseif SubValue == 2 then
                Player.Functions.AddItem('yellow-card', 1, false, false, true)
            end
        elseif RandomValue > 7 and RandomValue < 12 then
            Player.Functions.AddItem('money-roll', math.random(60, 110), false, false, true)
        elseif RandomValue > 12 and RandomValue < 27 then
            Player.Functions.AddItem('rolex', math.random(8, 16), false, false, true)
        elseif RandomValue > 27 and RandomValue < 69 then
            Player.Functions.AddItem('markedbills', 1, false, {worth = math.random(8500, 12500)})
        elseif RandomValue > 69 and RandomValue < 84 then
            Player.Functions.AddItem('goldchain', math.random(17, 30), false, false, true)
        elseif RandomValue > 84 and RandomValue < 85 then
            Player.Functions.AddItem('snspistol_part_3', 1, false, false, true)
        elseif RandomValue > 85 and RandomValue < 100 then
            Player.Functions.AddItem('goldbar', math.random(2, 6), false, false, true)
        end
    end
end)