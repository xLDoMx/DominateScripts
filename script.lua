local player = game:GetService("Players").LocalPlayer
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local NetRemote = nil

local existingUI = player:WaitForChild("PlayerGui"):FindFirstChild("LukesBrosweHubMirror")
if existingUI then existingUI:Destroy() end

local sg = Instance.new("ScreenGui")
sg.Name = "LukesBrosweHubMirror"
sg.ResetOnSpawn = false
sg.Parent = player:WaitForChild("PlayerGui")
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 460, 0, 360)
mainFrame.Position = UDim2.new(0.5, -230, 0.5, -180)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.Parent = sg

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame
local function createPage(name, isVisible)
    local page = Instance.new("Frame")
    page.Name = name
    page.Size = UDim2.new(1, -20, 1, -85)
    page.Position = UDim2.new(0, 10, 0, 80)
    page.BackgroundTransparency = 1
    page.Visible = isVisible
    page.Parent = mainFrame
    return page
end

trialPage = createPage("TrialPage", true)
capsulePage = createPage("CapsulePage", false)
realm1MasterPage = createPage("Realm1MasterPage", false)
realm3Page = createPage("Realm3Page", false)
settingsPage = createPage("SettingsPage", false)
runesPage = createPage("RunesPage", false)
local headerTitle = Instance.new("TextLabel")
headerTitle.Size = UDim2.new(1, -20, 0, 35)
headerTitle.Position = UDim2.new(0, 12, 0, 4)
headerTitle.BackgroundTransparency = 1
headerTitle.TextColor3 = Color3.fromRGB(245, 245, 250)
headerTitle.TextSize = 15
headerTitle.Font = Enum.Font.SourceSansBold
headerTitle.Text = "Broswe Hub | Noob Incremental"
headerTitle.TextXAlignment = Enum.TextXAlignment.Left
headerTitle.Parent = mainFrame

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 95, 0, 24)
minBtn.Position = UDim2.new(0.5, -47, 0.01, 0)
minBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
minBtn.TextColor3 = Color3.fromRGB(0, 136, 255)
minBtn.TextSize = 12
minBtn.Font = Enum.Font.SourceSansBold
minBtn.Text = "Hide UI"
minBtn.Parent = sg

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 5)
minCorner.Parent = minBtn
local tabList = Instance.new("Frame")
tabList.Size = UDim2.new(1, -20, 0, 32)
tabList.Position = UDim2.new(0, 10, 0, 40)
tabList.BackgroundTransparency = 1
tabList.Parent = mainFrame

local function createMainTab(text, offset, sizeX)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, sizeX, 1, 0)
    btn.Position = UDim2.new(0, offset, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.TextColor3 = Color3.fromRGB(170, 170, 170)
    btn.TextSize = 12
    btn.Font = Enum.Font.SourceSansBold
    btn.Text = text
    btn.Parent = tabList
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 16)
    return btn
end

tabTrial = createMainTab("Trial", 5, 60)
tabTrial.BackgroundColor3 = Color3.fromRGB(230, 230, 235)
tabTrial.TextColor3 = Color3.fromRGB(15, 15, 15)
tabCapsules = createMainTab("Capsules", 70, 75)
tabRealm1 = createMainTab("Realm 1", 150, 75)
tabRealm3 = createMainTab("Realm 3", 230, 75)
tabSettings = createMainTab("Settings", 310, 75)
tabRunes = createMainTab("Runes", 390, 60)
local subTabList = Instance.new("Frame")
subTabList.Size = UDim2.new(1, 0, 0, 25)
subTabList.BackgroundTransparency = 1
subTabList.Parent = realm1MasterPage

local function createSubTab(text, offset, sizeX)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, sizeX, 1, 0)
    btn.Position = UDim2.new(0, offset, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.TextColor3 = Color3.fromRGB(170, 170, 170)
    btn.TextSize = 10
    btn.Font = Enum.Font.SourceSansBold
    btn.Text = text
    btn.Parent = subTabList
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    return btn
end

subBtnNoobs = createSubTab("Noobs", 2, 50)
subBtnNoobs.BackgroundColor3 = Color3.fromRGB(230, 230, 235)
subBtnNoobs.TextColor3 = Color3.fromRGB(15, 15, 15)
subBtnOof = createSubTab("Oof Upgrades", 54, 75)
subBtnRebirth = createSubTab("Rebirth Upgrades", 131, 95)
subBtnFire = createSubTab("Fire Upgrades", 228, 75)
subBtnBlaze = createSubTab("Blaze", 305, 50)
subBtnCash = createSubTab("Cash Upgrades", 357, 75)
local function makeScroll()
    local s = Instance.new("ScrollingFrame")
    s.Size = UDim2.new(1, 0, 1, -30)
    s.Position = UDim2.new(0, 0, 0, 30)
    s.BackgroundTransparency = 1
    s.BorderSizePixel = 0
    s.ScrollBarThickness = 3
    s.ScrollBarImageColor3 = Color3.fromRGB(0, 136, 255)
    s.Visible = false
    s.AutomaticCanvasSize = Enum.AutomaticSize.Y
    s.CanvasSize = UDim2.new(0, 0, 0, 0)
    s.Parent = realm1MasterPage
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = s
    return s
end

realm1NoobScroll = makeScroll()
realm1NoobScroll.Visible = true
realm1UpgradeScroll = makeScroll()
realm1RebirthScroll = makeScroll()
realm1FireScroll = makeScroll()
realm1BlazeScroll = makeScroll()
realm1CashScroll = makeScroll()
function gridRow(txt, pos, page)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -10, 0, 36)
    f.Position = UDim2.new(0, 5, 0, (pos - 1) * 41 + 5)
    f.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    f.BorderSizePixel = 0
    f.Parent = page
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(0.7, 0, 1, 0)
    l.Position = UDim2.new(0, 12, 0, 0)
    l.BackgroundTransparency = 1
    l.TextColor3 = Color3.fromRGB(220, 220, 225)
    l.TextSize = 13
    l.Font = Enum.Font.SourceSans
    l.Text = txt
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 75, 0, 22)
    b.Position = UDim2.new(1, -85, 0.5, -11)
    b.BackgroundColor3 = Color3.fromRGB(60, 20, 20)
    b.TextColor3 = Color3.fromRGB(255, 120, 120)
    b.TextSize = 11
    b.Font = Enum.Font.SourceSansBold
    b.Text = "DISABLED"
    b.Parent = f
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 5)
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    return b
end

function makeSubRow(label, scr)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -12, 0, 42)
    f.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    f.BorderSizePixel = 0
    f.Parent = scr
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(0.7, 0, 1, 0)
    l.Position = UDim2.new(0, 12, 0, 0)
    l.BackgroundTransparency = 1
    l.TextColor3 = Color3.fromRGB(220, 220, 225)
    l.TextSize = 13
    l.Font = Enum.Font.SourceSans
    l.Text = label
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 75, 0, 24)
    b.Position = UDim2.new(1, -85, 0.5, -12)
    b.BackgroundColor3 = Color3.fromRGB(60, 20, 20)
    b.TextColor3 = Color3.fromRGB(255, 120, 120)
    b.TextSize = 11
    b.Font = Enum.Font.SourceSansBold
    b.Text = "DISABLED"
    b.Parent = f
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 5)
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    return b
end
toggleEasy = gridRow("Auto Trial (Easy) - Fast Entry", 1, trialPage)
toggleMed = gridRow("Auto Trial (Medium) - Progress Entry", 2, trialPage)
toggleHard = gridRow("Auto Trial (Hard) - Rapid Chain", 3, trialPage)
toggleTrailCapsule = gridRow("Auto Open Capsule After Trial (Ancient)", 4, trialPage)
toggleStandaloneCapsule = gridRow("Open Ancient Capsule", 1, capsulePage)
toggleStandaloneCapsule.Size = UDim2.new(0, 75, 0, 26)
toggleStandaloneCapsule.Position = UDim2.new(1, -85, 0.5, -13)

toggleStarter = makeSubRow("Starter Noob Auto Upgrade", realm1NoobScroll)
toggleCooker = makeSubRow("Cooker Noob Auto Upgrade", realm1NoobScroll)
toggleExplorer = makeSubRow("Explorer Noob Auto Upgrade", realm1NoobScroll)
toggleMagician = makeSubRow("Magician Noob Auto Upgrade", realm1NoobScroll)
toggleArcher = makeSubRow("Archer Noob Auto Upgrade", realm1NoobScroll)
toggleSoldier = makeSubRow("Soldier Noob Auto Upgrade", realm1NoobScroll)
toggleMoreOof = makeSubRow("More Oof Auto Upgrade", realm1UpgradeScroll)
toggleFasterNoobs = makeSubRow("Faster Noobs Auto Upgrade", realm1UpgradeScroll)
toggleRebirthOof = makeSubRow("More Oof (Rebirth)", realm1RebirthScroll)
toggleRebirthRebirth = makeSubRow("More Rebirth (Rebirth)", realm1RebirthScroll)
toggleRebirthFire = makeSubRow("More Fire (Rebirth)", realm1RebirthScroll)
toggleFireFire = makeSubRow("More Fire (Fire)", realm1FireScroll)
toggleFireOof = makeSubRow("More Oof (Fire)", realm1FireScroll)
toggleFireRebirth = makeSubRow("More Rebirth (Fire)", realm1FireScroll)
toggleFireBulk = makeSubRow("More Bulk (Fire)", realm1FireScroll)
toggleBuildFire = makeSubRow("Auto Build Fire", realm1FireScroll)
toggleAutoBlazeConvert = makeSubRow("Auto Convert Fire to Blaze (5m)", realm1BlazeScroll)
toggleBlazeMoreBlaze = makeSubRow("More Blaze (Blaze)", realm1BlazeScroll)
toggleBlazeMoreFire = makeSubRow("More Fire (Blaze)", realm1BlazeScroll)
toggleBlazeMoreOof = makeSubRow("More Oof (Blaze)", realm1BlazeScroll)
toggleAutoFarmCash = makeSubRow("Auto Stand On Conveyor Pad", realm1CashScroll)
toggleCashMoreCash = makeSubRow("More Cash Auto Upgrade", realm1CashScroll)
toggleCashFasterDropper = makeSubRow("Faster Dropper Auto Upgrade", realm1CashScroll)
toggleCashMoreRuneLuck = makeSubRow("More Rune Luck Auto Upgrade", realm1CashScroll)

togglePharaoh = gridRow("Auto Upgrade Pharaoh (Max)", 1, realm3Page)
togglePharaoh.Size = UDim2.new(0, 75, 0, 26)
togglePharaoh.Position = UDim2.new(1, -85, 0.5, -13)
toggleAFK = gridRow("Anti-AFK Safety Disconnect Protection", 1, settingsPage)
toggleAFK.Size = UDim2.new(0, 75, 0, 26)
toggleAFK.Position = UDim2.new(1, -85, 0.5, -13)
toggleAFK.BackgroundColor3 = Color3.fromRGB(20, 60, 20)
toggleAFK.TextColor3 = Color3.fromRGB(120, 255, 120)
toggleAFK.Text = "ACTIVE"
togglePrestige = gridRow("Auto Prestige (Server Max Buy Engine)", 2, settingsPage)
togglePrestige.Size = UDim2.new(0, 75, 0, 26)
togglePrestige.Position = UDim2.new(1, -85, 0.5, -13)
toggleRebirthTimerCard = gridRow("Auto Rebirth (Every 10-Minute Loop Interval)", 3, settingsPage)
toggleRebirthTimerCard.Size = UDim2.new(0, 75, 0, 26)
toggleRebirthTimerCard.Position = UDim2.new(1, -85, 0.5, -13)
toggleKillSwitch = gridRow("EMERGENCY SYSTEM KILL SWITCH", 4, settingsPage)
toggleKillSwitch.Size = UDim2.new(0, 75, 0, 26)
toggleKillSwitch.Position = UDim2.new(1, -85, 0.5, -13)
toggleKillSwitch.BackgroundColor3 = Color3.fromRGB(120, 20, 20)
toggleKillSwitch.TextColor3 = Color3.fromRGB(255, 200, 200)
toggleKillSwitch.Text = "TERMINATE"
toggleRuneBasic = gridRow("Teleport Basic Rune (Auto-Collection Loop)", 1, runesPage)
toggleRuneBasic.Size = UDim2.new(0, 75, 0, 26)
toggleRuneBasic.Position = UDim2.new(1, -85, 0.5, -13)
_G.ScriptRunning = true
local InsideTrail, PrepTimerActive = false, false
local TrailState = "Capsule"
local SweeperActiveMovement = false
local CastlePosition = Vector3.new(879.0405, 12.3479, 13443.0859)
local CapsulePosition = Vector3.new(712.6, 5.7, 7814.0)

_G.AutoEasyTrails, _G.AutoMediumTrails, _G.AutoHardTrails, _G.AutoCapsule, _G.AutoUpgradePharaoh, _G.AntiAFK, _G.AutoPrestige = false, false, false, false, false, true, false
_G.AutoUpgradeStarter, _G.AutoUpgradeCooker, _G.AutoUpgradeExplorer, _G.AutoUpgradeMagician, _G.AutoUpgradeArcher, _G.AutoUpgradeSoldier, _G.AutoUpgradeMoreOof, _G.AutoUpgradeFasterNoobs = false, false, false, false, false, false, false, false
_G.AutoRebirthMoreOof, _G.AutoRebirthMoreRebirth, _G.AutoRebirthMoreFire = false, false, false
_G.AutoFireMoreFire, _G.AutoFireMoreOof, _G.AutoFireMoreRebirth, _G.AutoFireMoreBulk = false, false, false, false
_G.AutoRebirthTimer, _G.AutoRuneBasic = false, false
_G.AutoBlazeMoreBlaze, _G.AutoBlazeMoreFire, _G.AutoBlazeMoreOof, _G.AutoBlazeConvert = false, false, false, false
_G.AutoBuildFire = false
_G.AutoFarmCash, _G.AutoUpgradeMoreCash, _G.AutoUpgradeFasterDropper, _G.AutoUpgradeMoreRuneLuck = false, false, false, false

player.Idled:Connect(function()
    if _G.AntiAFK and game:GetService("VirtualUser") then
        game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end
end)

repeat
    local netService = game:GetService("ReplicatedStorage"):WaitForChild("__Net", 5)
    if netService then NetRemote = netService:FindFirstChild("MainRemote") or netService:FindFirstChildWhichIsA("RemoteEvent") end
    if not NetRemote then task.wait(0.5) end
until NetRemote

local function GetWorldRoot() return player.Character and player.Character:FindFirstChild("HumanoidRootPart") end
local function MovePlayer(pos) local hrp = GetWorldRoot() if hrp then hrp.CFrame = CFrame.new(pos) task.wait(0.2) end end
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
function mainRoute(pOpen, bActive)
    trialPage.Visible, capsulePage.Visible, realm1MasterPage.Visible, realm3Page.Visible, settingsPage.Visible, runesPage.Visible = false, false, false, false, false, false
    pOpen.Visible = true
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
        if s == targetScroll then btns[i].BackgroundColor3, btns[i].TextColor3 = Color3.fromRGB(230, 230, 235), Color3.fromRGB(15, 15, 15)
        else btns[i].BackgroundColor3, btns[i].TextColor3 = Color3.fromRGB(45, 45, 45), Color3.fromRGB(170, 170, 170) end
    end
end
subBtnNoobs.MouseButton1Click:Connect(function() route(realm1NoobScroll) end)
subBtnOof.MouseButton1Click:Connect(function() route(realm1UpgradeScroll) end)
subBtnRebirth.MouseButton1Click:Connect(function() route(realm1RebirthScroll) end)
subBtnFire.MouseButton1Click:Connect(function() route(realm1FireScroll) end)
subBtnBlaze.MouseButton1Click:Connect(function() route(realm1BlazeScroll) end)
subBtnCash.MouseButton1Click:Connect(function() route(realm1CashScroll) end)

minBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
    minBtn.Text = mainFrame.Visible and "Hide UI" or "Lukes Script"
    minBtn.TextColor3 = mainFrame.Visible and Color3.fromRGB(0, 136, 255) or Color3.fromRGB(0, 215, 110)
end)

local dragging, dragInput, dragStart, startPos
mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = mainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
mainFrame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        TweenService:Create(mainFrame, TweenInfo.new(0.08, Enum.EasingStyle.Linear), {Position = targetPos}):Play()
    end
end)
