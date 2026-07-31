-- ZERTYX BLOXSTRIKE SILENT AIM + ESP (ВКЛАДКИ)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- СОЗДАНИЕ МЕНЮ (670x420, БЕЗ СКРУГЛЕНИЯ)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer.PlayerGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 670, 0, 420)
Frame.Position = UDim2.new(0.5, -335, 0.5, -210)
Frame.BackgroundColor3 = Color3.new(1, 1, 1)
Frame.BorderSizePixel = 1
Frame.BorderColor3 = Color3.new(0.8, 0.8, 0.8)
Frame.Parent = ScreenGui

-- === ВКЛАДКИ (сверху, мягкие скруглённые) ===
local Tabs = {"Visuals", "Aim", "Skins", "Settings"}
local TabButtons = {}
local currentTab = "Visuals"

-- Контейнер для вкладок
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, 0, 0, 40)
TabContainer.Position = UDim2.new(0, 0, 0, 0)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = Frame

-- Создаём вкладки
for i, tabName in pairs(Tabs) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(0, 167, 1, 0) -- 670/4 = 167.5
    tabBtn.Position = UDim2.new(0, (i-1) * 167, 0, 0)
    tabBtn.BackgroundColor3 = (i == 1) and Color3.new(0.9, 0.9, 0.9) or Color3.new(1, 1, 1)
    tabBtn.BorderSizePixel = 0
    tabBtn.Text = tabName
    tabBtn.TextColor3 = Color3.new(0, 0, 0)
    tabBtn.TextSize = 16
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.Parent = TabContainer
    
    -- Мягкие скругления сверху
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 8)
    tabCorner.Parent = tabBtn
    
    -- Только верхние углы скруглены
    local tabCorner2 = Instance.new("UICorner")
    tabCorner2.CornerRadius = UDim.new(0, 8)
    tabCorner2.Parent = tabBtn
    
    TabButtons[tabName] = tabBtn
    
    -- Переключение вкладок
    tabBtn.MouseButton1Click:Connect(function()
        currentTab = tabName
        
        -- Обновляем цвета вкладок
        for name, btn in pairs(TabButtons) do
            btn.BackgroundColor3 = (name == tabName) and Color3.new(0.9, 0.9, 0.9) or Color3.new(1, 1, 1)
        end
        
        -- Показываем/скрываем контент
        UpdateTabContent(tabName)
    end)
end

-- Контейнер для контента вкладок
local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -20, 1, -60)
ContentContainer.Position = UDim2.new(0, 10, 0, 50)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = Frame

-- === ФУНКЦИЯ ОБНОВЛЕНИЯ КОНТЕНТА ВКЛАДОК ===
local TabContent = {}

function UpdateTabContent(tabName)
    -- Очищаем контейнер
    for _, child in pairs(ContentContainer:GetChildren()) do
        child:Destroy()
    end
    
    if tabName == "Visuals" then
        -- === VISUALS ===
        local VisualLabel = Instance.new("TextLabel")
        VisualLabel.Size = UDim2.new(1, 0, 0, 30)
        VisualLabel.Position = UDim2.new(0, 0, 0, 10)
        VisualLabel.BackgroundTransparency = 1
        VisualLabel.Text = "Настройки визуала"
        VisualLabel.TextColor3 = Color3.new(0, 0, 0)
        VisualLabel.TextSize = 18
        VisualLabel.Font = Enum.Font.GothamBold
        VisualLabel.TextXAlignment = Enum.TextXAlignment.Left
        VisualLabel.Parent = ContentContainer
        
        -- ESP Toggle
        local EspBtn = Instance.new("TextButton")
        EspBtn.Size = UDim2.new(0, 200, 0, 40)
        EspBtn.Position = UDim2.new(0, 0, 0, 50)
        EspBtn.BackgroundColor3 = espEnabled and Color3.new(0.3, 0.8, 0.3) or Color3.new(0.8, 0.3, 0.3)
        EspBtn.Text = espEnabled and "ESP: ВКЛ" or "ESP: ВЫКЛ"
        EspBtn.TextColor3 = Color3.new(1, 1, 1)
        EspBtn.TextSize = 16
        EspBtn.Font = Enum.Font.Gotham
        EspBtn.Parent = ContentContainer
        
        EspBtn.MouseButton1Click:Connect(function()
            espEnabled = not espEnabled
            EspBtn.BackgroundColor3 = espEnabled and Color3.new(0.3, 0.8, 0.3) or Color3.new(0.8, 0.3, 0.3)
            EspBtn.Text = espEnabled and "ESP: ВКЛ" or "ESP: ВЫКЛ"
            
            if not espEnabled then
                for player, highlight in pairs(espObjects) do
                    highlight:Destroy()
                    espObjects[player] = nil
                end
            else
                updateAllESP()
            end
        end)
        
    elseif tabName == "Aim" then
        -- === AIM ===
        local AimLabel = Instance.new("TextLabel")
        AimLabel.Size = UDim2.new(1, 0, 0, 30)
        AimLabel.Position = UDim2.new(0, 0, 0, 10)
        AimLabel.BackgroundTransparency = 1
        AimLabel.Text = "Настройки прицела"
        AimLabel.TextColor3 = Color3.new(0, 0, 0)
        AimLabel.TextSize = 18
        AimLabel.Font = Enum.Font.GothamBold
        AimLabel.TextXAlignment = Enum.TextXAlignment.Left
        AimLabel.Parent = ContentContainer
        
        -- Silent Aim Toggle
        local SaBtn = Instance.new("TextButton")
        SaBtn.Size = UDim2.new(0, 200, 0, 40)
        SaBtn.Position = UDim2.new(0, 0, 0, 50)
        SaBtn.BackgroundColor3 = silentAimEnabled and Color3.new(0.3, 0.8, 0.3) or Color3.new(0.8, 0.3, 0.3)
        SaBtn.Text = silentAimEnabled and "Silent Aim: ВКЛ" or "Silent Aim: ВЫКЛ"
        SaBtn.TextColor3 = Color3.new(1, 1, 1)
        SaBtn.TextSize = 16
        SaBtn.Font = Enum.Font.Gotham
        SaBtn.Parent = ContentContainer
        
        SaBtn.MouseButton1Click:Connect(function()
            silentAimEnabled = not silentAimEnabled
            SaBtn.BackgroundColor3 = silentAimEnabled and Color3.new(0.3, 0.8, 0.3) or Color3.new(0.8, 0.3, 0.3)
            SaBtn.Text = silentAimEnabled and "Silent Aim: ВКЛ" or "Silent Aim: ВЫКЛ"
            CircleContainer.Visible = silentAimEnabled
        end)
        
        -- Радиус
        local RadiusLabel2 = Instance.new("TextLabel")
        RadiusLabel2.Size = UDim2.new(0, 100, 0, 30)
        RadiusLabel2.Position = UDim2.new(0, 0, 0, 100)
        RadiusLabel2.BackgroundTransparency = 1
        RadiusLabel2.Text = "Радиус:"
        RadiusLabel2.TextColor3 = Color3.new(0, 0, 0)
        RadiusLabel2.TextSize = 16
        RadiusLabel2.Font = Enum.Font.Gotham
        RadiusLabel2.TextXAlignment = Enum.TextXAlignment.Left
        RadiusLabel2.Parent = ContentContainer
        
        local RadiusBox = Instance.new("TextBox")
        RadiusBox.Size = UDim2.new(0, 80, 0, 30)
        RadiusBox.Position = UDim2.new(0, 110, 0, 100)
        RadiusBox.BackgroundColor3 = Color3.new(0.9, 0.9, 0.9)
        RadiusBox.Text = tostring(aimRadius)
        RadiusBox.TextColor3 = Color3.new(0, 0, 0)
        RadiusBox.TextSize = 16
        RadiusBox.Font = Enum.Font.Gotham
        RadiusBox.Parent = ContentContainer
        
        RadiusBox.FocusLost:Connect(function()
            local val = tonumber(RadiusBox.Text)
            if val then
                aimRadius = math.clamp(val, 0, 300)
                RadiusBox.Text = tostring(aimRadius)
                CircleContainer.Size = UDim2.new(0, aimRadius * 2, 0, aimRadius * 2)
                CircleContainer.Position = UDim2.new(0.5, -aimRadius, 0.5, -aimRadius)
            else
                RadiusBox.Text = tostring(aimRadius)
            end
        end)
        
    elseif tabName == "Skins" then
        -- === SKINS ===
        local SkinsLabel = Instance.new("TextLabel")
        SkinsLabel.Size = UDim2.new(1, 0, 0, 30)
        SkinsLabel.Position = UDim2.new(0, 0, 0, 10)
        SkinsLabel.BackgroundTransparency = 1
        SkinsLabel.Text = "Скины оружия"
        SkinsLabel.TextColor3 = Color3.new(0, 0, 0)
        SkinsLabel.TextSize = 18
        SkinsLabel.Font = Enum.Font.GothamBold
        SkinsLabel.TextXAlignment = Enum.TextXAlignment.Left
        SkinsLabel.Parent = ContentContainer
        
        local SkinsInfo = Instance.new("TextLabel")
        SkinsInfo.Size = UDim2.new(1, 0, 0, 30)
        SkinsInfo.Position = UDim2.new(0, 0, 0, 50)
        SkinsInfo.BackgroundTransparency = 1
        SkinsInfo.Text = "Функция в разработке"
        SkinsInfo.TextColor3 = Color3.new(0.5, 0.5, 0.5)
        SkinsInfo.TextSize = 14
        SkinsInfo.Font = Enum.Font.Gotham
        SkinsInfo.TextXAlignment = Enum.TextXAlignment.Left
        SkinsInfo.Parent = ContentContainer
        
    elseif tabName == "Settings" then
        -- === SETTINGS ===
        local SettingsLabel = Instance.new("TextLabel")
        SettingsLabel.Size = UDim2.new(1, 0, 0, 30)
        SettingsLabel.Position = UDim2.new(0, 0, 0, 10)
        SettingsLabel.BackgroundTransparency = 1
        SettingsLabel.Text = "Настройки"
        SettingsLabel.TextColor3 = Color3.new(0, 0, 0)
        SettingsLabel.TextSize = 18
        SettingsLabel.Font = Enum.Font.GothamBold
        SettingsLabel.TextXAlignment = Enum.TextXAlignment.Left
        SettingsLabel.Parent = ContentContainer
        
        local SettingsInfo = Instance.new("TextLabel")
        SettingsInfo.Size = UDim2.new(1, 0, 0, 30)
        SettingsInfo.Position = UDim2.new(0, 0, 0, 50)
        SettingsInfo.BackgroundTransparency = 1
        SettingsInfo.Text = "Настройки чиста"
        SettingsInfo.TextColor3 = Color3.new(0.5, 0.5, 0.5)
        SettingsInfo.TextSize = 14
        SettingsInfo.Font = Enum.Font.Gotham
        SettingsInfo.TextXAlignment = Enum.TextXAlignment.Left
        SettingsInfo.Parent = ContentContainer
    end
end

-- ПЕРЕМЕННЫЕ
local espEnabled = true
local silentAimEnabled = true
local aimRadius = 150
local espObjects = {}

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

-- === HIGHLIGHT ESP ===
local function updatePlayerESP(playerObj)
    if espObjects[playerObj] then
        espObjects[playerObj]:Destroy()
        espObjects[playerObj] = nil
    end
    
    if not espEnabled then return end
    if playerObj == LocalPlayer then return end
    if not playerObj.Character then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Parent = playerObj.Character
    highlight.FillColor = Color3.fromHSV(math.random(), 1, 1)
    highlight.FillTransparency = 0.4
    highlight.OutlineColor = Color3.new(1, 1, 1)
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    
    espObjects[playerObj] = highlight
end

local function updateAllESP()
    for _, player in pairs(Players:GetPlayers()) do
        updatePlayerESP(player)
    end
end

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

for _, player in pairs(Players:GetPlayers()) do
    player.CharacterAdded:Connect(function()
        updatePlayerESP(player)
    end)
end

updateAllESP()

-- === SILENT AIM ===
local Remotes = ReplicatedStorage:FindFirstChild("Network")
if Remotes then
    Remotes = Remotes:FindFirstChild("Remotes")
    if Remotes then
        Remotes = Remotes:FindFirstChild("Character")
    end
end

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

Mouse.Button1Down:Connect(function()
    if not silentAimEnabled then return end
    
    local target = GetClosestEnemy()
    if not target or not target.Character or not target.Character:FindFirstChild("Head") then 
        return 
    end
    
    local headPos = target.Character.Head.Position
    
    if LookAngleRemote then
        local direction = (headPos - Camera.CFrame.Position).Unit
        pcall(function()
            LookAngleRemote:FireServer(direction)
        end)
    end
    
    if ShootRemote then
        pcall(function()
            ShootRemote:FireServer(headPos)
        end)
    else
        local FireRemote = Remotes and Remotes:FindFirstChild("Fire")
        if FireRemote then
            pcall(function()
                FireRemote:FireServer(headPos)
            end)
        end
    end
end)

-- Загружаем первую вкладку
UpdateTabContent("Visuals")

print("✅ Zertyx с вкладками загружен!")
