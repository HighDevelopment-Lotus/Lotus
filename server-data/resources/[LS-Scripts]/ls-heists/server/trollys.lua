-- Code

-- // Events \\ --

RegisterServerEvent('ls-heists:server:trolly:reward')
AddEventHandler('ls-heists:server:trolly:reward', function(RewardType)
    local Player = LSCore.Functions.GetPlayer(source)
    if RewardType == 'Bobcat' then
        Player.Functions.AddItem('diamond', 1, false, false, true)
        Player.Functions.AddItem('markedbills', 1, false, {worth = math.random(7000, 11000)}, true)
        Player.Functions.AddItem('markedbills', 1, false, {worth = math.random(7000, 11000)}, true)
    end
end)

RegisterServerEvent('ls-heists:server:crate:reward')
AddEventHandler('ls-heists:server:crate:reward', function(RewardType)
    local Player = LSCore.Functions.GetPlayer(source)
    if RewardType == 'Bobcat' then
        local RandomValue = math.random(1,5)
        if RandomValue == 1 or RandomValue == 2 or RandomValue == 3 or RandomValue == 4 then
            Player.Functions.AddItem('weapon_vintagepistol', 1, false, false, true)
            Player.Functions.AddItem('weapon_snspistol_mk2', 1, false, false, true)
        else
            Player.Functions.AddItem('weapon_microsmg', 1, false, false, true)
            Player.Functions.AddItem('smg_extendedclip', 1, false, false, true)
        end
    end
end)