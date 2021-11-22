local LSCore = exports['ls-core']:GetCoreObject()

-- Code

RegisterServerEvent('ls-lockpick:server:add:skill:lockpick')
AddEventHandler('ls-lockpick:server:add:skill:lockpick', function(Points)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    local NewSkillLevel = Player.PlayerData.skills['lockpick'] + Points
    if NewSkillLevel > 1 then
        Player.Functions.SetSkillPoints('lockpick', NewSkillLevel)
    else
        Player.Functions.SetSkillPoints('lockpick', 0)
    end
end)

RegisterServerEvent('ls-lockpick:server:remove:skill:lockpick')
AddEventHandler('ls-lockpick:server:remove:skill:lockpick', function(Points)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    local NewSkillLevel = Player.PlayerData.skills['lockpick'] - Points
    if NewSkillLevel > 1 then
        Player.Functions.SetSkillPoints('lockpick', NewSkillLevel)
    else
        Player.Functions.SetSkillPoints('lockpick', NewSkillLevel)
    end
end)