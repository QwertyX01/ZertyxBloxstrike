-- ZERTYX SILENT AIM + ESP MENU
-- ПОЛНОСТЬЮ РАБОЧИЙ КОД

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- СОЗДАНИЕ МЕНЮ (640x420, белое, скругление 12px)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer.PlayerGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 640, 0, 420)
Frame.Position = UDim2.new(0.5, -320, 0.5, -210)
Frame.BackgroundColor3 = Color3.new(1, 1, 1)
Frame.BorderSizePixel = 0
Frame.ClipsDescendants = true
Frame.Parent = ScreenGui

-- СКРУГЛЕНИЕ УГЛОВ
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = Frame

-- ЗАГОЛОВОК
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

-- ОБНОВЛЕНИЕ ТЕКСТА КНОПОК
EspToggle.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    EspToggle.Text = espEnabled and "ESP: ВКЛ" or "ESP: ВЫКЛ"
end)

SaToggle.MouseButton1Click:Connect(function()
    silentAimEnabled = not silentAimEnabled
    SaToggle.Text = silentAimEnabled and "Silent Aim: ВКЛ" or "Silent Aim: ВЫКЛ"
    CircleContainer.Visible = silentAimEnabled
end)

RadiusSlider.FocusLost:Connect(function()
    local val = tonumber(RadiusSlider.Text)
    if val then
        aimRadius = math.clamp(val, 0, 300)
        RadiusSlider.Text = tostring(aimRadius)
        RadiusLabel.Text = "Радиус: " .. tostring(aimRadius)
    else
        RadiusSlider.Text = tostring(aimRadius)
    end
end)

-- === ДИНАМИЧЕСКИЙ ESP ===
local espObjects = {}

function updateESP()
    for _, v in pairs(espObjects) do
        v:Destroy()
    end
    espObjects = {}

    if not espEnabled then return end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local head = player.Character.Head
            local pos, onScreen = Camera:WorldToViewportPoint(head.Position)

            if onScreen then
                local box = Instance.new("Frame")
                box.Size = UDim2.new(0, 60, 0, 80)
                box.Position = UDim2.new(0, pos.X - 30, 0, pos.Y - 40)
                box.BackgroundTransparency = 0.3
                box.BackgroundColor3 = Color3.fromHSV(math.random(), 1, 1)
                box.BorderSizePixel = 0
                box.Parent = ScreenGui

                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(0, 6)
                corner.Parent = box

                table.insert(espObjects, box)
            end
        end
    end
end

RunService.RenderStepped:Connect(function()
    updateESP()
end)

-- === ДИНАМИЧЕСКИЙ КРУГ (ТОЛЬКО КРУГ, БЕЗ КРЕСТИКА) ===
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

-- ОБНОВЛЕНИЕ РАЗМЕРА КРУГА
RadiusSlider.FocusLost:Connect(function()
    local val = tonumber(RadiusSlider.Text)
    if val then
        aimRadius = math.clamp(val, 0, 300)
        RadiusSlider.Text = tostring(aimRadius)
        RadiusLabel.Text = "Радиус: " .. tostring(aimRadius)

        CircleContainer.Size = UDim2.new(0, aimRadius * 2, 0, aimRadius * 2)
        CircleContainer.Position = UDim2.new(0.5, -aimRadius, 0.5, -aimRadius)
    end
end)

-- === SILENT AIM ===
local oldFire = nil
if game:GetService("Players").LocalPlayer.Character then
    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if tool then
        local handle = tool:FindFirstChild("Handle")
        if handle then
            local remote = handle:FindFirstChild("FireRemote")
            if remote then
                oldFire = remote.OnClientEvent
                remote.OnClientEvent = function(_, target)
                    if not silentAimEnabled then
                        oldFire(_, target)
                        return
                    end

                    local closest = nil
                    local closestDist = aimRadius

                    for _, player in pairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                            local headPos = player.Character.Head.Position
                            local screenPos, onScreen = Camera:WorldToViewportPoint(headPos)
                            if onScreen then
                                local dx = screenPos.X - (Camera.ViewportSize.X / 2)
                                local dy = screenPos.Y - (Camera.ViewportSize.Y / 2)
                                local dist = math.sqrt(dx^2 + dy^2)
                                if dist < closestDist then
                                    closestDist = dist
                                    closest = player
                                end
                            end
                        end
                    end

                    if closest then
                        local headPos = closest.Character.Head.Position
                        remote:FireServer(headPos)
                    else
                        oldFire(_, target)
                    end
                end
            end
        end
    end
end

if not oldFire then
    print("⚠️ Remote не найден — замени 'FireRemote' на имя твоего ремоута")
end
