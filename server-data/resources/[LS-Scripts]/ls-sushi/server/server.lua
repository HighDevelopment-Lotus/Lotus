local LSCore = exports['ls-core']:GetCoreObject()

-- Code

LSCore.Functions.CreateCallback('ls-sushi:server:get:config', function(source, cb)
    cb(Config)
end)

RegisterServerEvent('ls-sushi:server:add:to:register')
AddEventHandler('ls-sushi:server:add:to:register', function(Price, Note)
    local RandomID = math.random(1111,9999)
    Config.RegisterData[RandomID] = {['Price'] = Price, ['Note'] = Note}
    TriggerClientEvent('ls-sushi:client:sync:register', -1, RandomID, Config.RegisterData[RandomID])
end)

RegisterServerEvent('ls-sushi:server:pay:receipt')
AddEventHandler('ls-sushi:server:pay:receipt', function(Data)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    if Player.Functions.RemoveMoney('cash', Data['Price'], 'burger-shot') then
        if Config.RegisterData[tonumber(Data['BillId'])] ~= nil then
            Config.RegisterData[tonumber(Data['BillId'])] = nil
            TriggerEvent('ls-sushi:give:receipt:to:workers')
            TriggerClientEvent('ls-sushi:client:sync:register', -1, Data['BillId'], nil)
        else
            TriggerClientEvent('LSCore:Notify', src, 'Error..', 'error')
        end
    else
        TriggerClientEvent('LSCore:Notify', src, 'Je hebt niet genoeg contant geld..', 'error')
    end
end)

RegisterServerEvent('ls-sushi:give:receipt:to:workers')
AddEventHandler('ls-sushi:give:receipt:to:workers', function()
    for k, v in pairs(LSCore.Functions.GetPlayers()) do
        local Player = LSCore.Functions.GetPlayer(v)
        if Player ~= nil and Player.PlayerData.job.name == 'sushi' and Player.PlayerData.job.onduty then
            Player.Functions.AddItem('burger-ticket', 1, false, false, true)
        end
    end
end)

RegisterServerEvent('ls-sushi:server:create:food')
AddEventHandler('ls-sushi:server:create:food', function(FoodName)
    local Player = LSCore.Functions.GetPlayer(source)
    if FoodName == 'sushi' then
        Player.Functions.RemoveItem('water_bottle', 1, false, false)
        Player.Functions.RemoveItem('sushi-rice', 1, false, false)
        Player.Functions.AddItem(FoodName, 1, false, false, true)
    elseif FoodName == 'sushi-beef' then
        Player.Functions.RemoveItem('hunting-beef', 1, false, false)
        Player.Functions.RemoveItem('sushi-noodle', 1, false, false)
        Player.Functions.AddItem(FoodName, 1, false, false, true)
    elseif FoodName == 'sushi-ramen' then
        Player.Functions.RemoveItem('hunting-beef', 1, false, false)
        Player.Functions.RemoveItem('sushi-noodle', 1, false, false)
        Player.Functions.RemoveItem('water_bottle', 1, false, false)
        Player.Functions.AddItem(FoodName, 1, false, false, true)
    end
end)

RegisterServerEvent('ls-sushi:server:create:tea')
AddEventHandler('ls-sushi:server:create:tea', function()
    local Player = LSCore.Functions.GetPlayer(source)
    Player.Functions.AddItem('sushi-tea', 1, false, false, true)
end)