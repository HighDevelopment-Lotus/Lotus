local LSCore = exports['ls-core']:GetCoreObject()

-- Code

LSCore.Functions.CreateCallback("ls-housing:server:get:config", function(source, cb)
    cb(Config)
end)

Citizen.CreateThread(function()
    Citizen.SetTimeout(450, function()
        LSCore.Functions.ExecuteSql(false, "SELECT * FROM `player_houses`", function(result)
            if result[1] ~= nil then
                for k, v in pairs(result) do
                    if v.owned == 'true' then
                        Owned = true
                    else
                        Owned = false
                    end
                    Config.Houses[v.house] = {
                        ['DBName'] = v.house,
                        ['Coords'] = json.decode(v.coords),
                        ['Owned'] = Owned,
                        ['Owner'] = v.citizenid,
                        ['Tier'] = v.tier,
                        ['Price'] = v.price,
                        ['Door-Lock'] = true,
                        ['Adres'] = v.label,
                        ['Garage'] = json.decode(v.garage),
                        ['HasGarage'] = v.hasgarage,
                        ['Key-Holders'] = json.decode(v.keyholders),
                        ['Decorations'] = {}
                    }
                    Citizen.Wait(25)
                    TriggerClientEvent("ls-housing:client:sync:config", -1, v.house, Config.Houses[v.house])
                end
            end
        end)
    end)
end)


-- Citizen.CreateThread(function()
--     LSCore.Functions.ExecuteSql(false, "SELECT * FROM `houselocations`", function(Firstresult)
--         if Firstresult[1] ~= nil then
--             for k, v in pairs(Firstresult) do
--                 LSCore.Functions.ExecuteSql(false, "SELECT * FROM `player_houses` WHERE `house` = '"..v.name.."'", function(Secondresult)
--                     if Secondresult[1] ~= nil then
--                         local NewData = {}
--                         local Tier = v.tier
--                         local Garage = false
--                         if v.tier == 11 then
--                             Tier = 13
--                         elseif v.tier == 9 then
--                             Tier = 11
--                         elseif v.tier == 8 then
--                             Tier = 12
--                         elseif v.tier == 7 then
--                             Tier = 3
--                         elseif v.tier == 5 then
--                             Tier = 6
--                         elseif v.tier == 4 then
--                             Tier = 9
--                         elseif v.tier == 3 then
--                             Tier = 4
--                         end
--                         local CurrentHouseCoords = json.decode(v.coords)
--                         local NewHouseCoords = {['Enter'] = {['X'] = CurrentHouseCoords['enter']['x'], ['Y'] = CurrentHouseCoords['enter']['y'],['Z'] = CurrentHouseCoords['enter']['z'],['H'] = CurrentHouseCoords['enter']['h']}}
                        
                        
                        
                        
--                         local CurrentGarageCoords = json.decode(v.garage)
--                         if CurrentGarageCoords ~= nil then
--                             local NewGarageCoords = {['X'] = CurrentGarageCoords['x'], ['Y'] = CurrentGarageCoords['y'],['Z'] = CurrentGarageCoords['z'],['H'] = CurrentGarageCoords['h']}
--                             Garage = true
--                             LSCore.Functions.ExecuteSql(false, "INSERT INTO `player_houses-new` (`citizenid`, `house`, `label`, `price`, `tier`, `owned`, `coords`, `keyholders`, `hasgarage`, `garage`) VALUES ('"..Secondresult[1].citizenid.."', '"..v.name.."', '"..v.label.."', "..v.price..", "..Tier..", 'true', '"..json.encode(NewHouseCoords).."', '"..Secondresult[1].keyholders.."', '"..tostring(Garage).."', '"..json.encode(NewGarageCoords).."')")
--                         else
--                             LSCore.Functions.ExecuteSql(false, "INSERT INTO `player_houses-new` (`citizenid`, `house`, `label`, `price`, `tier`, `owned`, `coords`, `keyholders`, `hasgarage`, `garage`) VALUES ('"..Secondresult[1].citizenid.."', '"..v.name.."', '"..v.label.."', "..v.price..", "..Tier..", 'true', '"..json.encode(NewHouseCoords).."', '"..Secondresult[1].keyholders.."', '"..tostring(Garage).."', '{}')")
--                         end
--                         print('imported', v.name)
--                     end
--                 end)
--             end
--         end
--     end)
-- end)

LSCore.Functions.CreateCallback('ls-housing:server:has:house:key', function(source, cb, HouseId)
	local src = source
	local Player = LSCore.Functions.GetPlayer(src)
	local retval = false
	if Player ~= nil then 
        if Config.Houses[HouseId] ~= nil then
            if Config.Houses[HouseId]['Key-Holders'] ~= nil then
                for key, housekey in pairs(Config.Houses[HouseId]['Key-Holders']) do
                    if housekey == Player.PlayerData.citizenid then
                        cb(true)
                    end
                end
            end
        end
    end
	cb(false)
end)

LSCore.Functions.CreateCallback('ls-housing:server:get:decorations', function(source, cb, house)
	local retval = nil
	LSCore.Functions.ExecuteSql(false, "SELECT * FROM `player_houses` WHERE `house` = '"..house.."'", function(result)
		if result[1] ~= nil then
			if result[1].decorations ~= nil then
				retval = json.decode(result[1].decorations)
			end
		end
		cb(retval)
	end)
end)

LSCore.Functions.CreateCallback('ls-housing:server:get:locations', function(source, cb, HouseId)
	local retval = nil
	LSCore.Functions.ExecuteSql(false, "SELECT * FROM `player_houses` WHERE `house` = '"..HouseId.."'", function(result)
		if result[1] ~= nil then
			retval = result[1]
		end
		cb(retval)
	end)
end)

LSCore.Functions.CreateCallback('ls-housing:server:TransferCid', function(source, cb, NewCid, HouseName)
    local Return = nil
    LSCore.Functions.ExecuteSql(false, "SELECT * FROM `players` WHERE `citizenid` = '"..NewCid.."'", function(result)
        if result[1] ~= nil then
            local src = source
            local Player = LSCore.Functions.GetPlayer(src)
            Config.Houses[HouseName]['Owner'] = NewCid
            Config.Houses[HouseName]['Key-Holders'] = {
                [1] = NewCid
            }
            Return = true
			LSCore.Functions.ExecuteSql(false, "UPDATE `player_houses` SET citizenid='"..NewCid.."', keyholders = '[\""..NewCid.."\"]' WHERE `house` = '"..HouseName.."'")
		else
            Return = false
        end
	end)
    Citizen.SetTimeout(120, function()
        cb(Return)
    end)
end)

RegisterServerEvent('ls-housing:server:buy:house')
AddEventHandler('ls-housing:server:buy:house', function(HouseId)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    local HousePrice = math.ceil(Config.Houses[HouseId]['Price'] * 1.21)
    if Player.PlayerData.money['bank'] >= HousePrice then
      LSCore.Functions.ExecuteSql(true, "UPDATE `player_houses` SET citizenid='"..Player.PlayerData.citizenid.."', owned='true', keyholders = '[\""..Player.PlayerData.citizenid.."\"]' WHERE `house` = '"..HouseId.."'")
      Player.Functions.RemoveMoney('bank', HousePrice, "Bought House")
      Config.Houses[HouseId]['Key-Holders'] = {
          [1] = Player.PlayerData.citizenid
      }
      Config.Houses[HouseId]['Owned'] = true
      Config.Houses[HouseId]['Owner'] = Player.PlayerData.citizenid
      TriggerClientEvent('LSCore:Notify', src, "Je hebt een huis gekocht: "..Config.Houses[HouseId]['Adres'], 'success', 8500)
      TriggerClientEvent('ls-housing:client:set:owned', -1, HouseId, true, Player.PlayerData.citizenid)
      TriggerEvent("ls-logs:server:SendLog", "realestate", "Huis gekocht", nil, "(citizenid: *" .. Player.PlayerData.citizenid .. "* | name: " .. Player.PlayerData.name .. " | id: *(" .. src .. ")* Heef **" .. HouseId .. "** gekocht voor " .. HousePrice .. ". Met karakter: **" .. Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname .. "**")
    else
      TriggerClientEvent('LSCore:Notify', src, "Je hebt niet genoeg geld op de bank..", 'error', 8500)
    end
end)

RegisterServerEvent('ls-housing:server:add:new:house')
AddEventHandler('ls-housing:server:add:new:house', function(StreetName, CoordsTable, Price, Tier)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    local Price, Tier = tonumber(Price), tonumber(Tier)
    local Street = StreetName:gsub("%'", "")
    local HouseNumber = GetFreeHouseNumber()
    local Name, Label = Street:lower()..tostring(HouseNumber), Street..' '..tostring(HouseNumber)
    LSCore.Functions.ExecuteSql(true, "INSERT INTO `player_houses` (`house`, `label`, `price`, `tier`, `owned`, `coords`, `keyholders`) VALUES ('"..Name.."', '"..Label.."', "..Price..", "..Tier..", 'false', '"..json.encode(CoordsTable).."', '{}')")
    Config.Houses[Name] = {
        ['DBName'] = Name,
        ['Coords'] = CoordsTable,
        ['Owned'] = false,
        ['Owner'] = nil,
        ['Tier'] = Tier,
        ['Price'] = Price,
        ['Door-Lock'] = true,
        ['Adres'] = Label,
        ['Garage'] = nil,
        ['Key-Holders'] = {},
        ['Decorations'] = {}
    }
    TriggerClientEvent('ls-housing:client:sync:config', -1, Name, Config.Houses[Name])
    TriggerClientEvent('LSCore:Notify', src, "Je hebt een huis toegevoegd: "..Label, 'info', 8500)
    TriggerEvent("ls-logs:server:SendLog", "realestate", "Huis aangemaakt", nil, "(citizenid: *" .. Player.PlayerData.citizenid .. "* | name: " .. Player.PlayerData.name .. " | id: *(" .. src .. ")* Heef **" .. Name .. "** aangemaakt voor het bedrag " .. Price .. " Met de tier " .. Tier .. ". Met karakter: **" .. Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname .. "**")
end)

RegisterServerEvent('ls-housing:server:view:house')
AddEventHandler('ls-housing:server:view:house', function(HouseId)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src) 
    local houseprice = Config.Houses[HouseId]['Price']
    local brokerfee = (houseprice / 100 * 5)
    local bankfee = (houseprice / 100 * 10) 
    local taxes = (houseprice / 100 * 6) 
    TriggerClientEvent('ls-housing:client:view:house', src, houseprice, brokerfee, bankfee, taxes, Player.PlayerData.charinfo.firstname, Player.PlayerData.charinfo.lastname)
end)

RegisterServerEvent('ls-housing:server:add:garage')
AddEventHandler('ls-housing:server:add:garage', function(HouseId, HouseName, Coords)
	local src = source
    local Player = LSCore.Functions.GetPlayer(src)
	LSCore.Functions.ExecuteSql(false, "UPDATE `player_houses` SET `garage` = '"..json.encode(Coords).."', `hasgarage` = 'true' WHERE `house` = '"..HouseId.."'")
    Config.Houses[HouseId]['Garage'] = Coords
    Config.Houses[HouseId]['HasGarage'] = true
    TriggerClientEvent('ls-housing:client:sync:config', -1, HouseId, Config.Houses[HouseId])
	TriggerClientEvent('LSCore:Notify', src, "Je hebt een garage toegevoegd bij: "..HouseName)
    TriggerEvent("ls-logs:server:SendLog", "realestate", "Huis garage aangemaakt", nil, "(citizenid: *" .. Player.PlayerData.citizenid .. "* | name: " .. Player.PlayerData.name .. " | id: *(" .. src .. ")* Heef bij **" .. HouseId .. "** een garage aangemaakt. Met karakter: **" .. Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname .. "**")
end)

RegisterServerEvent('ls-housing:server:save:decorations')
AddEventHandler('ls-housing:server:save:decorations', function(house, decorations)
    LSCore.Functions.ExecuteSql(false, "UPDATE `player_houses` SET `decorations` = '"..json.encode(decorations).."' WHERE `house` = '"..house.."'")
    TriggerClientEvent("ls-housing:server:sethousedecorations", -1, house, decorations)
end)

RegisterServerEvent('ls-housing:server:give:keys')
AddEventHandler('ls-housing:server:give:keys', function(HouseId, Target)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    local TargetPlayer = LSCore.Functions.GetPlayer(Target)
    if TargetPlayer ~= nil then
        TriggerClientEvent('LSCore:Notify', TargetPlayer.PlayerData.source, "Je hebt huis sleutels ontvangen: "..Config.Houses[HouseId]['Adres'], 'success', 8500)
        table.insert(Config.Houses[HouseId]['Key-Holders'], TargetPlayer.PlayerData.citizenid)
        LSCore.Functions.ExecuteSql(false, "UPDATE `player_houses` SET `keyholders` = '"..json.encode(Config.Houses[HouseId]['Key-Holders']).."' WHERE `house` = '"..HouseId.."'")
    end
end)

RegisterServerEvent('ls-housing:server:logout')
AddEventHandler('ls-housing:server:logout', function()
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    local PlayerItems = Player.PlayerData.inventory
    TriggerClientEvent('ls-radio:onRadioDrop', src)
    if PlayerItems ~= nil then
       LSCore.Functions.ExecuteSql(true, "UPDATE `players` SET `inventory` = '"..LSCore.EscapeSqli(json.encode(PlayerItems)).."' WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'")
    else
       LSCore.Functions.ExecuteSql(true, "UPDATE `players` SET `inventory` = '{}' WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'")
    end
    LSCore.Player.Logout(src)
    Citizen.Wait(450)
    TriggerClientEvent('ls-multichar:client:open:select', src)
end)

RegisterServerEvent('ls-housing:server:set:location')
AddEventHandler('ls-housing:server:set:location', function(HouseId, CoordsTable, Type)
    local src = source
	local Player = LSCore.Functions.GetPlayer(src)
	if Type == 'stash' then
		LSCore.Functions.ExecuteSql(true, "UPDATE `player_houses` SET `stash` = '"..json.encode(CoordsTable).."' WHERE `house` = '"..HouseId.."'")
	elseif Type == 'clothes' then
		LSCore.Functions.ExecuteSql(true, "UPDATE `player_houses` SET `outfit` = '"..json.encode(CoordsTable).."' WHERE `house` = '"..HouseId.."'")
	elseif Type == 'logout' then
		LSCore.Functions.ExecuteSql(true, "UPDATE `player_houses` SET `logout` = '"..json.encode(CoordsTable).."' WHERE `house` = '"..HouseId.."'")
	end
	TriggerClientEvent('ls-housing:client:refresh:location', -1, HouseId, CoordsTable, Type)
end)

RegisterServerEvent('ls-housing:server:ring:door')
AddEventHandler('ls-housing:server:ring:door', function(HouseId)
    local src = source
    TriggerClientEvent('ls-housing:client:ringdoor', -1, src, HouseId)
end)

RegisterServerEvent('ls-housing:server:open:door')
AddEventHandler('ls-housing:server:open:door', function(Taget, HouseId)
    local OtherPlayer = LSCore.Functions.GetPlayer(Taget)
    if OtherPlayer ~= nil then
        TriggerClientEvent('ls-housing:client:set:in:house', OtherPlayer.PlayerData.source, HouseId)
    end
end)

RegisterServerEvent('ls-housing:server:remove:house:key')
AddEventHandler('ls-housing:server:remove:house:key', function(HouseId, CitizenId)
	local src = source
    local NewKeyHolders = {}
    if Config.Houses[HouseId]['Key-Holders'] ~= nil then
        for k, v in pairs(Config.Houses[HouseId]['Key-Holders']) do
            if Config.Houses[HouseId]['Key-Holders'][k] ~= CitizenId then
                table.insert(NewKeyHolders, Config.Houses[HouseId]['Key-Holders'][k])
            end
        end
    end
    Config.Houses[HouseId]['Key-Holders'] = NewKeyHolders
	TriggerClientEvent('ls-housing:client:set:new:key:holders', -1, HouseId, NewKeyHolders)
	TriggerClientEvent('LSCore:Notify', src, "Huis sleutels zijn verwijderd!", 'error', 3500)
	LSCore.Functions.ExecuteSql(false, "UPDATE `player_houses` SET `keyholders` = '"..json.encode(NewKeyHolders).."' WHERE `house` = '"..HouseId.."'")
end)

RegisterServerEvent('ls-housing:server:set:house:door')
AddEventHandler('ls-housing:server:set:house:door', function(HouseId, bool)
    Config.Houses[HouseId]['Door-Lock'] = bool
    TriggerClientEvent('ls-housing:client:set:house:door', -1, HouseId, bool)
end)

RegisterServerEvent('ls-housing:server:detlete:house')
AddEventHandler('ls-housing:server:detlete:house', function(HouseId)
    Config.Houses[HouseId] = {}
    LSCore.Functions.ExecuteSql(false, "DELETE FROM `player_houses` WHERE `house` = '"..HouseId.."'")
    TriggerClientEvent('LSCore:Notify', source, '['..HouseId.."] Huis is verwijderd.", 'error', 3500)
    TriggerClientEvent('ls-housing:client:sync:config', -1, HouseId, Config.Houses[HouseId])
end)

LSCore.Commands.Add("createhouse", "Maak een huis aan als makelaar", {{name="price", help="Prijs van het huis"}, {name="tier", help="Huizen: [1 / 2 / 3 / 4 / 5 / 6 / 7 / 8 / 9 / 10] Garages: [11 / 12 / 13] Winkel: [14] Kantoor: [15] WietOpslag: [16]"}}, true, function(source, args)
	local Player = LSCore.Functions.GetPlayer(source)
	local price = tonumber(args[1])
	local tier = tonumber(args[2])
	if Player.PlayerData.job.name == "realestate" then
        if tier <= 16 then
		    TriggerClientEvent("ls-housing:client:create:house", source, price, tier)
        else
            TriggerClientEvent('LSCore:Notify', source, "Deze tier bestaat niet..", "error")
        end
	end
end)

LSCore.Commands.Add("togglehouses", "Laat alle huis blips zien", {}, false, function(source, args)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.PlayerData.job.name == "realestate" then
		TriggerClientEvent("ls-housing:client:toggle:blips", source)
    end
end)

LSCore.Commands.Add("deletehouse", "Verwijder het huis waar je nu staat", {}, false, function(source, args)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.PlayerData.job.name == "realestate" then
		TriggerClientEvent("ls-housing:client:delete:house", source)
    else
        TriggerClientEvent('LSCore:Notify', source, "Je bent geen makelaar..", "error")
	end
end)

LSCore.Commands.Add("addgarage", "Garage toevoegen bij het huis waar ", {}, false, function(source, args)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.PlayerData.job.name == "realestate" then
		TriggerClientEvent("ls-housing:client:add:garage", source)
	end
end)

LSCore.Commands.Add("ring", "Aanbellen bij huis", {}, false, function(source, args)
    TriggerClientEvent('ls-housing:client:ring:door', source)
end)

LSCore.Commands.Add("setrealestate", "Neem een makelaar aan", {{name="id", help="Speler ID"}}, true, function(source, args)
    local Player = LSCore.Functions.GetPlayer(source)
    local TargetPlayer = LSCore.Functions.GetPlayer(tonumber(args[1]))
    if Player.PlayerData.metadata['ishighcommand'] and Player.PlayerData.job.name == 'realestate' then
        if TargetPlayer ~= nil then
            TriggerClientEvent('LSCore:Notify', TargetPlayer.PlayerData.source, 'Je bent aangenomen als makelaar! gefeliciteerd!', 'success')
            TriggerClientEvent('LSCore:Notify', Player.PlayerData.source, 'Je hebt '..TargetPlayer.PlayerData.charinfo.firstname..' '..TargetPlayer.PlayerData.charinfo.lastname..' aangenomen als makelaar!', 'success')
            TargetPlayer.Functions.SetJob('realestate')
        end
    end
end)

LSCore.Commands.Add("firerealestate", "Ontsla een makelaar", {{name="id", help="Speler ID"}}, true, function(source, args)
    local Player = LSCore.Functions.GetPlayer(source)
    local TargetPlayer = LSCore.Functions.GetPlayer(tonumber(args[1]))
    if Player.PlayerData.metadata['ishighcommand'] and Player.PlayerData.job.name == 'realestate' then
        if TargetPlayer ~= nil and TargetPlayer.PlayerData.job.name == 'realestate' then
            TriggerClientEvent('LSCore:Notify', TargetPlayer.PlayerData.source, 'Je bent ontslagen!', 'error')
            TriggerClientEvent('LSCore:Notify', Player.PlayerData.source, 'Je hebt '..TargetPlayer.PlayerData.charinfo.firstname..' '..TargetPlayer.PlayerData.charinfo.lastname..' ontslagen!', 'success')
            TargetPlayer.Functions.SetJob('unemployed')
        end
    end
end)

LSCore.Functions.CreateUseableItem("police_stormram", function(source, item)
	local Player = LSCore.Functions.GetPlayer(source)
	if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
		TriggerClientEvent("ls-housing:client:breaking:door", source)
	else
		TriggerClientEvent('LSCore:Notify', source, "Dit is alleen mogelijk voor hulpdiensten!", "error")
	end
end)

-- Functions \\ --

function GetFreeHouseNumber()
    return math.random(1111,9999)
end