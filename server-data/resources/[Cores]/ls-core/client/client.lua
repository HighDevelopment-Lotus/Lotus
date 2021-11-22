LSCore = {}
LSCore.PlayerData = {}
LSCore.Config = Config
LSCore.Shared = Shared
LSCore.ServerCallbacks = {}

LoggedIn = false

RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
	exports.spawnmanager:setAutoSpawn(false)
	LoggedIn = true
end)

RegisterNetEvent('LSCore:Client:OnPlayerUnload')
AddEventHandler('LSCore:Client:OnPlayerUnload', function()
    LoggedIn = false
end)

-- // Function \\ --

function GetCoreObject()
	return LSCore
end