if not Core then Core = {} end

AdminManager = {}
AdminManager.__index = AdminManager

function AdminManager.Initialize()
    local self = setmetatable({}, AdminManager)
    self.Admins = {}
    self.Groups = {}
    return self
end

function AdminManager:LoadAdminsFromFile()

    local adminsFromFile = Core.ConfigManager:Get("admins")

    if not adminsFromFile then 
        if Core.IsDebugEnabled() then print("{PURPLE} Cannot loaded admins.json config.") end
        if Core.IsLogEnabled() then logger:Write(LogType_t.Error,"Cannot loaded admins.json") end
    end
    
    for _, adminDef in pairs(adminsFromFile) do
        
        local adminData = AdminData(adminDef.identity, adminDef.immunity, adminDef.flags, adminDef.group)

        adminData:InitializeFlags()

        if self.Admins[adminData.Identity] then
            for domain, flags in pairs(adminData.Flags) do
                if self.Admins[adminData.Identity].Flags[domain] then
                    -- Assuming a function to merge sets is defined
                    Core.Helpers.Table.UnionWith(self.Admins[adminData.Identity].Flags[domain], flags)
                end
            end
            
            if adminData.Immunity > self.Admins[adminData.Identity].Immunity then
                self.Admins[adminData.Identity].Immunity = adminData.Immunity
            end            
        else
            self.Admins[adminData.Identity] = adminData
        end
    end

    print(string.format("{BLUE} Admins loaded from config file: %d", Core.Helpers.Table.Count(self.Admins)))
    if Core.IsDebugEnabled() then print(string.format("{BLUE} %s", json.encode(self.Admins))) end
end

function AdminManager:LoadGroupsFromFile()
    local groupsFromFile = Core.ConfigManager:Get("groups")
    if not groupsFromFile then return end
    
    for key, groupsDef in pairs(groupsFromFile) do
        local groupsData = AdminGroupData(groupsDef.flags,groupsDef.immunity)

        if self.Groups[key] then
            local existingFlags = self.Groups[key].Flags or {}

            for _, flag in ipairs(groupsData.Flags) do
                if not Core.Helpers.Table.Contains(existingFlags, flag) then
                    table.insert(existingFlags, flag)
                end
            end
            self.Groups[key].Flags = existingFlags
            
            if groupsData.Immunity > self.Groups[key].Immunity then
                self.Groups[key].Immunity = groupsData.Immunity
            end

        else
            self.Groups[key] = groupsData
        end

        for _, admin in pairs(self.Admins) do
            local groups = admin.Groups or {}
            for _, group in ipairs(groups) do
                local groupData = self.Groups[group]
                if groupData then
                    self.Admins[admin.Identity]:AddFlags(groupData.Flags)
                    if groupData.Immunity > admin.Immunity then
                        self.Admins[admin.Identity].Immunity = groupData.Immunity
                    end
                end
            end
        end
    end

    print(string.format("{BLUE} Groups loaded from config file: %d", Core.Helpers.Table.Count(self.Groups)))

    if Core.IsDebugEnabled() then print(string.format("{BLUE} %s", json.encode(self.Groups))) end
end

function AdminManager:GetPlayerAdminData(player --[[Player]])
    if not player then return nil end
    -- Look up admin data using the SteamID64
    return self.Admins[tostring(player:GetSteamID())]
end

function AdminManager:RemovePlayerAdminData(player --[[player]])
    if not player then return nil end;
    self.Admins[tostring(player:GetSteamID())] = nil;
end

function AdminManager:PlayerHasPermissions(player --[[Player]], flags )
    if not Core.Utils.IsPlayerValid(player) then return false end

    local playerSteamID = tostring(player:GetSteamID())

    if not playerSteamID or playerSteamID == "" then return false end


    local playerData = self.GetPlayerAdminData(player)

    if not playerData then return false end

    local localDomains = {}

    for _, flag in ipairs(playerData.Flags) do
        if string.sub(flag, 1, 1) == PermissionCharacters.UserPermissionChar then
            local domain = string.match(flag, "([^/]+)")
            if domain then
                localDomains[domain] = true
            end
        end
    end

    local playerFlagDomains = playerData:GetFlagDomains(playerData)

    for domain in pairs(localDomains) do
        if not playerFlagDomains[domain] then
            return false
        end
    end

        -- Check if player has all required flags for each domain
    for domain, _ in pairs(playerData.Flags) do
        local requiredFlags = {}
        for _, flag in ipairs(flags) do
            if string.match(flag, "^" .. PermissionCharacters.UserPermissionChar .. domain .. "/") then
                table.insert(requiredFlags, flag)
            end
        end

        if not playerData:DomainHasFlags(domain, requiredFlags) then
            return false
        end
    end

    return true
end

function AdminManager:AddPlayerPermissions(player --[[Player]], flags --[[table]])
    if not Core.Utils.IsPlayerValid(player) then return end
    local adminData = self:GetPlayerAdminData(player)
    local playerSteamID = tostring(player:GetSteamID())
    if not adminData then
        adminData = AdminData(playerSteamID)
        self.Admins[playerSteamID] = adminData
    end
    self.Admins[playerSteamID]:AddFlags(flags)
end

function AdminManager:RemovePlayerPermissions(player --[[Player]], flags --[[table]])
    if not Core.Utils.IsPlayerValid(player) then return end
    local adminData = self:GetPlayerAdminData(player)
    if not adminData then return end
    local playerSteamID = tostring(player:GetSteamID())
    self.Admins[playerSteamID]:RemoveFlags(flags)
end

function AdminManager:ClearPlayerPermissions(player --[[Player]])
    if not Core.Utils.IsPlayerValid(player) then return end
    local adminData = self:GetPlayerAdminData(player)
    if not adminData then return end
    local playerSteamID = tostring(player:GetSteamID())
    self.Admins[playerSteamID].Flags = {}
end

function AdminManager:SetPlayerImmunity(player --[[Player]], value --[[number]])
    if not Core.Utils.IsPlayerValid(player) then return end
    local adminData = self:GetPlayerAdminData(player)
    if not adminData then return end
    local playerSteamID = tostring(player:GetSteamID())
    self.Admins[playerSteamID].Immunity = value
end

function AdminManager:GetPlayerImmunity(player --[[Player]])
    if not Core.Utils.IsPlayerValid(player) then return end
    local adminData = self:GetPlayerAdminData(player)
    if not adminData then return end
    local playerSteamID = player:GetSteamID()
    return self.Admins[playerSteamID].Immunity
end

function AdminManager:CanPlayerTarget(caller --[[Player]], target --[[Player]])
    if not caller and not target then return false end
    local callerData = self:GetPlayerAdminData(caller)
    if not callerData then return false end
    local targetData = self:GetPlayerAdminData(target)
    if not targetData then return true end
    
    return callerData.Immunity >= targetData.Immunity;
end

function AdminManager:PlayerInGroup(player --[[Player]], groups --[[table]] )
    if not Core.Utils.IsPlayerValid(player) then return false end

    local playerData = self:GetPlayerAdminData(player)
    if not playerData then return false end

    local playerGroups = {}
    for _, group in ipairs(groups) do
        playerGroups[group] = true
    end

    for domain, _ in pairs(playerData.Flags) do
        if playerData:DomainHasRootFlag(domain) then
            for group in pairs(playerGroups) do
                if string.match(group, domain .. '/') then
                    playerGroups[group] = nil
                end
            end
        end
    end

    return Core.Helpers.Table.IsSupersetOf(playerGroups)
end

function AdminManager:AddPlayerToGroup(player --[[Player]], groups --[[table]])

    if not Core.Utils.IsPlayerValid(player) then return end

    local playerData = self:GetPlayerAdminData(player)

    if not playerData then
        local playerSteamID = tostring(player:GetSteamID())
        playerData = AdminData(playerSteamID,nil,nil,groups,nil)
    end

    for _, group in groups do
        local groupDef = self.Group[group]
        if groupDef then
            self:AddPlayerPermissions(player, groupDef.Flags)
        end
    end
end

function AdminManager:RemovePlayerGroup(player --[[Player]],removeInheritedFlags --[[boolean]],  groups --[[table]])
    removeInheritedFlags = removeInheritedFlags  or true

    if not Core.Utils.IsPlayerValid(player) then return end
    local playerData = self:GetPlayerAdminData(player)
    if not playerData then return end

    Core.Helpers.Table.ExceptWith(playerData.Groups, groups )

    if removeInheritedFlags then
        for _, group in ipairs(groups) do
            local groupDef = self.Groups[group]
            self:RemovePlayerPermissions(player,groupDef.Flags)
        end
    end

    self.Admins[tostring(player:GetSteamID())] = playerData
end


setmetatable(AdminManager, {
    __call = function(cls, ...)
        return cls.Initialize(...)
    end
})
