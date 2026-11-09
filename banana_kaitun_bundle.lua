-- ====================================================================
-- 🍌 BANANA KAITUN - ALL-IN-ONE STANDALONE ENDGAME BUNDLE
-- Self-Contained 1-to-Max Autonomous Botting Engine for Blox Fruits
-- With Race V2, V3, and V4 (Mirage Moon Resonance, Blue Gear, Temple
-- Lever, Chamber Trials for all 6 races, Ancient Clock), plus
-- Cursed Dual Katana (Yama/Tushita/CDK) and Soul Guitar Automations.
-- Compatible with all mobile & PC executors (Zero external dependencies).
-- ====================================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local StatsService = game:GetService("Stats")
local LocalPlayer = Players.LocalPlayer

-- ====================================================================
-- 1. ANTI-AFK ENGINE
-- ====================================================================
pcall(function()
    LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.zero)
    end)
end)

-- ====================================================================
-- 2. REMOTES & NETWORK INITIALIZATION
-- ====================================================================
local CommF = nil
local RegisterAttackRemote = nil
local RegisterHitRemote = nil

pcall(function()
    CommF = ReplicatedStorage:WaitForChild("Remotes", 5) and ReplicatedStorage.Remotes:WaitForChild("CommF_", 5)
    local modules = ReplicatedStorage:WaitForChild("Modules", 5)
    if modules then
        local net = modules:FindFirstChild("Net") and require(modules.Net)
        if net then
            RegisterAttackRemote = modules.Net:FindFirstChild("RE/RegisterAttack")
            RegisterHitRemote = net:RemoteEvent("RegisterHit", true)
        end
    end
end)

-- ====================================================================
-- 3. QUEST & LEVEL DATABASE (1 TO 2550+)
-- ====================================================================
local Data = {
    Places = {
        Sea1 = { 2753915549, 85211729168715 },
        Sea2 = { 4442272183, 79091703265657 },
        Sea3 = { 7449423635, 100117331123089 }
    },
    Quests = {
        -- Sea 1 (Lv 1 - 700)
        { Level = 1,   Mob = "Bandit",             Quest = "BanditQuest1",       Id = 1, PosQ = CFrame.new(1059.37, 16.51, 1549.26),  PosM = CFrame.new(1145.47, 16.51, 1608.82) },
        { Level = 10,  Mob = "Monkey",             Quest = "JungleQuest",        Id = 1, PosQ = CFrame.new(-1598.08, 36.85, 153.38),  PosM = CFrame.new(-1448.14, 22.85, 229.86) },
        { Level = 15,  Mob = "Gorilla",            Quest = "JungleQuest",        Id = 2, PosQ = CFrame.new(-1598.08, 36.85, 153.38),  PosM = CFrame.new(-1237.76, 6.28, -486.29) },
        { Level = 30,  Mob = "Pirate",             Quest = "BuggyQuest1",        Id = 1, PosQ = CFrame.new(-1141.07, 4.75, 3831.55),  PosM = CFrame.new(-1201.07, 4.75, 3918.55) },
        { Level = 40,  Mob = "Brute",              Quest = "BuggyQuest1",        Id = 2, PosQ = CFrame.new(-1141.07, 4.75, 3831.55),  PosM = CFrame.new(-1379.23, 14.75, 4134.42) },
        { Level = 60,  Mob = "Desert Bandit",      Quest = "DesertQuest",        Id = 1, PosQ = CFrame.new(894.48, 6.44, 4392.43),    PosM = CFrame.new(996.48, 6.44, 4402.43) },
        { Level = 75,  Mob = "Desert Officer",     Quest = "DesertQuest",        Id = 2, PosQ = CFrame.new(894.48, 6.44, 4392.43),    PosM = CFrame.new(1570.82, 10.44, 4373.91) },
        { Level = 90,  Mob = "Snow Bandit",        Quest = "SnowQuest",          Id = 1, PosQ = CFrame.new(1385.50, 87.27, -1298.57), PosM = CFrame.new(1285.50, 105.27, -1348.57) },
        { Level = 100, Mob = "Snowman",            Quest = "SnowQuest",          Id = 2, PosQ = CFrame.new(1385.50, 87.27, -1298.57), PosM = CFrame.new(1285.50, 150.27, -1500.57) },
        { Level = 120, Mob = "Chief Petty Officer",Quest = "MarineQuest2",       Id = 1, PosQ = CFrame.new(-5039.59, 28.65, 4324.68), PosM = CFrame.new(-4850.59, 28.65, 4324.68) },
        { Level = 150, Mob = "Sky Bandit",         Quest = "SkyQuest",           Id = 1, PosQ = CFrame.new(-4839.53, 717.67, -2619.44),PosM = CFrame.new(-4980.53, 717.67, -2619.44) },
        { Level = 175, Mob = "Dark Master",        Quest = "SkyQuest",           Id = 2, PosQ = CFrame.new(-4839.53, 717.67, -2619.44),PosM = CFrame.new(-5250.53, 717.67, -2250.44) },
        { Level = 190, Mob = "Prisoner",           Quest = "PrisonerQuest",      Id = 1, PosQ = CFrame.new(5308.93, 1.66, 475.12),    PosM = CFrame.new(5150.93, 1.66, 500.12) },
        { Level = 210, Mob = "Dangerous Prisoner", Quest = "PrisonerQuest",      Id = 2, PosQ = CFrame.new(5308.93, 1.66, 475.12),    PosM = CFrame.new(5500.93, 1.66, 650.12) },
        { Level = 250, Mob = "Toga Warrior",       Quest = "ColosseumQuest",     Id = 1, PosQ = CFrame.new(-1580.90, 7.35, -2986.40), PosM = CFrame.new(-1800.90, 7.35, -2986.40) },
        { Level = 300, Mob = "Military Soldier",   Quest = "MagmaQuest",         Id = 1, PosQ = CFrame.new(-5313.37, 12.24, 8515.29), PosM = CFrame.new(-5400.37, 12.24, 8600.29) },
        { Level = 375, Mob = "Fishman Warrior",    Quest = "FishmanQuest",       Id = 1, PosQ = CFrame.new(61122.65, 18.50, 1569.40), PosM = CFrame.new(61000.65, 18.50, 1500.40) },
        { Level = 450, Mob = "God's Guard",        Quest = "SkyExp1Quest",       Id = 1, PosQ = CFrame.new(-4721.89, 845.28, -1954.28),PosM = CFrame.new(-4600.89, 845.28, -1850.28) },
        { Level = 525, Mob = "Royal Squad",        Quest = "SkyExp2Quest",       Id = 1, PosQ = CFrame.new(-7906.82, 5636.01, -1411.99),PosM = CFrame.new(-7700.82, 5636.01, -1411.99) },
        { Level = 625, Mob = "Galley Pirate",      Quest = "FountainQuest",      Id = 1, PosQ = CFrame.new(5259.82, 38.50, 4050.00),  PosM = CFrame.new(5559.82, 38.50, 4000.00) },

        -- Sea 2 (Lv 700 - 1500)
        { Level = 700, Mob = "Raider",             Quest = "Area1Quest",         Id = 1, PosQ = CFrame.new(-429.54, 73.02, 1836.18),  PosM = CFrame.new(-650.54, 73.02, 1836.18) },
        { Level = 775, Mob = "Swan Pirate",        Quest = "Area2Quest",         Id = 1, PosQ = CFrame.new(638.43, 73.02, 918.28),    PosM = CFrame.new(878.01, 121.36, 1212.18) },
        { Level = 875, Mob = "Marine Lieutenant",  Quest = "MarineQuest3",       Id = 1, PosQ = CFrame.new(-2440.79, 73.02, -3216.06),PosM = CFrame.new(-2600.79, 73.02, -3216.06) },
        { Level = 1000,Mob = "Snow Trooper",       Quest = "SnowMountainQuest",  Id = 1, PosQ = CFrame.new(609.86, 401.48, -5372.25), PosM = CFrame.new(500.86, 401.48, -5372.25) },
        { Level = 1100,Mob = "Lab Subordinate",    Quest = "IceSideQuest",       Id = 1, PosQ = CFrame.new(-6064.07, 15.95, -4902.98),PosM = CFrame.new(-5800.07, 15.95, -4902.98) },
        { Level = 1250,Mob = "Ship Deckhand",      Quest = "ShipQuest1",         Id = 1, PosQ = CFrame.new(1031.50, 125.07, 32911.00),PosM = CFrame.new(1150.50, 125.07, 32911.00) },
        { Level = 1350,Mob = "Arctic Warrior",     Quest = "FrostQuest",         Id = 1, PosQ = CFrame.new(5667.66, 28.17, -6486.09), PosM = CFrame.new(5900.66, 28.17, -6486.09) },

        -- Sea 3 (Lv 1500 - 2550+)
        { Level = 1500,Mob = "Pirate Millionaire", Quest = "PiratePortQuest",    Id = 1, PosQ = CFrame.new(-290.07, 43.85, 5580.08),  PosM = CFrame.new(-450.07, 43.85, 5580.08) },
        { Level = 1575,Mob = "Dragon Crew Warrior",Quest = "DragonCrewQuest",    Id = 1, PosQ = CFrame.new(6747.01, 127.35, -948.51), PosM = CFrame.new(6500.01, 127.35, -948.51) },
        { Level = 1700,Mob = "Fishman Raider",     Quest = "FloatingTurtleQuest",Id = 1, PosQ = CFrame.new(-1327.45, 53.15, -7579.22),PosM = CFrame.new(-1500.45, 53.15, -7579.22) },
        { Level = 1825,Mob = "Forest Pirate",      Quest = "DeepForestIslandQuest",Id = 1,PosQ = CFrame.new(-13233.00, 332.00, -7625.00),PosM = CFrame.new(-13400.00, 332.00, -7625.00) },
        { Level = 1975,Mob = "Reborn Skeleton",    Quest = "HauntedQuest1",      Id = 1, PosQ = CFrame.new(-9515.00, 142.00, 5535.00), PosM = CFrame.new(-8700.00, 142.00, 5535.00) },
        { Level = 2075,Mob = "Living Zombie",      Quest = "HauntedQuest2",      Id = 1, PosQ = CFrame.new(-9515.00, 142.00, 5535.00), PosM = CFrame.new(-9515.00, 142.00, 6000.00) },
        { Level = 2200,Mob = "Peanut Scout",       Quest = "PeanutQuest",        Id = 1, PosQ = CFrame.new(-2125.00, 48.00, -10190.00),PosM = CFrame.new(-1950.00, 48.00, -10190.00) },
        { Level = 2300,Mob = "Ice Cream Chef",     Quest = "IceCreamQuest",      Id = 1, PosQ = CFrame.new(-850.00, 65.00, -10950.00), PosM = CFrame.new(-650.00, 65.00, -10950.00) },
        { Level = 2450,Mob = "Isle Outlaw",        Quest = "TikiQuest1",         Id = 1, PosQ = CFrame.new(-16235.00, 12.00, 435.00),  PosM = CFrame.new(-16450.00, 12.00, 435.00) },
    }
}

function Data.GetSea()
    local placeId = game.PlaceId
    if table.find(Data.Places.Sea1, placeId) then return 1
    elseif table.find(Data.Places.Sea2, placeId) then return 2
    elseif table.find(Data.Places.Sea3, placeId) then return 3 end
    return 1
end

function Data.GetQuest(lvl)
    local best = Data.Quests[1]
    for _, q in ipairs(Data.Quests) do
        if lvl >= q.Level then best = q else break end
    end
    return best
end

local function HasItem(itemName)
    local bp = LocalPlayer:FindFirstChild("Backpack")
    local char = LocalPlayer.Character
    if (bp and bp:FindFirstChild(itemName)) or (char and char:FindFirstChild(itemName)) then
        return true
    end
    local hasInv = false
    pcall(function()
        if CommF then
            local inv = CommF:InvokeServer("getInventory")
            if type(inv) == "table" then
                for _, item in ipairs(inv) do
                    if item.Name == itemName then hasInv = true; break end
                end
            end
        end
    end)
    return hasInv
end

local function PressKey(key)
    pcall(function()
        VirtualInputManager:SendKeyEvent(true, key, false, game)
        task.wait(0.1)
        VirtualInputManager:SendKeyEvent(false, key, false, game)
    end)
end

-- ====================================================================
-- 4. MOVEMENT & DELTA LERP TWEEN ENGINE
-- ====================================================================
local Movement = { TweenRunning = false, CurrentGoal = nil }

-- Collision bypass
RunService.Stepped:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end)
end)

function Movement.SetHover(hrp, enabled)
    local force = hrp:FindFirstChild("KaitunHoverForce")
    if enabled then
        if not force then
            force = Instance.new("BodyVelocity")
            force.Name = "KaitunHoverForce"
            force.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            force.Velocity = Vector3.zero
            force.Parent = hrp
        end
    else
        if force then force:Destroy() end
    end
end

function Movement.ToTarget(targetCF, speed, snapDist)
    speed = speed or 260
    snapDist = snapDist or 5

    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not hrp or not hum or hum.Health <= 0 then return end

    if hum.Sit then hum.Sit = false end
    Movement.SetHover(hrp, true)

    local dist = (hrp.Position - targetCF.Position).Magnitude
    if dist <= snapDist then
        hrp.CFrame = targetCF
        return
    end

    local stepDist = speed * (1 / 60)
    local alpha = math.clamp(stepDist / dist, 0, 1)
    hrp.CFrame = hrp.CFrame:Lerp(targetCF, alpha)
end

function Movement.Stop()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then Movement.SetHover(hrp, false) end
end

-- ====================================================================
-- 5. COMBAT & FAST ATTACK ENGINE
-- ====================================================================
local Combat = { FastAttack = true, BringMob = true }

function Combat.IsAlive(mob)
    if not mob or not mob.Parent then return false end
    local hum = mob:FindFirstChild("Humanoid")
    return hum and hum.Health > 0
end

function Combat.CheckBuso()
    pcall(function()
        local char = LocalPlayer.Character
        if char and not char:FindFirstChild("HasBuso") and CommF then
            CommF:InvokeServer("Buso")
        end
    end)
end

function Combat.EquipWeapon()
    pcall(function()
        local bp = LocalPlayer.Backpack
        local char = LocalPlayer.Character
        if not bp or not char then return end
        if not char:FindFirstChildOfClass("Tool") then
            for _, tool in ipairs(bp:GetChildren()) do
                if tool:IsA("Tool") and (tool.ToolTip == "Melee" or tool.ToolTip == "Sword") then
                    tool.Parent = char
                    break
                end
            end
        end
    end)
end

function Combat.Bring(primaryMob)
    if not Combat.BringMob or not primaryMob then return end
    local primHRP = primaryMob:FindFirstChild("HumanoidRootPart")
    if not primHRP then return end

    local enemies = Workspace:FindFirstChild("Enemies")
    if not enemies then return end

    for _, mob in ipairs(enemies:GetChildren()) do
        if mob ~= primaryMob and mob.Name == primaryMob.Name and Combat.IsAlive(mob) then
            local mobHRP = mob:FindFirstChild("HumanoidRootPart")
            if mobHRP and (mobHRP.Position - primHRP.Position).Magnitude <= 250 then
                mobHRP.CFrame = primHRP.CFrame
                mobHRP.CanCollide = false
                mobHRP.Velocity = Vector3.zero
            end
        end
    end
end

function Combat.Attack()
    if not Combat.FastAttack then return end
    pcall(function()
        Combat.CheckBuso()
        local char = LocalPlayer.Character
        local tool = char and char:FindFirstChildOfClass("Tool")
        if not tool then return end

        local enemies = Workspace:FindFirstChild("Enemies")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not enemies or not hrp then return end

        local hitTargets = {}
        for _, mob in ipairs(enemies:GetChildren()) do
            if Combat.IsAlive(mob) then
                local mobHRP = mob:FindFirstChild("HumanoidRootPart")
                if mobHRP and (mobHRP.Position - hrp.Position).Magnitude <= 60 then
                    table.insert(hitTargets, { mob:FindFirstChild("Humanoid"), mobHRP })
                    if #hitTargets >= 4 then break end
                end
            end
        end

        if #hitTargets == 0 then return end

        if RegisterAttackRemote then
            RegisterAttackRemote:FireServer(0.05)
        end

        if RegisterHitRemote then
            for _, entry in ipairs(hitTargets) do
                RegisterHitRemote:FireServer(entry[2], { entry })
            end
        end
    end)
end

task.spawn(function()
    while true do
        task.wait(0.05)
        Combat.Attack()
    end
end)

local function HasActiveQuest()
    local pgui = LocalPlayer:FindFirstChild("PlayerGui")
    local tqf = pgui and pgui:FindFirstChild("TrackedQuestFrame")
    if tqf and tqf.Enabled and tqf:FindFirstChild("Frame") then return true end
    local guide = ReplicatedStorage:FindFirstChild("GuideModule")
    if guide then
        local g = require(guide)
        if g and g.Data and g.Data.QuestData then return true end
    end
    return false
end

-- ====================================================================
-- 6. STATS & FRUIT BACKGROUND SERVICES
-- ====================================================================
task.spawn(function()
    while true do
        task.wait(5)
        pcall(function()
            local data = LocalPlayer:FindFirstChild("Data")
            local points = data and data:FindFirstChild("Points") and data.Points.Value or 0
            if points > 0 and CommF then
                local toAdd = math.min(points, 25)
                CommF:InvokeServer("AddPoint", "Melee", toAdd)
                CommF:InvokeServer("AddPoint", "Defense", toAdd)
            end
        end)
    end
end)

task.spawn(function()
    while true do
        task.wait(10)
        pcall(function()
            if CommF then
                CommF:InvokeServer("Cousin", "Buy")
                local bp = LocalPlayer.Backpack
                local char = LocalPlayer.Character
                for _, container in ipairs({ bp, char }) do
                    if container then
                        for _, tool in ipairs(container:GetChildren()) do
                            if tool:IsA("Tool") and tool.Name:find("Fruit") and not tool:FindFirstChild("Stored") then
                                local clean = tool.Name:gsub(" Fruit", "")
                                local orig = tool:GetAttribute("OriginalName") or (clean .. "-" .. clean)
                                CommF:InvokeServer("StoreFruit", orig, tool)
                                local t = Instance.new("BoolValue", tool)
                                t.Name = "Stored"
                            end
                        end
                    end
                end
            end
        end)
    end
end)

-- ====================================================================
-- 7. RACE EVOLUTION ENGINE (V2, V3, & V4)
-- ====================================================================
local Race = {
    AutoRaceV2 = true,
    AutoRaceV3 = true,
    AutoRaceV4 = true,
    AutoMirageGear = true,
    AutoPullLever = true,
    AutoTrial = true,
    AutoAncientClock = true,
    SelectGear = "Alpha",

    AlchemistCF     = CFrame.new(-2777.60, 72.96, -3571.42),
    AroweCF         = CFrame.new(86.37, 24.81, 2865.12),
    GreatTreePeakCF = CFrame.new(3032.78, 2280.85, -7325.48),
    TempleOfTimeCF  = CFrame.new(28282.57, 14896.85, 105.10),
    AncientClockCF  = CFrame.new(28576.47, 14935.95, 75.47),
}

local function IsNight()
    local clock = Lighting.ClockTime
    return (clock >= 18 or clock <= 5.5)
end

local function GetPlayerBeli()
    local d = LocalPlayer:FindFirstChild("Data")
    return d and d:FindFirstChild("Beli") and d.Beli.Value or 0
end

local function GetPlayerRace()
    local d = LocalPlayer:FindFirstChild("Data")
    return d and d:FindFirstChild("Race") and d.Race.Value or "Human"
end

-- Race V2 (Alchemist Flowers)
function Race.DoRaceV2()
    if not Race.AutoRaceV2 or not CommF or Data.GetSea() ~= 2 then return false end
    local d = LocalPlayer:FindFirstChild("Data")
    if not d or not d:FindFirstChild("Level") or d.Level.Value < 850 then return false end

    local state = CommF:InvokeServer("Alchemist", "1")
    if state == 0 then
        Movement.ToTarget(Race.AlchemistCF, 260, 5)
        CommF:InvokeServer("Alchemist", "2")
        return true
    elseif state == 1 then
        if not HasItem("Flower 1") then
            if Workspace:FindFirstChild("Flower1") then
                Movement.ToTarget(Workspace.Flower1.CFrame, 260, 3)
            else
                Movement.ToTarget(CFrame.new(-5497.06, 47.59, -795.14), 260, 10)
            end
            return true
        elseif not HasItem("Flower 2") then
            if Workspace:FindFirstChild("Flower2") then
                Movement.ToTarget(Workspace.Flower2.CFrame, 260, 3)
            else
                Movement.ToTarget(CFrame.new(-429.54, 71.76, 1836.18), 260, 10)
            end
            return true
        elseif not HasItem("Flower 3") then
            local enemies = Workspace:FindFirstChild("Enemies")
            local mob = enemies and enemies:FindFirstChild("Swan Pirate")
            if mob and Combat.IsAlive(mob) then
                local root = mob:FindFirstChild("HumanoidRootPart")
                if root then
                    Movement.ToTarget(root.CFrame * CFrame.new(0, 15, 0), 260, 5)
                    Combat.Bring(mob)
                    Combat.EquipWeapon()
                end
            else
                Movement.ToTarget(CFrame.new(878.01, 121.36, 1212.18), 260, 10)
            end
            return true
        end
    elseif state == 2 then
        if GetPlayerBeli() >= 500000 then
            Movement.ToTarget(Race.AlchemistCF, 260, 5)
            CommF:InvokeServer("Alchemist", "3")
        end
        return true
    end
    return false
end

-- Race V3 (Arowe / Wenlocktoad)
function Race.DoRaceV3()
    if not Race.AutoRaceV3 or not CommF or Data.GetSea() ~= 2 then return false end
    local d = LocalPlayer:FindFirstChild("Data")
    if not d or not d:FindFirstChild("Level") or d.Level.Value < 1000 then return false end

    local state = CommF:InvokeServer("Wenlocktoad", "1")
    if state == 0 then
        Movement.ToTarget(Race.AroweCF, 260, 5)
        CommF:InvokeServer("Wenlocktoad", "2")
        return true
    elseif state == 2 and GetPlayerBeli() >= 2000000 then
        Movement.ToTarget(Race.AroweCF, 260, 5)
        CommF:InvokeServer("Wenlocktoad", "3")
        return true
    end
    return false
end

-- Race V4 Helpers
local function GetMirage()
    local map = Workspace:FindFirstChild("Map")
    return map and map:FindFirstChild("MysticIsland")
end

local function GetMiragePeak(mirage)
    if not mirage then return nil end
    for _, part in ipairs(mirage:GetDescendants()) do
        if part:IsA("MeshPart") and part.MeshId == "rbxassetid://6745037796" then
            return part
        end
    end
    return nil
end

local function GetMirageGear(mirage)
    if not mirage then return nil end
    for _, part in ipairs(mirage:GetChildren()) do
        if part:IsA("MeshPart") and part.MeshId == "rbxassetid://10153114969" then
            return part
        end
    end
    return nil
end

local function GetTemple()
    local map = Workspace:FindFirstChild("Map")
    return map and map:FindFirstChild("Temple of Time")
end

-- Race V4 Phase 1: Great Tree Unlock
function Race.CheckTempleUnlock()
    if not CommF or not HasItem("Valkyrie Helm") or not HasItem("Mirror Fractal") then return false end
    if CommF:InvokeServer("CheckTempleDoor") then return true end

    local step = CommF:InvokeServer("RaceV4Progress", "Check")
    if step == 1 then
        CommF:InvokeServer("RaceV4Progress", "Begin")
        return true
    elseif step == 2 then
        Movement.ToTarget(Race.GreatTreePeakCF, 280, 5)
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp and (hrp.Position - Race.GreatTreePeakCF.Position).Magnitude <= 10 then
            CommF:InvokeServer("RaceV4Progress", "Teleport")
        end
        return true
    elseif step == 3 then
        CommF:InvokeServer("RaceV4Progress", "Continue")
        return true
    end
    return false
end

-- Race V4 Phase 2: Mirage Moon Resonance & Blue Gear Sniping
function Race.DoMirageGear()
    if not Race.AutoMirageGear then return false end
    local mirage = GetMirage()
    if not mirage then return false end

    local blueGear = GetMirageGear(mirage)
    if blueGear and not blueGear.CanCollide and blueGear.Transparency ~= 1 then
        Movement.ToTarget(blueGear.CFrame, 280, 2)
        return true
    end

    if IsNight() then
        local peak = GetMiragePeak(mirage)
        if peak then
            local peakCF = peak.CFrame * CFrame.new(0, 211.88, 0)
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not hrp or (hrp.Position - peakCF.Position).Magnitude > 10 then
                Movement.ToTarget(peakCF, 280, 5)
            else
                pcall(function()
                    local cam = Workspace.CurrentCamera
                    local moonDir = Lighting:GetMoonDirection()
                    if cam and moonDir then
                        cam.CFrame = CFrame.new(cam.CFrame.Position, moonDir + cam.CFrame.Position)
                    end
                end)
                PressKey("T")
                task.wait(1)
            end
            return true
        end
    end
    return false
end

-- Race V4 Phase 3: Temple Secret Lever
function Race.DoPullLever()
    if not Race.AutoPullLever or not CommF then return false end
    if not HasItem("Valkyrie Helm") or not HasItem("Mirror Fractal") then return false end

    local temple = GetTemple()
    if not temple then
        Movement.ToTarget(Race.TempleOfTimeCF, 280, 10)
        return true
    end

    local leverModel = temple:FindFirstChild("Lever")
    if leverModel and leverModel:FindFirstChild("Lever") and leverModel:FindFirstChild("Prompt") then
        local prompt = leverModel.Prompt:FindFirstChildOfClass("ProximityPrompt")
        local leverCF = leverModel.Lever.CFrame
        if math.abs(leverCF.Z - 75.47) >= 0.5 then
            Movement.ToTarget(leverModel.Lever.CFrame, 280, 4)
            if prompt then fireproximityprompt(prompt, 1) end
            return true
        end
    end
    return false
end

-- Race V4 Phase 4: Full Moon Chamber Trials
function Race.DoChamberTrial()
    if not Race.AutoTrial then return false end
    local temple = GetTemple()
    if not temple then return false end

    local playerRace = GetPlayerRace()
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    local topHud = pg and pg:FindFirstChild("Main") and pg.Main:FindFirstChild("TopHUDList")
    local raidTimer = topHud and topHud:FindFirstChild("RaidTimer")
    local isRaid = raidTimer and raidTimer.Visible or false

    if not isRaid then
        local corridor = temple:FindFirstChild(playerRace .. "Corridor")
        if corridor and corridor:FindFirstChild("Door") then
            local door = corridor.Door.Door.RightDoor:FindFirstChild("Union") or corridor.Door
            if door then
                Movement.ToTarget(door.CFrame, 280, 4)
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp and (hrp.Position - door.Position).Magnitude <= 8 then
                    PressKey("T")
                end
                return true
            end
        end
        return false
    end

    -- In-Trial Execution
    if playerRace == "Human" or playerRace == "Ghoul" then
        local enemies = Workspace:FindFirstChild("Enemies")
        if enemies then
            for _, mob in ipairs(enemies:GetChildren()) do
                if Combat.IsAlive(mob) then
                    Movement.ToTarget(mob.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0), 280, 5)
                    Combat.Bring(mob)
                    Combat.EquipWeapon()
                    return true
                end
            end
        end
    elseif playerRace == "Skypiea" then
        local finish = Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("SkyTrial") and Workspace.Map.SkyTrial.Model:FindFirstChild("FinishPart")
        if finish then
            Movement.ToTarget(finish.CFrame * CFrame.new(0, 5, 0), 280, 3)
            return true
        end
    elseif playerRace == "Fishman" then
        local seaBeasts = Workspace:FindFirstChild("SeaBeasts")
        if seaBeasts then
            for _, sb in ipairs(seaBeasts:GetChildren()) do
                if sb:FindFirstChild("HumanoidRootPart") and sb:FindFirstChild("Health") and sb.Health.Value > 0 then
                    Movement.ToTarget(sb.HumanoidRootPart.CFrame * CFrame.new(0, 100, 40), 280, 10)
                    Combat.EquipWeapon()
                    return true
                end
            end
        end
    elseif playerRace == "Mink" then
        local startPoint = Workspace:FindFirstChild("StartPoint")
        if startPoint then
            Movement.ToTarget(startPoint.CFrame * CFrame.new(0, 3, 0), 280, 3)
            return true
        end
    elseif playerRace == "Cyborg" then
        local floor = Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("CyborgTrial") and Workspace.Map.CyborgTrial:FindFirstChild("Floor")
        if floor then
            Movement.ToTarget(floor.CFrame * CFrame.new(0, 180, 0), 280, 5)
            return true
        end
    end

    return true
end

-- Race V4 Phase 5: Ancient Clock Upgrades
function Race.DoAncientClock()
    if not Race.AutoAncientClock or not CommF then return false end
    local info = nil
    pcall(function() info = CommF:InvokeServer("TempleClock", "Check") end)
    if info and info.HadPoint then
        Movement.ToTarget(Race.AncientClockCF, 280, 5)
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp and (hrp.Position - Race.AncientClockCF.Position).Magnitude <= 10 then
            pcall(function() CommF:InvokeServer("UpgradeRace", "Buy") end)
            pcall(function()
                CommF:InvokeServer("TempleClock", "SpendPoint", "Gear1", Race.SelectGear)
                CommF:InvokeServer("TempleClock", "SpendPoint", "Gear2", Race.SelectGear)
            end)
        end
        return true
    end
    return false
end

function Race.Step()
    local sea = Data.GetSea()
    if sea == 2 then
        if Race.DoRaceV2() then return true end
        if Race.DoRaceV3() then return true end
    elseif sea == 3 then
        if Race.DoMirageGear() then return true end
        if Race.DoChamberTrial() then return true end
        if Race.DoAncientClock() then return true end
        if Race.CheckTempleUnlock() then return true end
        if Race.DoPullLever() then return true end
    end
    return false
end

-- ====================================================================
-- 8. SECRET ENDGAME QUESTS ENGINE (CDK, YAMA, TUSHITA, SOUL GUITAR)
-- ====================================================================
local SecretQuests = {
    AutoYama = true,
    AutoTushita = true,
    AutoCDK = true,
    AutoSoulGuitar = true,
}

function SecretQuests.DoYama()
    if not SecretQuests.AutoYama or not CommF or Data.GetSea() ~= 3 or HasItem("Yama") then return false end
    local eliteKills = CommF:InvokeServer("EliteHunter", "Progress") or 0
    if eliteKills < 30 then
        local enemies = Workspace:FindFirstChild("Enemies")
        if enemies then
            for _, name in ipairs({ "Urban", "Diablo", "Deandre" }) do
                local mob = enemies:FindFirstChild(name)
                if mob and Combat.IsAlive(mob) then
                    Movement.ToTarget(mob.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0), 260, 5)
                    Combat.Bring(mob)
                    Combat.EquipWeapon()
                    return true
                end
            end
        end
        CommF:InvokeServer("EliteHunter")
        return false
    else
        local sealedKatana = Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("Waterfall") and Workspace.Map.Waterfall:FindFirstChild("SealedKatana")
        if sealedKatana then
            local cd = sealedKatana:FindFirstChild("Hitbox") and sealedKatana.Hitbox:FindFirstChildOfClass("ClickDetector")
            if cd and typeof(fireclickdetector) == "function" then
                fireclickdetector(cd)
            end
            return true
        else
            Movement.ToTarget(CFrame.new(5251.90, 17.18, 453.60), 260, 10)
            return true
        end
    end
end

function SecretQuests.DoTushita()
    if not SecretQuests.AutoTushita or not CommF or Data.GetSea() ~= 3 or HasItem("Tushita") then return false end
    local ripIndra = Workspace:FindFirstChild("Enemies") and Workspace.Enemies:FindFirstChild("rip_indra True Form")
    if ripIndra and Combat.IsAlive(ripIndra) then
        local door = Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("Waterfall") and Workspace.Map.Waterfall:FindFirstChild("SecretRoom")
        if door then
            Movement.ToTarget(CFrame.new(5251.90, 17.18, 453.60), 260, 10)
            return true
        end
    end
    local longma = Workspace:FindFirstChild("Enemies") and Workspace.Enemies:FindFirstChild("Longma")
    if longma and Combat.IsAlive(longma) then
        Movement.ToTarget(longma.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0), 260, 5)
        Combat.Bring(longma)
        Combat.EquipWeapon()
        return true
    end
    return false
end

function SecretQuests.DoCDK()
    if not SecretQuests.AutoCDK or not CommF or Data.GetSea() ~= 3 or HasItem("Cursed Dual Katana") then return false end
    if not HasItem("Yama") or not HasItem("Tushita") then return false end
    local cdkNPC = CFrame.new(-12061.27, 332.12, -7534.50)
    Movement.ToTarget(cdkNPC, 260, 5)
    pcall(function()
        CommF:InvokeServer("CDKQuest", "StartTrial", "Good")
        CommF:InvokeServer("CDKQuest", "StartTrial", "Evil")
    end)
    return true
end

function SecretQuests.DoSoulGuitar()
    if not SecretQuests.AutoSoulGuitar or not CommF or Data.GetSea() ~= 3 or HasItem("Soul Guitar") then return false end
    local d = LocalPlayer:FindFirstChild("Data")
    if not d or not d:FindFirstChild("Level") or d.Level.Value < 2300 then return false end

    if IsNight() then
        local graveCF = CFrame.new(-9515.00, 142.00, 5535.00)
        Movement.ToTarget(graveCF, 260, 5)
        pcall(function() CommF:InvokeServer("Gravstone", "Pray") end)
        return true
    end
    return false
end

function SecretQuests.Step()
    if SecretQuests.DoYama() then return true end
    if SecretQuests.DoTushita() then return true end
    if SecretQuests.DoCDK() then return true end
    if SecretQuests.DoSoulGuitar() then return true end
    return false
end

-- ====================================================================
-- 9. LOW-CPU HEADS-UP DISPLAY (HUD)
-- ====================================================================
local HUDStatus = "Starting up..."
local function CreateHUD()
    pcall(function()
        local sg = Instance.new("ScreenGui")
        sg.Name = "BananaKaitunStandalone"
        sg.ResetOnSpawn = false
        local parent = pcall(function() return CoreGui end) and CoreGui or LocalPlayer:WaitForChild("PlayerGui")

        local f = Instance.new("Frame", sg)
        f.Size = UDim2.new(0, 340, 0, 180)
        f.Position = UDim2.new(0.02, 0, 0.05, 0)
        f.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
        f.BorderSizePixel = 0
        f.Active = true
        f.Draggable = true
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)

        local stroke = Instance.new("UIStroke", f)
        stroke.Color = Color3.fromRGB(245, 185, 30)
        stroke.Thickness = 1.5

        local t = Instance.new("TextLabel", f)
        t.Size = UDim2.new(1, -20, 0, 30)
        t.Position = UDim2.new(0, 10, 0, 5)
        t.BackgroundTransparency = 1
        t.Text = "🍌 BANANA KAITUN STANDALONE"
        t.TextColor3 = Color3.fromRGB(245, 185, 30)
        t.Font = Enum.Font.GothamBold
        t.TextSize = 13
        t.TextXAlignment = Enum.TextXAlignment.Left

        local info = Instance.new("TextLabel", f)
        info.Name = "Info"
        info.Size = UDim2.new(1, -20, 0, 130)
        info.Position = UDim2.new(0, 10, 0, 40)
        info.BackgroundTransparency = 1
        info.TextColor3 = Color3.fromRGB(220, 220, 230)
        info.Font = Enum.Font.Gotham
        info.TextSize = 11
        info.TextXAlignment = Enum.TextXAlignment.Left
        info.TextYAlignment = Enum.TextYAlignment.Top
        info.Text = HUDStatus

        sg.Parent = parent

        task.spawn(function()
            while true do
                task.wait(1)
                pcall(function()
                    local d = LocalPlayer:FindFirstChild("Data")
                    local lvl = d and d:FindFirstChild("Level") and d.Level.Value or 1
                    local beli = d and d:FindFirstChild("Beli") and d.Beli.Value or 0
                    local frags = d and d:FindFirstChild("Fragments") and d.Fragments.Value or 0
                    local raceName = GetPlayerRace()
                    local sea = Data.GetSea()
                    info.Text = string.format("Level: %d / 2550\nSea: %d | Race: %s\nBeli: $%d | Fragments: %d\nAction: %s\nAutomation: ACTIVE ⚡", lvl, sea, raceName, beli, frags, HUDStatus)
                end)
            end
        end)
    end)
end
CreateHUD()

-- ====================================================================
-- 10. MASTER AUTONOMOUS PROGRESSION LOOP (1 TO MAX 2550+)
-- ====================================================================
task.spawn(function()
    while true do
        task.wait(0.2)
        pcall(function()
            local data = LocalPlayer:FindFirstChild("Data")
            local level = data and data:FindFirstChild("Level") and data.Level.Value or 1
            local currentSea = Data.GetSea()

            -- Sea 1 -> 2 Transition
            if currentSea == 1 and level >= 700 and CommF then
                local prog = CommF:InvokeServer("DressrosaQuestProgress", "Dressrosa")
                if prog ~= 0 then
                    HUDStatus = "Unlocking Sea 2 (Detective & Ice Admiral)"
                    local iceDoor = Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("Ice") and Workspace.Map.Ice:FindFirstChild("Door")
                    if iceDoor and iceDoor.CanCollide then
                        Movement.ToTarget(CFrame.new(4852.28, 5.65, 718.53), 260, 5)
                        task.wait(0.5)
                        CommF:InvokeServer("DressrosaQuestProgress", "Detective")
                    else
                        local enemies = Workspace:FindFirstChild("Enemies")
                        local iceAdmiral = enemies and enemies:FindFirstChild("Ice Admiral")
                        if iceAdmiral and Combat.IsAlive(iceAdmiral) then
                            local root = iceAdmiral:FindFirstChild("HumanoidRootPart")
                            if root then
                                Movement.ToTarget(root.CFrame * CFrame.new(0, 15, 0), 260, 5)
                                Combat.Bring(iceAdmiral)
                                Combat.EquipWeapon()
                                return
                            end
                        else
                            Movement.ToTarget(CFrame.new(1347.71, 37.37, -1325.64), 260, 10)
                            return
                        end
                    end
                else
                    HUDStatus = "Traveling to Sea 2 (Dressrosa)"
                    CommF:InvokeServer("TravelDressrosa")
                    return
                end
            end

            -- Sea 2 -> 3 Transition
            if currentSea == 2 and level >= 1500 and CommF then
                local zCheck = CommF:InvokeServer("ZQuestProgress", "Check")
                if zCheck == 1 then
                    HUDStatus = "Traveling to Sea 3 (Zou)"
                    CommF:InvokeServer("TravelZou")
                    return
                end
            end

            -- Race Progression Engine (V2/V3 in Sea 2, V4 in Sea 3)
            if Race and Race.Step then
                if Race.Step() then
                    HUDStatus = "Race Progression Active (V2/V3/V4)"
                    return
                end
            end

            -- Endgame Secret Quests (Yama, Tushita, CDK, Soul Guitar in Sea 3)
            if currentSea == 3 and SecretQuests and SecretQuests.Step then
                if SecretQuests.Step() then
                    HUDStatus = "Secret Endgame Quest Active (CDK/Soul Guitar)"
                    return
                end
            end

            -- Standard Quest Farming
            local quest = Data.GetQuest(level)
            if not quest then return end

            if not HasActiveQuest() then
                HUDStatus = string.format("Accepting Quest: %s", quest.Quest)
                Movement.ToTarget(quest.PosQ, 260, 5)
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp and (hrp.Position - quest.PosQ.Position).Magnitude <= 10 and CommF then
                    CommF:InvokeServer("StartQuest", quest.Quest, quest.Id)
                    task.wait(0.5)
                end
            else
                HUDStatus = string.format("Farming %s (Lv %d)", quest.Mob, quest.Level)
                local targetMob = nil
                local enemies = Workspace:FindFirstChild("Enemies")
                if enemies then
                    for _, mob in ipairs(enemies:GetChildren()) do
                        if mob.Name:find(quest.Mob) and Combat.IsAlive(mob) then
                            targetMob = mob
                            break
                        end
                    end
                end

                if targetMob then
                    local mobHRP = targetMob:FindFirstChild("HumanoidRootPart")
                    if mobHRP then
                        Movement.ToTarget(mobHRP.CFrame * CFrame.new(0, 15, 0) * CFrame.Angles(math.rad(-90), 0, 0), 260, 5)
                        Combat.Bring(targetMob)
                        Combat.EquipWeapon()
                    end
                else
                    Movement.ToTarget(quest.PosM, 260, 15)
                end
            end
        end)
    end
end)

print("[🍌 Banana Kaitun Standalone] Fully loaded with Race V4, CDK & Soul Guitar!")
