local LSCore = exports['ls-core']:GetCoreObject()

-- Code

LSCore.Functions.CreateCallback('ls-jobmanager:server:get:config', function(source, cb)
    cb(Config)
end)

LSCore.Functions.CreateCallback('ls-jobmanager:server:do:bail', function(source, cb, price)
    local Player = LSCore.Functions.GetPlayer(source)
    if Player.Functions.RemoveMoney('cash', price, 'job-bail') then
        cb(true)
    else
        cb(false)
    end
end)

RegisterServerEvent('ls-jobmanager:server:add:payment')
AddEventHandler('ls-jobmanager:server:add:payment', function(PaymentAmount)
    local Player = LSCore.Functions.GetPlayer(source)
    if Config.JobData[Player.PlayerData.citizenid] ~= nil then
        Config.JobData[Player.PlayerData.citizenid]['Payment'] = Config.JobData[Player.PlayerData.citizenid]['Payment'] + math.ceil(PaymentAmount)
    else
        Config.JobData[Player.PlayerData.citizenid] = {['Payment'] = 0 + math.ceil(PaymentAmount)}
    end
    TriggerClientEvent('ls-jobmanager:client:sync:payment', -1, Config.JobData)
end)

RegisterServerEvent('ls-jobmanager:server:recieve:payment')
AddEventHandler('ls-jobmanager:server:recieve:payment', function()
    local Player = LSCore.Functions.GetPlayer(source)
    if Player.Functions.AddMoney('cash', Config.JobData[Player.PlayerData.citizenid]['Payment']) then
      Config.JobData[Player.PlayerData.citizenid]['Payment'] = 0
      TriggerClientEvent('ls-jobmanager:client:sync:payment', -1, Config.JobData)
    end
end)

RegisterServerEvent('ls-jobmanager:server:set:duty')
AddEventHandler('ls-jobmanager:server:set:duty', function(Duty)
    local Player = LSCore.Functions.GetPlayer(source)
    Player.Functions.SetJobDuty(Duty)
end)

RegisterServerEvent('ls-jobmanager:server:receive:materials')
AddEventHandler('ls-jobmanager:server:receive:materials', function()
    local Player = LSCore.Functions.GetPlayer(source)
    Player.Functions.AddItem('recycle-mats', math.random(5, 10), false, false, true)
end)

-- // Hunting \\ --

RegisterServerEvent('ls-jobmanager:server:recieve:carcas')
AddEventHandler('ls-jobmanager:server:recieve:carcas', function(AnimalName, IsIllegal, UsedBait, AnimalId)
    local Player = LSCore.Functions.GetPlayer(source)
    local IsPlayerLucky = Player.PlayerData.metadata['lucky'] ~= false and Player.PlayerData.metadata['lucky'] > 0 and Player.PlayerData.metadata['lucky'] or false
    --print(IsIllegal, AnimalName, UsedBait, AnimalId)
    if IsIllegal then
        if UsedBait then
            local RandomValue = math.random(1, 60)
            if RandomValue >= 1 and RandomValue <= 5 then
                Player.Functions.AddItem('hunting-carcas-one', 1, false, {date = os.date(), animal = AnimalName}, true)
            elseif RandomValue > 5 and RandomValue <= 15 then 
                Player.Functions.AddItem('hunting-carcas-two', 1, false, {date = os.date(), animal = AnimalName}, true)
            elseif RandomValue > 15 and RandomValue <= 38 then 
                Player.Functions.AddItem('hunting-carcas-three', 1, false, {date = os.date(), animal = AnimalName}, true)
            else
                Player.Functions.AddItem('hunting-carcas-four', 1, false, {date = os.date(), animal = AnimalName}, true)
            end
        else
            local RandomValue = math.random(1, 60)
            if RandomValue >= 1 and RandomValue <= 20 then
                Player.Functions.AddItem('hunting-carcas-one', 1, false, {date = os.date(), animal = AnimalName}, true)
            elseif RandomValue > 20 and RandomValue <= 45 then 
                Player.Functions.AddItem('hunting-carcas-two', 1, false, {date = os.date(), animal = AnimalName}, true)
            elseif RandomValue > 45 and RandomValue <= 55 then 
                Player.Functions.AddItem('hunting-carcas-three', 1, false, {date = os.date(), animal = AnimalName}, true)
            else
                Player.Functions.AddItem('hunting-carcas-four', 1, false, {date = os.date(), animal = AnimalName}, true)
            end
        end
        TriggerEvent('ls-police:server:alert:illegal:hunting', GetEntityCoords(GetPlayerPed(source)))
    else
        if UsedBait then
            local RandomValue = math.random(1, 50)
            if RandomValue >= 1 and RandomValue <= 26 then
                Player.Functions.AddItem('hunting-carcas-one', 1, false, {date = os.date(), animal = AnimalName}, true)
            elseif RandomValue > 26 and RandomValue <= 45 then 
                Player.Functions.AddItem('hunting-carcas-two', 1, false, {date = os.date(), animal = AnimalName}, true)
            else
                Player.Functions.AddItem('hunting-carcas-three', 1, false, {date = os.date(), animal = AnimalName}, true)
            end
        else
            local RandomValue = math.random(1, 50)
            if RandomValue >= 1 and RandomValue <= 45 then
                Player.Functions.AddItem('hunting-carcas-one', 1, false, {date = os.date(), animal = AnimalName}, true)
            elseif RandomValue > 45 and RandomValue <= 49 then 
                Player.Functions.AddItem('hunting-carcas-two', 1, false, {date = os.date(), animal = AnimalName}, true)
            else
                Player.Functions.AddItem('hunting-carcas-three', 1, false, {date = os.date(), animal = AnimalName}, true)
            end
        end
    end
    if AnimalName ~= 'Retriever' and AnimalName ~= 'Bergkat' then
        if math.random(1, 100) < 45 then
            Player.Functions.AddItem('hunting-meat', 1, false, false, true)
        end
    end
    if UsedBait then
        TriggerEvent('ls-jobmanager:server:hunting:register:bait:animal', AnimalId, false)
    end
end)

RegisterServerEvent('ls-jobmanager:server:hunting:register:bait:animal')
AddEventHandler('ls-jobmanager:server:hunting:register:bait:animal', function(AnimalId, Bool)
    Config.HuntingData['BaitEntitys'][AnimalId] = Bool
    TriggerClientEvent('ls-jobmanager:client:hunting:sync:bait:data', -1, AnimalId, Config.HuntingData['BaitEntitys'][AnimalId])
end)

RegisterServerEvent('ls-jobmanager:server:sell:hunting')
AddEventHandler('ls-jobmanager:server:sell:hunting', function()
    local Player = LSCore.Functions.GetPlayer(source)
    local CurrentTime = exports['ls-weathersync']:GetCurrentTime()
    for k, v in pairs(Player.PlayerData.inventory) do
        if v.name == 'hunting-carcas-one' then
            Player.Functions.RemoveItem('hunting-carcas-one', v.amount, v.slot, true)
            Player.Functions.AddMoney('cash', math.random(225, 275))
        elseif v.name == 'hunting-carcas-two' then
            Player.Functions.RemoveItem('hunting-carcas-two', v.amount, v.slot, true)
            Player.Functions.AddMoney('cash', math.random(425, 475))
        elseif v.name == 'hunting-carcas-three' then
            Player.Functions.RemoveItem('hunting-carcas-three', v.amount, v.slot, true)
            Player.Functions.AddMoney('cash', math.random(650, 1000))
        elseif v.name == 'hunting-carcas-four' and (CurrentTime >= 20 and CurrentTime <= 24 or CurrentTime >= 0 and CurrentTime <= 5) then
            Player.Functions.RemoveItem('hunting-carcas-four', v.amount, v.slot, true)
            Player.Functions.AddItem('money-roll', math.random(25, 30), false, false, true)
        end
    end
end)

RegisterServerEvent('ls-jobmanager:server:get:rewards')
AddEventHandler('ls-jobmanager:server:get:rewards', function(Mined)
    local Player = LSCore.Functions.GetPlayer(source)
    if not Mined then
        for i = 1, math.random(2, 6) do
            local RandomItem = Config.MiningMaterials[math.random(#Config.MiningMaterials)]
            Player.Functions.AddItem(RandomItem, math.random(5, 7), false, false, true)
        end
        local RandomValue = math.random(1, 1000)
        if RandomValue >= 550 and RandomValue <= 560 then
            Player.Functions.AddItem('goldbar', 1, false, false, true)
        elseif RandomValue >= 750 and RandomValue <= 755 then
            Player.Functions.AddItem('diamond', 1, false, false, true)
        end
    else
        for i = 1, math.random(2, 3) do
            local RandomItem = Config.MiningMaterials[math.random(#Config.MiningMaterials)]
            Player.Functions.AddItem(RandomItem, 1, false, false, true)
        end
    end
end)

RegisterServerEvent('ls-jobmanager:server:mining:set:state')
AddEventHandler('ls-jobmanager:server:mining:set:state', function(MiningSpot, Type, Bool)
    Config.MiningSpots[MiningSpot][Type] = Bool
    TriggerClientEvent('ls-jobmanager:client:sync:spots', -1, MiningSpot, Config.MiningSpots[MiningSpot])
    if Type == 'Mined' and Bool then
        Citizen.SetTimeout((1000 * 60) * 1, function()
            Config.MiningSpots[MiningSpot]['Mined'] = false
            Config.MiningSpots[MiningSpot]['Busy'] = false
            TriggerClientEvent('ls-jobmanager:client:sync:spots', -1, MiningSpot, Config.MiningSpots[MiningSpot])
        end)
    end
end)

LSCore.Commands.Add("settaxi", "Neem neen taxi aan", {{name="id", help="Speler ID"}}, true, function(source, args)
    local Player = LSCore.Functions.GetPlayer(source)
    local TargetPlayer = LSCore.Functions.GetPlayer(tonumber(args[1]))
    if Player.PlayerData.metadata['ishighcommand'] and Player.PlayerData.job.name == 'taxi' then
        if TargetPlayer ~= nil then
            TriggerClientEvent('LSCore:Notify', TargetPlayer.PlayerData.source, 'Je bent aangenomen als taxi! gefeliciteerd!', 'success')
            TriggerClientEvent('LSCore:Notify', Player.PlayerData.source, 'Je hebt '..TargetPlayer.PlayerData.charinfo.firstname..' '..TargetPlayer.PlayerData.charinfo.lastname..' aangenomen als taxi!', 'success')
            TargetPlayer.Functions.SetJob('taxi')
        end
    end
end)

LSCore.Commands.Add("firetaxi", "Ontsla een taxi", {{name="id", help="Speler ID"}}, true, function(source, args)
    local Player = LSCore.Functions.GetPlayer(source)
    local TargetPlayer = LSCore.Functions.GetPlayer(tonumber(args[1]))
    if Player.PlayerData.metadata['ishighcommand'] and Player.PlayerData.job.name == 'taxi' then
        if TargetPlayer ~= nil and TargetPlayer.PlayerData.job.name == 'taxi' then
            TriggerClientEvent('LSCore:Notify', TargetPlayer.PlayerData.source, 'Je bent ontslagen!', 'error')
            TriggerClientEvent('LSCore:Notify', Player.PlayerData.source, 'Je hebt '..TargetPlayer.PlayerData.charinfo.firstname..' '..TargetPlayer.PlayerData.charinfo.lastname..' ontslagen!', 'success')
            TargetPlayer.Functions.SetJob('unemployed')
        end
    end
end)