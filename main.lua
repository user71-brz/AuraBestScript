-- Gui principal
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local wins = player:WaitForChild("leaderstats"):WaitForChild("Wins")

-- Config
local WIN_POS = Vector3.new(-222, 341, 126)
local LAP_POS = Vector3.new(-220, 342, 110)
local AUTO_WIN_DELAY = 55

-- Contador de vitórias durante execução
local winsAtStart = wins.Value
local sessionWins = 0

-- Criar GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "AuraAutoWin"
gui.ResetOnSpawn = false

-- Frame principal
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 260, 0, 270)
frame.Position = UDim2.new(0.05, 0, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = true

local uiCorner = Instance.new("UICorner", frame)
uiCorner.CornerRadius = UDim.new(0, 8)

local uiStroke = Instance.new("UIStroke", frame)
uiStroke.Color = Color3.fromRGB(0, 255, 255)
uiStroke.Thickness = 1.5

-- Cabeçalho
local header = Instance.new("TextButton", frame)
header.Size = UDim2.new(1, 0, 0, 35)
header.Text = "Ability Tower v2"
header.Font = Enum.Font.GothamBold
header.TextSize = 16
header.TextColor3 = Color3.fromRGB(0, 255, 255)
header.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
header.AutoButtonColor = false

local headerCorner = Instance.new("UICorner", header)
headerCorner.CornerRadius = UDim.new(0, 8)

-- Conteúdo interno
local contentHolder = Instance.new("Frame", frame)
contentHolder.Size = UDim2.new(1, 0, 1, -35)
contentHolder.Position = UDim2.new(0, 0, 0, 35)
contentHolder.BackgroundTransparency = 1
contentHolder.Name = "Content"

local contentVisible = true
header.MouseButton1Click:Connect(function()
	contentVisible = not contentVisible
	contentHolder.Visible = contentVisible
	frame.Size = contentVisible and UDim2.new(0, 260, 0, 270) or UDim2.new(0, 260, 0, 35)
end)

-- Criador de botões
local function createButton(text, yPos)
	local btn = Instance.new("TextButton", contentHolder)
	btn.Size = UDim2.new(1, -20, 0, 30)
	btn.Position = UDim2.new(0, 10, 0, yPos)
	btn.Text = text
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

	local corner = Instance.new("UICorner", btn)
	corner.CornerRadius = UDim.new(0, 6)

	return btn
end

-- Botões
local btnLap = createButton("TP to Lap", 10)
btnLap.MouseButton1Click:Connect(function()
	local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if root then root.CFrame = CFrame.new(LAP_POS) end
end)

local btnTPWin = createButton("TP to Win", 50)
btnTPWin.MouseButton1Click:Connect(function()
	local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if root then root.CFrame = CFrame.new(WIN_POS) end
end)

-- Auto Win
local autoWinEnabled = false
local btnAuto = createButton("Auto Win: OFF", 90)

btnAuto.MouseButton1Click:Connect(function()
	autoWinEnabled = not autoWinEnabled
	btnAuto.Text = "Auto Win: " .. (autoWinEnabled and "ON" or "OFF")
	btnAuto.BackgroundColor3 = autoWinEnabled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(50, 50, 50)

	if autoWinEnabled then
		local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
		if root then root.CFrame = CFrame.new(WIN_POS) end
	end
end)

-- Timer
local timerLabel = Instance.new("TextLabel", contentHolder)
timerLabel.Size = UDim2.new(1, -20, 0, 20)
timerLabel.Position = UDim2.new(0, 10, 0, 130)
timerLabel.Text = "Próximo TP em: 0s"
timerLabel.Font = Enum.Font.Gotham
timerLabel.TextSize = 12
timerLabel.TextColor3 = Color3.new(1, 1, 1)
timerLabel.BackgroundTransparency = 1

-- Vitórias
local winLabel = Instance.new("TextLabel", contentHolder)
winLabel.Size = UDim2.new(1, -20, 0, 20)
winLabel.Position = UDim2.new(0, 10, 0, 155)
winLabel.Text = "Vitórias farmadas ao total: 0"
winLabel.Font = Enum.Font.Gotham
winLabel.TextSize = 12
winLabel.TextColor3 = Color3.new(1, 1, 1)
winLabel.BackgroundTransparency = 1

wins:GetPropertyChangedSignal("Value"):Connect(function()
	local diff = wins.Value - winsAtStart
	if diff > sessionWins then
		sessionWins = diff
		winLabel.Text = "Vitórias farmadas ao total: " .. sessionWins
	end
end)

-- ESP
local espEnabled = false
local btnESP = createButton("ESP: OFF", 185)
btnESP.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

btnESP.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	btnESP.Text = "ESP: " .. (espEnabled and "ON" or "OFF")
	btnESP.BackgroundColor3 = espEnabled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(50, 50, 50)

	for _, v in ipairs(workspace:GetDescendants()) do
		if v:IsA("Highlight") and v.Name == "ESP_Highlight" then
			v.Enabled = espEnabled
		end
		if v:IsA("BillboardGui") and v.Name == "ESP_NameTag" then
			v.Enabled = espEnabled
		end
	end
end)

-- Auto Win loop
task.spawn(function()
	while true do
		if autoWinEnabled and player.Character then
			local root = player.Character:FindFirstChild("HumanoidRootPart")
			if root then
				root.CFrame = CFrame.new(WIN_POS)
				for i = AUTO_WIN_DELAY, 0, -1 do
					if not autoWinEnabled then break end
					timerLabel.Text = "Próximo TP em: " .. i .. "s"
					task.wait(1)
				end
			end
		end
		task.wait(0.5)
	end
end)

-- ESP visual
local function createESP(target)
	local highlight = Instance.new("Highlight")
	highlight.Adornee = target
	highlight.FillTransparency = 1
	highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
	highlight.OutlineTransparency = 0
	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	highlight.Name = "ESP_Highlight"
	highlight.Enabled = false
	highlight.Parent = target

	local nameTag = Instance.new("BillboardGui")
	nameTag.Name = "ESP_NameTag"
	nameTag.Size = UDim2.new(0, 100, 0, 20)
	nameTag.Adornee = target:WaitForChild("Head")
	nameTag.AlwaysOnTop = true
	nameTag.StudsOffset = Vector3.new(0, 2.5, 0)
	nameTag.Enabled = false
	nameTag.Parent = target

	local label = Instance.new("TextLabel", nameTag)
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = target.Name
	label.TextColor3 = Color3.new(1, 1, 1)
	label.Font = Enum.Font.Gotham
	label.TextSize = 14
end

local function addESPToPlayers()
	for _, plr in ipairs(game.Players:GetPlayers()) do
		if plr ~= player and plr.Character and not plr.Character:FindFirstChild("ESP_Highlight") then
			createESP(plr.Character)
		end
	end
end

addESPToPlayers()
game.Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function()
		task.wait(1)
		addESPToPlayers()
	end)
end)

print("✅ Script carregado com sucesso!")
