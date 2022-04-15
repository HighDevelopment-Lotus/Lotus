LSCore = {}
LSCore.Config = Config
LSCore.Shared = Shared
LSCore.ServerCallbacks = {}
LSCore.UseableItems = {}

-- // Functions \\ --

function GetCoreObject()
	return LSCore
end

-- Webhooks = {
--     ["default"] = "https://discord.com/api/webhooks/938888023540637827/nQmnpBQSqGVJmIdOcPtsqTkV9xt604QgUhNGd1xPlVATvt53EyRBtXYovc8_qqjy453T",
--     ["anticheat"] = "https://discord.com/api/webhooks/862105679435137064/H3vCRWYhpAzpcrM8PB-JxYkaHJO8Ragi0afxEZKIPe45hlWN4N2JWh6rBeDnmy69JuOk",
--     ["playermoney"] = "https://discord.com/api/webhooks/938888126967976026/gBoXjdT_IaW_8Fm6yaO33ygKSQ1aVyONwFEm9HLNqFnahyZLqE-3aXxN7Q1rqlhFoorO",
--     ["playerinventory"] = "https://discord.com/api/webhooks/938888212770877450/wgPo2JWMuW7OVDWKhh1ImwI8DceVR3DVZv0J2TmcnlvQ-MWDlpr_DqwWkOvxXieke33p",
--     ["robbing"] = "https://discord.com/api/webhooks/938888314591805490/Tx54mPbqxZHIHpgMoF8b_MmYS693c8zDn9QmvTGyLLT7Zu3zG7HouPvc69JGDW0zqyL3",
--     ["cuffing"] = "https://discord.com/api/webhooks/938888424755200000/7VzRuJIl1MT-7mhFifB0iIRvvntXfAiFwztiOekcrz7uuFutGgOaEmUYHqRjXpy3aALv",
--     ["drop"] = "https://discord.com/api/webhooks/938888563553091635/4a18zHo-vbVatpbxM4_DfBEfV_kt4ZI4VlBG_pUYNAeEWJOKQEXE7z8-YdPVAavIPCm3",
--     ["trunk"] = "https://discord.com/api/webhooks/938888670017097738/1BbyQrHWfCY2zCTMprUXRVzKJaSCF2B95P7XXuX7m-IcXjxUufxf-As-FzIOW3OJFXdk",
--     ["stash"] = "https://discord.com/api/webhooks/938888719551823962/W04BNVrpdzd9BIA1xKoIJeVLzLei8Oi5mwlXM_skNb91jMwIvMekMAbdvGtA_5KoxC6n",
--     ["glovebox"] = "https://discord.com/api/webhooks/938888776179122239/siyR1oxRDz-rkMBRG4yk9mZWNBCpl4LfEPCWtmGJZQIzO37Qu1JIc4Zd4ImwoLZEC96X",
--     ["banking"] = "https://discord.com/api/webhooks/938889069717520385/6UfM73r-aG_i0HF3A16-QXXQrVbNW7Z_Ui2iNHABtLiLtswW-KgptfFt1xNzlqyr1Upm",
--     ["vehicleshop"] = "https://discord.com/api/webhooks/938889115926138901/48DxYkZhJRmvRGNVBwBNUMsqw2TZ4y2IDdB2D6d64mXv0nNs0G57YYLUzZKX_hQPsagA",
--     ["vehicleupgrades"] ="https://discord.com/api/webhooks/862107931330478170/hZlsCKNq-aeoCYZYhCggMHBjCPnI4LsfiS6uKR25EgPfZ8tPvJHmHLvNriOlVVv3gmzt", 
--     ["shops"] = "https://discord.com/api/webhooks/938889175262957678/uh8ZIDCwl8LmWy7w2sfloSvAg7qfLyV_HdHgdSmMjU0WGU3lH-EP_P9jJ-xM9XAsWjV0", 
--     ["storerobbery"] = "https://discord.com/api/webhooks/938889402564902912/hGmtvOczIdQl3UZbOurDMQSy4lyUQueGyIwMIcxrXn__G0qcv--tHjeQMHgtLTxfELM1",
--     ["dealers"] = "https://discord.com/api/webhooks/938889259069353995/NczEJ6B6eLzqe38YGwkzUUaRfaBszKv8CMghgeIkbGXbyxuDj0Docs2wTF6G8G_p0Jmg",
--     ["bankrobbery"] = "https://discord.com/api/webhooks/938889402564902912/hGmtvOczIdQl3UZbOurDMQSy4lyUQueGyIwMIcxrXn__G0qcv--tHjeQMHgtLTxfELM1",
--     ["death"] = "https://discord.com/api/webhooks/938889766768885801/tM8K0RwlUPkE_T13RbFAyi6zLpnarUoIx4h87isSL4u6JZGxddTM7H0UjZOcbOed02IN",
--     ["joinleave"] = "https://discord.com/api/webhooks/938889870670176347/gFDRYBt9FIjszDgPAR5balU0yXNmcR_pSPDZg6wANHmvPO328k1SNGFkiQd1F9Kz5WL3",
--     ['chat'] = "https://discord.com/api/webhooks/938889705834045543/PG2ArRGicLlHcgys1gNIxHPN7iASxBnTvVIR8VOck9Pm9D7aLRN9R7JV5VmahPyFY90Z",
--     ['bans'] = "https://discord.com/api/webhooks/862105679435137064/H3vCRWYhpAzpcrM8PB-JxYkaHJO8Ragi0afxEZKIPe45hlWN4N2JWh6rBeDnmy69JuOk",
--     ['heist'] = "https://discord.com/api/webhooks/923690182031605810/vKXULs9xylNx61n70NkGB17Hc17KLmMYqY38OQ5ZpaVm8FAKxKQ5wUi3MX13m1bHQlVz",
--     ['humanelabs'] = "https://discord.com/api/webhooks/938889402564902912/hGmtvOczIdQl3UZbOurDMQSy4lyUQueGyIwMIcxrXn__G0qcv--tHjeQMHgtLTxfELM1",
--     ["housing"] = "https://discord.com/api/webhooks/938889562342715482/reBlJxP_1XQRp1yPoDYQI537levzL08vgmMn9XaxRUCi1hhwdlrXSjkrryRCEX04Safy",
--     ["casino"] = "https://discord.com/api/webhooks/948839597788516362/HllAfCoxAx8-re_3quXXfxnunu4Ff0Ld0GRM0BKBTovFln1C-5ESHDju64Q9CUd9TncT",
--     ["cheaters"] = "https://discord.com/api/webhooks/951019906898489384/awfMswXTrSKmeIv_WgaTafDH0fjb1sG04cnie0WiPSCzPnXxh1QtLGePwra-oO-879Sk",
-- }

-- Colors = {
--     ["default"] = 16711680,
--     ["blue"] = 25087,
--     ["green"] = 762640,
--     ["white"] = 16777215,
--     ["black"] = 0,
--     ["orange"] = 16743168,
--     ["lightgreen"] = 65309,
--     ["yellow"] = 15335168,
--     ["turqois"] = 62207,
--     ["pink"] = 16711900,
--     ["red"] = 16711680,
-- }

-- RegisterServerEvent('framework-logs:server:SendLog')
-- AddEventHandler('framework-logs:server:SendLog', function(name, title, color, message, tagEveryone)
--     local tag = tagEveryone ~= nil and tagEveryone or false
--     local webHook = Webhooks[name] ~= nil and Webhooks[name] or Webhooks["default"]
--     local embedData = {
--         {
--          ["title"] = title,
--          ["color"] = Colors[color] ~= nil and Colors[color] or Colors["default"],
--          ["footer"] = {
--          ["text"] = os.date("%c"),
--          },
--          ["description"] = message,
--         }
--     }
--     Citizen.Wait(100)
--     if tag then
--       PerformHttpRequest(webHook, function(err, text, headers) end, 'POST', json.encode({ username = "QuackCity Logs",embeds = embedData}), { ['Content-Type'] = 'application/json' })
--       Citizen.Wait(200)
--       PerformHttpRequest(webHook, function(err, text, headers) end, 'POST', json.encode({ username = "QuackCity Logs", content = "@everyone"}), { ['Content-Type'] = 'application/json' })
--     else
--       PerformHttpRequest(webHook, function(err, text, headers) end, 'POST', json.encode({ username = "QuackCity Logs",embeds = embedData}), { ['Content-Type'] = 'application/json' })
--     end
-- end)