if not Core then Core = {} end
if not Core.API then Core.API = {} end

---Get core prefix
---Configure the prefix in addons/swiftly/configs/plugins/ekill-core.json.
---@return string | nil
function Core.API:GetPrefix()
    return Core.GetPrefix()
end

---Check if core is in debug mode
---Configure the debug in addons/swiftly/configs/plugins/ekill-core.json.
---@return boolean
Core.API.IsDebugEnabled = function ()
    return Core.IsDebugEnabled()
end

---Check if core has logging enabled
---Configure the debug in addons/swiftly/configs/plugins/ekill-core.json.
---@return boolean
Core.API.IsLogEnabled = function ()
    return Core.IsLogEnabled()
end

