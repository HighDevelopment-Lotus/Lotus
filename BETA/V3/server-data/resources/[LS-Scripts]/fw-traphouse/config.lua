Config = Config or {}

Config.MinZOffset = 40
Config.TakeoverPrice = 5000
Config.Timer = 60
Config.TrapHouses = {
    [1] = {
        coords = {
            ["enter"] = vector3(-1202.13, -1308.48, 4.91),
            ["interaction"] = vector3(-1207.42, -1311.83, -27.00),
            -- ["enter"] = {x = -1202.13, y = -1308.48, z = 4.91, h = 131.86, r = 1.0},
            -- ["interaction"] = {x = -1207.42, y = -1311.83, z = -27.00, h = 264.5, r = 1.0}, 
        },
        keyholders = {},
        pincode = 1234,
        inventory = {},
        opened = false,
        takingover = false,
        money = 0,
    }
}


Config.CraftingItems = {
    [1] = {
        ['Label'] = 'Extended Mag',
        ['ItemName'] = 'pistol_extendedclip',
        ['Slot'] = 1,
        ['Amount'] = 10,
        ['Info'] = '',
        ['Weight'] = 2000,
        ['Image'] = 'pistol_extendedclip.png',
        ['AddingPoints'] = 1,
        ['PointsNeeded'] = 100,
        ['Cost'] = {
            [1] = {
                ['Label'] = 'Staal',
                ['ItemName'] = 'steel',
                ['Image'] = 'steel.png',
                ['Amount'] = 200,
            },
            [2] = {
                ['Label'] = 'Ijzer',
                ['ItemName'] = 'iron',
                ['Image'] = 'ironplate.png',
                ['Amount'] = 150,
            },
            [3] = {
                ['Label'] = 'Aluminium',
                ['ItemName'] = 'aluminum',
                ['Image'] = 'aluminum.png',
                ['Amount'] = 150,
            },
        },
    },
    [2] = {
        ['Label'] = 'Silencer',
        ['ItemName'] = 'pistol_suppressor',
        ['Slot'] = 2,
        ['Amount'] = 2,
        ['Info'] = '',
        ['Weight'] = 2000,
        ['Image'] = 'pistol_suppressor.png',
        ['AddingPoints'] = 1,
        ['PointsNeeded'] = 50,
        ['Cost'] = {
            [1] = {
                ['Label'] = 'Staal',
                ['ItemName'] = 'steel',
                ['Image'] = 'steel.png',
                ['Amount'] = 200,
            },
            [2] = {
                ['Label'] = 'Rubber',
                ['ItemName'] = 'rubber',
                ['Image'] = 'rubber.png',
                ['Amount'] = 100,
            },
            [3] = {
                ['Label'] = 'Aluminium',
                ['ItemName'] = 'aluminum',
                ['Image'] = 'aluminum.png',
                ['Amount'] = 250,
            },
        },
    },
    [3] = {
        ['Label'] = 'Bank Doos Sleutel',
        ['ItemName'] = 'bank-box-key',
        ['Slot'] = 3,
        ['Amount'] = 6,
        ['Info'] = '',
        ['Weight'] = 2000,
        ['Image'] = 'bankbox-key.png',
        ['AddingPoints'] = 1,
        ['PointsNeeded'] = 150,
        ['Cost'] = {
            [1] = {
                ['Label'] = 'Kopererts',
                ['ItemName'] = 'copper-ore',
                ['Image'] = 'copper-ore.png',
                ['Amount'] = 50,
            },
            [2] = {
                ['Label'] = 'Rubber',
                ['ItemName'] = 'rubber',
                ['Image'] = 'rubber.png',
                ['Amount'] = 20,
            },
            [3] = {
                ['Label'] = 'Metaalschroot',
                ['ItemName'] = 'metalscrap',
                ['Image'] = 'metalscrap.png',
                ['Amount'] = 100,
            },
        },
    },
}