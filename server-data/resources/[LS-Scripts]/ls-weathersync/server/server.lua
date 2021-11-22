local LSCore = exports['ls-core']:GetCoreObject()

-- Code

-- Callback --

LSCore.Functions.CreateCallback("ls-weathersync:server:get:config", function(source, cb)
    cb(Config)
end)

-- // Loops \\ --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if Config.Syncing then
            if Config.SyncData['Minutes'] + 1 < 60 then
                Config.SyncData['Minutes'] = Config.SyncData['Minutes'] + 1
            else
                Config.SyncData['Minutes'] = 0
                if Config.SyncData['Hour'] + 1 < 24 then
                    Config.SyncData['Hour'] = Config.SyncData['Hour'] + 1
                else
                    Config.SyncData['Hour'] = 1
                end
            end
            TriggerClientEvent('ls-weathersync:client:sync', -1, Config)
            Citizen.Wait(2350)
        else
            Citizen.Wait(450)
        end
    end
end)

-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(4)
--         if Config.Syncing then
--             local NewWeather = GetRandomWeather(Config.SyncData['Weather'])
--             local WaitTime = 0
--             if Config.SyncData['Weather'] == 'RAIN' or Config.SyncData['Weather'] == 'THUNDER' then
--                 Config.SyncData['Weather'] = 'CLEARING'
--                 WaitTime = 1
--             elseif Config.SyncData['Weather'] == 'CLEARING' then
--                 Config.SyncData['Weather'] = 'EXTRASUNNY'
--                 WaitTime = 6
--             else
--                 Config.SyncData['Weather'] = NewWeather['Weather']
--                 WaitTime = NewWeather['MaxTime']
--             end
--             TriggerClientEvent('ls-weathersync:client:sync', -1, Config)
--             Citizen.Wait((60 * 1000) * (60 * WaitTime))
--         end
--     end
-- end)

-- // Commands \\ --

LSCore.Commands.Add("togglesync", "Toggle Weather Sync", {}, false, function(source, args)
    if Config.Syncing then
        Config.Syncing = false
    else
        Config.Syncing = true
    end
end, 'admin')

-- LSCore.Commands.Add("weather", "Weer Menu", {}, false, function(source, args)
--     TriggerClientEvent('ls-weathersync:client:open:weather:menu', source)
-- end, 'admin')

LSCore.Commands.Add("time", "Tijd Menu", {}, false, function(source, args)
    TriggerClientEvent('ls-weathersync:client:open:time:menu', source)
end, 'admin')

-- // Events \\ --

RegisterServerEvent('ls-weathersync:server:set:weather')
AddEventHandler('ls-weathersync:server:set:weather', function(data)
    Config.SyncData['Weather'] = data['Weather']
    TriggerClientEvent('ls-weathersync:client:sync', -1, Config)
end)

RegisterServerEvent('ls-weathersync:server:set:time')
AddEventHandler('ls-weathersync:server:set:time', function(data)
    Config.SyncData['Minutes'] = data['Minutes']
    Config.SyncData['Hour'] = data['Hour']
    TriggerClientEvent('ls-weathersync:client:sync', -1, Config)
end)

-- // Functions \\ --

function GetRandomWeather(CurrentWeather)
    local Found = false
    while not Found do 
        local RandomWeather = Config.WeatherTypes[math.random(1, #Config.WeatherTypes)]
        if RandomWeather['Weather'] ~= CurrentWeather and RandomWeather['AllowRandom'] then
            Found = true
            return RandomWeather
        end
    end
end

function GetCurrentTime()
    return Config.SyncData['Hour'], Config.SyncData['Minutes']
end