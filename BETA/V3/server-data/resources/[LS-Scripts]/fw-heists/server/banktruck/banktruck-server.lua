-- // BankTruck \\ --

RegisterServerEvent('framework-banktruck:server:update:plates')
AddEventHandler('framework-banktruck:server:update:plates', function(Plate)
    Config.RobbedPlates[Plate] = true
    TriggerClientEvent('framework-banktruck:sync', -1, Config.RobbedPlates)
end)

RegisterServerEvent('framework-banktruck:server:rewards')
AddEventHandler('framework-banktruck:server:rewards', function()
    local Player = LSCore.Functions.GetPlayer(source)
    -- TriggerEvent("framework-logs:server:SendLog", "cheaters", "Event Trigger", 'red', "(citizenid: *"..Player.PlayerData.citizenid.."* | name: "..Player.PlayerData.name.." | id: *(" ..src..")* Heeft een event getriggerd welke is omgezet door Dennii om cheaters tegen te gaan')
end)

LSCore.Functions.CreateCallback('framework-banktruck:server:rewards', function(source, cb)
    -- print('Hallo')
-- RegisterServerEvent('framework-banktruck:server:rewards')
-- AddEventHandler('framework-banktruck:server:rewards', function()
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    local RandomWaarde = math.random(1,100)
    Player.Functions.AddMoney('cash', math.random(5000, 9000), false, false, true)
    if RandomWaarde >= 1 and RandomWaarde <= 30 then
        local info = {worth = math.random(2500, 8500)}
        Player.Functions.AddItem('markedbills', 1, false, info, true)
    elseif RandomWaarde >= 31 and RandomWaarde <= 50 then
        Player.Functions.AddItem('rolex', math.random(3, 7), false, false, true)
    elseif RandomWaarde >= 51 and RandomWaarde <= 80 then 
        Player.Functions.AddItem('goldchain', math.random(6, 11), false, false, true)
    elseif RandomWaarde == 91 or RandomWaarde == 98 or RandomWaarde == 85 or RandomWaarde == 65 then
        Player.Functions.AddItem('goldbar', math.random(1, 2), false, false, true)
    elseif RandomWaarde == 26 or RandomWaarde == 52 then 
        Player.Functions.AddItem('yellow-card', 1, false, false, true)
    end
end)