--======================================================================================
-- BROSWE HUB | PART 7 OF 10 (TRAIL ENGINES & SPATIAL CALCULATIONS)
--======================================================================================
local GFolder = workspace:WaitForChild("__GAME_CONTENT", 5) and workspace.__GAME_CONTENT:WaitForChild("Contents", 5)
local InsideTrail, PrepTimerActive = false, false
local TrailState = "Capsule"

local CastlePosition = Vector3.new(879.0405, 12.3479, 13443.0859)
local CapsulePosition = Vector3.new(712.6, 5.7, 7814.0)
local FirePosition = Vector3.new(1080.31, 13.55, -675.99)

local function GetWorldRoot()
    local char = player.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function MovePlayer(pos)
    local hrp = GetWorldRoot()
    if hrp then hrp.CFrame = CFrame.new(pos) end
end

local function GetChosenTrail()
    if _G.AutoHardTrails then return "Hard" end
    if _G.AutoMediumTrails then return "Medium" end
    if _G.AutoEasyTrails then return "Easy" end
    return nil
end

local function GetGate(name)
    local world3 = workspace:FindFirstChild("__GAME_CONTENT") and workspace.__GAME_CONTENT:FindFirstChild("Contents") and workspace.__GAME_CONTENT.Contents:FindFirstChild("WORLD - 3.AncientBossModel")
    if world3 then return world3:FindFirstChild(name .. "Gate", true) end
end

local function GateOpen(gate)
    if not gate then return false end
    local gui = gate:FindFirstChildWhichIsA("SurfaceGui", true)
    if gui then
        local label = gui:FindFirstChildWhichIsA("TextLabel", true)
        if label then return label.Text:lower():find("open") ~= nil end
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
            if _G.AutoCapsule then InsideTrail = false MovePlayer(CapsulePosition) end
            if selected then
                local gate = GetGate(selected)
                if GateOpen(gate) then TrailState = "EnteringTrail" end
            end
        elseif TrailState == "EnteringTrail" then
            MovePlayer(CastlePosition) task.wait(0.5)
            local gate = GetGate(selected)
            if gate and GetWorldRoot() then GetWorldRoot().CFrame = gate.CFrame * CFrame.new(0, 0, -5) end
            task.wait(1) InsideTrail = true TrailState = "Fighting"
        elseif TrailState == "Fighting" then
            local enemy = FindEnemy()
            local hrp = GetWorldRoot()
            if enemy and hrp then hrp.CFrame = CFrame.new(enemy.Position + Vector3.new(0, 3, 0), enemy.Position) end
            if not InsideTrail then TrailState = "Capsule" end
        end
    end
end)
--======================================================================================
-- BROSWE HUB | PART 8 OF 10 (AUTO UPGRADE REFACTOR & ENV LOOPS)
--======================================================================================
task.spawn(function()
    local upgrades = {
        {F = "AutoUpgradeStarter",    T = "UpgradeNoobMax",    S = "UpgradeNoob",    A = {"Starter"}},
        {F = "AutoUpgradeCooker",     T = "UpgradeNoobMax",    S = "UpgradeNoob",    A = {"Cooker"}},
        {F = "AutoUpgradeExplorer",   T = "UpgradeNoobMax",    S = "UpgradeNoob",    A = {"Explorer"}},
        {F = "AutoUpgradeMagician",   T = "UpgradeNoobMax",    S = "UpgradeNoob",    A = {"Magician"}},
        {F = "AutoUpgradeArcher",     T = "UpgradeNoobMax",    S = "UpgradeNoob",    A = {"Archer"}},
        {F = "AutoUpgradeSoldier",    T = "UpgradeNoobMax",    S = "UpgradeNoob",    A = {"Soldier"}},
        {F = "AutoUpgradePharaoh",    T = "UpgradeNoobMax",    S = "UpgradeNoob",    A = {"Pharaoh"}},
        {F = "AutoUpgradeMoreOof",    T = "UpgradeUpgradeMax", A = {"Oof", "MoreOof"}},
        {F = "AutoUpgradeFasterNoobs",T = "UpgradeUpgradeMax", A = {"Oof", "FasterNoobs"}},
        {F = "AutoRebirthMoreOof",    T = "UpgradeUpgradeMax", A = {"Rebirth", "MoreOof"}},
        {F = "AutoRebirthMoreRebirth",T = "UpgradeUpgradeMax", A = {"Rebirth", "MoreRebirth"}},
        {F = "AutoRebirthMoreFire",   T = "UpgradeUpgradeMax", A = {"Rebirth", "MoreFire"}},
        {F = "AutoFireMoreFire",      T = "UpgradeUpgradeMax", A = {"Fire", "MoreFire"}},
        {F = "AutoFireMoreOof",       T = "UpgradeUpgradeMax", A = {"Fire", "MoreOof"}},
        {F = "AutoFireMoreRebirth",   T = "UpgradeUpgradeMax", A = {"Fire", "MoreRebirth"}},
        {F = "AutoFireMoreBulk",      T = "UpgradeUpgradeMax", A = {"Fire", "MoreBulk"}}
    }
    while true do
        task.wait(0.4)
        for _, item in ipairs(upgrades) do
            if _G[item.F] then
                pcall(function() 
                    NetRemote:FireServer(item.T, unpack(item.A)) 
                    if item.S then
                        task.wait(0.05)
                        for i = 1, 5 do NetRemote:FireServer(item.S, unpack(item.A)) end
                    end
                end)
                task.wait(0.1)
            end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(1)
        if _G.AutoBlazeMoreBlaze then print("Blaze MoreBlaze") end
        if _G.AutoBlazeMoreFire then print("Blaze MoreFire") end
        if _G.AutoBlazeMoreOof then print("Blaze MoreOof") end
    end
end)

task.spawn(function()
    local rebirthTimer = 0
    while true do
        task.wait(0.5)
        if _G.AutoPrestige then pcall(function() NetRemote:FireServer("Prestige") end) end
        if _G.AutoRebirthTimer then
            rebirthTimer = rebirthTimer + 0.5
            if rebirthTimer >= 600 then rebirthTimer = 0 pcall(function() NetRemote:FireServer("Rebirth") end) end
        else rebirthTimer = 0 end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.4)
        if _G.AutoBuildFire and TrailState == "Capsule" then
            local hrp = GetWorldRoot()
            if hrp and (hrp.Position - FirePosition).Magnitude > 5 then hrp.CFrame = CFrame.new(FirePosition) end
        end
        if _G.AutoRuneBasic and not InsideTrail then
            local hrp = GetWorldRoot() if hrp then hrp.CFrame = CFrame.new(879.04, 12.35, 13443.09) end
        end
    end
end)
--======================================================================================
-- BROSWE HUB | PART 9 OF 10 (REMOTE HOOKS & UI PROPERTY SYNCHRONIZATION)
--======================================================================================
local hook
hook = hookfunction(NetRemote.FireServer, function(self, ...)
    local args = {...}
    if args == "Prestige" or args == "Rebirth" then
        task.spawn(function()
            task.wait(120) 
            local minionFolder = workspace:FindFirstChild("_GAME_MINIONS")
            local hrp = GetWorldRoot()
            if minionFolder and hrp then
                local originalPos = hrp.CFrame
                for _, pad in ipairs(minionFolder:GetChildren()) do
                    local touchTarget = pad:IsA("BasePart") and pad or pad:FindFirstChildWhichIsA("BasePart", true)
                    if touchTarget then
                        hrp.CFrame = CFrame.new(touchTarget.Position + Vector3.new(0, 2, 0)) task.wait(0.4) 
                    end
                end
                hrp.CFrame = originalPos
            end
        end)
    end
    return hook(self, ...)
end)

local function tState(b, v) 
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
--======================================================================================
-- BROSWE HUB | PART 10 OF 10 (VIEW NAVIGATION LABELS & VIEWPORT SLIDERS)
--======================================================================================
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

local function mainRoute(pOpen, bActive) 
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

local function route(b1, b2, b3, b4, b5, s1, s2, s3, s4, s5)
    s1.Visible, s2.Visible, s3.Visible, s4.Visible, s5.Visible = true, false, false, false, false
    local btns = {b1, b2, b3, b4, b5}
    for i, b in ipairs(btns) do
        if i == 1 then b.BackgroundColor3, b.TextColor3 = Color3.fromRGB(230, 230, 235), Color3.fromRGB(15, 15, 15)
        else b.BackgroundColor3, b.TextColor3 = Color3.fromRGB(45, 45, 45), Color3.fromRGB(170, 170, 170) end
    end
end
subBtnNoobs.MouseButton1Click:Connect(function() route(subBtnNoobs, subBtnOof, subBtnRebirth, subBtnFire, subBtnBlaze, realm1NoobScroll, realm1UpgradeScroll, realm1RebirthScroll, realm1FireScroll, realm1BlazeScroll) end)
subBtnOof.MouseButton1Click:Connect(function() route(subBtnOof, subBtnNoobs, subBtnRebirth, subBtnFire, subBtnBlaze, realm1UpgradeScroll, realm1NoobScroll, realm1RebirthScroll, realm1FireScroll, realm1BlazeScroll) end)
subBtnRebirth.MouseButton1Click:Connect(function() route(subBtnRebirth, subBtnNoobs, subBtnOof, subBtnFire, subBtnBlaze, realm1RebirthScroll, realm1NoobScroll, realm1UpgradeScroll, realm1FireScroll, realm1BlazeScroll) end)
subBtnFire.MouseButton1Click:Connect(function() route(subBtnFire, subBtnNoobs, subBtnOof, subBtnRebirth, subBtnBlaze, realm1FireScroll, realm1NoobScroll, realm1UpgradeScroll, realm1RebirthScroll, realm1FireScroll) end)
subBtnBlaze.MouseButton1Click:Connect(function() route(subBtnBlaze, subBtnNoobs, subBtnOof, subBtnRebirth, subBtnFire, realm1BlazeScroll, realm1NoobScroll, realm1UpgradeScroll, realm1RebirthScroll, realm1FireScroll) end)

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
