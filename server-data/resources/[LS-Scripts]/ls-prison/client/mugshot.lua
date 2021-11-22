local Cop = nil
local Scaleform = nil
local Handle = nil
local MugshotBoard = nil
local MugshotOverlay = nil
local IsGoingToPhoto = false

RegisterNetEvent('ls-prison:client:set:in:jail')
AddEventHandler('ls-prison:client:set:in:jail', function(Name, Months, CitizenId, Date)
    JailIntro(Name, Months, CitizenId, Date)
end)

function JailIntro(Name, Months, CitizenId, Date)
    DoScreenFadeOut(10)
    IsGoingToPhoto = true
    FreezeEntityPosition(PlayerPedId(), true)
    TriggerEvent('ls-sound:client:play', 'handcuff', 0.4)
    TriggerEvent('ls-police:client:check:cuffed')
    RequestModel(GetHashKey("s_m_y_prismuscl_01"))
    while not HasModelLoaded(GetHashKey("s_m_y_prismuscl_01"))  do 
      Wait(1) 
    end
    Cop = CreatePed(5, GetHashKey('s_m_y_prismuscl_01'), 403.75, -1001.25, -100.00, 4.34, false)
    TaskStartScenarioInPlace(Cop, "WORLD_HUMAN_PAPARAZZI", 0, false)

    SetEntityCoords(PlayerPedId(), 402.91567993164, -996.75970458984, -100.000259399414)
    SetEntityHeading(PlayerPedId(), 180.5)
    Citizen.Wait(1500)
    DoScreenFadeIn(500)
    AddMugshot(Name, Months, CitizenId, Date)
    TriggerEvent('ls-sound:client:play', 'jail-photo', 0.4)
    Citizen.Wait(3000) 
    TriggerEvent('ls-sound:client:play', 'jail-photo', 0.4)
    Citizen.Wait(3000) 

    SetEntityHeading(PlayerPedId(), 270.75) 
    TriggerEvent('ls-sound:client:play', 'jail-photo', 0.4)
    Citizen.Wait(3000)  
    TriggerEvent('ls-sound:client:play', 'jail-photo', 0.4)
    Citizen.Wait(3000)    

    SetEntityHeading(PlayerPedId(), 87.61) 
    TriggerEvent('ls-sound:client:play', 'jail-photo', 0.4)
    Citizen.Wait(3000) 
    TriggerEvent('ls-sound:client:play', 'jail-photo', 0.4)
    Citizen.Wait(3000)       
    SetEntityHeading(PlayerPedId(), 180.5)
    Citizen.Wait(2000)
    DoScreenFadeOut(1100)   
    Citizen.Wait(2000)
    TriggerEvent('ls-sound:client:play', 'jail-door', 0.5)
    FreezeEntityPosition(PlayerPedId(), false)
    ResetMugshot()

    DoScreenFadeOut(500)
	while not IsScreenFadedOut() do
		Citizen.Wait(10)
	end
    
    local RandomStartPosition = Config.Locations['Spawns'][math.random(1, #Config.Locations['Spawns'])]
    SetEntityCoords(GetPlayerPed(-1), RandomStartPosition['Coords']['X'], RandomStartPosition['Coords']['Y'], RandomStartPosition['Coords']['Z'] - 0.9, 0, 0, 0, false)
    SetEntityHeading(GetPlayerPed(-1), RandomStartPosition['Coords']['H'])
    Citizen.Wait(500)
    TriggerEvent('animations:client:EmoteCommandStart', {RandomStartPosition['Animation']})
    Citizen.Wait(2000)
    DoScreenFadeIn(1000)
    IsGoingToPhoto = false
    TriggerServerEvent("ls-ui:server:add:news:jail", Months)
    TriggerServerEvent("ls-prison:server:set:jail:items")
    TriggerEvent('ls-prison:client:enter:prison', Months, true)
    LSCore.Functions.Notify("Je zit in de gevangenis voor "..Months.." maanden..", "error", 6500)
end

-- // MugShot Board \\ --

Citizen.CreateThread(function()
  Scaleform = LoadScaleform("mugshot_board_01")
  Handle = CreateNamedRenderTargetForModel("ID_Text", GetHashKey("prop_police_id_text"))
  while Handle do
     if IsGoingToPhoto then
      SetTextRenderId(Handle)
      Set_2dLayer(4)
      Citizen.InvokeNative(0xC6372ECD45D73BCD, 1)
      DrawScaleformMovie(Scaleform, 0.405, 0.37, 0.81, 0.74, 255, 255, 255, 255, 0)
      Citizen.InvokeNative(0xC6372ECD45D73BCD, 0)
      SetTextRenderId(GetDefaultScriptRendertargetRenderId())
      Citizen.InvokeNative(0xC6372ECD45D73BCD, 1)
      Citizen.InvokeNative(0xC6372ECD45D73BCD, 0)
      Wait(0)
     else
         Citizen.Wait(1500)
     end
  end
end)

-- // Functions \\ --

function AddMugshot(Name, Months, CitizenId, Date)
 local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
 -- Set Information --
 PushScaleformMovieFunction(Scaleform, "SET_BOARD")
 PushScaleformMovieFunctionParameterString("POLITIE LOS SANTOS")
 PushScaleformMovieFunctionParameterString(Date) -- Datum
 PushScaleformMovieFunctionParameterString("Veroordeeld voor "..Months.." Maand(en)")  -- Veroordeeld
 PushScaleformMovieFunctionParameterString(Name) -- Voornaam en Achternaam
 PushScaleformMovieFunctionParameterFloat(0.0)
 PushScaleformMovieFunctionParameterString(CitizenId) -- CitizenId
 PushScaleformMovieFunctionParameterFloat(0.0)
 PopScaleformMovieFunctionVoid()
 -- Add Prop --
 RequestModel(GetHashKey("prop_police_id_board"))
 RequestModel(GetHashKey("prop_police_id_text"))
 exports['ls-assets']:RequestAnimationDict("mp_character_creation@lineup@male_a")
 while not HasModelLoaded(GetHashKey("prop_police_id_board")) or not HasModelLoaded(GetHashKey("prop_police_id_text")) do 
   Wait(1) 
 end
 MugshotBoard = CreateObject(GetHashKey("prop_police_id_board"), PlayerCoords, false, true, false)
 MugshotOverlay = CreateObject(GetHashKey("prop_police_id_text"), PlayerCoords, false, true, false)
 AttachEntityToEntity(MugshotOverlay, MugshotBoard, -1, 4103, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
 SetModelAsNoLongerNeeded(GetHashKey("prop_police_id_board"))
 SetModelAsNoLongerNeeded(GetHashKey("prop_police_id_text"))
 SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("weapon_unarmed"), 1)
 AttachEntityToEntity(MugshotBoard, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 2, 1)
 TaskPlayAnim(GetPlayerPed(-1), "mp_character_creation@lineup@male_a", "loop_raised", 8.0, 8.0, -1, 49, 0, false, false, false)
end

function ResetMugshot()
 DeleteEntity(Cop)
 SetModelAsNoLongerNeeded(GetHashKey('s_m_y_prismuscl_01'))
 DeleteObject(MugshotOverlay)
 DeleteObject(MugshotBoard)
 ClearPedSecondaryTask(GetPlayerPed(-1))
 PushScaleformMovieFunction(Scaleform, "SET_BOARD")
 PushScaleformMovieFunctionParameterString("")
 PushScaleformMovieFunctionParameterString('')  -- Datum
 PushScaleformMovieFunctionParameterString("") -- Veroordeeld
 PushScaleformMovieFunctionParameterString('') -- Voornaam en Achternaam
 PushScaleformMovieFunctionParameterFloat(0.0)
 PushScaleformMovieFunctionParameterString('') -- CitizenId
 PushScaleformMovieFunctionParameterFloat(0.0)
 PopScaleformMovieFunctionVoid() 
end

function CreateNamedRenderTargetForModel(name, model)
  local Handle = 0
  if not IsNamedRendertargetRegistered(name) then
      RegisterNamedRendertarget(name, 0)
  end
  if not IsNamedRendertargetLinked(model) then
      LinkNamedRendertarget(model)
  end
  if IsNamedRendertargetRegistered(name) then
      Handle = GetNamedRendertargetRenderId(name)
  end
  return Handle
 end
 
 function LoadScaleform(Scaleform)
  local Handle = RequestScaleformMovie(Scaleform)
  if Handle ~= 0 then
      while not HasScaleformMovieLoaded(Handle) do
          Citizen.Wait(0)
      end
  end
  return Handle
end
   
function CallScaleformMethod(Scaleform, method, ...)
 local t
 local args = { ... }
 BeginScaleformMovieMethod(Scaleform, method)
 for k, v in ipairs(args) do
     t = type(v)
     if t == 'string' then
         PushScaleformMovieMethodParameterString(v)
     elseif t == 'number' then
         if string.match(tostring(v), "%.") then
             PushScaleformMovieFunctionParameterFloat(v)
         else
             PushScaleformMovieFunctionParameterInt(v)
         end
     elseif t == 'boolean' then
         PushScaleformMovieMethodParameterBool(v)
     end
 end
 EndScaleformMovieMethod()
end