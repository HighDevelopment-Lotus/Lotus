local LSCore = exports['fw-base']:GetCoreObject()

LSCore.Functions.CreateUseableItem("bowlingball", function(source, item)
    local Player = LSCore.Functions.GetPlayer(source)
    TriggerClientEvent('framework-bowling:client:itemused', source)
end)

LSCore.Functions.CreateCallback('framework-bowling:purchaseItem', function(source, cb , key , lane)
    local Player = LSCore.Functions.GetPlayer(source)
    if(lane == true) then
        Player.Functions.RemoveMoney("cash", 10, false, false, true)
        local info = {
            lane = key
        }
        Player.Functions.AddItem('bowlingreceipt', 1, info, false, false, true)
        cb(true)
    else
        cb(true)
        Player.Functions.RemoveMoney("cash", 8, false, false, true)
        Player.Functions.AddItem('bowlingball', 1, info, false, false, true)
    end
end)

LSCore.Functions.CreateCallback('framework-bowling:getLaneAccess', function(source, cb , currentid)
    local Player = LSCore.Functions.GetPlayer(source)
    local item = Player.Functions.GetItemByName('bowlingreceipt')
    if(item == nil) then
        cb(false)
    else
        if(item.info.lane == currentid) then
            cb(true)
        end
    end
end)
 
RegisterServerEvent("framework-bowling:RemoveItem")
AddEventHandler("framework-bowling:RemoveItem" , function()
    local Player = LSCore.Functions.GetPlayer(source)
    Player.Functions.RemoveItem('bowlingball', 1, false, true)
    Player.Functions.RemoveItem('bowlingreceipt', 1, false, true)
end)