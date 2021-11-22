function GenerateNewDui(URL, Width, Height, DuiId)
    if Config.SavedDuiData[DuiId] == nil then
        local Width, Height = Width or 1920, Height or 1080
        local DuiSize = tostring(Width) .. 'x' .. tostring(Height)
        local GenerateDictName = DuiSize..'-dict-'..tostring(DuiNumber)
        local GenerateTxtName = DuiSize..'-txt-'..tostring(DuiNumber)
        local URL = Config.DuiLinks[DuiId] ~= nil and Config.DuiLinks[DuiId] or URL
        local DuiObject = CreateDui(URL, Width, Height)
        local DictObject = CreateRuntimeTxd(GenerateDictName)
        local DuiHandle = GetDuiHandle(DuiObject)
        local TxdObject = CreateRuntimeTextureFromDuiHandle(DictObject, GenerateTxtName, DuiHandle)
        local ReturnData = {
            ['DuiId'] = DuiId,
            ['DuiSize'] = DuiSize,
            ['DuiObject'] = DuiObject,
            ['DuiHandle'] = DuiHandle,
            ['DictObject'] = DictObject,
            ['TxdObject'] = TxdObject,
            ['TxdDictName'] = GenerateDictName,
            ['TxdName'] = GenerateTxtName,
            ['Width'] = Width,
            ['Height'] = Height,
            ['DuiUrl'] = URL,
        }
        Config.DuiLinks[DuiId] = URL
        Config.SavedDuiData[DuiId] = ReturnData
        TriggerServerEvent('ls-assets:serrver:set:dui:data', DuiId, ReturnData)
        return ReturnData
    else
        return false
    end
end

function GetDuiData(DuiId)
    if Config.SavedDuiData[DuiId] ~= nil then
        return Config.SavedDuiData[DuiId]
    end
end

function ReleaseDui(DuiId)
    if Config.SavedDuiData[DuiId] ~= nil then
        local Settings = Config.SavedDuiData[DuiId]
        SetDuiUrl(Settings['DuiObject'], 'about:blank')
        DestroyDui(Settings['DuiObject'])
        Config.SavedDuiData[DuiId] = nil
    end
end

function DeactivateDui(DuiId)
    if Config.SavedDuiData[DuiId] ~= nil then
        local Settings = Config.SavedDuiData[DuiId]
        SetDuiUrl(Settings['DuiObject'], 'about:blank')
    end
end

function ActivateDui(DuiId)
    if Config.SavedDuiData[DuiId] ~= nil then
        local Settings = Config.SavedDuiData[DuiId]
        SetDuiUrl(Settings['DuiObject'], Config.DuiLinks[DuiId])
    end
end

-- // Events \\ --

RegisterNetEvent('ls-assets:client:set:dui:url')
AddEventHandler('ls-assets:client:set:dui:url', function(DuiId, URL)
    if Config.SavedDuiData[DuiId] ~= nil then
        local Settings = Config.SavedDuiData[DuiId]
        Config.DuiLinks[DuiId] = URL
        Settings['DuiUrl'] = URL
        SetDuiUrl(Settings['DuiObject'], URL)
    end
end)

RegisterNetEvent('ls-assets:client:change:dui:menu')
AddEventHandler('ls-assets:client:change:dui:menu', function(DuiId)
    local TxData = {['Title'] = 'URL?', ['Type'] = 'text', ['Logo'] = '<i class="fas fa-link"></i>'}
    LSCore.Functions.OpenInput(TxData, function(NoteData)
        if NoteData ~= false then
            TriggerServerEvent('ls-assets:server:set:dui:url', DuiId, NoteData)
        end
    end)
end)

RegisterNetEvent('ls-assets:client:set:dui:data')
AddEventHandler('ls-assets:client:set:dui:data', function(DuiId, DuiData)
    Config.DuiLinks[DuiId] = DuiData['DuiUrl']
    Config.SavedDuiData[DuiId] = DuiData
end)