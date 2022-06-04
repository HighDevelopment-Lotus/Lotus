-- // VARIABLES \\ --
local LimitSpeed, LastVehicle, LimiterEnabled = 0.0, nil, false

-- // KEYBINDS \\ --
RegisterKeyMapping('speedLimiter', 'Begrenzer', 'keyboard', 'b')

RegisterCommand('speedLimiter', function()
    local playerPed = PlayerPedId()
    if IsPedInAnyVehicle(PlayerPedId()) then
        local Vehicle = GetVehiclePedIsIn(PlayerPedId())
        if GetPedInVehicleSeat(Vehicle, -1) == PlayerPedId() then
            LimitSpeed = GetEntitySpeed(Vehicle)
            if LimiterEnabled then
                LimiterEnabled = false
                LastVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                SetEntityMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), GetVehicleHandlingFloat(GetVehiclePedIsIn(PlayerPedId(), false),"CHandlingData","fInitialDriveMaxFlatVel"))
                LSCore.Functions.Notify("Begrenzer uitgeschakeld!")
            else
                LimiterEnabled = true
                LastVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                SetEntityMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), LimitSpeed)
                LSCore.Functions.Notify("Begrenzer gezet op "..tostring(math.floor(LimitSpeed * 3.6)).."km/u")
            end
        end
    end
end, false)