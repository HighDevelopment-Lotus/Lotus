local LSCore = exports['fw-base']:GetCoreObject()

-- Code

-- // Command \\ --

RegisterCommand('AdminPanelKick', function(source, args, rawCommand)
    if source == 0 then
        local ServerId = tonumber(args[1])
        table.remove(args, 1)
        local Msg = table.concat(args, " ")
        DropPlayer(ServerId, "\n🛑 Je bent gekicked uit de server!\nReden: "..Msg)
    end
end, false)

RegisterCommand('AdminPanelAddItem', function(source, args, rawCommand)
    if source == 0 then
        local ServerId, ItemName, ItemAmount = tonumber(args[1]), tostring(args[2]), tonumber(args[3])
        local Player = LSCore.Functions.GetPlayer(ServerId)
        if Player ~= nil then
            Player.Functions.AddItem(ItemName, ItemAmount, false, false, true)
        end
    end
end, false)

RegisterCommand('AdminPanelAddMoney', function(source, args, rawCommand)
    if source == 0 then
        local ServerId, Amount = tonumber(args[1]), tonumber(args[2])
        local Player = LSCore.Functions.GetPlayer(ServerId)
        if Player ~= nil then
            Player.Functions.AddMoney('cash', Amount)
        end
    end
end, false)

RegisterCommand('AdminPanelSetJob', function(source, args, rawCommand)
    if source == 0 then
        local ServerId, JobName = tonumber(args[1]), tostring(args[2])
        local Player = LSCore.Functions.GetPlayer(ServerId)
        if Player ~= nil then
            Player.Functions.SetJob(JobName)
        end
    end
end, false)

LSCore.Commands.Add("admin", "Open het admin menu", {}, false, function(source, args)
    TriggerClientEvent('framework-admin:client:open:admin:menu', source)
end, 'admin')

LSCore.Commands.Add("s", "Bericht naar alle staff sturen", {{name="bericht", help="Bericht die je wilt sturen"}}, true, function(source, args)
    local Message = table.concat(args, " ")
    TriggerClientEvent('framework-admin:client:staffchat:message', -1, GetPlayerName(source), Message)
end, "admin")

LSCore.Commands.Add("openstash", "Open een stash van iemand", {{name="stashid", help="Stash ID"}}, true, function(source, args)
    local Message = table.concat(args, " ")
    if Message ~= nil then
        TriggerClientEvent('framework-admin:client:openstash', source, Message)
    end
end, "admin")

LSCore.Commands.Add("reporttoggle", "Toggle inkomende reports uit of aan", {}, false, function(source, args)
    LSCore.Functions.ToggleOptin(source)
    if LSCore.Functions.IsOptin(source) then
        TriggerClientEvent('LSCore:Notify', source, "Je krijgt WEL reports", "success")
    else
        TriggerClientEvent('LSCore:Notify', source, "Je krijgt GEEN reports", "error")
    end
end, "admin")

LSCore.Commands.Add("announce", "Stuur een bericht naar iedereen", {}, false, function(source, args)
    local Message = table.concat(args, " ")
    for i = 1, 3, 1 do
        TriggerClientEvent('chatMessage', -1, "SYSTEM", "error", Message)
    end
end, "admin")

LSCore.Commands.Add("report", "Stuur een report naar admins (alleen wanneer nodig, MAAK HIER GEEN MISBRUIK VAN)", {{name="bericht", help="Bericht die je wilt sturen"}}, true, function(source, args)
    local Message = table.concat(args, " ")
    local Player = LSCore.Functions.GetPlayer(source)
    TriggerClientEvent('framework-admin:client:send:report', -1, GetPlayerName(source), source, Message)
    TriggerClientEvent('chatMessage', source, "REPORT VERSTUURD", "normal", Message)
    TriggerEvent("framework-logs:server:SendLog", "report", "Report", "green", "**"..GetPlayerName(source).."** (CitizenID: "..Player.PlayerData.citizenid.." | ID: "..source..") **Report:** " ..Message, false)
end)

LSCore.Commands.Add("reportr", "Reply op een report", {}, false, function(source, args)
    local PlayerId = tonumber(args[1])
    table.remove(args, 1)
    local Message = table.concat(args, " ")
    local OtherPlayer = LSCore.Functions.GetPlayer(PlayerId)
    local Player = LSCore.Functions.GetPlayer(source)
    if OtherPlayer ~= nil then
        TriggerClientEvent('chatMessage', PlayerId, "ADMIN - "..GetPlayerName(source), "reportr", Message)
        TriggerEvent("framework-logs:server:SendLog", "report", "Report Reply", "red", "**"..GetPlayerName(source).."** reageerde op: **"..OtherPlayer.PlayerData.name.. " **(ID: "..OtherPlayer.PlayerData.source..") **Bericht:** " ..Message, false)
        for k, v in pairs(LSCore.Functions.GetPlayers()) do
            if LSCore.Functions.HasPermission(v, "admin") then
                if LSCore.Functions.IsOptin(v) then
                    TriggerClientEvent('chatMessage', v, "ReportReply("..source..") - "..GetPlayerName(source), "reportr", Message)
                end
            end
        end
    else
        TriggerClientEvent('LSCore:Notify', source, "Persoon is niet online", "error")
    end
end, "admin")

-- // Events \\ --

RegisterServerEvent('framework-admin:server:slay:player')
AddEventHandler('framework-admin:server:slay:player', function(TargetPlayer)
    if LSCore.Functions.HasPermission(source, Config.AdminPerms['KillPlayer']) then
        TriggerClientEvent("framework-admin:client:slay:player", TargetPlayer)
    end
end)

RegisterServerEvent('framework-admin:server:kick:chosen:player')
AddEventHandler('framework-admin:server:kick:chosen:player', function(TargetPlayer, Reason)
    if LSCore.Functions.HasPermission(source, Config.AdminPerms['KickPlayer']) then
        DropPlayer(TargetPlayer, "\n🛑 Je bent gekicked uit de server!\n🛑 Reden: "..Reason.."\n\n")
    end
end)

RegisterServerEvent('framework-admin:server:bring:chosen:player')
AddEventHandler('framework-admin:server:bring:chosen:player', function(TargetPlayer, Coords)
    if LSCore.Functions.HasPermission(source, Config.AdminPerms['BringPlayer']) then
        TriggerClientEvent('framework-admin:client:bring:chosen:player', TargetPlayer, Coords)
    end
end)

RegisterServerEvent('framework-admin:server:opem:skin:menu')
AddEventHandler('framework-admin:server:opem:skin:menu', function(TargetPlayer)
 --   TriggerClientEvent("framework-clothing:client:openMenu", TargetPlayer)
      TriggerClientEvent("fivem-appearance:outfitsMenu", TargetPlayer)
end)

RegisterServerEvent('framework-admin:server:give:item')
AddEventHandler('framework-admin:server:give:item', function(ItemName, ItemAmount)
    if LSCore.Functions.HasPermission(source, Config.AdminPerms['SpawnItem']) then
        local Player = LSCore.Functions.GetPlayer(source)
        if not Player.Functions.AddItem(ItemName, ItemAmount, false, false, true, "Inventory") then
            TriggerClientEvent('LSCore:Notify', source, "Je bent te dik..", "error")
        end
    end
end)

RegisterServerEvent('framework-admin:server:send:report')
AddEventHandler('framework-admin:server:send:report', function(Name, TargetSrc, Message)
    if LSCore.Functions.HasPermission(source, "admin") then
        if LSCore.Functions.IsOptin(source) then
            TriggerClientEvent('chatMessage', source, "REPORT - "..Name.." ("..TargetSrc..")", "report", Message)
        end
    end
end)

RegisterServerEvent('framework-admin:server:staffchat:message')
AddEventHandler('framework-admin:server:staffchat:message', function(Name, Message)
    if LSCore.Functions.HasPermission(source, "admin") then
        if LSCore.Functions.IsOptin(source) then
            TriggerClientEvent('chatMessage', source, "STAFFCHAT - "..Name, "error", Message)
        end
    end
end)