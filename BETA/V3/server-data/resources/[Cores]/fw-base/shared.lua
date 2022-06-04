Shared = {}

local StringCharset = {}
local NumberCharset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end
for i = 65,  90 do table.insert(StringCharset, string.char(i)) end
for i = 97, 122 do table.insert(StringCharset, string.char(i)) end

Shared.RandomStr = function(length)
	if length > 0 then
		return Shared.RandomStr(length-1) .. StringCharset[math.random(1, #StringCharset)]
	else
		return ''
	end
end

Shared.RandomInt = function(length)
	if length > 0 then
		return Shared.RandomInt(length-1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

Shared.Trim = function(value)
	if not value then return nil end
    return (string.gsub(value, '^%s*(.-)%s*$', '%1'))
end

Shared.SplitStr = function(str, delimiter)
	local result = { }
	local from  = 1
	local delim_from, delim_to = string.find( str, delimiter, from  )
	while delim_from do
		table.insert( result, string.sub( str, from , delim_from-1 ) )
		from  = delim_to + 1
		delim_from, delim_to = string.find( str, delimiter, from  )
	end
	table.insert( result, string.sub( str, from  ) )
	return result
end
	
Shared.StarterItems = {
  ["phone"] = {amount = 1, item = "phone"},
  ["id_card"] = {amount = 1, item = "id_card"},
  ["driver_license"] = {amount = 1, item = "driver_license"},
  ["sandwich"] = {amount = 5, item = "sandwich"},
  ["lockpick"] = {amount = 2, item = "lockpick"},
}

Shared.Gangs = {
	["none"] = {
		label = "Geen ganglid",
		grades = { 
			[1] = { 
				label = "None",  
			}, 
		} 
	},
	["satudarah"] = {
		label = "Satudarah MC",
		grades = { 
			[1] = { 
				label = "Lid", 
			}, 
			[2] = { 
				label = "Kapikane", 
				boss = true,
			},
		} 
	},
	["bastards"] = {
		label = "The Bastards MC",
		grades = { 
			[1] = { 
				label = "Lid", 
			}, 
			[2] = { 
				label = "President", 
				boss = true,
			}, 
		} 
	},
	["ballas"] = {
		label = "Ballas",
		grades = { 
			[1] = { 
				label = "Member", 
			}, 
			[2] = { 
				label = "Leader", 
				boss = true,
			}, 
		} 
	},
	["aztecas"] = {
		label = "Aztecas",
		grades = { 
			[1] = { 
				label = "Member", 
			}, 
			[2] = { 
				label = "Leader", 
				boss = true,
			}, 
		} 
	},
}
Shared.Jobs = {
	["unemployed"] = {
		label = "Koos",
		defaultDuty = true,
		grades = {
			[1] = {
				label = "Werkloos",
				payment = 100,
			},
		}
	},
	["police"] = {
        label = "Politie",
        defaultDuty = true,
        grades = {
            [1] = {
                label = "Academie",
                payment = 450,
            },
            [2] = {
                label = "Wijkagent",
                payment = 500,
            },
            [3] = {
                label = "Surveillant",
                payment = 600,
            },
            [4] = {
                label = "Agent",
                payment = 620,
            },
            [5] = {
                label = "Hoofdagent",
                payment = 650,
            },
            [6] = {
                label = "Brigadier",
                payment = 680,
            },
            [7] = {
                label = "Inspecteur",
                payment = 700,
            },
            [8] = {
                label = "Hoofdinspecteur",
                payment = 750,
            },
            [9] = {
                label = "Commissaris",
                payment = 800,
            },
            [10] = {
                label = "Hoofdcommissaris",
				isboss = true,
                payment = 850,
            },
			[11] = {
				label = "Eerste hoofdcommissaris",
				isboss = true,
                payment = 1100,
            },
        },
	},
	
	["ambulance"] = {
		label = "Ambulance",
		defaultDuty = true,
		grades = {
			[1] = {
                label = "OP in opleiding",
                payment = 400,
            },
			[2] = {
                label = "Ondersteunend Personeel",
                payment = 450,
            },
			[3] = {
                label = "Broeder",
                payment = 500,
            },
			[4] = {
                label = "Verpleegkundige",
                payment = 525,
            },
			[5] = {
                label = "Specialist",
                payment = 550,
            },
			[6] = {
                label = "Geneeskundige",
                payment = 650,
            },
			[7] = {
				label = "Hoofd Geneeskunde",
				isboss = true,
                payment = 750,
            },
        },
	},

	["trucker"] = {
		label = "Dumbo",
		payment = 100,
		defaultDuty = true,
		grades = {
            [1] = {
                label = "Werknemer",
                payment = 80,
			},
		},
	},
	["taxi"] = {
		label = "Taxi",
		payment = 120,
		defaultDuty = true,
		grades = {
			[1] = {
                label = "Werknemer",
                payment = 80,
            },
			[2] = {
				label = "Boss",
				isboss = true,
                payment = 250,
            },
		},
	},
	["realestate"] = {
		label = "Ontroerend Goed",
		payment = 80,
		defaultDuty = true,
		grades = {
			[1] = {
                label = "Aannemer",
                payment = 250,
            },
			[2] = {
                label = "Eigenaar",
				boss = true,
                payment = 550,
            },
        },
	},
	["tow"] = {
		label = "Sleepdienst",
		payment = 80,
		defaultDuty = true,
		grades = {
            [1] = {
                label = "Werknemer",
                payment = 100,
			},
		},
	},
	["reporter"] = {
		label = "Los Santos Nieuws",
		payment = 80,
		defaultDuty = true,
		grades = {
            [1] = {
                label = "Journalist",
                payment = 180,
			},
		},
	},
	["judge"] = {
		label = "Hoge Raad",
		payment = 200,
		defaultDuty = true,
		grades = {
            [1] = {
                label = "Rechter",
                payment = 250,
			},
		},
	},
	["lawyer"] = {
		label = "Advocatuur",
		payment = 150,
		defaultDuty = true,
		grades = {
			[1] = {
                label = "Secretaris",
                payment = 750,
            },
            [2] = {
                label = "Medewerker",
                payment = 900,
            },
            [3] = {
                label = "Eigenaar",
				isboss = true,
                payment = 1000,
            },
		}
	},
	["cardealer"] = {
		label = "Car Dealer",
		payment = 150,
		defaultDuty = true,
		grades = {
            [1] = {
                label = "Verkoper",
                payment = 250,
            },
			[2] = {
				label = "Eigenaar",
				isboss = true,
                payment = 350,
            },
        },
	},
	["mechanic"] = {
		label = "AutoCare",
		payment = 150,
		defaultDuty = true,
		grades = {
            [1] = {
                label = "In Opleiding",
                payment = 110,
			},
            [2] = {
                label = "Automonteur",
                payment = 150,
			},
            [3] = {
                label = "Gespecialiseerde Monteur",
                payment = 250,
			},
            [4] = {
                label = "Hoofd Monteur",
                payment = 250,
			},
			[5] = {
				label = "Eigenaar",
				isboss = true,
                payment = 350,
            },
		}
	},
	["vanilla"] = {
		label = "Unicorn",
		payment = 110,
		defaultDuty = true,
		grades = {
            [1] = {
                label = "Werknemer",
                payment = 120,
			},
			[2] = {
				label = "Danser",
                payment = 125,
            },
			[3] = {
				label = "Barman",
                payment = 125,
            },
			[4] = {
				label = "Beveiliging",
                payment = 130,
            },
			[5] = {
				label = "Baas",
				isboss = true,
                payment = 120,
            },
		}
	},
	["garbage"] = {
		label = "Los Santos Garbage",
		payment = 100,
		defaultDuty = true,
		grades = {
            [1] = {
                label = "Werknemer",
                payment = 110,
			},
		},
	},
	["burger"] = {
		label = "Burgershot",
		payment = 80,
		defaultDuty = true,
		grades = {
            [1] = {
                label = "Werknemer",
                payment = 100,
			},
			[2] = {
				label = "Baas",
				isboss = true,
                payment = 250,
            },
		},
	},
	["butcher"] = {
		label = "Los Santos Slachterij",
		payment = 80,
		defaultDuty = true,
		grades = {
            [1] = {
                label = "Slachter",
                payment = 80,
			},
		},
	},
	["fueler"] = {
		label = "Fueler",
		payment = 80,
		defaultDuty = true,
		grades = {
            [1] = {
                label = "Werknemer",
                payment = 80,
			},
		},
	},
	["kledingmaker"] = {
		label = "Kledingmaker",
		payment = 80,
		defaultDuty = true,
		grades = {
            [1] = {
                label = "Werknemer",
                payment = 80,
			},
		},
	},
	["weed"] = {
		label = "Wietwinkel",
		payment = 80,
		defaultDuty = true,
		grades = {
            [1] = {
                label = "Werknemer",
                payment = 90,
			},
			[2] = {
				label = "Baas",
				isboss = true,
                payment = 110,
            },
		},
	},
	-- ["taxi"] = { 
	-- 	label = "Taxi", 
	-- 	defaultDuty = true, 
	-- 	grades = { 
	-- 		[1] = { 
	-- 			label = "Driver", 
	-- 			payment = 200, 
	-- 		}, 
	-- 	} 
	-- },
	-- ["tow"] = { 
	-- 	label = "Tow", 
	-- 	defaultDuty = false, 
	-- 	grades = { 
	-- 		[1] = { 
	-- 			label = "Driver", 
	-- 			payment = 200, 
	-- 		},
	-- 	} 
	-- },
	-- ["reporter"] = {
	-- 	label = " Los Santos News",
	-- 	defaultDuty = true,
	-- 	grades = {
	-- 		[1] = {
	-- 			label = "Internshipr",
	-- 			payment = 200,
	-- 		},
	-- 		[2] = {
	-- 			label = "Technician",
	-- 			payment = 200,
	-- 		},
	-- 		[3] = {
	-- 			label = "Reporter",
	-- 			payment = 200,
	-- 		},
	-- 		[4] = {
	-- 			label = "Editor",
	-- 			payment = 200,
	-- 		},
	-- 		[5] = {
	-- 			label = "Board Member",
	-- 			payment = 200,
	-- 		},
	-- 		[6] = {
	-- 			label = "Director",
	-- 			payment = 200,
	-- 			boss = true,
	-- 		},
	-- 	}
	-- },
	-- ["garbage"] = { 
	-- 	label = "Garbage Collector", 
	-- 	defaultDuty = true, 
	-- 	grades = { 
	-- 		[1] = { 
	-- 			label = "Driver", 
	-- 			payment = 200, 
	-- 		},
	-- 	} 
	-- },
	-- ["burger"] = {
	-- 	label = "Burgershot",
	-- 	defaultDuty = false,
	-- 	grades = {
	-- 		[1] = {
	-- 			label = "Employee",
	-- 			payment = 200,
	-- 		},
	-- 		[2] = {
	-- 			label = "Shift Supervisor",
	-- 			payment = 200,
	-- 		},
	-- 		[3] = {
	-- 			label = "Supervisor",
	-- 			boss = true,
	-- 			payment = 200,
	-- 		},
	-- 		[4] = {
	-- 			label = "Boss",
	-- 			boss = true,
	-- 			payment = 200,
	-- 		},
	-- 	}
	-- },
	-- ["police"] = {
	-- 	label = "LSPD",
	-- 	defaultDuty = true,
	-- 	grades = {
    --         [1] = {
    --             label = "Cadet",
    --             payment = 50,
    --         },
    --         [2] = {
    --             label = "Officer",
    --             payment = 75,
    --         },
    --         [3] = {
    --             label = "Senior Officer",
    --             payment = 100,
    --         },
    --         [4] = {
    --             label = "Sergeant",
    --             payment = 125,
    --         },
	-- 		[5] = {
    --             label = "Head Sergeant",
    --             payment = 150,
    --         },
    --         [6] = {
    --             label = "Lieutenant",
    --             payment = 175,
    --         },
    --         [7] = {
	-- 			label = "Assistant Chief",
	-- 			boss = true,
    --             payment = 200,
    --         },
	-- 		[8] = {
	-- 			label = "Chief",
	-- 			boss = true,
    --             payment = 200,
    --         },
	-- 	},
	-- },
	-- ["ambulance"] = {
	-- 	label = "EMS",
	-- 	defaultDuty = true,
	-- 	grades = {
	-- 		[1] = {
    --             label = "Trainee",
    --             payment = 50,
    --         },
    --         [2] = {
    --             label = "EMT",
    --             payment = 75,
    --         },
	-- 		[3] = {
    --             label = "Paramedic",
    --             payment = 100,
    --         },
	-- 		[4] = {
    --             label = "Paramedic FTO",
    --             payment = 125,
    --         },
	-- 		[5] = {
    --             label = "Lieutenant",
    --             payment = 150,
    --         },
	-- 		[6] = {
    --             label = "Captian",
	-- 			boss = true,
    --             payment = 175,
    --         },
	-- 		[7] = {
    --             label = "Assistant Chief",
	-- 			boss = true,
    --             payment = 200,
    --         },
    --         [8] = {
    --             label = "Chief",
	-- 			boss = true,
    --             payment = 200,
    --         },
    --     }
	-- },
	-- ["mechanic"] = {
	-- 	label = "Benny's",
	-- 	defaultDuty = true,
	-- 	grades = {
	-- 		[1] = {
	-- 			label = "Employee",
	-- 			payment = 200,
	-- 		},
	-- 		[2] = {
    --             label = "Shift Supervisor",
	-- 			boss = true,
    --             payment = 200,
	-- 		},
	-- 		[3] = {
    --             label = "Boss",
	-- 			boss = true,
    --             payment = 250,
	-- 		},
	-- 	}
	-- },
	-- ["tuners"] = {
	-- 	label = "Heat Tuners",
	-- 	defaultDuty = true,
	-- 	grades = {
    --         [1] = {
    --             label = "Employee",
    --             payment = 50,
	-- 		},
	-- 		[2] = {
    --             label = "Shift Supervisor",
	-- 			boss = true,
    --             payment = 200,
	-- 		},
	-- 		[3] = {
    --             label = "Boss",
	-- 			boss = true,
    --             payment = 250,
	-- 		},
	-- 	},
	-- },
	-- ["repairshop"] = {
	-- 	label = "Hayes",
	-- 	defaultDuty = true,
	-- 	grades = {
	-- 		[1] = {
	-- 			label = "Employee",
	-- 			payment = 200,
	-- 		},
	-- 		[2] = {
    --             label = "Shift Supervisor",
	-- 			boss = true,
    --             payment = 200,
	-- 		},
	-- 		[3] = {
    --             label = "Boss",
	-- 			boss = true,
    --             payment = 250,
	-- 		},
	-- 	}
	-- },
	-- ["judge"] = {
	-- 	label = "DOJ",
	-- 	defaultDuty = true,
	-- 	grades = {
	-- 		[1] = {
	-- 			label = "Judge",
	-- 			payment = 350,
	-- 		},
	-- 	}
	-- },
	-- ["lawyer"] = {
	-- 	label = "Los Santos Lawyers",
	-- 	defaultDuty = true,
	-- 	grades = {
	-- 		[1] = {
	-- 			label = "Employee",
	-- 			payment = 200,
	-- 		},
	-- 		[2] = {
    --             label = "Boss",
	-- 			boss = true,
    --             payment = 250,
	-- 		},
	-- 	}
	-- },
	-- ["realestate"] = {
	-- 	label = "Dynasty 8 Realestate",
	-- 	defaultDuty = true,
	-- 	grades = {
	-- 		[1] = {
	-- 			label = "Employee",
	-- 			payment = 200,
	-- 		},
	-- 		[2] = {
    --             label = "Boss",
	-- 			boss = true,
    --             payment = 250,
	-- 		},
	-- 	}
	-- },
	-- ["cardealer"] = {
	-- 	label = "PDM",
	-- 	defaultDuty = true,
	-- 	grades = {
	-- 		[1] = {
	-- 			label = "Employee",
	-- 			payment = 200,
	-- 		},
	-- 		[2] = {
    --             label = "Boss",
	-- 			boss = true,
    --             payment = 250,
	-- 		},
	-- 	}
	-- },
	-- ["stripclub"] = {
	-- 	label = "Stripclub",
	-- 	defaultDuty = false,
	-- 	grades = {
	-- 		[1] = {
	-- 			label = "Employee",
	-- 			payment = 200,
	-- 		},
	-- 		[2] = {
    --             label = "Boss",
	-- 			boss = true,
    --             payment = 250,
	-- 		},
	-- 	}
	-- },
	-- ["winemaker"] = {
	-- 	label = "Wine Maker",
	-- 	defaultDuty = true,
	-- 	grades = {
	-- 		[1] = {
	-- 			label = "Employee",
	-- 			payment = 200,
	-- 		},
	-- 		[2] = {
    --             label = "Boss",
	-- 			boss = true,
    --             payment = 250,
	-- 		},
	-- 	}
	-- },
	-- ["darkdoctor"] = {
	-- 	label = "Underground",
	-- 	defaultDuty = true,
	-- 	grades = {
	-- 		[1] = {
	-- 			label = "Doctor",
	-- 			payment = 200,
	-- 		},
	-- 	}
	-- },
	-- ["flightschool"] = {
	-- 	label = "Flightschool",
	-- 	defaultDuty = true,
	-- 	grades = {
	-- 		[1] = {
	-- 			label = "Employee",
	-- 			payment = 200,
	-- 		},
	-- 		[2] = {
    --             label = "Boss",
	-- 			boss = true,
    --             payment = 250,
	-- 		},
	-- 	}
	-- },
	-- ["sushi"] = {
	-- 	label = "Sushi",
	-- 	defaultDuty = true,
	-- 	grades = {
	-- 		[1] = {
	-- 			label = "Employee",
	-- 			payment = 200,
	-- 		},
	-- 		[2] = {
    --             label = "Boss",
	-- 			boss = true,
    --             payment = 250,
	-- 		},
	-- 	}
	-- },
}