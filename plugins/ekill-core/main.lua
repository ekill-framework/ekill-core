if not Core then Core = {} end

export("GetCoreObject", function ()
    return Core
end)

export("IsPlayerValid", function (player --[[Player]])
    return Core.Functions.IsPlayerValid(player)
end)

export("IsPlayerIdValid", function (playerid --[[number]])
    return Core.Functions.IsPlayerIdValid(playerid)
end)

export("IsPistolRound", function ()
    return Core.Functions.IsPistolRound()
end)

export("IsWarmupPeriod", function ()
    return Core.Functions.IsWarmupPeriod()
end)

export("HasPlayerWeapon", function (player --[[Player]], weaponName --[[string]])
    return Core.Functions.HasPlayerWeapon(player,weaponName)
end)

export("GetTeamScore", function (teamID)
    return Core.Functions.GetTeamScore(teamID)
end)

export("GetCPlantedC4", function ()
    return Core.Functions.GetCPlantedC4()
end)

export("IsBombPlanted", function ()
    return Core.Functions.IsBombPlanted()
end)

export("IsBombPlantedSide", function (bombSideID --[[number]])
    return Core.Functions.IsBombPlantedSide(bombSideID)
end)

export("CalculateDistanceBetweenVector", function (vector1 --[[Vector]], vector2 --[[Vector]])
    return Core.Functions.CalculateDistanceBetweenVector(vector1,vector2)
end)

export("SendToPlayer", function (prefix --[[string]], messageType --[[MessageType]], player --[[Player]], message --[[string]])
    return Core.Functions.SendToPlayer(prefix,messageType,player,message)
end)

export("SendToAllPlayers", function (prefix --[[string]], messageType --[[MessageType]], message --[[string]])
    return Core.Functions.SendToAllPlayers(prefix,messageType,message)
end)


AddEventHandler("OnPluginStart", function(event --[[ Event ]])
    
    TriggerEvent(Core.Types.Events.OnCoreLoaded, Core)

    return EventResult.Continue
end)
