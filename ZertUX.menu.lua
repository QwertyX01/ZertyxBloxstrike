-- Zertyx CHEAT v4.8 - THIRD PERSON + FOV
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- НАСТРОЙКИ
local ESPEnabled = true
local BigHeadEnabled = false
local ThirdPersonEnabled = false
local FOVEnabled = false
local ZoomDistance = 10
local FOVValue = 120
local espObjects = {}
local bigHeadObjects = {}
local originalCameraOffset = nil
local originalFOV = nil

-- === ГЛАВНОЕ МЕНЮ ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.Name = "Zertyx"
ScreenGui.ResetOnSpawn = false

-- === МЕНЮ ===
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 640, 0, 420)
MainFrame.Position = UDim2.new(0.5, -320, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 20, 40)
MainFrame.BackgroundTransparency = 0
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Visible = false

local MainCorner = Instance.new("UICorner")
MainCorner.Parent = MainFrame
MainCorner.CornerRadius = UDim.new(0, 12)

-- ХЕДЕР
local Header = Instance.new("Frame")
Header.Parent = MainFrame
Header.Size = UDim2.new(1, 0, 0, 40)
Header.Position = UDim2.new(0, 0, 0, 0)
Header.BackgroundColor3 = Color3.fromRGB(60, 30, 80)
Header.BackgroundTransparency = 0
Header.BorderSizePixel = 0

local Title = Instance.new("TextLabel")
Title.Parent = Header
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "ZERTYX CHEAT"
Title.TextColor3 = Color3.fromRGB(220, 150, 255)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Center
Title.TextYAlignment = Enum.TextYAlignment.Center

-- ВКЛАДКИ
local TabContainer = Instance.new("Frame")
TabContainer.Parent = MainFrame
TabContainer.Size = UDim2.new(1, 0, 0, 35)
TabContainer.Position = UDim2.new(0, 0, 0, 40)
TabContainer.BackgroundColor3 = Color3.fromRGB(40, 20, 55)
TabContainer.BackgroundTransparency = 0
TabContainer.BorderSizePixel = 0

local tabs = {"Visuals", "Aim", "Misc"}
local tabBtns = {}
local tabContents = {}

for i = 1, 3 do
    local btn = Instance.new("TextButton")
    btn.Parent = TabContainer
    btn.Size = UDim2.new(0, 80, 0, 28)
    btn.Position = UDim2.new(0, 15 + (i-1) * 90, 0.5, -14)
    btn.BackgroundColor3 = Color3.fromRGB(50, 30, 65)
    btn.BackgroundTransparency = 0
    btn.BorderSizePixel = 0
    btn.Text = string.upper(tabs[i])
    btn.TextColor3 = Color3.fromRGB(200, 180, 220)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamMedium
    btn.AutoButtonColor = false
    
    local corner = Instance.new("UICorner")
    corner.Parent = btn
    corner.CornerRadius = UDim.new(0, 15)
    
    local content = Instance.new("Frame")
    content.Parent = MainFrame
    content.Size = UDim2.new(1, 0, 1, -90)
    content.Position = UDim2.new(0, 0, 0, 75)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.Visible = (i == 1)
    content.Name = tabs[i] .. "Content"
    
    tabBtns[tabs[i]] = btn
    tabContents[tabs[i]] = content
    
    btn.MouseButton1Click:Connect(function()
        for _, b in pairs(tabBtns) do
            b.BackgroundColor3 = Color3.fromRGB(50, 30, 65)
            b.TextColor3 = Color3.fromRGB(200, 180, 220)
        end
        for _, c in pairs(tabContents) do
            c.Visible = false
        end
        btn.BackgroundColor3 = Color3.fromRGB(80, 50, 100)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        content.Visible = true
    end)
end

-- VISUALS TAB
local visualsContent = tabContents["Visuals"]
local yPos = 10

-- ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ
local function CreateToggleRow(parent, label, defaultState, callback, yPos)
    local row = Instance.new("Frame")
    row.Parent = parent
    row.Size = UDim2.new(1, -20, 0, 40)
    row.Position = UDim2.new(0, 10, 0, yPos)
    row.BackgroundColor3 = Color3.fromRGB(50, 30, 65)
    row.BackgroundTransparency = 0.5
    row.BorderSizePixel = 0
    
    local rowCorner = Instance.new("UICorner")
    rowCorner.Parent = row
    rowCorner.CornerRadius = UDim.new(0, 8)
    
    local labelText = Instance.new("TextLabel")
    labelText.Parent = row
    labelText.Size = UDim2.new(0, 140, 1, 0)
    labelText.Position = UDim2.new(0, 12, 0, 0)
    labelText.BackgroundTransparency = 1
    labelText.Text = label
    labelText.TextColor3 = Color3.fromRGB(220, 200, 240)
    labelText.TextSize = 14
    labelText.Font = Enum.Font.GothamMedium
    labelText.TextXAlignment = Enum.TextXAlignment.Left
    labelText.TextYAlignment = Enum.TextYAlignment.Center
    
    local toggle = Instance.new("TextButton")
    toggle.Parent = row
    toggle.Size = UDim2.new(0, 30, 0, 30)
    toggle.Position = UDim2.new(1, -40, 0.5, -15)
    toggle.BackgroundColor3 = defaultState and Color3.fromRGB(100, 150, 255) or Color3.fromRGB(60, 40, 75)
    toggle.BackgroundTransparency = 0
    toggle.BorderSizePixel = 0
    toggle.Text = defaultState and "✓" or ""
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.TextSize = 18
    toggle.Font = Enum.Font.GothamBold
    toggle.AutoButtonColor = false
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.Parent = toggle
    toggleCorner.CornerRadius = UDim.new(0, 4)
    
    local state = defaultState
    toggle.MouseButton1Click:Connect(function()
        state = not state
        toggle.Text = state and "✓" or ""
        toggle.BackgroundColor3 = state and Color3.fromRGB(100, 150, 255) or Color3.fromRGB(60, 40, 75)
        if callback then callback(state) end
    end)
    
    return row, toggle
end

-- ФУНКЦИЯ СОЗДАНИЯ СЛАЙДЕРА
local function CreateSlider(parent, label, minVal, maxVal, defaultVal, callback, yPos)
    local row = Instance.new("Frame")
    row.Parent = parent
    row.Size = UDim2.new(1, -20, 0, 40)
    row.Position = UDim2.new(0, 10, 0, yPos)
    row.BackgroundColor3 = Color3.fromRGB(50, 30, 65)
    row.BackgroundTransparency = 0.5
    row.BorderSizePixel = 0
    
    local rowCorner = Instance.new("UICorner")
    rowCorner.Parent = row
    rowCorner.CornerRadius = UDim.new(0, 8)
    
    local labelText = Instance.new("TextLabel")
    labelText.Parent = row
    labelText.Size = UDim2.new(0, 100, 1, 0)
    labelText.Position = UDim2.new(0, 12, 0, 0)
    labelText.BackgroundTransparency = 1
    labelText.Text = label
    labelText.TextColor3 = Color3.fromRGB(220, 200, 240)
    labelText.TextSize = 14
    labelText.Font = Enum.Font.GothamMedium
    labelText.TextXAlignment = Enum.TextXAlignment.Left
    labelText.TextYAlignment = Enum.TextYAlignment.Center
    
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Parent = row
    sliderFrame.Size = UDim2.new(0, 120, 0, 6)
    sliderFrame.Position = UDim2.new(0, 120, 0.5, -3)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(60, 50, 70)
    sliderFrame.BorderSizePixel = 0
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.Parent = sliderFrame
    sliderCorner.CornerRadius = UDim.new(0, 10)
    
    local fill = Instance.new("Frame")
    fill.Parent = sliderFrame
    fill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
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
    valueLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
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

-- === СОЗДАНИЕ ЭЛЕМЕНТОВ ===
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

-- Third Person
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

-- FOV
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

-- AIM TAB
local aimContent = tabContents["Aim"]
local aimLabel = Instance.new("TextLabel")
aimLabel.Parent = aimContent
aimLabel.Size = UDim2.new(1, 0, 1, 0)
aimLabel.Position = UDim2.new(0, 0, 0, 0)
aimLabel.BackgroundTransparency = 1
aimLabel.Text = "AIM TAB"
aimLabel.TextColor3 = Color3.fromRGB(180, 150, 200)
aimLabel.TextSize = 24
aimLabel.Font = Enum.Font.GothamBold
aimLabel.TextXAlignment = Enum.TextXAlignment.Center
aimLabel.TextYAlignment = Enum.TextYAlignment.Center

-- MISC TAB
local miscContent = tabContents["Misc"]
local miscLabel = Instance.new("TextLabel")
miscLabel.Parent = miscContent
miscLabel.Size = UDim2.new(1, 0, 1, 0)
miscLabel.Position = UDim2.new(0, 0, 0, 0)
miscLabel.BackgroundTransparency = 1
miscLabel.Text = "MISC TAB"
miscLabel.TextColor3 = Color3.fromRGB(180, 150, 200)
miscLabel.TextSize = 24
miscLabel.Font = Enum.Font.GothamBold
miscLabel.TextXAlignment = Enum.TextXAlignment.Center
miscLabel.TextYAlignment = Enum.TextYAlignment.Center

-- === ПРИНУДИТЕЛЬНОЕ ОБНОВЛЕНИЕ КАЖДЫЙ КАДР ===
RunService.RenderStepped:Connect(function()
    -- Third Person
    if ThirdPersonEnabled then
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.CameraOffset = Vector3.new(0, 2, -ZoomDistance)
            end
        end
    end
    
    -- FOV
    if FOVEnabled then
        Camera.FieldOfView = FOVValue
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

-- === ПОСТОЯННОЕ ОБНОВЛЕНИЕ ДЛЯ ESP И BIG HEAD ===
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

-- === СОБЫТИЯ ===
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        UpdateESP()
        UpdateBigHead()
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
OpenBtn.BackgroundColor3 = Color3.fromRGB(60, 30, 80)
OpenBtn.BackgroundTransparency = 0
OpenBtn.BorderSizePixel = 0
OpenBtn.Text = "≡"
OpenBtn.TextColor3 = Color3.fromRGB(220, 150, 255)
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
Watermark.Text = "Zertyx v4.8 | BloxStrike"
Watermark.TextColor3 = Color3.fromRGB(180, 150, 200)
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
FPS.TextColor3 = Color3.fromRGB(180, 150, 200)
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

print("ZERTYX v4.8 LOADED!")
print("Press ≡ to open menu")
print("ESP: ON | Big Head: OFF | Third Person: OFF | FOV: OFF")
