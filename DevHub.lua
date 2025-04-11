if getgenv().DevHubLoaded then return end
getgenv().DevHubLoaded = true

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local flySpeed = 50
local flying = false
local flyConnection
local noclip = false
local verticalFly = 0

-- GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "DevHubUI"
ScreenGui.ResetOnSpawn = false

local function createUICorner(obj, rad)
	local uic = Instance.new("UICorner", obj)
	uic.CornerRadius = UDim.new(0, rad)
end

local function createButton(text)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 40)
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.Text = text
	createUICorner(btn, 10)
	return btn
end

local function createTabButton(text)
	local btn = createButton(text)
	btn.Size = UDim2.new(0, 120, 0, 40)
	return btn
end

-- Floating Button
local floatingButton = Instance.new("TextButton", ScreenGui)
floatingButton.Size = UDim2.new(0, 50, 0, 50)
floatingButton.Position = UDim2.new(0, 20, 0.5, -25)
floatingButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
floatingButton.TextColor3 = Color3.new(1, 1, 1)
floatingButton.Text = "≡"
floatingButton.Visible = false
createUICorner(floatingButton, 10)

-- Fly Up/Down Buttons
local flyUpBtn = createButton("↑")
flyUpBtn.Size = UDim2.new(0, 50, 0, 50)
flyUpBtn.Position = UDim2.new(1, -60, 0.5, -80)
flyUpBtn.Visible = false
flyUpBtn.TextSize = 24
flyUpBtn.Parent = ScreenGui

local flyDownBtn = createButton("↓")
flyDownBtn.Size = UDim2.new(0, 50, 0, 50)
flyDownBtn.Position = UDim2.new(1, -60, 0.5, -20)
flyDownBtn.Visible = false
flyDownBtn.TextSize = 24
flyDownBtn.Parent = ScreenGui

-- Drag fly buttons by dragging Up button
local dragging = false
flyUpBtn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		local start = input.Position
		local origUp = flyUpBtn.Position
		local origDown = flyDownBtn.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)

		UserInputService.InputChanged:Connect(function(input2)
			if dragging and (input2.UserInputType == Enum.UserInputType.MouseMovement or input2.UserInputType == Enum.UserInputType.Touch) then
				local delta = input2.Position - start
				flyUpBtn.Position = origUp + UDim2.new(0, delta.X, 0, delta.Y)
				flyDownBtn.Position = origDown + UDim2.new(0, delta.X, 0, delta.Y)
			end
		end)
	end
end)

flyUpBtn.MouseButton1Down:Connect(function()
	verticalFly = 1
end)
flyUpBtn.MouseButton1Up:Connect(function()
	verticalFly = 0
end)

flyDownBtn.MouseButton1Down:Connect(function()
	verticalFly = -1
end)
flyDownBtn.MouseButton1Up:Connect(function()
	verticalFly = 0
end)

-- Drag and Drop for floating button
local draggingFloat, dragInput, dragStart, startPos = false, nil, nil, nil
floatingButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingFloat = true
		dragStart = input.Position
		startPos = floatingButton.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				draggingFloat = false
			end
		end)
	end
end)

floatingButton.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if draggingFloat and input == dragInput then
		local delta = input.Position - dragStart
		floatingButton.Position = UDim2.new(
			0, math.clamp(startPos.X.Offset + delta.X, 0, workspace.CurrentCamera.ViewportSize.X - 50),
			0, math.clamp(startPos.Y.Offset + delta.Y, 0, workspace.CurrentCamera.ViewportSize.Y - 50)
		)
	end
end)

-- Main HUD
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 400, 0, 240)
Main.Position = UDim2.new(0.5, -200, 0.5, -120)
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Main.Visible = true
createUICorner(Main, 12)

local tabButtonsFrame = Instance.new("Frame", Main)
tabButtonsFrame.Size = UDim2.new(1, 0, 0, 40)
tabButtonsFrame.BackgroundTransparency = 1

local miscTabButton = createTabButton("Misc")
miscTabButton.Position = UDim2.new(0, 10, 0, 0)
miscTabButton.Parent = tabButtonsFrame

local closeBtn = createTabButton("X")
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -90, 0, 0)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.Parent = tabButtonsFrame
closeBtn.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
	getgenv().DevHubLoaded = nil
end)

local minimizeBtn = createTabButton("-")
minimizeBtn.Size = UDim2.new(0, 40, 0, 40)
minimizeBtn.Position = UDim2.new(1, -50, 0, 0)
minimizeBtn.Parent = tabButtonsFrame
minimizeBtn.MouseButton1Click:Connect(function()
	Main.Visible = false
	floatingButton.Visible = true
end)

floatingButton.MouseButton1Click:Connect(function()
	Main.Visible = true
	floatingButton.Visible = false
end)

tabButtonsFrame.Parent = Main

-- Misc Page
local miscPage = Instance.new("Frame", Main)
miscPage.Size = UDim2.new(1, 0, 1, -40)
miscPage.Position = UDim2.new(0, 0, 0, 40)
miscPage.BackgroundTransparency = 1
miscPage.Visible = true
miscPage.Parent = Main

miscTabButton.MouseButton1Click:Connect(function()
	miscPage.Visible = true
end)

-- Fly
local function FlyFunc()
	local character = LocalPlayer.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local cam = workspace.CurrentCamera
	if not root or not humanoid then return end

	if flying then
		if flyConnection then flyConnection:Disconnect() end
		local existing = root:FindFirstChild("DevHubFly")
		if existing then existing:Destroy() end
		humanoid.PlatformStand = false
		flying = false
		flyUpBtn.Visible = false
		flyDownBtn.Visible = false
		return
	end

	flying = true
	local bodyVel = Instance.new("BodyVelocity")
	bodyVel.Name = "DevHubFly"
	bodyVel.MaxForce = Vector3.new(1,1,1) * 1e6
	bodyVel.Velocity = Vector3.zero
	bodyVel.Parent = root

	humanoid.PlatformStand = true
	flyUpBtn.Visible = true
	flyDownBtn.Visible = true

	flyConnection = RunService.RenderStepped:Connect(function()
		local camCF = cam.CFrame
		local forward = camCF.LookVector
		local right = camCF.RightVector
		local moveVec = Vector3.zero

		if UserInputService:GetLastInputType() == Enum.UserInputType.Touch then
			moveVec = humanoid.MoveDirection
		else
			local inputX, inputY, inputZ = 0, verticalFly, 0
			if UserInputService:IsKeyDown(Enum.KeyCode.W) then inputZ = inputZ - 1 end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) then inputZ = inputZ + 1 end
			if UserInputService:IsKeyDown(Enum.KeyCode.A) then inputX = inputX - 1 end
			if UserInputService:IsKeyDown(Enum.KeyCode.D) then inputX = inputX + 1 end
			moveVec = (right * inputX) + (forward * inputZ) + Vector3.new(0, inputY, 0)
		end

		if moveVec.Magnitude > 1 then
			moveVec = moveVec.Unit
		end

		bodyVel.Velocity = moveVec * flySpeed
	end)
end

-- NoClip
RunService.Stepped:Connect(function()
	if noclip then
		for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
			if v:IsA("BasePart") and v.CanCollide then
				v.CanCollide = false
			end
		end
	end
end)

-- Botões Misc
local flyBtn = createButton("Fly (Ativar/Desativar)")
flyBtn.Position = UDim2.new(0, 10, 0, 10)
flyBtn.Size = UDim2.new(1, -20, 0, 40)
flyBtn.Parent = miscPage
flyBtn.MouseButton1Click:Connect(FlyFunc)

local speedSlider = Instance.new("TextBox", miscPage)
speedSlider.Size = UDim2.new(1, -20, 0, 40)
speedSlider.Position = UDim2.new(0, 10, 0, 60)
speedSlider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
speedSlider.TextColor3 = Color3.new(1, 1, 1)
speedSlider.Font = Enum.Font.Gotham
speedSlider.Text = "Velocidade: 50"
speedSlider.TextSize = 14
createUICorner(speedSlider, 6)

speedSlider.FocusLost:Connect(function()
	local val = tonumber(speedSlider.Text:match("%d+"))
	if val and val >= 20 and val <= 200 then
		flySpeed = val
		speedSlider.Text = "Velocidade: "..val
	else
		speedSlider.Text = "Velocidade: "..flySpeed
	end
end)

local noclipBtn = createButton("NoClip (Ativar/Desativar)")
noclipBtn.Position = UDim2.new(0, 10, 0, 110)
noclipBtn.Size = UDim2.new(1, -20, 0, 40)
noclipBtn.Parent = miscPage
noclipBtn.MouseButton1Click:Connect(function()
	noclip = not noclip
end)
