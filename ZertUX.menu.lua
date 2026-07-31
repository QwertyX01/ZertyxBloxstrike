-- Zertyx Menu для BloxStrike (Roblox)
-- Размер: 640x420, белое меню, серый выделенный хедер

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

-- Тень (для красоты)
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
header.BackgroundColor3 = Color3.fromRGB(180, 180, 180) -- Серый цвет
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

-- Кнопка закрытия (X)
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0.5, -15)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 70, 70)
closeButton.BackgroundTransparency = 0.8
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 16
closeButton.Font = Enum.Font.GothamBold
closeButton.BorderSizePixel = 0
closeButton.Parent = header

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Контент меню (скроллируемый)
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -20, 1, -60)
contentFrame.Position = UDim2.new(0, 10, 0, 50)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Список функций (пример)
local functions = {
    {"Бесконечные патроны", false},
    {"Быстрая перезарядка", false},
    {"Магнит на пули", false},
    {"Аимбот (мягкий)", false},
    {"ESP игроков", false},
    {"Бессмертие", false},
    {"Скорость x2", false},
    {"Прыжок x3", false}
}

local yOffset = 0
local spacing = 35

for i, v in ipairs(functions) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.Position = UDim2.new(0, 0, 0, yOffset)
    btn.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
    btn.BackgroundTransparency = 0
    btn.Text = v[1] .. " [OFF]"
    btn.TextColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextSize = 16
    btn.Font = Enum.Font.Gotham
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.TextYAlignment = Enum.TextYAlignment.Center
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(200, 200, 200)
    btn.Padding = UDim.new(0, 10)
    btn.Parent = contentFrame
    
    local isActive = false
    
    btn.MouseButton1Click:Connect(function()
        isActive = not isActive
        if isActive then
            btn.Text = v[1] .. " [ON]"
            btn.BackgroundColor3 = Color3.fromRGB(200, 230, 200)
        else
            btn.Text = v[1] .. " [OFF]"
            btn.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
        end
    end)
    
    -- Эффект наведения
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
    end)
    
    btn.MouseLeave:Connect(function()
        if isActive then
            btn.BackgroundColor3 = Color3.fromRGB(200, 230, 200)
        else
            btn.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
        end
    end)
    
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
