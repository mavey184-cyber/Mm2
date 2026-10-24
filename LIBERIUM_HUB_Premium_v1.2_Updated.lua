--[[
    LIBERIUM HUB Premium v1.2
    Single-file Luau hub. No external loaders, no links, no data collection.
    Toggle window: RightShift or the floating button. Everything is undone on Unload.
]]

local env = (getgenv and getgenv()) or _G
if env.LIBERIUM_HUB and env.LIBERIUM_HUB.Unload then
    pcall(env.LIBERIUM_HUB.Unload)
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Stats = game:GetService("Stats")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local VERSION = "v1.2"

-- ============================================================
-- Theme
-- ============================================================
local C = {
    bg = Color3.fromRGB(11, 12, 15),
    panel = Color3.fromRGB(16, 18, 22),
    card = Color3.fromRGB(21, 23, 28),
    cardHover = Color3.fromRGB(27, 30, 36),
    stroke = Color3.fromRGB(40, 44, 52),
    text = Color3.fromRGB(240, 244, 248),
    muted = Color3.fromRGB(139, 148, 160),
    off = Color3.fromRGB(52, 57, 67),
    green = Color3.fromRGB(46, 204, 113),
    green2 = Color3.fromRGB(120, 255, 170),
    orange = Color3.fromRGB(255, 138, 31),
    orange2 = Color3.fromRGB(255, 184, 77),
    danger = Color3.fromRGB(255, 82, 82),
}
local GRADIENT = ColorSequence.new({
    ColorSequenceKeypoint.new(0, C.green),
    ColorSequenceKeypoint.new(1, C.orange),
})
local FONT = Enum.Font.Gotham
local FONT_M = Enum.Font.GothamMedium
local FONT_B = Enum.Font.GothamBold
local FONT_K = Enum.Font.GothamBlack

-- ============================================================
-- Cleanup manager
-- ============================================================
local Hub = { alive = true }
local janitor = {}
local function keep(x)
    janitor[#janitor + 1] = x
    return x
end
local function cleanJanitor()
    for i = #janitor, 1, -1 do
        local x = janitor[i]
        local t = typeof(x)
        if t == "RBXScriptConnection" then
            pcall(function() x:Disconnect() end)
        elseif t == "Instance" then
            pcall(function() x:Destroy() end)
        elseif t == "function" then
            pcall(x)
        end
        janitor[i] = nil
    end
end

-- ============================================================
-- Small helpers
-- ============================================================
local function new(class, props, parent)
    local o = Instance.new(class)
    if props then
        for k, v in pairs(props) do o[k] = v end
    end
    if parent then o.Parent = parent end
    return o
end
local function corner(o, r) return new("UICorner", { CornerRadius = UDim.new(0, r) }, o) end
local function stroke(o, color, thickness, transparency)
    return new("UIStroke", {
        Color = color, Thickness = thickness or 1, Transparency = transparency or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, o)
end
local function tween(o, t, props, style, dir)
    pcall(function()
        TweenService:Create(o, TweenInfo.new(t, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out), props):Play()
    end)
end

local function getChar() return LocalPlayer.Character end
local function getHum()
    local c = LocalPlayer.Character
    return c and c:FindFirstChildOfClass("Humanoid") or nil
end
local function getRoot()
    local c = LocalPlayer.Character
    return c and c:FindFirstChild("HumanoidRootPart") or nil
end

-- ============================================================
-- State
-- ============================================================
local Settings = {
    walkSpeed = 40, jumpPower = 100, flySpeed = 60,
    espDistance = 800, espNames = true, espTeam = true,
    fov = 90, uiScale = 1, glow = true, notifications = true,
}
local Features = {}      -- id -> { enabled, on, off, step, stage, respawn }
local Target = nil       -- selected player (teleport / spectate)

local toast -- forward declaration

local function defineFeature(id, def)
    def.enabled = false
    Features[id] = def
    return def
end
local function setFeature(id, value)
    local f = Features[id]
    if not f then return false end
    value = value and true or false
    if f.enabled == value then return true end
    f.enabled = value
    local ok, err = pcall(value and f.on or f.off)
    if not ok then
        f.enabled = false
        if toast then toast("Error: " .. id) end
        warn("[LIBERIUM] " .. id .. ": " .. tostring(err))
        return false
    end
    return true
end

-- ============================================================
-- Features (every one is a real implementation)
-- ============================================================
local weak = { __mode = "k" }

-- WalkSpeed
local origWalk = setmetatable({}, weak)
defineFeature("walk", {
    stage = "Heartbeat",
    on = function() end,
    off = function()
        for h, v in pairs(origWalk) do
            if h.Parent then h.WalkSpeed = v end
            origWalk[h] = nil
        end
    end,
    step = function()
        local h = getHum()
        if not h then return end
        if origWalk[h] == nil then origWalk[h] = h.WalkSpeed end
        if h.WalkSpeed ~= Settings.walkSpeed then h.WalkSpeed = Settings.walkSpeed end
    end,
})

-- JumpPower
local origJump = setmetatable({}, weak)
defineFeature("jump", {
    stage = "Heartbeat",
    on = function() end,
    off = function()
        for h, v in pairs(origJump) do
            if h.Parent then
                if h.UseJumpPower then h.JumpPower = v else h.JumpHeight = v end
            end
            origJump[h] = nil
        end
    end,
    step = function()
        local h = getHum()
        if not h then return end
        if h.UseJumpPower then
            if origJump[h] == nil then origJump[h] = h.JumpPower end
            if h.JumpPower ~= Settings.jumpPower then h.JumpPower = Settings.jumpPower end
        else
            if origJump[h] == nil then origJump[h] = h.JumpHeight end
            local height = (Settings.jumpPower * Settings.jumpPower) / (2 * Workspace.Gravity)
            if math.abs(h.JumpHeight - height) > 0.01 then h.JumpHeight = height end
        end
    end,
})

-- Infinite Jump
local infJumpConn
defineFeature("infjump", {
    on = function()
        infJumpConn = UserInputService.JumpRequest:Connect(function()
            local h = getHum()
            if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
        end)
    end,
    off = function()
        if infJumpConn then infJumpConn:Disconnect() infJumpConn = nil end
    end,
})

-- Noclip
local ncOrig = setmetatable({}, weak)
defineFeature("noclip", {
    stage = "Stepped",
    on = function() end,
    off = function()
        for part, v in pairs(ncOrig) do
            if part.Parent then part.CanCollide = v end
            ncOrig[part] = nil
        end
    end,
    step = function()
        local c = getChar()
        if not c then return end
        for _, p in ipairs(c:GetDescendants()) do
            if p:IsA("BasePart") and p.CanCollide then
                if ncOrig[p] == nil then ncOrig[p] = true end
                p.CanCollide = false
            end
        end
    end,
})

-- Fly (camera-relative, works with touch thumbstick, keyboard and gamepad)
local flyVel, flyAlign, flyHum
local function destroyFly()
    if flyVel then flyVel:Destroy() flyVel = nil end
    if flyAlign then flyAlign:Destroy() flyAlign = nil end
    if flyHum and flyHum.Parent then
        flyHum.PlatformStand = false
        pcall(function() flyHum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
    end
    flyHum = nil
end
local function buildFly()
    destroyFly()
    local root, hum = getRoot(), getHum()
    if not root or not hum then return false end
    local att = root:FindFirstChild("RootAttachment") or new("Attachment", { Name = "RootAttachment" }, root)
    flyVel = new("LinearVelocity", {
        Attachment0 = att, MaxForce = math.huge, VectorVelocity = Vector3.new(0, 0, 0),
        RelativeTo = Enum.ActuatorRelativeTo.World,
    }, root)
    flyAlign = new("AlignOrientation", {
        Attachment0 = att, Mode = Enum.OrientationAlignmentMode.OneAttachment,
        MaxTorque = 1e7, Responsiveness = 40, RigidityEnabled = false,
    }, root)
    hum.PlatformStand = true
    flyHum = hum
    return true
end
defineFeature("fly", {
    stage = "Heartbeat",
    on = function() buildFly() end,
    off = destroyFly,
    respawn = function()
        local c = getChar()
        if c then c:WaitForChild("HumanoidRootPart", 5) c:WaitForChild("Humanoid", 5) end
        if Features.fly.enabled then buildFly() end
    end,
    step = function()
        local root, hum = getRoot(), getHum()
        local cam = Workspace.CurrentCamera
        if not root or not hum or not cam then return end
        if not flyVel or not flyVel.Parent or not flyHum or flyHum ~= hum then
            if not buildFly() then return end
        end
        local look = cam.CFrame.LookVector
        local flat = Vector3.new(look.X, 0, look.Z)
        if flat.Magnitude > 0.001 then flat = flat.Unit else flat = Vector3.new(0, 0, -1) end
        local move = hum.MoveDirection
        local fwd = move:Dot(flat)
        local up = 0
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) or hum.Jump then up = up + 1 end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.Q) then up = up - 1 end
        local vertical = look.Y * fwd + up
        flyVel.VectorVelocity = Vector3.new(move.X, vertical, move.Z) * Settings.flySpeed
        flyAlign.CFrame = CFrame.lookAt(Vector3.new(0, 0, 0), flat)
    end,
})

-- Anti AFK
local afkConn
defineFeature("antiafk", {
    on = function()
        afkConn = LocalPlayer.Idled:Connect(function()
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new(0, 0))
            end)
        end)
    end,
    off = function()
        if afkConn then afkConn:Disconnect() afkConn = nil end
    end,
})

-- ESP (Highlight + name tag). Roblox draws at most 31 Highlights, so only the nearest ones get one.
local espData = {}
local ESP_HIGHLIGHT_CAP = 30
local function clearESP(plr)
    local d = espData[plr]
    if not d then return end
    if d.highlight then d.highlight:Destroy() end
    if d.board then d.board:Destroy() end
    espData[plr] = nil
end
local function clearAllESP()
    for plr in pairs(espData) do clearESP(plr) end
end
local function buildESP(plr)
    local char = plr.Character
    if not char then return nil end
    local head = char:FindFirstChild("Head")
    if not head then return nil end
    local d = { char = char }
    d.highlight = new("Highlight", {
        Adornee = char, DepthMode = Enum.HighlightDepthMode.AlwaysOnTop,
        FillTransparency = 0.78, OutlineTransparency = 0.05, Enabled = false,
    }, char)
    d.board = new("BillboardGui", {
        Adornee = head, Size = UDim2.fromOffset(150, 34), StudsOffset = Vector3.new(0, 2.4, 0),
        AlwaysOnTop = true, ResetOnSpawn = false, Enabled = false,
    }, head)
    d.label = new("TextLabel", {
        Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Font = FONT_B, TextSize = 13,
        TextColor3 = C.text, TextStrokeTransparency = 0.4, Text = plr.Name,
    }, d.board)
    espData[plr] = d
    return d
end
local espAcc = 0
defineFeature("esp", {
    stage = "Heartbeat",
    on = function() espAcc = 1 end,
    off = clearAllESP,
    step = function(dt)
        espAcc = espAcc + dt
        if espAcc < 0.2 then return end
        espAcc = 0
        local myRoot = getRoot()
        local list = {}
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                local d = espData[plr]
                if d and d.char ~= plr.Character then clearESP(plr) d = nil end
                local char = plr.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if root and hum and hum.Health > 0 then
                    local dist = myRoot and (root.Position - myRoot.Position).Magnitude or 0
                    local sameTeam = plr.Team ~= nil and plr.Team == LocalPlayer.Team
                    local show = dist <= Settings.espDistance and (Settings.espTeam or not sameTeam)
                    if show then
                        list[#list + 1] = { plr = plr, dist = dist, hum = hum, same = sameTeam }
                    elseif d then
                        d.highlight.Enabled = false
                        d.board.Enabled = false
                    end
                elseif d then
                    d.highlight.Enabled = false
                    d.board.Enabled = false
                end
            else
                clearESP(plr)
            end
        end
        table.sort(list, function(a, b) return a.dist < b.dist end)
        for i, e in ipairs(list) do
            local d = espData[e.plr] or buildESP(e.plr)
            if d then
                local color = e.plr.Team and e.plr.TeamColor.Color or C.orange
                d.highlight.FillColor = color
                d.highlight.OutlineColor = color
                d.highlight.Enabled = i <= ESP_HIGHLIGHT_CAP
                d.board.Enabled = Settings.espNames
                d.label.TextColor3 = color
                d.label.Text = string.format("%s  [%dm]  %d HP", e.plr.DisplayName, math.floor(e.dist), math.floor(e.hum.Health))
            end
        end
    end,
})
keep(Players.PlayerRemoving:Connect(function(plr) clearESP(plr) end))

-- Fullbright
local lightOrig
local FB_PROPS = { "Brightness", "ClockTime", "FogEnd", "GlobalShadows", "Ambient", "OutdoorAmbient" }
local FB_VALUES = {
    Brightness = 2, ClockTime = 14, FogEnd = 100000, GlobalShadows = false,
    Ambient = Color3.fromRGB(178, 178, 178), OutdoorAmbient = Color3.fromRGB(178, 178, 178),
}
defineFeature("fullbright", {
    stage = "Heartbeat",
    on = function()
        lightOrig = {}
        for _, p in ipairs(FB_PROPS) do lightOrig[p] = Lighting[p] end
    end,
    off = function()
        if lightOrig then
            for p, v in pairs(lightOrig) do pcall(function() Lighting[p] = v end) end
            lightOrig = nil
        end
    end,
    step = function()
        for _, p in ipairs(FB_PROPS) do
            if Lighting[p] ~= FB_VALUES[p] then Lighting[p] = FB_VALUES[p] end
        end
    end,
})

-- FOV
local origFov
defineFeature("fov", {
    stage = "RenderStepped",
    on = function()
        local cam = Workspace.CurrentCamera
        origFov = cam and cam.FieldOfView or 70
    end,
    off = function()
        local cam = Workspace.CurrentCamera
        if cam and origFov then cam.FieldOfView = origFov end
        origFov = nil
    end,
    step = function()
        local cam = Workspace.CurrentCamera
        if cam and cam.FieldOfView ~= Settings.fov then cam.FieldOfView = Settings.fov end
    end,
})

-- Spectate selected player
defineFeature("spectate", {
    stage = "Heartbeat",
    on = function() end,
    off = function()
        local cam = Workspace.CurrentCamera
        local h = getHum()
        if cam and h then cam.CameraSubject = h end
    end,
    step = function()
        local cam = Workspace.CurrentCamera
        local hum = Target and Target.Character and Target.Character:FindFirstChildOfClass("Humanoid")
        if not cam then return end
        if not hum then
            setFeature("spectate", false)
            if Hub.syncSpectate then Hub.syncSpectate(false) end
            return
        end
        if cam.CameraSubject ~= hum then cam.CameraSubject = hum end
    end,
})

-- Master loops: one connection per stage runs every active feature inside pcall.
local function runStage(stage, dt)
    for id, f in pairs(Features) do
        if f.enabled and f.step and (f.stage or "Heartbeat") == stage then
            local ok, err = pcall(f.step, dt)
            if not ok then
                warn("[LIBERIUM] " .. id .. ": " .. tostring(err))
                f.enabled = false
                pcall(f.off)
                if Hub.syncToggle then Hub.syncToggle(id, false) end
            end
        end
    end
end
keep(RunService.Heartbeat:Connect(function(dt) runStage("Heartbeat", dt) end))
keep(RunService.Stepped:Connect(function(_, dt) runStage("Stepped", dt) end))
keep(RunService.RenderStepped:Connect(function(dt) runStage("RenderStepped", dt) end))

-- Respawn handling: features that need to rebuild do it here; the others re-apply through their step.
keep(LocalPlayer.CharacterAdded:Connect(function()
    for _, f in pairs(Features) do
        if f.enabled and f.respawn then task.spawn(f.respawn) end
    end
end))

-- ============================================================
-- UI
-- ============================================================
local function guiParent()
    local ok, h = pcall(function() return gethui and gethui() end)
    if ok and h then return h end
    if pcall(function() return CoreGui.Name end) then return CoreGui end
    return LocalPlayer:WaitForChild("PlayerGui")
end

local gui = new("ScreenGui", {
    Name = "LiberiumHub_" .. tostring(math.random(1000, 9999)), ResetOnSpawn = false,
    IgnoreGuiInset = true, DisplayOrder = 999, ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})
pcall(function() gui.Parent = guiParent() end)
if not gui.Parent then gui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
keep(gui)

local glowGradients = {}
local function glowStroke(o, thickness, transparency)
    local s = stroke(o, Color3.new(1, 1, 1), thickness, transparency)
    local g = new("UIGradient", { Color = GRADIENT }, s)
    glowGradients[#glowGradients + 1] = g
    return s, g
end

-- toasts -------------------------------------------------------
local toastHolder = new("Frame", {
    Size = UDim2.new(0, 320, 0, 200), Position = UDim2.new(0.5, -160, 1, -220),
    BackgroundTransparency = 1,
}, gui)
new("UIListLayout", {
    VerticalAlignment = Enum.VerticalAlignment.Bottom, HorizontalAlignment = Enum.HorizontalAlignment.Center,
    Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder,
}, toastHolder)
toast = function(msg)
    if not Settings.notifications or not Hub.alive then return end
    local wrap = new("Frame", { Size = UDim2.fromOffset(0, 34), AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1 }, toastHolder)
    local f = new("Frame", {
        Size = UDim2.fromScale(0, 1), AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = C.panel, BackgroundTransparency = 1, BorderSizePixel = 0,
        Position = UDim2.fromOffset(0, 14),
    }, wrap)
    corner(f, 10)
    local s = glowStroke(f, 1.2, 1)
    new("UIPadding", { PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14) }, f)
    local l = new("TextLabel", {
        Size = UDim2.fromScale(0, 1), AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1,
        Font = FONT_M, TextSize = 12, TextColor3 = C.text, Text = tostring(msg), TextTransparency = 1,
    }, f)
    tween(f, 0.2, { BackgroundTransparency = 0.05, Position = UDim2.fromOffset(0, 0) })
    tween(s, 0.2, { Transparency = 0.2 })
    tween(l, 0.2, { TextTransparency = 0 })
    task.delay(1.8, function()
        if not f.Parent then return end
        tween(f, 0.25, { BackgroundTransparency = 1 }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        tween(s, 0.25, { Transparency = 1 })
        tween(l, 0.25, { TextTransparency = 1 })
        task.wait(0.28)
        if wrap.Parent then wrap:Destroy() end
    end)
end

-- window -------------------------------------------------------
local WIN_W, WIN_H = 560, 430
local win = new("Frame", {
    Name = "Window", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(WIN_W, WIN_H), BackgroundColor3 = C.bg, BorderSizePixel = 0,
    Visible = false, Active = true, ClipsDescendants = true,
}, gui)
corner(win, 18)
glowStroke(win, 1.6, 0.35)
local winScale = new("UIScale", {}, win)

local function fitScale()
    local cam = Workspace.CurrentCamera
    local v = cam and cam.ViewportSize or Vector2.new(1280, 720)
    return math.clamp(math.min((v.X - 16) / WIN_W, (v.Y - 16) / WIN_H), 0.45, 1)
end
local function currentScale() return fitScale() * Settings.uiScale end

-- banner -------------------------------------------------------
local banner = new("Frame", {
    Name = "Banner", Position = UDim2.fromOffset(8, 8), Size = UDim2.new(1, -16, 0, 112),
    BackgroundColor3 = Color3.fromRGB(14, 20, 18), BorderSizePixel = 0, ClipsDescendants = true, Active = true,
}, win)
corner(banner, 14)
local bannerGrad = new("UIGradient", {
    Rotation = 20,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 58, 40)),
        ColorSequenceKeypoint.new(0.55, Color3.fromRGB(16, 18, 22)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(78, 40, 12)),
    }),
}, banner)
glowStroke(banner, 1.2, 0.45)

-- glow blobs (stacked translucent circles)
local function blob(color, x, y, size)
    for i = 1, 4 do
        local s = size * (1 - (i - 1) * 0.22)
        local f = new("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(x, 0, y, 0),
            Size = UDim2.fromOffset(s, s), BackgroundColor3 = color,
            BackgroundTransparency = 0.93 - i * 0.012, BorderSizePixel = 0, ZIndex = 1,
        }, banner)
        corner(f, 999)
    end
end
blob(C.green, 0.08, 0.1, 190)
blob(C.orange, 0.95, 0.95, 210)

local title = new("TextLabel", {
    Position = UDim2.fromOffset(18, 14), Size = UDim2.new(1, -150, 0, 44), BackgroundTransparency = 1,
    Font = FONT_K, TextSize = 34, Text = "LIBERIUM HUB", TextColor3 = Color3.new(1, 1, 1),
    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 3,
}, banner)
local titleGrad = new("UIGradient", { Color = GRADIENT }, title)
new("TextLabel", {
    Position = UDim2.fromOffset(20, 58), Size = UDim2.new(1, -150, 0, 16), BackgroundTransparency = 1,
    Font = FONT_B, TextSize = 11, Text = "PREMIUM  " .. VERSION, TextColor3 = C.orange2,
    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 3,
}, banner)

local function chip(xOffset, label)
    local f = new("Frame", {
        Position = UDim2.new(0, xOffset, 1, -30), Size = UDim2.fromOffset(86, 22),
        BackgroundColor3 = Color3.fromRGB(10, 12, 14), BackgroundTransparency = 0.25, BorderSizePixel = 0, ZIndex = 3,
    }, banner)
    corner(f, 11)
    stroke(f, C.stroke, 1, 0.3)
    local t = new("TextLabel", {
        Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Font = FONT_B, TextSize = 11,
        TextColor3 = C.text, Text = label, ZIndex = 4,
    }, f)
    return t
end
local chipFps = chip(18, "FPS --")
local chipPing = chip(112, "PING --")
local chipPlayers = chip(206, "PLAYERS --")

local function bannerButton(text, xFromRight)
    local b = new("TextButton", {
        Position = UDim2.new(1, xFromRight, 0, 10), Size = UDim2.fromOffset(28, 28),
        BackgroundColor3 = Color3.fromRGB(10, 12, 14), BackgroundTransparency = 0.3, BorderSizePixel = 0,
        Text = text, Font = FONT_B, TextSize = 18, TextColor3 = C.text, AutoButtonColor = false, ZIndex = 5,
    }, banner)
    corner(b, 14)
    b.MouseEnter:Connect(function() tween(b, 0.12, { BackgroundTransparency = 0 }) end)
    b.MouseLeave:Connect(function() tween(b, 0.12, { BackgroundTransparency = 0.3 }) end)
    return b
end
local btnClose = bannerButton("×", -38)

-- tabs ---------------------------------------------------------
local TAB_NAMES = { "Movement", "Visuals", "Utility", "Settings" }
local tabBar = new("Frame", {
    Position = UDim2.fromOffset(12, 128), Size = UDim2.new(1, -24, 0, 32), BackgroundTransparency = 1,
}, win)
new("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 8),
    SortOrder = Enum.SortOrder.LayoutOrder,
}, tabBar)
local tabButtons, pages = {}, {}
local activeTab = 1

local function showTab(i)
    activeTab = i
    for idx, pg in ipairs(pages) do pg.Visible = (idx == i) end
    for idx, b in ipairs(tabButtons) do
        local on = idx == i
        b.BackgroundColor3 = on and Color3.new(1, 1, 1) or C.card
        b.TextColor3 = on and Color3.fromRGB(12, 14, 16) or C.muted
        local g = b:FindFirstChildOfClass("UIGradient")
        if g then g.Enabled = on end
    end
end

for i, name in ipairs(TAB_NAMES) do
    local b = new("TextButton", {
        Size = UDim2.fromOffset(104, 32), BackgroundColor3 = C.card, BorderSizePixel = 0, AutoButtonColor = false,
        Text = name, Font = FONT_B, TextSize = 12, TextColor3 = C.muted, LayoutOrder = i,
    }, tabBar)
    corner(b, 10)
    new("UIGradient", { Color = GRADIENT, Enabled = false }, b)
    tabButtons[i] = b
    b.MouseButton1Click:Connect(function() showTab(i) end)
end

local pageHolder = new("Frame", {
    Position = UDim2.fromOffset(12, 170), Size = UDim2.new(1, -24, 1, -200), BackgroundTransparency = 1,
    ClipsDescendants = true,
}, win)
for i = 1, #TAB_NAMES do
    local pg = new("ScrollingFrame", {
        Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3,
        ScrollBarImageColor3 = C.orange, CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y, Visible = (i == 1),
    }, pageHolder)
    new("UIGridLayout", {
        CellSize = UDim2.new(0.5, -5, 0, 66), CellPadding = UDim2.fromOffset(10, 10),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, pg)
    new("UIPadding", { PaddingBottom = UDim.new(0, 10), PaddingRight = UDim.new(0, 4) }, pg)
    pages[i] = pg
end

new("TextLabel", {
    Position = UDim2.new(0, 16, 1, -26), Size = UDim2.new(1, -32, 0, 16), BackgroundTransparency = 1,
    Font = FONT, TextSize = 10, TextColor3 = C.muted, TextXAlignment = Enum.TextXAlignment.Left,
    Text = "LIBERIUM HUB Premium " .. VERSION .. "   •   RightShift: show / hide",
}, win)

-- card + controls ----------------------------------------------
local order = {}
local function nextOrder(page)
    order[page] = (order[page] or 0) + 1
    return order[page]
end

local function makeCard(page, titleText, descText)
    local card = new("Frame", { BackgroundColor3 = C.card, BorderSizePixel = 0, LayoutOrder = nextOrder(page) }, page)
    corner(card, 12)
    local st = stroke(card, C.stroke, 1, 0.25)
    new("TextLabel", {
        Position = UDim2.fromOffset(12, 9), Size = UDim2.new(1, -78, 0, 18), BackgroundTransparency = 1,
        Font = FONT_B, TextSize = 13, TextColor3 = C.text, Text = titleText,
        TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
    }, card)
    if descText then
        new("TextLabel", {
            Position = UDim2.fromOffset(12, 29), Size = UDim2.new(1, -78, 0, 28), BackgroundTransparency = 1,
            Font = FONT, TextSize = 11, TextColor3 = C.muted, Text = descText, TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
        }, card)
    end
    card.MouseEnter:Connect(function() tween(card, 0.12, { BackgroundColor3 = C.cardHover }) end)
    card.MouseLeave:Connect(function() tween(card, 0.12, { BackgroundColor3 = C.card }) end)
    return card, st
end

local toggleSetters = {}
local function addToggle(page, id, titleText, descText, onChange)
    local card, st = makeCard(page, titleText, descText)
    local btn = new("TextButton", {
        Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", AutoButtonColor = false,
    }, card)
    local track = new("Frame", {
        Position = UDim2.new(1, -54, 0.5, -11), Size = UDim2.fromOffset(42, 22), BackgroundColor3 = C.off,
        BorderSizePixel = 0,
    }, btn)
    corner(track, 11)
    local tg = new("UIGradient", { Color = GRADIENT, Enabled = false }, track)
    local knob = new("Frame", {
        Position = UDim2.fromOffset(3, 3), Size = UDim2.fromOffset(16, 16), BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
    }, track)
    corner(knob, 8)
    local state = false
    local function paint(v, animate)
        state = v
        tg.Enabled = v
        local pos = UDim2.fromOffset(v and 23 or 3, 3)
        if animate then
            tween(knob, 0.16, { Position = pos })
        else
            knob.Position = pos
        end
        track.BackgroundColor3 = v and Color3.new(1, 1, 1) or C.off
        st.Color = v and C.green or C.stroke
        st.Transparency = v and 0.35 or 0.25
    end
    paint(false, false)
    btn.MouseButton1Click:Connect(function()
        local want = not state
        local ok = onChange(want)
        if ok == false then paint(false, true) else paint(want, true) end
    end)
    toggleSetters[id] = function(v) paint(v, true) end
    return { set = function(v) paint(v, true) end }
end

local activeSlide
local function addSlider(page, titleText, minV, maxV, default, suffix, onChange)
    local card = makeCard(page, titleText, nil)
    local value = new("TextLabel", {
        Position = UDim2.new(1, -86, 0, 9), Size = UDim2.fromOffset(74, 18), BackgroundTransparency = 1,
        Font = FONT_B, TextSize = 12, TextColor3 = C.orange2, TextXAlignment = Enum.TextXAlignment.Right,
        Text = tostring(default) .. (suffix or ""),
    }, card)
    local hit = new("TextButton", {
        Position = UDim2.fromOffset(12, 34), Size = UDim2.new(1, -24, 0, 24), BackgroundTransparency = 1,
        Text = "", AutoButtonColor = false,
    }, card)
    local track = new("Frame", {
        AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.new(1, 0, 0, 6),
        BackgroundColor3 = C.off, BorderSizePixel = 0,
    }, hit)
    corner(track, 3)
    local ratio0 = (maxV > minV) and math.clamp((default - minV) / (maxV - minV), 0, 1) or 0
    local fill = new("Frame", { Size = UDim2.fromScale(ratio0, 1), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0 }, track)
    corner(fill, 3)
    new("UIGradient", { Color = GRADIENT }, fill)
    local knob = new("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(ratio0, 0, 0.5, 0), Size = UDim2.fromOffset(14, 14),
        BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0,
    }, track)
    corner(knob, 7)
    stroke(knob, C.orange, 1.5, 0.1)
    local function slide(x)
        local w = math.max(track.AbsoluteSize.X, 1)
        local ratio = math.clamp((x - track.AbsolutePosition.X) / w, 0, 1)
        local v = math.floor(minV + ratio * (maxV - minV) + 0.5)
        fill.Size = UDim2.fromScale(ratio, 1)
        knob.Position = UDim2.new(ratio, 0, 0.5, 0)
        value.Text = tostring(v) .. (suffix or "")
        onChange(v)
    end
    hit.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            activeSlide = slide
            slide(input.Position.X)
        end
    end)
end
keep(UserInputService.InputChanged:Connect(function(input)
    if activeSlide and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        activeSlide(input.Position.X)
    end
end))
keep(UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        activeSlide = nil
    end
end))

local function smallButton(parent, text, pos, size, color)
    local b = new("TextButton", {
        Position = pos, Size = size, BackgroundColor3 = color or C.off, BorderSizePixel = 0, AutoButtonColor = false,
        Text = text, Font = FONT_B, TextSize = 11, TextColor3 = C.text,
    }, parent)
    corner(b, 8)
    return b
end

local function addButton(page, titleText, descText, label, onClick)
    local card = makeCard(page, titleText, descText)
    local b = smallButton(card, label, UDim2.new(1, -74, 0.5, -14), UDim2.fromOffset(62, 28), C.off)
    b.MouseEnter:Connect(function() tween(b, 0.12, { BackgroundColor3 = C.orange }) end)
    b.MouseLeave:Connect(function() tween(b, 0.12, { BackgroundColor3 = C.off }) end)
    b.MouseButton1Click:Connect(function() onClick() end)
end

-- Player page ---------------------------------------------------
local pPlayer, pVisuals, pUtility, pSettings = pages[1], pages[2], pages[3], pages[4]

-- Candy Auto Farm: transferred targeting model from DaDa's CoinVisual farm.
-- Live seasonal candy targets must use the game's CoinVisual tag to be detected.
local CollectionService = game:GetService("CollectionService")
local candyFarm = {on=false, state="Idle", target=nil, conn=nil, lastTouch=0}
local function stopCandyFarm(state)
    candyFarm.on=false; candyFarm.target=nil
    if candyFarm.conn then candyFarm.conn:Disconnect(); candyFarm.conn=nil end
    candyFarm.state=state or "Idle"
end
local function candyRoot()
    local c=LocalPlayer.Character; local h=c and c:FindFirstChildOfClass("Humanoid")
    local r=c and c:FindFirstChild("HumanoidRootPart")
    if not h or h.Health<=0 or not r then return nil end
    return r
end
local function candyTargets()
    local out={}
    for _,v in ipairs(CollectionService:GetTagged("CoinVisual")) do
        if v and v.Parent and v:IsA("BasePart") and not v:GetAttribute("Collected") and not v:GetAttribute("Delete") then out[#out+1]=v end
    end
    return out
end
local function nearestCandy(pos, list)
    local chosen,dist=nil,math.huge
    for _,v in ipairs(list) do local d=(v.Position-pos).Magnitude; if d<dist then chosen,dist=v,d end end
    return chosen
end
local function startCandyFarm()
    if candyFarm.on then return true end
    if #CollectionService:GetTagged("CoinVisual")==0 then
        candyFarm.state="Paused"; if toast then toast("No live CoinVisual targets; candy tags unverified") end; return false
    end
    candyFarm.on=true; candyFarm.state="Running"
    candyFarm.conn=RunService.Heartbeat:Connect(function(dt)
        if not Hub.alive or not candyFarm.on then stopCandyFarm("Idle"); return end
        local root=candyRoot(); if not root then candyFarm.state="Paused"; candyFarm.target=nil; return end
        local ok,err=pcall(function()
            local list=candyTargets()
            if #list==0 then candyFarm.target=nil; candyFarm.state="Paused"; return end
            local t=candyFarm.target
            if not t or not t.Parent or t:GetAttribute("Collected") or t:GetAttribute("Delete") then t=nearestCandy(root.Position,list); candyFarm.target=t end
            if not t then return end
            local delta=t.Position-root.Position
            if delta.Magnitude<=5 then
                if os.clock()-candyFarm.lastTouch>.12 then
                    candyFarm.lastTouch=os.clock()
                    if type(firetouchinterest)=="function" then
                        pcall(firetouchinterest,root,t,0); pcall(firetouchinterest,root,t,1)
                    end
                end
            else
                local pos=root.Position+delta.Unit*math.min(18*math.max(dt,0),delta.Magnitude)
                root.CFrame=CFrame.new(pos)
            end
        end)
        if not ok then warn("[LIBERIUM CandyFarm] "..tostring(err)); stopCandyFarm("Error") end
    end)
    return true
end

addToggle(pUtility, "candyfarm", "Candy Auto Farm", "DaDa CoinVisual targeting; seasonal candy tag compatibility is unconfirmed", function(v)
    if v then
        if not startCandyFarm() then if Hub.syncToggle then Hub.syncToggle("candyfarm",false) end; return false end
        return true
    end
    stopCandyFarm("Idle"); return true
end)
addButton(pUtility, "Stop Auto Farm", "Stop movement and clear the target", "STOP", function()
    stopCandyFarm("Idle"); if Hub.syncToggle then Hub.syncToggle("candyfarm",false) end
    if toast then toast("Auto Farm stopped") end
end)
addButton(pUtility, "Stop All", "Stop farm and disable active hub features", "STOP ALL", function()
    pcall(function() stopCandyFarm("Idle") end)
    if Hub.syncToggle then Hub.syncToggle("candyfarm", false) end
    for id, feature in pairs(Features) do
        if feature.enabled then
            feature.enabled = false
            pcall(function() if feature.off then feature.off() end end)
            if Hub.syncToggle then pcall(Hub.syncToggle, id, false) end
        end
    end
    pcall(clearAllESP)
    if toast then toast("All active features stopped") end
end)
addToggle(pPlayer, "walk", "WalkSpeed", "Locks walk speed to the value", function(v) return setFeature("walk", v) end)
addSlider(pPlayer, "Speed value", 16, 200, Settings.walkSpeed, "", function(v) Settings.walkSpeed = v end)
addToggle(pPlayer, "jump", "JumpPower", "Locks jump strength", function(v) return setFeature("jump", v) end)
addSlider(pPlayer, "Jump value", 50, 300, Settings.jumpPower, "", function(v) Settings.jumpPower = v end)
addToggle(pPlayer, "infjump", "Infinite Jump", "Jump again in mid-air", function(v) return setFeature("infjump", v) end)
addToggle(pPlayer, "noclip", "Noclip", "Walk through walls", function(v) return setFeature("noclip", v) end)
addToggle(pPlayer, "fly", "Fly", "Camera-relative flight; Space up, Ctrl down", function(v) return setFeature("fly", v) end)
addSlider(pPlayer, "Fly speed", 10, 200, Settings.flySpeed, "", function(v) Settings.flySpeed = v end)
addToggle(pPlayer, "antiafk", "Anti AFK", "Stops the idle kick", function(v) return setFeature("antiafk", v) end)
addButton(pPlayer, "Reset character", "Respawn right now", "Reset", function()
    local h = getHum()
    if h then h.Health = 0 end
end)

-- Visuals page --------------------------------------------------
addToggle(pVisuals, "esp", "Player ESP", "Outline, name, distance and health", function(v) return setFeature("esp", v) end)
addSlider(pVisuals, "ESP distance", 100, 3000, Settings.espDistance, " st", function(v) Settings.espDistance = v end)
addToggle(pVisuals, "espnames", "ESP names", "Show the name tag above players", function(v)
    Settings.espNames = v
    return true
end)
addToggle(pVisuals, "espteam", "ESP teammates", "Include players on your team", function(v)
    Settings.espTeam = v
    return true
end)
addToggle(pVisuals, "fullbright", "Fullbright", "Removes darkness and fog", function(v) return setFeature("fullbright", v) end)
addToggle(pVisuals, "fov", "Field of view", "Locks camera FOV", function(v) return setFeature("fov", v) end)
addSlider(pVisuals, "FOV value", 40, 120, Settings.fov, "", function(v) Settings.fov = v end)

-- Utility page --------------------------------------------------
local function playerList()
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then list[#list + 1] = p end
    end
    table.sort(list, function(a, b) return a.Name:lower() < b.Name:lower() end)
    return list
end

do
    local card = makeCard(pUtility, "Target player", nil)
    local nameLabel = new("TextLabel", {
        Position = UDim2.fromOffset(12, 30), Size = UDim2.new(1, -118, 0, 26), BackgroundTransparency = 1,
        Font = FONT_B, TextSize = 13, TextColor3 = C.orange2, Text = "none", TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
    }, card)
    local function refresh()
        if Target and not Target.Parent then Target = nil end
        nameLabel.Text = Target and Target.DisplayName or "none"
    end
    local function cycle(step)
        local list = playerList()
        if #list == 0 then Target = nil refresh() return end
        local idx = 0
        for i, p in ipairs(list) do if p == Target then idx = i end end
        idx = ((idx - 1 + step) % #list) + 1
        Target = list[idx]
        refresh()
    end
    local prev = smallButton(card, "‹", UDim2.new(1, -94, 0, 8), UDim2.fromOffset(26, 22))
    local nextB = smallButton(card, "›", UDim2.new(1, -64, 0, 8), UDim2.fromOffset(26, 22))
    local go = smallButton(card, "Teleport", UDim2.new(1, -94, 0, 34), UDim2.fromOffset(82, 24), C.orange)
    prev.MouseButton1Click:Connect(function() cycle(-1) end)
    nextB.MouseButton1Click:Connect(function() cycle(1) end)
    go.MouseButton1Click:Connect(function()
        local root = getRoot()
        local tr = Target and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart")
        if root and tr then
            root.CFrame = tr.CFrame + Vector3.new(0, 3, 0)
            toast("Teleported to " .. Target.DisplayName)
        else
            toast("No valid target")
        end
    end)
    keep(Players.PlayerRemoving:Connect(function() task.defer(refresh) end))
end

addToggle(pUtility, "spectate", "Spectate target", "Camera follows the selected player", function(v)
    if v and not (Target and Target.Character) then
        toast("Select a target first")
        return false
    end
    return setFeature("spectate", v)
end)
addButton(pUtility, "Rejoin", "Rejoin this server", "Rejoin", function()
    toast("Rejoining...")
    local ok = pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end)
    if not ok then pcall(function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end) end
end)
addButton(pUtility, "Server hop", "Join a less crowded server", "Hop", function()
    task.spawn(function()
        local ok = pcall(function()
            local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
            local data = HttpService:JSONDecode(game:HttpGet(url))
            local pick
            for _, sv in ipairs(data.data or {}) do
                if sv.id ~= game.JobId and sv.playing and sv.maxPlayers and sv.playing < sv.maxPlayers - 1 then
                    if not pick or sv.playing < pick.playing then pick = sv end
                end
            end
            if not pick then toast("No free server found") return end
            toast("Hopping...")
            TeleportService:TeleportToPlaceInstance(game.PlaceId, pick.id, LocalPlayer)
        end)
        if not ok then toast("Server list unavailable") end
    end)
end)
addButton(pUtility, "Copy Job ID", "Current server id", "Copy", function()
    local sc = setclipboard or toclipboard
    if sc then
        pcall(sc, tostring(game.JobId))
        toast("Job ID copied")
    else
        toast("Clipboard not supported here")
    end
end)

-- Settings page -------------------------------------------------
addSlider(pSettings, "Menu scale", 70, 120, 100, "%", function(v)
    Settings.uiScale = v / 100
    winScale.Scale = currentScale()
end)
addToggle(pSettings, "glow", "Glow animation", "Animated green-orange glow", function(v)
    Settings.glow = v
    return true
end)
addToggle(pSettings, "notify", "Notifications", "Small pop-ups at the bottom", function(v)
    Settings.notifications = v
    return true
end)
addButton(pSettings, "Unload hub", "Disable everything and remove the UI", "Unload", function()
    Hub.Unload()
end)

-- default toggle visuals for options that start enabled
toggleSetters.espnames(true)
toggleSetters.espteam(true)
toggleSetters.glow(true)
toggleSetters.notify(true)

Hub.syncToggle = function(id, v)
    if toggleSetters[id] then toggleSetters[id](v) end
end
Hub.syncSpectate = function(v) Hub.syncToggle("spectate", v) end

-- floating button ---------------------------------------------
local fab = new("TextButton", {
    Name = "Fab", Position = UDim2.new(0, 14, 0.5, -22), Size = UDim2.fromOffset(44, 44),
    BackgroundColor3 = C.panel, BorderSizePixel = 0, Text = "", AutoButtonColor = false, ZIndex = 50,
}, gui)
corner(fab, 22)
glowStroke(fab, 2, 0.05)
local fabLabel = new("TextLabel", {
    Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Font = FONT_K, TextSize = 22, Text = "L",
    TextColor3 = Color3.new(1, 1, 1), ZIndex = 51,
}, fab)
new("UIGradient", { Color = GRADIENT, Rotation = 45 }, fabLabel)

local function setOpen(open)
    if open then
        win.Visible = true
        winScale.Scale = currentScale() * 0.92
        tween(winScale, 0.22, { Scale = currentScale() })
        showTab(activeTab)
    else
        win.Visible = false
    end
end
local function toggleOpen() setOpen(not win.Visible) end

-- fab drag vs click
do
    local down, moved, startPos, startInput
    fab.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            down, moved = true, false
            startPos, startInput = fab.Position, input.Position
        end
    end)
    keep(UserInputService.InputChanged:Connect(function(input)
        if not down then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local d = input.Position - startInput
            if d.Magnitude > 6 then moved = true end
            if moved then
                fab.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
            end
        end
    end))
    keep(UserInputService.InputEnded:Connect(function(input)
        if not down then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            down = false
            if not moved then toggleOpen() end
        end
    end))
end

-- window drag (banner)
do
    local down, startPos, startInput
    banner.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            down, startPos, startInput = true, win.Position, input.Position
        end
    end)
    keep(UserInputService.InputChanged:Connect(function(input)
        if not down then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local d = (input.Position - startInput) / math.max(winScale.Scale, 0.01)
            win.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end))
    keep(UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            down = false
        end
    end))
end

btnClose.MouseButton1Click:Connect(function() setOpen(false) end)
keep(UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then toggleOpen() end
end))
local camConn
local function hookCamera()
    local cam = Workspace.CurrentCamera
    if camConn then camConn:Disconnect() camConn = nil end
    if cam then
        camConn = cam:GetPropertyChangedSignal("ViewportSize"):Connect(function()
            if win.Visible then winScale.Scale = currentScale() end
        end)
    end
end
hookCamera()
keep(function() if camConn then camConn:Disconnect() end end)
keep(Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(hookCamera))
winScale.Scale = currentScale()

-- animation + stats loop
do
    local acc, frames, t = 0, 0, 0
    keep(RunService.RenderStepped:Connect(function(dt)
        acc = acc + dt
        frames = frames + 1
        if Settings.glow then
            t = t + dt
            local rot = (t * 70) % 360
            for gi = #glowGradients, 1, -1 do
                local g = glowGradients[gi]
                if g.Parent then g.Rotation = rot else table.remove(glowGradients, gi) end
            end
            titleGrad.Offset = Vector2.new(math.sin(t * 0.8) * 0.15, 0)
            bannerGrad.Rotation = 20 + math.sin(t * 0.5) * 8
        end
        if acc >= 0.5 then
            chipFps.Text = "FPS " .. tostring(math.floor(frames / acc + 0.5))
            local ping = 0
            pcall(function() ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue() end)
            chipPing.Text = "PING " .. tostring(math.floor(ping + 0.5))
            chipPlayers.Text = "PLAYERS " .. tostring(#Players:GetPlayers())
            acc, frames = 0, 0
        end
    end))
end

-- ============================================================
-- Unload
-- ============================================================
function Hub.Unload()
    pcall(function() stopCandyFarm("Idle") end)
    if not Hub.alive then return end
    Hub.alive = false
    for id, f in pairs(Features) do
        if f.enabled then
            f.enabled = false
            pcall(f.off)
        end
    end
    clearAllESP()
    cleanJanitor()
    if env.LIBERIUM_HUB == Hub then env.LIBERIUM_HUB = nil end
end
Hub.Features = Features
Hub.setFeature = setFeature
Hub.Settings = Settings
Hub.Open = setOpen
env.LIBERIUM_HUB = Hub

showTab(1)
setOpen(true)
toast("LIBERIUM HUB " .. VERSION .. " loaded")
