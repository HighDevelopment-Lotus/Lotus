local chatInputActive, chatInputActivating = false, false
local LSCore = exports['fw-base']:GetCoreObject()
local chatLoaded, chatHidden = false, true

RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1000, function()
        LoggedIn = true
    end)
end)

RegisterNetEvent('LSCore:Client:OnPlayerUnload')
AddEventHandler('LSCore:Client:OnPlayerUnload', function()
    LoggedIn = false
end)

-- Code

-- Loops

Citizen.CreateThread(function()
    SetTextChatEnabled(false)
    SetNuiFocus(false, false)
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            if not chatInputActive then
                if IsControlJustReleased(0, 245) then
                    chatInputActive = true
                    chatInputActivating = true
                    SetNuiFocus(true)
                    SendNUIMessage({
                        type = 'ON_OPEN'
                    })
                end
            end
        else
            Citizen.Wait(450)
        end
    end
end)

-- Events

RegisterNetEvent('chatMessage')
AddEventHandler('chatMessage', function(author, ctype, text)
    local args = { text }
    if author ~= "" then
        table.insert(args, 1, author)
    end
    local ctype = ctype ~= false and ctype or "normal"
    SendNUIMessage({
      type = 'ON_MESSAGE',
      message = {
        template = '<div class="chat-message '..ctype..'"><div class="chat-message-body"><strong>{0}:</strong> {1}</div></div>',
        args = {author, text}
      }
    })
end)

RegisterNetEvent('__cfx_internal:serverPrint')
AddEventHandler('__cfx_internal:serverPrint', function(msg)
    SendNUIMessage({
        type = 'ON_MESSAGE',
        message = {
          templateId = 'print',
          multiline = true,
          args = { msg }
        }
    })
end)

RegisterNetEvent('chat:addMessage')
AddEventHandler('chat:addMessage', function(message)
    SendNUIMessage({
      type = 'ON_MESSAGE',
      message = message
    })
end)

RegisterNetEvent('chat:addSuggestion')
AddEventHandler('chat:addSuggestion', function(name, help, params)
    SendNUIMessage({
      type = 'ON_SUGGESTION_ADD',
      suggestion = {
        name = name,
        help = help,
        params = params or nil
      }
    })
end)

RegisterNetEvent('chat:addSuggestions')
AddEventHandler('chat:addSuggestions', function(suggestions)
    for _, suggestion in ipairs(suggestions) do
        SendNUIMessage({
          type = 'ON_SUGGESTION_ADD',
          suggestion = suggestion
        })
    end
end)

RegisterNetEvent('chat:removeSuggestion')
AddEventHandler('chat:removeSuggestion', function(name)
    SendNUIMessage({
      type = 'ON_SUGGESTION_REMOVE',
      name = name
    })
end)

RegisterNetEvent('chat:clear')
AddEventHandler('chat:clear', function(name)
    SendNUIMessage({
      type = 'ON_CLEAR'
    })
end)

AddEventHandler('onClientResourceStart', function(resName)
  Citizen.SetTimeout(1000, function()
      refreshCommands()
  end)
end)

AddEventHandler('onClientResourceStop', function(resName)
  Citizen.SetTimeout(1000, function()
      refreshCommands()
  end)
end)

RegisterNUICallback('loaded', function(data, cb)
    TriggerServerEvent('chat:init');
    refreshCommands()
    chatLoaded = true
    cb('ok')
end)

-- Functions

RegisterNUICallback('chatResult', function(data, cb)
    chatInputActive = false
    SetNuiFocus(false, false)
    if not data.canceled then
        local id = PlayerId()
        local r, g, b = 0, 0x99, 255
        if data.message:sub(1, 1) == '/' then
            ExecuteCommand(data.message:sub(2))
        else
            TriggerServerEvent('_chat:messageEntered', GetPlayerName(id), { r, g, b }, data.message)
        end
    end
    cb('ok')
end)

function refreshCommands()
    if GetRegisteredCommands then
      local registeredCommands = GetRegisteredCommands()
      local suggestions = {}
      for _, command in ipairs(registeredCommands) do
          if IsAceAllowed(('command.%s'):format(command.name)) then
              table.insert(suggestions, {
                  name = '/' .. command.name,
                  help = ''
              })
          end
      end
      TriggerEvent('chat:addSuggestions', suggestions)
    end
end