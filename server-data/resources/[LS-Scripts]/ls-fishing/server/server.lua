local LSCore = exports['ls-core']:GetCoreObject()
local FishLocation = {['Name'] = 'Fish1',['Coords'] = {['X'] = 241.00, ['Y'] = 3993.00, ['Z'] = 30.40}}

-- Code

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LSCore ~= nil then
            Citizen.Wait(1000 * 60 * 6)
            FishLocation = Config.FishLocations[math.random(1, #Config.FishLocations)]
            TriggerClientEvent('ls-fishing:client:sync:location', -1, FishLocation)
        end
    end
end)

LSCore.Functions.CreateCallback('ls-fishing:server:get:location', function(source, cb)
    cb(FishLocation)
end)

LSCore.Functions.CreateCallback('ls-fishing:server:can:pay', function(source, cb, price)
    local Player = LSCore.Functions.GetPlayer(source)
    if Player.Functions.RemoveMoney("cash", price, "boat-price") then
        cb(true)
    else 
        cb(false)
    end
end)

LSCore.Functions.CreateCallback('ls-fishing:server:HasFishItem', function(source, cb, itemName)
    local Player = LSCore.Functions.GetPlayer(source)
    if Player ~= nil then
        local ItemDrill = Player.Functions.GetItemByName('drill')
        local ItemBit = Player.Functions.GetItemByName('drill-bit')
        if ItemDrill ~= nil and ItemBit then
            cb(true)
        else
            cb(false)
        end
    end
end)

LSCore.Functions.CreateUseableItem("fishingrod", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('ls-fishing:client:use:fishingrod', source)
    end
end)

RegisterServerEvent('ls-fishing:server:fish:154:reward:new:55')
AddEventHandler('ls-fishing:server:fish:154:reward:new:55', function()
    local Player = LSCore.Functions.GetPlayer(source)
    local RandomValue = math.random(1, 1000)
    if RandomValue >= 100 and RandomValue < 650 then
        local SubValue = math.random(1,3)
        if SubValue == 1 then
            Player.Functions.AddItem('fish-1', 1, false, false, true)
        elseif SubValue == 2 then
            Player.Functions.AddItem('fish-2', 1, false, false, true)
        else
            Player.Functions.AddItem('fish-3', 1, false, false, true)
        end
    elseif RandomValue >= 700 and RandomValue < 820 then
        local SubValue = math.random(1,2)
        if SubValue == 1 then
            Player.Functions.AddItem('shoe', 1, false, false, true)
        else
            Player.Functions.AddItem('plasticbag', 1, false, false, true)
        end
    elseif RandomValue >= 830 and RandomValue <= 840 then
        local SubValue = math.random(1, 10)
        if SubValue <= 7 then
            Player.Functions.AddItem('fish-box', 1, false, false, true)
        else
            Player.Functions.AddItem('fish-crate', 1, false, false, true)
        end
    elseif RandomValue >= 850 and RandomValue <= 853 then
        Player.Functions.AddItem('fish-dolphine', 1, false, false, true)
    elseif RandomValue >= 900 and RandomValue <= 904 then
        Player.Functions.AddItem('special-fish', 1, false, false, true)
    else
        TriggerClientEvent('LSCore:Notify', source, "Er zat niks aan je haak..", "error")
    end
end)

RegisterServerEvent('ls-fishing:server:unbox')
AddEventHandler('ls-fishing:server:unbox', function(BoxName)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    if BoxName == 'fish-crate' then
        if Player.Functions.RemoveItem('fish-crate', 1, false, true) then
            local RandomPremiumItem = Config.PremiumItems[math.random(1, #Config.PremiumItems)]
            Player.Functions.AddItem(RandomPremiumItem, math.random(1, 2), false, false, true)
        end
    else
        if Player.Functions.RemoveItem('fish-box', 1, false, true) then
            local RandomNormalItem = Config.NormalItems[math.random(1, #Config.NormalItems)]
            Player.Functions.AddItem(RandomNormalItem, 1, false, false, true)
        end 
    end
end)

RegisterServerEvent('ls-fishing:server:sell:gold-fish')
AddEventHandler('ls-fishing:server:sell:gold-fish', function()
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    if Player.Functions.RemoveItem('special-fish', 1, false, true) then
        Player.Functions.AddMoney('cash', math.random(1000, 3500))
    elseif Player.Functions.RemoveItem('fish-dolphine', 1, false, true) then
        Player.Functions.AddMoney('cash', math.random(2000, 4500))
    elseif Player.Functions.RemoveItem('white-pearl', 1, false, true) then
        Player.Functions.AddMoney('cash', 1200)
    end
end)

RegisterServerEvent('ls-fishing:server:repay:bail')
AddEventHandler('ls-fishing:server:repay:bail', function()
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    Player.Functions.AddMoney('cash', 500, 'bail-repay')
end)

RegisterServerEvent('ls-fishing:server:sell:items')
AddEventHandler('ls-fishing:server:sell:items', function()
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    for k, v in pairs(Config.SellItems) do
        local Item = Player.Functions.GetItemByName(k)
        if Item ~= nil then
          if Item.amount > 0 then
              for i = 1, Item.amount do
                  Player.Functions.RemoveItem(Item.name, 1, false, true)
                  if v['Type'] == 'item' then
                      Player.Functions.AddItem(v['Item'], v['Amount'])
                  else
                      Player.Functions.AddMoney('cash', v['Amount'], 'sold-fish')
                  end
                  Citizen.Wait(250)
              end
          end
        end
    end
end)