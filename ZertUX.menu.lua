-- Zertyx Menu for Bloxstrike
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local uis = game:GetService("UserInputService")

-- Создаём основной GUI
local gui = Instance.new("ScreenGui")
gui.Name = "ZertyxMenu"
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui

-- Главное окно (640x420)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 640, 0, 420)
mainFrame.Position = UDim2.new(0.5, -320, 0.5, -210)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui

-- Хедер (серая полоска)
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 30)
header.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
header.BorderSizePixel = 0
header.Parent = mainFrame

-- Название "Zertyx" в центре хедера
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -30, 1, 0)
title.BackgroundTransparency = 1
title.Text = "Zertyx"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.TextXAlignment = Enum.TextXAlignment.Center
title.Parent = header

-- Кнопка закрытия (крестик)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 1, 0)
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextScaled = true
closeBtn.Parent = header
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Перетаскивание окна
local dragging = false
local dragStart, startPos

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

header.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

uis.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

-- Панель вкладок (под хедером)
local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, 0, 0, 30)
tabContainer.Position = UDim2.new(0, 0, 0, 30)
tabContainer.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
tabContainer.BorderSizePixel = 0
tabContainer.Parent = mainFrame

-- Функция создания кнопки вкладки
local function createTabButton(name, position)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 1, 0)
    btn.Position = UDim2.new(0, position, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.BorderSizePixel = 0
    btn.Parent = tabContainer
    return btn
end

local aimbotBtn = createTabButton("Aimbot", 5)
local espBtn = createTabButton("ESP", 110)

-- Контейнеры для содержимого вкладок (ScrollingFrame)
local function createContent()
    local frame = Instance.new("ScrollingFrame")
    frame.Size = UDim2.new(1, 0, 1, -60)
    frame.Position = UDim2.new(0, 0, 0, 60)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.BorderSizePixel = 0
    frame.CanvasSize = UDim2.new(0, 0, 0, 0)
    frame.ScrollBarThickness = 10
    frame.Parent = mainFrame
    return frame
end

local contentAimbot = createContent()
local contentESP = createContent()

-- UIListLayout для автоматического выравнивания элементов
local function addLayout(parent)
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 5)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = parent
    return layout
end
addLayout(contentAimbot)
addLayout(contentESP)

-- Вспомогательная функция: чекбокс
local function addCheckbox(parent, text, default)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 30)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.8, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local check = Instance.new("TextButton")
    check.Size = UDim2.new(0, 30, 0, 30)
    check.Position = UDim2.new(1, -35, 0, 0)
    check.BackgroundColor3 = default and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(100, 100, 100)
    check.Text = default and "✓" or ""
    check.TextColor3 = Color3.fromRGB(255, 255, 255)
    check.Parent = frame
    check.MouseButton1Click:Connect(function()
        if check.Text == "✓" then
            check.Text = ""
            check.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        else
            check.Text = "✓"
            check.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        end
    end)
end

-- Вспомогательная функция: поле ввода (для FOV)
local function addInput(parent, labelText, default)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 30)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0, 60, 1, 0)
    box.Position = UDim2.new(0.7, 0, 0, 0)
    box.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    box.Text = default
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.Parent = frame
end

-- === Вкладка AIMBOT ===
addCheckbox(contentAimbot, "Enable Aimbot", true)
addCheckbox(contentAimbot, "Visible Check", false)
addCheckbox(contentAimbot, "Silent Aim", true)
addInput(contentAimbot, "FOV:", "90")
addInput(contentAimbot, "Smoothness:", "5")

-- === Вкладка ESP ===
addCheckbox(contentESP, "Enable ESP", true)
addCheckbox(contentESP, "Box ESP", true)
addCheckbox(contentESP, "Name ESP", true)
addCheckbox(contentESP, "Health ESP", true)
addCheckbox(contentESP, "Distance ESP", false)
addInput(contentESP, "Max Distance:", "500")

-- Логика переключения вкладок
local currentTab = "Aimbot"
local function selectTab(tabName)
    if currentTab == tabName then return end
    if tabName == "Aimbot" then
        contentAimbot.Visible = true
        contentESP.Visible = false
        aimbotBtn.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
        espBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    elseif tabName == "ESP" then
        contentAimbot.Visible = false
        contentESP.Visible = true
        aimbotBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        espBtn.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
    end
    currentTab = tabName
end

aimbotBtn.MouseButton1Click:Connect(function() selectTab("Aimbot") end)
espBtn.MouseButton1Click:Connect(function() selectTab("ESP") end)

-- Инициализация: активна вкладка Aimbot
selectTab("Aimbot")
