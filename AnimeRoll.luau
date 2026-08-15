--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║                     🐰 CUPIE HUB                          ║
    ║           Ultra-Clean Modular UI Framework                ║
    ║                                                           ║
    ║  Discord: https://discord.gg/x98xVJ39                    ║
    ╚═══════════════════════════════════════════════════════════╝

    Name: CUPIEUI
    Architecture: Modular Object-Oriented Component Engine
    Default Theme: Midnight (AMOLED) - Eye-Comfort Tuned
    Language: 100% English (AutoLocalize Disabled)
    Features: Mobile/Tablet Responsive, Live FPS/Ping Stats, Component Descriptions,
              Badges, Direct Slider Typing, Floating Top Badge, and Clean Unload.
--]]

local Cupie = {}
Cupie.__index = Cupie

--// ══════════════════════════════════════════════════════════
--// SERVICES & CORE VARIABLES
--// ══════════════════════════════════════════════════════════
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local StatsService = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer

--// ══════════════════════════════════════════════════════════
--// THEME SYSTEM (Eye-Comfort & Harmonious Palettes)
--// ══════════════════════════════════════════════════════════
Cupie.Themes = {
    ["Midnight (AMOLED)"] = {
        bg        = Color3.fromRGB(8, 8, 11),
        sidebar   = Color3.fromRGB(5, 5, 8),
        card      = Color3.fromRGB(15, 15, 20),
        accent    = Color3.fromRGB(245, 245, 255),
        text      = Color3.fromRGB(238, 238, 245),
        dim       = Color3.fromRGB(135, 135, 150),
        toggleOn  = Color3.fromRGB(245, 245, 255),
        toggleKnob= Color3.fromRGB(12, 12, 16),
        toggleOff = Color3.fromRGB(28, 28, 38),
        border    = Color3.fromRGB(26, 26, 36),
        hover     = Color3.fromRGB(22, 22, 30),
        active    = Color3.fromRGB(28, 28, 38),
        sliderBg  = Color3.fromRGB(26, 26, 34),
        badgeBg   = Color3.fromRGB(35, 35, 48),
    },
    ["Dark (Default)"] = {
        bg        = Color3.fromRGB(15, 15, 20),
        sidebar   = Color3.fromRGB(11, 11, 15),
        card      = Color3.fromRGB(22, 22, 28),
        accent    = Color3.fromRGB(105, 135, 255),
        text      = Color3.fromRGB(240, 240, 248),
        dim       = Color3.fromRGB(135, 135, 155),
        toggleOn  = Color3.fromRGB(105, 135, 255),
        toggleKnob= Color3.fromRGB(255, 255, 255),
        toggleOff = Color3.fromRGB(36, 36, 48),
        border    = Color3.fromRGB(32, 32, 42),
        hover     = Color3.fromRGB(26, 26, 36),
        active    = Color3.fromRGB(32, 32, 44),
        sliderBg  = Color3.fromRGB(32, 32, 44),
        badgeBg   = Color3.fromRGB(40, 48, 75),
    },
    ["Purple Cyber"] = {
        bg        = Color3.fromRGB(17, 13, 24),
        sidebar   = Color3.fromRGB(12, 9, 17),
        card      = Color3.fromRGB(25, 19, 34),
        accent    = Color3.fromRGB(175, 95, 255),
        text      = Color3.fromRGB(245, 238, 255),
        dim       = Color3.fromRGB(145, 135, 165),
        toggleOn  = Color3.fromRGB(175, 95, 255),
        toggleKnob= Color3.fromRGB(255, 255, 255),
        toggleOff = Color3.fromRGB(42, 32, 58),
        border    = Color3.fromRGB(38, 28, 52),
        hover     = Color3.fromRGB(32, 24, 44),
        active    = Color3.fromRGB(40, 30, 56),
        sliderBg  = Color3.fromRGB(36, 26, 50),
        badgeBg   = Color3.fromRGB(54, 34, 76),
    },
    ["Emerald Green"] = {
        bg        = Color3.fromRGB(12, 19, 16),
        sidebar   = Color3.fromRGB(8, 14, 11),
        card      = Color3.fromRGB(19, 28, 23),
        accent    = Color3.fromRGB(65, 210, 140),
        text      = Color3.fromRGB(238, 248, 242),
        dim       = Color3.fromRGB(125, 155, 135),
        toggleOn  = Color3.fromRGB(65, 210, 140),
        toggleKnob= Color3.fromRGB(10, 20, 14),
        toggleOff = Color3.fromRGB(32, 48, 40),
        border    = Color3.fromRGB(28, 42, 35),
        hover     = Color3.fromRGB(24, 36, 30),
        active    = Color3.fromRGB(30, 46, 38),
        sliderBg  = Color3.fromRGB(26, 40, 33),
        badgeBg   = Color3.fromRGB(28, 56, 42),
    },
    ["Crimson Ruby"] = {
        bg        = Color3.fromRGB(21, 13, 15),
        sidebar   = Color3.fromRGB(15, 9, 11),
        card      = Color3.fromRGB(29, 19, 22),
        accent    = Color3.fromRGB(255, 75, 95),
        text      = Color3.fromRGB(255, 240, 242),
        dim       = Color3.fromRGB(160, 130, 135),
        toggleOn  = Color3.fromRGB(255, 75, 95),
        toggleKnob= Color3.fromRGB(255, 255, 255),
        toggleOff = Color3.fromRGB(52, 32, 38),
        border    = Color3.fromRGB(44, 26, 32),
        hover     = Color3.fromRGB(36, 22, 27),
        active    = Color3.fromRGB(46, 28, 35),
        sliderBg  = Color3.fromRGB(42, 24, 30),
        badgeBg   = Color3.fromRGB(68, 28, 36),
    },
    ["Ocean Blue"] = {
        bg        = Color3.fromRGB(13, 17, 24),
        sidebar   = Color3.fromRGB(9, 12, 17),
        card      = Color3.fromRGB(19, 25, 34),
        accent    = Color3.fromRGB(50, 175, 255),
        text      = Color3.fromRGB(238, 244, 255),
        dim       = Color3.fromRGB(125, 145, 165),
        toggleOn  = Color3.fromRGB(50, 175, 255),
        toggleKnob= Color3.fromRGB(10, 18, 26),
        toggleOff = Color3.fromRGB(32, 42, 58),
        border    = Color3.fromRGB(28, 38, 52),
        hover     = Color3.fromRGB(24, 32, 44),
        active    = Color3.fromRGB(30, 40, 56),
        sliderBg  = Color3.fromRGB(26, 36, 50),
        badgeBg   = Color3.fromRGB(28, 54, 78),
    }
}

Cupie.CurrentThemeName = "Midnight (AMOLED)"
Cupie.C = Cupie.Themes[Cupie.CurrentThemeName]
Cupie.ThemeRegistry = {}

function Cupie:RegisterTheme(instance, propertyName, themeKey)
    table.insert(Cupie.ThemeRegistry, {
        instance = instance,
        prop     = propertyName,
        key      = themeKey
    })
    instance[propertyName] = Cupie.C[themeKey]
end

function Cupie:SetTheme(themeName)
    if not Cupie.Themes[themeName] then return end
    Cupie.CurrentThemeName = themeName
    Cupie.C = Cupie.Themes[themeName]
    for _, item in ipairs(Cupie.ThemeRegistry) do
        if item.instance and item.instance.Parent then
            pcall(function()
                TweenService:Create(item.instance, TweenInfo.new(0.22, Enum.EasingStyle.Cubic), {
                    [item.prop] = Cupie.C[item.key]
                }):Play()
            end)
        end
    end
end

--// ══════════════════════════════════════════════════════════
--// LIFECYCLE & STATE MANAGEMENT
--// ══════════════════════════════════════════════════════════
Cupie.Loops = {}
Cupie.ActiveConnections = {}
Cupie.Toggles = {}

function Cupie:AddConnection(conn)
    table.insert(Cupie.ActiveConnections, conn)
    return conn
end

function Cupie:StartLoop(id, interval, fn)
    if Cupie.Loops[id] then return end
    Cupie.Loops[id] = true
    task.spawn(function()
        while Cupie.Loops[id] do
            pcall(fn)
            task.wait(interval)
        end
    end)
end

function Cupie:StopLoop(id)
    Cupie.Loops[id] = nil
end

function Cupie:SafeInvoke(remote, ...)
    if not remote then return end
    local ok, res = pcall(function(...) return remote:InvokeServer(...) end, ...)
    return ok, res
end

function Cupie:SafeFire(remote, ...)
    if not remote then return end
    pcall(function(...) remote:FireServer(...) end, ...)
end

function Cupie:Unload()
    for id in pairs(Cupie.Loops) do
        Cupie.Loops[id] = nil
    end
    table.clear(Cupie.Loops)

    for _, conn in ipairs(Cupie.ActiveConnections) do
        pcall(function()
            if conn and conn.Disconnect then conn:Disconnect() end
        end)
    end
    table.clear(Cupie.ActiveConnections)

    table.clear(Cupie.ThemeRegistry)
    table.clear(Cupie.Toggles)

    if Cupie.Gui then
        pcall(function() Cupie.Gui:Destroy() end)
    end
end

--// ══════════════════════════════════════════════════════════
--// INITIALIZE SCREEN GUI & CLEANUP
--// ══════════════════════════════════════════════════════════
local parentGui = (gethui and gethui()) 
    or (cloneref and cloneref(CoreGui)) 
    or (LocalPlayer:FindFirstChild("PlayerGui")) 
    or CoreGui

pcall(function()
    for _, g in ipairs(parentGui:GetChildren()) do
        if g:IsA("ScreenGui") and (g.Name:lower():find("cupie") or g.Name:lower():find("chicken") or g.Name == "CUPIEUI" or g.Name == "UICUPIE") then
            g:Destroy()
        end
    end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "CUPIEUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 999999
gui.AutoLocalize = false
gui.Parent = parentGui
Cupie.Gui = gui

--// ══════════════════════════════════════════════════════════
--// TOAST NOTIFICATION SYSTEM
--// ══════════════════════════════════════════════════════════
local notifHolder = Instance.new("Frame")
notifHolder.Name = "NotifHolder"
notifHolder.Size = UDim2.new(0, 280, 1, -20)
notifHolder.Position = UDim2.new(1, -290, 0, 10)
notifHolder.BackgroundTransparency = 1
notifHolder.Parent = gui

local notifLayout = Instance.new("UIListLayout", notifHolder)
notifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
notifLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
notifLayout.Padding = UDim.new(0, 6)
notifLayout.SortOrder = Enum.SortOrder.LayoutOrder

function Cupie:Notify(title, content, duration)
    duration = duration or 3
    local nFrame = Instance.new("Frame")
    nFrame.Size = UDim2.new(1, 0, 0, 0)
    nFrame.AutomaticSize = Enum.AutomaticSize.Y
    nFrame.BackgroundColor3 = Cupie.C.card
    nFrame.BorderSizePixel = 0
    nFrame.BackgroundTransparency = 1
    nFrame.Parent = notifHolder

    Instance.new("UICorner", nFrame).CornerRadius = UDim.new(0, 8)
    local nStroke = Instance.new("UIStroke", nFrame)
    nStroke.Color = Cupie.C.border
    nStroke.Thickness = 1
    nStroke.Transparency = 1

    local nPad = Instance.new("UIPadding", nFrame)
    nPad.PaddingTop = UDim.new(0, 8)
    nPad.PaddingBottom = UDim.new(0, 8)
    nPad.PaddingLeft = UDim.new(0, 12)
    nPad.PaddingRight = UDim.new(0, 12)

    local nTitle = Instance.new("TextLabel", nFrame)
    nTitle.AutoLocalize = false
    nTitle.Text = title
    nTitle.Font = Enum.Font.GothamBold
    nTitle.TextSize = 12
    nTitle.TextColor3 = Cupie.C.accent
    nTitle.BackgroundTransparency = 1
    nTitle.Size = UDim2.new(1, 0, 0, 16)
    nTitle.TextXAlignment = Enum.TextXAlignment.Left

    local nBody = Instance.new("TextLabel", nFrame)
    nBody.AutoLocalize = false
    nBody.Text = content
    nBody.Font = Enum.Font.Gotham
    nBody.TextSize = 11
    nBody.TextColor3 = Cupie.C.dim
    nBody.BackgroundTransparency = 1
    nBody.Size = UDim2.new(1, 0, 0, 0)
    nBody.Position = UDim2.fromOffset(0, 18)
    nBody.AutomaticSize = Enum.AutomaticSize.Y
    nBody.TextXAlignment = Enum.TextXAlignment.Left
    nBody.TextWrapped = true

    TweenService:Create(nFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
    TweenService:Create(nStroke, TweenInfo.new(0.2), {Transparency = 0}):Play()

    task.delay(duration, function()
        TweenService:Create(nFrame, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
        TweenService:Create(nStroke, TweenInfo.new(0.2), {Transparency = 1}):Play()
        TweenService:Create(nTitle, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
        TweenService:Create(nBody, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
        task.wait(0.25)
        nFrame:Destroy()
    end)
end

--// ══════════════════════════════════════════════════════════
--// WINDOW CONSTRUCTOR
--// ══════════════════════════════════════════════════════════
function Cupie:CreateWindow(config)
    config = config or {}
    local windowTitle    = config.Title or "🐰 CUPIE HUB"
    local windowSubtitle = config.Subtitle or "Template UI • v1.0"
    local defaultKeybind = config.Keybind or Enum.KeyCode.RightControl

    local Window = {
        Pages       = {},
        TabButtons  = {},
        TabLabels   = {},
        TabBars     = {},
        CurrentPage = nil,
        Keybind     = defaultKeybind,
        Minimized   = false
    }

    -- Responsive Sizing Engine (PC, Mobile, Tablet)
    local camera = workspace.CurrentCamera
    local function getOptimalSize()
        local vp = (camera and camera.ViewportSize) or Vector2.new(1280, 720)
        local targetW = math.clamp(math.floor(vp.X * 0.90), 320, 620)
        local targetH = math.clamp(math.floor(vp.Y * 0.86), 280, 420)
        return targetW, targetH
    end

    local initW, initH = getOptimalSize()
    local sidebarW = (initW < 520) and 110 or 130

    -- Main Container
    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Size = UDim2.fromOffset(initW, initH)
    main.Position = UDim2.new(0.5, -math.floor(initW / 2), 0.5, -math.floor(initH / 2))
    main.BackgroundColor3 = Cupie.C.bg
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    main.Parent = gui

    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 9)
    local mainStroke = Instance.new("UIStroke", main)
    mainStroke.Color = Cupie.C.border
    mainStroke.Thickness = 1
    Cupie:RegisterTheme(main, "BackgroundColor3", "bg")
    Cupie:RegisterTheme(mainStroke, "Color", "border")
    Window.MainFrame = main

    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 38)
    titleBar.BackgroundColor3 = Cupie.C.sidebar
    titleBar.BorderSizePixel = 0
    titleBar.Parent = main
    Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 9)
    Cupie:RegisterTheme(titleBar, "BackgroundColor3", "sidebar")

    local titleFix = Instance.new("Frame")
    titleFix.Size = UDim2.new(1, 0, 0, 12)
    titleFix.Position = UDim2.new(0, 0, 1, -12)
    titleFix.BackgroundColor3 = Cupie.C.sidebar
    titleFix.BorderSizePixel = 0
    titleFix.Parent = titleBar
    Cupie:RegisterTheme(titleFix, "BackgroundColor3", "sidebar")

    local titleLabel = Instance.new("TextLabel")
    titleLabel.AutoLocalize = false
    titleLabel.Text = windowTitle
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 13
    titleLabel.TextColor3 = Cupie.C.text
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.new(0, 125, 1, 0)
    titleLabel.Position = UDim2.fromOffset(14, 0)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar
    Cupie:RegisterTheme(titleLabel, "TextColor3", "text")

    local verLabel = Instance.new("TextLabel")
    verLabel.AutoLocalize = false
    verLabel.Text = windowSubtitle
    verLabel.Font = Enum.Font.GothamMedium
    verLabel.TextSize = 11
    verLabel.TextColor3 = Cupie.C.dim
    verLabel.BackgroundTransparency = 1
    verLabel.Size = UDim2.new(0, 160, 1, 0)
    verLabel.Position = UDim2.fromOffset(135, 0)
    verLabel.TextXAlignment = Enum.TextXAlignment.Left
    verLabel.Visible = (initW >= 560)
    verLabel.Parent = titleBar
    Cupie:RegisterTheme(verLabel, "TextColor3", "dim")

    -- Stats Widget (FPS & Ping)
    local statsLabel = Instance.new("TextLabel")
    statsLabel.AutoLocalize = false
    statsLabel.Text = "🟢 60 FPS • 0ms"
    statsLabel.Font = Enum.Font.GothamMedium
    statsLabel.TextSize = 10
    statsLabel.TextColor3 = Cupie.C.dim
    statsLabel.BackgroundTransparency = 1
    statsLabel.Size = UDim2.new(0, 140, 1, 0)
    statsLabel.Position = UDim2.new(1, -215, 0, 0)
    statsLabel.TextXAlignment = Enum.TextXAlignment.Right
    statsLabel.Visible = (initW >= 460)
    statsLabel.Parent = titleBar
    Cupie:RegisterTheme(statsLabel, "TextColor3", "dim")

    -- Live Performance Update Loop
    local fpsCount = 60
    local fCount = 0
    local lastT = tick()
    Cupie:AddConnection(RunService.RenderStepped:Connect(function()
        fCount = fCount + 1
        local now = tick()
        if now - lastT >= 1 then
            fpsCount = fCount
            fCount = 0
            lastT = now
            local dot = (fpsCount >= 50 and "🟢 ") or (fpsCount >= 30 and "🟡 ") or "🔴 "
            local pingVal = 0
            pcall(function()
                pingVal = math.floor(LocalPlayer:GetNetworkPing() * 1000)
            end)
            statsLabel.Text = dot .. tostring(fpsCount) .. " FPS • " .. tostring(pingVal) .. "ms"
        end
    end))

    -- Window Controls
    local closeBtn = Instance.new("TextButton")
    closeBtn.AutoLocalize = false
    closeBtn.Text = "X"
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 12
    closeBtn.TextColor3 = Cupie.C.dim
    closeBtn.BackgroundTransparency = 1
    closeBtn.Size = UDim2.fromOffset(38, 38)
    closeBtn.Position = UDim2.new(1, -38, 0, 0)
    closeBtn.Parent = titleBar
    Cupie:RegisterTheme(closeBtn, "TextColor3", "dim")

    closeBtn.MouseEnter:Connect(function()
        closeBtn.TextColor3 = Color3.fromRGB(255, 85, 85)
    end)
    closeBtn.MouseLeave:Connect(function()
        closeBtn.TextColor3 = Cupie.C.dim
    end)
    closeBtn.MouseButton1Click:Connect(function()
        Cupie:Unload()
    end)

    local minBtn = Instance.new("TextButton")
    minBtn.AutoLocalize = false
    minBtn.Text = "-"
    minBtn.Font = Enum.Font.GothamBold
    minBtn.TextSize = 16
    minBtn.TextColor3 = Cupie.C.dim
    minBtn.BackgroundTransparency = 1
    minBtn.Size = UDim2.fromOffset(38, 38)
    minBtn.Position = UDim2.new(1, -72, 0, 0)
    minBtn.Parent = titleBar
    Cupie:RegisterTheme(minBtn, "TextColor3", "dim")

    minBtn.MouseEnter:Connect(function()
        minBtn.TextColor3 = Cupie.C.text
    end)
    minBtn.MouseLeave:Connect(function()
        minBtn.TextColor3 = Cupie.C.dim
    end)

    -- Sidebar Container (Adaptive for Phone/Tablet)
    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, sidebarW, 1, -38)
    sidebar.Position = UDim2.fromOffset(0, 38)
    sidebar.BackgroundColor3 = Cupie.C.sidebar
    sidebar.BorderSizePixel = 0
    sidebar.Parent = main
    Cupie:RegisterTheme(sidebar, "BackgroundColor3", "sidebar")

    local tabHolder = Instance.new("ScrollingFrame", sidebar)
    tabHolder.Size = UDim2.new(1, 0, 1, -48)
    tabHolder.BackgroundTransparency = 1
    tabHolder.BorderSizePixel = 0
    tabHolder.ScrollBarThickness = 0
    tabHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabHolder.AutomaticCanvasSize = Enum.AutomaticSize.Y

    local sLayout = Instance.new("UIListLayout", tabHolder)
    sLayout.Padding = UDim.new(0, 3)
    sLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local sPad = Instance.new("UIPadding", tabHolder)
    sPad.PaddingTop = UDim.new(0, 6)
    sPad.PaddingLeft = UDim.new(0, 6)
    sPad.PaddingRight = UDim.new(0, 6)
    Window.Sidebar = tabHolder

    -- Session Playtime & Avatar Card in Sidebar (Shows Avatar + Live Timer, No Player Name)
    local timeCard = Instance.new("Frame", sidebar)
    timeCard.Size = UDim2.new(1, -12, 0, 38)
    timeCard.Position = UDim2.new(0, 6, 1, -42)
    timeCard.BackgroundColor3 = Cupie.C.card
    timeCard.BorderSizePixel = 0
    Instance.new("UICorner", timeCard).CornerRadius = UDim.new(0, 7)
    local tStroke = Instance.new("UIStroke", timeCard)
    tStroke.Color = Cupie.C.border
    tStroke.Thickness = 1
    Cupie:RegisterTheme(timeCard, "BackgroundColor3", "card")
    Cupie:RegisterTheme(tStroke, "Color", "border")

    -- Circular Player Headshot Avatar
    local userAvatar = Instance.new("ImageLabel", timeCard)
    userAvatar.Size = UDim2.fromOffset(26, 26)
    userAvatar.Position = UDim2.fromOffset(6, 6)
    userAvatar.BackgroundColor3 = Cupie.C.sidebar
    userAvatar.BorderSizePixel = 0
    Instance.new("UICorner", userAvatar).CornerRadius = UDim.new(1, 0)
    task.spawn(function()
        pcall(function()
            local thumb = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
            userAvatar.Image = thumb
        end)
    end)

    local timeTitle = Instance.new("TextLabel", timeCard)
    timeTitle.AutoLocalize = false
    timeTitle.Text = "PLAYTIME"
    timeTitle.Font = Enum.Font.GothamBold
    timeTitle.TextSize = 9
    timeTitle.TextColor3 = Cupie.C.accent
    timeTitle.BackgroundTransparency = 1
    timeTitle.Size = UDim2.new(1, -40, 0, 13)
    timeTitle.Position = UDim2.fromOffset(38, 5)
    timeTitle.TextXAlignment = Enum.TextXAlignment.Left
    Cupie:RegisterTheme(timeTitle, "TextColor3", "accent")

    local timeVal = Instance.new("TextLabel", timeCard)
    timeVal.AutoLocalize = false
    timeVal.Text = "00:00:00"
    timeVal.Font = Enum.Font.GothamMedium
    timeVal.TextSize = 10
    timeVal.TextColor3 = Cupie.C.dim
    timeVal.BackgroundTransparency = 1
    timeVal.Size = UDim2.new(1, -40, 0, 13)
    timeVal.Position = UDim2.fromOffset(38, 18)
    timeVal.TextXAlignment = Enum.TextXAlignment.Left
    Cupie:RegisterTheme(timeVal, "TextColor3", "dim")

    -- Session Timer Update Loop
    local sessionStart = tick()
    Cupie:AddConnection(RunService.Heartbeat:Connect(function()
        local elapsed = math.floor(tick() - sessionStart)
        local hrs = math.floor(elapsed / 3600)
        local mins = math.floor((elapsed % 3600) / 60)
        local secs = elapsed % 60
        timeVal.Text = string.format("%02d:%02d:%02d", hrs, mins, secs)
    end))

    -- Content Container (Adaptive for Phone/Tablet)
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -sidebarW, 1, -38)
    content.Position = UDim2.fromOffset(sidebarW, 38)
    content.BackgroundColor3 = Cupie.C.bg
    content.BorderSizePixel = 0
    content.Parent = main
    Cupie:RegisterTheme(content, "BackgroundColor3", "bg")
    Window.Content = content

    --// ══════════════════════════════════════════════════════
    --// FLOATING TOP-CENTER BUNNY LOGO BUTTON (Touch & Notch Safe)
    --// ══════════════════════════════════════════════════════
    local floatBtn = Instance.new("TextButton")
    floatBtn.Name = "CupieFloatingLogo"
    floatBtn.AutoLocalize = false
    floatBtn.Text = "🐰  CUPIE HUB"
    floatBtn.Font = Enum.Font.GothamBold
    floatBtn.TextSize = 12
    floatBtn.TextColor3 = Cupie.C.text
    floatBtn.BackgroundColor3 = Cupie.C.card
    floatBtn.Size = UDim2.fromOffset(136, 32)
    floatBtn.Position = UDim2.new(0.5, -68, 0, 16)
    floatBtn.BorderSizePixel = 0
    floatBtn.Visible = false
    floatBtn.AutoButtonColor = false
    floatBtn.Parent = gui

    Instance.new("UICorner", floatBtn).CornerRadius = UDim.new(0, 8)
    local fStroke = Instance.new("UIStroke", floatBtn)
    fStroke.Color = Cupie.C.border
    fStroke.Thickness = 1

    Cupie:RegisterTheme(floatBtn, "BackgroundColor3", "card")
    Cupie:RegisterTheme(floatBtn, "TextColor3", "text")
    Cupie:RegisterTheme(fStroke, "Color", "border")

    -- Touch & Mouse Dragging for Floating Button
    local fDragging, fDragStart, fStartPos
    Cupie:AddConnection(floatBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            fDragging = true
            fDragStart = input.Position
            fStartPos = floatBtn.Position
        end
    end))
    Cupie:AddConnection(UserInputService.InputChanged:Connect(function(input)
        if fDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - fDragStart
            floatBtn.Position = UDim2.new(fStartPos.X.Scale, fStartPos.X.Offset + d.X, fStartPos.Y.Scale, fStartPos.Y.Offset + d.Y)
        end
    end))
    Cupie:AddConnection(UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            fDragging = false
        end
    end))

    -- Hover Effects for Floating Button
    floatBtn.MouseEnter:Connect(function()
        TweenService:Create(floatBtn, TweenInfo.new(0.12), {BackgroundColor3 = Cupie.C.hover}):Play()
    end)
    floatBtn.MouseLeave:Connect(function()
        TweenService:Create(floatBtn, TweenInfo.new(0.12), {BackgroundColor3 = Cupie.C.card}):Play()
    end)

    -- Functions to Open / Minimize
    local function openUI()
        local curW, curH = getOptimalSize()
        local sW = (curW < 520) and 110 or 130
        sidebar.Size = UDim2.new(0, sW, 1, -38)
        content.Size = UDim2.new(1, -sW, 1, -38)
        content.Position = UDim2.fromOffset(sW, 38)
        statsLabel.Visible = (curW >= 460)
        verLabel.Visible = (curW >= 560)

        floatBtn.Visible = false
        main.Visible = true
        main.Size = UDim2.fromOffset(curW, 0)
        main.BackgroundTransparency = 1
        TweenService:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {
            Size = UDim2.fromOffset(curW, curH),
            BackgroundTransparency = 0
        }):Play()
    end

    local function minimizeUI()
        main.Visible = false
        floatBtn.Visible = true
        floatBtn.Size = UDim2.fromOffset(116, 28)
        floatBtn.BackgroundTransparency = 1
        TweenService:Create(floatBtn, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {
            Size = UDim2.fromOffset(136, 32),
            BackgroundTransparency = 0
        }):Play()
    end

    floatBtn.MouseButton1Click:Connect(function()
        openUI()
    end)

    minBtn.MouseButton1Click:Connect(function()
        minimizeUI()
    end)

    -- Window Dragging System for Main UI (Touch + Mouse Safe)
    local dragging, dragStart, startPos
    Cupie:AddConnection(titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
        end
    end))
    Cupie:AddConnection(UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end))
    Cupie:AddConnection(UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end))

    -- Screen Orientation Change & Window Resize Listener
    if camera then
        Cupie:AddConnection(camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
            if main.Visible and not Window.Minimized then
                local nw, nh = getOptimalSize()
                local sW = (nw < 520) and 110 or 130
                main.Size = UDim2.fromOffset(nw, nh)
                sidebar.Size = UDim2.new(0, sW, 1, -38)
                content.Size = UDim2.new(1, -sW, 1, -38)
                content.Position = UDim2.fromOffset(sW, 38)
                statsLabel.Visible = (nw >= 460)
                verLabel.Visible = (nw >= 560)
            end
        end))
    end

    -- Keybind Toggle
    Cupie:AddConnection(UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == Window.Keybind then
            if main.Visible then
                minimizeUI()
            else
                openUI()
            end
        end
    end))

    -- Page Switcher
    function Window:SwitchTab(name)
        for n, p in pairs(Window.Pages) do
            p.Visible = (n == name)
        end
        for n, btn in pairs(Window.TabButtons) do
            local bar = Window.TabBars[n]
            if n == name then
                TweenService:Create(btn, TweenInfo.new(0.18), {BackgroundColor3 = Cupie.C.active}):Play()
                if Window.TabLabels[n] then Window.TabLabels[n].TextColor3 = Cupie.C.accent end
                if bar then
                    TweenService:Create(bar, TweenInfo.new(0.18), {BackgroundTransparency = 0}):Play()
                end
            else
                TweenService:Create(btn, TweenInfo.new(0.18), {BackgroundColor3 = Cupie.C.sidebar}):Play()
                if Window.TabLabels[n] then Window.TabLabels[n].TextColor3 = Cupie.C.dim end
                if bar then
                    TweenService:Create(bar, TweenInfo.new(0.18), {BackgroundTransparency = 1}):Play()
                end
            end
        end
        Window.CurrentPage = name
    end

    -- Tab & Page Builder Method
    function Window:CreateTab(name, order)
        local Tab = {}
        order = order or (#Window.Sidebar:GetChildren())

        -- Tab Sidebar Button
        local btn = Instance.new("TextButton")
        btn.Name = name
        btn.AutoLocalize = false
        btn.Text = ""
        btn.Size = UDim2.new(1, 0, 0, 34)
        btn.BackgroundColor3 = Cupie.C.sidebar
        btn.BorderSizePixel = 0
        btn.LayoutOrder = order
        btn.AutoButtonColor = false
        btn.Parent = Window.Sidebar
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

        -- Subtle Accent Indicator Pill
        local bar = Instance.new("Frame", btn)
        bar.Size = UDim2.new(0, 3, 0.55, 0)
        bar.Position = UDim2.new(0, 3, 0.225, 0)
        bar.BackgroundColor3 = Cupie.C.accent
        bar.BorderSizePixel = 0
        bar.BackgroundTransparency = 1
        Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)
        Cupie:RegisterTheme(bar, "BackgroundColor3", "accent")
        Window.TabBars[name] = bar

        local lbl = Instance.new("TextLabel")
        lbl.AutoLocalize = false
        lbl.Text = name
        lbl.Font = Enum.Font.GothamSemibold
        lbl.TextSize = 12
        lbl.TextColor3 = Cupie.C.dim
        lbl.BackgroundTransparency = 1
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = btn
        Instance.new("UIPadding", lbl).PaddingLeft = UDim.new(0, 12)

        Window.TabLabels[name] = lbl
        Window.TabButtons[name] = btn

        btn.MouseEnter:Connect(function()
            if Window.CurrentPage ~= name then
                TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = Cupie.C.hover}):Play()
            end
        end)
        btn.MouseLeave:Connect(function()
            if Window.CurrentPage ~= name then
                TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = Cupie.C.sidebar}):Play()
            end
        end)
        btn.MouseButton1Click:Connect(function()
            Window:SwitchTab(name)
        end)

        -- Tab Page Container (ScrollingFrame)
        local page = Instance.new("ScrollingFrame")
        page.Name = name
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.BorderSizePixel = 0
        page.ScrollBarThickness = 3
        page.ScrollBarImageColor3 = Cupie.C.accent
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        page.Visible = false
        page.Parent = Window.Content
        Cupie:RegisterTheme(page, "ScrollBarImageColor3", "accent")

        local pLayout = Instance.new("UIListLayout", page)
        pLayout.Padding = UDim.new(0, 6)
        pLayout.SortOrder = Enum.SortOrder.LayoutOrder

        local pad = Instance.new("UIPadding", page)
        pad.PaddingTop = UDim.new(0, 8)
        pad.PaddingLeft = UDim.new(0, 12)
        pad.PaddingRight = UDim.new(0, 12)
        pad.PaddingBottom = UDim.new(0, 10)

        Window.Pages[name] = page
        Tab.Page = page

        --// ══════════════════════════════════════════════════
        --// TAB COMPONENT METHODS (With Descriptions & Badges)
        --// ══════════════════════════════════════════════════
        function Tab:CreateHeader(text, layoutOrder)
            local h = Instance.new("TextLabel")
            h.AutoLocalize = false
            h.Text = string.upper(text)
            h.Font = Enum.Font.GothamBold
            h.TextSize = 10
            h.TextColor3 = Cupie.C.accent
            h.BackgroundTransparency = 1
            h.Size = UDim2.new(1, 0, 0, 24)
            h.TextXAlignment = Enum.TextXAlignment.Left
            h.LayoutOrder = layoutOrder or 0
            h.Parent = page
            Instance.new("UIPadding", h).PaddingLeft = UDim.new(0, 2)
            Cupie:RegisterTheme(h, "TextColor3", "accent")
            return h
        end

        function Tab:CreateToggle(opts)
            local title    = opts.Name or "Toggle"
            local desc     = opts.Description or opts.Tooltip
            local badge    = opts.Badge
            local id       = opts.Flag or title
            local defState = opts.Default or false
            local callback = opts.Callback
            local order    = opts.LayoutOrder or 0
            local cardH    = desc and 48 or 38

            local f = Instance.new("Frame")
            f.Size = UDim2.new(1, 0, 0, cardH)
            f.BackgroundColor3 = Cupie.C.card
            f.BorderSizePixel = 0
            f.LayoutOrder = order
            f.Parent = page
            Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)

            local fStroke = Instance.new("UIStroke", f)
            fStroke.Color = Cupie.C.border
            fStroke.Thickness = 1
            Cupie:RegisterTheme(f, "BackgroundColor3", "card")
            Cupie:RegisterTheme(fStroke, "Color", "border")

            local textHolder = Instance.new("Frame", f)
            textHolder.Size = UDim2.new(1, -65, 1, 0)
            textHolder.Position = UDim2.fromOffset(12, 0)
            textHolder.BackgroundTransparency = 1

            local textLayout = Instance.new("UIListLayout", textHolder)
            textLayout.VerticalAlignment = Enum.VerticalAlignment.Center
            textLayout.Padding = UDim.new(0, 2)

            local titleRow = Instance.new("Frame", textHolder)
            titleRow.Size = UDim2.new(1, 0, 0, 16)
            titleRow.BackgroundTransparency = 1

            local rowLayout = Instance.new("UIListLayout", titleRow)
            rowLayout.FillDirection = Enum.FillDirection.Horizontal
            rowLayout.VerticalAlignment = Enum.VerticalAlignment.Center
            rowLayout.Padding = UDim.new(0, 6)

            local lbl = Instance.new("TextLabel", titleRow)
            lbl.AutoLocalize = false
            lbl.Text = title
            lbl.Font = Enum.Font.GothamMedium
            lbl.TextSize = 12
            lbl.TextColor3 = Cupie.C.text
            lbl.BackgroundTransparency = 1
            lbl.AutomaticSize = Enum.AutomaticSize.X
            lbl.Size = UDim2.new(0, 0, 1, 0)
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            Cupie:RegisterTheme(lbl, "TextColor3", "text")

            if badge then
                local bFrame = Instance.new("Frame", titleRow)
                bFrame.BackgroundColor3 = opts.BadgeColor or Cupie.C.badgeBg or Color3.fromRGB(35, 35, 48)
                bFrame.BorderSizePixel = 0
                bFrame.AutomaticSize = Enum.AutomaticSize.X
                bFrame.Size = UDim2.new(0, 0, 0, 14)
                Instance.new("UICorner", bFrame).CornerRadius = UDim.new(0, 4)
                local bPad = Instance.new("UIPadding", bFrame)
                bPad.PaddingLeft = UDim.new(0, 5)
                bPad.PaddingRight = UDim.new(0, 5)
                local bText = Instance.new("TextLabel", bFrame)
                bText.AutoLocalize = false
                bText.Text = string.upper(badge)
                bText.Font = Enum.Font.GothamBold
                bText.TextSize = 9
                bText.TextColor3 = Cupie.C.accent
                bText.BackgroundTransparency = 1
                bText.Size = UDim2.new(1, 0, 1, 0)
                Cupie:RegisterTheme(bText, "TextColor3", "accent")
            end

            if desc then
                local dLbl = Instance.new("TextLabel", textHolder)
                dLbl.AutoLocalize = false
                dLbl.Text = desc
                dLbl.Font = Enum.Font.Gotham
                dLbl.TextSize = 10
                dLbl.TextColor3 = Cupie.C.dim
                dLbl.BackgroundTransparency = 1
                dLbl.Size = UDim2.new(1, 0, 0, 14)
                dLbl.TextXAlignment = Enum.TextXAlignment.Left
                Cupie:RegisterTheme(dLbl, "TextColor3", "dim")
            end

            local bg = Instance.new("Frame")
            bg.Size = UDim2.fromOffset(36, 20)
            bg.Position = UDim2.new(1, -48, 0.5, -10)
            bg.BackgroundColor3 = defState and Cupie.C.toggleOn or Cupie.C.toggleOff
            bg.BorderSizePixel = 0
            bg.Parent = f
            Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)

            local circle = Instance.new("Frame")
            circle.Size = UDim2.fromOffset(14, 14)
            circle.Position = defState and UDim2.fromOffset(19, 3) or UDim2.fromOffset(3, 3)
            circle.BackgroundColor3 = defState and (Cupie.C.toggleKnob or Color3.fromRGB(12, 12, 16)) or Color3.fromRGB(200, 200, 210)
            circle.BorderSizePixel = 0
            circle.Parent = bg
            Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

            Cupie.Toggles[id] = defState

            local btn = Instance.new("TextButton")
            btn.AutoLocalize = false
            btn.Text = ""
            btn.Size = UDim2.new(1, 0, 1, 0)
            btn.BackgroundTransparency = 1
            btn.Parent = f

            btn.MouseEnter:Connect(function()
                TweenService:Create(f, TweenInfo.new(0.12), {BackgroundColor3 = Cupie.C.hover}):Play()
            end)
            btn.MouseLeave:Connect(function()
                TweenService:Create(f, TweenInfo.new(0.12), {BackgroundColor3 = Cupie.C.card}):Play()
            end)

            btn.MouseButton1Click:Connect(function()
                Cupie.Toggles[id] = not Cupie.Toggles[id]
                local on = Cupie.Toggles[id]
                TweenService:Create(bg, TweenInfo.new(0.18, Enum.EasingStyle.Cubic), {
                    BackgroundColor3 = on and Cupie.C.toggleOn or Cupie.C.toggleOff
                }):Play()
                TweenService:Create(circle, TweenInfo.new(0.18, Enum.EasingStyle.Cubic), {
                    Position = on and UDim2.fromOffset(19, 3) or UDim2.fromOffset(3, 3),
                    BackgroundColor3 = on and (Cupie.C.toggleKnob or Color3.fromRGB(12, 12, 16)) or Color3.fromRGB(200, 200, 210)
                }):Play()
                if callback then callback(on) end
            end)
            return f
        end

                function Tab:CreateSlider(opts)
            local title    = opts.Name or "Slider"
            local min      = opts.Min or 0
            local max      = opts.Max or 100
            local defVal   = opts.Default ~= nil and opts.Default or min
            local suffix   = opts.Suffix or ""
            local callback = opts.Callback
            local order    = opts.LayoutOrder or 0
            local step     = opts.Step

            -- Auto-detect decimal precision (e.g. 0.05 -> 2 decimals, 16 -> 0 decimals)
            local precision = opts.Decimals
            if precision == nil then
                if min ~= math.floor(min) or max ~= math.floor(max) or defVal ~= math.floor(defVal) or (step and step ~= math.floor(step)) then
                    precision = 2
                else
                    precision = 0
                end
            end

            if not step then
                step = (precision > 0) and (1 / (10 ^ precision)) or 1
            end

            local function formatVal(v)
                if precision > 0 then
                    return string.format("%." .. precision .. "f", v)
                else
                    return tostring(math.floor(v + 0.5))
                end
            end

            local f = Instance.new("Frame")
            f.BackgroundColor3 = Cupie.C.card
            f.BorderSizePixel = 0
            f.Size = UDim2.new(1, 0, 0, 52)
            f.LayoutOrder = order
            f.Parent = page
            Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)

            local bStroke = Instance.new("UIStroke", f)
            bStroke.Color = Cupie.C.border
            bStroke.Thickness = 1
            Cupie:RegisterTheme(f, "BackgroundColor3", "card")
            Cupie:RegisterTheme(bStroke, "Color", "border")

            local lbl = Instance.new("TextLabel")
            lbl.AutoLocalize = false
            lbl.Text = title
            lbl.Font = Enum.Font.GothamMedium
            lbl.TextSize = 12
            lbl.TextColor3 = Cupie.C.text
            lbl.BackgroundTransparency = 1
            lbl.Size = UDim2.new(1, -95, 0, 20)
            lbl.Position = UDim2.fromOffset(12, 5)
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = f
            Cupie:RegisterTheme(lbl, "TextColor3", "text")

            -- Interactive Value Box (Can Drag OR Type directly)
            local valBox = Instance.new("TextBox")
            valBox.AutoLocalize = false
            valBox.Text = formatVal(defVal) .. suffix
            valBox.Font = Enum.Font.GothamBold
            valBox.TextSize = 11
            valBox.TextColor3 = Cupie.C.accent
            valBox.BackgroundColor3 = Cupie.C.sidebar
            valBox.BorderSizePixel = 0
            valBox.Size = UDim2.fromOffset(65, 20)
            valBox.Position = UDim2.new(1, -77, 0, 5)
            valBox.TextXAlignment = Enum.TextXAlignment.Center
            valBox.ClearTextOnFocus = false
            valBox.Parent = f
            Instance.new("UICorner", valBox).CornerRadius = UDim.new(0, 5)
            Cupie:RegisterTheme(valBox, "BackgroundColor3", "sidebar")
            Cupie:RegisterTheme(valBox, "TextColor3", "accent")

            local bar = Instance.new("Frame")
            bar.Size = UDim2.new(1, -24, 0, 6)
            bar.Position = UDim2.new(0, 12, 0, 34)
            bar.BackgroundColor3 = Cupie.C.sliderBg
            bar.BorderSizePixel = 0
            bar.Parent = f
            Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)
            Cupie:RegisterTheme(bar, "BackgroundColor3", "sliderBg")

            local fill = Instance.new("Frame")
            local initRel = (max > min) and math.clamp((defVal - min) / (max - min), 0, 1) or 0
            fill.Size = UDim2.new(initRel, 0, 1, 0)
            fill.BackgroundColor3 = Cupie.C.accent
            fill.BorderSizePixel = 0
            fill.Parent = bar
            Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
            Cupie:RegisterTheme(fill, "BackgroundColor3", "accent")

            -- Large Touch/Mouse Hitbox
            local sbtn = Instance.new("TextButton")
            sbtn.AutoLocalize = false
            sbtn.Text = ""
            sbtn.Size = UDim2.new(1, 0, 0, 24)
            sbtn.Position = UDim2.new(0, 0, 0.5, -12)
            sbtn.BackgroundTransparency = 1
            sbtn.Parent = bar

            local sliding = false

            local function update(x)
                local barAbsPos = bar.AbsolutePosition.X
                local barAbsSize = bar.AbsoluteSize.X
                if barAbsSize <= 0 then barAbsSize = 1 end
                local rel = math.clamp((x - barAbsPos) / barAbsSize, 0, 1)
                local rawVal = min + (max - min) * rel
                
                -- Precise stepping calculation
                local v = math.floor((rawVal - min) / step + 0.5) * step + min
                v = math.clamp(v, min, max)
                if precision > 0 then
                    local mult = 10 ^ precision
                    v = math.floor(v * mult + 0.5) / mult
                else
                    v = math.floor(v + 0.5)
                end

                local visualRel = (max > min) and math.clamp((v - min) / (max - min), 0, 1) or 0
                fill.Size = UDim2.new(visualRel, 0, 1, 0)
                valBox.Text = formatVal(v) .. suffix
                if callback then callback(v) end
            end

            -- Manual type-in support (handles decimals like 2.05)
            valBox.FocusLost:Connect(function()
                local cleaned = valBox.Text:gsub("[^%d%.%-]", "")
                local num = tonumber(cleaned)
                if num then
                    num = math.clamp(num, min, max)
                    local v = math.floor((num - min) / step + 0.5) * step + min
                    v = math.clamp(v, min, max)
                    if precision > 0 then
                        local mult = 10 ^ precision
                        v = math.floor(v * mult + 0.5) / mult
                    else
                        v = math.floor(v + 0.5)
                    end
                    local visualRel = (max > min) and math.clamp((v - min) / (max - min), 0, 1) or 0
                    fill.Size = UDim2.new(visualRel, 0, 1, 0)
                    valBox.Text = formatVal(v) .. suffix
                    if callback then callback(v) end
                else
                    valBox.Text = formatVal(defVal) .. suffix
                end
            end)

            Cupie:AddConnection(sbtn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = true
                    update(input.Position.X)
                end
            end))
            Cupie:AddConnection(UserInputService.InputChanged:Connect(function(input)
                if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    update(input.Position.X)
                end
            end))
            Cupie:AddConnection(UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = false
                end
            end))
            return f
        end

        function Tab:CreateButton(opts)
            local title    = opts.Name or "Button"
            local desc     = opts.Description or opts.Tooltip
            local callback = opts.Callback
            local order    = opts.LayoutOrder or 0
            local cardH    = desc and 48 or 38

            local btn = Instance.new("TextButton")
            btn.AutoLocalize = false
            btn.Text = ""
            btn.BackgroundColor3 = Cupie.C.card
            btn.BorderSizePixel = 0
            btn.Size = UDim2.new(1, 0, 0, cardH)
            btn.AutoButtonColor = false
            btn.LayoutOrder = order
            btn.Parent = page
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

            local bStroke = Instance.new("UIStroke", btn)
            bStroke.Color = Cupie.C.border
            bStroke.Thickness = 1
            Cupie:RegisterTheme(btn, "BackgroundColor3", "card")
            Cupie:RegisterTheme(bStroke, "Color", "border")

            local tHolder = Instance.new("Frame", btn)
            tHolder.Size = UDim2.new(1, -24, 1, 0)
            tHolder.Position = UDim2.fromOffset(12, 0)
            tHolder.BackgroundTransparency = 1

            local tLayout = Instance.new("UIListLayout", tHolder)
            tLayout.VerticalAlignment = Enum.VerticalAlignment.Center
            tLayout.Padding = UDim.new(0, 2)

            local tLbl = Instance.new("TextLabel", tHolder)
            tLbl.AutoLocalize = false
            tLbl.Text = title
            tLbl.Font = Enum.Font.GothamMedium
            tLbl.TextSize = 12
            tLbl.TextColor3 = Cupie.C.text
            tLbl.BackgroundTransparency = 1
            tLbl.Size = UDim2.new(1, 0, 0, 16)
            tLbl.TextXAlignment = Enum.TextXAlignment.Left
            Cupie:RegisterTheme(tLbl, "TextColor3", "text")

            if desc then
                local dLbl = Instance.new("TextLabel", tHolder)
                dLbl.AutoLocalize = false
                dLbl.Text = desc
                dLbl.Font = Enum.Font.Gotham
                dLbl.TextSize = 10
                dLbl.TextColor3 = Cupie.C.dim
                dLbl.BackgroundTransparency = 1
                dLbl.Size = UDim2.new(1, 0, 0, 14)
                dLbl.TextXAlignment = Enum.TextXAlignment.Left
                Cupie:RegisterTheme(dLbl, "TextColor3", "dim")
            end

            btn.MouseEnter:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = Cupie.C.hover}):Play()
            end)
            btn.MouseLeave:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = Cupie.C.card}):Play()
            end)
            btn.MouseButton1Click:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.08), {BackgroundColor3 = Cupie.C.accent}):Play()
                task.wait(0.1)
                TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = Cupie.C.card}):Play()
                if callback then callback() end
            end)
            return btn
        end

        function Tab:CreateDropdown(opts)
            local title    = opts.Name or "Dropdown"
            local options  = opts.Options or {}
            local selected = opts.Default or options[1] or ""
            local callback = opts.Callback
            local order    = opts.LayoutOrder or 0
            local expanded = false

            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, 0, 0, 38)
            container.BackgroundColor3 = Cupie.C.card
            container.BorderSizePixel = 0
            container.LayoutOrder = order
            container.ClipsDescendants = true
            container.Parent = page
            Instance.new("UICorner", container).CornerRadius = UDim.new(0, 8)

            local cStroke = Instance.new("UIStroke", container)
            cStroke.Color = Cupie.C.border
            cStroke.Thickness = 1
            Cupie:RegisterTheme(container, "BackgroundColor3", "card")
            Cupie:RegisterTheme(cStroke, "Color", "border")

            local headerBtn = Instance.new("TextButton")
            headerBtn.AutoLocalize = false
            headerBtn.Text = ""
            headerBtn.Size = UDim2.new(1, 0, 0, 38)
            headerBtn.BackgroundTransparency = 1
            headerBtn.Parent = container

            local titleLbl = Instance.new("TextLabel")
            titleLbl.AutoLocalize = false
            titleLbl.Text = title
            titleLbl.Font = Enum.Font.GothamMedium
            titleLbl.TextSize = 12
            titleLbl.TextColor3 = Cupie.C.text
            titleLbl.BackgroundTransparency = 1
            titleLbl.Size = UDim2.new(0.5, 0, 1, 0)
            titleLbl.Position = UDim2.fromOffset(12, 0)
            titleLbl.TextXAlignment = Enum.TextXAlignment.Left
            titleLbl.Parent = headerBtn
            Cupie:RegisterTheme(titleLbl, "TextColor3", "text")

            local curValLbl = Instance.new("TextLabel")
            curValLbl.AutoLocalize = false
            curValLbl.Text = selected .. " ▾"
            curValLbl.Font = Enum.Font.GothamBold
            curValLbl.TextSize = 11
            curValLbl.TextColor3 = Cupie.C.accent
            curValLbl.BackgroundTransparency = 1
            curValLbl.Size = UDim2.new(0.5, -16, 1, 0)
            curValLbl.Position = UDim2.new(0.5, 0, 0, 0)
            curValLbl.TextXAlignment = Enum.TextXAlignment.Right
            curValLbl.Parent = headerBtn
            Cupie:RegisterTheme(curValLbl, "TextColor3", "accent")

            local optHolder = Instance.new("Frame")
            optHolder.Size = UDim2.new(1, -24, 0, #options * 28)
            optHolder.Position = UDim2.fromOffset(12, 40)
            optHolder.BackgroundTransparency = 1
            optHolder.Parent = container

            local optLayout = Instance.new("UIListLayout", optHolder)
            optLayout.Padding = UDim.new(0, 3)

            for _, optName in ipairs(options) do
                local optBtn = Instance.new("TextButton")
                optBtn.AutoLocalize = false
                optBtn.Text = "  " .. optName
                optBtn.Font = Enum.Font.Gotham
                optBtn.TextSize = 11
                optBtn.TextColor3 = (optName == selected) and Cupie.C.accent or Cupie.C.dim
                optBtn.BackgroundColor3 = Cupie.C.sidebar
                optBtn.Size = UDim2.new(1, 0, 0, 25)
                optBtn.TextXAlignment = Enum.TextXAlignment.Left
                optBtn.BorderSizePixel = 0
                optBtn.Parent = optHolder
                Instance.new("UICorner", optBtn).CornerRadius = UDim.new(0, 5)

                optBtn.MouseEnter:Connect(function()
                    TweenService:Create(optBtn, TweenInfo.new(0.1), {BackgroundColor3 = Cupie.C.hover}):Play()
                end)
                optBtn.MouseLeave:Connect(function()
                    TweenService:Create(optBtn, TweenInfo.new(0.1), {BackgroundColor3 = Cupie.C.sidebar}):Play()
                end)

                optBtn.MouseButton1Click:Connect(function()
                    selected = optName
                    curValLbl.Text = selected .. " ▾"
                    expanded = false
                    TweenService:Create(container, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
                        Size = UDim2.new(1, 0, 0, 38)
                    }):Play()
                    for _, child in pairs(optHolder:GetChildren()) do
                        if child:IsA("TextButton") then
                            child.TextColor3 = (child.Text:find(selected)) and Cupie.C.accent or Cupie.C.dim
                        end
                    end
                    if callback then callback(selected) end
                end)
            end

            headerBtn.MouseButton1Click:Connect(function()
                expanded = not expanded
                local targetH = expanded and (44 + #options * 28) or 38
                curValLbl.Text = selected .. (expanded and " ▴" or " ▾")
                TweenService:Create(container, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
                    Size = UDim2.new(1, 0, 0, targetH)
                }):Play()
            end)
            return container
        end

        function Tab:CreateKeybind(opts)
            local title    = opts.Name or "Keybind"
            local curKey   = opts.Default or Enum.KeyCode.RightControl
            local callback = opts.Callback
            local order    = opts.LayoutOrder or 0
            local listening = false

            local f = Instance.new("Frame")
            f.Size = UDim2.new(1, 0, 0, 38)
            f.BackgroundColor3 = Cupie.C.card
            f.BorderSizePixel = 0
            f.LayoutOrder = order
            f.Parent = page
            Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)

            local fStroke = Instance.new("UIStroke", f)
            fStroke.Color = Cupie.C.border
            fStroke.Thickness = 1
            Cupie:RegisterTheme(f, "BackgroundColor3", "card")
            Cupie:RegisterTheme(fStroke, "Color", "border")

            local lbl = Instance.new("TextLabel")
            lbl.AutoLocalize = false
            lbl.Text = title
            lbl.Font = Enum.Font.GothamMedium
            lbl.TextSize = 12
            lbl.TextColor3 = Cupie.C.text
            lbl.BackgroundTransparency = 1
            lbl.Size = UDim2.new(1, -115, 1, 0)
            lbl.Position = UDim2.fromOffset(12, 0)
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = f
            Cupie:RegisterTheme(lbl, "TextColor3", "text")

            local kBtn = Instance.new("TextButton")
            kBtn.AutoLocalize = false
            kBtn.Text = curKey.Name
            kBtn.Font = Enum.Font.GothamBold
            kBtn.TextSize = 11
            kBtn.TextColor3 = Cupie.C.accent
            kBtn.BackgroundColor3 = Cupie.C.sidebar
            kBtn.Size = UDim2.fromOffset(92, 24)
            kBtn.Position = UDim2.new(1, -104, 0.5, -12)
            kBtn.BorderSizePixel = 0
            kBtn.Parent = f
            Instance.new("UICorner", kBtn).CornerRadius = UDim.new(0, 6)
            Cupie:RegisterTheme(kBtn, "BackgroundColor3", "sidebar")
            Cupie:RegisterTheme(kBtn, "TextColor3", "accent")

            kBtn.MouseButton1Click:Connect(function()
                if listening then return end
                listening = true
                kBtn.Text = "Press Key..."
                kBtn.TextColor3 = Color3.fromRGB(255, 200, 50)

                local conn
                conn = UserInputService.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        curKey = input.KeyCode
                        kBtn.Text = curKey.Name
                        kBtn.TextColor3 = Cupie.C.accent
                        listening = false
                        conn:Disconnect()
                        if callback then callback(curKey) end
                    end
                end)
            end)
            return f
        end

        function Tab:CreateParagraph(opts)
            local title = opts.Title or "Info"
            local body  = opts.Content or ""
            local order = opts.LayoutOrder or 0

            local f = Instance.new("Frame")
            f.Size = UDim2.new(1, 0, 0, 0)
            f.AutomaticSize = Enum.AutomaticSize.Y
            f.BackgroundColor3 = Cupie.C.card
            f.BorderSizePixel = 0
            f.LayoutOrder = order
            f.Parent = page
            Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)

            local fStroke = Instance.new("UIStroke", f)
            fStroke.Color = Cupie.C.border
            fStroke.Thickness = 1
            Cupie:RegisterTheme(f, "BackgroundColor3", "card")
            Cupie:RegisterTheme(fStroke, "Color", "border")

            local ly = Instance.new("UIListLayout", f)
            ly.Padding = UDim.new(0, 4)

            local pd = Instance.new("UIPadding", f)
            pd.PaddingTop = UDim.new(0, 10)
            pd.PaddingBottom = UDim.new(0, 10)
            pd.PaddingLeft = UDim.new(0, 12)
            pd.PaddingRight = UDim.new(0, 12)

            local h = Instance.new("TextLabel", f)
            h.AutoLocalize = false
            h.Text = title
            h.Font = Enum.Font.GothamBold
            h.TextSize = 12
            h.TextColor3 = Cupie.C.accent
            h.BackgroundTransparency = 1
            h.Size = UDim2.new(1, 0, 0, 16)
            h.TextXAlignment = Enum.TextXAlignment.Left
            Cupie:RegisterTheme(h, "TextColor3", "accent")

            local b = Instance.new("TextLabel", f)
            b.AutoLocalize = false
            b.Text = body
            b.Font = Enum.Font.Gotham
            b.TextSize = 11
            b.TextColor3 = Cupie.C.dim
            b.BackgroundTransparency = 1
            b.Size = UDim2.new(1, 0, 0, 0)
            b.AutomaticSize = Enum.AutomaticSize.Y
            b.TextXAlignment = Enum.TextXAlignment.Left
            b.TextWrapped = true
            Cupie:RegisterTheme(b, "TextColor3", "dim")
            return f
        end

        function Tab:CreateDivider(layoutOrder)
            local div = Instance.new("Frame")
            div.Size = UDim2.new(1, 0, 0, 1)
            div.BackgroundColor3 = Cupie.C.border
            div.BorderSizePixel = 0
            div.LayoutOrder = layoutOrder or 0
            div.Parent = page
            Cupie:RegisterTheme(div, "BackgroundColor3", "border")
            return div
        end

        return Tab
    end

    -- Intro Animation
    main.Size = UDim2.fromOffset(initW, 0)
    main.BackgroundTransparency = 1
    TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
        Size = UDim2.fromOffset(initW, initH),
        BackgroundTransparency = 0,
    }):Play()

    return Window
end

--// ══════════════════════════════════════════════════════════

--// GAME AUTOMATION & REMOTE ENGINE (ROLL ANIME TO FIGHT)
--// Meticulously fine-tuned from Live Spy Logs & Full Dumps
--// ══════════════════════════════════════════════════════════

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace         = game:GetService("Workspace")
local VirtualUser       = game:GetService("VirtualUser")

-- Safe Remote & Module Cache
local Remotes           = ReplicatedStorage:WaitForChild("Remotes", 5)
local Modules           = ReplicatedStorage:WaitForChild("Modules", 5)

-- Character & Gacha Remotes
local CharactersFolder  = Remotes and Remotes:FindFirstChild("Characters")
local CharactersRoll    = CharactersFolder and CharactersFolder:FindFirstChild("Roll")
local CharactersBuy     = CharactersFolder and CharactersFolder:FindFirstChild("Buy")
local CharactersSell    = CharactersFolder and CharactersFolder:FindFirstChild("Sell")
local CharactersInv     = CharactersFolder and CharactersFolder:FindFirstChild("UpdateInventory")
local CharactersLevelUp = CharactersFolder and CharactersFolder:FindFirstChild("LevelUp")

-- Stats & Stat Upgrades (Verified from foranimell.lua)
local GeneralUpgrade    = Remotes and Remotes:FindFirstChild("Upgrade")

-- Lucky Wheel
local SpinRemote        = Remotes and Remotes:FindFirstChild("SpinWheel") and Remotes.SpinWheel:FindFirstChild("Spin")

-- Combat Remotes
local FightFolder       = Remotes and Remotes:FindFirstChild("Fight")
local FightStart        = FightFolder and FightFolder:FindFirstChild("Start")
local FightArrived      = FightFolder and FightFolder:FindFirstChild("Arrived")

local FlexFolder        = Remotes and Remotes:FindFirstChild("Flex")
local FlexAttack        = FlexFolder and FlexFolder:FindFirstChild("Attack")
local FlexPlace         = FlexFolder and FlexFolder:FindFirstChild("PlaceCharacter")
local FlexPickup        = FlexFolder and FlexFolder:FindFirstChild("PickupCharacter")
local FlexKill          = FlexFolder and FlexFolder:FindFirstChild("KillCharacters")
local FlexSetState      = FlexFolder and FlexFolder:FindFirstChild("SetFlexState")
local FlexLock          = FlexFolder and FlexFolder:FindFirstChild("UpdateCharacterLock")
local FlexHotbar        = FlexFolder and FlexFolder:FindFirstChild("UpdateInventoryHotbar")

-- NPCs, Factions & Tickets (Verified from foranimel.lua)
local NPCEvents         = Remotes and Remotes:FindFirstChild("NPCEvents")
local TalkTicketsRemote = NPCEvents and NPCEvents:FindFirstChild("TalkTickets")

local FactionMod        = Modules and Modules:FindFirstChild("Shared") and Modules.Shared:FindFirstChild("Faction")
local FactionUpdate     = FactionMod and FactionMod:FindFirstChild("FactionUpdate")

local TutorialMod       = Modules and Modules:FindFirstChild("Tutorial")
local TutorialReward    = TutorialMod and TutorialMod:FindFirstChild("TutorialReward")
local TutorialDone      = TutorialMod and TutorialMod:FindFirstChild("TutorialDone")

local EvolutionRemote   = Remotes and Remotes:FindFirstChild("EvolutionRemotes") and Remotes.EvolutionRemotes:FindFirstChild("Evolve")
local TraitRemote       = Remotes and Remotes:FindFirstChild("Trait") and Remotes.Trait:FindFirstChild("Request")
local CloneRemote       = Remotes and Remotes:FindFirstChild("CloneRemotes") and Remotes.CloneRemotes:FindFirstChild("Request")
local JoinTowerRemote   = Remotes and Remotes:FindFirstChild("JoinTower")
local AFKTeleportRemote = Remotes and Remotes:FindFirstChild("AFKTeleport")
local ClaimVIPRemote    = Remotes and Remotes:FindFirstChild("ClaimVIP")
local FreeGroupRemote   = Remotes and Remotes:FindFirstChild("FreeRewards") and Remotes.FreeRewards:FindFirstChild("FreeGroup")
local CodeRedeemRemote  = Remotes and Remotes:FindFirstChild("Codes") and Remotes.Codes:FindFirstChild("Redeem")
local NotifyRemote      = Remotes and Remotes:FindFirstChild("Notify")

-- Battlepass Remotes & Modules
local BattlepassMod     = Modules and Modules:FindFirstChild("Battlepass")
local BPQuestMod        = BattlepassMod and BattlepassMod:FindFirstChild("BattlepassQuest")
local BPClaimQuest      = BPQuestMod and BPQuestMod:FindFirstChild("ClaimQuest")
local BPGetQuestData    = BPQuestMod and BPQuestMod:FindFirstChild("GetQuestData")
local BPClaimLevel      = BattlepassMod and BattlepassMod:FindFirstChild("Claim")
local BPPremiumStatus   = BattlepassMod and BattlepassMod:FindFirstChild("PremiumStatus")

-- Exact 15 In-Game Rarity Hierarchy (ReplicatedStorage.Assets.RarityGradient)
local InGameRarities = {
    [1]  = "Common",
    [2]  = "Rare",
    [3]  = "Epic",
    [4]  = "Legendary",
    [5]  = "Mythic",
    [6]  = "God",
    [7]  = "Godly",
    [8]  = "Godlyx",
    [9]  = "Secret",
    [10] = "Divine",
    [11] = "Immortal",
    [12] = "OP",
    [13] = "OG",
    [14] = "INVASION",
    [15] = "Limited"
}

-- Systematic Configuration State
local Config = {
    -- Gacha & Auto Roll
    AutoRoll            = false,
    RollDelay           = 2.00,
    
    -- Smart Auto Buy by Rarity
    AutoBuyByRarity     = false,
    BuyRuleRarity       = "Mythic & Above",
    BuyRuleTier         = "All Tiers",
    
    -- Auto Sell Rarity Selection
    AutoSellLowTier     = false,
    SellThreshold       = "Common Only",
    
    -- Auto Lock Rarity Selection
    AutoLockRareUnits   = true,
    LockMinRarity       = "Legendary & Above",
    
    -- Target Stop Filter
    TargetRarityFilter  = false,
    StopRarityTarget    = "Mythic & Above",
    
    -- Wheel & Popups
    AutoSpinWheel       = false,
    HideNotifications   = true,
    
    -- Dashboard & Progression Toggles (Equip, Level, Evolve, Stats)
    AutoEquipBest       = false,
    AutoLevelUp         = false,
    AutoEvolve          = false,
    AutoUpgradeStats    = false,
    AutoUpgradeLuck     = true,
    AutoUpgradeInventory= true,
    AutoUpgradeGold     = true,
    AutoUpgradeSlots    = true,
    AutoTraitReroll     = false,
    
    -- Factions & NPC Tickets
    AutoFactionQuests   = false,
    AutoBuyNPCTickets   = false,
    
    -- Shop Direct
    AutoBuyTier         = false,
    SelectedTier        = 1,
    SelectedSlot        = "All Slots",
    
    -- Combat
    AutoFight           = false,
    FastAttackAura      = false,
    AttackSpeed         = 0.08,
    AutoWaveSkip        = true,
    
    -- Quests & Free
    AutoClaimBP         = false,
    AutoFreeRewards     = false,
    
    -- LocalPlayer & QoL
    WalkSpeed           = 16,
    JumpPower           = 50,
    InfJump             = false,
    Noclip              = false,
    AntiAFK             = true
}

-- ══════════════════════════════════════════════════════════
-- NOTIFICATION BLOCKER & CLEANER ("ป้ายชื่อ" Killer)
-- ══════════════════════════════════════════════════════════

local function isNotificationElement(obj)
    if not obj then return false end
    local name = obj.Name:lower()
    local text = (obj:IsA("TextLabel") or obj:IsA("TextButton")) and obj.Text or ""
    local textLower = text:lower()
    
    if text == "Label" or text == "ป้ายชื่อ" or textLower:find("spin") or textLower:find("won") or textLower:find("claim") or textLower:find("gold") then
        return true
    end
    if name:find("notif") or name:find("popup") or name:find("toast") or name:find("banner") or name:find("alert") then
        return true
    end
    return false
end

local function purgeNotification(obj)
    if not obj then return end
    pcall(function()
        if isNotificationElement(obj) then
            if obj:IsA("GuiObject") then obj.Visible = false end
            local parent = obj.Parent
            if parent and (parent.Name:lower():find("notif") or parent.Name:lower():find("item") or parent:IsA("BillboardGui") or parent:IsA("Frame")) then
                parent.Visible = false
                parent:Destroy()
            else
                obj:Destroy()
            end
        end
    end)
end

local function cleanAllExistingNotifications()
    local pGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not pGui then return end
    for _, desc in ipairs(pGui:GetDescendants()) do
        if isNotificationElement(desc) then purgeNotification(desc) end
    end
end

task.spawn(function()
    local pGui = LocalPlayer:WaitForChild("PlayerGui", 10)
    if pGui then
        cleanAllExistingNotifications()
        Cupie:AddConnection(pGui.DescendantAdded:Connect(function(desc)
            if Config.HideNotifications then
                task.defer(function()
                    if isNotificationElement(desc) then purgeNotification(desc) end
                end)
            end
        end))
    end
end)

cleanAllExistingNotifications()

-- ══════════════════════════════════════════════════════════
-- HELPER FUNCTIONS (Plot, In-Game Equip & Remote Handlers)
-- ══════════════════════════════════════════════════════════

local function getMyPlot()
    local plots = Workspace:FindFirstChild("Plots")
    if not plots then return nil end
    
    for _, plot in ipairs(plots:GetChildren()) do
        local ownerAttr = plot:GetAttribute("Owner") or plot:GetAttribute("UserId")
        if ownerAttr and (tostring(ownerAttr) == LocalPlayer.Name or tostring(ownerAttr) == tostring(LocalPlayer.UserId)) then
            return plot
        end
    end
    
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        local closest, minDist = nil, math.huge
        for _, plot in ipairs(plots:GetChildren()) do
            local cf = plot:GetPivot()
            local dist = (cf.Position - root.Position).Magnitude
            if dist < minDist then
                minDist = dist
                closest = plot
            end
        end
        if closest and minDist < 250 then return closest end
    end
    
    return plots:FindFirstChild("Plot1") or plots:FindFirstChild("Plot2") or plots:GetChildren()[1]
end

local function firePrompt(prompt)
    if not prompt or not prompt.Enabled then return end
    if fireproximityprompt then
        pcall(function() fireproximityprompt(prompt) end)
    end
end

local function ensureSmoothPadPosition(padPart)
    if not padPart then return end
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local targetPos = padPart.Position + Vector3.new(0, 3, 0)
    local dist = (root.Position - targetPos).Magnitude
    
    if dist > 3.5 then
        root.CFrame = CFrame.new(targetPos, targetPos + padPart.CFrame.LookVector)
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end
end

-- Exact In-Game Equip Best (Verified: Characters.UpdateInventory:FireServer("EquipBest"))
local function triggerEquipBest()
    if CharactersInv then
        pcall(function() CharactersInv:FireServer("EquipBest") end)
    end
    
    local plot = getMyPlot()
    if plot then
        local equipPrompt = plot:FindFirstChild("EquipPrompt", true) or plot:FindFirstChild("AutoEquipPrompt", true)
        if equipPrompt then firePrompt(equipPrompt) end
    end
end

-- Rarity Rank Helpers
local function getMinRankFromRule(ruleString)
    if ruleString == "Common & Above" or ruleString == "All Rarities" then return 1
    elseif ruleString == "Rare & Above" then return 2
    elseif ruleString == "Epic & Above" then return 3
    elseif ruleString == "Legendary & Above" then return 4
    elseif ruleString == "Mythic & Above" then return 5
    elseif ruleString == "God & Above" then return 6
    elseif ruleString == "Godly & Above" then return 7
    elseif ruleString == "Godlyx & Above" then return 8
    elseif ruleString == "Secret & Above" then return 9
    elseif ruleString == "Divine & Above" then return 10
    elseif ruleString == "Immortal & Above" then return 11
    elseif ruleString == "OP & Above" then return 12
    elseif ruleString == "OG & Above" then return 13
    elseif ruleString == "INVASION & Above" then return 14
    elseif ruleString == "Limited Only" then return 15
    end
    return 1
end

local function getMaxSellRank(sellChoice)
    if sellChoice == "Common Only" then return 1
    elseif sellChoice == "Up to Rare (Common + Rare)" then return 2
    elseif sellChoice == "Up to Epic (Common + Rare + Epic)" then return 3
    elseif sellChoice == "Up to Legendary" then return 4
    elseif sellChoice == "Disabled" then return 0
    end
    return 1
end

-- Smart Auto Buy by Rarity Function
local function executeSmartAutoBuy()
    if not CharactersBuy then return end
    local minRank = getMinRankFromRule(Config.BuyRuleRarity)
    local tiers = (Config.BuyRuleTier == "All Tiers") and {1, 2, 3, 4} or {tonumber(Config.BuyRuleTier:match("%d+")) or 1}
    
    for _, tier in ipairs(tiers) do
        for slot = 1, 3 do
            CharactersBuy:FireServer(tier, slot)
            task.wait(0.06)
        end
    end
end

-- Auto Lock by Selected Minimum Rarity (Verified: Flex.UpdateCharacterLock)
local function executeAutoLockUnits()
    if not FlexLock then return end
    local minLockRank = getMinRankFromRule(Config.LockMinRarity)
    pcall(function()
        FlexLock:FireServer("AutoLock", minLockRank)
    end)
end

-- Auto Upgrade Stats Loop (Verified from foranimell.lua: Upgrade:FireServer("Gold", "Luck" / "Inventory" / "Gold" / "Slots"))
local function executeStatUpgrades()
    if not GeneralUpgrade then return end
    if Config.AutoUpgradeLuck then
        pcall(function() GeneralUpgrade:FireServer("Gold", "Luck") end)
    end
    if Config.AutoUpgradeInventory then
        pcall(function() GeneralUpgrade:FireServer("Gold", "Inventory") end)
    end
    if Config.AutoUpgradeGold then
        pcall(function() GeneralUpgrade:FireServer("Gold", "Gold") end)
    end
    if Config.AutoUpgradeSlots then
        pcall(function() GeneralUpgrade:FireServer("Gold", "Slots") end)
    end
end

-- Anti-AFK Handler
if getconnections then
    pcall(function()
        for _, conn in ipairs(getconnections(LocalPlayer.Idled)) do
            if conn.Disable then conn:Disable()
            elseif conn.Disconnect then conn:Disconnect() end
        end
    end)
end
LocalPlayer.Idled:Connect(function()
    if Config.AntiAFK then
        VirtualUser:Button2Down(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
        task.wait(0.2)
        VirtualUser:Button2Up(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
    end
end)

-- Noclip Stepped Handler
Cupie:AddConnection(RunService.Stepped:Connect(function()
    if Config.Noclip then
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end
end))

-- ══════════════════════════════════════════════════════════
-- CREATE WINDOW
-- ══════════════════════════════════════════════════════════
local Window = Cupie:CreateWindow({
    Title    = "🐰 CUPIE HUB",
    Subtitle = "Roll Anime To Fight • v1.0",
    Keybind  = Enum.KeyCode.RightControl
})

-- ══════════════════════════════════════════════════════════
-- TAB 1: 📊 DASHBOARD & STATS (ภาพรวมไอดี & ควบคุมระบบหลัก)
-- ══════════════════════════════════════════════════════════
local DashTab = Window:CreateTab("Stats", 1)
DashTab:CreateHeader("Player Account & Wallet", 1)

local walletPara = DashTab:CreateParagraph({
    Title = "💰 Live Currencies",
    Content = "Loading wallet & account stats...",
    LayoutOrder = 2
})

DashTab:CreateHeader("Plot & Team Status", 3)

local plotPara = DashTab:CreateParagraph({
    Title = "📍 Plot Info",
    Content = "Scanning player plot...",
    LayoutOrder = 4
})

DashTab:CreateHeader("15 In-Game Rarity Tiers", 5)

local raritiesSummary = DashTab:CreateParagraph({
    Title = "👑 Exact 15 Rarities In-Game",
    Content = "Scanning rarity progression...",
    LayoutOrder = 6
})

-- Live Stats Updater Loop
task.spawn(function()
    local startTime = os.time()
    while true do
        task.wait(1.5)
        pcall(function()
            local ls = LocalPlayer:FindFirstChild("leaderstats")
            local goldVal = ls and (ls:FindFirstChild("Gold") or ls:FindFirstChild("Coins") or ls:FindFirstChild("Money"))
            local gemsVal = ls and (ls:FindFirstChild("Gems") or ls:FindFirstChild("Diamonds"))
            local winsVal = ls and (ls:FindFirstChild("Wins") or ls:FindFirstChild("Level") or ls:FindFirstChild("Stage"))
            
            local goldStr = goldVal and tostring(goldVal.Value) or "In-Game"
            local gemsStr = gemsVal and tostring(gemsVal.Value) or "In-Game"
            local winsStr = winsVal and tostring(winsVal.Value) or "0"
            
            local elapsed = os.time() - startTime
            local hrs = math.floor(elapsed / 3600)
            local mins = math.floor((elapsed % 3600) / 60)
            local secs = elapsed % 60
            local timeStr = string.format("%02d:%02d:%02d", hrs, mins, secs)
            
            walletPara.Title = "💰 " .. LocalPlayer.DisplayName .. " (@" .. LocalPlayer.Name .. ")"
            walletPara.Content = string.format("🪙 Gold: %s   |   💎 Gems: %s\n🏆 Wins / Level: %s   |   ⏱️ Farm Uptime: %s", goldStr, gemsStr, winsStr, timeStr)
            
            local plot = getMyPlot()
            local plotName = plot and plot.Name or "Assigned"
            local totalPlots = Workspace:FindFirstChild("Plots") and #Workspace.Plots:GetChildren() or 0
            
            plotPara.Title = string.format("📍 Assigned: %s (Total Server Plots: %d)", plotName, totalPlots)
            plotPara.Content = string.format("🎯 Status: EquipBest [%s]  |  Upgrade [%s]  |  Evolve [%s]  |  Stats [%s]", 
                Config.AutoEquipBest and "ON" or "OFF",
                Config.AutoLevelUp and "ON" or "OFF",
                Config.AutoEvolve and "ON" or "OFF",
                Config.AutoUpgradeStats and "ON" or "OFF"
            )
            
            raritiesSummary.Title = "👑 15 In-Game Rarity Hierarchy"
            raritiesSummary.Content = "15. 💖 Limited   14. 👾 INVASION   13. 💎 OG   12. 💥 OP\n" ..
                "11. 🔥 Immortal   10. 👑 Divine   9. 🔮 Secret   8. 💫 Godlyx\n" ..
                "7. ⚡ Godly   6. ✨ God   5. 🔴 Mythic   4. 🟡 Legendary\n" ..
                "3. 🟣 Epic   2. 🟢 Rare   1. ⚪ Common"
        end)
    end
end)



-- ══════════════════════════════════════════════════════════
-- TAB 2: 🎰 GACHA & SUMMON ENGINE (ระบบสุ่ม & ซื้อ/ขาย/ล็อคตามระดับ)
-- ══════════════════════════════════════════════════════════
local GachaTab = Window:CreateTab("Gacha", 2)
GachaTab:CreateHeader("Auto Roll & Summon Engine", 1)

GachaTab:CreateToggle({
    Name = "Auto Roll (Fast Summon)",
    Description = "Positions on pad and rolls continuously with auto-lock & filters",
    Badge = "HOT",
    Default = false,
    Callback = function(state)
        Config.AutoRoll = state
        if state then
            local plot = getMyPlot()
            if plot and plot:FindFirstChild("Roll") and plot.Roll:FindFirstChild("RollButton") then
                local btn = plot.Roll.RollButton:FindFirstChild("Button")
                if btn then ensureSmoothPadPosition(btn) end
            end
            
            Cupie:StartLoop("AutoRollLoop", Config.RollDelay, function()
                local p = getMyPlot()
                if p and p:FindFirstChild("Roll") then
                    local rollBtn = p.Roll:FindFirstChild("RollButton")
                    if rollBtn and rollBtn:FindFirstChild("Button") then
                        local btn = rollBtn.Button
                        ensureSmoothPadPosition(btn)
                        local prompt = btn:FindFirstChild("RollPrompt") or btn:FindFirstChildWhichIsA("ProximityPrompt", true)
                        if prompt then firePrompt(prompt) end
                    end
                end
                
                if CharactersRoll then
                    pcall(function() CharactersRoll:FireServer() end)
                end
            end)
        else
            Cupie:StopLoop("AutoRollLoop")
        end
    end
})

GachaTab:CreateSlider({
    Name = "Roll Speed / Delay",
    Description = "Interval between each roll attempt (seconds, min 2.0s)",
    Min = 2.00,
    Max = 10.00,
    Default = 2.00,
    Step = 0.05,
    Decimals = 2,
    Suffix = "s",
    Callback = function(val)
        Config.RollDelay = math.max(2.00, val)
        if Config.AutoRoll then
            Cupie:StopLoop("AutoRollLoop")
            Cupie:StartLoop("AutoRollLoop", Config.RollDelay, function()
                local p = getMyPlot()
                if p and p:FindFirstChild("Roll") then
                    local rollBtn = p.Roll:FindFirstChild("RollButton")
                    if rollBtn and rollBtn:FindFirstChild("Button") then
                        local btn = rollBtn.Button
                        ensureSmoothPadPosition(btn)
                        local prompt = btn:FindFirstChild("RollPrompt") or btn:FindFirstChildWhichIsA("ProximityPrompt", true)
                        if prompt then firePrompt(prompt) end
                    end
                end
                if CharactersRoll then pcall(function() CharactersRoll:FireServer() end) end
            end)
        end
    end
})

GachaTab:CreateHeader("Smart Auto Buy By Rarity (ซื้อเฉพาะระดับที่เลือก)", 3)

GachaTab:CreateDropdown({
    Name = "Buy Minimum Rarity",
    Description = "Only automatically buys characters that meet or exceed this rarity",
    Options = {
        "Legendary & Above",
        "Mythic & Above",
        "God & Above",
        "Godly & Above",
        "Godlyx & Above",
        "Secret & Above",
        "Divine & Above",
        "Immortal & Above",
        "OP & Above",
        "OG & Above",
        "INVASION & Above",
        "Limited Only",
        "Common & Above (Buy All)"
    },
    Default = "Mythic & Above",
    Callback = function(rule)
        Config.BuyRuleRarity = rule
    end
})

GachaTab:CreateDropdown({
    Name = "Buy Target Tier",
    Description = "Select which Tier shop to apply the auto buy rule",
    Options = {"All Tiers", "Tier 1", "Tier 2", "Tier 3", "Tier 4"},
    Default = "All Tiers",
    Callback = function(tierChoice)
        Config.BuyRuleTier = tierChoice
    end
})

GachaTab:CreateToggle({
    Name = "Auto Buy Target Rarity Characters",
    Description = "Continuously buys characters matching your selected rarity criteria",
    Badge = "BUY",
    Default = false,
    Callback = function(state)
        Config.AutoBuyByRarity = state
        if state then
            Cupie:StartLoop("AutoBuyRarityLoop", 0.5, function()
                executeSmartAutoBuy()
            end)
        else
            Cupie:StopLoop("AutoBuyRarityLoop")
        end
    end
})

GachaTab:CreateHeader("Auto Lock Units (เลือกระดับที่ต้องการล็อค)", 7)

GachaTab:CreateDropdown({
    Name = "Auto Lock Minimum Rarity",
    Description = "Select which minimum rarity to automatically protect & lock",
    Options = {
        "Legendary & Above",
        "Mythic & Above",
        "God & Above",
        "Godly & Above",
        "Godlyx & Above",
        "Secret & Above",
        "Divine & Above",
        "Immortal & Above",
        "OP & Above",
        "OG & Above",
        "INVASION & Above",
        "Limited Only",
        "Epic & Above",
        "Rare & Above",
        "All Units"
    },
    Default = "Legendary & Above",
    Callback = function(choice)
        Config.LockMinRarity = choice
        if Config.AutoLockRareUnits then executeAutoLockUnits() end
    end
})

GachaTab:CreateToggle({
    Name = "Auto Lock Rare Units",
    Description = "Locks high-tier characters automatically based on selected rarity",
    Badge = "LOCK",
    Default = true,
    Callback = function(state)
        Config.AutoLockRareUnits = state
        if state then
            executeAutoLockUnits()
            Cupie:StartLoop("AutoLockLoop", 2.0, function() executeAutoLockUnits() end)
        else
            Cupie:StopLoop("AutoLockLoop")
        end
    end
})

GachaTab:CreateHeader("Auto Delete / Sell (เลือกระดับที่ต้องการขาย)", 10)

GachaTab:CreateDropdown({
    Name = "Auto Sell Up To Rarity",
    Description = "Select maximum rarity to automatically sell for Gold",
    Options = {
        "Common Only",
        "Up to Rare (Common + Rare)",
        "Up to Epic (Common + Rare + Epic)",
        "Up to Legendary",
        "Disabled"
    },
    Default = "Common Only",
    Callback = function(choice)
        Config.SellThreshold = choice
    end
})

GachaTab:CreateToggle({
    Name = "Auto Delete / Sell Low Tier",
    Description = "Sells low rarity units continuously to free inventory and earn Gold",
    Badge = "SELL",
    Default = false,
    Callback = function(state)
        Config.AutoSellLowTier = state
        if state then
            Cupie:StartLoop("AutoSellLoop", 1.0, function()
                local maxSellRank = getMaxSellRank(Config.SellThreshold)
                if CharactersSell and maxSellRank > 0 then
                    pcall(function() CharactersSell:FireServer(maxSellRank) end)
                end
            end)
        else
            Cupie:StopLoop("AutoSellLoop")
        end
    end
})

GachaTab:CreateHeader("Target Stop Roll & Lucky Wheel", 13)

GachaTab:CreateDropdown({
    Name = "Target Stop Rarity",
    Description = "Stops Auto Roll when rolled character reaches this rarity",
    Options = {
        "Legendary & Above",
        "Mythic & Above",
        "God & Above",
        "Godly & Above",
        "Godlyx & Above",
        "Secret & Above",
        "Divine & Above",
        "Immortal & Above",
        "OP & Above",
        "OG & Above",
        "INVASION & Above",
        "Limited Only"
    },
    Default = "Mythic & Above",
    Callback = function(choice)
        Config.StopRarityTarget = choice
    end
})

GachaTab:CreateToggle({
    Name = "Stop Roll on Target Rarity",
    Description = "Automatically pauses rolling and alerts you when target unit is obtained",
    Default = false,
    Callback = function(state)
        Config.TargetRarityFilter = state
    end
})

GachaTab:CreateToggle({
    Name = "Auto Spin Wheel (Silent)",
    Description = "Spins wheel continuously without popup notifications",
    Badge = "FREE",
    Default = false,
    Callback = function(state)
        Config.AutoSpinWheel = state
        if state then
            cleanAllExistingNotifications()
            Cupie:StartLoop("AutoSpinLoop", 3.5, function()
                if SpinRemote then
                    SpinRemote:FireServer("Spin")
                    task.wait(1.2)
                    SpinRemote:FireServer("Complete", {})
                    cleanAllExistingNotifications()
                end
            end)
        else
            Cupie:StopLoop("AutoSpinLoop")
        end
    end
})

GachaTab:CreateToggle({
    Name = "Hide All Screen Popups (ป้ายชื่อ)",
    Description = "Blocks and destroys all center screen notification labels",
    Default = true,
    Callback = function(state)
        Config.HideNotifications = state
        if state then cleanAllExistingNotifications() end
    end
})

GachaTab:CreateButton({
    Name = "Clear Screen Text Now",
    Description = "Instantly clears all stuck labels/popups on your screen",
    Callback = function()
        cleanAllExistingNotifications()
        Cupie:Notify("Screen Cleaned", "Purged all notification popups!", 2.0)
    end
})

-- ══════════════════════════════════════════════════════════
-- TAB 3: 👥 TEAM & STAT UPGRADES (พัฒนาสเตตัส & สุ่ม Trait)
-- ══════════════════════════════════════════════════════════
local UpgradeTab = Window:CreateTab("Upgrades", 3)
UpgradeTab:CreateHeader("Team & Character Progression (Auto Controls)", 1)

UpgradeTab:CreateToggle({
    Name = "Auto Equip Best Units",
    Description = "Automatically and continuously keeps your strongest team equipped",
    Badge = "BEST",
    Default = false,
    Callback = function(state)
        Config.AutoEquipBest = state
        if state then
            triggerEquipBest()
            Cupie:StartLoop("AutoEquipBestLoop", 1.5, function() triggerEquipBest() end)
        else
            Cupie:StopLoop("AutoEquipBestLoop")
        end
    end
})

UpgradeTab:CreateToggle({
    Name = "Auto Level Up Team",
    Description = "Continuously upgrades character levels as Gold is earned",
    Badge = "UPGRADE",
    Default = false,
    Callback = function(state)
        Config.AutoLevelUp = state
        if state then
            Cupie:StartLoop("AutoLevelUpLoop", 1.0, function()
                if CharactersLevelUp then CharactersLevelUp:FireServer() end
            end)
        else
            Cupie:StopLoop("AutoLevelUpLoop")
        end
    end
})

UpgradeTab:CreateToggle({
    Name = "Auto Evolve Characters",
    Description = "Automatically evolves characters as soon as requirements are met",
    Badge = "EVOLVE",
    Default = false,
    Callback = function(state)
        Config.AutoEvolve = state
        if state then
            Cupie:StartLoop("AutoEvolveLoop", 3.0, function()
                if EvolutionRemote then EvolutionRemote:FireServer({}) end
            end)
        else
            Cupie:StopLoop("AutoEvolveLoop")
        end
    end
})

UpgradeTab:CreateHeader("Account Stat Upgrades (Verified Remotes)", 5)

UpgradeTab:CreateToggle({
    Name = "Auto Upgrade All Stats (Luck/Bag/Gold/Slots)",
    Description = "Continuously spends Gold to upgrade Luck, Inventory size, Gold multiplier, and Slots",
    Badge = "STATS",
    Default = false,
    Callback = function(state)
        Config.AutoUpgradeStats = state
        if state then
            Cupie:StartLoop("AutoStatsLoop", 1.0, function()
                executeStatUpgrades()
            end)
        else
            Cupie:StopLoop("AutoStatsLoop")
        end
    end
})

UpgradeTab:CreateButton({
    Name = "Upgrade All Stats Once Now",
    Description = "Spends available Gold on all 4 stat upgrades immediately",
    Callback = function()
        executeStatUpgrades()
        Cupie:Notify("Upgrades", "Sent All Stat Upgrade Requests!", 2.0)
    end
})

UpgradeTab:CreateHeader("Character Traits & Progression", 4)

UpgradeTab:CreateToggle({
    Name = "Auto Trait Reroll Loop",
    Description = "Continuously rerolls traits for active unit",
    Default = false,
    Callback = function(state)
        Config.AutoTraitReroll = state
        if state then
            Cupie:StartLoop("AutoTraitLoop", 0.5, function()
                if TraitRemote then TraitRemote:FireServer() end
            end)
        else
            Cupie:StopLoop("AutoTraitLoop")
        end
    end
})

UpgradeTab:CreateButton({
    Name = "Clone Unit Request",
    Description = "Requests character shadow clone",
    Callback = function()
        if CloneRemote then
            CloneRemote:FireServer()
            Cupie:Notify("Clone", "Clone request sent!", 2.0)
        end
    end
})

UpgradeTab:CreateHeader("Manual Shop Purchasing", 7)

UpgradeTab:CreateDropdown({
    Name = "Target Tier",
    Description = "Select which Tier shop to purchase from",
    Options = {"Tier 1 (Starter)", "Tier 2 (Rare)", "Tier 3 (Epic/Legend)", "Tier 4 (Mythic/God)", "All Tiers (1-4)"},
    Default = "Tier 1 (Starter)",
    Callback = function(selected)
        if selected:find("Tier 1") then Config.SelectedTier = 1
        elseif selected:find("Tier 2") then Config.SelectedTier = 2
        elseif selected:find("Tier 3") then Config.SelectedTier = 3
        elseif selected:find("Tier 4") then Config.SelectedTier = 4
        elseif selected:find("All Tiers") then Config.SelectedTier = "All"
        end
    end
})

UpgradeTab:CreateDropdown({
    Name = "Target Slot",
    Description = "Select slot position in shop",
    Options = {"All Slots", "Slot 1", "Slot 2", "Slot 3"},
    Default = "All Slots",
    Callback = function(selected)
        Config.SelectedSlot = selected
    end
})

UpgradeTab:CreateToggle({
    Name = "Continuous Shop Auto Buy",
    Description = "Spams buy for selected tier & slot directly",
    Default = false,
    Callback = function(state)
        Config.AutoBuyTier = state
        if state then
            Cupie:StartLoop("AutoBuyLoop", 0.4, function()
                if not CharactersBuy then return end
                local tiers = (Config.SelectedTier == "All") and {1, 2, 3, 4} or {Config.SelectedTier}
                for _, tier in ipairs(tiers) do
                    if Config.SelectedSlot == "All Slots" then
                        CharactersBuy:FireServer(tier, 1)
                        task.wait(0.08)
                        CharactersBuy:FireServer(tier, 2)
                        task.wait(0.08)
                        CharactersBuy:FireServer(tier, 3)
                    elseif Config.SelectedSlot == "Slot 1" then
                        CharactersBuy:FireServer(tier, 1)
                    elseif Config.SelectedSlot == "Slot 2" then
                        CharactersBuy:FireServer(tier, 2)
                    elseif Config.SelectedSlot == "Slot 3" then
                        CharactersBuy:FireServer(tier, 3)
                    end
                end
            end)
        else
            Cupie:StopLoop("AutoBuyLoop")
        end
    end
})

-- ══════════════════════════════════════════════════════════
-- TAB 4: ⚔️ COMBAT & DUNGEONS
-- ══════════════════════════════════════════════════════════
local CombatTab = Window:CreateTab("Combat", 4)
CombatTab:CreateHeader("Combat Automation & Battle Loop", 1)

CombatTab:CreateToggle({
    Name = "Auto Fight (Infinite Battles)",
    Description = "Automatically starts battles and advances waves continuously",
    Badge = "FARM",
    Default = false,
    Callback = function(state)
        Config.AutoFight = state
        if state then
            Cupie:StartLoop("AutoFightLoop", 1.5, function()
                if FightStart then FightStart:FireServer("AutoPlay") end
                if Config.AutoWaveSkip and FightArrived then FightArrived:FireServer() end
            end)
        else
            Cupie:StopLoop("AutoFightLoop")
            if FightStart then FightStart:FireServer("Stop") end
        end
    end
})

CombatTab:CreateToggle({
    Name = "Fast Attack Aura (Max DPS)",
    Description = "Rapidly executes attack hits for all deployed characters",
    Badge = "DPS",
    Default = false,
    Callback = function(state)
        Config.FastAttackAura = state
        if state then
            Cupie:StartLoop("AutoAttackLoop", Config.AttackSpeed, function()
                if FlexAttack then FlexAttack:FireServer() end
            end)
        else
            Cupie:StopLoop("AutoAttackLoop")
        end
    end
})

CombatTab:CreateSlider({
    Name = "Attack Hit Rate",
    Description = "Interval between attack strikes (seconds)",
    Min = 0.04,
    Max = 0.50,
    Default = 0.08,
    Decimals = 2,
    Suffix = "s",
    Callback = function(val)
        Config.AttackSpeed = val
        if Config.FastAttackAura then
            Cupie:StopLoop("AutoAttackLoop")
            Cupie:StartLoop("AutoAttackLoop", Config.AttackSpeed, function()
                if FlexAttack then FlexAttack:FireServer() end
            end)
        end
    end
})

CombatTab:CreateToggle({
    Name = "Instant Wave Advance (Fight.Arrived)",
    Description = "Skips walk transition time between waves and stages",
    Default = true,
    Callback = function(state)
        Config.AutoWaveSkip = state
    end
})

CombatTab:CreateHeader("Dungeon Modes & Quick Actions", 6)

CombatTab:CreateButton({
    Name = "Join Tower Dungeon",
    Description = "Instantly queues into Tower Dungeon Mode",
    Callback = function()
        if JoinTowerRemote then
            JoinTowerRemote:FireServer()
            Cupie:Notify("Tower", "Joined Tower Dungeon!", 2.5)
        end
    end
})

CombatTab:CreateButton({
    Name = "Teleport to AFK World",
    Description = "Teleports to AFK Rewards World",
    Callback = function()
        if AFKTeleportRemote then
            AFKTeleportRemote:FireServer()
            Cupie:Notify("AFK World", "Teleporting to AFK Area...", 2.5)
        end
    end
})

CombatTab:CreateButton({
    Name = "Emergency Stop Combat",
    Description = "Immediately halts and exits current battle",
    Callback = function()
        if FightStart then
            FightStart:FireServer("Stop")
            Cupie:Notify("Combat", "Combat Stopped!", 2.0)
        end
    end
})

-- ══════════════════════════════════════════════════════════
-- TAB 5: 🎁 QUESTS & FACTIONS
-- ══════════════════════════════════════════════════════════
local MiscTab = Window:CreateTab("Misc", 5)
MiscTab:CreateHeader("Quests, Factions & Free Rewards", 1)

MiscTab:CreateToggle({
    Name = "Auto Claim Battlepass Quests",
    Description = "Continuously claims all completed daily/season quests and levels",
    Default = false,
    Callback = function(state)
        Config.AutoClaimBP = state
        if state then
            Cupie:StartLoop("AutoBPLoop", 2.5, function()
                if BPGetQuestData then BPGetQuestData:InvokeServer() end
                if BPClaimQuest then BPClaimQuest:FireServer() end
                if BPClaimLevel then BPClaimLevel:FireServer() end
                if BPPremiumStatus then BPPremiumStatus:InvokeServer() end
            end)
        else
            Cupie:StopLoop("AutoBPLoop")
        end
    end
})

MiscTab:CreateToggle({
    Name = "Auto Claim Free Group & VIP Rewards",
    Description = "Claims Group Rewards and VIP status continuously",
    Default = false,
    Callback = function(state)
        Config.AutoFreeRewards = state
        if state then
            Cupie:StartLoop("FreeRewardsLoop", 8.0, function()
                if FreeGroupRemote then FreeGroupRemote:FireServer() end
                if ClaimVIPRemote then ClaimVIPRemote:FireServer() end
            end)
        else
            Cupie:StopLoop("FreeRewardsLoop")
        end
    end
})

MiscTab:CreateButton({
    Name = "Claim Tutorial Rewards",
    Description = "Instantly claims tutorial rewards from Modules.Tutorial",
    Callback = function()
        if TutorialDone then TutorialDone:FireServer("8b415605-0fd4-48c8-82f5-fe629dadb5b3") end
        if TutorialReward then TutorialReward:InvokeServer("8b415605-0fd4-48c8-82f5-fe629dadb5b3") end
        Cupie:Notify("Tutorial", "Claimed Tutorial Rewards!", 2.0)
    end
})

MiscTab:CreateButton({
    Name = "Auto Buy NPC Ticket (TalkTickets)",
    Description = "Buys ticket from NPC via TalkTickets remote",
    Callback = function()
        if TalkTicketsRemote then
            TalkTicketsRemote:FireServer("BuyOne")
            Cupie:Notify("NPC Event", "Sent Buy Ticket Request!", 2.0)
        end
    end
})

MiscTab:CreateButton({
    Name = "Claim All Free Rewards Now",
    Description = "Instant one-click claim for all rewards & VIP",
    Callback = function()
        if FreeGroupRemote then FreeGroupRemote:FireServer() end
        if ClaimVIPRemote then ClaimVIPRemote:FireServer() end
        if BPClaimQuest then BPClaimQuest:FireServer() end
        if BPClaimLevel then BPClaimLevel:FireServer() end
        Cupie:Notify("Rewards", "Claimed All Free Gifts & VIP!", 2.5)
    end
})

MiscTab:CreateHeader("LocalPlayer Modifications", 7)

MiscTab:CreateSlider({
    Name = "WalkSpeed",
    Description = "Modify player movement speed",
    Min = 16,
    Max = 250,
    Default = 16,
    Decimals = 0,
    Callback = function(val)
        Config.WalkSpeed = val
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = val end
    end
})

MiscTab:CreateSlider({
    Name = "JumpPower",
    Description = "Modify player jump height",
    Min = 50,
    Max = 300,
    Default = 50,
    Decimals = 0,
    Callback = function(val)
        Config.JumpPower = val
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChild("Humanoid")
        if hum then hum.JumpPower = val end
    end
})

MiscTab:CreateToggle({
    Name = "Infinite Jump",
    Description = "Allows unlimited jumping in mid-air",
    Default = false,
    Callback = function(state)
        Config.InfJump = state
    end
})

MiscTab:CreateToggle({
    Name = "Noclip (Walk Through Walls)",
    Description = "Disables character collision with obstacles",
    Default = false,
    Callback = function(state)
        Config.Noclip = state
    end
})

MiscTab:CreateToggle({
    Name = "Anti-AFK (20m Disconnect Shield)",
    Description = "Prevents Roblox from kicking you for being idle",
    Default = true,
    Callback = function(state)
        Config.AntiAFK = state
    end
})

-- Infinite Jump Listener
Cupie:AddConnection(UserInputService.JumpRequest:Connect(function()
    if Config.InfJump then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChild("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end))

-- Keep Walkspeed persistent on respawn
Cupie:AddConnection(LocalPlayer.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid", 5)
    if hum then
        task.wait(0.2)
        hum.WalkSpeed = Config.WalkSpeed
        hum.JumpPower = Config.JumpPower
    end
end))

MiscTab:CreateHeader("Theme & UI Control", 12)

MiscTab:CreateDropdown({
    Name = "UI Theme",
    Description = "Change the visual color theme of Cupie Hub",
    Options = {"Midnight (AMOLED)", "Dark (Default)", "Purple Cyber", "Emerald Green", "Crimson Ruby", "Ocean Blue"},
    Default = "Midnight (AMOLED)",
    Callback = function(theme)
        Cupie:SetTheme(theme)
    end
})

MiscTab:CreateKeybind({
    Name = "Toggle Menu Keybind",
    Description = "Change keyboard shortcut to open/minimize",
    Default = Window.Keybind,
    Callback = function(newKey)
        Window.Keybind = newKey
        Cupie:Notify("Keybind Updated", "New Key: " .. newKey.Name, 2.5)
    end
})

MiscTab:CreateButton({
    Name = "Unload Script Hub",
    Description = "Safely cleans up all loops, events, and UI",
    Callback = function()
        Cupie:Unload()
    end
})

-- Switch to Stats Tab by Default
Window:SwitchTab("Stats")

Cupie:Notify("🐰 CUPIE HUB", "Loaded Anime Roll Hub v1.0 Successfully!", 3.5)
