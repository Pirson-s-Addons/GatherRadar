<p align="center"><a href="https://www.curseforge.com/wow/addons/gather-radar"><img src="https://raw.githubusercontent.com/Pirson-s-Addons/.github/main/profile/assets/readme-gr-en.svg" width="100%" alt="Gather Radar"/></a></p>

<p align="center"><b>English</b> · <a href="README.es.md">Español</a></p>

<p align="center">
<a href="https://www.curseforge.com/wow/addons/gather-radar"><b>CurseForge</b></a> ·
<a href="https://github.com/Pirson-s-Addons/GatherRadar/releases/latest"><b>Download</b></a>
</p>

## Screenshots

<table>
<tr>
<td align="center" width="50%"><img src="https://media.forgecdn.net/attachments/2087/104/minimap-show-png.png" alt="Nodes on the minimap"><br><sub>Nodes on the minimap</sub></td>
<td align="center" width="50%"><img src="https://media.forgecdn.net/attachments/2087/105/map-options-png.png" alt="Choose what to show"><br><sub>Choose what to show</sub></td>
</tr>
<tr>
<td align="center" width="50%"><img src="https://media.forgecdn.net/attachments/2087/107/ore-png.png" alt="Ore veins"><br><sub>Ore veins</sub></td>
<td align="center" width="50%"><img src="https://media.forgecdn.net/attachments/2087/108/herb-png.png" alt="Herbs and the skill they need"><br><sub>Herbs and the skill they need</sub></td>
</tr>
<tr>
<td align="center" width="50%"><img src="https://media.forgecdn.net/attachments/2087/106/chest-png.png" alt="Treasure chests"><br><sub>Treasure chests</sub></td>
<td align="center" width="50%"><img src="https://media.forgecdn.net/attachments/2087/109/fish-png.png" alt="Fishing pools"><br><sub>Fishing pools</sub></td>
</tr>
</table>

## What it does

**GatherRadar** turns Find Herbs, Find Minerals, Find Treasure and Find Fish into a real gathering radar. Every saved node near you shows on the minimap as a **hollow ring** colored by your chance of a skill-up, for the professions you know: if the node is there, the tracking dot shows inside the ring. What your party finds shows with the **icon of what it gives** (Peacebloom, Copper Ore, a chest...), bigger and glowing. Every node you gather is **remembered** on the **world map**, so you can plan your farming route at a glance.

## Features

- **Minimap rings**: every saved herb, vein, chest and fishing pool around you, colored like the profession window (orange, yellow, green, gray; red if your skill is too low). What your party finds shows with its real item icon.
- **Remembers every node**: the ones you gather (exact position) and the ones your party finds, to find them later on the world map.
- **World map pins** for every saved node of the zone. Shift + right-click a pin to delete it.
- **No duplicates**: two nodes of the same kind closer than 15 yards (you choose) are the same place and only one is kept.
- **Known nodes included**: one click imports the WoW Forever herbs, ore and treasure (Wowhead data from GatherMate2_Data) and fishing pools you are missing, the kinds you choose, no other addon needed. Your own nodes are never replaced.
- **Map filter**: a round button on the world map chooses which kinds (herbs, ore, treasure, fishing pools) are shown on the minimap and the world map. The arrow follows it too.
- **3D arrow to the nearest node** with its name and distance, preferring what is here now. It skips the node you just passed for 5 minutes. Turn it on or off from the world map button.
- **Party sharing**: group members with GatherRadar see the nodes you find, and you see theirs, live.
- **Session panel**: nodes gathered and materials obtained, with icons, totals and per hour.
- **Works in your language**: herbs, ore, treasure and fishing pools are recognized by their in-game name in every official language; nodes new to Forever are learned as you gather.
- Settings in the game's own **Options → AddOns** panel, 20 languages, no libraries.

## Usage

- Turn on **Find Herbs**, **Find Minerals**, **Find Treasure** or **Find Fish** in the minimap tracking menu. GatherRadar does the rest.
- `/gr` opens the settings. `/gr session` shows the session panel, `/gr arrow` the arrow, `/gr import` imports the Wowhead nodes.
- **Options → AddOns → GatherRadar → General**: what to show and where, the radar and the icon sizes.
- **Options → AddOns → GatherRadar → Data**: saved nodes, duplicates, import (choose the kinds), delete and forget everything.

## Installation

1. Download the zip from [CurseForge](https://www.curseforge.com/wow/addons/gather-radar) or the [latest release](https://github.com/Pirson-s-Addons/GatherRadar/releases/latest).
2. Extract the `GatherRadar` folder into `World of Warcraft/_classic_beta_/Interface/AddOns/`.
3. Restart WoW and enable the addon.

## Notes

- Addons cannot ask the game where nodes are, and since Blizzard's API changes they cannot read the minimap at all (the tracking dot's name is secret, even under your own mouse). A remembered node is only a ring: an empty ring means someone may have gathered it.
- Fishing pools come from the import and your party only (fishing loot comes from the bobber, not the pool, and the minimap cannot be read).
- Nodes new to WoW Forever (Cold Iron Deposit, Dreamroot...) are recognized in English; in other languages their name is learned the first time you gather them. Herbs with an extra word in their name (Wilted Peacebloom) count as the herb.

## For addon authors

<details>
<summary><b>Public API</b></summary>

Read-only, versioned, always returns copies. Add `## OptionalDeps: GatherRadar` to your TOC and call it after `PLAYER_LOGIN`. Coordinates are 0-100 (like TomTom); node IDs are GatherMate2's.

```lua
local api = GatherRadarAPI
if api and api.version == 1 then
    api.KINDS                        -- { "herb", "ore", "treasure", "fish" }
    api.FindNode("Copper Vein")      -- nodeID, kind (English or client language)
    api.GetNodeInfo(201)             -- { nodeID, kind, name, englishName, item, skill }
    api.GetNodes(1426, "ore")        -- { { x, y, nodeID }, ... } known on that map
    api.GetMapsForNode(201)          -- { { mapID, count }, ... } most nodes first
    api.GetNearest("herb")           -- { mapID, x, y, nodeID, yards } or nil
    api.HasProfession("ore")         -- true if the player can gather it
end
```
</details>

<br/>

<p align="center"><a href="https://github.com/Pirson-s-Addons"><img src="https://raw.githubusercontent.com/Pirson-s-Addons/.github/main/profile/assets/readme-footer-en.svg" width="100%" alt="Part of Pirson's Addons. See all addons."/></a></p>
