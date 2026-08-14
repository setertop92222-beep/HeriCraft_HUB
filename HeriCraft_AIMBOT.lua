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

local aimbotBtn = createButton(mainFrame, 45, "🎯 Aimbot (Выкл)")

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
-- ОТКРЫТИЕ/ЗАКРЫТИЕ
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
