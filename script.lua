--======================================================================================
-- DOMINATE HUB | PRO EDITION (STABLE V17.4 - HOISTED HELPERS & TRIALS INTEGRATION)
--======================================================================================
local Env = (type(getgenv) == "function" and getgenv()) or _G

if Env.DominateHubLoaded then 
    pcall(function()
        local parentTarget = (type(gethui) == "function" and gethui()) or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
        local oldUI = parentTarget:FindFirstChild("DominateHubMirror")
        if oldUI then oldUI:Destroy() end
        local oldBlur = game:GetService("Lighting"):FindFirstChild("DominateHubBlur")
        if oldBlur then oldBlur:Destroy() end
    end)
    print("[Dominate Hub] Reloading Instance...")
end
Env.DominateHubLoaded = true

local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

local Running = true
local player = Players.LocalPlayer
local vu = VirtualUser

local UI = {}

-- DESTINATION VECTORS (VERIFIED TRIAL VECTORS)
local Dest = {
    Basic = Vector3.new(1114.753, 10.310, -644.151), 
    Super = Vector3.new(1082.093, 16.661, -782.021), 
    Advanced = Vector3.new(1293.495, 16.515, -883.312),
    Cosmic = Vector3.new(783.450, 16.655, -855.972), 
    Football = Vector3.new(-2713.261, 36.861, -15.832), 
    Snowy = Vector3.new(1017.366, 5.866, 3262.671),
    ClassicCap = Vector3.new(-2586.923, 43.317, -659.105), 
    FootballCap = Vector3.new(-2603.007, 36.295, -31.061), 
    SuperCap = Vector3.new(618.032, 9.653, 3172.149),
    AncientCap = Vector3.new(714.6417236328125, 4.870510101318359, 7814.7265625),
    Dunes = Vector3.new(981.1582, 4.5862, 7767.3315),
    SandPit = Vector3.new(552.6134, 3.9798, 7827.5971),
    Sunfire = Vector3.new(692.3831176757812, 4.754001617431641, 7735.392578125),
    EasyTrial = Vector3.new(856.3858, 11.1623, 13441.8535),
    MediumTrial = Vector3.new(874.0194, 11.1781, 13418.9121),
    HardTrial = Vector3.new(908.3367, 11.1623, 13442.0332),
    CastleEntrance = Vector3.new(834.7246, 4.8552, 7622.6528),
    RitualChamber = Vector3.new(837.1246, 3.9983, 7904.0763),
    SandRegenPad = Vector3.new(557.1278076171875, 5.08376932144165, 7820.8671875),
    AncientBossSpawn = Vector3.new(627.4028, 4.8705, 7854.8388)
}

-- HOISTED HELPER FUNCTIONS (PREVENTS NIL-VALUE EXECUTION ERRORS)
local function GetWorldRoot() 
    return player.Character and player.Character:FindFirstChild("HumanoidRootPart") 
end

local function showToast(msg)
    task.spawn(function()
        local parentGui = (type(gethui) == "function" and gethui()) or player:WaitForChild("PlayerGui")
        local toast = Instance.new("Frame")
        toast.Size = UDim2.new(0, 220, 0, 38)
        toast.Position = UDim2.new(1, 10, 1, -60)
        toast.BackgroundColor3 = Color3.fromRGB(18, 12, 28)
        toast.BackgroundTransparency = 0.1
        toast.BorderSizePixel = 0
        toast.Parent = parentGui
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = toast

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(168, 85, 247)
        stroke.Transparency = 0.3
        stroke.Parent = toast

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -12, 1, 0)
        label.Position = UDim2.new(0, 6, 0, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(240, 240, 250)
        label.TextSize = 11
        label.Font = Enum.Font.GothamBold
        label.Text = msg
        label.Parent = toast

        toast:TweenPosition(UDim2.new(1, -235, 1, -60), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)
        task.wait(2.8)
        toast:TweenPosition(UDim2.new(1, 10, 1, -60), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.25, true)
        task.wait(0.25)
        toast:Destroy()
    end)
end

local function createToggleRow(parent, txt, vKey)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -10, 0, 42)
    row.BackgroundColor3 = Color3.fromRGB(35, 20, 55)
    row.BackgroundTransparency = 0.5
    row.BorderSizePixel = 0
    row.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = row

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.65, 0, 1, 0)
    lbl.Position = UDim2.new(0, 16, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(240, 235, 250)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.GothamBold
    lbl.Text = txt
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local switchTrack = Instance.new("TextButton")
    switchTrack.Size = UDim2.new(0, 48, 0, 22)
    switchTrack.Position = UDim2.new(1, -58, 0.5, -11)
    switchTrack.BackgroundColor3 = Env[vKey] and Color3.fromRGB(168, 85, 247) or Color3.fromRGB(42, 28, 65)
    switchTrack.Text = ""
    switchTrack.AutoButtonColor = false
    switchTrack.Parent = row
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = switchTrack

    local trackStroke = Instance.new("UIStroke")
    trackStroke.Color = Color3.fromRGB(216, 180, 254)
    trackStroke.Transparency = Env[vKey] and 0.2 or 0.7
    trackStroke.Parent = switchTrack

    local switchThumb = Instance.new("Frame")
    switchThumb.Size = UDim2.new(0, 18, 0, 18)
    switchThumb.Position = Env[vKey] and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    switchThumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    switchThumb.BorderSizePixel = 0
    switchThumb.Parent = switchTrack
    
    local thumbCorner = Instance.new("UICorner")
    thumbCorner.CornerRadius = UDim.new(1, 0)
    thumbCorner.Parent = switchThumb

    switchTrack.MouseButton1Click:Connect(function()
        Env[vKey] = not Env[vKey]
        local active = Env[vKey]
        switchTrack.BackgroundColor3 = active and Color3.fromRGB(168, 85, 247) or Color3.fromRGB(42, 28, 65)
        showToast(txt .. ": " .. tostring(active))
    end)
    return row
end

local function createTextBoxRow(parent, txt, vKey)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -10, 0, 42)
    row.BackgroundColor3 = Color3.fromRGB(35, 20, 55)
    row.BackgroundTransparency = 0.5
    row.BorderSizePixel = 0
    row.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = row

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.55, 0, 1, 0)
    lbl.Position = UDim2.new(0, 16, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(240, 235, 250)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.GothamBold
    lbl.Text = txt
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0, 90, 0, 26)
    textBox.Position = UDim2.new(1, -100, 0.5, -13)
    textBox.BackgroundColor3 = Color3.fromRGB(42, 28, 65)
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.TextSize = 12
    textBox.Font = Enum.Font.GothamBold
    textBox.Text = tostring(Env[vKey] or 3)
    textBox.ClearTextOnFocus = false
    textBox.Parent = row

    local tbCorner = Instance.new("UICorner")
    tbCorner.CornerRadius = UDim.new(0, 6)
    tbCorner.Parent = textBox

    textBox.FocusLost:Connect(function(enterPressed)
        local num = tonumber(textBox.Text)
        if num then
            num = math.max(1, math.round(num))
            Env[vKey] = num
            textBox.Text = tostring(num)
            showToast(txt .. " set to " .. tostring(num))
        else
            textBox.Text = tostring(Env[vKey])
        end
    end)
    return row
end

local function createButtonRow(parent, txt, callback)
    local row = Instance.new("TextButton")
    row.Size = UDim2.new(1, -10, 0, 42)
    row.BackgroundColor3 = Color3.fromRGB(168, 85, 247)
    row.BackgroundTransparency = 0.2
    row.TextColor3 = Color3.fromRGB(255, 255, 255)
    row.TextSize = 12
    row.Font = Enum.Font.GothamBold
    row.Text = txt
    row.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = row

    row.MouseButton1Click:Connect(callback)
    return row
end

local function createSectionHeader(parent, txt)
    local header = Instance.new("TextLabel")
    header.Size = UDim2.new(1, -10, 0, 32)
    header.BackgroundTransparency = 1
    header.TextColor3 = Color3.fromRGB(230, 110, 255)
    header.TextSize = 12
    header.Font = Enum.Font.GothamBold
    header.Text = txt
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.Parent = parent
    return header
end

local function masterToggleGroup(txt, flagsTable, scr)
    local f = Instance.new("Frame") 
    f.Size = UDim2.new(1, -10, 0, 42) 
    f.BackgroundColor3 = Color3.fromRGB(35, 20, 55) 
    f.BackgroundTransparency = 0.5
    f.BorderSizePixel = 0 
    f.Parent = scr

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = f

    local l = Instance.new("TextLabel") 
    l.Size = UDim2.new(0.65, 0, 1, 0) 
    l.Position = UDim2.new(0, 16, 0, 0) 
    l.BackgroundTransparency = 1 
    l.TextColor3 = Color3.fromRGB(240, 235, 250) 
    l.TextSize = 12 
    l.Font = Enum.Font.GothamBold 
    l.Text = txt 
    l.TextXAlignment = Enum.TextXAlignment.Left 
    l.Parent = f
    
    local switchTrack = Instance.new("TextButton")
    switchTrack.Size = UDim2.new(0, 48, 0, 22)
    switchTrack.Position = UDim2.new(1, -58, 0.5, -11)
    switchTrack.BackgroundColor3 = Color3.fromRGB(42, 28, 65)
    switchTrack.Text = ""
    switchTrack.AutoButtonColor = false
    switchTrack.Parent = f
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = switchTrack

    switchTrack.MouseButton1Click:Connect(function()
        local activeState = false
        for _, flag in ipairs(flagsTable) do
            if not Env[flag] then 
                activeState = true 
                break 
            end
        end
        for _, flag in ipairs(flagsTable) do
            Env[flag] = activeState
        end
        switchTrack.BackgroundColor3 = activeState and Color3.fromRGB(168, 85, 247) or Color3.fromRGB(42, 28, 65)
    end)
    return switchTrack
end

local function createRitualMobDropdown(parent, title, mobList)
    local dropFrame = Instance.new("Frame")
    dropFrame.Size = UDim2.new(1, -10, 0, 42)
    dropFrame.BackgroundColor3 = Color3.fromRGB(35, 20, 55)
    dropFrame.BackgroundTransparency = 0.5
    dropFrame.BorderSizePixel = 0
    dropFrame.ClipsDescendants = true
    dropFrame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = dropFrame

    local headerBtn = Instance.new("TextButton")
    headerBtn.Size = UDim2.new(1, 0, 0, 42)
    headerBtn.BackgroundTransparency = 1
    headerBtn.Text = ""
    headerBtn.Parent = dropFrame

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.75, 0, 1, 0)
    lbl.Position = UDim2.new(0, 16, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(240, 235, 250)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.GothamBold
    lbl.Text = title .. " (Configure Mobs)"
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = headerBtn

    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 30, 0, 42)
    arrow.Position = UDim2.new(1, -38, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.TextColor3 = Color3.fromRGB(216, 180, 254)
    arrow.TextSize = 12
    arrow.Font = Enum.Font.GothamBold
    arrow.Text = "▼"
    arrow.Parent = headerBtn

    local container = Instance.new("ScrollingFrame")
    container.Size = UDim2.new(1, -16, 0, 150)
    container.Position = UDim2.new(0, 8, 0, 46)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.ScrollBarThickness = 3
    container.ScrollingEnabled = true
    container.Parent = dropFrame

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 4)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = container

    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        container.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
    end)

    for _, mobInfo in ipairs(mobList) do
        local mobRow = Instance.new("TextButton")
        mobRow.Size = UDim2.new(1, -4, 0, 30)
        mobRow.BackgroundColor3 = Env.RitualSelectedMobs[mobInfo.N] and Color3.fromRGB(168, 85, 247) or Color3.fromRGB(42, 28, 65)
        mobRow.BackgroundTransparency = Env.RitualSelectedMobs[mobInfo.N] and 0.2 or 0.6
        mobRow.Text = ""
        mobRow.AutoButtonColor = false
        mobRow.Parent = container

        local rc = Instance.new("UICorner")
        rc.CornerRadius = UDim.new(0, 6)
        rc.Parent = mobRow

        local rLbl = Instance.new("TextLabel")
        rLbl.Size = UDim2.new(1, -12, 1, 0)
        rLbl.Position = UDim2.new(0, 10, 0, 0)
        rLbl.BackgroundTransparency = 1
        rLbl.TextColor3 = Color3.fromRGB(240, 235, 250)
        rLbl.TextSize = 11
        rLbl.Font = Enum.Font.GothamBold
        rLbl.Text = (Env.RitualSelectedMobs[mobInfo.N] and "[✔] " or "[   ] ") .. mobInfo.N
        rLbl.TextXAlignment = Enum.TextXAlignment.Left
        rLbl.Parent = mobRow

        mobRow.MouseButton1Click:Connect(function()
            Env.RitualSelectedMobs[mobInfo.N] = not Env.RitualSelectedMobs[mobInfo.N]
            local active = Env.RitualSelectedMobs[mobInfo.N]
            mobRow.BackgroundColor3 = active and Color3.fromRGB(168, 85, 247) or Color3.fromRGB(42, 28, 65)
            mobRow.BackgroundTransparency = active and 0.2 or 0.6
            rLbl.Text = (active and "[✔] " or "[   ] ") .. mobInfo.N
        end)
    end

    local isOpen = false
    headerBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        arrow.Text = isOpen and "▲" or "▼"
        TweenService:Create(dropFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Size = isOpen and UDim2.new(1, -10, 0, 204) or UDim2.new(1, -10, 0, 42)}):Play()
    end)

    return dropFrame
end

-- STATS TRACKING VARIABLES
local oresMined = 0
local mobsKilled = 0
local gemExchangeCountdown = 60
local ritualTimer = 0
local ritualInCooldown = false
local trialIsRunning = false
local ritualIsActive = false
local ritualSuppressMobs = false
local cachedStates = nil
local deadMobs = {}

-- RITUAL PRE-SELECTED MOBS & CONFIGS
Env.RitualSelectedMobs = {
    ["Dark Knight"] = true,
    ["Dark Commander"] = true
}

Env.AutoSandUpgrades = false
Env.AutoShovelLevelUp = false
Env.AutoExcavationRankUp = false
Env.AutoRegenSandLayers = false
Env.TargetSandLayer = 3
Env.AutoLeaveIfStuck = true
Env.TrialStagnationTime = 30
Env.AutoAncientBossFarm = false
Env.AntiAFK = true
Env.AutoPrestige = false
Env.CPUSaverMode = false

-- TRIAL TOGGLE FLAGS
Env.AutoEasyTrial = false
Env.AutoMediumTrial = false
Env.AutoHardTrial = false

-- LIVE GEM EXCHANGE TICKER
task.spawn(function()
    while Running do
        task.wait(1.0)
        if Env.AutoGemExchange or Env.AutoGemShopTeleport then
            gemExchangeCountdown = gemExchangeCountdown - 1
            if gemExchangeCountdown < 0 then
                gemExchangeCountdown = 60
            end
        else
            gemExchangeCountdown = 60
        end
    end
end)

-- ADD SUBTLE FROSTED BLUR EFFECT TO LIGHTING
pcall(function()
    local blur = Instance.new("BlurEffect")
    blur.Name = "DominateHubBlur"
    blur.Size = 6
    blur.Parent = Lighting
end)

player.Idled:Connect(function()
    if Running and Env.AntiAFK then
        local cam = workspace.CurrentCamera
        local cf = cam and cam.CFrame or CFrame.new()
        vu:Button2Down(Vector2.new(0,0), cf) task.wait(0.5) vu:Button2Up(Vector2.new(0,0), cf)
    end
end)

-- UI MASTER ALLOCATION
local parentTarget = (type(gethui) == "function" and gethui()) or player:WaitForChild("PlayerGui")
local sg = Instance.new("ScreenGui")
sg.Name = "DominateHubMirror"
sg.ResetOnSpawn = false
sg.Parent = parentTarget

local fps = 60
local frameCount = 0
local lastFpsUpdate = tick()
RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    if tick() - lastFpsUpdate >= 1 then
        fps = frameCount
        frameCount = 0
        lastFpsUpdate = tick()
    end
end)

-- MAIN WINDOW CONTAINER
local mainFrame = Instance.new("Frame") 
mainFrame.Size = UDim2.new(0, 620, 0, 410)
mainFrame.Position = UDim2.new(0.5, -310, 0.5, -205)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 12, 28) 
mainFrame.BackgroundTransparency = 0.02
mainFrame.BorderSizePixel = 0 
mainFrame.ClipsDescendants = true
mainFrame.Parent = sg

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(168, 85, 247)
mainStroke.Transparency = 0.25
mainStroke.Parent = mainFrame

local headerTitle = Instance.new("TextLabel") 
headerTitle.Size = UDim2.new(0.5, 0, 0, 20) 
headerTitle.Position = UDim2.new(0, 56, 0, 8) 
headerTitle.BackgroundTransparency = 1 
headerTitle.TextColor3 = Color3.fromRGB(216, 180, 254)
headerTitle.TextSize = 15 
headerTitle.Font = Enum.Font.GothamBold 
headerTitle.Text = "Dominate Hub v17.4 (Trials Fixed)" 
headerTitle.TextXAlignment = Enum.TextXAlignment.Left 
headerTitle.Parent = mainFrame

-- SIDEBAR TABS
local sidebarFrame = Instance.new("ScrollingFrame")
sidebarFrame.Size = UDim2.new(0, 135, 1, -55)
sidebarFrame.Position = UDim2.new(0, 12, 0, 50)
sidebarFrame.BackgroundTransparency = 1
sidebarFrame.BorderSizePixel = 0
sidebarFrame.ScrollBarThickness = 0
sidebarFrame.ScrollingEnabled = true
sidebarFrame.Parent = mainFrame

local sidebarLayout = Instance.new("UIListLayout")
sidebarLayout.Padding = UDim.new(0, 8)
sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
sidebarLayout.Parent = sidebarFrame

local function makeMainTab(emoji, txt)
    local t = Instance.new("TextButton")
    t.Size = UDim2.new(1, 0, 0, 42)
    t.BackgroundColor3 = Color3.fromRGB(18, 12, 28)
    t.TextColor3 = Color3.fromRGB(210, 190, 235)
    t.TextSize = 12
    t.Font = Enum.Font.GothamBold
    t.Text = emoji .. "    " .. txt
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.Parent = sidebarFrame
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 8)
    tabCorner.Parent = t
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 14)
    padding.Parent = t

    local tabStroke = Instance.new("UIStroke")
    tabStroke.Name = "TabStroke"
    tabStroke.Color = Color3.fromRGB(168, 85, 247)
    tabStroke.Transparency = 0.6
    tabStroke.Parent = t

    return t
end

local tabUpgrades = makeMainTab("⚡", "Upgrades") 
tabUpgrades.BackgroundColor3 = Color3.fromRGB(168, 85, 247) 
tabUpgrades.TextColor3 = Color3.fromRGB(255, 255, 255)
local activeTabStroke = tabUpgrades:FindFirstChild("TabStroke")
if activeTabStroke then activeTabStroke.Transparency = 0.1 end

local tabNoobs = makeMainTab("🤖", "Noobs")
local tabMines = makeMainTab("⛏️", "Mines")
local tabMobs = makeMainTab("⚔️", "Mobs")
local tabTrials = makeMainTab("🛡️", "Trials")
local tabFootball = makeMainTab("⚽", "Football")
local tabMisc = makeMainTab("📦", "Misc")
local tabSettings = makeMainTab("⚙️", "Settings")

-- PAGES
local pageArea = Instance.new("Frame")
pageArea.Size = UDim2.new(1, -165, 1, -55)
pageArea.Position = UDim2.new(0, 155, 0, 50)
pageArea.BackgroundTransparency = 1
pageArea.ClipsDescendants = true
pageArea.Parent = mainFrame

local function makePage()
    local p = Instance.new("Frame") 
    p.Size = UDim2.new(1, 0, 1, 0) 
    p.BackgroundTransparency = 1 
    p.Visible = false 
    p.Parent = pageArea 
    return p
end

local upgradesPage, noobsPage, minesPage, mobsPage, trialsPage, footballPage, miscPage, settingsPage = makePage(), makePage(), makePage(), makePage(), makePage(), makePage(), makePage(), makePage()
upgradesPage.Visible = true

local function makeVerticalScroll(parent)
    local s = Instance.new("ScrollingFrame")
    s.Size = UDim2.new(1, 0, 1, 0) 
    s.Position = UDim2.new(0, 0, 0, 0)
    s.BackgroundTransparency = 1 
    s.BorderSizePixel = 0 
    s.ScrollBarThickness = 0 
    s.ScrollingEnabled = true
    s.Visible = true
    s.Parent = parent 
    
    local list = Instance.new("UIListLayout") 
    list.Padding = UDim.new(0, 10) 
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Parent = s
    
    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() 
        s.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 20) 
    end)
    return s 
end

-- POPULATE PAGES
local upScroll = makeVerticalScroll(upgradesPage)
upScroll.Visible = true
createSectionHeader(upScroll, "Realm 1 Upgrades")
createToggleRow(upScroll, "More Oof Auto Upgrade", "AutoUpgradeMoreOof")
createToggleRow(upScroll, "Faster Noobs Upgrade", "AutoUpgradeFasterNoobs")
masterToggleGroup("Fire Upgrades", {"AutoFireMoreFire", "AutoFireMoreBulk", "AutoFireMoreOof", "AutoFireMoreRebirth", "AutoFireMoreTierLuck", "AutoFireMoreCashBonus"}, upScroll)
masterToggleGroup("Rebirth Upgrades", {"AutoRebirthMoreOof", "AutoRebirthMoreRebirth", "AutoRebirthMoreFire"}, upScroll)

local noobsScroll = makeVerticalScroll(noobsPage)
createSectionHeader(noobsScroll, "Realm 1 Noobs")
createToggleRow(noobsScroll, "Starter Auto Upgrade", "AutoUpgradeStarter")
createToggleRow(noobsScroll, "Cooker Auto Upgrade", "AutoUpgradeCooker")

-- TRIALS PAGE BUILD (WITH EASY, MEDIUM, HARD TOGGLES & MANUAL TEST BUTTON)
local trialsScroll = makeVerticalScroll(trialsPage)
createSectionHeader(trialsScroll, "Realm 3 Trials Automation (Scheduled :29 / :59)")
createToggleRow(trialsScroll, "Auto Easy Trial", "AutoEasyTrial")
createToggleRow(trialsScroll, "AutoMedium Trial", "AutoMediumTrial")
createToggleRow(trialsScroll, "Auto Hard Trial", "AutoHardTrial")
createToggleRow(trialsScroll, "Auto Leave If Stuck (Mob Stagnation)", "AutoLeaveIfStuck")
createTextBoxRow(trialsScroll, "Stagnation Time (s)", "TrialStagnationTime")

createSectionHeader(trialsScroll, "Manual Testing")
createButtonRow(trialsScroll, "Test Trial Teleport Now", function()
    local targetPad = Dest.HardTrial
    if Env.AutoEasyTrial then targetPad = Dest.EasyTrial
    elseif Env.AutoMediumTrial then targetPad = Dest.MediumTrial end
    
    showToast("Trials: Manual teleport test triggered!")
    trialIsRunning = true
    
    local hrp = GetWorldRoot()
    if hrp then
        hrp.Anchored = false
        hrp.CFrame = CFrame.new(targetPad)
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
    end
end)

local minesScroll = makeVerticalScroll(minesPage)
createSectionHeader(minesScroll, "Mining Configuration")
createToggleRow(minesScroll, "Stone", "AutoMineStone")
createToggleRow(minesScroll, "Coal", "AutoMineCoal")

local mobsScroll = makeVerticalScroll(mobsPage)
createSectionHeader(mobsScroll, "Realm 3 Mobs")
createToggleRow(mobsScroll, "Goblin", "AutoMobGoblin")
createToggleRow(mobsScroll, "Skeleton", "AutoMobSkeleton")
createRitualMobDropdown(mobsScroll, "Ritual Target Mobs", MobPriorityList)

local footballScroll = makeVerticalScroll(footballPage)
createSectionHeader(footballScroll, "Football Noobs")
createToggleRow(footballScroll, "Goalkeeper", "AutoUpgradeGoalkeeper")

local miscScroll = makeVerticalScroll(miscPage)
createSectionHeader(miscScroll, "Runes")
createToggleRow(miscScroll, "Auto Basic Rune Circle", "AutoRollBasicRune")

local settingsScroll = makeVerticalScroll(settingsPage)
createSectionHeader(settingsScroll, "General Settings")
createToggleRow(settingsScroll, "Anti AFK Protection", "AntiAFK")
createToggleRow(settingsScroll, "FPS Booster Mode", "FPSBoostMode")

createButtonRow(settingsScroll, "TERMINATE", function()
    Running = false 
    Env.DominateHubLoaded = nil 
    pcall(function() 
        local cam = workspace.CurrentCamera 
        if cam then cam.CameraType = Enum.CameraType.Custom end 
        local blur = Lighting:FindFirstChild("DominateHubBlur")
        if blur then blur:Destroy() end
    end) 
    sg:Destroy()
end)

-- NAVIGATION ROUTING
local function mainRoute(pOpen, bActive) 
    upgradesPage.Visible = false
    noobsPage.Visible = false
    minesPage.Visible = false
    mobsPage.Visible = false
    trialsPage.Visible = false
    footballPage.Visible = false
    miscPage.Visible = false
    settingsPage.Visible = false
    pOpen.Visible = true
    
    local tabs = {tabUpgrades, tabNoobs, tabMines, tabMobs, tabTrials, tabFootball, tabMisc, tabSettings}
    for _, t in ipairs(tabs) do 
        t.BackgroundColor3 = Color3.fromRGB(18, 12, 28)
        t.TextColor3 = Color3.fromRGB(210, 190, 235)
        local stroke = t:FindFirstChild("TabStroke")
        if stroke then stroke.Transparency = 0.6 end
    end
    bActive.BackgroundColor3 = Color3.fromRGB(168, 85, 247)
    bActive.TextColor3 = Color3.fromRGB(255, 255, 255)
    local activeStroke = bActive:FindFirstChild("TabStroke")
    if activeStroke then activeStroke.Transparency = 0.1 end
end

tabUpgrades.MouseButton1Click:Connect(function() mainRoute(upgradesPage, tabUpgrades) end) 
tabNoobs.MouseButton1Click:Connect(function() mainRoute(noobsPage, tabNoobs) end) 
tabMines.MouseButton1Click:Connect(function() mainRoute(minesPage, tabMines) end)
tabMobs.MouseButton1Click:Connect(function() mainRoute(mobsPage, tabMobs) end)
tabTrials.MouseButton1Click:Connect(function() mainRoute(trialsPage, tabTrials) end)
tabFootball.MouseButton1Click:Connect(function() mainRoute(footballPage, tabFootball) end) 
tabMisc.MouseButton1Click:Connect(function() mainRoute(miscPage, tabMisc) end)
tabSettings.MouseButton1Click:Connect(function() mainRoute(settingsPage, tabSettings) end)

-- MOVEMENT ENGINE
local MasterTargetVector = nil  
local MiningTargetVector = nil
local MobTargetVector = nil
local RitualTargetVector = nil
local SandTargetVector = nil

task.spawn(function()
    while Running do
        RunService.RenderStepped:Wait()
        local hrp = GetWorldRoot()
        if hrp and Running then
            local act = nil
            if RitualTargetVector then act = RitualTargetVector
            elseif MasterTargetVector then act = MasterTargetVector 
            elseif MobTargetVector then act = MobTargetVector
            elseif MiningTargetVector then act = MiningTargetVector
            elseif SandTargetVector then act = SandTargetVector end
            
            if act then
                local targetCF = CFrame.new(act)
                if trialIsRunning or MobTargetVector then
                    hrp.Anchored = false
                    hrp.CFrame = targetCF
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                else
                    if (hrp.Position - act).Magnitude > 0.3 then
                        hrp.Anchored = false
                        hrp.CFrame = hrp.CFrame:Lerp(targetCF, 0.85)
                        hrp.AssemblyLinearVelocity = Vector3.zero
                    else
                        hrp.CFrame = targetCF
                        hrp.AssemblyLinearVelocity = Vector3.zero
                        hrp.AssemblyAngularVelocity = Vector3.zero
                        hrp.Anchored = true
                    end
                end
            else
                hrp.Anchored = false
            end
        end
    end
end)

-- SCHEDULED TRIAL AUTOMATION (29TH & 59TH MINUTE WITH NEW VECTORS)
local lastTrialTriggeredSlot = ""
task.spawn(function()
    while Running do
        task.wait(1.0)
        local hrp = GetWorldRoot()
        local inLobby = hrp and hrp.Position.Z < 13000 or true
        
        if Running and (Env.AutoEasyTrial or Env.AutoMediumTrial or Env.AutoHardTrial) and not trialIsRunning and inLobby then
            local timeTable = os.date("*t")
            local min = timeTable.min
            local hour = timeTable.hour
            
            if (min == 29 or min == 59) then
                local currentSlot = hour .. "_" .. min
                if currentSlot ~= lastTrialTriggeredSlot then
                    lastTrialTriggeredSlot = currentSlot
                    
                    local targetPad = Dest.HardTrial
                    if Env.AutoEasyTrial then targetPad = Dest.EasyTrial
                    elseif Env.AutoMediumTrial then targetPad = Dest.MediumTrial end
                    
                    if targetPad then
                        showToast("Trials: Scheduled trial time reached! Teleporting...")
                        
                        MasterTargetVector = nil
                        MiningTargetVector = nil
                        MobTargetVector = nil
                        RitualTargetVector = nil
                        SandTargetVector = nil
                        
                        trialIsRunning = true
                        
                        local hrpToTeleport = GetWorldRoot()
                        if hrpToTeleport then
                            hrpToTeleport.Anchored = false
                            hrpToTeleport.CFrame = CFrame.new(targetPad)
                            hrpToTeleport.AssemblyLinearVelocity = Vector3.zero
                            hrpToTeleport.AssemblyAngularVelocity = Vector3.zero
                        end
                    end
                end
            end
        end
    end
end)

-- TRIAL ARENA EXIT & LOBBY DETECTOR
task.spawn(function()
    while Running do
        task.wait(0.5)
        local hrp = GetWorldRoot()
        if hrp then
            if hrp.Position.Z > 13000 and not trialIsRunning then
                trialIsRunning = true
                showToast("Trials: Entered trial arena.")
            elseif trialIsRunning and hrp.Position.Z < 13000 then
                trialIsRunning = false
                showToast("Trials: Exited trial arena.")
            end
        end
    end
end)

-- ANCIENT BOSS AUTO-SPAWN
task.spawn(function()
    while Running do
        task.wait(2.0)
        if Running and Env.AutoAncientBossFarm and not trialIsRunning then
            pcall(function()
                local bossExists = false
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("Model") and obj.Name == "Supreme Shadow Lord" then
                        local hum = obj:FindFirstChildOfClass("Humanoid")
                        if hum and hum.Health > 0 then
                            bossExists = true
                            break
                        end
                    end
                end
                if not bossExists then
                    MasterTargetVector = Dest.AncientBossSpawn
                    task.wait(1.5)
                    ReplicatedStorage:WaitForChild("__Net"):WaitForChild("MainRemote"):FireServer("SpawnAncientMob", "Supreme Shadow Lord")
                    task.wait(1.5)
                    MasterTargetVector = nil
                    task.wait(3.0)
                end
            end)
        end
    end
end)

print("[Dominate Hub] V17.4 Stable Loaded Successfully!")
