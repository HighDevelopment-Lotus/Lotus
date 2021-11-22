local InsideBriefing, DiscoMode, DarkModeOn = false, false, false
local ColorR, ColorG, ColorB = 15, 15, 15

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
            local Distance = #(PlayerCoords - vector3(445.02, -985.66, 34.97))
            if Distance <= 5.5 then
                if not InsideBriefing then
                    InsideBriefing = true
                    local DuiData = exports['ls-assets']:GenerateNewDui('https://i.imgur.com/5Ust2GQ.jpg', 1920, 1080, 'police-briefing')
                    if DuiData == false then
                        local SecondDuiData = exports['ls-assets']:GetDuiData('police-briefing')
                        AddReplaceTexture('prop_planning_b1', 'prop_base_white_01b', SecondDuiData['TxdDictName'], SecondDuiData['TxdName'])
                        exports['ls-assets']:ActivateDui('police-briefing')
                    else
                        AddReplaceTexture('prop_planning_b1', 'prop_base_white_01b', DuiData['TxdDictName'], DuiData['TxdName'])
                    end
                end
            else
                if InsideBriefing then
                    InsideBriefing = false
                    local DuiData = exports['ls-assets']:GetDuiData('police-briefing')
                    RemoveReplaceTexture('prop_planning_b1', 'prop_base_white_01b')
                    exports['ls-assets']:ReleaseDui('police-briefing')
                    if DarkModeOn then
                        DarkModeOn = false
                        SetArtificialLightsState(false)
                    end
                end
            end
        else
            Citizen.Wait(450)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            if InsideBriefing and DiscoMode then
                ColorR, ColorG, ColorB = math.random(1,255), math.random(1,255), math.random(1,255)
                if not DarkModeOn then
                    DarkModeOn = true
                    SetArtificialLightsState(true)
                end
            end
            Citizen.Wait(750)
        else
            Citizen.Wait(450)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            if InsideBriefing and DiscoMode then
                DrawLightWithRange(446.13, -983.44, 35.97, ColorB, ColorG, ColorB, 5.0, 10.0)
                DrawLightWithRange(446.23, -988.14, 35.97, ColorB, ColorR, ColorG, 5.0, 10.0)
                DrawLightWithRange(442.08, -988.05, 35.97, ColorR, ColorG, ColorB, 5.0, 10.0)
                DrawLightWithRange(441.98, -983.45, 35.97, ColorR, ColorB, ColorG, 5.0, 10.0)
            else
                Citizen.Wait(450)
            end
        else
            Citizen.Wait(450)
        end
    end
end)

-- // Events \\ --

RegisterNetEvent('ls-police:client:try:toggle:disco')
AddEventHandler('ls-police:client:try:toggle:disco', function()
    if DiscoMode then
        TriggerServerEvent('ls-police:server:toggle:disco:mode', false)
    else
        TriggerServerEvent('ls-police:server:toggle:disco:mode', true)
    end
end)

RegisterNetEvent('ls-police:client:toggle:disco:mode')
AddEventHandler('ls-police:client:toggle:disco:mode', function(Bool)
    DiscoMode = Bool
    if not Bool then
        DarkModeOn = false
        SetArtificialLightsState(false)
    end
end)