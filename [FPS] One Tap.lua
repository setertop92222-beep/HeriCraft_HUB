-- ============================================
-- [FPS] One Tap - ESP + AIMBOT (С БОТАМИ)
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
    Bot = Color3.fromRGB(255, 165, 0),
}

-- ============================================
-- ПЕРЕМЕННЫЕ
-- ============================================

local espEnabled = false
local aimbotEnabled = false
local menuOpen = false
local isAiming = false
local espObjects = {}

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
-- ОПРЕДЕЛЕНИЕ ТИПА СУЩЕСТВА
-- ============================================

local function IsBot(char)
    if not char then return false end
    
    -- Проверяем, является ли игроком
    local plr = Players:GetPlayerFromCharacter(char)
    if plr then
        return false
    end
    
    -- Проверяем наличие Humanoid
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then
        return false
    end
    
    -- Проверяем наличие имени (у ботов часто есть имя)
    if char.Name and char.Name ~= "" then
        -- Если есть имя и это не игрок — считаем ботом
        return true
    end
    
    return true
end

-- ============================================
-- ПОЛУЧЕНИЕ ЦВЕТА ДЛЯ СУЩЕСТВА
-- ============================================

local function GetEntityColor(char)
    if not char then return COLORS.Border end
    
    local plr = Players:GetPlayerFromCharacter(char)
    if plr then
        if plr == player then return Color3.fromRGB(0, 150, 255) end
        if plr.Team and player.Team then
            if plr.Team == player.Team then
                return Color3.fromRGB(0, 255, 0)
            else
                return Color3.fromRGB(255, 0, 0)
            end
        end
        return Color3.fromRGB(255, 255, 255)
    end
    
    -- Если это бот — оранжевый
    if IsBot(char) then
        return COLORS.Bot
    end
    
    return COLORS.Border
end

-- ============================================
-- ПОЛУЧЕНИЕ ВСЕХ ЦЕЛЕЙ (ИГРОКИ + БОТЫ)
-- ============================================

local function GetAllTargets()
    local targets = {}
    local seen = {}
    
    -- 1. Игроки
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            local char = plr.Character
            if char then
                local hum = char:FindFirstChild("Humanoid")
                if hum and hum.Health > 0 then
                    local head = char:FindFirstChild("Head")
                    if head then
                        if not seen[char] then
                            seen[char] = true
                            table.insert(targets, {
                                type = "player",
                                name = plr.Name,
                                object = char,
                                part = head,
                                color = GetEntityColor(char),
                                isBot = false
                            })
                        end
                    end
                end
            end
        end
    end
    
    -- 2. Боты и другие существа (NPC, монстры, зомби)
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") then
            if not seen[obj] then
                local plr = Players:GetPlayerFromCharacter(obj)
                if not plr then
                    local hum = obj:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        local head = obj:FindFirstChild("Head")
                        if head then
                            seen[obj] = true
                            table.insert(targets, {
                                type = "bot",
                                name = obj.Name,
                                object = obj,
                                part = head,
                                color = COLORS.Bot,
                                isBot = true
                            })
                        end
                    end
                end
            end
        end
    end
    
    -- 3. Инструменты (для ESP)
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Tool") or obj:IsA("Part") then
            if obj:IsA("Part") and obj.Parent and obj.Parent:IsA("Tool") then
                obj = obj.Parent
            end
            if obj:IsA("Tool") and obj:FindFirstChildWhichIsA("Part") then
                local part = obj:FindFirstChildWhichIsA("Part")
                if part then
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
                            color = COLORS.Item,
                            isBot = false
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

local function updateESP()
    clearESP()
    if not espEnabled then return end
    
    local targets = GetAllTargets()
    
    for _, target in ipairs(targets) do
        if target.part and target.part.Parent then
            if not target.object:FindFirstChild("EspBox") then
                local esp = Instance.new("BoxHandleAdornment")
                esp.Adornee = target.object
                esp.ZIndex = 0
                
                if target.type == "player" then
                    esp.Size = Vector3.new(4, 5, 1)
                    esp.Transparency = 0.5
                elseif target.type == "bot" then
                    esp.Size = Vector3.new(3, 4, 1)
                    esp.Transparency = 0.4
                else
                    esp.Size = Vector3.new(2, 2, 1)
                    esp.Transparency = 0.3
                end
                
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
-- AIMBOT ФУНКЦИИ (ИГРОКИ + БОТЫ)
-- ============================================

local function GetNearestTarget()
    local closest = nil
    local closestDist = math.huge
    
    local targets = GetAllTargets()
    
    for _, target in ipairs(targets) do
        -- Целимся в игроков и ботов (не в инструменты)
        if target.type == "player" or target.type == "bot" then
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
        UDim2.new(0, 0, 0, 155),
        "ПКМ - Aimbot (игроки + боты)",
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
print("📌 ESP: показывает игроков и ботов")
print("📌 Aimbot: наводит на игроков и ботов")
print("📌 Кружок [FPS] → открыть меню")
print("📌 ПКМ → Aimbot")

CreateMenu()
