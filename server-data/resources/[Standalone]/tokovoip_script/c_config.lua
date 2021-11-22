TokoVoipConfig = {
	refreshRate = 100,
	networkRefreshRate = 2000,
	playerListRefreshRate = 5000,
	minVersion = "1.5.0",
	enableDebug = false,
	distance = {
		3,
		8,
		13,
		28,
	},
	headingType = 1,
	radioKey = Keys["CAPS"],
	keySwitchChannels = Keys["~"],
	keySwitchChannelsSecondary = Keys["LEFTSHIFT"],
	keyProximity = Keys["~"],
	radioClickMaxChannel = 500,
	radioAnim = true,
	radioEnabled = true,
	wsServer = "135.125.188.16:33250",
	plugin_data = {
		TSChannel = "[TokoVoip] Lobby",
		TSPassword = "sdf4hhsdfik",
		TSChannelWait = "[TokoVoip] Wachtkamer",
		TSServer = "voice.lotusrp.nl",
		TSChannelSupport = "Support Wachtkamer",
		TSDownload = "",
		TSChannelWhitelist = {
			"Support Wachtkamer",
			"Support 2",
		},
		local_click_on = true,
		local_click_off = true,
		remote_click_on = true,
		remote_click_off = true,
		enableStereoAudio = true,
	    ClickVolume = -15,
		localName = "Speler",
		localNamePrefix = "[" .. GetPlayerServerId(PlayerId()) .. "] ",
	}
};

AddEventHandler("onClientResourceStart", function(resource)
	if (resource == GetCurrentResourceName()) then
		Citizen.CreateThread(function()
			if(TokoVoipConfig.plugin_data.localName == '') then
				TokoVoipConfig.plugin_data.localName = "Speler"
			end
		end);
		TriggerEvent("initializeVoip");
	end
end)

function SetTokoProperty(key, value)
	if TokoVoipConfig[key] ~= nil and TokoVoipConfig[key] ~= "plugin_data" then
		TokoVoipConfig[key] = value
		if voip then
			if voip.config then
				if voip.config[key] ~= nil then
					voip.config[key] = value
				end
			end
		end
	end
end

exports("SetTokoProperty", SetTokoProperty)
