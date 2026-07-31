-- LocalScript (поместите в StarterGui)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local camera = workspace.CurrentCamera

-- Настройки
local settings = {
    aimbotEnabled = false,
    espEnabled = false,
    silentAim = false,
    aimRadius = 200, -- пикселей от центра экрана
}

-- ---------------------------------- GUI ----------------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 200)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BackgroundTransparency = 0.3
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Bloxstrike Menu"
title.TextColor3 = Color3.new(1,1,1)
title.TextSize = 18
title.Font = Enum.Font.SourceSansBold
title.Parent = mainFrame

-- Кнопка Aimbot
local aimbotBtn = Instance.new("TextButton")
aimbotBtn.Size = UDim2.new(0, 100, 0, 30)
aimbotBtn.Position = UDim2.new(0, 10, 0, 40)
aimbotBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
aimbotBtn.Text = "Aimbot OFF"
aimbotBtn.TextColor3 = Color3.new(1,1,1)
aimbotBtn.Parent = mainFrame
aimbotBtn.MouseButton1Click:Connect(function()
    settings.aimbotEnabled = not settings.aimbotEnabled
    aimbotBtn.Text = settings.aimbotEnabled and "Aimbot ON" or "Aimbot OFF"
end)

-- Кнопка ESP
local espBtn = Instance.new("TextButton")
espBtn.Size = UDim2.new(0, 100, 0, 30)
espBtn.Position = UDim2.new(0, 130, 0, 40)
espBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
espBtn.Text = "ESP OFF"
espBtn.TextColor3 = Color3.new(1,1,1)
espBtn.Parent = mainFrame
espBtn.MouseButton1Click:Connect(function()
    settings.espEnabled = not settings.espEnabled
    espBtn.Text = settings.espEnabled and "ESP ON" or "ESP OFF"
end)

-- Чекбокс Silent Aim
local silentCheck = Instance.new("TextButton")
silentCheck.Size = UDim2.new(0, 100, 0, 30)
silentCheck.Position = UDim2.new(0, 10, 0, 80)
silentCheck.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
silentCheck.Text = "Silent OFF"
silentCheck.TextColor3 = Color3.new(1,1,1)
silentCheck.Parent = mainFrame
silentCheck.MouseButton1Click:Connect(function()
    settings.silentAim = not settings.silentAim
    silentCheck.Text = settings.silentAim and "Silent ON" or "Silent OFF"
end)

-- Ползунок радиуса
local radiusLabel = Instance.new("TextLabel")
radiusLabel.Size = UDim2.new(0, 100, 0, 20)
radiusLabel.Position = UDim2.new(0, 10, 0, 120)
radiusLabel.BackgroundTransparency = 1
radiusLabel.Text = "Radius: 200"
radiusLabel.TextColor3 = Color3.new(1,1,1)
radiusLabel.TextSize = 14
radiusLabel.Parent = mainFrame

local radiusSlider = Instance.new("Frame")
radiusSlider.Size = UDim2.new(0, 200, 0, 10)
radiusSlider.Position = UDim2.new(0, 10, 0, 145)
radiusSlider.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
radiusSlider.Parent = mainFrame

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(0.5, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
sliderFill.Parent = radiusSlider

local dragging = false
local function updateSlider(mouseX)
    local relativeX = math.clamp((mouseX - radiusSlider.AbsolutePosition.X) / radiusSlider.AbsoluteSize.X, 0, 1)
    sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
    settings.aimRadius = math.floor(relativeX * 400)
    radiusLabel.Text = "Radius: " .. settings.aimRadius
end

radiusSlider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        updateSlider(input.Position.X)
    end
end)

radiusSlider.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        updateSlider(input.Position.X)
    end
end)

-- ---------------------------------- ESP ----------------------------------
local espObjects = {}

local function createEspObject()
    local box = Drawing.new("Square")
    box.Thickness = 2
    box.Color = Color3.new(1,1,1)
    box.Filled = false
    box.Transparency = 1
    box.Visible = false
    
    local text = Drawing.new("Text")
    text.Color = Color3.new(1,1,1)
    text.Size = 14
    text.Center = true
    text.Outline = true
    text.OutlineColor = Color3.new(0,0,0)
    text.Visible = false
    
    return {box = box, text = text}
end

-- Определение команды игрока (подстройте под Bloxstrike)
local function getPlayerTeam(plr)
    local teamVal = plr:FindFirstChild("Team")
    if teamVal and (teamVal:IsA("StringValue") or teamVal:IsA("IntValue")) then
        return tostring(teamVal.Value)
    end
    -- Если используется встроенная команда Roblox
    if plr.Team then
        return plr.Team.Name
    end
    return nil
end

local function getEnemyHead(enemy)
    local char = enemy.Character
    if not char then return nil end
    local head = char:FindFirstChild("Head")
    if head then return head end
    return char:FindFirstChild("HumanoidRootPart")
end

local function worldToScreen(pos)
    local vec, onScreen = camera:WorldToScreenPoint(pos)
    return Vector2.new(vec.X, vec.Y), onScreen
end

RunService.RenderStepped:Connect(function()
    if not settings.espEnabled then
        for _, obj in pairs(espObjects) do
            obj.box.Visible = false
            obj.text.Visible = false
        end
        return
    end
    
    local localTeam = getPlayerTeam(player)
    if not localTeam then return end
    
    for _, other in ipairs(Players:GetPlayers()) do
        if other ~= player then
            local otherTeam = getPlayerTeam(other)
            if otherTeam and otherTeam ~= localTeam then
                local head = getEnemyHead(other)
                if head then
                    local headPos = head.Position
                    local screenPos, onScreen = worldToScreen(headPos + Vector3.new(0, 0.5, 0))
                    if onScreen then
                        if not espObjects[other] then
                            espObjects[other] = createEspObject()
                        end
                        local esp = espObjects[other]
                        
                        local humanoid = other.Character:FindFirstChild("Humanoid")
                        local height = 3
                        local bottomPos = headPos - Vector3.new(0, height/2, 0)
                        local topPos = headPos + Vector3.new(0, height/2, 0)
                        local bottomScreen, _ = worldToScreen(bottomPos)
                        local topScreen, _ = worldToScreen(topPos)
                        local boxHeight = math.abs(topScreen.Y - bottomScreen.Y)
                        local boxWidth = boxHeight * 0.5
                        local centerX = screenPos.X
                        local centerY = (topScreen.Y + bottomScreen.Y) / 2
                        
                        esp.box.Size = Vector2.new(boxWidth, boxHeight)
                        esp.box.Position = Vector2.new(centerX - boxWidth/2, centerY - boxHeight/2)
                        esp.box.Visible = true
                        
                        local hp = humanoid and humanoid.Health or 0
                        esp.text.Text = string.format("%.0f HP", hp)
                        esp.text.Position = Vector2.new(centerX, topScreen.Y - 20)
                        esp.text.Visible = true
                    else
                        if espObjects[other] then
                            espObjects[other].box.Visible = false
                            espObjects[other].text.Visible = false
                        end
                    end
                end
            else
                if espObjects[other] then
                    espObjects[other].box.Visible = false
                    espObjects[other].text.Visible = false
                end
            end
        end
    end
    
    for plr, esp in pairs(espObjects) do
        if not plr.Parent then
            esp.box.Visible = false
            esp.text.Visible = false
            espObjects[plr] = nil
        end
    end
end)

-- ---------------------------------- Aimbot ----------------------------------
local function getClosestEnemyInRadius()
    local localTeam = getPlayerTeam(player)
    if not localTeam then return nil, nil end
    
    local closestDist = settings.aimRadius
    local closestEnemy = nil
    local closestHeadPos = nil
    
    for _, other in ipairs(Players:GetPlayers()) do
        if other ~= player then
            local otherTeam = getPlayerTeam(other)
            if otherTeam and otherTeam ~= localTeam then
                local head = getEnemyHead(other)
                if head then
                    local headPos = head.Position
                    local screenPos, onScreen = worldToScreen(headPos)
                    if onScreen then
                        local dist = (screenPos - Vector2.new(mouse.X, mouse.Y)).Magnitude
                        if dist < closestDist then
                            closestDist = dist
                            closestEnemy = other
                            closestHeadPos = headPos
                        end
                    end
                end
            end
        end
    end
    return closestEnemy, closestHeadPos
end

local function aimAt(headPos)
    if not headPos then return end
    local camPos = camera.CFrame.Position
    mouse.Hit = CFrame.new(camPos + (headPos - camPos).Unit * 100, headPos)
end

mouse.Button1Down:Connect(function()
    if not settings.aimbotEnabled then return end
    
    local enemy, headPos = getClosestEnemyInRadius()
    if enemy and headPos then
        -- При silent aim мы всё равно перенаправляем выстрел через mouse.Hit.
        -- Для настоящего Silent Aim требуется перехват RemoteEvent'а оружия,
        -- чтобы изменять направление без движения прицела.
        aimAt(headPos)
    end
end)

print("Bloxstrike Menu loaded!")
