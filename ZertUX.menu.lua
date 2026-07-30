-- Локальный скрипт для создания меню "Zenyx" в игре Bloxstrike
-- Разместите этот скрипт в StarterGui или StarterPlayerScripts

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Создаём основной ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ZenyxMenu"
screenGui.Parent = playerGui

-- === Главный фрейм (MainFrame) ===
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 480, 0, 310)          -- размеры 480x310
mainFrame.Position = UDim2.new(0.5, -240, 0.5, -155) -- центрирование
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)        -- привязка к центру
mainFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 24) -- тёмно-серый матовый
mainFrame.BackgroundTransparency = 0
mainFrame.ClipsDescendants = true                    -- обязательное свойство
mainFrame.Parent = screenGui

-- Скругление углов (все 4 угла получают радиус 8px)
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- === Верхняя панель (TopBar) – отдельный фрейм для сохранения острых верхних углов ===
-- Располагается строго поверх MainFrame, перекрывая его скруглённые верхние углы
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(0, 480, 0, 25)               -- ширина как у MainFrame, высота 25px
topBar.Position = UDim2.new(0.5, -480, 0.5, -310)    -- позиция верхнего левого угла MainFrame
topBar.BackgroundColor3 = Color3.fromRGB(32, 32, 32) -- цвет панели
topBar.BackgroundTransparency = 0
topBar.ZIndex = 2                                    -- поверх MainFrame
topBar.Parent = screenGui

-- === Заголовок "Zenyx" внутри TopBar ===
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 1, 0)              -- растянуть на всю панель
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1                -- прозрачный фон
titleLabel.Text = "Zenyx"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- белый текст
titleLabel.TextScaled = true                         -- автоматический размер шрифта
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Center
titleLabel.TextYAlignment = Enum.TextYAlignment.Center
titleLabel.Parent = topBar

-- Примечание: TopBar не является дочерним MainFrame, поэтому он не обрезается скруглением.
-- Благодаря этому верхние углы панели остаются строго прямыми, а нижние углы MainFrame
-- сохраняют скругление, что полностью соответствует требованиям.
