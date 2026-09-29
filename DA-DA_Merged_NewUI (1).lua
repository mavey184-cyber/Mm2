--[[ DA-DA Mini v8 + Shoot Murderer Button (прямоугольная фиолетовая) Author: dada (2025) ]]-- local Players = game:GetService("Players") local RunService = game:GetService("RunService") local UserInputService = game:GetService("UserInputService") local Stats = game:GetService("Stats") local CollectionService = game:GetService("CollectionService") local ReplicatedStorage = game:GetService("ReplicatedStorage") local TweenService = game:GetService("TweenService") local Lighting = game:GetService("Lighting") local CoreGui = game:GetService("CoreGui") local LocalPlayer = Players.LocalPlayer local Workspace = workspace local Camera = Workspace.CurrentCamera -- ============ NOTIFY ============ local notifyGui = Instance.new("ScreenGui") notifyGui.Name = "DaDaNotify" notifyGui.ResetOnSpawn = false notifyGui.Parent = CoreGui local notifyHolder = Instance.new("Frame") notifyHolder.Size = UDim2.new(0, 260, 1, -20) notifyHolder.Position = UDim2.new(1, -270, 0, 10) notifyHolder.BackgroundTransparency = 1 notifyHolder.Parent = notifyGui local notifyList = Instance.new("UIListLayout") notifyList.Padding = UDim.new(0, 6) notifyList.VerticalAlignment = Enum.VerticalAlignment.Bottom notifyList.SortOrder = Enum.SortOrder.LayoutOrder notifyList.Parent = notifyHolder local function notify(title, text) local frame = Instance.new("Frame") frame.Size = UDim2.new(1, 0, 0, 50) frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25) frame.BackgroundTransparency = 0.05 frame.BorderSizePixel = 0 frame.Parent = notifyHolder local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 8) c.Parent = frame local s = Instance.new("UIStroke") s.Color = Color3.fromRGB(180, 80, 255) s.Thickness = 1.2 s.Parent = frame local acc = Instance.new("Frame") acc.Size = UDim2.new(0, 3, 1, -12) acc.Position = UDim2.new(0, 4, 0, 6) acc.BackgroundColor3 = Color3.fromRGB(180, 80, 255) acc.BorderSizePixel = 0 acc.Parent = frame local ac = Instance.new("UICorner") ac.CornerRadius = UDim.new(1, 0) ac.Parent = acc local t = Instance.new("TextLabel") t.Size = UDim2.new(1, -24, 0, 20) t.Position = UDim2.new(0, 14, 0, 6) t.BackgroundTransparency = 1 t.Text = title t.TextColor3 = Color3.new(1, 1, 1) t.TextSize = 12 t.Font = Enum.Font.GothamBold t.TextXAlignment = Enum.TextXAlignment.Left t.Parent = frame local d = Instance.new("TextLabel") d.Size = UDim2.new(1, -24, 0, 20) d.Position = UDim2.new(0, 14, 0, 26) d.BackgroundTransparency = 1 d.Text = text d.TextColor3 = Color3.fromRGB(180, 180, 190) d.TextSize = 11 d.Font = Enum.Font.Gotham d.TextXAlignment = Enum.TextXAlignment.Left d.Parent = frame frame.Position = UDim2.new(1, 300, 0, 0) TweenService:Create(frame, TweenInfo.new(0.25), {Position = UDim2.new(0, 0, 0, 0)}):Play() task.delay(3, function() TweenService:Create(frame, TweenInfo.new(0.25), {Position = UDim2.new(1, 300, 0, 0)}):Play() task.wait(0.3) frame:Destroy() end) end -- ============ SETTINGS ============ local S = { silent = false, wallshot = false, predict = true, autoGrab = false, standOff = 15, knifeAim = false, killAura = false, killAuraDist = 20, tracer = false, aura = false, auraName = "Angel", chinaHat = false, griddy = false, flingBypass = false, touchFling = false, esp = false, espName = false, weaponSkin = "None", } local MAX_RANGE = 300 local round_mod = nil local function get_round() if round_mod then return round_mod end local ok, m = pcall(function() return require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("CurrentRoundClient")) end) if ok and type(m) == "table" then round_mod = m end return round_mod end -- ============ SILENT AIM / WALLSHOT ============ local target_player, target_char, target_part, target_hum = nil, nil, nil, nil local function holds(c, n) return c ~= nil and c:FindFirstChild(n) ~= nil end local function lp_has_gun() return holds(LocalPlayer.Character, "Gun") or holds(LocalPlayer:FindFirstChildOfClass("Backpack"), "Gun") end local function refresh_target() local found = nil local m = get_round() local data = m and m.PlayerData or nil if type(data) == "table" then local me = data[LocalPlayer.Name] S.am_sheriff = (me ~= nil and (me.Role == "Sheriff" or me.Role == "Hero")) or lp_has_gun() for name, d in pairs(data) do if type(d) == "table" and d.Role == "Murderer" and not d.Dead then found = Players:FindFirstChild(name) break end end else S.am_sheriff = lp_has_gun() end if not found then for _, plr in ipairs(Players:GetPlayers()) do if plr ~= LocalPlayer and holds(plr.Character, "Knife") then found = plr break end end end if found ~= target_player then target_player = found target_char = nil target_part = nil target_hum = nil end if not found then return end local char = found.Character if char ~= target_char then target_char = char target_part = nil target_hum = nil end if not char then return end if not target_part or not target_part.Parent then target_part = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") end if not target_hum or not target_hum.Parent then target_hum = char:FindFirstChildOfClass("Humanoid") end end local function target_alive() if not target_part or not target_part.Parent then return false end if not target_hum or not target_hum.Parent then return false end return target_hum.Health > 0 end local ray_params = RaycastParams.new() ray_params.FilterType = Enum.RaycastFilterType.Exclude ray_params.IgnoreWater = false local ignore_base, ignore_work, ignore_time = {}, {}, 0 local function refresh_ignore() local now = os.clock() if #ignore_base > 0 and now - ignore_time < 0.5 then return end ignore_time = now table.clear(ignore_base) local char = LocalPlayer.Character if char then ignore_base[1] = char end local ok, tagged = pcall(function() return CollectionService:GetTagged("WeaponPassthrough") end) if ok and type(tagged) == "table" then for k = 1, #tagged do ignore_base[#ignore_base + 1] = tagged[k] end end end local function trace(origin, direction) refresh_ignore() table.clear(ignore_work) for k = 1, #ignore_base do ignore_work[k] = ignore_base[k] end local result = nil for _ = 1, 6 do ray_params.FilterDescendantsInstances = ignore_work result = Workspace:Raycast(origin, direction, ray_params) if not result then break end local inst = result.Instance if not inst then break end local ok, tr = pcall(function() return inst.Transparency end) if not ok or tr ~= 1 then break end ignore_work[#ignore_work + 1] = inst end return result end local function gun_attachment() local char = LocalPlayer.Character local hrp = char and char:FindFirstChild("HumanoidRootPart") if not hrp then return nil, nil end return hrp:FindFirstChild("GunRaycastAttachment"), hrp end local function origin_cframe() local att, hrp = gun_attachment() if att then return att.WorldCFrame end if hrp then return hrp.CFrame end end local P = { snap = 48, min_span = 5, max_span = 90 } local snap_t = table.create(P.snap, 0) local snap_p = table.create(P.snap, Vector3.zero) local snap_n, snap_i = 0, 0 local TR = { part = nil, pos = nil, time = 0, vel = Vector3.zero, gap = 0, ready = false, fresh = Vector3.zero } local EC = { rtt = 0, jitter = 0, seen = false } local function snap_push(now, pos) snap_i = snap_i % P.snap + 1 snap_t[snap_i] = now snap_p[snap_i] = pos if snap_n < P.snap then snap_n = snap_n + 1 end end local function snap_get(k) local idx = (snap_i - k - 1) % P.snap + 1 return snap_t[idx], snap_p[idx] end local function raw_rtt() local ok, ms = pcall(function() return Stats.Network.ServerStatsItem["Data Ping"]:GetValue() end) if ok and type(ms) == "number" and ms > 4 and ms < 800 then return ms / 1000 end end local function sample_ping() local rtt = raw_rtt() if not rtt then return end rtt = math.clamp(rtt, 0, 1) if EC.seen then EC.jitter = EC.jitter * 0.9 + math.abs(rtt - EC.rtt) * 0.1 EC.rtt = EC.rtt * 0.82 + rtt * 0.18 else EC.rtt = rtt EC.jitter = 0 EC.seen = true end end local function lead_time() if not EC.seen then return 0 end return math.clamp(EC.rtt + EC.jitter * 0.5, 0, 1) end local function track(now) local part = target_part if not part or not part.Parent then if TR.part then TR.part = nil snap_n, snap_i = 0, 0 end return end local pos = part.Position if part ~= TR.part or not TR.pos then TR.part = part TR.pos = pos TR.time = now TR.vel = Vector3.zero TR.ready = false snap_n, snap_i = 0, 0 snap_push(now, pos) return end local dt = now - TR.time if dt > 0.75 or (pos - TR.pos).Magnitude > 140 then TR.pos = pos TR.time = now snap_n, snap_i = 0, 0 snap_push(now, pos) return end if dt <= 0 or (pos - TR.pos).Magnitude == 0 then return end TR.gap = dt snap_push(now, pos) TR.pos = pos TR.time = now if snap_n >= 3 then local newest, head = snap_get(0) local oldest, tail = snap_get(snap_n - 1) local span = newest - oldest if span > 0 then TR.vel = (head - tail) / span TR.ready = true TR.fresh = TR.vel end end end local hit_names = { "HumanoidRootPart","UpperTorso","Torso","LowerTorso","Head","RightUpperArm","LeftUpperArm","Right Arm","Left Arm","RightUpperLeg","LeftUpperLeg","Right Leg","Left Leg" } local hit_parts, hit_count, hit_char = {}, 0, nil local function refresh_parts() local char = target_char if char == hit_char then return end table.clear(hit_parts) hit_count = 0 hit_char = char if not char then return end for k = 1, #hit_names do local part = char:FindFirstChild(hit_names[k]) if part and part:IsA("BasePart") then hit_count = hit_count + 1 hit_parts[hit_count] = part end end end local function los_clear(origin, point) if not origin or not point then return false end local delta = point - origin local dist = delta.Magnitude if dist < 0.5 then return true end if dist > MAX_RANGE then return false end local hit = trace(origin, delta) if not hit then return true end local inst = hit.Instance local char = target_char if inst and char and (inst == char or inst:IsDescendantOf(char)) then return true end return (hit.Position - origin).Magnitude >= dist - 0.75 end local force_att, force_saved, force_stamp = nil, nil, 0 local function restore_origin() local att = force_att if not att then return end local saved = force_saved force_att, force_saved = nil, nil if saved then pcall(function() if att.Parent then att.CFrame = saved end end) end end local function push_origin(cf) local att = gun_attachment() if not att then return false end if force_att and force_att ~= att then restore_origin() end if not force_att then local ok, saved = pcall(function() return att.CFrame end) if not ok or typeof(saved) ~= "CFrame" then return false end force_att = att force_saved = saved end force_stamp = os.clock() local ok = pcall(function() att.WorldCFrame = cf end) if not ok then restore_origin() return false end task.defer(restore_origin) return true end local function is_target_hit(inst) local char = target_char if not inst or not char then return false end return inst == char or inst:IsDescendantOf(char) end local function force_clear(origin, aim) local hit = trace(origin, aim - origin) if not hit then return false end return is_target_hit(hit.Instance) end local function force_velocity() if TR.ready and TR.fresh.Magnitude > 0.5 then return TR.fresh end if TR.ready and TR.vel.Magnitude > 0.5 then return TR.vel end return Vector3.zero end local function resolve_force() local part = target_part if not part or not part.Parent then return nil end local live = part.Position local vel = force_velocity() local dir = Vector3.new(0, -1, 0) if vel.Magnitude > 3 then dir = vel.Unit else local mine = origin_cframe() if mine then local delta = live - mine.Position if delta.Magnitude > 2 then dir = delta.Unit end end end local back = live - dir * 6 local front = live + dir * math.max(P.min_span, vel.Magnitude * lead_time() + 8) if not force_clear(back, front) then back = live - dir * 2.5 end local want = S.standOff while want > 0 do local probe = back - dir * want if (front - probe).Magnitude <= P.max_span and los_clear(probe, live) then back = probe break end want = want - 3 end if (front - back).Magnitude > P.max_span then back = front - dir * P.max_span end return CFrame.new(back, front), CFrame.new(front), 0, live end local function shot_shift(dt) if not S.predict or not TR.ready or dt <= 0 then return Vector3.zero end return Vector3.new(TR.vel.X * dt, 0, TR.vel.Z * dt) end local function compensate_force(oc, ac, st) local sh = shot_shift(math.max(0, os.clock() - st)) if sh == Vector3.zero then return oc, ac end return CFrame.new(oc.Position + sh, ac.Position + sh), CFrame.new(ac.Position + sh) end local function pick_point(origin) refresh_parts() if hit_count == 0 then return nil end local off = TR.ready and (TR.fresh * lead_time()) or Vector3.zero for k = 1, hit_count do local part = hit_parts[k] if part.Parent then local point = part.Position + off if not origin then return point end if los_clear(origin, point) then return point end end end return nil end local weapon_service, orig_mouse, orig_screen, hook_mouse, hook_screen = nil, nil, nil, nil, nil local function get_weapon_service() if weapon_service then return weapon_service end local ok, m = pcall(function() return require(ReplicatedStorage:WaitForChild("ClientServices"):WaitForChild("WeaponService")) end) if ok and type(m) == "table" then weapon_service = m end return weapon_service end local function resolve_shot() if not S.silent or not S.am_sheriff or not target_alive() then return nil end if S.wallshot then local started = os.clock() local oc, ac = resolve_force() if oc and ac then oc, ac = compensate_force(oc, ac, started) if push_origin(oc) then return ac end end end local cf = origin_cframe() local aim = pick_point(cf and cf.Position or nil) if not aim then return nil end return CFrame.new(aim) end local function compensate_resolve(cf) if S.wallshot or typeof(cf) ~= "CFrame" then return cf end return CFrame.new(cf.Position + shot_shift(0.02)) end local function install_hooks() local m = get_weapon_service() if not m then return end if not hook_mouse then hook_mouse = function(self, ...) sample_ping() local ok, cf = pcall(resolve_shot) if ok and cf then return compensate_resolve(cf) end return orig_mouse(self, ...) end hook_screen = function(self, x, y, ...) sample_ping() local ok, cf = pcall(resolve_shot) if ok and cf then return compensate_resolve(cf) end return orig_screen(self, x, y, ...) end end pcall(function() setreadonly(m, false) end) if type(m.GetMouseTargetCFrame) == "function" and m.GetMouseTargetCFrame ~= hook_mouse then orig_mouse = m.GetMouseTargetCFrame pcall(function() m.GetMouseTargetCFrame = hook_mouse end) end if type(m.GetTargetPosition) == "function" and m.GetTargetPosition ~= hook_screen then orig_screen = m.GetTargetPosition pcall(function() m.GetTargetPosition = hook_screen end) end end -- ============ AUTO GRAB / KNIFE AIM / KILL AURA ============ local function has_gun() local char = LocalPlayer.Character if char and char:FindFirstChild("Gun") then return true end local bp = LocalPlayer:FindFirstChildOfClass("Backpack") return bp and bp:FindFirstChild("Gun") ~= nil end local function grab_gun(obj) if not S.autoGrab or has_gun() then return end local char = LocalPlayer.Character local root = char and char:FindFirstChild("HumanoidRootPart") if not root then return end pcall(function() obj.CFrame = root.CFrame end) local prompt = obj:FindFirstChildOfClass("ProximityPrompt") if prompt then pcall(function() fireproximityprompt(prompt) end) end end local function scan_guns() for _, obj in pairs(Workspace:GetDescendants()) do if obj.Name == "GunDrop" and obj:IsA("BasePart") then grab_gun(obj) end end end local grab_desc_conn = nil local function grab_desc_added(obj) if obj.Name == "GunDrop" and obj:IsA("BasePart") then task.wait(0.1) grab_gun(obj) end end local function grab_attach() if grab_desc_conn then return end grab_desc_conn = Workspace.DescendantAdded:Connect(grab_desc_added) task.spawn(scan_guns) end local function grab_detach() if grab_desc_conn then pcall(function() grab_desc_conn:Disconnect() end) grab_desc_conn = nil end end local function knifeAimLoop() spawn(function() while S.knifeAim do task.wait() pcall(function() local char = LocalPlayer.Character local knife = char and char:FindFirstChild("Knife") if knife and char:FindFirstChild("HumanoidRootPart") then local sheriff = nil local m = get_round() local data = m and m.PlayerData if type(data) == "table" then for name, d in pairs(data) do if type(d) == "table" and not d.Dead and (d.Role == "Sheriff" or d.Role == "Hero") then sheriff = Players:FindFirstChild(name) break end end end if sheriff and sheriff.Character then local sp = sheriff.Character:FindFirstChild("HumanoidRootPart") if sp then local tv = Vector3.new(sp.Velocity.X, 0, sp.Velocity.Z) local tp = sp.Position + tv * 0.15 Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, tp) end end end end) end end) end task.spawn(function() while task.wait() do if not S.killAura then continue end local char = LocalPlayer.Character local knife = char and (char:FindFirstChild("Knife") or LocalPlayer.Backpack:FindFirstChild("Knife")) if not knife then continue end if knife.Parent ~= char then knife.Parent = char task.wait(0.1) end knife = char:FindFirstChild("Knife") if not knife then continue end local handle = knife:FindFirstChild("Handle") local events = knife:FindFirstChild("Events") local touched = events and events:FindFirstChild("HandleTouched") if not handle or not touched then continue end local hrp = char:FindFirstChild("HumanoidRootPart") if not hrp then continue end for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character then local pHrp = p.Character:FindFirstChild("HumanoidRootPart") local pHum = p.Character:FindFirstChildOfClass("Humanoid") if pHrp and pHum and pHum.Health > 0 and (pHrp.Position - hrp.Position).Magnitude <= S.killAuraDist then pcall(function() handle.CFrame = pHrp.CFrame touched:FireServer(pHrp) end) end end end end end) -- ============ FLING + TOUCH FLING ============ local function do_fling(tp) if not tp or not tp.Character then return end local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") if not hrp then return end local tc = tp.Character local thrp = tc:FindFirstChild("HumanoidRootPart") or tc:FindFirstChild("Head") local th = tc:FindFirstChildOfClass("Humanoid") if not thrp then return end getgenv().FLING_ACTIVE = (getgenv().FLING_ACTIVE or 0) + 1 if hrp.Velocity.Magnitude < 50 then getgenv().OldPos = hrp.CFrame end if th and th.Sit then getgenv().FLING_ACTIVE = math.max(0, (getgenv().FLING_ACTIVE or 1) - 1) return end local old_fdh = Workspace.FallenPartsDestroyHeight Camera.CameraSubject = thrp pcall(function() Workspace.FallenPartsDestroyHeight = 0 / 0 end) local bv = Instance.new("BodyVelocity") bv.Parent = hrp bv.Velocity = Vector3.new(0, 0, 0) bv.MaxForce = Vector3.new(9e9, 9e9, 9e9) local se = hum and hum:GetStateEnabled(Enum.HumanoidStateType.Seated) if hum then hum:SetStateEnabled(Enum.HumanoidStateType.Seated, false) end local tm = tick() local tw = 2 local ang = 0 local bypass = S.flingBypass repeat if hrp and th then local tv = bypass and (th.MoveDirection * th.WalkSpeed) or thrp.Velocity if tv.Magnitude < 50 then ang = ang + 100 for _ = 1, 2 do hrp.CFrame = CFrame.new(thrp.Position) * CFrame.new(0, 1.5, 0) + th.MoveDirection * tv.Magnitude / 1.25 hrp.CFrame = hrp.CFrame * CFrame.Angles(math.rad(ang), 0, 0) LocalPlayer.Character:SetPrimaryPartCFrame(hrp.CFrame) hrp.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7) hrp.RotVelocity = Vector3.new(9e8, 9e8, 9e8) task.wait() hrp.CFrame = CFrame.new(thrp.Position) * CFrame.new(0, -1.5, 0) + th.MoveDirection * tv.Magnitude / 1.25 hrp.CFrame = hrp.CFrame * CFrame.Angles(math.rad(ang), 0, 0) LocalPlayer.Character:SetPrimaryPartCFrame(hrp.CFrame) hrp.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7) hrp.RotVelocity = Vector3.new(9e8, 9e8, 9e8) task.wait() end else hrp.CFrame = CFrame.new(thrp.Position) * CFrame.new(0, 1.5, th.WalkSpeed) hrp.CFrame = hrp.CFrame * CFrame.Angles(math.rad(90), 0, 0) LocalPlayer.Character:SetPrimaryPartCFrame(hrp.CFrame) hrp.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7) hrp.RotVelocity = Vector3.new(9e8, 9e8, 9e8) task.wait() end end until tm + tw < tick() or (getgenv().FLING_ACTIVE or 0) <= 0 if bv then bv:Destroy() end if hum and se ~= nil then hum:SetStateEnabled(Enum.HumanoidStateType.Seated, se) end Camera.CameraSubject = hum if getgenv().OldPos and hrp then hrp.CFrame = getgenv().OldPos * CFrame.new(0, 0.5, 0) LocalPlayer.Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, 0.5, 0)) if hum then hum:ChangeState("GettingUp") end for _, p in pairs(LocalPlayer.Character:GetChildren()) do if p:IsA("BasePart") then p.Velocity = Vector3.new() p.RotVelocity = Vector3.new() end end pcall(function() Workspace.FallenPartsDestroyHeight = old_fdh end) end getgenv().FLING_ACTIVE = math.max(0, (getgenv().FLING_ACTIVE or 1) - 1) end local function role_player(role) local m = get_round() local data = m and m.PlayerData if type(data) ~= "table" then return nil end for name, info in pairs(data) do if type(info) == "table" and not info.Dead and (info.Role == role or (role == "Sheriff" and info.Role == "Hero")) then local p = Players:FindFirstChild(name) if p and p ~= LocalPlayer then return p end end end return nil end local function fling_role(role) local tp = role_player(role) if tp and tp.Character then task.spawn(do_fling, tp) notify("Fling", "Flinging " .. tp.Name) else notify("Fling", "No target for " .. role) end end local function fling_all() for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character then task.spawn(do_fling, p) task.wait(0.3) end end notify("Fling", "Fling all started") end local touchFlingThread = nil local function toggleTouchFling(state) S.touchFling = state if state then touchFlingThread = task.spawn(function() local n = 0.1 while S.touchFling do RunService.Heartbeat:Wait() local char = LocalPlayer.Character local hrp = char and char:FindFirstChild("HumanoidRootPart") if hrp then local vel = hrp.Velocity hrp.Velocity = vel * 10000 + Vector3.new(0, 10000, 0) RunService.RenderStepped:Wait() hrp.Velocity = vel RunService.Stepped:Wait() hrp.Velocity = vel + Vector3.new(0, n, 0) n = -n end end end) notify("Touch Fling", "ON") else touchFlingThread = nil notify("Touch Fling", "OFF") end end -- ============ TRACER / AURA / CHINA HAT / GRIDDY / FE ============ local tracerConn = nil local function tracerAttach() if tracerConn then return end local ok, remote = pcall(function() return ReplicatedStorage:WaitForChild("ClientServices"):WaitForChild("WeaponService"):WaitForChild("GunFired") end) if not ok or not remote then return end tracerConn = remote.OnClientEvent:Connect(function(gun, posA, posB) if not S.tracer then return end if typeof(posA) ~= "Vector3" or typeof(posB) ~= "Vector3" then return end local pA = Instance.new("Part") pA.Size = Vector3.new(0.05, 0.05, 0.05) pA.Position = posA pA.Anchored = true pA.CanCollide = false pA.Transparency = 1 pA.Parent = Workspace local pB = Instance.new("Part") pB.Size = Vector3.new(0.05, 0.05, 0.05) pB.Position = posB pB.Anchored = true pB.CanCollide = false pB.Transparency = 1 pB.Parent = Workspace local aA = Instance.new("Attachment", pA) local aB = Instance.new("Attachment", pB) local beam = Instance.new("Beam") beam.Attachment0 = aA beam.Attachment1 = aB beam.Width0 = 0.08 beam.Width1 = 0.08 beam.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255)) beam.FaceCamera = true beam.LightEmission = 1 beam.Transparency = NumberSequence.new(0) beam.Parent = pA task.wait(0.1) TweenService:Create(beam, TweenInfo.new(0.5), {Width0 = 0, Width1 = 0, Transparency = NumberSequence.new(1)}):Play() task.wait(0.6) pA:Destroy() pB:Destroy() end) end task.spawn(function() while task.wait(1) do if S.tracer and not tracerConn then tracerAttach() end end end) local AURA_IDS = { Angel = "rbxassetid://97658130917593", Wind = "rbxassetid://80694081850877", Starlight = "rbxassetid://134645216613107", Heavenly = "rbxassetid://139300897520961" } local AURA_COLOR = Color3.fromRGB(133, 220, 255) local function removeAura() local char = LocalPlayer.Character if not char then return end for _, obj in ipairs(char:GetDescendants()) do if obj.Name:find("DaDaAura") then obj:Destroy() end end end local function applyAura(name) removeAura() if not S.aura then return end local auraId = AURA_IDS[name] if not auraId then return end local char = LocalPlayer.Character if not char then return end local ok, aura = pcall(function() return game:GetObjects(auraId)[1] end) if not ok or not aura then return end local parts = {} for _, part in ipairs(char:GetChildren()) do if part:IsA("BasePart") then parts[part.Name] = part end end for _, auraPart in ipairs(aura:GetChildren()) do local target = parts[auraPart.Name] if target then for _, effect in ipairs(auraPart:GetChildren()) do local clone = effect:Clone() clone.Name = "DaDaAura_" .. name clone.Parent = target for _, obj in ipairs(clone:GetDescendants()) do if obj:IsA("ParticleEmitter") or obj:IsA("Beam") or obj:IsA("Trail") then obj.Color = ColorSequence.new(AURA_COLOR) obj.Enabled = true elseif obj:IsA("PointLight") then obj.Color = AURA_COLOR end end end end end aura:Destroy() end local chRows, chShown = {}, {} local chinaConn = nil local CH_RADIUS, CH_HEIGHT, CH_DROP = 1.55, 0.82, 0.02 local CH_SEG = 32 local CH_TAU = math.pi * 2 local chCos, chSin = {}, {} for i = 1, CH_SEG do local a = (i - 1) / CH_SEG * CH_TAU chCos[i] = math.cos(a) * CH_RADIUS chSin[i] = math.sin(a) * CH_RADIUS end local CH_COL = Color3.fromRGB(255, 60, 60) local function chRow(i) local r = chRows[i] if r then return r end r = Drawing.new("Square") r.Filled = true r.Thickness = 0 r.Transparency = 0.72 r.Visible = false r.ZIndex = 1 chRows[i] = r chShown[i] = false return r end local function chClear() for i = 1, #chRows do pcall(function() chRows[i]:Remove() end) end table.clear(chRows) table.clear(chShown) end local function chUpdate() local char = LocalPlayer.Character local head = char and char:FindFirstChild("Head") if not head then for i = 1, #chRows do chRows[i].Visible = false end return end local cam = Camera local view = cam.ViewportSize local px, py = {}, {} local headPos = head.Position local baseY = headPos.Y + head.Size.Y * 0.5 - CH_DROP local center = Vector3.new(headPos.X, baseY, headPos.Z) local apex = cam:WorldToViewportPoint(center + Vector3.new(0, CH_HEIGHT, 0)) if apex.Z <= 0 then for i = 1, #chRows do chRows[i].Visible = false end return end px[1], py[1] = apex.X, apex.Y for i = 1, CH_SEG do local p = cam:WorldToViewportPoint(center + Vector3.new(chCos[i], 0, chSin[i])) if p.Z <= 0 then for k = 1, #chRows do chRows[k].Visible = false end return end px[i + 1], py[i + 1] = p.X, p.Y end local n = CH_SEG + 1 local ord = {} for i = 1, n do ord[i] = i end table.sort(ord, function(a, b) if px[a] == px[b] then return py[a] < py[b] end return px[a] < px[b] end) local st, m = {}, 0 for k = 1, n do local i = ord[k] while m >= 2 do local o, a2 = st[m - 1], st[m] if (px[a2] - px[o]) * (py[i] - py[o]) - (py[a2] - py[o]) * (px[i] - px[o]) > 0 then break end m = m - 1 end m = m + 1 st[m] = i end local lower = m for k = n - 1, 1, -1 do local i = ord[k] while m > lower do local o, a2 = st[m - 1], st[m] if (px[a2] - px[o]) * (py[i] - py[o]) - (py[a2] - py[o]) * (px[i] - px[o]) > 0 then break end m = m - 1 end m = m + 1 st[m] = i end local hn = m - 1 if hn < 3 then for i = 1, #chRows do chRows[i].Visible = false end return end local minY, maxY = math.huge, -math.huge for i = 1, hn do local y = py[st[i]] if y < minY then minY = y end if y > maxY then maxY = y end end local firstY = math.max(0, math.floor(minY)) local lastY = math.min(view.Y, math.ceil(maxY)) if lastY - firstY < 2 then for i = 1, #chRows do chRows[i].Visible = false end return end local step = math.max(1, math.ceil((lastY - firstY) / 220)) local used = 0 for y0 = firstY, lastY - 1, step do local h = math.min(step, lastY - y0) local y = y0 + h * 0.5 local left, right = math.huge, -math.huge local ax, ay = px[st[hn]], py[st[hn]] for i = 1, hn do local ix = st[i] local bx, by = px[ix], py[ix] if (ay <= y and by > y) or (by <= y and ay > y) then local x = ax + (y - ay) * (bx - ax) / (by - ay) if x < left then left = x end if x > right then right = x end end ax, ay = bx, by end local w = right - left if w >= 2.5 then used = used + 1 local row = chRow(used) row.Position = Vector2.new(left, y0) row.Size = Vector2.new(w, h) row.Color = CH_COL if not chShown[used] then row.Visible = true chShown[used] = true end end end for i = used + 1, #chRows do if chShown[i] then chRows[i].Visible = false chShown[i] = false end end end local function chinaHatToggle(state) S.chinaHat = state if state then if not chinaConn then chinaConn = RunService.RenderStepped:Connect(function() if S.chinaHat then chUpdate() end end) end notify("China Hat", "ON") else if chinaConn then chinaConn:Disconnect() chinaConn = nil end chClear() notify("China Hat", "OFF") end end local GriddyConns = {} local function GriddySetup() local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait() if not character then return end local humanoid = character:WaitForChild("Humanoid", 5) if not humanoid then return end local animate = character:FindFirstChild("Animate") if not animate then return end local animator = humanoid:FindFirstChildOfClass("Animator") if not animator then animator = Instance.new("Animator") animator.Parent = humanoid end local griddyTrack = nil local conn = animator.AnimationPlayed:Connect(function(track) local ok, a = pcall(function() return track.Animation end) if ok and a then griddyTrack = track end end) pcall(function() humanoid:PlayEmoteAndGetAnimTrackById(77017926307035) end) local timeout = tick() + 3 while not griddyTrack and tick() < timeout do task.wait() end if conn then conn:Disconnect() end if not griddyTrack then return end local animation pcall(function() animation = griddyTrack.Animation end) if not animation then return end local aid = animation.AnimationId griddyTrack:Stop(0) local function replace(folder, object) local f = animate:FindFirstChild(folder) if f then local a = f:FindFirstChild(object) if a and a:IsA("Animation") then a.AnimationId = aid end end end replace("idle", "Animation1") replace("idle", "Animation2") replace("walk", "WalkAnim") replace("run", "RunAnim") replace("jump", "JumpAnim") replace("fall", "FallAnim") replace("climb", "ClimbAnim") end local function GriddyToggle(state) S.griddy = state if state then GriddySetup() local c = LocalPlayer.CharacterAdded:Connect(function() task.wait(1) if S.griddy then GriddySetup() end end) table.insert(GriddyConns, c) notify("Griddy", "Walk enabled") else for _, c in ipairs(GriddyConns) do pcall(function() c:Disconnect() end) end GriddyConns = {} local char = LocalPlayer.Character if char then local animate = char:FindFirstChild("Animate") if animate then local function restore(folder, object, default) local f = animate:FindFirstChild(folder) if f then local a = f:FindFirstChild(object) if a and a:IsA("Animation") then a.AnimationId = default end end end restore("walk", "WalkAnim", "rbxassetid://180426354") restore("run", "RunAnim", "rbxassetid://180426354") end end notify("Griddy", "Walk disabled") end end local FEAnimPresets = { Ninja = { idle1="rbxassetid://656117400", idle2="rbxassetid://656118341", walk="rbxassetid://656121766", run="rbxassetid://656118852", jump="rbxassetid://656117878", climb="rbxassetid://656114359", fall="rbxassetid://656115606" }, Hero = { idle1="rbxassetid://616111295", idle2="rbxassetid://616113536", walk="rbxassetid://616122287", run="rbxassetid://616117076", jump="rbxassetid://616115533", climb="rbxassetid://616104706", fall="rbxassetid://616108001" }, Zombie = { idle1="rbxassetid://616158929", idle2="rbxassetid://616160636", walk="rbxassetid://616168032", run="rbxassetid://616163682", jump="rbxassetid://616161997", climb="rbxassetid://616156119", fall="rbxassetid://616157476" }, Vampire = { idle1="rbxassetid://1083445855", idle2="rbxassetid://1083450166", walk="rbxassetid://1083473930", run="rbxassetid://1083462077", jump="rbxassetid://1083455352", climb="rbxassetid://1083439238", fall="rbxassetid://1083443587" }, Mage = { idle1="rbxassetid://707742142", idle2="rbxassetid://707855907", walk="rbxassetid://707897309", run="rbxassetid://707861613", jump="rbxassetid://707853694", climb="rbxassetid://707826056", fall="rbxassetid://707829716" }, Knight = { idle1="rbxassetid://657595757", idle2="rbxassetid://657568135", walk="rbxassetid://657552124", run="rbxassetid://657564596", jump="rbxassetid://658409194", climb="rbxassetid://658360781", fall="rbxassetid://657600338" }, } local FEAnimMap = { idle = { folder="idle", slots={{child="Animation1",origKey="idle1"},{child="Animation2",origKey="idle2"}} }, walk = { folder="walk", slots={{child="WalkAnim",origKey="walk"}} }, run = { folder="run", slots={{child="RunAnim",origKey="run"}} }, jump = { folder="jump", slots={{child="JumpAnim",origKey="jump"}} }, climb = { folder="climb", slots={{child="ClimbAnim",origKey="climb"}} }, fall = { folder="fall", slots={{child="FallAnim",origKey="fall"}} }, } local FEAnimOriginals = {} local function saveFEAnimOriginals(animate) for _, v in pairs(FEAnimMap) do local folder = animate:FindFirstChild(v.folder) if folder then for _, s in ipairs(v.slots) do local anim = folder:FindFirstChild(s.child) if anim and anim:IsA("Animation") and anim.AnimationId ~= "" then FEAnimOriginals[s.origKey] = anim.AnimationId end end end end end local function applyFEAnims(char, presetName) if not char then return end local animate = char:FindFirstChild("Animate") local hum = char:FindFirstChildOfClass("Humanoid") if not animate or not hum then return end saveFEAnimOriginals(animate) for _, t in ipairs(hum:GetPlayingAnimationTracks()) do t:Stop(0) end animate.Disabled = true task.wait(0.15) for k, v in pairs(FEAnimMap) do local folder = animate:FindFirstChild(v.folder) if folder then for _, s in ipairs(v.slots) do local anim = folder:FindFirstChild(s.child) if anim and anim:IsA("Animation") then if presetName == "Default" then if FEAnimOriginals[s.origKey] then anim.AnimationId = FEAnimOriginals[s.origKey] end else local preset = FEAnimPresets[presetName] if preset and preset[s.origKey] then anim.AnimationId = preset[s.origKey] end end end end end end animate.Disabled = false local st = hum:GetState() hum:ChangeState(Enum.HumanoidStateType.GettingUp) task.delay(0.1, function() if hum and hum.Parent then hum:ChangeState(st) end end) end -- ============ ESP ============ local roleColors = { Murderer = Color3.fromRGB(255, 40, 40), Sheriff = Color3.fromRGB(40, 130, 255), Hero = Color3.fromRGB(255, 215, 0), Innocent = Color3.fromRGB(0, 220, 0), Default = Color3.fromRGB(200, 200, 200), } local esp_conns = {} local esp_data = {} local function make_esp(plr) if plr == LocalPlayer then return end local char = plr.Character if not char then return end local head = char:FindFirstChild("Head") if not head then return end local data = esp_data[plr] or {} esp_data[plr] = data if not data.hl then data.hl = Instance.new("Highlight") data.hl.Name = "DaDaESP" data.hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop data.hl.FillTransparency = 0.5 data.hl.OutlineTransparency = 0 data.hl.Enabled = false data.hl.Parent = char end if not data.bg then data.bg = Instance.new("BillboardGui") data.bg.Name = "DaDaESPTxt" data.bg.Adornee = head data.bg.Size = UDim2.new(2.5, 0, 1, 0) data.bg.AlwaysOnTop = true data.bg.Parent = head local lbl = Instance.new("TextLabel") lbl.Name = "Lbl" lbl.Size = UDim2.new(1, 0, 1, 0) lbl.BackgroundTransparency = 1 lbl.TextStrokeTransparency = 0 lbl.TextSize = 10 lbl.Font = Enum.Font.SourceSansBold lbl.Visible = false lbl.Parent = data.bg data.lbl = lbl end end local function espClear() for plr, data in pairs(esp_data) do if data.hl then pcall(function() data.hl:Destroy() end) end if data.bg then pcall(function() data.bg:Destroy() end) end esp_data[plr] = nil end for _, c in ipairs(esp_conns) do pcall(function() c:Disconnect() end) end table.clear(esp_conns) end local function espLoop() local roleMap = {} local m = get_round() local data = m and m.PlayerData if type(data) == "table" then for name, d in pairs(data) do if type(d) == "table" and not d.Dead then roleMap[name] = d.Role end end end for _, plr in ipairs(Players:GetPlayers()) do if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then local info = esp_data[plr] if info and info.hl then local role = roleMap[plr.Name] or "Default" local color = roleColors[role] or roleColors.Default info.hl.FillColor = color info.hl.OutlineColor = Color3.new(1, 1, 1) info.hl.Enabled = S.esp if info.lbl then if S.espName then local char = plr.Character local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") local hrp = char and char:FindFirstChild("HumanoidRootPart") local dist = (myHrp and hrp) and math.floor((hrp.Position - myHrp.Position).Magnitude) or 0 info.lbl.Text = plr.Name .. " | " .. role .. " | " .. dist .. "m" info.lbl.TextColor3 = color info.lbl.Visible = true else info.lbl.Visible = false end end end end end end local function espStart() for _, plr in ipairs(Players:GetPlayers()) do if plr ~= LocalPlayer then make_esp(plr) esp_conns[#esp_conns + 1] = plr.CharacterAdded:Connect(function() task.wait(1) make_esp(plr) end) end end esp_conns[#esp_conns + 1] = Players.PlayerAdded:Connect(function(plr) if plr ~= LocalPlayer then esp_conns[#esp_conns + 1] = plr.CharacterAdded:Connect(function() task.wait(1) make_esp(plr) end) make_esp(plr) end end) esp_conns[#esp_conns + 1] = RunService.Heartbeat:Connect(espLoop) end -- ============ WEAPON SKINS ============ local WEAPON_SKINS = { AWP = { asset="rbxassetid://5181507328", scale=2, rotation=CFrame.Angles(math.rad(90),0,0), position=Vector3.new(0,2.5,0), name="AWP_VisualModel" }, ["Tommy Gun"] = { asset="rbxassetid://10648330247", scale=1, rotation=CFrame.Angles(math.rad(90),0,0), position=Vector3.new(0,0.5,0), name="TommyGun_VisualModel" }, Minigun = { asset="rbxassetid://697022516", scale=1, rotation=CFrame.Angles(math.rad(90),math.rad(90),0), position=Vector3.new(0,0.5,0), name="Minigun_VisualModel" }, } local cachedAwp, cachedTommy, cachedMinigun = nil, nil, nil local activeSkinModel = nil local function sanitizeSkinPart(part) if part:IsA("BasePart") then part.Anchored = false part.CanCollide = false part.CanTouch = false part.CanQuery = false part.Massless = true end end local function loadSkinModel(skinName) local skin = WEAPON_SKINS[skinName] if not skin then return nil end local cache = { AWP=cachedAwp, ["Tommy Gun"]=cachedTommy, Minigun=cachedMinigun } if cache[skinName] then return cache[skinName]:Clone() end local ok, result = pcall(function() return game:GetObjects(skin.asset) end) if ok and result and #result > 0 then local container = Instance.new("Model") for _, obj in ipairs(result) do obj.Parent = container end if skinName == "AWP" then cachedAwp = container elseif skinName == "Tommy Gun" then cachedTommy = container elseif skinName == "Minigun" then cachedMinigun = container end return container:Clone() end end local function removeActiveSkin() if activeSkinModel and activeSkinModel.Parent then activeSkinModel:Destroy() end activeSkinModel = nil end local function applySkinToGun(tool) if not tool:IsA("Tool") or tool.Name ~= "Gun" then return end if activeSkinModel and activeSkinModel.Parent then activeSkinModel:Destroy() activeSkinModel = nil end for _, desc in ipairs(tool:GetDescendants()) do if desc:IsA("BasePart") or desc:IsA("Decal") or desc:IsA("Texture") then desc.Transparency = 1 end end if S.weaponSkin == "None" then return end local skin = WEAPON_SKINS[S.weaponSkin] if not skin then return end local handle = tool:WaitForChild("Handle", 3) or tool:FindFirstChildWhichIsA("BasePart") if not handle then return end task.spawn(function() local model = loadSkinModel(S.weaponSkin) if not model then return end model.Name = skin.name for _, desc in ipairs(model:GetDescendants()) do sanitizeSkinPart(desc) end if not model.PrimaryPart then model.PrimaryPart = model:FindFirstChildWhichIsA("BasePart") end if skin.scale ~= 1 then pcall(function() model:ScaleTo(skin.scale) end) end local targetCF = handle.CFrame * CFrame.new(skin.position) * skin.rotation model:PivotTo(targetCF) for _, part in ipairs(model:GetDescendants()) do if part:IsA("BasePart") then local weld = Instance.new("WeldConstraint") weld.Name = "SkinWeld" weld.Part0 = handle weld.Part1 = part weld.Parent = part end end model.Parent = tool activeSkinModel = model end) end local function trackGunContainer(container) if not container then return end for _, child in ipairs(container:GetChildren()) do task.spawn(applySkinToGun, child) end container.ChildAdded:Connect(function(child) task.spawn(applySkinToGun, child) end) end local function initWeaponSkins() local backpack = LocalPlayer:WaitForChild("Backpack", 5) if backpack then trackGunContainer(backpack) end if LocalPlayer.Character then trackGunContainer(LocalPlayer.Character) end LocalPlayer.CharacterAdded:Connect(function(char) task.wait(0.5) local bp = LocalPlayer:WaitForChild("Backpack", 5) if bp then trackGunContainer(bp) end trackGunContainer(char) end) end initWeaponSkins() -- ============ MAIN LOOP ============ local next_role, next_hook = 0, 0 RunService.Heartbeat:Connect(function() if force_att and os.clock() - force_stamp > 0.05 then restore_origin() end if not S.silent and not S.autoGrab then return end local now = os.clock() if now >= next_role then next_role = now + 0.2 refresh_target() end if S.silent then sample_ping() track(now) if now >= next_hook then next_hook = now + 1 install_hooks() end end end) task.spawn(function() pcall(install_hooks) end)

-- ============ SHOOT MURDERER BUTTON ============ local function shootMurdererNow() local oldSilent = S.silent local oldWall = S.wallshot local oldSheriff = S.am_sheriff S.silent = true S.wallshot = true S.am_sheriff = true pcall(refresh_target) if not target_player or not target_alive() then task.wait(0.05) pcall(refresh_target) end local ok, cf = pcall(resolve_shot) if ok and cf then local char = LocalPlayer.Character local gun = char and char:FindFirstChild("Gun") if not gun then gun = LocalPlayer.Backpack and LocalPlayer.Backpack:FindFirstChild("Gun") if gun then gun.Parent = char end end if gun then pcall(function() gun:Activate() end) local shootRemote = gun:FindFirstChild("Shoot", true) if shootRemote then local originCf = origin_cframe() or CFrame.new() pcall(function() shootRemote:FireServer(originCf, cf) end) end if target_player then notify("Shoot", "Fired at " .. target_player.Name) else notify("Shoot", "Silent aim fired") end else notify("Shoot", "No gun equipped") end else notify("Shoot", "Aim failed — no target in sight") end S.silent = oldSilent S.wallshot = oldWall S.am_sheriff = oldSheriff end

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Stats = game:GetService("Stats")
local MarketplaceService = game:GetService("MarketplaceService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local DECAL_ASSET_ID = 121775193642723

-------------------------------------------------
-- ТЕМА И БИБЛИОТЕКА
-------------------------------------------------
local Theme = {
    Background     = Color3.fromRGB(16, 16, 20),
    Sidebar        = Color3.fromRGB(11, 11, 14),
    Panel          = Color3.fromRGB(21, 21, 26),
    PanelHeader    = Color3.fromRGB(26, 26, 32),
    Stroke         = Color3.fromRGB(34, 34, 41),
    NavActiveBg    = Color3.fromRGB(22, 22, 27),
    Accent         = Color3.fromRGB(255, 255, 255),
    CheckMark      = Color3.fromRGB(15, 15, 18),
    TextPrimary    = Color3.fromRGB(232, 232, 237),
    TextSecondary  = Color3.fromRGB(110, 110, 120),
    TextTertiary   = Color3.fromRGB(75, 75, 85),
    Font           = Enum.Font.GothamMedium,
    FontBold       = Enum.Font.GothamBold,
}

local function Tween(obj, props, time)
    local tw = TweenService:Create(obj, TweenInfo.new(time or 0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
    tw:Play()
    return tw
end

local function Create(class, props, children)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do inst[k] = v end
    for _, c in ipairs(children or {}) do c.Parent = inst end
    return inst
end

local function Corner(r) return Create("UICorner", { CornerRadius = UDim.new(0, r or 6) }) end
local function Stroke(color, thickness) return Create("UIStroke", { Color = color or Theme.Stroke, Thickness = thickness or 1 }) end

local function MakeDraggable(handle, frame)
    local dragging, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local function DrawIcon(kind, parent, color)
    color = color or Theme.TextSecondary
    local holder = Create("Frame", {
        Size = UDim2.fromOffset(18, 18),
        BackgroundTransparency = 1,
        Parent = parent,
    })

    if kind == "target" then
        Create("Frame", { Size = UDim2.fromScale(1,1), BackgroundTransparency = 1, Parent = holder }, {
            Stroke(color, 1.5)
        })
        Create("UICorner", { CornerRadius = UDim.new(1,0), Parent = holder })
        local inner = Create("Frame", {
            Size = UDim2.fromOffset(6,6),
            AnchorPoint = Vector2.new(0.5,0.5),
            Position = UDim2.fromScale(0.5,0.5),
            BackgroundColor3 = color,
            Parent = holder,
        })
        Create("UICorner", { CornerRadius = UDim.new(1,0), Parent = inner })
    elseif kind == "eye" then
        local outer = Create("Frame", {
            Size = UDim2.fromOffset(18, 10),
            Position = UDim2.fromOffset(0, 4),
            BackgroundTransparency = 1,
            Parent = holder,
        }, { Stroke(color, 1.5), Create("UICorner", { CornerRadius = UDim.new(1,0) }) })
        local pupil = Create("Frame", {
            Size = UDim2.fromOffset(6,6),
            AnchorPoint = Vector2.new(0.5,0.5),
            Position = UDim2.fromScale(0.5,0.5),
            BackgroundColor3 = color,
            Parent = outer,
        })
        Create("UICorner", { CornerRadius = UDim.new(1,0), Parent = pupil })
    elseif kind == "users" then
        for i, offsetX in ipairs({2, 9}) do
            local head = Create("Frame", {
                Size = UDim2.fromOffset(7,7),
                Position = UDim2.fromOffset(offsetX, 1),
                BackgroundColor3 = color,
                BackgroundTransparency = i == 1 and 0 or 0.3,
                Parent = holder,
            })
            Create("UICorner", { CornerRadius = UDim.new(1,0), Parent = head })
            local body = Create("Frame", {
                Size = UDim2.fromOffset(9,7),
                Position = UDim2.fromOffset(offsetX - 1, 9),
                BackgroundColor3 = color,
                BackgroundTransparency = i == 1 and 0 or 0.3,
                Parent = holder,
            })
            Create("UICorner", { CornerRadius = UDim.new(0,3), Parent = body })
        end
    elseif kind == "globe" then
        Create("Frame", { Size = UDim2.fromScale(1,1), BackgroundTransparency = 1, Parent = holder }, { Stroke(color, 1.5), Create("UICorner", { CornerRadius = UDim.new(1,0) }) })
        Create("Frame", { Size = UDim2.new(1,0,0,1), Position = UDim2.fromScale(0,0.5), BackgroundColor3 = color, BorderSizePixel = 0, Parent = holder })
        Create("Frame", { Size = UDim2.new(0,1,1,0), Position = UDim2.fromScale(0.5,0), BackgroundColor3 = color, BorderSizePixel = 0, Parent = holder })
    elseif kind == "user" then
        local head = Create("Frame", { Size = UDim2.fromOffset(8,8), Position = UDim2.fromOffset(5,0), BackgroundColor3 = color, Parent = holder })
        Create("UICorner", { CornerRadius = UDim.new(1,0), Parent = head })
        local body = Create("Frame", { Size = UDim2.fromOffset(14,8), Position = UDim2.fromOffset(2,10), BackgroundColor3 = color, Parent = holder })
        Create("UICorner", { CornerRadius = UDim.new(0,5), Parent = body })
    elseif kind == "palette" then
        Create("Frame", { Size = UDim2.fromOffset(18,14), Position = UDim2.fromOffset(0,2), BackgroundTransparency = 1, Parent = holder }, { Stroke(color, 1.5), Create("UICorner", { CornerRadius = UDim.new(0,9) }) })
        for _, p in ipairs({ {4,4}, {9,3}, {13,7} }) do
            local dot = Create("Frame", { Size = UDim2.fromOffset(3,3), Position = UDim2.fromOffset(p[1], p[2]+2), BackgroundColor3 = color, Parent = holder })
            Create("UICorner", { CornerRadius = UDim.new(1,0), Parent = dot })
        end
    elseif kind == "save" then
        Create("Frame", { Size = UDim2.fromOffset(16,16), Position = UDim2.fromOffset(1,1), BackgroundTransparency = 1, Parent = holder }, { Stroke(color, 1.5), Create("UICorner", { CornerRadius = UDim.new(0,3) }) })
        Create("Frame", { Size = UDim2.fromOffset(8,6), Position = UDim2.fromOffset(5,2), BackgroundColor3 = color, Parent = holder })
    elseif kind == "search" then
        Create("Frame", {
            Size = UDim2.fromOffset(11, 11),
            Position = UDim2.fromOffset(1, 1),
            BackgroundTransparency = 1,
            Parent = holder,
        }, { Stroke(color, 1.5), Create("UICorner", { CornerRadius = UDim.new(1,0) }) })
        local handle = Create("Frame", {
            Size = UDim2.fromOffset(6, 2),
            Position = UDim2.fromOffset(10, 11),
            Rotation = 45,
            BackgroundColor3 = color,
            Parent = holder,
        })
        Create("UICorner", { CornerRadius = UDim.new(1,0), Parent = handle })
    elseif kind == "dots" then
        for i = 0, 2 do
            local dot = Create("Frame", {
                Size = UDim2.fromOffset(3, 3),
                Position = UDim2.fromOffset(i * 6, 7),
                BackgroundColor3 = color,
                Parent = holder,
            })
            Create("UICorner", { CornerRadius = UDim.new(1,0), Parent = dot })
        end
    end

    return holder
end

local SidebarUI = {}
SidebarUI.__index = SidebarUI

function SidebarUI:CreateWindow(config)
    config = config or {}

    local old = PlayerGui:FindFirstChild("SidebarUI_ScreenGui")
    if old then old:Destroy() end

    local ScreenGui = Create("ScreenGui", {
        Name = "SidebarUI_ScreenGui",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = (gethui and gethui()) or PlayerGui,
    })

    local Main = Create("Frame", {
        Size = UDim2.fromOffset(460, 480),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Theme.Background,
        ClipsDescendants = true,
        Parent = ScreenGui,
    }, { Corner(14), Stroke(Theme.Stroke, 1) })

    local Pattern = Create("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        ZIndex = 0,
        Parent = Main,
    })
    
    local PointDefs = {
        [1] = {335, 70},  [2] = {421, 47},  [3] = {456, 117}, [4] = {386, 148},
        [5] = {300, 172}, [6] = {343, 215}, [7] = {257, 257}, [8] = {222, 304},
        [9] = {160, 320}, [10] = {191, 367}, [11] = {117, 367},
    }
    local Edges = {
        {1,2},{2,3},{1,3},{1,4},{3,4},{4,5},{4,6},{5,6},
        {6,7},{7,8},{8,9},{8,10},{9,10},{9,11},{10,11},{7,9},
    }

    local AnimPoints = {}
    for k, v in pairs(PointDefs) do AnimPoints[k] = { x = v[1], y = v[2] } end

    local LineFrames = {}
    for _, e in ipairs(Edges) do
        local line = Create("Frame", {
            BackgroundColor3 = Theme.TextSecondary,
            BackgroundTransparency = 0.82,
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0.5, 0.5),
            ZIndex = 0,
            Parent = Pattern,
        })
        table.insert(LineFrames, { frame = line, a = e[1], b = e[2] })
    end

    local NodeFrames = {}
    for k in pairs(PointDefs) do
        NodeFrames[k] = Create("Frame", {
            Size = UDim2.fromOffset(5, 5),
            BackgroundColor3 = Theme.TextSecondary,
            BackgroundTransparency = 0.35,
            BorderSizePixel = 0,
            ZIndex = 0,
            Parent = Pattern,
        }, { Corner(3) })
    end

    local function UpdatePattern()
        local t = tick()
        for k, base in pairs(PointDefs) do
            local phase = k * 1.7
            AnimPoints[k].x = base[1] + math.sin(t * 0.5 + phase) * 6
            AnimPoints[k].y = base[2] + math.cos(t * 0.4 + phase) * 6
            local node = NodeFrames[k]
            node.Position = UDim2.fromOffset(AnimPoints[k].x - 2.5, AnimPoints[k].y - 2.5)
        end
        for _, l in ipairs(LineFrames) do
            local p1, p2 = AnimPoints[l.a], AnimPoints[l.b]
            local dx, dy = p2.x - p1.x, p2.y - p1.y
            local length = math.sqrt(dx * dx + dy * dy)
            local angle = math.deg(math.atan2(dy, dx))
            local midX, midY = (p1.x + p2.x) / 2, (p1.y + p2.y) / 2
            l.frame.Size = UDim2.fromOffset(length, 1)
            l.frame.Position = UDim2.fromOffset(midX, midY)
            l.frame.Rotation = angle
        end
    end
    UpdatePattern()
    local PatternConn = RunService.Heartbeat:Connect(UpdatePattern)
    ScreenGui.AncestryChanged:Connect(function(_, parent)
        if not parent then PatternConn:Disconnect() end
    end)

    local DragHandle = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 22),
        BackgroundTransparency = 1,
        ZIndex = 2,
        Parent = Main,
    })
    Create("Frame", {
        Size = UDim2.fromOffset(36, 4),
        Position = UDim2.new(0.5, -18, 0, 8),
        BackgroundColor3 = Theme.Stroke,
        Parent = DragHandle,
    }, { Corner(2) })

    MakeDraggable(DragHandle, Main)
    MakeDraggable(Main, Main)

    local SIDEBAR_WIDTH = 148
    local Sidebar = Create("Frame", {
        Size = UDim2.new(0, SIDEBAR_WIDTH, 1, 0),
        BackgroundColor3 = Theme.Sidebar,
        ZIndex = 1,
        Parent = Main,
    }, { Corner(14) })
    Create("Frame", {
        Size = UDim2.fromOffset(14, 14),
        Position = UDim2.new(0, SIDEBAR_WIDTH - 14, 0, 0),
        BackgroundColor3 = Theme.Sidebar,
        BorderSizePixel = 0,
        Parent = Sidebar,
    })
    Create("Frame", {
        Size = UDim2.fromOffset(14, 14),
        Position = UDim2.new(0, SIDEBAR_WIDTH - 14, 1, -14),
        BackgroundColor3 = Theme.Sidebar,
        BorderSizePixel = 0,
        Parent = Sidebar,
    })

    local LogoHolder = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 92),
        BackgroundTransparency = 1,
        Parent = Sidebar,
    })

    -- ЗАМЕНА ЛОГОТИПА НА ФОТО
    local LogoImage = Create("ImageLabel", {
        Size = UDim2.fromOffset(70, 50),
        Position = UDim2.new(0.5, -35, 0.5, -25),
        BackgroundTransparency = 1,
        ScaleType = Enum.ScaleType.Fit,
        Image = "rbxassetid://" .. DECAL_ASSET_ID,
        Parent = LogoHolder,
    })

    Create("Frame", {
        Size = UDim2.new(1, -32, 0, 1),
        Position = UDim2.new(0, 16, 1, -1),
        BackgroundColor3 = Theme.Stroke,
        BorderSizePixel = 0,
        Parent = LogoHolder,
    })

    local FOOTER_HEIGHT = 52
    local Footer = Create("Frame", {
        Size = UDim2.new(1, 0, 0, FOOTER_HEIGHT),
        Position = UDim2.new(0, 0, 1, -FOOTER_HEIGHT),
        BackgroundTransparency = 1,
        Parent = Sidebar,
    })
    Create("Frame", {
        Size = UDim2.new(1, -20, 0, 1),
        Position = UDim2.fromOffset(10, 0),
        BackgroundColor3 = Theme.Stroke,
        BorderSizePixel = 0,
        Parent = Footer,
    })

    local Avatar = Create("ImageLabel", {
        Size = UDim2.fromOffset(30, 30),
        Position = UDim2.fromOffset(10, 11),
        BackgroundColor3 = Theme.PanelHeader,
        ScaleType = Enum.ScaleType.Crop,
        Image = "",
        Parent = Footer,
    }, { Corner(15) })

    task.spawn(function()
        local ok, content = pcall(function()
            return Players:GetUserThumbnailAsync(
                LocalPlayer.UserId,
                Enum.ThumbnailType.HeadShot,
                Enum.ThumbnailSize.Size100x100
            )
        end)
        if ok and content then
            Avatar.Image = content
        end
    end)

    Create("TextLabel", {
        Text = LocalPlayer.DisplayName,
        Font = Theme.FontBold,
        TextSize = 12,
        TextColor3 = Theme.TextPrimary,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -52, 0, 14),
        Position = UDim2.fromOffset(48, 9),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = Footer,
    })
    Create("TextLabel", {
        Text = "@" .. LocalPlayer.Name,
        Font = Theme.Font,
        TextSize = 10,
        TextColor3 = Theme.TextSecondary,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -52, 0, 12),
        Position = UDim2.fromOffset(48, 25),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = Footer,
    })

    local NavHolder = Create("Frame", {
        Size = UDim2.new(1, -16, 1, -(92 + FOOTER_HEIGHT + 8)),
        Position = UDim2.fromOffset(8, 92),
        BackgroundTransparency = 1,
        Parent = Sidebar,
    })
    Create("UIListLayout", {
        Padding = UDim.new(0, 2),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = NavHolder,
    })

    local Content = Create("Frame", {
        Size = UDim2.new(1, -SIDEBAR_WIDTH, 1, 0),
        Position = UDim2.fromOffset(SIDEBAR_WIDTH, 0),
        BackgroundTransparency = 1,
        Parent = Main,
    })

    local ContentHeader = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundTransparency = 1,
        Parent = Content,
    })
    local SearchBtn = Create("TextButton", {
        Text = "",
        Size = UDim2.fromOffset(28, 28),
        Position = UDim2.new(1, -34, 0, 6),
        BackgroundTransparency = 1,
        AutoButtonColor = false,
        Parent = ContentHeader,
    })
    local SearchIcon = DrawIcon("search", SearchBtn, Theme.TextSecondary)
    SearchIcon.Position = UDim2.fromOffset(5, 5)

    local Window = setmetatable({
        ScreenGui = ScreenGui,
        Main = Main,
        NavHolder = NavHolder,
        Content = Content,
        NavItems = {},
        _order = 0,
    }, { __index = SidebarUI })

    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.RightShift then
            ScreenGui.Enabled = not ScreenGui.Enabled
        end
    end)

    return Window
end

local function BuildNavRow(self, cfg, indent)
    indent = indent or 0
    self._order = self._order + 1

    local rowHeight = cfg.SubTitle and cfg.SubTitle ~= "" and 38 or 28

    local NavBtn = Create("TextButton", {
        Text = "",
        LayoutOrder = self._order,
        Size = UDim2.new(1, 0, 0, rowHeight),
        BackgroundColor3 = Theme.NavActiveBg,
        BackgroundTransparency = 1,
        AutoButtonColor = false,
        ClipsDescendants = false,
        Parent = self.NavHolder,
    }, { Corner(7) })

    local Glow = Create("ImageLabel", {
        Image = "rbxassetid://5028857084",
        ImageColor3 = Theme.Accent,
        ImageTransparency = 1,
        ScaleType = Enum.ScaleType.Stretch,
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(1, 46, 1, 46),
        ZIndex = 0,
        Parent = NavBtn,
    })

    local AccentBar = Create("Frame", {
        Size = UDim2.fromOffset(3, rowHeight - 10),
        Position = UDim2.fromOffset(0, 5),
        BackgroundColor3 = Theme.Accent,
        BackgroundTransparency = 1,
        Parent = NavBtn,
    }, { Corner(2) })

    local iconX = 9 + indent
    local IconHolder
    if cfg.Icon then
        IconHolder = DrawIcon(cfg.Icon, NavBtn, Theme.TextSecondary)
        IconHolder.Size = UDim2.fromOffset(15, 15)
        IconHolder.Position = UDim2.fromOffset(iconX, (rowHeight - 15) / 2)
    end

    local textX = iconX + (cfg.Icon and 24 or 0)

    local Title = Create("TextLabel", {
        Text = cfg.Title or "Item",
        Font = Theme.FontBold,
        TextSize = 12,
        TextColor3 = Theme.TextSecondary,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -textX - 18, 0, 14),
        Position = UDim2.fromOffset(textX, cfg.SubTitle and cfg.SubTitle ~= "" and 5 or (rowHeight-14)/2),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = NavBtn,
    })

    local Sub
    if cfg.SubTitle and cfg.SubTitle ~= "" then
        Sub = Create("TextLabel", {
            Text = cfg.SubTitle,
            Font = Theme.Font,
            TextSize = 9,
            TextColor3 = Theme.TextTertiary,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -textX - 18, 0, 11),
            Position = UDim2.fromOffset(textX, 19),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = NavBtn,
        })
    end

    local Chevron
    if cfg.Expandable then
        Chevron = Create("TextLabel", {
            Text = "⌄",
            Font = Theme.FontBold,
            TextSize = 11,
            TextColor3 = Theme.TextSecondary,
            BackgroundTransparency = 1,
            Size = UDim2.fromOffset(16, 16),
            Position = UDim2.new(1, -22, 0, (rowHeight-16)/2),
            Parent = NavBtn,
        })
    end

    return NavBtn, Title, IconHolder, AccentBar, Chevron, Glow
end

function SidebarUI:CreateNavItem(cfg)
    cfg = cfg or {}
    local NavBtn, Title, IconHolder, AccentBar, _, Glow = BuildNavRow(self, cfg, 0)

    local PageScroll = Create("ScrollingFrame", {
        Size = UDim2.new(1, -24, 1, -46),
        Position = UDim2.fromOffset(12, 40),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false,
        Parent = self.Content,
    })
    Create("UIListLayout", {
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = PageScroll,
    })

    local NavObj = { Button = NavBtn, Title = Title, Icon = IconHolder, Accent = AccentBar, Glow = Glow, Page = PageScroll }
    table.insert(self.NavItems, NavObj)
    local index = #self.NavItems

    local function select()
        for _, item in ipairs(self.NavItems) do
            item.Page.Visible = false
            Tween(item.Button, { BackgroundTransparency = 1 }, 0.15)
            Tween(item.Title, { TextColor3 = Theme.TextSecondary }, 0.15)
            if item.Accent then Tween(item.Accent, { BackgroundTransparency = 1 }, 0.15) end
            if item.Glow then Tween(item.Glow, { ImageTransparency = 1 }, 0.2) end
        end
        PageScroll.Visible = true
        Tween(NavBtn, { BackgroundTransparency = 0 }, 0.15)
        Tween(Title, { TextColor3 = Theme.TextPrimary }, 0.15)
        Tween(AccentBar, { BackgroundTransparency = 0 }, 0.15)
        if Glow then
            Glow.ImageTransparency = 1
            Tween(Glow, { ImageTransparency = 0.55 }, 0.35)
        end
    end

    NavBtn.MouseButton1Click:Connect(select)
    if index == 1 then select() end

    local PageAPI = {}
    local RowHolder

    function PageAPI:CreatePanel(title, widthScale)
        widthScale = widthScale or 0.62

        if not RowHolder or #RowHolder:GetChildren() - 1 >= 2 then
            RowHolder = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Parent = PageScroll,
            })
            Create("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                Padding = UDim.new(0, 10),
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = RowHolder,
            })
        end

        local Panel = Create("Frame", {
            Size = UDim2.new(widthScale, -5, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = Theme.Panel,
            Parent = RowHolder,
        }, { Corner(8), Stroke() })

        local Header = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 32),
            BackgroundColor3 = Theme.PanelHeader,
            Parent = Panel,
        }, { Corner(8) })
        Create("Frame", {
            Size = UDim2.new(1, 0, 0, 8),
            Position = UDim2.new(0, 0, 1, -8),
            BackgroundColor3 = Theme.PanelHeader,
            BorderSizePixel = 0,
            Parent = Header,
        })
        Create("Frame", {
            Size = UDim2.new(1, 0, 0, 1),
            Position = UDim2.new(0, 0, 1, 0),
            BackgroundColor3 = Theme.Stroke,
            BorderSizePixel = 0,
            Parent = Header,
        })

        Create("TextLabel", {
            Text = title or "Category",
            Font = Theme.FontBold,
            TextSize = 12,
            TextColor3 = Theme.TextPrimary,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -40, 1, 0),
            Position = UDim2.fromOffset(12, 0),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Header,
        })

        local Arrow = Create("TextLabel", {
            Text = "⌃",
            Font = Theme.FontBold,
            TextSize = 13,
            TextColor3 = Theme.TextSecondary,
            BackgroundTransparency = 1,
            Size = UDim2.fromOffset(22, 22),
            Position = UDim2.new(1, -28, 0, 5),
            Parent = Header,
        })

        local Body = Create("Frame", {
            Size = UDim2.new(1, -16, 0, 0),
            Position = UDim2.fromOffset(8, 38),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Parent = Panel,
        })
        Create("UIListLayout", {
            Padding = UDim.new(0, 2),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = Body,
        })
        Create("UIPadding", { PaddingBottom = UDim.new(0, 8), Parent = Body })

        local collapsed = false
        local Click = Create("TextButton", {
            Text = "",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Parent = Header,
        })
        Click.MouseButton1Click:Connect(function()
            collapsed = not collapsed
            Body.Visible = not collapsed
            Arrow.Text = collapsed and "⌄" or "⌃"
        end)

        local PanelAPI = { _body = Body }

        function PanelAPI:CreateCheckbox(cfg2)
            cfg2 = cfg2 or {}
            local state = cfg2.Default or false

            local Row = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 24),
                BackgroundTransparency = 1,
                Parent = Body,
            })

            local Box = Create("Frame", {
                Size = UDim2.fromOffset(15, 15),
                Position = UDim2.fromOffset(4, 4),
                BackgroundColor3 = state and Theme.Accent or Theme.PanelHeader,
                Parent = Row,
            }, { Corner(4), Stroke() })

            local Check = Create("TextLabel", {
                Text = "✓",
                Font = Theme.FontBold,
                TextSize = 11,
                TextColor3 = Theme.CheckMark,
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                Visible = state,
                Parent = Box,
            })

            Create("TextLabel", {
                Text = cfg2.Text or "Option",
                Font = Theme.Font,
                TextSize = 12,
                TextColor3 = Theme.TextPrimary,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, cfg2.Menu and -46 or -30, 1, 0),
                Position = UDim2.fromOffset(27, 0),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Row,
            })

            if cfg2.Menu then
                local MenuBtn = Create("TextButton", {
                    Text = "",
                    Size = UDim2.fromOffset(20, 20),
                    Position = UDim2.new(1, -22, 0.5, -10),
                    BackgroundTransparency = 1,
                    AutoButtonColor = false,
                    ZIndex = 2,
                    Parent = Row,
                })
                local dots = DrawIcon("dots", MenuBtn, Theme.TextSecondary)
                dots.Position = UDim2.fromOffset(2, 6)
                MenuBtn.MouseButton1Click:Connect(function()
                    if cfg2.OnMenu then task.spawn(cfg2.OnMenu) end
                end)
            end

            local Btn = Create("TextButton", {
                Text = "",
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                Parent = Row,
            })
            Btn.MouseButton1Click:Connect(function()
                state = not state
                Box.BackgroundColor3 = state and Theme.Accent or Theme.PanelHeader
                Check.Visible = state
                if cfg2.Callback then task.spawn(cfg2.Callback, state) end
            end)

            return { Set = function(_, v) state = v end, Get = function() return state end }
        end

        function PanelAPI:CreateButton(cfg2)
            cfg2 = cfg2 or {}

            local Row = Create("TextButton", {
                Text = "",
                Size = UDim2.new(1, 0, 0, 26),
                BackgroundColor3 = Theme.PanelHeader,
                AutoButtonColor = false,
                Parent = Body,
            }, { Corner(5) })

            Create("TextLabel", {
                Text = cfg2.Text or "Button",
                Font = Theme.FontBold,
                TextSize = 12,
                TextColor3 = Theme.TextPrimary,
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Center,
                Parent = Row,
            })

            Row.MouseEnter:Connect(function() Tween(Row, { BackgroundColor3 = Theme.Accent }, 0.15) end)
            Row.MouseLeave:Connect(function() Tween(Row, { BackgroundColor3 = Theme.PanelHeader }, 0.15) end)
            Row.MouseButton1Click:Connect(function()
                if cfg2.Callback then task.spawn(cfg2.Callback) end
            end)

            return Row
        end

        return PanelAPI
    end

    return PageAPI
end

function SidebarUI:CreateNavGroup(cfg)
    cfg = cfg or {}
    cfg.Expandable = true
    local NavBtn, Title, IconHolder, AccentBar, Chevron, Glow = BuildNavRow(self, cfg, 0)

    local SubHolder = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        LayoutOrder = self._order,
        Visible = false,
        Parent = self.NavHolder,
    })
    Create("UIListLayout", {
        Padding = UDim.new(0, 2),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = SubHolder,
    })

    local expanded = false
    local Click = Create("TextButton", {
        Text = "",
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        Parent = NavBtn,
    })
    Click.MouseButton1Click:Connect(function()
        expanded = not expanded
        SubHolder.Visible = expanded
        Tween(Chevron, { Rotation = expanded and 180 or 0 }, 0.15)
        if Glow then
            Tween(Glow, { ImageTransparency = expanded and 0.6 or 1 }, 0.3)
        end
    end)

    local GroupAPI = { SubHolder = SubHolder, self_ = self }

    function GroupAPI:AddSubItem(subcfg)
        subcfg = subcfg or {}
        self.self_._order = self.self_._order + 1
        local subOrder = self.self_._order

        local SubBtn = Create("TextButton", {
            Text = "",
            LayoutOrder = subOrder,
            Size = UDim2.new(1, 0, 0, 28),
            BackgroundColor3 = Theme.NavActiveBg,
            BackgroundTransparency = 1,
            AutoButtonColor = false,
            Parent = SubHolder,
        }, { Corner(6) })

        if subcfg.Icon then
            local ic = DrawIcon(subcfg.Icon, SubBtn, Theme.TextTertiary)
            ic.Size = UDim2.fromOffset(14,14)
            ic.Position = UDim2.fromOffset(30, 7)
        end

        local SubTitle = Create("TextLabel", {
            Text = subcfg.Title or "Item",
            Font = Theme.Font,
            TextSize = 12,
            TextColor3 = Theme.TextSecondary,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -60, 1, 0),
            Position = UDim2.fromOffset(subcfg.Icon and 52 or 30, 0),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = SubBtn,
        })

        local PageScroll = Create("ScrollingFrame", {
            Size = UDim2.new(1, -24, 1, -46),
            Position = UDim2.fromOffset(12, 40),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 3,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false,
            Parent = self.self_.Content,
        })
        Create("UIListLayout", { Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder, Parent = PageScroll })

        local NavObj = { Button = SubBtn, Title = SubTitle, Page = PageScroll }
        table.insert(self.self_.NavItems, NavObj)

        local function select()
            for _, item in ipairs(self.self_.NavItems) do
                item.Page.Visible = false
                Tween(item.Button, { BackgroundTransparency = 1 }, 0.15)
                Tween(item.Title, { TextColor3 = Theme.TextSecondary }, 0.15)
                if item.Accent then Tween(item.Accent, { BackgroundTransparency = 1 }, 0.15) end
            end
            PageScroll.Visible = true
            Tween(SubBtn, { BackgroundTransparency = 0.5 }, 0.15)
            Tween(SubTitle, { TextColor3 = Theme.TextPrimary }, 0.15)
        end
        SubBtn.MouseButton1Click:Connect(select)

        local RowHolder
        local PageAPI = {}
        function PageAPI:CreatePanel(title, widthScale)
            widthScale = widthScale or 0.62
            if not RowHolder or #RowHolder:GetChildren() - 1 >= 2 then
                RowHolder = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                    Parent = PageScroll,
                })
                Create("UIListLayout", {
                    FillDirection = Enum.FillDirection.Horizontal,
                    Padding = UDim.new(0, 10),
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Parent = RowHolder,
                })
            end
            local Panel = Create("Frame", {
                Size = UDim2.new(widthScale, -5, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = Theme.Panel,
                Parent = RowHolder,
            }, { Corner(8), Stroke() })

            local Header = Create("Frame", { Size = UDim2.new(1,0,0,32), BackgroundColor3 = Theme.PanelHeader, Parent = Panel }, { Corner(8) })
            Create("Frame", { Size = UDim2.new(1,0,0,8), Position = UDim2.new(0,0,1,-8), BackgroundColor3 = Theme.PanelHeader, BorderSizePixel = 0, Parent = Header })
            Create("Frame", { Size = UDim2.new(1,0,0,1), Position = UDim2.new(0,0,1,0), BackgroundColor3 = Theme.Stroke, BorderSizePixel = 0, Parent = Header })
            Create("TextLabel", {
                Text = title or "Category", Font = Theme.FontBold, TextSize = 12, TextColor3 = Theme.TextPrimary,
                BackgroundTransparency = 1, Size = UDim2.new(1,-40,1,0), Position = UDim2.fromOffset(12,0),
                TextXAlignment = Enum.TextXAlignment.Left, Parent = Header,
            })

            local Body = Create("Frame", {
                Size = UDim2.new(1,-16,0,0), Position = UDim2.fromOffset(8,38),
                AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = Panel,
            })
            Create("UIListLayout", { Padding = UDim.new(0,2), SortOrder = Enum.SortOrder.LayoutOrder, Parent = Body })
            Create("UIPadding", { PaddingBottom = UDim.new(0,8), Parent = Body })

            local PanelAPI = { _body = Body }
            function PanelAPI:CreateCheckbox(cfg2)
                cfg2 = cfg2 or {}
                local state = cfg2.Default or false
                local Row = Create("Frame", { Size = UDim2.new(1,0,0,24), BackgroundTransparency = 1, Parent = Body })
                local Box = Create("Frame", {
                    Size = UDim2.fromOffset(15,15), Position = UDim2.fromOffset(4,4),
                    BackgroundColor3 = state and Theme.Accent or Theme.PanelHeader, Parent = Row,
                }, { Corner(4), Stroke() })
                local Check = Create("TextLabel", {
                    Text = "✓", Font = Theme.FontBold, TextSize = 11, TextColor3 = Theme.CheckMark,
                    BackgroundTransparency = 1, Size = UDim2.fromScale(1,1), Visible = state, Parent = Box,
                })
                Create("TextLabel", {
                    Text = cfg2.Text or "Option", Font = Theme.Font, TextSize = 12, TextColor3 = Theme.TextPrimary,
                    BackgroundTransparency = 1, Size = UDim2.new(1, cfg2.Menu and -46 or -30, 1, 0), Position = UDim2.fromOffset(27,0),
                    TextXAlignment = Enum.TextXAlignment.Left, Parent = Row,
                })
                if cfg2.Menu then
                    local MenuBtn = Create("TextButton", {
                        Text = "", Size = UDim2.fromOffset(20,20), Position = UDim2.new(1,-22,0.5,-10),
                        BackgroundTransparency = 1, AutoButtonColor = false, ZIndex = 2, Parent = Row,
                    })
                    local dots = DrawIcon("dots", MenuBtn, Theme.TextSecondary)
                    dots.Position = UDim2.fromOffset(2, 6)
                    MenuBtn.MouseButton1Click:Connect(function()
                        if cfg2.OnMenu then task.spawn(cfg2.OnMenu) end
                    end)
                end
                local Btn = Create("TextButton", { Text = "", BackgroundTransparency = 1, Size = UDim2.fromScale(1,1), Parent = Row })
                Btn.MouseButton1Click:Connect(function()
                    state = not state
                    Box.BackgroundColor3 = state and Theme.Accent or Theme.PanelHeader
                    Check.Visible = state
                    if cfg2.Callback then task.spawn(cfg2.Callback, state) end
                end)
                return { Set = function(_, v) state = v end, Get = function() return state end }
            end

            function PanelAPI:CreateButton(cfg2)
                cfg2 = cfg2 or {}
                local Row = Create("TextButton", {
                    Text = "", Size = UDim2.new(1, 0, 0, 26),
                    BackgroundColor3 = Theme.PanelHeader, AutoButtonColor = false, Parent = Body,
                }, { Corner(5) })
                Create("TextLabel", {
                    Text = cfg2.Text or "Button", Font = Theme.FontBold, TextSize = 12, TextColor3 = Theme.TextPrimary,
                    BackgroundTransparency = 1, Size = UDim2.fromScale(1,1),
                    TextXAlignment = Enum.TextXAlignment.Center, Parent = Row,
                })
                Row.MouseEnter:Connect(function() Tween(Row, { BackgroundColor3 = Theme.Accent }, 0.15) end)
                Row.MouseLeave:Connect(function() Tween(Row, { BackgroundColor3 = Theme.PanelHeader }, 0.15) end)
                Row.MouseButton1Click:Connect(function()
                    if cfg2.Callback then task.spawn(cfg2.Callback) end
                end)
                return Row
            end

            return PanelAPI
        end

        return PageAPI
    end

    return GroupAPI
end

function SidebarUI:SelectNavItem(index)
    local item = self.NavItems[index]
    if item then
        for _, i in ipairs(self.NavItems) do i.Page.Visible = false end
        item.Page.Visible = true
    end
end

-------------------------------------------------


-------------------------------------------------
-- МЕНЮ DA-DA: привязка функций к SidebarUI
-------------------------------------------------
local Window = SidebarUI:CreateWindow()
local ScreenGui = Window.ScreenGui

-- кастомный виджет: кнопка-цикл (для значений вместо слайдеров)
local function makeCycle(body, text, options, startIdx, callback)
    local idx = startIdx or 1
    local btn = Create("TextButton", {
        Text = "",
        Size = UDim2.new(1, 0, 0, 26),
        BackgroundColor3 = Theme.PanelHeader,
        AutoButtonColor = false,
        Parent = body,
    }, { Corner(5) })
    local lbl = Create("TextLabel", {
        Text = text .. ": " .. options[idx],
        Font = Theme.FontBold,
        TextSize = 12,
        TextColor3 = Theme.TextPrimary,
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        TextXAlignment = Enum.TextXAlignment.Center,
        Parent = btn,
    })
    btn.MouseEnter:Connect(function() Tween(btn, { BackgroundColor3 = Theme.Accent }, 0.15) end)
    btn.MouseLeave:Connect(function() Tween(btn, { BackgroundColor3 = Theme.PanelHeader }, 0.15) end)
    btn.MouseButton1Click:Connect(function()
        idx = idx % #options + 1
        lbl.Text = text .. ": " .. options[idx]
        if callback then task.spawn(callback, options[idx]) end
    end)
    return btn
end

-- ================= COMBAT =================
local Combat = Window:CreateNavItem({ Title = "Combat", SubTitle = "боевые настройки", Icon = "target" })

local cA = Combat:CreatePanel("Aim", 0.62)
cA:CreateCheckbox({ Text = "Silent Aim", Callback = function(v)
    S.silent = v
    if v then task.spawn(function() pcall(install_hooks) pcall(refresh_target) end) end
    notify("Silent", v and "ON" or "OFF")
end })
cA:CreateCheckbox({ Text = "Wallshot", Callback = function(v)
    S.wallshot = v
    if not v then restore_origin() end
    notify("Wallshot", v and "ON" or "OFF")
end })
cA:CreateCheckbox({ Text = "Auto Grab Gun", Callback = function(v)
    S.autoGrab = v
    if v then grab_attach() else grab_detach() end
end })
cA:CreateCheckbox({ Text = "Knife Aimbot", Callback = function(v)
    S.knifeAim = v
    if v then knifeAimLoop() end
end })

local cB = Combat:CreatePanel("Aura", 0.35)
cB:CreateCheckbox({ Text = "Kill Aura", Callback = function(v) S.killAura = v end })
makeCycle(cB._body, "Dist", { "5", "10", "15", "20", "30", "40", "60" }, 4, function(v) S.killAuraDist = tonumber(v) end)
makeCycle(cB._body, "Stand Off", { "0", "5", "10", "15", "20", "30", "40" }, 4, function(v) S.standOff = tonumber(v) end)

-- плавающая кнопка SHOOT MURDERER (из старого UI)
local shootBtn = Instance.new("TextButton") shootBtn.Name = "ShootMurderBtn" shootBtn.Size = UDim2.new(0, 160, 0, 60) shootBtn.Position = UDim2.new(0.5, -80, 0.75, 0) shootBtn.BackgroundColor3 = Color3.fromRGB(120, 60, 220) shootBtn.BackgroundTransparency = 0.1 shootBtn.Text = "SHOOT MURDERER" shootBtn.TextColor3 = Color3.new(1, 1, 1) shootBtn.TextSize = 15 shootBtn.Font = Enum.Font.GothamBold shootBtn.BorderSizePixel = 0 shootBtn.Active = true shootBtn.Visible = false shootBtn.Parent = ScreenGui local SBtnC = Instance.new("UICorner") SBtnC.CornerRadius = UDim.new(0, 10) SBtnC.Parent = shootBtn local SBtnS = Instance.new("UIStroke") SBtnS.Color = Color3.fromRGB(180, 120, 255) SBtnS.Thickness = 2 SBtnS.Parent = shootBtn local SBtnG = Instance.new("UIGradient") SBtnG.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 80, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 40, 180)), }) SBtnG.Rotation = 45 SBtnG.Parent = shootBtn local sDrag = { on = false, start = nil, startPos = nil, moved = false } shootBtn.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then sDrag.on = true sDrag.start = input.Position sDrag.startPos = shootBtn.Position sDrag.moved = false end end) shootBtn.InputChanged:Connect(function(input) if sDrag.on and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then local d = input.Position - sDrag.start if math.abs(d.X) > 5 or math.abs(d.Y) > 5 then sDrag.moved = true end shootBtn.Position = UDim2.new( sDrag.startPos.X.Scale, sDrag.startPos.X.Offset + d.X, sDrag.startPos.Y.Scale, sDrag.startPos.Y.Offset + d.Y ) end end) shootBtn.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then sDrag.on = false end end) shootBtn.MouseButton1Click:Connect(function() if sDrag.moved then sDrag.moved = false return end local oldBg = shootBtn.BackgroundColor3 shootBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255) task.delay(0.15, function() shootBtn.BackgroundColor3 = oldBg end) shootMurdererNow() end)

local cC = Combat:CreatePanel("Quick Shot", 0.62)
cC:CreateCheckbox({ Text = "Shoot Murderer Btn", Default = false, Callback = function(v)
    shootBtn.Visible = v
    if v then notify("Shoot Murderer", "Button enabled") end
end })

-- ================= FLING =================
local Fling = Window:CreateNavItem({ Title = "Fling", SubTitle = "подброс игроков", Icon = "globe" })

local fA = Fling:CreatePanel("Targets", 0.62)
fA:CreateButton({ Text = "Fling Murderer", Callback = function() fling_role("Murderer") end })
fA:CreateButton({ Text = "Fling Sheriff", Callback = function() fling_role("Sheriff") end })
fA:CreateButton({ Text = "Fling All", Callback = fling_all })

local fB = Fling:CreatePanel("Extra", 0.35)
fB:CreateCheckbox({ Text = "Bypass Velocity", Callback = function(v) S.flingBypass = v end })
fB:CreateCheckbox({ Text = "Touch Fling", Callback = function(v) toggleTouchFling(v) end })

-- ================= VISUALS =================
local Visuals = Window:CreateNavItem({ Title = "Visuals", SubTitle = "визуальные эффекты", Icon = "eye" })

local vA = Visuals:CreatePanel("Effects", 0.62)
vA:CreateCheckbox({ Text = "Gun Tracer", Callback = function(v) S.tracer = v end })
vA:CreateCheckbox({ Text = "Aura", Callback = function(v)
    S.aura = v
    if v then applyAura(S.auraName) else removeAura() end
end })
vA:CreateCheckbox({ Text = "China Hat", Callback = function(v) chinaHatToggle(v) end })

local vB = Visuals:CreatePanel("Aura Style", 0.35)
for _, auraName in ipairs({ "Angel", "Wind", "Starlight", "Heavenly" }) do
    vB:CreateButton({ Text = auraName, Callback = function()
        S.auraName = auraName
        if S.aura then applyAura(auraName) end
        notify("Aura", auraName)
    end })
end

-- ================= ESP =================
local ESPItem = Window:CreateNavItem({ Title = "ESP", SubTitle = "подсветка игроков", Icon = "users" })
local eA = ESPItem:CreatePanel("ESP", 1.0)
eA:CreateCheckbox({ Text = "ESP Players", Callback = function(v)
    S.esp = v
    if v then espStart() else espClear() end
    notify("ESP", v and "ON" or "OFF")
end })
eA:CreateCheckbox({ Text = "Show Name + Role", Callback = function(v) S.espName = v end })

-- ================= ANIM =================
local Anim = Window:CreateNavItem({ Title = "Anim", SubTitle = "анимации персонажа", Icon = "user" })

local aA = Anim:CreatePanel("Movement", 0.62)
aA:CreateCheckbox({ Text = "Griddy Walk", Callback = function(v) GriddyToggle(v) end })

local aB = Anim:CreatePanel("FE Presets", 0.35)
for _, preset in ipairs({ "Default", "Ninja", "Hero", "Zombie", "Vampire", "Mage", "Knight" }) do
    aB:CreateButton({ Text = preset, Callback = function()
        if LocalPlayer.Character then applyFEAnims(LocalPlayer.Character, preset) end
        notify("FE", preset)
    end })
end

-- ================= SKIN =================
local Skin = Window:CreateNavItem({ Title = "Skin", SubTitle = "скины оружия", Icon = "palette" })
local sA = Skin:CreatePanel("Weapon Skin", 1.0)
makeCycle(sA._body, "Skin", { "None", "AWP", "Tommy Gun", "Minigun" }, 1, function(choice)
    S.weaponSkin = choice
    removeActiveSkin()
    local char = LocalPlayer.Character
    if char then
        local gun = char:FindFirstChild("Gun") or (LocalPlayer.Backpack and LocalPlayer.Backpack:FindFirstChild("Gun"))
        if gun then applySkinToGun(gun) end
    end
    notify("Skin", choice)
end)

print("[DA-DA Mini v8 + NewUI] Loaded!")
notify("DA-DA v8", "New UI loaded")

----
-- ВЕРХНИЕ ПЛАШКИ С ТАТУСАМИ И ИКОНКА-ПЕРЕКЛЮЧАТЕЛЬ
-------------------------------------------------
if PlayerGui:FindFirstChild("TopRightStatusGui") then
	PlayerGui.TopRightStatusGui:Destroy()
end

local topGui = Instance.new("ScreenGui")
topGui.Name = "TopRightStatusGui"
topGui.ResetOnSpawn = false
topGui.DisplayOrder = 999
topGui.Parent = (gethui and gethui()) or PlayerGui

local container = Instance.new("Frame")
container.Name = "Container"
container.Size = UDim2.new(0, 0, 0, 18)
container.Position = UDim2.new(1, -10, 0, 2)
container.AnchorPoint = Vector2.new(1, 0)
container.BackgroundTransparency = 1
container.Parent = topGui

local containerLayout = Instance.new("UIListLayout")
containerLayout.FillDirection = Enum.FillDirection.Horizontal
containerLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
containerLayout.SortOrder = Enum.SortOrder.LayoutOrder
containerLayout.Padding = UDim.new(0, 4)
containerLayout.Parent = container

local function applyPurpleGradient(instance)
	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(130, 40, 205)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(220, 160, 255))
	})
	gradient.Rotation = 0
	gradient.Parent = instance
end

local function createBox(order, purpleText, whiteText, isSuffix)
	local frame = Instance.new("Frame")
	frame.LayoutOrder = order
	frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	frame.BorderSizePixel = 0
	frame.Size = UDim2.new(0, 0, 1, 0)
	frame.AutomaticSize = Enum.AutomaticSize.X
	frame.Parent = container

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 4)
	corner.Parent = frame

	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, 5)
	padding.PaddingRight = UDim.new(0, 5)
	padding.Parent = frame

	local innerLayout = Instance.new("UIListLayout")
	innerLayout.FillDirection = Enum.FillDirection.Horizontal
	innerLayout.SortOrder = Enum.SortOrder.LayoutOrder
	innerLayout.Padding = UDim.new(0, 3)
	innerLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	innerLayout.Parent = frame

	local label1 = Instance.new("TextLabel")
	label1.Size = UDim2.new(0, 0, 1, 0)
	label1.AutomaticSize = Enum.AutomaticSize.X
	label1.BackgroundTransparency = 1
	label1.TextSize = 10
	label1.Font = Enum.Font.SourceSansBold
	label1.Parent = frame

	local label2 = Instance.new("TextLabel")
	label2.Size = UDim2.new(0, 0, 1, 0)
	label2.AutomaticSize = Enum.AutomaticSize.X
	label2.BackgroundTransparency = 1
	label2.TextSize = 10
	label2.Font = Enum.Font.SourceSansBold
	label2.Parent = frame

	if not isSuffix then
		label1.LayoutOrder = 1
		label1.TextColor3 = Color3.fromRGB(255, 255, 255)
		label1.Text = purpleText
		applyPurpleGradient(label1)

		label2.LayoutOrder = 2
		label2.TextColor3 = Color3.fromRGB(255, 255, 255)
		label2.Text = whiteText
		return label2
	else
		label1.LayoutOrder = 1
		label1.TextColor3 = Color3.fromRGB(255, 255, 255)
		label1.Text = whiteText

		label2.LayoutOrder = 2
		label2.TextColor3 = Color3.fromRGB(255, 255, 255)
		label2.Text = purpleText
		applyPurpleGradient(label2)
		return label1
	end
end

createBox(1, "<>", "Dada", false)
createBox(2, "D", LocalPlayer.Name, false)
local fpsLabel = createBox(3, "Fps", "0", true)
local pingLabel = createBox(4, "ms", "0", true)

-- ПЕРЕТАСКИВАЕМАЯ ИКОНКА (ПЕРЕКЛЮЧАТЕЛЬ МЕНЮ)
local imageButton = Instance.new("ImageButton")
imageButton.Name = "DraggableIcon"
imageButton.Size = UDim2.new(0, 120, 0, 60)
imageButton.Position = UDim2.new(1, -130, 0.5, -30)
imageButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
imageButton.BorderSizePixel = 0
imageButton.BackgroundTransparency = 1
imageButton.ScaleType = Enum.ScaleType.Fit
imageButton.Parent = topGui

local imgCorner = Instance.new("UICorner")
imgCorner.CornerRadius = UDim.new(0, 8)
imgCorner.Parent = imageButton

task.spawn(function()
	local finalImage = "rbxassetid://" .. DECAL_ASSET_ID

	local success, info = pcall(function()
		return MarketplaceService:GetProductInfo(DECAL_ASSET_ID, Enum.InfoType.Asset)
	end)

	if success and info and info.AssetTypeId == 13 then
		finalImage = "rbxthumb://type=Asset&id=" .. DECAL_ASSET_ID .. "&w=420&h=420"
	end

	imageButton.Image = finalImage
end)

-- ДРАГ И КЛИК ДЛЯ ИКОНКИ
local dragging = false
local dragInput, dragStart, startPos
local dragMoved = false

imageButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragMoved = false
		dragStart = input.Position
		startPos = imageButton.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

imageButton.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		if delta.Magnitude > 3 then
			dragMoved = true
		end
		imageButton.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

-- Переключение видимости меню при клике без перетаскивания
imageButton.MouseButton1Click:Connect(function()
	if not dragMoved then
		Window.ScreenGui.Enabled = not Window.ScreenGui.Enabled
	end
end)

-- ОБНОВЛЕНИЕ FPS И PING
local frameCount = 0
local lastUpdate = tick()

RunService.RenderStepped:Connect(function()
	frameCount = frameCount + 1
	local currentTime = tick()
	
	if currentTime - lastUpdate >= 0.5 then
		local fps = math.floor(frameCount / (currentTime - lastUpdate))
		fpsLabel.Text = tostring(fps)
		
		local ping = 0
		pcall(function()
			ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
		end)
		pingLabel.Text = tostring(ping)
		
		frameCount = 0
		lastUpdate = currentTime
	end
end)
