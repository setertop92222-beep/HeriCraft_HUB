-- ============================================
-- HERRICRAFT HUB - МЕНЮ ВХОДА С УВЕДОМЛЕНИЯМИ
-- ============================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer

-- ============================================
-- ============================================
-- НАСТРОЙКИ TELEGRAM
-- ============================================
-- ============================================

local TELEGRAM_TOKEN = "8971624443:AAGYMd7W9zk2uE4BEZq4Ke_wsEZJ1MUZCF4"  -- ТОКЕН БОТА (от @BotFather)
local TELEGRAM_CHAT_ID = "7227279621"  -- ТВОЙ ID (узнай у @userinfobot)

-- ============================================
-- ФУНКЦИЯ ОТПРАВКИ В TELEGRAM
-- ============================================

local function SendToTelegram(message)
    local url = "https://api.telegram.org/bot" .. TELEGRAM_TOKEN .. "/sendMessage"
    local payload = {
        chat_id = TELEGRAM_CHAT_ID,
        text = message,
        parse_mode = "HTML"
    }
    
    pcall(function()
        local request = syn and syn.request or request or http and http.request
        if request then
            request({
                Url = url,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = HttpService:JSONEncode(payload)
            })
        end
    end)
end

-- ============================================
-- ============================================
-- НАСТРОЙКИ КЛЮЧЕЙ
-- ============================================
-- ============================================

local KEYS_URL = "https://raw.githubusercontent.com/setertop92222-beep/HeriCraft_HUB/refs/heads/main/keys.lua"

local KeysData = {}

local function LoadKeysFromGitHub()
    local success, result = pcall(function()
        return game:HttpGet(KEYS_URL)
    end)
    if success and result then
        local func, err = loadstring(result)
        if func then
            local loadedKeys = func()
            if type(loadedKeys) == "table" then
                KeysData = loadedKeys
                print("✅ Загружено ключей: " .. #KeysData)
                return true
            end
        end
    end
    print("❌ Ошибка загрузки ключей!")
    return false
end

-- ============================================
-- ПОЛУЧЕНИЕ HWID
-- ============================================

local function GetHWID()
    local userId = player.UserId
    local platform = UserInputService:GetPlatform()
    return tostring(userId) .. "_" .. tostring(platform)
end

-- ============================================
-- ПОИСК КЛЮЧА
-- ============================================

local function FindKey(key)
    for _, k in ipairs(KeysData) do
        if k.key == key then
            return k
        end
    end
    return nil
end

-- ============================================
-- ============================================
-- ЗАГРУЗКА МЕНЮ
-- ============================================
-- ============================================

local function LoadScriptMenu()
    local url = "https://raw.githubusercontent.com/setertop92222-beep/HeriCraft_HUB/refs/heads/main/HeriCraft_MENU.lua"
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    if success and result then
        loadstring(result)()
    else
        print("❌ Ошибка загрузки меню!")
    end
end

-- ============================================
-- ============================================
-- GUI ВХОДА
-- ============================================
-- ============================================

local function CreateLoginGUI()
    for _, gui in ipairs(CoreGui:GetChildren()) do
        if gui.Name == "HericraftLogin" then
            gui:Destroy()
        end
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "HericraftLogin"
    screenGui.Parent = CoreGui
    screenGui.ResetOnSpawn = false

    local mainFrame = Instance.new("Frame")
    mainFrame.Parent = screenGui
    mainFrame.Size = UDim2.new(0, 420, 0, 320)
    mainFrame.Position = UDim2.new(0.5, -210, 0.5, -160)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 16)
    corner.Parent = mainFrame

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

    -- Подзаголовок
    local subtitle = Instance.new("TextLabel")
    subtitle.Parent = mainFrame
    subtitle.Size = UDim2.new(1, 0, 0, 25)
    subtitle.Position = UDim2.new(0, 0, 0, 65)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "🔑 Введите ключ для доступа"
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
    codeBox.PlaceholderText = "🔑 Введите ключ..."
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
    -- ============================================
    -- ПРОВЕРКА КЛЮЧА + ОТПРАВКА В TELEGRAM
    -- ============================================
    -- ============================================

    local function CheckKey()
        local inputKey = codeBox.Text
        local hwid = GetHWID()
        
        if inputKey == "" then
            errorLabel.Text = "❌ Введите ключ!"
            errorLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
            task.wait(1)
            errorLabel.Text = ""
            return
        end
        
        -- Ищем ключ
        local foundKey = FindKey(inputKey)
        
        if not foundKey then
            errorLabel.Text = "❌ Ключ не найден!"
            errorLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
            codeBox.Text = ""
            task.wait(1.5)
            errorLabel.Text = ""
            return
        end
        
        -- Проверяем, использован ли ключ
        if foundKey.used then
            if foundKey.hwid == hwid then
                errorLabel.Text = "✅ Доступ разрешён!"
                errorLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                confirmBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
                confirmBtn.Text = "✅ ОТКРЫТО!"
                
                task.wait(0.5)
                screenGui:Destroy()
                LoadScriptMenu()
            else
                errorLabel.Text = "❌ Ключ уже используется!"
                errorLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
                codeBox.Text = ""
                task.wait(1.5)
                errorLabel.Text = ""
            end
            return
        end
        
        -- ============================================
        -- КЛЮЧ АКТИВИРОВАН — ОТПРАВЛЯЕМ В TELEGRAM
        -- ============================================
        
        -- Отправляем уведомление
        local message = string.format([[
🎯 <b>АКТИВАЦИЯ КЛЮЧА</b>

🔑 Ключ: <code>%s</code>
🆔 HWID: <code>%s</code>
👤 Игрок: %s
🖥️ Устройство: %s
📅 Время: %s
        ]],
            inputKey,
            hwid,
            player.Name,
            UserInputService:GetPlatform(),
            os.date("%Y-%m-%d %H:%M:%S")
        )
        
        SendToTelegram(message)
        
        -- Обновляем ключ в памяти
        foundKey.used = true
        foundKey.hwid = hwid
        
        -- Открываем доступ
        errorLabel.Text = "✅ Ключ активирован!"
        errorLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        confirmBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        confirmBtn.Text = "✅ ОТКРЫТО!"
        
        task.wait(0.5)
        screenGui:Destroy()
        LoadScriptMenu()
    end

    confirmBtn.MouseButton1Click:Connect(CheckKey)
    codeBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then CheckKey() end
    end)
end

-- ============================================
-- ЗАПУСК
-- ============================================

print("🏆 HERRICRAFT HUB загружен!")
print("📥 Загрузка ключей...")

local success = LoadKeysFromGitHub()
if success then
    print("📌 Введите ключ для доступа")
    print("📨 Уведомления отправляются в Telegram")
    CreateLoginGUI()
else
    print("❌ Не удалось загрузить ключи!")
end
