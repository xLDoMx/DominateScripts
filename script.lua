--======================================================================================
-- DOMINATE HUB | V12.2 PRO EDITION (V11.7 SPEEDS + MOUSE CLICKS + DOUBLE-CLICK FIX)
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
    print("[Dominate Hub] Reloading V12.2 Instance...")
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

-- ADD SUBTLE FROSTED BLUR EFFECT TO LIGHTING
pcall(function()
    local blur = Instance.new("BlurEffect")
    blur.Name = "DominateHubBlur"
    blur.Size = 6
    blur.Parent = Lighting
end)

-- MULTI-SLOT CONFIG SYSTEM
Env.SelectedConfigSlot = Env.SelectedConfigSlot or 1
local slotCustomNames = {[1] = "Slot 1", [2] = "Slot 2", [3] = "Slot 3", [4] = "Slot 4", [5] = "Slot 5"}

local function getSlotFileName(slot)
    return "DominateHub_Config_Slot" .. slot .. ".json"
end

local function saveConfigToSlot(slot, customName)
    if customName then slotCustomNames[slot] = customName end
    local configData = { _SlotCustomName = slotCustomNames[slot] }
    for k, v in pairs(Env) do
        if type(v) == "boolean" or type(v) == "number" or type(v) == "string" then
            configData[k] = v
        end
    end
    pcall(function()
        if writefile then
            writefile(getSlotFileName(slot), HttpService:JSONEncode(configData))
        end
    end)
end

-- TOAST NOTIFICATION HELPER
local function showToast(msg)
    task.spawn(function()
        local toast = Instance.new("Frame")
        toast.Size = UDim2.new(0, 210, 0, 36)
        toast.Position = UDim2.new(1, 10, 1, -60)
        toast.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
        toast.BackgroundTransparency = 0.35 
        toast.BorderSizePixel = 0
        toast.Parent = (gethui and gethui()) or player:WaitForChild("PlayerGui")
        Instance.new("UICorner", toast).CornerRadius = UDim.new(0, 10)

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -10, 1, 0)
        label.Position = UDim2.new(0, 5, 0, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(240, 240, 245)
        label.TextSize = 11
        label.Font = Enum.Font.SourceSansBold
        label.Text = msg
        label.Parent = toast

        toast:TweenPosition(UDim2.new(1, -225, 1, -60), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)
        task.wait(2.8)
        toast:TweenPosition(UDim2.new(1, 10, 1, -60), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.25, true)
        task.wait(0.25)
        toast:Destroy()
    end)
end

Env.AntiAFK = Env.AntiAFK ~= nil and Env.AntiAFK or true
Env.AutoPrestige = Env.AutoPrestige or false
Env.CPUSaverMode = Env.CPUSaverMode or false
Env.AutoTycoonTeleport = Env.AutoTycoonTeleport or false

-- ALL AUTOMATION FLAGS INITIALIZED IN GETGENV
Env.AutoUpgradeStarter = Env.AutoUpgradeStarter or false
Env.AutoUpgradeCooker = Env.AutoUpgradeCooker or false
Env.AutoUpgradeFarmer = Env.AutoUpgradeFarmer or false
Env.AutoUpgradeMagician = Env.AutoUpgradeMagician or false
Env.AutoUpgradeArcher = Env.AutoUpgradeArcher or false
Env.AutoUpgradeSoldier = Env.AutoUpgradeSoldier or false
Env.AutoUpgradeMoreOof = Env.AutoUpgradeMoreOof or false
Env.AutoUpgradeFasterNoobs = Env.AutoUpgradeFasterNoobs or false

Env.AutoRebirthMoreOof = Env.AutoRebirthMoreOof or false
Env.AutoRebirthMoreRebirth = Env.AutoRebirthMoreRebirth or false
Env.AutoRebirthMoreFire = Env.AutoRebirthMoreFire or false

Env.AutoFireMoreFire = Env.AutoFireMoreFire or false
Env.AutoFireMoreBulk = Env.AutoFireMoreBulk or false
Env.AutoFireMoreOof = Env.AutoFireMoreOof or false
Env.AutoFireMoreRebirth = Env.AutoFireMoreRebirth or false
Env.AutoFireMoreTierLuck = Env.AutoFireMoreTierLuck or false
Env.AutoFireMoreCashBonus = Env.AutoFireMoreCashBonus or false

Env.AutoRebirthTimer = Env.AutoRebirthTimer or false

Env.AutoBlazeMoreBlaze = Env.AutoBlazeMoreBlaze or false
Env.AutoBlazeMoreFire = Env.AutoBlazeMoreFire or false
Env.AutoBlazeMoreOof = Env.AutoBlazeMoreOof or false
Env.AutoBlazeMoreOofs = Env.AutoBlazeMoreOofs or false
Env.AutoBlazeMoreBulk = Env.AutoBlazeMoreBulk or false
Env.AutoBlazeConvert = Env.AutoBlazeConvert or false

Env.AutoUpgradePharaoh = Env.AutoUpgradePharaoh or false

Env.AutoUpgradeFishermanNoob = Env.AutoUpgradeFishermanNoob or false
Env.AutoUpgradeKnightNoob = Env.AutoUpgradeKnightNoob or false
Env.AutoUpgradeExplorerNoob = Env.AutoUpgradeExplorerNoob or false
Env.AutoUpgradeMagicianNoob = Env.AutoUpgradeMagicianNoob or false
Env.AutoRealm2MoreWalkSpeed = Env.AutoRealm2MoreWalkSpeed or false
Env.AutoRealm2MoreWater = Env.AutoRealm2MoreWater or false
Env.AutoRealm2MoreOofWater = Env.AutoRealm2MoreOofWater or false
Env.AutoRealm2MorePlanks = Env.AutoRealm2MorePlanks or false
Env.AutoRealm2MoreIce = Env.AutoRealm2MoreIce or false
Env.AutoRealm2WaterPump1 = Env.AutoRealm2WaterPump1 or false
Env.AutoRealm2WaterPump2 = Env.AutoRealm2WaterPump2 or false
Env.AutoRealm2MoreOofIce = Env.AutoRealm2MoreOofIce or false

for i = 1, 11 do
    Env["AutoFillBucket" .. i] = Env["AutoFillBucket" .. i] or false
end

Env.AutoWoodRankUp = Env.AutoWoodRankUp or false
Env.AutoWoodMoreWood = Env.AutoWoodMoreWood or false
Env.AutoWoodSharperAxes = Env.AutoWoodSharperAxes or false
Env.AutoWoodBiggerDeposit = Env.AutoWoodBiggerDeposit or false
Env.AutoWoodFasterConversion = Env.AutoWoodFasterConversion or false
Env.AutoWoodMorePlanks = Env.AutoWoodMorePlanks or false
Env.AutoDepositWood = Env.AutoDepositWood or false

Env.AutoPlanksMorePlanks = Env.AutoPlanksMorePlanks or false
Env.AutoPlanksMoreWood = Env.AutoPlanksMoreWood or false
Env.AutoPlanksWaterFromPlanks = Env.AutoPlanksWaterFromPlanks or false

Env.AutoGemMoreOof = Env.AutoGemMoreOof or false
Env.AutoGemMoreGems = Env.AutoGemMoreGems or false
Env.AutoGemStrongerPickaxes = Env.AutoGemStrongerPickaxes or false
Env.AutoGemMoreOreStats = Env.AutoGemMoreOreStats or false
Env.AutoGemExchange = Env.AutoGemExchange or false

Env.AutoMineStone = Env.AutoMineStone or false
Env.AutoMineCoal = Env.AutoMineCoal or false
Env.AutoMineSilver = Env.AutoMineSilver or false
Env.AutoMineIron = Env.AutoMineIron or false
Env.AutoMineCopper = Env.AutoMineCopper or false
Env.AutoMineGold = Env.AutoMineGold or false
Env.AutoMinePlatinum = Env.AutoMinePlatinum or false
Env.AutoMineTitanium = Env.AutoMineTitanium or false
Env.AutoMineCobalt = Env.AutoMineCobalt or false
Env.AutoMineUranium = Env.AutoMineUranium or false
Env.AutoMinePalladium = Env.AutoMinePalladium or false
Env.AutoMineAetherite = Env.AutoMineAetherite or false
Env.AutoMineRuby = Env.AutoMineRuby or false
Env.AutoMineVoidsteel = Env.AutoMineVoidsteel or false
Env.AutoMineCelestium = Env.AutoMineCelestium or false
Env.MiningJumpSpeed = Env.MiningJumpSpeed or 0.8 

Env.AutoUpgradeHacker1 = Env.AutoUpgradeHacker1 or false
Env.AutoUpgradeHacker2 = Env.AutoUpgradeHacker2 or false
Env.AutoUpgradeHacker3 = Env.AutoUpgradeHacker3 or false
Env.AutoUpgradeHacker4 = Env.AutoUpgradeHacker4 or false

Env.AutoScoreGoal = Env.AutoScoreGoal or false
Env.AutoGoalsMoreGoals = Env.AutoGoalsMoreGoals or false
Env.AutoGoalsRuneBulk = Env.AutoGoalsRuneBulk or false
Env.AutoGoalsRuneLuck = Env.AutoGoalsRuneLuck or false
Env.AutoBuyAutoKick = Env.AutoBuyAutoKick or false
Env.AutoFootballTree = Env.AutoFootballTree or false
Env.AutoClaimTrophies = Env.AutoClaimTrophies or false

Env.AutoUpgradeGoalkeeper = Env.AutoUpgradeGoalkeeper or false
Env.AutoUpgradeLeftBack = Env.AutoUpgradeLeftBack or false
Env.AutoUpgradeLeftCenterBack = Env.AutoUpgradeLeftCenterBack or false
Env.AutoUpgradeRightCenterBack = Env.AutoUpgradeRightCenterBack or false
Env.AutoUpgradeRightBack = Env.AutoUpgradeRightBack or false
Env.AutoUpgradeLeftDefensiveMid = Env.AutoUpgradeLeftDefensiveMid or false
Env.AutoUpgradeRightDefensiveMid = Env.AutoUpgradeRightDefensiveMid or false
Env.AutoUpgradeAttackingMid = Env.AutoUpgradeAttackingMid or false
Env.AutoUpgradeLeftWing = Env.AutoUpgradeLeftWing or false
Env.AutoUpgradeRightWing = Env.AutoUpgradeRightWing or false
Env.AutoUpgradeStriker = Env.AutoUpgradeStriker or false

Env.AutoBreadMoreBread = Env.AutoBreadMoreBread or false
Env.AutoBreadMoreBread2 = Env.AutoBreadMoreBread2 or false
Env.AutoBreadMoreWheat = Env.AutoBreadMoreWheat or false
Env.AutoBreadBiggerWheatDeposit = Env.AutoBreadBiggerWheatDeposit or false
Env.AutoDepositWheat = Env.AutoDepositWheat or false
Env.AutoBreadFasterWheatConversion = Env.AutoBreadFasterWheatConversion or false
Env.AutoBreadMoreConsumption = Env.AutoBreadMoreConsumption or false
Env.AutoBreadMoreRuneLuck = Env.AutoBreadMoreRuneLuck or false
Env.AutoBreadMoreTierLuck = Env.AutoBreadMoreTierLuck or false
Env.AutoUpgradeCow = Env.AutoUpgradeCow or false
Env.AutoUpgradeChicken = Env.AutoUpgradeChicken or false
Env.AutoBuyCow = Env.AutoBuyCow or false
Env.AutoBuyChicken = Env.AutoBuyChicken or false

Env.AutoFarmCash = Env.AutoFarmCash or false
Env.AutoUpgradeMoreCash = Env.AutoUpgradeMoreCash or false
Env.AutoUpgradeFasterDropper = Env.AutoUpgradeFasterDropper or false
Env.AutoUpgradeMoreRuneLuck = Env.AutoUpgradeMoreRuneLuck or false
Env.AutoTycoonReset = Env.AutoTycoonReset or false

Env.AutoRollBasicRune = Env.AutoRollBasicRune or false
Env.AutoRollSuperRune = Env.AutoRollSuperRune or false
Env.AutoRollAdvancedRune = Env.AutoRollAdvancedRune or false
Env.AutoRollCosmicRune = Env.AutoRollCosmicRune or false
Env.AutoRollFootballRune = Env.AutoRollFootballRune or false
Env.AutoRollSnowyRune = Env.AutoRollSnowyRune or false

Env.AutoOpenT1Chest = Env.AutoOpenT1Chest or false
Env.AutoOpenT2Chest = Env.AutoOpenT2Chest or false
Env.AutoOpenClassicCapsule = Env.AutoOpenClassicCapsule or false
Env.AutoOpenFootballCapsule = Env.AutoOpenFootballCapsule or false
Env.AutoOpenSuperCapsule = Env.AutoOpenSuperCapsule or false

Env.FPSBoostMode = Env.FPSBoostMode or false
Env.ShowStatsHUD = Env.ShowStatsHUD ~= nil and Env.ShowStatsHUD or true
Env.DiscordWebhookURL = Env.DiscordWebhookURL or ""

-- HELPER FUNCTIONS HOISTED EARLY
local function tV2(b, v) 
    Env[v] = not Env[v] 
    b.Text = Env[v] and "ACTIVE" or "DISABLED" 
    b.BackgroundColor3 = Env[v] and Color3.fromRGB(20, 60, 20) or Color3.fromRGB(60, 20, 20) 
    b.TextColor3 = Env[v] and Color3.fromRGB(120, 255, 120) or Color3.fromRGB(255, 120, 120) 
    
    local card = b.Parent
    if card and card:IsA("Frame") then
        local dot = card:FindFirstChild("StatusDot")
        if dot then
            dot.BackgroundColor3 = Env[v] and Color3.fromRGB(80, 255, 80) or Color3.fromRGB(255, 80, 80)
        end
    end
    saveConfigToSlot(Env.SelectedConfigSlot)
end

local function toggleFPSBoost(b)
    Env.FPSBoostMode = not Env.FPSBoostMode
    b.Text = Env.FPSBoostMode and "ACTIVE" or "DISABLED"
    b.BackgroundColor3 = Env.FPSBoostMode and Color3.fromRGB(20, 60, 20) or Color3.fromRGB(60, 20, 20)
    b.TextColor3 = Env.FPSBoostMode and Color3.fromRGB(120, 255, 120) or Color3.fromRGB(255, 120, 120)
    local dot = b.Parent:FindFirstChild("StatusDot")
    if dot then dot.BackgroundColor3 = Env.FPSBoostMode and Color3.fromRGB(80, 255, 80) or Color3.fromRGB(255, 80, 80) end
    saveConfigToSlot(Env.SelectedConfigSlot)
    
    if Env.FPSBoostMode then
        pcall(function()
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 9e9
            for _, v in ipairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.Material = Enum.Material.SmoothPlastic
                    v.Reflectance = 0
                elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                    v.Enabled = false
                end
            end
        end)
        showToast("FPS Booster Enabled!")
    else
        showToast("FPS Booster Disabled!")
    end
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

-- UI MASTER ALLOCATION (Compact Height: 350)
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
statsHud.Size = UDim2.new(0, 170, 0, 84)
statsHud.Position = UDim2.new(0, 15, 0, 15) 
statsHud.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
statsHud.BackgroundTransparency = 0.35
statsHud.BorderSizePixel = 0
statsHud.Parent = sg
Instance.new("UICorner", statsHud).CornerRadius = UDim.new(0, 8)

local hudTitle = Instance.new("TextLabel")
hudTitle.Size = UDim2.new(1, 0, 0, 20)
hudTitle.Position = UDim2.new(0, 0, 0, 2)
hudTitle.BackgroundTransparency = 1
hudTitle.TextColor3 = Color3.fromRGB(0, 136, 255)
hudTitle.TextSize = 10
hudTitle.Font = Enum.Font.SourceSansBold
hudTitle.Text = "PERFORMANCE HUD"
hudTitle.Parent = statsHud

local hudText = Instance.new("TextLabel")
hudText.Size = UDim2.new(1, -10, 1, -22)
hudText.Position = UDim2.new(0, 5, 0, 22)
hudText.BackgroundTransparency = 1
hudText.TextColor3 = Color3.fromRGB(220, 220, 225)
hudText.TextSize = 10
hudText.Font = Enum.Font.SourceSans
hudText.TextXAlignment = Enum.TextXAlignment.Left
hudText.TextYAlignment = Enum.TextYAlignment.Top
hudText.TextWrapped = true
hudText.Text = "Uptime: 00:00:00\nFPS: 60 | Ping: 0ms\nActive Features: 0"
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
            
            local pingVal = 0
            pcall(function()
                pingVal = math.floor((player:GetNetworkPing() or 0) * 1000)
            end)
            
            local activeCount = 0
            for k, v in pairs(Env) do
                if type(v) == "boolean" and v == true and k ~= "AntiAFK" and k ~= "FPSBoostMode" and k ~= "ShowStatsHUD" and k ~= "CPUSaverMode" then
                    activeCount = activeCount + 1
                end
            end
            
            hudText.Text = string.format("Uptime: %02d:%02d:%02d\nFPS: %d | Ping: %dms\nActive Features: %d", hours, mins, secs, fps, pingVal, activeCount)
        else
            statsHud.Visible = false
        end
    end
end)

local mainFrame = Instance.new("Frame") 
mainFrame.Size = UDim2.new(0, 540, 0, 350) 
mainFrame.Position = UDim2.new(0.5, -270, 0.5, -175) 
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25) 
mainFrame.BackgroundTransparency = 0.35; mainFrame.BorderSizePixel = 0; mainFrame.Parent = sg
local mainCorner = Instance.new("UICorner") mainCorner.CornerRadius = UDim.new(0, 10) mainCorner.Parent = mainFrame

local headerTitle = Instance.new("TextLabel") headerTitle.Size = UDim2.new(0.5, 0, 0, 30) headerTitle.Position = UDim2.new(0, 12, 0, 4) headerTitle.BackgroundTransparency = 1; headerTitle.TextColor3 = Color3.fromRGB(245, 245, 250) headerTitle.TextSize = 15; headerTitle.Font = Enum.Font.SourceSansBold; headerTitle.Text = "Dominate Hub | V12.2 Pro" headerTitle.TextXAlignment = Enum.TextXAlignment.Left; headerTitle.Parent = mainFrame

-- FLOATING PILL
local minBtn = Instance.new("TextButton") 
minBtn.Size = UDim2.new(0, 105, 0, 26) 
minBtn.Position = UDim2.new(0.5, -52, 0.01, 0) 
minBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 20) 
minBtn.BackgroundTransparency = 0.70 
minBtn.TextColor3 = Color3.fromRGB(0, 136, 255) 
minBtn.TextSize = 11; minBtn.Font = Enum.Font.SourceSansBold; minBtn.Text = "Dominate Hub" 
minBtn.Parent = sg
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 13)

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
        minBtn.TextColor3 = Color3.fromRGB(0, 215, 110)
    else
        mainFrame.Size = UDim2.new(0, 0, 0, 0)
        mainFrame.BackgroundTransparency = 1
        mainFrame.Visible = true
        local tween = TweenService:Create(mainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 540, 0, 350), BackgroundTransparency = 0.35})
        tween:Play()
        minBtn.TextColor3 = Color3.fromRGB(0, 136, 255)
    end
end)

-- SCROLLING TOP TABS CONTAINER
local tabScroll = Instance.new("ScrollingFrame")
tabScroll.Size = UDim2.new(1, -20, 0, 30)
tabScroll.Position = UDim2.new(0, 10, 0, 36)
tabScroll.BackgroundTransparency = 1
tabScroll.BorderSizePixel = 0
tabScroll.CanvasSize = UDim2.new(0, 500, 0, 0)
tabScroll.ScrollBarThickness = 2
tabScroll.ScrollBarImageColor3 = Color3.fromRGB(0, 136, 255)
tabScroll.Parent = mainFrame

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0, 6)
tabLayout.Parent = tabScroll

local function makeMainTab(txt)
    local t = Instance.new("TextButton")
    t.Size = UDim2.new(0, 75, 1, 0)
    t.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
    t.TextColor3 = Color3.fromRGB(210, 210, 220)
    t.TextSize = 10
    t.Font = Enum.Font.SourceSansBold
    t.Text = txt
    t.Parent = tabScroll
    Instance.new("UICorner", t).CornerRadius = UDim.new(0, 6)
    
    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(160, 160, 175))
    }
    grad.Rotation = 90
    grad.Parent = t
    return t
end

local tabUpgrades = makeMainTab("Upgrades") tabUpgrades.BackgroundColor3 = Color3.fromRGB(240, 240, 245) tabUpgrades.TextColor3 = Color3.fromRGB(15, 15, 15)
local tabNoobs = makeMainTab("Noobs")
local tabMines = makeMainTab("Mines")
local tabFootball = makeMainTab("Football")
local tabMisc = makeMainTab("Misc")
local tabSettings = makeMainTab("Settings")

-- PAGE CONTAINERS
local function makePage()
    local p = Instance.new("Frame") p.Size = UDim2.new(1, -20, 1, -72) p.Position = UDim2.new(0, 10, 0, 68) p.BackgroundTransparency = 1; p.Visible = false; p.Parent = mainFrame return p
end
local upgradesPage, noobsPage, minesPage, footballPage, miscPage, settingsPage = makePage(), makePage(), makePage(), makePage(), makePage(), makePage()
upgradesPage.Visible = true

-- SIDEBAR GENERATOR
local function makeSidebar(parent)
    local sb = Instance.new("ScrollingFrame") sb.Size = UDim2.new(0, 95, 1, -5) sb.Position = UDim2.new(0, 0, 0, 5) sb.BackgroundTransparency = 1; sb.BorderSizePixel = 0; sb.ScrollBarThickness = 2; sb.ScrollBarImageColor3 = Color3.fromRGB(0, 136, 255); sb.Parent = parent
    local list = Instance.new("UIListLayout") list.Padding = UDim.new(0, 4) list.Parent = sb
    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() sb.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 10) end)
    return sb
end

local function makeSideBtn(txt, parent)
    local b = Instance.new("TextButton") b.Size = UDim2.new(1, -5, 0, 26) b.BackgroundColor3 = Color3.fromRGB(55, 55, 65) b.TextColor3 = Color3.fromRGB(210, 210, 220) b.Font = Enum.Font.SourceSansBold; b.TextSize = 10; b.Text = txt; b.Parent = parent
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    
    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(170, 170, 185))
    }
    grad.Rotation = 90
    grad.Parent = b
    return b
end

-- 2-COLUMN SCROLL GENERATOR
local function makeGridScroll(parent, hasSidebar)
    local s = Instance.new("ScrollingFrame")
    if hasSidebar then s.Size = UDim2.new(1, -105, 1, -5) s.Position = UDim2.new(0, 105, 0, 5) else s.Size = UDim2.new(1, 0, 1, -5) s.Position = UDim2.new(0, 0, 0, 5) end
    s.BackgroundTransparency = 1; s.BorderSizePixel = 0; s.ScrollBarThickness = 3; s.ScrollBarImageColor3 = Color3.fromRGB(0, 136, 255); s.Visible = false; s.Parent = parent 
    
    local grid = Instance.new("UIGridLayout") grid.CellSize = UDim2.new(0.5, -6, 0, 30) grid.CellPadding = UDim2.new(0, 6, 0, 5) grid.SortOrder = Enum.SortOrder.LayoutOrder; grid.Parent = s
    grid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() s.CanvasSize = UDim2.new(0, 0, 0, grid.AbsoluteContentSize.Y + 10) end)
    return s 
end

-- SINGLE-COLUMN STACKED VERTICAL SCROLL GENERATOR
local function makeVerticalScroll(parent, hasSidebar)
    local s = Instance.new("ScrollingFrame")
    if hasSidebar then s.Size = UDim2.new(1, -105, 1, -5) s.Position = UDim2.new(0, 105, 0, 5) else s.Size = UDim2.new(1, 0, 1, -5) s.Position = UDim2.new(0, 0, 0, 5) end
    s.BackgroundTransparency = 1; s.BorderSizePixel = 0; s.ScrollBarThickness = 3; s.ScrollBarImageColor3 = Color3.fromRGB(0, 136, 255); s.Visible = false; s.Parent = parent 
    
    local list = Instance.new("UIListLayout") list.Padding = UDim.new(0, 6) list.SortOrder = Enum.SortOrder.LayoutOrder; list.Parent = s
    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() s.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 10) end)
    return s 
end

-- REGISTRY FOR UI BUTTON SYNC
local registeredButtons = {}

local function gridRow(txt, scr, vKey)
    local f = Instance.new("Frame") f.BackgroundColor3 = Color3.fromRGB(35, 35, 45) f.BorderSizePixel = 0; f.Parent = scr

    local dot = Instance.new("Frame")
    dot.Name = "StatusDot"
    dot.Size = UDim2.new(0, 5, 0, 5)
    dot.Position = UDim2.new(0, 6, 0.5, -2)
    dot.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    dot.BorderSizePixel = 0
    dot.Parent = f
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    local l = Instance.new("TextLabel") l.Size = UDim2.new(0.58, -8, 1, 0) l.Position = UDim2.new(0, 16, 0, 0) l.BackgroundTransparency = 1; l.TextColor3 = Color3.fromRGB(230, 230, 235) l.TextSize = 10; l.Font = Enum.Font.SourceSansBold; l.Text = txt; l.TextXAlignment = Enum.TextXAlignment.Left; l.TextWrapped = true; l.Parent = f
    local b = Instance.new("TextButton") b.Size = UDim2.new(0.40, -4, 0, 20) b.Position = UDim2.new(0.58, 0, 0.5, -10) b.BackgroundColor3 = Color3.fromRGB(60, 20, 20) b.TextColor3 = Color3.fromRGB(255, 120, 120) b.TextSize = 10; b.Font = Enum.Font.SourceSansBold; b.Text = "DISABLED" b.Parent = f
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 5) Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4) 
    
    if vKey then
        table.insert(registeredButtons, {Btn = b, Var = vKey, Dot = dot})
    end
    return b
end

-- ======================================================================================
-- UPGRADES PAGE
-- ======================================================================================
local upSidebar = makeSidebar(upgradesPage)
local bUpR1 = makeSideBtn("Realm 1", upSidebar) bUpR1.BackgroundColor3 = Color3.fromRGB(240, 240, 245) bUpR1.TextColor3 = Color3.fromRGB(15, 15, 15)
local bUpR2 = makeSideBtn("Realm 2", upSidebar)
local bUpR3 = makeSideBtn("Realm 3", upSidebar)

local upScrollR1 = makeGridScroll(upgradesPage, true) upScrollR1.Visible = true
local upScrollR2 = makeGridScroll(upgradesPage, true)
local upScrollR3 = makeGridScroll(upgradesPage, true)

local function masterToggle(txt, flagsTable, scr)
    local f = Instance.new("Frame") f.BackgroundColor3 = Color3.fromRGB(35, 35, 45) f.BorderSizePixel = 0; f.Parent = scr
    local dot = Instance.new("Frame") dot.Name = "StatusDot" dot.Size = UDim2.new(0, 5, 0, 5) dot.Position = UDim2.new(0, 6, 0.5, -2) dot.BackgroundColor3 = Color3.fromRGB(255, 80, 80) dot.BorderSizePixel = 0; dot.Parent = f
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    local l = Instance.new("TextLabel") l.Size = UDim2.new(0.55, -8, 1, 0) l.Position = UDim2.new(0, 16, 0, 0) l.BackgroundTransparency = 1; l.TextColor3 = Color3.fromRGB(230, 230, 235) l.TextSize = 10; l.Font = Enum.Font.SourceSansBold; l.Text = txt; l.TextXAlignment = Enum.TextXAlignment.Left; l.TextWrapped = true; l.Parent = f
    local b = Instance.new("TextButton") b.Size = UDim2.new(0.42, -4, 0, 20) b.Position = UDim2.new(0.57, 0, 0.5, -10) b.BackgroundColor3 = Color3.fromRGB(60, 20, 20) b.TextColor3 = Color3.fromRGB(255, 120, 120) b.TextSize = 9; b.Font = Enum.Font.SourceSansBold; b.Text = "DISABLED" b.Parent = f
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 5) Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)

    b.MouseButton1Click:Connect(function()
        local activeState = false
        for _, flag in ipairs(flagsTable) do
            if not Env[flag] then activeState = true break end
        end
        for _, flag in ipairs(flagsTable) do
            Env[flag] = activeState
        end
        b.Text = activeState and "ACTIVE" or "DISABLED"
        b.BackgroundColor3 = activeState and Color3.fromRGB(20, 60, 20) or Color3.fromRGB(60, 20, 20)
        b.TextColor3 = activeState and Color3.fromRGB(120, 255, 120) or Color3.fromRGB(255, 120, 120)
        dot.BackgroundColor3 = activeState and Color3.fromRGB(80, 255, 80) or Color3.fromRGB(255, 80, 80)
        saveConfigToSlot(Env.SelectedConfigSlot)
    end)
    return b
end

masterToggle("Fire Upgrades", {"AutoFireMoreFire", "AutoFireMoreBulk", "AutoFireMoreOof", "AutoFireMoreRebirth", "AutoFireMoreTierLuck", "AutoFireMoreCashBonus"}, upScrollR1)
masterToggle("Rebirth Upgrades", {"AutoRebirthMoreOof", "AutoRebirthMoreRebirth", "AutoRebirthMoreFire"}, upScrollR1)
masterToggle("Blaze Upgrades", {"AutoBlazeConvert", "AutoBlazeMoreBlaze", "AutoBlazeMoreFire", "AutoBlazeMoreOof", "AutoBlazeMoreOofs", "AutoBlazeMoreBulk"}, upScrollR1)
masterToggle("Bread Upgrades", {"AutoDepositWheat", "AutoBreadMoreBread", "AutoBreadMoreBread2", "AutoBreadMoreWheat", "AutoBreadBiggerWheatDeposit", "AutoBreadFasterWheatConversion", "AutoBreadMoreConsumption", "AutoBreadMoreRuneLuck", "AutoBreadMoreTierLuck", "AutoUpgradeCow", "AutoUpgradeChicken", "AutoBuyCow", "AutoBuyChicken"}, upScrollR1)
masterToggle("Cash Upgrades", {"AutoFarmCash", "AutoUpgradeMoreCash", "AutoUpgradeFasterDropper", "AutoUpgradeMoreRuneLuck", "AutoTycoonReset"}, upScrollR1)
masterToggle("Hacker Upgrades", {"AutoUpgradeHacker1", "AutoUpgradeHacker2", "AutoUpgradeHacker3", "AutoUpgradeHacker4"}, upScrollR1)

masterToggle("Ice Upgrades", {"AutoRealm2MoreIce", "AutoRealm2WaterPump1", "AutoRealm2WaterPump2", "AutoRealm2MoreOofIce"}, upScrollR2)
masterToggle("Bucket Upgrades", {"AutoFillBucket1", "AutoFillBucket2", "AutoFillBucket3", "AutoFillBucket4", "AutoFillBucket5", "AutoFillBucket6", "AutoFillBucket7", "AutoFillBucket8", "AutoFillBucket9", "AutoFillBucket10", "AutoFillBucket11"}, upScrollR2)
masterToggle("Water Upgrades", {"AutoRealm2MoreWater", "AutoRealm2MoreOofWater", "AutoRealm2MorePlanks"}, upScrollR2)
masterToggle("Wood Upgrades", {"AutoWoodRankUp", "AutoWoodMoreWood", "AutoWoodSharperAxes", "AutoWoodBiggerDeposit", "AutoWoodFasterConversion", "AutoWoodMorePlanks", "AutoDepositWood"}, upScrollR2)
masterToggle("Planks Upgrades", {"AutoPlanksMorePlanks", "AutoPlanksMoreWood", "AutoPlanksWaterFromPlanks"}, upScrollR2)
masterToggle("Gem Upgrades", {"AutoGemMoreOof", "AutoGemMoreGems", "AutoGemStrongerPickaxes", "AutoGemMoreOreStats", "AutoGemExchange"}, upScrollR2)

masterToggle("Pharaoh Upgrades", {"AutoUpgradePharaoh"}, upScrollR3)

-- ======================================================================================
-- NOOBS PAGE
-- ======================================================================================
local noobSidebar = makeSidebar(noobsPage)
local bNoobR1 = makeSideBtn("Realm 1 Noobs", noobSidebar) bNoobR1.BackgroundColor3 = Color3.fromRGB(240, 240, 245) bNoobR1.TextColor3 = Color3.fromRGB(15, 15, 15)
local bNoobR2 = makeSideBtn("Realm 2 Noobs", noobSidebar)

local noobScrollR1 = makeGridScroll(noobsPage, true) noobScrollR1.Visible = true
local noobScrollR2 = makeGridScroll(noobsPage, true)

UI.Starter = gridRow("Starter Auto Upgrade", noobScrollR1, "AutoUpgradeStarter") 
UI.Cooker = gridRow("Cooker Auto Upgrade", noobScrollR1, "AutoUpgradeCooker") 
UI.Farmer = gridRow("Farmer Auto Upgrade", noobScrollR1, "AutoUpgradeFarmer") 
UI.Magician = gridRow("Magician Auto Upgrade", noobScrollR1, "AutoUpgradeMagician") 
UI.Archer = gridRow("Archer Auto Upgrade", noobScrollR1, "AutoUpgradeArcher") 
UI.Soldier = gridRow("Soldier Auto Upgrade", noobScrollR1, "AutoUpgradeSoldier")
UI.MoreOof = gridRow("More Oof Auto Upgrade", noobScrollR1, "AutoUpgradeMoreOof") 
UI.FasterNoobs = gridRow("Faster Noobs Upgrade", noobScrollR1, "AutoUpgradeFasterNoobs")

UI.R2Fisherman = gridRow("Auto Upgrade Fisherman", noobScrollR2, "AutoUpgradeFishermanNoob") 
UI.R2Knight = gridRow("Auto Upgrade Knight", noobScrollR2, "AutoUpgradeKnightNoob") 
UI.R2Explorer = gridRow("Auto Upgrade Explorer", noobScrollR2, "AutoUpgradeExplorerNoob") 
UI.R2Magician = gridRow("Auto Upgrade Magician", noobScrollR2, "AutoUpgradeMagicianNoob")

-- ======================================================================================
-- MINES PAGE
-- ======================================================================================
local minesScroll = makeVerticalScroll(minesPage, false) minesScroll.Visible = true

local bestTierActive = false
local bestTierBtn = Instance.new("TextButton")
bestTierBtn.Size = UDim2.new(1, -6, 0, 28)
bestTierBtn.BackgroundColor3 = Color3.fromRGB(60, 20, 20)
bestTierBtn.TextColor3 = Color3.fromRGB(255, 120, 120)
bestTierBtn.TextSize = 11
bestTierBtn.Font = Enum.Font.SourceSansBold
bestTierBtn.Text = "Best Tier Only: DISABLED"
bestTierBtn.Parent = minesScroll
Instance.new("UICorner", bestTierBtn).CornerRadius = UDim.new(0, 5)

bestTierBtn.MouseButton1Click:Connect(function()
    bestTierActive = not bestTierActive
    bestTierBtn.Text = bestTierActive and "Best Tier Only: ACTIVE" or "Best Tier Only: DISABLED"
    bestTierBtn.BackgroundColor3 = bestTierActive and Color3.fromRGB(20, 60, 20) or Color3.fromRGB(60, 20, 20)
    bestTierBtn.TextColor3 = bestTierActive and Color3.fromRGB(120, 255, 120) or Color3.fromRGB(255, 120, 120)

    local topOres = {"AutoMineVoidsteel", "AutoMineCelestium", "AutoMineRuby"}
    local allOres = {
        "AutoMineStone", "AutoMineCoal", "AutoMineSilver", "AutoMineIron", "AutoMineCopper",
        "AutoMineGold", "AutoMinePlatinum", "AutoMineTitanium", "AutoMineCobalt", "AutoMineUranium",
        "AutoMinePalladium", "AutoMineAetherite", "AutoMineRuby", "AutoMineVoidsteel", "AutoMineCelestium"
    }
    
    for _, ore in ipairs(allOres) do
        Env[ore] = false
    end
    
    if bestTierActive then
        for _, ore in ipairs(topOres) do
            Env[ore] = true
        end
    end
    
    saveConfigToSlot(Env.SelectedConfigSlot)
    syncAllUI()
    showToast(bestTierActive and "Best Tier Only ores activated!" or "Best Tier Only deactivated.")
end)

local function mineSectionHeader(txt, scr)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -6, 0, 24)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(130, 130, 145)
    lbl.TextSize = 10
    lbl.Font = Enum.Font.SourceSansBold
    lbl.Text = txt
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = scr
end

local function sleekMineRow(txt, scr, vKey)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -6, 0, 26)
    f.BackgroundTransparency = 1
    f.BorderSizePixel = 0
    f.Parent = scr

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(0.58, -8, 1, 0)
    l.Position = UDim2.new(0, 16, 0, 0)
    l.BackgroundTransparency = 1
    l.TextColor3 = Color3.fromRGB(180, 180, 195)
    l.TextSize = 10
    l.Font = Enum.Font.SourceSans
    l.Text = txt
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f

    local dot = Instance.new("Frame")
    dot.Name = "StatusDot"
    dot.Size = UDim2.new(0, 4, 0, 4)
    dot.Position = UDim2.new(0, 6, 0.5, -2)
    dot.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    dot.BorderSizePixel = 0
    dot.Parent = f
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.40, -4, 0, 20)
    b.Position = UDim2.new(0.58, 0, 0.5, -10)
    b.BackgroundColor3 = Color3.fromRGB(60, 20, 20)
    b.TextColor3 = Color3.fromRGB(255, 120, 120)
    b.TextSize = 9
    b.Font = Enum.Font.SourceSansBold
    b.Text = "DISABLED"
    b.Parent = f
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)

    UI[vKey] = b
    table.insert(registeredButtons, {Btn = b, Var = vKey, Dot = dot})
    return b
end

mineSectionHeader("Basic Ores", minesScroll)
UI.MineStone = sleekMineRow("Stone", minesScroll, "AutoMineStone")
UI.MineCoal = sleekMineRow("Coal", minesScroll, "AutoMineCoal")
UI.MineSilver = sleekMineRow("Silver", minesScroll, "AutoMineSilver")
UI.MineIron = sleekMineRow("Iron", minesScroll, "AutoMineIron")
UI.MineCopper = sleekMineRow("Copper", minesScroll, "AutoMineCopper")

mineSectionHeader("Advanced Ores", minesScroll)
UI.MineGold = sleekMineRow("Gold", minesScroll, "AutoMineGold")
UI.MinePlatinum = sleekMineRow("Platinum", minesScroll, "AutoMinePlatinum")
UI.MineTitanium = sleekMineRow("Titanium", minesScroll, "AutoMineTitanium")
UI.MineCobalt = sleekMineRow("Cobalt", minesScroll, "AutoMineCobalt")
UI.MineUranium = sleekMineRow("Uranium", minesScroll, "AutoMineUranium")

mineSectionHeader("End-Game Ores", minesScroll)
UI.MinePalladium = sleekMineRow("Palladium", minesScroll, "AutoMinePalladium")
UI.MineAetherite = sleekMineRow("Aetherite", minesScroll, "AutoMineAetherite")
UI.MineRuby = sleekMineRow("Ruby", minesScroll, "AutoMineRuby")
UI.MineVoidsteel = sleekMineRow("Voidsteel", minesScroll, "AutoMineVoidsteel")
UI.MineCelestium = sleekMineRow("Celestium", minesScroll, "AutoMineCelestium")

-- ======================================================================================
-- FOOTBALL PAGE
-- ======================================================================================
local fSidebar = makeSidebar(footballPage)
local bFNoobs = makeSideBtn("Noobs", fSidebar) bFNoobs.BackgroundColor3 = Color3.fromRGB(240, 240, 245) bFNoobs.TextColor3 = Color3.fromRGB(15, 15, 15)
local bFUpgrades = makeSideBtn("Upgrades", fSidebar)
local fNoobScroll = makeGridScroll(footballPage, true) fNoobScroll.Visible = true
local fUpgradeScroll = makeGridScroll(footballPage, true)

UI.Goalkeeper = gridRow("Upgrade Goalkeeper", fNoobScroll, "AutoUpgradeGoalkeeper") 
UI.LeftBack = gridRow("Upgrade Left Back", fNoobScroll, "AutoUpgradeLeftBack") 
UI.LeftCenterBack = gridRow("Upgrade L-Center Back", fNoobScroll, "AutoUpgradeLeftCenterBack") 
UI.RightCenterBack = gridRow("Upgrade R-Center Back", fNoobScroll, "AutoUpgradeRightCenterBack") 
UI.RightBack = gridRow("Upgrade Right Back", fNoobScroll, "AutoUpgradeRightBack") 
UI.LeftDefensiveMid = gridRow("Upgrade L-Defensive Mid", fNoobScroll, "AutoUpgradeLeftDefensiveMid") 
UI.RightDefensiveMid = gridRow("Upgrade R-Defensive Mid", fNoobScroll, "AutoUpgradeRightDefensiveMid") 
UI.AttackingMid = gridRow("Upgrade Attacking Mid", fNoobScroll, "AutoUpgradeAttackingMid") 
UI.LeftWing = gridRow("Upgrade Left Wing", fNoobScroll, "AutoUpgradeLeftWing") 
UI.RightWing = gridRow("Upgrade Right Wing", fNoobScroll, "AutoUpgradeRightWing") 
UI.Striker = gridRow("Upgrade Striker", fNoobScroll, "AutoUpgradeStriker")

UI.ScoreGoal = gridRow("Auto Score Goal", fUpgradeScroll, "AutoScoreGoal") 
UI.MoreGoals = gridRow("More Goals Upgrade", fUpgradeScroll, "AutoGoalsMoreGoals") 
UI.GoalsRuneBulk = gridRow("Goals Rune Bulk", fUpgradeScroll, "AutoGoalsRuneBulk") 
UI.GoalsRuneLuck = gridRow("Goals Rune Luck", fUpgradeScroll, "AutoGoalsRuneLuck") 
UI.AutoBuyKicker = gridRow("Auto-Buy Auto Kick", fUpgradeScroll, "AutoBuyAutoKick") 
UI.FootballTree = gridRow("Auto Football Tree", fUpgradeScroll, "AutoFootballTree") 
UI.ClaimTrophies = gridRow("Auto Buy Trophies", fUpgradeScroll, "AutoClaimTrophies")

-- ======================================================================================
-- MISC PAGE
-- ======================================================================================
local miscSidebar = makeSidebar(miscPage)
local bMiscRu1 = makeSideBtn("Runes R1", miscSidebar) bMiscRu1.BackgroundColor3 = Color3.fromRGB(240, 240, 245) bMiscRu1.TextColor3 = Color3.fromRGB(15, 15, 15)
local bMiscRu2 = makeSideBtn("Runes R2", miscSidebar)
local bMiscRuE = makeSideBtn("Runes Events", miscSidebar)
local bMiscCap = makeSideBtn("Capsules", miscSidebar)

local miscScrollRu1 = makeGridScroll(miscPage, true) miscScrollRu1.Visible = true
local miscScrollRu2 = makeGridScroll(miscPage, true)
local miscScrollRuE = makeGridScroll(miscPage, true)
local miscScrollCap = makeGridScroll(miscPage, true)

UI.RollBasicRuneCard = gridRow("Auto Basic Rune Circle", miscScrollRu1, "AutoRollBasicRune") 
UI.RollSuperRuneCard = gridRow("Auto Super Rune Circle", miscScrollRu1, "AutoRollSuperRune") 
UI.RollAdvancedRuneCard = gridRow("Auto Advanced Rune", miscScrollRu1, "AutoRollAdvancedRune") 
UI.RollCosmicRuneCard = gridRow("Auto Cosmic Prism", miscScrollRu1, "AutoRollCosmicRune")

UI.RollSnowyRuneCard = gridRow("Auto Snowy Rune Circle", miscScrollRu2, "AutoRollSnowyRune")

UI.FootballRuneCard = gridRow("Auto Football Rune", miscScrollRuE, "AutoRollFootballRune")

UI.ClassicCapsule = gridRow("Hatch Classic Capsule", miscScrollCap, "AutoOpenClassicCapsule") 
UI.FootballCapsule = gridRow("Hatch Football Capsule", miscScrollCap, "AutoOpenFootballCapsule") 
UI.SuperCapsule = gridRow("Hatch Super Capsule", miscScrollCap, "AutoOpenSuperCapsule")

-- ======================================================================================
-- SETTINGS PAGE
-- ======================================================================================
local setSidebar = makeSidebar(settingsPage)
local bSetGen = makeSideBtn("General", setSidebar) bSetGen.BackgroundColor3 = Color3.fromRGB(240, 240, 245) bSetGen.TextColor3 = Color3.fromRGB(15, 15, 15)
local bSetConfig = makeSideBtn("Config", setSidebar)

local setGenScroll = makeVerticalScroll(settingsPage, true) setGenScroll.Visible = true
local setConfigScroll = makeVerticalScroll(settingsPage, true)

for i = 1, 5 do
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -6, 0, 32)
    row.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    row.BorderSizePixel = 0
    row.Parent = setConfigScroll
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 5)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 50, 1, 0)
    label.Position = UDim2.new(0, 8, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(220, 220, 225)
    label.TextSize = 11
    label.Font = Enum.Font.SourceSansBold
    label.Text = "Slot " .. i
    label.Parent = row

    local loadBtn = Instance.new("TextButton")
    loadBtn.Size = UDim2.new(0, 55, 0, 22)
    loadBtn.AnchorPoint = Vector2.new(1, 0.5)
    loadBtn.Position = UDim2.new(1, -4, 0.5, 0)
    loadBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 120)
    loadBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    loadBtn.TextSize = 9
    loadBtn.Font = Enum.Font.SourceSansBold
    loadBtn.Text = "LOAD"
    loadBtn.Parent = row
    Instance.new("UICorner", loadBtn).CornerRadius = UDim.new(0, 4)

    local saveBtn = Instance.new("TextButton")
    saveBtn.Size = UDim2.new(0, 55, 0, 22)
    saveBtn.AnchorPoint = Vector2.new(1, 0.5)
    saveBtn.Position = UDim2.new(1, -63, 0.5, 0)
    saveBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 50)
    saveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    saveBtn.TextSize = 9
    saveBtn.Font = Enum.Font.SourceSansBold
    saveBtn.Text = "SAVE"
    saveBtn.Parent = row
    Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0, 4)

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -180, 0, 22)
    box.Position = UDim2.new(0, 58, 0.5, -11)
    box.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.TextSize = 10
    box.Font = Enum.Font.SourceSansBold
    box.Text = slotCustomNames[i]
    box.Parent = row
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)

    box:GetPropertyChangedSignal("Text"):Connect(function()
        slotCustomNames[i] = box.Text
    end)

    saveBtn.MouseButton1Click:Connect(function()
        saveConfigToSlot(i, box.Text)
        showToast("Saved to Slot " .. i .. " (" .. box.Text .. ")")
    end)

    loadBtn.MouseButton1Click:Connect(function()
        Env.SelectedConfigSlot = i
        loadConfigFromSlot(i)
        box.Text = slotCustomNames[i]
        showToast("Loaded Slot " .. i .. " (" .. slotCustomNames[i] .. ")")
    end)
end

local function genRow(txt, vKey, callback)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -6, 0, 32)
    f.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    f.BorderSizePixel = 0
    f.Parent = setGenScroll
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 5)

    local dot = Instance.new("Frame")
    dot.Name = "StatusDot"
    dot.Size = UDim2.new(0, 5, 0, 5)
    dot.Position = UDim2.new(0, 6, 0.5, -2)
    dot.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    dot.BorderSizePixel = 0
    dot.Parent = f
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(0.58, -8, 1, 0)
    l.Position = UDim2.new(0, 16, 0, 0)
    l.BackgroundTransparency = 1
    l.TextColor3 = Color3.fromRGB(230, 230, 235)
    l.TextSize = 10
    l.Font = Enum.Font.SourceSansBold
    l.Text = txt
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f

    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.40, -4, 0, 20)
    b.Position = UDim2.new(0.58, 0, 0.5, -10)
    b.BackgroundColor3 = Color3.fromRGB(60, 20, 20)
    b.TextColor3 = Color3.fromRGB(255, 120, 120)
    b.TextSize = 10
    b.Font = Enum.Font.SourceSansBold
    b.Text = "DISABLED"
    b.Parent = f
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)

    if vKey then
        table.insert(registeredButtons, {Btn = b, Var = vKey, Dot = dot})
    end

    if callback then
        b.MouseButton1Click:Connect(function()
            callback(b)
        end)
    end
    return b
end

local function genSpacer(h)
    local sp = Instance.new("Frame")
    sp.Size = UDim2.new(1, -6, 0, h or 12)
    sp.BackgroundTransparency = 1
    sp.Parent = setGenScroll
end

UI.AFK = genRow("Anti AFK Protection", "AntiAFK", function(b) tV2(b, "AntiAFK") end)
UI.FPSBoostToggle = genRow("FPS Booster Mode", "FPSBoostMode", function(b) toggleFPSBoost(b) end)
UI.HUDToggle = genRow("Stats HUD Overlay", "ShowStatsHUD", function(b)
    Env.ShowStatsHUD = not Env.ShowStatsHUD
    b.Text = Env.ShowStatsHUD and "ACTIVE" or "DISABLED"
    b.BackgroundColor3 = Env.ShowStatsHUD and Color3.fromRGB(20, 60, 20) or Color3.fromRGB(60, 20, 20)
    b.TextColor3 = Env.ShowStatsHUD and Color3.fromRGB(120, 255, 120) or Color3.fromRGB(255, 120, 120)
    local dot = b.Parent:FindFirstChild("StatusDot")
    if dot then dot.BackgroundColor3 = Env.ShowStatsHUD and Color3.fromRGB(80, 255, 80) or Color3.fromRGB(255, 80, 80) end
    saveConfigToSlot(Env.SelectedConfigSlot)
end)

UI.CPUSaverToggle = genRow("CPU Saver Mode", "CPUSaverMode", function(b) 
    Env.CPUSaverMode = not Env.CPUSaverMode
    b.Text = Env.CPUSaverMode and "ACTIVE" or "DISABLED"
    b.BackgroundColor3 = Env.CPUSaverMode and Color3.fromRGB(20, 60, 20) or Color3.fromRGB(60, 20, 20)
    b.TextColor3 = Env.CPUSaverMode and Color3.fromRGB(120, 255, 120) or Color3.fromRGB(255, 120, 120)
    local dot = b.Parent:FindFirstChild("StatusDot")
    if dot then dot.BackgroundColor3 = Env.CPUSaverMode and Color3.fromRGB(80, 255, 80) or Color3.fromRGB(255, 80, 80) end
    saveConfigToSlot(Env.SelectedConfigSlot)
    showToast(Env.CPUSaverMode and "CPU Saver Mode Enabled (Background loops throttled)" or "CPU Saver Mode Disabled")
end)

UI.TycoonTeleportToggle = genRow("Tycoon Teleport to Pad", "AutoTycoonTeleport", function(b) tV2(b, "AutoTycoonTeleport") end)

genSpacer(10)

UI.RebirthTimerCard = genRow("Auto Rebirth", "AutoRebirthTimer", function(b) tV2(b, "AutoRebirthTimer") end)
UI.Prestige = genRow("Auto Prestige", "AutoPrestige", function(b) tV2(b, "AutoPrestige") end)
UI.OpenT1ChestCard = genRow("Mass Open T1 Chest", "AutoOpenT1Chest", function(b) tV2(b, "AutoOpenT1Chest") end)
UI.OpenT2ChestCard = genRow("Mass Open T2 Chest", "AutoOpenT2Chest", function(b) tV2(b, "AutoOpenT2Chest") end)

genSpacer(10)

local speedRow = Instance.new("Frame")
speedRow.Size = UDim2.new(1, -6, 0, 32)
speedRow.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
speedRow.BorderSizePixel = 0
speedRow.Parent = setGenScroll
Instance.new("UICorner", speedRow).CornerRadius = UDim.new(0, 5)

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.58, -8, 1, 0)
speedLabel.Position = UDim2.new(0, 16, 0, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.fromRGB(230, 230, 235)
speedLabel.TextSize = 10
speedLabel.Font = Enum.Font.SourceSansBold
speedLabel.Text = "Glide Speed"
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = speedRow

UI.MiningSpeedSwitch = Instance.new("TextButton")
UI.MiningSpeedSwitch.Size = UDim2.new(0.40, -4, 0, 20)
UI.MiningSpeedSwitch.Position = UDim2.new(0.58, 0, 0.5, -10)
UI.MiningSpeedSwitch.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
UI.MiningSpeedSwitch.TextColor3 = Color3.fromRGB(255, 255, 255)
UI.MiningSpeedSwitch.TextSize = 10
UI.MiningSpeedSwitch.Font = Enum.Font.SourceSansBold
UI.MiningSpeedSwitch.Text = "0.8 S/s"
UI.MiningSpeedSwitch.Parent = speedRow
Instance.new("UICorner", UI.MiningSpeedSwitch).CornerRadius = UDim.new(0, 4)

local ms = {0.3, 0.5, 0.8, 1.2, 2.0} 
local ml = {"0.3 S/s", "0.5 S/s", "0.8 S/s", "1.2 S/s", "2.0 S/s"} 
local mi = 3
UI.MiningSpeedSwitch.MouseButton1Click:Connect(function() 
    mi = mi + 1 
    if mi > #ms then mi = 1 end 
    Env.MiningJumpSpeed = ms[mi] 
    UI.MiningSpeedSwitch.Text = ml[mi] 
    saveConfigToSlot(Env.SelectedConfigSlot) 
end)

genSpacer(10)

local themeRow = Instance.new("Frame")
themeRow.Size = UDim2.new(1, -6, 0, 32)
themeRow.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
themeRow.BorderSizePixel = 0
themeRow.Parent = setGenScroll
Instance.new("UICorner", themeRow).CornerRadius = UDim.new(0, 5)

local themeLabel = Instance.new("TextLabel")
themeLabel.Size = UDim2.new(0.58, -8, 1, 0)
themeLabel.Position = UDim2.new(0, 16, 0, 0)
themeLabel.BackgroundTransparency = 1
themeLabel.TextColor3 = Color3.fromRGB(230, 230, 235)
themeLabel.TextSize = 10
themeLabel.Font = Enum.Font.SourceSansBold
themeLabel.Text = "Hub Theme"
themeLabel.TextXAlignment = Enum.TextXAlignment.Left
themeLabel.Parent = themeRow

local themeBtn = Instance.new("TextButton")
themeBtn.Size = UDim2.new(0.40, -4, 0, 20)
themeBtn.Position = UDim2.new(0.58, 0, 0.5, -10)
themeBtn.BackgroundColor3 = Color3.fromRGB(0, 80, 160)
themeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
themeBtn.TextSize = 9
themeBtn.Font = Enum.Font.SourceSansBold
themeBtn.Text = "Theme: Neon Blue"
themeBtn.Parent = themeRow
Instance.new("UICorner", themeBtn).CornerRadius = UDim.new(0, 4)

local themes = {
    {Name = "Neon Blue", Color = Color3.fromRGB(0, 136, 255)},
    {Name = "Purple Glow", Color = Color3.fromRGB(138, 43, 226)},
    {Name = "Emerald Green", Color = Color3.fromRGB(0, 200, 100)},
    {Name = "Crimson Red", Color = Color3.fromRGB(220, 20, 60)}
}
local currentThemeIdx = 1

themeBtn.MouseButton1Click:Connect(function()
    currentThemeIdx = currentThemeIdx + 1
    if currentThemeIdx > #themes then currentThemeIdx = 1 end
    local th = themes[currentThemeIdx]
    themeBtn.Text = "Theme: " .. th.Name
    minBtn.TextColor3 = th.Color
    hudTitle.TextColor3 = th.Color
    showToast("Theme changed to " .. th.Name)
end)

local killRow = Instance.new("Frame")
killRow.Size = UDim2.new(1, -6, 0, 32)
killRow.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
killRow.BorderSizePixel = 0
killRow.Parent = setGenScroll
Instance.new("UICorner", killRow).CornerRadius = UDim.new(0, 5)

local killLabel = Instance.new("TextLabel")
killLabel.Size = UDim2.new(0.58, -8, 1, 0)
killLabel.Position = UDim2.new(0, 16, 0, 0)
killLabel.BackgroundTransparency = 1
killLabel.TextColor3 = Color3.fromRGB(255, 200, 200)
killLabel.TextSize = 10
killLabel.Font = Enum.Font.SourceSansBold
killLabel.Text = "Emergency Kill Switch"
killLabel.TextXAlignment = Enum.TextXAlignment.Left
killLabel.Parent = killRow

UI.KillSwitch = Instance.new("TextButton")
UI.KillSwitch.Size = UDim2.new(0.40, -4, 0, 20)
UI.KillSwitch.Position = UDim2.new(0.58, 0, 0.5, -10)
UI.KillSwitch.BackgroundColor3 = Color3.fromRGB(120, 20, 20)
UI.KillSwitch.TextColor3 = Color3.fromRGB(255, 200, 200)
UI.KillSwitch.TextSize = 9
UI.KillSwitch.Font = Enum.Font.SourceSansBold
UI.KillSwitch.Text = "TERMINATE"
UI.KillSwitch.Parent = killRow
Instance.new("UICorner", UI.KillSwitch).CornerRadius = UDim.new(0, 4)

UI.KillSwitch.MouseButton1Click:Connect(function()
    Running = false Env.DominateHubLoaded = nil 
    for k, _ in pairs(Env) do if type(k) == "string" and (k:sub(1,4) == "Auto" or k == "AntiAFK") then Env[k] = false end end
    pcall(function() 
        local cam = workspace.CurrentCamera if cam then cam.CameraType = Enum.CameraType.Custom end 
        local blur = Lighting:FindFirstChild("DominateHubBlur")
        if blur then blur:Destroy() end
    end) 
    sg:Destroy()
end)

-- ======================================================================================
-- UI SYNCHRONIZATION ENGINE
-- ======================================================================================
syncAllUI = function()
    for _, item in ipairs(registeredButtons) do
        local isActive = Env[item.Var] == true
        item.Btn.Text = isActive and "ACTIVE" or "DISABLED"
        item.Btn.BackgroundColor3 = isActive and Color3.fromRGB(20, 60, 20) or Color3.fromRGB(60, 20, 20)
        item.Btn.TextColor3 = isActive and Color3.fromRGB(120, 255, 120) or Color3.fromRGB(255, 120, 120)
        if item.Dot then
            item.Dot.BackgroundColor3 = isActive and Color3.fromRGB(80, 255, 80) or Color3.fromRGB(255, 80, 80)
        end
    end
end

-- WIRE UP NOOBS
UI.Starter.MouseButton1Click:Connect(function() tV2(UI.Starter, "AutoUpgradeStarter") end) 
UI.Cooker.MouseButton1Click:Connect(function() tV2(UI.Cooker, "AutoUpgradeCooker") end) 
UI.Farmer.MouseButton1Click:Connect(function() tV2(UI.Farmer, "AutoUpgradeFarmer") end) 
UI.Magician.MouseButton1Click:Connect(function() tV2(UI.Magician, "AutoUpgradeMagician") end) 
UI.Archer.MouseButton1Click:Connect(function() tV2(UI.Archer, "AutoUpgradeArcher") end) 
UI.Soldier.MouseButton1Click:Connect(function() tV2(UI.Soldier, "AutoUpgradeSoldier") end) 
UI.MoreOof.MouseButton1Click:Connect(function() tV2(UI.MoreOof, "AutoUpgradeMoreOof") end) 
UI.FasterNoobs.MouseButton1Click:Connect(function() tV2(UI.FasterNoobs, "AutoUpgradeFasterNoobs") end)

UI.R2Fisherman.MouseButton1Click:Connect(function() tV2(UI.R2Fisherman, "AutoUpgradeFishermanNoob") end) 
UI.R2Knight.MouseButton1Click:Connect(function() tV2(UI.R2Knight, "AutoUpgradeKnightNoob") end) 
UI.R2Explorer.MouseButton1Click:Connect(function() tV2(UI.R2Explorer, "AutoUpgradeExplorerNoob") end) 
UI.R2Magician.MouseButton1Click:Connect(function() tV2(UI.R2Magician, "AutoUpgradeMagicianNoob") end)

-- WIRE UP FOOTBALL
UI.Goalkeeper.MouseButton1Click:Connect(function() tV2(UI.Goalkeeper, "AutoUpgradeGoalkeeper") end) 
UI.LeftBack.MouseButton1Click:Connect(function() tV2(UI.LeftBack, "AutoUpgradeLeftBack") end) 
UI.LeftCenterBack.MouseButton1Click:Connect(function() tV2(UI.LeftCenterBack, "AutoUpgradeLeftCenterBack") end) 
UI.RightCenterBack.MouseButton1Click:Connect(function() tV2(UI.RightCenterBack, "AutoUpgradeRightCenterBack") end) 
UI.RightBack.MouseButton1Click:Connect(function() tV2(UI.RightBack, "AutoUpgradeRightBack") end) 
UI.LeftDefensiveMid.MouseButton1Click:Connect(function() tV2(UI.LeftDefensiveMid, "AutoUpgradeLeftDefensiveMid") end) 
UI.RightDefensiveMid.MouseButton1Click:Connect(function() tV2(UI.RightDefensiveMid, "AutoUpgradeRightDefensiveMid") end) 
UI.AttackingMid.MouseButton1Click:Connect(function() tV2(UI.AttackingMid, "AutoUpgradeAttackingMid") end) 
UI.LeftWing.MouseButton1Click:Connect(function() tV2(UI.LeftWing, "AutoUpgradeLeftWing") end) 
UI.RightWing.MouseButton1Click:Connect(function() tV2(UI.RightWing, "AutoUpgradeRightWing") end) 
UI.Striker.MouseButton1Click:Connect(function() tV2(UI.Striker, "AutoUpgradeStriker") end)

UI.ScoreGoal.MouseButton1Click:Connect(function() tV2(UI.ScoreGoal, "AutoScoreGoal") end) 
UI.MoreGoals.MouseButton1Click:Connect(function() tV2(UI.MoreGoals, "AutoGoalsMoreGoals") end) 
UI.GoalsRuneBulk.MouseButton1Click:Connect(function() tV2(UI.GoalsRuneBulk, "AutoGoalsRuneBulk") end) 
UI.GoalsRuneLuck.MouseButton1Click:Connect(function() tV2(UI.GoalsRuneLuck, "AutoGoalsRuneLuck") end) 
UI.AutoBuyKicker.MouseButton1Click:Connect(function() tV2(UI.AutoBuyKicker, "AutoBuyAutoKick") end) 
UI.FootballTree.MouseButton1Click:Connect(function() tV2(UI.FootballTree, "AutoFootballTree") end) 
UI.ClaimTrophies.MouseButton1Click:Connect(function() tV2(UI.ClaimTrophies, "AutoClaimTrophies") end)

-- WIRE UP RUNES & CAPSULES
UI.RollBasicRuneCard.MouseButton1Click:Connect(function() tV2(UI.RollBasicRuneCard, "AutoRollBasicRune") end) 
UI.RollSuperRuneCard.MouseButton1Click:Connect(function() tV2(UI.RollSuperRuneCard, "AutoRollSuperRune") end) 
UI.RollAdvancedRuneCard.MouseButton1Click:Connect(function() tV2(UI.RollAdvancedRuneCard, "AutoRollAdvancedRune") end) 
UI.RollCosmicRuneCard.MouseButton1Click:Connect(function() tV2(UI.RollCosmicRuneCard, "AutoRollCosmicRune") end) 
UI.RollSnowyRuneCard.MouseButton1Click:Connect(function() tV2(UI.RollSnowyRuneCard, "AutoRollSnowyRune") end) 
UI.FootballRuneCard.MouseButton1Click:Connect(function() tV2(UI.FootballRuneCard, "AutoRollFootballRune") end)

UI.ClassicCapsule.MouseButton1Click:Connect(function() tV2(UI.ClassicCapsule, "AutoOpenClassicCapsule") end) 
UI.FootballCapsule.MouseButton1Click:Connect(function() tV2(UI.FootballCapsule, "AutoOpenFootballCapsule") end) 
UI.SuperCapsule.MouseButton1Click:Connect(function() tV2(UI.SuperCapsule, "AutoOpenSuperCapsule") end)

-- WIRE UP MINES
UI.MineStone.MouseButton1Click:Connect(function() tV2(UI.MineStone, "AutoMineStone") end) 
UI.MineCoal.MouseButton1Click:Connect(function() tV2(UI.MineCoal, "AutoMineCoal") end) 
UI.MineSilver.MouseButton1Click:Connect(function() tV2(UI.MineSilver, "AutoMineSilver") end) 
UI.MineIron.MouseButton1Click:Connect(function() tV2(UI.MineIron, "AutoMineIron") end) 
UI.MineCopper.MouseButton1Click:Connect(function() tV2(UI.MineCopper, "AutoMineCopper") end) 
UI.MineGold.MouseButton1Click:Connect(function() tV2(UI.MineGold, "AutoMineGold") end) 
UI.MinePlatinum.MouseButton1Click:Connect(function() tV2(UI.MinePlatinum, "AutoMinePlatinum") end) 
UI.MineTitanium.MouseButton1Click:Connect(function() tV2(UI.MineTitanium, "AutoMineTitanium") end) 
UI.MineCobalt.MouseButton1Click:Connect(function() tV2(UI.MineCobalt, "AutoMineCobalt") end) 
UI.MineUranium.MouseButton1Click:Connect(function() tV2(UI.MineUranium, "AutoMineUranium") end) 
UI.MinePalladium.MouseButton1Click:Connect(function() tV2(UI.MinePalladium, "AutoMinePalladium") end) 
UI.MineAetherite.MouseButton1Click:Connect(function() tV2(UI.MineAetherite, "AutoMineAetherite") end) 
UI.MineRuby.MouseButton1Click:Connect(function() tV2(UI.MineRuby, "AutoMineRuby") end) 
UI.MineVoidsteel.MouseButton1Click:Connect(function() tV2(UI.MineVoidsteel, "AutoMineVoidsteel") end) 
UI.MineCelestium.MouseButton1Click:Connect(function() tV2(UI.MineCelestium, "AutoMineCelestium") end)

-- TAB ROUTERS
local function mainRoute(pOpen, bActive) 
    upgradesPage.Visible, noobsPage.Visible, minesPage.Visible, footballPage.Visible, miscPage.Visible, settingsPage.Visible = false, false, false, false, false, false; pOpen.Visible = true; 
    local tabs = {tabUpgrades, tabNoobs, tabMines, tabFootball, tabMisc, tabSettings}
    for _, t in ipairs(tabs) do t.BackgroundColor3, t.TextColor3 = Color3.fromRGB(55, 55, 65), Color3.fromRGB(210, 210, 220) end
    bActive.BackgroundColor3, bActive.TextColor3 = Color3.fromRGB(240, 240, 245), Color3.fromRGB(15, 15, 15) 
end
tabUpgrades.MouseButton1Click:Connect(function() mainRoute(upgradesPage, tabUpgrades) end) 
tabNoobs.MouseButton1Click:Connect(function() mainRoute(noobsPage, tabNoobs) end) 
tabMines.MouseButton1Click:Connect(function() mainRoute(minesPage, tabMines) end)
tabFootball.MouseButton1Click:Connect(function() mainRoute(footballPage, tabFootball) end) 
tabMisc.MouseButton1Click:Connect(function() mainRoute(miscPage, tabMisc) end)
tabSettings.MouseButton1Click:Connect(function() mainRoute(settingsPage, tabSettings) end)

local function sideRoute(tScroll, aBtn, aScrolls, aBtns)
    for i, s in ipairs(aScrolls) do s.Visible = (s == tScroll) end
    for i, b in ipairs(aBtns) do b.BackgroundColor3 = (b == aBtn) and Color3.fromRGB(240, 240, 245) or Color3.fromRGB(55, 55, 65) b.TextColor3 = (b == aBtn) and Color3.fromRGB(15, 15, 15) or Color3.fromRGB(210, 210, 220) end
end

local upS, upB = {upScrollR1, upScrollR2, upScrollR3}, {bUpR1, bUpR2, bUpR3}
bUpR1.MouseButton1Click:Connect(function() sideRoute(upScrollR1, bUpR1, upS, upB) end)
bUpR2.MouseButton1Click:Connect(function() sideRoute(upScrollR2, bUpR2, upS, upB) end)
bUpR3.MouseButton1Click:Connect(function() sideRoute(upScrollR3, bUpR3, upS, upB) end)

local noobS, noobB = {noobScrollR1, noobScrollR2}, {bNoobR1, bNoobR2}
bNoobR1.MouseButton1Click:Connect(function() sideRoute(noobScrollR1, bNoobR1, noobS, noobB) end)
bNoobR2.MouseButton1Click:Connect(function() sideRoute(noobScrollR2, bNoobR2, noobS, noobB) end)

local fS, fB = {fNoobScroll, fUpgradeScroll}, {bFNoobs, bFUpgrades}
bFNoobs.MouseButton1Click:Connect(function() sideRoute(fNoobScroll, bFNoobs, fS, fB) end) bFUpgrades.MouseButton1Click:Connect(function() sideRoute(fUpgradeScroll, bFUpgrades, fS, fB) end)

local miscSubS, miscSubB = {miscScrollRu1, miscScrollRu2, miscScrollRuE, miscScrollCap}, {bMiscRu1, bMiscRu2, bMiscRuE, bMiscCap}
bMiscRu1.MouseButton1Click:Connect(function() sideRoute(miscScrollRu1, bMiscRu1, miscSubS, miscSubB) end)
bMiscRu2.MouseButton1Click:Connect(function() sideRoute(miscScrollRu2, bMiscRu2, miscSubS, miscSubB) end)
bMiscRuE.MouseButton1Click:Connect(function() sideRoute(miscScrollRuE, bMiscRuE, miscSubS, miscSubB) end)
bMiscCap.MouseButton1Click:Connect(function() sideRoute(miscScrollCap, bMiscCap, miscSubS, miscSubB) end)

local setS, setB = {setGenScroll, setConfigScroll}, {bSetGen, bSetConfig}
bSetGen.MouseButton1Click:Connect(function() sideRoute(setGenScroll, bSetGen, setS, setB) end)
bSetConfig.MouseButton1Click:Connect(function() sideRoute(setConfigScroll, bSetConfig, setS, setB) end)

local dragging, dragInput, dragStart, startPos
mainFrame.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true dragStart = input.Position startPos = mainFrame.Position input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) end end)
mainFrame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- NOW LOAD CONFIG & SYNC BUTTONS AFTER ALL ELEMENTS ARE CREATED & REGISTERED
loadConfigFromSlot(1)

--======================================================================================
-- LOCOMOTION & TELEPORT ENGINES (SPED UP BY 0.3s)
--======================================================================================
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
        task.wait(Env.CPUSaverMode and 0.2 or 0.05)
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
local currentTargetPart = nil

local function isOreRespawning(oreModel)
    for _, desc in ipairs(oreModel:GetDescendants()) do
        if desc:IsA("TextLabel") and desc.Text:lower():find("respawning") then return true end
    end return false
end

task.spawn(function()
    while Running do
        task.wait(Env.CPUSaverMode and 0.1 or 0.02)
        if Running then
            local enabledOreNames = {} local hasAnyEnabled = false
            for i = 1, #OrePriorityList do if Env[OrePriorityList[i].F] then enabledOreNames[OrePriorityList[i].N] = true hasAnyEnabled = true end end

            if hasAnyEnabled then
                local needsNewTarget = false
                if not currentTargetPart or not currentTargetPart.Parent or not currentTargetPart:IsDescendantOf(workspace) then needsNewTarget = true
                elseif currentTargetPart.Parent and isOreRespawning(currentTargetPart.Parent) then needsNewTarget = true
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
                        currentTargetPart = freshList[currentOreIndex] lastOreJumpTick = tick()
                    else currentTargetPart = nil end
                end
                
                if currentTargetPart and currentTargetPart.Parent then MiningTargetVector = currentTargetPart.Position + Vector3.new(0, 3, 0) else MiningTargetVector = nil end
            else currentTargetPart = nil MiningTargetVector = nil end
        end
    end
end)

task.spawn(function()
    while Running do
        task.wait(Env.CPUSaverMode and 0.1 or 0.02)
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
        task.wait(0.2)
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
                                att = true 
                                if Env.AutoTycoonTeleport then
                                    MasterTargetVector = tb.Position + Vector3.new(0, 3, 0) 
                                    task.wait(0.1) 
                                else
                                    task.wait(0.05)
                                end
                                if not Running then break end
                                if bM:IsDescendantOf(btnF) then locked[bM.Name] = true MasterTargetVector = nil task.wait(0.02) else MasterTargetVector = nil task.wait(0.05) break end
                            end
                        end
                    end
                    if not att or not Env.AutoFarmCash or not Running then break end task.wait(0.05)
                until false
                if Running then MasterTargetVector = nil local sE = tick() + math.random(120, 180) repeat task.wait(1) until tick() >= sE or not Env.AutoFarmCash or not Running end
            else MasterTargetVector = nil task.wait(1.7) end
        else MasterTargetVector = nil task.wait(0.7) end
    end
end)

local PrimaryUpgradeQueue = {
    {F="AutoUpgradeStarter",T="UpgradeNoob",A={"Starter"}}, {F="AutoUpgradeCooker",T="UpgradeNoobMax",A={"Cooker"}}, {F="AutoUpgradeFarmer",T="UpgradeNoobMax",A={"Farmer"}}, {F="AutoUpgradeMagician",T="UpgradeNoobMax",A={"Magician"}}, {F="AutoUpgradeArcher",T="UpgradeNoobMax",A={"Archer"}}, {F="AutoUpgradeSoldier",T="UpgradeNoobMax",A={"Soldier"}}, {F="AutoUpgradePharaoh",T="UpgradeNoobMax",A={"Pharaoh"}},
    {F="AutoUpgradeHacker1",T="UpgradeNoobMax",A={"Hacker 1"}}, {F="AutoUpgradeHacker2",T="UpgradeNoobMax",A={"Hacker 2"}}, {F="AutoUpgradeHacker3",T="UpgradeNoobMax",A={"Hacker 3"}}, {F="AutoUpgradeHacker4",T="UpgradeNoobMax",A={"Hacker 4"}},
    {F="AutoUpgradeFishermanNoob",T="UpgradeNoobMax",A={"Fisherman"}}, {F="AutoUpgradeKnightNoob",T="UpgradeNoobMax",A={"Knight"}}, {F="AutoUpgradeExplorerNoob",T="UpgradeNoobMax",A={"Explorer"}}, {F="AutoUpgradeMagicianNoob",T="UpgradeNoobMax",A={"Magician"}},
    {F="AutoUpgradeGoalkeeper",T="UpgradeNoobMax",A={"Goalkeeper"}}, {F="AutoUpgradeLeftBack",T="UpgradeNoobMax",A={"LeftBack"}}, {F="AutoUpgradeLeftCenterBack",T="UpgradeNoobMax",A={"LeftCenterBack"}}, {F="AutoUpgradeRightCenterBack",T="UpgradeNoobMax",A={"RightCenterBack"}}, {F="AutoUpgradeRightBack",T="UpgradeNoobMax",A={"RightBack"}}, {F="AutoUpgradeLeftDefensiveMid",T="UpgradeNoobMax",A={"LeftDefensiveMid"}}, {F="AutoUpgradeRightDefensiveMid",T="UpgradeNoobMax",A={"RightDefensiveMid"}}, {F="AutoUpgradeAttackingMid",T="UpgradeNoobMax",A={"AttackingMid"}}, {F="AutoUpgradeLeftWing",T="UpgradeNoobMax",A={"LeftWing"}}, {F="AutoUpgradeRightWing",T="UpgradeNoobMax",A={"RightWing"}}, {F="AutoUpgradeStriker",T="UpgradeNoobMax",A={"Striker"}},
    {F="AutoUpgradeMoreOof",T="UpgradeUpgradeMax",A={"Oof","MoreOof"}}, {F="AutoUpgradeFasterNoobs",T="UpgradeUpgradeMax",A={"Oof","FasterNoobs"}},
    {F="AutoRealm2MoreOof",T="UpgradeUpgradeMax",A={"Oof","MoreOofRealm2"}}, {F="AutoRealm2MoreWalkSpeed",T="UpgradeUpgradeMax",A={"Oof","MoreWalkSpeedRealm2"}}, {F="AutoRealm2MoreWater",T="UpgradeUpgradeMax",A={"Water","MoreWater"}}, {F="AutoRealm2MoreOofWater",T="UpgradeUpgradeMax",A={"Water","MoreOof"}}, {F="AutoRealm2MorePlanks",T="UpgradeUpgradeMax",A={"Water","MorePlanks"}}, {F="AutoRealm2MoreIce",T="UpgradeUpgradeMax",A={"Ice","MoreIce"}}, {F="AutoRealm2WaterPump1",T="UpgradeUpgradeMax",A={"Ice","WaterPumpNoobHire"}}, {F="AutoRealm2WaterPump2",T="UpgradeUpgradeMax",A={"Ice","WaterFromIce"}}, {F="AutoRealm2MoreOofIce",T="UpgradeUpgradeMax",A={"Ice","MoreOof"}},
    {F="AutoGemMoreOof",T="UpgradeUpgradeMax",A={"Gem","MoreOof"}}, {F="AutoGemMoreGems",T="UpgradeUpgradeMax",A={"Gem","MoreGems"}}, {F="AutoGemStrongerPickaxes",T="UpgradeUpgradeMax",A={"Gem","StrongerPickaxes"}}, {F="AutoGemMoreOreStats",T="UpgradeUpgradeMax",A={"Gem","MoreOreStats"}},
    {F="AutoWoodRankUp",T="WoodRankUp",A={}}, {F="AutoTycoonReset",T="Tycoon",A={}},
    {F="AutoWoodMoreWood",T="UpgradeUpgradeMax",A={"Wood","MoreWood"}}, {F="AutoWoodSharperAxes",T="UpgradeUpgradeMax",A={"Wood","SharperAxes"}}, {F="AutoWoodBiggerDeposit",T="UpgradeUpgradeMax",A={"Wood","BiggerWoodDeposit"}}, {F="AutoWoodFasterConversion",T="UpgradeUpgradeMax",A={"Wood","FasterWoodConversion"}}, {F="AutoWoodMorePlanks",T="UpgradeUpgradeMax",A={"Wood","MorePlanksFromWood"}},
    {F="AutoPlanksMorePlanks",T="UpgradeUpgradeMax",A={"Planks","MorePlanks"}}, {F="AutoPlanksMoreWood",T="UpgradeUpgradeMax",A={"Planks","MoreWood"}}, {F="AutoPlanksWaterFromPlanks",T="UpgradeUpgradeMax",A={"Planks","WaterFromPlanks"}},
    {F="AutoRebirthMoreOof",T="UpgradeUpgradeMax",A={"Rebirth","MoreOof"}}, {F="AutoRebirthMoreRebirth",T="UpgradeUpgradeMax",A={"Rebirth","MoreRebirth"}}, {F="AutoRebirthMoreFire",T="UpgradeUpgradeMax",A={"Rebirth","MoreFire"}},
    {F="AutoFireMoreFire",T="UpgradeUpgradeMax",A={"Fire","MoreFire"}}, {F="AutoFireMoreBulk",T="UpgradeUpgradeMax",A={"Fire","MoreBulk"}}, {F="AutoFireMoreOof",T="UpgradeUpgradeMax",A={"Fire","MoreOof"}}, {F="AutoFireMoreRebirth",T="UpgradeUpgradeMax",A={"Fire","MoreRebirth"}}, {F="AutoFireMoreTierLuck",T="UpgradeUpgradeMax",A={"Fire","MoreTierLuck"}}, {F="AutoFireMoreCashBonus",T="UpgradeUpgradeMax",A={"Fire","MoreCashBonus"}},
    {F="AutoUpgradeMoreCash",T="UpgradeUpgradeMax",A={"Cash","MoreCash"}}, {F="AutoUpgradeFasterDropper",T="UpgradeUpgradeMax",A={"Cash","FasterDropper"}}, {F="AutoUpgradeMoreRuneLuck",T="UpgradeUpgradeMax",A={"Cash","MoreRuneLuck"}},
    {F="AutoGoalsMoreGoals",T="UpgradeUpgradeMax",A={"Goals","MoreGoals"}}, {F="AutoGoalsRuneBulk",T="UpgradeUpgradeMax",A={"Goals","RuneBulk"}}, {F="AutoGoalsRuneLuck",T="UpgradeUpgradeMax",A={"Goals","RuneLuck"}}, {F="AutoBuyAutoKick",T="UpgradeUpgradeMax",A={"Goals","AutoKick"}},
    {F="AutoBreadMoreWheat",T="UpgradeUpgradeMax",A={"Bread","MoreWheat"}}, {F="AutoBreadMoreBread",T="UpgradeUpgradeMax",A={"Bread","MoreBread"}}, {F="AutoBreadMoreBread2",T="UpgradeUpgradeMax",A={"Bread","MoreBread2"}}, {F="AutoBreadBiggerWheatDeposit",T="UpgradeUpgradeMax",A={"Bread","BiggerWheatDeposit"}}, {F="AutoBreadFasterWheatConversion",T="UpgradeUpgradeMax",A={"Bread","FasterWheatConversion"}}, {F="AutoBreadMoreConsumption",T="UpgradeUpgradeMax",A={"Bread","MoreConsumption"}}, {F="AutoBreadMoreRuneLuck",T="UpgradeUpgradeMax",A={"Bread","MoreRuneLuck"}}, {F="AutoBreadMoreTierLuck",T="UpgradeUpgradeMax",A={"Bread","MoreTierLuck"}}, {F="AutoUpgradeCow",T="UpgradeAnimal",A={"Cow"}}, {F="AutoUpgradeChicken",T="UpgradeAnimal",A={"Chicken"}}, {F="AutoBuyCow",T="BuyAnimal",A={"Cow",true}}, {F="AutoBuyChicken",T="BuyAnimal",A={"Chicken",true}}
}

task.spawn(function()
    while Running do
        task.wait(Env.CPUSaverMode and 1.7 or 0.7)
        if NetRemote and Running then
            for i = 1, #PrimaryUpgradeQueue do
                if not Running then break end local item = PrimaryUpgradeQueue[i]
                if Env[item.F] then pcall(function() NetRemote:FireServer(item.T, unpack(item.A)) end) task.wait(0.05) end
            end
        end
    end
end)

task.spawn(function() while Running do task.wait(0.2) if NetRemote and Running then for i = 1, 11 do if Env["AutoFillBucket" .. i] then pcall(function() NetRemote:FireServer("FillWaterBucket", i) end) task.wait(0.05) end end end end end)

task.spawn(function()
    while Running do
        task.wait(20.0)
        if NetRemote and Running and Env.AutoGemExchange then
            pcall(function() NetRemote:FireServer("ExchangeAllMinerals") end)
            showToast("Successfully exchanged minerals for gems!")
            sendDiscordWebhook("Dominate Hub: Successfully exchanged all minerals for gems!")
        end
    end
end)

task.spawn(function() while Running do task.wait(0.2) if NetRemote and Running and Env.AutoScoreGoal then pcall(function() NetRemote:FireServer("RegisterFootballKick") end) task.wait(1.2) if not Running or not Env.AutoScoreGoal then break end pcall(function() NetRemote:FireServer("ScoreGoal") end) task.wait(1.2) end end end)

task.spawn(function()
    while Running do
        if NetRemote and Running and Env.AutoFootballTree then
            local pGui = player:FindFirstChild("PlayerGui") local treeGui = pGui and pGui:FindFirstChild("FootballUITree")
            if treeGui then
                for _, obj in pairs(treeGui:GetDescendants()) do
                    if not Running or not Env.AutoFootballTree then break end
                    if (obj:IsA("GuiButton") or obj:IsA("Frame")) and obj.Name ~= "Main" and obj.Name ~= "Container" then pcall(function() NetRemote:FireServer("BuyFootballUITreeNode", obj.Name) end) task.wait(0.2) end
                end
            end
        end
        task.wait(4.7)
    end
end)

task.spawn(function() while Running do task.wait(2.7) if NetRemote and Running and Env.AutoClaimTrophies then for i = 1, 10 do if not Running or not Env.AutoClaimTrophies then break end pcall(function() NetRemote:FireServer("BuyTrophy", i) end) task.wait(0.05) end end end end)

task.spawn(function() while Running do task.wait(29.7) if NetRemote and Running then if Env.AutoDepositWheat then pcall(function() NetRemote:FireServer("DepositWheat") end) end if Env.AutoDepositWood then pcall(function() NetRemote:FireServer("DepositWood") end) end end end end)
task.spawn(function() while Running do task.wait(0.7) if NetRemote and Running then if Env.AutoBlazeMoreBlaze then pcall(function() NetRemote:FireServer("UpgradeUpgradeMax", "Blaze", "MoreBlaze") end) task.wait(0.05) end if Env.AutoBlazeMoreFire then pcall(function() NetRemote:FireServer("UpgradeUpgradeMax", "Blaze", "MoreFire") end) task.wait(0.05) end if Env.AutoBlazeMoreOof then pcall(function() NetRemote:FireServer("UpgradeUpgradeMax", "Blaze", "MoreOof") end) task.wait(0.05) end if Env.AutoBlazeMoreOofs then pcall(function() NetRemote:FireServer("UpgradeUpgradeMax", "Blaze", "MoreOofs") end) task.wait(0.05) end if Env.AutoBlazeMoreBulk then pcall(function() NetRemote:FireServer("UpgradeUpgradeMax", "Blaze", "MoreBulk") end) task.wait(0.05) end end end end)
task.spawn(function() while Running do task.wait(0.9) if NetRemote and Running then if Env.AutoOpenT1Chest then pcall(function() NetRemote:FireServer("OpenChest", "T1TrialChest", 10) end) end if Env.AutoOpenT2Chest then pcall(function() NetRemote:FireServer("OpenChest", "T2TrialChest", 10) end) end end end end)
task.spawn(function() while Running do task.wait(4.7) if Env.AutoPrestige and NetRemote and Running then pcall(function() NetRemote:FireServer("Prestige") end) end end end)

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

print("[Dominate Hub] V12.2 Pro Edition - V11.7 Sped-up Script + Double-Click Fixed!")
