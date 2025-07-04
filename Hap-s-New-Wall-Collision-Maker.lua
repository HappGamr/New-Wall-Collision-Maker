local gW = game.Workspace

local NCF = gW:FindFirstChild("NewCollisionFolder")
if NCF then
	NCF:Destroy()
end

NCF = Instance.new("Folder")
NCF.Name = "NewCollisionFolder"
NCF.Parent = gW

local tilt = 10 

local tiltA = 90-tilt
local tiltB = 180-tilt

local thickness = 2.4

for _, i in pairs(gW:GetDescendants()) do
	if not i:FindFirstChildWhichIsA("ClickDetector") and not i:FindFirstChildWhichIsA("Sound") and not i:FindFirstChildWhichIsA("CylinderMesh") and i.Name ~= "NewCollision" and i.Name ~= "Charge" and i:IsA("BasePart") and i.Transparency == 0 and i.CanCollide == true and i.Anchored == true then
		local SX = i.Size.X
		local SY = i.Size.Y
		local SZ = i.Size.Z
		
		if SX*SY*SZ >= 8.9 then
			local function NewCollisionf(a,b,c)
				local NewCollision = i:Clone()
				NewCollision.Transparency = 1
				NewCollision.Parent = NCF
				NewCollision.CastShadow = false
				NewCollision.EnableFluidForces = false
				NewCollision.CanTouch = false
				NewCollision.CanQuery = false
				NewCollision.Name = "NewCollision"
				NewCollision:ClearAllChildren()
				NewCollision.Size = Vector3.new(a,b,c)
			end

			local oriz = i.Orientation.Z

			local absx = math.abs(i.Orientation.X) 
			local absz = math.abs(oriz) 

			local minSize  = math.min(SX,SY,SZ)

			local msx = minSize == SX and SX ~= SY and SX ~= SZ and SX <= thickness
			local msy = minSize == SY and SY ~= SX and SY ~= SZ and SY <= thickness
			local msz = minSize == SZ and SZ ~= SX and SZ ~= SY and SZ <= thickness

			if msx and oriz >= -tilt and oriz <= tilt or msx and oriz >= -tiltB and oriz >= tiltB or msx and oriz <= -tiltB and oriz <= tiltB then
				NewCollisionf(thickness,SY,SZ)
			elseif msy and absz <= 90+tilt and absz >= tiltA or msy and absx >= tiltA then
				NewCollisionf(SX,thickness,SZ)
			elseif msz and absx <= tilt then
				NewCollisionf(SX,SY,thickness)
			end
		end
	end
end

if script then
	script:Destroy()
end