
LSCore = exports["fw-base"]:GetCoreObject()
cachedData = {}

local JobBusy = false
local CanSell = true
-- function CreateBlips()
-- 	for i, zone in ipairs(Config.FishingZones) do
-- 		local coords = zone.secret and ((zone.coords / 1.5) - 133.37) or zone.coords
-- 		local name = zone.name
-- 		if not zone.secret then
-- 			local x = AddBlipForCoord(coords)
-- 			SetBlipSprite (x, 405)
-- 			SetBlipDisplay(x, 4)
-- 			SetBlipScale  (x, 0.35)
-- 			SetBlipAsShortRange(x, true)
-- 			SetBlipColour(x, 69)
-- 			BeginTextCommandSetBlipName("STRING")
-- 			AddTextComponentSubstringPlayerName(name)
-- 			EndTextCommandSetBlipName(x)
-- 		end
-- 	end
-- end

-- function DeleteBlips()
-- 	if DoesBlipExist(coords) then
-- 		RemoveBlip(coords)
-- 	end
-- end

-- function SellFish()


RegisterNetEvent("framework-fishing:tryToFish")
AddEventHandler("framework-fishing:tryToFish", function()
	TryToFish() 
end)

RegisterNetEvent("framework-fishing:calculatedistances")
AddEventHandler("framework-fishing:calculatedistances", pos, function()

end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1500)

		local ped = PlayerPedId()

		if cachedData["ped"] ~= ped then
			cachedData["ped"] = ped
		end
	end
end)

RegisterNetEvent('framework-fishing:client:sell:fish')
AddEventHandler('framework-fishing:client:sell:fish', function()
    if CanSell then
        CanSell = false
        TriggerServerEvent('framework-fishing:server:sell:items')
		TriggerServerEvent('framework-fishing:server:sell:gold-fish')
        Citizen.SetTimeout((60 * 1000) * 1, function()
            CanSell = true
        end)
    end
end)


RegisterNetEvent('framework-fishing:client:use:box')
AddEventHandler('framework-fishing:client:use:box', function(ItemName)
    if not DoingSomething then
        DoingSomething = true
        if ItemName == 'fish-box' then
            LSCore.Functions.TriggerCallback('LSCore:HasItem', function(HasItem)
                if HasItem then
                    TriggerEvent('framework-inv:client:set:inventory:state', false)
                    exports['fw-ui']:StartSkillTest(2, 'Normal', function(Outcome)
                        if Outcome then
                            DoingSomething = false
                            LSCore.Functions.Progressbar("open-box", "Doos Openbreken..", 20000, false, true, {
                                disableMovement = false,
                                disableCarMovement = false,
                                disableMouse = false,
                                disableCombat = true,
                            }, {}, {}, {}, function() -- Done
                                DoingSomething = false
                                TriggerServerEvent('framework-fishing:server:unbox', ItemName)
                                TriggerEvent('framework-inv:client:set:inventory:state', true)
                            end, function()
                               DoingSomething = false
                               TriggerEvent('framework-inv:client:set:inventory:state', true)
                               LSCore.Functions.Notify("Geannuleerd..", "error")
                            end)
                        else
                            DoingSomething = false
                            TriggerEvent('framework-inv:client:set:inventory:state', true)
                            LSCore.Functions.Notify("Gefaalt..", "error")
                        end
                    end) 
                else
                    LSCore.Functions.Notify("Je hebt geen grote lockpick..", "error")
                end
            end, "advancedlockpick") 
        else
            LSCore.Functions.TriggerCallback("framework-fishing:server:HasFishItem", function(HasFishItems)
                if HasFishItems then
                    LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, 'drill-bit', 1, false)
                    TriggerEvent('framework-inv:client:set:inventory:state', false)
                    exports['fw-assets']:RequestAnimationDict("anim@heists@fleeca_bank@drilling")
                    TaskPlayAnim(PlayerPedId(), 'anim@heists@fleeca_bank@drilling', 'drill_straight_idle' , 3.0, 3.0, -1, 1, 0, false, false, false)
                    exports['fw-assets']:AddProp('Drill')
                    exports['minigame-drill']:StartDrilling(function(Success)
                        if Success then
                            LSCore.Functions.Progressbar("open-box", "Doos Openbreken..", 20000, false, true, {
                                disableMovement = false,
                                disableCarMovement = false,
                                disableMouse = false,
                                disableCombat = true,
                            }, {}, {}, {}, function() -- Done
                                DoingSomething = false
                                exports['fw-assets']:RemoveProp()
                                TriggerServerEvent('framework-fishing:server:unbox', ItemName)
                                StopAnimTask(PlayerPedId(), "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 1.0)
                                TriggerEvent('framework-inv:client:set:inventory:state', true)
                            end, function()
                               DoingSomething = false
                               exports['fw-assets']:RemoveProp()
                               TriggerEvent('framework-inv:client:set:inventory:state', true)
                               StopAnimTask(PlayerPedId(), "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 1.0)
                               LSCore.Functions.Notify("Geannuleerd..", "error")
                            end)
                        else
                            DoingSomething = false
                            exports['fw-assets']:RemoveProp()
                            TriggerEvent('framework-inv:client:set:inventory:state', true)
                            StopAnimTask(PlayerPedId(), "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 1.0)
                            LSCore.Functions.Notify("Gefaalt..", "error")
                        end
                    end) 
                else
                    LSCore.Functions.Notify('Je mist iets..', 'error', 2500)
                end
            end)
        end
    end
end)
