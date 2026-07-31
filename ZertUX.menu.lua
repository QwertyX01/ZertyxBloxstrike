-- Сервисы Roblox
local TweenService = game:Service("TweenService")

-- Главный контейнер GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZerrtyxMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = script.Parent

-- Главная панель (640x420)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 640, 0, 420)
MainFrame.Position = UDim2.new(0.5, -320, 0.5, -210) -- Центр экрана
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25) -- Темный современный фон
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Меню можно перетаскивать по экрану
MainFrame.Parent = ScreenGui

-- Мягкие углы для главной панели
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10) -- Скругление 10px
MainCorner.Parent = MainFrame

-- Хедер (Верхняя панель)
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundTransparency = 1
Header.Parent = MainFrame

-- Название Zerrtyx в хедере
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Zerrtyx"
Title.TextColor3 = Color3.fromRGB(240, 240, 240)
Title.TextSize = 22
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Серая разделяющая полоска под хедером
local Divider = Instance.new("Frame")
Divider.Name = "Divider"
Divider.Size = UDim2.new(1, 0, 0, 1)
Divider.Position = UDim2.new(0, 0, 1, 0)
Divider.BackgroundColor3 = Color3.fromRGB(60, 60, 60) -- Серый цвет полоски
Divider.BorderSizePixel = 0
Divider.Parent = Header

-- Боковая панель для красивых вкладок
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 160, 1, -51)
Sidebar.Position = UDim2.new(0, 0, 0, 51)
Sidebar.BackgroundTransparency = 1
Sidebar.Parent = MainFrame

-- UI List для автоматического выравнивания кнопок
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
UIListLayout.Parent = Sidebar

-- Контейнер для отображения контента вкладок
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -170, 1, -61)
ContentFrame.Position = UDim2.new(0, 165, 0, 56)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Таблицы для хранения страниц и кнопок
local tabs = {"Aim", "Visuals", "Skins"}
local pages = {}
local buttons = {}

-- Функция для создания красивой кнопки вкладки
local function createTabButton(name)
	local btn = Instance.new("TextButton")
	btn.Name = name .. "Tab"
	btn.Size = UDim2.new(0, 140, 0, 36)
	btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	btn.Text = name
	btn.TextColor3 = Color3.fromRGB(150, 150, 150)
	btn.TextSize = 14
	btn.Font = Enum.Font.GothamSemibold
	btn.BorderSizePixel = 0
	btn.AutoButtonColor = false
	btn.Parent = Sidebar

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = btn
	
	-- Логика подсветки при наведении
	btn.MouseEnter:Connect(function()
		if btn.TextColor3 ~= Color3.fromRGB(255, 255, 255) then
			TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
		end
	end)
	btn.MouseLeave:Connect(function()
		if btn.TextColor3 ~= Color3.fromRGB(255, 255, 255) then
			TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
		end
	end)
	
	return btn
end

-- Функция для создания внутренней страницы под вкладку
local function createPage(name)
	local page = Instance.new("Frame")
	page.Name = name .. "Page"
	page.Size = UDim2.new(1, 0, 1, 0)
	page.BackgroundTransparency = 1
	page.Visible = false
	page.Parent = ContentFrame
	
	-- Заголовок внутри страницы (временная заглушка)
	local placeholder = Instance.new("TextLabel")
	placeholder.Size = UDim2.new(1, 0, 0, 30)
	placeholder.BackgroundTransparency = 1
	placeholder.Text = name .. " Settings"
	placeholder.TextColor3 = Color3.fromRGB(100, 100, 100)
	placeholder.TextSize = 16
	placeholder.Font = Enum.Font.Gotham
	placeholder.TextXAlignment = Enum.TextXAlignment.Left
	placeholder.Parent = page
	
	return page
end

-- Инициализация вкладок и страниц
for _, tabName in ipairs(tabs) do
	buttons[tabName] = createTabButton(tabName)
	pages[tabName] = createPage(tabName)
end

-- Логика переключения между вкладками
local function switchTab(activeTabName)
	for name, btn in pairs(buttons) do
		if name == activeTabName then
			-- Активная вкладка (яркая)
			TweenService:Create(btn, TweenInfo.new(0.2), {
				BackgroundColor3 = Color3.fromRGB(60, 120, 240), -- Красивый синий акцент
				TextColor3 = Color3.fromRGB(255, 255, 255)
			}):Play()
			pages[name].Visible = true
		else
			-- Неактивные вкладки (темные)
			TweenService:Create(btn, TweenInfo.new(0.2), {
				BackgroundColor3 = Color3.fromRGB(35, 35, 35),
				TextColor3 = Color3.fromRGB(150, 150, 150)
			}):Play()
			pages[name].Visible = false
		end
	end
end

-- Подключаем клики к кнопкам
for name, btn in pairs(buttons) do
	btn.MouseButton1Click:Connect(function()
		switchTab(name)
	end)
end

-- Открываем первую вкладку по умолчанию
switchTab("Aim")
