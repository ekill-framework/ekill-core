if not Core then Core = {} end

local CCSPlayerPawnBase_PostThink_Constructor = Memory()
CCSPlayerPawnBase_PostThink_Constructor:LoadFromSignatureName("CCSPlayerPawnBase_PostThink")
local CCSPlayerPawnBase_PostThink_ConstructorHook = AddHook(CCSPlayerPawnBase_PostThink_Constructor, "p", "v")

AddPreHookListener(CCSPlayerPawnBase_PostThink_ConstructorHook, function(event)
    if event:IsHook() then
        local pawnPtr = event:GetHookPointer(0):GetPtr() -- string of the pointer
        TriggerEvent(Core.Types.Hooks.CCSPlayerPawnBase_PostThink, CCSPlayerPawnBase(pawnPtr))
    end
    return EventResult.Continue
end)