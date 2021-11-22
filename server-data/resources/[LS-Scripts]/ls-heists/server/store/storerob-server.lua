-- // Store Robbery \\ --

LSCore.Functions.CreateCallback('ls-storerobbery:server:HasItem', function(source, cb, itemName)
    local Player = LSCore.Functions.GetPlayer(source)
    local Item = Player.Functions.GetItemByName(itemName)
	if Player ~= nil then
        if Item ~= nil then
			cb(true)
        else
			cb(false)
        end
	end
end)

RegisterServerEvent('ls-storerobbery:server:set:register:robbed')
AddEventHandler('ls-storerobbery:server:set:register:robbed', function(RegisterId, bool)
    if RegisterId ~= nil then
        Config.Registers[RegisterId]['Robbed'] = bool
        TriggerClientEvent('ls-storerobbery:client:sync:registers', -1, RegisterId, Config.Registers[RegisterId])
        SetTimeout((1000 * 60) * 10, function()
            Config.Registers[RegisterId]['Robbed'] = false
            TriggerClientEvent('ls-storerobbery:client:sync:registers', -1, RegisterId, Config.Registers[RegisterId])
        end)
    end
end)

RegisterServerEvent('ls-storerobbery:server:safe:busy')
AddEventHandler('ls-storerobbery:server:safe:busy', function(SafeId, bool)
    Config.Safes[SafeId]['Busy'] = bool
    TriggerClientEvent('ls-storerobbery:client:sync:safes', -1, SafeId, Config.Safes[SafeId])
end)

RegisterServerEvent('ls-storerobbery:server:safe:robbed')
AddEventHandler('ls-storerobbery:server:safe:robbed', function(SafeId, bool)
    Config.Safes[SafeId]['Robbed'] = bool
    TriggerClientEvent('ls-storerobbery:client:sync:safes', -1, SafeId, Config.Safes[SafeId])
    SetTimeout((1000 * 60) * 25, function()
        TriggerClientEvent('ls-storerobbery:client:sync:safes', -1, SafeId, Config.Safes[SafeId])
        Config.Safes[SafeId]['Robbed'] = false
    end)
end)

RegisterServerEvent('ls-storerobbery:server:rob:register:new')
AddEventHandler('ls-storerobbery:server:rob:register:new', function(RegisterId, IsDone)
    local Player = LSCore.Functions.GetPlayer(source)
    Player.Functions.AddMoney('cash', math.random(250, 450), "Store Robbery")
    local RandomItem = Config.CardTypes[math.random(#Config.CardTypes)]
    local RandomValue = math.random(1, 100)
    if RandomValue <= 12 then
        Player.Functions.AddItem(RandomItem, 1, false, false, true)
    end
    Player.Functions.AddItem('money-roll', math.random(5, 15), false, false, true)
end)

RegisterServerEvent('ls-storerobbery:server:safe:reward:new:new')
AddEventHandler('ls-storerobbery:server:safe:reward:new:new', function()
    local Player = LSCore.Functions.GetPlayer(source)
    local RandomItem = Config.CardTypes[math.random(#Config.CardTypes)]
    Player.Functions.AddMoney('cash', math.random(800, 1000), "Safe Robbery")
    Player.Functions.AddItem('money-roll', math.random(7, 15), false, false, true)
    local RandomValue = math.random(1,100)
    if RandomValue <= 25 then
        Player.Functions.AddItem("rolex", math.random(2,4), false, false, true)
    elseif RandomValue >= 35 and RandomValue <= 55 then
        Player.Functions.AddItem(RandomItem, 1, false, false, true)
    end
end)