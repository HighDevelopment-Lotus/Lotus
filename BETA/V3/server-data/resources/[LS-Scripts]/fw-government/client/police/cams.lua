local InsideCam, SecurityCam, CameraNumber = false, nil, nil

-- // Loops \\ --
Citizen.CreateThread(function ()
	while true do
		Citizen.Wait(4)
		if InsideCam then
			local Camrotation = GetCamRot(SecurityCam, 2)
			if IsControlPressed(1, 108) then --N4
				SetCamRot(SecurityCam, Camrotation.x, 0.0, Camrotation.z + 0.7, 2)
			end
			if IsControlPressed(1, 107) then --N6
				SetCamRot(SecurityCam, Camrotation.x, 0.0, Camrotation.z - 0.7, 2)
			end
			if IsControlPressed(1, 61) then -- N8
				SetCamRot(SecurityCam, Camrotation.x + 0.7, 0.0, Camrotation.z, 2)
			end
			if IsControlPressed(1, 60) then -- N5
				SetCamRot(SecurityCam, Camrotation.x - 0.7, 0.0, Camrotation.z, 2)
			end
			if IsControlJustPressed(1, 177) then -- Backspace
				DestroyCam(SecurityCam, true)
				InsideCam, SecurityCam, CameraNumber = false, nil, nil
				exports['fw-ui']:HideInteraction()
				exports['fw-assets']:RemoveProp()
				ClearPedTasks(PlayerPedId())
				ClearTimecycleModifier()
				ClearFocus()
			end
		end
	end
end)

-- // Events \\ --
RegisterNetEvent('framework-police:client:open:number')
AddEventHandler('framework-police:client:open:number', function()
    local Data = {['Title'] = 'Camera Nummer (1-'..#Config.SecurityCams..')', ['Type'] = 'number', ['Logo'] = '<i class="fas fa-video"></i>'}
    LSCore.Functions.OpenInput(Data, function(ReturnData)
        if ReturnData ~= false then
            if Config.SecurityCams[ReturnData] ~= nil then
                TriggerEvent('framework-police:client:open:camera', tonumber(ReturnData))
            else
                TriggerEvent('framework-police:client:open:camera', tonumber(ReturnData))
            end
        end
    end)
end)

RegisterNetEvent("framework-police:client:open:camera")
AddEventHandler("framework-police:client:open:camera", function(CameraNumber)
    local Coords = Config.SecurityCams[CameraNumber]['Coords']
	CameraNumber = tonumber(CameraNumber)
	SetTimecycleModifier("heliGunCam")
	SetTimecycleModifierStrength(1.0)
	local Scaleform = RequestScaleformMovie("TRAFFIC_CAM")
	while not HasScaleformMovieLoaded(Scaleform) do
		Citizen.Wait(0)
	end
	SecurityCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
	SetCamCoord(SecurityCam, Coords.x, Coords.y, (Coords.z + 1.2))						
	SetCamRot(SecurityCam, -15.0, 0.0, Coords.w)
	SetCamFov(SecurityCam, 110.0)
	RenderScriptCams(true, false, 0, 1, 0)
	PushScaleformMovieFunction(Scaleform, "PLAY_CAM_MOVIE")
	SetFocusArea(Coords.x, Coords.y, Coords.z, 0.0, 0.0, 0.0)
	PopScaleformMovieFunctionVoid()
    InsideCam = true
	exports['fw-ui']:ShowInteraction('[ESC] Sluiten', 'error')
	exports['fw-assets']:AddProp('Tablet')
    exports['fw-assets']:RequestAnimationDict('amb@code_human_in_bus_passenger_idles@female@tablet@base')
    TaskPlayAnim(PlayerPedId(), "amb@code_human_in_bus_passenger_idles@female@tablet@base", "base", 3.0, 3.0, -1, 49, 0, 0, 0, 0)
	while InsideCam do
		SetCamCoord(SecurityCam, Coords.x, Coords.y, (Coords.z + 1.2))						
		PushScaleformMovieFunction(Scaleform, "SET_ALT_FOV_HEADING")
		PushScaleformMovieFunctionParameterFloat(1.0)
		PushScaleformMovieFunctionParameterFloat(GetCamRot(SecurityCam, 2).z)
		PopScaleformMovieFunctionVoid()
		DrawScaleformMovieFullscreen(Scaleform, 255, 255, 255, 255)
		Citizen.Wait(1)
	end
	ClearFocus()
	ClearTimecycleModifier()
	RenderScriptCams(false, false, 0, 1, 0)
	SetScaleformMovieAsNoLongerNeeded(Scaleform)
	DestroyCam(SecurityCam, false)
	SetNightvision(false)
	SetSeethrough(false)	
end)