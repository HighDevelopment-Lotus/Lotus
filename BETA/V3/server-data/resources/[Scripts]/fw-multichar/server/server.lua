local LSCore = exports['fw-base']:GetCoreObject()

-- Code

LSCore.Functions.CreateCallback("framework-multichar:server:get:char:data", function(source, cb)
    local src = source
    local CharactersTable = {}
    LSCore.Functions.ExecuteSql(false, "SELECT * FROM players WHERE `steam` = '"..GetPlayerIdentifiers(src)[1].."'", function(result)
        for k, v in pairs(result) do
            local TempTable = {}
            local CharInfo = json.decode(v.charinfo)
            local MoneyInfo = json.decode(v.money)
            local Job = json.decode(v.job)
            local MetaData = json.decode(v.metadata)
            TempTable['Photo'] = MetaData['phone']['WhatsappPicture']
            TempTable['Name'] = CharInfo.firstname..' '..CharInfo.lastname
            TempTable['Date'] = CharInfo.birthdate
            TempTable['JobName'] = Job.label
            TempTable['JobFunctie'] = Job.gradelabel
            TempTable['CitizenId'] = v.citizenid
            TempTable['Bank'] = MoneyInfo.bank
            TempTable['Cid'] = v.cid
            LSCore.Functions.ExecuteSql(true, "SELECT * FROM `player_skins` WHERE `citizenid` = '"..v.citizenid.."'", function(modelresult)
                if modelresult[1] ~= nil then
                    TempTable['Skin'] = json.decode(modelresult[1].skin)
                    TempTable['Model'] = tonumber(modelresult[1].model)
                else
                    TempTable['Skin'] = nil
                    TempTable['Model'] = nil
                end
            end)
            table.insert(CharactersTable, TempTable)
        end
        cb(CharactersTable)
    end)
end)

LSCore.Commands.Add("logout", "Ga naar het karakter menu.", {}, false, function(source, args)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    TriggerClientEvent('framework-radio:onRadioDrop', src)
    LSCore.Player.Logout(src)
    Citizen.Wait(550)
    TriggerClientEvent('framework-multichar:client:open:select', src)
end, "admin")

RegisterServerEvent('framework-multichar:server:select:char')
AddEventHandler('framework-multichar:server:select:char', function(CitizenId)
    local src = source
    if LSCore.Player.Login(src, false, CitizenId) then
        local Player = LSCore.Functions.GetPlayer(src)
        while Player == nil do
            Player = LSCore.Functions.GetPlayer(src)
            Citizen.Wait(100)
        end
        TriggerClientEvent('framework-spawn:client:choose:spawn', src, Player.PlayerData)
        TriggerEvent("framework-logs:server:SendLog", "joinleave", "Loaded", "green", "**".. GetPlayerName(src) .. "** ("..CitizenId.." | "..src..") loaded..")
	end
end)

RegisterServerEvent('framework-multichar:server:create:new:char')
AddEventHandler('framework-multichar:server:create:new:char', function(NewCharData)
    local src = source
    local newData = {firstname = NewCharData.Firstname, lastname = NewCharData.Lastname, birthdate = NewCharData.Birthdate, nationality = 'Los Santos', gender = NewCharData.Gender, cid = NewCharData.Slot}
    if LSCore.Player.Login(src, true, false, newData) then
        LSCore.Commands.Refresh(src)
        GiveStarterItems(src)
        TriggerClientEvent('framework-spawn:client:choose:appartment', src)
        TriggerEvent("framework-logs:server:SendLog", "joinleave", "Character Creation", "green", "**".. GetPlayerName(src) .. "** ("..src..") Created their character..")
	end
end)

RegisterServerEvent('framework-multichar:server:delete:char')
AddEventHandler('framework-multichar:server:delete:char', function(CitizenId)
    LSCore.Player.DeleteCharacter(source, CitizenId)
end)

function GiveStarterItems(source)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    for k, v in pairs(LSCore.Shared.StarterItems) do
        local Info = {}
		if v.item == 'id_card' then
            Info.citizenid = Player.PlayerData.citizenid
            Info.firstname = Player.PlayerData.charinfo.firstname
            Info.lastname = Player.PlayerData.charinfo.lastname
            Info.birthdate = Player.PlayerData.charinfo.birthdate
            Info.gender = Player.PlayerData.charinfo.gender
            Info.nationality = Player.PlayerData.charinfo.nationality
		elseif v.item == 'driver_license' then
            Info.firstname = Player.PlayerData.charinfo.firstname
            Info.lastname = Player.PlayerData.charinfo.lastname
            Info.birthdate = Player.PlayerData.charinfo.birthdate
            Info.type = "A1-A2-A | AM-B | C1-C-CE"
        else
            Info = ""
        end
        Player.Functions.AddItem(v.item, v.amount, false, Info, true)
    end
end