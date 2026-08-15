-- ============================================
-- HERRICRAFT HUB - СПИСОК СКРИПТОВ (ПК)
-- ============================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- ============================================
-- ЦВЕТА
-- ============================================

local COLORS = {
    Background = Color3.fromRGB(10, 10, 10),
    Dark = Color3.fromRGB(20, 20, 20),
    Border = Color3.fromRGB(255, 215, 0),
    Text = Color3.fromRGB(255, 215, 0),
    TextDark = Color3.fromRGB(150, 150, 150),
}

-- ============================================
-- ============================================
-- !!! СЮДА ДОБАВЛЯЙ СВОИ ССЫЛКИ ДЛЯ ПК !!!
-- ============================================
-- ============================================

local SCRIPTS_PC = {
    -- ===== СКРИПТ 1 =====
    {
        name = "[FPS] One Tap",
        desc = "ESP + Aimbot (оптимизированный)",
        icon = "🎯",
        url = "https://raw.githubusercontent.com/setertop92222-beep/HeriCraft_HUB/refs/heads/main/onetap.lua"
    },
    -- ===== СКРИПТ 2 =====
    {
        name = "ESP с разделами",
        desc = "ESP для игроков, ботов, монстров",
        icon = "👾",
        url = "https://raw.githubusercontent.com/setertop92222-beep/HeriCraft_HUB/refs/heads/main/esp_sections.lua"
    },
    -- ===== СКРИПТ 3 =====
    {
        name = "ESP",
        desc = "Обычный ESP",
        icon = "🎯",
        url = "https://raw.githubusercontent.com/setertop92222-beep/HeriCraft_HUB/refs/heads/main/esp.lua"
    },
    -- ===== СКРИПТ 4 =====
    {
        name = "Aimbot",
        desc = "Наведение на цель",
        icon = "🎯",
        url = "https://raw.githubusercontent.com/setertop92222-beep/HeriCraft_HUB/refs/heads/main/aimbot.lua"
    },
    -- ============================================
    -- ДОБАВЛЯЙ НОВЫЕ СКРИПТЫ СЮДА:
    -- ============================================
    -- {
    --     name = "Название скрипта",
    --     desc = "Описание",
    --     icon = "🔥",
    --     url = "https://ссылка_на_скрипт.lua"
    -- },
}

-- ============================================
-- GUI ФУНКЦИИ
-- ============================================

local function CreateFrame(parent, size, pos)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.Size = size
    frame.Position = pos
    frame.BackgroundColor3 = COLORS.Background
    frame.BackgroundTransparency = 0
    frame.BorderSizePixel = 2
    frame.BorderColor3 = COLORS.Border
    frame.Active = true
    frame.Draggable = true
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame
    return frame
end

local function CreateLabel(parent, size, pos, text, color, sizeText)
    local label = Instance.new("TextLabel")
    label.Parent = parent
    label.Size = size
    label.Position = pos
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color or COLORS.Text
    label.TextSize = sizeText or 16
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.TextYAlignment = Enum.TextYAlignment.Center
    return label
end

local function CreateButton(parent, size, pos, text, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.Size = size
    btn.Position = pos
    btn.BackgroundColor3 = COLORS.Dark
    btn.BackgroundTransparency = 0
    btn.BorderSizePixel = 2
    btn.BorderColor3 = COLORS.Border
    btn.Text = text
    btn.TextColor3 = COLORS.Text
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(40, 35, 0)
        }):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundColor3 = COLORS.Dark
        }):Play()
    end)
    
    if callback then
        btn.MouseButton1Click:Connect(callback)
    end
    return btn
end

-- ============================================
-- ЗАГРУЗЧИК СКРИПТОВ
-- ============================================

local function LoadScript(url, name)
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    if success and result then
        loadstring(result)()
        print("✅ " .. name .. " загружен!")
    else
        print("❌ Ошибка загрузки " .. name)
    end
end

-- ============================================
-- ФУНКЦИЯ ВОЗВРАТА
-- ============================================

local function ReturnToDeviceMenu()
    for _, gui in ipairs(CoreGui:GetChildren()) do
        if gui.Name == "HericraftPCList" then
            gui:Destroy()
        end
    end
    
    local url = "https://raw.githubusercontent.com/setertop92222-beep/HeriCraft_HUB/refs/heads/main/device.lua"
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    if success and result then
        loadstring(result)()
    end
end

-- ============================================
-- МЕНЮ ДЛЯ ПК
-- ============================================

local function CreatePCList()
    for _, gui in ipairs(CoreGui:GetChildren()) do
        if gui.Name == "HericraftPCList" then
            gui:Destroy()
        end
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "HericraftPCList"
    screenGui.Parent = CoreGui
    screenGui.ResetOnSpawn = false

    local mainFrame = CreateFrame(screenGui,
        UDim2.new(0, 450, 0, 400),
        UDim2.new(0.5, -225, 0.5, -200)
    )

    CreateLabel(mainFrame,
        UDim2.new(1, 0, 0, 50),
        UDim2.new(0, 0, 0, 5),
        "💻 КОМПЬЮТЕР - СКРИПТЫ",
        COLORS.Border,
        22
    )

    CreateLabel(mainFrame,
        UDim2.new(1, 0, 0, 20),
        UDim2.new(0, 0, 0, 50),
        "👇 Нажми на скрипт чтобы запустить",
        COLORS.TextDark,
        12
    )

    -- Контейнер с прокруткой
    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Parent = mainFrame
    scrollingFrame.Size = UDim2.new(1, -40, 0, 230)
    scrollingFrame.Position = UDim2.new(0, 20, 0, 80)
    scrollingFrame.BackgroundTransparency = 1
    scrollingFrame.BorderSizePixel = 0
    scrollingFrame.ScrollBarThickness = 6
    scrollingFrame.ScrollBarImageColor3 = COLORS.TextDark
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

    local container = Instance.new("Frame")
    container.Parent = scrollingFrame
    container.Size = UDim2.new(1, 0, 0, 0)
    container.BackgroundTransparency = 1

    -- ============================================
    -- СОЗДАНИЕ КНОПОК
    -- ============================================

    local function CreateScriptButton(parent, yPos, icon, name, desc, url)
        local btn = Instance.new("TextButton")
        btn.Parent = parent
        btn.Size = UDim2.new(1, 0, 0, 55)
        btn.Position = UDim2.new(0, 0, 0, yPos)
        btn.BackgroundColor3 = COLORS.Dark
        btn.BackgroundTransparency = 0
        btn.BorderSizePixel = 2
        btn.BorderColor3 = COLORS.Border
        btn.Text = ""
        btn.AutoButtonColor = false

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 10)
        btnCorner.Parent = btn

        -- Иконка
        local iconLabel = Instance.new("TextLabel")
        iconLabel.Parent = btn
        iconLabel.Size = UDim2.new(0, 40, 1, 0)
        iconLabel.Position = UDim2.new(0, 10, 0, 0)
        iconLabel.BackgroundTransparency = 1
        iconLabel.Text = icon
        iconLabel.TextColor3 = COLORS.Text
        iconLabel.TextSize = 24
        iconLabel.Font = Enum.Font.GothamBold
        iconLabel.TextXAlignment = Enum.TextXAlignment.Center

        -- Название
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Parent = btn
        nameLabel.Size = UDim2.new(1, -60, 0, 22)
        nameLabel.Position = UDim2.new(0, 55, 0, 5)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = name
        nameLabel.TextColor3 = COLORS.Text
        nameLabel.TextSize = 16
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left

        -- Описание
        local descLabel = Instance.new("TextLabel")
        descLabel.Parent = btn
        descLabel.Size = UDim2.new(1, -60, 0, 18)
        descLabel.Position = UDim2.new(0, 55, 0, 28)
        descLabel.BackgroundTransparency = 1
        descLabel.Text = desc
        descLabel.TextColor3 = COLORS.TextDark
        descLabel.TextSize = 12
        descLabel.Font = Enum.Font.Gotham
        descLabel.TextXAlignment = Enum.TextXAlignment.Left

        -- Статус
        local statusLabel = Instance.new("TextLabel")
        statusLabel.Parent = btn
        statusLabel.Size = UDim2.new(0, 60, 0, 20)
        statusLabel.Position = UDim2.new(1, -65, 0, 17)
        statusLabel.BackgroundTransparency = 1
        statusLabel.Text = "▶️"
        statusLabel.TextColor3 = COLORS.TextDark
        statusLabel.TextSize = 16
        statusLabel.Font = Enum.Font.GothamBold
        statusLabel.TextXAlignment = Enum.TextXAlignment.Center

        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(40, 35, 0)
            }):Play()
            statusLabel.TextColor3 = COLORS.Text
        end)

        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {
                BackgroundColor3 = COLORS.Dark
            }):Play()
            statusLabel.TextColor3 = COLORS.TextDark
        end)

        btn.MouseButton1Click:Connect(function()
            statusLabel.Text = "⏳"
            statusLabel.TextColor3 = COLORS.Text
            btn.BackgroundColor3 = Color3.fromRGB(60, 50, 0)
            
            task.wait(0.3)
            screenGui:Destroy()
            LoadScript(url, name)
        end)

        return btn
    end

    -- ============================================
    -- КНОПКИ СКРИПТОВ (ПК)
    -- ============================================

    local yPos = 0
    for _, script in ipairs(SCRIPTS_PC) do
        CreateScriptButton(container, yPos, script.icon, script.name, script.desc, script.url)
        yPos = yPos + 65
    end

    container.Size = UDim2.new(1, 0, 0, yPos + 10)
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, yPos + 20)

    -- ============================================
    -- КНОПКА НАЗАД
    -- ============================================

    local backBtn = CreateButton(mainFrame,
        UDim2.new(0.6, 0, 0, 35),
        UDim2.new(0.2, 0, 0, 330),
        "⬅ ВЕРНУТЬСЯ",
        function()
            screenGui:Destroy()
            ReturnToDeviceMenu()
        end
    )
    backBtn.BackgroundColor3 = Color3.fromRGB(30, 20, 0)
    backBtn.BorderColor3 = Color3.fromRGB(255, 200, 0)
    backBtn.TextColor3 = Color3.fromRGB(255, 200, 0)

    -- ============================================
    -- КНОПКА ЗАКРЫТИЯ
    -- ============================================

    local closeBtn = CreateButton(mainFrame,
        UDim2.new(0, 32, 0, 32),
        UDim2.new(1, -38, 0, 8),
        "✕",
        function()
            screenGui:Destroy()
        end
    )
    closeBtn.BackgroundColor3 = COLORS.Background
    closeBtn.BorderColor3 = Color3.fromRGB(255, 50, 50)
    closeBtn.TextColor3 = Color3.fromRGB(255, 50, 50)

    -- Анимация
    mainFrame.BackgroundTransparency = 1
    local tween = TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0
    })
    tween:Play()
end

-- ============================================
-- ЗАПУСК
-- ============================================

print("💻 Список скриптов для ПК загружен!")
CreatePCList()
