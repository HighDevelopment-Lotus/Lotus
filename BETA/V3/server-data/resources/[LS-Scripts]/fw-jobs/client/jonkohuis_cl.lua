local InRange = false

-- Code

RegisterNetEvent('framework-jonkohuis:client:open:storage')
AddEventHandler('framework-jonkohuis:client:open:storage', function()
    if exports['fw-inv']:CanOpenInventory() then
        TriggerServerEvent('framework-inv:server:open:inventory:other', "weedshop", 'Stash', 20, 10000000)
    end
end)

RegisterNetEvent('framework-jonkohuis:client:open:tray')
AddEventHandler('framework-jonkohuis:client:open:tray', function()
    if exports['fw-inv']:CanOpenInventory() then
        TriggerServerEvent('framework-inv:server:open:inventory:other', "weedbestelling", 'Stash', 5, 100000)
    end
end)

-- // Shops \\ --
RegisterNetEvent("framework-jonkohuis:client:shop")
AddEventHandler("framework-jonkohuis:client:shop", function()
    TriggerServerEvent("framework-inv:server:OpenInventory", "shop", "weedshop", Config.Items)
end)

RegisterNUICallback('Click', function()
    PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
  end)
  
  RegisterNUICallback('ErrorClick', function()
    PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
  end)
  
  RegisterNUICallback('AddPrice', function(data)
    TriggerServerEvent('framework-jonkohuis:server:add:to:register', data.Price, data.Note)
  end)
  
  RegisterNUICallback('PayReceipt', function(data)
    TriggerServerEvent('framework-jonkohuis:server:pay:receipt', data.Price, data.Note, data.Id)
  end)
  
  RegisterNUICallback('CloseNui', function()
    SetNuiFocus(false, false)
  end)

-- // Register \\ --
RegisterNetEvent('framework-jonkohuis:client:open:payment')
AddEventHandler('framework-jonkohuis:client:open:payment', function()
    local MenuItems = {}
    for k, v in pairs(Config.ActivePayments) do
        if Config.ActivePayments[k] ~= nil then
          local NewData = {}
          NewData['Title'] = 'Bestelling: #'..k
          NewData['Desc'] = 'Prijs: $'..v['Price']..' <br>Notitie: '..v['Note']
          NewData['Data'] = {['Event'] = 'framework-jonkohuis:server:pay:receipt', ['Type'] = 'Server', ['BillId'] = k, ['Price'] = v['Price'], ['Note'] = v['Note']}
          table.insert(MenuItems, NewData)
        end
    end
    if #MenuItems > 0 then
        local Data = {['Title'] = 'Open Orders', ['MainMenuItems'] = MenuItems}
        LSCore.Functions.OpenMenu(Data)
    else
        LSCore.Functions.Notify("Er zijn geen orders", "error")
    end
end)

RegisterNetEvent('framework-jonkohuis:client:open:register')
AddEventHandler('framework-jonkohuis:client:open:register', function()
  local PrData = {['Title'] = 'Kosten?', ['Type'] = 'number', ['Logo'] = '<i class="fas fa-coins"></i>'}
  local TxData = {['Title'] = 'Bestelling?', ['Type'] = 'text', ['Logo'] = '<i class="fa-martini-glass"></i>'}
  LSCore.Functions.OpenInput(PrData, function(PriceData)
      if PriceData ~= false then
        Citizen.Wait(250)
        LSCore.Functions.OpenInput(TxData, function(NoteData)
          if NoteData ~= false then
            TriggerServerEvent('framework-jonkohuis:server:add:to:register', PriceData, NoteData)
          end
        end)
      end
  end)
end)

RegisterNetEvent('framework-jonkohuis:client:sync:register')
AddEventHandler('framework-jonkohuis:client:sync:register', function(RegisterConfig)
    Config.ActivePayments = RegisterConfig
end)

RegisterNetEvent('framework-jonkohuis:client:open:craft')
AddEventHandler('framework-jonkohuis:client:open:craft', function()
    if exports['fw-inv']:CanOpenInventory() then
        local CraftingData = {['Type'] = 'Crafting', ['InvName'] = 'Jonkohuis', ['Items'] = Config.WeedItems}
		TriggerServerEvent('framework-inv:server:open:inventory:other', CraftingData, 'Crafting')
    end
end)
 -- Thread

Citizen.CreateThread(function()
  while true do
      Citizen.Wait(4)
      if LoggedIn then
          local PlayerCoords = GetEntityCoords(PlayerPedId())
          local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, 187.46786, -243.3238, 54.070487, true)
          InRange = false
          if Distance < 4.0 then
              InRange = true
          end
          if not InRange then
              Citizen.Wait(1500)
          end
      end
  end
end)


function IsInsideWeedshop()
  return InRange
end