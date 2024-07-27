if not Core then Core = {} end
Core.Types = {}

Core.Types.PlayerConnectedState = {
    PlayerNeverConnected = 0xffffffffffffffff,
    PlayerConnected = 0x0,
    PlayerConnecting = 0x1,
    PlayerReconnecting = 0x2,
    PlayerDisconnecting = 0x3,
    PlayerDisconnected = 0x4,
    PlayerReserved = 0x5
}

Core.Types.Events = {
    OnCoreLoaded = "ekill:Event:OnCoreLoaded"
}

Core.Types.Hooks = {
    CCSPlayerPawnBase_PostThink = "ekill:Hook:CCSPlayerPawnBase_PostThink"
}