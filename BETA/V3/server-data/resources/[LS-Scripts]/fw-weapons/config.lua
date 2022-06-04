Config = Config or {}

Config.HideReticle = true

Config.CurrentWeaponData = nil

Config.DurabilityBlockedWeapons = {"weapon_unarmed", "weapon_molotov", "weapon_brick", "weapon_flare", "weapon_smokegrenade", "weapon_shoe"}
Config.DurabilityMultiplier = {['weapon_m4'] = 0.17, ['weapon_stungun'] = 0.17, ['weapon_assaultrifle'] = 0.17, ['weapon_heavypistol'] = 0.17,  ['weapon_gusenberg'] = 0.17, ['weapon_pistol_mk2'] = 0.17, ['weapon_snspistol_mk2'] = 0.17 , ['weapon_nightstick'] = 0.5, ['weapon_flashlight'] = 0.5, ['weapon_switchblade'] = 0.5, ['weapon_wrench'] = 0.5, ['weapon_hatchet'] = 0.5, ['weapon_machete'] = 0.5, ['weapon_knife'] = 0.5, ['weapon_hammer'] = 0.5, ['weapon_sledgeham'] = 0.5, ['weapon_sawnoffshotgun'] = 0.17, ['weapon_appistol'] = 0.17, ['weapon_machinepistol'] = 0.17, ['weapon_vintagepistol'] = 0.17, ['weapon_combatpistol'] = 0.17, ['weapon_sniperrifle2'] = 0.10, ['weapon_microsmg'] = 0.17, ['weapon_pistol'] = 0.17, ['weapon_katana'] = 0.10, ['weapon_unicorn'] = 0.10, ['weapon_crutch'] = 0.10, ['weapon_snspistol'] = 0.10, ['weapon_ceramicpistol'] = 0.17, ['weapon_browning'] = 0.17, ['weapon_microsmg2'] = 0.17, ['weapon_microsmg3'] = 0.17, ['weapon_assaultrifle2'] = 0.17}  

Config.WeaponsList = {
    -- // Unarmed \\ --
    [GetHashKey('weapon_unarmed')]     = {['Name'] = 'Hands',       ['IdName'] = 'weapon_unarmed',     ['AmmoType'] = nil,          ['MaxAmmo'] = nil, ['Wait'] = math.random(4000, 6000), ['Recoil'] = nil},
    [GetHashKey('weapon_nightstick')]  = {['Name'] = 'Baton',       ['IdName'] = 'weapon_nightstick',  ['AmmoType'] = 'AMMO_MELEE', ['MaxAmmo'] = nil, ['Wait'] = math.random(4000, 6000), ['Recoil'] = nil},
    [GetHashKey('weapon_flashlight')]  = {['Name'] = 'Zaklamp',     ['IdName'] = 'weapon_flashlight',  ['AmmoType'] = 'AMMO_MELEE', ['MaxAmmo'] = nil, ['Wait'] = math.random(4000, 6000), ['Recoil'] = nil},
    [GetHashKey('weapon_hatchet')]     = {['Name'] = 'Hakbijl',     ['IdName'] = 'weapon_hatchet',     ['AmmoType'] = 'AMMO_MELEE', ['MaxAmmo'] = nil, ['Wait'] = math.random(4000, 6000), ['Recoil'] = nil},
    [GetHashKey('weapon_switchblade')] = {['Name'] = 'Klapmes',     ['IdName'] = 'weapon_switchblade', ['AmmoType'] = 'AMMO_MELEE', ['MaxAmmo'] = nil, ['Wait'] = math.random(4000, 6000), ['Recoil'] = nil},
    [GetHashKey('weapon_knife')]       = {['Name'] = 'Keuken Mes',  ['IdName'] = 'weapon_knife',       ['AmmoType'] = 'AMMO_MELEE', ['MaxAmmo'] = nil, ['Wait'] = math.random(4000, 6000), ['Recoil'] = nil},
    [GetHashKey('weapon_hammer')]      = {['Name'] = 'Hammer',      ['IdName'] = 'weapon_hammer',      ['AmmoType'] = 'AMMO_MELEE', ['MaxAmmo'] = nil, ['Wait'] = math.random(4000, 6000), ['Recoil'] = nil},
    [GetHashKey('weapon_machete')]     = {['Name'] = 'Machete',     ['IdName'] = 'weapon_machete',     ['AmmoType'] = 'AMMO_MELEE', ['MaxAmmo'] = nil, ['Wait'] = math.random(4000, 6000), ['Recoil'] = nil},
    [GetHashKey('weapon_wrench')]      = {['Name'] = 'Moersleutel', ['IdName'] = 'weapon_wrench',      ['AmmoType'] = 'AMMO_MELEE', ['MaxAmmo'] = nil, ['Wait'] = math.random(4000, 6000), ['Recoil'] = nil},
    [GetHashKey('weapon_sledgeham')]   = {['Name'] = 'Sledgehammer',['IdName'] = 'weapon_sledgeham',   ['AmmoType'] = 'AMMO_MELEE', ['MaxAmmo'] = nil, ['Wait'] = math.random(4000, 6000), ['Recoil'] = nil},
    [GetHashKey('weapon_katana')]      = {['Name'] = 'Katana',      ['IdName'] = 'weapon_katana',      ['AmmoType'] = 'AMMO_MELEE', ['MaxAmmo'] = nil, ['Wait'] = math.random(4000, 6000), ['Recoil'] = nil},
    [GetHashKey('weapon_unicorn')]     = {['Name'] = 'Unicorn',     ['IdName'] = 'weapon_unicorn',     ['AmmoType'] = 'AMMO_MELEE', ['MaxAmmo'] = nil, ['Wait'] = math.random(4000, 6000), ['Recoil'] = nil},
    [GetHashKey('weapon_crutch')]      = {['Name'] = 'Kruk',        ['IdName'] = 'weapon_crutch',      ['AmmoType'] = 'AMMO_MELEE', ['MaxAmmo'] = nil, ['Wait'] = math.random(4000, 6000), ['Recoil'] = nil},
    [GetHashKey('weapon_brick')]       = {['Name'] = 'Steen',       ['IdName'] = 'weapon_brick',       ['AmmoType'] = 'AMMO_FIRE',  ['MaxAmmo'] = nil, ['Recoil'] = nil},
    [GetHashKey('weapon_shoe')]        = {['Name'] = 'Schoen',      ['IdName'] = 'weapon_shoe',        ['AmmoType'] = 'AMMO_FIRE',  ['MaxAmmo'] = nil, ['Recoil'] = nil},
    [GetHashKey('weapon_molotov')]     = {['Name'] = 'Molotov Cocktail', ['IdName'] = 'weapon_molotov', ['AmmoType'] = 'AMMO_FIRE', ['MaxAmmo'] = nil, ['Recoil'] = nil},
    [GetHashKey('weapon_flare')]       = {['Name'] = 'Flare',       ['IdName'] = 'weapon_flare',        ['AmmoType'] = 'AMMO_FIRE', ['MaxAmmo'] = nil, ['Recoil'] = nil},
    [GetHashKey('weapon_smokegrenade')] = {['Name'] = 'Rook Bom',   ['IdName'] = 'weapon_smokegrenade', ['AmmoType'] = 'AMMO_FIRE', ['MaxAmmo'] = nil, ['Recoil'] = nil},
    -- // Pistols \\ --
    [GetHashKey('weapon_stungun')]        = {['Name'] = 'Stun Gun',           ['IdName'] = 'weapon_stungun',         ['AmmoType'] = 'AMMO_TAZER',  ['MaxAmmo'] = 1, ['Wait'] = math.random(15000, 20000), ['Recoil'] = 2.5},
    [GetHashKey('weapon_snspistol_mk2')]  = {['Name'] = 'Sns Pistool',        ['IdName'] = 'weapon_snspistol_mk2',   ['AmmoType'] = 'AMMO_PISTOL', ['MaxAmmo'] = 25, ['Wait'] = math.random(4000, 6000), ['Recoil'] = 2.5},
    [GetHashKey('weapon_snspistol')]      = {['Name'] = 'Paintball',          ['IdName'] = 'weapon_snspistol',       ['AmmoType'] = 'AMMO_PAINTBALL', ['MaxAmmo'] = 35, ['Wait'] = math.random(4000, 6000), ['Recoil'] = 2.5},
    [GetHashKey('weapon_pistol')]         = {['Name'] = 'Colt M1911',         ['IdName'] = 'weapon_pistol',          ['AmmoType'] = 'AMMO_PISTOL', ['MaxAmmo'] = 25, ['Wait'] = math.random(4000, 6000), ['Recoil'] = 2.5},
    [GetHashKey('weapon_pistol_mk2')]     = {['Name'] = 'Walther P99Q',       ['IdName'] = 'weapon_pistol_mk2',      ['AmmoType'] = 'AMMO_PISTOL', ['MaxAmmo'] = 25, ['Wait'] = math.random(4000, 6000), ['Recoil'] = 2.5},
    [GetHashKey('weapon_heavypistol')]    = {['Name'] = 'Heavy Pistool',      ['IdName'] = 'weapon_heavypistol',     ['AmmoType'] = 'AMMO_PISTOL', ['MaxAmmo'] = 25, ['Wait'] = math.random(4000, 6000), ['Recoil'] = 2.5},
    [GetHashKey('weapon_vintagepistol')]  = {['Name'] = 'Klasiek Pistool',    ['IdName'] = 'weapon_vintagepistol',   ['AmmoType'] = 'AMMO_PISTOL', ['MaxAmmo'] = 25, ['Wait'] = math.random(4000, 6000), ['Recoil'] = 2.5},
    [GetHashKey('weapon_combatpistol')]   = {['Name'] = 'Beretta',            ['IdName'] = 'weapon_combatpistol',    ['AmmoType'] = 'AMMO_PISTOL', ['MaxAmmo'] = 25, ['Wait'] = math.random(4000, 6000), ['Recoil'] = 2.5},
    [GetHashKey('weapon_browning')]       = {['Name'] = 'Browning Pistool',   ['IdName'] = 'weapon_browning',        ['AmmoType'] = 'AMMO_PISTOL', ['MaxAmmo'] = 25, ['Wait'] = math.random(4000, 6000), ['Recoil'] = 2.5},
    [GetHashKey('weapon_ceramicpistol')]  = {['Name'] = 'Keramisch Pistool',  ['IdName'] = 'weapon_ceramicpistol',   ['AmmoType'] = 'AMMO_PISTOL', ['MaxAmmo'] = 25, ['Wait'] = math.random(4000, 6000), ['Recoil'] = 2.5},
    [GetHashKey('weapon_navyrevolver')]   = {['Name'] = 'Navy Revolver',      ['IdName'] = 'weapon_navyrevolver',    ['AmmoType'] = 'AMMO_PISTOL', ['MaxAmmo'] = 25, ['Wait'] = math.random(4000, 6000), ['Recoil'] = 2.5},
    -- // SMG Pistols \\ --
    [GetHashKey('weapon_machinepistol')]  = {['Name'] = 'Machine Pistool',   ['IdName'] = 'weapon_machinepistol', ['AmmoType'] = 'AMMO_PISTOL', ['MaxAmmo'] = 60, ['Wait'] = math.random(4000, 6000), ['Recoil'] = 3.5},
    [GetHashKey('weapon_appistol')]       = {['Name'] = 'AP Pistool',        ['IdName'] = 'weapon_appistol',      ['AmmoType'] = 'AMMO_PISTOL', ['MaxAmmo'] = 60, ['Wait'] = math.random(4000, 6000), ['Recoil'] = 3.5},
    [GetHashKey('weapon_microsmg')]       = {['Name'] = 'Micro SMG',         ['IdName'] = 'weapon_microsmg',      ['AmmoType'] = 'AMMO_SMG',    ['MaxAmmo'] = 60, ['Wait'] = math.random(4000, 6000), ['Recoil'] = 3.5},
    [GetHashKey('weapon_microsmg2')]      = {['Name'] = 'Uzi',               ['IdName'] = 'weapon_microsmg2',     ['AmmoType'] = 'AMMO_SMG',    ['MaxAmmo'] = 60, ['Wait'] = math.random(4000, 6000), ['Recoil'] = 3.5},
    [GetHashKey('weapon_microsmg3')]      = {['Name'] = 'Mac-10',            ['IdName'] = 'weapon_microsmg3',     ['AmmoType'] = 'AMMO_SMG',    ['MaxAmmo'] = 60, ['Wait'] = math.random(4000, 6000), ['Recoil'] = 3.5},
    [GetHashKey('weapon_gusenberg')]      = {['Name'] = 'Tommy Gun',         ['IdName'] = 'weapon_gusenberg',     ['AmmoType'] = 'AMMO_RIFLE', ['MaxAmmo'] = 60, ['Wait'] = math.random(4000, 6000), ['Recoil'] = 3.5},
    -- Shotgun --
    [GetHashKey('weapon_sawnoffshotgun')]  = {['Name'] = 'Korte Shotgun',   ['IdName'] = 'weapon_sawnoffshotgun', ['AmmoType'] = 'AMMO_SHOTGUN', ['MaxAmmo'] = 16, ['Wait'] = math.random(4000, 6000), ['Recoil'] = 0.35},
    -- // Rifles \\ --
    [GetHashKey('weapon_m4')]                = {['Name'] = 'M4',              ['IdName'] = 'weapon_m4',               ['AmmoType'] = 'AMMO_RIFLE', ['MaxAmmo'] = 60, ['Wait'] = math.random(4000, 6000), ['Recoil'] = 0.15},
    [GetHashKey('weapon_assaultrifle')]      = {['Name'] = 'Ak74',            ['IdName'] = 'weapon_assaultrifle',     ['AmmoType'] = 'AMMO_RIFLE', ['MaxAmmo'] = 60, ['Wait'] = math.random(4000, 6000), ['Recoil'] = 0.15},
    [GetHashKey('weapon_assaultrifle2')]     = {['Name'] = 'M70',             ['IdName'] = 'weapon_assaultrifle2',    ['AmmoType'] = 'AMMO_RIFLE', ['MaxAmmo'] = 60, ['Wait'] = math.random(4000, 6000), ['Recoil'] = 0.15},
    [GetHashKey('weapon_sniperrifle2')]      = {['Name'] = 'Jaag Geweer',     ['IdName'] = 'weapon_sniperrifle2',     ['AmmoType'] = 'AMMO_RIFLE', ['MaxAmmo'] = 20, ['Wait'] = math.random(4000, 6000), ['Recoil'] = 0.15},
    -- Stickys
    -- [GetHashKey('weapon_stickybomb')]                = {['Name'] = 'Stickybomb',              ['IdName'] = 'weapon_stickybomb',               ['AmmoType'] = 'AMMO_STICKYBOMB', ['MaxAmmo'] = 1, ['Wait'] = math.random(4000, 6000), ['Recoil'] = 0.0},
}