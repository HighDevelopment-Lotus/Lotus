local LSCore = exports['ls-core']:GetCoreObject()

-- Code

Races = {}

AvailableRaces = {}

LastRaces = {}
NotFinished = {}

Citizen.CreateThread(function()
    LSCore.Functions.ExecuteSql(false, "SELECT * FROM `server_lapraces`", function(races)
        if races[1] ~= nil then
            for k, v in pairs(races) do
                local Records = {}
                if v.records ~= nil then
                    Records = json.decode(v.records)
                end
                Races[v.raceid] = {
                    RaceName = v.name,
                    Checkpoints = json.decode(v.checkpoints),
                    Records = Records,
                    Creator = v.creator,
                    RaceId = v.raceid,
                    Started = false,
                    Waiting = false,
                    Distance = v.distance,
                    LastLeaderboard = {},
                    Racers = {},
                }
            end
        end
    end)
end)

LSCore.Functions.CreateCallback('ls-lapraces:server:GetRacingLeaderboards', function(source, cb)
    cb(Races)
end)

function SecondsToClock(seconds)
    local seconds = tonumber(seconds)
    local retval = 0
    if seconds <= 0 then
        retval = "00:00:00";
    else
        hours = string.format("%02.f", math.floor(seconds/3600));
        mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
        secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
        retval = hours..":"..mins..":"..secs
    end
    return retval
end

RegisterServerEvent('ls-lapraces:server:FinishPlayer')
AddEventHandler('ls-lapraces:server:FinishPlayer', function(RaceData, TotalTime, TotalLaps, BestLap)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    local AvailableKey = GetOpenedRaceKey(RaceData.RaceId)
    local PlayersFinished = 0
    local AmountOfRacers = 0
    for k, v in pairs(Races[RaceData.RaceId].Racers) do
        if v.Finished then
            PlayersFinished = PlayersFinished + 1
        end
        AmountOfRacers = AmountOfRacers + 1
    end
    local BLap = 0
    if TotalLaps < 2 then
        BLap = TotalTime
    else
        BLap = BestLap
    end
    if LastRaces[RaceData.RaceId] ~= nil then
        table.insert(LastRaces[RaceData.RaceId], {
            TotalTime = TotalTime,
            BestLap = BLap,
            Holder = {
                [1] = Player.PlayerData.charinfo.firstname,
                [2] = Player.PlayerData.charinfo.lastname
            }
        })
    else
        LastRaces[RaceData.RaceId] = {}
        table.insert(LastRaces[RaceData.RaceId], {
            TotalTime = TotalTime,
            BestLap = BLap,
            Holder = {
                [1] = Player.PlayerData.charinfo.firstname,
                [2] = Player.PlayerData.charinfo.lastname
            }
        })
    end
    if Races[RaceData.RaceId].Records ~= nil and next(Races[RaceData.RaceId].Records) ~= nil then
        if BLap < Races[RaceData.RaceId].Records.Time then
            Races[RaceData.RaceId].Records = {
                Time = BLap,
                Holder = {
                    [1] = Player.PlayerData.charinfo.firstname, 
                    [2] = Player.PlayerData.charinfo.lastname,
                }
            }
            LSCore.Functions.ExecuteSql(false, "UPDATE `server_lapraces` SET `records` = '"..json.encode(Races[RaceData.RaceId].Records).."' WHERE `raceid` = '"..RaceData.RaceId.."'")
            TriggerClientEvent('ls-phone_new:client:RaceNotify', src, 'Je hebt het WR van '..RaceData.RaceName..' verbroken met een tijd van: '..SecondsToClock(BLap)..'!')
        end
    else
        Races[RaceData.RaceId].Records = {
            Time = BLap,
            Holder = {
                [1] = Player.PlayerData.charinfo.firstname,
                [2] = Player.PlayerData.charinfo.lastname,
            }
        }
        LSCore.Functions.ExecuteSql(false, "UPDATE `server_lapraces` SET `records` = '"..json.encode(Races[RaceData.RaceId].Records).."' WHERE `raceid` = '"..RaceData.RaceId.."'")
        TriggerClientEvent('ls-phone_new:client:RaceNotify', src, 'Je hebt het WR van '..RaceData.RaceName..' neergezet met een tijd van: '..SecondsToClock(BLap)..'!')
    end
    AvailableRaces[AvailableKey].RaceData = Races[RaceData.RaceId]
    TriggerClientEvent('ls-lapraces:client:PlayerFinishs', -1, RaceData.RaceId, PlayersFinished, Player)
    if PlayersFinished == AmountOfRacers then
        if NotFinished ~= nil and next(NotFinished) ~= nil and NotFinished[RaceData.RaceId] ~= nil and next(NotFinished[RaceData.RaceId]) ~= nil then
            for k, v in pairs(NotFinished[RaceData.RaceId]) do
                table.insert(LastRaces[RaceData.RaceId], {
                    TotalTime = v.TotalTime,
                    BestLap = v.BestLap,
                    Holder = {
                        [1] = v.Holder[1],
                        [2] = v.Holder[2]
                    }
                })
            end
        end
        Races[RaceData.RaceId].LastLeaderboard = LastRaces[RaceData.RaceId]
        Races[RaceData.RaceId].Racers = {}
        Races[RaceData.RaceId].Started = false
        Races[RaceData.RaceId].Waiting = false
        table.remove(AvailableRaces, AvailableKey)
        LastRaces[RaceData.RaceId] = nil
        NotFinished[RaceData.RaceId] = nil
    end
    TriggerClientEvent('ls-phone_new:client:UpdateLapraces', -1)
end)

function IsWhitelisted(CitizenId)
    local retval = false
    for _, cid in pairs(Config.WhitelistedCreators) do
        if cid == CitizenId then
            retval = true
            break
        end
    end
    local Player = LSCore.Functions.GetPlayerByCitizenId(CitizenId)
    local Perms = LSCore.Functions.GetPermission(Player.PlayerData.source)
    if Perms == "admin" or Perms == "god" then
        retval = true
    end
    return retval
end

function IsNameAvailable(RaceName)
    local retval = true
    for RaceId,_ in pairs(Races) do
        if Races[RaceId].RaceName == RaceName then
            retval = false
            break
        end
    end
    return retval
end

RegisterServerEvent('ls-lapraces:server:CreateLapRace')
AddEventHandler('ls-lapraces:server:CreateLapRace', function(RaceName)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    
    if IsWhitelisted(Player.PlayerData.citizenid) then
        if IsNameAvailable(RaceName) then
            TriggerClientEvent('ls-lapraces:client:StartRaceEditor', source, RaceName)
        else
            TriggerClientEvent('LSCore:Notify', source, 'Er bestaat al een race met deze naam.', 'error')
        end
    else
        TriggerClientEvent('LSCore:Notify', source, 'Je hebt niet geautoriseerd om race\'s te creëren.', 'error')
    end
end)

LSCore.Functions.CreateCallback('ls-lapraces:server:GetRaces', function(source, cb)
    cb(AvailableRaces)
end)

LSCore.Functions.CreateCallback('ls-lapraces:server:GetListedRaces', function(source, cb)
    cb(Races)
end)

LSCore.Functions.CreateCallback('ls-lapraces:server:GetRacingData', function(source, cb, RaceId)
    cb(Races[RaceId])
end)

LSCore.Functions.CreateCallback('ls-lapraces:server:HasCreatedRace', function(source, cb)
    cb(HasOpenedRace(LSCore.Functions.GetPlayer(source).PlayerData.citizenid))
end)

LSCore.Functions.CreateCallback('ls-lapraces:server:IsAuthorizedToCreateRaces', function(source, cb, TrackName)
    cb(IsWhitelisted(LSCore.Functions.GetPlayer(source).PlayerData.citizenid), IsNameAvailable(TrackName))
end)

function HasOpenedRace(CitizenId)
    local retval = false
    for k, v in pairs(AvailableRaces) do
        if v.SetupCitizenId == CitizenId then
            retval = true
        end
    end
    return retval
end

LSCore.Functions.CreateCallback('ls-lapraces:server:GetTrackData', function(source, cb, RaceId)
    LSCore.Functions.ExecuteSql(false, "SELECT * FROM `players` WHERE `citizenid` = '"..Races[RaceId].Creator.."'", function(result)
        if result[1] ~= nil then
            result[1].charinfo = json.decode(result[1].charinfo)
            cb(Races[RaceId], result[1])
        else
            cb(Races[RaceId], {
                charinfo = {
                    firstname = "Unknown",
                    lastname = "Unknown",
                }
            })
        end
    end)
end)

function GetOpenedRaceKey(RaceId)
    local retval = nil
    for k, v in pairs(AvailableRaces) do
        if v.RaceId == RaceId then
            retval = k
            break
        end
    end
    return retval
end

function GetCurrentRace(MyCitizenId)
    local retval = nil
    for RaceId,_ in pairs(Races) do
        for cid,_ in pairs(Races[RaceId].Racers) do
            if cid == MyCitizenId then
                retval = RaceId
                break
            end
        end
    end
    return retval
end

RegisterServerEvent('ls-lapraces:server:JoinRace')
AddEventHandler('ls-lapraces:server:JoinRace', function(RaceData)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    local RaceName = RaceData.RaceData.RaceName
    local RaceId = GetRaceId(RaceName)
    local AvailableKey = GetOpenedRaceKey(RaceData.RaceId)
    local CurrentRace = GetCurrentRace(Player.PlayerData.citizenid)
    if CurrentRace ~= nil then
        local AmountOfRacers = 0
        PreviousRaceKey = GetOpenedRaceKey(CurrentRace)
        for k, v in pairs(Races[CurrentRace].Racers) do
            AmountOfRacers = AmountOfRacers + 1
        end
        Races[CurrentRace].Racers[Player.PlayerData.citizenid] = nil
        if (AmountOfRacers - 1) == 0 then
            Races[CurrentRace].Racers = {}
            Races[CurrentRace].Started = false
            Races[CurrentRace].Waiting = false
            table.remove(AvailableRaces, PreviousRaceKey)
            TriggerClientEvent('LSCore:Notify', src, 'Je was de enige in de race.. De race is beëindigd.', 'error')
            TriggerClientEvent('ls-lapraces:client:LeaveRace', src, Races[CurrentRace])
        else
            AvailableRaces[PreviousRaceKey].RaceData = Races[CurrentRace]
            TriggerClientEvent('ls-lapraces:client:LeaveRace', src, Races[CurrentRace])
        end
        TriggerClientEvent('ls-phone_new:client:UpdateLapraces', -1)
    end
    Races[RaceId].Waiting = true
    Races[RaceId].Racers[Player.PlayerData.citizenid] = {
        Checkpoint = 0,
        Lap = 1,
        Finished = false,
    }
    AvailableRaces[AvailableKey].RaceData = Races[RaceId]
    TriggerClientEvent('ls-lapraces:client:JoinRace', src, Races[RaceId], RaceData.Laps)
    TriggerClientEvent('ls-phone_new:client:UpdateLapraces', -1)
    local creatorsource = LSCore.Functions.GetPlayerByCitizenId(AvailableRaces[AvailableKey].SetupCitizenId).PlayerData.source
    if creatorsource ~= Player.PlayerData.source then
        TriggerClientEvent('ls-phone_new:client:RaceNotify', creatorsource, string.sub(Player.PlayerData.charinfo.firstname, 1, 1)..'. '..Player.PlayerData.charinfo.lastname..' is de race gejoined!')
    end
end)

RegisterServerEvent('ls-lapraces:server:LeaveRace')
AddEventHandler('ls-lapraces:server:LeaveRace', function(RaceData)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    local RaceName
    if RaceData.RaceData ~= nil then
        RaceName = RaceData.RaceData.RaceName
    else
        RaceName = RaceData.RaceName
    end
    local RaceId = GetRaceId(RaceName)
    local AvailableKey = GetOpenedRaceKey(RaceData.RaceId)
    local creatorsource = LSCore.Functions.GetPlayerByCitizenId(AvailableRaces[AvailableKey].SetupCitizenId).PlayerData.source
    if creatorsource ~= Player.PlayerData.source then
        TriggerClientEvent('ls-phone_new:client:RaceNotify', creatorsource, string.sub(Player.PlayerData.charinfo.firstname, 1, 1)..'. '..Player.PlayerData.charinfo.lastname..' is de race geleaved!')
    end
    local AmountOfRacers = 0
    for k, v in pairs(Races[RaceData.RaceId].Racers) do
        AmountOfRacers = AmountOfRacers + 1
    end
    if NotFinished[RaceData.RaceId] ~= nil then
        table.insert(NotFinished[RaceData.RaceId], {
            TotalTime = "DNF",
            BestLap = "DNF",
            Holder = {
                [1] = Player.PlayerData.charinfo.firstname,
                [2] = Player.PlayerData.charinfo.lastname
            }
        })
    else
        NotFinished[RaceData.RaceId] = {}
        table.insert(NotFinished[RaceData.RaceId], {
            TotalTime = "DNF",
            BestLap = "DNF",
            Holder = {
                [1] = Player.PlayerData.charinfo.firstname,
                [2] = Player.PlayerData.charinfo.lastname
            }
        })
    end
    Races[RaceId].Racers[Player.PlayerData.citizenid] = nil
    if (AmountOfRacers - 1) == 0 then
        if NotFinished ~= nil and next(NotFinished) ~= nil and NotFinished[RaceId] ~= nil and next(NotFinished[RaceId]) ~= nil then
            for k, v in pairs(NotFinished[RaceId]) do
                if LastRaces[RaceId] ~= nil then
                    table.insert(LastRaces[RaceId], {
                        TotalTime = v.TotalTime,
                        BestLap = v.BestLap,
                        Holder = {
                            [1] = v.Holder[1],
                            [2] = v.Holder[2]
                        }
                    })
                else
                    LastRaces[RaceId] = {}
                    table.insert(LastRaces[RaceId], {
                        TotalTime = v.TotalTime,
                        BestLap = v.BestLap,
                        Holder = {
                            [1] = v.Holder[1],
                            [2] = v.Holder[2]
                        }
                    })
                end
            end
        end
        Races[RaceId].LastLeaderboard = LastRaces[RaceId]
        Races[RaceId].Racers = {}
        Races[RaceId].Started = false
        Races[RaceId].Waiting = false
        table.remove(AvailableRaces, AvailableKey)
        TriggerClientEvent('LSCore:Notify', src, 'Je was de enige in de race.. De race is beëindigd.', 'error')
        TriggerClientEvent('ls-lapraces:client:LeaveRace', src, Races[RaceId])
        LastRaces[RaceId] = nil
        NotFinished[RaceId] = nil
    else
        AvailableRaces[AvailableKey].RaceData = Races[RaceId]
        TriggerClientEvent('ls-lapraces:client:LeaveRace', src, Races[RaceId])
    end
    TriggerClientEvent('ls-phone_new:client:UpdateLapraces', -1)
end)

RegisterServerEvent('ls-lapraces:server:SetupRace')
AddEventHandler('ls-lapraces:server:SetupRace', function(RaceId, Laps)
    local Player = LSCore.Functions.GetPlayer(source)
    if Races[RaceId] ~= nil then
        if not Races[RaceId].Waiting then
            if not Races[RaceId].Started then
                Races[RaceId].Waiting = true
                table.insert(AvailableRaces, {
                    RaceData = Races[RaceId],
                    Laps = Laps,
                    RaceId = RaceId,
                    SetupCitizenId = Player.PlayerData.citizenid,
                })
                TriggerClientEvent('ls-phone_new:client:UpdateLapraces', -1)
                SetTimeout(5 * 60 * 1000, function()
                    if Races[RaceId].Waiting then
                        local AvailableKey = GetOpenedRaceKey(RaceId)
                        for cid,_ in pairs(Races[RaceId].Racers) do
                            local RacerData = LSCore.Functions.GetPlayerByCitizenId(cid)
                            if RacerData ~= nil then
                                TriggerClientEvent('ls-lapraces:client:LeaveRace', RacerData.PlayerData.source, Races[RaceId])
                            end
                        end
                        table.remove(AvailableRaces, AvailableKey)
                        Races[RaceId].LastLeaderboard = {}
                        Races[RaceId].Racers = {}
                        Races[RaceId].Started = false
                        Races[RaceId].Waiting = false
                        LastRaces[RaceId] = nil
                        TriggerClientEvent('ls-phone_new:client:UpdateLapraces', -1)
                    end
                end)
            else
                TriggerClientEvent('LSCore:Notify', source, 'De race is al actief...', 'error')
            end
        else
            TriggerClientEvent('LSCore:Notify', source, 'De race is al actief..', 'error')
        end
    else
        TriggerClientEvent('LSCore:Notify', source, 'Deze race bestaat niet :(', 'error')
    end
end)

RegisterServerEvent('ls-lapraces:server:UpdateRaceState')
AddEventHandler('ls-lapraces:server:UpdateRaceState', function(RaceId, Started, Waiting)
    Races[RaceId].Waiting = Waiting
    Races[RaceId].Started = Started
end)

RegisterServerEvent('ls-lapraces:server:UpdateRacerData')
AddEventHandler('ls-lapraces:server:UpdateRacerData', function(RaceId, Checkpoint, Lap, Finished)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    local CitizenId = Player.PlayerData.citizenid

    Races[RaceId].Racers[CitizenId].Checkpoint = Checkpoint
    Races[RaceId].Racers[CitizenId].Lap = Lap
    Races[RaceId].Racers[CitizenId].Finished = Finished

    TriggerClientEvent('ls-lapraces:client:UpdateRaceRacerData', -1, RaceId, Races[RaceId])
end)

RegisterServerEvent('ls-lapraces:server:StartRace')
AddEventHandler('ls-lapraces:server:StartRace', function(RaceId)
    local src = source
    local MyPlayer = LSCore.Functions.GetPlayer(src)
    local AvailableKey = GetOpenedRaceKey(RaceId)
    
    if RaceId ~= nil then
        if AvailableRaces[AvailableKey].SetupCitizenId == MyPlayer.PlayerData.citizenid then
            AvailableRaces[AvailableKey].RaceData.Started = true
            AvailableRaces[AvailableKey].RaceData.Waiting = false
            for CitizenId,_ in pairs(Races[RaceId].Racers) do
                local Player = LSCore.Functions.GetPlayerByCitizenId(CitizenId)
                if Player ~= nil then
                    TriggerClientEvent('ls-lapraces:client:RaceCountdown', Player.PlayerData.source)
                end
            end
            TriggerClientEvent('ls-phone_new:client:UpdateLapraces', -1)
        else
            TriggerClientEvent('LSCore:Notify', src, 'Je bent niet de maker van de race..', 'error')
        end
    else
        TriggerClientEvent('LSCore:Notify', src, 'Je zit niet in een race..', 'error')
    end
end)

RegisterServerEvent('ls-lapraces:server:SaveRace')
AddEventHandler('ls-lapraces:server:SaveRace', function(RaceData)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)
    local RaceId = GenerateRaceId()
    local Checkpoints = {}
    for k, v in pairs(RaceData.Checkpoints) do
        Checkpoints[k] = {
            offset = v.offset,
            coords = v.coords,
        }
    end
    Races[RaceId] = {
        RaceName = RaceData.RaceName,
        Checkpoints = Checkpoints,
        Records = {},
        Creator = Player.PlayerData.citizenid,
        RaceId = RaceId,
        Started = false,
        Waiting = false,
        Distance = math.ceil(RaceData.RaceDistance),
        Racers = {},
        LastLeaderboard = {},
    }
    LSCore.Functions.ExecuteSql(false, "INSERT INTO `server_lapraces` (`name`, `checkpoints`, `creator`, `distance`, `raceid`) VALUES ('"..RaceData.RaceName.."', '"..json.encode(Checkpoints).."', '"..Player.PlayerData.citizenid.."', '"..RaceData.RaceDistance.."', '"..GenerateRaceId().."')")
end)

function GetRaceId(name)
    local retval = nil
    for k, v in pairs(Races) do
        if v.RaceName == name then
            retval = k
            break
        end
    end
    return retval
end

function GenerateRaceId()
    local RaceId = "LR-"..math.random(1111, 9999)
    while Races[RaceId] ~= nil do
        RaceId = "LR-"..math.random(1111, 9999)
    end
    return RaceId
end

LSCore.Commands.Add("togglesetup", "Zet Racing setup aan/uit", {}, false, function(source, args)
    local Player = LSCore.Functions.GetPlayer(source)

    if IsWhitelisted(Player.PlayerData.citizenid) then
        Config.RaceSetupAllowed = not Config.RaceSetupAllowed
        if not Config.RaceSetupAllowed then
            TriggerClientEvent('LSCore:Notify', source, 'Er kunnen geen race\'s meer aangemaakt worden!', 'error')
        else
            TriggerClientEvent('LSCore:Notify', source, 'Er kunnen weer race\'s aangemaakt worden!', 'success')
        end
    else
        TriggerClientEvent('LSCore:Notify', source, 'Je hebt niet geautoriseerd om dit te doen.', 'error')
    end
end)

LSCore.Commands.Add("cancelrace", "Cancel gaande race..", {}, false, function(source, args)
    local Player = LSCore.Functions.GetPlayer(source)

    if IsWhitelisted(Player.PlayerData.citizenid) then
        local RaceName = table.concat(args, " ")
        if RaceName ~= nil then
            local RaceId = GetRaceId(RaceName)
            if Races[RaceId].Started then
                local AvailableKey = GetOpenedRaceKey(RaceId)
                for cid,_ in pairs(Races[RaceId].Racers) do
                    local RacerData = LSCore.Functions.GetPlayerByCitizenId(cid)
                    if RacerData ~= nil then
                        TriggerClientEvent('ls-lapraces:client:LeaveRace', RacerData.PlayerData.source, Races[RaceId])
                    end
                end
                table.remove(AvailableRaces, AvailableKey)
                Races[RaceId].LastLeaderboard = {}
                Races[RaceId].Racers = {}
                Races[RaceId].Started = false
                Races[RaceId].Waiting = false
                LastRaces[RaceId] = nil
                TriggerClientEvent('ls-phone_new:client:UpdateLapraces', -1)
            else
                TriggerClientEvent('LSCore:Notify', source, 'Deze race is nog niet van start gegaanw.', 'error')
            end
        end
    else
        TriggerClientEvent('LSCore:Notify', source, 'Je hebt niet geautoriseerd om dit te doen.', 'error')
    end
end)

LSCore.Functions.CreateCallback('ls-lapraces:server:CanRaceSetup', function(source, cb)
    cb(Config.RaceSetupAllowed)
end)