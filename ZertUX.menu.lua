-- Создаём меню Zertyx
local player = game.Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")

-- Проверяем, нет ли уже такого меню, чтобы не дублировать
if gui:FindFirstChild("ZertyxMenu") then
    gui.ZertyxMenu:Destroy()
end

-- Основной контейнер (ScreenGui)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ZertyxMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = gui

-- Главное окно (Frame)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 640, 0, 420)          -- размер 640x420
mainFrame.Position = UDim2.new(0.5, -320, 0.5, -210) -- центрирование
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- тёмный фон
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Active = true        -- для возможности перетаскивания
mainFrame.Draggable = false    -- будет своя логика перетаскивания
mainFrame.Parent = screenGui

-- Хедер (серая полоска сверху)
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 30)               -- на всю ширину, высота 30
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundColor3 = Color3.fromRGB(80, 80, 80) -- серый
header.BorderSizePixel = 0
header.Parent = mainFrame

-- Текст "меню Zertyx" белого цвета, слева
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -10, 1, 0)          -- с отступом справа 10
titleLabel.Position = UDim2.new(0, 10, 0, 0)       -- сдвиг влево на 10
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "меню Zertyx"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- белый
titleLabel.TextSize = 18
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.TextYAlignment = Enum.TextYAlignment.Center
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = header

-- (Опционально) кнопка закрытия "X" справа (можно добавить позже)
-- ...

-- ===== Логика перетаскивания окна за хедер =====
local dragging = false
local dragStart = nil
local startPos = nil

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

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                      startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ===== Открытие/закрытие по клавише Insert =====
local visible = true
game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        visible = not visible
        mainFrame.Visible = visible
    end
end)

-- Вывод в консоль для подтверждения
print("Меню Zertyx загружено! Нажмите Insert для показа/скрытия.")
