-- Zertyx Menu для BloxStrike (Roblox)
-- Размер: 640x420, белое меню, серый выделенный хедер
-- Чекбоксы вместо кнопок, без кнопки X

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Создаём ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ZertyxMenu"
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Основное меню (Frame)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 640, 0, 420)
mainFrame.Position = UDim2.new(0.5, -320, 0.5, -210)
mainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
mainFrame.BackgroundTransparency = 0
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

-- Тень
local shadow = Instance.new("Frame")
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.3
shadow.BorderSizePixel = 0
shadow.Parent = mainFrame

-- Хедер (серая выделенная полоска)
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 40)
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
header.BorderSizePixel = 0
header.Parent = mainFrame

-- Заголовок в хедере
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 1, 0)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Zertyx Menu"
titleLabel.TextColor3 = Color3.fromRGB(40, 40, 40)
titleLabel.TextSize = 20
titleLabel.TextScaled = false
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.TextYAlignment = Enum.TextYAlignment.Center
titleLabel.Padding = UDim.new(0, 15)
titleLabel.Parent = header

-- Контент меню (скроллируемый)
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -20, 1, -60)
contentFrame.Position = UDim2.new(0, 10, 0, 50)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Список функций
local functions = {
    "Бесконечные патроны",
    "Быстрая перезарядка",
    "Магнит на пули",
    "Аимбот (мягкий)",
    "ESP игроков",
    "Бессмертие",
    "Скорость x2",
    "Прыжок x3"
}

local yOffset = 0
local spacing = 38

for i, funcName in ipairs(functions) do
    -- Контейнер для чекбокса
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 32)
    container.Position = UDim2.new(0, 0, 0, yOffset)
    container.BackgroundTransparency = 1
    container.Parent = contentFrame
    
    -- Сам чекбокс (квадрат)
    local checkbox = Instance.new("Frame")
    checkbox.Size = UDim2.new(0, 22, 0, 22)
    checkbox.Position = UDim2.new(0, 5, 0.5, -11)
    checkbox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    checkbox.BackgroundTransparency = 0
    checkbox.BorderSizePixel = 2
    checkbox.BorderColor3 = Color3.fromRGB(150, 150, 150)
    checkbox.Parent = container
    
    -- Галочка внутри чекбокса
    local checkmark = Instance.new("Frame")
    checkmark.Size = UDim2.new(0.7, 0, 0.7, 0)
    checkmark.Position = UDim2.new(0.15, 0, 0.15, 0)
    checkmark.BackgroundColor3 = Color3.fromRGB(70, 200, 70)
    checkmark.BackgroundTransparency = 1
    checkmark.BorderSizePixel = 0
    checkmark.Parent = checkbox
    
    -- Текст функции
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -35, 1, 0)
    label.Position = UDim2.new(0, 35, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = funcName
    label.TextColor3 = Color3.fromRGB(50, 50, 50)
    label.TextSize = 17
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.Parent = container
    
    -- Кнопка-невидимка поверх всего для клика
    local clicker = Instance.new("TextButton")
    clicker.Size = UDim2.new(1, 0, 1, 0)
    clicker.Position = UDim2.new(0, 0, 0, 0)
    clicker.BackgroundTransparency = 1
    clicker.Text = ""
    clicker.Parent = container
    
    local isChecked = false
    
    -- Функция обновления состояния
    local function updateCheckbox()
        if isChecked then
            checkmark.BackgroundTransparency = 0
            checkbox.BorderColor3 = Color3.fromRGB(70, 200, 70)
        else
            checkmark.BackgroundTransparency = 1
            checkbox.BorderColor3 = Color3.fromRGB(150, 150, 150)
        end
    end
    
    -- Обработка клика
    clicker.MouseButton1Click:Connect(function()
        isChecked = not isChecked
        updateCheckbox()
        
        -- Здесь можно добавить реальный функционал
        if isChecked then
            print(funcName .. " включён ✅")
        else
            print(funcName .. " выключен ❌")
        end
    end)
    
    -- Эффект наведения
    local function onHover()
        if not isChecked then
            checkbox.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
        end
    end
    
    local function onLeave()
        checkbox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    end
    
    clicker.MouseEnter:Connect(onHover)
    clicker.MouseLeave:Connect(onLeave)
    container.MouseEnter:Connect(onHover)
    container.MouseLeave:Connect(onLeave)
    
    yOffset = yOffset + spacing
end

-- Перетаскивание меню
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

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local deltaX = input.Position.X - dragStartX
        local deltaY = input.Position.Y - dragStartY
        mainFrame.Position = UDim2.new(0.5, frameStartX + deltaX, 0.5, frameStartY + deltaY)
    end
end)

-- Закрытие по Escape
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Escape then
        screenGui:Destroy()
    end
end)
