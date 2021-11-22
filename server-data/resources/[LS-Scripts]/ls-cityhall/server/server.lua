local LSCore = exports['ls-core']:GetCoreObject()

-- Code

RegisterServerEvent('ls-cityhall:server:request:identity')
AddEventHandler('ls-cityhall:server:request:identity', function(data)
    local Player = LSCore.Functions.GetPlayer(source)
    if Player.Functions.RemoveMoney('cash', 50) then
        local CardInfo = {}
        if data['Id'] == "id" then
            CardInfo.citizenid = Player.PlayerData.citizenid
            CardInfo.firstname = Player.PlayerData.charinfo.firstname
            CardInfo.lastname = Player.PlayerData.charinfo.lastname
            CardInfo.birthdate = Player.PlayerData.charinfo.birthdate
            CardInfo.gender = Player.PlayerData.charinfo.gender
            CardInfo.nationality = Player.PlayerData.charinfo.nationality
            Player.Functions.AddItem('id_card', 1, false, CardInfo, true)
        elseif data['Id'] == "drive" then
            CardInfo.firstname = Player.PlayerData.charinfo.firstname
            CardInfo.lastname = Player.PlayerData.charinfo.lastname
            CardInfo.birthdate = Player.PlayerData.charinfo.birthdate
            CardInfo.type = "A1-A2-A | AM-B | C1-C-CE"
            Player.Functions.AddItem('driver_license', 1, false, CardInfo, true)
        end
    else
      TriggerClientEvent('LSCore:Notify', source, 'Je hebt niet genoeg geld..', 'error')
    end
end)

RegisterServerEvent('ls-cityhall:server:request:license')
AddEventHandler('ls-cityhall:server:request:license', function(data)
    local Player, Label = LSCore.Functions.GetPlayer(source), 'Jaag'
    if Player.PlayerData.metadata['licences'][data['Id']] == nil then
        if Player.Functions.RemoveMoney('cash', 5000) or Player.Functions.RemoveMoney('bank', 5000) then
            local SerialNumber, LicenseInfo = LSCore.Player.CreateWeaponSerial(), {}
            Player.Functions.SetMetaDataTable('licences', data['Id'], SerialNumber)
            if data['Id'] == 'hunting' then Label = 'Jaag' LicenseInfo.type = 'Jaag' LicenseInfo.serie = SerialNumber end
            TriggerClientEvent('LSCore:Notify', source, 'Je ontving een '..Label..' vergunning!', 'success')
            Player.Functions.AddItem('licence', 1, false, LicenseInfo, true)
        else
            TriggerClientEvent('LSCore:Notify', source, 'Je hebt niet genoeg geld..', 'error')
        end
    else
        if Player.Functions.RemoveMoney('cash', 5000) or Player.Functions.RemoveMoney('bank', 5000) then
            local LicenseInfo = {}
            if data['Id'] == 'hunting' then LicenseInfo.type = 'Jaag' LicenseInfo.serie = Player.PlayerData.metadata['licences']['hunting'] end
            Player.Functions.AddItem('licence', 1, false, LicenseInfo, true)
        else
            TriggerClientEvent('LSCore:Notify', source, 'Je hebt niet genoeg geld..', 'error')
        end
    end
end)

RegisterServerEvent('ls-cityhall:server:request:work')
AddEventHandler('ls-cityhall:server:request:work', function(data)
    local Player = LSCore.Functions.GetPlayer(source)
    local JobInfo = LSCore.Shared.Jobs[data['Id']]
    Player.Functions.SetJob(data['Id'])
    TriggerClientEvent('LSCore:Notify', source, 'Gefeliciteerd met je nieuwe baan! ('..JobInfo.label..')')
end)

RegisterServerEvent('ls-cityhall:server:scan:metal')
AddEventHandler('ls-cityhall:server:scan:metal', function()
    local RemoveItemsTable = {}
    local Player = LSCore.Functions.GetPlayer(source)
    if Player.PlayerData.metadata['courtitems'] ~= nil then
        for k, v in pairs(Player.PlayerData.metadata['courtitems']) do
            table.insert(RemoveItemsTable, Player.PlayerData.metadata['courtitems'][k])
        end
    end
    for k, v in pairs(Player.PlayerData.inventory) do
        local ItemData = exports['ls-inventory-new']:GetItemData(Player.PlayerData.inventory[k].name)
        if ItemData['ismetal'] then
            Player.Functions.RemoveItem(Player.PlayerData.inventory[k].name, Player.PlayerData.inventory[k].amount, false, true)
            table.insert(RemoveItemsTable, Player.PlayerData.inventory[k])
        end
    end
    Citizen.SetTimeout(250, function()
        Player.Functions.SetMetaData("courtitems", RemoveItemsTable)
        Player.Functions.Save()
    end)
end)

RegisterServerEvent('ls-cityhall:server:recieve:metal:objects')
AddEventHandler('ls-cityhall:server:recieve:metal:objects', function()
    local Player = LSCore.Functions.GetPlayer(source)
    if Player.PlayerData.metadata['courtitems'] ~= nil then
        for k, v in pairs(Player.PlayerData.metadata['courtitems']) do
            Player.Functions.AddItem(v.name, v.amount, false, v.info, true)
        end
        Citizen.SetTimeout(250, function()
           Player.Functions.SetMetaData("courtitems", {})
           Player.Functions.Save()
        end)
    end
end)