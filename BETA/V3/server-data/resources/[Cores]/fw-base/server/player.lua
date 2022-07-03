LSCore.Players = {}
LSCore.Player = {}

LSCore.Player.Login = function(Source, IsCharNew, CitizenId, newData)
	if Source ~= nil then
		if IsCharNew then
			local PlayerData = {}
			PlayerData.cid = newData.cid
			PlayerData.charinfo = {
				firstname = newData.firstname,
				lastname = newData.lastname,
				birthdate = newData.birthdate,
				gender = newData.gender,
				nationality = newData.nationality,
			}
		  	LSCore.Player.CheckPlayerData(Source, PlayerData)
		  	return true
		else

		 	LSCore.Functions.ExecuteSql(false, "SELECT * FROM `players` WHERE `citizenid` = '"..CitizenId.."'", function(result)
		 		local PlayerData = result[1]
		 		if PlayerData ~= nil then
		 			PlayerData.money = json.decode(PlayerData.money)
					PlayerData.position = json.decode(PlayerData.position)
					PlayerData.job = json.decode(PlayerData.job)
					PlayerData.gang = json.decode(PlayerData.gang)
		 			PlayerData.metadata = json.decode(PlayerData.metadata)
		 			PlayerData.skills = json.decode(PlayerData.skills)
		 			PlayerData.addiction = json.decode(PlayerData.addiction)
		 			PlayerData.charinfo = json.decode(PlayerData.charinfo)
				end	
				LSCore.Player.CheckPlayerData(Source, PlayerData)		
		 	end)
		 	return true
		end
	end
end

LSCore.Player.CheckPlayerData = function(source, PlayerData)
	PlayerData = PlayerData ~= nil and PlayerData or {}
	PlayerData.source = source
	PlayerData.citizenid = PlayerData.citizenid ~= nil and PlayerData.citizenid or LSCore.Player.CreateCitizenId()
	PlayerData.email = PlayerData.email ~= nil and PlayerData.email or PlayerData.charinfo.firstname:lower()..''..PlayerData.charinfo.lastname:lower()..'@lossantos.nl'
	PlayerData.steam = PlayerData.steam ~= nil and PlayerData.steam or LSCore.Functions.GetIdentifier(source, "steam")
	PlayerData.license = PlayerData.license ~= nil and PlayerData.license or LSCore.Functions.GetIdentifier(source, "license")
	PlayerData.name = GetPlayerName(source)
	PlayerData.cid = PlayerData.cid ~= nil and PlayerData.cid or 1
	--  // Money Shit \\ --
	PlayerData.money = PlayerData.money ~= nil and PlayerData.money or {}
	PlayerData.money['cash'] = PlayerData.money['cash'] ~= nil and PlayerData.money['cash'] or 0
	PlayerData.money['bank'] = PlayerData.money['bank'] ~= nil and PlayerData.money['bank'] or Config.Money.MoneyTypes['bank']
	PlayerData.money['casino'] = PlayerData.money['casino'] ~= nil and PlayerData.money['casino'] or 0
	PlayerData.money['crypto'] = PlayerData.money['crypto'] ~= nil and PlayerData.money['crypto'] ~= 0 and PlayerData.money['crypto'] or LSCore.Config.Money.ConfigDefaultCrypto
	-- // Char Info \\ --
	PlayerData.charinfo = PlayerData.charinfo ~= nil and PlayerData.charinfo or {}
	PlayerData.charinfo.firstname = PlayerData.charinfo.firstname ~= nil and PlayerData.charinfo.firstname or "Firstname"
	PlayerData.charinfo.lastname = PlayerData.charinfo.lastname ~= nil and PlayerData.charinfo.lastname or "Lastname"
	PlayerData.charinfo.birthdate = PlayerData.charinfo.birthdate ~= nil and PlayerData.charinfo.birthdate or "00-00-0000"
	PlayerData.charinfo.gender = PlayerData.charinfo.gender ~= nil and PlayerData.charinfo.gender or 0
	PlayerData.charinfo.nationality = PlayerData.charinfo.nationality ~= nil and PlayerData.charinfo.nationality or "Nederlands"
	PlayerData.charinfo.phone = PlayerData.charinfo.phone ~= nil and PlayerData.charinfo.phone or "06"..math.random(11111111, 99999999)
	PlayerData.charinfo.account = PlayerData.charinfo.account ~= nil and PlayerData.charinfo.account or "NL0"..math.random(1,9)..LSCore.Shared.RandomInt(3):upper()..math.random(1111,9999)..math.random(1111,9999)..math.random(11,99)
    -- // Health Shit \\ --
	PlayerData.metadata = PlayerData.metadata ~= nil and PlayerData.metadata or {}
    PlayerData.metadata["health"] = PlayerData.metadata["health"]  ~= nil and PlayerData.metadata["health"] or 200
    PlayerData.metadata["armor"] = PlayerData.metadata["armor"]  ~= nil and PlayerData.metadata["armor"] or 0
	PlayerData.metadata["hunger"] = PlayerData.metadata["hunger"] ~= nil and PlayerData.metadata["hunger"] or 100
	PlayerData.metadata["thirst"] = PlayerData.metadata["thirst"] ~= nil and PlayerData.metadata["thirst"] or 100
    PlayerData.metadata["stress"] = PlayerData.metadata["stress"] ~= nil and PlayerData.metadata["stress"] or 0
	PlayerData.metadata["isdead"] = PlayerData.metadata["isdead"] ~= nil and PlayerData.metadata["isdead"] or false
	PlayerData.metadata["lucky"] = PlayerData.metadata["lucky"] ~= nil and PlayerData.metadata["lucky"] or false
	-- // DNA \\ --
	PlayerData.metadata["bloodtype"] = PlayerData.metadata["bloodtype"] ~= nil and PlayerData.metadata["bloodtype"] or LSCore.Config.Player.Bloodtypes[math.random(1, #LSCore.Config.Player.Bloodtypes)]
	PlayerData.metadata["fingerprint"] = PlayerData.metadata["fingerprint"] ~= nil and PlayerData.metadata["fingerprint"] or LSCore.Player.CreateDnaId('finger')
	PlayerData.metadata["slimecode"] = PlayerData.metadata["slimecode"] ~= nil and PlayerData.metadata["slimecode"] or LSCore.Player.CreateDnaId('slime')
    PlayerData.metadata["haircode"] = PlayerData.metadata["haircode"] ~= nil and PlayerData.metadata["haircode"] or LSCore.Player.CreateDnaId('hair')
    -- // Reputations \\ --
	PlayerData.metadata["baan"] = PlayerData.metadata["baan"] ~= nil and PlayerData.metadata["baan"] or 0
	PlayerData.metadata["runs"] = PlayerData.metadata["runs"] ~= nil and PlayerData.metadata["runs"] or 0
	PlayerData.metadata["drugs"] = PlayerData.metadata["drugs"] ~= nil and PlayerData.metadata["drugs"] or 0
	PlayerData.metadata["craftingrep"] = PlayerData.metadata["craftingrep"] ~= nil and PlayerData.metadata["craftingrep"] or 0
	-- // Work Shizzle \\ --
	PlayerData.metadata["jailitems"] = PlayerData.metadata["jailitems"] ~= nil and PlayerData.metadata["jailitems"] or {}
	PlayerData.metadata["courtitems"] = PlayerData.metadata["courtitems"] ~= nil and PlayerData.metadata["courtitems"] or {}
	PlayerData.metadata["callsign"] = PlayerData.metadata["callsign"] ~= nil and PlayerData.metadata["callsign"] or "NO CALLSIGN"
	PlayerData.metadata["duty-vehicle"] = PlayerData.metadata["duty-vehicle"] ~= nil and PlayerData.metadata["duty-vehicle"] or {['STANDAARD'] = true, ['AUDI'] = false, ['UNMARKED'] = false, ['MOTOR'] = false, ['HELI'] = false}
	PlayerData.metadata["ishighcommand"] = PlayerData.metadata["ishighcommand"] ~= nil and PlayerData.metadata["ishighcommand"] or false
	-- // Appartment \\ 
	PlayerData.metadata["appartment-id"] = PlayerData.metadata["appartment-id"] ~= nil and PlayerData.metadata["appartment-id"] or LSCore.Player.CreateAppartmentId()
	PlayerData.metadata["phone"] = PlayerData.metadata["phone"] ~= nil and PlayerData.metadata["phone"] or {}
	-- // Miscs \\ --
	PlayerData.metadata["firstscene"] = PlayerData.metadata["firstscene"] ~= nil and PlayerData.metadata["firstscene"] or false
	PlayerData.metadata["tracker"] = PlayerData.metadata["tracker"] ~= nil and PlayerData.metadata["tracker"] or false
	PlayerData.metadata['walkstyle'] = PlayerData.metadata['walkstyle'] ~= nil and PlayerData.metadata['walkstyle'] or nil
	PlayerData.metadata['paycheck'] = PlayerData.metadata['paycheck'] ~= nil and PlayerData.metadata['paycheck'] or 0
	PlayerData.metadata["iscrafting"] = PlayerData.metadata["iscrafting"] ~= nil and PlayerData.metadata["iscrafting"] or false
    PlayerData.metadata["ishandcuffed"] = PlayerData.metadata["ishandcuffed"] ~= nil and PlayerData.metadata["ishandcuffed"] or false
    PlayerData.metadata["jailtime"] = PlayerData.metadata["jailtime"] ~= nil and PlayerData.metadata["jailtime"] or 0
    PlayerData.metadata["commandbinds"] = PlayerData.metadata["commandbinds"] ~= nil and PlayerData.metadata["commandbinds"] or {}
    PlayerData.metadata["licences"] = PlayerData.metadata["licences"] ~= nil and PlayerData.metadata["licences"] or {["driver"] = true, ['hunting'] = nil, ['flying'] = false}
	-- // Skills \\ --
	PlayerData.skills = PlayerData.skills ~= nil and PlayerData.skills or {}
	PlayerData.skills["lockpick"] = PlayerData.skills["lockpick"] ~= nil and PlayerData.skills["lockpick"] or 0
	PlayerData.skills["hacking"] = PlayerData.skills["hacking"] ~= nil and PlayerData.skills["hacking"] or 0
	-- // Addiction \\ --
	PlayerData.addiction = PlayerData.addiction ~= nil and PlayerData.addiction or {}
	PlayerData.addiction["cocaine"] = PlayerData.addiction["cocaine"] ~= nil and PlayerData.addiction["cocaine"] or 0
	PlayerData.addiction["weed"] = PlayerData.addiction["weed"] ~= nil and PlayerData.addiction["weed"] or 0
	PlayerData.addiction["fastfood"] = PlayerData.addiction["fastfood"] ~= nil and PlayerData.addiction["fastfood"] or 0
	-- // Jobs
	PlayerData.job = PlayerData.job ~= nil and PlayerData.job or {}
	PlayerData.job.name = PlayerData.job.name ~= nil and PlayerData.job.name or "unemployed"
	PlayerData.job.label = PlayerData.job.label ~= nil and PlayerData.job.label or "Werkloos"
	PlayerData.job.gradelabel = PlayerData.job.gradelabel ~= nil and PlayerData.job.gradelabel or "Werkloos"
    PlayerData.job.grade = PlayerData.job.grade ~= nil and PlayerData.job.grade or 1
    PlayerData.job.isboss = PlayerData.job.isboss ~= nil and PlayerData.job.isboss or false
	PlayerData.job.payment = PlayerData.job.payment ~= nil and PlayerData.job.payment or 10
	PlayerData.job.plate = PlayerData.job.plate ~= nil and PlayerData.job.plate or 'none'
	PlayerData.job.serial = PlayerData.job.serial ~= nil and PlayerData.job.serial or LSCore.Player.CreateWeaponSerial()
    PlayerData.job.onduty = PlayerData.job.onduty ~= nil and PlayerData.job.onduty or true
	-- Gangs
	PlayerData.gang = PlayerData.gang ~= nil and PlayerData.gang or {}
	PlayerData.gang.name = PlayerData.gang.name ~= nil and PlayerData.gang.name or "none"
	PlayerData.gang.label = PlayerData.gang.label ~= nil and PlayerData.gang.label or "Geen"
	PlayerData.gang.gradelabel = PlayerData.gang.gradelabel ~= nil and PlayerData.gang.gradelabel or "Gangloos"
    -- // Position \\ --
	PlayerData.position = PlayerData.position ~= nil and PlayerData.position or {}
	PlayerData.inventory = LSCore.Player.LoadInventory(PlayerData.citizenid)
	PlayerData.metadata['phonedata'] = PlayerData.metadata['phonedata'] or {
        SerialNumber = LSCore.Player.CreateSerialNumber(),
        InstalledApps = {},
    }
	LSCore.Player.CreatePlayer(PlayerData)
end

LSCore.Player.CreatePlayer = function(PlayerData)
	local self = {}
	self.Functions = {}
	self.PlayerData = PlayerData

	self.Functions.UpdatePlayerData = function()
		TriggerClientEvent(Config.Server.FrameworkTriggers['playerdata'], self.PlayerData.source, self.PlayerData)
		LSCore.Commands.Refresh(self.PlayerData.source)
	end

	self.Functions.SetJob = function(job, grade)
        local job = job:lower()
        local grade = tonumber(grade)

        if LSCore.Shared.Jobs[job] ~= nil then        
            if LSCore.Shared.Jobs[job].grades[grade] ~= nil then
                self.PlayerData.job.name = job
                self.PlayerData.job.label = LSCore.Shared.Jobs[job].label
                self.PlayerData.job.onduty = LSCore.Shared.Jobs[job].defaultDuty

                self.PlayerData.job.grade = grade
                self.PlayerData.job.gradelabel = LSCore.Shared.Jobs[job].grades[grade].label
                self.PlayerData.job.payment = LSCore.Shared.Jobs[job].grades[grade].payment
                self.PlayerData.job.isboss = LSCore.Shared.Jobs[job].grades[grade].isboss

                self.Functions.UpdatePlayerData()
                TriggerClientEvent(Config.Server.FrameworkTriggers['jobupdate'], self.PlayerData.source, self.PlayerData.job)
            else
                TriggerClientEvent(Config.Server.FrameworkTriggers['notify'], self.PlayerData.source, 'Deze rang bestaat niet..', "error")
            end
        else
            TriggerClientEvent(Config.Server.FrameworkTriggers['notify'],  self.PlayerData.source, 'Dit beroep bestaat niet..', "error")
        end
    end

	self.Functions.SetJobDuty = function(onDuty)
		self.PlayerData.job.onduty = onDuty
		self.Functions.UpdatePlayerData()
	end

	self.Functions.SetDutyPlate = function(Plate)
		local Plate = Plate:upper()
		self.PlayerData.job.plate = Plate
		self.Functions.UpdatePlayerData()
	end
	
	self.Functions.SetGang = function(gang)
		local gang = gang:lower()
		if LSCore.Shared.Gangs[gang] ~= nil then
			self.PlayerData.gang.name = gang
			self.PlayerData.gang.label = LSCore.Shared.Gangs[gang].label
			self.Functions.UpdatePlayerData()
			TriggerClientEvent(Config.Server.FrameworkTriggers['gangupdate'], self.PlayerData.source, self.PlayerData.gang)
		end
	end
	
	self.Functions.SetMetaData = function(meta, val)
		local meta = meta:lower()
		if val ~= nil then
			self.PlayerData.metadata[meta] = val
			self.Functions.UpdatePlayerData()
		end
	end

	self.Functions.SetMetaDataTable = function(tablename, key, val)
		local tablename = tablename:lower()
		if val ~= nil then
			self.PlayerData.metadata[tablename][key] = val
			self.Functions.UpdatePlayerData()
		end
	end

	self.Functions.SetMetaDataTablePoint = function(tablename, key, val)
		local tablename = tablename:lower()
		if val ~= nil then
			self.PlayerData.metadata[tablename].key = val
			self.Functions.UpdatePlayerData()
		end
	end

	self.Functions.SetSkillPoints = function(skill, val)
		local skill = skill:lower()
		if val ~= nil then
			self.PlayerData.skills[skill] = val
			self.Functions.UpdatePlayerData()
		end
	end

	self.Functions.AddAddiction = function(addiction, val)
		local addiction = addiction:lower()
		if val ~= nil then
			self.PlayerData.addiction[addiction] = self.PlayerData.addiction[addiction] + val
			self.Functions.UpdatePlayerData()
		end
	end

	-- self.Functions.AddMoney = function(moneytype, amount, reason)
	-- 	reason = reason ~= nil and reason or "unkown"
	-- 	local moneytype = moneytype:lower()
	-- 	local amount = tonumber(amount)
	-- 	if amount < 0 then return end
	-- 	if self.PlayerData.money[moneytype] ~= nil then
	-- 		self.PlayerData.money[moneytype] = self.PlayerData.money[moneytype]+amount
	-- 			if moneytype == 'cash' then
	-- 				self.Functions.AddItem(moneytype, amount)
	-- 			end
	-- 		self.Functions.UpdatePlayerData()

    --         local message = "**"..GetPlayerName(self.PlayerData.source) .. " (citizenid: "..self.PlayerData.citizenid.." | id: "..self.PlayerData.source..")** €"..amount .. " ("..moneytype..") erbij, nieuw "..moneytype.." balans: "..self.PlayerData.money[moneytype] .. " van de resource '"
    --         if GetInvokingResource() ~= nil then
    --             message = message .. GetInvokingResource() .. "'"
    --         else
    --             message = message .. GetCurrentResourceName() .. "'"
    --         end
	-- 		if GetCurrentResourceName() == 'fw-casino' or GetCurrentResourceName() == 'fw-luckywheel' or GetCurrentResourceName() == 'fw-blackjack' then
	-- 			if amount > 100000 then
	-- 				TriggerEvent(Config.Server.FrameworkTriggers['log'], "casino", "AddMoney", "lightgreen", message)
	-- 			else
	-- 				TriggerEvent(Config.Server.FrameworkTriggers['log'], "casino", "AddMoney", "lightgreen", message)
	-- 			end
	-- 		else
	-- 			if amount > 100000 then
	-- 				TriggerEvent(Config.Server.FrameworkTriggers['log'], "prio", "AddMoney", "lightgreen", message)
	-- 			else
	-- 				TriggerEvent(Config.Server.FrameworkTriggers['log'], "playermoney", "AddMoney", "lightgreen", message)
	-- 			end
	-- 		end
	-- 		if moneytype == 'cash' then
	-- 			TriggerClientEvent("framework-ui:client:money:change", self.PlayerData.source, amount, 'Plus')
	-- 		end
	-- 		return true
	-- 	end
	-- 	return false
	-- end

	
	self.Functions.AddMoney = function(moneytype, amount, reason)
		reason = reason ~= nil and reason or "unkown"
		local moneytype = moneytype:lower()
		local amount = tonumber(amount)
		if amount < 0 then return end
		if self.PlayerData.money[moneytype] ~= nil then
			self.PlayerData.money[moneytype] = self.PlayerData.money[moneytype]+amount
			self.Functions.UpdatePlayerData()

            local message = "**"..GetPlayerName(self.PlayerData.source) .. " (citizenid: "..self.PlayerData.citizenid.." | id: "..self.PlayerData.source..")** €"..amount .. " ("..moneytype..") erbij, nieuw "..moneytype.." balans: "..self.PlayerData.money[moneytype] .. " van de resource '"
            if GetInvokingResource() ~= nil then
                message = message .. GetInvokingResource() .. "'"
            else
                message = message .. GetCurrentResourceName() .. "'"
            end

			if amount > 100000 then
				TriggerEvent(Config.Server.FrameworkTriggers['log'], "prio", "AddMoney", "lightgreen", message)
			else
				TriggerEvent(Config.Server.FrameworkTriggers['log'], "playermoney", "AddMoney", "lightgreen", message)
			end
			if moneytype == 'cash' then
				TriggerClientEvent("framework-ui:client:money:change", self.PlayerData.source, amount, 'Plus')
			end
			return true
		end
		return false
	end

	self.Functions.RemoveMoney = function(moneytype, amount, reason)
		reason = reason ~= nil and reason or "unkown"
		local moneytype = moneytype:lower()
		local amount = tonumber(amount)
		if amount < 0 then return end
		if self.PlayerData.money[moneytype] ~= nil then
			for _, mtype in pairs(LSCore.Config.Money.DontAllowMinus) do
				if mtype == moneytype then
					if self.PlayerData.money[moneytype] - amount < 0 then return false end
				end
			end
			self.PlayerData.money[moneytype] = self.PlayerData.money[moneytype] - amount
			self.Functions.UpdatePlayerData()

            local message = "**"..GetPlayerName(self.PlayerData.source) .. " (citizenid: "..self.PlayerData.citizenid.." | id: "..self.PlayerData.source..")** €"..amount .. " ("..moneytype..") erbij, nieuw "..moneytype.." balans: "..self.PlayerData.money[moneytype] .. " van de resource '"
            if GetInvokingResource() ~= nil then
                message = message .. GetInvokingResource() .. "'"
            else
                message = message .. GetCurrentResourceName() .. "'"
            end

			if amount > 100000 then
				TriggerEvent("framework-logs:server:SendLog", "prio", "RemoveMoney", "red", message)
			else
				TriggerEvent("framework-logs:server:SendLog", "playermoney", "RemoveMoney", "red", message)
			end
			if moneytype == 'cash' then
				TriggerClientEvent("framework-ui:client:money:change", self.PlayerData.source, amount, 'Minus')
			end
			return true
		end
		return false
	end

	-- self.Functions.RemoveMoney = function(moneytype, amount, reason)
	-- 	reason = reason ~= nil and reason or "unkown"
	-- 	local moneytype = moneytype:lower()
	-- 	local amount = tonumber(amount)
	-- 	if amount < 0 then return end
	-- 	if self.PlayerData.money[moneytype] ~= nil then
	-- 		for _, mtype in pairs(LSCore.Config.Money.DontAllowMinus) do
	-- 			if mtype == moneytype then
	-- 				if self.PlayerData.money[moneytype] - amount < 0 then return false end
	-- 			end
	-- 		end
	-- 		self.PlayerData.money[moneytype] = self.PlayerData.money[moneytype] - amount
	-- 		if moneytype == 'cash' then
	-- 			self.Functions.RemoveItem(moneytype, amount)
	-- 		end
	-- 		self.Functions.UpdatePlayerData()

    --         local message = "**"..GetPlayerName(self.PlayerData.source) .. " (citizenid: "..self.PlayerData.citizenid.." | id: "..self.PlayerData.source..")** €"..amount .. " ("..moneytype..") erbij, nieuw "..moneytype.." balans: "..self.PlayerData.money[moneytype] .. " van de resource '"
    --         if GetInvokingResource() ~= nil then
    --             message = message .. GetInvokingResource() .. "'"
    --         else
    --             message = message .. GetCurrentResourceName() .. "'"
    --         end
			
	-- 		if amount > 100000 then
	-- 			TriggerEvent(Config.Server.FrameworkTriggers['log'], "prio", "RemoveMoney", "red", message)
	-- 		else
	-- 			TriggerEvent(Config.Server.FrameworkTriggers['log'], "playermoney", "RemoveMoney", "red", message)
	-- 		end
	-- 		-- if moneytype == 'cash' then
	-- 		-- 	-- TriggerClientEvent("framework-ui:client:money:change", self.PlayerData.source, amount, 'Minus')
	-- 		-- end
	-- 		return true
	-- 	end
	-- 	return false
	-- end

	self.Functions.SetMoney = function(moneytype, amount, reason)
		reason = reason ~= nil and reason or "unkown"
		local moneytype = moneytype:lower()
		local amount = tonumber(amount)
		if amount < 0 then return end
		if self.PlayerData.money[moneytype] ~= nil then
			self.PlayerData.money[moneytype] = amount
			self.Functions.UpdatePlayerData()
			TriggerEvent("framework-logs:server:SendLog", "playermoney", "SetMoney", "green", "**"..GetPlayerName(self.PlayerData.source) .. " (citizenid: "..self.PlayerData.citizenid.." | id: "..self.PlayerData.source..")** €"..amount .. " ("..moneytype..") gezet, nieuw "..moneytype.." balans: "..self.PlayerData.money[moneytype])
			return true
		end
		return false
	end
	-- self.Functions.SetMoney = function(moneytype, amount, reason)
	-- 	reason = reason ~= nil and reason or "unkown"
	-- 	local moneytype = moneytype:lower()
	-- 	local amount = tonumber(amount)
	-- 	if amount < 0 then return end
	-- 	if self.PlayerData.money[moneytype] ~= nil then
	-- 		self.PlayerData.money[moneytype] = amount
	-- 		if moneytype == 'cash' then
	-- 			self.Functions.AddItem(moneytype, amount)
	-- 		end
	-- 		self.Functions.UpdatePlayerData()
	-- 		TriggerEvent(Config.Server.FrameworkTriggers['log'], "playermoney", "SetMoney", "green", "**"..GetPlayerName(self.PlayerData.source) .. " (citizenid: "..self.PlayerData.citizenid.." | id: "..self.PlayerData.source..")** €"..amount .. " ("..moneytype..") gezet, nieuw "..moneytype.." balans: "..self.PlayerData.money[moneytype])
	-- 		return true
	-- 	end
	-- 	return false
	-- end

	self.Functions.AddCrypto = function(CryptoType, Amount)
		local CryptoType = CryptoType ~= nil and CryptoType
		local Amount = tonumber(Amount)
		if Amount > 0 then
			if self.PlayerData.money['crypto'][CryptoType] ~= nil then
				self.PlayerData.money['crypto'][CryptoType] = self.PlayerData.money['crypto'][CryptoType] + Amount
				self.Functions.UpdatePlayerData()
				return true, self.PlayerData.money['crypto'][CryptoType]
			else
				return false
			end
		else
			return false
		end
	end

	self.Functions.RemoveCrypto = function(CryptoType, Amount)
		local CryptoType = CryptoType ~= nil and CryptoType
		local Amount = tonumber(Amount)
		if Amount > 0 then
			if self.PlayerData.money['crypto'][CryptoType] ~= nil then
				if self.PlayerData.money['crypto'][CryptoType] - Amount > 0 then
					self.PlayerData.money['crypto'][CryptoType] = self.PlayerData.money['crypto'][CryptoType] - Amount
					self.Functions.UpdatePlayerData()
					return true, self.PlayerData.money['crypto'][CryptoType]
				else
					return false
				end
			else
				return false
			end
		else
			return false
		end
	end

	self.Functions.AddItem = function(Item, Amount, Slot, Info, Show, Type)
		local TotalWeight = LSCore.Player.GetTotalWeight(self.PlayerData.inventory)
		local ItemInfo = Item ~= nil and exports[Config.Server.FrameworkTriggers['inventoryname']]:GetItemData(Item:lower())
		local Amount = tonumber(Amount)
		local Slot = tonumber(Slot) ~= nil and tonumber(Slot) or LSCore.Player.GetFirstSlotByItem(self.PlayerData.inventory, Item)
		local Show = Show ~= nil and Show or false
		if ItemInfo ~= nil then
			if Info == nil and ItemInfo["type"] == "weapon" or Info == false and ItemInfo["type"] == "weapon" then
				if not ItemInfo['melee'] then
					Info = {ammo = 5, quality = 100.0, serie = tostring(LSCore.Shared.RandomInt(2) .. LSCore.Shared.RandomStr(3) .. LSCore.Shared.RandomInt(1) .. LSCore.Shared.RandomStr(2) .. LSCore.Shared.RandomInt(3) .. LSCore.Shared.RandomStr(4))}
				else
					Info = {quality = 100.0}
				end
				Amount = 1
			end
			if (TotalWeight + (ItemInfo["weight"] * Amount)) <= LSCore.Config.Player.MaxWeight then
				if (Slot ~= nil and self.PlayerData.inventory[Slot] ~= nil) and (self.PlayerData.inventory[Slot].name:lower() == Item:lower()) and (ItemInfo["type"] == "item" and not ItemInfo["unique"]) then
					self.PlayerData.inventory[Slot].amount = self.PlayerData.inventory[Slot].amount + Amount
					self.Functions.UpdatePlayerData()
					if Show then
						TriggerClientEvent(Config.Server.FrameworkTriggers['inventoryitem'], self.PlayerData.source, 'Add', ItemInfo, Amount)
					end
					TriggerClientEvent(Config.Server.FrameworkTriggers['updateplayer'], self.PlayerData.source)
					return true
				elseif (not ItemInfo["unique"] and Slot or Slot ~= nil and self.PlayerData.inventory[Slot] == nil) then
					self.PlayerData.inventory[Slot] = {
						name = ItemInfo["name"], 
						amount = Amount, 
						info = Info ~= nil and Info or "", 
						label = ItemInfo["label"], 
						description = ItemInfo["description"] ~= nil and ItemInfo["description"] or "", 
						weight = ItemInfo["weight"], 
						type = ItemInfo["type"], 
						unique = ItemInfo["unique"], 
						image = ItemInfo["image"], 
						slot = Slot, 
						combinable = ItemInfo["combinable"]
					}
					self.Functions.UpdatePlayerData()
					if Show then
						TriggerClientEvent(Config.Server.FrameworkTriggers['inventoryitem'], self.PlayerData.source, 'Add', ItemInfo, Amount)
					end
					TriggerClientEvent(Config.Server.FrameworkTriggers['updateplayer'], self.PlayerData.source)
					return true
				elseif (ItemInfo["unique"]) or (not Slot or Slot == nil) or (ItemInfo["type"] == "weapon") then
					local FreeSlot = LSCore.Player.GetFreeInventorySlot(self.PlayerData.inventory)
					if FreeSlot ~= false then
						self.PlayerData.inventory[FreeSlot] = {
							name = ItemInfo["name"], 
							amount = Amount, 
							info = Info ~= nil and Info or "", 
							label = ItemInfo["label"], 
							description = ItemInfo["description"] ~= nil and ItemInfo["description"] or "", 
							weight = ItemInfo["weight"], 
							type = ItemInfo["type"], 
							unique = ItemInfo["unique"], 
							image = ItemInfo["image"], 
							slot = FreeSlot, 
							combinable = ItemInfo["combinable"]
						}
						self.Functions.UpdatePlayerData()
						if Show then
							TriggerClientEvent(Config.Server.FrameworkTriggers['inventoryitem'], self.PlayerData.source, 'Add', ItemInfo, Amount)
						end
						TriggerClientEvent(Config.Server.FrameworkTriggers['updateplayer'], self.PlayerData.source)
						return true
					else
						TriggerClientEvent(Config.Server.FrameworkTriggers['notify'], self.PlayerData.source, "Je bent te zwaar of je hebt geen plek meer..", "error", 4500)
						TriggerEvent(Config.Server.FrameworkTriggers['dropitem'], self.PlayerData.source, ItemInfo["name"], Amount, Info)
					end
				end
			else
				if Type ~= 'Inventory' then
					TriggerClientEvent(Config.Server.FrameworkTriggers['notify'], self.PlayerData.source, "Je bent te zwaar of je hebt geen plek meer..", "error", 4500)
					TriggerEvent(Config.Server.FrameworkTriggers['dropitem'], self.PlayerData.source, ItemInfo["name"], Amount, Info)
				else
					return false
				end
			end
		else
			TriggerClientEvent(Config.Server.FrameworkTriggers['notify'], self.PlayerData.source, "Dit item bestaat niet..", "error", 4500)
		end
		return false
	end

	self.Functions.RemoveItem = function(Item, Amount, Slot, Show)
		local ItemInfo = exports[Config.Server.FrameworkTriggers['inventoryname']]:GetItemData(Item:lower())
		local Amount = tonumber(Amount)
		local Slot = tonumber(Slot) ~= nil and tonumber(Slot) or LSCore.Player.GetFirstSlotByItem(self.PlayerData.inventory, Item)
		local Show = Show ~= nil and Show or false
		if Slot ~= nil then
			if self.PlayerData.inventory[Slot] ~= nil then
				if self.PlayerData.inventory[Slot].amount > Amount then
					self.PlayerData.inventory[Slot].amount = self.PlayerData.inventory[Slot].amount - Amount
					self.Functions.UpdatePlayerData()
					if Show then
						TriggerClientEvent(Config.Server.FrameworkTriggers['inventoryitem'], self.PlayerData.source, 'Remove', ItemInfo, Amount)
					end
					TriggerClientEvent(Config.Server.FrameworkTriggers['updateplayer'], self.PlayerData.source)
					return true
				else
					self.PlayerData.inventory[Slot] = nil
					self.Functions.UpdatePlayerData()
					if Show then
						TriggerClientEvent(Config.Server.FrameworkTriggers['inventoryitem'], self.PlayerData.source, 'Remove', ItemInfo, Amount)
					end
					TriggerClientEvent(Config.Server.FrameworkTriggers['updateplayer'], self.PlayerData.source)
					return true
				end
			else
				print(self.PlayerData.source, self.PlayerData.steam, 'Is volgensmij aan het cheaten met de inventaris.')
			end
		end
		return false
	end

	self.Functions.SetItemData = function(ItemData)
		self.PlayerData.inventory = ItemData
		LSCore.Player.SaveInventory(self.PlayerData.citizenid, self.PlayerData.inventory)
		self.Functions.UpdatePlayerData()
	end

	self.Functions.ClearInventory = function()
		self.PlayerData.inventory = {}
		LSCore.Player.SaveInventory(self.PlayerData.citizenid, self.PlayerData.inventory)
		self.Functions.UpdatePlayerData()
	end

	self.Functions.GetItemBySlot = function(Slot)
		local Slot = tonumber(Slot)
		if self.PlayerData.inventory[Slot] ~= nil then
			return self.PlayerData.inventory[Slot]
		end
	end

	self.Functions.GetItemByName = function(Item)
		local Item = Item:lower()
		local Slot = LSCore.Player.GetFirstSlotByItem(self.PlayerData.inventory, Item)
		if Slot ~= nil then
			return self.PlayerData.inventory[Slot]
		end
	end

	self.Functions.Save = function()
		LSCore.Player.Save(self.PlayerData.source)
	end
	
	LSCore.Players[self.PlayerData.source] = self
	LSCore.Player.Save(self.PlayerData.source)
	self.Functions.UpdatePlayerData()
end

LSCore.Player.Save = function(source)
	local PlayerData = LSCore.Players[source].PlayerData
	if PlayerData ~= nil then

		LSCore.Functions.ExecuteSql(true, "SELECT * FROM `players` WHERE `citizenid` = '"..PlayerData.citizenid.."'", function(result)
			if result[1] == nil then
				LSCore.Functions.ExecuteSql(true, "INSERT INTO `players` (`citizenid`, `email`, `cid`, `steam`, `license`, `name`, `money`, `charinfo`, `position`, `job`, `gang`, `metadata`, `skills`, `addiction`) VALUES ('"..PlayerData.citizenid.."', '"..PlayerData.email.."', '"..tonumber(PlayerData.cid).."', '"..PlayerData.steam.."', '"..PlayerData.license.."', '"..PlayerData.name.."', '"..json.encode(PlayerData.money).."', '"..LSCore.EscapeSqli(json.encode(PlayerData.charinfo)).."', '"..json.encode(PlayerData.position).."', '"..json.encode(PlayerData.job).."', '"..json.encode(PlayerData.gang).."', '"..json.encode(PlayerData.metadata).."', '"..json.encode(PlayerData.skills).."', '"..json.encode(PlayerData.addiction).."')")
				-- LSCore.Functions.ExecuteSql(true, "INSERT INTO `player_accounts` (`citizenid`, `type`, `name`, `bankid`, `balance`, `authorized`, `transactions`) VALUES ('"..PlayerData.citizenid.."', 'private', '"..tonumber(PlayerData.charinfo.account).."', '"..PlayerData.name.."', '0', '{}')")
			else
				LSCore.Functions.ExecuteSql(true, "UPDATE `players` SET steam='"..PlayerData.steam.."', name='"..LSCore.EscapeSqli(PlayerData.name).."', money='"..LSCore.EscapeSqli(json.encode(PlayerData.money)).."', charinfo='"..LSCore.EscapeSqli(json.encode(PlayerData.charinfo)).."', position='"..LSCore.EscapeSqli(json.encode(PlayerData.position)).."', job='"..LSCore.EscapeSqli(json.encode(PlayerData.job)).."', email='"..LSCore.EscapeSqli(PlayerData.email).."', gang='"..LSCore.EscapeSqli(json.encode(PlayerData.gang)).."', metadata='"..LSCore.EscapeSqli(json.encode(PlayerData.metadata)).."', skills='"..json.encode(PlayerData.skills).."', addiction='"..json.encode(PlayerData.addiction).."' WHERE `citizenid` = '"..PlayerData.citizenid.."'")
			end
			LSCore.Player.SaveInventory(PlayerData.citizenid, PlayerData.inventory)
		end)
		print(PlayerData.name .." ^2PLAYER SAVED!^0")
	else
		print('SAVE DATA ERROR - NILL - Lotus Framework 3.0')
	end
end

LSCore.Player.Logout = function(source)
	local Player = LSCore.Functions.GetPlayer(source)
	TriggerClientEvent(Config.Server.FrameworkTriggers['unload'], source)
	TriggerClientEvent(Config.Server.FrameworkTriggers['uplayer'], source)
	Player.Functions.Save()
	Citizen.Wait(200)
	LSCore.Players[source] = nil
end

LSCore.Player.DeleteCharacter = function(source, citizenid)
  	LSCore.Functions.ExecuteSql(false, "SELECT * FROM `players` WHERE `citizenid` = '"..LSCore.EscapeSqli(citizenid).."'", function(result)
		if result[1] ~= nil then
			if result[1].steam == GetPlayerIdentifiers(source)[1] then
			   LSCore.Functions.ExecuteSql(true, "DELETE FROM `player_skins` WHERE `citizenid` = '"..citizenid.."'")
			   LSCore.Functions.ExecuteSql(true, "DELETE FROM `players` WHERE `citizenid` = '"..citizenid.."'")
			   TriggerClientEvent(Config.Server.FrameworkTriggers['multichar'], source)
		       TriggerEvent(Config.Server.FrameworkTriggers['log'], "joinleave", "Character Deleted", "red", "**".. GetPlayerName(source) .. "** ("..GetPlayerIdentifiers(source)[1]..") deleted **"..citizenid.."**..")
			else
				TriggerClientEvent(Config.Server.FrameworkTriggers['multichar'], source)
				TriggerEvent(Config.Server.FrameworkTriggers['log'], "joinleave", "Character Cheats", "red", GetPlayerName(source) .." probeerd "..citizenid.." te verwijderen die niet van hem is..", true)
			end
		else
			TriggerClientEvent(Config.Server.FrameworkTriggers['multichar'], source)
		    TriggerEvent(Config.Server.FrameworkTriggers['log'], "joinleave", "Character Cheats", "red", GetPlayerName(source) .." probeerd "..citizenid.." te verwijderen die niet van hem is..", true)
		end
  	end)
end

LSCore.Player.LoadInventory = function(CitizenId)
	local ReturnItems = {}
	LSCore.Functions.ExecuteSql(false, "SELECT * FROM `players` WHERE `citizenid` = '"..CitizenId.."'", function(result)
		if result[1] ~= nil and result[1].inventory ~= nil then
			local InventoryItems = json.decode(result[1].inventory)
			if InventoryItems ~= nil then
				for k, v in pairs(InventoryItems) do
					if exports[Config.Server.FrameworkTriggers['inventoryname']]:GetItemData(v.name) ~= nil then
						local ItemInfo = exports[Config.Server.FrameworkTriggers['inventoryname']]:GetItemData(v.name)
						ReturnItems[v.slot] = {
							label = ItemInfo['label'],
							name = ItemInfo['name'],
							slot = v.slot,
							type = ItemInfo['type'],
							unique = ItemInfo['unique'],
							amount = v.amount,
							image = ItemInfo['image'],
							weight = ItemInfo['weight'],
							info = v.info ~= nil and v.info or "",
							description = ItemInfo['description'],
							combinable = ItemInfo['combinable'], 
						}
					end
				end
			end
		end
	end)
	return ReturnItems
end

LSCore.Player.SaveInventory = function(CitizenId, ItemData)
	local ItemsJson = {}
	LSCore.Functions.ExecuteSql(false, "SELECT * FROM `players` WHERE `citizenid` = '"..CitizenId.."'", function(result)
		for k, v in pairs(ItemData) do
			if ItemData[k] ~= nil then
				local NewData = {}
				NewData.name = v.name
				NewData.slot = v.slot
				NewData.amount = v.amount
				NewData.info = v.info
				table.insert(ItemsJson, NewData)
			end
		end
		LSCore.Functions.ExecuteSql(false, "UPDATE `players` SET `inventory` = '"..json.encode(ItemsJson).."' WHERE `citizenid` = '"..CitizenId.."'")
	end)
end

LSCore.Player.GetFirstSlotByItem = function(InventoryItems, ItemName)
	for k, v in pairs(InventoryItems) do
		if v.name:lower() == ItemName:lower() then
			return tonumber(k)
		end
	end
end

LSCore.Player.GetFreeInventorySlot = function(PlayerInventory)
	for i = 1, Config.Player.MaxInvSlots, 1 do
		if PlayerInventory[i] == nil then
			return i
		end
	end
	return false
end

LSCore.Player.GetSlotsByItem = function(PlayerInventory, ItemName)
	local ReturnSlots = {}
	for k, v in pairs(PlayerInventory) do
		if v.name:lower() == ItemName:lower() then
			table.insert(ReturnSlots, k)
		end
	end
	return ReturnSlots
end

LSCore.Player.GetTotalWeight = function(InventoryItems)
	local ReturnWeight = 0
	for k, v in pairs(InventoryItems) do
		ReturnWeight = ReturnWeight + (v.weight * v.amount)
	end
	return ReturnWeight
end

LSCore.Player.CreateCitizenId = function()
	local UniqueFound, CitizenId = false, nil
	while not UniqueFound do
		CitizenId = tostring(LSCore.Shared.RandomStr(3) .. LSCore.Shared.RandomInt(5)):upper()
		LSCore.Functions.ExecuteSql(true, "SELECT COUNT(*) as count FROM `players` WHERE `citizenid` = '"..CitizenId.."'", function(result)
            if result[1].count == 0 then
				UniqueFound = true
			end
		end)
	end
	return CitizenId
end

LSCore.Player.CreateDnaId = function(Type)
    local DnaId = {}
    if Type == 'finger' then
        DnaId = tostring('F'..LSCore.Shared.RandomStr(3) .. LSCore.Shared.RandomInt(3):upper() .. LSCore.Shared.RandomStr(1) .. LSCore.Shared.RandomInt(2) .. LSCore.Shared.RandomStr(3) .. LSCore.Shared.RandomInt(4):upper())
    elseif Type == 'slime' then
        DnaId = tostring('S'..LSCore.Shared.RandomStr(2) .. LSCore.Shared.RandomInt(3) .. LSCore.Shared.RandomStr(2) .. LSCore.Shared.RandomInt(2):upper() .. LSCore.Shared.RandomStr(3) .. LSCore.Shared.RandomInt(4))
    elseif Type == 'hair' then
        DnaId = tostring('H'..LSCore.Shared.RandomStr(2) .. LSCore.Shared.RandomInt(3) .. LSCore.Shared.RandomStr(3) .. LSCore.Shared.RandomInt(2) .. LSCore.Shared.RandomStr(3) .. LSCore.Shared.RandomInt(4):upper())
    end 
    return DnaId
end

LSCore.Player.CreateWeaponSerial = function()
	local Serial =  LSCore.Shared.RandomStr(2)..LSCore.Shared.RandomInt(3):upper()..LSCore.Shared.RandomStr(3)..LSCore.Shared.RandomInt(3):upper()..LSCore.Shared.RandomStr(2)..LSCore.Shared.RandomInt(3):upper()
	return Serial
end

LSCore.Player.CreateAppartmentId = function()
	local AppartmentId =  LSCore.Shared.RandomStr(2)..LSCore.Shared.RandomInt(2):upper()..'Appartment'..LSCore.Shared.RandomStr(2)..LSCore.Shared.RandomInt(2):lower()
	return AppartmentId
end

-- LSCore.Player.CreateSerialNumber = function()
--     local UniqueFound = false
--     local SerialNumber = nil
--     while not UniqueFound do
--         SerialNumber = math.random(11111111, 99999999)
--         local query = '%' .. SerialNumber .. '%'
--         local result = LSCore.Functions.ExecuteSql(true, 'SELECT COUNT(*) as count FROM players WHERE metadata LIKE ?', { query })
--         if result == 0 then
--             UniqueFound = true
--         end
--     end
--     return SerialNumber
-- end

LSCore.Player.CreateSerialNumber = function()
	local SerialNumber = math.random(11111111, 99999999)
    return SerialNumber
end

LSCore.EscapeSqli = function(str)
    local replacements = { ['"'] = '\\"', ["'"] = "\\'" }
    return str:gsub( "['\"]", replacements)
end