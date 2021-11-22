-- // VARIABLES \\ --
local LimitSpeed, LastVehicle, LimiterEnabled = 0.0, nil, false

-- // KEYBINDS \\ --
RegisterKeyMapping('speedLimiter', 'Begrenzer', 'keyboard', 'b')

RegisterCommand('speedLimiter', function()
    local playerPed = GetPlayerPed(-1)
    if IsPedInAnyVehicle(GetPlayerPed(-1)) then
        local Vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
        if GetPedInVehicleSeat(Vehicle, -1) == GetPlayerPed(-1) then
            LimitSpeed = GetEntitySpeed(Vehicle)
            if LimiterEnabled then
                LimiterEnabled = false
                LastVehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                SetEntityMaxSpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetVehicleHandlingFloat(GetVehiclePedIsIn(GetPlayerPed(-1), false),"CHandlingData","fInitialDriveMaxFlatVel"))
                LSCore.Functions.Notify("Begrenzer uitgeschakeld!")
            else
                LimiterEnabled = true
                LastVehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                SetEntityMaxSpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false), LimitSpeed)
                LSCore.Functions.Notify("Begrenzer gezet op "..tostring(math.floor(LimitSpeed * 3.6)).."km/u")
            end
        end
    end
end, false)