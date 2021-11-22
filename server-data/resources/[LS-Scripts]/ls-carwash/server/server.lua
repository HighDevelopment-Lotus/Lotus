local LSCore = exports['ls-core']:GetCoreObject()

-- Code

LSCore.Functions.CreateCallback('ls-carwash:server:can:wash', function(source, cb, price)
    local CanWash = false
    local Player = LSCore.Functions.GetPlayer(source)
    if Player.Functions.RemoveMoney("cash", price, "car-wash") then
        CanWash = true
    else 
        CanWash = false
    end
    cb(CanWash)
end)

RegisterServerEvent('ls-carwash:server:set:busy')
AddEventHandler('ls-carwash:server:set:busy', function(CarWashId, bool)
 Config.CarWashLocations[CarWashId]['Busy'] = bool
 TriggerClientEvent('ls-carwash:client:set:busy', -1, CarWashId, bool)
end)

RegisterServerEvent('ls-carwash:server:sync:wash')
AddEventHandler('ls-carwash:server:sync:wash', function(Vehicle)
 TriggerClientEvent('ls-carwash:client:sync:wash', -1, Vehicle)
end)

RegisterServerEvent('ls-carwash:server:sync:water')
AddEventHandler('ls-carwash:server:sync:water', function(WaterId)
 TriggerClientEvent('ls-carwash:client:sync:water', -1, WaterId)
end)

RegisterServerEvent('ls-carwash:server:stop:water')
AddEventHandler('ls-carwash:server:stop:water', function(WaterId)
 TriggerClientEvent('ls-carwash:client:stop:water', -1, WaterId)
end)
