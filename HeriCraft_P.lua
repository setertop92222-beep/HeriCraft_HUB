-- ============================================
-- HERRICRAFT HUB - ГЛАВНЫЙ СКРИПТ
-- ============================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer

-- ============================================
-- ССЫЛКА НА ФАЙЛ С КЛЮЧАМИ (GitHub)
-- ============================================

local KEYS_URL = "https://raw.githubusercontent.com/setertop92222-beep/HeriCraft_HUB/refs/heads/main/keys.lua"

-- ============================================
-- ЗАГРУЗКА КЛЮЧЕЙ И HWID С GITHUB
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
-- ОБНОВЛЕНИЕ ФАЙЛА НА GITHUB
-- ============================================
-- ============================================

local GITHUB_TOKEN = "ghp_ТВОЙ_ТОКЕН"  -- Твой Personal Access Token
local REPO_OWNER = "setertop92222-beep"
local REPO_NAME = "HeriCraft_HUB"
local FILE_PATH = "keys.lua"
local BRANCH = "main"

local function UpdateKeysOnGitHub(newContent)
    local url = "https://api.github.com/repos/" .. REPO_OWNER .. "/" .. REPO_NAME .. "/contents/" .. FILE_PATH
    
    -- Сначала получаем SHA файла
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    if not success then return false end
    
    local data = HttpService:JSONDecode(result)
    local sha = data.sha
    
    -- Формируем запрос на обновление
    local payload = {
        message = "Обновление HWID",
        content = HttpService:Base64Encode(newContent),
        sha = sha,
        branch = BRANCH
    }
    
    local headers = {
        ["Authorization"] = "token " .. GITHUB_TOKEN,
        ["Content-Type"] = "application/json"
    }
    
    local updateSuccess, updateResult = pcall(function()
        return syn.request({
            Url = url,
            Method = "PUT",
            Headers = headers,
            Body = HttpService:JSONEncode(payload)
        })
    end)
    
    return updateSuccess
end

-- ============================================
-- ============================================
-- ПОЛУЧЕНИЕ HWID
-- ============================================
-- ============================================

local function GetHWID()
    local userId = player.UserId
    local platform = UserInputService:GetPlatform()
    return tostring(userId) .. "_" .. tostring(platform)
}

-- ============================================
-- ============================================
-- ПОИСК КЛЮЧА В СПИСКЕ
-- ============================================
-- ============================================

local function FindKeyData(key)
    for _, k in ipairs(KeysData) do
        if k.key == key then
            return k
        end
    end
    return nil
end

-- ============================================
-- ============================================
-- ПРОВЕРКА И АКТИВАЦИЯ КЛЮЧА
-- ============================================
-- ============================================

local function CheckAndActivateKey(inputKey, hwid)
    -- 1. Ищем ключ
    local keyData = FindKeyData(inputKey)
    if not keyData then
        return false, "❌ Ключ не найден!"
    end
    
    -- 2. Проверяем, не активирован ли уже этот ключ на этом устройстве
    local currentActivations = 0
    if keyData.hwids then
        for _, savedHwid in ipairs(keyData.hwids) do
            if savedHwid == hwid then
                return true, "✅ Доступ разрешён!"
            end
        end
        currentActivations = #keyData.hwids
    end
    
    -- 3. Проверяем лимит активаций
    if currentActivations >= keyData.max_activations then
        return false, "❌ Достигнут лимит активаций! (" .. keyData.max_activations .. ")"
    end
    
    -- 4. Добавляем новый HWID
    if not keyData.hwids then
        keyData.hwids = {}
    end
    table.insert(keyData.hwids, hwid)
    
    -- 5. Обновляем файл на GitHub
    local newContent = "return {\n"
    for _, k in ipairs(KeysData) do
        newContent = newContent .. "    { key = \"" .. k.key .. "\", max_activations = " .. k.max_activations .. ", hwids = {"
        if k.hwids then
            local hwidsStr = ""
            for i, h in ipairs(k.hwids) do
                if i > 1 then hwidsStr = hwidsStr .. ", "
                end
                hwidsStr = hwidsStr .. "\"" .. h .. "\""
            end
            newContent = newContent .. hwidsStr
        end
        newContent = newContent .. "} },\n"
    end
    newContent = newContent .. "}"
    
    local success = UpdateKeysOnGitHub(newContent)
    if not success then
        return false, "❌ Ошибка сохранения на GitHub!"
    end
    
    return true, "✅ Ключ активирован! (" .. (currentActivations + 1) .. "/" .. keyData.max_activations .. ")"
end

-- ============================================
-- ============================================
-- GUI ВХОДА
-- ============================================
-- ============================================

local function LoadMainMenu()
    local url = "https://raw.githubusercontent.com/setertop92222-beep/HeriCraft_HUB/refs/heads/main/HeriCraft_MENU.lua"
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
    mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 16)
    corner.Parent = mainFrame

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
    -- ПРОВЕРКА КЛЮЧА
    -- ============================================

    local function CheckKey()
        local input = codeBox.Text
        local hwid = GetHWID()
        
        if input == "" then
            errorLabel.Text = "❌ Введите ключ!"
            errorLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
            task.wait(1)
            errorLabel.Text = ""
            return
        end
        
        local access, message = CheckAndActivateKey(input, hwid)
        
        if access then
            errorLabel.Text = message
            errorLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            confirmBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
            confirmBtn.Text = "✅ ОТКРЫТО!"
            
            task.wait(0.5)
            screenGui:Destroy()
            LoadMainMenu()
        else
            errorLabel.Text = message
            errorLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
            codeBox.Text = ""
            task.wait(1.5)
            errorLabel.Text = ""
        end
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
    CreateLoginGUI()
else
    print("❌ Не удалось загрузить ключи!")
end
