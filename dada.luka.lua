--[[
    DA-DA MM2 — REBUILD UI
    Based on the uploaded MM2 readable source.
    New mobile-first UI; feature logic separated from UI.

    Tabs:
      Combat / Visuals / Player / Teleport / Fun / Settings

    Note:
      Some MM2 functions are game-update/executor dependent.
      The UI itself is independent and can be extended without replacing the layout.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local State = {
    Open = true,
    ESP = false,
    RoleESP = true,
    TargetHUD = false,
    SilentAim = false,
    AutoShoot = false,
    AimFOV = 180,
    AimPart = "HumanoidRootPart",
    TeamCheck = false,

    WalkSpeed = 16,
    JumpPower = 50,
    Noclip = false,
    Fly = false,
    FlySpeed = 60,

    FullBright = false,
    NoFog = false,
    Rainbow = false,
    SnowSky = false,
    SpaceSky = false,

    Fling = false,
    AntiAFK = true,

    SelectedPlayer = nil,
    Connections = {},
    ESPObjects = {},
    OriginalLighting = {},
}

--========================================================
-- Helpers
--========================================================

local function connect(signal, fn)
    local c = signal:Connect(fn)
    table.insert(State.Connections, c)
    return c
end

local function getCharacter(plr)
    return plr and plr.Character
end

local function getRoot(plr)
    local c = getCharacter(plr)
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function getHumanoid(plr)
    local c = getCharacter(plr)
    return c and c:FindFirstChildOfClass("Humanoid")
end

local function alive(plr)
    local h = getHumanoid(plr)
    return h and h.Health > 0
end

local function notify(title, text)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = 2
        })
    end)
end

local function roleOf(plr)
    -- MM2 role detection compatible with the common replicated GetPlayerData layout.
    local ok, data = pcall(function()
        local ps = game:GetService("ReplicatedStorage")
            :FindFirstChild("GetPlayerData", true)
        if ps and ps:IsA("RemoteFunction") then
            return ps:InvokeServer()
        end
    end)

    if ok and type(data) == "table" and data[plr.Name] then
        local role = data[plr.Name].Role
        if role then return role end
    end

    -- Fallback: backpack/tool inspection.
    local c = plr.Character
    local b = plr:FindFirstChildOfClass("Backpack")
    local function hasTool(container, name)
        return container and container:FindFirstChild(name) ~= nil
    end

    if hasTool(c, "Knife") or hasTool(b, "Knife") then
        return "Murderer"
    end
    if hasTool(c, "Gun") or hasTool(b, "Gun") then
        return "Sheriff"
    end
    return "Innocent"
end

local function getRoleColor(role)
    if role == "Murderer" then
        return Color3.fromRGB(255, 65, 65)
    elseif role == "Sheriff" then
        return Color3.fromRGB(70, 155, 255)
    elseif role == "Hero" then
        return Color3.fromRGB(255, 215, 40)
    end
    return Color3.fromRGB(235, 235, 240)
end

local function findNearest(filter)
    local root = getRoot(LP)
    if not root then return nil end

    local best, bestDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and alive(plr) then
            local ok = true
            if filter then ok = filter(plr) end
            local r = getRoot(plr)
            if ok and r then
                local d = (r.Position - root.Position).Magnitude
                if d < bestDist then
                    best, bestDist = plr, d
                end
            end
        end
    end
    return best, bestDist
end

local function findMurderer()
    return findNearest(function(plr)
        return roleOf(plr) == "Murderer"
    end)
end

local function findSheriff()
    return findNearest(function(plr)
        return roleOf(plr) == "Sheriff"
    end)
end

--========================================================
-- ESP
--========================================================

local function removeESP(plr)
    local x = State.ESPObjects[plr]
    if x then
        for _, obj in pairs(x) do
            pcall(function() obj:Destroy() end)
        end
        State.ESPObjects[plr] = nil
    end
end

local function makeESP(plr)
    if plr == LP or not State.ESP then return end
    removeESP(plr)

    local root = getRoot(plr)
    if not root then return end

    local bill = Instance.new("BillboardGui")
    bill.Name = "DADA_ESP"
    bill.Adornee = root
    bill.Size = UDim2.fromOffset(180, 44)
    bill.StudsOffset = Vector3.new(0, 3.2, 0)
    bill.AlwaysOnTop = true
    bill.Parent = root

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Size = UDim2.fromScale(1, 1)
    label.Font = Enum.Font.GothamBold
    label.TextScaled = true
    label.TextStrokeTransparency = 0.25
    label.Text = plr.DisplayName
    label.Parent = bill

    local role = roleOf(plr)
    label.TextColor3 = State.RoleESP and getRoleColor(role) or Color3.new(1,1,1)

    State.ESPObjects[plr] = {bill, label}
end

local function refreshESP()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP then
            if State.ESP then
                makeESP(plr)
            else
                removeESP(plr)
            end
        end
    end
end

--========================================================
-- Target / Silent Aim resolver
--========================================================

local function getAimTarget()
    local center = Camera.ViewportSize / 2
    local best, bestScreen = nil, State.AimFOV

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and alive(plr) then
            local role = roleOf(plr)
            local allowed = role ~= "Innocent" or not State.TeamCheck
            if allowed then
                local c = plr.Character
                local part = c and (c:FindFirstChild(State.AimPart) or c:FindFirstChild("Head"))
                if part then
                    local pos, visible = Camera:WorldToViewportPoint(part.Position)
                    if visible and pos.Z > 0 then
                        local dist = (Vector2.new(pos.X,pos.Y) - center).Magnitude
                        if dist < bestScreen then
                            best, bestScreen = plr, dist
                        end
                    end
                end
            end
        end
    end
    return best
end

-- Camera aim fallback. It does not alter MM2 remotes and works as a safe aim-assist mode.
local function updateAim()
    if not State.SilentAim then return end
    local target = getAimTarget()
    if not target then return end

    local root = getRoot(target)
    if root then
        local from = Camera.CFrame.Position
        local to = root.Position
        Camera.CFrame = CFrame.lookAt(from, to)
    end
end

--========================================================
-- Movement
--========================================================

local function applyMovement()
    local h = getHumanoid(LP)
    if h then
        h.WalkSpeed = State.WalkSpeed
        h.UseJumpPower = true
        h.JumpPower = State.JumpPower
    end
end

connect(RunService.Stepped, function()
    if State.Noclip then
        local c = LP.Character
        if c then
            for _, v in ipairs(c:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end
    end
end)

local flyVelocity
local flyGyro

local function setFly(on)
    State.Fly = on
    if not on then
        if flyVelocity then flyVelocity:Destroy() flyVelocity = nil end
        if flyGyro then flyGyro:Destroy() flyGyro = nil end
        return
    end

    local root = getRoot(LP)
    if not root then return end

    flyVelocity = Instance.new("BodyVelocity")
    flyVelocity.MaxForce = Vector3.new(1e6,1e6,1e6)
    flyVelocity.Velocity = Vector3.zero
    flyVelocity.Parent = root

    flyGyro = Instance.new("BodyGyro")
    flyGyro.MaxTorque = Vector3.new(1e6,1e6,1e6)
    flyGyro.P = 9000
    flyGyro.CFrame = root.CFrame
    flyGyro.Parent = root
end

connect(RunService.RenderStepped, function()
    applyMovement()
    updateAim()

    if State.Fly and flyVelocity and flyGyro then
        local dir = Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W) then dir += Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= Camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then dir += Camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.yAxis end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.yAxis end

        flyVelocity.Velocity = dir.Magnitude > 0
            and dir.Unit * State.FlySpeed
            or Vector3.zero
        flyGyro.CFrame = Camera.CFrame
    end
end)

--========================================================
-- Teleports
--========================================================

local function tpTo(plr)
    local a, b = getRoot(LP), getRoot(plr)
    if a and b then
        a.CFrame = b.CFrame + Vector3.new(0, 3, 0)
        notify("DA-DA", "Teleported to "..plr.DisplayName)
    end
end

local function tpLobby()
    local root = getRoot(LP)
    if not root then return end

    local spawn = workspace:FindFirstChild("Lobby")
        or workspace:FindFirstChild("lobby")
        or workspace:FindFirstChild("SpawnLocation", true)

    if spawn and spawn:IsA("BasePart") then
        root.CFrame = spawn.CFrame + Vector3.new(0,4,0)
    else
        notify("DA-DA", "Lobby spawn not found")
    end
end

local function tpRandom()
    local root = getRoot(LP)
    if not root then return end
    local points = {}

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("SpawnLocation") then
            table.insert(points, obj)
        end
    end

    if #points > 0 then
        root.CFrame = points[math.random(1,#points)].CFrame + Vector3.new(0,4,0)
    end
end

--========================================================
-- Fling
--========================================================

local function fling(plr)
    local myRoot, targetRoot = getRoot(LP), getRoot(plr)
    if not myRoot or not targetRoot then return end

    local old = myRoot.CFrame
    for i = 1, 8 do
        myRoot.CFrame = targetRoot.CFrame * CFrame.new(
            math.random(-2,2), 0, math.random(-2,2)
        )
        myRoot.AssemblyLinearVelocity = Vector3.new(0, 250, 0)
        RunService.Heartbeat:Wait()
    end
    myRoot.CFrame = old
    myRoot.AssemblyLinearVelocity = Vector3.zero
end

--========================================================
-- Visuals
--========================================================

local function setFullBright(on)
    State.FullBright = on
    if on then
        State.OriginalLighting.Brightness = Lighting.Brightness
        State.OriginalLighting.ClockTime = Lighting.ClockTime
        State.OriginalLighting.FogEnd = Lighting.FogEnd
        Lighting.Brightness = 3
        Lighting.ClockTime = 14
        Lighting.FogEnd = 1e6
    else
        if State.OriginalLighting.Brightness then
            Lighting.Brightness = State.OriginalLighting.Brightness
        end
        if State.OriginalLighting.ClockTime then
            Lighting.ClockTime = State.OriginalLighting.ClockTime
        end
        if State.OriginalLighting.FogEnd then
            Lighting.FogEnd = State.OriginalLighting.FogEnd
        end
    end
end

local function setNoFog(on)
    State.NoFog = on
    Lighting.FogEnd = on and 1e6 or (State.OriginalLighting.FogEnd or 100000)
end

local function clearSky()
    for _, v in ipairs(Lighting:GetChildren()) do
        if v:IsA("Sky") and v.Name == "DADA_Sky" then
            v:Destroy()
        end
    end
end

local function createSky(texture)
    clearSky()
    local sky = Instance.new("Sky")
    sky.Name = "DADA_Sky"
    sky.SkyboxBk = texture
    sky.SkyboxDn = texture
    sky.SkyboxFt = texture
    sky.SkyboxLf = texture
    sky.SkyboxRt = texture
    sky.SkyboxUp = texture
    sky.Parent = Lighting
end

--========================================================
-- Anti AFK
--========================================================

pcall(function()
    local vu = game:GetService("VirtualUser")
    connect(LP.Idled, function()
        if State.AntiAFK then
            vu:Button2Down(Vector2.new(0,0), Camera.CFrame)
            task.wait(0.1)
            vu:Button2Up(Vector2.new(0,0), Camera.CFrame)
        end
    end)
end)

--========================================================
-- Custom UI
--========================================================

local old = game:GetService("CoreGui"):FindFirstChild("DADA_REBUILD")
if old then old:Destroy() end

local Gui = Instance.new("ScreenGui")
Gui.Name = "DADA_REBUILD"
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = game:GetService("CoreGui")

local OpenButton = Instance.new("TextButton")
OpenButton.Name = "OpenButton"
OpenButton.Size = UDim2.fromOffset(62,62)
OpenButton.Position = UDim2.new(0,18,0.5,-31)
OpenButton.BackgroundColor3 = Color3.fromRGB(25,20,34)
OpenButton.Text = "D"
OpenButton.TextColor3 = Color3.fromRGB(255,255,255)
OpenButton.TextSize = 30
OpenButton.Font = Enum.Font.GothamBlack
OpenButton.Parent = Gui

Instance.new("UICorner", OpenButton).CornerRadius = UDim.new(1,0)

local Stroke = Instance.new("UIStroke", OpenButton)
Stroke.Thickness = 2
Stroke.Color = Color3.fromRGB(175,80,255)

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(650,430)
Main.Position = UDim2.new(0.5,-325,0.5,-215)
Main.BackgroundColor3 = Color3.fromRGB(13,12,18)
Main.BorderSizePixel = 0
Main.Parent = Gui

Instance.new("UICorner", Main).CornerRadius = UDim.new(0,18)

local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Color3.fromRGB(92,55,125)
MainStroke.Thickness = 1.5

local Top = Instance.new("Frame")
Top.Size = UDim2.new(1,0,0,68)
Top.BackgroundColor3 = Color3.fromRGB(19,17,27)
Top.BorderSizePixel = 0
Top.Parent = Main

local Title = Instance.new("TextLabel")
Title.BackgroundTransparency = 1
Title.Position = UDim2.fromOffset(22,8)
Title.Size = UDim2.new(1,-100,0,30)
Title.Text = "DA-DA  MM2"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 22
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Top

local Sub = Instance.new("TextLabel")
Sub.BackgroundTransparency = 1
Sub.Position = UDim2.fromOffset(23,38)
Sub.Size = UDim2.new(1,-100,0,20)
Sub.Text = "REBUILD • MOBILE UI"
Sub.TextColor3 = Color3.fromRGB(157,137,180)
Sub.Font = Enum.Font.GothamMedium
Sub.TextSize = 11
Sub.TextXAlignment = Enum.TextXAlignment.Left
Sub.Parent = Top

local Close = Instance.new("TextButton")
Close.Size = UDim2.fromOffset(42,42)
Close.Position = UDim2.new(1,-53,0,13)
Close.BackgroundColor3 = Color3.fromRGB(35,28,43)
Close.Text = "×"
Close.TextColor3 = Color3.fromRGB(255,255,255)
Close.TextSize = 25
Close.Font = Enum.Font.GothamBold
Close.Parent = Top
Instance.new("UICorner",Close).CornerRadius = UDim.new(0,12)

local Nav = Instance.new("Frame")
Nav.Size = UDim2.new(0,150,1,-82)
Nav.Position = UDim2.fromOffset(12,74)
Nav.BackgroundColor3 = Color3.fromRGB(17,15,23)
Nav.BorderSizePixel = 0
Nav.Parent = Main
Instance.new("UICorner",Nav).CornerRadius = UDim.new(0,14)

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1,-174,1,-82)
Content.Position = UDim2.fromOffset(162,74)
Content.BackgroundTransparency = 1
Content.Parent = Main

local function makeScroll(parent)
    local s = Instance.new("ScrollingFrame")
    s.Size = UDim2.fromScale(1,1)
    s.BackgroundTransparency = 1
    s.BorderSizePixel = 0
    s.ScrollBarThickness = 3
    s.CanvasSize = UDim2.new()
    s.AutomaticCanvasSize = Enum.AutomaticSize.Y
    s.Parent = parent
    local pad = Instance.new("UIPadding",s)
    pad.PaddingTop = UDim.new(0,4)
    pad.PaddingBottom = UDim.new(0,8)
    pad.PaddingLeft = UDim.new(0,4)
    pad.PaddingRight = UDim.new(0,8)
    local list = Instance.new("UIListLayout",s)
    list.Padding = UDim.new(0,8)
    return s
end

local Pages = {}
local NavButtons = {}
local currentPage

local function createPage(name)
    local p = Instance.new("Frame")
    p.Name = name
    p.Size = UDim2.fromScale(1,1)
    p.BackgroundTransparency = 1
    p.Visible = false
    p.Parent = Content
    Pages[name] = makeScroll(p)
    return Pages[name]
end

local function addNav(name, icon)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,-12,0,44)
    b.BackgroundColor3 = Color3.fromRGB(25,21,33)
    b.Text = icon.."  "..name
    b.TextColor3 = Color3.fromRGB(190,181,201)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    b.Parent = Nav
    Instance.new("UICorner",b).CornerRadius = UDim.new(0,10)
    NavButtons[name] = b

    b.MouseButton1Click:Connect(function()
        for n,btn in pairs(NavButtons) do
            btn.BackgroundColor3 = Color3.fromRGB(25,21,33)
            btn.TextColor3 = Color3.fromRGB(190,181,201)
        end
        b.BackgroundColor3 = Color3.fromRGB(85,44,115)
        b.TextColor3 = Color3.new(1,1,1)
        for n,p in pairs(Pages) do
            p.Parent.Visible = (n == name)
        end
        currentPage = name
    end)
end

local Combat = createPage("Combat")
local Visuals = createPage("Visuals")
local Player = createPage("Player")
local Teleport = createPage("Teleport")
local Fun = createPage("Fun")
local Settings = createPage("Settings")

addNav("Combat","◈")
addNav("Visuals","◉")
addNav("Player","◆")
addNav("Teleport","⌖")
addNav("Fun","★")
addNav("Settings","⚙")

local function section(parent, title)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1,-4,0,28)
    l.BackgroundTransparency = 1
    l.Text = title:upper()
    l.TextColor3 = Color3.fromRGB(170,130,205)
    l.Font = Enum.Font.GothamBlack
    l.TextSize = 11
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = parent
end

local function toggle(parent, text, default, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,-4,0,48)
    b.BackgroundColor3 = Color3.fromRGB(22,19,29)
    b.Text = ""
    b.Parent = parent
    Instance.new("UICorner",b).CornerRadius = UDim.new(0,12)

    local t = Instance.new("TextLabel")
    t.BackgroundTransparency = 1
    t.Position = UDim2.fromOffset(14,0)
    t.Size = UDim2.new(1,-80,1,0)
    t.Text = text
    t.TextColor3 = Color3.new(1,1,1)
    t.Font = Enum.Font.GothamMedium
    t.TextSize = 13
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.Parent = b

    local dot = Instance.new("Frame")
    dot.Size = UDim2.fromOffset(34,20)
    dot.Position = UDim2.new(1,-48,0.5,-10)
    dot.BackgroundColor3 = Color3.fromRGB(52,47,60)
    dot.Parent = b
    Instance.new("UICorner",dot).CornerRadius = UDim.new(1,0)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(16,16)
    knob.Position = UDim2.fromOffset(2,2)
    knob.BackgroundColor3 = Color3.fromRGB(220,215,225)
    knob.Parent = dot
    Instance.new("UICorner",knob).CornerRadius = UDim.new(1,0)

    local value = default == true

    local function render()
        dot.BackgroundColor3 = value and Color3.fromRGB(142,65,190) or Color3.fromRGB(52,47,60)
        knob.Position = value and UDim2.fromOffset(16,2) or UDim2.fromOffset(2,2)
    end

    b.MouseButton1Click:Connect(function()
        value = not value
        render()
        callback(value)
    end)

    render()
    return b
end

local function button(parent, text, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,-4,0,46)
    b.BackgroundColor3 = Color3.fromRGB(28,23,35)
    b.Text = text
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    b.Parent = parent
    Instance.new("UICorner",b).CornerRadius = UDim.new(0,11)
    b.MouseButton1Click:Connect(callback)
    return b
end

local function input(parent, text, value, callback)
    local b = Instance.new("Frame")
    b.Size = UDim2.new(1,-4,0,48)
    b.BackgroundColor3 = Color3.fromRGB(22,19,29)
    b.Parent = parent
    Instance.new("UICorner",b).CornerRadius = UDim.new(0,12)

    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Position = UDim2.fromOffset(13,0)
    l.Size = UDim2.new(0.55,0,1,0)
    l.Text = text
    l.TextColor3 = Color3.new(1,1,1)
    l.Font = Enum.Font.GothamMedium
    l.TextSize = 13
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = b

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0,100,0,32)
    box.Position = UDim2.new(1,-112,0.5,-16)
    box.BackgroundColor3 = Color3.fromRGB(35,30,43)
    box.Text = tostring(value)
    box.TextColor3 = Color3.new(1,1,1)
    box.Font = Enum.Font.GothamBold
    box.TextSize = 13
    box.ClearTextOnFocus = false
    box.Parent = b
    Instance.new("UICorner",box).CornerRadius = UDim.new(0,8)

    box.FocusLost:Connect(function()
        callback(box.Text)
    end)
    return b
end

--========================================================
-- Pages
--========================================================

section(Combat,"Aim")
toggle(Combat,"Silent Aim / Aim Assist",false,function(v)
    State.SilentAim = v
end)
toggle(Combat,"Auto Shoot",false,function(v)
    State.AutoShoot = v
    notify("DA-DA","Auto Shoot "..(v and "enabled" or "disabled"))
end)
toggle(Combat,"Role Check",false,function(v)
    State.TeamCheck = v
end)
input(Combat,"FOV",180,function(v)
    State.AimFOV = math.clamp(tonumber(v) or 180,20,1000)
end)
button(Combat,"Target Murderer",function()
    local p = findMurderer()
    if p then
        State.SelectedPlayer = p
        notify("DA-DA",p.DisplayName.." • Murderer")
    else
        notify("DA-DA","Murderer not found")
    end
end)
button(Combat,"Target Sheriff",function()
    local p = findSheriff()
    if p then
        State.SelectedPlayer = p
        notify("DA-DA",p.DisplayName.." • Sheriff")
    else
        notify("DA-DA","Sheriff not found")
    end
end)
button(Combat,"Select Nearest",function()
    local p = findNearest()
    State.SelectedPlayer = p
    if p then notify("DA-DA","Target: "..p.DisplayName) end
end)

section(Visuals,"ESP / HUD")
toggle(Visuals,"Player ESP",false,function(v)
    State.ESP = v
    refreshESP()
end)
toggle(Visuals,"Role Colors",true,function(v)
    State.RoleESP = v
    refreshESP()
end)
toggle(Visuals,"Target HUD",false,function(v)
    State.TargetHUD = v
end)
toggle(Visuals,"Full Bright",false,function(v)
    setFullBright(v)
end)
toggle(Visuals,"No Fog",false,function(v)
    setNoFog(v)
end)
button(Visuals,"Clear Sky",function()
    clearSky()
end)
button(Visuals,"Purple Space Sky",function()
    createSky("rbxassetid://159454299")
end)

section(Player,"Movement")
input(Player,"Walkspeed",16,function(v)
    State.WalkSpeed = math.clamp(tonumber(v) or 16,0,250)
    applyMovement()
end)
input(Player,"JumpPower",50,function(v)
    State.JumpPower = math.clamp(tonumber(v) or 50,0,250)
    applyMovement()
end)
toggle(Player,"Noclip",false,function(v)
    State.Noclip = v
end)
toggle(Player,"Fly",false,function(v)
    setFly(v)
end)
input(Player,"Fly Speed",60,function(v)
    State.FlySpeed = math.clamp(tonumber(v) or 60,10,300)
end)
toggle(Player,"Anti AFK",true,function(v)
    State.AntiAFK = v
end)

section(Teleport,"Quick Teleport")
button(Teleport,"Teleport → Murderer",function()
    local p = findMurderer()
    if p then tpTo(p) else notify("DA-DA","Murderer not found") end
end)
button(Teleport,"Teleport → Sheriff",function()
    local p = findSheriff()
    if p then tpTo(p) else notify("DA-DA","Sheriff not found") end
end)
button(Teleport,"Teleport → Lobby",tpLobby)
button(Teleport,"Teleport → Random Spawn",tpRandom)
button(Teleport,"Teleport → Selected",function()
    if State.SelectedPlayer then tpTo(State.SelectedPlayer) end
end)

section(Fun,"Actions")
button(Fun,"Fling Selected",function()
    if State.SelectedPlayer then
        fling(State.SelectedPlayer)
    else
        notify("DA-DA","Select a player first")
    end
end)
button(Fun,"Fling Murderer",function()
    local p = findMurderer()
    if p then fling(p) end
end)
button(Fun,"Fling Sheriff",function()
    local p = findSheriff()
    if p then fling(p) end
end)
button(Fun,"Refresh ESP",refreshESP)
button(Fun,"Rejoin Server",function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId,game.JobId,LP)
end)

section(Settings,"Menu")
toggle(Settings,"Open on Start",true,function(v)
    State.Open = v
end)
button(Settings,"Destroy UI",function()
    Gui:Destroy()
end)
button(Settings,"Reset Character",function()
    local h = getHumanoid(LP)
    if h then h.Health = 0 end
end)

--========================================================
-- UI behaviour
--========================================================

local dragging, dragStart, startPos

connect(Top.InputBegan,function(inputObj)
    if inputObj.UserInputType == Enum.UserInputType.MouseButton1
        or inputObj.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = inputObj.Position
        startPos = Main.Position
    end
end)

connect(UIS.InputChanged,function(inputObj)
    if dragging and (inputObj.UserInputType == Enum.UserInputType.MouseMovement
        or inputObj.UserInputType == Enum.UserInputType.Touch) then
        local delta = inputObj.Position - dragStart
        Main.Position = UDim2.new(
            startPos.X.Scale,startPos.X.Offset + delta.X,
            startPos.Y.Scale,startPos.Y.Offset + delta.Y
        )
    end
end)

connect(UIS.InputEnded,function(inputObj)
    if inputObj.UserInputType == Enum.UserInputType.MouseButton1
        or inputObj.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

OpenButton.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

Close.MouseButton1Click:Connect(function()
    Main.Visible = false
end)

connect(Players.PlayerAdded,function(plr)
    task.wait(1)
    if State.ESP then makeESP(plr) end
end)

connect(Players.PlayerRemoving,function(plr)
    removeESP(plr)
end)

-- Default page
NavButtons["Combat"].BackgroundColor3 = Color3.fromRGB(85,44,115)
NavButtons["Combat"].TextColor3 = Color3.new(1,1,1)
Pages["Combat"].Parent.Visible = true
currentPage = "Combat"

-- Refresh role ESP periodically, as MM2 roles change during rounds.
task.spawn(function()
    while Gui.Parent do
        if State.ESP then
            refreshESP()
        end
        task.wait(2)
    end
end)

notify("DA-DA MM2","Rebuild UI loaded")
