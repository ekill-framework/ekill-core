if not Core then Core = {} end

ConfigManager = {}
ConfigManager.__index = ConfigManager

function ConfigManager.Initialize()
    local self = setmetatable({}, ConfigManager)
    self.Cache = {}
    self.Path = "addons/swiftly/configs/plugins/ekill"

    if not files:ExistsPath(self.Path) or not files:IsDirectory(self.Path) then
        files:CreateDirectory(self.Path)
    end
    return self
end


function ConfigManager:Get(configName)
    
    if not configName or configName == "" then return nil end

    if self.Cache[configName] then return self.Cache[configName] end

    local configPath = string.format("%s/%s.json",self.Path, configName)

    if not files:ExistsPath(configPath) then return nil end
    
    local configString = files:Read(configPath)

    if not configString or configString == "" then return nil end

    local config = json.decode(configString)

    if not config or type(config) ~= "table" then return nil end

    self.Cache[configName] = config

    return config
end


setmetatable(ConfigManager, {
    __call = function(cls, ...)
        return cls.Initialize(...)
    end
})