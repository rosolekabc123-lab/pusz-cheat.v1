pcall(function()
if not game:IsLoaded() then
	game.Loaded:Wait()
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HRP = Character:WaitForChild("HumanoidRootPart")
local Camera = workspace.CurrentCamera

-- GUI Parent
local parent = game:FindFirstChild("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")
local gui = Instance.new("ScreenGui", parent)
gui.Name = "PUSZ-HUB"
gui.ResetOnSpawn = false

-- Voidware Style Main Frame
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 320, 0, 400)
main.Position = UDim2.new(0.5, -160, 0.5, -200)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0,14)

-- Title
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "PUSZ HUB (by Puszek_OfficialYT)"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18

-- Utility function for buttons
local function createButton(text,posY,color)
	local btn = Instance.new("TextButton", main)
	btn.Position = UDim2.new(0,20,0,posY)
	btn.Size = UDim2.new(0,280,0,35)
	btn.Text = text
	btn.BackgroundColor3 = color
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 16
	Instance.new("UICorner", btn)
	return btn
end

-- Fly
local flying = false
local flySpeed = 50
local bv, bg
local flyBtn = createButton("Fly: OFF",50,Color3.fromRGB(50,50,50))
flyBtn.MouseButton1Click:Connect(function()
	flying = not flying
	flyBtn.Text = flying and "Fly: ON" or "Fly: OFF"
	if flying then
		bv = Instance.new("BodyVelocity", HRP)
		bv.MaxForce = Vector3.new(400000,400000,400000)
		bg = Instance.new("BodyGyro", HRP)
		bg.MaxTorque = Vector3.new(400000,400000,400000)
	else
		if bv then bv:Destroy() end
		if bg then bg:Destroy() end
	end
end)

-- Speed / Sprint
local speedOn = false
local normalSpeed = 16
local sprintSpeed = 50
local speedBtn = createButton("Speed: OFF",100,Color3.fromRGB(50,50,50))
speedBtn.MouseButton1Click:Connect(function()
	speedOn = not speedOn
	speedBtn.Text = speedOn and "Speed: ON" or "Speed: OFF"
	Humanoid.WalkSpeed = speedOn and sprintSpeed or normalSpeed
end)

-- Noclip
local noclipOn = false
local noclipBtn = createButton("Noclip: OFF",150,Color3.fromRGB(50,50,50))
noclipBtn.MouseButton1Click:Connect(function()
	noclipOn = not noclipOn
	noclipBtn.Text = noclipOn and "Noclip: ON" or "Noclip: OFF"
end)
RunService.Stepped:Connect(function()
	if noclipOn then
		for _, part in pairs(Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)

-- JumpBoost
local jumpBoostOn = false
local jumpBoostPower = 100
local jumpBtn = createButton("JumpBoost: OFF",200,Color3.fromRGB(50,50,50))
jumpBtn.MouseButton1Click:Connect(function()
	jumpBoostOn = not jumpBoostOn
	jumpBtn.Text = jumpBoostOn and "JumpBoost: ON" or "JumpBoost: OFF"
	Humanoid.JumpPower = jumpBoostOn and jumpBoostPower or 50
end)

-- ESP
local espOn = false
local espBtn = createButton("ESP: OFF",250,Color3.fromRGB(50,50,50))
espBtn.MouseButton1Click:Connect(function()
	espOn = not espOn
	espBtn.Text = espOn and "ESP: ON" or "ESP: OFF"
end)

local espBoxes = {}
RunService.RenderStepped:Connect(function()
	if espOn then
		for _, plr in pairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
				if not espBoxes[plr] then
					local box = Instance.new("BoxHandleAdornment")
					box.Adornee = plr.Character.HumanoidRootPart
					box.Color3 = Color3.fromRGB(255,0,0)
					box.Size = Vector3.new(2,3,1)
					box.Transparency = 0.5
					box.AlwaysOnTop = true
					box.Parent = workspace
					espBoxes[plr] = box
				end
			end
		end
	else
		for _, box in pairs(espBoxes) do
			box:Destroy()
		end
		espBoxes = {}
	end
end)

-- Teleport to player
local tpBtn = createButton("Teleport to Player",300,Color3.fromRGB(50,50,50))
tpBtn.MouseButton1Click:Connect(function()
	local targetName = game:GetService("Players"):GetPlayers()[2] -- przykładowo teleport do 2 gracza w liscie
	if targetName and targetName.Character and targetName.Character:FindFirstChild("HumanoidRootPart") then
		HRP.CFrame = targetName.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
	end
end)

-- Discord
local discordBtn = createButton("Join Discord",350,Color3.fromRGB(114,137,218))
discordBtn.MouseButton1Click:Connect(function()
	if setclipboard then
		setclipboard("https://discord.puszekcraft.pl")
	end
	game.StarterGui:SetCore("SendNotification", {
		Title = "Discord",
		Text = "Link skopiowany – otwórz w przeglądarce",
		Duration = 4
	})
end)

-- Fly movement update
RunService.Heartbeat:Connect(function()
	if flying and HRP then
		local move = Vector3.new(0,0,0)
		local keys = game:GetService("UserInputService"):GetKeysPressed()
		for _, key in pairs(keys) do
			if key.KeyCode == Enum.KeyCode.W then move = move + Camera.CFrame.LookVector end
			if key.KeyCode == Enum.KeyCode.S then move = move - Camera.CFrame.LookVector end
			if key.KeyCode == Enum.KeyCode.A then move = move - Camera.CFrame.RightVector end
			if key.KeyCode == Enum.KeyCode.D then move = move + Camera.CFrame.RightVector end
		end
		if bv then
			bv.Velocity = move.Unit * flySpeed
		end
	end
end)

end)
