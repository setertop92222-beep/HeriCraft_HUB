-- ============================================
-- [FPS] One Tap - ESP С РАЗДЕЛАМИ
-- ============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInput = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- ============================================
-- ЦВЕТА
-- ============================================

local COLORS = {
    Background = Color3.fromRGB(10, 10, 10),
    Dark = Color3.fromRGB(20, 20, 20),
    Border = Color3.fromRGB(255, 215, 0),
    Text = Color3.fromRGB(255, 215, 0),
    TextDark = Color3.fromRGB(150, 150, 150),
    Active = Color3.fromRGB(255, 215, 0),
    Inactive = Color3.fromRGB(60, 60, 60),
    
    -- Цвета для разных типов существ
    Enemy = Color3.fromRGB(255, 0, 0),
    Ally = Color3.fromRGB(0, 255, 0),
    Neutral = Color3.fromRGB(255, 255, 255),
    Yourself = Color3.fromRGB(0, 150, 255),
    Zombie = Color3.fromRGB(0, 255, 0),
    Monster = Color3.fromRGB(255, 0, 255),
    Boss = Color3.fromRGB(255, 215, 0),
    Animal = Color3.fromRGB(255, 165, 0),
    NPC = Color3.fromRGB(0, 255, 255),
    Unknown = Color3.fromRGB(128, 128, 128),
}

-- ============================================
-- НАСТРОЙКИ ESP
-- ============================================

local ESP_Settings = {
    Enabled = false,
    
    -- Игроки
    ShowEnemy = true,
    ShowAlly = true,
    ShowNeutral = true,
    ShowYourself = true,
    
    -- Монстры
    ShowZombie = true,
    ShowMonster = true,
    ShowBoss = true,
    ShowAnimal = true,
    
    -- NPC и другое
    ShowNPC = true,
    ShowUnknown = true,
}

-- ============================================
-- ПЕРЕМЕННЫЕ
-- ============================================

local espEnabled = false
local menuOpen = false
local espObjects = {}

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
-- ОПРЕДЕЛЕНИЕ ТИПА СУЩЕСТВА
-- ============================================

local function GetEntityType(obj)
    if not obj then return "Unknown" end
    
    local plr = Players:GetPlayerFromCharacter(obj)
    if plr then
        return "Player"
    end
    
    local name = obj.Name:lower()
    
    -- Зомби
    if name:find("zombie") or name:find("zomb") or name:find("walker") or 
       name:find("infected") or name:find("undead") then
        return "Zombie"
    end
    
    -- Монстры
    if name:find("monster") or name:find("demon") or name:find("devil") or
       name:find("creature") or name:find("beast") or name:find("horror") then
        return "Monster"
    end
    
    -- Боссы
    if name:find("boss") or name:find("king") or name:find("lord") or
       name:find("giant") or name:find("titan") or name:find("dragon") then
        return "Boss"
    end
    
    -- Животные
    if name:find("dog") or name:find("cat") or name:find("wolf") or
       name:find("bear") or name:find("deer") or name:find("rabbit") or
       name:find("horse") or name:find("cow") or name:find("chicken") or
       name:find("pig") or name:find("sheep") or name:find("fox") then
        return "Animal"
    end
    
    -- NPC
    if name:find("npc") or name:find("villager") or name:find("guard") or
       name:find("trader") or name:find("merchant") or name:find("citizen") or
       name:find("shop") or name:find("quest") then
        return "NPC"
    end
    
    if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") then
        return "Unknown"
    end
    
    return "Unknown"
end

-- ============================================
-- ПОЛУЧЕНИЕ ЦВЕТА ДЛЯ ТИПА
-- ============================================

local function GetEntityColor(obj)
    if not obj then return COLORS.Unknown end
    
    local entityType = GetEntityType(obj)
    
    if entityType == "Player" then
        local plr = Players:GetPlayerFromCharacter(obj)
        if plr then
            if plr == player then return COLORS.Yourself end
            if plr.Team and player.Team then
                if plr.Team == player.Team then return COLORS.Ally end
                return COLORS.Enemy
            end
            return COLORS.Neutral
        end
    end
    
    local typeColors = {
        Zombie = COLORS.Zombie,
        Monster = COLORS.Monster,
        Boss = COLORS.Boss,
        Animal = COLORS.Animal,
        NPC = COLORS.NPC,
        Unknown = COLORS.Unknown,
    }
    
    return typeColors[entityType] or COLORS.Unknown
end

-- ============================================
-- ПРОВЕРКА НУЖНО ЛИ ПОКАЗЫВАТЬ
-- ============================================

local function ShouldShowEntity(obj)
    if not obj then return false end
    if not ESP_Settings.Enabled then return false end
    
    local plr = Players:GetPlayerFromCharacter(obj)
    if plr then
        if plr == player then
            return ESP_Settings.ShowYourself
        end
        if plr.Team and player.Team then
            if plr.Team == player.Team then
                return ESP_Settings.ShowAlly
            else
                return ESP_Settings.ShowEnemy
            end
        end
        return ESP_Settings.ShowNeutral
    end
    
    local entityType = GetEntityType(obj)
    if entityType == "Zombie" then return ESP_Settings.ShowZombie end
    if entityType == "Monster" then return ESP_Settings.ShowMonster end
    if entityType == "Boss" then return ESP_Settings.ShowBoss end
    if entityType == "Animal" then return ESP_Settings.ShowAnimal end
    if entityType == "NPC" then return ESP_Settings.ShowNPC end
    if entityType == "Unknown" then return ESP_Settings.ShowUnknown end
    
    return false
end

-- ============================================
-- ПОИСК ВСЕХ СУЩЕСТВ
-- ============================================

local function FindAllEntities()
    local entities = {}
    local seen = {}
    
    -- Ищем игроков
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") then
            local char = plr.Character
            if not seen[char] then
                seen[char] = true
                table.insert(entities, char)
            end
        end
    end
    
    -- Ищем всех существ в workspace
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") then
            if not seen[obj] then
                -- Проверяем, не является ли игроком
                local isPlayer = Players:GetPlayerFromCharacter(obj)
                if not isPlayer then
                    seen[obj] = true
                    table.insert(entities, obj)
                end
            end
        end
    end
    
    return entities
end

-- ============================================
-- ESP ФУНКЦИИ
-- ============================================

local function clearESP()
    for _, v in ipairs(espObjects) do
        if v and v.Parent then
            v:Destroy()
        end
    end
    espObjects = {}
end

local function createESPForEntity(entity)
    if not entity then return end
    if not ESP_Settings.Enabled then return end
    if not ShouldShowEntity(entity) then return end
    if not entity:FindFirstChildOfClass("Humanoid") then return end
    
    if entity:FindFirstChild("EspBox") then
        entity.EspBox:Destroy()
    end
    
    local color = GetEntityColor(entity)
    
    -- Разный размер для разных типов
    local size = Vector3.new(4, 5, 1)
    local entityType = GetEntityType(entity)
    if entityType == "Unknown" or entityType == "Animal" then
        size = Vector3.new(2, 2, 1)
    end
    
    local esp = Instance.new("BoxHandleAdornment")
    esp.Adornee = entity
    esp.ZIndex = 0
    esp.Size = size
    esp.Transparency = 0.5
    esp.Color3 = color
    esp.AlwaysOnTop = true
    esp.Name = "EspBox"
    esp.Parent = entity
    table.insert(espObjects, esp)
end

local function updateESP()
    clearESP()
    if not ESP_Settings.Enabled then return end
    
    local entities = FindAllEntities()
    for _, entity in ipairs(entities) do
        if ShouldShowEntity(entity) then
            createESPForEntity(entity)
        end
    end
end

-- ============================================
-- МЕНЮ
-- ============================================

local function CreateESPMenu()
    for _, gui in ipairs(CoreGui:GetChildren()) do
        if gui.Name == "ESPSections" then
            gui:Destroy()
        end
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ESPSections"
    screenGui.Parent = CoreGui
    screenGui.ResetOnSpawn = false

    local mainFrame = CreateFrame(screenGui,
        UDim2.new(0, 320, 0, 420),
        UDim2.new(0.5, -160, 0.5, -210)
    )
    mainFrame.Visible = false

    CreateLabel(mainFrame,
        UDim2.new(1, 0, 0, 40),
        UDim2.new(0, 0, 0, 5),
        "👾 ESP С РАЗДЕЛАМИ",
        COLORS.Border,
        20
    )

    -- Главный переключатель ESP
    local mainBtn = CreateButton(mainFrame,
        UDim2.new(0.9, 0, 0, 30),
        UDim2.new(0.05, 0, 0, 50),
        "> ESP: ВЫКЛ"
    )
    mainBtn.TextColor3 = COLORS.Inactive
    mainBtn.BorderColor3 = COLORS.Inactive

    mainBtn.MouseButton1Click:Connect(function()
        ESP_Settings.Enabled = not ESP_Settings.Enabled
        if ESP_Settings.Enabled then
            mainBtn.Text = "> ESP: ВКЛ"
            mainBtn.TextColor3 = COLORS.Active
            mainBtn.BorderColor3 = COLORS.Active
            updateESP()
        else
            mainBtn.Text = "> ESP: ВЫКЛ"
            mainBtn.TextColor3 = COLORS.Inactive
            mainBtn.BorderColor3 = COLORS.Inactive
            clearESP()
        end
    end)

    -- Разделитель
    local divider = Instance.new("Frame")
    divider.Parent = mainFrame
    divider.Size = UDim2.new(0.9, 0, 0, 1)
    divider.Position = UDim2.new(0.05, 0, 0, 88)
    divider.BackgroundColor3 = COLORS.Border
    divider.BackgroundTransparency = 0.5

    CreateLabel(mainFrame,
        UDim2.new(0.9, 0, 0, 20),
        UDim2.new(0.05, 0, 0, 95),
        "👤 Игроки",
        COLORS.Text,
        14
    )

    -- Кнопки игроков
    local function createSectionButton(parent, yPos, text, settingKey, color)
        local btn = CreateButton(parent,
            UDim2.new(0.8, 0, 0, 28),
            UDim2.new(0.1, 0, 0, yPos),
            text .. " ✅"
        )
        btn.BackgroundColor3 = Color3.fromRGB(0, 180, 80)
        btn.BorderColor3 = COLORS.Border
        btn.TextColor3 = COLORS.Text
        
        btn.MouseButton1Click:Connect(function()
            ESP_Settings[settingKey] = not ESP_Settings[settingKey]
            if ESP_Settings[settingKey] then
                btn.Text = text .. " ✅"
                btn.BackgroundColor3 = Color3.fromRGB(0, 180, 80)
            else
                btn.Text = text .. " ❌"
                btn.BackgroundColor3 = COLORS.Dark
            end
            updateESP()
        end)
        return btn
    end

    createSectionButton(mainFrame, 120, "🔴 Враги", "ShowEnemy")
    createSectionButton(mainFrame, 153, "🟢 Союзники", "ShowAlly")
    createSectionButton(mainFrame, 186, "⚪ Нейтральные", "ShowNeutral")
    createSectionButton(mainFrame, 219, "🔵 Ты", "ShowYourself")

    -- Разделитель
    local divider2 = Instance.new("Frame")
    divider2.Parent = mainFrame
    divider2.Size = UDim2.new(0.9, 0, 0, 1)
    divider2.Position = UDim2.new(0.05, 0, 0, 255)
    divider2.BackgroundColor3 = COLORS.Border
    divider2.BackgroundTransparency = 0.5

    CreateLabel(mainFrame,
        UDim2.new(0.9, 0, 0, 20),
        UDim2.new(0.05, 0, 0, 262),
        "👾 Монстры",
        COLORS.Text,
        14
    )

    createSectionButton(mainFrame, 287, "🧟 Зомби", "ShowZombie")
    createSectionButton(mainFrame, 320, "👹 Монстры", "ShowMonster")
    createSectionButton(mainFrame, 353, "👑 Боссы", "ShowBoss")
    createSectionButton(mainFrame, 386, "🐾 Животные", "ShowAnimal")

    -- Кнопка закрытия
    local closeBtn = CreateButton(mainFrame,
        UDim2.new(0, 28, 0, 28),
        UDim2.new(1, -33, 0, 5),
        "✕",
        function()
            mainFrame.Visible = false
            menuOpen = false
            if circleBtn then
                circleBtn.Text = "ESP"
                circleBtn.BorderColor3 = COLORS.Border
                circleBtn.TextColor3 = COLORS.TextDark
            end
        end
    )
    closeBtn.BackgroundColor3 = COLORS.Background
    closeBtn.BorderColor3 = Color3.fromRGB(255, 50, 50)
    closeBtn.TextColor3 = Color3.fromRGB(255, 50, 50)

    -- КРУЖОК
    local circleGui = Instance.new("ScreenGui")
    circleGui.Name = "ESPSectionsCircle"
    circleGui.Parent = CoreGui
    circleGui.ResetOnSpawn = false

    local circleBtn = Instance.new("TextButton")
    circleBtn.Size = UDim2.new(0, 50, 0, 50)
    circleBtn.Position = UDim2.new(0, 10, 0, 250)
    circleBtn.BackgroundColor3 = COLORS.Background
    circleBtn.BackgroundTransparency = 0
    circleBtn.BorderSizePixel = 2
    circleBtn.BorderColor3 = COLORS.Border
    circleBtn.Text = "ESP"
    circleBtn.TextColor3 = COLORS.TextDark
    circleBtn.TextSize = 11
    circleBtn.Font = Enum.Font.GothamBold
    circleBtn.TextScaled = true
    circleBtn.Draggable = true
    circleBtn.ClipsDescendants = true
    circleBtn.Parent = circleGui

    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = circleBtn

    -- Перетаскивание
    local dragging = false
    local dragStart = nil
    local startPos = nil

    circleBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = circleBtn.Position
        end
    end)

    circleBtn.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            circleBtn.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    circleBtn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    circleBtn.MouseButton1Click:Connect(function()
        menuOpen = not menuOpen
        mainFrame.Visible = menuOpen
        if menuOpen then
            circleBtn.Text = "MENU"
            circleBtn.BorderColor3 = COLORS.Active
            circleBtn.TextColor3 = COLORS.Active
        else
            circleBtn.Text = "ESP"
            circleBtn.BorderColor3 = COLORS.Border
            circleBtn.TextColor3 = COLORS.TextDark
        end
    end)

    -- Анимация
    mainFrame.BackgroundTransparency = 1
    local tween = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0
    })
    tween:Play()
end

-- ============================================
-- АВТООБНОВЛЕНИЕ
-- ============================================

RunService.Heartbeat:Connect(function()
    if ESP_Settings.Enabled then
        updateESP()
    end
end)

-- ============================================
-- ЗАПУСК
-- ============================================

print("👾 ESP С РАЗДЕЛАМИ загружен!")
print("📌 Кружок ESP → открыть меню")
print("📌 Включай разделы по отдельности")

CreateESPMenu()
