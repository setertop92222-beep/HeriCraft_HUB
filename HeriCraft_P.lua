local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInput = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer

-- ============================================
-- НАСТРОЙКИ (ИЗМЕНЯЙ ЗДЕСЬ)
-- ============================================

local CONFIG = {
    -- Пароль для входа (НЕ ВЫВОДИТСЯ В КОНСОЛЬ)
    Password = "finsik1431243",
    
    -- Ссылки на GitHub (RAW)
    Scripts = {
        Menu = "https://raw.githubusercontent.com/setertop92222-beep/HeriCraft_HUB/refs/heads/main/HeriCraft_MENU.lua",
    }
}

-- ============================================
-- ЗАГРУЗЧИК СКРИПТОВ С GITHUB
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
-- МЕНЮ ВХОДА С ПАРОЛЕМ
-- ============================================

local function CreateLoginMenu()
    -- Удаляем старые GUI
    for _, gui in ipairs(CoreGui:GetChildren()) do
        if gui.Name == "HerricraftLogin" or gui.Name == "HerricraftScriptMenu" then
            gui:Destroy()
        end
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "HerricraftLogin"
    screenGui.Parent = CoreGui
    screenGui.ResetOnSpawn = false
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Parent = screenGui
    mainFrame.Size = UDim2.new(0, 420, 0, 320)
    mainFrame.Position = UDim2.new(0.5, -210, 0.5, -160)
    mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 16)
    corner.Parent = mainFrame
    
    local stroke = Instance.new("UIStroke")
    stroke.Parent = mainFrame
    stroke.Color = Color3.fromRGB(255, 215, 0)
    stroke.Thickness = 2
    stroke.Transparency = 0.2
    
    -- Заголовок
    local title = Instance.new("TextLabel")
    title.Parent = mainFrame
    title.Size = UDim2.new(1, 0, 0, 60)
    title.Position = UDim2.new(0, 0, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "🏆 HERRICRAFT HUB"
    title.TextColor3 = Color3.fromRGB(255, 215, 0)
    title.TextSize = 30
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Center
    
    local subtitle = Instance.new("TextLabel")
    subtitle.Parent = mainFrame
    subtitle.Size = UDim2.new(1, 0, 0, 25)
    subtitle.Position = UDim2.new(0, 0, 0, 65)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "🔐 Введите пароль для доступа"
    subtitle.TextColor3 = Color3.fromRGB(160, 160, 160)
    subtitle.TextSize = 14
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextXAlignment = Enum.TextXAlignment.Center
    
    -- Поле ввода
    local codeBox = Instance.new("TextBox")
    codeBox.Parent = mainFrame
    codeBox.Size = UDim2.new(0.6, 0, 0, 45)
    codeBox.Position = UDim2.new(0.2, 0, 0, 110)
    codeBox.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    codeBox.BorderSizePixel = 0
    codeBox.Text = ""
    codeBox.PlaceholderText = "🔑 Введите пароль..."
    codeBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    codeBox.PlaceholderColor3 = Color3.fromRGB(130, 130, 130)
    codeBox.TextSize = 18
    codeBox.Font = Enum.Font.GothamMedium
    codeBox.TextXAlignment = Enum.TextXAlignment.Center
    codeBox.ClearTextOnFocus = false
    
    local codeCorner = Instance.new("UICorner")
    codeCorner.CornerRadius = UDim.new(0, 10)
    codeCorner.Parent = codeBox
    
    -- Кнопка входа
    local confirmBtn = Instance.new("TextButton")
    confirmBtn.Parent = mainFrame
    confirmBtn.Size = UDim2.new(0.4, 0, 0, 45)
    confirmBtn.Position = UDim2.new(0.3, 0, 0, 175)
    confirmBtn.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    confirmBtn.BorderSizePixel = 0
    confirmBtn.Text = "🚀 ВОЙТИ"
    confirmBtn.TextColor3 = Color3.fromRGB(18, 18, 22)
    confirmBtn.TextSize = 18
    confirmBtn.Font = Enum.Font.GothamBold
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = confirmBtn
    
    -- Ошибка
    local errorLabel = Instance.new("TextLabel")
    errorLabel.Parent = mainFrame
    errorLabel.Size = UDim2.new(1, 0, 0, 25)
    errorLabel.Position = UDim2.new(0, 0, 0, 235)
    errorLabel.BackgroundTransparency = 1
    errorLabel.Text = ""
    errorLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
    errorLabel.TextSize = 14
    errorLabel.Font = Enum.Font.Gotham
    errorLabel.TextXAlignment = Enum.TextXAlignment.Center
    
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
    -- ПРОВЕРКА ПАРОЛЯ (ПАРОЛЬ НЕ ВЫВОДИТСЯ)
    -- ============================================
    
    local function CheckCode()
        local inputCode = codeBox.Text
        if inputCode == CONFIG.Password then
            errorLabel.Text = "✅ Пароль верный!"
            errorLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            confirmBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
            confirmBtn.Text = "✅ ОТКРЫТО!"
            
            task.wait(0.3)
            
            -- Закрываем меню входа
            CloseGUI(screenGui, function()
                -- Загружаем меню скриптов с GitHub
                local menuScript = LoadScriptFromGithub(CONFIG.Scripts.Menu)
                if menuScript then
                    loadstring(menuScript)()
                else
                    local errorGui = Instance.new("ScreenGui")
                    errorGui.Parent = CoreGui
                    local errorFrame = Instance.new("Frame")
                    errorFrame.Parent = errorGui
                    errorFrame.Size = UDim2.new(0, 400, 0, 100)
                    errorFrame.Position = UDim2.new(0.5, -200, 0.5, -50)
                    errorFrame.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
                    errorFrame.BorderSizePixel = 0
                    local errorCorner = Instance.new("UICorner")
                    errorCorner.CornerRadius = UDim.new(0, 12)
                    errorCorner.Parent = errorFrame
                    local errorText = Instance.new("TextLabel")
                    errorText.Parent = errorFrame
                    errorText.Size = UDim2.new(1, 0, 1, 0)
                    errorText.BackgroundTransparency = 1
                    errorText.Text = "❌ Ошибка загрузки меню!\nПроверьте интернет или ссылку"
                    errorText.TextColor3 = Color3.fromRGB(255, 255, 255)
                    errorText.TextSize = 16
                    errorText.Font = Enum.Font.GothamBold
                    errorText.TextWrapped = true
                    task.wait(3)
                    errorGui:Destroy()
                end
            end)
        else
            errorLabel.Text = "❌ Неверный пароль!"
            errorLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
            codeBox.Text = ""
            task.wait(0.5)
            errorLabel.Text = ""
            codeBox.PlaceholderText = "🔑 Введите пароль..."
        end
    end
    
    confirmBtn.MouseButton1Click:Connect(CheckCode)
    
    codeBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            CheckCode()
        end
    end)
    
    -- Анимация появления
    mainFrame.BackgroundTransparency = 1
    local tween = TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0
    })
    tween:Play()
end
CreateLoginMenu()
