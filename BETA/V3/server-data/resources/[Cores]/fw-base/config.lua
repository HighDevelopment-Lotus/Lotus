Config = {}

Config.Money = {}
Config.Server = {} 
Config.Player = {}
Config.Server.PermissionList = {} 

Config.IdentifierType = "steam"

Config.Priority = {}

Config.RequireSteam = true

Config.PriorityOnly = false

Config.DisableHardCap = true

Config.ConnectTimeOut = 600

Config.QueueTimeOut = 90

Config.EnableGrace = true

Config.GracePower = 2

Config.GraceTime = 240

Config.JoinDelay = 60000

Config.ShowTemp = false
Config.Money.MoneyTypes = {['cash'] = 0, ['bank'] = 5000, ['casino'] = 0}
Config.Money.DontAllowMinus = {'cash', 'casino', 'bank'}
Config.Money.ConfigDefaultCrypto = {['Bitflop'] = 0, ['Bittop'] = 0}

Config.Player.MaxWeight = 130000
Config.Player.MaxInvSlots = 45
Config.Server.License = "" -- Licensekey from pepe-framework.com
Config.Server.Username = "" -- Username on pepe-framework.com
Config.Server.FrameworkTriggers = {
    main = 'LSCore:GetObject',
    notify = 'LSCore:Notify',
    unload = 'LSCore:Client:OnPlayerUnload',
    uplayer = 'LSCore:Player:UpdatePlayerData',
    jobupdate = 'LSCore:Client:OnJobUpdate',
    gangupdate = 'LSCore:Client:OnGangUpdate',
    moneychange = 'framework-ui:client:money:change',
    playerdata = 'LSCore:Player:SetPlayerData',
    log = 'framework-logs:server:SendLog',
    newinventorytrigger = 'framework-inv',
    multichar = 'framework-multichar:client:open:select',
    inventoryitem = 'framework-inv:client:item:box',
    updateplayer = 'framework-inv:client:update:player',
    dropitem = 'framework-inv:server:add🆕drop:core',
    inventoryname = 'fw-inv',
}

-- Config.Server.FrameworkTriggers['dropitem']
Config.Player.Bloodtypes = {
    "A+",
    "A-",
    "B+",
    "B-",
    "AB+",
    "AB-",
    "O+",
    "O-",
}


Config.Language = {
    joining = "\xF0\x9F\x8E\x89Inladen..",
    connecting = "\xE2\x8F\xB3Verbinden...",
    idrr = "\xE2\x9D\x97[Queue] Error: Kan geen id's ophalen, probeer opnieuw op te starten.",
    err = "\xE2\x9D\x97[Queue] Er was een error",
    pos = "\xF0\x9F\x90\x8CJe staat %d/%d in de wachtrij \xF0\x9F\x95\x9C%s",
    connectingerr = "\xE2\x9D\x97[Queue] Error: Kan niet toevoegen aan de wachtrij..",
    timedout = "\xE2\x9D\x97[Queue] Error: Timed out",
    wlonly = "\xE2\x9D\x97[Queue] Je moet een whitelist hebben om de server te joinen..",
    steam = "\xE2\x9D\x97 [Queue] Error: Steam moet aan staan.."
}