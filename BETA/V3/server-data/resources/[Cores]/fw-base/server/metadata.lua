LSCore.Players = {}
LSCore.Player = {}

LSCore.Player.CheckPlayerData = function(source, PlayerData)
	PlayerData = PlayerData ~= nil and PlayerData or {}
	PlayerData.source = source
	PlayerData.citizenid = PlayerData.citizenid ~= nil and PlayerData.citizenid or LSCore.Player.CreateCitizenId()
	PlayerData.email = PlayerData.email ~= nil and PlayerData.email or PlayerData.charinfo.firstname:lower()..''..PlayerData.charinfo.lastname:lower()..'@lossantos.nl'
	PlayerData.steam = PlayerData.steam ~= nil and PlayerData.steam or LSCore.Functions.GetIdentifier(source, "steam")
	PlayerData.license = PlayerData.license ~= nil and PlayerData.license or LSCore.Functions.GetIdentifier(source, "license")
	PlayerData.name = GetPlayerName(source)
	PlayerData.cid = PlayerData.cid ~= nil and PlayerData.cid or 1
	--  // Money Shit \\ --
	PlayerData.money = PlayerData.money ~= nil and PlayerData.money or {}
	PlayerData.money['cash'] = PlayerData.money['cash'] ~= nil and PlayerData.money['cash'] or 0
	PlayerData.money['bank'] = PlayerData.money['bank'] ~= nil and PlayerData.money['bank'] or Config.Money.MoneyTypes['bank']
	PlayerData.money['casino'] = PlayerData.money['casino'] ~= nil and PlayerData.money['casino'] or 0
	PlayerData.money['crypto'] = PlayerData.money['crypto'] ~= nil and PlayerData.money['crypto'] ~= 0 and PlayerData.money['crypto'] or LSCore.Config.Money.ConfigDefaultCrypto
	-- // Char Info \\ --
	PlayerData.charinfo = PlayerData.charinfo ~= nil and PlayerData.charinfo or {}
	PlayerData.charinfo.firstname = PlayerData.charinfo.firstname ~= nil and PlayerData.charinfo.firstname or "Firstname"
	PlayerData.charinfo.lastname = PlayerData.charinfo.lastname ~= nil and PlayerData.charinfo.lastname or "Lastname"
	PlayerData.charinfo.birthdate = PlayerData.charinfo.birthdate ~= nil and PlayerData.charinfo.birthdate or "00-00-0000"
	PlayerData.charinfo.gender = PlayerData.charinfo.gender ~= nil and PlayerData.charinfo.gender or 0
	PlayerData.charinfo.nationality = PlayerData.charinfo.nationality ~= nil and PlayerData.charinfo.nationality or "Nederlands"
	PlayerData.charinfo.phone = PlayerData.charinfo.phone ~= nil and PlayerData.charinfo.phone or "06"..math.random(11111111, 99999999)
	PlayerData.charinfo.account = PlayerData.charinfo.account ~= nil and PlayerData.charinfo.account or "NL0"..math.random(1,9)..LSCore.Shared.RandomInt(3):upper()..math.random(1111,9999)..math.random(1111,9999)..math.random(11,99)
    -- // Health Shit \\ --
	PlayerData.metadata = PlayerData.metadata ~= nil and PlayerData.metadata or {}
    PlayerData.metadata["health"] = PlayerData.metadata["health"]  ~= nil and PlayerData.metadata["health"] or 200
    PlayerData.metadata["armor"] = PlayerData.metadata["armor"]  ~= nil and PlayerData.metadata["armor"] or 0
	PlayerData.metadata["hunger"] = PlayerData.metadata["hunger"] ~= nil and PlayerData.metadata["hunger"] or 100
	PlayerData.metadata["thirst"] = PlayerData.metadata["thirst"] ~= nil and PlayerData.metadata["thirst"] or 100
    PlayerData.metadata["stress"] = PlayerData.metadata["stress"] ~= nil and PlayerData.metadata["stress"] or 0
	PlayerData.metadata["isdead"] = PlayerData.metadata["isdead"] ~= nil and PlayerData.metadata["isdead"] or false
	PlayerData.metadata["lucky"] = PlayerData.metadata["lucky"] ~= nil and PlayerData.metadata["lucky"] or false
	-- // DNA \\ --
	PlayerData.metadata["bloodtype"] = PlayerData.metadata["bloodtype"] ~= nil and PlayerData.metadata["bloodtype"] or LSCore.Config.Player.Bloodtypes[math.random(1, #LSCore.Config.Player.Bloodtypes)]
	PlayerData.metadata["fingerprint"] = PlayerData.metadata["fingerprint"] ~= nil and PlayerData.metadata["fingerprint"] or LSCore.Player.CreateDnaId('finger')
	PlayerData.metadata["slimecode"] = PlayerData.metadata["slimecode"] ~= nil and PlayerData.metadata["slimecode"] or LSCore.Player.CreateDnaId('slime')
    PlayerData.metadata["haircode"] = PlayerData.metadata["haircode"] ~= nil and PlayerData.metadata["haircode"] or LSCore.Player.CreateDnaId('hair')
    -- // Reputations \\ --
	PlayerData.metadata["baan"] = PlayerData.metadata["baan"] ~= nil and PlayerData.metadata["baan"] or 0
	PlayerData.metadata["runs"] = PlayerData.metadata["runs"] ~= nil and PlayerData.metadata["runs"] or 0
	PlayerData.metadata["drugs"] = PlayerData.metadata["drugs"] ~= nil and PlayerData.metadata["drugs"] or 0
	PlayerData.metadata["craftingrep"] = PlayerData.metadata["craftingrep"] ~= nil and PlayerData.metadata["craftingrep"] or 0
	-- // Work Shizzle \\ --
	PlayerData.metadata["jailitems"] = PlayerData.metadata["jailitems"] ~= nil and PlayerData.metadata["jailitems"] or {}
	PlayerData.metadata["courtitems"] = PlayerData.metadata["courtitems"] ~= nil and PlayerData.metadata["courtitems"] or {}
	PlayerData.metadata["callsign"] = PlayerData.metadata["callsign"] ~= nil and PlayerData.metadata["callsign"] or "NO CALLSIGN"
	PlayerData.metadata["duty-vehicle"] = PlayerData.metadata["duty-vehicle"] ~= nil and PlayerData.metadata["duty-vehicle"] or {['STANDAARD'] = true, ['AUDI'] = false, ['UNMARKED'] = false, ['MOTOR'] = false, ['HELI'] = false}
	PlayerData.metadata["ishighcommand"] = PlayerData.metadata["ishighcommand"] ~= nil and PlayerData.metadata["ishighcommand"] or false
	-- // Appartment \\ 
	PlayerData.metadata["appartment-id"] = PlayerData.metadata["appartment-id"] ~= nil and PlayerData.metadata["appartment-id"] or LSCore.Player.CreateAppartmentId()
	PlayerData.metadata["phone"] = PlayerData.metadata["phone"] ~= nil and PlayerData.metadata["phone"] or {}
	-- // Miscs \\ --
	PlayerData.metadata["firstscene"] = PlayerData.metadata["firstscene"] ~= nil and PlayerData.metadata["firstscene"] or false
	PlayerData.metadata["tracker"] = PlayerData.metadata["tracker"] ~= nil and PlayerData.metadata["tracker"] or false
	PlayerData.metadata['walkstyle'] = PlayerData.metadata['walkstyle'] ~= nil and PlayerData.metadata['walkstyle'] or nil
	PlayerData.metadata['paycheck'] = PlayerData.metadata['paycheck'] ~= nil and PlayerData.metadata['paycheck'] or 0
	PlayerData.metadata["iscrafting"] = PlayerData.metadata["iscrafting"] ~= nil and PlayerData.metadata["iscrafting"] or false
    PlayerData.metadata["ishandcuffed"] = PlayerData.metadata["ishandcuffed"] ~= nil and PlayerData.metadata["ishandcuffed"] or false
    PlayerData.metadata["jailtime"] = PlayerData.metadata["jailtime"] ~= nil and PlayerData.metadata["jailtime"] or 0
    PlayerData.metadata["commandbinds"] = PlayerData.metadata["commandbinds"] ~= nil and PlayerData.metadata["commandbinds"] or {}
    PlayerData.metadata["licences"] = PlayerData.metadata["licences"] ~= nil and PlayerData.metadata["licences"] or {["driver"] = true, ['hunting'] = nil, ['flying'] = false}
	-- // Skills \\ --
	PlayerData.skills = PlayerData.skills ~= nil and PlayerData.skills or {}
	PlayerData.skills["lockpick"] = PlayerData.skills["lockpick"] ~= nil and PlayerData.skills["lockpick"] or 0
	PlayerData.skills["hacking"] = PlayerData.skills["hacking"] ~= nil and PlayerData.skills["hacking"] or 0
	-- // Addiction \\ --
	PlayerData.addiction = PlayerData.addiction ~= nil and PlayerData.addiction or {}
	PlayerData.addiction["cocaine"] = PlayerData.addiction["cocaine"] ~= nil and PlayerData.addiction["cocaine"] or 0
	PlayerData.addiction["weed"] = PlayerData.addiction["weed"] ~= nil and PlayerData.addiction["weed"] or 0
	PlayerData.addiction["fastfood"] = PlayerData.addiction["fastfood"] ~= nil and PlayerData.addiction["fastfood"] or 0
	-- // Jobs
	PlayerData.job = PlayerData.job ~= nil and PlayerData.job or {}
	PlayerData.job.name = PlayerData.job.name ~= nil and PlayerData.job.name or "unemployed"
	PlayerData.job.label = PlayerData.job.label ~= nil and PlayerData.job.label or "Werkloos"
	PlayerData.job.gradelabel = PlayerData.job.gradelabel ~= nil and PlayerData.job.gradelabel or "Werkloos"
    PlayerData.job.grade = PlayerData.job.grade ~= nil and PlayerData.job.grade or 1
    PlayerData.job.isboss = PlayerData.job.isboss ~= nil and PlayerData.job.isboss or false
	PlayerData.job.payment = PlayerData.job.payment ~= nil and PlayerData.job.payment or 10
	PlayerData.job.plate = PlayerData.job.plate ~= nil and PlayerData.job.plate or 'none'
	PlayerData.job.serial = PlayerData.job.serial ~= nil and PlayerData.job.serial or LSCore.Player.CreateWeaponSerial()
    PlayerData.job.onduty = PlayerData.job.onduty ~= nil and PlayerData.job.onduty or true
	-- Gangs
	PlayerData.gang = PlayerData.gang ~= nil and PlayerData.gang or {}
	PlayerData.gang.name = PlayerData.gang.name ~= nil and PlayerData.gang.name or "none"
	PlayerData.gang.label = PlayerData.gang.label ~= nil and PlayerData.gang.label or "Geen"
	PlayerData.gang.gradelabel = PlayerData.gang.gradelabel ~= nil and PlayerData.gang.gradelabel or "Gangloos"
    -- // Position \\ --
	PlayerData.position = PlayerData.position ~= nil and PlayerData.position or {}
	PlayerData.inventory = LSCore.Player.LoadInventory(PlayerData.citizenid)
	PlayerData.metadata['phonedata'] = PlayerData.metadata['phonedata'] or {
        SerialNumber = LSCore.Player.CreateSerialNumber(),
        InstalledApps = {},
    }
	LSCore.Player.CreatePlayer(PlayerData)
end
