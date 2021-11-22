Config = Config or {}

Config.Evidence, Config.PoliceObjects = {}, {}

Config.IsHandCuffed, Config.IsEscorted = false, false

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
        price = 0,
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
        price = 100,
        amount = 50,
        info = {},
        type = "item",
        slot = 6,
      },
      [7] = {
        name = "taser_ammo",
        price = 75,
        amount = 50,
        info = {},
        type = "item",
        slot = 7,
      },
      [8] = {
        name = "rifle_ammo",
        price = 250,
        amount = 50,
        info = {},
        type = "item",
        slot = 8,
      },
      [9] = {
        name = "armor",
        price = 150,
        amount = 50,
        info = {},
        type = "item",
        slot = 9,
      },
      [10] = {
        name = "heavyarmor",
        price = 350,
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
        price = 10,
        amount = 50,
        info = {},
        type = "item",
        slot = 15,
      },
      [16] = {
        name = "sheer",
        price = 50,
        amount = 50,
        info = {},
        type = "item",
        slot = 16,
      },
      [17] = {
        name = "keyfob",
        price = 10,
        amount = 50,
        info = {},
        type = "item",
        slot = 17,
      },
   }
}