--======================================================================================
-- DOMINATE HUB | PRO EDITION (STABLE V17.3 - TYPE-SAFE ENVIRONMENT & TRIAL FIX)
--======================================================================================
local Env = (type(getgenv) == "function" and getgenv()) or _G

if Env.DominateHubLoaded then 
    pcall(function()
        local parentTarget = (type(gethui) == "function" and gethui()) or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
        local oldUI = parentTarget:FindFirstChild("DominateHubMirror")
        if oldUI then oldUI:Destroy() end
        local oldBlur = game:GetService("Lighting"):FindFirstChild("DominateHubBlur")
        if oldBlur then oldBlur:Destroy() end
    end)
    print("[Dominate Hub] Reloading Safe Instance...")
end
Env.DominateHubLoaded = true

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

local Running = true
local player = Players.LocalPlayer

-- VERIFIED MASTER VECTORS (INCLUDING TRIAL VECTORS)
local Dest = {
    EasyTrial = Vector3.new(856.3858, 11.1623, 13441.8535),
    MediumTrial = Vector3.new(874.0194, 11.1781, 13418.9121),
    HardTrial = Vector3.new(908.3367, 11.1623, 13442.0332),
    Dunes = Vector3.new(981.1582, 4.5862, 7767.3315),
    SandPit = Vector3.new(552.6134, 3.9798, 7827.5971),
    SandRegenPad = Vector3.new(557.1278, 5.0837, 7820.8671),
    AncientBossSpawn = Vector3.new(627.4028, 4.8705, 7854.8388),
    RitualChamber = Vector3.new(837.1246, 3.9983, 7904.0763),
    Basic = Vector3.new(1114.753, 10.310, -644.151),
    Super = Vector3.new(1082.093, 16.661, -782.021),
    Advanced = Vector3.new(1293.495, 16.515, -883.312),
    Cosmic = Vector3.new(783.450, 16.655, -855.972),
    ClassicCap = Vector3.new(-2586.923, 43.317, -659.105),
    FootballCap = Vector3.new(-2603.007, 36.295, -31.061),
    SuperCap = Vector3.new(618.032, 9.653, 3172.149),
    AncientCap = Vector3.new(714.6417, 4.8705, 7814.7265)
}

-- RUNTIME FLAGS & CONFIGS
Env.AutoEasyTrial = false
Env.AutoMediumTrial = false
Env.AutoHardTrial = false
Env.AutoAncientBossFarm = false
Env.AutoRegenSandLayers = false
Env.TargetSandLayer = 3
Env.AutoRollDunesRune = false

local trialIsRunning = false
local MobTargetVector = nil
local MasterTargetVector = nil

-- BLUR EFFECT & TOAST NOTIFICATIONS
pcall(function()
    local blur = Instance.new("BlurEffect")
    blur.Name = "DominateHubBlur"
    blur.Size = 6
    blur.Parent = Lighting
end)

local function showToast(msg)
    task.spawn(function()
        local parentGui = (type(gethui) == "function" and gethui()) or player:WaitForChild("PlayerGui")
        local toast = Instance.new("Frame")
        toast.Size = UDim2.new(0, 220, 0, 38)
        toast.Position = UDim2.new(1, 10, 1, -60)
        toast.BackgroundColor3 = Color3.fromRGB(18, 12, 28)
        toast.BackgroundTransparency = 0.1
        toast.BorderSizePixel = 0
        toast.Parent = parentGui
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = toast

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -12, 1, 0)
        label.Position = UDim2.new(0, 6, 0, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(240, 240, 250)
        label.TextSize = 11
        label.Font = Enum.Font.GothamBold
        label.Text = msg
        label.Parent = toast

        toast:TweenPosition(UDim2.new(1, -235, 1, -60), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)
        task.wait(2.8)
        toast:TweenPosition(UDim2.new(1, 10, 1, -60), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.25, true)
        task.wait(0.25)
        toast:Destroy()
    end)
end

-- UI CREATION
local parentTarget = (type(gethui) == "function" and gethui()) or player:WaitForChild("PlayerGui")
local sg = Instance.new("ScreenGui")
sg.Name = "DominateHubMirror"
sg.ResetOnSpawn = false
sg.Parent = parentTarget

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 620, 0, 410)
mainFrame.Position = UDim2.new(0.5, -310, 0.5, -205)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 12, 28)
mainFrame.BackgroundTransparency = 0.02
mainFrame.BorderSizePixel = 0
mainFrame.Parent = sg

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

local headerTitle = Instance.new("TextLabel")
headerTitle.Size = UDim2.new(0.6, 0, 0, 30)
headerTitle.Position = UDim2.new(0, 16, 0, 12)
headerTitle.BackgroundTransparency = 1
headerTitle.TextColor3 = Color3.fromRGB(216, 180, 254)
headerTitle.TextSize = 14
headerTitle.Font = Enum.Font.GothamBold
headerTitle.Text = "Dominate Hub v17.3 (Type-Safe Fix)"
headerTitle.TextXAlignment = Enum.TextXAlignment.Left
headerTitle.Parent = mainFrame

-- SIDEBAR TABS
local sidebarFrame = Instance.new("ScrollingFrame")
sidebarFrame.Size = UDim2.new(0, 135, 1, -55)
sidebarFrame.Position = UDim2.new(0, 12, 0, 50)
sidebarFrame.BackgroundTransparency = 1
sidebarFrame.BorderSizePixel = 0
sidebarFrame.ScrollBarThickness = 0
sidebarFrame.ScrollingEnabled = true
sidebarFrame.Parent = mainFrame

local sidebarLayout = Instance.new("UIListLayout")
sidebarLayout.Padding = UDim.new(0, 8)
sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
sidebarLayout.Parent = sidebarFrame

local function makeMainTab(emoji, txt)
    local t = Instance.new("TextButton")
    t.Size = UDim2.new(1, 0, 0, 42)
    t.BackgroundColor3 = Color3.fromRGB(18, 12, 28)
    t.TextColor3 = Color3.fromRGB(210, 190, 235)
    t.TextSize = 12
    t.Font = Enum.Font.GothamBold
    t.Text = emoji .. "    " .. txt
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.Parent = sidebarFrame
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 8)
    tabCorner.Parent = t
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 14)
    padding.Parent = t

    local tabStroke = Instance.new("UIStroke")
    tabStroke.Name = "TabStroke"
    tabStroke.Color = Color3.fromRGB(168, 85, 247)
    tabStroke.Transparency = 0.6
    tabStroke.Parent = t

    return t
end

local tabGeneral = makeMainTab("⚙️", "General")
tabGeneral.BackgroundColor3 = Color3.fromRGB(168, 85, 247)
tabGeneral.TextColor3 = Color3.fromRGB(255, 255, 255)
local activeStroke = tabGeneral:FindFirstChild("TabStroke")
if activeStroke then activeStroke.Transparency = 0.1 end

local tabTrials = makeMainTab("🛡️", "Trials")

-- PAGES AREA
local pageArea = Instance.new("Frame")
pageArea.Size = UDim2.new(1, -165, 1, -55)
pageArea.Position = UDim2.new(0, 155, 0, 50)
pageArea.BackgroundTransparency = 1
pageArea.ClipsDescendants = true
pageArea.Parent = mainFrame

local function makePage()
    local p = Instance.new("Frame")
    p.Size = UDim2.new(1, 0, 1, 0)
    p.BackgroundTransparency = 1
    p.Visible = false
    p.Parent = pageArea
    return p
end

local generalPage = makePage()
local trialsPage = makePage()
generalPage.Visible = true

local function makeVerticalScroll(parent)
    local s = Instance.new("ScrollingFrame")
    s.Size = UDim2.new(1, 0, 1, 0)
    s.BackgroundTransparency = 1
    s.BorderSizePixel = 0
    s.ScrollBarThickness = 0
    s.ScrollingEnabled = true
    s.Parent = parent
    
    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 10)
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Parent = s
    
    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        s.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 20)
    end)
    return s
end

local generalScroll = makeVerticalScroll(generalPage)
local trialsScroll = makeVerticalScroll(trialsPage)

local function mainRoute(pOpen, bActive)
    generalPage.Visible = false
    trialsPage.Visible = false
    pOpen.Visible = true
    
    local tabs = {tabGeneral, tabTrials}
    for _, t in ipairs(tabs) do
        t.BackgroundColor3 = Color3.fromRGB(18, 12, 28)
        t.TextColor3 = Color3.fromRGB(210, 190, 235)
        local stroke = t:FindFirstChild("TabStroke")
        if stroke then stroke.Transparency = 0.6 end
    end
    bActive.BackgroundColor3 = Color3.fromRGB(168, 85, 247)
    bActive.TextColor3 = Color3.fromRGB(255, 255, 255)
    local strokeActive = bActive:FindFirstChild("TabStroke")
    if strokeActive then strokeActive.Transparency = 0.1 end
end

tabGeneral.MouseButton1Click:Connect(function() mainRoute(generalPage, tabGeneral) end)
tabTrials.MouseButton1Click:Connect(function() mainRoute(trialsPage, tabTrials) end)

-- UI HELPERS
local function createToggleRow(parent, txt, vKey)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -10, 0, 42)
    row.BackgroundColor3 = Color3.fromRGB(35, 20, 55)
    row.BackgroundTransparency = 0.5
    row.BorderSizePixel = 0
    row.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = row

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.65, 0, 1, 0)
    lbl.Position = UDim2.new(0, 16, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(240, 235, 250)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.GothamBold
    lbl.Text = txt
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local switchTrack = Instance.new("TextButton")
    switchTrack.Size = UDim2.new(0, 48, 0, 22)
    switchTrack.Position = UDim2.new(1, -58, 0.5, -11)
    switchTrack.BackgroundColor3 = Env[vKey] and Color3.fromRGB(168, 85, 247) or Color3.fromRGB(42, 28, 65)
    switchTrack.Text = ""
    switchTrack.AutoButtonColor = false
    switchTrack.Parent = row
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = switchTrack

    switchTrack.MouseButton1Click:Connect(function()
        Env[vKey] = not Env[vKey]
        local active = Env[vKey]
        switchTrack.BackgroundColor3 = active and Color3.fromRGB(168, 85, 247) or Color3.fromRGB(42, 28, 65)
        showToast(txt .. ": " .. tostring(active))
    end)
    return row
end

local function createButtonRow(parent, txt, callback)
    local row = Instance.new("TextButton")
    row.Size = UDim2.new(1, -10, 0, 42)
    row.BackgroundColor3 = Color3.fromRGB(168, 85, 247)
    row.BackgroundTransparency = 0.2
    row.TextColor3 = Color3.fromRGB(255, 255, 255)
    row.TextSize = 12
    row.Font = Enum.Font.GothamBold
    row.Text = txt
    row.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = row

    row.MouseButton1Click:Connect(callback)
    return row
end

local function createSectionHeader(parent, txt)
    local header = Instance.new("TextLabel")
    header.Size = UDim2.new(1, -10, 0, 32)
    header.BackgroundTransparency = 1
    header.TextColor3 = Color3.fromRGB(230, 110, 255)
    header.TextSize = 12
    header.Font = Enum.Font.GothamBold
    header.Text = txt
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.Parent = parent
    return header
end

-- BUILD CONTROLS
createToggleRow(generalScroll, "Ancient Boss Farm", "AutoAncientBossFarm")
createToggleRow(generalScroll, "Auto Regenerate Sand Layers", "AutoRegenSandLayers")

createSectionHeader(trialsScroll, "Realm 3 Trials Automation")
createToggleRow(trialsScroll, "Auto Easy Trial", "AutoEasyTrial")
createToggleRow(trialsScroll, "Auto Medium Trial", "AutoMediumTrial")
createToggleRow(trialsScroll, "Auto Hard Trial", "AutoHardTrial")

createButtonRow(trialsScroll, "Test Trial Teleport Now", function()
    local targetPad = Dest.HardTrial
    if Env.AutoEasyTrial then targetPad = Dest.EasyTrial
    elseif Env.AutoMediumTrial then targetPad = Dest.MediumTrial end
    
    showToast("Trials: Manual teleport test triggered!")
    MasterTargetVector = nil
    MobTargetVector = nil
    trialIsRunning = true
    
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.Anchored = false
        hrp.CFrame = CFrame.new(targetPad)
        hrp.AssemblyLinearVelocity = Vector3.zero
    end
end)

-- UNIFIED MOVEMENT ENGINE
local function GetWorldRoot() return player.Character and player.Character:FindFirstChild("HumanoidRootPart") end

task.spawn(function()
    while Running do
        RunService.RenderStepped:Wait()
        local hrp = GetWorldRoot()
        if hrp and Running then
            local act = nil
            if MasterTargetVector then act = MasterTargetVector
            elseif MobTargetVector then act = MobTargetVector end
            
            if act then
                local targetCF = CFrame.new(act)
                if trialIsRunning or MobTargetVector then
                    hrp.Anchored = false
                    hrp.CFrame = targetCF
                    hrp.AssemblyLinearVelocity = Vector3.zero
                else
                    hrp.CFrame = hrp.CFrame:Lerp(targetCF, 0.85)
                end
            else
                hrp.Anchored = false
            end
        end
    end
end)

-- SCHEDULED TRIAL AUTOMATION (29TH AND 59TH MINUTE)
local lastTrialTriggeredSlot = ""
task.spawn(function()
    while Running do
        task.wait(1.0)
        local hrp = GetWorldRoot()
        local inLobby = hrp and hrp.Position.Z < 13000 or true
        
        if Running and (Env.AutoEasyTrial or Env.AutoMediumTrial or Env.AutoHardTrial) and not trialIsRunning and inLobby then
            local timeTable = os.date("*t")
            local min = timeTable.min
            local hour = timeTable.hour
            
            if (min == 29 or min == 59) then
                local currentSlot = hour .. "_" .. min
                if currentSlot ~= lastTrialTriggeredSlot then
                    lastTrialTriggeredSlot = currentSlot
                    local targetPad = Dest.HardTrial
                    if Env.AutoEasyTrial then targetPad = Dest.EasyTrial
                    elseif Env.AutoMediumTrial then targetPad = Dest.MediumTrial end
                    
                    showToast("Trials: Scheduled slot reached! Teleporting...")
                    MasterTargetVector = nil
                    MobTargetVector = nil
                    trialIsRunning = true
                    
                    if hrp then
                        hrp.Anchored = false
                        hrp.CFrame = CFrame.new(targetPad)
                        hrp.AssemblyLinearVelocity = Vector3.zero
                    end
                end
            end
        end
    end
end)

-- TRIAL ARENA EXIT & LOBBY DETECTOR
task.spawn(function()
    while Running do
        task.wait(0.5)
        local hrp = GetWorldRoot()
        if hrp then
            if hrp.Position.Z > 13000 and not trialIsRunning then
                trialIsRunning = true
                showToast("Trials: Entered arena.")
            elseif trialIsRunning and hrp.Position.Z < 13000 then
                trialIsRunning = false
                showToast("Trials: Returned to lobby.")
            end
        end
    end
end)

-- ANCIENT BOSS AUTO-SPAWN LOOP
task.spawn(function()
    while Running do
        task.wait(2.0)
        if Running and Env.AutoAncientBossFarm and not trialIsRunning then
            pcall(function()
                local bossExists = false
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("Model") and obj.Name == "Supreme Shadow Lord" then
                        local hum = obj:FindFirstChildOfClass("Humanoid")
                        if hum and hum.Health > 0 then
                            bossExists = true
                            break
                        end
                    end
                end
                if not bossExists then
                    MasterTargetVector = Dest.AncientBossSpawn
                    task.wait(1.5)
                    ReplicatedStorage:WaitForChild("__Net"):WaitForChild("MainRemote"):FireServer("SpawnAncientMob", "Supreme Shadow Lord")
                    task.wait(1.5)
                    MasterTargetVector = nil
                    task.wait(3.0)
                end
            end)
        end
    end
end)

-- SAND REGENERATION LOOP
task.spawn(function()
    while Running do
        task.wait(1.0)
        if Running and Env.AutoRegenSandLayers and not trialIsRunning then
            pcall(function()
                local hrp = GetWorldRoot()
                if hrp then
                    hrp.Anchored = false
                    hrp.CFrame = CFrame.new(Dest.SandPit)
                    hrp.AssemblyLinearVelocity = Vector3.zero
                end
            end)
            task.wait(2.5)
        end
    end
end)

print("[Dominate Hub] V17.3 Type-Safe Fix Loaded Successfully!")
