local LSCore = exports['ls-core']:GetCoreObject()

-- Code

LSCore.Functions.CreateCallback("ls-autocare:server:get:config", function(source, cb)
    cb(Config)
end)

LSCore.Functions.CreateCallback('ls-autocare:server:get:vehicle:part', function(source, cb, plate)
    LSCore.Functions.ExecuteSql(false, "SELECT * FROM `player_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        if result[1] ~= nil then
            cb(json.decode(result[1].parts))
        else
            cb(false)
        end
    end)
end)

LSCore.Functions.CreateCallback('ls-autocare:server:has:repair:parts', function(source, cb, partsdata, partclass)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    local PartItem = Player.Functions.GetItemByName(partsdata['Item'])
    if PartItem ~= nil and PartItem.amount >= partsdata[partclass]['Amount'] then
        if Player.Functions.RemoveItem(partsdata['Item'], partsdata[partclass]['Amount'], false, true) then
            cb(true)
        else
            cb(false)
        end
    else
        cb(false)
    end
end)

RegisterServerEvent('ls-autocare:server:delete:vehicle:data')
AddEventHandler('ls-autocare:server:delete:vehicle:data', function(Plate)
    SaveVehicleParts(Plate, Config.VehiclePartData[Plate])
    Config.VehiclePartData[Plate] = nil
    TriggerClientEvent('ls-autocare:server:sync:parts:config', -1, Config.VehiclePartData)
end)

RegisterServerEvent('ls-autocare:server:set:part:data')
AddEventHandler('ls-autocare:server:set:part:data', function(Plate, Part, Value)
    Config.VehiclePartData[Plate][Part]['Procent'] = Value
    SaveVehicleParts(Plate, Config.VehiclePartData[Plate])
    TriggerClientEvent('ls-autocare:server:sync:parts:config', -1, Config.VehiclePartData)
end)

RegisterServerEvent('ls-autocare:server:set:new:part')
AddEventHandler('ls-autocare:server:set:new:part', function(Plate, Part, Class)
    Config.VehiclePartData[Plate][Part]['Class'] = Class
    SaveVehicleParts(Plate, Config.VehiclePartData[Plate])
    TriggerClientEvent('ls-autocare:server:sync:parts:config', -1, Config.VehiclePartData)
end)

RegisterServerEvent('ls-autocare:server:set:busy:vehicle')
AddEventHandler('ls-autocare:server:set:busy:vehicle', function(Plate, Bool)
    Config.BusyVehicles[Plate] = Bool
    TriggerClientEvent('ls-autocare:server:sync:busy:config', -1, Config.VehiclePartData)
end)

RegisterServerEvent('ls-autocare:server:register:vehicle')
AddEventHandler('ls-autocare:server:register:vehicle', function(Plate, VehicleParts)
    Config.VehiclePartData[Plate] = {}
    Config.BusyVehicles[Plate] = false
    for k, v in pairs(VehicleParts) do
        Config.VehiclePartData[Plate][tostring(k)] = v
    end
    SaveVehicleParts(Plate, Config.VehiclePartData[Plate])
    TriggerClientEvent('ls-autocare:server:sync:parts:config', -1, Config.VehiclePartData)
end)

RegisterServerEvent('ls-autocare:server:do:damage')
AddEventHandler('ls-autocare:server:do:damage', function(Plate)
    if Config.VehiclePartData[Plate] ~= nil then
        for k, v in pairs(Config.VehiclePartData[Plate]) do
            if Config.VehiclePartData[Plate][k]['Class'] == 'A' then
                local RandomMinus = math.random(1, 4)
                if Config.VehiclePartData[Plate][k]['Procent'] - RandomMinus > 0 then
                    Config.VehiclePartData[Plate][k]['Procent'] = Config.VehiclePartData[Plate][k]['Procent'] - RandomMinus
                else
                    Config.VehiclePartData[Plate][k]['Procent'] = 0
                end
            elseif Config.VehiclePartData[Plate][k]['Class'] == 'B' then
                local RandomMinus = math.random(1, 5)
                if Config.VehiclePartData[Plate][k]['Procent'] - RandomMinus > 0 then
                    Config.VehiclePartData[Plate][k]['Procent'] = Config.VehiclePartData[Plate][k]['Procent'] - RandomMinus
                else
                    Config.VehiclePartData[Plate][k]['Procent'] = 0
                end
            else
                local RandomMinus = math.random(1, 2)
                if Config.VehiclePartData[Plate][k]['Procent'] - RandomMinus > 0 then
                    Config.VehiclePartData[Plate][k]['Procent'] = Config.VehiclePartData[Plate][k]['Procent'] - RandomMinus
                else
                    Config.VehiclePartData[Plate][k]['Procent'] = 0
                end
            end
        end
        SaveVehicleParts(Plate, Config.VehiclePartData[Plate])
        TriggerClientEvent('ls-autocare:server:sync:parts:config', -1, Config.VehiclePartData)
    end
end)

function GetCraftingConfig(ItemId)
    return Config.MechanicCrafting[ItemId]
end

function SaveVehicleParts(Plate, PartData)
    LSCore.Functions.ExecuteSql(false, "UPDATE `player_vehicles` SET `parts` = '"..json.encode(PartData).."' WHERE  `plate` = '"..Plate.."'")
end

-- // Items \\ --

LSCore.Functions.CreateUseableItem("clutch-a", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('ls-autocare:client:use:part', source, 'Koppeling', 'A', 'clutch-a')
    end
end)

LSCore.Functions.CreateUseableItem("clutch-b", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('ls-autocare:client:use:part', source, 'Koppeling', 'B', 'clutch-b')
    end
end)

LSCore.Functions.CreateUseableItem("clutch-s", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('ls-autocare:client:use:part', source, 'Koppeling', 'S', 'clutch-s')
    end
end)

LSCore.Functions.CreateUseableItem("axle-a", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('ls-autocare:client:use:part', source, 'Aandrijfas', 'A', 'axle-a')
    end
end)

LSCore.Functions.CreateUseableItem("axle-b", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('ls-autocare:client:use:part', source, 'Aandrijfas', 'B', 'axle-b')
    end
end)

LSCore.Functions.CreateUseableItem("axle-s", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('ls-autocare:client:use:part', source, 'Aandrijfas', 'S', 'axle-s')
    end
end)

LSCore.Functions.CreateUseableItem("brakes-a", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('ls-autocare:client:use:part', source, 'Remmen', 'A', 'brakes-a')
    end
end)

LSCore.Functions.CreateUseableItem("brakes-b", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('ls-autocare:client:use:part', source, 'Remmen', 'B', 'brakes-b')
    end
end)

LSCore.Functions.CreateUseableItem("brakes-s", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('ls-autocare:client:use:part', source, 'Remmen', 'S', 'brakes-s')
    end
end)

LSCore.Functions.CreateUseableItem("engine-a", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('ls-autocare:client:use:part', source, 'Motor', 'A', 'engine-a')
    end
end)

LSCore.Functions.CreateUseableItem("engine-b", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('ls-autocare:client:use:part', source, 'Motor', 'B', 'engine-b')
    end
end)

LSCore.Functions.CreateUseableItem("engine-s", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('ls-autocare:client:use:part', source, 'Motor', 'S', 'engine-s')
    end
end)

LSCore.Functions.CreateUseableItem("injectors-a", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('ls-autocare:client:use:part', source, 'Brandstof Injectoren', 'A', 'injectors-a')
    end
end)

LSCore.Functions.CreateUseableItem("injectors-b", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('ls-autocare:client:use:part', source, 'Brandstof Injectoren', 'B', 'injectors-b')
    end
end)

LSCore.Functions.CreateUseableItem("injectors-s", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('ls-autocare:client:use:part', source, 'Brandstof Injectoren', 'S', 'injectors-s')
    end
end)

LSCore.Functions.CreateUseableItem("transmission-a", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('ls-autocare:client:use:part', source, 'Transmissie', 'A', 'transmission-a')
    end
end)

LSCore.Functions.CreateUseableItem("transmission-b", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('ls-autocare:client:use:part', source, 'Transmissie', 'B', 'transmission-b')
    end
end)

LSCore.Functions.CreateUseableItem("transmission-s", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('ls-autocare:client:use:part', source, 'Transmissie', 'S', 'transmission-s')
    end
end)

LSCore.Functions.CreateUseableItem("big-repair", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('ls-autocare:client:use:repair', source)
    end
end)

LSCore.Commands.Add("setmechanic", "Neem neen monteur aan", {{name="id", help="Speler ID"}}, true, function(source, args)
    local Player = LSCore.Functions.GetPlayer(source)
    local TargetPlayer = LSCore.Functions.GetPlayer(tonumber(args[1]))
    if Player.PlayerData.metadata['ishighcommand'] and Player.PlayerData.job.name == 'mechanic' then
        if TargetPlayer ~= nil then
            TriggerClientEvent('LSCore:Notify', TargetPlayer.PlayerData.source, 'Je bent aangenomen als monteur! gefeliciteerd!', 'success')
            TriggerClientEvent('LSCore:Notify', Player.PlayerData.source, 'Je hebt '..TargetPlayer.PlayerData.charinfo.firstname..' '..TargetPlayer.PlayerData.charinfo.lastname..' aangenomen als agent!', 'success')
            TargetPlayer.Functions.SetJob('mechanic', 1)
        end
    elseif  Player.PlayerData.metadata['ishighcommand'] and Player.PlayerData.job.name == 'repairshop' then
        if TargetPlayer ~= nil then
            TriggerClientEvent('LSCore:Notify', TargetPlayer.PlayerData.source, 'Je bent aangenomen als monteur! gefeliciteerd!', 'success')
            TriggerClientEvent('LSCore:Notify', Player.PlayerData.source, 'Je hebt '..TargetPlayer.PlayerData.charinfo.firstname..' '..TargetPlayer.PlayerData.charinfo.lastname..' aangenomen als monteur!', 'success')
            TargetPlayer.Functions.SetJob('repairshop', 1)
        end
    end
end)

LSCore.Commands.Add("firemechanic", "Ontsla een monteur", {{name="id", help="Speler ID"}}, true, function(source, args)
    local Player = LSCore.Functions.GetPlayer(source)
    local TargetPlayer = LSCore.Functions.GetPlayer(tonumber(args[1]))
    if Player.PlayerData.metadata['ishighcommand'] and Player.PlayerData.job.name == 'mechanic' then
        if TargetPlayer ~= nil and TargetPlayer.PlayerData.job.name == 'mechanic' then
            TriggerClientEvent('LSCore:Notify', TargetPlayer.PlayerData.source, 'Je bent ontslagen!', 'error')
            TriggerClientEvent('LSCore:Notify', Player.PlayerData.source, 'Je hebt '..TargetPlayer.PlayerData.charinfo.firstname..' '..TargetPlayer.PlayerData.charinfo.lastname..' ontslagen!', 'success')
            TargetPlayer.Functions.SetJob('unemployed', 1)
        end
    elseif Player.PlayerData.metadata['ishighcommand'] and Player.PlayerData.job.name == 'repairshop' then
        if TargetPlayer ~= nil and TargetPlayer.PlayerData.job.name == 'repairshop' then
            TriggerClientEvent('LSCore:Notify', TargetPlayer.PlayerData.source, 'Je bent ontslagen!', 'error')
            TriggerClientEvent('LSCore:Notify', Player.PlayerData.source, 'Je hebt '..TargetPlayer.PlayerData.charinfo.firstname..' '..TargetPlayer.PlayerData.charinfo.lastname..' ontslagen!', 'success')
            TargetPlayer.Functions.SetJob('unemployed', 1)
        end
    end
end)