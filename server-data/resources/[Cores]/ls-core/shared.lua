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
}

Shared.Gangs = {
	["none"] = {
		label = "No Gang Affiliaton",
		grades = { 
			[1] = { 
				label = "None",  
			}, 
		} 
	},
	["biker"] = {
		label = "Lost MC",
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
	["famiglia"] = {
		label = "La Famiglia",
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
		label = "Unemployed",
		defaultDuty = true,
		grades = {
			[1] = {
				label = "Unemployed",
				payment = 100,
			},
		}
	},
	["taxi"] = { 
		label = "Taxi", 
		defaultDuty = true, 
		grades = { 
			[1] = { 
				label = "Driver", 
				payment = 200, 
			}, 
		} 
	},
	["tow"] = { 
		label = "Tow", 
		defaultDuty = false, 
		grades = { 
			[1] = { 
				label = "Driver", 
				payment = 200, 
			},
		} 
	},
	["gopostal"] = { 
		label = "GoPostal", 
		defaultDuty = false, 
		grades = { 
			[1] = { 
				label = "Delivery Driver", 
				payment = 200, 
			},
		} 
	},
	["reporter"] = {
		label = " Los Santos News",
		defaultDuty = true,
		grades = {
			[1] = {
				label = "Internshipr",
				payment = 200,
			},
			[2] = {
				label = "Technician",
				payment = 200,
			},
			[3] = {
				label = "Reporter",
				payment = 200,
			},
			[4] = {
				label = "Editor",
				payment = 200,
			},
			[5] = {
				label = "Board Member",
				payment = 200,
			},
			[6] = {
				label = "Director",
				payment = 200,
				boss = true,
			},
		}
	},
	["garbage"] = { 
		label = "Garbage Collector", 
		defaultDuty = true, 
		grades = { 
			[1] = { 
				label = "Driver", 
				payment = 200, 
			},
		} 
	},
	["trucker"] = { 
		label = "Cumbo", 
		defaultDuty = true, 
		grades = { 
			[1] = { 
				label = "Delivery Driver", 
				payment = 200, 
			}, 
		} 
	},
	["takeaway"] = {
		label = "Takeaway",
		defaultDuty = true,
		grades = {
			[1] = {
				label = "Delivery Driver",
				payment = 200,
			},
		}
	},
	["burger"] = {
		label = "Burgershot",
		defaultDuty = false,
		grades = {
			[1] = {
				label = "Employee",
				payment = 200,
			},
			[2] = {
				label = "Shift Supervisor",
				payment = 200,
			},
			[3] = {
				label = "Supervisor",
				boss = true,
				payment = 200,
			},
			[4] = {
				label = "Boss",
				boss = true,
				payment = 200,
			},
		}
	},
	["police"] = {
		label = "LSPD",
		defaultDuty = true,
		grades = {
            [1] = {
                label = "Cadet",
                payment = 50,
            },
            [2] = {
                label = "Officer",
                payment = 75,
            },
            [3] = {
                label = "Senior Officer",
                payment = 100,
            },
            [4] = {
                label = "Sergeant",
                payment = 125,
            },
			[5] = {
                label = "Head Sergeant",
                payment = 150,
            },
            [6] = {
                label = "Lieutenant",
                payment = 175,
            },
            [7] = {
				label = "Assistant Chief",
				boss = true,
                payment = 200,
            },
			[8] = {
				label = "Chief",
				boss = true,
                payment = 200,
            },
		},
	},
	["ambulance"] = {
		label = "EMS",
		defaultDuty = true,
		grades = {
			[1] = {
                label = "Trainee",
                payment = 50,
            },
            [2] = {
                label = "EMT",
                payment = 75,
            },
			[3] = {
                label = "Paramedic",
                payment = 100,
            },
			[4] = {
                label = "Paramedic FTO",
                payment = 125,
            },
			[5] = {
                label = "Lieutenant",
                payment = 150,
            },
			[6] = {
                label = "Captian",
				boss = true,
                payment = 175,
            },
			[7] = {
                label = "Assistant Chief",
				boss = true,
                payment = 200,
            },
            [8] = {
                label = "Chief",
				boss = true,
                payment = 200,
            },
        }
	},
	["mechanic"] = {
		label = "Benny's",
		defaultDuty = true,
		grades = {
			[1] = {
				label = "Employee",
				payment = 200,
			},
			[2] = {
                label = "Shift Supervisor",
				isboss = true,
                payment = 200,
			},
			[3] = {
                label = "Boss",
				isboss = true,
                payment = 250,
			},
		}
	},
	["tuners"] = {
		label = "Heat Tuners",
		defaultDuty = true,
		grades = {
            [1] = {
                label = "Employee",
                payment = 50,
			},
			[2] = {
                label = "Shift Supervisor",
				isboss = true,
                payment = 200,
			},
			[3] = {
                label = "Boss",
				isboss = true,
                payment = 250,
			},
		},
	},
	["repairshop"] = {
		label = "Hayes",
		defaultDuty = true,
		grades = {
			[1] = {
				label = "Employee",
				payment = 200,
			},
			[2] = {
                label = "Shift Supervisor",
				isboss = true,
                payment = 200,
			},
			[3] = {
                label = "Boss",
				isboss = true,
                payment = 250,
			},
		}
	},
	["electronic"] = {
		label = "LSDWP",
		defaultDuty = true,
		grades = {
			[1] = {
				label = "Electrician",
				payment = 200,
			},
		}
	},
	["judge"] = {
		label = "DOJ",
		defaultDuty = true,
		grades = {
			[1] = {
				label = "Judge",
				payment = 350,
			},
		}
	},
	["lawyer"] = {
		label = "Los Santos Lawyers",
		defaultDuty = true,
		grades = {
			[1] = {
				label = "Employee",
				payment = 200,
			},
			[2] = {
                label = "Boss",
				isboss = true,
                payment = 250,
			},
		}
	},
	["realestate"] = {
		label = "Dynasty 8 Realestate",
		defaultDuty = true,
		grades = {
			[1] = {
				label = "Employee",
				payment = 200,
			},
			[2] = {
                label = "Boss",
				isboss = true,
                payment = 250,
			},
		}
	},
	["cardealer"] = {
		label = "PDM",
		defaultDuty = true,
		grades = {
			[1] = {
				label = "Employee",
				payment = 200,
			},
			[2] = {
                label = "Boss",
				isboss = true,
                payment = 250,
			},
		}
	},
	["stripclub"] = {
		label = "Stripclub",
		defaultDuty = false,
		grades = {
			[1] = {
				label = "Employee",
				payment = 200,
			},
			[2] = {
                label = "Boss",
				isboss = true,
                payment = 250,
			},
		}
	},
	["pizza"] = {
		label = "Pizzeria",
		defaultDuty = false,
		grades = {
			[1] = {
				label = "Employee",
				payment = 200,
			},
			[2] = {
                label = "Boss",
				isboss = true,
                payment = 250,
			},
		}
	},
	["winemaker"] = {
		label = "Wine Maker",
		defaultDuty = true,
		grades = {
			[1] = {
				label = "Employee",
				payment = 200,
			},
			[2] = {
                label = "Boss",
				isboss = true,
                payment = 250,
			},
		}
	},
	["darkdoctor"] = {
		label = "Underground",
		defaultDuty = true,
		grades = {
			[1] = {
				label = "Doctor",
				payment = 200,
			},
		}
	},
	["flightschool"] = {
		label = "Flightschool",
		defaultDuty = true,
		grades = {
			[1] = {
				label = "Employee",
				payment = 200,
			},
			[2] = {
                label = "Boss",
				isboss = true,
                payment = 250,
			},
		}
	},
	["sushi"] = {
		label = "Sushi",
		defaultDuty = true,
		grades = {
			[1] = {
				label = "Employee",
				payment = 200,
			},
			[2] = {
                label = "Boss",
				isboss = true,
                payment = 250,
			},
		}
	},
}