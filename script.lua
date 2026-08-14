--======================================================================================
-- DOMINATE HUB | PRO EDITION (STABLE V16.9.110 - sdsaM)
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
Env._UIElements = {}

-- FORWARD HELPER FUNCTIONS
local function GetWorldRoot() 
    return player.Character and player.Character:FindFirstChild("HumanoidRootPart") 
end

local function isMobRespawning(mobModel)
    if not mobModel then return true end
    for _, desc in ipairs(mobModel:GetDescendants()) do
        if desc:IsA("TextLabel") and desc.Text and desc.Text:lower():find("respawning") then
            return true
        end
    end
    return false
end

-- ROBUST ORE RESPAWN CHECK (SCANS ALL TEXT LABELS IN THE MODEL)
local function isOreRespawning(oreModel)
    if not oreModel then return true end
    for _, desc in ipairs(oreModel:GetDescendants()) do
        if desc:IsA("TextLabel") and desc.Text and desc.Text:lower():find("respawning") then
            return true
        end
    end
    return false
end

-- DESTINATION VECTORS DECLARED EARLY TO PREVENT NIL-INDEX ERRORS
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
    EasyTrial = Vector3.new(850.21044921875, 11.162318229675293, 13444.673828125),     
    MediumTrial = Vector3.new(879.9605712890625, 11.17810344696045, 13418.396484375), 
    HardTrial = Vector3.new(909.3944702148438, 11.162318229675293, 13441.96875),   
    CastleEntrance = Vector3.new(834.7246, 4.8552, 7622.6528),
    RitualChamber = Vector3.new(837.1246, 3.9983, 7904.0763),
    SandRegenPad = Vector3.new(557.1278076171875, 5.08376932144165, 7820.8671875),
    AncientBossSpawn = Vector3.new(627.4028, 4.8705, 7854.8388),
    PostTrialLanding = Vector3.new(1011.821, 4.8705, 7799.512),
    TrialDropOut = Vector3.new(879.040, 11.531, 13443.085),
    DeepcoreRune = Vector3.new(691.268432, 12.532532, 3161.888916)
}

-- STATS TRACKING VARIABLES FOR HUD & EFFICIENCY TRACKER
local oresMined = 0
local mobsKilled = 0
local sessionStartTime = tick()
local lastTrackedPart = nil
local lastTrackedMobPart = nil
local currentTargetPanel = nil
local currentTargetMob = nil
local gemExchangeCountdown = 60

-- DEEPCORE RUNE COUNTDOWN TIMER VARIABLE
local deepcoreTimer = 300

-- RITUAL HUD TIMER VARIABLES
local ritualTimer = 0
local ritualInCooldown = false

-- RUNTIME STATE LOCKS
local trialIsRunning = false
local trialExiting = false
local ritualIsActive = false
local ritualSuppressMobs = false
local cachedStates = nil

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
Env.TargetSandLayer = 3

-- DEEPCORE RUNE CONFIG
Env.DeepcoreRuneInterval = false

-- REALM 4 CONFIG FLAGS
Env.AutoSpaceMultiStar = false
Env.AutoSpaceMoreSpacePoints = false
Env.AutoSpaceBlackholes = false
Env.AutoSpaceBoostRadius = false

Env.AutoStarsMoreStars = false
Env.AutoStarsEvenMoreStars = false
Env.AutoStarsFasterRespawn = false
Env.AutoStarsMoreSpacePoints = false
Env.AutoStarsOof = false
Env.AutoStarsBoostLuck = false
Env.AutoCollectStars = false

-- TRIAL CONFIG
Env.AutoLeaveByTime = true
Env.TrialTimeLimit = 15
Env.TrialDiagnostics = false

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

-- TOGGLE & UI HELPERS
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

    Env._UIElements[vKey] = {Track = switchTrack, Stroke = trackStroke, Thumb = switchThumb}

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
    row.AutoButtonColor = true
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
local sg = Instance.new("ScreenGui")
sg.Name = "DominateHubMirror"
sg.ResetOnSpawn = false
sg.Parent = parentTarget

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

-- INSERT KEY HOTKEY TO TOGGLE UI VISIBILITY
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.Insert then
        local isVisible = mainFrame.Visible
        mainFrame.Visible = not isVisible
        minBtn.TextColor3 = mainFrame.Visible and Color3.fromRGB(216, 180, 254) or Color3.fromRGB(74, 222, 128)
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

-- PERFORMANCE HUD OVERLAY (TOP LEFT WITH EFFICIENCY TRACKER)
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
            
            if Env.DeepcoreRuneInterval then
                local dcMin = math.floor(deepcoreTimer / 60)
                local dcSec = deepcoreTimer % 60
                table.insert(extraLines, string.format("Deepcore: %02d:%02d", dcMin, dcSec))
            end
            
            local elapsedHours = math.max((tick() - sessionStartTime) / 3600, 0.0001)
            
            local miningActive = false
            for _, oreInfo in ipairs(OrePriorityList) do
                if Env[oreInfo.F] then miningActive = true break end
            end
            if miningActive then
                local oresPerHour = math.floor(oresMined / elapsedHours)
                table.insert(extraLines, string.format("Gem Exch: %ds | Mined: %d (%d/hr)", gemExchangeCountdown, oresMined, oresPerHour))
            end
            
            local mobActive = false
            for _, mobInfo in ipairs(MobPriorityList) do
                if Env[mobInfo.F] then mobActive = true break end
            end
            if mobActive then
                local mobsPerHour = math.floor(mobsKilled / elapsedHours)
                table.insert(extraLines, string.format("Kills: %d (%d/hr)", mobsKilled, mobsPerHour))
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
headerTitle.Text = "Dominate Hub v1.8 (Pro Edition)" 
headerTitle.TextXAlignment = Enum.TextXAlignment.Left 
headerTitle.Parent = mainFrame

local headerSubtitle = Instance.new("TextLabel")
headerSubtitle.Size = UDim2.new(0.5, 0, 0, 16)
headerSubtitle.Position = UDim2.new(0, 56, 0, 28)
headerSubtitle.BackgroundTransparency = 1
headerSubtitle.TextColor3 = Color3.fromRGB(180, 150, 210)
headerSubtitle.TextSize = 11
headerSubtitle.Font = Enum.Font.GothamBold
headerSubtitle.Text = "discord.gg/dominatehub | Press [Insert] to Hide"
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

-- PAGES CREATED FIRST TO FIX SCOPING/VISIBILITY REFERENCE
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

-- UPGRADES PAGE BUILD (FLAT LAYOUT)
local upScroll = makeVerticalScroll(upgradesPage)
upScroll.Visible = true
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
masterToggleGroup("Meat Upgrades", {"AutoDepositMeat", "AutoMeatMoreMeat", "AutoMeatStrongerSwords", "AutoMeatMoreOof", "AutoMeatMoreBones"}, upScroll)
masterToggleGroup("Bones Upgrades", {"AutoBonesMoreBones", "AutoBonesFasterSwords", "AutoBonesBiggerMeatDeposit"}, upScroll)
masterToggleGroup("Souls Upgrades", {"AutoSoulsMoreSouls", "AutoSoulsLuckierSwords", "AutoSoulsMoreOof", "AutoSoulsMoreBones", "AutoSoulsRuneBulk"}, upScroll)

createSectionHeader(upScroll, "Sand Upgrades")
createToggleRow(upScroll, "Auto Sand Upgrades", "AutoSandUpgrades")
createToggleRow(upScroll, "Auto Shovel Level Up", "AutoShovelLevelUp")
createToggleRow(upScroll, "Auto Excavation Rank Up", "AutoExcavationRankUp")
createToggleRow(upScroll, "Auto Regenerate Sand Layers", "AutoRegenSandLayers")
createTextBoxRow(upScroll, "Target Sand Layer (1-250)", "TargetSandLayer")

createSectionHeader(upScroll, "Realm 4 Upgrades & Features")
masterToggleGroup("SpacePoints Upgrades", {"AutoSpaceMultiStar", "AutoSpaceMoreSpacePoints", "AutoSpaceBlackholes", "AutoSpaceBoostRadius"}, upScroll)
masterToggleGroup("Stars Upgrades", {"AutoStarsMoreStars", "AutoStarsEvenMoreStars", "AutoStarsFasterRespawn", "AutoStarsMoreSpacePoints", "AutoStarsOof", "AutoStarsBoostLuck"}, upScroll)
createToggleRow(upScroll, "Auto Collect Stars (ClientStars)", "AutoCollectStars")

-- NOOBS PAGE BUILD
local noobsScroll = makeVerticalScroll(noobsPage)
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

createSectionHeader(noobsScroll, "Realm 3 Noobs")
createToggleRow(noobsScroll, "Auto Upgrade Merchant", "AutoUpgradeMerchantNoob")
createToggleRow(noobsScroll, "Auto Upgrade Mummy", "AutoUpgradeMummyNoob")
createToggleRow(noobsScroll, "Auto Upgrade Pharaoh", "AutoUpgradePharaoh")

-- TRIALS PAGE BUILD
local trialsScroll = makeVerticalScroll(trialsPage)
createSectionHeader(trialsScroll, "Realm 3 Trials Automation (Scheduled :29 / :59)")
createToggleRow(trialsScroll, "Auto Easy Trial", "AutoEasyTrial")
createToggleRow(trialsScroll, "Auto Medium Trial", "AutoMediumTrial")
createToggleRow(trialsScroll, "Auto Hard Trial", "AutoHardTrial")
createToggleRow(trialsScroll, "Auto Leave By Time Limit", "AutoLeaveByTime")
createTextBoxRow(trialsScroll, "Trial Time Limit (min)", "TrialTimeLimit")
createToggleRow(trialsScroll, "Trial Diagnostics Mode", "TrialDiagnostics")

createSectionHeader(trialsScroll, "Manual Testing")
createButtonRow(trialsScroll, "Test Trial Staging Teleport", function()
    local testPad = Dest.HardTrial
    if Env.AutoEasyTrial then testPad = Dest.EasyTrial
    elseif Env.AutoMediumTrial then testPad = Dest.MediumTrial
    elseif Env.AutoHardTrial then testPad = Dest.HardTrial end

    showToast("Trials: Teleporting to trial pad...")
    print("[DominateHub Diag] Manual Staging Teleport Triggered. Pad:", tostring(testPad))
    
    MasterTargetVector = nil
    MiningTargetVector = nil
    MobTargetVector = nil
    RitualTargetVector = nil
    SandTargetVector = nil
    
    local hrp = GetWorldRoot()
    if hrp then
        hrp.Anchored = false
        hrp.CFrame = CFrame.new(testPad)
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        print("[DominateHub Diag] Teleported to trial pad successfully.")
    else
        print("[DominateHub Diag] ERROR: HumanoidRootPart is nil during manual test!")
    end
end)

-- MINES PAGE BUILD
local minesScroll = makeVerticalScroll(minesPage)
createSectionHeader(minesScroll, "Mining Configuration")

-- Deepcore Rune 5-Minute Teleport Toggle
createToggleRow(minesScroll, "Deepcore Rune 5m Teleport", "DeepcoreRuneInterval")

local bestTierActive = false
local bestTierBtn = Instance.new("TextButton")
bestTierBtn.Size = UDim2.new(1, -10, 0, 48)
bestTierBtn.BackgroundColor3 = Color3.fromRGB(35, 20, 55)
bestTierBtn.BackgroundTransparency = 0.5
bestTierBtn.TextColor3 = Color3.fromRGB(240, 235, 250)
bestTierBtn.TextSize = 13
bestTierBtn.Font = Enum.Font.GothamBold
bestTierBtn.Text = "Best Tier Only: DISABLED"
bestTierBtn.Parent = minesScroll

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
speedContainer.Parent = minesScroll

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

-- MOBS PAGE BUILD
local mobsScroll = makeVerticalScroll(mobsPage)
createSectionHeader(mobsScroll, "Realm 3 Mobs (Worst to Best)")
local bestMobTierActive = false
local bestMobTierBtn = Instance.new("TextButton")
bestMobTierBtn.Size = UDim2.new(1, -10, 0, 48)
bestMobTierBtn.BackgroundColor3 = Color3.fromRGB(35, 20, 55)
bestMobTierBtn.BackgroundTransparency = 0.5
bestMobTierBtn.TextColor3 = Color3.fromRGB(240, 235, 250)
bestMobTierBtn.TextSize = 13
bestMobTierBtn.Font = Enum.Font.GothamBold
bestMobTierBtn.Text = "Best Mob Tier Only: DISABLED"
bestMobTierBtn.Parent = mobsScroll

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

createToggleRow(mobsScroll, "Goblin", "AutoMobGoblin")
createToggleRow(mobsScroll, "Skeleton", "AutoMobSkeleton")
createToggleRow(mobsScroll, "Orc", "AutoMobOrc")
createToggleRow(mobsScroll, "Pirate", "AutoMobPirate")
createToggleRow(mobsScroll, "Ninja", "AutoMobNinja")
createToggleRow(mobsScroll, "Warrior", "AutoMobWarrior")
createToggleRow(mobsScroll, "Pirate Captain", "AutoMobPirateCaptain")
createToggleRow(mobsScroll, "Samurai", "AutoMobSamurai")
createToggleRow(mobsScroll, "Pirate Admiral", "AutoMobPirateAdmiral")
createToggleRow(mobsScroll, "Samurai Master", "AutoMobSamuraiMaster")
createToggleRow(mobsScroll, "Dark Knight", "AutoMobDarkKnight")
createToggleRow(mobsScroll, "Dark Commander", "AutoMobDarkCommander")

createSectionHeader(mobsScroll, "Combat Utilities")
createToggleRow(mobsScroll, "Ancient Boss Farm (Supreme Shadow Lord)", "AutoAncientBossFarm")
createToggleRow(mobsScroll, "Combat Safe Spot Break (4s)", "AutoCombatBreak")
createToggleRow(mobsScroll, "Auto Start Ritual (Infinite Multi-Fire Loop)", "AutoStartRitual")
createRitualMobDropdown(mobsScroll, "Ritual Target Mobs", MobPriorityList)

-- FOOTBALL PAGE BUILD
local footballScroll = makeVerticalScroll(footballPage)
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

-- MISC PAGE BUILD
local miscScroll = makeVerticalScroll(miscPage)
createSectionHeader(miscScroll, "Runes")
createToggleRow(miscScroll, "Auto Basic Rune Circle", "AutoRollBasicRune")
createToggleRow(miscScroll, "Auto Super Rune Circle", "AutoRollSuperRune")
createToggleRow(miscScroll, "Auto Advanced Rune", "AutoRollAdvancedRune")
createToggleRow(miscScroll, "Auto Cosmic Prism", "AutoRollCosmicRune")
createToggleRow(miscScroll, "Auto Snowy Rune Circle", "AutoRollSnowyRune")
createToggleRow(miscScroll, "Auto Football Rune", "AutoRollFootballRune")
createToggleRow(miscScroll, "Auto Dunes Rune Circle", "AutoRollDunesRune")
createToggleRow(miscScroll, "Auto Sunfire Rune Circle", "AutoRollSunfireRune")

createSectionHeader(miscScroll, "Capsules")
createToggleRow(miscScroll, "Hatch Classic Capsule", "AutoOpenClassicCapsule")
createToggleRow(miscScroll, "Hatch Football Capsule", "AutoOpenFootballCapsule")
createToggleRow(miscScroll, "Hatch Super Capsule", "AutoOpenSuperCapsule")
createToggleRow(miscScroll, "Hatch Ancient Capsule", "AutoOpenAncientCapsule")

-- SETTINGS PAGE BUILD
local settingsScroll = makeVerticalScroll(settingsPage)

-- ABOUT & LICENSE AT TOP
createSectionHeader(settingsScroll, "About & License")
local aboutFrame = Instance.new("Frame")
aboutFrame.Size = UDim2.new(1, -10, 0, 95)
aboutFrame.BackgroundColor3 = Color3.fromRGB(35, 20, 55)
aboutFrame.BackgroundTransparency = 0.5
aboutFrame.BorderSizePixel = 0
aboutFrame.Parent = settingsScroll

local afCorner = Instance.new("UICorner")
afCorner.CornerRadius = UDim.new(0, 8)
afCorner.Parent = aboutFrame

local aboutLbl = Instance.new("TextLabel")
aboutLbl.Size = UDim2.new(1, -20, 1, 0)
aboutLbl.Position = UDim2.new(0, 10, 0, 0)
aboutLbl.BackgroundTransparency = 1
aboutLbl.TextColor3 = Color3.fromRGB(220, 210, 240)
aboutLbl.TextSize = 11
aboutLbl.Font = Enum.Font.GothamBold
aboutLbl.TextXAlignment = Enum.TextXAlignment.Left
aboutLbl.TextYAlignment = Enum.TextYAlignment.Center
aboutLbl.TextWrapped = true
aboutLbl.Text = "Dominate Hub v1.8 (Pro Edition)\nDiscord: discord.gg/dominatehub\nKey Status: Active / Unlimited\nHotkey: Press [Insert] to Toggle UI"
aboutLbl.Parent = aboutFrame

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
local killRow = Instance.new("Frame") 
killRow.Size = UDim2.new(1, -10, 0, 48) 
killRow.BackgroundColor3 = Color3.fromRGB(35, 20, 55) 
killRow.BackgroundTransparency = 0.5
killRow.BorderSizePixel = 0 
killRow.Parent = settingsScroll

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
    Running = false 
    Env.DominateHubLoaded = nil 
    for k, _ in pairs(Env) do 
        if type(k) == "string" and (k:sub(1,4) == "Auto" or k == "AntiAFK") then 
            Env[k] = false 
        end 
    end
    pcall(function() 
        local cam = workspace.CurrentCamera 
        if cam then cam.CameraType = Enum.CameraType.Custom end 
        local blur = Lighting:FindFirstChild("DominateHubBlur")
        if blur then blur:Destroy() end
    end) 
    sg:Destroy()
end)

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

-- LOCOMOTION & AUTOMATION ENGINES
local MasterTargetVector = nil  
local MiningTargetVector = nil
local MobTargetVector = nil
local TrialTargetVector = nil
local RitualTargetVector = nil
local SandTargetVector = nil
local StarTargetVector = nil

local lastGlidingState = false
RunService.Stepped:Connect(function()
    if not Running then return end
    local char = player.Character
    if char then
        local isGliding = (MasterTargetVector ~= nil or MobTargetVector ~= nil or MiningTargetVector ~= nil or RitualTargetVector ~= nil or SandTargetVector ~= nil or StarTargetVector ~= nil or Env.AutoRollSunfireRune or Env.AutoRollDunesRune or Env.AutoRollFootballRune or Env.AutoRollSnowyRune or Env.AutoRollCosmicRune or Env.AutoRollAdvancedRune or Env.AutoRollSuperRune or Env.AutoRollBasicRune)
        
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

-- UNIFIED SMOOTH GLIDE MOVEMENT LOOP (PREVENTS SPINNING & PHYSICS GLITCHES)
task.spawn(function()
    while Running do
        RunService.RenderStepped:Wait()
        local hrp = GetWorldRoot()
        if hrp and Running and not trialExiting then
            local act = nil
            if RitualTargetVector then act = RitualTargetVector
            elseif MasterTargetVector then act = MasterTargetVector 
            elseif MobTargetVector then act = MobTargetVector
            elseif MiningTargetVector then act = MiningTargetVector
            elseif SandTargetVector then act = SandTargetVector
            elseif StarTargetVector then act = StarTargetVector
            elseif Env.AutoRollSunfireRune then act = Dest.Sunfire
            elseif Env.AutoRollDunesRune then act = Dest.Dunes
            elseif Env.AutoRollFootballRune then act = Dest.Football 
            elseif Env.AutoRollSnowyRune then act = Dest.Snowy
            elseif Env.AutoRollCosmicRune then act = Dest.Cosmic 
            elseif Env.AutoRollAdvancedRune then act = Dest.Advanced
            elseif Env.AutoRollSuperRune then act = Dest.Super 
            elseif Env.AutoRollBasicRune then act = Dest.Basic end
            
            if act then
                local targetCF = CFrame.new(act)
                if trialIsRunning or MobTargetVector then
                    hrp.Anchored = false
                    hrp.CFrame = targetCF
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                elseif StarTargetVector then
                    -- ANTI-CHEAT SAFE CONSTANT-SPEED GLIDE FOR STARS
                    local currentPos = hrp.Position
                    local targetPos = StarTargetVector
                    local distance = (currentPos - targetPos).Magnitude
                    
                    if distance > 1.5 then
                        hrp.Anchored = false
                        local speed = 55 
                        local step = math.min(1.0, (speed * 0.016) / distance)
                        local newPos = currentPos:Lerp(targetPos, step)
                        
                        hrp.CFrame = CFrame.new(newPos, targetPos)
                        hrp.AssemblyLinearVelocity = Vector3.zero
                    else
                        hrp.CFrame = CFrame.new(targetPos)
                        hrp.AssemblyLinearVelocity = Vector3.zero
                    end
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

-- OPTIMIZED & SMARTER STAR COLLECTION LOOP
local starCooldowns = {}
task.spawn(function()
    while Running do
        task.wait(0.1) -- Fast and responsive polling for new spawns
        if Running and Env.AutoCollectStars and not trialIsRunning and not trialExiting and not ritualIsActive then
            pcall(function()
                local clientStars = workspace:FindFirstChild("ClientStars")
                if clientStars then
                    local hrp = GetWorldRoot()
                    if not hrp then return end
                    
                    local now = tick()
                    local availableStars = {}
                    
                    -- Clean expired cooldowns
                    for starModel, expiry in pairs(starCooldowns) do
                        if now >= expiry or not starModel.Parent then
                            starCooldowns[starModel] = nil
                        end
                    end
                    
                    -- Gather all valid, un-cooldown-locked stars into a table
                    for _, starModel in ipairs(clientStars:GetChildren()) do
                        if not starCooldowns[starModel] then
                            local hitbox = starModel:FindFirstChild("Hitbox") or starModel:FindFirstChild("StarPart") or starModel:FindFirstChildWhichIsA("BasePart")
                            if hitbox then
                                local dist = (hitbox.Position - hrp.Position).Magnitude
                                table.insert(availableStars, {Model = starModel, Part = hitbox, Dist = dist})
                            end
                        end
                    end
                    
                    -- Sort available stars by closest distance to the player
                    if #availableStars > 0 then
                        table.sort(availableStars, function(a, b)
                            return a.Dist < b.Dist
                        end)
                        
                        -- Target the absolute closest star
                        local closest = availableStars[1]
                        StarTargetVector = closest.Part.Position
                        
                        -- Apply a short cooldown if we are right on top of it to prevent stuttering
                        if closest.Dist < 3.5 then
                            starCooldowns[closest.Model] = now + 2.0
                        end
                    else
                        StarTargetVector = nil
                    end
                else
                    StarTargetVector = nil
                end
            end)
        else
            StarTargetVector = nil
        end
    end
end)
                    
                    if foundStarPart then
                        StarTargetVector = foundStarPart.Position
                    else
                        StarTargetVector = nil
                    end
                else
                    StarTargetVector = nil
                end
            end)
        else
            StarTargetVector = nil
        end
    end
end)

-- FIXED TICK-BASED DEEPCORE RUNE 5-MINUTE AUTO-TELEPORT ROUTINE
task.spawn(function()
    print("[DominateHub] Deepcore Rune loop initialized.")
    local nextTeleportTick = tick() + 300
    
    while Running do
        task.wait(1.0)
        local isEnabled = Env.DeepcoreRuneInterval
        
        if isEnabled then
            if trialIsRunning or trialExiting or ritualIsActive then
                nextTeleportTick = tick() + 300
                deepcoreTimer = 300
            else
                local remaining = nextTeleportTick - tick()
                deepcoreTimer = math.max(0, math.ceil(remaining))
                
                if remaining <= 0 then
                    nextTeleportTick = tick() + 300
                    deepcoreTimer = 300
                    
                    pcall(function()
                        local char = player.Character
                        local hrp = char and char:FindFirstChild("HumanoidRootPart")
                        
                        if hrp then
                            print("[DominateHub] Pausing auto-mining for Deepcore Rune teleport...")
                            showToast("Deepcore Rune: Pausing to teleport...")
                            
                            local activeOres = {}
                            for _, oreInfo in ipairs(OrePriorityList) do
                                if Env[oreInfo.F] then
                                    activeOres[oreInfo.F] = true
                                    Env[oreInfo.F] = false
                                end
                            end
                            
                            MiningTargetVector = nil
                            hrp.Anchored = false
                            hrp.CFrame = CFrame.new(Dest.DeepcoreRune)
                            hrp.AssemblyLinearVelocity = Vector3.zero
                            hrp.AssemblyAngularVelocity = Vector3.zero
                            
                            showToast("Deepcore Rune: Waiting 5s...")
                            task.wait(5.0)
                            
                            for flagName, _ in pairs(activeOres) do
                                Env[flagName] = true
                            end
                            print("[DominateHub] Resuming auto-mining.")
                            showToast("Deepcore Rune: Resumed auto-mining!")
                        end
                    end)
                end
            end
        else
            nextTeleportTick = tick() + 300
            deepcoreTimer = 300
        end
    end
end)

-- ANCIENT BOSS SPAWN & AUTO-NAVIGATE LOOP
task.spawn(function()
    while Running do
        task.wait(2.0)
        if Running and Env.AutoAncientBossFarm and not trialIsRunning and not trialExiting and not ritualIsActive then
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
                    
                    local args = {
                        [1] = "SpawnAncientMob",
                        [2] = "Supreme Shadow Lord"
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("__Net"):WaitForChild("MainRemote"):FireServer(unpack(args))
                    task.wait(1.5)
                    MasterTargetVector = nil
                    task.wait(3.0)
                end
            end)
        end
    end
end)

-- RITUAL LOOP
task.spawn(function()
    while Running do
        task.wait(1.0)
        if Running and Env.AutoStartRitual and not trialIsRunning and not trialExiting then
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
                if not Running or not Env.AutoStartRitual or trialIsRunning or trialExiting then break end
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
            
            while ritualTimer > 0 and Running and Env.AutoStartRitual and not trialIsRunning and not trialExiting do
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

-- DYNAMIC ENV SNAPSHOT & SAFETY RELEASE FUNCTIONS
local function cacheAndPauseToggles()
    if cachedStates then return end
    cachedStates = {}
    for k, v in pairs(Env) do
        if type(k) == "string" and k:sub(1, 4) == "Auto" then
            if k ~= "AutoEasyTrial" and k ~= "AutoMediumTrial" and k ~= "AutoHardTrial" and k ~= "AutoLeaveByTime" and k ~= "TrialDiagnostics" then
                if v == true then
                    cachedStates[k] = true
                    Env[k] = false
                end
            end
        end
    end
    if Env.TrialDiagnostics then print("[DominateHub Diag] Snapshot saved. Background toggles paused.") end
    showToast("Trials: Dynamic snapshot saved. Background automation paused.")
end

local function restoreToggles()
    if not cachedStates then return end
    if Env.TrialDiagnostics then print("[DominateHub Diag] Restoring background toggles...") end
    showToast("Trials: Restoring background automation toggles...")
    
    for flagName, state in pairs(cachedStates) do
        Env[flagName] = state
        if Env._UIElements and Env._UIElements[flagName] then
            local ui = Env._UIElements[flagName]
            local active = state
            pcall(function()
                TweenService:Create(ui.Track, TweenInfo.new(0.2), {BackgroundColor3 = active and Color3.fromRGB(168, 85, 247) or Color3.fromRGB(42, 28, 65)}):Play()
                TweenService:Create(ui.Stroke, TweenInfo.new(0.2), {Transparency = active and 0.2 or 0.7}):Play()
                TweenService:Create(ui.Thumb, TweenInfo.new(0.2), {Position = active and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)}):Play()
            end)
        end
    end
    
    cachedStates = nil
    trialIsRunning = false
    trialExiting = false
    
    currentTargetPanel = nil
    currentTargetMob = nil
    MiningTargetVector = nil
    MobTargetVector = nil
    StarTargetVector = nil
end

-- STRICT STEP-BY-STEP TRIAL AUTOMATION SEQUENCE
local lastTrialTriggeredSlot = ""
local trialExitCooldown = 0

task.spawn(function()
    while Running do
        task.wait(0.2)
        local hrp = GetWorldRoot()
        local inLobby = hrp and (hrp.Position - Dest.TrialDropOut).Magnitude > 50 or true
        
        local trialEnabled = (Env.AutoEasyTrial or Env.AutoMediumTrial or Env.AutoHardTrial)
        
        if Running and trialEnabled and not ritualIsActive and not trialIsRunning and not trialExiting and inLobby and (tick() - trialExitCooldown > 5) then
            local timeTable = os.date("*t")
            local min = timeTable.min
            local sec = timeTable.sec
            local hour = timeTable.hour
            
            local isTriggerTime = ((min == 28 or min == 58) and sec >= 50) or (min == 29 or min == 59)
            
            if isTriggerTime then
                local currentSlot = hour .. "_" .. min
                if currentSlot ~= lastTrialTriggeredSlot then
                    lastTrialTriggeredSlot = currentSlot
                    
                    if Env.TrialDiagnostics then print("[DominateHub Diag] Step 1: Pre-pause, Ritual Kill & Staging hit at " .. min .. ":" .. sec) end
                    showToast("Trials: Stopping rituals & preparing for trial...")
                    
                    cacheAndPauseToggles()
                    
                    Env.AutoStartRitual = false
                    ritualIsActive = false
                    ritualSuppressMobs = false
                    RitualTargetVector = nil
                    
                    MasterTargetVector = nil
                    MiningTargetVector = nil
                    MobTargetVector = nil
                    RitualTargetVector = nil
                    SandTargetVector = nil
                    StarTargetVector = nil
                    
                    task.wait(1.0)
                    
                    trialIsRunning = true
                    
                    local targetPad = Dest.HardTrial
                    if Env.AutoEasyTrial then targetPad = Dest.EasyTrial
                    elseif Env.AutoMediumTrial then targetPad = Dest.MediumTrial
                    elseif Env.AutoHardTrial then targetPad = Dest.HardTrial end
                    
                    local hrpStaging = GetWorldRoot()
                    if hrpStaging then
                        hrpStaging.Anchored = false
                        hrpStaging.CFrame = CFrame.new(targetPad)
                        hrpStaging.AssemblyLinearVelocity = Vector3.zero
                        hrpStaging.AssemblyAngularVelocity = Vector3.zero
                    end
                    
                    local entryWaitStart = tick()
                    local enteredArena = false
                    while Running and trialIsRunning and not trialExiting and (tick() - entryWaitStart < 45) do
                        task.wait(0.5)
                        local checkHrp = GetWorldRoot()
                        if checkHrp and checkHrp.Position.Z > 13000 then
                            enteredArena = true
                            break
                        end
                    end
                    
                    if enteredArena then
                        showToast("Trials: Entered arena! Timer started.")
                        local trialStartTick = tick()
                        local limitMins = tonumber(Env.TrialTimeLimit) or 15
                        local limitSecs = limitMins * 60
                        
                        while Running and trialIsRunning and not trialExiting do
                            task.wait(1.0)
                            local checkHrp = GetWorldRoot()
                            
                            if (tick() - trialStartTick) >= limitSecs then
                                showToast("Trials: Time limit reached (" .. limitMins .. "m). Leaving trial...")
                                trialExitCooldown = tick()
                                trialExiting = true
                                trialIsRunning = false
                                MobTargetVector = nil
                                currentTargetMob = nil
                                lastTrackedMobPart = nil
                                
                                task.wait(2.0)
                                pcall(function()
                                    local args = { [1] = "LeaveTrial" }
                                    game:GetService("ReplicatedStorage"):WaitForChild("__Net"):WaitForChild("MainRemote"):FireServer(unpack(args))
                                end)
                                break
                            end
                            
                            if checkHrp and checkHrp.Position.Z < 13000 then
                                break
                            end
                        end
                    else
                        showToast("Trials: Entry timeout. Resetting state.")
                    end
                    
                    showToast("Trials: Exited trial. Relocating to farm spot...")
                    task.wait(1.5)
                    
                    local hrpDrop = GetWorldRoot()
                    if hrpDrop then
                        hrpDrop.Anchored = false
                        hrpDrop.CFrame = CFrame.new(Dest.PostTrialLanding)
                        hrpDrop.AssemblyLinearVelocity = Vector3.zero
                        hrpDrop.AssemblyAngularVelocity = Vector3.zero
                    end
                    
                    trialIsRunning = false
                    MobTargetVector = nil
                    currentTargetMob = nil
                    lastTrackedMobPart = nil
                    trialExitCooldown = tick()
                    
                    task.wait(0.5)
                    restoreToggles()
                end
            end
        end
    end
end)

-- COMBAT SAFE SPOT BREAK
task.spawn(function()
    while Running do
        task.wait(40.0)
        if Running and Env.AutoCombatBreak and not trialIsRunning and not trialExiting and not ritualIsActive then
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
                
                task.wait(3.5)
                for flag, state in pairs(activeMobStates) do
                    Env[flag] = state
                end
            end
        end
    end
end)

-- STABILIZED MOB FARMING ENGINE
task.spawn(function()
    while Running do
        task.wait(0.01)
        if Running and not trialExiting and not ritualIsActive and not ritualSuppressMobs and RitualTargetVector == nil and SandTargetVector == nil and StarTargetVector == nil then
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
                local currentValid = false
                if currentTargetMob and currentTargetMob.Parent then
                    local mobModel = currentTargetMob.Parent
                    if mobModel:IsA("Model") and not isMobRespawning(mobModel) then
                        local isDead = false
                        for _, desc in ipairs(mobModel:GetDescendants()) do
                            if desc:IsA("TextLabel") and desc.Text then
                                local txt = desc.Text:gsub(",", "")
                                if txt:find("^0%s*/") or txt == "0" then
                                    isDead = true
                                    break
                                end
                            end
                        end
                        if not isDead then
                            currentValid = true
                            foundMobPart = currentTargetMob
                        end
                    end
                end

                if not currentValid then
                    if trialIsRunning then
                        local gc = workspace:FindFirstChild("__GAME_CONTENT")
                        local trialsFolder = gc and gc:FindFirstChild("Trials")
                        if trialsFolder then
                            local shortestDist = math.huge
                            local hrp = GetWorldRoot()
                            for _, roomObj in ipairs(trialsFolder:GetChildren()) do
                                local mFolder = roomObj:FindFirstChild("Mobs")
                                if mFolder then
                                    for _, mobObj in ipairs(mFolder:GetChildren()) do
                                        if mobObj:IsA("Model") and not isMobRespawning(mobObj) then
                                            local hum = mobObj:FindFirstChildOfClass("Humanoid")
                                            local part = mobObj.PrimaryPart or mobObj:FindFirstChildWhichIsA("BasePart")
                                            if part and (not hum or hum.Health > 0) then
                                                local isActuallyDead = false
                                                for _, desc in ipairs(mobObj:GetDescendants()) do
                                                    if desc:IsA("TextLabel") and desc.Text then
                                                        local txt = desc.Text:gsub(",", "")
                                                        if txt:find("^0%s*/") or txt == "0" then
                                                            isActuallyDead = true
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
                                            if part then
                                                local isDead = false
                                                for _, desc in ipairs(mobObj:GetDescendants()) do
                                                    if desc:IsA("TextLabel") and desc.Text then
                                                        local txt = desc.Text:gsub(",", "")
                                                        if txt:find("^0%s*/") or txt == "0" then
                                                            isActuallyDead = true
                                                            break
                                                        end
                                                    end
                                                end
                                                if not isDead then
                                                    foundMobPart = part
                                                    break
                                                end
                                            end
                                        end
                                    end
                                end
                                if foundMobPart then break end
                            end
                        end
                    end
                end
                
                currentTargetMob = foundMobPart
                if currentTargetMob then
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
            end
        end
    end
end)

-- SAND REGENERATION LOOP
task.spawn(function()
    while Running do
        task.wait(1.0)
        if Running and Env.AutoRegenSandLayers and not trialIsRunning and not trialExiting and not ritualIsActive then
            showToast("Sand Regen: Teleporting to pit...")
            pcall(function()
                local hrp = GetWorldRoot()
                if hrp then
                    hrp.Anchored = false
                    hrp.CFrame = CFrame.new(Dest.SandPit)
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                end
            end)
            task.wait(1.0)
            
            local reachedTarget = false
            local targetLayer = tonumber(Env.TargetSandLayer) or 3
            
            while Running and Env.AutoRegenSandLayers and not trialIsRunning and not trialExiting and not ritualIsActive and not reachedTarget do
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
                            local depth = math.abs(hrp.Position.Y - Dest.SandPit.Y)
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
local oreLockStartTime = 0
local oreCooldowns = {}

task.spawn(function()
    while Running do
        task.wait(Env.CPUSaverMode and 0.25 or 0.1)
        if Running and not trialIsRunning and not trialExiting and not ritualIsActive then
            local enabledOreNames = {} 
            local hasAnyEnabled = false
            for i = 1, #OrePriorityList do 
                if Env[OrePriorityList[i].F] then 
                    enabledOreNames[OrePriorityList[i].N] = true 
                    hasAnyEnabled = true 
                end 
            end

            if hasAnyEnabled then
                local hrp = GetWorldRoot()
                local now = tick()
                local dwellTime = Env.MiningJumpSpeed or 0.8
                local keepCurrent = false
                
                if currentTargetPanel and currentTargetPanel.Parent and currentTargetPanel:IsDescendantOf(workspace) then
                    if not isOreRespawning(currentTargetPanel.Parent) then
                        if (now - oreLockStartTime) < dwellTime then
                            keepCurrent = true
                        end
                    end
                end
                
                if not keepCurrent then
                    if currentTargetPanel and currentTargetPanel.Parent then
                        oreCooldowns[currentTargetPanel.Parent] = now + 4.0
                    end
                    
                    for oreModel, expiry in pairs(oreCooldowns) do
                        if now >= expiry or not oreModel.Parent then
                            oreCooldowns[oreModel] = nil
                        end
                    end
                    
                    local freshList = {} 
                    local gc = workspace:FindFirstChild("__GAME_CONTENT") 
                    local oresFolder = gc and gc:FindFirstChild("Ores")
                    
                    if oresFolder and hrp then
                        for _, obj in ipairs(oresFolder:GetChildren()) do
                            if enabledOreNames[obj.Name] and obj:IsA("Model") and not isOreRespawning(obj) and not oreCooldowns[obj] then
                                local part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                                if part then 
                                    table.insert(freshList, {Part = part, Dist = (part.Position - hrp.Position).Magnitude}) 
                                end
                            end
                        end
                    end
                    
                    if #freshList > 0 then
                        table.sort(freshList, function(a, b) return a.Dist < b.Dist end)
                        
                        currentOreIndex = currentOreIndex + 1 
                        if currentOreIndex > #freshList then currentOreIndex = 1 end
                        
                        currentTargetPanel = freshList[currentOreIndex].Part
                        oreLockStartTime = now
                        
                        if currentTargetPanel and currentTargetPanel ~= lastTrackedPart then
                            lastTrackedPart = currentTargetPanel
                            oresMined = oresMined + 1
                        end
                    else 
                        oreCooldowns = {}
                        currentTargetPanel = nil
                    end
                end
                
                if currentTargetPanel and currentTargetPanel.Parent then 
                    local orePos = currentTargetPanel.Position
                    if hrp then
                        local dir = (hrp.Position - orePos)
                        dir = Vector3.new(dir.X, 0, dir.Z)
                        if dir.Magnitude > 0.1 then
                            MiningTargetVector = orePos
                        else
                            MiningTargetVector = Vector3.new(orePos.X, hrp.Position.Y, orePos.Z)
                        end
                    else
                        MiningTargetVector = orePos
                    end
                else 
                    MiningTargetVector = nil 
                end
            else 
                currentTargetPanel = nil 
                MiningTargetVector = nil 
                oresMined = 0
                lastTrackedPart = nil
            end
        end
    end
end)

-- CAPSULE LOOP
task.spawn(function()
    while Running do
        task.wait(Env.CPUSaverMode and 0.25 or 0.12)
        if Running then
            local hrp = GetWorldRoot()
            if hrp then
                if Env.AutoOpenClassicCapsule then 
                    if (hrp.Position - Dest.ClassicCap).Magnitude > 10 then hrp.CFrame = CFrame.new(Dest.ClassicCap) end 
                    pcall(function() 
                        local args = { [1] = "ToggleMinionAutoOpen", [2] = "Classic" } 
                        game:GetService("ReplicatedStorage"):WaitForChild("__Net"):WaitForChild("MainRemote"):FireServer(unpack(args)) 
                    end)
                elseif Env.AutoOpenFootballCapsule then 
                    if (hrp.Position - Dest.FootballCap).Magnitude > 10 then hrp.CFrame = CFrame.new(Dest.FootballCap) end 
                    pcall(function() 
                        local args = { [1] = "ToggleMinionAutoOpen", [2] = "Football" } 
                        game:GetService("ReplicatedStorage"):WaitForChild("__Net"):WaitForChild("MainRemote"):FireServer(unpack(args)) 
                    end)
                elseif Env.AutoOpenSuperCapsule then 
                    if (hrp.Position - Dest.SuperCap).Magnitude > 10 then hrp.CFrame = CFrame.new(Dest.SuperCap) end 
                    pcall(function() 
                        local args = { [1] = "ToggleMinionAutoOpen", [2] = "Super" } 
                        game:GetService("ReplicatedStorage"):WaitForChild("__Net"):WaitForChild("MainRemote"):FireServer(unpack(args)) 
                    end)
                elseif Env.AutoOpenAncientCapsule then 
                    if (hrp.Position - Dest.AncientCap).Magnitude > 10 then hrp.CFrame = CFrame.new(Dest.AncientCap) end 
                    pcall(function() 
                        local args = { [1] = "ToggleMinionAutoOpen", [2] = "Ancient" } 
                        game:GetService("ReplicatedStorage"):WaitForChild("__Net"):WaitForChild("MainRemote"):FireServer(unpack(args)) 
                    end) 
                end
            end
        end
    end
end)

task.spawn(function()
    while Running do
        task.wait(0.5)
        if Env.AutoFarmCash and Running and not trialIsRunning and not trialExiting and not ritualIsActive then
            local gc = workspace:FindFirstChild("__GAME_CONTENT") 
            local ty = gc and gc:FindFirstChild("Tycoon") 
            local btnF = ty and ty:FindFirstChild("Buttons")
            if btnF and Running then
                local locked = {} 
                repeat
                    if not Running or not Env.AutoFarmCash or trialIsRunning or trialExiting or ritualIsActive then break end
                    local vis = btnF:GetChildren() 
                    local att = false
                    for i = 1, #vis do
                        if not Running or not Env.AutoFarmCash then break end
                        local bM = vis[i]
                        if bM and bM:IsA("Model") and not locked[bM.Name] then
                            local tb = bM:FindFirstChild("BuyingButtonPart", true)
                            if tb and tb:IsA("BasePart") and Running then
                                att = true 
                                MasterTargetVector = tb.Position 
                                task.wait(0.4)
                                if not Running then break end
                                if bM:IsDescendantOf(btnF) then 
                                    locked[bM.Name] = true 
                                    MasterTargetVector = nil 
                                    task.wait(0.05) 
                                else 
                                    MasterTargetVector = nil 
                                    task.wait(0.1) 
                                    break 
                                end
                            end
                        end
                    end
                    if not att or not Env.AutoFarmCash or not Running then break end 
                    task.wait(0.1)
                until false
                if Running then 
                    MasterTargetVector = nil 
                    local sE = tick() + math.random(120, 180) 
                    repeat task.wait(1) until tick() >= sE or not Env.AutoFarmCash or not Running 
                end
            else 
                MasterTargetVector = nil 
                task.wait(2) 
            end
        else 
            MasterTargetVector = nil 
            task.wait(1) 
        end
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
    {F="AutoExcavationRankUp",T="ExcavationRankUp",A={}},
    {F="AutoSpaceMultiStar",T="UpgradeUpgradeMax",A={"SpacePoints","MultiStar"}},
    {F="AutoSpaceMoreSpacePoints",T="UpgradeUpgradeMax",A={"SpacePoints","MoreSpacePoints"}},
    {F="AutoSpaceBlackholes",T="UpgradeUpgradeMax",A={"SpacePoints","Blackholes"}},
    {F="AutoSpaceBoostRadius",T="UpgradeUpgradeMax",A={"SpacePoints","BoostStarsCollectRadius"}},
    {F="AutoStarsMoreStars",T="UpgradeUpgradeMax",A={"Stars","MoreStars"}},
    {F="AutoStarsEvenMoreStars",T="UpgradeUpgradeMax",A={"Stars","EvenMoreStars"}},
    {F="AutoStarsFasterRespawn",T="UpgradeUpgradeMax",A={"Stars","FasterRespawn"}},
    {F="AutoStarsMoreSpacePoints",T="UpgradeUpgradeMax",A={"Stars","MoreSpacePoints"}},
    {F="AutoStarsOof",T="UpgradeUpgradeMax",A={"Stars","Oof"}},
    {F="AutoStarsBoostLuck",T="UpgradeUpgradeMax",A={"Stars","BoostStarsMutationLuck"}}
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

task.spawn(function() 
    while Running do 
        task.wait(0.5) 
        if Running then 
            for i = 1, 11 do 
                if Env["AutoFillBucket" .. i] then 
                    pcall(function() 
                        local args = { [1] = "FillWaterBucket", [2] = i } 
                        game:GetService("ReplicatedStorage"):WaitForChild("__Net"):WaitForChild("MainRemote"):FireServer(unpack(args)) 
                    end) 
                    task.wait(0.2) 
                end 
            end 
        end 
    end 
end)

task.spawn(function() 
    while Running do 
        task.wait(0.2) 
        if Running and Env.AutoScoreGoal then 
            pcall(function() 
                local args = { [1] = "RegisterFootballKick" } 
                game:GetService("ReplicatedStorage"):WaitForChild("__Net"):WaitForChild("MainRemote"):FireServer(unpack(args)) 
            end) 
            task.wait(1.5) 
            if not Running or not Env.AutoScoreGoal then break end 
            pcall(function() 
                local args = { [1] = "ScoreGoal" } 
                game:GetService("ReplicatedStorage"):WaitForChild("__Net"):WaitForChild("MainRemote"):FireServer(unpack(args)) 
            end) 
            task.wait(1.5) 
        end 
    end 
end)

task.spawn(function()
    while Running do
        if Running and Env.AutoFootballTree then
            local pGui = player:FindFirstChild("PlayerGui") 
            local treeGui = pGui and pGui:FindFirstChild("FootballUITree")
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

task.spawn(function() 
    while Running do 
        task.wait(3.0) 
        if Running and Env.AutoClaimTrophies then 
            for i = 1, 10 do 
                if not Running or not Env.AutoClaimTrophies then break end 
                pcall(function() 
                    local args = { [1] = "BuyTrophy", [2] = i } 
                    game:GetService("ReplicatedStorage"):WaitForChild("__Net"):WaitForChild("MainRemote"):FireServer(unpack(args)) 
                end) 
                task.wait(0.2) 
            end 
        end 
    end 
end)

local BreadUpgradeList = { 
    {F="AutoBreadMoreWheat",T="UpgradeUpgradeMax",A={"Bread","MoreWheat"}}, 
    {F="AutoBreadMoreBread",T="UpgradeUpgradeMax",A={"Bread","MoreBread"}}, 
    {F="AutoBreadMoreBread2",T="UpgradeUpgradeMax",A={"Bread","MoreBread2"}}, 
    {F="AutoBreadBiggerWheatDeposit",T="UpgradeUpgradeMax",A={"Bread","BiggerWheatDeposit"}}, 
    {F="AutoBreadFasterWheatConversion",T="UpgradeUpgradeMax",A={"Bread","FasterWheatConversion"}}, 
    {F="AutoBreadMoreConsumption",T="UpgradeUpgradeMax",A={"Bread","MoreConsumption"}}, 
    {F="AutoBreadMoreRuneLuck",T="UpgradeUpgradeMax",A={"Bread","MoreRuneLuck"}}, 
    {F="AutoBreadMoreTierLuck",T="UpgradeUpgradeMax",A={"Bread","MoreTierLuck"}}, 
    {F="AutoUpgradeCow",T="UpgradeAnimal",A={"Cow"}}, 
    {F="AutoUpgradeChicken",T="UpgradeAnimal",A={"Chicken"}}, 
    {F="AutoBuyCow",T="BuyAnimal",A={"Cow",true}}, 
    {F="AutoBuyChicken",T="BuyAnimal",A={"Chicken",true}} 
}

task.spawn(function() 
    local bIdx = 1 
    while Running do 
        task.wait(1.2) 
        if Running then 
            local att = 0 
            repeat 
                local cur = BreadUpgradeList[bIdx] 
                bIdx = (bIdx % #BreadUpgradeList) + 1 
                att = att + 1 
                if Env[cur.F] then 
                    pcall(function() 
                        local args = { [1] = cur.T, [2] = cur.A[1], [3] = cur.A[2] } 
                        game:GetService("ReplicatedStorage"):WaitForChild("__Net"):WaitForChild("MainRemote"):FireServer(unpack(args)) 
                    end) 
                    break 
                end 
            until att >= #BreadUpgradeList 
        end 
    end 
end)

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
            if Env.AutoDepositWheat then 
                pcall(function() 
                    local args = { [1] = "DepositWheat" } 
                    game:GetService("ReplicatedStorage"):WaitForChild("__Net"):WaitForChild("MainRemote"):FireServer(unpack(args)) 
                end) 
            end 
            if Env.AutoDepositWood then 
                pcall(function() 
                    local args = { [1] = "DepositWood" } 
                    game:GetService("ReplicatedStorage"):WaitForChild("__Net"):WaitForChild("MainRemote"):FireServer(unpack(args)) 
                end) 
            end 
        end 
    end 
end)

task.spawn(function() 
    while Running do 
        task.wait(1.0) 
        if Running then 
            if Env.AutoBlazeMoreBlaze then 
                pcall(function() 
                    local args = { [1] = "UpgradeUpgradeMax", [2] = "Blaze", [3] = "MoreBlaze" } 
                    game:GetService("ReplicatedStorage"):WaitForChild("__Net"):WaitForChild("MainRemote"):FireServer(unpack(args)) 
                end) 
                task.wait(0.25) 
            end 
            if Env.AutoBlazeMoreFire then 
                pcall(function() 
                    local args = { [1] = "UpgradeUpgradeMax", [2] = "Blaze", [3] = "MoreFire" } 
                    game:GetService("ReplicatedStorage"):WaitForChild("__Net"):WaitForChild("MainRemote"):FireServer(unpack(args)) 
                end) 
                task.wait(0.25) 
            end 
            if Env.AutoBlazeMoreOof then 
                pcall(function() 
                    local args = { [1] = "UpgradeUpgradeMax", [2] = "Blaze", [3] = "MoreOof" } 
                    game:GetService("ReplicatedStorage"):WaitForChild("__Net"):WaitForChild("MainRemote"):FireServer(unpack(args)) 
                end) 
                task.wait(0.25) 
            end 
            if Env.AutoBlazeMoreOofs then 
                pcall(function() 
                    local args = { [1] = "UpgradeUpgradeMax", [2] = "Blaze", [3] = "MoreOofs" } 
                    game:GetService("ReplicatedStorage"):WaitForChild("__Net"):WaitForChild("MainRemote"):FireServer(unpack(args)) 
                end) 
                task.wait(0.25) 
            end 
            if Env.AutoBlazeMoreBulk then 
                pcall(function() 
                    local args = { [1] = "UpgradeUpgradeMax", [2] = "Blaze", [3] = "MoreBulk" } 
                    game:GetService("ReplicatedStorage"):WaitForChild("__Net"):WaitForChild("MainRemote"):FireServer(unpack(args)) 
                end) 
                task.wait(0.25) 
            end 
        end 
    end 
end)

-- CHEST OPENING LOOP (100 CHESTS)
task.spawn(function() 
    while Running do 
        task.wait(1.2) 
        if Running then 
            if Env.AutoOpenT1Chest then 
                pcall(function() 
                    local args = { [1] = "OpenChest", [2] = "T1TrialChest", [3] = 100 } 
                    game:GetService("ReplicatedStorage"):WaitForChild("__Net"):WaitForChild("MainRemote"):FireServer(unpack(args)) 
                end) 
            end 
            if Env.AutoOpenT2Chest then 
                pcall(function() 
                    local args = { [1] = "OpenChest", [2] = "T2TrialChest", [3] = 100 } 
                    game:GetService("ReplicatedStorage"):WaitForChild("__Net"):WaitForChild("MainRemote"):FireServer(unpack(args)) 
                end) 
            end 
        end 
    end 
end)

task.spawn(function() 
    while Running do 
        task.wait(5.0) 
        if Env.AutoPrestige and Running then 
            pcall(function() 
                local args = { [1] = "Prestige" } 
                game:GetService("ReplicatedStorage"):WaitForChild("__Net"):WaitForChild("MainRemote"):FireServer(unpack(args)) 
            end) 
        end 
    end 
end)

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

print("[Dominate Hub] V16.9.110 Stable Loaded Successfully with Safe Anti-Cheat Star Glide!")
