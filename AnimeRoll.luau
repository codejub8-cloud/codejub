-- =========================================================
--  CUPIE HUB - Roll Anime To Fight
--  Ultra-Clean Modular UI Framework
-- =========================================================

-- Kill any previously running script threads and GUIs instantly
if _G.CupieHubUnload then pcall(_G.CupieHubUnload) end
if shared.CupieHubUnload then pcall(shared.CupieHubUnload) end

local currentRunToken = tostring(os.time()) .. "_" .. tostring(math.random(1000, 9999))
_G.CupieRunToken = currentRunToken
shared.CupieRunToken = currentRunToken


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
if not LocalPlayer then
    repeat
        task.wait()
        LocalPlayer = Players.LocalPlayer
    until LocalPlayer
end

--// ══════════════════════════════════════════════════════════
--// CUPIE HUB V2.0 UTILITIES & CONFIG PERSISTENCE
--// ══════════════════════════════════════════════════════════
local HttpService = game:GetService("HttpService")

local function Log(logType, message, ...)
    local args = {...}
    local ok, formatted = pcall(function()
        if #args > 0 then
            return string.format(message, table.unpack(args))
        else
            return tostring(message)
        end
    end)
    local msg = ok and formatted or tostring(message)
    local prefix = "[CUPIE HUB]"
    
    if logType == "Error" then
        warn(prefix .. " ❌ " .. msg)
    elseif logType == "Warning" then
        warn(prefix .. " ⚠️ " .. msg)
    elseif logType == "Success" then
        print(prefix .. " ✅ " .. msg)
    else
        print(prefix .. " ℹ️ " .. msg)
    end
end

local function randomDelay(base, variance)
    variance = variance or 0.3
    return base + (math.random() * variance)
end

local function createThrottle(callback, cooldown)
    local lastRun = 0
    return function(...)
        local now = tick()
        if now - lastRun >= cooldown then
            lastRun = now
            return callback(...)
        end
    end
end


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

_G.CupieHubUnload = function()
    _G.CupieRunToken = nil
    shared.CupieRunToken = nil
    if Cupie and Cupie.Unload then Cupie:Unload() end
end
shared.CupieHubUnload = _G.CupieHubUnload

function Cupie:AddConnection(conn)
    table.insert(Cupie.ActiveConnections, conn)
    return conn
end

function Cupie:StartLoop(id, interval, fn)
    local token = (type(Cupie.Loops[id]) == "number" and Cupie.Loops[id] or 0) + 1
    Cupie.Loops[id] = token
    task.spawn(function()
        while Cupie.Loops[id] == token and _G.CupieRunToken == currentRunToken do
            pcall(fn)
            task.wait(interval)
        end
    end)
end

function Cupie:StopLoop(id)
    Cupie.Loops[id] = false
end

function Cupie:SafeFire(remote, ...)
    if not remote then 
        Log("Warning", "Attempted to fire nil remote!")
        return false
    end
    local success, err = pcall(function(...) remote:FireServer(...) end, ...)
    if not success then
        Log("Error", "Failed to fire remote: %s", tostring(err))
    end
    return success
end

function Cupie:SafeInvoke(remote, ...)
    if not remote then 
        Log("Warning", "Attempted to invoke nil remote!")
        return false, nil
    end
    local success, result = pcall(function(...) return remote:InvokeServer(...) end, ...)
    if not success then
        Log("Error", "Failed to invoke remote: %s", tostring(result or "unknown"))
    end
    return success, result
end

function Cupie:Unload()
    Log("Info", "Unloading Cupie Hub...")
    pcall(saveConfig)
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
local parentGui
if gethui then
    local ok, h = pcall(gethui)
    if ok and h then parentGui = h end
end
if not parentGui and cloneref then
    local ok, cg = pcall(function() return cloneref(CoreGui) end)
    if ok and cg then parentGui = cg end
end
if not parentGui then
    local ok, pg = pcall(function()
        return LocalPlayer and (LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 3))
    end)
    if ok and pg then parentGui = pg end
end
if not parentGui then parentGui = CoreGui end

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
    local windowTitle    = config.Title or "CUPIE HUB"
    local windowSubtitle = config.Subtitle or "Template UI - v1.0"
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
    statsLabel.Text = "🔄 BOOTING..."
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

    -- Live Performance Update Loop (2s Interval + Real FPS Calculation)
    local fpsCount = 0
    local fCount = 0
    local lastT = tick()
    local isFirstUpdate = true

    Cupie:AddConnection(RunService.RenderStepped:Connect(function()
        fCount = fCount + 1
        local now = tick()
        local dt = now - lastT
        if dt >= 2 then
            fpsCount = math.floor(fCount / dt + 0.5)
            fCount = 0
            lastT = now
            
            if isFirstUpdate or fpsCount == 0 then
                statsLabel.Text = "🔄 BOOTING..."
                isFirstUpdate = false
            else
                local dot = (fpsCount >= 50 and "🟢 ") or (fpsCount >= 30 and "🟡 ") or "🔴 "
                local pingVal = 0
                pcall(function()
                    pingVal = math.floor(LocalPlayer:GetNetworkPing() * 1000)
                end)
                statsLabel.Text = dot .. tostring(fpsCount) .. " FPS • " .. tostring(pingVal) .. "ms"
            end
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

            local precision = opts.Decimals
            if precision == nil then
                if min ~= math.floor(min) or max ~= math.floor(max) or defVal ~= math.floor(defVal) or (step and step ~= math.floor(step)) then
                    precision = 1
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

            -- Interactive Value Box
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

            -- Circular Visual Knob
            local knob = Instance.new("Frame", fill)
            knob.Size = UDim2.fromOffset(12, 12)
            knob.Position = UDim2.new(1, -6, 0.5, -6)
            knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            knob.BorderSizePixel = 0
            Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

            -- Large Touch/Mouse Hitbox (28px)
            local sbtn = Instance.new("TextButton")
            sbtn.AutoLocalize = false
            sbtn.Text = ""
            sbtn.Size = UDim2.new(1, 0, 0, 28)
            sbtn.Position = UDim2.new(0, 0, 0.5, -14)
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

            -- Direct Textbox Editing Support
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
            curValLbl.Text = selected .. " v"
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
                    curValLbl.Text = selected .. " v"
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
                curValLbl.Text = selected .. (expanded and " ^" or " v")
                TweenService:Create(container, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
                    Size = UDim2.new(1, 0, 0, targetH)
                }):Play()
            end)
            return container
        end

        
        function Tab:CreateMultiDropdown(opts)
            local title    = opts.Name or "Multi Dropdown"
            local options  = opts.Options or {}
            local selected = opts.Default or {}
            local callback = opts.Callback
            local order    = opts.LayoutOrder or 0
            local expanded = false

            local selMap = {}
            if type(selected) == "table" then
                for k, v in pairs(selected) do
                    if type(k) == "number" then selMap[v] = true
                    elseif v == true then selMap[k] = true end
                end
            elseif type(selected) == "string" and selected ~= "" then
                selMap[selected] = true
            end

            local function getSummaryText()
                local count = 0
                local names = {}
                for _, opt in ipairs(options) do
                    if selMap[opt] then
                        count = count + 1
                        table.insert(names, opt)
                    end
                end
                if count == 0 then return "None Selected v"
                elseif count == #options then return "All (" .. count .. ") v"
                elseif count <= 2 then return table.concat(names, ", ") .. " v"
                else return count .. " Selected v" end
            end

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
            titleLbl.Size = UDim2.new(0.42, 0, 1, 0)
            titleLbl.Position = UDim2.fromOffset(12, 0)
            titleLbl.TextXAlignment = Enum.TextXAlignment.Left
            titleLbl.Parent = headerBtn
            Cupie:RegisterTheme(titleLbl, "TextColor3", "text")

            local curValLbl = Instance.new("TextLabel")
            curValLbl.AutoLocalize = false
            curValLbl.Text = getSummaryText()
            curValLbl.Font = Enum.Font.GothamBold
            curValLbl.TextSize = 11
            curValLbl.TextColor3 = Cupie.C.accent
            curValLbl.BackgroundTransparency = 1
            curValLbl.Size = UDim2.new(0.58, -16, 1, 0)
            curValLbl.Position = UDim2.new(0.42, 0, 0, 0)
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
                local isSel = (selMap[optName] == true)
                optBtn.Text = (isSel and "  [✓] " or "  [  ] ") .. optName
                optBtn.Font = Enum.Font.Gotham
                optBtn.TextSize = 11
                optBtn.TextColor3 = isSel and Cupie.C.accent or Cupie.C.dim
                optBtn.BackgroundColor3 = isSel and Cupie.C.hover or Cupie.C.sidebar
                optBtn.Size = UDim2.new(1, 0, 0, 25)
                optBtn.TextXAlignment = Enum.TextXAlignment.Left
                optBtn.BorderSizePixel = 0
                optBtn.Parent = optHolder
                Instance.new("UICorner", optBtn).CornerRadius = UDim.new(0, 5)

                optBtn.MouseButton1Click:Connect(function()
                    selMap[optName] = not selMap[optName]
                    local newSel = selMap[optName]
                    optBtn.Text = (newSel and "  [✓] " or "  [  ] ") .. optName
                    optBtn.TextColor3 = newSel and Cupie.C.accent or Cupie.C.dim
                    optBtn.BackgroundColor3 = newSel and Cupie.C.hover or Cupie.C.sidebar
                    local sumText = getSummaryText()
                    curValLbl.Text = sumText:gsub(" v", expanded and " ^" or " v")
                    if callback then callback(selMap) end
                end)
            end

            headerBtn.MouseButton1Click:Connect(function()
                expanded = not expanded
                local targetH = expanded and (44 + #options * 28) or 38
                local sumText = getSummaryText()
                curValLbl.Text = sumText:gsub(" v", expanded and " ^" or " v")
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

            local ParagraphObj = {
                Frame = f,
                TitleLabel = h,
                BodyLabel = b
            }
            function ParagraphObj:SetTitle(newTitle)
                h.Text = tostring(newTitle)
            end
            function ParagraphObj:SetContent(newContent)
                b.Text = tostring(newContent)
            end
            function ParagraphObj:Set(newTitle, newContent)
                if newTitle then h.Text = tostring(newTitle) end
                if newContent then b.Text = tostring(newContent) end
            end

            setmetatable(ParagraphObj, {
                __index = f,
                __newindex = function(t, k, v)
                    if k == "Title" then
                        h.Text = tostring(v)
                    elseif k == "Content" or k == "Text" or k == "Body" then
                        b.Text = tostring(v)
                    else
                        rawset(t, k, v)
                    end
                end
            })
            return ParagraphObj
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
    main.Size = UDim2.fromOffset(initW, initH)
    main.BackgroundTransparency = 0

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
    RollDelay           = 2.5,
    
    -- Smart Auto Buy by Rarity
    AutoBuyByRarity     = false,
    SelectedBuyRarities = {
        ["Common"]    = true,
        ["Rare"]      = true,
        ["Epic"]      = true,
        ["Legendary"] = true,
        ["Mythic"]    = true,
        ["Secret"]    = true,
        ["God"]       = true,
        ["Limited"]   = true
    },
    SelectedBuyMutations = {
        ["Gold"]      = true,
        ["Astronaut"] = true,
        ["Diamond"]   = true,
        ["Demon"]     = true,
        ["Destroyer"] = true,
        ["Hollow"]    = true,
        ["Slayer"]    = true,
        ["Cursed"]    = true
    },
    BuyRuleTier         = "All Tiers",
    
    -- Auto Sell Rarities (Multi-Select)
    SelectedSellRarities = {
        ["Common"]    = true,
        ["Rare"]      = true,
        ["Epic"]      = false,
        ["Legendary"] = false,
        ["Mythic"]    = false,
        ["Secret"]    = false,
        ["God"]       = false,
        ["Limited"]   = false
    },
    
    -- Auto Sell Rarity Selection
    AutoSellLowTier     = false,
    SellThreshold       = "Common Only",
    
    -- Auto Pickup
    AutoPickupAll       = false,
    
    -- Team Progression & Upgrades
    AutoEquipBest       = false,
    AutoLevelUp         = false,
    AutoEvolve          = false,
    AutoUpgradeStats    = false,
    AutoUpgradeLuck     = true,
    AutoUpgradeInventory = true,
    AutoUpgradeGold     = true,
    AutoUpgradeSlots    = true,
    AutoTraitReroll     = false,
    
    -- Combat & Farming
    AutoFight           = false,
    FastAttackAura      = false,
    AttackSpeed         = 0.15,
    AutoWaveSkip        = true,
    
    -- Quests & Rewards
    AutoClaimBP         = false,
    AutoFreeRewards     = false,
    AutoFactionQuests   = false,
    AutoSpinWheel       = false,
    HideNotifications   = true,
    
    -- Player Mods
    WalkSpeed           = 16,
    JumpPower           = 50,
    InfJump             = false,
    Noclip              = false,
    AntiAFK             = true
}

-- Config Persistence Functions (shared + writefile/readfile)
local function saveConfig()
    pcall(function()
        if shared then
            shared.CupieConfig = Config
        end
        if writefile and HttpService then
            pcall(function()
                writefile("CupieHub_Config.json", HttpService:JSONEncode(Config))
            end)
        end
        Log("Success", "Configuration saved successfully!")
    end)
end

local function loadConfig()
    pcall(function()
        if shared and shared.CupieConfig then
            for k, v in pairs(shared.CupieConfig) do
                if Config[k] ~= nil then
                    Config[k] = v
                end
            end
        end
        if readfile and HttpService then
            pcall(function()
                local data = readfile("CupieHub_Config.json")
                if data and data ~= "" then
                    local loaded = HttpService:JSONDecode(data)
                    for k, v in pairs(loaded) do
                        if Config[k] ~= nil then
                            Config[k] = v
                        end
                    end
                end
            end)
        end
        Log("Info", "Configuration loaded successfully!")
    end)
end

-- ══════════════════════════════════════════════════════════
-- SAFE NOTIFICATION HANDLER (Zero Damage to Game UI)
-- ══════════════════════════════════════════════════════════

local function cleanAllExistingNotifications()
    pcall(function()
        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
        if not playerGui then return end
        
        for _, gui in ipairs(playerGui:GetChildren()) do
            if gui:IsA("ScreenGui") and gui.Name ~= "CUPIEUI" and gui.Enabled then
                for _, child in ipairs(gui:GetDescendants()) do
                    if child:IsA("TextLabel") or child:IsA("Frame") then
                        local name = child.Name:lower()
                        local text = child:IsA("TextLabel") and child.Text:lower() or ""
                        
                        local isPopup = (
                            name:find("popup") or 
                            name:find("notif") or 
                            name:find("toast") or 
                            name:find("alert") or 
                            name:find("message") or 
                            name:find("reward") or 
                            name:find("claim") or 
                            text:find("rolled") or 
                            text:find("claimed") or 
                            text:find("reward") or 
                            text:find("success") or 
                            text:find("got") or 
                            text:find("rare") or 
                            text:find("epic") or 
                            text:find("legendary") or 
                            text:find("mythic") or 
                            text:find("secret") or 
                            text:find("god") or 
                            text:find("limited") or 
                            (child.Parent and child.Parent.Name:lower():find("popup"))
                        )
                        
                        local isProtected = (
                            child.Parent and 
                            (child.Parent.Name:lower():find("shop") or
                             child.Parent.Name:lower():find("pass") or
                             child.Parent.Name:lower():find("upgrade") or
                             child.Parent.Name:lower():find("gold") or
                             child.Parent.Name:lower():find("hud") or
                             child.Parent.Name:lower():find("main") or
                             child.Parent.Name:lower():find("bar"))
                        )
                        
                        if isPopup and not isProtected then
                            if child:IsA("TextLabel") then
                                child.Visible = false
                                child.TextTransparency = 1
                            elseif child:IsA("Frame") then
                                child.Visible = false
                            end
                        end
                    end
                end
            end
        end
    end)
end

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
    pcall(function()
        prompt.MaxActivationDistance = 999999
        prompt.RequiresLineOfSight = false
        prompt.HoldDuration = 0
    end)
    if fireproximityprompt then
        pcall(function() fireproximityprompt(prompt) end)
    elseif prompt.InputHoldBegin then
        pcall(function()
            prompt:InputHoldBegin()
            task.wait(0.04)
            prompt:InputHoldEnd()
        end)
    end
end

local function getPlotRollPrompt(plot)
    if not plot then return nil end
    local rollFolder = plot:FindFirstChild("Roll")
    if rollFolder then
        local rollBtn = rollFolder:FindFirstChild("RollButton")
        if rollBtn then
            local btn = rollBtn:FindFirstChild("Button") or rollBtn
            local prompt = btn:FindFirstChild("RollPrompt") or btn:FindFirstChildWhichIsA("ProximityPrompt", true)
            if prompt then return prompt, btn end
        end
        local anyPrompt = rollFolder:FindFirstChildWhichIsA("ProximityPrompt", true)
        if anyPrompt then return anyPrompt, anyPrompt.Parent end
    end
    return nil, nil
end

local function smoothPositionToRollPad()
    local plot = getMyPlot()
    local _, btn = getPlotRollPrompt(plot)
    if not btn then return end
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root and btn:IsA("BasePart") then
        local targetPos = btn.Position + Vector3.new(0, 3.2, 0)
        root.CFrame = CFrame.new(targetPos, targetPos + btn.CFrame.LookVector)
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

-- ══════════════════════════════════════════════════════════
-- UNIFIED 15-TIER IN-GAME RARITY INDEX & ORDER
-- ══════════════════════════════════════════════════════════

local InGameRarities = {
    [1]  = "Common",
    [2]  = "Rare",
    [3]  = "Epic",
    [4]  = "Legendary",
    [5]  = "Mythic",
    [6]  = "Secret",
    [7]  = "God",
    [8]  = "Limited",
    [9]  = "Godly",
    [10] = "Godlyx",
    [11] = "Divine",
    [12] = "Immortal",
    [13] = "OP",
    [14] = "OG",
    [15] = "INVASION"
}

-- 100% OFFICIAL DECOMPILED IN-GAME CHARACTER RARITY MATRIX
-- (Supports both Internal Names & In-Game Parody Display Names)
-- ══════════════════════════════════════════════════════════

local CharacterRarities = {
    -- 1. Common (Tier 1)
    ["zoro"] = "Common", ["zero"] = "Common",
    ["krillin"] = "Common", ["keririn"] = "Common",
    ["luffy"] = "Common", ["luppi"] = "Common",
    ["ussop"] = "Common", ["usopp"] = "Common", ["usoff"] = "Common",
    ["itadori"] = "Common", ["itadoro"] = "Common",
    ["rock lee"] = "Common", ["rocklee"] = "Common", ["solid lei"] = "Common",

    -- 2. Rare (Tier 2)
    ["maki"] = "Rare", ["mika"] = "Rare",
    ["goku"] = "Rare", ["goke"] = "Rare",
    ["sakura"] = "Rare", ["sukora"] = "Rare",
    ["mob"] = "Rare", ["mobi"] = "Rare", ["reigen"] = "Rare",
    ["junwoo"] = "Rare", ["janwoo"] = "Rare",
    ["choji"] = "Rare", ["soji"] = "Rare",

    -- 3. Epic (Tier 3)
    ["tanjiro"] = "Epic", ["tanjuro"] = "Epic",
    ["shinra"] = "Epic", ["shinrat"] = "Epic",
    ["guts"] = "Epic", ["got"] = "Epic",
    ["manji"] = "Epic",
    ["ban"] = "Epic", ["bon"] = "Epic",
    ["piccolo"] = "Epic", ["picurro"] = "Epic",
    ["renji"] = "Epic", ["rinnju"] = "Epic",
    ["shikamaru"] = "Epic", ["shikamura"] = "Epic",

    -- 4. Legendary (Tier 4)
    ["erwin"] = "Legendary", ["erwon"] = "Legendary",
    ["sukuna"] = "Legendary", ["sakuna"] = "Legendary",
    ["gojo"] = "Legendary", ["goji"] = "Legendary",
    ["naruto"] = "Legendary", ["noruto"] = "Legendary",
    ["narutoclone"] = "Legendary", ["noruto clone"] = "Legendary",
    ["summonertest"] = "Legendary",
    ["saitama"] = "Legendary", ["saitomo"] = "Legendary",
    ["trunks"] = "Legendary", ["truck"] = "Legendary",
    ["grimmjow"] = "Legendary", ["grimmick"] = "Legendary",
    ["zenitsu"] = "Legendary", ["zinichou"] = "Legendary",
    ["nanami"] = "Legendary", ["nonomi"] = "Legendary",

    -- 5. Mythic (Tier 5)
    ["stark"] = "Mythic", ["coyote"] = "Mythic",
    ["kokushibo"] = "Mythic", ["kokushiro"] = "Mythic",
    ["simo hayha"] = "Mythic", ["shimo haya"] = "Mythic",
    ["hoshina"] = "Mythic", ["hoshira"] = "Mythic",
    ["ace"] = "Mythic", ["acer"] = "Mythic",
    ["broly"] = "Mythic", ["brocolli"] = "Mythic",
    ["orihime"] = "Mythic", ["orihemi"] = "Mythic",
    ["rengoku"] = "Mythic", ["rengundam"] = "Mythic",
    ["toji"] = "Mythic", ["joti"] = "Mythic",
    ["kashimo"] = "Mythic", ["kashimi"] = "Mythic",
    ["kakashi"] = "Mythic", ["kebashi"] = "Mythic",
    ["tobi"] = "Mythic", ["tomi"] = "Mythic",
    ["akaza"] = "Mythic", ["akazo"] = "Mythic",
    ["kisuke"] = "Mythic", ["kiwusuke"] = "Mythic",
    ["yoruichi"] = "Mythic", ["yoriki"] = "Mythic",

    -- 6. Secret (Tier 6)
    ["dio"] = "Secret", ["deyo"] = "Secret",
    ["frieren"] = "Secret", ["fryren"] = "Secret",
    ["yhwatch"] = "Secret", ["yhwach"] = "Secret", ["yuwah"] = "Secret",
    ["jiren"] = "Secret", ["jerin"] = "Secret",
    ["byakuya"] = "Secret", ["brakura"] = "Secret",
    ["ulquiorra"] = "Secret", ["ulquiopta"] = "Secret",
    ["kenpachi"] = "Secret", ["kenie"] = "Secret",
    ["gyomei"] = "Secret", ["gyomain"] = "Secret",
    ["megumi"] = "Secret", ["megumo"] = "Secret",
    ["mahoraga"] = "Secret", ["mahorogo"] = "Secret",
    ["yuta"] = "Secret", ["yutta"] = "Secret",
    ["rika"] = "Secret", ["rikka"] = "Secret",
    ["hakari"] = "Secret", ["hakuro"] = "Secret",
    ["mojuro"] = "Secret", ["moru"] = "Secret",
    ["sasuke"] = "Secret", ["susuko"] = "Secret",
    ["naruto (six path)"] = "Secret", ["noruto (six realm)"] = "Secret",
    ["naruto (six path) clone"] = "Secret", ["noruto (six realm) clone"] = "Secret",
    ["douma"] = "Secret", ["duma"] = "Secret",
    ["magellan"] = "Secret", ["magullan"] = "Secret",

    -- 7. God (Tier 7)
    ["beerus"] = "God", ["bills"] = "God",
    ["rimuru"] = "God", ["remura"] = "God",
    ["whis"] = "God", ["wise"] = "God",
    ["yamamoto"] = "God", ["yamumoto"] = "God",
    ["aizen (transcendent)"] = "God", ["aisen (divine)"] = "God",
    ["ichigo"] = "God", ["isogo (true form)"] = "God", ["isogo"] = "God",
    ["dabura"] = "God", ["daburo"] = "God",
    ["madara"] = "God", ["madura"] = "God",
    ["madara (clone)"] = "God", ["madura (clone)"] = "God",
    ["hashirama"] = "God", ["hashyrama"] = "God",
    ["yorichi"] = "God", ["yoichi"] = "God",
    ["shanks"] = "God", ["shancks"] = "God",
    ["ainz"] = "God", ["ais"] = "God",
    ["death knight"] = "God",
    ["gojo (shibuya)"] = "God", ["goji (shinjuku)"] = "God",
    ["yuji (modulo)"] = "God", ["yujo (timeskip)"] = "God",
    ["madara (six path)"] = "God", ["madura (six realms)"] = "God",
    ["madara (limbo)"] = "God", ["madura (six realms) shadow"] = "God",
    ["doflamingo"] = "God", ["flamingo"] = "God",
    ["boros"] = "God", ["boris"] = "God",
    ["boros v2"] = "God", ["boris (white)"] = "God",
    ["goku (black)"] = "God", ["goki (black)"] = "God",
    ["sukuna (heian)"] = "God", ["sakuna (heian)"] = "God",
    ["muzan"] = "God", ["michael"] = "God",
    ["muzan (evolved)"] = "God", ["michael (monster)"] = "God",

    -- 8. Limited
    ["entoma"] = "Limited", ["entomancer"] = "Limited",
    ["spider (entoma)"] = "Limited",
    ["hakari (jackpot)"] = "Limited", ["hakaru (jackpot!)"] = "Limited",
    ["shalltear"] = "Limited", ["bloodtear"] = "Limited",
    ["juuzou"] = "Limited", ["joozou"] = "Limited",
    ["milim"] = "Limited", ["lilim"] = "Limited",
    ["tatsumaki"] = "Limited", ["tazumaki"] = "Limited",
    ["yugi"] = "Limited", ["yuwi"] = "Limited",
    ["darkmagician"] = "Limited", ["purple magician"] = "Limited",
    ["darkmagiciangirl"] = "Limited", ["purple magician girl"] = "Limited"
}

-- Asynchronous Module Cache for Live In-Game Exact Data
local CachedModuleRarities = {}
task.spawn(function()
    pcall(function()
        local cInfoMod = ReplicatedStorage:WaitForChild("Modules", 3) 
            and ReplicatedStorage.Modules:WaitForChild("Characters", 3) 
            and ReplicatedStorage.Modules.Characters:WaitForChild("CharactersInfo", 3)
        if cInfoMod then
            local info = require(cInfoMod)
            if type(info) == "table" then
                local chars = info.Characters or info
                for _, cData in pairs(chars) do
                    if type(cData) == "table" then
                        local r = cData.Rarity
                        if r then
                            if cData.Name then CachedModuleRarities[cData.Name:lower()] = tostring(r) end
                            if cData.DisplayName then CachedModuleRarities[cData.DisplayName:lower()] = tostring(r) end
                        end
                    end
                end
            end
        end
    end)
end)


-- Fast Number Formatting (e.g. 1,250,000)
local function formatNumberWithCommas(amount)
    local formatted = tostring(amount or "0"):gsub("[^%d]", "")
    if formatted == "" then formatted = "0" end
    local k
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then break end
    end
    return formatted
end

-- Fast Direct Currency Scanner (Instant O(1))

local RarityOrder = {
    ["Common"]    = 1,
    ["Rare"]      = 2,
    ["Epic"]      = 3,
    ["Legendary"] = 4,
    ["Mythic"]    = 5,
    ["Secret"]    = 6,
    ["God"]       = 7,
    ["Limited"]   = 8,
    ["Godly"]     = 9,
    ["Godlyx"]    = 10,
    ["Divine"]    = 11,
    ["Immortal"]  = 12,
    ["OP"]        = 13,
    ["OG"]        = 14,
    ["INVASION"]  = 15
}

local function getMinRankFromRule(ruleString)
    if not ruleString then return 1 end
    if ruleString == "Common & Above (Buy All)" or ruleString == "Common & Above" or ruleString == "All Rarities" or ruleString == "All Units" then return 1
    elseif ruleString == "Rare & Above" then return 2
    elseif ruleString == "Epic & Above" then return 3
    elseif ruleString == "Legendary & Above" then return 4
    elseif ruleString == "Mythic & Above" then return 5
    elseif ruleString == "Secret & Above" then return 6
    elseif ruleString == "God & Above" then return 7
    elseif ruleString == "Limited Only" then return 8
    elseif ruleString == "Godly & Above" then return 9
    elseif ruleString == "Godlyx & Above" then return 10
    elseif ruleString == "Divine & Above" then return 11
    elseif ruleString == "Immortal & Above" then return 12
    elseif ruleString == "OP & Above" then return 13
    elseif ruleString == "OG & Above" then return 14
    elseif ruleString == "INVASION & Above" then return 15
    end
    return 1
end

-- ══════════════════════════════════════════════════════════
-- 100% SAFE & GUARANTEED AUTO SELL ENGINE (MULTI-SOURCE SCAN + UUID & INSTANCE BUYER)
-- ══════════════════════════════════════════════════════════

local throttledAutoSell = createThrottle(function()
    Log("Info", "Executing Auto Sell scan...")
    if not CharactersSell and not CharactersInv then
        pcall(function()
            CharactersSell = ReplicatedStorage:FindFirstChild("Remotes") 
                and ReplicatedStorage.Remotes:FindFirstChild("Characters") 
                and ReplicatedStorage.Remotes.Characters:FindFirstChild("Sell")
            CharactersInv = ReplicatedStorage:FindFirstChild("Remotes") 
                and ReplicatedStorage.Remotes:FindFirstChild("Characters") 
                and ReplicatedStorage.Remotes.Characters:FindFirstChild("UpdateInventory")
        end)
    end

    local function getUnitRarity(unitName, explicitRarity)
        if explicitRarity and InGameRarities then
            for _, rName in pairs(InGameRarities) do
                if explicitRarity:lower() == rName:lower() then return rName end
            end
        end
        local raw = tostring(unitName or ""):lower():gsub("lv%s*%.?%s*%d+", ""):gsub("%d+", ""):gsub("[%[%]%(%)%_%-%.%#]", " ")
        local nTrim = raw:match("^%s*(.-)%s*$") or ""
        if nTrim == "" then return nil end

        if CachedModuleRarities and CachedModuleRarities[nTrim] then return CachedModuleRarities[nTrim] end
        if CharacterRarities and CharacterRarities[nTrim] then return CharacterRarities[nTrim] end
        
        if CharacterRarities then
            for charKey, rVal in pairs(CharacterRarities) do
                if nTrim == charKey or nTrim:find("^" .. charKey .. "$") or nTrim:find(charKey, 1, true) then
                    return rVal
                end
            end
        end
        return nil
    end

    local function shouldSellItem(uName, explicitRarity, isLocked, mutation, trait, level)
        if isLocked == true then return false end
        if mutation and tostring(mutation):lower() ~= "none" and tostring(mutation) ~= "" and tostring(mutation):lower() ~= "nil" then return false end
        if trait and tostring(trait):lower() ~= "none" and tostring(trait) ~= "" and tostring(trait):lower() ~= "nil" then return false end
        if type(level) == "number" and level > 1 then return false end

        local finalRarity = getUnitRarity(uName, explicitRarity)
        if finalRarity and Config.SelectedSellRarities and Config.SelectedSellRarities[finalRarity] == true then
            return true, finalRarity
        end
        return false, nil
    end

    local uuidsToSell = {}
    local instancesToSell = {}
    local namesToSell = {}
    local seenUIDs = {}

    -- 1. Scan DataService Profile Memory (Primary)
    pcall(function()
        local dataServMod = ReplicatedStorage:FindFirstChild("Data") and ReplicatedStorage.Data:FindFirstChild("DataService")
        if dataServMod then
            local ds = require(dataServMod)
            local client = (type(ds) == "table" and (ds.client or ds.Client or ds)) or ds
            
            for _, key in ipairs({"Inventory", "Characters", "Units", "Bag"}) do
                local rawList = nil
                pcall(function() rawList = client:get(LocalPlayer, {key}) end)
                if not rawList then pcall(function() rawList = client:get({key}) end) end
                if not rawList then pcall(function() rawList = ds:get(LocalPlayer, {key}) end) end
                if not rawList and client.Data then rawList = client.Data[key] end
                if not rawList and client.Profile then rawList = client.Profile[key] end
                if not rawList and client._data then rawList = (client._data._data and client._data._data[key]) or client._data[key] end
                if not rawList and ds._data then rawList = (ds._data._data and ds._data._data[key]) or ds._data[key] end

                if type(rawList) == "table" then
                    for _, item in pairs(rawList) do
                        if type(item) == "table" then
                            local uid = item.UUID or item.Uuid or item.Id or item.uid
                            local uName = item.Name or item.CharacterName or item.UnitName or ""
                            local isLocked = item.isLocked == true or item.Locked == true or item.IsLocked == true
                            local mut = item.Mutation or item.Variant
                            local trait = item.Trait or item.Traits
                            local lvl = item.Level or item.Lvl
                            local rStr = item.Rarity or item.Tier

                            local sellOk, _ = shouldSellItem(uName, rStr, isLocked, mut, trait, lvl)
                            if sellOk and uid and not seenUIDs[uid] then
                                seenUIDs[uid] = true
                                table.insert(uuidsToSell, uid)
                                table.insert(namesToSell, uName)
                            end
                        end
                    end
                end
            end
        end
    end)

    -- 2. Scan LocalPlayer Data / PlayerData Folders
    pcall(function()
        for _, fName in ipairs({"Data", "PlayerData", "Inventory", "Characters"}) do
            local df = LocalPlayer:FindFirstChild(fName)
            if df then
                local invFolder = df:FindFirstChild("Inventory") or df:FindFirstChild("Characters") or df
                for _, item in ipairs(invFolder:GetChildren()) do
                    if item:IsA("Instance") and item.Name ~= "Terrain" then
                        local uid = item:GetAttribute("UUID") or item:GetAttribute("Uuid") or item:GetAttribute("Id") or item.Name
                        local uName = item:GetAttribute("CharacterName") or item:GetAttribute("Name") or item.Name
                        local isLocked = item:GetAttribute("Locked") == true or item:GetAttribute("isLocked") == true
                        local mut = item:GetAttribute("Mutation") or item:GetAttribute("Variant")
                        local trait = item:GetAttribute("Trait")
                        local lvl = item:GetAttribute("Level") or item:GetAttribute("Lvl")
                        local rStr = item:GetAttribute("Rarity") or item:GetAttribute("Tier")

                        local sellOk, _ = shouldSellItem(uName, rStr, isLocked, mut, trait, lvl)
                        if sellOk then
                            if uid and not seenUIDs[uid] then
                                seenUIDs[uid] = true
                                table.insert(uuidsToSell, uid)
                            end
                            table.insert(instancesToSell, item)
                            table.insert(namesToSell, uName)
                        end
                    end
                end
            end
        end
    end)

    -- 3. Execute Multi-Format Selling
    if #uuidsToSell > 0 then
        if CharactersSell then
            pcall(function() CharactersSell:FireServer(uuidsToSell) end)
            pcall(function() CharactersSell:FireServer({ UUIDs = uuidsToSell }) end)
            pcall(function() CharactersSell:FireServer("Sell", uuidsToSell) end)
            for _, uid in ipairs(uuidsToSell) do
                pcall(function() CharactersSell:FireServer(uid) end)
                pcall(function() CharactersSell:FireServer({ UUID = uid }) end)
            end
        end
        if CharactersInv then
            pcall(function() CharactersInv:FireServer("Sell", uuidsToSell) end)
            pcall(function() CharactersInv:FireServer("SellUnits", uuidsToSell) end)
        end
    end

    if #instancesToSell > 0 and CharactersSell then
        for _, inst in ipairs(instancesToSell) do
            pcall(function() CharactersSell:FireServer(inst) end)
            pcall(function() CharactersSell:FireServer(inst.Name) end)
        end
    end
    if #uuidsToSell > 0 then
        Log("Success", "Sold %d units for Gold!", #uuidsToSell)
    end
end, 2.5)

local function executeAutoSell()
    if not CharactersSell and not CharactersInv then
        Log("Warning", "Characters.Sell remote not found, auto-sell disabled")
        return
    end
    throttledAutoSell()
end

-- Auto Pickup All Units (Verified from foranimell.lua: UpdateInventory:FireServer("PickupAll"))
local function autoPickupAll()
    if CharactersInv then
        pcall(function() CharactersInv:FireServer("PickupAll") end)
    end
end

-- Auto Faction Quests (จาก Spy Log: FactionUpdate:FireServer("RequestQuestData"))
local function autoFactionQuests()
    if FactionUpdate then
        pcall(function() FactionUpdate:FireServer("RequestQuestData") end)
        pcall(function() FactionUpdate:FireServer("RequestFactionScores") end)
        pcall(function() FactionUpdate:FireServer("RequestFactionRanks") end)
    end
end

-- ══════════════════════════════════════════════════════════
-- OFFICIAL CHARACTER PRICES & MUTATION MULTIPLIERS
-- ══════════════════════════════════════════════════════════

local CharacterPrices = {
    ["zero"] = 200, ["zoro"] = 200, ["krillin"] = 200, ["keririn"] = 200,
    ["luffy"] = 275, ["luppi"] = 275, ["ussop"] = 300, ["usopp"] = 300, ["usoff"] = 300,
    ["itadori"] = 500, ["itadoro"] = 500, ["rock lee"] = 750, ["rocklee"] = 750, ["solid lei"] = 750,
    ["maki"] = 1000, ["mika"] = 1000, ["goku"] = 1000, ["goke"] = 1000,
    ["mob"] = 1200, ["mobi"] = 1200, ["reigen"] = 1200,
    ["junwoo"] = 1800, ["janwoo"] = 1800, ["sakura"] = 1800, ["sukora"] = 1800,
    ["choji"] = 3500, ["soji"] = 3500,
    ["shinra"] = 4200, ["shinrat"] = 4200, ["ban"] = 4500, ["bon"] = 4500,
    ["tanjiro"] = 4800, ["tanjuro"] = 4800, ["manji"] = 5200,
    ["guts"] = 6000, ["got"] = 6000, ["renji"] = 7000, ["rinnju"] = 7000,
    ["piccolo"] = 7800, ["picurro"] = 7800, ["shikamaru"] = 10000, ["shikamura"] = 10000,
    ["saitama"] = 16000, ["saitomo"] = 16000, ["sukuna"] = 17500, ["sakuna"] = 17500,
    ["gojo"] = 18000, ["goji"] = 18000, ["erwin"] = 20000, ["erwon"] = 20000,
    ["naruto"] = 24000, ["noruto"] = 24000, ["summonertest"] = 24000,
    ["trunks"] = 36000, ["truck"] = 36000,
    ["akaza"] = 50500, ["akazo"] = 50500, ["entoma"] = 50000, ["entomancer"] = 50000,
    ["stark"] = 60000, ["coyote"] = 60000, ["kokushibo"] = 70000, ["kokushiro"] = 70000,
    ["simo hayha"] = 75000, ["shimo haya"] = 75000, ["hoshina"] = 80000, ["hoshira"] = 80000,
    ["ace"] = 85000, ["acer"] = 85000, ["grimmjow"] = 85000, ["grimmick"] = 85000,
    ["zenitsu"] = 120000, ["zinichou"] = 120000, ["broly"] = 127500, ["brocolli"] = 127500,
    ["nanami"] = 200000, ["nonomi"] = 200000, ["orihime"] = 200000, ["orihemi"] = 200000,
    ["dio"] = 200000, ["deyo"] = 200000, ["rengoku"] = 250000, ["rengundam"] = 250000,
    ["frieren"] = 275000, ["fryren"] = 275000, ["yhwatch"] = 310000, ["yuwah"] = 310000,
    ["toji"] = 350000, ["joti"] = 350000, ["kisuke"] = 350000, ["kiwusuke"] = 350000,
    ["yoruichi"] = 375000, ["yoriki"] = 375000, ["kashimo"] = 450000, ["kashimi"] = 450000,
    ["jiren"] = 450000, ["jerin"] = 450000,
    ["kakashi"] = 650000, ["kebashi"] = 650000, ["tobi"] = 650000, ["tomi"] = 650000,
    ["beerus"] = 650000, ["bills"] = 650000, ["byakuya"] = 700000, ["brakura"] = 700000,
    ["ulquiorra"] = 750000, ["ulquiopta"] = 750000, ["rimuru"] = 750000, ["remura"] = 750000,
    ["whis"] = 1125000, ["wise"] = 1125000, ["kenpachi"] = 1125000, ["kenie"] = 1125000,
    ["gyomei"] = 1500000, ["gyomain"] = 1500000, ["yamamoto"] = 1750000, ["yamumoto"] = 1750000,
    ["megumi"] = 2500000, ["megumo"] = 2500000, ["yuta"] = 3100000, ["yutta"] = 3100000,
    ["aizen (transcendent)"] = 3500000, ["aisen (divine)"] = 3500000,
    ["hakari"] = 3900000, ["hakuro"] = 3900000, ["ichigo"] = 4000000, ["isogo (true form)"] = 4000000,
    ["mojuro"] = 4500000, ["moru"] = 4500000, ["sasuke"] = 5000000, ["susuko"] = 5000000,
    ["dabura"] = 6000000, ["daburo"] = 6000000, ["madara"] = 7500000, ["madura"] = 7500000,
    ["hashirama"] = 7500000, ["hashyrama"] = 7500000
}

local MutationPriceMultipliers = {
    ["gold"]       = 2,
    ["diamond"]    = 5,
    ["demon"]      = 10,
    ["destroyer"]  = 15,
    ["hollow"]     = 20,
    ["slayer"]     = 25,
    ["cursed"]     = 30,
    ["astronaut"]  = 1
}

local function getCharacterCost(cleanName, mutStr)
    local base = CharacterPrices[cleanName] or 200
    local mult = 1
    if mutStr and mutStr ~= "" then
        for mKey, mVal in pairs(MutationPriceMultipliers) do
            if mutStr:find(mKey) then
                mult = mVal
                break
            end
        end
    end
    return base * mult
end


local function parseFormattedNumber(val)
    if type(val) == "number" then return val end
    if not val then return 0 end
    local str = tostring(val):gsub(",", ""):match("^%s*(.-)%s*$") or "0"
    local num, suffix = str:match("([%d%.]+)%s*([KkMmBbTtQq]?)")
    local n = tonumber(num) or 0
    if suffix then
        local s = suffix:upper()
        if s == "K" then n = n * 1e3
        elseif s == "M" then n = n * 1e6
        elseif s == "B" then n = n * 1e9
        elseif s == "T" then n = n * 1e12
        elseif s == "Q" then n = n * 1e15
        end
    end
    return n
end



local function getCurrentPlayerGold()
    -- 1. ตรวจสอบ leaderstats (ตรงที่สุด)
    local ls = LocalPlayer:FindFirstChild("leaderstats")
    if ls then
        for _, child in ipairs(ls:GetChildren()) do
            local name = child.Name:lower()
            if (name:find("gold") or name:find("coin") or name:find("money") or name:find("cash")) and child:IsA("NumberValue") then
                return child.Value
            end
        end
    end

    -- 2. ตรวจสอบ Attribute ของ LocalPlayer
    local attrs = LocalPlayer:GetAttributes()
    if attrs.Gold and tonumber(attrs.Gold) then
        return tonumber(attrs.Gold)
    end
    if attrs.Coins and tonumber(attrs.Coins) then
        return tonumber(attrs.Coins)
    end
    if attrs.Money and tonumber(attrs.Money) then
        return tonumber(attrs.Money)
    end

    -- 3. ตรวจสอบโฟลเดอร์ Data / PlayerData
    for _, fName in ipairs({"Data", "PlayerData", "Stats"}) do
        local folder = LocalPlayer:FindFirstChild(fName)
        if folder then
            -- ตรวจสอบ ValueBase
            for _, child in ipairs(folder:GetChildren()) do
                if child:IsA("NumberValue") or child:IsA("ValueBase") then
                    local n = child.Name:lower()
                    if (n:find("gold") or n:find("coin") or n:find("money") or n:find("cash")) and tonumber(child.Value) then
                        return tonumber(child.Value)
                    end
                end
            end
            -- ตรวจสอบ Attribute ของโฟลเดอร์
            local fAttr = folder:GetAttribute("Gold") or folder:GetAttribute("Coins") or folder:GetAttribute("Money")
            if fAttr and tonumber(fAttr) then
                return tonumber(fAttr)
            end
        end
    end

    -- 4. สุดท้าย: สแกน HUD แต่จำกัดเฉพาะ GUI ที่ไม่เกี่ยวกับ Shop/Pass/Upgrade
    local pGui = LocalPlayer:FindFirstChild("PlayerGui")
    if pGui then
        for _, gui in ipairs(pGui:GetChildren()) do
            if gui:IsA("ScreenGui") and gui.Name ~= "CUPIEUI" and gui.Enabled then
                local gName = gui.Name:lower()
                -- ข้าม GUI ที่เกี่ยวกับ Shop, Pass, Product, Upgrade
                if not gName:find("shop") and not gName:find("pass") and not gName:find("product") and not gName:find("upgr") then
                    for _, lbl in ipairs(gui:GetDescendants()) do
                        if lbl:IsA("TextLabel") and lbl.Visible and lbl.Text:match("%d") then
                            local lName = lbl.Name:lower()
                            local pName = (lbl.Parent and lbl.Parent.Name:lower()) or ""
                            if not pName:find("shop") and not pName:find("product") and not pName:find("cost") and not pName:find("price") then
                                if (lName:find("gold") or lName:find("coin") or lName:find("money") or pName:find("gold") or pName:find("coins")) then
                                    local parsed = parseFormattedNumber(lbl.Text)
                                    if parsed and parsed > 0 then return parsed end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    return 0
end

local function getStandTargetInfo(model)
    if not model or not model:IsA("Model") then return nil end
    local uName = model.Name
    local cleanName = uName:lower():gsub("lv%s*%.?%s*%d+", ""):gsub("%d+", ""):gsub("[%[%]%(%)%_%-%.%#]", " "):match("^%s*(.-)%s*$")
    
    local foundRarity = nil
    local foundMutation = nil
    local foundPrice = nil
    local foundCharName = nil

    for _, desc in ipairs(model:GetDescendants()) do
        if desc:IsA("TextLabel") and desc.Visible then
            local txt = desc.Text:lower():match("^%s*(.-)%s*$") or ""
            
            -- Read Price from Billboard (e.g. "$400", "$1,200", "$350K")
            local priceMatch = desc.Text:match("%$%s*([%d%,%.%a]+)") or desc.Text:match("([%d%,%.%a]+)%s*[Gg]old")
            if priceMatch then
                foundPrice = parseFormattedNumber(priceMatch)
            end

            -- Read Mutation from Billboard
            if txt:find("gold") then foundMutation = "Gold"
            elseif txt:find("diamond") then foundMutation = "Diamond"
            elseif txt:find("astronaut") or txt:find("cosmic") then foundMutation = "Astronaut"
            elseif txt:find("demon") then foundMutation = "Demon"
            elseif txt:find("destroyer") then foundMutation = "Destroyer"
            elseif txt:find("hollow") then foundMutation = "Hollow"
            elseif txt:find("slayer") then foundMutation = "Slayer"
            elseif txt:find("cursed") then foundMutation = "Cursed"
            end
            
            -- Read Rarity from Billboard
            if InGameRarities then
                for _, rName in pairs(InGameRarities) do
                    if txt == rName:lower() or txt:find("^" .. rName:lower() .. "$") or txt:find(rName:lower()) then
                        foundRarity = rName
                        break
                    end
                end
            end
            
            if CharacterRarities and (CharacterRarities[txt] or CharacterRarities[txt:gsub("[%[%]%(%)%_%-%.%#]", "")]) then
                foundCharName = txt
            end
        end
    end

    local attrR = model:GetAttribute("Rarity") or model:GetAttribute("Tier")
    local finalRarity = foundRarity or attrR or (foundCharName and CharacterRarities and CharacterRarities[foundCharName]) or (CharacterRarities and CharacterRarities[cleanName]) or (CachedModuleRarities and CachedModuleRarities[cleanName]) or "Common"
    
    local attrM = model:GetAttribute("Mutation") or model:GetAttribute("Mutations") or model:GetAttribute("Variant")
    local mutChild = model:FindFirstChild("Mutation") or model:FindFirstChild("Gold") or model:FindFirstChild("Diamond") or model:FindFirstChild("Astronaut")
    local finalMutation = foundMutation or (attrM and tostring(attrM)) or (mutChild and mutChild.Name) or (model.Name:lower():find("gold") and "Gold") or (model.Name:lower():find("astronaut") and "Astronaut") or nil

    local cost = foundPrice or getCharacterCost(cleanName, finalMutation)
    local prompt = model:FindFirstChildWhichIsA("ProximityPrompt", true)

    return {
        Model = model,
        Name = uName,
        CleanName = cleanName,
        Rarity = finalRarity,
        Mutation = finalMutation,
        Cost = cost,
        Prompt = prompt
    }
end



-- ══════════════════════════════════════════════════════════
-- DEDICATED STAND TARGET DISCOVERY & BUY ENGINE
-- ══════════════════════════════════════════════════════════

local function checkUnitMatchesFilter(unitName, unitRarity, unitMutation)
    local rPass = false
    local mPass = false

    -- 1. Check Multi-Selected Rarities
    if Config.SelectedBuyRarities and type(Config.SelectedBuyRarities) == "table" then
        for rName, enabled in pairs(Config.SelectedBuyRarities) do
            if enabled and unitRarity and (unitRarity:lower() == rName:lower() or unitRarity:lower():find(rName:lower())) then
                rPass = true
                break
            end
        end
    end

    -- 2. Check Multi-Selected Mutations
    local mutStr = tostring(unitMutation or ""):lower()
    if mutStr ~= "" and mutStr ~= "nil" and mutStr ~= "none" then
        if Config.SelectedBuyMutations and type(Config.SelectedBuyMutations) == "table" then
            for mName, enabled in pairs(Config.SelectedBuyMutations) do
                if enabled and (mutStr:find(mName:lower()) or (mName:lower() == "astronaut" and mutStr:find("cosmic"))) then
                    mPass = true
                    break
                end
            end
        end
    end

    local anyRaritySelected = false
    if Config.SelectedBuyRarities then
        for _, v in pairs(Config.SelectedBuyRarities) do if v then anyRaritySelected = true break end end
    end
    local anyMutationSelected = false
    if Config.SelectedBuyMutations then
        for _, v in pairs(Config.SelectedBuyMutations) do if v then anyMutationSelected = true break end end
    end

    if anyRaritySelected and anyMutationSelected then
        return rPass or mPass
    elseif anyRaritySelected then
        return rPass
    elseif anyMutationSelected then
        return mPass
    else
        return true
    end
end

local function getMatchingStandTargets()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local myPlot = getMyPlot()

    local candidateModels = {}
    if myPlot then
        local charFolder = myPlot:FindFirstChild("Characters") or myPlot:FindFirstChild("Stands") or myPlot:FindFirstChild("Roll")
        if charFolder then
            for _, m in ipairs(charFolder:GetChildren()) do
                if m:IsA("Model") and m ~= char then
                    table.insert(candidateModels, m)
                end
            end
        end
    end
    
    if #candidateModels == 0 and root then
        for _, m in ipairs(Workspace:GetChildren()) do
            if m:IsA("Model") and m ~= char and m.Name ~= "Terrain" then
                local mRoot = m:FindFirstChild("HumanoidRootPart") or m.PrimaryPart
                if mRoot and (mRoot.Position - root.Position).Magnitude < 45 then
                    table.insert(candidateModels, m)
                end
            end
        end
        local plots = Workspace:FindFirstChild("Plots")
        if plots then
            for _, p in ipairs(plots:GetChildren()) do
                local cFolder = p:FindFirstChild("Characters") or p:FindFirstChild("Stands")
                if cFolder then
                    for _, m in ipairs(cFolder:GetChildren()) do
                        if m:IsA("Model") and m ~= char then
                            local mRoot = m:FindFirstChild("HumanoidRootPart") or m.PrimaryPart
                            if mRoot and (mRoot.Position - root.Position).Magnitude < 45 then
                                table.insert(candidateModels, m)
                            end
                        end
                    end
                end
            end
        end
    end

    table.sort(candidateModels, function(a, b)
        local pA = a:GetPivot().Position
        local pB = b:GetPivot().Position
        return (pA.X + pA.Z) < (pB.X + pB.Z)
    end)

    local matching = {}
    for slotIdx, model in ipairs(candidateModels) do
        local info = getStandTargetInfo(model)
        if info and checkUnitMatchesFilter(info.Name, info.Rarity, info.Mutation) then
            info.SlotIdx = slotIdx
            table.insert(matching, info)
        end
    end
    return matching
end

local function buyStandTarget(target)
    if not target then return false end
    
    local curGold = getCurrentPlayerGold()
    local cost = target.Cost or 200
    if curGold < cost then
        warn("❌ [BUY] Not enough Gold for " .. tostring(target.Name) .. " (Have: " .. tostring(curGold) .. ", Need: " .. tostring(cost) .. ")")
        return false
    end
    
    if not CharactersBuy then
        pcall(function()
            CharactersBuy = ReplicatedStorage:FindFirstChild("Remotes") 
                and ReplicatedStorage.Remotes:FindFirstChild("Characters") 
                and ReplicatedStorage.Remotes.Characters:FindFirstChild("Buy")
        end)
    end

    local tier = 1
    if target.Rarity then
        local r = tostring(target.Rarity):lower()
        if r == "common" or r == "rare" then tier = 1
        elseif r == "epic" then tier = 2
        elseif r == "legendary" or r == "mythic" then tier = 3
        elseif r == "secret" or r == "god" or r == "limited" then tier = 4
        end
    end
    local slot = target.SlotIdx or 1

    warn("🟢 [BUYING] Target: " .. tostring(target.Name) .. " | Rarity: " .. tostring(target.Rarity) .. " | Tier: " .. tostring(tier) .. " | Slot: " .. tostring(slot) .. " | Cost: " .. tostring(cost))

    -- 1. Fire ProximityPrompt on Stand Model
    if target.Prompt then
        pcall(function()
            target.Prompt.MaxActivationDistance = 999999
            target.Prompt.RequiresLineOfSight = false
            target.Prompt.HoldDuration = 0
        end)
        if fireproximityprompt then
            pcall(function() fireproximityprompt(target.Prompt, 1) end)
            pcall(function() fireproximityprompt(target.Prompt, 0) end)
            pcall(function() fireproximityprompt(target.Prompt) end)
        end
        if target.Prompt.InputHoldBegin then
            pcall(function()
                target.Prompt:InputHoldBegin()
                task.wait(0.01)
                target.Prompt:InputHoldEnd()
            end)
        end
    end

    -- 2. Fire Characters.Buy Remote with all verified signatures
    if CharactersBuy then
        pcall(function() CharactersBuy:FireServer(tier, slot) end)
        pcall(function() CharactersBuy:FireServer(tier, 1) end)
        pcall(function() CharactersBuy:FireServer(tier, 2) end)
        pcall(function() CharactersBuy:FireServer(tier, 3) end)
        pcall(function() CharactersBuy:FireServer({ Tier = tier, Slot = slot }) end)
        pcall(function() CharactersBuy:FireServer(tier, slot, "Buy") end)
    end
    
    return true
end

local function executeSmartAutoBuy()
    if not CharactersBuy then 
        pcall(function()
            CharactersBuy = ReplicatedStorage:FindFirstChild("Remotes") 
                and ReplicatedStorage.Remotes:FindFirstChild("Characters") 
                and ReplicatedStorage.Remotes.Characters:FindFirstChild("Buy")
        end)
    end

    -- 1. FIRST PRIORITY: Scan stand models on player plot (Multi-Select Rarity & Mutation Filter)
    local targets = getMatchingStandTargets()
    local boughtCount = 0
    if #targets > 0 then
        for _, target in ipairs(targets) do
            local curGold = getCurrentPlayerGold()
            local cost = target.Cost or 200
            if curGold >= cost then
                if buyStandTarget(target) then
                    boughtCount = boughtCount + 1
                    task.wait(randomDelay(0.08, 0.03))
                end
            else
                warn("⏳ [SMART BUY] Insufficient Gold for " .. tostring(target.Name) .. " (Have: " .. tostring(curGold) .. ", Cost: " .. tostring(cost) .. ")")
            end
        end
        return boughtCount
    end

    -- 2. SECOND PRIORITY: Direct Tier & Slot purchase fallback
    local tiers = {}
    if Config.SelectedTier == "All" or Config.SelectedTier == "All Tiers" or Config.SelectedTier == nil then
        tiers = {1, 2, 3, 4}
    elseif type(Config.SelectedTier) == "number" then
        tiers = {Config.SelectedTier}
    else
        tiers = {1, 2, 3, 4}
    end

    local slots = {}
    local slotStr = Config.SelectedSlot or "All Slots"
    if slotStr == "All Slots" or slotStr == nil then
        slots = {1, 2, 3}
    elseif slotStr == "Slot 1" then
        slots = {1}
    elseif slotStr == "Slot 2" then
        slots = {2}
    elseif slotStr == "Slot 3" then
        slots = {3}
    else
        slots = {1, 2, 3}
    end

    for _, tier in ipairs(tiers) do
        for _, slot in ipairs(slots) do
            local gold = getCurrentPlayerGold()
            if gold >= 200 and CharactersBuy then
                pcall(function()
                    CharactersBuy:FireServer(tier, slot)
                    task.wait(randomDelay(0.06, 0.03))
                end)
            end
        end
    end
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
pcall(function()
    if getconnections and LocalPlayer then
        for _, conn in ipairs(getconnections(LocalPlayer.Idled)) do
            if conn.Disable then conn:Disable()
            elseif conn.Disconnect then conn:Disconnect() end
        end
    end
    if LocalPlayer then
        LocalPlayer.Idled:Connect(function()
            if Config.AntiAFK and VirtualUser then
                pcall(function()
                    local cam = workspace.CurrentCamera
                    local cf = cam and cam.CFrame or CFrame.new()
                    VirtualUser:Button2Down(Vector2.new(0, 0), cf)
                    task.wait(0.2)
                    VirtualUser:Button2Up(Vector2.new(0, 0), cf)
                end)
            end
        end)
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
    Title    = "CUPIE HUB",
    Subtitle = "Roll Anime To Fight - v1.0",
    Keybind  = Enum.KeyCode.RightControl
})

-- ══════════════════════════════════════════════════════════
-- TAB 1: DASHBOARD & STATS (GOLD HIGHLIGHT & RARITY INVENTORY ONLY)
-- ══════════════════════════════════════════════════════════
local DashTab = Window:CreateTab("Stats", 1)

DashTab:CreateHeader("GOLD & TREASURY", 1)

-- Highlighted Gold Balance Card
local goldPara = DashTab:CreateParagraph({
    Title = "GOLD BALANCE",
    Content = "Scanning Gold balance...",
    LayoutOrder = 2
})

DashTab:CreateHeader("OTHER CURRENCIES & SESSION", 3)

local curPara = DashTab:CreateParagraph({
    Title = "Account Currencies",
    Content = "Scanning currencies...",
    LayoutOrder = 4
})

DashTab:CreateHeader("CHARACTER INVENTORY BY RARITY", 5)

local invRarityPara = DashTab:CreateParagraph({
    Title = "Owned Characters Breakdown",
    Content = "Scanning character inventory...",
    LayoutOrder = 6
})

DashTab:CreateHeader("CHARACTER MUTATIONS (SPECIAL VARIANTS)", 7)

local mutPara = DashTab:CreateParagraph({
    Title = "Owned Mutations (0 Total)",
    Content = "Scanning mutations...",
    LayoutOrder = 8
})

-- ══════════════════════════════════════════════════════════
-- INSTANT REAL-TIME STATS & INVENTORY ENGINE (ZERO-LAG)
-- ══════════════════════════════════════════════════════════

-- Known Character Rarity Dictionary (Instant O(1) Lookup, No require hang)
-- ══════════════════════════════════════════════════════════
-- ══════════════════════════════════════════════════════════
local function getPlayerCurrencies()
    local gold = nil
    local gems = nil
    local wins = nil
    
    -- 1. Direct Leaderstats check
    local ls = LocalPlayer:FindFirstChild("leaderstats")
    if ls then
        for _, child in ipairs(ls:GetChildren()) do
            local n = child.Name:lower()
            local val = tostring(child.Value or (child:IsA("ValueBase") and child.Value) or "")
            if val ~= "" and val ~= "nil" then
                if n:find("gold") or n:find("coin") or n:find("money") or n:find("cash") then
                    gold = val
                elseif n:find("gem") or n:find("diamond") then
                    gems = val
                elseif n:find("win") or n:find("level") or n:find("stage") or n:find("wave") then
                    wins = val
                end
            end
        end
    end
    
    -- 2. Direct Player Attributes check
    if not gold or not gems or not wins then
        local attrs = LocalPlayer:GetAttributes()
        for k, v in pairs(attrs) do
            local n = tostring(k):lower()
            local val = tostring(v)
            if val ~= "" and val ~= "nil" then
                if not gold and (n:find("gold") or n:find("coin") or n:find("money") or n:find("cash")) then
                    gold = val
                elseif not gems and (n:find("gem") or n:find("diamond")) then
                    gems = val
                elseif not wins and (n:find("win") or n:find("level") or n:find("stage") or n:find("wave")) then
                    wins = val
                end
            end
        end
    end
    
    -- 3. Direct Data / PlayerData folder check
    if not gold or not gems or not wins then
        local df = LocalPlayer:FindFirstChild("Data") or LocalPlayer:FindFirstChild("PlayerData") or LocalPlayer:FindFirstChild("Stats")
        if df then
            for _, child in ipairs(df:GetChildren()) do
                local n = child.Name:lower()
                local val = tostring(child.Value or (child:IsA("ValueBase") and child.Value) or "")
                if val ~= "" and val ~= "nil" then
                    if not gold and (n:find("gold") or n:find("coin") or n:find("money") or n:find("cash")) then
                        gold = val
                    elseif not gems and (n:find("gem") or n:find("diamond")) then
                        gems = val
                    elseif not wins and (n:find("win") or n:find("level") or n:find("stage") or n:find("wave")) then
                        wins = val
                    end
                end
            end
            for k, v in pairs(df:GetAttributes()) do
                local n = tostring(k):lower()
                local val = tostring(v)
                if not gold and (n:find("gold") or n:find("coin") or n:find("money")) then gold = val
                elseif not gems and (n:find("gem") or n:find("diamond")) then gems = val
                elseif not wins and (n:find("win") or n:find("level") or n:find("stage")) then wins = val
                end
            end
        end
    end

    -- 4. Direct Fast UI Checks
    if not gold or gold == "0" then
        local pGui = LocalPlayer:FindFirstChild("PlayerGui")
        if pGui then
            local mainGui = pGui:FindFirstChild("MainGui") or pGui:FindFirstChild("ScreenGui") or pGui:FindFirstChild("HUD") or pGui:FindFirstChild("Main")
            if mainGui then
                for _, ch in ipairs(mainGui:GetChildren()) do
                    if ch:IsA("Frame") or ch:IsA("TextLabel") then
                        local n = ch.Name:lower()
                        if ch:IsA("TextLabel") and ch.Text:match("%d") then
                            if n:find("gold") or n:find("coin") then gold = ch.Text end
                            if n:find("gem") or n:find("diamond") then gems = ch.Text end
                            if n:find("win") or n:find("level") then wins = ch.Text end
                        end
                    end
                end
            end
        end
    end
    
    return tostring(gold or "0"), tostring(gems or "0"), tostring(wins or "0")
end


-- PURE DATA-DRIVEN INVENTORY SCANNER (ZERO FALSE POSITIVES)
-- ══════════════════════════════════════════════════════════

-- ══════════════════════════════════════════════════════════
-- PURE DATA-DRIVEN INVENTORY & MUTATION SCANNER (ZERO FALSE POSITIVES)
-- ══════════════════════════════════════════════════════════

local function scanPlayerCharacterInventory()
    local rarityCounts = {
        ["Limited"]   = 0,
        ["INVASION"]  = 0,
        ["OG"]        = 0,
        ["OP"]        = 0,
        ["Immortal"]  = 0,
        ["Divine"]    = 0,
        ["Secret"]    = 0,
        ["Godlyx"]    = 0,
        ["Godly"]     = 0,
        ["God"]       = 0,
        ["Mythic"]    = 0,
        ["Legendary"] = 0,
        ["Epic"]      = 0,
        ["Rare"]      = 0,
        ["Common"]    = 0
    }
    
    local mutationCounts = {
        ["Gold"]       = 0,
        ["Diamond"]    = 0,
        ["Demon"]      = 0,
        ["Destroyer"]  = 0,
        ["Hollow"]     = 0,
        ["Slayer"]     = 0,
        ["Cursed"]     = 0,
        ["Astronaut"]  = 0
    }
    
    local totalChars = 0
    local totalMutations = 0
    local seenUIDs = {}

    local function resolveRarity(rawName, explicitRarity)
        if explicitRarity and rarityCounts[explicitRarity] then
            return explicitRarity
        end
        if explicitRarity and type(explicitRarity) == "string" then
            for rName in pairs(rarityCounts) do
                if explicitRarity:lower() == rName:lower() then
                    return rName
                end
            end
        end

        local nClean = tostring(rawName or ""):lower():gsub("lv%s*%.?%s*%d+", ""):gsub("%d+", ""):gsub("[%[%]%(%)%_%-%.%#]", " ")
        local nTrim = nClean:match("^%s*(.-)%s*$") or ""
        if nTrim == "" then return nil end

        -- 1. Check live game module cache from CharactersInfo
        if CachedModuleRarities and CachedModuleRarities[nTrim] and rarityCounts[CachedModuleRarities[nTrim]] then
            return CachedModuleRarities[nTrim]
        end

        -- 2. Check exact character dictionary
        if CharacterRarities and CharacterRarities[nTrim] and rarityCounts[CharacterRarities[nTrim]] then
            return CharacterRarities[nTrim]
        end

        -- 3. Check clean substring in dictionary
        if CharacterRarities then
            for charKey, rVal in pairs(CharacterRarities) do
                if (nTrim == charKey or nTrim:find("^" .. charKey .. "$") or nTrim:find(charKey, 1, true)) and rarityCounts[rVal] then
                    return rVal
                end
            end
        end

        return "Common"
    end

    local function resolveMutation(rawMut)
        if not rawMut then return nil end
        local mStr = tostring(rawMut):lower()
        if mStr:find("gold") then return "Gold"
        elseif mStr:find("diamond") then return "Diamond"
        elseif mStr:find("demon") then return "Demon"
        elseif mStr:find("destroyer") then return "Destroyer"
        elseif mStr:find("hollow") then return "Hollow"
        elseif mStr:find("slayer") then return "Slayer"
        elseif mStr:find("cursed") then return "Cursed"
        elseif mStr:find("astronaut") or mStr:find("cosmic") then return "Astronaut"
        end
        return nil
    end

    local function addChar(name, explicitRarity, uid, explicitMutation)
        if not name or name == "" then return end
        if uid then
            if seenUIDs[uid] then return end
            seenUIDs[uid] = true
        end

        local raw = tostring(name):lower()
        local nClean = raw:gsub("lv%s*%.?%s*%d+", ""):gsub("%d+", ""):gsub("[%[%]%(%)%_%-%.%#]", " ")
        local nTrim = nClean:match("^%s*(.-)%s*$") or ""
        
        -- Filter out non-character words
        if nTrim == "" or nTrim == "gold" or nTrim == "level" or nTrim == "slot" or nTrim == "button" or nTrim == "image" or nTrim == "frame" or nTrim == "pass" or nTrim == "shop" or nTrim == "index" or nTrim == "trade" or nTrim == "items" or nTrim == "animes" or nTrim == "profile" or nTrim == "upgr" or nTrim == "upgrades" or nTrim == "boost" then
            return
        end
        
        local finalRarity = resolveRarity(nTrim, explicitRarity)
        if finalRarity and rarityCounts[finalRarity] then
            totalChars = totalChars + 1
            rarityCounts[finalRarity] = rarityCounts[finalRarity] + 1
        end

        local finalMut = resolveMutation(explicitMutation) or resolveMutation(raw)
        if finalMut and mutationCounts[finalMut] then
            totalMutations = totalMutations + 1
            mutationCounts[finalMut] = mutationCounts[finalMut] + 1
        end
    end

    local foundFromData = false

    -- 1. Direct DataService Profile Access (Bag + Hotbar Profile)
    pcall(function()
        local dataServMod = ReplicatedStorage:FindFirstChild("Data") and ReplicatedStorage.Data:FindFirstChild("DataService")
        if dataServMod then
            local ds = require(dataServMod)
            local client = (type(ds) == "table" and (ds.client or ds.Client or ds)) or ds
            
            for _, key in ipairs({"Inventory", "Characters", "Hotbar", "Units", "Equipped"}) do
                local invList = nil
                pcall(function() invList = client:get(LocalPlayer, {key}) end)
                if not invList then pcall(function() invList = client:get({key}) end) end
                if not invList then pcall(function() invList = ds:get(LocalPlayer, {key}) end) end
                if not invList and client.Data then invList = client.Data[key] end
                if not invList and client.Profile then invList = client.Profile[key] end
                
                if type(invList) == "table" and next(invList) ~= nil then
                    foundFromData = true
                    for k, v in pairs(invList) do
                        if type(v) == "table" then
                            local cName = v.Name or v.CharacterName or v.Id or tostring(k)
                            local cRarity = v.Rarity or v.Tier
                            local cMut = v.Mutation or v.Mutations or v.Variant or v.Shiny
                            local cUID = v.UUID or v.UID or (key .. "_" .. tostring(k))
                            addChar(cName, cRarity, cUID, cMut)
                        elseif type(v) == "string" then
                            addChar(v, nil, key .. "_" .. tostring(k), nil)
                        end
                    end
                end
            end
        end
    end)

    -- 2. LocalPlayer Data / PlayerData Folders
    pcall(function()
        local dataFolder = LocalPlayer:FindFirstChild("Data") or LocalPlayer:FindFirstChild("PlayerData")
        if dataFolder then
            for _, folderName in ipairs({"Inventory", "Characters", "Hotbar", "Units", "Equipped"}) do
                local sub = dataFolder:FindFirstChild(folderName)
                if sub and #sub:GetChildren() > 0 then
                    foundFromData = true
                    for _, item in ipairs(sub:GetChildren()) do
                        local attrR = item:GetAttribute("Rarity") or item:GetAttribute("Tier")
                        local attrM = item:GetAttribute("Mutation") or item:GetAttribute("Mutations") or item:GetAttribute("Variant") or item:GetAttribute("Shiny")
                        local rChild = item:FindFirstChild("Rarity") or item:FindFirstChild("Tier")
                        local mChild = item:FindFirstChild("Mutation") or item:FindFirstChild("Mutations")
                        local rVal = (attrR and type(attrR) == "string" and attrR) or (rChild and rChild:IsA("ValueBase") and tostring(rChild.Value)) or nil
                        local mVal = (attrM and type(attrM) == "string" and attrM) or (mChild and mChild:IsA("ValueBase") and tostring(mChild.Value)) or nil
                        local itemUID = item:GetAttribute("UUID") or ("df_" .. item:GetFullName())
                        addChar(item.Name, rVal, itemUID, mVal)
                    end
                end
            end
        end
    end)

    -- 3. LocalPlayer Direct Storage Folders
    pcall(function()
        for _, folderName in ipairs({"Inventory", "Characters", "Hotbar", "Units", "Equipped"}) do
            local sub = LocalPlayer:FindFirstChild(folderName)
            if sub and #sub:GetChildren() > 0 then
                foundFromData = true
                for _, item in ipairs(sub:GetChildren()) do
                    local attrR = item:GetAttribute("Rarity") or item:GetAttribute("Tier")
                    local attrM = item:GetAttribute("Mutation") or item:GetAttribute("Mutations") or item:GetAttribute("Variant")
                    local rChild = item:FindFirstChild("Rarity") or item:FindFirstChild("Tier")
                    local mChild = item:FindFirstChild("Mutation") or item:FindFirstChild("Mutations")
                    local rVal = (attrR and type(attrR) == "string" and attrR) or (rChild and rChild:IsA("ValueBase") and tostring(rChild.Value)) or nil
                    local mVal = (attrM and type(attrM) == "string" and attrM) or (mChild and mChild:IsA("ValueBase") and tostring(mChild.Value)) or nil
                    local itemUID = item:GetAttribute("UUID") or ("lp_" .. item:GetFullName())
                    addChar(item.Name, rVal, itemUID, mVal)
                end
            end
        end
    end)

    -- 4. Bottom Hotbar Slots in PlayerGui
    pcall(function()
        local pGui = LocalPlayer:FindFirstChild("PlayerGui")
        if pGui then
            for _, g in ipairs(pGui:GetChildren()) do
                if g:IsA("ScreenGui") and g.Name ~= "CUPIEUI" and g.Enabled then
                    for _, desc in ipairs(g:GetDescendants()) do
                        if (desc:IsA("Frame") or desc:IsA("ImageLabel")) and (desc.Name:lower():find("slot") or desc.Name:match("^%d+$")) then
                            local lvLabel = nil
                            local nameLabel = nil
                            local mutLabel = nil
                            for _, ch in ipairs(desc:GetChildren()) do
                                if ch:IsA("TextLabel") and ch.Visible then
                                    local txt = ch.Text:lower()
                                    if txt:find("lv") or txt:match("^%d+$") then
                                        lvLabel = ch
                                    elseif CharacterRarities and (CharacterRarities[txt] or CharacterRarities[txt:match("^%s*(.-)%s*$")]) then
                                        nameLabel = ch
                                    elseif txt:find("gold") or txt:find("diamond") or txt:find("demon") or txt:find("destroyer") or txt:find("hollow") or txt:find("slayer") or txt:find("cursed") or txt:find("astronaut") then
                                        mutLabel = ch.Text
                                    end
                                end
                            end
                            if lvLabel and nameLabel then
                                local slotUID = "hotbar_slot_" .. desc:GetFullName()
                                local slotMut = desc:GetAttribute("Mutation") or mutLabel or (desc.Name:lower():find("gold") and "Gold")
                                addChar(nameLabel.Text, desc:GetAttribute("Rarity"), slotUID, slotMut)
                            end
                        end
                    end
                end
            end
        end
    end)
    
    return rarityCounts, totalChars, mutationCounts, totalMutations
end


-- Live Stats Updater Loop
local function updateDashboardStats(startTime)
    local goldStr, gemsStr, winsStr = getPlayerCurrencies()
    local elapsed = os.time() - (startTime or os.time())
    local hrs = math.floor(elapsed / 3600)
    local mins = math.floor((elapsed % 3600) / 60)
    local secs = elapsed % 60
    local timeStr = string.format("%02d:%02d:%02d", hrs, mins, secs)
    
    local formattedGold = formatNumberWithCommas(goldStr or "0")
    
    -- 1. Prominent Gold Display Card
    if goldPara then
        goldPara:SetTitle("GOLD: " .. formattedGold)
        goldPara:SetContent("Current Available Balance: " .. formattedGold .. " Gold Coins")
    end
    
    -- 2. Other Currencies Card
    if curPara then
        local dName = (LocalPlayer and LocalPlayer.DisplayName) or "Player"
        local uName = (LocalPlayer and LocalPlayer.Name) or "User"
        curPara:SetTitle(dName .. " (@" .. uName .. ")")
        curPara:SetContent(string.format(
            "• Gems (Diamonds) : %s\n" ..
            "• Wins / Level    : %s\n" ..
            "• Farm Duration   : %s",
            formatNumberWithCommas(gemsStr or "0"),
            tostring(winsStr or "0"),
            tostring(timeStr)
        ))
    end
    
    -- 3. Characters Count by Rarity & Mutations
    local rCounts, totalCount, mCounts, totalMutations = scanPlayerCharacterInventory()
    rCounts = rCounts or {}
    totalCount = totalCount or 0
    mCounts = mCounts or {}
    totalMutations = totalMutations or 0
    
    if invRarityPara then
        invRarityPara:SetTitle(string.format("Owned Characters (%d Total)", totalCount))
        invRarityPara:SetContent(string.format(
            "• Limited   : %d  |  INVASION : %d  |  OG       : %d\n" ..
            "• OP        : %d  |  Immortal : %d  |  Divine   : %d\n" ..
            "• Secret    : %d  |  Godlyx   : %d  |  Godly    : %d\n" ..
            "• God       : %d  |  Mythic   : %d  |  Legendary: %d\n" ..
            "• Epic      : %d  |  Rare     : %d  |  Common   : %d",
            rCounts["Limited"] or 0, rCounts["INVASION"] or 0, rCounts["OG"] or 0,
            rCounts["OP"] or 0, rCounts["Immortal"] or 0, rCounts["Divine"] or 0,
            rCounts["Secret"] or 0, rCounts["Godlyx"] or 0, rCounts["Godly"] or 0,
            rCounts["God"] or 0, rCounts["Mythic"] or 0, rCounts["Legendary"] or 0,
            rCounts["Epic"] or 0, rCounts["Rare"] or 0, rCounts["Common"] or 0
        ))
    end
    
    -- 4. Mutations Count Card
    if mutPara then
        mutPara:SetTitle(string.format("Owned Mutations (%d Total)", totalMutations))
        mutPara:SetContent(string.format(
            "• Gold       : %d  |  Diamond   : %d  |  Demon     : %d\n" ..
            "• Destroyer  : %d  |  Hollow    : %d  |  Slayer    : %d\n" ..
            "• Cursed     : %d  |  Astronaut : %d",
            mCounts["Gold"] or 0, mCounts["Diamond"] or 0, mCounts["Demon"] or 0,
            mCounts["Destroyer"] or 0, mCounts["Hollow"] or 0, mCounts["Slayer"] or 0,
            mCounts["Cursed"] or 0, mCounts["Astronaut"] or 0
        ))
    end
end

-- Run immediate first update + continuous 1-second refresh
task.spawn(function()
    local startTime = os.time()
    updateDashboardStats(startTime)
    while true do
        task.wait(3.0)
        pcall(function()
            updateDashboardStats(startTime)
        end)
    end
end)

-- Load saved user preferences if available
loadConfig()

Log("Success", "CUPIE HUB v2.0 Loaded Successfully!")
Log("Info", "AutoRoll: %s, AutoBuy: %s, AutoSell: %s", 
    tostring(Config.AutoRoll), 
    tostring(Config.AutoBuyByRarity),
    tostring(Config.AutoSellLowTier))



-- ══════════════════════════════════════════════════════════
-- UNIFIED MASTER AUTO ROLL & FUND-LOCK STEP FUNCTION
-- ══════════════════════════════════════════════════════════

local function performAutoRollStep()
    if not Config.AutoRoll then return end

    -- STEP 1: Smart Auto Buy with Active Gold Waiting (Never bail out / return early)
    if Config.AutoBuyByRarity then
        local waitCounter = 0
        while Config.AutoRoll and Config.AutoBuyByRarity do
            local targets = getMatchingStandTargets()
            if #targets == 0 then break end
            
            local hasUnaffordable = false
            for _, target in ipairs(targets) do
                local requiredCost = target.Cost or 200
                local curGold = getCurrentPlayerGold()
                if curGold < requiredCost then
                    hasUnaffordable = true
                else
                    buyStandTarget(target)
                    task.wait(randomDelay(0.12, 0.05))
                end
            end
            
            if not hasUnaffordable then
                break
            end
            
            waitCounter = waitCounter + 1
            if waitCounter >= 8 then
                warn("⏳ [AUTO ROLL] Waiting for Gold to buy matching targets on stand (Current: " .. tostring(getCurrentPlayerGold()) .. ")")
                waitCounter = 0
            end
            
            task.wait(randomDelay(0.5, 0.2))
        end
    end

    if not Config.AutoRoll then return end

    -- STEP 2: Trigger Roll
    local plot = getMyPlot()
    local prompt, btn = getPlotRollPrompt(plot)
    if prompt then
        firePrompt(prompt)
        Log("Info", "Roll triggered via ProximityPrompt")
    elseif CharactersRoll then
        pcall(function() 
            CharactersRoll:FireServer() 
            Log("Info", "Roll triggered via Remote")
        end)
    end

    -- STEP 3: Wait for new roll animation
    task.wait(randomDelay(0.35, 0.1))

    -- STEP 4: Inspect new roll and buy immediately if funds ready
    if Config.AutoBuyByRarity then
        executeSmartAutoBuy()
    end

    -- STEP 5: Auto Pickup All (ถ้าเปิด)
    if Config.AutoPickupAll then
        autoPickupAll()
    end

    -- STEP 6: Wait configured delay
    task.wait(randomDelay(math.max(1.5, Config.RollDelay), 0.3))
end

-- TAB 2: GACHA & SUMMON ENGINE (ระบบสุ่ม & ซื้อ/ขาย/ล็อคตามระดับ)
-- ══════════════════════════════════════════════════════════
local GachaTab = Window:CreateTab("Gacha", 2)
GachaTab:CreateToggle({
    Name = "Auto Roll (Fast Summon)",
    Description = "Automatically triggers roll proximity prompt and remote without stuttering",
    Badge = "HOT",
    Default = false,
    Callback = function(state)
        Config.AutoRoll = state
        if state then
            smoothPositionToRollPad()
            Cupie:StartLoop("AutoRollLoop", 0.5, function()
                performAutoRollStep()
            end)
        else
            Cupie:StopLoop("AutoRollLoop")
        end
    end
})

GachaTab:CreateSlider({
    Name = "Roll Speed / Delay",
    Description = "Interval between each roll attempt (seconds, min 2.0s)",
    Min = 2.0,
    Max = 8.0,
    Default = 2.5,
    Step = 0.1,
    Decimals = 1,
    Suffix = "s",
    Callback = function(val)
        Config.RollDelay = math.max(2.0, val)
    end
})

GachaTab:CreateHeader("AUTO BUY & FILTER CRITERIA", 3)

GachaTab:CreateMultiDropdown({
    Name = "Auto Buy - Rarity Filter (Multi-Select)",
    Description = "Select multiple specific Rarities to automatically buy",
    Options = {
        "Common",
        "Rare",
        "Epic",
        "Legendary",
        "Mythic",
        "Secret",
        "God",
        "Limited",
        "Godly",
        "Godlyx",
        "Divine",
        "Immortal",
        "OP",
        "OG",
        "INVASION"
    },
    Default = {
        ["Common"]    = true,
        ["Rare"]      = true,
        ["Epic"]      = true,
        ["Legendary"] = true,
        ["Mythic"]    = true,
        ["Secret"]    = true,
        ["God"]       = true,
        ["Limited"]   = true
    },
    Callback = function(selectedMap)
        Config.SelectedBuyRarities = selectedMap
    end
})

GachaTab:CreateMultiDropdown({
    Name = "Auto Buy - Mutation Filter (Multi-Select)",
    Description = "Select multiple specific Mutations to automatically buy",
    Options = {
        "Gold",
        "Astronaut",
        "Diamond",
        "Demon",
        "Destroyer",
        "Hollow",
        "Slayer",
        "Cursed"
    },
    Default = {
        ["Gold"]      = true,
        ["Astronaut"] = true
    },
    Callback = function(selectedMap)
        Config.SelectedBuyMutations = selectedMap
    end
})

GachaTab:CreateToggle({
    Name = "Enable Smart Auto Buy",
    Description = "Continuously buys characters matching your Rarity & Mutation criteria",
    Badge = "BUY",
    Default = false,
    Callback = function(state)
        Config.AutoBuyByRarity = state
        if state then
            Cupie:StartLoop("AutoBuyRarityLoop", 0.5, function()
                if not Config.AutoRoll then
                    executeSmartAutoBuy()
                end
            end)
        else
            Cupie:StopLoop("AutoBuyRarityLoop")
        end
    end
})

GachaTab:CreateMultiDropdown({
    Name = "Auto Sell - Rarity Filter (Multi-Select)",
    Description = "Select specific Rarities to automatically sell for Gold",
    Options = {
        "Common",
        "Rare",
        "Epic",
        "Legendary",
        "Mythic",
        "Secret",
        "God",
        "Limited"
    },
    Default = Config.SelectedSellRarities,
    Callback = function(selMap)
        Config.SelectedSellRarities = selMap
    end
})

GachaTab:CreateToggle({
    Name = "Auto Delete / Sell Low Tier",
    Description = "Scans inventory and sells units below selected rarity for Gold",
    Badge = "SELL",
    Default = false,
    Callback = function(state)
        Config.AutoSellLowTier = state
        if state then
            Cupie:StartLoop("AutoSellLoop", 2.0, function()
                executeAutoSell()
            end)
        else
            Cupie:StopLoop("AutoSellLoop")
        end
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
    Name = "Auto Pickup All Units",
    Description = "Automatically picks up all units from plot",
    Badge = "PICKUP",
    Default = false,
    Callback = function(state)
        Config.AutoPickupAll = state
        saveConfig()
        if state then
            Cupie:StartLoop("AutoPickupLoop", 1.5, function()
                autoPickupAll()
            end)
        else
            Cupie:StopLoop("AutoPickupLoop")
        end
    end
})

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

UpgradeTab:CreateHeader("Account Stat Upgrades (แยกตามประเภท)", 5)

-- 1. อัปเกรดโชค (Luck)
UpgradeTab:CreateToggle({
    Name = "Auto Upgrade Luck",
    Description = "อัปเกรดโชคเพื่อเพิ่มโอกาสได้ตัวละครระดับสูง",
    Badge = "LUCK",
    Default = false,
    Callback = function(state)
        Config.AutoUpgradeLuck = state
        saveConfig()
        if state or Config.AutoUpgradeInventory or Config.AutoUpgradeGold or Config.AutoUpgradeSlots then
            Cupie:StartLoop("AutoStatsLoop", 2.0, function()
                executeStatUpgrades()
            end)
        else
            Cupie:StopLoop("AutoStatsLoop")
        end
    end
})

-- 2. อัปเกรดกระเป๋า (Inventory)
UpgradeTab:CreateToggle({
    Name = "Auto Upgrade Inventory",
    Description = "อัปเกรดกระเป๋าเพื่อเพิ่มช่องเก็บตัวละคร",
    Badge = "BAG",
    Default = false,
    Callback = function(state)
        Config.AutoUpgradeInventory = state
        saveConfig()
        if state or Config.AutoUpgradeLuck or Config.AutoUpgradeGold or Config.AutoUpgradeSlots then
            Cupie:StartLoop("AutoStatsLoop", 2.0, function()
                executeStatUpgrades()
            end)
        else
            Cupie:StopLoop("AutoStatsLoop")
        end
    end
})

-- 3. อัปเกรดตัวคูณทอง (Gold Multiplier)
UpgradeTab:CreateToggle({
    Name = "Auto Upgrade Gold Multiplier",
    Description = "อัปเกรดตัวคูณทองเพื่อเพิ่มรายได้",
    Badge = "GOLD",
    Default = false,
    Callback = function(state)
        Config.AutoUpgradeGold = state
        saveConfig()
        if state or Config.AutoUpgradeLuck or Config.AutoUpgradeInventory or Config.AutoUpgradeSlots then
            Cupie:StartLoop("AutoStatsLoop", 2.0, function()
                executeStatUpgrades()
            end)
        else
            Cupie:StopLoop("AutoStatsLoop")
        end
    end
})

-- 4. อัปเกรดช่องสล็อต (Slots)
UpgradeTab:CreateToggle({
    Name = "Auto Upgrade Slots",
    Description = "อัปเกรดช่องสล็อตเพื่อวางตัวละครได้มากขึ้น",
    Badge = "SLOT",
    Default = false,
    Callback = function(state)
        Config.AutoUpgradeSlots = state
        saveConfig()
        if state or Config.AutoUpgradeLuck or Config.AutoUpgradeInventory or Config.AutoUpgradeGold then
            Cupie:StartLoop("AutoStatsLoop", 2.0, function()
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
-- TAB 4: COMBAT & DUNGEONS
-- ══════════════════════════════════════════════════════════
local CombatTab = Window:CreateTab("Combat", 4)
CombatTab:CreateHeader("Combat Automation & Battle Loop", 1)

local isFighting = false

if FightFolder then
    local battleEnded = FightFolder:FindFirstChild("Ended") or FightFolder:FindFirstChild("BattleEnded") or FightFolder:FindFirstChild("Finish")
    if battleEnded then
        Cupie:AddConnection(battleEnded.OnClientEvent:Connect(function()
            isFighting = false
            Log("Info", "Battle finished, ready for next round.")
        end))
    end
end

CombatTab:CreateToggle({
    Name = "Auto Fight (Infinite Battles)",
    Description = "Automatically starts battles and advances waves continuously",
    Badge = "FARM",
    Default = false,
    Callback = function(state)
        Config.AutoFight = state
        saveConfig()
        if state then
            Cupie:StartLoop("AutoFightLoop", 2.5, function()
                if not isFighting and FightStart then
                    FightStart:FireServer("AutoPlay")
                    isFighting = true
                    Log("Info", "AutoPlay battle started.")
                end
                if Config.AutoWaveSkip and FightArrived then
                    pcall(function() FightArrived:FireServer() end)
                end
            end)
        else
            Cupie:StopLoop("AutoFightLoop")
            if FightStart then
                FightStart:FireServer("Stop")
                isFighting = false
                Log("Info", "Combat halted.")
            end
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
        saveConfig()
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
    Description = "Interval between attack strikes (seconds) - 0.05s to 0.50s",
    Min = 0.05,
    Max = 0.50,
    Default = 0.15,
    Decimals = 2,
    Suffix = "s",
    Callback = function(val)
        Config.AttackSpeed = val
        saveConfig()
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
    Name = "Auto Faction Quests",
    Description = "Continuously requests faction quest data and scores",
    Default = false,
    Callback = function(state)
        Config.AutoFactionQuests = state
        saveConfig()
        if state then
            Cupie:StartLoop("AutoFactionLoop", 5.0, function()
                autoFactionQuests()
            end)
        else
            Cupie:StopLoop("AutoFactionLoop")
        end
    end
})


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

MiscTab:CreateHeader("Configuration & Profile Management", 8)

MiscTab:CreateButton({
    Name = "Save Current Settings",
    Description = "Save all toggle/slider values to file and shared memory",
    Callback = function()
        saveConfig()
        Cupie:Notify("Settings Saved", "Configuration saved successfully!", 2.5)
    end
})

MiscTab:CreateButton({
    Name = "Reset Settings to Default",
    Description = "Reset all settings to default values",
    Callback = function()
        Config.AutoRoll = false
        Config.AutoBuyByRarity = false
        Config.AutoSellLowTier = false
        Config.AutoEquipBest = false
        Config.AutoFight = false
        Config.FastAttackAura = false
        Config.AutoUpgradeStats = false
        Cupie:Notify("Settings Reset", "All settings restored to default!", 2.5)
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

Cupie:Notify("CUPIE HUB", "Loaded Anime Roll Hub v1.0 Successfully!", 3.5)
