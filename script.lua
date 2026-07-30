--======================================================================================
-- BROSWE HUB | PART 1 OF 9 (CRITICAL ENGINE PATH VERIFICATION)
--======================================================================================
player = game:GetService("Players").LocalPlayer
vu = game:GetService("VirtualUser")
NetRemote = nil

_G.AutoEasyTrails, _G.AutoMediumTrails, _G.AutoHardTrails, _G.AutoCapsule, _G.AutoUpgradePharaoh, _G.AntiAFK, _G.AutoPrestige = false, false, false, false, false, true, false
_G.AutoUpgradeStarter, _G.AutoUpgradeCooker, _G.AutoUpgradeExplorer, _G.AutoUpgradeMagician, _G.AutoUpgradeArcher, _G.AutoUpgradeSoldier, _G.AutoUpgradeMoreOof, _G.AutoUpgradeFasterNoobs = false, false, false, false, false, false, false, false
_G.AutoRebirthMoreOof, _G.AutoRebirthMoreRebirth, _G.AutoRebirthMoreFire = false, false, false
_G.AutoFireMoreFire, _G.AutoFireMoreOof, _G.AutoFireMoreRebirth, _G.AutoFireMoreBulk = false, false, false, false
_G.AutoRebirthTimer, _G.AutoRuneBasic = false, false
_G.AutoBlazeMoreBlaze, _G.AutoBlazeMoreFire, _G.AutoBlazeMoreOof, _G.AutoBlazeConvert = false, false, false, false
_G.AutoBuildFire = false

-- CASH STATE FLAGS REGISTER
_G.AutoFarmCash, _G.AutoUpgradeMoreCash, _G.AutoUpgradeFasterDropper, _G.AutoUpgradeMoreRuneLuck = false, false, false, false

player.Idled:Connect(function()
    if _G.AntiAFK then
        vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame) task.wait(1) vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end
end)

repeat
    local netService = game:GetService("ReplicatedStorage"):WaitForChild("__Net", 5)
    if netService then
        NetRemote = netService:FindFirstChild("MainRemote") or netService:FindFirstChildWhichIsA("RemoteEvent")
    end
    if not NetRemote then task.wait(0.5) end
until NetRemote
--======================================================================================
-- BROSWE HUB | PART 2 OF 9 (MASTER PAGES REGISTRY SETUP)
--======================================================================================
local sg = Instance.new("ScreenGui") sg.Name = "LukesBrosweHubMirror" sg.Parent = player:WaitForChild("PlayerGui") sg.ResetOnSpawn = false
mainFrame = Instance.new("Frame") mainFrame.Size = UDim2.new(0, 460, 0, 360) mainFrame.Position = UDim2.new(0.5, -230, 0.5, -180) mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20) mainFrame.BackgroundTransparency = 0.15; mainFrame.BorderSizePixel = 0; mainFrame.Parent = sg
local mainCorner = Instance.new("UICorner") mainCorner.CornerRadius = UDim.new(0, 10) mainCorner.Parent = mainFrame

trialPage = Instance.new("Frame") trialPage.Size = UDim2.new(1, -20, 1, -85) trialPage.Position = UDim2.new(0, 10, 0, 80) trialPage.BackgroundTransparency = 1; trialPage.Visible = true; trialPage.Parent = mainFrame
capsulePage = Instance.new("Frame") capsulePage.Size = UDim2.new(1, -20, 1, -85) capsulePage.Position = UDim2.new(0, 10, 0, 80) capsulePage.BackgroundTransparency = 1; capsulePage.Visible = false; capsulePage.Parent = mainFrame
realm1MasterPage = Instance.new("Frame") realm1MasterPage.Size = UDim2.new(1, -20, 1, -85) realm1MasterPage.Position = UDim2.new(0, 10, 0, 80) realm1MasterPage.BackgroundTransparency = 1; realm1MasterPage.Visible = false; realm1MasterPage.Parent = mainFrame
realm3Page = Instance.new("Frame") realm3Page.Size = UDim2.new(1, -20, 1, -85) realm3Page.Position = UDim2.new(0, 10, 0, 80) realm3Page.BackgroundTransparency = 1; realm3Page.Visible = false; realm3Page.Parent = mainFrame
settingsPage = Instance.new("Frame") settingsPage.Size = UDim2.new(1, -20, 1, -85) settingsPage.Position = UDim2.new(0, 10, 0, 80) settingsPage.BackgroundTransparency = 1; settingsPage.Visible = false; settingsPage.Parent = mainFrame
runesPage = Instance.new("Frame") runesPage.Size = UDim2.new(1, -20, 1, -85) runesPage.Position = UDim2.new(0, 10, 0, 80) runesPage.BackgroundTransparency = 1; runesPage.Visible = false; runesPage.Parent = mainFrame
--======================================================================================
-- BROSWE HUB | PART 3 OF 9 (INTERFACE INTERACTIVE HEADER AND TABS LOADING)
--======================================================================================
local headerTitle = Instance.new("TextLabel") headerTitle.Size = UDim2.new(1, -20, 0, 35) headerTitle.Position = UDim2.new(0, 12, 0, 4) headerTitle.BackgroundTransparency = 1; headerTitle.TextColor3 = Color3.fromRGB(245, 245, 250) headerTitle.TextSize = 15; headerTitle.Font = Enum.Font.SourceSansBold; headerTitle.Text = "Broswe Hub | Noob Incremental" headerTitle.TextXAlignment = Enum.TextXAlignment.Left; headerTitle.Parent = mainFrame

minBtn = Instance.new("TextButton") minBtn.Size = UDim2.new(0, 95, 0, 24) minBtn.Position = UDim2.new(0.5, -47, 0.01, 0) minBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25) minBtn.TextColor3 = Color3.fromRGB(0, 136, 255) minBtn.TextSize = 12; minBtn.Font = Enum.Font.SourceSansBold; minBtn.Text = "Hide UI" minBtn.Parent = sg
local minCorner = Instance.new("UICorner") minCorner.CornerRadius = UDim.new(0, 5) minCorner.Parent = minBtn

local tabList = Instance.new("Frame") tabList.Size = UDim2.new(1, -20, 0, 32) tabList.Position = UDim2.new(0, 10, 0, 40) tabList.BackgroundTransparency = 1; tabList.Parent = mainFrame
tabTrial = Instance.new("TextButton") tabTrial.Size = UDim2.new(0, 60, 1, 0) tabTrial.Position = UDim2.new(0, 5, 0, 0) tabTrial.BackgroundColor3 = Color3.fromRGB(230, 230, 235) tabTrial.TextColor3 = Color3.fromRGB(15, 15, 15) tabTrial.TextSize = 12; tabTrial.Font = Enum.Font.SourceSansBold; tabTrial.Text = "Trial" tabTrial.Parent = tabList
tabCapsules = Instance.new("TextButton") tabCapsules.Size = UDim2.new(0, 75, 1, 0) tabCapsules.Position = UDim2.new(0, 70, 0, 0) tabCapsules.BackgroundColor3 = Color3.fromRGB(45, 45, 45) tabCapsules.TextColor3 = Color3.fromRGB(170, 170, 170) tabCapsules.TextSize = 12; tabCapsules.Font = Enum.Font.SourceSansBold; tabCapsules.Text = "Capsules" tabCapsules.Parent = tabList
tabRealm1 = Instance.new("TextButton") tabRealm1.Size = UDim2.new(0, 75, 1, 0) tabRealm1.Position = UDim2.new(0, 150, 0, 0) tabRealm1.BackgroundColor3 = Color3.fromRGB(45, 45, 45) tabRealm1.TextColor3 = Color3.fromRGB(170, 170, 170) tabRealm1.TextSize = 12; tabRealm1.Font = Enum.Font.SourceSansBold; tabRealm1.Text = "Realm 1" tabRealm1.Parent = tabList
tabRealm3 = Instance.new("TextButton") tabRealm3.Size = UDim2.new(0, 75, 1, 0) tabRealm3.Position = UDim2.new(0, 230, 0, 0) tabRealm3.BackgroundColor3 = Color3.fromRGB(45, 45, 45) tabRealm3.TextColor3 = Color3.fromRGB(170, 170, 170) tabRealm3.TextSize = 12; tabRealm3.Font = Enum.Font.SourceSansBold; tabRealm3.Text = "Realm 3" tabRealm3.Parent = tabList
tabSettings = Instance.new("TextButton") tabSettings.Size = UDim2.new(0, 75, 1, 0) tabSettings.Position = UDim2.new(0, 310, 0, 0) tabSettings.BackgroundColor3 = Color3.fromRGB(45, 45, 45) tabSettings.TextColor3 = Color3.fromRGB(170, 170, 170) tabSettings.TextSize = 12; tabSettings.Font = Enum.Font.SourceSansBold; tabSettings.Text = "Settings" tabSettings.Parent = tabList
tabRunes = Instance.new("TextButton") tabRunes.Size = UDim2.new(0, 60, 1, 0) tabRunes.Position = UDim2.new(0, 390, 0, 0) tabRunes.BackgroundColor3 = Color3.fromRGB(45, 45, 45) tabRunes.TextColor3 = Color3.fromRGB(170, 170, 170) tabRunes.TextSize = 12; tabRunes.Font = Enum.Font.SourceSansBold; tabRunes.Text = "Runes" tabRunes.Parent = tabList

Instance.new("UICorner", tabTrial).CornerRadius = UDim.new(0, 16) Instance.new("UICorner", tabCapsules).CornerRadius = UDim.new(0, 16) Instance.new("UICorner", tabRealm1).CornerRadius = UDim.new(0, 16) Instance.new("UICorner", tabRealm3).CornerRadius = UDim.new(0, 16) Instance.new("UICorner", tabSettings).CornerRadius = UDim.new(0, 16) Instance.new("UICorner", tabRunes).CornerRadius = UDim.new(0, 16)

local subTabList = Instance.new("Frame") subTabList.Size = UDim2.new(1, 0, 0, 25) subTabList.Position = UDim2.new(0, 0, 0, 0) subTabList.BackgroundTransparency = 1; subTabList.Parent = realm1MasterPage
subBtnNoobs = Instance.new("TextButton") subBtnNoobs.Size = UDim2.new(0, 50, 1, 0) subBtnNoobs.Position = UDim2.new(0, 2, 0, 0) subBtnNoobs.BackgroundColor3 = Color3.fromRGB(230, 230, 235) subBtnNoobs.TextColor3 = Color3.fromRGB(15, 15, 15) subBtnNoobs.TextSize = 10; subBtnNoobs.Font = Enum.Font.SourceSansBold; subBtnNoobs.Text = "Noobs" subBtnNoobs.Parent = subTabList
subBtnOof = Instance.new("TextButton") subBtnOof.Size = UDim2.new(0, 75, 1, 0) subBtnOof.Position = UDim2.new(0, 54, 0, 0) subBtnOof.BackgroundColor3 = Color3.fromRGB(45, 45, 45) subBtnOof.TextColor3 = Color3.fromRGB(170, 170, 170) subBtnOof.TextSize = 10; subBtnOof.Font = Enum.Font.SourceSansBold; subBtnOof.Text = "Oof Upgrades" subBtnOof.Parent = subTabList
subBtnRebirth = Instance.new("TextButton") subBtnRebirth.Size = UDim2.new(0, 95, 1, 0) subBtnRebirth.Position = UDim2.new(0, 131, 0, 0) subBtnRebirth.BackgroundColor3 = Color3.fromRGB(45, 45, 45) subBtnRebirth.TextColor3 = Color3.fromRGB(170, 170, 170) subBtnRebirth.TextSize = 10; subBtnRebirth.Font = Enum.Font.SourceSansBold; subBtnRebirth.Text = "Rebirth Upgrades" subBtnRebirth.Parent = subTabList
subBtnFire = Instance.new("TextButton") subBtnFire.Size = UDim2.new(0, 75, 1, 0) subBtnFire.Position = UDim2.new(0, 228, 0, 0) subBtnFire.BackgroundColor3 = Color3.fromRGB(45, 45, 45) subBtnFire.TextColor3 = Color3.fromRGB(170, 170, 170) subBtnFire.TextSize = 10; subBtnFire.Font = Enum.Font.SourceSansBold; subBtnFire.Text = "Fire Upgrades" subBtnFire.Parent = subTabList
subBtnBlaze = Instance.new("TextButton") subBtnBlaze.Size = UDim2.new(0, 50, 1, 0) subBtnBlaze.Position = UDim2.new(0, 305, 0, 0) subBtnBlaze.BackgroundColor3 = Color3.fromRGB(45, 45, 45) subBtnBlaze.TextColor3 = Color3.fromRGB(170, 170, 170) subBtnBlaze.TextSize = 10; subBtnBlaze.Font = Enum.Font.SourceSansBold; subBtnBlaze.Text = "Blaze" subBtnBlaze.Parent = subTabList
subBtnCash = Instance.new("TextButton") subBtnCash.Size = UDim2.new(0, 75, 1, 0) subBtnCash.Position = UDim2.new(0, 357, 0, 0) subBtnCash.BackgroundColor3 = Color3.fromRGB(45, 45, 45) subBtnCash.TextColor3 = Color3.fromRGB(170, 170, 170) subBtnCash.TextSize = 10; subBtnCash.Font = Enum.Font.SourceSansBold; subBtnCash.Text = "Cash Upgrades" subBtnCash.Parent = subTabList

Instance.new("UICorner", subBtnNoobs).CornerRadius = UDim.new(0, 5) Instance.new("UICorner", subBtnOof).CornerRadius = UDim.new(0, 5) Instance.new("UICorner", subBtnRebirth).CornerRadius = UDim.new(0, 5) Instance.new("UICorner", subBtnFire).CornerRadius = UDim.new(0, 5) Instance.new("UICorner", subBtnBlaze).CornerRadius = UDim.new(0, 5) Instance.new("UICorner", subBtnCash).CornerRadius = UDim.new(0, 5)
--======================================================================================
-- BROSWE HUB | PART 4 OF 9 (SCROLL CONTAINER INSTANTIATIONS)
--======================================================================================
local function makeScroll(canvas) 
    local s = Instance.new("ScrollingFrame") s.Size = UDim2.new(1, 0, 1, -30) s.Position = UDim2.new(0, 0, 0, 30) s.BackgroundTransparency = 1; s.BorderSizePixel = 0; s.CanvasSize = UDim2.new(0, 0, 0, canvas) s.ScrollBarThickness = 3; s.ScrollBarImageColor3 = Color3.fromRGB(0, 136, 255) s.Visible = false; s.Parent = realm1MasterPage return s 
end
realm1NoobScroll = makeScroll(310) realm1NoobScroll.Visible = true
realm1UpgradeScroll = makeScroll(110)
realm1RebirthScroll = makeScroll(160)
realm1FireScroll = makeScroll(210)
realm1FireScroll.Parent = realm1MasterPage
realm1BlazeScroll = makeScroll(210)
realm1CashScroll = makeScroll(170)

function gridRow(txt, pos, page)
    local f = Instance.new("Frame") f.Size = UDim2.new(1, -10, 0, 36) f.Position = UDim2.new(0, 5, 0, (pos-1)*41+5) f.BackgroundColor3 = Color3.fromRGB(30, 30, 30) f.BorderSizePixel = 0; f.Parent = page
    local l = Instance.new("TextLabel") l.Size = UDim2.new(0.7, 0, 1, 0) l.Position = UDim2.new(0, 12, 0, 0) l.BackgroundTransparency = 1; l.TextColor3 = Color3.fromRGB(220, 220, 225) l.TextSize = 13; l.Font = Enum.Font.SourceSans; l.Text = txt; l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = f
    local b = Instance.new("TextButton") b.Size = UDim2.new(0, 75, 0, 22) b.Position = UDim2.new(1, -85, 0.5, -11) b.BackgroundColor3 = Color3.fromRGB(60, 20, 20) b.TextColor3 = Color3.fromRGB(255, 120, 120) b.TextSize = 11; b.Font = Enum.Font.SourceSansBold; b.Text = "DISABLED" b.Parent = f
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 5) Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5) return b
end

function makeSubRow(label, idx, scr)
    local f = Instance.new("Frame") f.Size = UDim2.new(1, -12, 0, 42) f.Position = UDim2.new(0, 5, 0, (idx-1)*48+5) f.BackgroundColor3 = Color3.fromRGB(30, 30, 30) f.BorderSizePixel = 0; f.Parent = scr
    local l = Instance.new("TextLabel") l.Size = UDim2.new(0.7, 0, 1, 0) l.Position = UDim2.new(0, 12, 0, 0) l.BackgroundTransparency = 1; l.TextColor3 = Color3.fromRGB(220, 220, 225) l.TextSize = 13; l.Font = Enum.Font.SourceSans; l.Text = label; l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = f
    local b = Instance.new("TextButton") b.Size = UDim2.new(0, 75, 0, 24) b.Position = UDim2.new(1, -85, 0.5, -12) b.BackgroundColor3 = Color3.fromRGB(60, 20, 20) b.TextColor3 = Color3.fromRGB(255, 120, 120) b.TextSize = 11; b.Font = Enum.Font.SourceSansBold; b.Text = "DISABLED" b.Parent = f
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 5) Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5) return b
end
--======================================================================================
-- BROSWE HUB | PART 5 OF 9 (COMPONENT INTERACTIVE TOGGLES LIST MAPPING)
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

toggleAutoBlazeConvert = makeSubRow("Auto Convert Fire to Blaze (5m)", 1, realm1BlazeScroll)
toggleBlazeMoreBlaze = makeSubRow("More Blaze (Blaze)", 2, realm1BlazeScroll)
toggleBlazeMoreFire = makeSubRow("More Fire (Blaze)", 3, realm1BlazeScroll)
toggleBlazeMoreOof = makeSubRow("More Oof (Blaze)", 4, realm1BlazeScroll)

toggleAutoFarmCash = makeSubRow("Auto Stand On Conveyor Pad", 1, realm1CashScroll)
toggleCashMoreCash = makeSubRow("More Cash Auto Upgrade", 2, realm1CashScroll)
toggleCashFasterDropper = makeSubRow("Faster Dropper Auto Upgrade", 3, realm1CashScroll)
toggleCashMoreRuneLuck = makeSubRow("More Rune Luck Auto Upgrade", 4, realm1CashScroll)

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
--======================================================================================
-- BROSWE HUB | PART 6 OF 9 (PLOT-AGNOSTIC SPATIAL VALUE MATRIX)
--======================================================================================
local InsideTrail, PrepTimerActive = false, false
local TrailState = "Capsule"
local SweeperActiveMovement = false

print("PART 6 LOADED")

local CastlePosition = Vector3.new(879.0405, 12.3479, 13443.0859)
local CapsulePosition = Vector3.new(712.6, 5.7, 7814.0)

local function GetWorldRoot()
    local char = player.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

-- PLOT-AGNOSTIC CONVEYOR FINDER: Dynamically crawls the map to find your live belt and kill under-map bugs
local function ResolveConveyorPosition()
    local hrp = GetWorldRoot()
    
    -- Method 1: Scan all active tycoon plots in the game content folder tree dynamically
    local gameContent = workspace:FindFirstChild("__GAME_CONTENT")
    if gameContent then
        for _, folder in ipairs(gameContent:GetChildren()) do
            if folder.Name:lower():find("tycoon") or folder.Name:lower():find("plot") then
                local conveyor = folder:FindFirstChild("Conveyor", true)
                if conveyor and conveyor:IsA("BasePart") then
                    -- Verify this tycoon belongs to the player by checking nearby owner models
                    local ownerVal = folder:FindFirstChild("Owner", true) or folder:FindFirstChild("Player", true)
                    if not ownerVal or (ownerVal:IsA("ValueBase") and ownerVal.Value == player) or ownerVal.Name:lower():find(player.Name:lower()) then
                        return conveyor.Position + Vector3.new(0, 4, 0)
                    end
                end
            end
        end
    end
    
    -- Method 2: Universal Ancestry Sweep Fallback
    local primaryTycoon = gameContent and gameContent:FindFirstChild("Tycoon")
    local standardConveyor = primaryTycoon and primaryTycoon:FindFirstChild("Conveyor", true)
    if standardConveyor and standardConveyor:IsA("BasePart") then
        return standardConveyor.Position + Vector3.new(0, 4, 0)
    end
    
    -- Method 3: Absolute Anti-Clip Buffer Gate (Keeps you 15 studs in the air above current position if lost)
    if hrp then
        return hrp.Position + Vector3.new(0, 15, 0)
    end
    return Vector3.new(874.84, 15.0, 13426.69) -- Raised fallback safety height out of the void
end

local function ParseCostText(obj)
    if not obj or not obj:IsA("TextLabel") then return math.huge end
    local text = tostring(obj.Text):upper()
    if text == "" then return math.huge end
    text = text:gsub("CASH", ""):gsub("%s", "")
    local num = tonumber(text:match("[%d%.]+"))
    if not num then return math.huge end
    if text:find("K") then num = num * 1000
    elseif text:find("M") then num = num * 1000000
    elseif text:find("B") then num = num * 1000000000
    elseif text:find("T") then num = num * 1000000000000
    end
    return num
end

local function GetPlayerCash()
    local extraFolder = player:FindFirstChild("EXTRA")
    local pinnedFolder = extraFolder and extraFolder:FindFirstChild("PINNED_CURRENCIES")
    local cashObj = pinnedFolder and pinnedFolder:FindFirstChild("Cash")
    if cashObj and cashObj:IsA("ValueBase") and type(cashObj.Value) == "number" then 
        return cashObj.Value 
    end
    return 0
end

local function GetChosenTrail()
    if _G.AutoHardTrails then return "Hard" end
    if _G.AutoMediumTrails then return "Medium" end
    if _G.AutoEasyTrails then return "Easy" end
    return nil
end

--======================================================================================
-- BROSWE HUB | PART 7 OF 9 (STRICT STRING GATE KEYWORD OVERRIDES)
--======================================================================================
local function GetGate(name)
    local gameContent = workspace:FindFirstChild("__GAME_CONTENT")
    local world3 = gameContent and gameContent:FindFirstChild("Contents") and gameContent.Contents:FindFirstChild("WORLD - 3.AncientBossModel")
    if world3 then return world3:FindFirstChild(name .. "Gate", true) end
end

-- STRICT STRINGS FILTER GATING: Bypasses countdown timers completely by hunting true active keywords
local function GateOpen(gate)
    if not gate then return false end
    local gui = gate:FindFirstChildWhichIsA("SurfaceGui", true)
    if gui then
        local label = gui:FindFirstChildWhichIsA("TextLabel", true)
        if label then 
            local txt = label.Text:lower()
            -- Block the teleport instantly if the text label contains a countdown timer keyword
            if txt:find("in") or txt:find("m") or txt:find("s") then
                return false
            end
            -- Only pass true if an active entry keyword registers on the board surface
            return txt:find("enter") ~= nil or txt:find("active") ~= nil or txt:find("now") ~= nil or txt == "open"
        end
    end
    return false
end

local function FindEnemy()
    local hrp = GetWorldRoot()
    if not hrp then return nil end
    local closest, distance = nil, math.huge
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("Model") and obj ~= player.Character then
            local hum = obj:FindFirstChildOfClass("Humanoid")
            local root = obj:FindFirstChild("HumanoidRootPart")
            if hum and root and hum.Health > 0 and not game.Players:GetPlayerFromCharacter(obj) then
                local d = (hrp.Position - root.Position).Magnitude
                if d < distance then distance = d; closest = root end
            end
        end
    end
    return closest
end

task.spawn(function()
    while true do
        task.wait(0.25)
        local selected = GetChosenTrail()
        if TrailState == "Capsule" then
            if not SweeperActiveMovement then
                if _G.AutoCapsule then 
                    InsideTrail = false 
                    local hrp = GetWorldRoot() if hrp then hrp.CFrame = CFrame.new(CapsulePosition) end
                elseif _G.AutoFarmCash then
                    InsideTrail = false 
                    local hrp = GetWorldRoot() if hrp then hrp.CFrame = CFrame.new(ResolveConveyorPosition()) end
                end
            end
            
            if selected and (selected == "Easy" or selected == "Medium" or selected == "Hard") then
                local gate = GetGate(selected)
                if GateOpen(gate) then TrailState = "EnteringTrail" end
            end
        elseif TrailState == "EnteringTrail" then
            if selected and (selected == "Easy" or selected == "Medium" or selected == "Hard") then
                local hrp = GetWorldRoot() if hrp then hrp.CFrame = CFrame.new(CastlePosition) end
                task.wait(0.5)
                local gate = GetGate(selected)
                if gate and GetWorldRoot() then GetWorldRoot().CFrame = gate.CFrame * CFrame.new(0, 0, -5) end
                task.wait(1) InsideTrail = true TrailState = "Fighting"
            else
                TrailState = "Capsule"
            end
        elseif TrailState == "Fighting" then
            if not selected or (selected ~= "Easy" and selected ~= "Medium" and selected ~= "Hard") then
                InsideTrail = false
                TrailState = "Capsule"
            else
                local enemy = FindEnemy()
                local hrp = GetWorldRoot()
                if enemy and hrp then hrp.CFrame = CFrame.new(enemy.Position + Vector3.new(0, 3, 0), enemy.Position) end
                if not InsideTrail then TrailState = "Capsule" end
            end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.4)
        if _G.AutoFarmCash and not InsideTrail then
            local gameContent = workspace:FindFirstChild("__GAME_CONTENT")
            local tycoon = gameContent and gameContent:FindFirstChild("Tycoon")
            local buttonsFolder = tycoon and tycoon:FindFirstChild("Buttons")
            
            if buttonsFolder then
                local orderedButtons = buttonsFolder:GetChildren()
                local foundAffordable = false
                
                for _, btnModel in ipairs(orderedButtons) do
                    if btnModel:IsA("Model") then
                        local targetBuyPart = btnModel:FindFirstChild("BuyingButtonPart", true)
                        local costLabel = btnModel:FindFirstChild("Cost", true)
                        
                        if targetBuyPart and targetBuyPart:IsA("BasePart") then
                            local parsedCost = ParseCostText(costLabel)
                            local localWallet = GetPlayerCash()
                            
                            if localWallet and localWallet > 0 and parsedCost > localWallet then
                                continue
                            end
                            
                            local hrp = GetWorldRoot()
                            if hrp then
                                SweeperActiveMovement = true
                                foundAffordable = true
                                
                                hrp.CFrame = CFrame.new(targetBuyPart.Position + Vector3.new(0, 3, 0))
                                task.wait(0.25)
                                hrp.CFrame = CFrame.new(ResolveConveyorPosition())
                                
                                local giveUpTime = tick() + 0.4
                                repeat task.wait(0.05) until not btnModel:IsDescendantOf(buttonsFolder) or tick() > giveUpTime or InsideTrail or not _G.AutoFarmCash
                                SweeperActiveMovement = false
                                break 
                            end
                        end
                    end
                end
                if not foundAffordable then SweeperActiveMovement = false end
            else SweeperActiveMovement = false end
        else SweeperActiveMovement = false end
    end
end)


--======================================================================================
-- BROSWE HUB | PART 8 OF 9 (MULTI-THREADED REMOTE PURCHASE ROUTINES)
--======================================================================================
local function buildPurchaseThread(flag, command, serverArgs)
    task.spawn(function()
        while true do
            task.wait(0.4)
            if _G[flag] and NetRemote then
                pcall(function() NetRemote:FireServer(command, unpack(serverArgs)) end)
            end
        end
    end)
end

local upgrades = {
    {F = "AutoUpgradeStarter",    T = "UpgradeNoobMax",    A = {"Starter"}},
    {F = "AutoUpgradeCooker",     T = "UpgradeNoobMax",    A = {"Cooker"}},
    {F = "AutoUpgradeExplorer",   T = "UpgradeNoobMax",    A = {"Explorer"}},
    {F = "AutoUpgradeMagician",   T = "UpgradeNoobMax",    A = {"Magician"}},
    {F = "AutoUpgradeArcher",     T = "UpgradeNoobMax",    A = {"Archer"}},
    {F = "AutoUpgradeSoldier",    T = "UpgradeNoobMax",    A = {"Soldier"}},
    {F = "AutoUpgradePharaoh",    T = "UpgradeNoobMax",    A = {"Pharaoh"}},
    {F = "AutoUpgradeMoreOof",    T = "UpgradeUpgradeMax", A = {"Oof", "MoreOof"}},
    {F = "AutoUpgradeFasterNoobs",T = "UpgradeUpgradeMax", A = {"Oof", "FasterNoobs"}},
    {F = "AutoRebirthMoreOof",    T = "UpgradeUpgradeMax", A = {"Rebirth", "MoreOof"}},
    {F = "AutoRebirthMoreRebirth",T = "UpgradeUpgradeMax", A = {"Rebirth", "MoreRebirth"}},
    {F = "AutoRebirthMoreFire",   T = "UpgradeUpgradeMax", A = {"Rebirth", "MoreFire"}},
    {F = "AutoFireMoreFire",      T = "UpgradeUpgradeMax", A = {"Fire", "MoreFire"}},
    {F = "AutoFireMoreOof",       T = "UpgradeUpgradeMax", A = {"Fire", "MoreOof"}},
    {F = "AutoFireMoreRebirth",   T = "UpgradeUpgradeMax", A = {"Fire", "MoreRebirth"}},
    {F = "AutoFireMoreBulk",      T = "UpgradeUpgradeMax", A = {"Fire", "MoreBulk"}},
    {F = "AutoBlazeMoreBlaze",    T = "UpgradeUpgradeMax", A = {"Blaze", "MoreBlaze"}},
    {F = "AutoBlazeMoreFire",     T = "UpgradeUpgradeMax", A = {"Blaze", "MoreFire"}},
    {F = "AutoBlazeMoreOof",      T = "UpgradeUpgradeMax", A = {"Blaze", "MoreOof"}},
    {F = "AutoUpgradeMoreCash",   T = "UpgradeUpgradeMax", A = {"Cash", "MoreCash"}},
    {F = "AutoUpgradeFasterDropper",T = "UpgradeUpgradeMax", A = {"Cash", "FasterDropper"}},
    {F = "AutoUpgradeMoreRuneLuck",T = "UpgradeUpgradeMax", A = {"Cash", "MoreRuneLuck"}}
}
for _, item in ipairs(upgrades) do buildPurchaseThread(item.F, item.T, item.A) end

task.spawn(function()
    local targetCooldown = math.random(270, 330)
    local secondsElapsed = 0
    while true do
        task.wait(1)
        if _G.AutoBlazeConvert and NetRemote then
            secondsElapsed = secondsElapsed + 1
            if secondsElapsed >= targetCooldown then
                secondsElapsed = 0
                targetCooldown = math.random(270, 330)
                pcall(function() NetRemote:FireServer("Blaze") end)
            end
        else secondsElapsed = 0 end
    end
end)
--======================================================================================
-- BROSWE HUB | PART 9 OF 9 (SIGNALS INTERACTIVE TOGGLES MAPPING FRAMEWORKS)
--======================================================================================
function tState(b, v) 
    _G[v] = not _G[v] 
    b.Text = _G[v] and "ACTIVE" or "DISABLED" 
    b.BackgroundColor3 = _G[v] and Color3.fromRGB(20, 60, 20) or Color3.fromRGB(60, 20, 20) 
    b.TextColor3 = _G[v] and Color3.fromRGB(120, 255, 120) or Color3.fromRGB(255, 120, 120) 
end

toggleEasy.MouseButton1Click:Connect(function() tState(toggleEasy, "AutoEasyTrails") end) 
toggleMed.MouseButton1Click:Connect(function() tState(toggleMed, "AutoMediumTrails") end) 
toggleHard.MouseButton1Click:Connect(function() tState(toggleHard, "AutoHardTrails") end) 
togglePharaoh.MouseButton1Click:Connect(function() tState(togglePharaoh, "AutoUpgradePharaoh") end) 
toggleAFK.MouseButton1Click:Connect(function() tState(toggleAFK, "AntiAFK") end) 
togglePrestige.MouseButton1Click:Connect(function() tState(togglePrestige, "AutoPrestige") end)
toggleStarter.MouseButton1Click:Connect(function() tState(toggleStarter, "AutoUpgradeStarter") end) 
toggleCooker.MouseButton1Click:Connect(function() tState(toggleCooker, "AutoUpgradeCooker") end) 
toggleExplorer.MouseButton1Click:Connect(function() tState(toggleExplorer, "AutoUpgradeExplorer") end) 
toggleMagician.MouseButton1Click:Connect(function() tState(toggleMagician, "AutoUpgradeMagician") end) 
toggleArcher.MouseButton1Click:Connect(function() tState(toggleArcher, "AutoUpgradeArcher") end) 
toggleSoldier.MouseButton1Click:Connect(function() tState(toggleSoldier, "AutoUpgradeSoldier") end) 
toggleMoreOof.MouseButton1Click:Connect(function() tState(toggleMoreOof, "AutoUpgradeMoreOof") end) 
toggleFasterNoobs.MouseButton1Click:Connect(function() tState(toggleFasterNoobs, "AutoUpgradeFasterNoobs") end)
toggleRebirthOof.MouseButton1Click:Connect(function() tState(toggleRebirthOof, "AutoRebirthMoreOof") end) 
toggleRebirthRebirth.MouseButton1Click:Connect(function() tState(toggleRebirthRebirth, "AutoRebirthMoreRebirth") end) 
toggleRebirthFire.MouseButton1Click:Connect(function() tState(toggleRebirthFire, "AutoRebirthMoreFire") end)
toggleFireFire.MouseButton1Click:Connect(function() tState(toggleFireFire, "AutoFireMoreFire") end)
toggleFireOof.MouseButton1Click:Connect(function() tState(toggleFireOof, "AutoFireMoreOof") end)
toggleFireRebirth.MouseButton1Click:Connect(function() tState(toggleFireRebirth, "AutoFireMoreRebirth") end)
toggleFireBulk.MouseButton1Click:Connect(function() tState(toggleFireBulk, "AutoFireMoreBulk") end)
toggleBuildFire.MouseButton1Click:Connect(function() tState(toggleBuildFire, "AutoBuildFire") end)
toggleRebirthTimerCard.MouseButton1Click:Connect(function() tState(toggleRebirthTimerCard, "AutoRebirthTimer") end) 
toggleRuneBasic.MouseButton1Click:Connect(function() tState(toggleRuneBasic, "AutoRuneBasic") end)
toggleBlazeMoreBlaze.MouseButton1Click:Connect(function() tState(toggleBlazeMoreBlaze, "AutoBlazeMoreBlaze") end) 
toggleBlazeMoreFire.MouseButton1Click:Connect(function() tState(toggleBlazeMoreFire, "AutoBlazeMoreFire") end) 
toggleBlazeMoreOof.MouseButton1Click:Connect(function() tState(toggleBlazeMoreOof, "AutoBlazeMoreOof") end)
toggleAutoBlazeConvert.MouseButton1Click:Connect(function() tState(toggleAutoBlazeConvert, "AutoBlazeConvert") end)

toggleAutoFarmCash.MouseButton1Click:Connect(function() tState(toggleAutoFarmCash, "AutoFarmCash") end)
toggleCashMoreCash.MouseButton1Click:Connect(function() tState(toggleCashMoreCash, "AutoUpgradeMoreCash") end)
toggleCashFasterDropper.MouseButton1Click:Connect(function() tState(toggleCashFasterDropper, "AutoUpgradeFasterDropper") end)
toggleCashMoreRuneLuck.MouseButton1Click:Connect(function() tState(toggleCashMoreRuneLuck, "AutoUpgradeMoreRuneLuck") end)

local function uCaps() 
    local s = _G.AutoCapsule and "ACTIVE" or "DISABLED" 
    local c = _G.AutoCapsule and Color3.fromRGB(20, 60, 20) or Color3.fromRGB(60, 20, 20) 
    local t = _G.AutoCapsule and Color3.fromRGB(120, 255, 120) or Color3.fromRGB(255, 120, 120) 
    toggleTrailCapsule.Text, toggleTrailCapsule.BackgroundColor3, toggleTrailCapsule.TextColor3 = s, c, t 
    toggleStandaloneCapsule.Text, toggleStandaloneCapsule.BackgroundColor3, toggleStandaloneCapsule.TextColor3 = s, c, t 
end
toggleTrailCapsule.MouseButton1Click:Connect(function() _G.AutoCapsule = not _G.AutoCapsule; uCaps() end) 
toggleStandaloneCapsule.MouseButton1Click:Connect(function() _G.AutoCapsule = not _G.AutoCapsule; uCaps() end)

toggleKillSwitch.MouseButton1Click:Connect(function()
    for k, _ in pairs(_G) do if type(k) == "string" and (k:sub(1,4) == "Auto" or k == "AntiAFK") then _G[k] = false end end
    pcall(function() local cam = workspace.CurrentCamera if cam then cam.CameraType = Enum.CameraType.Custom end end) sg:Destroy()
end)

function mainRoute(pOpen, bActive) 
    trialPage.Visible, capsulePage.Visible, realm1MasterPage.Visible, realm3Page.Visible, settingsPage.Visible, runesPage.Visible = false, false, false, false, false, false; pOpen.Visible = true; 
    local tabs = {tabTrial, tabCapsules, tabRealm1, tabRealm3, tabSettings, tabRunes}
    for _, t in ipairs(tabs) do t.BackgroundColor3, t.TextColor3 = Color3.fromRGB(45, 45, 45), Color3.fromRGB(170, 170, 170) end
    bActive.BackgroundColor3, bActive.TextColor3 = Color3.fromRGB(220, 220, 225), Color3.fromRGB(15, 15, 15) 
end
tabTrial.MouseButton1Click:Connect(function() mainRoute(trialPage, tabTrial) end) 
tabCapsules.MouseButton1Click:Connect(function() mainRoute(capsulePage, tabCapsules) end) 
tabRealm1.MouseButton1Click:Connect(function() mainRoute(realm1MasterPage, tabRealm1) end) 
tabRealm3.MouseButton1Click:Connect(function() mainRoute(realm3Page, tabRealm3) end) 
tabSettings.MouseButton1Click:Connect(function() mainRoute(settingsPage, tabSettings) end) 
tabRunes.MouseButton1Click:Connect(function() mainRoute(runesPage, tabRunes) end)

function route(targetScroll)
    local scrolls = {realm1NoobScroll, realm1UpgradeScroll, realm1RebirthScroll, realm1FireScroll, realm1BlazeScroll, realm1CashScroll}
    local btns = {subBtnNoobs, subBtnOof, subBtnRebirth, subBtnFire, subBtnBlaze, subBtnCash}
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
subBtnCash.MouseButton1Click:Connect(function() route(realm1CashScroll) end)

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
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

print("PART 9 LOADED - CORE ENGINES COMPLETELY PERFORMANCE RESTORED")
