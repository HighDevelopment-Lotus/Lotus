local LSCore, LoggedIn = exports['ls-core']:GetCoreObject(), false   
local NearShop, CurrentShop = false, nil
   
RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1250, function()
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
        Citizen.Wait(3)
        if LoggedIn then
            NearShop = false
            for k, v in pairs(Config.Shops) do
                local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
                local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'], true)
                if Distance < 2.5 then
                    NearShop = true
                    CurrentShop = k
                end
            end
            if not NearShop then
                Citizen.Wait(1000)
                CurrentShop = nil
            end
        end
    end
end)

-- // Events \\ --

RegisterNetEvent('ls-stores:server:open:shop')
AddEventHandler('ls-stores:server:open:shop', function()
    Citizen.SetTimeout(350, function()
        if CurrentShop ~= nil then 
            if CanOpenShop(CurrentShop) then
                if exports['ls-inventory-new']:CanOpenInventory() then
                    local Shop = {['Type'] = 'Store', ['InvName'] = Config.Shops[CurrentShop]['Name'], ['Items'] = Config.Shops[CurrentShop]['Product']}
                    TriggerServerEvent('ls-inventory-new:server:open:inventory:other', Shop, 'Store')
                end
            end
        end
    end)
end)

RegisterNetEvent('ls-stores:client:open:custom:store')
AddEventHandler('ls-stores:client:open:custom:store', function(ProductName)
    if exports['ls-inventory-new']:CanOpenInventory() then
        local Shop = {['Type'] = 'Store', ['InvName'] = ProductName, ['Items'] = Config.Products[ProductName]}
        TriggerServerEvent('ls-inventory-new:server:open:inventory:other', Shop, 'Store')
    end
end)

-- // Functions \\ --

function CanOpenShop(Storenumber)
    local PlayerData = LSCore.Functions.GetPlayerData()
    if Storenumber == 29 then
        print('Hunting')
        if PlayerData.metadata['licences']['hunting'] ~= nil then
            return true
        else
            LSCore.Functions.Notify('Je hebt geen jachtvergunning..', 'error')
            return false
        end
    else
        return true
    end
end

function IsNearStore()
    return NearShop
end

function GetStoreNumber()
    return CurrentShop
end