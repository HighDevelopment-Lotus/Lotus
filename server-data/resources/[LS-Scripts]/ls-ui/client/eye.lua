local DoingRayCast, ShowingEye, PreviousEntity = false, false, 1
local CurrentEntity = {}
local HitData = false

-- Code

-- // Loops \\ --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            if IsControlJustPressed(0, 47) and not IsPedInAnyVehicle(GetPlayerPed(-1)) then
                if not ShowingEye then
                    DoingRayCast = true
                    ShowingEye = true
                    SetNuiFocus(true, false)
                    SetNuiFocusKeepInput(true)
                    SendNUIMessage({action = 'OpenEye'})
                    TriggerEvent('ls-inventory-new:client:set:inventory:state', false)
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
            if ShowingEye then
                if IsControlJustReleased(0, 68) then
                    if HitData then
                        if not MouseActive then
                            MouseActive = true
                            SetNuiFocus(true, true)
                            SetNuiFocusKeepInput(false)
                            SendNuiMessage(json.encode({action = 'SetMouseState', mouse = true}))
                            Citizen.InvokeNative(0xFC695459D4D0E219, 0.5, 0.5)
                        end
                    end
                end
                DisableControlAction(0, 24, true)
                DisableControlAction(0, 25, true)
                DisablePlayerFiring(PlayerId(), true)
            else
                Citizen.Wait(150)
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
            if DoingRayCast then
                local DataOne, DataTwo, DataThree, DataFour, DataFive, DataSix = RayCastGamePlayCamera()
                if DataFive ~= PreviousEntity then
                    CurrentEntity['Entity'] = DataFive
                    CurrentEntity['Hash'] = GetEntityModel(DataFive)
                    CurrentEntity['Coords'] = DataSix
                    CurrentEntity['EntityCoords'] = GetEntityCoords(DataFive)
                    CurrentEntity['EntityHeading'] =  GetEntityHeading(DataFive)
                    CurrentEntity['EntityRotation'] = GetEntityRotation(DataFive)
                    CurrentEntity['IsPlayer'] = false
                    CurrentEntity['IsCar'] = false
                    CurrentEntity['IsPed'] = false
                    CurrentEntity['IsBike'] = false
                    if IsPedAPlayer(DataFive) then
                        CurrentEntity['IsPlayer'] = true
                    elseif IsEntityAVehicle(DataFive) and GetVehicleClass(DataFive) ~= 13 and GetVehicleClass(DataFive) ~= 15 and GetVehicleClass(DataFive) ~= 16 and GetVehicleClass(DataFive) ~= 21 then
                        CurrentEntity['IsCar'] = true 
                    elseif IsEntityAVehicle(DataFive) and GetVehicleClass(DataFive) == 13 then
                        CurrentEntity['IsBike'] = true
                    elseif IsModelAPed(CurrentEntity['Hash']) then
                        CurrentEntity['IsPed'] = true
                    end
                    Config.EntityData = CurrentEntity
                    SendCurrentObjectData(CurrentEntity)
                    PreviousEntity = DataFive
                end
            else
                Citizen.Wait(450)
            end
        end
    end
end)


-- // Main Functions \\ --

function SendCurrentObjectData(Data)
    local SendMenu = {}
    local Player = LSCore.Functions.GetPlayerData()
    if Config.ObjectOptions[Data['Hash']] ~= nil then
        for k, v in pairs(Config.ObjectOptions[Data['Hash']]['Options']) do
            if v['Enabled']() then
                if (v['Job'] ~= false and v['UseDuty'] and v['Job'] == Player.job.name and Player.job.onduty) or (v['Job'] ~= false and not v['UseDuty'] and v['Job'] == Player.job.name) or (not v['Job']) then
                    local NewData = {}
                    NewData['Name'] = v['Name']
                    NewData['EventType'] = v['EventType']
                    NewData['Logo'] = v['Logo']
                    NewData['EventName'] = v['EventName']
                    NewData['EventParameter'] = v['EventParameter']
                    table.insert(SendMenu, NewData)
                end
            end
        end
        if #SendMenu > 0 then
            SendNUIMessage({
                action = 'SetData',
                currentdata = SendMenu,
            })
            HitData = true
        else
            HitData = false
            SendNUIMessage({action = 'ResetEye'})
        end
    elseif Data['IsCar'] then
        for k, v in pairs(Config.VehicleMenu) do
            if v['Enabled']() then
                if (v['Job'] ~= false and v['UseDuty'] and v['Job'] == Player.job.name and Player.job.onduty) or (v['Job'] ~= false and not v['UseDuty'] and v['Job'] == Player.job.name) or (not v['Job']) then
                    local NewData = {}
                    NewData['Name'] = v['Name']
                    NewData['EventType'] = v['EventType']
                    NewData['Logo'] = v['Logo']
                    NewData['EventName'] = v['EventName']
                    NewData['EventParameter'] = v['EventParameter']
                    table.insert(SendMenu, NewData)
                end
            end
        end
        if #SendMenu > 0 then
            SendNUIMessage({
                action = 'SetData',
                currentdata = SendMenu,
            })
            HitData = true
        else
            HitData = false
            SendNUIMessage({action = 'ResetEye'})
        end
    elseif Data['IsBike'] then
        for k, v in pairs(Config.BikeMenu) do
            if v['Enabled']() then
                if (v['Job'] ~= false and v['UseDuty'] and v['Job'] == Player.job.name and Player.job.onduty) or (v['Job'] ~= false and not v['UseDuty'] and v['Job'] == Player.job.name) or (not v['Job']) then
                    local NewData = {}
                    NewData['Name'] = v['Name']
                    NewData['EventType'] = v['EventType']
                    NewData['Logo'] = v['Logo']
                    NewData['EventName'] = v['EventName']
                    NewData['EventParameter'] = v['EventParameter']
                    table.insert(SendMenu, NewData)
                end
            end
        end
        if #SendMenu > 0 then
            SendNUIMessage({
                action = 'SetData',
                currentdata = SendMenu,
            })
            HitData = true
        else
            HitData = false
            SendNUIMessage({action = 'ResetEye'})
        end
    elseif Data['IsPed'] then
        for k, v in pairs(Config.PedMenu) do
            if v['Enabled']() then
                if (v['Job'] ~= false and v['UseDuty'] and v['Job'] == Player.job.name and Player.job.onduty) or (v['Job'] ~= false and not v['UseDuty'] and v['Job'] == Player.job.name) or (not v['Job']) then
                    local NewData = {}
                    NewData['Name'] = v['Name']
                    NewData['EventType'] = v['EventType']
                    NewData['Logo'] = v['Logo']
                    NewData['EventName'] = v['EventName']
                    NewData['EventParameter'] = v['EventParameter']
                    table.insert(SendMenu, NewData)
                end
            end
        end
        if #SendMenu > 0 then
            SendNUIMessage({
                action = 'SetData',
                currentdata = SendMenu,
            })
            HitData = true
        else
            HitData = false
            SendNUIMessage({action = 'ResetEye'})
        end
    elseif Data['IsPlayer'] then
        for k, v in pairs(Config.PlayerMenu) do
            if v['Enabled']() then
                if (v['Job'] ~= false and v['UseDuty'] and v['Job'] == Player.job.name and Player.job.onduty) or (v['Job'] ~= false and not v['UseDuty'] and v['Job'] == Player.job.name) or (not v['Job']) then
                    local NewData = {}
                    NewData['Name'] = v['Name']
                    NewData['EventType'] = v['EventType']
                    NewData['Logo'] = v['Logo']
                    NewData['EventName'] = v['EventName']
                    NewData['EventParameter'] = v['EventParameter']
                    table.insert(SendMenu, NewData)
                end
            end
        end
        if #SendMenu > 0 then
            SendNUIMessage({
                action = 'SetData',
                currentdata = SendMenu,
            })
            HitData = true
        else
            HitData = false
            SendNUIMessage({action = 'ResetEye'})
        end
    else
        HitData = false
        SendNUIMessage({action = 'ResetEye'})
    end
end

function ImportEyeData(data)
    if Config.ObjectOptions[GetHashKey(data['Prop'])] == nil then
        local Job = data['Job'] ~= nil and data['Job'] or false
        local Duty = data['Duty'] ~= nil and data['Duty'] or false
        Config.ObjectOptions[GetHashKey(data['Prop'])] = {
            ['Options'] = {
                [1] = {
                    ['Job'] = Job,
                    ['UseDuty'] = Duty,
                    ['Name'] = data['Name'],
                    ['EventType'] = data['Type'],
                    ['Logo'] = data['Logo'],
                    ['EventName'] = data['Event'], 
                    ['Enabled'] = function()
                        return true
                    end,
                },
            },
        }
    else
        print('Deze bestaat al..')
    end
end

RegisterNUICallback('CloseUi', function()
    SetNuiFocusKeepInput(false)
    SetNuiFocus(false, false)
    Citizen.Wait(60)
    ShowingEye = false
    PreviousEntity = 1
    MouseActive = false
    DoingRayCast = false
    SendNuiMessage(json.encode({action = 'SetMouseState', mouse = false}))
    Citizen.SetTimeout(165, function()
        CurrentEntity, Config.EntityData = {}, {}
    end)
    EnableControlAction(0, 24, true)
    EnableControlAction(0, 25, true)
    DisablePlayerFiring(PlayerId(), false)
    TriggerEvent('ls-inventory-new:client:set:inventory:state', true)
end)

RegisterNUICallback('CloseMenu', function()
    MouseActive = false
    SetNuiFocusKeepInput(true)
    SetNuiFocus(true, false)
    SendNuiMessage(json.encode({action = 'SetMouseState', mouse = false}))
end)

RegisterNUICallback('DoSomething', function(data)
    local EyeData = data.eyedata
    PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
    Citizen.SetTimeout(250, function()
        if EyeData['EventType'] == 'Client' then
            TriggerEvent(EyeData['EventName'], EyeData['EventParameter'], CurrentEntity)
            CurrentEntity, Config.EntityData = {}, {}
        else
            TriggerServerEvent(EyeData['EventName'], EyeData['EventParameter'], CurrentEntity)
            CurrentEntity, Config.EntityData = {}, {}
        end
    end)
end)

RegisterNetEvent('ls-ui:client:open:trunk')
AddEventHandler('ls-ui:client:open:trunk', function()
    NetworkRequestControlOfEntity(CurrentEntity['Entity'])
    if GetVehicleDoorAngleRatio(CurrentEntity['Entity'], 5) > 0.0 then
        SetVehicleDoorShut(CurrentEntity['Entity'], 5, false)
    else
        SetVehicleDoorOpen(CurrentEntity['Entity'], 5, false, false)
    end
end)

RegisterNetEvent('ls-ui:client:refresh')
AddEventHandler('ls-ui:client:refresh', function()
    SendNUIMessage({action = 'UiReload'})
    SendNUIMessage({action = 'Hide'})
    Citizen.SetTimeout(2000, function()
        LSCore.Functions.GetPlayerData(function(PlayerData)
            Hunger, Thirst, Stress = PlayerData.metadata["hunger"], PlayerData.metadata["thirst"], PlayerData.metadata["stress"]
            SendNUIMessage({action = 'SetMoney', amount = PlayerData.money['cash']})
            SendNUIMessage({action = 'Show'})
            InVehicle = false
        end)
    end)
end)