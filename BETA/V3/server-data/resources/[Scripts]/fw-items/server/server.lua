local LSCore = exports['fw-base']:GetCoreObject()

-- Code

-- // Lockpick \\ --
LSCore.Functions.CreateUseableItem("advancedlockpick", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-items:client:use:lockpick', source, true)
    end
end)

LSCore.Functions.CreateUseableItem("lockpick", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-items:client:use:lockpick', source, false)
    end
end)

LSCore.Functions.CreateUseableItem("drill", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-items:client:use:drill', source)
    end
end)

-- // Eten \\ --

LSCore.Functions.CreateUseableItem("water_bottle", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-items:client:drink', source, 'water_bottle', 'water')
    end
end)

LSCore.Functions.CreateUseableItem("kurkakola", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-items:client:drink', source, 'kurkakola', 'cola')
    end
end)

LSCore.Functions.CreateUseableItem("sprunk", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-items:client:drink', source, 'sprunk', 'cola')
    end
end)

LSCore.Functions.CreateUseableItem("slushy", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-items:client:drink:slushy', source)
    end
end)

LSCore.Functions.CreateUseableItem("sandwich", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-items:client:eat', source, 'sandwich', 'sandwich')
    end
end)

LSCore.Functions.CreateUseableItem("chocolade", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-items:client:eat', source, 'chocolade', 'chocolade')
    end
end)

LSCore.Functions.CreateUseableItem("420-choco", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-items:client:eat', source, '420-choco', 'chocolade')
    end
end)

LSCore.Functions.CreateUseableItem("donut", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-items:client:eat', source, 'donut', 'donut')
    end
end)

LSCore.Functions.CreateUseableItem("coffee", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-items:client:drink', source, 'coffee', 'coffee')
    end
end)

LSCore.Functions.CreateUseableItem("chips", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-items:client:eat', source, 'chips', 'chips')
    end
end)

LSCore.Functions.CreateUseableItem("macncheese", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-items:client:eat', source, 'macncheese', 'macncheese')
    end
end)

LSCore.Functions.CreateUseableItem("apple", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-items:client:eat:fruit', source, 'apple', 'apple')
    end
end)

LSCore.Functions.CreateUseableItem("banana", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-items:client:eat:fruit', source, 'banana', 'banana')
    end
end)

LSCore.Functions.CreateUseableItem("sushi", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-items:client:eat', source, 'sushi', 'sushi-box')
    end
end)

LSCore.Functions.CreateUseableItem("sushi-ramen", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-items:client:eat', source, 'sushi-ramen', 'sushi-box')
    end
end)

LSCore.Functions.CreateUseableItem("sushi-beef", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-items:client:eat', source, 'sushi-beef', 'sushi-box')
    end
end)

LSCore.Functions.CreateUseableItem("sushi-tea", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-items:client:drink', source, 'sushi-tea', 'tea')
    end
end)

-- BurgerShot

LSCore.Functions.CreateUseableItem("burger-bleeder", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-items:client:eat', source, 'burger-bleeder', 'hamburger')
    end
end)

LSCore.Functions.CreateUseableItem("burger-moneyshot", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-items:client:eat', source, 'burger-moneyshot', 'hamburger')
    end
end)

LSCore.Functions.CreateUseableItem("burger-torpedo", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-items:client:eat', source, 'burger-torpedo', 'hamburger')
    end
end)

LSCore.Functions.CreateUseableItem("burger-heartstopper", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-items:client:eat', source, 'burger-heartstopper', 'hamburger')
    end
end)

LSCore.Functions.CreateUseableItem("burger-softdrink", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-items:client:drink', source, 'burger-softdrink', 'burger-soft')
    end
end)

LSCore.Functions.CreateUseableItem("burger-fries", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-items:client:eat', source, 'burger-fries', 'burger-fries')
    end
end)

LSCore.Functions.CreateUseableItem("burger-box", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-burgershot:client:open:box', source, item.info.boxid)
    end
end)

LSCore.Functions.CreateUseableItem("burger-coffee", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-items:client:drink', source, 'burger-coffee', 'coffee')
    end
end)

-- // Other \\ --

LSCore.Functions.CreateUseableItem("duffel-bag", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-items:client:use:duffel-bag', source, item.info.bagid)
    end
end)

LSCore.Functions.CreateUseableItem("burger-box", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-jobmanager:client:open:box', source, item.info.boxid)
    end
end)

LSCore.Functions.CreateUseableItem("armor", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-items:client:use:armor', source)
    end
end)

LSCore.Functions.CreateUseableItem("heavyarmor", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-items:client:use:heavy', source)
    end
end)

LSCore.Functions.CreateUseableItem("repairkit", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-items:client:use:repairkit', source)
    end
end)

LSCore.Functions.CreateUseableItem("tirekit", function(source, item)
    local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("framework-items:client:use:tirekit", source)
    end
end)

LSCore.Functions.CreateUseableItem("bandage", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-hospital:client:use:bandage', source)
    end
end)

LSCore.Functions.CreateUseableItem("health-pack", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-hospital:client:use:health-pack', source)
    end
end)

LSCore.Functions.CreateUseableItem("painkillers", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-hospital:client:use:painkillers', source)
    end
end)

LSCore.Functions.CreateUseableItem("joint", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-items:client:use:joint', source)
    end
end)

LSCore.Functions.CreateUseableItem("coke-bag", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-items:client:use:coke', source)
    end
end)

LSCore.Functions.CreateUseableItem("lsd-strip", function(source, item)
    local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("framework-items:client:use:lsd", source)
    end
end)

LSCore.Functions.CreateUseableItem("coin", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-items:client:coinflip', source)
    end
end)

-- Weed

LSCore.Functions.CreateUseableItem("weed-nutrition", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-houseplants:client:feed:plants', source)
    end
end)

LSCore.Functions.CreateUseableItem("weed_white-widow_seed", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-houseplants:client:plant', source, 'White Widow', 'White-Widow', 'weed_white-widow_seed')
    end
end)

LSCore.Functions.CreateUseableItem("weed_skunk_seed", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-houseplants:client:plant', source, 'Skunk', 'Skunk', 'weed_skunk_seed')
    end
end)

LSCore.Functions.CreateUseableItem("weed_purple-haze_seed", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-houseplants:client:plant', source, 'Purple Haze', 'Purple-Haze', 'weed_purple-haze_seed')
    end
end)

LSCore.Functions.CreateUseableItem("weed_og-kush_seed", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-houseplants:client:plant', source, 'Og Kush', 'Og-Kush', 'weed_og-kush_seed')
    end
end)

LSCore.Functions.CreateUseableItem("weed_amnesia_seed", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-houseplants:client:plant', source, 'Amnesia', 'Amnesia', 'weed_amnesia_seed')
    end
end)

LSCore.Functions.CreateUseableItem("weed_ak47_seed", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-houseplants:client:plant', source, 'AK47', 'AK47', 'weed_ak47_seed')
    end
end)

-- Fishing

LSCore.Functions.CreateUseableItem("fish-crate", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-fishing:client:use:box', source, 'fish-crate')
    end
end)

LSCore.Functions.CreateUseableItem("fish-box", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-fishing:client:use:box', source, 'fish-box')
    end
end)

-- Lighter

LSCore.Functions.CreateUseableItem("lighter", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-items:client:use:lighter', source)
        if math.random(1, 100) <= 21 then
            Player.Functions.RemoveItem('lighter', 1)
            TriggerClientEvent('LSCore:Notify', source, "Je aansteker brak sukkel..", "error", 3500)
        end
    end
end)

LSCore.Functions.CreateUseableItem("binoculars", function(source, item)
    local Player = LSCore.Functions.GetPlayer(source)
    TriggerClientEvent("framework-items:binoculars:toggle", source)
end)

LSCore.Functions.CreateUseableItem("camera", function(source, item)
    local Player = LSCore.Functions.GetPlayer(source)
    TriggerClientEvent("framework-items:camera:toggle", source)
end)

LSCore.Functions.CreateUseableItem("explosive", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-items:client:use:explosive', source)
    end
end)

LSCore.Functions.CreateUseableItem("black-card", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-items:client:use:black-card', source)
    end
end)

LSCore.Functions.CreateUseableItem("pickaxe", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-jobmanager:client:use:pickaxe', source)
    end
end)

LSCore.Functions.CreateUseableItem("mine-scanner", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-jobmanager:client:use:scanner', source)
    end
end)

LSCore.Functions.CreateUseableItem("rose", function(source)
    local Player = LSCore.Functions.GetPlayer(source)
    TriggerClientEvent('animations:client:EmoteCommandStart', source, {"rose"})
end)

LSCore.Functions.CreateUseableItem("teddy", function(source)
    local Player = LSCore.Functions.GetPlayer(source)
    TriggerClientEvent('animations:client:EmoteCommandStart', source, {"teddy"})
end)

LSCore.Functions.CreateUseableItem("umbrella", function(source)
    local Player = LSCore.Functions.GetPlayer(source)
    TriggerClientEvent('animations:client:EmoteCommandStart', source, {"umbrella"})
end)

LSCore.Functions.CreateUseableItem("heavy-thermite", function(source, item)
    TriggerClientEvent("framework-items:client:use:heavy-thermite", source)
end)

LSCore.Functions.CreateUseableItem("scuba-gear", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-items:client:put:scuba:on', source, item.info.air)
    end
end)

LSCore.Functions.CreateUseableItem("nitrous", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-vehicles:client:use:nitrous', source)
    end
end)

LSCore.Functions.CreateUseableItem("wheelchair", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-items:client:use:wheelchair', source)
    end
end)

LSCore.Functions.CreateUseableItem("cocktail-1", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-items:client:drink', source, 'cocktail-1', 'cocktail')
    end
end)

LSCore.Functions.CreateUseableItem("cocktail-2", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-items:client:drink', source, 'cocktail-2', 'cocktail')
    end
end)

LSCore.Functions.CreateUseableItem("cocktail-3", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-items:client:drink', source, 'cocktail-3', 'cocktail')
    end
end)

LSCore.Functions.CreateUseableItem("walkstick", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-items:client:walkstick', source)
    end
end)

LSCore.Functions.CreateUseableItem("jerry_can", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-items:client:jerry_can', source)
    end
end)

LSCore.Functions.CreateUseableItem("moneybag", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        if Player.PlayerData.job.name ~= 'police' then
            Player.Functions.RemoveItem('moneybag', 1, item.slot, true)
            Player.Functions.AddMoney('cash', item.info.worth)
        end
    end
end)

LSCore.Functions.CreateUseableItem("rentalpapers", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-vehicles:client:recieve:extra:keys', source, item.info.plate)
    end
end)

-- // Hunting \\ --

LSCore.Functions.CreateUseableItem("hunting-bait", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-jobmanager:client:use:bait', source)
    end
end)

LSCore.Functions.CreateUseableItem("hunting-knife", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('framework-jobmanager:client:use:knife', source)
    end
end)

LSCore.Functions.CreateUseableItem("sheer", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        if Player.PlayerData.job.name == 'police' then
            TriggerClientEvent('framework-houseplants:client:use:sheer', source)
        end
    end
end)

LSCore.Functions.CreateUseableItem("parachute", function(source, item)
    local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("framework-items:client:use:parachute", source)
    end
end)

LSCore.Functions.CreateUseableItem("handcuffs", function(source, item)
    local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("framework-police:client:cuff:closest", source)
    end
end)

LSCore.Functions.CreateUseableItem("policepass", function(source, item)
    local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("framework-police:client:show:closest:id", source, item.info)
    end
end)

LSCore.Functions.CreateUseableItem("mask", function(source, item)
    local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("framework-items:client:add:facewear", source, 'mask', item.info, item.slot)
    end
end)

LSCore.Functions.CreateUseableItem("hat", function(source, item)
    local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("framework-items:client:add:facewear", source, 'hat', item.info, item.slot)
    end
end)

LSCore.Functions.CreateUseableItem("glasses", function(source, item)
    local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("framework-items:client:add:facewear", source, 'glasses', item.info, item.slot)
    end
end)

LSCore.Functions.CreateUseableItem("hairtie", function(source, item)
    local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("framework-items:client:use:hairtie", source)
    end
end)

LSCore.Functions.CreateUseableItem("id_card", function(source, item)
    local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("framework-items:client:show:id", -1, source, nil, item.info)
    end
end)

LSCore.Functions.CreateUseableItem("driver_license", function(source, item)
    local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("framework-items:client:show:driver", -1, source, nil, item.info)
    end
end)

LSCore.Commands.Add("dobbel", "Lekker dobbelen", {{name="aantal", help="Aantal dobbelsteentjes"}, {name="zijdes", help="Aantal zijdes van dobbelsteentje"}}, true, function(source, args)
    local Player = LSCore.Functions.GetPlayer(source)
    local DiceItems = Player.Functions.GetItemByName("dice")
    if args[1] ~= nil and args[2] ~= nil then 
      local Amount = tonumber(args[1])
      local Sides = tonumber(args[2])
      if DiceItems ~= nil then
         if (Sides > 0 and Sides <= 20) and (Amount > 0 and Amount <= 5) then 
             TriggerClientEvent('framework-items:client:dobbel', source, Amount, Sides)
         else
             TriggerClientEvent('LSCore:Notify', source, "Teveel aantal kanten of 0 (max: 5) of teveel aantal dobbelstenen of 0 (max: 20)", "error", 3500)
         end
      else
        TriggerClientEvent('LSCore:Notify', source, "Je hebt geen eens dobbelstenen..", "error", 3500)
      end
  end
end)

LSCore.Commands.Add("parachuteuit", "Doe je parachute uit", {}, false, function(source, args)
    TriggerClientEvent("framework-items:client:reset:parachute", source)
end)

LSCore.Commands.Add("vestuit", "Doe je vest uit", {}, false, function(source, args)
    local Player = LSCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        TriggerClientEvent("framework-items:client:reset:armor", source)
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Dit command is voor hulpdiensten!")
    end
end)

LSCore.Commands.Add("duikpakuit", "Doe je duikpak uit", {}, false, function(source, args)
    TriggerClientEvent('framework-items:client:takeoff:scuba', source)
end)

LSCore.Commands.Add("helm", "Zet je hoed af..", {}, false, function(source, args)
    TriggerClientEvent("framework-items:client:remove:facewear", source, 'hat')
end)

LSCore.Commands.Add("bril", "Zet je bril af..", {}, false, function(source, args)
	TriggerClientEvent("framework-items:client:remove:facewear", source, 'glasses')
end)

LSCore.Commands.Add("masker", "Zet je masker af..", {}, false, function(source, args)
	TriggerClientEvent("framework-items:client:remove:facewear", source, 'mask')
end)

RegisterServerEvent('framework-items:server:recieve:clothing')
AddEventHandler('framework-items:server:recieve:clothing', function(Type, Palette, Texture, Prop)
    local Player = LSCore.Functions.GetPlayer(source)
    if Type == 'mask' then
        Player.Functions.AddItem('mask', 1, false, {palette = Palette, texture = Texture, prop = Prop}, true)
    elseif Type == 'hat' then
        Player.Functions.AddItem('hat', 1, false, {palette = Palette, texture = Texture, prop = Prop}, true)
    elseif Type == 'glasses' then
        Player.Functions.AddItem('glasses', 1, false, {palette = Palette, texture = Texture, prop = Prop}, true)
    end
end)

RegisterServerEvent('framework-items:server:return:heavy:armor')
AddEventHandler('framework-items:server:return:heavy:armor', function()
    local Player = LSCore.Functions.GetPlayer(source)
    Player.Functions.AddItem('heavyarmor', 1, false, false, true)
end)

RegisterServerEvent('framework-items:server:resturn:scuba')
AddEventHandler('framework-items:server:resturn:scuba', function(CurrentAir)
    local Player = LSCore.Functions.GetPlayer(source)
    local Info = {air = CurrentAir}
    Player.Functions.AddItem('scuba-gear', 1, false, Info, true)
end)

RegisterServerEvent('framework-items:server:return:wheelchair')
AddEventHandler('framework-items:server:return:wheelchair', function()
    local Player = LSCore.Functions.GetPlayer(source)
    Player.Functions.AddItem('wheelchair', 1, false, false, true)
end)

RegisterServerEvent('framework-items:server:add:addiction:weed')
AddEventHandler('framework-items:server:add:addiction:weed', function()
    local Player = LSCore.Functions.GetPlayer(source)
    local RandomValue = math.random(1, 100)
    if RandomValue == 25 or RandomValue == 20 or RandomValue == 50 or RandomValue == 70 or RandomValue == 75 or RandomValue == 80 or RandomValue == 100 then
        Player.Functions.AddAddiction('weed', 1)
    end
end)

RegisterServerEvent('framework-items:server:add:lucky')
AddEventHandler('framework-items:server:add:lucky', function()
    local Player = LSCore.Functions.GetPlayer(source)
    Player.Functions.SetMetaData("lucky", true)
end)