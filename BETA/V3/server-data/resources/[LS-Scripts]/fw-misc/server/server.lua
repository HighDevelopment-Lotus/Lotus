local LSCore = exports['fw-base']:GetCoreObject()

LSCore.Functions.CreateCallback('framework-blackout:server:get:config', function(source, cb)
    cb(Config)
end)

LSCore.Functions.CreateCallback('framework-stores:server:GetConfig', function(source, cb)
    cb(Config)
end)

RegisterNetEvent('framework-ui:server:addskill')
AddEventHandler('framework-ui:server:addskill', function(skill, punten)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
	if Player ~= nil then
        -- if skill ~= nil and punten ~= nil then
            Player.Functions.SetMetaData(skill, Player.PlayerData.metadata[skill] + punten)
            TriggerClientEvent('LSCore:Notify', src, 'Reputatie gekregen', 'primary')
        -- end
    end
end)

RegisterNetEvent('framework-ui:server:removeskill')
AddEventHandler('framework-ui:server:removeskill', function(skill, punten)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
	if Player ~= nil then
        -- if skill ~= nil and punten ~= nil then
            Player.Functions.SetMetaData(skill, Player.PlayerData.metadata[skill] - punten)
            TriggerClientEvent('LSCore:Notify', src, 'Reputatie verloren', 'primary')
        -- end
    end
end)

LSCore.Commands.Add("sling", "Change weapon sling position", {}, false, function(source, args)
	TriggerClientEvent("framework-misc:client:sling", source)
end)


RegisterServerEvent('framework-paintball:server:recieve:gun')
AddEventHandler('framework-paintball:server:recieve:gun', function()
    local Player = LSCore.Functions.GetPlayer(source)
    Player.Functions.AddItem('weapon_snspistol', 1, false, false, true)
end)

RegisterServerEvent('framework-paintball:server:remove:gun')
AddEventHandler('framework-paintball:server:remove:gun', function()
    local Player = LSCore.Functions.GetPlayer(source)
    TriggerClientEvent('framework-paintball:client:removegun', source)
    Player.Functions.RemoveItem('weapon_snspistol', 1, false, false, true)
end)

RegisterServerEvent('framework-paintball:server:buy:ammo')
AddEventHandler('framework-paintball:server:buy:ammo', function()
    local Player = LSCore.Functions.GetPlayer(source)
	if Player.PlayerData.money['cash'] >= 250 then
        Player.Functions.RemoveMoney("cash", "250")
        Player.Functions.AddItem('paintball_ammo', 2, false, false, true)
    else
        TriggerClientEvent('LSCore:Notify', source, "Je hebt geen 250 euro over voor 2 nieuwe mags")
    end
end)


-- Code
RegisterServerEvent('framework-blackout:server:blackout:enable:power')
AddEventHandler('framework-blackout:server:blackout:enable:power', function()
    local Player = LSCore.Functions.GetPlayer(source)

    if Player.PlayerData.job.name == 'police' then
        if Player.PlayerData.job.onduty then
            if Config.Blackout['Options']['BlackoutActive'] then
                if not Config.Blackout['Options']['PoliceActivated'] then
                    TriggerEvent('framework-blackout:server:blackout:set:config:value', 'Options', 'PoliceActivated', true)
                    TriggerClientEvent('LSCore:Notify', source, 'The power will be back up soon..', 'success')
                    Citizen.Wait(60000 * 15)
                    TriggerEvent('framework-blackout:server:blackout:set:config:value', 'Options', 'BlackoutActive', false)
                    TriggerEvent('framework-blackout:server:blackout:set:config:value', 'Options', 'PoliceActivated', false)
                    TriggerClientEvent('framework-weathersync:server:toggle:blackout', source, false)
                else
                    TriggerClientEvent('LSCore:Notify', source, 'Were working hard on it..', 'primary')
                end
            else
                TriggerClientEvent('LSCore:Notify', source, 'There is no power outage yet..', 'error')
            end
        else
            TriggerClientEvent('LSCore:Notify', source, 'Youre not on duty..', 'error')
        end
    else
        TriggerClientEvent('LSCore:Notify', source, 'Wut..', 'error')
    end

end)

RegisterServerEvent('framework-blackout:server:blackout:set:config:value')
AddEventHandler('framework-blackout:server:blackout:set:config:value', function(Type, Type2, Value)
    Config.Blackout[Type][Type2] = Value
    TriggerClientEvent('framework-blackout:client:blackout:set:config:value', -1, Type, Type2, Value)
end)

LSCore.Commands.Add("resetblackout", "Ja wat zou dit nou doen eh ?", {}, false, function(source, args)
    TriggerEvent('framework-weathersync:server:toggle:blackout', false)
end, "admin")

LSCore.Commands.Add("doblackout", "Ja wat zou dit nou doen eh ?", {}, false, function(source, args)
    TriggerEvent('framework-weathersync:server:toggle:blackout', true)
end, "admin")

LSCore.Commands.Add("c-dance", "stop met dansen", {}, false, function(source, args)
    TriggerClientEvent('framework-dances:client:clear:dance', source)
end)

LSCore.Commands.Add("dance", "Eventjes lekker dansen", {{name="number", help="een nummer of gewoon niks"}}, false, function(source, args)
    if args[1] ~= nil then
        local DanceNumber = tonumber(args[1])
        TriggerClientEvent('framework-dances:client:dance', source, DanceNumber)
    else
        TriggerClientEvent('framework-dances:client:dance', source, -1)
    end
end)