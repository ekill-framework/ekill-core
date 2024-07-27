if not Core then Core = {} end

Core.IsDebugEnabled = function() return (config:Fetch("ekill-core.debug") == true) end

Core.IsLogEnabled = function() return (config:Fetch("ekill-core.log") == true) end

Core.GetPrefix = function() return tostring(config:Fetch("ekill-core.prefix")) or nil end

AddEventHandler("OnPluginStart", function(event)
   print(string.format("Starting {PURPLE}v%s{DEFAULT}", GetPluginVersion()))

   Core.ConfigManager = ConfigManager()

   Core.AdminManager = AdminManager()

   Core.AdminManager:LoadAdminsFromFile()

   Core.AdminManager:LoadGroupsFromFile()

   print()


   return EventResult.Continue
end)

export("GetCoreObject", function()
    return Core.API
end)