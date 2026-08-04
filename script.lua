--======================================================================================
-- DOMINATE HUB | PRO EDITION (LARGER SPACED CARDS & EXACT STYLING)
--======================================================================================
local Env = getgenv()

if Env.DominateHubLoaded then 
    pcall(function()
        local parentTarget = (gethui and gethui()) or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
        local oldUI = parentTarget:FindFirstChild("DominateHubMirror")
        if oldUI then oldUI:Destroy() end
        local oldBlur = Lighting:FindFirstChild("DominateHubBlur")
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
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local Running = true
local player = Players.LocalPlayer
local vu = VirtualUser
local NetRemote = nil

local UI = {}

-- STATS TRACKING VARIABLES FOR HUD
local oresMined = 0
local lastTrackedPart = nil
local currentTargetPanel = nil
local gemExchangeCountdown = 60

-- ADD SUBTLE FROSTED BLUR EFFECT TO LIGHTING
pcall(function()
    local blur = Instance.new("BlurEffect")
    blur.Name = "DominateHubBlur"
    blur.Size = 6
    blur.Parent = Lighting
end)

-- TOAST NOTIFICATION HELPER
local function showToast(msg)
    task.spawn(function()
        local toast = Instance.new("Frame")
        toast.Size = UDim2.new(0, 220, 0, 38)
        toast.Position = UDim2.new(1, 10, 1, -60)
        toast.BackgroundColor3 = Color3.fromRGB(28, 18, 42)
        toast.BackgroundTransparency = 0.2
        toast.BorderSizePixel = 0
        toast.Parent = (gethui and gethui()) or player:WaitForChild("PlayerGui")
        Instance.new("UICorner", toast).CornerRadius = UDim.new(0, 8)

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(168, 85, 247)
        stroke.Transparency = 0.3
        stroke.Parent = toast

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -10, 1, 0)
        label.Position = UDim2.new(0, 5, 0, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(240, 240, 250)
        label.TextSize = 12
        label.Font = Enum.Font.SourceSansBold
        label.Text = msg
        label.Parent = toast

        toast:TweenPosition(UDim2.new(1, -235, 1, -60), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)
        task.wait(2.8)
        toast:TweenPosition(UDim2.new(1, 10, 1, -60), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.25, true)
        task.wait(0.25)
        toast:Destroy()
    end)
end

Env.AntiAFK = true
Env.AutoPrestige = false
Env.CPUSaverMode = false

-- ALL AUTOMATION FLAGS INITIALIZED IN GETGENV
Env.AutoUpgradeStarter = false
Env.AutoUpgradeCooker = false
Env.AutoUpgradeFarmer = false
Env.AutoUpgradeMagician = false
Env.AutoUpgradeArcher = false
Env.AutoUpgradeSoldier = false
Env.AutoUpgradeMoreOof = false
Env.AutoUpgradeFasterNoobs = false

Env.AutoRebirthMoreOof = false
Env.AutoRebirthMoreRebirth = false
Env.AutoRebirthMoreFire = false

Env.AutoFireMoreFire = false
Env.AutoFireMoreBulk = false
Env.AutoFireMoreOof = false
Env.AutoFireMoreRebirth = false
Env.AutoFireMoreTierLuck = false
Env.AutoFireMoreCashBonus = false

Env.AutoRebirthTimer = false

Env.AutoBlazeMoreBlaze = false
Env.AutoBlazeMoreFire = false
Env.AutoBlazeMoreOof = false
Env.AutoBlazeMoreOofs = false
Env.AutoBlazeMoreBulk = false
Env.AutoBlazeConvert = false

Env.AutoUpgradePharaoh = false

Env.AutoUpgradeFishermanNoob = false
Env.AutoUpgradeKnightNoob = false
Env.AutoUpgradeExplorerNoob = false
Env.AutoUpgradeMagicianNoob = false
Env.AutoRealm2MoreWalkSpeed = false
Env.AutoRealm2MoreWater = false
Env.AutoRealm2MoreOofWater = false
Env.AutoRealm2MorePlanks = false
Env.AutoRealm2MoreIce = false
Env.AutoRealm2WaterPump1 = false
Env.AutoRealm2WaterPump2 = false
Env.AutoRealm2MoreOofIce = false

for i = 1, 11 do
    Env["AutoFillBucket" .. i] = false
end

Env.AutoWoodRankUp = false
Env.AutoWoodMoreWood = false
Env.AutoWoodSharperAxes = false
Env.AutoWoodBiggerDeposit = false
Env.AutoWoodFasterConversion = false
Env.AutoWoodMorePlanks = false
Env.AutoDepositWood = false

Env.AutoPlanksMorePlanks = false
Env.AutoPlanksMoreWood = false
Env.AutoPlanksWaterFromPlanks = false

Env.AutoGemMoreOof = false
Env.AutoGemMoreGems = false
Env.AutoGemStrongerPickaxes = false
Env.AutoGemMoreOreStats = false
Env.AutoGemExchange = false
Env.AutoGemShopTeleport = false

Env.AutoMineStone = false
Env.AutoMineCoal = false
Env.AutoMineSilver = false
Env.AutoMineIron = false
Env.AutoMineCopper = false
Env.AutoMineGold = false
Env.AutoMinePlatinum = false
Env.AutoMineTitanium = false
Env.AutoMineCobalt = false
Env.AutoMineUranium = false
Env.AutoMinePalladium = false
Env.AutoMineAetherite = false
Env.AutoMineRuby = false
Env.AutoMineVoidsteel = false
Env.AutoMineCelestium = false
Env.MiningJumpSpeed = 0.8 

Env.AutoUpgradeHacker1 = false
Env.AutoUpgradeHacker2 = false
Env.AutoUpgradeHacker3 = false
Env.AutoUpgradeHacker4 = false

Env.AutoScoreGoal = false
Env.AutoGoalsMoreGoals = false
Env.AutoGoalsRuneBulk = false
Env.AutoGoalsRuneLuck = false
Env.AutoBuyAutoKick = false
Env.AutoFootballTree = false
Env.AutoClaimTrophies = false

Env.AutoUpgradeGoalkeeper = false
Env.AutoUpgradeLeftBack = false
Env.AutoUpgradeLeftCenterBack = false
Env.AutoUpgradeRightCenterBack = false
Env.AutoUpgradeRightBack = false
Env.AutoUpgradeLeftDefensiveMid = false
Env.AutoUpgradeRightDefensiveMid = false
Env.AutoUpgradeAttackingMid = false
Env.AutoUpgradeLeftWing = false
Env.AutoUpgradeRightWing = false
Env.AutoUpgradeStriker = false

Env.AutoBreadMoreBread = false
Env.AutoBreadMoreBread2 = false
Env.AutoBreadMoreWheat = false
Env.AutoBreadBiggerWheatDeposit = false
Env.AutoDepositWheat = false
Env.AutoBreadFasterWheatConversion = false
Env.AutoBreadMoreConsumption = false
Env.AutoBreadMoreRuneLuck = false
Env.AutoBreadMoreTierLuck = false
Env.AutoUpgradeCow = false
Env.AutoUpgradeChicken = false
Env.AutoBuyCow = false
Env.AutoBuyChicken = false

Env.AutoFarmCash = false
Env.AutoUpgradeMoreCash = false
Env.AutoUpgradeFasterDropper = false
Env.AutoUpgradeMoreRuneLuck = false

Env.AutoRollBasicRune = false
Env.AutoRollSuperRune = false
Env.AutoRollAdvancedRune = false
Env.AutoRollCosmicRune = false
Env.AutoRollFootballRune = false
Env.AutoRollSnowyRune = false

Env.AutoOpenT1Chest = false
Env.AutoOpenT2Chest = false
Env.AutoOpenClassicCapsule = false
Env.AutoOpenFootballCapsule = false
Env.AutoOpenSuperCapsule = false

Env.FPSBoostMode = false
Env.ShowStatsHUD = true
Env.DiscordWebhookURL = ""

-- LARGER SPACED CARD BOX HELPER
local function createToggleRow(parent, txt, vKey)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -10, 0, 48)
    row.BackgroundColor3 = Color3.fromRGB(22, 14, 35)
    row.BorderSizePixel = 0
    row.Parent = parent
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 10)

    local rowStroke = Instance.new("UIStroke")
    rowStroke.Color = Color3.fromRGB(168, 85, 247)
    rowStroke.Transparency = 0.5
    rowStroke.Parent = row

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.65, 0, 1, 0)
    lbl.Position = UDim2.new(0, 16, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(240, 235, 250)
    lbl.TextSize = 13
    lbl.Font = Enum.Font.SourceSansBold
    lbl.Text = txt
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local switchTrack = Instance.new("TextButton")
    switchTrack.Size = UDim2.new(0, 50, 0, 24)
    switchTrack.Position = UDim2.new(1, -60, 0.5, -12)
    switchTrack.BackgroundColor3 = Env[vKey] and Color3.fromRGB(168, 85, 247) or Color3.fromRGB(42, 28, 65)
    switchTrack.Text = ""
    switchTrack.AutoButtonColor = false
    switchTrack.Parent = row
    Instance.new("UICorner", switchTrack).CornerRadius = UDim.new(1, 0)

    local trackStroke = Instance.new("UIStroke")
    trackStroke.Color = Color3.fromRGB(216, 180, 254)
    trackStroke.Transparency = Env[vKey] and 0.2 or 0.7
    trackStroke.Parent = switchTrack

    local switchThumb = Instance.new("Frame")
    switchThumb.Size = UDim2.new(0, 20, 0, 20)
    switchThumb.Position = Env[vKey] and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
    switchThumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    switchThumb.BorderSizePixel = 0
    switchThumb.Parent = switchTrack
    Instance.new("UICorner", switchThumb).CornerRadius = UDim.new(1, 0)

    switchTrack.MouseButton1Click:Connect(function()
        Env[vKey] = not Env[vKey]
        local active = Env[vKey]
        TweenService:Create(switchTrack, TweenInfo.new(0.2), {BackgroundColor3 = active and Color3.fromRGB(168, 85, 247) or Color3.fromRGB(42, 28, 65)}):Play()
        TweenService:Create(trackStroke, TweenInfo.new(0.2), {Transparency = active and 0.2 or 0.7}):Play()
        TweenService:Create(switchThumb, TweenInfo.new(0.2), {Position = active and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)}):Play()
    end)

    return row
end

-- LARGER MASTER TOGGLE GROUP HELPER
local function masterToggleGroup(txt, flagsTable, scr)
    local f = Instance.new("Frame") 
    f.Size = UDim2.new(1, -10, 0, 48) 
    f.BackgroundColor3 = Color3.fromRGB(22, 14, 35) 
    f.BorderSizePixel = 0 
    f.Parent = scr
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)

    local fStroke = Instance.new("UIStroke")
    fStroke.Color = Color3.fromRGB(168, 85, 247)
    fStroke.Transparency = 0.5
    fStroke.Parent = f

    local l = Instance.new("TextLabel") 
    l.Size = UDim2.new(0.65, 0, 1, 0) 
    l.Position = UDim2.new(0, 16, 0, 0) 
    l.BackgroundTransparency = 1 
    l.TextColor3 = Color3.fromRGB(240, 235, 250) 
    l.TextSize = 13 
    l.Font = Enum.Font.SourceSansBold 
    l.Text = txt 
    l.TextXAlignment = Enum.TextXAlignment.Left 
    l.Parent = f
    
    local switchTrack = Instance.new("TextButton")
    switchTrack.Size = UDim2.new(0, 50, 0, 24)
    switchTrack.Position = UDim2.new(1, -60, 0.5, -12)
    switchTrack.BackgroundColor3 = Color3.fromRGB(42, 28, 65)
    switchTrack.Text = ""
    switchTrack.AutoButtonColor = false
    switchTrack.Parent = f
    Instance.new("UICorner", switchTrack).CornerRadius = UDim.new(1, 0)

    local trackStroke = Instance.new("UIStroke")
    trackStroke.Color = Color3.fromRGB(216, 180, 254)
    trackStroke.Transparency = 0.7
    trackStroke.Parent = switchTrack

    local switchThumb = Instance.new("Frame")
    switchThumb.Size = UDim2.new(0, 20, 0, 20)
    switchThumb.Position = UDim2.new(0, 2, 0.5, -10)
    switchThumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    switchThumb.BorderSizePixel = 0
    switchThumb.Parent = switchTrack
    Instance.new("UICorner", switchThumb).CornerRadius = UDim.new(1, 0)

    switchTrack.MouseButton1Click:Connect(function()
        local activeState = false
        for _, flag in ipairs(flagsTable) do
            if not Env[flag] then activeState = true break end
        end
        for _, flag in ipairs(flagsTable) do
            Env[flag] = activeState
        end
        TweenService:Create(switchTrack, TweenInfo.new(0.2), {BackgroundColor3 = activeState and Color3.fromRGB(168, 85, 247) or Color3.fromRGB(42, 28, 65)}):Play()
        TweenService:Create(trackStroke, TweenInfo.new(0.2), {Transparency = activeState and 0.2 or 0.7}):Play()
        TweenService:Create(switchThumb, TweenInfo.new(0.2), {Position = activeState and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)}):Play()
    end)
    return switchTrack
end

-- SECTION HEADER HELPER
local function createSectionHeader(parent, txt)
    local header = Instance.new("TextLabel")
    header.Size = UDim2.new(1, -10, 0, 32)
    header.BackgroundTransparency = 1
    header.TextColor3 = Color3.fromRGB(230, 110, 255)
    header.TextSize = 13
    header.Font = Enum.Font.SourceSansBold
    header.Text = txt
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.Parent = parent
    return header
end

player.Idled:Connect(function()
    if Running and Env.AntiAFK then
        local cam = workspace.CurrentCamera
        local cf = cam and cam.CFrame or CFrame.new()
        vu:Button2Down(Vector2.new(0,0), cf) task.wait(0.5) vu:Button2Up(Vector2.new(0,0), cf)
    end
end)

task.spawn(function()
    repeat
        local netService = ReplicatedStorage:WaitForChild("__Net", 5)
        if netService then NetRemote = netService:FindFirstChild("MainRemote") or netService:FindFirstChildWhichIsA("RemoteEvent") end
        if not NetRemote then task.wait(0.5) end
    until NetRemote or not Running
end)

-- UI MASTER ALLOCATION
local parentTarget = (gethui and gethui()) or player:WaitForChild("PlayerGui")
local sg = Instance.new("ScreenGui") sg.Name = "DominateHubMirror" sg.ResetOnSpawn = false sg.Parent = parentTarget

local function sendDiscordWebhook(message)
    if Env.DiscordWebhookURL ~= "" then
        pcall(function()
            local requestFunc = syn and syn.request or http_request or request
            if requestFunc then
                requestFunc({
                    Url = Env.DiscordWebhookURL,
                    Method = "POST",
                    Headers = {["Content-Type"] = "application/json"},
                    Body = HttpService:JSONEncode({content = message})
                })
            end
        end)
    end
end

-- FPS & PING TRACKING UTILS
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

-- PERFORMANCE HUD OVERLAY (TOP LEFT)
local statsHud = Instance.new("Frame")
statsHud.Size = UDim2.new(0, 210, 0, 96)
statsHud.Position = UDim2.new(0, 15, 0, 15) 
statsHud.BackgroundColor3 = Color3.fromRGB(20, 14, 32)
statsHud.BackgroundTransparency = 0.35
statsHud.BorderSizePixel = 0
statsHud.Parent = sg
Instance.new("UICorner", statsHud).CornerRadius = UDim.new(0, 8)

local hudStroke = Instance.new("UIStroke")
hudStroke.Color = Color3.fromRGB(168, 85, 247)
hudStroke.Transparency = 0.4
hudStroke.Parent = statsHud

local hudTitle = Instance.new("TextLabel")
hudTitle.Size = UDim2.new(1, 0, 0, 20)
hudTitle.Position = UDim2.new(0, 0, 0, 2)
hudTitle.BackgroundTransparency = 1
hudTitle.TextColor3 = Color3.fromRGB(216, 180, 254)
hudTitle.TextSize = 10
hudTitle.Font = Enum.Font.SourceSansBold
hudTitle.Text = "PERFORMANCE HUD"
hudTitle.Parent = statsHud

local hudText = Instance.new("TextLabel")
hudText.Size = UDim2.new(1, -10, 1, -22)
hudText.Position = UDim2.new(0, 5, 0, 22)
hudText.BackgroundTransparency = 1
hudText.TextColor3 = Color3.fromRGB(220, 220, 230)
hudText.TextSize = 10
hudText.Font = Enum.Font.SourceSans
hudText.TextXAlignment = Enum.TextXAlignment.Left
hudText.TextYAlignment = Enum.TextYAlignment.Top
hudText.TextWrapped = true
hudText.Text = "Uptime: 00:00:00 | FPS: 60\nTarget: None | Glide: 0.8 S/s\nGem Exchange: 60s | Mined: 0"
hudText.Parent = statsHud

local sessionStartTime = tick()
task.spawn(function()
    while Running do
        task.wait(1.0)
        if Env.ShowStatsHUD then
            statsHud.Visible = true
            local elapsed = math.floor(tick() - sessionStartTime)
            local hours = math.floor(elapsed / 3600)
            local mins = math.floor((elapsed % 3600) / 60)
            local secs = elapsed % 60
            
            local targetName = "None"
            if currentTargetPanel and currentTargetPanel.Parent then
                targetName = currentTargetPanel.Parent.Name
            end
            
            hudText.Text = string.format(
                "Uptime: %02d:%02d:%02d | FPS: %d\nTarget: %s | Glide: %.1f S/s\nGem Exchange: %ds | Mined: %d",
                hours, mins, secs, fps, targetName, Env.MiningJumpSpeed or 0.8, gemExchangeCountdown, oresMined
            )
        else
            statsHud.Visible = false
        end
    end
end)

-- MAIN WINDOW CONTAINER (UNIFIED SEAMLESS BLENDED PURPLE BACKGROUND)
local mainFrame = Instance.new("Frame") 
mainFrame.Size = UDim2.new(0, 620, 0, 410) 
mainFrame.Position = UDim2.new(0.5, -310, 0.5, -205) 
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 12, 30) 
mainFrame.BackgroundTransparency = 0.02
mainFrame.BorderSizePixel = 0 
mainFrame.Parent = sg

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(168, 85, 247)
mainStroke.Transparency = 0.25
mainStroke.Parent = mainFrame

-- BRANDED HEADER WITH LOGO ICON BOX & SUBTITLE
local logoBox = Instance.new("Frame")
logoBox.Size = UDim2.new(0, 34, 0, 34)
logoBox.Position = UDim2.new(0, 14, 0, 10)
logoBox.BackgroundColor3 = Color3.fromRGB(147, 51, 234)
logoBox.BackgroundTransparency = 0.2
logoBox.BorderSizePixel = 0
logoBox.Parent = mainFrame
Instance.new("UICorner", logoBox).CornerRadius = UDim.new(0, 8)
local logoBoxStroke = Instance.new("UIStroke")
logoBoxStroke.Color = Color3.fromRGB(216, 180, 254)
logoBoxStroke.Transparency = 0.3
logoBoxStroke.Parent = logoBox

local logoLabel = Instance.new("TextLabel")
logoLabel.Size = UDim2.new(1, 0, 1, 0)
logoLabel.BackgroundTransparency = 1
logoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
logoLabel.TextSize = 18
logoLabel.Font = Enum.Font.SourceSansItalic
logoLabel.Text = "B"
logoLabel.Parent = logoBox

local headerTitle = Instance.new("TextLabel") 
headerTitle.Size = UDim2.new(0.5, 0, 0, 20) 
headerTitle.Position = UDim2.new(0, 56, 0, 8) 
headerTitle.BackgroundTransparency = 1 
headerTitle.TextColor3 = Color3.fromRGB(255, 255, 255) 
headerTitle.TextSize = 15 
headerTitle.Font = Enum.Font.SourceSansBold 
headerTitle.Text = "Dominate Hub v1.4 (Pro Edition)" 
headerTitle.TextXAlignment = Enum.TextXAlignment.Left 
headerTitle.Parent = mainFrame

local headerSubtitle = Instance.new("TextLabel")
headerSubtitle.Size = UDim2.new(0.5, 0, 0, 16)
headerSubtitle.Position = UDim2.new(0, 56, 0, 28)
headerSubtitle.BackgroundTransparency = 1
headerSubtitle.TextColor3 = Color3.fromRGB(180, 150, 210)
headerSubtitle.TextSize = 11
headerSubtitle.Font = Enum.Font.SourceSans
headerSubtitle.Text = "discord.gg/dominatehub | Lovely <3"
headerSubtitle.TextXAlignment = Enum.TextXAlignment.Left
headerSubtitle.Parent = mainFrame

local headerTelemetry = Instance.new("TextLabel")
headerTelemetry.Size = UDim2.new(0.3, 0, 0, 35)
headerTelemetry.Position = UDim2.new(0.68, 0, 0, 10)
headerTelemetry.BackgroundTransparency = 1
headerTelemetry.TextColor3 = Color3.fromRGB(74, 222, 128)
headerTelemetry.TextSize = 12
headerTelemetry.Font = Enum.Font.SourceSansBold
headerTelemetry.Text = "FPS: 60 | 30ms"
headerTelemetry.TextXAlignment = Enum.TextXAlignment.Right
headerTelemetry.Parent = mainFrame

task.spawn(function()
    while Running do
        task.wait(1.0)
        pcall(function()
            local pingVal = math.floor((player:GetNetworkPing() or 0) * 1000)
            headerTelemetry.Text = string.format("FPS: %d | %dms", fps, pingVal)
        end)
    end
end)

-- FLOATING PILL (MINIMIZE / RESTORE)
local minBtn = Instance.new("TextButton") 
minBtn.Size = UDim2.new(0, 115, 0, 26) 
minBtn.Position = UDim2.new(0.5, -57, 0.01, 0) 
minBtn.BackgroundColor3 = Color3.fromRGB(24, 16, 40) 
minBtn.BackgroundTransparency = 0.5 
minBtn.TextColor3 = Color3.fromRGB(216, 180, 254) 
minBtn.TextSize = 11 
minBtn.Font = Enum.Font.SourceSansBold 
minBtn.Text = "Dominate Hub" 
minBtn.Parent = sg
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 13)
local minStroke = Instance.new("UIStroke")
minStroke.Color = Color3.fromRGB(168, 85, 247)
minStroke.Transparency = 0.4
minStroke.Parent = minBtn

local pDragging, pDragInput, pDragStart, pStartPos
minBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        pDragging = true pDragStart = input.Position pStartPos = minBtn.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then pDragging = false end end)
    end
end)
minBtn.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then pDragInput = input end end)
UserInputService.InputChanged:Connect(function(input)
    if input == pDragInput and pDragging then
        local delta = input.Position - pDragStart
        minBtn.Position = UDim2.new(pStartPos.X.Scale, pStartPos.X.Offset + delta.X, pStartPos.Y.Scale, pStartPos.Y.Offset + delta.Y)
    end
end)

minBtn.MouseButton1Click:Connect(function()
    local isVisible = mainFrame.Visible
    if isVisible then
        local tween = TweenService:Create(mainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1})
        tween:Play()
        task.wait(0.25)
        mainFrame.Visible = false
        minBtn.TextColor3 = Color3.fromRGB(74, 222, 128)
    else
        mainFrame.Size = UDim2.new(0, 0, 0, 0)
        mainFrame.BackgroundTransparency = 0.02
        mainFrame.Visible = true
        local tween = TweenService:Create(mainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 620, 0, 410), BackgroundTransparency = 0.02})
        tween:Play()
        minBtn.TextColor3 = Color3.fromRGB(216, 180, 254)
    end
end)

-- SIDEBAR CONTAINER (VERTICAL LEFT NAVIGATION - CROPPED TIGHTLY TO FIT EMOJI & TEXT)
local sidebarFrame = Instance.new("Frame")
sidebarFrame.Size = UDim2.new(0, 135, 1, -55)
sidebarFrame.Position = UDim2.new(0, 12, 0, 50)
sidebarFrame.BackgroundTransparency = 1
sidebarFrame.BorderSizePixel = 0
sidebarFrame.Parent = mainFrame

local sidebarLayout = Instance.new("UIListLayout")
sidebarLayout.Padding = UDim.new(0, 8)
sidebarLayout.Parent = sidebarFrame

local function makeMainTab(emoji, txt)
    local t = Instance.new("TextButton")
    t.Size = UDim2.new(1, 0, 0, 42)
    t.BackgroundColor3 = Color3.fromRGB(28, 18, 46)
    t.TextColor3 = Color3.fromRGB(210, 190, 235)
    t.TextSize = 13
    t.Font = Enum.Font.SourceSansBold
    t.Text = emoji .. "    " .. txt
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.Parent = sidebarFrame
    
    Instance.new("UICorner", t).CornerRadius = UDim.new(0, 10)
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 14)
    padding.Parent = t

    return t
end

local tabUpgrades = makeMainTab("⚡", "Upgrades") 
tabUpgrades.BackgroundColor3 = Color3.fromRGB(147, 51, 234) 
tabUpgrades.TextColor3 = Color3.fromRGB(255, 255, 255)

local tabNoobs = makeMainTab("🤖", "Noobs")
local tabMines = makeMainTab("⛏️", "Mines")
local tabFootball = makeMainTab("⚽", "Football")
local tabMisc = makeMainTab("📦", "Misc")
local tabSettings = makeMainTab("⚙️", "Settings")

-- PAGE CONTAINER AREA
local pageArea = Instance.new("Frame")
pageArea.Size = UDim2.new(1, -165, 1, -55)
pageArea.Position = UDim2.new(0, 155, 0, 50)
pageArea.BackgroundTransparency = 1
pageArea.Parent = mainFrame

local function makePage()
    local p = Instance.new("Frame") 
    p.Size = UDim2.new(1, 0, 1, 0) 
    p.BackgroundTransparency = 1 
    p.Visible = false 
    p.Parent = pageArea 
    return p
end
local upgradesPage, noobsPage, minesPage, footballPage, miscPage, settingsPage = makePage(), makePage(), makePage(), makePage(), makePage(), makePage()
upgradesPage.Visible = true

-- VERTICAL SCROLL GENERATOR WITH BOLD PURPLE SCROLLBAR & CLEAN PADDING (`UIListLayout.Padding = 10`)
local function makeVerticalScroll(parent)
    local s = Instance.new("ScrollingFrame")
    s.Size = UDim2.new(1, 0, 1, 0) 
    s.Position = UDim2.new(0, 0, 0, 0)
    s.BackgroundTransparency = 1 
    s.BorderSizePixel = 0 
    s.ScrollBarThickness = 6 
    s.ScrollBarImageColor3 = Color3.fromRGB(168, 85, 247) 
    s.Visible = false 
    s.Parent = parent 
    
    local list = Instance.new("UIListLayout") list.Padding = UDim.new(0, 10) list.SortOrder = Enum.SortOrder.LayoutOrder; list.Parent = s
    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() s.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 20) end)
    return s 
end

-- ======================================================================================
-- UPGRADES PAGE
-- ======================================================================================
local upScroll = makeVerticalScroll(upgradesPage) upScroll.Visible = true

createSectionHeader(upScroll, "Realm 1 Upgrades")
createToggleRow(upScroll, "More Oof Auto Upgrade", "AutoUpgradeMoreOof")
createToggleRow(upScroll, "Faster Noobs Upgrade", "AutoUpgradeFasterNoobs")
masterToggleGroup("Fire Upgrades", {"AutoFireMoreFire", "AutoFireMoreBulk", "AutoFireMoreOof", "AutoFireMoreRebirth", "AutoFireMoreTierLuck", "AutoFireMoreCashBonus"}, upScroll)
masterToggleGroup("Rebirth Upgrades", {"AutoRebirthMoreOof", "AutoRebirthMoreRebirth", "AutoRebirthMoreFire"}, upScroll)
masterToggleGroup("Blaze Upgrades", {"AutoBlazeConvert", "AutoBlazeMoreBlaze", "AutoBlazeMoreFire", "AutoBlazeMoreOof", "AutoBlazeMoreOofs", "AutoBlazeMoreBulk"}, upScroll)
masterToggleGroup("Bread Upgrades", {"AutoDepositWheat", "AutoBreadMoreBread", "AutoBreadMoreBread2", "AutoBreadMoreWheat", "AutoBreadBiggerWheatDeposit", "AutoBreadFasterWheatConversion", "AutoBreadMoreConsumption", "AutoBreadMoreRuneLuck", "AutoBreadMoreTierLuck", "AutoUpgradeCow", "AutoUpgradeChicken", "AutoBuyCow", "AutoBuyChicken"}, upScroll)
masterToggleGroup("Cash Upgrades", {"AutoFarmCash", "AutoUpgradeMoreCash", "AutoUpgradeFasterDropper", "AutoUpgradeMoreRuneLuck"}, upScroll)
masterToggleGroup("Hacker Upgrades", {"AutoUpgradeHacker1", "AutoUpgradeHacker2", "AutoUpgradeHacker3", "AutoUpgradeHacker4"}, upScroll)

createSectionHeader(upScroll, "Realm 2 Upgrades")
masterToggleGroup("Ice Upgrades", {"AutoRealm2MoreIce", "AutoRealm2WaterPump1", "AutoRealm2WaterPump2", "AutoRealm2MoreOofIce"}, upScroll)
masterToggleGroup("Bucket Upgrades", {"AutoFillBucket1", "AutoFillBucket2", "AutoFillBucket3", "AutoFillBucket4", "AutoFillBucket5", "AutoFillBucket6", "AutoFillBucket7", "AutoFillBucket8", "AutoFillBucket9", "AutoFillBucket10", "AutoFillBucket11"}, upScroll)
masterToggleGroup("Water Upgrades", {"AutoRealm2MoreWater", "AutoRealm2MoreOofWater", "AutoRealm2MorePlanks"}, upScroll)
masterToggleGroup("Wood Upgrades", {"AutoWoodRankUp", "AutoWoodMoreWood", "AutoWoodSharperAxes", "AutoWoodBiggerDeposit", "AutoWoodFasterConversion", "AutoWoodMorePlanks", "AutoDepositWood"}, upScroll)
masterToggleGroup("Planks Upgrades", {"AutoPlanksMorePlanks", "AutoPlanksMoreWood", "AutoPlanksWaterFromPlanks"}, upScroll)

createSectionHeader(upScroll, "Gem Upgrades & Features")
createToggleRow(upScroll, "More Oof (Gem)", "AutoGemMoreOof")
createToggleRow(upScroll, "More Gems", "AutoGemMoreGems")
createToggleRow(upScroll, "Stronger Pickaxes", "AutoGemStrongerPickaxes")
createToggleRow(upScroll, "More Ore Stats", "AutoGemMoreOreStats")
createToggleRow(upScroll, "Gem Converter", "AutoGemExchange")
createToggleRow(upScroll, "Shop Teleport Loop", "AutoGemShopTeleport")

createSectionHeader(upScroll, "Realm 3 Upgrades")
masterToggleGroup("Pharaoh Upgrades", {"AutoUpgradePharaoh"}, upScroll)

-- ======================================================================================
-- NOOBS PAGE SETUP
-- ======================================================================================
local noobsScroll = makeVerticalScroll(noobsPage) noobsScroll.Visible = true

createSectionHeader(noobsScroll, "Realm 1 Noobs")
createToggleRow(noobsScroll, "Starter Auto Upgrade", "AutoUpgradeStarter")
createToggleRow(noobsScroll, "Cooker Auto Upgrade", "AutoUpgradeCooker")
createToggleRow(noobsScroll, "Farmer Auto Upgrade", "AutoUpgradeFarmer")
createToggleRow(noobsScroll, "Magician Auto Upgrade", "AutoUpgradeMagician")
createToggleRow(noobsScroll, "Archer Auto Upgrade", "AutoUpgradeArcher")
createToggleRow(noobsScroll, "Soldier Auto Upgrade", "AutoUpgradeSoldier")

createSectionHeader(noobsScroll, "Realm 2 Noobs")
createToggleRow(noobsScroll, "Auto Upgrade Fisherman", "AutoUpgradeFishermanNoob")
createToggleRow(noobsScroll, "Auto Upgrade Knight", "AutoUpgradeKnightNoob")
createToggleRow(noobsScroll, "Auto Upgrade Explorer", "AutoUpgradeExplorerNoob")
createToggleRow(noobsScroll, "Auto Upgrade Magician", "AutoUpgradeMagicianNoob")

-- ======================================================================================
-- MINES PAGE SETUP (SORTED WORST TO BEST)
-- ======================================================================================
local minesScroll = makeVerticalScroll(minesPage) minesScroll.Visible = true

local bestTierActive = false
local bestTierBtn = Instance.new("TextButton")
bestTierBtn.Size = UDim2.new(1, -10, 0, 48)
bestTierBtn.BackgroundColor3 = Color3.fromRGB(22, 14, 35)
bestTierBtn.TextColor3 = Color3.fromRGB(240, 235, 250)
bestTierBtn.TextSize = 13
bestTierBtn.Font = Enum.Font.SourceSansBold
bestTierBtn.Text = "Best Tier Only: DISABLED"
bestTierBtn.Parent = minesScroll
Instance.new("UICorner", bestTierBtn).CornerRadius = UDim.new(0, 10)
local bestTierStroke = Instance.new("UIStroke")
bestTierStroke.Color = Color3.fromRGB(168, 85, 247)
bestTierStroke.Transparency = 0.5
bestTierStroke.Parent = bestTierBtn

bestTierBtn.MouseButton1Click:Connect(function()
    bestTierActive = not bestTierActive
    bestTierBtn.Text = bestTierActive and "Best Tier Only: ACTIVE" or "Best Tier Only: DISABLED"
    bestTierBtn.BackgroundColor3 = bestTierActive and Color3.fromRGB(168, 85, 247) or Color3.fromRGB(22, 14, 35)

    local topOres = {"AutoMineVoidsteel", "AutoMineCelestium", "AutoMineRuby"}
    local allOres = {
        "AutoMineStone", "AutoMineCoal", "AutoMineSilver", "AutoMineIron", "AutoMineCopper",
        "AutoMineGold", "AutoMinePlatinum", "AutoMineTitanium", "AutoMineCobalt", "AutoMineUranium",
        "AutoMinePalladium", "AutoMineAetherite", "AutoMineRuby", "AutoMineVoidsteel", "AutoMineCelestium"
    }
    for _, ore in ipairs(allOres) do Env[ore] = false end
    if bestTierActive then for _, ore in ipairs(topOres) do Env[ore] = true end end
    showToast(bestTierActive and "Best Tier Only ores activated!" or "Best Tier Only deactivated.")
end)

-- GLIDE SPEED SCROLLER
local speedContainer = Instance.new("Frame")
speedContainer.Size = UDim2.new(1, -10, 0, 60)
speedContainer.BackgroundColor3 = Color3.fromRGB(22, 14, 35)
speedContainer.BorderSizePixel = 0
speedContainer.Parent = minesScroll
Instance.new("UICorner", speedContainer).CornerRadius = UDim.new(0, 10)
local speedStroke = Instance.new("UIStroke")
speedStroke.Color = Color3.fromRGB(168, 85, 247)
speedStroke.Transparency = 0.5
speedStroke.Parent = speedContainer

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, -20, 0, 22)
speedLabel.Position = UDim2.new(0, 16, 0, 8)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.fromRGB(240, 235, 250)
speedLabel.TextSize = 13
speedLabel.Font = Enum.Font.SourceSansBold
speedLabel.Text = string.format("Glide Speed: %.1fs", Env.MiningJumpSpeed or 0.8)
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = speedContainer

local sliderTrack = Instance.new("TextButton")
sliderTrack.Size = UDim2.new(1, -32, 0, 14)
sliderTrack.Position = UDim2.new(0, 16, 0, 34)
sliderTrack.BackgroundColor3 = Color3.fromRGB(42, 28, 65)
sliderTrack.Text = ""
sliderTrack.AutoButtonColor = false
sliderTrack.Parent = speedContainer
Instance.new("UICorner", sliderTrack).CornerRadius = UDim.new(1, 0)

local sliderFill = Instance.new("Frame")
local initialPercent = math.clamp(((Env.MiningJumpSpeed or 0.8) - 0.1) / 2.9, 0, 1)
sliderFill.Size = UDim2.new(initialPercent, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(168, 85, 247)
sliderFill.BorderSizePixel = 0
sliderFill.Parent = sliderTrack
Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)

local function updateSlider(inputX)
    local relX = math.clamp((inputX - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1)
    local speedVal = math.round((0.1 + (relX * 2.9)) * 10) / 10
    Env.MiningJumpSpeed = speedVal
    speedLabel.Text = string.format("Glide Speed: %.1fs", speedVal)
    sliderFill.Size = UDim2.new(relX, 0, 1, 0)
end

local sliding = false
sliderTrack.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        sliding = true
        updateSlider(input.Position.X)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateSlider(input.Position.X)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        sliding = false
    end
end)

createSectionHeader(minesScroll, "Basic Ores")
createToggleRow(minesScroll, "Stone", "AutoMineStone")
createToggleRow(minesScroll, "Coal", "AutoMineCoal")
createToggleRow(minesScroll, "Copper", "AutoMineCopper")
createToggleRow(minesScroll, "Iron", "AutoMineIron")
createToggleRow(minesScroll, "Silver", "AutoMineSilver")

createSectionHeader(minesScroll, "Advanced Ores")
createToggleRow(minesScroll, "Gold", "AutoMineGold")
createToggleRow(minesScroll, "Platinum", "AutoMinePlatinum")
createToggleRow(minesScroll, "Titanium", "AutoMineTitanium")
createToggleRow(minesScroll, "Uranium", "AutoMineUranium")
createToggleRow(minesScroll, "Cobalt", "AutoMineCobalt")

createSectionHeader(minesScroll, "End-Game Ores")
createToggleRow(minesScroll, "Palladium", "AutoMinePalladium")
createToggleRow(minesScroll, "Ruby", "AutoMineRuby")
createToggleRow(minesScroll, "Aetherite", "AutoMineAetherite")
createToggleRow(minesScroll, "Celestium", "AutoMineCelestium")
createToggleRow(minesScroll, "Voidsteel", "AutoMineVoidsteel")

-- ======================================================================================
-- FOOTBALL PAGE SETUP (UPDATED LABELS & REMOVED AUTO BUY KICK)
-- ======================================================================================
local footballScroll = makeVerticalScroll(footballPage) footballScroll.Visible = true

createSectionHeader(footballScroll, "Football Noobs")
createToggleRow(footballScroll, "Goalkeeper", "AutoUpgradeGoalkeeper")
createToggleRow(footballScroll, "Left Back", "AutoUpgradeLeftBack")
createToggleRow(footballScroll, "Left Centerback", "AutoUpgradeLeftCenterBack")
createToggleRow(footballScroll, "Right Centerback", "AutoUpgradeRightCenterBack")
createToggleRow(footballScroll, "Right Back", "AutoUpgradeRightBack")
createToggleRow(footballScroll, "Left Defensive Midfield", "AutoUpgradeLeftDefensiveMid")
createToggleRow(footballScroll, "Right Defensive Midfield", "AutoUpgradeRightDefensiveMid")
createToggleRow(footballScroll, "Attacking Mid", "AutoUpgradeAttackingMid")
createToggleRow(footballScroll, "Left Wing", "AutoUpgradeLeftWing")
createToggleRow(footballScroll, "Right Wing", "AutoUpgradeRightWing")
createToggleRow(footballScroll, "Striker", "AutoUpgradeStriker")

createSectionHeader(footballScroll, "Football Upgrades & Features")
createToggleRow(footballScroll, "Auto Score Goal", "AutoScoreGoal")
createToggleRow(footballScroll, "More Goals Upgrade", "AutoGoalsMoreGoals")
createToggleRow(footballScroll, "Goals Rune Bulk", "AutoGoalsRuneBulk")
createToggleRow(footballScroll, "Goals Rune Luck", "AutoGoalsRuneLuck")
createToggleRow(footballScroll, "Auto Football Tree", "AutoFootballTree")
createToggleRow(footballScroll, "Auto Buy Trophies", "AutoClaimTrophies")

-- ======================================================================================
-- MISC PAGE SETUP
-- ======================================================================================
local miscScroll = makeVerticalScroll(miscPage) miscScroll.Visible = true

createSectionHeader(miscScroll, "Runes")
createToggleRow(miscScroll, "Auto Basic Rune Circle", "AutoRollBasicRune")
createToggleRow(miscScroll, "Auto Super Rune Circle", "AutoRollSuperRune")
createToggleRow(miscScroll, "Auto Advanced Rune", "AutoRollAdvancedRune")
createToggleRow(miscScroll, "Auto Cosmic Prism", "AutoRollCosmicRune")
createToggleRow(miscScroll, "Auto Snowy Rune Circle", "AutoRollSnowyRune")
createToggleRow(miscScroll, "Auto Football Rune", "AutoRollFootballRune")

createSectionHeader(miscScroll, "Capsules")
createToggleRow(miscScroll, "Hatch Classic Capsule", "AutoOpenClassicCapsule")
createToggleRow(miscScroll, "Hatch Football Capsule", "AutoOpenFootballCapsule")
createToggleRow(miscScroll, "Hatch Super Capsule", "AutoOpenSuperCapsule")

-- ======================================================================================
-- SETTINGS PAGE SETUP
-- ======================================================================================
local settingsScroll = makeVerticalScroll(settingsPage) settingsScroll.Visible = true

createSectionHeader(settingsScroll, "General Settings")
createToggleRow(settingsScroll, "Anti AFK Protection", "AntiAFK")
createToggleRow(settingsScroll, "FPS Booster Mode", "FPSBoostMode")
createToggleRow(settingsScroll, "Stats HUD Overlay", "ShowStatsHUD")
createToggleRow(settingsScroll, "CPU Saver Mode", "CPUSaverMode")

createSectionHeader(settingsScroll, "Automation Settings")
createToggleRow(settingsScroll, "Auto Rebirth", "AutoRebirthTimer")
createToggleRow(settingsScroll, "Auto Prestige", "AutoPrestige")
createToggleRow(settingsScroll, "Mass Open T1 Chest", "AutoOpenT1Chest")
createToggleRow(settingsScroll, "Mass Open T2 Chest", "AutoOpenT2Chest")

createSectionHeader(settingsScroll, "Emergency Controls")
local killRow = Instance.new("Frame") killRow.Size = UDim2.new(1, -10, 0, 48) killRow.BackgroundColor3 = Color3.fromRGB(22, 14, 35) killRow.BorderSizePixel = 0; killRow.Parent = settingsScroll
Instance.new("UICorner", killRow).CornerRadius = UDim.new(0, 10)
local killRowStroke = Instance.new("UIStroke")
killRowStroke.Color = Color3.fromRGB(168, 85, 247)
killRowStroke.Transparency = 0.5
killRowStroke.Parent = killRow

local killLbl = Instance.new("TextLabel") killLbl.Size = UDim2.new(0.6, 0, 1, 0) killLbl.Position = UDim2.new(0, 16, 0, 0) killLbl.BackgroundTransparency = 1; killLbl.TextColor3 = Color3.fromRGB(254, 202, 202) killLbl.TextSize = 13; killLbl.Font = Enum.Font.SourceSansBold; killLbl.Text = "Emergency Kill Switch"; killLbl.TextXAlignment = Enum.TextXAlignment.Left; killLbl.Parent = killRow

local killBtn = Instance.new("TextButton") killBtn.Size = UDim2.new(0, 90, 0, 26) killBtn.Position = UDim2.new(1, -58, 0.5, -13) killBtn.BackgroundColor3 = Color3.fromRGB(153, 27, 27) killBtn.TextColor3 = Color3.fromRGB(254, 226, 226) killBtn.TextSize = 11; killBtn.Font = Enum.Font.SourceSansBold; killBtn.Text = "TERMINATE" killBtn.Parent = killRow
Instance.new("UICorner", killBtn).CornerRadius = UDim.new(0, 6)

killBtn.MouseButton1Click:Connect(function()
    Running = false Env.DominateHubLoaded = nil 
    for k, _ in pairs(Env) do if type(k) == "string" and (k:sub(1,4) == "Auto" or k == "AntiAFK") then Env[k] = false end end
    pcall(function() 
        local cam = workspace.CurrentCamera if cam then cam.CameraType = Enum.CameraType.Custom end 
        local blur = Lighting:FindFirstChild("DominateHubBlur")
        if blur then blur:Destroy() end
    end) 
    sg:Destroy()
end)

-- TAB ROUTING SYSTEM
local function mainRoute(pOpen, bActive) 
    upgradesPage.Visible, noobsPage.Visible, minesPage.Visible, footballPage.Visible, miscPage.Visible, settingsPage.Visible = false, false, false, false, false, false; pOpen.Visible = true; 
    local tabs = {tabUpgrades, tabNoobs, tabMines, tabFootball, tabMisc, tabSettings}
    for _, t in ipairs(tabs) do 
        t.BackgroundColor3 = Color3.fromRGB(28, 18, 46)
        t.TextColor3 = Color3.fromRGB(210, 190, 235)
    end
    bActive.BackgroundColor3 = Color3.fromRGB(147, 51, 234)
    bActive.TextColor3 = Color3.fromRGB(255, 255, 255)
end

tabUpgrades.MouseButton1Click:Connect(function() mainRoute(upgradesPage, tabUpgrades) end) 
tabNoobs.MouseButton1Click:Connect(function() mainRoute(noobsPage, tabNoobs) end) 
tabMines.MouseButton1Click:Connect(function() mainRoute(minesPage, tabMines) end)
tabFootball.MouseButton1Click:Connect(function() mainRoute(footballPage, tabFootball) end) 
tabMisc.MouseButton1Click:Connect(function() mainRoute(miscPage, tabMisc) end)
tabSettings.MouseButton1Click:Connect(function() mainRoute(settingsPage, tabSettings) end)

-- WINDOW DRAGGING ENGINE
local dragging, dragInput, dragStart, startPos
mainFrame.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true dragStart = input.Position startPos = mainFrame.Position input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) end end)
mainFrame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ======================================================================================
-- LOCOMOTION & AUTOMATION ENGINES
-- ======================================================================================
local MasterTargetVector = nil  
local MiningTargetVector = nil

local Dest = {
    Basic = Vector3.new(1114.753, 10.310, -644.151), Super = Vector3.new(1082.093, 16.661, -782.021), Advanced = Vector3.new(1293.495, 16.515, -883.312),
    Cosmic = Vector3.new(783.450, 16.655, -855.972), Football = Vector3.new(-2713.261, 36.861, -15.832), Snowy = Vector3.new(1017.366, 5.866, 3262.671),
    ClassicCap = Vector3.new(-2586.923, 43.317, -659.105), FootballCap = Vector3.new(-2603.007, 36.295, -31.061), SuperCap = Vector3.new(618.032, 9.653, 3172.149)
}

local function GetWorldRoot() return player.Character and player.Character:FindFirstChild("HumanoidRootPart") end

task.spawn(function()
    while Running do
        task.wait(Env.CPUSaverMode and 0.5 or 0.2)
        local hrp = GetWorldRoot()
        if hrp and Running then
            local act = nil
            if MasterTargetVector then act = MasterTargetVector elseif MiningTargetVector then act = MiningTargetVector
            elseif Env.AutoRollFootballRune then act = Dest.Football elseif Env.AutoRollSnowyRune then act = Dest.Snowy
            elseif Env.AutoRollCosmicRune then act = Dest.Cosmic elseif Env.AutoRollAdvancedRune then act = Dest.Advanced
            elseif Env.AutoRollSuperRune then act = Dest.Super elseif Env.AutoRollBasicRune then act = Dest.Basic end
            if act and Running and (hrp.Position - act).Magnitude > 5 then hrp.CFrame = CFrame.new(act) end
        end
    end
end)

local OrePriorityList = {
    {F = "AutoMineCelestium", N = "Celestium"}, {F = "AutoMineVoidsteel", N = "Voidsteel"}, {F = "AutoMineRuby", N = "Ruby"},
    {F = "AutoMineAetherite", N = "Aetherite"}, {F = "AutoMinePalladium", N = "Palladium"}, {F = "AutoMineUranium", N = "Uranium"},
    {F = "AutoMineCobalt", N = "Cobalt"}, {F = "AutoMineTitanium", N = "Titanium"}, {F = "AutoMinePlatinum", N = "Platinum"},
    {F = "AutoMineGold", N = "Gold"}, {F = "AutoMineCopper", N = "Copper"}, {F = "AutoMineIron", N = "Iron"},
    {F = "AutoMineSilver", N = "Silver"}, {F = "AutoMineCoal", N = "Coal"}, {F = "AutoMineStone", N = "Stone"}
}

local currentOreIndex = 1
local lastOreJumpTick = 0

local function isOreRespawning(oreModel)
    for _, desc in ipairs(oreModel:GetDescendants()) do
        if desc:IsA("TextLabel") and desc.Text:lower():find("respawning") then return true end
    end return false
end

task.spawn(function()
    while Running do
        task.wait(Env.CPUSaverMode and 0.25 or 0.1)
        if Running then
            local enabledOreNames = {} local hasAnyEnabled = false
            for i = 1, #OrePriorityList do if Env[OrePriorityList[i].F] then enabledOreNames[OrePriorityList[i].N] = true hasAnyEnabled = true end end

            if hasAnyEnabled then
                local needsNewTarget = false
                if not currentTargetPanel or not currentTargetPanel.Parent or not currentTargetPanel:IsDescendantOf(workspace) then needsNewTarget = true
                elseif currentTargetPanel.Parent and isOreRespawning(currentTargetPanel.Parent) then needsNewTarget = true
                elseif tick() - lastOreJumpTick >= (Env.MiningJumpSpeed or 0.8) then needsNewTarget = true end

                if needsNewTarget then
                    local freshList = {} local gc = workspace:FindFirstChild("__GAME_CONTENT") local oresFolder = gc and gc:FindFirstChild("Ores")
                    if oresFolder then
                        for _, obj in ipairs(oresFolder:GetChildren()) do
                            if enabledOreNames[obj.Name] and obj:IsA("Model") and not isOreRespawning(obj) then
                                local part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                                if part then table.insert(freshList, part) end
                            end
                        end
                    end
                    if #freshList > 0 then
                        table.sort(freshList, function(a, b) return a.Position.X < b.Position.X end)
                        currentOreIndex = currentOreIndex + 1 if currentOreIndex > #freshList then currentOreIndex = 1 end
                        currentTargetPanel = freshList[currentOreIndex] 
                        lastOreJumpTick = tick()
                        
                        if currentTargetPanel and currentTargetPanel ~= lastTrackedPart then
                            lastTrackedPart = currentTargetPanel
                            oresMined = oresMined + 1
                        end
                    else 
                        currentTargetPanel = nil 
                    end
                end
                
                if currentTargetPanel and currentTargetPanel.Parent then MiningTargetVector = currentTargetPanel.Position + Vector3.new(0, 3, 0) else MiningTargetVector = nil end
            else 
                currentTargetPanel = nil 
                MiningTargetVector = nil 
                oresMined = 0
                lastTrackedPart = nil
            end
        end
    end
end)

task.spawn(function()
    while Running do
        task.wait(Env.CPUSaverMode and 0.25 or 0.12)
        if NetRemote and Running then
            local hrp = GetWorldRoot()
            if hrp then
                if Env.AutoOpenClassicCapsule then if (hrp.Position - Dest.ClassicCap).Magnitude > 10 then hrp.CFrame = CFrame.new(Dest.ClassicCap + Vector3.new(0, 3, 0)) end pcall(function() NetRemote:FireServer("ToggleMinionAutoOpen", "Classic") end)
                elseif Env.AutoOpenFootballCapsule then if (hrp.Position - Dest.FootballCap).Magnitude > 10 then hrp.CFrame = CFrame.new(Dest.FootballCap + Vector3.new(0, 3, 0)) end pcall(function() NetRemote:FireServer("ToggleMinionAutoOpen", "Football") end)
                elseif Env.AutoOpenSuperCapsule then if (hrp.Position - Dest.SuperCap).Magnitude > 10 then hrp.CFrame = CFrame.new(Dest.SuperCap + Vector3.new(0, 3, 0)) end pcall(function() NetRemote:FireServer("ToggleMinionAutoOpen", "Super") end) end
            end
        end
    end
end)

task.spawn(function()
    while Running do
        task.wait(0.5)
        if Env.AutoFarmCash and Running then
            local gc = workspace:FindFirstChild("__GAME_CONTENT") local ty = gc and gc:FindFirstChild("Tycoon") local btnF = ty and ty:FindFirstChild("Buttons")
            if btnF and Running then
                local locked = {} 
                repeat
                    if not Running or not Env.AutoFarmCash then break end
                    local vis = btnF:GetChildren() local att = false
                    for i = 1, #vis do
                        if not Running or not Env.AutoFarmCash then break end
                        local bM = vis[i]
                        if bM and bM:IsA("Model") and not locked[bM.Name] then
                            local tb = bM:FindFirstChild("BuyingButtonPart", true)
                            if tb and tb:IsA("BasePart") and Running then
                                att = true MasterTargetVector = tb.Position + Vector3.new(0, 3, 0) task.wait(0.4)
                                if not Running then break end
                                if bM:IsDescendantOf(btnF) then locked[bM.Name] = true MasterTargetVector = nil task.wait(0.05) else MasterTargetVector = nil task.wait(0.1) break end
                            end
                        end
                    end
                    if not att or not Env.AutoFarmCash or not Running then break end task.wait(0.1)
                until false
                if Running then MasterTargetVector = nil local sE = tick() + math.random(120, 180) repeat task.wait(1) until tick() >= sE or not Env.AutoFarmCash or not Running end
            else MasterTargetVector = nil task.wait(2) end
        else MasterTargetVector = nil task.wait(1) end
    end
end)

local PrimaryUpgradeQueue = {
    {F="AutoUpgradeStarter",T="UpgradeNoob",A={"Starter"}}, {F="AutoUpgradeCooker",T="UpgradeNoobMax",A={"Cooker"}}, {F="AutoUpgradeFarmer",T="UpgradeNoobMax",A={"Farmer"}}, {F="AutoUpgradeMagician",T="UpgradeNoobMax",A={"Magician"}}, {F="AutoUpgradeArcher",T="UpgradeNoobMax",A={"Archer"}}, {F="AutoUpgradeSoldier",T="UpgradeNoobMax",A={"Soldier"}}, {F="AutoUpgradePharaoh",T="UpgradeNoobMax",A={"Pharaoh"}},
    {F="AutoUpgradeHacker1",T="UpgradeNoobMax",A={"Hacker 1"}}, {F="AutoUpgradeHacker2",T="UpgradeNoobMax",A={"Hacker 2"}}, {F="AutoUpgradeHacker3",T="UpgradeNoobMax",A={"Hacker 3"}}, {F="AutoUpgradeHacker4",T="UpgradeNoobMax",A={"Hacker 4"}},
    {F="AutoUpgradeFishermanNoob",T="UpgradeNoobMax",A={"Fisherman"}}, {F="AutoUpgradeKnightNoob",T="UpgradeNoobMax",A={"Knight"}}, {F="AutoUpgradeExplorerNoob",T="UpgradeNoobMax",A={"Explorer"}}, {F="AutoUpgradeMagicianNoob",T="UpgradeNoobMax",A={"Magician"}},
    {F="AutoUpgradeGoalkeeper",T="UpgradeNoobMax",A={"Goalkeeper"}}, {F="AutoUpgradeLeftBack",T="UpgradeNoobMax",A={"LeftBack"}}, {F="AutoUpgradeLeftCenterBack",T="UpgradeNoobMax",A={"LeftCenterBack"}}, {F="AutoUpgradeRightCenterBack",T="UpgradeNoobMax",A={"RightCenterBack"}}, {F="AutoUpgradeRightBack",T="UpgradeNoobMax",A={"RightBack"}}, {F="AutoUpgradeLeftDefensiveMid",T="UpgradeNoobMax",A={"LeftDefensiveMid"}}, {F="AutoUpgradeRightDefensiveMid",T="UpgradeNoobMax",A={"RightDefensiveMid"}}, {F="AutoUpgradeAttackingMid",T="UpgradeNoobMax",A={"AttackingMid"}}, {F="AutoUpgradeLeftWing",T="UpgradeNoobMax",A={"LeftWing"}}, {F="AutoUpgradeRightWing",T="UpgradeNoobMax",A={"RightWing"}}, {F="AutoUpgradeStriker",T="UpgradeNoobMax",A={"Striker"}},
    {F="AutoUpgradeMoreOof",T="UpgradeUpgradeMax",A={"Oof","MoreOof"}}, {F="AutoUpgradeFasterNoobs",T="UpgradeUpgradeMax",A={"Oof","FasterNoobs"}},
    {F="AutoRealm2MoreOof",T="UpgradeUpgradeMax",A={"Oof","MoreOofRealm2"}}, {F="AutoRealm2MoreWalkSpeed",T="UpgradeUpgradeMax",A={"Oof","MoreWalkSpeedRealm2"}}, {F="AutoRealm2MoreWater",T="UpgradeUpgradeMax",A={"Water","MoreWater"}}, {F="AutoRealm2MoreOofWater",T="UpgradeUpgradeMax",A={"Water","MoreOof"}}, {F="AutoRealm2MorePlanks",T="UpgradeUpgradeMax",A={"Water","MorePlanks"}}, {F="AutoRealm2MoreIce",T="UpgradeUpgradeMax",A={"Ice","MoreIce"}}, {F="AutoRealm2WaterPump1",T="UpgradeUpgradeMax",A={"Ice","WaterPumpNoobHire"}}, {F="AutoRealm2WaterPump2",T="UpgradeUpgradeMax",A={"Ice","WaterFromIce"}}, {F="AutoRealm2MoreOofIce",T="UpgradeUpgradeMax",A={"Ice","MoreOof"}},
    {F="AutoWoodRankUp",T="WoodRankUp",A={}}, {F="AutoWoodMoreWood",T="UpgradeUpgradeMax",A={"Wood","MoreWood"}}, {F="AutoWoodSharperAxes",T="UpgradeUpgradeMax",A={"Wood","SharperAxes"}}, {F="AutoWoodBiggerDeposit",T="UpgradeUpgradeMax",A={"Wood","BiggerWoodDeposit"}}, {F="AutoWoodFasterConversion",T="UpgradeUpgradeMax",A={"Wood","FasterWoodConversion"}}, {F="AutoWoodMorePlanks",T="UpgradeUpgradeMax",A={"Wood","MorePlanksFromWood"}},
    {F="AutoPlanksMorePlanks",T="UpgradeUpgradeMax",A={"Planks","MorePlanks"}}, {F="AutoPlanksMoreWood",T="UpgradeUpgradeMax",A={"Planks","MoreWood"}}, {F="AutoPlanksWaterFromPlanks",T="UpgradeUpgradeMax",A={"Planks","WaterFromPlanks"}},
    {F="AutoRebirthMoreOof",T="UpgradeUpgradeMax",A={"Rebirth","MoreOof"}}, {F="AutoRebirthMoreRebirth",T="UpgradeUpgradeMax",A={"Rebirth","MoreRebirth"}}, {F="AutoRebirthMoreFire",T="UpgradeUpgradeMax",A={"Rebirth","MoreFire"}},
    {F="AutoFireMoreFire",T="UpgradeUpgradeMax",A={"Fire","MoreFire"}}, {F="AutoFireMoreBulk",T="UpgradeUpgradeMax",A={"Fire","MoreBulk"}}, {F="AutoFireMoreOof",T="UpgradeUpgradeMax",A={"Fire","MoreOof"}}, {F="AutoFireMoreRebirth",T="UpgradeUpgradeMax",A={"Fire","MoreRebirth"}}, {F="AutoFireMoreTierLuck",T="UpgradeUpgradeMax",A={"Fire","MoreTierLuck"}}, {F="AutoFireMoreCashBonus",T="UpgradeUpgradeMax",A={"Fire","MoreCashBonus"}},
    {F="AutoUpgradeMoreCash",T="UpgradeUpgradeMax",A={"Cash","MoreCash"}}, {F="AutoUpgradeFasterDropper",T="UpgradeUpgradeMax",A={"Cash","FasterDropper"}}, {F="AutoUpgradeMoreRuneLuck",T="UpgradeUpgradeMax",A={"Cash","MoreRuneLuck"}},
    {F="AutoGoalsMoreGoals",T="UpgradeUpgradeMax",A={"Goals","MoreGoals"}}, {F="AutoGoalsRuneBulk",T="UpgradeUpgradeMax",A={"Goals","RuneBulk"}}, {F="AutoGoalsRuneLuck",T="UpgradeUpgradeMax",A={"Goals","RuneLuck"}}, {F="AutoBuyAutoKick",T="UpgradeUpgradeMax",A={"Goals","AutoKick"}}
}

task.spawn(function()
    while Running do
        task.wait(Env.CPUSaverMode and 2.0 or 1.0)
        if NetRemote and Running then
            for i = 1, #PrimaryUpgradeQueue do
                if not Running then break end local item = PrimaryUpgradeQueue[i]
                if Env[item.F] then pcall(function() NetRemote:FireServer(item.T, unpack(item.A)) end) task.wait(0.25) end
            end
        end
    end
end)

local GemUpgradeList = {
    {F="AutoGemMoreOof", T="UpgradeUpgradeMax", A={"Gem","MoreOof"}},
    {F="AutoGemMoreGems", T="UpgradeUpgradeMax", A={"Gem","MoreGems"}},
    {F="AutoGemStrongerPickaxes", T="UpgradeUpgradeMax", A={"Gem","StrongerPickaxes"}},
    {F="AutoGemMoreOreStats", T="UpgradeUpgradeMax", A={"Gem","MoreOreStats"}}
}
task.spawn(function()
    local gIdx = 1
    while Running do
        task.wait(0.4)
        if NetRemote and Running then
            local att = 0
            repeat
                local cur = GemUpgradeList[gIdx]
                gIdx = (gIdx % #GemUpgradeList) + 1
                att = att + 1
                if Env[cur.F] then
                    pcall(function() NetRemote:FireServer(cur.T, unpack(cur.A)) end)
                    break
                end
            until att >= #GemUpgradeList
        end
    end
end)

task.spawn(function() while Running do task.wait(0.5) if NetRemote and Running then for i = 1, 11 do if Env["AutoFillBucket" .. i] then pcall(function() NetRemote:FireServer("FillWaterBucket", i) end) task.wait(0.2) end end end end end)

-- WORKING GEM CONVERTER & 6-SECOND PITSTOP LOOP
task.spawn(function()
    while Running do
        task.wait(60.0)
        if NetRemote and Running and Env.AutoGemExchange then
            pcall(function()
                MasterTargetVector = Vector3.new(623.851, 8.781, 3210.993)
                task.wait(6.0)
                NetRemote:FireServer("ExchangeAllMinerals")
                task.wait(1.0)
                MasterTargetVector = nil
            end)
            showToast("Gem Shop Pitstop: Exchanged minerals successfully!")
            sendDiscordWebhook("Dominate Hub: Successfully performed Gem Shop Pitstop & Converted Minerals!")
        end
    end
end)

task.spawn(function() while Running do task.wait(0.2) if NetRemote and Running and Env.AutoScoreGoal then pcall(function() NetRemote:FireServer("RegisterFootballKick") end) task.wait(1.5) if not Running or not Env.AutoScoreGoal then break end pcall(function() NetRemote:FireServer("ScoreGoal") end) task.wait(1.5) end end end)

task.spawn(function()
    while Running do
        if NetRemote and Running and Env.AutoFootballTree then
            local pGui = player:FindFirstChild("PlayerGui") local treeGui = pGui and pGui:FindFirstChild("FootballUITree")
            if treeGui then
                for _, obj in pairs(treeGui:GetDescendants()) do
                    if not Running or not Env.AutoFootballTree then break end
                    if (obj:IsA("GuiButton") or obj:IsA("Frame")) and obj.Name ~= "Main" and obj.Name ~= "Container" then pcall(function() NetRemote:FireServer("BuyFootballUITreeNode", obj.Name) end) task.wait(0.5) end
                end
            end
        end
        task.wait(5.0)
    end
end)

task.spawn(function() while Running do task.wait(3.0) if NetRemote and Running and Env.AutoClaimTrophies then for i = 1, 10 do if not Running or not Env.AutoClaimTrophies then break end pcall(function() NetRemote:FireServer("BuyTrophy", i) end) task.wait(0.2) end end end end)

local BreadUpgradeList = { {F="AutoBreadMoreWheat",T="UpgradeUpgradeMax",A={"Bread","MoreWheat"}}, {F="AutoBreadMoreBread",T="UpgradeUpgradeMax",A={"Bread","MoreBread"}}, {F="AutoBreadMoreBread2",T="UpgradeUpgradeMax",A={"Bread","MoreBread2"}}, {F="AutoBreadBiggerWheatDeposit",T="UpgradeUpgradeMax",A={"Bread","BiggerWheatDeposit"}}, {F="AutoBreadFasterWheatConversion",T="UpgradeUpgradeMax",A={"Bread","FasterWheatConversion"}}, {F="AutoBreadMoreConsumption",T="UpgradeUpgradeMax",A={"Bread","MoreConsumption"}}, {F="AutoBreadMoreRuneLuck",T="UpgradeUpgradeMax",A={"Bread","MoreRuneLuck"}}, {F="AutoBreadMoreTierLuck",T="UpgradeUpgradeMax",A={"Bread","MoreTierLuck"}}, {F="AutoUpgradeCow",T="UpgradeAnimal",A={"Cow"}}, {F="AutoUpgradeChicken",T="UpgradeAnimal",A={"Chicken"}}, {F="AutoBuyCow",T="BuyAnimal",A={"Cow",true}}, {F="AutoBuyChicken",T="BuyAnimal",A={"Chicken",true}} }
task.spawn(function() local bIdx = 1 while Running do task.wait(1.2) if NetRemote and Running then local att = 0 repeat local cur = BreadUpgradeList[bIdx] bIdx = (bIdx % #BreadUpgradeList) + 1 att = att + 1 if Env[cur.F] then pcall(function() NetRemote:FireServer(cur.T, unpack(cur.A)) end) break end until att >= #BreadUpgradeList end end end)

task.spawn(function() while Running do task.wait(30.0) if NetRemote and Running then if Env.AutoDepositWheat then pcall(function() NetRemote:FireServer("DepositWheat") end) end if Env.AutoDepositWood then pcall(function() NetRemote:FireServer("DepositWood") end) end end end end)
task.spawn(function() while Running do task.wait(1.0) if NetRemote and Running then if Env.AutoBlazeMoreBlaze then pcall(function() NetRemote:FireServer("UpgradeUpgradeMax", "Blaze", "MoreBlaze") end) task.wait(0.25) end if Env.AutoBlazeMoreFire then pcall(function() NetRemote:FireServer("UpgradeUpgradeMax", "Blaze", "MoreFire") end) task.wait(0.25) end if Env.AutoBlazeMoreOof then pcall(function() NetRemote:FireServer("UpgradeUpgradeMax", "Blaze", "MoreOof") end) task.wait(0.25) end if Env.AutoBlazeMoreOofs then pcall(function() NetRemote:FireServer("UpgradeUpgradeMax", "Blaze", "MoreOofs") end) task.wait(0.25) end if Env.AutoBlazeMoreBulk then pcall(function() NetRemote:FireServer("UpgradeUpgradeMax", "Blaze", "MoreBulk") end) task.wait(0.25) end end end end)
task.spawn(function() while Running do task.wait(1.2) if NetRemote and Running then if Env.AutoOpenT1Chest then pcall(function() NetRemote:FireServer("OpenChest", "T1TrialChest", 10) end) end if Env.AutoOpenT2Chest then pcall(function() NetRemote:FireServer("OpenChest", "T2TrialChest", 10) end) end end end end)
task.spawn(function() while Running do task.wait(5.0) if Env.AutoPrestige and NetRemote and Running then pcall(function() NetRemote:FireServer("Prestige") end) end end end)

task.spawn(function()
    while Running do
        task.wait(60.0)
        if NetRemote and Running and Env.AutoBlazeConvert then
            pcall(function()
                NetRemote:FireServer("Blaze")
            end)
        end
    end
end)

print("[Dominate Hub] V11.20 Spacious Card Boxes & Stable Execution Loaded Successfully!")
