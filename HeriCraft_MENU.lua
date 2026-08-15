-- ============================================
--          🏆 HERRICRAFT HUB 🏆
--         МЕНЮ СО СПИСКОМ СКРИПТОВ
-- ============================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInput = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

-- ============================================
-- ============================================
-- !!! НАСТРОЙКИ СКРИПТОВ !!!
-- ============================================
-- ============================================
-- 
-- КАК ДОБАВЛЯТЬ СКРИПТЫ:
-- 1. Впиши название и ссылку
-- 2. Всё! Остальное автоматически
-- 
-- ПРИМЕР:
-- {"ESP с разделами", "https://raw.githubusercontent.com/.../esp.lua"},
-- 
-- Если хочешь скрыть скрипт - просто удали строку
-- ============================================

local SCRIPTS = {
    -- ===== СКРИПТ 1 =====
    {"[FPS] One Tap", "https://raw.githubusercontent.com/setertop92222-beep/HeriCraft_HUB/refs/heads/main/%5BFPS%5D%20One%20Tap.lua"},
    
    -- ===== СКРИПТ 2 =====
    {"AIMBOT", "https://raw.githubusercontent.com/setertop92222-beep/HeriCraft_HUB/refs/heads/main/HeriCraft_AIMBOT.lua"},
    
    -- ===== СКРИПТ 3 =====
    {"ESP_all", "https://raw.githubusercontent.com/setertop92222-beep/HeriCraft_HUB/refs/heads/main/HeriCraft_ESP.lua"},

    
    {"ESP", "https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"},

    {"MENU_ALL_GAMES", "https://raw.githubusercontent.com/setertop92222-beep/HeriCraft_HUB/refs/heads/main/HeriCraft_menu_all_all_games.lua"},

    {"MENU_ALL_GAMES", "https://raw.githubusercontent.com/setertop92222-beep/HeriCraft_HUB/refs/heads/main/HeriCraft_menu_all_all_games.lua"},

    {"MENU_ALL_GAMES", "https://raw.githubusercontent.com/setertop92222-beep/HeriCraft_HUB/refs/heads/main/HeriCraft_menu_all_all_games.lua"},

    {"MENU_ALL_GAMES", "https://raw.githubusercontent.com/setertop92222-beep/HeriCraft_HUB/refs/heads/main/HeriCraft_menu_all_all_games.lua"},

    {"MENU_ALL_GAMES", "https://raw.githubusercontent.com/setertop92222-beep/HeriCraft_HUB/refs/heads/main/HeriCraft_menu_all_all_games.lua"},
    
    -- ============================================
    -- ДОБАВЛЯЙ НОВЫЕ СКРИПТЫ СЮДА:
    -- ============================================
    
    -- {"Название скрипта", "https://ссылка_на_скрипт"},
}

-- ============================================
-- ФИЛЬТРУЕМ ТОЛЬКО ВИДИМЫЕ СКРИПТЫ
-- ============================================

local function GetVisibleScripts()
    local visible = {}
    for _, script in ipairs(SCRIPTS) do
        local name = script[1] or ""
        local url = script[2] or ""
        if name ~= "" and url ~= "" then
            table.insert(visible, script)
        end
    end
    return visible
end

-- ============================================
-- ЗАГРУЗЧИК СКРИПТОВ
-- ============================================

local function LoadScriptFromGithub(url)
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    
    if success and result then
        return result
    else
        return nil
    end
end

-- ============================================
-- ФУНКЦИЯ ПЛАВНОГО ЗАКРЫТИЯ
-- ============================================

local function CloseGUI(gui, callback)
    if not gui then
        if callback then callback() end
        return
    end
    
    local frame = gui:FindFirstChildWhichIsA("Frame")
    if frame then
        local tween = TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            BackgroundTransparency = 1
        })
        tween:Play()
        tween.Completed:Connect(function()
            gui:Destroy()
            if callback then callback() end
        end)
    else
        gui:Destroy()
        if callback then callback() end
    end
end

-- ============================================
-- СОЗДАНИЕ МЕНЮ
-- ============================================

local function CreateScriptMenu()
    -- Удаляем старый GUI
    for _, gui in ipairs(CoreGui:GetChildren()) do
        if gui.Name == "HerricraftScriptMenu" then
            gui:Destroy()
        end
    end
    
    local visibleScripts = GetVisibleScripts()
    
    if #visibleScripts == 0 then
        local errorGui = Instance.new("ScreenGui")
        errorGui.Parent = CoreGui
        local errorFrame = Instance.new("Frame")
        errorFrame.Parent = errorGui
        errorFrame.Size = UDim2.new(0, 400, 0, 80)
        errorFrame.Position = UDim2.new(0.5, -200, 0.5, -40)
        errorFrame.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        errorFrame.BorderSizePixel = 0
        local errorCorner = Instance.new("UICorner")
        errorCorner.CornerRadius = UDim.new(0, 12)
        errorCorner.Parent = errorFrame
        local errorText = Instance.new("TextLabel")
        errorText.Parent = errorFrame
        errorText.Size = UDim2.new(1, 0, 1, 0)
        errorText.BackgroundTransparency = 1
        errorText.Text = "❌ Нет доступных скриптов!\nДобавьте скрипты в настройки"
        errorText.TextColor3 = Color3.fromRGB(255, 255, 255)
        errorText.TextSize = 16
        errorText.Font = Enum.Font.GothamBold
        errorText.TextWrapped = true
        task.wait(3)
        errorGui:Destroy()
        return
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "HerricraftScriptMenu"
    screenGui.Parent = CoreGui
    screenGui.ResetOnSpawn = false
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Parent = screenGui
    mainFrame.Size = UDim2.new(0, 450, 0, 380)
    mainFrame.Position = UDim2.new(0.5, -225, 0.5, -190)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 16)
    corner.Parent = mainFrame
    
    local stroke = Instance.new("UIStroke")
    stroke.Parent = mainFrame
    stroke.Color = Color3.fromRGB(0, 150, 255)
    stroke.Thickness = 2
    stroke.Transparency = 0.2
    
    -- Заголовок
    local title = Instance.new("TextLabel")
    title.Parent = mainFrame
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Position = UDim2.new(0, 0, 0, 5)
    title.BackgroundTransparency = 1
    title.Text = "📦 ДОСТУПНЫЕ СКРИПТЫ"
    title.TextColor3 = Color3.fromRGB(0, 200, 255)
    title.TextSize = 24
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Center
    
    local subtitle = Instance.new("TextLabel")
    subtitle.Parent = mainFrame
    subtitle.Size = UDim2.new(1, 0, 0, 20)
    subtitle.Position = UDim2.new(0, 0, 0, 50)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "👇 Нажмите на скрипт чтобы запустить"
    subtitle.TextColor3 = Color3.fromRGB(150, 150, 150)
    subtitle.TextSize = 12
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextXAlignment = Enum.TextXAlignment.Center
    
    -- Кнопка закрытия
    local closeBtn = Instance.new("TextButton")
    closeBtn.Parent = mainFrame
    closeBtn.Size = UDim2.new(0, 32, 0, 32)
    closeBtn.Position = UDim2.new(1, -38, 0, 8)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 18
    closeBtn.Font = Enum.Font.GothamBold
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeBtn
    
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    -- ============================================
    -- КОНТЕЙНЕР С ПРОКРУТКОЙ
    -- ============================================
    
    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Parent = mainFrame
    scrollingFrame.Size = UDim2.new(1, -40, 0, 230)
    scrollingFrame.Position = UDim2.new(0, 20, 0, 80)
    scrollingFrame.BackgroundTransparency = 1
    scrollingFrame.BorderSizePixel = 0
    scrollingFrame.ScrollBarThickness = 6
    scrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120)
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollingFrame.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
    
    local container = Instance.new("Frame")
    container.Parent = scrollingFrame
    container.Size = UDim2.new(1, 0, 0, 0)
    container.BackgroundTransparency = 1
    
    -- ============================================
    -- СОЗДАНИЕ КНОПОК
    -- ============================================
    
    local function CreateScriptButton(parent, yPos, name, url)
        local btn = Instance.new("TextButton")
        btn.Parent = parent
        btn.Size = UDim2.new(1, 0, 0, 50)
        btn.Position = UDim2.new(0, 0, 0, yPos)
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        btn.BorderSizePixel = 0
        btn.Text = ""
        btn.AutoButtonColor = false
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 10)
        btnCorner.Parent = btn
        
        -- Название
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Parent = btn
        nameLabel.Size = UDim2.new(1, -80, 0, 50)
        nameLabel.Position = UDim2.new(0, 15, 0, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = name
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.TextSize = 16
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        -- Кнопка "Запуск"
        local runLabel = Instance.new("TextLabel")
        runLabel.Parent = btn
        runLabel.Size = UDim2.new(0, 60, 0, 30)
        runLabel.Position = UDim2.new(1, -70, 0, 10)
        runLabel.BackgroundTransparency = 1
        runLabel.Text = "▶️"
        runLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
        runLabel.TextSize = 20
        runLabel.Font = Enum.Font.GothamBold
        runLabel.TextXAlignment = Enum.TextXAlignment.Center
        
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
                BackgroundColor3 = Color3.fromRGB(45, 45, 50)
            }):Play()
            runLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)
        
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
                BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            }):Play()
            runLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
        end)
        
        btn.MouseButton1Click:Connect(function()
            runLabel.Text = "⏳"
            runLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
            
            task.wait(0.3)
            
            CloseGUI(screenGui, function()
                local scriptCode = LoadScriptFromGithub(url)
                if scriptCode then
                    loadstring(scriptCode)()
                else
                    local errorGui = Instance.new("ScreenGui")
                    errorGui.Parent = CoreGui
                    local errorFrame = Instance.new("Frame")
                    errorFrame.Parent = errorGui
                    errorFrame.Size = UDim2.new(0, 400, 0, 80)
                    errorFrame.Position = UDim2.new(0.5, -200, 0.5, -40)
                    errorFrame.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
                    errorFrame.BorderSizePixel = 0
                    local errorCorner = Instance.new("UICorner")
                    errorCorner.CornerRadius = UDim.new(0, 12)
                    errorCorner.Parent = errorFrame
                    local errorText = Instance.new("TextLabel")
                    errorText.Parent = errorFrame
                    errorText.Size = UDim2.new(1, 0, 1, 0)
                    errorText.BackgroundTransparency = 1
                    errorText.Text = "❌ Ошибка загрузки скрипта!"
                    errorText.TextColor3 = Color3.fromRGB(255, 255, 255)
                    errorText.TextSize = 16
                    errorText.Font = Enum.Font.GothamBold
                    errorText.TextWrapped = true
                    task.wait(3)
                    errorGui:Destroy()
                end
            end)
        end)
        
        return btn
    end

    -- ============================================
    -- СОЗДАЕМ ВИДИМЫЕ КНОПКИ
    -- ============================================

    local yPos = 0
    local visibleCount = 0
    
    for _, script in ipairs(visibleScripts) do
        CreateScriptButton(container, yPos, script[1], script[2])
        yPos = yPos + 60
        visibleCount = visibleCount + 1
    end
    
    container.Size = UDim2.new(1, 0, 0, yPos + 10)
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, yPos + 20)
    
    if visibleCount <= 3 then
        scrollingFrame.ScrollBarThickness = 0
    end

    -- Анимация появления
    mainFrame.BackgroundTransparency = 1
    local tween = TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0
    })
    tween:Play()
    
    print("📦 Загружено скриптов: " .. visibleCount)
end

-- ============================================
-- ЗАПУСК
-- ============================================

print("📦 Меню скриптов загружено!")
CreateScriptMenu()
