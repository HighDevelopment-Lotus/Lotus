Config = {}
local LSCore = exports["fw-base"]:GetCoreObject()
LSCore.Functions.CreateCallback("framework-storagelockers:server:FetchConfig", function(source, cb)
    Config.Lockers = json.decode(LoadResourceFile(GetCurrentResourceName(), "lockers.json"))
    cb(Config.Lockers)
end)

LSCore.Functions.CreateCallback("framework-storagelockers:server:purchaselocker", function(source, cb, v, k)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    local CitizenID = Player.PlayerData.citizenid
    local price = v.price
    local bankMoney = Player.PlayerData.money["bank"]
    if bankMoney >= price then
        Player.Functions.RemoveMoney('bank', price, "Locker Gekocht")
        Config.Lockers = json.decode(LoadResourceFile(GetCurrentResourceName(), "lockers.json"))
        Config.Lockers[k]['isOwned'] = true
        Config.Lockers[k]['owner'] = CitizenID 
        SaveResourceFile(GetCurrentResourceName(), "./lockers.json", json.encode(Config.Lockers), -1)
        TriggerClientEvent('framework-storagelockers:client:FetchConfig', -1)
        TriggerClientEvent('framework-storagelockers:client:setupBlips', src)
        cb(bankMoney)
    else
        TriggerClientEvent('LSCore:Notify', src, 'Je hebt niet genoeg geld', 'error')
        cb(bankMoney)
    end
end)

LSCore.Functions.CreateCallback("framework-storagelockers:server:getData", function(source, cb, locker, data)  --make this a fetch event for everything and then pass through what you wanna fetch
    Config.Lockers = json.decode(LoadResourceFile(GetCurrentResourceName(), "lockers.json"))
    cb(Config.Lockers[locker][data])
end)

LSCore.Functions.CreateCallback('framework-storagelockers:server:getOwnedLockers', function(source, cb)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    local ownedLockers = {}
    if Player then
        Config.Lockers = json.decode(LoadResourceFile(GetCurrentResourceName(), "lockers.json"))
        for k, v in pairs(Config.Lockers) do 
            if Player.PlayerData.citizenid == v["owner"] then
                table.insert(ownedLockers, k)
            end
        end
        if ownedLockers then
            cb(ownedLockers)
        else
            cb(false)
        end
    end
end)

RegisterNetEvent('framework-storagelockers:server:changePasscode')
AddEventHandler('framework-storagelockers:server:changePasscode', function(newPasscode, lockername, lockertable)
    local src = source
    Config.Lockers = json.decode(LoadResourceFile(GetCurrentResourceName(), "lockers.json"))
    Config.Lockers[lockername]['password'] = newPasscode
    SaveResourceFile(GetCurrentResourceName(), "./lockers.json", json.encode(Config.Lockers), -1)
    TriggerClientEvent('framework-storagelockers:client:FetchConfig', -1)
    TriggerClientEvent('LSCore:Notify', src, 'Wachtwoord veranderd', 'success')
end)

RegisterNetEvent('framework-storagelockers:server:sellLocker')
AddEventHandler('framework-storagelockers:server:sellLocker', function(lockername, lockertable)
    --add extra checks to make sure they own the locker
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    local price = lockertable.price
    local saleprice = price - ((tonumber(price)/100) * 10)
    Config.Lockers[lockername]['isOwned'] = false
    Config.Lockers[lockername]['owner'] = '' --will this work?
    Player.Functions.AddMoney('bank', saleprice, "Locker Sold")
    SaveResourceFile(GetCurrentResourceName(), "./lockers.json", json.encode(Config.Lockers), -1)
    TriggerClientEvent('LSCore:Notify', src, 'Locker verkocht voor ' .. saleprice, 'success')
    TriggerClientEvent('framework-storagelockers:client:setupBlips', src)
    TriggerClientEvent('framework-storagelockers:client:FetchConfig', -1)
end)

RegisterNetEvent('framework-storagelockers:server:createPassword')
AddEventHandler('framework-storagelockers:server:createPassword', function(password, locker)
    Config.Lockers = json.decode(LoadResourceFile(GetCurrentResourceName(), "lockers.json"))
    Config.Lockers[locker]['password'] = password
    SaveResourceFile(GetCurrentResourceName(), "./lockers.json", json.encode(Config.Lockers), -1)
    TriggerClientEvent('framework-storagelockers:client:FetchConfig', -1)
end)

LSCore.Commands.Add("locker", "Plaats een locker", {{name = "name", help = "Locker naam"}, {name = "price", help = "Prijs?"}, {name = "slots", help = "Slots - suggestie: 30"}, {name = "capactiy", help = "Capiciteit (max: 5,000,000)"} }, true, function(source, args)
    local coords = GetEntityCoords(GetPlayerPed(source))
    name = args[1]
    price = args[2]
    slots = args[3]
    capacity = args[4]
    newlocker = {
        ["capacity"] = {},
        ["price"] = {},
        ["slots"] = {},
        ["coords"] = {}
    }
    newlocker["price"] = tonumber(price)
    newlocker["capacity"] = tonumber(capacity)
    newlocker["slots"] = tonumber(slots)
    newlocker["coords"] = {x = coords.x, y = coords.y, z = coords.z}
    local currentConfig = json.decode(LoadResourceFile(GetCurrentResourceName(), "lockers.json"))
    currentConfig[name] = newlocker
    SaveResourceFile(GetCurrentResourceName(), "lockers.json", json.encode(currentConfig), -1)
    TriggerClientEvent('framework-storagelockers:client:FetchConfig', -1)
end, "admin")