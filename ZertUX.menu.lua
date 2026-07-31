-- =====================================================
--  Zertyx Menu (UNIVERSAL для BloxStrike)
-- =====================================================

local player = game:GetService("Players").LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "Zertyx"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")

-- ============================================================
--  МЕНЮ
-- ============================================================
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 640, 0, 420)
mainFrame.Position = UDim2.new(0.5, -320, 0.5, -210)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BackgroundTransparency = 0
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 6)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(60, 60, 60)
mainStroke.Thickness = 1
mainStroke.Transparency = 0.5
mainStroke.Parent = mainFrame

-- ХЕДЕР
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 35)
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
header.BackgroundTransparency = 0
header.BorderSizePixel = 0
header.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "Zertyx"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 22
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Center
title.Parent = header

-- ============================================================
--  ВКЛАДКИ (Aim и Esp)
-- ============================================================
local contentContainer = Instance.new("Frame")
contentContainer.Size = UDim2.new(1, 0, 1, -70)
contentContainer.Position = UDim2.new(0, 0, 0, 35)
contentContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
contentContainer.BackgroundTransparency = 0
contentContainer.BorderSizePixel = 0
contentContainer.ClipsDescendants = true
contentContainer.Parent = mainFrame

local pages = {}
local pageNames = {"Aim", "Esp"}

for i, name in ipairs(pageNames) do
    local page = Instance.new("Frame")
    page.Name = name .. "Page"
    page.Size = UDim2.new(1, 0, 1, 0)
    page.Position = UDim2.new(0, 0, 0, 0)
    page.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    page.BackgroundTransparency = 0.2
    page.BorderSizePixel = 0
    page.Visible = (i == 1)
    page.Parent = contentContainer
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = page
    pages[name] = page
end

-- Заглушка для Aim
local aimLabel = Instance.new("TextLabel")
aimLabel.Size = UDim2.new(1, 0, 1, 0)
aimLabel.BackgroundTransparency = 1
aimLabel.Text = "Настройки Aim\n(скоро)"
aimLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
aimLabel.TextSize = 20
aimLabel.Font = Enum.Font.GothamMedium
aimLabel.TextXAlignment = Enum.TextXAlignment.Center
aimLabel.TextYAlignment = Enum.TextYAlignment.Center
aimLabel.Parent = pages["Aim"]

-- Заглушка для Esp
local espLabel = Instance.new("TextLabel")
espLabel.Size = UDim2.new(1, 0, 1, 0)
espLabel.BackgroundTransparency = 1
espLabel.Text = "ESP + Health Bar\n(всегда включены)"
espLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
espLabel.TextSize = 24
espLabel.Font = Enum.Font.GothamBold
espLabel.TextXAlignment = Enum.TextXAlignment.Center
espLabel.TextYAlignment = Enum.TextYAlignment.Center
espLabel.Parent = pages["Esp"]

-- ============================================================
--  УНИВЕРСАЛЬНЫЙ ESP + HEALTH BAR (для BloxStrike)
-- ============================================================
local espObjects = {}
local hue = 0

-- УНИВЕРСАЛЬНЫЙ ПОИСК ЧАСТЕЙ ТЕЛА
local function getRootPart(character)
    if not character then return nil end
    -- Пробуем все возможные варианты
    local root = character:FindFirstChild("HumanoidRootPart")
    if root then return root end
    root = character:FindFirstChild("RootPart")
    if root then return root end
    root = character:FindFirstChild("UpperTorso")
    if root then return root end
    root = character:FindFirstChild("Torso")
    if root then return root end
    -- Если ничего нет, берём любую часть с именем, содержащим "Torso" или "Root"
    for _, child in pairs(character:GetChildren()) do
        if child:IsA("BasePart") and (string.find(child.Name, "Torso") or string.find(child.Name, "Root")) then
            return child
        end
    end
    return nil
end

-- УНИВЕРСАЛЬНЫЙ ПОИСК ГОЛОВЫ
local function getHead(character)
    if not character then return nil end
    local head = character:FindFirstChild("Head")
    if head then return head end
    -- Ищем любую часть с именем, содержащим "Head"
    for _, child in pairs(character:GetChildren()) do
        if child:IsA("BasePart") and string.find(child.Name, "Head") then
            return child
        end
    end
    return nil
end

local function refreshESP()
    -- Удаляем старые объекты
    for plr, data in pairs(espObjects) do
        if data.highlight then data.highlight:Destroy() end
        if data.healthBar then data.healthBar:Destroy() end
    end
    espObjects = {}

    -- Создаём заново для всех игроков (без проверки команд и здоровья)
    for _, plr in pairs(Players:GetPlayers()) do
        if plr == player then continue end
        local char = plr.Character
        if not char then continue end
        
        local head = getHead(char)
        local rootPart = getRootPart(char)
        if not head or not rootPart then continue end

        -- Пропускаем проверку на Humanoid и Health (для BloxStrike)
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid and humanoid.Health <= 0 then continue end

        hue = (hue + 0.1) % 1
        local color = Color3.fromHSV(hue, 0.8, 1)

        local data = {
            character = char,
            humanoid = humanoid,
            head = head,
            rootPart = rootPart
        }

        -- ESP (Highlight)
        local highlight = Instance.new("Highlight")
        highlight.Adornee = char
        highlight.FillColor = color
        highlight.FillTransparency = 0.4
        highlight.OutlineColor = color
        highlight.OutlineTransparency = 0.2
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = char
        data.highlight = highlight

        -- Health Bar
        local billboard = Instance.new("BillboardGui")
        billboard.Size = UDim2.new(0, 80, 0, 20)
        billboard.Adornee = head
        billboard.StudsOffset = Vector3.new(0, 2.5, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = char

        local barFrame = Instance.new("Frame")
        barFrame.Size = UDim2.new(1, 0, 1, 0)
        barFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        barFrame.BackgroundTransparency = 0.3
        barFrame.BorderSizePixel = 0
        barFrame.Parent = billboard

        local fill = Instance.new("Frame")
        fill.Size = UDim2.new(1, 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        fill.BackgroundTransparency = 0
        fill.BorderSizePixel = 0
        fill.Parent = barFrame

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = ""
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 12
        label.Font = Enum.Font.GothamBold
        label.TextXAlignment = Enum.TextXAlignment.Center
        label.TextYAlignment = Enum.TextYAlignment.Center
        label.Parent = billboard

        data.healthBar = billboard
        data.healthFill = fill
        data.healthLabel = label

        espObjects[plr] = data
    end

    -- Обновляем Health Bar (числа)
    for plr, data in pairs(espObjects) do
        if data.healthFill and data.humanoid then
            local health = data.humanoid.Health
            local maxHealth = data.humanoid.MaxHealth
            local percent = math.clamp(health / maxHealth, 0, 1)
            data.healthFill.Size = UDim2.new(percent, 0, 1, 0)
            data.healthLabel.Text = math.round(health) .. "/" .. math.round(maxHealth)
        elseif data.healthFill then
            -- Если Humanoid нет, показываем "100%"
            data.healthFill.Size = UDim2.new(1, 0, 1, 0)
            data.healthLabel.Text = "100%"
        end
    end
end

-- ОБНОВЛЯЕМ КАЖДЫЕ 0.3 СЕКУНДЫ
task.spawn(function()
    while true do
        task.wait(0.3)
        refreshESP()
    end
end)

-- ОБНОВЛЯЕМ HEALTH BAR КАЖДЫЙ КАДР
RunService.RenderStepped:Connect(function()
    for plr, data in pairs(espObjects) do
        if data.healthFill and data.humanoid then
            local health = data.humanoid.Health
            local maxHealth = data.humanoid.MaxHealth
            local percent = math.clamp(health / maxHealth, 0, 1)
            data.healthFill.Size = UDim2.new(percent, 0, 1, 0)
            data.healthLabel.Text = math.round(health) .. "/" .. math.round(maxHealth)
        elseif data.healthFill then
            data.healthFill.Size = UDim2.new(1, 0, 1, 0)
            data.healthLabel.Text = "100%"
        end
    end
end)

-- НОВЫЕ ИГРОКИ
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(0.2)
        refreshESP()
    end)
end)

-- УДАЛЁННЫЕ ИГРОКИ
Players.PlayerRemoving:Connect(function(plr)
    local data = espObjects[plr]
    if data then
        if data.highlight then data.highlight:Destroy() end
        if data.healthBar then data.healthBar:Destroy() end
        espObjects[plr] = nil
    end
end)

-- ============================================================
--  НИЖНИЕ ВКЛАДКИ
-- ============================================================
local tabsBar = Instance.new("Frame")
tabsBar.Size = UDim2.new(1, 0, 0, 35)
tabsBar.Position = UDim2.new(0, 0, 1, -35)
tabsBar.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
tabsBar.BackgroundTransparency = 0
tabsBar.BorderSizePixel = 0
tabsBar.ClipsDescendants = true
tabsBar.Parent = mainFrame

local topLine = Instance.new("Frame")
topLine.Size = UDim2.new(1, 0, 0, 1)
topLine.Position = UDim2.new(0, 0, 0, 0)
topLine.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
topLine.BackgroundTransparency = 0.3
topLine.BorderSizePixel = 0
topLine.Parent = tabsBar

local tabNames = {"Aim", "Esp"}
local tabButtons = {}

for i, name in ipairs(tabNames) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.5, 0, 1, 0)
    btn.Position = UDim2.new((i-1) * 0.5, 0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    btn.BackgroundTransparency = 0.2
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.TextColor3 = (i == 1) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
    btn.TextSize = 18
    btn.Font = Enum.Font.SourceSansBold
    btn.Parent = tabsBar

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    tabButtons[name] = btn

    btn.MouseButton1Click:Connect(function()
        for pageName, page in pairs(pages) do
            page.Visible = (pageName == name)
        end
        for n, b in pairs(tabButtons) do
            if n == name then
                b.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
                b.BackgroundTransparency = 0.1
                b.TextColor3 = Color3.fromRGB(255, 255, 255)
            else
                b.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
                b.BackgroundTransparency = 0.2
                b.TextColor3 = Color3.fromRGB(180, 180, 180)
            end
        end
    end)
end

tabButtons["Aim"].BackgroundColor3 = Color3.fromRGB(60, 60, 70)
tabButtons["Aim"].BackgroundTransparency = 0.1
tabButtons["Aim"].TextColor3 = Color3.fromRGB(255, 255, 255)

print("✅ Zertyx Menu (UNIVERSAL для BloxStrike) загружен!")
