local LSCore = exports["fw-base"]:GetCoreObject()
Accounts = {}

CreateThread(function()
    Wait(1500)
    local result = json.decode(LoadResourceFile(GetCurrentResourceName(), "./database.json"))

    if not result then
        return
    end

    for k,v in pairs(result) do
        local k = tostring(k)
        local v = tonumber(v)

        if k and v then
            Accounts[k] = v
        end
    end
end)

RegisterServerEvent("framework-bossmenu:server:withdrawMoney")
AddEventHandler("framework-bossmenu:server:withdrawMoney", function(amount)
    local src = source
    local xPlayer = LSCore.Functions.GetPlayer(src)
    local job = xPlayer.PlayerData.job.name

    if not Accounts[job] then
        Accounts[job] = 0
    end

    if Accounts[job] >= amount then
        Accounts[job] = Accounts[job] - amount
        xPlayer.Functions.AddMoney("cash", amount)
    else
        TriggerClientEvent('LSCore:Notify', src, "Invaild Amount :/", "error")
        return
    end

    TriggerClientEvent('framework-bossmenu:client:refreshSociety', -1, job, Accounts[job])
    SaveResourceFile(GetCurrentResourceName(), "./database.json", json.encode(Accounts), -1)
    TriggerEvent('framework-logs:server:createLog', 'bossmenu', 'Geld opnemen', "Met succes opgenomen €" .. amount .. ' (' .. job .. ')', src)
end)

RegisterServerEvent("framework-bossmenu:server:depositMoney")
AddEventHandler("framework-bossmenu:server:depositMoney", function(amount)
    local src = source
    local xPlayer = LSCore.Functions.GetPlayer(src)
    local job = xPlayer.PlayerData.job.name

    if not Accounts[job] then
        Accounts[job] = 0
    end

    if xPlayer.Functions.RemoveMoney("cash", amount) then
        Accounts[job] = Accounts[job] + amount
    else
        TriggerClientEvent('LSCore:Notify', src, "Invaild Amount :/", "error")
        return
    end

    TriggerClientEvent('framework-bossmenu:client:refreshSociety', -1, job, Accounts[job])
    SaveResourceFile(GetCurrentResourceName(), "./database.json", json.encode(Accounts), -1)
    TriggerEvent('framework-logs:server:createLog', 'bossmenu', 'Geld storten', "Succesvol gestort €" .. amount .. ' (' .. job .. ')', src)
end)

RegisterServerEvent("framework-bossmenu:server:addAccountMoney")
AddEventHandler("framework-bossmenu:server:addAccountMoney", function(account, amount)
    if not Accounts[account] then
        Accounts[account] = 0
    end
    
    Accounts[account] = Accounts[account] + amount
    TriggerClientEvent('framework-bossmenu:client:refreshSociety', -1, account, Accounts[account])
    SaveResourceFile(GetCurrentResourceName(), "./database.json", json.encode(Accounts), -1)
end)

RegisterServerEvent("framework-bossmenu:server:removeAccountMoney")
AddEventHandler("framework-bossmenu:server:removeAccountMoney", function(account, amount)
    if not Accounts[account] then
        Accounts[account] = 0
    end

    if Accounts[account] >= amount then
        Accounts[account] = Accounts[account] - amount
    end

    TriggerClientEvent('framework-bossmenu:client:refreshSociety', -1, account, Accounts[account])
    SaveResourceFile(GetCurrentResourceName(), "./database.json", json.encode(Accounts), -1)
end)

RegisterServerEvent("framework-bossmenu:server:openMenu")
AddEventHandler("framework-bossmenu:server:openMenu", function()
    local src = source
    local xPlayer = LSCore.Functions.GetPlayer(src)
    local job = xPlayer.PlayerData.job
    local job2 = xPlayer.PlayerData.job.isboss
    local employees = {}

    if job.isboss == true then
        if not Accounts[job.name] then
            Accounts[job.name] = 0
        end

        exports['oxmysql']:fetch("SELECT * FROM `players` WHERE `job` LIKE @job", {
            ['@job'] = '%'.. job.name ..'%',
        }, function(players)
            if players[1] ~= nil then
                for key, value in pairs(players) do
                    local isOnline = LSCore.Functions.GetPlayerByCitizenId(value.citizenid)

                    if isOnline then
                        table.insert(employees, {
                            source = isOnline.PlayerData.citizenid, 
                            grade = isOnline.PlayerData.job.grade,
                            isboss = isOnline.PlayerData.job.isboss,
                            name = isOnline.PlayerData.charinfo.firstname .. ' ' .. isOnline.PlayerData.charinfo.lastname
                        })
                    else
                        table.insert(employees, {
                            source = value.citizenid, 
                            grade =  json.decode(value.job).grade,
                            isboss = json.decode(value.job).isboss,
                            name = json.decode(value.charinfo).firstname .. ' ' .. json.decode(value.charinfo).lastname
                        })
                    end
                end
            end

            TriggerClientEvent('framework-bossmenu:client:openMenu', src, employees, LSCore.Shared.Jobs[job.name])
            TriggerClientEvent('framework-bossmenu:client:refreshSociety', -1, job.name, Accounts[job.name])
        end)
    else
        TriggerClientEvent('LSCore:Notify', src, "Je bent de baas niet, hoe ben je hier gekomen?!", "error")
    end
end)

RegisterServerEvent('framework-bossmenu:server:fireEmployee')
AddEventHandler('framework-bossmenu:server:fireEmployee', function(data)
    local src = source
    local xPlayer = LSCore.Functions.GetPlayer(src)
    local xEmployee = LSCore.Functions.GetPlayerByCitizenId(data.source)

    if xEmployee then
        if xEmployee.Functions.SetJob("unemployed", '1') then
            TriggerEvent('framework-logs:server:createLog', 'bossmenu', 'Ontslaan', "Succesvol ontslagen " .. GetPlayerName(xEmployee.PlayerData.source) .. ' (' .. xPlayer.PlayerData.job.name .. ')', src)

            TriggerClientEvent('LSCore:Notify', src, "Succesvol ontslagen!", "success")
            TriggerClientEvent('LSCore:Notify', xEmployee.PlayerData.source , "Je bent ontslagen.", "success")

            Wait(500)
            local employees = {}
            exports['oxmysql']:fetch("SELECT * FROM `characters_metadata` WHERE `job` LIKE @job", {
                ['@job'] = '%'.. xPlayer.PlayerData.job.name ..'%',
            }, function(players)
                if players[1] ~= nil then
                    for key, value in pairs(players) do
                        local isOnline = LSCore.Functions.GetPlayerByCitizenId(value.citizenid)
                    
                        if isOnline then
                            table.insert(employees, {
                                source = isOnline.PlayerData.citizenid, 
                                grade = isOnline.PlayerData.job.grade,
                                isboss = isOnline.PlayerData.job.isboss,
                                name = isOnline.PlayerData.charinfo.firstname .. ' ' .. isOnline.PlayerData.charinfo.lastname
                            })
                        else
                            table.insert(employees, {
                                source = value.citizenid, 
                                grade =  json.decode(value.job).grade,
                                isboss = json.decode(value.job).isboss,
                                name = json.decode(value.charinfo).firstname .. ' ' .. json.decode(value.charinfo).lastname
                            })
                        end
                    end
                    TriggerClientEvent('framework-bossmenu:client:refreshPage', src, 'employee', employees)
                end
            end)
        else
            TriggerClientEvent('LSCore:Notify', src, "Error.", "error")
        end
    else
        exports['oxmysql']:fetch("SELECT * FROM `players` WHERE `citizenid` = @cid LIMIT 1", {
            ['@cid'] = data.source,
        }, function(player)
            if player[1] ~= nil then
                xEmployee = player[1]

                local job = {}
	            job.name = "unemployed"
	            job.label = "Werkloos"
	            job.payment = 10
	            job.onduty = true
	            job.isboss = false
	            job.grade = {}
	            job.grade.name = nil
                job.grade.level = 0

                exports['oxmysql']:execute("UPDATE `players` SET `job` = @job WHERE `citizenid` = @cid", {
                    ['@job'] = json.encode(job),
                    ['@cid'] = data.source,
                })
                TriggerClientEvent('LSCore:Notify', src, "Succesvol ontslagen!", "success")
                TriggerEvent('framework-logs:server:createLog', 'bossmenu', 'Fire', "Succesvol ontslagen " .. data.source .. ' (' .. xPlayer.PlayerData.job.name .. ')', src)
                
                Wait(500)
                local employees = {}
                exports['oxmysql']:fetch("SELECT * FROM `players` WHERE `job` LIKE @job", {
                    ['@job'] = '%'.. xPlayer.PlayerData.job.name ..'%',
                }, function(players)
                    if players[1] ~= nil then
                        for key, value in pairs(players) do
                            local isOnline = LSCore.Functions.GetPlayerByCitizenId(value.citizenid)
                        
                            if isOnline then
                                table.insert(employees, {
                                    source = isOnline.PlayerData.citizenid, 
                                    grade = isOnline.PlayerData.job.grade,
                                    isboss = isOnline.PlayerData.job.isboss,
                                    name = isOnline.PlayerData.charinfo.firstname .. ' ' .. isOnline.PlayerData.charinfo.lastname
                                })
                            else
                                table.insert(employees, {
                                    source = value.citizenid, 
                                    grade =  json.decode(value.job).grade,
                                    isboss = json.decode(value.job).isboss,
                                    name = json.decode(value.charinfo).firstname .. ' ' .. json.decode(value.charinfo).lastname
                                })
                            end
                        end

                        TriggerClientEvent('framework-bossmenu:client:refreshPage', src, 'employee', employees)
                    end
                end)
            else
                TriggerClientEvent('LSCore:Notify', src, "Fout. Kan speler niet vinden.", "error")
            end
        end)
    end
end)

RegisterServerEvent('framework-bossmenu:server:giveJob')
AddEventHandler('framework-bossmenu:server:giveJob', function(data)
    local src = source
    local xPlayer = LSCore.Functions.GetPlayer(src)
    local xTarget = LSCore.Functions.GetPlayerByCitizenId(data.source)

    if xPlayer.PlayerData.job.isboss == true then
        if xTarget and xTarget.Functions.SetJob(xPlayer.PlayerData.job.name, '1') then
            TriggerClientEvent('LSCore:Notify', src, "You recruit " .. (xTarget.PlayerData.charinfo.firstname .. ' ' .. xTarget.PlayerData.charinfo.lastname) .. " to " .. xPlayer.PlayerData.job.label .. ".", "success")
            TriggerClientEvent('LSCore:Notify', xTarget.PlayerData.source , "U bent gerekruteerd voor " .. xPlayer.PlayerData.job.label .. ".", "success")
            TriggerEvent('framework-logs:server:createLog', 'bossmenu', 'Recruit', "Succesvol gerekruteerd " .. (xTarget.PlayerData.charinfo.firstname .. ' ' .. xTarget.PlayerData.charinfo.lastname) .. ' (' .. job .. ')', src)
        end
    else
        TriggerClientEvent('LSCore:Notify', src, "Je bent de baas niet, hoe ben je hier gekomen?!", "error")
    end
end)

RegisterServerEvent('framework-bossmenu:server:updateGrade')
AddEventHandler('framework-bossmenu:server:updateGrade', function(data)
    local src = source
    local xPlayer = LSCore.Functions.GetPlayer(src)
    local xEmployee = LSCore.Functions.GetPlayerByCitizenId(data.source)

    if xEmployee then
        if xEmployee.Functions.SetJob(xPlayer.PlayerData.job.name, data.grade) then
            TriggerClientEvent('LSCore:Notify', src, "Promoted successfully!", "success")
            TriggerClientEvent('LSCore:Notify', xEmployee.PlayerData.source , "Je bent net gepromoveerd [" .. data.grade .."].", "success")

            Wait(500)
            local employees = {}
            exports['oxmysql']:execute("SELECT * FROM `players` WHERE `job` LIKE @job", {
                ['@job'] = '%'..xPlayer.PlayerData.job.name..'%',
            }, function(players)
                if players[1] ~= nil then
                    for key, value in pairs(players) do
                        local isOnline = LSCore.Functions.GetPlayerByCitizenId(value.citizenid)
                    
                        if isOnline then
                            table.insert(employees, {
                                source = isOnline.PlayerData.citizenid, 
                                grade = isOnline.PlayerData.job.grade,
                                isboss = isOnline.PlayerData.job.isboss,
                                name = isOnline.PlayerData.charinfo.firstname .. ' ' .. isOnline.PlayerData.charinfo.lastname
                            })
                        else
                            table.insert(employees, {
                                source = value.citizenid, 
                                grade =  json.decode(value.job).grade,
                                isboss = json.decode(value.job).isboss,
                                name = json.decode(value.charinfo).firstname .. ' ' .. json.decode(value.charinfo).lastname
                            })
                        end
                    end

                    TriggerClientEvent('framework-bossmenu:client:refreshPage', src, 'employee', employees)
                end
            end)
        else
            TriggerClientEvent('LSCore:Notify', src, "Error.", "error")
        end
    else
        exports['oxmysql']:execute("SELECT * FROM `players` WHERE `citizenid` = @cid LIMIT 1", {
            ['@cid'] = data.source,
        }, function(player)
            if player[1] ~= nil then
                xEmployee = player[1]
                local job = LSCore.Shared.Jobs[xPlayer.PlayerData.job.name]
                local employeejob = json.decode(xEmployee.job)
                employeejob.grade = job.grades[data.grade]
                LSCore.Functions.UpdateSql(false, "UPDATE `players` SET `job` = @job WHERE `citizenid` = @cid", {
                    ['@job'] = json.encode(employeejob),
                    ['@cid'] = data.source,
                })
                TriggerClientEvent('LSCore:Notify', src, "Succesvol gepromoot!", "success")
                
                Wait(500)
                local employees = {}
                exports['oxmysql']:execute("SELECT * FROM `players` WHERE `job` LIKE @job", {
                    ['@job'] = '%'..xPlayer.PlayerData.job.name..'%',
                }, function(players)
                    if players[1] ~= nil then
                        for key, value in pairs(players) do
                            local isOnline = LSCore.Functions.GetPlayerByCitizenId(value.citizenid)
                        
                            if isOnline then
                                table.insert(employees, {
                                    source = isOnline.PlayerData.citizenid, 
                                    grade = isOnline.PlayerData.job.grade,
                                    isboss = isOnline.PlayerData.job.isboss,
                                    name = isOnline.PlayerData.charinfo.firstname .. ' ' .. isOnline.PlayerData.charinfo.lastname
                                })
                            else
                                table.insert(employees, {
                                    source = value.citizenid, 
                                    grade =  json.decode(value.job).grade,
                                    isboss = json.decode(value.job).isboss,
                                    name = json.decode(value.charinfo).firstname .. ' ' .. json.decode(value.charinfo).lastname
                                })
                            end
                        end

                        TriggerClientEvent('framework-bossmenu:client:refreshPage', src, 'employee', employees)
                    end
                end)
            else
                TriggerClientEvent('LSCore:Notify', src, "Fout. Kan speler niet vinden.", "error")
            end
        end)
    end
end)

RegisterServerEvent('framework-bossmenu:server:updateNearbys')
AddEventHandler('framework-bossmenu:server:updateNearbys', function(data)
    local src = source
    local players = {}
    local xPlayer = LSCore.Functions.GetPlayer(src)
    for _, player in pairs(data) do
        local xTarget = LSCore.Functions.GetPlayer(player)
        if xTarget and xTarget.PlayerData.job.name ~= xPlayer.PlayerData.job.name then
            table.insert(players, {
                source = xTarget.PlayerData.citizenid,
                name = xTarget.PlayerData.charinfo.firstname .. ' ' .. xTarget.PlayerData.charinfo.lastname
            })
        end
    end

    TriggerClientEvent('framework-bossmenu:client:refreshPage', src, 'recruits', players)
end)

function GetAccount(account)
    return Accounts[account] or 0
end