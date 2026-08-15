-- ============================================
-- [FPS] One Tap - ESP + AIMBOT (С ПОДДЕРЖКОЙ ИНС)
-- ============================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInput = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local mouse = player:GetMouse()

-- ============================================
-- ЦВЕТА (ЧЁРНЫЙ + ЖЁЛТЫЙ)
-- ============================================

local COLORS = {
    Background = Color3.fromRGB(10, 10, 10),
    Dark = Color3.fromRGB(20, 20, 20),
    Border = Color3.fromRGB(255, 215, 0),
    Text = Color3.fromRGB(255, 215, 0),
    TextDark = Color3.fromRGB(150, 150, 150),
    Active = Color3.fromRGB(255, 215, 0),
    Inactive = Color3.fromRGB(60, 60, 60),
    Item = Color3.fromRGB(255, 200, 0),
}

-- ============================================
-- ПЕРЕМЕННЫЕ
-- ============================================

local espEnabled = false
local aimbotEnabled = false
local menuOpen = false
local isAiming = false
local espObjects = {}
local aimbotTarget = nil

_G.AIM_AT = "Head"

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
-- ФУНКЦИИ ПОЛУЧЕНИЯ ОБЪЕКТОВ (ИГРОКИ + ИНС)
-- ============================================

local function GetAllTargets()
    local targets = {}
    
    -- 1. Игроки
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            local char = plr.Character
            if char then
                local hum = char:FindFirstChild("Humanoid")
                if hum and hum.Health > 0 then
                    local head = char:FindFirstChild("Head")
                    if head then
                        table.insert(targets, {
                            type = "player",
                            name = plr.Name,
                            object = char,
                            part = head,
                            color = GetPlayerColor(plr)
                        })
                    end
                end
            end
        end
    end
    
    -- 2. Инструменты (инс) в руках игроков
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            local char = plr.Character
            if char then
                -- Проверяем, что держит игрок в руках
                local rightArm = char:FindFirstChild("Right Arm") or char:FindFirstChild("RightArm")
                local leftArm = char:FindFirstChild("Left Arm") or char:FindFirstChild("LeftArm")
                
                local function checkArm(arm)
                    if arm then
                        for _, child in ipairs(arm:GetChildren()) do
                            if child:IsA("Tool") or child:IsA("Part") or child:IsA("Model") then
                                if child:FindFirstChildWhichIsA("Part") then
                                    local part = child:FindFirstChildWhichIsA("Part")
                                    if part then
                                        table.insert(targets, {
                                            type = "item",
                                            name = child.Name,
                                            object = child,
                                            part = part,
                                            color = COLORS.Item,
                                            parentPlayer = plr.Name
                                        })
                                    end
                                else
                                    table.insert(targets, {
                                        type = "item",
                                        name = child.Name,
                                        object = child,
                                        part = child,
                                        color = COLORS.Item,
                                        parentPlayer = plr.Name
                                    })
                                end
                            end
                        end
                    end
                end
                
                checkArm(rightArm)
                checkArm(leftArm)
            end
        end
    end
    
    -- 3. Инструменты на земле (в workspace)
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Tool") or obj:IsA("Part") then
            if obj:IsA("Part") and obj.Parent and obj.Parent:IsA("Tool") then
                obj = obj.Parent
            end
            if obj:IsA("Tool") and obj:FindFirstChildWhichIsA("Part") then
                local part = obj:FindFirstChildWhichIsA("Part")
                if part then
                    -- Проверяем, не находится ли в руках игрока (чтобы не дублировать)
                    local inHands = false
                    for _, plr in ipairs(Players:GetPlayers()) do
                        if plr ~= player then
                            local char = plr.Character
                            if char then
                                local rightArm = char:FindFirstChild("Right Arm") or char:FindFirstChild("RightArm")
                                local leftArm = char:FindFirstChild("Left Arm") or char:FindFirstChild("LeftArm")
                                if rightArm and obj:IsDescendantOf(rightArm) then inHands = true end
                                if leftArm and obj:IsDescendantOf(leftArm) then inHands = true end
                            end
                        end
                    end
                    if not inHands then
                        table.insert(targets, {
                            type = "item_ground",
                            name = obj.Name,
                            object = obj,
                            part = part,
                            color = COLORS.Item
                        })
                    end
                end
            end
        end
    end
    
    return targets
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

local function GetPlayerColor(plr)
    if plr == player then return nil end
    if plr.Team and player.Team then
        if plr.Team == player.Team then
            return Color3.fromRGB(0, 255, 0)
        else
            return Color3.fromRGB(255, 0, 0)
        end
    end
    return COLORS.Border
end

local function updateESP()
    clearESP()
    if not espEnabled then return end
    
    local targets = GetAllTargets()
    
    for _, target in ipairs(targets) do
        if target.part and target.part.Parent then
            -- Пропускаем объекты без Humanoid (кроме инструментов)
            if target.type ~= "item" and target.type ~= "item_ground" then
                local hum = target.object:FindFirstChild("Humanoid")
                if not hum or hum.Health <= 0 then
                    continue
                end
            end
            
            if not target.object:FindFirstChild("EspBox") then
                local esp = Instance.new("BoxHandleAdornment")
                esp.Adornee = target.object
                esp.ZIndex = 0
                esp.Size = target.type == "player" and Vector3.new(4, 5, 1) or Vector3.new(2, 2, 2)
                esp.Transparency = target.type == "player" and 0.5 or 0.3
                esp.Color3 = target.color or COLORS.Border
                esp.AlwaysOnTop = true
                esp.Name = "EspBox"
                esp.Parent = target.object
                table.insert(espObjects, esp)
            end
        end
    end
end

-- ============================================
-- AIMBOT ФУНКЦИИ (ИГРОКИ + ИНС)
-- ============================================

local function GetNearestTarget()
    local closest = nil
    local closestDist = math.huge
    
    local targets = GetAllTargets()
    
    for _, target in ipairs(targets) do
        -- Целимся только в игроков и инструменты в руках
        if target.type ~= "item_ground" then
            if target.part then
                local screenPos, onScreen = camera:WorldToViewportPoint(target.part.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closest = target
                    end
                end
            end
        end
    end
    
    return closest
end

-- ============================================
-- AIMBOT ЛОГИКА
-- ============================================

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

RunService.RenderStepped:Connect(function()
    if aimbotEnabled and isAiming then
        local target = GetNearestTarget()
        if target and target.part then
            camera.CFrame = CFrame.new(camera.CFrame.Position, target.part.CFrame.Position)
        end
    end
end)

-- ============================================
-- МЕНЮ
-- ============================================

local function CreateMenu()
    for _, gui in ipairs(CoreGui:GetChildren()) do
        if gui.Name == "OneTapFPS" then
            gui:Destroy()
        end
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "OneTapFPS"
    screenGui.Parent = CoreGui
    screenGui.ResetOnSpawn = false

    local mainFrame = CreateFrame(screenGui,
        UDim2.new(0, 300, 0, 240),
        UDim2.new(0.5, -150, 0.5, -120)
    )
    mainFrame.Visible = false

    CreateLabel(mainFrame,
        UDim2.new(1, 0, 0, 40),
        UDim2.new(0, 0, 0, 5),
        "[FPS] One Tap",
        COLORS.Border,
        20
    )

    -- Кнопка ESP
    local espBtn = CreateButton(mainFrame,
        UDim2.new(0.8, 0, 0, 35),
        UDim2.new(0.1, 0, 0, 55),
        "> ESP: ВЫКЛ"
    )
    espBtn.TextColor3 = COLORS.Inactive
    espBtn.BorderColor3 = COLORS.Inactive

    espBtn.MouseButton1Click:Connect(function()
        espEnabled = not espEnabled
        if espEnabled then
            espBtn.Text = "> ESP: ВКЛ"
            espBtn.TextColor3 = COLORS.Active
            espBtn.BorderColor3 = COLORS.Active
            updateESP()
        else
            espBtn.Text = "> ESP: ВЫКЛ"
            espBtn.TextColor3 = COLORS.Inactive
            espBtn.BorderColor3 = COLORS.Inactive
            clearESP()
        end
    end)

    -- Кнопка Aimbot
    local aimBtn = CreateButton(mainFrame,
        UDim2.new(0.8, 0, 0, 35),
        UDim2.new(0.1, 0, 0, 105),
        "> AIMBOT: ВЫКЛ"
    )
    aimBtn.TextColor3 = COLORS.Inactive
    aimBtn.BorderColor3 = COLORS.Inactive

    aimBtn.MouseButton1Click:Connect(function()
        aimbotEnabled = not aimbotEnabled
        if aimbotEnabled then
            aimBtn.Text = "> AIMBOT: ВКЛ"
            aimBtn.TextColor3 = COLORS.Active
            aimBtn.BorderColor3 = COLORS.Active
        else
            aimBtn.Text = "> AIMBOT: ВЫКЛ"
            aimBtn.TextColor3 = COLORS.Inactive
            aimBtn.BorderColor3 = COLORS.Inactive
        end
    end)

    -- Информация
    CreateLabel(mainFrame,
        UDim2.new(1, 0, 0, 20),
        UDim2.new(0, 0, 0, 160),
        "ПКМ - Aimbot (игроки + инс)",
        COLORS.TextDark,
        12
    )

    -- Кнопка закрытия
    local closeBtn = CreateButton(mainFrame,
        UDim2.new(0, 28, 0, 28),
        UDim2.new(1, -33, 0, 5),
        "✕",
        function()
            mainFrame.Visible = false
            menuOpen = false
            if circleBtn then
                circleBtn.Text = "[FPS]"
                circleBtn.BorderColor3 = COLORS.Border
                circleBtn.TextColor3 = COLORS.TextDark
            end
        end
    )
    closeBtn.BackgroundColor3 = COLORS.Background
    closeBtn.BorderColor3 = Color3.fromRGB(255, 50, 50)
    closeBtn.TextColor3 = Color3.fromRGB(255, 50, 50)

    -- ============================================
    -- КРУЖОК
    -- ============================================

    local circleGui = Instance.new("ScreenGui")
    circleGui.Name = "OneTapCircle"
    circleGui.Parent = CoreGui
    circleGui.ResetOnSpawn = false

    local circleBtn = Instance.new("TextButton")
    circleBtn.Size = UDim2.new(0, 50, 0, 50)
    circleBtn.Position = UDim2.new(0, 10, 0, 250)
    circleBtn.BackgroundColor3 = COLORS.Background
    circleBtn.BackgroundTransparency = 0
    circleBtn.BorderSizePixel = 2
    circleBtn.BorderColor3 = COLORS.Border
    circleBtn.Text = "[FPS]"
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
            circleBtn.Text = "[MENU]"
            circleBtn.BorderColor3 = COLORS.Active
            circleBtn.TextColor3 = COLORS.Active
        else
            circleBtn.Text = "[FPS]"
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
-- АВТООБНОВЛЕНИЕ ESP
-- ============================================

RunService.Heartbeat:Connect(function()
    if espEnabled then
        updateESP()
    end
end)

-- ============================================
-- ЗАПУСК
-- ============================================

print("🎯 [FPS] One Tap - ESP + Aimbot загружены!")
print("📌 Кружок [FPS] → открыть меню")
print("📌 ПКМ → Aimbot (игроки + инс)")

CreateMenu()
