--======================================================================================
-- DOMINATE HUB | PRO EDITION (STABLE V16.9.31 - COLLAPSIBLE UI SECTIONS & MASTER BUILD)
--======================================================================================
local Env = (getgenv and getgenv()) or _G

if Env.DominateHubLoaded then 
    pcall(function()
        local parentTarget = (gethui and gethui()) or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
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
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local Running = true
local player = Players.LocalPlayer
local vu = VirtualUser

local UI = {}

-- STATS TRACKING VARIABLES FOR HUD
local oresMined = 0
local mobsKilled = 0
local lastTrackedPart = nil
local lastTrackedMobPart = nil
local currentTargetPanel = nil
local currentTargetMob = nil
local gemExchangeCountdown = 60

-- RITUAL HUD TIMER VARIABLES
local ritualTimer = 0
local ritualInCooldown = false

-- RUNTIME STATE LOCKS
local trialIsRunning = false
local ritualIsActive = false
local ritualSuppressMobs = false

-- CORPSE CACHE FOR INSTANT TRIAL MOB SKIPPING
local deadMobs = {}

-- RITUAL PRE-SELECTED MOBS & SAND CONFIG
Env.RitualSelectedMobs = {
    ["Dark Knight"] = true,
    ["Dark Commander"] = true
}

Env.AutoSandUpgrades = false
Env.AutoShovelLevelUp = false
Env.AutoExcavationRankUp = false
Env.AutoRegenSandLayers = false
Env.TargetSandLayer = 3 -- User configurable layer 1-250

-- TRIAL ANTI-STUCK CONFIG
Env.AutoLeaveIfStuck = true

-- ANCIENT BOSS FARM CONFIG
Env.AutoAncientBossFarm = false

-- LIVE GEM EXCHANGE COUNTDOWN TICKER
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

-- TOAST NOTIFICATION HELPER
local function showToast(msg)
    task.spawn(function()
        local toast = Instance.new("Frame")
        toast.Size = UDim2.new(0, 220, 0, 38)
        toast.Position = UDim2.new(1, 10, 1, -60)
        toast.BackgroundColor3 = Color3.fromRGB(18, 12, 28)
        toast.BackgroundTransparency = 0.1
        toast.BorderSizePixel = 0
        toast.Parent = (gethui and gethui()) or player:WaitForChild("PlayerGui")
        
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

Env.AntiAFK = true
Env.AutoPrestige = false
Env.CPUSaverMode = false

-- SAFE ZONE VECTOR FOR COMBAT BREAK
Env.SafeZoneVector = Vector3.new(919.1552, 4.8658, 7905.8755)

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

-- SOULS & RITUAL FLAGS
Env.AutoSoulsMoreSouls = false
Env.AutoSoulsLuckierSwords = false
Env.AutoSoulsMoreOof = false
Env.AutoSoulsMoreBones = false
Env.AutoSoulsRuneBulk = false
Env.AutoStartRitual = false

-- MEAT / BONES UPGRADE FLAGS
Env.AutoMeatMoreMeat = false
Env.AutoMeatStrongerSwords = false
Env.AutoMeatMoreOof = false
Env.AutoMeatMoreBones = false
Env.AutoDepositMeat = false

Env.AutoBonesMoreBones = false
Env.AutoBonesFasterSwords = false
Env.AutoBonesBiggerMeatDeposit = false
Env.AutoBonesFasterMeatConversion = false
Env.AutoBonesEvenMoreBones = false

-- TRIALS FLAGS
Env.AutoEasyTrial = false
Env.AutoMediumTrial = false
Env.AutoHardTrial = false

Env.AutoUpgradeFishermanNoob = false
Env.AutoUpgradeKnightNoob = false
Env.AutoUpgradeExplorerNoob = false
Env.AutoUpgradeMagicianNoob = false
Env.AutoUpgradeMerchantNoob = false
Env.AutoUpgradeMummyNoob = false
Env.AutoUpgradePharaoh = false

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

-- INDIVIDUAL MOB FARMING FLAGS (WORST TO BEST)
Env.AutoMobGoblin = false
Env.AutoMobSkeleton = false
Env.AutoMobOrc = false
Env.AutoMobPirate = false
Env.AutoMobNinja = false
Env.AutoMobWarrior = false
Env.AutoMobPirateCaptain = false
Env.AutoMobSamurai = false
Env.AutoMobPirateAdmiral = false
Env.AutoMobSamuraiMaster = false
Env.AutoMobDarkKnight = false
Env.AutoMobDarkCommander = false

-- COMBAT UPGRADE BREAK FLAG
Env.AutoCombatBreak = false

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
Env.AutoRollSnowyRune = false
Env.AutoRollFootballRune = false
Env.AutoRollDunesRune = false
Env.AutoRollSunfireRune = false

Env.AutoOpenT1Chest = false
Env.AutoOpenT2Chest = false
Env.AutoOpenClassicCapsule = false
Env.AutoOpenFootballCapsule = false
Env.AutoOpenSuperCapsule = false
Env.AutoOpenAncientCapsule = false

Env.FPSBoostMode = false
Env.ShowStatsHUD = true

-- FEATURE ROW CONTAINER
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

    row.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            TweenService:Create(row, TweenInfo.new(0.2), {BackgroundTransparency = 0.35, BackgroundColor3 = Color3.fromRGB(45, 25, 70)}):Play()
        end
    end)
    row.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            TweenService:Create(row, TweenInfo.new(0.2), {BackgroundTransparency = 0.5, BackgroundColor3 = Color3.fromRGB(35, 20, 55)}):Play()
        end
    end)

    switchTrack.MouseButton1Click:Connect(function()
        Env[vKey] = not Env[vKey]
        local active = Env[vKey]
        TweenService:Create(switchTrack, TweenInfo.new(0.2), {BackgroundColor3 = active and Color3.fromRGB(168, 85, 247) or Color3.fromRGB(42, 28, 65)}):Play()
        TweenService:Create(trackStroke, TweenInfo.new(0.2), {Transparency = active and 0.2 or 0.7}):Play()
        TweenService:Create(switchThumb, TweenInfo.new(0.2), {Position = active and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)}):Play()
    end)

    return row
end

-- TEXT INPUT ROW FOR TARGET LAYER (1-250)
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

    local tbStroke = Instance.new("UIStroke")
    tbStroke.Color = Color3.fromRGB(168, 85, 247)
    tbStroke.Transparency = 0.4
    tbStroke.Parent = textBox

    textBox.FocusLost:Connect(function(enterPressed)
        local num = tonumber(textBox.Text)
        if num then
            num = math.clamp(math.round(num), 1, 250)
            Env[vKey] = num
            textBox.Text = tostring(num)
            showToast(txt .. " set to Layer " .. tostring(num))
        else
            textBox.Text = tostring(Env[vKey])
        end
    end)

    return row
end

-- COLLAPSIBLE SECTION BUILDER
local function createCollapsibleSection(parent, txt)
    local secFrame = Instance.new("Frame")
    secFrame.Size = UDim2.new(1, -10, 0, 36)
    secFrame.BackgroundTransparency = 1
    secFrame.Parent = parent

    local headerBtn = Instance.new("TextButton")
    headerBtn.Size = UDim2.new(1, 0, 0, 32)
    headerBtn.BackgroundTransparency = 1
    headerBtn.TextColor3 = Color3.fromRGB(230, 110, 255)
    headerBtn.TextSize = 12
    headerBtn.Font = Enum.Font.GothamBold
    headerBtn.Text = "▼  " .. txt
    headerBtn.TextXAlignment = Enum.TextXAlignment.Left
    headerBtn.Parent = secFrame

    local cont = Instance.new("Frame")
    cont.Size = UDim2.new(1, 0, 0, 0)
    cont.Position = UDim2.new(0, 0, 0, 36)
    cont.BackgroundTransparency = 1
    cont.Parent = secFrame

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = cont

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        if cont.Visible then
            cont.Size = UDim2.new(1, 0, 0, layout.AbsoluteContentSize.Y)
            secFrame.Size = UDim2.new(1, -10, 0, layout.AbsoluteContentSize.Y + 44)
        end
    end)

    local isOpen = true
    headerBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        cont.Visible = isOpen
        headerBtn.Text = (isOpen and "▼  " or "▶  ") .. txt
        if isOpen then
            secFrame.Size = UDim2.new(1, -10, 0, layout.AbsoluteContentSize.Y + 44)
        else
            secFrame.Size = UDim2.new(1, -10, 0, 36)
        end
    end)

    return cont
end

-- EXPANDABLE MULTI-SELECT DROPDOWN FOR RITUAL TARGET MOBS
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
            showToast("Ritual Mobs: Updated " .. mobInfo.N)
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

-- MASTER TOGGLE GROUP CONTAINER
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

    local trackStroke = Instance.new("UIStroke")
    trackStroke.Color = Color3.fromRGB(216, 180, 254)
    trackStroke.Transparency = 0.7
    trackStroke.Parent = switchTrack

    local switchThumb = Instance.new("Frame")
    switchThumb.Size = UDim2.new(0, 18, 0, 18)
    switchThumb.Position = UDim2.new(0, 2, 0.5, -9)
    switchThumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    switchThumb.BorderSizePixel = 0
    switchThumb.Parent = switchTrack
    
    local thumbCorner = Instance.new("UICorner")
    thumbCorner.CornerRadius = UDim.new(1, 0)
    thumbCorner.Parent = switchThumb

    f.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            TweenService:Create(f, TweenInfo.new(0.2), {BackgroundTransparency = 0.35, BackgroundColor3 = Color3.fromRGB(45, 25, 70)}):Play()
        end
    end)
    f.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            TweenService:Create(f, TweenInfo.new(0.2), {BackgroundTransparency = 0.5, BackgroundColor3 = Color3.fromRGB(35, 20, 55)}):Play()
        end
    end)

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
        TweenService:Create(switchTrack, TweenInfo.new(0.2), {BackgroundColor3 = activeState and Color3.fromRGB(168, 85, 247) or Color3.fromRGB(42, 28, 65)}):Play()
        TweenService:Create(trackStroke, TweenInfo.new(0.2), {Transparency = activeState and 0.2 or 0.7}):Play()
        TweenService:Create(switchThumb, TweenInfo.new(0.2), {Position = activeState and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)}):Play()
    end)
    return switchTrack
end

player.Idled:Connect(function()
    if Running and Env.AntiAFK then
        local cam = workspace.CurrentCamera
        local cf = cam and cam.CFrame or CFrame.new()
        vu:Button2Down(Vector2.new(0,0), cf) task.wait(0.5) vu:Button2Up(Vector2.new(0,0), cf)
    end
end)

-- UI MASTER ALLOCATION
local parentTarget = (gethui and gethui()) or player:WaitForChild("PlayerGui")
local sg = Instance.new("ScreenGui") sg.Name = "DominateHubMirror" sg.ResetOnSpawn = false sg.Parent = parentTarget

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

-- FORWARD DECLARATIONS FOR HUD CHECKS
local OrePriorityList = {
    {F = "AutoMineCelestium", N = "Celestium"}, {F = "AutoMineVoidsteel", N = "Voidsteel"}, {F = "AutoMineRuby", N = "Ruby"},
    {F = "AutoMineAetherite", N = "Aetherite"}, {F = "AutoMinePalladium", N = "Palladium"}, {F = "AutoMineUranium", N = "Uranium"},
    {F = "AutoMineCobalt", N = "Cobalt"}, {F = "AutoMineTitanium", N = "Titanium"}, {F = "AutoMinePlatinum", N = "Platinum"},
    {F = "AutoMineGold", N = "Gold"}, {F = "AutoMineCopper", N = "Copper"}, {F = "AutoMineIron", N = "Iron"},
    {F = "AutoMineSilver", N = "Silver"}, {F = "AutoMineCoal", N = "Coal"}, {F = "AutoMineStone", N = "Stone"}
}

local MobPriorityList = {
    {F = "AutoMobGoblin", N = "Goblin"},
    {F = "AutoMobSkeleton", N = "Skeleton"},
    {F = "AutoMobOrc", N = "Orc"},
    {F = "AutoMobPirate", N = "Pirate"},
    {F = "AutoMobNinja", N = "Ninja"},
    {F = "AutoMobWarrior", N = "Warrior"},
    {F = "AutoMobPirateCaptain", N = "Pirate Captain"},
    {F = "AutoMobSamurai", N = "Samurai"},
    {F = "AutoMobPirateAdmiral", N = "Pirate Admiral"},
    {F = "AutoMobSamuraiMaster", N = "Samurai Master"},
    {F = "AutoMobDarkKnight", N = "Dark Knight"},
    {F = "AutoMobDarkCommander", N = "Dark Commander"}
}

-- PERFORMANCE HUD OVERLAY (TOP LEFT)
local statsHud = Instance.new("Frame")
statsHud.Size = UDim2.new(0, 210, 0, 60)
statsHud.Position = UDim2.new(0, 15, 0, 15) 
statsHud.BackgroundColor3 = Color3.fromRGB(18, 12, 28)
statsHud.BackgroundTransparency = 0.35
statsHud.BorderSizePixel = 0
statsHud.Parent = sg

local hudCorner = Instance.new("UICorner")
hudCorner.CornerRadius = UDim.new(0, 8)
hudCorner.Parent = statsHud

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
hudTitle.Font = Enum.Font.GothamBold
hudTitle.Text = "PERFORMANCE HUD"
hudTitle.Parent = statsHud

local hudText = Instance.new("TextLabel")
hudText.Size = UDim2.new(1, -10, 1, -22)
hudText.Position = UDim2.new(0, 5, 0, 22)
hudText.BackgroundTransparency = 1
hudText.TextColor3 = Color3.fromRGB(220, 220, 230)
hudText.TextSize = 10
hudText.Font = Enum.Font.GothamBold
hudText.TextXAlignment = Enum.TextXAlignment.Left
hudText.TextYAlignment = Enum.TextYAlignment.Top
hudText.TextWrapped = true
hudText.Text = "Uptime: 00:00:00 | FPS: 60\nTarget: None | Smooth Ground-Lock Active"
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
            
            local timeTable = os.date("*t")
            local curM = timeTable.min
            local curS = timeTable.sec
            local targetMin = (curM < 29) and 29 or (curM < 59 and 59 or 89)
            local diffSec = (targetMin * 60) - (curM * 60 + curS)
            if diffSec < 0 then diffSec = diffSec + 3600 end
            local tM = math.floor(diffSec / 60)
            local tS = diffSec % 60
            local trialCountdownStr = string.format("Next Trial: %02d:%02d", tM, tS)
            
            local targetName = "None"
            if currentTargetMob and currentTargetMob.Parent then
                targetName = currentTargetMob.Parent.Name
            elseif currentTargetPanel and currentTargetPanel.Parent then
                targetName = currentTargetPanel.Parent.Name
            end
            
            local uptimeStr = string.format("Uptime: %02d:%02d:%02d | FPS: %d", hours, mins, secs, fps)
            local targetStr = string.format("Target: %s | Ground-Lock", targetName)
            
            local extraLines = {trialCountdownStr}
            
            local miningActive = false
            for _, oreInfo in ipairs(OrePriorityList) do
                if Env[oreInfo.F] then miningActive = true break end
            end
            if miningActive then
                table.insert(extraLines, string.format("Gem Exch: %ds | Mined: %d", gemExchangeCountdown, oresMined))
            end
            
            local mobActive = false
            for _, mobInfo in ipairs(MobPriorityList) do
                if Env[mobInfo.F] then mobActive = true break end
            end
            if mobActive then
                table.insert(extraLines, string.format("Mobs Killed: %d", mobsKilled))
            end
            
            if Env.AutoStartRitual then
                if ritualTimer > 0 then
                    local rMin = math.floor(ritualTimer / 60)
                    local rSec = ritualTimer % 60
                    local stateStr = ritualInCooldown and "Cool Down" or "Active"
                    table.insert(extraLines, string.format("Ritual: %s (%dm %02ds)", stateStr, rMin, rSec))
                else
                    table.insert(extraLines, "Ritual: Starting...")
                end
            end
            
            local finalHudText = uptimeStr .. "\n" .. targetStr
            if #extraLines > 0 then
                finalHudText = finalHudText .. "\n" .. table.concat(extraLines, " | ")
            end
            
            hudText.Text = finalHudText
            statsHud.Size = UDim2.new(0, 210, 0, 52 + (#extraLines * 18))
        else
            statsHud.Visible = false
        end
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

local logoBox = Instance.new("ImageLabel")
logoBox.Size = UDim2.new(0, 34, 0, 34)
logoBox.Position = UDim2.new(0, 14, 0, 10)
logoBox.BackgroundColor3 = Color3.fromRGB(147, 51, 234)
logoBox.BackgroundTransparency = 0.2
logoBox.BorderSizePixel = 0
logoBox.Image = "rbxassetid://0"
logoBox.Parent = mainFrame

local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(0, 8)
logoCorner.Parent = logoBox

local logoBoxStroke = Instance.new("UIStroke")
logoBoxStroke.Color = Color3.fromRGB(240, 220, 255)
logoBoxStroke.Transparency = 0.65
logoBoxStroke.Parent = logoBox

local headerTitle = Instance.new("TextLabel") 
headerTitle.Size = UDim2.new(0.5, 0, 0, 20) 
headerTitle.Position = UDim2.new(0, 56, 0, 8) 
headerTitle.BackgroundTransparency = 1 
headerTitle.TextColor3 = Color3.fromRGB(216, 180, 254)
headerTitle.TextSize = 15 
headerTitle.Font = Enum.Font.GothamBold 
headerTitle.Text = "Dominate Hub v1.4 (Pro Edition)" 
headerTitle.TextXAlignment = Enum.TextXAlignment.Left 
headerTitle.Parent = mainFrame

local headerSubtitle = Instance.new("TextLabel")
headerSubtitle.Size = UDim2.new(0.5, 0, 0, 16)
headerSubtitle.Position = UDim2.new(0, 56, 0, 28)
headerSubtitle.BackgroundTransparency = 1
headerSubtitle.TextColor3 = Color3.fromRGB(180, 150, 210)
headerSubtitle.TextSize = 11
headerSubtitle.Font = Enum.Font.GothamBold
headerSubtitle.Text = "discord.gg/dominatehub | Lovely <3"
headerSubtitle.TextXAlignment = Enum.TextXAlignment.Left
headerSubtitle.Parent = mainFrame

local headerTelemetry = Instance.new("TextLabel")
headerTelemetry.Size = UDim2.new(0.3, 0, 0, 35)
headerTelemetry.Position = UDim2.new(0.68, 0, 0, 10)
headerTelemetry.BackgroundTransparency = 1
headerTelemetry.TextColor3 = Color3.fromRGB(74, 222, 128)
headerTelemetry.TextSize = 12
headerTelemetry.Font = Enum.Font.GothamBold
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

-- MINIMIZE BUTTON
local minBtn = Instance.new("TextButton") 
minBtn.Size = UDim2.new(0, 115, 0, 26) 
minBtn.Position = UDim2.new(0.5, -57, 0.01, 0) 
minBtn.BackgroundColor3 = Color3.fromRGB(18, 12, 28) 
minBtn.BackgroundTransparency = 0.5 
minBtn.TextColor3 = Color3.fromRGB(216, 180, 254) 
minBtn.TextSize = 11 
minBtn.Font = Enum.Font.GothamBold 
minBtn.Text = "Dominate Hub" 
minBtn.Parent = sg

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 8)
minCorner.Parent = minBtn

local minStroke = Instance.new("UIStroke")
minStroke.Color = Color3.fromRGB(168, 85, 247)
minStroke.Transparency = 0.4
minStroke.Parent = minBtn

minBtn.MouseButton1Click:Connect(function()
    local isVisible = mainFrame.Visible
    if isVisible then
        mainFrame.Visible = false
        minBtn.TextColor3 = Color3.fromRGB(74, 222, 128)
    else
        mainFrame.Visible = true
        minBtn.TextColor3 = Color3.fromRGB(216, 180, 254)
    end
end)

-- SIDEBAR
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

sidebarLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    sidebarFrame.CanvasSize = UDim2.new(0, 0, 0, sidebarLayout.AbsoluteContentSize.Y + 10)
end)

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

-- UPGRADES PAGE
local upScroll = makeVerticalScroll(upgradesPage) upScroll.Visible = true

local secU1 = createCollapsibleSection(upScroll, "Realm 1 Upgrades")
createToggleRow(secU1, "More Oof Auto Upgrade", "AutoUpgradeMoreOof")
createToggleRow(secU1, "Faster Noobs Upgrade", "AutoUpgradeFasterNoobs")
masterToggleGroup("Fire Upgrades", {"AutoFireMoreFire", "AutoFireMoreBulk", "AutoFireMoreOof", "AutoFireMoreRebirth", "AutoFireMoreTierLuck", "AutoFireMoreCashBonus"}, secU1)
masterToggleGroup("Rebirth Upgrades", {"AutoRebirthMoreOof", "AutoRebirthMoreRebirth", "AutoRebirthMoreFire"}, secU1)
masterToggleGroup("Blaze Upgrades", {"AutoBlazeConvert", "AutoBlazeMoreBlaze", "AutoBlazeMoreFire", "AutoBlazeMoreOof", "AutoBlazeMoreOofs", "AutoBlazeMoreBulk"}, secU1)
masterToggleGroup("Bread Upgrades", {"AutoDepositWheat", "AutoBreadMoreBread", "AutoBreadMoreBread2", "AutoBreadMoreWheat", "AutoBreadBiggerWheatDeposit", "AutoBreadFasterWheatConversion", "AutoBreadMoreConsumption", "AutoBreadMoreRuneLuck", "AutoBreadMoreTierLuck", "AutoUpgradeCow", "AutoUpgradeChicken", "AutoBuyCow", "AutoBuyChicken"}, secU1)
masterToggleGroup("Cash Upgrades", {"AutoFarmCash", "AutoUpgradeMoreCash", "AutoUpgradeFasterDropper", "AutoUpgradeMoreRuneLuck"}, secU1)
masterToggleGroup("Hacker Upgrades", {"AutoUpgradeHacker1", "AutoUpgradeHacker2", "AutoUpgradeHacker3", "AutoUpgradeHacker4"}, secU1)

local secU2 = createCollapsibleSection(upScroll, "Realm 2 Upgrades")
masterToggleGroup("Ice Upgrades", {"AutoRealm2MoreIce", "AutoRealm2WaterPump1", "AutoRealm2WaterPump2", "AutoRealm2MoreOofIce"}, secU2)
masterToggleGroup("Bucket Upgrades", {"AutoFillBucket1", "AutoFillBucket2", "AutoFillBucket3", "AutoFillBucket4", "AutoFillBucket5", "AutoFillBucket6", "AutoFillBucket7", "AutoFillBucket8", "AutoFillBucket9", "AutoFillBucket10", "AutoFillBucket11"}, secU2)
masterToggleGroup("Water Upgrades", {"AutoRealm2MoreWater", "AutoRealm2MoreOofWater", "AutoRealm2MorePlanks"}, secU2)
masterToggleGroup("Wood Upgrades", {"AutoWoodRankUp", "AutoWoodMoreWood", "AutoWoodSharperAxes", "AutoWoodBiggerDeposit", "AutoWoodFasterConversion", "AutoWoodMorePlanks", "AutoDepositWood"}, secU2)
masterToggleGroup("Planks Upgrades", {"AutoPlanksMorePlanks", "AutoPlanksMoreWood", "AutoPlanksWaterFromPlanks"}, secU2)

local secU3 = createCollapsibleSection(upScroll, "Gem Upgrades & Features")
createToggleRow(secU3, "More Oof (Gem)", "AutoGemMoreOof")
createToggleRow(secU3, "More Gems", "AutoGemMoreGems")
createToggleRow(secU3, "Stronger Pickaxes", "AutoGemStrongerPickaxes")
createToggleRow(secU3, "More Ore Stats", "AutoGemMoreOreStats")
createToggleRow(secU3, "Gem Converter", "AutoGemExchange")
createToggleRow(secU3, "Shop Teleport Loop", "AutoGemShopTeleport")

local secU4 = createCollapsibleSection(upScroll, "Realm 3 Upgrades")
masterToggleGroup("Meat Upgrades", {"AutoDepositMeat", "AutoMeatMoreMeat", "AutoMeatStrongerSwords", "AutoMeatMoreOof", "AutoMeatMoreBones"}, secU4)
masterToggleGroup("Bones Upgrades", {"AutoBonesMoreBones", "AutoBonesFasterSwords", "AutoBonesBiggerMeatDeposit"}, secU4)
masterToggleGroup("Souls Upgrades", {"AutoSoulsMoreSouls", "AutoSoulsLuckierSwords", "AutoSoulsMoreOof", "AutoSoulsMoreBones", "AutoSoulsRuneBulk"}, secU4)

local secU5 = createCollapsibleSection(upScroll, "Sand Upgrades")
createToggleRow(secU5, "Auto Sand Upgrades", "AutoSandUpgrades")
createToggleRow(secU5, "Auto Shovel Level Up", "AutoShovelLevelUp")
createToggleRow(secU5, "Auto Excavation Rank Up", "AutoExcavationRankUp")
createToggleRow(secU5, "Auto Regenerate Sand Layers", "AutoRegenSandLayers")
createTextBoxRow(secU5, "Target Sand Layer (1-250)", "TargetSandLayer")

-- NOOBS PAGE
local noobsScroll = makeVerticalScroll(noobsPage)
local secN1 = createCollapsibleSection(noobsScroll, "Realm 1 Noobs")
createToggleRow(secN1, "Starter Auto Upgrade", "AutoUpgradeStarter")
createToggleRow(secN1, "Cooker Auto Upgrade", "AutoUpgradeCooker")
createToggleRow(secN1, "Farmer Auto Upgrade", "AutoUpgradeFarmer")
createToggleRow(secN1, "Magician Auto Upgrade", "AutoUpgradeMagician")
createToggleRow(secN1, "Archer Auto Upgrade", "AutoUpgradeArcher")
createToggleRow(secN1, "Soldier Auto Upgrade", "AutoUpgradeSoldier")

local secN2 = createCollapsibleSection(noobsScroll, "Realm 2 Noobs")
createToggleRow(secN2, "Auto Upgrade Fisherman", "AutoUpgradeFishermanNoob")
createToggleRow(secN2, "Auto Upgrade Knight", "AutoUpgradeKnightNoob")
createToggleRow(secN2, "Auto Upgrade Explorer", "AutoUpgradeExplorerNoob")
createToggleRow(secN2, "Auto Upgrade Magician", "AutoUpgradeMagicianNoob")

local secN3 = createCollapsibleSection(noobsScroll, "Realm 3 Noobs")
createToggleRow(secN3, "Auto Upgrade Merchant", "AutoUpgradeMerchantNoob")
createToggleRow(secN3, "Auto Upgrade Mummy", "AutoUpgradeMummyNoob")
createToggleRow(secN3, "Auto Upgrade Pharaoh", "AutoUpgradePharaoh")

-- TRIALS PAGE
local trialsScroll = makeVerticalScroll(trialsPage)
local secT1 = createCollapsibleSection(trialsScroll, "Realm 3 Trials Automation (Scheduled :29 / :59)")
createToggleRow(secT1, "Auto Easy Trial", "AutoEasyTrial")
createToggleRow(secT1, "Auto Medium Trial", "AutoMediumTrial")
createToggleRow(secT1, "Auto Hard Trial", "AutoHardTrial")
createToggleRow(secT1, "Auto Leave If Stuck (60s Per Wave)", "AutoLeaveIfStuck")

-- MINES PAGE
local minesScroll = makeVerticalScroll(minesPage)
local secM1 = createCollapsibleSection(minesScroll, "Mining Configuration")
local bestTierActive = false
local bestTierBtn = Instance.new("TextButton")
bestTierBtn.Size = UDim2.new(1, -10, 0, 48)
bestTierBtn.BackgroundColor3 = Color3.fromRGB(35, 20, 55)
bestTierBtn.BackgroundTransparency = 0.5
bestTierBtn.TextColor3 = Color3.fromRGB(240, 235, 250)
bestTierBtn.TextSize = 13
bestTierBtn.Font = Enum.Font.GothamBold
bestTierBtn.Text = "Best Tier Only: DISABLED"
bestTierBtn.Parent = secM1

local btCorner = Instance.new("UICorner")
btCorner.CornerRadius = UDim.new(0, 8)
btCorner.Parent = bestTierBtn

bestTierBtn.MouseButton1Click:Connect(function()
    bestTierActive = not bestTierActive
    bestTierBtn.Text = bestTierActive and "Best Tier Only: ACTIVE" or "Best Tier Only: DISABLED"
    bestTierBtn.BackgroundColor3 = bestTierActive and Color3.fromRGB(168, 85, 247) or Color3.fromRGB(35, 20, 55)
    bestTierBtn.BackgroundTransparency = bestTierActive and 0 or 0.5

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

local speedContainer = Instance.new("Frame")
speedContainer.Size = UDim2.new(1, -10, 0, 60)
speedContainer.BackgroundColor3 = Color3.fromRGB(35, 20, 55)
speedContainer.BackgroundTransparency = 0.5
speedContainer.BorderSizePixel = 0
speedContainer.Parent = secM1

local scCorner = Instance.new("UICorner")
scCorner.CornerRadius = UDim.new(0, 8)
scCorner.Parent = speedContainer

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, -20, 0, 22)
speedLabel.Position = UDim2.new(0, 16, 0, 8)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.fromRGB(240, 235, 250)
speedLabel.TextSize = 13
speedLabel.Font = Enum.Font.GothamBold
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

local stCorner = Instance.new("UICorner")
stCorner.CornerRadius = UDim.new(1, 0)
stCorner.Parent = sliderTrack

local sliderFill = Instance.new("Frame")
local initialPercent = math.clamp(((Env.MiningJumpSpeed or 0.8) - 0.1) / 2.9, 0, 1)
sliderFill.Size = UDim2.new(initialPercent, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(168, 85, 247)
sliderFill.BorderSizePixel = 0
sliderFill.Parent = sliderTrack

local sfCorner = Instance.new("UICorner")
sfCorner.CornerRadius = UDim.new(1, 0)
sfCorner.Parent = sliderFill

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

local secM2 = createCollapsibleSection(minesScroll, "Basic Ores")
createToggleRow(secM2, "Stone", "AutoMineStone")
createToggleRow(secM2, "Coal", "AutoMineCoal")
createToggleRow(secM2, "Copper", "AutoMineCopper")
createToggleRow(secM2, "Iron", "AutoMineIron")
createToggleRow(secM2, "Silver", "AutoMineSilver")

local secM3 = createCollapsibleSection(minesScroll, "Advanced Ores")
createToggleRow(secM3, "Gold", "AutoMineGold")
createToggleRow(secM3, "Platinum", "AutoMinePlatinum")
createToggleRow(secM3, "Titanium", "AutoMineTitanium")
createToggleRow(secM3, "Uranium", "AutoMineUranium")
createToggleRow(secM3, "Cobalt", "AutoMineCobalt")

local secM4 = createCollapsibleSection(minesScroll, "End-Game Ores")
createToggleRow(secM4, "Palladium", "AutoMinePalladium")
createToggleRow(secM4, "Ruby", "AutoMineRuby")
createToggleRow(secM4, "Aetherite", "AutoMineAetherite")
createToggleRow(secM4, "Celestium", "AutoMineCelestium")
createToggleRow(secM4, "Voidsteel", "AutoMineVoidsteel")

-- MOBS PAGE
local mobsScroll = makeVerticalScroll(mobsPage)
local secMob1 = createCollapsibleSection(mobsScroll, "Realm 3 Mobs (Worst to Best)")
local bestMobTierActive = false
local bestMobTierBtn = Instance.new("TextButton")
bestMobTierBtn.Size = UDim2.new(1, -10, 0, 48)
bestMobTierBtn.BackgroundColor3 = Color3.fromRGB(35, 20, 55)
bestMobTierBtn.BackgroundTransparency = 0.5
bestMobTierBtn.TextColor3 = Color3.fromRGB(240, 235, 250)
bestMobTierBtn.TextSize = 13
bestMobTierBtn.Font = Enum.Font.GothamBold
bestMobTierBtn.Text = "Best Mob Tier Only: DISABLED"
bestMobTierBtn.Parent = secMob1

local bmtCorner = Instance.new("UICorner")
bmtCorner.CornerRadius = UDim.new(0, 8)
bmtCorner.Parent = bestMobTierBtn

bestMobTierBtn.MouseButton1Click:Connect(function()
    bestMobTierActive = not bestMobTierActive
    bestMobTierBtn.Text = bestMobTierActive and "Best Mob Tier Only: ACTIVE" or "Best Mob Tier Only: DISABLED"
    bestMobTierBtn.BackgroundColor3 = bestMobTierActive and Color3.fromRGB(168, 85, 247) or Color3.fromRGB(35, 20, 55)
    bestMobTierBtn.BackgroundTransparency = bestMobTierActive and 0 or 0.5

    local topOres = {"AutoMobDarkCommander", "AutoMobDarkKnight", "AutoMobSamuraiMaster"}
    local allMobs = {
        "AutoMobGoblin", "AutoMobSkeleton", "AutoMobOrc", "AutoMobPirate", "AutoMobNinja",
        "AutoMobWarrior", "AutoMobPirateCaptain", "AutoMobSamurai", "AutoMobPirateAdmiral",
        "AutoMobSamuraiMaster", "AutoMobDarkKnight", "AutoMobDarkCommander"
    }
    for _, mob in ipairs(allMobs) do Env[mob] = false end
    if bestMobTierActive then for _, mob in ipairs(topOres) do Env[mob] = true end end
    showToast(bestMobTierActive and "Best Mob Tier Only activated!" or "Best Mob Tier Only deactivated.")
end)

createToggleRow(secMob1, "Goblin", "AutoMobGoblin")
createToggleRow(secMob1, "Skeleton", "AutoMobSkeleton")
createToggleRow(secMob1, "Orc", "AutoMobOrc")
createToggleRow(secMob1, "Pirate", "AutoMobPirate")
createToggleRow(secMob1, "Ninja", "AutoMobNinja")
createToggleRow(secMob1, "Warrior", "AutoMobWarrior")
createToggleRow(secMob1, "Pirate Captain", "AutoMobPirateCaptain")
createToggleRow(secMob1, "Samurai", "AutoMobSamurai")
createToggleRow(secMob1, "Pirate Admiral", "AutoMobPirateAdmiral")
createToggleRow(secMob1, "Samurai Master", "AutoMobSamuraiMaster")
createToggleRow(secMob1, "Dark Knight", "AutoMobDarkKnight")
createToggleRow(secMob1, "Dark Commander", "AutoMobDarkCommander")

local secMob2 = createCollapsibleSection(mobsScroll, "Combat Utilities")
createToggleRow(secMob2, "Ancient Boss Farm (Supreme Shadow Lord)", "AutoAncientBossFarm")
createToggleRow(secMob2, "Combat Safe Spot Break (2s)", "AutoCombatBreak")
createToggleRow(secMob2, "Auto Start Ritual (Infinite Multi-Fire Loop)", "AutoStartRitual")
createRitualMobDropdown(secMob2, "Ritual Target Mobs", MobPriorityList)

-- FOOTBALL PAGE
local footballScroll = makeVerticalScroll(footballPage)
local secF1 = createCollapsibleSection(footballScroll, "Football Noobs")
createToggleRow(secF1, "Goalkeeper", "AutoUpgradeGoalkeeper")
createToggleRow(secF1, "Left Back", "AutoUpgradeLeftBack")
createToggleRow(secF1, "Left Centerback", "AutoUpgradeLeftCenterBack")
createToggleRow(secF1, "Right Centerback", "AutoUpgradeRightCenterBack")
createToggleRow(secF1, "Right Back", "AutoUpgradeRightBack")
createToggleRow(secF1, "Left Defensive Midfield", "AutoUpgradeLeftDefensiveMid")
createToggleRow(secF1, "Right Defensive Midfield", "AutoUpgradeRightDefensiveMid")
createToggleRow(secF1, "Attacking Mid", "AutoUpgradeAttackingMid")
createToggleRow(secF1, "Left Wing", "AutoUpgradeLeftWing")
createToggleRow(secF1, "Right Wing", "AutoUpgradeRightWing")
createToggleRow(secF1, "Striker", "AutoUpgradeStriker")

local secF2 = createCollapsibleSection(footballScroll, "Football Upgrades & Features")
createToggleRow(secF2, "Auto Score Goal", "AutoScoreGoal")
createToggleRow(secF2, "More Goals Upgrade", "AutoGoalsMoreGoals")
createToggleRow(secF2, "Goals Rune Bulk", "AutoGoalsRuneBulk")
createToggleRow(secF2, "Goals Rune Luck", "AutoGoalsRuneLuck")
createToggleRow(secF2, "Auto Football Tree", "AutoFootballTree")
createToggleRow(secF2, "Auto Buy Trophies", "AutoClaimTrophies")

-- MISC PAGE
local miscScroll = makeVerticalScroll(miscPage)
local secMis1 = createCollapsibleSection(miscScroll, "Runes")
createToggleRow(secMis1, "Auto Basic Rune Circle", "AutoRollBasicRune")
createToggleRow(secMis1, "Auto Super Rune Circle", "AutoRollSuperRune")
createToggleRow(secMis1, "Auto Advanced Rune", "AutoRollAdvancedRune")
createToggleRow(secMis1, "Auto Cosmic Prism", "AutoRollCosmicRune")
createToggleRow(secMis1, "Auto Snowy Rune Circle", "AutoRollSnowyRune")
createToggleRow(secMis1, "Auto Football Rune", "AutoRollFootballRune")
createToggleRow(secMis1, "Auto Dunes Rune Circle", "AutoRollDunesRune")
createToggleRow(secMis1, "Auto Sunfire Rune Circle", "AutoRollSunfireRune")

local secMis2 = createCollapsibleSection(miscScroll, "Capsules")
createToggleRow(secMis2, "Hatch Classic Capsule", "AutoOpenClassicCapsule")
createToggleRow(secMis2, "Hatch Football Capsule", "AutoOpenFootballCapsule")
createToggleRow(secMis2, "Hatch Super Capsule", "AutoOpenSuperCapsule")
createToggleRow(secMis2, "Hatch Ancient Capsule", "AutoOpenAncientCapsule")

-- SETTINGS PAGE
local settingsScroll = makeVerticalScroll(settingsPage)
local secSet1 = createCollapsibleSection(settingsScroll, "General Settings")
createToggleRow(secSet1, "Anti AFK Protection", "AntiAFK")
createToggleRow(secSet1, "FPS Booster Mode", "FPSBoostMode")
createToggleRow(secSet1, "Stats HUD Overlay", "ShowStatsHUD")
createToggleRow(secSet1, "CPU Saver Mode", "CPUSaverMode")

local secSet2 = createCollapsibleSection(settingsScroll, "Automation Settings")
createToggleRow(secSet2, "Auto Rebirth", "AutoRebirthTimer")
createToggleRow(secSet2, "Auto Prestige", "AutoPrestige")
createToggleRow(secSet2, "Mass Open T1 Chest", "AutoOpenT1Chest")
createToggleRow(secSet2, "Mass Open T2 Chest", "AutoOpenT2Chest")

local secSet3 = createCollapsibleSection(settingsScroll, "Emergency Controls")
local killRow = Instance.new("Frame") 
killRow.Size = UDim2.new(1, -10, 0, 48) 
killRow.BackgroundColor3 = Color3.fromRGB(35, 20, 55) 
killRow.BackgroundTransparency = 0.5
killRow.BorderSizePixel = 0 
killRow.Parent = secSet3

local krCorner = Instance.new("UICorner")
krCorner.CornerRadius = UDim.new(0, 8)
krCorner.Parent = killRow

local killLbl = Instance.new("TextLabel") 
killLbl.Size = UDim2.new(0.6, 0, 1, 0) 
killLbl.Position = UDim2.new(0, 16, 0, 0) 
killLbl.BackgroundTransparency = 1 
killLbl.TextColor3 = Color3.fromRGB(254, 202, 202) 
killLbl.TextSize = 13 
killLbl.Font = Enum.Font.GothamBold 
killLbl.Text = "Emergency Kill Switch" 
killLbl.TextXAlignment = Enum.TextXAlignment.Left 
killLbl.Parent = killRow

local killBtn = Instance.new("TextButton") 
killBtn.Size = UDim2.new(0, 110, 0, 30) 
killBtn.Position = UDim2.new(1, -118, 0.5, -15) 
killBtn.BackgroundColor3 = Color3.fromRGB(153, 27, 27) 
killBtn.TextColor3 = Color3.fromRGB(254, 226, 226) 
killBtn.TextSize = 11 
killBtn.Font = Enum.Font.GothamBold 
killBtn.Text = "TERMINATE" 
killBtn.Parent = killRow

local kbCorner = Instance.new("UICorner")
kbCorner.CornerRadius = UDim.new(0, 8)
kbCorner.Parent = killBtn

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

local function mainRoute(pOpen, bActive) 
    upgradesPage.Visible, noobsPage.Visible, minesPage.Visible, mobsPage.Visible, trialsPage.Visible, footballPage.Visible, miscPage.Visible, settingsPage.Visible = false, false, false, false, false, false, false, false; pOpen.Visible = true; 
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

-- LOCOMOTION & AUTOMATION ENGINES
local MasterTargetVector = nil  
local MiningTargetVector = nil
local MobTargetVector = nil
local TrialTargetVector = nil
local RitualTargetVector = nil
local SandTargetVector = nil

local Dest = {
    Basic = Vector3.new(1114.753, 10.310, -644.151), Super = Vector3.new(1082.093, 16.661, -782.021), Advanced = Vector3.new(1293.495, 16.515, -883.312),
    Cosmic = Vector3.new(783.450, 16.655, -855.972), Football = Vector3.new(-2713.261, 36.861, -15.832), Snowy = Vector3.new(1017.366, 5.866, 3262.671),
    ClassicCap = Vector3.new(-2586.923, 43.317, -659.105), FootballCap = Vector3.new(-2603.007, 36.295, -31.061), SuperCap = Vector3.new(618.032, 9.653, 3172.149),
    AncientCap = Vector3.new(714.6417236328125, 4.870510101318359, 7814.7265625),
    Dunes = Vector3.new(547.1116333007812, 2.187267780303955, 7826.4072265625),
    Sunfire = Vector3.new(692.3831176757812, 4.754001617431641, 7735.392578125),
    EasyTrial = Vector3.new(852.6607, 11.1623, 13442.8906),
    MediumTrial = Vector3.new(878.7848, 11.1781, 13417.0488),
    HardTrial = Vector3.new(910.2881, 11.1623, 13442.5009),
    CastleEntrance = Vector3.new(834.7246, 4.8552, 7622.6528),
    RitualChamber = Vector3.new(837.1246, 3.9983, 7904.0763),
    SandRegenPad = Vector3.new(557.1278076171875, 5.08376932144165, 7820.8671875)
}

local function GetWorldRoot() return player.Character and player.Character:FindFirstChild("HumanoidRootPart") end

local lastGlidingState = false
RunService.Stepped:Connect(function()
    if not Running then return end
    local char = player.Character
    if char then
        local isGliding = (MasterTargetVector ~= nil or MobTargetVector ~= nil or MiningTargetVector ~= nil or RitualTargetVector ~= nil or SandTargetVector ~= nil or Env.AutoRollSunfireRune or Env.AutoRollDunesRune or Env.AutoRollFootballRune or Env.AutoRollSnowyRune or Env.AutoRollCosmicRune or Env.AutoRollAdvancedRune or Env.AutoRollSuperRune or Env.AutoRollBasicRune)
        
        if isGliding ~= lastGlidingState then
            lastGlidingState = isGliding
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = not isGliding
                end
            end
        end
    end
end)

-- UNIFIED ZERO-DELAY INSTANT-SNAP MOVEMENT LOOP
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
            elseif SandTargetVector then act = SandTargetVector
            elseif Env.AutoRollSunfireRune then act = Dest.Sunfire
            elseif Env.AutoRollDunesRune then act = Dest.Dunes
            elseif Env.AutoRollFootballRune then act = Dest.Football elseif Env.AutoRollSnowyRune then act = Dest.Snowy
            elseif Env.AutoRollCosmicRune then act = Dest.Cosmic elseif Env.AutoRollAdvancedRune then act = Dest.Advanced
            elseif Env.AutoRollSuperRune then act = Dest.Super elseif Env.AutoRollBasicRune then act = Dest.Basic end
            
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

local function isMobRespawning(mobModel)
    if not mobModel then return true end
    for _, desc in ipairs(mobModel:GetDescendants()) do
        if desc:IsA("TextLabel") and desc.Text and desc.Text:lower():find("respawning") then
            return true
        end
    end
    return false
end

-- ANCIENT BOSS SPAWN LOOP (ANTI-SPAM DEBOUNCE)
task.spawn(function()
    while Running do
        task.wait(2.0)
        if Running and Env.AutoAncientBossFarm and not trialIsRunning and not ritualIsActive then
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
                    local args = {
                        [1] = "SpawnAncientMob",
                        [2] = "Supreme Shadow Lord"
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("__Net"):WaitForChild("MainRemote"):FireServer(unpack(args))
                    task.wait(3.0)
                end
            end)
        end
    end
end)

task.spawn(function()
    while Running do
        task.wait(1.0)
        if Running and Env.AutoStartRitual and not trialIsRunning then
            local hrp = GetWorldRoot()
            if hrp then
                hrp.Anchored = false
                hrp.CFrame = CFrame.new(Dest.RitualChamber)
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.AssemblyAngularVelocity = Vector3.zero
            end
            showToast("Ritual Chamber: Teleported to chamber!")
            task.wait(2.0)
            
            ritualTimer = 180
            ritualInCooldown = false
            ritualSuppressMobs = true
            ritualIsActive = true
            RitualTargetVector = Dest.RitualChamber
            
            for _ = 1, 5 do
                if not Running or not Env.AutoStartRitual or trialIsRunning then break end
                pcall(function()
                    local args = { [1] = "StartRitual" }
                    game:GetService("ReplicatedStorage"):WaitForChild("__Net"):WaitForChild("MainRemote"):FireServer(unpack(args))
                end)
                task.wait(1.0)
                ritualTimer = math.max(0, ritualTimer - 1)
            end
            
            RitualTargetVector = nil
            ritualIsActive = false
            ritualSuppressMobs = false
            currentTargetMob = nil
            MobTargetVector = nil
            
            while ritualTimer > 0 and Running and Env.AutoStartRitual and not trialIsRunning do
                task.wait(1.0)
                ritualTimer = ritualTimer - 1
                ritualInCooldown = ritualTimer <= 60
            end
            
            ritualTimer = 0
            ritualInCooldown = false
            ritualSuppressMobs = false
        else
            ritualTimer = 0
            ritualInCooldown = false
            ritualSuppressMobs = false
        end
    end
end)

-- SCHEDULED TRIAL AUTOMATION (STRICT CASTLE-ARRIVAL TOGGLE RESTORATION)
local lastTrialTriggeredMinute = -1
task.spawn(function()
    while Running do
        task.wait(1.0)
        if Running and (Env.AutoEasyTrial or Env.AutoMediumTrial or Env.AutoHardTrial) and not ritualIsActive then
            local timeTable = os.date("*t")
            local min = timeTable.min
            
            if (min == 29 or min == 59) and min ~= lastTrialTriggeredMinute then
                lastTrialTriggeredMinute = min
                
                local targetPad = nil
                if Env.AutoEasyTrial then targetPad = Dest.EasyTrial
                elseif Env.AutoMediumTrial then targetPad = Dest.MediumTrial
                elseif Env.AutoHardTrial then targetPad = Dest.HardTrial end
                
                if targetPad then
                    trialIsRunning = true
                    showToast("Trials: Scheduled trial time reached! Locking toggles & teleporting...")
                    
                    local cachedStates = {}
                    local flagsToPause = {
                        "AutoRegenSandLayers", "AutoFarmCash", "AutoStartRitual", "AutoGemExchange", "AutoGemShopTeleport", "AutoAncientBossFarm"
                    }
                    for _, mInfo in ipairs(MobPriorityList) do table.insert(flagsToPause, mInfo.F) end
                    for _, oInfo in ipairs(OrePriorityList) do table.insert(flagsToPause, oInfo.F) end
                    
                    for _, flagName in ipairs(flagsToPause) do
                        cachedStates[flagName] = Env[flagName]
                        Env[flagName] = false
                    end
                    
                    local hrp = GetWorldRoot()
                    if hrp then
                        hrp.Anchored = false
                        hrp.CFrame = CFrame.new(targetPad)
                        hrp.AssemblyLinearVelocity = Vector3.zero
                        hrp.AssemblyAngularVelocity = Vector3.zero
                    end
                    
                    showToast("Trials: Waiting 60s for trial countdown...")
                    local waitElapsed = 0
                    while waitElapsed < 60 and Running and trialIsRunning do
                        task.wait(1.0)
                        waitElapsed = waitElapsed + 1
                    end
                    
                    showToast("Trials: Zero-delay instant mob clearing active across all waves...")
                    
                    local currentWaveText = ""
                    local waveTimer = tick()
                    
                    while Running and trialIsRunning do
                        task.wait(1.0)
                        
                        pcall(function()
                            local hrpCheck = GetWorldRoot()
                            if hrpCheck and hrpCheck.Position.Z < 13000 then
                                trialIsRunning = false
                            end
                        end)
                        
                        if not trialIsRunning then break end
                        
                        pcall(function()
                            for _, lbl in ipairs(player.PlayerGui:GetDescendants()) do
                                if lbl:IsA("TextLabel") and lbl.Text and lbl.Text:lower():find("wave") then
                                    if lbl.Text ~= currentWaveText then
                                        currentWaveText = lbl.Text
                                        waveTimer = tick()
                                    end
                                    break
                                end
                            end
                        end)
                        
                        if Env.AutoLeaveIfStuck and (tick() - waveTimer > 60) then
                            showToast("Trials: Anti-stuck triggered (Stuck on wave >60s). Exiting trial...")
                            pcall(function()
                                for _, btn in ipairs(player.PlayerGui:GetDescendants()) do
                                    if btn:IsA("TextButton") and btn.Text and btn.Text:lower():find("leave trial") then
                                        if getconnections then
                                            for _, conn in ipairs(getconnections(btn.MouseButton1Click)) do
                                                conn:Fire()
                                            end
                                        else
                                            firesignal(btn.MouseButton1Click)
                                        end
                                    end
                                end
                            end)
                            task.wait(1.0)
                            trialIsRunning = false
                            break
                        end
                    end
                    
                    -- Safe surface relocation: Teleport back to Castle Entrance
                    showToast("Trials: Completed / Exited! Relocating to surface...")
                    pcall(function()
                        local hrp = GetWorldRoot()
                        if hrp then
                            hrp.Anchored = false
                            hrp.CFrame = CFrame.new(Dest.CastleEntrance)
                            hrp.AssemblyLinearVelocity = Vector3.zero
                            hrp.AssemblyAngularVelocity = Vector3.zero
                        end
                    end)
                    
                    -- STRICT CASTLE ARRIVAL LOCK: Wait until player is physically at the castle before restoring toggles
                    local castleWait = 0
                    while Running do
                        task.wait(0.2)
                        castleWait = castleWait + 0.2
                        local hrpCheck = GetWorldRoot()
                        if hrpCheck and (hrpCheck.Position - Dest.CastleEntrance).Magnitude < 50 then
                            break
                        end
                        if castleWait > 6.0 then
                            break
                        end
                    end
                    
                    task.wait(1.0) -- Stability buffer
                    
                    -- Restore all previously cached automation toggles ONLY AFTER ARRIVING AT CASTLE
                    for flagName, state in pairs(cachedStates) do
                        Env[flagName] = state
                    end
                    trialIsRunning = false
                    showToast("Trials: Successfully returned to castle! Toggles restored.")
                end
            end
        end
    end
end)

-- SAFE ZONE COMBAT BREAK
task.spawn(function()
    while Running do
        task.wait(40.0)
        if Running and Env.AutoCombatBreak and not trialIsRunning and not ritualIsActive then
            local activeMobStates = {}
            local anyActive = false
            for i = 1, #MobPriorityList do
                if Env[MobPriorityList[i].F] then
                    activeMobStates[MobPriorityList[i].F] = true
                    Env[MobPriorityList[i].F] = false
                    anyActive = true
                end
            end
            
            if anyActive then
                MobTargetVector = nil
                currentTargetMob = nil
                MasterTargetVector = Vector3.new(919.1552, 4.8658, 7905.8755)
                showToast("Safe Spot Break...")
                task.wait(0.5)
                MasterTargetVector = nil
                
                pcall(function()
                    local args = { [1] = "DepositMeat" }
                    game:GetService("ReplicatedStorage"):WaitForChild("__Net"):WaitForChild("MainRemote"):FireServer(unpack(args))
                end)
                
                task.wait(1.5)
                for flag, state in pairs(activeMobStates) do
                    Env[flag] = state
                end
            end
        end
    end
end)

local currentMobIndex = 1
local lastTargetedPart = nil

-- ZERO-DELAY INSTANT CORPSE-SKIPPING TRIAL & OVERWORLD MOB FARMING ENGINE
task.spawn(function()
    while Running do
        task.wait(0.01) -- 10ms super-tight poll rate
        if Running and not ritualIsActive and not ritualSuppressMobs and RitualTargetVector == nil and SandTargetVector == nil then
            local enabledMobNames = {} 
            local hasAnyMobEnabled = false

            if trialIsRunning then
                hasAnyMobEnabled = true
            elseif Env.AutoStartRitual and ritualTimer > 0 and ritualTimer <= 175 then
                for mobName, selected in pairs(Env.RitualSelectedMobs) do
                    if selected then
                        enabledMobNames[mobName] = true
                        hasAnyMobEnabled = true
                    end
                end
            else
                for i = 1, #MobPriorityList do 
                    if Env[MobPriorityList[i].F] then 
                        enabledMobNames[MobPriorityList[i].N] = true 
                        hasAnyMobEnabled = true 
                    end 
                end
            end

            if hasAnyMobEnabled then
                local foundMobPart = nil
                
                if trialIsRunning then
                    -- Clean up deadMobs cache
                    for mobModel, _ in pairs(deadMobs) do
                        if not mobModel:IsDescendantOf(workspace) then
                            deadMobs[mobModel] = nil
                        end
                    end

                    local gc = workspace:FindFirstChild("__GAME_CONTENT")
                    local trialsFolder = gc and gc:FindFirstChild("Trials")
                    if trialsFolder then
                        local shortestDist = math.huge
                        local hrp = GetWorldRoot()
                        for _, roomObj in ipairs(trialsFolder:GetChildren()) do
                            local mFolder = roomObj:FindFirstChild("Mobs")
                            if mFolder then
                                for _, mobObj in ipairs(mFolder:GetChildren()) do
                                    if mobObj:IsA("Model") and not isMobRespawning(mobObj) and not deadMobs[mobObj] then
                                        local part = mobObj.PrimaryPart or mobObj:FindFirstChildWhichIsA("BasePart")
                                        if part then
                                            local isActuallyDead = false
                                            for _, desc in ipairs(mobObj:GetDescendants()) do
                                                if desc:IsA("TextLabel") and desc.Text then
                                                    local txt = desc.Text:gsub(",", "")
                                                    if txt:find("^0%s*/") or txt == "0" then
                                                        isActuallyDead = true
                                                        deadMobs[mobObj] = true
                                                        break
                                                    end
                                                end
                                            end
                                            
                                            if not isActuallyDead and hrp then
                                                local dist = (part.Position - hrp.Position).Magnitude
                                                if dist < shortestDist then
                                                    shortestDist = dist
                                                    foundMobPart = part
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                else
                    local gc = workspace:FindFirstChild("__GAME_CONTENT") 
                    local mobsFolder = gc and gc:FindFirstChild("Mobs")
                    if mobsFolder then
                        for i = #MobPriorityList, 1, -1 do
                            local targetMobName = MobPriorityList[i].N
                            if enabledMobNames[targetMobName] then
                                for _, mobObj in ipairs(mobsFolder:GetChildren()) do
                                    if mobObj:IsA("Model") and mobObj.Name == targetMobName and not isMobRespawning(mobObj) then
                                        local part = mobObj.PrimaryPart or mobObj:FindFirstChildWhichIsA("BasePart")
                                        if part and part ~= lastTargetedPart then
                                            foundMobPart = part
                                            break
                                        end
                                    end
                                end
                            end
                            if foundMobPart then break end
                        end
                    end
                end
                
                currentTargetMob = foundMobPart
                if currentTargetMob then
                    lastTargetedPart = currentTargetMob
                    if currentTargetMob ~= lastTrackedMobPart then
                        lastTrackedMobPart = currentTargetMob
                        mobsKilled = mobsKilled + 1
                    end
                end
                
                if currentTargetMob and currentTargetMob.Parent then 
                    MobTargetVector = currentTargetMob.Position + Vector3.new(0, 1, 0)
                else 
                    MobTargetVector = nil 
                end
            else 
                currentTargetMob = nil 
                MobTargetVector = nil 
                mobsKilled = 0
                lastTrackedMobPart = nil
                lastTargetedPart = nil
            end
        end
    end
end)

-- SAND REGENERATION LOOP (250 LAYERS)
task.spawn(function()
    while Running do
        task.wait(1.0)
        if Running and Env.AutoRegenSandLayers and not trialIsRunning and not ritualIsActive then
            showToast("Sand Regen: Teleporting to pit...")
            pcall(function()
                local hrp = GetWorldRoot()
                if hrp then
                    hrp.Anchored = false
                    hrp.CFrame = CFrame.new(Dest.Dunes)
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                end
            end)
            task.wait(1.0)
            
            local reachedTarget = false
            local targetLayer = tonumber(Env.TargetSandLayer) or 3
            
            while Running and Env.AutoRegenSandLayers and not trialIsRunning and not ritualIsActive and not reachedTarget do
                task.wait(1.0)
                pcall(function()
                    local layersFolder = workspace:FindFirstChild("GeneratedSandLayers", true)
                    if layersFolder then
                        local targetFound = false
                        local totalRemaining = 0
                        for _, child in ipairs(layersFolder:GetChildren()) do
                            totalRemaining = totalRemaining + 1
                            local idx = child:GetAttribute("LayerIndex")
                            if idx and tonumber(idx) <= targetLayer then
                                targetFound = true
                            end
                        end
                        if not targetFound or totalRemaining <= math.max(0, 20 - targetLayer) then
                            reachedTarget = true
                        end
                    else
                        local hrp = GetWorldRoot()
                        if hrp then
                            local depth = math.abs(hrp.Position.Y - Dest.Dunes.Y)
                            if (depth / 5) >= targetLayer then
                                reachedTarget = true
                            end
                        end
                    end
                end)
            end
            
            if reachedTarget and Running and Env.AutoRegenSandLayers then
                showToast("Sand Regen: Target layer reached! Regen pad...")
                SandTargetVector = Dest.SandRegenPad
                task.wait(2.5)
                SandTargetVector = nil
                task.wait(1.5)
            end
        end
    end
end)

-- GEM LOOPS
task.spawn(function()
    while Running do
        task.wait(60.0)
        if Running and Env.AutoGemExchange and not Env.AutoGemShopTeleport then
            pcall(function()
                local args = { [1] = "ExchangeAllMinerals" }
                game:GetService("ReplicatedStorage"):WaitForChild("__Net"):WaitForChild("MainRemote"):FireServer(unpack(args))
            end)
            showToast("Gem Converter: Exchanged minerals!")
        end
    end
end)

task.spawn(function()
    while Running do
        task.wait(0.5)
        if Running and Env.AutoGemShopTeleport and not Env.AutoGemExchange then
            MasterTargetVector = Vector3.new(623.851, 8.781, 3210.993)
        elseif MasterTargetVector == Vector3.new(623.851, 8.781, 3210.993) and not Env.AutoGemShopTeleport then
            MasterTargetVector = nil
        end
    end
end)

task.spawn(function()
    while Running do
        task.wait(60.0)
        if Running and Env.AutoGemExchange and Env.AutoGemShopTeleport then
            pcall(function()
                MasterTargetVector = Vector3.new(623.851, 8.781, 3210.993)
                task.wait(6.0)
                local args = { [1] = "ExchangeAllMinerals" }
                game:GetService("ReplicatedStorage"):WaitForChild("__Net"):WaitForChild("MainRemote"):FireServer(unpack(args))
                task.wait(1.0)
                MasterTargetVector = nil
            end)
            showToast("Gem Shop Pitstop Completed!")
        end
    end
end)

local currentOreIndex = 1
local lastOreJumpTick = 0

local function isOreRespawning(oreModel)
    local desc = oreModel:FindFirstChildWhichIsA("TextLabel", true)
    if desc and desc.Text:lower():find("respawning") then return true end
    return false
end

task.spawn(function()
    while Running do
        task.wait(Env.CPUSaverMode and 0.25 or 0.1)
        if Running and not trialIsRunning and not ritualIsActive then
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
                
                if currentTargetPanel and currentTargetPanel.Parent then MiningTargetVector = currentTargetPanel.Position else MiningTargetVector = nil end
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
        if Running then
            local hrp = GetWorldRoot()
            if hrp then
                if Env.AutoOpenClassicCapsule then if (hrp.Position - Dest.ClassicCap).Magnitude > 10 then hrp.CFrame = CFrame.new(Dest.ClassicCap) end pcall(function() local args = { [1] = "ToggleMinionAutoOpen", [2] = "Classic" } game:GetService("ReplicatedStorage"):WaitForChild("__Net"):WaitForChild("MainRemote"):FireServer(unpack(args)) end)
                elseif Env.AutoOpenFootballCapsule then if (hrp.Position - Dest.FootballCap).Magnitude > 10 then hrp.CFrame = CFrame.new(Dest.FootballCap) end pcall(function() local args = { [1] = "ToggleMinionAutoOpen", [2] = "Football" } game:GetService("ReplicatedStorage"):WaitForChild("ReplicatedStorage"):WaitForChild("__Net"):WaitForChild("MainRemote"):FireServer(unpack(args)) end)
                elseif Env.AutoOpenSuperCapsule then if (hrp.Position - Dest.SuperCap).Magnitude > 10 then hrp.CFrame = CFrame.new(Dest.SuperCap) end pcall(function() local args = { [1] = "ToggleMinionAutoOpen", [2] = "Super" } game:GetService("ReplicatedStorage"):WaitForChild("ReplicatedStorage"):WaitForChild("__Net"):WaitForChild("MainRemote"):FireServer(unpack(args)) end)
                elseif Env.AutoOpenAncientCapsule then if (hrp.Position - Dest.AncientCap).Magnitude > 10 then hrp.CFrame = CFrame.new(Dest.AncientCap) end pcall(function() local args = { [1] = "ToggleMinionAutoOpen", [2] = "Ancient" } game:GetService("ReplicatedStorage"):WaitForChild("ReplicatedStorage"):WaitForChild("__Net"):WaitForChild("MainRemote"):FireServer(unpack(args)) end) end
            end
        end
    end
end)

task.spawn(function()
    while Running do
        task.wait(0.5)
        if Env.AutoFarmCash and Running and not trialIsRunning and not ritualIsActive then
            local gc = workspace:FindFirstChild("__GAME_CONTENT") local ty = gc and gc:FindFirstChild("Tycoon") local btnF = ty and ty:FindFirstChild("Buttons")
            if btnF and Running then
                local locked = {} 
                repeat
                    if not Running or not Env.AutoFarmCash or trialIsRunning or ritualIsActive then break end
                    local vis = btnF:GetChildren() local att = false
                    for i = 1, #vis do
                        if not Running or not Env.AutoFarmCash then break end
                        local bM = vis[i]
                        if bM and bM:IsA("Model") and not locked[bM.Name] then
                            local tb = bM:FindFirstChild("BuyingButtonPart", true)
                            if tb and tb:IsA("BasePart") and Running then
                                att = true MasterTargetVector = tb.Position task.wait(0.4)
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
    {F="AutoUpgradeFishermanNoob",T="UpgradeNoobMax",A={"Fisherman"}}, {F="AutoUpgradeKnightNoob",T="UpgradeNoobMax",A={"Knight"}}, {F="AutoUpgradeExplorerNoob",T="UpgradeNoobMax",A={"Explorer"}}, {F="AutoUpgradeMagicianNoob",T="UpgradeNoobMax",A={"Magician"}}, {F="AutoUpgradeMerchantNoob",T="UpgradeNoobMax",A={"Merchant"}}, {F="AutoUpgradeMummyNoob",T="UpgradeNoobMax",A={"Mummy"}},
    {F="AutoUpgradeGoalkeeper",T="UpgradeNoobMax",A={"Goalkeeper"}}, {F="AutoUpgradeLeftBack",T="UpgradeNoobMax",A={"LeftBack"}}, {F="AutoUpgradeLeftCenterBack",T="UpgradeNoobMax",A={"LeftCenterBack"}}, {F="AutoUpgradeRightCenterBack",T="UpgradeNoobMax",A={"RightCenterBack"}}, {F="AutoUpgradeRightBack",T="UpgradeNoobMax",A={"RightBack"}}, {F="AutoUpgradeLeftDefensiveMid",T="UpgradeNoobMax",A={"LeftDefensiveMid"}}, {F="AutoUpgradeRightDefensiveMid",T="UpgradeNoobMax",A={"RightDefensiveMid"}}, {F="AutoUpgradeAttackingMid",T="UpgradeNoobMax",A={"AttackingMid"}}, {F="AutoUpgradeLeftWing",T="UpgradeNoobMax",A={"LeftWing"}}, {F="AutoUpgradeRightWing",T="UpgradeNoobMax",A={"RightWing"}}, {F="AutoUpgradeStriker",T="UpgradeNoobMax",A={"Striker"}},
    {F="AutoUpgradeMoreOof",T="UpgradeUpgradeMax",A={"Oof","MoreOof"}}, {F="AutoUpgradeFasterNoobs",T="UpgradeUpgradeMax",A={"Oof","FasterNoobs"}},
    {F="AutoRealm2MoreOof",T="UpgradeUpgradeMax",A={"Oof","MoreOofRealm2"}}, {F="AutoRealm2MoreWalkSpeed",T="UpgradeUpgradeMax",A={"Oof","MoreWalkSpeedRealm2"}}, {F="AutoRealm2MoreWater",T="UpgradeUpgradeMax",A={"Water","MoreWater"}}, {F="AutoRealm2MoreOofWater",T="UpgradeUpgradeMax",A={"Water","MoreOof"}}, {F="AutoRealm2MorePlanks",T="UpgradeUpgradeMax",A={"Water","MorePlanks"}}, {F="AutoRealm2MoreIce",T="UpgradeUpgradeMax",A={"Ice","MoreIce"}}, {F="AutoRealm2WaterPump1",T="UpgradeUpgradeMax",A={"Ice","WaterPumpNoobHire"}}, {F="AutoRealm2WaterPump2",T="UpgradeUpgradeMax",A={"Ice","WaterFromIce"}}, {F="AutoRealm2MoreOofIce",T="UpgradeUpgradeMax",A={"Ice","MoreOof"}},
    {F="AutoWoodRankUp",T="WoodRankUp",A={}}, {F="AutoWoodMoreWood",T="UpgradeUpgradeMax",A={"Wood","MoreWood"}}, {F="AutoWoodSharperAxes",T="UpgradeUpgradeMax",A={"Wood","SharperAxes"}}, {F="AutoWoodBiggerDeposit",T="UpgradeUpgradeMax",A={"Wood","BiggerWoodDeposit"}}, {F="AutoWoodFasterConversion",T="UpgradeUpgradeMax",A={"Wood","FasterWoodConversion"}}, {F="AutoWoodMorePlanks",T="UpgradeUpgradeMax",A={"Wood","MorePlanksFromWood"}},
    {F="AutoPlanksMorePlanks",T="UpgradeUpgradeMax",A={"Planks","MorePlanks"}}, {F="AutoPlanksMoreWood",T="UpgradeUpgradeMax",A={"Planks","MoreWood"}}, {F="AutoPlanksWaterFromPlanks",T="UpgradeUpgradeMax",A={"Planks","WaterFromPlanks"}},
    {F="AutoRebirthMoreOof",T="UpgradeUpgradeMax",A={"Rebirth","MoreOof"}}, {F="AutoRebirthMoreRebirth",T="UpgradeUpgradeMax",A={"Rebirth","MoreRebirth"}}, {F="AutoRebirthMoreFire",T="UpgradeUpgradeMax",A={"Rebirth","MoreFire"}},
    {F="AutoFireMoreFire",T="UpgradeUpgradeMax",A={"Fire","MoreFire"}}, {F="AutoFireMoreBulk",T="UpgradeUpgradeMax",A={"Fire","MoreBulk"}}, {F="AutoFireMoreOof",T="UpgradeUpgradeMax",A={"Fire","MoreOof"}}, {F="AutoFireMoreRebirth",T="UpgradeUpgradeMax",A={"Fire","MoreRebirth"}}, {F="AutoFireMoreTierLuck",T="UpgradeUpgradeMax",A={"Fire","MoreTierLuck"}}, {F="AutoFireMoreCashBonus",T="UpgradeUpgradeMax",A={"Fire","MoreCashBonus"}},
    {F="AutoUpgradeMoreCash",T="UpgradeUpgradeMax",A={"Cash","MoreCash"}}, {F="AutoUpgradeFasterDropper",T="UpgradeUpgradeMax",A={"Cash","FasterDropper"}}, {F="AutoUpgradeMoreRuneLuck",T="UpgradeUpgradeMax",A={"Cash","MoreRuneLuck"}},
    {F="AutoGoalsMoreGoals",T="UpgradeUpgradeMax",A={"Goals","MoreGoals"}}, {F="AutoGoalsRuneBulk",T="UpgradeUpgradeMax",A={"Goals","RuneBulk"}}, {F="AutoGoalsRuneLuck",T="UpgradeUpgradeMax",A={"Goals","RuneLuck"}},
    {F="AutoSandUpgrades",T="UpgradeUpgradeMax",A={"Sand","MoreSand"}},
    {F="AutoSandUpgrades",T="UpgradeUpgradeMax",A={"Sand","MultiSand"}},
    {F="AutoSandUpgrades",T="UpgradeUpgradeMax",A={"Sand","StrongerShovels"}},
    {F="AutoSandUpgrades",T="UpgradeUpgradeMax",A={"Sand","FasterShovels"}},
    {F="AutoSandUpgrades",T="UpgradeUpgradeMax",A={"Sand","AlotSand"}},
    {F="AutoSandUpgrades",T="UpgradeUpgradeMax",A={"Sand","MoreOof"}},
    {F="AutoShovelLevelUp",T="ShovelLevelUp",A={}},
    {F="AutoExcavationRankUp",T="ExcavationRankUp",A={}}
}

task.spawn(function()
    while Running do
        task.wait(Env.CPUSaverMode and 2.0 or 1.0)
        if Running then
            for i = 1, #PrimaryUpgradeQueue do
                if not Running then break end 
                local item = PrimaryUpgradeQueue[i]
                if Env[item.F] then 
                    pcall(function() 
                        local args = {}
                        args[1] = item.T
                        for _, aVal in ipairs(item.A) do table.insert(args, aVal) end
                        game:GetService("ReplicatedStorage"):WaitForChild("__Net"):WaitForChild("MainRemote"):FireServer(unpack(args)) 
                    end) 
                    task.wait(0.25) 
                end
            end
        end
    end
end)

local MeatUpgradeList = {
    {F = "AutoMeatMoreMeat", T = "UpgradeUpgradeMax", A = {"Meat", "MoreMeat"}},
    {F = "AutoMeatStrongerSwords", T = "UpgradeUpgradeMax", A = {"Meat", "StrongerSwords"}},
    {F = "AutoMeatMoreOof", T = "UpgradeUpgradeMax", A = {"Meat", "MoreOof"}},
    {F = "AutoMeatMoreBones", T = "UpgradeUpgradeMax", A = {"Meat", "MoreBones"}}
}

task.spawn(function()
    local mIdx = 1
    while Running do
        task.wait(0.35)
        if Running then
            local att = 0
            repeat
                local cur = MeatUpgradeList[mIdx]
                mIdx = (mIdx % #MeatUpgradeList) + 1
                att = att + 1
                if Env[cur.F] then
                    pcall(function() 
                        local args = { [1] = cur.T, [2] = cur.A[1], [3] = cur.A[2] }
                        game:GetService("ReplicatedStorage"):WaitForChild("__Net"):WaitForChild("MainRemote"):FireServer(unpack(args)) 
                    end)
                    break
                end
            until att >= #MeatUpgradeList
        end
    end
end)

local BonesUpgradeList = {
    {F = "AutoBonesMoreBones", T = "UpgradeUpgradeMax", A = {"Bones", "MoreBones"}},
    {F = "AutoBonesFasterSwords", T = "UpgradeUpgradeMax", A = {"Bones", "FasterSwords"}},
    {F = "AutoBonesBiggerMeatDeposit", T = "UpgradeUpgradeMax", A = {"Bones", "BiggerMeatDeposit"}},
    {F = "AutoBonesFasterMeatConversion", T = "UpgradeUpgradeMax", A = {"Bones", "FasterMeatConversion"}},
    {F = "AutoBonesEvenMoreBones", T = "UpgradeUpgradeMax", A = {"Bones", "EvenMoreBones"}}
}

task.spawn(function()
    local bIdx = 1
    while Running do
        task.wait(0.45)
        if Running then
            local att = 0
            repeat
                local cur = BonesUpgradeList[bIdx]
                bIdx = (bIdx % #BonesUpgradeList) + 1
                att = att + 1
                if Env[cur.F] then
                    pcall(function() 
                        local args = { [1] = cur.T, [2] = cur.A[1], [3] = cur.A[2] }
                        game:GetService("ReplicatedStorage"):WaitForChild("__Net"):WaitForChild("MainRemote"):FireServer(unpack(args)) 
                    end)
                    break
                end
            until att >= #BonesUpgradeList
        end
    end
end)

local SoulsUpgradeList = {
    {F = "AutoSoulsMoreSouls", T = "UpgradeUpgradeMax", A = {"Souls", "MoreSouls"}},
    {F = "AutoSoulsLuckierSwords", T = "UpgradeUpgradeMax", A = {"Souls", "LuckierSwords"}},
    {F = "AutoSoulsMoreOof", T = "UpgradeUpgradeMax", A = {"Souls", "MoreOof"}},
    {F = "AutoSoulsMoreBones", T = "UpgradeUpgradeMax", A = {"Souls", "MoreBones"}},
    {F = "AutoSoulsRuneBulk", T = "UpgradeUpgradeMax", A = {"Souls", "RuneBulk"}}
}

task.spawn(function()
    local sIdx = 1
    while Running do
        task.wait(0.55)
        if Running then
            local att = 0
            repeat
                local cur = SoulsUpgradeList[sIdx]
                sIdx = (sIdx % #SoulsUpgradeList) + 1
                att = att + 1
                if Env[cur.F] then
                    pcall(function() 
                        local args = { [1] = cur.T, [2] = cur.A[1], [3] = cur.A[2] }
                        game:GetService("ReplicatedStorage"):WaitForChild("__Net"):WaitForChild("MainRemote"):FireServer(unpack(args)) 
                    end)
                    break
                end
            until att >= #SoulsUpgradeList
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
        task.wait(0.65)
        if Running then
            local att = 0
            repeat
                local cur = GemUpgradeList[gIdx]
                gIdx = (gIdx % #GemUpgradeList) + 1
                att = att + 1
                if Env[cur.F] then
                    pcall(function() 
                        local args = { [1] = cur.T, [2] = cur.A[1], [3] = cur.A[2] }
                        game:GetService("ReplicatedStorage"):WaitForChild("__Net"):WaitForChild("MainRemote"):FireServer(unpack(args)) 
                    end)
                    break
                end
            until att >= #GemUpgradeList
        end
    end
end)

task.spawn(function() while Running do task.wait(0.5) if Running then for i = 1, 11 do if Env["AutoFillBucket" .. i] then pcall(function() local args = { [1] = "FillWaterBucket", [2] = i } game:GetService("ReplicatedStorage"):WaitForChild("__Net"):WaitForChild("MainRemote"):FireServer(unpack(args)) end) task.wait(0.2) end end end end end)

task.spawn(function() while Running do task.wait(0.2) if Running and Env.AutoScoreGoal then pcall(function() local args = { [1] = "RegisterFootballKick" } game:GetService("ReplicatedStorage"):WaitForChild("__Net"):WaitForChild("MainRemote"):FireServer(unpack(args)) end) task.wait(1.5) if not Running or not Env.AutoScoreGoal then break end pcall(function() local args = { [1] = "ScoreGoal" } game:GetService("ReplicatedStorage"):WaitForChild("__Net"):WaitForChild("MainRemote"):FireServer(unpack(args)) end) task.wait(1.5) end end end)

task.spawn(function()
    while Running do
        if Running and Env.AutoFootballTree then
            local pGui = player:FindFirstChild("PlayerGui") local treeGui = pGui and pGui:FindFirstChild("FootballUITree")
            if treeGui then
                for _, obj in pairs(treeGui:GetDescendants()) do
                    if not Running or not Env.AutoFootballTree then break end
                    if (obj:IsA("GuiButton") or obj:IsA("Frame")) and obj.Name ~= "Main" and obj.Name ~= "Container" then 
                        pcall(function() 
                            local args = { [1] = "BuyFootballUITreeNode", [2] = obj.Name }
                            game:GetService("ReplicatedStorage"):WaitForChild("__Net"):WaitForChild("MainRemote"):FireServer(unpack(args)) 
                        end) 
                        task.wait(0.5) 
                    end
                end
            end
        end
        task.wait(5.0)
    end
end)

task.spawn(function() while Running do task.wait(3.0) if Running and Env.AutoClaimTrophies then for i = 1, 10 do if not Running or not Env.AutoClaimTrophies then break end pcall(function() local args = { [1] = "BuyTrophy", [2] = i } game:GetService("ReplicatedStorage"):WaitForChild("__Net"):WaitForChild("MainRemote"):FireServer(unpack(args)) end) task.wait(0.2) end end end end)

local BreadUpgradeList = { {F="AutoBreadMoreWheat",T="UpgradeUpgradeMax",A={"Bread","MoreWheat"}}, {F="AutoBreadMoreBread",T="UpgradeUpgradeMax",A={"Bread","MoreBread"}}, {F="AutoBreadMoreBread2",T="UpgradeUpgradeMax",A={"Bread","MoreBread2"}}, {F="AutoBreadBiggerWheatDeposit",T="UpgradeUpgradeMax",A={"Bread","BiggerWheatDeposit"}}, {F="AutoBreadFasterWheatConversion",T="UpgradeUpgradeMax",A={"Bread","FasterWheatConversion"}}, {F="AutoBreadMoreConsumption",T="UpgradeUpgradeMax",A={"Bread","MoreConsumption"}}, {F="AutoBreadMoreRuneLuck",T="UpgradeUpgradeMax",A={"Bread","MoreRuneLuck"}}, {F="AutoBreadMoreTierLuck",T="UpgradeUpgradeMax",A={"Bread","MoreTierLuck"}}, {F="AutoUpgradeCow",T="UpgradeAnimal",A={"Cow"}}, {F="AutoUpgradeChicken",T="UpgradeAnimal",A={"Chicken"}}, {F="AutoBuyCow",T="BuyAnimal",A={"Cow",true}}, {F="AutoBuyChicken",T="BuyAnimal",A={"Chicken",true}} }
task.spawn(function() local bIdx = 1 while Running do task.wait(1.2) if Running then local att = 0 repeat local cur = BreadUpgradeList[bIdx] bIdx = (bIdx % #BreadUpgradeList) + 1 att = att + 1 if Env[cur.F] then pcall(function() local args = { [1] = cur.T, [2] = cur.A[1], [3] = cur.A[2] } game:GetService("ReplicatedStorage"):WaitForChild("__Net"):WaitForChild("MainRemote"):FireServer(unpack(args)) end) break end until att >= #BreadUpgradeList end end end)

task.spawn(function() 
    while Running do 
        task.wait(60.0) 
        if Running then 
            pcall(function() 
                local args = { [1] = "DepositMeat" }
                game:GetService("ReplicatedStorage"):WaitForChild("__Net"):WaitForChild("MainRemote"):FireServer(unpack(args)) 
            end) 
        end 
    end 
end)

task.spawn(function() 
    while Running do 
        task.wait(30.0) 
        if Running then 
            if Env.AutoDepositWheat then pcall(function() local args = { [1] = "DepositWheat" } game:GetService("ReplicatedStorage"):WaitForChild("__Net"):WaitForChild("MainRemote"):FireServer(unpack(args)) end) end 
            if Env.AutoDepositWood then pcall(function() local args = { [1] = "DepositWood" } game:GetService("ReplicatedStorage"):WaitForChild("__Net"):WaitForChild("MainRemote"):FireServer(unpack(args)) end) end 
        end 
    end 
end)

task.spawn(function() while Running do task.wait(1.0) if Running then if Env.AutoBlazeMoreBlaze then pcall(function() local args = { [1] = "UpgradeUpgradeMax", [2] = "Blaze", [3] = "MoreBlaze" } game:GetService("ReplicatedStorage"):WaitForChild("__Net"):WaitForChild("MainRemote"):FireServer(unpack(args)) end) task.wait(0.25) end if Env.AutoBlazeMoreFire then pcall(function() local args = { [1] = "UpgradeUpgradeMax", [2] = "Blaze", [3] = "MoreFire" } game:GetService("ReplicatedStorage"):WaitForChild("__Net"):WaitForChild("MainRemote"):FireServer(unpack(args)) end) task.wait(0.25) end if Env.AutoBlazeMoreOof then pcall(function() local args = { [1] = "UpgradeUpgradeMax", [2] = "Blaze", [3] = "MoreOof" } game:GetService("ReplicatedStorage"):WaitForChild("__Net"):WaitForChild("MainRemote"):FireServer(unpack(args)) end) task.wait(0.25) end if Env.AutoBlazeMoreOofs then pcall(function() local args = { [1] = "UpgradeUpgradeMax", [2] = "Blaze", [3] = "MoreOofs" } game:GetService("ReplicatedStorage"):WaitForChild("__Net"):WaitForChild("MainRemote"):FireServer(unpack(args)) end) task.wait(0.25) end if Env.AutoBlazeMoreBulk then pcall(function() local args = { [1] = "UpgradeUpgradeMax", [2] = "Blaze", [3] = "MoreBulk" } game:GetService("ReplicatedStorage"):WaitForChild("__Net"):WaitForChild("MainRemote"):FireServer(unpack(args)) end) task.wait(0.25) end end end end)
task.spawn(function() while Running do task.wait(1.2) if Running then if Env.AutoOpenT1Chest then pcall(function() local args = { [1] = "OpenChest", [2] = "T1TrialChest", [3] = 10 } game:GetService("ReplicatedStorage"):WaitForChild("__Net"):WaitForChild("MainRemote"):FireServer(unpack(args)) end) end if Env.AutoOpenT2Chest then pcall(function() local args = { [1] = "OpenChest", [2] = "T2TrialChest", [3] = 10 } game:GetService("ReplicatedStorage"):WaitForChild("ReplicatedStorage"):WaitForChild("__Net"):WaitForChild("MainRemote"):FireServer(unpack(args)) end) end end end end)
task.spawn(function() while Running do task.wait(5.0) if Env.AutoPrestige and Running then pcall(function() local args = { [1] = "Prestige" } game:GetService("ReplicatedStorage"):WaitForChild("__Net"):WaitForChild("MainRemote"):FireServer(unpack(args)) end) end end end)

task.spawn(function()
    while Running do
        task.wait(60.0)
        if Running and Env.AutoBlazeConvert then
            pcall(function()
                local args = { [1] = "Blaze" }
                game:GetService("ReplicatedStorage"):WaitForChild("__Net"):WaitForChild("MainRemote"):FireServer(unpack(args))
            end)
        end
    end
end)

print("[Dominate Hub] V16.9.31 Stable Loaded Successfully!")
