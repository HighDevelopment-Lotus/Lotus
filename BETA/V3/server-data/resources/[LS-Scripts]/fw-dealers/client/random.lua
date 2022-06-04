local LSCore, LoggedIn, ActivePeds, NearDealer = exports['fw-base']:GetCoreObject(), false, {}, false

RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1250, function()
	    LSCore.Functions.TriggerCallback("framework-randomdealer:server:get:config", function(config)
            Config = config
        end)
       	LoggedIn = true
    end)
end)

RegisterNetEvent('LSCore:Client:OnPlayerUnload')
AddEventHandler('LSCore:Client:OnPlayerUnload', function()
    LoggedIn = false
end)

-- Code

-- // Loops \\ --

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(4)
		if LoggedIn and Config.CurrentDealerData ~= nil and Config.CurrentDealerData['Coords'] ~= nil then
			NearDealer = false
			local PlayerCoords = GetEntityCoords(PlayerPedId())
			local Distance = #(PlayerCoords - vector3(Config.CurrentDealerData['Coords'].x,  Config.CurrentDealerData['Coords'].y, Config.CurrentDealerData['Coords'].z))
			if Distance < 3.0 then
				NearDealer = true
			elseif Distance < 50.0 then
				--if not NpcActive then
				--	NpcActive = true
				--end
			end
			if not NearDealer then
				Citizen.Wait(450)
			end
		else
			Citizen.Wait(450)
		end
	end
end)

-- // Events \\ --

RegisterNetEvent('framework-randomdealer:client:talk')
AddEventHandler('framework-randomdealer:client:talk', function()
	local ClosestPlayer, Distance = LSCore.Functions.GetClosestPlayer()
	if ClosestPlayer ~= -1 and Distance < 5.0 then
		LSCore.Functions.Notify('Er staat iemand anders te dicht bij joh..', 'error')
	else
		if exports['fw-inv']:CanOpenInventory() then
			local Shop = {['Type'] = 'Store', ['SubType'] = 'WeaponDealer', ['InvName'] = 'Anoniem', ['Items'] = Config.CurrentDealerData['Inventory']}
			TriggerServerEvent('framework-inv:server:open:inventory:other', Shop, 'Store')
		end
	end
end)

RegisterNetEvent('framework-randomdealer:client:sync:data')
AddEventHandler('framework-randomdealer:client:sync:data', function(Data)
	Config.CurrentDealerData = Data
end)

RegisterNetEvent('framework-randomdealer:client:set:dealer:data')
AddEventHandler('framework-randomdealer:client:set:dealer:data', function(Data, Type)
	Config.CurrentDealerData = Data
	if Type == 'Set' then
		exports['fw-assets']:RequestModelHash('a_m_m_eastsa_01')
        local NpcPed = CreatePed(4, 'a_m_m_eastsa_01', Config.CurrentDealerData['Coords'].x, Config.CurrentDealerData['Coords'].y, Config.CurrentDealerData['Coords'].z - 0.95, Config.CurrentDealerData['Coords'].w, false, false)
        FreezeEntityPosition(NpcPed, true)
        SetEntityInvincible(NpcPed, true)
        SetBlockingOfNonTemporaryEvents(NpcPed, true)
		TaskStartScenarioInPlace(NpcPed, 'WORLD_HUMAN_SMOKING', 0, true)
		table.insert(ActivePeds, NpcPed)
	elseif Type == 'Delete' then
		for k, v in pairs(ActivePeds) do
			DeleteEntity(v)
		end
		ActivePeds = {}
	end
end)

-- // Functions \\ --

function NearNpc()
	return NearDealer
end