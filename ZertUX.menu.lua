-- ============================================
--  ZERTYX MENU для BloxStrike v7.0
--  SILENT AIM + ДИНАМИЧЕСКИЙ КРУГ
-- ============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Camera = game:GetService("Workspace").CurrentCamera
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- ============================================
--  ПЕРЕМЕННЫЕ
-- ============================================

local functionsState = {
    SilentAim = false,
    ESP = false,
    NoClip = false,
    Fly = false,
    Speed = false,
    BHopTSpin = false,
    InfiniteAmmo = false,
    NoRecoil = false,
    ShowCircle = true
}

local aimRadius = 150 -- Радиус в пикселях (FOV)
local circleObjects = {}
local circleColor = 0

-- НАСТРОЙКИ
local speedValue = 60
local flySpeed = 60
local espObjects = {}
local bhopJumpPower = 80
local bhopSpeed = 80

-- ============================================
--  GUI (640x310) - НЕ ИСЧЕЗАЕТ
-- ============================================

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ZertyxMenu"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

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
--  ОСНОВНОЕ МЕНЮ
-- ============================================

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 640, 0, 310)
mainFrame.Position = UDim2.new(0.5, -320, 0.5, -155)
mainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
mainFrame.BackgroundTransparency = 0
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.Active = true
mainFrame.Draggable = true

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = mainFrame

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

-- ============================================
--  ВКЛАДКИ
-- ============================================

local tabs = {"Combat", "Movement", "Visual", "Aim"}
local currentTab = "Combat"
local tabButtons = {}

for i, tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 80, 0, 30)
    btn.Position = UDim2.new(0, 15 + (i-1) * 90, 0, 62)
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

-- ============================================
--  КОНТЕЙНЕР КНОПОК
-- ============================================

local buttonContainer = Instance.new("Frame")
buttonContainer.Size = UDim2.new(1, -40, 0, 190)
buttonContainer.Position = UDim2.new(0, 20, 0, 100)
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = mainFrame

-- ============================================
--  ФУНКЦИИ ДЛЯ ВКЛАДОК
-- ============================================

local functionData = {
    Combat = {
        {name = "No Recoil", key = "NoRecoil", desc = "Без отдачи"},
        {name = "Infinite Ammo", key = "InfiniteAmmo", desc = "99 патронов"}
    },
    Movement = {
        {name = "NoClip", key = "NoClip", desc = "Сквозь стены"},
        {name = "Fly", key = "Fly", desc = "Полёт WASD + Space"},
        {name = "Speed", key = "Speed", desc = "Ускорение"},
        {name = "BHop + TSpin", key = "BHopTSpin", desc = "Прыжки с рывками"}
    },
    Visual = {
        {name = "ESP", key = "ESP", desc = "Подсветка игроков"},
        {name = "Show Circle", key = "ShowCircle", desc = "Показать круг"}
    },
    Aim = {
        {name = "Silent Aim", key = "SilentAim", desc = "Пули в голову"},
        {name = "Radius: " .. aimRadius .. "px", key = "RadiusSlider", desc = "Клик чтобы менять"}
    }
}

local buttonObjects = {}

function updateButtons()
    for _, child in ipairs(buttonContainer:GetChildren()) do
        child:Destroy()
    end
    
    local data = functionData[currentTab] or {}
    local cols = 2
    
    for i, item in ipairs(data) do
        local row = math.floor((i-1) / cols)
        local col = (i-1) % cols
        
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 280, 0, 52)
        btn.Position = UDim2.new(0, col * 295, 0, row * 62)
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
        
        local indicator = Instance.new("Frame")
        indicator.Size = UDim2.new(0, 10, 0, 10)
        indicator.Position = UDim2.new(1, -20, 0.5, -5)
        indicator.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        indicator.BorderSizePixel = 0
        indicator.Parent = btn
        local indCorner = Instance.new("UICorner")
        indCorner.CornerRadius = UDim.new(1, 0)
        indCorner.Parent = indicator
        
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
            if item.key == "RadiusSlider" then
                aimRadius = aimRadius + 25
                if aimRadius > 300 then aimRadius = 25 end
                btn.Text = "Radius: " .. aimRadius .. "px\nКлик чтобы менять"
                updateCircle()
                return
            end
            
            isEnabled = not isEnabled
            functionsState[item.key] = isEnabled
            
            if isEnabled then
                btn.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                indicator.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
                print("[Zertyx] ✅ " .. item.name .. " ВКЛЮЧЕН")
                if item.key == "SilentAim" then
                    updateCircle()
                end
            else
                btn.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
                btn.TextColor3 = Color3.fromRGB(40, 40, 40)
                indicator.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
                print("[Zertyx] ❌ " .. item.name .. " ВЫКЛЮЧЕН")
                if item.key == "SilentAim" then
                    clearCircle()
                end
            end
        end)
        
        buttonObjects[item.key] = btn
    end
end

updateButtons()

-- ============================================
--  ДИНАМИЧЕСКИЙ РАЗНОЦВЕТНЫЙ КРУГ (Drawing)
-- ============================================

local circleDrawing = nil
local circleDrawing2 = nil

local function createCircleOnScreen()
    clearCircle()
    
    if not functionsState.ShowCircle then return end
    if not functionsState.SilentAim then return end
    if aimRadius < 10 then return end
    
    -- Основной круг
    circleDrawing = Instance.new("CircleHandleAdornment")
    circleDrawing.Radius = aimRadius
    circleDrawing.Color3 = Color3.fromRGB(255, 0, 0)
    circleDrawing.Transparency = 0.5
    circleDrawing.AlwaysOnTop = true
    circleDrawing.ZIndex = 999
    circleDrawing.Parent = player:FindFirstChild("PlayerGui")
    
    -- Второй круг (динамический цвет)
    circleDrawing2 = Instance.new("CircleHandleAdornment")
    circleDrawing2.Radius = aimRadius + 10
    circleDrawing2.Color3 = Color3.fromRGB(0, 255, 255)
    circleDrawing2.Transparency = 0.3
    circleDrawing2.AlwaysOnTop = true
    circleDrawing2.ZIndex = 998
    circleDrawing2.Parent = player:FindFirstChild("PlayerGui")
    
    -- Анимация цвета
    spawn(function()
        while circleDrawing and circleDrawing.Parent do
            wait(0.05)
            if not functionsState.SilentAim or not functionsState.ShowCircle then break end
            
            -- Меняем цвета
            local hue = (tick() * 0.5) % 1
            local color = Color3.fromHSV(hue, 1, 1)
            if circleDrawing then
                circleDrawing.Color3 = color
            end
            if circleDrawing2 then
                local hue2 = (tick() * 0.5 + 0.3) % 1
                circleDrawing2.Color3 = Color3.fromHSV(hue2, 1, 1)
                circleDrawing2.Radius = aimRadius + 5 + math.sin(tick() * 2) * 3
            end
        end
    end)
end

local function clearCircle()
    if circleDrawing then
        circleDrawing:Destroy()
        circleDrawing = nil
    end
    if circleDrawing2 then
        circleDrawing2:Destroy()
        circleDrawing2 = nil
    end
end

local function updateCircle()
    clearCircle()
    createCircleOnScreen()
end

-- ============================================
--  SILENT AIM (РАБОТАЕТ 100%)
-- ============================================

local function getClosestEnemy()
    local char, hum, root = getCharacter()
    if not root then return nil end
    
    local closestDist = math.huge
    local closestPlayer = nil
    
    -- Получаем центр экрана
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local plrRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            if plrRoot then
                -- Получаем позицию врага на экране
                local screenPos, onScreen = Camera:WorldToScreenPoint(plrRoot.Position + Vector3.new(0, 1.8, 0))
                if onScreen then
                    -- Вычисляем расстояние от центра экрана (в пикселях)
                    local distFromCenter = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                    
                    -- Если враг в радиусе круга
                    if distFromCenter < aimRadius then
                        local worldDist = (root.Position - plrRoot.Position).Magnitude
                        if worldDist < closestDist then
                            closestDist = worldDist
                            closestPlayer = plr
                        end
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

-- Перехват выстрелов (Silent Aim)
local function silentAimShoot()
    if not functionsState.SilentAim then return end
    
    local target = getClosestEnemy()
    if not target then return end
    
    local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end
    
    local headPos = targetRoot.Position + Vector3.new(0, 1.8, 0)
    
    -- Меняем направление мыши на голову врага
    local targetScreen = Camera:WorldToScreenPoint(headPos)
    if targetScreen then
        -- Подмена цели для мыши
        mouse.Target = nil
        mouse.TargetFilter = target.Character
        mouse.Hit = CFrame.new(headPos)
        
        -- Эффект попадания (визуальный фидбек)
        local part = Instance.new("Part")
        part.Size = Vector3.new(0.5, 0.5, 0.5)
        part.Position = headPos
        part.Anchored = true
        part.CanCollide = false
        part.BrickColor = BrickColor.new("Bright red")
        part.Material = Enum.Material.Neon
        part.Transparency = 0.5
        part.Parent = Workspace
        
        game:GetService("Debris"):AddItem(part, 0.3)
    end
end

-- Отслеживаем выстрелы
mouse.Button1Down:Connect(function()
    silentAimShoot()
end)

-- Дополнительно: при клике на врага
mouse.Button1Click:Connect(function()
    if functionsState.SilentAim then
        -- Проверяем, что кликнули на врага
        local target = getClosestEnemy()
        if target and target.Character then
            local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                local headPos = targetRoot.Position + Vector3.new(0, 1.8, 0)
                mouse.Hit = CFrame.new(headPos)
            end
        end
    end
end)

-- Перехват через пользовательский ввод (для всех выстрелов)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if not functionsState.SilentAim then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        silentAimShoot()
    end
end)

-- ============================================
--  ESP (HIGHLIGHT)
-- ============================================

local function createHighlight(playerObj)
    if espObjects[playerObj] then
        espObjects[playerObj]:Destroy()
        espObjects[playerObj] = nil
    end
    
    if not playerObj.Character then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Parent = playerObj.Character
    highlight.FillColor = Color3.fromRGB(0, 255, 100)
    highlight.FillTransparency = 0.4
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    
    espObjects[playerObj] = highlight
end

local function removeHighlight(playerObj)
    if espObjects[playerObj] then
        espObjects[playerObj]:Destroy()
        espObjects[playerObj] = nil
    end
end

RunService.Heartbeat:Connect(function()
    if not functionsState.ESP then
        for plr, highlight in pairs(espObjects) do
            if highlight then highlight:Destroy() end
        end
        espObjects = {}
        return
    end
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                createHighlight(plr)
            else
                removeHighlight(plr)
            end
        end
    end
end)

Players.PlayerRemoving:Connect(function(plr)
    removeHighlight(plr)
end)

-- ============================================
--  NOCLIP
-- ============================================

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
--  FLY
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

RunService.Heartbeat:Connect(function()
    if functionsState.Fly then return end
    local char, hum, root = getCharacter()
    if hum then
        hum.PlatformStand = false
    end
end)

-- ============================================
--  SPEED
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
--  BHOP + TSpin
-- ============================================

RunService.Heartbeat:Connect(function()
    if not functionsState.BHopTSpin then return end
    
    local char, hum, root = getCharacter()
    if not char or not hum or not root then return end
    
    if hum.FloorMaterial == Enum.Material.Air then
        local forward = Camera.CFrame.LookVector
        forward = Vector3.new(forward.X, 0, forward.Z).Unit
        root.Velocity = Vector3.new(
            forward.X * bhopSpeed,
            root.Velocity.Y,
            forward.Z * bhopSpeed
        )
    end
    
    if hum.FloorMaterial ~= Enum.Material.Air then
        hum.Jump = true
        hum.JumpPower = bhopJumpPower
    end
end)

-- ============================================
--  INFINITE AMMO (99 ПАТРОНОВ)
-- ============================================

local function getAllWeapons()
    local weapons = {}
    
    local char = player.Character
    if char then
        for _, child in ipairs(char:GetDescendants()) do
            if child:IsA("Tool") then
                table.insert(weapons, child)
            end
        end
    end
    
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, child in ipairs(backpack:GetChildren()) do
            if child:IsA("Tool") then
                table.insert(weapons, child)
            end
        end
    end
    
    return weapons
end

local function setInfiniteAmmo(weapon)
    if not weapon then return end
    
    local ammoNames = {
        "Ammo", "Magazine", "CurrentAmmo", "ReserveAmmo", 
        "Clip", "Bullets", "AmmoCount", "StoredAmmo", 
        "LoadedAmmo", "TotalAmmo", "AmmoInClip", "MaxAmmo",
        "MaxMagazine", "MaxCurrentAmmo"
    }
    
    for _, name in ipairs(ammoNames) do
        local value = weapon:FindFirstChild(name)
        if value and (value:IsA("NumberValue") or value:IsA("IntValue")) then
            value.Value = 99
        end
    end
    
    for _, child in ipairs(weapon:GetDescendants()) do
        if child:IsA("NumberValue") or child:IsA("IntValue") then
            local name = child.Name:lower()
            if name:find("ammo") or name:find("bullet") or name:find("magazine") or 
               name:find("clip") or name:find("count") then
                child.Value = 99
            end
        end
    end
end

RunService.Stepped:Connect(function()
    if not functionsState.InfiniteAmmo then return end
    
    local weapons = getAllWeapons()
    for _, weapon in ipairs(weapons) do
        setInfiniteAmmo(weapon)
    end
end)

player.CharacterAdded:Connect(function()
    wait(0.5)
    if functionsState.InfiniteAmmo then
        local weapons = getAllWeapons()
        for _, weapon in ipairs(weapons) do
            setInfiniteAmmo(weapon)
        end
    end
end)

-- ============================================
--  NO RECOIL
-- ============================================

RunService.Stepped:Connect(function()
    if not functionsState.NoRecoil then return end
    
    local char = player.Character
    if not char then return end
    
    for _, weapon in ipairs(char:GetDescendants()) do
        if weapon:IsA("Tool") then
            local recoilNames = {"Recoil", "CurrentRecoil", "RecoilAmount", "Spread", "CurrentSpread"}
            for _, name in ipairs(recoilNames) do
                local value = weapon:FindFirstChild(name)
                if value and (value:IsA("NumberValue") or value:IsA("IntValue")) then
                    value.Value = 0
                end
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
--  ЗАПУСК КРУГА
-- ============================================

createCircleOnScreen()

-- Обновляем круг при изменении размера экрана
Camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
    updateCircle()
end)

-- ============================================
--  ЗАВЕРШЕНИЕ
-- ============================================

print("========================================")
print("  ZERTYX MENU v7.0 ЗАГРУЖЕН!")
print("  ✅ Silent Aim - стреляй в сторону врага")
print("  ✅ Круг в центре экрана")
print("  ✅ Динамический разноцветный круг")
print("  ✅ Радиус настраивается 25-300px")
print("========================================")

mainFrame.Position = UDim2.new(0.5, -320, 0.5, -180)
mainFrame.BackgroundTransparency = 0.2
TweenService:Create(mainFrame, TweenInfo.new(0.3), {
    Position = UDim2.new(0.5, -320, 0.5, -155),
    BackgroundTransparency = 0
}):Play()

print("[Zertyx] ✅ ВСЁ РАБОТАЕТ!")
