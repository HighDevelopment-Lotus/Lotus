local LSCore = exports['fw-base']:GetCoreObject()

-- Code

LSCore.Functions.CreateCallback('framework-illegal:server:get:config', function(source, cb)
    cb(Config)
end)

-- // Brick Verkoop \\ --
-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(4)
--         local TotalPlayer = GetNumPlayerIndices()
--         if TotalPlayer >= 0 then
--             local Hour = exports['fw-weathersync']:GetCurrentTime()
--             if Hour >= 0 and Hour <= 6 then
--                 if not DealerActive then
--                     DealerActive = true
--                     TriggerClientEvent('framework-illegal:client:set:seller:data', -1, 'Set')
--                 end
--             elseif Hour >= 6 and Hour <= 23 then
--                 if DealerActive then
--                     DealerActive = false
--                     TriggerClientEvent('framework-illegal:client:set:seller:data', -1, 'Delete')
--                 end
--             end
--             Citizen.Wait(2000)
--         else
--             Citizen.Wait(450)
--         end
--     end
-- end)

-- // Oxy Runs \\ --

RegisterServerEvent('framework-illegal:server:recieve:boxes')
AddEventHandler('framework-illegal:server:recieve:boxes', function(Amount)
    local Player = LSCore.Functions.GetPlayer(source)
    Player.Functions.AddItem('oxy-box', Amount, false, false, true)
end)

-- RegisterServerEvent('framework-illegal:server:sell:weed')
-- AddEventHandler('framework-illegal:server:sell:weed', function()
--     if not SellingWeed then
--         SellingWeed = true
--         local Player = LSCore.Functions.GetPlayer(source)
--         for k, v in pairs(Player.PlayerData.inventory) do
--             if Config.SellWeed[v.name] ~= nil then
--                 if Player.Functions.RemoveItem(v.name, v.amount, false, true) then
--                     local WeedAddictionLevel, ExtraAdd = LSCore.Functions.GetAddictionLevel(source, 'weed'), 0
--                     if WeedAddictionLevel == 1 then ExtraAdd = math.random(1,4) elseif WeedAddictionLevel == 2 then ExtraAdd = math.random(3,6) elseif WeedAddictionLevel == 3 then ExtraAdd = math.random(4,7) elseif WeedAddictionLevel == 4 then ExtraAdd = math.random(5,8) end
--                     Player.Functions.AddMoney('cash', (v.amount * Config.SellWeed[v.name]['Price']) + ExtraAdd)
--                 end
--             end
--         end
--         SellingWeed = false
--     else
--         TriggerClientEvent('LSCore:Notify', source, "Er is al iemand aan het verkopen..", "error", 3500)
--     end
-- end)

RegisterNetEvent('framework-illegal:server:sell:weedbrick')
AddEventHandler('framework-illegal:server:sell:weedbrick', function()
    local Player = LSCore.Functions.GetPlayer(source)
    for k, v in pairs(Player.PlayerData.inventory) do
        if v.name == 'weed-brick' then
            if Player.Functions.RemoveItem('weed-brick', v.amount, false, true) then
                Player.Functions.AddMoney('cash', v.amount * 11)
            end
        end
    end
end)

LSCore.Functions.CreateUseableItem("key-a", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-illegal:client:use:key', source, 'key-a')
    end
end)

LSCore.Functions.CreateUseableItem("key-b", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-illegal:client:use:key', source, 'key-b')
    end
end)

LSCore.Functions.CreateUseableItem("key-c", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-illegal:client:use:key', source, 'key-c')
    end
end)

LSCore.Functions.CreateUseableItem('weed_ak47', function(source, item)
    local Player = LSCore.Functions.GetPlayer(source)
    if item.amount >= 20 then
        Player.Functions.RemoveItem('weed_ak47', 20, false, false, true)
        Player.Functions.AddItem('weed-brick', 1, false, false, true)
        Player.Functions.AddItem('empty_weed_bag', math.random(6, 12), false, false, true)
    else
        TriggerClientEvent('LSCore:Notify', source, 'Je hebt niet genoeg wiet..', 'error')
    end
end)

LSCore.Functions.CreateUseableItem('weed_white-widow', function(source, item)
    local Player = LSCore.Functions.GetPlayer(source)
    if item.amount >= 20 then
        Player.Functions.RemoveItem('weed_white-widow', 20, false, false, true)
        Player.Functions.AddItem('weed-brick', 1, false, false, true)
        Player.Functions.AddItem('empty_weed_bag', math.random(6, 12), false, false, true)
    else
        TriggerClientEvent('LSCore:Notify', source, 'Je hebt niet genoeg wiet..', 'error')
    end
end)

RegisterServerEvent('framework-illegal:server:sell:electrnoics')
AddEventHandler('framework-illegal:server:sell:electrnoics', function()
    local Player = LSCore.Functions.GetPlayer(source)
    local StolenTv = Player.Functions.GetItemByName('stolen-tv')
    local StolenMicro = Player.Functions.GetItemByName('stolen-micro')
    local StolenPc = Player.Functions.GetItemByName('stolen-pc')
    if StolenTv ~= nil then
        if Player.Functions.RemoveItem('stolen-tv', 1, false, true) then
            Player.Functions.AddMoney('cash', math.random(250, 300))
        end
    elseif StolenMicro ~= nil then
        if Player.Functions.RemoveItem('stolen-micro', 1, false, true) then
            Player.Functions.AddMoney('cash', math.random(50, 65))
        end
    elseif StolenPc ~= nil then
        if Player.Functions.RemoveItem('stolen-pc', 1, false, true) then
            Player.Functions.AddMoney('cash', math.random(150, 320))
        end
    end
end)

LSCore.Functions.CreateCallback('framework-illegal:server:deliver:oxy', function(source, cb, CurrentSpot)
    local Player = LSCore.Functions.GetPlayer(source)
    if Player.Functions.RemoveItem('oxy-box', 1, false, true) then
        if Config.OxyLocations[CurrentSpot]['Cleaning'] then
            local RollsItem = Player.Functions.GetItemByName('money-roll')
            if RollsItem ~= nil and RollsItem.amount > 7 then
                local RandomRemove = math.random(3, 7)
                if Player.Functions.RemoveItem('money-roll', RandomRemove, false, true) then
                    Player.Functions.AddMoney('cash', (math.random(35, 75) * RandomRemove))
                end
            end
        end
        local RandomValue = math.random(1, 11)
        if RandomValue == 1 then
            Player.Functions.AddItem('advanced_lockpick', 1, false, false, true)
        elseif RandomValue == 2 then
            Player.Functions.AddItem('joint', math.random(1, 2), false, false, true)
        elseif RandomValue == 5 then
            Player.Functions.AddMoney('cash', math.random(135, 175), false, false, true)
        end 
        cb(true)
    else
        cb(false)
    end
end)

-- Selling --

RegisterServerEvent('framework-illegal:server:try:sell:other')
AddEventHandler('framework-illegal:server:try:sell:other', function()
    local RecieveMoney = 0
    local Player = LSCore.Functions.GetPlayer(source)
    local InventoryItems = exports['fw-inv']:GetInventoryItems("Inkoper: 2")
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
            exports['fw-inv']:SetInventoryItems("Inkoper: 2", InventoryItems)
            Player.Functions.AddMoney('cash', RecieveMoney)
        else
            TriggerClientEvent('LSCore:Notify', source, 'Er is niks om te verkopen..', 'error')
        end
    else
        TriggerClientEvent('LSCore:Notify', source, 'Er is niks om te verkopen..', 'error')
    end
end)


-- Labs --

-- Threads

Citizen.CreateThread(function()
    Config.Labs[1]['Coords']['Enter'] = {['X'] = 1510.5024, ['Y'] = 6326.0419, ['Z'] =  24.607133} -- Meth Lab vector3(1510.5024, 6326.0419, 24.607133)
    Config.Labs[2]['Coords']['Enter'] = {['X'] = 550.3272, ['Y'] = 2656.53, ['Z'] = 42.217205} -- Coke Lab
    Config.Labs[3]['Coords']['Enter'] = {['X'] = -1493.63, ['Y'] = 540.65, ['Z'] = 118.27} -- Money Lab
end)

-- Callbacks

LSCore.Functions.CreateCallback('framework-illegal:server:get:config', function(source, cb)
    cb(Config)
end)

LSCore.Functions.CreateCallback('framework-illegal:server:has:drugs', function(source, cb)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    for k, v in pairs(Config.SellDrugs) do
        local DrugsData = Player.Functions.GetItemByName(k)
        if DrugsData ~= nil then
            cb(true)
        end
    end
    cb(false)
end)

LSCore.Functions.CreateCallback('framework-illegal:server:get:drugs:items', function(source, cb)
    local src = source
    local AvailableDrugs = {}
    local Player = LSCore.Functions.GetPlayer(src)
    for k, v in pairs(Config.SellDrugs) do
        local DrugsData = Player.Functions.GetItemByName(k)
        if DrugsData ~= nil then
            table.insert(AvailableDrugs, {['Item'] = DrugsData.name, ['Amount'] = DrugsData.amount})
        end
    end
    cb(AvailableDrugs)
    -- print(AvailableDrugs)
end)

LSCore.Functions.CreateCallback("framework-illegal:server:has:meth:items", function(source, cb)
    local Player = LSCore.Functions.GetPlayer(source)
    if Player ~= nil then
        local ItemBaggy = Player.Functions.GetItemByName('empty_weed_baggy')
        if ItemBaggy ~= nil then
            cb(true)
        else
            if ItemBaggy == nil then
                TriggerClientEvent('LSCore:Notify', source, "Je mist lege zakjes", "error", 4500)
            end
            cb(false)
        end
    end
end)

LSCore.Functions.CreateCallback("framework-illegal:server:has:coke:items", function(source, cb)
    local Player = LSCore.Functions.GetPlayer(source)
    if Player ~= nil then
        local ItemKnife = Player.Functions.GetItemByName('weapon_knife')
        local ItemBrick = Player.Functions.GetItemByName('packed-coke-brick')
        if ItemKnife ~= nil and ItemBrick ~= nil then
            cb(true)
        else
            if ItemKnife == nil then
                TriggerClientEvent('LSCore:Notify', source, "Je mist een mes", "error", 4500)
            elseif ItemBrick == nil then
                TriggerClientEvent('LSCore:Notify', source, "Waar is je coke brick?", "error", 4500)
            end
            cb(false)
        end
    end
end)

-- Events


-- Anti triggers Dennii (ItzHighNL)
RegisterNetEvent('framework-illegal:server:cutting:coke:brick', function()
    local Player = LSCore.Functions.GetPlayer(source)
    TriggerEvent("framework-logs:server:SendLog", "cheaters", "Event Trigger", 'red', "(citizenid: *"..Player.PlayerData.citizenid.."* | name: "..Player.PlayerData.name.." | id: *(" ..src..")* Heeft een event getriggerd welke is omgezet door Dennii om cheaters tegen te gaan (fw-illegal)")
end)

RegisterNetEvent('framework-illegal:server:finish:corner:selling', function(Price, ItemName, ItemAmount)
    local Player = LSCore.Functions.GetPlayer(source)
    TriggerEvent("framework-logs:server:SendLog", "cheaters", "Event Trigger", 'red', "(citizenid: *"..Player.PlayerData.citizenid.."* | name: "..Player.PlayerData.name.." | id: *(" ..src..")* Heeft een event getriggerd welke is omgezet door Dennii om cheaters tegen te gaan (fw-illegal)")
end)

LSCore.Functions.CreateCallback('framework-illegal:server:cutting:coke:brick', function(source, cb)
-- RegisterNetEvent('framework-illegal:server:cutting:coke:brick', function()
    local Player = LSCore.Functions.GetPlayer(source)
    Player.Functions.RemoveItem('packed-coke-brick', 1, false, true)
    Player.Functions.AddItem('coke-powder', math.random(10, 35), false, false, true)
end)

LSCore.Functions.CreateCallback('framework-illegal:server:finish:corner:selling', function(source, cb, Price, ItemName, ItemAmount)
-- RegisterNetEvent('framework-illegal:server:finish:corner:selling', function(Price, ItemName, ItemAmount)
    local Player = LSCore.Functions.GetPlayer(source)
    Player.Functions.RemoveItem(ItemName, ItemAmount, false, true)
    Player.Functions.AddMoney('cash', Price, 'corner-selling')
	-- Player.Functions.SetMetaData("drugs", Player.PlayerData.metadata["drugs"] + 1)
    TriggerEvent('framework-ui:server:addskill', 'drugs', 1)
end)

-- RegisterNetEvent('framework-illegal:server:pickup:order', function()
--     local Player = LSCore.Functions.GetPlayer(source)
--     local RandomValue = math.random(1,3)
--     if RandomValue == 1 then
--         Player.Functions.AddItem('meth-ingredient-2', 1, false, false, true)
--     elseif RandomValue == 2 then
--         Player.Functions.AddItem('packed-coke-brick', 1, false, false, true)
--     elseif RandomValue == 3 then
--         Player.Functions.AddItem('money-paper', 1, false, false, true)
--     end
-- end)

RegisterNetEvent('framework-illegal:server:add:ingredient', function(LabId, IngredientName, Bool, Amount)
    Config.Labs[LabId]['Ingredient-Count'] = Config.Labs[LabId]['Ingredient-Count'] + Amount
    Config.Labs[LabId]['Ingredients'][IngredientName] = Bool
    if Config.Labs[LabId]['Ingredients']['meth-ingredient-1'] and Config.Labs[LabId]['Ingredients']['meth-ingredient-2'] then
        Config.Labs[LabId]['Cooking'] = true
        TriggerClientEvent('framework-illegal:client:start:cooking', -1, LabId)
    end
    TriggerClientEvent('framework-illegal:client:sync:meth', -1, Config.Labs[LabId], LabId, false)
end)

RegisterNetEvent('framework-illegal:server:get:meth', function(RandomAmount, LabId)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    ResetMethLab(LabId)
    Citizen.SetTimeout(150, function()
        Player.Functions.AddItem('meth-powder', RandomAmount, false, false, true)
    end)
end)

RegisterNetEvent('framework-illegal:server:reset:meth', function(LabId)
    ResetMethLab(LabId)
end)

RegisterNetEvent('framework-illegal:server:add:printer:item', function(LabId, ItemType, Amount)
    Config.Labs[LabId][ItemType] = Config.Labs[LabId][ItemType] + Amount
    TriggerClientEvent('framework-illegal:client:sync:items', -1, ItemType, Config.Labs[LabId][ItemType])
end)

RegisterNetEvent('framework-illegal:server:remove:printer:item', function(LabId, ItemType, Amount)
    Config.Labs[LabId][ItemType] = Config.Labs[LabId][ItemType] - Amount
    TriggerClientEvent('framework-illegal:client:sync:items', -1, ItemType, Config.Labs[LabId][ItemType])
end)

RegisterNetEvent('framework-illegal:server:set:printer:money', function(LabId, Amount)
    Config.Labs[LabId]['Total-Money'] = Config.Labs[LabId]['Total-Money'] + Amount
    TriggerClientEvent('framework-illegal:client:sync:money', -1, Config.Labs[LabId]['Total-Money'])
end)

RegisterNetEvent('framework-illegal:server:get:money:printer:money', function()
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    local Money = Config.Labs[3]['Total-Money']
    Player.Functions.AddItem('markedbills', 1, false, {worth = Money})
    Config.Labs[3]['Total-Money'] = 0
    TriggerClientEvent('framework-illegal:client:sync:money', -1, Config.Labs[3]['Total-Money'])
end)

-- Functions

function ResetMethLab(LabId)
    Config.Labs[LabId]['Cooking'] = false
    Config.Labs[LabId]['Ingredients']['meth-ingredient-1'] = false
    Config.Labs[LabId]['Ingredients']['meth-ingredient-2'] = false
    Config.Labs[LabId]['Ingredient-Count'] = 0
    TriggerClientEvent('framework-illegal:client:sync:meth', -1, Config.Labs[LabId], LabId, true)
end

-- Knock Deliveries

RegisterServerEvent('framework-knocky:server:updateDealerItems')
AddEventHandler('framework-knocky:server:updateDealerItems', function(itemData, amount, dealer)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    if Config.Dealers[dealer]["products"][itemData.slot].amount - 1 >= 0 then
        Config.Dealers[dealer]["products"][itemData.slot].amount = Config.Dealers[dealer]["products"][itemData.slot].amount - amount
        TriggerClientEvent('framework-knocky:client:setDealerItems', -1, itemData, amount, dealer)
    else
        Player.Functions.RemoveItem(itemData.name, amount)
        Player.Functions.AddMoney('cash', amount * Config.Dealers[dealer]["products"][itemData.slot].price)

        TriggerClientEvent("LSCore:Notify", _src, "Dit item is niet langer beschikbaar. Je hebt je geld terug gekregen", "error")
    end
end)

RegisterServerEvent('framework-knocky:server:giveDeliveryItems')
AddEventHandler('framework-knocky:server:giveDeliveryItems', function(amount)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)

    Player.Functions.AddItem('weed-brick', amount, false, false, true)
    print(amount)
end)

RegisterServerEvent('framework-knocky:server:succesDelivery')
AddEventHandler('framework-knocky:server:succesDelivery', function(deliveryData, inTime)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    local curRep = Player.PlayerData.metadata['runs']
    if inTime then
        if Player.Functions.GetItemByName('weed-brick') ~= nil and Player.Functions.GetItemByName('weed-brick').amount >= deliveryData["amount"] then
            Player.Functions.RemoveItem('weed-brick', deliveryData["amount"])
            local cops = GetCurrentCops()
            local price = 100
            if cops == 0 then
                price = 3000
            elseif cops == 2 then
                price = 5000
            elseif cops >= 3 then
                price = 5500
            else
                price = 2500
            end
            if curRep < 10 then
                Player.Functions.AddMoney('cash', (deliveryData["amount"] * price / 100 * 1), "delivery-drugs")
            elseif curRep >= 10 then
                Player.Functions.AddMoney('cash', (deliveryData["amount"] * price / 100 * 4), "delivery-drugs")
            elseif curRep >= 20 then
                Player.Functions.AddMoney('cash', (deliveryData["amount"] * price / 100 * 5), "delivery-drugs")
            elseif curRep >= 30 then
                Player.Functions.AddMoney('cash', (deliveryData["amount"] * price / 100 * 6), "delivery-drugs")
            elseif curRep >= 40 then
                Player.Functions.AddMoney('cash', (deliveryData["amount"] * price / 100 * 7), "delivery-drugs")
            elseif curRep >= 100 then
                Player.Functions.AddMoney('cash', (deliveryData["amount"] * price / 100 * 7), "delivery-drugs")
            elseif curRep >= 200 then
                Player.Functions.AddMoney('cash', (deliveryData["amount"] * price / 100 * 7), "delivery-drugs")
            elseif curRep >= 300 then
                Player.Functions.AddMoney('cash', (deliveryData["amount"] * price / 100 * 8), "delivery-drugs")
            elseif curRep >= 350 then
                Player.Functions.AddMoney('cash', (deliveryData["amount"] * price / 100 * 9), "delivery-drugs")
            elseif curRep >= 400 then
                Player.Functions.AddMoney('cash', (deliveryData["amount"] * price / 100 * 10), "delivery-drugs")
            elseif curRep >= 450 then
                Player.Functions.AddMoney('cash', (deliveryData["amount"] * price / 100 * 10), "delivery-drugs")
            elseif curRep >= 500 then
                Player.Functions.AddMoney('cash', (deliveryData["amount"] * price / 100 * 10), "delivery-drugs")
            elseif curRep >= 550 then
                Player.Functions.AddMoney('cash', (deliveryData["amount"] * price / 100 * 10), "delivery-drugs")
            elseif curRep >= 600 then
                Player.Functions.AddMoney('cash', (deliveryData["amount"] * price / 100 * 10), "delivery-drugs")
            elseif curRep >= 650 then
                Player.Functions.AddMoney('cash', (deliveryData["amount"] * price / 100 * 10), "delivery-drugs")
            elseif curRep >= 700 then
                Player.Functions.AddMoney('cash', (deliveryData["amount"] * price / 100 * 10), "delivery-drugs")
            elseif curRep >= 750 then
                Player.Functions.AddMoney('cash', (deliveryData["amount"] * price / 100 * 10), "delivery-drugs")
            elseif curRep >= 1000 then
                Player.Functions.AddMoney('cash', (deliveryData["amount"] * price / 100 * 10), "delivery-drugs")
            elseif curRep >= 1250 then
                Player.Functions.AddMoney('cash', (deliveryData["amount"] * price / 100 * 10), "delivery-drugs")
            elseif curRep >= 1500 then
                Player.Functions.AddMoney('cash', (deliveryData["amount"] * price / 100 * 10), "delivery-drugs")
            elseif curRep >= 2500 then
                Player.Functions.AddMoney('cash', (deliveryData["amount"] * price / 100 * 15), "delivery-drugs")
            elseif curRep >= 3000 then
                Player.Functions.AddMoney('cash', (deliveryData["amount"] * price / 100 * 17), "delivery-drugs")
            elseif curRep >= 3500 then
                Player.Functions.AddMoney('cash', (deliveryData["amount"] * price / 100 * 19), "delivery-drugs")
            end
            Player.Functions.RemoveItem('weed-brick', deliveryData["amount"], false, true, true) 
            TriggerClientEvent('LSCore:Notify', src, 'Order met succes afgeleverd', 'success')
            local change = math.random(1,10)
            if change < 2 then
                if curRep > 200 then
                    Player.Functions.AddItem('burner-phone', math.random(1,2), false, false, true)
                end
            end
            SetTimeout(math.random(5000, 6000), function()
                TriggerClientEvent('framework-knocky:client:sendDeliveryMail', src, 'perfect', deliveryData)
                TriggerEvent('framework-ui:server:addskill', 'runs', 1)
            end)
        else
            TriggerClientEvent('LSCore:Notify', src, 'Je order matched niet met je spullen', 'error')

            if Player.Functions.GetItemByName('weed-brick').amount >= 0 then
                Player.Functions.RemoveItem('weed-brick', Player.Functions.GetItemByName('weed-brick').amount)
                Player.Functions.AddMoney('cash', (Player.Functions.GetItemByName('weed-brick').amount * 1000 / 100 * 3))
            end

            Player.Functions.RemoveItem('weed-brick', amount, false, true) 

            SetTimeout(math.random(3000, 8000), function()
                TriggerClientEvent('framework-knocky:client:sendDeliveryMail', src, 'bad', deliveryData)
                TriggerEvent('framework-ui:server:removeskill', 'runs', 1)
            end)
        end
    else
        TriggerClientEvent('LSCore:Notify', src, 'Je bent te laat', 'error')

        Player.Functions.RemoveItem('weed-brick', deliveryData["amount"])
        Player.Functions.AddMoney('cash', (deliveryData["amount"] * 1000 / 100 * math.random(1,2)), "delivery-drugs-too-late")

        Player.Functions.RemoveItem('weed-brick', amount, false, true) 

        SetTimeout(math.random(5000, 10000), function()
            TriggerClientEvent('framework-knocky:client:sendDeliveryMail', src, 'late', deliveryData)
            TriggerEvent('framework-ui:server:removeskill', 'runs', 1)
        end)
    end
end)

function GetCurrentCops()
    local amount = 0
    for k, v in pairs(LSCore.Functions.GetPlayers()) do
        local Player = LSCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                amount = amount + 1
            end
        end
    end
    return amount
end

LSCore.Commands.Add("setdealer", "Plaats een Dealer", {
    {name = "name", help = "Dealer's Name"},
    {name = "min", help = "Minimum Time"},
    {name = "max", help = "Maximum Time"},
}, true, function(source, args)
    local dealerName = args[1]
    local mintime = tonumber(args[2])
    local maxtime = tonumber(args[3])

    TriggerClientEvent('framework-knocky:client:CreateDealer', source, dealerName, mintime, maxtime)
end, "admin")

LSCore.Commands.Add("removedealer", "Verwijder een Dealer", {
    {name = "name", help = "Dealer's Naam"},
}, true, function(source, args)
    local dealerName = args[1]
    
    LSCore.Functions.ExecuteSql(false, "SELECT * FROM `server_dealers` WHERE `name` = '"..dealerName.."'", function(result)
        if result[1] ~= nil then
            LSCore.Functions.ExecuteSql(false, "DELETE FROM `server_dealers` WHERE `name` = '"..dealerName.."'")
            Config.Dealers[dealerName] = nil
            TriggerClientEvent('framework-knocky:client:RefreshDealers', -1, Config.Dealers)
            TriggerClientEvent('LSCore:Notify', source, "You removed "..dealerName.." !", "success")
        else
            TriggerClientEvent('LSCore:Notify', source, "Dealer "..dealerName.." does not exist..", "error")
        end
    end)
end, "admin")

LSCore.Commands.Add("dealers", "Get an overview of all Dealers", {}, false, function(source, args)
    local DealersText = ""
    if Config.Dealers ~= nil and next(Config.Dealers) ~= nil then
        for k, v in pairs(Config.Dealers) do
            DealersText = DealersText .. "Naam: " .. v["name"] .. "<br>"
        end
        TriggerClientEvent('chat:addMessage', source, {
            template = '<div class="chat-message advert"><div class="chat-message-body"><strong>Alle dealers: </strong><br><br> '..DealersText..'</div></div>',
            args = {}
        })
    else
        TriggerClientEvent('LSCore:Notify', source, 'Er zijn geen dealers', 'error')
    end
end, "admin")

LSCore.Commands.Add("dealergoto", "TP naar dealer.", {{name = "name", help = "Dealer's Naam"}}, true, function(source, args)
    local DealerName = tostring(args[1])

    if Config.Dealers[DealerName] ~= nil then
        TriggerClientEvent('framework-knocky:client:GotoDealer', source, Config.Dealers[DealerName])
    else
        TriggerClientEvent('LSCore:Notify', source, 'Bestoat niet', 'error')
    end
end, "admin")

Citizen.CreateThread(function()
    Wait(500)
    LSCore.Functions.ExecuteSql(false, "SELECT * FROM `server_dealers`", function(dealers)
        if dealers[1] ~= nil then
            for k, v in pairs(dealers) do
                local coords = json.decode(v.coords)
                local time = json.decode(v.time)

                Config.Dealers[v.name] = {
                    ["name"] = v.name,
                    ["coords"] = {
                        ["x"] = coords.x,
                        ["y"] = coords.y,
                        ["z"] = coords.z,
                    },
                    ["time"] = {
                        ["min"] = time.min,
                        ["max"] = time.max,
                    },
                    ["products"] = Config.Products,
                }
            end
        end
        TriggerClientEvent('framework-knocky:client:RefreshDealers', -1, Config.Dealers)
    end)
end)

RegisterServerEvent('framework-knocky:server:CreateDealer')
AddEventHandler('framework-knocky:server:CreateDealer', function(DealerData)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)

    LSCore.Functions.ExecuteSql(false, "SELECT * FROM `server_dealers` WHERE `name` = '"..DealerData.name.."'", function(result)
        if result[1] ~= nil then
            TriggerClientEvent('LSCore:Notify', src, "Er is al een dealer met deze noam", "error")
        else
            LSCore.Functions.ExecuteSql(false, "INSERT INTO `server_dealers` (`name`, `coords`, `time`, `createdby`) VALUES ('"..DealerData.name.."', '"..json.encode(DealerData.pos).."', '"..json.encode(DealerData.time).."', '"..Player.PlayerData.citizenid.."')", function()
                Config.Dealers[DealerData.name] = {
                    ["name"] = DealerData.name,
                    ["coords"] = {
                        ["x"] = DealerData.pos.x,
                        ["y"] = DealerData.pos.y,
                        ["z"] = DealerData.pos.z,
                    },
                    ["time"] = {
                        ["min"] = DealerData.time.min,
                        ["max"] = DealerData.time.max,
                    },
                    ["products"] = Config.Products,
                }

                TriggerClientEvent('framework-knocky:client:RefreshDealers', -1, Config.Dealers)
            end)
        end
    end)
end)

function GetDealers()
    return Config.Dealers
end


RegisterServerEvent('framework-houserobbery:server:set:door:state')
AddEventHandler('framework-houserobbery:server:set:door:state', function(HouseId, Bool)
    Config.Houses[HouseId]['DoorState'] = Bool
    TriggerClientEvent('framework-houserobbery:client:sync:data', -1, HouseId, Config.Houses[HouseId])
end)

RegisterServerEvent('framework-houserobbery:server:set:cabin:state')
AddEventHandler('framework-houserobbery:server:set:cabin:state', function(HouseId, CabinId, Type, Bool)
    Config.Houses[HouseId]['Cabins'][CabinId][Type] = Bool
    if Type == 'Open' and Bool then
        local Count = 0
        for k, v in pairs(Config.Houses[HouseId]['Cabins']) do
            if v['Open'] then
                Count = Count + 1
            end
        end
        if Count == #Config.Houses[HouseId]['Cabins'] then
            TriggerClientEvent('framework-houseobbery:client:next:leave:stop:job', source)
        end
    end
    TriggerClientEvent('framework-houserobbery:client:sync:data', -1, HouseId, Config.Houses[HouseId])
end)

RegisterServerEvent('framework-houserobbery:server:set:house:busy')
AddEventHandler('framework-houserobbery:server:set:house:busy', function(HouseId, Bool)
    local src = source
    Config.Houses[HouseId]['Busy'] = Bool
    TriggerClientEvent('framework-houserobbery:client:sync:data', -1, HouseId, Config.Houses[HouseId])
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
        TriggerClientEvent('framework-houserobbery:client:stop:job', src)
        TriggerClientEvent('framework-houserobbery:client:sync:data', -1, HouseId, Config.Houses[HouseId])
    end)
end)

-- Anti triggers Dennii (ItzHighNL)
RegisterServerEvent('framework-houserobbery:server:get:house:reward')
AddEventHandler('framework-houserobbery:server:get:house:reward', function()
    local Player = LSCore.Functions.GetPlayer(source)
    TriggerEvent("framework-logs:server:SendLog", "cheaters", "Event Trigger", 'red', "(citizenid: *"..Player.PlayerData.citizenid.."* | name: "..Player.PlayerData.name.." | id: *(" ..src..")* Heeft een event getriggerd welke is omgezet door Dennii om cheaters tegen te gaan")
end)

RegisterServerEvent('framework-houserobbert:server:add:steal:item')
AddEventHandler('framework-houserobbert:server:add:steal:item', function(Type)
    local Player = LSCore.Functions.GetPlayer(source)
    TriggerEvent("framework-logs:server:SendLog", "cheaters", "Event Trigger", 'red', "(citizenid: *"..Player.PlayerData.citizenid.."* | name: "..Player.PlayerData.name.." | id: *(" ..src..")* Heeft een event getriggerd welke is omgezet door Dennii om cheaters tegen te gaan")
end)

LSCore.Functions.CreateCallback('framework-houserobbery:server:get:house:reward', function(source, cb)
    local RandomValue = math.random(1,100)
    local Player = LSCore.Functions.GetPlayer(source)
    Player.Functions.AddMoney('cash', math.random(20, 80), "House Robbery")
    if RandomValue >= 0 and RandomValue <= 15 then
        Player.Functions.AddMoney('cash', math.random(250, 450), "House Robbery")
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

LSCore.Functions.CreateCallback('framework-houserobbery:server:add:steal:item', function(source, cb, Type)
-- RegisterServerEvent('framework-houserobbert:server:add:steal:item')
-- AddEventHandler('framework-houserobbert:server:add:steal:item', function(Type)
    local Player = LSCore.Functions.GetPlayer(source)
    if Type == 'Tv' then
        Player.Functions.AddItem('stolen-tv', 1, false, false, true)
    elseif Type == 'Micro' then
        Player.Functions.AddItem('stolen-micro', 1, false, false, true)
    end
end)