local IsLooping = true

local Density = {
    ['Vehicle'] = 0.25,
    ['Parked'] = 0.25,
    ['Peds'] = 0.35,
    ['Scenario'] = 0.3,
}

-- Map Peds

-- // Loops \\ --

Citizen.CreateThread(function()
    while true do
		SetVehicleDensityMultiplierThisFrame(Density['Vehicle'])
		SetPedDensityMultiplierThisFrame(Density['Peds'])
	    SetParkedVehicleDensityMultiplierThisFrame(Density['Parked'])
        SetScenarioPedDensityMultiplierThisFrame(Density['Scenario'], Density['Scenario'])
        SetVehicleModelIsSuppressed(GetHashKey("blimp"), true)
		Citizen.Wait(4)
	end
end)

-- // Functions \\ --

function SetDensity(Type, Value)
    if Type == 'Vehicle' then
        Density['Vehicle'] = Value
    elseif Type == 'Peds' then
        Density['Peds'] = Value
    elseif Type == 'Parked' then
        Density['Parked'] = Value
    elseif Type == 'Scenario' then
        Density['Scenario'] = Value
    end
end