local LSCore = exports['fw-base']:GetCoreObject()

-- Code

LSCore.Functions.CreateCallback('framework-jobmanager:server:get:config', function(source, cb)
    cb(Config)
end)


LSCore.Functions.CreateCallback('framework-jobmanager:server:do:bail', function(source, cb, price)
    local Player = LSCore.Functions.GetPlayer(source)
    if Player.Functions.RemoveMoney('cash', price, 'job-bail') then
        cb(true)
    else
        cb(false)
    end
end)

RegisterServerEvent('framework-jobmanager:server:add:payment')
AddEventHandler('framework-jobmanager:server:add:payment', function(PaymentAmount)
    local Player = LSCore.Functions.GetPlayer(source)
    if Config.JobData[Player.PlayerData.citizenid] ~= nil then
        Config.JobData[Player.PlayerData.citizenid]['Payment'] = Config.JobData[Player.PlayerData.citizenid]['Payment'] + math.ceil(PaymentAmount)
    else
        Config.JobData[Player.PlayerData.citizenid] = {['Payment'] = 0 + math.ceil(PaymentAmount)}
    end
    TriggerClientEvent('framework-jobmanager:client:sync:payment', -1, Config.JobData)
end)

RegisterServerEvent('framework-jobmanager:server:recieve:payment')
AddEventHandler('framework-jobmanager:server:recieve:payment', function()
    local Player = LSCore.Functions.GetPlayer(source)
    if Player.Functions.AddMoney('cash', Config.JobData[Player.PlayerData.citizenid]['Payment']) then
      Config.JobData[Player.PlayerData.citizenid]['Payment'] = 0
      TriggerClientEvent('framework-jobmanager:client:sync:payment', -1, Config.JobData)
    end
end)

RegisterServerEvent('framework-jobmanager:server:set:duty')
AddEventHandler('framework-jobmanager:server:set:duty', function(Duty)
    local Player = LSCore.Functions.GetPlayer(source)
    Player.Functions.SetJobDuty(Duty)
end)

RegisterServerEvent('framework-jobmanager:server:receive:materials')
AddEventHandler('framework-jobmanager:server:receive:materials', function()
    local Player = LSCore.Functions.GetPlayer(source)
    Player.Functions.AddItem('recycle-mats', math.random(5, 10), false, false, true)
end)

-- // Hunting \\ --

-- Anti triggers Dennii (ItzHighNL)

RegisterServerEvent('framework-jobmanager:server:recieve:carcas')
AddEventHandler('framework-jobmanager:server:recieve:carcas', function(AnimalName, IsIllegal, UsedBait, AnimalId)
    local Player = LSCore.Functions.GetPlayer(source)
    TriggerEvent("framework-logs:server:SendLog", "cheaters", "Event Trigger", 'red', "(citizenid: *"..Player.PlayerData.citizenid.."* | name: "..Player.PlayerData.name.." | id: *(" ..src..")* Heeft een event getriggerd welke is omgezet door Dennii om cheaters tegen te gaan")
end)

LSCore.Functions.CreateCallback('framework-jobmanager:server:recieve:carcas', function(source, cb, AnimalName, IsIllegal, UsedBait, AnimalId)

-- RegisterServerEvent('framework-jobmanager:server:recieve:carcas')
-- AddEventHandler('framework-jobmanager:server:recieve:carcas', function(AnimalName, IsIllegal, UsedBait, AnimalId)
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
        TriggerEvent('framework-police:server:alert:illegal:hunting', GetEntityCoords(GetPlayerPed(source)))
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
        TriggerEvent('framework-jobmanager:server:hunting:register:bait:animal', AnimalId, false)
    end
end)

RegisterServerEvent('framework-jobmanager:server:hunting:register:bait:animal')
AddEventHandler('framework-jobmanager:server:hunting:register:bait:animal', function(AnimalId, Bool)
    Config.HuntingData['BaitEntitys'][AnimalId] = Bool
    TriggerClientEvent('framework-jobmanager:client:hunting:sync:bait:data', -1, AnimalId, Config.HuntingData['BaitEntitys'][AnimalId])
end)

RegisterServerEvent('framework-jobmanager:server:sell:hunting')
AddEventHandler('framework-jobmanager:server:sell:hunting', function()
    local Player = LSCore.Functions.GetPlayer(source)
    local CurrentTime = exports['fw-weathersync']:GetCurrentTime()
    for k, v in pairs(Player.PlayerData.inventory) do
        if v.name == 'hunting-carcas-one' then
            Player.Functions.RemoveItem('hunting-carcas-one', v.amount, v.slot, true)
            Player.Functions.AddMoney('cash', math.random(20, 45))
        elseif v.name == 'hunting-carcas-two' then
            Player.Functions.RemoveItem('hunting-carcas-two', v.amount, v.slot, true)
            Player.Functions.AddMoney('cash', math.random(25, 50))
        elseif v.name == 'hunting-carcas-three' then
            Player.Functions.RemoveItem('hunting-carcas-three', v.amount, v.slot, true)
            Player.Functions.AddMoney('cash', math.random(45, 60))
        elseif v.name == 'hunting-carcas-four' and (CurrentTime >= 20 and CurrentTime <= 24 or CurrentTime >= 0 and CurrentTime <= 5) then
            Player.Functions.RemoveItem('hunting-carcas-four', v.amount, v.slot, true)
            Player.Functions.AddItem('money-roll', math.random(25, 30), false, false, true)
        end
    end
end)

RegisterServerEvent('framework-stripclub:server:find:reward')
AddEventHandler('framework-stripclub:server:find:reward', function(Itempie)
    local Player = LSCore.Functions.GetPlayer(source)
    for i = 1, math.random(1, 2) do
        Player.Functions.AddItem('ijsblokjes', math.random(2, 7), false, false, true)
    end
end)


RegisterServerEvent('framework-jobmanager:server:get:rewards')
AddEventHandler('framework-jobmanager:server:get:rewards', function(Mined)
    local Player = LSCore.Functions.GetPlayer(source)
    local currep = Player.PlayerData.metadata['baan']
    if not Mined then
        if currep <= 100 then
            -- for i = 1, math.random(2, 6) do
                local RandomItem = Config.MiningMaterials[math.random(#Config.MiningMaterials)]
                Player.Functions.AddItem(RandomItem, math.random(2, 6), false, false, true)
            -- end
        elseif currep >= 350 then
                local RandomItem = Config.MiningMaterials[math.random(#Config.MiningMaterials)]
                Player.Functions.AddItem(RandomItem, math.random(4, 8), false, false, true)
        elseif currep >= 6000 then
            for i = 1, math.random(1, 2) do
                local RandomItem = Config.MiningMaterials[math.random(#Config.MiningMaterials)]
                Player.Functions.AddItem(RandomItem, math.random(5, 9), false, false, true)
            end
        elseif currep >= 15000 then
            for i = 1, math.random(1, 2) do
                local RandomItem = Config.MiningMaterials[math.random(#Config.MiningMaterials)]
                Player.Functions.AddItem(RandomItem, math.random(6, 10), false, false, true)
            end
            local RandomValue = math.random(1, 1000)
            if RandomValue >= 250 and RandomValue <= 260 then
                Player.Functions.AddItem('goldbar', 1, false, false, true)
            elseif RandomValue >= 350 and RandomValue <= 355 then
                Player.Functions.AddItem('diamond', 1, false, false, true)
            end
        end
    else
        -- for i = 1, math.random(2, 3) do
            local RandomItem = Config.MiningMaterials[math.random(#Config.MiningMaterials)]
            Player.Functions.AddItem(RandomItem, 1, false, false, true)
        -- end
    end
    TriggerEvent('framework-ui:server:addskill', 'baan', 1)
end)

RegisterServerEvent('framework-jobmanager:server:mining:set:state')
AddEventHandler('framework-jobmanager:server:mining:set:state', function(MiningSpot, Type, Bool)
    Config.MiningSpots[MiningSpot][Type] = Bool
    TriggerClientEvent('framework-jobmanager:client:sync:spots', -1, MiningSpot, Config.MiningSpots[MiningSpot])
    if Type == 'Mined' and Bool then
        Citizen.SetTimeout((1000 * 60) * 1, function()
            Config.MiningSpots[MiningSpot]['Mined'] = false
            Config.MiningSpots[MiningSpot]['Busy'] = false
            TriggerClientEvent('framework-jobmanager:client:sync:spots', -1, MiningSpot, Config.MiningSpots[MiningSpot])
        end)
    end
end)

LSCore.Commands.Add("settaxi", "Neem nieuwe Taxi werknemer aan", {{name="id", help="Speler ID"}}, true, function(source, args)
    local Player = LSCore.Functions.GetPlayer(source)
    local TargetPlayer = LSCore.Functions.GetPlayer(tonumber(args[1]))
    if Player.PlayerData.metadata['ishighcommand'] and Player.PlayerData.job.name == 'taxi' then
        if TargetPlayer ~= nil then
            TriggerClientEvent('LSCore:Notify', TargetPlayer.PlayerData.source, "Je bent aangenomen als Taxi chauffeur!", 'success')
            TriggerClientEvent('LSCore:Notify', Player.PlayerData.source, 'Je hebt'..TargetPlayer.PlayerData.charinfo.firstname..' '..TargetPlayer.PlayerData.charinfo.lastname..'aangenomen!', 'success')
            TargetPlayer.Functions.SetJob('taxi')
        end
    end
end)

LSCore.Commands.Add("firetaxi", "Onstla een Taxi werknemer", {{name="id", help="Speler ID"}}, true, function(source, args)
    local Player = LSCore.Functions.GetPlayer(source)
    local TargetPlayer = LSCore.Functions.GetPlayer(tonumber(args[1]))
    if Player.PlayerData.metadata['ishighcommand'] and Player.PlayerData.job.name == 'taxi' then
        if TargetPlayer ~= nil and TargetPlayer.PlayerData.job.name == 'taxi' then
            TriggerClientEvent('LSCore:Notify', TargetPlayer.PlayerData.source, "Je bent ontslagen bij het Taxi Bureau!", 'error')
            TriggerClientEvent('LSCore:Notify', Player.PlayerData.source, 'Je hebt'..TargetPlayer.PlayerData.charinfo.firstname..' '..TargetPlayer.PlayerData.charinfo.lastname..'ontslagen!', 'success')
            TargetPlayer.Functions.SetJob('unemployed')
        end
    end
end)

-- Flightschool

RegisterServerEvent('framework-flightschool:server:add:license')
AddEventHandler('framework-flightschool:server:add:license', function(PlayerId)
    local SourcePlayer = LSCore.Functions.GetPlayer(source)
    local TargetPlayer = LSCore.Functions.GetPlayer(PlayerId)
    if TargetPlayer ~= nil then
        if TargetPlayer.PlayerData.metadata['licences']['flying'] == false or TargetPlayer.PlayerData.metadata['licences']['flying'] == nil then
            TargetPlayer.Functions.SetMetaDataTable('licences', 'flying', true)
            TriggerClientEvent('LSCore:Notify', TargetPlayer.PlayerData.source, "Je hebt je vlieg brevet ontvangen!", "success")
            TriggerClientEvent('LSCore:Notify', source, "Vlieg brevet gegeven", "success")
        else
            TriggerClientEvent('LSCore:Notify', source, "Deze persoon heeft al een brevet", "error")
        end
    end
end)

LSCore.Commands.Add("setflight", "Neem nieuw vlieg personeel aan", {{name="id", help="Speler ID"}}, true, function(source, args)
    local Player = LSCore.Functions.GetPlayer(source)
    local TargetPlayer = LSCore.Functions.GetPlayer(tonumber(args[1]))
    if Player.PlayerData.metadata['ishighcommand'] and Player.PlayerData.job.name == 'flightschool' then
        if TargetPlayer ~= nil then
            TriggerClientEvent('LSCore:Notify', TargetPlayer.PlayerData.source, 'Je bent aangenomen als Vliegles instructeur!', 'success')
            TriggerClientEvent('LSCore:Notify', Player.PlayerData.source, 'Je hebt '..TargetPlayer.PlayerData.charinfo.firstname..' '..TargetPlayer.PlayerData.charinfo.lastname..' aangenomen!', 'success')
            TargetPlayer.Functions.SetJob('flightschool', 1)
        end
    end
end)

LSCore.Commands.Add("fireflight", "Fire a flightschool employee", {{name="id", help="Speler ID"}}, true, function(source, args)
    local Player = LSCore.Functions.GetPlayer(source)
    local TargetPlayer = LSCore.Functions.GetPlayer(tonumber(args[1]))
    if Player.PlayerData.metadata['ishighcommand'] and Player.PlayerData.job.name == 'flightschool' then
        if TargetPlayer ~= nil and TargetPlayer.PlayerData.job.name == 'flightschool' then
            TriggerClientEvent('LSCore:Notify', TargetPlayer.PlayerData.source, 'Je bent ontslagen', 'error')
            TriggerClientEvent('LSCore:Notify', Player.PlayerData.source, 'Je hebt '..TargetPlayer.PlayerData.charinfo.firstname..' '..TargetPlayer.PlayerData.charinfo.lastname..' ontslagen!', 'success')
            TargetPlayer.Functions.SetJob('unemployed', 1)
        end
    end
end)

-- Stripclub

-- // Effects \\ --
RegisterServerEvent('framework-unicorn:server:set:effect')
AddEventHandler('framework-unicorn:server:set:effect', function(data)
    Config.CurrentEffect = {['Dict'] = data['Dict'], ['Effect'] = data['Effect']}
    TriggerClientEvent('framework-unicorn:client:sync:config', -1, Config)
end)

RegisterServerEvent('framework-unicorn:server:close:effect')
AddEventHandler('framework-unicorn:server:close:effect', function()
    Config.CurrentEffect = {['Dict'] = nil, ['Effect'] = nil}
    TriggerClientEvent('framework-unicorn:client:stop:effects', -1)
    TriggerClientEvent('framework-unicorn:client:sync:config', -1, Config)
end)

-- // Register \\ --
RegisterServerEvent('framework-unicorn:server:add:to:register')
AddEventHandler('framework-unicorn:server:add:to:register', function(Price, Note)
    local RandomID = math.random(1111,9999)
    Config.ActivePayments[RandomID] = {['Price'] = Price, ['Note'] = Note}
    TriggerClientEvent('framework-unicorn:client:sync:register', -1, Config.ActivePayments)
end)

RegisterServerEvent('framework-jonkohuis:server:add:to:register')
AddEventHandler('framework-jonkohuis:server:add:to:register', function(Price, Note)
    local RandomID = math.random(1111,9999)
    Config.ActivePayments[RandomID] = {['Price'] = Price, ['Note'] = Note}
    TriggerClientEvent('framework-jonkohuis:client:sync:register', -1, Config.ActivePayments)
end)
-- // tickets \\ --
RegisterServerEvent('framework-unicorn:server:pay:receipt')
AddEventHandler('framework-unicorn:server:pay:receipt', function(Data)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    if Player.Functions.RemoveMoney('cash', Data['Price'], 'stripclub') then
        if Config.ActivePayments[tonumber(Data['BillId'])] ~= nil then
            Config.ActivePayments[tonumber(Data['BillId'])] = nil
            TriggerEvent('framework-unicorn:give:receipt:to:workers')
            TriggerClientEvent('framework-unicorn:client:sync:register', -1, Config.ActivePayments)
        else
            TriggerClientEvent('LSCore:Notify', src, 'Error..', 'error')
        end
    else
        TriggerClientEvent('LSCore:Notify', src, "Je hebt niet genoeg cash", 'error')
    end
end)

RegisterServerEvent('framework-jonkohuis:server:pay:receipt')
AddEventHandler('framework-jonkohuis:server:pay:receipt', function(Data)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    if Player.Functions.RemoveMoney('cash', Data['Price'], 'stripclub') then
        if Config.ActivePayments[tonumber(Data['BillId'])] ~= nil then
            Config.ActivePayments[tonumber(Data['BillId'])] = nil
            TriggerEvent('framework-jonkohuis:give:receipt:to:workers')
            TriggerClientEvent('framework-jonkohuis:client:sync:register', -1, Config.ActivePayments)
        else
            TriggerClientEvent('LSCore:Notify', src, 'Error..', 'error')
        end
    else
        TriggerClientEvent('LSCore:Notify', src, "Je hebt niet genoeg cash", 'error')
    end
end)
RegisterServerEvent('framework-unicorn:give:receipt:to:workers')
AddEventHandler('framework-unicorn:give:receipt:to:workers', function()
    for k, v in pairs(LSCore.Functions.GetPlayers()) do
        local Player = LSCore.Functions.GetPlayer(v)
        if Player ~= nil and Player.PlayerData.job.name == 'stripclub' and Player.PlayerData.job.onduty then
            Player.Functions.AddItem('weed-ticket', 1, false, false, true)
        end
    end
end)

RegisterServerEvent('framework-unicorn:server:sell:tickets')
AddEventHandler('framework-unicorn:server:sell:tickets', function()
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    for k, v in pairs(Player.PlayerData.inventory) do
        if v.name == 'stripclub-ticket' then
            Player.Functions.RemoveItem('stripclub-ticket', v.amount, false, true)
            Player.Functions.AddMoney('cash', (math.random(60, 100) * v.amount), 'stripclub-payment')
        end
    end
end)

-- // hire \\ --

LSCore.Commands.Add("setstripclub", "Hire an employee", {{name="id", help="Speler ID"}}, true, function(source, args)
    local Player = LSCore.Functions.GetPlayer(source)
    local TargetPlayer = LSCore.Functions.GetPlayer(tonumber(args[1]))
    if Player.PlayerData.metadata['ishighcommand'] and Player.PlayerData.job.name == 'stripclub' then
        if TargetPlayer ~= nil then
            TriggerClientEvent('LSCore:Notify', TargetPlayer.PlayerData.source, 'Je bent aangenomen bij de Stripclub', 'success')
            TriggerClientEvent('LSCore:Notify', Player.PlayerData.source, "Je hebt '..TargetPlayer.PlayerData.charinfo.firstname..' '..TargetPlayer.PlayerData.charinfo.lastname..' Aangenomen!", 'success')
            TargetPlayer.Functions.SetJob('stripclub', 1)
        end    
    end
end)

LSCore.Commands.Add("firestripclub", "Fire an employee", {{name="id", help="Speler ID"}}, true, function(source, args)
    local Player = LSCore.Functions.GetPlayer(source)
    local TargetPlayer = LSCore.Functions.GetPlayer(tonumber(args[1]))
    if Player.PlayerData.metadata['ishighcommand'] and Player.PlayerData.job.name == 'stripclub' then
        if TargetPlayer ~= nil and TargetPlayer.PlayerData.job.name == 'stripclub' then
            TriggerClientEvent('LSCore:Notify', TargetPlayer.PlayerData.source, 'Je bent ontslagen!', 'error')
            TriggerClientEvent('LSCore:Notify', Player.PlayerData.source, "Je hebt '..TargetPlayer.PlayerData.charinfo.firstname..' '..TargetPlayer.PlayerData.charinfo.lastname..' ontslagen", 'success')
            TargetPlayer.Functions.SetJob('unemployed', 1)
        end
    end
end)

LSCore.Commands.Add("setweed", "Hire an employee", {{name="id", help="Speler ID"}}, true, function(source, args)
    local Player = LSCore.Functions.GetPlayer(source)
    local TargetPlayer = LSCore.Functions.GetPlayer(tonumber(args[1]))
    if Player.PlayerData.metadata['ishighcommand'] and Player.PlayerData.job.name == 'weed' then
        if TargetPlayer ~= nil then
            TriggerClientEvent('LSCore:Notify', TargetPlayer.PlayerData.source, 'Je bent aangenomen bij de Stripclub', 'success')
            TriggerClientEvent('LSCore:Notify', Player.PlayerData.source, "Je hebt '..TargetPlayer.PlayerData.charinfo.firstname..' '..TargetPlayer.PlayerData.charinfo.lastname..' Aangenomen!", 'success')
            TargetPlayer.Functions.SetJob('weed', 1)
        end    
    end
end)

LSCore.Commands.Add("fireweed", "Fire an employee", {{name="id", help="Speler ID"}}, true, function(source, args)
    local Player = LSCore.Functions.GetPlayer(source)
    local TargetPlayer = LSCore.Functions.GetPlayer(tonumber(args[1]))
    if Player.PlayerData.metadata['ishighcommand'] and Player.PlayerData.job.name == 'weed' then
        if TargetPlayer ~= nil and TargetPlayer.PlayerData.job.name == 'weed' then
            TriggerClientEvent('LSCore:Notify', TargetPlayer.PlayerData.source, 'Je bent ontslagen!', 'error')
            TriggerClientEvent('LSCore:Notify', Player.PlayerData.source, "Je hebt '..TargetPlayer.PlayerData.charinfo.firstname..' '..TargetPlayer.PlayerData.charinfo.lastname..' ontslagen", 'success')
            TargetPlayer.Functions.SetJob('unemployed', 1)
        end
    end
end)

-- Lawyer

RegisterServerEvent('framework-judge:lawyer:add')
AddEventHandler('framework-judge:lawyer:add', function(TagetId)
local SelfPlayer = LSCore.Functions.GetPlayer(source)
local TagetPlayer = LSCore.Functions.GetPlayer(TagetId)
local LawyerInfo = {id = math.random(100000, 999999), firstname = TagetPlayer.PlayerData.charinfo.firstname, lastname = TagetPlayer.PlayerData.charinfo.lastname, citizenid = TagetPlayer.PlayerData.citizenid}
 if TagetPlayer ~= nil and SelfPlayer ~= nil then
    TagetPlayer.Functions.SetJob('lawyer')
    TagetPlayer.Functions.AddItem("lawyerpass", 1, false, LawyerInfo, true)
    TriggerClientEvent('LSCore:Notify', SelfPlayer.PlayerData.source, 'Je hebt'..TagetPlayer.PlayerData.charinfo.firstname..' '..TagetPlayer.PlayerData.charinfo.lastname..' aangenomen!')
    TriggerClientEvent('LSCore:Notify', TagetPlayer.PlayerData.source, 'Welkom in dienst als Advocaat! Handel naar eer en geweten')
 end
end)

LSCore.Functions.CreateUseableItem("lawyerpass", function(source, item)
 local Player = LSCore.Functions.GetPlayer(source)
  if Player.Functions.GetItemBySlot(item.slot) ~= nil then
    TriggerClientEvent("framework-judge:client:show:pass", -1, source, item.info)
  end
end)

-- Sushi

RegisterServerEvent('framework-sushi:server:add:to:register')
AddEventHandler('framework-sushi:server:add:to:register', function(Price, Note)
    local RandomID = math.random(1111,9999)
    Config.RegisterData[RandomID] = {['Price'] = Price, ['Note'] = Note}
    TriggerClientEvent('framework-sushi:client:sync:register', -1, RandomID, Config.RegisterData[RandomID])
end)

RegisterServerEvent('framework-sushi:server:pay:receipt')
AddEventHandler('framework-sushi:server:pay:receipt', function(Data)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    if Player.Functions.RemoveMoney('cash', Data['Price'], 'burger-shot') then
        if Config.RegisterData[tonumber(Data['BillId'])] ~= nil then
            Config.RegisterData[tonumber(Data['BillId'])] = nil
            TriggerEvent('framework-sushi:give:receipt:to:workers')
            TriggerClientEvent('framework-sushi:client:sync:register', -1, Data['BillId'], nil)
        else
            TriggerClientEvent('LSCore:Notify', src, 'Error..', 'error')
        end
    else
        TriggerClientEvent('LSCore:Notify', src, "Je hebt niet genoeg cash..", 'error')
    end
end)

RegisterServerEvent('framework-sushi:give:receipt:to:workers')
AddEventHandler('framework-sushi:give:receipt:to:workers', function()
    for k, v in pairs(LSCore.Functions.GetPlayers()) do
        local Player = LSCore.Functions.GetPlayer(v)
        if Player ~= nil and Player.PlayerData.job.name == 'sushi' and Player.PlayerData.job.onduty then
            Player.Functions.AddItem('sushi-ticket', 1, false, false, true)
        end
    end
end)

RegisterServerEvent('framework-sushi:server:create:food')
AddEventHandler('framework-sushi:server:create:food', function(FoodName)
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

RegisterServerEvent('framework-sushi:server:create:tea')
AddEventHandler('framework-sushi:server:create:tea', function()
    local Player = LSCore.Functions.GetPlayer(source)
    Player.Functions.AddItem('sushi-tea', 1, false, false, true)
end)

-- Burgershot

LSCore.Functions.CreateCallback('framework-jobmanager:server:has:burger:items', function(source, cb)
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

RegisterServerEvent('framework-jobmanager:server:finish:burger')
AddEventHandler('framework-jobmanager:server:finish:burger', function(BurgerName)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    for k, v in pairs(Config.BurgerItems) do
        Player.Functions.RemoveItem(v, 1, false, true)
    end
    Citizen.SetTimeout(350, function()
        Player.Functions.AddItem(BurgerName, 1, false, false, true)
    end)
end)

RegisterServerEvent('framework-jobmanager:server:finish:fries')
AddEventHandler('framework-jobmanager:server:finish:fries', function()
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    if Player.Functions.RemoveItem('burger-potato', 1, false, true) then
        Player.Functions.AddItem('burger-fries', math.random(3, 5), false, false, true)
    end
end)

RegisterServerEvent('framework-jobmanager:server:finish:patty')
AddEventHandler('framework-jobmanager:server:finish:patty', function()
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    if Player.Functions.RemoveItem('burger-raw', 1, false, true) then
        Player.Functions.AddItem('burger-meat', 1, false, false, true)
    end
end)

-- Anti triggers Dennii (ItzHighNL)
RegisterServerEvent('framework-jobmanager:server:finish:drink')
AddEventHandler('framework-jobmanager:server:finish:drink', function()
    local Player = LSCore.Functions.GetPlayer(source)
    TriggerEvent("framework-logs:server:SendLog", "cheaters", "Event Trigger", 'red', "(citizenid: *"..Player.PlayerData.citizenid.."* | name: "..Player.PlayerData.name.." | id: *(" ..src..")* Heeft een event getriggerd welke is omgezet door Dennii om cheaters tegen te gaan")
end)

LSCore.Functions.CreateCallback('framework-jobmanager:server:finish:drink', function(source, cb, DrinkName)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    Player.Functions.AddItem(DrinkName, 1, false, false, true)
end)

RegisterServerEvent('framework-jobmanager:server:add:to:register')
AddEventHandler('framework-jobmanager:server:add:to:register', function(Price, Note)
    local RandomID = math.random(1111,9999)
    Config.ActivePayments[RandomID] = {['Price'] = Price, ['Note'] = Note}
    TriggerClientEvent('framework-jobmanager:client:sync:register', -1, Config.ActivePayments)
end)

RegisterServerEvent('framework-jobmanager:server:get:bag')
AddEventHandler('framework-jobmanager:server:get:bag', function()
    local RandomID = math.random(1111,99999)
    local Player = LSCore.Functions.GetPlayer(source)
    Player.Functions.AddItem('burger-box', 1, false, {boxid = RandomID}, true)
end)

RegisterServerEvent('framework-jobmanager:server:pay:receipt')
AddEventHandler('framework-jobmanager:server:pay:receipt', function(Data)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    if Player.Functions.RemoveMoney('cash', Data['Price'], 'burger-shot') then
        if Config.ActivePayments[tonumber(Data['BillId'])] ~= nil then
            Config.ActivePayments[tonumber(Data['BillId'])] = nil
            TriggerEvent('framework-jobmanager:give:receipt:to:workers')
            TriggerClientEvent('framework-jobmanager:client:sync:register', -1, Config.ActivePayments)
        else
            TriggerClientEvent('LSCore:Notify', src, 'Error..', 'error')
        end
    else
        TriggerClientEvent('LSCore:Notify', src, 'Je hebt niet genoeg contact geld.', 'error')
    end
end)

RegisterServerEvent('framework-jobmanager:give:receipt:to:workers')
AddEventHandler('framework-jobmanager:give:receipt:to:workers', function()
    for k, v in pairs(LSCore.Functions.GetPlayers()) do
        local Player = LSCore.Functions.GetPlayer(v)
        if Player ~= nil and Player.PlayerData.job.name == 'burger' and Player.PlayerData.job.onduty then
            Player.Functions.AddItem('burger-ticket', 1, false, false, true)
        end
    end
end)

RegisterServerEvent('framework-jobmanager:server:sell:tickets')
AddEventHandler('framework-jobmanager:server:sell:tickets', function()
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    for k, v in pairs(Player.PlayerData.inventory) do
        if v.name == 'burger-ticket' then
            Player.Functions.RemoveItem('burger-ticket', v.amount, false, false)
            Player.Functions.AddMoney('cash', (math.random(60, 100) * v.amount), 'burgershot-payment')
        end
        if v.name == 'stripclub-ticket' then
            Player.Functions.RemoveItem('stripclub-ticket', v.amount, false, false)
            Player.Functions.AddMoney('cash', (math.random(60, 100) * v.amount), 'stripclub-payment')
        end
    end
end)

RegisterServerEvent('framework-jobmanager:server:alert:workers')
AddEventHandler('framework-jobmanager:server:alert:workers', function()
    TriggerClientEvent('framework-jobmanager:client:call:intercom', -1)
end)

RegisterServerEvent('framework-jobmanager:server:give:payment')
AddEventHandler('framework-jobmanager:server:give:payment', function(PlayerId)
    local Player = LSCore.Functions.GetPlayer(PlayerId)
    if Player ~= nil then
        TriggerClientEvent('framework-jobmanager:client:open:payment', PlayerId)
    else
        TriggerClientEvent('LSCore:Notify', source, 'Dit is niet correct', 'error')
    end
end)

LSCore.Commands.Add("setburger", "Hire a burgershot employee", {{name="id", help="Speler ID"}}, true, function(source, args)
    local Player = LSCore.Functions.GetPlayer(source)
    local TargetPlayer = LSCore.Functions.GetPlayer(tonumber(args[1]))
    if Player.PlayerData.metadata['ishighcommand'] and Player.PlayerData.job.name == 'burger' then
        if TargetPlayer ~= nil then
            TriggerClientEvent('LSCore:Notify', TargetPlayer.PlayerData.source, 'Je bent aangenomen bij de Burgershot!', 'success')
            TriggerClientEvent('LSCore:Notify', Player.PlayerData.source, 'Je hebt '..TargetPlayer.PlayerData.charinfo.firstname..' '..TargetPlayer.PlayerData.charinfo.lastname..' aangenomen!', 'success')
            TargetPlayer.Functions.SetJob('burger', 1)
        end
    end
end)

LSCore.Commands.Add("fireburger", "Ontsla een burgershot medewerker", {{name="id", help="Speler ID"}}, true, function(source, args)
    local Player = LSCore.Functions.GetPlayer(source)
    local TargetPlayer = LSCore.Functions.GetPlayer(tonumber(args[1]))
    if Player.PlayerData.metadata['ishighcommand'] and Player.PlayerData.job.name == 'burger' then
        if TargetPlayer ~= nil and TargetPlayer.PlayerData.job.name == 'burger' then
            TriggerClientEvent('LSCore:Notify', TargetPlayer.PlayerData.source, 'Je bent ontslagen', 'error')
            TriggerClientEvent('LSCore:Notify', Player.PlayerData.source, 'Je hebt '..TargetPlayer.PlayerData.charinfo.firstname..' '..TargetPlayer.PlayerData.charinfo.lastname..'ontslagen', 'success')
            TargetPlayer.Functions.SetJob('unemployed', 1)
        end
    end
end)

-- Vissen

RegisterServerEvent('framework-fishing:server:unbox')
AddEventHandler('framework-fishing:server:unbox', function(BoxName)
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

RegisterServerEvent('framework-fishing:server:sell:gold-fish')
AddEventHandler('framework-fishing:server:sell:gold-fish', function()
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    if Player.Functions.RemoveItem('special-fish', 1, false, true) then
        Player.Functions.AddMoney('cash', math.random(1000, 3500))
    elseif Player.Functions.RemoveItem('fish-dolphine', 1, false, true) then
        Player.Functions.AddMoney('cash', math.random(2000, 4500))
    elseif Player.Functions.RemoveItem('white-pearl', 1, false, true) then
        Player.Functions.AddMoney('cash', 1200)
    else
        TriggerClientEvent('Framework:Notify', src, 'Geen speciale vis ?', "error")
    end
end)

RegisterServerEvent('framework-fishing:server:sell:items')
AddEventHandler('framework-fishing:server:sell:items', function()
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

LSCore.Functions.CreateUseableItem("fishingrod", function(source, item)
    local Player = LSCore.Functions.GetPlayer(source)

    TriggerClientEvent('framework-fishing:tryToFish', source)
end)

RegisterServerEvent('framework-fishing:receiveFish')
AddEventHandler('framework-fishing:receiveFish', function()
    local Player = LSCore.Functions.GetPlayer(source)
    TriggerEvent("framework-logs:server:SendLog", "cheaters", "Event Trigger", 'red', "(citizenid: *"..Player.PlayerData.citizenid.."* | name: "..Player.PlayerData.name.." | id: *(" ..src..")* Heeft een event getriggerd welke is omgezet door Dennii om cheaters tegen te gaan")
end)


LSCore.Functions.CreateCallback('framework-fishing:receiveFish', function(source, cb)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    local luck = math.random(1, 100)
    local itemFound = true
    local itemCount = 1
    if itemFound then
        for i = 1, itemCount, 1 do
            local randomItem = Config.FishingItems["type"]math.random(1, 2)
			local SubValue = math.random(1,350)
            if luck >= 85 and luck <= 98 then
				randomItem = "plastic"
                Player.Functions.AddItem(randomItem, 6, false, false, true)
			elseif luck >= 80 and luck <= 85 then
				randomItem = "special-fish"
                Player.Functions.AddItem(randomItem, 2, false, false, true)
			elseif luck >= 73 and luck <= 75 then
				randomItem = "fish-dolphine"
                Player.Functions.AddItem(randomItem, 1, false, false, true)
			elseif luck >= 70 and luck <= 72 then
				randomItem = "fish-2"
                Player.Functions.AddItem(randomItem, 1, false, false, true)
			elseif luck >= 65 and luck <= 70 then
				randomItem = "fish-3"
                Player.Functions.AddItem(randomItem, 1, false, false, true)
			elseif luck >= 60 and luck <= 65 then
				randomItem = "fish-1"
                Player.Functions.AddItem(randomItem, 1, false, false, true)
			elseif luck >= 55 and luck <= 60 then
				randomItem = "fish-3"
                Player.Functions.AddItem(randomItem, 1, false, false, true)
			elseif luck >= 40 and luck <= 55 then
				randomItem = "fish-1"
                Player.Functions.AddItem(randomItem, 1, false, false, true)
			elseif luck >= 30 and luck <= 40 then
				randomItem = "fish-box"
            end
            Citizen.Wait(500)
        end
    end
end)

RegisterServerEvent("framework-fishing:sellFish")
AddEventHandler("framework-fishing:sellFish", function()
    local src = source
	local Player = LSCore.Functions.GetPlayer(src)
	local price = 0
    if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then 
        for k, v in pairs(Player.PlayerData.items) do 
            if Player.PlayerData.items[k] ~= nil then 
                if Player.PlayerData.items[k].name == "fish-1" then 
                    price = price + (Config.FishingItems["fish-1"]["price"] * Player.PlayerData.items[k].amount)
                    Player.Functions.RemoveItem("fish-1", Player.PlayerData.items[k].amount, k)
				elseif Player.PlayerData.items[k].name == "fish-2" then 
                    price = price + (Config.FishingItems["fish-2"]["price"] * Player.PlayerData.items[k].amount)
					Player.Functions.RemoveItem("fish-2", Player.PlayerData.items[k].amount, k)
				elseif Player.PlayerData.items[k].name == "fish-3" then 
                    price = price + (Config.FishingItems["fish-3"]["price"] * Player.PlayerData.items[k].amount)
					Player.Functions.RemoveItem("fish-3", Player.PlayerData.items[k].amount, k)
                end
            end
        end
        Player.Functions.AddMoney("cash", price, "sold-fish")
		TriggerClientEvent('LSCore:Notify', src, "Je hebt je vis verkocht!")
	end
end)