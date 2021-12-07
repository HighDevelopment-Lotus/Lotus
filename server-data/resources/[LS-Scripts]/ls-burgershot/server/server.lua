local LSCore = exports['ls-core']:GetCoreObject()

-- Code

LSCore.Functions.CreateCallback('ls-burgershot:server:has:burger:items', function(source, cb)
    local Count = 0
    local Player = LSCore.Functions.GetPlayer(source)
    for k, v in pairs(Config.BurgerItems) do
        local BurgerData = Player.Functions.GetItemByName(v)
        if BurgerData ~= nil then
           Count = Count + 1
        end
    end
    if Count == 3 then
        cb(true)
    else
        cb(false)
    end 
end)

RegisterServerEvent('ls-burgershot:server:finish:burger')
AddEventHandler('ls-burgershot:server:finish:burger', function(BurgerName)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    for k, v in pairs(Config.BurgerItems) do
        Player.Functions.RemoveItem(v, 1, false, true)
    end
    Citizen.SetTimeout(350, function()
        Player.Functions.AddItem(BurgerName, 1, false, false, true)
    end)
end)

RegisterServerEvent('ls-burgershot:server:finish:fries')
AddEventHandler('ls-burgershot:server:finish:fries', function()
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    if Player.Functions.RemoveItem('burger-potato', 1, false, true) then
        Player.Functions.AddItem('burger-fries', math.random(3, 5), false, false, true)
    end
end)

RegisterServerEvent('ls-burgershot:server:finish:patty')
AddEventHandler('ls-burgershot:server:finish:patty', function()
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    if Player.Functions.RemoveItem('burger-raw', 1, false, true) then
        Player.Functions.AddItem('burger-meat', 1, false, false, true)
    end
end)

RegisterServerEvent('ls-burgershot:server:finish:drink')
AddEventHandler('ls-burgershot:server:finish:drink', function(DrinkName)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    Player.Functions.AddItem(DrinkName, 1, false, false, true)
end)

RegisterServerEvent('ls-burgershot:server:add:to:register')
AddEventHandler('ls-burgershot:server:add:to:register', function(Price, Note)
    local RandomID = math.random(1111,9999)
    Config.ActivePayments[RandomID] = {['Price'] = Price, ['Note'] = Note}
    TriggerClientEvent('ls-burgershot:client:sync:register', -1, Config.ActivePayments)
end)

RegisterServerEvent('ls-burgershot:server:get:bag')
AddEventHandler('ls-burgershot:server:get:bag', function()
    local RandomID = math.random(1111,99999)
    local Player = LSCore.Functions.GetPlayer(source)
    Player.Functions.AddItem('burger-box', 1, false, {boxid = RandomID}, true)
end)

RegisterServerEvent('ls-burgershot:server:pay:receipt')
AddEventHandler('ls-burgershot:server:pay:receipt', function(Data)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    if Player.Functions.RemoveMoney('cash', Data['Price'], 'burger-shot') then
        if Config.ActivePayments[tonumber(Data['BillId'])] ~= nil then
            Config.ActivePayments[tonumber(Data['BillId'])] = nil
            TriggerEvent('ls-burgershot:give:receipt:to:workers')
            TriggerClientEvent('ls-burgershot:client:sync:register', -1, Config.ActivePayments)
        else
            TriggerClientEvent('LSCore:Notify', src, 'Error..', 'error')
        end
    else
        TriggerClientEvent('LSCore:Notify', src, 'Je hebt niet genoeg contant geld..', 'error')
    end
end)

RegisterServerEvent('ls-burgershot:give:receipt:to:workers')
AddEventHandler('ls-burgershot:give:receipt:to:workers', function()
    for k, v in pairs(LSCore.Functions.GetPlayers()) do
        local Player = LSCore.Functions.GetPlayer(v)
        if Player ~= nil and Player.PlayerData.job.name == 'burger' and Player.PlayerData.job.onduty then
            Player.Functions.AddItem('burger-ticket', 1, false, false, true)
        end
    end
end)

RegisterServerEvent('ls-burgershot:server:sell:tickets')
AddEventHandler('ls-burgershot:server:sell:tickets', function()
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    for k, v in pairs(Player.PlayerData.inventory) do
        if v.name == 'burger-ticket' then
            Player.Functions.RemoveItem('burger-ticket', v.amount, false, true)
            Player.Functions.AddMoney('cash', (math.random(60, 100) * v.amount), 'burgershot-payment')
        end
    end
end)

RegisterServerEvent('ls-burgershot:server:alert:workers')
AddEventHandler('ls-burgershot:server:alert:workers', function()
    TriggerClientEvent('ls-burgershot:client:call:intercom', -1)
end)

RegisterServerEvent('ls-burgershot:server:give:payment')
AddEventHandler('ls-burgershot:server:give:payment', function(PlayerId)
    local Player = LSCore.Functions.GetPlayer(PlayerId)
    if Player ~= nil then
        TriggerClientEvent('ls-burgershot:client:open:payment', PlayerId)
    else
        TriggerClientEvent('LSCore:Notify', source, 'Dit is niet juist..', 'error')
    end
end)

LSCore.Commands.Add("setburger", "Neem een burgershot medewerker aan", {{name="id", help="Speler ID"}}, true, function(source, args)
    local Player = LSCore.Functions.GetPlayer(source)
    local TargetPlayer = LSCore.Functions.GetPlayer(tonumber(args[1]))
    if Player.PlayerData.metadata['ishighcommand'] and Player.PlayerData.job.name == 'burger' then
        if TargetPlayer ~= nil then
            TriggerClientEvent('LSCore:Notify', TargetPlayer.PlayerData.source, 'Je bent aangenomen als burgershot medewerker! gefeliciteerd!', 'success')
            TriggerClientEvent('LSCore:Notify', Player.PlayerData.source, 'Je hebt '..TargetPlayer.PlayerData.charinfo.firstname..' '..TargetPlayer.PlayerData.charinfo.lastname..' aangenomen als burgershot medewerker!', 'success')
            TargetPlayer.Functions.SetJob('burger', 1)
        end
    end
end)

LSCore.Commands.Add("fireburger", "Ontsla een burgershot medewerker", {{name="id", help="Speler ID"}}, true, function(source, args)
    local Player = LSCore.Functions.GetPlayer(source)
    local TargetPlayer = LSCore.Functions.GetPlayer(tonumber(args[1]))
    if Player.PlayerData.metadata['ishighcommand'] and Player.PlayerData.job.name == 'burger' then
        if TargetPlayer ~= nil and TargetPlayer.PlayerData.job.name == 'burger' then
            TriggerClientEvent('LSCore:Notify', TargetPlayer.PlayerData.source, 'Je bent ontslagen!', 'error')
            TriggerClientEvent('LSCore:Notify', Player.PlayerData.source, 'Je hebt '..TargetPlayer.PlayerData.charinfo.firstname..' '..TargetPlayer.PlayerData.charinfo.lastname..' ontslagen!', 'success')
            TargetPlayer.Functions.SetJob('unemployed', 1)
        end
    end
end)