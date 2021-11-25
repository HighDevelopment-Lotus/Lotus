Config = {}

Config.Money = {}
Config.Server = {} 
Config.Player = {}
Config.Server.PermissionList = {} 

Config.IdentifierType = "steam"

Config.Money.MoneyTypes = {['cash'] = 0, ['bank'] = 500, ['casino'] = 0}
Config.Money.DontAllowMinus = {'cash', 'casino'}
Config.Money.ConfigDefaultCrypto = {['Bitflop'] = 0, ['Bittop'] = 0}

Config.Server.License = "LOT" -- Licensekey from pepe-framework.com
Config.Server.Username = "" -- Username on pepe-framework.com
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