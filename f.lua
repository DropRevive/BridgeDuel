-- Finter Library Module
local fl = {}
fl.__index = fl

local gui = Instance.new("ScreenGui")
gui.Name = "FLUI"
gui.Parent = game:GetService("CoreGui")

local posX = 0.05

local function calcSize(f)
    local totalHeight = 0
    for _, e in ipairs(f:GetChildren()) do
        if e:IsA("GuiObject") then
            totalHeight = totalHeight + e.Size.Y.Offset
        end
    end
    return totalHeight
end

function fl:CreateUI(cfg)
    local mf = Instance.new("Frame")
    mf.Name = cfg.Title or "MainFrame"
    mf.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    mf.BorderSizePixel = 0
    mf.Parent = gui
    mf.Active = true
    if cfg.Drag then
        mf.Draggable = true
    end

    local tb = Instance.new("Frame")
    tb.Name = "TitleBar"
    tb.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    tb.BorderSizePixel = 0
    tb.Parent = mf

    local tt = Instance.new("TextLabel")
    tt.Name = "TitleText"
    tt.Size = UDim2.new(1, 0, 1, 0)
    tt.BackgroundTransparency = 1
    tt.Text = cfg.Title or "Title"
    tt.TextColor3 = Color3.fromRGB(255, 255, 255)
    tt.TextScaled = true
    tt.Font = Enum.Font.RobotoMono
    tt.Parent = tb

    local bl = Instance.new("Frame")
    bl.Name = "BottomLine"
    bl.Size = UDim2.new(1, 0, 0, 3.25)
    bl.Position = UDim2.new(0, 0, 1, 0)
    bl.BackgroundColor3 = cfg.LineColor or Color3.fromRGB(255, 255, 255)
    bl.BorderSizePixel = 0
    bl.Parent = tb

    local cf = Instance.new("Frame")
    cf.Name = "ContentFrame"
    cf.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    cf.BorderSizePixel = 0
    cf.Parent = mf

    local cl = Instance.new("UIListLayout")
    cl.Parent = cf

    self:AdjustFrameSize(mf)

    mf.Position = UDim2.new(posX, 0, 0.1, 0)
    posX = posX + 0.25

    return mf, cf
end

function fl:CreateButton(p, cfg)
    local b = Instance.new("TextButton")
    b.Name = cfg.title
    b.Size = UDim2.new(1, 0, 0, 30)
    b.BackgroundTransparency = 0
    b.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    b.Text = cfg.title
    b.BorderSizePixel = 0
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextScaled = true
    b.Font = Enum.Font.RobotoMono
    b.Parent = p

    if cfg.callback then
        b.MouseButton1Click:Connect(cfg.callback)
    end

    return b
end

function fl:CreateToggle(p, cfg)
    local t = Instance.new("TextButton")
    t.Name = cfg.title
    t.Size = UDim2.new(1, 0, 0, 30)
    t.BackgroundTransparency = 0
    t.Text = cfg.title
    t.BorderSizePixel = 0
    t.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    t.TextColor3 = Color3.fromRGB(255, 255, 255)
    t.TextScaled = true
    t.Font = Enum.Font.RobotoMono
    t.Parent = p

    local toggled = false
    t.MouseButton1Click:Connect(function()
        toggled = not toggled
        if cfg.callback then
            cfg.callback(toggled)
        end
        t.TextColor3 = toggled and Color3.fromRGB(85, 170, 85) or Color3.fromRGB(255, 255, 255)
    end)

    return t
end
function fl:CreateSlider(p, cfg)
    local t = Instance.new("TextLabel")
    t.Name = cfg.title
    t.Size = UDim2.new(1, 0, 0, 30)
    t.BackgroundTransparency = 0
    t.Text = cfg.title
    t.BorderSizePixel = 0
    t.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    t.TextColor3 = Color3.fromRGB(255, 255, 255)
    t.TextScaled = true
    t.Font = Enum.Font.RobotoMono
    t.Parent = p

    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, 0, 0, 30)
    sliderFrame.Position = UDim2.new(0, 0, 0, 30)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Parent = p

    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(0.5, 0, 1, 0) 
    sliderBar.BackgroundColor3 = Color3.fromRGB(85, 170, 85)
    sliderBar.BorderSizePixel = 0
    sliderBar.Parent = sliderFrame

    
    local sliderButton = Instance.new("ImageButton")
    sliderButton.Size = UDim2.new(0, 20, 1, 0)
    sliderButton.Position = UDim2.new(0.5, -10, 0, 0) 
    sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderButton.BorderSizePixel = 0
    sliderButton.Parent = sliderFrame

    
    local dragging = false

    sliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)

    sliderButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    sliderFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            local x = math.clamp(input.Position.X - sliderFrame.AbsolutePosition.X, 0, sliderFrame.AbsoluteSize.X)
            sliderButton.Position = UDim2.new(x / sliderFrame.AbsoluteSize.X, -10, 0, 0)
            sliderBar.Size = UDim2.new(x / sliderFrame.AbsoluteSize.X, 0, 1, 0)
            if cfg.callback then
                cfg.callback(x / sliderFrame.AbsoluteSize.X)
            end
        end
    end)

    sliderFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local x = math.clamp(input.Position.X - sliderFrame.AbsolutePosition.X, 0, sliderFrame.AbsoluteSize.X)
            sliderButton.Position = UDim2.new(x / sliderFrame.AbsoluteSize.X, -10, 0, 0)
            sliderBar.Size = UDim2.new(x / sliderFrame.AbsoluteSize.X, 0, 1, 0)
            if cfg.callback then
                cfg.callback(x / sliderFrame.AbsoluteSize.X)
            end
        end
    end)
    
    return t, sliderFrame
end

function fl:AdjustFrameSize(f)
    local cf = f:FindFirstChild("ContentFrame")
    local cl = cf:FindFirstChildOfClass("UIListLayout")
    if cl then
        local th = calcSize(cf)
        f.Size = UDim2.new(0, 200, 0, th + 30 + 3.25)
        cf.Size = UDim2.new(1, 0, 1, -33.25)
        cf.Position = UDim2.new(0, 0, 0, 33.25)
        local tb = f:FindFirstChild("TitleBar")
        tb.Size = UDim2.new(1, 0, 0, th + 30)
    end
end

shared.FinterLibrary = fl

while not shared.FinterLibrary do
    wait()
end

local fl = shared.FinterLibrary

local tab = {
    Title = "Bridge Duel",
    Drag = true,
    LineColor = Color3.fromRGB(255, 255, 255)
}
local mf1, cf1 = fl:CreateUI(tab)

fl:CreateButton(cf1, {
    title = "aimbot",
    callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/DropRevive/esp/refs/heads/main/Aimbot%20Pro(AI%20Create).lua%20(1).txt"))()
    end
})

fl:CreateButton(cf1, {
    title = "vape v4",
    callback = function()
      loadstring(game:HttpGet("https://rawscripts.net/raw/BedWars-Epilogue-voidware-vape-v4-15982"))()
    end
})

local cfg = {
    Title = "exploits",
    Drag = true,
    LineColor = Color3.fromRGB(255, 255, 255)
}
local mf2, cf2 = fl:CreateUI(cfg)

local ESPEnabled = false

local function toggleESP(enabled)
    ESPEnabled = enabled
    if ESPEnabled then
        for _, player in pairs(game:GetService("Players"):GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local highlight = Instance.new("Highlight")
                highlight.Adornee = player.Character
                highlight.Parent = game.Workspace
            end
        end
        game:GetService("Players").PlayerAdded:Connect(function(player)
            if ESPEnabled then
                player.CharacterAdded:Connect(function(character)
                    local highlight = Instance.new("Highlight")
                    highlight.Adornee = character
                    highlight.Parent = game.Workspace
                end)
            end
        end)
    else
        for _, highlight in pairs(game.Workspace:GetChildren()) do
            if highlight:IsA("Highlight") then
                highlight:Destroy()
            end
        end
    end
end

fl:CreateToggle(cf2, {
    title = "ESP Player",
    callback = function(state)
        toggleESP(state)
    end
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local SpinEnabled = false
local SpinVelocity = Vector3.new(0, 50, 0)

local function enableSpin()
    SpinEnabled = true
end

local function disableSpin()
    SpinEnabled = false
end

local function onHeartbeat()
    if SpinEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local rootPart = player.Character.HumanoidRootPart
                rootPart.RotVelocity = SpinVelocity
            end
        end
    else
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local rootPart = player.Character.HumanoidRootPart
                rootPart.RotVelocity = Vector3.new(0, 0, 0)
            end
        end
    end
end

RunService.Heartbeat:Connect(onHeartbeat)

local function toggleSpin(enabled)
    if enabled then
        enableSpin()
    else
        disableSpin()
    end
end

fl:CreateToggle(cf2, {
    title = "Spin Player",
    callback = function(state)
        toggleSpin(state)
    end
})

-- 添加 Walk Jump 功能
local WalkJumpEnabled = false

local function enableWalkJump()
    WalkJumpEnabled = true
end

local function disableWalkJump()
    WalkJumpEnabled = false
end

local function onPlayerMove()
    if WalkJumpEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                local humanoid = player.Character.Humanoid
                if humanoid.MoveDirection.Magnitude > 0 then
                    humanoid.Jump = true
                end
            end
        end
    end
end

RunService.Heartbeat:Connect(onPlayerMove)

local function toggleWalkJump(enabled)
    if enabled then
        enableWalkJump()
    else
        disableWalkJump()
    end
end

fl:CreateToggle(cf2, {
    title = "Walk Jump",
    callback = function(state)
        toggleWalkJump(state)
    end
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local WalkSpeedValue = 16

local function setWalkSpeed(value)
    WalkSpeedValue = value 
end

RunService.Heartbeat:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local humanoidRootPart = player.Character.HumanoidRootPart
            if player.Character:FindFirstChild("Humanoid").MoveDirection.Magnitude > 0 then
                local moveDirection = player.Character.Humanoid.MoveDirection * WalkSpeedValue
                humanoidRootPart.Velocity = Vector3.new(moveDirection.X, humanoidRootPart.Velocity.Y, moveDirection.Z)
            end
        end
    end
end)

fl:CreateSlider(cf2, {
    title = "Velocity Walk Speed",
    callback = function(value)
        setWalkSpeed(value)
    end
})
