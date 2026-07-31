-- Zertyx Menu v2 для BloxStrike (ТЁМНО-СЕРЫЙ)
-- 640x420, тёмно-серый фон, скруглённые углы, вкладки снизу

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ZertyxMenu"
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- ===== ЦВЕТОВАЯ СХЕМА =====
local colors = {
    background = Color3.fromRGB(45, 45, 48),      -- Тёмно-серый фон
    header = Color3.fromRGB(35, 35, 38),          -- Ещё темнее для хедера
    headerText = Color3.fromRGB(220, 220, 225),   -- Светлый текст
    tabBg = Color3.fromRGB(40, 40, 43),           -- Фон вкладок
    tabText = Color3.fromRGB(160, 160, 165),      -- Текст вкладок (неактивный)
    tabTextActive = Color3.fromRGB(255, 255, 255),-- Активный текст
    divider = Color3.fromRGB(60, 60, 65),         -- Разделитель
    checkboxBg = Color3.fromRGB(55, 55, 60),      -- Фон чекбокса
    checkboxBorder = Color3.fromRGB(90, 90, 95),  -- Рамка чекбокса
    checkboxActive = Color3.fromRGB(70, 200, 70), -- Активная галочка
    text = Color3.fromRGB(200, 200, 205),         -- Основной текст
    textHover = Color3.fromRGB(230, 230, 235),    -- Текст при наведении
    shadow = Color3.fromRGB(0, 0, 0),             -- Тень
    status = Color3.fromRGB(70, 200, 70),         -- ONLINE статус
}

-- Главное окно
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 640, 0, 420)
mainFrame.Position = UDim2.new(0.5, -320, 0.5, -210)
mainFrame.BackgroundColor3 = colors.background
mainFrame.BackgroundTransparency = 0
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

-- Скругление углов
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- Тень
local shadow = Instance.new("Frame")
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.BackgroundColor3 = colors.shadow
shadow.BackgroundTransparency = 0.4
shadow.BorderSizePixel = 0
shadow.Parent = mainFrame

local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 14)
shadowCorner.Parent = shadow

-- ===== ХЕДЕР (тёмно-серый) =====
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 44)
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundColor3 = colors.header
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header

-- Обрезаем нижние углы хедера
local headerClip = Instance.new("Frame")
headerClip.Size = UDim2.new(1, 0, 1, 6)
headerClip.Position = UDim2.new(0, 0, 1, -6)
headerClip.BackgroundColor3 = colors.header
headerClip.BorderSizePixel = 0
headerClip.Parent = header

-- Название
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -40, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "ZERTYX MENU"
titleLabel.TextColor3 = colors.headerText
titleLabel.TextSize = 18
titleLabel.TextScaled = false
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.TextYAlignment = Enum.TextYAlignment.Center
titleLabel.Parent = header

-- Статус
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0, 80, 1, 0)
statusLabel.Position = UDim2.new(1, -90, 0, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "● ONLINE"
statusLabel.TextColor3 = colors.status
statusLabel.TextSize = 13
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextXAlignment = Enum.TextXAlignment.Right
statusLabel.TextYAlignment = Enum.TextYAlignment.Center
statusLabel.Parent = header

-- ===== КОНТЕНТ =====
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -20, 1, -96)
contentFrame.Position = UDim2.new(0, 10, 0, 50)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- ===== НИЖНИЕ ВКЛАДКИ =====
local tabsFrame = Instance.new("Frame")
tabsFrame.Size = UDim2.new(1, 0, 0, 44)
tabsFrame.Position = UDim2.new(0, 0, 1, -44)
tabsFrame.BackgroundColor3 = colors.tabBg
tabsFrame.BorderSizePixel = 0
tabsFrame.Parent = mainFrame

local tabsCorner = Instance.new("UICorner")
tabsCorner.CornerRadius = UDim.new(0, 12)
tabsCorner.Parent = tabsFrame

-- Обрезаем верхние углы вкладок
local tabsClip = Instance.new("Frame")
tabsClip.Size = UDim2.new(1, 0, 1, 6)
tabsClip.Position = UDim2.new(0, 0, -1, 6)
tabsClip.BackgroundColor3 = colors.tabBg
tabsClip.BorderSizePixel = 0
tabsClip.Parent = tabsFrame

-- Разделитель
local divider = Instance.new("Frame")
divider.Size = UDim2.new(1, -20, 0, 1)
divider.Position = UDim2.new(0, 10, 0, -1)
divider.BackgroundColor3 = colors.divider
divider.BorderSizePixel = 0
divider.Parent = tabsFrame

-- Вкладки
local tabs = {"Aim", "Esp", "Skins", "Other"}
local tabButtons = {}
local currentTab = "Aim"

local tabContent = {
    Aim = {"Аимбот (мягкий)", "Авто-прицел", "Сглаживание", "FOV круг"},
    Esp = {"ESP игроков", "ESP оружия", "Линии", "Дистанция"},
    Skins = {"Скин AWP", "Скин AK-47", "Скин M4A4", "Скин Deagle"},
    Other = {"Бессмертие", "Скорость x2", "Прыжок x3", "Магнит на пули"}
}

local function updateContent(tabName)
    for _, child in pairs(contentFrame:GetChildren()) do
        child:Destroy()
    end
    
    local items = tabContent[tabName] or {}
    local yOffset = 0
    local spacing = 38
    
    for i, funcName in ipairs(items) do
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, 0, 0, 32)
        container.Position = UDim2.new(0, 0, 0, yOffset)
        container.BackgroundTransparency = 1
        container.Parent = contentFrame
        
        -- Чекбокс
        local checkbox = Instance.new("Frame")
        checkbox.Size = UDim2.new(0, 22, 0, 22)
        checkbox.Position = UDim2.new(0, 5, 0.5, -11)
        checkbox.BackgroundColor3 = colors.checkboxBg
        checkbox.BackgroundTransparency = 0
        checkbox.BorderSizePixel = 2
        checkbox.BorderColor3 = colors.checkboxBorder
        checkbox.Parent = container
        
        local checkCorner = Instance.new("UICorner")
        checkCorner.CornerRadius = UDim.new(0, 4)
        checkCorner.Parent = checkbox
        
        -- Галочка
        local checkmark = Instance.new("Frame")
        checkmark.Size = UDim2.new(0.7, 0, 0.7, 0)
        checkmark.Position = UDim2.new(0.15, 0, 0.15, 0)
        checkmark.BackgroundColor3 = colors.checkboxActive
        checkmark.BackgroundTransparency = 1
        checkmark.BorderSizePixel = 0
        checkmark.Parent = checkbox
        
        local checkCorner2 = Instance.new("UICorner")
        checkCorner2.CornerRadius = UDim.new(0, 3)
        checkCorner2.Parent = checkmark
        
        -- Текст
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -35, 1, 0)
        label.Position = UDim2.new(0, 35, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = funcName
        label.TextColor3 = colors.text
        label.TextSize = 16
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextYAlignment = Enum.TextYAlignment.Center
        label.Parent = container
        
        -- Кликер
        local clicker = Instance.new("TextButton")
        clicker.Size = UDim2.new(1, 0, 1, 0)
        clicker.Position = UDim2.new(0, 0, 0, 0)
        clicker.BackgroundTransparency = 1
        clicker.Text = ""
        clicker.Parent = container
        
        local isChecked = false
        
        clicker.MouseButton1Click:Connect(function()
            isChecked = not isChecked
            if isChecked then
                checkmark.BackgroundTransparency = 0
                checkbox.BorderColor3 = colors.checkboxActive
                print("[Zertyx] " .. funcName .. " ON")
            else
                checkmark.BackgroundTransparency = 1
                checkbox.BorderColor3 = colors.checkboxBorder
                print("[Zertyx] " .. funcName .. " OFF")
            end
        end)
        
        -- Ховер эффект
        clicker.MouseEnter:Connect(function()
            label.TextColor3 = colors.textHover
            if not isChecked then
                checkbox.BackgroundColor3 = Color3.fromRGB(65, 65, 70)
            end
        end)
        
        clicker.MouseLeave:Connect(function()
            label.TextColor3 = colors.text
            checkbox.BackgroundColor3 = colors.checkboxBg
        end)
        
        yOffset = yOffset + spacing
    end
end

-- Создаём кнопки вкладок
local tabWidth = 640 / #tabs
for i, tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, tabWidth, 1, 0)
    btn.Position = UDim2.new(0, (i-1) * tabWidth, 0, 0)
    btn.BackgroundColor3 = colors.tabBg
    btn.BackgroundTransparency = 0
    btn.Text = tabName
    btn.TextColor3 = colors.tabText
    btn.TextSize = 15
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Parent = tabsFrame
    
    -- Индикатор активной вкладки
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0.6, 0, 0, 3)
    indicator.Position = UDim2.new(0.2, 0, 1, -4)
    indicator.BackgroundColor3 = colors.checkboxActive
    indicator.BackgroundTransparency = 1
    indicator.BorderSizePixel = 0
    indicator.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        for _, b in pairs(tabButtons) do
            b.indicator.BackgroundTransparency = 1
            b.TextColor3 = colors.tabText
        end
        btn.indicator.BackgroundTransparency = 0
        btn.TextColor3 = colors.tabTextActive
        currentTab = tabName
        updateContent(tabName)
    end)
    
    -- Ховер эффект для вкладок
    btn.MouseEnter:Connect(function()
        if btn.TextColor3 ~= colors.tabTextActive then
            btn.TextColor3 = Color3.fromRGB(200, 200, 205)
        end
    end)
    
    btn.MouseLeave:Connect(function()
        if btn.TextColor3 ~= colors.tabTextActive then
            btn.TextColor3 = colors.tabText
        end
    end)
    
    btn.indicator = indicator
    tabButtons[tabName] = btn
end

-- Активируем первую вкладку
tabButtons.Aim.indicator.BackgroundTransparency = 0
tabButtons.Aim.TextColor3 = colors.tabTextActive
updateContent("Aim")

-- ===== ПЕРЕТАСКИВАНИЕ =====
local dragging = false
local dragStartX, dragStartY
local frameStartX, frameStartY

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStartX = input.Position.X
        dragStartY = input.Position.Y
        frameStartX = mainFrame.Position.X.Offset
        frameStartY = mainFrame.Position.Y.Offset
    end
end)

header.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local deltaX = input.Position.X - dragStartX
        local deltaY = input.Position.Y - dragStartY
        mainFrame.Position = UDim2.new(0.5, frameStartX + deltaX, 0.5, frameStartY + deltaY)
    end
end)

-- Закрытие по Escape
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Escape then
        screenGui:Destroy()
    end
end)

print("✅ Zertyx Menu v2 (Тёмно-серый) загружен!")
