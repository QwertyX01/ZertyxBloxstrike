-- Создание GUI в памяти игры
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Проверка на повторный запуск (удаляет старое меню, чтобы не плодились копии)
if CoreGui:FindFirstChild("ZertyxMenu") then
	CoreGui.ZertyxMenu:Destroy()
end

-- Основной контейнер экрана
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZertyxMenu"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Главное окно меню (640х420)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 640, 0, 420)
MainFrame.Position = UDim2.new(0.5, -320, 0.5, -210) -- Центр экрана
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Темный фон
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Меню можно перетаскивать мышкой
MainFrame.Parent = ScreenGui

-- Мягкие углы для главного окна
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10) -- Скругление 10 пикселей
MainCorner.Parent = MainFrame

-- Хедер (Верхняя панель)
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 45) -- Высота хедера 45px
Header.Position = UDim2.new(0, 0, 0, 0)
Header.BackgroundColor3 = Color3.fromRGB(45, 45, 45) -- Серый цвет выделения
Header.BorderSizePixel = 0
Header.Parent = MainFrame

-- Мягкие углы для хедера (чтобы не вылезали за верхний край главного окна)
local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 10)
HeaderCorner.Parent = Header

-- Скрытие нижних углов хедера, чтобы они были прямыми стык-в-стык с фоном
local HeaderPatch = Instance.new("Frame")
HeaderPatch.Size = UDim2.new(1, 0, 0, 10)
HeaderPatch.Position = UDim2.new(0, 0, 1, -10)
HeaderPatch.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
HeaderPatch.BorderSizePixel = 0
HeaderPatch.Parent = Header

-- Название чита в хедере
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Zertyx"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Контейнер для функций (Контентная часть)
local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -40, 1, -75)
ContentContainer.Position = UDim2.new(0, 20, 0, 60)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

----------------------------------------------------
-- ЛОГИКА ФУНКЦИЙ И КНОПОК
----------------------------------------------------

local aimbotEnabled = false
local AIM_KEY = Enum.KeyCode.E 
local TARGET_PART = "Head"     

-- Кнопка переключения Аимбота
local AimButton = Instance.new("TextButton")
AimButton.Name = "AimButton"
AimButton.Size = UDim2.new(0, 200, 0, 40)
AimButton.Position = UDim2.new(0, 0, 0, 0)
AimButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
AimButton.Text = "Auto Aim: OFF"
AimButton.TextColor3 = Color3.fromRGB(255, 100, 100)
AimButton.TextSize = 16
AimButton.Font = Enum.Font.GothamSemibold
AimButton.Parent = ContentContainer

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 6)
ButtonCorner.Parent = AimButton

-- Переключение состояния по клику
AimButton.MouseButton1Click:Connect(function()
	aimbotEnabled = not aimbotEnabled
	if aimbotEnabled then
		AimButton.Text = "Auto Aim: ON"
		AimButton.BackgroundColor3 = Color3.fromRGB(40, 100, 40)
		AimButton.TextColor3 = Color3.fromRGB(100, 255, 100)
	else
		AimButton.Text = "Auto Aim: OFF"
		AimButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		AimButton.TextColor3 = Color3.fromRGB(255, 100, 100)
	end
end)

-- Функция поиска цели
local function getClosestEnemy()
	local closestTarget = nil
	local maxDistance = math.huge
	local localCharacter = LocalPlayer.Character
	if not localCharacter or not localCharacter:FindFirstChild("HumanoidRootPart") then return nil end
	local localRoot = localCharacter.HumanoidRootPart

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Team ~= LocalPlayer.Team then
			local character = player.Character
			if character and character:FindFirstChild(TARGET_PART) and character:FindFirstChild("Humanoid") then
				if character.Humanoid.Health > 0 then
					local distance = (character[TARGET_PART].Position - localRoot.Position).Magnitude
					if distance < maxDistance then
						maxDistance = distance
						closestTarget = character[TARGET_PART]
					end
				end
			end
		end
	end
	return closestTarget
end

-- Логика удержания клавиши аима
local isKeyHeld = false
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == AIM_KEY then isKeyHeld = true end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.KeyCode == AIM_KEY then isKeyHeld = false end
end)

-- Главный цикл аима
RunService.RenderStepped:Connect(function()
	if aimbotEnabled and isKeyHeld then
		local target = getClosestEnemy()
		if target then
			Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
		end
	end
end)

-- Свернуть/развернуть меню на клавишу Insert
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == Enum.KeyCode.Insert then
		MainFrame.Visible = not MainFrame.Visible
	end
end)
