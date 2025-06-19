local player = game.Players.LocalPlayer
local camera = game.Workspace.CurrentCamera
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local lighting = game.Lighting
local terrain = game.Workspace.Terrain
local replicatedStorage = game:GetService("ReplicatedStorage")
local physicsService = game:GetService("PhysicsService")

-- Wait for PlayerGui with retry and timeout
local function waitForPlayerGui()
    local startTime = tick()
    local maxWait = 30
    repeat
        local success, playerGui = pcall(function()
            return player:WaitForChild("PlayerGui", 1)
        end)
        if success and playerGui then
            return playerGui
        end
        if tick() - startTime > maxWait then
            warn("Failed to find PlayerGui after " .. maxWait .. " seconds")
            return nil
        end
        runService.Heartbeat:Wait()
    until false
end

-- Create ScreenGui with retry mechanism
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MoonHook"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Enabled = true
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 100000

local function parentScreenGui()
    local playerGui = waitForPlayerGui()
    if playerGui then
        screenGui.Parent = playerGui
        return true
    else
        warn("Could not parent ScreenGui to PlayerGui")
        return false
    end
end

if not parentScreenGui() then
    local connection
    connection = runService.Heartbeat:Connect(function()
        if parentScreenGui() then
            connection:Disconnect()
        end
    end)
end

-- Loading Frame
local loadingFrame = Instance.new("Frame")
loadingFrame.Name = "Loading"
loadingFrame.Size = UDim2.new(0, 400, 0, 200)
loadingFrame.Position = UDim2.new(0.5, -200, 0.5, -100)
loadingFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
loadingFrame.BorderSizePixel = 0
loadingFrame.ZIndex = 100005
loadingFrame.Visible = true
loadingFrame.Parent = screenGui

local uiCornerLoading = Instance.new("UICorner")
uiCornerLoading.CornerRadius = UDim.new(0, 12)
uiCornerLoading.Parent = loadingFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 100)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Hello from H1ttler"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 30
titleLabel.Font = Enum.Font.GothamBold
titleLabel.ZIndex = 100006
titleLabel.Parent = loadingFrame

local loadingLabel = Instance.new("TextLabel")
loadingLabel.Size = UDim2.new(1, 0, 0, 50)
loadingLabel.Position = UDim2.new(0, 0, 0, 100)
loadingLabel.BackgroundTransparency = 1
loadingLabel.Text = "Loading"
loadingLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
loadingLabel.TextSize = 20
loadingLabel.Font = Enum.Font.Gotham
loadingLabel.ZIndex = 100006
loadingLabel.Parent = loadingFrame

-- Menu Frame
local menuFrame = Instance.new("Frame")
menuFrame.Name = "Menu"
menuFrame.Size = UDim2.new(0, 900, 0, 600)
menuFrame.Position = UDim2.new(0, 0, 0, 0)
menuFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
menuFrame.BorderSizePixel = 0
menuFrame.ZIndex = 100001
menuFrame.Visible = false
menuFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 12)
uiCorner.Parent = menuFrame

local uiShadow = Instance.new("UIStroke")
uiShadow.Thickness = 3
uiShadow.Color = Color3.fromRGB(0, 0, 30)
uiShadow.Transparency = 0.3
uiShadow.Parent = menuFrame

-- Header frame
local headerFrame = Instance.new("Frame")
headerFrame.Size = UDim2.new(1, 0, 0, 60)
headerFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 35)
headerFrame.BorderSizePixel = 0
headerFrame.ZIndex = 100002
headerFrame.Visible = true
headerFrame.Parent = menuFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = headerFrame

-- Avatar
local avatarImage = Instance.new("ImageLabel")
avatarImage.Size = UDim2.new(0, 40, 0, 40)
avatarImage.Position = UDim2.new(0, 10, 0, 10)
avatarImage.BackgroundColor3 = Color3.fromRGB(25, 25, 50)
avatarImage.BorderSizePixel = 0
avatarImage.ZIndex = 100003
avatarImage.Image = player and "rbxthumb://id=" .. player.UserId .. "?width=420&height=420" or ""
avatarImage.Parent = headerFrame

local avatarCorner = Instance.new("UICorner")
avatarCorner.CornerRadius = UDim.new(0, 6)
avatarCorner.Parent = avatarImage

-- Username
local usernameLabel = Instance.new("TextLabel")
usernameLabel.Size = UDim2.new(0, 200, 0, 30)
usernameLabel.Position = UDim2.new(0, 60, 0, 15)
usernameLabel.BackgroundTransparency = 1
usernameLabel.Text = player and player.Name or "Loading..."
usernameLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
usernameLabel.TextSize = 16
usernameLabel.Font = Enum.Font.GothamBold
usernameLabel.ZIndex = 100003
usernameLabel.Parent = headerFrame

-- FPS Counter
local fpsCounter = Instance.new("TextLabel")
fpsCounter.Size = UDim2.new(0, 100, 0, 30)
fpsCounter.Position = UDim2.new(0, 270, 0, 15)
fpsCounter.BackgroundTransparency = 1
fpsCounter.TextColor3 = Color3.fromRGB(255, 255, 255)
fpsCounter.TextSize = 16
fpsCounter.Font = Enum.Font.GothamBold
fpsCounter.ZIndex = 100003
fpsCounter.Parent = headerFrame

local fps = 0
local lastTime = tick()

-- Menu Title
local menuTitleLabel = Instance.new("TextLabel")
menuTitleLabel.Size = UDim2.new(0, 200, 0, 30)
menuTitleLabel.Position = UDim2.new(0, 380, 0, 15)
menuTitleLabel.BackgroundTransparency = 1
menuTitleLabel.Text = "Privat (Version)"
menuTitleLabel.TextColor3 = Color3.fromRGB(150, 150, 255)
menuTitleLabel.TextSize = 16
menuTitleLabel.Font = Enum.Font.GothamBold
menuTitleLabel.ZIndex = 100003
menuTitleLabel.Parent = headerFrame

-- Tab buttons frame
local tabButtonsFrame = Instance.new("Frame")
tabButtonsFrame.Size = UDim2.new(0, 180, 1, -60)
tabButtonsFrame.Position = UDim2.new(0, 0, 0, 60)
tabButtonsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 50)
tabButtonsFrame.ZIndex = 100001
tabButtonsFrame.Visible = true
tabButtonsFrame.Parent = menuFrame

local tabGradient = Instance.new("UIGradient")
tabGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 50)), ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 70))}
tabGradient.Parent = tabButtonsFrame

local tabContentFrame = Instance.new("Frame")
tabContentFrame.Size = UDim2.new(1, -180, 1, -60)
tabContentFrame.Position = UDim2.new(0, 180, 0, 60)
tabContentFrame.BackgroundTransparency = 1
tabContentFrame.ClipsDescendants = true
tabContentFrame.ZIndex = 100000
tabContentFrame.Visible = true
tabContentFrame.Parent = menuFrame

-- Tab content containers
local tabContent = {}
local yOffsets = {0, 0, 0, 0, 0, 0}
for i = 1, 6 do
    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Size = UDim2.new(1, -20, 1, -10)
    scrollingFrame.Position = UDim2.new(0, 10, 0, 5)
    scrollingFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 50)
    scrollingFrame.BackgroundTransparency = 0
    scrollingFrame.ScrollBarThickness = 6
    scrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollingFrame.Visible = (i == 1)
    scrollingFrame.ZIndex = 100002
    scrollingFrame.Parent = tabContentFrame

    local uiCornerContent = Instance.new("UICorner")
    uiCornerContent.CornerRadius = UDim.new(0, 10)
    uiCornerContent.Parent = scrollingFrame

    tabContent[i] = scrollingFrame
end

-- Helper: Create text button
local function createTextButton(parent, text, position)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 160, 0, 30)
    button.Position = position
    button.Text = text
    button.BackgroundColor3 = Color3.fromRGB(35, 35, 60)
    button.TextColor3 = Color3.fromRGB(200, 200, 255)
    button.BorderSizePixel = 0
    button.Visible = true
    button.ZIndex = 100003
    button.TextSize = 14
    button.Font = Enum.Font.GothamBold
    button.Parent = parent

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = button

    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(45, 45, 80)
    end)
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(35, 35, 60)
    end)

    return button
end

-- Helper: Create slider
local function createSlider(parent, defaultValue, min, max, position)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(0, 160, 0, 40)
    sliderFrame.Position = position
    sliderFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 60)
    sliderFrame.BorderSizePixel = 0
    sliderFrame.ZIndex = 100003
    sliderFrame.Visible = true
    sliderFrame.Parent = parent

    local uiCornerSlider = Instance.new("UICorner")
    uiCornerSlider.CornerRadius = UDim.new(0, 6)
    uiCornerSlider.Parent = sliderFrame

    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0, 100, 0, 30)
    textBox.Position = UDim2.new(0, 5, 0, 5)
    textBox.Text = tostring(defaultValue)
    textBox.BackgroundColor3 = Color3.fromRGB(25, 25, 50)
    textBox.TextColor3 = Color3.fromRGB(200, 200, 255)
    textBox.BorderSizePixel = 0
    textBox.TextSize = 14
    textBox.ZIndex = 100004
    textBox.Parent = sliderFrame

    local textBoxCorner = Instance.new("UICorner")
    textBoxCorner.CornerRadius = UDim.new(0, 4)
    textBoxCorner.Parent = textBox

    textBox.FocusLost:Connect(function()
        local value = tonumber(textBox.Text)
        if value then
            textBox.Text = math.clamp(value, min, max)
        else
            textBox.Text = tostring(defaultValue)
        end
    end)

    textBox.MouseEnter:Connect(function()
        textBox.BackgroundColor3 = Color3.fromRGB(35, 35, 70)
    end)
    textBox.MouseLeave:Connect(function()
        textBox.BackgroundColor3 = Color3.fromRGB(25, 25, 50)
    end)

    return {sliderFrame, textBox}
end

-- Tab buttons
local tabNames = {"Visuals", "Combat", "Misc", "UI", "Range", "Player"}
for i, name in ipairs(tabNames) do
    local tabButton = createTextButton(tabButtonsFrame, name, UDim2.new(0, 10, 0, (i-1)*35 + 10))
    tabButton.MouseButton1Click:Connect(function()
        for j, content in pairs(tabContent) do
            content.Visible = (i == j)
        end
    end)
end

-- Title label
local isTitleEnabled = false
local titleLabel = nil
local titleConnection = nil

local function createTitleLabel()
    if titleLabel then
        titleLabel:Destroy()
    end
    titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0, 300, 0, 50)
    titleLabel.Position = UDim2.new(0.5, -150, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "MoonHook.zyx (by:iknowuknow42)"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 24
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.ZIndex = 100006
    titleLabel.Parent = screenGui

    local uiStroke = Instance.new("UIStroke")
    uiStroke.Thickness = 1
    uiStroke.Color = Color3.fromRGB(255, 255, 255)
    uiStroke.Parent = titleLabel

    if titleConnection then
        titleConnection:Disconnect()
    end
    local hue = 0
    titleConnection = runService.Heartbeat:Connect(function(delta)
        hue = (hue + delta / 5) % 1
        titleLabel.TextColor3 = Color3.fromHSV(hue, 1, 1)
    end)
end

local function toggleTitle()
    isTitleEnabled = not isTitleEnabled
    if isTitleEnabled then
        createTitleLabel()
    else
        if titleLabel then
            titleLabel:Destroy()
            titleLabel = nil
        end
        if titleConnection then
            titleConnection:Disconnect()
            titleConnection = nil
        end
    end
end

-- Aimbot System
local circle = Drawing.new("Circle")
circle.Visible = false
circle.Radius = 50
circle.Color = Color3.fromRGB(255, 0, 0)
circle.Transparency = 0.5
circle.Thickness = 2
circle.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X/2, workspace.CurrentCamera.ViewportSize.Y/2)
local smoothFactor = 0.25
local isAimbotEnabled = false

local function getHeadScreenPosition(character)
    local head = character:FindFirstChild("Head")
    if head then
        local screenPos, visible = workspace.CurrentCamera:WorldToViewportPoint(head.Position)
        return Vector2.new(screenPos.X, screenPos.Y), visible
    end
    return nil, false
end

local function findClosestPlayerInCircle()
    local closestPlayer = nil
    local closestDistance = math.huge
    local mousePos = circle.Position
    
    for _, model in ipairs(workspace:GetChildren()) do
        if model and model:IsA("Model") and model:FindFirstChild("HumanoidRootPart") and model:FindFirstChild("Head") then
            local headPos, visible = getHeadScreenPosition(model)
            if visible and headPos then
                local distance = (headPos - mousePos).Magnitude
                if distance <= circle.Radius and distance < closestDistance then
                    closestDistance = distance
                    closestPlayer = model
                end
            end
        end
    end
    return closestPlayer
end

-- ESP System
local BoxESP = {}
function BoxESP.Create(Player)
    local Box = Drawing.new("Square")
    Box.Visible = false
    Box.Color = Color3.fromRGB(194, 17, 17)
    Box.Filled = false
    Box.Transparency = 0.50
    Box.Thickness = 3

    local Updater

    local function UpdateBox()
        if Player and Player:IsA("Model") and Player:FindFirstChild("HumanoidRootPart") and Player:FindFirstChild("Head") then
            local Target2dPosition, IsVisible = workspace.CurrentCamera:WorldToViewportPoint(Player.HumanoidRootPart.Position)
            local scale_factor = 1 / (Target2dPosition.Z * math.tan(math.rad(workspace.CurrentCamera.FieldOfView * 0.5)) * 2) * 100
            local width, height = math.floor(40 * scale_factor), math.floor(62 * scale_factor)
            Box.Visible = IsVisible
            Box.Size = Vector2.new(width, height)
            Box.Position = Vector2.new(Target2dPosition.X - Box.Size.X / 2, Target2dPosition.Y - Box.Size.Y / 2)
        else
            Box.Visible = false
            if not Player then
                Box:Remove()
                Updater:Disconnect()
            end
        end
    end

    Updater = game:GetService("RunService").RenderStepped:Connect(UpdateBox)

    return Box
end

local Boxes = {}

local function EnableBoxESP()
    for _, Player in pairs(game:GetService("Workspace"):GetChildren()) do
        if Player:IsA("Model") and Player:FindFirstChild("HumanoidRootPart") and Player:FindFirstChild("Head") then
            local Box = BoxESP.Create(Player)
            table.insert(Boxes, Box)
        end
    end
end

game.Workspace.DescendantAdded:Connect(function(i)
    if i:IsA("Model") and i:FindFirstChild("HumanoidRootPart") and i:FindFirstChild("Head") then
        local Box = BoxESP.Create(i)
        table.insert(Boxes, Box)
    end
end)

EnableBoxESP()

-- Hitbox System
local SelectPart = "Head"
local HBSizeX = 2.7
local HBSizeY = 2.5
local HBSizeZ = 2.7
local HBTrans = 0.5
local PurpleColor = BrickColor.new("Really red")
local hitboxlist1 = {}

task.spawn(function()
    while wait(0.1) do
        for _, i in pairs(game:GetDescendants()) do
            if i:FindFirstChild("Head") and not i:FindFirstChild("Fake1") then
                local FakeHead = Instance.new("Part", i)
                FakeHead.CFrame = i.Head.CFrame
                FakeHead.Name = SelectPart
                FakeHead.Size = Vector3.new(HBSizeX, HBSizeY, HBSizeZ)
                FakeHead.Anchored = true
                FakeHead.CanCollide = false
                FakeHead.Transparency = HBTrans
                FakeHead.BrickColor = PurpleColor
                local subndom = Instance.new("Part", i)
                subndom.Name = "Fake1"
                table.insert(hitboxlist1, FakeHead)
                table.insert(hitboxlist1, subndom)
            end
        end
    end
end)

local function updateHitboxSettings()
    for _, fakeHead in pairs(hitboxlist1) do
        if fakeHead and fakeHead.Name == "Head" then
            fakeHead.Size = Vector3.new(HBSizeX, HBSizeY, HBSizeZ)
            fakeHead.Transparency = HBTrans
            fakeHead.Material = Enum.Material.SmoothPlastic
        end
    end
end

-- Visuals Tab
local visualsContent = tabContent[1]

yOffsets[1] = yOffsets[1] + 5
local espButton = createTextButton(visualsContent, "Box ESP On/Off", UDim2.new(0, 10, 0, yOffsets[1]))
local espToggle = createTextButton(visualsContent, "Off", UDim2.new(0, 175, 0, yOffsets[1]))
espButton.MouseButton1Click:Connect(function()
    for _, box in pairs(Boxes) do
        box.Visible = not box.Visible
    end
    espToggle.Text = (not espToggle.Text:match("On")) and "On" or "Off"
end)

yOffsets[1] = yOffsets[1] + 35
local xrayButton = createTextButton(visualsContent, "Xray On/Off", UDim2.new(0, 10, 0, yOffsets[1]))
local xrayToggle = createTextButton(visualsContent, "Off", UDim2.new(0, 175, 0, yOffsets[1]))
local xrayTransparencyButton = createTextButton(visualsContent, "Xray Transparency", UDim2.new(0, 10, 0, yOffsets[1] + 35))
local xrayTransparencySlider = createSlider(visualsContent, 0.6, 0, 1, UDim2.new(0, 175, 0, yOffsets[1] + 70))
xrayButton.MouseButton1Click:Connect(function()
    -- Xray logic to be implemented
    xrayToggle.Text = (not xrayToggle.Text:match("On")) and "On" or "Off"
end)
xrayTransparencyButton.MouseButton1Click:Connect(function()
    local value = tonumber(xrayTransparencySlider[2].Text) or 0.6
    -- Apply transparency to xray parts
end)

yOffsets[1] = yOffsets[1] + 110
local skinChangerButton = createTextButton(visualsContent, "SkinChanger On/Off", UDim2.new(0, 10, 0, yOffsets[1]))
local skinChangerToggle = createTextButton(visualsContent, "Off", UDim2.new(0, 175, 0, yOffsets[1]))
skinChangerButton.MouseButton1Click:Connect(function()
    -- SkinChanger logic to be implemented
    skinChangerToggle.Text = (not skinChangerToggle.Text:match("On")) and "On" or "Off"
end)

yOffsets[1] = yOffsets[1] + 35
local materialButton = createTextButton(visualsContent, "Set Material", UDim2.new(0, 10, 0, yOffsets[1]))
local materialToggle = createTextButton(visualsContent, "SmoothPlastic", UDim2.new(0, 175, 0, yOffsets[1]))
materialButton.MouseButton1Click:Connect(function()
    local materials = {Enum.Material.SmoothPlastic, Enum.Material.Fabric, Enum.Material.Air}
    local currentIndex = table.find(materials, Enum.Material.SmoothPlastic) or 1
    currentIndex = (currentIndex % #materials) + 1
    materialToggle.Text = materials[currentIndex].Name
    -- Apply material to hitboxes
end)

visualsContent.CanvasSize = UDim2.new(0, 0, 0, yOffsets[1] + 35)

-- Combat Tab
local combatContent = tabContent[2]

yOffsets[2] = yOffsets[2] + 5
local fovCircleButton = createTextButton(combatContent, "FOV Circle", UDim2.new(0, 10, 0, yOffsets[2]))
local fovCircleToggle = createTextButton(combatContent, "Off", UDim2.new(0, 175, 0, yOffsets[2]))
fovCircleButton.MouseButton1Click:Connect(function()
    -- FOV Circle logic to be implemented
    fovCircleToggle.Text = (not fovCircleToggle.Text:match("On")) and "On" or "Off"
end)

yOffsets[2] = yOffsets[2] + 35
local aimbotButton = createTextButton(combatContent, "Aimbot On/Off", UDim2.new(0, 10, 0, yOffsets[2]))
local aimbotToggle = createTextButton(combatContent, "Off", UDim2.new(0, 175, 0, yOffsets[2]))
aimbotButton.MouseButton1Click:Connect(function()
    isAimbotEnabled = not isAimbotEnabled
    circle.Visible = isAimbotEnabled
    aimbotToggle.Text = isAimbotEnabled and "On" or "Off"
end)

yOffsets[2] = yOffsets[2] + 35
local aimbotRadiusButton = createTextButton(combatContent, "Aimbot Radius", UDim2.new(0, 10, 0, yOffsets[2]))
local aimbotRadiusSlider = createSlider(combatContent, 50, 10, 200, UDim2.new(0, 175, 0, yOffsets[2] + 35))
aimbotRadiusButton.MouseButton1Click:Connect(function()
    local value = tonumber(aimbotRadiusSlider[2].Text) or 50
    circle.Radius = math.clamp(value, 10, 200)
end)

yOffsets[2] = yOffsets[2] + 70
local hitboxExpanderButton = createTextButton(combatContent, "Hitbox Expander On/Off", UDim2.new(0, 10, 0, yOffsets[2]))
local hitboxExpanderToggle = createTextButton(combatContent, "Off", UDim2.new(0, 175, 0, yOffsets[2]))
local hitboxSizeXSlider = createSlider(combatContent, HBSizeX, 1, 10, UDim2.new(0, 175, 0, yOffsets[2] + 35))
local hitboxSizeYSlider = createSlider(combatContent, HBSizeY, 1, 10, UDim2.new(0, 175, 0, yOffsets[2] + 80))
local hitboxSizeZSlider = createSlider(combatContent, HBSizeZ, 1, 10, UDim2.new(0, 175, 0, yOffsets[2] + 125))
local hitboxTransparencySlider = createSlider(combatContent, HBTrans, 0, 1, UDim2.new(0, 175, 0, yOffsets[2] + 170))
hitboxExpanderButton.MouseButton1Click:Connect(function()
    -- Toggle hitbox logic
    hitboxExpanderToggle.Text = (not hitboxExpanderToggle.Text:match("On")) and "On" or "Off"
    HBSizeX = tonumber(hitboxSizeXSlider[2].Text) or 2.7
    HBSizeY = tonumber(hitboxSizeYSlider[2].Text) or 2.5
    HBSizeZ = tonumber(hitboxSizeZSlider[2].Text) or 2.7
    HBTrans = tonumber(hitboxTransparencySlider[2].Text) or 0.5
    updateHitboxSettings()
end)

combatContent.CanvasSize = UDim2.new(0, 0, 0, yOffsets[2] + 210)

-- Misc Tab
local miscContent = tabContent[3]

yOffsets[3] = yOffsets[3] + 5
local grassButton = createTextButton(miscContent, "Remove Grass", UDim2.new(0, 10, 0, yOffsets[3]))
local grassToggle = createTextButton(miscContent, "Off", UDim2.new(0, 175, 0, yOffsets[3]))
grassButton.MouseButton1Click:Connect(function()
    grassRemoved = not grassRemoved
    grassToggle.Text = grassRemoved and "On" or "Off"
    terrain.GrassHeight = grassRemoved and 0 or 1
    terrain.GrassSpread = grassRemoved and 0 or 50
end)

yOffsets[3] = yOffsets[3] + 35
local shadowsButton = createTextButton(miscContent, "No Shadows", UDim2.new(0, 10, 0, yOffsets[3]))
local shadowsToggle = createTextButton(miscContent, "Off", UDim2.new(0, 175, 0, yOffsets[3]))
shadowsButton.MouseButton1Click:Connect(function()
    shadowsDisabled = not shadowsDisabled
    shadowsToggle.Text = shadowsDisabled and "On" or "Off"
    lighting.GlobalShadows = not shadowsDisabled
end)

yOffsets[3] = yOffsets[3] + 35
local particlesButton = createTextButton(miscContent, "No Particles", UDim2.new(0, 10, 0, yOffsets[3]))
local particlesToggle = createTextButton(miscContent, "Off", UDim2.new(0, 175, 0, yOffsets[3]))
particlesButton.MouseButton1Click:Connect(function()
    particlesDisabled = not particlesDisabled
    particlesToggle.Text = particlesDisabled and "On" or "Off"
    for _, obj in pairs(game.Workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") then obj.Enabled = not particlesDisabled end
    end
end)

yOffsets[3] = yOffsets[3] + 35
local decalsButton = createTextButton(miscContent, "No Decals", UDim2.new(0, 10, 0, yOffsets[3]))
local decalsToggle = createTextButton(miscContent, "Off", UDim2.new(0, 175, 0, yOffsets[3]))
decalsButton.MouseButton1Click:Connect(function()
    decalsDisabled = not decalsDisabled
    decalsToggle.Text = decalsDisabled and "Off" or "On"
    for _, obj in pairs(game.Workspace:GetDescendants()) do
        if obj:IsA("Decal") then obj.Transparency = decalsDisabled and 1 or 0 end
    end
end)

yOffsets[3] = yOffsets[3] + 35
local animationsButton = createTextButton(miscContent, "No Animations", UDim2.new(0, 10, 0, yOffsets[3]))
local animationsToggle = createTextButton(miscContent, "Off", UDim2.new(0, 175, 0, yOffsets[3]))
animationsButton.MouseButton1Click:Connect(function()
    animationsDisabled = not animationsDisabled
    animationsToggle.Text = animationsDisabled and "On" or "Off"
    for _, p in pairs(game.Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("Humanoid") then
            local animator = p.Character.Humanoid:FindChildOfClass("Animator")
            if animator then animator.Parent = animationsDisabled and nil or p.Character.Humanoid end
        end
    end
end)

yOffsets[3] = yOffsets[3] + 35
local meshButton = createTextButton(miscContent, "Low Meshes", UDim2.new(0, 10, 0, yOffsets[3]))
local meshToggle = createTextButton(miscContent, "Off", UDim2.new(0, 175, 0, yOffsets[3]))
meshButton.MouseButton1Click:Connect(function()
    meshDetailLow = not meshDetailLow
    meshToggle.Text = meshDetailLow and "On" or "Off"
    for _, obj in pairs(game.Workspace:GetDescendants()) do
        if obj:IsA("MeshPart") then obj.TextureID = meshDetailLow and "" or obj.TextureID end
    end
end)

yOffsets[3] = yOffsets[3] + 35
local fogButton = createTextButton(miscContent, "No Fog", UDim2.new(0, 10, 0, yOffsets[3]))
local fogToggle = createTextButton(miscContent, "Off", UDim2.new(0, 175, 0, yOffsets[3]))
fogButton.MouseButton1Click:Connect(function()
    fogDisabled = not fogDisabled
    fogToggle.Text = fogDisabled and "On" or "Off"
    lighting.FogEnd = fogDisabled and 100000 or 500
    lighting.FogStart = fogDisabled and 100000 or 0
end)

yOffsets[3] = yOffsets[3] + 35
local lightingEffectsButton = createTextButton(miscContent, "Low Lighting", UDim2.new(0, 10, 0, yOffsets[3]))
local lightingEffectsToggle = createTextButton(miscContent, "Off", UDim2.new(0, 175, 0, yOffsets[3]))
lightingEffectsButton.MouseButton1Click:Connect(function()
    lightingEffectsLow = not lightingEffectsLow
    lightingEffectsToggle.Text = lightingEffectsLow and "On" or "Off"
    lighting.Technology = lightingEffectsLow and Enum.Technology.Compatibility or Enum.Technology.Future
end)

yOffsets[3] = yOffsets[3] + 35
local skyboxButton = createTextButton(miscContent, "No Skybox", UDim2.new(0, 10, 0, yOffsets[3]))
local skyboxToggle = createTextButton(miscContent, "Off", UDim2.new(0, 175, 0, yOffsets[3]))
skyboxButton.MouseButton1Click:Connect(function()
    skyboxDisabled = not skyboxDisabled
    skyboxToggle.Text = skyboxDisabled and "On" or "Off"
    local sky = lighting:FindFirstChild("Sky")
    if sky then sky.Parent = skyboxDisabled and nil or lighting end
end)

yOffsets[3] = yOffsets[3] + 35
local postProcessingButton = createTextButton(miscContent, "No Post-Processing", UDim2.new(0, 10, 0, yOffsets[3]))
local postProcessingToggle = createTextButton(miscContent, "Off", UDim2.new(0, 175, 0, yOffsets[3]))
postProcessingButton.MouseButton1Click:Connect(function()
    postProcessingDisabled = not postProcessingDisabled
    postProcessingToggle.Text = postProcessingDisabled and "On" or "Off"
    for _, effect in pairs(lighting:GetChildren()) do
        if effect:IsA("BloomEffect") or effect:IsA("BlurEffect") or effect:IsA("ColorCorrectionEffect") then
            effect.Enabled = not postProcessingDisabled
        end
    end
end)

yOffsets[3] = yOffsets[3] + 35
local particleDensityButton = createTextButton(miscContent, "Low Particle Density", UDim2.new(0, 10, 0, yOffsets[3]))
local particleDensityToggle = createTextButton(miscContent, "Off", UDim2.new(0, 175, 0, yOffsets[3]))
particleDensityButton.MouseButton1Click:Connect(function()
    particleDensityLow = not particleDensityLow
    particleDensityToggle.Text = particleDensityLow and "On" or "Off"
    for _, obj in pairs(game.Workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") then obj.Rate = particleDensityLow and obj.Rate * 0.1 or obj.Rate * 10 end
    end
end)

yOffsets[3] = yOffsets[3] + 35
local terrainDetailsButton = createTextButton(miscContent, "Low Terrain Detail", UDim2.new(0, 10, 0, yOffsets[3]))
local terrainDetailsToggle = createTextButton(miscContent, "Off", UDim2.new(0, 175, 0, yOffsets[3]))
terrainDetailsButton.MouseButton1Click:Connect(function()
    terrainDetailsDisabled = not terrainDetailsDisabled
    terrainDetailsToggle.Text = terrainDetailsDisabled and "On" or "Off"
    terrain.Decoration = not terrainDetailsDisabled
end)

yOffsets[3] = yOffsets[3] + 35
local networkButton = createTextButton(miscContent, "Optimize Network", UDim2.new(0, 10, 0, yOffsets[3]))
local networkToggle = createTextButton(miscContent, "Off", UDim2.new(0, 175, 0, yOffsets[3]))
networkButton.MouseButton1Click:Connect(function()
    networkOptimized = not networkOptimized
    networkToggle.Text = networkOptimized and "On" or "Off"
    settings().Network.IncomingReplicationLag = networkOptimized and 0.05 or 0
end)

yOffsets[3] = yOffsets[3] + 35
local waterTransparencyButton = createTextButton(miscContent, "Water Transparency", UDim2.new(0, 10, 0, yOffsets[3]))
local waterTransparencySlider = createSlider(miscContent, 0, 0, 1, UDim2.new(0, 175, 0, yOffsets[3] + 35))
waterTransparencyButton.MouseButton1Click:Connect(function()
    local value = tonumber(waterTransparencySlider[2].Text) or 0
    for _, part in pairs(game.Workspace:GetDescendants()) do
        if part:IsA("BasePart") and part.Name:lower():find("water") then
            part.Transparency = value
        end
    end
end)

yOffsets[3] = yOffsets[3] + 70
local terrainTransparencyButton = createTextButton(miscContent, "Terrain Transparency", UDim2.new(0, 10, 0, yOffsets[3]))
local terrainTransparencySlider = createSlider(miscContent, 0, 0, 1, UDim2.new(0, 175, 0, yOffsets[3] + 35))
terrainTransparencyButton.MouseButton1Click:Connect(function()
    local value = tonumber(terrainTransparencySlider[2].Text) or 0
    terrain.WaterColor = Color3.new(value, value, value)
    terrain.WaterTransparency = value
end)

yOffsets[3] = yOffsets[3] + 70
local reducePhysicsButton = createTextButton(miscContent, "Reduce Physics", UDim2.new(0, 10, 0, yOffsets[3]))
local reducePhysicsToggle = createTextButton(miscContent, "Off", UDim2.new(0, 175, 0, yOffsets[3]))
reducePhysicsButton.MouseButton1Click:Connect(function()
    reducePhysics = not reducePhysics
    reducePhysicsToggle.Text = reducePhysics and "On" or "Off"
    physicsService:SetCollisionGroupEnabled("Default", not reducePhysics)
end)

yOffsets[3] = yOffsets[3] + 35
local lowRenderDistanceButton = createTextButton(miscContent, "Low Render Distance", UDim2.new(0, 10, 0, yOffsets[3]))
local lowRenderDistanceToggle = createTextButton(miscContent, "Off", UDim2.new(0, 175, 0, yOffsets[3]))
lowRenderDistanceButton.MouseButton1Click:Connect(function()
    lowRenderDistance = not lowRenderDistance
    lowRenderDistanceToggle.Text = lowRenderDistance and "On" or "Off"
    game.Workspace.RenderDistance = lowRenderDistance and 100 or 1000
end)

miscContent.CanvasSize = UDim2.new(0, 0, 0, yOffsets[3] + 105)

-- UI Tab
local uiContent = tabContent[4]
local guiTransparency = 0
local customKeybind = Enum.KeyCode.F5
local menuColor = Color3.fromRGB(20, 20, 40)

yOffsets[4] = yOffsets[4] + 5
local titleButton = createTextButton(uiContent, "Title On/Off", UDim2.new(0, 10, 0, yOffsets[4]))
local titleToggle = createTextButton(uiContent, "Off", UDim2.new(0, 175, 0, yOffsets[4]))
titleButton.MouseButton1Click:Connect(function()
    toggleTitle()
    titleToggle.Text = isTitleEnabled and "On" or "Off"
end)

yOffsets[4] = yOffsets[4] + 35
local transparencyButton = createTextButton(uiContent, "GUI Transparency", UDim2.new(0, 10, 0, yOffsets[4]))
local transparencySlider = createSlider(uiContent, 0, 0, 1, UDim2.new(0, 175, 0, yOffsets[4] + 35))
transparencyButton.MouseButton1Click:Connect(function()
    local value = tonumber(transparencySlider[2].Text) or 0
    guiTransparency = math.clamp(value, 0, 1)
    menuFrame.BackgroundTransparency = guiTransparency
    tabButtonsFrame.BackgroundTransparency = guiTransparency
    headerFrame.BackgroundTransparency = guiTransparency
    for _, content in pairs(tabContent) do
        content.BackgroundTransparency = guiTransparency
    end
end)

yOffsets[4] = yOffsets[4] + 70
local keybindButton = createTextButton(uiContent, "Set Keybind", UDim2.new(0, 10, 0, yOffsets[4]))
local keybindText = createTextButton(uiContent, "F5", UDim2.new(0, 175, 0, yOffsets[4]))
keybindButton.MouseButton1Click:Connect(function()
    userInputService.InputBegan:Wait()
    local input = userInputService.InputBegan:Wait()
    if input.KeyCode ~= Enum.KeyCode.Unknown then
        customKeybind = input.KeyCode
        keybindText.Text = customKeybind.Name
    end
end)

yOffsets[4] = yOffsets[4] + 35
local resetPositionButton = createTextButton(uiContent, "Reset GUI Pos", UDim2.new(0, 10, 0, yOffsets[4]))
resetPositionButton.MouseButton1Click:Connect(function()
    menuFrame.Position = UDim2.new(0, 0, 0, 0)
end)

yOffsets[4] = yOffsets[4] + 35
local lockPositionButton = createTextButton(uiContent, "Lock GUI Pos", UDim2.new(0, 10, 0, yOffsets[4]))
local lockPositionToggle = createTextButton(uiContent, "Off", UDim2.new(0, 175, 0, yOffsets[4]))
local isLocked = false
lockPositionButton.MouseButton1Click:Connect(function()
    isLocked = not isLocked
    lockPositionToggle.Text = isLocked and "On" or "Off"
end)

yOffsets[4] = yOffsets[4] + 35
local menuColorButton = createTextButton(uiContent, "Menu Color", UDim2.new(0, 10, 0, yOffsets[4]))
local colorSliderR = createSlider(uiContent, 20, 0, 255, UDim2.new(0, 175, 0, yOffsets[4] + 35))
local colorSliderG = createSlider(uiContent, 20, 0, 255, UDim2.new(0, 175, 0, yOffsets[4] + 80))
local colorSliderB = createSlider(uiContent, 40, 0, 255, UDim2.new(0, 175, 0, yOffsets[4] + 125))
menuColorButton.MouseButton1Click:Connect(function()
    local r = tonumber(colorSliderR[2].Text) or 20
    local g = tonumber(colorSliderG[2].Text) or 20
    local b = tonumber(colorSliderB[2].Text) or 40
    menuColor = Color3.fromRGB(r, g, b)
    menuFrame.BackgroundColor3 = menuColor
    headerFrame.BackgroundColor3 = menuColor:Lerp(Color3.fromRGB(5, 5, 10), 0.1)
    for _, content in pairs(tabContent) do
        content.BackgroundColor3 = menuColor:Lerp(Color3.fromRGB(5, 5, 10), 0.2)
    end
    tabButtonsFrame.BackgroundColor3 = menuColor:Lerp(Color3.fromRGB(10, 10, 20), 0.3)
end)

uiContent.CanvasSize = UDim2.new(0, 0, 0, yOffsets[4] + 160)

-- Range Tab
local rangeContent = tabContent[5]

yOffsets[5] = yOffsets[5] + 5
local spinButton = createTextButton(rangeContent, "Spin Hack On/Off", UDim2.new(0, 10, 0, yOffsets[5]))
local spinToggle = createTextButton(rangeContent, "Off", UDim2.new(0, 175, 0, yOffsets[5]))
spinButton.MouseButton1Click:Connect(function()
    -- Spin logic to be implemented
    spinToggle.Text = (not spinToggle.Text:match("On")) and "On" or "Off"
end)

yOffsets[5] = yOffsets[5] + 35
local ultraButton = createTextButton(rangeContent, "ULTRA On/Off", UDim2.new(0, 10, 0, yOffsets[5]))
local ultraToggle = createTextButton(rangeContent, "Off", UDim2.new(0, 175, 0, yOffsets[5]))
local ultraKeybindButton = createTextButton(rangeContent, "Set ULTRA Key", UDim2.new(0, 10, 0, yOffsets[5] + 35))
local ultraKeybindText = createTextButton(rangeContent, "T", UDim2.new(0, 175, 0, yOffsets[5] + 35))
ultraButton.MouseButton1Click:Connect(function()
    -- ULTRA logic to be implemented
    ultraToggle.Text = (not ultraToggle.Text:match("On")) and "On" or "Off"
end)
ultraKeybindButton.MouseButton1Click:Connect(function()
    userInputService.InputBegan:Wait()
    local input = userInputService.InputBegan:Wait()
    if input.KeyCode ~= Enum.KeyCode.Unknown then
        -- Set ULTRA keybind
        ultraKeybindText.Text = input.KeyCode.Name
    end
end)

yOffsets[5] = yOffsets[5] + 70
local wallhackRegenButton = createTextButton(rangeContent, "Wallhack/Regen On/Off", UDim2.new(0, 10, 0, yOffsets[5]))
local wallhackRegenToggle = createTextButton(rangeContent, "Off", UDim2.new(0, 175, 0, yOffsets[5]))
wallhackRegenButton.MouseButton1Click:Connect(function()
    -- Wallhack/Regen logic to be implemented
    wallhackRegenToggle.Text = (not wallhackRegenToggle.Text:match("On")) and "On" or "Off"
end)

rangeContent.CanvasSize = UDim2.new(0, 0, 0, yOffsets[5] + 70)

-- Player Tab
local playerContent = tabContent[6]
local isLongCheckEnabled = false
local longCheckDistance = 4
local isJumpBoostEnabled = false
local jumpPower = 50
local isGravityEnabled = false
local gravityValue = 196.2
local cameraFOV = 70

yOffsets[6] = yOffsets[6] + 5
local longCheckButton = createTextButton(playerContent, "Long Check On/Off", UDim2.new(0, 10, 0, yOffsets[6]))
local longCheckToggle = createTextButton(playerContent, "Off", UDim2.new(0, 175, 0, yOffsets[6]))
local longCheckDistanceSlider = createSlider(playerContent, longCheckDistance, 1, 20, UDim2.new(0, 175, 0, yOffsets[6] + 35))
longCheckButton.MouseButton1Click:Connect(function()
    isLongCheckEnabled = not isLongCheckEnabled
    longCheckToggle.Text = isLongCheckEnabled and "On" or "Off"
    longCheckDistance = tonumber(longCheckDistanceSlider[2].Text) or 4
end)

yOffsets[6] = yOffsets[6] + 70
local jumpBoostButton = createTextButton(playerContent, "Jump Boost On/Off", UDim2.new(0, 10, 0, yOffsets[6]))
local jumpBoostToggle = createTextButton(playerContent, "Off", UDim2.new(0, 175, 0, yOffsets[6]))
local jumpPowerSlider = createSlider(playerContent, jumpPower, 50, 200, UDim2.new(0, 175, 0, yOffsets[6] + 35))
jumpBoostButton.MouseButton1Click:Connect(function()
    isJumpBoostEnabled = not isJumpBoostEnabled
    jumpBoostToggle.Text = isJumpBoostEnabled and "On" or "Off"
    jumpPower = tonumber(jumpPowerSlider[2].Text) or 50
    if isJumpBoostEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.JumpPower = jumpPower
    end
end)

yOffsets[6] = yOffsets[6] + 70
local gravityButton = createTextButton(playerContent, "Custom Gravity On/Off", UDim2.new(0, 10, 0, yOffsets[6]))
local gravityToggle = createTextButton(playerContent, "Off", UDim2.new(0, 175, 0, yOffsets[6]))
local gravitySlider = createSlider(playerContent, gravityValue, 0, 300, UDim2.new(0, 175, 0, yOffsets[6] + 35))
gravityButton.MouseButton1Click:Connect(function()
    isGravityEnabled = not isGravityEnabled
    gravityToggle.Text = isGravityEnabled and "On" or "Off"
    gravityValue = tonumber(gravitySlider[2].Text) or 196.2
    if isGravityEnabled then
        game.Workspace.Gravity = gravityValue
    else
        game.Workspace.Gravity = 196.2
    end
end)

yOffsets[6] = yOffsets[6] + 70
local fovButton = createTextButton(playerContent, "Set FOV", UDim2.new(0, 10, 0, yOffsets[6]))
local fovSlider = createSlider(playerContent, cameraFOV, 10, 120, UDim2.new(0, 175, 0, yOffsets[6] + 35))
fovButton.MouseButton1Click:Connect(function()
    local value = tonumber(fovSlider[2].Text) or 70
    cameraFOV = math.clamp(value, 10, 120)
    camera.FieldOfView = cameraFOV
end)

playerContent.CanvasSize = UDim2.new(0, 0, 0, yOffsets[6] + 70)

-- Handle character respawns and updates
game.Players.PlayerAdded:Connect(function(playerAdded)
    playerAdded.CharacterAdded:Connect(function(character)
        -- ESP logic to be implemented
    end)
end)

runService.RenderStepped:Connect(function(delta)
    -- FPS Counter Update
    local currentTime = tick()
    fps = fps + 1
    if currentTime - lastTime >= 1 then
        fpsCounter.Text = "FPS: " .. fps
        fps = 0
        lastTime = currentTime
    end

    if isAimbotEnabled then
        circle.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X/2, workspace.CurrentCamera.ViewportSize.Y/2)
        if userInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            local target = findClosestPlayerInCircle()
            if target then
                local head = target:FindFirstChild("Head")
                if head then
                    local screenPos = workspace.CurrentCamera:WorldToViewportPoint(head.Position)
                    local targetPos = Vector2.new(screenPos.X, screenPos.Y)
                    local currentPos = userInputService:GetMouseLocation()
                    local delta = (targetPos - currentPos) * smoothFactor
                    mousemoverel(delta.X, delta.Y)
                end
            end
        end
    end

    if isLongCheckEnabled then
        local currentCFrame = camera.CFrame
        local newY = currentCFrame.Position.Y + longCheckDistance
        camera.CFrame = CFrame.new(currentCFrame.Position.X, newY, currentCFrame.Position.Z, currentCFrame:ToEulerAnglesXYZ())
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local humanoidRootPart = player.Character.HumanoidRootPart
            humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position.X, newY, humanoidRootPart.Position.Z)
        end
        local handModels = replicatedStorage:FindFirstChild("HandModels")
        if handModels then
            for _, model in pairs(handModels:GetDescendants()) do
                if model:IsA("Model") then
                    for _, part in pairs(model:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CFrame = part.CFrame + Vector3.new(0, longCheckDistance, 0)
                        end
                    end
                end
            end
        end
    end
end)

-- Make GUI draggable
local dragging, dragInput, dragStart, startPos
menuFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and not isLocked then
        dragging = true
        dragStart = input.Position
        startPos = menuFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
menuFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local delta = input.Position - dragStart
        menuFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Toggle GUI with custom keybind
userInputService.InputBegan:Connect(function(input)
    if input.KeyCode == customKeybind then
        screenGui.Enabled = not screenGui.Enabled
    end
end)

-- Loading to Menu Transition
task.delay(6, function()
    if loadingFrame and loadingFrame.Parent then
        loadingFrame:Destroy()
    end
    if menuFrame and menuFrame.Parent then
        menuFrame.Visible = true
    end
end)
