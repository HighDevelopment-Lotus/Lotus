for i = 1, #Config.Dealers, 1 do
    math.randomseed(os.clock()*100000000000)
    Citizen.CreateThread(function()
        while true do
            math.random() 
            math.random()
            math.random()
            if Config.GamesData[Config.Dealers[i]['GameId']] ~= nil then
                if Config.GamesData[Config.Dealers[i]['GameId']]['GameStarted'] then
                    for player, players in pairs(Config.GamesData[Config.Dealers[i]['GameId']]['Players']) do
                        TriggerClientEvent('ls-casino:client:menu:bet', players, Config.Dealers[i]['TableBet'], i)
                    end
                    HandleGameTimer(i)
                    Citizen.Wait(100 * 190)
                    if Config.GamesData[Config.Dealers[i]['GameId']]['BetsPlaced'] > 0 then

                        for player, players in pairs(Config.GamesData[Config.Dealers[i]['GameId']]['Players']) do
                            local RandomCard = GetRandomCard()
                            if Config.GamesData[Config.Dealers[i]['GameId']]['PlayerCards'][players] == nil then
                                Config.GamesData[Config.Dealers[i]['GameId']]['PlayerCards'] = {[players] = {RandomCard}}
                            else
                                table.insert(Config.GamesData[Config.Dealers[i]['GameId']]['PlayerCards'][players], RandomCard)
                            end
                            TriggerClientEvent('ls-casino:client:give:random:card', players, i, RandomCard)

                            Citizen.Wait(150)
                        end
                        


                        
                    else
                       
                    end
                elseif not Config.GamesData[Config.Dealers[i]['GameId']]['GameStarted'] then

                end
                Wait(1000)
            else
                Wait(1000)
            end
        end
    end)
end

-- // Events \\ --

RegisterServerEvent('ls-casino:server:set:seat')
AddEventHandler('ls-casino:server:set:seat', function(TableId, ChairId, Bool)
    if Bool then
        Config.Dealers[TableId]['Chairs'][ChairId]['Busy'] = true
        Config.Dealers[TableId]['Chairs'][ChairId]['Player'] = source
        local GetGamePlayerCount = CheckForTotalPlayer(TableId)
        if GetGamePlayerCount > 0 then
            if Config.GamesData[Config.Dealers[TableId]['GameId']] == nil then
                Config.GamesData[Config.Dealers[TableId]['GameId']] = {
                    ['GameStarted'] = true,
                    ['Players'] = {source},
                    ['TableId'] = TableId,
                    ['BetsPlaced'] = 0,
                    ['PlayerCards'] = {},
                }
            elseif Config.GamesData[Config.Dealers[TableId]['GameId']] ~= nil and not Config.GamesData[Config.Dealers[TableId]['GameId']]['GameStarted'] then
                Config.GamesData[Config.Dealers[TableId]['GameId']] = {
                    ['GameStarted'] = true,
                    ['Players'] = {source},
                    ['TableId'] = TableId,
                    ['BetsPlaced'] = 0,
                    ['PlayerCards'] = {},
                }
            else
                table.insert(Config.GamesData[Config.Dealers[TableId]['GameId']]['Players'], source)
            end
        end
    else
        Config.Dealers[TableId]['Chairs'][ChairId]['Busy'] = false
        Config.Dealers[TableId]['Chairs'][ChairId]['Player'] = nil
        local GetGamePlayerCount = CheckForTotalPlayer(TableId)
        if GetGamePlayerCount <= 0 then
            Config.GamesData[Config.Dealers[TableId]['GameId']] = {
                ['GameStarted'] = false,
                ['Players'] = {},
                ['TableId'] = nil,
                ['BetsPlaced'] = 0,
                ['PlayerCards'] = {},
            }
        else
            table.remove(Config.GamesData[Config.Dealers[TableId]['GameId']]['Players'], source)
        end
    end
    TriggerClientEvent('ls-casino:client:sync:dealers', -1, Config.Dealers)
end)

RegisterServerEvent('ls-casino:server:try:bet')
AddEventHandler('ls-casino:server:try:bet', function(data)
    local Player = LSCore.Functions.GetPlayer(source)
    if Player.Functions.RemoveMoney('cash', data['Bet']) then
        Config.GamesData[Config.Dealers[data['TableId']]['GameId']]['BetsPlaced'] = Config.GamesData[Config.Dealers[data['TableId']]['GameId']]['BetsPlaced'] + 1
    end
end)

RegisterServerEvent('ls-casino:server:set:ped')
AddEventHandler('ls-casino:server:set:ped', function(TableId, Ped)
    Config.Dealers[TableId]['PedId'] = Ped
    TriggerClientEvent('ls-casino:client:sync:dealers', source, Config.Dealers)
end)

-- // Function \\ --

function HandleGameTimer(TableId)
    local DoingTimer, TimerAmount = true, 100
    Citizen.CreateThread(function()
        while DoingTimer do
            Citizen.Wait(0)
            TimerAmount = TimerAmount - 1
            for k, v in pairs(Config.GamesData[Config.Dealers[TableId]['GameId']]['Players']) do
                TriggerClientEvent('ls-ui:client:set:timer', v, TimerAmount)
            end
            if TimerAmount <= 0 then
                DoingTimer = false
                for k, v in pairs(Config.GamesData[Config.Dealers[TableId]['GameId']]['Players']) do
                    TriggerClientEvent('ls-ui:client:set:timer', v, 0)
                end
            end
            Citizen.Wait(190)
        end
    end)
end

function GetRandomCard()
    local RandomCard = Config.Cards[math.random(1, #Config.Cards)]
    return RandomCard
end

function GetCashFormated(CashString)
	local i, j, minus, int, fraction = tostring(CashString):find('([-]?)(%d+)([.]?%d*)')
	int = int:reverse():gsub("(%d%d%d)", "%1,")
	return minus ..int:reverse():gsub("^,", "")..fraction
end

function CheckForTotalPlayer(TableId)
    local Count = 0
    for k, v in pairs(Config.Dealers[TableId]['Chairs']) do
        if v['Busy'] then
            Count = Count + 1
        end
    end
    return Count
end

function table_dump(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
end