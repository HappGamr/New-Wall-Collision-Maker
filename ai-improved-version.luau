--!strict
local Workspace = game:GetService("Workspace")

-- Configuration
local COLLISION_FOLDER_NAME = "NewCollisionFolder"
local THICKNESS = 2.4
local TILT_TOLERANCE = 10 -- Degrees of leniency for rotation
local MIN_VOLUME = 8.9

-- Cleanup old folder if it exists
local oldFolder = Workspace:FindFirstChild(COLLISION_FOLDER_NAME)
if oldFolder then
	oldFolder:Destroy()
end

-- Create new container
local collisionFolder = Instance.new("Folder")
collisionFolder.Name = COLLISION_FOLDER_NAME
collisionFolder.Parent = Workspace

-- Helper function to create the collision part
local function createCollisionClone(originalPart: BasePart, newSize: Vector3)
	local clone = originalPart:Clone()
	clone:ClearAllChildren() -- Remove scripts/textures/decals
	
	-- Set Physics Properties
	clone.Name = "NewCollision"
	clone.Transparency = 1
	clone.CastShadow = false
	clone.EnableFluidForces = false
	clone.CanTouch = false
	clone.CanQuery = false -- Raycasts will ignore this
	clone.CanCollide = true
	clone.Anchored = true
	clone.Size = newSize
	clone.Parent = collisionFolder
end

-- Check if a part is a valid candidate for thickening
local function isValidCandidate(part: Instance): boolean
	if not part:IsA("BasePart") then return false end
	if part.Transparency > 0 then return false end
	if part.CanCollide == false then return false end
	if part.Anchored == false then return false end
	
	-- Exclude specific names or interactive objects
	if part.Name == "NewCollision" or part.Name == "Charge" then return false end
	if part:FindFirstChildWhichIsA("ClickDetector") 
		or part:FindFirstChildWhichIsA("Sound") 
		or part:FindFirstChildWhichIsA("CylinderMesh") then 
		return false 
	end

	-- Volume check
	local size = part.Size
	if (size.X * size.Y * size.Z) < MIN_VOLUME then return false end

	return true
end

-- Main Loop
for _, part in ipairs(Workspace:GetDescendants()) do
	if not isValidCandidate(part) then continue end

	local size = part.Size
	local ori = part.Orientation
	
	-- Identify the thin axis
	local minDim = math.min(size.X, size.Y, size.Z)
	
	-- Boolean checks for which axis is the thin one (must be <= THICKNESS)
	local isThinX = (minDim == size.X) and (size.X <= THICKNESS)
	local isThinY = (minDim == size.Y) and (size.Y <= THICKNESS)
	local isThinZ = (minDim == size.Z) and (size.Z <= THICKNESS)

	-- Calculate Angle Checks (simplified from original logic)
	local absRotX = math.abs(ori.X)
	local absRotZ = math.abs(ori.Z)

	-- Logic to determine if the part is aligned enough to be thickened
	if isThinX then
		-- Check if "upright" or flipped 180
		local isUpright = (absRotZ <= TILT_TOLERANCE) or (absRotZ >= 180 - TILT_TOLERANCE)
		if isUpright then
			createCollisionClone(part, Vector3.new(THICKNESS, size.Y, size.Z))
		end
	elseif isThinY then
		-- Check if "flat" (floor/ceiling)
		local isFlat = (absRotZ <= 90 + TILT_TOLERANCE and absRotZ >= 90 - TILT_TOLERANCE) or (absRotX >= 90 - TILT_TOLERANCE)
		if isFlat then
			createCollisionClone(part, Vector3.new(size.X, THICKNESS, size.Z))
		end
	elseif isThinZ then
		-- Check if "upright" (facing Z axis)
		if absRotX <= TILT_TOLERANCE then
			createCollisionClone(part, Vector3.new(size.X, size.Y, THICKNESS))
		end
	end
end
