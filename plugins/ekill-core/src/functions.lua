if not Core then Core = {} end

Core.Functions = {}

---Check if player is valid
---https://cs2.poggu.me/metamod/your-first-plugin/incompatibilities#a-player-controller-still-exists-after-a-player-disconnects
---@param player Player
---@return boolean
Core.Functions.IsPlayerValid = function (player --[[Player]])
    return player ~= nil
    and not player:IsFakeClient()
    and player:CCSPlayerPawn() ~= nil
    and player:CCSPlayerPawn().IsValid
    and not player:CBasePlayerController().isHLTV
    and (player:CBasePlayerController().Connected % 0x100000000) == Core.Types.PlayerConnectedState.PlayerConnected
end

---Check if playerid is valid
---https://cs2.poggu.me/metamod/your-first-plugin/incompatibilities#a-player-controller-still-exists-after-a-player-disconnects
---@param playerID Player
---@return boolean
Core.Functions.IsPlayerIdValid = function (playerID --[[number]])
    local player = GetPlayer(playerID)
    return Core.Functions.IsPlayerValid(player)
end

---Check if the round is pistol
---@return boolean
Core.Functions.IsPistolRound = function()
    local gameRules = GetCCSGameRules()
    if gameRules == nil then return false end
    if gameRules.WarmupPeriod then return false end
    return gameRules.TotalRoundsPlayed == 0 or gameRules.RoundsPlayedThisPhase == 0 or (gameRules.SwitchingTeamsAtRoundReset and gameRules.OvertimePlaying == 0) or gameRules.GameRestart;
end

---Check if is warm-up period
---@return boolean
Core.Functions.IsWarmupPeriod = function()
    local gameRules = GetCCSGameRules()
    if gameRules == nil then return false end
    return gameRules.WarmupPeriod
end

---Check if player has weapon
---@param player Player
---@param weaponName string
---@return boolean
Core.Functions.HasPlayerWeapon = function(player --[[Player]], weaponName --[[string]] )
    local findedWeapon = false

    if weaponName == nil or weaponName == "" then return findedWeapon end

    local playerWeapons = player:GetWeaponManager():GetWeapons()
    
    for _, weaponHandler in ipairs(playerWeapons) do
        local weaponInstance = CEntityInstance(weaponHandler:CBasePlayerWeapon():ToPtr())
        if weaponInstance ~= nil and weaponInstance:IsValid() and weaponInstance.Entity.DesignerName == weaponName then
            findedWeapon = true
            break
        end
    end
    return findedWeapon

end

---Get a team score
--- Team : https://swiftlycs2.net/docs/scripting/types/core/team.html
---@param teamID Team
---@return number|nil
Core.Functions.GetTeamScore = function(teamID)
    local teamManagers = FindEntitiesByClassname("cs_team_manager")
    if #teamManagers <= 0 then return nil end  -- Corrected the condition to check if there are no team managers
    for _, manager in ipairs(teamManagers) do
        local entity = CBaseEntity(manager:ToPtr())
        if entity.TeamNum == teamID then
            return CTeam(entity:EHandle():ToPtr()).Score
        end
    end
    return 0
end

---Get a object of CPlantedC4
---@return CPlantedC4|nil
--- Team : https://swiftlycs2.net/docs/scripting/types/core/team.html
Core.Functions.GetCPlantedC4 = function()
    local bombManagers = FindEntitiesByClassname("planted_c4")
    if #bombManagers < 1 then return nil end
    return CPlantedC4(bombManagers[#bombManagers]:ToPtr())
end

---Check if bomb is planted
---@return boolean
--- Team : https://swiftlycs2.net/docs/scripting/types/core/team.html
Core.Functions.IsBombPlanted = function()
    local plantedBomb = Core.Functions.GetCPlantedC4()
    if plantedBomb == nil then return false end
    return true
end

---Check if bomb is planted on specifies bombsideId
---@param bombSideId number
---@return boolean
Core.Functions.IsBombPlantedSide = function(bombSideId)
    local plantedBomb = Core.Functions.GetCPlantedC4()
    if plantedBomb == nil then return false end
    return (plantedBomb.BombSite == bombSideId) 
end

---Calculate distance beetwen Vector3
---@param vector1 Vector
---@param vector2 Vector
---@return integer
Core.Functions.CalculateDistanceBetweenVector = function(vector1 --[[Vector]], vector2 --[[Vector]])
    local distanceX = vector2.x - vector1.x
    local distanceY = vector2.y - vector1.y
    local distanceZ = vector2.z - vector1.z
    local distance = math.sqrt(distanceX * distanceX + distanceY * distanceY + distanceZ * distanceZ)
    return distance
end

---Send message to player with prefix
---@param prefix string (default value is getted from config.prefix)
---@param messageType MessageType
---@param player Player
---@param message string
Core.Functions.SendToPlayer = function(prefix --[[string]], messageType --[[MessageType]], player --[[Player]], message --[[string]])
    if prefix == nil or prefix == "" then prefix = config:Fetch("ekill-core.prefix", message) end
    player:SendMsg(messageType, string.format("%s %s", prefix, message))
end

---Send message to all players with prefix
---@param prefix string (default value is getted from config.prefix)
---@param messageType MessageType
---@param message string
Core.Functions.SendToAllPlayers = function(prefix --[[string]], messageType --[[MessageType]], message --[[string]])
    if prefix == nil or prefix == "" then prefix = config:Fetch("ekill-core.prefix") end
    playermanager:SendMsg(messageType, string.format("%s %s", prefix, message))
end
