-- ============================================
-- ESP С РАЗДЕЛАМИ (BY: HERICRAFT)
-- ============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInput = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- ============================================
-- ПЕРЕМЕННЫЕ
-- ============================================

local espEnabled = false
local menuOpen = false

local espObjects = {}

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
-- ЦВЕТА
-- ============================================

local Colors = {
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
-- ОПРЕДЕЛЕНИЕ ТИПА
-- ============================================

local function GetEntityType(obj)
    if not obj then return "Unknown" end
    
    local plr = Players:GetPlayerFromCharacter(obj)
    if plr then return "Player" end
    
    local name = obj.Name:lower()
    
    if name:find("zombie") or name:find("zomb") or name:find("walker") or 
       name:find("infected") or name:find("undead") then return "Zombie" end
    
    if name:find("monster") or name:find("demon") or name:find("devil") or
       name:find("creature") or name:find("beast") or name:find("horror") then return "Monster" end
    
    if name:find("boss") or name:find("king") or name:find("lord") or
       name:find("giant") or name:find("titan") or name:find("dragon") then return "Boss" end
    
    if name:find("dog") or name:find("cat") or name:find("wolf") or
       name:find("bear") or name:find("deer") or name:find("rabbit") or
       name:find("horse") or name:find("cow") or name:find("chicken") or
       name:find("pig") or name:find("sheep") or name:find("fox") then return "Animal" end
    
    if name:find("npc") or name:find("villager") or name:find("guard") or
       name:find("trader") or name:find("merchant") or name:find("citizen") or
       name:find("shop") or name:find("quest") then return "NPC" end
    
    if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") then return "Unknown" end
    
    return "Unknown"
end

-- ============================================
-- ПОЛУЧЕНИЕ ЦВЕТА
-- ============================================

local function GetEntityColor(obj)
    if not obj then return Colors.Unknown end
    
    local entityType = GetEntityType(obj)
    
    if entityType == "Player" then
        local plr = Players:GetPlayerFromCharacter(obj)
        if plr then
            if plr == player then return Colors.Yourself end
            if plr.Team and player.Team then
                if plr.Team == player.Team then return Colors.Ally end
                return Colors.Enemy
            end
            return Colors.Neutral
        end
    end
    
    local typeColors = {
        Zombie = Colors.Zombie,
        Monster = Colors.Monster,
        Boss = Colors.Boss,
        Animal = Colors.Animal,
        NPC = Colors.NPC,
        Unknown = Colors.Unknown,
    }
    
    return typeColors[entityType] or Colors.Unknown
end

-- ============================================
-- ПРОВЕРКА ПОКАЗА
-- ============================================

local function ShouldShowEntity(obj)
    if not obj then return false end
    if not ESP_Settings.Enabled then return false end
    
    local plr = Players:GetPlayerFromCharacter(obj)
    if plr then
        if plr == player then return ESP_Settings.ShowYourself end
        if plr.Team and player.Team then
            if plr.Team == player.Team then return ESP_Settings.ShowAlly end
            return ESP_Settings.ShowEnemy
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
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") then
            table.insert(entities, plr.Character)
        end
    end
    
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") then
            if not Players:GetPlayerFromCharacter(obj) then
                local alreadyAdded = false
                for _, existing in ipairs(entities) do
                    if existing == obj then
                        alreadyAdded = true
                        break
                    end
                end
                if not alreadyAdded then
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
    
    local esp = Instance.new("BoxHandleAdornment")
    esp.Adornee = entity
    esp.ZIndex = 0
    esp.Size = Vector3.new(4, 5, 1)
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
-- GUI МЕНЮ
-- ============================================

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ESP_Menu"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 230, 0, 480)
mainFrame.Position = UDim2.new(0.5, -115, 0.5, -240)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
mainFrame.BackgroundTransparency = 0
mainFrame.Visible = false
mainFrame.Draggable = true
mainFrame.Active = true

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Parent = mainFrame
title.Size = UDim2.new(1, 0, 0, 35)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "BY: HERICRAFT"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Center

local dragHandle = Instance.new("Frame")
dragHandle.Parent = mainFrame
dragHandle.Size = UDim2.new(1, -45, 0, 35)
dragHandle.Position = UDim2.new(0, 0, 0, 0)
dragHandle.BackgroundTransparency = 1
dragHandle.Active = true
dragHandle.Draggable = true

local closeBtn = Instance.new("ImageButton")
closeBtn.Parent = mainFrame
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -33, 0, 4)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
closeBtn.BorderSizePixel = 0
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

local closeIcon = Instance.new("TextLabel")
closeIcon.Parent = closeBtn
closeIcon.Size = UDim2.new(1, 0, 1, 0)
closeIcon.BackgroundTransparency = 1
closeIcon.Text = "✕"
closeIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
closeIcon.TextSize = 14
closeIcon.Font = Enum.Font.GothamBold
closeIcon.TextXAlignment = Enum.TextXAlignment.Center
closeIcon.TextYAlignment = Enum.TextYAlignment.Center

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    menuOpen = false
    if espCircleBtn then
        espCircleBtn.Text = "HC"
        espCircleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    end
end)

-- ============================================
-- КНОПКИ
-- ============================================

local function createToggleButton(parent, yPos, text, settingKey)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.Size = UDim2.new(0.9, 0, 0, 26)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(0, 180, 80)
    btn.BorderSizePixel = 0
    btn.Text = text .. " ✅"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamMedium
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        ESP_Settings[settingKey] = not ESP_Settings[settingKey]
        if ESP_Settings[settingKey] then
            btn.BackgroundColor3 = Color3.fromRGB(0, 180, 80)
            btn.Text = text .. " ✅"
        else
            btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
            btn.Text = text .. " ❌"
        end
        updateESP()
    end)
    
    return btn
end

-- ============================================
-- ГЛАВНАЯ КНОПКА
-- ============================================

local mainToggleBtn = Instance.new("TextButton")
mainToggleBtn.Parent = mainFrame
mainToggleBtn.Size = UDim2.new(0.9, 0, 0, 32)
mainToggleBtn.Position = UDim2.new(0.05, 0, 0, 45)
mainToggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
mainToggleBtn.BorderSizePixel = 0
mainToggleBtn.Text = "🔴 ESP (Выкл)"
mainToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
mainToggleBtn.TextSize = 14
mainToggleBtn.Font = Enum.Font.GothamBold

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainToggleBtn

mainToggleBtn.MouseButton1Click:Connect(function()
    ESP_Settings.Enabled = not ESP_Settings.Enabled
    if ESP_Settings.Enabled then
        mainToggleBtn.Text = "🟢 ESP (Вкл)"
        mainToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 80)
        updateESP()
        print("✅ ESP ВКЛЮЧЕН")
    else
        mainToggleBtn.Text = "🔴 ESP (Выкл)"
        mainToggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
        clearESP()
        print("❌ ESP ВЫКЛЮЧЕН")
    end
end)

-- ============================================
-- РАЗДЕЛЫ
-- ============================================

-- Разделитель 1
local divider1 = Instance.new("Frame")
divider1.Parent = mainFrame
divider1.Size = UDim2.new(0.9, 0, 0, 1)
divider1.Position = UDim2.new(0.05, 0, 0, 85)
divider1.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
divider1.BorderSizePixel = 0

local playerLabel = Instance.new("TextLabel")
playerLabel.Parent = mainFrame
playerLabel.Size = UDim2.new(0.9, 0, 0, 20)
playerLabel.Position = UDim2.new(0.05, 0, 0, 93)
playerLabel.BackgroundTransparency = 1
playerLabel.Text = "👤 Игроки"
playerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
playerLabel.TextSize = 12
playerLabel.Font = Enum.Font.GothamBold
playerLabel.TextXAlignment = Enum.TextXAlignment.Left

createToggleButton(mainFrame, 118, "🔴 Враги", "ShowEnemy")
createToggleButton(mainFrame, 148, "🟢 Союзники", "ShowAlly")
createToggleButton(mainFrame, 178, "⚪ Нейтральные", "ShowNeutral")
createToggleButton(mainFrame, 208, "🔵 Ты", "ShowYourself")

-- Разделитель 2
local divider2 = Instance.new("Frame")
divider2.Parent = mainFrame
divider2.Size = UDim2.new(0.9, 0, 0, 1)
divider2.Position = UDim2.new(0.05, 0, 0, 242)
divider2.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
divider2.BorderSizePixel = 0

local monsterLabel = Instance.new("TextLabel")
monsterLabel.Parent = mainFrame
monsterLabel.Size = UDim2.new(0.9, 0, 0, 20)
monsterLabel.Position = UDim2.new(0.05, 0, 0, 250)
monsterLabel.BackgroundTransparency = 1
monsterLabel.Text = "👾 Монстры"
monsterLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
monsterLabel.TextSize = 12
monsterLabel.Font = Enum.Font.GothamBold
monsterLabel.TextXAlignment = Enum.TextXAlignment.Left

createToggleButton(mainFrame, 275, "🧟 Зомби", "ShowZombie")
createToggleButton(mainFrame, 305, "👹 Монстры", "ShowMonster")
createToggleButton(mainFrame, 335, "👑 Боссы", "ShowBoss")
createToggleButton(mainFrame, 365, "🐾 Животные", "ShowAnimal")

-- Разделитель 3
local divider3 = Instance.new("Frame")
divider3.Parent = mainFrame
divider3.Size = UDim2.new(0.9, 0, 0, 1)
divider3.Position = UDim2.new(0.05, 0, 0, 399)
divider3.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
divider3.BorderSizePixel = 0

local npcLabel = Instance.new("TextLabel")
npcLabel.Parent = mainFrame
npcLabel.Size = UDim2.new(0.9, 0, 0, 20)
npcLabel.Position = UDim2.new(0.05, 0, 0, 407)
npcLabel.BackgroundTransparency = 1
npcLabel.Text = "🗣️ NPC и другое"
npcLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
npcLabel.TextSize = 12
npcLabel.Font = Enum.Font.GothamBold
npcLabel.TextXAlignment = Enum.TextXAlignment.Left

createToggleButton(mainFrame, 432, "🗣️ NPC", "ShowNPC")
createToggleButton(mainFrame, 462, "❓ Неизвестно", "ShowUnknown")

-- ============================================
-- КРУЖОК HC
-- ============================================

local circleGui = Instance.new("ScreenGui")
circleGui.Name = "CircleMenu"
circleGui.Parent = CoreGui
circleGui.ResetOnSpawn = false

local espCircleBtn = Instance.new("TextButton")
espCircleBtn.Size = UDim2.new(0, 50, 0, 50)
espCircleBtn.Position = UDim2.new(0, 10, 0, 250)
espCircleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
espCircleBtn.BorderSizePixel = 2
espCircleBtn.BorderColor3 = Color3.fromRGB(255, 255, 255)
espCircleBtn.Text = "HC"
espCircleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
espCircleBtn.TextSize = 14
espCircleBtn.Font = Enum.Font.GothamBold
espCircleBtn.TextScaled = true
espCircleBtn.Draggable = true
espCircleBtn.ClipsDescendants = true
espCircleBtn.Parent = circleGui

local circleCorner = Instance.new("UICorner")
circleCorner.CornerRadius = UDim.new(1, 0)
circleCorner.Parent = espCircleBtn

-- Перетаскивание
local dragging = false
local dragStart = nil
local startPos = nil

espCircleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = espCircleBtn.Position
    end
end)

espCircleBtn.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        espCircleBtn.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

espCircleBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- ============================================
-- ОТКРЫТИЕ/ЗАКРЫТИЕ
-- ============================================

espCircleBtn.MouseButton1Click:Connect(function()
    menuOpen = not menuOpen
    mainFrame.Visible = menuOpen
    
    if menuOpen then
        espCircleBtn.Text = "HC"
        espCircleBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    else
        espCircleBtn.Text = "HC"
        espCircleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    end
end)

UserInput.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.P then
        mainFrame.Visible = not mainFrame.Visible
        menuOpen = mainFrame.Visible
        
        if menuOpen then
            espCircleBtn.Text = "HC"
            espCircleBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        else
            espCircleBtn.Text = "HC"
            espCircleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        end
    end
end)

-- ============================================
-- АВТООБНОВЛЕНИЕ
-- ============================================

Players.PlayerAdded:Connect(function()
    task.wait(0.5)
    if ESP_Settings.Enabled then updateESP() end
end)

Players.PlayerRemoving:Connect(function()
    task.wait(0.5)
    if ESP_Settings.Enabled then updateESP() end
end)

player.CharacterAdded:Connect(function()
    task.wait(1)
    if ESP_Settings.Enabled then updateESP() end
end)

Workspace.ChildAdded:Connect(function()
    if ESP_Settings.Enabled then
        task.wait(0.5)
        updateESP()
    end
end)

local updateTimer = 0
RunService.Heartbeat:Connect(function()
    if not ESP_Settings.Enabled then return end
    
    updateTimer = updateTimer + 1
    if updateTimer >= 120 then
        updateTimer = 0
        updateESP()
    end
end)

print("🎯 ESP с разделами загружен!")
print("📌 Кружок HC → открыть/закрыть меню")
