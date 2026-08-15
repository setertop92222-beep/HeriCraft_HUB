-- ============================================
-- HERRICRAFT HUB - МЕНЮ ВХОДА С HWID
-- ============================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer

-- ============================================
-- ============================================
-- НАСТРОЙКИ
-- ============================================
-- ============================================

local REPO_OWNER = "setertop92222-beep"
local REPO_NAME = "HeriCraft_HUB"
local BRANCH = "main"

-- ССЫЛКА НА ФАЙЛ С КЛЮЧАМИ (GitHub)
local KEYS_URL = "https://raw.githubusercontent.com/" .. REPO_OWNER .. "/" .. REPO_NAME .. "/" .. BRANCH .. "/keys.lua"

-- ЛОКАЛЬНЫЙ ФАЙЛ ДЛЯ АКТИВАЦИЙ
local ACTIVATIONS_FILE = "Hericraft_Activations.txt"

-- ============================================
-- ============================================
-- ЗАГРУЗКА КЛЮЧЕЙ С GITHUB
-- ============================================
-- ============================================

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
-- ============================================
-- РАБОТА С ЛОКАЛЬНЫМ ФАЙЛОМ АКТИВАЦИЙ
-- ============================================
-- ============================================

local function LoadActivations()
    local data = {}
    local success, content = pcall(function()
        return readfile(ACTIVATIONS_FILE)
    end)
    if success and content then
        for entry in string.gmatch(content, "([^;]+)") do
            local key, hwid = string.match(entry, "([^:]+):([^:]+)")
            if key and hwid then
                data[key] = hwid
            end
        end
    end
    return data
end

local function SaveActivation(key, hwid)
    local data = LoadActivations()
    data[key] = hwid
    
    local content = ""
    for k, v in pairs(data) do
        content = content .. k .. ":" .. v .. ";"
    end
    pcall(function()
        writefile(ACTIVATIONS_FILE, content)
    end)
    print("✅ Сохранено локально: " .. key .. " → " .. hwid)
    return true
end

-- ============================================
-- ============================================
-- ОСНОВНАЯ ЛОГИКА
-- ============================================
-- ============================================

local function GetHWID()
    local userId = player.UserId
    local platform = UserInputService:GetPlatform()
    return tostring(userId) .. "_" .. tostring(platform)
end

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
-- GUI ВХОДА
-- ============================================
-- ============================================

local function LoadScriptMenu()
    local url = "https://raw.githubusercontent.com/" .. REPO_OWNER .. "/" .. REPO_NAME .. "/" .. BRANCH .. "/HeriCraft_MENU.lua"
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    if success and result then
        loadstring(result)()
        print("✅ Меню загружено!")
    else
        print("❌ Ошибка загрузки меню!")
    end
end

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
    -- ПРОВЕРКА КЛЮЧА
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
        
        -- 1. Проверяем, есть ли ключ в списке
        local foundKey = FindKey(inputKey)
        if not foundKey then
            errorLabel.Text = "❌ Ключ не найден!"
            errorLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
            codeBox.Text = ""
            task.wait(1.5)
            errorLabel.Text = ""
            return
        end
        
        -- 2. Проверяем локальный файл активаций
        local activations = LoadActivations()
        local savedHwid = activations[inputKey]
        
        if savedHwid then
            if savedHwid == hwid then
                -- Тот же пользователь — доступ разрешён
                errorLabel.Text = "✅ Доступ разрешён!"
                errorLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                confirmBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
                confirmBtn.Text = "✅ ОТКРЫТО!"
                
                task.wait(0.5)
                screenGui:Destroy()
                LoadScriptMenu()
                return
            else
                errorLabel.Text = "❌ Ключ уже используется!"
                errorLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
                codeBox.Text = ""
                task.wait(1.5)
                errorLabel.Text = ""
                return
            end
        end
        
        -- 3. Ключ свободен — активируем локально
        SaveActivation(inputKey, hwid)
        
        errorLabel.Text = "✅ Ключ активирован!"
        errorLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        confirmBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        confirmBtn.Text = "✅ ОТКРЫТО!"
        
        print("🔑 Активирован ключ: " .. inputKey)
        print("🆔 HWID: " .. hwid)
        print("👤 Игрок: " .. player.Name)
        
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
-- ПРОВЕРКА
-- ============================================

local function TestConnection()
    print("🔍 Проверка загрузки ключей...")
    local success = LoadKeysFromGitHub()
    if success then
        print("✅ Ключи загружены!")
        return true
    else
        print("❌ Не удалось загрузить ключи!")
        return false
    end
end

-- ============================================
-- ЗАПУСК
-- ============================================

print("🏆 HERRICRAFT HUB загружен!")
print("📥 Загрузка ключей...")

local success = LoadKeysFromGitHub()
if success then
    print("📌 Введите ключ для доступа")
    CreateLoginGUI()
else
    print("❌ Не удалось загрузить ключи!")
end
