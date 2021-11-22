local LSCore = exports['ls-core']:GetCoreObject()

-- Code

Citizen.CreateThread(function()
    Config.Dealers[1]['Coords'] = {['X'] = 2415.61, ['Y'] = 5004.83,  ['Z'] = 46.68}
    Config.Dealers[2]['Coords'] = {['X'] = 967.20,  ['Y'] = -1858.47, ['Z'] = 31.16}
    Config.Dealers[3]['Coords'] = {['X'] = 734.38,  ['Y'] = -1294.98, ['Z'] = 27.03}
    --Config.Dealers[4]['Coords'] = {['X'] = -182.48, ['Y'] = 6551.14,   ['Z'] = 211.09}
end)

LSCore.Functions.CreateCallback("ls-dealers:server:get:config", function(source, cb)
    cb(Config.Dealers)
end)

RegisterServerEvent('ls-dealers:server:update:dealer:items')
AddEventHandler('ls-dealers:server:update:dealer:items', function(Slot, Amount, Dealer)
    if Config.Dealers[Dealer]["Products"][Slot].amount - Amount > 0 then
        Config.Dealers[Dealer]["Products"][Slot].amount = Config.Dealers[Dealer]["Products"][Slot].amount - Amount
    else
        Config.Dealers[Dealer]["Products"][Slot].amount = 0
    end
    TriggerClientEvent('ls-dealers:client:set:dealer:items', -1, Config.Dealers)
end)

Citizen.CreateThread(function()
    Citizen.Wait((1000 * 60) * 60)
    while true do
        Citizen.Wait(4)
        Config.Dealers[2]['Products'][1].amount = Config.Dealers[2]['Products'][1].resetamount
        Config.Dealers[2]['Products'][2].amount = Config.Dealers[2]['Products'][2].resetamount
        Config.Dealers[3]['Products'][1].amount = Config.Dealers[3]['Products'][1].resetamount
        Config.Dealers[3]['Products'][2].amount = Config.Dealers[3]['Products'][2].resetamount
        --Config.Dealers[4]['Products'][1].amount = Config.Dealers[4]['Products'][1].resetamount
        --Config.Dealers[4]['Products'][2].amount = Config.Dealers[4]['Products'][2].resetamount
        TriggerClientEvent('ls-dealers:client:set:dealer:items', -1, Config.Dealers)
        Citizen.Wait((1000 * 60) * 300)
    end
end)