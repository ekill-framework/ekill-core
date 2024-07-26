if not Core then Core = {} end
if not Core.API then Core.API = {} end

Core.API.Config = {}

---comment
---@param configName any
---@return table|nil
function Core.API.Config:Get(configName --[[string]])
    return Core.ConfigManager.Get(configName)
end

