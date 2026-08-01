--======================================================================================
-- DOMINATE HUB | FULL SCRIPT (HARDCODED CLASSIC CAPSULE TELEPORT)
--======================================================================================
if getgenv().DominateHubLoaded then 
    print("[Dominate Hub] Already running! Aborting duplicate instance.")
    return 
end
getgenv().DominateHubLoaded = true

local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local Running = true
local player = Players.LocalPlayer
local vu = VirtualUser
local NetRemote = nil

_G.AntiAFK, _G.AutoPrestige = true, false
_G.AutoUpgradeStarter, _G.AutoUpgradeCooker, _G.AutoUpgradeFarmer, _G.AutoUpgradeMagician, _G.AutoUpgradeArcher, _G.AutoUpgradeSoldier, _G.AutoUpgradeMoreOof, _G.AutoUpgradeFasterNoobs = false, false, false, false, false, false, false, false
_G.AutoRebirthMoreOof, _G.AutoRebirthMoreRebirth, _G.AutoRebirthMoreFire = false, false, false
_G.AutoFireMoreFire, _G.AutoFireMoreBulk, _G.AutoFireMoreOof, _G.AutoFireMoreRebirth, _G.AutoFireMoreTierLuck, _G.AutoFireMoreCashBonus = false, false, false, false, false, false
_G.AutoRebirthTimer = false
_G.AutoBlazeMoreBlaze, _G.AutoBlazeMoreFire, _G.AutoBlazeMoreOof, _G.AutoBlazeMoreOofs, _G.AutoBlazeMoreBulk, _G.AutoBlazeConvert = false, false, false, false, false, false
_G.AutoUpgradePharaoh = false

-- HACKER NOOBS AUTOMATION FLAGS (1 to 4)
_G.AutoUpgradeHacker1, _G.AutoUpgradeHacker2, _G.AutoUpgradeHacker3, _G.AutoUpgradeHacker4 = false, false, false, false

-- FOOTBALL & GOALS AUTOMATION FLAGS
_G.AutoScoreGoal = false
_G.AutoGoalsMoreGoals = false
_G.AutoGoalsRuneBulk = false
_G.AutoGoalsRuneLuck = false
_G.AutoBuyAutoKick = false
_G.AutoFootballTree = false
_G.AutoClaimTrophies = false

-- FOOTBALL POSITIONS AUTOMATION FLAGS
_G.AutoUpgradeGoalkeeper = false
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
_G.AutoRollBasicRune, _G.AutoRollSuperRune, _G.AutoRollAdvancedRune, _G.AutoRollCosmicRune = false, false, false, false
_G.AutoOpenT1Chest, _G.AutoOpenT2Chest = false, false

-- CAPSULE AUTOMATION FLAGS
_G.AutoOpenClassicCapsule = false

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
        if netService then
            NetRemote = netService:FindFirstChild("MainRemote") or netService:FindFirstChildWhichIsA("RemoteEvent")
        end
        if not NetRemote then task.wait(0.5) end
    until NetRemote or not Running
end)

-- UI MASTER ALLOCATION
local parentTarget = (gethui and gethui()) or player:WaitForChild("PlayerGui")
local sg = Instance.new("ScreenGui") sg.Name = "DominateHubMirror" sg.ResetOnSpawn = false sg.Parent = parentTarget

local mainFrame = Instance.new("Frame") mainFrame.Size = UDim2.new(0, 460, 0, 360) mainFrame.Position = UDim2.new(0.5, -230, 0.5, -180) mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20) mainFrame.BackgroundTransparency = 0.15; mainFrame.BorderSizePixel = 0; mainFrame.Parent = sg
local mainCorner = Instance.new("UICorner") mainCorner.CornerRadius = UDim.new(0, 10) mainCorner.Parent = mainFrame

local realm1MasterPage = Instance.new("Frame") realm1MasterPage.Size = UDim2.new(1, -20, 1, -85) realm1MasterPage.Position = UDim2.new(0, 10, 0, 80) realm1MasterPage.BackgroundTransparency = 1; realm1MasterPage.Visible = true; realm1MasterPage.Parent = mainFrame
local realm2Page = Instance.new("Frame") realm2Page.Size = UDim2.new(1, -20, 1, -85) realm2Page.Position = UDim2.new(0, 10, 0, 80) realm2Page.BackgroundTransparency = 1; realm2Page.Visible = false; realm2Page.Parent = mainFrame
local realm3Page = Instance.new("Frame") realm3Page.Size = UDim2.new(1, -20, 1, -85) realm3Page.Position = UDim2.new(0, 10, 0, 80) realm3Page.BackgroundTransparency = 1; realm3Page.Visible = false; realm3Page.Parent = mainFrame
local footballPage = Instance.new("Frame") footballPage.Size = UDim2.new(1, -20, 1, -85) footballPage.Position = UDim2.new(0, 10, 0, 80) footballPage.BackgroundTransparency = 1; footballPage.Visible = false; footballPage.Parent = mainFrame
local runesPage = Instance.new("Frame") runesPage.Size = UDim2.new(1, -20, 1, -85) runesPage.Position = UDim2.new(0, 10, 0, 80) runesPage.BackgroundTransparency = 1; runesPage.Visible = false; runesPage.Parent = mainFrame
local capsulesPage = Instance.new("Frame") capsulesPage.Size = UDim2.new(1, -20, 1, -85) capsulesPage.Position = UDim2.new(0, 10, 0, 80) capsulesPage.BackgroundTransparency = 1; capsulesPage.Visible = false; capsulesPage.Parent = mainFrame
local settingsPage = Instance.new("Frame") settingsPage.Size = UDim2.new(1, -20, 1, -85) settingsPage.Position = UDim2.new(0, 10, 0, 80) settingsPage.BackgroundTransparency = 1; settingsPage.Visible = false; settingsPage.Parent = mainFrame

-- UI HEADER & TABS
local headerTitle = Instance.new("TextLabel") headerTitle.Size = UDim2.new(1, -20, 0, 35) headerTitle.Position = UDim2.new(0, 12, 0, 4) headerTitle.BackgroundTransparency = 1; headerTitle.TextColor3 = Color3.fromRGB(245, 245, 250) headerTitle.TextSize = 15; headerTitle.Font = Enum.Font.SourceSansBold; headerTitle.Text = "Dominate Hub | Noob Incremental" headerTitle.TextXAlignment = Enum.TextXAlignment.Left; headerTitle.Parent = mainFrame

local minBtn = Instance.new("TextButton") minBtn.Size = UDim2.new(0, 95, 0, 24) minBtn.Position = UDim2.new(0.5, -47, 0.01, 0) minBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25) minBtn.TextColor3 = Color3.fromRGB(0, 136, 255) minBtn.TextSize = 12; minBtn.Font = Enum.Font.SourceSansBold; minBtn.Text = "Hide UI" minBtn.Parent = sg
local minCorner = Instance.new("UICorner") minCorner.CornerRadius = UDim.new(0, 5) minCorner.Parent = minBtn

local tabList = Instance.new("Frame") tabList.Size = UDim2.new(1, -20, 0, 32) tabList.Position = UDim2.new(0, 10, 0, 40) tabList.BackgroundTransparency = 1; tabList.Parent = mainFrame
local tabRealm1 = Instance.new("TextButton") tabRealm1.Size = UDim2.new(0, 60, 1, 0) tabRealm1.Position = UDim2.new(0, 2, 0, 0) tabRealm1.BackgroundColor3 = Color3.fromRGB(230, 230, 235) tabRealm1.TextColor3 = Color3.fromRGB(15, 15, 15) tabRealm1.TextSize = 11; tabRealm1.Font = Enum.Font.SourceSansBold; tabRealm1.Text = "Realm 1" tabRealm1.Parent = tabList
local tabRealm2 = Instance.new("TextButton") tabRealm2.Size = UDim2.new(0, 60, 1, 0) tabRealm2.Position = UDim2.new(0, 64, 0, 0) tabRealm2.BackgroundColor3 = Color3.fromRGB(45, 45, 45) tabRealm2.TextColor3 = Color3.fromRGB(170, 170, 170) tabRealm2.TextSize = 11; tabRealm2.Font = Enum.Font.SourceSansBold; tabRealm2.Text = "Realm 2" tabRealm2.Parent = tabList
local tabRealm3 = Instance.new("TextButton") tabRealm3.Size = UDim2.new(0, 60, 1, 0) tabRealm3.Position = UDim2.new(0, 126, 0, 0) tabRealm3.BackgroundColor3 = Color3.fromRGB(45, 45, 45) tabRealm3.TextColor3 = Color3.fromRGB(170, 170, 170) tabRealm3.TextSize = 11; tabRealm3.Font = Enum.Font.SourceSansBold; tabRealm3.Text = "Realm 3" tabRealm3.Parent = tabList
local tabFootball = Instance.new("TextButton") tabFootball.Size = UDim2.new(0, 62, 1, 0) tabFootball.Position = UDim2.new(0, 188, 0, 0) tabFootball.BackgroundColor3 = Color3.fromRGB(45, 45, 45) tabFootball.TextColor3 = Color3.fromRGB(170, 170, 170) tabFootball.TextSize = 11; tabFootball.Font = Enum.Font.SourceSansBold; tabFootball.Text = "Football" tabFootball.Parent = tabList
local tabRunes = Instance.new("TextButton") tabRunes.Size = UDim2.new(0, 60, 1, 0) tabRunes.Position = UDim2.new(0, 252, 0, 0) tabRunes.BackgroundColor3 = Color3.fromRGB(45, 45, 45) tabRunes.TextColor3 = Color3.fromRGB(170, 170, 170) tabRunes.TextSize = 11; tabRunes.Font = Enum.Font.SourceSansBold; tabRunes.Text = "Runes" tabRunes.Parent = tabList
local tabCapsules = Instance.new("TextButton") tabCapsules.Size = UDim2.new(0, 62, 1, 0) tabCapsules.Position = UDim2.new(0, 314, 0, 0) tabCapsules.BackgroundColor3 = Color3.fromRGB(45, 45, 45) tabCapsules.TextColor3 = Color3.fromRGB(170, 170, 170) tabCapsules.TextSize = 11; tabCapsules.Font = Enum.Font.SourceSansBold; tabCapsules.Text = "Capsules" tabCapsules.Parent = tabList
local tabSettings = Instance.new("TextButton") tabSettings.Size = UDim2.new(0, 60, 1, 0) tabSettings.Position = UDim2.new(0, 378, 0, 0) tabSettings.BackgroundColor3 = Color3.fromRGB(45, 45, 45) tabSettings.TextColor3 = Color3.fromRGB(170, 170, 170) tabSettings.TextSize = 11; tabSettings.Font = Enum.Font.SourceSansBold; tabSettings.Text = "Settings" tabSettings.Parent = tabList

Instance.new("UICorner", tabRealm1).CornerRadius = UDim.new(0, 16) 
Instance.new("UICorner", tabRealm2).CornerRadius = UDim.new(0, 16) 
Instance.new("UICorner", tabRealm3).CornerRadius = UDim.new(0, 16) 
Instance.new("UICorner", tabFootball).CornerRadius = UDim.new(0, 16) 
Instance.new("UICorner", tabRunes).CornerRadius = UDim.new(0, 16) 
Instance.new("UICorner", tabCapsules).CornerRadius = UDim.new(0, 16)
Instance.new("UICorner", tabSettings).CornerRadius = UDim.new(0, 16)

-- REALM 1 SUB-TABS
local subTabList = Instance.new("Frame") subTabList.Size = UDim2.new(1, 0, 0, 25) subTabList.Position = UDim2.new(0, 0, 0, 0) subTabList.BackgroundTransparency = 1; subTabList.Parent = realm1MasterPage
local subBtnNoobs = Instance.new("TextButton") subBtnNoobs.Size = UDim2.new(0, 42, 1, 0) subBtnNoobs.Position = UDim2.new(0, 0, 0, 0) subBtnNoobs.BackgroundColor3 = Color3.fromRGB(230, 230, 235) subBtnNoobs.TextColor3 = Color3.fromRGB(15, 15, 15) subBtnNoobs.TextSize = 9; subBtnNoobs.Font = Enum.Font.SourceSansBold; subBtnNoobs.Text = "Noobs" subBtnNoobs.Parent = subTabList
local subBtnOof = Instance.new("TextButton") subBtnOof.Size = UDim2.new(0, 50, 1, 0) subBtnOof.Position = UDim2.new(0, 44, 0, 0) subBtnOof.BackgroundColor3 = Color3.fromRGB(45, 45, 45) subBtnOof.TextColor3 = Color3.fromRGB(170, 170, 170) subBtnOof.TextSize = 9; subBtnOof.Font = Enum.Font.SourceSansBold; subBtnOof.Text = "Oof" subBtnOof.Parent = subTabList
local subBtnRebirth = Instance.new("TextButton") subBtnRebirth.Size = UDim2.new(0, 56, 1, 0) subBtnRebirth.Position = UDim2.new(0, 96, 0, 0) subBtnRebirth.BackgroundColor3 = Color3.fromRGB(45, 45, 45) subBtnRebirth.TextColor3 = Color3.fromRGB(170, 170, 170) subBtnRebirth.TextSize = 9; subBtnRebirth.Font = Enum.Font.SourceSansBold; subBtnRebirth.Text = "Rebirth" subBtnRebirth.Parent = subTabList
local subBtnFire = Instance.new("TextButton") subBtnFire.Size = UDim2.new(0, 45, 1, 0) subBtnFire.Position = UDim2.new(0, 154, 0, 0) subBtnFire.BackgroundColor3 = Color3.fromRGB(45, 45, 45) subBtnFire.TextColor3 = Color3.fromRGB(170, 170, 170) subBtnFire.TextSize = 9; subBtnFire.Font = Enum.Font.SourceSansBold; subBtnFire.Text = "Fire" subBtnFire.Parent = subTabList
local subBtnBlaze = Instance.new("TextButton") subBtnBlaze.Size = UDim2.new(0, 45, 1, 0) subBtnBlaze.Position = UDim2.new(0, 201, 0, 0) subBtnBlaze.BackgroundColor3 = Color3.fromRGB(45, 45, 45) subBtnBlaze.TextColor3 = Color3.fromRGB(170, 170, 170) subBtnBlaze.TextSize = 9; subBtnBlaze.Font = Enum.Font.SourceSansBold; subBtnBlaze.Text = "Blaze" subBtnBlaze.Parent = subTabList
local subBtnFarm = Instance.new("TextButton") subBtnFarm.Size = UDim2.new(0, 45, 1, 0) subBtnFarm.Position = UDim2.new(0, 248, 0, 0) subBtnFarm.BackgroundColor3 = Color3.fromRGB(45, 45, 45) subBtnFarm.TextColor3 = Color3.fromRGB(170, 170, 170) subBtnFarm.TextSize = 9; subBtnFarm.Font = Enum.Font.SourceSansBold; subBtnFarm.Text = "Farm" subBtnFarm.Parent = subTabList
local subBtnCash = Instance.new("TextButton") subBtnCash.Size = UDim2.new(0, 45, 1, 0) subBtnCash.Position = UDim2.new(0, 295, 0, 0) subBtnCash.BackgroundColor3 = Color3.fromRGB(45, 45, 45) subBtnCash.TextColor3 = Color3.fromRGB(170, 170, 170) subBtnCash.TextSize = 9; subBtnCash.Font = Enum.Font.SourceSansBold; subBtnCash.Text = "Cash" subBtnCash.Parent = subTabList
local subBtnHacker = Instance.new("TextButton") subBtnHacker.Size = UDim2.new(0, 52, 1, 0) subBtnHacker.Position = UDim2.new(0, 342, 0, 0) subBtnHacker.BackgroundColor3 = Color3.fromRGB(45, 45, 45) subBtnHacker.TextColor3 = Color3.fromRGB(170, 170, 170) subBtnHacker.TextSize = 9; subBtnHacker.Font = Enum.Font.SourceSansBold; subBtnHacker.Text = "Hacker" subBtnHacker.Parent = subTabList

Instance.new("UICorner", subBtnNoobs).CornerRadius = UDim.new(0, 4) Instance.new("UICorner", subBtnOof).CornerRadius = UDim.new(0, 4) Instance.new("UICorner", subBtnRebirth).CornerRadius = UDim.new(0, 4) Instance.new("UICorner", subBtnFire).CornerRadius = UDim.new(0, 4) Instance.new("UICorner", subBtnBlaze).CornerRadius = UDim.new(0, 4) Instance.new("UICorner", subBtnFarm).CornerRadius = UDim.new(0, 4) Instance.new("UICorner", subBtnCash).CornerRadius = UDim.new(0, 4) Instance.new("UICorner", subBtnHacker).CornerRadius = UDim.new(0, 4)

-- RUNES SUB-TABS
local runesSubTabList = Instance.new("Frame") runesSubTabList.Size = UDim2.new(1, 0, 0, 25) runesSubTabList.Position = UDim2.new(0, 0, 0, 0) runesSubTabList.BackgroundTransparency = 1; runesSubTabList.Parent = runesPage
local runesSubBtn1 = Instance.new("TextButton") runesSubBtn1.Size = UDim2.new(0, 80, 1, 0) runesSubBtn1.Position = UDim2.new(0, 0, 0, 0) runesSubBtn1.BackgroundColor3 = Color3.fromRGB(230, 230, 235) runesSubBtn1.TextColor3 = Color3.fromRGB(15, 15, 15) runesSubBtn1.TextSize = 11; runesSubBtn1.Font = Enum.Font.SourceSansBold; runesSubBtn1.Text = "Realm 1" runesSubBtn1.Parent = runesSubTabList
local runesSubBtn2 = Instance.new("TextButton") runesSubBtn2.Size = UDim2.new(0, 80, 1, 0) runesSubBtn2.Position = UDim2.new(0, 85, 0, 0) runesSubBtn2.BackgroundColor3 = Color3.fromRGB(45, 45, 45) runesSubBtn2.TextColor3 = Color3.fromRGB(170, 170, 170) runesSubBtn2.TextSize = 11; runesSubBtn2.Font = Enum.Font.SourceSansBold; runesSubBtn2.Text = "Realm 2" runesSubBtn2.Parent = runesSubTabList
local runesSubBtn3 = Instance.new("TextButton") runesSubBtn3.Size = UDim2.new(0, 80, 1, 0) runesSubBtn3.Position = UDim2.new(0, 170, 0, 0) runesSubBtn3.BackgroundColor3 = Color3.fromRGB(45, 45, 45) runesSubBtn3.TextColor3 = Color3.fromRGB(170, 170, 170) runesSubBtn3.TextSize = 11; runesSubBtn3.Font = Enum.Font.SourceSansBold; runesSubBtn3.Text = "Realm 3" runesSubBtn3.Parent = runesSubTabList
local runesSubBtnEvents = Instance.new("TextButton") runesSubBtnEvents.Size = UDim2.new(0, 80, 1, 0) runesSubBtnEvents.Position = UDim2.new(0, 255, 0, 0) runesSubBtnEvents.BackgroundColor3 = Color3.fromRGB(45, 45, 45) runesSubBtnEvents.TextColor3 = Color3.fromRGB(170, 170, 170) runesSubBtnEvents.TextSize = 11; runesSubBtnEvents.Font = Enum.Font.SourceSansBold; runesSubBtnEvents.Text = "Events" runesSubBtnEvents.Parent = runesSubTabList

Instance.new("UICorner", runesSubBtn1).CornerRadius = UDim.new(0, 5) Instance.new("UICorner", runesSubBtn2).CornerRadius = UDim.new(0, 5) Instance.new("UICorner", runesSubBtn3).CornerRadius = UDim.new(0, 5) Instance.new("UICorner", runesSubBtnEvents).CornerRadius = UDim.new(0, 5)

-- FOOTBALL SUB-TABS
local footballSubTabList = Instance.new("Frame") footballSubTabList.Size = UDim2.new(1, 0, 0, 25) footballSubTabList.Position = UDim2.new(0, 0, 0, 0) footballSubTabList.BackgroundTransparency = 1; footballSubTabList.Parent = footballPage
local footballSubBtnNoobs = Instance.new("TextButton") footballSubBtnNoobs.Size = UDim2.new(0, 110, 1, 0) footballSubBtnNoobs.Position = UDim2.new(0, 0, 0, 0) footballSubBtnNoobs.BackgroundColor3 = Color3.fromRGB(230, 230, 235) footballSubBtnNoobs.TextColor3 = Color3.fromRGB(15, 15, 15) footballSubBtnNoobs.TextSize = 11; footballSubBtnNoobs.Font = Enum.Font.SourceSansBold; footballSubBtnNoobs.Text = "Football Noobs" footballSubBtnNoobs.Parent = footballSubTabList
local footballSubBtnUpgrades = Instance.new("TextButton") footballSubBtnUpgrades.Size = UDim2.new(0, 130, 1, 0) footballSubBtnUpgrades.Position = UDim2.new(0, 115, 0, 0) footballSubBtnUpgrades.BackgroundColor3 = Color3.fromRGB(45, 45, 45) footballSubBtnUpgrades.TextColor3 = Color3.fromRGB(170, 170, 170) footballSubBtnUpgrades.TextSize = 11; footballSubBtnUpgrades.Font = Enum.Font.SourceSansBold; footballSubBtnUpgrades.Text = "Goals & Tree Upgrades" footballSubBtnUpgrades.Parent = footballSubTabList

Instance.new("UICorner", footballSubBtnNoobs).CornerRadius = UDim.new(0, 5) Instance.new("UICorner", footballSubBtnUpgrades).CornerRadius = UDim.new(0, 5)

local function makeScroll(canvas, parent) 
    local s = Instance.new("ScrollingFrame") s.Size = UDim2.new(1, 0, 1, -30) s.Position = UDim2.new(0, 0, 0, 30) s.BackgroundTransparency = 1; s.BorderSizePixel = 0; s.CanvasSize = UDim2.new(0, 0, 0, canvas) s.ScrollBarThickness = 3; s.ScrollBarImageColor3 = Color3.fromRGB(0, 136, 255) s.Visible = false; s.Parent = parent return s 
end

local realm1NoobScroll = makeScroll(310, realm1MasterPage) realm1NoobScroll.Visible = true
local realm1UpgradeScroll = makeScroll(110, realm1MasterPage)
local realm1RebirthScroll = makeScroll(160, realm1MasterPage)
local realm1FireScroll = makeScroll(300, realm1MasterPage)
local realm1BlazeScroll = makeScroll(360, realm1MasterPage)
local realm1BreadScroll = makeScroll(650, realm1MasterPage)
local realm1CashScroll = makeScroll(170, realm1MasterPage)
local realm1HackerScroll = makeScroll(220, realm1MasterPage)

local realm2Scroll = makeScroll(100, realm2Page) realm2Scroll.Visible = true

local runesScroll1 = makeScroll(200, runesPage) runesScroll1.Visible = true
local runesScroll2 = makeScroll(100, runesPage)
local runesScroll3 = makeScroll(100, runesPage)
local runesScrollEvents = makeScroll(100, runesPage)

local capsulesScroll = makeScroll(100, capsulesPage) capsulesScroll.Visible = true

local footballNoobScroll = makeScroll(460, footballPage) footballNoobScroll.Visible = true
local footballUpgradeScroll = makeScroll(380, footballPage)

local function gridRow(txt, pos, page)
    local f = Instance.new("Frame") f.Size = UDim2.new(1, -10, 0, 36) f.Position = UDim2.new(0, 5, 0, (pos-1)*41+5) f.BackgroundColor3 = Color3.fromRGB(30, 30, 30) f.BorderSizePixel = 0; f.Parent = page
    local l = Instance.new("TextLabel") l.Size = UDim2.new(0.7, 0, 1, 0) l.Position = UDim2.new(0, 12, 0, 0) l.BackgroundTransparency = 1; l.TextColor3 = Color3.fromRGB(220, 220, 225) l.TextSize = 13; l.Font = Enum.Font.SourceSans; l.Text = txt; l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = f
    local b = Instance.new("TextButton") b.Size = UDim2.new(0, 75, 0, 26) b.Position = UDim2.new(1, -85, 0.5, -13) b.BackgroundColor3 = Color3.fromRGB(60, 20, 20) b.TextColor3 = Color3.fromRGB(255, 120, 120) b.TextSize = 11; b.Font = Enum.Font.SourceSansBold; b.Text = "DISABLED" b.Parent = f
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 5) Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5) return b
end

local function makeSubRow(label, idx, scr)
    local f = Instance.new("Frame") f.Size = UDim2.new(1, -12, 0, 42) f.Position = UDim2.new(0, 5, 0, (idx-1)*48+5) f.BackgroundColor3 = Color3.fromRGB(30, 30, 30) f.BorderSizePixel = 0; f.Parent = scr
    local l = Instance.new("TextLabel") l.Size = UDim2.new(0.7, 0, 1, 0) l.Position = UDim2.new(0, 12, 0, 0) l.BackgroundTransparency = 1; l.TextColor3 = Color3.fromRGB(220, 220, 225) l.TextSize = 13; l.Font = Enum.Font.SourceSans; l.Text = label; l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = f
    local b = Instance.new("TextButton") b.Size = UDim2.new(0, 75, 0, 24) b.Position = UDim2.new(1, -85, 0.5, -12) b.BackgroundColor3 = Color3.fromRGB(60, 20, 20) b.TextColor3 = Color3.fromRGB(255, 120, 120) b.TextSize = 11; b.Font = Enum.Font.SourceSansBold; b.Text = "DISABLED" b.Parent = f
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 5) Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5) return b
end

local toggleStarter = makeSubRow("Starter Noob Auto Upgrade", 1, realm1NoobScroll)
local toggleCooker = makeSubRow("Cooker Noob Auto Upgrade", 2, realm1NoobScroll)
local toggleFarmer = makeSubRow("Farmer Noob Auto Upgrade", 3, realm1NoobScroll)
local toggleMagician = makeSubRow("Magician Noob Auto Upgrade", 4, realm1NoobScroll)
local toggleArcher = makeSubRow("Archer Noob Auto Upgrade", 5, realm1NoobScroll)
local toggleSoldier = makeSubRow("Soldier Noob Auto Upgrade", 6, realm1NoobScroll)

local toggleMoreOof = makeSubRow("More Oof Auto Upgrade", 1, realm1UpgradeScroll)
local toggleFasterNoobs = makeSubRow("Faster Noobs Auto Upgrade", 2, realm1UpgradeScroll)
local toggleRebirthOof = makeSubRow("More Oof (Rebirth)", 1, realm1RebirthScroll)
local toggleRebirthRebirth = makeSubRow("More Rebirth (Rebirth)", 2, realm1RebirthScroll)
local toggleRebirthFire = makeSubRow("More Fire (Rebirth)", 3, realm1RebirthScroll)

local toggleFireFire = makeSubRow("More Fire (Fire)", 1, realm1FireScroll)
local toggleFireBulk = makeSubRow("More Bulk (Fire)", 2, realm1FireScroll)
local toggleFireOof = makeSubRow("More Oof (Fire)", 3, realm1FireScroll)
local toggleFireRebirth = makeSubRow("More Rebirth (Fire)", 4, realm1FireScroll)
local toggleFireTierLuck = makeSubRow("More Tier Luck (Fire)", 5, realm1FireScroll)
local toggleFireCashBonus = makeSubRow("More Cash (Fire)", 6, realm1FireScroll)

local toggleAutoBlazeConvert = makeSubRow("Auto Convert Fire to Blaze (5m)", 1, realm1BlazeScroll)
local toggleBlazeMoreBlaze = makeSubRow("More Blaze (Blaze)", 2, realm1BlazeScroll)
local toggleBlazeMoreFire = makeSubRow("More Fire (Blaze)", 3, realm1BlazeScroll)
local toggleBlazeMoreOof = makeSubRow("More Oof (Blaze)", 4, realm1BlazeScroll)
local toggleBlazeMoreOofs = makeSubRow("More Oofs (Blaze)", 5, realm1BlazeScroll)
local toggleBlazeMoreBulk = makeSubRow("More Bulk (Blaze)", 6, realm1BlazeScroll)

local toggleDepositWheat = makeSubRow("Auto Deposit Wheat (1m)", 1, realm1BreadScroll)
local toggleBreadMoreBread = makeSubRow("More Bread (Bread)", 2, realm1BreadScroll)
local toggleBreadMoreBread2 = makeSubRow("More Bread 2 (Bread)", 3, realm1BreadScroll)
local toggleBreadMoreWheat = makeSubRow("More Wheat (Bread)", 4, realm1BreadScroll)
local toggleBreadBiggerWheatDeposit = makeSubRow("Bigger Wheat Deposit (Bread)", 5, realm1BreadScroll)
local toggleBreadFasterWheatConversion = makeSubRow("Faster Wheat Conversion (Bread)", 6, realm1BreadScroll)
local toggleBreadMoreConsumption = makeSubRow("More Consumption (Bread)", 7, realm1BreadScroll)
local toggleBreadMoreRuneLuck = makeSubRow("More Rune Luck (Bread)", 8, realm1BreadScroll)
local toggleBreadMoreTierLuck = makeSubRow("More Tier Luck (Bread)", 9, realm1BreadScroll)
local toggleUpgradeCow = makeSubRow("Upgrade Cow (Level)", 10, realm1BreadScroll)
local toggleUpgradeChicken = makeSubRow("Upgrade Chicken (Level)", 11, realm1BreadScroll)
local toggleBuyCow = makeSubRow("Buy Cow (Max)", 12, realm1BreadScroll)
local toggleBuyChicken = makeSubRow("Buy Chicken (Max)", 13, realm1BreadScroll)

local toggleAutoFarmCash = makeSubRow("Auto Pad", 1, realm1CashScroll)
local toggleCashMoreCash = makeSubRow("More Cash Auto Upgrade", 2, realm1CashScroll)
local toggleCashFasterDropper = makeSubRow("Faster Dropper Auto Upgrade", 3, realm1CashScroll)
local toggleCashMoreRuneLuck = makeSubRow("More Rune Luck Auto Upgrade", 4, realm1CashScroll)

-- HACKER ROWS (1 to 4)
local toggleHacker1 = makeSubRow("Auto Upgrade Hacker 1", 1, realm1HackerScroll)
local toggleHacker2 = makeSubRow("Auto Upgrade Hacker 2", 2, realm1HackerScroll)
local toggleHacker3 = makeSubRow("Auto Upgrade Hacker 3", 3, realm1HackerScroll)
local toggleHacker4 = makeSubRow("Auto Upgrade Hacker 4", 4, realm1HackerScroll)

local togglePharaoh = gridRow("Auto Upgrade Pharaoh (Max)", 1, realm3Page)

-- FOOTBALL ROWS (Ordered from Goalkeeper to Striker, no Max)
local toggleGoalkeeper = gridRow("Auto Upgrade Goalkeeper", 1, footballNoobScroll)
local toggleLeftCenterBack = gridRow("Auto Upgrade Left Center Back", 2, footballNoobScroll)
local toggleRightCenterBack = gridRow("Auto Upgrade Right Center Back", 3, footballNoobScroll)
local toggleRightBack = gridRow("Auto Upgrade Right Back", 4, footballNoobScroll)
local toggleLeftDefensiveMid = gridRow("Auto Upgrade Left Defensive Mid", 5, footballNoobScroll)
local toggleRightDefensiveMid = gridRow("Auto Upgrade Right Defensive Mid", 6, footballNoobScroll)
local toggleAttackingMid = gridRow("Auto Upgrade Attacking Mid", 7, footballNoobScroll)
local toggleLeftWing = gridRow("Auto Upgrade Left Wing", 8, footballNoobScroll)
local toggleRightWing = gridRow("Auto Upgrade Right Wing", 9, footballNoobScroll)
local toggleStriker = gridRow("Auto Upgrade Striker", 10, footballNoobScroll)

local toggleScoreGoal = gridRow("Auto Score & Kick (1.5s Debug)", 1, footballUpgradeScroll)
local toggleMoreGoals = gridRow("More Goals Upgrade (Max)", 2, footballUpgradeScroll)
local toggleGoalsRuneBulk = gridRow("Goals Rune Bulk (Max)", 3, footballUpgradeScroll)
local toggleGoalsRuneLuck = gridRow("Goals Rune Luck (Max)", 4, footballUpgradeScroll)
local toggleAutoBuyKicker = gridRow("Auto-Buy Auto Kick", 5, footballUpgradeScroll)
local toggleFootballTree = gridRow("Auto Buy Football Tree (Dynamic PlayerGui)", 6, footballUpgradeScroll)
local toggleClaimTrophies = gridRow("Auto Buy Trophies (1-10)", 7, footballUpgradeScroll)

-- RUNES ROWS
local toggleRollBasicRuneCard = gridRow("Auto Roll Basic Rune Circle (Fire)", 1, runesScroll1)
local toggleRollSuperRuneCard = gridRow("Auto Roll Super Rune Circle (Oof)", 2, runesScroll1)
local toggleRollAdvancedRuneCard = gridRow("Auto Roll Advanced Rune Circle (Gems)", 3, runesScroll1)
local toggleRollCosmicRuneCard = gridRow("Auto Roll Cosmic Prism Circle (Prisms)", 4, runesScroll1)

-- CAPSULES ROWS
local toggleClassicCapsule = gridRow("Auto Teleport & Open Classic Capsule", 1, capsulesScroll)

-- SETTINGS / CHESTS
local toggleOpenT1ChestCard = gridRow("Auto Mass-Open T1 Trial Chests", 1, settingsPage)
local toggleOpenT2ChestCard = gridRow("Auto Mass-Open T2 Trial Chests", 2, settingsPage)
local toggleAFK = gridRow("Anti-AFK Safety Disconnect Protection", 3, settingsPage)
toggleAFK.BackgroundColor3 = Color3.fromRGB(20, 60, 20) toggleAFK.TextColor3 = Color3.fromRGB(120, 255, 120) toggleAFK.Text = "ACTIVE"
local togglePrestige = gridRow("Auto Prestige", 4, settingsPage)
local toggleRebirthTimerCard = gridRow("Auto Rebirth (Every 10-Minute Loop Interval)", 5, settingsPage)
local toggleKillSwitch = gridRow("EMERGENCY SYSTEM KILL SWITCH", 6, settingsPage)
toggleKillSwitch.BackgroundColor3 = Color3.fromRGB(120, 20, 20) toggleKillSwitch.TextColor3 = Color3.fromRGB(255, 200, 200) toggleKillSwitch.Text = "TERMINATE"

--======================================================================================
-- LOCOMOTION & REMOTE ENGINES
--======================================================================================
local MasterTargetVector = nil  
local CurrentLoopStateSleep = false 

local BasicRuneVector = Vector3.new(1114.7530517578125, 10.3100004196167, -644.1510009765625)
local SuperRuneVector = Vector3.new(1082.0938720703125, 16.661418914794922, -782.02197265625)
local AdvancedRuneVector = Vector3.new(1293.495361328125, 16.515989303588867, -883.3126220703125)
local CosmicRuneVector = Vector3.new(783.4507446289062, 16.65555763244629, -855.9728393554688)
local ClassicCapsuleVector = Vector3.new(-2586.923828125, 43.317691802978516, -659.1055297851562)

local function GetWorldRoot()
    return player.Character and player.Character:FindFirstChild("HumanoidRootPart")
end

-- RUNE TELEPORTATION LOOP
task.spawn(function()
    while Running do
        task.wait(CurrentLoopStateSleep and 1.0 or 0.2)
        local hrp = GetWorldRoot()
        if hrp and Running then
            local activeDestination = nil
            if MasterTargetVector then activeDestination = MasterTargetVector
            elseif _G.AutoRollCosmicRune then activeDestination = CosmicRuneVector
            elseif _G.AutoRollAdvancedRune then activeDestination = AdvancedRuneVector
            elseif _G.AutoRollSuperRune then activeDestination = SuperRuneVector
            elseif _G.AutoRollBasicRune then activeDestination = BasicRuneVector end
            if activeDestination and Running and (hrp.Position - activeDestination).Magnitude > 5 then
                hrp.CFrame = CFrame.new(activeDestination)
            end
        end
    end
end)

-- HARDCODED CLASSIC CAPSULE TELEPORT & AUTO-OPEN ENGINE
task.spawn(function()
    while Running do
        task.wait(1.0)
        if NetRemote and Running and _G.AutoOpenClassicCapsule then
            local hrp = GetWorldRoot()
            if hrp and (hrp.Position - ClassicCapsuleVector).Magnitude > 10 then
                hrp.CFrame = CFrame.new(ClassicCapsuleVector + Vector3.new(0, 3, 0))
            end
            pcall(function()
                local args = {
                    [1] = "ToggleMinionAutoOpen",
                    [2] = "Classic"
                }
                NetRemote:FireServer(unpack(args))
            end)
        end
    end
end)

-- CONVEYOR CASH PAD AUTO FARM LOOP
task.spawn(function()
    while Running do
        task.wait(0.5)
        if _G.AutoFarmCash and Running then
            local gameContent = workspace:FindFirstChild("__GAME_CONTENT")
            local tycoon = gameContent and gameContent:FindFirstChild("Tycoon")
            local buttonsFolder = tycoon and tycoon:FindFirstChild("Buttons")
            if buttonsFolder and Running then
                local roundLockedPads = {} CurrentLoopStateSleep = false 
                repeat
                    if not Running or not _G.AutoFarmCash then break end
                    local visibleButtons = buttonsFolder:GetChildren()
                    local attemptedAPadThisPass = false
                    for i = 1, #visibleButtons do
                        if not Running or not _G.AutoFarmCash then break end
                        local btnModel = visibleButtons[i]
                        if btnModel and btnModel:IsA("Model") and not roundLockedPads[btnModel.Name] then
                            local targetBuyPart = btnModel:FindFirstChild("BuyingButtonPart", true)
                            if targetBuyPart and targetBuyPart:IsA("BasePart") and Running then
                                attemptedAPadThisPass = true MasterTargetVector = targetBuyPart.Position + Vector3.new(0, 3, 0)
                                task.wait(0.4)
                                if not Running then break end
                                if btnModel:IsDescendantOf(buttonsFolder) then roundLockedPads[btnModel.Name] = true MasterTargetVector = nil task.wait(0.05)
                                else MasterTargetVector = nil task.wait(0.1) break end
                            end
                        end
                    end
                    if not attemptedAPadThisPass or not _G.AutoFarmCash or not Running then break end
                    task.wait(0.1)
                until false
                if Running then
                    MasterTargetVector = nil CurrentLoopStateSleep = true 
                    local sleepDuration = math.random(120, 180)
                    local sleepEndTime = tick() + sleepDuration
                    repeat task.wait(1) until tick() >= sleepEndTime or not _G.AutoFarmCash or not Running
                end
            else MasterTargetVector = nil task.wait(2) end
        else MasterTargetVector = nil CurrentLoopStateSleep = true task.wait(1) end
    end
end)

-- UNIFIED PRIMARY UPGRADE QUEUE
local PrimaryUpgradeQueue = {
    {F = "AutoUpgradeStarter",    T = "UpgradeNoob",       A = {"Starter"}},
    {F = "AutoUpgradeCooker",     T = "UpgradeNoobMax",    A = {"Cooker"}},
    {F = "AutoUpgradeFarmer",     T = "UpgradeNoobMax",    A = {"Farmer"}},
    {F = "AutoUpgradeMagician",   T = "UpgradeNoobMax",    A = {"Magician"}},
    {F = "AutoUpgradeArcher",     T = "UpgradeNoobMax",    A = {"Archer"}},
    {F = "AutoUpgradeSoldier",    T = "UpgradeNoobMax",    A = {"Soldier"}},
    {F = "AutoUpgradePharaoh",    T = "UpgradeNoobMax",    A = {"Pharaoh"}},
    
    {F = "AutoUpgradeHacker1",    T = "UpgradeNoobMax",    A = {"Hacker 1"}},
    {F = "AutoUpgradeHacker2",    T = "UpgradeNoobMax",    A = {"Hacker 2"}},
    {F = "AutoUpgradeHacker3",    T = "UpgradeNoobMax",    A = {"Hacker 3"}},
    {F = "AutoUpgradeHacker4",    T = "UpgradeNoobMax",    A = {"Hacker 4"}},

    {F = "AutoUpgradeGoalkeeper",   T = "UpgradeNoobMax",    A = {"Goalkeeper"}},
    {F = "AutoUpgradeLeftCenterBack", T = "UpgradeNoobMax",  A = {"LeftCenterBack"}},
    {F = "AutoUpgradeRightCenterBack", T = "UpgradeNoobMax", A = {"RightCenterBack"}},
    {F = "AutoUpgradeRightBack",  T = "UpgradeNoobMax",    A = {"RightBack"}},
    {F = "AutoUpgradeLeftDefensiveMid", T = "UpgradeNoobMax",A = {"LeftDefensiveMid"}},
    {F = "AutoUpgradeRightDefensiveMid", T = "UpgradeNoobMax", A = {"RightDefensiveMid"}},
    {F = "AutoUpgradeAttackingMid", T = "UpgradeNoobMax",    A = {"AttackingMid"}},
    {F = "AutoUpgradeLeftWing",   T = "UpgradeNoobMax",    A = {"LeftWing"}},
    {F = "AutoUpgradeRightWing",  T = "UpgradeNoobMax",    A = {"RightWing"}},
    {F = "AutoUpgradeStriker",      T = "UpgradeNoobMax",    A = {"Striker"}},
    
    {F = "AutoUpgradeMoreOof",    T = "UpgradeUpgradeMax", A = {"Oof", "MoreOof"}},
    {F = "AutoUpgradeFasterNoobs",T = "UpgradeUpgradeMax", A = {"Oof", "FasterNoobs"}},
    
    {F = "AutoRebirthMoreOof",    T = "UpgradeUpgradeMax", A = {"Rebirth", "MoreOof"}},
    {F = "AutoRebirthMoreRebirth",T = "UpgradeUpgradeMax", A = {"Rebirth", "MoreRebirth"}},
    {F = "AutoRebirthMoreFire",   T = "UpgradeUpgradeMax", A = {"Rebirth", "MoreFire"}},
    
    {F = "AutoFireMoreFire",      T = "UpgradeUpgradeMax", A = {"Fire", "MoreFire"}},
    {F = "AutoFireMoreBulk",      T = "UpgradeUpgradeMax", A = {"Fire", "MoreBulk"}},
    {F = "AutoFireMoreOof",       T = "UpgradeUpgradeMax", A = {"Fire", "MoreOof"}},
    {F = "AutoFireMoreRebirth",   T = "UpgradeUpgradeMax", A = {"Fire", "MoreRebirth"}},
    {F = "AutoFireMoreTierLuck",  T = "UpgradeUpgradeMax", A = {"Fire", "MoreTierLuck"}},
    {F = "AutoFireMoreCashBonus", T = "UpgradeUpgradeMax", A = {"Fire", "MoreCashBonus"}},
    
    {F = "AutoUpgradeMoreCash",    T = "UpgradeUpgradeMax", A = {"Cash", "MoreCash"}},
    {F = "AutoUpgradeFasterDropper",T = "UpgradeUpgradeMax", A = {"Cash", "FasterDropper"}},
    {F = "AutoUpgradeMoreRuneLuck",T = "UpgradeUpgradeMax", A = {"Cash", "MoreRuneLuck"}},

    {F = "AutoGoalsMoreGoals",     T = "UpgradeUpgradeMax", A = {"Goals", "MoreGoals"}},
    {F = "AutoGoalsRuneBulk",      T = "UpgradeUpgradeMax", A = {"Goals", "RuneBulk"}},
    {F = "AutoGoalsRuneLuck",      T = "UpgradeUpgradeMax", A = {"Goals", "RuneLuck"}},
    {F = "AutoBuyAutoKick",        T = "UpgradeUpgradeMax", A = {"Goals", "AutoKick"}}
}

task.spawn(function()
    while Running do
        task.wait(1.0)
        if NetRemote and Running then
            for i = 1, #PrimaryUpgradeQueue do
                if not Running then break end
                local item = PrimaryUpgradeQueue[i]
                if _G[item.F] then 
                    pcall(function() NetRemote:FireServer(item.T, unpack(item.A)) end) 
                    task.wait(0.25) 
                end
            end
        end
    end
end)

-- AUTO SCORE & KICK LOOP (WITH 1.5s DELAYS)
task.spawn(function()
    while Running do
        task.wait(0.2)
        if NetRemote and Running and _G.AutoScoreGoal then
            pcall(function()
                NetRemote:FireServer("RegisterFootballKick")
            end)
            task.wait(1.5)
            if not Running or not _G.AutoScoreGoal then break end
            pcall(function()
                NetRemote:FireServer("ScoreGoal")
            end)
            task.wait(1.5)
        end
    end
end)

-- DYNAMIC PLAYERGUI FOOTBALL TREE AUTOMATION ENGINE
task.spawn(function()
    while Running do
        if NetRemote and Running and _G.AutoFootballTree then
            local pGui = player:FindFirstChild("PlayerGui")
            local treeGui = pGui and pGui:FindFirstChild("FootballUITree")
            
            if treeGui then
                for _, obj in pairs(treeGui:GetDescendants()) do
                    if not Running or not _G.AutoFootballTree then break end
                    if (obj:IsA("GuiButton") or obj:IsA("Frame")) and obj.Name ~= "Main" and obj.Name ~= "Container" then
                        local nodeKey = obj.Name
                        pcall(function()
                            NetRemote:FireServer("BuyFootballUITreeNode", nodeKey)
                        end)
                        task.wait(0.5)
                    end
                end
            end
        end
        task.wait(5.0)
    end
end)

-- AUTO BUY TROPHIES ENGINE (1 TO 10)
task.spawn(function()
    while Running do
        task.wait(3.0)
        if NetRemote and Running and _G.AutoClaimTrophies then
            for trophyIndex = 1, 10 do
                if not Running or not _G.AutoClaimTrophies then break end
                pcall(function()
                    local args = {
                        [1] = "BuyTrophy",
                        [2] = trophyIndex
                    }
                    NetRemote:FireServer(unpack(args))
                end)
                task.wait(0.2)
            end
        end
    end
end)

-- INTERLEAVED BREAD & ANIMALS ENGINE
local BreadUpgradeList = {
    {F = "AutoBreadMoreWheat",          T = "UpgradeUpgradeMax", A = {"Bread", "MoreWheat"}},
    {F = "AutoBreadMoreBread",          T = "UpgradeUpgradeMax", A = {"Bread", "MoreBread"}},
    {F = "AutoBreadMoreBread2",         T = "UpgradeUpgradeMax", A = {"Bread", "MoreBread2"}},
    {F = "AutoBreadBiggerWheatDeposit", T = "UpgradeUpgradeMax", A = {"Bread", "BiggerWheatDeposit"}},
    {F = "AutoBreadFasterWheatConversion", T = "UpgradeUpgradeMax", A = {"Bread", "FasterWheatConversion"}},
    {F = "AutoBreadMoreConsumption",    T = "UpgradeUpgradeMax", A = {"Bread", "MoreConsumption"}},
    {F = "AutoBreadMoreRuneLuck",       T = "UpgradeUpgradeMax", A = {"Bread", "MoreRuneLuck"}},
    {F = "AutoBreadMoreTierLuck",       T = "UpgradeUpgradeMax", A = {"Bread", "MoreTierLuck"}},
    {F = "AutoUpgradeCow",              T = "UpgradeAnimal",     A = {"Cow"}},
    {F = "AutoUpgradeChicken",          T = "UpgradeAnimal",     A = {"Chicken"}},
    {F = "AutoBuyCow",                  T = "BuyAnimal",         A = {"Cow", true}},
    {F = "AutoBuyChicken",              T = "BuyAnimal",         A = {"Chicken", true}}
}

task.spawn(function()
    local breadIndex = 1
    while Running do
        task.wait(1.2)
        if NetRemote and Running then
            local attempted = 0
            repeat
                local currentItem = BreadUpgradeList[breadIndex]
                breadIndex = (breadIndex % #BreadUpgradeList) + 1
                attempted = attempted + 1

                if _G[currentItem.F] then
                    pcall(function() 
                        NetRemote:FireServer(currentItem.T, unpack(currentItem.A)) 
                    end)
                    break
                end
            until attempted >= #BreadUpgradeList
        end
    end
end)

-- AUTO DEPOSIT WHEAT LOOP (1-MINUTE INTERVAL)
task.spawn(function()
    while Running do
        task.wait(60.0)
        if _G.AutoDepositWheat and NetRemote and Running then
            pcall(function()
                NetRemote:FireServer("DepositWheat")
            end)
        end
    end
end)

-- BLAZE AUTO-UPGRADE ENGINE
task.spawn(function()
    while Running do
        task.wait(1.0)
        if NetRemote and Running then
            if _G.AutoBlazeMoreBlaze then pcall(function() NetRemote:FireServer("UpgradeUpgradeMax", "Blaze", "MoreBlaze") end) task.wait(0.25) end
            if _G.AutoBlazeMoreFire then pcall(function() NetRemote:FireServer("UpgradeUpgradeMax", "Blaze", "MoreFire") end) task.wait(0.25) end
            if _G.AutoBlazeMoreOof then pcall(function() NetRemote:FireServer("UpgradeUpgradeMax", "Blaze", "MoreOof") end) task.wait(0.25) end
            if _G.AutoBlazeMoreOofs then pcall(function() NetRemote:FireServer("UpgradeUpgradeMax", "Blaze", "MoreOofs") end) task.wait(0.25) end
            if _G.AutoBlazeMoreBulk then pcall(function() NetRemote:FireServer("UpgradeUpgradeMax", "Blaze", "MoreBulk") end) task.wait(0.25) end
        end
    end
end)

-- CHEST OPENER ENGINE
task.spawn(function()
    while Running do
        task.wait(1.2)
        if NetRemote and Running then
            if _G.AutoOpenT1Chest then
                pcall(function() NetRemote:FireServer("OpenChest", "T1TrialChest", 10) end)
            end
            if _G.AutoOpenT2Chest then
                pcall(function() NetRemote:FireServer("OpenChest", "T2TrialChest", 10) end)
            end
        end
    end
end)

-- DIRECT PRESTIGE REMOTE LOOP
task.spawn(function()
    while Running do
        task.wait(5.0)
        if _G.AutoPrestige and NetRemote and Running then
            pcall(function()
                NetRemote:FireServer("Prestige")
            end)
        end
    end
end)

-- BLAZE CONVERT LOOP
task.spawn(function()
    local targetCooldown = math.random(270, 330) local secondsElapsed = 0
    while Running do
        task.wait(1)
        if Running and _G.AutoBlazeConvert and NetRemote then
            secondsElapsed = secondsElapsed + 1
            if secondsElapsed >= targetCooldown then
                secondsElapsed = 0 targetCooldown = math.random(270, 330)
                pcall(function() NetRemote:FireServer("Blaze") end)
            end
        else secondsElapsed = 0 end
    end
end)

--======================================================================================
-- CONNECTORS, KILL SWITCH & DRAG CONTROLLER
--======================================================================================
local function tStateV2(b, v) 
    _G[v] = not _G[v] 
    b.Text = _G[v] and "ACTIVE" or "DISABLED" 
    b.BackgroundColor3 = _G[v] and Color3.fromRGB(20, 60, 20) or Color3.fromRGB(60, 20, 20) 
    b.TextColor3 = _G[v] and Color3.fromRGB(120, 255, 120) or Color3.fromRGB(255, 120, 120) 
end

togglePharaoh.MouseButton1Click:Connect(function() tStateV2(togglePharaoh, "AutoUpgradePharaoh") end) 
toggleAFK.MouseButton1Click:Connect(function() tStateV2(toggleAFK, "AntiAFK") end) 
togglePrestige.MouseButton1Click:Connect(function() tStateV2(togglePrestige, "AutoPrestige") end)
toggleStarter.MouseButton1Click:Connect(function() tStateV2(toggleStarter, "AutoUpgradeStarter") end) 
toggleCooker.MouseButton1Click:Connect(function() tStateV2(toggleCooker, "AutoUpgradeCooker") end) 
toggleFarmer.MouseButton1Click:Connect(function() tStateV2(toggleFarmer, "AutoUpgradeFarmer") end) 
toggleMagician.MouseButton1Click:Connect(function() tStateV2(toggleMagician, "AutoUpgradeMagician") end) 
toggleArcher.MouseButton1Click:Connect(function() tStateV2(toggleArcher, "AutoUpgradeArcher") end) 
toggleSoldier.MouseButton1Click:Connect(function() tStateV2(toggleSoldier, "AutoUpgradeSoldier") end) 
toggleMoreOof.MouseButton1Click:Connect(function() tStateV2(toggleMoreOof, "AutoUpgradeMoreOof") end) 
toggleFasterNoobs.MouseButton1Click:Connect(function() tStateV2(toggleFasterNoobs, "AutoUpgradeFasterNoobs") end)

-- HACKER TOGGLE CONNECTORS (1 to 4)
toggleHacker1.MouseButton1Click:Connect(function() tStateV2(toggleHacker1, "AutoUpgradeHacker1") end)
toggleHacker2.MouseButton1Click:Connect(function() tStateV2(toggleHacker2, "AutoUpgradeHacker2") end)
toggleHacker3.MouseButton1Click:Connect(function() tStateV2(toggleHacker3, "AutoUpgradeHacker3") end)
toggleHacker4.MouseButton1Click:Connect(function() tStateV2(toggleHacker4, "AutoUpgradeHacker4") end)

-- FOOTBALL TOGGLE CONNECTORS
toggleGoalkeeper.MouseButton1Click:Connect(function() tStateV2(toggleGoalkeeper, "AutoUpgradeGoalkeeper") end)
toggleLeftCenterBack.MouseButton1Click:Connect(function() tStateV2(toggleLeftCenterBack, "AutoUpgradeLeftCenterBack") end)
toggleRightCenterBack.MouseButton1Click:Connect(function() tStateV2(toggleRightCenterBack, "AutoUpgradeRightCenterBack") end)
toggleRightBack.MouseButton1Click:Connect(function() tStateV2(toggleRightBack, "AutoUpgradeRightBack") end)
toggleLeftDefensiveMid.MouseButton1Click:Connect(function() tStateV2(toggleLeftDefensiveMid, "AutoUpgradeLeftDefensiveMid") end)
toggleRightDefensiveMid.MouseButton1Click:Connect(function() tStateV2(toggleRightDefensiveMid, "AutoUpgradeRightDefensiveMid") end)
toggleAttackingMid.MouseButton1Click:Connect(function() tStateV2(toggleAttackingMid, "AutoUpgradeAttackingMid") end)
toggleLeftWing.MouseButton1Click:Connect(function() tStateV2(toggleLeftWing, "AutoUpgradeLeftWing") end)
toggleRightWing.MouseButton1Click:Connect(function() tStateV2(toggleRightWing, "AutoUpgradeRightWing") end)
toggleStriker.MouseButton1Click:Connect(function() tStateV2(toggleStriker, "AutoUpgradeStriker") end)

toggleScoreGoal.MouseButton1Click:Connect(function() tStateV2(toggleScoreGoal, "AutoScoreGoal") end)
toggleMoreGoals.MouseButton1Click:Connect(function() tStateV2(toggleMoreGoals, "AutoGoalsMoreGoals") end)
toggleGoalsRuneBulk.MouseButton1Click:Connect(function() tStateV2(toggleGoalsRuneBulk, "AutoGoalsRuneBulk") end)
toggleGoalsRuneLuck.MouseButton1Click:Connect(function() tStateV2(toggleGoalsRuneLuck, "AutoGoalsRuneLuck") end)
toggleAutoBuyKicker.MouseButton1Click:Connect(function() tStateV2(toggleAutoBuyKicker, "AutoBuyAutoKick") end)
toggleFootballTree.MouseButton1Click:Connect(function() tStateV2(toggleFootballTree, "AutoFootballTree") end)
toggleClaimTrophies.MouseButton1Click:Connect(function() tStateV2(toggleClaimTrophies, "AutoClaimTrophies") end)

toggleRebirthOof.MouseButton1Click:Connect(function() tStateV2(toggleRebirthOof, "AutoRebirthMoreOof") end) 
toggleRebirthRebirth.MouseButton1Click:Connect(function() tStateV2(toggleRebirthRebirth, "AutoRebirthMoreRebirth") end) 
toggleRebirthFire.MouseButton1Click:Connect(function() tStateV2(toggleRebirthFire, "AutoRebirthMoreFire") end)

toggleFireFire.MouseButton1Click:Connect(function() tStateV2(toggleFireFire, "AutoFireMoreFire") end)
toggleFireBulk.MouseButton1Click:Connect(function() tStateV2(toggleFireBulk, "AutoFireMoreBulk") end)
toggleFireOof.MouseButton1Click:Connect(function() tStateV2(toggleFireOof, "AutoFireMoreOof") end)
toggleFireRebirth.MouseButton1Click:Connect(function() tStateV2(toggleFireRebirth, "AutoFireMoreRebirth") end)
toggleFireTierLuck.MouseButton1Click:Connect(function() tStateV2(toggleFireTierLuck, "AutoFireMoreTierLuck") end)
toggleFireCashBonus.MouseButton1Click:Connect(function() tStateV2(toggleFireCashBonus, "AutoFireMoreCashBonus") end)

-- FARM & ANIMAL TOGGLES
toggleDepositWheat.MouseButton1Click:Connect(function() tStateV2(toggleDepositWheat, "AutoDepositWheat") end)
toggleBreadMoreBread.MouseButton1Click:Connect(function() tStateV2(toggleBreadMoreBread, "AutoBreadMoreBread") end)
toggleBreadMoreBread2.MouseButton1Click:Connect(function() tStateV2(toggleBreadMoreBread2, "AutoBreadMoreBread2") end)
toggleBreadMoreWheat.MouseButton1Click:Connect(function() tStateV2(toggleBreadMoreWheat, "AutoBreadMoreWheat") end)
toggleBreadBiggerWheatDeposit.MouseButton1Click:Connect(function() tStateV2(toggleBreadBiggerWheatDeposit, "AutoBreadBiggerWheatDeposit") end)
toggleBreadFasterWheatConversion.MouseButton1Click:Connect(function() tStateV2(toggleBreadFasterWheatConversion, "AutoBreadFasterWheatConversion") end)
toggleBreadMoreConsumption.MouseButton1Click:Connect(function() tStateV2(toggleBreadMoreConsumption, "AutoBreadMoreConsumption") end)
toggleBreadMoreRuneLuck.MouseButton1Click:Connect(function() tStateV2(toggleBreadMoreRuneLuck, "AutoBreadMoreRuneLuck") end)
toggleBreadMoreTierLuck.MouseButton1Click:Connect(function() tStateV2(toggleBreadMoreTierLuck, "AutoBreadMoreTierLuck") end)
toggleUpgradeCow.MouseButton1Click:Connect(function() tStateV2(toggleUpgradeCow, "AutoUpgradeCow") end)
toggleUpgradeChicken.MouseButton1Click:Connect(function() tStateV2(toggleUpgradeChicken, "AutoUpgradeChicken") end)
toggleBuyCow.MouseButton1Click:Connect(function() tStateV2(toggleBuyCow, "AutoBuyCow") end)
toggleBuyChicken.MouseButton1Click:Connect(function() tStateV2(toggleBuyChicken, "AutoBuyChicken") end)

toggleRebirthTimerCard.MouseButton1Click:Connect(function() tStateV2(toggleRebirthTimerCard, "AutoRebirthTimer") end) 
toggleAutoBlazeConvert.MouseButton1Click:Connect(function() tStateV2(toggleAutoBlazeConvert, "AutoBlazeConvert") end)

toggleBlazeMoreBlaze.MouseButton1Click:Connect(function() tStateV2(toggleBlazeMoreBlaze, "AutoBlazeMoreBlaze") end) 
toggleBlazeMoreFire.MouseButton1Click:Connect(function() tStateV2(toggleBlazeMoreFire, "AutoBlazeMoreFire") end) 
toggleBlazeMoreOof.MouseButton1Click:Connect(function() tStateV2(toggleBlazeMoreOof, "AutoBlazeMoreOof") end)
toggleBlazeMoreOofs.MouseButton1Click:Connect(function() tStateV2(toggleBlazeMoreOofs, "AutoBlazeMoreOofs") end)
toggleBlazeMoreBulk.MouseButton1Click:Connect(function() tStateV2(toggleBlazeMoreBulk, "AutoBlazeMoreBulk") end)

toggleAutoFarmCash.MouseButton1Click:Connect(function() tStateV2(toggleAutoFarmCash, "AutoFarmCash") end)
toggleCashMoreCash.MouseButton1Click:Connect(function() tStateV2(toggleCashMoreCash, "AutoUpgradeMoreCash") end)
toggleCashFasterDropper.MouseButton1Click:Connect(function() tStateV2(toggleCashFasterDropper, "AutoUpgradeFasterDropper") end)
toggleCashMoreRuneLuck.MouseButton1Click:Connect(function() tStateV2(toggleCashMoreRuneLuck, "AutoUpgradeMoreRuneLuck") end)

toggleRollBasicRuneCard.MouseButton1Click:Connect(function() tStateV2(toggleRollBasicRuneCard, "AutoRollBasicRune") end)
toggleRollSuperRuneCard.MouseButton1Click:Connect(function() tStateV2(toggleRollSuperRuneCard, "AutoRollSuperRune") end)
toggleRollAdvancedRuneCard.MouseButton1Click:Connect(function() tStateV2(toggleRollAdvancedRuneCard, "AutoRollAdvancedRune") end)
toggleRollCosmicRuneCard.MouseButton1Click:Connect(function() tStateV2(toggleRollCosmicRuneCard, "AutoRollCosmicRune") end)

toggleClassicCapsule.MouseButton1Click:Connect(function() tStateV2(toggleClassicCapsule, "AutoOpenClassicCapsule") end)

toggleOpenT1ChestCard.MouseButton1Click:Connect(function() tStateV2(toggleOpenT1ChestCard, "AutoOpenT1Chest") end)
toggleOpenT2ChestCard.MouseButton1Click:Connect(function() tStateV2(toggleOpenT2ChestCard, "AutoOpenT2Chest") end)

toggleKillSwitch.MouseButton1Click:Connect(function()
    Running = false 
    getgenv().DominateHubLoaded = nil 
    for k, _ in pairs(_G) do if type(k) == "string" and (k:sub(1,4) == "Auto" or k == "AntiAFK") then _G[k] = false end end
    pcall(function() local cam = workspace.CurrentCamera if cam then cam.CameraType = Enum.CameraType.Custom end end) sg:Destroy()
end)

local function mainRoute(pOpen, bActive) 
    realm1MasterPage.Visible, realm2Page.Visible, realm3Page.Visible, footballPage.Visible, runesPage.Visible, capsulesPage.Visible, settingsPage.Visible = false, false, false, false, false, false, false; pOpen.Visible = true; 
    local tabs = {tabRealm1, tabRealm2, tabRealm3, tabFootball, tabRunes, tabCapsules, tabSettings}
    for _, t in ipairs(tabs) do t.BackgroundColor3, t.TextColor3 = Color3.fromRGB(45, 45, 45), Color3.fromRGB(170, 170, 170) end
    bActive.BackgroundColor3, bActive.TextColor3 = Color3.fromRGB(220, 220, 225), Color3.fromRGB(15, 15, 15) 
end
tabRealm1.MouseButton1Click:Connect(function() mainRoute(realm1MasterPage, tabRealm1) end) 
tabRealm2.MouseButton1Click:Connect(function() mainRoute(realm2Page, tabRealm2) end) 
tabRealm3.MouseButton1Click:Connect(function() mainRoute(realm3Page, tabRealm3) end) 
tabFootball.MouseButton1Click:Connect(function() mainRoute(footballPage, tabFootball) end)
tabRunes.MouseButton1Click:Connect(function() mainRoute(runesPage, tabRunes) end) 
tabCapsules.MouseButton1Click:Connect(function() mainRoute(capsulesPage, tabCapsules) end)
tabSettings.MouseButton1Click:Connect(function() mainRoute(settingsPage, tabSettings) end)

-- Football Sub-Tab Router
local function footballRoute(targetScroll, activeBtn)
    local scrolls = {footballNoobScroll, footballUpgradeScroll}
    local btns = {footballSubBtnNoobs, footballSubBtnUpgrades}
    for i, s in ipairs(scrolls) do
        s.Visible = (s == targetScroll)
        if s == targetScroll then
            btns[i].BackgroundColor3, btns[i].TextColor3 = Color3.fromRGB(230, 230, 235), Color3.fromRGB(15, 15, 15)
        else
            btns[i].BackgroundColor3, btns[i].TextColor3 = Color3.fromRGB(45, 45, 45), Color3.fromRGB(170, 170, 170)
        end
    end
end
footballSubBtnNoobs.MouseButton1Click:Connect(function() footballRoute(footballNoobScroll, footballSubBtnNoobs) end)
footballSubBtnUpgrades.MouseButton1Click:Connect(function() footballRoute(footballUpgradeScroll, footballSubBtnUpgrades) end)

-- Runes Sub-Tab Router
local function runesRoute(targetScroll, activeBtn)
    local scrolls = {runesScroll1, runesScroll2, runesScroll3, runesScrollEvents}
    local btns = {runesSubBtn1, runesSubBtn2, runesSubBtn3, runesSubBtnEvents}
    for i, s in ipairs(scrolls) do
        s.Visible = (s == targetScroll)
        if s == targetScroll then
            btns[i].BackgroundColor3, btns[i].TextColor3 = Color3.fromRGB(230, 230, 235), Color3.fromRGB(15, 15, 15)
        else
            btns[i].BackgroundColor3, btns[i].TextColor3 = Color3.fromRGB(45, 45, 45), Color3.fromRGB(170, 170, 170)
        end
    end
end
runesSubBtn1.MouseButton1Click:Connect(function() runesRoute(runesScroll1, runesSubBtn1) end)
runesSubBtn2.MouseButton1Click:Connect(function() runesRoute(runesScroll2, runesSubBtn2) end)
runesSubBtn3.MouseButton1Click:Connect(function() runesRoute(runesScroll3, runesSubBtn3) end)
runesSubBtnEvents.MouseButton1Click:Connect(function() runesRoute(runesScrollEvents, runesSubBtnEvents) end)

-- Realm 1 Sub-Tab Router
local function route(targetScroll)
    local scrolls = {realm1NoobScroll, realm1UpgradeScroll, realm1RebirthScroll, realm1FireScroll, realm1BlazeScroll, realm1BreadScroll, realm1CashScroll, realm1HackerScroll}
    local btns = {subBtnNoobs, subBtnOof, subBtnRebirth, subBtnFire, subBtnBlaze, subBtnFarm, subBtnCash, subBtnHacker}
    for i, s in ipairs(scrolls) do
        s.Visible = (s == targetScroll)
        if s == targetScroll then
            btns[i].BackgroundColor3, btns[i].TextColor3 = Color3.fromRGB(230, 230, 235), Color3.fromRGB(15, 15, 15)
        else
            btns[i].BackgroundColor3, btns[i].TextColor3 = Color3.fromRGB(45, 45, 45), Color3.fromRGB(170, 170, 170)
        end
    end
end
subBtnNoobs.MouseButton1Click:Connect(function() route(realm1NoobScroll) end)
subBtnOof.MouseButton1Click:Connect(function() route(realm1UpgradeScroll) end)
subBtnRebirth.MouseButton1Click:Connect(function() route(realm1RebirthScroll) end)
subBtnFire.MouseButton1Click:Connect(function() route(realm1FireScroll) end)
subBtnBlaze.MouseButton1Click:Connect(function() route(realm1BlazeScroll) end)
subBtnFarm.MouseButton1Click:Connect(function() route(realm1BreadScroll) end)
subBtnCash.MouseButton1Click:Connect(function() route(realm1CashScroll) end)
subBtnHacker.MouseButton1Click:Connect(function() route(realm1HackerScroll) end)

minBtn.MouseButton1Click:Connect(function() 
    mainFrame.Visible = not mainFrame.Visible minBtn.Text = mainFrame.Visible and "Hide UI" or "Lukes Script" 
    minBtn.TextColor3 = mainFrame.Visible and Color3.fromRGB(0, 136, 255) or Color3.fromRGB(0, 215, 110) 
end)

local dragging, dragInput, dragStart, startPos
mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true dragStart = input.Position startPos = mainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
mainFrame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

print("[Dominate Hub] Hardcoded Capsule Engine Fully Loaded!")
