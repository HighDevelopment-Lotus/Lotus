-- ## GABZ - PACIFIC BANK
-- ## COORDINATES: 223.313, 208.295, 105.521

-- Employees gate (first metal door)
table.insert(Config.DoorList, {
	authorizedJobs = { ['bank']=0 },
	objCoords = vector3(256.3116, 220.6578, 106.4296),
	objHeading = 340.00003051758,		
	objHash = -222270721, -- hei_v_ilev_bk_gate_pris
	maxDistance = 2.0,
	garage = false,
	slides = false,
	locked = true,
	audioRemote = true,
	lockpick = false,
	fixText = true,
	audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- oldMethod = true,
	-- autoLock = 1000
})

-- Security gate (with digicode)
table.insert(Config.DoorList, {
	authorizedJobs = { ['bank']=0 },
	objCoords = vector3(262.198, 222.5188, 106.4296),
	objHash = 746855201, -- hei_v_ilev_bk_gate2_pris
	objHeading = 250.00004577636,		
	maxDistance = 2.0,
	garage = false,
	locked = true,
	slides = false,
	lockpick = false,
	audioRemote = true,
	fixText = false,
	audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- oldMethod = true,
	-- autoLock = 1000
})

-- Stair door (left to the main entry)
table.insert(Config.DoorList, {
	authorizedJobs = { ['bank']=0 },
	objCoords = vector3(237.7704, 227.87, 106.426),
	objHeading = 340.00003051758,		
	objHash = 1956494919, -- v_ilev_bk_door
	maxDistance = 2.0,
	garage = false,
	locked = true,
	slides = false,
	lockpick = false,
	audioRemote = false,
	fixText = false,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- oldMethod = true,
	-- autoLock = 1000
})

-- DOWNSTAIRS -------------------------------------------------------------------------------------

-- Big vault door
table.insert(Config.DoorList, {
	authorizedJobs = { ['bank']=0 },
	objCoords = vector3(255.2282, 223.976, 102.3932),
	textCoords = vector3(253.8474, 224.7674, 102.2656),
	objHeading = 160.00001525878,
	objHash = 961976194, -- v_ilev_bk_vaultdoor
	maxDistance = 2.5,
	lockpick = false,
	slides = false,
	locked = true,
	audioRemote = true,
	garage = false,		
	audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	setText = true,
	-- fixText = false,
	-- oldMethod = true,
	-- autoLock = 1000
})

-- Vault inside gate 1
table.insert(Config.DoorList, {	
	authorizedJobs = { ['bank']=0 },
	objCoords = vector3(251.8576, 221.0654, 101.8324), -- 
	objHeading = 160.00001525878,
	objHash = -1508355822, -- hei_v_ilev_bk_safegate_pris
	maxDistance = 2.0,
	lockpick = false,
	slides = false,
	locked = true,
	garage = false,		
	audioRemote = true,
	audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	fixText = false,
	-- oldMethod = true,
	-- autoLock = 1000
})

-- Vault inside gate 2
table.insert(Config.DoorList, {
	authorizedJobs = { ['bank']=0 },
	objCoords = vector3(261.3004, 214.5052, 101.8324),
	objHeading = 250.00004577636,
	objHash = -1508355822, -- hei_v_ilev_bk_safegate_pris
	maxDistance = 3.0,
	lockpick = false,
	slides = false,
	fixText = false,
	locked = true,
	audioRemote = true,
	garage = false,		
	audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- oldMethod = true,
	-- autoLock = 1000
})

-- UPSTAIRS ---------------------------------------------------------------------------------------

-- desk 1
table.insert(Config.DoorList, {
	authorizedJobs = { ['bank']=0 },
	objCoords = vector3(262.5366, 215.0576, 110.4328),
	objHeading = 69.999992370606,
	objHash = 964838196, -- v_ilev_bk_door2
	maxDistance = 2.0,
	garage = false,
	locked = true,
	lockpick = false,
	slides = false,
	fixText = false,
	audioRemote = false,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- desk 2
table.insert(Config.DoorList, {
	authorizedJobs = { ['bank']=0 },
	objCoords = vector3(260.8578, 210.4452, 110.4328),
	objHeading = 69.999992370606,
	objHash = 964838196, -- v_ilev_bk_door2
	maxDistance = 2.0,
	garage = false,
	locked = true,
	lockpick = false,
	slides = false,
	fixText = false,
	audioRemote = false,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})