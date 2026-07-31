-- =====================================================
--  Zertyx Menu (ДИНАМИЧЕСКИЙ ESP + Health Bar)
-- =====================================================

local player = game:GetService("Players").LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "Zertyx"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")

-- ============================================================
--  ОСНОВНОЕ МЕНЮ
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

-- ============================================================
--  ХЕДЕР
-- ============================================================
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 35)
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
header.BackgroundTransparency = 0
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 6)
headerCorner.Parent = header

local headerStroke = Instance.new("UIStroke")
headerStroke.Color = Color3.fromRGB(60, 60, 60)
headerStroke.Thickness = 1
headerStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
headerStroke.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.5, 0, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Zertyx"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 20
title.Font = Enum.Font.GothamMedium
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextYAlignment = Enum.TextYAlignment.Center
title.Parent = header

-- ============================================================
--  КОНТЕЙНЕР СТРАНИЦ
-- ============================================================
local contentContainer = Instance.new("Frame")
contentContainer.Name = "ContentContainer"
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

-- ============================================================
--  ВКЛАДКА AIM (пустая)
-- ============================================================
local aimPage = pages["Aim"]

local dividerAim = Instance.new("Frame")
dividerAim.Size = UDim2.new(0, 2, 1, 0)
dividerAim.Position = UDim2.new(0.5, -1, 0, 0)
dividerAim.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
dividerAim.BackgroundTransparency = 0.4
dividerAim.BorderSizePixel = 0
dividerAim.Parent = aimPage

local leftHalfAim = Instance.new("Frame")
leftHalfAim.Size = UDim2.new(0.5, -5, 1, 0)
leftHalfAim.Position = UDim2.new(0, 5, 0, 0)
leftHalfAim.BackgroundTransparency = 1
leftHalfAim.Parent = aimPage

local placeholderLabel = Instance.new("TextLabel")
placeholderLabel.Size = UDim2.new(1, 0, 1, 0)
placeholderLabel.BackgroundTransparency = 1
placeholderLabel.Text = "Настройки Aim\n(скоро)"
placeholderLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
placeholderLabel.TextSize = 20
placeholderLabel.Font = Enum.Font.GothamMedium
placeholderLabel.TextXAlignment = Enum.TextXAlignment.Center
placeholderLabel.TextYAlignment = Enum.TextYAlignment.Center
placeholderLabel.Parent = leftHalfAim

local rightHalfAim = Instance.new("Frame")
rightHalfAim.Size = UDim2.new(0.5, -5, 1, 0)
rightHalfAim.Position = UDim2.new(0.5, 5, 0, 0)
rightHalfAim.BackgroundTransparency = 1
rightHalfAim.Parent = aimPage

local rightLabelAim = Instance.new("TextLabel")
rightLabelAim.Size = UDim2.new(1, 0, 1, 0)
rightLabelAim.BackgroundTransparency = 1
rightLabelAim.Text = "настройки\n(скоро)"
rightLabelAim.TextColor3 = Color3.fromRGB(150, 150, 150)
rightLabelAim.TextSize = 20
rightLabelAim.Font = Enum.Font.GothamMedium
rightLabelAim.TextXAlignment = Enum.TextXAlignment.Center
rightLabelAim.TextYAlignment = Enum.TextYAlignment.Center
rightLabelAim.Parent = rightHalfAim

-- ============================================================
--  ВКЛАДКА ESP (ДИНАМИЧЕСКИЙ ESP + HEALTH BAR)
-- ============================================================
local espPage = pages["Esp"]

-- ESP и Health Bar всегда включены
local espObjects = {}
local hue = 0

local function getRootPart(character)
    if not character then return nil end
    return character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("RootPart") or character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
end

local function refreshESP()
    for plr, data in pairs(espObjects) do
        if data.highlight then data.highlight:Destroy() end
        if data.healthBar then data.healthBar:Destroy() end
    end
    espObjects = {}

    for _, plr in pairs(Players:GetPlayers()) do
        if plr == player then continue end
        local char = plr.Character
        if not char then continue end
        local humanoid = char:FindFirstChild("Humanoid")
        if not humanoid or humanoid.Health <= 0 then continue end

        local head = char:FindFirstChild("Head")
        local rootPart = getRootPart(char)
        if not head or not rootPart then continue end

        hue = (hue + 0.1) % 1
        local color = Color3.fromHSV(hue, 0.8, 1)

        -- ESP (Highlight)
        local highlight = Instance.new("Highlight")
        highlight.Adornee = char
        highlight.FillColor = color
        highlight.FillTransparency = 0.4
        highlight.OutlineColor = color
        highlight.OutlineTransparency = 0.2
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = char

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

        espObjects[plr] = {
            highlight = highlight,
            healthBar = billboard,
            healthFill = fill,
            healthLabel = label,
            humanoid = humanoid
        }
    end
end

-- Обновляем ESP каждые 0.5 секунды
task.spawn(function()
    while true do
        task.wait(0.5)
        refreshESP()
    end
end)

-- Обновляем Health Bar каждый кадр
RunService.RenderStepped:Connect(function()
    for plr, data in pairs(espObjects) do
        if data.healthFill and data.humanoid then
            local health = data.humanoid.Health
            local maxHealth = data.humanoid.MaxHealth
            local percent = math.clamp(health / maxHealth, 0, 1)
            data.healthFill.Size = UDim2.new(percent, 0, 1, 0)
            data.healthLabel.Text = math.round(health) .. "/" .. math.round(maxHealth)
        end
    end
end)

-- При появлении новых игроков
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(0.3)
        refreshESP()
    end)
end)

-- Очистка при выходе
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
tabsBar.Name = "TabsBar"
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

local tabButtons = {}
local tabNames = {"Aim", "Esp"}
local tabWidth = 0.5

for i, name in ipairs(tabNames) do
    local btn = Instance.new("TextButton")
    btn.Name = name .. "Btn"
    btn.Size = UDim2.new(tabWidth, 0, 1, 0)
    btn.Position = UDim2.new((i-1) * tabWidth, 0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    btn.BackgroundTransparency = 0.2
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.TextColor3 = (i == 1) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
    btn.TextSize = 18
    btn.Font = Enum.Font.SourceSansBold
    btn.Parent = tabsBar

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(45, 45, 50)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        if btn.BackgroundColor3 ~= Color3.fromRGB(60, 60, 70) then
            TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}):Play()
        end
    end)

    tabButtons[name] = btn

    btn.MouseButton1Click:Connect(function()
        for pageName, page in pairs(pages) do
            if pageName == name then
                page.Visible = true
                TweenService:Create(page, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.1}):Play()
            else
                TweenService:Create(page, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 0.6}):Play()
                task.wait(0.1)
                page.Visible = false
            end
        end

        for n, b in pairs(tabButtons) do
            if n == name then
                TweenService:Create(b, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BackgroundColor3 = Color3.fromRGB(60, 60, 70),
                    BackgroundTransparency = 0.1,
                    TextColor3 = Color3.fromRGB(255, 255, 255)
                }):Play()
            else
                TweenService:Create(b, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BackgroundColor3 = Color3.fromRGB(35, 35, 40),
                    BackgroundTransparency = 0.2,
                    TextColor3 = Color3.fromRGB(180, 180, 180)
                }):Play()
            end
        end
    end)
end

tabButtons["Aim"].BackgroundColor3 = Color3.fromRGB(60, 60, 70)
tabButtons["Aim"].BackgroundTransparency = 0.1
tabButtons["Aim"].TextColor3 = Color3.fromRGB(255, 255, 255)

print("✅ Zertyx Menu (ДИНАМИЧЕСКИЙ ESP + Health Bar) загружен!")
