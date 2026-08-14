-- ============================================
--          🏆 HERRICRAFT HUB 🏆
-- ============================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInput = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

-- ============================================
-- ПЕРЕМЕННЫЕ
-- ============================================

local correctCode = "2026"
local loginScreenGui = nil
local scriptMenuScreenGui = nil
local isScriptLoaded = false

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
-- МЕНЮ 2: СПИСОК СКРИПТОВ
-- ============================================

local function CreateScriptMenu()
    if scriptMenuScreenGui then
        scriptMenuScreenGui:Destroy()
        scriptMenuScreenGui = nil
    end
    
    scriptMenuScreenGui = Instance.new("ScreenGui")
    scriptMenuScreenGui.Name = "HerricraftScriptMenu"
    scriptMenuScreenGui.Parent = CoreGui
    scriptMenuScreenGui.ResetOnSpawn = false
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Parent = scriptMenuScreenGui
    mainFrame.Size = UDim2.new(0, 450, 0, 350)
    mainFrame.Position = UDim2.new(0.5, -225, 0.5, -175)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 16)
    corner.Parent = mainFrame
    
    -- Обводка
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
    
    -- Контейнер
    local scriptContainer = Instance.new("Frame")
    scriptContainer.Parent = mainFrame
    scriptContainer.Size = UDim2.new(1, -40, 0, 200)
    scriptContainer.Position = UDim2.new(0, 20, 0, 80)
    scriptContainer.BackgroundTransparency = 1
    
    -- Кнопка закрытия (крестик)
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
        if scriptMenuScreenGui then
            scriptMenuScreenGui:Destroy()
            scriptMenuScreenGui = nil
        end
    end)
    
    -- ============================================
    -- ФУНКЦИЯ СОЗДАНИЯ КНОПКИ СКРИПТА
    -- ============================================
    
    local function CreateScriptButton(parent, yPos, icon, name, description, callback)
        local btn = Instance.new("TextButton")
        btn.Parent = parent
        btn.Size = UDim2.new(1, 0, 0, 55)
        btn.Position = UDim2.new(0, 0, 0, yPos)
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        btn.BorderSizePixel = 0
        btn.Text = ""
        
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
        iconLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
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
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.TextSize = 16
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        -- Описание
        local descLabel = Instance.new("TextLabel")
        descLabel.Parent = btn
        descLabel.Size = UDim2.new(1, -60, 0, 18)
        descLabel.Position = UDim2.new(0, 55, 0, 28)
        descLabel.BackgroundTransparency = 1
        descLabel.Text = description
        descLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        descLabel.TextSize = 12
        descLabel.Font = Enum.Font.Gotham
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        -- Статус
        local statusLabel = Instance.new("TextLabel")
        statusLabel.Parent = btn
        statusLabel.Size = UDim2.new(0, 60, 0, 20)
        statusLabel.Position = UDim2.new(1, -65, 0, 17)
        statusLabel.BackgroundTransparency = 1
        statusLabel.Text = "▶️ Запуск"
        statusLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
        statusLabel.TextSize = 11
        statusLabel.Font = Enum.Font.Gotham
        statusLabel.TextXAlignment = Enum.TextXAlignment.Center
        
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
                BackgroundColor3 = Color3.fromRGB(45, 45, 50)
            }):Play()
        end)
        
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
                BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            }):Play()
        end)
        
        btn.MouseButton1Click:Connect(function()
            statusLabel.Text = "⏳ Загрузка..."
            statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
            
            task.wait(0.3)
            
            -- Закрываем меню скриптов и запускаем скрипт
            CloseGUI(scriptMenuScreenGui, function()
                callback()
            end)
        end)
        
        return btn
    end

    -- ============================================
    -- СКРИПТ 1: ESP С РАЗДЕЛАМИ
    -- ============================================

    local function LoadESPScript()
        if isScriptLoaded then return end
        isScriptLoaded = true
        
        print("🚀 Загрузка ESP С РАЗДЕЛАМИ...")
        
        loadstring([[
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
            local flyEnabled = false
            local menuOpen = false

            local espObjects = {}
            local flyConnection = nil
            local flyBodyVelocity = nil
            local flyBodyGyro = nil

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
            -- ЦВЕТА ДЛЯ ВСЕХ ТИПОВ
            -- ============================================

            local Colors = {
                -- Игроки
                Enemy = Color3.fromRGB(255, 0, 0),
                Ally = Color3.fromRGB(0, 255, 0),
                Neutral = Color3.fromRGB(255, 255, 255),
                Yourself = Color3.fromRGB(0, 150, 255),
                
                -- Монстры
                Zombie = Color3.fromRGB(0, 255, 0),
                Monster = Color3.fromRGB(255, 0, 255),
                Boss = Color3.fromRGB(255, 215, 0),
                Animal = Color3.fromRGB(255, 165, 0),
                
                -- NPC
                NPC = Color3.fromRGB(0, 255, 255),
                Unknown = Color3.fromRGB(128, 128, 128),
            }

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
                
                if name:find("zombie") or name:find("zomb") or name:find("walker") or 
                   name:find("infected") or name:find("undead") then
                    return "Zombie"
                end
                
                if name:find("monster") or name:find("demon") or name:find("devil") or
                   name:find("creature") or name:find("beast") or name:find("horror") then
                    return "Monster"
                end
                
                if name:find("boss") or name:find("king") or name:find("lord") or
                   name:find("giant") or name:find("titan") or name:find("dragon") then
                    return "Boss"
                end
                
                if name:find("dog") or name:find("cat") or name:find("wolf") or
                   name:find("bear") or name:find("deer") or name:find("rabbit") or
                   name:find("horse") or name:find("cow") or name:find("chicken") or
                   name:find("pig") or name:find("sheep") or name:find("fox") then
                    return "Animal"
                end
                
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
            -- FLY (ПОЛЕТ)
            -- ============================================

            local function cleanFlyParts()
                if flyBodyVelocity then
                    flyBodyVelocity:Destroy()
                    flyBodyVelocity = nil
                end
                if flyBodyGyro then
                    flyBodyGyro:Destroy()
                    flyBodyGyro = nil
                end
            end

            local function startFly()
                if flyConnection then
                    flyConnection:Disconnect()
                    flyConnection = nil
                end
                
                cleanFlyParts()
                
                local char = player.Character
                if not char then return end
                
                local hum = char:FindFirstChild("Humanoid")
                local rootPart = char:FindFirstChild("HumanoidRootPart")
                if not hum or not rootPart then return end
                
                flyBodyVelocity = Instance.new("BodyVelocity")
                flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
                flyBodyVelocity.MaxForce = Vector3.new(1, 1, 1) * 100000
                flyBodyVelocity.Parent = rootPart
                
                flyBodyGyro = Instance.new("BodyGyro")
                flyBodyGyro.P = 10000
                flyBodyGyro.D = 1000
                flyBodyGyro.MaxTorque = Vector3.new(1, 1, 1) * 100000
                flyBodyGyro.CFrame = rootPart.CFrame
                flyBodyGyro.Parent = rootPart
                
                hum.PlatformStand = true
                
                flyConnection = RunService.Heartbeat:Connect(function()
                    if not flyEnabled then
                        return
                    end
                    
                    local char = player.Character
                    if not char then return end
                    
                    local rootPart = char:FindFirstChild("HumanoidRootPart")
                    if not rootPart then return end
                    
                    if not flyBodyVelocity or not flyBodyGyro then
                        return
                    end
                    
                    local moveDirection = Vector3.new()
                    local forward = camera.CFrame.LookVector
                    local right = camera.CFrame.RightVector
                    local up = camera.CFrame.UpVector
                    
                    if UserInput:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection = moveDirection + forward
                    end
                    if UserInput:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection = moveDirection - forward
                    end
                    if UserInput:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection = moveDirection - right
                    end
                    if UserInput:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection = moveDirection + right
                    end
                    if UserInput:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection = moveDirection + up
                    end
                    if UserInput:IsKeyDown(Enum.KeyCode.LeftControl) then
                        moveDirection = moveDirection - up
                    end
                    
                    local speed = 50
                    if moveDirection.Magnitude > 0 then
                        moveDirection = moveDirection.Unit * speed
                        flyBodyVelocity.Velocity = moveDirection
                        flyBodyGyro.CFrame = CFrame.lookAt(rootPart.Position, rootPart.Position + forward)
                    else
                        flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
                    end
                end)
            end

            local function stopFly()
                if flyConnection then
                    flyConnection:Disconnect()
                    flyConnection = nil
                end
                
                cleanFlyParts()
                
                local char = player.Character
                if char then
                    local hum = char:FindFirstChild("Humanoid")
                    if hum then
                        hum.PlatformStand = false
                    end
                end
            end

            local function toggleFly()
                flyEnabled = not flyEnabled
                if flyEnabled then
                    startFly()
                    print("✈️ Fly ВКЛЮЧЕН")
                else
                    stopFly()
                    print("✈️ Fly ВЫКЛЮЧЕН")
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
            mainFrame.Name = "MainFrame"
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

            -- КРЕСТИК
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
            -- СОЗДАНИЕ КНОПОК-ПЕРЕКЛЮЧАТЕЛЕЙ
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
            -- КНОПКА ВКЛЮЧЕНИЯ ESP (ГЛАВНАЯ)
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
            -- РАЗДЕЛ 1: ИГРОКИ
            -- ============================================

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

            local enemyBtn = createToggleButton(mainFrame, 118, "🔴 Враги", "ShowEnemy")
            local allyBtn = createToggleButton(mainFrame, 148, "🟢 Союзники", "ShowAlly")
            local neutralBtn = createToggleButton(mainFrame, 178, "⚪ Нейтральные", "ShowNeutral")
            local yourselfBtn = createToggleButton(mainFrame, 208, "🔵 Ты", "ShowYourself")

            -- ============================================
            -- РАЗДЕЛ 2: МОНСТРЫ
            -- ============================================

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

            local zombieBtn = createToggleButton(mainFrame, 275, "🧟 Зомби", "ShowZombie")
            local monsterBtn = createToggleButton(mainFrame, 305, "👹 Монстры", "ShowMonster")
            local bossBtn = createToggleButton(mainFrame, 335, "👑 Боссы", "ShowBoss")
            local animalBtn = createToggleButton(mainFrame, 365, "🐾 Животные", "ShowAnimal")

            -- ============================================
            -- РАЗДЕЛ 3: NPC И ДРУГОЕ
            -- ============================================

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

            local npcBtn = createToggleButton(mainFrame, 432, "🗣️ NPC", "ShowNPC")
            local unknownBtn = createToggleButton(mainFrame, 462, "❓ Неизвестно", "ShowUnknown")

            -- ============================================
            -- FLY КНОПКА
            -- ============================================

            local flyBtn = Instance.new("TextButton")
            flyBtn.Parent = mainFrame
            flyBtn.Size = UDim2.new(0.9, 0, 0, 26)
            flyBtn.Position = UDim2.new(0.05, 0, 0, 495)
            flyBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
            flyBtn.BorderSizePixel = 0
            flyBtn.Text = "🟠 Fly ❌"
            flyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            flyBtn.TextSize = 12
            flyBtn.Font = Enum.Font.GothamMedium

            local flyCorner = Instance.new("UICorner")
            flyCorner.CornerRadius = UDim.new(0, 6)
            flyCorner.Parent = flyBtn

            flyBtn.MouseButton1Click:Connect(function()
                toggleFly()
                if flyEnabled then
                    flyBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
                    flyBtn.Text = "🟢 Fly ✅"
                else
                    flyBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
                    flyBtn.Text = "🟠 Fly ❌"
                end
            end)

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
            -- ОТКРЫТИЕ/ЗАКРЫТИЕ МЕНЮ
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

            -- ============================================
            -- КЛАВИША P
            -- ============================================

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
                if flyEnabled then
                    stopFly()
                    task.wait(0.5)
                    startFly()
                end
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

            print("🟢 BY: HERICRAFT - ESP с разделами + Fly загружены!")
            print("📌 Разделы ESP:")
            print("   👤 Игроки: враги, союзники, нейтральные, ты")
            print("   👾 Монстры: зомби, монстры, боссы, животные")
            print("   🗣️ NPC и другое: NPC, неизвестно")
            print("📌 Кружок HC → открыть/закрыть меню")
            print("📌 Fly: WASD + Space(вверх) + Ctrl(вниз)")
        ]])()
    end

    -- ============================================
    -- СКРИПТ 2: ТОЛЬКО AIMBOT
    -- ============================================

    local function LoadAimbotOnlyScript()
        if isScriptLoaded then return end
        isScriptLoaded = true
        
        print("🚀 Загрузка ТОЛЬКО AIMBOT...")
        
        loadstring([[
            -- ============================================
            -- ТОЛЬКО AIMBOT (BY: HERICRAFT)
            -- ============================================

            local Players = game:GetService("Players")
            local RunService = game:GetService("RunService")
            local CoreGui = game:GetService("CoreGui")
            local UserInput = game:GetService("UserInputService")
            local Workspace = game:GetService("Workspace")

            local player = Players.LocalPlayer
            local camera = workspace.CurrentCamera
            local mouse = player:GetMouse()

            -- ============================================
            -- ПЕРЕМЕННЫЕ
            -- ============================================

            local aimbotEnabled = false
            local menuOpen = false

            local aimbotBtn = nil

            -- ============================================
            -- НАСТРОЙКИ
            -- ============================================

            _G.FREE_FOR_ALL = true
            _G.AIM_AT = "Head"

            -- ============================================
            -- ФУНКЦИЯ ПОЛУЧЕНИЯ БЛИЖАЙШЕГО ИГРОКА
            -- ============================================

            local function GetNearestPlayerToMouse()
                local players = {}
                local playerHold = {}
                local distances = {}
                
                for i, v in pairs(Players:GetPlayers()) do
                    if v ~= player then
                        table.insert(players, v)
                    end
                end
                
                for i, v in pairs(players) do
                    if not v.Character then continue end
                    if not v.Character:FindFirstChild(_G.AIM_AT) then continue end
                    
                    if _G.FREE_FOR_ALL == false then
                        if v.TeamColor == player.TeamColor then continue end
                    end
                    
                    local aim = v.Character:FindFirstChild(_G.AIM_AT)
                    if aim then
                        local distance = (aim.Position - camera.CFrame.Position).magnitude
                        local ray = Ray.new(camera.CFrame.Position, (mouse.Hit.p - camera.CFrame.Position).unit * distance)
                        local hit, pos = Workspace:FindPartOnRay(ray, Workspace)
                        local diff = math.floor((pos - aim.Position).magnitude)
                        playerHold[v.Name .. i] = {}
                        playerHold[v.Name .. i].dist = distance
                        playerHold[v.Name .. i].plr = v
                        playerHold[v.Name .. i].diff = diff
                        table.insert(distances, diff)
                    end
                end
                
                if #distances == 0 then
                    return false
                end
                
                local lDistance = math.floor(math.min(unpack(distances)))
                if lDistance > 20 then
                    return false
                end
                
                for i, v in pairs(playerHold) do
                    if v.diff == lDistance then
                        return v.plr
                    end
                end
                
                return false
            end

            -- ============================================
            -- AIMBOT (ПРАВАЯ КНОПКА МЫШИ)
            -- ============================================

            local isAiming = false

            UserInput.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                
                if aimbotEnabled and input.UserInputType == Enum.UserInputType.MouseButton2 then
                    isAiming = true
                end
            end)

            UserInput.InputEnded:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                
                if aimbotEnabled and input.UserInputType == Enum.UserInputType.MouseButton2 then
                    isAiming = false
                end
            end)

            -- ============================================
            -- ОСНОВНОЙ ЦИКЛ AIMBOT
            -- ============================================

            RunService.RenderStepped:Connect(function()
                if aimbotEnabled and isAiming then
                    local target = GetNearestPlayerToMouse()
                    if target and target.Character then
                        local aimPart = target.Character:FindFirstChild(_G.AIM_AT)
                        if aimPart then
                            camera.CFrame = CFrame.new(camera.CFrame.Position, aimPart.CFrame.Position)
                        end
                    end
                end
            end)

            -- ============================================
            -- СМЕНА ЦЕЛИ ПО КЛАВИШЕ K
            -- ============================================

            UserInput.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                if input.KeyCode == Enum.KeyCode.K then
                    if _G.AIM_AT == "Head" then
                        _G.AIM_AT = "Torso"
                        print("🎯 Цель: TORSO")
                    else
                        _G.AIM_AT = "Head"
                        print("🎯 Цель: HEAD")
                    end
                end
            end)

            -- ============================================
            -- GUI МЕНЮ
            -- ============================================

            local screenGui = Instance.new("ScreenGui")
            screenGui.Name = "Aimbot_Menu"
            screenGui.Parent = CoreGui
            screenGui.ResetOnSpawn = false

            local mainFrame = Instance.new("Frame")
            mainFrame.Name = "MainFrame"
            mainFrame.Parent = screenGui
            mainFrame.Size = UDim2.new(0, 200, 0, 150)
            mainFrame.Position = UDim2.new(0.5, -100, 0.5, -75)
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
            title.Text = "🎯 AIMBOT"
            title.TextColor3 = Color3.fromRGB(255, 215, 0)
            title.TextSize = 18
            title.Font = Enum.Font.GothamBold
            title.TextXAlignment = Enum.TextXAlignment.Center

            local dragHandle = Instance.new("Frame")
            dragHandle.Parent = mainFrame
            dragHandle.Size = UDim2.new(1, -45, 0, 35)
            dragHandle.Position = UDim2.new(0, 0, 0, 0)
            dragHandle.BackgroundTransparency = 1
            dragHandle.Active = true
            dragHandle.Draggable = true

            -- КРЕСТИК
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
                if aimbotCircleBtn then
                    aimbotCircleBtn.Text = "AIM"
                    aimbotCircleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
                end
            end)

            -- ============================================
            -- КНОПКА AIMBOT
            -- ============================================

            local function createButton(parent, yPos, text)
                local btn = Instance.new("TextButton")
                btn.Parent = parent
                btn.Size = UDim2.new(0.9, 0, 0, 32)
                btn.Position = UDim2.new(0.05, 0, 0, yPos)
                btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
                btn.BorderSizePixel = 0
                btn.Text = text
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                btn.TextSize = 13
                btn.Font = Enum.Font.GothamMedium
                
                local btnCorner = Instance.new("UICorner")
                btnCorner.CornerRadius = UDim.new(0, 8)
                btnCorner.Parent = btn
                
                return btn
            end

            aimbotBtn = createButton(mainFrame, 45, "🎯 Aimbot (Выкл)")

            -- ============================================
            -- ЛОГИКА КНОПКИ
            -- ============================================

            aimbotBtn.MouseButton1Click:Connect(function()
                aimbotEnabled = not aimbotEnabled
                if aimbotEnabled then
                    aimbotBtn.Text = "🎯 Aimbot (Вкл)"
                    aimbotBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
                    print("🎯 Aimbot ВКЛЮЧЕН (ПКМ)")
                else
                    aimbotBtn.Text = "🎯 Aimbot (Выкл)"
                    aimbotBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
                    print("🎯 Aimbot ВЫКЛЮЧЕН")
                end
            end)

            -- ============================================
            -- ИНФО
            -- ============================================

            local infoLabel = Instance.new("TextLabel")
            infoLabel.Parent = mainFrame
            infoLabel.Size = UDim2.new(0.9, 0, 0, 35)
            infoLabel.Position = UDim2.new(0.05, 0, 0, 90)
            infoLabel.BackgroundTransparency = 1
            infoLabel.Text = "🖱️ ПКМ → наведение\n⌨️ K → смена цели"
            infoLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
            infoLabel.TextSize = 11
            infoLabel.Font = Enum.Font.Gotham
            infoLabel.TextXAlignment = Enum.TextXAlignment.Center
            infoLabel.TextYAlignment = Enum.TextYAlignment.Center

            -- ============================================
            -- КРУЖОК AIM
            -- ============================================

            local circleGui = Instance.new("ScreenGui")
            circleGui.Name = "AimbotCircle"
            circleGui.Parent = CoreGui
            circleGui.ResetOnSpawn = false

            local aimbotCircleBtn = Instance.new("TextButton")
            aimbotCircleBtn.Size = UDim2.new(0, 50, 0, 50)
            aimbotCircleBtn.Position = UDim2.new(0, 10, 0, 310)
            aimbotCircleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
            aimbotCircleBtn.BorderSizePixel = 2
            aimbotCircleBtn.BorderColor3 = Color3.fromRGB(255, 255, 255)
            aimbotCircleBtn.Text = "AIM"
            aimbotCircleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            aimbotCircleBtn.TextSize = 14
            aimbotCircleBtn.Font = Enum.Font.GothamBold
            aimbotCircleBtn.TextScaled = true
            aimbotCircleBtn.Draggable = true
            aimbotCircleBtn.ClipsDescendants = true
            aimbotCircleBtn.Parent = circleGui

            local circleCorner = Instance.new("UICorner")
            circleCorner.CornerRadius = UDim.new(1, 0)
            circleCorner.Parent = aimbotCircleBtn

            -- Перетаскивание
            local dragging = false
            local dragStart = nil
            local startPos = nil

            aimbotCircleBtn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    dragStart = input.Position
                    startPos = aimbotCircleBtn.Position
                end
            end)

            aimbotCircleBtn.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local delta = input.Position - dragStart
                    aimbotCircleBtn.Position = UDim2.new(
                        startPos.X.Scale,
                        startPos.X.Offset + delta.X,
                        startPos.Y.Scale,
                        startPos.Y.Offset + delta.Y
                    )
                end
            end)

            aimbotCircleBtn.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)

            -- ============================================
            -- ОТКРЫТИЕ/ЗАКРЫТИЕ МЕНЮ
            -- ============================================

            aimbotCircleBtn.MouseButton1Click:Connect(function()
                menuOpen = not menuOpen
                mainFrame.Visible = menuOpen
                
                if menuOpen then
                    aimbotCircleBtn.Text = "AIM"
                    aimbotCircleBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
                else
                    aimbotCircleBtn.Text = "AIM"
                    aimbotCircleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
                end
            end)

            -- ============================================
            -- КЛАВИША P
            -- ============================================

            UserInput.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                if input.KeyCode == Enum.KeyCode.P then
                    mainFrame.Visible = not mainFrame.Visible
                    menuOpen = mainFrame.Visible
                    
                    if menuOpen then
                        aimbotCircleBtn.Text = "AIM"
                        aimbotCircleBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
                    else
                        aimbotCircleBtn.Text = "AIM"
                        aimbotCircleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
                    end
                end
            end)

            print("🎯 ТОЛЬКО AIMBOT загружен!")
            print("📌 Зажми ПКМ → наведение на цель")
            print("📌 Клавиша K → смена цели (Head/Torso)")
            print("📌 Кружок AIM → открыть/закрыть меню")
        ]])()
    end

    -- ============================================
    -- СКРИПТ 3: HERRICRAFT ESP + Aimbot
    -- ============================================

    local function LoadMainScript()
        if isScriptLoaded then return end
        isScriptLoaded = true
        
        print("🚀 Загрузка HERRICRAFT ESP + AIMBOT + AUTOFIRE + FLY...")
        
        loadstring([[
            print("✅ HERRICRAFT ESP + AIMBOT + AUTOFIRE + FLY загружен!")
            print("🔥 ВСТАВЬ СЮДА СВОЙ СКРИПТ")
        ]])()
    end

    -- ============================================
    -- КНОПКИ В МЕНЮ
    -- ============================================

    CreateScriptButton(scriptContainer, 0, "🎯", "ESP с разделами", "ESP для игроков, монстров и NPC", LoadESPScript)
    CreateScriptButton(scriptContainer, 65, "🎯", "ТОЛЬКО AIMBOT", "Только наведение на цель (ПКМ)", LoadAimbotOnlyScript)
    CreateScriptButton(scriptContainer, 130, "🔫", "HERRICRAFT ESP + Aimbot", "ESP, Aimbot, AutoFire и Fly", LoadMainScript)

    -- Анимация появления
    mainFrame.BackgroundTransparency = 1
    local tween = TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0
    })
    tween:Play()
end

-- ============================================
-- МЕНЮ 1: ВХОД С ПАРОЛЕМ
-- ============================================

local function CreateLoginMenu()
    if loginScreenGui then
        loginScreenGui:Destroy()
        loginScreenGui = nil
    end
    if scriptMenuScreenGui then
        scriptMenuScreenGui:Destroy()
        scriptMenuScreenGui = nil
    end
    
    loginScreenGui = Instance.new("ScreenGui")
    loginScreenGui.Name = "HerricraftLogin"
    loginScreenGui.Parent = CoreGui
    loginScreenGui.ResetOnSpawn = false
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Parent = loginScreenGui
    mainFrame.Size = UDim2.new(0, 420, 0, 320)
    mainFrame.Position = UDim2.new(0.5, -210, 0.5, -160)
    mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 16)
    corner.Parent = mainFrame
    
    -- Обводка
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
    
    -- Кнопка закрытия (крестик)
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
        if loginScreenGui then
            loginScreenGui:Destroy()
            loginScreenGui = nil
        end
        if scriptMenuScreenGui then
            scriptMenuScreenGui:Destroy()
            scriptMenuScreenGui = nil
        end
    end)
    
    -- ============================================
    -- ПРОВЕРКА ПАРОЛЯ
    -- ============================================
    
    local function CheckCode()
        local inputCode = codeBox.Text
        if inputCode == correctCode then
            errorLabel.Text = "✅ Пароль верный!"
            errorLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            confirmBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
            confirmBtn.Text = "✅ ОТКРЫТО!"
            
            task.wait(0.3)
            
            CloseGUI(loginScreenGui, function()
                CreateScriptMenu()
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

-- ============================================
-- ЗАПУСК
-- ============================================

print("🏆 HERRICRAFT HUB загружен!")
print("📌 Пароль: 2026")

CreateLoginMenu()
