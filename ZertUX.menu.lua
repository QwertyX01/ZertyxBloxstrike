-- =====================================================
--  Zertyx (ESP + AimBot Toggle + Бесконечные патроны)
-- =====================================================

local player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")

-- ============================================================
--  НАСТРОЙКИ
-- ============================================================
local ESP_ENABLED = true
local AIMBOT_ENABLED = true
local INFINITE_AMMO = true

-- ============================================================
--  ESP (ПОДСВЕТКА ВРАГОВ)
-- ============================================================
local espObjects = {}
local hue = 0

local function getRootPart(character)
    if not character then return nil end
    local root = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("RootPart") or character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
    if root then return root end
    for _, child in pairs(character:GetChildren()) do
        if child:IsA("BasePart") and (string.find(child.Name, "Torso") or string.find(child.Name, "Root")) then
            return child
        end
    end
    return nil
end

local function getHead(character)
    if not character then return nil end
    local head = character:FindFirstChild("Head")
    if head then return head end
    for _, child in pairs(character:GetChildren()) do
        if child:IsA("BasePart") and string.find(child.Name, "Head") then
            return child
        end
    end
    return nil
end

local function isEnemy(plr)
    if plr == player then return false end
    if not plr.Character then return false end
    local humanoid = plr.Character:FindFirstChild("Humanoid")
    if humanoid and humanoid.Health <= 0 then return false end
    if player.Team and plr.Team and player.Team == plr.Team then return false end
    return true
end

local function refreshESP()
    for plr, data in pairs(espObjects) do
        if data.highlight then data.highlight:Destroy() end
    end
    espObjects = {}

    for _, plr in pairs(Players:GetPlayers()) do
        if not isEnemy(plr) then continue end
        local char = plr.Character
        if not char then continue end
        
        local head = getHead(char)
        local rootPart = getRootPart(char)
        if not head or not rootPart then continue end

        hue = (hue + 0.1) % 1
        local color = Color3.fromHSV(hue, 0.8, 1)

        local highlight = Instance.new("Highlight")
        highlight.Adornee = char
        highlight.FillColor = color
        highlight.FillTransparency = 0.4
        highlight.OutlineColor = color
        highlight.OutlineTransparency = 0.2
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = char

        espObjects[plr] = { highlight = highlight, character = char }
    end
end

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(0.5)
        refreshESP()
    end)
end)

task.wait(1)
refreshESP()

-- ============================================================
--  AIMBOT (ПО ТОГГЛУ)
-- ============================================================
local aimbotActive = false

local function getClosestEnemy()
    local character = player.Character
    if not character then return nil end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    local closest = nil
    local closestDist = math.huge
    local camPos = Camera.CFrame.Position
    local camLook = Camera.CFrame.LookVector

    for _, plr in pairs(Players:GetPlayers()) do
        if not isEnemy(plr) then continue end
        local char = plr.Character
        if not char then continue end
        local head = getHead(char)
        if not head then continue end
        
        local headPos = head.Position
        local dirToHead = (headPos - camPos).Unit
        
        if dirToHead:Dot(camLook) < 0 then continue end
        
        local dist = (hrp.Position - headPos).Magnitude
        if dist < closestDist then
            closestDist = dist
            closest = head
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if not AIMBOT_ENABLED then return end
    if not aimbotActive then return end
    
    local targetHead = getClosestEnemy()
    if not targetHead then return end
    
    local camPos = Camera.CFrame.Position
    Camera.CFrame = CFrame.new(camPos, targetHead.Position)
end)

-- ============================================================
--  БЕСКОНЕЧНЫЕ ПАТРОНЫ (99)
-- ============================================================
local function setInfiniteAmmo()
    local character = player.Character
    if not character then return end
    
    for _, tool in pairs(character:GetChildren()) do
        if tool:IsA("Tool") then
            for _, child in pairs(tool:GetDescendants()) do
                if child:IsA("NumberValue") and (
                    string.find(child.Name, "Ammo") or 
                    string.find(child.Name, "Bullet") or 
                    string.find(child.Name, "Magazine") or
                    string.find(child.Name, "Count") or
                    string.find(child.Name, "CurrentAmmo") or
                    string.find(child.Name, "StoredAmmo")
                ) then
                    child.Value = 99
                end
            end
        end
    end
    
    for _, child in pairs(player:GetDescendants()) do
        if child:IsA("NumberValue") and (
            string.find(child.Name, "Ammo") or 
            string.find(child.Name, "Bullet") or 
            string.find(child.Name, "Magazine") or
            string.find(child.Name, "Count") or
            string.find(child.Name, "CurrentAmmo") or
            string.find(child.Name, "StoredAmmo")
        ) then
            child.Value = 99
        end
    end
end

if INFINITE_AMMO then
    task.spawn(function()
        while true do
            task.wait(0.2)
            setInfiniteAmmo()
        end
    end)
end

-- ============================================================
--  GUI ДЛЯ ТЕЛЕФОНА (TOGGLE КНОПКА)
-- ============================================================
local gui = Instance.new("ScreenGui")
gui.Name = "Zertyx"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Информационная панель
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 50)
mainFrame.Position = UDim2.new(0.5, -100, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 1, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Zertyx\nESP: ON | Ammo: INF"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextSize = 14
statusLabel.Font = Enum.Font.GothamMedium
statusLabel.TextXAlignment = Enum.TextXAlignment.Center
statusLabel.TextYAlignment = Enum.TextYAlignment.Center
statusLabel.Parent = mainFrame

-- КНОПКА AIMBOT TOGGLE
local aimButton = Instance.new("TextButton")
aimButton.Size = UDim2.new(0, 120, 0, 60)
aimButton.Position = UDim2.new(0.5, -60, 0.8, 0)
aimButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
aimButton.BackgroundTransparency = 0.2
aimButton.BorderSizePixel = 0
aimButton.Text = "🎯 AIM OFF"
aimButton.TextColor3 = Color3.fromRGB(255, 255, 255)
aimButton.TextSize = 22
aimButton.Font = Enum.Font.GothamBold
aimButton.ZIndex = 10
aimButton.Parent = gui

local aimCorner = Instance.new("UICorner")
aimCorner.CornerRadius = UDim.new(0, 12)
aimCorner.Parent = aimButton

-- TOGGLE ЛОГИКА
aimButton.MouseButton1Click:Connect(function()
    aimbotActive = not aimbotActive
    
    if aimbotActive then
        aimButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        aimButton.Text = "🎯 AIM ON"
        print("✅ AimBot ВКЛЮЧЁН")
    else
        aimButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        aimButton.Text = "🎯 AIM OFF"
        print("❌ AimBot ВЫКЛЮЧЁН")
    end
end)

print("✅ Zertyx для телефона загружен! Нажми кнопку AIM для включения/выключения AimBot.")
