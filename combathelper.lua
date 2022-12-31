local CombatHelper = {
	["HitBox"] = {
		["Execute"] = function (Character, CFramePosition, Size, ...)
			local valueToReturn
			if not Character or not CFramePosition or not Size then
				warn("Error (HitBox): Missing arguments, aborting")
			elseif Character:IsA("Model") and Character:FindFirstChild("Humanoid") then
				local newHitBox = Instance.new("Part", Character)
				newHitBox.Anchored = false; newHitBox.Transparency = 1; newHitBox.CFrame = CFramePosition; newHitBox.CastShadow = false; newHitBox.Size = Size; newHitBox.CanCollide = false; valueToReturn = newHitBox
				local hitBoxWeld = Instance.new("WeldConstraint", newHitBox)
				hitBoxWeld.Part0 = newHitBox; hitBoxWeld.Part1 = Character:WaitForChild("HumanoidRootPart", 5)
			end
			return valueToReturn
		end,
	},
	
	["DebugHitBox"] = {
		["Execute"] = function (Character, CFramePosition, Size, ...)
			local valueToReturn
			if not Character or not CFramePosition or not Size then
				warn("Error (DebugHitBox): Missing arguments, aborting")
			elseif Character:IsA("Model") and Character:FindFirstChild("Humanoid") then
				local newHitBox = Instance.new("Part", Character)
				newHitBox.Anchored = false; newHitBox.Transparency = 0; newHitBox.CFrame = CFramePosition; newHitBox.CastShadow = false; newHitBox.Size = Size; newHitBox.CanCollide = false; newHitBox.Color = Color3.fromRGB(255,0,0); newHitBox.Material = Enum.Material.ForceField; valueToReturn = newHitBox
				local hitBoxWeld = Instance.new("WeldConstraint", newHitBox)
				hitBoxWeld.Part0 = newHitBox; hitBoxWeld.Part1 = Character:WaitForChild("HumanoidRootPart", 5)
			end
			return valueToReturn
		end,
	},
	
	["Damage"] = {
		["Execute"] = function (Target, Amount, ...)
			if not Target or not Amount then
				warn("Error (Damage): Missing arguments, aborting")
			elseif Target:IsA("Model") and Target:FindFirstChild("Humanoid") then
				print(Amount)
				Target.Humanoid:TakeDamage(Amount)
			end
		end,
	},
	
	["Stun"] = {
		["Execute"] = function (Target, Timer, OriginalWalkSpeed, ...)
			if not Target or not Timer then
				warn("Error (Stun): Missing arguments, aborting")
			elseif Target:IsA("Model") and Target:FindFirstChild("Humanoid") then
				local stunInstance = Instance.new("BoolValue", Target)
				stunInstance.Name = "Stunned"; stunInstance.Value = true
				Target.Humanoid.WalkSpeed -= 10
				task.delay(Timer, function()
					stunInstance.Value = false; game.Debris:AddItem(stunInstance, 0)
					Target.Humanoid.WalkSpeed += 10
				end)
			end
		end,
	},
	
	["EmittParticles"] = {
		["Execute"] = function (Target, Timer, ParticleInstance, Attachment, ...)
			if not Target or not Timer or not ParticleInstance then
				warn("Error (EmittParticles): Missing arguments, aborting")
			elseif Target:IsA("Model") and Target:FindFirstChild("Humanoid") and ParticleInstance:IsA("ParticleEmitter") then
				local AttachmentInst = Instance.new("Attachment", Target:WaitForChild("HumanoidRootPart", 5))
				local newParticles = ParticleInstance:Clone()
				if Attachment == true then
					newParticles.Parent = AttachmentInst; newParticles.Enabled = true
				else
					newParticles.Parent = Target:WaitForChild("HumanoidRootPart", 5); newParticles.Enabled = true
				end
				task.delay(Timer, function()
					newParticles.Enabled = false
					game.Debris:AddItem(newParticles, 1); game.Debris:AddItem(AttachmentInst, 1)
				end)
			end
		end,
	},
	
	["PlaySound"] = {
		["Execute"] = function (Target, Timer, SoundInstance, ...)
			if not Target or not Timer or not SoundInstance then
				warn("Error (PlaySound): Missing arguments, aborting")
			elseif Target:IsA("Model") and Target:FindFirstChild("Humanoid") then
				local newAudio = SoundInstance:Clone(); newAudio.Parent = Target:WaitForChild("HumanoidRootPart", 5); newAudio:Play()
				task.delay(Timer, function()
					game.Debris:AddItem(newAudio, 0)
				end)
			end
		end,
	},
	
	["PlayAnimation"] = {
		["Execute"] = function (Target, AnimationInstance, ...)
			local valueToReturn
			if not Target or not AnimationInstance then
				warn("Error (PlayAnimation): Missing arguments, aborting")
			elseif Target:IsA("Model") and Target:FindFirstChild("Humanoid") and AnimationInstance:IsA("Animation") then
				local newTrack = Target.Humanoid:LoadAnimation(AnimationInstance); newTrack:Play(); valueToReturn = newTrack; newTrack.Stopped:Connect(function()
					game.Debris:AddItem(newTrack, 0)
				end)
			end
			return valueToReturn
		end,
	},
	
	["Knockback"] = {
		["Execute"] = function (Character, Target, ZValue)
			if not Character or not Target or not ZValue then
				warn("Error (Knockback): Missing arguments, aborting")
			elseif Character:IsA("Model") and Character:FindFirstChild("Humanoid") and Target:IsA("Model") and Target:FindFirstChild("Humanoid") then
				Target.HumanoidRootPart.CFrame = CFrame.lookAt(Target.HumanoidRootPart.Position, Vector3.new(Character.HumanoidRootPart.Position.X, Target.HumanoidRootPart.Position.Y, Character.HumanoidRootPart.Position.Z))
				local KnockBackPos = Target.HumanoidRootPart.CFrame:ToWorldSpace(CFrame.new(0,0,ZValue))
				local KnockBack = Instance.new("BodyPosition", Target.HumanoidRootPart)
				KnockBack.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
				KnockBack.Position = KnockBackPos.p
				KnockBack.D = 150
				KnockBack.P = 2500
				game.Debris:AddItem(KnockBack, .5)
			end
		end,
	},
	
	["MoveForward"] = {
		["Execute"] = function (Target, ZValue)
			local KnockBackPos = Target.HumanoidRootPart.CFrame:ToWorldSpace(CFrame.new(0,0,-ZValue))
			local KnockBack = Instance.new("BodyPosition", Target.HumanoidRootPart)
			KnockBack.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
			KnockBack.Position = KnockBackPos.p
			KnockBack.D = 150
			KnockBack.P = 2500
			game.Debris:AddItem(KnockBack, .5)
		end,
	},
	
	["MoveBackward"] = {
		["Execute"] = function (Target, ZValue)
			local KnockBackPos = Target.HumanoidRootPart.CFrame:ToWorldSpace(CFrame.new(0,0,ZValue))
			local KnockBack = Instance.new("BodyPosition", Target.HumanoidRootPart)
			KnockBack.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
			KnockBack.Position = KnockBackPos.p
			KnockBack.D = 150
			KnockBack.P = 10000
			game.Debris:AddItem(KnockBack, .1)
		end,
	},
	
	["AttackingBool"] = {
		["Execute"] = function (Target, Timer, OriginalWalkSpeed, ...)
			if not Target or not Timer then
				warn("Error (AttackingBool): Missing arguments, aborting")
			elseif Target:IsA("Model") and Target:FindFirstChild("Humanoid") then
				local stunInstance = Instance.new("BoolValue", Target)
				stunInstance.Name = "Attacking"; stunInstance.Value = true
				Target.Humanoid.WalkSpeed -= 10
				task.delay(Timer, function()
					stunInstance.Value = false; game.Debris:AddItem(stunInstance, 0)
					Target.Humanoid.WalkSpeed += 10
				end)
			end
		end,
	},
	
	["GroundUproot"] = {
		["Execute"] = function(Target, ...)
			if not workspace:FindFirstChild("DebrisFolder") then
				local A_1 = Instance.new("Folder", workspace); A_1.Name = "DebrisFolder"
			end
			local RayParams = RaycastParams.new()
			RayParams.FilterDescendantsInstances = {workspace.DebrisFolder}
			RayParams.FilterType = Enum.RaycastFilterType.Blacklist
			local Angle = 0
			for i = 1,30 do
				local HRP = Target:WaitForChild("HumanoidRootPart", 5)
				local Size = math.random(2,3)
				local Part = Instance.new("Part"); Part.Anchored = true; Part.Size = Vector3.new(4,4,4)
				Part.CFrame = HRP.CFrame * CFrame.fromEulerAnglesXYZ(0, math.rad(Angle), 0) * CFrame.new(10, 5, 0); game.Debris:AddItem(Part, 5)
				
				local RayCast = workspace:Raycast(Part.CFrame.p, Part.CFrame.UpVector * -10, RayParams)
				if RayCast then
					Part.Position = RayCast.Position + Vector3.new(0, -5, 0)
					Part.Material = RayCast.Instance.Material
					Part.Color = RayCast.Instance.Color
					Part.Orientation = Vector3.new(math.random(-180,180), math.random(-180,180), math.random(-180,180))
					Part.Parent = workspace.DebrisFolder
					
					local Tween = game:GetService("TweenService"):Create(Part, TweenInfo.new(.25, Enum.EasingStyle.Bounce, Enum.EasingDirection.InOut), {Position = Part.Position + Vector3.new(0, 5, 0)}):Play()
					task.delay(4, function()
						local Tween = game:GetService("TweenService"):Create(Part, TweenInfo.new(1), {Transparency = 1, Position = Part.Position + Vector3.new(0, -5, 0)}):Play()
					end)
				end
				Angle += 25
			end
		end,
	}
}

return CombatHelper
