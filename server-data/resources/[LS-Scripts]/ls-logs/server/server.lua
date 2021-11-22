LSCore = nil

TriggerEvent('LSCore:GetObject', function(obj) LSCore = obj end)

RegisterServerEvent('ls-logs:server:SendLog')
AddEventHandler('ls-logs:server:SendLog', function(name, title, color, message, tagEveryone)
    local tag = tagEveryone ~= nil and tagEveryone or false
    local webHook = Config.Webhooks[name] ~= nil and Config.Webhooks[name] or Config.Webhooks["default"]
    local embedData = {
        {
         ["title"] = title,
         ["color"] = Config.Colors[color] ~= nil and Config.Colors[color] or Config.Colors["default"],
         ["footer"] = {
         ["text"] = os.date("%c"),
         },
         ["description"] = message,
        }
    }
    Citizen.Wait(100)
    if tag then
      PerformHttpRequest(webHook, function(err, text, headers) end, 'POST', json.encode({ username = "Lotus Logs", content = "@everyone"}), { ['Content-Type'] = 'application/json' })
    else
      PerformHttpRequest(webHook, function(err, text, headers) end, 'POST', json.encode({ username = "Lotus Logs",embeds = embedData}), { ['Content-Type'] = 'application/json' })
    end
end)

AddEventHandler('chatMessage', function(author, color, message)
    if source ~= nil then
      TriggerEvent("ls-logs:server:SendLog", "chat", "Speler Chat", "blue", "**".. GetPlayerName(author) .. "** zegt: **" ..message.."**")
    end
end)