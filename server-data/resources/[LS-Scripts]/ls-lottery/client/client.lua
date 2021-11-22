local LSCore, LoggedIn = exports['ls-core']:GetCoreObject(), false
local ShowingInteraction, CanSell = false, true

RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1250, function()
        LoggedIn = true
    end)
end)

RegisterNetEvent('LSCore:Client:OnPlayerUnload')
AddEventHandler('LSCore:Client:OnPlayerUnload', function()
    LoggedIn = false
end)

RegisterNetEvent('LSCore:Client:CloseNui')
AddEventHandler('LSCore:Client:CloseNui', function()
    SetNuiFocus(false, false)
end)

-- Code

function generateSerial(id)
  local randFour = ""
  for i=1,4 do
      randFour = randFour .. math.random(1,9)
  end
  return string.format("KRAS-%s-%s%s%s", randFour, math.random(1,9),id,math.random(1,9))
end

function getRandomEntryOfTable(table)
    return table[math.random(1, tablelength(table))]
end

function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

function tableCopy(obj)
    if type(obj) ~= 'table' then return obj end
    local res = {}
    for k, v in pairs(obj) do res[tableCopy(k)] = tableCopy(v) end
    return res
end

function generateBlocks(prize)
    local blocks = {}
    local possiblePrizes = {}
	  for i=1, #Config.Prizes, 1 do
      table.insert(possiblePrizes, math.floor(Config.TopPrize/Config.Prizes[i].divide))
    end
    if prize > 0 then
        blocks = {
          ['block1'] = prize,
          ['block2'] = prize,
          ['block3'] = prize
        }
    else
        blocks = {
          ['block1'] = getRandomEntryOfTable(possiblePrizes),
          ['block2'] = getRandomEntryOfTable(possiblePrizes),
          ['block3'] = getRandomEntryOfTable(possiblePrizes)
        }
        while blocks.block1 == blocks.block3 and blocks.block2 == blocks.block3 do
          blocks['block3'] = getRandomEntryOfTable(possiblePrizes)
        end
    end
    return blocks
end

-- // Loops \\ -- 

Citizen.CreateThread(function()
	  while true do
		Citizen.Wait(4)
        if LoggedIn then
            local NearAnything = false
            local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
            local Distance = #(PlayerCoords - Config.Location['Coords'])
            if Distance < 1.5 and CanSell then
                NearAnything = true
                if not ShowingInteraction then
                    ShowingInteraction = true
                    exports['ls-ui']:ShowInteraction('[E] Kaarten Inwisselen', 'primary')
                end
                if IsControlJustPressed(0, 38) then
                    CanSell = false
                    TriggerServerEvent('ls-lottery:server:sell:card')
                    Citizen.SetTimeout(30000, function()
                        CanSell = true
                    end)
                end
            end
            if not NearAnything then
                if ShowingInteraction then
                    ShowingInteraction = false
                    exports['ls-ui']:HideInteraction()
                end
                Citizen.Wait(450)
            end
        else
            Citizen.Wait(450)
        end
    end
end)


-- // Einde Loops \\ --

RegisterNetEvent('ls-lottery:client:open:card')
AddEventHandler('ls-lottery:client:open:card', function(id, prize)
    local blocks = generateBlocks(prize)
    SetNuiFocus(true, true)
    SendNUIMessage({
      event = 'OpenCard',
      serial = generateSerial(id),
      block1 = blocks.block1,
      block2 = blocks.block2,
      block3 = blocks.block3
    })
 end)

RegisterNUICallback('cs:cardClosed', function(data, cb)
    SetNuiFocus(false, false)
    cb("{}")
end)