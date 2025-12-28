# Hap-s-New-Wall-Collision-Maker
- PLEASE create a backup file or save your game if you are going to run this script in case Roblox Studio freezes. 
- This script creates new collisions for ‘walls’ if their thickness is below or equal to a certain threshold, etc. You can run this script in the command bar, place it in a new script in ServerScriptService if you want it to run when the game is played, or do both if needed.
- This script was originally made for killhouses but it can be used for other types of buildings or structures. Nevertheless, you'll still need to check if their extended collision parts are created correctly and so on (by making them visible).

AI Generated readme:
# Hap's New Wall Collision Maker

[![Roblox](https://img.shields.io/badge/Roblox-Studio-red?logo=roblox)](https://www.roblox.com/)
[![Lua](https://img.shields.io/badge/Lua-2C2D72?logo=lua&logoColor=white)](https://www.lua.org/)

A simple Roblox Studio utility script that automatically creates invisible "collision extender" parts for thin walls to improve player collision reliability.

This script detects thin, collidable, anchored parts that appear to be walls and adds slightly thicker invisible collision parts around them so that your Roblox avatar's arms doesn't go through the walls.

## ⚠️ Important Warning

**Always save or create a backup of your place before running this script.**  
Roblox Studio may freeze or become unresponsive while the script processes a large number of parts.

## Features

- Detects thin walls based on size and orientation
- Creates invisible, non-query, non-touch collision parts that are slightly thicker
- Ignores decorative or non-wall parts (e.g., parts with ClickDetectors, Sounds, CylinderMeshes, etc.)
- Only affects solid (Transparency = 0), collidable, anchored BaseParts
- Skips very small parts (volume < 8.9 studs³)
- Places all new collision parts in a folder called `NewCollisionFolder` in Workspace for easy management/cleanup

## How to Use

### Option 1: Run Once in Command Bar (Recommended for testing)

1. Open your place in Roblox Studio.
2. Open the **Command Bar** (View → Command Bar).
3. Paste the entire script into the command bar.
4. Press Enter to execute.

### Option 2: Run Automatically on Play

1. In ServerScriptService, create a new Script.
2. Paste the script code into it.
3. The script will run every time the game starts (in Play mode or on a live server).

You can use both methods if desired.

## Customization

You can tweak these values at the top of the script:

```lua
local tilt = 10        -- Tolerance in degrees for wall orientation detection
local thickness = 2.4  -- Maximum thickness considered "thin" and the new collision thickness
```

- Lower `tilt` → stricter alignment required (walls must be more perfectly axis-aligned)
- Higher `thickness` → more walls will get extended collisions

## What the Script Does

1. Clears any existing `NewCollisionFolder`.
2. Creates a new `NewCollisionFolder` in Workspace.
3. Scans all descendants of Workspace.
4. For qualifying thin walls:
   - Clones the part
   - Makes it fully transparent and disables shadows/fluid/touch/query
   - Increases thickness in the thin dimension
   - Names it "NewCollision" and parents it to the folder

## Cleanup

To remove all generated collision parts:

```lua
game.Workspace:FindFirstChild("NewCollisionFolder"):Destroy()
```

Or simply delete the folder manually in Explorer.

## Notes

- The script self-destroys if placed as a Script (commented out by default).
- Generated parts have `CanQuery = false` and `CanTouch = false` to avoid interfering with raycasts or touch events.
- Works best on axis-aligned or near-axis-aligned walls.

## License

This script uses GNU General Public License v3.0

Happy building! 🛠️
