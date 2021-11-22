local MyHand, DealerHand, CurrentTable, CurrentChair, ChairScene = {}, 0, nil, nil, nil
local TimerOn, ShowingInteraction = false, false
local CurrentBet, SittingAtTable, GameInProgress = 0, false, false

-- Code

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            local NearAnything = false
            local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
            for k, v in pairs(Config.Dealers) do
                local Distance = #(PlayerCoords - v['TableCoords'])
                if Distance < 2.0 and not SittingAtTable then
                    local ClosestChair = GetClosestChair(k)
                    if ClosestChair ~= false then
                        NearAnything, CurrentTable, CurrentChair = true, k, ClosestChair
                        if not ShowingInteraction then
                            ShowingInteraction = true
                            exports['ls-ui']:ShowInteraction('[E] Spelen ($'..v['TableBet']..')')
                        end
                        if IsControlJustReleased(0, 38) then
                            TryEnterTable(k, ClosestChair)
                        end
                    end
                elseif SittingAtTable and CurrentTable ~= nil and CurrentChair ~= nil then
                    NearAnything = true
                    ShowingInteraction = false
                    exports['ls-ui']:HideInteraction()
                    if MyHand ~= nil then
                        print(MyHand[1]['Value'], MyHand[1]['Type'])
                    end
                    if IsControlJustReleased(0, 73) then
                        exports['ls-ui']:RemoveInfo()
                        NetworkStopSynchronisedScene(ChairScene)
                        PlayAmbientSpeech1(NetToPed(Config.Dealers[CurrentTable]['PedId']), "MINIGAME_DEALER_LEAVE_NEUTRAL_GAME", "SPEECH_PARAMS_FORCE_NORMAL_CLEAR", 1)
                        TaskPlayAnim(GetPlayerPed(-1), 'anim_casino_b@amb@casino@games@shared@player@', "sit_exit_left", 1.0, 1.0, 2500, 0)
                        Citizen.Wait(2500)
                        ClearPedTasksImmediately(PlayerPedId())
                        TriggerEvent('ls-ui:client:set:timer', 0)
                        TriggerServerEvent('ls-casino:server:set:seat', CurrentTable, CurrentChair, false)
                        ChairScene, SittingAtTable = nil, false
                    end
                end
            end
            if not NearAnything then
                if ShowingInteraction then
                    ShowingInteraction = false
                    exports['ls-ui']:HideInteraction()
                end
                CurrentTable, CurrentChair = nil, nil
                Citizen.Wait(450)
            end
        end
    end
end)

-- // Events \\ --

RegisterNetEvent('ls-casino:client:sync:dealers')
AddEventHandler('ls-casino:client:sync:dealers', function(ConfigData)
    Config.Dealers = ConfigData
end)

RegisterNetEvent('ls-casino:client:cancel:bet')
AddEventHandler('ls-casino:client:cancel:bet', function(ConfigData)
    exports['ls-ui']:RemoveInfo()
    NetworkStopSynchronisedScene(ChairScene)
    PlayAmbientSpeech1(NetToPed(Config.Dealers[CurrentTable]['PedId']), "MINIGAME_DEALER_LEAVE_NEUTRAL_GAME", "SPEECH_PARAMS_FORCE_NORMAL_CLEAR", 1)
    TaskPlayAnim(GetPlayerPed(-1), 'anim_casino_b@amb@casino@games@shared@player@', "sit_exit_left", 1.0, 1.0, 2500, 0)
    Citizen.Wait(2500)
    ClearPedTasksImmediately(PlayerPedId())
    TriggerEvent('ls-ui:client:set:timer', 0)
    TriggerServerEvent('ls-casino:server:set:seat', CurrentTable, CurrentChair, false)
    ChairScene, SittingAtTable = nil, false
end)

RegisterNetEvent('ls-casino:client:give:random:card')
AddEventHandler('ls-casino:client:give:random:card', function(Table, CardData)
    table.insert(MyHand, CardData)
end)

RegisterNetEvent('ls-casino:client:menu:bet')
AddEventHandler('ls-casino:client:menu:bet', function(Bet, Table)
    local MenuItems = {
        [1] = {
            ['Title'] = 'Inzetten ($'..Bet..')',
            ['Desc'] = 'Klik om intezetten',
            ['Data'] = {['Event'] = 'ls-casino:server:try:bet', ['Type'] = 'Server', ['TableId'] = Table, ['Bet'] = Bet},
        }
    }
    local Data = {['Title'] = 'Inzetten', ['MainMenuItems'] = MenuItems, ['Cancel'] = {['Event'] = 'ls-casino:client:cancel:bet', ['Type'] = 'Client'}}
    LSCore.Functions.OpenMenu(Data)
end)

-- // Function \\ --

function TryEnterTable(TableId, ChairId)
    LoadAnimations()
    local Chair = Config.Dealers[TableId]['Chairs'][ChairId]
    ChairScene = NetworkCreateSynchronisedScene(Chair['Coords']['Sit'].x, Chair['Coords']['Sit'].y, Chair['Coords']['Sit'].z - 1.0, false, false, Chair['Coords']['Heading'], 2, 1, 0, 1065353216, 0, 1065353216)
    PlayAmbientSpeech1(NetToPed(Config.Dealers[CurrentTable]['PedId']), "MINIGAME_DEALER_GREET","SPEECH_PARAMS_FORCE_NORMAL_CLEAR", 1)
    NetworkAddPedToSynchronisedScene(PlayerPedId(), ChairScene, "anim_casino_b@amb@casino@games@shared@player@", Chair['Animation'], 2.0, -2.0, 13, 16, 2.0, 0)
    NetworkStartSynchronisedScene(ChairScene)
    StartAudioScene("DLC_VW_Casino_Table_Games")
    Citizen.InvokeNative(0x79C0E43EB9B944E2, -2124244681)
    TriggerServerEvent('ls-casino:server:set:seat', TableId, ChairId, true)
    local Data = {['Title'] = 'Blackjack ($'..Config.Dealers[TableId]['TableBet']..')', ['Items'] = {[1] = {['Text'] = 'Balans: $'..LSCore.Functions.GetPlayerData().money['cash']}, [2] = {['Text'] = 'Wachten op dealer..'}}}
    exports['ls-ui']:ShowInfo(Data)
    SittingAtTable = true
end

function GetClosestChair(TableId)
    for k, v in pairs(Config.Dealers[TableId]['Chairs']) do
        local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
        local Distance = #(PlayerCoords - v['Coords']['Sit'])
        if not Config.Dealers[TableId]['Chairs'][k]['Busy'] and Distance < 0.75 then
            return k
        end
    end
    return false
end

function GetRandomCard()
    local RandomCard = Config.Cards[math.random(1, #Config.Cards)]
    return RandomCard
end

function LoadAnimations()
    exports['ls-assets']:RequestAnimationDict('anim_casino_b@amb@casino@games@blackjack@dealer')
    exports['ls-assets']:RequestAnimationDict('anim_casino_b@amb@casino@games@shared@dealer@')
    exports['ls-assets']:RequestAnimationDict('anim_casino_b@amb@casino@games@blackjack@player')
    exports['ls-assets']:RequestAnimationDict('anim_casino_b@amb@casino@games@shared@player@')
end

-- TaskPlayAnim(NetToPed(Config.Dealers[CurrentTable]['PedId']), "anim_casino_b@amb@casino@games@blackjack@dealer", "deal_card_player_04", 3.0, 1.0, -1, 2, 0, 0, 0, 0 ) -- 1 t/m 4
-- PlayFacialAnim(NetToPed(Config.Dealers[CurrentTable]['PedId']),"deal_card_player_01_facial") 1 tm 4
-- local Data = {['Title'] = 'Blackjack (Price)', ['Items'] = {[1] = {['Text'] = 'Kenker'}}}
-- exports['ls-ui']:ShowInfo(Data)
-- ShowInfo
-- EditInfo
-- RemoveInfo