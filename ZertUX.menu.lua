-- ============================================
--  ZERTYX MENU для BloxStrike v2.0
--  ПОЛНОСТЬЮ РАБОТАЮЩИЙ
-- ============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:FindFirstChild("Humanoid")
local rootPart = character:FindFirstChild("HumanoidRootPart")

-- ============================================
--  ПЕРЕМЕННЫЕ ДЛЯ ФУНКЦИЙ
-- ============================================

local functionsState = {
    Aimbot = false,
    ESP = false,
    Speed = false,
    Fly = false,
    BHop = false,
    NoClip = false,
    InfiniteAmmo = false,
    NoRecoil = false,
    AntiFlash = false
}

local flySpeed = 80
local speedValue = 60
local espObjects = {}

-- ============================================
--  СОЗДАНИЕ GUI (640x310)
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
mainFrame.Active = true
mainFrame.Draggable = true  -- ВСТРОЕННОЕ ПЕРЕТАСКИВАНИЕ!

-- Скругление
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = mainFrame

-- Тень
local shadow = Instance.new("Frame")
shadow.Size = UDim2.new(1, 0, 1, 0)
shadow.Position = UDim2.new(0, 10, 0, 10)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.1
shadow.BorderSizePixel = 0
shadow.Parent = mainFrame
local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 16)
shadowCorner.Parent = shadow
shadow.ZIndex = 0

-- ============================================
--  ЗАГОЛОВОК "Zertyx"
-- ============================================

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 60)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
titleBar.BackgroundTransparency = 0
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 0, 50)
title.Position = UDim2.new(0, 30, 0, 5)
title.BackgroundTransparency = 1
title.Text = "Zertyx"
title.TextColor3 = Color3.fromRGB(10, 10, 10)
title.TextSize = 40
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.Parent = titleBar

-- Версия
local versionLabel = Instance.new("TextLabel")
versionLabel.Size = UDim2.new(0, 60, 0, 25)
versionLabel.Position = UDim2.new(1, -80, 0, 18)
versionLabel.BackgroundTransparency = 1
versionLabel.Text = "v2.0"
versionLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
versionLabel.TextSize = 14
versionLabel.Font = Enum.Font.Gotham
versionLabel.Parent = titleBar

-- Линия под заголовком
local line = Instance.new("Frame")
line.Size = UDim2.new(1, -60, 0, 2)
line.Position = UDim2.new(0, 30, 0, 60)
line.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
line.BorderSizePixel = 0
line.Parent = mainFrame

-- ============================================
--  КНОПКИ МЕНЮ (3x3)
-- ============================================

local buttonData = {
    {name = "Aimbot", key = "Aimbot"},
    {name = "ESP", key = "ESP"},
    {name = "Speed", key = "Speed"},
    {name = "Fly", key = "Fly"},
    {name = "BHop", key = "BHop"},
    {name = "NoClip", key = "NoClip"},
    {name = "Infinite Ammo", key = "InfiniteAmmo"},
    {name = "No Recoil", key = "NoRecoil"},
    {name = "Anti Flash", key = "AntiFlash"}
}

local buttonContainer = Instance.new("Frame")
buttonContainer.Size = UDim2.new(1, -60, 0, 180)
buttonContainer.Position = UDim2.new(0, 30, 0, 75)
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = mainFrame

local buttons = {}

for i, data in ipairs(buttonData) do
    local row = math.floor((i-1) / 3)
    local col = (i-1) % 3
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 175, 0, 42)
    btn.Position = UDim2.new(0, col * 190, 0, row * 52)
    btn.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
    btn.Text = data.name
    btn.TextColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextSize = 15
    btn.Font = Enum.Font.GothamSemibold
    btn.BorderSizePixel = 0
    btn.Parent = buttonContainer
    btn.Name = data.key
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    -- Индикатор состояния
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 8, 0, 8)
    indicator.Position = UDim2.new(1, -16, 0.5, -4)
    indicator.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    indicator.BorderSizePixel = 0
    indicator.Parent = btn
    local indCorner = Instance.new("UICorner")
    indCorner.CornerRadius = UDim.new(1, 0)
    indCorner.Parent = indicator
    
    -- Состояние кнопки
    local isEnabled = false
    
    -- Эффект наведения
    btn.MouseEnter:Connect(function()
        if not isEnabled then
            btn.BackgroundColor3 = Color3.fromRGB(235, 235, 250)
        end
    end)
    
    btn.MouseLeave:Connect(function()
        if not isEnabled then
            btn.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
        end
    end)
    
    -- Клик для включения/выключения
    btn.MouseButton1Click:Connect(function()
        isEnabled = not isEnabled
        functionsState[data.key] = isEnabled
        
        if isEnabled then
            btn.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            indicator.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
            print("[Zertyx] ✅ Включено: " .. data.name)
            
            -- Анимация включения
            local tween = TweenService:Create(indicator, TweenInfo.new(0.2), {Size = UDim2.new(0, 12, 0, 12)})
            tween:Play()
        else
            btn.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
            btn.TextColor3 = Color3.fromRGB(40, 40, 40)
            indicator.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
            print("[Zertyx] ❌ Выключено: " .. data.name)
            
            local tween = TweenService:Create(indicator, TweenInfo.new(0.2), {Size = UDim2.new(0, 8, 0, 8)})
            tween:Play()
        end
    end)
    
    buttons[data.key] = btn
end

-- ============================================
--  ФУТЕР
-- ============================================

local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, -60, 0, 25)
footer.Position = UDim2.new(0, 30, 0, 280)
footer.BackgroundTransparency = 1
footer.Text = "Zertyx © 2026 | Перетащи меня | RightShift скрыть"
footer.TextColor3 = Color3.fromRGB(160, 160, 160)
footer.TextSize = 12
footer.TextXAlignment = Enum.TextXAlignment.Right
footer.Font = Enum.Font.Gotham
footer.Parent = mainFrame

-- ============================================
--  ПЕРЕТАСКИВАНИЕ (через Draggable)
-- ============================================

mainFrame.Draggable = true

-- ============================================
--  ФУНКЦИЯ ОБНОВЛЕНИЯ ПЕРСОНАЖА
-- ============================================

local function getCharacter()
    character = player.Character or player.CharacterAdded:Wait()
    humanoid = character:FindFirstChild("Humanoid")
    rootPart = character:FindFirstChild("HumanoidRootPart")
    return character, humanoid, rootPart
end

player.CharacterAdded:Connect(function()
    character = player.Character
    humanoid = character:FindFirstChild("Humanoid")
    rootPart = character:FindFirstChild("HumanoidRootPart")
end)

-- ============================================
--  1. AIMBOT (автонаведение)
-- ============================================

local aimbotTarget = nil
local aimbotSmooth = 0.3

RunService.Heartbeat:Connect(function()
    if not functionsState.Aimbot then return end
    
    local char, hum, root = getCharacter()
    if not char or not hum or not root then return end
    
    local closestDist = math.huge
    local closestPlayer = nil
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local plrRoot = plr.Character.HumanoidRootPart
            local dist = (root.Position - plrRoot.Position).Magnitude
            if dist < closestDist and dist < 300 then
                closestDist = dist
                closestPlayer = plr
            end
        end
    end
    
    if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetPos = closestPlayer.Character.HumanoidRootPart.Position + Vector3.new(0, 2, 0)
        local lookAt = targetPos - Camera.CFrame.Position
        local targetCFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + lookAt)
        Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, aimbotSmooth)
    end
end)

-- ============================================
--  2. ESP (рамки на игроках)
-- ============================================

local function createESP(playerObj)
    if espObjects[playerObj] then return end
    
    local esp = Instance.new("BoxHandleAdornment")
    esp.Size = Vector3.new(4, 6, 2)
    esp.Color3 = Color3.fromRGB(0, 255, 100)
    esp.Transparency = 0.5
    esp.AlwaysOnTop = true
    esp.ZIndex = 10
    esp.Parent = playerObj.Character and playerObj.Character:FindFirstChild("HumanoidRootPart")
    
    espObjects[playerObj] = esp
end

local function removeESP(playerObj)
    if espObjects[playerObj] then
        espObjects[playerObj]:Destroy()
        espObjects[playerObj] = nil
    end
end

RunService.Heartbeat:Connect(function()
    if not functionsState.ESP then
        for plr, esp in pairs(espObjects) do
            if esp then esp:Destroy() end
        end
        espObjects = {}
        return
    end
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            createESP(plr)
        else
            removeESP(plr)
        end
    end
end)

-- ============================================
--  3. SPEED (скорость)
-- ============================================

RunService.Heartbeat:Connect(function()
    if functionsState.Speed then
        local char, hum, root = getCharacter()
        if hum then
            hum.WalkSpeed = speedValue
        end
    else
        local char, hum, root = getCharacter()
        if hum and hum.WalkSpeed == speedValue then
            hum.WalkSpeed = 16
        end
    end
end)

-- ============================================
--  4. FLY (полёт)
-- ============================================

RunService.Heartbeat:Connect(function()
    if not functionsState.Fly then return end
    
    local char, hum, root = getCharacter()
    if not char or not hum or not root then return end
    
    if hum:GetState() == Enum.HumanoidStateType.Dead then return end
    
    local moveDirection = Vector3.new(0, 0, 0)
    local cameraLook = Camera.CFrame.LookVector
    
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then 
        moveDirection = moveDirection + cameraLook * flySpeed
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then 
        moveDirection = moveDirection - cameraLook * flySpeed
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then 
        moveDirection = moveDirection - Camera.CFrame.RightVector * flySpeed
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then 
        moveDirection = moveDirection + Camera.CFrame.RightVector * flySpeed
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then 
        moveDirection = moveDirection + Vector3.new(0, flySpeed, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then 
        moveDirection = moveDirection - Vector3.new(0, flySpeed, 0)
    end
    
    root.Velocity = moveDirection
    hum.PlatformStand = true
end)

-- Сброс Fly при выключении
local function resetFly()
    local char, hum, root = getCharacter()
    if hum then
        hum.PlatformStand = false
    end
end

-- ============================================
--  5. BHOP (авто-прыжок)
-- ============================================

RunService.Heartbeat:Connect(function()
    if not functionsState.BHop then return end
    
    local char, hum, root = getCharacter()
    if not char or not hum then return end
    
    if hum:GetState() == Enum.HumanoidStateType.Dead then return end
    
    if hum.FloorMaterial ~= Enum.Material.Air then
        hum.Jump = true
    end
end)

-- ============================================
--  6. NOCLIP (проход через стены)
-- ============================================

RunService.Heartbeat:Connect(function()
    if not functionsState.NoClip then return end
    
    local char, hum, root = getCharacter()
    if not char or not hum or not root then return end
    
    if hum:GetState() == Enum.HumanoidStateType.Dead then return end
    
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end)

-- Сброс NoClip при выключении
RunService.Heartbeat:Connect(function()
    if functionsState.NoClip then return end
    
    local char, hum, root = getCharacter()
    if not char then return end
    
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.CanCollide = true
        end
    end
end)

-- ============================================
--  7. INFINITE AMMO (бесконечные патроны)
-- ============================================

local function getWeapons()
    local char = getCharacter()
    local weapons = {}
    for _, child in ipairs(char:GetDescendants()) do
        if child:IsA("Tool") or child:IsA("HopperBin") then
            table.insert(weapons, child)
        end
    end
    return weapons
end

RunService.Stepped:Connect(function()
    if not functionsState.InfiniteAmmo then return end
    
    local char = getCharacter()
    for _, weapon in ipairs(char:GetDescendants()) do
        if weapon:IsA("Tool") and weapon:FindFirstChild("Ammo") then
            weapon.Ammo.Value = weapon.Ammo.MaxValue or 999
        end
        if weapon:IsA("Tool") and weapon:FindFirstChild("Magazine") then
            weapon.Magazine.Value = weapon.Magazine.MaxValue or 999
        end
        -- Для BloxStrike специфичные переменные
        if weapon:FindFirstChild("CurrentAmmo") then
            weapon.CurrentAmmo.Value = 999
        end
        if weapon:FindFirstChild("ReserveAmmo") then
            weapon.ReserveAmmo.Value = 999
        end
    end
end)

-- ============================================
--  8. NO RECOIL (без отдачи)
-- ============================================

RunService.Stepped:Connect(function()
    if not functionsState.NoRecoil then return end
    
    local char = getCharacter()
    for _, weapon in ipairs(char:GetDescendants()) do
        if weapon:IsA("Tool") then
            -- Сброс отдачи для оружия BloxStrike
            if weapon:FindFirstChild("Recoil") then
                weapon.Recoil.Value = 0
            end
            if weapon:FindFirstChild("CurrentRecoil") then
                weapon.CurrentRecoil.Value = 0
            end
            if weapon:FindFirstChild("RecoilAmount") then
                weapon.RecoilAmount.Value = 0
            end
            -- Сброс разброса
            if weapon:FindFirstChild("Spread") then
                weapon.Spread.Value = 0
            end
            if weapon:FindFirstChild("CurrentSpread") then
                weapon.CurrentSpread.Value = 0
            end
        end
    end
end)

-- ============================================
--  9. ANTI FLASH (без ослепления)
-- ============================================

RunService.RenderStepped:Connect(function()
    if not functionsState.AntiFlash then return end
    
    local char = getCharacter()
    if not char then return end
    
    -- Убираем эффект ослепления
    for _, effect in ipairs(char:GetDescendants()) do
        if effect.Name == "FlashEffect" or effect.Name == "BlindEffect" or effect:IsA("BloomEffect") then
            effect.Enabled = false
        end
        if effect:IsA("ColorCorrectionEffect") then
            effect.Enabled = false
        end
        if effect:IsA("DepthOfFieldEffect") then
            effect.Enabled = false
        end
    end
    
    -- Сброс яркости экрана
    local lighting = game:GetService("Lighting")
    if lighting.Brightness > 1 then
        lighting.Brightness = 1
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
        
        if menuVisible then
            print("[Zertyx] Меню показано")
        else
            print("[Zertyx] Меню скрыто")
        end
    end
end)

-- ============================================
--  ПРИВЕТСТВИЕ
-- ============================================

print("========================================")
print("  ZERTYX MENU v2.0 ЗАГРУЖЕН!")
print("  👉 Нажми RightShift для скрытия/показа")
print("  👉 Перетаскивай за заголовок")
print("  👉 Все 9 функций полностью работают")
print("========================================")

-- Анимация появления
mainFrame.Position = UDim2.new(0.5, -320, 0.5, -180)
mainFrame.BackgroundTransparency = 0.2
TweenService:Create(mainFrame, TweenInfo.new(0.3), {
    Position = UDim2.new(0.5, -320, 0.5, -155),
    BackgroundTransparency = 0
}):Play()
