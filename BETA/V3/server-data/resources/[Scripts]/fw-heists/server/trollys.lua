-- Code

-- // Events \\ --

-- Anti triggers Dennii (ItzHighNL)
RegisterServerEvent('framework-heists:server:crate:reward')
AddEventHandler('framework-heists:server:crate:reward', function(RewardType)
    local Player = LSCore.Functions.GetPlayer(source)
    TriggerEvent("framework-logs:server:SendLog", "cheaters", "Event Trigger", 'red', "(citizenid: *"..Player.PlayerData.citizenid.."* | name: "..Player.PlayerData.name.." | id: *(" ..src..")* Heeft een event getriggerd welke is omgezet door Dennii om cheaters tegen te gaan")
end)

RegisterServerEvent('framework-heists:server:trolly:reward')
AddEventHandler('framework-heists:server:trolly:reward', function(RewardType)
    local Player = LSCore.Functions.GetPlayer(source)
    TriggerEvent("framework-logs:server:SendLog", "cheaters", "Event Trigger", 'red', "(citizenid: *"..Player.PlayerData.citizenid.."* | name: "..Player.PlayerData.name.." | id: *(" ..src..")* Heeft een event getriggerd welke is omgezet door Dennii om cheaters tegen te gaan")
end)

LSCore.Functions.CreateCallback('framework-heists:server:trolly:reward', function(source, cb, RewardType)
    local Player = LSCore.Functions.GetPlayer(source)
    if RewardType == 'Bobcat' then
        Player.Functions.AddItem('diamond', 1, false, false, true)
        Player.Functions.AddItem('markedbills', 1, false, {worth = math.random(7000, 11000)}, true)
        Player.Functions.AddItem('markedbills', 1, false, {worth = math.random(7000, 11000)}, true)
    end
end)

LSCore.Functions.CreateCallback('framework-heists:server:crate:reward', function(source, cb, RewardType)
    local Player = LSCore.Functions.GetPlayer(source)
    if RewardType == 'Bobcat' then
        local RandomValue = math.random(1,5)
        if RandomValue == 1 or RandomValue == 2 or RandomValue == 3 or RandomValue == 4 then
            Player.Functions.AddItem('weapon_katana', 1, false, false, true)
            Player.Functions.AddItem('smg_ammo', 1, false, false, true)
        else
            Player.Functions.AddItem('smg_ammo', 1, false, false, true)
            Player.Functions.AddItem('pistol_extendedclip', 1, false, false, true)
        end
    end
end)