LSCore = exports["fw-base"]:GetCoreObject()
PlayerData = {}

Citizen.CreateThread(function()
	while LSCore.Functions.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	PlayerData = LSCore.Functions.GetPlayerData()
end)

RegisterNetEvent("LSCore:Client:OnPlayerLoaded")
AddEventHandler("LSCore:Client:OnPlayerLoaded", function()
	PlayerData = LSCore.Functions.GetPlayerData()
end)

RegisterNetEvent("LSCore:Client:OnJobUpdate")
AddEventHandler("LSCore:Client:OnJobUpdate", function(job)
	PlayerData.job = job
end)

function MyInvoices()
	LSCore.Functions.TriggerCallback("framework-invoices:GetInvoices", function(invoices)
		SetNuiFocus(true, true)
		SendNUIMessage({
			action = 'myinvoices',
			invoices = invoices,
			VAT = Config.VATPercentage
		})			
	end)
end

function SocietyInvoices(society)
	LSCore.Functions.TriggerCallback("framework-invoices:GetSocietyInvoices", function(cb, totalInvoices, totalIncome, totalUnpaid, awaitedIncome)
		if json.encode(cb) ~= '[]' then
			SetNuiFocus(true, true)
			SendNUIMessage({
				action = 'societyinvoices',
				invoices = cb,
				totalInvoices = totalInvoices,
				totalIncome = totalIncome,
				totalUnpaid = totalUnpaid,
				awaitedIncome = awaitedIncome,
				VAT = Config.VATPercentage
			})		
		else
			LSCore.Functions.Notify("Uw bedrijf heeft geen facturen uitstaan.")
			SetNuiFocus(false, false)
		end
	end, society)
end

function CreateInvoice(society)
	SetNuiFocus(true, true)
	SendNUIMessage({
		action = 'createinvoice',
		society = society
	})
end

RegisterNetEvent("framework-invoices:menu")
AddEventHandler("framework-invoices:menu", function()
	local isAllowed = false
	local jobName = ""
	for k, v in pairs(Config.AllowedSocieties) do
		if v == PlayerData.job.name then
			jobName = v
			isAllowed = true
		end
	end

	if Config.OnlyBossCanAccessSocietyInvoices and PlayerData.job.isboss == true and isAllowed then
		SetNuiFocus(true, true)
		SendNUIMessage({
			action = 'mainmenu',
			society = true,
			create = true
		})
	elseif Config.OnlyBossCanAccessSocietyInvoices and PlayerData.job.isboss ~= true and isAllowed then
		SetNuiFocus(true, true)
		SendNUIMessage({
			action = 'mainmenu',
			society = false,
			create = true
		})
	elseif not Config.OnlyBossCanAccessSocietyInvoices and isAllowed then
		SetNuiFocus(true, true)
		SendNUIMessage({
			action = 'mainmenu',
			society = true,
			create = true
		})
	elseif not isAllowed then
		SetNuiFocus(true, true)
		SendNUIMessage({
			action = 'mainmenu',
			society = false,
			create = false
		})
	end
end, false)

RegisterCommand(Config.InvoicesCommand, function()
	local isAllowed = false
	local jobName = ""
	for k, v in pairs(Config.AllowedSocieties) do
		if v == PlayerData.job.name then
			jobName = v
			isAllowed = true
		end
	end

	if Config.OnlyBossCanAccessSocietyInvoices and PlayerData.job.isboss == true and isAllowed then
		SetNuiFocus(true, true)
		SendNUIMessage({
			action = 'mainmenu',
			society = true,
			create = true
		})
	elseif Config.OnlyBossCanAccessSocietyInvoices and PlayerData.job.isboss ~= true and isAllowed then
		SetNuiFocus(true, true)
		SendNUIMessage({
			action = 'mainmenu',
			society = false,
			create = true
		})
	elseif not Config.OnlyBossCanAccessSocietyInvoices and isAllowed then
		SetNuiFocus(true, true)
		SendNUIMessage({
			action = 'mainmenu',
			society = true,
			create = true
		})
	elseif not isAllowed then
		SetNuiFocus(true, true)
		SendNUIMessage({
			action = 'mainmenu',
			society = false,
			create = false
		})
	end
end, false)

RegisterNUICallback("action", function(data, cb)
	if data.action == "close" then
		SetNuiFocus(false, false)
	elseif data.action == "payInvoice" then
		TriggerServerEvent("framework-invoices:PayInvoice", data.invoice_id)
		SetNuiFocus(false, false)
	elseif data.action == "cancelInvoice" then
		TriggerServerEvent("framework-invoices:CancelInvoice", data.invoice_id)
		SetNuiFocus(false, false)
	elseif data.action == "createInvoice" then
		local closestPlayer, playerDistance = LSCore.Functions.GetClosestPlayer()
		target = GetPlayerServerId(closestPlayer)
		data.target = target
		data.society = PlayerData.job.name
		data.society_name = PlayerData.job.label
		print(data)
		if closestPlayer == -1 or playerDistance > 3.0 then
			LSCore.Functions.Notify("De factuur kon niet worden verzonden! Er is niemand bij je in de buurt..", 'error')
		else
			TriggerServerEvent("framework-invoices:CreateInvoice", data)
			LSCore.Functions.Notify("Factuur verzonden!", 'success')
		end
		
		SetNuiFocus(false, false)
	elseif data.action == "missingInfo" then
		LSCore.Functions.Notify("Vul alle velden in voordat u een factuur verstuurd!", 'error')
	elseif data.action == "negativeAmount" then
		LSCore.Functions.Notify("U moet een positief bedrag invoeren!", 'error')
	elseif data.action == "mainMenuOpenMyInvoices" then
		MyInvoices()
	elseif data.action == "mainMenuOpenSocietyInvoices" then
		for k, v in pairs(Config.AllowedSocieties) do
			if v == PlayerData.job.name then
				if Config.OnlyBossCanAccessSocietyInvoices and PlayerData.job.isboss == true then
					SocietyInvoices(PlayerData.job.label)
				elseif not Config.OnlyBossCanAccessSocietyInvoices then
					SocietyInvoices(PlayerData.job.label)
				elseif Config.OnlyBossCanAccessSocietyInvoices then
					LSCore.Functions.Notify("Alleen de manager heeft toegang tot de facturen van het bedrijf.", 'error')
				end
			end
		end
	elseif data.action == "mainMenuOpenCreateInvoice" then
		for k, v in pairs(Config.AllowedSocieties) do
			if v == PlayerData.job.name then
				CreateInvoice(PlayerData.job.label)
			end
		end
	end
end)