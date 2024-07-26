if not Core then Core = {} end

Core.IsDebugEnabled = function() return config:Fetch("ekill-core.debug") end

Core.IsLogEnabled = function() return config:Fetch("ekill-core.log") end

Core.GetPrefix = function() return config:Fetch("ekill-core.prefix") end

AddEventHandler("OnPluginStart", function(event)

   print(string.format("Starting {PURPLE}v%s{DEFAULT}", GetPluginVersion()))

    Core.ModuleManager =  ModuleManager()

    if not Core.ModuleManager:IsModuleEnabled("config") then return EventResult.Continue end

    Core.ConfigManager = ConfigManager()

    return EventResult.Continue
end)


export("GetCoreObject", function()
    return Core.API
end)