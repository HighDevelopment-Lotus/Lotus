local LSCore = exports['ls-core']:GetCoreObject()

-- Code

LSCore.Functions.CreateCallback('ls-interactions:server:has:robbery:item', function(source, cb)
    local Player = LSCore.Functions.GetPlayer(source)
    local StolenTv = Player.Functions.GetItemByName('stolen-tv')
    local StolenMicro = Player.Functions.GetItemByName('stolen-micro')
    local StolenPc = Player.Functions.GetItemByName('stolen-pc')
    local DuffleBag = Player.Functions.GetItemByName('duffel-bag')
    local OxyBox = Player.Functions.GetItemByName('oxy-box')
    if StolenTv ~= nil then
        cb('StolenTv')
    elseif StolenMicro ~= nil then
        cb('StolenMicro')
    elseif StolenPc ~= nil then
        cb('StolenPc')
    elseif OxyBox ~= nil then
        cb('DarkmarketBox')
    elseif DuffleBag ~= nil then
        cb('Duffel')
    else 
        cb(false)
    end
end)

RegisterServerEvent('ls-interactions:server:steal:shoes')
AddEventHandler('ls-interactions:server:steal:shoes', function(TargetSource)
    local Player = LSCore.Functions.GetPlayer(source)
    Player.Functions.AddItem("weapon_shoe", 1, false, false, true)
    TriggerClientEvent('ls-interactions:client:remove:shoes', TargetSource)
end)