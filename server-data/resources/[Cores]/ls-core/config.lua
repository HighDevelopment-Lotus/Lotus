Config = {}

Config.Money = {}
Config.Server = {} 
Config.Player = {}
Config.Server.PermissionList = {} 

Config.IdentifierType = "steam"

Config.Money.MoneyTypes = {['cash'] = 0, ['bank'] = 500, ['casino'] = 0}
Config.Money.DontAllowMinus = {'cash', 'casino'}
Config.Money.ConfigDefaultCrypto = {['Bitflop'] = 0, ['Bittop'] = 0}

Config.Player.MaxWeight = 130000
Config.Player.MaxInvSlots = 45
Config.Server.License = "LOT" -- Licensekey from pepe-framework.com
Config.Server.Username = "" -- Username on pepe-framework.com
Config.Server.FrameworkTriggers = {
    main = 'LSCore:GetObject',
    notify = 'LSCore:Notify',
    unload = 'LSCore:Client:OnPlayerUnload',
    uplayer = 'LSCore:Player:UpdatePlayerData',
    jobupdate = 'LSCore:Client:OnJobUpdate',
    gangupdate = 'LSCore:Client:OnGangUpdate',
    moneychange = 'ls-ui:client:money:change',
    playerdata = 'LSCore:Player:SetPlayerData',
    log = 'ls-logs:server:SendLog',
    newinventorytrigger = 'ls-inventory-new',
    multichar = 'ls-multichar:client:open:select',
    inventoryitem = 'ls-inventory-new:client:item:box',
    updateplayer = 'ls-inventory-new:client:update:player',
    dropitem = 'ls-inventory-new:server:add🆕drop:core',
} 

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