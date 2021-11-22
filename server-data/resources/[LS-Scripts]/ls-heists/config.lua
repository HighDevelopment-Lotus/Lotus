Config = Config or {}

Config.RobbedPlates = {}

Config.CopsNeeded, Config.StoreCopsNeeded = 4, 2

Config.BankBeingRobbed = false

Config.CardTypes = {
  'blue-card',
  'red-card',
  'purple-card',
  'green-card',
}

Config.Banks = {
  [1] = {
    ['Name'] = 'Blokkenpark Bank',
    ['BankOpen'] = false,
    ['DoorReset'] = {44},
    ['Coords'] = {['X'] = 145.76, ['Y'] = -1044.52, ['Z'] = 29.37},
    ['Door'] = {['Object'] = GetHashKey("v_ilev_gb_vauldr"), ['Heading'] = {['Open'] = 160.0, ['Closed'] = 250.0}},
    ['Prop'] = {[1] = {['Show'] = false, ['Object'] = 'hei_prop_hei_securitypanel', ['Coords'] = {['X'] = 147.25, ['Y'] = -1046.28, ['Z'] = 29.36, ['H'] = 250.0}}, [2] = {['Show'] = true, ['Available'] = true, ['Object'] = 'hei_prop_heist_deposit_box', ['Coords'] = {['X'] = 148.37, ['Y'] = -1049.11, ['Z'] = 29.19, ['H'] = 136.33}}},
    ['Menus'] = {[1] = {['Active'] = true, ['Name'] = 'Welke kaart?', ['Desc'] = 'Kom er achter welke kaart je nodig hebt..', ['Event'] = 'ls-bankrobbery:client:hack:card', ['Card'] = nil}, [2] = {['Active'] = false, ['Name'] = 'Bank Hacken', ['Desc'] = 'Begin met het overvallen van de bank.', ['Event'] = 'ls-bankrobbery:client:hack:door'}},
    ['Lockers'] = {
      [1] = {['Busy'] = false, ['Open'] = false, ['Type'] = 'safe', ['Coords'] = {['X'] = 149.71, ['Y'] = -1044.93, ['Z'] = 29.34}},
      [2] = {['Busy'] = false, ['Open'] = false, ['Type'] = 'lockpick', ['Coords'] = {['X'] = 151.18, ['Y'] = -1046.66, ['Z'] = 29.34}},
      [3] = {['Busy'] = false, ['Open'] = false, ['Type'] = 'lockpick', ['Coords'] = {['X'] = 147.07, ['Y'] = -1047.97, ['Z'] = 29.34}},
      [4] = {['Busy'] = false, ['Open'] = false, ['Type'] = 'drill', ['Coords'] = {['X'] = 146.61, ['Y'] = -1049.12, ['Z'] = 29.34}},
      [5] = {['Busy'] = false, ['Open'] = false, ['Type'] = 'drill', ['Coords'] = {['X'] = 147.25, ['Y'] = -1050.38, ['Z'] = 29.34}},
      [6] = {['Busy'] = false, ['Open'] = false, ['Type'] = 'safe', ['Coords'] = {['X'] = 148.97, ['Y'] = -1051.05, ['Z'] = 29.34}},
      [7] = {['Busy'] = false, ['Open'] = false, ['Type'] = 'lockpick', ['Coords'] = {['X'] = 150.06, ['Y'] = -1050.45, ['Z'] = 29.34}},
      [8] = {['Busy'] = false, ['Open'] = false, ['Type'] = 'drill', ['Coords'] = {['X'] = 150.58, ['Y'] = -1049.11, ['Z'] = 29.34}},
    },
  },
  [2] = {
    ['Name'] = 'Motels Bank',
    ['BankOpen'] = false,
    ['DoorReset'] = {46},
    ['Coords'] = {['X'] = 310.29, ['Y'] = -283.02, ['Z'] = 54.17},
    ['Door'] = {['Object'] = GetHashKey("v_ilev_gb_vauldr"), ['Heading'] = {['Open'] = 160.0, ['Closed'] = 250.0}},
    ['Prop'] = {[1] = {['Show'] = false, ['Object'] = 'hei_prop_hei_securitypanel', ['Coords'] = {['X'] = 311.58, ['Y'] = -284.64, ['Z'] = 54.17, ['H'] = 250.0}}, [2] = {['Show'] = true, ['Available'] = true, ['Object'] = 'hei_prop_heist_deposit_box', ['Coords'] = {['X'] = 312.84, ['Y'] = -287.45, ['Z'] = 53.98, ['H'] = 136.33}}},
    ['Menus'] = {[1] = {['Active'] = true, ['Name'] = 'Welke kaart?', ['Desc'] = 'Kom er achter welke kaart je nodig hebt..', ['Event'] = 'ls-bankrobbery:client:hack:card', ['Card'] = nil}, [2] = {['Active'] = false, ['Name'] = 'Bank Hacken', ['Desc'] = 'Begin met het overvallen van de bank.', ['Event'] = 'ls-bankrobbery:client:hack:door'}},
    ['Lockers'] = {
      [1] = {['Busy'] = false, ['Open'] = false, ['Type'] = 'safe', ['Coords'] = {['X'] = 314.04, ['Y'] = -283.30, ['Z'] = 54.14}},
      [2] = {['Busy'] = false, ['Open'] = false, ['Type'] = 'lockpick', ['Coords'] = {['X'] = 315.53, ['Y'] = -284.97, ['Z'] = 54.14}},
      [3] = {['Busy'] = false, ['Open'] = false, ['Type'] = 'lockpick', ['Coords'] = {['X'] = 311.45, ['Y'] = -286.25, ['Z'] = 54.14}},
      [4] = {['Busy'] = false, ['Open'] = false, ['Type'] = 'drill', ['Coords'] = {['X'] = 310.90, ['Y'] = -287.45, ['Z'] = 54.14}},
      [5] = {['Busy'] = false, ['Open'] = false, ['Type'] = 'safe', ['Coords'] = {['X'] = 311.58, ['Y'] = -288.71, ['Z'] = 54.14}},
      [6] = {['Busy'] = false, ['Open'] = false, ['Type'] = 'lockpick', ['Coords'] = {['X'] = 313.40, ['Y'] = -289.38, ['Z'] = 54.14}},
      [7] = {['Busy'] = false, ['Open'] = false, ['Type'] = 'lockpick', ['Coords'] = {['X'] = 314.69, ['Y'] = -288.89, ['Z'] = 54.14}},
      [8] = {['Busy'] = false, ['Open'] = false, ['Type'] = 'safe', ['Coords'] = {['X'] = 315.12, ['Y'] = -287.55, ['Z'] = 54.14}},
    },
  },
  [3] = {
    ['Name'] = 'Burton Bank',
    ['BankOpen'] = false,
    ['DoorReset'] = {45},
    ['Coords'] = {['X'] = -354.78, ['Y'] = -53.87, ['Z'] = 49.04},
    ['Door'] = {['Object'] = GetHashKey("v_ilev_gb_vauldr"), ['Heading'] = {['Open'] = 160.0, ['Closed'] = 250.0}},
    ['Prop'] = {[1] = {['Show'] = false, ['Object'] = 'hei_prop_hei_securitypanel', ['Coords'] = {['X'] = -353.49, ['Y'] = -55.45, ['Z'] = 49.04, ['H'] = 250.0}}, [2] = {['Show'] = true, ['Available'] = true, ['Object'] = 'hei_prop_heist_deposit_box', ['Coords'] = {['X'] = -352.16, ['Y'] = -58.31, ['Z'] = 48.85, ['H'] = 136.33}}},
    ['Menus'] = {[1] = {['Active'] = true, ['Name'] = 'Welke kaart?', ['Desc'] = 'Kom er achter welke kaart je nodig hebt..', ['Event'] = 'ls-bankrobbery:client:hack:card', ['Card'] = nil}, [2] = {['Active'] = false, ['Name'] = 'Bank Hacken', ['Desc'] = 'Begin met het overvallen van de bank.', ['Event'] = 'ls-bankrobbery:client:hack:door'}},
    ['Lockers'] = {
      [1] = {['Busy'] = false, ['Open'] = false, ['Type'] = 'lockpick', ['Coords'] = {['X'] = -350.99, ['Y'] = -54.09, ['Z'] = 49.01}},
      [2] = {['Busy'] = false, ['Open'] = false, ['Type'] = 'drill', ['Coords'] = {['X'] = -349.55, ['Y'] = -55.73, ['Z'] = 49.01}},
      [3] = {['Busy'] = false, ['Open'] = false, ['Type'] = 'lockpick', ['Coords'] = {['X'] = -353.58, ['Y'] = -57.11, ['Z'] = 49.01}},
      [4] = {['Busy'] = false, ['Open'] = false, ['Type'] = 'drill', ['Coords'] = {['X'] = -354.11, ['Y'] = -58.35, ['Z'] = 49.01}},
      [5] = {['Busy'] = false, ['Open'] = false, ['Type'] = 'lockpick', ['Coords'] = {['X'] = -353.56, ['Y'] = -59.53, ['Z'] = 49.01}},
      [6] = {['Busy'] = false, ['Open'] = false, ['Type'] = 'drill', ['Coords'] = {['X'] = -351.72, ['Y'] = -60.25, ['Z'] = 49.01}},
      [7] = {['Busy'] = false, ['Open'] = false, ['Type'] = 'safe', ['Coords'] = {['X'] = -350.40, ['Y'] = -59.61, ['Z'] = 49.01}},
      [8] = {['Busy'] = false, ['Open'] = false, ['Type'] = 'drill', ['Coords'] = {['X'] = -349.94, ['Y'] = -58.40, ['Z'] = 49.01}},
    },
  },
  [4] = {
    ['Name'] = 'Rockford Bank',
    ['BankOpen'] = false,
    ['DoorReset'] = {47},
    ['Coords'] = {['X'] = -1212.38, ['Y'] = -336.19, ['Z'] = 37.79},
    ['Door'] = {['Object'] = GetHashKey("v_ilev_gb_vauldr"), ['Heading'] = {['Open'] = 205.0, ['Closed'] = 295.0}},
    ['Prop'] = {[1] = {['Show'] = false, ['Object'] = 'hei_prop_hei_securitypanel', ['Coords'] = {['X'] = -1210.55, ['Y'] = -336.45, ['Z'] = 37.79, ['H'] = 250.0}}, [2] = {['Show'] = true, ['Available'] = true, ['Object'] = 'hei_prop_heist_deposit_box', ['Coords'] = {['X'] = -1207.38, ['Y'] = -337.47, ['Z'] = 37.60, ['H'] = 136.33}}},
    ['Menus'] = {[1] = {['Active'] = true, ['Name'] = 'Welke kaart?', ['Desc'] = 'Kom er achter welke kaart je nodig hebt..', ['Event'] = 'ls-bankrobbery:client:hack:card', ['Card'] = nil}, [2] = {['Active'] = false,['Name'] = 'Bank Hacken', ['Desc'] = 'Begin met het overvallen van de bank.', ['Event'] = 'ls-bankrobbery:client:hack:door'}},
    ['Lockers'] = {
      [1] = {['Busy'] = false, ['Open'] = false, ['Type'] = 'safe', ['Coords'] = {['X'] = -1209.67, ['Y'] = -333.66, ['Z'] = 37.75}},
      [2] = {['Busy'] = false, ['Open'] = false, ['Type'] = 'lockpick', ['Coords'] = {['X'] = -1207.44, ['Y'] = -333.78, ['Z'] = 37.75}},
      [3] = {['Busy'] = false, ['Open'] = false, ['Type'] = 'safe', ['Coords'] = {['X'] = -1209.35, ['Y'] = -337.64, ['Z'] = 37.75}},
      [4] = {['Busy'] = false, ['Open'] = false, ['Type'] = 'drill', ['Coords'] = {['X'] = -1208.71, ['Y'] = -338.85, ['Z'] = 37.75}},
      [5] = {['Busy'] = false, ['Open'] = false, ['Type'] = 'drill', ['Coords'] = {['X'] = -1207.51, ['Y'] = -339.26, ['Z'] = 37.75}},
      [6] = {['Busy'] = false, ['Open'] = false, ['Type'] = 'lockpick', ['Coords'] = {['X'] = -1205.56, ['Y'] = -338.34, ['Z'] = 37.75}},
      [7] = {['Busy'] = false, ['Open'] = false, ['Type'] = 'drill', ['Coords'] = {['X'] = -1205.21, ['Y'] = -337.14, ['Z'] = 37.75}},
      [8] = {['Busy'] = false, ['Open'] = false, ['Type'] = 'safe', ['Coords'] = {['X'] = -1205.70, ['Y'] = -335.96, ['Z'] = 37.75}},
    },
  },
  [5] = {
    ['Name'] = 'Sandy Bank',
    ['BankOpen'] = false,
    ['DoorReset'] = {49},
    ['Coords'] = {['X'] = 1177.37, ['Y'] = 2711.80, ['Z'] = 38.09},
    ['Door'] = {['Object'] = GetHashKey("v_ilev_gb_vauldr"), ['Heading'] = {['Open'] = 356.0, ['Closed'] = 90.0}},
    ['Prop'] = {[1] = {['Show'] = false, ['Object'] = 'hei_prop_hei_securitypanel', ['Coords'] = {['X'] = 1175.78, ['Y'] = 2712.81, ['Z'] = 38.09, ['H'] = 88.0}}, [2] = {['Show'] = true, ['Available'] = true, ['Object'] = 'hei_prop_heist_deposit_box', ['Coords'] = {['X'] = 1173.49, ['Y'] = 2715.22, ['Z'] = 37.91, ['H'] = 136.33}}},
    ['Menus'] = {[1] = {['Active'] = true, ['Name'] = 'Welke kaart?', ['Desc'] = 'Kom er achter welke kaart je nodig hebt..', ['Event'] = 'ls-bankrobbery:client:hack:card', ['Card'] = nil}, [2] = {['Active'] = false, ['Name'] = 'Bank Hacken', ['Desc'] = 'Begin met het overvallen van de bank.', ['Event'] = 'ls-bankrobbery:client:hack:door'}},
    ['Lockers'] = {
      [1] = {['Busy'] = false, ['Open'] = false, ['Type'] = 'drill', ['Coords'] = {['X'] = 1173.78, ['Y'] = 2710.72, ['Z'] = 38.06}},
      [2] = {['Busy'] = false, ['Open'] = false, ['Type'] = 'drill', ['Coords'] = {['X'] = 1171.77, ['Y'] = 2711.89, ['Z'] = 38.06}},
      [3] = {['Busy'] = false, ['Open'] = false, ['Type'] = 'safe', ['Coords'] = {['X'] = 1175.27, ['Y'] = 2714.43, ['Z'] = 38.06}},
      [4] = {['Busy'] = false, ['Open'] = false, ['Type'] = 'safe', ['Coords'] = {['X'] = 1175.27, ['Y'] = 2715.89, ['Z'] = 38.06}},
      [5] = {['Busy'] = false, ['Open'] = false, ['Type'] = 'drill', ['Coords'] = {['X'] = 1174.31, ['Y'] = 2716.77, ['Z'] = 38.06}},
      [6] = {['Busy'] = false, ['Open'] = false, ['Type'] = 'lockpick', ['Coords'] = {['X'] = 1172.22, ['Y'] = 2716.85, ['Z'] = 38.06}},
      [7] = {['Busy'] = false, ['Open'] = false, ['Type'] = 'safe', ['Coords'] = {['X'] = 1171.25, ['Y'] = 2715.85, ['Z'] = 38.06}},
      [8] = {['Busy'] = false, ['Open'] = false, ['Type'] = 'lockpick', ['Coords'] = {['X'] = 1171.21, ['Y'] = 2714.48, ['Z'] = 38.06}},
    },
  },
  [6] = {
    ['Name'] = 'Snelweg Bank',
    ['BankOpen'] = false,
    ['DoorReset'] = {48},
    ['Coords'] = {['X'] = -2957.63, ['Y'] = 480.15, ['Z'] = 15.59},
    ['Door'] = {['Object'] = GetHashKey("hei_prop_heist_sec_door"), ['Heading'] = {['Open'] = 265.0, ['Closed'] = 357.0}},
    ['Prop'] = {[1] = {['Show'] = false, ['Object'] = 'hei_prop_hei_securitypanel', ['Coords'] = {['X'] = -2956.53, ['Y'] = 481.86, ['Z'] = 15.59, ['H'] = 88.0}}, [2] = {['Show'] = true, ['Available'] = true, ['Object'] = 'hei_prop_heist_deposit_box', ['Coords'] = {['X'] = -2954.03, ['Y'] = 484.19, ['Z'] = 15.51, ['H'] = 136.33}}},
    ['Menus'] = {[1] = {['Active'] = true, ['Name'] = 'Welke kaart?', ['Desc'] = 'Kom er achter welke kaart je nodig hebt..', ['Event'] = 'ls-bankrobbery:client:hack:card', ['Card'] = nil}, [2] = {['Active'] = false, ['Name'] = 'Bank Hacken', ['Desc'] = 'Begin met het overvallen van de bank.', ['Event'] = 'ls-bankrobbery:client:hack:door'}},
    ['Lockers'] = {
      [1] = {['Busy'] = false, ['Open'] = false, ['Type'] = 'safe', ['Coords'] = {['X'] = -2958.54, ['Y'] = 484.03, ['Z'] = 15.67}},
      [2] = {['Busy'] = false, ['Open'] = false, ['Type'] = 'drill', ['Coords'] = {['X'] = -2957.29, ['Y'] = 485.90, ['Z'] = 15.67}},
      [3] = {['Busy'] = false, ['Open'] = false, ['Type'] = 'lockpick', ['Coords'] = {['X'] = -2954.85, ['Y'] = 482.42, ['Z'] = 15.67}},
      [4] = {['Busy'] = false, ['Open'] = false, ['Type'] = 'drill', ['Coords'] = {['X'] = -2953.54, ['Y'] = 482.37, ['Z'] = 15.67}},
      [5] = {['Busy'] = false, ['Open'] = false, ['Type'] = 'safe', ['Coords'] = {['X'] = -2952.59, ['Y'] = 483.36, ['Z'] = 15.67}},
      [6] = {['Busy'] = false, ['Open'] = false, ['Type'] = 'drill', ['Coords'] = {['X'] = -2952.51, ['Y'] = 485.17, ['Z'] = 15.67}},
      [7] = {['Busy'] = false, ['Open'] = false, ['Type'] = 'lockpick', ['Coords'] = {['X'] = -2953.23, ['Y'] = 486.28, ['Z'] = 15.67}},
      [8] = {['Busy'] = false, ['Open'] = false, ['Type'] = 'safe', ['Coords'] = {['X'] = -2954.77, ['Y'] = 486.37, ['Z'] = 15.67}},
    },
  },
  [7] = {
    ['Name'] = 'Paleto Bank',
    ['BankOpen'] = false,
    ['DoorReset'] = {50},
    ['Coords'] = {['X'] = -103.94, ['Y'] = 6471.05, ['Z'] = 31.62},
    ['Door'] = {['Object'] = GetHashKey("v_ilev_cbankvauldoor01"), ['Heading'] = {['Open'] = 139.0, ['Closed'] = 45.0}},
    ['Prop'] = {[1] = {['Show'] = false, ['Object'] = 'hei_prop_hei_securitypanel', ['Coords'] = {['X'] = -106.00, ['Y'] = 6471.97, ['Z'] = 31.62, ['H'] = 42.0}}},
    ['Menus'] = {[1] = {['Active'] = true, ['Name'] = 'Welke kaart?', ['Desc'] = 'Kom er achter welke kaart je nodig hebt..', ['Event'] = 'ls-bankrobbery:client:hack:card', ['Card'] = nil}, [2] = {['Active'] = false, ['Name'] = 'Bank Hacken', ['Desc'] = 'Begin met het overvallen van de bank.', ['Event'] = 'ls-bankrobbery:client:hack:door'}},
    ['Lockers'] = {
      [1] = {['Busy'] = false, ['Open'] = false, ['Type'] = 'lockpick', ['Coords'] = {['X'] = -107.07, ['Y'] = 6473.55, ['Z'] = 31.62}},
      [2] = {['Busy'] = false, ['Open'] = false, ['Type'] = 'safe', ['Coords'] = {['X'] = -107.60, ['Y'] = 6475.62, ['Z'] = 31.62}},
      [3] = {['Busy'] = false, ['Open'] = false, ['Type'] = 'drill', ['Coords'] = {['X'] = -106.37, ['Y'] = 6478.11, ['Z'] = 31.62}},
      [4] = {['Busy'] = false, ['Open'] = false, ['Type'] = 'lockpick', ['Coords'] = {['X'] = -105.44, ['Y'] = 6479.13, ['Z'] = 31.62}},
      [5] = {['Busy'] = false, ['Open'] = false, ['Type'] = 'lockpick', ['Coords'] = {['X'] = -104.11, ['Y'] = 6479.05, ['Z'] = 31.62}},
      [6] = {['Busy'] = false, ['Open'] = false, ['Type'] = 'safe', ['Coords'] = {['X'] = -102.65, ['Y'] = 6477.56, ['Z'] = 31.62}},
      [7] = {['Busy'] = false, ['Open'] = false, ['Type'] = 'drill', ['Coords'] = {['X'] = -102.47, ['Y'] = 6476.05, ['Z'] = 31.62}},
      [8] = {['Busy'] = false, ['Open'] = false, ['Type'] = 'lockpick', ['Coords'] = {['X'] = -103.33, ['Y'] = 6475.10, ['Z'] = 31.62}},
    },
  },
  -- [8] = {
  --   ['Name'] = 'Grote Bank',
  --   ['BankOpen'] = false,
  --   ['Coords'] = {['X'] = 253.96, ['Y'] = 228.13, ['Z'] = 101.68},
  --   ['Prop'] = nil,
  --   ['Menus'] = {[1] = {['Active'] = true, ['Name'] = 'Welke kaart?', ['Desc'] = 'Kom erachter welke kaar je nodig hebt..', ['Event'] = 'ls-bankrobbery:client:hack:card', ['Card'] = nil}, [2] = {['Active'] = false, ['Name'] = 'Bank Hacken', ['Desc'] = 'Begin met het overvallen van de bank.', ['Event'] = 'ls-bankrobbery:client:hack:door'}},
  -- },
}

-- // Stores \\ --

Config.Registers = {
  [1] =  {['X'] = -47.24,   ['Y'] = -1757.65, ['Z'] = 29.53,   ['Robbed'] = false, ['Store'] = 1},
  [2] =  {['X'] = -48.58,   ['Y'] = -1759.21, ['Z'] = 29.59,   ['Robbed'] = false, ['Store'] = 1},
  [3] =  {['X'] = -1486.26, ['Y'] = -378.00,  ['Z'] = 40.16,   ['Robbed'] = false, ['Store'] = 2},
  [4] =  {['X'] = -1222.03, ['Y'] = -908.32,  ['Z'] = 12.32,   ['Robbed'] = false, ['Store'] = 3},
  [5] =  {['X'] = -706.08,  ['Y'] = -915.42,  ['Z'] = 19.21,   ['Robbed'] = false, ['Store'] = 4},
  [6] =  {['X'] = -706.16,  ['Y'] = -913.50,  ['Z'] = 19.21,   ['Robbed'] = false, ['Store'] = 4},
  [7] =  {['X'] = 24.47,    ['Y'] = -1344.99, ['Z'] = 29.49,   ['Robbed'] = false, ['Store'] = 5},
  [8] =  {['X'] = 24.45,    ['Y'] = -1347.37, ['Z'] = 29.59,   ['Robbed'] = false, ['Store'] = 5},
  [9] =  {['X'] = 1134.15,  ['Y'] = -982.53,  ['Z'] = 46.41,   ['Robbed'] = false, ['Store'] = 6},
  [10] = {['X'] = 1165.05,  ['Y'] = -324.49,  ['Z'] = 69.2,    ['Robbed'] = false, ['Store'] = 7},
  [11] = {['X'] = 1164.7,   ['Y'] = -322.58,  ['Z'] = 69.2,    ['Robbed'] = false, ['Store'] = 7},
  [12] = {['X'] = 373.14,   ['Y'] = 328.62,   ['Z'] = 103.56,  ['Robbed'] = false, ['Store'] = 8},
  [13] = {['X'] = 372.57,   ['Y'] = 326.42,   ['Z'] = 103.56,  ['Robbed'] = false, ['Store'] = 8},
  [14] = {['X'] = -1818.9,  ['Y'] = 792.9,    ['Z'] = 138.08,  ['Robbed'] = false, ['Store'] = 9},
  [15] = {['X'] = -1820.17, ['Y'] = 794.28,   ['Z'] = 138.08,  ['Robbed'] = false, ['Store'] = 9},
  [16] = {['X'] = -2966.46, ['Y'] = 390.89,   ['Z'] = 15.04,   ['Robbed'] = false, ['Store'] = 10},
  [17] = {['X'] = -3041.14, ['Y'] = 583.87,   ['Z'] = 7.9,     ['Robbed'] = false, ['Store'] = 11},
  [18] = {['X'] = -3038.92, ['Y'] = 584.5,    ['Z'] = 7.9,     ['Robbed'] = false, ['Store'] = 11},
  [19] = {['X'] = -3244.56, ['Y'] = 1000.14,  ['Z'] = 12.83,   ['Robbed'] = false, ['Store'] = 12},
  [20] = {['X'] = -3242.24, ['Y'] = 999.98,   ['Z'] = 12.83,   ['Robbed'] = false, ['Store'] = 12},
  [21] = {['X'] = 549.42,   ['Y'] = 2669.06,  ['Z'] = 42.15,   ['Robbed'] = false, ['Store'] = 13},
  [22] = {['X'] = 549.05,   ['Y'] = 2671.39,  ['Z'] = 42.15,   ['Robbed'] = false, ['Store'] = 13},
  [23] = {['X'] = 1165.9,   ['Y'] = 2710.81,  ['Z'] = 38.15,   ['Robbed'] = false, ['Store'] = 14},
  [24] = {['X'] = 2676.02,  ['Y'] = 3280.52,  ['Z'] = 55.24,   ['Robbed'] = false, ['Store'] = 15},
  [25] = {['X'] = 2678.07,  ['Y'] = 3279.39,  ['Z'] = 55.24,   ['Robbed'] = false, ['Store'] = 15},
  [26] = {['X'] = 1958.96,  ['Y'] = 3741.98,  ['Z'] = 32.34,   ['Robbed'] = false, ['Store'] = 16},
  [27] = {['X'] = 1960.13,  ['Y'] = 3740.0,   ['Z'] = 32.34,   ['Robbed'] = false, ['Store'] = 16},
  [28] = {['X'] = 1728.86,  ['Y'] = 6417.26,  ['Z'] = 35.03,   ['Robbed'] = false, ['Store'] = 17},
  [29] = {['X'] = 1727.85,  ['Y'] = 6415.14,  ['Z'] = 35.03,   ['Robbed'] = false, ['Store'] = 17},
  [30] = {['X'] = -161.07,  ['Y'] = 6321.23,  ['Z'] = 31.5,    ['Robbed'] = false, ['Store'] = 18},
  [31] = {['X'] = 160.52,   ['Y'] = 6641.74,  ['Z'] = 31.6,    ['Robbed'] = false, ['Store'] = 19},
  [32] = {['X'] = 162.16,   ['Y'] = 6643.22,  ['Z'] = 31.6,    ['Robbed'] = false, ['Store'] = 19},
  [33] = {['X'] = 1696.63,  ['Y'] = 4923.93,  ['Z'] = 42.06,   ['Robbed'] = false, ['Store'] = 20},
  [34] = {['X'] = 1698.10,  ['Y'] = 4922.83,  ['Z'] = 42.06,   ['Robbed'] = false, ['Store'] = 20},
  [35] = {['X'] = 2557.13,  ['Y'] = 380.84,   ['Z'] = 108.62,  ['Robbed'] = false, ['Store'] = 21},
  [36] = {['X'] = 2554.84,  ['Y'] = 380.88,   ['Z'] = 108.62,  ['Robbed'] = false, ['Store'] = 21},
}

Config.Safes = {
  [1] =  {['X'] = -43.43,    ['Y'] = -1748.3,  ['Z'] = 29.42,  ['Robbed'] = false, ['Busy'] = false},
  [2] =  {['X'] = -1478.94,  ['Y'] = -375.5,   ['Z'] = 39.16,  ['Robbed'] = false, ['Busy'] = false},
  [3] =  {['X'] = -1220.85,  ['Y'] = -916.05,  ['Z'] = 11.32,  ['Robbed'] = false, ['Busy'] = false},
  [4] =  {['X'] = -709.74,   ['Y'] = -904.15,  ['Z'] = 19.21,  ['Robbed'] = false, ['Busy'] = false},
  [5] =  {['X'] = 28.21,     ['Y'] = -1339.14, ['Z'] = 29.49,  ['Robbed'] = false, ['Busy'] = false},
  [6] =  {['X'] = 1126.77,   ['Y'] = -980.1,   ['Z'] = 45.41,  ['Robbed'] = false, ['Busy'] = false},
  [7] =  {['X'] = 1159.46,   ['Y'] = -314.05,  ['Z'] = 69.2,   ['Robbed'] = false, ['Busy'] = false},
  [8] =  {['X'] = 378.17,    ['Y'] = 333.44,   ['Z'] = 103.56, ['Robbed'] = false, ['Busy'] = false},
  [9] =  {['X'] = -1829.27,  ['Y'] = 798.76,   ['Z'] = 138.19, ['Robbed'] = false, ['Busy'] = false},
  [10] = {['X'] = -2959.64,  ['Y'] = 387.08,   ['Z'] = 14.04,  ['Robbed'] = false, ['Busy'] = false},
  [11] = {['X'] = -3047.88,  ['Y'] = 585.61,   ['Z'] = 7.9,    ['Robbed'] = false, ['Busy'] = false},
  [12] = {['X'] = -3250.02,  ['Y'] = 1004.43,  ['Z'] = 12.83,  ['Robbed'] = false, ['Busy'] = false},
  [13] = {['X'] = 546.41,    ['Y'] = 2662.8,   ['Z'] = 42.15,  ['Robbed'] = false, ['Busy'] = false},
  [14] = {['X'] = 1169.31,   ['Y'] = 2717.79,  ['Z'] = 37.15,  ['Robbed'] = false, ['Busy'] = false},
  [15] = {['X'] = 2672.69,   ['Y'] = 3286.63,  ['Z'] = 55.24,  ['Robbed'] = false, ['Busy'] = false},
  [16] = {['X'] = 1959.26,   ['Y'] = 3748.92,  ['Z'] = 32.34,  ['Robbed'] = false, ['Busy'] = false},
  [17] = {['X'] = 1734.78,   ['Y'] = 6420.84,  ['Z'] = 35.03,  ['Robbed'] = false, ['Busy'] = false},
  [18] = {['X'] = -168.40,   ['Y'] = 6318.80,  ['Z'] = 30.58,  ['Robbed'] = false, ['Busy'] = false},
  [19] = {['X'] = 168.95,    ['Y'] = 6644.74,  ['Z'] = 31.70,  ['Robbed'] = false, ['Busy'] = false},
  [20] = {['X'] = 1707.88,   ['Y'] = 4920.41,  ['Z'] = 42.06,  ['Robbed'] = false, ['Busy'] = false},
  [21] = {['X'] = 2549.19,   ['Y'] = 384.90,   ['Z'] = 108.62, ['Robbed'] = false, ['Busy'] = false},
}

-- // Jewel \\ --

Config.JewelAlarmOn = true

Config.VitrineWeapons = {
  GetHashKey("weapon_assaultrifle"),
  GetHashKey("weapon_assaultrifle2"),
  GetHashKey("weapon_m4"),
  GetHashKey("weapon_pistol"),
  GetHashKey("weapon_combatpistol"),
  GetHashKey("weapon_browning"),
  GetHashKey("weapon_heavypistol"),
  GetHashKey("weapon_combatpistol"),
  GetHashKey("weapon_vintagepistol"),
  GetHashKey("weapon_appistol"),
}

Config.JewelHack = {
  [1] = {
    ['HackDone'] = false,
    ['Coords'] = vector3(-624.23, -242.44, 56.18),
  },
  [2] = {
    ['HackDone'] = false,
    ['Coords'] = vector3(-629.69, -227.34, 56.18),
  },
}
 
Config.Vitrines = {
  [1] = {
    ['Busy'] = false,
    ['Robbed'] = false,
    ['Coords'] = vector3(-626.97, -235.25, 38.05)
  },
  [2] = {
    ['Busy'] = false,
    ['Robbed'] = false,
    ['Coords'] = vector3(-625.91, -234.47, 38.05)
  },
  [3] = {
    ['Busy'] = false,
    ['Robbed'] = false,
    ['Coords'] = vector3(-626.79, -233.26, 38.05)
  },
  [4] = {
    ['Busy'] = false,
    ['Robbed'] = false,
    ['Coords'] = vector3(-627.87, -233.99, 38.05)
  },
  [5] = {
    ['Busy'] = false,
    ['Robbed'] = false,
    ['Coords'] = vector3(-625.51, -237.89, 38.05)
  },
  [6] = {
    ['Busy'] = false,
    ['Robbed'] = false,
    ['Coords'] = vector3(-626.65, -238.63, 38.05)
  },
  [7] = {
    ['Busy'] = false,
    ['Robbed'] = false,
    ['Coords'] = vector3(-625.03, -227.75, 38.05)
  },
  [8] = {
    ['Busy'] = false,
    ['Robbed'] = false,
    ['Coords'] = vector3(-623.93, -227.07, 38.05)
  },
  [9] = {
    ['Busy'] = false,
    ['Robbed'] = false,
    ['Coords'] = vector3(-622.90, -232.78, 38.05)
  },
  [10] = {
    ['Busy'] = false,
    ['Robbed'] = false,
    ['Coords'] = vector3(-624.29, -230.93, 38.05)
  },
  [11] = {
    ['Busy'] = false,
    ['Robbed'] = false,
    ['Coords'] = vector3(-623.88, -228.22, 38.05)
  },
  [12] = {
    ['Busy'] = false,
    ['Robbed'] = false,
    ['Coords'] = vector3(-620.42, -226.51, 38.05)
  },
  [13] = {
    ['Busy'] = false,
    ['Robbed'] = false,
    ['Coords'] = vector3(-619.49, -227.45, 38.05)
  },
  [14] = {
    ['Busy'] = false,
    ['Robbed'] = false,
    ['Coords'] = vector3(-621.16, -228.70, 38.05)
  },
  [15] = {
    ['Busy'] = false,
    ['Robbed'] = false,
    ['Coords'] = vector3(-619.76, -230.54, 38.05)
  },
  [16] = {
    ['Busy'] = false,
    ['Robbed'] = false,
    ['Coords'] = vector3(-618.27, -229.43, 38.05)
  },
  [17] = {
    ['Busy'] = false,
    ['Robbed'] = false,
    ['Coords'] = vector3(-617.44, -230.41, 38.05)
  },
  [18] = {
    ['Busy'] = false,
    ['Robbed'] = false,
    ['Coords'] = vector3(-620.25, -233.21, 38.05)
  },
  [19] = {
    ['Busy'] = false,
    ['Robbed'] = false,
    ['Coords'] = vector3(-619.02, -233.85, 38.05)
  },
  [20] = {
    ['Busy'] = false,
    ['Robbed'] = false,
    ['Coords'] = vector3(-620.13, -234.55, 38.05)
  },
}

Config.JewelProps = {
  [1] = {
    ['Heading'] = 32.65,
    ['PutOnTheGround'] = true,
    ['Prop'] = 'p_counter_04_glass',
    ['Coords'] = vector3(-627.20, -234.87, 38.53),
  },
  [2] = {
    ['Heading'] = 211.90,
    ['PutOnTheGround'] = true,
    ['Prop'] = 'p_counter_04_glass',
    ['Coords'] = vector3(-625.38, -238.32, 38.53),
  },
  [3] = {
    ['Heading'] = 211.90,
    ['PutOnTheGround'] = true,
    ['Prop'] = 'p_counter_04_glass',
    ['Coords'] = vector3(-626.33, -239.02, 38.53),
  },
  [4] = {
    ['Heading'] = 209.58,
    ['PutOnTheGround'] = true,
    ['Prop'] = 'p_counter_04_glass',
    ['Coords'] = vector3(-627.58, -234.31, 38.53),
  },
  [5] = {
    ['Heading'] = 209.58,
    ['PutOnTheGround'] = true,
    ['Prop'] = 'p_counter_04_glass',
    ['Coords'] = vector3(-626.58, -233.60, 38.53),
  },
  [6] = {
    ['Heading'] = 34.87,
    ['PutOnTheGround'] = true,
    ['Prop'] = 'p_counter_04_glass',
    ['Coords'] = vector3(-625.34, -227.39, 38.53),
  },
  [7] = {
    ['Heading'] = 214.87,
    ['PutOnTheGround'] = true,
    ['Prop'] = 'p_counter_04_glass',
    ['Coords'] = vector3(-623.62, -228.59, 38.53),
  },
  [8] = {
    ['Heading'] = 307.14,
    ['PutOnTheGround'] = true,
    ['Prop'] = 'p_counter_04_glass',
    ['Coords'] = vector3(-620.02, -226.22, 38.53),
  },
  [9] = {
    ['Heading'] = 307.14,
    ['PutOnTheGround'] = true,
    ['Prop'] = 'p_counter_04_glass',
    ['Coords'] = vector3(-619.21, -227.26, 38.53),
  },
  [10] = {
    ['Heading'] = 307.14,
    ['PutOnTheGround'] = true,
    ['Prop'] = 'p_counter_04_glass',
    ['Coords'] = vector3(-621.55, -228.88, 38.53),
  },
  [11] = {
    ['Heading'] = 307.14,
    ['PutOnTheGround'] = true,
    ['Prop'] = 'p_counter_04_glass',
    ['Coords'] = vector3(-620.14, -230.78, 38.53),
  },
  [12] = {
    ['Heading'] = 307.14,
    ['PutOnTheGround'] = true,
    ['Prop'] = 'p_counter_04_glass',
    ['Coords'] = vector3(-617.79, -229.16, 38.53),
  },
  [13] = {
    ['Heading'] = 307.14,
    ['PutOnTheGround'] = true,
    ['Prop'] = 'p_counter_04_glass',
    ['Coords'] = vector3(-617.06, -230.14, 38.53),
  },
  [14] = {
    ['Heading'] = 217.92,
    ['PutOnTheGround'] = true,
    ['Prop'] = 'p_counter_04_glass',
    ['Coords'] = vector3(-619.80, -234.88, 38.53),
  },
  [15] = {
    ['Heading'] = 217.92,
    ['PutOnTheGround'] = true,
    ['Prop'] = 'p_counter_04_glass',
    ['Coords'] = vector3(-618.81, -234.14, 38.53),
  },
  [16] = {
    ['Heading'] = 306.82,
    ['PutOnTheGround'] = true,
    ['Prop'] = 'p_counter_04_glass',
    ['Coords'] = vector3(-622.61, -232.52, 38.53),
  },
  [17] = {
    ['Heading'] = 300.16,
    ['PutOnTheGround'] = true,
    ['Prop'] = 'v_ilev_fib_atrgl3',
    ['Coords'] = vector3(-596.23, -283.84, 50.32),
  },
  [18] = {
    ['Heading'] = 36.85,
    ['PutOnTheGround'] = false,
    ['Prop'] = 'hei_prop_bank_alarm_01',
    ['Coords'] = vector3(-629.41, -230.44, 38.50),
  },
}

-- Bobcat --

Config.IsBobcatExploded = false
Config.BlowVaultCoords = vector4(890.84, -2284.82, 32.44, 87.56)

Config.MainDoorsThermited = false
Config.MainDoorsCoords = vector4(882.18, -2258.35, 32.46, 174.91)

Config.SecondDoorsUsedCard = false
Config.SecondDoorsCoords = vector4(879.71, -2267.66, 32.44, 172.36)

-- Config.BobcatSecurity = {
--   [1] = {
--     ['Model'] = 'ig_casey',
--     ['Coords'] = vector4(877.74, -2260.50, 32.44, 168.58),
--   },
--   [2] = {
--     ['Model'] = 'ig_casey',
--     ['Coords'] = vector4(874.90, -2260.91, 32.44, 168.58),
--   },
--   [3] = {
--     ['Model'] = 'ig_casey',
--     ['Coords'] = vector4(883.78, -2261.81, 32.44, 168.58),
--   },
--   [4] = {
--     ['Model'] = 'ig_casey',
--     ['Coords'] = vector4(872.22, -2265.91, 32.44, 168.58),
--   },
-- }

-- // Misc \\ --

Config.MaleNoHandshoes = {
  [0] = true, [1] = true, [2] = true, [3] = true,
  [4] = true, [5] = true, [6] = true, [7] = true,
  [8] = true, [9] = true, [10] = true, [11] = true,
  [12] = true, [13] = true, [14] = true, [15] = true,
  [18] = true, [52] = true, [53] = true,
  [54] = true, [55] = true, [56] = true, [57] = true,
  [58] = true, [59] = true, [60] = true, [61] = true,
  [62] = true, [112] = true, [113] = true, [114] = true,
  [118] = true, [125] = true, [132] = true,
}

Config.FemaleNoHandshoes = {
  [0] = true, [1] = true, [2] = true, [3] = true,
  [4] = true, [5] = true, [6] = true, [7] = true,
  [8] = true, [9] = true, [10] = true, [11] = true,
  [12] = true, [13] = true, [14] = true, [15] = true,
  [19] = true, [59] = true, [60] = true, [61] = true,
  [62] = true, [63] = true, [64] = true, [65] = true,
  [66] = true, [67] = true, [68] = true, [69] = true,
  [70] = true, [71] = true, [129] = true, [130] = true,
  [131] = true, [135] = true, [142] = true, [149] = true,
  [153] = true, [157] = true, [161] = true,[165] = true,
}