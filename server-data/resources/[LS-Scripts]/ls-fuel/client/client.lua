local LSCore, LoggedIn, NearPump, CurrentPump = exports['ls-core']:GetCoreObject(), false, false, nil

RegisterNetEvent("LSCore:Client:OnPlayerLoaded")
AddEventHandler("LSCore:Client:OnPlayerLoaded", function()
    Citizen.SetTimeout(1250, function()
        LSCore.Functions.TriggerCallback("ls-fuel:server:get:fuel:config", function(config)
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
        Citizen.Wait(5)
        if LoggedIn then
            if IsPedInAnyVehicle(GetPlayerPed(-1)) then
                local Vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
                local Plate = GetVehicleNumberPlateText(Vehicle)
                if Config.VehicleFuel[Plate] ~= nil then
                    if IsVehicleEngineOn(Vehicle) then
                        if Config.VehicleFuel[Plate] ~= 0 then
                            if GetPedInVehicleSeat(Vehicle, -1) == PlayerPedId() then
                                if GetEntitySpeed(Vehicle) > 3 then
                                    SetFuelLevel(Vehicle, Plate, Config.VehicleFuel[Plate] - 0.3)
                                    Citizen.Wait(12500)
                                end
                            end
                        end
                    else
                        Citizen.Wait(250)
                    end
                else
                    SetFuelLevel(Vehicle, Plate, math.random(55, 85), false)
                    Citizen.Wait(2500)
                end
            else
                Citizen.Wait(1000)
            end
        else
            Citizen.Wait(1000)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        if LoggedIn then
            NearPump = false
            for k, v in pairs(Config.TankLocations) do
                local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
                local Distance = #(PlayerCoords - vector3(Config.TankLocations[k]["Coords"]["X"], Config.TankLocations[k]["Coords"]["Y"], Config.TankLocations[k]["Coords"]["Z"]))
                if Distance < 15.0 then
                    NearPump = true
                    CurrentPump = k
                end
            end
            if not NearPump then
                Citizen.Wait(1500)
                CurrentPump = nil
            end
        else
            Citizen.Wait(1000)
        end
    end
end)

-- // Event \\ --

RegisterNetEvent('ls-fuel:client:open:menu')
AddEventHandler('ls-fuel:client:open:menu', function()
    local MenuItems = {[1] = {['Title'] = 'Voertuig Tanken', ['Desc'] = 'Voertuig volledig tanken.<br>Kosten: €'..Config.TankLocations[CurrentPump]['Tank-Price']..',-', ['Data'] = {['Event'] = 'ls-fuel:client:refuel:vehicle', ['Type'] = 'Client', ['Price'] = Config.TankLocations[CurrentPump]['Tank-Price']}}}
    local Data = {['Title'] = 'Benzine Pomp', ['MainMenuItems'] = MenuItems}
    LSCore.Functions.OpenMenu(Data)
end)

RegisterNetEvent('ls-fuel:client:refuel:vehicle')
AddEventHandler('ls-fuel:client:refuel:vehicle', function(data)
    local Vehicle, VehDistance = LSCore.Functions.GetClosestVehicle()
    local Plate = GetVehicleNumberPlateText(Vehicle)
    if Vehicle ~= 0 and VehDistance < 4.5 then
        LSCore.Functions.TriggerCallback('LSCore:RemoveCash', function(DidPay)
            if DidPay then
                RefuelCar(Vehicle, Plate)
            end
        end, Config.TankLocations[CurrentPump]['Tank-Price']) 
    end
end)


RegisterNetEvent('ls-items:client:jerry_can')
AddEventHandler('ls-items:client:jerry_can', function()
	local Vehicle, Distance = LSCore.Functions.GetClosestVehicle()
	local Plate = GetVehicleNumberPlateText(Vehicle)
	local CurrentFuel = exports['ls-fuel']:GetFuelLevel(Plate)
	if Vehicle ~= -1 and Distance < 4.5 and not IsPedInAnyVehicle(GetPlayerPed(-1)) then
		if CurrentFuel < 100 then
			exports['ls-assets']:RequestAnimationDict("weapon@w_sp_jerrycan")
    		TaskPlayAnim( PlayerPedId(), "weapon@w_sp_jerrycan", "fire", 8.0, 1.0, -1, 1, 0, 0, 0, 0)
            TriggerEvent('ls-inventory-new:client:set:inventory:state', false)
    		if IsVehicleEngineOn(Vehicle) then
    		    if math.random(1, 100) <= 25 then
    		        AddExplosion(GetEntityCoords(Vehicle), EXPLOSION_CAR, 4.0, true, false, 20.0)
    		        TriggerServerEvent('ls-police:server:alert:explosion', GetEntityCoords(Vehicle), LSCore.Functions.GetStreetLabel())
    		        LSCore.Functions.Notify('Tjah had je maar je motor uit moeten zetten...', 'error', 7500)
    		    else
    		         LSCore.Functions.Progressbar("refuel-car", "Tanken..", math.random(5000, 6500), false, true, {
    		             disableMovement = true,
    		             disableCarMovement = true,
    		             disableMouse = false,
    		             disableCombat = true,
    		         }, {}, {}, {}, function() -- Done
                        TriggerEvent('ls-inventory-new:client:set:inventory:state', true)
                        LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, 'jerry_can', 1, false)
    		            SetFuelLevel(Vehicle, Plate, (CurrentFuel + 25), false)
    		            PlaySound(-1, "5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
    		            StopAnimTask(GetPlayerPed(-1), "weapon@w_sp_jerrycan", "fire", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
    		         end, function() -- Cancel
                        TriggerEvent('ls-inventory-new:client:set:inventory:state', true)
    		            StopAnimTask(GetPlayerPed(-1), "weapon@w_sp_jerrycan", "fire", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
    		         end)
    		    end
    		else
    		    LSCore.Functions.Progressbar("refuel-car", "Tanken..", math.random(5000, 6500), false, true, {
    		        disableMovement = true,
    		        disableCarMovement = true,
    		        disableMouse = false,
    		        disableCombat = true,
    		    }, {}, {}, {}, function() -- Done
                    TriggerEvent('ls-inventory-new:client:set:inventory:state', true)
                    LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, 'jerry_can', 1, false)
    		        SetFuelLevel(Vehicle, Plate, (CurrentFuel + 25), false)
    		        PlaySound(-1, "5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
    		        StopAnimTask(GetPlayerPed(-1), "weapon@w_sp_jerrycan", "fire", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
    		    end, function() -- Cancel
                    TriggerEvent('ls-inventory-new:client:set:inventory:state', true)
    		        StopAnimTask(GetPlayerPed(-1), "weapon@w_sp_jerrycan", "fire", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
    		    end)
    		end
		else
			LSCore.Functions.Notify('Er zit al genoeg benzine in joh..', 'error', 6500)
		end
	end
end)

RegisterNetEvent('ls-fuel:client:sync:vehicle:fuel')
AddEventHandler('ls-fuel:client:sync:vehicle:fuel', function(Plate, ConfigData)
    Config.VehicleFuel[Plate] = ConfigData
end)

-- // Functions \\ --

function NearGasPump()
    return NearPump
end

function GetFuelLevel(Plate)
    if Config.VehicleFuel[Plate] ~= nil then
        return Config.VehicleFuel[Plate]
    else
        return 0
    end
end

function SetFuelLevel(Vehicle, Plate, Amount, Spawned)
    if Amount < 0 then Amount = 0 end
    if Amount > 100 then Amount = 100 end
    if Spawned then if Amount < 100 or GetFuelLevel(Plate) < 100 then Amount = 100 end end
    SetVehicleFuelLevel(Vehicle, Amount + 0.0)
    TriggerServerEvent('ls-fuel:server:set:fuel', Plate, Vehicle, Amount)
end

function RefuelCar(Vehicle, Plate)
    exports['ls-assets']:RequestAnimationDict("weapon@w_sp_jerrycan")
    TaskPlayAnim( PlayerPedId(), "weapon@w_sp_jerrycan", "fire", 8.0, 1.0, -1, 1, 0, 0, 0, 0)
    if IsVehicleEngineOn(Vehicle) then
        if math.random(1, 100) <= 35 then
            AddExplosion(GetEntityCoords(Vehicle), EXPLOSION_CAR, 4.0, true, false, 20.0)
            TriggerServerEvent('ls-police:server:alert:explosion', GetEntityCoords(Vehicle), LSCore.Functions.GetStreetLabel())
            LSCore.Functions.Notify('Tjah had je maar je motor uit moeten zetten...', 'error', 7500)
        else
             LSCore.Functions.Progressbar("refuel-car", "Tanken..", math.random(5000, 6500), false, true, {
                 disableMovement = true,
                 disableCarMovement = true,
                 disableMouse = false,
                 disableCombat = true,
             }, {}, {}, {}, function() -- Done
                SetFuelLevel(Vehicle, Plate, 100, false)
                PlaySound(-1, "5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
                LSCore.Functions.Notify('Voertuig vol getankt!', 'success')
                StopAnimTask(GetPlayerPed(-1), "weapon@w_sp_jerrycan", "fire", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
             end, function() -- Cancel
                StopAnimTask(GetPlayerPed(-1), "weapon@w_sp_jerrycan", "fire", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
             end)
        end
    else
        LSCore.Functions.Progressbar("refuel-car", "Tanken..", math.random(5000, 6500), false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
           SetFuelLevel(Vehicle, Plate, 100, false)
           PlaySound(-1, "5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
           LSCore.Functions.Notify('Voertuig vol getankt!', 'success')
           StopAnimTask(GetPlayerPed(-1), "weapon@w_sp_jerrycan", "fire", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
        end, function() -- Cancel
           StopAnimTask(GetPlayerPed(-1), "weapon@w_sp_jerrycan", "fire", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
        end)
    end
end

function Round(num, numDecimalPlaces)
 local mult = 10^(numDecimalPlaces or 0)
 return math.floor(num * mult + 0.5) / mult
end
