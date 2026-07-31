-- =====================================================
--  Snap Aim (Auto-Aim) для BloxStrike
--  При удержании клавиши Q камера мгновенно
--  переключается на голову ближайшего врага.
-- =====================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer

-- ========== НАСТРОЙКИ ==========
local AIM_KEY = Enum.KeyCode.Q       -- клавиша для активации (можно заменить)
local MAX_DISTANCE = 200             -- максимальная дистанция поиска
-- =================================

local isKeyDown = false

-- Функция проверки, является ли игрок врагом
local function isEnemy(player)
    if player == LocalPlayer then return false end
    if player.Character == nil then return false end
    local humanoid = player.Character:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return false end

    -- Проверка команды (Team)
    if player.Team and LocalPlayer.Team then
        return player.Team ~= LocalPlayer.Team
    end
    -- Если нет Team, проверяем TeamColor
    if player.TeamColor and LocalPlayer.TeamColor then
        return player.TeamColor ~= LocalPlayer.TeamColor
    end
    -- Если команды не заданы, считаем всех врагами (можно настроить)
    return true
end

-- Поиск ближайшего врага
local function getClosestEnemy()
    local character = LocalPlayer.Character
    if not character then return nil end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end

    local closest = nil
    local closestDist = math.huge
    local origin = root.Position

    for _, player in pairs(Players:GetPlayers()) do
        if isEnemy(player) then
            local head = player.Character:FindFirstChild("Head")
            if head then
                local dist = (head.Position - origin).Magnitude
                if dist < closestDist and dist <= MAX_DISTANCE then
                    closestDist = dist
                    closest = head
                end
            end
        end
    end
    return closest
end

-- Обработчики нажатия/отпускания клавиши
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == AIM_KEY then
        isKeyDown = true
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == AIM_KEY then
        isKeyDown = false
    end
end)

-- Основной цикл (каждый кадр)
RunService.RenderStepped:Connect(function()
    if not isKeyDown then return end
    if not LocalPlayer.Character then return end

    local targetHead = getClosestEnemy()
    if not targetHead then return end

    -- Мгновенный перенос камеры на цель
    local cameraPos = Camera.CFrame.Position
    Camera.CFrame = CFrame.new(cameraPos, targetHead.Position)
end)

print("✅ Snap Aim загружен! Зажми Q для наведения.")
