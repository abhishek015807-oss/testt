-- ====================================================================
-- 🍌 BANANA KAITUN - ALL-IN-ONE STANDALONE SUITE (FIXED & ENHANCED)
-- Autonomous Level 1 to Max (2550+) Botting Suite for Blox Fruits
-- Powered by the battle-tested TweenManager & Farm Engine from Banana Hub
-- Integrated with BananaHub getgenv configuration & Ultra FPS Boost
-- Zero external filesystem dependencies - 100% executor compatible
-- ====================================================================

repeat wait() until game:IsLoaded() and game:GetService("Players").LocalPlayer

-- ====================================================================
-- BANANA KAITUN - SINGLETON EXECUTION GUARD (PREVENTS 2x / 3x MULTI-EXECUTE)
-- Automatically cancels out duplicate executions if script is already running
-- ====================================================================
local g = getgenv()
if g.__BananaKaitun_Active and g.__BananaKaitun_RT and g.__BananaKaitun_RT.alive and not g.ForceReload and not g.__BananaKaitun_ForceReload then
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "🍌 Banana Hub Kaitun",
            Text = "Script is already running! Duplicate execution cancelled.",
            Duration = 4
        })
    end)
    warn("[🍌 Banana Hub Kaitun] Script is ALREADY ACTIVE & RUNNING! Duplicate execution cancelled.")
    return
end

-- If previous instance requested reload, cleanly shut it down first
if type(g.__BananaKaitun_Shutdown) == "function" then
    pcall(g.__BananaKaitun_Shutdown)
end

-- Destroy existing duplicate UIs in CoreGui or PlayerGui
pcall(function()
    local core = game:GetService("CoreGui")
    local lp = game:GetService("Players").LocalPlayer
    local pg = lp and lp:FindFirstChild("PlayerGui")
    for _, parent in ipairs({ core, pg }) do
        if parent then
            local old1 = parent:FindFirstChild("BananaKaitunStatsHUD")
            if old1 then old1:Destroy() end
            local old2 = parent:FindFirstChild("BananaKaitunStandalone")
            if old2 then old2:Destroy() end
        end
    end
end)

g.__BananaKaitun_Active = true

-- ====================================================================
-- DEFAULT CONFIGURATION (BANANAHUB SCHEMA SPECIFICATION)
-- ====================================================================
getgenv().BananaHub = getgenv().BananaHub or getgenv().GravityHub or {
    ["Hide UI"] = false,
    ["Team"] = "Pirates", -- "Pirates" or "Marines" (Default: "Pirates")
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

getgenv().GravityHub = getgenv().BananaHub
local BH = getgenv().BananaHub
local GH = BH

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
        g.__BananaKaitun_Active = false
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
local UserInputService = game:GetService("UserInputService")
local CollectionService = game:GetService("CollectionService")
local LocalPlayer = Players.LocalPlayer

-- ====================================================================
-- AUTO REJOIN & QUEUE ON TELEPORT (PERSIST ACROSS SEAS, HOPS & DISCONNECTS)
-- ====================================================================
local function QueueAutoExecute()
    pcall(function()
        local qot = syn and syn.queue_on_teleport or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)
        if qot then
            qot([[
                repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer
                pcall(function()
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/abhishek015807-oss/testt/refs/heads/main/banana_kaitun_bundle.lua?t=" .. tostring(tick())))()
                end)
            ]])
        end
    end)
end
QueueAutoExecute()

-- Teleport listener to re-queue before leaving server
pcall(function()
    LocalPlayer.OnTeleport:Connect(function()
        QueueAutoExecute()
    end)
end)

-- Auto Rejoin on Disconnect / Kick (Error 277, 267, 268)
task.spawn(function()
    pcall(function()
        local GuiService = game:GetService("GuiService")
        local TeleportService = game:GetService("TeleportService")

        GuiService.ErrorMessageChanged:Connect(function()
            task.wait(2.5)
            QueueAutoExecute()
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        end)

        local promptOverlay = CoreGui:WaitForChild("RobloxPromptGui", 4) and CoreGui.RobloxPromptGui:WaitForChild("promptOverlay", 4)
        if promptOverlay then
            promptOverlay.ChildAdded:Connect(function(child)
                if child.Name == "ErrorPrompt" then
                    task.wait(2.5)
                    QueueAutoExecute()
                    TeleportService:Teleport(game.PlaceId, LocalPlayer)
                end
            end)
        end
    end)
end)

-- ====================================================================
-- AUTO TEAM SELECTOR (PIRATES / MARINES)
-- Automatically bypasses team selection screen so script runs immediately
-- ====================================================================
local function AutoSelectTeam()
    local configuredTeam = (GH and GH["Team"]) or getgenv().Team or "Pirates"
    local selectTeam = "Pirates"
    if tostring(configuredTeam):lower():find("marine") then
        selectTeam = "Marines"
    else
        selectTeam = "Pirates"
    end

    -- Remote execution
    pcall(function()
        local remotes = ReplicatedStorage:WaitForChild("Remotes", 3)
        if remotes and remotes:FindFirstChild("CommF_") then
            remotes.CommF_:InvokeServer("SetTeam", selectTeam)
        end
    end)

    -- UI button click fallback
    pcall(function()
        local pg = LocalPlayer:FindFirstChild("PlayerGui")
        if pg then
            local mainGui = pg:FindFirstChild("Main (minimal)") or pg:FindFirstChild("Main")
            if mainGui and mainGui:FindFirstChild("ChooseTeam") then
                local ct = mainGui.ChooseTeam
                if ct.Visible then
                    local container = ct:FindFirstChild("Container")
                    if container then
                        local teamFolder = (selectTeam == "Pirates") and container:FindFirstChild("Pirates") or container:FindFirstChild("Marines")
                        if teamFolder and teamFolder:FindFirstChild("Frame") and teamFolder.Frame:FindFirstChild("TextButton") then
                            local btn = teamFolder.Frame.TextButton
                            if typeof(getconnections) == "function" then
                                for _, c in pairs(getconnections(btn.MouseButton1Click or btn.Activated)) do
                                    pcall(function() c:Fire() end)
                                end
                            end
                        end
                    end
                    ct.Visible = false
                end
            end
        end
    end)
end

-- Wait for team and character spawn
if not LocalPlayer.Team then
    AutoSelectTeam()
    local waitStart = tick()
    repeat
        task.wait(0.5)
        if not LocalPlayer.Team then
            AutoSelectTeam()
        end
    until LocalPlayer.Team or (tick() - waitStart > 10)
end

-- Ensure character and rootpart are spawned before continuing
if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
    LocalPlayer.CharacterAdded:Wait()
    LocalPlayer.Character:WaitForChild("HumanoidRootPart", 10)
end


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
    while runtime.alive do
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
        if not hrp then return end

        local hitTargets = {}
        local function scanFolder(folder, range, limit)
            if not folder then return end
            for _, mob in ipairs(folder:GetChildren()) do
                if mob ~= char and IsMobAlive(mob) then
                    local part = mob:FindFirstChild("Head") or mob:FindFirstChild("HumanoidRootPart")
                    if part and (part.Position - hrp.Position).Magnitude <= range then
                        table.insert(hitTargets, { mob, part })
                        if #hitTargets >= limit then break end
                    end
                end
            end
        end

        scanFolder(Workspace:FindFirstChild("Enemies"), 85, 6)
        if #hitTargets < 5 then
            scanFolder(Workspace:FindFirstChild("Characters"), 75, 6)
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
    while runtime.alive do
        task.wait(0.03)
        Attack()
    end
end)

-- ====================================================================
-- RESTRICTED ITEM & PORTAL ENGINE (Ported from Quest_Hider.lua)
-- ====================================================================
local function HasRestrictedItem()
    local bp = LocalPlayer:FindFirstChild("Backpack")
    local char = LocalPlayer.Character
    local restricted = {
        "God's Chalice", "Sweet Chalice", "Hallow Essence", "Red Key",
        "Apple", "Banana", "Pineapple", "Flower 1", "Flower 2", "Flower 3"
    }
    for _, name in ipairs(restricted) do
        if (bp and bp:FindFirstChild(name)) or (char and char:FindFirstChild(name)) then
            return true
        end
    end
    return false
end

local function FindPortalRoute(origin, destination)
    local direct = (destination - origin).Magnitude
    if direct < 3000 then return nil end
    local map = Workspace:FindFirstChild("Map")
    local portal = map and map:FindFirstChild("TeleportSpawn", true)
    local entrance = portal and portal:FindFirstChild("Entrance", true)
    local exit = portal and portal:FindFirstChild("Exit", true)
    if entrance and exit and entrance:IsA("BasePart") and exit:IsA("BasePart") then
        for _, reverse in ipairs({ false, true }) do
            local source = reverse and exit or entrance
            local target = reverse and entrance or exit
            local cost = (origin - source.Position).Magnitude + (destination - target.Position).Magnitude + 150
            if cost + 1000 < direct then
                return { Source = source.CFrame, Destination = target.CFrame }
            end
        end
    end
    return nil
end

-- ====================================================================
-- 8. QUEST DATABASE (LEVEL 1 TO 2550+) - COMPLETE BANANA HUB MAPPING
-- ====================================================================
local Data = {}
Data.Places = {
    Sea1 = { 2753915549, 85211729168715 },
    Sea2 = { 4442272183, 79091703265657 },
    Sea3 = { 7449423635, 100117331123089 }
}
Data.Quests = {
	{ Min = 1, Max = 9, Quest = "BanditQuest1", Id = 1, Mob = "Bandit", PosQ = CFrame.new(1045.9626464844, 27.002508163452, 1560.8203125), PosM = CFrame.new(1045.9626464844, 27.002508163452, 1560.8203125) },
	{ Min = 10, Max = 14, Quest = "JungleQuest", Id = 1, Mob = "Monkey", PosQ = CFrame.new(-1598.08911, 35.5501175, 153.377838), PosM = CFrame.new(-1448.5180664062, 67.853012084961, 11.465796470642) },
	{ Min = 15, Max = 29, Quest = "JungleQuest", Id = 2, Mob = "Gorilla", PosQ = CFrame.new(-1598.08911, 35.5501175, 153.377838), PosM = CFrame.new(-1129.8836669922, 40.46354675293, -525.42370605469) },
	{ Min = 30, Max = 39, Quest = "BuggyQuest1", Id = 1, Mob = "Pirate", PosQ = CFrame.new(-1141.07483, 4.10001802, 3831.5498), PosM = CFrame.new(-1103.5134277344, 13.752052307129, 3896.0910644531) },
	{ Min = 40, Max = 59, Quest = "BuggyQuest1", Id = 2, Mob = "Brute", PosQ = CFrame.new(-1141.07483, 4.10001802, 3831.5498), PosM = CFrame.new(-1140.0837402344, 14.809885025024, 4322.9213867188) },
	{ Min = 60, Max = 74, Quest = "DesertQuest", Id = 1, Mob = "Desert Bandit", PosQ = CFrame.new(894.488647, 5.14000702, 4392.43359), PosM = CFrame.new(924.7998046875, 6.4486746788025, 4481.5859375) },
	{ Min = 75, Max = 89, Quest = "DesertQuest", Id = 2, Mob = "Desert Officer", PosQ = CFrame.new(894.488647, 5.14000702, 4392.43359), PosM = CFrame.new(1608.2822265625, 8.6142244338989, 4371.0073242188) },
	{ Min = 90, Max = 99, Quest = "SnowQuest", Id = 1, Mob = "Snow Bandit", PosQ = CFrame.new(1389.74451, 88.1519318, -1298.90796), PosM = CFrame.new(1354.3479003906, 87.272773742676, -1393.9465332031) },
	{ Min = 100, Max = 119, Quest = "SnowQuest", Id = 2, Mob = "Snowman", PosQ = CFrame.new(1389.74451, 88.1519318, -1298.90796), PosM = CFrame.new(1201.6412353516, 144.57958984375, -1550.0670166016) },
	{ Min = 120, Max = 149, Quest = "MarineQuest2", Id = 1, Mob = "Chief Petty Officer", PosQ = CFrame.new(-5039.58643, 27.3500385, 4324.68018), PosM = CFrame.new(-4881.2309570312, 22.652044296265, 4273.7524414062) },
	{ Min = 150, Max = 174, Quest = "SkyQuest", Id = 1, Mob = "Sky Bandit", PosQ = CFrame.new(-5406.29, 410.11, -694.04), PosM = CFrame.new(-5091.62, 280.72, -1019.22) },
	{ Min = 175, Max = 189, Quest = "SkyQuest", Id = 2, Mob = "Dark Master", PosQ = CFrame.new(-5406.29, 410.11, -694.04), PosM = CFrame.new(-5269.01, 504.98, -461.12) },
	{ Min = 190, Max = 209, Quest = "PrisonerQuest", Id = 1, Mob = "Prisoner", PosQ = CFrame.new(5308.93115, 1.65517521, 475.120514), PosM = CFrame.new(5098.9736328125, -0.3204058110714, 474.23733520508) },
	{ Min = 210, Max = 249, Quest = "PrisonerQuest", Id = 2, Mob = "Dangerous Prisoner", PosQ = CFrame.new(5308.93115, 1.65517521, 475.120514), PosM = CFrame.new(5654.5634765625, 15.633401870728, 866.29919433594) },
	{ Min = 250, Max = 274, Quest = "ColosseumQuest", Id = 1, Mob = "Toga Warrior", PosQ = CFrame.new(-1580.04663, 6.35000277, -2986.47534), PosM = CFrame.new(-1820.21484375, 51.683856964111, -2740.6650390625) },
	{ Min = 275, Max = 299, Quest = "ColosseumQuest", Id = 2, Mob = "Gladiator", PosQ = CFrame.new(-1580.04663, 6.35000277, -2986.47534), PosM = CFrame.new(-1292.8381347656, 56.380882263184, -3339.0314941406) },
	{ Min = 300, Max = 324, Quest = "MagmaQuest", Id = 1, Mob = "Military Soldier", PosQ = CFrame.new(-5313.37012, 10.9500084, 8515.29395), PosM = CFrame.new(-5411.1645507812, 11.081554412842, 8454.29296875) },
	{ Min = 325, Max = 374, Quest = "MagmaQuest", Id = 2, Mob = "Military Spy", PosQ = CFrame.new(-5313.37012, 10.9500084, 8515.29395), PosM = CFrame.new(-5802.8681640625, 86.262413024902, 8828.859375) },
	{ Min = 375, Max = 399, Quest = "FishmanQuest", Id = 1, Mob = "Fishman Warrior", PosQ = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734), PosM = CFrame.new(60878.30078125, 18.482830047607, 1543.7574462891) },
	{ Min = 400, Max = 449, Quest = "FishmanQuest", Id = 2, Mob = "Fishman Commando", PosQ = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734), PosM = CFrame.new(61922.6328125, 18.482830047607, 1493.9343261719) },
	{ Min = 450, Max = 474, Quest = "SkyExp1Quest", Id = 1, Mob = "God's Guard", PosQ = CFrame.new(-4721.88867, 843.874695, -1949.96643), PosM = CFrame.new(-4234.55, 1089.33, -267.37) },
	{ Min = 475, Max = 524, Quest = "SkyExp1Quest", Id = 2, Mob = "Shanda", PosQ = CFrame.new(-5949.0673828125, 5467.93994140625, 2086.51513671875), PosM = CFrame.new(-5950.41, 5470.0, 1800.0) },
	{ Min = 525, Max = 549, Quest = "SkyExp2Quest", Id = 1, Mob = "Royal Squad", PosQ = CFrame.new(-7033.1005859375, 5590.57421875, 1353.10693359375), PosM = CFrame.new(-6800.0, 5552.0, 1220.0) },
	{ Min = 550, Max = 624, Quest = "SkyExp2Quest", Id = 2, Mob = "Royal Soldier", PosQ = CFrame.new(-7033.1005859375, 5590.57421875, 1353.10693359375), PosM = CFrame.new(-7050.0, 5542.0, 930.0) },
	{ Min = 625, Max = 649, Quest = "FountainQuest", Id = 1, Mob = "Galley Pirate", PosQ = CFrame.new(5259.81982, 37.3500175, 4050.0293), PosM = CFrame.new(5551.0219726562, 78.901351928711, 3930.4128417969) },
	{ Min = 650, Max = 699, Quest = "FountainQuest", Id = 2, Mob = "Galley Captain", PosQ = CFrame.new(5259.81982, 37.3500175, 4050.0293), PosM = CFrame.new(5441.9516601562, 42.502059936523, 4950.09375) },
	{ Min = 700, Max = 724, Quest = "Area1Quest", Id = 1, Mob = "Raider", PosQ = CFrame.new(-429.543518, 71.7699966, 1836.18188), PosM = CFrame.new(-728.32672119141, 52.779319763184, 2345.7705078125) },
	{ Min = 725, Max = 774, Quest = "Area1Quest", Id = 2, Mob = "Mercenary", PosQ = CFrame.new(-429.543518, 71.7699966, 1836.18188), PosM = CFrame.new(-1004.3244018555, 80.158866882324, 1424.6193847656) },
	{ Min = 775, Max = 799, Quest = "Area2Quest", Id = 1, Mob = "Swan Pirate", PosQ = CFrame.new(638.43811, 71.769989, 918.282898), PosM = CFrame.new(1068.6643066406, 137.61428833008, 1322.1060791016) },
	{ Min = 800, Max = 874, Quest = "Area2Quest", Id = 2, Mob = "Factory Staff", PosQ = CFrame.new(632.698608, 73.1055908, 918.666321), PosM = CFrame.new(73.078674316406, 81.863441467285, -27.470672607422) },
	{ Min = 875, Max = 899, Quest = "MarineQuest3", Id = 1, Mob = "Marine Lieutenant", PosQ = CFrame.new(-2440.79639, 71.7140732, -3216.06812), PosM = CFrame.new(-2821.3723144531, 75.897277832031, -3070.0891113281) },
	{ Min = 900, Max = 949, Quest = "MarineQuest3", Id = 2, Mob = "Marine Captain", PosQ = CFrame.new(-2440.79639, 71.7140732, -3216.06812), PosM = CFrame.new(-1861.2310791016, 80.176582336426, -3254.6975097656) },
	{ Min = 950, Max = 974, Quest = "ZombieQuest", Id = 1, Mob = "Zombie", PosQ = CFrame.new(-5497.06152, 47.5923004, -795.237061), PosM = CFrame.new(-5657.7768554688, 78.969734191895, -928.68701171875) },
	{ Min = 975, Max = 999, Quest = "ZombieQuest", Id = 2, Mob = "Vampire", PosQ = CFrame.new(-5497.06152, 47.5923004, -795.237061), PosM = CFrame.new(-6037.66796875, 32.184638977051, -1340.6597900391) },
	{ Min = 1000, Max = 1049, Quest = "SnowMountainQuest", Id = 1, Mob = "Snow Trooper", PosQ = CFrame.new(609.858826, 400.119904, -5372.25928), PosM = CFrame.new(549.14733886719, 427.38705444336, -5563.6987304688) },
	{ Min = 1050, Max = 1099, Quest = "SnowMountainQuest", Id = 2, Mob = "Winter Warrior", PosQ = CFrame.new(609.858826, 400.119904, -5372.25928), PosM = CFrame.new(1142.7451171875, 475.63980102539, -5199.4165039062) },
	{ Min = 1100, Max = 1124, Quest = "IceSideQuest", Id = 1, Mob = "Lab Subordinate", PosQ = CFrame.new(-6064.06885, 15.2422857, -4902.97852), PosM = CFrame.new(-5707.4716796875, 15.951709747314, -4513.3920898438) },
	{ Min = 1125, Max = 1174, Quest = "IceSideQuest", Id = 2, Mob = "Horned Warrior", PosQ = CFrame.new(-6064.06885, 15.2422857, -4902.97852), PosM = CFrame.new(-6341.3666992188, 15.951770782471, -5723.162109375) },
	{ Min = 1175, Max = 1199, Quest = "FireSideQuest", Id = 1, Mob = "Magma Ninja", PosQ = CFrame.new(-5428.03174, 15.0622921, -5299.43457), PosM = CFrame.new(-5449.6728515625, 76.658744812012, -5808.2006835938) },
	{ Min = 1200, Max = 1249, Quest = "FireSideQuest", Id = 2, Mob = "Lava Pirate", PosQ = CFrame.new(-5428.03174, 15.0622921, -5299.43457), PosM = CFrame.new(-5213.3315429688, 49.737880706787, -4701.451171875) },
	{ Min = 1250, Max = 1274, Quest = "ShipQuest1", Id = 1, Mob = "Ship Deckhand", PosQ = CFrame.new(1037.80127, 125.092171, 32911.6016), PosM = CFrame.new(1212.0111083984, 150.79205322266, 33059.24609375) },
	{ Min = 1275, Max = 1299, Quest = "ShipQuest1", Id = 2, Mob = "Ship Engineer", PosQ = CFrame.new(1037.80127, 125.092171, 32911.6016), PosM = CFrame.new(919.47863769531, 43.544013977051, 32779.96875) },
	{ Min = 1300, Max = 1324, Quest = "ShipQuest2", Id = 1, Mob = "Ship Steward", PosQ = CFrame.new(968.80957, 125.092171, 33244.125), PosM = CFrame.new(919.43853759766, 129.55599975586, 33436.03515625) },
	{ Min = 1325, Max = 1349, Quest = "ShipQuest2", Id = 2, Mob = "Ship Officer", PosQ = CFrame.new(968.80957, 125.092171, 33244.125), PosM = CFrame.new(1036.0179443359, 181.4390411377, 33315.7265625) },
	{ Min = 1350, Max = 1374, Quest = "FrostQuest", Id = 1, Mob = "Arctic Warrior", PosQ = CFrame.new(5667.6582, 26.7997818, -6486.08984), PosM = CFrame.new(5966.24609375, 62.970020294189, -6179.3828125) },
	{ Min = 1375, Max = 1424, Quest = "FrostQuest", Id = 2, Mob = "Snow Lurker", PosQ = CFrame.new(5667.6582, 26.7997818, -6486.08984), PosM = CFrame.new(5407.0737304688, 69.194374084473, -6880.8803710938) },
	{ Min = 1425, Max = 1449, Quest = "ForgottenQuest", Id = 1, Mob = "Sea Soldier", PosQ = CFrame.new(-3054.44458, 235.544281, -10142.8193), PosM = CFrame.new(-3028.2236328125, 64.674514770508, -9775.4267578125) },
	{ Min = 1450, Max = 1499, Quest = "ForgottenQuest", Id = 2, Mob = "Water Fighter", PosQ = CFrame.new(-3054.44458, 235.544281, -10142.8193), PosM = CFrame.new(-3352.9013671875, 285.01556396484, -10534.841796875) },
	{ Min = 1500, Max = 1524, Quest = "PiratePortQuest", Id = 1, Mob = "Pirate Millionaire", PosQ = CFrame.new(-290.07, 42.9, 5581.59), PosM = CFrame.new(-246, 47.31, 5584.1) },
	{ Min = 1525, Max = 1574, Quest = "PiratePortQuest", Id = 2, Mob = "Pistol Billionaire", PosQ = CFrame.new(-290.07, 42.9, 5581.59), PosM = CFrame.new(-187.33, 86.24, 6013.51) },
	{ Min = 1575, Max = 1599, Quest = "DragonCrewQuest", Id = 1, Mob = "Dragon Crew Warrior", PosQ = CFrame.new(6737.06055, 127.417763, -712.300659), PosM = CFrame.new(6709.76367, 52.3442993, -1139.02966) },
	{ Min = 1600, Max = 1624, Quest = "DragonCrewQuest", Id = 2, Mob = "Dragon Crew Archer", PosQ = CFrame.new(6737.06055, 127.417763, -712.300659), PosM = CFrame.new(6668.76172, 481.376923, 329.12207) },
	{ Min = 1625, Max = 1649, Quest = "VenomCrewQuest", Id = 1, Mob = "Hydra Enforcer", PosQ = CFrame.new(5206.4018554688, 1004.1049804688, 748.35046386719), PosM = CFrame.new(4547.11523, 1003.10217, 334.194824) },
	{ Min = 1650, Max = 1699, Quest = "VenomCrewQuest", Id = 2, Mob = "Venomous Assailant", PosQ = CFrame.new(5206.4018554688, 1004.1049804688, 748.35046386719), PosM = CFrame.new(4674.92676, 1134.82654, 996.308838) },
	{ Min = 1700, Max = 1724, Quest = "MarineTreeIsland", Id = 1, Mob = "Marine Commodore", PosQ = CFrame.new(2180.54126, 27.8156815, -6741.5498), PosM = CFrame.new(2286.0078125, 73.133918762207, -7159.8090820312) },
	{ Min = 1725, Max = 1774, Quest = "MarineTreeIsland", Id = 2, Mob = "Marine Rear Admiral", PosQ = CFrame.new(2179.98828125, 28.731239318848, -6740.0551757813), PosM = CFrame.new(3656.7736816406, 160.52406311035, -7001.5986328125) },
	{ Min = 1775, Max = 1799, Quest = "DeepForestIsland3", Id = 1, Mob = "Fishman Raider", PosQ = CFrame.new(-10581.6563, 330.872955, -8761.18652), PosM = CFrame.new(-10407.526367188, 331.76263427734, -8368.5166015625) },
	{ Min = 1800, Max = 1824, Quest = "DeepForestIsland3", Id = 2, Mob = "Fishman Captain", PosQ = CFrame.new(-10581.6563, 330.872955, -8761.18652), PosM = CFrame.new(-10994.701171875, 352.38140869141, -9002.1103515625) },
	{ Min = 1825, Max = 1849, Quest = "DeepForestIsland", Id = 1, Mob = "Forest Pirate", PosQ = CFrame.new(-13234.04, 331.488495, -7625.40137), PosM = CFrame.new(-13274.478515625, 332.37814331055, -7769.5805664062) },
	{ Min = 1850, Max = 1899, Quest = "DeepForestIsland", Id = 2, Mob = "Mythological Pirate", PosQ = CFrame.new(-13234.04, 331.488495, -7625.40137), PosM = CFrame.new(-13680.607421875, 501.08154296875, -6991.189453125) },
	{ Min = 1900, Max = 1924, Quest = "DeepForestIsland2", Id = 1, Mob = "Jungle Pirate", PosQ = CFrame.new(-12680.3818, 389.971039, -9902.01953), PosM = CFrame.new(-12256.16015625, 331.73828125, -10485.836914062) },
	{ Min = 1925, Max = 1974, Quest = "DeepForestIsland2", Id = 2, Mob = "Musketeer Pirate", PosQ = CFrame.new(-12680.3818, 389.971039, -9902.01953), PosM = CFrame.new(-13457.904296875, 391.54565429688, -9859.177734375) },
	{ Min = 1975, Max = 1999, Quest = "HauntedQuest1", Id = 1, Mob = "Reborn Skeleton", PosQ = CFrame.new(-9479.2168, 141.215088, 5566.09277), PosM = CFrame.new(-8763.7236328125, 165.72299194336, 6159.8618164062) },
	{ Min = 2000, Max = 2024, Quest = "HauntedQuest1", Id = 2, Mob = "Living Zombie", PosQ = CFrame.new(-9479.2168, 141.215088, 5566.09277), PosM = CFrame.new(-10144.131835938, 138.6266784668, 5838.0888671875) },
	{ Min = 2025, Max = 2049, Quest = "HauntedQuest2", Id = 1, Mob = "Demonic Soul", PosQ = CFrame.new(-9516.99316, 172.017181, 6078.46533), PosM = CFrame.new(-9505.8720703125, 172.10482788086, 6158.9931640625) },
	{ Min = 2050, Max = 2074, Quest = "HauntedQuest2", Id = 2, Mob = "Posessed Mummy", PosQ = CFrame.new(-9516.99316, 172.017181, 6078.46533), PosM = CFrame.new(-9582.0224609375, 6.2515273094177, 6205.478515625) },
	{ Min = 2075, Max = 2099, Quest = "NutsIslandQuest", Id = 1, Mob = "Peanut Scout", PosQ = CFrame.new(-2104.3908691406, 38.104167938232, -10194.21875), PosM = CFrame.new(-2143.2419433594, 47.721984863281, -10029.995117188) },
	{ Min = 2100, Max = 2124, Quest = "NutsIslandQuest", Id = 2, Mob = "Peanut President", PosQ = CFrame.new(-2104.3908691406, 38.104167938232, -10194.21875), PosM = CFrame.new(-1859.3540039062, 38.103168487549, -10422.4296875) },
	{ Min = 2125, Max = 2149, Quest = "IceCreamIslandQuest", Id = 1, Mob = "Ice Cream Chef", PosQ = CFrame.new(-820.64825439453, 65.819526672363, -10965.795898438), PosM = CFrame.new(-872.24658203125, 65.81957244873, -10919.95703125) },
	{ Min = 2150, Max = 2199, Quest = "IceCreamIslandQuest", Id = 2, Mob = "Ice Cream Commander", PosQ = CFrame.new(-820.64825439453, 65.819526672363, -10965.795898438), PosM = CFrame.new(-558.06103515625, 112.04895782471, -11290.774414062) },
	{ Min = 2200, Max = 2224, Quest = "CakeQuest1", Id = 1, Mob = "Cookie Crafter", PosQ = CFrame.new(-2021.32007, 37.7982254, -12028.7295), PosM = CFrame.new(-2374.13671875, 37.798263549805, -12125.30859375) },
	{ Min = 2225, Max = 2249, Quest = "CakeQuest1", Id = 2, Mob = "Cake Guard", PosQ = CFrame.new(-2021.32007, 37.7982254, -12028.7295), PosM = CFrame.new(-1598.3070068359, 43.773197174072, -12244.581054688) },
	{ Min = 2250, Max = 2274, Quest = "CakeQuest2", Id = 1, Mob = "Baking Staff", PosQ = CFrame.new(-1927.91602, 37.7981339, -12842.5391), PosM = CFrame.new(-1887.8099365234, 77.618507385254, -12998.350585938) },
	{ Min = 2275, Max = 2299, Quest = "CakeQuest2", Id = 2, Mob = "Head Baker", PosQ = CFrame.new(-1927.91602, 37.7981339, -12842.5391), PosM = CFrame.new(-2216.1882324219, 82.884521484375, -12869.293945312) },
	{ Min = 2300, Max = 2324, Quest = "ChocQuest1", Id = 1, Mob = "Cocoa Warrior", PosQ = CFrame.new(233.22836303711, 29.876001358032, -12201.233398438), PosM = CFrame.new(-21.553283691406, 80.574996948242, -12352.387695312) },
	{ Min = 2325, Max = 2349, Quest = "ChocQuest1", Id = 2, Mob = "Chocolate Bar Battler", PosQ = CFrame.new(233.22836303711, 29.876001358032, -12201.233398438), PosM = CFrame.new(582.59057617188, 77.188095092773, -12463.162109375) },
	{ Min = 2350, Max = 2374, Quest = "ChocQuest2", Id = 1, Mob = "Sweet Thief", PosQ = CFrame.new(150.50663757324, 30.693693161011, -12774.502929688), PosM = CFrame.new(165.1884765625, 76.058853149414, -12600.836914062) },
	{ Min = 2375, Max = 2399, Quest = "ChocQuest2", Id = 2, Mob = "Candy Rebel", PosQ = CFrame.new(150.50663757324, 30.693693161011, -12774.502929688), PosM = CFrame.new(134.86563110352, 77.247680664062, -12876.547851562) },
	{ Min = 2400, Max = 2449, Quest = "CandyQuest1", Id = 1, Mob = "Candy Pirate", PosQ = CFrame.new(-1150.0400390625, 20.378934860229, -14446.334960938), PosM = CFrame.new(-1310.5003662109, 26.016523361206, -14562.404296875) },
	{ Min = 2450, Max = 2474, Quest = "TikiQuest1", Id = 1, Mob = "Isle Outlaw", PosQ = CFrame.new(-16548.8164, 55.6059914, -172.8125), PosM = CFrame.new(-16479.900390625, 226.6117401123, -300.31143188477) },
	{ Min = 2475, Max = 2499, Quest = "TikiQuest1", Id = 2, Mob = "Island Boy", PosQ = CFrame.new(-16548.8164, 55.6059914, -172.8125), PosM = CFrame.new(-16849.396484375, 192.86505126953, -150.78532409668) },
	{ Min = 2500, Max = 2524, Quest = "TikiQuest2", Id = 1, Mob = "Sun-kissed Warrior", PosQ = CFrame.new(-16538, 55, 1049), PosM = CFrame.new(-16347, 64, 984) },
	{ Min = 2525, Max = 2550, Quest = "TikiQuest2", Id = 2, Mob = "Isle Champion", PosQ = CFrame.new(-16541.0215, 57.3082275, 1051.46118), PosM = CFrame.new(-16602.1015625, 130.38734436035, 1087.2456054688) },
	{ Min = 2551, Max = 2574, Quest = "TikiQuest3", Id = 1, Mob = "Serpent Hunter", PosQ = CFrame.new(-16668.03, 105.32, 1568.6), PosM = CFrame.new(-16645.64, 163.09, 1352.87) },
	{ Min = 2575, Max = 2599, Quest = "TikiQuest3", Id = 2, Mob = "Skull Slayer", PosQ = CFrame.new(-16668.03, 105.32, 1568.6), PosM = CFrame.new(-16709.49, 419.68, 1751.09) },
	{ Min = 2600, Max = 2624, Quest = "SubmergedQuest1", Id = 1, Mob = "Reef Bandit", PosQ = CFrame.new(10778.875, -2087.72437, 9265.18359), PosM = CFrame.new(11019.1318, -2146.06812, 9342.3916) },
	{ Min = 2625, Max = 2649, Quest = "SubmergedQuest1", Id = 2, Mob = "Coral Pirate", PosQ = CFrame.new(10778.875, -2087.72437, 9265.18359), PosM = CFrame.new(10808.6006, -2030.36145, 9364.2334) },
	{ Min = 2650, Max = 2674, Quest = "SubmergedQuest2", Id = 1, Mob = "Sea Chanter", PosQ = CFrame.new(10880.6855, -2086.20044, 10032.624), PosM = CFrame.new(10671.2715, -2057.59155, 10047.2588) },
	{ Min = 2675, Max = 2699, Quest = "SubmergedQuest2", Id = 2, Mob = "Ocean Prophet", PosQ = CFrame.new(10880.6855, -2086.20044, 10032.624), PosM = CFrame.new(11008.5195, -2007.72839, 10223.0791) },
	{ Min = 2700, Max = 2724, Quest = "SubmergedQuest3", Id = 1, Mob = "High Disciple", PosQ = CFrame.new(9640.08789, -1992.44507, 9613.65234), PosM = CFrame.new(9750.41602, -1966.93884, 9753.36035) },
	{ Min = 2725, Max = 9999, Quest = "SubmergedQuest3", Id = 2, Mob = "Grand Devotee", PosQ = CFrame.new(9640.08789, -1992.44507, 9613.65234), PosM = CFrame.new(9611.70508, -1993.47119, 9882.68848) },
}

function Data.GetSea()
    local placeId = game.PlaceId
    if table.find(Data.Places.Sea1, placeId) then return 1
    elseif table.find(Data.Places.Sea2, placeId) then return 2
    elseif table.find(Data.Places.Sea3, placeId) then return 3 end
    return 1
end

function Data.GetQuest(lvl)
    lvl = tonumber(lvl) or 1
    local currentSea = Data.GetSea()
    if currentSea == 1 and lvl >= 700 then
        lvl = 650
    elseif currentSea == 2 and lvl >= 1500 then
        lvl = 1450
    end
    for _, q in ipairs(Data.Quests) do
        if lvl >= q.Min and lvl <= q.Max then
            return q
        end
    end
    local best = Data.Quests[1]
    for _, q in ipairs(Data.Quests) do
        if lvl >= q.Min then best = q else break end
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
    if pgui then
        local main = pgui:FindFirstChild("Main")
        if main then
            local qFrame = main:FindFirstChild("Quest")
            if qFrame and qFrame.Visible then
                return true
            end
        end
        local tqf = pgui:FindFirstChild("TrackedQuestFrame")
        if tqf and tqf.Enabled and tqf:FindFirstChild("Frame") then
            return true
        end
    end
    local guide = ReplicatedStorage:FindFirstChild("GuideModule")
    if guide then
        pcall(function()
            local g = require(guide)
            if g and g.Data and g.Data.QuestData then
                return true
            end
        end)
    end
    return false
end

-- ====================================================================
-- 9. BANANAHUB BACKGROUND SERVICES (FRUIT SNIPER, AUTO CHAT, HAKI)
-- ====================================================================

-- Auto Stat Allocator
task.spawn(function()
    while runtime.alive do
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
    while runtime.alive do
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
    while runtime.alive do
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
    while runtime.alive do
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

-- Synchronize with BananaHub "Get Items"
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
-- 11. COMPLETE ENDGAME QUESTS & RARE ITEMS ENGINE
-- Features: Valkyrie Helm, Mirror Fractal, CDK, Saber, Godhuman,
-- Soul Guitar, Pull Lever, Rengoku, Dragon Trident, Pole, Gravity Blade,
-- Shark Anchor, Auto Haki Buyer, and Intelligent Server Hopping.
-- ====================================================================

local SecretQuests = {
    AutoSaber = true,
    AutoValkyrie = true,
    AutoMirrorFractal = true,
    AutoYama = true,
    AutoTushita = true,
    AutoCDK = true,
    AutoSoulGuitar = true,
    AutoGodhuman = true,
    AutoPullLever = true,
    AutoSharkAnchor = true,
    AutoRengoku = false,
    AutoDragonTrident = false,
    AutoPole = false,
    AutoGravityBlade = false,
}

if GH["Get Items"] then
    SecretQuests.AutoSaber = GH["Get Items"]["Saber"] ~= false
    SecretQuests.AutoGodhuman = GH["Get Items"]["Godhuman"] ~= false
    SecretQuests.AutoSoulGuitar = (GH["Get Items"]["Skull Guitar"] or GH["Get Items"]["Soul Guitar"]) ~= false
    SecretQuests.AutoMirrorFractal = GH["Get Items"]["Mirror Fractal"] ~= false
    SecretQuests.AutoCDK = GH["Get Items"]["Cursed Dual Katana"] ~= false
    SecretQuests.AutoYama = GH["Get Items"]["Cursed Dual Katana"] ~= false
    SecretQuests.AutoTushita = GH["Get Items"]["Cursed Dual Katana"] ~= false
    SecretQuests.AutoPullLever = GH["Get Items"]["Auto Pull Lever"] ~= false
    SecretQuests.AutoSharkAnchor = GH["Get Items"]["Shark Anchor"] ~= false
end

if GH["Get Rare Items"] then
    SecretQuests.AutoRengoku = GH["Get Rare Items"]["Rengoku"] == true
    SecretQuests.AutoDragonTrident = GH["Get Rare Items"]["Dragon Trident"] == true
    SecretQuests.AutoPole = GH["Get Rare Items"]["Pole (1st Form)"] == true
    SecretQuests.AutoGravityBlade = GH["Get Rare Items"]["Gravity Blade"] == true
end

-- ====================================================================
-- INTELLIGENT SERVER HOPPER
-- ====================================================================
local VisitedServers = {}
local function HopServer(reason)
    HUDStatus = "Hopping Server: " .. tostring(reason or "Seeking Target")
    pcall(function()
        local placeId = game.PlaceId
        local serversUrl = string.format("https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Asc&limit=100", tostring(placeId))
        local response = game:HttpGet(serversUrl)
        local body = HttpService:JSONDecode(response)
        if body and body.data then
            for _, s in ipairs(body.data) do
                if s.playing and s.playing < s.maxPlayers - 1 and s.id ~= game.JobId and not VisitedServers[s.id] then
                    VisitedServers[s.id] = true
                    game:GetService("TeleportService"):TeleportToPlaceInstance(placeId, s.id, LocalPlayer)
                    task.wait(5)
                    return
                end
            end
        end
        game:GetService("TeleportService"):Teleport(placeId, LocalPlayer)
    end)
end

-- ====================================================================
-- AUTO BUY HAKI (BUSO, GEPPO, SORU, KEN)
-- ====================================================================
local function AutoBuyHaki()
    if not CommF or not GH["Buy Haki"] then return end
    pcall(function()
        local d = LocalPlayer:FindFirstChild("Data")
        local beli = d and d:FindFirstChild("Beli") and d.Beli.Value or 0
        local sea = Data.GetSea()

        if GH["Buy Haki"]["Enhancement"] and not HasItem("Buso") and beli >= 25000 then
            CommF:InvokeServer("BuyHaki", "Buso")
        end
        if GH["Buy Haki"]["Skyjump"] and not HasItem("Geppo") and beli >= 10000 then
            CommF:InvokeServer("BuyHaki", "Geppo")
        end
        if GH["Buy Haki"]["Flash Step"] and not HasItem("Soru") and beli >= 100000 then
            CommF:InvokeServer("BuyHaki", "Soru")
        end
        if GH["Buy Haki"]["Observation"] and not HasItem("Observation") and beli >= 750000 and sea == 1 then
            local lvl = d and d:FindFirstChild("Level") and d.Level.Value or 1
            if lvl >= 300 then
                CommF:InvokeServer("KenTalk", "Buy")
            end
        end
    end)
end

-- ====================================================================
-- 1. AUTO SABER QUEST (SEA 1 - FULL PUZZLE & SABER EXPERT)
-- ====================================================================
function SecretQuests.DoSaber()
    if not SecretQuests.AutoSaber or not CommF or Data.GetSea() ~= 1 or HasItem("Saber") then return false end
    local d = LocalPlayer:FindFirstChild("Data")
    local lvl = d and d:FindFirstChild("Level") and d.Level.Value or 1
    if lvl < 200 then return false end

    -- Check if Saber Expert is alive
    local saberExpert = Workspace:FindFirstChild("Enemies") and Workspace.Enemies:FindFirstChild("Saber Expert")
    if saberExpert and IsMobAlive(saberExpert) then
        local mRoot = saberExpert:FindFirstChild("HumanoidRootPart")
        if mRoot then
            HUDStatus = "Boss: Defeating Saber Expert [Unlocking Saber] ⚔️"
            toTarget(GetFarmCFrame(mRoot), 5)
            BringMob(saberExpert)
            EquipWeapon()
            return true
        end
    end

    -- Step 1: Jungle Plates (5 Buttons)
    local plates = {
        CFrame.new(-1612.56, 36.98, 148.72),
        CFrame.new(-1480.95, 23.51, 38.64),
        CFrame.new(-1390.87, 23.51, -112.58),
        CFrame.new(-1497.63, 23.51, -215.45),
        CFrame.new(-1645.24, 23.51, -195.42)
    }
    for _, plateCF in ipairs(plates) do
        toTarget(plateCF, 3)
        task.wait(0.2)
    end

    -- Step 2: Grab Torch & Burn Desert Door
    if not HasItem("Torch") and not HasItem("Cup") and not HasItem("Relic") then
        local torchHole = CFrame.new(-1610.01, 11.50, 164.00)
        toTarget(torchHole, 5)
        task.wait(0.5)
    end

    if HasItem("Torch") then
        local desertHouse = CFrame.new(1114.61, 5.05, 4350.23)
        toTarget(desertHouse, 5)
        EquipWeapon()
        task.wait(0.5)
    end

    -- Step 3: Fill Cup at Frozen Village & Help Sick Man
    if HasItem("Cup") then
        local icicleCave = CFrame.new(1398.54, 37.35, -1320.12)
        toTarget(icicleCave, 5)
        pcall(function() CommF:InvokeServer("ProQuestProgress", "FillCup", LocalPlayer.Character.Cup) end)
        task.wait(0.5)
        local sickMan = CFrame.new(1390.95, 37.35, -1350.50)
        toTarget(sickMan, 5)
        pcall(function() CommF:InvokeServer("ProQuestProgress", "SickMan") end)
        task.wait(0.5)
    end

    -- Step 4: Mob Leader & Relic
    local richSonProgress = CommF:InvokeServer("ProQuestProgress", "RichSon")
    if richSonProgress == 0 then
        local mobLeader = Workspace:FindFirstChild("Enemies") and Workspace.Enemies:FindFirstChild("Mob Leader")
        if mobLeader and IsMobAlive(mobLeader) then
            local mRoot = mobLeader:FindFirstChild("HumanoidRootPart")
            if mRoot then
                HUDStatus = "Boss: Defeating Mob Leader [Saber Quest] ⚔️"
                toTarget(GetFarmCFrame(mRoot), 5)
                BringMob(mobLeader)
                EquipWeapon()
                return true
            end
        else
            toTarget(CFrame.new(-2967.60, -4.91, 5328.71), 5)
            return true
        end
    elseif richSonProgress == 1 then
        pcall(function() CommF:InvokeServer("ProQuestProgress", "RichSon") end)
        task.wait(0.5)
    end

    -- Step 5: Insert Relic into Jungle Altar
    if HasItem("Relic") then
        local jungleAltar = CFrame.new(-1404.92, 29.98, 3.81)
        toTarget(jungleAltar, 5)
        pcall(function() CommF:InvokeServer("ProQuestProgress", "PlaceRelic") end)
        task.wait(0.5)
        return true
    end

    return false
end

-- ====================================================================
-- 2. AUTO VALKYRIE HELM & AUTO SUMMON RIP INDRA (SEA 3)
-- ====================================================================
function SecretQuests.DoValkyrieHelm()
    if not SecretQuests.AutoValkyrie or not CommF or Data.GetSea() ~= 3 or HasItem("Valkyrie Helm") then return false end

    -- Check if rip_indra True Form is alive
    local indra = Workspace:FindFirstChild("Enemies") and (Workspace.Enemies:FindFirstChild("rip_indra True Form") or Workspace.Enemies:FindFirstChild("rip_indra"))
    if indra and IsMobAlive(indra) then
        local mRoot = indra:FindFirstChild("HumanoidRootPart")
        if mRoot then
            HUDStatus = "Boss: Defeating rip_indra True Form [Valkyrie Helm / Tushita] 👑"
            toTarget(GetFarmCFrame(mRoot), 5)
            BringMob(indra)
            EquipWeapon()
            return true
        end
    end

    -- Summon with God's Chalice if Auto Summon Rip Indra is true
    if GH["Auto Summon Rip Indra"] and HasItem("God's Chalice") then
        HUDStatus = "Summoning rip_indra with God's Chalice at Castle on the Sea..."
        local indraAltar = CFrame.new(-5556.77, 313.79, -2988.49)
        toTarget(indraAltar, 5)
        local chaliceTool = LocalPlayer.Backpack:FindFirstChild("God's Chalice")
        if chaliceTool then
            chaliceTool.Parent = LocalPlayer.Character
        end
        task.wait(0.5)
        return true
    end

    -- Server Hop if configured
    if GH["Select Hop"] and GH["Select Hop"]["Hop Find Rip Indra Get Valkyrie Helm or Get Tushita"] and not indra and not HasItem("God's Chalice") then
        HopServer("Finding rip_indra for Valkyrie Helm / Tushita")
        return true
    end

    return false
end

-- ====================================================================
-- 3. AUTO DOUGH KING & MIRROR FRACTAL (SEA 3)
-- ====================================================================
function SecretQuests.DoMirrorFractal()
    if not SecretQuests.AutoMirrorFractal or not CommF or Data.GetSea() ~= 3 or HasItem("Mirror Fractal") then return false end

    -- Check if Dough King is alive
    local doughKing = Workspace:FindFirstChild("Enemies") and Workspace.Enemies:FindFirstChild("Dough King")
    if doughKing and IsMobAlive(doughKing) then
        local mRoot = doughKing:FindFirstChild("HumanoidRootPart")
        if mRoot then
            HUDStatus = "Boss: Defeating Dough King [Mirror Fractal] 🍩"
            toTarget(GetFarmCFrame(mRoot), 5)
            BringMob(doughKing)
            EquipWeapon()
            return true
        end
    end

    -- Summon Dough King if player has Sweet Chalice
    if HasItem("Sweet Chalice") then
        HUDStatus = "Summoning Dough King with Sweet Chalice at Cake Island..."
        local spawnerCF = CFrame.new(-2091.22, 70.01, -12143.08)
        toTarget(spawnerCF, 5)
        pcall(function() CommF:InvokeServer("CakePrinceSpawner") end)
        task.wait(1)
        return true
    end

    -- Craft Sweet Chalice with God's Chalice & 10 Cocoa
    if HasItem("God's Chalice") then
        pcall(function() CommF:InvokeServer("CakePrinceSpawner", "CraftSweetChalice") end)
        task.wait(0.5)
    end

    -- Server Hop if configured
    if GH["Select Hop"] and GH["Select Hop"]["Hop Find Dough King Get Mirror Fractal"] and not doughKing and not HasItem("Sweet Chalice") and not HasItem("God's Chalice") then
        HopServer("Finding Dough King for Mirror Fractal")
        return true
    end

    return false
end

-- ====================================================================
-- 4. AUTO CURSED DUAL KATANA (YAMA, TUSHITA, CDK TRIALS)
-- ====================================================================
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
                        HUDStatus = string.format("CDK: Hunting Elite %s (%d/30 kills)", name, eliteKills)
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
        HUDStatus = "CDK: 30 Elites Killed! Pulling Yama at Waterfall Temple..."
        local sealedKatana = Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("Waterfall") and Workspace.Map.Waterfall:FindFirstChild("SealedKatana")
        if sealedKatana then
            local cd = sealedKatana:FindFirstChild("Hitbox") and sealedKatana.Hitbox:FindFirstChildOfClass("ClickDetector")
            if cd and typeof(fireclickdetector) == "function" then
                fireclickdetector(cd)
            end
            return true
        else
            toTarget(CFrame.new(5251.90, 17.18, 453.60), 5)
            return true
        end
    end
end

function SecretQuests.DoTushita()
    if not SecretQuests.AutoTushita or not CommF or Data.GetSea() ~= 3 or HasItem("Tushita") then return false end

    -- Check if Longma is alive
    local longma = Workspace:FindFirstChild("Enemies") and Workspace.Enemies:FindFirstChild("Longma")
    if longma and IsMobAlive(longma) then
        local mRoot = longma:FindFirstChild("HumanoidRootPart")
        if mRoot then
            HUDStatus = "Boss: Defeating Longma [Unlocking Tushita] 🗡️"
            toTarget(GetFarmCFrame(mRoot), 5)
            BringMob(longma)
            EquipWeapon()
            return true
        end
    end

    -- If Rip Indra is alive, enter Waterfall secret door for 5 torches
    local ripIndra = Workspace:FindFirstChild("Enemies") and (Workspace.Enemies:FindFirstChild("rip_indra True Form") or Workspace.Enemies:FindFirstChild("rip_indra"))
    if ripIndra and IsMobAlive(ripIndra) then
        HUDStatus = "CDK: Rip Indra Active! Entering Waterfall Door for Tushita..."
        toTarget(CFrame.new(5251.90, 17.18, 453.60), 5)
        return true
    end

    return false
end

function SecretQuests.DoCDK()
    if not SecretQuests.AutoCDK or not CommF or Data.GetSea() ~= 3 or HasItem("Cursed Dual Katana") then return false end
    if not HasItem("Yama") or not HasItem("Tushita") then return false end

    -- Check if Soul Reaper / Cake Queen are alive for CDK trials
    local soulReaper = Workspace:FindFirstChild("Enemies") and Workspace.Enemies:FindFirstChild("Soul Reaper")
    if soulReaper and IsMobAlive(soulReaper) then
        local mRoot = soulReaper:FindFirstChild("HumanoidRootPart")
        if mRoot then
            HUDStatus = "CDK Trial: Engaging Soul Reaper Boss! ☠️"
            toTarget(GetFarmCFrame(mRoot), 5)
            BringMob(soulReaper)
            EquipWeapon()
            return true
        end
    end

    local cakeQueen = Workspace:FindFirstChild("Enemies") and Workspace.Enemies:FindFirstChild("Cake Queen")
    if cakeQueen and IsMobAlive(cakeQueen) then
        local mRoot = cakeQueen:FindFirstChild("HumanoidRootPart")
        if mRoot then
            HUDStatus = "CDK Trial: Engaging Cake Queen Boss! 👑"
            toTarget(GetFarmCFrame(mRoot), 5)
            BringMob(cakeQueen)
            EquipWeapon()
            return true
        end
    end

    -- CDK Crypt Master at Floating Turtle
    HUDStatus = "CDK Quest: Talking to Crypt Master & Progressing Trials..."
    local cdkNPC = CFrame.new(-12061.27, 332.12, -7534.50)
    toTarget(cdkNPC, 5)
    pcall(function()
        CommF:InvokeServer("CDKQuest", "StartTrial", "Good")
        CommF:InvokeServer("CDKQuest", "StartTrial", "Evil")
        CommF:InvokeServer("CDKQuest", "OpenDoor")
    end)
    return true
end

-- ====================================================================
-- 5. AUTO GODHUMAN (SEA 3 - MASTERY & ANCIENT MONK)
-- ====================================================================
function SecretQuests.DoGodhuman()
    if not SecretQuests.AutoGodhuman or not CommF or Data.GetSea() ~= 3 or HasItem("Godhuman") or HasItem("GodHuman") then return false end
    local monkCheck = nil
    pcall(function() monkCheck = CommF:InvokeServer("BuyGodhuman", true) end)
    if monkCheck == 3 then return false end -- Already owned

    local d = LocalPlayer:FindFirstChild("Data")
    local beli = d and d:FindFirstChild("Beli") and d.Beli.Value or 0
    local frags = d and d:FindFirstChild("Fragments") and d.Fragments.Value or 0

    if beli >= 5000000 and frags >= 5000 then
        HUDStatus = "Godhuman: Visiting Ancient Monk to Unlock Godhuman! 🥋"
        local monkTree = CFrame.new(-11015.82, 332.18, -10041.83)
        toTarget(monkTree, 5)
        pcall(function() CommF:InvokeServer("BuyGodhuman") end)
        task.wait(1)
        return true
    end
    return false
end

-- ====================================================================
-- 6. AUTO SOUL GUITAR (SEA 3 - HAUNTED CASTLE & FULL MOON)
-- ====================================================================
function SecretQuests.DoSoulGuitar()
    if not SecretQuests.AutoSoulGuitar or not CommF or Data.GetSea() ~= 3 or HasItem("Soul Guitar") or HasItem("Skull Guitar") then return false end
    local d = LocalPlayer:FindFirstChild("Data")
    if not d or not d:FindFirstChild("Level") or d.Level.Value < 2300 then return false end

    -- Check if Darkbeard is alive for Dark Fragment
    local darkbeard = Workspace:FindFirstChild("Enemies") and Workspace.Enemies:FindFirstChild("Darkbeard")
    if darkbeard and IsMobAlive(darkbeard) then
        local mRoot = darkbeard:FindFirstChild("HumanoidRootPart")
        if mRoot then
            HUDStatus = "Boss: Defeating Darkbeard [Dark Fragment for Soul Guitar] 🌌"
            toTarget(GetFarmCFrame(mRoot), 5)
            BringMob(darkbeard)
            EquipWeapon()
            return true
        end
    end

    if IsNight() then
        HUDStatus = "Soul Guitar: Praying at Haunted Castle Gravestone..."
        local graveCF = CFrame.new(-9515.00, 142.00, 5535.00)
        toTarget(graveCF, 5)
        pcall(function() CommF:InvokeServer("Gravstone", "Pray") end)
        task.wait(0.5)
        pcall(function() CommF:InvokeServer("SoulGuitar", "Craft") end)
        return true
    end

    if GH["Select Hop"] and GH["Select Hop"]["Hop Find Darkbeard [SG]"] and not darkbeard and not HasItem("Dark Fragment") then
        HopServer("Finding Darkbeard for Soul Guitar Dark Fragment")
        return true
    end

    return false
end

-- ====================================================================
-- 7. AUTO PULL LEVER & RACE V4 MIRAGE ISLAND (SEA 3)
-- ====================================================================
function SecretQuests.DoPullLever()
    if not SecretQuests.AutoPullLever or not CommF or Data.GetSea() ~= 3 then return false end

    -- Check if Temple of Time Lever is already pulled
    local m = Workspace:FindFirstChild("Map")
    local tot = m and m:FindFirstChild("Temple of Time")
    local lever = tot and tot:FindFirstChild("Lever")
    if lever then
        return false -- Lever already unlocked & available
    end

    -- Check Mirage Island
    local mirage = Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("MysticIsland")
    if mirage then
        HUDStatus = "Race V4: Mirage Island Active! Resonating with Moon & Finding Gear 🌙"
        local peak = CFrame.new(mirage:GetPivot().Position + Vector3.new(0, 180, 0))
        toTarget(peak, 5)
        -- Activate Race V3 ability
        pcall(function()
            local v = VirtualInputManager
            if v then v:SendKeyEvent(true, Enum.KeyCode.T, false, game) task.wait(0.1) v:SendKeyEvent(false, Enum.KeyCode.T, false, game) end
        end)
        task.wait(1)
        return true
    end

    -- Visit Temple of Time and pull lever if unlocked
    local templeRoom = CFrame.new(28282.57, 14896.85, 105.10)
    toTarget(templeRoom, 5)
    local pPrompt = Workspace:FindFirstChild("ProximityPrompt", true)
    if pPrompt and typeof(fireproximityprompt) == "function" then
        fireproximityprompt(pPrompt, 1)
    end
    return true
end

-- ====================================================================
-- 8. AUTO RARE ITEMS (RENGOKU, DRAGON TRIDENT, POLE, GRAVITY BLADE, SHARK ANCHOR)
-- ====================================================================
function SecretQuests.DoRareItems()
    local sea = Data.GetSea()

    -- 1. Rengoku (Sea 2)
    if SecretQuests.AutoRengoku and sea == 2 and not HasItem("Rengoku") then
        if HasItem("Hidden Key") then
            HUDStatus = "Rengoku: Unlocking Secret Chest with Hidden Key at Ice Castle! 🗝️"
            local chestCF = CFrame.new(6508.56, 296.81, -6969.34)
            toTarget(chestCF, 5)
            task.wait(0.5)
            return true
        end
        local iceBoss = Workspace:FindFirstChild("Enemies") and (Workspace.Enemies:FindFirstChild("Awakened Ice Admiral") or Workspace.Enemies:FindFirstChild("Arctic Warrior"))
        if iceBoss and IsMobAlive(iceBoss) then
            local mRoot = iceBoss:FindFirstChild("HumanoidRootPart")
            if mRoot then
                HUDStatus = "Rare Item: Farming Ice Admiral for Rengoku Hidden Key ❄️"
                toTarget(GetFarmCFrame(mRoot), 5)
                BringMob(iceBoss)
                EquipWeapon()
                return true
            end
        end
    end

    -- 2. Dragon Trident (Sea 3 - Island Empress)
    if SecretQuests.AutoDragonTrident and sea == 3 and not HasItem("Dragon Trident") then
        local empress = Workspace:FindFirstChild("Enemies") and Workspace.Enemies:FindFirstChild("Island Empress")
        if empress and IsMobAlive(empress) then
            local mRoot = empress:FindFirstChild("HumanoidRootPart")
            if mRoot then
                HUDStatus = "Rare Item: Hunting Island Empress for Dragon Trident 🔱"
                toTarget(GetFarmCFrame(mRoot), 5)
                BringMob(empress)
                EquipWeapon()
                return true
            end
        end
    end

    -- 3. Pole 1st Form (Sea 1 - Thunder God)
    if SecretQuests.AutoPole and sea == 1 and not HasItem("Pole (1st Form)") then
        local thunder = Workspace:FindFirstChild("Enemies") and Workspace.Enemies:FindFirstChild("Thunder God")
        if thunder and IsMobAlive(thunder) then
            local mRoot = thunder:FindFirstChild("HumanoidRootPart")
            if mRoot then
                HUDStatus = "Rare Item: Hunting Thunder God for Pole (1st Form) ⚡"
                toTarget(GetFarmCFrame(mRoot), 5)
                BringMob(thunder)
                EquipWeapon()
                return true
            end
        end
    end

    -- 4. Gravity Blade (Sea 2 - Fajita)
    if SecretQuests.AutoGravityBlade and sea == 2 and not HasItem("Gravity Blade") then
        local fajita = Workspace:FindFirstChild("Enemies") and Workspace.Enemies:FindFirstChild("Fajita")
        if fajita and IsMobAlive(fajita) then
            local mRoot = fajita:FindFirstChild("HumanoidRootPart")
            if mRoot then
                HUDStatus = "Rare Item: Hunting Fajita for Gravity Blade 🌌"
                toTarget(GetFarmCFrame(mRoot), 5)
                BringMob(fajita)
                EquipWeapon()
                return true
            end
        end
    end

    -- 5. Shark Anchor (Sea 3 - Terror Shark)
    if SecretQuests.AutoSharkAnchor and sea == 3 and not HasItem("Shark Anchor") then
        local terrorShark = Workspace:FindFirstChild("Enemies") and Workspace.Enemies:FindFirstChild("Terror Shark")
        if terrorShark and IsMobAlive(terrorShark) then
            local mRoot = terrorShark:FindFirstChild("HumanoidRootPart")
            if mRoot then
                HUDStatus = "Endgame: Hunting 195k HP Terror Shark for Shark Anchor ⚓"
                toTarget(GetFarmCFrame(mRoot), 5)
                BringMob(terrorShark)
                EquipWeapon()
                return true
            end
        end
    end

    return false
end

-- ====================================================================
-- MASTER ENDGAME QUEST STEPPER
-- Runs each quest in optimal progression priority
-- ====================================================================
function SecretQuests.Step()
    AutoBuyHaki()

    -- Sea 1 Quests
    if SecretQuests.DoSaber() then return true end

    -- Sea 3 Quests & Bosses
    if SecretQuests.DoValkyrieHelm() then return true end
    if SecretQuests.DoMirrorFractal() then return true end
    if SecretQuests.DoYama() then return true end
    if SecretQuests.DoTushita() then return true end
    if SecretQuests.DoCDK() then return true end
    if SecretQuests.DoGodhuman() then return true end
    if SecretQuests.DoSoulGuitar() then return true end
    if SecretQuests.DoPullLever() then return true end

    -- Rare Weapons
    if SecretQuests.DoRareItems() then return true end

    return false
end


-- ====================================================================
-- AUTO BLOX FRUITS DLC CODE REDEEMER (2x EXP, STAT RESETS, BELI)
-- ====================================================================
local BF_CODES = {
    "SUB2GAMERROBOT_EXP1",
    "SUB2GAMERROBOT_RESET1",
    "EASTEREXP",
    "LIGHTNINGABUSE",
    "KITT_RESET",
    "Sub2UncleKizaru",
    "Fudd10",
    "fudd10_v2",
    "Bignews",
    "Axiore",
    "Bluxxy",
    "Enyu_is_Pro",
    "JCWK",
    "Kittgaming",
    "Magicbus",
    "Starcodeheo",
    "StrawHatMaine",
    "Sub2CaptainMaui",
    "Sub2Daigrock",
    "Sub2Fer999",
    "Sub2NoobMaster123",
    "Sub2OfficialNoobie",
    "TantaiGaming",
    "TheGreatAce",
    "CHANDLER"
}

local function RedeemAllDLCCodes()
    task.spawn(function()
        local remotes = ReplicatedStorage:WaitForChild("Remotes", 5)
        local redeemRemote = remotes and remotes:FindFirstChild("Redeem")
        if not redeemRemote then return end
        for _, code in ipairs(BF_CODES) do
            pcall(function()
                HUDStatus = "Redeeming DLC Code: " .. code
                redeemRemote:InvokeServer(code)
            end)
            task.wait(0.35)
        end
        HUDStatus = "All DLC Codes Redeemed!"
        task.wait(1)
    end)
end


-- ====================================================================
-- 12. STATS CHECKER HUD & FLOATING TOGGLE (MATCHING TEDDY HUB LAYOUT)
-- ====================================================================
local HUDStatus = "Starting up..."
local HUDSubStatus = "Black Leg: beli"
local UI_Visible = true

local function FormatNumber(n)
    local num = tonumber(n) or 0
    local left, center, right = string.match(tostring(num), '^([^%d]*%d)(%d*)(.-)$')
    if not left then return tostring(num) end
    return left .. (center:reverse():gsub('(%d%d%d)', '%1,'):reverse()) .. right
end

local function GetSafeGuiParent()
    local success, target = pcall(function() return CoreGui end)
    if success and target then return target end
    return LocalPlayer:WaitForChild("PlayerGui")
end

-- Inventory & Milestone Checking Helpers
local InventoryCache = {}
local LastInvCheck = 0
local function UpdateInventoryCache()
    if tick() - LastInvCheck > 2.5 then
        LastInvCheck = tick()
        pcall(function()
            local comm = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if comm then
                local res = comm:InvokeServer("getInventory")
                if type(res) == "table" then
                    InventoryCache = {}
                    for _, item in ipairs(res) do
                        if item.Name then
                            InventoryCache[item.Name] = true
                        end
                    end
                end
            end
        end)
    end
end

local function CheckItemOwned(name)
    pcall(UpdateInventoryCache)
    if LocalPlayer.Backpack:FindFirstChild(name) then return true end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild(name) then return true end
    if InventoryCache[name] then return true end
    if name == "GodHuman" or name == "Godhuman" then
        if InventoryCache["Godhuman"] or InventoryCache["GodHuman"] then return true end
        local r = nil
        pcall(function()
            r = ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyGodhuman", true)
        end)
        if r == 3 then return true end
    elseif name == "Skull Guitar" or name == "Soul Guitar" then
        if InventoryCache["Soul Guitar"] or InventoryCache["Skull Guitar"] then return true end
    end
    return false
end

local function CheckPullLeverStatus()
    local sea = Data.GetSea()
    if sea < 3 then
        return "LOCKED"
    end
    local m = Workspace:FindFirstChild("Map")
    local tot = m and m:FindFirstChild("Temple of Time")
    local lever = tot and tot:FindFirstChild("Lever")
    if lever then
        return "DONE"
    end
    return "PENDING"
end

local function MakeDraggable(guiObject, clickCallback)
    local dragging = false
    local dragInput, dragStart, startPos
    local hasMoved = false

    guiObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            hasMoved = false
            dragStart = input.Position
            startPos = guiObject.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    if not hasMoved and clickCallback then
                        clickCallback()
                    end
                end
            end)
        end
    end)

    guiObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            if math.abs(delta.X) > 4 or math.abs(delta.Y) > 4 then
                hasMoved = true
            end
            guiObject.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

local function CreateHUD()
    if GH["Hide UI"] then return end
    pcall(function()
        local parent = GetSafeGuiParent()
        local sg = Instance.new("ScreenGui")
        sg.Name = "BananaKaitunStatsHUD"
        sg.ResetOnSpawn = false
        sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

        -- 1. FLOATING TOGGLE BUTTON (Left side circular toggle)
        local floatBtn = Instance.new("Frame")
        floatBtn.Name = "FloatingToggle"
        floatBtn.Size = UDim2.new(0, 52, 0, 52)
        floatBtn.Position = UDim2.new(0, 20, 0.28, 0)
        floatBtn.BackgroundColor3 = Color3.fromRGB(15, 12, 24)
        floatBtn.BorderSizePixel = 0
        floatBtn.Active = true
        floatBtn.Parent = sg

        local floatCorner = Instance.new("UICorner")
        floatCorner.CornerRadius = UDim.new(1, 0)
        floatCorner.Parent = floatBtn

        local floatStroke = Instance.new("UIStroke")
        floatStroke.Color = Color3.fromRGB(250, 195, 35)
        floatStroke.Thickness = 2.5
        floatStroke.Parent = floatBtn

        local floatIcon = Instance.new("TextLabel")
        floatIcon.Size = UDim2.new(1, 0, 1, 0)
        floatIcon.BackgroundTransparency = 1
        floatIcon.Text = "🍌"
        floatIcon.TextSize = 26
        floatIcon.Font = Enum.Font.GothamBold
        floatIcon.TextColor3 = Color3.fromRGB(245, 185, 30)
        floatIcon.Parent = floatBtn

        -- 2. MAIN STATS CHECKER WINDOW
        local main = Instance.new("Frame")
        main.Name = "MainFrame"
        main.AnchorPoint = Vector2.new(0.5, 0.5)
        main.Size = UDim2.new(0, 560, 0, 330)
        main.Position = UDim2.new(0.5, 0, 0.5, 0)
        main.BackgroundColor3 = Color3.fromRGB(16, 14, 24)
        main.BackgroundTransparency = 0.15
        main.BorderSizePixel = 0
        main.Active = true
        main.Parent = sg

        local mainCorner = Instance.new("UICorner")
        mainCorner.CornerRadius = UDim.new(0, 12)
        mainCorner.Parent = main

        local mainStroke = Instance.new("UIStroke")
        mainStroke.Color = Color3.fromRGB(250, 195, 35)
        mainStroke.Thickness = 2
        mainStroke.Parent = main

        -- Top Header: <Sea> & Title
        local seaTitle = Instance.new("TextLabel")
        seaTitle.Name = "SeaTitle"
        seaTitle.Size = UDim2.new(1, 0, 0, 22)
        seaTitle.Position = UDim2.new(0, 0, 0, 10)
        seaTitle.BackgroundTransparency = 1
        seaTitle.Text = "<Sea 1>"
        seaTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        seaTitle.Font = Enum.Font.GothamBold
        seaTitle.TextSize = 18
        seaTitle.TextXAlignment = Enum.TextXAlignment.Center
        seaTitle.Parent = main

        local subTitle = Instance.new("TextLabel")
        subTitle.Name = "SubTitle"
        subTitle.Size = UDim2.new(1, 0, 0, 18)
        subTitle.Position = UDim2.new(0, 0, 0, 32)
        subTitle.BackgroundTransparency = 1
        subTitle.Text = "Banana Hub Stats Checker"
        subTitle.TextColor3 = Color3.fromRGB(250, 195, 35)
        subTitle.Font = Enum.Font.GothamBold
        subTitle.TextSize = 15
        subTitle.TextXAlignment = Enum.TextXAlignment.Center
        subTitle.Parent = main

        -- Top Divider Line
        local div1 = Instance.new("Frame")
        div1.Name = "Divider1"
        div1.Size = UDim2.new(0.92, 0, 0, 1.5)
        div1.Position = UDim2.new(0.04, 0, 0, 56)
        div1.BackgroundColor3 = Color3.fromRGB(190, 190, 200)
        div1.BorderSizePixel = 0
        div1.Parent = main

        -- Dynamic Status Banner (Tween To Mob Spawn / Action)
        local actionLabel = Instance.new("TextLabel")
        actionLabel.Name = "ActionLabel"
        actionLabel.Size = UDim2.new(0.92, 0, 0, 18)
        actionLabel.Position = UDim2.new(0.04, 0, 0, 60)
        actionLabel.BackgroundTransparency = 1
        actionLabel.Text = "Tween To Mob Spawn [Sky Bandit]"
        actionLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
        actionLabel.Font = Enum.Font.GothamMedium
        actionLabel.TextSize = 12
        actionLabel.TextXAlignment = Enum.TextXAlignment.Center
        actionLabel.Parent = main

        local subActionLabel = Instance.new("TextLabel")
        subActionLabel.Name = "SubActionLabel"
        subActionLabel.Size = UDim2.new(0.92, 0, 0, 16)
        subActionLabel.Position = UDim2.new(0.04, 0, 0, 78)
        subActionLabel.BackgroundTransparency = 1
        subActionLabel.Text = "Black Leg: beli"
        subActionLabel.TextColor3 = Color3.fromRGB(240, 210, 100)
        subActionLabel.Font = Enum.Font.Gotham
        subActionLabel.TextSize = 11
        subActionLabel.TextXAlignment = Enum.TextXAlignment.Center
        subActionLabel.Parent = main

        -- MIDDLE TWO-COLUMN STATS GRID
        -- Left Column: Account Stats
        local accStatsHeader = Instance.new("TextLabel")
        accStatsHeader.Size = UDim2.new(0.4, 0, 0, 20)
        accStatsHeader.Position = UDim2.new(0.08, 0, 0, 98)
        accStatsHeader.BackgroundTransparency = 1
        accStatsHeader.Text = "Account Stats"
        accStatsHeader.TextColor3 = Color3.fromRGB(250, 195, 35)
        accStatsHeader.Font = Enum.Font.GothamBold
        accStatsHeader.TextSize = 14
        accStatsHeader.TextXAlignment = Enum.TextXAlignment.Left
        accStatsHeader.Parent = main

        local levelLabel = Instance.new("TextLabel")
        levelLabel.Name = "LevelLabel"
        levelLabel.Size = UDim2.new(0.4, 0, 0, 20)
        levelLabel.Position = UDim2.new(0.08, 0, 0, 126)
        levelLabel.BackgroundTransparency = 1
        levelLabel.Text = "Level: 10"
        levelLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        levelLabel.Font = Enum.Font.GothamBold
        levelLabel.TextSize = 14
        levelLabel.TextXAlignment = Enum.TextXAlignment.Left
        levelLabel.Parent = main

        local raceLabel = Instance.new("TextLabel")
        raceLabel.Name = "RaceLabel"
        raceLabel.Size = UDim2.new(0.4, 0, 0, 20)
        raceLabel.Position = UDim2.new(0.08, 0, 0, 154)
        raceLabel.BackgroundTransparency = 1
        raceLabel.Text = "Race: Human"
        raceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        raceLabel.Font = Enum.Font.GothamBold
        raceLabel.TextSize = 14
        raceLabel.TextXAlignment = Enum.TextXAlignment.Left
        raceLabel.Parent = main

        local beliLabel = Instance.new("TextLabel")
        beliLabel.Name = "BeliLabel"
        beliLabel.Size = UDim2.new(0.4, 0, 0, 20)
        beliLabel.Position = UDim2.new(0.08, 0, 0, 182)
        beliLabel.BackgroundTransparency = 1
        beliLabel.Text = "Beli: 2,128"
        beliLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        beliLabel.Font = Enum.Font.GothamBold
        beliLabel.TextSize = 14
        beliLabel.TextXAlignment = Enum.TextXAlignment.Left
        beliLabel.Parent = main

        local fragLabel = Instance.new("TextLabel")
        fragLabel.Name = "FragLabel"
        fragLabel.Size = UDim2.new(0.4, 0, 0, 20)
        fragLabel.Position = UDim2.new(0.08, 0, 0, 210)
        fragLabel.BackgroundTransparency = 1
        fragLabel.Text = "Frag: 0"
        fragLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        fragLabel.Font = Enum.Font.GothamBold
        fragLabel.TextSize = 14
        fragLabel.TextXAlignment = Enum.TextXAlignment.Left
        fragLabel.Parent = main

        -- Right Column: Account Items
        local accItemsHeader = Instance.new("TextLabel")
        accItemsHeader.Size = UDim2.new(0.4, 0, 0, 20)
        accItemsHeader.Position = UDim2.new(0.58, 0, 0, 98)
        accItemsHeader.BackgroundTransparency = 1
        accItemsHeader.Text = "Account Items"
        accItemsHeader.TextColor3 = Color3.fromRGB(250, 195, 35)
        accItemsHeader.Font = Enum.Font.GothamBold
        accItemsHeader.TextSize = 14
        accItemsHeader.TextXAlignment = Enum.TextXAlignment.Left
        accItemsHeader.Parent = main

        local itemsListFrame = Instance.new("Frame")
        itemsListFrame.Name = "ItemsListFrame"
        itemsListFrame.Size = UDim2.new(0.38, 0, 0, 110)
        itemsListFrame.Position = UDim2.new(0.58, 0, 0, 124)
        itemsListFrame.BackgroundTransparency = 1
        itemsListFrame.BorderSizePixel = 0
        itemsListFrame.Parent = main

        local itemsLayout = Instance.new("UIListLayout")
        itemsLayout.SortOrder = Enum.SortOrder.LayoutOrder
        itemsLayout.Padding = UDim.new(0, 6)
        itemsLayout.Parent = itemsListFrame

        -- Bottom Divider Line
        local div2 = Instance.new("Frame")
        div2.Name = "Divider2"
        div2.Size = UDim2.new(0.92, 0, 0, 1.5)
        div2.Position = UDim2.new(0.04, 0, 0, 238)
        div2.BackgroundColor3 = Color3.fromRGB(190, 190, 200)
        div2.BorderSizePixel = 0
        div2.Parent = main

        -- Bottom Milestone Badges (2 rows of 3)
        local function CreateMilestoneBadge(parentObj, name, xPos, yPos)
            local container = Instance.new("Frame")
            container.Name = name:gsub("%s+", "") .. "Badge"
            container.Size = UDim2.new(0.3, 0, 0, 22)
            container.Position = UDim2.new(xPos, 0, 0, yPos)
            container.BackgroundTransparency = 1
            container.Parent = parentObj

            local dot = Instance.new("Frame")
            dot.Name = "Dot"
            dot.Size = UDim2.new(0, 10, 0, 10)
            dot.Position = UDim2.new(0, 0, 0.5, -5)
            dot.BackgroundColor3 = Color3.fromRGB(255, 65, 80) -- Default Red
            dot.BorderSizePixel = 0
            dot.Parent = container

            local dotCorner = Instance.new("UICorner")
            dotCorner.CornerRadius = UDim.new(1, 0)
            dotCorner.Parent = dot

            local text = Instance.new("TextLabel")
            text.Name = "Label"
            text.Size = UDim2.new(1, -16, 1, 0)
            text.Position = UDim2.new(0, 16, 0, 0)
            text.BackgroundTransparency = 1
            text.Text = name
            text.TextColor3 = Color3.fromRGB(255, 255, 255)
            text.Font = Enum.Font.GothamBold
            text.TextSize = 13
            text.TextXAlignment = Enum.TextXAlignment.Left
            text.Parent = container

            return {
                Container = container,
                Dot = dot,
                Label = text,
                SetStatus = function(status)
                    if status == true or status == "DONE" then
                        dot.BackgroundColor3 = Color3.fromRGB(50, 240, 110) -- Green
                    elseif status == "LOCKED" then
                        dot.BackgroundColor3 = Color3.fromRGB(150, 160, 175) -- Grey
                    else
                        dot.BackgroundColor3 = Color3.fromRGB(255, 65, 80) -- Red
                    end
                end
            }
        end

        local badges = {
            Godhuman = CreateMilestoneBadge(main, "GodHuman", 0.05, 248),
            CDK = CreateMilestoneBadge(main, "Cursed Dual Katana", 0.38, 248),
            Valkyrie = CreateMilestoneBadge(main, "Valkyrie Helm", 0.71, 248),
            SoulGuitar = CreateMilestoneBadge(main, "Skull Guitar", 0.05, 280),
            MirrorFractal = CreateMilestoneBadge(main, "Mirror Fractal", 0.38, 280),
            PullLever = CreateMilestoneBadge(main, "Pull Lever", 0.71, 280),
        }

        -- DRAGGABLE LOGIC FOR FLOATING BUTTON & MAIN FRAME
        MakeDraggable(floatBtn, function()
            UI_Visible = not UI_Visible
            main.Visible = UI_Visible
        end)

        MakeDraggable(main, nil)

        sg.Parent = parent

        -- Automatically trigger DLC Code redemption
        RedeemAllDLCCodes()

        -- TELEMETRY & STATUS REFRESH LOOP
        task.spawn(function()
            while runtime.alive do
                task.wait(1)
                pcall(function()
                    local d = LocalPlayer:FindFirstChild("Data")
                    local lvl = d and d:FindFirstChild("Level") and d.Level.Value or 1
                    local beli = d and d:FindFirstChild("Beli") and d.Beli.Value or 0
                    local frags = d and d:FindFirstChild("Fragments") and d.Fragments.Value or 0
                    local raceName = (d and d:FindFirstChild("Race") and d.Race.Value) or GetPlayerRace() or "Human"
                    local sea = Data.GetSea()

                    seaTitle.Text = string.format("<Sea %d>", sea)
                    levelLabel.Text = "Level: " .. tostring(lvl)
                    raceLabel.Text = "Race: " .. tostring(raceName)
                    beliLabel.Text = "Beli: " .. FormatNumber(beli)
                    fragLabel.Text = "Frag: " .. FormatNumber(frags)

                    actionLabel.Text = HUDStatus
                    subActionLabel.Text = HUDSubStatus

                    -- Refresh Account Items list
                    for _, child in ipairs(itemsListFrame:GetChildren()) do
                        if child:IsA("TextLabel") then child:Destroy() end
                    end

                    local itemsCount = {}
                    for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
                        if tool:IsA("Tool") then
                            itemsCount[tool.Name] = (itemsCount[tool.Name] or 0) + 1
                        end
                    end
                    if LocalPlayer.Character then
                        for _, tool in ipairs(LocalPlayer.Character:GetChildren()) do
                            if tool:IsA("Tool") then
                                itemsCount[tool.Name] = (itemsCount[tool.Name] or 0) + 1
                            end
                        end
                    end

                    local displayed = 0
                    for itemName, count in pairs(itemsCount) do
                        if displayed < 4 then
                            local itemLbl = Instance.new("TextLabel")
                            itemLbl.Size = UDim2.new(1, 0, 0, 18)
                            itemLbl.BackgroundTransparency = 1
                            itemLbl.Text = string.format("%s x%d", itemName, count)
                            itemLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
                            itemLbl.Font = Enum.Font.GothamBold
                            itemLbl.TextSize = 13
                            itemLbl.TextXAlignment = Enum.TextXAlignment.Left
                            itemLbl.Parent = itemsListFrame
                            displayed = displayed + 1
                        end
                    end
                    if displayed == 0 then
                        local emptyLbl = Instance.new("TextLabel")
                        emptyLbl.Size = UDim2.new(1, 0, 0, 18)
                        emptyLbl.BackgroundTransparency = 1
                        emptyLbl.Text = "Tool x1"
                        emptyLbl.TextColor3 = Color3.fromRGB(180, 180, 180)
                        emptyLbl.Font = Enum.Font.GothamBold
                        emptyLbl.TextSize = 13
                        emptyLbl.TextXAlignment = Enum.TextXAlignment.Left
                        emptyLbl.Parent = itemsListFrame
                    end

                    -- Refresh Milestone Badges
                    badges.Godhuman.SetStatus(CheckItemOwned("Godhuman") or CheckItemOwned("GodHuman"))
                    badges.CDK.SetStatus(CheckItemOwned("Cursed Dual Katana"))
                    badges.Valkyrie.SetStatus(CheckItemOwned("Valkyrie Helm"))
                    badges.SoulGuitar.SetStatus(CheckItemOwned("Soul Guitar") or CheckItemOwned("Skull Guitar"))
                    badges.MirrorFractal.SetStatus(CheckItemOwned("Mirror Fractal"))
                    badges.PullLever.SetStatus(CheckPullLeverStatus())
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
    while runtime.alive do
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
                local targetQ = quest.PosQ
                pcall(function()
                    local npcs = Workspace:FindFirstChild("NPCs")
                    if npcs then
                        for _, npc in ipairs(npcs:GetChildren()) do
                            if npc:IsA("Model") and (npc.Name:find("Quest") or npc.Name:find(quest.Quest)) then
                                local root = npc:FindFirstChild("HumanoidRootPart") or npc:FindFirstChild("Head")
                                if root and (root.Position - quest.PosQ.Position).Magnitude <= 120 then
                                    targetQ = root.CFrame
                                    break
                                end
                            end
                        end
                    end
                end)
                toTarget(targetQ, 8)
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp and (hrp.Position - targetQ.Position).Magnitude <= 35 and CommF then
                    CommF:InvokeServer("StartQuest", quest.Quest, quest.Id)
                    task.wait(0.3)
                end
            else
                HUDStatus = string.format("Farming %s (Lv %d)", quest.Mob, quest.Min or 1)
                local targetMob = nil
                local enemies = Workspace:FindFirstChild("Enemies")
                if enemies then
                    for _, mob in ipairs(enemies:GetChildren()) do
                        if (mob.Name == quest.Mob or (mob.Name:find(quest.Mob) and not mob.Name:find("Escap"))) and IsMobAlive(mob) then
                            targetMob = mob
                            break
                        end
                    end
                end

                if targetMob then
                    local mobHRP = targetMob:FindFirstChild("HumanoidRootPart")
                    if mobHRP then
                        local isPrisoner = (targetMob.Name == "Prisoner" or targetMob.Name == "Dangerous Prisoner" or targetMob.Name:find("Prisoner"))
                        local farmCF = isPrisoner and (mobHRP.CFrame * CFrame.new(0, 3, -4)) or GetFarmCFrame(mobHRP)
                        toTarget(farmCF, 5)
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

print("[🍌 Banana Kaitun Standalone] Initialized with BananaHub schema & Ultra FPS Boost!")
