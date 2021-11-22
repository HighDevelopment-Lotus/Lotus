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

Config.Server.FrameworkTriggers = { --You can change the esx/qbcore events (IF NEEDED).
    core = 'LSCore',
    shorttag = 'ls-',
}

Config.Server.License = "" -- Your licensekey obtained from pepe-framework.com
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