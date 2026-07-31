-- ZERTYX BLOXSTRIKE SILENT AIM + ESP (HIGHLIGHT ВЕРСИЯ)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- СОЗДАНИЕ МЕНЮ (640x420)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer.PlayerGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 640, 0, 420)
Frame.Position = UDim2.new(0.5, -320, 0.5, -210)
Frame.BackgroundColor3 = Color3.new(1, 1, 1)
Frame.BorderSizePixel = 0
Frame.ClipsDescendants = true
Frame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Zertyx v2"
Title.TextColor3 = Color3.new(0, 0, 0)
Title.TextSize = 22
Title.Font = Enum.Font.GothamBold
Title.Parent = Frame

-- ESP TOGGLE
local EspToggle = Instance.new("TextButton")
EspToggle.Size = UDim2.new(0, 180, 0, 40)
EspToggle.Position = UDim2.new(0, 20, 0, 60)
EspToggle.BackgroundColor3 = Color3.new(0.9, 0.9, 0.9)
EspToggle.Text = "ESP: ВКЛ"
EspToggle.TextColor3 = Color3.new(0, 0, 0)
EspToggle.TextSize = 18
EspToggle.Font = Enum.Font.Gotham
local EspCorner = Instance.new("UICorner")
EspCorner.CornerRadius = UDim.new(0, 8)
EspCorner.Parent = EspToggle
EspToggle.Parent = Frame

-- SILENT AIM TOGGLE
local SaToggle = Instance.new("TextButton")
SaToggle.Size = UDim2.new(0, 180, 0, 40)
SaToggle.Position = UDim2.new(0, 220, 0, 60)
SaToggle.BackgroundColor3 = Color3.new(0.9, 0.9, 0.9)
SaToggle.Text = "Silent Aim: ВКЛ"
SaToggle.TextColor3 = Color3.new(0, 0, 0)
SaToggle.TextSize = 18
SaToggle.Font = Enum.Font.Gotham
local SaCorner = Instance.new("UICorner")
SaCorner.CornerRadius = UDim.new(0, 8)
SaCorner.Parent = SaToggle
SaToggle.Parent = Frame

-- РАДИУС
local RadiusLabel = Instance.new("TextLabel")
RadiusLabel.Size = UDim2.new(0, 180, 0, 30)
RadiusLabel.Position = UDim2.new(0, 20, 0, 120)
RadiusLabel.BackgroundTransparency = 1
RadiusLabel.Text = "Радиус: 150"
RadiusLabel.TextColor3 = Color3.new(0, 0, 0)
RadiusLabel.TextSize = 16
RadiusLabel.Font = Enum.Font.Gotham
RadiusLabel.Parent = Frame

local RadiusSlider = Instance.new("TextBox")
RadiusSlider.Size = UDim2.new(0, 180, 0, 30)
RadiusSlider.Position = UDim2.new(0, 220, 0, 120)
RadiusSlider.BackgroundColor3 = Color3.new(0.9, 0.9, 0.9)
RadiusSlider.Text = "150"
RadiusSlider.TextColor3 = Color3.new(0, 0, 0)
RadiusSlider.TextSize = 16
RadiusSlider.Font = Enum.Font.Gotham
local SliderCorner = Instance.new("UICorner")
SliderCorner.CornerRadius = UDim.new(0, 8)
SliderCorner.Parent = RadiusSlider
RadiusSlider.Parent = Frame

-- ПЕРЕМЕННЫЕ
local espEnabled = true
local silentAimEnabled = true
local aimRadius = 150
local espObjects = {} -- Таблица для Highlight-ов

-- === ДИНАМИЧЕСКИЙ КРУГ ===
local CircleContainer = Instance.new("Frame")
CircleContainer.Size = UDim2.new(0, aimRadius * 2, 0, aimRadius * 2)
CircleContainer.Position = UDim2.new(0.5, -aimRadius, 0.5, -aimRadius)
CircleContainer.BackgroundTransparency = 1
CircleContainer.Visible = silentAimEnabled
CircleContainer.Parent = ScreenGui

local CircleMain = Instance.new("Frame")
CircleMain.Size = UDim2.new(1, 0, 1, 0)
CircleMain.Position = UDim2.new(0, 0, 0, 0)
CircleMain.BackgroundColor3 = Color3.new(1, 1, 1)
CircleMain.BackgroundTransparency = 0.85
CircleMain.BorderSizePixel = 2
CircleMain.BorderColor3 = Color3.new(1, 1, 1)
CircleMain.Parent = CircleContainer

local CircleCorner = Instance.new("UICorner")
CircleCorner.CornerRadius = UDim.new(1, 0)
CircleCorner.Parent = CircleMain

-- === HIGHLIGHT ESP (РАБОТАЕТ ЗА СТЕНАМИ) ===
local function updatePlayerESP(playerObj)
    -- Удаляем старый ESP, если есть
    if espObjects[playerObj] then
        espObjects[playerObj]:Destroy()
        espObjects[playerObj] = nil
    end
    
    -- Проверки
    if not espEnabled then return end
    if playerObj == LocalPlayer then return end
    if not playerObj.Character then return end
    
    -- СОЗДАЁМ HIGHLIGHT
    local highlight = Instance.new("Highlight")
    highlight.Parent = playerObj.Character
    highlight.FillColor = Color3.fromHSV(math.random(), 1, 1) -- СЛУЧАЙНЫЙ ЦВЕТ
    highlight.FillTransparency = 0.4
    highlight.OutlineColor = Color3.new(1, 1, 1) -- Белый контур
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- ВИДНО ЗА СТЕНАМИ
    
    espObjects[playerObj] = highlight
end

local function updateAllESP()
    for _, player in pairs(Players:GetPlayers()) do
        updatePlayerESP(player)
    end
end

-- ОБНОВЛЕНИЕ ESP ПРИ ПОЯВЛЕНИИ/ИСЧЕЗНОВЕНИИ ИГРОКОВ
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        updatePlayerESP(player)
    end)
    updatePlayerESP(player)
end)

Players.PlayerRemoving:Connect(function(player)
    if espObjects[player] then
        espObjects[player]:Destroy()
        espObjects[player] = nil
    end
end)

-- Обновляем ESP при изменении настройки
EspToggle.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    EspToggle.Text = espEnabled and "ESP: ВКЛ" or "ESP: ВЫКЛ"
    
    if not espEnabled then
        -- Удаляем все Highlight-ы
        for player, highlight in pairs(espObjects) do
            highlight:Destroy()
            espObjects[player] = nil
        end
    else
        -- Пересоздаём Highlight-ы
        updateAllESP()
    end
end)

-- Показываем/скрываем круг с Silent Aim
SaToggle.MouseButton1Click:Connect(function()
    silentAimEnabled = not silentAimEnabled
    SaToggle.Text = silentAimEnabled and "Silent Aim: ВКЛ" or "Silent Aim: ВЫКЛ"
    CircleContainer.Visible = silentAimEnabled
end)

-- Обновление радиуса
RadiusSlider.FocusLost:Connect(function()
    local val = tonumber(RadiusSlider.Text)
    if val then
        aimRadius = math.clamp(val, 0, 300)
        RadiusSlider.Text = tostring(aimRadius)
        RadiusLabel.Text = "Радиус: " .. tostring(aimRadius)
        CircleContainer.Size = UDim2.new(0, aimRadius * 2, 0, aimRadius * 2)
        CircleContainer.Position = UDim2.new(0.5, -aimRadius, 0.5, -aimRadius)
    else
        RadiusSlider.Text = tostring(aimRadius)
    end
end)

-- Обновляем ESP при перерождении персонажа
for _, player in pairs(Players:GetPlayers()) do
    player.CharacterAdded:Connect(function()
        updatePlayerESP(player)
    end)
end

-- Первоначальное обновление
updateAllESP()

-- === SILENT AIM ДЛЯ BLOXSTRIKE ===
-- Находим нужные ремоуты
local Remotes = ReplicatedStorage:FindFirstChild("Network")
if Remotes then
    Remotes = Remotes:FindFirstChild("Remotes")
    if Remotes then
        Remotes = Remotes:FindFirstChild("Character")
    end
end

-- Ремоуты
local LookAngleRemote = Remotes and Remotes:FindFirstChild("ReplicateLookAngle")
local ShootRemote = Remotes and Remotes:FindFirstChild("Fire") or Remotes and Remotes:FindFirstChild("Shoot")

function GetClosestEnemy()
    local closest = nil
    local closestDist = aimRadius
    local centerX = Camera.ViewportSize.X / 2
    local centerY = Camera.ViewportSize.Y / 2

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local headPos = player.Character.Head.Position
            local screenPos, onScreen = Camera:WorldToViewportPoint(headPos)
            
            if onScreen then
                local dx = screenPos.X - centerX
                local dy = screenPos.Y - centerY
                local dist = math.sqrt(dx^2 + dy^2)
                
                if dist < closestDist then
                    closestDist = dist
                    closest = player
                end
            end
        end
    end
    
    return closest
end

-- Перехват выстрела
Mouse.Button1Down:Connect(function()
    if not silentAimEnabled then return end
    
    local target = GetClosestEnemy()
    if not target or not target.Character or not target.Character:FindFirstChild("Head") then 
        return 
    end
    
    local headPos = target.Character.Head.Position
    
    -- Отправляем направление взгляда на голову
    if LookAngleRemote then
        local direction = (headPos - Camera.CFrame.Position).Unit
        pcall(function()
            LookAngleRemote:FireServer(direction)
        end)
    end
    
    -- Отправляем выстрел
    if ShootRemote then
        pcall(function()
            ShootRemote:FireServer(headPos)
        end)
    else
        -- Если нет отдельного ремоута для выстрела
        local FireRemote = Remotes and Remotes:FindFirstChild("Fire")
        if FireRemote then
            pcall(function()
                FireRemote:FireServer(headPos)
            end)
        end
    end
end)

-- Автоматическое наведение (опционально)
RunService:BindToRenderStep("SilentAimBloxstrike", 0, function()
    if not silentAimEnabled then return end
    
    local target = GetClosestEnemy()
    if target and target.Character and target.Character:FindFirstChild("Head") then
        local headPos = target.Character.Head.Position
        -- Можно добавить плавное наведение камеры
        -- Camera.CFrame = CFrame.new(Camera.CFrame.Position, headPos)
    end
end)

print("✅ Zertyx для BloxStrike загружен!")
print("🔫 Silent Aim активен! Стреляй в круг — пули летят в голову.")
print("👁️ ESP работает через Highlight — видно за стенами!")
