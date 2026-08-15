-- ============================================
-- HERRICRAFT HUB - ВЫБОР УСТРОЙСТВА
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
-- ЗАГРУЗКА МЕНЮ
-- ============================================

local function LoadPCList()
    local url = "https://raw.githubusercontent.com/setertop92222-beep/HeriCraft_HUB/refs/heads/main/pc_list.lua"
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    if success and result then
        loadstring(result)()
    else
        print("❌ Ошибка загрузки списка для ПК!")
    end
end

local function LoadMobileList()
    local url = "https://raw.githubusercontent.com/setertop92222-beep/HeriCraft_HUB/refs/heads/main/mobile_list.lua"
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    if success and result then
        loadstring(result)()
    else
        print("❌ Ошибка загрузки списка для телефона!")
    end
end

-- ============================================
-- МЕНЮ ВЫБОРА УСТРОЙСТВА
-- ============================================

local function CreateDeviceMenu()
    for _, gui in ipairs(CoreGui:GetChildren()) do
        if gui.Name == "HericraftDevice" then
            gui:Destroy()
        end
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "HericraftDevice"
    screenGui.Parent = CoreGui
    screenGui.ResetOnSpawn = false

    local mainFrame = CreateFrame(screenGui,
        UDim2.new(0, 350, 0, 250),
        UDim2.new(0.5, -175, 0.5, -125)
    )

    CreateLabel(mainFrame,
        UDim2.new(1, 0, 0, 50),
        UDim2.new(0, 0, 0, 5),
        "💻 ВЫБЕРИ УСТРОЙСТВО",
        COLORS.Border,
        22
    )

    CreateLabel(mainFrame,
        UDim2.new(1, 0, 0, 20),
        UDim2.new(0, 0, 0, 50),
        "Для какого устройства нужны скрипты?",
        COLORS.TextDark,
        12
    )

    -- Контейнер
    local container = Instance.new("Frame")
    container.Parent = mainFrame
    container.Size = UDim2.new(1, -40, 0, 100)
    container.Position = UDim2.new(0, 20, 0, 80)
    container.BackgroundTransparency = 1

    -- Кнопка: Компьютер
    CreateButton(container,
        UDim2.new(1, 0, 0, 40),
        UDim2.new(0, 0, 0, 0),
        "💻 КОМПЬЮТЕР",
        function()
            screenGui:Destroy()
            LoadPCList()
        end
    )

    -- Кнопка: Телефон
    CreateButton(container,
        UDim2.new(1, 0, 0, 40),
        UDim2.new(0, 0, 0, 50),
        "📱 ТЕЛЕФОН",
        function()
            screenGui:Destroy()
            LoadMobileList()
        end
    )

    -- Информация
    CreateLabel(mainFrame,
        UDim2.new(1, 0, 0, 20),
        UDim2.new(0, 0, 0, 195),
        "Выбери устройство для загрузки скриптов",
        COLORS.TextDark,
        11
    )

    -- Кнопка закрытия
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

print("📱 Меню выбора устройства загружено!")
CreateDeviceMenu()
