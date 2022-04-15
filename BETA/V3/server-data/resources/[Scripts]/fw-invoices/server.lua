local LSCore = exports["fw-base"]:GetCoreObject()
local Webhook = 'https://discordapp.com/api/webhooks/928200852685094933/KG38_M0725Kw48fgF8uL1ScmFJ7Wn5v-hUJjyQWHBiMhLqoKVOSHxFIKUizMByfVd7iO'
local limiteTimeHours = Config.LimitDateDays*24
local hoursToPay = limiteTimeHours
local whenToAddFees = {}

for i = 1, Config.LimitDateDays, 1 do
	hoursToPay = hoursToPay - 24
	table.insert(whenToAddFees, hoursToPay)
end

LSCore.Functions.CreateCallback("framework-invoices:GetInvoices", function(source, cb)
	local xPlayer = LSCore.Functions.GetPlayer(source)
	local Player = source

	exports['oxmysql']:fetch('SELECT * FROM characters_invoices WHERE receiver_identifier = @identifier ORDER BY CASE WHEN status = "unpaid" THEN 1 WHEN status = "autopaid" THEN 2 WHEN status = "paid" THEN 3 WHEN status = "cancelled" THEN 4 END ASC, id DESC', {
		['@identifier'] = xPlayer.PlayerData.citizenid
	}, function(result)
		local invoices = {}

		if result ~= nil then
			for i=1, #result, 1 do
				table.insert(invoices, result[i])
			end
		end

		cb(invoices)
	end)
end)

RegisterServerEvent("framework-invoices:PayInvoice")
AddEventHandler("framework-invoices:PayInvoice", function(invoice_id)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)

	exports['oxmysql']:fetch('SELECT * FROM characters_invoices WHERE id = @id', {
		['@id'] = invoice_id
	}, function(result)
		local invoices = result[1]
		local playerMoney = Player.PlayerData.money.bank
		local job = Player.PlayerData.job.name
		local webhookData = {
			id = invoices.id,
			player_name = invoices.receiver_name,
			value = invoices.invoice_value,
			item = invoices.item,
			society = invoices.society_name
		}

		invoices.invoice_value = math.ceil(invoices.invoice_value)

		if playerMoney == nil then
			playerMoney = 0
		end

		if playerMoney < invoices.invoice_value then
			LSCore.Functions.Notify("Je hebt niet genoeg geld!", 'error')

			TriggerClientEvent('LSCore:Notify', Player, "Je hebt niet genoeg geld!", "success")
		else
			Player.Functions.RemoveMoney('bank', invoices.invoice_value)
			
			TriggerEvent('framework-bossmenu:server:addAccountMoney', invoices.society, invoices.invoice_value)

			exports['oxmysql']:execute('UPDATE characters_invoices SET status = @status, paid_date = CURRENT_TIMESTAMP WHERE id = @id', {
				['@status'] = 'paid',
				['@id'] = invoice_id
			})

			TriggerClientEvent('LSCore:Notify', Player, "Factuur succesvol betaald!", "success")
			if Webhook ~= '' then
				payInvoiceWebhook(webhookData)
			end
		end
	end)
end)

RegisterServerEvent("framework-invoices:CancelInvoice")
AddEventHandler("framework-invoices:CancelInvoice", function(invoice_id)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)

	exports['oxmysql']:fetchSync('SELECT * FROM characters_invoices WHERE id = @id', {
		['@id'] = invoice_id
	}, function(result)
		local invoices = result[1]
		local webhookData = {
			id = invoices.id,
			player_name = invoices.receiver_name,
			value = invoices.invoice_value,
			item = invoices.item,
			society = invoices.society_name,
			name = Player.PlayerData.name
		}
		exports['oxmysql']:execute('UPDATE characters_invoices SET status = "cancelled", paid_date = CURRENT_TIMESTAMP WHERE id = @id', {
			['@id'] = invoice_id
		})
		TriggerClientEvent('LSCore:Notify', Player, "U heeft de factuur geannuleerd", "error")
		if Webhook ~= '' then
			cancelInvoiceWebhook(webhookData)
		end
	end)
end)

RegisterServerEvent("framework-invoices:CreateInvoice")
AddEventHandler("framework-invoices:CreateInvoice", function(data)
    local src = source
	print(data.target)
    local Player = LSCore.Functions.GetPlayer(src)
	local target = LSCore.Functions.GetPlayer(data.target)
	print(target.PlayerData.name)
	local webhookData = {}
	exports['oxmysql']:fetchSync('SELECT id FROM characters_invoices WHERE id = (SELECT MAX(id) FROM characters_invoices)', {}, function(result)
		if result[1].id == nil then
			result[1].id = 0
		end
		webhookData = {
			id = result[1].id + 1,
			player_name = target.PlayerData.name,
			value = data.invoice_value,
			-- item = data.invoice_item,
			society = data.society_name,
			name = Player.PlayerData.name
		}
	end)

	if Config.LimitDate then
		exports['oxmysql']:insertSync('INSERT INTO characters_invoices (receiver_identifier, receiver_name, author_identifier, author_name, society, society_name, item, invoice_value, status, notes, targetrpname, sourcerpname, sent_date, limit_pay_date) VALUES (@receiver_identifier, @receiver_name, @author_identifier, @author_name, @society, @society_name, @item, @invoice_value, @status, @notes, @targetrpname, @sourcerpname, CURRENT_TIMESTAMP(), DATE_ADD(CURRENT_TIMESTAMP(), INTERVAL @limit_pay_date DAY))', {
			['@receiver_identifier'] = target.PlayerData.citizenid,
			['@receiver_name'] = target.PlayerData.name,
			['@author_identifier'] = Player.PlayerData.citizenid,
			['@author_name'] = Player.PlayerData.name,
			['@society'] = data.society,
			['@society_name'] = data.society_name,
			['@item'] = data.invoice_item,
			['@invoice_value'] = data.invoice_value,
			['@status'] = "unpaid",
			['@notes'] = data.invoice_notes,
			['@targetrpname'] = target.PlayerData.charinfo.firstname.." "..target.PlayerData.charinfo.lastname,
			['@sourcerpname'] = Player.PlayerData.charinfo.firstname.." "..Player.PlayerData.charinfo.lastname,
			['@limit_pay_date'] = Config.LimitDateDays,
			['@author_identifier'] = Player.PlayerData.citizenid
		}, function(result)
            TriggerClientEvent('LSCore:Notify', target.PlayerData.source, "U heeft zojuist een nieuwe factuur ontvangen", "error")
			if Webhook ~= '' then
				createNewInvoiceWebhook(webhookData)
			end
		end)
	else
		exports['oxmysql']:insertSync('INSERT INTO characters_invoices (receiver_identifier, receiver_name, author_identifier, author_name, society, society_name, item, invoice_value, status, notes, targetrpname, sourcerpname, sent_date, limit_pay_date) VALUES (@receiver_identifier, @receiver_name, @author_identifier, @author_name, @society, @society_name, @item, @invoice_value, @status, @notes, @targetrpname, @sourcerpname, CURRENT_TIMESTAMP(), DATE_ADD(CURRENT_TIMESTAMP(), INTERVAL @limit_pay_date DAY))', {
			['@receiver_identifier'] = target.PlayerData.citizenid,
			['@receiver_name'] = target.PlayerData.name,
			['@author_identifier'] = Player.PlayerData.citizenid,
			['@author_name'] = Player.PlayerData.name,
			['@society'] = data.society,
			['@society_name'] = data.society_name,
			['@item'] = data.invoice_item,
			['@invoice_value'] = data.invoice_value,
			['@status'] = "unpaid",
			['@notes'] = data.invoice_notes,
			['@targetrpname'] = target.PlayerData.charinfo.firstname.." "..target.PlayerData.charinfo.lastname,
			['@sourcerpname'] = Player.PlayerData.charinfo.firstname.." "..Player.PlayerData.charinfo.lastname,
			['@limit_pay_date'] = 'N/A'
		}, function(result)
            TriggerClientEvent('LSCore:Notify', target.PlayerData.source, "U heeft zojuist een nieuwe factuur ontvangen", "error")
			if Webhook ~= '' then
				createNewInvoiceWebhook(webhookData)
			end
		end)
	end
end)

LSCore.Functions.CreateCallback("framework-invoices:GetSocietyInvoices", function(source, cb, society)
	local xPlayer = LSCore.Functions.GetPlayer(source)

	exports['oxmysql']:fetch('SELECT * FROM characters_invoices WHERE society_name = @society ORDER BY id DESC', {
		['@society'] = society
	}, function(result)
		local invoices = {}
		local totalInvoices = 0
		local totalIncome = 0
		local totalUnpaid = 0
		local awaitedIncome = 0

		if result ~= nil then
			for i=1, #result, 1 do
				table.insert(invoices, result[i])
				totalInvoices = totalInvoices + 1

				if result[i].status == 'paid' then
					totalIncome = totalIncome + result[i].invoice_value
				elseif result[i].status == 'unpaid' then
					awaitedIncome = awaitedIncome + result[i].invoice_value
					totalUnpaid = totalUnpaid + 1
				end
			end
		end
		cb(invoices, totalInvoices, totalIncome, totalUnpaid, awaitedIncome)
	end)
end)

-- function checkTimeLeft()
-- 	exports['oxmysql']:transaction('SELECT *, TIMESTAMPDIFF(HOUR, limit_pay_date, CURRENT_TIMESTAMP()) AS "timeLeft" FROM characters_invoices WHERE status = "unpaid"', {}, function(result)
-- 		for k, v in ipairs(result) do
-- 			local invoice_value = v.invoice_value * (Config.FeeAfterEachDayPercentage / 100 + 1)
-- 			if v.timeLeft < 0 and Config.FeeAfterEachDay then
-- 				for k, vl in pairs(whenToAddFees) do
-- 					if v.fees_amount == k - 1 then
-- 						if v.timeLeft >= vl*(-1) then
-- 							LSCore.Functions.UpdateSql(true, 'UPDATE characters_invoices SET fees_amount = @fees_amount, invoice_value = @invoice_value WHERE id = @id', {
-- 								['@fees_amount'] = k,
-- 								['@invoice_value'] = v.invoice_value * (Config.FeeAfterEachDayPercentage / 100 + 1),
-- 								['@id'] = v.id
-- 							})
-- 						end
-- 					end
-- 				end
-- 			elseif v.timeLeft >= 0 and Config.PayAutomaticallyAfterLimit then
-- 				local xPlayer = LSCore.Functions.GetPlayerByCitizenId(v.receiver_identifier)
-- 				local webhookData = {
-- 					id = v.id,
-- 					player_name = v.receiver_name,
-- 					value = v.invoice_value,
-- 					item = v.item,
-- 					society = v.society_name
-- 				}

-- 				if xPlayer == nil then
--                         -- if xPlayer.Functions.RemoveMoney('bank', invoice_value, 'okok') then
-- 						-- 	TriggerEvent('framework-bossmenu:server:addAccountMoney', v.society, invoice_value)
-- 						-- 	LSCore.Functions.InsertSql(true, 'UPDATE characters_invoices SET status = @paid, paid_date = CURRENT_TIMESTAMP() WHERE id = @id', {
-- 						-- 		['@paid'] = 'autopaid',
-- 						-- 		['@id'] = v.id
-- 						-- 	})
-- 						-- else
-- 						-- 		xPlayer.Functions.RemoveMoney('cash', invoice_value, 'okok')
-- 						-- 		TriggerEvent('framework-bossmenu:server:addAccountMoney', v.society, invoice_value)
-- 						-- end
-- 				else
-- 					xPlayer.Functions.RemoveMoney('bank', invoice_value)
-- 					TriggerEvent('framework-bossmenu:server:addAccountMoney', v.society, invoice_value)

-- 					LSCore.Functions.UpdateSql(true, 'UPDATE characters_invoices SET status = @paid, paid_date = CURRENT_TIMESTAMP() WHERE id = @id', {
-- 						['@paid'] = 'autopaid',
-- 						['@id'] = v.id
-- 					})
-- 					if Webhook ~= '' then
-- 						autopayInvoiceWebhook(webhookData)
-- 					end
-- 				end
-- 			end
-- 		end
-- 	end)
-- 	-- SetTimeout(30 * 60000, checkTimeLeft)
-- end

-- if Config.PayAutomaticallyAfterLimit then
-- 	-- checkTimeLeft()
-- end

-------------------------- PAY INVOICE WEBHOOK

function payInvoiceWebhook(data)
	local information = {
		{
			["color"] = Config.PayInvoiceWebhookColor,
			["author"] = {
				["icon_url"] = Config.IconURL,
				["name"] = Config.ServerName..' - Logs',
			},
			["title"] = 'Factuur #'..data.id..' is betaald',
			["description"] = '**Ontvanger:** '..data.player_name..'\n**Value:** '..data.value..'€\n**Item:** '..data.item..'\n**TBV Bedrijfsrekening:** '..data.society,

			["footer"] = {
				["text"] = os.date(Config.DateFormat),
			}
		}
	}
	PerformHttpRequest(Webhook, function(err, text, headers) end, 'POST', json.encode({username = '', embeds = information}), {['Content-Type'] = 'application/json'})
end

-------------------------- CANCEL INVOICE WEBHOOK

function cancelInvoiceWebhook(data)
	local information = {
		{
			["color"] = Config.CancelInvoiceWebhookColor,
			["author"] = {
				["icon_url"] = Config.IconURL,
				["name"] = Config.ServerName..' - Logs',
			},
			["title"] = 'Factuur #'..data.id..' is geannuleerd',
			["description"] = '**Geannuleerd door:** '..data.name..'\n\n**Ontvanger:** '..data.player_name..'\n**Value:** '..data.value..'€\n**Item:** '..data.item..'\n**Bedrijf:** '..data.society,

			["footer"] = {
				["text"] = os.date(Config.DateFormat),
			}
		}
	}
	PerformHttpRequest(Webhook, function(err, text, headers) end, 'POST', json.encode({username = '', embeds = information}), {['Content-Type'] = 'application/json'})
end

-------------------------- CREATE NEW INVOICE WEBHOOK

function createNewInvoiceWebhook(data)
	local information = {
		{
			["color"] = Config.CreateNewInvoiceWebhookColor,
			["author"] = {
				["icon_url"] = Config.IconURL,
				["name"] = Config.ServerName..' - Logs',
			},
			["title"] = 'Factuur #'..data.id..' is aangemaakt',
			["description"] = '**Aangemaakt door:** '..data.name..'\n**Organisatie:** '..data.society..'\n\n**Ontvanger:** '..data.player_name..'\n**Bedrag:** € '..data.value..'',

			["footer"] = {
				["text"] = os.date(Config.DateFormat),
			}
		}
	}
	PerformHttpRequest(Webhook, function(err, text, headers) end, 'POST', json.encode({username = '', embeds = information}), {['Content-Type'] = 'application/json'})
end

-------------------------- AUTOPAY INVOICE WEBHOOK

function autopayInvoiceWebhook(data)
	local information = {
		{
			["color"] = Config.AutopayInvoiceWebhookColor,
			["author"] = {
				["icon_url"] = Config.IconURL,
				["name"] = Config.ServerName..' - Logs',
			},
			["title"] = 'Invoice #'..data.id..' has been autopaid',
			["description"] = '**Ontvanger:** '..data.player_name..'\n**Bedrag:** € '..data.value..'\n**Organisatie:** '..data.society,

			["footer"] = {
				["text"] = os.date(Config.DateFormat),
			}
		}
	}
	PerformHttpRequest(Webhook, function(err, text, headers) end, 'POST', json.encode({username = '', embeds = information}), {['Content-Type'] = 'application/json'})
end
