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
		label = "Geen",
	},
	["biker"] = {
		label = "Motor Club",
	},
	["famiglia"] = {
		label = "La Famiglia",
	},
}

Shared.Jobs = {
	["unemployed"] = {
		label = "Werkloos",
		payment = 15,
		defaultDuty = true,
	},
	["taxi"] = {
		label = "Taxi Chauffeur",
		payment = 60,
		defaultDuty = true,
	},
	["tow"] = {
		label = "Bergnet",
		payment = 50,
		defaultDuty = false,
	},
	["reporter"] = {
		label = "Verslag Gever",
		payment = 60,
		defaultDuty = true,
	},
	["garbage"] = {
		label = "Vuilnis Medewerker",
		payment = 50,
		defaultDuty = false,
	},
	["burger"] = {
		label = "Burgershot Medewerker",
		payment = 60,
		defaultDuty = false,
	},
	["police"] = {
		label = "Politie",
		payment = 250,
		defaultDuty = true,
	},
	["ambulance"] = {
		label = "Ambulance",
		payment = 250,
		defaultDuty = true,
	},
	["mechanic"] = {
		label = "Voertuig Monteur",
		payment = 60,
		defaultDuty = true,
	},
	["repairshop"] = {
		label = "Voertuig Monteur",
		payment = 60,
		defaultDuty = true,
	},
	["judge"] = {
		label = "Rechter",
		payment = 350,
		defaultDuty = true,
	},
	["lawyer"] = {
		label = "Advocaat",
		payment = 300,
		defaultDuty = true,
	},
	["realestate"] = {
		label = "Makelaar",
		payment = 60,
		defaultDuty = true,
	},
	["cardealer"] = {
		label = "Voertuig Verkoper",
		payment = 60,
		defaultDuty = true,
	},
	["stripclub"] = {
		label = "Stripclub Medewerker",
		payment = 60,
		defaultDuty = true,
	},
	["winemaker"] = {
		label = "Wijnmaker",
		payment = 50,
		defaultDuty = true,
	},
	["darkdoctor"] = {
		label = "Onderwereld Dokter",
		payment = 60,
		defaultDuty = true,
	},
	["flightschool"] = {
		label = "Vliegschool",
		payment = 60,
		defaultDuty = true,
	},
	["sushi"] = {
		label = "Sushi Mederwerker",
		payment = 60,
		defaultDuty = false,
	},
	["motordealer"] = {
		label = "Motor Dealer",
		payment = 60,
		defaultDuty = true,
	},
}