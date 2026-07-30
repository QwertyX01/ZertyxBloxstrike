-- Создаём меню Zertyx (640x420, чёрный матовый, перетаскиваемое)
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "ZertyxMenu"
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 640, 0, 420)
frame.Position = UDim2.new(0.5, -320, 0.5, -210)
frame.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
frame.BackgroundTransparency = 0
frame.BorderSizePixel = 0
frame.Draggable = true
frame.Active = true
frame.ClipsDescendants = true
frame.Parent = gui

-- Хедер
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 42)
header.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
header.BorderSizePixel = 0
header.Parent = frame

-- Серая полоска под хедером
local sep = Instance.new("Frame")
sep.Size = UDim2.new(1, 0, 0, 1)
sep.Position = UDim2.new(0, 0, 0, 42)
sep.BackgroundColor3 = Color3.fromRGB(136, 136, 136)
sep.BorderSizePixel = 0
sep.Parent = frame

-- Заголовок "Zertyx"
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Zertyx"
title.TextColor3 = Color3.fromRGB(221, 221, 221)
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextYAlignment = Enum.TextYAlignment.Center
title.Font = Enum.Font.GothamSemibold
title.Parent = header

-- (Необязательно) маленький бейдж
local badge = Instance.new("TextLabel")
badge.Size = UDim2.new(0, 60, 0, 22)
badge.Position = UDim2.new(1, -70, 0.5, -11)
badge.BackgroundColor3 = Color3.fromRGB(51, 51, 51)
badge.BorderSizePixel = 1
badge.BorderColor3 = Color3.fromRGB(85, 85, 85)
badge.Text = "v1.0"
badge.TextColor3 = Color3.fromRGB(170, 170, 170)
badge.TextSize = 12
badge.Font = Enum.Font.Gotham
badge.TextXAlignment = Enum.TextXAlignment.Center
badge.TextYAlignment = Enum.TextYAlignment.Center
badge.Parent = header

-- Основная область (можно добавить свои кнопки)
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -20, 1, -52)
content.Position = UDim2.new(0, 10, 0, 52)
content.BackgroundTransparency = 1
content.Parent = frame

-- Примеры пунктов (можно заменить/удалить)
local items = {"Профиль", "Настройки", "Инвентарь", "Выход"}
local yOff = 0
for _, name in ipairs(items) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.Position = UDim2.new(0, 0, 0, yOff)
    btn.BackgroundColor3 = Color3.fromRGB(37, 37, 37)
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 15
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.TextYAlignment = Enum.TextYAlignment.Center
    btn.Font = Enum.Font.Gotham
    btn.Parent = content

    local line = Instance.new("Frame")
    line.Size = UDim2.new(0, 3, 1, -4)
    line.Position = UDim2.new(0, 0, 0, 2)
    line.BackgroundColor3 = Color3.fromRGB(102, 102, 102)
    line.BackgroundTransparency = 1
    line.BorderSizePixel = 0
    line.Parent = btn

    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
        line.BackgroundTransparency = 0
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(37, 37, 37)
        line.BackgroundTransparency = 1
    end)

    yOff = yOff + 36
end

-- Закрытие по ESC (двойное нажатие скрывает/показывает)
game:GetService("UserInputService").InputBegan:Connect(function(inp)
    if inp.KeyCode == Enum.KeyCode.Escape then
        frame.Visible = not frame.Visible
    end
end)

print("Меню Zertyx успешно загружено!")
