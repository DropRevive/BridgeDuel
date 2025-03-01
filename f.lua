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

local ESPEnabled = false

local function toggleESP(enabled)
    ESPEnabled = enabled
    if ESPEnabled then
        enableESP()
    else
        disableESP()
    end
end

local function enableESP()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local highlight = Instance.new("Highlight")
            highlight.Adornee = player.Character
            highlight.Parent = game.Workspace
        end
    end
end

local function disableESP()
    for _, highlight in pairs(game.Workspace:GetChildren()) do
        if highlight:IsA("Highlight") then
            highlight:Destroy()
        end
    end
end

local cfg1 = {
    Title = "ESP",
    Drag = true,
    LineColor = Color3.fromRGB(255, 255, 255)
}
local mf1, cf1 = lib.CreateUI(cfg1)

lib.CreateToggle(cf1, {
    title = "ESP Player",
    callback = function(state)
        toggleESP(state)
    end
})
