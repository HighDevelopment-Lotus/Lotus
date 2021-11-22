local NetProp, AllProps, HasProp = {}, {}, false

function AddProp(Name)
    if Config.PropList[Name] ~= nil then
        if not HasProp then
          HasProp = true
          RequestModelHash(Config.PropList[Name]['prop'])
          local CurrentProp = CreateObject(Config.PropList[Name]['hash'], 0, 0, 0, true, false, false)
          local PropNetId = ObjToNet(CurrentProp)
          SetNetworkIdExistsOnAllMachines(PropNetId, true)
          SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(CurrentProp), true)
          AttachEntityToEntity(CurrentProp, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), Config.PropList[Name]['bone-index']['bone']), Config.PropList[Name]['bone-index']['X'], Config.PropList[Name]['bone-index']['Y'], Config.PropList[Name]['bone-index']['Z'], Config.PropList[Name]['bone-index']['XR'], Config.PropList[Name]['bone-index']['YR'], Config.PropList[Name]['bone-index']['ZR'], true, true, false, true, 1, true)
          table.insert(NetProp, PropNetId)
          table.insert(AllProps, CurrentProp)
        end
    end 
end

function RemoveProp()
    for k, v in pairs(NetProp) do
      NetworkRequestControlOfEntity(NetToObj(v))
      SetEntityAsMissionEntity(NetToObj(v), true, true)
      DeleteObject(NetToObj(v))
    end
    for k, v in pairs(AllProps) do
      NetworkRequestControlOfEntity(v)
      SetEntityAsMissionEntity(v, true, true)
      DeleteObject(v)
    end
    AllProps, NetProp = {}, {}
    HasProp = false
end

function GetPropStatus()
  return HasProp
end

function RequestModelHash(Model)
   RequestModel(Model)
	 while not HasModelLoaded(Model) do
	     Wait(1)
   end
end

AddEventHandler('onResourceStop', function(resource)
  RemoveProp()
end)