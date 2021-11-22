Config = Config or {}

Config.ScrapyardLocations = {
    [1] = {['Name'] = 'Yellow Jack', ['X'] = 2352.27, ['Y'] = 3133.19, ['Z'] = 48.20},
   -- [2] = {['Name'] = 'Secret Location', ['X'] = 2352.27, ['Y'] = 3133.19, ['Z'] = 48.20}
}

Config.CanScrap = true

Config.OpenedBins = {}

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
}

Config.BinItems = {
 'plastic',  
 'metalscrap',  
 'copper', 
 'aluminum',
 'iron',
 'steel',
 'rubber',
 'glass',
}

Config.CarItems = {
  'plastic',  
  'metalscrap',  
  'copper', 
  'aluminum',
  'iron',
  'steel',
  'rubber',
  'glass',
}

Config.RecycleProps = {
 'prop_boxpile_05a',
 'prop_boxpile_06b',
 'prop_boxpile_02b',
 'prop_boxpile_09a',
 'prop_boxpile_08a',
}

Config.Recycle = {
	['Outside'] = vector3(-322.24, -1545.86, 31.01),
	['Inside'] = vector3(992.35, -3097.83, -38.99),
	['Deliver'] = vector3(997.61, -3091.91, -38.99),
	['Props'] = {
		[1] = {
			['Prop'] = 'prop_toolchest_05',
			['Coords'] = vector3(996.64, -3099.46, -38.99),
			['Heading'] = 88.97,
			['FixGround'] = true,
			['Visible'] = true,
			['IsBox'] = false,
		},
		[2] = {
			['Prop'] = 'v_ind_meatwash',
			['Coords'] = vector3(995.09, -3100.01, -39.45),
			['Heading'] = 269.77,
			['FixGround'] = false,
			['Visible'] = false,
			['IsBox'] = false,
		},
		[3] = {
			['Coords'] = vector3(1026.73, -3096.39, -38.99), -- Begaande
			['Heading'] = 268.64,
			['FixGround'] = true,
			['Visible'] = true,
			['IsBox'] = true,
		},
		[4] = {
			['Coords'] = vector3(1026.55, -3093.98, -38.99), -- Begaande
			['Heading'] = 271.68,
			['FixGround'] = true,
			['Visible'] = true,
			['IsBox'] = true,
		},
		[5] = {
			['Coords'] = vector3(1026.56, -3091.65, -38.99), -- Begaande
			['Heading'] = 267.11,
			['FixGround'] = true,
			['Visible'] = true,
			['IsBox'] = true,
		},
		[6] = {
			['Coords'] = vector3(1018.07, -3091.46, -38.99), -- Begaande
			['Heading'] = 90.68,
			['FixGround'] = true,
			['Visible'] = true,
			['IsBox'] = true,
		},
		[7] = {
			['Coords'] = vector3(1015.80, -3091.54, -38.99), -- Begaande
			['Heading'] = 90.68,
			['FixGround'] = true,
			['Visible'] = true,
			['IsBox'] = true,
		},
		[8] = {
			['Coords'] = vector3(1013.41, -3091.54, -38.99), -- Begaande
			['Heading'] = 90.68,
			['FixGround'] = true,
			['Visible'] = true,
			['IsBox'] = true,
		},
		[9] = {
			['Coords'] = vector3(1010.86, -3091.59, -38.99), -- Begaande
			['Heading'] = 90.68,
			['FixGround'] = true,
			['Visible'] = true,
			['IsBox'] = true,
		},
		[10] = {
			['Coords'] = vector3(1008.54, -3091.57, -38.99), -- Begaande
			['Heading'] = 90.68,
			['FixGround'] = true,
			['Visible'] = true,
			['IsBox'] = true,
		},
		[11] = {
			['Coords'] = vector3(1006.09, -3091.62, -38.99), -- Begaande
			['Heading'] = 90.68,
			['FixGround'] = true,
			['Visible'] = true,
			['IsBox'] = true,
		},
		[12] = {
			['Coords'] = vector3(1003.64, -3091.62, -38.99), -- Begaande
			['Heading'] = 90.68,
			['FixGround'] = true,
			['Visible'] = true,
			['IsBox'] = true,
		},
		[13] = {
			['Coords'] = vector3(1003.70, -3096.96, -38.99), -- Begaande
			['Heading'] = 354.04,
			['FixGround'] = true,
			['Visible'] = true,
			['IsBox'] = true,
		},
		[14] = {
			['Coords'] = vector3(1006.10, -3097.20, -38.99), -- Begaande
			['Heading'] = 354.04,
			['FixGround'] = true,
			['Visible'] = true,
			['IsBox'] = true,
		},
		[15] = {
			['Coords'] = vector3(1008.49, -3097.17, -38.99), -- Begaande
			['Heading'] = 354.04,
			['FixGround'] = true,
			['Visible'] = true,
			['IsBox'] = true,
		},
		[16] = {
			['Coords'] = vector3(1011.00, -3096.95, -38.99), -- Begaande
			['Heading'] = 354.04,
			['FixGround'] = true,
			['Visible'] = true,
			['IsBox'] = true,
		},
		[17] = {
			['Coords'] = vector3(1013.37, -3097.01, -38.99), -- Begaande
			['Heading'] = 354.04,
			['FixGround'] = true,
			['Visible'] = true,
			['IsBox'] = true,
		},
		[18] = {
			['Coords'] = vector3(1015.71, -3096.91, -38.99), -- Begaande
			['Heading'] = 354.04,
			['FixGround'] = true,
			['Visible'] = true,
			['IsBox'] = true,
		},
		[19] = {
			['Coords'] = vector3(1018.05, -3097.07, -38.99), -- Begaande
			['Heading'] = 354.04,
			['FixGround'] = true,
			['Visible'] = true,
			['IsBox'] = true,
		},
		[20] = {
			['Coords'] = vector3(1026.77, -3106.49, -38.99), -- Begaande
			['Heading'] = 268.64,
			['FixGround'] = true,
			['Visible'] = true,
			['IsBox'] = true,
		},
		[21] = {
			['Coords'] = vector3(1026.85, -3109.09, -38.99), -- Begaande
			['Heading'] = 268.64,
			['FixGround'] = true,
			['Visible'] = true,
			['IsBox'] = true,
		},
		[22] = {
			['Coords'] = vector3(1026.73, -3111.37, -38.99), -- Begaande
			['Heading'] = 268.64,
			['FixGround'] = true,
			['Visible'] = true,
			['IsBox'] = true,
		},
		[23] = {
			['Coords'] = vector3(1015.72, -3103.12, -38.99), -- Begaande
			['Heading'] = 354.04,
			['FixGround'] = true,
			['Visible'] = true,
			['IsBox'] = true,
		},
		[24] = {
			['Coords'] = vector3(1013.39, -3102.85, -38.99), -- Begaande
			['Heading'] = 354.04,
			['FixGround'] = true,
			['Visible'] = true,
			['IsBox'] = true,
		},
		[25] = {
			['Coords'] = vector3(1010.89, -3103.10, -38.99), -- Begaande
			['Heading'] = 354.04,
			['FixGround'] = true,
			['Visible'] = true,
			['IsBox'] = true,
		},
		[26] = {
			['Coords'] = vector3(1008.51, -3102.85, -38.99), -- Begaande
			['Heading'] = 354.04,
			['FixGround'] = true,
			['Visible'] = true,
			['IsBox'] = true,
		},
		[27] = {
			['Coords'] = vector3(1005.89, -3102.80, -38.99), -- Begaande
			['Heading'] = 354.04,
			['FixGround'] = true,
			['Visible'] = true,
			['IsBox'] = true,
		},
		[28] = {
			['Coords'] = vector3(1003.71, -3102.89, -38.99), -- Begaande
			['Heading'] = 354.04,
			['FixGround'] = true,
			['Visible'] = true,
			['IsBox'] = true,
		},
		[29] = {
			['Coords'] = vector3(993.17, -3106.48, -38.99), -- Begaande
			['Heading'] = 268.64,
			['FixGround'] = true,
			['Visible'] = true,
			['IsBox'] = true,
		},
		[30] = {
			['Coords'] = vector3(993.22, -3108.88, -38.99), -- Begaande
			['Heading'] = 268.64,
			['FixGround'] = true,
			['Visible'] = true,
			['IsBox'] = true,
		},
		[31] = {
			['Coords'] = vector3(993.30, -3111.29, -38.99), -- Begaande
			['Heading'] = 268.64,
			['FixGround'] = true,
			['Visible'] = true,
			['IsBox'] = true,
		},

		[32] = {
			['Coords'] = vector3(1018.08, -3102.62, -38.99), -- Begaande
			['Heading'] = 357.01,
			['FixGround'] = true,
			['Visible'] = true,
			['IsBox'] = true,
		},
		[33] = {
			['Coords'] = vector3(1018.22, -3108.46, -38.99), -- Begaande
			['Heading'] = 357.01,
			['FixGround'] = true,
			['Visible'] = true,
			['IsBox'] = true,
		},
		[34] = {
			['Coords'] = vector3(1015.78, -3108.64, -38.99), -- Begaande
			['Heading'] = 357.01,
			['FixGround'] = true,
			['Visible'] = true,
			['IsBox'] = true,
		},
		[35] = {
			['Coords'] = vector3(1013.28, -3108.43, -38.99), -- Begaande
			['Heading'] = 357.01,
			['FixGround'] = true,
			['Visible'] = true,
			['IsBox'] = true,
		},
		[36] = {
			['Coords'] = vector3(1010.99, -3108.61, -38.99), -- Begaande
			['Heading'] = 357.01,
			['FixGround'] = true,
			['Visible'] = true,
			['IsBox'] = true,
		},
		[37] = {
			['Coords'] = vector3(1008.59, -3108.45, -38.99), -- Begaande
			['Heading'] = 357.01,
			['FixGround'] = true,
			['Visible'] = true,
			['IsBox'] = true,
		},
		[38] = {
			['Coords'] = vector3(1006.10, -3108.68, -38.99), -- Begaande
			['Heading'] = 357.01,
			['FixGround'] = true,
			['Visible'] = true,
			['IsBox'] = true,
		},
		[39] = {
			['Coords'] = vector3(1003.72, -3108.43, -38.99), -- Begaande
			['Heading'] = 357.01,
			['FixGround'] = true,
			['Visible'] = true,
			['IsBox'] = true,
		},
	},
}

Config.RecycleCrafting = {
    [1] = {
        ['Label'] = 'Metaal Schroot',
        ['ItemName'] = 'metalscrap',
        ['Slot'] = 1,
        ['Amount'] = 100,
        ['Info'] = '',
        ['Weight'] = 1000,
        ['Image'] = 'metalscrap.png',
        ['AddingPoints'] = 0,
        ['PointsNeeded'] = 0,
        ['Cost'] = {
            [1] = {
                ['Label'] = 'Recycle Materiaal',
                ['ItemName'] = 'recycle-mats',
                ['Image'] = 'recycle-mats.png',
                ['Amount'] = 1,
            },
        },
    },
    [2] = {
        ['Label'] = 'Staal',
        ['ItemName'] = 'steel',
        ['Slot'] = 2,
        ['Amount'] = 100,
        ['Info'] = '',
        ['Weight'] = 100,
        ['Image'] = 'steel.png',
        ['AddingPoints'] = 0,
        ['PointsNeeded'] = 0,
        ['Cost'] = {
            [1] = {
                ['Label'] = 'Recycle Materiaal',
                ['ItemName'] = 'recycle-mats',
                ['Image'] = 'recycle-mats.png',
                ['Amount'] = 1,
            },
        },
    },
    [3] = {
        ['Label'] = 'Koper',
        ['ItemName'] = 'copper',
        ['Slot'] = 3,
        ['Amount'] = 100,
        ['Info'] = '',
        ['Weight'] = 100,
        ['Image'] = 'copper.png',
        ['AddingPoints'] = 0,
        ['PointsNeeded'] = 0,
        ['Cost'] = {
            [1] = {
                ['Label'] = 'Recycle Materiaal',
                ['ItemName'] = 'recycle-mats',
                ['Image'] = 'recycle-mats.png',
                ['Amount'] = 1,
            },
        },
    },
    [4] = {
        ['Label'] = 'Ijzer',
        ['ItemName'] = 'iron',
        ['Slot'] = 4,
        ['Amount'] = 100,
        ['Info'] = '',
        ['Weight'] = 100,
        ['Image'] = 'ironplate.png',
        ['AddingPoints'] = 0,
        ['PointsNeeded'] = 0,
        ['Cost'] = {
            [1] = {
                ['Label'] = 'Recycle Materiaal',
                ['ItemName'] = 'recycle-mats',
                ['Image'] = 'recycle-mats.png',
                ['Amount'] = 1,
            },
        },
    },
    [5] = {
        ['Label'] = 'Aluminium',
        ['ItemName'] = 'aluminum',
        ['Slot'] = 5,
        ['Amount'] = 100,
        ['Info'] = '',
        ['Weight'] = 100,
        ['Image'] = 'aluminum.png',
        ['AddingPoints'] = 0,
        ['PointsNeeded'] = 0,
        ['Cost'] = {
            [1] = {
                ['Label'] = 'Recycle Materiaal',
                ['ItemName'] = 'recycle-mats',
                ['Image'] = 'recycle-mats.png',
                ['Amount'] = 1,
            },
        },
    },
    [6] = {
        ['Label'] = 'Plastic',
        ['ItemName'] = 'plastic',
        ['Slot'] = 6,
        ['Amount'] = 100,
        ['Info'] = '',
        ['Weight'] = 100,
        ['Image'] = 'plastic.png',
        ['AddingPoints'] = 0,
        ['PointsNeeded'] = 0,
        ['Cost'] = {
            [1] = {
                ['Label'] = 'Recycle Materiaal',
                ['ItemName'] = 'recycle-mats',
                ['Image'] = 'recycle-mats.png',
                ['Amount'] = 1,
            },
        },
    },
    [7] = {
        ['Label'] = 'Glasplaat',
        ['ItemName'] = 'glass',
        ['Slot'] = 7,
        ['Amount'] = 100,
        ['Info'] = '',
        ['Weight'] = 100,
        ['Image'] = 'glassplate.png',
        ['AddingPoints'] = 0,
        ['PointsNeeded'] = 0,
        ['Cost'] = {
            [1] = {
                ['Label'] = 'Recycle Materiaal',
                ['ItemName'] = 'recycle-mats',
                ['Image'] = 'recycle-mats.png',
                ['Amount'] = 1,
            },
        },
    },
    [8] = {
        ['Label'] = 'Rubber',
        ['ItemName'] = 'rubber',
        ['Slot'] = 8,
        ['Amount'] = 100,
        ['Info'] = '',
        ['Weight'] = 100,
        ['Image'] = 'rubber.png',
        ['AddingPoints'] = 0,
        ['PointsNeeded'] = 0,
        ['Cost'] = {
            [1] = {
                ['Label'] = 'Recycle Materiaal',
                ['ItemName'] = 'recycle-mats',
                ['Image'] = 'recycle-mats.png',
                ['Amount'] = 1,
            },
        },
    },
}