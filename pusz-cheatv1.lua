pcall(function()

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")

-- GUI PARENT (DELTA SAFE)
local parent = game:FindFirstChild("CoreGui") or player:WaitForChild("PlayerGui")

local gui = Instance.new("ScreenGui")
gui.Name = "pusz-cheat"
gui.ResetOnSpawn = false
gui.Parent = parent

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,260,0,220)
main.Position = UDim2.new(0.5,-130,0.5,-110)
main.BackgroundColor3 = Color3.fromRGB(30,30,30)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0,14)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = " PUSZ-CHEAT
  (Loader)"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 20

-- SPEED
local speedOn = false
local speedBtn = Instance.new("TextButton", main)
speedBtn.Position = UDim2.new(0,20,0,50)
speedBtn.Size = UDim2.new(0,220,0,35)
speedBtn.Text = "Speed: OFF"
speedBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
speedBtn.TextColor3 = Color3.new(1,1,1)
speedBtn.Font = Enum.Font.Gotham
speedBtn.TextSize = 16
Instance.new("UICorner", speedBtn)

speedBtn.MouseButton1Click:Connect(function()
	speedOn = not speedOn
	speedBtn.Text = speedOn and "Speed: ON" or "Speed: OFF"
	humanoid.WalkSpeed = speedOn and 50 or 16
end)

-- FLY
local flying = false
local bv, bg

local flyBtn = Instance.new("TextButton", main)
  flyBtn.Position = UDim2.new(0
