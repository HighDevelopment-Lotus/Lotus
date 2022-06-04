secondsUntilKick = 1000
LSCore = exports['fw-base']:GetCoreObject()

local group = "user"
local isLoggedIn = false

RegisterNetEvent('LSCore:Client:OnPlayerLoaded')
AddEventHandler('LSCore:Client:OnPlayerLoaded', function()
    LSCore.Functions.TriggerCallback('framework-afkserver:GetPermissions', function(UserGroup)
        group = UserGroup
    end)
    isLoggedIn = true
end)

RegisterNetEvent('LSCore:Client:OnPermissionUpdate')
AddEventHandler('LSCore:Client:OnPermissionUpdate', function(UserGroup)
    group = UserGroup
end)

-- Code
Citizen.CreateThread(function()
	while true do
		Wait(1000)
        playerPed = PlayerPedId()
        if isLoggedIn then
            if group ~= "god" then
                currentPos = GetEntityCoords(playerPed, true)
                if prevPos ~= nil then
                    if currentPos == prevPos then
                        if time ~= nil then
                            if time > 0 then
                                if time == (900) then
                                    LSCore.Functions.Notify('Je bent AFK en wordt over ' .. math.ceil(time / 60) .. ' minuten gekickt!', 'error', 10000)
                                elseif time == (600) then
                                    LSCore.Functions.Notify('Je bent AFK en wordt over ' .. math.ceil(time / 60) .. ' minuten gekickt!', 'error', 10000)
                                elseif time == (300) then
                                    LSCore.Functions.Notify('Je bent AFK en wordt over ' .. math.ceil(time / 60) .. ' minuten gekickt!', 'error', 10000)
                                elseif time == (150) then
                                    LSCore.Functions.Notify('Je bent AFK en wordt over ' .. math.ceil(time / 60) .. ' minuten gekickt!', 'error', 10000)   
                                elseif time == (60) then
                                    LSCore.Functions.Notify('Je bent AFK en wordt over ' .. math.ceil(time / 60) .. ' minuut gekickt!', 'error', 10000) 
                                elseif time == (30) then
                                    LSCore.Functions.Notify('Je bent AFK en wordt over ' .. time .. ' seconden gekickt!', 'error', 10000)  
                                elseif time == (20) then
                                    LSCore.Functions.Notify('Je bent AFK en wordt over ' .. time .. ' seconden gekickt!', 'error', 10000)    
                                elseif time == (10) then
                                    LSCore.Functions.Notify('Je bent AFK en wordt over ' .. time .. ' seconden gekickt!', 'error', 10000)                                                                                                            
                                end
                                time = time - 1
                            else
                                TriggerServerEvent("KickForAFK")
                            end
                        else
                            time = secondsUntilKick
                        end
                    else
                        time = secondsUntilKick
                    end
                end
                prevPos = currentPos
            end
        end
    end
end)