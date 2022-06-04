-- if GetConvar("sv_environment", "prod") == "debug" then
  RegisterCommand("pzadd", function(src, args)
    TriggerEvent("polyzone:pzadd")
  end)

  RegisterCommand("pzundo", function(src, args)
    TriggerEvent("polyzone:pzundo")
  end)

  RegisterCommand("pzfinish", function(src, args)
    TriggerEvent("polyzone:pzfinish")
  end)

  RegisterCommand("pzlast", function(src, args)
    TriggerEvent("polyzone:pzlast")
  end)

  RegisterCommand("pzcancel", function(src, args)
    TriggerEvent("polyzone:pzcancel")
  end)

  RegisterCommand("pzcomboinfo", function (src, args)
      TriggerEvent("polyzone:pzcomboinfo")
  end)
-- end

Citizen.CreateThread(function()
  TriggerEvent('chat:addSuggestion', '/pzcreate', 'Starts creation of a zone for PolyZone of one of the available types: circle, box, poly', {
    {name="zoneType", help="Zone Type (required)"},
  })

  TriggerEvent('chat:addSuggestion', '/pzadd', 'Adds point to zone.', {})
  TriggerEvent('chat:addSuggestion', '/pzundo', 'Undoes the last point added.', {})
  TriggerEvent('chat:addSuggestion', '/pzfinish', 'Finishes and prints zone.', {})
  TriggerEvent('chat:addSuggestion', '/pzlast', 'Starts creation of the last zone you finished (only works on BoxZone and CircleZone)', {})
  TriggerEvent('chat:addSuggestion', '/pzcancel', 'Cancel zone creation.', {})
  TriggerEvent('chat:addSuggestion', '/pzcomboinfo', 'Prints some useful info for all created ComboZones', {})
end)