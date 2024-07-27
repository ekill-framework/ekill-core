if not Core then Core = {} end
if not Core.API then Core.API = {} end

Core.API.AdminManager = {}

---Check if player has permissions
---@param player Player
---@param flags table
function Core.API.AdminManager:PlayerHasPermissions(player,flags)
    return Core.AdminManager:PlayerHasPermissions(player,flags)
end

---Add player permissions
---@param player Player
---@param flags table
function Core.API.AdminManager:AddPlayerPermissions(player,flags)
    return Core.AdminManager:PlayerHasPermissions(player, flags)
end

---Remove player permissions
---@param player Player
---@param flags table
function Core.API.AdminManager:RemovePlayerPermissions(player,flags)
    return Core.AdminManager:RemovePlayerPermissions(player, flags)
end

---Set player immunity
---@param player Player
---@param immunity number
function Core.API.AdminManager:SetPlayerImmunity(player,immunity)
    return Core.AdminManager:SetPlayerImmunity(player, immunity)
end

---Get player immunity
---@param player Player
---@return number
function Core.API.AdminManager:GetPlayerImmunity(player)
    return Core.AdminManager:GetPlayerImmunity(player)
end

---Get player immunity
---@param player Player
---@param target Player
---@return boolean
function Core.API.AdminManager:CanPlayerTarget(player, target)
    return Core.AdminManager:CanPlayerTarget(player, target)
end

---Add player to group
---@param player Player
---@param groups table
function Core.API.AdminManager:AddPlayerToGroup(player,groups)
    return Core.AdminManager:AddPlayerToGroup(player, groups)
end

---Remove player from groups
---@param player Player
---@param groups table
function Core.API.AdminManager:RemovePlayerGroup(player,groups)
    return Core.AdminManager:RemovePlayerGroup(player, groups)
end

