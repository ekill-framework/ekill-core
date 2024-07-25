<p align="center">

  <a href="https://github.com/swiftly-solution/deathmatch">
    <img src="https://github.com/user-attachments/assets/5c4e2699-e2d1-4840-afb5-109c279c226c" alt="eKillLogo" width="630" height="201">
  </a>

  <h1 align="center">Core</h1>

  <p align="center">
    ekill-core is a powerful plugin designed to enhance your development experience with a range of useful features and custom hooks. Built on a <a href="https://swiftlycs2.net/">Swiftly</a> modification specifically tailored for Counter-Strike 2.
    <br/>
  </p>
</p>

<p align="center">
  <img src="https://img.shields.io/github/downloads/ekill-framework/ekill-core/total" alt="Downloads"> 
  <img src="https://img.shields.io/github/contributors/ekill-framework/ekill-core?color=dark-green" alt="Contributors">
  <img src="https://img.shields.io/github/issues/ekill-framework/ekill-core" alt="Issues">
  <img src="https://img.shields.io/github/license/ekill-framework/ekill-core" alt="License">
</p>

<p align="center"><sub>Made by: <a href="https://github.com/m3ntorinho" target="_blank">@m3ntorinho</a> &  <a href="https://ekill.dev" target="_blank">eKill Development</a><br/> ✦ Special thanks to: <a href="https://github.com/skuzzis" target="_blank">@skuzzis</a></sub></p>

---
### Requeriments 📄
1. [Metamod 2.X](https://www.sourcemm.net/downloads.php/?branch=master)
2. [Swiftly](https://github.com/swiftly-solution/swiftly/releases/latest)
---

## Installation 👀

1. Download the newest [release](https://github.com/ekill-framework/ekill-core/releases)
2. Everything is drag & drop in `addons/swiftly`!
3. Update default prefix if you want in `addons/swiftly/configs/plugin/ekill-core.json` with the key `prefix` like in the following example:
```json
{
    "debug": false,
    "prefix": "͖☠ {PURPLE}ekill-core{DEFAULT} ☠"
}
```
---

## Documentation 📚

### Usage: 
  To integrate `ekill-core` into your plugin, add the following code to your script:
  
  ```lua
Core = nil
  AddEventHandler("OnPluginStart", function (event)
      Core = exports["ekill-core"]:GetCoreObject()
  end)
```
  <details open>
<summary>
Example usage:
</summary> <br />
  
```lua
Core = nil

AddEventHandler("OnPluginStart", function (event)
    Core = exports["ekill-core"]:GetCoreObject()
end)

commands:Register("test" , function(playerid, args, argsCount, silent, prefix)
  local player = GetPlayer(playerid)
  if not Core.Functions.IsPlayerValid(player) then return end
  print("Player is valid")
end)


```
</details>

### Development
<details>
<summary>
Functions
</summary> <br />
  
- **IsPlayerValid**
```lua
---@param player Player
---@return boolean
Core.Functions.IsPlayerValid(player) or exports["ekill-core"]:IsPlayerValid(player)
```
- **IsPlayerIdValid**
```lua
---@param player Player
---@return boolean
Core.Functions.IsPlayerIdValid(player) or exports["ekill-core"]:IsPlayerIdValid(player)
```
- **IsPistolRound**
```lua
---@return boolean
Core.Functions.IsPistolRound() or exports["ekill-core"]:IsPistolRound()
```
- **IsWarmupPeriod**
```lua
---@return boolean
Core.Functions.IsWarmupPeriod() or exports["ekill-core"]:IsWarmupPeriod()
```

- **HasPlayerWeapon**
```lua
---@param player Player
---@param weaponName string
---@return boolean
Core.Functions.HasPlayerWeapon(player,weaponName) or exports["ekill-core"]:HasPlayerWeapon(player, weaponName)
```
- **GetTeamScore**
```lua
---@param teamID Team (https://swiftlycs2.net/docs/scripting/types/core/team.html)
---@return boolean
Core.Functions.GetTeamScore(teamID) or exports["ekill-core"]:GetTeamScore(teamID)
```
- **GetCPlantedC4**
```lua
---@return CPlantedC4|nil
Core.Functions.GetCPlantedC4() or exports["ekill-core"]:GetCPlantedC4()
```
- **IsBombPlanted**
```lua
---@return boolean
Core.Functions.IsBombPlanted() or exports["ekill-core"]:IsBombPlanted()
```
- **IsBombPlantedSide**
```lua
---@param bombSideId number
---@return boolean
Core.Functions.IsBombPlantedSide(bombSideID) or exports["ekill-core"]:IsBombPlantedSide(bombSideID)
```

- **CalculateDistanceBetweenVector**
```lua
---@param vector1 Vector (https://swiftlycs2.net/docs/scripting/sdkclasses/core/vector.html)
---@param vector2 Vector (https://swiftlycs2.net/docs/scripting/sdkclasses/core/vector.html)
---@return integer
Core.Functions.CalculateDistanceBetweenVector(vector1, vector2) or exports["ekill-core"]:CalculateDistanceBetweenVector(vector1, vector2)
```

- **SendToPlayer**
```lua
---@param prefix string (if nil or empty then default value is getted from config.prefix)
---@param messageType MessageType (https://swiftlycs2.net/docs/scripting/types/core/messagetype.html)
---@param player Player
---@param message string
Core.Functions.SendToPlayer(prefix,messageType,player,message) or exports["ekill-core"]:SendToPlayer(prefix,messageType,player,message)
```

- **SendToAllPlayers**
```lua
---@param prefix string (if nil or empty then default value is getted from config.prefix)
---@param messageType MessageType (https://swiftlycs2.net/docs/scripting/types/core/messagetype.html)
---@param message string
Core.Functions.SendToAllPlayers(prefix,messageType,message) or exports["ekill-core"]:SendToAllPlayers(prefix,messageType,message)
```
</details>

<details>
<summary>
Events
</summary> <br />
  
- **OnCoreLoaded**
```lua
AddEventHandler("ekill:Event:OnCoreLoaded", function(core --[[Core]])
    --[[ ... ]]
    return EventResult.Continue
end)
```
</details>
<details>
<summary>
Hooks
</summary> <br />
  
- **CCSPlayerPawnBase_PostThink**
```lua
AddEventHandler("ekill:Hook:CCSPlayerPawnBase_PostThink", function(ccsPlayerPawnBase --[[CCSPlayerPawnBase]])
    --[[ ... ]]
    return EventResult.Continue
end)
```
</details>

---
## Creating A Pull Request 😃

1. Fork the Project
2. Create your Feature Branch
3. Commit your Changes
4. Push to the Branch
5. Open a Pull Request
---
## Have ideas/Found bugs? 💡
Join [Swiftly Discord Server](https://swiftlycs2.net/discord) and send a message in the topic from `📕╎plugins-sharing` of this plugin!