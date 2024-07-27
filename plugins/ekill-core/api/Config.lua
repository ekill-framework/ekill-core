if not Core then Core = {} end
if not Core.API then Core.API = {} end

Core.API.Config = {}

---Load config from name file
---File.json should be placed on addons/swiftly/configs/plugins/ekill/
---@param configName string
---@return table|nil
function Core.API.Config:Get(configName --[[string]])
    return Core.ConfigManager:Get(configName)
end


