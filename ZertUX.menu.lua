-- ============================================
--  ZERTYX MENU для BloxStrike v3.0
--  С ВКЛАДКАМИ И РАБОЧИМИ ФУНКЦИЯМИ
-- ============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Переменные состояния
local functionsState = {
    Aimbot = false,
    ESP = false,
    NoClip = false,
    AntiFlash = false,
    InfinityJump = false,
    Speed = false,
    BHop = false,
    InfiniteAmmo = false,
    NoRecoil = false
}

-- Настройки
local speedValue = 60
local espObjects = {}
local aimbotSmooth = 0.25
local aimbotRange = 300
local jumpPower = 50

-- ============================================
--  БЕЗОПАСНОЕ ПОЛУЧЕНИЕ ПЕРСОНАЖА
-- ============================================

local function getCharacter()
    local char = player.Character
    if not char then return nil, nil, nil end
    local hum = char:FindFirstChild("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    return char, hum, root
end

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
mainFrame.Draggable = true

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
--  ЗАГОЛОВОК
-- ============================================

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 55)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
titleBar.BackgroundTransparency = 0
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 0, 45)
title.Position = UDim2.new(0, 25, 0, 5)
title.BackgroundTransparency = 1
title.Text = "Zertyx"
title.TextColor3 = Color3.fromRGB(10, 10, 10)
title.TextSize = 36
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.Parent = titleBar

-- Кнопки вкладок
local tabs = {"Combat", "Movement", "Visual", "Other"}
local currentTab = "Combat"
local tabButtons = {}

for i, tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 80, 0, 30)
    btn.Position = UDim2.new(0, 20 + (i-1) * 85, 0, 62)
    btn.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
    btn.Text = tabName
    btn.TextColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamSemibold
    btn.BorderSizePixel = 0
    btn.Parent = mainFrame
    btn.Name = tabName
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    if i == 1 then
        btn.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
    
    btn.MouseButton1Click:Connect(function()
        currentTab = tabName
        for _, b in ipairs(tabButtons) do
            b.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
            b.TextColor3 = Color3.fromRGB(40, 40, 40)
        end
        btn.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        updateButtons()
    end)
    
    tabButtons[tabName] = btn
end

-- Контейнер для кнопок
local buttonContainer = Instance.new("Frame")
buttonContainer.Size = UDim2.new(1, -40, 0, 180)
buttonContainer.Position = UDim2.new(0, 20, 0, 100)
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = mainFrame

-- ============================================
--  ФУНКЦИИ ДЛЯ КАЖДОЙ ВКЛАДКИ
-- ============================================

local functionData = {
    Combat = {
        {name = "Aimbot", key = "Aimbot", desc = "Автонаведение"},
        {name = "No Recoil", key = "NoRecoil", desc = "Без отдачи"},
        {name = "Infinite Ammo", key = "InfiniteAmmo", desc = "Беск. патроны"}
    },
    Movement = {
        {name = "NoClip", key = "NoClip", desc = "Сквозь стены"},
        {name = "Infinity Jump", key = "InfinityJump", desc = "Беск. прыжок"},
        {name = "Speed", key = "Speed", desc = "Ускорение"},
        {name = "BHop", key = "BHop", desc = "Авто-прыжок"}
    },
    Visual = {
        {name = "ESP", key = "ESP", desc = "Рамки на игроках"},
        {name = "Anti Flash", key = "AntiFlash", desc = "Без ослепления"}
    },
    Other = {
        {name = "Доп. функция 1", key = "Other1", desc = "Скоро будет"},
        {name = "Доп. функция 2", key = "Other2", desc = "Скоро будет"}
    }
}

local buttons = {}
local buttonObjects = {}

function updateButtons()
    -- Очищаем контейнер
    for _, child in ipairs(buttonContainer:GetChildren()) do
        child:Destroy()
    end
    
    local data = functionData[currentTab] or {}
    local cols = 2
    local rows = math.ceil(#data / cols)
    
    for i, item in ipairs(data) do
        local row = math.floor((i-1) / cols)
        local col = (i-1) % cols
        
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 280, 0, 50)
        btn.Position = UDim2.new(0, col * 295, 0, row * 60)
        btn.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
        btn.Text = item.name .. "\n" .. item.desc
        btn.TextColor3 = Color3.fromRGB(40, 40, 40)
        btn.TextSize = 14
        btn.Font = Enum.Font.GothamSemibold
        btn.BorderSizePixel = 0
        btn.Parent = buttonContainer
        btn.Name = item.key
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = btn
        
        -- Индикатор
        local indicator = Instance.new("Frame")
        indicator.Size = UDim2.new(0, 10, 0, 10)
        indicator.Position = UDim2.new(1, -20, 0.5, -5)
        indicator.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        indicator.BorderSizePixel = 0
        indicator.Parent = btn
        local indCorner = Instance.new("UICorner")
        indCorner.CornerRadius = UDim.new(1, 0)
        indCorner.Parent = indicator
        
        -- Состояние
        local isEnabled = false
        
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
        
        btn.MouseButton1Click:Connect(function()
            isEnabled = not isEnabled
            functionsState[item.key] = isEnabled
            
            if isEnabled then
                btn.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                indicator.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
                print("[Zertyx] ✅ " .. item.name .. " ВКЛЮЧЕН")
            else
                btn.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
                btn.TextColor3 = Color3.fromRGB(40, 40, 40)
                indicator.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
                print("[Zertyx] ❌ " .. item.name .. " ВЫКЛЮЧЕН")
            end
        end)
        
        buttonObjects[item.key] = btn
    end
end

-- Обновляем кнопки
updateButtons()

-- ============================================
--  ФУНКЦИИ
-- ============================================

-- 1. AIMBOT (исправленный)
RunService.Heartbeat:Connect(function()
    if not functionsState.Aimbot then return end
    
    local char, hum, root = getCharacter()
    if not char or not hum or not root then return end
    
    local closestDist = math.huge
    local closestPlayer = nil
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local plrRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            if plrRoot then
                local dist = (root.Position - plrRoot.Position).Magnitude
                if dist < closestDist and dist < aimbotRange then
                    closestDist = dist
                    closestPlayer = plr
                end
            end
        end
    end
    
    if closestPlayer and closestPlayer.Character then
        local targetRoot = closestPlayer.Character:FindFirstChild("HumanoidRootPart")
        if targetRoot then
            local targetPos = targetRoot.Position + Vector3.new(0, 1.5, 0)
            local lookAt = targetPos - Camera.CFrame.Position
            local targetCFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + lookAt)
            Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, aimbotSmooth)
        end
    end
end)

-- 2. NOCLIP (исправленный - работает всегда)
RunService.Heartbeat:Connect(function()
    if not functionsState.NoClip then return end
    
    local char, hum, root = getCharacter()
    if not char then return end
    
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end)

-- Восстановление коллизий при выключении
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

-- 3. INFINITY JUMP (бесконечный прыжок)
RunService.Heartbeat:Connect(function()
    if not functionsState.InfinityJump then return end
    
    local char, hum, root = getCharacter()
    if not hum then return end
    
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        hum.Jump = true
        hum.JumpPower = jumpPower
    end
end)

-- 4. ANTI FLASH (исправленный)
RunService.RenderStepped:Connect(function()
    if not functionsState.AntiFlash then return end
    
    -- Убираем все эффекты ослепления
    for _, v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect") then
            v.Enabled = false
        end
        if v.Name:find("Flash") or v.Name:find("Blind") then
            if v:IsA("BasePart") then
                v.Transparency = 1
            elseif v:IsA("Model") then
                v:Destroy()
            end
        end
    end
    
    -- Сбрасываем яркость
    local lighting = game:GetService("Lighting")
    if lighting.Brightness > 1 then
        lighting.Brightness = 1
    end
end)

-- 5. ESP (исправленный)
local function createESP(playerObj)
    if espObjects[playerObj] then return end
    if not playerObj.Character then return end
    
    local root = playerObj.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local esp = Instance.new("BoxHandleAdornment")
    esp.Size = Vector3.new(4, 6, 2)
    esp.Color3 = Color3.fromRGB(0, 255, 100)
    esp.Transparency = 0.5
    esp.AlwaysOnTop = true
    esp.ZIndex = 10
    esp.Parent = root
    
    espObjects[playerObj] = esp
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
        end
    end
end)

-- 6. SPEED
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

-- 7. BHOP
RunService.Heartbeat:Connect(function()
    if not functionsState.BHop then return end
    
    local char, hum, root = getCharacter()
    if not hum then return end
    
    if hum.FloorMaterial ~= Enum.Material.Air then
        hum.Jump = true
    end
end)

-- 8. INFINITE AMMO
RunService.Stepped:Connect(function()
    if not functionsState.InfiniteAmmo then return end
    
    local char, hum, root = getCharacter()
    if not char then return end
    
    for _, weapon in ipairs(char:GetDescendants()) do
        if weapon:IsA("Tool") then
            if weapon:FindFirstChild("Ammo") then
                weapon.Ammo.Value = 999
            end
            if weapon:FindFirstChild("Magazine") then
                weapon.Magazine.Value = 999
            end
            if weapon:FindFirstChild("CurrentAmmo") then
                weapon.CurrentAmmo.Value = 999
            end
        end
    end
end)

-- 9. NO RECOIL
RunService.Stepped:Connect(function()
    if not functionsState.NoRecoil then return end
    
    local char, hum, root = getCharacter()
    if not char then return end
    
    for _, weapon in ipairs(char:GetDescendants()) do
        if weapon:IsA("Tool") then
            if weapon:FindFirstChild("Recoil") then
                weapon.Recoil.Value = 0
            end
            if weapon:FindFirstChild("Spread") then
                weapon.Spread.Value = 0
            end
        end
    end
end)

-- ============================================
--  УПРАВЛЕНИЕ
-- ============================================

local menuVisible = true

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        menuVisible = not menuVisible
        mainFrame.Visible = menuVisible
    end
end)

-- ============================================
--  ЗАВЕРШЕНИЕ
-- ============================================

print("========================================")
print("  ZERTYX MENU v3.0 ЗАГРУЖЕН!")
print("  👉 Вкладки: Combat, Movement, Visual, Other")
print("  👉 NoClip работает на любой карте")
print("  👉 Aimbot наводится на врагов")
print("  👉 Anti Flash убирает ослепление")
print("========================================")

-- Анимация
mainFrame.Position = UDim2.new(0.5, -320, 0.5, -180)
mainFrame.BackgroundTransparency = 0.2
TweenService:Create(mainFrame, TweenInfo.new(0.3), {
    Position = UDim2.new(0.5, -320, 0.5, -155),
    BackgroundTransparency = 0
}):Play()

print("[Zertyx] ✅ Скрипт полностью готов!")
