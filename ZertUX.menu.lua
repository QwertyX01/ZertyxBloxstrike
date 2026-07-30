-- Создаём интерфейс
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ZertyxMenuGui"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Главное окно
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 640, 0, 420)
mainFrame.Position = UDim2.new(0.5, -320, 0.5, -210)
mainFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
mainFrame.BackgroundTransparency = 0
mainFrame.BorderSizePixel = 0
mainFrame.Draggable = true
mainFrame.Active = true
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

-- Хедер
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 42)
header.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
header.BorderSizePixel = 0
header.Parent = mainFrame

-- Тонкая серая полоска под хедером
local separator = Instance.new("Frame")
separator.Name = "Separator"
separator.Size = UDim2.new(1, 0, 0, 1)
separator.Position = UDim2.new(0, 0, 0, 42)
separator.BackgroundColor3 = Color3.fromRGB(136, 136, 136)
separator.BorderSizePixel = 0
separator.Parent = mainFrame

-- Заголовок "Zertyx"
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, -20, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Zertyx"
titleLabel.TextColor3 = Color3.fromRGB(221, 221, 221)
titleLabel.TextSize = 18
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.TextYAlignment = Enum.TextYAlignment.Center
titleLabel.Font = Enum.Font.GothamSemibold
titleLabel.Parent = header

-- (Необязательный бейдж, можно удалить, если не нужен)
local badge = Instance.new("TextLabel")
badge.Name = "Badge"
badge.Size = UDim2.new(0, 60, 0, 22)
badge.Position = UDim2.new(1, -70, 0.5, -11)
badge.BackgroundColor3 = Color3.fromRGB(51, 51, 51)
badge.BackgroundTransparency = 0
badge.BorderSizePixel = 1
badge.BorderColor3 = Color3.fromRGB(85, 85, 85)
badge.Text = "v1.0"
badge.TextColor3 = Color3.fromRGB(170, 170, 170)
badge.TextSize = 12
badge.Font = Enum.Font.Gotham
badge.TextXAlignment = Enum.TextXAlignment.Center
badge.TextYAlignment = Enum.TextYAlignment.Center
badge.Parent = header

-- Основная область (можно наполнить своими элементами)
local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, -20, 1, -52) -- отступ сверху 52
content.Position = UDim2.new(0, 10, 0, 52)
content.BackgroundTransparency = 1
content.Parent = mainFrame

-- Пример пунктов меню (при желании замените или удалите)
local items = {"Профиль", "Настройки", "Инвентарь", "Выход"}
local yOffset = 0
for i, itemName in ipairs(items) do
    local item = Instance.new("TextButton")
    item.Name = "Item_" .. i
    item.Size = UDim2.new(1, 0, 0, 32)
    item.Position = UDim2.new(0, 0, 0, yOffset)
    item.BackgroundColor3 = Color3.fromRGB(37, 37, 37)
    item.BackgroundTransparency = 0
    item.BorderSizePixel = 0
    item.Text = itemName
    item.TextColor3 = Color3.fromRGB(200, 200, 200)
    item.TextSize = 15
    item.TextXAlignment = Enum.TextXAlignment.Left
    item.TextYAlignment = Enum.TextYAlignment.Center
    item.Font = Enum.Font.Gotham
    item.Parent = content

    local line = Instance.new("Frame")
    line.Name = "HoverLine"
    line.Size = UDim2.new(0, 3, 1, -4)
    line.Position = UDim2.new(0, 0, 0, 2)
    line.BackgroundColor3 = Color3.fromRGB(102, 102, 102)
    line.BackgroundTransparency = 1
    line.BorderSizePixel = 0
    line.Parent = item

    item.MouseEnter:Connect(function()
        item.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
        line.BackgroundTransparency = 0
    end)
    item.MouseLeave:Connect(function()
        item.BackgroundColor3 = Color3.fromRGB(37, 37, 37)
        line.BackgroundTransparency = 1
    end)

    yOffset = yOffset + 36
end

-- Закрытие по ESC
local function onKeyPress(input)
    if input.KeyCode == Enum.KeyCode.Escape then
        mainFrame.Visible = not mainFrame.Visible
    end
end
game:GetService("UserInputService").InputBegan:Connect(onKeyPress)
