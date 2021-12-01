local LSCore = exports['ls-core']:GetCoreObject()

-- Code

LSCore.Commands.Add("skin", "Ooohja toch", {}, false, function(source, args)
	TriggerClientEvent("ls-clothing:client:openMenu", source)
end, "admin")

RegisterServerEvent("ls-clothing:saveSkin")
AddEventHandler('ls-clothing:saveSkin', function(model, skin)
    local Player = LSCore.Functions.GetPlayer(source)
    if model ~= nil and skin ~= nil then 
        LSCore.Functions.ExecuteSql(false, "DELETE FROM `player_skins` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function()
          LSCore.Functions.ExecuteSql(false, "INSERT INTO `player_skins` (`citizenid`, `model`, `skin`) VALUES ('"..Player.PlayerData.citizenid.."', '"..model.."', '"..skin.."')")
        end)
    end
end)

RegisterServerEvent("ls-clothing:loadPlayerSkin")
AddEventHandler('ls-clothing:loadPlayerSkin', function()
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    LSCore.Functions.ExecuteSql(false, "SELECT * FROM `player_skins` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(result)
        if result[1] ~= nil then
            TriggerClientEvent("ls-clothing:loadSkin", src, false, result[1].model, result[1].skin)
        else
            TriggerClientEvent("ls-clothing:loadSkin", src, true)
        end
    end)
end)

RegisterServerEvent("ls-clothing:saveOutfit")
AddEventHandler("ls-clothing:saveOutfit", function(outfitName, model, skinData)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    if model ~= nil and skinData ~= nil then
        local outfitId = "outfit-"..math.random(1, 10).."-"..math.random(1111, 9999)
        LSCore.Functions.ExecuteSql(false, "INSERT INTO `player_outfits` (`citizenid`, `outfitname`, `model`, `skin`, `outfitId`) VALUES ('"..Player.PlayerData.citizenid.."', '"..outfitName.."', '"..model.."', '"..json.encode(skinData).."', '"..outfitId.."')", function()
            LSCore.Functions.ExecuteSql(false, "SELECT * FROM `player_outfits` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(result)
                if result[1] ~= nil then
                    TriggerClientEvent('ls-clothing:client:reloadOutfits', src, result)
                else
                    TriggerClientEvent('ls-clothing:client:reloadOutfits', src, nil)
                end
            end)
        end)
    end
end)

RegisterServerEvent("ls-clothing:server:removeOutfit")
AddEventHandler("ls-clothing:server:removeOutfit", function(outfitName, outfitId)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)

    LSCore.Functions.ExecuteSql(false, "DELETE FROM `player_outfits` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."' AND `outfitname` = '"..outfitName.."' AND `outfitId` = '"..outfitId.."'", function()
        LSCore.Functions.ExecuteSql(false, "SELECT * FROM `player_outfits` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(result)
            if result[1] ~= nil then
                TriggerClientEvent('ls-clothing:client:reloadOutfits', src, result)
            else
                TriggerClientEvent('ls-clothing:client:reloadOutfits', src, nil)
            end
        end)
    end)
end)

LSCore.Functions.CreateCallback('ls-clothing:server:getOutfits', function(source, cb)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    local anusVal = {}

    LSCore.Functions.ExecuteSql(false, "SELECT * FROM `player_outfits` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(result)
        if result[1] ~= nil then
            for k, v in pairs(result) do
                result[k].skin = json.decode(result[k].skin)
                anusVal[k] = v
            end
            cb(anusVal)
        end
        cb(anusVal)
    end)
end)