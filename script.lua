local player = game:GetService("Players").LocalPlayer
local NetRemote = game:GetService("ReplicatedStorage"):WaitForChild("__Net"):WaitForChild("MainRemote")
local vu = game:GetService("VirtualUser")

_G.AutoEasyTrails, _G.AutoMediumTrails, _G.AutoHardTrails, _G.AutoCapsule, _G.AutoUpgradePharaoh, _G.AntiAFK, _G.AutoPrestige = false, false, false, false, false, true, false
_G.AutoUpgradeStarter, _G.AutoUpgradeCooker, _G.AutoUpgradeExplorer, _G.AutoUpgradeMagician, _G.AutoUpgradeArcher, _G.AutoUpgradeSoldier, _G.AutoUpgradeMoreOof, _G.AutoUpgradeFasterNoobs = false, false, false, false, false, false, false, false
_G.AutoRebirthMoreOof, _G.AutoRebirthMoreRebirth, _G.AutoRebirthMoreFire = false, false, false
_G.AutoFireMoreFire, _G.AutoFireMoreOof, _G.AutoFireMoreRebirth, _G.AutoFireMoreBulk = false, false, false, false
_G.AutoRebirthTimer, _G.AutoRuneBasic = false, false
_G.AutoConvertBlaze, _G.AutoBlazeMoreBlaze, _G.AutoBlazeMoreFire, _G.AutoBlazeMoreOof = false, false, false, false

player.Idled:Connect(function()
    if _G.AntiAFK then
        vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame) task.wait(1) vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end
end)

local sg = Instance.new("ScreenGui") sg.Name = "LukesBrosweHubMirror" sg.Parent = player:WaitForChild("PlayerGui") sg.ResetOnSpawn = false
local mainFrame = Instance.new("Frame") mainFrame.Size = UDim2.new(0, 460, 0, 360) mainFrame.Position = UDim2.new(0.5, -230, 0.5, -180) mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20) mainFrame.BackgroundTransparency = 0.15; mainFrame.BorderSizePixel = 0; mainFrame.Parent = sg
local mainCorner = Instance.new("UICorner") mainCorner.CornerRadius = UDim.new(0, 10) mainCorner.Parent = mainFrame
local headerTitle = Instance.new("TextLabel") headerTitle.Size = UDim2.new(1, -20, 0, 35) headerTitle.Position = UDim2.new(0, 12, 0, 4) headerTitle.BackgroundTransparency = 1; headerTitle.TextColor3 = Color3.fromRGB(245, 245, 250) headerTitle.TextSize = 15; headerTitle.Font = Enum.Font.SourceSansBold; headerTitle.Text = "Broswe Hub | Noob Incremental" headerTitle.TextXAlignment = Enum.TextXAlignment.Left; headerTitle.Parent = mainFrame
local minBtn = Instance.new("TextButton") minBtn.Size = UDim2.new(0, 95, 0, 24) minBtn.Position = UDim2.new(0.5, -47, 0.01, 0) minBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25) minBtn.TextColor3 = Color3.fromRGB(0, 150, 255) minBtn.TextSize = 12; minBtn.Font = Enum.Font.SourceSansBold; minBtn.Text = "Hide UI" minBtn.Parent = sg
local minCorner = Instance.new("UICorner") minCorner.CornerRadius = UDim.new(0, 5) minCorner.Parent = minBtn
local tabList = Instance.new("Frame") tabList.Size = UDim2.new(1, -20, 0, 32) tabList.Position = UDim2.new(0, 10, 0, 40) tabList.BackgroundTransparency = 1; tabList.Parent = mainFrame
local tabTrial = Instance.new("TextButton") tabTrial.Size = UDim2.new(0, 55, 1, 0) tabTrial.Position = UDim2.new(0, 5, 0, 0) tabTrial.BackgroundColor3 = Color3.fromRGB(230, 230, 235) tabTrial.TextColor3 = Color3.fromRGB(15, 15, 15) tabTrial.TextSize = 12; tabTrial.Font = Enum.Font.SourceSansBold; tabTrial.Text = "Trial" tabTrial.Parent = tabList
local tabCapsules = Instance.new("TextButton") tabCapsules.Size = UDim2.new(0, 70, 1, 0) tabCapsules.Position = UDim2.new(0, 65, 0, 0) tabCapsules.BackgroundColor3 = Color3.fromRGB(45, 45, 45) tabCapsules.TextColor3 = Color3.fromRGB(170, 170, 170) tabCapsules.TextSize = 12; tabCapsules.Font = Enum.Font.SourceSansBold; tabCapsules.Text = "Capsules" tabCapsules.Parent = tabList
local tabRealm1 = Instance.new("TextButton") tabRealm1.Size = UDim2.new(0, 70, 1, 0) tabRealm1.Position = UDim2.new(0, 140, 0, 0) tabRealm1.BackgroundColor3 = Color3.fromRGB(45, 45, 45) tabRealm1.TextColor3 = Color3.fromRGB(170, 170, 170) tabRealm1.TextSize = 12; tabRealm1.Font = Enum.Font.SourceSansBold; tabRealm1.Text = "Realm 1" tabRealm1.Parent = tabList
local tabRealm3 = Instance.new("TextButton") tabRealm3.Size = UDim2.new(0, 70, 1, 0) tabRealm3.Position = UDim2.new(0, 215, 0, 0) tabRealm3.BackgroundColor3 = Color3.fromRGB(45, 45, 45) tabRealm3.TextColor3 = Color3.fromRGB(170, 170, 170) tabRealm3.TextSize = 12; tabRealm3.Font = Enum.Font.SourceSansBold; tabRealm3.Text = "Realm 3" tabRealm3.Parent = tabList
local tabSettings = Instance.new("TextButton") tabSettings.Size = UDim2.new(0, 70, 1, 0) tabSettings.Position = UDim2.new(0, 290, 0, 0) tabSettings.BackgroundColor3 = Color3.fromRGB(45, 45, 45) tabSettings.TextColor3 = Color3.fromRGB(170, 170, 170) tabSettings.TextSize = 12; tabSettings.Font = Enum.Font.SourceSansBold; tabSettings.Text = "Settings" tabSettings.Parent = tabList
local tabRunes = Instance.new("TextButton") tabRunes.Size = UDim2.new(0, 60, 1, 0) tabRunes.Position = UDim2.new(0, 365, 0, 0) tabRunes.BackgroundColor3 = Color3.fromRGB(45, 45, 45) tabRunes.TextColor3 = Color3.fromRGB(170, 170, 170) tabRunes.TextSize = 12; tabRunes.Font = Enum.Font.SourceSansBold; tabRunes.Text = "Runes" tabRunes.Parent = tabList

Instance.new("UICorner", tabTrial).CornerRadius = UDim.new(0, 16) Instance.new("UICorner", tabCapsules).CornerRadius = UDim.new(0, 16) Instance.new("UICorner", tabRealm1).CornerRadius = UDim.new(0, 16) Instance.new("UICorner", tabRealm3).CornerRadius = UDim.new(0, 16) Instance.new("UICorner", tabSettings).CornerRadius = UDim.new(0, 16) Instance.new("UICorner", tabRunes).CornerRadius = UDim.new(0, 16)

local trialPage = Instance.new("Frame") trialPage.Size = UDim2.new(1, -20, 1, -85) trialPage.Position = UDim2.new(0, 10, 0, 80) trialPage.BackgroundTransparency = 1; trialPage.Visible = true; trialPage.Parent = mainFrame
local capsulePage = Instance.new("Frame") capsulePage.Size = UDim2.new(1, -20, 1, -85) capsulePage.Position = UDim2.new(0, 10, 0, 80) capsulePage.BackgroundTransparency = 1; capsulePage.Visible = false; capsulePage.Parent = mainFrame
local realm1MasterPage = Instance.new("Frame") realm1MasterPage.Size = UDim2.new(1, -20, 1, -85) realm1MasterPage.Position = UDim2.new(0, 10, 0, 80) realm1MasterPage.BackgroundTransparency = 1; realm1MasterPage.Visible = false; realm1MasterPage.Parent = mainFrame
local realm3Page = Instance.new("Frame") realm3Page.Size = UDim2.new(1, -20, 1, -85) realm3Page.Position = UDim2.new(0, 10, 0, 80) realm3Page.BackgroundTransparency = 1; realm3Page.Visible = false; realm3Page.Parent = mainFrame
local settingsPage = Instance.new("Frame") settingsPage.Size = UDim2.new(1, -20, 1, -85) settingsPage.Position = UDim2.new(0, 10, 0, 80) settingsPage.BackgroundTransparency = 1; settingsPage.Visible = false; settingsPage.Parent = mainFrame
local runesPage = Instance.new("Frame") runesPage.Size = UDim2.new(1, -20, 1, -85) runesPage.Position = UDim2.new(0, 10, 0, 80) runesPage.BackgroundTransparency = 1; runesPage.Visible = false; runesPage.Parent = mainFrame
local subTabList = Instance.new("Frame") subTabList.Size = UDim2.new(1, 0, 0, 25) subTabList.Position = UDim2.new(0, 0, 0, 0) subTabList.BackgroundTransparency = 1; subTabList.Parent = realm1MasterPage

local subBtnNoobs = Instance.new("TextButton") subBtnNoobs.Size = UDim2.new(0, 50, 1, 0) subBtnNoobs.Position = UDim2.new(0, 2, 0, 0) subBtnNoobs.BackgroundColor3 = Color3.fromRGB(230, 230, 235) subBtnNoobs.TextColor3 = Color3.fromRGB(15, 15, 15) subBtnNoobs.TextSize = 10; subBtnNoobs.Font = Enum.Font.SourceSansBold; subBtnNoobs.Text = "Noobs" subBtnNoobs.Parent = subTabList
local subBtnOof = Instance.new("TextButton") subBtnOof.Size = UDim2.new(0, 75, 1, 0) subBtnOof.Position = UDim2.new(0, 54, 0, 0) subBtnOof.BackgroundColor3 = Color3.fromRGB(45, 45, 45) subBtnOof.TextColor3 = Color3.fromRGB(170, 170, 170) subBtnOof.TextSize = 10; subBtnOof.Font = Enum.Font.SourceSansBold; subBtnOof.Text = "Oof Upgrades" subBtnOof.Parent = subTabList
local subBtnRebirth = Instance.new("TextButton") subBtnRebirth.Size = UDim2.new(0, 95, 1, 0) subBtnRebirth.Position = UDim2.new(0, 131, 0, 0) subBtnRebirth.BackgroundColor3 = Color3.fromRGB(45, 45, 45) subBtnRebirth.TextColor3 = Color3.fromRGB(170, 170, 170) subBtnRebirth.TextSize = 10; subBtnRebirth.Font = Enum.Font.SourceSansBold; subBtnRebirth.Text = "Rebirth Upgrades" subBtnRebirth.Parent = subTabList
local subBtnFire = Instance.new("TextButton") subBtnFire.Size = UDim2.new(0, 80, 1, 0) subBtnFire.Position = UDim2.new(0, 228, 0, 0) subBtnFire.BackgroundColor3 = Color3.fromRGB(45, 45, 45) subBtnFire.TextColor3 = Color3.fromRGB(170, 170, 170) subBtnFire.TextSize = 10; subBtnFire.Font = Enum.Font.SourceSansBold; subBtnFire.Text = "Fire Upgrades" subBtnFire.Parent = subTabList
local subBtnBlaze = Instance.new("TextButton") subBtnBlaze.Size = UDim2.new(0, 65, 1, 0) subBtnBlaze.Position = UDim2.new(0, 310, 0, 0) subBtnBlaze.BackgroundColor3 = Color3.fromRGB(45, 45, 45) subBtnBlaze.TextColor3 = Color3.fromRGB(170, 170, 170) subBtnBlaze.TextSize = 10; subBtnBlaze.Font = Enum.Font.SourceSansBold; subBtnBlaze.Text = "Blaze" subBtnBlaze.Parent = subTabList

Instance.new("UICorner", subBtnNoobs).CornerRadius = UDim.new(0, 5) Instance.new("UICorner", subBtnOof).CornerRadius = UDim.new(0, 5) Instance.new("UICorner", subBtnRebirth).CornerRadius = UDim.new(0, 5) Instance.new("UICorner", subBtnFire).CornerRadius = UDim.new(0, 5) Instance.new("UICorner", subBtnBlaze).CornerRadius = UDim.new(0, 5)

local function makeScroll(canvas) local s = Instance.new("ScrollingFrame") s.Size = UDim2.new(1, 0, 1, -30) s.Position = UDim2.new(0, 0, 0, 30) s.BackgroundTransparency = 1; s.BorderSizePixel = 0; s.CanvasSize = UDim2.new(0, 0, 0, canvas) s.ScrollBarThickness = 3; s.ScrollBarImageColor3 = Color3.fromRGB(0, 136, 255) s.Visible = false; s.Parent = realm1MasterPage return s end
local realm1NoobScroll = makeScroll(310) realm1NoobScroll.Visible = true
local realm1UpgradeScroll = makeScroll(110)
local realm1RebirthScroll = makeScroll(160)
local realm1FireScroll = makeScroll(210)
local realm1BlazeScroll = makeScroll(210)
local function gridRow(txt, pos, page)
    local f = Instance.new("Frame") f.Size = UDim2.new(1, -10, 0, 36) f.Position = UDim2.new(0, 5, 0, (pos-1)*41+5) f.BackgroundColor3 = Color3.fromRGB(30, 30, 30) f.BorderSizePixel = 0; f.Parent = page
    local l = Instance.new("TextLabel") l.Size = UDim2.new(0.7, 0, 1, 0) l.Position = UDim2.new(0, 12, 0, 0) l.BackgroundTransparency = 1; l.TextColor3 = Color3.fromRGB(220, 220, 225) l.TextSize = 13; l.Font = Enum.Font.SourceSans; l.Text = txt; l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = f
    local b = Instance.new("TextButton") b.Size = UDim2.new(0, 75, 0, 22) b.Position = UDim2.new(1, -85, 0.5, -11) b.BackgroundColor3 = Color3.fromRGB(60, 20, 20) b.TextColor3 = Color3.fromRGB(255, 120, 120) b.TextSize = 11; b.Font = Enum.Font.SourceSansBold; b.Text = "DISABLED" b.Parent = f
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 5) Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5) return b
end

local toggleEasy = gridRow("Auto Trial (Easy) - Fast Entry", 1, trialPage)
local toggleMed = gridRow("Auto Trial (Medium) - Progress Entry", 2, trialPage)
local toggleHard = gridRow("Auto Trial (Hard) - Rapid Chain", 3, trialPage)
local toggleTrailCapsule = gridRow("Auto Open Capsule After Trial (Ancient)", 4, trialPage)
local toggleStandaloneCapsule = gridRow("Open Ancient Capsule", 1, capsulePage)
toggleStandaloneCapsule.Size = UDim2.new(0, 75, 0, 26) toggleStandaloneCapsule.Position = UDim2.new(1, -85, 0.5, -13)

local function makeSubRow(label, idx, scr)
    local f = Instance.new("Frame") f.Size = UDim2.new(1, -12, 0, 42) f.Position = UDim2.new(0, 5, 0, (idx-1)*48+5) f.BackgroundColor3 = Color3.fromRGB(30, 30, 30) f.BorderSizePixel = 0; f.Parent = scr
    local l = Instance.new("TextLabel") l.Size = UDim2.new(0.7, 0, 1, 0) l.Position = UDim2.new(0, 12, 0, 0) l.BackgroundTransparency = 1; l.TextColor3 = Color3.fromRGB(220, 220, 225) l.TextSize = 13; l.Font = Enum.Font.SourceSans; l.Text = label; l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = f
    local b = Instance.new("TextButton") b.Size = UDim2.new(0, 75, 0, 24) b.Position = UDim2.new(1, -85, 0.5, -12) b.BackgroundColor3 = Color3.fromRGB(60, 20, 20) b.TextColor3 = Color3.fromRGB(255, 120, 120) b.TextSize = 11; b.Font = Enum.Font.SourceSansBold; b.Text = "DISABLED" b.Parent = f
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 5) Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5) return b
end

local toggleStarter = makeSubRow("Starter Noob Auto Upgrade", 1, realm1NoobScroll)
local toggleCooker = makeSubRow("Cooker Noob Auto Upgrade", 2, realm1NoobScroll)
local toggleExplorer = makeSubRow("Explorer Noob Auto Upgrade", 3, realm1NoobScroll)
local toggleMagician = makeSubRow("Magician Noob Auto Upgrade", 4, realm1NoobScroll)
local toggleArcher = makeSubRow("Archer Noob Auto Upgrade", 5, realm1NoobScroll)
local toggleSoldier = makeSubRow("Soldier Noob Auto Upgrade", 6, realm1NoobScroll)
local toggleMoreOof = makeSubRow("More Oof Auto Upgrade", 1, realm1UpgradeScroll)
local toggleFasterNoobs = makeSubRow("Faster Noobs Auto Upgrade", 2, realm1UpgradeScroll)
local toggleRebirthOof = makeSubRow("More Oof (Rebirth)", 1, realm1RebirthScroll)
local toggleRebirthRebirth = makeSubRow("More Rebirth (Rebirth)", 2, realm1RebirthScroll)
local toggleRebirthFire = makeSubRow("More Fire (Rebirth)", 3, realm1RebirthScroll)
local toggleFireFire = makeSubRow("More Fire (Fire)", 1, realm1FireScroll)
local toggleFireOof = makeSubRow("More Oof (Fire)", 2, realm1FireScroll)
local toggleFireRebirth = makeSubRow("More Rebirth (Fire)", 3, realm1FireScroll)
local toggleFireBulk = makeSubRow("More Bulk (Fire)", 4, realm1FireScroll)

local toggleConvertBlaze = makeSubRow("Auto Convert Fire to Blaze", 1, realm1BlazeScroll)
local toggleBlazeMoreBlaze = makeSubRow("More Blaze (Blaze)", 2, realm1BlazeScroll)
local toggleBlazeMoreFire = makeSubRow("More Fire (Blaze)", 3, realm1BlazeScroll)
local toggleBlazeMoreOof = makeSubRow("More Oof (Blaze)", 4, realm1BlazeScroll)

local togglePharaoh = gridRow("Auto Upgrade Pharaoh (Max)", 1, realm3Page)
togglePharaoh.Size = UDim2.new(0, 75, 0, 26) togglePharaoh.Position = UDim2.new(1, -85, 0.5, -13)
local toggleAFK = gridRow("Anti-AFK Safety Disconnect Protection", 1, settingsPage)
toggleAFK.Size = UDim2.new(0, 75, 0, 26) toggleAFK.Position = UDim2.new(1, -85, 0.5, -13) toggleAFK.BackgroundColor3 = Color3.fromRGB(20, 60, 20) toggleAFK.TextColor3 = Color3.fromRGB(120, 255, 120) toggleAFK.Text = "ACTIVE"
local togglePrestige = gridRow("Auto Prestige (Server Max Buy Engine)", 2, settingsPage)
togglePrestige.Size = UDim2.new(0, 75, 0, 26) togglePrestige.Position = UDim2.new(1, -85, 0.5, -13)
local toggleRebirthTimerCard = gridRow("Auto Rebirth (Every 10-Minute Loop Interval)", 3, settingsPage)
toggleRebirthTimerCard.Size = UDim2.new(0, 75, 0, 26) toggleRebirthTimerCard.Position = UDim2.new(1, -85, 0.5, -13)

local toggleKillSwitch = gridRow("EMERGENCY SYSTEM KILL SWITCH", 4, settingsPage)
toggleKillSwitch.Size = UDim2.new(0, 75, 0, 26) toggleKillSwitch.Position = UDim2.new(1, -85, 0.5, -13) toggleKillSwitch.BackgroundColor3 = Color3.fromRGB(120, 20, 20) toggleKillSwitch.TextColor3 = Color3.fromRGB(255, 200, 200) toggleKillSwitch.Text = "TERMINATE"

local toggleRuneBasic = gridRow("Teleport Basic Rune (Auto-Collection Loop)", 1, runesPage)
toggleRuneBasic.Size = UDim2.new(0, 75, 0, 26) toggleRuneBasic.Position = UDim2.new(1, -85, 0.5, -13)

local GFolder = workspace:WaitForChild("__GAME_CONTENT", 5) and workspace.__GAME_CONTENT:WaitForChild("Contents", 5)
local CastleCenterPosition = Vector3.new(879.0405883789062, 12.347942352294922, 13443.0859375)
local InsideTrail, PrepTimerActive, LastCameraScout = false, false, 0

local function ForceWalkThroughGate(gatePart)
    local char = player.Character
    local hrp, hum = char and char:FindFirstChild("HumanoidRootPart"), char and char:FindFirstChildOfClass("Humanoid")
    if hrp and hum and gatePart then
        hrp.CFrame = CFrame.new(gatePart.Position + (gatePart.CFrame.LookVector * 4), gatePart.Position)
        task.wait(0.1) local startTime = tick()
        while tick() - startTime < 1.2 and not InsideTrail do hum:Move(Vector3.new(0, 0, -1), true) task.wait(0.02) end
    end
end

task.spawn(function()
    while true do
        task.wait(0.2)
        if _G.AutoEasyTrails or _G.AutoMediumTrails or _G.AutoHardTrails or _G.AutoCapsule then
            pcall(function()
                local character = player.Character or player.CharacterAdded:Wait()
                local hrp = character:WaitForChild("HumanoidRootPart", 5) if not hrp then return end
                local distanceToArena = (hrp.Position - Vector3.new(767.4, 11.5, 13766.8)).Magnitude
                local distanceToCastle = (hrp.Position - CastleCenterPosition).Magnitude
                if distanceToArena < 250 then
                    InsideTrail = true 
                    if (_G.AutoEasyTrails or _G.AutoMediumTrails or _G.AutoHardTrails) and not PrepTimerActive then
                        PrepTimerActive = true
                        task.spawn(function()
                            task.wait(60) 
                            while InsideTrail and (_G.AutoEasyTrails or _G.AutoMediumTrails or _G.AutoHardTrails) do
                                task.wait(0.1)
                                pcall(function()
                                    local targetEnemyRoot, shortestDistance = nil, math.huge
                                    for _, object in pairs(workspace:GetDescendants()) do
                                        if object:IsA("Model") and object:FindFirstChild("HumanoidRootPart") and object:FindFirstChild("Humanoid") then
                                            if object.Name ~= player.Name and not game.Players:GetPlayerFromCharacter(object) and object.Humanoid.Health > 0 then
                                                local dist = (hrp.Position - object.HumanoidRootPart.Position).Magnitude
                                                if dist < shortestDistance then shortestDistance = dist; targetEnemyRoot = object.HumanoidRootPart end
                                            end
                                        end
                                    end
                                    if targetEnemyRoot then hrp.CFrame = CFrame.new(targetEnemyRoot.Position + (targetEnemyRoot.CFrame.LookVector * 1.5), targetEnemyRoot.Position) end
                                end)
                            end
                        end)
                    end
                else
                    InsideTrail, PrepTimerActive = false, false
                    if (_G.AutoEasyTrails or _G.AutoMediumTrails or _G.AutoHardTrails) and (tick() - LastCameraScout > 10) and distanceToCastle > 50 then
                        LastCameraScout = tick() local cam = workspace.CurrentCamera
                        if cam then local originalType, originalCFrame = cam.CameraType, cam.CFrame; cam.CameraType = Enum.CameraType.Scriptable; cam.CFrame = CFrame.new(CastleCenterPosition + Vector3.new(0, 5, 10), CastleCenterPosition) task.wait(0.1) cam.CameraType, cam.CFrame = originalType, originalCFrame end
                    end
                    local EasyText = GFolder and GFolder:FindFirstChild("WORLD - 1.WorldModel", true) and GFolder["WORLD - 1.WorldModel"].MainPart.SurfaceGUI.Desc
                    local MedText  = GFolder and GFolder:FindFirstChild("WORLD - 2.DesertModel", true) and GFolder["WORLD - 2.DesertModel"].MainPart.SurfaceGUI.Desc
                    local HardText = GFolder and GFolder:FindFirstChild("WORLD - 3.AncientBossModel", true) and GFolder["WORLD - 3.AncientBossModel"].MainPart.SurfaceGUI.Desc
                    if _G.AutoEasyTrails and EasyText and EasyText.Text:lower():match("is open") then
                        local gateObj = EasyText:FindFirstAncestorOfClass("Part") or EasyText:FindFirstAncestorOfClass("MeshPart") if gateObj then ForceWalkThroughGate(gateObj) end
                    elseif _G.AutoMediumTrails and MedText and MedText.Text:lower():match("is open") then
                        local gateObj = MedText:FindFirstAncestorOfClass("Part") or MedText:FindFirstAncestorOfClass("MeshPart") if gateObj then ForceWalkThroughGate(gateObj) end
                    elseif _G.AutoHardTrails and HardText and HardText.Text:lower():match("is open") then
                        local gateObj = HardText:FindFirstAncestorOfClass("Part") or HardText:FindFirstAncestorOfClass("MeshPart") if gateObj then ForceWalkThroughGate(gateObj) end
                    else
                        if _G.AutoCapsule then hrp.CFrame = CFrame.new(712.6, 5.7, 7814.0) end
                    end
                end
            end)
        end
    end
end)
task.spawn(function()
    while true do task.wait(0.5) 
        if _G.AutoUpgradeStarter then NetRemote:FireServer("UpgradeNoobMax", "Starter") end
        if _G.AutoUpgradeCooker then NetRemote:FireServer("UpgradeNoobMax", "Cooker") end
        if _G.AutoUpgradeExplorer then NetRemote:FireServer("UpgradeNoobMax", "Explorer") end
        if _G.AutoUpgradeMagician then NetRemote:FireServer("UpgradeNoobMax", "Magician") end
        if _G.AutoUpgradeArcher then NetRemote:FireServer("UpgradeNoobMax", "Archer") end
        if _G.AutoUpgradeSoldier then NetRemote:FireServer("UpgradeNoobMax", "Soldier") end
        if _G.AutoUpgradeMoreOof then NetRemote:FireServer("UpgradeUpgradeMax", "Oof", "MoreOof") end
        if _G.AutoUpgradeFasterNoobs then NetRemote:FireServer("UpgradeUpgradeMax", "Oof", "FasterNoobs") end
        if _G.AutoUpgradePharaoh then NetRemote:FireServer("UpgradeNoobMax", "Pharaoh") end
    end
end)

task.spawn(function()
    while true do task.wait(0.5) 
        if _G.AutoRebirthMoreOof then NetRemote:FireServer("UpgradeUpgradeMax", "Rebirth", "MoreOof") end
        if _G.AutoRebirthMoreRebirth then NetRemote:FireServer("UpgradeUpgradeMax", "Rebirth", "MoreRebirth") end
        if _G.AutoRebirthMoreFire then NetRemote:FireServer("UpgradeUpgradeMax", "Rebirth", "MoreFire") end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.2)

        if _G.AutoFireMoreFire then
            pcall(function()
                NetRemote:FireServer("UpgradeUpgradeMax", "Fire", "MoreFire")
            end)
            task.wait(0.25)
        end

        if _G.AutoFireMoreOof then
            pcall(function()
                NetRemote:FireServer("UpgradeUpgradeMax", "Fire", "MoreOof")
            end)
            task.wait(0.25)
        end

        if _G.AutoFireMoreRebirth then
            pcall(function()
                NetRemote:FireServer("UpgradeUpgradeMax", "Fire", "MoreRebirth")
            end)
            task.wait(0.25)
        end

        if _G.AutoFireMoreBulk then
            pcall(function()
                NetRemote:FireServer("UpgradeUpgradeMax", "Fire", "MoreBulk")
            end)
            task.wait(0.25)
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.5)

        if _G.AutoPrestige then
            pcall(function()
                NetRemote:FireServer("Prestige")
            end)
        end
    end
end)

task.spawn(function() while true do task.wait(1) if _G.AutoRebirthTimer then pcall(function() NetRemote:FireServer("Rebirth") end) task.wait(600) end end end)
task.spawn(function() while true do task.wait(0.2) if _G.AutoRuneBasic and not InsideTrail then pcall(function() local c = player.Character local hrp = c and c:FindFirstChild("HumanoidRootPart") if hrp then hrp.CFrame = CFrame.new(879.04, 12.35, 13443.09) end end) end end end)
task.spawn(function() while true do task.wait(0.12) if _G.AutoCapsule and not InsideTrail then local args = { "ToggleMinionAutoOpen", "Ancient" } NetRemote:FireServer(unpack(args)) end end end)
local function route(b1, b2, b3, b4, b5, s1, s2, s3, s4, s5) s1.Visible, s2.Visible, s3.Visible, s4.Visible, s5.Visible = true, false, false, false, false; b1.BackgroundColor3, b1.TextColor3 = Color3.fromRGB(230, 230, 235), Color3.fromRGB(15, 15, 15) b2.BackgroundColor3, b2.TextColor3 = Color3.fromRGB(45, 45, 45), Color3.fromRGB(170, 170, 170) b3.BackgroundColor3, b3.TextColor3 = Color3.fromRGB(45, 45, 45), Color3.fromRGB(170, 170, 170) b4.BackgroundColor3, b4.TextColor3 = Color3.fromRGB(45, 45, 45), Color3.fromRGB(170, 170, 170) b5.BackgroundColor3, b5.TextColor3 = Color3.fromRGB(45, 45, 45), Color3.fromRGB(170, 170, 170) end
subBtnNoobs.MouseButton1Click:Connect(function() route(subBtnNoobs, subBtnOof, subBtnRebirth, subBtnFire, subBtnBlaze, realm1NoobScroll, realm1UpgradeScroll, realm1RebirthScroll, realm1FireScroll, realm1BlazeScroll) end)
subBtnOof.MouseButton1Click:Connect(function() route(subBtnOof, subBtnNoobs, subBtnRebirth, subBtnFire, subBtnBlaze, realm1UpgradeScroll, realm1NoobScroll, realm1RebirthScroll, realm1FireScroll, realm1BlazeScroll) end)
subBtnRebirth.MouseButton1Click:Connect(function() route(subBtnRebirth, subBtnNoobs, subObjOof, subBtnFire, subBtnBlaze, realm1RebirthScroll, realm1NoobScroll, realm1UpgradeScroll, realm1FireScroll, realm1BlazeScroll) end)
subBtnFire.MouseButton1Click:Connect(function() route(subBtnFire, subBtnNoobs, subBtnOof, subBtnRebirth, subBtnBlaze, realm1FireScroll, realm1NoobScroll, realm1UpgradeScroll, realm1RebirthScroll, realm1BlazeScroll) end)
subBtnBlaze.MouseButton1Click:Connect(function() route(subBtnBlaze, subBtnNoobs, subBtnOof, subBtnRebirth, subBtnFire, realm1BlazeScroll, realm1NoobScroll, realm1UpgradeScroll, realm1RebirthScroll, realm1FireScroll) end)

local function mainRoute(pOpen, bActive) trialPage.Visible, capsulePage.Visible, realm1MasterPage.Visible, realm3Page.Visible, settingsPage.Visible, runesPage.Visible = false, false, false, false, false, false; pOpen.Visible = true; tabTrial.BackgroundColor3, tabTrial.TextColor3 = Color3.fromRGB(45, 45, 45), Color3.fromRGB(170, 170, 170) tabCapsules.BackgroundColor3, tabCapsules.TextColor3 = Color3.fromRGB(45, 45, 45), Color3.fromRGB(170, 170, 170) tabRealm1.BackgroundColor3, tabRealm1.TextColor3 = Color3.fromRGB(45, 45, 45), Color3.fromRGB(170, 170, 170) tabRealm3.BackgroundColor3, tabRealm3.TextColor3 = Color3.fromRGB(45, 45, 45), Color3.fromRGB(170, 170, 170) tabSettings.BackgroundColor3, tabSettings.TextColor3 = Color3.fromRGB(45, 45, 45), Color3.fromRGB(170, 170, 170) tabRunes.BackgroundColor3, tabRunes.TextColor3 = Color3.fromRGB(45, 45, 45), Color3.fromRGB(170, 170, 170); bActive.BackgroundColor3, bActive.TextColor3 = Color3.fromRGB(220, 220, 225), Color3.fromRGB(15, 15, 15) end
tabTrial.MouseButton1Click:Connect(function() mainRoute(trialPage, tabTrial) end) tabCapsules.MouseButton1Click:Connect(function() mainRoute(capsulePage, tabCapsules) end) tabRealm1.MouseButton1Click:Connect(function() mainRoute(realm1MasterPage, tabRealm1) end) tabRealm3.MouseButton1Click:Connect(function() mainRoute(realm3Page, tabRealm3) end) tabSettings.MouseButton1Click:Connect(function() mainRoute(settingsPage, tabSettings) end) tabRunes.MouseButton1Click:Connect(function() mainRoute(runesPage, tabRunes) end)
minBtn.MouseButton1Click:Connect(function() mainFrame.Visible = not mainFrame.Visible; minBtn.Text = mainFrame.Visible and "Hide UI" or "Lukes Script" minBtn.TextColor3 = mainFrame.Visible and Color3.fromRGB(0, 136, 255) or Color3.fromRGB(0, 215, 110) end)

local function tState(b, v) _G[v] = not _G[v] b.Text = _G[v] and "ACTIVE" or "DISABLED" b.BackgroundColor3 = _G[v] and Color3.fromRGB(20, 60, 20) or Color3.fromRGB(60, 20, 20) b.TextColor3 = _G[v] and Color3.fromRGB(120, 255, 120) or Color3.fromRGB(255, 120, 120) end
toggleEasy.MouseButton1Click:Connect(function() tState(toggleEasy, "AutoEasyTrails") end) toggleMed.MouseButton1Click:Connect(function() tState(toggleMed, "AutoMediumTrails") end) toggleHard.MouseButton1Click:Connect(function() tState(toggleHard, "AutoHardTrails") end) togglePharaoh.MouseButton1Click:Connect(function() tState(togglePharaoh, "AutoUpgradePharaoh") end) toggleAFK.MouseButton1Click:Connect(function() tState(toggleAFK, "AntiAFK") end) togglePrestige.MouseButton1Click:Connect(function() tState(togglePrestige, "AutoPrestige") end)
toggleStarter.MouseButton1Click:Connect(function() tState(toggleStarter, "AutoUpgradeStarter") end) toggleCooker.MouseButton1Click:Connect(function() tState(toggleCooker, "AutoUpgradeCooker") end) toggleExplorer.MouseButton1Click:Connect(function() tState(toggleExplorer, "AutoUpgradeExplorer") end) toggleMagician.MouseButton1Click:Connect(function() tState(toggleMagician, "AutoUpgradeMagician") end) toggleArcher.MouseButton1Click:Connect(function() tState(toggleArcher, "AutoUpgradeArcher") end) toggleSoldier.MouseButton1Click:Connect(function() tState(toggleSoldier, "AutoUpgradeSoldier") end) toggleMoreOof.MouseButton1Click:Connect(function() tState(toggleMoreOof, "AutoUpgradeMoreOof") end) toggleFasterNoobs.MouseButton1Click:Connect(function() tState(toggleFasterNoobs, "AutoUpgradeFasterNoobs") end)
toggleRebirthOof.MouseButton1Click:Connect(function() tState(toggleRebirthOof, "AutoRebirthMoreOof") end) toggleRebirthRebirth.MouseButton1Click:Connect(function() tState(toggleRebirthRebirth, "AutoRebirthMoreRebirth") end) toggleRebirthFire.MouseButton1Click:Connect(function() tState(toggleRebirthFire, "AutoRebirthMoreFire") end)

toggleFireFire.MouseButton1Click:Connect(function() tState(toggleFireFire, "AutoFireMoreFire") end)
toggleFireOof.MouseButton1Click:Connect(function() tState(toggleFireOof, "AutoFireMoreOof") end)
toggleFireRebirth.MouseButton1Click:Connect(function() tState(toggleFireRebirth, "AutoFireMoreRebirth") end)
toggleFireBulk.MouseButton1Click:Connect(function() tState(toggleFireBulk, "AutoFireMoreBulk") end)

toggleRebirthTimerCard.MouseButton1Click:Connect(function() tState(toggleRebirthTimerCard, "AutoRebirthTimer") end) toggleRuneBasic.MouseButton1Click:Connect(function() tState(toggleRuneBasic, "AutoRuneBasic") end)
toggleConvertBlaze.MouseButton1Click:Connect(function() tState(toggleConvertBlaze, "AutoConvertBlaze") end) toggleBlazeMoreBlaze.MouseButton1Click:Connect(function() tState(toggleBlazeMoreBlaze, "AutoBlazeMoreBlaze") end) toggleBlazeMoreFire.MouseButton1Click:Connect(function() tState(toggleConvertBlaze, "AutoBlazeMoreFire") end) toggleBlazeMoreOof.MouseButton1Click:Connect(function() tState(toggleBlazeMoreOof, "AutoBlazeMoreOof") end)

toggleKillSwitch.MouseButton1Click:Connect(function()
    for k, _ in pairs(_G) do if type(k) == "string" and (k:sub(1,4) == "Auto" or k == "AntiAFK") then _G[k] = false end end
    pcall(function() local cam = workspace.CurrentCamera if cam then cam.CameraType = Enum.CameraType.Custom end end)
    sg:Destroy()
end)

local function uCaps() local s = _G.AutoCapsule and "ACTIVE" or "DISABLED" local c = _G.AutoCapsule and Color3.fromRGB(20, 60, 20) or Color3.fromRGB(60, 20, 20) local t = _G.AutoCapsule and Color3.fromRGB(120, 255, 120) or Color3.fromRGB(255, 120, 120) toggleTrailCapsule.Text, toggleTrailCapsule.BackgroundColor3, toggleTrailCapsule.TextColor3 = s, c, t toggleStandaloneCapsule.Text, toggleStandaloneCapsule.BackgroundColor3, toggleStandaloneCapsule.TextColor3 = s, c, t end
toggleTrailCapsule.MouseButton1Click:Connect(function() _G.AutoCapsule = not _G.AutoCapsule; uCaps() end) toggleStandaloneCapsule.MouseButton1Click:Connect(function() _G.AutoCapsule = not _G.AutoCapsule; uCaps() end)
