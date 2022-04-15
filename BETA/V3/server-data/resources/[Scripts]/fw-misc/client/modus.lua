local currentClass = "A"
local currentMode = "Automatic"
local vaildveh = false

-- Pursuit Mode

function validVehicle(vehicleModel)
    for k,v in pairs(Config.VehiclesConfig) do
        if Config.VehiclesConfig[k]["model"] == vehicleModel then
            return true
        end
    end

    return false
end


function getHandlingConfig(vehicleModel, type)
    for k,v in pairs(Config.VehiclesConfig) do
        if Config.VehiclesConfig[k]["model"] == vehicleModel then
            return Config.VehiclesConfig[k][currentClass][type]
        end
    end
end

function changeClass()
    if currentClass == "A" then
        currentClass = "A+"
        print("Veranderd naar A+ class")
    elseif currentClass == "A+" then
        currentClass = "S+"
        SetVehicleModKit(GetVehiclePedIsIn(PlayerPedId()), 0)
        ToggleVehicleMod(GetVehiclePedIsIn(PlayerPedId()), 22, true) -- toggle xenon lights
        ToggleVehicleMod(GetVehiclePedIsIn(PlayerPedId()), 18, true) -- upgrade turbo to max level
        SetVehicleMod(GetVehiclePedIsIn(PlayerPedId()), 11, 2, false) -- upgrade engine to max level
        SetVehicleXenonLightsColor(GetVehiclePedIsIn(PlayerPedId()), 1) -- change xenon lights color
        print("Veranderd naar S+ class")
    elseif currentClass == "S+" then
        currentClass = "A"
        ToggleVehicleMod(GetVehiclePedIsIn(PlayerPedId()), 22, false) -- toggle off xenon lights
        ToggleVehicleMod(GetVehiclePedIsIn(PlayerPedId()), 18, false) -- toggle off turbo
        SetVehicleMod(GetVehiclePedIsIn(PlayerPedId()), 11, -1, false) -- change engine to lowest level
        print("Veranderd naar A class")
    end
end

CreateThread(function()
    while true do
        local plyPed = PlayerPedId()
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            local plyVehicle = GetVehiclePedIsIn(plyPed)
            if validVehicle(GetEntityModel(plyVehicle)) and DoesEntityExist(plyVehicle) then
                vaildveh = true
                SetVehicleHandlingFloat(plyVehicle, "CHandlingData", "fDriveInertia", getHandlingConfig(GetEntityModel(plyVehicle), "fDriveInertia"))
                SetVehicleHandlingFloat(plyVehicle, "CHandlingData", "fInitialDriveMaxFlatVel", getHandlingConfig(GetEntityModel(plyVehicle), "fInitialDriveMaxFlatVel"))
                SetVehicleHandlingFloat(plyVehicle, "CHandlingData", "fBrakeForce", getHandlingConfig(GetEntityModel(plyVehicle), "fBrakeForce"))
                SetVehicleHandlingFloat(plyVehicle, "CHandlingData", "fSteeringLock", getHandlingConfig(GetEntityModel(plyVehicle), "fSteeringLock"))
                SetVehicleHandlingFloat(plyVehicle, "CHandlingData", "fInitialDriveForce", getHandlingConfig(GetEntityModel(plyVehicle), "fInitialDriveForce"))
                if IsControlPressed(0, Config.KeyBind) then
                    changeClass()
                    LSCore.Functions.Notify("Voertuig handeling aangepast: " .. currentClass)
                    SetVehicleHandlingFloat(plyVehicle, "CHandlingData", "fDriveInertia", getHandlingConfig(GetEntityModel(plyVehicle), "fDriveInertia"))
                    SetVehicleHandlingFloat(plyVehicle, "CHandlingData", "fInitialDriveMaxFlatVel", getHandlingConfig(GetEntityModel(plyVehicle), "fInitialDriveMaxFlatVel"))
                    SetVehicleHandlingFloat(plyVehicle, "CHandlingData", "fBrakeForce", getHandlingConfig(GetEntityModel(plyVehicle), "fBrakeForce"))
                    SetVehicleHandlingFloat(plyVehicle, "CHandlingData", "fSteeringLock", getHandlingConfig(GetEntityModel(plyVehicle), "fSteeringLock"))
                    SetVehicleHandlingFloat(plyVehicle, "CHandlingData", "fInitialDriveForce", getHandlingConfig(GetEntityModel(plyVehicle), "fInitialDriveForce"))
                end
            else
                vaildveh = false
                Wait(1000)
            end
        else
            vaildveh = false
            currentClass = "A"
        end
        if IsControlPressed(0, Config.WeaponKeyBind) then
            if currentMode == "Automatic" then
                currentMode = "Single"
                LSCore.Functions.Notify("Schietpatroon veranderd naar: Single")
            elseif currentMode == "Single" then
                currentMode = "Burst"
                LSCore.Functions.Notify("Schietpatroon veranderd naar: Burst")
            elseif currentMode == "Burst" then
                currentMode = "Automatic"
                LSCore.Functions.Notify("Schietpatroon veranderd naar: Automatic")
            end
        end

        Wait(750)
    end
end)

exports("currentClass", function()
    if currentClass == "A" then
        return 25
    elseif currentClass == "A+" then
        return 60
    elseif currentClass == "S+" then
        return 100
    end
end)

exports("validVehicle", function()
    return vaildveh
end)

-- Weapon Modes

exports("currentMode", function()
    if currentMode == "Single" then
        return 25
    elseif currentMode == "Burst" then
        return 60
    elseif currentMode == "Automatic" then
        return 100
    end
end)

CreateThread(function()
    while true do
        Wait(0)
        local playerPed = PlayerPedId()
        local shooting = IsPedShooting(playerPed)

        if shooting and currentMode == "Single" then
            DisablePlayerFiring(playerPed, true)
        elseif shooting and currentMode == "Burst" then
            Wait(300)
            DisablePlayerFiring(playerPed, true)
        end

    end
end)

RegisterCommand("carhash", function()
    print(GetEntityModel(GetVehiclePedIsIn(PlayerPedId(), -1)))
end)
