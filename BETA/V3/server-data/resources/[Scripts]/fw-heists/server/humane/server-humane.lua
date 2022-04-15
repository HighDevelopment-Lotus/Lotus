RegisterServerEvent('framework-humanelabs:server:set:lab:robbed')
AddEventHandler('framework-humanelabs:server:set:lab:robbed', function()
    Config.HumanLabs['BeingRobbed'] = true
    TriggerEvent('framework-doors:server:set:door:locks', 51, 0)
    TriggerClientEvent('framework-humanelabs:client:set:lab:robbed', -1)
    Citizen.SetTimeout(30 * (60 * 1000), function()
        -- Reset Humanelabs
        Config.HumanLabs['Hacked'] = false
        Config.HumanLabs['BeingRobbed'] = false
        TriggerEvent('framework-doors:server:set:door:locks', 51, 1)
        TriggerEvent('framework-doors:server:set:door:locks', 52, 1)
        TriggerEvent('framework-doors:server:set:door:locks', 53, 1)
        for k, v in pairs(Config.HumanLabs['Lockers']) do
            v['Busy'] = false
            v['IsOpen'] = false
        end
        TriggerClientEvent('framework-humanelabs:client:reset', -1)
    end)
end)

RegisterServerEvent('framework-humanelabs:server:set:locker:state')
AddEventHandler('framework-humanelabs:server:set:locker:state', function(LockerNumber, LockerType, Bool)
    Config.HumanLabs['Lockers'][LockerNumber][LockerType] = Bool
    TriggerClientEvent('framework-humanelabs:server:sync:lockers', -1 , Config.HumanLabs['Lockers'])
end)

RegisterServerEvent('framework-humanelabs:server:end:lockdown')
AddEventHandler('framework-humanelabs:server:end:lockdown', function()
    Config.HumanLabs['Hacked'] = true
    TriggerClientEvent('framework-humanelabs:server:end:lockdown', -1)
    TriggerEvent('framework-doors:server:set:door:locks', 51, 0)
    TriggerEvent('framework-doors:server:set:door:locks', 52, 0)
    TriggerEvent('framework-doors:server:set:door:locks', 53, 0)
end)

-- Anti triggers Dennii (ItzHighNL)
RegisterServerEvent('framework-humanelabs:server:locker:reward:new:2022:new')
AddEventHandler('framework-humanelabs:server:locker:reward:new:2022:new', function()
    local Player = LSCore.Functions.GetPlayer(source)
    TriggerEvent("framework-logs:server:SendLog", "cheaters", "Event Trigger", 'red', "(citizenid: *"..Player.PlayerData.citizenid.."* | name: "..Player.PlayerData.name.." | id: *(" ..source..")* Heeft een event getriggerd welke is omgezet door Dennii om cheaters tegen te gaan")
end)

LSCore.Functions.CreateCallback('framework-humanelabs:server:locker:reward:new:2022:new', function(source, cb)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    local RandomValue = math.random(1, 100)
        Player.Functions.AddMoney('cash', math.random(15000,25000), false, false, true)
    if RandomValue >= 1 and RandomValue <= 5 then
        Player.Functions.AddItem('lsd-strip', math.random(1,4), false, false, true)
    elseif RandomValue > 5 and RandomValue <= 15 then
        local Info = {quality = 100.0, melee = true}
        Player.Functions.AddItem('weapon_molotov', 1, false, Info, true)
    elseif RandomValue > 15 and RandomValue <= 35 then
        Player.Functions.AddItem('armor', math.random(2,6), false, false, true)
    elseif RandomValue > 35 and RandomValue <= 63 then
        Player.Functions.AddItem('pistol_ammo', math.random(5,8), false, false, true)
    elseif RandomValue > 63 and RandomValue <= 73 then
        Player.Functions.AddItem('smg_ammo', math.random(1,3), false, false, true)
    elseif RandomValue > 73 and RandomValue <= 76 then
        Player.Functions.AddItem('rifle_ammo', 1, false, false, true)
    elseif RandomValue > 76 and RandomValue <= 83 then
        Player.Functions.AddItem('shotgun_ammo', math.random(1,3), false, false, true)
    elseif RandomValue > 83 and RandomValue <= 97 then
        Player.Functions.AddItem('copper', 200, false, false, true)
    elseif RandomValue > 97 and RandomValue <= 100 then
        Player.Functions.AddItem('snspistol_part_2', 1, false, false, true)
    end
end)