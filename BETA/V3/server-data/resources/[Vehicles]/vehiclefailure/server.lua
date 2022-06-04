Framework = nil
TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

Framework.Commands.Add("fix", "Repareer een voertuig", {}, false, function(source, args)
    TriggerClientEvent('iens:repaira', source)
    TriggerClientEvent('vehiclemod:client:fixEverything', source)
end, "admin")

Framework.Functions.CreateUseableItem("repairkit", function(source, item)
    local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("vehiclefailure:client:RepairVehicle", source)
    end
end)

Framework.Functions.CreateUseableItem("cleaningkit", function(source, item)
    local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("vehiclefailure:client:CleanVehicle", source)
    end
end)

Framework.Functions.CreateUseableItem("advancedrepairkit", function(source, item)
    local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("vehiclefailure:client:RepairVehicleFull", source)
    end
end)

RegisterServerEvent('kwk-vehiclefailure:removeItem')
AddEventHandler('kwk-vehiclefailure:removeItem', function(item)
    local src = source
    local ply = Framework.Functions.GetPlayer(src)
    ply.Functions.RemoveItem(item, 1)
end)

RegisterServerEvent('vehiclefailure:server:removewashingkit')
AddEventHandler('vehiclefailure:server:removewashingkit', function(item)
    local src = source
    local ply = Framework.Functions.GetPlayer(src)
    ply.Functions.RemoveItem("cleaningkit", 1)
end)

