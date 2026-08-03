--======================================================================================
-- DOMINATE HUB | V10.1 PRO EDITION (BULLETPROOF CONNECTIONS & ERROR-FREE TOGGLES)
--======================================================================================
if getgenv().DominateHubLoaded then 
    pcall(function()
        local parentTarget = (gethui and gethui()) or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
        local oldUI = parentTarget:FindFirstChild("DominateHubMirror")
        if oldUI then oldUI:Destroy() end
        local oldBlur = Lighting:FindFirstChild("DominateHubBlur")
        if oldBlur then oldBlur:Destroy() end
    end)
    print("[Dominate Hub] Reloading V10.1 Instance...")
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

-- MASTER UI ELEMENTS TABLE
local UI = {}

-- ADD SUBTLE FROSTED BLUR EFFECT TO LIGHTING
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

local function saveConfigToSlot(slot, customName)
    if customName then slotCustomNames[slot] = customName end
    local configData = { _SlotCustomName = slotCustomNames[slot] }
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
            if data._SlotCustomName then
                slotCustomNames[slot] = data._SlotCustomName
            end
            for k, v in pairs(data) do
                if k ~= "_SlotCustomName" then
                    _G[k] = v
                end
            end
        end
    end)
end
loadConfigFromSlot(1)

_G.AntiAFK, _G.AutoPrestige, _G.CPUSaverMode = true, false, false

-- ALL AUTOMATION FLAGS
_G.AutoUpgradeStarter, _G.AutoUpgradeCooker, _G.AutoUpgradeFarmer, _G.AutoUpgradeMagician, _G.AutoUpgradeArcher, _G.AutoUpgradeSoldier, _G.AutoUpgradeMoreOof, _G.AutoUpgradeFasterNoobs = false, false, false, false, false, false, false, false
_G.AutoRebirthMoreOof, _G.AutoRebirthMoreRebirth, _G.AutoRebirthMoreFire = false, false, false
_G.AutoFireMoreFire, _G.AutoFireMoreBulk, _G.AutoFireMoreOof, _G.AutoFireMoreRebirth, _G.AutoFireMoreTierLuck, _G.AutoFireMoreCashBonus = false, false, false, false, false, false
_G.AutoRebirthTimer = false
_G.AutoBlazeMoreBlaze, _G.AutoBlazeMoreFire, _G.AutoBlazeMoreOof, _G.AutoBlazeMoreOofs, _G.AutoBlazeMoreBulk, _G.AutoBlazeConvert = false, false, false, false, false, false
_G.AutoUpgradePharaoh = false

_G.AutoUpgradeFishermanNoob = false
_G.AutoUpgradeKnightNoob = false
_G.AutoUpgradeExplorerNoob = false
_G.AutoUpgradeMagicianNoob = false
_G.AutoRealm2MoreWalkSpeed = false
_G.AutoRealm2MoreWater, _G.AutoRealm2MoreOofWater, _G.AutoRealm2MorePlanks = false, false, false
_G.AutoRealm2MoreIce, _G.AutoRealm2WaterPump1, _G.AutoRealm2WaterPump2, _G.AutoRealm2MoreOofIce = false, false, false, false
_G.AutoFillBucket1, _G.AutoFillBucket2, _G.AutoFillBucket3, _G.AutoFillBucket4, _G.AutoFillBucket5 = false, false, false, false, false
_G.AutoFillBucket6, _G.AutoFillBucket7, _G.AutoFillBucket8, _G.AutoFillBucket9, _G.AutoFillBucket10, _G.AutoFillBucket11 = false, false, false, false, false, false

_G.AutoWoodRankUp, _G.AutoWoodMoreWood, _G.AutoWoodSharperAxes, _G.AutoWoodBiggerDeposit = false, false, false, false
_G.AutoWoodFasterConversion, _G.AutoWoodMorePlanks = false, false
_G.AutoDepositWood = false
_G.AutoPlanksMorePlanks, _G.AutoPlanksMoreWood, _G.AutoPlanksWaterFromPlanks = false, false, false

_G.AutoGemMoreOof, _G.AutoGemMoreGems, _G.AutoGemStrongerPickaxes, _G.AutoGemMoreOreStats, _G.AutoGemExchange = false, false, false, false, false
_G.AutoMineStone, _G.AutoMineCoal, _G.AutoMineSilver, _G.AutoMineIron, _G.AutoMineCopper = false, false, false, false, false
_G.AutoMineGold, _G.AutoMinePlatinum, _G.AutoMineTitanium, _G.AutoMineCobalt, _G.AutoMineUranium = false, false, false, false, false
_G.AutoMinePalladium, _G.AutoMineAetherite, _G.AutoMineRuby, _G.AutoMineVoidsteel, _G.AutoMineCelestium = false, false, false, false, false
_G.MiningJumpSpeed = 0.8 

_G.AutoUpgradeHacker1, _G.AutoUpgradeHacker2, _G.AutoUpgradeHacker3, _G.AutoUpgradeHacker4 = false, false, false, false

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

-- UI MASTER ALLOCATION (Compact Height: 350)
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

local headerTitle = Instance.new("TextLabel") headerTitle.Size = UDim2.new(0.5, 0, 0, 30) headerTitle.Position = UDim2.new(0, 12, 0, 4) headerTitle.BackgroundTransparency = 1; headerTitle.TextColor3 = Color3.fromRGB(245, 245, 250) headerTitle.TextSize = 15; headerTitle.Font = Enum.Font.SourceSansBold; headerTitle.Text = "Dominate Hub | V10.1 Pro" headerTitle.TextXAlignment = Enum.TextXAlignment.Left; headerTitle.Parent = mainFrame

-- FLOATING PILL (ERROR-FREE TOGGLE)
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
    mainFrame.Visible = not mainFrame.Visible
    minBtn.TextColor3 = mainFrame.Visible and Color3.fromRGB(0, 136, 255) or Color3.fromRGB(0, 215, 110)
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

-- PAGE CONTAINERS (Compact Height: -72)
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

-- MORE COMPACT GRID ROW
local function gridRow(txt, scr)
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
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 5) Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4) return b
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
            if not _G[flag] then activeState = true break end
        end
        for _, flag in ipairs(flagsTable) do
            _G[flag] = activeState
        end
        b.Text = activeState and "ACTIVE" or "DISABLED"
        b.BackgroundColor3 = activeState and Color3.fromRGB(20, 60, 20) or Color3.fromRGB(60, 20, 20)
        b.TextColor3 = activeState and Color3.fromRGB(120, 255, 120) or Color3.fromRGB(255, 120, 120)
        dot.BackgroundColor3 = activeState and Color3.fromRGB(80, 255, 80) or Color3.fromRGB(255, 80, 80)
        saveConfigToSlot(_G.SelectedConfigSlot)
    end)
    return b
end

masterToggle("Fire Upgrades", {"AutoFireMoreFire", "AutoFireMoreBulk", "AutoFireMoreOof", "AutoFireMoreRebirth", "AutoFireMoreTierLuck", "AutoFireMoreCashBonus"}, upScrollR1)
masterToggle("Rebirth Upgrades", {"AutoRebirthMoreOof", "AutoRebirthMoreRebirth", "AutoRebirthMoreFire"}, upScrollR1)
masterToggle("Blaze Upgrades", {"AutoBlazeConvert", "AutoBlazeMoreBlaze", "AutoBlazeMoreFire", "AutoBlazeMoreOof", "AutoBlazeMoreOofs", "AutoBlazeMoreBulk"}, upScrollR1)
masterToggle("Bread Upgrades", {"AutoDepositWheat", "AutoBreadMoreBread", "AutoBreadMoreBread2", "AutoBreadMoreWheat", "AutoBreadBiggerWheatDeposit", "AutoBreadFasterWheatConversion", "AutoBreadMoreConsumption", "AutoBreadMoreRuneLuck", "AutoBreadMoreTierLuck", "AutoUpgradeCow", "AutoUpgradeChicken", "AutoBuyCow", "AutoBuyChicken"}, upScrollR1)
masterToggle("Cash Upgrades", {"AutoFarmCash", "AutoUpgradeMoreCash", "AutoUpgradeFasterDropper", "AutoUpgradeMoreRuneLuck"}, upScrollR1)
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

UI.Starter = gridRow("Starter Auto Upgrade", noobScrollR1) 
UI.Cooker = gridRow("Cooker Auto Upgrade", noobScrollR1) 
UI.Farmer = gridRow("Farmer Auto Upgrade", noobScrollR1) 
UI.Magician = gridRow("Magician Auto Upgrade", noobScrollR1) 
UI.Archer = gridRow("Archer Auto Upgrade", noobScrollR1) 
UI.Soldier = gridRow("Soldier Auto Upgrade", noobScrollR1)
UI.MoreOof = gridRow("More Oof Auto Upgrade", noobScrollR1) 
UI.FasterNoobs = gridRow("Faster Noobs Upgrade", noobScrollR1)

UI.R2Fisherman = gridRow("Auto Upgrade Fisherman", noobScrollR2) 
UI.R2Knight = gridRow("Auto Upgrade Knight", noobScrollR2) 
UI.R2Explorer = gridRow("Auto Upgrade Explorer", noobScrollR2) 
UI.R2Magician = gridRow("Auto Upgrade Magician", noobScrollR2)

-- ======================================================================================
-- MINES PAGE (BEST TIER ONLY TOGGLE & ORES)
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
        _G[ore] = false
    end
    
    if bestTierActive then
        for _, ore in ipairs(topOres) do
            _G[ore] = true
        end
    end
    
    for _, oreName in ipairs(allOres) do
        local btn = UI[oreName]
        if btn then
            local isActive = _G[oreName]
            btn.Text = isActive and "ACTIVE" or "DISABLED"
            btn.BackgroundColor3 = isActive and Color3.fromRGB(20, 60, 20) or Color3.fromRGB(60, 20, 20)
            btn.TextColor3 = isActive and Color3.fromRGB(120, 255, 120) or Color3.fromRGB(255, 120, 120)
            local dot = btn.Parent:FindFirstChild("StatusDot")
            if dot then dot.BackgroundColor3 = isActive and Color3.fromRGB(80, 255, 80) or Color3.fromRGB(255, 80, 80) end
        end
    end
    saveConfigToSlot(_G.SelectedConfigSlot)
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

    b.MouseButton1Click:Connect(function()
        _G[vKey] = not _G[vKey]
        b.Text = _G[vKey] and "ACTIVE" or "DISABLED"
        b.BackgroundColor3 = _G[vKey] and Color3.fromRGB(20, 60, 20) or Color3.fromRGB(60, 20, 20)
        b.TextColor3 = _G[vKey] and Color3.fromRGB(120, 255, 120) or Color3.fromRGB(255, 120, 120)
        dot.BackgroundColor3 = _G[vKey] and Color3.fromRGB(80, 255, 80) or Color3.fromRGB(255, 80, 80)
        saveConfigToSlot(_G.SelectedConfigSlot)
    end)
    return b
end

mineSectionHeader("Basic Ores", minesScroll)
sleekMineRow("Stone", minesScroll, "AutoMineStone")
sleekMineRow("Coal", minesScroll, "AutoMineCoal")
sleekMineRow("Silver", minesScroll, "AutoMineSilver")
sleekMineRow("Iron", minesScroll, "AutoMineIron")
sleekMineRow("Copper", minesScroll, "AutoMineCopper")

mineSectionHeader("Advanced Ores", minesScroll)
sleekMineRow("Gold", minesScroll, "AutoMineGold")
sleekMineRow("Platinum", minesScroll, "AutoMinePlatinum")
sleekMineRow("Titanium", minesScroll, "AutoMineTitanium")
sleekMineRow("Cobalt", minesScroll, "AutoMineCobalt")
sleekMineRow("Uranium", minesScroll, "AutoMineUranium")

mineSectionHeader("End-Game Ores", minesScroll)
sleekMineRow("Palladium", minesScroll, "AutoMinePalladium")
sleekMineRow("Aetherite", minesScroll, "AutoMineAetherite")
sleekMineRow("Ruby", minesScroll, "AutoMineRuby")
sleekMineRow("Voidsteel", minesScroll, "AutoMineVoidsteel")
sleekMineRow("Celestium", minesScroll, "AutoMineCelestium")

-- ======================================================================================
-- FOOTBALL PAGE
-- ======================================================================================
local fSidebar = makeSidebar(footballPage)
local bFNoobs = makeSideBtn("Noobs", fSidebar) bFNoobs.BackgroundColor3 = Color3.fromRGB(240, 240, 245) bFNoobs.TextColor3 = Color3.fromRGB(15, 15, 15)
local bFUpgrades = makeSideBtn("Upgrades", fSidebar)
local fNoobScroll = makeGridScroll(footballPage, true) fNoobScroll.Visible = true
local fUpgradeScroll = makeGridScroll(footballPage, true)

UI.Goalkeeper = gridRow("Upgrade Goalkeeper", fNoobScroll) 
UI.LeftBack = gridRow("Upgrade Left Back", fNoobScroll) 
UI.LeftCenterBack = gridRow("Upgrade L-Center Back", fNoobScroll) 
UI.RightCenterBack = gridRow("Upgrade R-Center Back", fNoobScroll) 
UI.RightBack = gridRow("Upgrade Right Back", fNoobScroll) 
UI.LeftDefensiveMid = gridRow("Upgrade L-Defensive Mid", fNoobScroll) 
UI.RightDefensiveMid = gridRow("Upgrade R-Defensive Mid", fNoobScroll) 
UI.AttackingMid = gridRow("Upgrade Attacking Mid", fNoobScroll) 
UI.LeftWing = gridRow("Upgrade Left Wing", fNoobScroll) 
UI.RightWing = gridRow("Upgrade Right Wing", fNoobScroll) 
UI.Striker = gridRow("Upgrade Striker", fNoobScroll)

UI.ScoreGoal = gridRow("Auto Score Goal", fUpgradeScroll) 
UI.MoreGoals = gridRow("More Goals Upgrade", fUpgradeScroll) 
UI.GoalsRuneBulk = gridRow("Goals Rune Bulk", fUpgradeScroll) 
UI.GoalsRuneLuck = gridRow("Goals Rune Luck", fUpgradeScroll) 
UI.AutoBuyKicker = gridRow("Auto-Buy Auto Kick", fUpgradeScroll) 
UI.FootballTree = gridRow("Auto Football Tree", fUpgradeScroll) 
UI.ClaimTrophies = gridRow("Auto Buy Trophies", fUpgradeScroll)

-- ======================================================================================
-- MISC PAGE (CONSOLIDATED RUNES, CAPSULES, AND ENCHANTS)
-- ======================================================================================
local miscSidebar = makeSidebar(miscPage)
local bMiscRu1 = makeSideBtn("Runes R1", miscSidebar) bMiscRu1.BackgroundColor3 = Color3.fromRGB(240, 240, 245) bMiscRu1.TextColor3 = Color3.fromRGB(15, 15, 15)
local bMiscRu2 = makeSideBtn("Runes R2", miscSidebar)
local bMiscRuE = makeSideBtn("Runes Events", miscSidebar)
local bMiscCap = makeSideBtn("Capsules", miscSidebar)
local bMiscEnc = makeSideBtn("Enchants", miscSidebar)

local miscScrollRu1 = makeGridScroll(miscPage, true) miscScrollRu1.Visible = true
local miscScrollRu2 = makeGridScroll(miscPage, true)
local miscScrollRuE = makeGridScroll(miscPage, true)
local miscScrollCap = makeGridScroll(miscPage, true)
local miscScrollEnc = makeGridScroll(miscPage, true)

UI.RollBasicRuneCard = gridRow("Auto Basic Rune Circle", miscScrollRu1) 
UI.RollSuperRuneCard = gridRow("Auto Super Rune Circle", miscScrollRu1) 
UI.RollAdvancedRuneCard = gridRow("Auto Advanced Rune", miscScrollRu1) 
UI.RollCosmicRuneCard = gridRow("Auto Cosmic Prism", miscScrollRu1)

UI.RollSnowyRuneCard = gridRow("Auto Snowy Rune Circle", miscScrollRu2)

UI.FootballRuneCard = gridRow("Auto Football Rune", miscScrollRuE)

UI.ClassicCapsule = gridRow("Hatch Classic Capsule", miscScrollCap) 
UI.FootballCapsule = gridRow("Hatch Football Capsule", miscScrollCap) 
UI.SuperCapsule = gridRow("Hatch Super Capsule", miscScrollCap)

UI.EnchantStarter = gridRow("Reroll: Starter", miscScrollEnc) 
UI.EnchantCooker = gridRow("Reroll: Cooker", miscScrollEnc) 
UI.EnchantFarmer = gridRow("Reroll: Farmer", miscScrollEnc) 
UI.EnchantMagician = gridRow("Reroll: Magician", miscScrollEnc) 
UI.EnchantArcher = gridRow("Reroll: Archer", miscScrollEnc) 
UI.EnchantSoldier = gridRow("Reroll: Soldier", miscScrollEnc) 
UI.EnchantHacker1 = gridRow("Reroll: Hacker 1", miscScrollEnc) 
UI.EnchantHacker2 = gridRow("Reroll: Hacker 2", miscScrollEnc) 
UI.EnchantHacker3 = gridRow("Reroll: Hacker 3", miscScrollEnc) 
UI.EnchantHacker4 = gridRow("Reroll: Hacker 4", miscScrollEnc) 
UI.EnchantPharaoh = gridRow("Reroll: Pharaoh", miscScrollEnc)

-- ======================================================================================
-- SETTINGS PAGE (GENERAL & FULL-WIDTH VERTICAL STACKED CONFIG SLOTS)
-- ======================================================================================
local setSidebar = makeSidebar(settingsPage)
local bSetGen = makeSideBtn("General", setSidebar) bSetGen.BackgroundColor3 = Color3.fromRGB(240, 240, 245) bSetGen.TextColor3 = Color3.fromRGB(15, 15, 15)
local bSetConfig = makeSideBtn("Config", setSidebar)

local setGenScroll = makeVerticalScroll(settingsPage, true) setGenScroll.Visible = true
local setConfigScroll = makeVerticalScroll(settingsPage, true)

-- FULL-WIDTH STACKED CONFIG SLOTS
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
        _G.SelectedConfigSlot = i
        loadConfigFromSlot(i)
        box.Text = slotCustomNames[i]
        showToast("Loaded Slot " .. i .. " (" .. slotCustomNames[i] .. ")")
    end)
end

-- ======================================================================================
-- GENERAL SETTINGS TAB (FULL-WIDTH VERTICAL STACKED ROWS WITH REQUESTED SPACING)
-- ======================================================================================
local function genRow(txt, callback)
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

UI.AFK = genRow("Anti  AFK Protection", function(b) tV2(b, "AntiAFK") end)
UI.FPSBoostToggle = genRow("FPS Booster Mode", function(b) toggleFPSBoost(b) end)
UI.HUDToggle = genRow("Stats HUD Ovrlay", function(b)
    _G.ShowStatsHUD = not _G.ShowStatsHUD
    b.Text = _G.ShowStatsHUD and "ACTIVE" or "DISABLED"
    b.BackgroundColor3 = _G.ShowStatsHUD and Color3.fromRGB(20, 60, 20) or Color3.fromRGB(60, 20, 20)
    b.TextColor3 = _G.ShowStatsHUD and Color3.fromRGB(120, 255, 120) or Color3.fromRGB(255, 120, 120)
    local dot = b.Parent:FindFirstChild("StatusDot")
    if dot then dot.BackgroundColor3 = _G.ShowStatsHUD and Color3.fromRGB(80, 255, 80) or Color3.fromRGB(255, 80, 80) end
    saveConfigToSlot(_G.SelectedConfigSlot)
end)

-- CPU Saver Mode toggle added right under Stats HUD
UI.CPUSaverToggle = genRow("CPU Saver Mode", function(b) 
    _G.CPUSaverMode = not _G.CPUSaverMode
    b.Text = _G.CPUSaverMode and "ACTIVE" or "DISABLED"
    b.BackgroundColor3 = _G.CPUSaverMode and Color3.fromRGB(20, 60, 20) or Color3.fromRGB(60, 20, 20)
    b.TextColor3 = _G.CPUSaverMode and Color3.fromRGB(120, 255, 120) or Color3.fromRGB(255, 120, 120)
    local dot = b.Parent:FindFirstChild("StatusDot")
    if dot then dot.BackgroundColor3 = _G.CPUSaverMode and Color3.fromRGB(80, 255, 80) or Color3.fromRGB(255, 80, 80) end
    saveConfigToSlot(_G.SelectedConfigSlot)
    showToast(_G.CPUSaverMode and "CPU Saver Mode Enabled (Background loops throttled)" or "CPU Saver Mode Disabled")
end)

genSpacer(10)

UI.RebirthTimerCard = genRow("Auto Rebirth", function(b) tV2(b, "AutoRebirthTimer") end)
UI.Prestige = genRow("Auto Prestige", function(b) tV2(b, "AutoPrestige") end)
UI.OpenT1ChestCard = genRow("Mass Open T1 Chest", function(b) tV2(b, "AutoOpenT1Chest") end)
UI.OpenT2ChestCard = genRow("Mass Open T2 Chest", function(b) tV2(b, "AutoOpenT2Chest") end)

genSpacer(10)

-- Glide Speed row in General Settings
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
    _G.MiningJumpSpeed = ms[mi] 
    UI.MiningSpeedSwitch.Text = ml[mi] 
    saveConfigToSlot(_G.SelectedConfigSlot) 
end)

genSpacer(10)

-- Hub Theme Row
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

-- Emergency Kill Switch at the bottom
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
killLabel.Text = "Enermency Kill Switch"
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
    Running = false getgenv().DominateHubLoaded = nil 
    for k, _ in pairs(_G) do if type(k) == "string" and (k:sub(1,4) == "Auto" or k == "AntiAFK") then _G[k] = false end end
    pcall(function() 
        local cam = workspace.CurrentCamera if cam then cam.CameraType = Enum.CameraType.Custom end 
        local blur = Lighting:FindFirstChild("DominateHubBlur")
        if blur then blur:Destroy() end
    end) 
    sg:Destroy()
end)

local function toggleFPSBoost(b)
    _G.FPSBoostMode = not _G.FPSBoostMode
    b.Text = _G.FPSBoostMode and "ACTIVE" or "DISABLED"
    b.BackgroundColor3 = _G.FPSBoostMode and Color3.fromRGB(20, 60, 20) or Color3.fromRGB(60, 20, 20)
    b.TextColor3 = _G.FPSBoostMode and Color3.fromRGB(120, 255, 120) or Color3.fromRGB(255, 120, 120)
    local dot = b.Parent:FindFirstChild("StatusDot")
    if dot then dot.BackgroundColor3 = _G.FPSBoostMode and Color3.fromRGB(80, 255, 80) or Color3.fromRGB(255, 80, 80) end
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

--======================================================================================
-- LOCOMOTION & REMOTE ENGINES (WITH CPU SAVER THROTTLE SUPPORT)
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
        task.wait((_G.CPUSaverMode and 0.5 or 0.2))
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
        task.wait(_G.CPUSaverMode and 0.25 or 0.1)
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
        task.wait(_G.CPUSaverMode and 0.25 or 0.12)
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
        task.wait(_G.CPUSaverMode and 1.0 or 0.5) local act = false
        for i = 1, #EnchantQueue do if _G[EnchantQueue[i].F] then act = true break end end
        if NetRemote and Running and act then
            local hrp = GetWorldRoot() if hrp and (hrp.Position - Dest.Enchant).Magnitude > 10 then hrp.CFrame = CFrame.new(Dest.Enchant + Vector3.new(0, 3, 0)) end
            for i = 1, #EnchantQueue do
                if not Running then break end local item = EnchantQueue[i]
                if _G[item.F] then pcall(function() NetRemote:FireServer("RerollEnchant", unpack(item.A)) end) task.wait(_G.CPUSaverMode and 0.6 or 0.3) end
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
                                att = true MasterTargetVector = tb.Position + Vector3.new(0, 3, 0) task.wait(_G.CPUSaverMode and 0.8 or 0.4)
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
        task.wait(_G.CPUSaverMode and 2.0 or 1.0)
        if NetRemote and Running then
            for i = 1, #PrimaryUpgradeQueue do
                if not Running then break end local item = PrimaryUpgradeQueue[i]
                if _G[item.F] then pcall(function() NetRemote:FireServer(item.T, unpack(item.A)) end) task.wait(_G.CPUSaverMode and 0.5 or 0.25) end
            end
        end
    end
end)

task.spawn(function() while Running do task.wait(_G.CPUSaverMode and 1.0 or 0.5) if NetRemote and Running then for i = 1, 11 do if _G["AutoFillBucket" .. i] then pcall(function() NetRemote:FireServer("FillWaterBucket", i) end) task.wait(_G.CPUSaverMode and 0.4 or 0.2) end end end end end)

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

task.spawn(function() while Running do task.wait(_G.CPUSaverMode and 0.4 or 0.2) if NetRemote and Running and _G.AutoScoreGoal then pcall(function() NetRemote:FireServer("RegisterFootballKick") end) task.wait(1.5) if not Running or not _G.AutoScoreGoal then break end pcall(function() NetRemote:FireServer("ScoreGoal") end) task.wait(1.5) end end end)

task.spawn(function()
    while Running do
        if NetRemote and Running and _G.AutoFootballTree then
            local pGui = player:FindFirstChild("PlayerGui") local treeGui = pGui and pGui:FindFirstChild("FootballUITree")
            if treeGui then
                for _, obj in pairs(treeGui:GetDescendants()) do
                    if not Running or not _G.AutoFootballTree then break end
                    if (obj:IsA("GuiButton") or obj:IsA("Frame")) and obj.Name ~= "Main" and obj.Name ~= "Container" then pcall(function() NetRemote:FireServer("BuyFootballUITreeNode", obj.Name) end) task.wait(_G.CPUSaverMode and 1.0 or 0.5) end
                end
            end
        end
        task.wait(_G.CPUSaverMode and 10.0 or 5.0)
    end
end)

task.spawn(function() while Running do task.wait(_G.CPUSaverMode and 6.0 or 3.0) if NetRemote and Running and _G.AutoClaimTrophies then for i = 1, 10 do if not Running or not _G.AutoClaimTrophies then break end pcall(function() NetRemote:FireServer("BuyTrophy", i) end) task.wait(_G.CPUSaverMode and 0.4 or 0.2) end end end end)

local BreadUpgradeList = { {F="AutoBreadMoreWheat",T="UpgradeUpgradeMax",A={"Bread","MoreWheat"}}, {F="AutoBreadMoreBread",T="UpgradeUpgradeMax",A={"Bread","MoreBread"}}, {F="AutoBreadMoreBread2",T="UpgradeUpgradeMax",A={"Bread","MoreBread2"}}, {F="AutoBreadBiggerWheatDeposit",T="UpgradeUpgradeMax",A={"Bread","BiggerWheatDeposit"}}, {F="AutoBreadFasterWheatConversion",T="UpgradeUpgradeMax",A={"Bread","FasterWheatConversion"}}, {F="AutoBreadMoreConsumption",T="UpgradeUpgradeMax",A={"Bread","MoreConsumption"}}, {F="AutoBreadMoreRuneLuck",T="UpgradeUpgradeMax",A={"Bread","MoreRuneLuck"}}, {F="AutoBreadMoreTierLuck",T="UpgradeUpgradeMax",A={"Bread","MoreTierLuck"}}, {F="AutoUpgradeCow",T="UpgradeAnimal",A={"Cow"}}, {F="AutoUpgradeChicken",T="UpgradeAnimal",A={"Chicken"}}, {F="AutoBuyCow",T="BuyAnimal",A={"Cow",true}}, {F="AutoBuyChicken",T="BuyAnimal",A={"Chicken",true}} }
task.spawn(function() local bIdx = 1 while Running do task.wait(_G.CPUSaverMode and 2.4 or 1.2) if NetRemote and Running then local att = 0 repeat local cur = BreadUpgradeList[bIdx] bIdx = (bIdx % #BreadUpgradeList) + 1 att = att + 1 if _G[cur.F] then pcall(function() NetRemote:FireServer(cur.T, unpack(cur.A)) end) break end until att >= #BreadUpgradeList end end end)

task.spawn(function() while Running do task.wait(30.0) if NetRemote and Running then if _G.AutoDepositWheat then pcall(function() NetRemote:FireServer("DepositWheat") end) end if _G.AutoDepositWood then pcall(function() NetRemote:FireServer("DepositWood") end) end end end end)
task.spawn(function() while Running do task.wait(_G.CPUSaverMode and 2.0 or 1.0) if NetRemote and Running then if _G.AutoBlazeMoreBlaze then pcall(function() NetRemote:FireServer("UpgradeUpgradeMax", "Blaze", "MoreBlaze") end) task.wait(0.25) end if _G.AutoBlazeMoreFire then pcall(function() NetRemote:FireServer("UpgradeUpgradeMax", "Blaze", "MoreFire") end) task.wait(0.25) end if _G.AutoBlazeMoreOof then pcall(function() NetRemote:FireServer("UpgradeUpgradeMax", "Blaze", "MoreOof") end) task.wait(0.25) end if _G.AutoBlazeMoreOofs then pcall(function() NetRemote:FireServer("UpgradeUpgradeMax", "Blaze", "MoreOofs") end) task.wait(0.25) end if _G.AutoBlazeMoreBulk then pcall(function() NetRemote:FireServer("UpgradeUpgradeMax", "Blaze", "MoreBulk") end) task.wait(0.25) end end end end)
task.spawn(function() while Running do task.wait(_G.CPUSaverMode and 2.4 or 1.2) if NetRemote and Running then if _G.AutoOpenT1Chest then pcall(function() NetRemote:FireServer("OpenChest", "T1TrialChest", 10) end) end if _G.AutoOpenT2Chest then pcall(function() NetRemote:FireServer("OpenChest", "T2TrialChest", 10) end) end end end end)
task.spawn(function() while Running do task.wait(_G.CPUSaverMode and 10.0 or 5.0) if _G.AutoPrestige and NetRemote and Running then pcall(function() NetRemote:FireServer("Prestige") end) end end end)
task.spawn(function() local tc = math.random(270, 330) local se = 0 while Running do task.wait(1) if Running and _G.AutoBlazeConvert and NetRemote then se = se + 1 if se >= tc then se = 0 tc = math.random(270, 330) pcall(function() NetRemote:FireServer("Blaze") end) end else se = 0 end end end)
