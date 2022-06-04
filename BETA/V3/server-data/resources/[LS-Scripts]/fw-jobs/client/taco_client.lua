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
local Bezig = false

local Nearby = false

RegisterNetEvent('framework-tacos:client:SetStock')
AddEventHandler('framework-tacos:client:SetStock', function(stock, amount)
	Config.JobData[stock] = amount
end)

-- Code

Citizen.CreateThread(function()
	while true do 
		--Citizen.Wait(7)
		local Positie = GetEntityCoords(PlayerPedId(), false)
		local GebiedA = #(vector3(Positie.x, Positie.y, Positie.z) - vector3(-1161.377, -1255.431, 6.3267903))
		if GebiedA <= 10.5 then
		  Citizen.Wait(5)
		else
		  Citizen.Wait(1508)
		end
		
		 for k,v in pairs(Config.JobData['locations']) do
		  local Positie = GetEntityCoords(PlayerPedId(), false)
		  local Gebied = #(vector3(Positie.x, Positie.y, Positie.z) - vector3(Config.JobData['locations'][k].x, Config.JobData['locations'][k].y, Config.JobData['locations'][k].z))

			if Gebied <= 1.5 then
				if Config.JobData['locations'][k]['name'] == 'Stock' then
					DrawText3D(Config.JobData['locations'][k].x, Config.JobData['locations'][k].y, Config.JobData['locations'][k].z + 0.15, 'Vlees voorraad: '..Config.JobData['stock-meat']..'x Sla voorraad: '..Config.JobData['stock-lettuce']..'x')
					elseif Config.JobData['locations'][k]['name'] == 'Register' then
						if Config.JobData['register'] >= 5000 then
							DrawText3D(Config.JobData['locations'][k].x, Config.JobData['locations'][k].y, Config.JobData['locations'][k].z + 0.15, '~g~G~s~ - Pak geld \nKassa capaciteit: ~g~Genoeg geld.')
						else
							DrawText3D(Config.JobData['locations'][k].x, Config.JobData['locations'][k].y, Config.JobData['locations'][k].z + 0.15, '~g~G~s~ - Pak geld \nKassa capaciteit: ~r~Nniet genoeg.')
						end
					end
				end
			end
	end
end)

RegisterNetEvent('framework-tacos:client:create:lettuce')
AddEventHandler('framework-tacos:client:create:lettuce', function()
	GetLettuce()
end)

RegisterNetEvent('framework-tacos:client:create:meat')
AddEventHandler('framework-tacos:client:create:meat', function()
	BakeMeat()
end)

RegisterNetEvent('framework-tacos:client:create:taco')
AddEventHandler('framework-tacos:client:create:taco', function()
	LSCore.Functions.TriggerCallback('framework-taco:server:get:ingredient', function(HasItems)  
		if HasItems then
			FinishTaco()
		else
			LSCore.Functions.Notify("Je hebt nog niet alle ingrediënten.", "error")
		end
	end)
end)

RegisterNetEvent('framework-tacos:client:add:stock')
AddEventHandler('framework-tacos:client:add:stock', function()
	AddStuff()
end)

RegisterNetEvent('framework-tacos:client:register:rob')
AddEventHandler('framework-tacos:client:register:rob', function()
	if Config.JobData['register'] >= 5000 then
		local lockpickTime = math.random(10000,35000)
		RegisterAnim(lockpickTime)
        GetMoney = false  
		TriggerServerEvent('framework-taco:server:set:taco:count', 'Min', 'register', 5000)  
		Bezig = false
	else
		LSCore.Functions.Notify("Er staat nog niet genoeg geld in de kassa ..", "error")
	end
end)

RegisterNetEvent('framework-tacos:client:add:taco')
AddEventHandler('framework-tacos:client:add:taco', function()
	GiveTacoToShop()
end)

-- functions

function FinishTaco()
	Bezig = true
	TriggerEvent('framework-sound:client:play', 'micro', 0.2)  
			TriggerServerEvent('framework-tacos:server:rem:stuff', "meat")
			TriggerServerEvent('framework-tacos:server:rem:stuff', "lettuce")
			TriggerServerEvent('framework-tacos:server:add:stuff', "taco")
			Bezig = false
end

function BakeMeat()
	if Config.JobData['stock-meat'] >= 1 then
	Bezig = true
	
			TriggerServerEvent('framework-tacos:server:add:stuff', "meat")
			TriggerServerEvent('framework-taco:server:set:taco:count', 'Min', 'stock-meat', 1)
			Bezig = false
else
	LSCore.Functions.Notify("Er is niet genoeg vlees op voorraad.", "error")
 end  
end

function GetLettuce()
	if Config.JobData['stock-lettuce'] >= 1 then
	Bezig = true
			TriggerEvent('framework-sound:client:play', 'fridge', 0.5)

					StopAnimTask(PlayerPedId(), "amb@prop_human_bum_bin@idle_b", "idle_d", 1.0)
					TriggerServerEvent('framework-tacos:server:add:stuff', 'lettuce')
					TriggerServerEvent('framework-taco:server:set:taco:count', 'Min', 'stock-lettuce', 1)
					Bezig = false
else
	LSCore.Functions.Notify("Er is niet genoeg sla op voorraad.", "error")
 end 
end

function GiveTacoToShop()
	LSCore.Functions.TriggerCallback('framework-taco:server:get:tacos', function(HasItem, type)
		if HasItem then
		  if not IsPedInAnyVehicle(PlayerPedId(), false) then
			if Config.JobData['tacos'] <= 10 then	
				LSCore.Functions.Notify("Taco ingepakt voor verkoop.", "success")
				TriggerServerEvent('framework-taco:server:set:taco:count', 'Plus', 'tacos', 1)
				TriggerServerEvent('framework-tacos:server:rem:stuff', "taco")
				else
					LSCore.Functions.Notify("Er zijn nog 10 taco's die verkocht moeten worden. We verspillen hier geen eten.", "error")
				end
		  elseif type == 'green' then
			if Config.JobData['green-tacos'] <= 10 then
				TriggerServerEvent('framework-tacos:server:rem:taco')
				TriggerEvent('framework-inv:client:ItemBox', Player.PlayerData.source, LSCore.Shared.Items['green-taco'], 'remove')
				else
					LSCore.Functions.Notify("Er zijn nog 10 taco's die verkocht moeten worden. We verspillen hier geen eten.", "error")
				end
		end
	    else
		LSCore.Functions.Notify("Je hebt niet eens een taco.", "error")
	 end
	end)
end

function AddStuff()
	LSCore.Functions.TriggerCallback('LSCore:HasItem', function(HasItem)
		if HasItem then
			if Config.JobBusy == true then
		TriggerServerEvent('framework-tacos:server:rem:stuff', "taco-box")
				TriggerServerEvent('framework-taco:server:set:taco:count', 'Plus', 'stock-meat', math.random(1,7))
				TriggerServerEvent('framework-taco:server:set:taco:count', 'Plus', 'stock-lettuce', math.random(1,7))
				LSCore.Functions.Notify("Taco Shop is weer aangevuld.", "success")
				Config.JobBusy = false
			else
				LSCore.Functions.Notify("Je komt rechtstreeks uit de Taco Shop.", "error")
			end
		else
			LSCore.Functions.Notify("Je hebt niet eens een doos met ingrediënten.", "error")
		end
	end, 'taco-box')
end

function TakeMoney()
	if Config.JobData['register'] >= 5000 then
		local lockpickTime = math.random(10000,35000)
		RegisterAnim(lockpickTime)
        GetMoney = false  
		TriggerServerEvent('framework-taco:server:set:taco:count', 'Min', 'register', 5000)  
		Bezig = false
	else
		LSCore.Functions.Notify("Er staat nog niet genoeg geld in de kassa ..", "error")
	end
end

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
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
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

function RegisterAnim(time)
	time = time / 1000
	loadAnimDict("veh@break_in@0h@p_m_one@")
	TaskPlayAnim(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds" ,3.0, 3.0, -1, 16, 0, false, false, false)
	GetMoney = true
	Citizen.CreateThread(function()
	while GetMoney do
		TaskPlayAnim(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 3.0, 3.0, -1, 16, 0, 0, 0, 0)
		Citizen.Wait(2000)
		time = time - 2
		if time <= 0 then
			GetMoney = false
			StopAnimTask(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 1.0)
		end
	end
	end)
end