local LSCore = exports['fw-base']:GetCoreObject()
local SpawnCam, FakeCharPed = nil, nil

RegisterNetEvent('LSCore:Client:CloseNui')
AddEventHandler('LSCore:Client:CloseNui', function()
    SetNuiFocus(false, false)
end)

-- Code

-- // Loops \\ --

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(4)
		if NetworkIsSessionStarted() then
			StartCharScreen()
			return
		end
	end
end)

-- // Events \\ --

RegisterNetEvent('framework-multichar:client:open:select')
AddEventHandler('framework-multichar:client:open:select', function()
    StartCharScreen()
end)

-- // Function \\ --

function StartCharScreen()
    DoScreenFadeOut(10)
    Citizen.Wait(1000)
    LSCore.Functions.TriggerCallback('framework-multichar:server:get:char:data', function(CharData)
        for k,v in pairs(CharData) do
            Config.CharData[v['Cid']] = v
            Config.CharData[v['Cid']]['Active'] = true
        end
        SetNuiFocus(true, true)
        SendNuiMessage(json.encode({action = 'SetupChars'}))
    end)
    SetEntityCoords(PlayerPedId(), -1412.073, -994.5971, 19.380468)
    FreezeEntityPosition(PlayerPedId(), true)	
    SetEntityVisible(PlayerPedId(), false)
    exports['fw-weathersync']:SetClientSync(true)
    SetCam(true)
    Citizen.Wait(750)
    ShutdownLoadingScreenNui()
    ShutdownLoadingScreen()
    DoScreenFadeIn(1000)
end

function ResetConfig()
    SpawnCam = nil
    FakeCharPed = nil
    Config.CharData[1] = {['Active'] = false}
    Config.CharData[2] = {['Active'] = false}
    Config.CharData[3] = {['Active'] = false}
    Config.CharData[4] = {['Active'] = false}
    Config.CharData[5] = {['Active'] = false}
end

function SetCam(bool)
    DestroyAllCams()
    if SpawnCam == nil then
        SpawnCam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", -1408.864, -992.2024, 19.4242, 0.00, 0.00, 120.00, 60.00, false, 0)
        SetCamActive(SpawnCam, true)
        RenderScriptCams(true, false, 1, true, true)
    else
        DestroyAllCams()
        SpawnCam = nil
    end
end

RegisterNUICallback('GetChar', function(data, cb)
    cb(Config.CharData[data.CharNumber])
    if FakeCharPed == nil then
        local LoadModel = GetHashKey('mp_m_freemode_01')
        if Config.CharData[data.CharNumber]['Model'] ~= nil then
            LoadModel = Config.CharData[data.CharNumber]['Model']
        end
        exports['fw-assets']:RequestModelHash(LoadModel)
        FakeCharPed = CreatePed(2, LoadModel, Config.Locations['Ped']['X'], Config.Locations['Ped']['Y'], Config.Locations['Ped']['Z'], Config.Locations['Ped']['H'], false, false)
        if Config.CharData[data.CharNumber]['Skin'] ~= nil then
            TriggerEvent('framework-clothing:client:loadPlayerClothing', Config.CharData[data.CharNumber]['Skin'], FakeCharPed)
        end
        SetEveryoneIgnorePlayer(FakeCharPed, true)
        NetworkSetEntityInvisibleToNetwork(FakeCharPed, true)
        SetEntityInvincible(FakeCharPed, true)
        SetBlockingOfNonTemporaryEvents(FakeCharPed, true)
        SetPedConfigFlag(FakeCharPed, 410, true)
        SetEntityCanBeDamagedByRelationshipGroup(FakeCharPed, false, GetHashKey('PLAYER'))
        FreezeEntityPosition(FakeCharPed, false)
        SetEntityAsMissionEntity(FakeCharPed, true, true)
        ClearPedTasks(FakeCharPed)
        exports['fw-assets']:RequestAnimationDict("friends@frj@ig_1")
        TaskPlayAnim(FakeCharPed, 'friends@frj@ig_1', 'wave_d', 3.0, 3.0, -1, 49, 0, false, false, false)
        Citizen.Wait(GetAnimDuration('friends@frj@ig_1', 'wave_d') * 1000)
        ClearPedTasks(FakeCharPed)
    else 
        if Config.CharData[data.CharNumber]['Active'] then
            local LoadModel = GetHashKey('mp_m_freemode_01')
            if Config.CharData[data.CharNumber]['Model'] ~= nil then
                LoadModel = Config.CharData[data.CharNumber]['Model']
            end
            exports['fw-assets']:RequestModelHash(LoadModel)
            if GetEntityModel(FakeCharPed) ~= LoadModel then
                DeleteEntity(FakeCharPed)
                FakeCharPed = CreatePed(2, LoadModel, Config.Locations['Ped']['X'], Config.Locations['Ped']['Y'], Config.Locations['Ped']['Z'], Config.Locations['Ped']['H'], false, false)
                SetEveryoneIgnorePlayer(FakeCharPed, true)
                NetworkSetEntityInvisibleToNetwork(FakeCharPed, true)
                SetEntityInvincible(FakeCharPed, true)
                SetBlockingOfNonTemporaryEvents(FakeCharPed, true)
                SetPedConfigFlag(FakeCharPed, 410, true)
                SetEntityCanBeDamagedByRelationshipGroup(FakeCharPed, false, GetHashKey('PLAYER'))
                FreezeEntityPosition(FakeCharPed, false)
                SetEntityAsMissionEntity(FakeCharPed, true, true)
            end
            SetPedComponentVariation(FakeCharPed, 0, 0, 0, 2)
            if Config.CharData[data.CharNumber]['Skin'] ~= nil then
                TriggerEvent('framework-clothing:client:loadPlayerClothing', Config.CharData[data.CharNumber]['Skin'], FakeCharPed)
            end
        else
            for i = 0, 12 do
                ClearPedProp(FakeCharPed, i)
                SetPedComponentVariation(FakeCharPed, i, 0, 0, 0)
            end
            SetPedHeadBlendData(FakeCharPed, 0,0,0,0,0,0,0,0,0,0)
        end
        ClearPedTasks(FakeCharPed)
        exports['fw-assets']:RequestAnimationDict("friends@frj@ig_1")
        TaskPlayAnim(FakeCharPed, 'friends@frj@ig_1', 'wave_d', 3.0, 3.0, -1, 49, 0, false, false, false)
        Citizen.Wait(GetAnimDuration('friends@frj@ig_1', 'wave_d') * 1000)
        ClearPedTasks(FakeCharPed)
    end
end)

RegisterNUICallback('ChooseChar', function(data)
    ClearPedTasks(FakeCharPed)
    exports['fw-assets']:RequestAnimationDict("anim@mp_fm_event@intro")
    TaskPlayAnim(FakeCharPed, 'anim@mp_fm_event@intro', 'beast_transform', 3.0, 3.0, -1, 49, 0, false, false, false)
    Citizen.SetTimeout(2000, function()
        DoScreenFadeOut(150)
        Citizen.Wait(150)
        NetworkRequestControlOfEntity(FakeCharPed)
        DeleteEntity(FakeCharPed)
        ResetConfig()
        TriggerServerEvent('framework-multichar:server:select:char', data.CitizenId)
    end)
end)

RegisterNUICallback('CreateChar', function(data)
    local NewCharData = {Slot = data.Slot, Firstname = data.FirstName, Lastname = data.LastName, Birthdate = data.BirthDate, Gender = data.Gender}
    ClearPedTasks(FakeCharPed)
    exports['fw-assets']:RequestAnimationDict("anim@mp_fm_event@intro")
    TaskPlayAnim(FakeCharPed, 'anim@mp_fm_event@intro', 'beast_transform', 3.0, 3.0, -1, 49, 0, false, false, false)
    Citizen.SetTimeout(2000, function()
        DoScreenFadeOut(150)
        Citizen.Wait(150)
        NetworkRequestControlOfEntity(FakeCharPed)
        DeleteEntity(FakeCharPed)
        ResetConfig()
        TriggerServerEvent('framework-multichar:server:create:new:char', NewCharData)
    end)
end)

RegisterNUICallback('DeleteCharacter', function(data)
    SetEntityHealth(FakeCharPed, 0.0)
    Citizen.SetTimeout(1750, function()
        DoScreenFadeOut(150)
        Citizen.Wait(150)
        NetworkRequestControlOfEntity(FakeCharPed)
        DeleteEntity(FakeCharPed)
        ResetConfig()
        TriggerServerEvent('framework-multichar:server:delete:char', data.CitizenId)
    end)
end)

RegisterNUICallback('ClickSound', function()
    PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
end)

RegisterNUICallback('ErrorSound', function()
    PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
end)

RegisterNUICallback('CloseUi', function()
    SetNuiFocus(false, false)
end)