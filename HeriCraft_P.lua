-- ============================================
-- HERRICRAFT HUB - СИСТЕМА КЛЮЧЕЙ С АДМИН-ПАНЕЛЬЮ
-- ============================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- ============================================
-- НАСТРОЙКИ
-- ============================================

-- ВСЕ 100 КЛЮЧЕЙ (из твоего файла)
local KEYS = {
    "JFJRKCMD-KEJDUENT",
    "BXJDRKDM-ELPQLSWN",
    "DJFHXJDN-VMCKELKT",
    "JDNFHCMV-DLFNGKDJ",
    "CMVMCJEU-RKDMSJDN",
    "FHCMVKRK-DLEJFNCK",
    "DMVKELFJ-NRCJFNRK",
    "DMELTJDNFHCMVKXM",
    "CKDLEJFN-PQLSKDJC",
    "MVBRJDNK-FKEMCKDM",
    "VKELJDNF-JCNRKDME",
    "KLDNJFHC-MVKRMCKJ",
    "DNFLEXJDNKFMCVLT",
    "JDNRKEMC-DLFNGKDJ",
    "VKVMCJEU-RKDLSJDN",
    "FHCMRKRK-DLEJFNCV",
    "DMVKELFJ-MCCJFNRK",
    "DMEKTJDN-FHCMLKXM",
    "CKDLEJFR-PQLSKDJC",
    "MNBRJDNF-KEMVKDMV",
    "KELJMC FJCNRKDMLK",
    "LDNJFHCM-VKRMCKJD",
    "NFLEXJDN-KFMCVRKT",
    "JDNRKEML-DLFNGKDJ",
    "VMVMCJEU-RKDFSJDN",
    "FHCMVKRK-DLEJFNCX",
    "DMVKELFJ-DNCJFNRK",
    "DMELTJDNFHCMVKXMC",
    "KDLEJFNP-QLSKDJCM",
    "VBRJDNFK-EMCKDMVK",
    "ELJDN FJCNRKDMEKL",
    "DNJFHCMV-KRMCKJDN",
    "FLEXJDNK-FMCVLKTJ",
    "DNRKEMCD-LFNGKDJV",
    "KVMCJEUR-KDLSJDNF",
    "HCMRKRKD-LEJFNCVD",
    "MVKELFJM-CCJFNRKD",
    "MEKTJDNF-HCMLKXMC",
    "KDLEJFRP-QLSKDJCM",
    "NBRJDNFK-EMVKDMVK",
    "ELJMCFJC-NRKDMLKL",
    "DNJFHCMV-KRMCKJDN",
    "FLEXJDNK-FMCVRKTJ",
    "DNRKEMLD-LFNGKDJV",
    "MVMCJEUR-KDFSJDNF",
    "HCMVKRKD-LEJFNCXD",
    "MVKELFJD-NCJFNRKD",
    "MELTJDNF-HCMVKXMC",
    "KDLEJFNP-QLSKDJCM",
    "VBRJDNFK-EMCKDMVK",
    "ELJDNFJC-NRKDMEKL",
    "DNJFHCMV-KRMCKJDN",
    "FLEXJDNK-FMCVLKTJ",
    "DNRKEMCD-LFNGKDJV",
    "KVMCJEUR-KDLSJDNF",
    "HCMRKRKD-LEJFNCVD",
    "MVKELFJM-CCJFNRKD",
    "MEKTJDNF-HCMLKXMC",
    "KDLEJFRP-QLSKDJCM",
    "NBRJDNFK-EMVKDMVK",
    "ELJMCFJC-NRKDMLKL",
    "DNJFHCMV-KRMCKJDN",
    "FLEXJDNK-FMCVRKTJ",
    "DNRKEMLD-LFNGKDJV",
    "MVMCJEUR-KDFSJDNF",
    "HCMVKRKD-LEJFNCXD",
    "MVKELFJD-NCJFNRKD",
    "MELTJDNF-HCMVKXMC",
    "KDLEJFNP-QLSKDJCM",
    "VBRJDNFK-EMCKDMVK",
    "ELJDNFJC-NRKDMEKL",
    "DNJFHCMV-KRMCKJDN",
    "FLEXJDNK-FMCVLKTJ",
    "DNRKEMCD-LFNGKDJV",
    "KVMCJEUR-KDLSJDNF",
    "HCMRKRKD-LEJFNCVD",
    "MVKELFJM-CCJFNRKD",
    "MEKTJDNF-HCMLKXMC",
    "KDLEJFRP-QLSKDJCM",
    "NBRJDNFK-EMVKDMVK",
    "ELJMCFJC-NRKDMLKL",
    "DNJFHCMV-KRMCKJDN",
    "FLEXJDNK-FMCVRKTJ",
    "DNRKEMLD-LFNGKDJV",
    "MVMCJEUR-KDFSJDNF",
    "HCMVKRKD-LEJFNCXD",
    "MVKELFJD-NCJFNRKD",
    "MELTJDNF-HCMVKXMC",
    "KDLEJFNP-QLSKDJCM",
    "VBRJDNFK-EMCKDMVK",
    "ELJDNFJC-NRKDMEKL",
    "DNJFHCMV-KRMCKJDN",
    "FLEXJDNK-FMCVLKTJ",
    "DNRKEMCD-LFNGKDJV",
    "KVMCJEUR-KDLSJDNF",
    "HCMRKRKD-LEJFNCVD",
    "MVKELFJM-CCJFNRKD",
    "MEKTJDNF-HCMLKXMC",
    "KDLEJFRP-QLSKDJCM",
    "NBRJDNFK-EMVKDMVK"
}

-- МАСТЕР-ПАРОЛЬ ДЛЯ АДМИН-ПАНЕЛИ
local MASTER_PASSWORD = "007489"  -- Измени на свой

-- ============================================
-- ХРАНИЛИЩЕ АКТИВИРОВАННЫХ КЛЮЧЕЙ
-- ============================================

local ActivatedKeys = {}

-- ============================================
-- ЗАГРУЗКА И СОХРАНЕНИЕ ДАННЫХ
-- ============================================

local function SaveActivatedKeys()
    local data = ""
    for key, hwid in pairs(ActivatedKeys) do
        data = data .. key .. ":" .. hwid .. ";"
    end
    pcall(function()
        writefile("Hericraft_Keys.txt", data)
    end)
end

local function LoadActivatedKeys()
    local data = pcall(function()
        return readfile("Hericraft_Keys.txt")
    end)
    if data then
        for entry in string.gmatch(data, "([^;]+)") do
            local parts = {}
            for part in string.gmatch(entry, "([^:]+)") do
                table.insert(parts, part)
            end
            if #parts == 2 then
                ActivatedKeys[parts[1]] = parts[2]
            end
        end
    end
end

LoadActivatedKeys()

-- ============================================
-- ПОЛУЧЕНИЕ HWID
-- ============================================

local function GetHWID()
    local userId = player.UserId
    local platform = game:GetService("UserInputService"):GetPlatform()
    return tostring(userId) .. "_" .. tostring(platform)
end

-- ============================================
-- ФУНКЦИИ ДЛЯ КЛЮЧЕЙ
-- ============================================

local function CheckAccess(key, hwid)
    local keyExists = false
    for _, k in ipairs(KEYS) do
        if k == key then
            keyExists = true
            break
        end
    end
    if not keyExists then
        return false, "Ключ не найден!"
    end
    
    local savedHwid = ActivatedKeys[key]
    if savedHwid then
        if savedHwid == hwid then
            return true, "Доступ разрешён!"
        else
            return false, "Этот ключ уже используется на другом устройстве!"
        end
    end
    
    return true, "Ключ активирован!"
end

local function ActivateKey(key, hwid)
    ActivatedKeys[key] = hwid
    SaveActivatedKeys()
    return true, "Ключ успешно активирован!"
end

local function ResetKey(key)
    if ActivatedKeys[key] then
        ActivatedKeys[key] = nil
        SaveActivatedKeys()
        return true, "HWID сброшен для ключа: " .. key
    else
        return false, "Ключ не найден в списке активированных!"
    end
end

-- ============================================
-- GUI ВХОДА
-- ============================================

local function CreateLoginGUI()
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
    -- ПРОВЕРКА КЛЮЧА (И МАСТЕР-ПАРОЛЯ)
    -- ============================================

    local function CheckKey()
        local input = codeBox.Text
        local hwid = GetHWID()
        
        -- ПРОВЕРКА МАСТЕР-ПАРОЛЯ (ОТКРЫВАЕТ АДМИН-ПАНЕЛЬ)
        if input == MASTER_PASSWORD then
            screenGui:Destroy()
            CreateAdminPanel()
            return
        end
        
        -- ОБЫЧНАЯ ПРОВЕРКА КЛЮЧА
        local access, message = CheckAccess(input, hwid)
        
        if access then
            local activated, msg = ActivateKey(input, hwid)
            if activated then
                errorLabel.Text = "✅ " .. msg
                errorLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                confirmBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
                confirmBtn.Text = "✅ ОТКРЫТО!"
                
                task.wait(0.5)
                screenGui:Destroy()
                
                local menuUrl = "https://raw.githubusercontent.com/setertop92222-beep/HeriCraft_HUB/refs/heads/main/HeriCraft_MENU.lua"
                loadstring(game:HttpGet(menuUrl))()
            else
                errorLabel.Text = "❌ " .. msg
                errorLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
                codeBox.Text = ""
                task.wait(1)
                errorLabel.Text = ""
            end
        else
            errorLabel.Text = "❌ " .. message
            errorLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
            codeBox.Text = ""
            task.wait(1)
            errorLabel.Text = ""
        end
    end

    confirmBtn.MouseButton1Click:Connect(CheckKey)
    codeBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then CheckKey() end
    end)
end

-- ============================================
-- ============================================
-- АДМИН-ПАНЕЛЬ
-- ============================================
-- ============================================

local function CreateAdminPanel()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AdminPanel"
    screenGui.Parent = CoreGui
    screenGui.ResetOnSpawn = false

    local mainFrame = Instance.new("Frame")
    mainFrame.Parent = screenGui
    mainFrame.Size = UDim2.new(0, 450, 0, 380)
    mainFrame.Position = UDim2.new(0.5, -225, 0.5, -190)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 16)
    corner.Parent = mainFrame

    local stroke = Instance.new("UIStroke")
    stroke.Parent = mainFrame
    stroke.Color = Color3.fromRGB(255, 0, 0)
    stroke.Thickness = 2
    stroke.Transparency = 0.3

    -- Заголовок
    local title = Instance.new("TextLabel")
    title.Parent = mainFrame
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Position = UDim2.new(0, 0, 0, 5)
    title.BackgroundTransparency = 1
    title.Text = "🔐 АДМИН-ПАНЕЛЬ"
    title.TextColor3 = Color3.fromRGB(255, 0, 0)
    title.TextSize = 24
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Center

    local subtitle = Instance.new("TextLabel")
    subtitle.Parent = mainFrame
    subtitle.Size = UDim2.new(1, 0, 0, 20)
    subtitle.Position = UDim2.new(0, 0, 0, 50)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Управление ключами и HWID"
    subtitle.TextColor3 = Color3.fromRGB(150, 150, 150)
    subtitle.TextSize = 12
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextXAlignment = Enum.TextXAlignment.Center

    -- Поле для ввода ключа
    local resetBox = Instance.new("TextBox")
    resetBox.Parent = mainFrame
    resetBox.Size = UDim2.new(0.6, 0, 0, 40)
    resetBox.Position = UDim2.new(0.2, 0, 0, 90)
    resetBox.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    resetBox.BorderSizePixel = 0
    resetBox.Text = ""
    resetBox.PlaceholderText = "🔑 Введите ключ для сброса..."
    resetBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    resetBox.PlaceholderColor3 = Color3.fromRGB(130, 130, 130)
    resetBox.TextSize = 16
    resetBox.Font = Enum.Font.GothamMedium
    resetBox.TextXAlignment = Enum.TextXAlignment.Center
    resetBox.ClearTextOnFocus = false

    local resetCorner = Instance.new("UICorner")
    resetCorner.CornerRadius = UDim.new(0, 10)
    resetCorner.Parent = resetBox

    -- Кнопка сброса
    local resetBtn = Instance.new("TextButton")
    resetBtn.Parent = mainFrame
    resetBtn.Size = UDim2.new(0.4, 0, 0, 40)
    resetBtn.Position = UDim2.new(0.3, 0, 0, 145)
    resetBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    resetBtn.BorderSizePixel = 0
    resetBtn.Text = "🔄 Сбросить HWID"
    resetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    resetBtn.TextSize = 16
    resetBtn.Font = Enum.Font.GothamBold

    local resetCorner2 = Instance.new("UICorner")
    resetCorner2.CornerRadius = UDim.new(0, 10)
    resetCorner2.Parent = resetBtn

    -- Статус
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Parent = mainFrame
    statusLabel.Size = UDim2.new(0.9, 0, 0, 25)
    statusLabel.Position = UDim2.new(0.05, 0, 0, 200)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = ""
    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    statusLabel.TextSize = 14
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextXAlignment = Enum.TextXAlignment.Center

    -- Список активированных ключей
    local listLabel = Instance.new("TextLabel")
    listLabel.Parent = mainFrame
    listLabel.Size = UDim2.new(0.9, 0, 0, 20)
    listLabel.Position = UDim2.new(0.05, 0, 0, 240)
    listLabel.BackgroundTransparency = 1
    listLabel.Text = "Активированные ключи:"
    listLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    listLabel.TextSize = 12
    listLabel.Font = Enum.Font.GothamBold
    listLabel.TextXAlignment = Enum.TextXAlignment.Center

    local keyList = Instance.new("ScrollingFrame")
    keyList.Parent = mainFrame
    keyList.Size = UDim2.new(0.9, 0, 0, 80)
    keyList.Position = UDim2.new(0.05, 0, 0, 265)
    keyList.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    keyList.BorderSizePixel = 0
    keyList.ScrollBarThickness = 4
    
    local listCorner = Instance.new("UICorner")
    listCorner.CornerRadius = UDim.new(0, 8)
    listCorner.Parent = keyList

    local listContainer = Instance.new("Frame")
    listContainer.Parent = keyList
    listContainer.Size = UDim2.new(1, 0, 0, 0)
    listContainer.BackgroundTransparency = 1

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
        CreateLoginGUI()
    end)

    -- ============================================
    -- ОБНОВЛЕНИЕ СПИСКА КЛЮЧЕЙ
    -- ============================================

    local function UpdateKeyList()
        listContainer:ClearAllChildren()
        local yPos = 5
        local count = 0
        
        for key, hwid in pairs(ActivatedKeys) do
            local label = Instance.new("TextLabel")
            label.Parent = listContainer
            label.Size = UDim2.new(1, 0, 0, 20)
            label.Position = UDim2.new(0, 0, 0, yPos)
            label.BackgroundTransparency = 1
            label.Text = key .. " → " .. string.sub(hwid, 1, 15) .. "..."
            label.TextColor3 = Color3.fromRGB(200, 200, 200)
            label.TextSize = 11
            label.Font = Enum.Font.Gotham
            label.TextXAlignment = Enum.TextXAlignment.Left
            yPos = yPos + 22
            count = count + 1
        end
        
        if count == 0 then
            local label = Instance.new("TextLabel")
            label.Parent = listContainer
            label.Size = UDim2.new(1, 0, 0, 20)
            label.Position = UDim2.new(0, 0, 0, 5)
            label.BackgroundTransparency = 1
            label.Text = "Нет активированных ключей"
            label.TextColor3 = Color3.fromRGB(150, 150, 150)
            label.TextSize = 12
            label.Font = Enum.Font.Gotham
            label.TextXAlignment = Enum.TextXAlignment.Center
            yPos = 30
        end
        
        listContainer.Size = UDim2.new(1, 0, 0, yPos + 10)
        keyList.CanvasSize = UDim2.new(0, 0, 0, yPos + 15)
    end

    -- ============================================
    -- ЛОГИКА СБРОСА
    -- ============================================

    resetBtn.MouseButton1Click:Connect(function()
        local key = resetBox.Text
        if key and key ~= "" then
            local success, msg = ResetKey(key)
            if success then
                statusLabel.Text = "✅ " .. msg
                statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                resetBox.Text = ""
                UpdateKeyList()
            else
                statusLabel.Text = "❌ " .. msg
                statusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
            end
            task.wait(2)
            statusLabel.Text = ""
        else
            statusLabel.Text = "❌ Введите ключ для сброса!"
            statusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
            task.wait(2)
            statusLabel.Text = ""
        end
    end)

    -- Обновляем список
    UpdateKeyList()
end

-- ============================================
-- ЗАПУСК
-- ============================================

print("🏆 HERRICRAFT HUB загружен!")
print("📌 Введите ключ для доступа")
CreateLoginGUI()
