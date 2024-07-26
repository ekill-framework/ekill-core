if not Core then Core = {} end
if not Core.API then Core.API = {} end

Core.API.GetPrefix = function ()
    return Core.GetPrefix()
end

Core.API.IsDebugEnabled = function ()
    return Core.IsDebugEnabled()
end

Core.API.IsLogEnabled = function ()
    return Core.IsLogEnabled()
end


