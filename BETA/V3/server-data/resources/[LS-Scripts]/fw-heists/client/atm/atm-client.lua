local CurrentCops = -0
-- Code

RegisterNetEvent('police:SetCopCount')
AddEventHandler('police:SetCopCount', function(amount)
    CurrentCops = amount
end)

RegisterNetEvent('fw-heist:atm:client:openatmmofo', function()
    RobAtm()
end)

local prop = {
    "prop_atm_01",
    "prop_atm_02",
    "prop_atm_03",
    "prop_fleeca_atm",
}
  exports['fw-polyzone']:AddTargetModel(prop, {
      options = {
          {
              type = "client",
              event = "fw-heist:atm:client:openatmmofo",
              icon = "fas fa-user-secret",
              label = "Sloop ATM",
        },
    },
        distance = 2.0    
})

function RobAtm()
	local pos = GetEntityCoords(PlayerPedId())
		LSCore.Functions.TriggerCallback("fw-heist:atm:Cooldown", function(cooldown)
			if not cooldown then
				if CurrentCops >= 0 then
					LSCore.Functions.TriggerCallback('LSCore:HasItem', function(hasItem)
						if hasItem then
							PoliceCall()
                            exports['minigame-varhack']:OpenHackingGame(function(success)
                            if success then
							   ClearPedTasksImmediately(PlayerPedId())
                               LSCore.Functions.Notify("Huts", "error")
							   HackSuccess() 

                            else
                                ClearPedTasksImmediately(PlayerPedId())
                                print("failed")
                            end
                        end, 5, 7)
						else
							LSCore.Functions.Notify("Je mist een usb device", "error")
						end
					end, "thermite")
				else
					LSCore.Functions.Notify("Niet genoeg Politie", "error")
				end
			else
				LSCore.Functions.Notify("Deze ATM is recent overvallen")
			end
		end)
end

function RobbingAtm()
    Anim = true
    LSCore.Functions.Progressbar("power_hack", "ATM Aan het openbreken", (17500), false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "random@mugging4",
        anim = "struggle_loop_b_thief",
        flags = 16,
    }, {
    }, {}, function() -- Done
                    LSCore.Functions.Progressbar("power_hack", "Geld stelen", (17500), false, true, {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    }, {
                        animDict = "anim@heists@ornate_bank@grab_cash_heels",
                        anim = "grab",
                        flags = 16,
                    }, {
                    model = "prop_cs_heist_bag_02",
                    bone = 57005,
                    coords = { x = -0.005, y = 0.00, z = -0.16 },
                    rotation = { x = 250.0, y = -30.0, z = 0.0 },
                    }, {}, function() -- Done
                        Anim = false
                        TriggerServerEvent("fw-heist:atm:success")
                        StopAnimTask(PlayerPedId(), "anim@heists@ornate_bank@grab_cash_heels", "grab", 1.0)
                        SetPedComponentVariation((PlayerPedId()), 5, 47, 0, 0)

                    end, function() -- Cancel
                        Anim = false
                        StopAnimTask(PlayerPedId(), "anim@heists@ornate_bank@grab_cash_heels", "grab", 1.0)
                    end)
    end, function() -- Cancel
        Anim = false
        StopAnimTask(PlayerPedId(), "random@mugging4", "struggle_loop_b_thief", 1.0)
		
    end)

    Citizen.CreateThread(function()
        while Anim do
            TriggerServerEvent('framework-ui:server:gain:stress', math.random(1, 6))
            Citizen.Wait(12000)
        end
    end)
end
-- // Results \\ --


function HackFailed()
	LSCore.Functions.Notify("Helaas!")
    if math.random(1, 100) <= 40 then
        TriggerServerEvent("framework-police:server:create:evidence", 'Finger', GetEntityCoords(PlayerPedId()))
		LSCore.Functions.Notify("Je vingerafdrukken zijn achtergebleven")
	end
end

function HackSuccess()
	-- LSCore.Functions.Notify("Success!")
    ClearPedTasksImmediately(PlayerPedId())
	RobbingAtm()
    TriggerServerEvent('fw-heist:atm:Server:BeginCooldown')
end

function PoliceCall()
    local chance = 75
    if GetClockHours() >= 0 and GetClockHours() <= 6 then
        chance = 50
    end
    if math.random(1, 100) <= chance then
        local StreetLabel = LSCore.Functions.GetStreetLabel()
        TriggerServerEvent('framework-police:server:send:alert:atm', GetEntityCoords(PlayerPedId()), StreetLabel)
    end
end