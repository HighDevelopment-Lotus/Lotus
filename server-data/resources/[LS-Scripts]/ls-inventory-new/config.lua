Config = Config or {}

Config.Drops = {}
Config.InventorySlots = 45
Config.CanOpenInventory = true
Config.MaxInventoryWeight = 130000

Config.Dumpsters = {
    [1] = {['Model'] = 666561306,    ['Name'] = 'Blauwe Bak'},
    [2] = {['Model'] = 218085040,    ['Name'] = 'Licht Blauwe Bak'},
    [3] = {['Model'] = -58485588,    ['Name'] = 'Grijze Bak'},
    [4] = {['Model'] = 682791951,    ['Name'] = 'Grote Blauwe Bak'},
    [5] = {['Model'] = -206690185,   ['Name'] = 'Grote Groene Bak'},
    [6] = {['Model'] = 364445978,    ['Name'] = 'Grote Groene Bak'},
    [7] = {['Model'] = 143369,       ['Name'] = 'Kleine Bak'},
    [8] = {['Model'] = -2140438327,  ['Name'] = 'Unknow Bak'},
    [9] = {['Model'] = -1851120826,  ['Name'] = 'Unknow Bak'},
    [10] = {['Model'] = -1543452585, ['Name'] = 'Unknow Bak'},
    [11] = {['Model'] = -1207701511, ['Name'] = 'Unknow Bak'},
    [12] = {['Model'] = -918089089,  ['Name'] = 'Unknow Bak'},
    [13] = {['Model'] = 1511880420,  ['Name'] = 'Unknow Bak'},
    [14] = {['Model'] = 1329570871,  ['Name'] = 'Unknow Bak'},
    [15] = {['Model'] = 650320113,   ['Name'] = 'Mine Barrel'},
}

Config.JailContainers = {
    [1] = {['Model'] = 1923262137, ['Name'] = 'Elektrische Kast 1'},
    [2] = {['Model'] = -686494084, ['Name'] = 'Elektrische Kast 2'},
    [3] = {['Model'] = 1419852836, ['Name'] = 'Elektrische Kast 3'},
}

Config.TrunkClasses = {
    [0] = {['MaxWeight'] = 35000,   ['MaxSlots'] = 15},
    [1] = {['MaxWeight'] = 50000,   ['MaxSlots'] = 25},
    [2] = {['MaxWeight'] = 100000,  ['MaxSlots'] = 25},
    [3] = {['MaxWeight'] = 50000,   ['MaxSlots'] = 25},
    [4] = {['MaxWeight'] = 40000,   ['MaxSlots'] = 25},
    [5] = {['MaxWeight'] = 40000,   ['MaxSlots'] = 15},
    [6] = {['MaxWeight'] = 40000,   ['MaxSlots'] = 15},
    [7] = {['MaxWeight'] = 15000,   ['MaxSlots'] = 5},
    [9] = {['MaxWeight'] = 25000,   ['MaxSlots'] = 25},
    [10] = {['MaxWeight'] = 400000, ['MaxSlots'] = 35},
    [11] = {['MaxWeight'] = 400000, ['MaxSlots'] = 35},
    [12] = {['MaxWeight'] = 400000, ['MaxSlots'] = 35},
    [14] = {['MaxWeight'] = 10000,  ['MaxSlots'] = 10},
    [15] = {['MaxWeight'] = 10000,  ['MaxSlots'] = 10},
    [17] = {['MaxWeight'] = 40000,  ['MaxSlots'] = 20},
    [18] = {['MaxWeight'] = 60000,  ['MaxSlots'] = 20},
    [19] = {['MaxWeight'] = 160000, ['MaxSlots'] = 25},
    [20] = {['MaxWeight'] = 160000, ['MaxSlots'] = 25},
}

Config.Attachments = {
    ['pistol_extendedclip'] = {
        ['weapon_vintagepistol'] = 'COMPONENT_VINTAGEPISTOL_CLIP_02',
        ['weapon_pistol'] = 'COMPONENT_PISTOL_CLIP_02',
        ['weapon_combatpistol'] = 'COMPONENT_COMBATPISTOL_CLIP_02',
        ['weapon_browning'] = 'COMPONENT_BROWNING_CLIP_02',
    },
    ['smg_extendedclip'] = {
        ['weapon_appistol'] = 'COMPONENT_APPISTOL_CLIP_02',
        ['weapon_machinepistol'] = 'COMPONENT_MACHINEPISTOL_CLIP_02',
        ['weapon_microsmg'] = 'COMPONENT_MICROSMG_CLIP_02',
    },
    ['pistol_suppressor'] = {}, -- Gebruiken we niet meer. Maar als het ooit nodig is..
}