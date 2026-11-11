-- ====================================================================
-- 🍌 BANANA KAITUN - ALL-IN-ONE STANDALONE SUITE (FIXED & ENHANCED)
-- Autonomous Level 1 to Max (2550+) Botting Suite for Blox Fruits
-- Powered by the battle-tested TweenManager & Farm Engine from Banana Hub
-- Integrated with GravityHub getgenv configuration & Ultra FPS Boost
-- Zero external filesystem dependencies - 100% executor compatible
-- ====================================================================

repeat wait() until game:IsLoaded() and game:GetService("Players").LocalPlayer

-- ====================================================================
-- DEFAULT CONFIGURATION (GRAVITYHUB SCHEMA SPECIFICATION)
-- ====================================================================
getgenv().GravityHub = getgenv().GravityHub or {
    ["Hide UI"] = false,
    ["Reset Teleport"] = {
        ["Enabled"] = false,
        ["Delay Reset"] = 3,
        ["Item Dont Reset"] = {
            ["Fruit"] = {
                ["Enabled"] = true,
                ["All Fruit"] = true,
                ["Select Fruit"] = {
                    ["Enabled"] = false,
                    ["Fruit"] = {},
                },
            },
        },
    },
    ["White Screen"] = false,
    ["Lock Fps"] = {
        ["Enabled"] = false,
        ["FPS"] = 20,
    },
    ["Get Items"] = {
        ["Saber"] = true,
        ["Godhuman"] = true,
        ["Skull Guitar"] = true,
        ["Mirror Fractal"] = true,
        ["Cursed Dual Katana"] = true,
        ["Upgrade Race V2-V3"] = true,
        ["Auto Pull Lever"] = true,
        ["Shark Anchor"] = true,
    },
    ["Get Rare Items"] = {
        ["Rengoku"] = false,
        ["Dragon Trident"] = false,
        ["Pole (1st Form)"] = false,
        ["Gravity Blade"] = false,
    },
    ["Farm Fragments"] = {
        ["Enabled"] = false,
        ["Fragment"] = 50000,
    },
    ["Auto Chat"] = {
        ["Enabled"] = false,
        ["Text"] = "",
    },
    ["Auto Summon Rip Indra"] = true,
    ["Select Hop"] = {
        ["Hop Server If Have Player Near"] = false,
        ["Hop Find Rip Indra Get Valkyrie Helm or Get Tushita"] = true,
        ["Hop Find Dough King Get Mirror Fractal"] = true,
        ["Hop Find Raids Castle [CDK]"] = true,
        ["Hop Find Cake Queen [CDK]"] = true,
        ["Hop Find Soul Reaper [CDK]"] = true,
        ["Hop Find Darkbeard [SG]"] = true,
        ["Hop Find Mirage [ Pull Lever ]"] = false,
    },
    ["Farm Mastery"] = {
        ["Melee"] = false,
        ["Sword"] = false,
    },
    ["Buy Haki"] = {
        ["Enhancement"] = false,
        ["Skyjump"] = true,
        ["Flash Step"] = true,
        ["Observation"] = true,
    },
    ["Sniper Fruit Shop"] = {
        ["Enabled"] = true,
        ["Fruit"] = {"Leopard-Leopard","Kitsune-Kitsune","Dragon-Dragon","Yeti-Yeti","Gas-Gas"},
    },
    ["Lock Fruit"] = {},
    ["Webhook"] = {
        ["Enabled"] = false,
        ["WebhookUrl"] = "",
    }
}

local GH = getgenv().GravityHub

-- Session Cleanup Guard (Clean restart, eliminates duplicate loops/tweens)
do
    local g = getgenv()
    if type(g.__BananaKaitun_Shutdown) == "function" then
        pcall(g.__BananaKaitun_Shutdown)
    end
    local runtime = { alive = true, conns = {} }
    g.__BananaKaitun_RT = runtime
    function runtime.track(c)
        if c then runtime.conns[#runtime.conns + 1] = c end
        return c
    end
    g.__BananaKaitun_Shutdown = function()
        runtime.alive = false
        for _, c in ipairs(runtime.conns) do
            pcall(function() c:Disconnect() end)
        end
        pcall(function()
            if g.TweenManager and g.TweenManager.CancelCurrent then
                g.TweenManager.CancelCurrent()
            end
        end)
        pcall(function()
            local lp = game:GetService("Players").LocalPlayer
            local char = lp and lp.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local ff = hrp:FindFirstChild("FloatForce") or hrp:FindFirstChild("KaitunHoverForce")
                if ff then ff:Destroy() end
                hrp.Anchored = false
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.AssemblyAngularVelocity = Vector3.zero
                pcall(function() game:GetService("CollectionService"):RemoveTag(hrp, "Teleporting") end)
            end
        end)
    end
end

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local CollectionService = game:GetService("CollectionService")
local LocalPlayer = Players.LocalPlayer

-- ====================================================================
-- ULTRA FPS BOOST: CLAY CHARACTER VOID MODE (AUTOMATIC ON EXECUTE)
-- Erases map meshes, ground, buildings, water & sky rendering
-- Character rendered completely uncolored (monochrome clay, stripped clothes)
-- ====================================================================
local function ApplyUltraFPSBoost()
    pcall(function()
        -- 1. Lighting Optimization
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Lighting.Brightness = 0
        Lighting.ClockTime = 14
        for _, item in ipairs(Lighting:GetChildren()) do
            if item:IsA("PostProcessEffect") or item:IsA("Sky") or item:IsA("Atmosphere") or item:IsA("Clouds") then
                pcall(function() item:Destroy() end)
            end
        end

        -- 2. Quality & Mesh Cache Setting
        pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
        pcall(function() settings().Rendering.MeshCacheSize = 0 end)

        -- 3. Lock FPS if configured
        if GH["Lock Fps"] and GH["Lock Fps"]["Enabled"] and typeof(setfpscap) == "function" then
            setfpscap(tonumber(GH["Lock Fps"]["FPS"]) or 20)
        end

        -- 4. White Screen / 3D Rendering Disable if configured
        if GH["White Screen"] then
            pcall(function() RunService:Set3dRenderingEnabled(false) end)
        end

        -- 5. Terrain Water Flattening
        local terrain = Workspace:FindFirstChildOfClass("Terrain") or Workspace.Terrain
        if terrain then
            pcall(function()
                terrain.WaterWaveSize = 0
                terrain.WaterWaveSpeed = 0
                terrain.WaterReflectance = 0
                terrain.WaterTransparency = 1
                terrain.Transparency = 1
            end)
        end

        -- 6. Character Styler: Neutral Monochrome Clay (No Colour, No Clothes)
        local function StyleClayCharacter(char)
            if not char then return end
            -- Strip clothing, decals, shirts, pants
            for _, item in ipairs(char:GetChildren()) do
                if item:IsA("Shirt") or item:IsA("Pants") or item:IsA("ShirtGraphic") then
                    pcall(function() item:Destroy() end)
                elseif item:IsA("Accessory") then
                    local handle = item:FindFirstChild("Handle")
                    if handle and handle:IsA("BasePart") then
                        handle.Material = Enum.Material.SmoothPlastic
                        handle.Color = Color3.fromRGB(160, 160, 160)
                        handle.CastShadow = false
                        for _, dec in ipairs(handle:GetDescendants()) do
                            if dec:IsA("Decal") or dec:IsA("Texture") or dec:IsA("SurfaceAppearance") or dec:IsA("SpecialMesh") then
                                pcall(function() dec:Destroy() end)
                            end
                        end
                    end
                end
            end
            -- Strip face decals and color all limbs neutral flat clay
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.Material = Enum.Material.SmoothPlastic
                    part.Color = Color3.fromRGB(160, 160, 160)
                    part.Transparency = 0
                    part.CastShadow = false
                elseif part:IsA("Decal") then
                    pcall(function() part:Destroy() end)
                end
            end
        end

        -- 7. World Map Eraser (Make non-character parts 100% invisible / non-rendering)
        local function EraseWorldPart(part)
            if not part or not part.Parent then return end
            local char = LocalPlayer.Character
            if char and part:IsDescendantOf(char) then return end

            if part:IsA("BasePart") then
                part.Material = Enum.Material.SmoothPlastic
                part.CastShadow = false
                part.Reflectance = 0
                part.Transparency = 1 -- Non-rendering invisible part
            elseif part:IsA("Decal") or part:IsA("Texture") or part:IsA("SurfaceAppearance") then
                pcall(function() part:Destroy() end)
            elseif part:IsA("ParticleEmitter") or part:IsA("Trail") or part:IsA("Beam") or part:IsA("Smoke") or part:IsA("Fire") or part:IsA("Sparkles") or part:IsA("Light") then
                part.Enabled = false
            end
        end

        -- Erase existing workspace objects
        for _, obj in ipairs(Workspace:GetDescendants()) do
            EraseWorldPart(obj)
        end

        -- Style current character
        if LocalPlayer.Character then
            StyleClayCharacter(LocalPlayer.Character)
        end

        -- Continuous listeners for streamed map chunks & character respawns
        Workspace.DescendantAdded:Connect(function(part)
            task.defer(function()
                EraseWorldPart(part)
            end)
        end)

        LocalPlayer.CharacterAdded:Connect(function(newChar)
            task.wait(0.2)
            StyleClayCharacter(newChar)
        end)
    end)
end
ApplyUltraFPSBoost()

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
        or ReplicatedStorage:FindFirstChild("CommF_")
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
-- 3. ANTICHEAT TELEPORT TAG MANAGER (Blox Fruits Native Tag)
-- ====================================================================
local TagActive = false
local TagExpires = 0

local function ApplyTeleportTag()
    TagExpires = tick() + 1.5
    if not CollectionService:HasTag(LocalPlayer, "Teleporting") then
        CollectionService:AddTag(LocalPlayer, "Teleporting")
        TagActive = true
    end
end

task.spawn(function()
    while true do
        task.wait(0.1)
        if TagActive and tick() >= TagExpires then
            CollectionService:RemoveTag(LocalPlayer, "Teleporting")
            TagActive = false
        end
    end
end)

-- ====================================================================
-- 4. CHARACTER NOCLIP & UNSEAT ENGINE
-- ====================================================================
RunService.Stepped:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end)
end)

local function UnseatPlayer()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hum then return end

    pcall(function()
        if hum.SeatPart then
            local seat = hum.SeatPart
            local weld = seat:FindFirstChild("SeatWeld") or (char and char:FindFirstChild("SeatWeld", true))
            if weld then weld:Destroy() end
        end
        for _, v in ipairs(char:GetDescendants()) do
            if v:IsA("Weld") and v.Name == "SeatWeld" then
                v:Destroy()
            end
        end
        hum.Sit = false
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
    end)

    if hrp and hrp:FindFirstChild("FloatForce") then
        pcall(function() hrp.FloatForce:Destroy() end)
    end
end

-- ====================================================================
-- 5. FLOATFORCE BODYVELOCITY (Vertical physics lock & anti-water)
-- ====================================================================
local function SetHoverForce(hrp)
    if not hrp or not hrp.Parent then return nil end
    local force = hrp:FindFirstChild("FloatForce")
    if not force then
        force = Instance.new("BodyVelocity")
        force.Name = "FloatForce"
        force.Parent = hrp
    end
    force.Velocity = Vector3.new(0, 0, 0)
    force.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    force.P = 10000

    local char = hrp.Parent
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum and hum.Health > 0 and hum.SeatPart == nil and hum:GetState() ~= Enum.HumanoidStateType.Dead then
        pcall(function()
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
            local cur = hum:GetState()
            if cur == Enum.HumanoidStateType.Swimming or cur == Enum.HumanoidStateType.StrafingNoPhysics or cur == Enum.HumanoidStateType.Running then
                hum:ChangeState(Enum.HumanoidStateType.Freefall)
            end
        end)
    end
    return force
end

local function RemoveHoverForce(hrp)
    if not hrp then return end
    local force = hrp:FindFirstChild("FloatForce")
    if force then pcall(function() force:Destroy() end) end
end

-- ====================================================================
-- 6. TWEEN MANAGER & DELTATIME LERP ENGINE (From Banana Hub & QuanumOnyx)
-- ====================================================================
local TweenManager = {
    currentTween = nil,
    currentPart = nil,
    currentGoal = nil,
    TweenRunning = false,
}
getgenv().TweenManager = TweenManager

function TweenManager.CancelTweenOnly()
    local t = TweenManager.currentTween
    if t then
        pcall(function()
            t:Cancel()
            t:Destroy()
        end)
    end
    TweenManager.currentTween = nil
    TweenManager.currentPart = nil
    TweenManager.currentGoal = nil
    TweenManager.TweenRunning = false

    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        RemoveHoverForce(hrp)
    end
end

function TweenManager.CancelCurrent()
    TweenManager.CancelTweenOnly()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum and hum.Health > 0 then
        hum.PlatformStand = false
        pcall(function()
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
            hum:ChangeState(Enum.HumanoidStateType.Freefall)
        end)
    end
end

local activeCoroutine = nil
local function B(hrp, goalCF, targetSpeed, snapThreshold)
    if not hrp or typeof(goalCF) ~= "CFrame" then return end
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not char or hrp.Parent ~= char or not hum or hum.Health <= 0 then return end

    if TweenManager.TweenRunning and TweenManager.currentGoal and TweenManager.currentPart == hrp then
        local goalDiff = (TweenManager.currentGoal.Position - goalCF.Position).Magnitude
        if goalDiff <= 12 then
            return TweenManager.currentTween
        end
    end

    TweenManager.CancelTweenOnly()
    if activeCoroutine and coroutine.status(activeCoroutine) == "suspended" then
        pcall(coroutine.close, activeCoroutine)
    end

    targetSpeed = tonumber(targetSpeed) or 260
    snapThreshold = tonumber(snapThreshold) or 4

    SetHoverForce(hrp)

    local isCancelled = false
    local tweenObj = { PlaybackState = Enum.PlaybackState.Playing }

    local function cleanup()
        if TweenManager.currentTween == tweenObj then
            TweenManager.currentTween = nil
            TweenManager.currentPart = nil
            TweenManager.currentGoal = nil
            TweenManager.TweenRunning = false
        end
    end

    function tweenObj:Pause()
        isCancelled = true
        tweenObj.PlaybackState = Enum.PlaybackState.Paused
    end

    function tweenObj:Cancel()
        isCancelled = true
        tweenObj.PlaybackState = Enum.PlaybackState.Cancelled
        cleanup()
    end

    function tweenObj:Destroy()
        tweenObj:Cancel()
    end

    local D = coroutine.create(function()
        local startCF = hrp.CFrame
        local targetCFrame = goalCF
        if targetCFrame.Rotation == CFrame.identity and startCF.Rotation ~= CFrame.identity then
            targetCFrame = CFrame.new(targetCFrame.Position) * startCF.Rotation
        end
        local totalDistance = (targetCFrame.Position - startCF.Position).Magnitude

        if totalDistance <= snapThreshold then
            hrp.CFrame = targetCFrame
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            tweenObj.PlaybackState = Enum.PlaybackState.Completed
            cleanup()
            return
        end

        local distanceTraveled = 0
        local lastTick = tick()

        while not isCancelled do
            local charNow = LocalPlayer.Character
            local humNow = charNow and charNow:FindFirstChildOfClass("Humanoid")
            if not charNow or hrp.Parent ~= charNow or not humNow or humNow.Health <= 0 or hrp.Anchored then
                break
            end

            local curState = humNow:GetState()
            if curState == Enum.HumanoidStateType.Swimming
                or curState == Enum.HumanoidStateType.StrafingNoPhysics
                or curState == Enum.HumanoidStateType.Running
                or curState == Enum.HumanoidStateType.Climbing
            then
                pcall(function()
                    humNow:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
                    humNow:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
                    humNow:ChangeState(Enum.HumanoidStateType.Freefall)
                end)
            end

            local dt = RunService.Heartbeat:Wait()
            local currentTick = tick()
            local elapsed = currentTick - lastTick
            lastTick = currentTick

            distanceTraveled = distanceTraveled + (targetSpeed * elapsed)
            local alpha = math.clamp(distanceTraveled / totalDistance, 0, 1)

            local currentPos = startCF.Position:Lerp(targetCFrame.Position, alpha)
            local moveVec = targetCFrame.Position - currentPos

            if targetCFrame.Rotation ~= CFrame.identity and targetCFrame.Rotation ~= startCF.Rotation then
                hrp.CFrame = startCF:Lerp(targetCFrame, alpha)
            else
                if moveVec.Magnitude > 0.5 then
                    local flatLook = Vector3.new(moveVec.X, 0, moveVec.Z)
                    if flatLook.Magnitude > 0.1 then
                        hrp.CFrame = CFrame.lookAt(currentPos, currentPos + flatLook)
                    else
                        hrp.CFrame = CFrame.new(currentPos) * startCF.Rotation
                    end
                else
                    hrp.CFrame = CFrame.new(currentPos) * startCF.Rotation
                end
            end

            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero

            ApplyTeleportTag()

            local remaining = (targetCFrame.Position - hrp.Position).Magnitude
            if alpha >= 1 or remaining <= snapThreshold then
                hrp.CFrame = targetCFrame
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.AssemblyAngularVelocity = Vector3.zero

                for _ = 1, 6 do
                    RunService.Heartbeat:Wait()
                    if isCancelled or not hrp or not hrp.Parent then break end
                    hrp.CFrame = targetCFrame
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                end

                tweenObj.PlaybackState = Enum.PlaybackState.Completed
                break
            end
        end

        cleanup()
    end)

    activeCoroutine = D
    TweenManager.currentTween = tweenObj
    TweenManager.currentPart = hrp
    TweenManager.currentGoal = goalCF
    TweenManager.TweenRunning = true

    if not coroutine.resume(D) then
        tweenObj:Cancel()
        return nil
    end
    return tweenObj
end

-- Master toTarget Navigation
local function toTarget(targetCF, snapThreshold, customSpeed)
    if typeof(targetCF) ~= "CFrame" then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum or hum.Health <= 0 then return end

    if hum.Sit then
        UnseatPlayer()
        task.wait(0.04)
    end

    SetHoverForce(hrp)

    local currentDist = (targetCF.Position - hrp.Position).Magnitude
    snapThreshold = snapThreshold or 4

    if currentDist < snapThreshold then
        TweenManager.CancelTweenOnly()
        ApplyTeleportTag()
        hrp.CFrame = targetCF
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        return
    end

    local hPos = hrp.Position
    local pPos = targetCF.Position
    local comm = CommF or (ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_"))

    local placeId = game.PlaceId
    local isSea1 = (placeId == 2753915549 or placeId == 85211729168715)
    local isSea3 = (placeId == 7449423635 or placeId == 100117331123089)

    -- Sea 1 Skylands (Upper <-> Lower)
    if isSea1 then
        if hPos.Y > 3000 and pPos.Y < 2500 and (pPos - Vector3.new(-7894, 5547, -380)).Magnitude > 1000 then
            local exitCF = CFrame.new(-7894, 5547, -380)
            if (hPos - exitCF.Position).Magnitude > 50 then
                B(hrp, exitCF, 350, 12)
                return
            else
                if comm then comm:InvokeServer("requestEntrance", Vector3.new(-4607, 874, -1667)) end
                TweenManager.CancelCurrent()
                task.wait(0.5)
                return
            end
        elseif hPos.Y < 2500 and pPos.Y > 3000 then
            local enterCF = CFrame.new(-4607, 874, -1667)
            if (hPos - enterCF.Position).Magnitude > 50 then
                B(hrp, enterCF, 350, 12)
                return
            else
                if comm then comm:InvokeServer("requestEntrance", Vector3.new(-7894, 5547, -380)) end
                TweenManager.CancelCurrent()
                task.wait(0.5)
                return
            end
        end

        -- Sea 1 Underwater City
        if hPos.X > 50000 and pPos.X < 50000 then
            local exitCF = CFrame.new(61163, 11, 1819)
            if (hPos - exitCF.Position).Magnitude > 50 then
                B(hrp, exitCF, 350, 12)
                return
            else
                if comm then comm:InvokeServer("requestEntrance", Vector3.new(4050, -1, -1814)) end
                TweenManager.CancelCurrent()
                task.wait(0.5)
                return
            end
        elseif hPos.X < 50000 and pPos.X > 50000 then
            local enterCF = CFrame.new(4050, -1, -1814)
            if (hPos - enterCF.Position).Magnitude > 50 then
                B(hrp, enterCF, 350, 12)
                return
            else
                if comm then comm:InvokeServer("requestEntrance", Vector3.new(61163, 11, 1819)) end
                TweenManager.CancelCurrent()
                task.wait(0.5)
                return
            end
        end
    end

    -- Sea 3 Temple of Time & Submerged Island
    if isSea3 then
        local totPos = Vector3.new(28609.39, 14896.53, 106.42)
        if (pPos - totPos).Magnitude > 3000 and (totPos - hPos).Magnitude <= 3000 then
            B(hrp, CFrame.new(totPos), 400, 8)
            if (totPos - hPos).Magnitude < 8 and comm then
                comm:InvokeServer("RaceV4Progress", "Check")
                comm:InvokeServer("RaceV4Progress", "TeleportBack")
                TweenManager.CancelCurrent()
            end
            return
        end

        local subPos = Vector3.new(11538.60, -2154.70, 9827.31)
        if (pPos - subPos).Magnitude <= 3000 and (subPos - hPos).Magnitude > 3000 then
            local subEntrance = CFrame.new(-16269.41, 23.98, 1371.66)
            B(hrp, subEntrance, 350, 8)
            if (subEntrance.Position - hPos).Magnitude < 8 then
                local net = ReplicatedStorage:FindFirstChild("Modules") and ReplicatedStorage.Modules:FindFirstChild("Net")
                local rf = net and net:FindFirstChild("RF/SubmarineWorkerSpeak")
                if rf then rf:InvokeServer("TravelToSubmergedIsland") end
                if comm then comm:InvokeServer("SetLastSpawnPoint", "SubmergedIsland") end
                TweenManager.CancelCurrent()
            end
            return
        end
    end

    B(hrp, targetCF, customSpeed or 260, snapThreshold)
end

-- ====================================================================
-- 7. COMBAT & FARMING SYSTEM
-- ====================================================================
local Combat = {
    FastAttack = true,
    BringMob = true,
    PreferredWeapon = "Melee",
    HoverY = 20,
    HoverSide = 7,
}

local function IsMobAlive(mob)
    if not mob or not mob.Parent then return false end
    local hum = mob:FindFirstChildOfClass("Humanoid")
    return hum and hum.Health > 0
end

local function DisableMobCollision(mob)
    if not mob or not mob.Parent then return end
    pcall(function()
        for _, part in ipairs(mob:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end)
end

local function GetFarmCFrame(mobRoot)
    if not mobRoot then return nil end
    local side = (Combat.PreferredWeapon == "Blox Fruit") and -Combat.HoverSide or Combat.HoverSide
    return mobRoot.CFrame * CFrame.new(side, Combat.HoverY, 0)
end

local function CheckBuso()
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        local hasBuso = char:FindFirstChild("HasBuso")
        local busoLayer = false
        for _, c in ipairs(char:GetChildren()) do
            if c.Name:find("_BusoLayer") then busoLayer = true; break end
        end
        if not hasBuso and not busoLayer and CommF then
            CommF:InvokeServer("Buso")
        end
    end)
end

local function EquipWeapon()
    pcall(function()
        local bp = LocalPlayer.Backpack
        local char = LocalPlayer.Character
        if not bp or not char then return end

        local curTool = char:FindFirstChildOfClass("Tool")
        if curTool and (curTool.ToolTip == Combat.PreferredWeapon or curTool:GetAttribute("WeaponType") == Combat.PreferredWeapon) then
            return
        end

        for _, tool in ipairs(bp:GetChildren()) do
            if tool:IsA("Tool") and (tool.ToolTip == Combat.PreferredWeapon or tool:GetAttribute("WeaponType") == Combat.PreferredWeapon) then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then hum:EquipTool(tool); return end
            end
        end

        if Combat.PreferredWeapon == "Melee" then
            for _, tool in ipairs(bp:GetChildren()) do
                if tool:IsA("Tool") and not tool:FindFirstChild("EatRemote", true) and tool.ToolTip ~= "Sword" and tool.ToolTip ~= "Gun" then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then hum:EquipTool(tool); return end
                end
            end
        end
    end)
end

local LastBringMob = nil
local BringSpawnCF = nil

local function BringMob(primaryMob)
    if not Combat.BringMob or not IsMobAlive(primaryMob) then return end
    local primHRP = primaryMob:FindFirstChild("HumanoidRootPart")
    if not primHRP then return end

    if LastBringMob ~= primaryMob then
        LastBringMob = primaryMob
        BringSpawnCF = primHRP.CFrame
    end

    DisableMobCollision(primaryMob)

    local enemies = Workspace:FindFirstChild("Enemies")
    if not enemies then return end

    local count = 1
    for _, mob in ipairs(enemies:GetChildren()) do
        if mob ~= primaryMob and mob.Name == primaryMob.Name and IsMobAlive(mob) and not mob:FindFirstChild("Ignored") then
            local mRoot = mob:FindFirstChild("HumanoidRootPart")
            if mRoot then
                local dist = (mRoot.Position - primHRP.Position).Magnitude
                if dist <= 220 and count < 4 then
                    DisableMobCollision(mob)
                    mRoot.CFrame = BringSpawnCF * CFrame.new(0, math.random(0, 2), math.random(0, 2))
                    mRoot.Velocity = Vector3.zero
                    mRoot.RotVelocity = Vector3.zero
                    count = count + 1

                    task.spawn(function()
                        local hum = mob:FindFirstChildOfClass("Humanoid")
                        local hp0 = hum and hum.Health or 0
                        task.wait(2.5)
                        if hum and hum.Health == hp0 and mob.Parent and not mob:FindFirstChild("Ignored") and mRoot and mRoot.Parent then
                            mRoot.CFrame = mob:GetPivot()
                            Instance.new("IntValue", mob).Name = "Ignored"
                        end
                    end)
                end
            end
        end
    end
end

local function Attack()
    if not Combat.FastAttack then return end
    pcall(function()
        CheckBuso()
        local char = LocalPlayer.Character
        if not char then return end

        local stun = char:FindFirstChild("Stun")
        if stun and stun.Value ~= 0 then return end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        local enemies = Workspace:FindFirstChild("Enemies")
        if not hrp or not enemies then return end

        local hitTargets = {}
        for _, mob in ipairs(enemies:GetChildren()) do
            if IsMobAlive(mob) then
                local mobHRP = mob:FindFirstChild("HumanoidRootPart")
                if mobHRP and (mobHRP.Position - hrp.Position).Magnitude <= 75 then
                    table.insert(hitTargets, { mob, mobHRP })
                    if #hitTargets >= 5 then break end
                end
            end
        end

        if #hitTargets == 0 then return end

        if RegisterAttackRemote and RegisterHitRemote then
            RegisterAttackRemote:FireServer(0)
            local primary = table.remove(hitTargets, 1)
            RegisterHitRemote:FireServer(primary[2], hitTargets)
        else
            local tool = char:FindFirstChildOfClass("Tool")
            if tool then tool:Activate() end
        end
    end)
end

task.spawn(function()
    while true do
        task.wait(0.05)
        Attack()
    end
end)

-- ====================================================================
-- 8. QUEST DATABASE (LEVEL 1 TO 2550+)
-- ====================================================================
local Data = {
    Places = {
        Sea1 = { 2753915549, 85211729168715 },
        Sea2 = { 4442272183, 79091703265657 },
        Sea3 = { 7449423635, 100117331123089 }
    },
    Quests = {
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

        -- Sea 2
        { Level = 700, Mob = "Raider",             Quest = "Area1Quest",         Id = 1, PosQ = CFrame.new(-429.54, 73.02, 1836.18),  PosM = CFrame.new(-650.54, 73.02, 1836.18) },
        { Level = 775, Mob = "Swan Pirate",        Quest = "Area2Quest",         Id = 1, PosQ = CFrame.new(638.43, 73.02, 918.28),    PosM = CFrame.new(878.01, 121.36, 1212.18) },
        { Level = 875, Mob = "Marine Lieutenant",  Quest = "MarineQuest3",       Id = 1, PosQ = CFrame.new(-2440.79, 73.02, -3216.06),PosM = CFrame.new(-2600.79, 73.02, -3216.06) },
        { Level = 1000,Mob = "Snow Trooper",       Quest = "SnowMountainQuest",  Id = 1, PosQ = CFrame.new(609.86, 401.48, -5372.25), PosM = CFrame.new(500.86, 401.48, -5372.25) },
        { Level = 1100,Mob = "Lab Subordinate",    Quest = "IceSideQuest",       Id = 1, PosQ = CFrame.new(-6064.07, 15.95, -4902.98),PosM = CFrame.new(-5800.07, 15.95, -4902.98) },
        { Level = 1250,Mob = "Ship Deckhand",      Quest = "ShipQuest1",         Id = 1, PosQ = CFrame.new(1031.50, 125.07, 32911.00),PosM = CFrame.new(1150.50, 125.07, 32911.00) },
        { Level = 1350,Mob = "Arctic Warrior",     Quest = "FrostQuest",         Id = 1, PosQ = CFrame.new(5667.66, 28.17, -6486.09), PosM = CFrame.new(5900.66, 28.17, -6486.09) },

        -- Sea 3
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
-- 9. GRAVITYHUB BACKGROUND SERVICES (FRUIT SNIPER, AUTO CHAT, HAKI)
-- ====================================================================

-- Auto Stat Allocator
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

-- Fruit Gacha, Storage & Sniper Shop
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

                -- Sniper Fruit Shop
                local sniper = GH["Sniper Fruit Shop"]
                if sniper and sniper["Enabled"] and sniper["Fruit"] then
                    for _, fruitName in ipairs(sniper["Fruit"]) do
                        pcall(function()
                            CommF:InvokeServer("BuyFruit", fruitName)
                        end)
                    end
                end
            end
        end)
    end
end)

-- Buy Haki Engine (Enhancement, Skyjump, Flash Step, Observation)
task.spawn(function()
    while true do
        task.wait(15)
        pcall(function()
            local haki = GH["Buy Haki"]
            if haki and CommF then
                if haki["Skyjump"] then CommF:InvokeServer("BuyHaki", "Geppo") end
                if haki["Enhancement"] then CommF:InvokeServer("Buso") end
                if haki["Flash Step"] then CommF:InvokeServer("BuyHaki", "Soru") end
                if haki["Observation"] then CommF:InvokeServer("KenTalk", "Buy") end
            end
        end)
    end
end)

-- Auto Chat
task.spawn(function()
    while true do
        task.wait(20)
        pcall(function()
            local ac = GH["Auto Chat"]
            if ac and ac["Enabled"] and ac["Text"] and ac["Text"] ~= "" then
                local chatEvents = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
                local sayMsg = chatEvents and chatEvents:FindFirstChild("SayMessageRequest")
                if sayMsg then
                    sayMsg:FireServer(ac["Text"], "All")
                end
            end
        end)
    end
end)

-- ====================================================================
-- 10. RACE EVOLUTION ENGINE (V2, V3, & V4)
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

-- Synchronize with GravityHub "Get Items"
if GH["Get Items"] then
    if GH["Get Items"]["Upgrade Race V2-V3"] ~= nil then
        Race.AutoRaceV2 = GH["Get Items"]["Upgrade Race V2-V3"]
        Race.AutoRaceV3 = GH["Get Items"]["Upgrade Race V2-V3"]
    end
    if GH["Get Items"]["Auto Pull Lever"] ~= nil then
        Race.AutoRaceV4 = GH["Get Items"]["Auto Pull Lever"]
        Race.AutoPullLever = GH["Get Items"]["Auto Pull Lever"]
    end
end

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

function Race.DoRaceV2()
    if not Race.AutoRaceV2 or not CommF or Data.GetSea() ~= 2 then return false end
    local d = LocalPlayer:FindFirstChild("Data")
    if not d or not d:FindFirstChild("Level") or d.Level.Value < 850 then return false end

    local state = CommF:InvokeServer("Alchemist", "1")
    if state == 0 then
        toTarget(Race.AlchemistCF, 6)
        CommF:InvokeServer("Alchemist", "2")
        return true
    elseif state == 1 then
        if not HasItem("Flower 1") then
            if Workspace:FindFirstChild("Flower1") then
                toTarget(Workspace.Flower1.CFrame, 3)
            else
                toTarget(CFrame.new(-5497.06, 47.59, -795.14), 10)
            end
            return true
        elseif not HasItem("Flower 2") then
            if Workspace:FindFirstChild("Flower2") then
                toTarget(Workspace.Flower2.CFrame, 3)
            else
                toTarget(CFrame.new(-429.54, 71.76, 1836.18), 10)
            end
            return true
        elseif not HasItem("Flower 3") then
            local enemies = Workspace:FindFirstChild("Enemies")
            local mob = enemies and enemies:FindFirstChild("Swan Pirate")
            if mob and IsMobAlive(mob) then
                local root = mob:FindFirstChild("HumanoidRootPart")
                if root then
                    toTarget(GetFarmCFrame(root), 5)
                    BringMob(mob)
                    EquipWeapon()
                end
            else
                toTarget(CFrame.new(878.01, 121.36, 1212.18), 10)
            end
            return true
        end
    elseif state == 2 then
        if GetPlayerBeli() >= 500000 then
            toTarget(Race.AlchemistCF, 6)
            CommF:InvokeServer("Alchemist", "3")
        end
        return true
    end
    return false
end

function Race.DoRaceV3()
    if not Race.AutoRaceV3 or not CommF or Data.GetSea() ~= 2 then return false end
    local d = LocalPlayer:FindFirstChild("Data")
    if not d or not d:FindFirstChild("Level") or d.Level.Value < 1000 then return false end

    local state = CommF:InvokeServer("Wenlocktoad", "1")
    if state == 0 then
        toTarget(Race.AroweCF, 6)
        CommF:InvokeServer("Wenlocktoad", "2")
        return true
    elseif state == 2 and GetPlayerBeli() >= 2000000 then
        toTarget(Race.AroweCF, 6)
        CommF:InvokeServer("Wenlocktoad", "3")
        return true
    end
    return false
end

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

function Race.CheckTempleUnlock()
    if not CommF or not HasItem("Valkyrie Helm") or not HasItem("Mirror Fractal") then return false end
    if CommF:InvokeServer("CheckTempleDoor") then return true end

    local step = CommF:InvokeServer("RaceV4Progress", "Check")
    if step == 1 then
        CommF:InvokeServer("RaceV4Progress", "Begin")
        return true
    elseif step == 2 then
        toTarget(Race.GreatTreePeakCF, 6)
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

function Race.DoMirageGear()
    if not Race.AutoMirageGear then return false end
    local mirage = GetMirage()
    if not mirage then return false end

    local blueGear = GetMirageGear(mirage)
    if blueGear and not blueGear.CanCollide and blueGear.Transparency ~= 1 then
        toTarget(blueGear.CFrame, 2)
        return true
    end

    if IsNight() then
        local peak = GetMiragePeak(mirage)
        if peak then
            local peakCF = peak.CFrame * CFrame.new(0, 211.88, 0)
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not hrp or (hrp.Position - peakCF.Position).Magnitude > 10 then
                toTarget(peakCF, 6)
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

function Race.DoPullLever()
    if not Race.AutoPullLever or not CommF then return false end
    if not HasItem("Valkyrie Helm") or not HasItem("Mirror Fractal") then return false end

    local temple = GetTemple()
    if not temple then
        toTarget(Race.TempleOfTimeCF, 10)
        return true
    end

    local leverModel = temple:FindFirstChild("Lever")
    if leverModel and leverModel:FindFirstChild("Lever") and leverModel:FindFirstChild("Prompt") then
        local prompt = leverModel.Prompt:FindFirstChildOfClass("ProximityPrompt")
        local leverCF = leverModel.Lever.CFrame
        if math.abs(leverCF.Z - 75.47) >= 0.5 then
            toTarget(leverModel.Lever.CFrame, 4)
            if prompt then fireproximityprompt(prompt, 1) end
            return true
        end
    end
    return false
end

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
                toTarget(door.CFrame, 4)
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp and (hrp.Position - door.Position).Magnitude <= 8 then
                    PressKey("T")
                end
                return true
            end
        end
        return false
    end

    if playerRace == "Human" or playerRace == "Ghoul" then
        local enemies = Workspace:FindFirstChild("Enemies")
        if enemies then
            for _, mob in ipairs(enemies:GetChildren()) do
                if IsMobAlive(mob) then
                    local mRoot = mob:FindFirstChild("HumanoidRootPart")
                    if mRoot then
                        toTarget(GetFarmCFrame(mRoot), 5)
                        BringMob(mob)
                        EquipWeapon()
                        return true
                    end
                end
            end
        end
    elseif playerRace == "Skypiea" then
        local finish = Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("SkyTrial") and Workspace.Map.SkyTrial.Model:FindFirstChild("FinishPart")
        if finish then
            toTarget(finish.CFrame * CFrame.new(0, 5, 0), 3)
            return true
        end
    elseif playerRace == "Fishman" then
        local seaBeasts = Workspace:FindFirstChild("SeaBeasts")
        if seaBeasts then
            for _, sb in ipairs(seaBeasts:GetChildren()) do
                if sb:FindFirstChild("HumanoidRootPart") and sb:FindFirstChild("Health") and sb.Health.Value > 0 then
                    toTarget(sb.HumanoidRootPart.CFrame * CFrame.new(0, 80, 30), 10)
                    EquipWeapon()
                    return true
                end
            end
        end
    elseif playerRace == "Mink" then
        local startPoint = Workspace:FindFirstChild("StartPoint")
        if startPoint then
            toTarget(startPoint.CFrame * CFrame.new(0, 3, 0), 3)
            return true
        end
    elseif playerRace == "Cyborg" then
        local floor = Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("CyborgTrial") and Workspace.Map.CyborgTrial:FindFirstChild("Floor")
        if floor then
            toTarget(floor.CFrame * CFrame.new(0, 180, 0), 5)
            return true
        end
    end

    return true
end

function Race.DoAncientClock()
    if not Race.AutoAncientClock or not CommF then return false end
    local info = nil
    pcall(function() info = CommF:InvokeServer("TempleClock", "Check") end)
    if info and info.HadPoint then
        toTarget(Race.AncientClockCF, 5)
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
-- 11. SECRET ENDGAME QUESTS ENGINE (CDK, YAMA, TUSHITA, SOUL GUITAR)
-- ====================================================================
local SecretQuests = {
    AutoYama = true,
    AutoTushita = true,
    AutoCDK = true,
    AutoSoulGuitar = true,
}

if GH["Get Items"] then
    if GH["Get Items"]["Cursed Dual Katana"] ~= nil then
        SecretQuests.AutoCDK = GH["Get Items"]["Cursed Dual Katana"]
        SecretQuests.AutoYama = GH["Get Items"]["Cursed Dual Katana"]
        SecretQuests.AutoTushita = GH["Get Items"]["Cursed Dual Katana"]
    end
    if GH["Get Items"]["Skull Guitar"] ~= nil or GH["Get Items"]["Soul Guitar"] ~= nil then
        SecretQuests.AutoSoulGuitar = GH["Get Items"]["Skull Guitar"] or GH["Get Items"]["Soul Guitar"]
    end
end

function SecretQuests.DoYama()
    if not SecretQuests.AutoYama or not CommF or Data.GetSea() ~= 3 or HasItem("Yama") then return false end
    local eliteKills = CommF:InvokeServer("EliteHunter", "Progress") or 0
    if eliteKills < 30 then
        local enemies = Workspace:FindFirstChild("Enemies")
        if enemies then
            for _, name in ipairs({ "Urban", "Diablo", "Deandre" }) do
                local mob = enemies:FindFirstChild(name)
                if mob and IsMobAlive(mob) then
                    local mRoot = mob:FindFirstChild("HumanoidRootPart")
                    if mRoot then
                        toTarget(GetFarmCFrame(mRoot), 5)
                        BringMob(mob)
                        EquipWeapon()
                        return true
                    end
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
            toTarget(CFrame.new(5251.90, 17.18, 453.60), 10)
            return true
        end
    end
end

function SecretQuests.DoTushita()
    if not SecretQuests.AutoTushita or not CommF or Data.GetSea() ~= 3 or HasItem("Tushita") then return false end
    local ripIndra = Workspace:FindFirstChild("Enemies") and Workspace.Enemies:FindFirstChild("rip_indra True Form")
    if ripIndra and IsMobAlive(ripIndra) then
        local door = Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("Waterfall") and Workspace.Map.Waterfall:FindFirstChild("SecretRoom")
        if door then
            toTarget(CFrame.new(5251.90, 17.18, 453.60), 10)
            return true
        end
    end
    local longma = Workspace:FindFirstChild("Enemies") and Workspace.Enemies:FindFirstChild("Longma")
    if longma and IsMobAlive(longma) then
        local mRoot = longma:FindFirstChild("HumanoidRootPart")
        if mRoot then
            toTarget(GetFarmCFrame(mRoot), 5)
            BringMob(longma)
            EquipWeapon()
            return true
        end
    end
    return false
end

function SecretQuests.DoCDK()
    if not SecretQuests.AutoCDK or not CommF or Data.GetSea() ~= 3 or HasItem("Cursed Dual Katana") then return false end
    if not HasItem("Yama") or not HasItem("Tushita") then return false end
    local cdkNPC = CFrame.new(-12061.27, 332.12, -7534.50)
    toTarget(cdkNPC, 5)
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
        toTarget(graveCF, 5)
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
-- 12. HEADS-UP DISPLAY (HUD)
-- ====================================================================
local HUDStatus = "Starting up..."
local function CreateHUD()
    if GH["Hide UI"] then return end
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
        t.Text = "🍌 BANANA KAITUN • GRAVITYHUB"
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
                    info.Text = string.format("Level: %d / 2550\nSea: %d | Race: %s\nBeli: $%d | Fragments: %d\nAction: %s\nMode: CLAY VOID FPS BOOST ⚡", lvl, sea, raceName, beli, frags, HUDStatus)
                end)
            end
        end)
    end)
end
CreateHUD()

-- ====================================================================
-- 13. MASTER AUTONOMOUS PROGRESSION LOOP (1 TO MAX 2550+)
-- ====================================================================
task.spawn(function()
    while true do
        task.wait(0.1)
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
                        toTarget(CFrame.new(4852.28, 5.65, 718.53), 5)
                        task.wait(0.5)
                        CommF:InvokeServer("DressrosaQuestProgress", "Detective")
                    else
                        local enemies = Workspace:FindFirstChild("Enemies")
                        local iceAdmiral = enemies and enemies:FindFirstChild("Ice Admiral")
                        if iceAdmiral and IsMobAlive(iceAdmiral) then
                            local root = iceAdmiral:FindFirstChild("HumanoidRootPart")
                            if root then
                                toTarget(GetFarmCFrame(root), 5)
                                BringMob(iceAdmiral)
                                EquipWeapon()
                                return
                            end
                        else
                            toTarget(CFrame.new(1347.71, 37.37, -1325.64), 10)
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
                toTarget(quest.PosQ, 5)
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp and (hrp.Position - quest.PosQ.Position).Magnitude <= 10 and CommF then
                    CommF:InvokeServer("StartQuest", quest.Quest, quest.Id)
                    task.wait(0.3)
                end
            else
                HUDStatus = string.format("Farming %s (Lv %d)", quest.Mob, quest.Level)
                local targetMob = nil
                local enemies = Workspace:FindFirstChild("Enemies")
                if enemies then
                    for _, mob in ipairs(enemies:GetChildren()) do
                        if mob.Name:find(quest.Mob) and IsMobAlive(mob) then
                            targetMob = mob
                            break
                        end
                    end
                end

                if targetMob then
                    local mobHRP = targetMob:FindFirstChild("HumanoidRootPart")
                    if mobHRP then
                        toTarget(GetFarmCFrame(mobHRP), 5)
                        BringMob(targetMob)
                        EquipWeapon()
                    end
                else
                    toTarget(quest.PosM, 15)
                end
            end
        end)
    end
end)

print("[🍌 Banana Kaitun Standalone] Initialized with GravityHub schema & Ultra FPS Boost!")
