local LSCore = exports['ls-core']:GetCoreObject()

LSCore.Functions.CreateCallback('ls-tables:server:finish', function(source, cb, type)
    local Player = LSCore.Functions.GetPlayer(source)
    local RandomMath = math.random(0,100)
    local Total = 2
    local Item = nil

    if type == 'Crack' then
        Item = Config.Tables['Crack']['ItemAfterProcess']
    elseif type == 'Weed' then
        Item = Config.Tables['Weed']['ItemAfterProcess']
    elseif type == 'Meth' then
        Item = Config.Tables['Meth']['ItemAfterProcess']
    end


    if RandomMath >= 90 then
        Total = 9
    elseif RandomMath <= 10 then
        Total = 2
    elseif RandomMath >= 50 then
        Total = 5
    elseif RandomMath == 20 then
        Total = 8
    end
    
    Player.Functions.AddItem(Item, 5, false, nil, true)
    
end)

LSCore.Functions.CreateCallback('ls-tables:server:get:item:amount', function(source, cb, item, amount)
    local Item = item
    local Amount = amount

    local Player = LSCore.Functions.GetPlayer(source)

    if Player.Functions.GetItemByName(Item) ~= nil then
        if Player.Functions.GetItemByName(Item).amount >= Amount then
            cb(true)
        else
            cb(false)
        end
    else
        cb(false)
    end
end)

LSCore.Functions.CreateUseableItem("cracktable", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('ls-tables:client:place:table', source, 'Meth')
    end
end)

LSCore.Functions.CreateUseableItem("weedtable", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('ls-tables:client:place:table', source), 'Meth'
    end
end)

LSCore.Functions.CreateUseableItem("methtable", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('ls-tables:client:place:table', source, 'Meth')
    end
end)

