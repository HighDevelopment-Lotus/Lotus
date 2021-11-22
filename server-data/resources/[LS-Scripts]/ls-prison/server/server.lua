local LSCore = exports['ls-core']:GetCoreObject()

-- Code

-- // Loops \\ --

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
                            TriggerClientEvent('ls-prison::client:set:time', Player.PlayerData.source, JailTime)
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

-- // Commands \\ --

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
                        JailPlayer.Functions.SetJob("unemployed")
                        TriggerClientEvent('LSCore:Notify', JailPlayer.PlayerData.source, "Je bent werkloos..", 'error')
                    end
                    JailPlayer.Functions.SetMetaData("jailtime", Time)
                    TriggerClientEvent('ls-prison:client:set:in:jail', JailPlayer.PlayerData.source, Name, Time, JailPlayer.PlayerData.citizenid, os.date('%d-'..'%m-'..'%y'))
                end
            else
                TriggerClientEvent('LSCore:Notify', Player.PlayerData.source, "Je kan geen agent jailen..", 'error')
            end
        end
    end
end)

RegisterServerEvent('ls-prison:server:set:jail:leave')
AddEventHandler('ls-prison:server:set:jail:leave', function()
    local Player = LSCore.Functions.GetPlayer(source)
    Player.Functions.SetMetaData("jailtime", 0)
    Player.Functions.Save()
end)

RegisterServerEvent('ls-prison:server:set:jail:items')
AddEventHandler('ls-prison:server:set:jail:items', function(Time)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    Player.Functions.SetMetaData("jailitems", Player.PlayerData.inventory)
    Player.Functions.ClearInventory()
    Player.Functions.AddItem("water_bottle", 5)
    Player.Functions.AddItem("sandwich", 5)
    Citizen.SetTimeout(500, function()
        Player.Functions.Save()
    end)
end)

RegisterServerEvent('ls-prison:server:get:items:back')
AddEventHandler('ls-prison:server:get:items:back', function()
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    for k, v in pairs(Player.PlayerData.metadata["jailitems"]) do
        Player.Functions.AddItem(v.name, v.amount, false, v.info)
    end
    Player.Functions.SetMetaData("jailitems", nil)
end)

RegisterServerEvent('ls-prison:server:find:reward')
AddEventHandler('ls-prison:server:find:reward', function(reward)
    local Player = LSCore.Functions.GetPlayer(source)
    Player.Functions.AddItem(reward, 1, false, false, true)
    CheckForPrisonItems(source)
end)

RegisterServerEvent('ls-prison:server:set:alarm')
AddEventHandler('ls-prison:server:set:alarm', function(bool)
    TriggerClientEvent('ls-prison:client:set:alarm', -1, bool)
end)

-- // Funtions \\ --

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
            local RandomMin = math.random(3,5)
            if Player.PlayerData.metadata['jailtime'] - RandomMin > 0 then
                Player.PlayerData.metadata['jailtime'] = Player.PlayerData.metadata['jailtime'] - RandomMin
                TriggerClientEvent('LSCore:Notify', Player.PlayerData.source, "Je moet nog "..Player.PlayerData.metadata['jailtime'].." maand(en) zitten.", 'error')
            else
                TriggerClientEvent('LSCore:Notify', Player.PlayerData.source, "Je bent vrij joh!", 'success')
                Player.PlayerData.metadata['jailtime'] = 0
            end
            Player.Functions.Save()
            TriggerClientEvent('ls-prison::client:set:time', Player.PlayerData.source, Player.PlayerData.metadata['jailtime'])
        end
    end
end