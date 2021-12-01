-- LSCore = nil
-- TriggerEvent('LSCore:GetObject', function(obj) LSCore = obj end)
local LSCore = exports['ls-core']:GetCoreObject()
-- Appearance Data

RegisterServerEvent('fivem-appearance:save')
AddEventHandler('fivem-appearance:save', function(appearance)
    local xPlayer = LSCore.Functions.GetPlayer(source)
    local Skin = json.encode(appearance)

    LSCore.Functions.ExecuteSql(false, 'SELECT * FROM `player_appearance` WHERE `citizenid` = "'..xPlayer.PlayerData.citizenid..'"', function(result)
        if result ~= nil and result[1] ~= nil then
            LSCore.Functions.ExecuteSql(false, 'UPDATE `player_appearance` SET `skin` = "'..LSCore.EscapeSqli(Skin)..'" WHERE `citizenid` = "'..xPlayer.PlayerData.citizenid..'"')
        else
            LSCore.Functions.ExecuteSql(false, "INSERT INTO `player_appearance` (`citizenid`, `skin`) VALUES ('"..xPlayer.PlayerData.citizenid.."', '"..LSCore.EscapeSqli(Skin).."')")
        end
    end)
end)

LSCore.Functions.CreateCallback('fivem-appearance:getPlayerSkin', function(source, cb, skin)
    local xPlayer = LSCore.Functions.GetPlayer(source)

    LSCore.Functions.ExecuteSql(false, 'SELECT * FROM `player_appearance` WHERE `citizenid` = "'..xPlayer.PlayerData.citizenid..'"', function(result)
        if result ~= nil and result[1] ~= nil then
            local Skin = json.decode(result[1].skin)
            cb(Skin)
        else
            cb(nil)
        end
    end)
end)

-- Command notc0rx#8463
LSCore.Commands.Add("skin", "Change Skin", {}, false, function(source, args)
	--TriggerClientEvent("ls-clothing:client:openMenu", source)
	TriggerClientEvent("fivem-appearance:client:CreateFirstCharacter", source)
end, "admin")

-- Player Outfits Data

RegisterServerEvent("fivem-appearance:saveOutfit")
AddEventHandler("fivem-appearance:saveOutfit", function(name, pedModel, pedComponents, pedProps)
	local xPlayer = LSCore.Functions.GetPlayer(source)
	local Outfit = name
	local Model = json.encode(pedModel)
	local Components = json.encode(pedComponents)
	local Props = json.encode(pedProps)

	print('saved')
    LSCore.Functions.ExecuteSql(false, "INSERT INTO `player_outfits` (`citizenid`, `name`, `ped`, `components`, `props`) VALUES ('"..xPlayer.PlayerData.citizenid.."', '"..LSCore.EscapeSqli(Outfit).."' , '"..LSCore.EscapeSqli(Model).."', '"..LSCore.EscapeSqli(Components).."', '"..LSCore.EscapeSqli(Props).."')")
end)

RegisterServerEvent("fivem-appearance:getOutfit")
AddEventHandler("fivem-appearance:getOutfit", function(name)
	local xPlayer = LSCore.Functions.GetPlayer(source)
	local oSource = source

	exports['ghmattimysql']:scalar('SELECT outfit FROM player_outfits WHERE citizenid = @identifier AND name = @name', {
		['@identifier'] = xPlayer.PlayerData.citizenid,
		['@name'] = name
	}, function(outfit)
		local newOutfit = outfit
		if newOutfit then
			newOutfit = json.decode(newOutfit)
			TriggerClientEvent('fivem-appearance:setOutfit', oSource, newOutfit)
		end
	end)
end)

RegisterServerEvent("fivem-appearance:getOutfits")
AddEventHandler("fivem-appearance:getOutfits", function()
	local xPlayer = LSCore.Functions.GetPlayer(source)
	local oSource = source
	local myOutfits = {}

	exports.ghmattimysql:execute('SELECT id, name, ped, components, props FROM player_outfits WHERE citizenid = @identifier', {
		['@identifier'] = xPlayer.PlayerData.citizenid
	}, function(result)
		for i=1, #result, 1 do
			table.insert(myOutfits, {id = result[i].id, name = result[i].name, ped = json.decode(result[i].ped), components = json.decode(result[i].components), props = json.decode(result[i].props)})
		end
		TriggerClientEvent('fivem-appearance:sendOutfits', oSource, myOutfits)
	end)
end)

-- PD Presets Data

RegisterServerEvent("fivem-appearance:getpdPreset")
AddEventHandler("fivem-appearance:getpdPreset", function(name)
	local xPlayer = LSCore.Functions.GetPlayer(source)
	local oSource = source

	exports['ghmattimysql']:scalar('SELECT preset FROM player_pdpresets WHERE name = @name', {
		['@name'] = name
	}, function(preset)
		local newPreset = preset
		if newPreset then
			newPreset = json.decode(newPreset)
			TriggerClientEvent('fivem-appearance:setpdPreset', oSource, newPreset)
		end
	end)
end)

RegisterServerEvent("fivem-appearance:getpdPresets")
AddEventHandler("fivem-appearance:getpdPresets", function()
	local xPlayer = LSCore.Functions.GetPlayer(source)
	local oSource = source
	local pdPresets = {}

	exports.ghmattimysql:execute('SELECT id, name, ped, components, props FROM player_pdpresets', function(result)
		for i=1, #result, 1 do
			table.insert(pdPresets, {id = result[i].id, name = result[i].name, ped = json.decode(result[i].ped), components = json.decode(result[i].components), props = json.decode(result[i].props)})
		end
		TriggerClientEvent('fivem-appearance:sendpdPresets', oSource, pdPresets)
	end)
end)

-- Delete Player Outfits Data

RegisterServerEvent("fivem-appearance:deleteOutfit")
AddEventHandler("fivem-appearance:deleteOutfit", function(id)
	local xPlayer = LSCore.Functions.GetPlayer(source)

	exports.ghmattimysql:execute('DELETE FROM `player_outfits` WHERE `id` = @id', {
		['@id'] = id
	})
end)