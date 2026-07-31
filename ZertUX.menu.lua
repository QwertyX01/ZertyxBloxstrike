-- ZERTYX BLOXSTRIKE (УНИВЕРСАЛЬНЫЙ SILENT AIM + ESP)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

-- === ДВИГАЕМОЕ МЕНЮ ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer.PlayerGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 670, 0, 420)
Frame.Position = UDim2.new(0.5, -335, 0.5, -210)
Frame.BackgroundColor3 = Color3.new(1, 1, 1)
Frame.BorderSizePixel = 1
Frame.BorderColor3 = Color3.new(0.8, 0.8, 0.8)
Frame.Parent = ScreenGui

-- === ДРАГ МЕНЮ ===
local dragging = false
local dragStart = nil
local startPos = nil

Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = Vector2.new(input.Position.X, input.Position.Y)
        startPos = Frame.Position
    end
end)

Frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStart
        Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- === ВКЛАДКИ ===
local Tabs = {"Visuals", "Aim", "Skins", "Settings"}
local TabButtons = {}
local currentTab = "Visuals"

local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, 0, 0, 40)
TabContainer.Position = UDim2.new(0, 0, 0, 0)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = Frame

for i, tabName in pairs(Tabs) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(0, 167, 1, 0)
    tabBtn.Position = UDim2.new(0, (i-1) * 167, 0, 0)
    tabBtn.BackgroundColor3 = (i == 1) and Color3.new(0.9, 0.9, 0.9) or Color3.new(1, 1, 1)
    tabBtn.BorderSizePixel = 0
    tabBtn.Text = tabName
    tabBtn.TextColor3 = Color3.new(0, 0, 0)
    tabBtn.TextSize = 16
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.Parent = TabContainer
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 8)
    tabCorner.Parent = tabBtn
    
    TabButtons[tabName] = tabBtn
    
    tabBtn.MouseButton1Click:Connect(function()
        currentTab = tabName
        for name, btn in pairs(TabButtons) do
            btn.BackgroundColor3 = (name == tabName) and Color3.new(0.9, 0.9, 0.9) or Color3.new(1, 1, 1)
        end
        UpdateTabContent(tabName)
    end)
end

local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -20, 1, -60)
ContentContainer.Position = UDim2.new(0, 10, 0, 50)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = Frame

-- === ПЕРЕМЕННЫЕ ===
local espEnabled = true
local silentAimEnabled = true
local aimRadius = 150
local espObjects = {}
local circleVisible = false

-- === КРАСНЫЙ КРУГ ===
local CircleContainer = Instance.new("Frame")
CircleContainer.Size = UDim2.new(0, aimRadius * 2, 0, aimRadius * 2)
CircleContainer.Position = UDim2.new(0.5, -aimRadius, 0.5, -aimRadius)
CircleContainer.BackgroundTransparency = 1
CircleContainer.Visible = false
CircleContainer.Parent = ScreenGui

local CircleMain = Instance.new("Frame")
CircleMain.Size = UDim2.new(1, 0, 1, 0)
CircleMain.Position = UDim2.new(0, 0, 0, 0)
CircleMain.BackgroundColor3 = Color3.new(1, 0, 0)
CircleMain.BackgroundTransparency = 0.7
CircleMain.BorderSizePixel = 3
CircleMain.BorderColor3 = Color3.new(1, 0, 0)
CircleMain.Parent = CircleContainer

local CircleCorner = Instance.new("UICorner")
CircleCorner.CornerRadius = UDim.new(1, 0)
CircleCorner.Parent = CircleMain

-- === ФУНКЦИИ ОБНОВЛЕНИЯ ===
local function UpdateRadius(newRadius)
    aimRadius = math.clamp(newRadius, 0, 300)
    CircleContainer.Size = UDim2.new(0, aimRadius * 2, 0, aimRadius * 2)
    CircleContainer.Position = UDim2.new(0.5, -aimRadius, 0.5, -aimRadius)
    
    for _, child in pairs(ContentContainer:GetChildren()) do
        if child.Name == "RadiusValue" then
            child.Text = tostring(aimRadius)
        end
    end
end

local function UpdateCircleVisibility()
    CircleContainer.Visible = silentAimEnabled and circleVisible
end

-- === УНИВЕРСАЛЬНЫЙ SILENT AIM ===
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

function GetHeadPosition(target)
    if target and target.Character and target.Character:FindFirstChild("Head") then
        return target.Character.Head.Position
    end
    return nil
end

-- Хукаем все RemoteEvent
local function HookRemote(remote)
    if not remote then return end
    if remote._hooked then return end
    remote._hooked = true
    
    local oldFire = remote.FireServer
    remote.FireServer = function(self, ...)
        if not silentAimEnabled then
            return oldFire(self, ...)
        end
        
        local args = {...}
        local target = GetClosestEnemy()
        local headPos = GetHeadPosition(target)
        
        if headPos then
            for i, arg in pairs(args) do
                if type(arg) == "Vector3" then
                    args[i] = headPos
                elseif type(arg) == "Instance" and arg:IsA("Player") then
                    args[i] = target
                elseif type(arg) == "CFrame" then
                    args[i] = CFrame.new(arg.Position, headPos)
                elseif type(arg) == "string" and arg:lower():match("head") then
                    args[i] = "Head"
                end
            end
            
            local hasVector = false
            for _, arg in pairs(args) do
                if type(arg) == "Vector3" then
                    hasVector = true
                    break
                end
            end
            if not hasVector then
                table.insert(args, headPos)
            end
            
            return oldFire(self, unpack(args))
        end
        
        return oldFire(self, ...)
    end
end

-- Хукаем все RemoteEvent в игре
for _, obj in pairs(game:GetDescendants()) do
    if obj:IsA("RemoteEvent") then
        HookRemote(obj)
    end
end

-- Хукаем RemoteFunction
for _, obj in pairs(game:GetDescendants()) do
    if obj:IsA("RemoteFunction") then
        local oldInvoke = obj.InvokeServer
        obj.InvokeServer = function(self, ...)
            if not silentAimEnabled then
                return oldInvoke(self, ...)
            end
            
            local args = {...}
            local target = GetClosestEnemy()
            local headPos = GetHeadPosition(target)
            
            if headPos then
                for i, arg in pairs(args) do
                    if type(arg) == "Vector3" then
                        args[i] = headPos
                    elseif type(arg) == "Instance" and arg:IsA("Player") then
                        args[i] = target
                    elseif type(arg) == "string" and arg:lower():match("head") then
                        args[i] = "Head"
                    end
                end
                return oldInvoke(self, unpack(args))
            end
            
            return oldInvoke(self, ...)
        end
    end
end

-- Перехватываем ReplicateLookAngle
local LookAngleRemote = nil
local Network = ReplicatedStorage:FindFirstChild("Network")
if Network then
    local Remotes = Network:FindFirstChild("Remotes")
    if Remotes then
        local Character = Remotes:FindFirstChild("Character")
        if Character then
            LookAngleRemote = Character:FindFirstChild("ReplicateLookAngle")
        end
    end
end

if LookAngleRemote then
    local oldLookFire = LookAngleRemote.FireServer
    LookAngleRemote.FireServer = function(self, direction)
        if not silentAimEnabled then
            return oldLookFire(self, direction)
        end
        
        local target = GetClosestEnemy()
        local headPos = GetHeadPosition(target)
        
        if headPos then
            local newDirection = (headPos - Camera.CFrame.Position).Unit
            return oldLookFire(self, newDirection)
        end
        
        return oldLookFire(self, direction)
    end
end

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

-- === ФУНКЦИЯ ОБНОВЛЕНИЯ КОНТЕНТА ВКЛАДОК ===
function UpdateTabContent(tabName)
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
            circleVisible = silentAimEnabled
            UpdateCircleVisibility()
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
        
        local MinusBtn = Instance.new("TextButton")
        MinusBtn.Size = UDim2.new(0, 40, 0, 30)
        MinusBtn.Position = UDim2.new(0, 110, 0, 100)
        MinusBtn.BackgroundColor3 = Color3.new(0.8, 0.8, 0.8)
        MinusBtn.Text = "-"
        MinusBtn.TextColor3 = Color3.new(0, 0, 0)
        MinusBtn.TextSize = 20
        MinusBtn.Font = Enum.Font.GothamBold
        MinusBtn.Parent = ContentContainer
        
        local RadiusValue = Instance.new("TextLabel")
        RadiusValue.Name = "RadiusValue"
        RadiusValue.Size = UDim2.new(0, 60, 0, 30)
        RadiusValue.Position = UDim2.new(0, 155, 0, 100)
        RadiusValue.BackgroundColor3 = Color3.new(0.95, 0.95, 0.95)
        RadiusValue.Text = tostring(aimRadius)
        RadiusValue.TextColor3 = Color3.new(0, 0, 0)
        RadiusValue.TextSize = 16
        RadiusValue.Font = Enum.Font.Gotham
        RadiusValue.Parent = ContentContainer
        
        local PlusBtn = Instance.new("TextButton")
        PlusBtn.Size = UDim2.new(0, 40, 0, 30)
        PlusBtn.Position = UDim2.new(0, 220, 0, 100)
        PlusBtn.BackgroundColor3 = Color3.new(0.8, 0.8, 0.8)
        PlusBtn.Text = "+"
        PlusBtn.TextColor3 = Color3.new(0, 0, 0)
        PlusBtn.TextSize = 20
        PlusBtn.Font = Enum.Font.GothamBold
        PlusBtn.Parent = ContentContainer
        
        MinusBtn.MouseButton1Click:Connect(function()
            UpdateRadius(aimRadius - 10)
        end)
        
        PlusBtn.MouseButton1Click:Connect(function()
            UpdateRadius(aimRadius + 10)
        end)
        
        local RadiusBox = Instance.new("TextBox")
        RadiusBox.Size = UDim2.new(0, 80, 0, 30)
        RadiusBox.Position = UDim2.new(0, 280, 0, 100)
        RadiusBox.BackgroundColor3 = Color3.new(0.9, 0.9, 0.9)
        RadiusBox.Text = tostring(aimRadius)
        RadiusBox.TextColor3 = Color3.new(0, 0, 0)
        RadiusBox.TextSize = 16
        RadiusBox.Font = Enum.Font.Gotham
        RadiusBox.PlaceholderText = "0-300"
        RadiusBox.Parent = ContentContainer
        
        RadiusBox.FocusLost:Connect(function()
            local val = tonumber(RadiusBox.Text)
            if val then
                UpdateRadius(val)
                RadiusBox.Text = tostring(aimRadius)
            else
                RadiusBox.Text = tostring(aimRadius)
            end
        end)
        
        local RadiusDesc = Instance.new("TextLabel")
        RadiusDesc.Size = UDim2.new(1, 0, 0, 25)
        RadiusDesc.Position = UDim2.new(0, 0, 0, 140)
        RadiusDesc.BackgroundTransparency = 1
        RadiusDesc.Text = "Нажми +/- для изменения радиуса (0-300)"
        RadiusDesc.TextColor3 = Color3.new(0.5, 0.5, 0.5)
        RadiusDesc.TextSize = 13
        RadiusDesc.Font = Enum.Font.Gotham
        RadiusDesc.TextXAlignment = Enum.TextXAlignment.Left
        RadiusDesc.Parent = ContentContainer
        
        local CircleToggle = Instance.new("TextButton")
        CircleToggle.Size = UDim2.new(0, 200, 0, 35)
        CircleToggle.Position = UDim2.new(0, 0, 0, 180)
        CircleToggle.BackgroundColor3 = circleVisible and Color3.new(0.3, 0.8, 0.3) or Color3.new(0.8, 0.3, 0.3)
        CircleToggle.Text = circleVisible and "Круг: ВКЛ" or "Круг: ВЫКЛ"
        CircleToggle.TextColor3 = Color3.new(1, 1, 1)
        CircleToggle.TextSize = 16
        CircleToggle.Font = Enum.Font.Gotham
        CircleToggle.Parent = ContentContainer
        
        CircleToggle.MouseButton1Click:Connect(function()
            circleVisible = not circleVisible
            CircleToggle.BackgroundColor3 = circleVisible and Color3.new(0.3, 0.8, 0.3) or Color3.new(0.8, 0.3, 0.3)
            CircleToggle.Text = circleVisible and "Круг: ВКЛ" or "Круг: ВЫКЛ"
            UpdateCircleVisibility()
        end)
        
        local SilentDesc = Instance.new("TextLabel")
        SilentDesc.Size = UDim2.new(1, 0, 0, 25)
        SilentDesc.Position = UDim2.new(0, 0, 0, 230)
        SilentDesc.BackgroundTransparency = 1
        SilentDesc.Text = "🔫 Silent Aim: пули летят в голову даже если не смотришь на врага!"
        SilentDesc.TextColor3 = Color3.new(0.3, 0.6, 0.3)
        SilentDesc.TextSize = 14
        SilentDesc.Font = Enum.Font.GothamBold
        SilentDesc.TextXAlignment = Enum.TextXAlignment.Left
        SilentDesc.Parent = ContentContainer
        
    elseif tabName == "Skins" then
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
        SettingsInfo.Text = "Настройки чита"
        SettingsInfo.TextColor3 = Color3.new(0.5, 0.5, 0.5)
        SettingsInfo.TextSize = 14
        SettingsInfo.Font = Enum.Font.Gotham
        SettingsInfo.TextXAlignment = Enum.TextXAlignment.Left
        SettingsInfo.Parent = ContentContainer
    end
end

-- Загружаем первую вкладку
UpdateTabContent("Visuals")

print("✅ Zertyx с универсальным Silent Aim загружен!")
print("🔫 Silent Aim: пули летят в голову даже если не смотришь на врага!")
print("🔄 Меню можно перетаскивать за любую часть")
print("🔴 Круг красный, появляется при включении в AIM")
print("➕➖ Радиус меняется кнопками + и -")
