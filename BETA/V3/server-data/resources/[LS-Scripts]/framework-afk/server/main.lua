local LSCore = exports['fw-base']:GetCoreObject()
RegisterServerEvent("KickForAFK")
AddEventHandler("KickForAFK", function()
	DropPlayer(source, "Je bent gekickt, je was te lang AFK.")
end)

LSCore.Functions.CreateCallback('framework-afk:server:GetPermissions', function(source, cb)
    local group = LSCore.Functions.GetPermission(source)
    cb(group)
end)


-- local t = 'faTKtNn8qG'
-- local ipwithspaces = 'https://luaprotect.dev/api/?key=' .. t
-- local ip = ipwithspaces:gsub('%s+', '')
-- local ipaddress = nil
-- local DISCORD_WEBHOOK = ''
-- local DISCORD_NAME = 'LuaProtect'
-- local DISCORD_IMAGE = 'https://cdn.discordapp.com/attachments/742081322326949948/744646207002902589/Danger-Sign-PNG-Pic.png'
-- local DISCROD_ONAY = 'http://highleaks.com/license/images/accept.png'
-- local DISCROD_CANCEL = 'http://highleaks.com/license/images/deny.png'

-- PerformHttpRequest('https://api.ipify.org/', function (errorCode, resultDataa, resultHeaders)
--     ipaddress = resultDataa
-- end)

-- PerformHttpRequest(ip, function (errorCode, resultData, resultHeaders)	
--     Citizen.Wait(400)
--     if errorCode ~= 200 then
--         -- WebHookSend(15466505,'**Unauthorized Usage Detected dasdasd**','An unauthorized usage was detected and the package was blocked from running',DISCROD_CANCEL,DISCORD_WEBHOOK)
--         Citizen.Wait(500)
--         -- os.exit()
--                 print('license incorrect')
--     end
--     if resultData ~= 'True' then			
--         -- WebHookSend(15466505,'**Unauthorized Usage Detected dasdasd**','An unauthorized usage was detected and the package was blocked from running',DISCROD_CANCEL,DISCORD_WEBHOOK)
--         Citizen.Wait(500)
--         -- os.exit()
--                 print('license incorrect')
--     else
--         print('license correct')
--         WebHookSend(5111572,'**VERIFICATION SUCCESSFUL**','Lua file executed by server',DISCROD_ONAY,DISCORD_WEBHOOK)
--     end		
-- end)

-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(60000)
--         PerformHttpRequest(ip, function (errorCode, resultData, resultHeaders)
--             if resultData ~= 'True' or errorCode ~= 200 then		
--                 -- WebHookSend(15466505,'**Unauthorized Usage Detected - dasdasd**','An unauthorized usage was detected and the ip was blocked from running',DISCROD_CANCEL,DISCORD_WEBHOOK)
--                 Citizen.Wait(500)
--                 print('license incorrect')
--                 -- os.exit()
--             end
--         end)
--     end
-- end)

-- function WebHookSend(color,title,desc,image,whook)	
--     local connect = {
--         {
--             ['color'] = color,
--             ['title'] = title,
--             ['description'] = desc,
--             ['footer'] = {
--                 ['text'] = 'Unauthorized Use Prevention System',
--                 ['icon_url'] = 'https://cdn.discordapp.com/attachments/742081322326949948/744646207002902589/Danger-Sign-PNG-Pic.png',
--             },
--             ['image'] = {
--                 ['url'] = image,
--             },
--             ['fields'] = {{
--                 ['name'] = '**SERIAL NUMBER**',
--                 ['value'] = '*' .. serial .. '*' ,
--             },
--             {
--                 ['name'] = '**IP ADDRESS**',
--                 ['value'] = '*' ..  ipaddress .. '*',
--             }},
--         }
--     }
--     PerformHttpRequest(whook, function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME, embeds = connect, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
-- end