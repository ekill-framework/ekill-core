if not Core then Core = {} end

AdminGroupData = {}
AdminGroupData.__index = AdminGroupData


function AdminGroupData.Initialize(flags --[[table]], immunity --[[number]])
    local self = setmetatable({}, AdminManager)
    self.Flags = flags or {}
    self.Immunity = immunity or 0
    return self
end

setmetatable(AdminGroupData, {
    __call = function(cls, ...)
        return cls.Initialize(...)
    end
})