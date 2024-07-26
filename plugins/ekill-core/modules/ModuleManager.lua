if not Core then Core = {} end

ModuleManager = {}
ModuleManager.__index = ModuleManager

function ModuleManager.Initialize()
    local self = setmetatable({}, ModuleManager)
    self.Cache = {}
    self.Path = string.format("%s/modules", GetPluginPath(GetPluginName()))
    local moduleArraySize = config:FetchArraySize("ekill-core.enable_modules")

    for index = 0 , moduleArraySize -1, 1 do

        local key = string.format("ekill-core.enable_modules[%d]", index)
        local moduleName = config:Fetch(key)
        local modulePath = string.format("%s/%s",self.Path,moduleName)
        
        if files:ExistsPath(modulePath) and files:IsDirectory(modulePath) then
            self.Cache[moduleName] = true
            if Core.IsLogEnabled() then logger:Write(LogType_t.Debug , string.format("Module %s loading..", moduleName)) end
            if Core.IsDebugEnabled() then print(string.format("Module {GREEN}%s{DEFAULT} loading...", moduleName)) end
        else
            if Core.IsLogEnabled() then logger:Write(LogType_t.Debug , string.format("Module %s doesn't exist..", moduleName)) end
            if Core.IsDebugEnabled() then print(string.format("Module {RED}%s{DEFAULT} doesn't exist...", moduleName)) end
        end
    end
    return self
end


function ModuleManager:IsModuleEnabled(moduleName)
    return self.Cache[moduleName] == true
end


setmetatable(ModuleManager, {
    __call = function(cls, ...)
        return cls.Initialize(...)
    end
})