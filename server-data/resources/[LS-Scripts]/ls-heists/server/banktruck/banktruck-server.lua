-- // BankTruck \\ --

RegisterServerEvent('ls-banktruck:server:update:plates')
AddEventHandler('ls-banktruck:server:update:plates', function(Plate)
    Config.RobbedPlates[Plate] = true
    TriggerClientEvent('ls-banktruck:sync', -1, Config.RobbedPlates)
end)

RegisterServerEvent('ls-banktruck:server:rewards')
AddEventHandler('ls-banktruck:server:rewards', function()
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    local RandomWaarde = math.random(1,100)
    if RandomWaarde >= 1 and RandomWaarde <= 30 then
        local info = {worth = math.random(5500, 8500)}
        Player.Functions.AddItem('markedbills', 1, false, info, true)
    elseif RandomWaarde >= 31 and RandomWaarde <= 50 then
        Player.Functions.AddItem('rolex', math.random(3, 11), false, false, true)
    elseif RandomWaarde >= 51 and RandomWaarde <= 80 then 
        Player.Functions.AddItem('goldchain', math.random(6, 20), false, false, true)
    elseif RandomWaarde == 91 or RandomWaarde == 98 or RandomWaarde == 85 or RandomWaarde == 65 then
        Player.Functions.AddItem('goldbar', math.random(1, 2), false, false, true)
    elseif RandomWaarde == 26 or RandomWaarde == 52 then 
        Player.Functions.AddItem('yellow-card', 1, false, false, true)
    end
end)