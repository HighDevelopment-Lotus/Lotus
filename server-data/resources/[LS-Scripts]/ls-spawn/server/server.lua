local LSCore = exports['ls-core']:GetCoreObject()

-- Code

LSCore.Functions.CreateCallback('ls-spawn:server:get:houses', function(source, cb, citizenid)
    local TempTable = {}
    LSCore.Functions.ExecuteSql(true, "SELECT * FROM `player_houses` WHERE `citizenid` = '"..citizenid.."'", function(result)
        if result[1] ~= nil then
            for k, v in pairs(result) do
                local HouseData = {}
                HouseData['Label'] = v.label
                HouseData['Coords'] = json.decode(v.coords)['Enter']
                table.insert(TempTable, HouseData)
            end
            cb(TempTable)
        else
            local EmptyTable = {}
            cb(EmptyTable)
        end
    end)
end)