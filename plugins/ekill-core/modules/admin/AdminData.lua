if not Core then Core = {} end

AdminData = {}
AdminData.__index = AdminData

function AdminData.Initialize(identity, immunity, flags, groups)
    local self = setmetatable({}, AdminData)
    self.Identity = identity
    self.Immunity = immunity or 0
    self._flags = flags or {}
    self.Groups = groups or {}
    self.Flags = {}
    return self
end

function AdminData:InitializeFlags()
    self:AddFlags(self._flags)
end
-- Check is domain has root flags
function AdminData:DomainHasRootFlag(domain --[[string]])
    if not self.Flags[domain] then return false end
    local flags = self.Flags[domain]

    -- Iterate through the flags to check for the specific patterns
    for _, flag in ipairs(flags) do
        if flag == "@" .. domain .. "/root" or flag == "@" .. domain .. "/*" then
            return true
        end
    end
    -- Return false if none of the flags match
    return false
end

-- Function to get all domain keys from the Flags table
function AdminData:GetFlagDomains()
    local domains = {}
    local flags = self.Flags
    -- Iterate over the keys in the Flags table
    for domain in pairs(flags) do
        -- Add each key (domain) to the domains table
        table.insert(domains, domain)
    end
    return domains
end

-- Function to add flags to the Flags table
function AdminData:AddFlags(flags)
    -- Table to store domains
    local domains = {}
    -- Filter and extract domains from the flags
    for _, flag in ipairs(flags) do
        if flag:sub(1, #PermissionCharacters.UserPermissionChar) == PermissionCharacters.UserPermissionChar then
            local domain = flag:match(PermissionCharacters.UserPermissionChar .. "([^/]+)")
            if domain and not domains[domain] then
                domains[domain] = true
            end
        end
    end
    -- Process each domain
    for domain in pairs(domains) do
        if not self.Flags[domain] then
            self.Flags[domain] = {}
        end
        -- Add flags to the domain
        for _, flag in ipairs(flags) do
            if flag:sub(1, #PermissionCharacters.UserPermissionChar + #domain) == PermissionCharacters.UserPermissionChar .. domain then
                table.insert(self.Flags[domain], flag)
            end
        end
    end
end

-- Function to remove flags from the Flags table
function AdminData:RemoveFlags(flags)
    -- Define the character that marks user permissions (equivalent to PermissionCharacters.UserPermissionChar in C#)
    local userPermissionChar = "@"  -- Adjust this as necessary

    -- Table to store domains
    local domains = {}

    -- Filter and extract domains from the flags
    for _, flag in ipairs(flags) do
        if flag:sub(1, #userPermissionChar) == userPermissionChar then
            local domain = flag:match(userPermissionChar .. "([^/]+)")
            if domain and not domains[domain] then
                domains[domain] = true
            end
        end
    end

    -- Process each domain
    for domain in pairs(domains) do
        if self.Flags[domain] then
            -- Create a set of flags that belong to the domain
            local domainFlags = {}
            for _, flag in ipairs(flags) do
                if flag:sub(1, #userPermissionChar + #domain) == userPermissionChar .. domain then
                    domainFlags[flag] = true
                end
            end

            -- Remove flags from the domain
            for flag in pairs(domainFlags) do
                self.GetFlagDomainsFlags[domain][flag] = nil
            end

            -- Remove the domain if it has no flags left
            if next(self.Flags[domain]) == nil then
                flags.Flags[domain] = nil
            end
        end
    end
end

-- Function to check if a domain has certain flags
function AdminData:DomainHasFlags(domain, flags, ignoreRoot)
    ignoreRoot = ignoreRoot or false -- Default to false if not provided

    -- Check if the domain exists in the Flags table
    if not self.Flags[domain] then
        return false
    end

    -- Check if the domain has the root flag and ignoreRoot is false
    if self.DomainHasRootFlag(domain) and not ignoreRoot then
        return true
    end

    -- Check if the domain flags are a superset of the provided flags
    return Core.Helpers.Table.IsSupersetOf(self.Flags[domain], flags)
end


setmetatable(AdminData, {
    __call = function(cls, ...)
        return cls.Initialize(...)
    end
})