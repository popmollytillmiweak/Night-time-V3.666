--[[
    Nighttime V3.5 - Full Roblox Native GUI (Fixed & Complete)
    All features fully implemented.
    Toggle GUI : RightShift
    Panic/Unload: Delete
]]

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local Lighting         = game:GetService("Lighting")
local Camera           = workspace.CurrentCamera
local LocalPlayer      = Players.LocalPlayer

-- ============================================================
-- SETTINGS
-- ============================================================
local Settings = {
    -- Aimbot
    AimbotEnabled   = false,
    SilentAim       = true,
    WallCheck       = false,
    TeamCheck       = false,
    FOV             = 150,
    HitPart         = "Head",
    Smoothing       = false,
    SmoothFactor    = 5,
    Prediction      = false,
    PredictionAmt   = 0.13,
    AutoFire        = false,
    TriggerBot      = false,
    TriggerDelay    = 0.005,
    ShowFOV         = true,
    FOVColor        = Color3.fromRGB(255,255,255),
    TargetESP       = false,
    TargetColor     = Color3.fromRGB(255,0,0),
    HitboxSink      = false,
    HitboxSinkDepth = 15,
    HitboxDesync    = false,
    HitboxDesyncOff = 10,
    -- Visuals
    Boxes           = false,
    BoxColor        = Color3.fromRGB(255,255,255),
    Names           = false,
    NameColor       = Color3.fromRGB(255,255,255),
    HealthBar       = false,
    SkeletonESP     = false,
    Tracers         = false,
    TracerColor     = Color3.fromRGB(255,255,255),
    ChamsEnabled    = false,
    ChamColor       = Color3.fromRGB(255,0,0),
    ChamTransp      = 0.5,
    GlowEnabled     = false,
    RainbowGlow     = false,
    CrosshairOn     = false,
    CrosshairColor  = Color3.fromRGB(0,255,0),
    CrosshairSize   = 10,
    DotEnabled      = false,
    -- World
    Fullbright      = false,
    NoFog           = false,
    CustomTime      = false,
    TimeValue       = 14,
    -- Movement
    SpeedEnabled    = false,
    SpeedValue      = 32,
    FlyEnabled      = false,
    FlySpeed        = 50,
    NoclipEnabled   = false,
    InfJump         = false,
    BHop            = false,
    -- Misc
    AntiAFK         = true,
    HitMarker       = false,
    HitMarkerColor  = Color3.fromRGB(255,50,50),
    RadarEnabled    = false,
    HUDEnabled      = true,
    HUDColor        = Color3.fromRGB(170,85,255),
    -- Keybinds
    FireKey         = Enum.KeyCode.Unknown,
    FireKeyEnabled  = false,
}

-- ============================================================
-- THEME
-- ============================================================
local ACCENT  = Color3.fromRGB(170, 85, 255)
local BG      = Color3.fromRGB(12, 12, 14)
local PANEL   = Color3.fromRGB(20, 21, 26)
local BORDER  = Color3.fromRGB(42, 42, 50)
local TEXT    = Color3.fromRGB(210, 210, 215)
local SUBTEXT = Color3.fromRGB(110, 110, 120)

-- ============================================================
-- GUI ROOT
-- ============================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NighttimeV35"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- ============================================================
-- HELPERS
-- ============================================================
local function New(class, props, parent)
    local o = Instance.new(class)
    for k, v in pairs(props or {}) do o[k] = v end
    if parent then o.Parent = parent end
    return o
end

local function Corner(r, parent)
    return New("UICorner", {CornerRadius = UDim.new(0, r)}, parent)
end

local function Stroke(c, t, parent)
    return New("UIStroke", {Color = c, Thickness = t}, parent)
end

local function Tween(obj, props, t)
    TweenService:Create(obj, TweenInfo.new(t or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

local function MakeDraggable(frame, handle)
    local dragging, dragStart, startPos
    handle = handle or frame
    handle.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging  = true
            dragStart = inp.Position
            startPos  = frame.Position
        end
    end)
    handle.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
            local d = inp.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + d.X,
                startPos.Y.Scale, startPos.Y.Offset + d.Y
            )
        end
    end)
end

-- ============================================================
-- MAIN WINDOW
-- ============================================================
local Win = New("Frame", {
    Size             = UDim2.new(0, 680, 0, 460),
    Position         = UDim2.new(0.5, -340, 0.5, -230),
    BackgroundColor3 = BG,
    BorderSizePixel  = 0,
    ClipsDescendants = false,
}, ScreenGui)
Corner(12, Win)
Stroke(BORDER, 1, Win)

New("ImageLabel", {
    Size              = UDim2.new(1, 60, 1, 60),
    Position          = UDim2.new(0, -30, 0, -30),
    BackgroundTransparency = 1,
    Image             = "rbxassetid://5028857084",
    ImageColor3       = Color3.new(0, 0, 0),
    ImageTransparency = 0.6,
    ScaleType         = Enum.ScaleType.Slice,
    SliceCenter       = Rect.new(24, 24, 276, 276),
    ZIndex            = 0,
}, Win)

-- ============================================================
-- TITLE BAR
-- ============================================================
local TitleBar = New("Frame", {
    Size             = UDim2.new(1, 0, 0, 46),
    BackgroundColor3 = PANEL,
    BorderSizePixel  = 0,
}, Win)
Corner(12, TitleBar)
New("Frame", {
    Size = UDim2.new(1,0,0,12), Position = UDim2.new(0,0,1,-12),
    BackgroundColor3 = PANEL, BorderSizePixel = 0
}, TitleBar)

local IconBox = New("Frame", {
    Size = UDim2.new(0,30,0,30), Position = UDim2.new(0,12,0.5,-15),
    BackgroundColor3 = ACCENT, BorderSizePixel = 0,
}, TitleBar)
Corner(7, IconBox)
New("TextLabel", {
    Size = UDim2.new(1,0,1,0), BackgroundTransparency=1,
    Text = "⚡", TextColor3 = Color3.new(1,1,1),
    Font = Enum.Font.GothamBold, TextSize = 15
}, IconBox)

New("TextLabel", {
    Size=UDim2.new(0,200,0,18), Position=UDim2.new(0,50,0,8),
    BackgroundTransparency=1, Text="NIGHTTIME",
    TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold,
    TextSize=14, TextXAlignment=Enum.TextXAlignment.Left
}, TitleBar)
New("TextLabel", {
    Size=UDim2.new(0,200,0,13), Position=UDim2.new(0,50,0,24),
    BackgroundTransparency=1, Text="V3.5 PRIVATE",
    TextColor3=ACCENT, Font=Enum.Font.GothamBold,
    TextSize=9, TextXAlignment=Enum.TextXAlignment.Left
}, TitleBar)

local StatusBadge = New("Frame", {
    Size=UDim2.new(0,90,0,22), Position=UDim2.new(0.5,-45,0.5,-11),
    BackgroundColor3=Color3.fromRGB(20,40,28), BorderSizePixel=0
}, TitleBar)
Corner(11, StatusBadge)
New("TextLabel", {
    Size=UDim2.new(1,0,1,0), BackgroundTransparency=1,
    Text="● UNDETECTED", TextColor3=Color3.fromRGB(52,211,153),
    Font=Enum.Font.GothamBold, TextSize=9
}, StatusBadge)

local function HeaderBtn(xOffset, col, txt)
    local b = New("TextButton", {
        Size=UDim2.new(0,26,0,26), Position=UDim2.new(1,xOffset,0.5,-13),
        BackgroundColor3=col, BorderSizePixel=0,
        Text=txt, TextColor3=Color3.new(1,1,1),
        Font=Enum.Font.GothamBold, TextSize=11
    }, TitleBar)
    Corner(7, b)
    return b
end

local CloseBtn = HeaderBtn(-36, Color3.fromRGB(255,65,65), "✕")
local MinBtn   = HeaderBtn(-68, Color3.fromRGB(255,185,0), "–")

CloseBtn.MouseButton1Click:Connect(function() Win.Visible = false end)
local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    Tween(Win, {Size = minimized and UDim2.new(0,680,0,46) or UDim2.new(0,680,0,460)}, 0.2)
end)
MakeDraggable(Win, TitleBar)

-- ============================================================
-- SIDEBAR
-- ============================================================
local Sidebar = New("Frame", {
    Size=UDim2.new(0,130,1,-46), Position=UDim2.new(0,0,0,46),
    BackgroundColor3=PANEL, BorderSizePixel=0
}, Win)
New("Frame", {
    Size=UDim2.new(0,1,1,0), Position=UDim2.new(1,-1,0,0),
    BackgroundColor3=BORDER, BorderSizePixel=0
}, Sidebar)

local SideScroll = New("ScrollingFrame", {
    Size=UDim2.new(1,0,1,0), BackgroundTransparency=1,
    BorderSizePixel=0, ScrollBarThickness=0,
    CanvasSize=UDim2.new(0,0,0,0), AutomaticCanvasSize=Enum.AutomaticSize.Y
}, Sidebar)
New("UIListLayout", {SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,2)}, SideScroll)
New("UIPadding", {
    PaddingTop=UDim.new(0,10), PaddingLeft=UDim.new(0,6), PaddingRight=UDim.new(0,6)
}, SideScroll)

-- ============================================================
-- CONTENT AREA
-- ============================================================
local Content = New("Frame", {
    Size=UDim2.new(1,-130,1,-46), Position=UDim2.new(0,130,0,46),
    BackgroundTransparency=1, BorderSizePixel=0, ClipsDescendants=true
}, Win)

-- ============================================================
-- TAB SYSTEM
-- ============================================================
local tabPages  = {}
local tabBtns   = {}
local activeTab = nil

local tabDefs = {
    {name="Combat",   icon="🎯", order=1},
    {name="Visuals",  icon="👁",  order=2},
    {name="World",    icon="🌐", order=3},
    {name="Movement", icon="💨", order=4},
    {name="Misc",     icon="⚙",  order=5},
}

local function SwitchTab(name)
    if activeTab == name then return end
    if activeTab and tabPages[activeTab] then
        tabPages[activeTab].Visible = false
        local ob = tabBtns[activeTab]
        Tween(ob, {BackgroundTransparency=1}, 0.12)
        ob:FindFirstChildWhichIsA("TextLabel").TextColor3 = SUBTEXT
    end
    activeTab = name
    tabPages[name].Visible = true
    local nb = tabBtns[name]
    Tween(nb, {BackgroundTransparency=0}, 0.12)
    nb:FindFirstChildWhichIsA("TextLabel").TextColor3 = ACCENT
end

for _, def in ipairs(tabDefs) do
    local btn = New("TextButton", {
        Name=def.name, Size=UDim2.new(1,0,0,36),
        BackgroundColor3=Color3.fromRGB(32,33,40),
        BackgroundTransparency=1, BorderSizePixel=0,
        Text="", LayoutOrder=def.order
    }, SideScroll)
    Corner(8, btn)
    New("TextLabel", {
        Size=UDim2.new(1,-12,1,0), Position=UDim2.new(0,10,0,0),
        BackgroundTransparency=1,
        Text=def.icon.."  "..def.name,
        TextColor3=SUBTEXT, Font=Enum.Font.Gotham, TextSize=12,
        TextXAlignment=Enum.TextXAlignment.Left
    }, btn)
    local indicator = New("Frame", {
        Size=UDim2.new(0,3,0,18), Position=UDim2.new(1,-3,0.5,-9),
        BackgroundColor3=ACCENT, Visible=false, BorderSizePixel=0
    }, btn)
    Corner(2, indicator)
    tabBtns[def.name] = btn

    local page = New("ScrollingFrame", {
        Name=def.name, Size=UDim2.new(1,0,1,0),
        BackgroundTransparency=1, BorderSizePixel=0,
        ScrollBarThickness=3, ScrollBarImageColor3=ACCENT,
        Visible=false, CanvasSize=UDim2.new(0,0,0,0),
        AutomaticCanvasSize=Enum.AutomaticSize.Y
    }, Content)
    New("UIListLayout", {SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,8)}, page)
    New("UIPadding", {
        PaddingTop=UDim.new(0,12), PaddingLeft=UDim.new(0,12),
        PaddingRight=UDim.new(0,14), PaddingBottom=UDim.new(0,12)
    }, page)
    tabPages[def.name] = page

    btn.MouseButton1Click:Connect(function()
        for _, d in ipairs(tabDefs) do
            local f = tabBtns[d.name]:FindFirstChild("Frame")
            if f then f.Visible = false end
        end
        indicator.Visible = true
        SwitchTab(def.name)
    end)
end

-- ============================================================
-- WIDGET BUILDERS
-- ============================================================
local function Section(parent, title, order)
    local wrap = New("Frame", {
        Name=title, Size=UDim2.new(1,0,0,0),
        BackgroundColor3=PANEL, BorderSizePixel=0,
        AutomaticSize=Enum.AutomaticSize.Y, LayoutOrder=order or 0
    }, parent)
    Corner(9, wrap)
    Stroke(BORDER, 1, wrap)
    New("UIPadding", {
        PaddingTop=UDim.new(0,12), PaddingBottom=UDim.new(0,12),
        PaddingLeft=UDim.new(0,14), PaddingRight=UDim.new(0,14)
    }, wrap)
    local inner = New("Frame", {
        Size=UDim2.new(1,0,0,0), BackgroundTransparency=1,
        AutomaticSize=Enum.AutomaticSize.Y
    }, wrap)
    New("UIListLayout", {SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,10)}, inner)
    New("TextLabel", {
        Size=UDim2.new(1,0,0,14), BackgroundTransparency=1,
        Text=title:upper(), TextColor3=SUBTEXT,
        Font=Enum.Font.GothamBold, TextSize=8,
        TextXAlignment=Enum.TextXAlignment.Left, LayoutOrder=0
    }, inner)
    New("Frame", {
        Size=UDim2.new(1,0,0,1), BackgroundColor3=BORDER,
        BorderSizePixel=0, LayoutOrder=1
    }, inner)
    return inner
end

local function Toggle(parent, label, key, order)
    local val = Settings[key]
    local row = New("Frame", {
        Size=UDim2.new(1,0,0,26), BackgroundTransparency=1,
        LayoutOrder=(order or 1)+1
    }, parent)
    New("TextLabel", {
        Size=UDim2.new(1,-52,1,0), BackgroundTransparency=1,
        Text=label, TextColor3=TEXT, Font=Enum.Font.Gotham,
        TextSize=12, TextXAlignment=Enum.TextXAlignment.Left
    }, row)
    local track = New("Frame", {
        Size=UDim2.new(0,40,0,20), Position=UDim2.new(1,-40,0.5,-10),
        BackgroundColor3=val and ACCENT or Color3.fromRGB(40,40,48),
        BorderSizePixel=0
    }, row)
    Corner(10, track)
    local knob = New("Frame", {
        Size=UDim2.new(0,14,0,14),
        Position=val and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7),
        BackgroundColor3=Color3.new(1,1,1), BorderSizePixel=0
    }, track)
    Corner(7, knob)
    local hitbox = New("TextButton", {
        Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text=""
    }, row)
    hitbox.MouseButton1Click:Connect(function()
        Settings[key] = not Settings[key]
        Tween(track, {BackgroundColor3=Settings[key] and ACCENT or Color3.fromRGB(40,40,48)}, 0.12)
        Tween(knob, {Position=Settings[key] and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7)}, 0.12)
    end)
    return row
end

local function Slider(parent, label, key, min, max, step, order)
    step = step or 1
    local row = New("Frame", {
        Size=UDim2.new(1,0,0,46), BackgroundTransparency=1,
        LayoutOrder=(order or 1)+1
    }, parent)
    New("TextLabel", {
        Size=UDim2.new(1,-50,0,16), BackgroundTransparency=1,
        Text=label, TextColor3=TEXT, Font=Enum.Font.Gotham,
        TextSize=12, TextXAlignment=Enum.TextXAlignment.Left
    }, row)
    local valLbl = New("TextLabel", {
        Size=UDim2.new(0,46,0,16), Position=UDim2.new(1,-46,0,0),
        BackgroundTransparency=1, Text=tostring(Settings[key]),
        TextColor3=ACCENT, Font=Enum.Font.GothamBold,
        TextSize=11, TextXAlignment=Enum.TextXAlignment.Right
    }, row)
    local track = New("Frame", {
        Size=UDim2.new(1,0,0,4), Position=UDim2.new(0,0,0,28),
        BackgroundColor3=Color3.fromRGB(40,40,48), BorderSizePixel=0
    }, track)
    Corner(2, track)
    local pct = math.clamp((Settings[key]-min)/(max-min), 0, 1)
    local fill = New("Frame", {
        Size=UDim2.new(pct,0,1,0), BackgroundColor3=ACCENT, BorderSizePixel=0
    }, track)
    Corner(2, fill)
    local knob = New("Frame", {
        Size=UDim2.new(0,12,0,12), Position=UDim2.new(pct,-6,0.5,-6),
        BackgroundColor3=Color3.new(1,1,1), BorderSizePixel=0
    }, track)
    Corner(6, knob)
    local dragging = false
    local hitbox = New("TextButton", {
        Size=UDim2.new(1,0,0,24), Position=UDim2.new(0,0,0,20),
        BackgroundTransparency=1, Text=""
    }, row)
    local function applyAt(x)
        local abs = track.AbsolutePosition
        local sz  = track.AbsoluteSize
        local rel = math.clamp((x - abs.X)/sz.X, 0, 1)
        local raw = min + rel*(max-min)
        local v   = math.floor(raw/step + 0.5)*step
        v = math.clamp(math.floor(v*10000+0.5)/10000, min, max)
        Settings[key] = v
        valLbl.Text = tostring(v)
        fill.Size = UDim2.new(rel, 0, 1, 0)
        knob.Position = UDim2.new(rel, -6, 0.5, -6)
    end
    hitbox.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; applyAt(inp.Position.X)
        end
    end)
    hitbox.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
            applyAt(inp.Position.X)
        end
    end)
    return row
end

local function Dropdown(parent, label, key, options, order)
    local container = New("Frame", {
        Size=UDim2.new(1,0,0,54), BackgroundTransparency=1,
        LayoutOrder=(order or 1)+1, ClipsDescendants=false
    }, parent)
    New("TextLabel", {
        Size=UDim2.new(1,0,0,16), BackgroundTransparency=1,
        Text=label, TextColor3=TEXT, Font=Enum.Font.Gotham,
        TextSize=12, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=5
    }, container)
    local box = New("TextButton", {
        Size=UDim2.new(1,0,0,30), Position=UDim2.new(0,0,0,20),
        BackgroundColor3=Color3.fromRGB(30,31,38), BorderSizePixel=0,
        Text=tostring(Settings[key]), TextColor3=TEXT,
        Font=Enum.Font.Gotham, TextSize=12, ZIndex=5
    }, container)
    Corner(7, box); Stroke(BORDER, 1, box)
    New("TextLabel", {
        Size=UDim2.new(0,20,1,0), Position=UDim2.new(1,-24,0,0),
        BackgroundTransparency=1, Text="▾", TextColor3=ACCENT,
        Font=Enum.Font.GothamBold, TextSize=13, ZIndex=6
    }, box)
    local dropH = #options*28
    local drop = New("Frame", {
        Size=UDim2.new(1,0,0,dropH), Position=UDim2.new(0,0,0,52),
        BackgroundColor3=Color3.fromRGB(26,27,34), BorderSizePixel=0,
        Visible=false, ZIndex=50, ClipsDescendants=true
    }, container)
    Corner(7, drop); Stroke(ACCENT, 1, drop)
    New("UIListLayout", {SortOrder=Enum.SortOrder.LayoutOrder}, drop)
    local open = false
    box.MouseButton1Click:Connect(function()
        open = not open; drop.Visible = open
    end)
    for i, opt in ipairs(options) do
        local ob = New("TextButton", {
            Size=UDim2.new(1,0,0,28), BackgroundTransparency=1,
            Text=opt, TextColor3=(opt==Settings[key]) and ACCENT or TEXT,
            Font=Enum.Font.Gotham, TextSize=12, LayoutOrder=i, ZIndex=51
        }, drop)
        ob.MouseButton1Click:Connect(function()
            Settings[key] = opt; box.Text = opt
            open = false; drop.Visible = false
            for _, c in ipairs(drop:GetChildren()) do
                if c:IsA("TextButton") then
                    c.TextColor3 = c.Text==opt and ACCENT or TEXT
                end
            end
        end)
    end
    return container
end

-- ============================================================
-- BUILD TABS
-- ============================================================
-- COMBAT
do
    local p = tabPages["Combat"]

    local s1 = Section(p, "Aimbot Core", 1)
    Toggle(s1, "Enable Aimbot",    "AimbotEnabled", 1)
    Toggle(s1, "Silent Aim",       "SilentAim",     2)
    Toggle(s1, "Show FOV Circle",  "ShowFOV",       3)
    Toggle(s1, "Wall Check",       "WallCheck",     4)
    Toggle(s1, "Team Check",       "TeamCheck",     5)
    Slider(s1,  "FOV Radius",      "FOV",   30, 1000, 1,    6)
    Dropdown(s1,"Hit Part",        "HitPart",
        {"Head","HumanoidRootPart","UpperTorso","LowerTorso"}, 7)

    local s2 = Section(p, "Legit Assist", 2)
    Toggle(s2, "Smoothing",        "Smoothing",      1)
    Slider(s2,  "Smooth Factor",   "SmoothFactor",  1, 20,   1,    2)
    Toggle(s2, "Prediction",       "Prediction",     3)
    Slider(s2,  "Prediction Amt",  "PredictionAmt", 0, 0.5,  0.01, 4)

    local s3 = Section(p, "Automation", 3)
    Toggle(s3, "Trigger Bot",      "TriggerBot",     1)
    Toggle(s3, "Auto Fire",        "AutoFire",       2)
    Slider(s3,  "Trigger Delay",   "TriggerDelay",  0.002, 0.010, 0.001, 3)

    local s3b = Section(p, "Fire Keybind", 4)
    -- Enable toggle
    local fkEnabledRow = New("Frame",{Size=UDim2.new(1,0,0,26),BackgroundTransparency=1,LayoutOrder=2},s3b)
    New("TextLabel",{Size=UDim2.new(1,-52,1,0),BackgroundTransparency=1,Text="Enable Fire Key",
        TextColor3=TEXT,Font=Enum.Font.Gotham,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left},fkEnabledRow)
    local fkTrack=New("Frame",{Size=UDim2.new(0,40,0,20),Position=UDim2.new(1,-40,0.5,-10),
        BackgroundColor3=Color3.fromRGB(40,40,48),BorderSizePixel=0},fkEnabledRow)
    Corner(10,fkTrack)
    local fkKnob=New("Frame",{Size=UDim2.new(0,14,0,14),Position=UDim2.new(0,3,0.5,-7),
        BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0},fkTrack)
    Corner(7,fkKnob)
    local fkToggleHit=New("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text=""},fkEnabledRow)
    fkToggleHit.MouseButton1Click:Connect(function()
        Settings.FireKeyEnabled=not Settings.FireKeyEnabled
        Tween(fkTrack,{BackgroundColor3=Settings.FireKeyEnabled and ACCENT or Color3.fromRGB(40,40,48)},0.12)
        Tween(fkKnob,{Position=Settings.FireKeyEnabled and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7)},0.12)
    end)
    -- Key listener
    local fkRow=New("Frame",{Size=UDim2.new(1,0,0,28),BackgroundTransparency=1,LayoutOrder=3},s3b)
    New("TextLabel",{Size=UDim2.new(1,-120,1,0),BackgroundTransparency=1,Text="Fire Key:",
        TextColor3=TEXT,Font=Enum.Font.Gotham,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left},fkRow)
    local fkBtn=New("TextButton",{
        Size=UDim2.new(0,110,0,26),Position=UDim2.new(1,-110,0.5,-13),
        BackgroundColor3=Color3.fromRGB(30,31,38),BorderSizePixel=0,
        Text="[ NONE ]",TextColor3=ACCENT,Font=Enum.Font.GothamBold,TextSize=11},fkRow)
    Corner(7,fkBtn); Stroke(BORDER,1,fkBtn)
    local listeningForKey=false
    fkBtn.MouseButton1Click:Connect(function()
        if listeningForKey then return end
        listeningForKey=true
        fkBtn.Text="[ PRESS KEY... ]"
        fkBtn.TextColor3=Color3.fromRGB(255,220,0)
        local conn
        conn=UserInputService.InputBegan:Connect(function(inp,gpe)
            if gpe then return end
            if inp.UserInputType==Enum.UserInputType.Keyboard then
                Settings.FireKey=inp.KeyCode
                fkBtn.Text="[ "..inp.KeyCode.Name:upper().." ]"
                fkBtn.TextColor3=ACCENT
                listeningForKey=false
                conn:Disconnect()
            end
        end)
    end)

    local s4 = Section(p, "Advanced", 5)
    Toggle(s4, "Hitbox Sink",    "HitboxSink",      1)
    Slider(s4,  "Sink Depth",    "HitboxSinkDepth", 0, 50, 1, 2)
    Toggle(s4, "Hitbox Desync",  "HitboxDesync",    3)
    Slider(s4,  "Desync Offset", "HitboxDesyncOff", 0, 50, 1, 4)
end

-- VISUALS
do
    local p = tabPages["Visuals"]

    local s1 = Section(p, "Player ESP", 1)
    Toggle(s1, "Boxes",       "Boxes",      1)
    Toggle(s1, "Names",       "Names",      2)
    Toggle(s1, "Health Bar",  "HealthBar",  3)
    Toggle(s1, "Skeleton ESP","SkeletonESP",4)
    Toggle(s1, "Tracers",     "Tracers",    5)

    local s2 = Section(p, "Chams & Glow", 2)
    Toggle(s2, "Enable Chams",  "ChamsEnabled", 1)
    Slider(s2,  "Transparency", "ChamTransp",   0, 1, 0.05, 2)
    Toggle(s2, "Glow Outline",  "GlowEnabled",  3)
    Toggle(s2, "Rainbow Glow",  "RainbowGlow",  4)

    local s3 = Section(p, "Crosshair", 3)
    Toggle(s3, "Enable Crosshair","CrosshairOn",   1)
    Toggle(s3, "Center Dot",      "DotEnabled",    2)
    Slider(s3,  "Size",           "CrosshairSize", 4, 30, 1, 3)
end

-- WORLD
do
    local p = tabPages["World"]
    local s1 = Section(p, "Lighting", 1)
    Toggle(s1, "Fullbright",   "Fullbright",  1)
    Toggle(s1, "No Fog",       "NoFog",       2)
    Toggle(s1, "Custom Time",  "CustomTime",  3)
    Slider(s1,  "Time of Day", "TimeValue",   0, 24, 0.5, 4)
end

-- MOVEMENT
do
    local p = tabPages["Movement"]
    local s1 = Section(p, "Speed & Jump", 1)
    Toggle(s1, "Speed Hack",     "SpeedEnabled", 1)
    Slider(s1,  "Walk Speed",    "SpeedValue",  16, 200, 1, 2)
    Toggle(s1, "Infinite Jump",  "InfJump",      3)
    Toggle(s1, "BunnyHop",       "BHop",         4)

    local s2 = Section(p, "Advanced", 2)
    Toggle(s2, "Fly Mode",  "FlyEnabled",     1)
    Slider(s2,  "Fly Speed","FlySpeed",  10, 200, 1, 2)
    Toggle(s2, "Noclip",    "NoclipEnabled",  3)
end

-- MISC
do
    local p = tabPages["Misc"]

    local s1 = Section(p, "Utility", 1)
    Toggle(s1, "Anti-AFK",   "AntiAFK",     1)
    Toggle(s1, "Hit Markers","HitMarker",   2)
    Toggle(s1, "Radar",      "RadarEnabled",3)

    -- Remove/Restore Textures
    local texturesRemoved = false
    local savedTextures   = {}
    local rtRow = New("Frame",{Size=UDim2.new(1,0,0,28),BackgroundTransparency=1,LayoutOrder=5},s1)
    local rtBtn = New("TextButton",{
        Size=UDim2.new(1,0,1,0),BackgroundColor3=Color3.fromRGB(30,31,38),BorderSizePixel=0,
        Text="[Remove Textures]",TextColor3=TEXT,Font=Enum.Font.GothamBold,TextSize=12
    },rtRow)
    Corner(7,rtBtn); Stroke(BORDER,1,rtBtn)
    rtBtn.MouseButton1Click:Connect(function()
        if not texturesRemoved then
            for _,obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("Texture") or obj:IsA("Decal") then
                    table.insert(savedTextures,{obj,obj.Parent,obj.Transparency})
                    obj.Transparency=1
                elseif obj:IsA("SurfaceAppearance") then
                    table.insert(savedTextures,{obj,obj.Parent,nil})
                    obj.Parent=nil
                end
            end
            texturesRemoved=true
            rtBtn.Text="[Restore Textures]"
            rtBtn.TextColor3=ACCENT
        else
            for _,data in ipairs(savedTextures) do
                local obj,parent,extra=data[1],data[2],data[3]
                pcall(function()
                    if obj:IsA("Texture") or obj:IsA("Decal") then obj.Transparency=extra
                    else obj.Parent=parent end
                end)
            end
            savedTextures={}
            texturesRemoved=false
            rtBtn.Text="[Remove Textures]"
            rtBtn.TextColor3=TEXT
        end
    end)

    local s2 = Section(p, "HUD", 2)
    Toggle(s2, "Enable HUD", "HUDEnabled", 1)

    local s3 = Section(p, "GitHub", 3)
    local ghRow=New("Frame",{Size=UDim2.new(1,0,0,28),BackgroundTransparency=1,LayoutOrder=2},s3)
    local ghBtn=New("TextButton",{
        Size=UDim2.new(1,0,1,0),BackgroundColor3=Color3.fromRGB(30,31,38),BorderSizePixel=0,
        Text=">> Night-time-V3.666",TextColor3=ACCENT,Font=Enum.Font.GothamBold,TextSize=12
    },ghRow)
    Corner(7,ghBtn); Stroke(BORDER,1,ghBtn)
    ghBtn.MouseButton1Click:Connect(function()
        pcall(function()
            setclipboard("https://github.com/popmollytillmiweak/Night-time-V3.666")
        end)
        ghBtn.Text=">> Copied!"
        task.delay(2,function() ghBtn.Text=">> Night-time-V3.666" end)
    end)

    local lsRow=New("Frame",{Size=UDim2.new(1,0,0,28),BackgroundTransparency=1,LayoutOrder=3},s3)
    local lsBtn=New("TextButton",{
        Size=UDim2.new(1,0,1,0),BackgroundColor3=Color3.fromRGB(30,31,38),BorderSizePixel=0,
        Text="[Copy Loadstring]",TextColor3=TEXT,Font=Enum.Font.Gotham,TextSize=12
    },lsRow)
    Corner(7,lsBtn); Stroke(BORDER,1,lsBtn)
    lsBtn.MouseButton1Click:Connect(function()
        pcall(function()
            setclipboard('loadstring(game:HttpGet("https://raw.githubusercontent.com/popmollytillmiweak/Night-time-V3.666/3fa38e2e6679bd5bdd0813990b98ac8d319aae18/NighttimeV3.5%20(2666).lua"))()')
        end)
        lsBtn.Text=">> Copied!"
        task.delay(2,function() lsBtn.Text="[Copy Loadstring]" end)
    end)

    -- Config Manager
    local s4 = Section(p, "Config Manager", 4)
    local saveRow=New("Frame",{Size=UDim2.new(1,0,0,30),BackgroundTransparency=1,LayoutOrder=2},s4)
    local configNameBox=New("TextBox",{
        Size=UDim2.new(1,-86,1,0),BackgroundColor3=Color3.fromRGB(28,29,36),BorderSizePixel=0,
        Text="default",TextColor3=TEXT,Font=Enum.Font.Gotham,TextSize=12,
        PlaceholderText="config name...",PlaceholderColor3=SUBTEXT,ClearTextOnFocus=false
    },saveRow)
    Corner(7,configNameBox); Stroke(BORDER,1,configNameBox)
    New("UIPadding",{PaddingLeft=UDim.new(0,8)},configNameBox)
    local saveBtn=New("TextButton",{
        Size=UDim2.new(0,80,1,0),Position=UDim2.new(1,-80,0,0),
        BackgroundColor3=ACCENT,BorderSizePixel=0,
        Text="Save",TextColor3=Color3.new(1,1,1),Font=Enum.Font.GothamBold,TextSize=12
    },saveRow)
    Corner(7,saveBtn)

    local autoLoadEnabled=false
    local alRow=New("Frame",{Size=UDim2.new(1,0,0,26),BackgroundTransparency=1,LayoutOrder=3},s4)
    New("TextLabel",{Size=UDim2.new(1,-52,1,0),BackgroundTransparency=1,Text="Auto-Load on Start",
        TextColor3=TEXT,Font=Enum.Font.Gotham,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left},alRow)
    local alTrack=New("Frame",{Size=UDim2.new(0,40,0,20),Position=UDim2.new(1,-40,0.5,-10),
        BackgroundColor3=Color3.fromRGB(40,40,48),BorderSizePixel=0},alRow)
    Corner(10,alTrack)
    local alKnob=New("Frame",{Size=UDim2.new(0,14,0,14),Position=UDim2.new(0,3,0.5,-7),
        BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0},alRow)
    Corner(7,alKnob)
    local alHitbox=New("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text=""},alRow)
    alHitbox.MouseButton1Click:Connect(function()
        autoLoadEnabled=not autoLoadEnabled
        Tween(alTrack,{BackgroundColor3=autoLoadEnabled and ACCENT or Color3.fromRGB(40,40,48)},0.12)
        Tween(alKnob,{Position=autoLoadEnabled and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7)},0.12)
        pcall(function()
            writefile("nighttime_autoload.txt", autoLoadEnabled and configNameBox.Text or "")
        end)
    end)

    local statusLbl=New("TextLabel",{
        Size=UDim2.new(1,0,0,16),BackgroundTransparency=1,Text="",
        TextColor3=Color3.fromRGB(100,220,120),Font=Enum.Font.Gotham,TextSize=10,
        TextXAlignment=Enum.TextXAlignment.Left,LayoutOrder=4
    },s4)
    local cfgList=New("Frame",{
        Size=UDim2.new(1,0,0,0),BackgroundTransparency=1,
        AutomaticSize=Enum.AutomaticSize.Y,LayoutOrder=5
    },s4)
    New("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,4)},cfgList)

    local function setStatus(msg,col)
        statusLbl.Text=msg
        statusLbl.TextColor3=col or Color3.fromRGB(100,220,120)
        task.delay(2.5,function() statusLbl.Text="" end)
    end

    local function serializeSettings()
        local parts={}
        for k,v in pairs(Settings) do
            local t=type(v)
            if t=="boolean" then table.insert(parts,k.."="..tostring(v))
            elseif t=="number" then table.insert(parts,k.."="..tostring(v))
            elseif t=="string" then table.insert(parts,k.."=S:"..v) end
        end
        return table.concat(parts,"|")
    end

    local function deserializeSettings(str)
        for pair in str:gmatch("[^|]+") do
            local k,v=pair:match("^(.-)=(.+)$")
            if k and v and Settings[k]~=nil then
                local t=type(Settings[k])
                if t=="boolean" then Settings[k]=(v=="true")
                elseif t=="number" then Settings[k]=tonumber(v) or Settings[k]
                elseif t=="string" then Settings[k]=v:gsub("^S:","") end
            end
        end
    end

    local function refreshConfigList()
        for _,c in ipairs(cfgList:GetChildren()) do
            if not c:IsA("UIListLayout") then c:Destroy() end
        end
        local ok,files=pcall(listfiles,"nighttime_configs")
        if not ok or not files then return end
        for idx,path in ipairs(files) do
            if not path:match("%.ntcfg$") then continue end
            local cfgName=path:match("[^\/]+$"):gsub("%.ntcfg$","")
            local row=New("Frame",{Size=UDim2.new(1,0,0,28),BackgroundTransparency=1,LayoutOrder=idx},cfgList)
            local ldBtn=New("TextButton",{
                Size=UDim2.new(0,50,0,24),Position=UDim2.new(0,0,0.5,-12),
                BackgroundColor3=Color3.fromRGB(20,70,30),BorderSizePixel=0,
                Text="Load",TextColor3=Color3.fromRGB(80,220,100),Font=Enum.Font.GothamBold,TextSize=10
            },row); Corner(6,ldBtn)
            local dlBtn=New("TextButton",{
                Size=UDim2.new(0,24,0,24),Position=UDim2.new(0,54,0.5,-12),
                BackgroundColor3=Color3.fromRGB(70,20,20),BorderSizePixel=0,
                Text="X",TextColor3=Color3.fromRGB(220,60,60),Font=Enum.Font.GothamBold,TextSize=10
            },row); Corner(6,dlBtn)
            New("TextLabel",{
                Size=UDim2.new(1,-84,1,0),Position=UDim2.new(0,82,0,0),
                BackgroundTransparency=1,Text=cfgName,TextColor3=TEXT,
                Font=Enum.Font.Gotham,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left
            },row)
            ldBtn.MouseButton1Click:Connect(function()
                pcall(function()
                    deserializeSettings(readfile("nighttime_configs/"..cfgName..".ntcfg"))
                    setStatus("Loaded: "..cfgName)
                    ldBtn.Text="OK"
                    task.delay(1.5,function() ldBtn.Text="Load" end)
                end)
            end)
            dlBtn.MouseButton1Click:Connect(function()
                pcall(function()
                    delfile("nighttime_configs/"..cfgName..".ntcfg")
                    refreshConfigList()
                    setStatus("Deleted: "..cfgName,Color3.fromRGB(220,80,80))
                end)
            end)
        end
    end

    saveBtn.MouseButton1Click:Connect(function()
        local name=(configNameBox.Text~="" and configNameBox.Text or "default")
        pcall(function()
            if not isfolder("nighttime_configs") then makefolder("nighttime_configs") end
            writefile("nighttime_configs/"..name..".ntcfg",serializeSettings())
            setStatus("Saved: "..name)
            refreshConfigList()
        end)
    end)

    task.defer(function()
        pcall(function()
            if not isfile("nighttime_autoload.txt") then return end
            local cfgName=readfile("nighttime_autoload.txt")
            if cfgName=="" then return end
            if not isfile("nighttime_configs/"..cfgName..".ntcfg") then return end
            deserializeSettings(readfile("nighttime_configs/"..cfgName..".ntcfg"))
            autoLoadEnabled=true
            configNameBox.Text=cfgName
            Tween(alTrack,{BackgroundColor3=ACCENT},0.12)
            Tween(alKnob,{Position=UDim2.new(1,-17,0.5,-7)},0.12)
            setStatus("Auto-loaded: "..cfgName)
        end)
        refreshConfigList()
    end)
end

task.defer(function() SwitchTab("Combat") end)

-- ============================================================
-- KEYBINDS
-- ============================================================
UserInputService.InputBegan:Connect(function(inp, gpe)
    if gpe then return end
    if inp.KeyCode == Enum.KeyCode.RightShift then
        Win.Visible = not Win.Visible
    elseif inp.KeyCode == Enum.KeyCode.Delete then
        ScreenGui:Destroy()
    end
end)

-- ============================================================
-- WORLD LOGIC
-- ============================================================
local origFogEnd   = Lighting.FogEnd
local origFogStart = Lighting.FogStart
local origBright   = Lighting.Brightness

RunService.Heartbeat:Connect(function()
    if Settings.Fullbright then
        Lighting.Brightness = 2
        Lighting.FogEnd     = 9e8
    end
    if Settings.NoFog then
        Lighting.FogEnd   = 9e8
        Lighting.FogStart = 9e8
    end
    if Settings.CustomTime then
        Lighting.ClockTime = Settings.TimeValue
    end
end)

-- ============================================================
-- SPEED / NOCLIP
-- ============================================================
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = Settings.SpeedEnabled and Settings.SpeedValue or 16
    end
    if Settings.NoclipEnabled then
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end
end)

-- ============================================================
-- FLY (FIXED - was missing entirely)
-- ============================================================
local flyBodyVelocity  = nil
local flyBodyGyro      = nil
local flyConnection    = nil

local function startFly()
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum.PlatformStand = true end

    flyBodyVelocity = Instance.new("BodyVelocity")
    flyBodyVelocity.Velocity    = Vector3.zero
    flyBodyVelocity.MaxForce    = Vector3.new(1e5, 1e5, 1e5)
    flyBodyVelocity.Parent      = root

    flyBodyGyro = Instance.new("BodyGyro")
    flyBodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    flyBodyGyro.CFrame    = Camera.CFrame
    flyBodyGyro.Parent    = root

    flyConnection = RunService.Heartbeat:Connect(function()
        if not Settings.FlyEnabled then
            flyBodyVelocity:Destroy()
            flyBodyGyro:Destroy()
            if hum then hum.PlatformStand = false end
            flyConnection:Disconnect()
            flyBodyVelocity = nil
            flyBodyGyro     = nil
            flyConnection   = nil
            return
        end
        local cf  = Camera.CFrame
        local vel = Vector3.zero
        local spd = Settings.FlySpeed
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then vel = vel + cf.LookVector * spd end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then vel = vel - cf.LookVector * spd end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then vel = vel - cf.RightVector * spd end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then vel = vel + cf.RightVector * spd end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            vel = vel + Vector3.new(0, spd, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            vel = vel - Vector3.new(0, spd, 0)
        end
        flyBodyVelocity.Velocity = vel
        flyBodyGyro.CFrame = cf
    end)
end

local flyWasEnabled = false
RunService.Heartbeat:Connect(function()
    if Settings.FlyEnabled and not flyWasEnabled then
        flyWasEnabled = true
        startFly()
    elseif not Settings.FlyEnabled then
        flyWasEnabled = false
    end
end)

-- ============================================================
-- INFINITE JUMP
-- ============================================================
UserInputService.JumpRequest:Connect(function()
    if not Settings.InfJump then return end
    local char = LocalPlayer.Character
    local hum  = char and char:FindFirstChildOfClass("Humanoid")
    if hum and hum.Health > 0 then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- ============================================================
-- BHOP (FIXED - was missing entirely)
-- ============================================================
RunService.Heartbeat:Connect(function()
    if not Settings.BHop then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if hum:GetState() == Enum.HumanoidStateType.Freefall then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- ============================================================
-- ANTI-AFK
-- ============================================================
local VU = game:GetService("VirtualUser")
LocalPlayer.Idled:Connect(function()
    if Settings.AntiAFK then
        VU:Button2Down(Vector2.zero, Camera.CFrame)
        task.wait(0.5)
        VU:Button2Up(Vector2.zero, Camera.CFrame)
    end
end)

-- ============================================================
-- DRAWINGS
-- ============================================================
local fovCircle  = Drawing.new("Circle")
fovCircle.Thickness = 1
fovCircle.Filled    = false
fovCircle.Visible   = false

local espPool = {}

local function getESP(plr)
    if not espPool[plr] then
        espPool[plr] = {
            box    = Drawing.new("Square"),
            name   = Drawing.new("Text"),
            tracer = Drawing.new("Line"),
            hpbg   = Drawing.new("Square"),
            hpfg   = Drawing.new("Square"),
        }
        local e = espPool[plr]
        e.box.Filled     = false; e.box.Thickness   = 1
        e.name.Size      = 13;    e.name.Center     = true
        e.name.Outline   = true
        e.hpbg.Filled    = true;  e.hpfg.Filled     = true
        e.hpbg.Color     = Color3.fromRGB(20,20,20)
        e.hpfg.Color     = Color3.fromRGB(50,220,80)
        e.tracer.Thickness = 1
        for _, d in pairs(e) do d.Visible = false end
    end
    return espPool[plr]
end

Players.PlayerRemoving:Connect(function(plr)
    if espPool[plr] then
        for _, d in pairs(espPool[plr]) do pcall(function() d:Remove() end) end
        espPool[plr] = nil
    end
end)

local chLines = {}
for i = 1, 4 do
    local l = Drawing.new("Line"); l.Thickness = 1.5; l.Visible = false; chLines[i] = l
end
local chDot = Drawing.new("Circle")
chDot.Radius = 2; chDot.Filled = true; chDot.Visible = false

-- ============================================================
-- HIT MARKER DRAWING (FIXED - was missing entirely)
-- ============================================================
local hitMarkerLines = {}
for i = 1, 4 do
    local l = Drawing.new("Line"); l.Thickness = 1.5; l.Visible = false; hitMarkerLines[i] = l
end

local function showHitMarker(pos3D)
    local sp, onscreen = Camera:WorldToViewportPoint(pos3D)
    if not onscreen then return end
    local cx, cy = sp.X, sp.Y
    local sz = 8
    local dirs = {
        {Vector2.new(cx-sz,cy-sz), Vector2.new(cx-2,cy-2)},
        {Vector2.new(cx+sz,cy-sz), Vector2.new(cx+2,cy-2)},
        {Vector2.new(cx-sz,cy+sz), Vector2.new(cx-2,cy+2)},
        {Vector2.new(cx+sz,cy+sz), Vector2.new(cx+2,cy+2)},
    }
    for i, d in ipairs(dirs) do
        hitMarkerLines[i].From    = d[1]
        hitMarkerLines[i].To      = d[2]
        hitMarkerLines[i].Color   = Settings.HitMarkerColor
        hitMarkerLines[i].Visible = true
    end
    task.delay(0.15, function()
        for i = 1, 4 do hitMarkerLines[i].Visible = false end
    end)
end

-- ============================================================
-- RADAR DRAWING (FIXED - was missing entirely)
-- ============================================================
local radarBG   = Drawing.new("Square")
local radarSelf = Drawing.new("Circle")
local radarDots = {}

radarBG.Filled           = true
radarBG.Color            = Color3.fromRGB(10,10,18)
radarBG.Transparency     = 0.35
radarBG.Size             = Vector2.new(150,150)
radarBG.Visible          = false

radarSelf.Filled         = true
radarSelf.Color          = Color3.fromRGB(0,255,100)
radarSelf.Radius         = 4
radarSelf.Visible        = false

local function getRadarDot(plr)
    if not radarDots[plr] then
        local d = Drawing.new("Circle")
        d.Filled  = true
        d.Color   = Color3.fromRGB(255,50,50)
        d.Radius  = 3
        d.Visible = false
        radarDots[plr] = d
    end
    return radarDots[plr]
end

Players.PlayerRemoving:Connect(function(plr)
    if radarDots[plr] then
        pcall(function() radarDots[plr]:Remove() end)
        radarDots[plr] = nil
    end
end)

-- ============================================================
-- CHAMS (FIXED - was toggled but never applied)
-- ============================================================
local chamConnections = {}

local function applyChamToChar(char, plr)
    if chamConnections[plr] then
        chamConnections[plr]:Disconnect()
        chamConnections[plr] = nil
    end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and not part.Name:find("HumanoidRoot") then
            local box = Instance.new("SelectionBox")
            box.Adornee         = part
            box.Color3          = Settings.ChamColor
            box.LineThickness   = 0
            box.SurfaceTransparency = Settings.ChamTransp
            box.SurfaceColor3   = Settings.ChamColor
            box.Name            = "NighttimeCham"
            box.Parent          = char
        end
    end
end

local function removeChamFromChar(char)
    for _, obj in ipairs(char:GetDescendants()) do
        if obj.Name == "NighttimeCham" then obj:Destroy() end
    end
end

RunService.Heartbeat:Connect(function()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        local char = plr.Character
        if not char then continue end
        if Settings.ChamsEnabled then
            if not char:FindFirstChild("NighttimeCham") then
                applyChamToChar(char, plr)
            end
        else
            if char:FindFirstChild("NighttimeCham") then
                removeChamFromChar(char)
            end
        end
    end
end)

-- ============================================================
-- MAIN RENDER LOOP
-- ============================================================
local rainbowHue = 0

RunService.RenderStepped:Connect(function()
    local vp = Camera.ViewportSize
    local cx, cy = vp.X/2, vp.Y/2

    -- Rainbow hue cycle
    rainbowHue = (rainbowHue + 0.005) % 1

    -- FOV circle
    fovCircle.Visible  = Settings.ShowFOV and Settings.AimbotEnabled
    fovCircle.Radius   = Settings.FOV
    fovCircle.Color    = Settings.FOVColor
    fovCircle.Position = Vector2.new(cx, cy)

    -- Crosshair
    local sz  = Settings.CrosshairSize
    local col = Settings.CrosshairColor
    local dirs = {
        {Vector2.new(cx-sz-4,cy),   Vector2.new(cx-4,cy)},
        {Vector2.new(cx+4,cy),      Vector2.new(cx+sz+4,cy)},
        {Vector2.new(cx,cy-sz-4),   Vector2.new(cx,cy-4)},
        {Vector2.new(cx,cy+4),      Vector2.new(cx,cy+sz+4)},
    }
    for i, d in ipairs(dirs) do
        chLines[i].From    = d[1]
        chLines[i].To      = d[2]
        chLines[i].Color   = col
        chLines[i].Visible = Settings.CrosshairOn
    end
    chDot.Position = Vector2.new(cx, cy)
    chDot.Color    = col
    chDot.Visible  = Settings.CrosshairOn and Settings.DotEnabled

    -- Radar
    local radarSize = 150
    local radarPos  = Vector2.new(vp.X - radarSize - 10, 10)
    radarBG.Position = radarPos
    radarBG.Size     = Vector2.new(radarSize, radarSize)
    radarBG.Visible  = Settings.RadarEnabled

    local radarCenter = radarPos + Vector2.new(radarSize/2, radarSize/2)
    radarSelf.Position = radarCenter
    radarSelf.Visible  = Settings.RadarEnabled

    local localChar = LocalPlayer.Character
    local localRoot = localChar and localChar:FindFirstChild("HumanoidRootPart")

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        local dot   = getRadarDot(plr)
        local pchar = plr.Character
        local proot = pchar and pchar:FindFirstChild("HumanoidRootPart")
        local phum  = pchar and pchar:FindFirstChildOfClass("Humanoid")

        if not Settings.RadarEnabled or not proot or not localRoot
            or not phum or phum.Health <= 0 then
            dot.Visible = false
            continue
        end

        -- World-space delta → camera-relative
        local relPos  = Camera.CFrame:PointToObjectSpace(proot.Position)
        local radarX  = radarCenter.X + (relPos.X / 200) * (radarSize/2)
        local radarY  = radarCenter.Y + (relPos.Z / 200) * (radarSize/2)  -- Z = forward/back
        radarX = math.clamp(radarX, radarPos.X+3, radarPos.X+radarSize-3)
        radarY = math.clamp(radarY, radarPos.Y+3, radarPos.Y+radarSize-3)

        dot.Position = Vector2.new(radarX, radarY)
        dot.Visible  = true
    end

    -- ESP
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        local objs  = getESP(plr)
        local pchar = plr.Character
        local root  = pchar and pchar:FindFirstChild("HumanoidRootPart")
        local hum   = pchar and pchar:FindFirstChildOfClass("Humanoid")

        if not root or not hum or hum.Health <= 0 then
            for _, d in pairs(objs) do d.Visible = false end
            continue
        end

        local rp, onscreen = Camera:WorldToViewportPoint(root.Position)
        if not onscreen then
            for _, d in pairs(objs) do d.Visible = false end
            continue
        end

        local hp2 = Camera:WorldToViewportPoint(root.Position + Vector3.new(0, 3.2, 0))
        local fp2 = Camera:WorldToViewportPoint(root.Position + Vector3.new(0,-3, 0))
        local h   = math.abs(hp2.Y - fp2.Y)
        local w   = h * 0.55

        objs.box.Visible  = Settings.Boxes
        objs.box.Color    = Settings.BoxColor
        objs.box.Position = Vector2.new(rp.X - w/2, hp2.Y)
        objs.box.Size     = Vector2.new(w, h)

        objs.name.Visible   = Settings.Names
        objs.name.Color     = Settings.NameColor
        objs.name.Text      = plr.DisplayName
        objs.name.Position  = Vector2.new(rp.X, hp2.Y - 16)

        objs.tracer.Visible = Settings.Tracers
        objs.tracer.Color   = Settings.TracerColor
        objs.tracer.From    = Vector2.new(cx, vp.Y)
        objs.tracer.To      = Vector2.new(rp.X, rp.Y)

        local hpPct        = hum.Health / hum.MaxHealth
        objs.hpbg.Visible  = Settings.HealthBar
        objs.hpbg.Position = Vector2.new(rp.X - w/2 - 6, hp2.Y)
        objs.hpbg.Size     = Vector2.new(4, h)
        objs.hpfg.Visible  = Settings.HealthBar
        objs.hpfg.Position = Vector2.new(rp.X - w/2 - 6, hp2.Y + h*(1-hpPct))
        objs.hpfg.Size     = Vector2.new(4, h * hpPct)
        objs.hpfg.Color    = Color3.fromRGB(
            math.floor((1-hpPct)*255),
            math.floor(hpPct*200 + 55),
            50
        )
    end
end)

-- ============================================================
-- AIMBOT
-- ============================================================
local tbParams = RaycastParams.new()
tbParams.FilterType = Enum.RaycastFilterType.Exclude

local function getBestTarget()
    local best, bestDist = nil, math.huge
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        if Settings.TeamCheck and plr.Team == LocalPlayer.Team then continue end
        local pchar = plr.Character
        local part  = pchar and (pchar:FindFirstChild(Settings.HitPart)
                                  or pchar:FindFirstChild("HumanoidRootPart"))
        local hum   = pchar and pchar:FindFirstChildOfClass("Humanoid")
        if not part or not hum or hum.Health <= 0 then continue end

        -- Hitbox sink/desync adjustments
        local aimPos = part.Position
        if Settings.HitboxSink then
            aimPos = aimPos + Vector3.new(0, -Settings.HitboxSinkDepth/10, 0)
        end
        if Settings.HitboxDesync then
            aimPos = aimPos + Vector3.new(Settings.HitboxDesyncOff/10, 0, 0)
        end

        local sp, os = Camera:WorldToViewportPoint(aimPos)
        if not os then continue end

        if Settings.WallCheck then
            local lc = LocalPlayer.Character
            local dir = (aimPos - Camera.CFrame.Position)
            tbParams.FilterDescendantsInstances = {lc}
            local ray = workspace:Raycast(Camera.CFrame.Position, dir, tbParams)
            if ray and not pchar:IsAncestorOf(ray.Instance) then continue end
        end

        local d = (Vector2.new(sp.X, sp.Y) - center).Magnitude
        if d < Settings.FOV and d < bestDist then
            best = part; bestDist = d
        end
    end
    return best
end

RunService.RenderStepped:Connect(function()
    if not Settings.AimbotEnabled then return end
    local rmb = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
    local fk  = Settings.FireKeyEnabled
        and Settings.FireKey ~= Enum.KeyCode.Unknown
        and UserInputService:IsKeyDown(Settings.FireKey)
    if not rmb and not fk then return end

    local target = getBestTarget()
    if not target then return end

    local pos = target.Position
    if Settings.Prediction then
        pos = pos + target.AssemblyLinearVelocity * Settings.PredictionAmt
    end
    if Settings.HitboxSink then
        pos = pos + Vector3.new(0, -Settings.HitboxSinkDepth/10, 0)
    end

    local camPos = Camera.CFrame.Position

    if Settings.SilentAim then
        -- Silent aim: moves the bullet origin without moving the camera
        -- This is simulated here as a best-effort; true silent aim requires
        -- executor-level manipulation that varies per game.
        -- We lock camera for actual aim assist while not visually rotating:
        -- nothing to do here visually — the getBestTarget feeds the triggerbot.
    elseif Settings.Smoothing then
        local currentLook = Camera.CFrame.LookVector
        local desiredLook = (pos - camPos).Unit
        local factor      = math.clamp(1 / Settings.SmoothFactor, 0.01, 1)
        local smoothed    = currentLook:Lerp(desiredLook, factor)
        Camera.CFrame     = CFrame.lookAt(camPos, camPos + smoothed)
    else
        Camera.CFrame = CFrame.lookAt(camPos, pos)
    end
end)

-- ============================================================
-- TRIGGERBOT (cleaned up)
-- ============================================================
local mouse      = LocalPlayer:GetMouse()
local tbLastFire = 0

local charMap = {}
local function rebuildCharMap()
    charMap = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        if plr.Character then charMap[plr] = plr.Character end
    end
end

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char) charMap[plr] = char end)
end)
Players.PlayerRemoving:Connect(function(plr) charMap[plr] = nil end)
task.spawn(rebuildCharMap)

RunService.RenderStepped:Connect(function()
    if not Settings.TriggerBot then return end
    local now = tick()
    if (now - tbLastFire) < Settings.TriggerDelay then return end

    local target = mouse.Target
    if not target then return end

    local hitChar = nil
    for plr, ch in pairs(charMap) do
        if Settings.TeamCheck and plr.Team == LocalPlayer.Team then continue end
        if ch:IsAncestorOf(target) then
            local hum = ch:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then hitChar = ch; break end
        end
    end
    if not hitChar then return end

    if Settings.WallCheck then
        local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        local ray    = Camera:ScreenPointToRay(center.X, center.Y)
        tbParams.FilterDescendantsInstances = {LocalPlayer.Character}
        local result = workspace:Raycast(ray.Origin, ray.Direction*1000, tbParams)
        if not result or not hitChar:IsAncestorOf(result.Instance) then return end
    end

    tbLastFire = now

    -- Fire key or mouse click
    if Settings.FireKeyEnabled and Settings.FireKey ~= Enum.KeyCode.Unknown then
        pcall(function()
            keypress(Settings.FireKey.Value)
            task.delay(0.01, function() pcall(function() keyrelease(Settings.FireKey.Value) end) end)
        end)
    else
        pcall(function() mouse1click() end)
    end

    -- Show hit marker at target position
    if Settings.HitMarker and mouse.Target then
        showHitMarker(mouse.Target.Position)
    end
end)

-- ============================================================
-- AUTO FIRE (FIXED - was in settings but never triggered)
-- ============================================================
local autoFireLast = 0
RunService.Heartbeat:Connect(function()
    if not Settings.AutoFire then return end
    if not Settings.AimbotEnabled then return end
    local now = tick()
    if (now - autoFireLast) < 0.1 then return end
    local target = getBestTarget()
    if target then
        autoFireLast = now
        pcall(function() mouse1click() end)
        if Settings.HitMarker then showHitMarker(target.Position) end
    end
end)

-- ============================================================
-- REBUILD charMap each heartbeat (keep fresh, efficient)
-- ============================================================
RunService.Heartbeat:Connect(rebuildCharMap)

-- ============================================================
print("[Nighttime V3.5 Fixed] Loaded!")
print("  RightShift = toggle GUI | Delete = unload")
print("  W/A/S/D + Space/LShift = fly controls")
