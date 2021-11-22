local WeedTime = 15
local OnWeed = false

RegisterNetEvent('ls-items:client:use:joint')
AddEventHandler('ls-items:client:use:joint', function()
    if not exports['ls-progressbar']:GetTaskBarStatus() then
	  	  if not DoingSomething then
	  	  DoingSomething = true
        TriggerEvent('ls-inventory-new:client:set:inventory:state', false)
            Citizen.SetTimeout(1000, function()
                LSCore.Functions.Progressbar("smoke-joint", "Joint opsteken..", 2500, false, true, {
                  disableMovement = false,
                  disableCarMovement = false,
                  disableMouse = false,
                  disableCombat = true,
                 }, {}, {}, {}, function() -- Done
                    WeedTime = 15
                    DoingSomething = false
                    TriggerEvent('ls-items:server:add:addiction:weed')
                    TriggerEvent('ls-inventory-new:client:set:inventory:state', true)
                    LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, 'joint', 1, false)
                    TriggerEvent('ls-items:client:joint:effect')
                    if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                        TriggerEvent('animations:client:EmoteCommandStart', {"smoke3"})
                    else
                        TriggerEvent('animations:client:EmoteCommandStart', {"smokeweed"})
                    end
                  end, function() -- Cancel
                    DoingSomething = false
                    TriggerEvent('ls-inventory-new:client:set:inventory:state', true)
                    LSCore.Functions.Notify("Geannuleerd..", "error")
                end)
            end)
        end
    end
end)

RegisterNetEvent("ls-items:client:use:coke")
AddEventHandler("ls-items:client:use:coke", function()
    if not exports['ls-progressbar']:GetTaskBarStatus() then
	  	  if not DoingSomething then
	  	      DoingSomething = true
            TriggerEvent('ls-inventory-new:client:set:inventory:state', false)
            Citizen.SetTimeout(1000, function()
                LSCore.Functions.Progressbar("snort_coke", "Sleutel Puntje..", math.random(5000, 8000), false, true, {
                    disableMovement = false,
                    disableCarMovement = false,
                    disableMouse = false,
                    disableCombat = true,
                }, {
                    animDict = "anim@amb@nightclub@peds@",
                    anim = "missfbi3_party_snort_coke_b_male3",
                    flags = 49,
                },  {
                    model = "prop_meth_bag_01",
                    bone = 57005,
                    coords = { x = 0.0, y = 0.0, z = 0.0},
                    rotation = { x = 0.0, y = 0.0, z = 0.0},
                }, {}, function() -- Done
                    DoingSomething = false
                    TriggerEvent('ls-inventory-new:client:set:inventory:state', true)
                    StopAnimTask(GetPlayerPed(-1), "anim@amb@nightclub@peds@", "missfbi3_party_snort_coke_b_male3", 1.0)
                    LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, 'coke-bag', 1, false)
                    CokeBagEffect()
                end, function() -- Cancel
                    DoingSomething = false
                    TriggerEvent('ls-inventory-new:client:set:inventory:state', true)
                    StopAnimTask(GetPlayerPed(-1), "anim@amb@nightclub@peds@", "missfbi3_party_snort_coke_b_male3", 1.0)
                    LSCore.Functions.Notify("Geannuleerd..", "error")
                end)
            end)
        end
    end
end)

RegisterNetEvent("ls-items:client:use:lsd")
AddEventHandler("ls-items:client:use:lsd", function()
    if not exports['ls-progressbar']:GetTaskBarStatus() then
	  	  if not DoingSomething then
	  	      DoingSomething = true
            TriggerEvent('ls-inventory-new:client:set:inventory:state', false)
            Citizen.SetTimeout(1000, function()
                LSCore.Functions.Progressbar("snort_coke", "Lekker Likken..", 3000, false, true, {
                    disableMovement = false,
                    disableCarMovement = false,
                    disableMouse = false,
                    disableCombat = true,
                }, {
                   animDict = "mp_suicide",
                   anim = "pill",
                   flags = 49,
                },  {}, {}, function() -- Done
                    DoingSomething = false
                    TriggerEvent('ls-inventory-new:client:set:inventory:state', true)
                    StopAnimTask(GetPlayerPed(-1), "mp_suicide", "pill", 1.0)
                    LSCore.Functions.TriggerCallback('LSCore:RemoveItem', function() end, 'lsd-strip', 1, false)
                    Effectlsd()
                end, function() -- Cancel
                    DoingSomething = false
                    TriggerEvent('ls-inventory-new:client:set:inventory:state', true)
                    StopAnimTask(GetPlayerPed(-1), "mp_suicide", "pill", 1.0)
                    LSCore.Functions.Notify("Geannuleerd..", "error")
                end)
            end)
        end
    end
end)

RegisterNetEvent('ls-items:client:joint:effect')
AddEventHandler('ls-items:client:joint:effect', function()
  OnWeed = true
  while OnWeed do
    Citizen.Wait(1)
    if WeedTime > 0 then
      WeedTime = WeedTime - 1
      TriggerServerEvent('ls-ui:server:remove:stress', math.random(2, 6))
      Citizen.Wait(1000)
    end
    if WeedTime == 0 then
       OnWeed = false
       ClearPedTasks(GetPlayerPed(-1))
    end
  end
end)

function CokeBagEffect()
  local startStamina = 20
  AlienEffect()
  SetRunSprintMultiplierForPlayer(PlayerId(), 1.2)
  while startStamina > 0 do 
      Citizen.Wait(1000)
      if GetPedArmour(GetPlayerPed(-1)) <= 100 then
         SetPedArmour(GetPlayerPed(-1), GetPedArmour(GetPlayerPed(-1)) + 2)
      end
      if GetEntityHealth(GetPlayerPed(-1)) <= 200 then
        SetEntityHealth(GetPlayerPed(-1), GetEntityHealth(GetPlayerPed(-1)) + 2)
      end
      if math.random(1, 100) < 20 then
          RestorePlayerStamina(PlayerId(), 1.0)
      end
      startStamina = startStamina - 1
      if math.random(1, 100) < 10 and IsPedRunning(GetPlayerPed(-1)) then
          SetPedToRagdoll(GetPlayerPed(-1), math.random(1000, 3000), math.random(1000, 3000), 3, 0, 0, 0)
      end
      if math.random(1, 300) < 10 then
          AlienEffect()
          Citizen.Wait(math.random(3000, 6000))
      end
  end
  if IsPedRunning(GetPlayerPed(-1)) then
    SetPedToRagdoll(GetPlayerPed(-1), math.random(1000, 3000), math.random(1000, 3000), 3, 0, 0, 0)
  end
  startStamina = 0
  SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
end

function AlienEffect()
  StartScreenEffect("DrugsMichaelAliensFightIn", 3.0, 0)
  Citizen.Wait(math.random(5000, 8000))
  StartScreenEffect("DrugsMichaelAliensFight", 3.0, 0)
  Citizen.Wait(math.random(5000, 8000))    
  StartScreenEffect("DrugsMichaelAliensFightOut", 3.0, 0)
  StopScreenEffect("DrugsMichaelAliensFightIn")
  StopScreenEffect("DrugsMichaelAliensFight")
  StopScreenEffect("DrugsMichaelAliensFightOut")
end

function Effectlsd()
  Wait(math.random(2000,5000))
  AnimpostfxPlay("DrugsDrivingIn", 10000, 0)
  Wait(10000)
  AnimpostfxStop("DrugsDrivingIn")
  DoLsd(60000);
end

local Mario = {
  cols = {
    [16] =  {r=55,  g=55,   b=55},
    [18] =  {r=55,  g=55,   b=135},
    [24] =  {r=55,  g=95,   b=135},
    [52] =  {r=95,  g=55,   b=55},
    [67] =  {r=95,  g=135,  b=175},
    [88] =  {r=135, g=55,   b=55},
    [95] =  {r=135, g=95,   b=95},
    [124] = {r=175, g=55,   b=55},
    [133] = {r=175, g=95,   b=175},
    [173] = {r=215, g=135,  b=95},
    [203] = {r=255, g=95,   b=95},
    [210] = {r=255, g=135,  b=135},
    [216] = {r=255, g=175,  b=135},
    [222] = {r=255, g=215,  b=135},
    [231] = {r=255, g=255,  b=255},
  },
  bits = {
    {
      133,133,133,133,88,88,88,88,88,88,133,133,133,133,133,133,
      133,133,133,88,124,222,222,124,124,124,88,133,133,133,133,133,
      133,133,133,88,124,231,231,203,203,203,124,88,133,133,133,133,
      133,133,88,88,88,88,88,88,88,203,203,124,88,88,133,133,
      133,88,124,203,203,203,203,124,124,88,203,203,124,124,88,133,
      133,88,88,88,88,88,88,88,88,88,124,203,203,124,88,133,
      133,133,133,95,231,231,210,231,231,210,88,88,88,88,88,133,
      133,133,133,95,231,67,216,67,231,210,210,52,52,95,133,133,
      133,133,133,95,231,16,216,16,231,216,210,52,52,216,95,133,
      133,133,95,216,216,216,216,216,216,216,52,52,52,216,95,133,
      133,133,16,210,216,216,210,210,16,216,216,52,210,95,133,133,
      133,16,16,16,210,210,16,16,16,16,216,210,210,52,52,133,
      133,133,133,16,16,16,16,16,216,216,210,210,52,52,133,133,
      133,133,133,133,95,210,210,210,210,210,210,95,133,133,133,133,
      133,133,95,95,24,18,88,88,88,18,18,88,88,88,133,133,
      133,95,231,24,18,124,124,124,18,24,203,203,203,124,88,133,
      95,231,222,18,124,203,203,18,24,124,95,95,95,203,124,88,
      95,222,222,18,124,124,124,18,24,95,231,231,231,95,124,88,
      133,95,18,24,18,18,18,24,95,231,231,231,231,222,95,88,
      133,133,18,222,67,67,222,222,95,231,231,231,222,222,95,133,
      133,52,52,222,67,67,222,222,67,95,222,222,222,95,133,133,
      52,173,173,52,24,67,67,67,67,24,95,95,95,52,133,133,
      52,95,95,173,52,67,24,24,67,67,24,24,18,95,52,133,
      52,52,95,95,52,24,24,18,24,67,67,67,18,95,52,52,
      52,52,95,95,52,24,18,18,18,24,24,67,18,95,95,52,
      133,52,52,95,52,18,133,133,133,18,18,24,18,173,95,52,
      133,52,52,52,133,133,133,133,133,133,133,18,18,173,95,52,
      133,133,133,133,133,133,133,133,133,133,133,133,133,52,52,133
    },
    {
      133,133,133,133,88,88,88,88,88,88,133,133,133,133,133,133,
      133,133,133,88,124,222,222,124,124,124,88,133,133,133,133,133,
      133,133,133,88,124,231,231,203,203,203,124,88,133,133,133,133,
      133,133,88,88,88,88,88,88,88,203,203,124,88,88,133,133,
      133,88,124,203,203,203,203,124,124,88,203,203,124,124,88,133,
      133,88,88,88,88,88,88,88,88,88,124,203,203,124,88,133,
      133,133,133,95,231,231,210,231,231,210,88,88,88,88,88,133,
      133,133,133,95,231,67,216,67,231,210,210,52,52,95,133,133,
      133,133,133,95,231,16,216,16,231,216,210,52,52,216,95,133,
      133,133,95,216,216,216,216,216,216,216,52,52,52,216,95,133,
      133,133,16,210,216,216,210,210,16,216,216,52,210,95,133,133,
      133,16,16,16,210,210,16,16,16,16,216,210,210,52,52,133,
      133,133,133,16,16,16,16,16,216,216,210,210,52,52,133,133,
      133,133,133,133,95,210,210,210,210,210,210,95,133,133,133,133,
      133,133,133,133,18,88,88,88,18,18,88,88,88,133,133,133,
      133,133,95,18,124,124,124,18,95,95,95,203,203,88,133,133,
      133,95,231,18,124,203,203,95,231,231,231,95,203,203,88,133,
      133,95,222,18,124,124,95,231,231,231,231,222,95,124,88,133,
      133,95,18,24,18,18,95,231,231,231,222,222,95,124,88,133,
      133,133,18,222,67,67,222,95,222,222,222,95,88,88,133,133,
      133,133,18,222,67,67,222,222,95,95,95,24,24,18,133,133,
      133,18,24,24,67,67,24,24,67,67,24,24,18,133,133,133,
      133,52,52,24,24,24,24,18,24,67,67,24,18,52,133,133,
      52,173,173,52,24,24,24,18,24,24,24,24,52,95,52,133,
      52,95,95,173,52,24,18,133,18,24,24,24,52,95,52,133,
      133,52,95,95,95,52,133,133,133,52,52,52,173,95,52,133,
      133,133,52,95,95,52,133,133,52,173,173,95,95,52,133,133,
      133,133,133,52,52,52,133,133,52,52,52,52,52,133,133,133
    },
    {
      133,133,133,133,88,88,88,88,88,88,133,133,133,133,133,133,
      133,133,133,88,124,222,222,124,124,124,88,133,133,133,133,133,
      133,133,133,88,124,231,231,203,203,203,124,88,133,133,133,133,
      133,133,88,88,88,88,88,88,88,124,203,124,88,88,133,133,
      133,88,124,203,203,203,203,124,124,88,203,203,124,124,88,133,
      133,88,88,88,88,88,88,88,88,88,124,203,203,124,88,133,
      133,133,133,95,231,231,210,231,231,210,88,88,88,88,88,133,
      133,133,133,95,231,67,216,67,231,210,210,52,52,95,133,133,
      133,133,133,95,231,16,216,16,231,216,210,52,52,210,95,133,
      133,133,95,216,216,216,216,216,216,216,52,52,52,210,95,133,
      133,133,16,210,216,216,210,210,16,216,216,52,210,95,133,133,
      133,16,16,16,210,210,16,16,16,16,216,210,210,52,52,133,
      133,133,133,16,16,16,16,16,216,216,210,210,52,52,133,133,
      133,133,133,133,95,210,210,210,210,210,210,95,133,133,133,133,
      133,133,133,133,18,88,95,95,95,88,88,88,88,133,133,133,
      133,133,133,18,88,95,231,231,231,95,203,203,124,88,133,133,
      133,133,133,18,95,231,231,231,231,222,95,203,203,88,133,133,
      133,133,18,88,95,231,231,231,222,222,95,203,124,88,133,133,
      133,133,18,18,18,95,222,222,222,95,124,124,124,88,133,133,
      133,133,18,222,67,222,95,95,95,88,88,88,88,18,133,133,
      133,133,18,222,67,222,222,67,24,24,24,24,24,18,133,133,
      133,133,133,18,67,67,67,67,67,24,24,24,18,133,133,133,
      133,133,133,18,24,18,67,67,67,24,24,24,18,133,133,133,
      133,133,133,133,18,24,18,67,24,24,24,18,133,133,133,133,
      133,133,133,133,18,18,18,18,18,18,18,18,133,133,133,133,
      133,133,133,133,52,95,52,173,173,95,95,52,133,133,133,133,
      133,133,133,52,95,52,173,173,95,95,95,52,133,133,133,133,
      133,133,133,52,52,52,52,52,52,52,52,52,133,133,133,133 
    }, 
  }, 
} 
 
local Cubes = {} 
local LastPedInteraction = 0 
local LastPedTurn 
local MarioInit 
local PedSpawned 
 
local MarioState = 1 
local MarioTimer = 0 
local MarioLength = 15 
local MarioAlpha = 0 
local MarioAdder = 1 
local MarioZOff = -20.0 
local MarioZAdd = 0.01

DoLsd = function(time)
   Citizen.CreateThread(function()
    AnimpostfxPlay("DMT_flight", time, 1)
   end)

  InitCubes()

  local step = 0
  local timer = GetGameTimer() 
  local ped = GetPlayerPed(-1)
  local lastPos = GetEntityCoords(ped)

  while GetGameTimer() - timer < time do

    DrawToons()
    DrawCubes()
    if MarioInit and not PedSpawned then 
      PedSpawned = true
      Citizen.CreateThread(InitPed)
    end
    Wait(0)
end

  ClearTimecycleModifier()
  ShakeGameplayCam('DRUNK_SHAKE', 0.0)  
  SetPedMotionBlur(GetPlayerPed(-1), false)

  AnimpostfxStop("DMT_flight")
  AnimpostfxPlay("DrugsDrivingOut", 3000, 0)
  Wait(3000) 
  AnimpostfxStop("DrugsDrivingOut")

  Cubes = {}

  LastPedInteraction = 0
  LastPedTurn = nil
  MarioInit = nil
  PedSpawned = nil

  MarioState = 1
  MarioTimer = 0
  MarioLength = 15
  MarioAlpha = 0
  MarioAdder = 1
  MarioZOff = -20.0
  MarioZAdd = 0.01
end

InitPed = function()
  local plyPed = GetPlayerPed(-1)
  local pos = GetEntityCoords(plyPed)

  local randomAlt     = math.random(0,359)
  local randomDist    = math.random(50,80)
  local spawnPos      = pos + PointOnSphere(0.0,randomAlt,randomDist)

  while World3dToScreen2d(spawnPos.x,spawnPos.y,spawnPos.z) and not IsPointOnRoad(spawnPos.x,spawnPos.y,spawnPos.z) do 
    randomAlt   = math.random(0,359)
    randomDist  = math.random(50,80)
    spawnPos    = GetEntityCoords(GetPlayerPed(-1)) + PointOnSphere(0.0,randomAlt,randomSphere)
    Citizen.Wait(0)
  end 
end

InitCubes = function()
  for i=1,40,1 do
    local r = math.random(5,255)
    local g = math.random(5,255)
    local b = math.random(5,255)
    local a = math.random(50,100)

    local x = math.random(1,180)
    local y = math.random(1,359)
    local z = math.random(15,35)

    Cubes[i] = {pos=PointOnSphere(x,y,z),points={x=x,y=y,z=z},col={r=r, g=g, b=b, a=a}}
  end  

  ShakeGameplayCam('DRUNK_SHAKE', 0.0) 
  SetTimecycleModifierStrength(0.0) 
  SetTimecycleModifier("BikerFilter")
  SetPedMotionBlur(GetPlayerPed(-1), true)


  local counter = 4000
  local tick = 0
  while tick < counter do
    tick = tick + 1
    local plyPos = GetEntityCoords(GetPlayerPed(-1))
    local adder = 0.1 * (tick/40)
    SetTimecycleModifierStrength(math.min(0.05 * (tick/(counter/40)),1.5))
    ShakeGameplayCam('DRUNK_SHAKE', math.min(0.1 * (tick/(counter/40)),1.5))  
    for k,v in pairs(Cubes) do
      local pos = plyPos + v.pos
      DrawBox(pos.x+adder,pos.y+adder,pos.z+adder,pos.x-adder,pos.y-adder,pos.z-adder, v.col.r,v.col.g,v.col.g,v.col.a)
      local points = {x=v.points.x+0.1,y=v.points.y+0.1,z=v.points.z}
      Cubes[k].points = points
      Cubes[k].pos = PointOnSphere(points.x,points.y,points.z)
    end
    Wait(0)
  end
end

DrawCubes = function()
  local position = GetEntityCoords(GetPlayerPed(-1))
  local adder = 10
  for k,v in pairs(Cubes) do
    local addX = 0.1
    local addY = 0.1

    if k%4 == 0 then
      addY = -0.1
    elseif k%3 == 0 then
      addX = -0.1
    elseif k%2 == 0 then
      addX = -0.1
      addY = -0.1
    end

    local pos = position + v.pos
    DrawBox(pos.x+adder,pos.y+adder,pos.z+adder,pos.x-adder,pos.y-adder,pos.z-adder, v.col.r,v.col.g,v.col.g,v.col.a)
    local points = {x=v.points.x+addX,y=v.points.y+addY,z=v.points.z}
    Cubes[k].points = points
    Cubes[k].pos = PointOnSphere(points.x,points.y,points.z)
  end
end

DrawToons = function()
  local plyPed = GetPlayerPed(-1)
  local plyPos = GetEntityCoords(plyPed)

  local infront = vector3(plyPos.x+35.0, plyPos.y-8.0,plyPos.z)
  local behind  = vector3(plyPos.x-35.0, plyPos.y-8.0,plyPos.z)

  if (GetGameTimer() - MarioTimer) > 1000 then
    MarioTimer = GetGameTimer()
    MarioState = MarioState + MarioAdder

    if MarioState > #Mario.bits then
      MarioAdder = -1
      MarioState = 2
    elseif MarioState <= 0 then
      MarioState = 2
      MarioAdder = 1
    end
  end

  DrawMario(infront)
  DrawMario(behind)
end

DrawMario = function(loc)
  local height = 0
  local width = 0

  if MarioZOff < 0.0 then MarioZOff = MarioZOff + MarioZAdd; end
  for k = #Mario.bits[MarioState],1,-1 do
    local v = Mario.bits[MarioState][k]
    local pos = vector3(loc.x,loc.y+width,loc.z+height)
    local col = Mario.cols[v]    

    if MarioAlpha < 255 then
      if not MarioInit then MarioInit = true; end
      MarioAlpha = MarioAlpha + 0.001
    end

    if v ~= 133 then
      DrawBox(pos.x+0.5,pos.y+0.5,pos.z+0.5 + MarioZOff, pos.x-0.5,pos.y-0.5,pos.z-0.5 + MarioZOff, col.r,col.g,col.b,math.floor(MarioAlpha))
    end

    width = width + 1
    if width > MarioLength then
      width = 0
      height = height + 1
    end
  end
end

GetVecDist = function(v1,v2)
  if not v1 or not v2 or not v1.x or not v2.x then return 0; end
  return math.sqrt(  ( (v1.x or 0) - (v2.x or 0) )*(  (v1.x or 0) - (v2.x or 0) )+( (v1.y or 0) - (v2.y or 0) )*( (v1.y or 0) - (v2.y or 0) )+( (v1.z or 0) - (v2.z or 0) )*( (v1.z or 0) - (v2.z or 0) )  )
end

PointOnSphere = function(alt,azu,radius,orgX,orgY,orgZ)
  local toradians = 0.017453292384744
  alt,azu,radius,orgX,orgY,orgZ = ( tonumber(alt or 0) or 0 ) * toradians, ( tonumber(azu or 0) or 0 ) * toradians, tonumber(radius or 0) or 0, tonumber(orgX or 0) or 0, tonumber(orgY or 0) or 0, tonumber(orgZ or 0) or 0
  if      vector3
  then
      return
      vector3(
           orgX + radius * math.sin( azu ) * math.cos( alt ),
           orgY + radius * math.cos( azu ) * math.cos( alt ),
           orgZ + radius * math.sin( alt )
      )
  end
end