LSCore = exports["fw-base"]:GetCoreObject()

-- Code

LSCore.Commands.Add("eventmovie", "", {{name="toggle", help="Yes or No"}}, true, function(source, args)
	if args[1] == "Yes" then
		TriggerClientEvent("framework-event:client:EventMovie", -1)
		-- Wait(5000)
		-- TriggerEvent('framework-weathersync:server:setTime', 01, 00)
		-- TriggerEvent('framework-weathersync:server:setWeather', "thunder")
		-- exports['framework-weathersync']:ToggleBlackout()
		-- exports['framework-weathersync']:FreezeElement('time')
	elseif args[1] == "No" then
		-- TriggerEvent('framework-weathersync:server:setTime', 12, 00)
		-- TriggerEvent('framework-weathersync:server:setWeather', "extrasunny")
		-- exports['framework-weathersync']:ToggleBlackout()
		-- exports['framework-weathersync']:FreezeElement('time')
	end
end, 'admin')