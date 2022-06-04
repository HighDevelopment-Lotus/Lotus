local LSCore, Stashes, TempStashes, Gloveboxes, Trunks = exports['fw-base']:GetCoreObject(), {}, {}, {}, {}
local OpenInventories = {}

-- Code

-- // Commands \\ --

LSCore.Commands.Add("resetinv", "Reset een inventory als je die niet meer kan openen", {{name="Type", help="Type: Stash/Drop/Glovebox/Trunk"},{name="Name", help="Inventory Naam"}}, true, function(source, args)
	local InventoryType = args[1]:lower()
	table.remove(args, 1)
	local StashName = table.concat(args, " ")
	if InventoryType == 'drop' then
		if OpenInventories['D'..StashName] ~= nil then
			OpenInventories['D'..StashName] = false
		else
			TriggerClientEvent('LSCore:Notify', source, "Deze inventory bestaat niet..", 'error')
		end
	elseif InventoryType == 'trunk' then
		if OpenInventories['T'..StashName] ~= nil then
			OpenInventories['T'..StashName] = false
		else
			TriggerClientEvent('LSCore:Notify', source, "Deze inventory bestaat niet..", 'error')
		end
	elseif InventoryType == 'glovebox' then
		if OpenInventories['G'..StashName] ~= nil then
			OpenInventories['G'..StashName] = false
		else
			TriggerClientEvent('LSCore:Notify', source, "Deze inventory bestaat niet..", 'error')
		end
	elseif InventoryType == 'stash' then
		if OpenInventories[StashName] ~= nil then
			OpenInventories[StashName] = false
		else
			TriggerClientEvent('LSCore:Notify', source, "Deze inventory bestaat niet..", 'error')
		end
	end
end, 'admin')

-- // Events \\ --

RegisterServerEvent('framework-inv:server:open:inventory:other')
AddEventHandler('framework-inv:server:open:inventory:other', function(OtherData, Type, Slots, MaxWeight, ExtraData)
	local src = source
	local Slots = Slots ~= nil and Slots or 15
	if Type == 'Glovebox' then
		if not OpenInventories['G'..OtherData] then
			if Gloveboxes[OtherData] == nil then
				Gloveboxes[OtherData] = GetDBItems('Glovebox', OtherData)
			end
			if Gloveboxes[OtherData] == nil then Gloveboxes[OtherData] = {} end
			local TotalData = {['Type'] = 'Glovebox', ['SubType'] = OtherData, ['InvName'] = 'Dashboard: '..OtherData, ['InvSlots'] = Slots, ['MaxWeight'] = MaxWeight, ['Items'] = Gloveboxes[OtherData]}
			TriggerClientEvent('framework-inv:client:open:inventory:other', src, TotalData)
			Citizen.SetTimeout(5, function()
				OpenInventories['G'..OtherData] = true
			end)
		else
			TriggerClientEvent('framework-inv:client:open:empty:other', source)
		end
	elseif Type == 'Trunk' then
		if not OpenInventories['T'..OtherData] then
			if Trunks[OtherData] == nil then
				Trunks[OtherData] = GetDBItems('Trunk', OtherData)
			end
			if Trunks[OtherData] == nil then Trunks[OtherData] = {} end
			local TotalData = {['Type'] = 'Trunk', ['SubType'] = OtherData, ['InvName'] = 'Kofferbak: '..OtherData, ['InvSlots'] = Slots, ['MaxWeight'] = MaxWeight, ['Items'] = Trunks[OtherData], ['ExtraData'] = ExtraData}
			TriggerClientEvent('framework-inv:client:open:inventory:other', src, TotalData)
			Citizen.SetTimeout(5, function()
				OpenInventories['T'..OtherData] = true
			end)
		else
			TriggerClientEvent('framework-inv:client:open:empty:other', source)
		end
	elseif Type == 'Stash' then
		if not OpenInventories[OtherData] then
			if Stashes[OtherData] == nil then
				Stashes[OtherData] = GetDBItems('Stash', OtherData)
			end
			if Stashes[OtherData] == nil then Stashes[OtherData] = {} end
			local TotalData = {['Type'] = 'Stash', ['SubType'] = OtherData, ['InvName'] = 'Stash: '..OtherData, ['InvSlots'] = Slots, ['MaxWeight'] = MaxWeight, ['Items'] = Stashes[OtherData], ['ExtraData'] = ExtraData}
			TriggerClientEvent('framework-inv:client:open:inventory:other', src, TotalData)
			Citizen.SetTimeout(5, function()
				OpenInventories[OtherData] = true
			end)
		else
			TriggerClientEvent('framework-inv:client:open:empty:other', source)
		end
	elseif Type == 'TempStashes' then
		if not OpenInventories[OtherData] then
			if TempStashes[OtherData] == nil then TempStashes[OtherData] = {} end
			local TotalData = {['Type'] = 'TempStashes', ['SubType'] = OtherData, ['InvName'] = OtherData, ['InvSlots'] = Slots, ['MaxWeight'] = MaxWeight, ['Items'] = TempStashes[OtherData], ['ExtraData'] = ExtraData}
			TriggerClientEvent('framework-inv:client:open:inventory:other', src, TotalData)
			Citizen.SetTimeout(5, function()
				OpenInventories[OtherData] = true
			end)
		else
			TriggerClientEvent('framework-inv:client:open:empty:other', source)
		end
	elseif Type == 'OtherPlayer' then
		if not OpenInventories['OT'..OtherData] then
			local OtherPlayer = LSCore.Functions.GetPlayer(tonumber(OtherData))
			if OtherPlayer ~= nil then
				local TotalData = {['Type'] = 'OtherPlayer', ['SubType'] = tonumber(OtherData), ['InvName'] = 'Speler-'..tonumber(OtherData), ['InvSlots'] = Config.InventorySlots, ['MaxWeight'] = Config.MaxInventoryWeight, ['Items'] = OtherPlayer.PlayerData.inventory}
				TriggerClientEvent('framework-inv:client:set:inventory:state', tonumber(OtherData), false)
				TriggerClientEvent('framework-inv:client:open:inventory:other', src, TotalData)
				Citizen.SetTimeout(5, function()
					OpenInventories['OT'..OtherData] = true
				end)
			else
				TriggerClientEvent('framework-inv:client:open:empty:other', source)
			end
		else
			TriggerClientEvent('framework-inv:client:open:empty:other', source)
		end
	elseif Type == 'Drop' then
		if not OpenInventories['D'..OtherData['SubType']] then
			TriggerClientEvent('framework-inv:client:open:inventory:other', src, OtherData)
			Citizen.SetTimeout(5, function()
				OpenInventories['D'..OtherData['SubType']] = true
			end)
		else
			TriggerClientEvent('framework-inv:client:open:empty:other', source)
		end
	else
		TriggerClientEvent('framework-inv:client:open:inventory:other', src, OtherData)
	end
end)

RegisterServerEvent('framework-inv:server:check:other')
AddEventHandler('framework-inv:server:check:other', function(Type, Name)
	if Type == 'Glovebox' then
		LSCore.Functions.ExecuteSql(true, "SELECT * FROM `player_inventory-vehicle` WHERE `plate` = '"..Name.."'", function(result)
			if result ~= nil and result[1] ~= nil then
				if Gloveboxes[Name] ~= nil then
					Gloveboxes[Name] = nil
				end
			end
		end)
		OpenInventories['G'..Name] = false
	elseif Type == 'Trunk' then
		LSCore.Functions.ExecuteSql(true, "SELECT * FROM `player_inventory-vehicle` WHERE `plate` = '"..Name.."'", function(result)
			if result ~= nil and result[1] ~= nil then
				if Trunks[Name] ~= nil then
					Trunks[Name] = nil
				end
			end
		end)
		OpenInventories['T'..Name] = false
	elseif Type == 'Stash' then
		if Stashes[Name] ~= nil then
			Stashes[Name] = nil
		end
		OpenInventories[Name] = false
	elseif Type == 'TempStashes' then
		OpenInventories[Name] = false
	elseif Type == 'Drop' then
		OpenInventories['D'..Name] = false
	elseif Type == 'OtherPlayer' then
		OpenInventories['OT'..Name] = false
		TriggerClientEvent('framework-inv:client:set:inventory:state', tonumber(Name), true)
	end
end)

RegisterServerEvent('framework-inv:server:disable:other')
AddEventHandler('framework-inv:server:disable:other', function(PlayerId, State)
	local OtherPlayer = LSCore.Functions.GetPlayer(tonumber(PlayerId))
	if OtherPlayer ~= nil then
		TriggerClientEvent('framework-inv:client:set:inventory:state', tonumber(PlayerId), State)
	end
end)

RegisterServerEvent('framework-inv:server:steal:money')
AddEventHandler('framework-inv:server:steal:money', function(TargetId)
	local SourcePlayer = LSCore.Functions.GetPlayer(source)
	local TargetPlayer = LSCore.Functions.GetPlayer(TargetId)
	if TargetPlayer ~= nil then
		local StealCash = TargetPlayer.PlayerData.money['cash']
		if StealCash > 0 then
			if SourcePlayer.PlayerData.job.name == 'police' and SourcePlayer.PlayerData.job.onduty then
				SourcePlayer.Functions.AddItem('moneybag', 1, false, {worth = StealCash}, true)
				TargetPlayer.Functions.RemoveMoney('cash', StealCash)
				TriggerClientEvent('framework-inv:client:update:player', source)
			else
				SourcePlayer.Functions.AddMoney('cash', StealCash)
				TargetPlayer.Functions.RemoveMoney('cash', StealCash)
				TriggerClientEvent('LSCore:Notify', TargetPlayer.PlayerData.source, "Je bent van €"..StealCash.." beroofd", 'error')
			end
		end
	end
end)
-- RegisterServerEvent('framework-inv:server:steal:money')
-- AddEventHandler('framework-inv:server:steal:money', function(TargetId)
-- 	local SourcePlayer = LSCore.Functions.GetPlayer(source)
-- 	local TargetPlayer = LSCore.Functions.GetPlayer(TargetId)
-- 	if TargetPlayer ~= nil then
-- 		-- if StealCash ~= nil then
-- 		local ItemData = Player.Functions.GetItemByName('cash')
-- 		if ItemData == nil then return false end
-- 			if ItemData.amount > 0 then
-- 		-- local StealCash = TargetPlayer.PlayerData.money['cash']
-- 		-- if StealCash > 0 then
-- 			if SourcePlayer.PlayerData.job.name == 'police' and SourcePlayer.PlayerData.job.onduty then
-- 				SourcePlayer.Functions.AddItem('moneybag', 1, false, {worth = StealCash}, true)
-- 				-- TargetPlayer.Functions.RemoveMoney('cash', StealCash)
-- 				TargetPlayer.Functions.AddMoney('cash', StealCash, false, false)
-- 				TriggerClientEvent('framework-inv:client:update:player', source)
-- 			else
-- 				SourcePlayer.Functions.AddMoney('cash', StealCash, false, false)
-- 				TargetPlayer.Functions.RemoveMoney('cash', StealCash, false, false)
-- 				-- SourcePlayer.Functions.AddMoney('cash', StealCash)
-- 				-- TargetPlayer.Functions.RemoveMoney('cash', StealCash)
-- 				TriggerClientEvent('LSCore:Notify', TargetPlayer.PlayerData.source, "Je bent van €"..StealCash.." beroofd", 'error')
-- 			end
-- 		end
-- 	end
-- end)

RegisterServerEvent('framework-inv:server:set:player:items')
AddEventHandler('framework-inv:server:set:player:items', function(PlayerItems)
	local Player = LSCore.Functions.GetPlayer(source)
	Player.Functions.SetItemData(PlayerItems)
end)

LSCore.Functions.CreateCallback('framework-inv:server:done:crafting', function(source, cb, ItemName, Amount, ToSlot, Info, Cost)
	local Player = LSCore.Functions.GetPlayer(source)
	local RepAmount = 1
	local CheckItems = {}
	local count = 0
	for k, v in pairs(Cost) do
		local NewData = {}
		NewData['Itemname'] = v['ItemName']
		NewData['Amount'] = v['Amount'] * Amount
		table.insert(CheckItems, NewData)
	end
	
	for k, v in pairs(CheckItems) do
		if Player.Functions.RemoveItem(v.Itemname, v.Amount, false, false) then
			count = count + 1
		end
	end

	if count >= #CheckItems then
		count = 0
		if Player.Functions.AddItem(ItemName, Amount, ToSlot, Info, true, 'Inventory') then
			-- for k, v in pairs(Cost) do
			-- 	Player.Functions.RemoveItem(v['ItemName'], (v['Amount'] * Amount), false, false)
			-- end
			-- print('succes')
		end
		if Amount > 20 then
			RepAmount = math.random(1,10)
		else
			RepAmount = 1 * Amount
		end
		TriggerEvent("framework-logs:server:SendLog", "crafting", "Craftlogger", 'red', "(citizenid: *"..Player.PlayerData.citizenid.."* | name: "..Player.PlayerData.name.." | id: *(" ..source..")* Heeft "..Amount.."x "..ItemName.." gemaakt bij de craft tafel")
		Player.Functions.SetMetaData("craftingrep", Player.PlayerData.metadata["craftingrep"] + 1 * RepAmount)
	else
		TriggerEvent("framework-logs:server:SendLog", "cheaters", "Craftlogger", 'red', "(citizenid: *"..Player.PlayerData.citizenid.."* | name: "..Player.PlayerData.name.." | id: *(" ..source..")* Heeft "..Amount.."x "..ItemName.." proberen te maken en de items gedropped wat een boefje")
	end
end)

-- Anti triggers Dennii (ItzHighNL)

RegisterServerEvent('framework-inv:server:done:combinding')
AddEventHandler('framework-inv:server:done:combinding', function()
    local Player = LSCore.Functions.GetPlayer(source)
    TriggerEvent("framework-logs:server:SendLog", "cheaters", "Event Trigger", 'red', "(citizenid: *"..Player.PlayerData.citizenid.."* | name: "..Player.PlayerData.name.." | id: *(" ..source..")* Heeft een event getriggerd welke is omgezet door Dennii om cheaters tegen te gaan")
end)

LSCore.Functions.CreateCallback('framework-inv:server:done:combinding', function(source, cb, FromSlot, FromItem, ToSlot, ToItem, Reward)
-- RegisterServerEvent('framework-inv:server:done:combinding')
-- AddEventHandler('framework-inv:server:done:combinding', function(FromSlot, FromItem, ToSlot, ToItem, Reward)
	local Player = LSCore.Functions.GetPlayer(source)
	local FromItemCheck = Player.Functions.GetItemByName(FromItem)
	local ToItemCheck = Player.Functions.GetItemByName(ToItem)
	if FromItemCheck ~= nil and ToItemCheck ~= nil then
		Player.Functions.RemoveItem(FromItem, 1, FromSlot, true)
		Player.Functions.RemoveItem(ToItem, 1, ToSlot, true)
		local ItemData = Shared.ItemList[Reward:lower()]
		if ItemData['type'] == 'weapon' then
			if ItemData['melee'] then
				Info = {quality = 100.0}
			else
				Info = {ammo = 5, quality = 100.0, serie = tostring(LSCore.Shared.RandomInt(2) .. LSCore.Shared.RandomStr(3) .. LSCore.Shared.RandomInt(1) .. LSCore.Shared.RandomStr(2) .. LSCore.Shared.RandomInt(3) .. LSCore.Shared.RandomStr(4))}
			end
		else
			Info = {}
		end
		Player.Functions.AddItem(Reward, 1, false, Info, true)
	end
end)

RegisterServerEvent('framework-inv:server:use:item')
AddEventHandler('framework-inv:server:use:item', function(Slot)
	local Player = LSCore.Functions.GetPlayer(source)
	local ItemData = Player.Functions.GetItemBySlot(Slot)
	if ItemData ~= nil and ItemData.amount > 0 then
		if LSCore.Functions.CanUseItem(ItemData.name) then
			TriggerClientEvent('framework-inv:client:item:box', source, 'Used', Shared.ItemList[ItemData.name], false)
			LSCore.Functions.UseItem(source, ItemData)
		elseif ItemData.type == 'weapon' then
			if ItemData.info.quality ~= nil then
				if ItemData.info.quality > 0 then
					TriggerClientEvent('framework-inv:client:item:box', source, 'Used', Shared.ItemList[ItemData.name], false)
					TriggerClientEvent('framework-inv:client:use:weapon', source, ItemData)
				else
					TriggerClientEvent('LSCore:Notify', source, "Item is kapot..", 'error')
				end
			else
				TriggerClientEvent('LSCore:Notify', source, "Geen wapen kwaliteit gevonden..", 'error')
			end
		end
	end
end)

RegisterServerEvent('framework-inv:server:add:new:drop:core')
AddEventHandler('framework-inv:server:add:new:drop:core', function(Source, ItemName, Amount, Info)
	local source = Source
	local RandomId = math.random(1111,99999)
	local PlayerCoords = GetEntityCoords(GetPlayerPed(source))
	Config.Drops[RandomId] = {
		['SubType'] = RandomId,
		['Type'] = 'Drop',
		['InvName'] = 'Grond',
		['InvSlots'] = 15,
		['Coords'] = vector3(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z - 0.3),
		['Items'] = {
			[1] = {
				name = ItemName,
				slot = 1,
				amount = Amount,
				info = Info,
			},
		},
	}
	TriggerClientEvent('framework-inv:client:update:drops', -1, Config.Drops[RandomId], RandomId)
end)

LSCore.Functions.CreateCallback('framework-inv:server:is:player:crafting', function(source, cb, target)
	local TargetPlayer = LSCore.Functions.GetPlayer(target)
	if TargetPlayer ~= nil then
		cb(TargetPlayer.PlayerData.metadata['iscrafting'])
	end
	cb(true)
end)

LSCore.Functions.CreateCallback('framework-inv:server:do:item:data', function(source, cb, data)
    local src = source
	local Player, OtherPlayer = LSCore.Functions.GetPlayer(src), LSCore.Functions.GetPlayer(data['SubType']) ~= nil and LSCore.Functions.GetPlayer(data['SubType'])
	local OtherInventoryItems, ExtraData, MaxOtherWeight = data['OtherItems'], data['ExtraData'], data['MaxOtherWeight']
	local Amount, Type, SubType = tonumber(data['Amount']), data['Type'], data['SubType']
	local ToSlot, FromSlot = tonumber(data['ToSlot']), tonumber(data['FromSlot'])
	local ToInventory, FromInventory = data['ToInventory'], data['FromInventory']
	--print(Amount, ToSlot, FromSlot, ToInventory, FromInventory, Type, SubType, MaxOtherWeight, ExtraData)
	if ToInventory == '.my-inventory-blocks' and FromInventory == '.other-inventory-blocks' then
		if Type == 'Store' then
			if Player.PlayerData.money['bank'] >= (OtherInventoryItems[FromSlot].price * Amount) then
		-- local ItemData = Player.Functions.GetItemByName('cash')
		-- if ItemData == nil then return false end
		-- 	if ItemData.amount >= (OtherInventoryItems[FromSlot].price * Amount) then

			-- if Player.PlayerData.money['cash'] >= (OtherInventoryItems[FromSlot].price * Amount) then
				if Shared.ItemList[OtherInventoryItems[FromSlot].name:lower()]['type'] == 'weapon' and not Shared.ItemList[OtherInventoryItems[FromSlot].name:lower()]['melee'] then
					if SubType == 'PoliceStore' then
						OtherInventoryItems[FromSlot].info = {quality = 100.0, ammo = 5, serie = Player.PlayerData.job.serial}
					else
						OtherInventoryItems[FromSlot].info = {quality = 100.0, ammo = 5, serie = LSCore.Shared.RandomStr(2)..LSCore.Shared.RandomInt(3):upper()..LSCore.Shared.RandomStr(3)..LSCore.Shared.RandomInt(3):upper()..LSCore.Shared.RandomStr(2)..LSCore.Shared.RandomInt(3):upper()}
					end
				elseif Shared.ItemList[OtherInventoryItems[FromSlot].name:lower()]['type'] == 'weapon' and Shared.ItemList[OtherInventoryItems[FromSlot].name:lower()]['melee'] then
					OtherInventoryItems[FromSlot].info = {quality = 100.0}
				else
					if OtherInventoryItems[FromSlot].name:lower() == 'duffel-bag' then
						OtherInventoryItems[FromSlot].info = {bagid = math.random(1111,99999)}
					end
					if OtherInventoryItems[FromSlot].name:lower() == 'burger-box' then
						OtherInventoryItems[FromSlot].info = {bagid = math.random(1111,99999)}
					end
				end
				if Player.Functions.AddItem(OtherInventoryItems[FromSlot].name, Amount, ToSlot, OtherInventoryItems[FromSlot].info, false, 'Inventory') then
					Player.Functions.RemoveMoney('bank', (OtherInventoryItems[FromSlot].price * Amount)) 
					-- Player.Functions.RemoveItem('cash', (OtherInventoryItems[FromSlot].price * Amount))
					if SubType == 'WeaponDealer' then
						TriggerClientEvent('framework-inv:client:force:close', src)
						TriggerEvent('framework-randomdealer:server:set:weapons', 'Minus', OtherInventoryItems[FromSlot].name, 1)
					elseif SubType == 'DealerDealer' then
						TriggerClientEvent('framework-inv:client:force:close', src)
						TriggerEvent('framework-dealers:server:update:dealer:items', OtherInventoryItems[FromSlot].slot, Amount, ExtraData)
					end
					cb(true)
				else
					cb(false)
				end
			else
				cb(false)
			end
		elseif Type == 'Drop' then
			if Config.Drops[SubType] ~= nil and Config.Drops[SubType]['Items'] ~= nil then
				if Config.Drops[SubType]['Items'][FromSlot] ~= nil then
					if Player.Functions.AddItem(Config.Drops[SubType]['Items'][FromSlot].name, Amount, ToSlot, Config.Drops[SubType]['Items'][FromSlot].info, false, 'Inventory') then
						TriggerEvent("framework-logs:server:SendLog", "drop", "Item Removed", 'green', "(citizenid: *"..Player.PlayerData.citizenid.."* | name: "..Player.PlayerData.name.." | id: *(" ..src..")* Heeft **"..Amount..'x '..Config.Drops[SubType]['Items'][FromSlot].name.. "** opgepakt van drop: "..SubType)
						if Config.Drops[SubType]['Items'][FromSlot].amount - Amount == 0 then
							Config.Drops[SubType]['Items'][FromSlot] = nil
						else
							Config.Drops[SubType]['Items'][FromSlot].amount = Config.Drops[SubType]['Items'][FromSlot].amount - Amount
						end
						CheckDropInventory(SubType)
						TriggerClientEvent('framework-inv:client:update:drops', -1, Config.Drops[SubType], SubType)
						cb(true)
					else
						cb(false)
					end
				else
					cb(false)
				end
			else
				cb(false)
			end
		elseif Type == 'Trunk' then
			local DBItems = Trunks[SubType] ~= nil and Trunks[SubType] or TriggerClientEvent('framework-inv:client:force:close', src)
			if DBItems ~= nil and DBItems[FromSlot] ~= nil then
				if Player.Functions.AddItem(DBItems[FromSlot].name, Amount, ToSlot, DBItems[FromSlot].info, false, 'Inventory') then
					TriggerEvent("framework-logs:server:SendLog", "trunk", "Item Removed", 'green', "(citizenid: *"..Player.PlayerData.citizenid.."* | name: "..Player.PlayerData.name.." | id: *(" ..src..")* Heeft **"..Amount..'x '..DBItems[FromSlot].name.. "** gepakt uit de kofferbak van het kenteken: "..SubType)
					if DBItems[FromSlot].amount - Amount == 0 then
						DBItems[FromSlot] = nil
					else
						DBItems[FromSlot].amount = DBItems[FromSlot].amount - Amount
					end
					SaveInventoryData('Trunk', SubType, DBItems)
					cb(true)
				else
					cb(false)
				end
			else
				cb(false)
			end
		elseif Type == 'Glovebox' then
			local DBItems = Gloveboxes[SubType] ~= nil and Gloveboxes[SubType] or TriggerClientEvent('framework-inv:client:force:close', src)
			if DBItems ~= nil and DBItems[FromSlot] ~= nil then
				if Player.Functions.AddItem(DBItems[FromSlot].name, Amount, ToSlot, DBItems[FromSlot].info, false, 'Inventory') then
					TriggerEvent("framework-logs:server:SendLog", "glovebox", "Item Removed", 'green', "(citizenid: *"..Player.PlayerData.citizenid.."* | name: "..Player.PlayerData.name.." | id: *(" ..src..")* Heeft **"..Amount..'x '..DBItems[FromSlot].name.. "** gepakt uit de glovebox van het kenteken: "..SubType)
					if DBItems[FromSlot].amount - Amount == 0 then
						DBItems[FromSlot] = nil
					else
						DBItems[FromSlot].amount = DBItems[FromSlot].amount - Amount
					end
					SaveInventoryData('Glovebox', SubType, DBItems)
					cb(true)
				else
					cb(false)
				end
			else
				cb(false)
			end
		elseif Type == 'Stash' then
			local DBItems = Stashes[SubType] ~= nil and Stashes[SubType] or TriggerClientEvent('framework-inv:client:force:close', src)
			if DBItems ~= nil and DBItems[FromSlot] ~= nil then
				if Player.Functions.AddItem(DBItems[FromSlot].name, Amount, ToSlot, DBItems[FromSlot].info, false, 'Inventory') then
					TriggerEvent("framework-logs:server:SendLog", "stash", "Item Removed", 'green', "(citizenid: *"..Player.PlayerData.citizenid.."* | name: "..Player.PlayerData.name.." | id: *(" ..src..")* Heeft **"..Amount..'x '..DBItems[FromSlot].name.. "** gepakt uit de stash met het id: "..SubType)
					if DBItems[FromSlot].amount - Amount == 0 then
						DBItems[FromSlot] = nil
					else
						DBItems[FromSlot].amount = DBItems[FromSlot].amount - Amount
					end
					SaveInventoryData('Stash', SubType, DBItems)
					cb(true)
				else
					cb(false)
				end
			else
				cb(false)
			end
		elseif Type == 'TempStashes' then
			local DBItems = TempStashes[SubType] ~= nil and TempStashes[SubType] or TriggerClientEvent('framework-inv:client:force:close', src)
			if DBItems ~= nil and DBItems[FromSlot] ~= nil then
				if Player.Functions.AddItem(DBItems[FromSlot].name, Amount, ToSlot, DBItems[FromSlot].info, false, 'Inventory') then
					TriggerEvent("framework-logs:server:SendLog", "stash", "Item Removed", 'green', "(citizenid: *"..Player.PlayerData.citizenid.."* | name: "..Player.PlayerData.name.." | id: *(" ..src..")* Heeft **"..Amount..'x '..DBItems[FromSlot].name.. "** gepakt uit de stash met het id: "..SubType)
					if DBItems[FromSlot].amount - Amount == 0 then
						DBItems[FromSlot] = nil
					else
						DBItems[FromSlot].amount = DBItems[FromSlot].amount - Amount
					end
					cb(true)
				else
					cb(false)
				end
			else
				cb(false)
			end
		elseif Type == 'OtherPlayer' then
			if Player.Functions.AddItem(OtherPlayer.PlayerData.inventory[FromSlot].name, Amount, ToSlot, OtherPlayer.PlayerData.inventory[FromSlot].info, false, 'Inventory') then
				local ItemDataFrom = GetItemData(OtherPlayer.PlayerData.inventory[FromSlot].name:lower())
				TriggerEvent("framework-logs:server:SendLog", "robbing", "Item Removed", 'green', "(citizenid: *"..Player.PlayerData.citizenid.."* | name: "..Player.PlayerData.name.." | id: *(" ..src..")* Heeft **"..Amount..'x '..OtherPlayer.PlayerData.inventory[FromSlot].name.. "** gepakt uit de zakken van: ("..OtherPlayer.PlayerData.citizenid..') '..OtherPlayer.PlayerData.name)
				OtherPlayer.Functions.RemoveItem(OtherPlayer.PlayerData.inventory[FromSlot].name, Amount, FromSlot, false)
				if ItemDataFrom['type'] == 'weapon' then
					TriggerClientEvent('framework-inv:client:reset:weapon', OtherPlayer.PlayerData.source)
				end
				TriggerClientEvent('framework-inv:client:update:player', OtherPlayer.PlayerData.source)
				cb(true)
			else
				cb(false)
			end
		elseif Type == 'Crafting' then
			if HasCraftingItems(src, OtherInventoryItems[FromSlot]['Cost'], Amount) then
				if Shared.ItemList[OtherInventoryItems[FromSlot]['ItemName']:lower()]['type'] == 'weapon' and not Shared.ItemList[OtherInventoryItems[FromSlot]['ItemName']:lower()]['melee'] then
					OtherInventoryItems[FromSlot]['Info'] = {quality = 100.0, ammo = 5, serie = LSCore.Shared.RandomStr(2)..LSCore.Shared.RandomInt(3):upper()..LSCore.Shared.RandomStr(3)..LSCore.Shared.RandomInt(3):upper()..LSCore.Shared.RandomStr(2)..LSCore.Shared.RandomInt(3):upper()}
				else
					OtherInventoryItems[FromSlot]['Info'] = {quality = 100.0}
				end
				TriggerClientEvent('framework-inv:client:craft', src, OtherInventoryItems[FromSlot]['ItemName'], Amount, ToSlot, OtherInventoryItems[FromSlot]['Info'], OtherInventoryItems[FromSlot]['Cost'])
				cb('Crafting')
			else
				cb(false)
			end
		end
	elseif ToInventory == '.other-inventory-blocks' and FromInventory == '.my-inventory-blocks' then
		if Type == 'Drop' then
			if Config.Drops[SubType] ~= nil and Config.Drops[SubType]['Items'] ~= nil then
				local TotalWeight = GetTotalWeight(Config.Drops[SubType]['Items'])
				if Player.PlayerData.inventory[FromSlot] ~= nil then
					if WeightCheck(MaxOtherWeight, TotalWeight, Amount, Player.PlayerData.inventory[FromSlot].weight) then
						Player.Functions.RemoveItem(Player.PlayerData.inventory[FromSlot].name, Amount, FromSlot, false)
						TriggerEvent("framework-logs:server:SendLog", "drop", "Dropped", 'red', "(citizenid: *"..Player.PlayerData.citizenid.."* | name: "..Player.PlayerData.name.." | id: *(" ..src..")* Heeft **"..Amount..'x '..Player.PlayerData.inventory[FromSlot].name.. "** op de grond gegooid met id: "..SubType)
						if Config.Drops[SubType]['Items'][ToSlot] == nil then
							Config.Drops[SubType]['Items'][ToSlot] = {
								name = Player.PlayerData.inventory[FromSlot].name,
								slot = ToSlot,
								amount = Amount,
								info = Player.PlayerData.inventory[FromSlot].info,
							}
						else
							Config.Drops[SubType]['Items'][ToSlot].amount = Config.Drops[SubType]['Items'][ToSlot].amount + Amount
						end
						TriggerClientEvent('framework-inv:client:update:drops', -1, Config.Drops[SubType], SubType)
						cb(true)
					else
						cb(false)
					end
				else
					cb(false)
				end
			else
				if Player.PlayerData.inventory[FromSlot] ~= nil then
					local PlayerCoords = GetEntityCoords(GetPlayerPed(src))
					Player.Functions.RemoveItem(Player.PlayerData.inventory[FromSlot].name, Amount, FromSlot, false)
					TriggerEvent("framework-logs:server:SendLog", "drop", "Dropped", 'red', "(citizenid: *"..Player.PlayerData.citizenid.."* | name: "..Player.PlayerData.name.." | id: *(" ..src..")* Heeft **"..Amount..'x '..Player.PlayerData.inventory[FromSlot].name.. "** op de grond gegooid met id: "..SubType)
					Config.Drops[SubType] = {
						['SubType'] = SubType,
						['Type'] = 'Drop',
						['InvName'] = 'Grond',
						['InvSlots'] = 15,
						['Coords'] = vector3(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z - 0.3),
						['Items'] = {
							[ToSlot] = {
								name = Player.PlayerData.inventory[FromSlot].name,
								slot = ToSlot,
								amount = Amount,
								info = Player.PlayerData.inventory[FromSlot].info,
							},
						},
					}
					OpenInventories['D'..SubType] = true
					TriggerClientEvent('framework-inv:client:update:drops', -1, Config.Drops[SubType], SubType)
					cb(true)
				else
					cb(false)
				end
			end
		elseif Type == 'Trunk' then
			local DBItems = Trunks[SubType] ~= nil and Trunks[SubType] or TriggerClientEvent('framework-inv:client:force:close', src)
			local TotalWeight = GetTotalWeight(DBItems)
			if Player.PlayerData.inventory[FromSlot] ~= nil then
				if WeightCheck(MaxOtherWeight, TotalWeight, Amount, Player.PlayerData.inventory[FromSlot].weight) then
					Player.Functions.RemoveItem(Player.PlayerData.inventory[FromSlot].name, Amount, FromSlot, false)
					TriggerEvent("framework-logs:server:SendLog", "trunk", "Trunk Item Added", 'red', "(citizenid: *"..Player.PlayerData.citizenid.."* | name: "..Player.PlayerData.name.." | id: *(" ..src..")* Heeft **"..Amount..'x '..Player.PlayerData.inventory[FromSlot].name.. "** in de kofferbak gegooid met het kenteken: "..SubType)
					if DBItems[ToSlot] == nil then
						DBItems[ToSlot] = {
							name = Player.PlayerData.inventory[FromSlot].name,
							slot = ToSlot,
							amount = Amount,
							info = Player.PlayerData.inventory[FromSlot].info,
						}
					else
						DBItems[ToSlot].amount = DBItems[ToSlot].amount + Amount
					end
					SaveInventoryData('Trunk', SubType, DBItems)
					cb(true)
				else
					cb(false)
				end
			else
				cb(false)
			end
		elseif Type == 'Glovebox' then
			local DBItems = Gloveboxes[SubType] ~= nil and Gloveboxes[SubType] or TriggerClientEvent('framework-inv:client:force:close', src)
			local TotalWeight = GetTotalWeight(DBItems)
			if Player.PlayerData.inventory[FromSlot] ~= nil then
				if WeightCheck(MaxOtherWeight, TotalWeight, Amount, Player.PlayerData.inventory[FromSlot].weight) then
					Player.Functions.RemoveItem(Player.PlayerData.inventory[FromSlot].name, Amount, FromSlot, false)
					TriggerEvent("framework-logs:server:SendLog", "glovebox", "Glovebox Item Added", 'red', "(citizenid: *"..Player.PlayerData.citizenid.."* | name: "..Player.PlayerData.name.." | id: *(" ..src..")* Heeft **"..Amount..'x '..Player.PlayerData.inventory[FromSlot].name.. "** in het dashboard gegooid met het kenteken: "..SubType)
					if DBItems[ToSlot] == nil then
						DBItems[ToSlot] = {
							name = Player.PlayerData.inventory[FromSlot].name,
							slot = ToSlot,
							amount = Amount,
							info = Player.PlayerData.inventory[FromSlot].info,
						}
					else
						DBItems[ToSlot].amount = DBItems[ToSlot].amount + Amount
					end
					SaveInventoryData('Glovebox', SubType, DBItems)
					cb(true)
				else
					cb(false)
				end
			else
				cb(false)
			end
		elseif Type == 'Stash' then
			local DBItems = Stashes[SubType] ~= nil and Stashes[SubType] or TriggerClientEvent('framework-inv:client:force:close', src)
			local TotalWeight = GetTotalWeight(DBItems)
			if Player.PlayerData.inventory[FromSlot] ~= nil then
				if WeightCheck(MaxOtherWeight, TotalWeight, Amount, Player.PlayerData.inventory[FromSlot].weight) then
					if ExtraData ~= Player.PlayerData.inventory[FromSlot].name then
						Player.Functions.RemoveItem(Player.PlayerData.inventory[FromSlot].name, Amount, FromSlot, false)
						TriggerEvent("framework-logs:server:SendLog", "stash", "Stash Item Added", 'red', "(citizenid: *"..Player.PlayerData.citizenid.."* | name: "..Player.PlayerData.name.." | id: *(" ..src..")* Heeft **"..Amount..'x '..Player.PlayerData.inventory[FromSlot].name.. "** in de stash gegooid met id: "..SubType)
						if DBItems[ToSlot] == nil then
							DBItems[ToSlot] = {
								name = Player.PlayerData.inventory[FromSlot].name,
								slot = ToSlot,
								amount = Amount,
								info = Player.PlayerData.inventory[FromSlot].info,
							}
						else
							DBItems[ToSlot].amount = DBItems[ToSlot].amount + Amount
						end
						SaveInventoryData('Stash', SubType, DBItems)
						cb(true)
					else
						cb(false)
					end
				else
					cb(false)
				end
			else
				cb(false)
			end
		elseif Type == 'TempStashes' then
			local DBItems = TempStashes[SubType] ~= nil and TempStashes[SubType] or TriggerClientEvent('framework-inv:client:force:close', src)
			local TotalWeight = GetTotalWeight(DBItems)
			if Player.PlayerData.inventory[FromSlot] ~= nil then
				if WeightCheck(MaxOtherWeight, TotalWeight, Amount, Player.PlayerData.inventory[FromSlot].weight) then
					Player.Functions.RemoveItem(Player.PlayerData.inventory[FromSlot].name, Amount, FromSlot, false)
					TriggerEvent("framework-logs:server:SendLog", "stash", "Stash Item Added", 'red', "(citizenid: *"..Player.PlayerData.citizenid.."* | name: "..Player.PlayerData.name.." | id: *(" ..src..")* Heeft **"..Amount..'x '..Player.PlayerData.inventory[FromSlot].name.. "** in de stash gegooid met id: "..SubType)
					if DBItems[ToSlot] == nil then
						DBItems[ToSlot] = {
							name = Player.PlayerData.inventory[FromSlot].name,
							slot = ToSlot,
							amount = Amount,
							info = Player.PlayerData.inventory[FromSlot].info,
						}
					else
						DBItems[ToSlot].amount = DBItems[ToSlot].amount + Amount
					end
					cb(true)
				else
					cb(false)
				end
			else
				cb(false)
			end
		elseif Type == 'OtherPlayer' then
			if OtherPlayer.Functions.AddItem(Player.PlayerData.inventory[FromSlot].name, Amount, ToSlot, Player.PlayerData.inventory[FromSlot].info, false, 'Inventory') then
				Player.Functions.RemoveItem(Player.PlayerData.inventory[FromSlot].name, Amount, FromSlot, false)
				TriggerEvent("framework-logs:server:SendLog", "robbing", "Player Item Added", 'red', "(citizenid: *"..Player.PlayerData.citizenid.."* | name: "..Player.PlayerData.name.." | id: *(" ..src..")* Heeft **"..Amount..'x '..Player.PlayerData.inventory[FromSlot].name.. "** in de zakken gegooid van ("..OtherPlayer.PlayerData.citizenid..') '..OtherPlayer.PlayerData.name)
				TriggerClientEvent('framework-inv:client:update:player', OtherPlayer.PlayerData.source)
				cb(true)
			else
				cb(false)
			end
		end
	elseif ToInventory == '.other-inventory-blocks' and FromInventory == '.other-inventory-blocks' then
		if Type == 'Drop' then
			if ExtraData == 'Swap' then
				local DataFrom = Config.Drops[SubType]['Items'][FromSlot]
				local DataTo = Config.Drops[SubType]['Items'][ToSlot]
				Config.Drops[SubType]['Items'][ToSlot] = {
					name = DataFrom.name,
					slot = ToSlot,
					amount = DataFrom.amount,
					info = DataFrom.info,
				}
				Config.Drops[SubType]['Items'][FromSlot] = {
					name = DataTo.name,
					slot = FromSlot,
					amount = DataTo.amount,
					info = DataTo.info,
				}
				TriggerClientEvent('framework-inv:client:update:drops', -1, Config.Drops[SubType], SubType)
				cb(true)
			elseif Config.Drops[SubType]['Items'][FromSlot].amount == Amount then
				if Config.Drops[SubType]['Items'][ToSlot] == nil then
					Config.Drops[SubType]['Items'][ToSlot] = {
						name = Config.Drops[SubType]['Items'][FromSlot].name,
						slot = ToSlot,
						amount = Amount,
						info = Config.Drops[SubType]['Items'][FromSlot].info,
					}
					Config.Drops[SubType]['Items'][FromSlot] = nil
					TriggerClientEvent('framework-inv:client:update:drops', -1, Config.Drops[SubType], SubType)
					cb(true)
				else
					Config.Drops[SubType]['Items'][ToSlot] = {
						name = Config.Drops[SubType]['Items'][ToSlot].name,
						slot = ToSlot,
						amount = Config.Drops[SubType]['Items'][ToSlot].amount + Amount,
						info = Config.Drops[SubType]['Items'][ToSlot].info,
					}
					Config.Drops[SubType]['Items'][FromSlot] = nil
					TriggerClientEvent('framework-inv:client:update:drops', -1, Config.Drops[SubType], SubType)
					cb(true)
				end
			elseif Config.Drops[SubType]['Items'][FromSlot].amount > Amount then
				if Config.Drops[SubType]['Items'][ToSlot] == nil then
					Config.Drops[SubType]['Items'][ToSlot] = {
						name = Config.Drops[SubType]['Items'][FromSlot].name,
						slot = ToSlot,
						amount = Amount,
						info = Config.Drops[SubType]['Items'][FromSlot].info,
					}
					Config.Drops[SubType]['Items'][FromSlot].amount = Config.Drops[SubType]['Items'][FromSlot].amount - Amount
					TriggerClientEvent('framework-inv:client:update:drops', -1, Config.Drops[SubType], SubType)
					cb(true)
				else
					Config.Drops[SubType]['Items'][ToSlot].amount = Config.Drops[SubType]['Items'][ToSlot].amount + Amount
					Config.Drops[SubType]['Items'][FromSlot].amount = Config.Drops[SubType]['Items'][FromSlot].amount - Amount
					TriggerClientEvent('framework-inv:client:update:drops', -1, Config.Drops[SubType], SubType)
					cb(true)
				end
			end
		elseif Type == 'Trunk' then
			local DBItems = Trunks[SubType] ~= nil and Trunks[SubType] or TriggerClientEvent('framework-inv:client:force:close', src)
			if ExtraData == 'Swap' then
				local DataFrom = DBItems[FromSlot]
				local DataTo = DBItems[ToSlot]
				DBItems[ToSlot] = {
					name = DataFrom.name,
					slot = ToSlot,
					amount = DataFrom.amount,
					info = DataFrom.info,
				}
				DBItems[FromSlot] = {
					name = DataTo.name,
					slot = FromSlot,
					amount = DataTo.amount,
					info = DataTo.info,
				}
				SaveInventoryData('Trunk', SubType, DBItems)
				cb(true)
			elseif DBItems[FromSlot].amount == Amount then
				if DBItems[ToSlot] == nil then
					DBItems[ToSlot] = {
						name = DBItems[FromSlot].name,
						slot = ToSlot,
						amount = Amount,
						info = DBItems[FromSlot].info,
					}
					DBItems[FromSlot] = nil
					SaveInventoryData('Trunk', SubType, DBItems)
					cb(true)
				else
					DBItems[ToSlot] = {
						name = DBItems[ToSlot].name,
						slot = ToSlot,
						amount = DBItems[ToSlot].amount + Amount,
						info = DBItems[ToSlot].info,
					}
					DBItems[FromSlot] = nil
					SaveInventoryData('Trunk', SubType, DBItems)
					cb(true)
				end
			elseif DBItems[FromSlot].amount > Amount then
				if DBItems[ToSlot] == nil then
					DBItems[ToSlot] = {
						name = DBItems[FromSlot].name,
						slot = ToSlot,
						amount = Amount,
						info = DBItems[FromSlot].info,
					}
					DBItems[FromSlot].amount = DBItems[FromSlot].amount - Amount
					SaveInventoryData('Trunk', SubType, DBItems)
					cb(true)
				else
					DBItems[ToSlot].amount = DBItems[ToSlot].amount + Amount
					DBItems[FromSlot].amount = DBItems[FromSlot].amount - Amount
					SaveInventoryData('Trunk', SubType, DBItems)
					cb(true)
				end
			end
		elseif Type == 'Glovebox' then
			local DBItems = Gloveboxes[SubType] ~= nil and Gloveboxes[SubType] or TriggerClientEvent('framework-inv:client:force:close', src)
			if ExtraData == 'Swap' then
				local DataFrom = DBItems[FromSlot]
				local DataTo = DBItems[ToSlot]
				DBItems[ToSlot] = {
					name = DataFrom.name,
					slot = ToSlot,
					amount = DataFrom.amount,
					info = DataFrom.info,
				}
				DBItems[FromSlot] = {
					name = DataTo.name,
					slot = FromSlot,
					amount = DataTo.amount,
					info = DataTo.info,
				}
				SaveInventoryData('Glovebox', SubType, DBItems)
				cb(true)
			elseif DBItems[FromSlot].amount == Amount then
				if DBItems[ToSlot] == nil then
					DBItems[ToSlot] = {
						name = DBItems[FromSlot].name,
						slot = ToSlot,
						amount = Amount,
						info = DBItems[FromSlot].info,
					}
					DBItems[FromSlot] = nil
					SaveInventoryData('Glovebox', SubType, DBItems)
					cb(true)
				else
					DBItems[ToSlot] = {
						name = DBItems[ToSlot].name,
						slot = ToSlot,
						amount = DBItems[ToSlot].amount + Amount,
						info = DBItems[ToSlot].info,
					}
					DBItems[FromSlot] = nil
					SaveInventoryData('Glovebox', SubType, DBItems)
					cb(true)
				end
			elseif DBItems[FromSlot].amount > Amount then
				if DBItems[ToSlot] == nil then
					DBItems[ToSlot] = {
						name = DBItems[FromSlot].name,
						slot = ToSlot,
						amount = Amount,
						info = DBItems[FromSlot].info,
					}
					DBItems[FromSlot].amount = DBItems[FromSlot].amount - Amount
					SaveInventoryData('Glovebox', SubType, DBItems)
					cb(true)
				else
					DBItems[ToSlot].amount = DBItems[ToSlot].amount + Amount
					DBItems[FromSlot].amount = DBItems[FromSlot].amount - Amount
					SaveInventoryData('Glovebox', SubType, DBItems)
					cb(true)
				end
			end
		elseif Type == 'Stash' then
			local DBItems = Stashes[SubType] ~= nil and Stashes[SubType] or TriggerClientEvent('framework-inv:client:force:close', src)
			if ExtraData == 'Swap' then
				local DataFrom = DBItems[FromSlot]
				local DataTo = DBItems[ToSlot]
				DBItems[ToSlot] = {
					name = DataFrom.name,
					slot = ToSlot,
					amount = DataFrom.amount,
					info = DataFrom.info,
				}
				DBItems[FromSlot] = {
					name = DataTo.name,
					slot = FromSlot,
					amount = DataTo.amount,
					info = DataTo.info,
				}
				SaveInventoryData('Stash', SubType, DBItems)
				cb(true)
			elseif DBItems[FromSlot].amount == Amount then
				if DBItems[ToSlot] == nil then
					DBItems[ToSlot] = {
						name = DBItems[FromSlot].name,
						slot = ToSlot,
						amount = Amount,
						info = DBItems[FromSlot].info,
					}
					DBItems[FromSlot] = nil
					SaveInventoryData('Stash', SubType, DBItems)
					cb(true)
				else
					DBItems[ToSlot] = {
						name = DBItems[ToSlot].name,
						slot = ToSlot,
						amount = DBItems[ToSlot].amount + Amount,
						info = DBItems[ToSlot].info,
					}
					DBItems[FromSlot] = nil
					SaveInventoryData('Stash', SubType, DBItems)
					cb(true)
				end
			elseif DBItems[FromSlot].amount > Amount then
				if DBItems[ToSlot] == nil then
					DBItems[ToSlot] = {
						name = DBItems[FromSlot].name,
						slot = ToSlot,
						amount = Amount,
						info = DBItems[FromSlot].info,
					}
					DBItems[FromSlot].amount = DBItems[FromSlot].amount - Amount
					SaveInventoryData('Stash', SubType, DBItems)
					cb(true)
				else
					DBItems[ToSlot].amount = DBItems[ToSlot].amount + Amount
					DBItems[FromSlot].amount = DBItems[FromSlot].amount - Amount
					SaveInventoryData('Stash', SubType, DBItems)
					cb(true)
				end
			end
		elseif Type == 'TempStashes' then
			local DBItems = TempStashes[SubType] ~= nil and TempStashes[SubType] or TriggerClientEvent('framework-inv:client:force:close', src)
			if ExtraData == 'Swap' then
				local DataFrom = DBItems[FromSlot]
				local DataTo = DBItems[ToSlot]
				DBItems[ToSlot] = {
					name = DataFrom.name,
					slot = ToSlot,
					amount = DataFrom.amount,
					info = DataFrom.info,
				}
				DBItems[FromSlot] = {
					name = DataTo.name,
					slot = FromSlot,
					amount = DataTo.amount,
					info = DataTo.info,
				}
				cb(true)
			elseif DBItems[FromSlot].amount == Amount then
				if DBItems[ToSlot] == nil then
					DBItems[ToSlot] = {
						name = DBItems[FromSlot].name,
						slot = ToSlot,
						amount = Amount,
						info = DBItems[FromSlot].info,
					}
					DBItems[FromSlot] = nil
					cb(true)
				else
					DBItems[ToSlot] = {
						name = DBItems[ToSlot].name,
						slot = ToSlot,
						amount = DBItems[ToSlot].amount + Amount,
						info = DBItems[ToSlot].info,
					}
					DBItems[FromSlot] = nil
					cb(true)
				end
			elseif DBItems[FromSlot].amount > Amount then
				if DBItems[ToSlot] == nil then
					DBItems[ToSlot] = {
						name = DBItems[FromSlot].name,
						slot = ToSlot,
						amount = Amount,
						info = DBItems[FromSlot].info,
					}
					DBItems[FromSlot].amount = DBItems[FromSlot].amount - Amount
					cb(true)
				else
					DBItems[ToSlot].amount = DBItems[ToSlot].amount + Amount
					DBItems[FromSlot].amount = DBItems[FromSlot].amount - Amount
					cb(true)
				end
			end
		elseif Type == 'OtherPlayer' then
			local OtherItems = OtherPlayer.PlayerData.inventory
			if ExtraData == 'Swap' then
				local DataFrom = OtherItems[FromSlot]
				local DataTo = OtherItems[ToSlot]
				local ItemDataFrom = GetItemData(OtherItems[FromSlot].name:lower())
				local ItemDataTo = GetItemData(OtherItems[ToSlot].name:lower())
				OtherItems[ToSlot] = {
					name = DataFrom.name,
					slot = ToSlot,
					amount = DataFrom.amount,
					info = DataFrom.info,
					label = ItemDataFrom["label"], 
					description = ItemDataFrom["description"] ~= nil and ItemDataFrom["description"] or "", 
					weight = ItemDataFrom["weight"], 
					type = ItemDataFrom["type"], 
					unique = ItemDataFrom["unique"], 
					image = ItemDataFrom["image"], 
					combinable = ItemDataFrom["combinable"]
				}
				OtherItems[FromSlot] = {
					name = DataTo.name,
					slot = FromSlot,
					amount = DataTo.amount,
					info = DataTo.info,
					label = ItemDataTo["label"], 
					description = ItemDataTo["description"] ~= nil and ItemDataTo["description"] or "", 
					weight = ItemDataTo["weight"], 
					type = ItemDataTo["type"], 
					unique = ItemDataTo["unique"], 
					image = ItemDataTo["image"],  
					combinable = ItemDataTo["combinable"]
				}
				OtherPlayer.Functions.SetItemData(OtherItems)
				if ItemDataFrom['type'] == 'weapon' then
					TriggerClientEvent('framework-inv:client:reset:weapon', OtherPlayer.PlayerData.source)
				end
				TriggerClientEvent('framework-inv:client:update:player', OtherPlayer.PlayerData.source)
				cb(true)
			elseif OtherItems[FromSlot].amount == Amount then
				if OtherItems[ToSlot] == nil then
					local ItemDataFrom = GetItemData(OtherItems[FromSlot].name:lower())
					OtherItems[ToSlot] = {
						name = OtherItems[FromSlot].name,
						slot = ToSlot,
						amount = Amount,
						info = OtherItems[FromSlot].info,
						label = ItemDataFrom["label"], 
						description = ItemDataFrom["description"] ~= nil and ItemDataFrom["description"] or "", 
						weight = ItemDataFrom["weight"], 
						type = ItemDataFrom["type"], 
						unique = ItemDataFrom["unique"], 
						image = ItemDataFrom["image"], 
						combinable = ItemDataFrom["combinable"]
					}
					OtherItems[FromSlot] = nil
					OtherPlayer.Functions.SetItemData(OtherItems)
					if ItemDataFrom['type'] == 'weapon' then
						TriggerClientEvent('framework-inv:client:reset:weapon', OtherPlayer.PlayerData.source)
					end
					TriggerClientEvent('framework-inv:client:update:player', OtherPlayer.PlayerData.source)
					cb(true)
				else
					local ItemDataTo = GetItemData(OtherItems[ToSlot].name:lower())
					OtherItems[ToSlot] = {
						name = OtherItems[ToSlot].name,
						slot = ToSlot,
						amount = OtherItems[ToSlot].amount + Amount,
						info = OtherItems[ToSlot].info,
						label = ItemDataTo["label"], 
						description = ItemDataTo["description"] ~= nil and ItemDataTo["description"] or "", 
						weight = ItemDataTo["weight"], 
						type = ItemDataTo["type"], 
						unique = ItemDataTo["unique"], 
						image = ItemDataTo["image"], 
						combinable = ItemDataTo["combinable"]
					}
					OtherItems[FromSlot] = nil
					OtherPlayer.Functions.SetItemData(OtherItems)
					TriggerClientEvent('framework-inv:client:update:player', OtherPlayer.PlayerData.source)
					cb(true)
				end
			elseif OtherItems[FromSlot].amount > Amount then
				if OtherItems[ToSlot] == nil then
					local ItemDataFrom = GetItemData(OtherItems[FromSlot].name:lower())
					OtherItems[ToSlot] = {
						name = OtherItems[FromSlot].name,
						slot = ToSlot,
						amount = Amount,
						info = OtherItems[FromSlot].info,
						label = ItemDataFrom["label"], 
						description = ItemDataFrom["description"] ~= nil and ItemDataFrom["description"] or "", 
						weight = ItemDataFrom["weight"], 
						type = ItemDataFrom["type"], 
						unique = ItemDataFrom["unique"], 
						image = ItemDataFrom["image"], 
						combinable = ItemDataFrom["combinable"]
					}
					OtherItems[FromSlot].amount = OtherItems[FromSlot].amount - Amount
					OtherPlayer.Functions.SetItemData(OtherItems)
					if ItemDataFrom['type'] == 'weapon' then
						TriggerClientEvent('framework-inv:client:reset:weapon', OtherPlayer.PlayerData.source)
					end
					TriggerClientEvent('framework-inv:client:update:player', OtherPlayer.PlayerData.source)
					cb(true)
				else
					OtherItems[ToSlot].amount = OtherItems[ToSlot].amount + Amount
					OtherItems[FromSlot].amount = OtherItems[FromSlot].amount - Amount
					OtherPlayer.Functions.SetItemData(OtherItems)
					TriggerClientEvent('framework-inv:client:update:player', OtherPlayer.PlayerData.source)
					cb(true)
				end
			end
		end
	end
end)

-- // Functions \\ --

function GetDBItems(Type, Name)
	local ReturnItems = {}
	if Type == 'Glovebox' then
		LSCore.Functions.ExecuteSql(true, "SELECT * FROM `player_inventory-vehicle` WHERE `plate` = '"..Name.."'", function(result)
			if result ~= nil and result[1] ~= nil then
				local DBItems = json.decode(result[1].gloveboxitems)
				if DBItems ~= nil and DBItems[1] ~= nil then
					for k,v in pairs(DBItems) do
						if DBItems[k] ~= nil then
							if v ~= nil and v.name ~= nil and Shared.ItemList[v.name:lower()] ~= nil then
								local ItemInfo = Shared.ItemList[v.name:lower()]
								ReturnItems[v.slot] = {
									name = ItemInfo["name"],
									amount = tonumber(v.amount),
									info = v.info ~= nil and v.info or "",
									slot = v.slot,
								}
							end
						end
					end
				else
					ReturnItems = {}
				end
			else
				ReturnItems = {}
			end
		end)
	elseif Type == 'Trunk' then
		LSCore.Functions.ExecuteSql(true, "SELECT * FROM `player_inventory-vehicle` WHERE `plate` = '"..Name.."'", function(result)
			if result ~= nil and result[1] ~= nil then
				local DBItems = json.decode(result[1].trunkitems)
				if DBItems ~= nil and DBItems[1] ~= nil then
					for k,v in pairs(DBItems) do
						if DBItems[k] ~= nil then
							if v ~= nil and v.name ~= nil and Shared.ItemList[v.name:lower()] ~= nil then
								local ItemInfo = Shared.ItemList[v.name:lower()]
								ReturnItems[v.slot] = {
									name = ItemInfo["name"],
									amount = tonumber(v.amount),
									info = v.info ~= nil and v.info or "",
									slot = v.slot,
								}
							end
						end
					end
				else
					ReturnItems = {}
				end
			else
				ReturnItems = {}
			end
		end)
	elseif Type == 'Stash' then
		LSCore.Functions.ExecuteSql(true, "SELECT * FROM `player_inventory-stash` WHERE `stash` = '"..Name.."'", function(result)
			if result ~= nil and result[1] ~= nil then
				local DBItems = json.decode(result[1].items)
				if DBItems ~= nil and DBItems[1] ~= nil then
					for k,v in pairs(DBItems) do
						if DBItems[k] ~= nil then
							if v ~= nil and v.name ~= nil and Shared.ItemList[v.name:lower()] ~= nil then
								local ItemInfo = Shared.ItemList[v.name:lower()]
								ReturnItems[v.slot] = {
									name = ItemInfo["name"],
									amount = tonumber(v.amount),
									info = v.info ~= nil and v.info or "",
									slot = v.slot,
								}
							end
						end
					end
				else
					ReturnItems = {}
				end
			else
				ReturnItems = {}
			end
		end)
	end
	return ReturnItems
end

function SaveInventoryData(Type, Name, Items)
	local ItemsJson = {}
	for k, v in pairs(Items) do
		if Items[k] ~= nil then
			local NewData = {}
			NewData.name = v.name
			NewData.slot = v.slot
			NewData.amount = v.amount
			NewData.info = v.info
			table.insert(ItemsJson, NewData)
		end
	end
	if Type == 'Trunk' then
		LSCore.Functions.ExecuteSql(false, "SELECT * FROM `player_vehicles` WHERE `plate` = '"..Name.."'", function(vehicleresult)
			if vehicleresult ~= nil and vehicleresult[1] ~= nil then
				LSCore.Functions.ExecuteSql(false, "SELECT * FROM `player_inventory-vehicle` WHERE `plate` = '"..Name.."'", function(result)
					if result ~= nil and result[1] ~= nil then
						LSCore.Functions.ExecuteSql(false, "UPDATE `player_inventory-vehicle` SET trunkitems='"..json.encode(ItemsJson).."' WHERE `plate` = '"..Name.."'")
					else
						LSCore.Functions.InsertSql(false, "INSERT INTO `player_inventory-vehicle` (`plate`, `trunkitems`) VALUES ('"..Name.."', '"..json.encode(ItemsJson).."')")
					end
				end)
			end
		end)
	elseif Type == 'Glovebox' then
		LSCore.Functions.ExecuteSql(false, "SELECT * FROM `player_vehicles` WHERE `plate` = '"..Name.."'", function(vehicleresult)
			if vehicleresult ~= nil and vehicleresult[1] ~= nil then
				LSCore.Functions.ExecuteSql(false, "SELECT * FROM `player_inventory-vehicle` WHERE `plate` = '"..Name.."'", function(result)
					if result ~= nil and result[1] ~= nil then
						LSCore.Functions.ExecuteSql(false, "UPDATE `player_inventory-vehicle` SET gloveboxitems='"..json.encode(ItemsJson).."' WHERE `plate` = '"..Name.."'")
					else
						LSCore.Functions.InsertSql(false, "INSERT INTO `player_inventory-vehicle` (`plate`, `gloveboxitems`) VALUES ('"..Name.."', '"..json.encode(ItemsJson).."')")
					end
				end)
			end
		end)
	elseif Type == 'Stash' then
		LSCore.Functions.ExecuteSql(false, "SELECT * FROM `player_inventory-stash` WHERE `stash` = '"..Name.."'", function(result)
			if result ~= nil and result[1] ~= nil then
				LSCore.Functions.ExecuteSql(false, "UPDATE `player_inventory-stash` SET items='"..json.encode(ItemsJson).."' WHERE `stash` = '"..Name.."'")
			else
				LSCore.Functions.InsertSql(false, "INSERT INTO `player_inventory-stash` (`stash`, `items`) VALUES ('"..Name.."', '"..json.encode(ItemsJson).."')")
			end
		end)
	end
end

function HasCraftingItems(Source, CostItems, Amount)
	local Player = LSCore.Functions.GetPlayer(Source)
	for k, v in pairs(CostItems) do
		local ItemData = Player.Functions.GetItemByName(v['ItemName'])
		if ItemData ~= nil then
			if ItemData.amount < (v['Amount'] * Amount) then
				return false
			end
		else
			return false
		end
	end
	return true
end

function CheckDropInventory(DropId)
	local NoNilCount = 0
	for i = 1, 15 do
		if Config.Drops[DropId]['Items'][i] ~= nil then
			NoNilCount = NoNilCount + 1
		end
	end
	if NoNilCount == 0 then
		Config.Drops[DropId] = {}
		OpenInventories['D'..DropId] = false
	end
end

function GetTotalWeight(Items)
	local ReturnWeight = 0
	if Items ~= nil and type(Items) == 'table' then
		for k, v in pairs(Items) do
			if Items[k] ~= nil then
				local ItemData = Shared.ItemList[v.name]
				if ItemData ~= nil then
					ReturnWeight = ReturnWeight + (ItemData['weight'] * v.amount)
				end
			end
		end
	end
	return ReturnWeight
end

function WeightCheck(MaxWeight, CurrentWeight, Amount, Weight)
	local MaxWeight = (MaxWeight * 1000)
	local TotalAdd = (Weight * Amount)
	if CurrentWeight + TotalAdd <= MaxWeight then
		return true
	else
		return false
	end
end

function GetInventoryItems(Name)
	return TempStashes[Name]
end

function SetInventoryItems(Name, Items)
	TempStashes[Name] = Items
end

function GetItemData(ItemName)
	return Shared.ItemList[ItemName]
end