-- local LoggedIn, LSCore = false, exports['fw-base']:GetCoreObject()

-- RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
-- AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
--     Citizen.SetTimeout(1250, function() 
--         LoggedIn = true
--     end)
-- end)

-- Code

RegisterNetEvent('framework-crafting:client:open:crafting')
AddEventHandler('framework-crafting:client:open:crafting', function()
	Citizen.SetTimeout(150, function()
		local CraftingData = {['Type'] = 'Crafting', ['InvName'] = 'Workbench', ['Items'] = GetThresholdItems(Config.CraftingItems)}
		TriggerServerEvent('framework-inv:server:open:inventory:other', CraftingData, 'Crafting')
		TriggerServerEvent("LSCore:Server:SetMetaData", "iscrafting", true)
	end)
end)

-- // Function \\ --

function GetThresholdItems(Items)
	local ReturnItems = {}
	for k, v in pairs(Items) do
		if LSCore.Functions.GetPlayerData().metadata["craftingrep"] >= v['PointsNeeded'] then
			ReturnItems[k] = Items[k]
		end
	end
	return ReturnItems
end