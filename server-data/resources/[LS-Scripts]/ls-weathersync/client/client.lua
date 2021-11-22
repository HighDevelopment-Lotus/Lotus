local LSCore, LoggedIn, CanSync = exports['ls-core']:GetCoreObject(), false, false

RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
    LoggedIn, CanSync = true, true
    SetupSyncing()
end)

RegisterNetEvent('LSCore:Client:OnPlayerUnload')
AddEventHandler('LSCore:Client:OnPlayerUnload', function()
    LoggedIn, CanSync = false, false
end)

-- Citizen.CreateThread(function()
--     Citizen.SetTimeout(2000, function()
--         LoggedIn, CanSync = true, true
--         SetupSyncing()
--      end)
-- end)

-- Code

-- // Events \\ --

RegisterNetEvent('ls-weathersync:client:sync')
AddEventHandler('ls-weathersync:client:sync', function(ConfigData)
    if CanSync then
        Citizen.SetTimeout(25, function()
            NetworkOverrideClockTime(ConfigData.SyncData['Hour'], ConfigData.SyncData['Minutes'], 0)
            if ConfigData.SyncData['Weather'] ~= Config.SyncData['Weather'] then
                SetWeatherTypeOverTime(ConfigData.SyncData['Weather'], 15.0)
                if ConfigData.SyncData['Weather'] == 'XMAS' then
                    SetForceVehicleTrails(true)
	    	    	SetForcePedFootstepsTracks(true)
	    	    else
	    	    	SetForceVehicleTrails(false)
	    	    	SetForcePedFootstepsTracks(false)
	    	    end
            end
            Config = ConfigData
        end)
    end
end)

RegisterNetEvent('ls-weathersync:client:open:weather:menu')
AddEventHandler('ls-weathersync:client:open:weather:menu', function()
    local MenuItems = {}
    for k, v in pairs(Config.WeatherTypes) do
        local TempData = {}
        TempData['Title'] = v['Label']
        TempData['Desc'] = 'Klik om het weer te veranderen.'
        TempData['Data'] = {['Event'] = 'ls-weathersync:server:set:weather', ['Type'] = 'Server', ['Weather'] = v['Weather']}
        table.insert(MenuItems, TempData)
    end
    if (#MenuItems > 0) then
        local Data = {['Title'] = 'Weer Bediening', ['MainMenuItems'] = MenuItems}
        LSCore.Functions.OpenMenu(Data)
    end
end)

RegisterNetEvent('ls-weathersync:client:open:time:menu')
AddEventHandler('ls-weathersync:client:open:time:menu', function()
    local MenuItems = {}
    for k, v in pairs(Config.TimeStamps) do
        local TempData = {}
        TempData['Title'] = v['Label']..' ('..v['Hour']..':'..v['Minutes']..'0)'
        TempData['Desc'] = 'Klik om de tijd te veranderen.'
        TempData['Data'] = {['Event'] = 'ls-weathersync:server:set:time', ['Type'] = 'Server', ['Hour'] = v['Hour'], ['Minutes'] = v['Minutes']}
        table.insert(MenuItems, TempData)
    end
    if (#MenuItems > 0) then
        local Data = {['Title'] = 'Tijd Bediening', ['MainMenuItems'] = MenuItems}
        LSCore.Functions.OpenMenu(Data)
    end
end)

-- // Functions \\ --

function SetupSyncing()
    LSCore.Functions.TriggerCallback('ls-weathersync:server:get:config', function(ConfigData)
        Config = ConfigData
        NetworkOverrideClockTime(ConfigData.SyncData['Hour'], ConfigData.SyncData['Minutes'], 0)
        SetWeatherTypePersist(ConfigData.SyncData['Weather'])
        SetWeatherTypeNow(ConfigData.SyncData['Weather'])
        SetWeatherTypeNowPersist(ConfigData.SyncData['Weather'])
        SetRainFxIntensity(-1.0)
    end)
end

function GetCurrentTime()
    return Config.SyncData['Hour'], Config.SyncData['Minutes']
end

function SetClientSync(Bool)
    CanSync = Bool
    if not CanSync then
        SetRainFxIntensity(0.0)
        NetworkOverrideClockTime(23, 0, 0)
        SetWeatherTypePersist('EXTRASUNNY')
        SetWeatherTypeNow('EXTRASUNNY')
        SetWeatherTypeNowPersist('EXTRASUNNY')
    else
        SetRainFxIntensity(-1.0)
        NetworkOverrideClockTime(Config.SyncData['Hour'], Config.SyncData['Minutes'], 0)
        SetWeatherTypePersist(Config.SyncData['Weather'])
        SetWeatherTypeNow(Config.SyncData['Weather'])
        SetWeatherTypeNowPersist(Config.SyncData['Weather'])
    end
end