-- Zertyx CHEAT v5.0 - WHITE THEME + ANIMATIONS + MISC
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- НАСТРОЙКИ
local ESPEnabled = true
local BigHeadEnabled = false
local ThirdPersonEnabled = false
local FOVEnabled = false
local MoveBeforeTimeEnabled = false
local ZoomDistance = 10
local FOVValue = 120
local espObjects = {}
local bigHeadObjects = {}
local originalCameraOffset = nil
local originalFOV = nil
local originalWalkSpeed = nil

-- УДАЛЯЕМ СТАРОЕ МЕНЮ (если есть)
pcall(function()
    LocalPlayer.PlayerGui:FindFirstChild("Zertyx"):Destroy()
end)

-- === ГЛАВНОЕ МЕНЮ ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.Name = "Zertyx"
ScreenGui.ResetOnSpawn = false

-- === МЕНЮ (БЕЛЫЙ ФОН) ===
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 640, 0, 420)
MainFrame.Position = UDim2.new(0.5, -320, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.BackgroundTransparency = 0
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Visible = false

-- Скругление углов (более мягкое)
local MainCorner = Instance.new("UICorner")
MainCorner.Parent = MainFrame
MainCorner.CornerRadius = UDim.new(0, 24)

-- Тень
local Shadow = Instance.new("ImageLabel")
Shadow.Parent = MainFrame
Shadow.Size = UDim2.new(1, 20, 1, 20)
Shadow.Position = UDim2.new(0, -10, 0, -10)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://1317777270"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.5

-- === ЗАГОЛОВОК (В ЛЕВЫЙ УГОЛ, КРАСНЫЙ) ===
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(0, 200, 0, 40)
Title.Position = UDim2.new(0, 16, 0, 8)
Title.BackgroundTransparency = 1
Title.Text = "Zertyx"
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.TextSize = 28
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextYAlignment = Enum.TextYAlignment.Center

-- Версия (маленькая)
local Version = Instance.new("TextLabel")
Version.Parent = MainFrame
Version.Size = UDim2.new(0, 50, 0, 20)
Version.Position = UDim2.new(0, 120, 0, 28)
Version.BackgroundTransparency = 1
Version.Text = "v5.0"
Version.TextColor3 = Color3.fromRGB(150, 150, 150)
Version.TextSize = 12
Version.Font = Enum.Font.GothamMedium
Version.TextXAlignment = Enum.TextXAlignment.Left
Version.TextYAlignment = Enum.TextYAlignment.Top

-- === ВКЛАДКИ ===
local TabContainer = Instance.new("Frame")
TabContainer.Parent = MainFrame
TabContainer.Size = UDim2.new(1, 0, 0, 40)
TabContainer.Position = UDim2.new(0, 0, 0, 48)
TabContainer.BackgroundTransparency = 1
TabContainer.BorderSizePixel = 0

local tabs = {"Visuals", "Aim", "Misc"}
local tabBtns = {}
local tabContents = {}

for i = 1, 3 do
    local btn = Instance.new("TextButton")
    btn.Parent = TabContainer
    btn.Size = UDim2.new(0, 80, 0, 30)
    btn.Position = UDim2.new(0, 16 + (i-1) * 90, 0.5, -15)
    btn.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
    btn.BackgroundTransparency = 0
    btn.BorderSizePixel = 0
    btn.Text = string.upper(tabs[i])
    btn.TextColor3 = Color3.fromRGB(80, 80, 80)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamMedium
    btn.AutoButtonColor = false
    
    local corner = Instance.new("UICorner")
    corner.Parent = btn
    corner.CornerRadius = UDim.new(0, 16) -- мягкие углы
    
    local content = Instance.new("ScrollingFrame")
    content.Parent = MainFrame
    content.Size = UDim2.new(1, -20, 1, -100)
    content.Position = UDim2.new(0, 10, 0, 96)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.Visible = (i == 1)
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.ScrollBarThickness = 4
    content.ScrollBarImageColor3 = Color3.fromRGB(200, 200, 200)
    content.Name = tabs[i] .. "Content"
    
    tabBtns[tabs[i]] = btn
    tabContents[tabs[i]] = content
    
    btn.MouseButton1Click:Connect(function()
        -- Анимация: плавное изменение цвета
        for name, b in pairs(tabBtns) do
            local tween = TweenService:Create(b, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundColor3 = Color3.fromRGB(240, 240, 240),
                TextColor3 = Color3.fromRGB(80, 80, 80)
            })
            tween:Play()
            TabContents[name].Visible = false
        end
        local tween = TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = Color3.fromRGB(200, 200, 200),
            TextColor3 = Color3.fromRGB(0, 0, 0)
        })
        tween:Play()
        content.Visible = true
    end)
end

-- Активируем первую вкладку
local firstBtn = tabBtns["Visuals"]
if firstBtn then
    firstBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    firstBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
end

-- === ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ ДЛЯ ЭЛЕМЕНТОВ ===
local function CreateToggleRow(parent, label, defaultState, callback, yPos)
    local row = Instance.new("Frame")
    row.Parent = parent
    row.Size = UDim2.new(1, -10, 0, 40)
    row.Position = UDim2.new(0, 5, 0, yPos)
    row.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
    row.BackgroundTransparency = 0
    row.BorderSizePixel = 0
    
    local rowCorner = Instance.new("UICorner")
    rowCorner.Parent = row
    rowCorner.CornerRadius = UDim.new(0, 12)
    
    local labelText = Instance.new("TextLabel")
    labelText.Parent = row
    labelText.Size = UDim2.new(0, 180, 1, 0)
    labelText.Position = UDim2.new(0, 12, 0, 0)
    labelText.BackgroundTransparency = 1
    labelText.Text = label
    labelText.TextColor3 = Color3.fromRGB(40, 40, 40)
    labelText.TextSize = 14
    labelText.Font = Enum.Font.GothamMedium
    labelText.TextXAlignment = Enum.TextXAlignment.Left
    labelText.TextYAlignment = Enum.TextYAlignment.Center
    
    local toggle = Instance.new("TextButton")
    toggle.Parent = row
    toggle.Size = UDim2.new(0, 30, 0, 30)
    toggle.Position = UDim2.new(1, -40, 0.5, -15)
    toggle.BackgroundColor3 = defaultState and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(200, 200, 200)
    toggle.BackgroundTransparency = 0
    toggle.BorderSizePixel = 0
    toggle.Text = defaultState and "✓" or ""
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.TextSize = 18
    toggle.Font = Enum.Font.GothamBold
    toggle.AutoButtonColor = false
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.Parent = toggle
    toggleCorner.CornerRadius = UDim.new(0, 6)
    
    local state = defaultState
    toggle.MouseButton1Click:Connect(function()
        state = not state
        toggle.Text = state and "✓" or ""
        toggle.BackgroundColor3 = state and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(200, 200, 200)
        if callback then callback(state) end
    end)
    
    return row, toggle
end

local function CreateSlider(parent, label, minVal, maxVal, defaultVal, callback, yPos)
    local row = Instance.new("Frame")
    row.Parent = parent
    row.Size = UDim2.new(1, -10, 0, 40)
    row.Position = UDim2.new(0, 5, 0, yPos)
    row.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
    row.BackgroundTransparency = 0
    row.BorderSizePixel = 0
    
    local rowCorner = Instance.new("UICorner")
    rowCorner.Parent = row
    rowCorner.CornerRadius = UDim.new(0, 12)
    
    local labelText = Instance.new("TextLabel")
    labelText.Parent = row
    labelText.Size = UDim2.new(0, 100, 1, 0)
    labelText.Position = UDim2.new(0, 12, 0, 0)
    labelText.BackgroundTransparency = 1
    labelText.Text = label
    labelText.TextColor3 = Color3.fromRGB(40, 40, 40)
    labelText.TextSize = 14
    labelText.Font = Enum.Font.GothamMedium
    labelText.TextXAlignment = Enum.TextXAlignment.Left
    labelText.TextYAlignment = Enum.TextYAlignment.Center
    
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Parent = row
    sliderFrame.Size = UDim2.new(0, 120, 0, 6)
    sliderFrame.Position = UDim2.new(0, 120, 0.5, -3)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
    sliderFrame.BorderSizePixel = 0
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.Parent = sliderFrame
    sliderCorner.CornerRadius = UDim.new(0, 10)
    
    local fill = Instance.new("Frame")
    fill.Parent = sliderFrame
    fill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    fill.BorderSizePixel = 0
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.Parent = fill
    fillCorner.CornerRadius = UDim.new(0, 10)
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Parent = row
    valueLabel.Size = UDim2.new(0, 30, 0, 20)
    valueLabel.Position = UDim2.new(0, 250, 0.5, -10)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(defaultVal)
    valueLabel.TextColor3 = Color3.fromRGB(40, 40, 40)
    valueLabel.TextSize = 13
    valueLabel.Font = Enum.Font.GothamMedium
    
    local dragging = false
    local currentVal = defaultVal
    
    sliderFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    sliderFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    sliderFrame.MouseMoved:Connect(function()
        if dragging then
            local mousePos = LocalPlayer:GetMouse().X
            local absPos = sliderFrame.AbsolutePosition.X
            local width = sliderFrame.AbsoluteSize.X
            local percent = math.clamp((mousePos - absPos) / width, 0, 1)
            local val = math.round(minVal + (maxVal - minVal) * percent)
            currentVal = val
            fill.Size = UDim2.new(percent, 0, 1, 0)
            valueLabel.Text = tostring(val)
            if callback then callback(val) end
        end
    end)
    
    return row
end

-- === СОЗДАНИЕ ЭЛЕМЕНТОВ В VISUALS ===
local visualsContent = tabContents["Visuals"]
local yPos = 10

CreateToggleRow(visualsContent, "ESP", ESPEnabled, function(state)
    ESPEnabled = state
    if state then UpdateESP() else ClearESP() end
end, yPos)
yPos = yPos + 50

CreateToggleRow(visualsContent, "Big Head", BigHeadEnabled, function(state)
    BigHeadEnabled = state
    if state then UpdateBigHead() else ClearBigHead() end
end, yPos)
yPos = yPos + 50

local thirdPersonRow, thirdPersonToggle = CreateToggleRow(visualsContent, "Third Person", ThirdPersonEnabled, function(state)
    ThirdPersonEnabled = state
    if state then 
        zoomSlider.Visible = true
        if originalCameraOffset == nil then
            local char = LocalPlayer.Character
            if char then
                local humanoid = char:FindFirstChild("Humanoid")
                if humanoid then
                    originalCameraOffset = humanoid.CameraOffset
                end
            end
        end
    else 
        zoomSlider.Visible = false
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChild("Humanoid")
            if humanoid then
                if originalCameraOffset ~= nil then
                    humanoid.CameraOffset = originalCameraOffset
                else
                    humanoid.CameraOffset = Vector3.new(0, 0, 0)
                end
            end
        end
    end
end, yPos)
yPos = yPos + 50

local zoomSlider = CreateSlider(visualsContent, "Zoom", 3, 20, ZoomDistance, function(val)
    ZoomDistance = val
end, yPos)
zoomSlider.Visible = false
yPos = yPos + 50

local fovRow, fovToggle = CreateToggleRow(visualsContent, "FOV", FOVEnabled, function(state)
    FOVEnabled = state
    if state then 
        fovSlider.Visible = true
        if originalFOV == nil then
            originalFOV = Camera.FieldOfView
        end
        Camera.FieldOfView = FOVValue
    else 
        fovSlider.Visible = false
        if originalFOV ~= nil then
            Camera.FieldOfView = originalFOV
        end
    end
end, yPos)
yPos = yPos + 50

local fovSlider = CreateSlider(visualsContent, "FOV Value", 70, 120, FOVValue, function(val)
    FOVValue = val
    if FOVEnabled then
        Camera.FieldOfView = FOVValue
    end
end, yPos)
fovSlider.Visible = false
yPos = yPos + 50

visualsContent.CanvasSize = UDim2.new(0, 0, 0, yPos + 20)

-- === СОЗДАНИЕ ЭЛЕМЕНТОВ В MISC ===
local miscContent = tabContents["Misc"]
local miscY = 10

CreateToggleRow(miscContent, "Move before time", MoveBeforeTimeEnabled, function(state)
    MoveBeforeTimeEnabled = state
    if state then
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChild("Humanoid")
            if humanoid then
                if originalWalkSpeed == nil then
                    originalWalkSpeed = humanoid.WalkSpeed
                end
                humanoid.WalkSpeed = 16
            end
        end
    else
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChild("Humanoid")
            if humanoid then
                if originalWalkSpeed ~= nil then
                    humanoid.WalkSpeed = originalWalkSpeed
                    originalWalkSpeed = nil
                else
                    humanoid.WalkSpeed = 16
                end
            end
        end
    end
end, miscY)
miscY = miscY + 50

miscContent.CanvasSize = UDim2.new(0, 0, 0, miscY + 20)

-- === ФУНКЦИИ ДЛЯ ПРИНУДИТЕЛЬНОГО ОБНОВЛЕНИЯ ===
RunService.RenderStepped:Connect(function()
    if ThirdPersonEnabled then
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.CameraOffset = Vector3.new(0, 2, -ZoomDistance)
            end
        end
    end
    
    if FOVEnabled then
        Camera.FieldOfView = FOVValue
    end
    
    if MoveBeforeTimeEnabled then
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChild("Humanoid")
            if humanoid and humanoid.WalkSpeed ~= 16 then
                humanoid.WalkSpeed = 16
            end
        end
    end
end)

-- === ESP ===
function CreateESP(targetPlayer)
    if espObjects[targetPlayer] then
        espObjects[targetPlayer]:Destroy()
        espObjects[targetPlayer] = nil
    end
    if not targetPlayer.Character then return end
    local highlight = Instance.new("Highlight")
    highlight.Parent = targetPlayer.Character
    highlight.FillColor = Color3.fromRGB(50, 150, 255)
    highlight.FillTransparency = 0.3
    highlight.OutlineColor = Color3.fromRGB(100, 200, 255)
    highlight.OutlineTransparency = 0.1
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    espObjects[targetPlayer] = highlight
end

function RemoveESP(targetPlayer)
    if espObjects[targetPlayer] then
        espObjects[targetPlayer]:Destroy()
        espObjects[targetPlayer] = nil
    end
end

function UpdateESP()
    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if targetPlayer ~= LocalPlayer then
            if ESPEnabled and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                CreateESP(targetPlayer)
            else
                RemoveESP(targetPlayer)
            end
        end
    end
end

function ClearESP()
    for _, obj in pairs(espObjects) do
        obj:Destroy()
    end
    espObjects = {}
end

-- === BIG HEAD ===
function CreateBigHead(targetPlayer)
    if bigHeadObjects[targetPlayer] then
        bigHeadObjects[targetPlayer]:Destroy()
        bigHeadObjects[targetPlayer] = nil
    end
    if not targetPlayer.Character then return end
    local head = targetPlayer.Character:FindFirstChild("Head")
    if not head then return end
    if not head:GetAttribute("OriginalSize") then
        head:SetAttribute("OriginalSize", head.Size)
    end
    head.Size = head.Size * 2
    bigHeadObjects[targetPlayer] = head
end

function RemoveBigHead(targetPlayer)
    if bigHeadObjects[targetPlayer] then
        local head = bigHeadObjects[targetPlayer]
        local originalSize = head:GetAttribute("OriginalSize")
        if originalSize then
            head.Size = originalSize
        end
        head:SetAttribute("OriginalSize", nil)
        bigHeadObjects[targetPlayer] = nil
    end
end

function UpdateBigHead()
    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if targetPlayer ~= LocalPlayer then
            if BigHeadEnabled and targetPlayer.Character then
                local head = targetPlayer.Character:FindFirstChild("Head")
                if head and not bigHeadObjects[targetPlayer] then
                    CreateBigHead(targetPlayer)
                end
            else
                RemoveBigHead(targetPlayer)
            end
        end
    end
end

function ClearBigHead()
    for _, head in pairs(bigHeadObjects) do
        local originalSize = head:GetAttribute("OriginalSize")
        if originalSize then
            head.Size = originalSize
        end
        head:SetAttribute("OriginalSize", nil)
    end
    bigHeadObjects = {}
end

-- === ПОСТОЯННОЕ ОБНОВЛЕНИЕ ДЛЯ ESP и BIG HEAD ===
RunService.Heartbeat:Connect(function()
    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if targetPlayer ~= LocalPlayer then
            if ESPEnabled and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                CreateESP(targetPlayer)
            else
                RemoveESP(targetPlayer)
            end
        end
    end
    
    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if targetPlayer ~= LocalPlayer then
            if BigHeadEnabled and targetPlayer.Character then
                local head = targetPlayer.Character:FindFirstChild("Head")
                if head and not bigHeadObjects[targetPlayer] then
                    CreateBigHead(targetPlayer)
                end
            else
                RemoveBigHead(targetPlayer)
            end
        end
    end
end)

-- === СОБЫТИЯ ИГРОКОВ ===
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        UpdateESP()
        UpdateBigHead()
        if MoveBeforeTimeEnabled then
            local char = player.Character
            if char then
                local humanoid = char:FindFirstChild("Humanoid")
                if humanoid then
                    if originalWalkSpeed == nil then
                        originalWalkSpeed = humanoid.WalkSpeed
                    end
                    humanoid.WalkSpeed = 16
                end
            end
        end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    RemoveESP(player)
    RemoveBigHead(player)
end)

UpdateESP()
UpdateBigHead()

-- === КНОПКА ОТКРЫТИЯ МЕНЮ ===
local OpenBtn = Instance.new("TextButton")
OpenBtn.Parent = ScreenGui
OpenBtn.Size = UDim2.new(0, 50, 0, 30)
OpenBtn.Position = UDim2.new(0, 10, 0, 10)
OpenBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
OpenBtn.BackgroundTransparency = 0
OpenBtn.BorderSizePixel = 0
OpenBtn.Text = "≡"
OpenBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
OpenBtn.TextSize = 22
OpenBtn.Font = Enum.Font.GothamBold

local OpenCorner = Instance.new("UICorner")
OpenCorner.Parent = OpenBtn
OpenCorner.CornerRadius = UDim.new(0, 30)

OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- === WATERMARK ===
local Watermark = Instance.new("TextLabel")
Watermark.Parent = ScreenGui
Watermark.Size = UDim2.new(0, 200, 0, 30)
Watermark.Position = UDim2.new(0, 10, 1, -40)
Watermark.BackgroundTransparency = 1
Watermark.Text = "Zertyx v5.0 | BloxStrike"
Watermark.TextColor3 = Color3.fromRGB(150, 150, 150)
Watermark.TextSize = 13
Watermark.Font = Enum.Font.GothamBold
Watermark.TextXAlignment = Enum.TextXAlignment.Left
Watermark.TextYAlignment = Enum.TextYAlignment.Bottom

-- === FPS ===
local FPS = Instance.new("TextLabel")
FPS.Parent = ScreenGui
FPS.Size = UDim2.new(0, 60, 0, 30)
FPS.Position = UDim2.new(1, -70, 1, -40)
FPS.BackgroundTransparency = 1
FPS.Text = "60 FPS"
FPS.TextColor3 = Color3.fromRGB(150, 150, 150)
FPS.TextSize = 13
FPS.Font = Enum.Font.GothamMedium
FPS.TextXAlignment = Enum.TextXAlignment.Right
FPS.TextYAlignment = Enum.TextYAlignment.Bottom

local fc = 0
local ft = tick()
RunService.RenderStepped:Connect(function()
    fc = fc + 1
    if tick() - ft >= 1 then
        FPS.Text = fc .. " FPS"
        fc = 0
        ft = tick()
    end
end)

_G.Zertyx = {
    ToggleMenu = function() MainFrame.Visible = not MainFrame.Visible end
}

print("ZERTYX v5.0 LOADED!")
print("Press ≡ to open menu")
print("ESP: ON | Big Head: OFF | Third Person: OFF | FOV: OFF | Move before time: OFF")
