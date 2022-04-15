local LSCore, SmeltingData, Smelting, TotalGoldBar = exports['fw-base']:GetCoreObject(), {}, false, 0

-- Code

LSCore.Functions.CreateCallback("framework-pawnshop:server:is:smelting", function(source, cb)
    cb(Smelting)
end)

-- // Loops \\ --

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait((1000 * 60))
        TriggerEvent('framework-police:server:update:current:cops')
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        TriggerEvent("framework-police:server:update:blips")
        Citizen.Wait(60000)
    end
end)

-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(4)
--         local CurrentHour = exports['fw-weathersync']:GetCurrentTime()
--         if CurrentHour >= 8 and CurrentHour <= 12 then
--             if Config.DoorsLocked then
--                 Config.DoorsLocked = false
--                 TriggerEvent('framework-doors:server:set:door:locks', 54, 0)
--                 TriggerEvent('framework-doors:server:set:door:locks', 55, 0)
--                 TriggerEvent('framework-doors:server:set:door:locks', 56, 0)
--             end
--         else
--             if not Config.DoorsLocked then
--                 Config.DoorsLocked = true
--                 TriggerEvent('framework-doors:server:set:door:locks', 54, 4)
--                 TriggerEvent('framework-doors:server:set:door:locks', 55, 4)
--                 TriggerEvent('framework-doors:server:set:door:locks', 56, 4)
--             end
--         end
--     end
-- end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        LSCore.Functions.ExecuteSql(true, "SELECT * FROM `players`", function(result)
            if result ~= nil and result[1] ~= nil then
                for k, v in pairs(result) do
                    local Player = LSCore.Functions.GetPlayerByCitizenId(v.citizenid)
                    if Player ~= nil then
                        local JailTime = Player.PlayerData.metadata['jailtime']
                        if JailTime > 0 then
                            if JailTime - 1 > 0 then
                                JailTime = JailTime - 1
                            else
                                JailTime = 0
                            end
                            --print(v.citizenid, JailTime, 'Online')
                            TriggerClientEvent('framework-prison::client:set:time', Player.PlayerData.source, JailTime)
                            Player.Functions.SetMetaData("jailtime", JailTime)
                            Player.Functions.Save()
                        end
                    else
                        local MetaData = json.decode(v.metadata)
                        if MetaData ~= nil and MetaData['jailtime'] ~= nil and MetaData['jailtime'] > 1 then
                            if MetaData['jailtime'] - 1 > 1 then
                                MetaData['jailtime'] = MetaData['jailtime'] - 1
                            else
                                MetaData['jailtime'] = 1
                            end
                            --print(v.citizenid, MetaData['jailtime'], 'Offline')
                            LSCore.Functions.ExecuteSql(false, "UPDATE `players` SET `metadata` = '"..json.encode(MetaData).."' WHERE `citizenid` = '"..v.citizenid.."'")
                        end
                    end
                end
            end
        end)
        Citizen.Wait(1000 * 60)
    end
end)

-- // Events \\ --

RegisterServerEvent('framework-police:server:update:current:cops')
AddEventHandler('framework-police:server:update:current:cops', function()
    local PoliceAmount = 0
    for k, v in pairs(LSCore.Functions.GetPlayers()) do
        local Player = LSCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                PoliceAmount = PoliceAmount + 1
            end
        end
    end
    TriggerClientEvent("framework-police:SetCopCount", -1, PoliceAmount)
end)

RegisterServerEvent('framework-police:server:cuff:closest')
AddEventHandler('framework-police:server:cuff:closest', function(SeverId)
    local Player = LSCore.Functions.GetPlayer(source)
    local CuffedPlayer = LSCore.Functions.GetPlayer(SeverId)
    if CuffedPlayer ~= nil then
        TriggerClientEvent("framework-police:client:get:cuffed", CuffedPlayer.PlayerData.source)
        if not CuffedPlayer.PlayerData['metadata']['ishandcuffed'] then
            TriggerClientEvent("framework-police:client:get:cuffed:anim", CuffedPlayer.PlayerData.source, Player.PlayerData.source)
        end
    end
end)

RegisterServerEvent('framework-police:server:set:handcuff:status')
AddEventHandler('framework-police:server:set:handcuff:status', function(Cuffed)
	local Player = LSCore.Functions.GetPlayer(source)
	Player.Functions.SetMetaData("ishandcuffed", Cuffed)
end)

RegisterServerEvent('framework-police:server:search:player')
AddEventHandler('framework-police:server:search:player', function(PlayerId)
    local SearchedPlayer = LSCore.Functions.GetPlayer(PlayerId)
    if SearchedPlayer ~= nil then 
        -- TriggerClientEvent('chatMessage', source, "SYSTEM", "warning", "Persoon heeft €"..SearchedPlayer.PlayerData.money["cash"]..",- op zak..")
        TriggerClientEvent('LSCore:Notify', SearchedPlayer.PlayerData.source, "Je wordt gefouilleerd..")
    end
end)

RegisterServerEvent('framework-police:server:rob:player')
AddEventHandler('framework-police:server:rob:player', function(PlayerId)
    local Player = LSCore.Functions.GetPlayer(source)
    local SearchedPlayer = LSCore.Functions.GetPlayer(PlayerId)
    if SearchedPlayer ~= nil then 
        TriggerClientEvent('LSCore:Notify', Player.PlayerData.source, "Je kunt het geld gewoon contant afnemen uit de inventaris")
    end
end)

RegisterServerEvent('framework-police:server:escort:closest')
AddEventHandler('framework-police:server:escort:closest', function(SeverId)
    local Player = LSCore.Functions.GetPlayer(source)
    local EscortPlayer = LSCore.Functions.GetPlayer(SeverId)
    if (EscortPlayer.PlayerData.metadata["ishandcuffed"] or EscortPlayer.PlayerData.metadata["isdead"]) then
        TriggerClientEvent("framework-police:client:get:escorted", EscortPlayer.PlayerData.source, Player.PlayerData.source)
    end
end)

RegisterServerEvent('framework-police:server:set:out:vehicle')
AddEventHandler('framework-police:server:set:out:vehicle', function(ServerId)
    local Player = LSCore.Functions.GetPlayer(source)
    local EscortPlayer = LSCore.Functions.GetPlayer(ServerId)
    if EscortPlayer.PlayerData.metadata["ishandcuffed"] or EscortPlayer.PlayerData.metadata["isdead"] then
        TriggerClientEvent("framework-police:client:set:out:veh", EscortPlayer.PlayerData.source)
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Persoon is niet dood of geboeid!")
    end
end)

RegisterServerEvent('framework-police:server:set:in:vehicle')
AddEventHandler('framework-police:server:set:in:vehicle', function(ServerId)
    local Player = LSCore.Functions.GetPlayer(source)
    local EscortPlayer = LSCore.Functions.GetPlayer(ServerId)
    if EscortPlayer.PlayerData.metadata["ishandcuffed"] or EscortPlayer.PlayerData.metadata["isdead"] then
        TriggerClientEvent("framework-police:client:set:in:veh", EscortPlayer.PlayerData.source)
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Persoon is niet dood of geboeid!")
    end
end)

RegisterServerEvent('framework-police:server:give:finger:scanner')
AddEventHandler('framework-police:server:give:finger:scanner', function(TargetPlayer)
    local TargetPlayer = LSCore.Functions.GetPlayer(tonumber(TargetPlayer))
    if TargetPlayer ~= nil then
        TriggerClientEvent('framework-police:client:give:finger:scanner', TargetPlayer.PlayerData.source)
    end
end)

RegisterServerEvent('framework-police:server:update:blips')
AddEventHandler('framework-police:server:update:blips', function()
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
    TriggerClientEvent("framework-police:client:update:blips", -1, DutyPlayers)
end)

RegisterServerEvent('framework-police:server:set:tracker')
AddEventHandler('framework-police:server:set:tracker', function(TargetId)
    local Target = LSCore.Functions.GetPlayer(TargetId)
    local TrackerMeta = Target.PlayerData.metadata["tracker"]
    if TrackerMeta then
        Target.Functions.SetMetaData("tracker", false)
        TriggerClientEvent('LSCore:Notify', TargetId, 'Je enkelband is afgedaan.', 'error', 5000)
        TriggerClientEvent('LSCore:Notify', source, 'Je hebt een enkelband afgedaan van '..Target.PlayerData.charinfo.firstname.." "..Target.PlayerData.charinfo.lastname, 'error', 5000)
        TriggerClientEvent('framework-police:client:set:tracker', TargetId, false)
    else
        Target.Functions.SetMetaData("tracker", true)
        TriggerClientEvent('LSCore:Notify', TargetId, 'Je hebt een enkelband omgekregen.', 'error', 5000)
        TriggerClientEvent('LSCore:Notify', source, 'Je hebt een enkelband omgedaan bij '..Target.PlayerData.charinfo.firstname.." "..Target.PlayerData.charinfo.lastname, 'error', 5000)
        TriggerClientEvent('framework-police:client:set:tracker', TargetId, true)
    end
end)

-- // Commands \\ --

LSCore.Commands.Add("cuff", "toggle handboeien (Admin)", {{name="ID", help="PlayerId"}}, true, function(source, args)
    local Player = LSCore.Functions.GetPlayer(source)
    if args ~= nil then
        local TargetPlayer = LSCore.Functions.GetPlayer(tonumber(args[1]))
        if TargetPlayer ~= nil then
          TriggerClientEvent("framework-police:client:get:cuffed", TargetPlayer.PlayerData.source, Player.PlayerData.source)
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
            TargetPlayer.Functions.SetJob('police', 1)
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
            TargetPlayer.Functions.SetJob('unemployed', 1)
        end
    end
end)

LSCore.Commands.Add("meospass", "Stel je meos wachtwoord in", {{name="Wachtwoord", help="Type je wachtwoord in die je wilt gaan gebruiken"}}, true, function(source, args)
    local Player = LSCore.Functions.GetPlayer(source)
    if args ~= nil then
        if Player.PlayerData.job.name == 'police' and Player.PlayerData.job.onduty then
            exports['oxmysql']:execute("UPDATE `players` SET `web_pass` = @web_pass WHERE `citizenid` = @citizenid", {
                ["@web_pass"] = args[1],
                ["@citizenid"] = Player.PlayerData.citizenid,
            })
            Citizen.SetTimeout(150, function()
                Player.Functions.Save()
            end)
            TriggerClientEvent('LSCore:Notify', source, 'Wachtwoord succesvol aangepast', 'success')
        else
            TriggerClientEvent('LSCore:Notify', source, 'Dit is alleen voor hulp diensten..', 'error')
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
            TriggerClientEvent("framework-police:client:open:evidence", source, args[1])
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
            TriggerClientEvent('framework-radialmenu:client:update:duty:vehicles', TargetPlayerData.PlayerData.source)
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

-- LSCore.Commands.Add("bill", "Factuur uitschrijven", {{name="id", help="Speler ID"},{name="geld", help="Hoeveel"}}, true, function(source, args)
--     local Player = LSCore.Functions.GetPlayer(source)
--     local TargetPlayer = LSCore.Functions.GetPlayer(tonumber(args[1]))
--     local Amount = tonumber(args[2])
--     if TargetPlayer ~= nil then
--         if Player.PlayerData.job.name == "police" then
--             if Amount > 0 then
--                 if TargetPlayer.Functions.RemoveMoney('bank', Amount) then
--                     TriggerClientEvent('LSCore:Notify', source, TargetPlayer.PlayerData.charinfo.firstname..' '..TargetPlayer.PlayerData.charinfo.lastname..' heeft een boete ontvangen van €'..Amount..',-', "success")
--                     TriggerClientEvent('LSCore:Notify', TargetPlayer.PlayerData.source, 'Je ontving een boete van €'..Amount..',-', "error")
--                     -- TriggerEvent('framework-banking:server:set:business:accounts', 'Add', Amount, 'POLITIE', 'Boete betaling.', TargetPlayer.PlayerData.source)
--                 end
--             else
--                 TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Het bedrag moet hoger zijn dan 0")
--             end
--         else
--             TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Dit command is voor hulpdiensten!")
--         end
--     end
-- end)

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
                TriggerEvent('framework-ui:server:addskill', 'baan', 1)
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
                    TriggerClientEvent("framework-police:client:send:tracker:location", Target.PlayerData.source, Target.PlayerData.source)
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
        TriggerClientEvent('framework-police:client:send:alert', source, Message, false)
        TriggerEvent("framework-logs:server:SendLog", "112", "112 Melding", "blue", "**"..GetPlayerName(source).."** (CitizenID: "..Player.PlayerData.citizenid.." | ID: "..source..") **Melding:** " ..Message, false)
    else
        TriggerClientEvent('LSCore:Notify', source, 'Je hebt geen telefoon..', 'error')
    end
end)

LSCore.Commands.Add("112a", "Stuur een anonieme melding naar hulpdiensten (geeft geen locatie)", {{name="bericht", help="Bericht die je wilt sturen naar de hulpdiensten"}}, true, function(source, args)
    local Message = table.concat(args, " ")
    local Player = LSCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemByName("phone") ~= nil then
        TriggerClientEvent("framework-police:client:call:anim", source)
        TriggerClientEvent('framework-police:client:send:alert', -1, Message, true)
        TriggerEvent("framework-logs:server:SendLog", "112", "112a Melding", "blue", "**"..GetPlayerName(source).."** (CitizenID: "..Player.PlayerData.citizenid.." | ID: "..source..") **Melding:** " ..Message, false)
    else
        TriggerClientEvent('LSCore:Notify', source, 'Je hebt geen telefoon..', 'error')
    end
end)

-- // Callbacks \\ --

LSCore.Functions.CreateCallback('framework-police:server:get:config', function(source, cb)
    cb(Config)
end)

LSCore.Functions.CreateCallback('framework-police:server:is:player:dead', function(source, cb, PlayerId)
    local Player = LSCore.Functions.GetPlayer(PlayerId)
    cb(Player.PlayerData.metadata["isdead"])
end)

-- // Alerts \\ --

RegisterServerEvent('framework-police:server:send:tracker:location')
AddEventHandler('framework-police:server:send:tracker:location', function(Coords, RequestId)
    local Target = LSCore.Functions.GetPlayer(RequestId)
    TriggerClientEvent('framework-police:client:send:tracker:alert', -1, Coords, Target.PlayerData.charinfo.firstname.." "..Target.PlayerData.charinfo.lastname)
end)

RegisterServerEvent('framework-police:server:send:alert:officer:down')
AddEventHandler('framework-police:server:send:alert:officer:down', function(Coords, StreetName, Info, Priority)
   TriggerClientEvent('framework-police:client:send:officer:down', -1, Coords, StreetName, Info, Priority)
end)

RegisterServerEvent('framework-police:server:send:alert:panic:button')
AddEventHandler('framework-police:server:send:alert:panic:button', function(Coords, StreetName, Info)
    TriggerClientEvent('framework-police:client:send:alert:panic:button', -1, Coords, StreetName, Info)
end)

RegisterServerEvent('framework-police:server:send:alert:gunshots')
AddEventHandler('framework-police:server:send:alert:gunshots', function(Coords, GunType, StreetName, InVeh)
   TriggerClientEvent("framework-phone-new:client:send:recent:alert:meos", -1, Data)
   TriggerClientEvent('framework-police:client:send:alert:gunshots', -1, Coords, GunType, StreetName, InVeh)
end)

RegisterServerEvent('framework-police:server:send:alert:dead')
AddEventHandler('framework-police:server:send:alert:dead', function(Coords, StreetName)
   TriggerClientEvent('framework-police:client:send:alert:dead', -1, Coords, StreetName)
end)

RegisterServerEvent('framework-police:server:send:bank:alert')
AddEventHandler('framework-police:server:send:bank:alert', function(Coords, StreetName, Name)
   TriggerClientEvent('framework-police:client:send:bank:alert', -1, Coords, StreetName, Name)
end)

RegisterServerEvent('framework-police:server:send:alert:jewellery')
AddEventHandler('framework-police:server:send:alert:jewellery', function(Coords, StreetName)
   TriggerClientEvent('framework-police:client:send:alert:jewellery', -1, Coords, StreetName)
end)

RegisterServerEvent('framework-police:server:send:alert:store')
AddEventHandler('framework-police:server:send:alert:store', function(Coords, StreetName, StoreNumber)
   TriggerClientEvent('framework-police:client:send:alert:store', -1, Coords, StreetName, StoreNumber)
end)

RegisterServerEvent('framework-police:server:send:house:alert')
AddEventHandler('framework-police:server:send:house:alert', function(Coords, StreetName)
   TriggerClientEvent('framework-police:client:send:house:alert', -1, Coords, StreetName)
end)

RegisterServerEvent('framework-police:server:send:banktruck:alert')
AddEventHandler('framework-police:server:send:banktruck:alert', function(Coords, Plate, StreetName)
   TriggerClientEvent('framework-police:client:send:banktruck:alert', -1, Coords, Plate, StreetName)
end)

RegisterServerEvent('framework-police:server:alert:explosion')
AddEventHandler('framework-police:server:alert:explosion', function(Coords, StreetName)
   TriggerClientEvent('framework-police:client:send:explosion:alert', -1, Coords, StreetName)
end)

RegisterServerEvent('framework-police:server:alert:cornerselling')
AddEventHandler('framework-police:server:alert:cornerselling', function(Coords, StreetName)
   TriggerClientEvent('framework-police:client:send:cornerselling:alert', -1, Coords, StreetName)
end)

RegisterServerEvent('framework-police:server:alert:weedbrick')
AddEventHandler('framework-police:server:alert:weedbrick', function(Coords, StreetName)
   TriggerClientEvent('framework-police:client:send:weedbrick:alert', -1, Coords, StreetName)
end)

RegisterServerEvent('framework-police:server:alert:humanelabs')
AddEventHandler('framework-police:server:alert:humanelabs', function(Coords, StreetName)
   TriggerClientEvent('framework-police:client:send:humanelabs:alert', -1, Coords, StreetName)
end)

RegisterServerEvent('framework-police:server:send:bobcat:alert')
AddEventHandler('framework-police:server:send:bobcat:alert', function(Coords, StreetName)
   TriggerClientEvent('framework-police:client:send:bobcat:alert', -1, Coords, StreetName)
end)

RegisterServerEvent('framework-police:server:alert:illegal:hunting')
AddEventHandler('framework-police:server:alert:illegal:hunting', function(Coords)
   TriggerClientEvent('framework-police:client:send:illegal:hunting:alert', -1, Coords)
end)

RegisterServerEvent('framework-police:server:send:oxy:alert')
AddEventHandler('framework-police:server:send:oxy:alert', function(Coords, Street)
   TriggerClientEvent('framework-police:client:send:oxy:alert', -1, Coords, Street)
end)

RegisterServerEvent('framework-police:server:alert:prison')
AddEventHandler('framework-police:server:alert:prison', function(Coords)
   TriggerClientEvent('framework-police:client:send:prison:alert', -1, Coords)
end)

RegisterServerEvent('framework-police:server:send:call:alert')
AddEventHandler('framework-police:server:send:call:alert', function(Coords, Message)
    local Player = LSCore.Functions.GetPlayer(source)
    local Name = Player.PlayerData.charinfo.firstname..' '..Player.PlayerData.charinfo.lastname
    TriggerClientEvent('framework-police:client:send:call:alert', -1, Coords, Name, Message)
end)

-- // Evidence \\ --

RegisterServerEvent('framework-police:server:create:bullet')
AddEventHandler('framework-police:server:create:bullet', function(Weapon, Coords)
    local Player = LSCore.Functions.GetPlayer(source)
    local CasingId = CreateRandomId()
    local WeaponInfo = exports['fw-weapons']:GetWeaponList(Weapon)
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
    TriggerClientEvent("framework-police:client:sync:evidence", -1, CasingId, Config.Evidence[CasingId])
end)

RegisterServerEvent('framework-police:server:create:evidence')
AddEventHandler('framework-police:server:create:evidence', function(Type, Coords)
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
    TriggerClientEvent("framework-police:client:sync:evidence", -1, RandomId, Config.Evidence[RandomId])
end)

RegisterServerEvent('framework-police:server:add:evidence')
AddEventHandler('framework-police:server:add:evidence', function(EvidenceNumber, Data, Street)
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
            TriggerClientEvent("framework-police:client:sync:evidence", -1, EvidenceNumber, Config.Evidence[EvidenceNumber])
        end
    else
       TriggerClientEvent('LSCore:Notify', source, "Je moet een leeg bewijszakje bij je hebben", "error")
    end
end)

RegisterServerEvent('framework-police:server:toggle:disco:mode')
AddEventHandler('framework-police:server:toggle:disco:mode', function(Bool)
    TriggerClientEvent('framework-police:client:toggle:disco:mode', -1, Bool)
end)

-- // Functions \\ --

function CreateRandomId()
    return math.random(11111,99999)
end


-- // Smelter \\ --

RegisterServerEvent('framework-pawnshop:server:try:start')
AddEventHandler('framework-pawnshop:server:try:start', function(InventoryName)
    if not Smelting then
        local InventoryItems = exports['fw-inv']:GetInventoryItems(InventoryName)
        for k, v in pairs(InventoryItems) do
            if v.name == 'goldbar' then
                TotalGoldBar = TotalGoldBar + v.amount
            end
            if Config.SmeltItems[v.name] ~= nil then
                if SmeltingData[v.name] == nil then
                    SmeltingData[v.name] = v.amount
                else
                    SmeltingData[v.name] = SmeltingData[v.name] + v.amount
                end
            end
        end
        if SmeltingData ~= nil and (SmeltingData['rolex'] ~= nil and SmeltingData['rolex'] >= Config.SmeltItems['rolex'] or SmeltingData['goldchain'] ~= nil and SmeltingData['goldchain'] >= Config.SmeltItems['goldchain'] or SmeltingData['heirloom'] ~= nil and SmeltingData['heirloom'] >= Config.SmeltItems['heirloom']) then
            if not Smelting then
                Smelting = true
                TriggerClientEvent('LSCore:Notify', source, 'Smelter is nu aan het smelten!', 'success') 
                StartSmelting()
            else
                TriggerClientEvent('LSCore:Notify', source, 'Er worden al goederen gesmolten..', 'error') 
            end
        else
            SmeltingData, TotalGoldBar = {}, 0
            TriggerClientEvent('LSCore:Notify', source, 'Deze spullen kan je niet smelten..', 'error')
        end
    else
        TriggerClientEvent('LSCore:Notify', source, 'Er worden al goederen gesmolten..', 'error') 
    end
end)

function StartSmelting()
    Citizen.SetTimeout((1000 * 60) * 2, function()
        for k, v in pairs(SmeltingData) do
            while SmeltingData[k] >= Config.SmeltItems[k] do
                if SmeltingData[k] - Config.SmeltItems[k] > 0 then
                    SmeltingData[k] = SmeltingData[k] - Config.SmeltItems[k]
                    TotalGoldBar = TotalGoldBar + 1
                elseif SmeltingData[k] - Config.SmeltItems[k] == 0 then
                    SmeltingData[k] = 0
                    TotalGoldBar = TotalGoldBar + 1
                end
            end
        end
        local Inventory = {[1] = {name = 'goldbar', slot = 1, info = '', amount = TotalGoldBar}} 
        if (SmeltingData['rolex'] ~= nil and SmeltingData['rolex'] > 0) and (SmeltingData['goldchain'] ~= nil and SmeltingData['goldchain'] > 0) and (SmeltingData['heirloom'] ~= nil and SmeltingData['heirloom'] > 0) then
            Inventory = {[1] = {name = 'goldbar', slot = 1, info = '', amount = TotalGoldBar}, [2] = {name = 'goldchain', slot = 2, info = '', amount = SmeltingData['goldchain']}, [3] = {name = 'rolex', slot = 3, info = '', amount = SmeltingData['rolex']}, [4] = {name = 'heirloom', slot = 4, info = '', amount = SmeltingData['heirloom']}}
        elseif SmeltingData['rolex'] ~= nil and SmeltingData['rolex'] > 0 then
            Inventory = {[1] = {name = 'goldbar', slot = 1, info = '', amount = TotalGoldBar}, [2] = {name = 'rolex', slot = 2, info = '', amount = SmeltingData['rolex']}}
        elseif SmeltingData['goldchain'] ~= nil and SmeltingData['goldchain'] > 0 then
            Inventory = {[1] = {name = 'goldbar', slot = 1, info = '', amount = TotalGoldBar}, [2] = {name = 'goldchain', slot = 2, info = '', amount = SmeltingData['goldchain']}}
        elseif SmeltingData['heirloom'] ~= nil and SmeltingData['heirloom'] > 0 then
            Inventory = {[1] = {name = 'goldbar', slot = 1, info = '', amount = TotalGoldBar}, [2] = {name = 'heirloom', slot = 2, info = '', amount = SmeltingData['heirloom']}}
        end
        exports['fw-inv']:SetInventoryItems("Smelter", Inventory)
        SmeltingData, Smelting, TotalGoldBar = {}, false, 0
    end)
end

-- // PawnShop \\ --

RegisterServerEvent('framework-pawnshop:server:try:sell')
AddEventHandler('framework-pawnshop:server:try:sell', function(InventoryName, Type)
    print('try selling pawnshop items')
    local RecieveMoney = 0
    local Player = LSCore.Functions.GetPlayer(source)
    local Inventoryamount = 0
    local InvItemName = nil
    local InventoryItems = exports['fw-inv']:GetInventoryItems(InventoryName)
    if InventoryItems ~= nil then
        if Type == 'BarsItem' then
            for k, v in pairs(InventoryItems) do
                if Config.SellItems[v.name] ~= nil then
                    RecieveMoney = RecieveMoney + (Config.SellItems[v.name] * v.amount)
                    InventoryItems[k] = nil
                end
            end
            if RecieveMoney > 0 then
                exports['fw-inv']:SetInventoryItems("Inkoper: 1", InventoryItems)
                Player.Functions.AddMoney('cash', RecieveMoney)
            else
                TriggerClientEvent('LSCore:Notify', source, 'Er is niks om te verkopen..', 'error')
            end
        elseif Type == 'WoodSell' then
                for k, v in pairs(InventoryItems) do
                    if Config.ConvertItems[v.name] ~= nil then
                        Inventoryamount = v.amount
                        InvItemName = v.name
                        InventoryItems[k] = nil
                    end
                end
                if Inventoryamount > 0 then
                    exports['fw-inv']:SetInventoryItems("Inkoper: 3", InventoryItems)
                    Player.Functions.AddItem('clean_paper', Inventoryamount, false, false, true)
                else
                    TriggerClientEvent('LSCore:Notify', source, 'Er is niks om te verkopen..', 'error')
                end
        end
    else
        TriggerClientEvent('LSCore:Notify', source, 'Er is niks om te verkopen..', 'error')
    end
end)

-- Hospital

LSCore.Functions.CreateCallback('framework-hospital:server:pay:hospital', function(source, cb)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player.Functions.RemoveMoney('cash', Config.BedPayment, 'Ziekenhuis') then
		cb(true)
	elseif Player.Functions.RemoveMoney('bank', Config.BedPayment, 'Ziekenhuis') then
		cb(true)
	else
		TriggerClientEvent('LSCore:Notify', source, "Je hebt niet genoeg contant..", "error", 4500)
		cb(false)
	end

end)

RegisterServerEvent('framework-hospital:server:set:state')
AddEventHandler('framework-hospital:server:set:state', function(type, state)
	local src = source
	local Player = LSCore.Functions.GetPlayer(src)
	if Player ~= nil then
		Player.Functions.SetMetaData(type, state)
	end
end)

RegisterServerEvent('framework-hospital:server:dead:respawn')
AddEventHandler('framework-hospital:server:dead:respawn', function()
	local Player = LSCore.Functions.GetPlayer(source)
	Player.Functions.RemoveMoney('bank', Config.RespawnPrice, 'respawn-fund')
	Player.Functions.ClearInventory()
	Citizen.SetTimeout(250, function()
		Player.Functions.Save()
	end)
end)

RegisterServerEvent('framework-hospital:server:save:health:armor')
AddEventHandler('framework-hospital:server:save:health:armor', function(PlayerHealth, PlayerArmor)
	local Player = LSCore.Functions.GetPlayer(source)
	if Player ~= nil then
		Player.Functions.SetMetaData('health', PlayerHealth)
		Player.Functions.SetMetaData('armor', PlayerArmor)
	end
end)

RegisterServerEvent('framework-hospital:server:revive:player')
AddEventHandler('framework-hospital:server:revive:player', function(PlayerId)
	local TargetPlayer = LSCore.Functions.GetPlayer(PlayerId)
	if TargetPlayer ~= nil then
		TriggerClientEvent('framework-hospital:client:revive', TargetPlayer.PlayerData.source, true, true)
		TriggerEvent('framework-ui:server:addskill', 'baan', 1)
	end
end)

RegisterServerEvent('framework-hospital:server:heal:player')
AddEventHandler('framework-hospital:server:heal:player', function(TargetId)
	local TargetPlayer = LSCore.Functions.GetPlayer(TargetId)
	if TargetPlayer ~= nil then
		TriggerClientEvent('framework-hospital:client:heal', TargetPlayer.PlayerData.source)
		TriggerEvent('framework-ui:server:addskill', 'baan', 1)
	end
end)

RegisterServerEvent('framework-hospital:server:take:blood:player')
AddEventHandler('framework-hospital:server:take:blood:player', function(TargetId)
	local src = source
	local SourcePlayer = LSCore.Functions.GetPlayer(src)
	local TargetPlayer = LSCore.Functions.GetPlayer(TargetId)
	if TargetPlayer ~= nil then
	 local Info = {vialid = math.random(11111,99999), bloodtype = TargetPlayer.PlayerData.metadata['bloodtype'], vialbsn = TargetPlayer.PlayerData.citizenid}
	 SourcePlayer.Functions.AddItem('bloodvial', 1, false, Info, true)
	 TriggerEvent('framework-ui:server:addskill', 'baan', 1)
	end
end)

RegisterServerEvent('framework-hospital:server:set:bed:state')
AddEventHandler('framework-hospital:server:set:bed:state', function(BedData, bool)
	Config.Beds[BedData]['Busy'] = bool
	TriggerClientEvent('framework-hospital:client:set:bed:state', -1 , BedData, bool)
end)

LSCore.Commands.Add("revive", "Revive een speler of jezelf", {{name="id", help="Speler ID (mag leeg zijn)"}}, false, function(source, args)
	if args[1] ~= nil then
		local Player = LSCore.Functions.GetPlayer(tonumber(args[1]))
		if Player ~= nil then
			TriggerClientEvent('framework-hospital:client:revive', Player.PlayerData.source, true, true)
		else
			TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Speler is niet online!")
		end
	else
		TriggerClientEvent('framework-hospital:client:revive', source, true, true)
	end
end, "admin")

LSCore.Commands.Add("armor", "Geef armor aan een speler of jezelf", {{name="id", help="Speler ID (mag leeg zijn)"}}, false, function(source, args)
	if args[1] ~= nil then
		local Player = LSCore.Functions.GetPlayer(tonumber(args[1]))
		if Player ~= nil then
			TriggerClientEvent('framework-hospital:client:armor:up', Player.PlayerData.source)
		else
			TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Speler is niet online!")
		end
	else
		TriggerClientEvent('framework-hospital:client:armor:up', source)
	end
end, "admin")

LSCore.Commands.Add("setambulance", "Neem neen ambulancier aan", {{name="id", help="Speler ID"}}, true, function(source, args)
    local Player = LSCore.Functions.GetPlayer(source)
    local TargetPlayer = LSCore.Functions.GetPlayer(tonumber(args[1]))
    if Player.PlayerData.metadata['ishighcommand'] and Player.PlayerData.job.name == 'ambulance' then
      	if TargetPlayer ~= nil then
      	    TriggerClientEvent('LSCore:Notify', TargetPlayer.PlayerData.source, 'Je bent aangenomen als ambulancier! gefeliciteerd!', 'success')
      	    TriggerClientEvent('LSCore:Notify', Player.PlayerData.source, 'Je hebt '..TargetPlayer.PlayerData.charinfo.firstname..' '..TargetPlayer.PlayerData.charinfo.lastname..' aangenomen als ambulancier!', 'success')
      	    TargetPlayer.Functions.SetJob('ambulance', 1)
      	end
    end
end)

LSCore.Commands.Add("fireambulance", "Ontsla een ambulancier", {{name="id", help="Speler ID"}}, true, function(source, args)
    local Player = LSCore.Functions.GetPlayer(source)
    local TargetPlayer = LSCore.Functions.GetPlayer(tonumber(args[1]))
    if Player.PlayerData.metadata['ishighcommand'] then
      	if TargetPlayer ~= nil and TargetPlayer.PlayerData.job.name == 'ambulance' then
      	  	TriggerClientEvent('LSCore:Notify', TargetPlayer.PlayerData.source, 'Je bent ontslagen!', 'error')
      	  	TriggerClientEvent('LSCore:Notify', Player.PlayerData.source, 'Je hebt '..TargetPlayer.PlayerData.charinfo.firstname..' '..TargetPlayer.PlayerData.charinfo.lastname..' ontslagen!', 'success')
      	  	TargetPlayer.Functions.SetJob('unemployed', 1)
      	end
    end
end)

-- Prison

LSCore.Commands.Add("jail", "Stop een burger in de cel", {{name="id", help="Speler ID"}, {name="tijd", help="Tijd hoelang hij moet zitten"}}, true, function(source, args)
    local Player = LSCore.Functions.GetPlayer(source)
    local JailPlayer = LSCore.Functions.GetPlayer(tonumber(args[1]))
    if Player.PlayerData.job.name == "police" then
        if JailPlayer ~= nil then
            if JailPlayer.PlayerData.job.name ~= 'police' then
                local Time = tonumber(args[2])
                if Time > 0 then
                    local Name = JailPlayer.PlayerData.charinfo.firstname..' '..JailPlayer.PlayerData.charinfo.lastname
                    if JailPlayer.PlayerData.job.name ~= 'police' and JailPlayer.PlayerData.job.name ~= 'ambulance' then
                        JailPlayer.Functions.SetJob('unemployed', 1)
                        TriggerClientEvent('LSCore:Notify', JailPlayer.PlayerData.source, "Je bent werkloos..", 'error')
                    end
                    JailPlayer.Functions.SetMetaData("jailtime", Time)
                    TriggerClientEvent('framework-prison:client:set:in:jail', JailPlayer.PlayerData.source, Name, Time, JailPlayer.PlayerData.citizenid, os.date('%d-'..'%m-'..'%y'))
                end
            else
                TriggerClientEvent('LSCore:Notify', Player.PlayerData.source, "Je kan geen agent jailen..", 'error')
            end
        end
    end
end)

RegisterServerEvent('framework-prison:server:set:jail:leave')
AddEventHandler('framework-prison:server:set:jail:leave', function()
    local Player = LSCore.Functions.GetPlayer(source)
    Player.Functions.SetMetaData("jailtime", 0)
    Player.Functions.Save()
end)

RegisterServerEvent('framework-prison:server:set:jail:items')
AddEventHandler('framework-prison:server:set:jail:items', function(Time)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    Player.Functions.SetMetaData("jailitems", Player.PlayerData.inventory)
    Player.Functions.ClearInventory()
    Player.Functions.AddItem("water_bottle", 5)
    Player.Functions.AddItem("sandwich", 5)
    Player.Functions.AddMoney("cash", 15)
    Citizen.SetTimeout(500, function()
        Player.Functions.Save()
    end)
end)

RegisterServerEvent('framework-prison:server:get:items:back')
AddEventHandler('framework-prison:server:get:items:back', function()
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    for k, v in pairs(Player.PlayerData.metadata["jailitems"]) do
        Player.Functions.AddItem(v.name, v.amount, false, v.info)
    end
    Player.Functions.SetMetaData("jailitems", nil)
end)

RegisterServerEvent('framework-prison:server:find:reward')
AddEventHandler('framework-prison:server:find:reward', function(reward)
    local Player = LSCore.Functions.GetPlayer(source)
    Player.Functions.AddItem(reward, 1, false, false, true)
    CheckForPrisonItems(source)
end)

RegisterServerEvent('framework-prison:server:set:alarm')
AddEventHandler('framework-prison:server:set:alarm', function(bool)
    TriggerClientEvent('framework-prison:client:set:alarm', -1, bool)
end)

RegisterServerEvent('framework-prison:server:reduce:reward')
AddEventHandler('framework-prison:server:reduce:reward', function()
    ReduceReward(source)
end)

-- // Funtions \\ --

function ReduceReward(Source)
    local Player = LSCore.Functions.GetPlayer(Source)
        if Player.PlayerData.metadata['jailtime'] > 0 then
            local RandomMin = math.random(2,5)
            if Player.PlayerData.metadata['jailtime'] - RandomMin > 0 then
                Player.PlayerData.metadata['jailtime'] = Player.PlayerData.metadata['jailtime'] - RandomMin
                TriggerClientEvent('LSCore:Notify', Player.PlayerData.source, "Je moet nog "..Player.PlayerData.metadata['jailtime'].." maand(en) zitten.", 'error')
            else
                TriggerClientEvent('LSCore:Notify', Player.PlayerData.source, "Je bent vrij joh!", 'success')
                Player.PlayerData.metadata['jailtime'] = 0
            end
            Player.Functions.Save()
            TriggerClientEvent('framework-prison::client:set:time', Player.PlayerData.source, Player.PlayerData.metadata['jailtime'])
        end
end

function CheckForPrisonItems(Source)
    local Player = LSCore.Functions.GetPlayer(Source)
    local FirstItem = Player.Functions.GetItemByName('ass-lockpick')
    local SecondItem = Player.Functions.GetItemByName('ass-phone')
    local LastItem = Player.Functions.GetItemByName('jail-food')
    if FirstItem ~= nil and SecondItem ~= nil and LastItem ~= nil then
        Player.Functions.RemoveItem(FirstItem.name, 1, false, true)
        Player.Functions.RemoveItem(SecondItem.name, 1, false, true)
        Player.Functions.RemoveItem(LastItem.name, 1, false, true)
        if Player.PlayerData.metadata['jailtime'] > 0 then
            local RandomMin = math.random(2,5)
            if Player.PlayerData.metadata['jailtime'] - RandomMin > 0 then
                Player.PlayerData.metadata['jailtime'] = Player.PlayerData.metadata['jailtime'] - RandomMin
                TriggerClientEvent('LSCore:Notify', Player.PlayerData.source, "Je moet nog "..Player.PlayerData.metadata['jailtime'].." maand(en) zitten.", 'error')
            else
                TriggerClientEvent('LSCore:Notify', Player.PlayerData.source, "Je bent vrij joh!", 'success')
                Player.PlayerData.metadata['jailtime'] = 0
            end
            Player.Functions.Save()
            TriggerClientEvent('framework-prison::client:set:time', Player.PlayerData.source, Player.PlayerData.metadata['jailtime'])
        end
    end
end

-- Cityhall

RegisterServerEvent('framework-cityhall:server:request:identity')
AddEventHandler('framework-cityhall:server:request:identity', function(data)
    local Player = LSCore.Functions.GetPlayer(source)
    if Player.Functions.RemoveMoney('cash', 50) then
        local CardInfo = {}
        if data['Id'] == "id" then
            CardInfo.citizenid = Player.PlayerData.citizenid
            CardInfo.firstname = Player.PlayerData.charinfo.firstname
            CardInfo.lastname = Player.PlayerData.charinfo.lastname
            CardInfo.birthdate = Player.PlayerData.charinfo.birthdate
            CardInfo.gender = Player.PlayerData.charinfo.gender
            CardInfo.nationality = Player.PlayerData.charinfo.nationality
            Player.Functions.AddItem('id_card', 1, false, CardInfo, true)
        elseif data['Id'] == "drive" then
            CardInfo.firstname = Player.PlayerData.charinfo.firstname
            CardInfo.lastname = Player.PlayerData.charinfo.lastname
            CardInfo.birthdate = Player.PlayerData.charinfo.birthdate
            CardInfo.type = "A1-A2-A | AM-B | C1-C-CE"
            Player.Functions.AddItem('driver_license', 1, false, CardInfo, true)
        end
    else
      TriggerClientEvent('LSCore:Notify', source, 'Je hebt niet genoeg geld..', 'error')
    end
end)

RegisterServerEvent('framework-cityhall:server:request:license')
AddEventHandler('framework-cityhall:server:request:license', function(data)
    local Player, Label = LSCore.Functions.GetPlayer(source), 'Jaag'
    if Player.PlayerData.metadata['licences'][data['Id']] == nil then
        if Player.Functions.RemoveMoney('cash', 5000) or Player.Functions.RemoveMoney('bank', 5000) then
            local SerialNumber, LicenseInfo = LSCore.Player.CreateWeaponSerial(), {}
            Player.Functions.SetMetaDataTable('licences', data['Id'], SerialNumber)
            if data['Id'] == 'hunting' then Label = 'Jaag' LicenseInfo.type = 'Jaag' LicenseInfo.serie = SerialNumber end
            TriggerClientEvent('LSCore:Notify', source, 'Je ontving een '..Label..' vergunning!', 'success')
            Player.Functions.AddItem('licence', 1, false, LicenseInfo, true)
        else
            TriggerClientEvent('LSCore:Notify', source, 'Je hebt niet genoeg geld..', 'error')
        end
    else
        if Player.Functions.RemoveMoney('cash', 5000) or Player.Functions.RemoveMoney('bank', 5000) then
            local LicenseInfo = {}
            if data['Id'] == 'hunting' then LicenseInfo.type = 'Jaag' LicenseInfo.serie = Player.PlayerData.metadata['licences']['hunting'] end
            Player.Functions.AddItem('licence', 1, false, LicenseInfo, true)
        else
            TriggerClientEvent('LSCore:Notify', source, 'Je hebt niet genoeg geld..', 'error')
        end
    end
end)

RegisterServerEvent('framework-cityhall:server:request:work')
AddEventHandler('framework-cityhall:server:request:work', function(data)
    local Player = LSCore.Functions.GetPlayer(source)
    local JobInfo = LSCore.Shared.Jobs[data['Id']]
    Player.Functions.SetJob(data['Id'], 1)
    TriggerClientEvent('LSCore:Notify', source, 'Gefeliciteerd met je nieuwe baan! ('..JobInfo.label..')')
end)

RegisterServerEvent('framework-cityhall:server:scan:metal')
AddEventHandler('framework-cityhall:server:scan:metal', function()
    local RemoveItemsTable = {}
    local Player = LSCore.Functions.GetPlayer(source)
    if Player.PlayerData.metadata['courtitems'] ~= nil then
        for k, v in pairs(Player.PlayerData.metadata['courtitems']) do
            table.insert(RemoveItemsTable, Player.PlayerData.metadata['courtitems'][k])
        end
    end
    for k, v in pairs(Player.PlayerData.inventory) do
        local ItemData = exports['fw-inv']:GetItemData(Player.PlayerData.inventory[k].name)
        if ItemData['ismetal'] then
            Player.Functions.RemoveItem(Player.PlayerData.inventory[k].name, Player.PlayerData.inventory[k].amount, false, true)
            table.insert(RemoveItemsTable, Player.PlayerData.inventory[k])
        end
    end
    Citizen.SetTimeout(250, function()
        Player.Functions.SetMetaData("courtitems", RemoveItemsTable)
        Player.Functions.Save()
    end)
end)

RegisterServerEvent('framework-cityhall:server:recieve:metal:objects')
AddEventHandler('framework-cityhall:server:recieve:metal:objects', function()
    local Player = LSCore.Functions.GetPlayer(source)
    if Player.PlayerData.metadata['courtitems'] ~= nil then
        for k, v in pairs(Player.PlayerData.metadata['courtitems']) do
            Player.Functions.AddItem(v.name, v.amount, false, v.info, true)
        end
        Citizen.SetTimeout(250, function()
           Player.Functions.SetMetaData("courtitems", {})
           Player.Functions.Save()
        end)
    end
end)