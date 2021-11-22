local ParticleDict = "veh_xs_vehicle_mods"
local ParticleFx = "veh_nitrous"
local VehicleParticles = {}
local ParticleSize = 2.0

local FlameLocations = {
	"exhaust",
	"exhaust_2",
	"exhaust_3",
	"exhaust_4",
	"exhaust_5",
	"exhaust_6",
	"exhaust_7",
	"exhaust_8",
	"exhaust_9",
	"exhaust_10",
	"exhaust_11",
	"exhaust_12",
	"exhaust_13",
	"exhaust_14",
	"exhaust_15",
	"exhaust_16",
}

-- // Loops \\ --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            if IsControlPressed(0, 19) then
                local Vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
                local Plate = GetVehicleNumberPlateText(Vehicle)
                if GetPedInVehicleSeat(Vehicle, -1) == PlayerPedId() then
                    if Config.NosActive[Plate] ~= nil then
                        if Config.NosActive[Plate] > 9 then
                            local VehicleModel = GetEntityModel(Vehicle)
                            local CurrentSpeed = GetEntitySpeed(Vehicle)
                            local MaximumSpeed = GetVehicleModelMaxSpeed(VehicleModel)
                            local Multiplier = 1.5 * MaximumSpeed / CurrentSpeed
                            SetVehicleBoostActive(Vehicle, true)                            
                            SetVehicleEnginePowerMultiplier(Vehicle, Multiplier)
                            SetVehicleEngineTorqueMultiplier(Vehicle, Multiplier)
                            TriggerServerEvent('ls-vehicles:server:remove:amount:nitrous', Plate, 10)
                            Citizen.Wait(1400)
                            if Config.NosActive[Plate] == 0 or Config.NosActive[Plate] < 0 then
                                SetVehicleBoostActive(Vehicle, false)
                                SetVehicleEnginePowerMultiplier(Vehicle, 1.0)
                                SetVehicleEngineTorqueMultiplier(Vehicle, 1.0)
                                TriggerServerEvent('ls-vehicles:server:remove:nitrous', Plate)
                                TriggerServerEvent('ls-vehicles:server:remove:flames', VehToNet(Vehicle))
                            end
                        end
                    end
                end
            end
        else
            Citizen.Wait(1500)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            if IsControlJustPressed(0, 19) then
                local Vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
                local Plate = GetVehicleNumberPlateText(Vehicle)
                if GetPedInVehicleSeat(Vehicle, -1) == PlayerPedId() then
                    if Config.NosActive[Plate] ~= nil then
                        TriggerServerEvent('ls-vehicles:server:set:flames', VehToNet(Vehicle))
                    end
                end
            end
            if IsControlJustReleased(0, 19) then
                local Vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
                local Plate = GetVehicleNumberPlateText(Vehicle)
                if GetPedInVehicleSeat(Vehicle, -1) == PlayerPedId() then
                    if Config.NosActive[Plate] ~= nil then
                        TriggerServerEvent('ls-vehicles:server:remove:flames', VehToNet(Vehicle))
                        SetVehicleBoostActive(Vehicle, false)
                        SetVehicleEnginePowerMultiplier(Vehicle, 1.0)
                        SetVehicleEngineTorqueMultiplier(Vehicle, 1.0)
                    end
                end
            end
        else
            Citizen.Wait(1500)
        end
    end
end)

-- // Events \\ --

RegisterNetEvent('ls-vehicles:client:set:flames')
AddEventHandler('ls-vehicles:client:set:flames', function(Veh)
    local Vehicle = NetToVeh(Veh)
    local Plate = GetVehicleNumberPlateText(Vehicle)
    if VehicleParticles[Plate] == nil then
        VehicleParticles[Plate] = {}
    end
    for k, v in pairs(FlameLocations) do
        if GetEntityBoneIndexByName(Vehicle, v) ~= -1 then
            RequestNamedPtfxAsset(ParticleDict)
            while not HasNamedPtfxAssetLoaded(ParticleDict) do
                Citizen.Wait(0)
            end
            SetPtfxAssetNextCall(ParticleDict)
            Citizen.InvokeNative(0x6C38AF3693A69A91, ParticleDict)
            table.insert(VehicleParticles[Plate], StartParticleFxLoopedOnEntityBone(ParticleFx, Vehicle, 0.0, -0.02, 0.0, 0.0, 0.0, 0.0, GetEntityBoneIndexByName(Vehicle, v), ParticleSize, 0.0, 0.0, 0.0))
        end
    end
end)

RegisterNetEvent('ls-vehicles:client:remove:flames')
AddEventHandler('ls-vehicles:client:remove:flames', function(Veh)
    local Vehicle = NetToVeh(Veh)
    local Plate = GetVehicleNumberPlateText(Vehicle)
    if VehicleParticles[Plate] ~= nil then
        for k, v in pairs(VehicleParticles[Plate]) do
            StopParticleFxLooped(v, 1)
        end
        VehicleParticles[Plate] = {}
    end
end)

RegisterNetEvent('ls-vehicles:client:use:nitrous')
AddEventHandler('ls-vehicles:client:use:nitrous', function()
    local Vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
    local Plate = GetVehicleNumberPlateText(Vehicle)
    if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
        if Config.NosActive[Plate] == nil then
            LSCore.Functions.Progressbar("use_nos", "Nitrous Aansluiten..", 1000, false, true, {
                disableMovement = false,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function() -- Done
                LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, 'nitrous', 1, false)
                TriggerServerEvent('ls-vehicles:server:register:nitrous', Plate)
            end)
        else
            LSCore.Functions.Notify('Voertuig heeft al nos..', 'error')
        end
    end
end)

RegisterNetEvent('ls-vehicles:client:sync:nitrous')
AddEventHandler('ls-vehicles:client:sync:nitrous', function(NosData)
    Config.NosActive = NosData
end)

-- // Functions \\ --

function HasVehicleNosActive(Plate)
    if Config.NosActive[Plate] ~= nil then
        return Config.NosActive[Plate]
    else
        return false
    end
end