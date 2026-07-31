--======================================================================================
-- DOMINATE HUB | PART 1 OF 8 (CORE LIFECYCLE CONTROLLERS)
--======================================================================================
if getgenv().DominateHubLoaded then 
    print("[Dominate Hub] Already running! Aborting duplicate instance.")
    return 
end
getgenv().DominateHubLoaded = true

local Running = true
player = game:GetService("Players").LocalPlayer
vu = game:GetService("VirtualUser")
NetRemote = nil

_G.AntiAFK, _G.AutoPrestige = true, false
_G.AutoUpgradeStarter, _G.AutoUpgradeCooker, _G.AutoUpgradeFarmer, _G.AutoUpgradeMagician, _G.AutoUpgradeArcher, _G.AutoUpgradeSoldier, _G.AutoUpgradeMoreOof, _G.AutoUpgradeFasterNoobs = false, false, false, false, false, false, false, false
_G.AutoRebirthMoreOof, _G.AutoRebirthMoreRebirth, _G.AutoRebirthMoreFire = false, false, false
_G.AutoFireMoreFire, _G.AutoFireMoreOof, _G.AutoFireMoreRebirth, _G.AutoFireMoreBulk = false, false, false, false
_G.AutoRebirthTimer = false
_G.AutoBlazeMoreBlaze, _G.AutoBlazeMoreFire, _G.AutoBlazeMoreOof, _G.AutoBlazeConvert = false, false, false, false
_G.AutoBuildFire = false

-- AUTOMATION FLAGS REGISTRY
_G.AutoFarmCash, _G.AutoUpgradeMoreCash, _G.AutoUpgradeFasterDropper, _G.AutoUpgradeMoreRuneLuck = false, false, false, false
_G.AutoRollBasicRune = false
_G.AutoRollSuperRune = false
_G.AutoRollAdvancedRune = false
_G.AutoRollCosmicRune = false

player.Idled:Connect(function()
    if Running and _G.AntiAFK then
        vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame) task.wait(1) vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end
end)

repeat
    local netService = game:GetService("ReplicatedStorage"):WaitForChild("__Net", 5)
    if netService then
        NetRemote = netService:FindFirstChild("MainRemote") or netService:FindFirstChildWhichIsA("RemoteEvent")
    end
    if not NetRemote then task.wait(0.5) end
until NetRemote or not Running
--======================================================================================
-- DOMINATE HUB | PART 2 OF 8 (MASTER UI FRAME ALLOCATIONS)
--======================================================================================
local sg = Instance.new("ScreenGui") sg.Name = "DominateHubMirror" sg.Parent = player:WaitForChild("PlayerGui") sg.ResetOnSpawn = false
mainFrame = Instance.new("Frame") mainFrame.Size = UDim2.new(0, 460, 0, 360) mainFrame.Position = UDim2.new(0.5, -230, 0.5, -180) mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20) mainFrame.BackgroundTransparency = 0.15; mainFrame.BorderSizePixel = 0; mainFrame.Parent = sg
local mainCorner = Instance.new("UICorner") mainCorner.CornerRadius = UDim.new(0, 10) mainCorner.Parent = mainFrame

realm1MasterPage = Instance.new("Frame") realm1MasterPage.Size = UDim2.new(1, -20, 1, -85) realm1MasterPage.Position = UDim2.new(0, 10, 0, 80) realm1MasterPage.BackgroundTransparency = 1; realm1MasterPage.Visible = true; realm1MasterPage.Parent = mainFrame
realm3Page = Instance.new("Frame") realm3Page.Size = UDim2.new(1, -20, 1, -85) realm3Page.Position = UDim2.new(0, 10, 0, 80) realm3Page.BackgroundTransparency = 1; realm3Page.Visible = false; realm3Page.Parent = mainFrame
runesPage = Instance.new("Frame") runesPage.Size = UDim2.new(1, -20, 1, -85) runesPage.Position = UDim2.new(0, 10, 0, 80) runesPage.BackgroundTransparency = 1; runesPage.Visible = false; runesPage.Parent = mainFrame
settingsPage = Instance.new("Frame") settingsPage.Size = UDim2.new(1, -20, 1, -85) settingsPage.Position = UDim2.new(0, 10, 0, 80) settingsPage.BackgroundTransparency = 1; settingsPage.Visible = false; settingsPage.Parent = mainFrame
--======================================================================================
-- DOMINATE HUB | PART 3 OF 8 (HEADER & NAV TAB INTERACTIVES)
--======================================================================================
local headerTitle = Instance.new("TextLabel") headerTitle.Size = UDim2.new(1, -20, 0, 35) headerTitle.Position = UDim2.new(0, 12, 0, 4) headerTitle.BackgroundTransparency = 1; headerTitle.TextColor3 = Color3.fromRGB(245, 245, 250) headerTitle.TextSize = 15; headerTitle.Font = Enum.Font.SourceSansBold; headerTitle.Text = "Dominate Hub | Noob Incremental" headerTitle.TextXAlignment = Enum.TextXAlignment.Left; headerTitle.Parent = mainFrame

minBtn = Instance.new("TextButton") minBtn.Size = UDim2.new(0, 95, 0, 24) minBtn.Position = UDim2.new(0.5, -47, 0.01, 0) minBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25) minBtn.TextColor3 = Color3.fromRGB(0, 136, 255) minBtn.TextSize = 12; minBtn.Font = Enum.Font.SourceSansBold; minBtn.Text = "Hide UI" minBtn.Parent = sg
local minCorner = Instance.new("UICorner") minCorner.CornerRadius = UDim.new(0, 5) minCorner.Parent = minBtn

local tabList = Instance.new("Frame") tabList.Size = UDim2.new(1, -20, 0, 32) tabList.Position = UDim2.new(0, 10, 0, 40) tabList.BackgroundTransparency = 1; tabList.Parent = mainFrame
tabRealm1 = Instance.new("TextButton") tabRealm1.Size = UDim2.new(0, 100, 1, 0) tabRealm1.Position = UDim2.new(0, 5, 0, 0) tabRealm1.BackgroundColor3 = Color3.fromRGB(230, 230, 235) tabRealm1.TextColor3 = Color3.fromRGB(15, 15, 15) tabRealm1.TextSize = 12; tabRealm1.Font = Enum.Font.SourceSansBold; tabRealm1.Text = "Realm 1" tabRealm1.Parent = tabList
tabRealm3 = Instance.new("TextButton") tabRealm3.Size = UDim2.new(0, 100, 1, 0) tabRealm3.Position = UDim2.new(0, 115, 0, 0) tabRealm3.BackgroundColor3 = Color3.fromRGB(45, 45, 45) tabRealm3.TextColor3 = Color3.fromRGB(170, 170, 170) tabRealm3.TextSize = 12; tabRealm3.Font = Enum.Font.SourceSansBold; tabRealm3.Text = "Realm 3" tabRealm3.Parent = tabList
tabRunes = Instance.new("TextButton") tabRunes.Size = UDim2.new(0, 100, 1, 0) tabRunes.Position = UDim2.new(0, 225, 0, 0) tabRunes.BackgroundColor3 = Color3.fromRGB(45, 45, 45) tabRunes.TextColor3 = Color3.fromRGB(170, 170, 170) tabRunes.TextSize = 12; tabRunes.Font = Enum.Font.SourceSansBold; tabRunes.Text = "Runes" tabRunes.Parent = tabList
tabSettings = Instance.new("TextButton") tabSettings.Size = UDim2.new(0, 100, 1, 0) tabSettings.Position = UDim2.new(0, 335, 0, 0) tabSettings.BackgroundColor3 = Color3.fromRGB(45, 45, 45) tabSettings.TextColor3 = Color3.fromRGB(170, 170, 170) tabSettings.TextSize = 12; tabSettings.Font = Enum.Font.SourceSansBold; tabSettings.Text = "Settings" tabSettings.Parent = tabList

Instance.new("UICorner", tabRealm1).CornerRadius = UDim.new(0, 16) Instance.new("UICorner", tabRealm3).CornerRadius = UDim.new(0, 16) Instance.new("UICorner", tabRunes).CornerRadius = UDim.new(0, 16) Instance.new("UICorner", tabSettings).CornerRadius = UDim.new(0, 16)

local subTabList = Instance.new("Frame") subTabList.Size = UDim2.new(1, 0, 0, 25) subTabList.Position = UDim2.new(0, 0, 0, 0) subTabList.BackgroundTransparency = 1; subTabList.Parent = realm1MasterPage
subBtnNoobs = Instance.new("TextButton") subBtnNoobs.Size = UDim2.new(0, 50, 1, 0) subBtnNoobs.Position = UDim2.new(0, 2, 0, 0) subBtnNoobs.BackgroundColor3 = Color3.fromRGB(230, 230, 235) subBtnNoobs.TextColor3 = Color3.fromRGB(15, 15, 15) subBtnNoobs.TextSize = 10; subBtnNoobs.Font = Enum.Font.SourceSansBold; subBtnNoobs.Text = "Noobs" subBtnNoobs.Parent = subTabList
subBtnOof = Instance.new("TextButton") subBtnOof.Size = UDim2.new(0, 75, 1, 0) subBtnOof.Position = UDim2.new(0, 54, 0, 0) subBtnOof.BackgroundColor3 = Color3.fromRGB(45, 45, 45) subBtnOof.TextColor3 = Color3.fromRGB(170, 170, 170) subBtnOof.TextSize = 10; subBtnOof.Font = Enum.Font.SourceSansBold; subBtnOof.Text = "Oof Upgrades" subBtnOof.Parent = subTabList
subBtnRebirth = Instance.new("TextButton") subBtnRebirth.Size = UDim2.new(0, 95, 1, 0) subBtnRebirth.Position = UDim2.new(0, 131, 0, 0) subBtnRebirth.BackgroundColor3 = Color3.fromRGB(45, 45, 45) subBtnRebirth.TextColor3 = Color3.fromRGB(170, 170, 170) subBtnRebirth.TextSize = 10; subBtnRebirth.Font = Enum.Font.SourceSansBold; subBtnRebirth.Text = "Rebirth Upgrades" subBtnRebirth.Parent = subTabList
subBtnFire = Instance.new("TextButton") subBtnFire.Size = UDim2.new(0, 75, 1, 0) subBtnFire.Position = UDim2.new(0, 228, 0, 0) subBtnFire.BackgroundColor3 = Color3.fromRGB(45, 45, 45) subBtnFire.TextColor3 = Color3.fromRGB(170, 170, 170) subBtnFire.TextSize = 10; subBtnFire.Font = Enum.Font.SourceSansBold; subBtnFire.Text = "Fire Upgrades" subBtnFire.Parent = subTabList
subBtnBlaze = Instance.new("TextButton") subBtnBlaze.Size = UDim2.new(0, 50, 1, 0) subBtnBlaze.Position = UDim2.new(0, 305, 0, 0) subBtnBlaze.BackgroundColor3 = Color3.fromRGB(45, 45, 45) subBtnBlaze.TextColor3 = Color3.fromRGB(170, 170, 170) subBtnBlaze.TextSize = 10; subBtnBlaze.Font = Enum.Font.SourceSansBold; subBtnBlaze.Text = "Blaze" subBtnBlaze.Parent = subTabList
subBtnCash = Instance.new("TextButton") subBtnCash.Size = UDim2.new(0, 75, 1, 0) subBtnCash.Position = UDim2.new(0, 357, 0, 0) subBtnCash.BackgroundColor3 = Color3.fromRGB(45, 45, 45) subBtnCash.TextColor3 = Color3.fromRGB(170, 170, 170) subBtnCash.TextSize = 10; subBtnCash.Font = Enum.Font.SourceSansBold; subBtnCash.Text = "Cash Upgrades" subBtnCash.Parent = subTabList

Instance.new("UICorner", subBtnNoobs).CornerRadius = UDim.new(0, 5) Instance.new("UICorner", subBtnOof).CornerRadius = UDim.new(0, 5) Instance.new("UICorner", subBtnRebirth).CornerRadius = UDim.new(0, 5) Instance.new("UICorner", subBtnFire).CornerRadius = UDim.new(0, 5) Instance.new("UICorner", subBtnBlaze).CornerRadius = UDim.new(0, 5) Instance.new("UICorner", subBtnCash).CornerRadius = UDim.new(0, 5)
--======================================================================================
-- DOMINATE HUB | PART 4 OF 8 (SCROLL LAYOUT CANVAS INJECTORS)
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
-- DOMINATE HUB | PART 5 OF 8 (UI INTERACTIVE GRID REGISTRY MAP)
--======================================================================================
toggleStarter = makeSubRow("Starter Noob Auto Upgrade", 1, realm1NoobScroll)
toggleCooker = makeSubRow("Cooker Noob Auto Upgrade", 2, realm1NoobScroll)
toggleFarmer = makeSubRow("Farmer Noob Auto Upgrade", 3, realm1NoobScroll)
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

-- RUNES SECTION COMPONENT ROW LAYOUT LISTING
toggleRollBasicRuneCard = gridRow("Auto Roll Basic Rune Circle (Fire)", 1, runesPage)
toggleRollBasicRuneCard.Size = UDim2.new(0, 75, 0, 26) toggleRollBasicRuneCard.Position = UDim2.new(1, -85, 0.5, -13)

toggleRollSuperRuneCard = gridRow("Auto Roll Super Rune Circle (Oof)", 2, runesPage)
toggleRollSuperRuneCard.Size = UDim2.new(0, 75, 0, 26) toggleRollSuperRuneCard.Position = UDim2.new(1, -85, 0.5, -13)

toggleRollAdvancedRuneCard = gridRow("Auto Roll Advanced Rune Circle (Gems)", 3, runesPage)
toggleRollAdvancedRuneCard.Size = UDim2.new(0, 75, 0, 26) toggleRollAdvancedRuneCard.Position = UDim2.new(1, -85, 0.5, -13)

toggleRollCosmicRuneCard = gridRow("Auto Roll Cosmic Prism Circle (Prisms)", 4, runesPage)
toggleRollCosmicRuneCard.Size = UDim2.new(0, 75, 0, 26) toggleRollCosmicRuneCard.Position = UDim2.new(1, -85, 0.5, -13)

toggleAFK = gridRow("Anti-AFK Safety Disconnect Protection", 1, settingsPage)
toggleAFK.Size = UDim2.new(0, 75, 0, 26) toggleAFK.Position = UDim2.new(1, -85, 0.5, -13) toggleAFK.BackgroundColor3 = Color3.fromRGB(20, 60, 20) toggleAFK.TextColor3 = Color3.fromRGB(120, 255, 120) toggleAFK.Text = "ACTIVE"
togglePrestige = gridRow("Auto Prestige (Server Max Buy Engine)", 2, settingsPage)
togglePrestige.Size = UDim2.new(0, 75, 0, 26) togglePrestige.Position = UDim2.new(1, -85, 0.5, -13)
toggleRebirthTimerCard = gridRow("Auto Rebirth (Every 10-Minute Loop Interval)", 3, settingsPage)
toggleRebirthTimerCard.Size = UDim2.new(0, 75, 0, 26) toggleRebirthTimerCard.Position = UDim2.new(1, -85, 0.5, -13)
toggleKillSwitch = gridRow("EMERGENCY SYSTEM KILL SWITCH", 4, settingsPage)
toggleKillSwitch.Size = UDim2.new(0, 75, 0, 26) toggleKillSwitch.Position = UDim2.new(1, -85, 0.5, -13) toggleKillSwitch.BackgroundColor3 = Color3.fromRGB(120, 20, 20) toggleKillSwitch.TextColor3 = Color3.fromRGB(255, 200, 200) toggleKillSwitch.Text = "TERMINATE"
--======================================================================================
-- DOMINATE HUB | PART 6 OF 8 (CHARACTER SYSTEM LINK COUPLERS)
--======================================================================================
print("PART 6 LOADED")

local function GetWorldRoot()
    local char = player.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end
--======================================================================================
-- DOMINATE HUB | PART 7 OF 8 (LOCOMOTION & AUTO-PRESTIGE SCANNER)
--======================================================================================
local MasterTargetVector = nil  
local BasicRuneVector = Vector3.new(1114.7530517578125, 10.3100004196167, -644.1510009765625)
local SuperRuneVector = Vector3.new(1082.0938720703125, 16.661418914794922, -782.02197265625)
local AdvancedRuneVector = Vector3.new(1293.495361328125, 16.515989303588867, -883.3126220703125)
local CosmicRuneVector = Vector3.new(783.4507446289062, 16.65555763244629, -855.9728393554688)

-- MASTER POSITION UPDATER THREAD
task.spawn(function()
    while Running do
        task.wait(0.1)
        local hrp = GetWorldRoot()
        if hrp and Running then
            local activeDestination = nil
            if MasterTargetVector then
                activeDestination = MasterTargetVector
            elseif _G.AutoRollCosmicRune then
                activeDestination = CosmicRuneVector
            elseif _G.AutoRollAdvancedRune then
                activeDestination = AdvancedRuneVector
            elseif _G.AutoRollSuperRune then
                activeDestination = SuperRuneVector
            elseif _G.AutoRollBasicRune then
                activeDestination = BasicRuneVector
            end
            
            if activeDestination and Running then
                if (hrp.Position - activeDestination).Magnitude > 5 then
                    hrp.CFrame = CFrame.new(activeDestination)
                end
            end
        end
    end
end)

-- TIMED ACTIVE-CHAIN SWEEPER LOOPS
task.spawn(function()
    while Running do
        task.wait(0.5)
        if _G.AutoFarmCash and Running then
            local gameContent = workspace:FindFirstChild("__GAME_CONTENT")
            local tycoon = gameContent and gameContent:FindFirstChild("Tycoon")
            local buttonsFolder = tycoon and tycoon:FindFirstChild("Buttons")
            
            if buttonsFolder and Running then
                local roundLockedPads = {}
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
                                attemptedAPadThisPass = true
                                MasterTargetVector = targetBuyPart.Position + Vector3.new(0, 3, 0)
                                task.wait(0.4)
                                
                                if not Running then break end
                                if btnModel:IsDescendantOf(buttonsFolder) then
                                    roundLockedPads[btnModel.Name] = true
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
                    if not attemptedAPadThisPass or not _G.AutoFarmCash or not Running then break end
                    task.wait(0.1)
                until false
                
                if Running then
                    MasterTargetVector = nil
                    local sleepEndTime = tick() + 300
                    repeat task.wait(1) until tick() >= sleepEndTime or not _G.AutoFarmCash or not Running
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

-- AUTOMATED SCREENSPACE PRESTIGE MONITOR THREAD
task.spawn(function()
    while Running do
        task.wait(1)
        if _G.AutoPrestige and NetRemote and Running then
            local pGui = player:FindFirstChild("PlayerGui")
            local foundEligibleText = false
            
            if pGui then
                -- Dynamically scans all active BillboardGuis and ScreenGuis on your monitor layout frame
                for _, desc in ipairs(pGui:GetDescendants()) do
                    if desc:IsA("TextLabel") then
                        local text = desc.Text:lower()
                        -- Detects when "Progress for Prestige" converts into a live click message
                        if text:find("prestige") and (text:find("can") or text:find("ready") or text:find("now") or text:find("click") or desc.TextColor3.G > 0.7) then
                            if not text:find("progress") then
                                foundEligibleText = true
                                break
                            end
                        end
                    end
                end
            end
            
            -- If the over-screen label layout greenlights the reset, fire the network purchase event instantly
            if foundEligibleText and Running then
                print("[Dominate Hub] Top screen indicator turned green/ready! Executing auto-prestige reset remote event sequence.")
                pcall(function() NetRemote:FireServer("Prestige") end)
                task.wait(5) -- Safe anti-spam interval window padding
            end
        end
    end
end)

local function buildPurchaseThread(flag, command, serverArgs)
    task.spawn(function()
        while Running do
            task.wait(0.4)
            if Running and _G[flag] and NetRemote then
                pcall(function() NetRemote:FireServer(command, unpack(serverArgs)) end)
            end
        end
    end)
end

local upgrades = {
    {F = "AutoUpgradeStarter",    T = "UpgradeNoobMax",    A = {"Starter"}},
    {F = "AutoUpgradeCooker",     T = "UpgradeNoobMax",    A = {"Cooker"}},
    {F = "AutoUpgradeFarmer",     T = "UpgradeNoobMax",    A = {"Farmer"}},
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
    while Running do
        task.wait(1)
        if Running and _G.AutoBlazeConvert and NetRemote then
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
-- DOMINATE HUB | PART 8 OF 8 (SIGNALS INTERACTIVE TOGGLES MAPPING FRAMEWORKS)
--======================================================================================
function tState(b, v) 
    _G[v] = not _G[v] 
    b.Text = _G[v] and "ACTIVE" or "DISABLED" 
    b.BackgroundColor3 = _G[v] and Color3.fromRGB(20, 60, 20) or Color3.fromRGB(60, 20, 20) 
    b.TextColor3 = _G[v] and Color3.fromRGB(120, 255, 120) or Color3.fromRGB(255, 120, 120) 
end

togglePharaoh.MouseButton1Click:Connect(function() tState(togglePharaoh, "AutoUpgradePharaoh") end) 
toggleAFK.MouseButton1Click:Connect(function() tState(toggleAFK, "AntiAFK") end) 
togglePrestige.MouseButton1Click:Connect(function() tState(togglePrestige, "AutoPrestige") end)
toggleStarter.MouseButton1Click:Connect(function() tState(toggleStarter, "AutoUpgradeStarter") end) 
toggleCooker.MouseButton1Click:Connect(function() tState(toggleCooker, "AutoUpgradeCooker") end) 
toggleFarmer.MouseButton1Click:Connect(function() tState(toggleFarmer, "AutoUpgradeFarmer") end) 
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
toggleAutoBlazeConvert.MouseButton1Click:Connect(function() tState(toggleAutoBlazeConvert, "AutoBlazeConvert") end)
toggleBlazeMoreBlaze.MouseButton1Click:Connect(function() tState(toggleBlazeMoreBlaze, "AutoBlazeMoreBlaze") end) 
toggleBlazeMoreFire.MouseButton1Click:Connect(function() tState(toggleBlazeMoreFire, "AutoBlazeMoreFire") end) 
toggleBlazeMoreOof.MouseButton1Click:Connect(function() tState(toggleBlazeMoreOof, "AutoBlazeMoreOof") end)

toggleAutoFarmCash.MouseButton1Click:Connect(function() tState(toggleAutoFarmCash, "AutoFarmCash") end)
toggleCashMoreCash.MouseButton1Click:Connect(function() tState(toggleCashMoreCash, "AutoUpgradeMoreCash") end)
toggleCashFasterDropper.MouseButton1Click:Connect(function() tState(toggleCashFasterDropper, "AutoUpgradeFasterDropper") end)
toggleCashMoreRuneLuck.MouseButton1Click:Connect(function() tState(toggleCashMoreRuneLuck, "AutoUpgradeMoreRuneLuck") end)

-- RUNES TOGGLE LINKED ASSET INTERACTIVE CONNECTORS
toggleRollBasicRuneCard.MouseButton1Click:Connect(function() tState(toggleRollBasicRuneCard, "AutoRollBasicRune") end)
toggleRollSuperRuneCard.MouseButton1Click:Connect(function() tState(toggleRollSuperRuneCard, "AutoRollSuperRune") end)
toggleRollAdvancedRuneCard.MouseButton1Click:Connect(function() tState(toggleRollAdvancedRuneCard, "AutoRollAdvancedRune") end)
toggleRollCosmicRuneCard.MouseButton1Click:Connect(function() tState(toggleRollCosmicRuneCard, "AutoRollCosmicRune") end)

toggleKillSwitch.MouseButton1Click:Connect(function()
    Running = false 
    getgenv().DominateHubLoaded = nil 
    for k, _ in pairs(_G) do if type(k) == "string" and (k:sub(1,4) == "Auto" or k == "AntiAFK") then _G[k] = false end end
    pcall(function() local cam = workspace.CurrentCamera if cam then cam.CameraType = Enum.CameraType.Custom end end) sg:Destroy()
    print("[Dominate Hub] System Kill Switch Triggered. 100% of background automated loops terminated.")
end)

function mainRoute(pOpen, bActive) 
    realm1MasterPage.Visible, realm3Page.Visible, runesPage.Visible, settingsPage.Visible = false, false, false, false; pOpen.Visible = true; 
    local tabs = {tabRealm1, tabRealm3, tabRunes, tabSettings}
    for _, t in ipairs(tabs) do t.BackgroundColor3, t.TextColor3 = Color3.fromRGB(45, 45, 45), Color3.fromRGB(170, 170, 170) end
    bActive.BackgroundColor3, bActive.TextColor3 = Color3.fromRGB(220, 220, 225), Color3.fromRGB(15, 15, 15) 
end
tabRealm1.MouseButton1Click:Connect(function() mainRoute(realm1MasterPage, tabRealm1) end) 
tabRealm3.MouseButton1Click:Connect(function() mainRoute(realm3Page, tabRealm3) end) 
tabRunes.MouseButton1Click:Connect(function() mainRoute(runesPage, tabRunes) end) 
tabSettings.MouseButton1Click:Connect(function() mainRoute(settingsPage, tabSettings) end)

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

print("PART 8 LOADED - DOMINATE HUB RUNNING COMPLETELY OPERATIONAL")

