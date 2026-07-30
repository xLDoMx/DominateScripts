--======================================================================================
-- DOMINATE HUB | PART 1 OF 8 (CRITICAL ENGINE PATH VERIFICATION)
--======================================================================================
player = game:GetService("Players").LocalPlayer
vu = game:GetService("VirtualUser")
NetRemote = nil

_G.AntiAFK, _G.AutoPrestige = true, false
_G.AutoUpgradeStarter, _G.AutoUpgradeCooker, _G.AutoUpgradeExplorer, _G.AutoUpgradeMagician, _G.AutoUpgradeArcher, _G.AutoUpgradeSoldier, _G.AutoUpgradeMoreOof, _G.AutoUpgradeFasterNoobs = false, false, false, false, false, false, false, false
_G.AutoRebirthMoreOof, _G.AutoRebirthMoreRebirth, _G.AutoRebirthMoreFire = false, false, false
_G.AutoFireMoreFire, _G.AutoFireMoreOof, _G.AutoFireMoreRebirth, _G.AutoFireMoreBulk = false, false, false, false
_G.AutoRebirthTimer = false
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
-- DOMINATE HUB | PART 2 OF 8 (MASTER PAGES REGISTRY SETUP)
--======================================================================================
local sg = Instance.new("ScreenGui") sg.Name = "DominateHubMirror" sg.Parent = player:WaitForChild("PlayerGui") sg.ResetOnSpawn = false
mainFrame = Instance.new("Frame") mainFrame.Size = UDim2.new(0, 460, 0, 360) mainFrame.Position = UDim2.new(0.5, -230, 0.5, -180) mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20) mainFrame.BackgroundTransparency = 0.15; mainFrame.BorderSizePixel = 0; mainFrame.Parent = sg
local mainCorner = Instance.new("UICorner") mainCorner.CornerRadius = UDim.new(0, 10) mainCorner.Parent = mainFrame

realm1MasterPage = Instance.new("Frame") realm1MasterPage.Size = UDim2.new(1, -20, 1, -85) realm1MasterPage.Position = UDim2.new(0, 10, 0, 80) realm1MasterPage.BackgroundTransparency = 1; realm1MasterPage.Visible = true; realm1MasterPage.Parent = mainFrame
realm3Page = Instance.new("Frame") realm3Page.Size = UDim2.new(1, -20, 1, -85) realm3Page.Position = UDim2.new(0, 10, 0, 80) realm3Page.BackgroundTransparency = 1; realm3Page.Visible = false; realm3Page.Parent = mainFrame
settingsPage = Instance.new("Frame") settingsPage.Size = UDim2.new(1, -20, 1, -85) settingsPage.Position = UDim2.new(0, 10, 0, 80) settingsPage.BackgroundTransparency = 1; settingsPage.Visible = false; settingsPage.Parent = mainFrame
--======================================================================================
-- DOMINATE HUB | PART 3 OF 8 (INTERFACE INTERACTIVE HEADER AND TABS LOADING)
--======================================================================================
local headerTitle = Instance.new("TextLabel") headerTitle.Size = UDim2.new(1, -20, 0, 35) headerTitle.Position = UDim2.new(0, 12, 0, 4) headerTitle.BackgroundTransparency = 1; headerTitle.TextColor3 = Color3.fromRGB(245, 245, 250) headerTitle.TextSize = 15; headerTitle.Font = Enum.Font.SourceSansBold; headerTitle.Text = "Dominate Hub | Noob Incremental" headerTitle.TextXAlignment = Enum.TextXAlignment.Left; headerTitle.Parent = mainFrame

minBtn = Instance.new("TextButton") minBtn.Size = UDim2.new(0, 95, 0, 24) minBtn.Position = UDim2.new(0.5, -47, 0.01, 0) minBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25) minBtn.TextColor3 = Color3.fromRGB(0, 136, 255) minBtn.TextSize = 12; minBtn.Font = Enum.Font.SourceSansBold; minBtn.Text = "Hide UI" minBtn.Parent = sg
local minCorner = Instance.new("UICorner") minCorner.CornerRadius = UDim.new(0, 5) minCorner.Parent = minBtn

local tabList = Instance.new("Frame") tabList.Size = UDim2.new(1, -20, 0, 32) tabList.Position = UDim2.new(0, 10, 0, 40) tabList.BackgroundTransparency = 1; tabList.Parent = mainFrame
tabRealm1 = Instance.new("TextButton") tabRealm1.Size = UDim2.new(0, 130, 1, 0) tabRealm1.Position = UDim2.new(0, 10, 0, 0) tabRealm1.BackgroundColor3 = Color3.fromRGB(230, 230, 235) tabRealm1.TextColor3 = Color3.fromRGB(15, 15, 15) tabRealm1.TextSize = 12; tabRealm1.Font = Enum.Font.SourceSansBold; tabRealm1.Text = "Realm 1" tabRealm1.Parent = tabList
tabRealm3 = Instance.new("TextButton") tabRealm3.Size = UDim2.new(0, 130, 1, 0) tabRealm3.Position = UDim2.new(0, 155, 0, 0) tabRealm3.BackgroundColor3 = Color3.fromRGB(45, 45, 45) tabRealm3.TextColor3 = Color3.fromRGB(170, 170, 170) tabRealm3.TextSize = 12; tabRealm3.Font = Enum.Font.SourceSansBold; tabRealm3.Text = "Realm 3" tabRealm3.Parent = tabList
tabSettings = Instance.new("TextButton") tabSettings.Size = UDim2.new(0, 130, 1, 0) tabSettings.Position = UDim2.new(0, 300, 0, 0) tabSettings.BackgroundColor3 = Color3.fromRGB(45, 45, 45) tabSettings.TextColor3 = Color3.fromRGB(170, 170, 170) tabSettings.TextSize = 12; tabSettings.Font = Enum.Font.SourceSansBold; tabSettings.Text = "Settings" tabSettings.Parent = tabList

Instance.new("UICorner", tabRealm1).CornerRadius = UDim.new(0, 16) Instance.new("UICorner", tabRealm3).CornerRadius = UDim.new(0, 16) Instance.new("UICorner", tabSettings).CornerRadius = UDim.new(0, 16)

local subTabList = Instance.new("Frame") subTabList.Size = UDim2.new(1, 0, 0, 25) subTabList.Position = UDim2.new(0, 0, 0, 0) subTabList.BackgroundTransparency = 1; subTabList.Parent = realm1MasterPage
subBtnNoobs = Instance.new("TextButton") subBtnNoobs.Size = UDim2.new(0, 50, 1, 0) subBtnNoobs.Position = UDim2.new(0, 2, 0, 0) subBtnNoobs.BackgroundColor3 = Color3.fromRGB(230, 230, 235) subBtnNoobs.TextColor3 = Color3.fromRGB(15, 15, 15) subBtnNoobs.TextSize = 10; subBtnNoobs.Font = Enum.Font.SourceSansBold; subBtnNoobs.Text = "Noobs" subBtnNoobs.Parent = subTabList
subBtnOof = Instance.new("TextButton") subBtnOof.Size = UDim2.new(0, 75, 1, 0) subBtnOof.Position = UDim2.new(0, 54, 0, 0) subBtnOof.BackgroundColor3 = Color3.fromRGB(45, 45, 45) subBtnOof.TextColor3 = Color3.fromRGB(170, 170, 170) subBtnOof.TextSize = 10; subBtnOof.Font = Enum.Font.SourceSansBold; subBtnOof.Text = "Oof Upgrades" subBtnOof.Parent = subTabList
subBtnRebirth = Instance.new("TextButton") subBtnRebirth.Size = UDim2.new(0, 95, 1, 0) subBtnRebirth.Position = UDim2.new(0, 131, 0, 0) subBtnRebirth.BackgroundColor3 = Color3.fromRGB(45, 45, 45) subBtnRebirth.TextColor3 = Color3.fromRGB(170, 170, 170) subBtnRebirth.TextSize = 10; subBtnRebirth.Font = Enum.Font.SourceSansBold; subBtnRebirth.Text = "Rebirth Upgrades" subBtnRebirth.Parent = subTabList
subBtnFire = Instance.new("TextButton") subBtnFire.Size = UDim2.new(0, 75, 1, 0) subBtnFire.Position = UDim2.new(0, 228, 0, 0) subBtnFire.BackgroundColor3 = Color3.fromRGB(45, 45, 45) subBtnFire.TextColor3 = Color3.fromRGB(170, 170, 170) subBtnFire.TextSize = 10; subBtnFire.Font = Enum.Font.SourceSansBold; subBtnFire.Text = "Fire Upgrades" subBtnFire.Parent = subTabList
subBtnBlaze = Instance.new("TextButton") subBtnBlaze.Size = UDim2.new(0, 50, 1, 0) subBtnBlaze.Position = UDim2.new(0, 305, 0, 0) subBtnBlaze.BackgroundColor3 = Color3.fromRGB(45, 45, 45) subBtnBlaze.TextColor3 = Color3.fromRGB(170, 170, 170) subBtnBlaze.TextSize = 10; subBtnBlaze.Font = Enum.Font.SourceSansBold; subBtnBlaze.Text = "Blaze" subBtnBlaze.Parent = subTabList
subBtnCash = Instance.new("TextButton") subBtnCash.Size = UDim2.new(0, 75, 1, 0) subBtnCash.Position = UDim2.new(0, 357, 0, 0) subBtnCash.BackgroundColor3 = Color3.fromRGB(45, 45, 45) subBtnCash.TextColor3 = Color3.fromRGB(170, 170, 170) subBtnCash.TextSize = 10; subBtnCash.Font = Enum.Font.SourceSansBold; subBtnCash.Text = "Cash Upgrades" subBtnCash.Parent = subTabList

Instance.new("UICorner", subBtnNoobs).CornerRadius = UDim.new(0, 5) Instance.new("UICorner", subBtnOof).CornerRadius = UDim.new(0, 5) Instance.new("UICorner", subBtnRebirth).CornerRadius = UDim.new(0, 5) Instance.new("UICorner", subBtnFire).CornerRadius = UDim.new(0, 5) Instance.new("UICorner", subBtnBlaze).CornerRadius = UDim.new(0, 5) Instance.new("UICorner", subBtnCash).CornerRadius = UDim.new(0, 5)
--======================================================================================
-- DOMINATE HUB | PART 4 OF 8 (SCROLL CONTAINER INSTANTIATIONS)
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
-- DOMINATE HUB | PART 5 OF 8 (COMPONENT INTERACTIVE TOGGLES LIST MAPPING)
--======================================================================================
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
--======================================================================================
-- DOMINATE HUB | PART 6 OF 8 (STREAMLINED LOCATION TRACKERS MATRIX)
--======================================================================================
local SweeperActiveMovement = false

print("PART 6 LOADED")

local function GetWorldRoot()
    local char = player.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

-- FLUID PLOT FINDER: Tracks your moving tycoon base plane dynamically on every wake cycle
local function ResolveConveyorPosition()
    local gameContent = workspace:FindFirstChild("__GAME_CONTENT")
    if gameContent then
        for _, folder in ipairs(gameContent:GetChildren()) do
            if folder.Name:lower():find("tycoon") or folder.Name:lower():find("plot") then
                local conveyor = folder:FindFirstChild("Conveyor", true)
                if conveyor and conveyor:IsA("BasePart") then
                    local ownerVal = folder:FindFirstChild("Owner", true) or folder:FindFirstChild("Player", true)
                    if not ownerVal or (ownerVal:IsA("ValueBase") and ownerVal.Value == player) or ownerVal.Name:lower():find(player.Name:lower()) then
                        return conveyor.Position + Vector3.new(0, 4, 0)
                    end
                end
            end
        end
    end
    local primaryTycoon = gameContent and gameContent:FindFirstChild("Tycoon")
    local standardConveyor = primaryTycoon and primaryTycoon:FindFirstChild("Conveyor", true)
    if standardConveyor and standardConveyor:IsA("BasePart") then
        return standardConveyor.Position + Vector3.new(0, 4, 0)
    end
    local hrp = GetWorldRoot()
    if hrp then return hrp.Position + Vector3.new(0, 15, 0) end
    return Vector3.new(874.84, 15.0, 13426.69)
end


--======================================================================================
-- DOMINATE HUB | PART 7 OF 8 (5-MINUTE BLIND FORCE-STEP SCHEDULER)
--======================================================================================
-- DEDICATED BASELINE CONVEYOR HARVEST ANCHOR
task.spawn(function()
    while true do
        task.wait(0.3)
        if _G.AutoFarmCash and not SweeperActiveMovement then
            local hrp = GetWorldRoot()
            if hrp then hrp.CFrame = CFrame.new(ResolveConveyorPosition()) end
        end
    end
end)

-- BLIND INTERVAL SWEEPER ENGINE: Bypasses money logic completely via a 5-minute timed step routine
task.spawn(function()
    while true do
        task.wait(0.5)
        
        if _G.AutoFarmCash then
            local gameContent = workspace:FindFirstChild("__GAME_CONTENT")
            local tycoon = gameContent and gameContent:FindFirstChild("Tycoon")
            local buttonsFolder = tycoon and tycoon:FindFirstChild("Buttons")
            
            if buttonsFolder then
                local currentButtons = buttonsFolder:GetChildren()
                print("[Dominate Hub] Initiating scheduled factory sweep batch pass...")
                
                -- Step through every single button model in order, exactly once per pass
                for _, btnModel in ipairs(currentButtons) do
                    if not _G.AutoFarmCash then break end
                    
                    if btnModel:IsA("Model") then
                        local targetBuyPart = btnModel:FindFirstChild("BuyingButtonPart", true)
                        local hrp = GetWorldRoot()
                        
                        if targetBuyPart and targetBuyPart:IsA("BasePart") and hrp then
                            SweeperActiveMovement = true
                            
                            -- Force-step directly onto the pad vector 
                            hrp.CFrame = CFrame.new(targetBuyPart.Position + Vector3.new(0, 3, 0))
                            task.wait(0.35) -- Stable physical touch window duration
                            
                            -- Instantly return to baseline conveyor line to avoid anchoring errors
                            hrp.CFrame = CFrame.new(ResolveConveyorPosition())
                            task.wait(0.05) -- Tiny cooldown recovery gap before the next jump
                        end
                    end
                end
                
                -- ENTER DEEP TIMED HARVEST: Lock the character to the conveyor for exactly 5 minutes
                SweeperActiveMovement = false
                print("[Dominate Hub] Sweep batch complete. Harvesting cash drops for 5 minutes...")
                
                local sleepEndTime = tick() + 300 -- 5 minutes * 60 seconds
                repeat 
                    task.wait(1) 
                until tick() >= sleepEndTime or not _G.AutoFarmCash
                
                print("[Dominate Hub] 5 minutes concluded. Preparing next factory sweep pass.")
            else
                SweeperActiveMovement = false
                task.wait(2)
            end
        else
            SweeperActiveMovement = false
            task.wait(1)
        end
    end
end)

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
toggleAutoBlazeConvert.MouseButton1Click:Connect(function() tState(toggleAutoBlazeConvert, "AutoBlazeConvert") end)

toggleAutoFarmCash.MouseButton1Click:Connect(function() tState(toggleAutoFarmCash, "AutoFarmCash") end)
toggleCashMoreCash.MouseButton1Click:Connect(function() tState(toggleCashMoreCash, "AutoUpgradeMoreCash") end)
toggleCashFasterDropper.MouseButton1Click:Connect(function() tState(toggleCashFasterDropper, "AutoUpgradeFasterDropper") end)
toggleCashMoreRuneLuck.MouseButton1Click:Connect(function() tState(toggleCashMoreRuneLuck, "AutoUpgradeMoreRuneLuck") end)

toggleKillSwitch.MouseButton1Click:Connect(function()
    for k, _ in pairs(_G) do if type(k) == "string" and (k:sub(1,4) == "Auto" or k == "AntiAFK") then _G[k] = false end end
    pcall(function() local cam = workspace.CurrentCamera if cam then cam.CameraType = Enum.CameraType.Custom end end) sg:Destroy()
end)

function mainRoute(pOpen, bActive) 
    realm1MasterPage.Visible, realm3Page.Visible, settingsPage.Visible = false, false, false; pOpen.Visible = true; 
    local tabs = {tabRealm1, tabRealm3, tabSettings}
    for _, t in ipairs(tabs) do t.BackgroundColor3, t.TextColor3 = Color3.fromRGB(45, 45, 45), Color3.fromRGB(170, 170, 170) end
    bActive.BackgroundColor3, bActive.TextColor3 = Color3.fromRGB(220, 220, 225), Color3.fromRGB(15, 15, 15) 
end
tabRealm1.MouseButton1Click:Connect(function() mainRoute(realm1MasterPage, tabRealm1) end) 
tabRealm3.MouseButton1Click:Connect(function() mainRoute(realm3Page, tabRealm3) end) 
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
