-- ============================================
--  ZERTYX MENU для BloxStrike v1.0
--  Белое меню 640x310
-- ============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- ============================================
--  СОЗДАНИЕ GUI
-- ============================================

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ZertyxMenu"
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 640, 0, 310)
mainFrame.Position = UDim2.new(0.5, -320, 0.5, -155)
mainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
mainFrame.BackgroundTransparency = 0
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Скругление
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = mainFrame

-- ============================================
--  ЗАГОЛОВОК "Zertyx"
-- ============================================

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 0, 55)
title.Position = UDim2.new(0, 30, 0, 15)
title.BackgroundTransparency = 1
title.Text = "Zertyx"
title.TextColor3 = Color3.fromRGB(10, 10, 10)
title.TextSize = 40
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

-- Линия под заголовком
local line = Instance.new("Frame")
line.Size = UDim2.new(1, -60, 0, 2)
line.Position = UDim2.new(0, 30, 0, 75)
line.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
line.BorderSizePixel = 0
line.Parent = mainFrame

-- ============================================
--  КНОПКИ МЕНЮ (3 колонки x 3 ряда)
-- ============================================

local functions = {
    {name = "Aimbot",    enabled = false},
    {name = "ESP",       enabled = false},
    {name = "Speed",     enabled = false},
    {name = "Fly",       enabled = false},
    {name = "BHop",      enabled = false},
    {name = "NoClip",    enabled = false},
    {name = "Infinite Ammo", enabled = false},
    {name = "No Recoil", enabled = false},
    {name = "Anti Flash", enabled = false}
}

local buttonContainer = Instance.new("Frame")
buttonContainer.Size = UDim2.new(1, -60, 0, 180)
buttonContainer.Position = UDim2.new(0, 30, 0, 90)
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = mainFrame

local buttons = {}

for i, data in ipairs(functions) do
    local row = math.floor((i-1) / 3)
    local col = (i-1) % 3
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 175, 0, 42)
    btn.Position = UDim2.new(0, col * 190, 0, row * 52)
    btn.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
    btn.Text = data.name
    btn.TextColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextSize = 16
    btn.Font = Enum.Font.GothamMedium
    btn.BorderSizePixel = 0
    btn.Parent = buttonContainer
    btn.Name = data.name
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    -- Переменная состояния
    local isEnabled = false
    
    -- Эффект наведения
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(230, 230, 255)
    end)
    
    btn.MouseLeave:Connect(function()
        if isEnabled then
            btn.BackgroundColor3 = Color3.fromRGB(180, 220, 255)
        else
            btn.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
        end
    end)
    
    -- Клик для включения/выключения
    btn.MouseButton1Click:Connect(function()
        isEnabled = not isEnabled
        if isEnabled then
            btn.BackgroundColor3 = Color3.fromRGB(180, 220, 255)
            btn.TextColor3 = Color3.fromRGB(0, 80, 200)
            print("[Zertyx] Включено: " .. data.name)
        else
            btn.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
            btn.TextColor3 = Color3.fromRGB(30, 30, 30)
            print("[Zertyx] Выключено: " .. data.name)
        end
    end)
    
    buttons[data.name] = btn
end

-- ============================================
--  ФУТЕР
-- ============================================

local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, -60, 0, 25)
footer.Position = UDim2.new(0, 30, 0, 280)
footer.BackgroundTransparency = 1
footer.Text = "Zertyx © 2026 | Перетащи меня"
footer.TextColor3 = Color3.fromRGB(160, 160, 160)
footer.TextSize = 12
footer.TextXAlignment = Enum.TextXAlignment.Right
footer.Font = Enum.Font.Gotham
footer.Parent = mainFrame

-- ============================================
--  ПЕРЕТАСКИВАНИЕ МЕНЮ
-- ============================================

local dragging = false
local dragStart = nil
local startPos = nil

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

title.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- ============================================
--  РЕАЛИЗАЦИЯ ФУНКЦИЙ (примеры)
-- ============================================

-- 1. Fly (полёт)
local flyEnabled = false
local flySpeed = 50

RunService.Heartbeat:Connect(function()
    if flyEnabled then
        local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if root then
            local moveDirection = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + Vector3.new(0, 0, -flySpeed) end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection + Vector3.new(0, 0, flySpeed) end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection + Vector3.new(-flySpeed, 0, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + Vector3.new(flySpeed, 0, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDirection = moveDirection + Vector3.new(0, flySpeed, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDirection = moveDirection + Vector3.new(0, -flySpeed, 0) end
            
            root.Velocity = moveDirection * 2
        end
    end
end)

-- 2. BHop (авто-прыжок)
local bHopEnabled = false

RunService.Heartbeat:Connect(function()
    if bHopEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
        local humanoid = player.Character.Humanoid
        if humanoid.FloorMaterial ~= Enum.Material.Air then
            humanoid.Jump = true
        end
    end
end)

-- 3. Speed (скорость)
local speedEnabled = false
local speedValue = 50

RunService.Heartbeat:Connect(function()
    if speedEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
        local humanoid = player.Character.Humanoid
        humanoid.WalkSpeed = 50
    end
end)

-- ============================================
--  КЛАВИША ДЛЯ ОТКРЫТИЯ/ЗАКРЫТИЯ МЕНЮ
-- ============================================

local menuVisible = true

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        menuVisible = not menuVisible
        mainFrame.Visible = menuVisible
    end
end)

print("[Zertyx] Меню загружено! Нажми RightShift для скрытия/показа")
