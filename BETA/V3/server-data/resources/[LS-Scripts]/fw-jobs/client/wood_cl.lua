local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
  }
local mining = false
local ClosestBerth = 1
local sellX4 = 1205.84  
local sellY4 = -1271.42
local sellZ4 = 35.23
local delX = 1187.84  --del auto 
local delY = -1286.76
local delZ = 34.95
local HasVehicle = true

Citizen.CreateThread(function()
    while true do
        
        local pos = GetEntityCoords(PlayerPedId())
        local ped = PlayerPedId()
        local sleep = 250
        local closeTo = 0
        local xp 
        local yp
        local zp
        for k, v in pairs(Config.Lumberjack.WoodPosition) do
            
        -- local distone = #(pos - v.coords)
            if #(pos - vector3(v.coords.x, v.coords.y, v.coords.z)) <= 2.5 then
                closeTo = v
                xp = v.coords.x
                yp = v.coords.y
                zp = v.coords.z
                break
            end
        end
        if type(closeTo) == 'table' then
            -- while GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), closeTo.coords, true) <= 2.5 do
                
            if #(pos - closeTo.coords) <= 2.5 then
                sleep = 5
               
                DrawText3D2(xp, yp, zp+0.97, '~g~[E]~w~ Houthakken')
               
                if IsControlJustReleased(0, 38) then
                    local player, distance = LSCore.Functions.GetClosestPlayer()
                    if distance == -1 or distance >= 4.0 then
                        mining = true
                        SetEntityCoords(PlayerPedId(), closeTo.coords)
                        SetEntityHeading(PlayerPedId(), closeTo.heading)
                        FreezeEntityPosition(PlayerPedId(), true)
						--local model = loadModel(GetHashKey(Config.Objects['pickaxe']))
                        ----local axe = CreateObject(model, GetEntityCoords(PlayerPedId()), true, false, false)
                        --AttachEntityToEntity(axe, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.09, 0.03, -0.02, -78.0, 13.0, 28.0, false, true, true, true, 0, true)

                        while mining do
                            Wait(0)
                            SetCurrentPedWeapon(PlayerPedId(), GetHashKey('WEAPON_UNARMED'))
                            helpText(Strings['wood_info'])
                            DisableControlAction(0, 24, true)
                            if IsDisabledControlJustReleased(0, 24) then
                                local dict = loadDict('melee@hatchet@streamed_core')
                                TaskPlayAnim(PlayerPedId(), dict, 'plyr_rear_takedown_b', 8.0, -8.0, -1, 2, 0, false, false, false)
                                local timer = GetGameTimer() + 800
                                while GetGameTimer() <= timer do Wait(0) DisableControlAction(0, 24, true) end
                                ClearPedTasks(PlayerPedId())
                                TriggerServerEvent('wood:getItem')
                            elseif IsControlJustReleased(0, 194) then
                                break
                            end
                        end
                        mining = false
                        DeleteObject(axe)
                        FreezeEntityPosition(PlayerPedId(), false)
                    else
                    end
                end
            end
        end
        Wait(sleep)
    end
end)


local procesX = -584.66
local procesY = 5285.63
local procesZ = 70.26
------------------------------------
Citizen.CreateThread(function()
    while true do
    --Citizen.Wait(7)
	local plyCoords = GetEntityCoords(PlayerPedId(), false)
    local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, procesX, procesY, procesZ)
    if dist < 10.5 then
        Citizen.Wait(4)
      else
        Citizen.Wait(1500)
      end

	-- if dist <= 20.0 then
	-- -- DrawMarker(27, procesX, procesY, procesZ-0.96, 0, 0, 0, 0, 0, 0, 2.20, 2.20, 2.20, 255, 255, 255, 200, 0, 0, 0, 0)
	-- else
	-- Citizen.Wait(1000)
	-- end
	local hasBagd7 = false
	local s1d7 = false
	if dist <= 10.0 then
	DrawText3D2(procesX, procesY, procesZ+0.1, "[E] Snijd hout")
		if IsControlJustPressed(0, Keys['E']) then 
		LSCore.Functions.TriggerCallback('LSCore:HasItem', function(result)
					hasBagd7 = result
					s1d7 = true
			end, 'wood_cut')
			while(not s1d7) do
					Citizen.Wait(100)
				end
			if (hasBagd7) then
		SellKurczaki22()
		else
		LSCore.Functions.Notify('Je hebt geen planken.', 'error')
		end
		end	
	end
	
end
end)
function SellKurczaki22()
    -- local
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local inventory = LSCore.Functions.GetPlayerData().inventory
    local count = 0
    ----
    
    if(count == 0) then
    LSCore.Functions.Progressbar("search_register", "Hout snijden.", 5000, false, true, {disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                        disableInventory = true,
                    }, {}, {}, {}, function()end, function()
                        
                    end)
    local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.9, -0.98))
    prop = CreateObject(GetHashKey('hei_prop_heist_box'), x, y, z,  true,  true, true)
    SetEntityHeading(prop, GetEntityHeading(PlayerPedId()))
    LoadDict('amb@medic@standing@tendtodead@idle_a')
    TaskPlayAnim(PlayerPedId(), 'amb@medic@standing@tendtodead@idle_a', 'idle_a', 8.0, -8.0, -1, 1, 0.0, 0, 0, 0)
    Citizen.Wait(5000)
    LoadDict('amb@medic@standing@tendtodead@exit')
    TaskPlayAnim(PlayerPedId(), 'amb@medic@standing@tendtodead@exit', 'exit', 8.0, -8.0, -1, 1, 0.0, 0, 0, 0)
    ClearPedTasks(PlayerPedId())
    DeleteEntity(prop)
    TriggerServerEvent('wood_weed:processweed2')
        
    else
    
    
    end
end


local sellX = 1210.0
local sellY = -1318.51
local sellZ = 35.23
Citizen.CreateThread(function()
    while true do
    --Citizen.Wait(7)
	local plyCoords = GetEntityCoords(PlayerPedId(), false)
    local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, sellX, sellY, sellZ)
    if dist < 10.5 then

        Citizen.Wait(4)
      else
        
        Citizen.Wait(1500)
      end

	-- if dist <= 20.0 then
	-- -- DrawMarker(27, sellX, sellY, sellZ-0.96, 0, 0, 0, 0, 0, 0, 2.20, 2.20, 2.20, 255, 255, 255, 200, 0, 0, 0, 0)
	-- else
	-- Citizen.Wait(1000)
	-- end
	local hasBagd7 = false
	local s1d7 = false
	if dist <= 10.0 then
	DrawText3D2(sellX, sellY, sellZ+0.1, "[E] Verkoop planken")
		if IsControlJustPressed(0, Keys['E']) then 
		LSCore.Functions.TriggerCallback('LSCore:HasItem', function(result)
					hasBagd7 = result
					s1d7 = true
			end, 'wood_proc')
			while(not s1d7) do
					Citizen.Wait(100)
				end
			if (hasBagd7) then
		SellKurczaki()
		else
		LSCore.Functions.Notify('Je hebt geen planken.', 'error')
		end
		end	
	end
	
end
end)
function SellKurczaki()
    -- local
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local inventory = LSCore.Functions.GetPlayerData().inventory
    local count = 0
    ----
    if(count == 0) then
    LSCore.Functions.Progressbar("search_register", "Verkopen..", 5000, false, true, {disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                        disableInventory = true,
                    }, {}, {}, {}, function()end, function()
                        
                    end)
    local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.9, -0.98))
    prop = CreateObject(GetHashKey('hei_prop_heist_box'), x, y, z,  true,  true, true)
    SetEntityHeading(prop, GetEntityHeading(PlayerPedId()))
    LoadDict('amb@medic@standing@tendtodead@idle_a')
    TaskPlayAnim(PlayerPedId(), 'amb@medic@standing@tendtodead@idle_a', 'idle_a', 8.0, -8.0, -1, 1, 0.0, 0, 0, 0)
    Citizen.Wait(5000)
    LoadDict('amb@medic@standing@tendtodead@exit')
    TaskPlayAnim(PlayerPedId(), 'amb@medic@standing@tendtodead@exit', 'exit', 8.0, -8.0, -1, 1, 0.0, 0, 0, 0)
    ClearPedTasks(PlayerPedId())
    DeleteEntity(prop)
    TriggerServerEvent('wood:sell')
    else
    
    
    end
end

function LoadDict(dict)
    RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
	  	Citizen.Wait(10)
    end
end

---load dict and model
loadModel = function(model)
    while not HasModelLoaded(model) do Wait(0) RequestModel(model) end
    return model
end

loadDict = function(dict, anim)
    while not HasAnimDictLoaded(dict) do Wait(0) RequestAnimDict(dict) end
    return dict
end

helpText = function(msg)
    BeginTextCommandDisplayHelp('STRING')
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

addBlip = function(coords, sprite, size, colour, text)
    local blip = AddBlipForCoord(coords)
    SetBlipSprite(blip, sprite)
    SetBlipScale  (blip, size)
    SetBlipColour (blip, colour)
    --SetBlipColour(blip, colour)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(blip)
end


----TEXT 3D
function DrawText3D2(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 90)
end