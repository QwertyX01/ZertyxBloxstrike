-- =====================================================
--  Zertyx Menu (со звуком по твоей ссылке)
-- =====================================================

local player = game:GetService("Players").LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "Zertyx"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")

-- ============================================================
--  ЗВУК (твоя ссылка на MP3)
-- ============================================================
local clickSound = Instance.new("Sound")
clickSound.SoundId = "https://www.image2url.com/r2/default/audio/1785482101020-da6f6692-cbe3-48a5-8c38-900a5f825d88.mp3"
clickSound.Volume = 0.5
clickSound.Parent = SoundService

local function playClickSound()
    clickSound:Play()
end

-- ============================================================
--  ОСНОВНОЕ МЕНЮ
-- ============================================================
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 640, 0, 420)
mainFrame.Position = UDim2.new(0.5, -320, 0.5, -210)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BackgroundTransparency = 0
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 6)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(60, 60, 60)
mainStroke.Thickness = 1
mainStroke.Transparency = 0.5
mainStroke.Parent = mainFrame

-- ============================================================
--  ХЕДЕР
-- ============================================================
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 35)
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
header.BackgroundTransparency = 0
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 6)
headerCorner.Parent = header

local headerStroke = Instance.new("UIStroke")
headerStroke.Color = Color3.fromRGB(60, 60, 60)
headerStroke.Thickness = 1
headerStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
headerStroke.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.5, 0, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Zertyx"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 20
title.Font = Enum.Font.GothamMedium
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextYAlignment = Enum.TextYAlignment.Center
title.Parent = header

-- ============================================================
--  КОНТЕНТ
-- ============================================================
local contentContainer = Instance.new("Frame")
contentContainer.Name = "ContentContainer"
contentContainer.Size = UDim2.new(1, 0, 1, -70)
contentContainer.Position = UDim2.new(0, 0, 0, 35)
contentContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
contentContainer.BackgroundTransparency = 0
contentContainer.BorderSizePixel = 0
contentContainer.ClipsDescendants = true
contentContainer.Parent = mainFrame

local pages = {}
local pageNames = {"Aim", "Esp"}

for i, name in ipairs(pageNames) do
    local page = Instance.new("Frame")
    page.Name = name .. "Page"
    page.Size = UDim2.new(1, 0, 1, 0)
    page.Position = UDim2.new(0, 0, 0, 0)
    page.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    page.BackgroundTransparency = 0.2
    page.BorderSizePixel = 0
    page.Visible = (i == 1)
    page.Parent = contentContainer
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = page
    pages[name] = page
end

-- ============================================================
--  ВКЛАДКА AIM
-- ============================================================
local aimPage = pages["Aim"]
local aimEnabled = false
local currentTarget = nil
local DETACH_ANGLE = 30

local divider = Instance.new("Frame")
divider.Size = UDim2.new(0, 2, 1, 0)
divider.Position = UDim2.new(0.5, -1, 0, 0)
divider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
divider.BackgroundTransparency = 0.4
divider.BorderSizePixel = 0
divider.Parent = aimPage

local leftHalf = Instance.new("Frame")
leftHalf.Size = UDim2.new(0.5, -5, 1, 0)
leftHalf.Position = UDim2.new(0, 5, 0, 0)
leftHalf.BackgroundTransparency = 1
leftHalf.Parent = aimPage

local row = Instance.new("Frame")
row.Size = UDim2.new(1, 0, 0, 40)
row.Position = UDim2.new(0, 0, 0.1, 0)
row.BackgroundTransparency = 1
row.Parent = leftHalf

local label = Instance.new("TextLabel")
label.Size = UDim2.new(0.6, 0, 1, 0)
label.Position = UDim2.new(0, 10, 0, 0)
label.BackgroundTransparency = 1
label.Text = "Auto Aim"
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.TextSize = 18
label.Font = Enum.Font.GothamBold
label.TextXAlignment = Enum.TextXAlignment.Left
label.TextYAlignment = Enum.TextYAlignment.Center
label.Parent = row

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 80, 0, 32)
toggleBtn.Position = UDim2.new(0.75, 0, 0.5, -16)
toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
toggleBtn.BackgroundTransparency = 0.2
toggleBtn.BorderSizePixel = 0
toggleBtn.Text = "OFF"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextSize = 16
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.Parent = row
local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 6)
btnCorner.Parent = toggleBtn

local function updateToggle(state)
    aimEnabled = state
    if state then
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        toggleBtn.Text = "ON"
    else
        toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        toggleBtn.Text = "OFF"
        currentTarget = nil
    end
    print("Auto Aim:", state and "ON" or "OFF")
end

toggleBtn.MouseButton1Click:Connect(function()
    updateToggle(not aimEnabled)
end)
updateToggle(false)

-- Правая половина
local rightHalf = Instance.new("Frame")
rightHalf.Size = UDim2.new(0.5, -5, 1, 0)
rightHalf.Position = UDim2.new(0.5, 5, 0, 0)
rightHalf.BackgroundTransparency = 1
rightHalf.Parent = aimPage

local rightLabel = Instance.new("TextLabel")
rightLabel.Size = UDim2.new(1, 0, 1, 0)
rightLabel.BackgroundTransparency = 1
rightLabel.Text = "настройки\n(скоро)"
rightLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
rightLabel.TextSize = 20
rightLabel.Font = Enum.Font.GothamMedium
rightLabel.TextXAlignment = Enum.TextXAlignment.Center
rightLabel.TextYAlignment = Enum.TextYAlignment.Center
rightLabel.Parent = rightHalf

-- ============================================================
--  ЛОГИКА AUTO AIM
-- ============================================================
local function isEnemy(plr)
    if plr == player then return false end
    if plr.Team and player.Team then
        return plr.Team ~= player.Team
    end
    if plr.TeamColor and player.TeamColor then
        return plr.TeamColor ~= player.TeamColor
    end
    return true
end

local function getClosestEnemy()
    local character = player.Character
    if not character then return nil end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    local closest = nil
    local closestDist = math.huge

    for _, plr in pairs(Players:GetPlayers()) do
        if isEnemy(plr) and plr.Character then
            local head = plr.Character:FindFirstChild("Head")
            local humanoid = plr.Character:FindFirstChild("Humanoid")
            if head and humanoid and humanoid.Health > 0 then
                local dist = (hrp.Position - head.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    closest = head
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if not aimEnabled then return end

    local character = player.Character
    if not character then return end
    local camPos = Camera.CFrame.Position

    if currentTarget and currentTarget.Parent and currentTarget.Parent:FindFirstChild("Humanoid") and currentTarget.Parent.Humanoid.Health > 0 then
        -- цель жива
    else
        currentTarget = getClosestEnemy()
        if not currentTarget then return end
        print("Новая цель:", currentTarget.Parent.Name)
    end

    local targetPos = currentTarget.Position
    local dirToTarget = (targetPos - camPos).Unit
    local lookVec = Camera.CFrame.LookVector
    local angle = math.deg(math.acos(dirToTarget:Dot(lookVec)))
    if angle > DETACH_ANGLE then
        print("Отвернулись, сброс цели")
        currentTarget = nil
        return
    end

    Camera.CFrame = CFrame.new(camPos, targetPos)
end)

-- ============================================================
--  НИЖНИЕ ВКЛАДКИ (с анимацией и звуком)
-- ============================================================
local tabsBar = Instance.new("Frame")
tabsBar.Name = "TabsBar"
tabsBar.Size = UDim2.new(1, 0, 0, 35)
tabsBar.Position = UDim2.new(0, 0, 1, -35)
tabsBar.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
tabsBar.BackgroundTransparency = 0
tabsBar.BorderSizePixel = 0
tabsBar.ClipsDescendants = true
tabsBar.Parent = mainFrame

local topLine = Instance.new("Frame")
topLine.Size = UDim2.new(1, 0, 0, 1)
topLine.Position = UDim2.new(0, 0, 0, 0)
topLine.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
topLine.BackgroundTransparency = 0.3
topLine.BorderSizePixel = 0
topLine.Parent = tabsBar

local tabButtons = {}
local tabNames = {"Aim", "Esp"}
local tabWidth = 0.5

for i, name in ipairs(tabNames) do
    local btn = Instance.new("TextButton")
    btn.Name = name .. "Btn"
    btn.Size = UDim2.new(tabWidth, 0, 1, 0)
    btn.Position = UDim2.new((i-1) * tabWidth, 0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    btn.BackgroundTransparency = 0.2
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.TextColor3 = (i == 1) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
    btn.TextSize = 18
    btn.Font = Enum.Font.SourceSansBold
    btn.Parent = tabsBar

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(45, 45, 50)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        if btn.BackgroundColor3 ~= Color3.fromRGB(60, 60, 70) then
            TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}):Play()
        end
    end)

    tabButtons[name] = btn

    btn.MouseButton1Click:Connect(function()
        playClickSound()

        for pageName, page in pairs(pages) do
            if pageName == name then
                page.Visible = true
                TweenService:Create(page, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.1}):Play()
            else
                TweenService:Create(page, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 0.6}):Play()
                task.wait(0.1)
                page.Visible = false
            end
        end

        for n, b in pairs(tabButtons) do
            if n == name then
                TweenService:Create(b, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BackgroundColor3 = Color3.fromRGB(60, 60, 70),
                    BackgroundTransparency = 0.1,
                    TextColor3 = Color3.fromRGB(255, 255, 255)
                }):Play()
            else
                TweenService:Create(b, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BackgroundColor3 = Color3.fromRGB(35, 35, 40),
                    BackgroundTransparency = 0.2,
                    TextColor3 = Color3.fromRGB(180, 180, 180)
                }):Play()
            end
        end
    end)
end

tabButtons["Aim"].BackgroundColor3 = Color3.fromRGB(60, 60, 70)
tabButtons["Aim"].BackgroundTransparency = 0.1
tabButtons["Aim"].TextColor3 = Color3.fromRGB(255, 255, 255)

print("✅ Zertyx Menu со звуком по твоей ссылке загружен!")
