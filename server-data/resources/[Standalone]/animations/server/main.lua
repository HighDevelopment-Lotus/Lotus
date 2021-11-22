local LSCore = exports['ls-core']:GetCoreObject()

-- Code

LSCore.Commands.Add("am", "Toggle animatie menu", {}, false, function(source, args)
	local Player = LSCore.Functions.GetPlayer(source)
	if not Player.PlayerData.metadata['ishandcuffed'] then
		TriggerClientEvent('animations:client:ToggleMenu', source)
	end
end)

LSCore.Commands.Add("a", "Gebruik een animatie, voor animatie lijst doe /em", {{name = "naam", help = "Emote naam"}}, true, function(source, args)
	local Player = LSCore.Functions.GetPlayer(source)
	if not Player.PlayerData.metadata['ishandcuffed'] then
		TriggerClientEvent('animations:client:EmoteCommandStart', source, args)
	end
end)