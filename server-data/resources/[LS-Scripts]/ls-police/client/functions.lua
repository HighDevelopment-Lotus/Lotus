local PoliceProps = {}

-- Code

function SpawnPoliceProps()
    for k, v in pairs(Config.PoliceProps) do
        local Prop = GetHashKey(v['Prop'])
        exports['ls-assets']:RequestModelHash(Prop)
        local Object = CreateObject(Prop, v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'], false, false, false)
        SetEntityHeading(Object, v['Coords']['H'])
        FreezeEntityPosition(Object, true)
        SetEntityInvincible(Object, true)
        if not v['Visible'] then
            SetEntityVisible(Object, false)
        end
        table.insert(PoliceProps, Object)
    end
end

function DeSpawnPoliceProps()
    for k, v in pairs(PoliceProps) do
        DeleteEntity(v)
        DeleteObject(v)
    end
    PoliceProps = {}
end

function GetEscortStatus()
    return Config.IsEscorted
end

function IsTargetDead(ServerId)
    local IsDead = false
    LSCore.Functions.TriggerCallback('ls-police:server:is:player:dead', function(result)
      IsDead = result
    end, ServerId)
    Citizen.Wait(100)
    return IsDead
end

function IsWeaponSilent(Weapon)
	local IsSilent = false
	for k, v in pairs(Config.SilentWeapons) do
	    if GetHashKey(v) == Weapon then		
	    	IsSilent = true
	    end
	end
    return IsSilent
end

function GetWeaponCategory(Weapon)
	local WeaponCategory = 'Onbekend'
	local WeaponGroupHash = GetWeapontypeGroup(Weapon)
	if Config.WeaponHashGroup[WeaponGroupHash] ~= nil then 
		WeaponCategory = Config.WeaponHashGroup[WeaponGroupHash]['name']
	end
	return WeaponCategory
end

function DropBulletCasing(Weapon)
    local RandomX = math.random() + math.random(-1, 1)
    local RandomY = math.random() + math.random(-1, 1)
    local Coords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), RandomX, RandomY, 0)
    TriggerServerEvent("ls-police:server:create:bullet", Weapon, Coords)
end

function CreateDutyBlips(PlayerId, PlayerLabel, PlayerJob)
	local PlayerPed = GetPlayerPed(PlayerId)
    local DutyBlip = GetBlipFromEntity(PlayerPed)
	if not DoesBlipExist(DutyBlip) then
		DutyBlip = AddBlipForEntity(PlayerPed)
		SetBlipSprite(DutyBlip, 480)
        SetBlipScale(DutyBlip, 1.0)
        if PlayerJob == "police" then
            SetBlipColour(DutyBlip, 38)
        else
            SetBlipColour(DutyBlip, 35)
        end
        SetBlipAsShortRange(DutyBlip, true)
        SetBlipCategory(DutyBlip, 7)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(PlayerLabel)
        EndTextCommandSetBlipName(DutyBlip)
		table.insert(DutyBlips, DutyBlip)
	end
end