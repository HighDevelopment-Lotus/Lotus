local LSCore = exports['fw-base']:GetCoreObject()

LSCore.Functions.CreateCallback('framework-tattoos:GetPlayerTattoos', function(source, cb)
	local src = source
	local xPlayer = LSCore.Functions.GetPlayer(src)
	if xPlayer then
		LSCore.Functions.ExecuteSql(true, "SELECT `tattoos` FROM `players` WHERE `citizenid` = '"..xPlayer.PlayerData.citizenid.."'", function(result)
			if result[1].tattoos and result[1].tattoos ~= nil then
				cb(json.decode(result[1].tattoos))
			else
				cb()
			end
		end)
	else
		cb()
	end
end)

LSCore.Functions.CreateCallback('framework-tattoos:GetPlayerTattoosMC', function(source, cb, citizenid)
	local src = source
	local xPlayer = LSCore.Functions.GetPlayer(src)


	LSCore.Functions.ExecuteSql(true, "SELECT `tattoos` FROM `players` WHERE `citizenid` = '"..citizenid.."'", function(result)
		if result[1].tattoos and result[1].tattoos ~= nil then
			cb(json.decode(result[1].tattoos))
		else
			cb()
		end
	end)
end)

LSCore.Functions.CreateCallback('framework-tattoos:PurchaseTattoo', function(source, cb, tattooList, price, tattoo, tattooName)
	local src = source
	local xPlayer = LSCore.Functions.GetPlayer(src)

	if xPlayer.PlayerData.money.cash >= price then
		xPlayer.Functions.RemoveMoney('cash', price, "tattoo-shop")
		table.insert(tattooList, tattoo)

		LSCore.Functions.ExecuteSql(true, "UPDATE `players` SET `tattoos` = '"..json.encode(tattooList).."' WHERE citizenid = '"..xPlayer.PlayerData.citizenid.."'", function(result)
		end)

		TriggerClientEvent('LSCore:Notify', src, "Je hebt de tattoo " .. tattooName .. " gekocht voor €" .. price, 'success', 3500)
		cb(true)
	elseif xPlayer.PlayerData.money.bank >= price then
		xPlayer.Functions.RemoveMoney('bank', price, "tattoo-shop")
		TriggerEvent('LSCore:banking/addTransaction', src, xPlayer.PlayerData.charinfo.account, 'Remove', 'Contactloze betaling tattooshop', price)
		table.insert(tattooList, tattoo)

		LSCore.Functions.ExecuteSql(true, "UPDATE `players` SET `tattoos` = '"..json.encode(tattooList).."' WHERE citizenid = '"..xPlayer.PlayerData.citizenid.."'", function(result)
		end)

		TriggerClientEvent('LSCore:Notify', src, "Je hebt de tattoo " .. tattooName .. " gekocht voor €" .. price, 'success', 3500)
		cb(true)
	else
		TriggerClientEvent('LSCore:Notify', src, 'Je hebt niet genoeg geld voor deze tattoo.', 'error', 3500)
		cb(false)
	end
end)

RegisterServerEvent('framework-tattoos:RemoveTattoo')
AddEventHandler('framework-tattoos:RemoveTattoo', function (tattooList)
	local src = source
	local xPlayer = LSCore.Functions.GetPlayer(src)
	LSCore.Functions.ExecuteSql(true, "UPDATE `players` SET `tattoos` = '"..json.encode(tattooList).."' WHERE citizenid = '"..xPlayer.PlayerData.citizenid.."'", function(result)
	end)
end)
