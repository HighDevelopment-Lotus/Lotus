local LSCore = exports['ls-core']:GetCoreObject()

-- Code

LSCore.Functions.CreateCallback('ls-illegal:server:get:config', function(source, cb)
    cb(Config)
end)

-- // Brick Verkoop \\ --
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        local TotalPlayer = GetNumPlayerIndices()
        if TotalPlayer >= 0 then
            local Hour = exports['ls-weathersync']:GetCurrentTime()
            if Hour >= 0 and Hour <= 6 then
                if not DealerActive then
                    DealerActive = true
                    TriggerClientEvent('ls-illegal:client:set:seller:data', -1, 'Set')
                end
            elseif Hour >= 6 and Hour <= 23 then
                if DealerActive then
                    DealerActive = false
                    TriggerClientEvent('ls-illegal:client:set:seller:data', -1, 'Delete')
                end
            end
            Citizen.Wait(2000)
        else
            Citizen.Wait(450)
        end
    end
end)

-- // Oxy Runs \\ --

RegisterServerEvent('ls-illegal:server:recieve:boxes')
AddEventHandler('ls-illegal:server:recieve:boxes', function(Amount)
    local Player = LSCore.Functions.GetPlayer(source)
    Player.Functions.AddItem('oxy-box', Amount, false, false, true)
end)

RegisterServerEvent('ls-illegal:server:sell:weed')
AddEventHandler('ls-illegal:server:sell:weed', function()
    if not SellingWeed then
        SellingWeed = true
        local Player = LSCore.Functions.GetPlayer(source)
        for k, v in pairs(Player.PlayerData.inventory) do
            if Config.SellWeed[v.name] ~= nil then
                if Player.Functions.RemoveItem(v.name, v.amount, false, true) then
                    local WeedAddictionLevel, ExtraAdd = LSCore.Functions.GetAddictionLevel(source, 'weed'), 0
                    if WeedAddictionLevel == 1 then ExtraAdd = math.random(1,4) elseif WeedAddictionLevel == 2 then ExtraAdd = math.random(3,6) elseif WeedAddictionLevel == 3 then ExtraAdd = math.random(4,7) elseif WeedAddictionLevel == 4 then ExtraAdd = math.random(5,8) end
                    Player.Functions.AddMoney('cash', (v.amount * Config.SellWeed[v.name]['Price']) + ExtraAdd)
                end
            end
        end
        SellingWeed = false
    else
        TriggerClientEvent('LSCore:Notify', source, "Er is al iemand aan het verkopen..", "error", 3500)
    end
end)

RegisterNetEvent('ls-illegal:server:sell:weedbrick')
AddEventHandler('ls-illegal:server:sell:weedbrick', function()
    local Player = LSCore.Functions.GetPlayer(source)
    for k, v in pairs(Player.PlayerData.inventory) do
        if v.name == 'weed-brick' then
            if Player.Functions.RemoveItem('weed-brick', v.amount, false, true) then
                Player.Functions.AddMoney('cash', v.amount * 1300)
            end
        end
    end
end)

LSCore.Functions.CreateUseableItem('weed_ak47', function(source, item)
    local Player = LSCore.Functions.GetPlayer(source)
    if item.amount >= 20 then
        Player.Functions.RemoveItem('weed_ak47', 20)
        Player.Functions.AddItem('weed-brick', 1)
        Player.Functions.AddItem('empty_weed_bag', math.random(6, 12))
    else
        TriggerClientEvent('LSCore:Notify', source, 'Je hebt niet genoeg wiet..', 'error')
    end
end)

LSCore.Functions.CreateUseableItem('weed_white-widow', function(source, item)
    local Player = LSCore.Functions.GetPlayer(source)
    if item.amount >= 20 then
        Player.Functions.RemoveItem('weed_white-widow', 20)
        Player.Functions.AddItem('weed-brick', 1)
        Player.Functions.AddItem('empty_weed_bag', math.random(6, 12))
    else
        TriggerClientEvent('LSCore:Notify', source, 'Je hebt niet genoeg wiet..', 'error')
    end
end)

RegisterServerEvent('ls-illegal:server:sell:electrnoics')
AddEventHandler('ls-illegal:server:sell:electrnoics', function()
    local Player = LSCore.Functions.GetPlayer(source)
    local StolenTv = Player.Functions.GetItemByName('stolen-tv')
    local StolenMicro = Player.Functions.GetItemByName('stolen-micro')
    local StolenPc = Player.Functions.GetItemByName('stolen-pc')
    if StolenTv ~= nil then
        if Player.Functions.RemoveItem('stolen-tv', 1, false, true) then
            Player.Functions.AddMoney('cash', math.random(600, 950))
        end
    elseif StolenMicro ~= nil then
        if Player.Functions.RemoveItem('stolen-micro', 1, false, true) then
            Player.Functions.AddMoney('cash', math.random(250, 350))
        end
    elseif StolenPc ~= nil then
        if Player.Functions.RemoveItem('stolen-pc', 1, false, true) then
            Player.Functions.AddMoney('cash', math.random(300, 450))
        end
    end
end)

LSCore.Functions.CreateCallback('ls-illegal:server:deliver:oxy', function(source, cb, CurrentSpot)
    local Player = LSCore.Functions.GetPlayer(source)
    if Player.Functions.RemoveItem('oxy-box', 1, false, true) then
        if Config.OxyLocations[CurrentSpot]['Cleaning'] then
            local RollsItem = Player.Functions.GetItemByName('money-roll')
            if RollsItem ~= nil and RollsItem.amount > 7 then
                local RandomRemove = math.random(3, 7)
                if Player.Functions.RemoveItem('money-roll', RandomRemove, false, true) then
                    Player.Functions.AddMoney('cash', (math.random(85, 105) * RandomRemove))
                end
            end
        end
        local RandomValue = math.random(1, 3)
        if RandomValue == 1 then
            Player.Functions.AddItem('painkillers', math.random(2, 4), false, false, true)
        elseif RandomValue == 2 then
            Player.Functions.AddItem('joint', math.random(1, 2), false, false, true)
        elseif RandomValue == 3 then
            Player.Functions.AddItem('painkillers', math.random(1, 2), false, false, true)
        end
        cb(true)
    else
        cb(false)
    end
end)

-- Selling --

RegisterServerEvent('ls-illegal:server:try:sell:other')
AddEventHandler('ls-illegal:server:try:sell:other', function()
    local RecieveMoney = 0
    local Player = LSCore.Functions.GetPlayer(source)
    local InventoryItems = exports['ls-inventory-new']:GetInventoryItems("Inkoper: 2")
    if InventoryItems ~= nil then
        for k, v in pairs(InventoryItems) do
            if Config.SellItems[v.name] ~= nil then
                if v.name == 'markedbills' then
                    RecieveMoney = RecieveMoney + v.info.worth
                else
                    RecieveMoney = RecieveMoney + (Config.SellItems[v.name] * v.amount)
                end
                InventoryItems[k] = nil
            end
        end
        if RecieveMoney > 0 then
            exports['ls-inventory-new']:SetInventoryItems("Inkoper: 2", InventoryItems)
            Player.Functions.AddMoney('cash', RecieveMoney)
        else
            TriggerClientEvent('LSCore:Notify', source, 'Er is niks om te verkopen..', 'error')
        end
    else
        TriggerClientEvent('LSCore:Notify', source, 'Er is niks om te verkopen..', 'error')
    end
end)