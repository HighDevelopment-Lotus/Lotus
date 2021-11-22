local LSCore, SmeltingData, Smelting, TotalGoldBar = exports['ls-core']:GetCoreObject(), {}, false, 0

-- Code

LSCore.Functions.CreateCallback("ls-pawnshop:server:is:smelting", function(source, cb)
    cb(Smelting)
end)

-- // Loops \\ --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        local CurrentHour = exports['ls-weathersync']:GetCurrentTime()
        if CurrentHour >= 8 and CurrentHour <= 12 then
            if Config.DoorsLocked then
                Config.DoorsLocked = false
                TriggerEvent('ls-doors:server:set:door:locks', 54, 0)
                TriggerEvent('ls-doors:server:set:door:locks', 55, 0)
                TriggerEvent('ls-doors:server:set:door:locks', 56, 0)
            end
        else
            if not Config.DoorsLocked then
                Config.DoorsLocked = true
                TriggerEvent('ls-doors:server:set:door:locks', 54, 4)
                TriggerEvent('ls-doors:server:set:door:locks', 55, 4)
                TriggerEvent('ls-doors:server:set:door:locks', 56, 4)
            end
        end
    end
end)

-- // Events \\ --

-- // Smelter \\ --

RegisterServerEvent('ls-pawnshop:server:try:start')
AddEventHandler('ls-pawnshop:server:try:start', function(InventoryName)
    if not Smelting then
        local InventoryItems = exports['ls-inventory-new']:GetInventoryItems(InventoryName)
        for k, v in pairs(InventoryItems) do
            if v.name == 'goldbar' then
                TotalGoldBar = TotalGoldBar + v.amount
            end
            if Config.SmeltItems[v.name] ~= nil then
                if SmeltingData[v.name] == nil then
                    SmeltingData[v.name] = v.amount
                else
                    SmeltingData[v.name] = SmeltingData[v.name] + v.amount
                end
            end
        end
        if SmeltingData ~= nil and (SmeltingData['rolex'] ~= nil and SmeltingData['rolex'] >= Config.SmeltItems['rolex'] or SmeltingData['goldchain'] ~= nil and SmeltingData['goldchain'] >= Config.SmeltItems['goldchain'] or SmeltingData['heirloom'] ~= nil and SmeltingData['heirloom'] >= Config.SmeltItems['heirloom']) then
            if not Smelting then
                Smelting = true
                TriggerClientEvent('LSCore:Notify', source, 'Smelter is nu aan het smelten!', 'success') 
                StartSmelting()
            else
                TriggerClientEvent('LSCore:Notify', source, 'Er worden al goederen gesmolten..', 'error') 
            end
        else
            SmeltingData, TotalGoldBar = {}, 0
            TriggerClientEvent('LSCore:Notify', source, 'Deze spullen kan je niet smelten..', 'error')
        end
    else
        TriggerClientEvent('LSCore:Notify', source, 'Er worden al goederen gesmolten..', 'error') 
    end
end)

function StartSmelting()
    Citizen.SetTimeout((1000 * 60) * 2, function()
        for k, v in pairs(SmeltingData) do
            while SmeltingData[k] >= Config.SmeltItems[k] do
                if SmeltingData[k] - Config.SmeltItems[k] > 0 then
                    SmeltingData[k] = SmeltingData[k] - Config.SmeltItems[k]
                    TotalGoldBar = TotalGoldBar + 1
                elseif SmeltingData[k] - Config.SmeltItems[k] == 0 then
                    SmeltingData[k] = 0
                    TotalGoldBar = TotalGoldBar + 1
                end
            end
        end
        local Inventory = {[1] = {name = 'goldbar', slot = 1, info = '', amount = TotalGoldBar}} 
        if (SmeltingData['rolex'] ~= nil and SmeltingData['rolex'] > 0) and (SmeltingData['goldchain'] ~= nil and SmeltingData['goldchain'] > 0) and (SmeltingData['heirloom'] ~= nil and SmeltingData['heirloom'] > 0) then
            Inventory = {[1] = {name = 'goldbar', slot = 1, info = '', amount = TotalGoldBar}, [2] = {name = 'goldchain', slot = 2, info = '', amount = SmeltingData['goldchain']}, [3] = {name = 'rolex', slot = 3, info = '', amount = SmeltingData['rolex']}, [4] = {name = 'heirloom', slot = 4, info = '', amount = SmeltingData['heirloom']}}
        elseif SmeltingData['rolex'] ~= nil and SmeltingData['rolex'] > 0 then
            Inventory = {[1] = {name = 'goldbar', slot = 1, info = '', amount = TotalGoldBar}, [2] = {name = 'rolex', slot = 2, info = '', amount = SmeltingData['rolex']}}
        elseif SmeltingData['goldchain'] ~= nil and SmeltingData['goldchain'] > 0 then
            Inventory = {[1] = {name = 'goldbar', slot = 1, info = '', amount = TotalGoldBar}, [2] = {name = 'goldchain', slot = 2, info = '', amount = SmeltingData['goldchain']}}
        elseif SmeltingData['heirloom'] ~= nil and SmeltingData['heirloom'] > 0 then
            Inventory = {[1] = {name = 'goldbar', slot = 1, info = '', amount = TotalGoldBar}, [2] = {name = 'heirloom', slot = 2, info = '', amount = SmeltingData['heirloom']}}
        end
        exports['ls-inventory-new']:SetInventoryItems("Smelter", Inventory)
        SmeltingData, Smelting, TotalGoldBar = {}, false, 0
    end)
end

-- // PawnShop \\ --

RegisterServerEvent('ls-pawnshop:server:try:sell')
AddEventHandler('ls-pawnshop:server:try:sell', function(InventoryName, Type)
    local RecieveMoney = 0
    local Player = LSCore.Functions.GetPlayer(source)
    local InventoryItems = exports['ls-inventory-new']:GetInventoryItems(InventoryName)
    if InventoryItems ~= nil then
        if Type == 'BarsItem' then
            for k, v in pairs(InventoryItems) do
                if Config.SellItems[v.name] ~= nil then
                    RecieveMoney = RecieveMoney + (Config.SellItems[v.name] * v.amount)
                    InventoryItems[k] = nil
                end
            end
            if RecieveMoney > 0 then
                exports['ls-inventory-new']:SetInventoryItems("Inkoper: 1", InventoryItems)
                Player.Functions.AddMoney('cash', RecieveMoney)
            else
                TriggerClientEvent('LSCore:Notify', source, 'Er is niks om te verkopen..', 'error')
            end
        end
    else
        TriggerClientEvent('LSCore:Notify', source, 'Er is niks om te verkopen..', 'error')
    end
end)