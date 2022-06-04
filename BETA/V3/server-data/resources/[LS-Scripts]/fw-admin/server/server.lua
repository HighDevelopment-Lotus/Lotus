local LSCore = exports['fw-base']:GetCoreObject()

-- Commands

LSCore.Commands.Add("kickall", "Kick iedereen uit de server", {}, false, function(source, args)
    local src = source
    
    if src > 0 then
        local reason = table.concat(args, ' ')
        local Player = LSCore.Functions.GetPlayer(src)

        if args[1] ~= nil then
            for k, v in pairs(LSCore.Functions.GetPlayers()) do
                local Player = LSCore.Functions.GetPlayer(v)
                if Player ~= nil then 
                    DropPlayer(Player.PlayerData.source, reason)
                end
            end
        else
            TriggerClientEvent('chatMessage', src, 'SYSTEM', 'Geef reden.')
        end
    else
        for k, v in pairs(LSCore.Functions.GetPlayers()) do
            local Player = LSCore.Functions.GetPlayer(v)
            if Player ~= nil then 
                DropPlayer(Player.PlayerData.source, "⚜️ Server Restart! Zie discord voor meer informatie je kunt over enkele minuten weer verbinden")
            end
        end
    end
end, 'god')

LSCore.Commands.Add("admin", "Open Admin Menu", {}, false, function(source, args)
    TriggerClientEvent('framework-admin:client:open:admin:menu', source)
end, 'god')

LSCore.Commands.Add("s", "Stuur een bericht naar alle staffleden en support", {{name="message", help="Type je bericht"}}, true, function(source, args)
    local Message = table.concat(args, " ")
    TriggerClientEvent('framework-admin:client:staffchat:message', -1, GetPlayerName(source), Message)
end, "admin")

LSCore.Commands.Add("openstash", "Open a stash of someone", {{name="stashid", help="Stash ID"}}, true, function(source, args)
    local Message = table.concat(args, " ")
    if Message ~= nil then
        TriggerClientEvent('framework-admin:client:openstash', source, Message)
    end
end, "god")

LSCore.Commands.Add("reporttoggle", "Toggle incoming reports off or on", {}, false, function(source, args)
    LSCore.Functions.ToggleOptin(source)
    if LSCore.Functions.IsOptin(source) then
        TriggerClientEvent('LSCore:Notify', source, "Reports Aan", "success")
    else
        TriggerClientEvent('LSCore:Notify', source, "Reports Uit", "error")
    end
end, "admin")

LSCore.Commands.Add("announce", "Send a message to everyone", {}, false, function(source, args)
    local Message = table.concat(args, " ")
    for i = 1, 3, 1 do
        TriggerClientEvent('chatMessage', -1, "SYSTEM", "error", Message)
    end
end, "god")

LSCore.Commands.Add("report", "Send a report to admins (only when needed, DO NOT USE THIS)", {{name="message", help="Type je bericht"}}, true, function(source, args)
    local Message = table.concat(args, " ")
    local Player = LSCore.Functions.GetPlayer(source)
    TriggerClientEvent('framework-admin:client:send:report', -1, GetPlayerName(source), source, Message)
    TriggerClientEvent('chatMessage', source, "REPORT SEND", "normal", Message)
    TriggerEvent("framework-logs:server:SendLog", "report", "Report", "green", "**"..GetPlayerName(source).."** (CitizenID: "..Player.PlayerData.citizenid.." | ID: "..source..") **Report:** " ..Message, false)
end)

LSCore.Commands.Add("reportr", "Reply to report", {}, false, function(source, args)
    local PlayerId = tonumber(args[1])
    table.remove(args, 1)
    local Message = table.concat(args, " ")
    local OtherPlayer = LSCore.Functions.GetPlayer(PlayerId)
    local Player = LSCore.Functions.GetPlayer(source)
    if OtherPlayer ~= nil then
        TriggerClientEvent('chatMessage', PlayerId, "ADMIN - "..GetPlayerName(source), "reportr", Message)
        TriggerEvent("framework-logs:server:SendLog", "report", "Report Reply", "red", "**"..GetPlayerName(source).."** replied to: **"..OtherPlayer.PlayerData.name.. " **(ID: "..OtherPlayer.PlayerData.source..") **Message:** " ..Message, false)
        for k, v in pairs(LSCore.Functions.GetPlayers()) do
            if LSCore.Functions.HasPermission(v, "admin") then
                if LSCore.Functions.IsOptin(v) then
                    TriggerClientEvent('chatMessage', v, "Report Antwoord ("..source..") - "..GetPlayerName(source), "reportr", Message)
                end
            end
        end
    else
        TriggerClientEvent('LSCore:Notify', source, "Speler niet online", "error")
    end
end, "admin")

LSCore.Functions.CreateCallback('framework-admin:server:set:job', function(source, cb, job)
    local Player = LSCore.Functions.GetPlayer(source)
    Player.Functions.SetJob(job, 1)
end)

LSCore.Commands.Add("admincar", "Save vehicle in your garage", {{name="id", help="Type id of player"}}, false, function(source, args)
    if args[1] == nil then
        local ply = LSCore.Functions.GetPlayer(source)
        TriggerClientEvent('framework-admin:client:SaveCar', source)
    else
        local ply = LSCore.Functions.GetPlayer(tonumber(args[1]))
        TriggerClientEvent('framework-admin:client:SaveCar', ply.PlayerData.source, tonumber(args[1]))
    end
end, "god")

-- Events

RegisterNetEvent('framework-admin:server:SaveCar', function(mods, vehicle, plate, target)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    print(Player.PlayerData.citizenid)
    if target ~= nil then
        Player = LSCore.Functions.GetPlayer(target)
    end
    local vehiclemeta = {Fuel = 100, Body = 1000.0, Engine = 1000.0}
    local result = exports.oxmysql:executeSync('SELECT plate FROM player_vehicles WHERE plate = ?', { plate })
    if result[1] == nil then
        exports.oxmysql:insert('INSERT INTO player_vehicles (steam, citizenid, vehicle, plate, garage, state, mods, metadata) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', {
            Player.PlayerData.steam,
            Player.PlayerData.citizenid,
            vehicle.Model,
            plate,
            'Alta Parking',
            'in',
            json.encode(mods),
            json.encode(vehiclemeta)
        })
        TriggerClientEvent('chatMessage', Player.PlayerData.source, "SYSTEM", "inform", "Je hebt een voertuig gekregen: ".. vehicle.Name .." met kenteken: ".. plate ..".")
    else
        TriggerClientEvent('LSCore:Notify', src, 'Deze kenteken is al in gebruik door iemand anders', 'error', 3000)
    end
end)

RegisterNetEvent('framework-admin:server:log:action', function(message)
    local src = source
    local group = LSCore.Functions.GetPermission(src)
    TriggerClientEvent('framework-admin:client:log:action', -1, message, group)
end)

RegisterNetEvent('framework-admin:Server:ToggleVisibility', function(src, bool)
    TriggerClientEvent('framework-admin:Client:ToggleVisibility', src, bool)
end)

RegisterNetEvent('framework-admin:server:slay:player', function(TargetPlayer)
    if LSCore.Functions.HasPermission(source, Config.AdminPerms['KillPlayer']) then
        TriggerClientEvent("framework-admin:client:slay:player", TargetPlayer)
    end
end)

RegisterNetEvent('framework-admin:server:kick:chosen:player', function(TargetPlayer, Reason)
    if LSCore.Functions.HasPermission(source, Config.AdminPerms['KickPlayer']) then
        DropPlayer(TargetPlayer, "\n🛑 You've been kicked from the server!\n🛑 Reason: "..Reason.."\n\n")
    end
end)

RegisterNetEvent('framework-admin:server:bring:chosen:player', function(TargetPlayer, Coords)
    if LSCore.Functions.HasPermission(source, Config.AdminPerms['BringPlayer']) then
        TriggerClientEvent('framework-admin:client:bring:chosen:player', TargetPlayer, Coords)
    end
end)

RegisterNetEvent('framework-admin:server:opem:skin:menu', function(TargetPlayer)
    TriggerClientEvent("framework-clothing:client:openMenu", TargetPlayer)
end)

RegisterNetEvent('framework-admin:server:give:item', function(ItemName, ItemAmount)
    if LSCore.Functions.HasPermission(source, Config.AdminPerms['SpawnItem']) then
        local Player = LSCore.Functions.GetPlayer(source)
        if not Player.Functions.AddItem(ItemName, ItemAmount, false, false, true, "Inventory") then
            TriggerClientEvent('LSCore:Notify', source, "Je bent te zwaar", "error")
        end
    end
end)

RegisterNetEvent('framework-admin:server:set:job', function(JobName, JobGrade)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    Player.Functions.SetJob(JobName, JobGrade, 'admin-menu-setjob')
    TriggerClientEvent('LSCore:Notify', src, 'Job '..LSCore.Shared.Jobs[JobName].label..' - '..LSCore.Shared.Jobs[JobName].grades[JobGrade].label..' gegeven', 'success')
end)

RegisterNetEvent('framework-admin:server:send:report', function(Name, TargetSrc, Message)
    if LSCore.Functions.HasPermission(source, "admin") then
        if LSCore.Functions.IsOptin(source) then
            TriggerClientEvent('chatMessage', source, "REPORT - "..Name.." ("..TargetSrc..")", "report", Message)
        end
    end
end)

RegisterNetEvent('framework-admin:server:staffchat:message', function(Name, Message)
    if LSCore.Functions.HasPermission(source, "admin") then
        if LSCore.Functions.IsOptin(source) then
            TriggerClientEvent('chatMessage', source, "STAFFCHAT - "..Name, "error", Message)
        end
    end
end)