--[[
    DA-DA Mini v9 — LITE (убраны FE Anim, Weapon Skins, Griddy)
    Author: dada (2025)
    Loader: loadstring(game:HttpGet("URL"))()
]]--

print("[DaDa v9] BOOT START")
local _DaDaBootLabel, _DaDaBootSub, _DaDaBootFrame
do
    local sg = Instance.new("ScreenGui")
    sg.Name = "DaDaBoot"
    sg.ResetOnSpawn = false
    pcall(function() sg.Parent = game:GetService("CoreGui") end)
    if not sg.Parent then
        pcall(function() sg.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui") end)
    end

    local f = Instance.new("Frame")
    f.Size = UDim2.new(0, 380, 0, 90)
    f.Position = UDim2.new(0.5, -190, 0, 100)
    f.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    f.BorderSizePixel = 0
    f.Parent = sg
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
    local s = Instance.new("UIStroke", f)
    s.Color = Color3.fromRGB(180, 80, 255)
    s.Thickness = 2

    local t = Instance.new("TextLabel", f)
    t.Size = UDim2.new(1, -20, 0, 30)
    t.Position = UDim2.new(0, 10, 0, 10)
    t.BackgroundTransparency = 1
    t.Text = "DA-DA Mini v9 — загрузка..."
    t.TextColor3 = Color3.new(1, 1, 1)
    t.TextSize = 16
    t.Font = Enum.Font.GothamBold

    local d = Instance.new("TextLabel", f)
    d.Size = UDim2.new(1, -20, 0, 40)
    d.Position = UDim2.new(0, 10, 0, 45)
    d.BackgroundTransparency = 1
    d.Text = "Если висит больше 5 сек — скрипт упал"
    d.TextColor3 = Color3.fromRGB(180, 180, 200)
    d.TextSize = 12
    d.Font = Enum.Font.Gotham
    d.TextWrapped = true

    _DaDaBootFrame, _DaDaBootLabel, _DaDaBootSub = f, t, d
end

local _OK, _ERR = pcall(function()

-- ============================================
-- СЕРВИСЫ
-- ============================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Workspace = workspace
local Camera = Workspace.CurrentCamera

-- ============ NOTIFY ============
local notifyGui = Instance.new("ScreenGui")
notifyGui.Name = "DaDaNotify"
notifyGui.ResetOnSpawn = false
pcall(function() notifyGui.Parent = CoreGui end)
if not notifyGui.Parent then notifyGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local notifyHolder = Instance.new("Frame")
notifyHolder.Size = UDim2.new(0, 260, 1, -20)
notifyHolder.Position = UDim2.new(1, -270, 0, 10)
notifyHolder.BackgroundTransparency = 1
notifyHolder.Parent = notifyGui

local notifyList = Instance.new("UIListLayout")
notifyList.Padding = UDim.new(0, 6)
notifyList.VerticalAlignment = Enum.VerticalAlignment.Bottom
notifyList.SortOrder = Enum.SortOrder.LayoutOrder
notifyList.Parent = notifyHolder

local function notify(title, text)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 50)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    frame.BackgroundTransparency = 0.05
    frame.BorderSizePixel = 0
    frame.Parent = notifyHolder
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 8) c.Parent = frame
    local s = Instance.new("UIStroke") s.Color = Color3.fromRGB(180, 80, 255) s.Thickness = 1.2 s.Parent = frame
    local acc = Instance.new("Frame")
    acc.Size = UDim2.new(0, 3, 1, -12)
    acc.Position = UDim2.new(0, 4, 0, 6)
    acc.BackgroundColor3 = Color3.fromRGB(180, 80, 255)
    acc.BorderSizePixel = 0
    acc.Parent = frame
    local ac = Instance.new("UICorner") ac.CornerRadius = UDim.new(1, 0) ac.Parent = acc
    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1, -24, 0, 20) t.Position = UDim2.new(0, 14, 0, 6)
    t.BackgroundTransparency = 1 t.Text = title t.TextColor3 = Color3.new(1, 1, 1)
    t.TextSize = 12 t.Font = Enum.Font.GothamBold
    t.TextXAlignment = Enum.TextXAlignment.Left t.Parent = frame
    local d = Instance.new("TextLabel")
    d.Size = UDim2.new(1, -24, 0, 20) d.Position = UDim2.new(0, 14, 0, 26)
    d.BackgroundTransparency = 1 d.Text = text d.TextColor3 = Color3.fromRGB(180, 180, 190)
    d.TextSize = 11 d.Font = Enum.Font.Gotham
    d.TextXAlignment = Enum.TextXAlignment.Left d.Parent = frame
    frame.Position = UDim2.new(1, 300, 0, 0)
    TweenService:Create(frame, TweenInfo.new(0.25), {Position = UDim2.new(0, 0, 0, 0)}):Play()
    task.delay(3, function()
        TweenService:Create(frame, TweenInfo.new(0.25), {Position = UDim2.new(1, 300, 0, 0)}):Play()
        task.wait(0.3)
        frame:Destroy()
    end)
end

-- ============ SETTINGS ============
local S = {
    silent = false, wallshot = false, predict = true,
    autoGrab = false, standOff = 15,
    knifeAim = false, killAura = false, killAuraDist = 20,
    tracer = false, aura = false, auraName = "Angel",
    chinaHat = false,
    flingBypass = false, touchFling = false,
    esp = false, espName = false,
    antiFling = false, antiVoid = false, am_sheriff = false,
    walkSpeed = false, walkSpeedVal = 40,
    jumpPower = false, jumpPowerVal = 80,
    fly = false, flySpeed = 60,
    noclip = false, bhop = false,
    customFov = false, fovValue = 70,
    aspectRatio = false,
}
local MAX_RANGE = 300

local round_mod = nil
local function get_round()
    if round_mod then return round_mod end
    local ok, m = pcall(function()
        return require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("CurrentRoundClient"))
    end)
    if ok and type(m) == "table" then round_mod = m end
    return round_mod
end

local function holds(c, n) return c ~= nil and c:FindFirstChild(n) ~= nil end
local function lp_has_gun()
    return holds(LocalPlayer.Character, "Gun") or holds(LocalPlayer:FindFirstChildOfClass("Backpack"), "Gun")
end

-- ============ SILENT AIM ============
local target_player, target_char, target_part, target_hum = nil, nil, nil, nil

local function refresh_target()
    local found = nil
    local m = get_round()
    local data = m and m.PlayerData or nil
    if type(data) == "table" then
        local me = data[LocalPlayer.Name]
        S.am_sheriff = (me ~= nil and (me.Role == "Sheriff" or me.Role == "Hero")) or lp_has_gun()
        for name, d in pairs(data) do
            if type(d) == "table" and d.Role == "Murderer" and not d.Dead then
                found = Players:FindFirstChild(name) break
            end
        end
    else S.am_sheriff = lp_has_gun() end
    if not found then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and holds(plr.Character, "Knife") then found = plr break end
        end
    end
    if found ~= target_player then
        target_player = found
        target_char = nil target_part = nil target_hum = nil
    end
    if not found then return end
    local char = found.Character
    if char ~= target_char then
        target_char = char target_part = nil target_hum = nil
    end
    if not char then return end
    if not target_part or not target_part.Parent then
        target_part = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    end
    if not target_hum or not target_hum.Parent then
        target_hum = char:FindFirstChildOfClass("Humanoid")
    end
end

local function target_alive()
    if not target_part or not target_part.Parent then return false end
    if not target_hum or not target_hum.Parent then return false end
    return target_hum.Health > 0
end

local ray_params = RaycastParams.new()
ray_params.FilterType = Enum.RaycastFilterType.Exclude
ray_params.IgnoreWater = false
local ignore_base, ignore_work, ignore_time = {}, {}, 0

local function refresh_ignore()
    local now = os.clock()
    if #ignore_base > 0 and now - ignore_time < 0.5 then return end
    ignore_time = now
    table.clear(ignore_base)
    local char = LocalPlayer.Character
    if char then ignore_base[1] = char end
    local ok, tagged = pcall(function() return CollectionService:GetTagged("WeaponPassthrough") end)
    if ok and type(tagged) == "table" then
        for k = 1, #tagged do ignore_base[#ignore_base + 1] = tagged[k] end
    end
end

local function trace(origin, direction)
    refresh_ignore()
    table.clear(ignore_work)
    for k = 1, #ignore_base do ignore_work[k] = ignore_base[k] end
    local result = nil
    for _ = 1, 6 do
        ray_params.FilterDescendantsInstances = ignore_work
        result = Workspace:Raycast(origin, direction, ray_params)
        if not result then break end
        local inst = result.Instance
        if not inst then break end
        local ok, tr = pcall(function() return inst.Transparency end)
        if not ok or tr ~= 1 then break end
        ignore_work[#ignore_work + 1] = inst
    end
    return result
end

local function gun_attachment()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil, nil end
    return hrp:FindFirstChild("GunRaycastAttachment"), hrp
end

local function origin_cframe()
    local att, hrp = gun_attachment()
    if att then return att.WorldCFrame end
    if hrp then return hrp.CFrame end
end

-- ============ PREDICTION ============
local P = { snap = 48, ring = 48, hit_r = 2.1, pad = 2.6, min_span = 5, max_span = 90,
    acc_t = 0.15, acc_max = 280, acc_min = 40, speed_floor = 26, speed_head = 1.3 }
local snap_t = table.create(P.snap, 0)
local snap_p = table.create(P.snap, Vector3.zero)
local snap_n, snap_i = 0, 0
local SK = { vt = table.create(P.ring, 0), dx = table.create(P.ring, 0), dz = table.create(P.ring, 0), vn = 0, vi = 0 }
local EC = { ping = 0, rtt = 0, jitter = 0, seen = false, step = 0, step_seen = false }
local TR = { part = nil, pos = nil, time = 0, vel = Vector3.zero, gap = 0, ready = false,
    fresh = Vector3.zero, air = false, air_since = 0, jumping = false, jump_v = 0,
    fresh_ok = false, turn = 0, spoof = 0, clr = 0, air_edge = 0, jump_fresh = false }
local KIN = { ok = false, ax = 0, az = 0, smax = 0 }
local GC = { base = 0, seen = false }
local JL = { v = 0, seen = false }
local HY = { pos = {}, w = {}, n = 0, weight = 0, primary = nil, stamp = 0, conf = 0 }

local function snap_push(now, pos)
    snap_i = snap_i % P.snap + 1
    snap_t[snap_i] = now
    snap_p[snap_i] = pos
    if snap_n < P.snap then snap_n = snap_n + 1 end
end
local function snap_get(k)
    local idx = (snap_i - k - 1) % P.snap + 1
    return snap_t[idx], snap_p[idx]
end
local function sample_span()
    local span = math.max(EC.step, TR.gap)
    if span <= 0 then return 0 end
    return span
end
local function raw_rtt()
    local a, b
    local ok, ms = pcall(function() return Stats.Network.ServerStatsItem["Data Ping"]:GetValue() end)
    if ok and type(ms) == "number" and ms == ms and ms > 4 and ms < 800 then a = ms / 1000 end
    local fine, value = pcall(function() return LocalPlayer:GetNetworkPing() end)
    if fine and type(value) == "number" and value == value and value > 0 then
        local rtt = value * 2
        if rtt > 0.004 and rtt < 0.8 then b = rtt end
    end
    if a and b then return (a + b) * 0.5 end
    return a or b
end
local function sample_ping()
    local rtt = raw_rtt()
    if not rtt or rtt ~= rtt then return end
    rtt = math.clamp(rtt, 0, 1)
    if EC.seen then
        EC.jitter = EC.jitter * 0.9 + math.abs(rtt - EC.rtt) * 0.1
        EC.rtt = EC.rtt * 0.82 + rtt * 0.18
    else EC.rtt = rtt EC.jitter = 0 EC.seen = true end
    EC.ping = EC.rtt
end
local function lead_time()
    if not EC.seen then return 0 end
    local stale = 0
    if TR.time > 0 and EC.step_seen then stale = math.clamp(os.clock() - TR.time, 0, EC.step) end
    return math.clamp(EC.rtt + EC.jitter * 0.5 + stale, 0, 1)
end
local function grav()
    local ok, g = pcall(function() return workspace.Gravity end)
    if ok and type(g) == "number" and g > 0 then return g end
    return 0
end
local function step_push(dt)
    if dt <= 0 or dt > 0.5 then return end
    if EC.step_seen then EC.step = EC.step * 0.85 + dt * 0.15
    else EC.step = dt EC.step_seen = true end
end
local function fit_velocity()
    if snap_n < 3 then return nil end
    local newest = snap_get(0)
    local used = 0
    local sum_d = 0
    local win = sample_span() * 4
    for k = 0, snap_n - 1 do
        local t = snap_get(k)
        if newest - t > win then break end
        used = used + 1
        sum_d = sum_d + t - newest
    end
    if used < 3 then return nil end
    local mean_d = sum_d / used
    local num = Vector3.zero
    local den = 0
    for k = 0, used - 1 do
        local t, p = snap_get(k)
        local d = t - newest - mean_d
        num = num + p * d
        den = den + d * d
    end
    if den < 1e-8 then return nil end
    return num / den, -mean_d
end
local function recent_velocity()
    if snap_n < 2 then return nil end
    local newest, head = snap_get(0)
    local fallback, fallback_age = nil, nil
    local target_span = sample_span() * 2
    local max_span = target_span * 2
    for k = 1, snap_n - 1 do
        local t, p = snap_get(k)
        local dt = newest - t
        if dt > max_span then break end
        if dt > 0 then
            fallback = (head - p) / dt
            fallback_age = dt * 0.5
            if dt >= target_span then return fallback, fallback_age end
        end
    end
    return fallback, fallback_age
end
local function kin_clear()
    KIN.ok = false KIN.ax = 0 KIN.az = 0 KIN.smax = 0
end
local function fit_kin()
    if snap_n < 5 then return nil end
    local t0 = snap_get(0)
    local win = math.max(sample_span() * 5, 0.12)
    local scale = win
    local n, s1, s2, s3, s4 = 0, 0, 0, 0, 0
    local bx0, bx1, bx2 = 0, 0, 0
    local bz0, bz1, bz2 = 0, 0, 0
    for k = 0, snap_n - 1 do
        local t, p = snap_get(k)
        local age = t0 - t
        if age > win then break end
        local u = -age / scale
        local u2 = u * u
        n = n + 1
        s1 = s1 + u s2 = s2 + u2 s3 = s3 + u2 * u s4 = s4 + u2 * u2
        bx0 = bx0 + p.X bx1 = bx1 + p.X * u bx2 = bx2 + p.X * u2
        bz0 = bz0 + p.Z bz1 = bz1 + p.Z * u bz2 = bz2 + p.Z * u2
    end
    if n < 5 then return nil end
    local det = n * (s2 * s4 - s3 * s3) - s1 * (s1 * s4 - s3 * s2) + s2 * (s1 * s3 - s2 * s2)
    if math.abs(det) < 1e-9 then return nil end
    local function solve(b0, b1, b2)
        local d1 = n * (b1 * s4 - s3 * b2) - b0 * (s1 * s4 - s3 * s2) + s2 * (s1 * b2 - b1 * s2)
        local d2 = n * (s2 * b2 - b1 * s3) - s1 * (s1 * b2 - b1 * s2) + b0 * (s1 * s3 - s2 * s2)
        return d1 / det, d2 / det
    end
    local cx1, cx2 = solve(bx0, bx1, bx2)
    local cz1, cz2 = solve(bz0, bz1, bz2)
    local vx, vz = cx1 / scale, cz1 / scale
    local ax, az = 2 * cx2 / (scale * scale), 2 * cz2 / (scale * scale)
    if vx ~= vx or vz ~= vz or ax ~= ax or az ~= az then return nil end
    return Vector3.new(vx, 0, vz), Vector3.new(ax, 0, az)
end
local function kin_update()
    local kv, ka = fit_kin()
    if not kv then KIN.ok = false KIN.ax = 0 KIN.az = 0 return nil end
    KIN.ok = true
    local sp = math.sqrt(kv.X * kv.X + kv.Z * kv.Z)
    if sp > KIN.smax then KIN.smax = sp else KIN.smax = KIN.smax * 0.985 + sp * 0.015 end
    if ka and not TR.air then
        local am = math.sqrt(ka.X * ka.X + ka.Z * ka.Z)
        local ax, az = ka.X, ka.Z
        if am > P.acc_max and am > 0 then ax = ax * P.acc_max / am az = az * P.acc_max / am end
        KIN.ax = KIN.ax * 0.5 + ax * 0.5
        KIN.az = KIN.az * 0.5 + az * 0.5
    else KIN.ax = KIN.ax * 0.5 KIN.az = KIN.az * 0.5 end
    return kv
end
local function snap_vel(k)
    local t0, p0 = snap_get(k)
    local t1, p1 = snap_get(k + 1)
    local d = t0 - t1
    if d <= 0 then return nil end
    return (p0 - p1) / d, d
end
local function vert_accel()
    if snap_n < 3 then return nil end
    local v0, d0 = snap_vel(0)
    local v1, d1 = snap_vel(1)
    if not v0 or not v1 then return nil end
    local span = (d0 + d1) * 0.5
    if span <= 1e-4 then return nil end
    return (v0.Y - v1.Y) / span
end
local function air_vy()
    if snap_n < 2 then return nil end
    local edge = TR.air_edge
    if edge <= 0 then return nil end
    local g = grav()
    local newest, head = snap_get(0)
    local want = sample_span() * 2
    local best = nil
    for k = 1, snap_n - 1 do
        local t, p = snap_get(k)
        if t < edge then break end
        local dt = newest - t
        if dt > 1e-4 then
            best = (head.Y - p.Y) / dt - 0.5 * g * dt
            if dt >= want then break end
        end
    end
    return best
end
local function body_clearance()
    local part = target_part
    local hum = target_hum
    if not part or not hum then return 0 end
    local ok, value = pcall(function() return part.Size.Y * 0.5 + hum.HipHeight end)
    if ok and type(value) == "number" and value > 0 then return value end
    return 0
end
local function stand_clearance()
    if GC.seen then return GC.base end
    return body_clearance()
end

local ground_params = RaycastParams.new()
ground_params.FilterType = Enum.RaycastFilterType.Exclude
ground_params.IgnoreWater = true
local ground_filter = {}

local function ground_below(pos, reach)
    table.clear(ground_filter)
    local n = 0
    local char = target_char
    if char then n = n + 1 ground_filter[n] = char end
    local mine = LocalPlayer.Character
    if mine then n = n + 1 ground_filter[n] = mine end
    ground_params.FilterDescendantsInstances = ground_filter
    local res = workspace:Raycast(pos, Vector3.new(0, -reach, 0), ground_params)
    if res then return res.Position.Y end
    return nil
end

local function engine_vel(part)
    local ok, v = pcall(function() return part.AssemblyLinearVelocity end)
    if not ok or typeof(v) ~= "Vector3" then
        ok, v = pcall(function() return part.Velocity end)
    end
    if not ok or typeof(v) ~= "Vector3" then return nil end
    if v.Magnitude ~= v.Magnitude then return nil end
    return v
end
local function vel_trust(pv, ev)
    if not pv or not ev then return 0 end
    local ph = Vector3.new(pv.X, 0, pv.Z)
    local eh = Vector3.new(ev.X, 0, ev.Z)
    local pm, em = ph.Magnitude, eh.Magnitude
    if pm < 1 and em < 1 then return 1 end
    if pm < 1 or em < 1 then return 0 end
    local ratio = em / pm
    if ratio > 1.5 or ratio < 0.6 then return 0 end
    local align = ph.Unit:Dot(eh.Unit)
    if align < 0.7 then return 0 end
    local a = math.clamp((align - 0.7) / 0.25, 0, 1)
    local r = 1 - math.clamp(math.abs(ratio - 1) / 0.4, 0, 1)
    return a * r
end
local function phase_velocity(v, age, air)
    if not v then return nil end
    local y = 0
    if air then y = v.Y - grav() * math.clamp(age or 0, 0, sample_span() * 4) end
    return Vector3.new(v.X, y, v.Z)
end
local function merge_vel(fit, fit_age, fast, fast_age, engine, engine_age, air)
    local stable = phase_velocity(fit, fit_age, air)
    local instant = phase_velocity(fast, fast_age, air)
    local turn = 0
    if stable and instant then
        local sh = Vector3.new(stable.X, 0, stable.Z)
        local ih = Vector3.new(instant.X, 0, instant.Z)
        if sh.Magnitude > 1 and ih.Magnitude > 1 then
            turn = math.acos(math.clamp(sh.Unit:Dot(ih.Unit), -1, 1)) / math.pi
        end
    end
    local base = instant or stable
    if not base then return Vector3.zero, 0, nil, 0 end
    if stable and instant then
        local agility = math.clamp(turn * 2.2, 0, 1)
        base = stable:Lerp(instant, 0.4 + 0.6 * agility)
    end
    local trust = 0
    if engine then
        local live = phase_velocity(engine, engine_age, air)
        trust = vel_trust(base, live)
        if trust > 0 and air then
            base = Vector3.new(base.X, base.Y, base.Z):Lerp(Vector3.new(base.X, live.Y, base.Z), trust * 0.35)
        end
    end
    return base, turn, instant or stable, trust
end
local function track_clear()
    TR.part = nil TR.pos = nil TR.vel = Vector3.zero TR.gap = 0 TR.ready = false
    TR.fresh = Vector3.zero TR.air = false TR.jumping = false TR.jump_v = 0
    TR.fresh_ok = false TR.turn = 0 TR.spoof = 0 TR.clr = 0 TR.air_edge = 0 TR.jump_fresh = false
    GC.base = 0 GC.seen = false JL.v = 0 JL.seen = false
    snap_n, snap_i = 0, 0 SK.vn, SK.vi = 0, 0
    kin_clear()
end
local function track_seed(part, pos, now)
    TR.part = part TR.pos = pos TR.time = now TR.vel = Vector3.zero TR.fresh = Vector3.zero
    TR.fresh_ok = false TR.turn = 0 TR.jump_v = 0 TR.gap = 0 TR.ready = false TR.spoof = 0
    TR.air_edge = 0 TR.jump_fresh = false GC.base = 0 GC.seen = false
    snap_n, snap_i = 0, 0 kin_clear() snap_push(now, pos)
end
local function track_fresh(now)
    local part = target_part
    if not part or not part.Parent then TR.fresh_ok = false return end
    local pos = part.Position
    local g = grav()
    local sv = snap_vel(0)
    local vy = sv and sv.Y or 0
    local accel = vert_accel()
    local falling = accel ~= nil and accel < -g * 0.5
    local guess = stand_clearance()
    local reach = guess + 6 + math.abs(vy) * sample_span() * 4
    local air
    local gy = ground_below(pos, reach)
    if gy then
        local clr = pos.Y - gy
        TR.clr = clr
        if math.abs(vy) < 1 and not falling then
            if GC.seen then
                if clr < GC.base then GC.base = GC.base * 0.7 + clr * 0.3
                else GC.base = GC.base * 0.98 + clr * 0.02 end
            else GC.base = clr GC.seen = true end
        end
        local floor = GC.seen and GC.base or guess
        local tol = math.max(floor * 0.35, 1)
        air = clr > floor + tol
        if not air and falling and math.abs(vy) > 4 and clr > floor + 0.35 then air = true end
    else air = true end
    if air ~= TR.air then
        TR.air_edge = now
        if air then TR.air_since = now TR.jump_fresh = true TR.jump_v = JL.seen and JL.v or math.max(vy, 0)
        else TR.jump_fresh = false TR.jump_v = 0 end
    end
    local model_vy = TR.jump_v - g * math.max(0, now - TR.air_since)
    TR.air = air
    TR.jumping = air and (vy > 1 or model_vy > 1)
end
local function track(now)
    local part = target_part
    if not part or not part.Parent then
        if TR.part then track_clear() end
        return
    end
    track_fresh(now)
    local pos = part.Position
    if part ~= TR.part or not TR.pos then track_seed(part, pos, now) return end
    local dt = now - TR.time
    if dt > 0.75 or (pos - TR.pos).Magnitude > 140 then track_seed(part, pos, now) return end
    if dt <= 0 then return end
    if (pos - TR.pos).Magnitude == 0 then
        if TR.gap > 0 and dt >= TR.gap then TR.vel = Vector3.zero TR.fresh = Vector3.zero end
        return
    end
    step_push(dt)
    TR.gap = dt
    snap_push(now, pos)
    TR.pos = pos TR.time = now
    local fit, fit_age = fit_velocity()
    local fast, fast_age = recent_velocity()
    local engine = engine_vel(part)
    local fresh, turn, instant, trust = merge_vel(fit, fit_age, fast, fast_age, engine, sample_span() * 0.5, TR.air)
    local kv = kin_update()
    if kv then fresh = Vector3.new(kv.X, fresh.Y, kv.Z) end
    if engine and trust <= 0 then
        if TR.spoof < 20 then TR.spoof = TR.spoof + 1 end
    elseif TR.spoof > 0 then TR.spoof = TR.spoof - 1 end
    if TR.air then
        local vy = air_vy()
        if vy then
            fresh = Vector3.new(fresh.X, vy, fresh.Z)
            local since = math.max(0, now - TR.air_edge)
            if TR.jump_fresh and since <= 0.2 then
                local impulse = vy + grav() * since
                if impulse > 1 then
                    if JL.seen then JL.v = JL.v * 0.7 + impulse * 0.3
                    else JL.v = impulse JL.seen = true end
                    if impulse > TR.jump_v then TR.jump_v = impulse end
                end
            else TR.jump_fresh = false end
        end
    end
    TR.vel = fresh
    TR.ready = fit ~= nil or fast ~= nil
    TR.fresh = TR.vel
    TR.fresh_ok = TR.ready
    TR.turn = turn
    local raw = instant or fresh
    SK.vi = SK.vi % P.ring + 1
    SK.vt[SK.vi] = now
    SK.dx[SK.vi] = raw.X
    SK.dz[SK.vi] = raw.Z
    if SK.vn < P.ring then SK.vn = SK.vn + 1 end
end
local function dir_stats(win)
    if SK.vn < 4 then return 1, 0 end
    win = math.max(win, sample_span() * 3)
    local newest = SK.vt[SK.vi]
    local sx, sz, n = 0, 0, 0
    local prev = nil
    local turn, turn_n = 0, 0
    local oldest = newest
    for k = 0, SK.vn - 1 do
        local idx = (SK.vi - k - 1) % P.ring + 1
        local t = SK.vt[idx]
        if newest - t > win then break end
        local hx, hz = SK.dx[idx], SK.dz[idx]
        local m = math.sqrt(hx * hx + hz * hz)
        if m > 0 then
            sx = sx + hx / m sz = sz + hz / m n = n + 1
            local ang = math.atan2(hz, hx)
            if prev then
                local d = ang - prev
                while d > math.pi do d = d - 6.2831853 end
                while d < -math.pi do d = d + 6.2831853 end
                turn = turn + d turn_n = turn_n + 1
            end
            prev = ang oldest = t
        end
    end
    if n < 2 then return 1, 0 end
    local coh = math.clamp(math.sqrt(sx * sx + sz * sz) / n, 0, 1)
    local omega = 0
    local elapsed = newest - oldest
    if turn_n >= 1 and elapsed > 1e-3 then omega = -turn / elapsed end
    return coh, omega
end
local function rotate_y(v, ang)
    local c, s = math.cos(ang), math.sin(ang)
    return Vector3.new(v.X * c - v.Z * s, v.Y, v.X * s + v.Z * c)
end
local function predict_from(base, sa, sb, fh, now)
    local span = math.max(0, sa + sb)
    local g = grav()
    local dir = fh
    if dir.Magnitude == 0 then dir = Vector3.new(TR.vel.X, 0, TR.vel.Z) end
    local x, z
    if span > 0 and KIN.ok then
        local age = math.clamp(now - TR.time, 0, sample_span() * 2)
        local ax, az = KIN.ax, KIN.az
        if TR.air or math.sqrt(ax * ax + az * az) < P.acc_min then ax, az = 0, 0 end
        local vx = dir.X + ax * age
        local vz = dir.Z + az * age
        local ta = math.min(span, P.acc_t)
        local dx = vx * span + 0.5 * ax * ta * ta
        local dz = vz * span + 0.5 * az * ta * ta
        local reach = math.sqrt(dx * dx + dz * dz)
        local cap = math.max(KIN.smax * P.speed_head, P.speed_floor) * span
        if reach > cap and reach > 1e-6 then dx = dx * cap / reach dz = dz * cap / reach end
        x = base.X + dx
        z = base.Z + dz
    else
        local hspan = span
        if span > 0 and dir.Magnitude > 0 and not TR.air then
            local coh, omega = dir_stats(span)
            local conf = math.clamp(coh, 0, 1) * (1 - math.clamp(TR.turn, 0, 1) * 0.5)
            if omega ~= 0 then dir = rotate_y(dir, math.clamp(omega * span * 0.5 * conf, -0.6, 0.6)) end
            hspan = span * (0.85 + 0.15 * conf)
        end
        x = base.X + dir.X * hspan
        z = base.Z + dir.Z * hspan
    end
    local y = base.Y
    if TR.air and span > 0 then
        local vy = TR.vel.Y
        local phase = math.max(0, now - TR.air_since)
        local modeled = TR.jump_v - g * phase
        if TR.jumping and TR.jump_v > 0 and g > 0 and phase <= TR.jump_v / g and modeled > vy then vy = modeled end
        y = base.Y + vy * span - 0.5 * g * span * span
        if y < base.Y then
            local clearance = stand_clearance()
            local reach = base.Y - y + clearance
            local gy = ground_below(Vector3.new(x, base.Y, z), reach)
            if gy then local floor = gy + clearance if y < floor then y = floor end end
        end
    end
    return Vector3.new(x, y, z)
end
local function build_hyps(base, now)
    table.clear(HY.pos) table.clear(HY.w)
    local horizon = S.predict and TR.ready and lead_time() or 0
    local fh = Vector3.new(TR.fresh.X, 0, TR.fresh.Z)
    HY.primary = predict_from(base, 0, horizon, fh, now)
    HY.n = 1 HY.pos[1] = HY.primary HY.w[1] = 1 HY.weight = 1 HY.stamp = now
end
local function score_axis(anchor, axis)
    local covered = 0
    local lo, hi = 0, 0
    for k = 1, HY.n do
        local d = HY.pos[k] - anchor
        local a = d:Dot(axis)
        local perp = (d - axis * a).Magnitude
        if perp <= P.hit_r then
            covered = covered + HY.w[k]
            if a < lo then lo = a end
            if a > hi then hi = a end
        end
    end
    return covered, lo, hi
end
local axis_pool = {}
local function corridor_axes(anchor)
    table.clear(axis_pool)
    local n = 0
    local function add(v)
        if typeof(v) ~= "Vector3" or v.Magnitude < 1e-4 then return end
        local u = v.Unit
        for k = 1, n do if axis_pool[k]:Dot(u) > 0.985 then return end end
        n = n + 1 axis_pool[n] = u
    end
    local fh = Vector3.new(TR.fresh.X, 0, TR.fresh.Z)
    if TR.air then add(TR.fresh) end
    add(fh)
    for k = 1, HY.n do add(HY.pos[k] - anchor) end
    add(TR.fresh)
    add(Vector3.new(0, 1, 0))
    return n
end
local function build_corridor(now)
    local part = target_part
    if not part or not part.Parent then return nil end
    local base = part.Position
    build_hyps(base, now)
    local anchor = HY.primary or base
    local count = corridor_axes(anchor)
    local best_axis, best_cov, best_lo, best_hi = nil, -1, 0, 0
    for k = 1, count do
        local axis = axis_pool[k]
        local cov, lo, hi = score_axis(anchor, axis)
        if cov > best_cov then best_axis, best_cov, best_lo, best_hi = axis, cov, lo, hi end
    end
    if not best_axis then return nil end
    HY.conf = HY.weight > 0 and best_cov / HY.weight or 0
    local pad = P.pad
    local origin = anchor + best_axis * (best_lo - pad)
    local aim = anchor + best_axis * (best_hi + pad)
    if (aim - origin).Magnitude < 4 then origin = anchor - best_axis * 4 aim = anchor + best_axis * 4 end
    return origin, aim, HY.conf, anchor
end
local pred_off = Vector3.zero
local pred_stamp = 0
local function lead_offset()
    local part = target_part
    if not part or not part.Parent then return Vector3.zero end
    if not S.predict or not TR.ready then return Vector3.zero end
    local base = part.Position
    local now = os.clock()
    local fh = Vector3.new(TR.fresh.X, 0, TR.fresh.Z)
    local point = predict_from(base, 0, lead_time(), fh, now)
    local off = point - base
    pred_stamp = now pred_off = off
    return pred_off
end
local hit_names = { "HumanoidRootPart","UpperTorso","Torso","LowerTorso","Head","RightUpperArm","LeftUpperArm","Right Arm","Left Arm","RightUpperLeg","LeftUpperLeg","Right Leg","Left Leg","RightLowerLeg","LeftLowerLeg" }
local hit_parts, hit_count, hit_char = {}, 0, nil
local function refresh_parts()
    local char = target_char
    if char == hit_char then return end
    table.clear(hit_parts)
    hit_count = 0 hit_char = char
    if not char then return end
    for k = 1, #hit_names do
        local part = char:FindFirstChild(hit_names[k])
        if part and part:IsA("BasePart") then
            hit_count = hit_count + 1
            hit_parts[hit_count] = part
        end
    end
end
local function los_clear(origin, point)
    if not origin or not point then return false end
    local delta = point - origin
    local dist = delta.Magnitude
    if dist < 0.5 then return true end
    if dist > MAX_RANGE then return false end
    local hit = trace(origin, delta)
    if not hit then return true end
    local inst = hit.Instance
    local char = target_char
    if inst and char and (inst == char or inst:IsDescendantOf(char)) then return true end
    return (hit.Position - origin).Magnitude >= dist - 0.75
end
local function pick_point(origin, strict)
    refresh_parts()
    if hit_count == 0 then return nil end
    local off = lead_offset()
    local first = nil
    for k = 1, hit_count do
        local part = hit_parts[k]
        if not part.Parent then hit_char = nil
        else
            local point = part.Position + off
            if not origin then return point end
            if not first then first = point end
            if los_clear(origin, point) then return point end
        end
    end
    if strict then return nil end
    return first
end
local force_att, force_saved, force_stamp = nil, nil, 0
local function restore_origin()
    local att = force_att
    if not att then return end
    local saved = force_saved
    force_att, force_saved = nil, nil
    if saved then pcall(function() if att.Parent then att.CFrame = saved end end) end
end
local function push_origin(cf)
    local att = gun_attachment()
    if not att then return false end
    if force_att and force_att ~= att then restore_origin() end
    if not force_att then
        local ok, saved = pcall(function() return att.CFrame end)
        if not ok or typeof(saved) ~= "CFrame" then return false end
        force_att = att force_saved = saved
    end
    force_stamp = os.clock()
    local ok = pcall(function() att.WorldCFrame = cf end)
    if not ok then restore_origin() return false end
    task.defer(restore_origin)
    return true
end
local function is_target_hit(inst)
    local char = target_char
    if not inst or not char then return false end
    return inst == char or inst:IsDescendantOf(char)
end
local function force_clear(origin, aim)
    local hit = trace(origin, aim - origin)
    if not hit then return false end
    return is_target_hit(hit.Instance)
end
local function force_velocity()
    if TR.fresh_ok and TR.fresh.Magnitude > 0.5 then return TR.fresh end
    if TR.ready and TR.vel.Magnitude > 0.5 then return TR.vel end
    return Vector3.zero
end
local function resolve_force()
    local part = target_part
    if not part or not part.Parent then return nil end
    local live = part.Position
    local now = os.clock()
    local origin, aim, conf, anchor = build_corridor(now)
    if origin and aim then
        local axis = aim - origin
        local span = axis.Magnitude
        if span > 1e-3 then
            local u = axis / span
            local mark = anchor or live
            local behind = (mark - origin):Dot(u)
            if behind < P.pad then origin = origin - u * (P.pad - behind) end
            local ahead = (aim - mark):Dot(u)
            if ahead < P.min_span then aim = mark + u * P.min_span end
            local want = S.standOff
            while want > 0 do
                local probe = origin - u * want
                if (aim - probe).Magnitude <= P.max_span and los_clear(probe, mark) and los_clear(probe, live) then origin = probe break end
                want = want - 3
            end
            if (aim - origin).Magnitude > P.max_span then origin = aim - u * P.max_span end
            return CFrame.new(origin, aim), CFrame.new(aim), conf or 0, mark
        end
    end
    local vel = force_velocity()
    local dir = Vector3.new(0, -1, 0)
    if vel.Magnitude > 3 then dir = vel.Unit
    else
        local mine = origin_cframe()
        if mine then local delta = live - mine.Position if delta.Magnitude > 2 then dir = delta.Unit end end
    end
    local back = live - dir * 6
    local front = live + dir * math.max(P.min_span, vel.Magnitude * lead_time() + 8)
    if not force_clear(back, front) then back = live - dir * 2.5 end
    return CFrame.new(back, front), CFrame.new(front), 0, live
end
local function shot_shift(dt)
    if not S.predict or not TR.ready or dt <= 0 then return Vector3.zero end
    local shift = Vector3.new(TR.vel.X * dt, 0, TR.vel.Z * dt)
    if TR.air then
        local g = grav()
        local horizon = lead_time()
        local vy = TR.vel.Y
        local phase = math.max(0, os.clock() - TR.air_since)
        local modeled = TR.jump_v - g * phase
        if TR.jumping and TR.jump_v > 0 and g > 0 and phase <= TR.jump_v / g and modeled > vy then vy = modeled end
        shift = Vector3.new(shift.X, vy * dt - g * horizon * dt - 0.5 * g * dt * dt, shift.Z)
    end
    return shift
end
local function compensate_force(oc, ac, started)
    local shift = shot_shift(math.max(0, os.clock() - started))
    if shift == Vector3.zero then return oc, ac end
    return CFrame.new(oc.Position + shift, ac.Position + shift), CFrame.new(ac.Position + shift)
end
local function resolve_shot()
    if not S.silent or not S.am_sheriff or not target_alive() then return nil end
    if S.wallshot then
        local started = os.clock()
        local oc, ac = resolve_force()
        if oc and ac then
            oc, ac = compensate_force(oc, ac, started)
            if push_origin(oc) then return ac end
        end
    end
    local cf = origin_cframe()
    local aim = pick_point(cf and cf.Position or nil, false)
    if not aim then return nil end
    return CFrame.new(aim)
end
local function compensate_resolve(cf)
    if S.wallshot or typeof(cf) ~= "CFrame" then return cf end
    return CFrame.new(cf.Position + shot_shift(math.max(0, os.clock() - pred_stamp)))
end
local weapon_service, orig_mouse, orig_screen, hook_mouse, hook_screen = nil, nil, nil, nil, nil
local function get_weapon_service()
    if weapon_service then return weapon_service end
    local ok, m = pcall(function()
        return require(ReplicatedStorage:WaitForChild("ClientServices"):WaitForChild("WeaponService"))
    end)
    if ok and type(m) == "table" then weapon_service = m end
    return weapon_service
end
local function install_hooks()
    local m = get_weapon_service()
    if not m then return end
    if not hook_mouse then
        hook_mouse = function(self, ...)
            sample_ping()
            local ok, cf = pcall(resolve_shot)
            if ok and cf then return compensate_resolve(cf) end
            return orig_mouse(self, ...)
        end
        hook_screen = function(self, x, y, ...)
            sample_ping()
            local ok, cf = pcall(resolve_shot)
            if ok and cf then return compensate_resolve(cf) end
            return orig_screen(self, x, y, ...)
        end
    end
    pcall(function() setreadonly(m, false) end)
    if type(m.GetMouseTargetCFrame) == "function" and m.GetMouseTargetCFrame ~= hook_mouse then
        orig_mouse = m.GetMouseTargetCFrame
        pcall(function() m.GetMouseTargetCFrame = hook_mouse end)
    end
    if type(m.GetTargetPosition) == "function" and m.GetTargetPosition ~= hook_screen then
        orig_screen = m.GetTargetPosition
        pcall(function() m.GetTargetPosition = hook_screen end)
    end
end

-- ============ AUTO GRAB GUN ============
local function has_gun()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Gun") then return true end
    local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
    return bp and bp:FindFirstChild("Gun") ~= nil
end
local function grab_gun(obj)
    if not S.autoGrab or has_gun() then return end
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    pcall(function() obj.CFrame = root.CFrame end)
    local prompt = obj:FindFirstChildOfClass("ProximityPrompt")
    if prompt then pcall(function() fireproximityprompt(prompt) end) end
end
local function scan_guns()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name == "GunDrop" and obj:IsA("BasePart") then grab_gun(obj) end
    end
end
local grab_desc_conn = nil
local function grab_desc_added(obj)
    if obj.Name == "GunDrop" and obj:IsA("BasePart") then task.wait(0.1) grab_gun(obj) end
end
local function grab_attach()
    if grab_desc_conn then return end
    grab_desc_conn = Workspace.DescendantAdded:Connect(grab_desc_added)
    task.spawn(scan_guns)
end
local function grab_detach()
    if grab_desc_conn then pcall(function() grab_desc_conn:Disconnect() end) grab_desc_conn = nil end
end

-- ============ KNIFE AIM ============
local function knifeAimLoop()
    task.spawn(function()
        while S.knifeAim do
            task.wait()
            pcall(function()
                local char = LocalPlayer.Character
                local knife = char and char:FindFirstChild("Knife")
                if knife and char:FindFirstChild("HumanoidRootPart") then
                    local sheriff = nil
                    local m = get_round()
                    local data = m and m.PlayerData
                    if type(data) == "table" then
                        for name, d in pairs(data) do
                            if type(d) == "table" and not d.Dead and (d.Role == "Sheriff" or d.Role == "Hero") then
                                sheriff = Players:FindFirstChild(name) break
                            end
                        end
                    end
                    if sheriff and sheriff.Character then
                        local sp = sheriff.Character:FindFirstChild("HumanoidRootPart")
                        if sp then
                            local tv = Vector3.new(sp.Velocity.X, 0, sp.Velocity.Z)
                            local tp = sp.Position + tv * 0.15
                            Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, tp)
                        end
                    end
                end
            end)
        end
    end)
end

-- ============ KILL AURA ============
task.spawn(function()
    while task.wait() do
        if not S.killAura then continue end
        local char = LocalPlayer.Character
        local knife = char and (char:FindFirstChild("Knife") or LocalPlayer.Backpack:FindFirstChild("Knife"))
        if not knife then continue end
        if knife.Parent ~= char then knife.Parent = char task.wait(0.1) end
        knife = char:FindFirstChild("Knife")
        if not knife then continue end
        local handle = knife:FindFirstChild("Handle")
        local events = knife:FindFirstChild("Events")
        local touched = events and events:FindFirstChild("HandleTouched")
        if not handle or not touched then continue end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end
        local m = get_round()
        local data = m and m.PlayerData
        local my_role = data and data[LocalPlayer.Name] and data[LocalPlayer.Name].Role
        local am_murd = my_role == "Murderer"
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local pHrp = p.Character:FindFirstChild("HumanoidRootPart")
                local pHum = p.Character:FindFirstChildOfClass("Humanoid")
                if pHrp and pHum and pHum.Health > 0 then
                    local can_hit = false
                    if am_murd and type(data) == "table" then
                        local info = data[p.Name]
                        if info and not info.Dead and (info.Role == "Innocent" or info.Role == "Sheriff" or info.Role == "Hero") then can_hit = true end
                    elseif type(data) ~= "table" then can_hit = true end
                    if can_hit and (pHrp.Position - hrp.Position).Magnitude <= S.killAuraDist then
                        pcall(function()
                            handle.CFrame = pHrp.CFrame
                            touched:FireServer(pHrp)
                        end)
                    end
                end
            end
        end
    end
end)

-- ============ FLING ============
local isFlinging = false
local flingTargetPlayer = nil
local flingQueue = {}
local flingQueueIndex = 1
local flingConnection = nil
local flingOldPos = nil
local flingOldCameraSubject = nil
local flingAngle = 0
local flingHighVelCount = 0
local flingOriginalFallenHeight = nil
local trueOriginalPos = nil

local function cleanupFling()
    local wasFlinging = isFlinging
    if flingConnection then flingConnection:Disconnect() flingConnection = nil end
    isFlinging = false flingTargetPlayer = nil flingAngle = 0 flingHighVelCount = 0
    if flingOriginalFallenHeight ~= nil then
        pcall(function() workspace.FallenPartsDestroyHeight = flingOriginalFallenHeight end)
        flingOriginalFallenHeight = nil
    end
    if flingOldCameraSubject then
        pcall(function() Camera.CameraSubject = flingOldCameraSubject end)
        flingOldCameraSubject = nil
    else
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then pcall(function() Camera.CameraSubject = hum end) end
        end
    end
    local char = LocalPlayer.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hrp then
            for _, child in pairs(hrp:GetChildren()) do
                if child:IsA("BodyVelocity") or child:IsA("BodyGyro") or child:IsA("LinearVelocity") or child:IsA("AngularVelocity") or child:IsA("AlignOrientation") or child:IsA("AlignPosition") then
                    child:Destroy()
                end
            end
        end
        local savedPos = trueOriginalPos or flingOldPos
        if hrp and savedPos then
            task.spawn(function()
                hrp.Anchored = true
                task.wait(0.1)
                for _ = 1, 20 do
                    if not hrp.Parent then break end
                    pcall(function()
                        hrp.CFrame = savedPos
                        char:SetPrimaryPartCFrame(savedPos)
                        hrp.Velocity = Vector3.zero
                        hrp.AssemblyLinearVelocity = Vector3.zero
                        hrp.AssemblyAngularVelocity = Vector3.zero
                        hrp.RotVelocity = Vector3.zero
                    end)
                    task.wait(0.03)
                end
                pcall(function() hrp.Anchored = false end)
            end)
        end
        if hum then
            pcall(function()
                hum:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                hum.PlatformStand = false
            end)
        end
    end
    flingOldPos = nil
    if wasFlinging then
        trueOriginalPos = nil flingQueue = {} flingQueueIndex = 1
    end
end

local function startVibrationFling(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    local targetChar = targetPlayer.Character
    local targetHum = targetChar:FindFirstChildOfClass("Humanoid")
    local targetRoot = targetHum and targetHum.RootPart
    local targetHead = targetChar:FindFirstChild("Head")
    if not targetHead and not targetRoot then return end
    local myChar = LocalPlayer.Character
    if not myChar then return end
    local myHrp = myChar:FindFirstChild("HumanoidRootPart")
    local myHum = myChar:FindFirstChildOfClass("Humanoid")
    if not myHrp or not myHum then return end
    if not trueOriginalPos then trueOriginalPos = myHrp.CFrame end
    cleanupFling()
    flingTargetPlayer = targetPlayer isFlinging = true flingAngle = 0
    flingOldPos = myHrp.CFrame flingOldCameraSubject = Camera.CameraSubject
    Camera.CameraSubject = targetHead or targetHum
    myHum:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
    pcall(function()
        flingOriginalFallenHeight = workspace.FallenPartsDestroyHeight
        workspace.FallenPartsDestroyHeight = 0 / 0
    end)
    for _, p in pairs(myChar:GetChildren()) do
        if p:IsA("BasePart") then p.CanCollide = true end
    end
    local bv = Instance.new("BodyVelocity")
    bv.Name = "_xFling"
    bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
    bv.Velocity = Vector3.new(9e8, 9e8, 9e8)
    bv.Parent = myHrp
    local bg = Instance.new("BodyGyro")
    bg.Name = "_xFlingGyro" bg.P = 90000
    bg.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
    bg.CFrame = myHrp.CFrame bg.Parent = myHrp
    flingHighVelCount = 0
    local offsets = { Vector3.new(0, 0.15, 0), Vector3.new(0, -0.15, 0), Vector3.new(0.2, 0.25, 0), Vector3.new(-0.2, -0.25, 0) }
    local function predictCFrame(part)
        local vel = part.AssemblyLinearVelocity
        local pos = part.Position + vel * 0.04
        if vel.Magnitude > 5 then return CFrame.new(pos) * CFrame.Angles(0, math.atan2(vel.X, vel.Z), 0) end
        return CFrame.new(pos)
    end
    local function applyBurst(part, offset)
        local hrp2 = myChar:FindFirstChild("HumanoidRootPart")
        if not hrp2 then return end
        local baseCF = predictCFrame(part)
        local offsetVec = CFrame.Angles(0, math.rad(flingAngle), 0) * Vector3.new(2.6, 0, 0)
        hrp2.CFrame = baseCF * CFrame.new(offsetVec + offset) * CFrame.Angles(math.rad(flingAngle * 1.8), math.rad(flingAngle * 3.2), math.rad(flingAngle * 0.7))
        pcall(function() myChar:SetPrimaryPartCFrame(hrp2.CFrame) end)
        pcall(function()
            hrp2.Velocity = Vector3.new(9e7, 1.8e9, 9e7)
            hrp2.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
        end)
    end
    flingConnection = RunService.Stepped:Connect(function()
        if not isFlinging or not flingTargetPlayer then cleanupFling() return end
        local tChar = flingTargetPlayer.Character
        if not tChar or not tChar.Parent then cleanupFling() return end
        local tHrp = tChar:FindFirstChild("HumanoidRootPart")
        local tHead = tChar:FindFirstChild("Head")
        local part = tHead or tHrp
        if not part then cleanupFling() return end
        local v1 = tHead and tHead.AssemblyLinearVelocity.Magnitude or 0
        local v2 = tHrp and tHrp.AssemblyLinearVelocity.Magnitude or 0
        local maxV = math.max(v1, v2)
        if maxV > 420 then flingHighVelCount = flingHighVelCount + 1 else flingHighVelCount = 0 end
        if maxV > 780 or flingHighVelCount >= 9 then cleanupFling() return end
        flingAngle = flingAngle + 260
        for _, off in ipairs(offsets) do applyBurst(part, off) task.wait() end
    end)
    task.delay(12, function() if isFlinging then cleanupFling() end end)
end

local function role_player(role)
    local m = get_round()
    local data = m and m.PlayerData
    if type(data) ~= "table" then return nil end
    for name, info in pairs(data) do
        if type(info) == "table" and not info.Dead and (info.Role == role or (role == "Sheriff" and info.Role == "Hero")) then
            local p = Players:FindFirstChild(name)
            if p and p ~= LocalPlayer then return p end
        end
    end
    return nil
end

local function fling_role(role)
    if isFlinging then cleanupFling() return end
    local tp = role_player(role)
    if tp and tp.Character then
        flingQueue = {} flingQueueIndex = 1
        startVibrationFling(tp)
        notify("Fling", "Flinging " .. tp.Name)
    else notify("Fling", "No target for " .. role) end
end

local function fling_all()
    if isFlinging then cleanupFling() return end
    local myChar = LocalPlayer.Character
    local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
    flingQueue = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp and myHrp then table.insert(flingQueue, {player = p, distance = (myHrp.Position - hrp.Position).Magnitude}) end
        end
    end
    if #flingQueue == 0 then return end
    table.sort(flingQueue, function(a, b) return a.distance < b.distance end)
    for i, v in ipairs(flingQueue) do flingQueue[i] = v.player end
    flingQueueIndex = 1
    local first = flingQueue[1]
    flingQueueIndex = 2
    startVibrationFling(first)
    notify("Fling", "Flinging " .. #flingQueue .. " players")
end

-- ============ TOUCH FLING ============
local touchFlingThread = nil
local function toggleTouchFling(state)
    S.touchFling = state
    if state then
        touchFlingThread = task.spawn(function()
            local n = 0.1
            while S.touchFling do
                RunService.Heartbeat:Wait()
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local vel = hrp.Velocity
                    hrp.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
                    RunService.RenderStepped:Wait()
                    hrp.Velocity = vel
                    RunService.Stepped:Wait()
                    hrp.Velocity = vel + Vector3.new(0, n, 0)
                    n = -n
                end
            end
        end)
        notify("Touch Fling", "ON")
    else touchFlingThread = nil notify("Touch Fling", "OFF") end
end

-- ============ ANTI-FLING ============
local FLING_MAX_VEL = 700
local FLING_MAX_ANG = 90
local FLING_SNAP_DIST = 60
local FLING_HOLD = 0.25
local FLING_SAFE_VEL = 250
local fling_reg = {}
local fling_conns = {}
local fling_attached = false
local fling_safe_cf = nil
local fling_hold_until = 0
local fling_cache = {}
local anti_fling = false
local function fling_busy()
    if S.fly then return true end
    if (getgenv().FLING_ACTIVE or 0) > 0 then return true end
    return false
end
local function fling_kill_part(p)
    if fling_cache[p] == nil then fling_cache[p] = p.CanCollide end
    if p.CanCollide then p.CanCollide = false end
end
local function fling_unregister(model)
    local entry = fling_reg[model]
    if not entry then return end
    fling_reg[model] = nil
    for i = 1, #entry.conns do pcall(function() entry.conns[i]:Disconnect() end) end
    for p in pairs(entry.parts) do
        local v = fling_cache[p]
        fling_cache[p] = nil
        if v ~= nil and p.Parent then pcall(function() p.CanCollide = v end) end
    end
    table.clear(entry.parts)
end
local function fling_register(model)
    if not anti_fling or not model then return end
    if fling_reg[model] or model == LocalPlayer.Character then return end
    local entry = { parts = {}, conns = {} }
    fling_reg[model] = entry
    local function add(d)
        if d:IsA("BasePart") and not entry.parts[d] then
            entry.parts[d] = true
            if anti_fling then pcall(fling_kill_part, d) end
        end
    end
    for _, d in model:GetDescendants() do pcall(add, d) end
    local function push(c) entry.conns[#entry.conns + 1] = c end
    push(model.DescendantAdded:Connect(function(d) if anti_fling then pcall(add, d) end end))
    push(model.DescendantRemoving:Connect(function(d)
        if entry.parts[d] then entry.parts[d] = nil fling_cache[d] = nil end
    end))
    push(model.AncestryChanged:Connect(function(_, parent) if not parent then fling_unregister(model) end end))
end
local function fling_is_body(m)
    return m ~= LocalPlayer.Character and m:IsA("Model") and m:FindFirstChildOfClass("Humanoid") ~= nil
end
local function fling_scan()
    for _, pl in Players:GetPlayers() do if pl ~= LocalPlayer and pl.Character then fling_register(pl.Character) end end
    for _, m in Workspace:GetChildren() do if fling_is_body(m) then fling_register(m) end end
end
local function fling_sweep()
    for model, entry in pairs(fling_reg) do
        if not model.Parent or model == LocalPlayer.Character then fling_unregister(model)
        else
            for p in pairs(entry.parts) do
                if p.Parent then
                    if p.CanCollide then
                        if fling_cache[p] == nil then fling_cache[p] = true end
                        p.CanCollide = false
                    end
                else entry.parts[p] = nil fling_cache[p] = nil end
            end
        end
    end
end
local function fling_guard(full)
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp or not hrp.Parent then fling_safe_cf = nil return end
    if fling_busy() then fling_safe_cf = nil return end
    local lin = hrp.AssemblyLinearVelocity
    local ang = hrp.AssemblyAngularVelocity
    local spike = lin.Magnitude > FLING_MAX_VEL or ang.Magnitude > FLING_MAX_ANG
    local now = os.clock()
    if spike then fling_hold_until = now + FLING_HOLD end
    if spike or now < fling_hold_until then
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        if full and fling_safe_cf then
            if (hrp.Position - fling_safe_cf.Position).Magnitude > FLING_SNAP_DIST then hrp.CFrame = fling_safe_cf end
        end
    elseif full and lin.Magnitude < FLING_SAFE_VEL then fling_safe_cf = hrp.CFrame end
end
local function fling_detach()
    fling_attached = false
    for i = 1, #fling_conns do pcall(function() fling_conns[i]:Disconnect() end) end
    table.clear(fling_conns)
end
local function fling_attach()
    if fling_attached then return end
    fling_attached = true
    local function push(c) fling_conns[#fling_conns + 1] = c end
    local function watch(pl)
        if pl == LocalPlayer then return end
        push(pl.CharacterAdded:Connect(function(c) if anti_fling then fling_register(c) end end))
        push(pl.CharacterRemoving:Connect(function(c) fling_unregister(c) end))
    end
    for _, pl in Players:GetPlayers() do watch(pl) end
    push(Players.PlayerAdded:Connect(function(pl)
        watch(pl)
        if anti_fling and pl.Character then fling_register(pl.Character) end
    end))
    push(Players.PlayerRemoving:Connect(function(pl) if pl.Character then fling_unregister(pl.Character) end end))
    push(Workspace.ChildAdded:Connect(function(m)
        if not anti_fling then return end
        task.defer(function()
            if anti_fling and m.Parent == Workspace and fling_is_body(m) then fling_register(m) end
        end)
    end))
    push(LocalPlayer.CharacterAdded:Connect(function(c)
        fling_unregister(c) fling_safe_cf = nil fling_hold_until = 0
        if anti_fling then task.defer(fling_scan) end
    end))
    fling_scan()
end
local function fling_restore()
    fling_detach()
    for model in pairs(fling_reg) do fling_unregister(model) end
    table.clear(fling_reg)
    for p, v in pairs(fling_cache) do
        if p and p.Parent then pcall(function() p.CanCollide = v end) end
    end
    table.clear(fling_cache)
    fling_safe_cf = nil fling_hold_until = 0
end
local function toggleAntiFling(state)
    anti_fling = state
    if state then fling_attach() else fling_restore() end
end
RunService.Stepped:Connect(function()
    if anti_fling then
        if not fling_attached then pcall(fling_attach) end
        pcall(fling_sweep)
        pcall(fling_guard, true)
    end
end)
RunService.Heartbeat:Connect(function() if anti_fling then pcall(fling_guard, false) end end)

-- ============ ANTI-VOID ============
local anti_void = false
local void_original = workspace.FallenPartsDestroyHeight
RunService.Stepped:Connect(function()
    if not anti_void then return end
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if hrp.Position.Y <= (workspace.FallenPartsDestroyHeight or -1000) + 25 then
        hrp.Velocity = hrp.Velocity + Vector3.new(0, 250, 0)
    end
end)
local function toggleAntiVoid(state)
    anti_void = state
    if state then pcall(function() workspace.FallenPartsDestroyHeight = -9e9 end)
    else pcall(function() workspace.FallenPartsDestroyHeight = void_original end) end
end

-- ============ MAIN LOOP ============
local next_role, next_hook = 0, 0
RunService.Heartbeat:Connect(function()
    if force_att and os.clock() - force_stamp > 0.05 then restore_origin() end
    if not S.silent and not S.autoGrab then return end
    local now = os.clock()
    if now >= next_role then next_role = now + 0.2 refresh_target() end
    if S.silent then
        sample_ping()
        track(now)
        if now >= next_hook then next_hook = now + 1 install_hooks() end
    end
end)
task.spawn(function() pcall(install_hooks) end)

-- ============ ESP ============
local roleColors = {
    Murderer = Color3.fromRGB(255, 40, 40),
    Sheriff = Color3.fromRGB(40, 130, 255),
    Hero = Color3.fromRGB(255, 215, 0),
    Innocent = Color3.fromRGB(0, 220, 0),
    Default = Color3.fromRGB(200, 200, 200),
}
local esp_conns = {}
local esp_data = {}
local function make_esp(plr)
    if plr == LocalPlayer then return end
    local char = plr.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    local data = esp_data[plr] or {}
    esp_data[plr] = data
    if not data.hl then
        data.hl = Instance.new("Highlight")
        data.hl.Name = "DaDaESP"
        data.hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        data.hl.FillTransparency = 0.5
        data.hl.OutlineTransparency = 0
        data.hl.Enabled = false
        data.hl.Parent = char
    end
    if not data.bg then
        data.bg = Instance.new("BillboardGui")
        data.bg.Name = "DaDaESPTxt"
        data.bg.Adornee = head
        data.bg.Size = UDim2.new(2.5, 0, 1, 0)
        data.bg.AlwaysOnTop = true
        data.bg.Parent = head
        local lbl = Instance.new("TextLabel")
        lbl.Name = "Lbl"
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.TextStrokeTransparency = 0
        lbl.TextSize = 10
        lbl.Font = Enum.Font.SourceSansBold
        lbl.Visible = false
        lbl.Parent = data.bg
        data.lbl = lbl
    end
    if not data.box and Drawing then
        local lines = {}
        for i = 1, 4 do
            local l = Drawing.new("Line")
            l.Visible = false
            l.Thickness = 1
            l.Transparency = 1
            lines[i] = l
        end
        data.box = lines
    end
end
local function espClear()
    for plr, data in pairs(esp_data) do
        if data.hl then pcall(function() data.hl:Destroy() end) end
        if data.bg then pcall(function() data.bg:Destroy() end) end
        if data.box then for _, l in ipairs(data.box) do pcall(function() l:Remove() end) end end
        esp_data[plr] = nil
    end
    for _, c in ipairs(esp_conns) do pcall(function() c:Disconnect() end) end
    table.clear(esp_conns)
end
local function espLoop()
    local roleMap = {}
    local m = get_round()
    local data = m and m.PlayerData
    if type(data) == "table" then
        for name, d in pairs(data) do
            if type(d) == "table" and not d.Dead then roleMap[name] = d.Role end
        end
    end
    local myChar = LocalPlayer.Character
    local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
            local info = esp_data[plr]
            if info and info.hl then
                local role = roleMap[plr.Name] or "Default"
                local color = roleColors[role] or roleColors.Default
                info.hl.FillColor = color
                info.hl.OutlineColor = Color3.new(1, 1, 1)
                info.hl.Enabled = S.esp
                local char = plr.Character
                local hrp = char:FindFirstChild("HumanoidRootPart")
                local head = char:FindFirstChild("Head")
                local hum = char:FindFirstChildOfClass("Humanoid")
                if S.esp and hrp and head and hum and hum.Health > 0 then
                    local dist = myHrp and math.floor((hrp.Position - myHrp.Position).Magnitude) or 0
                    if info.lbl then
                        if S.espName then
                            info.lbl.Text = plr.Name .. " | " .. role .. " | " .. dist .. "m"
                            info.lbl.TextColor3 = color
                            info.lbl.Visible = true
                        else info.lbl.Visible = false end
                    end
                    if info.box then
                        local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                        if onScreen then
                            local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                            local feetPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                            local h = math.abs(headPos.Y - feetPos.Y)
                            local w = h * 0.5
                            info.box[1].From = Vector2.new(screenPos.X - w / 2, headPos.Y)
                            info.box[1].To = Vector2.new(screenPos.X + w / 2, headPos.Y)
                            info.box[2].From = Vector2.new(screenPos.X - w / 2, feetPos.Y)
                            info.box[2].To = Vector2.new(screenPos.X + w / 2, feetPos.Y)
                            info.box[3].From = Vector2.new(screenPos.X - w / 2, headPos.Y)
                            info.box[3].To = Vector2.new(screenPos.X - w / 2, feetPos.Y)
                            info.box[4].From = Vector2.new(screenPos.X + w / 2, headPos.Y)
                            info.box[4].To = Vector2.new(screenPos.X + w / 2, feetPos.Y)
                            for _, l in ipairs(info.box) do
                                l.Color = color
                                l.Visible = true
                            end
                        else for _, l in ipairs(info.box) do l.Visible = false end end
                    end
                else
                    if info.lbl then info.lbl.Visible = false end
                    if info.box then for _, l in ipairs(info.box) do l.Visible = false end end
                end
            end
        end
    end
end
local function espStart()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            make_esp(plr)
            esp_conns[#esp_conns + 1] = plr.CharacterAdded:Connect(function() task.wait(1) make_esp(plr) end)
        end
    end
    esp_conns[#esp_conns + 1] = Players.PlayerAdded:Connect(function(plr)
        if plr ~= LocalPlayer then
            esp_conns[#esp_conns + 1] = plr.CharacterAdded:Connect(function() task.wait(1) make_esp(plr) end)
            make_esp(plr)
        end
    end)
    esp_conns[#esp_conns + 1] = RunService.Heartbeat:Connect(espLoop)
end

-- ============ TRACER ============
local tracerConn = nil
local function tracerAttach()
    if tracerConn then return end
    local ok, remote = pcall(function()
        return ReplicatedStorage:WaitForChild("ClientServices"):WaitForChild("WeaponService"):WaitForChild("GunFired")
    end)
    if not ok or not remote then return end
    tracerConn = remote.OnClientEvent:Connect(function(gun, posA, posB)
        if not S.tracer then return end
        if typeof(posA) ~= "Vector3" or typeof(posB) ~= "Vector3" then return end
        local pA = Instance.new("Part") pA.Size = Vector3.new(0.05, 0.05, 0.05) pA.Position = posA pA.Anchored = true pA.CanCollide = false pA.Transparency = 1 pA.Parent = Workspace
        local pB = Instance.new("Part") pB.Size = Vector3.new(0.05, 0.05, 0.05) pB.Position = posB pB.Anchored = true pB.CanCollide = false pB.Transparency = 1 pB.Parent = Workspace
        local aA = Instance.new("Attachment", pA)
        local aB = Instance.new("Attachment", pB)
        local beam = Instance.new("Beam")
        beam.Attachment0 = aA beam.Attachment1 = aB
        beam.Width0 = 0.08 beam.Width1 = 0.08
        beam.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
        beam.FaceCamera = true beam.LightEmission = 1
        beam.Transparency = NumberSequence.new(0) beam.Parent = pA
        task.wait(0.1)
        TweenService:Create(beam, TweenInfo.new(0.5), {Width0 = 0, Width1 = 0, Transparency = NumberSequence.new(1)}):Play()
        task.wait(0.6)
        pA:Destroy() pB:Destroy()
    end)
end
task.spawn(function() while task.wait(1) do if S.tracer and not tracerConn then tracerAttach() end end end)

-- ============ AURA ============
local AURA_IDS = { Angel = "rbxassetid://97658130917593", Wind = "rbxassetid://80694081850877", Starlight = "rbxassetid://134645216613107", Heavenly = "rbxassetid://139300897520961" }
local AURA_COLOR = Color3.fromRGB(133, 220, 255)
local function removeAura()
    local char = LocalPlayer.Character
    if not char then return end
    for _, obj in ipairs(char:GetDescendants()) do
        if obj.Name:find("DaDaAura") then obj:Destroy() end
    end
end
local function applyAura(name)
    removeAura()
    if not S.aura then return end
    local auraId = AURA_IDS[name]
    if not auraId then return end
    local char = LocalPlayer.Character
    if not char then return end
    local ok, aura = pcall(function() return game:GetObjects(auraId)[1] end)
    if not ok or not aura then return end
    local parts = {}
    for _, part in ipairs(char:GetChildren()) do
        if part:IsA("BasePart") then parts[part.Name] = part end
    end
    for _, auraPart in ipairs(aura:GetChildren()) do
        local target = parts[auraPart.Name]
        if target then
            for _, effect in ipairs(auraPart:GetChildren()) do
                local clone = effect:Clone()
                clone.Name = "DaDaAura_" .. name
                clone.Parent = target
                for _, obj in ipairs(clone:GetDescendants()) do
                    if obj:IsA("ParticleEmitter") or obj:IsA("Beam") or obj:IsA("Trail") then
                        obj.Color = ColorSequence.new(AURA_COLOR)
                        obj.Enabled = true
                    elseif obj:IsA("PointLight") then obj.Color = AURA_COLOR end
                end
            end
        end
    end
    aura:Destroy()
end

-- ============ CHINA HAT ============
local chRows, chShown = {}, {}
local chinaConn = nil
local CH_RADIUS, CH_HEIGHT, CH_DROP = 1.55, 0.82, 0.02
local CH_SEG = 32
local CH_TAU = math.pi * 2
local chCos, chSin = {}, {}
for i = 1, CH_SEG do
    local a = (i - 1) / CH_SEG * CH_TAU
    chCos[i] = math.cos(a) * CH_RADIUS
    chSin[i] = math.sin(a) * CH_RADIUS
end
local CH_COL = Color3.fromRGB(255, 60, 60)
local function chRow(i)
    local r = chRows[i]
    if r then return r end
    r = Drawing.new("Square")
    r.Filled = true r.Thickness = 0 r.Transparency = 0.72 r.Visible = false r.ZIndex = 1
    chRows[i] = r chShown[i] = false
    return r
end
local function chClear()
    for i = 1, #chRows do pcall(function() chRows[i]:Remove() end) end
    table.clear(chRows) table.clear(chShown)
end
local function chUpdate()
    local char = LocalPlayer.Character
    local head = char and char:FindFirstChild("Head")
    if not head then for i = 1, #chRows do chRows[i].Visible = false end return end
    local cam = Camera
    local view = cam.ViewportSize
    local px, py = {}, {}
    local headPos = head.Position
    local baseY = headPos.Y + head.Size.Y * 0.5 - CH_DROP
    local center = Vector3.new(headPos.X, baseY, headPos.Z)
    local apex = cam:WorldToViewportPoint(center + Vector3.new(0, CH_HEIGHT, 0))
    if apex.Z <= 0 then for i = 1, #chRows do chRows[i].Visible = false end return end
    px[1], py[1] = apex.X, apex.Y
    for i = 1, CH_SEG do
        local p = cam:WorldToViewportPoint(center + Vector3.new(chCos[i], 0, chSin[i]))
        if p.Z <= 0 then for k = 1, #chRows do chRows[k].Visible = false end return end
        px[i + 1], py[i + 1] = p.X, p.Y
    end
    local n = CH_SEG + 1
    local ord = {}
    for i = 1, n do ord[i] = i end
    table.sort(ord, function(a, b)
        if px[a] == px[b] then return py[a] < py[b] end
        return px[a] < px[b]
    end)
    local st, m = {}, 0
    for k = 1, n do
        local i = ord[k]
        while m >= 2 do
            local o, a2 = st[m - 1], st[m]
            if (px[a2] - px[o]) * (py[i] - py[o]) - (py[a2] - py[o]) * (px[i] - px[o]) > 0 then break end
            m = m - 1
        end
        m = m + 1 st[m] = i
    end
    local lower = m
    for k = n - 1, 1, -1 do
        local i = ord[k]
        while m > lower do
            local o, a2 = st[m - 1], st[m]
            if (px[a2] - px[o]) * (py[i] - py[o]) - (py[a2] - py[o]) * (px[i] - px[o]) > 0 then break end
            m = m - 1
        end
        m = m + 1 st[m] = i
    end
    local hn = m - 1
    if hn < 3 then for i = 1, #chRows do chRows[i].Visible = false end return end
    local minY, maxY = math.huge, -math.huge
    for i = 1, hn do
        local y = py[st[i]]
        if y < minY then minY = y end
        if y > maxY then maxY = y end
    end
    local firstY = math.max(0, math.floor(minY))
    local lastY = math.min(view.Y, math.ceil(maxY))
    if lastY - firstY < 2 then for i = 1, #chRows do chRows[i].Visible = false end return end
    local step = math.max(1, math.ceil((lastY - firstY) / 220))
    local used = 0
    for y0 = firstY, lastY - 1, step do
        local h = math.min(step, lastY - y0)
        local y = y0 + h * 0.5
        local left, right = math.huge, -math.huge
        local ax, ay = px[st[hn]], py[st[hn]]
        for i = 1, hn do
            local ix = st[i]
            local bx, by = px[ix], py[ix]
            if (ay <= y and by > y) or (by <= y and ay > y) then
                local x = ax + (y - ay) * (bx - ax) / (by - ay)
                if x < left then left = x end
                if x > right then right = x end
            end
            ax, ay = bx, by
        end
        local w = right - left
        if w >= 2.5 then
            used = used + 1
            local row = chRow(used)
            row.Position = Vector2.new(left, y0)
            row.Size = Vector2.new(w, h)
            row.Color = CH_COL
            if not chShown[used] then row.Visible = true chShown[used] = true end
        end
    end
    for i = used + 1, #chRows do if chShown[i] then chRows[i].Visible = false chShown[i] = false end end
end
local function chinaHatToggle(state)
    S.chinaHat = state
    if state then
        if not chinaConn then
            chinaConn = RunService.RenderStepped:Connect(function() if S.chinaHat then chUpdate() end end)
        end
        notify("China Hat", "ON")
    else
        if chinaConn then chinaConn:Disconnect() chinaConn = nil end
        chClear()
        notify("China Hat", "OFF")
    end
end

-- ============ PLAYER ============
local ws_original, jp_original, use_jp_original = nil, nil, nil
local flyBV, flyBG, flyConn = nil, nil, nil
local noclipCache = {}
local bhopConn = nil
local fovOriginal = nil
local aspectMult = CFrame.new(0,0,0,1,0,0,0,1,0,0,0,1)

RunService.Stepped:Connect(function()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if S.walkSpeed and hum.WalkSpeed ~= S.walkSpeedVal then hum.WalkSpeed = S.walkSpeedVal end
    if S.jumpPower then
        if not hum.UseJumpPower then hum.UseJumpPower = true end
        if hum.JumpPower ~= S.jumpPowerVal then hum.JumpPower = S.jumpPowerVal end
    end
end)

local function toggleFly(state)
    S.fly = state
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    if state then
        hum.PlatformStand = true
        flyBV = Instance.new("BodyVelocity")
        flyBV.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        flyBV.Velocity = Vector3.zero
        flyBV.Parent = hrp
        flyBG = Instance.new("BodyGyro")
        flyBG.P = 9e4 flyBG.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        flyBG.CFrame = Camera.CFrame flyBG.Parent = hrp
        if flyConn then flyConn:Disconnect() end
        flyConn = RunService.RenderStepped:Connect(function()
            if not S.fly then return end
            local char2 = LocalPlayer.Character
            local hrp2 = char2 and char2:FindFirstChild("HumanoidRootPart")
            local hum2 = char2 and char2:FindFirstChildOfClass("Humanoid")
            if not hrp2 or not hum2 then return end
            local cf = Camera.CFrame
            local md = hum2.MoveDirection
            local dir = (cf.RightVector * md:Dot(cf.RightVector) + cf.LookVector * md:Dot(Vector3.new(cf.LookVector.X, 0, cf.LookVector.Z).Unit)).Unit
            flyBV.Velocity = md.Magnitude > 0 and dir * S.flySpeed or Vector3.zero
            flyBG.CFrame = cf
        end)
        notify("Fly", "ON")
    else
        if flyConn then flyConn:Disconnect() flyConn = nil end
        if flyBV then flyBV:Destroy() flyBV = nil end
        if flyBG then flyBG:Destroy() flyBG = nil end
        hum.PlatformStand = false
        notify("Fly", "OFF")
    end
end

RunService.Stepped:Connect(function()
    if not S.noclip then return end
    local char = LocalPlayer.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.CanCollide then
            if noclipCache[part] == nil then noclipCache[part] = part.CanCollide end
            part.CanCollide = false
        end
    end
end)

local function noclipRestore()
    for p, v in pairs(noclipCache) do if p and p.Parent then p.CanCollide = v end end
    noclipCache = {}
end

local function bhopLoop()
    if bhopConn then bhopConn:Disconnect() bhopConn = nil end
    if not S.bhop then return end
    bhopConn = RunService.Heartbeat:Connect(function()
        if not S.bhop then return end
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local state = hum:GetState()
        if state == Enum.HumanoidStateType.Landed and UserInputService:IsKeyDown(Enum.KeyCode.Space) then hum.Jump = true end
    end)
end

local fovConn = nil
local function setFov(v)
    S.fovValue = v
    if S.customFov then
        local cam = Workspace.CurrentCamera
        if cam then cam.FieldOfView = v end
    end
end
local function toggleFov(state)
    S.customFov = state
    local cam = Workspace.CurrentCamera
    if state then
        if cam then fovOriginal = cam.FieldOfView cam.FieldOfView = S.fovValue end
        if not fovConn then
            fovConn = RunService.RenderStepped:Connect(function()
                if S.customFov then
                    local c = Workspace.CurrentCamera
                    if c and c.FieldOfView ~= S.fovValue then c.FieldOfView = S.fovValue end
                end
            end)
        end
    else
        if cam and fovOriginal then cam.FieldOfView = fovOriginal end
        if fovConn then fovConn:Disconnect() fovConn = nil end
    end
end

RunService:BindToRenderStep("DaDaAspect", Enum.RenderPriority.Camera.Value + 1, function()
    if not S.aspectRatio then return end
    local cam = Workspace.CurrentCamera
    if cam then cam.CFrame = cam.CFrame * aspectMult end
end)

-- ============ UI ============
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DaDaMiniV9"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 15, 0.5, -25)
OpenBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
OpenBtn.Text = "DD"
OpenBtn.TextColor3 = Color3.new(1, 1, 1)
OpenBtn.TextSize = 18
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.BorderSizePixel = 0
OpenBtn.Active = true
OpenBtn.Parent = ScreenGui
local OC = Instance.new("UICorner") OC.CornerRadius = UDim.new(0, 10) OC.Parent = OpenBtn
local OS = Instance.new("UIStroke") OS.Color = Color3.fromRGB(180, 80, 255) OS.Thickness = 1.5 OS.Parent = OpenBtn

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 460)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -230)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui
local MC = Instance.new("UICorner") MC.CornerRadius = UDim.new(0, 12) MC.Parent = MainFrame
local MS = Instance.new("UIStroke") MS.Color = Color3.fromRGB(180, 80, 255) MS.Thickness = 1.2 MS.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50, 0, 40)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "DA-DA Mini v9 LITE"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 15
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -38, 0, 6)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.TextSize = 13
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = MainFrame
local CC = Instance.new("UICorner") CC.CornerRadius = UDim.new(0, 6) CC.Parent = CloseBtn

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -20, 0, 32)
TabBar.Position = UDim2.new(0, 10, 0, 42)
TabBar.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
TabBar.BorderSizePixel = 0
TabBar.Parent = MainFrame
local TBC = Instance.new("UICorner") TBC.CornerRadius = UDim.new(0, 8) TBC.Parent = TabBar
local TabList = Instance.new("UIListLayout")
TabList.FillDirection = Enum.FillDirection.Horizontal
TabList.Padding = UDim.new(0, 3)
TabList.Parent = TabBar

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -20, 1, -95)
Content.Position = UDim2.new(0, 10, 0, 82)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

local tabs, pages = {}, {}
local function add_tab(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 65, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(180, 180, 200)
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Parent = TabBar
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 6) c.Parent = btn
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Color3.fromRGB(180, 80, 255)
    page.CanvasSize = UDim2.new(0, 0, 0, 900)
    page.Visible = false
    page.Parent = Content
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = page
    tabs[name] = btn pages[name] = page
    btn.MouseButton1Click:Connect(function()
        for n, b in pairs(tabs) do
            b.BackgroundColor3 = n == name and Color3.fromRGB(60, 30, 90) or Color3.fromRGB(25, 25, 32)
            b.TextColor3 = n == name and Color3.new(1, 1, 1) or Color3.fromRGB(180, 180, 200)
        end
        for n, p in pairs(pages) do p.Visible = (n == name) end
    end)
    return page
end

local mainPage = add_tab("Main")
local playerPage = add_tab("Player")
local flingPage = add_tab("Fling")
local visualPage = add_tab("Visuals")
local espPage = add_tab("ESP")
tabs["Main"].BackgroundColor3 = Color3.fromRGB(60, 30, 90)
tabs["Main"].TextColor3 = Color3.new(1, 1, 1)
mainPage.Visible = true

local function makeToggle(parent, text, default, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -6, 0, 40)
    btn.BackgroundColor3 = default and Color3.fromRGB(40, 80, 40) or Color3.fromRGB(28, 28, 36)
    btn.Text = text .. ": " .. (default and "ON" or "OFF")
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Parent = parent
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 8) c.Parent = btn
    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(40, 80, 40) or Color3.fromRGB(28, 28, 36)
        btn.Text = text .. ": " .. (state and "ON" or "OFF")
        callback(state)
    end)
    return btn
end

local function makeButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -6, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Parent = parent
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 8) c.Parent = btn
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function makeSlider(parent, text, minV, maxV, defV, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -6, 0, 55)
    frame.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 8) c.Parent = frame
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -20, 0, 20)
    lbl.Position = UDim2.new(0, 10, 0, 5)
    lbl.BackgroundTransparency = 1
    lbl.Text = text .. ": " .. defV
    lbl.TextColor3 = Color3.new(1, 1, 1)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame
    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -20, 0, 6)
    track.Position = UDim2.new(0, 10, 0, 35)
    track.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    track.BorderSizePixel = 0
    track.Parent = frame
    local tc = Instance.new("UICorner") tc.CornerRadius = UDim.new(1, 0) tc.Parent = track
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((defV - minV) / (maxV - minV), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(180, 80, 255)
    fill.BorderSizePixel = 0
    fill.Parent = track
    local fc = Instance.new("UICorner") fc.CornerRadius = UDim.new(1, 0) fc.Parent = fill
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = UDim2.new((defV - minV) / (maxV - minV), -7, 0.5, -7)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.BorderSizePixel = 0
    knob.Parent = track
    local kc = Instance.new("UICorner") kc.CornerRadius = UDim.new(1, 0) kc.Parent = knob
    local dragging = false
    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true end
    end)
    knob.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local x = input.Position.X
            local tp = track.AbsolutePosition.X
            local ts = track.AbsoluteSize.X
            local pct = math.clamp((x - tp) / ts, 0, 1)
            local val = math.floor(minV + (maxV - minV) * pct)
            lbl.Text = text .. ": " .. val
            knob.Position = UDim2.new(pct, -7, 0.5, -7)
            fill.Size = UDim2.new(pct, 0, 1, 0)
            callback(val)
        end
    end)
    return frame
end

makeToggle(mainPage, "Silent Aim", false, function(v) S.silent = v if v then task.spawn(function() pcall(install_hooks) pcall(refresh_target) end) end notify("Silent", v and "ON" or "OFF") end)
makeToggle(mainPage, "Wallshot", false, function(v) S.wallshot = v notify("Wallshot", v and "ON" or "OFF") end)
makeToggle(mainPage, "Auto Grab Gun", false, function(v) S.autoGrab = v if v then grab_attach() else grab_detach() end end)
makeToggle(mainPage, "Knife Aimbot", false, function(v) S.knifeAim = v if v then knifeAimLoop() end end)
makeToggle(mainPage, "Kill Aura", false, function(v) S.killAura = v end)
makeSlider(mainPage, "Kill Aura Dist", 5, 60, 20, function(v) S.killAuraDist = v end)
makeSlider(mainPage, "Stand Off", 0, 40, 15, function(v) S.standOff = v end)

makeToggle(playerPage, "WalkSpeed", false, function(v)
    S.walkSpeed = v
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if v then if hum then ws_original = hum.WalkSpeed end
    else if hum and ws_original then hum.WalkSpeed = ws_original end end
end)
makeSlider(playerPage, "WS Value", 16, 300, 40, function(v) S.walkSpeedVal = v end)
makeToggle(playerPage, "JumpPower", false, function(v)
    S.jumpPower = v
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if v then
        if hum then use_jp_original = hum.UseJumpPower jp_original = hum.JumpPower end
    else
        if hum then
            if use_jp_original ~= nil then hum.UseJumpPower = use_jp_original end
            if jp_original then hum.JumpPower = jp_original end
        end
    end
end)
makeSlider(playerPage, "JP Value", 0, 500, 80, function(v) S.jumpPowerVal = v end)
makeToggle(playerPage, "Fly", false, function(v) toggleFly(v) end)
makeSlider(playerPage, "Fly Speed", 10, 300, 60, function(v) S.flySpeed = v end)
makeToggle(playerPage, "Noclip", false, function(v) S.noclip = v if not v then noclipRestore() end end)
makeToggle(playerPage, "Bhop", false, function(v) S.bhop = v bhopLoop() end)
makeToggle(playerPage, "Custom FOV", false, function(v) toggleFov(v) end)
makeSlider(playerPage, "FOV Value", 30, 120, 70, function(v) setFov(v) end)
makeToggle(playerPage, "Aspect Ratio", false, function(v) S.aspectRatio = v end)
makeSlider(playerPage, "Aspect Value", 10, 200, 100, function(v) aspectMult = CFrame.new(0,0,0,1,0,0,0,v/100,0,0,0,1) end)
makeButton(playerPage, "Reset Character", function()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildWhichIsA("Humanoid")
    if hum then hum:ChangeState(Enum.HumanoidStateType.Dead)
    elseif char then pcall(function() char:BreakJoints() end) end
end)

makeButton(flingPage, "Fling Murderer", function() fling_role("Murderer") end)
makeButton(flingPage, "Fling Sheriff", function() fling_role("Sheriff") end)
makeButton(flingPage, "Fling All", function() fling_all() end)
makeToggle(flingPage, "Fling Bypass Velocity", false, function(v) S.flingBypass = v end)
makeToggle(flingPage, "Touch Fling", false, function(v) toggleTouchFling(v) end)
makeToggle(flingPage, "Anti-Fling", false, function(v) toggleAntiFling(v) end)
makeToggle(flingPage, "Anti-Void", false, function(v) toggleAntiVoid(v) end)

makeToggle(visualPage, "Gun Tracer", false, function(v) S.tracer = v end)
makeToggle(visualPage, "Aura", false, function(v) S.aura = v if v then applyAura(S.auraName) else removeAura() end end)
makeButton(visualPage, "Aura: Angel", function() S.auraName = "Angel" if S.aura then applyAura("Angel") end notify("Aura", "Angel") end)
makeButton(visualPage, "Aura: Wind", function() S.auraName = "Wind" if S.aura then applyAura("Wind") end notify("Aura", "Wind") end)
makeButton(visualPage, "Aura: Starlight", function() S.auraName = "Starlight" if S.aura then applyAura("Starlight") end notify("Aura", "Starlight") end)
makeButton(visualPage, "Aura: Heavenly", function() S.auraName = "Heavenly" if S.aura then applyAura("Heavenly") end notify("Aura", "Heavenly") end)
makeToggle(visualPage, "China Hat", false, function(v) chinaHatToggle(v) end)

makeToggle(espPage, "ESP Players", false, function(v) S.esp = v if v then espStart() else espClear() end notify("ESP", v and "ON" or "OFF") end)
makeToggle(espPage, "Show Name + Role", false, function(v) S.espName = v end)

OpenBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)
CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    if S.silent then pcall(install_hooks) end
    if S.esp then espStart() end
    if S.aura then applyAura(S.auraName) end
    if S.chinaHat then chinaHatToggle(true) end
    if S.fly then toggleFly(true) end
end)

end)

if not _OK then
    warn("[DaDa v9] CRASH: " .. tostring(_ERR))
    if _DaDaBootLabel then
        _DaDaBootLabel.Text = "❌ ОШИБКА:"
        _DaDaBootLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
    end
    if _DaDaBootSub then
        _DaDaBootSub.Text = tostring(_ERR):sub(1, 400)
    end
    return
end

print("[DaDa v9] BOOT END — скрипт загружен")
if _DaDaBootLabel then
    _DaDaBootLabel.Text = "✅ DaDa v9 LITE загружен!"
    _DaDaBootLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
end
task.delay(5, function()
    if _DaDaBootFrame then _DaDaBootFrame:Destroy() end
end)
