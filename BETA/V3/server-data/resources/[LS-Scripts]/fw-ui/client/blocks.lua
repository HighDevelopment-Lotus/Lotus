function StartBlocksGame(Callback)
    if not Config.DoingSkill then
        Config.DoingSkill = true
        ReturnCallback = Callback    
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = 'blocks-start'
        })
    end
end

RegisterNUICallback('WonBlocksGame', function()
    SetNuiFocus(false, false)
    Config.DoingSkill = false
    ReturnCallback(true)
end)

RegisterNUICallback('LostBlocksGame', function()
    SetNuiFocus(false, false)
    Config.DoingSkill = false
    ReturnCallback(false)
end)