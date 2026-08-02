--======================================================================================
-- DOMINATE HUB | V7.1 PRO EDITION (CARD-BASED MODULES & LIVE STATUS BADGES)
--======================================================================================
if getgenv().DominateHubLoaded then 
    pcall(function()
        local parentTarget = (gethui and gethui()) or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
        local oldUI = parentTarget:FindFirstChild("DominateHubMirror")
        if oldUI then oldUI:Destroy() end
        local oldBlur = Lighting:FindFirstChild("DominateHubBlur")
        if oldBlur then oldBlur:Destroy() end
    end)
    print("[Dominate Hub] Reloading V7.1 Instance...")
end
getgenv().DominateHubLoaded = true

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

-- ADD FROSTED BLUR EFFECT TO LIGHTING
pcall(function()
    local blur = Instance.new("BlurEffect")
    blur.Name = "DominateHubBlur"
    blur.Size = 6
    blur.Parent = Lighting
end)

-- MULTI-SLOT CONFIG SYSTEM
_G.SelectedConfigSlot = 1
local slotCustomNames = {[1] = "Slot 1", [2] = "Slot 2", [3] = "Slot 3", [4] = "Slot 4", [5] = "Slot 5"}

local function getSlotFileName(slot)
    return "DominateHub_Config_Slot" .. slot .. ".json"
end

local function saveConfigToSlot(slot)
    local configData = {}
    for k, v in pairs(_G) do
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

local function loadConfigFromSlot(slot)
    pcall(function()
        local fileName = getSlotFileName(slot)
        if readfile and isfile and isfile(fileName) then
            local data = HttpService:JSONDecode(readfile(fileName))
            for k, v in pairs(data) do
                _G[k] = v
            end
        end
    end)
end
loadConfigFromSlot(1)

_G.AntiAFK, _G.AutoPrestige = true, false
_G.AutoUpgradeStarter, _G.AutoUpgradeCooker, _G.AutoUpgradeFarmer, _G.AutoUpgradeMagician, _G.AutoUpgradeArcher, _G.AutoUpgradeSoldier, _G.AutoUpgradeMoreOof, _G.AutoUpgradeFasterNoobs = false, false, false, false, false, false, false, false
_G.AutoRebirthMoreOof, _G.AutoRebirthMoreRebirth, _G.AutoRebirthMoreFire = false, false, false
_G.AutoFireMoreFire, _G.AutoFireMoreBulk, _G.AutoFireMoreOof, _G.AutoFireMoreRebirth, _G.AutoFireMoreTierLuck, _G.AutoFireMoreCashBonus = false, false, false, false, false, false
_G.AutoRebirthTimer = false
_G.AutoBlazeMoreBlaze, _G.AutoBlazeMoreFire, _G.AutoBlazeMoreOof, _G.AutoBlazeMoreOofs, _G.AutoBlazeMoreBulk, _G.AutoBlazeConvert = false, false, false, false, false, false
_G.AutoUpgradePharaoh = false

-- REALM 2 AUTOMATION FLAGS
_G.AutoUpgradeFishermanNoob = false
_G.AutoUpgradeKnightNoob = false
_G.AutoUpgradeExplorerNoob = false
_G.AutoUpgradeMagicianNoob = false
_G.AutoRealm2MoreOof, _G.AutoRealm2MoreWalkSpeed = false, false
_G.AutoRealm2MoreWater, _G.AutoRealm2MoreOofWater, _G.AutoRealm2MorePlanks = false, false, false
_G.AutoRealm2MoreIce, _G.AutoRealm2WaterPump1, _G.AutoRealm2WaterPump2, _G.AutoRealm2MoreOofIce = false, false, false, false
_G.AutoFillBucket1, _G.AutoFillBucket2, _G.AutoFillBucket3, _G.AutoFillBucket4, _G.AutoFillBucket5 = false, false, false, false, false
_G.AutoFillBucket6, _G.AutoFillBucket7, _G.AutoFillBucket8, _G.AutoFillBucket9, _G.AutoFillBucket10, _G.AutoFillBucket11 = false, false, false, false, false, false

-- WOOD & PLANKS AUTOMATION FLAGS
_G.AutoWoodRankUp, _G.AutoWoodMoreWood, _G.AutoWoodSharperAxes, _G.AutoWoodBiggerDeposit = false, false, false, false
_G.AutoWoodFasterConversion, _G.AutoWoodMorePlanks = false, false
_G.AutoDepositWood = false
_G.AutoPlanksMorePlanks, _G.AutoPlanksMoreWood, _G.AutoPlanksWaterFromPlanks = false, false, false

-- GEMS & MINING AUTOMATION FLAGS
_G.AutoGemMoreOof, _G.AutoGemMoreGems, _G.AutoGemStrongerPickaxes, _G.AutoGemMoreOreStats, _G.AutoGemExchange = false, false, false, false, false
_G.AutoMineStone, _G.AutoMineCoal, _G.AutoMineSilver, _G.AutoMineIron, _G.AutoMineCopper = false, false, false, false, false
_G.AutoMineGold, _G.AutoMinePlatinum, _G.AutoMineTitanium, _G.AutoMineCobalt, _G.AutoMineUranium = false, false, false, false, false
_G.AutoMinePalladium, _G.AutoMineAetherite, _G.AutoMineRuby, _G.AutoMineVoidsteel, _G.AutoMineCelestium = false, false, false, false, false
_G.MiningJumpSpeed = 0.8 

-- HACKER NOOBS AUTOMATION FLAGS
_G.AutoUpgradeHacker1, _G.AutoUpgradeHacker2, _G.AutoUpgradeHacker3, _G.AutoUpgradeHacker4 = false, false, false, false

-- FOOTBALL AUTOMATION FLAGS
_G.AutoScoreGoal = false
_G.AutoGoalsMoreGoals = false
_G.AutoGoalsRuneBulk = false
_G.AutoGoalsRuneLuck = false
_G.AutoBuyAutoKick = false
_G.AutoFootballTree = false
_G.AutoClaimTrophies = false

_G.AutoUpgradeGoalkeeper = false
_G.AutoUpgradeLeftBack = false
_G.AutoUpgradeLeftCenterBack = false
_G.AutoUpgradeRightCenterBack = false
_G.AutoUpgradeRightBack = false
_G.AutoUpgradeLeftDefensiveMid = false
_G.AutoUpgradeRightDefensiveMid = false
_G.AutoUpgradeAttackingMid = false
_G.AutoUpgradeLeftWing = false
_G.AutoUpgradeRightWing = false
_G.AutoUpgradeStriker = false

-- BREAD & ANIMAL AUTOMATION FLAGS
_G.AutoBreadMoreBread, _G.AutoBreadMoreBread2, _G.AutoBreadMoreWheat, _G.AutoBreadBiggerWheatDeposit, _G.AutoDepositWheat = false, false, false, false, false
_G.AutoBreadFasterWheatConversion, _G.AutoBreadMoreConsumption, _G.AutoBreadMoreRuneLuck, _G.AutoBreadMoreTierLuck = false, false, false, false
_G.AutoUpgradeCow, _G.AutoUpgradeChicken, _G.AutoBuyCow, _G.AutoBuyChicken = false, false, false, false

_G.AutoFarmCash, _G.AutoUpgradeMoreCash, _G.AutoUpgradeFasterDropper, _G.AutoUpgradeMoreRuneLuck = false, false, false, false
_G.AutoRollBasicRune, _G.AutoRollSuperRune, _G.AutoRollAdvancedRune, _G.AutoRollCosmicRune, _G.AutoRollFootballRune, _G.AutoRollSnowyRune = false, false, false, false, false, false
_G.AutoOpenT1Chest, _G.AutoOpenT2Chest = false, false
_G.AutoOpenClassicCapsule, _G.AutoOpenFootballCapsule, _G.AutoOpenSuperCapsule = false, false, false

_G.AutoEnchantStarter, _G.AutoEnchantCooker, _G.AutoEnchantFarmer, _G.AutoEnchantMagician, _G.AutoEnchantArcher, _G.AutoEnchantSoldier = false, false, false, false, false, false
_G.AutoEnchantHacker1, _G.AutoEnchantHacker2, _G.AutoEnchantHacker3, _G.AutoEnchantHacker4, _G.AutoEnchantPharaoh = false, false, false, false, false

_G.FPSBoostMode = false
_G.ShowStatsHUD = true
_G.DiscordWebhookURL = _G.DiscordWebhookURL or ""

player.Idled:Connect(function()
    if Running and _G.AntiAFK then
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

-- TOAST NOTIFICATION HELPER
local function showToast(msg)
    task.spawn(function()
        local toast = Instance.new("Frame")
        toast.Size = UDim2.new(0, 210, 0, 36)
        toast.Position = UDim2.new(1, 10, 1, -60)
        toast.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
        toast.BackgroundTransparency = 0.35 
        toast.BorderSizePixel = 0
        toast.Parent = sg
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

local function sendDiscordWebhook(message)
    if _G.DiscordWebhookURL ~= "" then
        pcall(function()
            local requestFunc = syn and syn.request or http_request or request
            if requestFunc then
                requestFunc({
                    Url = _G.DiscordWebhookURL,
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
        if _G.ShowStatsHUD then
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
            for k, v in pairs(_G) do
                if type(v) == "boolean" and v == true and k ~= "AntiAFK" and k ~= "FPSBoostMode" and k ~= "ShowStatsHUD" then
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
mainFrame.Size = UDim2.new(0, 580, 0, 420) 
mainFrame.Position = UDim2.new(0.5, -290, 0.5, -210) 
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25) 
mainFrame.BackgroundTransparency = 0.35; mainFrame.BorderSizePixel = 0; mainFrame.Parent = sg
local mainCorner = Instance.new("UICorner") mainCorner.CornerRadius = UDim.new(0, 10) mainCorner.Parent = mainFrame

local headerTitle = Instance.new("TextLabel") headerTitle.Size = UDim2.new(0.5, 0, 0, 35) headerTitle.Position = UDim2.new(0, 12, 0, 4) headerTitle.BackgroundTransparency = 1; headerTitle.TextColor3 = Color3.fromRGB(245, 245, 250) headerTitle.TextSize = 16; headerTitle.Font = Enum.Font.SourceSansBold; headerTitle.Text = "Dominate Hub | V7.1 Pro" headerTitle.TextXAlignment = Enum.TextXAlignment.Left; headerTitle.Parent = mainFrame

-- UNIVERSAL SEARCH BAR
local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(0, 150, 0, 26) searchBox.Position = UDim2.new(1, -160, 0, 8) searchBox.BackgroundColor3 = Color3.fromRGB(35, 35, 40) searchBox.TextColor3 = Color3.fromRGB(255, 255, 255) searchBox.PlaceholderText = "Search Hub..." searchBox.TextSize = 13; searchBox.Font = Enum.Font.SourceSansBold; searchBox.Parent = mainFrame
Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 6)

searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local q = searchBox.Text:lower()
    for _, f in ipairs(mainFrame:GetDescendants()) do
        if f:IsA("Frame") and f.BackgroundColor3 == Color3.fromRGB(35, 35, 45) then
            local label = f:FindFirstChildWhichIsA("TextLabel")
            if label then
                if q == "" or label.Text:lower():find(q) then f.Visible = true else f.Visible = false end
            end
        end
    end
end)

-- FLOATING PILL (NO STROKE)
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
        local tween = TweenService:Create(mainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 580, 0, 420), BackgroundTransparency = 0.35})
        tween:Play()
        minBtn.TextColor3 = Color3.fromRGB(0, 136, 255)
    end
end)

local tabList = Instance.new("Frame") tabList.Size = UDim2.new(1, -20, 0, 32) tabList.Position = UDim2.new(0, 10, 0, 40) tabList.BackgroundTransparency = 1; tabList.Parent = mainFrame

local function makeMainTab(txt, pos)
    local t = Instance.new("TextButton") t.Size = UDim2.new(0, 65, 1, 0) t.Position = UDim2.new(0, pos, 0, 0) t.BackgroundColor3 = Color3.fromRGB(55, 55, 65) t.TextColor3 = Color3.fromRGB(210, 210, 220) t.TextSize = 11; t.Font = Enum.Font.SourceSansBold; t.Text = txt; t.Parent = tabList
    Instance.new("UICorner", t).CornerRadius = UDim.new(0, 6)
    return t
end

local tabRealm1 = makeMainTab("Realm 1", 0) tabRealm1.BackgroundColor3 = Color3.fromRGB(240, 240, 245) tabRealm1.TextColor3 = Color3.fromRGB(15, 15, 15)
local tabRealm2 = makeMainTab("Realm 2", 70)
local tabRealm3 = makeMainTab("Realm 3", 140)
local tabFootball = makeMainTab("Football", 210)
local tabRunes = makeMainTab("Runes", 280)
local tabCapsules = makeMainTab("Capsules", 350)
local tabEnchants = makeMainTab("Enchants", 420)
local tabSettings = makeMainTab("Settings", 490)

-- PAGE CONTAINERS
local function makePage()
    local p = Instance.new("Frame") p.Size = UDim2.new(1, -20, 1, -85) p.Position = UDim2.new(0, 10, 0, 80) p.BackgroundTransparency = 1; p.Visible = false; p.Parent = mainFrame return p
end
local realm1MasterPage, realm2Page, realm3Page, footballPage, runesPage, capsulesPage, enchantsPage, settingsPage = makePage(), makePage(), makePage(), makePage(), makePage(), makePage(), makePage(), makePage()
realm1MasterPage.Visible = true

-- SIDEBAR GENERATOR
local function makeSidebar(parent)
    local sb = Instance.new("ScrollingFrame") sb.Size = UDim2.new(0, 80, 1, -5) sb.Position = UDim2.new(0, 0, 0, 5) sb.BackgroundTransparency = 1; sb.BorderSizePixel = 0; sb.ScrollBarThickness = 2; sb.ScrollBarImageColor3 = Color3.fromRGB(0, 136, 255); sb.Parent = parent
    local list = Instance.new("UIListLayout") list.Padding = UDim.new(0, 4) list.Parent = sb
    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() sb.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 10) end)
    return sb
end

local function makeSideBtn(txt, parent)
    local b = Instance.new("TextButton") b.Size = UDim2.new(1, -5, 0, 28) b.BackgroundColor3 = Color3.fromRGB(55, 55, 65) b.TextColor3 = Color3.fromRGB(210, 210, 220) b.Font = Enum.Font.SourceSansBold; b.TextSize = 10; b.Text = txt; b.Parent = parent
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    return b
end

-- 2-COLUMN SCROLL GENERATOR
local function makeGridScroll(parent, hasSidebar)
    local s = Instance.new("ScrollingFrame")
    if hasSidebar then s.Size = UDim2.new(1, -90, 1, -5) s.Position = UDim2.new(0, 90, 0, 5) else s.Size = UDim2.new(1, 0, 1, -5) s.Position = UDim2.new(0, 0, 0, 5) end
    s.BackgroundTransparency = 1; s.BorderSizePixel = 0; s.ScrollBarThickness = 3; s.ScrollBarImageColor3 = Color3.fromRGB(0, 136, 255); s.Visible = false; s.Parent = parent 
    
    local grid = Instance.new("UIGridLayout") grid.CellSize = UDim2.new(0.5, -6, 0, 36) grid.CellPadding = UDim2.new(0, 8, 0, 8) grid.SortOrder = Enum.SortOrder.LayoutOrder; grid.Parent = s
    grid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() s.CanvasSize = UDim2.new(0, 0, 0, grid.AbsoluteContentSize.Y + 10) end)
    return s 
end

-- CARD-BASED MODULE LAYOUT WITH LIVE STATUS BADGE DOTS (NO STROKE)
local function gridRow(txt, scr)
    local f = Instance.new("Frame") f.BackgroundColor3 = Color3.fromRGB(35, 35, 45) f.BorderSizePixel = 0; f.Parent = scr

    -- Live Status Indicator Badge (Green = Active, Red = Disabled)
    local dot = Instance.new("Frame")
    dot.Name = "StatusDot"
    dot.Size = UDim2.new(0, 6, 0, 6)
    dot.Position = UDim2.new(0, 8, 0.5, -3)
    dot.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    dot.BorderSizePixel = 0
    dot.Parent = f
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    local l = Instance.new("TextLabel") l.Size = UDim2.new(0.60, -10, 1, 0) l.Position = UDim2.new(0, 20, 0, 0) l.BackgroundTransparency = 1; l.TextColor3 = Color3.fromRGB(230, 230, 235) l.TextSize = 11; l.Font = Enum.Font.SourceSansBold; l.Text = txt; l.TextXAlignment = Enum.TextXAlignment.Left; l.TextWrapped = true; l.Parent = f
    local b = Instance.new("TextButton") b.Size = UDim2.new(0.35, -5, 0, 24) b.Position = UDim2.new(0.65, 0, 0.5, -12) b.BackgroundColor3 = Color3.fromRGB(60, 20, 20) b.TextColor3 = Color3.fromRGB(255, 120, 120) b.TextSize = 11; b.Font = Enum.Font.SourceSansBold; b.Text = "DISABLED" b.Parent = f
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6) Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5) return b
end

-- ======================================================================================
-- REALM 1 SIDEBAR & GRIDS
-- ======================================================================================
local r1Sidebar = makeSidebar(realm1MasterPage)
local b1Noobs = makeSideBtn("Noobs", r1Sidebar) b1Noobs.BackgroundColor3 = Color3.fromRGB(240, 240, 245) b1Noobs.TextColor3 = Color3.fromRGB(15, 15, 15)
local b1Oof = makeSideBtn("Oof", r1Sidebar) 
local b1Rebirth = makeSideBtn("Rebirth", r1Sidebar) 
local b1Fire = makeSideBtn("Fire", r1Sidebar) 
local b1Blaze = makeSideBtn("Blaze", r1Sidebar) 
local b1Farm = makeSideBtn("Farm", r1Sidebar) 
local b1Cash = makeSideBtn("Cash", r1Sidebar) 
local b1Hacker = makeSideBtn("Hacker", r1Sidebar)

local r1NoobScroll = makeGridScroll(realm1MasterPage, true) r1NoobScroll.Visible = true
local r1OofScroll = makeGridScroll(realm1MasterPage, true) local r1RebirthScroll = makeGridScroll(realm1MasterPage, true) local r1FireScroll = makeGridScroll(realm1MasterPage, true) local r1BlazeScroll = makeGridScroll(realm1MasterPage, true) local r1BreadScroll = makeGridScroll(realm1MasterPage, true) local r1CashScroll = makeGridScroll(realm1MasterPage, true) local r1HackerScroll = makeGridScroll(realm1MasterPage, true)

local UI = {}
UI.Starter = gridRow("Starter Auto Upgrade", r1NoobScroll) UI.Cooker = gridRow("Cooker Auto Upgrade", r1NoobScroll) UI.Farmer = gridRow("Farmer Auto Upgrade", r1NoobScroll) UI.Magician = gridRow("Magician Auto Upgrade", r1NoobScroll) UI.Archer = gridRow("Archer Auto Upgrade", r1NoobScroll) UI.Soldier = gridRow("Soldier Auto Upgrade", r1NoobScroll)
UI.MoreOof = gridRow("More Oof Auto Upgrade", r1OofScroll) UI.FasterNoobs = gridRow("Faster Noobs Upgrade", r1OofScroll)
UI.RebirthOof = gridRow("More Oof (Rebirth)", r1RebirthScroll) UI.RebirthRebirth = gridRow("More Rebirth (Rebirth)", r1RebirthScroll) UI.RebirthFire = gridRow("More Fire (Rebirth)", r1RebirthScroll)

UI.FireFire = gridRow("More Fire", r1FireScroll) 
UI.FireBulk = gridRow("More Bulk", r1FireScroll) 
UI.FireOof = gridRow("More Oof", r1FireScroll) 
UI.FireRebirth = gridRow("More Rebirth", r1FireScroll) 
UI.FireTierLuck = gridRow("More Tier Luck", r1FireScroll) 
UI.FireCashBonus = gridRow("More Cash", r1FireScroll)

UI.AutoBlazeConvert = gridRow("Auto Convert to Blaze", r1BlazeScroll) UI.BlazeMoreBlaze = gridRow("More Blaze", r1BlazeScroll) UI.BlazeMoreFire = gridRow("More Fire", r1BlazeScroll) UI.BlazeMoreOof = gridRow("More Oof", r1BlazeScroll) UI.BlazeMoreOofs = gridRow("More Oofs", r1BlazeScroll) UI.BlazeMoreBulk = gridRow("More Bulk", r1BlazeScroll)
UI.DepositWheat = gridRow("Auto Deposit Wheat", r1BreadScroll) UI.BreadMoreBread = gridRow("More Bread", r1BreadScroll) UI.BreadMoreBread2 = gridRow("More Bread 2", r1BreadScroll) UI.BreadMoreWheat = gridRow("More Wheat", r1BreadScroll) UI.BreadBiggerWheatDeposit = gridRow("Bigger Wheat Deposit", r1BreadScroll) UI.BreadFasterWheatConversion = gridRow("Fast Wheat Conversion", r1BreadScroll) UI.BreadMoreConsumption = gridRow("More Consumption", r1BreadScroll) UI.BreadMoreRuneLuck = gridRow("More Rune Luck", r1BreadScroll) UI.BreadMoreTierLuck = gridRow("More Tier Luck", r1BreadScroll) UI.UpgradeCow = gridRow("Upgrade Cow", r1BreadScroll) UI.UpgradeChicken = gridRow("Upgrade Chicken", r1BreadScroll) UI.BuyCow = gridRow("Buy Cow", r1BreadScroll) UI.BuyChicken = gridRow("Buy Chicken", r1BreadScroll)
UI.AutoFarmCash = gridRow("Auto Pad Tycoon", r1CashScroll) UI.CashMoreCash = gridRow("More Cash Upgrade", r1CashScroll) UI.CashFasterDropper = gridRow("Faster Dropper", r1CashScroll) UI.CashMoreRuneLuck = gridRow("More Rune Luck", r1CashScroll)
UI.Hacker1 = gridRow("Auto Upgrade Hacker 1", r1HackerScroll) UI.Hacker2 = gridRow("Auto Upgrade Hacker 2", r1HackerScroll) UI.Hacker3 = gridRow("Auto Upgrade Hacker 3", r1HackerScroll) UI.Hacker4 = gridRow("Auto Upgrade Hacker 4", r1HackerScroll)

-- ======================================================================================
-- REALM 2 SIDEBAR & GRIDS
-- ======================================================================================
local r2Sidebar = makeSidebar(realm2Page)
local b2Noobs = makeSideBtn("Noobs", r2Sidebar) b2Noobs.BackgroundColor3 = Color3.fromRGB(240, 240, 245) b2Noobs.TextColor3 = Color3.fromRGB(15, 15, 15)
local b2Oof = makeSideBtn("OoF", r2Sidebar) 
local b2Water = makeSideBtn("Water", r2Sidebar) 
local b2Ice = makeSideBtn("Ice", r2Sidebar) 
local b2Buckets = makeSideBtn("Buckets", r2Sidebar) 
local b2Wood = makeSideBtn("Wood", r2Sidebar) 
local b2Planks = makeSideBtn("Planks", r2Sidebar) 
local b2Gems = makeSideBtn("Gems", r2Sidebar) 
local b2Mine = makeSideBtn("Mining", r2Sidebar)

local r2NoobScroll = makeGridScroll(realm2Page, true) r2NoobScroll.Visible = true
local r2OofScroll = makeGridScroll(realm2Page, true) local r2WaterScroll = makeGridScroll(realm2Page, true) local r2IceScroll = makeGridScroll(realm2Page, true) local r2BucketScroll = makeGridScroll(realm2Page, true) local r2WoodScroll = makeGridScroll(realm2Page, true) local r2PlanksScroll = makeGridScroll(realm2Page, true) local r2GemsScroll = makeGridScroll(realm2Page, true) local r2MiningScroll = makeGridScroll(realm2Page, true)

UI.R2Fisherman = gridRow("Auto Upgrade Fisherman", r2NoobScroll) UI.R2Knight = gridRow("Auto Upgrade Knight", r2NoobScroll) UI.R2Explorer = gridRow("Auto Upgrade Explorer", r2NoobScroll) UI.R2Magician = gridRow("Auto Upgrade Magician", r2NoobScroll)
UI.R2MoreOof = gridRow("More Oof (Realm 2)", r2OofScroll) UI.R2WalkSpeed = gridRow("More Walk Speed", r2OofScroll)
UI.R2MoreWater = gridRow("More Water", r2WaterScroll) UI.R2WaterOof = gridRow("More Oof (Water)", r2WaterScroll) UI.R2Planks = gridRow("More Planks", r2WaterScroll)
UI.R2MoreIce = gridRow("More Ice", r2IceScroll) UI.R2WaterPump1 = gridRow("Water Pump Hire", r2IceScroll) UI.R2WaterPump2 = gridRow("Water From Ice", r2IceScroll) UI.R2IceOof = gridRow("More Oof (Ice)", r2IceScroll)
UI.Bucket1 = gridRow("Auto Fill Bucket #1", r2BucketScroll) UI.Bucket2 = gridRow("Auto Fill Bucket #2", r2BucketScroll) UI.Bucket3 = gridRow("Auto Fill Bucket #3", r2BucketScroll) UI.Bucket4 = gridRow("Auto Fill Bucket #4", r2BucketScroll) UI.Bucket5 = gridRow("Auto Fill Bucket #5", r2BucketScroll) UI.Bucket6 = gridRow("Auto Fill Bucket #6", r2BucketScroll) UI.Bucket7 = gridRow("Auto Fill Bucket #7", r2BucketScroll) UI.Bucket8 = gridRow("Auto Fill Bucket #8", r2BucketScroll) UI.Bucket9 = gridRow("Auto Fill Bucket #9", r2BucketScroll) UI.Bucket10 = gridRow("Auto Fill Bucket #10", r2BucketScroll) UI.Bucket11 = gridRow("Auto Fill Bucket #11", r2BucketScroll)
UI.WoodRankUp = gridRow("Auto Wood Rank Up", r2WoodScroll) UI.WoodMoreWood = gridRow("More Wood", r2WoodScroll) UI.WoodSharperAxes = gridRow("Sharper Axes", r2WoodScroll) UI.WoodBiggerDeposit = gridRow("Bigger Wood Deposit", r2WoodScroll) UI.WoodFasterConversion = gridRow("Faster Wood Conversion", r2WoodScroll) UI.WoodMorePlanks = gridRow("More Planks From Wood", r2WoodScroll) UI.DepositWood = gridRow("Auto Deposit Wood", r2WoodScroll)
UI.PlanksMorePlanks = gridRow("More Planks", r2PlanksScroll) UI.PlanksMoreWood = gridRow("More Wood", r2PlanksScroll) UI.PlanksWaterFromPlanks = gridRow("Water From Planks", r2PlanksScroll)
UI.GemMoreOof = gridRow("Upgrade More Oof (Gems)", r2GemsScroll) UI.GemMoreGems = gridRow("Upgrade More Gems", r2GemsScroll) UI.GemStrongerPickaxes = gridRow("Stronger Pickaxes", r2GemsScroll) UI.GemMoreOreStats = gridRow("More Ore Stats", r2GemsScroll) UI.GemExchange = gridRow("Auto Gem Exchange", r2GemsScroll)

UI.MiningSpeedSwitch = gridRow("Glide Speed", r2MiningScroll) UI.MiningSpeedSwitch.BackgroundColor3 = Color3.fromRGB(0, 100, 200) UI.MiningSpeedSwitch.TextColor3 = Color3.fromRGB(255, 255, 255) UI.MiningSpeedSwitch.Text = "0.8 Studs/sec"
UI.MineStone = gridRow("Mine Stone", r2MiningScroll) UI.MineCoal = gridRow("Mine Coal", r2MiningScroll) UI.MineSilver = gridRow("Mine Silver", r2MiningScroll) UI.MineIron = gridRow("Mine Iron", r2MiningScroll) UI.MineCopper = gridRow("Mine Copper", r2MiningScroll) UI.MineGold = gridRow("Mine Gold", r2MiningScroll) UI.MinePlatinum = gridRow("Mine Platinum", r2MiningScroll) UI.MineTitanium = gridRow("Mine Titanium", r2MiningScroll) UI.MineCobalt = gridRow("Mine Cobalt", r2MiningScroll) UI.MineUranium = gridRow("Mine Uranium", r2MiningScroll) UI.MinePalladium = gridRow("Mine Palladium", r2MiningScroll) UI.MineAetherite = gridRow("Mine Aetherite", r2MiningScroll) UI.MineRuby = gridRow("Mine Ruby", r2MiningScroll) UI.MineVoidsteel = gridRow("Mine Voidsteel", r2MiningScroll) UI.MineCelestium = gridRow("Mine Celestium", r2MiningScroll)

-- ======================================================================================
-- REALM 3, FOOTBALL, RUNES, CAPSULES, ENCHANTS, SETTINGS
-- ======================================================================================
local r3Scroll = makeGridScroll(realm3Page, false) r3Scroll.Visible = true
UI.Pharaoh = gridRow("Auto Upgrade Pharaoh", r3Scroll)

local fSidebar = makeSidebar(footballPage)
local bFNoobs = makeSideBtn("Noobs", fSidebar) bFNoobs.BackgroundColor3 = Color3.fromRGB(240, 240, 245) bFNoobs.TextColor3 = Color3.fromRGB(15, 15, 15)
local bFUpgrades = makeSideBtn("Upgrades", fSidebar)
local fNoobScroll = makeGridScroll(footballPage, true) fNoobScroll.Visible = true
local fUpgradeScroll = makeGridScroll(footballPage, true)
UI.Goalkeeper = gridRow("Upgrade Goalkeeper", fNoobScroll) UI.LeftBack = gridRow("Upgrade Left Back", fNoobScroll) UI.LeftCenterBack = gridRow("Upgrade L-Center Back", fNoobScroll) UI.RightCenterBack = gridRow("Upgrade R-Center Back", fNoobScroll) UI.RightBack = gridRow("Upgrade Right Back", fNoobScroll) UI.LeftDefensiveMid = gridRow("Upgrade L-Defensive Mid", fNoobScroll) UI.RightDefensiveMid = gridRow("Upgrade R-Defensive Mid", fNoobScroll) UI.AttackingMid = gridRow("Upgrade Attacking Mid", fNoobScroll) UI.LeftWing = gridRow("Upgrade Left Wing", fNoobScroll) UI.RightWing = gridRow("Upgrade Right Wing", fNoobScroll) UI.Striker = gridRow("Upgrade Striker", fNoobScroll)
UI.ScoreGoal = gridRow("Auto Score Goal", fUpgradeScroll) UI.MoreGoals = gridRow("More Goals Upgrade", fUpgradeScroll) UI.GoalsRuneBulk = gridRow("Goals Rune Bulk", fUpgradeScroll) UI.GoalsRuneLuck = gridRow("Goals Rune Luck", fUpgradeScroll) UI.AutoBuyKicker = gridRow("Auto-Buy Auto Kick", fUpgradeScroll) UI.FootballTree = gridRow("Auto Football Tree", fUpgradeScroll) UI.ClaimTrophies = gridRow("Auto Buy Trophies", fUpgradeScroll)

local ruSidebar = makeSidebar(runesPage)
local bRu1 = makeSideBtn("Realm 1", ruSidebar) bRu1.BackgroundColor3 = Color3.fromRGB(240, 240, 245) bRu1.TextColor3 = Color3.fromRGB(15, 15, 15)
local bRu2 = makeSideBtn("Realm 2", ruSidebar) 
local bRu3 = makeSideBtn("Realm 3", ruSidebar) 
local bRuE = makeSideBtn("Events", ruSidebar)
local ruScroll1 = makeGridScroll(runesPage, true) ruScroll1.Visible = true
local ruScroll2 = makeGridScroll(runesPage, true) local ruScroll3 = makeGridScroll(runesPage, true) local ruScrollE = makeGridScroll(runesPage, true)
UI.RollBasicRuneCard = gridRow("Auto Basic Rune Circle", ruScroll1) UI.RollSuperRuneCard = gridRow("Auto Super Rune Circle", ruScroll1) UI.RollAdvancedRuneCard = gridRow("Auto Advanced Rune", ruScroll1) UI.RollCosmicRuneCard = gridRow("Auto Cosmic Prism", ruScroll1)
UI.RollSnowyRuneCard = gridRow("Auto Snowy Rune Circle", ruScroll2)
UI.FootballRuneCard = gridRow("Auto Football Rune", ruScrollE)

local capScroll = makeGridScroll(capsulesPage, false) capScroll.Visible = true
UI.ClassicCapsule = gridRow("Hatch Classic Capsule", capScroll) UI.FootballCapsule = gridRow("Hatch Football Capsule", capScroll) UI.SuperCapsule = gridRow("Hatch Super Capsule", capScroll)

local encScroll = makeGridScroll(enchantsPage, false) encScroll.Visible = true
UI.EnchantStarter = gridRow("Reroll: Starter", encScroll) UI.EnchantCooker = gridRow("Reroll: Cooker", encScroll) UI.EnchantFarmer = gridRow("Reroll: Farmer", encScroll) UI.EnchantMagician = gridRow("Reroll: Magician", encScroll) UI.EnchantArcher = gridRow("Reroll: Archer", encScroll) UI.EnchantSoldier = gridRow("Reroll: Soldier", encScroll) UI.EnchantHacker1 = gridRow("Reroll: Hacker 1", encScroll) UI.EnchantHacker2 = gridRow("Reroll: Hacker 2", encScroll) UI.EnchantHacker3 = gridRow("Reroll: Hacker 3", encScroll) UI.EnchantHacker4 = gridRow("Reroll: Hacker 4", encScroll) UI.EnchantPharaoh = gridRow("Reroll: Pharaoh", encScroll)

-- SETTINGS SIDEBAR (GENERAL & CONFIG SUB-TABS)
local setSidebar = makeSidebar(settingsPage)
local bSetGen = makeSideBtn("General", setSidebar) bSetGen.BackgroundColor3 = Color3.fromRGB(240, 240, 245) bSetGen.TextColor3 = Color3.fromRGB(15, 15, 15)
local bSetConfig = makeSideBtn("Config", setSidebar)

local setGenScroll = makeGridScroll(settingsPage, true) setGenScroll.Visible = true
local setConfigScroll = makeGridScroll(settingsPage, true)

UI.OpenT1ChestCard = gridRow("Mass-Open T1 Chests", setGenScroll) UI.OpenT2ChestCard = gridRow("Mass-Open T2 Chests", setGenScroll) 
UI.AFK = gridRow("Anti-AFK Protection", setGenScroll) UI.AFK.BackgroundColor3 = Color3.fromRGB(20, 60, 20) UI.AFK.TextColor3 = Color3.fromRGB(120, 255, 120) UI.AFK.Text = "ACTIVE"
UI.Prestige = gridRow("Auto Prestige", setGenScroll) UI.RebirthTimerCard = gridRow("Auto Rebirth (10m)", setGenScroll) 

UI.HUDToggle = gridRow("Stats HUD Overlay", setGenScroll)
UI.HUDToggle.BackgroundColor3 = Color3.fromRGB(20, 60, 20) UI.HUDToggle.TextColor3 = Color3.fromRGB(120, 255, 120) UI.HUDToggle.Text = "ACTIVE"

UI.FPSBoostToggle = gridRow("FPS Booster Mode", setGenScroll)
UI.ThemePicker = gridRow("Hub Accent Theme", setGenScroll)
UI.ThemePicker.BackgroundColor3 = Color3.fromRGB(0, 80, 160)
UI.ThemePicker.TextColor3 = Color3.fromRGB(255, 255, 255)
UI.ThemePicker.Text = "Theme: Neon Blue"

UI.KillSwitch = gridRow("EMERGENCY KILL SWITCH", setGenScroll) UI.KillSwitch.BackgroundColor3 = Color3.fromRGB(120, 20, 20) UI.KillSwitch.TextColor3 = Color3.fromRGB(255, 200, 200) UI.KillSwitch.Text = "TERMINATE"

-- CONFIG SLOTS (1 TO 5) IN CONFIG SUB-TAB
UI.ConfigSlotSwitch = gridRow("Select Slot", setConfigScroll)
UI.ConfigSlotSwitch.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
UI.ConfigSlotSwitch.TextColor3 = Color3.fromRGB(255, 255, 255)
UI.ConfigSlotSwitch.Text = "Slot #" .. _G.SelectedConfigSlot .. ": " .. slotCustomNames[1]

UI.SaveSlotBtn = gridRow("Save Slot", setConfigScroll)
UI.SaveSlotBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 50)
UI.SaveSlotBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
UI.SaveSlotBtn.Text = "SAVE"

UI.LoadSlotBtn = gridRow("Load Slot", setConfigScroll)
UI.LoadSlotBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 120)
UI.LoadSlotBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
UI.LoadSlotBtn.Text = "LOAD"

UI.ConfigSlotSwitch.MouseButton1Click:Connect(function()
    _G.SelectedConfigSlot = _G.SelectedConfigSlot + 1
    if _G.SelectedConfigSlot > 5 then _G.SelectedConfigSlot = 1 end
    UI.ConfigSlotSwitch.Text = "Slot #" .. _G.SelectedConfigSlot .. ": " .. slotCustomNames[_G.SelectedConfigSlot]
    showToast("Switched to Config Slot " .. _G.SelectedConfigSlot)
end)

UI.SaveSlotBtn.MouseButton1Click:Connect(function()
    saveConfigToSlot(_G.SelectedConfigSlot)
    showToast("Saved to Slot " .. _G.SelectedConfigSlot)
end)

UI.LoadSlotBtn.MouseButton1Click:Connect(function()
    loadConfigFromSlot(_G.SelectedConfigSlot)
    showToast("Loaded Slot " .. _G.SelectedConfigSlot)
end)

local function toggleFPSBoost(b)
    _G.FPSBoostMode = not _G.FPSBoostMode
    b.Text = _G.FPSBoostMode and "ACTIVE" or "DISABLED"
    b.BackgroundColor3 = _G.FPSBoostMode and Color3.fromRGB(20, 60, 20) or Color3.fromRGB(60, 20, 20)
    b.TextColor3 = _G.FPSBoostMode and Color3.fromRGB(120, 255, 120) or Color3.fromRGB(255, 120, 120)
    saveConfigToSlot(_G.SelectedConfigSlot)
    
    if _G.FPSBoostMode then
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
UI.FPSBoostToggle.MouseButton1Click:Connect(function() toggleFPSBoost(UI.FPSBoostToggle) end)

UI.HUDToggle.MouseButton1Click:Connect(function()
    _G.ShowStatsHUD = not _G.ShowStatsHUD
    UI.HUDToggle.Text = _G.ShowStatsHUD and "ACTIVE" or "DISABLED"
    UI.HUDToggle.BackgroundColor3 = _G.ShowStatsHUD and Color3.fromRGB(20, 60, 20) or Color3.fromRGB(60, 20, 20)
    UI.HUDToggle.TextColor3 = _G.ShowStatsHUD and Color3.fromRGB(120, 255, 120) or Color3.fromRGB(60, 20, 20)
    saveConfigToSlot(_G.SelectedConfigSlot)
end)

local themes = {
    {Name = "Neon Blue", Color = Color3.fromRGB(0, 136, 255)},
    {Name = "Purple Glow", Color = Color3.fromRGB(138, 43, 226)},
    {Name = "Emerald Green", Color = Color3.fromRGB(0, 200, 100)},
    {Name = "Crimson Red", Color = Color3.fromRGB(220, 20, 60)}
}
local currentThemeIdx = 1

UI.ThemePicker.MouseButton1Click:Connect(function()
    currentThemeIdx = currentThemeIdx + 1
    if currentThemeIdx > #themes then currentThemeIdx = 1 end
    local th = themes[currentThemeIdx]
    UI.ThemePicker.Text = "Theme: " + th.Name
    minBtn.TextColor3 = th.Color
    hudTitle.TextColor3 = th.Color
    showToast("Theme changed to " + th.Name)
end)

--======================================================================================
-- LOCOMOTION & REMOTE ENGINES
--======================================================================================
local MasterTargetVector = nil  
local MiningTargetVector = nil
local CurrentLoopStateSleep = false 

local Dest = {
    Basic = Vector3.new(1114.753, 10.310, -644.151), Super = Vector3.new(1082.093, 16.661, -782.021), Advanced = Vector3.new(1293.495, 16.515, -883.312),
    Cosmic = Vector3.new(783.450, 16.655, -855.972), Football = Vector3.new(-2713.261, 36.861, -15.832), Snowy = Vector3.new(1017.366, 5.866, 3262.671),
    ClassicCap = Vector3.new(-2586.923, 43.317, -659.105), FootballCap = Vector3.new(-2603.007, 36.295, -31.061), SuperCap = Vector3.new(618.032, 9.653, 3172.149),
    Enchant = Vector3.new(1193.1235, 18.7949, -854.0244)
}

local function GetWorldRoot() return player.Character and player.Character:FindFirstChild("HumanoidRootPart") end

task.spawn(function()
    while Running do
        task.wait(CurrentLoopStateSleep and 1.0 or 0.2)
        local hrp = GetWorldRoot()
        if hrp and Running then
            local act = nil
            if MasterTargetVector then act = MasterTargetVector elseif MiningTargetVector then act = MiningTargetVector
            elseif _G.AutoRollFootballRune then act = Dest.Football elseif _G.AutoRollSnowyRune then act = Dest.Snowy
            elseif _G.AutoRollCosmicRune then act = Dest.Cosmic elseif _G.AutoRollAdvancedRune then act = Dest.Advanced
            elseif _G.AutoRollSuperRune then act = Dest.Super elseif _G.AutoRollBasicRune then act = Dest.Basic end
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
        task.wait(0.1)
        if Running then
            local enabledOreNames = {} local hasAnyEnabled = false
            for i = 1, #OrePriorityList do if _G[OrePriorityList[i].F] then enabledOreNames[OrePriorityList[i].N] = true hasAnyEnabled = true end end

            if hasAnyEnabled then
                local needsNewTarget = false
                if not currentTargetPart or not currentTargetPart.Parent or not currentTargetPart:IsDescendantOf(workspace) then needsNewTarget = true
                elseif currentTargetPart.Parent and isOreRespawning(currentTargetPart.Parent) then needsNewTarget = true
                elseif tick() - lastOreJumpTick >= (_G.MiningJumpSpeed or 0.8) then needsNewTarget = true end

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
        task.wait(0.12)
        if NetRemote and Running then
            local hrp = GetWorldRoot()
            if hrp then
                if _G.AutoOpenClassicCapsule then if (hrp.Position - Dest.ClassicCap).Magnitude > 10 then hrp.CFrame = CFrame.new(Dest.ClassicCap + Vector3.new(0, 3, 0)) end pcall(function() NetRemote:FireServer("ToggleMinionAutoOpen", "Classic") end)
                elseif _G.AutoOpenFootballCapsule then if (hrp.Position - Dest.FootballCap).Magnitude > 10 then hrp.CFrame = CFrame.new(Dest.FootballCap + Vector3.new(0, 3, 0)) end pcall(function() NetRemote:FireServer("ToggleMinionAutoOpen", "Football") end)
                elseif _G.AutoOpenSuperCapsule then if (hrp.Position - Dest.SuperCap).Magnitude > 10 then hrp.CFrame = CFrame.new(Dest.SuperCap + Vector3.new(0, 3, 0)) end pcall(function() NetRemote:FireServer("ToggleMinionAutoOpen", "Super") end) end
            end
        end
    end
end)

local EnchantQueue = { {F="AutoEnchantStarter",A={"Starter"}}, {F="AutoEnchantCooker",A={"Cooker"}}, {F="AutoEnchantFarmer",A={"Farmer"}}, {F="AutoEnchantMagician",A={"Magician"}}, {F="AutoEnchantArcher",A={"Archer"}}, {F="AutoEnchantSoldier",A={"Soldier"}}, {F="AutoEnchantHacker1",A={"Hacker 1"}}, {F="AutoEnchantHacker2",A={"Hacker 2"}}, {F="AutoEnchantHacker3",A={"Hacker 3"}}, {F="AutoEnchantHacker4",A={"Hacker 4"}}, {F="AutoEnchantPharaoh",A={"Pharaoh"}} }
task.spawn(function()
    while Running do
        task.wait(0.5) local act = false
        for i = 1, #EnchantQueue do if _G[EnchantQueue[i].F] then act = true break end end
        if NetRemote and Running and act then
            local hrp = GetWorldRoot() if hrp and (hrp.Position - Dest.Enchant).Magnitude > 10 then hrp.CFrame = CFrame.new(Dest.Enchant + Vector3.new(0, 3, 0)) end
            for i = 1, #EnchantQueue do
                if not Running then break end local item = EnchantQueue[i]
                if _G[item.F] then pcall(function() NetRemote:FireServer("RerollEnchant", unpack(item.A)) end) task.wait(0.3) end
            end
        end
    end
end)

task.spawn(function()
    while Running do
        task.wait(0.5)
        if _G.AutoFarmCash and Running then
            local gc = workspace:FindFirstChild("__GAME_CONTENT") local ty = gc and gc:FindFirstChild("Tycoon") local btnF = ty and ty:FindFirstChild("Buttons")
            if btnF and Running then
                local locked = {} CurrentLoopStateSleep = false 
                repeat
                    if not Running or not _G.AutoFarmCash then break end
                    local vis = btnF:GetChildren() local att = false
                    for i = 1, #vis do
                        if not Running or not _G.AutoFarmCash then break end
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
                    if not att or not _G.AutoFarmCash or not Running then break end task.wait(0.1)
                until false
                if Running then MasterTargetVector = nil CurrentLoopStateSleep = true local sE = tick() + math.random(120, 180) repeat task.wait(1) until tick() >= sE or not _G.AutoFarmCash or not Running end
            else MasterTargetVector = nil task.wait(2) end
        else MasterTargetVector = nil CurrentLoopStateSleep = true task.wait(1) end
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
    {F="AutoWoodRankUp",T="WoodRankUp",A={}}, {F="AutoWoodMoreWood",T="UpgradeUpgradeMax",A={"Wood","MoreWood"}}, {F="AutoWoodSharperAxes",T="UpgradeUpgradeMax",A={"Wood","SharperAxes"}}, {F="AutoWoodBiggerDeposit",T="UpgradeUpgradeMax",A={"Wood","BiggerWoodDeposit"}}, {F="AutoWoodFasterConversion",T="UpgradeUpgradeMax",A={"Wood","FasterWoodConversion"}}, {F="AutoWoodMorePlanks",T="UpgradeUpgradeMax",A={"Wood","MorePlanksFromWood"}},
    {F="AutoPlanksMorePlanks",T="UpgradeUpgradeMax",A={"Planks","MorePlanks"}}, {F="AutoPlanksMoreWood",T="UpgradeUpgradeMax",A={"Planks","MoreWood"}}, {F="AutoPlanksWaterFromPlanks",T="UpgradeUpgradeMax",A={"Planks","WaterFromPlanks"}},
    {F="AutoRebirthMoreOof",T="UpgradeUpgradeMax",A={"Rebirth","MoreOof"}}, {F="AutoRebirthMoreRebirth",T="UpgradeUpgradeMax",A={"Rebirth","MoreRebirth"}}, {F="AutoRebirthMoreFire",T="UpgradeUpgradeMax",A={"Rebirth","MoreFire"}},
    {F="AutoFireMoreFire",T="UpgradeUpgradeMax",A={"Fire","MoreFire"}}, {F="AutoFireMoreBulk",T="UpgradeUpgradeMax",A={"Fire","MoreBulk"}}, {F="AutoFireMoreOof",T="UpgradeUpgradeMax",A={"Fire","MoreOof"}}, {F="AutoFireMoreRebirth",T="UpgradeUpgradeMax",A={"Fire","MoreRebirth"}}, {F="AutoFireMoreTierLuck",T="UpgradeUpgradeMax",A={"Fire","MoreTierLuck"}}, {F="AutoFireMoreCashBonus",T="UpgradeUpgradeMax",A={"Fire","MoreCashBonus"}},
    {F="AutoUpgradeMoreCash",T="UpgradeUpgradeMax",A={"Cash","MoreCash"}}, {F="AutoUpgradeFasterDropper",T="UpgradeUpgradeMax",A={"Cash","FasterDropper"}}, {F="AutoUpgradeMoreRuneLuck",T="UpgradeUpgradeMax",A={"Cash","MoreRuneLuck"}},
    {F="AutoGoalsMoreGoals",T="UpgradeUpgradeMax",A={"Goals","MoreGoals"}}, {F="AutoGoalsRuneBulk",T="UpgradeUpgradeMax",A={"Goals","RuneBulk"}}, {F="AutoGoalsRuneLuck",T="UpgradeUpgradeMax",A={"Goals","RuneLuck"}}, {F="AutoBuyAutoKick",T="UpgradeUpgradeMax",A={"Goals","AutoKick"}}
}

task.spawn(function()
    while Running do
        task.wait(1.0)
        if NetRemote and Running then
            for i = 1, #PrimaryUpgradeQueue do
                if not Running then break end local item = PrimaryUpgradeQueue[i]
                if _G[item.F] then pcall(function() NetRemote:FireServer(item.T, unpack(item.A)) end) task.wait(0.25) end
            end
        end
    end
end)

task.spawn(function() while Running do task.wait(0.5) if NetRemote and Running then for i = 1, 11 do if _G["AutoFillBucket" .. i] then pcall(function() NetRemote:FireServer("FillWaterBucket", i) end) task.wait(0.2) end end end end end)

task.spawn(function()
    while Running do
        task.wait(20.0)
        if NetRemote and Running and _G.AutoGemExchange then
            pcall(function() NetRemote:FireServer("ExchangeAllMinerals") end)
            showToast("Successfully exchanged minerals for gems!")
            sendDiscordWebhook("Dominate Hub: Successfully exchanged all minerals for gems!")
        end
    end
end)

task.spawn(function() while Running do task.wait(0.2) if NetRemote and Running and _G.AutoScoreGoal then pcall(function() NetRemote:FireServer("RegisterFootballKick") end) task.wait(1.5) if not Running or not _G.AutoScoreGoal then break end pcall(function() NetRemote:FireServer("ScoreGoal") end) task.wait(1.5) end end end)

task.spawn(function()
    while Running do
        if NetRemote and Running and _G.AutoFootballTree then
            local pGui = player:FindFirstChild("PlayerGui") local treeGui = pGui and pGui:FindFirstChild("FootballUITree")
            if treeGui then
                for _, obj in pairs(treeGui:GetDescendants()) do
                    if not Running or not _G.AutoFootballTree then break end
                    if (obj:IsA("GuiButton") or obj:IsA("Frame")) and obj.Name ~= "Main" and obj.Name ~= "Container" then pcall(function() NetRemote:FireServer("BuyFootballUITreeNode", obj.Name) end) task.wait(0.5) end
                end
            end
        end
        task.wait(5.0)
    end
end)

task.spawn(function() while Running do task.wait(3.0) if NetRemote and Running and _G.AutoClaimTrophies then for i = 1, 10 do if not Running or not _G.AutoClaimTrophies then break end pcall(function() NetRemote:FireServer("BuyTrophy", i) end) task.wait(0.2) end end end end)

local BreadUpgradeList = { {F="AutoBreadMoreWheat",T="UpgradeUpgradeMax",A={"Bread","MoreWheat"}}, {F="AutoBreadMoreBread",T="UpgradeUpgradeMax",A={"Bread","MoreBread"}}, {F="AutoBreadMoreBread2",T="UpgradeUpgradeMax",A={"Bread","MoreBread2"}}, {F="AutoBreadBiggerWheatDeposit",T="UpgradeUpgradeMax",A={"Bread","BiggerWheatDeposit"}}, {F="AutoBreadFasterWheatConversion",T="UpgradeUpgradeMax",A={"Bread","FasterWheatConversion"}}, {F="AutoBreadMoreConsumption",T="UpgradeUpgradeMax",A={"Bread","MoreConsumption"}}, {F="AutoBreadMoreRuneLuck",T="UpgradeUpgradeMax",A={"Bread","MoreRuneLuck"}}, {F="AutoBreadMoreTierLuck",T="UpgradeUpgradeMax",A={"Bread","MoreTierLuck"}}, {F="AutoUpgradeCow",T="UpgradeAnimal",A={"Cow"}}, {F="AutoUpgradeChicken",T="UpgradeAnimal",A={"Chicken"}}, {F="AutoBuyCow",T="BuyAnimal",A={"Cow",true}}, {F="AutoBuyChicken",T="BuyAnimal",A={"Chicken",true}} }
task.spawn(function() local bIdx = 1 while Running do task.wait(1.2) if NetRemote and Running then local att = 0 repeat local cur = BreadUpgradeList[bIdx] bIdx = (bIdx % #BreadUpgradeList) + 1 att = att + 1 if _G[cur.F] then pcall(function() NetRemote:FireServer(cur.T, unpack(cur.A)) end) break end until att >= #BreadUpgradeList end end end)

task.spawn(function() while Running do task.wait(30.0) if NetRemote and Running then if _G.AutoDepositWheat then pcall(function() NetRemote:FireServer("DepositWheat") end) end if _G.AutoDepositWood then pcall(function() NetRemote:FireServer("DepositWood") end) end end end end)
task.spawn(function() while Running do task.wait(1.0) if NetRemote and Running then if _G.AutoBlazeMoreBlaze then pcall(function() NetRemote:FireServer("UpgradeUpgradeMax", "Blaze", "MoreBlaze") end) task.wait(0.25) end if _G.AutoBlazeMoreFire then pcall(function() NetRemote:FireServer("UpgradeUpgradeMax", "Blaze", "MoreFire") end) task.wait(0.25) end if _G.AutoBlazeMoreOof then pcall(function() NetRemote:FireServer("UpgradeUpgradeMax", "Blaze", "MoreOof") end) task.wait(0.25) end if _G.AutoBlazeMoreOofs then pcall(function() NetRemote:FireServer("UpgradeUpgradeMax", "Blaze", "MoreOofs") end) task.wait(0.25) end if _G.AutoBlazeMoreBulk then pcall(function() NetRemote:FireServer("UpgradeUpgradeMax", "Blaze", "MoreBulk") end) task.wait(0.25) end end end end)
task.spawn(function() while Running do task.wait(1.2) if NetRemote and Running then if _G.AutoOpenT1Chest then pcall(function() NetRemote:FireServer("OpenChest", "T1TrialChest", 10) end) end if _G.AutoOpenT2Chest then pcall(function() NetRemote:FireServer("OpenChest", "T2TrialChest", 10) end) end end end end)
task.spawn(function() while Running do task.wait(5.0) if _G.AutoPrestige and NetRemote and Running then pcall(function() NetRemote:FireServer("Prestige") end) end end end)
task.spawn(function() local tc = math.random(270, 330) local se = 0 while Running do task.wait(1) if Running and _G.AutoBlazeConvert and NetRemote then se = se + 1 if se >= tc then se = 0 tc = math.random(270, 330) pcall(function() NetRemote:FireServer("Blaze") end) end else se = 0 end end end)

--======================================================================================
-- CONNECTORS, KILL SWITCH & DRAG CONTROLLER
--======================================================================================
local function tV2(b, v) 
    _G[v] = not _G[v] 
    b.Text = _G[v] and "ACTIVE" or "DISABLED" 
    b.BackgroundColor3 = _G[v] and Color3.fromRGB(20, 60, 20) or Color3.fromRGB(60, 20, 20) 
    b.TextColor3 = _G[v] and Color3.fromRGB(120, 255, 120) or Color3.fromRGB(255, 120, 120) 
    
    local card = b.Parent
    if card and card:IsA("Frame") then
        local dot = card:FindFirstChild("StatusDot")
        if dot then
            dot.BackgroundColor3 = _G[v] and Color3.fromRGB(80, 255, 80) or Color3.fromRGB(255, 80, 80)
        end
    end
    
    saveConfigToSlot(_G.SelectedConfigSlot)
end

UI.Starter.MouseButton1Click:Connect(function() tV2(UI.Starter, "AutoUpgradeStarter") end) UI.Cooker.MouseButton1Click:Connect(function() tV2(UI.Cooker, "AutoUpgradeCooker") end) UI.Farmer.MouseButton1Click:Connect(function() tV2(UI.Farmer, "AutoUpgradeFarmer") end) UI.Magician.MouseButton1Click:Connect(function() tV2(UI.Magician, "AutoUpgradeMagician") end) UI.Archer.MouseButton1Click:Connect(function() tV2(UI.Archer, "AutoUpgradeArcher") end) UI.Soldier.MouseButton1Click:Connect(function() tV2(UI.Soldier, "AutoUpgradeSoldier") end) UI.MoreOof.MouseButton1Click:Connect(function() tV2(UI.MoreOof, "AutoUpgradeMoreOof") end) UI.FasterNoobs.MouseButton1Click:Connect(function() tV2(UI.FasterNoobs, "AutoUpgradeFasterNoobs") end)
UI.RebirthOof.MouseButton1Click:Connect(function() tV2(UI.RebirthOof, "AutoRebirthMoreOof") end) UI.RebirthRebirth.MouseButton1Click:Connect(function() tV2(UI.RebirthRebirth, "AutoRebirthMoreRebirth") end) UI.RebirthFire.MouseButton1Click:Connect(function() tV2(UI.RebirthFire, "AutoRebirthMoreFire") end)
UI.FireFire.MouseButton1Click:Connect(function() tV2(UI.FireFire, "AutoFireMoreFire") end) UI.FireBulk.MouseButton1Click:Connect(function() tV2(UI.FireBulk, "AutoFireMoreBulk") end) UI.FireOof.MouseButton1Click:Connect(function() tV2(UI.FireOof, "AutoFireMoreOof") end) UI.FireRebirth.MouseButton1Click:Connect(function() tV2(UI.FireRebirth, "AutoFireMoreRebirth") end) UI.FireTierLuck.MouseButton1Click:Connect(function() tV2(UI.FireTierLuck, "AutoFireMoreTierLuck") end) UI.FireCashBonus.MouseButton1Click:Connect(function() tV2(UI.FireCashBonus, "AutoFireMoreCashBonus") end)
UI.AutoBlazeConvert.MouseButton1Click:Connect(function() tV2(UI.AutoBlazeConvert, "AutoBlazeConvert") end) UI.BlazeMoreBlaze.MouseButton1Click:Connect(function() tV2(UI.BlazeMoreBlaze, "AutoBlazeMoreBlaze") end) UI.BlazeMoreFire.MouseButton1Click:Connect(function() tV2(UI.BlazeMoreFire, "AutoBlazeMoreFire") end) UI.BlazeMoreOof.MouseButton1Click:Connect(function() tV2(UI.BlazeMoreOof, "AutoBlazeMoreOof") end) UI.BlazeMoreOofs.MouseButton1Click:Connect(function() tV2(UI.BlazeMoreOofs, "AutoBlazeMoreOofs") end) UI.BlazeMoreBulk.MouseButton1Click:Connect(function() tV2(UI.BlazeMoreBulk, "AutoBlazeMoreBulk") end)
UI.DepositWheat.MouseButton1Click:Connect(function() tV2(UI.DepositWheat, "AutoDepositWheat") end) UI.BreadMoreBread.MouseButton1Click:Connect(function() tV2(UI.BreadMoreBread, "AutoBreadMoreBread") end) UI.BreadMoreBread2.MouseButton1Click:Connect(function() tV2(UI.BreadMoreBread2, "AutoBreadMoreBread2") end) UI.BreadMoreWheat.MouseButton1Click:Connect(function() tV2(UI.BreadMoreWheat, "AutoBreadMoreWheat") end) UI.BreadBiggerWheatDeposit.MouseButton1Click:Connect(function() tV2(UI.BreadBiggerWheatDeposit, "AutoBreadBiggerWheatDeposit") end) UI.BreadFasterWheatConversion.MouseButton1Click:Connect(function() tV2(UI.BreadFasterWheatConversion, "AutoBreadFasterWheatConversion") end) UI.BreadMoreConsumption.MouseButton1Click:Connect(function() tV2(UI.BreadMoreConsumption, "AutoBreadMoreConsumption") end) UI.BreadMoreRuneLuck.MouseButton1Click:Connect(function() tV2(UI.BreadMoreRuneLuck, "AutoBreadMoreRuneLuck") end) UI.BreadMoreTierLuck.MouseButton1Click:Connect(function() tV2(UI.BreadMoreTierLuck, "AutoBreadMoreTierLuck") end) UI.UpgradeCow.MouseButton1Click:Connect(function() tV2(UI.UpgradeCow, "AutoUpgradeCow") end) UI.UpgradeChicken.MouseButton1Click:Connect(function() tV2(UI.UpgradeChicken, "AutoUpgradeChicken") end) UI.BuyCow.MouseButton1Click:Connect(function() tV2(UI.BuyCow, "AutoBuyCow") end) UI.BuyChicken.MouseButton1Click:Connect(function() tV2(UI.BuyChicken, "AutoBuyChicken") end)
UI.AutoFarmCash.MouseButton1Click:Connect(function() tV2(UI.AutoFarmCash, "AutoFarmCash") end) UI.CashMoreCash.MouseButton1Click:Connect(function() tV2(UI.CashMoreCash, "AutoUpgradeMoreCash") end) UI.CashFasterDropper.MouseButton1Click:Connect(function() tV2(UI.CashFasterDropper, "AutoUpgradeFasterDropper") end) UI.CashMoreRuneLuck.MouseButton1Click:Connect(function() tV2(UI.CashMoreRuneLuck, "AutoUpgradeMoreRuneLuck") end)

UI.R2Fisherman.MouseButton1Click:Connect(function() tV2(UI.R2Fisherman, "AutoUpgradeFishermanNoob") end) UI.R2Knight.MouseButton1Click:Connect(function() tV2(UI.R2Knight, "AutoUpgradeKnightNoob") end) UI.R2Explorer.MouseButton1Click:Connect(function() tV2(UI.R2Explorer, "AutoUpgradeExplorerNoob") end) UI.R2Magician.MouseButton1Click:Connect(function() tV2(UI.R2Magician, "AutoUpgradeMagicianNoob") end)
UI.R2MoreOof.MouseButton1Click:Connect(function() tV2(UI.R2MoreOof, "AutoRealm2MoreOof") end) UI.R2WalkSpeed.MouseButton1Click:Connect(function() tV2(UI.R2WalkSpeed, "AutoRealm2MoreWalkSpeed") end) UI.R2MoreWater.MouseButton1Click:Connect(function() tV2(UI.R2MoreWater, "AutoRealm2MoreWater") end) UI.R2WaterOof.MouseButton1Click:Connect(function() tV2(UI.R2WaterOof, "AutoRealm2MoreOofWater") end) UI.R2Planks.MouseButton1Click:Connect(function() tV2(UI.R2Planks, "AutoRealm2MorePlanks") end) UI.R2MoreIce.MouseButton1Click:Connect(function() tV2(UI.R2MoreIce, "AutoRealm2MoreIce") end) UI.R2WaterPump1.MouseButton1Click:Connect(function() tV2(UI.R2WaterPump1, "AutoRealm2WaterPump1") end) UI.R2WaterPump2.MouseButton1Click:Connect(function() tV2(UI.R2WaterPump2, "AutoRealm2WaterPump2") end) UI.R2IceOof.MouseButton1Click:Connect(function() tV2(UI.R2IceOof, "AutoRealm2MoreOofIce") end)
UI.Bucket1.MouseButton1Click:Connect(function() tV2(UI.Bucket1, "AutoFillBucket1") end) UI.Bucket2.MouseButton1Click:Connect(function() tV2(UI.Bucket2, "AutoFillBucket2") end) UI.Bucket3.MouseButton1Click:Connect(function() tV2(UI.Bucket3, "AutoFillBucket3") end) UI.Bucket4.MouseButton1Click:Connect(function() tV2(UI.Bucket4, "AutoFillBucket4") end) UI.Bucket5.MouseButton1Click:Connect(function() tV2(UI.Bucket5, "AutoFillBucket5") end) UI.Bucket6.MouseButton1Click:Connect(function() tV2(UI.Bucket6, "AutoFillBucket6") end) UI.Bucket7.MouseButton1Click:Connect(function() tV2(UI.Bucket7, "AutoFillBucket7") end) UI.Bucket8.MouseButton1Click:Connect(function() tV2(UI.Bucket8, "AutoFillBucket8") end) UI.Bucket9.MouseButton1Click:Connect(function() tV2(UI.Bucket9, "AutoFillBucket9") end) UI.Bucket10.MouseButton1Click:Connect(function() tV2(UI.Bucket10, "AutoFillBucket10") end) UI.Bucket11.MouseButton1Click:Connect(function() tV2(UI.Bucket11, "AutoFillBucket11") end)
UI.WoodRankUp.MouseButton1Click:Connect(function() tV2(UI.WoodRankUp, "AutoWoodRankUp") end) UI.WoodMoreWood.MouseButton1Click:Connect(function() tV2(UI.WoodMoreWood, "AutoWoodMoreWood") end) UI.WoodSharperAxes.MouseButton1Click:Connect(function() tV2(UI.WoodSharperAxes, "AutoWoodSharperAxes") end) UI.WoodBiggerDeposit.MouseButton1Click:Connect(function() tV2(UI.WoodBiggerDeposit, "AutoWoodBiggerDeposit") end) UI.WoodFasterConversion.MouseButton1Click:Connect(function() tV2(UI.WoodFasterConversion, "AutoWoodFasterConversion") end) UI.WoodMorePlanks.MouseButton1Click:Connect(function() tV2(UI.WoodMorePlanks, "AutoWoodMorePlanks") end) UI.DepositWood.MouseButton1Click:Connect(function() tV2(UI.DepositWood, "AutoDepositWood") end)
UI.PlanksMorePlanks.MouseButton1Click:Connect(function() tV2(UI.PlanksMorePlanks, "AutoPlanksMorePlanks") end) UI.PlanksMoreWood.MouseButton1Click:Connect(function() tV2(UI.PlanksMoreWood, "AutoPlanksMoreWood") end) UI.PlanksWaterFromPlanks.MouseButton1Click:Connect(function() tV2(UI.PlanksWaterFromPlanks, "AutoPlanksWaterFromPlanks") end)
UI.GemMoreOof.MouseButton1Click:Connect(function() tV2(UI.GemMoreOof, "AutoGemMoreOof") end) UI.GemMoreGems.MouseButton1Click:Connect(function() tV2(UI.GemMoreGems, "AutoGemMoreGems") end) UI.GemStrongerPickaxes.MouseButton1Click:Connect(function() tV2(UI.GemStrongerPickaxes, "AutoGemStrongerPickaxes") end) UI.GemMoreOreStats.MouseButton1Click:Connect(function() tV2(UI.GemMoreOreStats, "AutoGemMoreOreStats") end) UI.GemExchange.MouseButton1Click:Connect(function() tV2(UI.GemExchange, "AutoGemExchange") end)

local ms = {0.3, 0.5, 0.8, 1.2, 2.0} local ml = {"0.3 Studs/s", "0.5 Studs/s", "0.8 Studs/s", "1.2 Studs/s", "2.0 Studs/s"} local mi = 3
UI.MiningSpeedSwitch.MouseButton1Click:Connect(function() mi = mi + 1 if mi > #ms then mi = 1 end _G.MiningJumpSpeed = ms[mi] UI.MiningSpeedSwitch.Text = ml[mi] saveConfigToSlot(_G.SelectedConfigSlot) end)
UI.MineStone.MouseButton1Click:Connect(function() tV2(UI.MineStone, "AutoMineStone") end) UI.MineCoal.MouseButton1Click:Connect(function() tV2(UI.MineCoal, "AutoMineCoal") end) UI.MineSilver.MouseButton1Click:Connect(function() tV2(UI.MineSilver, "AutoMineSilver") end) UI.MineIron.MouseButton1Click:Connect(function() tV2(UI.MineIron, "AutoMineIron") end) UI.MineCopper.MouseButton1Click:Connect(function() tV2(UI.MineCopper, "AutoMineCopper") end) UI.MineGold.MouseButton1Click:Connect(function() tV2(UI.MineGold, "AutoMineGold") end) UI.MinePlatinum.MouseButton1Click:Connect(function() tV2(UI.MinePlatinum, "AutoMinePlatinum") end) UI.MineTitanium.MouseButton1Click:Connect(function() tV2(UI.MineTitanium, "AutoMineTitanium") end) UI.MineCobalt.MouseButton1Click:Connect(function() tV2(UI.MineCobalt, "AutoMineCobalt") end) UI.MineUranium.MouseButton1Click:Connect(function() tV2(UI.MineUranium, "AutoMineUranium") end) UI.MinePalladium.MouseButton1Click:Connect(function() tV2(UI.MinePalladium, "AutoMinePalladium") end) UI.MineAetherite.MouseButton1Click:Connect(function() tV2(UI.MineAetherite, "AutoMineAetherite") end) UI.MineRuby.MouseButton1Click:Connect(function() tV2(UI.MineRuby, "AutoMineRuby") end) UI.MineVoidsteel.MouseButton1Click:Connect(function() tV2(UI.MineVoidsteel, "AutoMineVoidsteel") end) UI.MineCelestium.MouseButton1Click:Connect(function() tV2(UI.MineCelestium, "AutoMineCelestium") end)

UI.Hacker1.MouseButton1Click:Connect(function() tV2(UI.Hacker1, "AutoUpgradeHacker1") end) UI.Hacker2.MouseButton1Click:Connect(function() tV2(UI.Hacker2, "AutoUpgradeHacker2") end) UI.Hacker3.MouseButton1Click:Connect(function() tV2(UI.Hacker3, "AutoUpgradeHacker3") end) UI.Hacker4.MouseButton1Click:Connect(function() tV2(UI.Hacker4, "AutoUpgradeHacker4") end)
UI.Pharaoh.MouseButton1Click:Connect(function() tV2(UI.Pharaoh, "AutoUpgradePharaoh") end)
UI.Goalkeeper.MouseButton1Click:Connect(function() tV2(UI.Goalkeeper, "AutoUpgradeGoalkeeper") end) UI.LeftBack.MouseButton1Click:Connect(function() tV2(UI.LeftBack, "AutoUpgradeLeftBack") end) UI.LeftCenterBack.MouseButton1Click:Connect(function() tV2(UI.LeftCenterBack, "AutoUpgradeLeftCenterBack") end) UI.RightCenterBack.MouseButton1Click:Connect(function() tV2(UI.RightCenterBack, "AutoUpgradeRightCenterBack") end) UI.RightBack.MouseButton1Click:Connect(function() tV2(UI.RightBack, "AutoUpgradeRightBack") end) UI.LeftDefensiveMid.MouseButton1Click:Connect(function() tV2(UI.LeftDefensiveMid, "AutoUpgradeLeftDefensiveMid") end) UI.RightDefensiveMid.MouseButton1Click:Connect(function() tV2(UI.RightDefensiveMid, "AutoUpgradeRightDefensiveMid") end) UI.AttackingMid.MouseButton1Click:Connect(function() tV2(UI.AttackingMid, "AutoUpgradeAttackingMid") end) UI.LeftWing.MouseButton1Click:Connect(function() tV2(UI.LeftWing, "AutoUpgradeLeftWing") end) UI.RightWing.MouseButton1Click:Connect(function() tV2(UI.RightWing, "AutoUpgradeRightWing") end) UI.Striker.MouseButton1Click:Connect(function() tV2(UI.Striker, "AutoUpgradeStriker") end)
UI.ScoreGoal.MouseButton1Click:Connect(function() tV2(UI.ScoreGoal, "AutoScoreGoal") end) UI.MoreGoals.MouseButton1Click:Connect(function() tV2(UI.MoreGoals, "AutoGoalsMoreGoals") end) UI.GoalsRuneBulk.MouseButton1Click:Connect(function() tV2(UI.GoalsRuneBulk, "AutoGoalsRuneBulk") end) UI.GoalsRuneLuck.MouseButton1Click:Connect(function() tV2(UI.GoalsRuneLuck, "AutoGoalsRuneLuck") end) UI.AutoBuyKicker.MouseButton1Click:Connect(function() tV2(UI.AutoBuyKicker, "AutoBuyAutoKick") end) UI.FootballTree.MouseButton1Click:Connect(function() tV2(UI.FootballTree, "AutoFootballTree") end) UI.ClaimTrophies.MouseButton1Click:Connect(function() tV2(UI.ClaimTrophies, "AutoClaimTrophies") end)
UI.RollBasicRuneCard.MouseButton1Click:Connect(function() tV2(UI.RollBasicRuneCard, "AutoRollBasicRune") end) UI.RollSuperRuneCard.MouseButton1Click:Connect(function() tV2(UI.RollSuperRuneCard, "AutoRollSuperRune") end) UI.RollAdvancedRuneCard.MouseButton1Click:Connect(function() tV2(UI.RollAdvancedRuneCard, "AutoRollAdvancedRune") end) UI.RollCosmicRuneCard.MouseButton1Click:Connect(function() tV2(UI.RollCosmicRuneCard, "AutoRollCosmicRune") end) UI.RollSnowyRuneCard.MouseButton1Click:Connect(function() tV2(UI.RollSnowyRuneCard, "AutoRollSnowyRune") end) UI.FootballRuneCard.MouseButton1Click:Connect(function() tV2(UI.FootballRuneCard, "AutoRollFootballRune") end)
UI.ClassicCapsule.MouseButton1Click:Connect(function() tV2(UI.ClassicCapsule, "AutoOpenClassicCapsule") end) UI.FootballCapsule.MouseButton1Click:Connect(function() tV2(UI.FootballCapsule, "AutoOpenFootballCapsule") end) UI.SuperCapsule.MouseButton1Click:Connect(function() tV2(UI.SuperCapsule, "AutoOpenSuperCapsule") end)
UI.EnchantStarter.MouseButton1Click:Connect(function() tV2(UI.EnchantStarter, "AutoEnchantStarter") end) UI.EnchantCooker.MouseButton1Click:Connect(function() tV2(UI.EnchantCooker, "AutoEnchantCooker") end) UI.EnchantFarmer.MouseButton1Click:Connect(function() tV2(UI.EnchantFarmer, "AutoEnchantFarmer") end) UI.EnchantMagician.MouseButton1Click:Connect(function() tV2(UI.EnchantMagician, "AutoEnchantMagician") end) UI.EnchantArcher.MouseButton1Click:Connect(function() tV2(UI.EnchantArcher, "AutoEnchantArcher") end) UI.EnchantSoldier.MouseButton1Click:Connect(function() tV2(UI.EnchantSoldier, "AutoEnchantSoldier") end) UI.EnchantHacker1.MouseButton1Click:Connect(function() tV2(UI.EnchantHacker1, "AutoEnchantHacker1") end) UI.EnchantHacker2.MouseButton1Click:Connect(function() tV2(UI.EnchantHacker2, "AutoEnchantHacker2") end) UI.EnchantHacker3.MouseButton1Click:Connect(function() tV2(UI.EnchantHacker3, "AutoEnchantHacker3") end) UI.EnchantHacker4.MouseButton1Click:Connect(function() tV2(UI.EnchantHacker4, "AutoEnchantHacker4") end) UI.EnchantPharaoh.MouseButton1Click:Connect(function() tV2(UI.EnchantPharaoh, "AutoEnchantPharaoh") end)
UI.OpenT1ChestCard.MouseButton1Click:Connect(function() tV2(UI.OpenT1ChestCard, "AutoOpenT1Chest") end) UI.OpenT2ChestCard.MouseButton1Click:Connect(function() tV2(UI.OpenT2ChestCard, "AutoOpenT2Chest") end) UI.AFK.MouseButton1Click:Connect(function() tV2(UI.AFK, "AntiAFK") end) UI.Prestige.MouseButton1Click:Connect(function() tV2(UI.Prestige, "AutoPrestige") end) UI.RebirthTimerCard.MouseButton1Click:Connect(function() tV2(UI.RebirthTimerCard, "AutoRebirthTimer") end) 

UI.KillSwitch.MouseButton1Click:Connect(function()
    Running = false getgenv().DominateHubLoaded = nil 
    for k, _ in pairs(_G) do if type(k) == "string" and (k:sub(1,4) == "Auto" or k == "AntiAFK") then _G[k] = false end end
    pcall(function() 
        local cam = workspace.CurrentCamera if cam then cam.CameraType = Enum.CameraType.Custom end 
        local blur = Lighting:FindFirstChild("DominateHubBlur")
        if blur then blur:Destroy() end
    end) 
    sg:Destroy()
end)

-- TAB ROUTERS
local function mainRoute(pOpen, bActive) 
    realm1MasterPage.Visible, realm2Page.Visible, realm3Page.Visible, footballPage.Visible, runesPage.Visible, capsulesPage.Visible, enchantsPage.Visible, settingsPage.Visible = false, false, false, false, false, false, false, false; pOpen.Visible = true; 
    local tabs = {tabRealm1, tabRealm2, tabRealm3, tabFootball, tabRunes, tabCapsules, tabEnchants, tabSettings}
    for _, t in ipairs(tabs) do t.BackgroundColor3, t.TextColor3 = Color3.fromRGB(55, 55, 65), Color3.fromRGB(210, 210, 220) end
    bActive.BackgroundColor3, bActive.TextColor3 = Color3.fromRGB(240, 240, 245), Color3.fromRGB(15, 15, 15) 
end
tabRealm1.MouseButton1Click:Connect(function() mainRoute(realm1MasterPage, tabRealm1) end) tabRealm2.MouseButton1Click:Connect(function() mainRoute(realm2Page, tabRealm2) end) tabRealm3.MouseButton1Click:Connect(function() mainRoute(realm3Page, tabRealm3) end) tabFootball.MouseButton1Click:Connect(function() mainRoute(footballPage, tabFootball) end) tabRunes.MouseButton1Click:Connect(function() mainRoute(runesPage, tabRunes) end) tabCapsules.MouseButton1Click:Connect(function() mainRoute(capsulesPage, tabCapsules) end) tabEnchants.MouseButton1Click:Connect(function() mainRoute(enchantsPage, tabEnchants) end) tabSettings.MouseButton1Click:Connect(function() mainRoute(settingsPage, tabSettings) end)

local function sideRoute(tScroll, aBtn, aScrolls, aBtns)
    for i, s in ipairs(aScrolls) do s.Visible = (s == tScroll) end
    for i, b in ipairs(aBtns) do b.BackgroundColor3 = (b == aBtn) and Color3.fromRGB(240, 240, 245) or Color3.fromRGB(55, 55, 65) b.TextColor3 = (b == aBtn) and Color3.fromRGB(15, 15, 15) or Color3.fromRGB(210, 210, 220) end
end

local r1S, r1B = {r1NoobScroll, r1OofScroll, r1RebirthScroll, r1FireScroll, r1BlazeScroll, r1BreadScroll, r1CashScroll, r1HackerScroll}, {b1Noobs, b1Oof, b1Rebirth, b1Fire, b1Blaze, b1Farm, b1Cash, b1Hacker}
b1Noobs.MouseButton1Click:Connect(function() sideRoute(r1NoobScroll, b1Noobs, r1S, r1B) end) b1Oof.MouseButton1Click:Connect(function() sideRoute(r1OofScroll, b1Oof, r1S, r1B) end) b1Rebirth.MouseButton1Click:Connect(function() sideRoute(r1RebirthScroll, b1Rebirth, r1S, r1B) end) b1Fire.MouseButton1Click:Connect(function() sideRoute(r1FireScroll, b1Fire, r1S, r1B) end) b1Blaze.MouseButton1Click:Connect(function() sideRoute(r1BlazeScroll, b1Blaze, r1S, r1B) end) b1Farm.MouseButton1Click:Connect(function() sideRoute(r1BreadScroll, b1Farm, r1S, r1B) end) b1Cash.MouseButton1Click:Connect(function() sideRoute(r1CashScroll, b1Cash, r1S, r1B) end) b1Hacker.MouseButton1Click:Connect(function() sideRoute(r1HackerScroll, b1Hacker, r1S, r1B) end)

local r2S, r2B = {r2NoobScroll, r2OofScroll, r2WaterScroll, r2IceScroll, r2BucketScroll, r2WoodScroll, r2PlanksScroll, r2GemsScroll, r2MiningScroll}, {b2Noobs, b2Oof, b2Water, b2Ice, b2Buckets, b2Wood, b2Planks, b2Gems, b2Mine}
b2Noobs.MouseButton1Click:Connect(function() sideRoute(r2NoobScroll, b2Noobs, r2S, r2B) end) b2Oof.MouseButton1Click:Connect(function() sideRoute(r2OofScroll, b2Oof, r2S, r2B) end) b2Water.MouseButton1Click:Connect(function() sideRoute(r2WaterScroll, b2Water, r2S, r2B) end) b2Ice.MouseButton1Click:Connect(function() sideRoute(r2IceScroll, b2Ice, r2S, r2B) end) b2Buckets.MouseButton1Click:Connect(function() sideRoute(r2BucketScroll, b2Buckets, r2S, r2B) end) b2Wood.MouseButton1Click:Connect(function() sideRoute(r2WoodScroll, b2Wood, r2S, r2B) end) b2Planks.MouseButton1Click:Connect(function() sideRoute(r2PlanksScroll, b2Planks, r2S, r2B) end) b2Gems.MouseButton1Click:Connect(function() sideRoute(r2GemsScroll, b2Gems, r2S, r2B) end) b2Mine.MouseButton1Click:Connect(function() sideRoute(r2MiningScroll, b2Mine, r2S, r2B) end)

local fS, fB = {fNoobScroll, fUpgradeScroll}, {bFNoobs, bFUpgrades}
bFNoobs.MouseButton1Click:Connect(function() sideRoute(fNoobScroll, bFNoobs, fS, fB) end) bFUpgrades.MouseButton1Click:Connect(function() sideRoute(fUpgradeScroll, bFUpgrades, fS, fB) end)

local ruS, ruB = {ruScroll1, ruScroll2, ruScroll3, ruScrollE}, {bRu1, bRu2, bRu3, bRuE}
bRu1.MouseButton1Click:Connect(function() sideRoute(ruScroll1, bRu1, ruS, ruB) end) bRu2.MouseButton1Click:Connect(function() sideRoute(ruScroll2, bRu2, ruS, ruB) end) bRu3.MouseButton1Click:Connect(function() sideRoute(ruScroll3, bRu3, ruS, ruB) end) bRuE.MouseButton1Click:Connect(function() sideRoute(ruScrollE, bRuE, ruS, ruB) end)

-- SETTINGS SUB-TAB ROUTER (General / Config)
local setS, setB = {setGenScroll, setConfigScroll}, {bSetGen, bSetConfig}
bSetGen.MouseButton1Click:Connect(function() sideRoute(setGenScroll, bSetGen, setS, setB) end)
bSetConfig.MouseButton1Click:Connect(function() sideRoute(setConfigScroll, bSetConfig, setS, setB) end)

local dragging, dragInput, dragStart, startPos
mainFrame.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true dragStart = input.Position startPos = mainFrame.Position input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) end end)
mainFrame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then local delta = input.Position - dragStart mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)

print("[Dominate Hub] V7.1 Pro Edition - Frosted Glass & Card Modules Deployed!")
