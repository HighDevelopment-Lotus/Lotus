local WallRendered, ShowBigWin, LastUpdated = nil, false, 0
InsideCasino, LoggedIn, LSCore = false, false, exports['ls-core']:GetCoreObject()

RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
    LoggedIn = true
end)

RegisterNetEvent('LSCore:Client:OnPlayerUnload')
AddEventHandler('LSCore:Client:OnPlayerUnload', function()
    LoggedIn = false
end)

Citizen.CreateThread(function()
   LoggedIn = true
   SetupDealers()
end)

RegisterCommand('win', function(source, args)
  ShowBigWin = true
end)

-- Code

-- // Loops \\ --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
            if not InsideCasino then
                local Distance = #(PlayerCoords - vector3(934.1, 45.24, 81.09))
                if Distance < 2.0 then
                    InsideCasino = true
                    EnterCasino()
                end
            else
                local Distance = #(PlayerCoords - vector3(1089.69, 206.60, -48.99))
                if Distance < 2.0 then
                    InsideCasino = false
                    LeaveCasino()
                end
            end
        end
    end
end)

-- // Events \\ --

-- Citizen.CreateThread(function()
--     SetupDealers()
-- end)

RegisterNetEvent('ls-casino:client:setup:dealers')
AddEventHandler('ls-casino:client:setup:dealers', function()
    --SetupDealers()
    --print('sadfasdf')
end)

-- // Function \\ --

function BackgroundAudio()
    Citizen.CreateThread(function()
        function AudioBanks()
            while not RequestScriptAudioBank("DLC_VINEWOOD/CASINO_GENERAL", false, -1) do
                Citizen.Wait(0)
            end
            while not RequestScriptAudioBank("DLC_VINEWOOD/CASINO_SLOT_MACHINES_01", false, -1) do
                Citizen.Wait(0)
            end
            while not RequestScriptAudioBank("DLC_VINEWOOD/CASINO_SLOT_MACHINES_02", false, -1) do
                Citizen.Wait(0)
            end
            while not RequestScriptAudioBank("DLC_VINEWOOD/CASINO_SLOT_MACHINES_03", false, -1) do
                Citizen.Wait(0)
            end
        end
        AudioBanks()
        while InsideCasino do
            if not IsStreamPlaying() and LoadStream("casino_walla", "DLC_VW_Casino_Interior_Sounds") then
                PlayStreamFromPosition(1111, 230, -47)
            end
            if IsStreamPlaying() and not IsAudioSceneActive("DLC_VW_Casino_General") then
                StartAudioScene("DLC_VW_Casino_General")
            end
            Citizen.Wait(1000)
        end
        if IsStreamPlaying() then
            StopStream()
        end
        if IsAudioSceneActive("DLC_VW_Casino_General") then
            StopAudioScene("DLC_VW_Casino_General")
        end
    end)
end

function DiamondScreens()
    RequestStreamedTextureDict('Prop_Screen_Vinewood')
    while not HasStreamedTextureDictLoaded('Prop_Screen_Vinewood') do
        Citizen.Wait(100)
    end
    RegisterNamedRendertarget('casinoscreen_01')
    LinkNamedRendertarget(`vw_vwint01_video_overlay`)
    WallRendered = GetNamedRendertargetRenderId('casinoscreen_01')
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            if not InsideCasino then
                ReleaseNamedRendertarget('casinoscreen_01')
                WallRendered = nil
                ShowBigWin = false
                break
            end
            if WallRendered then
                local CurrentTime = GetGameTimer()
                if ShowBigWin then
                    SetWallWin()
                    LastUpdated = GetGameTimer() - 33666
                    ShowBigWin = false
                else
                    if (CurrentTime - LastUpdated) >= 42666 then
                        SetWallNormal()
                        LastUpdated = CurrentTime
                    end
                end
                SetTextRenderId(WallRendered)
                SetScriptGfxDrawOrder(4)
                SetScriptGfxDrawBehindPausemenu(true)
                DrawInteractiveSprite('Prop_Screen_Vinewood', 'BG_Wall_Colour_4x4', 0.25, 0.5, 0.5, 1.0, 0.0, 255, 255, 255, 255)
                DrawTvChannel(0.5, 0.5, 1.0, 1.0, 0.0, 255, 255, 255, 255)
                SetTextRenderId(GetDefaultScriptRendertargetRenderId())
            end
        end
    end)
end

function SetupDealers()
    for k, v in pairs(Config.Dealers) do
        exports['ls-assets']:RequestModelHash(v['PedModel'])
        NpcPed = CreatePed(4, v['PedModel'], v['PedCoords'].x, v['PedCoords'].y, v['PedCoords'].z - 0.95, v['PedCoords'].w, false, false)
        FreezeEntityPosition(NpcPed, true)
        SetEntityInvincible(NpcPed, true)
        SetBlockingOfNonTemporaryEvents(NpcPed, true)
        SetPedVoiceGroup(NpcPed, GetHashKey("S_M_Y_Casino_01_WHITE_01"))
        SetPedDefaultComponentVariation(NpcPed)
        SetPedComponentVariation(NpcPed, 0, 2, 2, 0)
        SetPedComponentVariation(NpcPed, 1, 1, 0, 0)
        SetPedComponentVariation(NpcPed, 2, 4, 0, 0)
        SetPedComponentVariation(NpcPed, 3, 0, 3, 0)
        SetPedComponentVariation(NpcPed, 4, 0, 0, 0)
        SetPedComponentVariation(NpcPed, 6, 1, 0, 0)
        SetPedComponentVariation(NpcPed, 7, 2, 0, 0)
        SetPedComponentVariation(NpcPed, 8, 1, 0, 0)
        SetPedComponentVariation(NpcPed, 10, 1, 0, 0)
        SetPedComponentVariation(NpcPed, 11, 1, 0, 0)
        TaskPlayAnim(NpcPed, 'anim_casino_b@amb@casino@games@shared@dealer@', "idle", 1000.0, -2.0, -1, 2, 1148846080, 0)
        TriggerServerEvent('ls-casino:server:set:ped', k, PedToNet(NpcPed))
    end
end

-- SetPedVoiceGroup(dealerPed,GetHashKey("S_M_Y_Casino_01_WHITE_01"))
--  SetPedDefaultComponentVariation(dealerPed)
--  SetPedComponentVariation(dealerPed, 0, 2, 2, 0)
--  SetPedComponentVariation(dealerPed, 1, 1, 0, 0)
--  SetPedComponentVariation(dealerPed, 2, 4, 0, 0)
--  SetPedComponentVariation(dealerPed, 3, 0, 3, 0)
--  SetPedComponentVariation(dealerPed, 4, 0, 0, 0)
--  SetPedComponentVariation(dealerPed, 6, 1, 0, 0)
--  SetPedComponentVariation(dealerPed, 7, 2, 0, 0)
--  SetPedComponentVariation(dealerPed, 8, 1, 0, 0)
--  SetPedComponentVariation(dealerPed, 10, 1, 0, 0)
--  SetPedComponentVariation(dealerPed, 11, 1, 0, 0)

-- function RemoveDealers()
--     for k, v in pairs(Config.Dealers) do
--         NetworkRequestControlOfEntity(v['PedId'])
--         DeletePed(v['PedId'])
--         v['PedId'] = nil
--     end
-- end

function SetWallWin()
    SetTvChannelPlaylist(0, 'CASINO_WIN_PL', true)
    SetTvAudioFrontend(true)
    SetTvVolume(-100.0)
    SetTvChannel(-1)
    SetTvChannel(0)
end

function SetWallNormal()
    SetTvChannelPlaylist(0, 'CASINO_DIA_PL', true)
    SetTvAudioFrontend(true)
    SetTvVolume(-100.0)
    SetTvChannel(0)
end

function EnterCasino()
    DoScreenFadeOut(500)
    Citizen.Wait(500)
    NetworkFadeOutEntity(PlayerPedId(), true, true)
    Citizen.Wait(300)
    ClearPedTasksImmediately(PlayerPedId())
    SetGameplayCamRelativeHeading(0.0)
    SetEntityCoords(GetPlayerPed(-1), 1091.63, 211.09, -49.00)
    BackgroundAudio()
    DiamondScreens()
    exports['ls-weathersync']:SetClientSync(false)
    NetworkFadeInEntity(PlayerPedId(), true)
    Citizen.Wait(500)
    DoScreenFadeIn(500)
end

function LeaveCasino()
    DoScreenFadeOut(500)
    Citizen.Wait(500)
    NetworkFadeOutEntity(PlayerPedId(), true, true)
    Citizen.Wait(300)
    ClearPedTasksImmediately(PlayerPedId())
    SetGameplayCamRelativeHeading(0.0)
    SetEntityCoords(GetPlayerPed(-1), 931.50, 42.33, 81.09)
    exports['ls-weathersync']:SetClientSync(true)
    NetworkFadeInEntity(PlayerPedId(), true)
    Citizen.Wait(500)
    DoScreenFadeIn(500)
end