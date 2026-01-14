pcall(function()
-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Local Player
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HRP = Character:WaitForChild("HumanoidRootPart")
local Camera = workspace.CurrentCamera

-- GUI Parent
local parent = game:FindFirstChild("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")
local gui = Instance.new("ScreenGui", parent)
gui.Name = "PUSZ_HUB"
gui.ResetOnSpawn = false

-- Toggle GUI visibility
local guiVisible = true
UserInputService.InputBegan:Connect(function(input, gp)
	if not gp and input.KeyCode == Enum.KeyCode.RightControl then
		guiVisible = not guiVisible
		gui.Enabled = guiVisible
	end
end)

-- Main Frame
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 340, 0, 500)
main.Position = UDim2.new(0.5, -170, 0.5, -250)
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
	btn.Size = UDim2.new(0,300,0,35)
	btn.Text = text
	btn.BackgroundColor3 = color
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 16
	Instance.new("UICorner", btn)
	return btn
end

-- SPEED / SPRINT
local speedOn = false
local normalSpeed = 16
local sprintSpeed = 50
local speedBtn = createButton("Speed: OFF",50,Color3.fromRGB(50,50,50))
speedBtn.MouseButton1Click:Connect(function()
	speedOn = not speedOn
	speedBtn.Text = speedOn and "Speed: ON" or "Speed: OFF"
	Humanoid.WalkSpeed = speedOn and sprintSpeed or normalSpeed
end)

-- FLY
local flying = false
local flySpeed = 50
local flyBtn = createButton("Fly: OFF",100,Color3.fromRGB(50,50,50))

flyBtn.MouseButton1Click:Connect(function()
	flying = not flying
	flyBtn.Text = flying and "Fly: ON" or "Fly: OFF"
end)

-- Fly movement
RunService.Heartbeat:Connect(function()
	if flying then
		local moveVector = Vector3.new(0,0,0)
		local camCF = Camera.CFrame
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVector = moveVector + camCF.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVector = moveVector - camCF.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVector = moveVector - camCF.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVector = moveVector + camCF.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVector = moveVector + Vector3.new(0,1,0) end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveVector = moveVector - Vector3.new(0,1,0) end
		if moveVector.Magnitude > 0 then
			moveVector = moveVector.Unit
		end
		HRP.Velocity = moveVector * flySpeed
	end
end)

-- JUMPBOOST
local jumpBoostOn = false
local jumpPower = 100
local jumpBtn = createButton("JumpBoost: OFF",150,Color3.fromRGB(50,50,50))
jumpBtn.MouseButton1Click:Connect(function()
	jumpBoostOn = not jumpBoostOn
	jumpBtn.Text = jumpBoostOn and "JumpBoost: ON" or "JumpBoost: OFF"
	Humanoid.JumpPower = jumpBoostOn and jumpPower or 50
end)

-- NOCLIP
local noclipOn = false
local noclipBtn = createButton("Noclip: OFF",200,Color3.fromRGB(50,50,50))
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

-- ESP
local espOn = false
local espBtn = createButton("ESP: OFF",250,Color3.fromRGB(50,50,50))
local espBoxes = {}
espBtn.MouseButton1Click:Connect(function()
	espOn = not espOn
	espBtn.Text = espOn and "ESP: ON" or "ESP: OFF"
	if not espOn then
		for _, box in pairs(espBoxes) do box:Destroy() end
		espBoxes = {}
	end
end)
RunService.RenderStepped:Connect(function()
	if espOn then
		for _, plr in pairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
				if not espBoxes[plr] then
					local box = Instance.new("BoxHandleAdornment")
					box.Adornee = plr.Character.HumanoidRootPart
					box.Size = Vector3.new(2,3,1)
					box.Color3 = Color3.fromRGB(255,0,0)
					box.Transparency = 0.5
					box.AlwaysOnTop = true
					box.Parent = workspace
					espBoxes[plr] = box
				end
			end
		end
	end
end)

-- PLAYER TELEPORT
local teleportFrameVisible = false
local playersListFrame = Instance.new("Frame", main)
playersListFrame.Size = UDim2.new(0,300,0,0) -- początkowo schowane
playersListFrame.Position = UDim2.new(0,20,0,310)
playersListFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
Instance.new("UICorner", playersListFrame)
local uiList = Instance.new("UIListLayout", playersListFrame)
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Padding = UDim.new(0,5)

local selectedPlayer

local function refreshPlayerList()
	for i,v in pairs(playersListFrame:GetChildren()) do
		if v:IsA("TextButton") then v:Destroy() end
	end
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			local btn = Instance.new("TextButton", playersListFrame)
			btn.Size = UDim2.new(1,0,0,25)
			btn.Text = plr.Name
			btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
			btn.TextColor3 = Color3.fromRGB(255,255,255)
			btn.Font = Enum.Font.Gotham
			btn.TextSize = 14
			Instance.new("UICorner", btn)
			btn.MouseButton1Click:Connect(function()
				selectedPlayer = plr
			end)
		end
	end
	if teleportFrameVisible then
		local count = #playersListFrame:GetChildren()
		playersListFrame.Size = UDim2.new(0,300,0,25*count)
	else
		playersListFrame.Size = UDim2.new(0,300,0,0)
	end
end

refreshPlayerList()
Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(refreshPlayerList)

-- Teleport Button
local tpBtn = createButton("Teleport: Click to Choose",420,Color3.fromRGB(50,50,50))
tpBtn.MouseButton1Click:Connect(function()
	teleportFrameVisible = not teleportFrameVisible
	refreshPlayerList()
	if selectedPlayer then
		HRP.CFrame = selectedPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
	end
end)

-- Discord Button
local discordBtn = createButton("Join Discord",470,Color3.fromRGB(114,137,218))
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

end)
