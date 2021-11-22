function DespawnInterior(objects, cb)
    Citizen.CreateThread(function()
        for k, v in pairs(objects) do
            if DoesEntityExist(v) then
                DeleteEntity(v)
            end
        end
        cb()
    end)
end

function GetRotation(input)
    return 360 / (10 * input)
end

-- // Appartments \\ --

function CreateAppartement(spawn)
	local objects = {}
    local POIOffsets = {}
    POIOffsets.exit = json.decode('{"z":34.0,"y":3.55,"x":4.0,"h":0.0}')
    POIOffsets.stash = json.decode('{"z":34.0,"y":2.0,"x":-0.5,"h":0.0}')
	POIOffsets.closet = json.decode('{"z":34.0,"y":-2.5,"x":0.6,"h":0.0}')
	POIOffsets.logout = json.decode('{"z":34.0,"y":1.25,"x":-3.35,"h":0.0}')
	DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
	RequestModel(`gabz_pinkcage`)
    while not HasModelLoaded(`gabz_pinkcage`) do
	    Citizen.Wait(1000)
	end
	local house = CreateObject(`gabz_pinkcage`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(house, true)
	table.insert(objects, house)
    Citizen.Wait(100)
    SetEntityCoords(GetPlayerPed(-1), spawn.x - POIOffsets.exit.x , spawn.y - POIOffsets.exit.y, spawn.z + 1.5)
    Citizen.Wait(45)
    DoScreenFadeIn(500)
    return {objects, POIOffsets}
end

function CreateMidAppartement(spawn)
	local objects = {}
    local POIOffsets = {}
    POIOffsets.exit = json.decode('{"z":32.0,"y":1.25,"x":-5.0,"h":0.0}')
    POIOffsets.stash = json.decode('{"z":32.0,"y":-4.25,"x":3.2,"h":0.0}')
	POIOffsets.closet = json.decode('{"z":32.0,"y":2.50,"x":-1.2,"h":0.0}')
	POIOffsets.logout = json.decode('{"z":32.0,"y":1.25,"x":5.0,"h":0.0}')
	DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
	RequestModel(`furnitured_lowapart`)
    while not HasModelLoaded(`furnitured_lowapart`) do
	    Citizen.Wait(1000)
	end
	local house = CreateObject(`furnitured_lowapart`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(house, true)
	table.insert(objects, house)
    Citizen.Wait(100)
    SetEntityCoords(GetPlayerPed(-1), spawn.x - POIOffsets.exit.x , spawn.y - POIOffsets.exit.y, spawn.z + 1.5)
    Citizen.Wait(45)
    DoScreenFadeIn(500)
    return {objects, POIOffsets}
end

function CreateMidHotel(spawn)
    local objects = {}
    local POIOffsets = {}
	POIOffsets.exit = json.decode('{"z":34.0,"y":3.95,"x":1.66,"h":0}')
	POIOffsets.stash = json.decode('{"z":34.0,"y":-0.9,"x":1.75,"h":0}')
	POIOffsets.closet = json.decode('{"z":34.0,"y":-2.6,"x":1.58,"h":0}')
	POIOffsets.logout = json.decode('{"z":34.0,"y":-0.75,"x":-1.45,"h":0}')
	DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
	RequestModel(`furnitured_motel`)
    while not HasModelLoaded(`furnitured_motel`) do
	    Citizen.Wait(1000)
	end
	local house = CreateObject(`furnitured_motel`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(house, true)
	table.insert(objects, house)
    Citizen.Wait(100)
    SetEntityCoords(GetPlayerPed(-1), spawn.x - POIOffsets.exit.x , spawn.y - POIOffsets.exit.y, spawn.z + 0.2)
    Citizen.Wait(45)
    DoScreenFadeIn(500)
    return {objects, POIOffsets}
end

-- // Houses // --

function HouseTierOne(spawn)
    local objects = {}
    local POIOffsets = {}
    POIOffsets.exit = json.decode('{"z":32.8,"y":15.6,"x":-3.66,"h":0.0}')
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
    RequestModel(`playerhouse_tier1`)
	while not HasModelLoaded(`playerhouse_tier1`) do
	    Citizen.Wait(1000)
	end
    local shell = CreateObject(`playerhouse_tier1`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(shell, true)
    table.insert(objects, shell)

    local dt = CreateObject(`V_16_DT`, spawn.x-1.21854400, spawn.y-1.04389600, spawn.z + 1.39068600, false, false, false)
    table.insert(objects, dt)

    Citizen.Wait(100)
    SetEntityCoords(GetPlayerPed(-1), spawn.x - POIOffsets.exit.x , spawn.y - POIOffsets.exit.y, spawn.z + 1.5)
    Citizen.Wait(45)
    DoScreenFadeIn(500)
    return {objects, POIOffsets}
end

function HouseTierTwo(spawn)
    local objects = {}
    local POIOffsets = {}
    POIOffsets.exit = json.decode('{"z":27.7,"y":3.8,"x":-0.1,"h":0.0}')
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
    RequestModel(`trevors_shell`)
	while not HasModelLoaded(`trevors_shell`) do
	    Citizen.Wait(1000)
	end
    local shell = CreateObject(`trevors_shell`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(shell, true)
    table.insert(objects, shell)

    local dt = CreateObject(`V_16_DT`, spawn.x-1.21854400, spawn.y-1.04389600, spawn.z + 1.39068600, false, false, false)
    table.insert(objects, dt)

    Citizen.Wait(100)
    SetEntityCoords(GetPlayerPed(-1), spawn.x - POIOffsets.exit.x , spawn.y - POIOffsets.exit.y, spawn.z + 6.5)
    Citizen.Wait(45)
    DoScreenFadeIn(500)
    return {objects, POIOffsets}
end

function HouseTierThree(spawn)
    local objects = {}
    local POIOffsets = {}
    POIOffsets.exit = json.decode('{"z":32.8,"y":5.7,"x":0.45,"h":0.0}')
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
    RequestModel(`tante_shell`)
	while not HasModelLoaded(`tante_shell`) do
	    Citizen.Wait(1000)
	end
    local shell = CreateObject(`tante_shell`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(shell, true)
    table.insert(objects, shell)
    local dt = CreateObject(`V_16_DT`, spawn.x-1.21854400, spawn.y-1.04389600, spawn.z + 1.39068600, false, false, false)
    table.insert(objects, dt)

    Citizen.Wait(100)
    SetEntityCoords(GetPlayerPed(-1), spawn.x - POIOffsets.exit.x , spawn.y - POIOffsets.exit.y, spawn.z + 1.5)
    Citizen.Wait(45)
    DoScreenFadeIn(500)
    return {objects, POIOffsets}
end

function HouseTierFour(spawn)
    local objects = {}
    local POIOffsets = {}
    POIOffsets.exit = json.decode('{"z":33.8,"y":-2.69,"x":10.3,"h":0.0}')
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
    RequestModel(`micheal_shell`)
	while not HasModelLoaded(`micheal_shell`) do
	    Citizen.Wait(1000)
	end
    local shell = CreateObject(`micheal_shell`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(shell, true)
    table.insert(objects, shell)
    local dt = CreateObject(`V_16_DT`, spawn.x-1.21854400, spawn.y-1.04389600, spawn.z + 1.39068600, false, false, false)
    table.insert(objects, dt)
    Citizen.Wait(100)
    SetEntityCoords(GetPlayerPed(-1), spawn.x - POIOffsets.exit.x , spawn.y - POIOffsets.exit.y, spawn.z + 0.8)
    Citizen.Wait(45)
    DoScreenFadeIn(500)
    return {objects, POIOffsets}
end

function HouseTierFive(spawn)
    local objects = {}
    local POIOffsets = {}
    POIOffsets.exit = json.decode('{"z":28.5,"y":-7.7,"x":-10.8,"h":0.0}')
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
    RequestModel(`frankelientje`)
	while not HasModelLoaded(`frankelientje`) do
	    Citizen.Wait(1000)
	end
    local shell = CreateObject(`frankelientje`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(shell, true)
    table.insert(objects, shell)
    local dt = CreateObject(`V_16_DT`, spawn.x-1.21854400, spawn.y-1.04389600, spawn.z + 1.39068600, false, false, false)
    table.insert(objects, dt)
    Citizen.Wait(100)
    SetEntityCoords(GetPlayerPed(-1), spawn.x - POIOffsets.exit.x , spawn.y - POIOffsets.exit.y, spawn.z + 6.0)
    Citizen.Wait(45)
    DoScreenFadeIn(500)
    return {objects, POIOffsets}
end

function HouseTierSix(spawn)
    local objects = {}
    local POIOffsets = {}
    POIOffsets.exit = json.decode('{"z":32.8,"y":1.9,"x":1.5,"h":0.0}')
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
    RequestModel(`caravan_shell`)
	while not HasModelLoaded(`caravan_shell`) do
	    Citizen.Wait(1000)
	end
    local shell = CreateObject(`caravan_shell`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(shell, true)
    table.insert(objects, shell)
    local dt = CreateObject(`V_16_DT`, spawn.x-1.21854400, spawn.y-1.04389600, spawn.z + 1.39068600, false, false, false)
    table.insert(objects, dt)
    Citizen.Wait(100)
    SetEntityCoords(GetPlayerPed(-1), spawn.x - POIOffsets.exit.x , spawn.y - POIOffsets.exit.y, spawn.z + 0.8)
    Citizen.Wait(45)
    DoScreenFadeIn(500)
    return {objects, POIOffsets}
end

function HouseTierSeven(spawn)
    local objects = {}
    local POIOffsets = {}
    POIOffsets.exit = json.decode('{"z":27.8,"y":0.3,"x":22.2,"h":0.0}')
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
    RequestModel(`shell_highend`)
	while not HasModelLoaded(`shell_highend`) do
	    Citizen.Wait(1000)
	end
    local shell = CreateObject(`shell_highend`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(shell, true)
    table.insert(objects, shell)
    local dt = CreateObject(`V_16_DT`, spawn.x-1.21854400, spawn.y-1.04389600, spawn.z + 1.39068600, false, false, false)
    table.insert(objects, dt)
    Citizen.Wait(100)
    SetEntityCoords(GetPlayerPed(-1), spawn.x - POIOffsets.exit.x , spawn.y - POIOffsets.exit.y, spawn.z + 7.0)
    Citizen.Wait(45)
    DoScreenFadeIn(500)
    return {objects, POIOffsets}
end

function HouseTierEight(spawn)
    local objects = {}
    local POIOffsets = {}
    POIOffsets.exit = json.decode('{"z":28.45,"y":-0.95,"x":10.4,"h":0.0}')
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
    RequestModel(`shell_highendv2`)
	while not HasModelLoaded(`shell_highendv2`) do
	    Citizen.Wait(1000)
	end
    local shell = CreateObject(`shell_highendv2`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(shell, true)
    table.insert(objects, shell)
    local dt = CreateObject(`V_16_DT`, spawn.x-1.21854400, spawn.y-1.04389600, spawn.z + 1.39068600, false, false, false)
    table.insert(objects, dt)
    Citizen.Wait(100)
    SetEntityCoords(GetPlayerPed(-1), spawn.x - POIOffsets.exit.x , spawn.y - POIOffsets.exit.y, spawn.z + 6.0)
    Citizen.Wait(45)
    DoScreenFadeIn(500)
    return {objects, POIOffsets}
end

function HouseTierNine(spawn)
    local objects = {}
    local POIOffsets = {}
    POIOffsets.exit = json.decode('{"z":33.8,"y":5.9,"x":1.61,"h":0.0}')
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
    RequestModel(`shell_lester`)
	while not HasModelLoaded(`shell_lester`) do
	    Citizen.Wait(1000)
	end
    local shell = CreateObject(`shell_lester`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(shell, true)
    table.insert(objects, shell)
    local dt = CreateObject(`V_16_DT`, spawn.x-1.21854400, spawn.y-1.04389600, spawn.z + 1.39068600, false, false, false)
    table.insert(objects, dt)
    Citizen.Wait(100)
    SetEntityCoords(GetPlayerPed(-1), spawn.x - POIOffsets.exit.x , spawn.y - POIOffsets.exit.y, spawn.z + 0.8)
    Citizen.Wait(45)
    DoScreenFadeIn(500)
    return {objects, POIOffsets}
end

function HouseTierTen(spawn)
    local objects = {}
    local POIOffsets = {}
    POIOffsets.exit = json.decode('{"z":32.4,"y":5.45,"x":1.3,"h":0.0}')
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
    RequestModel(`shell_ranch`)
	while not HasModelLoaded(`shell_ranch`) do
	    Citizen.Wait(1000)
	end
    local shell = CreateObject(`shell_ranch`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(shell, true)
    table.insert(objects, shell)
    local dt = CreateObject(`V_16_DT`, spawn.x-1.21854400, spawn.y-1.04389600, spawn.z + 1.39068600, false, false, false)
    table.insert(objects, dt)
    Citizen.Wait(100)
    SetEntityCoords(GetPlayerPed(-1), spawn.x - POIOffsets.exit.x , spawn.y - POIOffsets.exit.y, spawn.z + 0.8)
    Citizen.Wait(45)
    DoScreenFadeIn(500)
    return {objects, POIOffsets}
end

-- // Garages \\ --

function GarageTierOne(spawn)
    local objects = {}
    local POIOffsets = {}
    POIOffsets.exit = json.decode('{"z":33.9,"y":-0.2,"x":8.8,"h":0.0}')
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
    RequestModel(`shell_warehouse1`)
	while not HasModelLoaded(`shell_warehouse1`) do
	    Citizen.Wait(1000)
	end
    local shell = CreateObject(`shell_warehouse1`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(shell, true)
    table.insert(objects, shell)
    local dt = CreateObject(`V_16_DT`, spawn.x-1.21854400, spawn.y-1.04389600, spawn.z + 1.39068600, false, false, false)
    table.insert(objects, dt)
    Citizen.Wait(100)
    SetEntityCoords(GetPlayerPed(-1), spawn.x - POIOffsets.exit.x , spawn.y - POIOffsets.exit.y, spawn.z + 0.45)
    Citizen.Wait(45)
    DoScreenFadeIn(500)
    return {objects, POIOffsets}
end

function GarageTierTwo(spawn)
    local objects = {}
    local POIOffsets = {}
    POIOffsets.exit = json.decode('{"z":33.9,"y":-5.5,"x":12.3,"h":0.0}')
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
    RequestModel(`shell_warehouse2`)
	while not HasModelLoaded(`shell_warehouse2`) do
	    Citizen.Wait(1000)
	end
    local shell = CreateObject(`shell_warehouse2`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(shell, true)
    table.insert(objects, shell)
    local dt = CreateObject(`V_16_DT`, spawn.x-1.21854400, spawn.y-1.04389600, spawn.z + 1.39068600, false, false, false)
    table.insert(objects, dt)
    Citizen.Wait(100)
    SetEntityCoords(GetPlayerPed(-1), spawn.x - POIOffsets.exit.x , spawn.y - POIOffsets.exit.y, spawn.z + 0.45)
    Citizen.Wait(45)
    DoScreenFadeIn(500)
    return {objects, POIOffsets}
end

function GarageTierThree(spawn)
    local objects = {}
    local POIOffsets = {}
    POIOffsets.exit = json.decode('{"z":33.9,"y":1.6,"x":-2.5,"h":0.0}')
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
    RequestModel(`shell_warehouse3`)
	while not HasModelLoaded(`shell_warehouse3`) do
	    Citizen.Wait(1000)
	end
    local shell = CreateObject(`shell_warehouse3`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(shell, true)
    table.insert(objects, shell)
    local dt = CreateObject(`V_16_DT`, spawn.x-1.21854400, spawn.y-1.04389600, spawn.z + 1.39068600, false, false, false)
    table.insert(objects, dt)
    Citizen.Wait(100)
    SetEntityCoords(GetPlayerPed(-1), spawn.x - POIOffsets.exit.x , spawn.y - POIOffsets.exit.y, spawn.z + 0.45)
    Citizen.Wait(45)
    DoScreenFadeIn(500)
    return {objects, POIOffsets}
end

function SpawnWinkel(spawn)
    local objects = {}
    local POIOffsets = {}
    POIOffsets.exit = json.decode('{"z":32.9,"y":7.85,"x":0.1,"h":0.0}')
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
    RequestModel(`shell_store3`)
	while not HasModelLoaded(`shell_store3`) do
	    Citizen.Wait(1000)
	end
    local shell = CreateObject(`shell_store3`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(shell, true)
    table.insert(objects, shell)
    local dt = CreateObject(`V_16_DT`, spawn.x-1.21854400, spawn.y-1.04389600, spawn.z + 1.39068600, false, false, false)
    table.insert(objects, dt)
    Citizen.Wait(100)
    SetEntityCoords(GetPlayerPed(-1), spawn.x - POIOffsets.exit.x , spawn.y - POIOffsets.exit.y, spawn.z + 0.45)
    Citizen.Wait(45)
    DoScreenFadeIn(500)
    return {objects, POIOffsets}
end

function SpawnKantoor(spawn)
    local objects = {}
    local POIOffsets = {}
    POIOffsets.exit = json.decode('{"z":29.65,"y":-2.0,"x":12.4,"h":0.0}')
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
    RequestModel(`shell_officebig`)
	while not HasModelLoaded(`shell_officebig`) do
	    Citizen.Wait(1000)
	end
    local shell = CreateObject(`shell_officebig`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(shell, true)
    table.insert(objects, shell)
    local dt = CreateObject(`V_16_DT`, spawn.x-1.21854400, spawn.y-1.04389600, spawn.z + 1.39068600, false, false, false)
    table.insert(objects, dt)
    Citizen.Wait(100)
    SetEntityCoords(GetPlayerPed(-1), spawn.x - POIOffsets.exit.x , spawn.y - POIOffsets.exit.y, spawn.z + 4.45)
    Citizen.Wait(45)
    DoScreenFadeIn(500)
    return {objects, POIOffsets}
end

function SpawnDrugs(spawn)
    local objects = {}
    local POIOffsets = {}
    POIOffsets.exit = json.decode('{"z":33.9,"y":-11.7,"x":-17.8,"h":0.0}')
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
    RequestModel(`shell_weed`)
	while not HasModelLoaded(`shell_weed`) do
	    Citizen.Wait(1000)
	end
    local shell = CreateObject(`shell_weed`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(shell, true)
    table.insert(objects, shell)
    local dt = CreateObject(`V_16_DT`, spawn.x-1.21854400, spawn.y-1.04389600, spawn.z + 1.39068600, false, false, false)
    table.insert(objects, dt)
    Citizen.Wait(100)
    SetEntityCoords(GetPlayerPed(-1), spawn.x - POIOffsets.exit.x , spawn.y - POIOffsets.exit.y, spawn.z + 0.45)
    Citizen.Wait(45)
    DoScreenFadeIn(500)
    return {objects, POIOffsets}
end

function TrapHouse(spawn)
    local objects = {}
    local POIOffsets = {}
	POIOffsets.exit = json.decode('{"z":32.8,"y":5.7,"x":0.45,"h":0.0}')
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
    RequestModel(`barbers_shell`)
	while not HasModelLoaded(`barbers_shell`) do
	    Citizen.Wait(1000)
	end
    local shell = CreateObject(`barbers_shell`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(shell, true)
    table.insert(objects, shell)
	local dt = CreateObject(`V_16_DT`, spawn.x-1.21854400, spawn.y-1.04389600, spawn.z + 1.39068600, false, false, false)
    table.insert(objects, dt)
    Citizen.Wait(100)
    SetEntityCoords(GetPlayerPed(-1), spawn.x - POIOffsets.exit.x , spawn.y - POIOffsets.exit.y, spawn.z + 1.5)
    Citizen.Wait(45)
    DoScreenFadeIn(500)
    return {objects, POIOffsets}
end

-- // Furnished Interiors \\ --

function HouseRobTierOne(spawn, addtv, addmicro)
    local objects = {}
    local POIOffsets = {}
	print(addtv, addmicro)
	POIOffsets.exit = json.decode('{"z":32.8,"y":15.6,"x":-3.66,"h":0.0}')
	DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
	RequestModel(GetHashKey("clrp_house_1"))
    while not HasModelLoaded(GetHashKey("clrp_house_1")) do
	    Citizen.Wait(1000)
	end
	SetEntityCoords(PlayerPedId(), 347.04724121094, -1000.2844848633, -99.194671630859)
	Citizen.Wait(1000)
	local shell = CreateObject(GetHashKey("clrp_house_1"), spawn.x, spawn.y-0.05, spawn.z+1.26253700-89.825, false, false, false)
	FreezeEntityPosition(shell, true)
	table.insert(objects, shell)
	local dt = CreateObject(`V_16_DT`,spawn.x-1.21854400,spawn.y-1.04389600,spawn.z+1.39068600,false,false,false)
	local mpmid01 = CreateObject(`V_16_mpmidapart01`,spawn.x+0.52447510,spawn.y-5.04953700,spawn.z+1.32,false,false,false)
	local mpmid09 = CreateObject(`V_16_mpmidapart09`,spawn.x+0.82202150,spawn.y+2.29612000,spawn.z+1.88,false,false,false)
	local mpmid07 = CreateObject(`V_16_mpmidapart07`,spawn.x-1.91445900,spawn.y-6.61911300,spawn.z+1.45,false,false,false)
	local mpmid03 = CreateObject(`V_16_mpmidapart03`,spawn.x-4.82565300,spawn.y-6.86803900,spawn.z+1.14,false,false,false)
	local midData = CreateObject(`V_16_midapartdeta`,spawn.x+2.28558400,spawn.y-1.94082100,spawn.z+1.288628,false,false,false)
	local glow = CreateObject(`V_16_treeglow`,spawn.x-1.37408500,spawn.y-0.95420070,spawn.z+1.135,false,false,false)
	local curtins = CreateObject(`V_16_midapt_curts`,spawn.x-1.96423300,spawn.y-0.95958710,spawn.z+1.280,false,false,false)
	local mpmid13 = CreateObject(`V_16_mpmidapart13`,spawn.x-4.65580700,spawn.y-6.61684000,spawn.z+1.259,false,false,false)
	local mpcab = CreateObject(`V_16_midapt_cabinet`,spawn.x-1.16177400,spawn.y-0.97333810,spawn.z+1.27,false,false,false)
	local mpdecal = CreateObject(`V_16_midapt_deca`,spawn.x+2.311386000,spawn.y-2.05385900,spawn.z+1.297,false,false,false)
	local mpdelta = CreateObject(`V_16_mid_hall_mesh_delta`,spawn.x+3.69693000,spawn.y-5.80020100,spawn.z+1.293,false,false,false)
	local beddelta = CreateObject(`V_16_mid_bed_delta`,spawn.x+7.95187400,spawn.y+1.04246500,spawn.z+1.28402300,false,false,false)
	local bed = CreateObject(`V_16_mid_bed_bed`,spawn.x+6.86376900,spawn.y+1.20651200,spawn.z+1.36589100,false,false,false)
	local beddecal = CreateObject(`V_16_MID_bed_over_decal`,spawn.x+7.82861300,spawn.y+1.04696700,spawn.z+1.34753700,false,false,false)
	local bathDelta = CreateObject(`V_16_mid_bath_mesh_delta`,spawn.x+4.45460500,spawn.y+3.21322800,spawn.z+1.21116100,false,false,false)
	local bathmirror = CreateObject(`V_16_mid_bath_mesh_mirror`,spawn.x+3.57740800,spawn.y+3.25032000,spawn.z+1.48871300,false,false,false)
	--props
	local beerbot = CreateObject(`Prop_CS_Beer_Bot_01`,spawn.x+1.73134600,spawn.y-4.88520200,spawn.z+1.91083000,false,false,false)
	local couch = CreateObject(`v_res_mp_sofa`,spawn.x-1.48765600,spawn.y+1.68100600,spawn.z+1.21640500,false,false,false)
	local chair = CreateObject(`v_res_mp_stripchair`,spawn.x-4.44770800,spawn.y-1.78048800,spawn.z+1.21640500,false,false,false)
	local chair2 = CreateObject(`v_res_tre_chair`,spawn.x+2.91325400,spawn.y-5.27835100,spawn.z+1.22746400,false,false,false)
	local plant = CreateObject(`Prop_Plant_Int_04a`,spawn.x+2.78941300,spawn.y-4.39133900,spawn.z+2.12746400,false,false,false)
	local lamp = CreateObject(`v_res_d_lampa`,spawn.x-3.61473100,spawn.y-6.61465100,spawn.z+2.08382800,false,false,false)
	local fridge = CreateObject(`v_res_fridgemodsml`,spawn.x+1.90339700,spawn.y-3.80026800,spawn.z+1.29917900,false,false,false)
	if addmicro == false then
		local micro = CreateObject(`prop_micro_01`,spawn.x+2.03442400,spawn.y-4.61585100,spawn.z+2.30395600,false,false,false)
	end
	local sideBoard = CreateObject(`V_Res_Tre_SideBoard`,spawn.x+2.84053000,spawn.y-4.30947100,spawn.z+1.24577300,false,false,false)
	local bedSide = CreateObject(`V_Res_Tre_BedSideTable`,spawn.x-3.50363200,spawn.y-6.55289400,spawn.z+1.30625800,false,false,false)
	local lamp2 = CreateObject(`v_res_d_lampa`,spawn.x+2.69674700,spawn.y-3.83123500,spawn.z+2.09373700,false,false,false)
	local plant2 = CreateObject(`v_res_tre_tree`,spawn.x-4.96064800,spawn.y-6.09898500,spawn.z+1.31631400,false,false,false)
	local tableObj = CreateObject(`V_Res_M_DineTble_replace`,spawn.x-3.50712600,spawn.y-4.13621600,spawn.z+1.29625800,false,false,false)
	if addtv == false then
		local tv = CreateObject(`Prop_TV_Flat_01`,spawn.x-5.53120400,spawn.y+0.76299670,spawn.z+2.17236000,false,false,false)
	end
	local plant3 = CreateObject(`v_res_tre_plant`,spawn.x-5.14112800,spawn.y-2.78951000,spawn.z+1.25950800,false,false,false)
	local chair3 = CreateObject(`v_res_m_dinechair`,spawn.x-3.04652400,spawn.y-4.95971200,spawn.z+1.19625800,false,false,false)
	local lampStand = CreateObject(`v_res_m_lampstand`,spawn.x+1.26588400,spawn.y+3.68883900,spawn.z+1.30556700,false,false,false)
	local stool = CreateObject(`V_Res_M_Stool_REPLACED`,spawn.x-3.23216300,spawn.y+2.06159000,spawn.z+1.20556700,false,false,false)
	local chair4 = CreateObject(`v_res_m_dinechair`,spawn.x-2.82237200,spawn.y-3.59831300,spawn.z+1.25950800,false,false,false)
	local chair5 = CreateObject(`v_res_m_dinechair`,spawn.x-4.14955100,spawn.y-4.71316600,spawn.z+1.19625800,false,false,false)
	local chair6 = CreateObject(`v_res_m_dinechair`,spawn.x-3.80622900,spawn.y-3.37648300,spawn.z+1.19625800,false,false,false)
	local plant4 = CreateObject(`v_res_fa_plant01`,spawn.x+2.97859200,spawn.y+2.55307400,spawn.z+1.85796300,false,false,false)
	local storage = CreateObject(`v_res_tre_storageunit`,spawn.x+8.47819500,spawn.y-2.50979300,spawn.z+1.19712300,false,false,false)
	local storage2 = CreateObject(`v_res_tre_storagebox`,spawn.x+9.75982700,spawn.y-1.35874100,spawn.z+1.29625800,false,false,false)
	local basketmess = CreateObject(`v_res_tre_basketmess`,spawn.x+8.70730600,spawn.y-2.55503600,spawn.z+1.94059590,false,false,false)
	local lampStand2 = CreateObject(`v_res_m_lampstand`,spawn.x+9.54306000,spawn.y-2.50427700,spawn.z+1.30556700,false,false,false)
	local plant4 = CreateObject(`Prop_Plant_Int_03a`,spawn.x+9.87521400,spawn.y+3.90917400,spawn.z+1.20829700,false,false,false)
	local basket = CreateObject(`v_res_tre_washbasket`,spawn.x+9.39091500,spawn.y+4.49676300,spawn.z+1.19625800,false,false,false)
	local wardrobe = CreateObject(`V_Res_Tre_Wardrobe`,spawn.x+8.46626300,spawn.y+4.53223600,spawn.z+1.19425800,false,false,false)
	local basket2 = CreateObject(`v_res_tre_flatbasket`,spawn.x+8.51593000,spawn.y+4.55647300,spawn.z+3.46737300,false,false,false)
	local basket3 = CreateObject(`v_res_tre_basketmess`,spawn.x+7.57797200,spawn.y+4.55198800,spawn.z+3.46737300,false,false,false)
	local basket4 = CreateObject(`v_res_tre_flatbasket`,spawn.x+7.12286400,spawn.y+4.54689200,spawn.z+3.46737300,false,false,false)
	local wardrobe2 = CreateObject(`V_Res_Tre_Wardrobe`,spawn.x+7.24382000,spawn.y+4.53423500,spawn.z+1.19625800,false,false,false)
	local basket5 = CreateObject(`v_res_tre_flatbasket`,spawn.x+8.03364600,spawn.y+4.54835500,spawn.z+3.46737300,false,false,false)
	local switch = CreateObject(`v_serv_switch_2`,spawn.x+6.28086900,spawn.y-0.68169880,spawn.z+2.30326000,false,false,false)
	local table2 = CreateObject(`V_Res_Tre_BedSideTable`,spawn.x+5.84416200,spawn.y+2.57377400,spawn.z+1.22089100,false,false,false)
	local lamp3 = CreateObject(`v_res_d_lampa`,spawn.x+5.84912100,spawn.y+2.58001100,spawn.z+1.95311890,false,false,false)
	local laundry = CreateObject(`v_res_mlaundry`,spawn.x+5.77729800,spawn.y+4.60211400,spawn.z+1.19674400,false,false,false)
	local ashtray = CreateObject(`Prop_ashtray_01`,spawn.x-1.24716200,spawn.y+1.07820500,spawn.z+1.89089300,false,false,false)
	local candle1 = CreateObject(`v_res_fa_candle03`,spawn.x-2.89289900,spawn.y-4.35329700,spawn.z+2.02881310,false,false,false)
	local candle2 = CreateObject(`v_res_fa_candle02`,spawn.x-3.99865700,spawn.y-4.06048500,spawn.z+2.02530190,false,false,false)
	local candle3 = CreateObject(`v_res_fa_candle01`,spawn.x-3.37733400,spawn.y-3.66639800,spawn.z+2.02526200,false,false,false)
	local woodbowl = CreateObject(`v_res_m_woodbowl`,spawn.x-3.50787400,spawn.y-4.11983000,spawn.z+2.02589900,false,false,false)
	local tablod = CreateObject(`V_Res_TabloidsA`,spawn.x-0.80513000,spawn.y+0.51389600,spawn.z+1.18418800,false,false,false)
	local tapeplayer = CreateObject(`Prop_Tapeplayer_01`,spawn.x-1.26010100,spawn.y-3.62966400,spawn.z+2.37883200,false,false,false)
	local woodbowl2 = CreateObject(`v_res_tre_fruitbowl`,spawn.x+2.77764900,spawn.y-4.138297000,spawn.z+2.10340100,false,false,false)
	local sculpt = CreateObject(`v_res_sculpt_dec`,spawn.x+3.03932200,spawn.y+1.62726400,spawn.z+3.58363900,false,false,false)
	local jewlry = CreateObject(`v_res_jewelbox`,spawn.x+3.04164100,spawn.y+0.31671810,spawn.z+3.58363900,false,false,false)
	local basket6 = CreateObject(`v_res_tre_basketmess`,spawn.x-1.64906300,spawn.y+1.62675900,spawn.z+1.39038500,false,false,false)
	local basket7 = CreateObject(`v_res_tre_flatbasket`,spawn.x-1.63938900,spawn.y+0.91133310,spawn.z+1.39038500,false,false,false)
	local basket8 = CreateObject(`v_res_tre_flatbasket`,spawn.x-1.19923400,spawn.y+1.69598600,spawn.z+1.39038500,false,false,false)
	local basket9 = CreateObject(`v_res_tre_basketmess`,spawn.x-1.18293800,spawn.y+0.91436380,spawn.z+1.39038500,false,false,false)
	local bowl = CreateObject(`v_res_r_sugarbowl`,spawn.x-0.26029210,spawn.y-6.66716800,spawn.z+3.77324900,false,false,false)
	local breadbin = CreateObject(`Prop_Breadbin_01`,spawn.x+2.09788500,spawn.y-6.57634000,spawn.z+2.24041900,false,false,false)
	local knifeblock = CreateObject(`v_res_mknifeblock`,spawn.x+1.82084700,spawn.y-6.58438500,spawn.z+2.27399500,false,false,false)
	local toaster = CreateObject(`prop_toaster_01`,spawn.x-1.05790700,spawn.y-6.59017400,spawn.z+2.26793200,false,false,false)
	local wok = CreateObject(`prop_wok`,spawn.x+2.01728800,spawn.y-5.57091500,spawn.z+2.26793200,false,false,false)
	local plant5 = CreateObject(`Prop_Plant_Int_03a`,spawn.x+2.55015600,spawn.y+4.60183900,spawn.z+1.20829700,false,false,false)
	local tumbler = CreateObject(`p_tumbler_cs2_s`,spawn.x-0.90916440,spawn.y-4.24099100,spawn.z+2.26793200,false,false,false)
	local wisky = CreateObject(`p_whiskey_bottle_s`,spawn.x-0.92809300,spawn.y-3.99099100,spawn.z+2.26793200,false,false,false)
	local tissue = CreateObject(`v_res_tissues`,spawn.x+7.95889300,spawn.y-2.54847100,spawn.z+1.94013400,false,false,false)
	local pants = CreateObject(`V_16_Ap_Mid_Pants4`,spawn.x+7.55366500,spawn.y-0.25457100,spawn.z+1.33009200,false,false,false)
	local pants2 = CreateObject(`V_16_Ap_Mid_Pants5`,spawn.x+7.76753200,spawn.y+3.00476500,spawn.z+1.33052800,false,false,false)
	local hairdryer = CreateObject(`v_club_vuhairdryer`,spawn.x+8.12616000,spawn.y-2.50562000,spawn.z+1.96009390,false,false,false)

	FreezeEntityPosition(dt,true)
	FreezeEntityPosition(mpmid01,true)
	FreezeEntityPosition(mpmid09,true)
	FreezeEntityPosition(mpmid07,true)
	FreezeEntityPosition(mpmid03,true)
	FreezeEntityPosition(midData,true)
	FreezeEntityPosition(glow,true)
	FreezeEntityPosition(curtins,true)
	FreezeEntityPosition(mpmid13,true)
	FreezeEntityPosition(mpcab,true)
	FreezeEntityPosition(mpdecal,true)
	FreezeEntityPosition(mpdelta,true)
	FreezeEntityPosition(couch,true)
	FreezeEntityPosition(chair,true)
	FreezeEntityPosition(chair2,true)
	FreezeEntityPosition(plant,true)
	FreezeEntityPosition(lamp,true)
	FreezeEntityPosition(fridge,true)
	if addmicro == false then
		FreezeEntityPosition(micro,true)
	end
	FreezeEntityPosition(sideBoard,true)
	FreezeEntityPosition(bedSide,true)
	FreezeEntityPosition(plant2,true)
	FreezeEntityPosition(tableObj,true)
	if addtv == false then
		FreezeEntityPosition(tv,true)
	end
	FreezeEntityPosition(plant3,true)
	FreezeEntityPosition(chair3,true)
	FreezeEntityPosition(lampStand,true)
	FreezeEntityPosition(chair4,true)
	FreezeEntityPosition(chair5,true)
	FreezeEntityPosition(chair6,true)
    FreezeEntityPosition(plant4,true)
    FreezeEntityPosition(storage,true)
	FreezeEntityPosition(storage2,true)
	FreezeEntityPosition(basket,true)
	FreezeEntityPosition(wardrobe,true)
	FreezeEntityPosition(wardrobe2,true)
	FreezeEntityPosition(table2,true)
	FreezeEntityPosition(lamp3,true)
	FreezeEntityPosition(laundry,true)
	FreezeEntityPosition(beddelta,true)
	FreezeEntityPosition(bed,true)
	FreezeEntityPosition(beddecal,true)
	FreezeEntityPosition(tapeplayer,true)
	FreezeEntityPosition(basket7,true)
	FreezeEntityPosition(basket6,true)
	FreezeEntityPosition(basket8,true)
    FreezeEntityPosition(basket9,true)

    table.insert(objects, dt)
    table.insert(objects, mpmid01)
    table.insert(objects, mpmid09)
    table.insert(objects, mpmid07)
    table.insert(objects, mpmid03)
    table.insert(objects, midData)
    table.insert(objects, glow)
    table.insert(objects, curtins)
    table.insert(objects, mpmid13)
    table.insert(objects, mpcab)
    table.insert(objects, mpdecal)
    table.insert(objects, mpdelta)
    table.insert(objects, couch)
    table.insert(objects, chair)
    table.insert(objects, chair2)
    table.insert(objects, plant)
    table.insert(objects, lamp)
    table.insert(objects, fridge)
	if addmicro == false then
		table.insert(objects, micro)
	end
    table.insert(objects, sideBoard)
    table.insert(objects, bedSide)
    table.insert(objects, plant2)
    table.insert(objects, tableObj)
	if addtv == false then
		table.insert(objects, tv)
	end
    table.insert(objects, plant3)
    table.insert(objects, chair3)
    table.insert(objects, lampStand)
    table.insert(objects, chair4)
    table.insert(objects, chair5)
    table.insert(objects, chair6)
    table.insert(objects, plant4)
    table.insert(objects, storage2)
    table.insert(objects, basket)
    table.insert(objects, wardrobe)
    table.insert(objects, wardrobe2)
    table.insert(objects, table2)
    table.insert(objects, lamp3)
    table.insert(objects, laundry)
    table.insert(objects, beddelta)
    table.insert(objects, bed)
    table.insert(objects, beddecal)
    table.insert(objects, tapeplayer)
    table.insert(objects, basket7)
    table.insert(objects, basket6)
    table.insert(objects, basket8)
    table.insert(objects, basket9)

	SetEntityHeading(beerbot,GetEntityHeading(beerbot)+90)
	SetEntityHeading(couch,GetEntityHeading(couch)-90)
	SetEntityHeading(chair,GetEntityHeading(chair)+GetRotation(0.28045480))
	SetEntityHeading(chair2,GetEntityHeading(chair2)+GetRotation(0.3276100))
	SetEntityHeading(fridge,GetEntityHeading(chair2)+160)
	if addmicro == false then
		SetEntityHeading(micro,GetEntityHeading(micro)-80)
	end
	SetEntityHeading(sideBoard,GetEntityHeading(sideBoard)+90)
	SetEntityHeading(bedSide,GetEntityHeading(bedSide)+180)
	if addtv == false then
		SetEntityHeading(tv,GetEntityHeading(tv)+90)
	end
	SetEntityHeading(plant3,GetEntityHeading(plant3)+90)
	SetEntityHeading(chair3,GetEntityHeading(chair3)+200)
	SetEntityHeading(chair4,GetEntityHeading(chair3)+100)
	SetEntityHeading(chair5,GetEntityHeading(chair5)+135)
	SetEntityHeading(chair6,GetEntityHeading(chair6)+10)
	SetEntityHeading(storage,GetEntityHeading(storage)+180)
	SetEntityHeading(storage2,GetEntityHeading(storage2)-90)
	SetEntityHeading(table2,GetEntityHeading(table2)+90)
	SetEntityHeading(tapeplayer,GetEntityHeading(tapeplayer)+90)
    SetEntityHeading(knifeblock,GetEntityHeading(knifeblock)+180)

    SetEntityCoords(GetPlayerPed(-1), spawn.x - POIOffsets.exit.x , spawn.y - POIOffsets.exit.y, spawn.z + 1.5)
	SetEntityHeading(PlayerPedId(), 358.106)
    DoScreenFadeIn(500)
    return {objects, POIOffsets}
end

function HouseRobTierThree(spawn)
	local objects = {}
    local POIOffsets = {}
	POIOffsets.exit = json.decode('{"z":40.8,"y":-2.69,"x":10.3,"h":0.0}')
	DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
	RequestModel(`micheal_shell`)
	while not HasModelLoaded(`micheal_shell`) do
	    Citizen.Wait(1000)
	end
	SetEntityCoords(PlayerPedId(), -813.54, 179.36, 72.15)
	Citizen.Wait(1000)
	local house = CreateObject(`micheal_shell`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(house, true)
	table.insert(objects, house)

	local dt = CreateObject(`V_16_DT`, spawn.x-1.21854400, spawn.y-1.04389600, spawn.z + 1.39068600, false, false, false)
	local gasfornuis = CreateObject(`v_res_ovenhobmod`,spawn.x+7.11616000,spawn.y+5.6062000,spawn.z+0.6203,false,false,false)
	local gasfornuis2 = CreateObject(`v_res_ovenhobmod`,spawn.x+8.00876000,spawn.y+5.6062000,spawn.z+0.6203,false,false,false)
	local bank = CreateObject(`apa_mp_h_stn_sofacorn_01`,spawn.x-2.23024,spawn.y-5.9684600,spawn.z+0.8349,false,false,false)
	local avunits = CreateObject(`apa_mp_h_str_avunits_01`,spawn.x-1.48765600,spawn.y-11.9656,spawn.z+0.8349,false,false,false)
	local eettafel = CreateObject(`v_res_m_dinetble_replace`,spawn.x+8.07676,spawn.y-2.2142,spawn.z+0.8581,false,false,false)
	local stoel1 = CreateObject(`v_res_mbchair`,spawn.x+8.79056,spawn.y-1.5427,spawn.z+0.8604,false,false,false)
	local stoel2 = CreateObject(`v_res_mbchair`,spawn.x+7.37686,spawn.y-1.5945,spawn.z+0.8604,false,false,false)
	local stoel3 = CreateObject(`v_res_mbchair`,spawn.x+7.38636,spawn.y-2.9317,spawn.z+0.8604,false,false,false)
	local stoel4 = CreateObject(`v_res_mbchair`,spawn.x+8.74406,spawn.y-2.883,spawn.z+0.8604,false,false,false)
	local consolemod = CreateObject(`v_res_mconsolemod`,spawn.x-5.55194,spawn.y-2.2877,spawn.z+4.7544,false,false,false)
	local armoire = CreateObject(`v_res_m_armoire`,spawn.x+2.45376,spawn.y-5.1888,spawn.z+4.7544,false,false,false)
	local bed1 = CreateObject(`v_res_mdbed`,spawn.x+0.78096,spawn.y-8.8889,spawn.z+4.771,false,false,false)
	local bad = CreateObject(`apa_mp_h_bathtub_01`,spawn.x-1.48214,spawn.y-11.2114,spawn.z+4.7585,false,false,false)
	local toilet = CreateObject(`prop_toilet_01`,spawn.x-2.79564,spawn.y-11.3553,spawn.z+4.7538,false,false,false)
	local wastafel = CreateObject(`prop_sink_06`,spawn.x-3.03954,spawn.y-8.6854,spawn.z+4.7531,false,false,false)
	local handdoek = CreateObject(`prop_towel_rail_01`,spawn.x-0.68474,spawn.y-9.4637,spawn.z+5.5607,false,false,false)
	local doucheding = CreateObject(`prop_shower_rack_01`,spawn.x-0.69474,spawn.y-11.0642,spawn.z+5.5607,false,false,false)
	local zeep = CreateObject(`prop_toilet_soap_02`,spawn.x-0.82164,spawn.y-11.0668,spawn.z+5.6127,false,false,false)
	local bed2 = CreateObject(`apa_mp_h_bed_with_table_02`,spawn.x-7.87674,spawn.y+5.9472,spawn.z+4.7629,false,false,false)
	local schilderij = CreateObject(`apa_p_h_acc_artwalll_02`,spawn.x-7.86444,spawn.y+5.9283,spawn.z+5.6751,false,false,false)
	local bureau = CreateObject(`v_med_p_desk`,spawn.x-6.80674,spawn.y-1.93183,spawn.z+4.7536,false,false,false)
	local bureaustoel = CreateObject(`v_club_officechair`,spawn.x-7.97964,spawn.y-2.2074,spawn.z+4.7735,false,false,false)
	local kast = CreateObject(`v_corp_offshelf`,spawn.x-10.9832,spawn.y-2.2,spawn.z+4.7586,false,false,false)
	local laptop = CreateObject(`prop_laptop_01a`,spawn.x-7.10454,spawn.y-1.7372,spawn.z+5.5023,false,false,false)
	local muis = CreateObject(`prop_mouse_01b`,spawn.x-7.21634,spawn.y-2.0773,spawn.z+5.5035,false,false,false)
	local koffietafel = CreateObject(`v_res_fh_coftbldisp`,spawn.x-0.365654,spawn.y-8.1713,spawn.z+0.8478,false,false,false)
	local armstoel = CreateObject(`apa_mp_h_stn_chairarm_12`,spawn.x+2.40106,spawn.y-10.2779,spawn.z+0.8478,false,false,false)
	local voetensteun = CreateObject(`apa_mp_h_stn_chairstool_12`,spawn.x+1.51176,spawn.y-9.764,spawn.z+0.8478,false,false,false)
	local keukenkast = CreateObject(`prop_cs_kitchen_cab_l`,spawn.x+9.92616000,spawn.y+5.7062000,spawn.z+1.645,false,false,false)
	local bloemenvaas = CreateObject(`v_res_m_vasefresh`,spawn.x-8.11436,spawn.y-2.1717,spawn.z+1.6992,false,false,false)
	local lamp = CreateObject(`v_ret_gc_lamp`,spawn.x-6.758,spawn.y-2.763,spawn.z+5.5,false,false,false)
	local bed3 = CreateObject(`v_res_msonbed`,spawn.x-6.165,spawn.y-10.639,spawn.z+4.763,false,false,false)
	local kast2 = CreateObject(`v_res_cabinet`,spawn.x-4.387,spawn.y+4.302,spawn.z+4.678,false,false,false)
	local kast3 = CreateObject(`v_res_m_sidetable`,spawn.x+4.728,spawn.y-2.275,spawn.z+4.753,false,false,false)
	local schilderij2 = CreateObject(`apa_mp_h_acc_artwallm_04`,spawn.x-5.859,spawn.y-2.277,spawn.z+6.119,false,false,false)
	local meubel = CreateObject(`v_res_d_dressingtable`,spawn.x-3.543,spawn.y+1.2602,spawn.z+4.753,false,false,false)
	local nachtkast = CreateObject(`v_res_mbbedtable`,spawn.x-4.813,spawn.y-11.703,spawn.z+4.763,false,false,false)
	local nachtkast2 = CreateObject(`v_res_mbbedtable`,spawn.x-7.518,spawn.y-11.697,spawn.z+4.753,false,false,false)
	local meubel2 = CreateObject(`v_res_d_dressingtable`,spawn.x+1.411,spawn.y-11.608,spawn.z+4.753,false,false,false)
	local kast4 = CreateObject(`apa_mp_h_str_sideboardl_11`,spawn.x-0.176,spawn.y-1.24,spawn.z+0.848,false,false,false)
	local schilderij3 = CreateObject(`ex_mp_h_acc_artwallm_02`,spawn.x-0.176,spawn.y-1.189,spawn.z+2.163,false,false,false)
	local plant = CreateObject(`v_med_p_planter`,spawn.x-2.034,spawn.y-1.639,spawn.z+0.859,false,false,false)
	local kast5 = CreateObject(`v_res_mcupboard`,spawn.x+0.93716,spawn.y+0.3832,spawn.z+0.374,false,false,false)
	local golftas = CreateObject(`prop_golf_bag_01c`,spawn.x-10.653,spawn.y+5.15,spawn.z+0.183,false,false,false)
	local kunst = CreateObject(`apa_mp_h_acc_dec_head_01`,spawn.x-8.126,spawn.y-0.075,spawn.z+1.267,false,false,false)
	local kunst2 = CreateObject(`apa_mp_h_acc_dec_sculpt_02`,spawn.x-7.547,spawn.y-0.075,spawn.z+1.267,false,false,false)
	local bank2 = CreateObject(`v_res_r_sofa`,spawn.x-7.62,spawn.y+5.255,spawn.z+0.167,false,false,false)
	local schilderij4 = CreateObject(`ex_mp_h_acc_artwallm_02`,spawn.x-7.595,spawn.y+5.884,spawn.z+1.564,false,false,false)
	local kast6 = CreateObject(`v_res_mconsolemod`,spawn.x-7.799,spawn.y+0.537,spawn.z+0.173,false,false,false)
	local tafeltje = CreateObject(`v_res_mbbedtable`,spawn.x+1.458,spawn.y+5.495,spawn.z+3.015,false,false,false)
	local plant2 = CreateObject(`v_res_rubberplant`,spawn.x+1.491,spawn.y+5.524,spawn.z+3.565,false,false,false)
	local bank3 = CreateObject(`v_club_officesofa`,spawn.x-7.932,spawn.y-7.054,spawn.z+4.768,false,false,false)
	local box = CreateObject(`v_res_tre_storagebox`,spawn.x-3.832,spawn.y-7.528,spawn.z+4.763,false,false,false)
	local lamp2 = CreateObject(`v_club_vu_lamp`,spawn.x-4.832,spawn.y-11.730,spawn.z+5.313,false,false,false)
	local speakerdock = CreateObject(`v_res_fh_speakerdock`,spawn.x-7.53,spawn.y-11.632,spawn.z+5.3,false,false,false)
	local fan = CreateObject(`v_res_tre_lightfan`,spawn.x-1.276,spawn.y-7.481,spawn.z+4.162,false,false,false)
	local kunst3 = CreateObject(`v_res_sculpt_dec`,spawn.x-4.868,spawn.y-7.307,spawn.z+3.098,false,false,false)
	local kunst4 = CreateObject(`v_res_sculpt_dece`,spawn.x-4.903,spawn.y-7.667,spawn.z+2.112,false,false,false)
	local kunst5 = CreateObject(`v_res_r_figoblisk`,spawn.x-4.842,spawn.y-5.623,spawn.z+2.1,false,false,false)
	local kunst6 = CreateObject(`v_res_r_figflamenco`,spawn.x+0.947,spawn.y-1.451,spawn.z+1.73,false,false,false)
	local plant2 = CreateObject(`v_res_m_bananaplant`,spawn.x-1.73,spawn.y+2.15,spawn.z-0.398,false,false,false)
	local kunst7 = CreateObject(`ba_prop_battle_trophy_battler`,spawn.x-4.958,spawn.y-9.021,spawn.z+2.097,false,false,false)
	local kunst8 = CreateObject(`ba_prop_battle_trophy_no1`,spawn.x-4.899,spawn.y-9.309,spawn.z+2.097,false,false,false)
	local bong = CreateObject(`prop_bong_01`,spawn.x-4.851,spawn.y-9.808,spawn.z+2.097,false,false,false)
	local plant3 = CreateObject(`v_res_tre_tree`,spawn.x+4.654,spawn.y-4.830,spawn.z+0.848,false,false,false)
	local kunst9 = CreateObject(`v_res_r_figfemale`,spawn.x-4.933,spawn.y-6.174,spawn.z+2.109,false,false,false)
	local kunst10 = CreateObject(`v_res_r_figcat`,spawn.x-4.942,spawn.y-5.07,spawn.z+3.1,false,false,false)
	local kunst11 = CreateObject(`v_res_sculpt_decf`,spawn.x-4.903,spawn.y-5.93,spawn.z+3.1,false,false,false)
	local kunst12 = CreateObject(`v_res_r_fighorsestnd`,spawn.x-4.978,spawn.y-5.157,spawn.z+2.109,false,false,false)
	local kunst13 = CreateObject(`v_med_p_vaseround`,spawn.x-1.381,spawn.y-1.561,spawn.z+1.725,false,false,false)
	local krijtbord = CreateObject(`v_res_mchalkbrd`,spawn.x+2.208,spawn.y+2.895,spawn.z+1.645,false,false,false)
	local tijdschrift = CreateObject(`v_res_fashmagopen`,spawn.x-0.304,spawn.y-1.464,spawn.z+1.725,false,false,false)
	local kluis = CreateObject(`prop_ld_int_safe_01`,spawn.x-7.078,spawn.y-0.925,spawn.z+4.525,false,false,false)
	local plafondlamp = CreateObject(`ba_prop_battle_lights_ceiling_l_c`,spawn.x-1.489,spawn.y+1.703,spawn.z+5.858,false,false,false)

	FreezeEntityPosition(gasfornuis,true)
	FreezeEntityPosition(gasfornuis2,true)
	FreezeEntityPosition(keukenkast,true)
	FreezeEntityPosition(bank,true)
	FreezeEntityPosition(avunits,true)
	FreezeEntityPosition(eettafel,true)
	FreezeEntityPosition(stoel1,true)
	FreezeEntityPosition(stoel2,true)
	FreezeEntityPosition(stoel3,true)
	FreezeEntityPosition(stoel4,true)
	FreezeEntityPosition(consolemod,true)
	FreezeEntityPosition(armoire,true)
	FreezeEntityPosition(bed1,true)
	FreezeEntityPosition(bad,true)
	FreezeEntityPosition(toilet,true)
	FreezeEntityPosition(wastafel,true)
	FreezeEntityPosition(handdoek,true)
	FreezeEntityPosition(toilet,true)
	FreezeEntityPosition(wastafel,true)
	FreezeEntityPosition(handdoek,true)
	FreezeEntityPosition(doucheding,true)
	FreezeEntityPosition(zeep,true)
	FreezeEntityPosition(bed2,true)
	FreezeEntityPosition(kast,true)
	FreezeEntityPosition(bureau,true)
	FreezeEntityPosition(bureaustoel,true)
	FreezeEntityPosition(laptop,true)
	FreezeEntityPosition(muis,true)
	FreezeEntityPosition(koffietafel,true)
	FreezeEntityPosition(armstoel,true)
	FreezeEntityPosition(voetensteun,true)
	FreezeEntityPosition(plant,true)
	FreezeEntityPosition(nachtkast,true)
	FreezeEntityPosition(nachtkast2,true)
	FreezeEntityPosition(schilderij2,true)
	FreezeEntityPosition(schilderij3,true)
	FreezeEntityPosition(meubel,true)
	FreezeEntityPosition(meubel2,true)
	FreezeEntityPosition(kast2,true)
	FreezeEntityPosition(kast3,true)
	FreezeEntityPosition(kast4,true)
	FreezeEntityPosition(kast5,true)
	FreezeEntityPosition(bed3,true)
	FreezeEntityPosition(kunst,true)
	FreezeEntityPosition(kunst2,true)
	FreezeEntityPosition(bank2,true)
	FreezeEntityPosition(kast6,true)
	FreezeEntityPosition(schilderij4,true)
	FreezeEntityPosition(kunst8,true)
	FreezeEntityPosition(kluis,true)
	FreezeEntityPosition(plafondlamp,true)
	FreezeEntityPosition(krijtbord,true)
	FreezeEntityPosition(plant3,true)
	FreezeEntityPosition(plant2,true)
	FreezeEntityPosition(box,true)
	FreezeEntityPosition(bank3,true)
	FreezeEntityPosition(speakerdock,true)
	FreezeEntityPosition(kast6,true)
	FreezeEntityPosition(schilderij4,true)
	FreezeEntityPosition(tafeltje,true)
	FreezeEntityPosition(plant2,true)
	FreezeEntityPosition(schilderij,true)

	table.insert(objects, dt)
	table.insert(objects, gasfornuis)
	table.insert(objects, gasfornuis2)
	table.insert(objects, bank)
	table.insert(objects, avunits)
	table.insert(objects, eettafel)
	table.insert(objects, stoel1)
	table.insert(objects, stoel2)
	table.insert(objects, stoel3)
	table.insert(objects, stoel4)
	table.insert(objects, consolemod)
	table.insert(objects, armoire)
	table.insert(objects, bed1)
	table.insert(objects, bad)
	table.insert(objects, toilet)
	table.insert(objects, wastafel)
	table.insert(objects, handdoek)
	table.insert(objects, doucheding)
	table.insert(objects, zeep)
	table.insert(objects, bed2)
	table.insert(objects, schilderij)
	table.insert(objects, bureau)
	table.insert(objects, bureaustoel)
	table.insert(objects, kast)
	table.insert(objects, laptop)
	table.insert(objects, muis)
	table.insert(objects, koffietafel)
	table.insert(objects, armstoel)
	table.insert(objects, voetensteun)
	table.insert(objects, keukenkast)
	table.insert(objects, bloemenvaas)
	table.insert(objects, lamp)
	table.insert(objects, lamp)
	table.insert(objects, bed3)
	table.insert(objects, kast2)
	table.insert(objects, kast3)
	table.insert(objects, schilderij2)
	table.insert(objects, meubel)
	table.insert(objects, nachtkast)
	table.insert(objects, nachtkast2)
	table.insert(objects, meubel2)
	table.insert(objects, kast4)
	table.insert(objects, schilderij3)
	table.insert(objects, plant)
	table.insert(objects, kast5)
	table.insert(objects, golftas)
	table.insert(objects, kunst)
	table.insert(objects, kunst2)
	table.insert(objects, bank2)
	table.insert(objects, schilderij4)
	table.insert(objects, kast6)
	table.insert(objects, tafeltje)
	table.insert(objects, plant2)
	table.insert(objects, bank3)
	table.insert(objects, box)
	table.insert(objects, lamp2)
	table.insert(objects, speakerdock)
	table.insert(objects, fan)
	table.insert(objects, kunst3)
	table.insert(objects, kunst4)
	table.insert(objects, kunst5)
	table.insert(objects, kunst6)
	table.insert(objects, plant2)
	table.insert(objects, kunst7)
	table.insert(objects, kunst8)
	table.insert(objects, bong)
	table.insert(objects, plant3)
	table.insert(objects, kunst9)
	table.insert(objects, kunst10)
	table.insert(objects, kunst11)
	table.insert(objects, kunst12)
	table.insert(objects, kunst13)
	table.insert(objects, krijtbord)
	table.insert(objects, tijdschrift)
	table.insert(objects, kluis)
	table.insert(objects, plafondlamp)

	SetEntityHeading(bank,GetEntityHeading(bank)+90)
	SetEntityHeading(avunits,GetEntityHeading(avunits)+180)
	SetEntityHeading(stoel1,GetEntityHeading(stoel1)+315)
	SetEntityHeading(stoel2,GetEntityHeading(stoel2)+45)
	SetEntityHeading(stoel3,GetEntityHeading(stoel3)+135)
	SetEntityHeading(stoel4,GetEntityHeading(stoel4)+225)
	SetEntityHeading(consolemod,GetEntityHeading(consolemod)+90)
	SetEntityHeading(bed1,GetEntityHeading(bed1)+90)
	SetEntityHeading(bad,GetEntityHeading(bad)+180)
	SetEntityHeading(toilet,GetEntityHeading(toilet)+180)
	SetEntityHeading(wastafel,GetEntityHeading(wastafel)+90)
	SetEntityHeading(kast,GetEntityHeading(kast)+90)
	SetEntityHeading(handdoek,GetEntityHeading(handdoek)+270)
	SetEntityHeading(doucheding,GetEntityHeading(doucheding)+270)
	SetEntityHeading(zeep,GetEntityHeading(zeep)+270)
	SetEntityHeading(bureau,GetEntityHeading(bureau)+270)
	SetEntityHeading(bureaustoel,GetEntityHeading(bureaustoel)+103)
	SetEntityHeading(laptop,GetEntityHeading(laptop)+283)
	SetEntityHeading(muis,GetEntityHeading(muis)+270)
	SetEntityHeading(koffietafel,GetEntityHeading(koffietafel)+270)
	SetEntityHeading(armstoel,GetEntityHeading(armstoel)+240)
	SetEntityHeading(voetensteun,GetEntityHeading(voetensteun)+240)
	SetEntityHeading(schilderij2,GetEntityHeading(schilderij2)+90)
	SetEntityHeading(bed3,GetEntityHeading(bed3)+180)
	SetEntityHeading(lamp,GetEntityHeading(lamp)+180)
	SetEntityHeading(kast2,GetEntityHeading(kast2)+270)
	SetEntityHeading(kast3,GetEntityHeading(kast3)+270)
	SetEntityHeading(meubel,GetEntityHeading(meubel)+270)
	SetEntityHeading(meubel2,GetEntityHeading(meubel2)+180)
	SetEntityHeading(kast5,GetEntityHeading(kast5)+180)
	SetEntityHeading(kast6,GetEntityHeading(kast6)+180)
	SetEntityHeading(kunst,GetEntityHeading(kunst)+180)
	SetEntityHeading(kunst2,GetEntityHeading(kunst2)+180)
	SetEntityHeading(krijtbord,GetEntityHeading(krijtbord)+90)
	SetEntityHeading(plant2,GetEntityHeading(plant2)+270)
	SetEntityHeading(kunst12,GetEntityHeading(kunst12)+90)
	SetEntityHeading(kunst11,GetEntityHeading(kunst11)+90)
	SetEntityHeading(kluis,GetEntityHeading(kluis)+270)
	SetEntityHeading(box,GetEntityHeading(box)+90)
	SetEntityHeading(bank3,GetEntityHeading(bank3)+90)
	SetEntityHeading(kunst4,GetEntityHeading(kunst4)+90)

    SetEntityCoords(GetPlayerPed(-1), spawn.x - POIOffsets.exit.x , spawn.y - POIOffsets.exit.y, spawn.z + 0.1)

    DoScreenFadeIn(500)
    return {objects, POIOffsets}
end