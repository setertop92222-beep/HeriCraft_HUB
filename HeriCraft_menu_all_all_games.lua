-- ============================================
-- HERRICRAFT ESP + AIMBOT + AUTOFIRE + FLY
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

local espEnabled = false
local aimbotEnabled = false
local flyEnabled = false
local autoFireEnabled = false
local menuOpen = false

local espHighlights = {}
local flyConnection = nil
local flyBodyVelocity = nil
local flyBodyGyro = nil

local espBtn = nil
local aimbotBtn = nil
local autoFireBtn = nil
local flyBtn = nil

-- ============================================
-- НАСТРОЙКИ
-- ============================================

_G.FREE_FOR_ALL = true
_G.AIM_AT = "Head"

-- ============================================
-- ФУНКЦИЯ ДЛЯ СТРЕЛЬБЫ
-- ============================================

local function ClickMouse()
    if mouse1click then
        mouse1click()
    elseif mouse1press and mouse1release then
        mouse1press()
        task.wait(0.05)
        mouse1release()
    else
        pcall(function()
            local VirtualInput = game:GetService("VirtualInputManager")
            VirtualInput:SendMouseButtonEvent(Enum.UserInputType.MouseButton1, 0, true, game, 0)
            task.wait(0.05)
            VirtualInput:SendMouseButtonEvent(Enum.UserInputType.MouseButton1, 0, false, game, 0)
        end)
    end
end

-- ============================================
-- ФУНКЦИЯ РАДУГИ
-- ============================================

local rainbowHue = 0

local function GetRainbowColor()
    rainbowHue = (rainbowHue + 0.005) % 1
    return Color3.fromHSV(rainbowHue, 1, 1)
end

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
-- ФУНКЦИЯ ПРОВЕРКИ ИГРОКА В ПРИЦЕЛЕ
-- ============================================

local function IsPlayerInCrosshair()
    local target = GetNearestPlayerToMouse()
    if target and target.Character then
        local aimPart = target.Character:FindFirstChild(_G.AIM_AT)
        if aimPart then
            return true
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
-- АВТОСТРЕЛЬБА
-- ============================================

RunService.RenderStepped:Connect(function()
    if not autoFireEnabled then return end
    if not aimbotEnabled then return end
    
    if IsPlayerInCrosshair() then
        ClickMouse()
        task.wait(0.08)
    end
end)

RunService.RenderStepped:Connect(function()
    if not autoFireEnabled then return end
    if not aimbotEnabled then return end
    
    if isAiming and IsPlayerInCrosshair() then
        ClickMouse()
        task.wait(0.08)
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
-- ESP (ОБВОДКА)
-- ============================================

local function clearESP()
    for _, highlight in ipairs(espHighlights) do
        if highlight and highlight.Parent then
            highlight:Destroy()
        end
    end
    espHighlights = {}
end

local function GetPlayerColor(plr)
    if plr == player then return nil end
    if plr.Team and player.Team then
        if plr.Team == player.Team then
            return Color3.fromRGB(0, 255, 0)
        else
            return Color3.fromRGB(255, 0, 0)
        end
    end
    return Color3.fromRGB(255, 255, 255)
end

local function createESPForPlayer(plr)
    if plr == player then return end
    if not espEnabled then return end
    
    local char = plr.Character
    if not char then return end
    
    if espHighlights[plr] then
        espHighlights[plr]:Destroy()
        espHighlights[plr] = nil
    end
    
    local color = GetPlayerColor(plr)
    if not color then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Parent = char
    highlight.Adornee = char
    highlight.FillColor = color
    highlight.FillTransparency = 0.7
    highlight.OutlineColor = color
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    
    espHighlights[plr] = highlight
end

local function updateESP()
    clearESP()
    if not espEnabled then return end
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            createESPForPlayer(plr)
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
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 200, 0, 250)
mainFrame.Position = UDim2.new(0.5, -100, 0.5, -125)
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

local function createButton(parent, yPos, text)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.Size = UDim2.new(0.9, 0, 0, 28)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamMedium
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    return btn
end

espBtn = createButton(mainFrame, 45, "🔴 ESP (Выкл)")
aimbotBtn = createButton(mainFrame, 82, "🎯 Aimbot (Выкл)")
autoFireBtn = createButton(mainFrame, 119, "🔥 AutoFire (Выкл)")
flyBtn = createButton(mainFrame, 156, "🟠 Fly (Выкл)")

-- ============================================
-- ОБНОВЛЕНИЕ ЦВЕТА КНОПОК (РАДУГА)
-- ============================================

local function UpdateButtonColors()
    if not espBtn or not aimbotBtn or not autoFireBtn or not flyBtn then return end
    
    if espEnabled then
        espBtn.BackgroundColor3 = GetRainbowColor()
        espBtn.Text = "🟢 ESP (Вкл)"
    else
        espBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
        espBtn.Text = "🔴 ESP (Выкл)"
    end
    
    if aimbotEnabled then
        aimbotBtn.BackgroundColor3 = GetRainbowColor()
        aimbotBtn.Text = "🎯 Aimbot (Вкл)"
    else
        aimbotBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
        aimbotBtn.Text = "🎯 Aimbot (Выкл)"
    end
    
    if autoFireEnabled then
        autoFireBtn.BackgroundColor3 = GetRainbowColor()
        autoFireBtn.Text = "🔥 AutoFire (Вкл)"
    else
        autoFireBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
        autoFireBtn.Text = "🔥 AutoFire (Выкл)"
    end
    
    if flyEnabled then
        flyBtn.BackgroundColor3 = GetRainbowColor()
        flyBtn.Text = "🟢 Fly (Вкл)"
    else
        flyBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
        flyBtn.Text = "🟠 Fly (Выкл)"
    end
end

-- ============================================
-- ЛОГИКА КНОПОК
-- ============================================

espBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    if espEnabled then
        updateESP()
        print("✅ ESP ВКЛЮЧЕН")
    else
        clearESP()
        print("❌ ESP ВЫКЛЮЧЕН")
    end
end)

aimbotBtn.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    if aimbotEnabled then
        print("🎯 Aimbot ВКЛЮЧЕН (ПКМ)")
    else
        print("🎯 Aimbot ВЫКЛЮЧЕН")
    end
end)

autoFireBtn.MouseButton1Click:Connect(function()
    autoFireEnabled = not autoFireEnabled
    if autoFireEnabled then
        print("🔥 AutoFire ВКЛЮЧЕН")
    else
        print("🔥 AutoFire ВЫКЛЮЧЕН")
    end
end)

flyBtn.MouseButton1Click:Connect(function()
    toggleFly()
end)

RunService.Heartbeat:Connect(function()
    if mainFrame.Visible then
        UpdateButtonColors()
    end
end)

local infoLabel = Instance.new("TextLabel")
infoLabel.Parent = mainFrame
infoLabel.Size = UDim2.new(0.9, 0, 0, 40)
infoLabel.Position = UDim2.new(0.05, 0, 0, 195)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "🖱️ ПКМ → наведение\n🔥 AutoFire → стрельба по цели\n⌨️ K → смена цели"
infoLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
infoLabel.TextSize = 11
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextXAlignment = Enum.TextXAlignment.Center
infoLabel.TextYAlignment = Enum.TextYAlignment.Center

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
-- ОБРАБОТКА ИГРОКОВ
-- ============================================

local function SetupPlayer(plr)
    if plr == player then return end
    
    plr.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        if espEnabled then
            createESPForPlayer(plr)
        end
    end)
    
    if plr.Character then
        task.wait(0.5)
        if espEnabled then
            createESPForPlayer(plr)
        end
    end
end

Players.PlayerAdded:Connect(function(plr)
    print("🟢 Игрок зашел: " .. plr.Name)
    SetupPlayer(plr)
    task.wait(0.5)
    if espEnabled then
        createESPForPlayer(plr)
    end
end)

Players.PlayerRemoving:Connect(function(plr)
    print("🔴 Игрок вышел: " .. plr.Name)
    if espHighlights[plr] then
        espHighlights[plr]:Destroy()
        espHighlights[plr] = nil
    end
end)

for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= player then
        SetupPlayer(plr)
    end
end

player.CharacterAdded:Connect(function()
    task.wait(1)
    if espEnabled then
        updateESP()
    end
    if flyEnabled then
        stopFly()
        task.wait(0.5)
        startFly()
    end
end)

local updateTimer = 0
RunService.Heartbeat:Connect(function()
    if not espEnabled then return end
    
    updateTimer = updateTimer + 1
    if updateTimer >= 180 then
        updateTimer = 0
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player then
                local hasESP = espHighlights[plr] and espHighlights[plr].Parent ~= nil
                if not hasESP then
                    createESPForPlayer(plr)
                end
            end
        end
    end
end)

print("🟢 BY: HERICRAFT - ESP + Aimbot + AutoFire + Fly загружены!")
print("📌 Включенные функции светятся РАДУГОЙ!")
print("📌 Aimbot: зажми ПКМ → наведение на цель")
print("📌 AutoFire: автоматическая стрельба по цели в прицеле")
print("📌 Клавиша K → смена цели (Head/Torso)")
print("📌 Fly: WASD + Space(вверх) + Ctrl(вниз)")
