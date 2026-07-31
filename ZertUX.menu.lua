-- =====================================================
--  Zertyx Menu (ESP с динамичным RGB и белым Box)
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
local SoundService = game:GetService("SoundService")

-- ============================================================
--  ЗВУК
-- ============================================================
local clickSound = Instance.new("Sound")
clickSound.SoundId = "rbxassetid://9120379486"
clickSound.Volume = 0.5
clickSound.Parent = SoundService

local function playClickSound()
    clickSound:Play()
end

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
--  ВКЛАДКА ESP (с динамичным RGB и белым Box)
-- ============================================================
local espPage = pages["Esp"]
local espEnabled = false
local boxEnabled = false

-- Хранилище объектов ESP
local espObjects = {}

-- Проверка Drawing API
local hasDrawing = pcall(function() return Drawing end) and Drawing ~= nil
print("🔍 Drawing API доступен:", hasDrawing)

-- Функция для поиска корневой части
local function getRootPart(character)
    if not character then return nil end
    local root = character:FindFirstChild("HumanoidRootPart")
    if root then return root end
    root = character:FindFirstChild("RootPart")
    if root then return root end
    root = character:FindFirstChild("UpperTorso")
    if root then return root end
    root = character:FindFirstChild("Torso")
    return root
end

-- Проверка врага
local function isEnemy(plr)
    if plr == player then return false end
    if not plr.Character then return false end
    local humanoid = plr.Character:FindFirstChild("Humanoid")
    if not humanoid then
        return true -- если нет Humanoid, считаем врагом
    end
    if humanoid.Health <= 0 then return false end
    if player.Team and plr.Team and player.Team == plr.Team then
        return false
    end
    if player.TeamColor and plr.TeamColor and player.TeamColor == plr.TeamColor then
        return false
    end
    return true
end

-- Очистка ESP
local function clearESP()
    for _, data in pairs(espObjects) do
        if data.highlight then data.highlight:Destroy() end
        if data.boxLines then
            for _, line in pairs(data.boxLines) do
                line:Remove()
            end
        end
    end
    espObjects = {}
end

-- Переменная для динамичного цвета
local hue = 0

-- Основной цикл обновления ESP
RunService.RenderStepped:Connect(function()
    -- Обновляем hue для радужного эффекта (0.5-0.7 для сине-голубого спектра)
    hue = (hue + 0.002) % 1
    local dynamicColor = Color3.fromHSV(hue, 0.8, 1)  -- насыщенный, яркий

    -- Удаляем объекты для мёртвых или не-врагов
    for plr, data in pairs(espObjects) do
        if not plr or not plr.Parent or not isEnemy(plr) or not plr.Character then
            if data.highlight then data.highlight:Destroy() end
            if data.boxLines then
                for _, line in pairs(data.boxLines) do
                    line:Remove()
                end
            end
            espObjects[plr] = nil
        end
    end

    -- Обходим всех игроков
    for _, plr in pairs(Players:GetPlayers()) do
        if not isEnemy(plr) then
            continue
        end
        local character = plr.Character
        if not character then continue end
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid and humanoid.Health <= 0 then continue end

        local rootPart = getRootPart(character)
        local head = character:FindFirstChild("Head")
        if not rootPart or not head then
            continue
        end

        if not espObjects[plr] then
            espObjects[plr] = {}
        end
        local data = espObjects[plr]

        -- Highlight с динамичным цветом
        if espEnabled then
            if not data.highlight then
                local highlight = Instance.new("Highlight")
                highlight.Adornee = character
                highlight.FillColor = dynamicColor
                highlight.FillTransparency = 0.4
                highlight.OutlineColor = dynamicColor
                highlight.OutlineTransparency = 0.2
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                highlight.Parent = character
                data.highlight = highlight
            else
                -- Обновляем цвет каждый кадр
                data.highlight.FillColor = dynamicColor
                data.highlight.OutlineColor = dynamicColor
            end
        else
            if data.highlight then
                data.highlight:Destroy()
                data.highlight = nil
            end
        end

        -- 2D Box (белый, увеличенный, обводит всего персонажа)
        if boxEnabled and hasDrawing then
            if not data.boxLines then
                data.boxLines = {}
                for i = 1, 4 do
                    local line = Drawing.new("Line")
                    line.Color = Color3.fromRGB(255, 255, 255)  -- белый
                    line.Thickness = 3                         -- чуть толще
                    line.Transparency = 0.6
                    line.Visible = false
                    table.insert(data.boxLines, line)
                end
            end
            -- Вычисляем размеры бокса, чтобы обводить всего персонажа
            local headPos = head.Position
            local rootPos = rootPart.Position
            local height = (headPos - rootPos).Magnitude
            -- Увеличиваем ширину бокса (коэффициент 0.8 вместо 0.4)
            local width = height * 0.8

            local topPos = headPos + Vector3.new(0, 1, 0)          -- выше головы
            local bottomPos = rootPos - Vector3.new(0, 0.5, 0)     -- ниже ног

            local topScreen, topVis = Camera:WorldToViewportPoint(topPos)
            local bottomScreen, bottomVis = Camera:WorldToViewportPoint(bottomPos)

            if topVis and bottomVis and topScreen.Z > 0 and bottomScreen.Z > 0 then
                local topY = topScreen.Y
                local bottomY = bottomScreen.Y
                local centerX = (topScreen.X + bottomScreen.X) / 2
                local boxHeight = math.abs(topY - bottomY)
                local boxWidth = boxHeight * 0.6                  -- ширина относительно высоты

                local leftX = centerX - boxWidth / 2
                local rightX = centerX + boxWidth / 2

                local lines = data.boxLines
                lines[1].From = Vector2.new(leftX, topY)
                lines[1].To = Vector2.new(rightX, topY)
                lines[1].Visible = true

                lines[2].From = Vector2.new(leftX, bottomY)
                lines[2].To = Vector2.new(rightX, bottomY)
                lines[2].Visible = true

                lines[3].From = Vector2.new(leftX, topY)
                lines[3].To = Vector2.new(leftX, bottomY)
                lines[3].Visible = true

                lines[4].From = Vector2.new(rightX, topY)
                lines[4].To = Vector2.new(rightX, bottomY)
                lines[4].Visible = true
            else
                if data.boxLines then
                    for _, line in pairs(data.boxLines) do
                        line.Visible = false
                    end
                end
            end
        else
            if data.boxLines then
                for _, line in pairs(data.boxLines) do
                    line:Remove()
                end
                data.boxLines = nil
            end
        end
    end
end)

-- ============================================================
--  ИНТЕРФЕЙС ВКЛАДКИ ESP
-- ============================================================
local espPage = pages["Esp"]

local dividerEsp = Instance.new("Frame")
dividerEsp.Size = UDim2.new(0, 2, 1, 0)
dividerEsp.Position = UDim2.new(0.5, -1, 0, 0)
dividerEsp.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
dividerEsp.BackgroundTransparency = 0.4
dividerEsp.BorderSizePixel = 0
dividerEsp.Parent = espPage

local leftHalfEsp = Instance.new("Frame")
leftHalfEsp.Size = UDim2.new(0.5, -5, 1, 0)
leftHalfEsp.Position = UDim2.new(0, 5, 0, 0)
leftHalfEsp.BackgroundTransparency = 1
leftHalfEsp.Parent = espPage

-- ESP Toggle
local rowEsp = Instance.new("Frame")
rowEsp.Size = UDim2.new(1, 0, 0, 40)
rowEsp.Position = UDim2.new(0, 0, 0.1, 0)
rowEsp.BackgroundTransparency = 1
rowEsp.Parent = leftHalfEsp

local labelEsp = Instance.new("TextLabel")
labelEsp.Size = UDim2.new(0.6, 0, 1, 0)
labelEsp.Position = UDim2.new(0, 10, 0, 0)
labelEsp.BackgroundTransparency = 1
labelEsp.Text = "ESP"
labelEsp.TextColor3 = Color3.fromRGB(255, 255, 255)
labelEsp.TextSize = 18
labelEsp.Font = Enum.Font.GothamBold
labelEsp.TextXAlignment = Enum.TextXAlignment.Left
labelEsp.TextYAlignment = Enum.TextYAlignment.Center
labelEsp.Parent = rowEsp

local toggleEsp = Instance.new("TextButton")
toggleEsp.Size = UDim2.new(0, 80, 0, 32)
toggleEsp.Position = UDim2.new(0.75, 0, 0.5, -16)
toggleEsp.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
toggleEsp.BackgroundTransparency = 0.2
toggleEsp.BorderSizePixel = 0
toggleEsp.Text = "OFF"
toggleEsp.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleEsp.TextSize = 16
toggleEsp.Font = Enum.Font.SourceSansBold
toggleEsp.Parent = rowEsp
local btnCornerEsp = Instance.new("UICorner")
btnCornerEsp.CornerRadius = UDim.new(0, 6)
btnCornerEsp.Parent = toggleEsp

local function updateEspState(state)
    espEnabled = state
    if state then
        toggleEsp.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        toggleEsp.Text = "ON"
    else
        toggleEsp.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        toggleEsp.Text = "OFF"
    end
end

toggleEsp.MouseButton1Click:Connect(function()
    updateEspState(not espEnabled)
end)
updateEspState(false)

-- 2D Box Toggle
local rowBox = Instance.new("Frame")
rowBox.Size = UDim2.new(1, 0, 0, 40)
rowBox.Position = UDim2.new(0, 0, 0.25, 0)
rowBox.BackgroundTransparency = 1
rowBox.Parent = leftHalfEsp

local labelBox = Instance.new("TextLabel")
labelBox.Size = UDim2.new(0.6, 0, 1, 0)
labelBox.Position = UDim2.new(0, 10, 0, 0)
labelBox.BackgroundTransparency = 1
labelBox.Text = "2D Box"
labelBox.TextColor3 = Color3.fromRGB(255, 255, 255)
labelBox.TextSize = 18
labelBox.Font = Enum.Font.GothamBold
labelBox.TextXAlignment = Enum.TextXAlignment.Left
labelBox.TextYAlignment = Enum.TextYAlignment.Center
labelBox.Parent = rowBox

local toggleBox = Instance.new("TextButton")
toggleBox.Size = UDim2.new(0, 80, 0, 32)
toggleBox.Position = UDim2.new(0.75, 0, 0.5, -16)
toggleBox.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
toggleBox.BackgroundTransparency = 0.2
toggleBox.BorderSizePixel = 0
toggleBox.Text = "OFF"
toggleBox.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBox.TextSize = 16
toggleBox.Font = Enum.Font.SourceSansBold
toggleBox.Parent = rowBox
local btnCornerBox = Instance.new("UICorner")
btnCornerBox.CornerRadius = UDim.new(0, 6)
btnCornerBox.Parent = toggleBox

local function updateBoxState(state)
    boxEnabled = state
    if state then
        toggleBox.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        toggleBox.Text = "ON"
    else
        toggleBox.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        toggleBox.Text = "OFF"
    end
end

toggleBox.MouseButton1Click:Connect(function()
    updateBoxState(not boxEnabled)
end)
updateBoxState(false)

-- Правая половина (заглушка)
local rightHalfEsp = Instance.new("Frame")
rightHalfEsp.Size = UDim2.new(0.5, -5, 1, 0)
rightHalfEsp.Position = UDim2.new(0.5, 5, 0, 0)
rightHalfEsp.BackgroundTransparency = 1
rightHalfEsp.Parent = espPage

local rightLabelEsp = Instance.new("TextLabel")
rightLabelEsp.Size = UDim2.new(1, 0, 1, 0)
rightLabelEsp.BackgroundTransparency = 1
rightLabelEsp.Text = "настройки\n(скоро)"
rightLabelEsp.TextColor3 = Color3.fromRGB(150, 150, 150)
rightLabelEsp.TextSize = 20
rightLabelEsp.Font = Enum.Font.GothamMedium
rightLabelEsp.TextXAlignment = Enum.TextXAlignment.Center
rightLabelEsp.TextYAlignment = Enum.TextYAlignment.Center
rightLabelEsp.Parent = rightHalfEsp

-- ============================================================
--  НИЖНИЕ ВКЛАДКИ (с анимацией и звуком)
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
        playClickSound()

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

print("✅ Zertyx Menu (ESP с динамичным RGB и белым Box) загружен!")
