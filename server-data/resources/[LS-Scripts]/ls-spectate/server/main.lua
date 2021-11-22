local LSCore = exports['ls-core']:GetCoreObject()

LSCore.Commands.Add("spectate", "Spectate een speler", {}, false, function(source, args)
    TriggerClientEvent('ls-spectate:spectate', source)
end, "admin")

LSCore.Functions.CreateCallback('ls-spectate:getOtherPlayerData', function(source, cb, target)
        local src = source
        local Player = LSCore.Functions.GetPlayer(src)
        if Player ~= nil then
            local playerData = Player.PlayerData
            local char = playerData.charinfo
            local data = {
                name = GetPlayerName(target),
                job = PlayerData.job.label .. " - " .. PlayerData.job.onduty,
                inventory = PlayerData.items,
                firstname = char.firstname,
                lastname = char.lastname,
                sex = char.gender,
                dob = char.birthdate,
                money = playerData.money['cash'],
                bank = playerData.money['bank']
            }

            cb(data)
        end
end)

LSCore.Commands.Add("spectateRadio", "Spectate een speler (radio)", {}, false, function(source, args)
    TriggerClientEvent('ls-spectate:radioSwitch', source)
end, "admin")
