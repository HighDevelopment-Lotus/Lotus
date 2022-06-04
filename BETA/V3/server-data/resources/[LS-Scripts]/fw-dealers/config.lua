Config = Config or {}

local StringCharset = {}
local NumberCharset = {}

Config.DealerActive = false
Config.CurrentDealerData = {}

-- Police Settings:
Config.PoliceDatabaseName = "police"	-- set the exact name from your jobs database for police
Config.PoliceNotfiyEnabled = true		-- police notification upon truck robbery enabled (true) or disabled (false)
Config.PoliceBlipShow = true			-- enable or disable blip on map on police notify
Config.PoliceBlipTime = 30				-- miliseconds that blip is active on map (this value is multiplied with 4 in the script)
Config.PoliceBlipRadius = 50.0			-- set radius of the police notify blip
Config.PoliceBlipAlpha = 250			-- set alpha of the blip
Config.PoliceBlipColor = 5				-- set blip color

-- Job Settings:
Config.CooldownTime = 25					-- Set cooldown time for doing drug jobs in minutes
Config.HackerDevice = "hackerDevice"		-- Name in database for hacker device
Config.HackingBlocks = 5					-- Amount of code-blocks, player needs to match per side.
Config.HackingTime = 30						-- Amount of time player has to complete the minigame.
Config.JobVan = 'rumpo2'					-- spawn name for job van

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end
for i = 65,  90 do table.insert(StringCharset, string.char(i)) end
for i = 97, 122 do table.insert(StringCharset, string.char(i)) end

Config.RandomStr = function(length)
	if length > 0 then
		return Config.RandomStr(length-1) .. StringCharset[math.random(1, #StringCharset)]
	else
		return ''
	end
end

Config.RandomInt = function(length)
	if length > 0 then
		return Config.RandomInt(length-1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

Config.Dealers = {
    [1] = {
        ['Name'] = 'Oma Gerda',
        ['Type'] = 'medic-dealer',
        ['Coords'] = 'GA HET LEKKER ZOEKEN JOH',
        ['Products'] = {
            [1] = {
                name = "painkillers",
                price = 450,
                amount = 50,
                resetamount = 50,
                info = {},
                type = "item",
                slot = 1,
            },
        },
    },
    [2] = {
        ['Name'] = 'Maris',
        ['Type'] = 'weapon-dealer',
        ['Coords'] = 'GA HET LEKKER ZOEKEN JOH',
        ['Products'] = {
            [1] = {
                name = "weapon_sledgeham",
                price = 3500,
                amount = 0,
                resetamount = 10,
                info = {},
                type = "weapon",
                slot = 1,
            },
            [2] = {
                name = "weapon_hatchet",
                price = 4500,
                amount = 0,
                resetamount = 10,
                info = {},
                type = "weapon",
                slot = 2,
            },
        },
    },
    [3] = {
        ['Name'] = 'Jankbal',
        ['Type'] = 'weapon-dealer',
        ['Coords'] = 'GA HET LEKKER ZOEKEN JOH',
        ['Products'] = {
            [1] = {
                name = "weapon_katana",
                price = 3500,
                amount = 0,
                resetamount = 10,
                info = {},
                type = "weapon",
                slot = 1,
            },
            [2] = {
                name = "weapon_hammer",
                price = 3500,
                amount = 0,
                resetamount = 10,
                info = {},
                type = "weapon",
                slot = 2,
            },
        },
    },
    [4] = {
        ['Name'] = 'Jan',
        ['Type'] = 'item-dealer',
        ['Coords'] = 'GA HET LEKKER ZOEKEN JOH',
        ['Products'] = {
            [1] = {
                name = "key-a",
                price = 15000,
                amount = 10,
                resetamount = 2,
                info = {},
                type = "item",
                slot = 1,
            },
        },
    },
    [5] = {
        ['Name'] = 'Klaas',
        ['Type'] = 'item-dealer',
        ['Coords'] = 'GA HET LEKKER ZOEKEN JOH',
        ['Products'] = {
            [1] = {
                name = "key-b",
                price = 15000,
                amount = 10,
                resetamount = 2,
                info = {},
                type = "item",
                slot = 1,
            },
        },
    },
    [6] = {
        ['Name'] = 'Kees',
        ['Type'] = 'item-dealer',
        ['Coords'] = 'GA HET LEKKER ZOEKEN JOH',
        ['Products'] = {
            [1] = {
                name = "key-c",
                price = 15000,
                amount = 10,
                resetamount = 2,
                info = {},
                type = "item",
                slot = 1,
            },
        },
    },
    -- [6] = {
    --     ['Name'] = 'Kees',
    --     ['Type'] = 'item-dealer',
    --     ['Coords'] = 'GA HET LEKKER ZOEKEN JOH',
    --     ['Products'] = {
    --         [1] = {
    --             name = "key-c",
    --             price = 15000,
    --             amount = 10,
    --             resetamount = 2,
    --             info = {},
    --             type = "item",
    --             slot = 1,
    --         },
    --     },
    -- },
}

-- Random

Config.DealerLocations = {
    [1] = {
        ['Coords'] = vector4(2221.88, 5614.79, 54.9, 106.54),
        ['Hints'] = {
          [1] = 'Ga van min land af!',
          [2] = 'Dat is een 6320.',
          [3] = 'Wil je niet aan betsie zitten!',
        },
    },
    [2] = {
        ['Coords'] = vector4(-1041.20, -519.58, 36.29, 117.13),
        ['Hints'] = {
          [1] = 'Verse broodjes tekoop!',
          [2] = 'Eeeeeen Actie!',
          [3] = 'Wat wordt hier toch allemaal voor actie gemaakt joh?',
        },
    },
    [3] = {
        ['Coords'] = vector4(1293.88, -3345.92, 5.9, 21.70),
        ['Hints'] = {
          [1] = 'Dit is een trap maar hij gaat naar nergens?',
          [2] = 'Dat zou ik niet durven hoor zo hoog!',
          [3] = 'Als ik er naar kijk wordt ik er al zeeziek van!',
        },
    },
    [4] = {
        ['Coords'] = vector4(-1683.16, -1107.47, 13.58, 146.42),
        ['Hints'] = {
          [1] = 'Fototje kopen?',
          [2] = 'Een grote foto kost maar $7',
          [3] = 'Jouw gezicht op een mok wow!',
        },
    },
    [5] = {
        ['Coords'] = vector4(-1683.16, -1107.47, 13.58, 146.42),
        ['Hints'] = {
          [1] = 'Wat zullen we vandaag aan de haak slaan?',
          [2] = 'Sow er staat hier zelfs een arcade kast joh.',
          [3] = 'Dineren in de buitenlucht heerlijk.',
        },
    },
    [6] = {
        ['Coords'] = vector4(732.89, 2523.42, 73.22, 269.15),
        ['Hints'] = {
          [1] = 'Hallo?!? Zijn we live?',
          [2] = 'Voor de heerlijke hits luister u naar....',
          [3] = 'Ik hou hier maar geen rood doekje voor..',
        },
    },
    [7] = {
        ['Coords'] = vector4(2560.04, 381.78, 108.62, 296.99),
        ['Hints'] = {
          [1] = 'Ik heb nog nooit iemand bij deze winkel gezien..',
          [2] = 'Er staat zoveel hier maar toch zie ik nooit iemand..',
        },
    },
    [8] = {
        ['Coords'] = vector4(-2296.59, 360.66, 174.60, 326.10),
        ['Hints'] = {
          [1] = 'In frankrijk hebben ze nog een grotere versie hier van!',
          [2] = 'De wielen van de bus gaan rond en rond, Rond en rond!',
        },
    },
}
-- Random dealer
Config.DealerWeapons = {
    [1] = {
      ['WeaponId'] = "WEAPON_KNUCKLE",
      ['Prices'] = {
          ['Max'] = 6500,
          ['Min'] = 5000,
      },
      ['Chance'] = 70,
      ['MinOnline'] = 3,
    },
    [2] = {
      ['WeaponId'] = "WEAPON_SLEDGEHAM",
      ['Prices'] = {
          ['Max'] = 6500,
          ['Min'] = 5000,
      },
      ['Chance'] = 70,
      ['MinOnline'] = 3,
    },
    [3] = {
      ['WeaponId'] = "WEAPON_UNICORN",
      ['Prices'] = {
          ['Max'] = 6500,
          ['Min'] = 5000,
      },
      ['Chance'] = 70,
      ['MinOnline'] = 3,
    },
    [4] = {
      ['WeaponId'] = "WEAPON_SNSPISTOL_MK2",
      ['Prices'] = {
          ['Max'] = 32000,
          ['Min'] = 23000,
      },
      ['Chance'] = 10,
      ['MinOnline'] = 15,
    },
    [5] = {
      ['WeaponId'] = "WEAPON_VINTAGEPISTOL",
      ['Prices'] = {
          ['Max'] = 75000,
          ['Min'] = 30000,
      },
      ['Chance'] = 5,
      ['MinOnline'] = 20,
    },
    [6] = {
      ['WeaponId'] = "WEAPON_SAWNOFFSHOTGUN",
      ['Prices'] = {
          ['Max'] = 65000,
          ['Min'] = 55000,
      },
      ['Chance'] = 5,
      ['MinOnline'] = 30,
    },
    [6] = {
      ['WeaponId'] = "WEAPON_KNIFE",
      ['Prices'] = {
          ['Max'] = 5000,
          ['Min'] = 3000,
      },
      ['Chance'] = 80,
      ['MinOnline'] = 2,
    },
}

-- Coke collection

-- List of Drugs:
Config.ListOfDrugs = {
	{ drug = 'coke', label = 'Coke', Enabled = true, BuyPrice = 7500, MinReward = 1, MaxReward = 3 },
	{ drug = 'meth', label = 'Meth', Enabled = true, BuyPrice = 6000, MinReward = 2, MaxReward = 6 },
	{ drug = 'weed', label = 'Weed', Enabled = true, BuyPrice = 3500, MinReward = 4, MaxReward = 10 },
}

-- Job Location & Settings:
Config.Jobs = {
    { 
		Spot = vector3(-219.13305664063,6382.3969726563,31.604875564575),
		Heading = 46.104721069336,
		LockpickPos = vector3(-220.72117614746,6381.3217773438,31.556158065796),
		LockpickHeading = 316.11254882812,
		InProgress = false,
		VanSpawned = false,
		GoonsSpawned = false,
		JobPlayer = false,
		Goons = {
			NPC1 = { x = -224.59748840332, y = 6383.2241210938, z = 31.51745223999, h = 347.59951782226, ped = 'G_M_Y_Lost_02', animDict = 'amb@world_human_cop_idles@female@base', animName = 'base', weapon = 'WEAPON_PISTOL', },
			NPC2 = { x = -222.18724060059, y = 6390.8276367188, z = 31.731483459473, h = 132.96998596192, ped = 'G_M_Y_MexGang_01', animDict = 'rcmme_amanda1', animName = 'stand_loop_cop', weapon = 'WEAPON_PISTOL', },
			NPC3 = { x = -207.90756225586, y = 6375.7329101563, z = 31.543397903442, h = 77.105667114258, ped = 'G_M_Y_SalvaBoss_01', animDict = 'amb@world_human_leaning@male@wall@back@legs_crossed@base', animName = 'base', weapon = 'WEAPON_PISTOL' },
			NPC4 = { x = -215.0399017334, y = 6369.32421875, z = 31.49330329895, h = 3.3780143260956, ped = 'G_M_Y_Lost_02', animDict = 'amb@world_human_cop_idles@female@base', animName = 'base', weapon = 'WEAPON_PISTOL', },
			NPC5 = { x = -221.62728881836, y = 6375.7763671875, z = 35.193054199219, h = 36.372509002686, ped = 'G_M_Y_MexGang_01', animDict = 'rcmme_amanda1', animName = 'stand_loop_cop', weapon = 'WEAPON_PISTOL', }
		}
	},
	{ 
		Spot = vector3(-679.55017089844,5797.9360351563,17.330942153931),
		Heading = 243.62330627442,
		LockpickPos = vector3(-678.30072021484,5799.3623046875,17.330938339233),
		LockpickHeading = 158.37776184082,
		InProgress = false,
		VanSpawned = false,
		GoonsSpawned = false,
		JobPlayer = false,
		Goons = {
			NPC1 = { x = -679.2060546875, y = 5801.8061523438, z = 19.747180938721, h = 188.85772705078, ped = 'G_M_Y_Lost_02', animDict = 'amb@world_human_cop_idles@female@base', animName = 'base', weapon = 'WEAPON_PISTOL', },
			NPC2 = { x = -684.60620117188, y = 5796.0415039063, z = 17.330934524536, h = 155.99533081054, ped = 'G_M_Y_MexGang_01', animDict = 'rcmme_amanda1', animName = 'stand_loop_cop', weapon = 'WEAPON_MICROSMG', },
			NPC3 = { x = -669.90759277344, y = 5796.826171875, z = 17.330947875977, h = 133.18479919434, ped = 'G_M_Y_SalvaBoss_01', animDict = 'amb@world_human_leaning@male@wall@back@legs_crossed@base', animName = 'base', weapon = 'WEAPON_PISTOL' },
			NPC4 = { x = -676.41986083984, y = 5790.3002929688, z = 17.330978393555, h = 238.11218261718, ped = 'G_M_Y_Lost_02', animDict = 'amb@world_human_cop_idles@female@base', animName = 'base', weapon = 'WEAPON_PISTOL', }
		}
	},
}

-- Job Delivery Location:
Config.DeliverySpot = {
	vector3(1243.6381835938,-3263.3635253906,5.5918521881104),
}

-- Job Delivery Marker Setting:
Config.DeliveryDrawDistance  = 50.0
Config.DeliveryMarkerType  = 27
Config.DeliveryMarkerScale  = { x = 5.0, y = 5.0, z = 1.0 }
Config.DeliveryMarkerColor  = { r = 240, g = 52, b = 52, a = 100 }
