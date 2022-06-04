Config = Config or {}

Config.Evidence, Config.PoliceObjects = {}, {}

Config.IsHandCuffed, Config.IsEscorted = false, false

Config.Keys = {["E"] = 38, ["T"] = 245, ["V"] = 0, ["ESC"] = 322, ["F1"] = 288, ["HOME"] = 213}

Config.IsDeath = false
Config.IsInBed = false
Config.Timer = 300

Config.RespawnPrice = 500

Config.OnOxy = false

Config.BedPayment = 50

Config.MaxBodyPartHealth = 5

Config.CurrentPain = {}

Config.DoorsLocked = true

Config.Locations = {
  ["CheckIn"] = vector3(-817.327, -1236.54, 7.3374285),
  ['Shop'] = vector3(-805.1927, -1212.575, 7.3374271),
  ['Storage'] = vector3(-820.214, -1242.936, 7.3374285),
  ['Teleporters'] = {
    ['ToHeli'] = {['X'] = 331.99, ['Y'] = -595.62, ['Z'] = 43.28},
    ['ToHospitalFirst'] = {['X'] = 339.06, ['Y'] = -583.92, ['Z'] = 74.16},
    ['ToHospitalSecond'] = {['X'] = 329.98, ['Y'] = -601.08, ['Z'] = 43.28},
    ['ToLower'] = {['X'] = 344.84, ['Y'] = -586.30, ['Z'] = 28.79},
  },
  ['Prison'] = {
    ['Coords'] = {['X'] = 1693.33, ['Y'] = 2569.51, ['Z'] = 45.55, ['H'] = nil},
  },
  ['Leave'] = {
     ['Coords'] = {['X'] = 1832.01, ['Y'] = 2580.4, ['Z'] = 46.01, ['H'] = nil},
  },
  -- ['Shop'] = {
  --    ['Coords'] = {['X'] = 1642.85, ['Y'] = 2522.28, ['Z'] = 45.56, ['H'] = nil},
  -- },
  ['Garages'] = {
    [1] = {
      ['Coords'] = vector3(-817.6165, -1209.7, 6.9341173),
      ['Spawns'] = {
          [1] = {
             ['Coords'] = vector4(-817.1804, -1201.468, 6.934123, 138.29612)
          },
          [2] = {
             ['Coords'] = vector4(-822.2924, -1197.409, 6.8243036, 140.19825)
          },
      },
    },
    [2] = {
      ['Coords'] = vector3(352.17, -587.87, 74.16),
      ['Spawns'] = nil
    },
  },
  ['Search'] = {
    [1] = {
        ['Reward'] = 'slushy',
        ['Chance'] = 50,
        ['Coords'] = {['X'] = 1778.82, ['Y'] = 2557.64, ['Z'] = 45.67, ['H'] = nil},
    },
    [2] = {
        ['Reward'] = 'ass-lockpick',
        ['Chance'] = 2,
        ['Coords'] = {['X'] = 1778.10, ['Y'] = 2565.23, ['Z'] = 45.67, ['H'] = nil},
    },
    [3] = {
        ['Reward'] = 'ass-phone',
        ['Chance'] = 2,
        ['Coords'] = {['X'] = 1678.08, ['Y'] = 2480.92, ['Z'] = 45.56, ['H'] = nil},
    },
    [4] = {
        ['Reward'] = 'jail-food',
        ['Chance'] = 10,
        ['Coords'] = {['X'] = 1585.8, ['Y'] = 2514.51, ['Z'] = 45.56, ['H'] = nil},
    },

 },
 ['Spawns'] = {
     [1] = {
         ['Animation'] = "bumsleep",
         ['Coords'] = {['X'] = 1661.046, ['Y'] = 2524.681, ['Z'] = 45.564, ['H'] = 260.545},
     },
     [2] = {
         ['Animation'] = "lean",
         ['Coords'] = {['X'] = 1650.812, ['Y'] = 2540.582, ['Z'] = 45.564, ['H'] = 230.436},
     },
     [3] = {
         ['Animation'] = "lean",
         ['Coords'] = {['X'] = 1654.959, ['Y'] = 2545.535, ['Z'] = 45.564, ['H'] = 230.436},
     },
     [4] = {
         ['Animation'] = "lean",
         ['Coords'] = {['X'] = 1697.106, ['Y'] = 2525.558, ['Z'] = 45.564, ['H'] = 187.208},
     },
     [5] = {
         ['Animation'] = "chair4",
         ['Coords'] = {['X'] = 1673.084, ['Y'] = 2519.823, ['Z'] = 45.564, ['H'] = 229.542},
     },
     [6] = {
         ['Animation'] = "chair",
         ['Coords'] = {['X'] = 1666.029, ['Y'] = 2511.367, ['Z'] = 45.564, ['H'] = 233.888},
     },
     [7] = {
         ['Animation'] = "chair4",
         ['Coords'] = {['X'] = 1691.229, ['Y'] = 2509.635, ['Z'] = 45.564, ['H'] = 52.432},
     },
     [8] = {
         ['Animation'] = "finger2",
         ['Coords'] = {['X'] = 1770.59, ['Y'] = 2536.064, ['Z'] = 45.564, ['H'] = 258.113},
     },
     [9] = {
         ['Animation'] = "smoke",
         ['Coords'] = {['X'] = 1751.05, ['Y'] = 2564.37, ['Z'] = 45.56, ['H'] = 225.14},
     },
  },
  ['Leave-Spawn'] = {
    [1] = {
        ['Animation'] = "chair",
        ['Coords'] = {['X'] = 1841.04, ['Y'] = 2583.25, ['Z'] = 46.00, ['H'] = 0.0},
    },
    [2] = {
        ['Animation'] = "chair",
        ['Coords'] = {['X'] = 1841.08, ['Y'] = 2581.74, ['Z'] = 46.01, ['H'] = 174.142},
    },
    [3] = {
        ['Animation'] = "chair",
        ['Coords'] = {['X'] = 1841.03, ['Y'] = 2588.94, ['Z'] = 45.99, ['H'] = 0.0},
    },
  }
}

Config.Items = {
  [1] = {
    name = "weapon_molotov",
    price = 7500,
    amount = 1,
    info = {},
    type = "item",
    slot = 1,
  },
}

Config.BodyHealth = {
  ['HEAD'] =       {['Name'] = 'hoofd',         ['Health'] = 4, ['Pain'] = false, ['IsDead'] = false, ['CanDie'] = false},
  ['NECK'] =       {['Name'] = 'nek',           ['Health'] = 4, ['Pain'] = false, ['IsDead'] = false, ['CanDie'] = false},
  ['LOWER_BODY'] = {['Name'] = 'onder lichaam', ['Health'] = 4, ['Pain'] = false, ['IsDead'] = false, ['CanDie'] = false},
  ['UPPER_BODY'] = {['Name'] = 'boven lichaam', ['Health'] = 4, ['Pain'] = false, ['IsDead'] = false, ['CanDie'] = false},
  ['SPINE'] =      {['Name'] = 'rug',           ['Health'] = 4, ['Pain'] = false, ['IsDead'] = false, ['CanDie'] = false},
  ['LARM'] =       {['Name'] = 'linker arm',    ['Health'] = 4, ['Pain'] = false, ['IsDead'] = false, ['CanDie'] = true},
  ['RARM'] =       {['Name'] = 'rechter arm',   ['Health'] = 4, ['Pain'] = false, ['IsDead'] = false, ['CanDie'] = true},
  ['LHAND'] =      {['Name'] = 'linker hand',   ['Health'] = 4, ['Pain'] = false, ['IsDead'] = false, ['CanDie'] = false},
  ['RHAND'] =      {['Name'] = 'rechter hand',  ['Health'] = 4, ['Pain'] = false, ['IsDead'] = false, ['CanDie'] = false},
  ['LLEG'] =       {['Name'] = 'linker been',   ['Health'] = 4, ['Pain'] = false, ['IsDead'] = false, ['CanDie'] = true},
  ['RLEG'] =       {['Name'] = 'rechter been',  ['Health'] = 4, ['Pain'] = false, ['IsDead'] = false, ['CanDie'] = true},
  ['LFOOT'] =      {['Name'] = 'linker voet',   ['Health'] = 4, ['Pain'] = false, ['IsDead'] = false, ['CanDie'] = true},
  ['RFOOT'] =      {['Name'] = 'rechter voet',  ['Health'] = 4, ['Pain'] = false, ['IsDead'] = false, ['CanDie'] = true},
 }
 
 Config.Beds = {
   [1] = {['X'] = -809.5229, ['Y'] = -1226.749, ['Z'] = 6.895049, ['H'] = 139.99, ['Busy'] = false, ['Hash'] = 1631638868},
   [2] = {['X'] = -806.7446, ['Y'] = -1229.08, ['Z'] = 6.895049, ['H'] = 139.99, ['Busy'] = false, ['Hash'] = 1631638868},
   [3] = {['X'] = -804.1318, ['Y'] = -1231.273, ['Z'] = 6.895049, ['H'] = 139.99, ['Busy'] = false, ['Hash'] = 1631638868},
   [4] = {['X'] = -805.484, ['Y'] = -1224.05, ['Z'] = 6.895049, ['H'] = 320.0, ['Busy'] = false, ['Hash'] = 1631638868},
   [5] = {['X'] = -801.0148, ['Y'] = -1227.8, ['Z'] = 6.895049, ['H'] = 320.0, ['Busy'] = false, ['Hash'] = 1631638868},
 }
 
 Config.BodyParts = {
   [0]     = 'NONE',
   [31085] = 'HEAD',
   [31086] = 'HEAD',
   [39317] = 'NECK',
   [57597] = 'SPINE',
   [23553] = 'SPINE',
   [24816] = 'SPINE',
   [24817] = 'SPINE',
   [24818] = 'SPINE',
   [10706] = 'UPPER_BODY',
   [64729] = 'UPPER_BODY',
   [11816] = 'LOWER_BODY',
   [45509] = 'LARM',
   [61163] = 'LARM',
   [18905] = 'LHAND',
   [4089] = 'LFINGER',
   [4090] = 'LFINGER',
   [4137] = 'LFINGER',
   [4138] = 'LFINGER',
   [4153] = 'LFINGER',
   [4154] = 'LFINGER',
   [4169] = 'LFINGER',
   [4170] = 'LFINGER',
   [4185] = 'LFINGER',
   [4186] = 'LFINGER',
   [26610] = 'LFINGER',
   [26611] = 'LFINGER',
   [26612] = 'LFINGER',
   [26613] = 'LFINGER',
   [26614] = 'LFINGER',
   [58271] = 'LLEG',
   [63931] = 'LLEG',
   [2108] = 'LFOOT',
   [14201] = 'LFOOT',
   [40269] = 'RARM',
   [28252] = 'RARM',
   [57005] = 'RHAND',
   [58866] = 'RFINGER',
   [58867] = 'RFINGER',
   [58868] = 'RFINGER',
   [58869] = 'RFINGER',
   [58870] = 'RFINGER',
   [64016] = 'RFINGER',
   [64017] = 'RFINGER',
   [64064] = 'RFINGER',
   [64065] = 'RFINGER',
   [64080] = 'RFINGER',
   [64081] = 'RFINGER',
   [64096] = 'RFINGER',
   [64097] = 'RFINGER',
   [64112] = 'RFINGER',
   [64113] = 'RFINGER',
   [36864] = 'RLEG',
   [51826] = 'RLEG',
   [20781] = 'RFOOT',
   [52301] = 'RFOOT',
 }
 
 Config.HospitalItems = {
   ['Items'] = {
     [1] = {
         name = "radio",
         price = 0,
         amount = 1,
         info = {},
         type = "item",
         slot = 1,
     },
     [2] = {
         name = "bandage",
         price = 0,
         amount = 15,
         info = {},
         type = "item",
         slot = 2,
     },
     [3] = {
         name = "painkillers",
         price = 0,
         amount = 15,
         info = {},
         type = "item",
         slot = 3,
     },
     [4] = {
         name = "weapon_flashlight",
         price = 0,
         amount = 1,
         info = {
           quality = 100.0,
         },
         type = "item",
         slot = 4,
     },
     [5] = {
         name = "weapon_fireextinguisher",
         price = 0,
         amount = 1,
         info = {
           quality = 100.0,
         },
         type = "item",
         slot = 5,
     },
     [6] = {
         name = "wheelchair",
         price = 0,
         amount = 1,
         info = {},
         type = "item",
         slot = 6,
     },
     [7] = {
         name = "walkstick",
         price = 0,
         amount = 1,
         info = {},
         type = "item",
         slot = 7,
     },
     [8] = {
         name = "scuba-gear",
         price = 0,
         amount = 1,
         info = {
           air = 100.0,
         },
         type = "item",
         slot = 8,
     },
     [9] = {
         name = "xray-brain",
         price = 0,
         amount = 1,
         info = {},
         type = "item",
         slot = 9,
     },
     [10] = {
         name = "xray-arm",
         price = 0,
         amount = 1,
         info = {},
         type = "item",
         slot = 10,
     },
     [11] = {
         name = "teddy",
         price = 0,
         amount = 1,
         info = {},
         type = "item",
         slot = 11,
     },
     [12] = {
         name = "weapon_crutch",
         price = 100,
         amount = 1,
         info = {
           quality = 100.0
         },
         type = "weapon",
         slot = 12,
     },
   }
 }
 -- Police
Config.PoliceLocations = {
  ['FingerPrint'] = {
    [1] = {['Coords'] = vector3(473.19, -1007.45, 26.27)},
    [2] = {['Coords'] = vector3(-433.31, 5991.84, 31.71)},
    [3] = {['Coords'] = vector3(-1081.31, -835.77, 13.52)},
  },
  ['Locker'] = {
    [1] = {['Coords'] = vector3(479.23, -996.72, 30.69)},
    [2] = {['Coords'] = vector3(-429.49, 5995.05, 31.71)},
    [3] = {['Coords'] = vector3(-1080.06, -823.09, 19.29)},
  },
  ['PoliceSafe'] = {
    [1] = {['Coords'] = vector3(482.63, -995.21, 30.68)},
    [2] = {['Coords'] = vector3(-425.06, 5997.73, 31.71)},
    [3] = {['Coords'] = vector3(-1074.83, -831.08, 19.29)},
  },
  ['Evidence'] = {
    [1] = {['Coords'] = vector3(474.79, -996.17, 26.27)},
  },
  ['Delete'] = {
    [1] = {['Coords'] = vector3(435.24, -975.79, 25.69)},
  },
  ['Meeting'] = vector3(444.82, -985.64, 34.97),
}

Config.PoliceGarages = {
  ['P1'] = {
    ['Name'] = 'Mission Row',
    ['Coords'] = vector3(441.43, -997.14, 25.69),
    ['Distance'] = 4.0,
    ['Spawns'] = {
      [1] = {['Coords'] = {['X'] = 437.25, ['Y'] = -988.83, ['Z'] = 25.69, ['H'] = 91.93}},
      [2] = {['Coords'] = {['X'] = 437.35, ['Y'] = -994.28, ['Z'] = 25.69, ['H'] = 91.93}},
      [3] = {['Coords'] = {['X'] = 445.92, ['Y'] = -994.30, ['Z'] = 25.69, ['H'] = 271.48}},
      [4] = {['Coords'] = {['X'] = 445.66, ['Y'] = -986.14, ['Z'] = 25.69, ['H'] = 271.48}},
      [5] = {['Coords'] = {['X'] = 425.54, ['Y'] = -989.00, ['Z'] = 25.69, ['H'] = 269.66}},
      [6] = {['Coords'] = {['X'] = 425.61, ['Y'] = -994.39, ['Z'] = 25.69, ['H'] = 269.66}},
    },
  },
  ['P2'] = {
    ['Name'] = 'Paleto Bay',
    ['Coords'] = vector3(-445.05, 6024.46, 31.49),
    ['Distance'] = 4.0,
    ['Spawns'] = {
      [1] = {['Coords'] = {['X'] = -441.84, ['Y'] = 6026.55, ['Z'] = 31.34, ['H'] = 42.57}},
      [2] = {['Coords'] = {['X'] = -438.67, ['Y'] = 6029.05, ['Z'] = 31.34, ['H'] = 31.71}},
      [3] = {['Coords'] = {['X'] = -434.99, ['Y'] = 6031.36, ['Z'] = 31.34, ['H'] = 38.11}},
    },
  },
  ['P3'] = {
    ['Name'] = 'Heli Pad',
    ['Coords'] = vector3(449.19, -981.18, 43.69),
    ['Distance'] = 7.0,
    ['Spawns'] = {
      [1] = {['Coords'] = {['X'] = 449.24, ['Y'] = -981.26, ['Z'] = 43.69, ['H'] = 93.32}},
    },
  },
  ['P4'] = {
    ['Name'] = 'Heli Pad',
    ['Coords'] = vector3(-475.33, 5988.47, 31.33),
    ['Distance'] = 7.0,
    ['Spawns'] = {
      [1] = {['Coords'] = {['X'] = -475.33, ['Y'] = 5988.47, ['Z'] = 31.33, ['H'] = 313.55}},
    },
  },
}

Config.PoliceVehicles = {
  [1] = {['Vehicle'] = 'PolitieAmarok'},
  [2] = {['Vehicle'] = 'PolitieTouran'},
  [3] = {['Vehicle'] = 'PolitieKlasse'},
  [4] = {['Vehicle'] = 'PolitieVito'},
  [5] = {['Vehicle'] = 'PolitieAudi'},
  [6] = {['Vehicle'] = 'PolitieRS6'},
  [7] = {['Vehicle'] = 'PolitieMotor'},
  [8] = {['Vehicle'] = 'PolitieAudiUnmarked'},
  [9] = {['Vehicle'] = 'PolitieBmw'},
  [10] = {['Vehicle'] = 'PolitieVelar'},
  [11] = {['Vehicle'] = 'riot'},
  [12] = {['Vehicle'] = 'police2'},
}

Config.PoliceHelis = {
  [1] = {['Vehicle'] = 'PolitieZulu', ['Name'] = 'Politie Zulu'},
  [2] = {['Vehicle'] = 'DsiZulu', ['Name'] = 'Politie DSI Zulu'},
}

Config.AmmoLabels = {
  ["AMMO_PISTOL"] = "9x19mm Parabellum",
  ["AMMO_SMG"] = "9x19mm Parabellum",
  ["AMMO_RIFLE"] = "7.62x39mm Parabellum",
  ["AMMO_MG"] = "7.92x57mm Parabellum",
  ["AMMO_SHOTGUN"] = "12-Gauge Parabellum",
  ["AMMO_SNIPER"] = "Groot kaliber Parabellum",
  ["AMMO_PAINTBALL"] = "Paintball",
}

Config.SilentWeapons = {
  "WEAPON_UNARMED",
  "WEAPON_SNOWBALL",
  "WEAPON_PETROLCAN",
  "WEAPON_STUNGUN",
  "WEAPON_SNSPISTOL", --Paintball gun
  "WEAPON_FIREEXTINGUISHER",
}

Config.WeaponHashGroup = {
  [416676503] =   {['name'] = "Pistool"},
  [860033945] =   {['name'] = "Shotgun"},
  [970310034] =   {['name'] = "Semi-Automatisch"},
  [1159398588] =  {['name'] = "Automatisch"},
  [-1212426201] = {['name'] = "Scherpschutter"},
  [-1569042529] = {['name'] = "Zwaar"},
  [1548507267] =  {['name'] = "Granaat"},
}

Config.SecurityCams = {
  [1] = {['Coords'] = vector4(-57.32, -1752.09, 30.4, 266.79),    ['Label'] = 'Grove Street'},
  [2] = {['Coords'] = vector4(-1485.66, -376.66, 41.4, 137.59),   ['Label'] = 'Morningwood'},
  [3] = {['Coords'] = vector4(-1220.76, -909.15, 13.55, 37.12),   ['Label'] = 'San Andreas'},
  [4] = {['Coords'] = vector4(-718.05, -916.04, 20.04, 313.80),   ['Label'] = 'Little Seoul'},
  [5] = {['Coords'] = vector4(34.42, -1348.74, 30.7, 46.54),      ['Label'] = 'Innocence'},
  [6] = {['Coords'] = vector4(1132.66, -983.17, 47.11, 279.92),   ['Label'] = 'El Rancho'},
  [7] = {['Coords'] = vector4(1153.48, -327.02, 70.30, 324.08),   ['Label'] = 'West Mirror Drive'},
  [8] = {['Coords'] = vector4(381.81, 322.70, 104.70, 32.40),     ['Label'] = 'Clinton Ave'},
  [9] = {['Coords'] = vector4(-1827.25, 784.65, 139.42, 353.42),  ['Label'] = 'Banham Canvon'},
  [10] = {['Coords'] = vector4(-2965.01, 391.32, 16.24, 93.29),   ['Label'] = 'Great Ocean Hyw'},
  [11] = {['Coords'] = vector4(-3040.69, 594.32, 9.08, 152.40),   ['Label'] = 'Ineseno Road'},
  [12] = {['Coords'] = vector4(-3240.03, 1009.41, 13.95, 131.45), ['Label'] = 'Barbareno Rd'},
  [13] = {['Coords'] = vector4(539.15, 2671.33, 43.20, 234.35),   ['Label'] = 'Route 68'},
  [14] = {['Coords'] = vector4(1165.42, 2712.17, 39.35, 181.28),  ['Label'] = 'Route 68 2'},
  [15] = {['Coords'] = vector4(2684.03, 3287.36, 56.39, 110.03),  ['Label'] = 'Senora Fwy'},
  [16] = {['Coords'] = vector4(1969.34, 3743.76, 33.51, 75.11),   ['Label'] = 'Alhambra Dr'},
  [17] = {['Coords'] = vector4(1736.06, 6409.70, 36.23, 17.48),   ['Label'] = 'Senora Fwy 2'},
  [18] = {['Coords'] = vector4(-161.75, 6319.98, 32.78, 318.76),  ['Label'] = 'Pyrite Ave'},
  [19] = {['Coords'] = vector4(166.52, 6633.68, 32.89, 359.50),   ['Label'] = 'Paleto Blvd'},
  [20] = {['Coords'] = vector4(1702.95, 4934.05, 43.26, 181.29),  ['Label'] = 'Grapeseed'},
  [21] = {['Coords'] = vector4(2559.04, 390.68, 109.74, 134.40),  ['Label'] = 'Palomino Fwy'},
}

Config.PoliceProps = {
  [1] = {
    ['Visible'] = false,
    ['Prop'] = 'v_ind_cs_bucket',
    ['Coords'] = {
        ['X'] = 441.80, 
        ['Y'] = -982.02, 
        ['Z'] = 30.40,
        ['H'] = 265.15,
    },
  },
}

Config.PoliceSafe = {
  ['Items'] = {
      [1] = {
        name = "weapon_pistol_mk2",
        price = 0,
        amount = 1,
        info = {},
        type = "weapon",
        slot = 1,
      },
      [2] = {
        name = "weapon_stungun",
        price = 0,
        amount = 1,
        info = {},
        type = "weapon",
        slot = 2,
      },
      [3] = {
        name = "weapon_m4",
        price = 100,
        amount = 1,
        info = {},
        type = "weapon",
        slot = 3,
      },
      [4] = {
        name = "weapon_flashlight",
        price = 0,
        amount = 1,
        info = {},
        type = "weapon",
        slot = 4,
      },
      [5] = {
        name = "weapon_nightstick",
        price = 0,
        amount = 1,
        info = {},
        type = "weapon",
        slot = 5,
      },
      [6] = {
        name = "pistol_ammo",
        price = 10,
        amount = 50,
        info = {},
        type = "item",
        slot = 6,
      },
      [7] = {
        name = "taser_ammo",
        price = 0,
        amount = 50,
        info = {},
        type = "item",
        slot = 7,
      },
      [8] = {
        name = "rifle_ammo",
        price = 15,
        amount = 50,
        info = {},
        type = "item",
        slot = 8,
      },
      [9] = {
        name = "armor",
        price = 10,
        amount = 50,
        info = {},
        type = "item",
        slot = 9,
      },
      [10] = {
        name = "heavyarmor",
        price = 20,
        amount = 50,
        info = {},
        type = "item",
        slot = 10,
      },
      [11] = {
        name = "handcuffs",
        price = 0,
        amount = 1,
        info = {},
        type = "item",
        slot = 11,
      },
      [12] = {
        name = "empty_evidence_bag",
        price = 0,
        amount = 50,
        info = {},
        type = "item",
        slot = 12,
      },
      [13] = {
        name = "radio",
        price = 0,
        amount = 50,
        info = {},
        type = "item",
        slot = 13,
      },
      [14] = {
        name = "police_stormram",
        price = 0,
        amount = 50,
        info = {},
        type = "item",
        slot = 14,
      },
      [15] = {
        name = "camera",
        price = 0,
        amount = 50,
        info = {},
        type = "item",
        slot = 15,
      },
      [16] = {
        name = "sheer",
        price = 2,
        amount = 50,
        info = {},
        type = "item",
        slot = 16,
      },
      [17] = {
        name = "keyfob",
        price = 2,
        amount = 50,
        info = {},
        type = "item",
        slot = 17,
      },
      [18] = {
        name = "nightvision",
        price = 10,
        amount = 50,
        info = {},
        type = "item",
        slot = 18,
      },
      [19] = {
        name = "health-pack",
        price = 20,
        amount = 50,
        info = {},
        type = "item",
        slot = 19,
      },
   }
}

-- Pawnshop

Config.SmeltingProps = {
  [1] = {
      ['Prop'] = 'v_ilev_fib_frame03',
      ['Coords'] = vector4(1087.60, -2002.30, 30.0, 120.02)
  },
}

Config.SmeltItems = {
  ['rolex'] = 16,
  ['goldchain'] = 27,
  ['heirloom'] = 19,
}

Config.SellItems = {
  ['rolex'] = 285,
  ['goldchain'] = 185,
  ['diamond_ring'] = 175,
  -- ['goldbar'] = math.random(4500, 6500),
  ['heirloom'] = 250,
  ['cult-necklace'] = 1000,
  ['gold-record'] = 750,
}

Config.ConvertItems = {
  ['wood_proc'] = 'clean_paper',
}

Config.MaterialItems = {
  [1] = {
      ['Label'] = 'Geld',
      ['ItemName'] = 'cash',
      ['Slot'] = 1,
      ['Amount'] = 600000,
      ['Info'] = '',
      ['Weight'] = 5,
      ['Image'] = 'cash.png',
      ['AddingPoints'] = 2,
      ['PointsNeeded'] = 0,
      ['Cost'] = {
          [1] = {
              ['Label'] = 'Papier',
              ['ItemName'] = 'clean_paper',
              ['Image'] = 'clean_paper.png',
              ['Amount'] = 2,
          },
          [2] = {
              ['Label'] = 'Moneyroll',
              ['ItemName'] = 'money-roll',
              ['Image'] = 'money-roll.png',
              ['Amount'] = 1,
          },
      },
  },
}

-- Crafting


Config.CraftingItems = {
  [1] = {
      ['Label'] = 'Lockpick',
      ['ItemName'] = 'lockpick',
      ['Slot'] = 1,
      ['Amount'] = 10,
      ['Info'] = '',
      ['Weight'] = 1000,
      ['Image'] = 'lockpick.png',
      ['AddingPoints'] = 2,
      ['PointsNeeded'] = 0,
      ['Cost'] = {
          [1] = {
              ['Label'] = 'Plastic',
              ['ItemName'] = 'plastic',
              ['Image'] = 'plastic.png',
              ['Amount'] = 32,
          },
          [2] = {
              ['Label'] = 'Metaal Schroot',
              ['ItemName'] = 'metalscrap',
              ['Image'] = 'metalscrap.png',
              ['Amount'] = 22,
          },
      },
  },
  [2] = {
      ['Label'] = 'Toolkit',
      ['ItemName'] = 'screwdriverset',
      ['Slot'] = 2,
      ['Amount'] = 10,
      ['Info'] = '',
      ['Weight'] = 450,
      ['Image'] = 'toolkit.png',
      ['AddingPoints'] = 2,
      ['PointsNeeded'] = 0,
      ['Cost'] = {
          [1] = {
              ['Label'] = 'Plastic',
              ['ItemName'] = 'plastic',
              ['Image'] = 'plastic.png',
              ['Amount'] = 42,
          },
          [2] = {
              ['Label'] = 'Metaal Schroot',
              ['ItemName'] = 'metalscrap',
              ['Image'] = 'metalscrap.png',
              ['Amount'] = 30,
          },
      },
  },
  [3] = {
      ['Label'] = 'Electronic Kit',
      ['ItemName'] = 'electronickit',
      ['Slot'] = 3,
      ['Amount'] = 10,
      ['Info'] = '',
      ['Weight'] = 1000,
      ['Image'] = 'electronickit.png',
      ['AddingPoints'] = 3,
      ['PointsNeeded'] = 0,
      ['Cost'] = {
          [1] = {
              ['Label'] = 'Plastic',
              ['ItemName'] = 'plastic',
              ['Image'] = 'plastic.png',
              ['Amount'] = 45,
          },
          [2] = {
              ['Label'] = 'Metaal Schroot',
              ['ItemName'] = 'metalscrap',
              ['Image'] = 'metalscrap.png',
              ['Amount'] = 30,
          },
          [3] = {
              ['Label'] = 'Aluminum',
              ['ItemName'] = 'aluminum',
              ['Image'] = 'aluminum.png',
              ['Amount'] = 28,
          },
      },
  },
  [4] = {
      ['Label'] = 'Plastic Zakje',
      ['ItemName'] = 'empty_weed_bag',
      ['Slot'] = 4,
      ['Amount'] = 10,
      ['Info'] = '',
      ['Weight'] = 200,
      ['Image'] = 'plastic-bag.png',
      ['AddingPoints'] = 0,
      ['PointsNeeded'] = 0,
      ['Cost'] = {
          [1] = {
              ['Label'] = 'Plastic',
              ['ItemName'] = 'plastic',
              ['Image'] = 'plastic.png',
              ['Amount'] = 5,
          },
      },
  },
  [5] = {
      ['Label'] = 'Reparatie Set',
      ['ItemName'] = 'repairkit',
      ['Slot'] = 5,
      ['Amount'] = 10,
      ['Info'] = '',
      ['Weight'] = 2500,
      ['Image'] = 'repairkit.png',
      ['AddingPoints'] = 2,
      ['PointsNeeded'] = 100,
      ['Cost'] = {
          [1] = {
              ['Label'] = 'Metaal Schroot',
              ['ItemName'] = 'metalscrap',
              ['Image'] = 'metalscrap.png',
              ['Amount'] = 32,
          },
          [2] = {
              ['Label'] = 'Staal',
              ['ItemName'] = 'steel',
              ['Image'] = 'steel.png',
              ['Amount'] = 43,
          },
          [3] = {
              ['Label'] = 'Plastic',
              ['ItemName'] = 'plastic',
              ['Image'] = 'plastic.png',
              ['Amount'] = 61,
          },
      },
  },
  [6] = {
      ['Label'] = 'Handboeien',
      ['ItemName'] = 'handcuffs',
      ['Slot'] = 6,
      ['Amount'] = 10,
      ['Info'] = '',
      ['Weight'] = 1250,
      ['Image'] = 'cuffs.png',
      ['AddingPoints'] = 3,
      ['PointsNeeded'] = 250,
      ['Cost'] = {
          [1] = {
              ['Label'] = 'Metaal Schroot',
              ['ItemName'] = 'metalscrap',
              ['Image'] = 'metalscrap.png',
              ['Amount'] = 36,
          },
          [2] = {
              ['Label'] = 'Staal',
              ['ItemName'] = 'steel',
              ['Image'] = 'steel.png',
              ['Amount'] = 24,
          },
          [3] = {
              ['Label'] = 'Aluminum',
              ['ItemName'] = 'aluminum',
              ['Image'] = 'aluminum.png',
              ['Amount'] = 28,
          },
      },
  },
  [7] = {
      ['Label'] = 'Kogel Vest',
      ['ItemName'] = 'armor',
      ['Slot'] = 7,
      ['Amount'] = 10,
      ['Info'] = '',
      ['Weight'] = 13500,
      ['Image'] = 'vest.png',
      ['AddingPoints'] = 3,
      ['PointsNeeded'] = 300,
      ['Cost'] = {
          [1] = {
              ['Label'] = 'Plastic',
              ['ItemName'] = 'plastic',
              ['Image'] = 'plastic.png',
              ['Amount'] = 55,
          },
          [2] = {
              ['Label'] = 'Staal',
              ['ItemName'] = 'steel',
              ['Image'] = 'steel.png',
              ['Amount'] = 44,
          },
          [3] = {
              ['Label'] = 'Ijzer',
              ['ItemName'] = 'iron',
              ['Image'] = 'ironplate.png',
              ['Amount'] = 33,
          },
          [4] = {
              ['Label'] = 'Aluminium',
              ['ItemName'] = 'aluminum',
              ['Image'] = 'aluminum.png',
              ['Amount'] = 22,
          },
      },
  },
  [8] = {
      ['Label'] = 'Pistool Kogels',
      ['ItemName'] = 'pistol_ammo',
      ['Slot'] = 8,
      ['Amount'] = 10,
      ['Info'] = '',
      ['Weight'] = 500,
      ['Image'] = 'ammo-pistol.png',
      ['AddingPoints'] = 3,
      ['PointsNeeded'] = 450,
      ['Cost'] = {
          [1] = {
              ['Label'] = 'Metaal Schroot',
              ['ItemName'] = 'metalscrap',
              ['Image'] = 'metalscrap.png',
              ['Amount'] = 50,
          },
          [2] = {
              ['Label'] = 'Staal',
              ['ItemName'] = 'steel',
              ['Image'] = 'steel.png',
              ['Amount'] = 37,
          },
          [3] = {
              ['Label'] = 'Koper',
              ['ItemName'] = 'copper',
              ['Image'] = 'copper.png',
              ['Amount'] = 26,
          },
          [4] = {
              ['Label'] = 'Aluminium Poeder',
              ['ItemName'] = 'aluminumoxide',
              ['Image'] = 'aluminumoxide.png',
              ['Amount'] = 3,
          },
          [5] = {
              ['Label'] = 'Ijzer Poeder',
              ['ItemName'] = 'ironoxide',
              ['Image'] = 'ironoxide.png',
              ['Amount'] = 3,
          },
      },
  },
  [9] = {
      ['Label'] = 'SMG Kogels',
      ['ItemName'] = 'smg_ammo',
      ['Slot'] = 9,
      ['Amount'] = 10,
      ['Info'] = '',
      ['Weight'] = 650,
      ['Image'] = 'ammo-smg.png',
      ['AddingPoints'] = 1,
      ['PointsNeeded'] = 950,
      ['Cost'] = {
          [1] = {
              ['Label'] = 'Metaal Schroot',
              ['ItemName'] = 'metalscrap',
              ['Image'] = 'metalscrap.png',
              ['Amount'] = 65,
          },
          [2] = {
              ['Label'] = 'Staal',
              ['ItemName'] = 'steel',
              ['Image'] = 'steel.png',
              ['Amount'] = 41,
          },
          [3] = {
              ['Label'] = 'Koper',
              ['ItemName'] = 'copper',
              ['Image'] = 'copper.png',
              ['Amount'] = 26,
          },
          [4] = {
              ['Label'] = 'Aluminium Poeder',
              ['ItemName'] = 'aluminumoxide',
              ['Image'] = 'aluminumoxide.png',
              ['Amount'] = 4,
          },
          [5] = {
              ['Label'] = 'Ijzer Poeder',
              ['ItemName'] = 'ironoxide',
              ['Image'] = 'ironoxide.png',
              ['Amount'] = 4,
          },
      },
  },
  [10] = {
      ['Label'] = 'Shotgun Slugs',
      ['ItemName'] = 'shotgun_ammo',
      ['Slot'] = 10,
      ['Amount'] = 10,
      ['Info'] = '',
      ['Weight'] = 650,
      ['Image'] = 'ammo-shotgun.png',
      ['AddingPoints'] = 1,
      ['PointsNeeded'] = 1150,
      ['Cost'] = {
          [1] = {
              ['Label'] = 'Metaal Schroot',
              ['ItemName'] = 'metalscrap',
              ['Image'] = 'metalscrap.png',
              ['Amount'] = 75,
          },
          [2] = {
              ['Label'] = 'Staal',
              ['ItemName'] = 'steel',
              ['Image'] = 'steel.png',
              ['Amount'] = 40,
          },
          [3] = {
              ['Label'] = 'Koper',
              ['ItemName'] = 'copper',
              ['Image'] = 'copper.png',
              ['Amount'] = 28,
          },
          [4] = {
              ['Label'] = 'Aluminium Poeder',
              ['ItemName'] = 'aluminumoxide',
              ['Image'] = 'aluminumoxide.png',
              ['Amount'] = 5,
          },
          [5] = {
              ['Label'] = 'Ijzer Poeder',
              ['ItemName'] = 'ironoxide',
              ['Image'] = 'ironoxide.png',
              ['Amount'] = 5,
          },
      },
  },
  [11] = {
      ['Label'] = 'Mes Onderdeel',
      ['ItemName'] = 'knife-part-2',
      ['Slot'] = 11,
      ['Amount'] = 10,
      ['Info'] = '',
      ['Weight'] = 450,
      ['Image'] = 'knife-part-2.png',
      ['AddingPoints'] = 3,
      ['PointsNeeded'] = 550,
      ['Cost'] = {
          [1] = {
              ['Label'] = 'Metaal Schroot',
              ['ItemName'] = 'metalscrap',
              ['Image'] = 'metalscrap.png',
              ['Amount'] = 72,
          },
          [2] = {
              ['Label'] = 'Staal',
              ['ItemName'] = 'steel',
              ['Image'] = 'steel.png',
              ['Amount'] = 33,
          },
          [3] = {
              ['Label'] = 'Ijzer',
              ['ItemName'] = 'iron',
              ['Image'] = 'ironplate.png',
              ['Amount'] = 51,
          },
      },
  },
  [12] = {
      ['Label'] = 'Klapmes Onderdeel',
      ['ItemName'] = 'switch-part-2',
      ['Slot'] = 12,
      ['Amount'] = 10,
      ['Info'] = '',
      ['Weight'] = 450,
      ['Image'] = 'switch-part-2.png',
      ['AddingPoints'] = 3,
      ['PointsNeeded'] = 550,
      ['Cost'] = {
          [1] = {
              ['Label'] = 'Metaal Schroot',
              ['ItemName'] = 'metalscrap',
              ['Image'] = 'metalscrap.png',
              ['Amount'] = 72,
          },
          [2] = {
              ['Label'] = 'Staal',
              ['ItemName'] = 'steel',
              ['Image'] = 'steel.png',
              ['Amount'] = 33,
          },
          [3] = {
              ['Label'] = 'Ijzer',
              ['ItemName'] = 'iron',
              ['Image'] = 'ironplate.png',
              ['Amount'] = 51,
          },
      },
  },
  [13] = {
      ['Label'] = 'Extended Clip',
      ['ItemName'] = 'pistol_extendedclip',
      ['Slot'] = 13,
      ['Amount'] = 10,
      ['Info'] = '',
      ['Weight'] = 1000,
      ['Image'] = 'pistol_extendedclip.png',
      ['AddingPoints'] = 3,
      ['PointsNeeded'] = 1100,
      ['Cost'] = {
          [1] = {
              ['Label'] = 'Metaal Schroot',
              ['ItemName'] = 'metalscrap',
              ['Image'] = 'metalscrap.png',
              ['Amount'] = 105,
          },
          [2] = {
              ['Label'] = 'Staal',
              ['ItemName'] = 'steel',
              ['Image'] = 'steel.png',
              ['Amount'] = 48,
          },
          [3] = {
              ['Label'] = 'Ijzer',
              ['ItemName'] = 'iron',
              ['Image'] = 'ironplate.png',
              ['Amount'] = 36,
          },
          [4] = {
              ['Label'] = 'Rubber',
              ['ItemName'] = 'rubber',
              ['Image'] = 'rubber.png',
              ['Amount'] = 100,
          },
      },
  },
  [14] = {
      ['Label'] = 'PonyPack',
      ['ItemName'] = 'ponypack',
      ['Slot'] = 14,
      ['Amount'] = 1,
      ['Info'] = '',
      ['Weight'] = 70,
      ['Image'] = 'paperbag.png',
      ['AddingPoints'] = 1,
      ['PointsNeeded'] = 300,
      ['Cost'] = {
          [1] = {
              ['Label'] = 'Papier',
              ['ItemName'] = 'clean_paper',
              ['Image'] = 'clean_paper.png',
              ['Amount'] = 2,
          },
      },
  },
  [15] = {
      ['Label'] = 'Aluminium Poeder',
      ['ItemName'] = 'aluminumoxide',
      ['Slot'] = 15,
      ['Amount'] = 10,
      ['Info'] = '',
      ['Weight'] = 100,
      ['Image'] = 'aluminumoxide.png',
      ['AddingPoints'] = 2,
      ['PointsNeeded'] = 800,
      ['Cost'] = {
          [1] = {
              ['Label'] = 'Aluminium',
              ['ItemName'] = 'aluminum',
              ['Image'] = 'aluminum.png',
              ['Amount'] = 60,
          },
          [2] = {
              ['Label'] = 'Glasplaat',
              ['ItemName'] = 'glass',
              ['Image'] = 'glassplate.png',
              ['Amount'] = 30,
          },
      },
  },
  [16] = {
      ['Label'] = 'Ijzer Poeder',
      ['ItemName'] = 'ironoxide',
      ['Slot'] = 16,
      ['Amount'] = 10,
      ['Info'] = '',
      ['Weight'] = 100,
      ['Image'] = 'ironoxide.png',
      ['AddingPoints'] = 2,
      ['PointsNeeded'] = 800,
      ['Cost'] = {
          [1] = {
              ['Label'] = 'Ijzer',
              ['ItemName'] = 'iron',
              ['Image'] = 'ironplate.png',
              ['Amount'] = 60,
          },
          [2] = {
              ['Label'] = 'Glasplaat',
              ['ItemName'] = 'glass',
              ['Image'] = 'glassplate.png',
              ['Amount'] = 30,
          },
      },
  },
  [17] = {
      ['Label'] = 'Explosief',
      ['ItemName'] = 'explosive',
      ['Slot'] = 17,
      ['Amount'] = 10,
      ['Info'] = '',
      ['Weight'] = 4500,
      ['Image'] = 'explosive.png',
      ['AddingPoints'] = 2,
      ['PointsNeeded'] = 800,
      ['Cost'] = {
          [1] = {
              ['Label'] = 'Metaal Schroot',
              ['ItemName'] = 'metalscrap',
              ['Image'] = 'metalscrap.png',
              ['Amount'] = 110,
          },
          [2] = {
              ['Label'] = 'Plastic',
              ['ItemName'] = 'plastic',
              ['Image'] = 'plastic.png',
              ['Amount'] = 150,
          },
          [3] = {
              ['Label'] = 'Thermiet',
              ['ItemName'] = 'thermite',
              ['Image'] = 'thermite.png',
              ['Amount'] = 4,
          },
          [4] = {
              ['Label'] = 'Rubber',
              ['ItemName'] = 'rubber',
              ['Image'] = 'rubber.png',
              ['Amount'] = 20,
          },
          [5] = {
              ['Label'] = 'Electronic Kit',
              ['ItemName'] = 'electronickit',
              ['Image'] = 'electronickit.png',
              ['Amount'] = 2,
          },
      },
  },
  [18] = {
      ['Label'] = 'Zwaar Thermiet',
      ['ItemName'] = 'heavy-thermite',
      ['Slot'] = 18,
      ['Amount'] = 10,
      ['Info'] = '',
      ['Weight'] = 10000,
      ['Image'] = 'hthermite.png',
      ['AddingPoints'] = 2,
      ['PointsNeeded'] = 1000,
      ['Cost'] = {
          [1] = {
              ['Label'] = 'Metaal Schroot',
              ['ItemName'] = 'metalscrap',
              ['Image'] = 'metalscrap.png',
              ['Amount'] = 210,
          },
          [2] = {
              ['Label'] = 'Staal',
              ['ItemName'] = 'steel',
              ['Image'] = 'steel.png',
              ['Amount'] = 75,
          },
          [3] = {
              ['Label'] = 'Koper',
              ['ItemName'] = 'copper',
              ['Image'] = 'copper.png',
              ['Amount'] = 33,
          },
          [4] = {
              ['Label'] = 'Thermiet',
              ['ItemName'] = 'thermite',
              ['Image'] = 'thermite.png',
              ['Amount'] = 10,
          },
          [5] = {
              ['Label'] = 'Rubber',
              ['ItemName'] = 'rubber',
              ['Image'] = 'rubber.png',
              ['Amount'] = 10,
          },
      },
  },
}

-- Cityhall


Config.Menus = {
  ['Identity'] = {
      [1] = {
          ['Name'] = 'Identiteits Kaart',
          ['Desc'] = 'Kosten: €50,-',
          ['Type'] = 'id',
          ['EventType'] = 'Server',
          ['Event'] = 'framework-cityhall:server:request:identity',
      },
      [2] = {
          ['Name'] = 'Rijbewijs',
          ['Desc'] = 'Kosten: €50,-',
          ['Type'] = 'drive',
          ['EventType'] = 'Server',
          ['Event'] = 'framework-cityhall:server:request:identity',
      },
  },
  ['Licences'] = {
      [1] = {
          ['Name'] = 'Jaag Vergunning',
          ['Desc'] = 'Kosten: €5000,-',
          ['Type'] = 'hunting',
          ['EventType'] = 'Server',
          ['Event'] = 'framework-cityhall:server:request:license',
      },
  },
  ['Work'] = {
      [1] = {
          ['Name'] = 'Depot Medewerker',
          ['Desc'] = 'Verdient: €50,-',
          ['Type'] = 'tow',
          ['EventType'] = 'Server',
          ['Event'] = 'framework-cityhall:server:request:work',
      },
      [2] = {
          ['Name'] = 'Vuilnis Medewerker',
          ['Desc'] = 'Verdient: €50,-',
          ['Type'] = 'garbage',
          ['EventType'] = 'Server',
          ['Event'] = 'framework-cityhall:server:request:work',
      },
      [3] = {
          ['Name'] = 'Taxi Medewerker',
          ['Desc'] = 'Verdient: €80,-',
          ['Type'] = 'taxi',
          ['EventType'] = 'Server',
          ['Event'] = 'framework-cityhall:server:request:work',
      },
      [4] = {
          ['Name'] = 'Trucker Medewerker',
          ['Desc'] = 'Verdient: €100,-',
          ['Type'] = 'trucker',
          ['EventType'] = 'Server',
          ['Event'] = 'framework-cityhall:server:request:work',
      },
      [5] = {
          ['Name'] = 'Journalist Medewerker',
          ['Desc'] = 'Verdient: €100,-',
          ['Type'] = 'reporter',
          ['EventType'] = 'Server',
          ['Event'] = 'framework-cityhall:server:request:work',
      },
      [6] = {
          ['Name'] = 'Burgerjob Medewerker',
          ['Desc'] = 'Verdient: €100,-',
          ['Type'] = 'burger',
          ['EventType'] = 'Server',
          ['Event'] = 'framework-cityhall:server:request:work',
      },
  },
  -- ['Appartment'] = {
  --     [1] = {
  --         ['Name'] = 'South Rockford Drive',
  --         ['Desc'] = 'Verhuis Kosten: €10000,-',
  --         ['Type'] = 'apartment1',
  --         ['EventType'] = 'Server',
  --         ['Event'] = 'framework-cityhall:server:request:appartment',
  --     },
  --     [2] = {
  --         ['Name'] = 'Morningwood Blvd',
  --         ['Desc'] = 'Verhuis Kosten: €10000,-',
  --         ['Type'] = 'apartment2',
  --         ['EventType'] = 'Server',
  --         ['Event'] = 'framework-cityhall:server:request:appartment',
  --     },
  --     [3] = {
  --         ['Name'] = 'Integrity Way',
  --         ['Desc'] = 'Verhuis Kosten: €10000,-',
  --         ['Type'] = 'apartment3',
  --         ['EventType'] = 'Server',
  --         ['Event'] = 'framework-cityhall:server:request:appartment',
  --     },
  --     [4] = {
  --         ['Name'] = 'Vinewood Towers',
  --         ['Desc'] = 'Verhuis Kosten: €10000,-',
  --         ['Type'] = 'apartment4',
  --         ['EventType'] = 'Server',
  --         ['Event'] = 'framework-cityhall:server:request:appartment',
  --     },
  --     [5] = {
  --         ['Name'] = 'Fantastic Plaza',
  --         ['Desc'] = 'Verhuis Kosten: €10000,-',
  --         ['Type'] = 'apartment5',
  --         ['EventType'] = 'Server',
  --         ['Event'] = 'framework-cityhall:server:request:appartment',
  --     },
  --     [6] = {
  --         ['Name'] = 'Phillbox Hill',
  --         ['Desc'] = 'Verhuis Kosten: €10000,-',
  --         ['Type'] = 'apartment6',
  --         ['EventType'] = 'Server',
  --         ['Event'] = 'framework-cityhall:server:request:appartment',
  --     },
  -- },
}

Config.CityProps = {
  [1] = {
      ['Visible'] = false,
      ['PlacePropGood'] = false,
      ['Prop'] = 'v_ilev_gunsign_assmg',
      ['Coords'] = {
          ['X'] = -550.81, 
          ['Y'] = -192.13, 
          ['Z'] = 38.32,
          ['H'] = 29.82,
      },
  },
  [2] = {
      ['Visible'] = false,
      ['PlacePropGood'] = false,
      ['Prop'] = 'v_ilev_gunsign_assmg',
      ['Coords'] = {
          ['X'] = -552.71, 
          ['Y'] = -193.23, 
          ['Z'] = 38.32,
          ['H'] = 29.82,
      },
  },
}

Config.MetalDetector = {
  ['Scanned'] = false,
  ['Coords'] = {
      [1] = {
        ['X'] = 128.17523,
        ['Y'] = -1297.67,
        ['Z'] = 29.269346,
      },
      -- [2] = {
      --   ['X'] = -537.44,
      --   ['Y'] = -186.37,
      --   ['Z'] = 42.76,
      -- },
  },
}