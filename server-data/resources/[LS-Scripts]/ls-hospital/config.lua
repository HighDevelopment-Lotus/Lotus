Config = Config or {}

Config.Keys = {["E"] = 38, ["T"] = 245, ["V"] = 0, ["ESC"] = 322, ["F1"] = 288, ["HOME"] = 213}

Config.IsDeath = false
Config.IsInBed = false
Config.Timer = 300

Config.RespawnPrice = 2000

Config.OnOxy = false

Config.BedPayment = 500

Config.MaxBodyPartHealth = 5

Config.CurrentPain = {}

Config.Locations = {
  ["CheckIn"] = vector3(306.77, -595.03, 43.28),
  ['Shop'] = vector3(308.91, -562.32, 43.28),
  ['Storage'] = vector3(309.81, -569.33, 43.28),
  ['Teleporters'] = {
    ['ToHeli'] = {['X'] = 331.99, ['Y'] = -595.62, ['Z'] = 43.28},
    ['ToHospitalFirst'] = {['X'] = 339.06, ['Y'] = -583.92, ['Z'] = 74.16},
    ['ToHospitalSecond'] = {['X'] = 329.98, ['Y'] = -601.08, ['Z'] = 43.28},
    ['ToLower'] = {['X'] = 344.84, ['Y'] = -586.30, ['Z'] = 28.79},
  },
  ['Garages'] = {
    [1] = {
      ['Coords'] = vector3(329.30, -575.07, 28.79),
      ['Spawns'] = {
          [1] = {
             ['Coords'] = vector4(333.75, -574.79, 28.79, 341.55)
          },
          [2] = {
             ['Coords'] = vector4(327.38, -570.27, 28.79, 340.72)
          },
      },
    },
    [2] = {
      ['Coords'] = vector3(352.17, -587.87, 74.16),
      ['Spawns'] = nil
    },
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
  [1] = {['X'] = 311.14, ['Y'] = -582.98, ['Z'] = 44.20, ['H'] = 336.86, ['Busy'] = false, ['Hash'] = 1631638868},
  [2] = {['X'] = 314.53, ['Y'] = -584.08, ['Z'] = 44.20, ['H'] = 336.86, ['Busy'] = false, ['Hash'] = 1631638868},
  [3] = {['X'] = 317.72, ['Y'] = -585.28, ['Z'] = 44.20, ['H'] = 336.86, ['Busy'] = false, ['Hash'] = 1631638868},
  [4] = {['X'] = 319.28, ['Y'] = -581.11, ['Z'] = 44.20, ['H'] = 159.34, ['Busy'] = false, ['Hash'] = 1631638868},
  [5] = {['X'] = 313.88, ['Y'] = -579.08, ['Z'] = 44.20, ['H'] = 159.34, ['Busy'] = false, ['Hash'] = 1631638868},
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