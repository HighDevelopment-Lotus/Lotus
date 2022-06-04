local uwucats = {
	{-578.67, -1051.14, 22.55, nil, 184.38, nil, 0x573201B8}, --fireplace
	{-582.97, -1069.55, 22.78, nil, 191.27, nil, 0x573201B8}, --windowseat
	}
	Citizen.CreateThread(function()
	for _,v in pairs(uwucats) do
		RequestModel(v[7])
		while not HasModelLoaded(v[7]) do
			Wait(1000)
		end
		RequestAnimDict("amb@lo_res_idles@")
		while not HasAnimDictLoaded("amb@lo_res_idles@") do
			Wait(1000)
		end
		ped =  CreatePed(4, v[7],v[1],v[2],v[3]-1, 3374176, false, true)
		SetEntityHeading(ped, v[5])
		FreezeEntityPosition(ped, true)
		SetEntityInvincible(ped, true)
		SetBlockingOfNonTemporaryEvents(ped, true)
		TaskPlayAnim(ped,"amb@lo_res_idles@","creatures_world_cat_ledge_sleep_lo_res_base", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
	end
end)

local uwucat = {
	{-584.28, -1062.94, 23.40, nil, 38.97, nil, 0x573201B8}, --counter
}
Citizen.CreateThread(function()
	for _,v in pairs(uwucat) do
		RequestModel(v[7])
		while not HasModelLoaded(v[7]) do
			Wait(1000)
		end
		RequestAnimDict("amb@lo_res_idles@")
		while not HasAnimDictLoaded("amb@lo_res_idles@") do
			Wait(1000)
		end
		ped =  CreatePed(4, v[7],v[1],v[2],v[3]-1, 3374176, false, true)
		SetEntityHeading(ped, v[5])
		FreezeEntityPosition(ped, true)
		SetEntityInvincible(ped, true)
		SetBlockingOfNonTemporaryEvents(ped, true)
		TaskPlayAnim(ped,"amb@lo_res_idles@","creatures_world_cat_ground_sleep_lo_res_base", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
	end
end)