local LSCore = exports['ls-core']:GetCoreObject()

-- Code

-- // Loops \\ --

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait((1000 * 60))
        TriggerEvent('ls-police:server:update:current:cops')
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        TriggerEvent("ls-police:server:update:blips")
        Citizen.Wait(60000)
    end
end)

-- // Events \\ --

RegisterServerEvent('ls-police:server:update:current:cops')
AddEventHandler('ls-police:server:update:current:cops', function()
    local PoliceAmount = 0
    for k, v in pairs(LSCore.Functions.GetPlayers()) do
        local Player = LSCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                PoliceAmount = PoliceAmount + 1
            end
        end
    end
    TriggerClientEvent("ls-police:SetCopCount", -1, PoliceAmount)
end)

RegisterServerEvent('ls-police:server:cuff:closest')
AddEventHandler('ls-police:server:cuff:closest', function(SeverId)
    local Player = LSCore.Functions.GetPlayer(source)
    local CuffedPlayer = LSCore.Functions.GetPlayer(SeverId)
    if CuffedPlayer ~= nil then
        TriggerClientEvent("ls-police:client:get:cuffed", CuffedPlayer.PlayerData.source)
        if not CuffedPlayer.PlayerData['metadata']['ishandcuffed'] then
            TriggerClientEvent("ls-police:client:get:cuffed:anim", CuffedPlayer.PlayerData.source, Player.PlayerData.source)
        end
    end
end)

RegisterServerEvent('ls-police:server:set:handcuff:status')
AddEventHandler('ls-police:server:set:handcuff:status', function(Cuffed)
	local Player = LSCore.Functions.GetPlayer(source)
	Player.Functions.SetMetaData("ishandcuffed", Cuffed)
end)

RegisterServerEvent('ls-police:server:search:player')
AddEventHandler('ls-police:server:search:player', function(PlayerId)
    local SearchedPlayer = LSCore.Functions.GetPlayer(PlayerId)
    if SearchedPlayer ~= nil then 
        TriggerClientEvent('chatMessage', source, "SYSTEM", "warning", "Persoon heeft €"..SearchedPlayer.PlayerData.money["cash"]..",- op zak..")
        TriggerClientEvent('LSCore:Notify', SearchedPlayer.PlayerData.source, "Je wordt gefouilleerd..")
    end
end)

RegisterServerEvent('ls-police:server:rob:player')
AddEventHandler('ls-police:server:rob:player', function(PlayerId)
    local Player = LSCore.Functions.GetPlayer(source)
    local SearchedPlayer = LSCore.Functions.GetPlayer(PlayerId)
    if SearchedPlayer ~= nil then 
        local TotalCash = SearchedPlayer.PlayerData.money["cash"]
        if Player.PlayerData.job.name == 'police' and Player.PlayerData.job.onduty then
            Player.Functions.AddItem('moneybag', 1, false, {worth = TotalCash}, true)
            SearchedPlayer.Functions.RemoveMoney("cash", TotalCash, "police-player-robbed")
            TriggerClientEvent('ls-inventory:client:close:inventory', source)
        else
            Player.Functions.AddMoney("cash", TotalCash, "police-player-robbed")
            SearchedPlayer.Functions.RemoveMoney("cash", TotalCash, "police-player-robbed")
            TriggerClientEvent('LSCore:Notify', SearchedPlayer.PlayerData.source, "Je bent van €"..TotalCash.." beroofd")
        end
    end
end)

RegisterServerEvent('ls-police:server:escort:closest')
AddEventHandler('ls-police:server:escort:closest', function(SeverId)
    local Player = LSCore.Functions.GetPlayer(source)
    local EscortPlayer = LSCore.Functions.GetPlayer(SeverId)
    if (EscortPlayer.PlayerData.metadata["ishandcuffed"] or EscortPlayer.PlayerData.metadata["isdead"]) then
        TriggerClientEvent("ls-police:client:get:escorted", EscortPlayer.PlayerData.source, Player.PlayerData.source)
    end
end)

RegisterServerEvent('ls-police:server:set:out:vehicle')
AddEventHandler('ls-police:server:set:out:vehicle', function(ServerId)
    local Player = LSCore.Functions.GetPlayer(source)
    local EscortPlayer = LSCore.Functions.GetPlayer(ServerId)
    if EscortPlayer.PlayerData.metadata["ishandcuffed"] or EscortPlayer.PlayerData.metadata["isdead"] then
        TriggerClientEvent("ls-police:client:set:out:veh", EscortPlayer.PlayerData.source)
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Persoon is niet dood of geboeid!")
    end
end)

RegisterServerEvent('ls-police:server:set:in:vehicle')
AddEventHandler('ls-police:server:set:in:vehicle', function(ServerId)
    local Player = LSCore.Functions.GetPlayer(source)
    local EscortPlayer = LSCore.Functions.GetPlayer(ServerId)
    if EscortPlayer.PlayerData.metadata["ishandcuffed"] or EscortPlayer.PlayerData.metadata["isdead"] then
        TriggerClientEvent("ls-police:client:set:in:veh", EscortPlayer.PlayerData.source)
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Persoon is niet dood of geboeid!")
    end
end)

RegisterServerEvent('ls-police:server:give:finger:scanner')
AddEventHandler('ls-police:server:give:finger:scanner', function(TargetPlayer)
    local TargetPlayer = LSCore.Functions.GetPlayer(tonumber(TargetPlayer))
    if TargetPlayer ~= nil then
        TriggerClientEvent('ls-police:client:give:finger:scanner', TargetPlayer.PlayerData.source)
    end
end)

RegisterServerEvent('ls-police:server:update:blips')
AddEventHandler('ls-police:server:update:blips', function()
    local src = source
    local DutyPlayers = {}
    for k, v in pairs(LSCore.Functions.GetPlayers()) do
        local Player = LSCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            local PortoItem = Player.Functions.GetItemByName('radio')
            if ((Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == "ambulance") and Player.PlayerData.job.onduty and PortoItem ~= nil) then
                table.insert(DutyPlayers, {['Source'] = Player.PlayerData.source, ['Label'] = Player.PlayerData.metadata["callsign"]..' | '..Player.PlayerData.charinfo.firstname..' '..Player.PlayerData.charinfo.lastname, ['Job'] = Player.PlayerData.job.name})
            end
        end
    end
    TriggerClientEvent("ls-police:client:update:blips", -1, DutyPlayers)
end)

RegisterServerEvent('ls-police:server:set:tracker')
AddEventHandler('ls-police:server:set:tracker', function(TargetId)
    local Target = LSCore.Functions.GetPlayer(TargetId)
    local TrackerMeta = Target.PlayerData.metadata["tracker"]
    if TrackerMeta then
        Target.Functions.SetMetaData("tracker", false)
        TriggerClientEvent('LSCore:Notify', TargetId, 'Je enkelband is afgedaan.', 'error', 5000)
        TriggerClientEvent('LSCore:Notify', source, 'Je hebt een enkelband afgedaan van '..Target.PlayerData.charinfo.firstname.." "..Target.PlayerData.charinfo.lastname, 'error', 5000)
        TriggerClientEvent('ls-police:client:set:tracker', TargetId, false)
    else
        Target.Functions.SetMetaData("tracker", true)
        TriggerClientEvent('LSCore:Notify', TargetId, 'Je hebt een enkelband omgekregen.', 'error', 5000)
        TriggerClientEvent('LSCore:Notify', source, 'Je hebt een enkelband omgedaan bij '..Target.PlayerData.charinfo.firstname.." "..Target.PlayerData.charinfo.lastname, 'error', 5000)
        TriggerClientEvent('ls-police:client:set:tracker', TargetId, true)
    end
end)

-- // Commands \\ --

LSCore.Commands.Add("cuff", "toggle handboeien (Admin)", {{name="ID", help="PlayerId"}}, true, function(source, args)
    local Player = LSCore.Functions.GetPlayer(source)
    if args ~= nil then
        local TargetPlayer = LSCore.Functions.GetPlayer(tonumber(args[1]))
        if TargetPlayer ~= nil then
          TriggerClientEvent("ls-police:client:get:cuffed", TargetPlayer.PlayerData.source, Player.PlayerData.source)
        end
    end
end, "admin")

LSCore.Commands.Add("sethighcommand", "Zet iemand zijn high command status", {{name="ID", help="PlayerId"}, {name="Status", help="True/False"}}, true, function(source, args)
    if args ~= nil then
        local TargetPlayer = LSCore.Functions.GetPlayer(tonumber(args[1]))
        if TargetPlayer ~= nil then
            if args[2]:lower() == 'true' then
                TargetPlayer.Functions.SetMetaData("ishighcommand", true)
                TriggerClientEvent('LSCore:Notify', TargetPlayer.PlayerData.source, 'Je bent nu een leiding gevende!', 'success')
                TriggerClientEvent('LSCore:Notify', source, 'Speler is nu een leiding gevende!', 'success')
            else
                TargetPlayer.Functions.SetMetaData("ishighcommand", false)
                TriggerClientEvent('LSCore:Notify', TargetPlayer.PlayerData.source, 'Je bent geen leiding gevende meer!', 'error')
                TriggerClientEvent('LSCore:Notify', source, 'Speler is GEEN leiding gevende meer!', 'error')
            end
        end
    end
end, "admin")

LSCore.Commands.Add("setpolice", "Neem neen agent aan", {{name="id", help="Speler ID"}}, true, function(source, args)
    local Player = LSCore.Functions.GetPlayer(source)
    local TargetPlayer = LSCore.Functions.GetPlayer(tonumber(args[1]))
    if Player.PlayerData.metadata['ishighcommand'] then
        if TargetPlayer ~= nil then
            TriggerClientEvent('LSCore:Notify', TargetPlayer.PlayerData.source, 'Je bent aangenomen als agent! gefeliciteerd!', 'success')
            TriggerClientEvent('LSCore:Notify', Player.PlayerData.source, 'Je hebt '..TargetPlayer.PlayerData.charinfo.firstname..' '..TargetPlayer.PlayerData.charinfo.lastname..' aangenomen als agent!', 'success')
            TargetPlayer.Functions.SetJob('police')
        end
    end
end)

LSCore.Commands.Add("createpass", "Maak een politie pas aan voor iemand", {{name="name", help="Naam"}, {name="function", help="Functie"}, {name="callsign", help="Dienstnummer"}, {name="photo", help="Foto (Url)"}}, true, function(source, args)
    local Name, Function, Callsign, Photo  = args[1], args[2], args[3], args[4]
    local Info = {name = Name, callsign = Callsign, photo = Photo, pfunction = Function}
    local Player = LSCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == 'police' and Player.PlayerData.metadata['ishighcommand'] then
        Player.Functions.AddItem('policepass', 1, false, Info, true)
    end
end)

LSCore.Commands.Add("firepolice", "Ontsla een agent", {{name="id", help="Speler ID"}}, true, function(source, args)
    local Player = LSCore.Functions.GetPlayer(source)
    local TargetPlayer = LSCore.Functions.GetPlayer(tonumber(args[1]))
    if Player.PlayerData.metadata['ishighcommand'] then
        if TargetPlayer ~= nil and TargetPlayer.PlayerData.job.name == 'police' then
            TriggerClientEvent('LSCore:Notify', TargetPlayer.PlayerData.source, 'Je bent ontslagen!', 'error')
            TriggerClientEvent('LSCore:Notify', Player.PlayerData.source, 'Je hebt '..TargetPlayer.PlayerData.charinfo.firstname..' '..TargetPlayer.PlayerData.charinfo.lastname..' ontslagen!', 'success')
            TargetPlayer.Functions.SetJob('unemployed')
        end
    end
end)

LSCore.Commands.Add("callsign", "Verander je dienstnummer", {{name="Nummer", help="Dienstnummer"}}, true, function(source, args)
    local Player = LSCore.Functions.GetPlayer(source)
    if args[1] ~= nil then
        if Player.PlayerData.job.name == 'police' or Player.PlayerData.job.name == 'ambulance' and Player.PlayerData.job.onduty then
         Player.Functions.SetMetaData("callsign", args[1])
         TriggerClientEvent('LSCore:Notify', source, 'Dienstnummer succesvol aangepast. U bent nu de: ' ..args[1], 'success')
        else
            TriggerClientEvent('LSCore:Notify', source, 'Dit is alleen voor hulp diensten..', 'error')
        end
    end
end)

LSCore.Commands.Add("setplate", "Verander je dienst kenteken", {{name="Nummer", help="Dienstnummer"}}, true, function(source, args)
    local Player = LSCore.Functions.GetPlayer(source)
    if args[1] ~= nil then
        if Player.PlayerData.job.name == 'police' or Player.PlayerData.job.name == 'ambulance' and Player.PlayerData.job.onduty then
            if args[1]:len() == 8 then
              Player.Functions.SetDutyPlate(args[1])
              TriggerClientEvent('LSCore:Notify', source, 'Kenteken succesvol aangepast. U dienst kenteken is nu: ' ..args[1], 'success')
            else
                TriggerClientEvent('LSCore:Notify', source, 'Het moet exact 8 karakters lang zijn..', 'error')
            end
        else
            TriggerClientEvent('LSCore:Notify', source, 'Dit is alleen voor hulp diensten..', 'error')
        end
    end
end)

LSCore.Commands.Add("kluis", "Open bewijs kluis", {{"bsn", "BSN Nummer"}}, true, function(source, args)
    local Player = LSCore.Functions.GetPlayer(source)
    if args[1] ~= nil then 
        if ((Player.PlayerData.job.name == "police") and Player.PlayerData.job.onduty) then
            TriggerClientEvent("ls-police:client:open:evidence", source, args[1])
        else
            TriggerClientEvent('LSCore:Notify', source, "Je moet een hulpdienst zijn hiervoor..", "error")
        end
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Je moet alle argumenten invoeren.")
    end
end)

LSCore.Commands.Add("setdutyvehicle", "Geef een werk voertuig aan een werknemer", {{name="Id", help="Werknemer Server ID"}, {name="Vehicle", help="Standaard / Audi / Heli / Motor / Unmarked"}, {name="state", help="True / False"}}, true, function(source, args)
    local SelfPlayerData = LSCore.Functions.GetPlayer(source)
    local TargetPlayerData = LSCore.Functions.GetPlayer(tonumber(args[1]))
    if TargetPlayerData ~= nil then
        if SelfPlayerData.PlayerData.metadata['ishighcommand'] and SelfPlayerData.PlayerData.job.name == 'police' then
            if args[3] == 'true' then
                TargetPlayerData.Functions.SetMetaDataTable("duty-vehicle", args[2]:upper(), true)
            else
                TargetPlayerData.Functions.SetMetaDataTable("duty-vehicle", args[2]:upper(), false)
            end
            local PlayerCredentials = TargetPlayerData.PlayerData.metadata['callsign']..' | '..TargetPlayerData.PlayerData.charinfo.firstname..' '..TargetPlayerData.PlayerData.charinfo.lastname
            TriggerClientEvent('ls-radialmenu:client:update:duty:vehicles', TargetPlayerData.PlayerData.source)
            if args[3] == 'true' then
                TriggerClientEvent('LSCore:Notify', TargetPlayerData.PlayerData.source, 'Je hebt een voertuig specialisatie ontvangen ('..args[2]:upper()..')', 'success')
                TriggerClientEvent('LSCore:Notify', SelfPlayerData.PlayerData.source, 'Je hebt succesvol de voertuig specialisatie ('..args[2]:upper()..') gegeven aan '..PlayerCredentials, 'success')
            else
                TriggerClientEvent('LSCore:Notify', TargetPlayerData.PlayerData.source, 'Je ('..args[2]:upper()..') specialisatie is afgenomen nerd..', 'error')
                TriggerClientEvent('LSCore:Notify', SelfPlayerData.PlayerData.source, 'Je hebt succesvol de voertuig specialisatie ('..args[2]:upper()..') afgenomen van '..PlayerCredentials, 'error')
            end
        end
    end
end)

LSCore.Commands.Add("bill", "Factuur uitschrijven", {{name="id", help="Speler ID"},{name="geld", help="Hoeveel"}}, true, function(source, args)
    local Player = LSCore.Functions.GetPlayer(source)
    local TargetPlayer = LSCore.Functions.GetPlayer(tonumber(args[1]))
    local Amount = tonumber(args[2])
    if TargetPlayer ~= nil then
        if Player.PlayerData.job.name == "police" then
            if Amount > 0 then
                if TargetPlayer.Functions.RemoveMoney('bank', Amount) then
                    TriggerClientEvent('LSCore:Notify', source, TargetPlayer.PlayerData.charinfo.firstname..' '..TargetPlayer.PlayerData.charinfo.lastname..' heeft een boete ontvangen van €'..Amount..',-', "success")
                    TriggerClientEvent('LSCore:Notify', TargetPlayer.PlayerData.source, 'Je ontving een boete van €'..Amount..',-', "error")
                    TriggerEvent('ls-banking:server:set:business:accounts', 'Add', Amount, 'POLITIE', 'Boete betaling.', TargetPlayer.PlayerData.source)
                end
            else
                TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Het bedrag moet hoger zijn dan 0")
            end
        else
            TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Dit command is voor hulpdiensten!")
        end
    end
end)

LSCore.Commands.Add("paylaw", "Betaal een advocaat", {{name="id", help="ID van een speler"}, {name="amount", help="Hoeveel?"}}, true, function(source, args)
	local Player = LSCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == "judge" then
        local playerId = tonumber(args[1])
        local Amount = tonumber(args[2])
        local OtherPlayer = LSCore.Functions.GetPlayer(playerId)
        if OtherPlayer ~= nil then
            if OtherPlayer.PlayerData.job.name == "lawyer" then
                OtherPlayer.Functions.AddMoney("bank", Amount, "police-lawyer-paid")
                TriggerClientEvent('chatMessage', OtherPlayer.PlayerData.source, "SYSTEM", "warning", "Je hebt €"..Amount..",- ontvangen voor je gegeven diensten!")
                TriggerClientEvent('LSCore:Notify', source, 'Je hebt een advocaat betaald')
            else
                TriggerClientEvent('LSCore:Notify', source, 'Persoon is geen advocaat', "error")
            end
        end
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Dit command is voor hulpdiensten!")
    end
end)

LSCore.Commands.Add("enkelbandlocatie", "Haal locatie van persoon met enkelband", {{name="bsn", help="BSN van de burger"}}, true, function(source, args)
    local Player = LSCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        if args[1] ~= nil then
            local citizenid = args[1]
            local Target = LSCore.Functions.GetPlayerByCitizenId(citizenid)
            local Tracking = false
            if Target ~= nil then
                if Target.PlayerData.metadata["tracker"] and not Tracking then
                    Tracking = true
                    TriggerClientEvent("ls-police:client:send:tracker:location", Target.PlayerData.source, Target.PlayerData.source)
                else
                    TriggerClientEvent('LSCore:Notify', source, 'Deze persoon heeft geen enkelband.', 'error')
                end
            end
        end
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Dit command is voor hulpdiensten!")
    end
end)

LSCore.Commands.Add("112", "Stuur een melding naar hulpdiensten", {{name="bericht", help="Bericht die je wilt sturen naar de hulpdiensten"}}, true, function(source, args)
    local Message = table.concat(args, " ")
    local Player = LSCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemByName("phone") ~= nil then
        TriggerClientEvent('ls-police:client:send:alert', source, Message, false)
        TriggerEvent("ls-logs:server:SendLog", "112", "112 Melding", "blue", "**"..GetPlayerName(source).."** (CitizenID: "..Player.PlayerData.citizenid.." | ID: "..source..") **Melding:** " ..Message, false)
    else
        TriggerClientEvent('LSCore:Notify', source, 'Je hebt geen telefoon..', 'error')
    end
end)

LSCore.Commands.Add("112a", "Stuur een anonieme melding naar hulpdiensten (geeft geen locatie)", {{name="bericht", help="Bericht die je wilt sturen naar de hulpdiensten"}}, true, function(source, args)
    local Message = table.concat(args, " ")
    local Player = LSCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemByName("phone") ~= nil then
        TriggerClientEvent("ls-police:client:call:anim", source)
        TriggerClientEvent('ls-police:client:send:alert', -1, Message, true)
        TriggerEvent("ls-logs:server:SendLog", "112", "112a Melding", "blue", "**"..GetPlayerName(source).."** (CitizenID: "..Player.PlayerData.citizenid.." | ID: "..source..") **Melding:** " ..Message, false)
    else
        TriggerClientEvent('LSCore:Notify', source, 'Je hebt geen telefoon..', 'error')
    end
end)

-- // Callbacks \\ --

LSCore.Functions.CreateCallback('ls-police:server:get:config', function(source, cb)
    cb(Config)
end)

LSCore.Functions.CreateCallback('ls-police:server:is:player:dead', function(source, cb, PlayerId)
    local Player = LSCore.Functions.GetPlayer(PlayerId)
    cb(Player.PlayerData.metadata["isdead"])
end)

-- // Alerts \\ --

RegisterServerEvent('ls-police:server:send:tracker:location')
AddEventHandler('ls-police:server:send:tracker:location', function(Coords, RequestId)
    local Target = LSCore.Functions.GetPlayer(RequestId)
    TriggerClientEvent('ls-police:client:send:tracker:alert', -1, Coords, Target.PlayerData.charinfo.firstname.." "..Target.PlayerData.charinfo.lastname)
end)

RegisterServerEvent('ls-police:server:send:alert:officer:down')
AddEventHandler('ls-police:server:send:alert:officer:down', function(Coords, StreetName, Info, Priority)
   TriggerClientEvent('ls-police:client:send:officer:down', -1, Coords, StreetName, Info, Priority)
end)

RegisterServerEvent('ls-police:server:send:alert:panic:button')
AddEventHandler('ls-police:server:send:alert:panic:button', function(Coords, StreetName, Info)
    TriggerClientEvent('ls-police:client:send:alert:panic:button', -1, Coords, StreetName, Info)
end)

RegisterServerEvent('ls-police:server:send:alert:gunshots')
AddEventHandler('ls-police:server:send:alert:gunshots', function(Coords, GunType, StreetName, InVeh)
   TriggerClientEvent("ls-phone-new:client:send:recent:alert:meos", -1, Data)
   TriggerClientEvent('ls-police:client:send:alert:gunshots', -1, Coords, GunType, StreetName, InVeh)
end)

RegisterServerEvent('ls-police:server:send:alert:dead')
AddEventHandler('ls-police:server:send:alert:dead', function(Coords, StreetName)
   TriggerClientEvent('ls-police:client:send:alert:dead', -1, Coords, StreetName)
end)

RegisterServerEvent('ls-police:server:send:bank:alert')
AddEventHandler('ls-police:server:send:bank:alert', function(Coords, StreetName, Name)
   TriggerClientEvent('ls-police:client:send:bank:alert', -1, Coords, StreetName, Name)
end)

RegisterServerEvent('ls-police:server:send:alert:jewellery')
AddEventHandler('ls-police:server:send:alert:jewellery', function(Coords, StreetName)
   TriggerClientEvent('ls-police:client:send:alert:jewellery', -1, Coords, StreetName)
end)

RegisterServerEvent('ls-police:server:send:alert:store')
AddEventHandler('ls-police:server:send:alert:store', function(Coords, StreetName, StoreNumber)
   TriggerClientEvent('ls-police:client:send:alert:store', -1, Coords, StreetName, StoreNumber)
end)

RegisterServerEvent('ls-police:server:send:house:alert')
AddEventHandler('ls-police:server:send:house:alert', function(Coords, StreetName)
   TriggerClientEvent('ls-police:client:send:house:alert', -1, Coords, StreetName)
end)

RegisterServerEvent('ls-police:server:send:banktruck:alert')
AddEventHandler('ls-police:server:send:banktruck:alert', function(Coords, Plate, StreetName)
   TriggerClientEvent('ls-police:client:send:banktruck:alert', -1, Coords, Plate, StreetName)
end)

RegisterServerEvent('ls-police:server:alert:explosion')
AddEventHandler('ls-police:server:alert:explosion', function(Coords, StreetName)
   TriggerClientEvent('ls-police:client:send:explosion:alert', -1, Coords, StreetName)
end)

RegisterServerEvent('ls-police:server:alert:cornerselling')
AddEventHandler('ls-police:server:alert:cornerselling', function(Coords, StreetName)
   TriggerClientEvent('ls-police:client:send:cornerselling:alert', -1, Coords, StreetName)
end)

RegisterServerEvent('ls-police:server:alert:humanelabs')
AddEventHandler('ls-police:server:alert:humanelabs', function(Coords, StreetName)
   TriggerClientEvent('ls-police:client:send:humanelabs:alert', -1, Coords, StreetName)
end)

RegisterServerEvent('ls-police:server:send:bobcat:alert')
AddEventHandler('ls-police:server:send:bobcat:alert', function(Coords, StreetName)
   TriggerClientEvent('ls-police:client:send:bobcat:alert', -1, Coords, StreetName)
end)

RegisterServerEvent('ls-police:server:alert:illegal:hunting')
AddEventHandler('ls-police:server:alert:illegal:hunting', function(Coords)
   TriggerClientEvent('ls-police:client:send:illegal:hunting:alert', -1, Coords)
end)

RegisterServerEvent('ls-police:server:send:oxy:alert')
AddEventHandler('ls-police:server:send:oxy:alert', function(Coords, Street)
   TriggerClientEvent('ls-police:client:send:oxy:alert', -1, Coords, Street)
end)

RegisterServerEvent('ls-police:server:alert:prison')
AddEventHandler('ls-police:server:alert:prison', function(Coords)
   TriggerClientEvent('ls-police:client:send:prison:alert', -1, Coords)
end)

RegisterServerEvent('ls-police:server:send:call:alert')
AddEventHandler('ls-police:server:send:call:alert', function(Coords, Message)
    local Player = LSCore.Functions.GetPlayer(source)
    local Name = Player.PlayerData.charinfo.firstname..' '..Player.PlayerData.charinfo.lastname
    TriggerClientEvent('ls-police:client:send:call:alert', -1, Coords, Name, Message)
end)

-- // Evidence \\ --

RegisterServerEvent('ls-police:server:create:bullet')
AddEventHandler('ls-police:server:create:bullet', function(Weapon, Coords)
    local Player = LSCore.Functions.GetPlayer(source)
    local CasingId = CreateRandomId()
    local WeaponInfo = exports['ls-weapons']:GetWeaponList(Weapon)
    local SerialNumber = nil
    if WeaponInfo ~= nil then 
        local WeaponItem = Player.Functions.GetItemByName(WeaponInfo["IdName"])
        if WeaponItem ~= nil then
            if WeaponItem.info ~= nil and WeaponItem.info ~= "" then 
                SerialNumber = WeaponItem.info.serie
            else
                SerialNumber = 'Onbekend'
            end
        end
    end
    local InsertData = {['Type'] = 'Bullet', ['Id'] = CasingId, ['Weapon'] = Weapon, ['Coords'] = Coords, ['Serial'] = SerialNumber}
    Config.Evidence[CasingId] = InsertData
    TriggerClientEvent("ls-police:client:sync:evidence", -1, CasingId, Config.Evidence[CasingId])
end)

RegisterServerEvent('ls-police:server:create:evidence')
AddEventHandler('ls-police:server:create:evidence', function(Type, Coords)
    local Player = LSCore.Functions.GetPlayer(source)
    local RandomId = CreateRandomId()
    local Desc, EvidenceType = {}, ''
    if Type == 'Blood' then
        Desc = Player.PlayerData.metadata["bloodtype"]
        EvidenceType = 'Blood'
    elseif Type == 'Finger' then
        Desc = Player.PlayerData.metadata["fingerprint"]
        EvidenceType = 'Finger'
    elseif Type == 'Hair' then
        Desc = Player.PlayerData.metadata["haircode"]
        EvidenceType = 'Hair'
    elseif Type == 'Slime' then
        Desc = Player.PlayerData.metadata["slimecode"]
        EvidenceType = 'Slime'
    end
    local InsertData = {['Type'] = EvidenceType, ['Id'] = RandomId, ['Coords'] = Coords, ['Desc'] = Desc}
    Config.Evidence[RandomId] = InsertData
    TriggerClientEvent("ls-police:client:sync:evidence", -1, RandomId, Config.Evidence[RandomId])
end)

RegisterServerEvent('ls-police:server:add:evidence')
AddEventHandler('ls-police:server:add:evidence', function(EvidenceNumber, Data, Street)
    local Player = LSCore.Functions.GetPlayer(source)
    local Info = {}
    if Data['Type'] == 'Blood' then
        Info = {label = "Bloed Monster", type = "blood", street = Street, bloodtype = Data['Desc']}
    elseif Data['Type'] == 'Finger' then
        Info = {label = "Vingerafdruk", type = "fingerprint", street = Street, fingerid = Data['Desc']}
    elseif Data['Type'] == 'Slime' then
        Info = {label = "Slijm Monster", type = "slime", street = Street, slimeid = Data['Desc']}
    elseif Data['Type'] == 'Hair' then
        Info = {label= "Haar Pluk", type = "hair", street = Street, hairid = Data['Desc']}
    elseif Data['Type'] == 'Bullet' then
        Info = {label = "Kogelhuls", type = "casing", street = Street, ammo = Data['Ammo'], ammotype = Data['Weapon'], serie = Data['Serial']}
    end	
    if Player.Functions.RemoveItem("empty_evidence_bag", 1, false, true) then
        if Player.Functions.AddItem("filled_evidence_bag", 1, false, Info, true) then
            Config.Evidence[EvidenceNumber] = {}
            TriggerClientEvent("ls-police:client:sync:evidence", -1, EvidenceNumber, Config.Evidence[EvidenceNumber])
        end
    else
       TriggerClientEvent('LSCore:Notify', source, "Je moet een leeg bewijszakje bij je hebben", "error")
    end
end)

RegisterServerEvent('ls-police:server:toggle:disco:mode')
AddEventHandler('ls-police:server:toggle:disco:mode', function(Bool)
    TriggerClientEvent('ls-police:client:toggle:disco:mode', -1, Bool)
end)

-- // Functions \\ --

function CreateRandomId()
    return math.random(11111,99999)
end