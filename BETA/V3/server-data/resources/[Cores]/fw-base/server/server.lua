LSCore = {}
LSCore.Config = Config
LSCore.Shared = Shared
LSCore.ServerCallbacks = {}
LSCore.UseableItems = {}

function GetCoreObject()
	return LSCore
end

Webhooks = {
    ["default"] = "",
    ["anticheat"] = "",
    ["playermoney"] = "",
    ["playerinventory"] = "",
    ["robbing"] = "",
    ["cuffing"] = "",
    ["drop"] = "",
    ["trunk"] = "",
    ["stash"] = "",
    ["glovebox"] = "",
    ["banking"] = "",
    ["vehicleshop"] = "",
    ["vehicleupgrades"] ="", 
    ["shops"] = "", 
    ["storerobbery"] = "",
    ["dealers"] = "",
    ["bankrobbery"] = "",
    ["death"] = "",
    ["joinleave"] = "",
    ['chat'] = "",
    ['bans'] = "",
    ['heist'] = "",
    ['humanelabs'] = "",
    ["housing"] = "",
    ["casino"] = "",
    ["cheaters"] = "",
    ["realestate"] = "",
}

Colors = {
    ["default"] = 16711680,
    ["blue"] = 25087,
    ["green"] = 762640,
    ["white"] = 16777215,
    ["black"] = 0,
    ["orange"] = 16743168,
    ["lightgreen"] = 65309,
    ["yellow"] = 15335168,
    ["turqois"] = 62207,
    ["pink"] = 16711900,
    ["red"] = 16711680,
}

RegisterServerEvent('framework-logs:server:SendLog')
AddEventHandler('framework-logs:server:SendLog', function(name, title, color, message, tagEveryone)
    local tag = tagEveryone ~= nil and tagEveryone or false
    local webHook = Webhooks[name] ~= nil and Webhooks[name] or Webhooks["default"]
    local embedData = {
        {
         ["title"] = title,
         ["color"] = Colors[color] ~= nil and Colors[color] or Colors["default"],
         ["footer"] = {
         ["text"] = os.date("%c"),
         },
         ["description"] = message,
        }
    }
    Citizen.Wait(100)
    if tag then
      PerformHttpRequest(webHook, function(err, text, headers) end, 'POST', json.encode({ username = "Lotus Logs",embeds = embedData}), { ['Content-Type'] = 'application/json' })
      Citizen.Wait(200)
      PerformHttpRequest(webHook, function(err, text, headers) end, 'POST', json.encode({ username = "Lotus Logs", content = "@everyone"}), { ['Content-Type'] = 'application/json' })
    else
      PerformHttpRequest(webHook, function(err, text, headers) end, 'POST', json.encode({ username = "Lotus Logs",embeds = embedData}), { ['Content-Type'] = 'application/json' })
    end
end)


Citizen.CreateThread(function()
	LoadQueueDatabase()
end)

function LoadQueueDatabase()
	LSCore.Functions.ExecuteSql(false, "SELECT * FROM `server_extra`", function(result)
		if result[1] ~= nil then
			for k, v in pairs(result) do
				Config.Priority[v.steam] = tonumber(v.priority)
			end
		end
	end)
end