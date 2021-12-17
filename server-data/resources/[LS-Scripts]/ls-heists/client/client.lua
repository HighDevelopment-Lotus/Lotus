LSCore, LoggedIn = exports['ls-core']:GetCoreObject(), false
local BankProps = {}

RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
AddEventHandler('LSCore:Client:OnPlayerLoaded', function()  
    Citizen.SetTimeout(3500, function()
        LSCore.Functions.TriggerCallback("ls-heists:server:get:config", function(ConfigData)
            Config = ConfigData
        end)
        LoadInteriorBobcat()
        SpawnBankProps()
        LoggedIn = true
    end)
end)

RegisterNetEvent('LSCore:Client:OnPlayerUnload')
AddEventHandler('LSCore:Client:OnPlayerUnload', function()
    DespawnBankProps()
    RemoveJewelProps()
    LoggedIn = false
end)

RegisterNetEvent('ls-police:SetCopCount')
AddEventHandler('ls-police:SetCopCount', function(Amount)
    CurrentCops = Amount
end)

-- Functions
function SpawnBankProps()
    for k, v in pairs(Config.Banks) do
        if v['Prop'] ~= nil then
            for Prop, Props in pairs(Config.Banks[k]['Prop']) do
                local Prop = GetHashKey(Props['Object'])
                exports['ls-assets']:RequestModelHash(Prop)
                Object = CreateObject(Prop, Props['Coords']['X'], Props['Coords']['Y'], Props['Coords']['Z'], false, false, false)
                SetEntityHeading(Object, Props['Coords']['H'])
                FreezeEntityPosition(Object, true)
                SetEntityInvincible(Object, true)
                if not Props['Show'] then
                    SetEntityVisible(Object, false)
                end
                table.insert(BankProps, Object)
            end
        end
    end
end

function DespawnBankProps()
    for k, v in pairs(BankProps) do
        NetworkRequestControlOfEntity(v)
        while not NetworkHasControlOfEntity(v) do
            Citizen.Wait(10)
        end
        DeleteEntity(v)
    end
end

function IsWearingHandshoes()
    local armIndex = GetPedDrawableVariation(GetPlayerPed(-1), 3)
    local model = GetEntityModel(GetPlayerPed(-1))
    local retval = true
    if model == GetHashKey("mp_m_freemode_01") then
        if Config.MaleNoHandshoes[armIndex] ~= nil and Config.MaleNoHandshoes[armIndex] then
            retval = false
        end
    else
        if Config.FemaleNoHandshoes[armIndex] ~= nil and Config.FemaleNoHandshoes[armIndex] then
            retval = false
        end
    end
    return retval
end

function DrawText3D(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end