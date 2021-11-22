local LSCore = exports['ls-core']:GetCoreObject()

-- Code

LSCore.Functions.CreateCallback("ls-randomdealer:server:get:config", function(source, cb)
    cb(Config)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        local TotalPlayer = GetNumPlayerIndices()
        if TotalPlayer >= 3 then
            local Hour = exports['ls-weathersync']:GetCurrentTime()
            if Hour >= 0 and Hour <= 6 then
                if not Config.DealerActive then
                    Config.DealerActive = true
                    local RandomDealer = Config.DealerLocations[math.random(1, #Config.DealerLocations)] 
                    local RandomMessage = RandomDealer['Hints'][math.random(1, #RandomDealer['Hints'])] 
                    Config.CurrentDealerData = RandomDealer
                    local TweetMessage = {firstName = 'Anoniem', lastName = '', message = "Ik ben in de stad met interessante spullen. Kom snel want OP=OP! ("..RandomMessage..")", time = os.date(), tweetId = 'TWEET-'..math.random(111,9999), picture = 'https://cdn.discordapp.com/attachments/569718394077839371/679746109748543545/non.png'}
                    TriggerEvent('ls-phone_new:server:add:tweet', TweetMessage)
                    TriggerClientEvent('ls-randomdealer:client:set:dealer:data', -1, Config.CurrentDealerData, 'Set')
                    SetupDealerWeapons()
                end
            elseif Hour >= 6 and Hour <= 23 then
                if Config.DealerActive then
                    Config.DealerActive = false
                    Config.CurrentDealerData = {}
                    TriggerClientEvent('ls-randomdealer:client:set:dealer:data', -1, Config.CurrentDealerData, 'Delete')
                end
            end
            Citizen.Wait(2000)
        else
            Citizen.Wait(450)
        end
    end
end)

-- // Events \\ --

RegisterServerEvent('ls-randomdealer:server:set:weapons')
AddEventHandler('ls-randomdealer:server:set:weapons', function(Type, ItemName, Amount)
    if Type == 'Minus' then
        for k, v in pairs(Config.CurrentDealerData['Inventory']) do 
            if v.name == ItemName then
                v.amount = v.amount - Amount
            end
        end
    end
    TriggerClientEvent('ls-randomdealer:client:sync:data', -1, Config.CurrentDealerData)
end)

function SetupDealerWeapons()
    local DealerWeapons = {}
    local TotalPlayer = GetNumPlayerIndices()
    for k, v in pairs(Config.DealerWeapons) do
        if TotalPlayer >= v['MinOnline'] then
            if math.random(1, 100) <= v['Chance'] then
                local TableIndex = #DealerWeapons + 1
                DealerWeapons[TableIndex] = {
                    name = v['WeaponId'],
                    price = math.random(v['Prices']['Min'], v['Prices']['Max']),
                    amount = 1,
                    info = {quality = 100.0, ammo = 5},
                    type = "weapon",
                    slot = TableIndex,
                }
            end
        end
    end
    Config.CurrentDealerData['Inventory'] = DealerWeapons
    TriggerClientEvent('ls-randomdealer:client:sync:data', -1, Config.CurrentDealerData)
end