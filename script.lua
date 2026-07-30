--======================================================================================
-- BROSWE HUB | PART 1 OF 6 (GLOBAL PARAMETERS & SCOPE DECLARATION)
--======================================================================================
local player = game:GetService("Players").LocalPlayer
local NetRemote = game:GetService("ReplicatedStorage"):WaitForChild("__Net"):WaitForChild("MainRemote")
local vu = game:GetService("VirtualUser")

-- Initialize Configurations
_G.AutoEasyTrails, _G.AutoMediumTrails, _G.AutoHardTrails, _G.AutoCapsule, _G.AutoUpgradePharaoh, _G.AntiAFK, _G.AutoPrestige = false, false, false, false, false, true, false
_G.AutoUpgradeStarter, _G.AutoUpgradeCooker, _G.AutoUpgradeExplorer, _G.AutoUpgradeMagician, _G.AutoUpgradeArcher, _G.AutoUpgradeSoldier, _G.AutoUpgradeMoreOof, _G.AutoUpgradeFasterNoobs = false, false, false, false, false, false, false, false
_G.AutoRebirthMoreOof, _G.AutoRebirthMoreRebirth, _G.AutoRebirthMoreFire = false, false, false
_G.AutoFireMoreFire, _G.AutoFireMoreOof, _G.AutoFireMoreRebirth, _G.AutoFireMoreBulk = false, false, false, false
_G.AutoRebirthTimer, _G.AutoRuneBasic = false, false
_G.AutoBlazeMoreBlaze, _G.AutoBlazeMoreFire, _G.AutoBlazeMoreOof = false, false, false
_G.AutoBuildFire = false

player.Idled:Connect(function()
    if _G.AntiAFK then
        vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame) task.wait(1) vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end
end)

-- Main Frame Structure Setup
local sg = Instance.new("ScreenGui") sg.Name = "LukesBrosweHubMirror" sg.Parent = player:WaitForChild("PlayerGui") sg.ResetOnSpawn = false
mainFrame = Instance.new("Frame") mainFrame.Size = UDim2.new(0, 460, 0, 360) mainFrame.Position = UDim2.new(0.5, -230, 0.5, -180) mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20) mainFrame.BackgroundTransparency = 0.15; mainFrame.BorderSizePixel = 0; mainFrame.Parent = sg
local mainCorner = Instance.new("UICorner") mainCorner.CornerRadius = UDim.new(0, 10) mainCorner.Parent = mainFrame
--======================================================================================
-- BROSWE HUB | PART 2 OF 6 (MASTER VISIBILITY LAYERS REGISTRY)
--======================================================================================
trialPage = Instance.new("Frame") trialPage.Size = UDim2.new(1, -20, 1, -85) trialPage.Position = UDim2.new(0, 10, 0, 80) trialPage.BackgroundTransparency = 1; trialPage.Visible = true; trialPage.Parent = mainFrame
capsulePage = Instance.new("Frame") capsulePage.Size = UDim2.new(1, -20, 1, -85) capsulePage.Position = UDim2.new(0, 10, 0, 80) capsulePage.BackgroundTransparency = 1; capsulePage.Visible = false; capsulePage.Parent = mainFrame
realm1MasterPage = Instance.new("Frame") realm1MasterPage.Size = UDim2.new(1, -20, 1, -85) realm1MasterPage.Position = UDim2.new(0, 10, 0, 80) realm1MasterPage.BackgroundTransparency = 1; realm1MasterPage.Visible = false; realm1MasterPage.Parent = mainFrame
realm3Page = Instance.new("Frame") realm3Page.Size = UDim2.new(1, -20, 1, -85) realm3Page.Position = UDim2.new(0, 10, 0, 80) realm3Page.BackgroundTransparency = 1; realm3Page.Visible = false; realm3Page.Parent = mainFrame
settingsPage = Instance.new("Frame") settingsPage.Size = UDim2.new(1, -20, 1, -85) settingsPage.Position = UDim2.new(0, 10, 0, 80) settingsPage.BackgroundTransparency = 1; settingsPage.Visible = false; settingsPage.Parent = mainFrame
runesPage = Instance.new("Frame") runesPage.Size = UDim2.new(1, -20, 1, -85) runesPage.Position = UDim2.new(0, 10, 0, 80) runesPage.BackgroundTransparency = 1; runesPage.Visible = false; runesPage.Parent = mainFrame

local headerTitle = Instance.new("TextLabel") headerTitle.Size = UDim2.new(1, -20, 0, 35) headerTitle.Position = UDim2.new(0, 12, 0, 4) headerTitle.BackgroundTransparency = 1; headerTitle.TextColor3 = Color3.fromRGB(245, 245, 250) headerTitle.TextSize = 15; headerTitle.Font = Enum.Font.SourceSansBold; headerTitle.Text = "Broswe Hub | Noob Incremental" headerTitle.TextXAlignment = Enum.TextXAlignment.Left; headerTitle.Parent = mainFrame

minBtn = Instance.new("TextButton") minBtn.Size = UDim2.new(0, 95, 0, 24) minBtn.Position = UDim2.new(0.5, -47, 0.01, 0) minBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25) minBtn.TextColor3 = Color3.fromRGB(0, 136, 255) minBtn.TextSize = 12; minBtn.Font = Enum.Font.SourceSansBold; minBtn.Text = "Hide UI" minBtn.Parent = sg
local minCorner = Instance.new("UICorner") minCorner.CornerRadius = UDim.new(0, 5) minCorner.Parent = minBtn
--======================================================================================
-- BROSWE HUB | PART 3 OF 6 (MENU BUTTON BAR ELEMENTS LOADING)
--======================================================================================
local tabList = Instance.new("Frame") tabList.Size = UDim2.new(1, -20, 0, 32) tabList.Position = UDim2.new(0, 10, 0, 40) tabList.BackgroundTransparency = 1; tabList.Parent = mainFrame
tabTrial = Instance.new("TextButton") tabTrial.Size = UDim2.new(0, 55, 1, 0) tabTrial.Position = UDim2.new(0, 5, 0, 0) tabTrial.BackgroundColor3 = Color3.fromRGB(230, 230, 235) tabTrial.TextColor3 = Color3.fromRGB(15, 15, 15) tabTrial.TextSize = 12; tabTrial.Font = Enum.Font.SourceSansBold; tabTrial.Text = "Trial" tabTrial.Parent = tabList
tabCapsules = Instance.new("TextButton") tabCapsules.Size = UDim2.new(0, 70, 1, 0) tabCapsules.Position = UDim2.new(0, 65, 0, 0) tabCapsules.BackgroundColor3 = Color3.fromRGB(45, 45, 45) tabCapsules.TextColor3 = Color3.fromRGB(170, 170, 170) tabCapsules.TextSize = 12; tabCapsules.Font = Enum.Font.SourceSansBold; tabCapsules.Text = "Capsules" tabCapsules.Parent = tabList
tabRealm1 = Instance.new("TextButton") tabRealm1.Size = UDim2.new(0, 70, 1, 0) tabRealm1.Position = UDim2.new(0, 140, 0, 0) tabRealm1.BackgroundColor3 = Color3.fromRGB(45, 45, 45) tabRealm1.TextColor3 = Color3.fromRGB(170, 170, 170) tabRealm1.TextSize = 12; tabRealm1.Font = Enum.Font.SourceSansBold; tabRealm1.Text = "Realm 1" tabRealm1.Parent = tabList
tabRealm3 = Instance.new("TextButton") tabRealm3.Size = UDim2.new(0, 70, 1, 0) tabRealm3.Position = UDim2.new(0, 215, 0, 0) tabRealm3.BackgroundColor3 = Color3.fromRGB(45, 45, 45) tabRealm3.TextColor3 = Color3.fromRGB(170, 170, 170) tabRealm3.TextSize = 12; tabRealm3.Font = Enum.Font.SourceSansBold; tabRealm3.Text = "Realm 3" tabRealm3.Parent = tabList
tabSettings = Instance.new("TextButton") tabSettings.Size = UDim2.new(0, 70, 1, 0) tabSettings.Position = UDim2.new(0, 290, 0, 0) tabSettings.BackgroundColor3 = Color3.fromRGB(45, 45, 45) tabSettings.TextColor3 = Color3.fromRGB(170, 170, 170) tabSettings.TextSize = 12; tabSettings.Font = Enum.Font.SourceSansBold; tabSettings.Text = "Settings" tabSettings.Parent = tabList
tabRunes = Instance.new("TextButton") tabRunes.Size = UDim2.new(0, 60, 1, 0) tabRunes.Position = UDim2.new(0, 365, 0, 0) tabRunes.BackgroundColor3 = Color3.fromRGB(45, 45, 45) tabRunes.TextColor3 = Color3.fromRGB(170, 170, 170) tabRunes.TextSize = 12; tabRunes.Font = Enum.Font.SourceSansBold; tabRunes.Text = "Runes" tabRunes.Parent = tabList

Instance.new("UICorner", tabTrial).CornerRadius = UDim.new(0, 16) Instance.new("UICorner", tabCapsules).CornerRadius = UDim.new(0, 16) Instance.new("UICorner", tabRealm1).CornerRadius = UDim.new(0, 16) Instance.new("UICorner", tabRealm3).CornerRadius = UDim.new(0, 16) Instance.new("UICorner", tabSettings).CornerRadius = UDim.new(0, 16) Instance.new("UICorner", tabRunes).CornerRadius = UDim.new(0, 16)
--======================================================================================
-- BROSWE HUB | PART 4 OF 6 (SUB-MENU CONTROLS AND INNER GENERATION SETUP)
--======================================================================================
local subTabList = Instance.new("Frame") subTabList.Size = UDim2.new(1, 0, 0, 25) subTabList.Position = UDim2.new(0, 0, 0, 0) subTabList.BackgroundTransparency = 1; subTabList.Parent = realm1MasterPage
subBtnNoobs = Instance.new("TextButton") subBtnNoobs.Size = UDim2.new(0, 50, 1, 0) subBtnNoobs.Position = UDim2.new(0, 2, 0, 0) subBtnNoobs.BackgroundColor3 = Color3.fromRGB(230, 230, 235) subBtnNoobs.TextColor3 = Color3.fromRGB(15, 15, 15) subBtnNoobs.TextSize = 10; subBtnNoobs.Font = Enum.Font.SourceSansBold; subBtnNoobs.Text = "Noobs" subBtnNoobs.Parent = subTabList
subBtnOof = Instance.new("TextButton") subBtnOof.Size = UDim2.new(0, 75, 1, 0) subBtnOof.Position = UDim2.new(0, 54, 0, 0) subBtnOof.BackgroundColor3 = Color3.fromRGB(45, 45, 45) subBtnOof.TextColor3 = Color3.fromRGB(170, 170, 170) subBtnOof.TextSize = 10; subBtnOof.Font = Enum.Font.SourceSansBold; subBtnOof.Text = "Oof Upgrades" subBtnOof.Parent = subTabList
subBtnRebirth = Instance.new("TextButton") subBtnRebirth.Size = UDim2.new(0, 95, 1, 0) subBtnRebirth.Position = UDim2.new(0, 131, 0, 0) subBtnRebirth.BackgroundColor3 = Color3.fromRGB(45, 45, 45) subBtnRebirth.TextColor3 = Color3.fromRGB(170, 170, 170) subBtnRebirth.TextSize = 10; subBtnRebirth.Font = Enum.Font.SourceSansBold; subBtnRebirth.Text = "Rebirth Upgrades" subBtnRebirth.Parent = subTabList
subBtnFire = Instance.new("TextButton") subBtnFire.Size = UDim2.new(0, 80, 1, 0) subBtnFire.Position = UDim2.new(0, 228, 0, 0) subBtnFire.BackgroundColor3 = Color3.fromRGB(45, 45, 45) subBtnFire.TextColor3 = Color3.fromRGB(170, 170, 170) subBtnFire.TextSize = 10; subBtnFire.Font = Enum.Font.SourceSansBold; subBtnFire.Text = "Fire Upgrades" subBtnFire.Parent = subTabList
subBtnBlaze = Instance.new("TextButton") subBtnBlaze.Size = UDim2.new(0, 65, 1, 0) subBtnBlaze.Position = UDim2.new(0, 310, 0, 0) subBtnBlaze.BackgroundColor3 = Color3.fromRGB(45, 45, 45) subBtnBlaze.TextColor3 = Color3.fromRGB(170, 170, 170) subBtnBlaze.TextSize = 10; subBtnBlaze.Font = Enum.Font.SourceSansBold; subBtnBlaze.Text = "Blaze" subBtnBlaze.Parent = subTabList

Instance.new("UICorner", subBtnNoobs).CornerRadius = UDim.new(0, 5) Instance.new("UICorner", subBtnOof).CornerRadius = UDim.new(0, 5) Instance.new("UICorner", subBtnRebirth).CornerRadius = UDim.new(0, 5) Instance.new("UICorner", subBtnFire).CornerRadius = UDim.new(0, 5) Instance.new("UICorner", subBtnBlaze).CornerRadius = UDim.new(0, 5)

local function makeScroll(canvas) 
    local s = Instance.new("ScrollingFrame") s.Size = UDim2.new(1, 0, 1, -30) s.Position = UDim2.new(0, 0, 0, 30) s.BackgroundTransparency = 1; s.BorderSizePixel = 0; s.CanvasSize = UDim2.new(0, 0, 0, canvas) s.ScrollBarThickness = 3; s.ScrollBarImageColor3 = Color3.fromRGB(0, 136, 255) s.Visible = false; s.Parent = realm1MasterPage return s 
end
realm1NoobScroll = makeScroll(310) realm1NoobScroll.Visible = true
realm1UpgradeScroll = makeScroll(110)
realm1RebirthScroll = makeScroll(160)
realm1FireScroll = makeScroll(210)
realm1BlazeScroll = makeScroll(160)
--======================================================================================
-- BROSWE HUB | PART 5 OF 6 (COMPONENT CONSTRUCTOR UTILITIES LOADING)
--======================================================================================
local function gridRow(txt, pos, page)
    local f = Instance.new("Frame") f.Size = UDim2.new(1, -10, 0, 36) f.Position = UDim2.new(0, 5, 0, (pos-1)*41+5) f.BackgroundColor3 = Color3.fromRGB(30, 30, 30) f.BorderSizePixel = 0; f.Parent = page
    local l = Instance.new("TextLabel") l.Size = UDim2.new(0.7, 0, 1, 0) l.Position = UDim2.new(0, 12, 0, 0) l.BackgroundTransparency = 1; l.TextColor3 = Color3.fromRGB(220, 220, 225) l.TextSize = 13; l.Font = Enum.Font.SourceSans; l.Text = txt; l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = f
    local b = Instance.new("TextButton") b.Size = UDim2.new(0, 75, 0, 22) b.Position = UDim2.new(1, -85, 0.5, -11) b.BackgroundColor3 = Color3.fromRGB(60, 20, 20) b.TextColor3 = Color3.fromRGB(255, 120, 120) b.TextSize = 11; b.Font = Enum.Font.SourceSansBold; b.Text = "DISABLED" b.Parent = f
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 5) Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5) return b
end

local function makeSubRow(label, idx, scr)
    local f = Instance.new("Frame") f.Size = UDim2.new(1, -12, 0, 42) f.Position = UDim2.new(0, 5, 0, (idx-1)*48+5) f.BackgroundColor3 = Color3.fromRGB(30, 30, 30) f.BorderSizePixel = 0; f.Parent = scr
    local l = Instance.new("TextLabel") l.Size = UDim2.new(0.7, 0, 1, 0) l.Position = UDim2.new(0, 12, 0, 0) l.BackgroundTransparency = 1; l.TextColor3 = Color3.fromRGB(220, 220, 225) l.TextSize = 13; l.Font = Enum.Font.SourceSans; l.Text = label; l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = f
    local b = Instance.new("TextButton") b.Size = UDim2.new(0, 75, 0, 24) b.Position = UDim2.new(1, -85, 0.5, -12) b.BackgroundColor3 = Color3.fromRGB(60, 20, 20) b.TextColor3 = Color3.fromRGB(255, 120, 120) b.TextSize = 11; b.Font = Enum.Font.SourceSansBold; b.Text = "DISABLED" b.Parent = f
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 5) Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5) return b
end
--======================================================================================
-- BROSWE HUB | PART 6 OF 6 (MENU LIST ASSEMBLIES INSTANTIATIONS)
--======================================================================================
toggleEasy = gridRow("Auto Trial (Easy) - Fast Entry", 1, trialPage)
toggleMed = gridRow("Auto Trial (Medium) - Progress Entry", 2, trialPage)
toggleHard = gridRow("Auto Trial (Hard) - Rapid Chain", 3, trialPage)
toggleTrailCapsule = gridRow("Auto Open Capsule After Trial (Ancient)", 4, trialPage)
toggleStandaloneCapsule = gridRow("Open Ancient Capsule", 1, capsulePage)
toggleStandaloneCapsule.Size = UDim2.new(0, 75, 0, 26) toggleStandaloneCapsule.Position = UDim2.new(1, -85, 0.5, -13)

toggleStarter = makeSubRow("Starter Noob Auto Upgrade", 1, realm1NoobScroll)
toggleCooker = makeSubRow("Cooker Noob Auto Upgrade", 2, realm1NoobScroll)
toggleExplorer = makeSubRow("Explorer Noob Auto Upgrade", 3, realm1NoobScroll)
toggleMagician = makeSubRow("Magician Noob Auto Upgrade", 4, realm1NoobScroll)
toggleArcher = makeSubRow("Archer Noob Auto Upgrade", 5, realm1NoobScroll)
toggleSoldier = makeSubRow("Soldier Noob Auto Upgrade", 6, realm1NoobScroll)

toggleMoreOof = makeSubRow("More Oof Auto Upgrade", 1, realm1UpgradeScroll)
toggleFasterNoobs = makeSubRow("Faster Noobs Auto Upgrade", 2, realm1UpgradeScroll)
toggleRebirthOof = makeSubRow("More Oof (Rebirth)", 1, realm1RebirthScroll)
toggleRebirthRebirth = makeSubRow("More Rebirth (Rebirth)", 2, realm1RebirthScroll)
toggleRebirthFire = makeSubRow("More Fire (Rebirth)", 3, realm1RebirthScroll)

toggleFireFire = makeSubRow("More Fire (Fire)", 1, realm1FireScroll)
toggleFireOof = makeSubRow("More Oof (Fire)", 2, realm1FireScroll)
toggleFireRebirth = makeSubRow("More Rebirth (Fire)", 3, realm1FireScroll)
toggleFireBulk = makeSubRow("More Bulk (Fire)", 4, realm1FireScroll)
toggleBuildFire = makeSubRow("Auto Build Fire", 5, realm1FireScroll)

toggleBlazeMoreBlaze = makeSubRow("More Blaze (Blaze)", 1, realm1BlazeScroll)
toggleBlazeMoreFire = makeSubRow("More Fire (Blaze)", 2, realm1BlazeScroll)
toggleBlazeMoreOof = makeSubRow("More Oof (Blaze)", 3, realm1BlazeScroll)

togglePharaoh = gridRow("Auto Upgrade Pharaoh (Max)", 1, realm3Page)
togglePharaoh.Size = UDim2.new(0, 75, 0, 26) togglePharaoh.Position = UDim2.new(1, -85, 0.5, -13)
toggleAFK = gridRow("Anti-AFK Safety Disconnect Protection", 1, settingsPage)
toggleAFK.Size = UDim2.new(0, 75, 0, 26) toggleAFK.Position = UDim2.new(1, -85, 0.5, -13) toggleAFK.BackgroundColor3 = Color3.fromRGB(20, 60, 20) toggleAFK.TextColor3 = Color3.fromRGB(120, 255, 120) toggleAFK.Text = "ACTIVE"
togglePrestige = gridRow("Auto Prestige (Server Max Buy Engine)", 2, settingsPage)
togglePrestige.Size = UDim2.new(0, 75, 0, 26) togglePrestige.Position = UDim2.new(1, -85, 0.5, -13)
toggleRebirthTimerCard = gridRow("Auto Rebirth (Every 10-Minute Loop Interval)", 3, settingsPage)
toggleRebirthTimerCard.Size = UDim2.new(0, 75, 0, 26) toggleRebirthTimerCard.Position = UDim2.new(1, -85, 0.5, -13)
toggleKillSwitch = gridRow("EMERGENCY SYSTEM KILL SWITCH", 4, settingsPage)
toggleKillSwitch.Size = UDim2.new(0, 75, 0, 26) toggleKillSwitch.Position = UDim2.new(1, -85, 0.5, -13) toggleKillSwitch.BackgroundColor3 = Color3.fromRGB(120, 20, 20) toggleKillSwitch.TextColor3 = Color3.fromRGB(255, 200, 200) toggleKillSwitch.Text = "TERMINATE"
toggleRuneBasic = gridRow("Teleport Basic Rune (Auto-Collection Loop)", 1, runesPage)
toggleRuneBasic.Size = UDim2.new(0, 75, 0, 26) toggleRuneBasic.Position = UDim2.new(1, -85, 0.5, -13)
