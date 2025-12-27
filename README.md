# Hap-s-New-Wall-Collision-Maker
- PLEASE create a back-up file of or save your game if you are going to run this script in the event that your roblox studio freezes. 
- This script creates new collisions for ‘walls’ if their thickness is below or equal to a certain vector, etc. You can run this script in the command bar, place it in a new script in ServerScriptService if you want it to run when the game is played, or do both if needed.

AI Generated readme:
# New Wall Collision Maker

[![Roblox](https://img.shields.io/badge/Roblox-Script-red.svg)](https://www.roblox.com/)
[![Lua](https://img.shields.io/badge/Lua-2C2D72.svg?logo=lua)](https://www.lua.org/)

A simple **Roblox Studio** script that automatically generates improved invisible collision parts for thin walls and floors in your map.

### Purpose

In Roblox, very thin parts (e.g., walls thinner than ~2-3 studs) often cause unreliable player collisions — characters can clip through them, get stuck, or experience jittery movement. This is a common issue with detailed or low-poly builds.

This script scans your `Workspace` for anchored, visible, collidable `BasePart`s that appear to be **thin walls/floors** (based on size and orientation), then creates **thicker invisible collision duplicates** placed exactly over them. These new parts ensure solid, consistent collisions without altering the visual appearance of your map.

The generated collisions are placed in a folder called `NewCollisionFolder` for easy management/deletion.

### How It Works

- Ignores small parts (volume < ~9 studs³) and parts with certain children (e.g., ClickDetectors, Sounds).
- Detects "thin" dimensions where one axis is the smallest and ≤ `thickness` (default: 2.4 studs).
- Checks the part's orientation to determine if the thin axis acts as a wall (vertical-ish) or floor/ceiling.
- Creates a cloned invisible part with:
  - The thin dimension expanded to `thickness`.
  - `Transparency = 1`
  - `CanTouch = false`, `CanQuery = false`
  - No children, no shadows, etc.
- Allows a small `tilt` (default: 10°) for slightly angled walls.

### Usage

1. Open your place in **Roblox Studio**.
2. Insert a **Script** (server-side, e.g., in `ServerScriptService` or `Workspace`).
3. Paste the entire script code into it.
4. Run the game (or Play Solo) — the script will execute once, create the `NewCollisionFolder`, and add the new collision parts.
5. Stop the test, and you'll see the invisible parts in Workspace (select them to view outlines).
6. Keep the folder for better collisions in your game, or delete it if you want to revert/regenerate.

> **Note:** Run this whenever you add or modify thin walls in your map. It's designed to be safe to run multiple times (deletes old folder first).

### Script Code

```lua
local gW = game.Workspace
local NCF = gW:FindFirstChild("NewCollisionFolder")
if NCF then
	NCF:Destroy()
end

NCF = Instance.new("Folder")
NCF.Name = "NewCollisionFolder"
NCF.Parent = gW

local tilt = 10          -- Maximum tilt angle (degrees) for detecting walls/floors
local tiltA = 90 - tilt
local tiltB = 180 - tilt
local thickness = 2.4    -- Thickness for new collision parts

for _, i in pairs(gW:GetDescendants()) do
	if not i:FindFirstChildWhichIsA("ClickDetector") 
		and not i:FindFirstChildWhichIsA("Sound") 
		and not i:FindFirstChildWhichIsA("CylinderMesh") 
		and i.Name ~= "NewCollision" 
		and i.Name ~= "Charge" 
		and i:IsA("BasePart") 
		and i.Transparency == 0 
		and i.CanCollide == true 
		and i.Anchored == true 
	then
		
		local SX = i.Size.X
		local SY = i.Size.Y
		local SZ = i.Size.Z
		
		if SX * SY * SZ >= 8.9 then
			local function NewCollisionf(a, b, c)
				local NewCollision = i:Clone()
				NewCollision.Transparency = 1
				NewCollision.Parent = NCF
				NewCollision.CastShadow = false
				NewCollision.EnableFluidForces = false
				NewCollision.CanTouch = false
				NewCollision.CanQuery = false
				NewCollision.Name = "NewCollision"
				NewCollision:ClearAllChildren()
				NewCollision.Size = Vector3.new(a, b, c)
			end
			
			local oriz = i.Orientation.Z
			local absx = math.abs(i.Orientation.X)
			local absz = math.abs(oriz)
			
			local minSize = math.min(SX, SY, SZ)
			local msx = minSize == SX and SX ~= SY and SX ~= SZ and SX <= thickness
			local msy = minSize == SY and SY ~= SX and SY ~= SZ and SY <= thickness
			local msz = minSize == SZ and SZ ~= SX and SZ ~= SY and SZ <= thickness
			
			if msx and (oriz >= -tilt and oriz <= tilt or oriz >= -tiltB and oriz <= tiltB or oriz >= tiltB and oriz <= tiltB + 180) then  -- Simplified for horizontal thin walls
				NewCollisionf(thickness, SY, SZ)
			elseif msy and (absz <= 90 + tilt and absz >= tiltA or absx >= tiltA) then
				NewCollisionf(SX, thickness, SZ)
			elseif msz and absx <= tilt then
				NewCollisionf(SX, SY, thickness)
			end
		end
	end
end
```

### Customization

- Adjust `tilt` for more/less lenient angled wall detection.
- Change `thickness` to make collisions thicker (e.g., 3 or 4 for extra reliability).
- Modify the volume check (`>= 8.9`) or ignored children as needed.

### Issues / Contributions

Feel free to fork and improve! Common enhancements could include:
- Support for MeshParts/Unions
- Automatic re-running on part changes
- Better orientation detection

Created by HappGamr 🚀
