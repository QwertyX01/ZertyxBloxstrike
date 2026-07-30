-- Меню Zertyx (матово-чёрное, скруглённые углы)
local player = game.Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")

if gui:FindFirstChild("ZertyxMenu") then
    gui.ZertyxMenu:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ZertyxMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = gui

-- Главное окно
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 640, 0, 420)
mainFrame.Position = UDim2.new(0.5, -320, 0.5, -210)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20) -- матово-чёрный
mainFrame.BackgroundTransparency = 0 -- полностью непрозрачный
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = false
mainFrame.Parent = screenGui

-- Скругление углов (6 пикселей)
local corners = Instance.new("UICorner")
corners.CornerRadius = UDim.new(0, 6)
corners.Parent = mainFrame

-- Хедер (тоже матово-чёрный)
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 30)
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundColor3 = Color3.fromRGB(20, 20, 20) -- тот же цвет
header.BorderSizePixel = 0
header.Parent = mainFrame

-- Тонкая серая полоска снизу хедера (для выделения)
local divider = Instance.new("Frame")
divider.Size = UDim2.new(1, 0, 0, 1)
divider.Position = UDim2.new(0, 0, 1, -1) -- внизу хедера
divider.BackgroundColor3 = Color3.fromRGB(100, 100, 100) -- серый
divider.BorderSizePixel = 0
divider.Parent = header

-- Надпись "меню Zertyx" белая, слева
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -10, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "меню Zertyx"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 18
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.TextYAlignment = Enum.TextYAlignment.Center
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = header

-- ===== Перетаскивание за хедер =====
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

-- ===== Открытие/закрытие по Insert =====
local visible = true
game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        visible = not visible
        mainFrame.Visible = visible
    end
end)

print("Меню Zertyx (обновлённое) загружено! Нажмите Insert.")
