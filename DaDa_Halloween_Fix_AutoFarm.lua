-- ================================================================
--  DaDa v16.4 — FULL (Dashboard removed)
--  Kity UI + Silent Aim + Force Shoot + Invisible
--  + Auto Map Vote + Animations + Emotes + Double Jump
-- ================================================================

local CoreGui, Players, RunService, UIS, TweenService, ReplicatedStorage
local Stats, CollectionService, Lighting, HttpService, LP
local Themes, currentTheme, themeUpdaters
local ACCENT, ACCENT2, BG_MAIN, BG_SIDE, BG_PANEL, BG_HEADER, BG_ROW, BG_SLIDER
local BG_ON, BG_OFF, TEXT_MAIN, TEXT_DIM, STROKE
local WIN_TRANS, SIDE_TRANS, PANEL_TRANS, HEADER_TRANS, ROW_TRANS
local ST, farm_cfg, esp_cache, af_cache, nc_cache
local SL, SHF
local applyTheme, notify
local get_round, get_roles, my_role, holds, lp_has_gun, get_hrp, has_knife
local ping_sec
local resolve_shot, install_hooks
local getgun_step, make_esp, remove_esp, clear_highlights, update_highlights, esp_step
local farm_hrp, farm_release, can_farm, coin_bags_full, farm_step
local antifling_step, do_fling, fling_loop, killaura_step
local main_conn, gui, win, quick_gui, hubGui, notifGui, fovGui
local target_player, target_char, target_part, target_hum
local SL_refresh, SL_alive, SL_origin, SL_installHooks, makePanel
-- ============================================================
-- INIT 0: LOADING SCREEN
-- ============================================================
local loadGui = Instance.new("ScreenGui")
loadGui.Name = "DaDaLoad_"..math.random(1000,9999)
loadGui.ResetOnSpawn = false
loadGui.IgnoreGuiInset = true
loadGui.DisplayOrder = 9999
pcall(function() loadGui.Parent = game:GetService("CoreGui") end)
if not loadGui.Parent then loadGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui") end

local bg = Instance.new("Frame")
bg.Size = UDim2.new(1,0,1,0)
bg.BackgroundColor3 = Color3.fromRGB(0,0,0)
bg.BackgroundTransparency = 1
bg.BorderSizePixel = 0
bg.ZIndex = 1
bg.Parent = loadGui

local center = Instance.new("Frame")
center.Size = UDim2.new(0,320,0,180)
center.Position = UDim2.new(0.5,-160,0.5,-90)
center.BackgroundTransparency = 1
center.ZIndex = 2
center.Parent = loadGui

local logo = Instance.new("TextLabel")
logo.Size = UDim2.new(1,0,0,60)
logo.Position = UDim2.new(0,0,0,10)
logo.BackgroundTransparency = 1
logo.Text = "DaDa"
logo.TextColor3 = Color3.fromRGB(200,120,255)
logo.TextSize = 64
logo.Font = Enum.Font.GothamBlack
logo.TextTransparency = 1
logo.TextStrokeTransparency = 1
logo.TextStrokeColor3 = Color3.fromRGB(140,60,200)
logo.ZIndex = 3
logo.Parent = center

local logoGlow = Instance.new("TextLabel")
logoGlow.Size = UDim2.new(1,0,0,60)
logoGlow.Position = UDim2.new(0,0,0,10)
logoGlow.BackgroundTransparency = 1
logoGlow.Text = "DaDa"
logoGlow.TextColor3 = Color3.fromRGB(180,80,255)
logoGlow.TextSize = 66
logoGlow.Font = Enum.Font.GothamBlack
logoGlow.TextTransparency = 1
logoGlow.ZIndex = 2
logoGlow.Parent = center

local sub = Instance.new("TextLabel")
sub.Size = UDim2.new(1,0,0,20)
sub.Position = UDim2.new(0,0,0,72)
sub.BackgroundTransparency = 1
sub.Text = "v16.4  •  загрузка"
sub.TextColor3 = Color3.fromRGB(150,150,160)
sub.TextSize = 14
sub.Font = Enum.Font.GothamMedium
sub.TextTransparency = 1
sub.ZIndex = 3
sub.Parent = center

local barBg = Instance.new("Frame")
barBg.Size = UDim2.new(1,-40,0,6)
barBg.Position = UDim2.new(0,20,0,120)
barBg.BackgroundColor3 = Color3.fromRGB(40,40,50)
barBg.BorderSizePixel = 0
barBg.BackgroundTransparency = 1
barBg.ZIndex = 3
barBg.Parent = center
Instance.new("UICorner", barBg).CornerRadius = UDim.new(1,0)

local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0,0,1,0)
barFill.BackgroundColor3 = Color3.fromRGB(200,120,255)
barFill.BorderSizePixel = 0
barFill.ZIndex = 4
barFill.Parent = barBg
Instance.new("UICorner", barFill).CornerRadius = UDim.new(1,0)

local barGlow = Instance.new("Frame")
barGlow.Size = UDim2.new(0,0,1,0)
barGlow.BackgroundColor3 = Color3.fromRGB(255,200,255)
barGlow.BackgroundTransparency = 0.5
barGlow.BorderSizePixel = 0
barGlow.ZIndex = 5
barGlow.Parent = barBg
Instance.new("UICorner", barGlow).CornerRadius = UDim.new(1,0)

local pct = Instance.new("TextLabel")
pct.Size = UDim2.new(1,0,0,16)
pct.Position = UDim2.new(0,0,0,132)
pct.BackgroundTransparency = 1
pct.Text = "0%"
pct.TextColor3 = Color3.fromRGB(180,180,200)
pct.TextSize = 12
pct.Font = Enum.Font.GothamBold
pct.TextTransparency = 1
pct.ZIndex = 3
pct.Parent = center

local TweenService = game:GetService("TweenService")

TweenService:Create(bg, TweenInfo.new(0.4), { BackgroundTransparency = 0.15 }):Play()

task.wait(0.2)
TweenService:Create(logo, TweenInfo.new(0.4, Enum.EasingStyle.Back), { TextTransparency = 0 }):Play()
TweenService:Create(logo, TweenInfo.new(0.4), { TextStrokeTransparency = 0.6 }):Play()
TweenService:Create(logoGlow, TweenInfo.new(0.6), { TextTransparency = 0.8 }):Play()
task.wait(0.2)
TweenService:Create(sub, TweenInfo.new(0.3), { TextTransparency = 0 }):Play()
TweenService:Create(barBg, TweenInfo.new(0.3), { BackgroundTransparency = 0 }):Play()
TweenService:Create(pct, TweenInfo.new(0.3), { TextTransparency = 0 }):Play()

local DURATION = 3
local start_t = tick()

task.spawn(function()
    while true do
        local elapsed = tick() - start_t
        local progress = math.clamp(elapsed / DURATION, 0, 1)
        local eased = progress
        if progress > 0.5 then
            eased = 1 - (1 - progress)^2 * 0.5
        end
        barFill.Size = UDim2.new(eased, 0, 1, 0)
        barGlow.Size = UDim2.new(math.min(eased + 0.05, 1), 0, 1, 0)
        pct.Text = math.floor(progress * 100) .. "%"
        if progress >= 1 then break end
        task.wait()
    end
    task.wait(0.3)
    TweenService:Create(logo, TweenInfo.new(0.4), { TextTransparency = 1 }):Play()
    TweenService:Create(logoGlow, TweenInfo.new(0.4), { TextTransparency = 1 }):Play()
    TweenService:Create(sub, TweenInfo.new(0.4), { TextTransparency = 1 }):Play()
    TweenService:Create(barBg, TweenInfo.new(0.4), { BackgroundTransparency = 1 }):Play()
    TweenService:Create(barFill, TweenInfo.new(0.4), { BackgroundTransparency = 1 }):Play()
    TweenService:Create(barGlow, TweenInfo.new(0.4), { BackgroundTransparency = 1 }):Play()
    TweenService:Create(pct, TweenInfo.new(0.4), { TextTransparency = 1 }):Play()
    TweenService:Create(bg, TweenInfo.new(0.5), { BackgroundTransparency = 1 }):Play()
    task.wait(0.6)
    loadGui:Destroy()
end)

-- ============================================================
-- INIT 1: SERVICES + THEMES
-- ============================================================
local function initServices()
    CoreGui          = game:GetService("CoreGui")
    Players          = game:GetService("Players")
    RunService       = game:GetService("RunService")
    UIS              = game:GetService("UserInputService")
    TweenService     = game:GetService("TweenService")
    ReplicatedStorage= game:GetService("ReplicatedStorage")
    Stats            = game:GetService("Stats")
    CollectionService= game:GetService("CollectionService")
    Lighting         = game:GetService("Lighting")
    HttpService      = game:GetService("HttpService")
    LP               = Players.LocalPlayer
    Themes = {
        Default={Background=Color3.fromRGB(10,9,8),Inline=Color3.fromRGB(15,13,11),Text=Color3.fromRGB(245,242,238),Element=Color3.fromRGB(15,13,11),Accent=Color3.fromRGB(224,116,24),LightAccent=Color3.fromRGB(255,170,54),Border=Color3.fromRGB(50,34,23)},
        White={Background=Color3.fromRGB(18,18,20),Inline=Color3.fromRGB(28,28,31),Text=Color3.fromRGB(248,248,250),Element=Color3.fromRGB(35,35,39),Accent=Color3.fromRGB(235,235,240),LightAccent=Color3.fromRGB(255,255,255),Border=Color3.fromRGB(105,105,115)},
        Blue={Background=Color3.fromRGB(7,14,25),Inline=Color3.fromRGB(11,24,42),Text=Color3.fromRGB(232,244,255),Element=Color3.fromRGB(14,32,55),Accent=Color3.fromRGB(43,153,255),LightAccent=Color3.fromRGB(118,202,255),Border=Color3.fromRGB(25,77,125)},
        Pink={Background=Color3.fromRGB(25,10,20),Inline=Color3.fromRGB(42,16,34),Text=Color3.fromRGB(255,239,248),Element=Color3.fromRGB(54,20,44),Accent=Color3.fromRGB(244,78,164),LightAccent=Color3.fromRGB(255,145,204),Border=Color3.fromRGB(119,35,83)},
        Purple={Background=Color3.fromRGB(15,10,28),Inline=Color3.fromRGB(27,17,49),Text=Color3.fromRGB(242,235,255),Element=Color3.fromRGB(37,23,65),Accent=Color3.fromRGB(154,91,255),LightAccent=Color3.fromRGB(202,157,255),Border=Color3.fromRGB(78,42,135)},
        Green={Background=Color3.fromRGB(8,20,16),Inline=Color3.fromRGB(13,35,27),Text=Color3.fromRGB(232,255,242),Element=Color3.fromRGB(17,47,36),Accent=Color3.fromRGB(38,199,126),LightAccent=Color3.fromRGB(113,239,175),Border=Color3.fromRGB(24,102,70)},
    }
    Themes.Halloween={Background=Color3.fromRGB(15,8,20),Inline=Color3.fromRGB(28,13,35),Text=Color3.fromRGB(255,238,247),Element=Color3.fromRGB(42,18,48),Accent=Color3.fromRGB(255,111,25),LightAccent=Color3.fromRGB(255,164,54),Border=Color3.fromRGB(111,49,132)}
    currentTheme = Themes.Halloween
    ACCENT=currentTheme.Accent; ACCENT2=currentTheme.LightAccent
    BG_MAIN=currentTheme.Background; BG_SIDE=currentTheme.Inline
    BG_PANEL=currentTheme.Inline; BG_HEADER=currentTheme.Element
    BG_ROW=currentTheme.Element; BG_SLIDER=currentTheme.Border
    BG_ON=currentTheme.Accent; BG_OFF=currentTheme.Border
    TEXT_MAIN=currentTheme.Text; TEXT_DIM=currentTheme.Text
    STROKE=currentTheme.Border
    WIN_TRANS=0.18; SIDE_TRANS=0.15; PANEL_TRANS=0.22
    HEADER_TRANS=0.18; ROW_TRANS=0.25
    themeUpdaters={}
    applyTheme = function(name)
        local t=Themes[name]; if not t then return end
        currentTheme=t
        ACCENT=t.Accent; ACCENT2=t.LightAccent
        BG_MAIN=t.Background; BG_SIDE=t.Inline; BG_PANEL=t.Inline
        BG_HEADER=t.Element; BG_ROW=t.Element; BG_SLIDER=t.Border
        BG_ON=t.Accent; BG_OFF=t.Border; TEXT_MAIN=t.Text; TEXT_DIM=t.Text; STROKE=t.Border
        for _,fn in ipairs(themeUpdaters) do pcall(fn,t) end
    end
end
initServices()

-- ============================================================
-- INIT 2: STATE
-- ============================================================
local function initState()
    ST={
        triggerbot=false, hit_part="UpperTorso",
        getgun=false, getgun_mode="Touch", getgun_interval=0.15, getgun_tp_back=true,
        auto_knife_throw=false, knife_predict=true, knife_lead=100, antifling=false,
        esp_on=false, esp_box=true, esp_box_col=Color3.fromRGB(160,150,200),
        esp_name=true, esp_name_col=Color3.fromRGB(180,180,220),
        esp_dist=true, esp_dist_col=Color3.fromRGB(210,210,225),
        esp_health=true, esp_skel=false, esp_skel_col=Color3.fromRGB(210,210,225),
        esp_line=false, esp_chams=false, esp_chams_roles=true, esp_max_dist=1000,
        fullbright=false, fov_changer=false, fov_value=90,
        world_color=false, world_color_val=Color3.fromRGB(255,255,255), skybox="Default",
        fly=false, fly_speed=80, noclip=false, inf_jump=false,
        speed_hack=false, speed_val=32, jump_power=false, jump_val=80,
        bhop=false, bhop_power=120, bhop_strafe=true,
        gravity=false, gravity_val=196,
        char_transparency=false, char_trans_val=0.3,
        fling_murder=false, fling_sheriff=false,
        killaura=false, killaura_dist=30, autoknife=false,
        quick=false, quick_corner="Bottom-Right", quick_offset_y=280,
        quick_features={
            {name="Silent",flag="silent"},
            {name="ESP",flag="esp"},
            {name="Bhop",flag="bhop"},
            {name="Fly",flag="fly"},
            {name="InfJump",flag="inf_jump"},
        },
        quick_state={},
        am_sheriff=false, last_shot=0, getgun_last=0, teleporting=false,
    }
    for _,f in ipairs(ST.quick_features) do ST.quick_state[f.flag]=false end

    SHF = {
        tracer=false, tracer_col=Color3.fromRGB(133,220,255), tracer_dur=1,
        sheriff_sound=false, sheriff_sound_name="mc bow", sheriff_sound_vol=1,
        kill_sound=false, kill_sound_name="skeet", kill_sound_vol=1,
        gunshot_sound=false, gunshot_sound_name="mc bow", gunshot_sound_vol=1,
        shaders=false, shader_type="morning",
        fog=false, fog_color=Color3.fromRGB(192,192,192), fog_start=0, fog_end=1000,
        ambient=false, ambient_col=Color3.fromRGB(128,128,128),
        exposure=false, exposure_val=0,
        prem_skybox=false, prem_skybox_name="Jungle",
        world_fx=false, world_fx_type="Snow", world_fx_col=Color3.fromRGB(150,200,255), world_fx_rate=250,
        aura=false, aura_type="angel", aura_col=Color3.fromRGB(133,220,255),
        crosshair=false, crosshair_gap=4, crosshair_len=8, crosshair_thick=2,
        crosshair_line_col=Color3.fromRGB(255,255,255), crosshair_out_col=Color3.fromRGB(0,0,0),
        crosshair_rot=0,
        china_hat=false, china_hat_col=Color3.fromRGB(170,85,255),
        self_chams=false, self_chams_col=Color3.fromRGB(0,200,255),
        tool_chams=false, tool_chams_col=Color3.fromRGB(255,200,0),
        landing_circle=false, landing_circle_col=Color3.fromRGB(255,255,255),
        landing_circle_tr=1, landing_circle_dur=0.82,
        gun_esp=false, gun_esp_text=true, gun_esp_text_col=Color3.fromRGB(255,255,255),
        gun_esp_hl=true, gun_esp_hl_col=Color3.fromRGB(255,255,255),
        aspect=false, aspect_val=100,
        mapvote=false, mapvote_dupe=false, mapvote_cap=3,
        fake_pos=false, fake_pos_range_x=9, fake_pos_range_y=9, fake_pos_range_z=9,
        mov_graph=false, mov_graph_col=Color3.fromRGB(242,242,242),
        invis=false, invis_mode="Ghost",
        hitbox=false, hitbox_size=5, hitbox_transp=true, hitbox_col=Color3.fromRGB(255,0,0),
        no_recoil=false, no_spread=false, auto_reload=false,
        auto_click=false, auto_click_delay=0.1,
        auto_heal=false, auto_heal_threshold=50,
        auto_dodge=false, auto_dodge_range=20,
        anti_swap=false, anti_void=false, anti_kick=false, anti_afk=false, anti_trap=false,
        auto_respawn=false, auto_respawn_delay=3,
        gun_skin="None", knife_skin="None",
        anim_pack="Default",
        round_notify=false, killer_notify=false, role_map={},
    }

    farm_cfg={on=false,mode="Basic",avoid_murder=false,auto_reset=false,speed=23,down_depth=14,avoid_dist=40,rise_safe_dist=20}
    esp_cache={}
    af_cache={}
    nc_cache={}
    target_player, target_char, target_part, target_hum = nil,nil,nil,nil
end
initState()

-- ============================================================
-- INIT 3: ROLES / HELPERS
-- ============================================================
local function initRoles()
    local round_mod=nil
    get_round=function()
        if round_mod then return round_mod end
        local ok,m=pcall(function() return require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("CurrentRoundClient")) end)
        if ok and type(m)=="table" then round_mod=m end
        return round_mod
    end
    get_roles=function()
        local out={}
        local m=get_round(); local d=m and m.PlayerData
        if type(d)=="table" then for name,info in pairs(d) do if type(info)=="table" and not info.Dead then out[name]=info.Role end end end
        for _,p in ipairs(Players:GetPlayers()) do
            local c=p.Character; local bp=p:FindFirstChildOfClass("Backpack")
            local hasGun=(c and c:FindFirstChild("Gun")) or (bp and bp:FindFirstChild("Gun"))
            local hasKnife=(c and c:FindFirstChild("Knife")) or (bp and bp:FindFirstChild("Knife"))
            if hasGun and out[p.Name]~="Murderer" then out[p.Name]="Sheriff" end
            if hasKnife then out[p.Name]="Murderer" end
        end
        return out
    end
    my_role=function()
        local m=get_round(); local d=m and m.PlayerData; local me=d and d[LP.Name]
        return me and me.Role or nil
    end
    holds=function(c,n) return c~=nil and c:FindFirstChild(n)~=nil end
    lp_has_gun=function() return holds(LP.Character,"Gun") or holds(LP:FindFirstChildOfClass("Backpack"),"Gun") end
    get_hrp=function() local c=LP.Character; return c and c:FindFirstChild("HumanoidRootPart") end
    has_knife=function()
        local c=LP.Character
        if c and c:FindFirstChild("Knife") then return true end
        local bp=LP:FindFirstChildOfClass("Backpack")
        if bp and bp:FindFirstChild("Knife") then return true end
        return false
    end
    ping_sec=function()
        local ok,ms=pcall(function() return Stats.Network.ServerStatsItem["Data Ping"]:GetValue() end)
        if ok and type(ms)=="number" and ms>0 and ms<800 then return ms/1000 end
        local ok2,p=pcall(function() return LP:GetNetworkPing() end)
        if ok2 and type(p)=="number" then return p end
        return 0.05
    end
end
initRoles()

-- ============================================================
-- INIT 4: SILENT AIM
-- ============================================================
local function initSilent()
    local lp = LP
    local stats = Stats
    SL = {
        enabled=false, predict=true, force=false,
        auto_on=false, auto_delay=0, am_sheriff=false,
        fire_gap=0, last_shot=0, stand_off=15,
    }
    local MAX_RANGE=300
    local gap_min=0; local gap_seen=false; local gap_gun=nil; local want_since=0
    local function gap_reset() gap_min=0; gap_seen=false; SL.fire_gap=0 end
    local function gap_push(v) if v<=0 then return end if not gap_seen or v<gap_min then gap_min=v; gap_seen=true; SL.fire_gap=v end end
    local round_mod=nil
    SL_getRound=function()
        if round_mod then return round_mod end
        local ok,m=pcall(function() return require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("CurrentRoundClient")) end)
        if ok and type(m)=="table" then round_mod=m end
        return round_mod
    end
    local function sholds(c,n) return c~=nil and c:FindFirstChild(n)~=nil end
    local function shp_has_gun() return sholds(LP.Character,"Gun") or sholds(LP:FindFirstChildOfClass("Backpack"),"Gun") end
    local target_player=nil; local target_char=nil; local target_part=nil; local target_hum=nil
    SL_refresh=function()
        local found=nil
        local m=SL_getRound(); local data=m and m.PlayerData or nil
        if type(data)=="table" then
            local me=data[LP.Name]
            SL.am_sheriff=(me~=nil and (me.Role=="Sheriff" or me.Role=="Hero")) or shp_has_gun()
            for name,d in pairs(data) do
                if type(d)=="table" and d.Role=="Murderer" and not d.Dead then found=Players:FindFirstChild(name); break end
            end
        else SL.am_sheriff=shp_has_gun() end
        if not found then for _,plr in ipairs(Players:GetPlayers()) do if plr~=LP and sholds(plr.Character,"Knife") then found=plr; break end end end
        if found~=target_player then target_player=found; target_char=nil; target_part=nil; target_hum=nil end
        if not found then return end
        local char=found.Character
        if char~=target_char then target_char=char; target_part=nil; target_hum=nil end
        if not char then return end
        if not target_part or not target_part.Parent then target_part=char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") end
        if not target_hum or not target_hum.Parent then target_hum=char:FindFirstChildOfClass("Humanoid") end
    end
    SL_alive=function()
        if not target_part or not target_part.Parent then return false end
        if not target_hum or not target_hum.Parent then return false end
        return target_hum.Health>0
    end
    _G.DaDa_SL_target_alive=SL_alive
    local SL_lastShot=0
    local ray_params=RaycastParams.new()
    ray_params.FilterType=Enum.RaycastFilterType.Exclude
    ray_params.IgnoreWater=false
    local ignore_base={}; local ignore_work={}; local ignore_time=0
    local function refresh_ignore()
        local now=os.clock()
        if #ignore_base>0 and now-ignore_time<0.5 then return end
        ignore_time=now
        table.clear(ignore_base)
        local char=LP.Character
        if char then ignore_base[1]=char end
        local ok,tagged=pcall(function() return CollectionService:GetTagged("WeaponPassthrough") end)
        if ok and type(tagged)=="table" then for k=1,#tagged do ignore_base[#ignore_base+1]=tagged[k] end end
    end
    local function trace(origin,direction)
        refresh_ignore()
        table.clear(ignore_work)
        for k=1,#ignore_base do ignore_work[k]=ignore_base[k] end
        local result=nil
        for _=1,6 do
            ray_params.FilterDescendantsInstances=ignore_work
            result=workspace:Raycast(origin,direction,ray_params)
            if not result then break end
            local inst=result.Instance
            if not inst then break end
            local ok,tr=pcall(function() return inst.Transparency end)
            if not ok or tr~=1 then break end
            ignore_work[#ignore_work+1]=inst
        end
        return result
    end
    local function gun_attachment()
        local char=LP.Character
        local hrp=char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return nil,nil end
        return hrp:FindFirstChild("GunRaycastAttachment"),hrp
    end
    SL_origin=function()
        local att,hrp=gun_attachment()
        if att then return att.WorldCFrame end
        if hrp then return hrp.CFrame end
        return nil
    end
    local function grav()
        local ok,g=pcall(function() return workspace.Gravity end)
        if ok and type(g)=="number" and g>0 then return g end
        return 0
    end
    local P={snap=48,ring=48,hit_r=2.1,pad=2.6,min_span=5,max_span=90,acc_t=0.15,acc_max=280,acc_min=40,speed_floor=26,speed_head=1.3}
    local snap_t=table.create(P.snap,0); local snap_p=table.create(P.snap,Vector3.zero)
    local snap_n=0; local snap_i=0
    local TR={part=nil,pos=nil,time=0,vel=Vector3.zero,gap=0,ready=false,fresh=Vector3.zero,air=false,air_since=0,jumping=false,jump_v=0,fresh_ok=false,turn=0,spoof=0,clr=0,air_edge=0,jump_fresh=false}
    local SK={vt=table.create(P.ring,0),dx=table.create(P.ring,0),dz=table.create(P.ring,0),vn=0,vi=0}
    local EC={ping=0,rtt=0,jitter=0,seen=false,step=0,step_seen=false}
    local function step_push(dt) if dt<=0 or dt>0.5 then return end if EC.step_seen then EC.step=EC.step*0.85+dt*0.15 else EC.step=dt; EC.step_seen=true end end
    local function sample_span() local s=math.max(EC.step,TR.gap) if s<=0 then return 0 end return s end
    local HY={pos={},w={},n=0,weight=0,primary=nil,stamp=0,conf=0}
    local ground_params=RaycastParams.new()
    ground_params.FilterType=Enum.RaycastFilterType.Exclude
    ground_params.IgnoreWater=true
    local ground_filter={}; local axis_pool={}
    local function ground_below(pos,reach)
        table.clear(ground_filter)
        local n=0
        local char=target_char
        if char then n=n+1; ground_filter[n]=char end
        local mine=LP.Character
        if mine then n=n+1; ground_filter[n]=mine end
        ground_params.FilterDescendantsInstances=ground_filter
        local res=workspace:Raycast(pos,Vector3.new(0,-reach,0),ground_params)
        if res then return res.Position.Y end
        return nil
    end
    local function snap_push(now,pos)
        snap_i=snap_i%P.snap+1; snap_t[snap_i]=now; snap_p[snap_i]=pos
        if snap_n<P.snap then snap_n=snap_n+1 end
    end
    local function snap_get(k) local idx=(snap_i-k-1)%P.snap+1 return snap_t[idx],snap_p[idx] end
    local function fit_velocity()
        if snap_n<3 then return nil end
        local newest=snap_get(0); local used=0; local sum_d=0; local win=sample_span()*4
        for k=0,snap_n-1 do local t=snap_get(k) if newest-t>win then break end used=used+1; sum_d=sum_d+t-newest end
        if used<3 then return nil end
        local mean_d=sum_d/used; local num=Vector3.zero; local den=0
        for k=0,used-1 do local t,p=snap_get(k); local d=t-newest-mean_d; num=num+p*d; den=den+d*d end
        if den<1e-8 then return nil end
        return num/den,-mean_d
    end
    local function recent_velocity()
        if snap_n<2 then return nil end
        local newest,head=snap_get(0)
        local fallback,fallback_age=nil,nil
        local target_span=sample_span()*2; local max_span=target_span*2
        for k=1,snap_n-1 do
            local t,p=snap_get(k); local dt=newest-t
            if dt>max_span then break end
            if dt>0 then fallback=(head-p)/dt; fallback_age=dt*0.5
                if dt>=target_span then return fallback,fallback_age end
            end
        end
        return fallback,fallback_age
    end
    local KIN={ok=false,ax=0,az=0,smax=0}
    local function kin_clear() KIN.ok=false; KIN.ax=0; KIN.az=0; KIN.smax=0 end
    local function fit_kin()
        if snap_n<5 then return nil end
        local t0=snap_get(0); local win=math.max(sample_span()*5,0.12); local scale=win
        local n,s1,s2,s3,s4=0,0,0,0,0
        local bx0,bx1,bx2=0,0,0; local bz0,bz1,bz2=0,0,0
        for k=0,snap_n-1 do
            local t,p=snap_get(k); local age=t0-t
            if age>win then break end
            local u=-age/scale; local u2=u*u
            n=n+1; s1=s1+u; s2=s2+u2; s3=s3+u2*u; s4=s4+u2*u2
            bx0=bx0+p.X; bx1=bx1+p.X*u; bx2=bx2+p.X*u2
            bz0=bz0+p.Z; bz1=bz1+p.Z*u; bz2=bz2+p.Z*u2
        end
        if n<5 then return nil end
        local det=n*(s2*s4-s3*s3)-s1*(s1*s4-s3*s2)+s2*(s1*s3-s2*s2)
        if math.abs(det)<1e-9 then return nil end
        local function solve(b0,b1,b2)
            local d1=n*(b1*s4-s3*b2)-b0*(s1*s4-s3*s2)+s2*(s1*b2-b1*s2)
            local d2=n*(s2*b2-b1*s3)-s1*(s1*b2-b1*s2)+b0*(s1*s3-s2*s2)
            return d1/det,d2/det
        end
        local cx1,cx2=solve(bx0,bx1,bx2); local cz1,cz2=solve(bz0,bz1,bz2)
        local vx,vz=cx1/scale,cz1/scale
        local ax,az=2*cx2/(scale*scale),2*cz2/(scale*scale)
        if vx~=vx or vz~=vz or ax~=ax or az~=az then return nil end
        return Vector3.new(vx,0,vz),Vector3.new(ax,0,az)
    end
    local function kin_update()
        local kv,ka=fit_kin()
        if not kv then KIN.ok=false; KIN.ax=0; KIN.az=0; return nil end
        KIN.ok=true
        local sp=math.sqrt(kv.X*kv.X+kv.Z*kv.Z)
        if sp>KIN.smax then KIN.smax=sp else KIN.smax=KIN.smax*0.985+sp*0.015 end
        if ka and not TR.air then
            local am=math.sqrt(ka.X*ka.X+ka.Z*ka.Z); local ax,az=ka.X,ka.Z
            if am>P.acc_max and am>0 then ax=ax*P.acc_max/am; az=az*P.acc_max/am end
            KIN.ax=KIN.ax*0.5+ax*0.5; KIN.az=KIN.az*0.5+az*0.5
        else KIN.ax=KIN.ax*0.5; KIN.az=KIN.az*0.5 end
        return kv
    end
    local function snap_vel(k)
        local t0,p0=snap_get(k); local t1,p1=snap_get(k+1)
        local d=t0-t1; if d<=0 then return nil end
        return (p0-p1)/d,d
    end
    local function vert_accel()
        if snap_n<3 then return nil end
        local v0,d0=snap_vel(0); local v1,d1=snap_vel(1)
        if not v0 or not v1 then return nil end
        local span=(d0+d1)*0.5; if span<=1e-4 then return nil end
        return (v0.Y-v1.Y)/span
    end
    local function air_vy()
        if snap_n<2 then return nil end
        local edge=TR.air_edge; if edge<=0 then return nil end
        local g=grav(); local newest,head=snap_get(0); local want=sample_span()*2; local best=nil
        for k=1,snap_n-1 do
            local t,p=snap_get(k); if t<edge then break end
            local dt=newest-t
            if dt>1e-4 then best=(head.Y-p.Y)/dt-0.5*g*dt if dt>=want then break end end
        end
        return best
    end
    local function body_clearance()
        local part=target_part; local hum=target_hum
        if not part or not hum then return 0 end
        local ok,value=pcall(function() return part.Size.Y*0.5+hum.HipHeight end)
        if ok and type(value)=="number" and value>0 then return value end
        return 0
    end
    local GC={base=0,seen=false}; local JL={v=0,seen=false}
    local function stand_clearance() if GC.seen then return GC.base end return body_clearance() end
    local function engine_vel(part)
        local ok,v=pcall(function() return part.AssemblyLinearVelocity end)
        if not ok or typeof(v)~="Vector3" then ok,v=pcall(function() return part.Velocity end) end
        if not ok or typeof(v)~="Vector3" then return nil end
        if v.Magnitude~=v.Magnitude then return nil end
        return v
    end
    local function vel_trust(pv,ev)
        if not pv or not ev then return 0 end
        local ph=Vector3.new(pv.X,0,pv.Z); local eh=Vector3.new(ev.X,0,ev.Z)
        local pm,em=ph.Magnitude,eh.Magnitude
        if pm<1 and em<1 then return 1 end
        if pm<1 or em<1 then return 0 end
        local ratio=em/pm; if ratio>1.5 or ratio<0.6 then return 0 end
        local align=ph.Unit:Dot(eh.Unit); if align<0.7 then return 0 end
        local a=math.clamp((align-0.7)/0.25,0,1)
        local r=1-math.clamp(math.abs(ratio-1)/0.4,0,1)
        return a*r
    end
    local function phase_velocity(v,age,air)
        if not v then return nil end
        local y=0
        if air then y=v.Y-grav()*math.clamp(age or 0,0,sample_span()*4) end
        return Vector3.new(v.X,y,v.Z)
    end
    local function merge_vel(fit,fit_age,fast,fast_age,engine,engine_age,air)
        local stable=phase_velocity(fit,fit_age,air)
        local instant=phase_velocity(fast,fast_age,air)
        local turn=0
        if stable and instant then
            local sh=Vector3.new(stable.X,0,stable.Z); local ih=Vector3.new(instant.X,0,instant.Z)
            if sh.Magnitude>1 and ih.Magnitude>1 then
                turn=math.acos(math.clamp(sh.Unit:Dot(ih.Unit),-1,1))/math.pi
            end
        end
        local base=instant or stable
        if not base then return Vector3.zero,0,nil,0 end
        if stable and instant then
            local agility=math.clamp(turn*2.2,0,1)
            base=stable:Lerp(instant,0.4+0.6*agility)
        end
        local trust=0
        if engine then
            local live=phase_velocity(engine,engine_age,air)
            trust=vel_trust(base,live)
            if trust>0 and air then
                base=Vector3.new(base.X,base.Y,base.Z):Lerp(Vector3.new(base.X,live.Y,base.Z),trust*0.35)
            end
        end
        return base,turn,instant or stable,trust
    end
    local function vel_push(now,hx,hz)
        SK.vi=SK.vi%P.ring+1; SK.vt[SK.vi]=now; SK.dx[SK.vi]=hx; SK.dz[SK.vi]=hz
        if SK.vn<P.ring then SK.vn=SK.vn+1 end
    end
    local function track_clear()
        TR.part=nil; TR.pos=nil; TR.vel=Vector3.zero; TR.gap=0
        TR.ready=false; TR.fresh=Vector3.zero; TR.air=false
        TR.jumping=false; TR.jump_v=0; TR.fresh_ok=false
        TR.turn=0; TR.spoof=0; TR.clr=0; TR.air_edge=0; TR.jump_fresh=false
        GC.base=0; GC.seen=false; JL.v=0; JL.seen=false
        snap_n,snap_i=0,0; SK.vn,SK.vi=0,0; kin_clear()
    end
    local function track_seed(part,pos,now)
        TR.part=part; TR.pos=pos; TR.time=now
        TR.vel=Vector3.zero; TR.fresh=Vector3.zero; TR.fresh_ok=false
        TR.turn=0; TR.jump_v=0; TR.gap=0; TR.ready=false
        TR.spoof=0; TR.air_edge=0; TR.jump_fresh=false
        GC.base=0; GC.seen=false; snap_n,snap_i=0,0; kin_clear()
        snap_push(now,pos)
    end
    local function track_fresh(now)
        local part=target_part
        if not part or not part.Parent then TR.fresh_ok=false; return end
        local pos=part.Position
        local g=grav()
        local sv=snap_vel(0)
        local vy=sv and sv.Y or 0
        local accel=vert_accel()
        local falling=accel~=nil and accel<-g*0.5
        local guess=stand_clearance()
        local reach=guess+6+math.abs(vy)*sample_span()*4
        local air
        local gy=ground_below(pos,reach)
        if gy then
            local clr=pos.Y-gy; TR.clr=clr
            if math.abs(vy)<1 and not falling then
                if GC.seen then
                    if clr<GC.base then GC.base=GC.base*0.7+clr*0.3
                    else GC.base=GC.base*0.98+clr*0.02 end
                else GC.base=clr; GC.seen=true end
            end
            local floor=GC.seen and GC.base or guess
            local tol=math.max(floor*0.35,1)
            air=clr>floor+tol
            if not air and falling and math.abs(vy)>4 and clr>floor+0.35 then air=true end
        else air=true end
        if air~=TR.air then
            TR.air_edge=now
            if air then TR.air_since=now; TR.jump_fresh=true; TR.jump_v=JL.seen and JL.v or math.max(vy,0)
            else TR.jump_fresh=false; TR.jump_v=0 end
        end
        local model_vy=TR.jump_v-g*math.max(0,now-TR.air_since)
        TR.air=air
        TR.jumping=air and (vy>1 or model_vy>1)
    end
    local function track(now)
        local part=target_part
        if not part or not part.Parent then if TR.part then track_clear() end return end
        track_fresh(now)
        local pos=part.Position
        if part~=TR.part or not TR.pos then track_seed(part,pos,now); return end
        local dt=now-TR.time
        if dt>0.75 or (pos-TR.pos).Magnitude>140 then track_seed(part,pos,now); return end
        if dt<=0 then return end
        if (pos-TR.pos).Magnitude==0 then
            if TR.gap>0 and dt>=TR.gap then TR.vel=Vector3.zero; TR.fresh=Vector3.zero end
            return
        end
        step_push(dt); TR.gap=dt; snap_push(now,pos); TR.pos=pos; TR.time=now
        local fit,fit_age=fit_velocity()
        local fast,fast_age=recent_velocity()
        local engine=engine_vel(part)
        local fresh,turn,instant,trust=merge_vel(fit,fit_age,fast,fast_age,engine,sample_span()*0.5,TR.air)
        local kv=kin_update()
        if kv then fresh=Vector3.new(kv.X,fresh.Y,kv.Z) end
        if engine and trust<=0 then if TR.spoof<20 then TR.spoof=TR.spoof+1 end
        elseif TR.spoof>0 then TR.spoof=TR.spoof-1 end
        if TR.air then
            local vy=air_vy()
            if vy then
                fresh=Vector3.new(fresh.X,vy,fresh.Z)
                local since=math.max(0,now-TR.air_edge)
                if TR.jump_fresh and since<=0.2 then
                    local impulse=vy+grav()*since
                    if impulse>1 then
                        if JL.seen then JL.v=JL.v*0.7+impulse*0.3 else JL.v=impulse; JL.seen=true end
                        if impulse>TR.jump_v then TR.jump_v=impulse end
                    end
                else TR.jump_fresh=false end
            end
        end
        TR.vel=fresh; TR.ready=fit~=nil or fast~=nil
        TR.fresh=TR.vel; TR.fresh_ok=TR.ready; TR.turn=turn
        local raw=instant or fresh
        vel_push(now,raw.X,raw.Z)
    end
    local function raw_rtt()
        local a,b
        local ok,ms=pcall(function() return stats.Network.ServerStatsItem["Data Ping"]:GetValue() end)
        if ok and type(ms)=="number" and ms==ms and ms>4 and ms<800 then a=ms/1000 end
        local fine,value=pcall(function() return lp:GetNetworkPing() end)
        if fine and type(value)=="number" and value==value and value>0 then
            local rtt=value*2
            if rtt>0.004 and rtt<0.8 then b=rtt end
        end
        if a and b then return (a+b)*0.5 end
        return a or b
    end
    local function sample_ping()
        local rtt=raw_rtt()
        if not rtt or rtt~=rtt then return end
        rtt=math.clamp(rtt,0,1)
        if EC.seen then
            EC.jitter=EC.jitter*0.9+math.abs(rtt-EC.rtt)*0.1
            EC.rtt=EC.rtt*0.82+rtt*0.18
        else EC.rtt=rtt; EC.jitter=0; EC.seen=true end
        EC.ping=EC.rtt
    end
    local function lead_time()
        if not EC.seen then return 0 end
        local stale=0
        if TR.time>0 and EC.step_seen then stale=math.clamp(os.clock()-TR.time,0,EC.step) end
        return math.clamp(EC.rtt+EC.jitter*0.5+stale,0,1)
    end
    local function rotate_y(v,ang)
        local c,s=math.cos(ang),math.sin(ang)
        return Vector3.new(v.X*c-v.Z*s,v.Y,v.X*s+v.Z*c)
    end
    local function dir_stats(win)
        if SK.vn<4 then return 1,0 end
        win=math.max(win,sample_span()*3)
        local newest=SK.vt[SK.vi]
        local sx,sz,n=0,0,0
        local prev=nil; local turn,turn_n=0,0; local oldest=newest
        for k=0,SK.vn-1 do
            local idx=(SK.vi-k-1)%P.ring+1
            local t=SK.vt[idx]
            if newest-t>win then break end
            local hx,hz=SK.dx[idx],SK.dz[idx]
            local m=math.sqrt(hx*hx+hz*hz)
            if m>0 then
                sx=sx+hx/m; sz=sz+hz/m; n=n+1
                local ang=math.atan2(hz,hx)
                if prev then
                    local d=ang-prev
                    while d>math.pi do d=d-6.2831853 end
                    while d<-math.pi do d=d+6.2831853 end
                    turn=turn+d; turn_n=turn_n+1
                end
                prev=ang; oldest=t
            end
        end
        if n<2 then return 1,0 end
        local coh=math.clamp(math.sqrt(sx*sx+sz*sz)/n,0,1)
        local omega=0
        local elapsed=newest-oldest
        if turn_n>=1 and elapsed>1e-3 then omega=-turn/elapsed end
        return coh,omega
    end
    local function predict_from(base,sa,sb,fh,now)
        local span=math.max(0,sa+sb); local g=grav(); local dir=fh
        if dir.Magnitude==0 then dir=Vector3.new(TR.vel.X,0,TR.vel.Z) end
        local x,z
        if span>0 and KIN.ok then
            local age=math.clamp(now-TR.time,0,sample_span()*2)
            local ax,az=KIN.ax,KIN.az
            if TR.air or math.sqrt(ax*ax+az*az)<P.acc_min then ax,az=0,0 end
            local vx=dir.X+ax*age; local vz=dir.Z+az*age
            local ta=math.min(span,P.acc_t)
            local dx=vx*span+0.5*ax*ta*ta; local dz=vz*span+0.5*az*ta*ta
            local reach=math.sqrt(dx*dx+dz*dz)
            local cap=math.max(KIN.smax*P.speed_head,P.speed_floor)*span
            if reach>cap and reach>1e-6 then dx=dx*cap/reach; dz=dz*cap/reach end
            x=base.X+dx; z=base.Z+dz
        else
            local hspan=span
            if span>0 and dir.Magnitude>0 and not TR.air then
                local coh,omega=dir_stats(span)
                local conf=math.clamp(coh,0,1)*(1-math.clamp(TR.turn,0,1)*0.5)
                if omega~=0 then dir=rotate_y(dir,math.clamp(omega*span*0.5*conf,-0.6,0.6)) end
                hspan=span*(0.85+0.15*conf)
            end
            x=base.X+dir.X*hspan; z=base.Z+dir.Z*hspan
        end
        local y=base.Y
        if TR.air and span>0 then
            local vy=TR.vel.Y
            local phase=math.max(0,now-TR.air_since)
            local modeled=TR.jump_v-g*phase
            if TR.jumping and TR.jump_v>0 and g>0 and phase<=TR.jump_v/g and modeled>vy then vy=modeled end
            y=base.Y+vy*span-0.5*g*span*span
            if y<base.Y then
                local clearance=stand_clearance()
                local reach=base.Y-y+clearance
                local gy=ground_below(Vector3.new(x,base.Y,z),reach)
                if gy then local floor=gy+clearance if y<floor then y=floor end end
            end
        end
        return Vector3.new(x,y,z)
    end
    local function build_hyps(base,now)
        table.clear(HY.pos); table.clear(HY.w)
        local horizon=SL.predict and TR.ready and lead_time() or 0
        local fh=Vector3.new(TR.fresh.X,0,TR.fresh.Z)
        HY.primary=predict_from(base,0,horizon,fh,now)
        HY.n=1; HY.pos[1]=HY.primary; HY.w[1]=1; HY.weight=1; HY.stamp=now
    end
    local function score_axis(anchor,axis)
        local covered=0; local lo,hi=0,0
        for k=1,HY.n do
            local d=HY.pos[k]-anchor; local a=d:Dot(axis)
            local perp=(d-axis*a).Magnitude
            if perp<=P.hit_r then
                covered=covered+HY.w[k]
                if a<lo then lo=a end
                if a>hi then hi=a end
            end
        end
        return covered,lo,hi
    end
    local function corridor_axes(anchor)
        table.clear(axis_pool); local n=0
        local function add(v)
            if typeof(v)~="Vector3" or v.Magnitude<1e-4 then return end
            local u=v.Unit
            for k=1,n do if axis_pool[k]:Dot(u)>0.985 then return end end
            n=n+1; axis_pool[n]=u
        end
        local fh=Vector3.new(TR.fresh.X,0,TR.fresh.Z)
        if TR.air then add(TR.fresh) end
        add(fh)
        for k=1,HY.n do add(HY.pos[k]-anchor) end
        add(TR.fresh); add(Vector3.new(0,1,0))
        return n
    end
    local function build_corridor(now)
        local part=target_part
        if not part or not part.Parent then return nil end
        local base=part.Position
        build_hyps(base,now)
        local anchor=HY.primary or base
        local count=corridor_axes(anchor)
        local best_axis,best_cov,best_lo,best_hi=nil,-1,0,0
        for k=1,count do
            local axis=axis_pool[k]
            local cov,lo,hi=score_axis(anchor,axis)
            if cov>best_cov then best_axis,best_cov,best_lo,best_hi=axis,cov,lo,hi end
        end
        if not best_axis then return nil end
        HY.conf=HY.weight>0 and best_cov/HY.weight or 0
        local pad=P.pad
        local origin=anchor+best_axis*(best_lo-pad)
        local aim=anchor+best_axis*(best_hi+pad)
        if (aim-origin).Magnitude<4 then origin=anchor-best_axis*4; aim=anchor+best_axis*4 end
        return origin,aim,HY.conf,anchor
    end
    local pred_off=Vector3.zero; local pred_stamp=0
    local function lead_offset()
        local part=target_part
        if not part or not part.Parent then return Vector3.zero end
        if not SL.predict or not TR.ready then return Vector3.zero end
        local base=part.Position
        local now=os.clock()
        local fh=Vector3.new(TR.fresh.X,0,TR.fresh.Z)
        local point=predict_from(base,0,lead_time(),fh,now)
        local off=point-base; pred_stamp=now; pred_off=off
        return pred_off
    end
    local hit_names={"HumanoidRootPart","UpperTorso","Torso","LowerTorso","Head","RightUpperArm","LeftUpperArm","Right Arm","Left Arm","RightUpperLeg","LeftUpperLeg","Right Leg","Left Leg","RightLowerLeg","LeftLowerLeg"}
    local hit_parts={}; local hit_count=0; local hit_char=nil
    local function refresh_parts()
        local char=target_char
        if char==hit_char then return end
        table.clear(hit_parts); hit_count=0; hit_char=char
        if not char then return end
        for k=1,#hit_names do
            local part=char:FindFirstChild(hit_names[k])
            if part and part:IsA("BasePart") then hit_count=hit_count+1; hit_parts[hit_count]=part end
        end
    end
    local function los_clear(origin,point)
        if not origin or not point then return false end
        local delta=point-origin; local dist=delta.Magnitude
        if dist<0.5 then return true end
        if dist>MAX_RANGE then return false end
        local hit=trace(origin,delta)
        if not hit then return true end
        local inst=hit.Instance
        local char=target_char
        if inst and char and (inst==char or inst:IsDescendantOf(char)) then return true end
        return (hit.Position-origin).Magnitude>=dist-0.75
    end
    local function pick_point(origin,strict)
        refresh_parts()
        if hit_count==0 then return nil end
        local off=lead_offset()
        local first=nil
        for k=1,hit_count do
            local part=hit_parts[k]
            if not part.Parent then hit_char=nil
            else
                local point=part.Position+off
                if not origin then return point end
                if not first then first=point end
                if los_clear(origin,point) then return point end
            end
        end
        if strict then return nil end
        return first
    end
    local force_att=nil; local force_saved=nil; local force_stamp=0
    local function restore_origin()
        local att=force_att
        if not att then return end
        local saved=force_saved
        force_att=nil; force_saved=nil
        if saved then pcall(function() if att.Parent then att.CFrame=saved end end) end
    end
    local function push_origin(cf)
        local att=gun_attachment()
        if not att then return false end
        if force_att and force_att~=att then restore_origin() end
        if not force_att then
            local ok,saved=pcall(function() return att.CFrame end)
            if not ok or typeof(saved)~="CFrame" then return false end
            force_att=att; force_saved=saved
        end
        force_stamp=os.clock()
        local ok=pcall(function() att.WorldCFrame=cf end)
        if not ok then restore_origin() return false end
        task.defer(restore_origin); return true
    end
    local function is_target_hit(inst)
        local char=target_char
        if not inst or not char then return false end
        return inst==char or inst:IsDescendantOf(char)
    end
    local function force_clear(origin,aim)
        local hit=trace(origin,aim-origin)
        if not hit then return false end
        return is_target_hit(hit.Instance)
    end
    local function force_velocity()
        if TR.fresh_ok and TR.fresh.Magnitude>0.5 then return TR.fresh end
        if TR.ready and TR.vel.Magnitude>0.5 then return TR.vel end
        return Vector3.zero
    end
    local function resolve_force()
        local part=target_part
        if not part or not part.Parent then return nil end
        local live=part.Position; local now=os.clock()
        local origin,aim,conf,anchor=build_corridor(now)
        if origin and aim then
            local axis=aim-origin; local span=axis.Magnitude
            if span>1e-3 then
                local u=axis/span; local mark=anchor or live
                local behind=(mark-origin):Dot(u)
                if behind<P.pad then origin=origin-u*(P.pad-behind) end
                local ahead=(aim-mark):Dot(u)
                if ahead<P.min_span then aim=mark+u*P.min_span end
                local want=SL.stand_off
                while want>0 do
                    local probe=origin-u*want
                    if (aim-probe).Magnitude<=P.max_span and los_clear(probe,mark) and los_clear(probe,live) then origin=probe; break end
                    want=want-3
                end
                if (aim-origin).Magnitude>P.max_span then origin=aim-u*P.max_span end
                return CFrame.new(origin,aim),CFrame.new(aim),conf or 0,mark
            end
        end
        local vel=force_velocity(); local dir=Vector3.new(0,-1,0)
        if vel.Magnitude>3 then dir=vel.Unit
        else
            local mine=SL_origin()
            if mine then local delta=live-mine.Position if delta.Magnitude>2 then dir=delta.Unit end end
        end
        local back=live-dir*6
        local front=live+dir*math.max(P.min_span,vel.Magnitude*lead_time()+8)
        if not force_clear(back,front) then back=live-dir*2.5 end
        return CFrame.new(back,front),CFrame.new(front),0,live
    end
    local function shot_shift(dt)
        if not SL.predict or not TR.ready or dt<=0 then return Vector3.zero end
        local shift=Vector3.new(TR.vel.X*dt,0,TR.vel.Z*dt)
        if TR.air then
            local g=grav(); local horizon=lead_time(); local vy=TR.vel.Y
            local phase=math.max(0,os.clock()-TR.air_since)
            local modeled=TR.jump_v-g*phase
            if TR.jumping and TR.jump_v>0 and g>0 and phase<=TR.jump_v/g and modeled>vy then vy=modeled end
            shift=Vector3.new(shift.X,vy*dt-g*horizon*dt-0.5*g*dt*dt,shift.Z)
        end
        return shift
    end
    local function compensate_force(origin_cf,aim_cf,started)
        local shift=shot_shift(math.max(0,os.clock()-started))
        if shift==Vector3.zero then return origin_cf,aim_cf end
        local origin=origin_cf.Position+shift; local aim=aim_cf.Position+shift
        return CFrame.new(origin,aim),CFrame.new(aim)
    end
    resolve_shot=function()
        if not SL.enabled or not SL.am_sheriff or not SL_alive() then return nil end
        if SL.force then
            local started=os.clock()
            local origin_cf,aim_cf=resolve_force()
            if origin_cf and aim_cf then
                origin_cf,aim_cf=compensate_force(origin_cf,aim_cf,started)
                if push_origin(origin_cf) then return aim_cf end
            end
        end
        local cf=SL_origin()
        local aim=pick_point(cf and cf.Position or nil,false)
        if not aim then return nil end
        return CFrame.new(aim)
    end
    local function compensate_resolve(cf)
        if SL.force or typeof(cf)~="CFrame" then return cf end
        return CFrame.new(cf.Position+shot_shift(math.max(0,os.clock()-pred_stamp)))
    end
    local weapon_service=nil; local orig_mouse=nil; local orig_screen=nil
    local hook_mouse=nil; local hook_screen=nil
    local function get_weapon_service()
        if weapon_service then return weapon_service end
        local ok,m=pcall(function() return require(ReplicatedStorage:WaitForChild("ClientServices"):WaitForChild("WeaponService")) end)
        if ok and type(m)=="table" then weapon_service=m end
        return weapon_service
    end
    install_hooks=function()
        local m=get_weapon_service()
        if not m then return end
        if not hook_mouse then
            hook_mouse=function(self,...)
                sample_ping()
                local ok,cf=pcall(resolve_shot)
                if ok and cf then return compensate_resolve(cf) end
                return orig_mouse(self,...)
            end
            hook_screen=function(self,x,y,...)
                sample_ping()
                local ok,cf=pcall(resolve_shot)
                if ok and cf then return compensate_resolve(cf) end
                return orig_screen(self,x,y,...)
            end
        end
        pcall(function() setreadonly(m,false) end)
        if type(m.GetMouseTargetCFrame)=="function" and m.GetMouseTargetCFrame~=hook_mouse then
            orig_mouse=m.GetMouseTargetCFrame
            pcall(function() m.GetMouseTargetCFrame=hook_mouse end)
        end
        if type(m.GetTargetPosition)=="function" and m.GetTargetPosition~=hook_screen then
            orig_screen=m.GetTargetPosition
            pcall(function() m.GetTargetPosition=hook_screen end)
        end
    end
    SL_installHooks=install_hooks
    local function get_gun_sh()
        local char=LP.Character
        if char then local g=char:FindFirstChild("Gun") if g then return g,true end end
        local bp=LP:FindFirstChildOfClass("Backpack")
        if bp then local g=bp:FindFirstChild("Gun") if g then return g,false end end
        return nil,false
    end
    local function fire_gun_sh(gun,start_cf,aim_cf)
        if not gun or not start_cf or not aim_cf then return false end
        local remote=gun:FindFirstChild("Shoot")
        if not remote or not remote:IsA("RemoteEvent") then return false end
        return (pcall(function() remote:FireServer(start_cf,aim_cf) end))
    end
    local function auto_step(now)
        if not SL.auto_on or not SL.enabled or not SL.am_sheriff or getgenv().AUTOFARM_HOLD or not SL_alive() then want_since=0; return end
        local gun,equipped=get_gun_sh()
        if not gun then want_since=0; return end
        if gun~=gap_gun then gap_gun=gun; gap_reset() end
        if not equipped then
            want_since=0
            local hum=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
            if hum then pcall(function() hum:EquipTool(gun) end) end
            return
        end
        if want_since==0 then want_since=now end
        local hold=SL.auto_delay
        if hold<SL.fire_gap then hold=SL.fire_gap end
        local since=SL_lastShot>0 and SL_lastShot or SL.last_shot
        if now-since<hold then return end
        if SL.force then
            local started=os.clock()
            local origin_cf,aim_cf=resolve_force()
            if not origin_cf or not aim_cf then return end
            origin_cf,aim_cf=compensate_force(origin_cf,aim_cf,started)
            if fire_gun_sh(gun,origin_cf,aim_cf) then SL.last_shot=now; SL_lastShot=now end
            return
        end
        local cf=SL_origin()
        if not cf then return end
        local aim=pick_point(cf.Position,true)
        if not aim then return end
        local aim_cf=compensate_resolve(CFrame.new(aim))
        if fire_gun_sh(gun,cf,aim_cf) then SL.last_shot=now; SL_lastShot=now end
    end
    _G.DaDa_SL_auto_step=auto_step
    _G.DaDa_SL_track=track
    _G.DaDa_SL_restore_origin=restore_origin
    _G.DaDa_SL_target_alive=SL_alive
end
initSilent()

-- ============================================================
-- INIT 5: FOV CIRCLE
-- ============================================================
local function initFovTrigger()
    fovGui=Instance.new("ScreenGui")
    fovGui.Name="DaDaFOV_"..math.random(1000,9999); fovGui.ResetOnSpawn=false; fovGui.IgnoreGuiInset=true
    pcall(function() fovGui.Parent=CoreGui end)
    if not fovGui.Parent then fovGui.Parent=LP:WaitForChild("PlayerGui") end
    local fovCircle=Instance.new("Frame")
    fovCircle.AnchorPoint=Vector2.new(0.5,0.5); fovCircle.Position=UDim2.fromScale(0.5,0.5)
    fovCircle.BackgroundTransparency=1; fovCircle.Visible=false; fovCircle.Parent=fovGui
    Instance.new("UICorner",fovCircle).CornerRadius=UDim.new(1,0)
    local fovStroke=Instance.new("UIStroke",fovCircle); fovStroke.Color=ACCENT; fovStroke.Thickness=1.5
    table.insert(themeUpdaters,function(t) fovStroke.Color=t.Accent end)
    RunService.RenderStepped:Connect(function()
        fovCircle.Visible=ST.fov_circle and SL.enabled
        fovCircle.Size=UDim2.fromOffset(ST.fov_size*2,ST.fov_size*2)
    end)
end
initFovTrigger()

-- ============================================================
-- INIT 6: AUTO GET GUN
-- ============================================================
local function initGetGun()
    local function find_gun_drop()
        for _,o in ipairs(workspace:GetDescendants()) do if o.Name=="GunDrop" and o:IsA("BasePart") then return o end end
        return nil
    end
    local function grab_touch(hrp,gun) pcall(function() if firetouchinterest then firetouchinterest(hrp,gun,0); firetouchinterest(hrp,gun,1) else gun.CFrame=hrp.CFrame end end) end
    local function grab_teleport(hrp,gun) pcall(function() gun.CFrame=hrp.CFrame end) end
    local function grab_player_tp(hrp,gun)
        if my_role()=="Murderer" then return end
        if ST.teleporting then return end
        ST.teleporting=true
        task.spawn(function()
            local old=hrp.CFrame
            pcall(function() hrp.CFrame=gun.CFrame; task.wait(0.08); local h=get_hrp(); if h and ST.getgun_tp_back then h.CFrame=old end end)
            task.wait(0.2); ST.teleporting=false
        end)
    end
    local function grab_prompt(gun)
        if has_knife() then return end
        if not my_role() then return end
        local hrp=get_hrp(); if not hrp then return end
        pcall(function() gun.CFrame=hrp.CFrame end)
        local p=gun:FindFirstChildOfClass("ProximityPrompt")
        if p and fireproximityprompt then pcall(function() fireproximityprompt(p) end) end
    end
    getgun_step=function(now)
        if not ST.getgun then return end
        if now-ST.getgun_last<ST.getgun_interval then return end
        ST.getgun_last=now
        local hrp=get_hrp(); if not hrp then return end
        local gun=find_gun_drop(); if not gun then return end
        if ST.getgun_mode=="Touch" then grab_touch(hrp,gun)
        elseif ST.getgun_mode=="Teleport" then grab_teleport(hrp,gun)
        elseif ST.getgun_mode=="PlayerTP" then grab_player_tp(hrp,gun)
        elseif ST.getgun_mode=="AutoGrab" then grab_prompt(gun) end
    end
end
initGetGun()

-- ============================================================
-- INIT 7: ESP
-- ============================================================
local function initESP()
    local SKEL_R6={{"Head","Torso"},{"Torso","Left Arm"},{"Torso","Right Arm"},{"Torso","Left Leg"},{"Torso","Right Leg"}}
    local SKEL_R15={{"Head","UpperTorso"},{"UpperTorso","LowerTorso"},{"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},{"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},{"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},{"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"}}
    make_esp=function()
        local d={Box=Drawing.new("Square"),Name=Drawing.new("Text"),Dist=Drawing.new("Text"),HealthBg=Drawing.new("Square"),HealthBar=Drawing.new("Square"),Line=Drawing.new("Line"),Skel={},Flag=Drawing.new("Text")}
        d.Box.Filled=false; d.Box.Thickness=1.5
        d.Name.Center=true; d.Name.Outline=true; d.Name.Size=14
        d.Dist.Center=true; d.Dist.Outline=true; d.Dist.Size=12
        d.HealthBg.Filled=true; d.HealthBg.Color=Color3.new(0,0,0); d.HealthBg.Thickness=0
        d.HealthBar.Filled=true; d.HealthBar.Thickness=0
        d.Flag.Center=true; d.Flag.Outline=true; d.Flag.Size=11
        for i=1,20 do local l=Drawing.new("Line"); l.Thickness=1; l.Transparency=1; d.Skel[i]=l end
        return d
    end
    remove_esp=function(d)
        for k,v in pairs(d) do
            if type(v)=="table" then for _,l in ipairs(v) do pcall(function() l:Remove() end) end
            else pcall(function() v:Remove() end) end
        end
    end
    clear_highlights=function()
        for _,p in ipairs(Players:GetPlayers()) do if p.Character then local h=p.Character:FindFirstChild("DaDaChams"); if h then pcall(function() h:Destroy() end) end end end
    end
    update_highlights=function(roles)
        if not (ST.esp_on and ST.esp_chams) then clear_highlights(); return end
        for _,p in ipairs(Players:GetPlayers()) do
            if p~=LP and p.Character then
                local role=roles[p.Name]; local col
                if ST.esp_chams_roles then col=role=="Murderer" and Color3.fromRGB(255,90,90) or (role=="Sheriff" or role=="Hero") and Color3.fromRGB(90,160,255) or Color3.fromRGB(230,230,240) else col=ST.esp_box_col end
                local h=p.Character:FindFirstChild("DaDaChams")
                if not h then h=Instance.new("Highlight"); h.Name="DaDaChams"; h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop; h.Parent=p.Character end
                h.FillColor=col; h.OutlineColor=col; h.FillTransparency=0.5; h.OutlineTransparency=0; h.Enabled=true
            end
        end
    end
    esp_step=function()
        if not ST.esp_on then for plr,d in pairs(esp_cache) do remove_esp(d); esp_cache[plr]=nil end; clear_highlights(); return end
        local cam=workspace.CurrentCamera; if not cam then return end
        local roles=get_roles(); update_highlights(roles)
        for _,plr in ipairs(Players:GetPlayers()) do
            if plr~=LP and plr.Character then
                local char=plr.Character
                local hrp=char:FindFirstChild("HumanoidRootPart")
                local hum=char:FindFirstChildOfClass("Humanoid")
                if hrp and hum and hum.Health>0 then
                    local dist=(hrp.Position-cam.CFrame.Position).Magnitude
                    local d=esp_cache[plr]; if not d then d=make_esp(); esp_cache[plr]=d end
                    if dist>ST.esp_max_dist then
                        for k,v in pairs(d) do if type(v)=="table" then for _,l in ipairs(v) do l.Visible=false end else v.Visible=false end end
                    else
                        local cf=hrp.CFrame
                        local corners={Vector3.new(-2,2.75,-1),Vector3.new(2,2.75,-1),Vector3.new(-2,-2.75,-1),Vector3.new(2,-2.75,-1),Vector3.new(-2,2.75,1),Vector3.new(2,2.75,1),Vector3.new(-2,-2.75,1),Vector3.new(2,-2.75,1)}
                        local minX,minY=math.huge,math.huge; local maxX,maxY=-math.huge,-math.huge; local valid=true
                        for _,o in ipairs(corners) do
                            local vp,on=cam:WorldToViewportPoint((cf*CFrame.new(o)).Position)
                            if vp.Z<=0 then valid=false break end
                            if on then minX=math.min(minX,vp.X); minY=math.min(minY,vp.Y); maxX=math.max(maxX,vp.X); maxY=math.max(maxY,vp.Y) end
                        end
                        if valid and minX<maxX and minY<maxY then
                            local bw=maxX-minX; local bh=maxY-minY
                            d.Box.Size=Vector2.new(bw,bh); d.Box.Position=Vector2.new(minX,minY); d.Box.Color=ST.esp_box_col; d.Box.Visible=ST.esp_box
                            d.Name.Text=plr.Name; d.Name.Position=Vector2.new(minX+bw/2,minY-16); d.Name.Color=ST.esp_name_col; d.Name.Visible=ST.esp_name
                            d.Dist.Text=string.format("%dm",math.floor(dist)); d.Dist.Position=Vector2.new(minX+bw/2,maxY+2); d.Dist.Color=ST.esp_dist_col; d.Dist.Visible=ST.esp_dist
                            local hf=hum.Health/hum.MaxHealth
                            d.HealthBg.Size=Vector2.new(3,bh); d.HealthBg.Position=Vector2.new(minX-6,minY); d.HealthBg.Visible=ST.esp_health
                            d.HealthBar.Size=Vector2.new(3,bh*hf); d.HealthBar.Position=Vector2.new(minX-6,minY+bh*(1-hf)); d.HealthBar.Color=Color3.fromRGB(255*(1-hf),255*hf,0); d.HealthBar.Visible=ST.esp_health
                            if ST.esp_line then d.Line.From=Vector2.new(cam.ViewportSize.X/2,cam.ViewportSize.Y); d.Line.To=Vector2.new(minX+bw/2,maxY); d.Line.Color=ST.esp_box_col; d.Line.Thickness=1; d.Line.Visible=true else d.Line.Visible=false end
                            if ST.esp_skel then
                                local isR15=char:FindFirstChild("UpperTorso")~=nil
                                local skel=isR15 and SKEL_R15 or SKEL_R6
                                for i=1,#d.Skel do d.Skel[i].Visible=false end
                                for i,pair in ipairs(skel) do
                                    local a=char:FindFirstChild(pair[1]); local b=char:FindFirstChild(pair[2])
                                    if a and b then
                                        local ap,aon=cam:WorldToViewportPoint(a.Position); local bp,bon=cam:WorldToViewportPoint(b.Position)
                                        if aon and bon then local l=d.Skel[i]; l.From=Vector2.new(ap.X,ap.Y); l.To=Vector2.new(bp.X,bp.Y); l.Color=ST.esp_skel_col; l.Visible=true end
                                    end
                                end
                            else for i=1,#d.Skel do d.Skel[i].Visible=false end end
                        else for k,v in pairs(d) do if type(v)=="table" then for _,l in ipairs(v) do l.Visible=false end else v.Visible=false end end end
                    end
                elseif esp_cache[plr] then remove_esp(esp_cache[plr]); esp_cache[plr]=nil end
            end
        end
    end
end
initESP()

-- ============================================================
-- INIT 8: KNIFE AUTO THROW + TRIGGER BOT
-- ============================================================
local function initKnifeTrigger()
    local last_trig = 0
    triggerbot_step = function()
        if not ST.triggerbot then return end
        if not SL or not SL.enabled then return end
        if not SL.am_sheriff then return end
        if not SL_alive() then return end
        if getgenv().AUTOFARM_HOLD then return end
        local now = os.clock()
        if now - last_trig < 0.05 then return end
        local cam = workspace.CurrentCamera
        if not cam then return end
        local m = SL_getRound()
        local data = m and m.PlayerData
        local myHrp = get_hrp()
        if not myHrp then return end
        local mouse = UIS:GetMouseLocation()
        local best, best_dist = nil, ST.fov_size
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                local thrp = p.Character:FindFirstChild("HumanoidRootPart")
                local th = p.Character:FindFirstChildOfClass("Humanoid")
                if thrp and th and th.Health > 0 then
                    local sp, on = cam:WorldToViewportPoint(thrp.Position)
                    if on then
                        local d = (Vector2.new(sp.X, sp.Y) - mouse).Magnitude
                        if d < best_dist then
                            best_dist = d
                            best = p
                        end
                    end
                end
            end
        end
        if not best then return end
        local gun, eq = (function()
            local c = LP.Character
            if c then local g = c:FindFirstChild("Gun") if g then return g, true end end
            local bp = LP:FindFirstChildOfClass("Backpack")
            if bp then local g = bp:FindFirstChild("Gun") if g then return g, false end end
            return nil, false
        end)()
        if not gun or not eq then return end
        last_trig = now
        local shootRemote = gun:FindFirstChild("Shoot")
        if shootRemote and shootRemote:IsA("RemoteEvent") then
            local cf = SL_origin()
            if cf then
                local target_part = best.Character:FindFirstChild("HumanoidRootPart") or best.Character:FindFirstChild("Head")
                if target_part then
                    pcall(function() shootRemote:FireServer(cf, CFrame.new(target_part.Position)) end)
                end
            end
        end
    end

    local last_knife = 0
    knife_silent_step = function()
        if not ST.auto_knife_throw then return end
        if my_role() ~= "Murderer" then return end
        if getgenv().AUTOFARM_HOLD then return end
        local now = os.clock()
        if now - last_knife < 0.1 then return end
        local char = LP.Character
        local k = char and char:FindFirstChild("Knife")
        if not k then return end
        local my = get_hrp()
        if not my then return end
        local best, best_dist = nil, math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if hum and hrp and hum.Health > 0 then
                    local d = (hrp.Position - my.Position).Magnitude
                    if d < best_dist then
                        best_dist = d
                        best = hrp
                    end
                end
            end
        end
        if not best then return end
        last_knife = now
        local events = k:FindFirstChild("Events")
        local throw = events and events:FindFirstChild("ThrowKnife")
        if not throw then return end
        local lead = best.Position
        if ST.knife_predict then
            local v = best.AssemblyLinearVelocity
            lead = lead + v * (ping_sec() + 0.05) * (ST.knife_lead / 100)
        end
        pcall(function() throw:FireServer(CFrame.new(lead)) end)
    end
end
initKnifeTrigger()

-- ============================================================
-- INIT 9: FARM + FLING + ANTIFLING + KILL AURA
-- ============================================================
local function initFarmFling()
    local was_down=false; local down_ref_y=nil; local last_touch=0
    local farm_target=nil; local collected_ids={}; local collected_count=0
    local coins_done=false; local saw_coins=false
    getgenv().AUTOFARM_HOLD=false
    farm_hrp=function() local c=LP.Character; return c and c:FindFirstChild("HumanoidRootPart") end
    local function get_round_data() local m=get_round(); return m and m.PlayerData end
    can_farm=function()
        local char=LP.Character; local hum=char and char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health<=0 then return false end
        local d=get_round_data()
        if type(d)=="table" then local me=d[LP.Name]; if not me or not me.Role or me.Dead then return false end end
        return true
    end
    coin_bags_full=function()
        local pg=LP:FindFirstChild("PlayerGui"); local main=pg and pg:FindFirstChild("MainGUI"); local gg=main and main:FindFirstChild("Game")
        local bags=gg and gg:FindFirstChild("CoinBags"); local container=bags and bags:FindFirstChild("Container")
        if not container then return false end
        local any=false
        for _,v in ipairs(container:GetChildren()) do
            if v:IsA("Frame") and v.Visible then
                any=true
                local full=v:FindFirstChild("Full")
                if not (full and full.Visible) then return false end
            end
        end
        return any
    end
    local function coin_available(v) return v and v.Parent and v:IsA("BasePart") and not v:GetAttribute("Collected") and not v:GetAttribute("Delete") end
    local function nearest_coin(pos,list)
        local best,bd=nil,math.huge
        for _,v in ipairs(list) do
            local d=(v.Position-pos).Magnitude
            if d<bd then bd=d; best=v end
        end
        return best
    end
    local function set_farm_noclip(on)
        local char=LP.Character; local hum=char and char:FindFirstChildOfClass("Humanoid")
        if on then
            if not char then return end
            if hum then pcall(function() hum.PlatformStand=true end) end
            for _,p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") and p.CanCollide then
                    if nc_cache[p]==nil then nc_cache[p]=p.CanCollide end
                    p.CanCollide=false
                end
            end
        else
            if hum then pcall(function() hum.PlatformStand=false end) end
            for p,v in pairs(nc_cache) do if p and p.Parent then pcall(function() p.CanCollide=v end) end end
            nc_cache={}
        end
    end
    local up_params=RaycastParams.new()
    up_params.FilterType=Enum.RaycastFilterType.Exclude
    up_params.IgnoreWater=true
    local function return_to_surface()
        local hrp=farm_hrp(); if not hrp then return end
        local origin=hrp.Position
        up_params.FilterDescendantsInstances={LP.Character}
        local res=workspace:Raycast(origin,Vector3.new(0,400,0),up_params)
        local y=res and (res.Position.Y+5) or (down_ref_y and down_ref_y+5 or nil)
        if not y then return end
        pcall(function()
            hrp.CFrame=CFrame.new(origin.X,y,origin.Z)
            hrp.AssemblyLinearVelocity=Vector3.zero
            hrp.AssemblyAngularVelocity=Vector3.zero
        end)
    end
    farm_release=function() if was_down then was_down=false; return_to_surface() end; set_farm_noclip(false) end
    local murder_hrp_cache,murder_hrp_t=nil,0
    local function murderer_hrp()
        local now=os.clock()
        if now-murder_hrp_t<0.25 then return murder_hrp_cache end
        murder_hrp_t=now; murder_hrp_cache=nil
        local d=get_round_data()
        if type(d)=="table" then
            local me=d[LP.Name]
            if me and me.Role=="Murderer" then return nil end
            for name,info in pairs(d) do
                if type(info)=="table" and info.Role=="Murderer" and not info.Dead and name~=LP.Name then
                    local pl=Players:FindFirstChild(name)
                    local char=pl and pl.Character
                    local h=char and char:FindFirstChild("HumanoidRootPart")
                    local hum=char and char:FindFirstChildOfClass("Humanoid")
                    if h and (not hum or hum.Health>0) then murder_hrp_cache=h end
                    break
                end
            end
        end
        return murder_hrp_cache
    end
    local function flat_dist(a,b) return Vector3.new(a.X-b.X,0,a.Z-b.Z).Magnitude end
    local function pick_coin(pos,list,mpos)
        if not (farm_cfg.avoid_murder and mpos) then return nearest_coin(pos,list) end
        local safe,sd=nil,math.huge
        local far,fd=nil,-1
        for _,v in ipairs(list) do
            local md=flat_dist(v.Position,mpos)
            if md>fd then fd=md; far=v end
            if md>=farm_cfg.avoid_dist then
                local d=(v.Position-pos).Magnitude
                if d<sd then sd=d; safe=v end
            end
        end
        if safe then return safe end
        if far and fd>=farm_cfg.avoid_dist*0.6 then return far end
        return nil
    end
    local function coin_ok_now(v,mpos)
        if not coin_available(v) then return false end
        if farm_cfg.avoid_murder and mpos and flat_dist(v.Position,mpos)<farm_cfg.avoid_dist*0.6 then return false end
        return true
    end
    local function avoid_steer(cur,dest,mpos)
        if not (farm_cfg.avoid_murder and mpos) then return dest end
        local dm=flat_dist(cur,mpos)
        if dm>=farm_cfg.avoid_dist then return dest end
        local away=Vector3.new(cur.X-mpos.X,0,cur.Z-mpos.Z)
        if away.Magnitude<0.1 then away=Vector3.new(1,0,0) end
        away=away.Unit
        local want=Vector3.new(dest.X-cur.X,0,dest.Z-cur.Z)
        local mag=want.Magnitude
        if mag<0.1 then return dest end
        local weight=1+(1-dm/farm_cfg.avoid_dist)*2
        local blend=(want.Unit+away*weight)
        if blend.Magnitude<0.1 then blend=away else blend=blend.Unit end
        local np=cur+blend*mag
        return Vector3.new(np.X,dest.Y,np.Z)
    end
    local function touch_targets(coin)
        local list,seen={},{}
        local function add(p)
            if p and not seen[p] and p:IsA("BasePart") and p:FindFirstChildOfClass("TouchTransmitter") then
                seen[p]=true; list[#list+1]=p
            end
        end
        add(coin)
        for _,v in ipairs(coin:GetChildren()) do add(v) end
        local par=coin.Parent
        if par then
            if par:IsA("BasePart") then add(par) end
            for _,v in ipairs(par:GetChildren()) do add(v) end
        end
        if #list==0 then list[1]=coin end
        return list
    end
    local function fire_touch(coin)
        if type(firetouchinterest)~="function" then return end
        if not coin or not coin.Parent then return end
        local now=os.clock()
        if now-last_touch<0.05 then return end
        last_touch=now
        local hrp=farm_hrp(); if not hrp then return end
        for _,p in ipairs(touch_targets(coin)) do
            pcall(firetouchinterest,hrp,p,0)
            pcall(firetouchinterest,hrp,p,1)
        end
    end
    local function farm_move(hrp,dest,dt)
        local dir=dest-hrp.Position
        local dist=dir.Magnitude
        local np=dest
        if dist>0.1 then np=hrp.Position+dir.Unit*math.min(farm_cfg.speed*dt,dist) end
        local cf=CFrame.new(np)
        if farm_cfg.mode=="Down" then cf=cf*CFrame.Angles(-math.pi*0.5,0,0); was_down=true end
        pcall(function()
            hrp.CFrame=cf
            hrp.AssemblyLinearVelocity=Vector3.zero
            hrp.AssemblyAngularVelocity=Vector3.zero
        end)
    end
    farm_step=function(_,dt)
        if not farm_cfg.on then return end
        if not can_farm() then farm_target=nil; was_down=false; set_farm_noclip(false); return end
        local hrp=farm_hrp(); if not hrp then return end
        local list={}
        for _,v in ipairs(CollectionService:GetTagged("CoinVisual")) do
            if v and v.Parent and v:IsA("BasePart") then
                if v:GetAttribute("Collected") then
                    local id=v:GetAttribute("CoinID")
                    if id and not collected_ids[id] then collected_ids[id]=true; collected_count=collected_count+1 end
                elseif not v:GetAttribute("Delete") then
                    list[#list+1]=v
                end
            end
        end
        local function finish()
            farm_target=nil; farm_release()
            if not coins_done then
                coins_done=true
                getgenv().AUTOFARM_HOLD=false
                if farm_cfg.auto_reset then
                    local hum=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
                    if hum then pcall(function() hum.Health=0 end) end
                end
            end
        end
        if saw_coins and coin_bags_full() then finish() return end
        if #list>0 then
            saw_coins=true
            if coins_done then coins_done=false end
            local mhrp=farm_cfg.avoid_murder and murderer_hrp() or nil
            local mpos=mhrp and mhrp.Position or nil
            if not coin_ok_now(farm_target,mpos) then farm_target=pick_coin(hrp.Position,list,mpos) end
            if farm_target then
                set_farm_noclip(true)
                local cpos=farm_target.Position
                down_ref_y=cpos.Y
                local dest=cpos
                if farm_cfg.mode=="Down" then
                    local xz=flat_dist(hrp.Position,cpos)
                    local safe_rise=(not mpos) or flat_dist(hrp.Position,mpos)>farm_cfg.rise_safe_dist
                    if xz<=4 and safe_rise then dest=cpos; fire_touch(farm_target)
                    else dest=Vector3.new(cpos.X,cpos.Y-farm_cfg.down_depth,cpos.Z) end
                elseif (cpos-hrp.Position).Magnitude<=6 then
                    fire_touch(farm_target)
                end
                dest=avoid_steer(hrp.Position,dest,mpos)
                farm_move(hrp,dest,dt)
            elseif mpos then
                set_farm_noclip(true)
                local away=Vector3.new(hrp.Position.X-mpos.X,0,hrp.Position.Z-mpos.Z)
                if away.Magnitude<0.1 then away=Vector3.new(1,0,0) end
                away=away.Unit
                local y=hrp.Position.Y
                if farm_cfg.mode=="Down" and down_ref_y then y=down_ref_y-farm_cfg.down_depth end
                farm_move(hrp,hrp.Position+away*40+Vector3.new(0,y-hrp.Position.Y,0),dt)
            end
        else
            farm_target=nil
            farm_release()
            if saw_coins and not coins_done and collected_count>0 then finish() end
        end
    end
    RunService.Stepped:Connect(farm_step)

    local FLING_MAX_VEL=700; local FLING_MAX_ANG=90; local FLING_HOLD=0.25; local FLING_SAFE_VEL=250
    local fling_safe_cf=nil; local fling_hold_until=0
    antifling_step=function()
        if not ST.antifling then
            for p,v in pairs(af_cache) do if p.Parent then pcall(function() p.CanCollide=v end) end end
            af_cache={}
            return
        end
        for _,p in ipairs(Players:GetPlayers()) do
            if p~=LP and p.Character then
                for _,part in ipairs(p.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        if af_cache[part]==nil then af_cache[part]=part.CanCollide end
                        if part.CanCollide then part.CanCollide=false end
                        pcall(function() part.CustomPhysicalProperties=PhysicalProperties.new(0,0,0,0,0) end)
                    end
                end
            end
        end
        local hrp=get_hrp()
        if not hrp or not hrp.Parent then fling_safe_cf=nil; return end
        local lin=hrp.AssemblyLinearVelocity
        local ang=hrp.AssemblyAngularVelocity
        local spike=lin.Magnitude>FLING_MAX_VEL or ang.Magnitude>FLING_MAX_ANG
        local now=os.clock()
        if spike then fling_hold_until=now+FLING_HOLD end
        if spike or now<fling_hold_until then
            hrp.AssemblyLinearVelocity=Vector3.zero
            hrp.AssemblyAngularVelocity=Vector3.zero
            if fling_safe_cf and (hrp.Position-fling_safe_cf.Position).Magnitude>60 then hrp.CFrame=fling_safe_cf end
        elseif lin.Magnitude<FLING_SAFE_VEL then fling_safe_cf=hrp.CFrame end
    end

    do_fling=function(tp)
        if not tp or not tp.Character then return end
        local hrp=get_hrp()
        local hum=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if not hrp then return end
        local tc=tp.Character
        local thrp=tc:FindFirstChild("HumanoidRootPart") or tc:FindFirstChild("Head")
        local th=tc:FindFirstChildOfClass("Humanoid")
        if not thrp then return end
        if not getgenv().OldPos or hrp.Velocity.Magnitude<50 then getgenv().OldPos=hrp.CFrame end
        getgenv().FLING_ACTIVE=(getgenv().FLING_ACTIVE or 0)+1
        if th and th.Sit then
            getgenv().FLING_ACTIVE=math.max(0,(getgenv().FLING_ACTIVE or 1)-1)
            return
        end
        local camera=workspace.CurrentCamera
        local old_fdh=workspace.FallenPartsDestroyHeight
        if thrp then camera.CameraSubject=thrp elseif th then camera.CameraSubject=th end
        pcall(function() workspace.FallenPartsDestroyHeight=0/0 end)
        local bv=Instance.new("BodyVelocity")
        bv.Parent=hrp
        bv.Velocity=Vector3.new(0,0,0)
        bv.MaxForce=Vector3.new(9e9,9e9,9e9)
        local se=hum and hum:GetStateEnabled(Enum.HumanoidStateType.Seated)
        if hum then hum:SetStateEnabled(Enum.HumanoidStateType.Seated,false) end
        local tw=2; local tm=tick()
        repeat
            if not hrp or not hrp.Parent then break end
            if th and th.Parent then
                hrp.CFrame=CFrame.new(thrp.Position)*CFrame.new(0,1.5,0)
                hrp.Velocity=Vector3.new(9e7,9e8,9e7)
                hrp.RotVelocity=Vector3.new(9e8,9e8,9e8)
            end
            task.wait()
        until tm+tw<tick() or not (ST.fling_murder or ST.fling_sheriff)
        if bv then bv:Destroy() end
        if hum and se~=nil then hum:SetStateEnabled(Enum.HumanoidStateType.Seated,se) end
        if getgenv().OldPos and hrp and hrp.Parent then
            pcall(function()
                hrp.AssemblyLinearVelocity=Vector3.zero
                hrp.AssemblyAngularVelocity=Vector3.zero
            end)
            pcall(function() hrp.CFrame=getgenv().OldPos end)
            if hum then pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end) end
            task.wait(0.15)
            if hrp and hrp.Parent then
                pcall(function() hrp.CFrame=getgenv().OldPos end)
                pcall(function()
                    hrp.AssemblyLinearVelocity=Vector3.zero
                    hrp.AssemblyAngularVelocity=Vector3.zero
                end)
            end
            getgenv().OldPos=nil
        end
        if camera and hum then camera.CameraSubject=hum end
        pcall(function() workspace.FallenPartsDestroyHeight=old_fdh end)
        getgenv().FLING_ACTIVE=math.max(0,(getgenv().FLING_ACTIVE or 1)-1)
    end
    local fling_thread=nil
    fling_loop=function()
        if fling_thread then return end
        fling_thread=task.spawn(function()
            while ST.fling_murder or ST.fling_sheriff do
                local target=nil; local roles=get_roles()
                if ST.fling_murder then
                    for name,role in pairs(roles) do
                        if role=="Murderer" then target=Players:FindFirstChild(name); break end
                    end
                end
                if not target and ST.fling_sheriff then
                    for name,role in pairs(roles) do
                        if role=="Sheriff" or role=="Hero" then target=Players:FindFirstChild(name); break end
                    end
                end
                if target and target.Character and get_hrp() then do_fling(target)
                else task.wait(0.3) end
                task.wait()
            end
            fling_thread=nil
        end)
    end

    local function get_knife()
        local char=LP.Character
        if char then local k=char:FindFirstChild("Knife") if k then return k,true end end
        local bp=LP:FindFirstChildOfClass("Backpack")
        if bp then local k=bp:FindFirstChild("Knife") if k then return k,false end end
        return nil,false
    end
    local function ensure_knife()
        local k,eq=get_knife(); if not k then return nil end
        if not eq then
            local hum=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
            if hum then pcall(function() hum:EquipTool(k) end) end
            return nil
        end
        return k
    end
    local function knife_stab(k)
        local ev=k:FindFirstChild("Events")
        local s=ev and ev:FindFirstChild("KnifeStabbed")
        if s then pcall(function() s:FireServer() end) end
    end
    local function knife_touch(k,part)
        local ev=k:FindFirstChild("Events")
        local t=ev and ev:FindFirstChild("HandleTouched")
        if t then pcall(function() t:FireServer(part) end) end
    end
    local last_ka=0
    killaura_step=function()
        if not (ST.killaura or ST.autoknife) then return end
        if my_role()~="Murderer" then return end
        if os.clock()-last_ka<0.05 then return end
        local k=ensure_knife(); if not k then return end
        local my_hrp=get_hrp(); if not my_hrp then return end
        local victims={}
        for _,p in ipairs(Players:GetPlayers()) do
            if p~=LP and p.Character then
                local hum=p.Character:FindFirstChildOfClass("Humanoid")
                local part=p.Character:FindFirstChild("HumanoidRootPart") or p.Character:FindFirstChild("Head")
                if hum and hum.Health>0 and part then
                    if ST.autoknife then victims[#victims+1]=part
                    elseif ST.killaura and (part.Position-my_hrp.Position).Magnitude<=ST.killaura_dist then
                        victims[#victims+1]=part
                    end
                end
            end
        end
        if #victims>0 then
            knife_stab(k)
            for _,part in ipairs(victims) do knife_touch(k,part) end
            last_ka=os.clock()
        end
    end
end
initFarmFling()

-- ============================================================
-- INIT 9.5: FLING (fixed)
-- ============================================================
local function initFlingMini()
    ST.fling_mini = ST.fling_mini or {
        on = false,
        mode = "murderer",
        target = nil,
        bypass_vel = false,
        delay = 0.15,
        duration = 2.5,
    }
    ST.fling_active = false
    ST.fling_killer_name = ST.fling_killer_name or nil

    getgenv().DaDa_OldPos = nil
    getgenv().DaDa_FPDH = workspace.FallenPartsDestroyHeight

    -- === ХЕЛПЕРЫ ===
    local function hasKnife(plr)
        local ch = plr and plr.Character
        local bp = plr and plr:FindFirstChildOfClass("Backpack")
        if ch and ch:FindFirstChild("Knife") then return true end
        if bp and bp:FindFirstChild("Knife") then return true end
        return false
    end
    local function hasGun(plr)
        local ch = plr and plr.Character
        local bp = plr and plr:FindFirstChildOfClass("Backpack")
        if ch and ch:FindFirstChild("Gun") then return true end
        if bp and bp:FindFirstChild("Gun") then return true end
        return false
    end

    -- === ПОИСК ЦЕЛИ ===
    local function findTarget()
        local mode = ST.fling_mini.mode
        if mode == "target" and ST.fling_mini.target then
            local p = Players:FindFirstChild(ST.fling_mini.target)
            if p and p ~= LP and p.Character then return p end
            return nil
        end
        if mode == "killer" and ST.fling_killer_name then
            local p = Players:FindFirstChild(ST.fling_killer_name)
            if p and p ~= LP and p.Character then return p end
            return nil
        end
        local best, bestScore = nil, math.huge
        local myRoot = get_hrp()
        local origin = myRoot and myRoot.Position or Vector3.zero
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character then
                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                local root = plr.Character:FindFirstChild("HumanoidRootPart")
                if hum and hum.Health > 0 and root then
                    local ok = false
                    if mode == "murderer" then ok = hasKnife(plr)
                    elseif mode == "sheriff" then ok = hasGun(plr) and not hasKnife(plr)
                    elseif mode == "all" then ok = true end
                    if ok then
                        local d = (root.Position - origin).Magnitude
                        local score = d
                        if mode == "murderer" and hasKnife(plr) then score = score - 1000 end
                        if score < bestScore then
                            bestScore = score
                            best = plr
                        end
                    end
                end
            end
        end
        return best
    end

    -- === САМ ФЛИНГ ===
    local function mini_fling(plr)
        if ST.fling_active then return end
        if not plr or not plr.Character then return end

        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end

        local tChar = plr.Character
        local tHum = tChar:FindFirstChildOfClass("Humanoid")
        local tRoot = tHum and tHum.RootPart
        local tHead = tChar:FindFirstChild("Head")
        local tAcc = tChar:FindFirstChildOfClass("Accessory")
        local tAccHandle = tAcc and tAcc:FindFirstChild("Handle")

        if hrp.AssemblyLinearVelocity.Magnitude < 50 then
            getgenv().DaDa_OldPos = hrp.CFrame
        end

        if not tHum or tHum.Sit then return end

        local flingPart = tHead or tAccHandle or tRoot
        if not flingPart then
            if notify then notify("Fling", plr.Name .. " — нет части") end
            return
        end

        ST.fling_active = true

        local old_fpdh = workspace.FallenPartsDestroyHeight
        pcall(function() workspace.FallenPartsDestroyHeight = 0 / 0 end)

        local bv = Instance.new("BodyVelocity")
        bv.Velocity = Vector3.zero
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Parent = hrp

        pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Seated, false) end)
        pcall(function() workspace.CurrentCamera.CameraSubject = flingPart end)

        local endTime = tick() + (ST.fling_mini.duration or 2.5)
        local spin = 0

        local ok, err = pcall(function()
            while tick() < endTime and ST.fling_active do
                if not hrp.Parent or not tHum or not flingPart.Parent then break end
                if not ST.fling_mini.on then break end

                local vel = flingPart.AssemblyLinearVelocity
                local moveDir = tHum.MoveDirection
                local walkSpeed = tHum.WalkSpeed

                if vel.Magnitude >= 40 then
                    local up = CFrame.new(moveDir.X * walkSpeed * 0.12, 3, moveDir.Z * walkSpeed * 0.12)
                    local down = CFrame.new(-moveDir.X * walkSpeed * 0.06, -3, -moveDir.Z * walkSpeed * 0.06)

                    hrp.CFrame = CFrame.new(flingPart.Position) * up * CFrame.Angles(math.pi / 2, 0, 0)
                    pcall(function() char:SetPrimaryPartCFrame(hrp.CFrame) end)
                    hrp.AssemblyLinearVelocity = Vector3.new(9e7, 9e8, 9e7)
                    task.wait()

                    hrp.CFrame = CFrame.new(flingPart.Position) * down
                    pcall(function() char:SetPrimaryPartCFrame(hrp.CFrame) end)
                    hrp.AssemblyLinearVelocity = Vector3.new(9e7, 9e8, 9e7)
                    task.wait()
                else
                    spin = spin + 100
                    local offset1 = CFrame.new(0, 1.5, 0) + moveDir * (vel.Magnitude / 1.25)
                    local offset2 = CFrame.new(0, -1.5, 0) + moveDir * (vel.Magnitude / 1.25)

                    hrp.CFrame = CFrame.new(flingPart.Position) * offset1 * CFrame.Angles(math.rad(spin), 0, 0)
                    pcall(function() char:SetPrimaryPartCFrame(hrp.CFrame) end)
                    task.wait()

                    hrp.CFrame = CFrame.new(flingPart.Position) * offset2 * CFrame.Angles(math.rad(spin), 0, 0)
                    pcall(function() char:SetPrimaryPartCFrame(hrp.CFrame) end)
                    task.wait()
                end

                hrp.AssemblyLinearVelocity = Vector3.new(9e7, 9e8, 9e7)
                hrp.AssemblyAngularVelocity = Vector3.new(9e8, 9e8, 9e8)
            end
        end)

        if not ok then
            warn("[Fling] Error:", err)
        end

        pcall(function()
            bv:Destroy()
            hum:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
            workspace.CurrentCamera.CameraSubject = hum
            workspace.FallenPartsDestroyHeight = old_fpdh
        end)

        if getgenv().DaDa_OldPos and hrp.Parent then
            local attempts = 0
            repeat
                attempts = attempts + 1
                hrp.CFrame = getgenv().DaDa_OldPos * CFrame.new(0, 0.5, 0)
                pcall(function() char:SetPrimaryPartCFrame(getgenv().DaDa_OldPos * CFrame.new(0, 0.5, 0)) end)
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
                for _, p in ipairs(char:GetChildren()) do
                    if p:IsA("BasePart") then
                        p.Velocity = Vector3.zero
                        p.RotVelocity = Vector3.zero
                    end
                end
                task.wait()
            until attempts > 30 or (hrp.Position - getgenv().DaDa_OldPos.Position).Magnitude < 25

            if notify then notify("Fling", "Возврат на позицию") end
        end

        getgenv().DaDa_OldPos = nil
        ST.fling_active = false
    end

    -- === ЦИКЛ ===
    local fling_thread = nil
    local function start_loop()
        if fling_thread then return end
        fling_thread = task.spawn(function()
            while ST.fling_mini.on do
                local ok, err = pcall(function()
                    if not ST.fling_active then
                        local target = findTarget()
                        if target then
                            mini_fling(target)
                            task.wait(ST.fling_mini.delay or 0.15)
                        else
                            task.wait(0.3)
                        end
                    else
                        task.wait(0.1)
                    end
                end)
                if not ok then
                    warn("[Fling Loop] Error:", err)
                    break
                end
                task.wait()
            end
            fling_thread = nil
        end)
    end

    -- === ЗАХВАТ УБИЙЦЫ ===
    local function bind_killer(char)
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        hum.Died:Connect(function()
            local k = hum:FindFirstChild("creator") or hum:FindFirstChild("Killer")
            if k and k.Value then ST.fling_killer_name = k.Value.Name end
        end)
    end
    bind_killer(LP.Character)
    LP.CharacterAdded:Connect(function(c)
        task.wait(1)
        bind_killer(c)
    end)

    LP.CharacterAdded:Connect(function()
        getgenv().DaDa_OldPos = nil
        ST.fling_active = false
    end)

    -- === API ===
    SHF.fling_mini = {
        set_on = function(v)
            ST.fling_mini.on = v == true
            if not v then
                ST.fling_active = false
                getgenv().DaDa_OldPos = nil
                pcall(function()
                    if getgenv().DaDa_FPDH then
                        workspace.FallenPartsDestroyHeight = getgenv().DaDa_FPDH
                    end
                end)
            end
            if v then start_loop() end
        end,
        set_mode     = function(m) ST.fling_mini.mode = m end,
        set_target   = function(n) ST.fling_mini.target = n end,
        set_bypass   = function(v) ST.fling_mini.bypass_vel = v end,
        set_delay    = function(v) ST.fling_mini.delay = v end,
        set_duration = function(v) ST.fling_mini.duration = v end,
        get_killer   = function() return ST.fling_killer_name end,
        state        = ST.fling_mini,
        fling_now    = mini_fling,
    }
end
initFlingMini()

-- ============================================================
-- INIT 10: MOVEMENT (FIXED InfJump)
-- ============================================================
local function initMovement()
    local flyBody=Instance.new("BodyVelocity"); flyBody.MaxForce=Vector3.new(9e9,9e9,9e9)
    local flyGyro=Instance.new("BodyGyro"); flyGyro.MaxTorque=Vector3.new(9e9,9e9,9e9); flyGyro.P=1000
    RunService.Heartbeat:Connect(function()
        if not ST.fly then
            if flyBody.Parent then flyBody.Parent=nil end
            if flyGyro.Parent then flyGyro.Parent=nil end
            return
        end
        local hrp=get_hrp(); if not hrp then return end
        if flyBody.Parent~=hrp then flyBody.Parent=hrp; flyGyro.Parent=hrp end
        local cam=workspace.CurrentCamera; local mv=Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W) then mv=mv+cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then mv=mv-cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then mv=mv-cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then mv=mv+cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then mv=mv+Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then mv=mv-Vector3.new(0,1,0) end
        if mv.Magnitude>0 then mv=mv.Unit*ST.fly_speed end
        flyBody.Velocity=mv
        flyGyro.CFrame=cam.CFrame
    end)
    local nocache={}
    RunService.Stepped:Connect(function()
        if not ST.noclip then
            for p,v in pairs(nocache) do if p.Parent then p.CanCollide=v end end
            nocache={}
            return
        end
        local char=LP.Character; if not char then return end
        for _,p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") then
                if nocache[p]==nil then nocache[p]=p.CanCollide end
                if p.CanCollide then p.CanCollide=false end
            end
        end
    end)
    local infJumpConn=nil
    RunService.Heartbeat:Connect(function()
        if ST.inf_jump and not infJumpConn then
            infJumpConn=UIS.JumpRequest:Connect(function()
                if not ST.inf_jump then return end
                local hum=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
            end)
        elseif not ST.inf_jump and infJumpConn then
            pcall(function() infJumpConn:Disconnect() end)
            infJumpConn=nil
        end
    end)
    RunService.Stepped:Connect(function()
        if ST.speed_hack then
            local hum=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.WalkSpeed~=ST.speed_val then hum.WalkSpeed=ST.speed_val end
        end
    end)
    RunService.Stepped:Connect(function()
        if ST.jump_power then
            local hum=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                if not hum.UseJumpPower then hum.UseJumpPower=true end
                if hum.JumpPower~=ST.jump_val then hum.JumpPower=ST.jump_val end
            end
        end
    end)
    local bhop_conn=nil; local bhop_speed=0; local bhop_last_jump=0; local bhop_last_cam_yaw=nil
    local function bhop_cleanup()
        if bhop_conn then pcall(function() bhop_conn:Disconnect() end) bhop_conn=nil end
        bhop_speed=0; bhop_last_jump=0; bhop_last_cam_yaw=nil
    end
    local function bhop_start()
        bhop_cleanup()
        bhop_conn=RunService.Heartbeat:Connect(function()
            if not ST.bhop then return end
            local hum=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
            local hrp=get_hrp()
            if not hum or not hrp then return end
            local state=hum:GetState()
            local jumping=state==Enum.HumanoidStateType.Jumping
            local freefall=state==Enum.HumanoidStateType.Freefall
            local airborne=jumping or freefall
            local now=tick()
            if jumping and now-bhop_last_jump>0.03 then
                bhop_last_jump=now
                local v=hrp.AssemblyLinearVelocity
                local xz=Vector3.new(v.X,0,v.Z)
                local dir
                if xz.Magnitude>0.1 then dir=xz.Unit
                else
                    local md=hum.MoveDirection
                    if md.Magnitude>0.1 then dir=Vector3.new(md.X,0,md.Z).Unit
                    else
                        local lv=hrp.CFrame.LookVector
                        dir=Vector3.new(lv.X,0,lv.Z)
                        if dir.Magnitude>0 then dir=dir.Unit end
                    end
                end
                if dir then
                    bhop_speed=math.max(bhop_speed,hum.WalkSpeed*1.5)
                    bhop_speed=math.min(bhop_speed+ST.bhop_power*0.35,ST.bhop_power+hum.WalkSpeed*2)
                    hrp.AssemblyLinearVelocity=Vector3.new(dir.X*bhop_speed,v.Y,dir.Z*bhop_speed)
                end
            end
            if airborne and bhop_speed>0 then
                local v=hrp.AssemblyLinearVelocity
                local xz=Vector3.new(v.X,0,v.Z)
                local md=hum.MoveDirection
                local dir
                if md.Magnitude>0.1 then dir=Vector3.new(md.X,0,md.Z).Unit
                elseif xz.Magnitude>0.1 then dir=xz.Unit end
                if dir then
                    local speed=math.max(xz.Magnitude,bhop_speed)
                    hrp.AssemblyLinearVelocity=Vector3.new(dir.X*speed,v.Y,dir.Z*speed)
                end
            end
            if ST.bhop_strafe and airborne then
                local cam=workspace.CurrentCamera
                if cam then
                    local look=cam.CFrame.LookVector
                    local yaw=math.atan2(-look.X,-look.Z)
                    if bhop_last_cam_yaw then
                        local delta=yaw-bhop_last_cam_yaw
                        while delta>math.pi do delta=delta-math.pi*2 end
                        while delta<-math.pi do delta=delta+math.pi*2 end
                        if math.abs(delta)>0.0005 then
                            local v=hrp.AssemblyLinearVelocity
                            local xz=Vector3.new(v.X,0,v.Z)
                            if xz.Magnitude>1 then
                                local rotated=CFrame.fromEulerAnglesYXZ(0,delta,0)*xz
                                hrp.AssemblyLinearVelocity=Vector3.new(rotated.X,v.Y,rotated.Z)
                            end
                        end
                    end
                    bhop_last_cam_yaw=yaw
                end
            end
            if not airborne then
                bhop_speed=hum.WalkSpeed
                if UIS:IsKeyDown(Enum.KeyCode.Space) then hum.Jump=true end
            end
        end)
    end
    RunService.Heartbeat:Connect(function()
        if ST.bhop and not bhop_conn then bhop_start()
        elseif not ST.bhop and bhop_conn then bhop_cleanup() end
    end)
    local orig_grav=workspace.Gravity
    RunService.Stepped:Connect(function()
        if ST.gravity then
            if workspace.Gravity~=ST.gravity_val then workspace.Gravity=ST.gravity_val end
        elseif workspace.Gravity~=orig_grav then workspace.Gravity=orig_grav end
    end)
end
initMovement()

-- ============================================================
-- INIT 11: WORLD + SHADERS + FOG + AMBIENT + EXPOSURE + SKYBOX + WORLD FX + AURA
-- ============================================================
local function initWorld()
    local fb_orig={
        Brightness=Lighting.Brightness, ClockTime=Lighting.ClockTime,
        GlobalShadows=Lighting.GlobalShadows, OutdoorAmbient=Lighting.OutdoorAmbient,
        Ambient=Lighting.Ambient, ExposureCompensation=Lighting.ExposureCompensation,
        FogColor=Lighting.FogColor, FogStart=Lighting.FogStart, FogEnd=Lighting.FogEnd,
    }
    -- DaDa 60 visual themes (visual-only; combat code remains untouched)
    local DADA_VISUAL_PRESETS = {
        ["Arctic"]={Brightness=1.7, ClockTime=13, Ambient={125,165,205}, OutdoorAmbient={95,130,180}, FogColor={170,215,255}, FogEnd=900, ExposureCompensation=-0.05, Bloom=0.25, Saturation=0.05, Contrast=0.08},
        ["Aurora"]={Brightness=1.8, ClockTime=22, Ambient={85,115,180}, OutdoorAmbient={55,80,150}, FogColor={90,160,220}, FogEnd=1200, ExposureCompensation=0.05, Bloom=0.35, Saturation=0.18, Contrast=0.12},
        ["Moonlight"]={Brightness=0.8, ClockTime=0, Ambient={35,45,85}, OutdoorAmbient={18,25,55}, FogColor={30,40,80}, FogEnd=700, ExposureCompensation=-0.15, Bloom=0.15, Saturation=0.08, Contrast=0.15},
        ["Deep Space"]={Brightness=1.1, ClockTime=0, Ambient={40,30,75}, OutdoorAmbient={15,15,35}, FogColor={40,25,80}, FogEnd=1500, ExposureCompensation=-0.1, Bloom=0.3, Saturation=0.25, Contrast=0.18},
        ["Nebula"]={Brightness=1.2, ClockTime=1, Ambient={80,35,110}, OutdoorAmbient={25,15,45}, FogColor={80,35,120}, FogEnd=1300, ExposureCompensation=0, Bloom=0.4, Saturation=0.25, Contrast=0.2},
        ["Red Eclipse"]={Brightness=1.2, ClockTime=19, Ambient={115,35,45}, OutdoorAmbient={50,15,25}, FogColor={130,30,40}, FogEnd=850, ExposureCompensation=-0.1, Bloom=0.3, Saturation=0.2, Contrast=0.15},
        ["Crimson Night"]={Brightness=0.8, ClockTime=1, Ambient={75,15,25}, OutdoorAmbient={25,5,10}, FogColor={90,10,20}, FogEnd=650, ExposureCompensation=-0.2, Bloom=0.2, Saturation=0.1, Contrast=0.2},
        ["Purple Haze"]={Brightness=1.4, ClockTime=20, Ambient={95,65,150}, OutdoorAmbient={40,25,80}, FogColor={115,65,170}, FogEnd=1000, ExposureCompensation=0, Bloom=0.3, Saturation=0.18, Contrast=0.12},
        ["Violet Dream"]={Brightness=1.6, ClockTime=16, Ambient={125,85,180}, OutdoorAmbient={65,40,105}, FogColor={145,90,190}, FogEnd=1100, ExposureCompensation=0.05, Bloom=0.35, Saturation=0.2, Contrast=0.08},
        ["Cyberpunk"]={Brightness=1.5, ClockTime=21, Ambient={30,100,110}, OutdoorAmbient={15,35,55}, FogColor={30,150,170}, FogEnd=900, ExposureCompensation=0.05, Bloom=0.45, Saturation=0.3, Contrast=0.18},
        ["Neon City"]={Brightness=1.5, ClockTime=22, Ambient={130,35,120}, OutdoorAmbient={45,15,60}, FogColor={180,30,140}, FogEnd=850, ExposureCompensation=0, Bloom=0.5, Saturation=0.25, Contrast=0.2},
        ["Toxic Green"]={Brightness=1.3, ClockTime=12, Ambient={65,120,50}, OutdoorAmbient={20,55,25}, FogColor={60,140,50}, FogEnd=800, ExposureCompensation=-0.05, Bloom=0.2, Saturation=0.1, Contrast=0.1},
        ["Emerald"]={Brightness=1.5, ClockTime=14, Ambient={70,145,95}, OutdoorAmbient={25,65,40}, FogColor={70,170,110}, FogEnd=1000, ExposureCompensation=0.05, Bloom=0.3, Saturation=0.12, Contrast=0.08},
        ["Forest"]={Brightness=1.1, ClockTime=9, Ambient={60,90,65}, OutdoorAmbient={25,45,30}, FogColor={75,115,75}, FogEnd=650, ExposureCompensation=-0.1, Bloom=0.15, Saturation=0.1, Contrast=0.1},
        ["Jungle"]={Brightness=1.2, ClockTime=11, Ambient={80,120,55}, OutdoorAmbient={25,60,20}, FogColor={85,130,55}, FogEnd=750, ExposureCompensation=-0.05, Bloom=0.25, Saturation=0.12, Contrast=0.12},
        ["Sakura"]={Brightness=1.6, ClockTime=16, Ambient={175,105,150}, OutdoorAmbient={90,50,95}, FogColor={240,150,195}, FogEnd=1100, ExposureCompensation=0.1, Bloom=0.25, Saturation=0.15, Contrast=0.08},
        ["Blossom"]={Brightness=1.7, ClockTime=14, Ambient={190,125,165}, OutdoorAmbient={105,65,115}, FogColor={255,175,210}, FogEnd=1200, ExposureCompensation=0.1, Bloom=0.25, Saturation=0.12, Contrast=0.05},
        ["Rose Gold"]={Brightness=1.5, ClockTime=17, Ambient={165,105,105}, OutdoorAmbient={85,45,50}, FogColor={220,145,135}, FogEnd=1000, ExposureCompensation=0.05, Bloom=0.25, Saturation=0.1, Contrast=0.1},
        ["Candy"]={Brightness=1.8, ClockTime=14, Ambient={150,125,190}, OutdoorAmbient={95,70,135}, FogColor={220,170,245}, FogEnd=1200, ExposureCompensation=0.1, Bloom=0.35, Saturation=0.18, Contrast=0.05},
        ["Cotton Candy"]={Brightness=1.9, ClockTime=15, Ambient={135,165,205}, OutdoorAmbient={80,105,160}, FogColor={230,185,245}, FogEnd=1300, ExposureCompensation=0.1, Bloom=0.3, Saturation=0.15, Contrast=0.05},
        ["Sunset"]={Brightness=1.7, ClockTime=18, Ambient={180,100,70}, OutdoorAmbient={95,45,35}, FogColor={245,125,75}, FogEnd=1000, ExposureCompensation=0.1, Bloom=0.3, Saturation=0.15, Contrast=0.1},
        ["Golden Hour"]={Brightness=1.8, ClockTime=16, Ambient={175,145,80}, OutdoorAmbient={100,75,35}, FogColor={245,195,95}, FogEnd=1200, ExposureCompensation=0.1, Bloom=0.25, Saturation=0.12, Contrast=0.05},
        ["Desert"]={Brightness=1.5, ClockTime=14, Ambient={160,125,85}, OutdoorAmbient={100,75,45}, FogColor={215,165,105}, FogEnd=800, ExposureCompensation=0.05, Bloom=0.15, Saturation=0.08, Contrast=0.08},
        ["Sandstorm"]={Brightness=1.2, ClockTime=15, Ambient={130,95,65}, OutdoorAmbient={70,45,25}, FogColor={180,120,75}, FogEnd=500, ExposureCompensation=-0.05, Bloom=0.2, Saturation=0.12, Contrast=0.12},
        ["Volcano"]={Brightness=1.3, ClockTime=20, Ambient={120,45,25}, OutdoorAmbient={50,15,10}, FogColor={190,55,20}, FogEnd=700, ExposureCompensation=-0.1, Bloom=0.35, Saturation=0.2, Contrast=0.2},
        ["Magma"]={Brightness=1.1, ClockTime=1, Ambient={85,25,20}, OutdoorAmbient={25,5,5}, FogColor={150,35,15}, FogEnd=600, ExposureCompensation=-0.15, Bloom=0.3, Saturation=0.2, Contrast=0.2},
        ["Ocean"]={Brightness=1.5, ClockTime=12, Ambient={45,110,145}, OutdoorAmbient={20,65,95}, FogColor={65,160,195}, FogEnd=1200, ExposureCompensation=0.05, Bloom=0.25, Saturation=0.15, Contrast=0.08},
        ["Deep Ocean"]={Brightness=1.1, ClockTime=2, Ambient={20,55,95}, OutdoorAmbient={5,20,45}, FogColor={25,80,135}, FogEnd=850, ExposureCompensation=-0.1, Bloom=0.25, Saturation=0.18, Contrast=0.15},
        ["Tropical"]={Brightness=1.8, ClockTime=13, Ambient={75,155,130}, OutdoorAmbient={35,95,70}, FogColor={90,200,170}, FogEnd=1300, ExposureCompensation=0.1, Bloom=0.25, Saturation=0.1, Contrast=0.05},
        ["Beach"]={Brightness=1.8, ClockTime=15, Ambient={180,165,120}, OutdoorAmbient={110,100,65}, FogColor={245,220,165}, FogEnd=1400, ExposureCompensation=0.1, Bloom=0.2, Saturation=0.08, Contrast=0.03},
        ["Storm"]={Brightness=0.9, ClockTime=17, Ambient={65,75,90}, OutdoorAmbient={25,30,40}, FogColor={85,100,120}, FogEnd=450, ExposureCompensation=-0.2, Bloom=0.1, Saturation=0.1, Contrast=0.15},
        ["Thunder"]={Brightness=0.7, ClockTime=20, Ambient={40,50,70}, OutdoorAmbient={15,20,30}, FogColor={55,70,95}, FogEnd=350, ExposureCompensation=-0.25, Bloom=0.15, Saturation=0.15, Contrast=0.2},
        ["Foggy"]={Brightness=1.0, ClockTime=11, Ambient={120,125,135}, OutdoorAmbient={75,80,90}, FogColor={175,180,190}, FogEnd=280, ExposureCompensation=-0.05, Bloom=0.1, Saturation=0.05, Contrast=0.05},
        ["Mystic Fog"]={Brightness=0.9, ClockTime=7, Ambient={90,100,120}, OutdoorAmbient={45,55,75}, FogColor={130,145,170}, FogEnd=220, ExposureCompensation=-0.1, Bloom=0.12, Saturation=0.08, Contrast=0.08},
        ["Haunted"]={Brightness=0.7, ClockTime=0, Ambient={65,55,80}, OutdoorAmbient={20,15,30}, FogColor={100,70,120}, FogEnd=500, ExposureCompensation=-0.2, Bloom=0.2, Saturation=0.12, Contrast=0.15},
        ["Halloween"]={Brightness=1.0, ClockTime=20, Ambient={125,65,35}, OutdoorAmbient={45,20,15}, FogColor={190,85,35}, FogEnd=700, ExposureCompensation=-0.1, Bloom=0.3, Saturation=0.2, Contrast=0.15},
        ["Blood Moon"]={Brightness=0.6, ClockTime=0, Ambient={90,20,35}, OutdoorAmbient={25,5,15}, FogColor={125,15,30}, FogEnd=500, ExposureCompensation=-0.2, Bloom=0.25, Saturation=0.2, Contrast=0.2},
        ["Ghost Blue"]={Brightness=1.1, ClockTime=2, Ambient={65,110,145}, OutdoorAmbient={25,45,75}, FogColor={100,170,210}, FogEnd=850, ExposureCompensation=-0.05, Bloom=0.2, Saturation=0.12, Contrast=0.1},
        ["Silver Moon"]={Brightness=1.0, ClockTime=23, Ambient={110,115,130}, OutdoorAmbient={45,50,65}, FogColor={155,160,180}, FogEnd=950, ExposureCompensation=-0.05, Bloom=0.15, Saturation=0.08, Contrast=0.08},
        ["Dark Matter"]={Brightness=0.5, ClockTime=0, Ambient={25,25,35}, OutdoorAmbient={8,8,15}, FogColor={35,35,50}, FogEnd=500, ExposureCompensation=-0.25, Bloom=0.15, Saturation=0.15, Contrast=0.2},
        ["Classic"]={Brightness=2, ClockTime=14, Ambient={128,128,128}, OutdoorAmbient={128,128,128}, FogColor={192,192,192}, FogEnd=100000, ExposureCompensation=0, Bloom=0, Saturation=0, Contrast=0},
        ["Vintage"]={Brightness=1.4, ClockTime=15, Ambient={145,120,85}, OutdoorAmbient={90,70,45}, FogColor={190,155,110}, FogEnd=1200, ExposureCompensation=-0.05, Bloom=0.1, Saturation=-0.15, Contrast=0.08},
        ["Sepia"]={Brightness=1.3, ClockTime=14, Ambient={140,115,80}, OutdoorAmbient={85,65,40}, FogColor={180,145,100}, FogEnd=1000, ExposureCompensation=-0.05, Bloom=0.1, Saturation=-0.2, Contrast=0.1},
        ["Monochrome"]={Brightness=1.2, ClockTime=14, Ambient={100,100,100}, OutdoorAmbient={55,55,55}, FogColor={150,150,150}, FogEnd=1200, ExposureCompensation=0, Bloom=0.15, Saturation=-1, Contrast=0.1},
        ["Soft Pastel"]={Brightness=1.9, ClockTime=14, Ambient={175,175,195}, OutdoorAmbient={120,120,150}, FogColor={220,215,240}, FogEnd=1500, ExposureCompensation=0.1, Bloom=0.15, Saturation=0.05, Contrast=-0.05},
        ["Dreamy"]={Brightness=1.7, ClockTime=17, Ambient={140,125,180}, OutdoorAmbient={75,65,110}, FogColor={195,165,230}, FogEnd=1300, ExposureCompensation=0.1, Bloom=0.35, Saturation=0.12, Contrast=0.02},
        ["Heavenly"]={Brightness=2, ClockTime=11, Ambient={180,190,215}, OutdoorAmbient={125,140,175}, FogColor={230,235,255}, FogEnd=1800, ExposureCompensation=0.15, Bloom=0.25, Saturation=0.1, Contrast=-0.03},
        ["Celestial"]={Brightness=1.5, ClockTime=23, Ambient={85,95,150}, OutdoorAmbient={35,40,90}, FogColor={130,140,220}, FogEnd=1400, ExposureCompensation=0.05, Bloom=0.35, Saturation=0.18, Contrast=0.12},
        ["Fairy Garden"]={Brightness=1.8, ClockTime=10, Ambient={130,175,125}, OutdoorAmbient={70,115,65}, FogColor={190,230,155}, FogEnd=1300, ExposureCompensation=0.1, Bloom=0.25, Saturation=0.1, Contrast=0.03},
        ["Magic Hour"]={Brightness=1.7, ClockTime=17, Ambient={155,105,145}, OutdoorAmbient={80,45,85}, FogColor={220,145,190}, FogEnd=1200, ExposureCompensation=0.1, Bloom=0.3, Saturation=0.15, Contrast=0.08},
        ["New Year"]={Brightness=1.8, ClockTime=19, Ambient={125,145,190}, OutdoorAmbient={55,65,105}, FogColor={175,195,240}, FogEnd=1500, ExposureCompensation=0.1, Bloom=0.3, Saturation=0.15, Contrast=0.08},
        ["Winter Night"]={Brightness=1.0, ClockTime=1, Ambient={85,105,145}, OutdoorAmbient={30,45,75}, FogColor={140,170,210}, FogEnd=700, ExposureCompensation=-0.1, Bloom=0.2, Saturation=0.1, Contrast=0.1},
        ["Snowfall"]={Brightness=1.7, ClockTime=12, Ambient={155,175,195}, OutdoorAmbient={100,125,155}, FogColor={220,235,255}, FogEnd=1100, ExposureCompensation=0.05, Bloom=0.2, Saturation=0.05, Contrast=0.03},
        ["Frozen Lake"]={Brightness=1.3, ClockTime=9, Ambient={100,145,175}, OutdoorAmbient={45,80,110}, FogColor={160,210,235}, FogEnd=900, ExposureCompensation=-0.05, Bloom=0.25, Saturation=0.1, Contrast=0.08},
        ["Holiday Lights"]={Brightness=1.6, ClockTime=18, Ambient={155,115,85}, OutdoorAmbient={75,45,35}, FogColor={225,165,95}, FogEnd=1200, ExposureCompensation=0.05, Bloom=0.3, Saturation=0.18, Contrast=0.08},
        ["Spring"]={Brightness=1.8, ClockTime=10, Ambient={130,170,110}, OutdoorAmbient={65,110,55}, FogColor={195,230,155}, FogEnd=1500, ExposureCompensation=0.1, Bloom=0.2, Saturation=0.08, Contrast=0.03},
        ["Summer"]={Brightness=2, ClockTime=14, Ambient={160,165,115}, OutdoorAmbient={100,110,60}, FogColor={240,220,145}, FogEnd=1800, ExposureCompensation=0.15, Bloom=0.2, Saturation=0.08, Contrast=0},
        ["Autumn"]={Brightness=1.4, ClockTime=16, Ambient={155,95,55}, OutdoorAmbient={80,45,25}, FogColor={205,125,65}, FogEnd=1100, ExposureCompensation=0, Bloom=0.25, Saturation=0.12, Contrast=0.1},
        ["Rainy Day"]={Brightness=1.0, ClockTime=8, Ambient={85,105,125}, OutdoorAmbient={40,55,75}, FogColor={125,150,175}, FogEnd=550, ExposureCompensation=-0.1, Bloom=0.12, Saturation=0.05, Contrast=0.1},
        ["Midnight"]={Brightness=0.6, ClockTime=0, Ambient={30,35,65}, OutdoorAmbient={10,12,30}, FogColor={45,50,95}, FogEnd=450, ExposureCompensation=-0.2, Bloom=0.15, Saturation=0.12, Contrast=0.18},
    -- DaDa 30 additional visual themes
        ['Cherry Blossom']={Brightness=1.6, ClockTime=16, Ambient={185,95,145}, OutdoorAmbient={95,35,75}, FogColor={245,150,195}, FogEnd=1150, ExposureCompensation=0, Bloom=0.28, Saturation=0.16, Contrast=0.08},
        ['Ice Crystal']={Brightness=1.7, ClockTime=13, Ambient={130,195,235}, OutdoorAmbient={55,105,155}, FogColor={180,235,255}, FogEnd=1300, ExposureCompensation=0, Bloom=0.28, Saturation=0.08, Contrast=0.12},
        ['Electric Blue']={Brightness=1.3, ClockTime=21, Ambient={35,105,210}, OutdoorAmbient={10,25,90}, FogColor={40,135,255}, FogEnd=900, ExposureCompensation=0, Bloom=0.42, Saturation=0.28, Contrast=0.18},
        ['Lava Flow']={Brightness=1.1, ClockTime=20, Ambient={150,45,20}, OutdoorAmbient={45,10,5}, FogColor={255,85,20}, FogEnd=650, ExposureCompensation=0, Bloom=0.36, Saturation=0.22, Contrast=0.18},
        ['Mint Glow']={Brightness=1.7, ClockTime=14, Ambient={100,205,165}, OutdoorAmbient={35,105,90}, FogColor={130,255,205}, FogEnd=1250, ExposureCompensation=0, Bloom=0.25, Saturation=0.12, Contrast=0.06},
        ['Royal Gold']={Brightness=1.6, ClockTime=17, Ambient={175,130,55}, OutdoorAmbient={80,50,20}, FogColor={255,205,90}, FogEnd=1100, ExposureCompensation=0, Bloom=0.26, Saturation=0.12, Contrast=0.08},
        ['Ocean Pearl']={Brightness=1.6, ClockTime=12, Ambient={100,165,190}, OutdoorAmbient={35,75,100}, FogColor={160,220,235}, FogEnd=1400, ExposureCompensation=0, Bloom=0.22, Saturation=0.1, Contrast=0.04},
        ['Plum Night']={Brightness=0.9, ClockTime=0, Ambient={100,45,115}, OutdoorAmbient={35,10,45}, FogColor={160,75,180}, FogEnd=800, ExposureCompensation=0, Bloom=0.24, Saturation=0.16, Contrast=0.16},
        ['Polar Night']={Brightness=0.9, ClockTime=23, Ambient={65,95,145}, OutdoorAmbient={15,25,55}, FogColor={90,145,210}, FogEnd=850, ExposureCompensation=0, Bloom=0.18, Saturation=0.12, Contrast=0.14},
        ['Lavender Sky']={Brightness=1.7, ClockTime=16, Ambient={165,145,205}, OutdoorAmbient={80,65,125}, FogColor={205,180,245}, FogEnd=1350, ExposureCompensation=0, Bloom=0.26, Saturation=0.1, Contrast=0.04},
        ['Coral Reef']={Brightness=1.7, ClockTime=13, Ambient={205,105,85}, OutdoorAmbient={100,40,45}, FogColor={255,145,125}, FogEnd=1250, ExposureCompensation=0, Bloom=0.25, Saturation=0.16, Contrast=0.05},
        ['Lime Circuit']={Brightness=1.4, ClockTime=12, Ambient={100,165,35}, OutdoorAmbient={25,65,10}, FogColor={165,255,50}, FogEnd=850, ExposureCompensation=0, Bloom=0.4, Saturation=0.24, Contrast=0.16},
        ['Blue Hour']={Brightness=1.2, ClockTime=19, Ambient={70,105,160}, OutdoorAmbient={25,45,90}, FogColor={105,150,220}, FogEnd=1000, ExposureCompensation=0, Bloom=0.2, Saturation=0.1, Contrast=0.12},
        ['Rose Storm']={Brightness=0.9, ClockTime=20, Ambient={150,75,105}, OutdoorAmbient={65,25,50}, FogColor={220,110,155}, FogEnd=650, ExposureCompensation=0, Bloom=0.26, Saturation=0.18, Contrast=0.14},
        ['Silver Frost']={Brightness=1.5, ClockTime=14, Ambient={145,160,180}, OutdoorAmbient={60,70,90}, FogColor={210,225,245}, FogEnd=1400, ExposureCompensation=0, Bloom=0.18, Saturation=0.04, Contrast=0.08},
        ['Amber Dusk']={Brightness=1.4, ClockTime=18, Ambient={175,105,45}, OutdoorAmbient={80,35,15}, FogColor={245,155,65}, FogEnd=950, ExposureCompensation=0, Bloom=0.22, Saturation=0.12, Contrast=0.08},
        ['Galaxy Pink']={Brightness=1.1, ClockTime=23, Ambient={145,55,145}, OutdoorAmbient={45,15,65}, FogColor={230,75,200}, FogEnd=1200, ExposureCompensation=0, Bloom=0.42, Saturation=0.24, Contrast=0.2},
        ['Deep Teal']={Brightness=1.2, ClockTime=2, Ambient={35,115,120}, OutdoorAmbient={10,35,50}, FogColor={45,165,170}, FogEnd=900, ExposureCompensation=0, Bloom=0.24, Saturation=0.16, Contrast=0.12},
        ['Misty Pine']={Brightness=1.1, ClockTime=8, Ambient={95,125,105}, OutdoorAmbient={35,55,45}, FogColor={135,165,135}, FogEnd=500, ExposureCompensation=0, Bloom=0.14, Saturation=0.08, Contrast=0.06},
        ['Whiteout']={Brightness=1.8, ClockTime=13, Ambient={205,215,225}, OutdoorAmbient={145,155,170}, FogColor={235,245,255}, FogEnd=500, ExposureCompensation=0, Bloom=0.15, Saturation=0.02, Contrast=0.02},
        ['Night Drive']={Brightness=0.8, ClockTime=22, Ambient={35,45,75}, OutdoorAmbient={8,10,25}, FogColor={70,90,150}, FogEnd=750, ExposureCompensation=0, Bloom=0.32, Saturation=0.22, Contrast=0.18},
        ['Prism']={Brightness=1.6, ClockTime=15, Ambient={130,105,165}, OutdoorAmbient={45,35,75}, FogColor={185,150,220}, FogEnd=1100, ExposureCompensation=0, Bloom=0.35, Saturation=0.22, Contrast=0.1},
        ['Peach Glow']={Brightness=1.8, ClockTime=16, Ambient={210,145,115}, OutdoorAmbient={110,65,50}, FogColor={255,190,150}, FogEnd=1300, ExposureCompensation=0, Bloom=0.22, Saturation=0.12, Contrast=0.03},
        ['Rainforest']={Brightness=1.2, ClockTime=10, Ambient={45,110,75}, OutdoorAmbient={15,45,30}, FogColor={70,155,100}, FogEnd=650, ExposureCompensation=0, Bloom=0.18, Saturation=0.1, Contrast=0.08},
        ['Blue Lagoon']={Brightness=1.7, ClockTime=13, Ambient={60,145,175}, OutdoorAmbient={15,65,100}, FogColor={85,200,230}, FogEnd=1350, ExposureCompensation=0, Bloom=0.28, Saturation=0.14, Contrast=0.05},
        ['Dark Cherry']={Brightness=0.7, ClockTime=1, Ambient={100,20,45}, OutdoorAmbient={30,5,15}, FogColor={160,30,65}, FogEnd=600, ExposureCompensation=0, Bloom=0.22, Saturation=0.14, Contrast=0.18},
        ['Sunrise Mist']={Brightness=1.6, ClockTime=6, Ambient={190,125,105}, OutdoorAmbient={90,65,75}, FogColor={255,175,140}, FogEnd=1200, ExposureCompensation=0, Bloom=0.22, Saturation=0.1, Contrast=0.04},
        ['Cosmic Gold']={Brightness=1.2, ClockTime=23, Ambient={145,110,50}, OutdoorAmbient={50,35,20}, FogColor={220,175,75}, FogEnd=1000, ExposureCompensation=0, Bloom=0.3, Saturation=0.18, Contrast=0.15},
        ['Cyan Pulse']={Brightness=1.4, ClockTime=18, Ambient={40,145,155}, OutdoorAmbient={10,45,65}, FogColor={50,220,230}, FogEnd=900, ExposureCompensation=0, Bloom=0.42, Saturation=0.25, Contrast=0.14},
        ['Velvet Purple']={Brightness=1.1, ClockTime=20, Ambient={95,55,135}, OutdoorAmbient={30,15,55}, FogColor={145,90,195}, FogEnd=850, ExposureCompensation=0, Bloom=0.3, Saturation=0.18, Contrast=0.15},
    }
    local activeVisualPreset = nil
    local function applyVisualPreset(name)
        local p = DADA_VISUAL_PRESETS[name]
        if not p then return false end
        activeVisualPreset = name
        SHF.visual_preset = name
        SHF.custom_visual_preset = true
        local function rgb(t) return Color3.fromRGB(t[1], t[2], t[3]) end
        local function ensureEffect(name, className)
            local e = Lighting:FindFirstChild("DaDaPreset_" .. name)
            if not e or not e:IsA(className) then
                if e then e:Destroy() end
                e = Instance.new(className)
                e.Name = "DaDaPreset_" .. name
                e.Parent = Lighting
            end
            return e
        end
        local function apply()
            if not activeVisualPreset then return end
            local q = DADA_VISUAL_PRESETS[activeVisualPreset]
            if not q then return end
            Lighting.Brightness = q.Brightness
            Lighting.ClockTime = q.ClockTime
            Lighting.Ambient = rgb(q.Ambient)
            Lighting.OutdoorAmbient = rgb(q.OutdoorAmbient)
            Lighting.FogColor = rgb(q.FogColor)
            Lighting.FogStart = 0
            Lighting.FogEnd = q.FogEnd
            Lighting.ExposureCompensation = q.ExposureCompensation
            local bloom = ensureEffect("Bloom", "BloomEffect")
            bloom.Intensity = q.Bloom; bloom.Size = 24; bloom.Threshold = 1.1; bloom.Enabled = q.Bloom > 0
            local cc = ensureEffect("ColorCorrection", "ColorCorrectionEffect")
            cc.Saturation = q.Saturation; cc.Contrast = q.Contrast; cc.Brightness = 0
            cc.TintColor = Color3.new(1, 1, 1); cc.Enabled = q.Saturation ~= 0 or q.Contrast ~= 0
        end
        SHF.applyVisualPreset = applyVisualPreset
        apply()
        return true
    end
    SHF.applyVisualPreset = applyVisualPreset
    SHF.clearVisualPreset = function()
        activeVisualPreset = nil
        SHF.visual_preset = "Off"
        SHF.custom_visual_preset = false
        for _, name in ipairs({"Bloom", "ColorCorrection"}) do
            local e = Lighting:FindFirstChild("DaDaPreset_" .. name)
            if e then pcall(function() e:Destroy() end) end
        end
        Lighting.Brightness = fb_orig.Brightness
        Lighting.ClockTime = fb_orig.ClockTime
        Lighting.Ambient = fb_orig.Ambient
        Lighting.OutdoorAmbient = fb_orig.OutdoorAmbient
        Lighting.FogColor = fb_orig.FogColor
        Lighting.FogStart = fb_orig.FogStart
        Lighting.FogEnd = fb_orig.FogEnd
        Lighting.ExposureCompensation = fb_orig.ExposureCompensation
    end
    RunService.Heartbeat:Connect(function()
        if activeVisualPreset then
            local p = DADA_VISUAL_PRESETS[activeVisualPreset]
            if p then
                Lighting.Brightness = p.Brightness; Lighting.ClockTime = p.ClockTime
                Lighting.Ambient = Color3.fromRGB(p.Ambient[1], p.Ambient[2], p.Ambient[3])
                Lighting.OutdoorAmbient = Color3.fromRGB(p.OutdoorAmbient[1], p.OutdoorAmbient[2], p.OutdoorAmbient[3])
                Lighting.FogColor = Color3.fromRGB(p.FogColor[1], p.FogColor[2], p.FogColor[3])
                Lighting.FogStart = 0; Lighting.FogEnd = p.FogEnd
                Lighting.ExposureCompensation = p.ExposureCompensation
                local b = Lighting:FindFirstChild("DaDaPreset_Bloom")
                if b and b:IsA("BloomEffect") then b.Intensity=p.Bloom; b.Size=24; b.Threshold=1.1; b.Enabled=p.Bloom>0 end
                local c = Lighting:FindFirstChild("DaDaPreset_ColorCorrection")
                if c and c:IsA("ColorCorrectionEffect") then c.Saturation=p.Saturation; c.Contrast=p.Contrast; c.Brightness=0; c.Enabled=(p.Saturation~=0 or p.Contrast~=0) end
            end
        end
    end)

    RunService.Stepped:Connect(function()
        if ST.fullbright then
            Lighting.Brightness=3
            Lighting.ClockTime=14
            Lighting.GlobalShadows=false
            Lighting.OutdoorAmbient=Color3.fromRGB(200,200,200)
        else
            if Lighting.Brightness~=fb_orig.Brightness and not SHF.shaders and not SHF.custom_visual_preset then Lighting.Brightness=fb_orig.Brightness end
            if Lighting.ClockTime~=fb_orig.ClockTime and not SHF.shaders and not SHF.custom_visual_preset then Lighting.ClockTime=fb_orig.ClockTime end
            if Lighting.GlobalShadows~=fb_orig.GlobalShadows and not SHF.shaders and not SHF.custom_visual_preset then Lighting.GlobalShadows=fb_orig.GlobalShadows end
            if Lighting.OutdoorAmbient~=fb_orig.OutdoorAmbient and not SHF.shaders and not SHF.custom_visual_preset then Lighting.OutdoorAmbient=fb_orig.OutdoorAmbient end
        end
    end)
    local first_fov=true; local orig_fov=70
    RunService.RenderStepped:Connect(function()
        local c=workspace.CurrentCamera
        if not c then return end
        if first_fov then orig_fov=c.FieldOfView; first_fov=false end
        if ST.fov_changer then
            if c.FieldOfView~=ST.fov_value then c.FieldOfView=ST.fov_value end
        elseif c.FieldOfView~=orig_fov then
            c.FieldOfView=orig_fov
        end
    end)
    RunService.Stepped:Connect(function()
        if ST.world_color then
            Lighting.Ambient=ST.world_color_val
            Lighting.OutdoorAmbient=ST.world_color_val
        elseif Lighting.Ambient~=fb_orig.Ambient and not SHF.shaders and not SHF.custom_visual_preset then
            Lighting.Ambient=fb_orig.Ambient
        end
    end)
    local current_sky=nil
    local original_skies={}
    for _,obj in ipairs(Lighting:GetChildren()) do
        if obj:IsA("Sky") then
            local ok,copy=pcall(function() return obj:Clone() end)
            if ok and copy then table.insert(original_skies,copy) end
        end
    end
    local function restoreOriginalSky()
        for _,obj in ipairs(Lighting:GetChildren()) do
            if obj:IsA("Sky") then pcall(function() obj:Destroy() end) end
        end
        current_sky=nil
        for _,copy in ipairs(original_skies) do
            pcall(function() copy:Clone().Parent=Lighting end)
        end
    end
    local SKYBOXES={
        ["Default"]=nil,
        ["Space"]={Bk="rbxassetid://166509999",Dn="rbxassetid://166510057",Ft="rbxassetid://166510116",Lf="rbxassetid://166510092",Rt="rbxassetid://166510131",Up="rbxassetid://166510114"},
        ["Red"]={Bk="rbxassetid://401664839",Dn="rbxassetid://401664862",Ft="rbxassetid://401664960",Lf="rbxassetid://401664881",Rt="rbxassetid://401664901",Up="rbxassetid://401664936"},
        ["Purple"]={Bk="rbxassetid://13694952867",Dn="rbxassetid://13694968325",Ft="rbxassetid://13694980654",Lf="rbxassetid://13694998113",Rt="rbxassetid://13695002700",Up="rbxassetid://13695007103"},
    }
    getgenv().DaDa_apply_skybox = function(name)
        if current_sky then pcall(function() current_sky:Destroy() end); current_sky=nil end
        if not SKYBOXES[name] then
            restoreOriginalSky()
            return
        end
        for _,obj in ipairs(Lighting:GetChildren()) do
            if obj:IsA("Sky") then pcall(function() obj:Destroy() end) end
        end
        local def=SKYBOXES[name]
        local sky=Instance.new("Sky")
        sky.Name="DaDaCustomSky"
        for k,v in pairs(def) do pcall(function() sky[k]=v end) end
        sky.Parent=Lighting
        current_sky=sky
    end
    RunService.Stepped:Connect(function()
        local char=LP.Character
        if not char then return end
        for _,p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") and p.Name~="HumanoidRootPart" then
                if ST.char_transparency then
                    p.LocalTransparencyModifier=ST.char_trans_val
                else
                    p.LocalTransparencyModifier=0
                end
            end
        end
    end)
    UIS.InputBegan:Connect(function(input,gpe)
        if gpe then return end
        if input.KeyCode==Enum.KeyCode.K then
            local hum=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.Health=0 end
        end
    end)

    local SHADERS={
        morning={Amb=Color3.fromRGB(10,10,10),Br=1.5,CT=7.5,OA=Color3.fromRGB(10,10,10),Ex=0.3,GS=true},
        midday={Amb=Color3.fromRGB(2,2,2),Br=3.25,CT=8,OA=Color3.fromRGB(51,54,67),Ex=0.85,GS=true},
        evening={Amb=Color3.fromRGB(2,2,2),Br=2.25,CT=16,OA=Color3.fromRGB(0,0,0),Ex=0.65,GS=true},
        night={Amb=Color3.fromRGB(33,33,33),Br=3.25,CT=20,OA=Color3.fromRGB(51,54,67),Ex=0.85,GS=true},
    }
    local function applyShader(d)
        if not d then return end
        Lighting.Ambient=d.Amb
        Lighting.Brightness=d.Br
        Lighting.ClockTime=d.CT
        Lighting.OutdoorAmbient=d.OA
        Lighting.ExposureCompensation=d.Ex
        Lighting.GlobalShadows=d.GS
    end
    local function restoreShader()
        Lighting.Ambient=fb_orig.Ambient
        Lighting.Brightness=fb_orig.Brightness
        Lighting.ClockTime=fb_orig.ClockTime
        Lighting.OutdoorAmbient=fb_orig.OutdoorAmbient
        Lighting.ExposureCompensation=fb_orig.ExposureCompensation
        Lighting.GlobalShadows=fb_orig.GlobalShadows
    end
    SHF.applyShader=applyShader
    SHF.restoreShader=restoreShader
    SHF.shaders_table=SHADERS
    RunService.Heartbeat:Connect(function()
        if SHF.shaders then
            local d=SHADERS[SHF.shader_type]
            if d then applyShader(d) end
        end
    end)

    RunService.Stepped:Connect(function()
        if SHF.fog then
            Lighting.FogColor=SHF.fog_color
            Lighting.FogStart=SHF.fog_start
            Lighting.FogEnd=SHF.fog_end
        else
            if Lighting.FogColor~=fb_orig.FogColor and not SHF.shaders and not SHF.custom_visual_preset then Lighting.FogColor=fb_orig.FogColor end
            if Lighting.FogStart~=fb_orig.FogStart and not SHF.shaders and not SHF.custom_visual_preset then Lighting.FogStart=fb_orig.FogStart end
            if Lighting.FogEnd~=fb_orig.FogEnd and not SHF.shaders and not ST.fullbright and not SHF.custom_visual_preset then Lighting.FogEnd=fb_orig.FogEnd end
        end
    end)

    RunService.Stepped:Connect(function()
        if SHF.ambient then
            Lighting.Ambient=SHF.ambient_col
            Lighting.OutdoorAmbient=SHF.ambient_col
        elseif Lighting.Ambient~=fb_orig.Ambient and not ST.fullbright and not SHF.shaders and not SHF.custom_visual_preset then
            Lighting.Ambient=fb_orig.Ambient
            Lighting.OutdoorAmbient=fb_orig.OutdoorAmbient
        end
    end)

    RunService.Stepped:Connect(function()
        if SHF.exposure then
            if Lighting.ExposureCompensation~=SHF.exposure_val then Lighting.ExposureCompensation=SHF.exposure_val end
        elseif Lighting.ExposureCompensation~=fb_orig.ExposureCompensation and not SHF.shaders and not SHF.custom_visual_preset then
            Lighting.ExposureCompensation=fb_orig.ExposureCompensation
        end
    end)

    local PREM={
        Jungle={Bk="rbxassetid://214399891",Dn="rbxassetid://214399887",Ft="rbxassetid://214399894",Lf="rbxassetid://214405668",Rt="rbxassetid://214399899",Up="rbxassetid://214399889"},
        Blossom={Bk="rbxassetid://271042516",Dn="rbxassetid://271077243",Ft="rbxassetid://271042556",Lf="rbxassetid://271042310",Rt="rbxassetid://271042467",Up="rbxassetid://271077958"},
        RedNight={Bk="rbxassetid://401664839",Dn="rbxassetid://401664862",Ft="rbxassetid://401664960",Lf="rbxassetid://401664881",Rt="rbxassetid://401664901",Up="rbxassetid://401664936"},
        Purple={Bk="rbxassetid://13694952867",Dn="rbxassetid://13694968325",Ft="rbxassetid://13694980654",Lf="rbxassetid://13694998113",Rt="rbxassetid://13695002700",Up="rbxassetid://13695007103"},
        Foggy={Bk="rbxassetid://1370717244",Dn="rbxassetid://1370717336",Ft="rbxassetid://1370717438",Lf="rbxassetid://1370717567",Rt="rbxassetid://1370717698",Up="rbxassetid://1370717782"},
    }
    local prem_sky_inst=nil
    local function applyPremSky(name)
        if prem_sky_inst then pcall(function() prem_sky_inst:Destroy() end); prem_sky_inst=nil end
        local d=PREM[name]
        if not d then return end
        for _,obj in ipairs(Lighting:GetChildren()) do
            if obj:IsA("Sky") then pcall(function() obj:Destroy() end) end
        end
        local s=Instance.new("Sky")
        s.Name="DaDaPremiumSky"
        for k,v in pairs(d) do pcall(function() s[k]=v end) end
        s.Parent=Lighting
        prem_sky_inst=s
    end
    local function clearPremSky()
        if prem_sky_inst then pcall(function() prem_sky_inst:Destroy() end); prem_sky_inst=nil end
        if getgenv().DaDa_apply_skybox then
            local selected=ST.skybox or "Default"
            getgenv().DaDa_apply_skybox(selected)
        else
            restoreOriginalSky()
        end
    end
    SHF.applyPremSky=applyPremSky
    SHF.clearPremSky=clearPremSky
    RunService.Heartbeat:Connect(function()
        if SHF.prem_skybox then
            local n=SHF.prem_skybox_name
            if prem_sky_inst and prem_sky_inst.Parent and prem_sky_inst.Name~=n then
                applyPremSky(n)
            elseif not prem_sky_inst then
                applyPremSky(n)
            end
        else
            if prem_sky_inst then clearPremSky() end
        end
    end)

    local fx_part=Instance.new("Part")
    fx_part.Name="DaDaWorldFX"
    fx_part.Anchored=true
    fx_part.CanCollide=false
    fx_part.CanQuery=false
    fx_part.CanTouch=false
    fx_part.Transparency=1
    fx_part.Size=Vector3.new(260,140,260)
    local fx_emitter=Instance.new("ParticleEmitter")
    fx_emitter.Parent=fx_part
    local function styleFX(t)
        pcall(function() fx_emitter.Texture="rbxasset://textures/particles/smoke_main.dds" end)
        fx_emitter.LightInfluence=0
        fx_emitter.LightEmission=0.4
        fx_emitter.Rate=SHF.world_fx_rate
        fx_emitter.Color=ColorSequence.new(SHF.world_fx_col)
        fx_emitter.EmissionDirection=Enum.NormalId.Bottom
        if t=="Snow" then
            fx_emitter.Lifetime=NumberRange.new(4,6)
            fx_emitter.Speed=NumberRange.new(6,12)
            fx_emitter.Acceleration=Vector3.new(2,-6,1)
            fx_emitter.SpreadAngle=Vector2.new(35,35)
            fx_emitter.Size=NumberSequence.new(0.55)
            fx_emitter.Transparency=NumberSequence.new({
                NumberSequenceKeypoint.new(0,0.2),
                NumberSequenceKeypoint.new(0.8,0.3),
                NumberSequenceKeypoint.new(1,1)
            })
        else
            fx_emitter.Lifetime=NumberRange.new(5,7)
            fx_emitter.Speed=NumberRange.new(5,10)
            fx_emitter.Acceleration=Vector3.new(4,-5,2)
            fx_emitter.SpreadAngle=Vector2.new(40,40)
            fx_emitter.Size=NumberSequence.new(0.5)
            fx_emitter.Transparency=NumberSequence.new({
                NumberSequenceKeypoint.new(0,0.15),
                NumberSequenceKeypoint.new(0.85,0.25),
                NumberSequenceKeypoint.new(1,1)
            })
        end
    end
    styleFX(SHF.world_fx_type)
    RunService.RenderStepped:Connect(function()
        if not SHF.world_fx then
            if fx_part.Parent then fx_part.Parent=nil end
            return
        end
        if not fx_part.Parent then fx_part.Parent=workspace end
        styleFX(SHF.world_fx_type)
        local cam=workspace.CurrentCamera
        if cam then
            local cf=cam.CFrame
            local d=cf.LookVector
            local flat=Vector3.new(d.X,0,d.Z)
            if flat.Magnitude<0.05 then flat=Vector3.new(0,0,-1) else flat=flat.Unit end
            fx_part.CFrame=CFrame.new(cf.Position+flat*60+Vector3.new(0,40,0))
        end
    end)

    local AURA_PRESETS={
        angel={col=Color3.fromRGB(133,220,255),rate=80,size=0.5,speed=4,lifetime=2},
        wind={col=Color3.fromRGB(180,255,200),rate=60,size=0.6,speed=3,lifetime=2.5},
        starlight={col=Color3.fromRGB(255,255,180),rate=100,size=0.4,speed=2,lifetime=3},
        heavenly={col=Color3.fromRGB(255,220,150),rate=120,size=0.5,speed=5,lifetime=1.8},
        aurora={col=Color3.fromRGB(80,220,255),rate=90,size=0.45,speed=3,lifetime=2.5},
        flame={col=Color3.fromRGB(255,95,30),rate=100,size=0.5,speed=5,lifetime=1.6},
        frost={col=Color3.fromRGB(170,235,255),rate=75,size=0.45,speed=2,lifetime=3},
        rose={col=Color3.fromRGB(255,105,170),rate=85,size=0.5,speed=3,lifetime=2.4},
        void={col=Color3.fromRGB(125,75,200),rate=65,size=0.6,speed=2,lifetime=3},
        emerald={col=Color3.fromRGB(60,255,145),rate=80,size=0.45,speed=3,lifetime=2.2},
        solar={col=Color3.fromRGB(255,200,65),rate=95,size=0.5,speed=4,lifetime=2},
        lunar={col=Color3.fromRGB(190,200,255),rate=70,size=0.45,speed=1,lifetime=3},
        ocean={col=Color3.fromRGB(55,175,255),rate=90,size=0.5,speed=3,lifetime=2.5},
        toxic={col=Color3.fromRGB(170,255,45),rate=80,size=0.55,speed=4,lifetime=2},
        sakura={col=Color3.fromRGB(255,160,205),rate=85,size=0.5,speed=2,lifetime=2.8},
        plasma={col=Color3.fromRGB(255,60,220),rate=110,size=0.45,speed=5,lifetime=1.8},
        storm={col=Color3.fromRGB(130,155,190),rate=70,size=0.55,speed=6,lifetime=1.8},
        ember={col=Color3.fromRGB(255,130,45),rate=75,size=0.45,speed=2,lifetime=2.4},
        crystal={col=Color3.fromRGB(160,245,255),rate=90,size=0.35,speed=2,lifetime=3},
        rainbow={col=Color3.fromRGB(255,255,255),rate=100,size=0.45,speed=3,lifetime=2.5},
        shadow={col=Color3.fromRGB(95,75,125),rate=55,size=0.6,speed=1,lifetime=3},
        mint={col=Color3.fromRGB(110,255,205),rate=75,size=0.45,speed=2,lifetime=2.8},
        coral={col=Color3.fromRGB(255,130,115),rate=80,size=0.5,speed=3,lifetime=2.3},
        gold={col=Color3.fromRGB(255,215,100),rate=95,size=0.45,speed=3,lifetime=2},
        sapphire={col=Color3.fromRGB(65,105,255),rate=90,size=0.45,speed=3,lifetime=2.5},
        amethyst={col=Color3.fromRGB(190,100,255),rate=85,size=0.5,speed=3,lifetime=2.5},
        pearl={col=Color3.fromRGB(235,245,255),rate=65,size=0.4,speed=1,lifetime=3},
        cinder={col=Color3.fromRGB(190,65,35),rate=75,size=0.5,speed=4,lifetime=1.9},
        breeze={col=Color3.fromRGB(175,255,220),rate=55,size=0.4,speed=2,lifetime=3},
        comet={col=Color3.fromRGB(120,190,255),rate=100,size=0.4,speed=7,lifetime=1.5},
        stardust={col=Color3.fromRGB(255,245,175),rate=115,size=0.35,speed=2,lifetime=3},
        aurum={col=Color3.fromRGB(255,175,65),rate=80,size=0.5,speed=4,lifetime=2},
        glacier={col=Color3.fromRGB(125,210,255),rate=80,size=0.45,speed=2,lifetime=3},
        dream={col=Color3.fromRGB(220,145,255),rate=75,size=0.5,speed=2,lifetime=3},
    }
    local aura_inst=nil
    local function clearAura()
        if aura_inst then pcall(function() aura_inst:Destroy() end) aura_inst=nil end
    end
    local function applyAura()
        clearAura()
        local char=LP.Character
        if not char then return end
        local preset=AURA_PRESETS[SHF.aura_type] or AURA_PRESETS.angel
        local part=char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
        if not part then return end
        local att=Instance.new("Attachment")
        att.Parent=part
        local emitter=Instance.new("ParticleEmitter")
        pcall(function() emitter.Texture="rbxasset://textures/particles/sparkles_main.dds" end)
        emitter.Color=ColorSequence.new(SHF.aura_col or preset.col)
        emitter.Rate=preset.rate
        emitter.Lifetime=NumberRange.new(preset.lifetime,preset.lifetime+1)
        emitter.Speed=NumberRange.new(preset.speed,preset.speed+2)
        emitter.Size=NumberSequence.new(preset.size)
        emitter.Transparency=NumberSequence.new({
            NumberSequenceKeypoint.new(0,0.3),
            NumberSequenceKeypoint.new(1,1)
        })
        emitter.LightEmission=1
        emitter.LightInfluence=0
        emitter.Parent=att
        aura_inst=att
    end
    SHF.applyAura=applyAura
    SHF.clearAura=clearAura
    LP.CharacterAdded:Connect(function()
        task.wait(1)
        if SHF.aura then applyAura() end
    end)

    do
        local aura2_ids = {
            angel     = "97658130917593",
            starlight = "134645216613107",
            heavenly  = "139300897520961",
            ribbon    = "132069507632161",
            sakura    = "81755778619404",
            wind      = "80694081850877",
            flow      = "119913533725648",
            star      = "73754563740680"
        }
        local aura2_cache = {}
        local aura2_particles = {}
        local aura2_on = false
        local aura2_type = "angel"
        local aura2_col = Color3.fromRGB(133, 220, 255)
        local aura2_conn = nil

        local function load_aura2(name)
            if aura2_cache[name] then return aura2_cache[name] end
            local id = aura2_ids[name]
            if not id then return nil end
            local ok, objs = pcall(game.GetObjects, game, "rbxassetid://"..id)
            if ok and objs and objs[1] then
                aura2_cache[name] = objs[1]
                return objs[1]
            end
            return nil
        end

        local function color_aura2(model, color)
            local seq = ColorSequence.new(color)
            for _, d in ipairs(model:GetDescendants()) do
                if d:IsA("PointLight") then
                    pcall(function() d.Color = color end)
                elseif d:IsA("ParticleEmitter") or d:IsA("Beam") or d:IsA("Trail") then
                    pcall(function() d.Color = seq end)
                end
            end
        end

        local function clear_aura2()
            for i = #aura2_particles, 1, -1 do
                pcall(function() aura2_particles[i]:Destroy() end)
                aura2_particles[i] = nil
            end
        end

        local function apply_aura2()
            clear_aura2()
            local char = LP.Character
            if not char then return end
            local src = load_aura2(aura2_type)
            if not src then return end
            color_aura2(src, aura2_col)
            local cloned = src:Clone()
            local attached = 0
            for _, part in ipairs(cloned:GetChildren()) do
                local target = char:FindFirstChild(part.Name)
                if not target then
                    for _, d in ipairs(char:GetDescendants()) do
                        if d:IsA("BasePart") and d.Name == part.Name then target = d; break end
                    end
                end
                if target and target:IsA("BasePart") then
                    for _, child in ipairs(part:GetChildren()) do
                        child.Parent = target
                        aura2_particles[#aura2_particles+1] = child
                        attached = attached + 1
                    end
                end
            end
            cloned:Destroy()
        end

        SHF.applyAura2 = function()
            if not aura2_on then return end
            task.spawn(apply_aura2)
        end
        SHF.clearAura2 = clear_aura2

        SHF.aura2Toggle = function(v)
            aura2_on = v
            if v then
                task.spawn(apply_aura2)
                if aura2_conn then pcall(function() aura2_conn:Disconnect() end) end
                aura2_conn = LP.CharacterAdded:Connect(function()
                    task.wait(0.5)
                    if aura2_on then apply_aura2() end
                end)
            else
                if aura2_conn then pcall(function() aura2_conn:Disconnect() end) aura2_conn = nil end
                clear_aura2()
            end
        end

        SHF.aura2Type = function(t)
            aura2_type = t or aura2_type
            if aura2_on then task.spawn(apply_aura2) end
        end

        SHF.aura2Color = function(c)
            aura2_col = c
            for _, m in pairs(aura2_cache) do color_aura2(m, c) end
            if aura2_on then task.spawn(apply_aura2) end
        end

        LP.CharacterAdded:Connect(function()
            task.wait(1)
            if aura2_on then apply_aura2() end
        end)
    end
end
initWorld()

-- ============================================================
-- INIT 12: INVISIBLE (FIXED Decal/Texture) + 20 ФИЧ
-- ============================================================
local function initInvisExtras()
    do
        local orig_parts={}
        local invis_conn=nil
        local invis_char_conn=nil
        local function remember(obj, prop)
            local entry=orig_parts[obj]
            if not entry then entry={}; orig_parts[obj]=entry end
            if entry[prop]==nil then
                local ok,value=pcall(function() return obj[prop] end)
                if ok then entry[prop]=value end
            end
        end
        local function setInvis(mode)
            local char=LP.Character
            if not char then return end
            for _,obj in ipairs(char:GetDescendants()) do
                if obj:IsA("BasePart") and (obj.Name~="HumanoidRootPart" or mode=="Full") then
                    remember(obj,"LocalTransparencyModifier")
                    obj.LocalTransparencyModifier=1
                elseif obj:IsA("Decal") or obj:IsA("Texture") then
                    remember(obj,"Transparency")
                    obj.Transparency=1
                end
            end
            if mode~="Full" then
                local hrp=char:FindFirstChild("HumanoidRootPart")
                local saved=hrp and orig_parts[hrp]
                if saved and saved.LocalTransparencyModifier~=nil then
                    pcall(function() hrp.LocalTransparencyModifier=saved.LocalTransparencyModifier end)
                    saved.LocalTransparencyModifier=nil
                    if next(saved)==nil then orig_parts[hrp]=nil end
                end
            end
        end
        local function clearInvis()
            for obj,props in pairs(orig_parts) do
                if obj and obj.Parent then
                    for prop,value in pairs(props) do
                        pcall(function() obj[prop]=value end)
                    end
                end
            end
            table.clear(orig_parts)
        end
        SHF.setInvis=setInvis
        SHF.clearInvis=clearInvis
        if invis_conn then invis_conn:Disconnect() end
        invis_conn=RunService.Stepped:Connect(function()
            if SHF.invis then setInvis(SHF.invis_mode) else clearInvis() end
        end)
        invis_char_conn=LP.CharacterAdded:Connect(function()
            task.wait(0.5)
            table.clear(orig_parts)
            if SHF.invis then setInvis(SHF.invis_mode) end
        end)
        SHF._invisDisconnect=function()
            if invis_conn then pcall(function() invis_conn:Disconnect() end); invis_conn=nil end
            if invis_char_conn then pcall(function() invis_char_conn:Disconnect() end); invis_char_conn=nil end
            clearInvis()
        end
    end

    do
        local inv2_on = false
        local inv2_conn = nil
        local inv2_char_conn = nil
        local inv2_saved = {}

        local function inv2_apply()
            local char = LP.Character
            if not char then return end
            for _, p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") then
                    if inv2_saved[p] == nil then inv2_saved[p] = {t = p.LocalTransparencyModifier} end
                    p.LocalTransparencyModifier = 1
                elseif p:IsA("Decal") or p:IsA("Texture") then
                    if inv2_saved[p] == nil then inv2_saved[p] = {t = p.Transparency} end
                    p.Transparency = 1
                end
            end
        end

        local function inv2_clear()
            for p, v in pairs(inv2_saved) do
                if p and p.Parent then
                    if v.t ~= nil then pcall(function() p.LocalTransparencyModifier = v.t end) end
                    pcall(function() p.Transparency = v.t end)
                end
            end
            inv2_saved = {}
        end

        local function inv2_loop()
            if not inv2_on then return end
            local char = LP.Character
            if not char then return end
            for _, p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") and p.LocalTransparencyModifier ~= 1 then
                    p.LocalTransparencyModifier = 1
                elseif (p:IsA("Decal") or p:IsA("Texture")) and p.Transparency ~= 1 then
                    p.Transparency = 1
                end
            end
        end

        SHF.invis2Toggle = function(v)
            inv2_on = v
            if v then
                inv2_apply()
                if inv2_conn then pcall(function() inv2_conn:Disconnect() end) end
                inv2_conn = RunService.Stepped:Connect(inv2_loop)
                if not inv2_char_conn then
                    inv2_char_conn = LP.CharacterAdded:Connect(function()
                        task.wait(0.5)
                        if inv2_on then inv2_apply() end
                    end)
                end
            else
                if inv2_conn then pcall(function() inv2_conn:Disconnect() end) inv2_conn = nil end
                inv2_clear()
            end
        end
    end

    do
        local hitboxes={}
        RunService.Heartbeat:Connect(function()
            if not SHF.hitbox then
                for _,e in pairs(hitboxes) do
                    if e.part then pcall(function() e.part:Destroy() end) end
                end
                hitboxes={}
                return
            end
            for _,p in ipairs(Players:GetPlayers()) do
                if p~=LP and p.Character then
                    local hrp=p.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local e=hitboxes[p]
                        if not e then
                            local hb=Instance.new("Part")
                            hb.Size=Vector3.new(SHF.hitbox_size,SHF.hitbox_size,SHF.hitbox_size)
                            hb.Anchored=true
                            hb.CanCollide=false
                            hb.CanQuery=false
                            hb.CanTouch=true
                            hb.Transparency=0.7
                            hb.Material=Enum.Material.ForceField
                            hb.Color=SHF.hitbox_col
                            hb.Parent=workspace
                            e={part=hb}
                            hitboxes[p]=e
                        end
                        if e.part and e.part.Parent then
                            e.part.CFrame=hrp.CFrame
                            e.part.Size=Vector3.new(SHF.hitbox_size,SHF.hitbox_size,SHF.hitbox_size)
                            e.part.Color=SHF.hitbox_col
                        end
                    end
                end
            end
        end)
    end

    RunService.Stepped:Connect(function()
        if not SHF.anti_swap then return end
        local char=LP.Character
        if not char then return end
        local hum=char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        for _,t in ipairs(char:GetChildren()) do
            if t:IsA("Tool") then
                local eq=hum:FindFirstChildOfClass("Tool")
                if eq and eq~=t then pcall(function() t.Parent=char end) end
            end
        end
    end)

    do
        local orig_fdh=workspace.FallenPartsDestroyHeight
        RunService.Stepped:Connect(function()
            if SHF.anti_void then
                if workspace.FallenPartsDestroyHeight~=-9e9 then
                    pcall(function() workspace.FallenPartsDestroyHeight=-9e9 end)
                end
            elseif workspace.FallenPartsDestroyHeight~=orig_fdh then
                pcall(function() workspace.FallenPartsDestroyHeight=orig_fdh end)
            end
        end)
    end

    do
        local VirtualUser=game:GetService("VirtualUser")
        LP.Idled:Connect(function()
            if SHF.anti_afk then
                pcall(function()
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                end)
            end
        end)
    end

    RunService.Heartbeat:Connect(function()
        if not SHF.anti_trap then return end
        local char=LP.Character
        local hum=char and char:FindFirstChildOfClass("Humanoid")
        if hum and hum.WalkSpeed<5 then
            hum.WalkSpeed=32
            hum.JumpPower=80
        end
        local pg=LP:FindFirstChild("PlayerGui")
        if pg then
            local trap=pg:FindFirstChild("TrapGUI")
            if trap then pcall(function() trap:Destroy() end) end
        end
    end)

    LP.CharacterAdded:Connect(function()
        if SHF.auto_respawn then
            task.wait(SHF.auto_respawn_delay)
            local char=LP.Character
            local hum=char and char:FindFirstChildOfClass("Humanoid")
            if hum then pcall(function() hum.Health=0 end) end
        end
    end)

    do
        local orig_recoil={}
        RunService.Stepped:Connect(function()
            if not SHF.no_recoil then
                for o,v in pairs(orig_recoil) do
                    if o and o.Parent then pcall(function() o.Value=v end) end
                end
                orig_recoil={}
                return
            end
            local char=LP.Character
            if not char then return end
            local gun=char:FindFirstChild("Gun")
            if gun then
                for _,d in ipairs(gun:GetDescendants()) do
                    if d:IsA("NumberValue") and d.Name:lower():find("recoil") then
                        if orig_recoil[d]==nil then orig_recoil[d]=d.Value end
                        d.Value=0
                    end
                end
            end
        end)
    end

    do
        local orig_spread={}
        RunService.Stepped:Connect(function()
            if not SHF.no_spread then
                for o,v in pairs(orig_spread) do
                    if o and o.Parent then pcall(function() o.Value=v end) end
                end
                orig_spread={}
                return
            end
            local char=LP.Character
            if not char then return end
            local gun=char:FindFirstChild("Gun")
            if gun then
                for _,d in ipairs(gun:GetDescendants()) do
                    if d:IsA("NumberValue") and d.Name:lower():find("spread") then
                        if orig_spread[d]==nil then orig_spread[d]=d.Value end
                        d.Value=0
                    end
                end
            end
        end)
    end

    do
        local last_click=0
        RunService.Heartbeat:Connect(function()
            if not SHF.auto_click then return end
            local now=os.clock()
            if now-last_click<SHF.auto_click_delay then return end
            last_click=now
            local vim=game:GetService("VirtualInputManager")
            pcall(function()
                vim:SendMouseButtonEvent(0,0,0,true,game,1)
                vim:SendMouseButtonEvent(0,0,0,false,game,1)
            end)
        end)
    end

    RunService.Heartbeat:Connect(function()
        if not SHF.auto_reload then return end
        local char=LP.Character
        local gun=char and char:FindFirstChild("Gun")
        if gun then
            local ammo=gun:FindFirstChild("Ammo")
            if ammo and ammo:IsA("IntValue") and ammo.Value==0 then
                local reload=gun:FindFirstChild("Reload")
                if reload and reload:IsA("RemoteEvent") then
                    pcall(function() reload:FireServer() end)
                end
            end
        end
    end)

    RunService.Heartbeat:Connect(function()
        if not SHF.auto_heal then return end
        local char=LP.Character
        local hum=char and char:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health>0 and hum.Health<hum.MaxHealth*(SHF.auto_heal_threshold/100) then
            local bp=LP:FindFirstChildOfClass("Backpack")
            if bp then
                for _,t in ipairs(bp:GetChildren()) do
                    if t:IsA("Tool") and (t.Name:lower():find("med") or t.Name:lower():find("heal")) then
                        pcall(function()
                            hum:EquipTool(t)
                            task.wait(0.1)
                            t:Activate()
                        end)
                        break
                    end
                end
            end
        end
    end)

    RunService.Heartbeat:Connect(function()
        if not SHF.auto_dodge then return end
        local char=LP.Character
        local hrp=char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        for _,p in ipairs(Players:GetPlayers()) do
            if p~=LP and p.Character then
                local thrp=p.Character:FindFirstChild("HumanoidRootPart")
                local th=p.Character:FindFirstChildOfClass("Humanoid")
                if thrp and th and th.Health>0 then
                    local dist=(thrp.Position-hrp.Position).Magnitude
                    if dist<SHF.auto_dodge_range and th.WalkSpeed>40 then
                        local away=(hrp.Position-thrp.Position).Unit
                        local v=hrp.AssemblyLinearVelocity
                        hrp.AssemblyLinearVelocity=Vector3.new(away.X*60,v.Y,away.Z*60)
                    end
                end
            end
        end
    end)

    do
        local GUN_SKINS={
            ["Golden"]=Color3.fromRGB(255,215,0),
            ["Rainbow"]=Color3.fromRGB(255,100,255),
            ["Neon"]=Color3.fromRGB(0,255,255),
            ["Dark"]=Color3.fromRGB(20,20,30),
            ["Blood"]=Color3.fromRGB(180,0,0),
        }
        local KNIFE_SKINS={
            ["Golden"]=Color3.fromRGB(255,215,0),
            ["Neon"]=Color3.fromRGB(0,255,255),
            ["Blood"]=Color3.fromRGB(180,0,0),
            ["Shadow"]=Color3.fromRGB(30,30,40),
        }
        local saved={}
        local function restoreTool(tool)
            for part,props in pairs(saved) do
                if part and part.Parent and part:IsDescendantOf(tool) then
                    pcall(function() part.Color=props.Color end)
                    pcall(function() part.Material=props.Material end)
                    saved[part]=nil
                end
            end
        end
        local function applyTool(tool, color)
            if not tool then return end
            if not color then restoreTool(tool); return end
            for _,part in ipairs(tool:GetDescendants()) do
                if part:IsA("BasePart") then
                    if not saved[part] then saved[part]={Color=part.Color,Material=part.Material} end
                    part.Color=color
                    part.Material=Enum.Material.Neon
                end
            end
        end
        local skin_conn=RunService.Heartbeat:Connect(function()
            local char=LP.Character
            local backpack=LP:FindFirstChildOfClass("Backpack")
            local function update(container, toolName, color)
                if not container then return end
                for _,tool in ipairs(container:GetChildren()) do
                    if tool:IsA("Tool") and tool.Name==toolName then applyTool(tool,color) end
                end
            end
            local gunColor=GUN_SKINS[SHF.gun_skin]
            local knifeColor=KNIFE_SKINS[SHF.knife_skin]
            update(char,"Gun",gunColor)
            update(backpack,"Gun",gunColor)
            update(char,"Knife",knifeColor)
            update(backpack,"Knife",knifeColor)
            for part in pairs(saved) do
                if not part or not part.Parent then saved[part]=nil end
            end
        end)
        SHF._skinDisconnect=function()
            if skin_conn then pcall(function() skin_conn:Disconnect() end); skin_conn=nil end
            for part,props in pairs(saved) do
                if part and part.Parent then
                    pcall(function() part.Color=props.Color end)
                    pcall(function() part.Material=props.Material end)
                end
            end
            table.clear(saved)
        end
    end

    -- Visual overlays are toggled with F6 (Role List) and F7 (Target HUD).
    -- No existing menu panels or Combat sections are modified.
    do
        SHF.role_list=SHF.role_list or false
        SHF.target_hud=SHF.target_hud or false
        local function makeOverlay(name,size,pos)
            local label=Instance.new("TextLabel")
            label.Name=name
            label.Size=size
            label.Position=pos
            label.BackgroundColor3=Color3.fromRGB(15,18,21)
            label.BackgroundTransparency=0.15
            label.TextColor3=Color3.fromRGB(235,235,235)
            label.Font=Enum.Font.GothamMedium
            label.TextSize=12
            label.TextXAlignment=Enum.TextXAlignment.Left
            label.TextYAlignment=Enum.TextYAlignment.Top
            label.TextWrapped=true
            label.Visible=false
            label.Parent=gui
            Instance.new("UICorner",label).CornerRadius=UDim.new(0,8)
            table.insert(themeUpdaters,function(t)
                label.BackgroundColor3=t.Inline
                label.TextColor3=t.Text
            end)
            return label
        end
        local roleList=makeOverlay("DaDaRoleList",UDim2.new(0,200,0,160),UDim2.new(1,-210,0,10))
        local targetHUD=makeOverlay("DaDaTargetHUD",UDim2.new(0,200,0,80),UDim2.new(1,-210,0,180))
        local visualConn=RunService.Heartbeat:Connect(function()
            roleList.Visible=SHF.role_list
            targetHUD.Visible=SHF.target_hud
            if SHF.role_list then
                local lines={}
                local ok,round=pcall(get_round)
                local data=ok and round and round.PlayerData
                if type(data)=="table" then
                    for name,info in pairs(data) do
                        if type(info)=="table" and not info.Dead and info.Role then
                            lines[#lines+1]=tostring(name).." - "..tostring(info.Role)
                        end
                    end
                end
                table.sort(lines)
                roleList.Text=#lines>0 and table.concat(lines,"\n") or "No role data"
            end
            if SHF.target_hud then
                local best,bestDist=nil,math.huge
                local myHrp=get_hrp()
                local cam=workspace.CurrentCamera
                if myHrp and cam then
                    for _,player in ipairs(Players:GetPlayers()) do
                        if player~=LP and player.Character then
                            local hrp=player.Character:FindFirstChild("HumanoidRootPart")
                            local hum=player.Character:FindFirstChildOfClass("Humanoid")
                            if hrp and hum and hum.Health>0 then
                                local screen,onScreen=cam:WorldToViewportPoint(hrp.Position)
                                if onScreen and screen.Z>0 then
                                    local dist=(hrp.Position-myHrp.Position).Magnitude
                                    if dist<bestDist then
                                        bestDist=dist
                                        best={player=player,humanoid=hum}
                                    end
                                end
                            end
                        end
                    end
                end
                if best then
                    targetHUD.Text=string.format("%s\nHP: %d/%d\nDistance: %dm",best.player.Name,math.floor(best.humanoid.Health),math.floor(best.humanoid.MaxHealth),math.floor(bestDist))
                else
                    targetHUD.Text="Target: none"
                end
            end
        end)
        local visualKeyConn=UIS.InputBegan:Connect(function(input,gpe)
            if gpe then return end
            if input.KeyCode==Enum.KeyCode.F6 then
                SHF.role_list=not SHF.role_list
            elseif input.KeyCode==Enum.KeyCode.F7 then
                SHF.target_hud=not SHF.target_hud
            end
        end)
        SHF._visualDisconnect=function()
            if visualConn then pcall(function() visualConn:Disconnect() end); visualConn=nil end
            if visualKeyConn then pcall(function() visualKeyConn:Disconnect() end); visualKeyConn=nil end
            if roleList then pcall(function() roleList:Destroy() end) end
            if targetHUD then pcall(function() targetHUD:Destroy() end) end
            SHF.role_list=false
            SHF.target_hud=false
        end
    end

    do
        local ANIM_IDS={
            ["Default"]=nil,
            ["Ninja"]={idle1="rbxassetid://656117400",idle2="rbxassetid://656118341",walk="rbxassetid://656121766",run="rbxassetid://656118852",jump="rbxassetid://656117878"},
            ["Zombie"]={idle1="rbxassetid://616158929",idle2="rbxassetid://616160636",walk="rbxassetid://616168032",run="rbxassetid://616163682",jump="rbxassetid://616161997"},
            ["Pirate"]={idle1="rbxassetid://750781874",idle2="rbxassetid://750782230",walk="rbxassetid://750785693",run="rbxassetid://750783738",jump="rbxassetid://750782770"},
            ["Robot"]={idle1="rbxassetid://616088211",idle2="rbxassetid://616089559",walk="rbxassetid://616095330",run="rbxassetid://616091570",jump="rbxassetid://616090588"},
        }
        local function applyAnim(name)
            local char=LP.Character
            if not char then return end
            local hum=char:FindFirstChildOfClass("Humanoid")
            if not hum then return end
            local animate=char:FindFirstChild("Animate")
            if not animate then return end
            local anims=ANIM_IDS[name]
            if not anims then return end
            hum:UnequipTools()
            for _,v in ipairs(hum:GetPlayingAnimationTracks()) do pcall(function() v:Stop(0) end) end
            animate.Disabled=true
            task.wait(0.1)
            local function replace(folder,child,id)
                local f=animate:FindFirstChild(folder)
                if not f then return end
                local a=f:FindFirstChild(child)
                if a and a:IsA("Animation") and id then a.AnimationId=id end
            end
            if anims.idle1 then replace("idle","Animation1",anims.idle1) end
            if anims.idle2 then replace("idle","Animation2",anims.idle2) end
            if anims.walk then replace("walk","WalkAnim",anims.walk) end
            if anims.run then replace("run","RunAnim",anims.run) end
            if anims.jump then replace("jump","JumpAnim",anims.jump) end
            animate.Disabled=false
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
        SHF.applyAnim=applyAnim
    end

    do
        local last_role=nil
        task.spawn(function()
            while task.wait(0.5) do
                if not SHF.round_notify then continue end
                local m=get_round()
                local d=m and m.PlayerData
                local me=d and d[LP.Name]
                local role=me and me.Role
                if role and role~=last_role then
                    last_role=role
                    if notify then pcall(notify,"Role",role,4) end
                end
            end
        end)
    end

    task.spawn(function()
        while task.wait(1) do
            if not SHF.killer_notify then continue end
            local m=get_round()
            local d=m and m.PlayerData
            if type(d)=="table" then
                for name,info in pairs(d) do
                    if type(info)=="table" and info.Role=="Murderer" and not info.Dead then
                        if not SHF.role_map[name] then
                            SHF.role_map[name]=true
                            if notify then pcall(notify,"Murderer","@"..name,5) end
                        end
                        break
                    end
                end
            end
        end
    end)
end
initInvisExtras()

-- ============================================================
-- INIT 13: NOTIFICATIONS + SOUNDS
-- ============================================================
local function initNotifications()
    notifGui=Instance.new("ScreenGui")
    notifGui.Name="DaDaNotif"
    notifGui.ResetOnSpawn=false
    notifGui.IgnoreGuiInset=true
    notifGui.DisplayOrder=101
    pcall(function() notifGui.Parent=CoreGui end)
    if not notifGui.Parent then notifGui.Parent=LP:WaitForChild("PlayerGui") end
    local notifHolder=Instance.new("Frame")
    notifHolder.Size=UDim2.new(0,220,1,-80)
    notifHolder.Position=UDim2.new(1,-235,0,70)
    notifHolder.BackgroundTransparency=1
    notifHolder.Parent=notifGui
    local nlist=Instance.new("UIListLayout",notifHolder)
    nlist.Padding=UDim.new(0,6)
    nlist.SortOrder=Enum.SortOrder.LayoutOrder
    nlist.HorizontalAlignment=Enum.HorizontalAlignment.Right
    notify=function(title,desc,dur)
        dur=dur or 4
        local card=Instance.new("Frame")
        card.Size=UDim2.new(1,0,0,0)
        card.AutomaticSize=Enum.AutomaticSize.Y
        card.BackgroundColor3=BG_PANEL
        card.BackgroundTransparency=0.1
        card.Parent=notifHolder
        Instance.new("UICorner",card).CornerRadius=UDim.new(0,6)
        local stroke=Instance.new("UIStroke",card)
        stroke.Color=ACCENT
        stroke.Thickness=1
        local t=Instance.new("TextLabel")
        t.Size=UDim2.new(1,-16,0,16)
        t.Position=UDim2.new(0,8,0,6)
        t.BackgroundTransparency=1
        t.Text=title
        t.TextColor3=TEXT_MAIN
        t.TextSize=12
        t.Font=Enum.Font.GothamBold
        t.TextXAlignment=Enum.TextXAlignment.Left
        t.Parent=card
        local d=Instance.new("TextLabel")
        d.Size=UDim2.new(1,-16,0,0)
        d.AutomaticSize=Enum.AutomaticSize.Y
        d.Position=UDim2.new(0,8,0,24)
        d.BackgroundTransparency=1
        d.Text=desc or ""
        d.TextColor3=TEXT_DIM
        d.TextSize=11
        d.Font=Enum.Font.Gotham
        d.TextXAlignment=Enum.TextXAlignment.Left
        d.TextWrapped=true
        d.Parent=card
        Instance.new("UIPadding",card).PaddingBottom=UDim.new(0,6)
        task.delay(dur,function()
            if card and card.Parent then
                TweenService:Create(card,TweenInfo.new(0.3),{BackgroundTransparency=1}):Play()
                TweenService:Create(stroke,TweenInfo.new(0.3),{Transparency=1}):Play()
                task.wait(0.3)
                card:Destroy()
            end
        end)
    end

    -- Kitty-compatible sound assets: use Roblox asset IDs directly instead of
    -- downloading .ogg files from a GitHub URL (that was the main playback failure).
    local SND_ASSETS={
        ["primordial"]="6534947869",
        ["neverlose"]="110168723447153",
        ["sparkle"]="110241936966089",
        ["mc bow"]="3442683707",
        ["skeet"]="5633695679",
        ["break"]="7149516994",
        ["rust"]="138750331387064",
        ["applepay"]="13956013041",
        ["bubble"]="6534947588",
        ["combobreak"]="2868331684",
        ["killcard"]="9102080552",
        ["xp"]="7147454322",
        ["na naxuy"]="4578740568",
        ["stony"]="3581383408",
        ["hentai"]="6442965016",
        ["TF2 Critical"]="296102734",
        ["Call of Duty"]="5952120301",
        ["Bat"]="3333907347",
        ["Saber"]="8415678813",
        ["Money"]="13956013041",
        ["LazerBeam"]="130791043",
        ["WindowsXPError"]="160715357",
        ["OSU"]="7147454322",
        ["Minecraft"]="5869422451",
        ["Among Us"]="5700183626",
        ["Bonk"]="5766898159",
        ["Vine"]="5332680810",
        ["Bruh"]="4578740568",
        ["Fatality"]="6534947869",
        ["Default Sound"]="330595293",
    }
    local SND_LIST={"primordial","neverlose","sparkle","mc bow","skeet","break","rust","applepay","bubble","combobreak","killcard","xp","na naxuy","stony","hentai","TF2 Critical","Call of Duty","Bat","Saber","Money","LazerBeam","WindowsXPError","OSU","Minecraft","Among Us","Bonk","Vine","Bruh","Fatality"}
    local snd_cache={}
    local function snd_download(name)
        local asset=SND_ASSETS[name]
        if not asset then return nil end
        asset=tostring(asset):gsub("^rbxassetid://", "")
        if not asset:match("^%d+$") then return nil end
        return "rbxassetid://"..asset
    end
    local SoundService=game:GetService("SoundService")
    local ContentProvider=game:GetService("ContentProvider")
    local function get_custom_sound(name)
        local id=snd_download(name)
        if not id then return nil end
        local cached=snd_cache[name]
        if cached and cached.Parent then return cached end
        local ok,sound=pcall(function()
            local obj=Instance.new("Sound")
            obj.Name="DaDaCustomSound_"..tostring(name):gsub("%W", "")
            obj.SoundId=id
            obj.Volume=1
            obj.Looped=false
            obj.Parent=SoundService
            return obj
        end)
        if not ok or not sound then return nil end
        snd_cache[name]=sound
        task.spawn(function() pcall(function() ContentProvider:PreloadAsync({sound}) end) end)
        return sound
    end
    local function snd_preload(name)
        local sound=get_custom_sound(name)
        if sound then task.spawn(function() pcall(function() ContentProvider:PreloadAsync({sound}) end) end) end
    end
    local function snd_play(name,vol)
        local sound=get_custom_sound(name)
        if not sound then return false end
        local ok=pcall(function()
            sound:Stop()
            sound.TimePosition=0
            sound.Volume=math.clamp(tonumber(vol) or 1,0,10)
            sound.Parent=SoundService
            sound:Play()
        end)
        return ok
    end
    SHF.snd_play=snd_play
    SHF.snd_preload=snd_preload
    SHF.snd_list=SND_LIST

    task.defer(function() snd_preload(SHF.gunshot_sound_name); snd_preload(SHF.sheriff_sound_name); snd_preload(SHF.kill_sound_name) end)

    local gun_conn=nil
    local function lp_has_gun_sh()
        local char=LP.Character
        if char and char:FindFirstChild("Gun") then return true end
        local bp=LP:FindFirstChildOfClass("Backpack")
        if bp and bp:FindFirstChild("Gun") then return true end
        return false
    end
    local function murderer_player()
        local m=get_round()
        local d=m and m.PlayerData
        if type(d)~="table" then return nil end
        for name,info in pairs(d) do
            if type(info)=="table" and info.Role=="Murderer" then return Players:FindFirstChild(name) end
        end
        return nil
    end
    -- Mute original weapon sounds as they are created/played, not only after the remote arrives.
    local mutedOriginalSounds={}
    local function isOriginalGunshot(sound)
        if not sound or not sound:IsA("Sound") then return false end
        if sound.Name:lower():find("dadacustomsound",1,true) then return false end
        local n=sound.Name:lower()
        local parent=sound.Parent
        local inGun=false
        local char=LP.Character
        local gun=char and char:FindFirstChild("Gun")
        pcall(function() inGun=gun~=nil and (sound==gun or sound:IsDescendantOf(gun)) end)
        local looksLikeShot=n:find("gunshot",1,true)~=nil or n:find("shoot",1,true)~=nil
            or n:find("fire",1,true)~=nil or n=="gun" or n=="shot" or n:find("shot",1,true)~=nil
        return looksLikeShot and (inGun or parent==SoundService or (char and sound:IsDescendantOf(char)))
    end
    local function silenceOne(sound)
        if not SHF.gunshot_sound or not isOriginalGunshot(sound) then return end
        pcall(function()
            sound.Volume=0
            sound:Stop()
            mutedOriginalSounds[sound]=true
        end)
    end
    local function silenceOriginalGunshot()
        if not SHF.gunshot_sound then return end
        local char=LP.Character
        local gun=char and char:FindFirstChild("Gun")
        if gun then for _,obj in ipairs(gun:GetDescendants()) do silenceOne(obj) end end
        if char then for _,obj in ipairs(char:GetDescendants()) do silenceOne(obj) end end
        for _,obj in ipairs(SoundService:GetDescendants()) do silenceOne(obj) end
    end
    SoundService.DescendantAdded:Connect(function(obj)
        if SHF.gunshot_sound and obj:IsA("Sound") then task.defer(function() silenceOne(obj) end) end
    end)
    local function playCustomGunshot()
        if not SHF.gunshot_sound then return end
        silenceOriginalGunshot()
        snd_play(SHF.gunshot_sound_name,SHF.gunshot_sound_vol)
        -- A few games start the original Sound after Tool.Activated; mute it again next frame.
        task.defer(silenceOriginalGunshot)
    end
    local function on_shot_sh()
        -- This callback comes from the game's GunFired event and remains responsible for kill sounds.
        if SHF.gunshot_sound then silenceOriginalGunshot() end
        if not (SHF.kill_sound or SHF.sheriff_sound) then return end
        local role=my_role()
        local mp=murderer_player()
        if not mp then return end
        local mname=mp.Name
        task.delay(0.7,function()
            local m=get_round()
            local d=m and m.PlayerData
            local info=d and d[mname]
            local tgt=Players:FindFirstChild(mname)
            local hum=tgt and tgt.Character and tgt.Character:FindFirstChildOfClass("Humanoid")
            local killed=(info and info.Dead==true) or (hum~=nil and hum.Health<=0)
            if killed then
                if role=="Sheriff" or role=="Hero" or lp_has_gun_sh() then
                    if SHF.sheriff_sound then snd_play(SHF.sheriff_sound_name,SHF.sheriff_sound_vol) end
                elseif role=="Murderer" then
                    if SHF.kill_sound then snd_play(SHF.kill_sound_name,SHF.kill_sound_vol) end
                end
            end
        end)
    end
    -- Tool.Activated starts the replacement immediately; the remote event is retained for kill detection.
    local activatedConnections={}
    local function hookGunTool(tool)
        if not tool or not tool:IsA("Tool") or tool.Name~="Gun" or activatedConnections[tool] then return end
        activatedConnections[tool]=tool.Activated:Connect(function()
            if SHF.gunshot_sound then playCustomGunshot() end
        end)
    end
    local function scanGunTools()
        local char=LP.Character
        local bp=LP:FindFirstChildOfClass("Backpack")
        if char then
            for _,obj in ipairs(char:GetChildren()) do hookGunTool(obj) end
            char.ChildAdded:Connect(function(obj) hookGunTool(obj) end)
        end
        if bp then
            for _,obj in ipairs(bp:GetChildren()) do hookGunTool(obj) end
            bp.ChildAdded:Connect(function(obj) hookGunTool(obj) end)
        end
    end
    scanGunTools()
    LP.CharacterAdded:Connect(function()
        task.wait(0.5)
        scanGunTools()
    end)
    local function ensure_gun_hook_sh()
        if gun_conn then return end
        local ok,remote=pcall(function()
            return ReplicatedStorage:WaitForChild("ClientServices"):WaitForChild("WeaponService"):WaitForChild("GunFired")
        end)
        if not ok or not remote then return end
        gun_conn=remote.OnClientEvent:Connect(function(gun)
            local char=LP.Character
            if typeof(gun)=="Instance" and char and gun:IsDescendantOf(char) then
                on_shot_sh()
            end
        end)
    end
    local lastDeadState={}
    task.spawn(function()
        while true do
            local ok,round=pcall(get_round)
            local data=ok and round and round.PlayerData
            if type(data)=="table" then
                local role=my_role()
                if role=="Murderer" and SHF.kill_sound then
                    for playerName,info in pairs(data) do
                        if type(info)=="table" then
                            local dead=info.Dead==true
                            if dead and lastDeadState[playerName]~=true and playerName~=LP.Name then
                                snd_play(SHF.kill_sound_name, SHF.kill_sound_vol)
                            end
                            lastDeadState[playerName]=dead
                        end
                    end
                else
                    for playerName,info in pairs(data) do
                        if type(info)=="table" then lastDeadState[playerName]=info.Dead==true end
                    end
                end
            end
            if SHF.gunshot_sound or SHF.kill_sound or SHF.sheriff_sound then
                ensure_gun_hook_sh()
            end
            task.wait(0.25)
        end
    end)
end
initNotifications()-- ============================================================
-- INIT 14: МЕНЮ
-- ============================================================
local function initMenu()
    gui=Instance.new("ScreenGui")
    gui.Name="DaDaMenu_"..math.random(1000,9999)
    gui.ResetOnSpawn=false
    gui.IgnoreGuiInset=true
    gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
    pcall(function() gui.Parent=CoreGui end)
    if not gui.Parent then gui.Parent=LP:WaitForChild("PlayerGui") end
    win=Instance.new("Frame")
    win.Size=UDim2.new(0,600,0,360)
    win.Position=UDim2.new(0.5,-300,0.5,-180)
    win.BackgroundColor3=BG_MAIN
    win.BackgroundTransparency=WIN_TRANS
    win.Visible=false
    win.Active=true
    win.Parent=gui
    Instance.new("UICorner",win).CornerRadius=UDim.new(0,10)
    local winStroke=Instance.new("UIStroke",win); winStroke.Color=STROKE
    table.insert(themeUpdaters,function(t) win.BackgroundColor3=t.Background; winStroke.Color=t.Border end)
    local winDragBar=Instance.new("Frame")
    winDragBar.Size=UDim2.new(1,0,0,30)
    winDragBar.BackgroundTransparency=1
    winDragBar.Active=true
    winDragBar.ZIndex=10
    winDragBar.Parent=win
    local winDrag=false; local winDS; local winSP
    winDragBar.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            winDrag=true; winDS=input.Position; winSP=win.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if not winDrag then return end
        if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then
            local delta=input.Position-winDS
            win.Position=UDim2.new(winSP.X.Scale,winSP.X.Offset+delta.X,winSP.Y.Scale,winSP.Y.Offset+delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then winDrag=false end
    end)
    local sidebar=Instance.new("Frame")
    sidebar.Size=UDim2.new(0,98,1,-12)
    sidebar.Position=UDim2.new(0,6,0,6)
    sidebar.BackgroundColor3=BG_SIDE
    sidebar.BackgroundTransparency=SIDE_TRANS
    sidebar.BorderSizePixel=0
    sidebar.Parent=win
    Instance.new("UICorner",sidebar).CornerRadius=UDim.new(0,8)
    table.insert(themeUpdaters,function(t) sidebar.BackgroundColor3=t.Inline end)
    local sbList=Instance.new("UIListLayout",sidebar)
    sbList.Padding=UDim.new(0,3)
    sbList.HorizontalAlignment=Enum.HorizontalAlignment.Center
    sbList.SortOrder=Enum.SortOrder.LayoutOrder
    Instance.new("UIPadding",sidebar).PaddingTop=UDim.new(0,8)
    local pagesFrame=Instance.new("Frame")
    pagesFrame.Size=UDim2.new(1,-110,1,-12)
    pagesFrame.Position=UDim2.new(0,104,0,6)
    pagesFrame.BackgroundTransparency=1
    pagesFrame.Parent=win
    local TABS={"Combat","Fling","Movement","Visuals","World","Extras","Config","Farm"}
    local tabBtns,tapPages={},{}
    for i,name in ipairs(TABS) do
        local b=Instance.new("TextButton")
        b.Size=UDim2.new(1,-14,0,28)
        b.BackgroundColor3=BG_PANEL
        b.BackgroundTransparency=0.6
        b.Text=name
        b.TextColor3=TEXT_DIM
        b.TextSize=11
        b.Font=Enum.Font.GothamBold
        b.LayoutOrder=i
        b.Parent=sidebar
        Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)
        tabBtns[i]=b
        local pg=Instance.new("Frame")
        pg.Size=UDim2.new(1,0,1,0)
        pg.BackgroundTransparency=1
        pg.Visible=(i==1)
        pg.Parent=pagesFrame
        tapPages[i]=pg
        local colL=Instance.new("ScrollingFrame")
        colL.Size=UDim2.new(0.5,-3,1,0)
        colL.BackgroundTransparency=1
        colL.ScrollBarThickness=3
        colL.ScrollBarImageColor3=ACCENT
        colL.CanvasSize=UDim2.new(0,0,0,0)
        colL.AutomaticCanvasSize=Enum.AutomaticSize.Y
        colL.Parent=pg
        local lL=Instance.new("UIListLayout",colL); lL.Padding=UDim.new(0,6)
        local colR=Instance.new("ScrollingFrame")
        colR.Size=UDim2.new(0.5,-3,1,0)
        colR.Position=UDim2.new(0.5,3,0,0)
        colR.BackgroundTransparency=1
        colR.ScrollBarThickness=3
        colR.ScrollBarImageColor3=ACCENT
        colR.CanvasSize=UDim2.new(0,0,0,0)
        colR.AutomaticCanvasSize=Enum.AutomaticSize.Y
        colR.Parent=pg
        local lR=Instance.new("UIListLayout",colR); lR.Padding=UDim.new(0,6)
        b.MouseButton1Click:Connect(function()
            for j,btn in ipairs(tabBtns) do
                btn.BackgroundTransparency=(j==i) and 0.2 or 0.6
                btn.TextColor3=(j==i) and TEXT_MAIN or TEXT_DIM
                tapPages[j].Visible=(j==i)
            end
        end)
    end
    tabBtns[1].BackgroundTransparency=0.2; tabBtns[1].TextColor3=TEXT_MAIN

    -- Halloween decor: pumpkins only. No web, vignette, skeleton, or bat.
    local decorLayer=Instance.new("Frame")
    decorLayer.Name="DaDaHalloweenDecor"
    decorLayer.Size=UDim2.fromScale(1,1)
    decorLayer.Position=UDim2.fromScale(0,0)
    decorLayer.BackgroundTransparency=1
    decorLayer.BorderSizePixel=0
    decorLayer.ZIndex=31
    decorLayer.Active=false
    decorLayer.Selectable=false
    decorLayer.Parent=main

    local function addPumpkin(name,position,size,textSize)
        local pumpkin=Instance.new("TextLabel")
        pumpkin.Name=name
        pumpkin.AnchorPoint=Vector2.new(0.5,0.5)
        pumpkin.Position=position
        pumpkin.Size=UDim2.fromOffset(size,size)
        pumpkin.BackgroundTransparency=1
        pumpkin.Text="🎃"
        pumpkin.TextSize=textSize
        pumpkin.Font=Enum.Font.GothamBold
        pumpkin.TextColor3=Color3.fromRGB(255,132,38)
        pumpkin.TextStrokeColor3=Color3.fromRGB(55,20,18)
        pumpkin.TextStrokeTransparency=0.15
        pumpkin.ZIndex=32
        pumpkin.Active=false
        pumpkin.Selectable=false
        pumpkin.Parent=decorLayer
        return pumpkin
    end
    -- Pumpkins stay tucked into the bottom corners, clear of controls.
    addPumpkin("HalloweenPumpkinBottomLeft",UDim2.new(0,18,1,-18),30,25)
    addPumpkin("HalloweenPumpkinBottomRight",UDim2.new(1,-18,1,-18),30,25)
    addPumpkin("HalloweenPumpkinSmallBottomRight",UDim2.new(1,-43,1,-13),22,18)

    local function getCols(tabIndex)
        local pg=tapPages[tabIndex]; local cols={}
        for _,c in ipairs(pg:GetChildren()) do if c:IsA("ScrollingFrame") then cols[#cols+1]=c end end
        return cols
    end
    local uiRegistry={}
    makePanel=function(tabIndex,side,title)
        local cols=getCols(tabIndex)
        local target=cols[side=="left" and 1 or 2]
        if not target then return end
        local panel=Instance.new("Frame")
        panel.Size=UDim2.new(1,-3,0,0)
        panel.AutomaticSize=Enum.AutomaticSize.Y
        panel.BackgroundColor3=BG_PANEL
        panel.BackgroundTransparency=PANEL_TRANS
        panel.Parent=target
        Instance.new("UICorner",panel).CornerRadius=UDim.new(0,6)
        local ps=Instance.new("UIStroke",panel); ps.Color=STROKE
        table.insert(themeUpdaters,function(t) panel.BackgroundColor3=t.Inline; ps.Color=t.Border end)
        local head=Instance.new("Frame")
        head.Size=UDim2.new(1,0,0,20)
        head.BackgroundColor3=BG_HEADER
        head.BackgroundTransparency=HEADER_TRANS
        head.Parent=panel
        Instance.new("UICorner",head).CornerRadius=UDim.new(0,6)
        table.insert(themeUpdaters,function(t) head.BackgroundColor3=t.Element end)
        local tl=Instance.new("TextLabel")
        tl.Size=UDim2.new(1,-8,1,0)
        tl.Position=UDim2.new(0,6,0,0)
        tl.BackgroundTransparency=1
        tl.Text=title
        tl.TextColor3=TEXT_MAIN
        tl.TextSize=11
        tl.Font=Enum.Font.GothamBold
        tl.TextXAlignment=Enum.TextXAlignment.Left
        tl.Parent=head
        local body=Instance.new("Frame")
        body.Size=UDim2.new(1,-10,0,0)
        body.Position=UDim2.new(0,5,0,24)
        body.AutomaticSize=Enum.AutomaticSize.Y
        body.BackgroundTransparency=1
        body.Parent=panel
        local bl=Instance.new("UIListLayout",body); bl.Padding=UDim.new(0,2)
        Instance.new("UIPadding",body).PaddingBottom=UDim.new(0,4)
        local P={body=body}
        function P:Toggle(label,default,cb,flag)
            local row=Instance.new("Frame")
            row.Size=UDim2.new(1,0,0,20)
            row.BackgroundTransparency=1
            row.Parent=body
            local lbl=Instance.new("TextLabel")
            lbl.Size=UDim2.new(1,-50,1,0)
            lbl.Position=UDim2.new(0,4,0,0)
            lbl.BackgroundTransparency=1
            lbl.Text=label
            lbl.TextColor3=TEXT_MAIN
            lbl.TextSize=10
            lbl.Font=Enum.Font.Gotham
            lbl.TextXAlignment=Enum.TextXAlignment.Left
            lbl.Parent=row
            local tbg=Instance.new("Frame")
            tbg.Size=UDim2.fromOffset(24,13)
            tbg.Position=UDim2.new(1,-28,0.5,-6.5)
            tbg.BackgroundColor3=default and BG_ON or BG_OFF
            tbg.BackgroundTransparency=ROW_TRANS
            tbg.Parent=row
            Instance.new("UICorner",tbg).CornerRadius=UDim.new(1,0)
            local ball=Instance.new("Frame")
            ball.Size=UDim2.fromOffset(9,9)
            ball.Position=default and UDim2.new(1,-11,0.5,-4.5) or UDim2.new(0,2,0.5,-4.5)
            ball.BackgroundColor3=Color3.fromRGB(30,30,35)
            ball.Parent=tbg
            Instance.new("UICorner",ball).CornerRadius=UDim.new(1,0)
            -- Larger hit target: easier to tap on mobile; keep the switch visuals unchanged.
            local btn=Instance.new("TextButton")
            btn.Name="ToggleHitTarget"
            btn.Size=UDim2.new(1,0,1,0)
            btn.Position=UDim2.new(0,0,0,0)
            btn.BackgroundTransparency=1
            btn.Text=""
            btn.AutoButtonColor=false
            btn.ZIndex=10
            btn.Parent=row
            tbg.ZIndex=8
            ball.ZIndex=9
            lbl.ZIndex=7
            local st=default
            local function refresh()
                TweenService:Create(ball,TweenInfo.new(0.15),{Position=st and UDim2.new(1,-11,0.5,-4.5) or UDim2.new(0,2,0.5,-4.5)}):Play()
                tbg.BackgroundColor3=st and ACCENT or BG_OFF
            end
            btn.MouseButton1Click:Connect(function()
                st=not st
                refresh()
                if cb then pcall(cb,st) end
            end)
            if flag then uiRegistry[flag]=function(nv) if st~=nv then st=nv; refresh() end end end
        end
        function P:Button(label,cb)
            local btn=Instance.new("TextButton")
            btn.Size=UDim2.new(1,0,0,20)
            btn.BackgroundColor3=BG_ROW
            btn.BackgroundTransparency=ROW_TRANS
            btn.Text=label
            btn.TextColor3=TEXT_MAIN
            btn.TextSize=10
            btn.Font=Enum.Font.Gotham
            btn.Parent=body
            Instance.new("UICorner",btn).CornerRadius=UDim.new(0,4)
            btn.MouseButton1Click:Connect(function() if cb then pcall(cb) end end)
        end
        function P:Slider(label,default,min,max,cb)
            local row=Instance.new("Frame")
            row.Size=UDim2.new(1,0,0,28)
            row.BackgroundTransparency=1
            row.Parent=body
            local lbl=Instance.new("TextLabel")
            lbl.Size=UDim2.new(1,0,0,12)
            lbl.BackgroundTransparency=1
            lbl.Text=label..": "..tostring(default)
            lbl.TextColor3=TEXT_MAIN
            lbl.TextSize=10
            lbl.Font=Enum.Font.Gotham
            lbl.TextXAlignment=Enum.TextXAlignment.Left
            lbl.Parent=row
            local track=Instance.new("Frame")
            track.Size=UDim2.new(1,0,0,4)
            track.Position=UDim2.new(0,0,0,17)
            track.BackgroundColor3=BG_SLIDER
            track.BackgroundTransparency=ROW_TRANS
            track.Parent=row
            Instance.new("UICorner",track).CornerRadius=UDim.new(1,0)
            local fill=Instance.new("Frame")
            fill.Size=UDim2.new((default-min)/(max-min),0,1,0)
            fill.BackgroundColor3=ACCENT2
            fill.Parent=track
            Instance.new("UICorner",fill).CornerRadius=UDim.new(1,0)
            local drag=false
            local function upd(i)
                local p=math.clamp((i.Position.X-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1)
                fill.Size=UDim2.new(p,0,1,0)
                local v=math.floor(min+(max-min)*p)
                lbl.Text=label..": "..tostring(v)
                if cb then cb(v) end
            end
            track.InputBegan:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=true; upd(i) end
            end)
            UIS.InputEnded:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=false end
            end)
            UIS.InputChanged:Connect(function(i)
                if drag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then upd(i) end
            end)
        end
        function P:Dropdown(label,values,default,cb)
            local row=Instance.new("TextButton")
            row.Size=UDim2.new(1,0,0,20)
            row.BackgroundColor3=BG_ROW
            row.BackgroundTransparency=ROW_TRANS
            row.Text=label..": "..tostring(default)
            row.TextColor3=TEXT_MAIN
            row.TextSize=10
            row.Font=Enum.Font.Gotham
            row.Parent=body
            Instance.new("UICorner",row).CornerRadius=UDim.new(0,4)
            local idx=1
            for i,v in ipairs(values) do if v==default then idx=i end end
            row.MouseButton1Click:Connect(function()
                idx=idx%#values+1
                local v=values[idx]
                row.Text=label..": "..tostring(v)
                if cb then pcall(cb,v) end
            end)
        end
        return P
    end

    -- COMBAT
    local cA=makePanel(1,"left","Silent Aim")
    cA:Toggle("Silent Aim",false,function(v)
        SL.enabled=v
        ST.quick_state.silent=v
        if v then task.spawn(function() pcall(SL_installHooks); pcall(SL_refresh) end)
        else if _G.DaDa_SL_restore_origin then pcall(_G.DaDa_SL_restore_origin) end end
    end,"silent")
    cA:Toggle("Prediction",true,function(v) SL.predict=v end)
    cA:Toggle("Force Shoot",false,function(v)
        SL.force=v
        if not v and _G.DaDa_SL_restore_origin then pcall(_G.DaDa_SL_restore_origin) end
    end)
    cA:Slider("Origin",15,0,40,function(v) SL.stand_off=v end)
    cA:Dropdown("Hit Part",{"Head","UpperTorso","Torso","HumanoidRootPart"},"UpperTorso",function(v) ST.hit_part=v end)
    cA:Toggle("Trigger Bot",false,function(v) ST.triggerbot=v end)
    cA:Toggle("FOV Circle",false,function(v) ST.fov_circle=v end)
    cA:Slider("FOV Size",120,40,300,function(v) ST.fov_size=v end)
    local cB=makePanel(1,"right","Auto Shoot")
    cB:Toggle("Auto Shoot",false,function(v) SL.auto_on=v; ST.quick_state.auto_shoot=v end)
    cB:Slider("Auto Delay",0,0,600,function(v) SL.auto_delay=v/1000 end)
    local cC=makePanel(1,"left","Get Gun")
    cC:Toggle("Auto Get Gun",false,function(v) ST.getgun=v; ST.quick_state.getgun=v end)
    cC:Dropdown("Mode",{"Touch","Teleport","PlayerTP","AutoGrab"},"Touch",function(v) ST.getgun_mode=v end)
    cC:Slider("Interval",15,5,100,function(v) ST.getgun_interval=v/100 end)
    cC:Toggle("Teleport Back",true,function(v) ST.getgun_tp_back=v end)
    local cD=makePanel(1,"right","Knife / Murderer")
    cD:Toggle("Auto Knife Throw",false,function(v) ST.auto_knife_throw=v end)
    cD:Toggle("Knife Prediction",true,function(v) ST.knife_predict=v end)
    cD:Slider("Knife Lead %",100,0,300,function(v) ST.knife_lead=v end)
    cD:Toggle("Kill Aura",false,function(v) ST.killaura=v end)
    cD:Toggle("Auto Knife",false,function(v) ST.autoknife=v end)
    cD:Slider("Kill Distance",30,5,60,function(v) ST.killaura_dist=v end)

    -- Vote Duper: uses the original Auto Vote behavior under the requested label.
    -- This is ordinary map voting; it does not fake or inflate server vote counts.
    local votePanel=makePanel(1,"left","Vote Duper")
    SHF.mapvote_dupe=false
    votePanel:Toggle("Vote Duper",false,function(v)
        SHF.mapvote_dupe=false
        SHF.mapvote=v
        if notify then pcall(function() notify("Vote Duper",v and "Enabled" or "Disabled") end) end
    end,"DaDaVoteDuper")
    votePanel:Slider("Vote Cap",3,1,10,function(v)
        SHF.mapvote_cap=math.max(1,math.floor(tonumber(v) or 3))
    end)
    local voteHint=Instance.new("TextLabel")
    voteHint.Size=UDim2.new(1,0,0,18)
    voteHint.BackgroundTransparency=1
    voteHint.Text="Choose a map"
    voteHint.TextColor3=TEXT_DIM
    voteHint.TextSize=9
    voteHint.Font=Enum.Font.Gotham
    voteHint.TextXAlignment=Enum.TextXAlignment.Left
    voteHint.Parent=votePanel.body

    local voteCards=Instance.new("Frame")
    voteCards.Name="VotePadCards"
    voteCards.Size=UDim2.new(1,0,0,112)
    voteCards.BackgroundTransparency=1
    voteCards.Parent=votePanel.body
    local voteGrid=Instance.new("UIGridLayout")
    voteGrid.CellSize=UDim2.new(0.32,0,0,104)
    voteGrid.CellPadding=UDim2.new(0.02,0,0,4)
    voteGrid.FillDirection=Enum.FillDirection.Horizontal
    voteGrid.FillDirectionMaxCells=3
    voteGrid.SortOrder=Enum.SortOrder.LayoutOrder
    voteGrid.Parent=voteCards

    local voteSlots={}
    local function deepFind(parent,name)
        if not parent then return nil end
        local found=parent:FindFirstChild(name,true)
        if found then return found end
        return nil
    end
    local function findVoteLobby()
        for _,lobbyName in ipairs({"RegularLobby","SummerLobby","Lobby"}) do
            local lobby=workspace:FindFirstChild(lobbyName) or workspace:FindFirstChild(lobbyName,true)
            if lobby then return lobby end
        end
        return nil
    end
    local function getImageSource(root)
        if not root then return "" end
        local function read(obj)
            if obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
                return obj.Image
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                return obj.Texture
            end
            local ok,img=pcall(function() return obj.Image end)
            if ok and type(img)=="string" and img~="" then return img end
            return ""
        end
        local direct=read(root)
        if direct~="" then return direct end
        for _,obj in ipairs(root:GetDescendants()) do
            local img=read(obj)
            if img~="" then return img end
        end
        return ""
    end
    local function getMapTitle(model)
        local voteInfo=deepFind(model,"VoteInfoGui")
        local mapInfo=deepFind(model,"MapInfoGui")
        local title=(voteInfo and deepFind(voteInfo,"MapName"))
            or (mapInfo and deepFind(mapInfo,"MapName"))
            or deepFind(model,"MapName")
        if title and (title:IsA("TextLabel") or title:IsA("TextButton") or title:IsA("TextBox")) then
            local value=title.Text
            if value and value~="" and value~="MAP NAME" then return value end
        end
        return nil
    end
    local function getMapImage(model)
        local mapInfo=deepFind(model,"MapInfoGui")
        local icon=(mapInfo and deepFind(mapInfo,"MapIcon")) or deepFind(model,"MapIcon")
        local img=getImageSource(icon or mapInfo)
        if img=="" then
            -- Some lobby versions put the map thumbnail outside MapInfoGui.
            img=getImageSource(model)
        end
        return img
    end
    for i=1,3 do
        local card=Instance.new("ImageButton")
        card.Name="MapCardSlot"..i
        card.LayoutOrder=i
        card.Size=UDim2.new(0.32,0,0,104)
        card.BackgroundColor3=BG_ROW
        card.BackgroundTransparency=0.05
        card.BorderSizePixel=0
        card.Image=""
        card.AutoButtonColor=true
        card.Parent=voteCards
        Instance.new("UICorner",card).CornerRadius=UDim.new(0,6)
        local image=Instance.new("ImageLabel")
        image.Name="MapImage"
        image.Size=UDim2.new(1,0,1,-24)
        image.BackgroundColor3=BG_PANEL
        image.BackgroundTransparency=0
        image.Image=""
        image.ScaleType=Enum.ScaleType.Crop
        image.Parent=card
        image.ZIndex=card.ZIndex+1
        image.Active=false
        Instance.new("UICorner",image).CornerRadius=UDim.new(0,6)
        local name=Instance.new("TextLabel")
        name.Name="MapName"
        name.Size=UDim2.new(1,-4,0,22)
        name.Position=UDim2.new(0,2,1,-22)
        name.BackgroundColor3=BG_PANEL
        name.BackgroundTransparency=0.05
        name.TextColor3=TEXT_MAIN
        name.Text="Searching..."
        name.TextSize=9
        name.TextWrapped=true
        name.Font=Enum.Font.GothamBold
        name.ZIndex=image.ZIndex+1
        name.Parent=card
        name.Active=false
        Instance.new("UICorner",name).CornerRadius=UDim.new(0,4)
        voteSlots[i]={card=card,image=image,name=name,mapName=nil,model=nil}
        card.MouseButton1Click:Connect(function()
            local selectedMap=voteSlots[i].mapName
            if selectedMap and selectedMap~="" then
                local slot=voteSlots[i]
                -- The clicked card is the authoritative target for Auto Vote.
                getgenv().DaDa_SelectedMapName = selectedMap
                getgenv().DaDa_MapPriority = selectedMap
                getgenv().DaDa_SelectedVoteModel = slot and slot.model or nil
                -- Restart the worker so it immediately re-reads the selected map.
                -- Selection is shared by Auto Vote and VoteDupe; restart either active worker.
                local restartAutoVote = SHF.mapvote
                local restartVoteDupe = SHF.mapvote_dupe
                if restartAutoVote or restartVoteDupe then
                    SHF.mapvote = false
                    SHF.mapvote_dupe = false
                    task.delay(0.12, function()
                        if voteCards and voteCards.Parent and getgenv().DaDa_SelectedMapName == selectedMap then
                            SHF.mapvote = restartAutoVote
                            SHF.mapvote_dupe = restartVoteDupe
                        end
                    end)
                end
                if notify then pcall(function() notify("Auto Vote","Selected map: "..selectedMap) end) end
            else
                if notify then pcall(function() notify("Auto Vote","Map not detected yet. Wait for the lobby cards to load.") end) end
            end
        end)
    end
    local function refreshVoteCards()
        local lobby=findVoteLobby()
        local padsRoot=lobby and deepFind(lobby,"VotePads")
        local candidates={}
        local seen={}
        local function addCandidate(model)
            if not model or seen[model] then return end
            local mapName=getMapTitle(model)
            if mapName then
                seen[model]=true
                local pad=deepFind(model,"Pad")
                if not (pad and pad:IsA("BasePart")) then
                    pad=model:IsA("BasePart") and model or model:FindFirstChildWhichIsA("BasePart",true)
                end
                local pos=pad and pad.Position or Vector3.zero
                candidates[#candidates+1]={name=mapName,image=getMapImage(model),model=model,x=pos.X,z=pos.Z}
            end
        end
        if padsRoot then
            -- The game's VotePads child order is the canonical slot order. Do not sort by
            -- map name or world coordinates: those can separate an image from its pad.
            for _,obj in ipairs(padsRoot:GetChildren()) do addCandidate(obj) end
            -- Some lobby variants wrap the three vote models in one extra folder.
            if #candidates==0 then
                for _,obj in ipairs(padsRoot:GetDescendants()) do
                    if obj.Name:match("VotePad%d*") or obj.Name:match("Detector%d*") then addCandidate(obj) end
                end
            end
        end
        if #candidates==0 and lobby then
            for _,obj in ipairs(lobby:GetDescendants()) do
                if obj.Name:match("VotePad%d*") or obj.Name:match("Detector%d*") then addCandidate(obj) end
            end
        end
        for i,slot in ipairs(voteSlots) do
            local entry=candidates[i]
            if entry then
                slot.mapName=entry.name
                slot.model=entry.model
                slot.name.Text=entry.name
                slot.image.Image=entry.image or ""
                slot.card.Visible=true
            else
                slot.mapName=nil
                slot.model=nil
                slot.name.Text="Waiting for map..."
                slot.image.Image=""
                slot.card.Visible=true
            end
        end
        voteHint.Text=(#candidates>0) and "Tap a map to prioritize Auto Vote" or "Waiting for lobby map cards..."
    end
    task.spawn(function()
        while voteCards.Parent do
            pcall(refreshVoteCards)
            task.wait(1)
        end
    end)

    -- Auto Farm controls for the existing farm engine.
    local farmPanel=makePanel(8,"left","Auto Farm")
    farmPanel:Toggle("Auto Farm Coins",false,function(v)
        farm_cfg.on=v
        if not v and farm_release then pcall(farm_release) end
        notify("Auto Farm",v and "Enabled" or "Disabled")
    end,"DaDaAutoFarm")
    farmPanel:Dropdown("Farm Mode",{"Basic","Down"},"Basic",function(v)
        farm_cfg.mode=v
        if v~="Down" and farm_release then pcall(farm_release) end
    end)
    farmPanel:Slider("Move Speed",23,8,40,function(v) farm_cfg.speed=v end)
    farmPanel:Slider("Down Depth",14,4,30,function(v) farm_cfg.down_depth=v end)
    farmPanel:Slider("Safe Rise Distance",20,5,60,function(v) farm_cfg.rise_safe_dist=v end)
    farmPanel:Toggle("Avoid Murderer",false,function(v) farm_cfg.avoid_murder=v end)
    farmPanel:Slider("Avoid Distance",40,10,100,function(v) farm_cfg.avoid_dist=v end)
    farmPanel:Toggle("Auto Reset When Full",false,function(v) farm_cfg.auto_reset=v end)

    -- FLING
    local fA=makePanel(2,"left","Fling")
    fA:Toggle("Fling On",false,function(v)
        if not SHF.fling_mini then
            notify("Fling","Ошибка: fling_mini не инициализирован")
            return
        end
        SHF.fling_mini.set_on(v)
        notify("Fling", v and "ON" or "OFF")
    end)
    fA:Dropdown("Mode",{"killer","murderer","sheriff","all","target"},"murderer",function(v)
        if SHF.fling_mini then SHF.fling_mini.set_mode(v) end
    end)
    local targetRow = Instance.new("TextButton")
    targetRow.Size = UDim2.new(1,0,0,20)
    targetRow.BackgroundColor3 = BG_ROW
    targetRow.BackgroundTransparency = ROW_TRANS
    targetRow.Text = "Target: none"
    targetRow.TextColor3 = TEXT_MAIN
    targetRow.TextSize = 10
    targetRow.Font = Enum.Font.Gotham
    targetRow.Parent = fA.body
    Instance.new("UICorner", targetRow).CornerRadius = UDim.new(0,4)
    local tList, tIdx = {}, 0
    targetRow.MouseButton1Click:Connect(function()
        tList = {}
        for _,p in ipairs(Players:GetPlayers()) do
            if p ~= LP then
                tList[#tList+1] = { name = p.Name, disp = p.DisplayName or p.Name }
            end
        end
        if #tList == 0 then
            targetRow.Text = "Target: no players"
            return
        end
        tIdx = tIdx % #tList + 1
        local t = tList[tIdx]
        if SHF.fling_mini then
            SHF.fling_mini.set_target(t.name)
            SHF.fling_mini.set_mode("target")
        end
        targetRow.Text = "Target: "..t.disp
    end)
    fA:Slider("Duration",2,1,5,function(v) if SHF.fling_mini then SHF.fling_mini.set_duration(v) end end)
    fA:Slider("Delay",15,1,50,function(v) if SHF.fling_mini then SHF.fling_mini.set_delay(v/100) end end)
    fA:Toggle("Bypass Velocity",false,function(v) if SHF.fling_mini then SHF.fling_mini.set_bypass(v) end end)
    fA:Toggle("Anti-Fling",false,function(v)
        ST.antifling = v
    end)
    fA:Button("Clear Target",function()
        if SHF.fling_mini then SHF.fling_mini.set_target(nil) end
        targetRow.Text = "Target: none"
    end)

    -- MOVEMENT
    local mA=makePanel(3,"left","Fly / Noclip")
    mA:Toggle("Fly",false,function(v) ST.fly=v; ST.quick_state.fly=v end,"fly")
    mA:Slider("Fly Speed",80,10,300,function(v) ST.fly_speed=v end)
    mA:Toggle("Noclip",false,function(v) ST.noclip=v end)
    mA:Toggle("Infinite Jump",false,function(v) ST.inf_jump=v; ST.quick_state.inf_jump=v end,"inf_jump")
    local mB=makePanel(3,"right","Speed / Jump / Bhop")
    mB:Toggle("Speed Hack",false,function(v) ST.speed_hack=v end)
    mB:Slider("WalkSpeed",32,16,300,function(v) ST.speed_val=v end)
    mB:Toggle("Jump Power",false,function(v) ST.jump_power=v end)
    mB:Slider("JumpPower",80,50,500,function(v) ST.jump_val=v end)
    mB:Toggle("Bhop",false,function(v) ST.bhop=v; ST.quick_state.bhop=v end,"bhop")
    mB:Slider("Bhop Power",120,10,300,function(v) ST.bhop_power=v end)
    mB:Toggle("Auto Strafe",true,function(v) ST.bhop_strafe=v end)
    mB:Toggle("Gravity",false,function(v) ST.gravity=v end)
    mB:Slider("Gravity",196,0,500,function(v) ST.gravity_val=v end)
    mB:Toggle("Double Jump",false,function(v)
        if getgenv().DADA_DOUBLEJUMP_TOGGLE then
            getgenv().DADA_DOUBLEJUMP_TOGGLE(v)
        end
    end)

    -- VISUALS
    local vA=makePanel(4,"left","ESP")
    vA:Toggle("ESP",false,function(v) ST.esp_on=v; ST.quick_state.esp=v end,"esp")
    vA:Toggle("Box",true,function(v) ST.esp_box=v end)
    vA:Toggle("Name",true,function(v) ST.esp_name=v end)
    vA:Toggle("Distance",true,function(v) ST.esp_dist=v end)
    vA:Toggle("Health Bar",true,function(v) ST.esp_health=v end)
    local vB=makePanel(4,"right","ESP Extras")
    vB:Toggle("Skeleton",false,function(v) ST.esp_skel=v end)
    vB:Toggle("Snapline",false,function(v) ST.esp_line=v end)
    vB:Toggle("Chams",false,function(v) ST.esp_chams=v end)
    vB:Toggle("Flags",false,function(v) ST.esp_flags=v end)
    vB:Slider("Max Distance",1000,100,3000,function(v) ST.esp_max_dist=v end)

    -- WORLD
    local wA=makePanel(5,"left","Visuals")
    wA:Toggle("Fullbright",false,function(v) ST.fullbright=v end)
    wA:Toggle("FOV Changer",false,function(v) ST.fov_changer=v end)
    wA:Slider("FOV",90,30,120,function(v) ST.fov_value=v end)
    wA:Toggle("World Color",false,function(v) ST.world_color=v end)
    wA:Toggle("Transparency",false,function(v) ST.char_transparency=v end)
    wA:Slider("Transp Val",0.3,0,0.9,function(v) ST.char_trans_val=v end)
    local wB=makePanel(5,"right","Skybox")
    local visualPresetNames = {"Off"}
    table.insert(visualPresetNames, "Arctic")
    table.insert(visualPresetNames, "Aurora")
    table.insert(visualPresetNames, "Moonlight")
    table.insert(visualPresetNames, "Deep Space")
    table.insert(visualPresetNames, "Nebula")
    table.insert(visualPresetNames, "Red Eclipse")
    table.insert(visualPresetNames, "Crimson Night")
    table.insert(visualPresetNames, "Purple Haze")
    table.insert(visualPresetNames, "Violet Dream")
    table.insert(visualPresetNames, "Cyberpunk")
    table.insert(visualPresetNames, "Neon City")
    table.insert(visualPresetNames, "Toxic Green")
    table.insert(visualPresetNames, "Emerald")
    table.insert(visualPresetNames, "Forest")
    table.insert(visualPresetNames, "Jungle")
    table.insert(visualPresetNames, "Sakura")
    table.insert(visualPresetNames, "Blossom")
    table.insert(visualPresetNames, "Rose Gold")
    table.insert(visualPresetNames, "Candy")
    table.insert(visualPresetNames, "Cotton Candy")
    table.insert(visualPresetNames, "Sunset")
    table.insert(visualPresetNames, "Golden Hour")
    table.insert(visualPresetNames, "Desert")
    table.insert(visualPresetNames, "Sandstorm")
    table.insert(visualPresetNames, "Volcano")
    table.insert(visualPresetNames, "Magma")
    table.insert(visualPresetNames, "Ocean")
    table.insert(visualPresetNames, "Deep Ocean")
    table.insert(visualPresetNames, "Tropical")
    table.insert(visualPresetNames, "Beach")
    table.insert(visualPresetNames, "Storm")
    table.insert(visualPresetNames, "Thunder")
    table.insert(visualPresetNames, "Foggy")
    table.insert(visualPresetNames, "Mystic Fog")
    table.insert(visualPresetNames, "Haunted")
    table.insert(visualPresetNames, "Halloween")
    table.insert(visualPresetNames, "Blood Moon")
    table.insert(visualPresetNames, "Ghost Blue")
    table.insert(visualPresetNames, "Silver Moon")
    table.insert(visualPresetNames, "Dark Matter")
    table.insert(visualPresetNames, "Classic")
    table.insert(visualPresetNames, "Vintage")
    table.insert(visualPresetNames, "Sepia")
    table.insert(visualPresetNames, "Monochrome")
    table.insert(visualPresetNames, "Soft Pastel")
    table.insert(visualPresetNames, "Dreamy")
    table.insert(visualPresetNames, "Heavenly")
    table.insert(visualPresetNames, "Celestial")
    table.insert(visualPresetNames, "Fairy Garden")
    table.insert(visualPresetNames, "Magic Hour")
    table.insert(visualPresetNames, "New Year")
    table.insert(visualPresetNames, "Winter Night")
    table.insert(visualPresetNames, "Snowfall")
    table.insert(visualPresetNames, "Frozen Lake")
    table.insert(visualPresetNames, "Holiday Lights")
    table.insert(visualPresetNames, "Spring")
    table.insert(visualPresetNames, "Summer")
    table.insert(visualPresetNames, "Autumn")
    table.insert(visualPresetNames, "Rainy Day")
    table.insert(visualPresetNames, "Midnight")
    -- Preset picker with a separate ON/OFF switch.
    local selectedVisualPreset = "Arctic"
    local visualPresetsEnabled = false
    table.insert(visualPresetNames, "Cherry Blossom")
    table.insert(visualPresetNames, "Ice Crystal")
    table.insert(visualPresetNames, "Electric Blue")
    table.insert(visualPresetNames, "Lava Flow")
    table.insert(visualPresetNames, "Mint Glow")
    table.insert(visualPresetNames, "Royal Gold")
    table.insert(visualPresetNames, "Ocean Pearl")
    table.insert(visualPresetNames, "Plum Night")
    table.insert(visualPresetNames, "Polar Night")
    table.insert(visualPresetNames, "Lavender Sky")
    table.insert(visualPresetNames, "Coral Reef")
    table.insert(visualPresetNames, "Lime Circuit")
    table.insert(visualPresetNames, "Blue Hour")
    table.insert(visualPresetNames, "Rose Storm")
    table.insert(visualPresetNames, "Silver Frost")
    table.insert(visualPresetNames, "Amber Dusk")
    table.insert(visualPresetNames, "Galaxy Pink")
    table.insert(visualPresetNames, "Deep Teal")
    table.insert(visualPresetNames, "Misty Pine")
    table.insert(visualPresetNames, "Whiteout")
    table.insert(visualPresetNames, "Night Drive")
    table.insert(visualPresetNames, "Prism")
    table.insert(visualPresetNames, "Peach Glow")
    table.insert(visualPresetNames, "Rainforest")
    table.insert(visualPresetNames, "Blue Lagoon")
    table.insert(visualPresetNames, "Dark Cherry")
    table.insert(visualPresetNames, "Sunrise Mist")
    table.insert(visualPresetNames, "Cosmic Gold")
    table.insert(visualPresetNames, "Cyan Pulse")
    table.insert(visualPresetNames, "Velvet Purple")
    table.remove(visualPresetNames, 1) -- remove Off from the selectable preset list
    wB:Dropdown("Choose Visual Preset", visualPresetNames, selectedVisualPreset, function(v)
        selectedVisualPreset = v
        if visualPresetsEnabled and SHF.applyVisualPreset then
            SHF.applyVisualPreset(selectedVisualPreset)
        end
    end)
    wB:Toggle("Visual Presets ON/OFF", false, function(v)
        visualPresetsEnabled = v
        if v then
            if SHF.applyVisualPreset then SHF.applyVisualPreset(selectedVisualPreset) end
        else
            if SHF.clearVisualPreset then SHF.clearVisualPreset() end
        end
    end)
    wB:Dropdown("Skybox",{"Default","Space","Red","Purple"},"Default",function(v)
        ST.skybox=v
        local f=getgenv().DaDa_apply_skybox; if f then f(v) end
    end)
    local wC=makePanel(5,"left","Shaders")
    wC:Toggle("Shaders",false,function(v) SHF.shaders=v end)
    wC:Dropdown("Preset",{"morning","midday","evening","night"},"morning",function(v) SHF.shader_type=v end)
    wC:Toggle("Fog",false,function(v) SHF.fog=v end)
    wC:Toggle("Ambient",false,function(v) SHF.ambient=v end)
    wC:Toggle("Exposure",false,function(v) SHF.exposure=v end)

    -- Extra local-only post-processing visuals
    local localFx = {}
    local function setLocalFx(key, className, enabled, configure)
        local effect = localFx[key]
        if enabled then
            if not effect or not effect.Parent then
                effect = Instance.new(className)
                effect.Name = "DaDa_Local_" .. key
                effect.Parent = Lighting
                localFx[key] = effect
            end
            if configure then pcall(configure, effect) end
            effect.Enabled = true
        elseif effect then
            pcall(function() effect.Enabled = false end)
        end
    end
    wC:Toggle("Bloom",false,function(v)
        SHF.local_bloom=v
        setLocalFx("Bloom", "BloomEffect", v, function(e)
            e.Intensity=0.35; e.Size=24; e.Threshold=1.1
        end)
    end)
    wC:Toggle("Color Correction",false,function(v)
        SHF.local_color_correction=v
        setLocalFx("ColorCorrection", "ColorCorrectionEffect", v, function(e)
            e.Brightness=0.02; e.Contrast=0.08; e.Saturation=0.12
            e.TintColor=Color3.fromRGB(235,225,255)
        end)
    end)
    wC:Toggle("Sun Rays",false,function(v)
        SHF.local_sunrays=v
        setLocalFx("SunRays", "SunRaysEffect", v, function(e)
            e.Intensity=0.04; e.Spread=0.75
        end)
    end)
    wC:Toggle("Depth of Field",false,function(v)
        SHF.local_dof=v
        setLocalFx("DepthOfField", "DepthOfFieldEffect", v, function(e)
            e.FarIntensity=0.08; e.FocusDistance=35; e.InFocusRadius=25; e.NearIntensity=0
        end)
    end)

    local wD=makePanel(5,"right","Skybox / FX")
    wD:Toggle("Premium Skybox",false,function(v)
        SHF.prem_skybox=v
        if v and SHF.applyPremSky then SHF.applyPremSky(SHF.prem_skybox_name)
        elseif SHF.clearPremSky then SHF.clearPremSky() end
    end)
    wD:Dropdown("Premium Preset",{"Jungle","Blossom","RedNight","Purple","Foggy"},"Jungle",function(v)
        SHF.prem_skybox_name=v
        if SHF.prem_skybox and SHF.applyPremSky then SHF.applyPremSky(v) end
    end)
    wD:Toggle("World FX",false,function(v) SHF.world_fx=v end)
    wD:Dropdown("World FX Type",{"Snow","Sakura"},"Snow",function(v) SHF.world_fx_type=v end)

    wD:Toggle("Aura",false,function(v)
        SHF.aura=v
        if v and SHF.applyAura then SHF.applyAura()
        elseif SHF.clearAura then SHF.clearAura() end
    end)
    wD:Dropdown("Aura Type",{"angel","wind","starlight","heavenly","aurora","flame","frost","rose","void","emerald","solar","lunar","ocean","toxic","sakura","plasma","storm","ember","crystal","rainbow","shadow","mint","coral","gold","sapphire","amethyst","pearl","cinder","breeze","comet","stardust","aurum","glacier","dream"},"angel",function(v)
        SHF.aura_type=v
        if SHF.aura and SHF.applyAura then SHF.applyAura() end
    end)

    local wE=makePanel(5,"left","Aura v2")
    wE:Toggle("Aura v2",false,function(v)
        SHF.aura2 = v
        if type(SHF.aura2Toggle) == "function" then
            local ok, err = pcall(SHF.aura2Toggle, v)
            if not ok then warn("[DaDa] Aura v2 toggle: " .. tostring(err)) end
        elseif not v and type(SHF.clearAura2) == "function" then
            pcall(SHF.clearAura2)
        end
    end)
    wE:Dropdown("Type",{"angel","starlight","heavenly","ribbon","sakura","wind","flow","star"},"angel",function(v)
        if SHF.aura2Type then SHF.aura2Type(v) end
    end)

    -- Local-only custom gun model changer based on the Gun Model catalog
    -- from MM2.readable.luau.txt. This changes only the local visual model.
    local wF=makePanel(5,"right","Gun Model Changer")
    local gunModelEnabled = false
    local selectedGunModel = "AWP"
    local gunModelCache = {}
    local gunModelRecords = setmetatable({}, {__mode="k"})

    local gunModelCatalog = {
        ["AWP"] = {id="4531395275", rot=CFrame.Angles(0,0,0), pos=CFrame.new(0,0,-0.5)},
        ["Pistol"] = {id="5102714039", rot=CFrame.Angles(0,math.pi,0), pos=CFrame.new(0,0,0.5)},
        ["Shotgun"] = {id="5294131243", rot=CFrame.Angles(0,math.pi,0), pos=CFrame.new(0,0,0.8)},
        ["RayGun"] = {id="542699703", rot=CFrame.Angles(0,math.pi,0), pos=CFrame.new(0,0,0.2)},
        ["AK-47"] = {id="127200798279812", rot=CFrame.Angles(math.pi/2,0,-math.pi/2), pos=CFrame.new(0,-0.3,0.3)},
        ["PinkGun"] = {id="18610978709", rot=CFrame.Angles(0,0,0), pos=CFrame.new(0,0,-0.3)},
        ["FlameGun"] = {id="10656806096", rot=CFrame.Angles(-math.pi/2,math.pi/2,math.pi/2), pos=CFrame.new(2.1,0,-0.3)},
        ["MiniBlackGun"] = {id="62932622", rot=CFrame.Angles(math.pi/2,0,0), pos=CFrame.new(0,0,0)},
        ["BlueGun"] = {id="87594143804300", rot=CFrame.Angles(-math.pi/2,math.pi/2,math.pi/2), pos=CFrame.new(0,-0.3,0.5)},
        ["BigUSP-S"] = {id="12899296613", rot=CFrame.Angles(math.pi/2,0,0), pos=CFrame.new(0,-0.3,0)},
        ["GreenGun"] = {id="1297856838", rot=CFrame.Angles(0,0,0), pos=CFrame.new(0,-0.3,-1.3)},
    }

    local function loadGunModelAsset(modelName)
        local cached = gunModelCache[modelName]
        if cached and cached.Parent == nil then
            local okClone, cloned = pcall(function() return cached:Clone() end)
            if okClone and cloned then return cloned end
        end

        local config = gunModelCatalog[modelName]
        if not config then return nil, "Unknown gun model" end
        local okLoad, objects = pcall(function()
            return game:GetObjects("rbxassetid://" .. config.id)
        end)
        if not okLoad or type(objects) ~= "table" or not objects[1] then
            return nil, "Could not load model asset " .. tostring(config.id)
        end

        local source = objects[1]
        pcall(function() source.Parent = nil end)
        for i = 2, #objects do
            pcall(function() objects[i]:Destroy() end)
        end
        gunModelCache[modelName] = source
        local okClone, cloned = pcall(function() return source:Clone() end)
        if not okClone or not cloned then
            return nil, "Could not clone model asset"
        end
        return cloned
    end

    local function resolveGunModel(cloned)
        if cloned:IsA("Model") or cloned:IsA("BasePart") then
            return cloned
        end
        local root = cloned:FindFirstChildWhichIsA("BasePart", true)
        if not root then
            pcall(function() cloned:Destroy() end)
            return nil
        end
        local wrapper = Instance.new("Model")
        wrapper.Name = "DaDaCustomGunModel"
        cloned.Parent = wrapper
        wrapper.PrimaryPart = root
        return wrapper
    end

    local function restoreGunModel(tool)
        local record = gunModelRecords[tool]
        if not record then return end
        if record.visual then pcall(function() record.visual:Destroy() end) end
        for instance, saved in pairs(record.hidden or {}) do
            if instance and instance.Parent then
                pcall(function()
                    if saved.Transparency ~= nil then instance.Transparency = saved.Transparency end
                    if saved.LocalTransparencyModifier ~= nil then instance.LocalTransparencyModifier = saved.LocalTransparencyModifier end
                end)
            end
        end
        gunModelRecords[tool] = nil
    end

    local function restoreAllGunModels()
        local toRestore = {}
        for tool in pairs(gunModelRecords) do table.insert(toRestore, tool) end
        for _, tool in ipairs(toRestore) do restoreGunModel(tool) end
    end

    local function getEquippedGun()
        local character = LP and LP.Character
        if not character then return nil end
        local tool = character:FindFirstChild("Gun")
        if tool and tool:IsA("Tool") then return tool end
        return nil
    end

    local function applyGunModelToTool(tool, quiet)
        if not gunModelEnabled or not tool or not tool.Parent then return false end
        if not tool:IsA("Tool") or tool.Name ~= "Gun" then return false end
        local character = LP and LP.Character
        if not character or tool.Parent ~= character then return false end

        local hand = character:FindFirstChild("RightHand") or character:FindFirstChild("Right Arm")
        if not hand or not hand:IsA("BasePart") then
            if not quiet then notify("Gun Model", "Could not find the character's right hand") end
            return false
        end

        local recordNow = gunModelRecords[tool]
        if recordNow and recordNow.modelName == selectedGunModel and recordNow.visual and recordNow.visual.Parent then
            return true
        end
        restoreGunModel(tool)

        local config = gunModelCatalog[selectedGunModel]
        if not config then return false end
        local cloned, loadError = loadGunModelAsset(selectedGunModel)
        if not cloned then
            if not quiet then notify("Gun Model", tostring(loadError)) end
            return false
        end
        local visual = resolveGunModel(cloned)
        if not visual then
            if not quiet then notify("Gun Model", "The selected asset has no usable parts") end
            return false
        end

        local root
        if visual:IsA("BasePart") then
            root = visual
        elseif visual:IsA("Model") then
            root = visual.PrimaryPart or visual:FindFirstChild("Handle") or visual:FindFirstChildWhichIsA("BasePart", true)
            if root and not visual.PrimaryPart then
                pcall(function() visual.PrimaryPart = root end)
            end
        end
        if not root or not root:IsA("BasePart") then
            pcall(function() visual:Destroy() end)
            if not quiet then notify("Gun Model", "The selected model has no root part") end
            return false
        end

        local torso = character:FindFirstChild("UpperTorso")
        local handOffset
        if torso then
            handOffset = CFrame.new(0,-0.25,-0.1) * CFrame.Angles(-math.pi/2,0,0)
        else
            handOffset = CFrame.new(0,-1,-0.1) * CFrame.Angles(-math.pi/2,0,0)
        end
        local targetCFrame = hand.CFrame * handOffset * config.rot * config.pos

        pcall(function()
            if visual:IsA("Model") then
                visual:PivotTo(targetCFrame)
            else
                visual.CFrame = targetCFrame
            end
        end)

        for _, part in ipairs(visual:GetDescendants()) do
            if part:IsA("BasePart") then
                pcall(function()
                    part.CanCollide = false
                    part.CanTouch = false
                    part.CanQuery = false
                    part.Massless = true
                    part.Anchored = false
                end)
                if part ~= root then
                    local weld = Instance.new("WeldConstraint")
                    weld.Part0 = root
                    weld.Part1 = part
                    weld.Parent = part
                end
            end
        end
        pcall(function()
            root.CanCollide = false
            root.CanTouch = false
            root.CanQuery = false
            root.Massless = true
            root.Anchored = false
        end)
        local handWeld = Instance.new("WeldConstraint")
        handWeld.Name = "DaDaGunModelWeld"
        handWeld.Part0 = hand
        handWeld.Part1 = root
        handWeld.Parent = root
        visual.Name = "CustomGunModel"
        visual.Parent = tool

        local hidden = {}
        for _, instance in ipairs(tool:GetDescendants()) do
            if instance ~= visual and not instance:IsDescendantOf(visual) then
                if instance:IsA("BasePart") then
                    hidden[instance] = {
                        Transparency = instance.Transparency,
                        LocalTransparencyModifier = instance.LocalTransparencyModifier,
                    }
                    pcall(function()
                        instance.Transparency = 1
                        instance.LocalTransparencyModifier = 1
                    end)
                elseif instance:IsA("Decal") or instance:IsA("Texture") then
                    hidden[instance] = {Transparency = instance.Transparency}
                    pcall(function() instance.Transparency = 1 end)
                end
            end
        end
        gunModelRecords[tool] = {visual=visual, hidden=hidden, modelName=selectedGunModel}
        if not quiet then notify("Gun Model", "Selected: " .. selectedGunModel) end
        return true
    end

    local function refreshGunModel(quiet)
        if not gunModelEnabled then
            restoreAllGunModels()
            return
        end
        local tool = getEquippedGun()
        if tool then
            applyGunModelToTool(tool, quiet)
        end
    end

    local gunModelToggleFlag = "DaDaWorldGunModel"
    wF:Toggle("Custom Gun Model",false,function(v)
        gunModelEnabled = v
        if v then
            refreshGunModel(false)
            if not getEquippedGun() then
                notify("Gun Model", "Enabled. Equip the Gun tool to apply the selected model")
            end
        else
            restoreAllGunModels()
            notify("Gun Model", "Original gun model restored")
        end
    end, gunModelToggleFlag)
    wF:Dropdown("Select Model",{"AWP","Pistol","Shotgun","RayGun","AK-47","PinkGun","FlameGun","MiniBlackGun","BlueGun","BigUSP-S","GreenGun"},"AWP",function(v)
        selectedGunModel = v
        if gunModelEnabled then refreshGunModel(false) end
    end)
    wF:Button("Apply Selected Model",function()
        gunModelEnabled = true
        if uiRegistry[gunModelToggleFlag] then uiRegistry[gunModelToggleFlag](true) end
        refreshGunModel(false)
        if not getEquippedGun() then
            notify("Gun Model", "Selected. Equip the Gun tool to see the model")
        end
    end)
    wF:Button("Restore Original Gun",function()
        gunModelEnabled = false
        if uiRegistry[gunModelToggleFlag] then uiRegistry[gunModelToggleFlag](false) end
        restoreAllGunModels()
        notify("Gun Model", "Original gun model restored")
    end)

    local function watchGunModelCharacter(character)
        if not character then return end
        character.ChildAdded:Connect(function(child)
            if child:IsA("Tool") and child.Name == "Gun" then
                task.wait(0.15)
                if gunModelEnabled then applyGunModelToTool(child, true) end
            end
        end)
        character.ChildRemoved:Connect(function(child)
            if child:IsA("Tool") and gunModelRecords[child] then
                restoreGunModel(child)
            end
        end)
        task.defer(function()
            task.wait(0.6)
            if gunModelEnabled then
                local tool = character:FindFirstChild("Gun")
                if tool and tool:IsA("Tool") then applyGunModelToTool(tool, true) end
            end
        end)
    end
    if LP.Character then watchGunModelCharacter(LP.Character) end
    LP.CharacterAdded:Connect(function(character)
        task.wait(0.8)
        watchGunModelCharacter(character)
    end)

    -- Gun Beam: use the actual GunFired event, so aiming/mouse movement never draws a beam.
    -- Each confirmed shot gets its own trail and is removed after 3.5 seconds.
    local beamEnabled=false
    local beamColor=Color3.fromRGB(190,90,255)
    local beamStyle="Neon"
    local shotHookConn
    local activeShotBeams={}
    local function clearGunBeam()
        if shotHookConn then shotHookConn:Disconnect(); shotHookConn=nil end
        for i,obj in ipairs(activeShotBeams) do
            if obj then
                if obj.startPart then pcall(function() obj.startPart:Destroy() end) end
                if obj.endPart then pcall(function() obj.endPart:Destroy() end) end
            end
            activeShotBeams[i]=nil
        end
    end
    local function createShotBeam(posA,posB)
        if not beamEnabled or typeof(posA)~="Vector3" or typeof(posB)~="Vector3" then return end
        local ok,shot=pcall(function()
            local startPart=Instance.new("Part")
            startPart.Name="DaDaGunBeamShotStart"
            startPart.Anchored=true
            startPart.CanCollide=false
            startPart.CanTouch=false
            startPart.CanQuery=false
            startPart.Transparency=1
            startPart.Size=Vector3.new(0.05,0.05,0.05)
            startPart.Position=posA
            startPart.Parent=workspace

            local endPart=Instance.new("Part")
            endPart.Name="DaDaGunBeamShotEnd"
            endPart.Anchored=true
            endPart.CanCollide=false
            endPart.CanTouch=false
            endPart.CanQuery=false
            endPart.Transparency=1
            endPart.Size=Vector3.new(0.05,0.05,0.05)
            endPart.Position=posB
            endPart.Parent=workspace

            local a0=Instance.new("Attachment")
            a0.Name="DaDaGunBeamShotStartAttachment"
            a0.Parent=startPart
            local a1=Instance.new("Attachment")
            a1.Name="DaDaGunBeamShotEndAttachment"
            a1.Parent=endPart
            local beam=Instance.new("Beam")
            beam.Name="DaDaGunBeamShot"
            beam.Attachment0=a0
            beam.Attachment1=a1
            beam.Color=ColorSequence.new(beamColor)
            beam.Width0=0.08
            beam.Width1=0.025
            beam.FaceCamera=true
            beam.LightEmission=1
            beam.TextureSpeed=2
            beam.Transparency=NumberSequence.new(0.08)
            if beamStyle=="Neon" then
                beam.LightInfluence=0
            elseif beamStyle=="Thin" then
                beam.Width0=0.025; beam.Width1=0.01
            elseif beamStyle=="Pulse" then
                beam.Width0=0.12; beam.Width1=0.04
                beam.Texture="rbxasset://textures/particles/sparkles_main.dds"
            end
            beam.Parent=startPart
            return {startPart=startPart,endPart=endPart}
        end)
        if not ok or not shot then return end
        table.insert(activeShotBeams,shot)
        task.delay(3.5,function()
            for i,obj in ipairs(activeShotBeams) do
                if obj==shot then table.remove(activeShotBeams,i); break end
            end
            if shot.startPart then pcall(function() shot.startPart:Destroy() end) end
            if shot.endPart then pcall(function() shot.endPart:Destroy() end) end
        end)
    end
    local function setupGunBeam()
        if shotHookConn then shotHookConn:Disconnect(); shotHookConn=nil end
        if not beamEnabled then return end
        local ok,remote=pcall(function()
            return ReplicatedStorage:WaitForChild("ClientServices"):WaitForChild("WeaponService"):WaitForChild("GunFired")
        end)
        if not ok or not remote then return end
        shotHookConn=remote.OnClientEvent:Connect(function(gun,posA,posB)
            if not beamEnabled then return end
            createShotBeam(posA,posB)
        end)
    end
    vB:Toggle("Gun Beam",false,function(v)
        beamEnabled=v
        if v then setupGunBeam() else clearGunBeam() end
    end,"DaDaGunBeam")
    vB:Dropdown("Beam Style",{"Neon","Thin","Pulse"},"Neon",function(v)
        beamStyle=v
    end)
    vB:Dropdown("Beam Color",{"Purple","Red","Blue","Green","White","Gold"},"Purple",function(v)
        local colors={Purple=Color3.fromRGB(190,90,255),Red=Color3.fromRGB(255,65,80),Blue=Color3.fromRGB(70,155,255),Green=Color3.fromRGB(80,255,140),White=Color3.fromRGB(245,245,255),Gold=Color3.fromRGB(255,190,65)}
        beamColor=colors[v] or colors.Purple
    end)

    -- EXTRAS
    local eA=makePanel(6,"left","Visuals Extras")
    eA:Toggle("Bullet Tracer",false,function(v) SHF.tracer=v end)
    eA:Toggle("Crosshair",false,function(v) SHF.crosshair=v end)
    eA:Toggle("China Hat",false,function(v) SHF.china_hat=v end)
    eA:Toggle("Self Chams",false,function(v) SHF.self_chams=v end)
    eA:Toggle("Tool Chams",false,function(v) SHF.tool_chams=v end)
    eA:Toggle("Landing Circle",false,function(v)
        SHF.landing_circle=v
        if v and SHF.lc_bind then SHF.lc_bind() end
    end)
    eA:Toggle("Gun ESP",false,function(v) SHF.gun_esp=v; SHF.gun_esp_text=v; SHF.gun_esp_hl=v end)
    eA:Toggle("Aspect Ratio",false,function(v) SHF.aspect=v end)
    eA:Slider("Aspect %",100,1,100,function(v)
        if SHF.setAspect then SHF.setAspect(v) end
    end)
    eA:Toggle("Invisible",false,function(v)
        SHF.invis=v
        if not v and SHF.clearInvis then SHF.clearInvis() end
    end)
    eA:Dropdown("Invis Mode",{"Ghost","Full"},"Ghost",function(v) SHF.invis_mode=v end)

    eA:Toggle("Invis v2",false,function(v)
        if SHF.invis2Toggle then SHF.invis2Toggle(v) end
    end)

    eA:Toggle("Hitbox Expander",false,function(v) SHF.hitbox=v end)
    eA:Slider("Hitbox Size",5,1,15,function(v) SHF.hitbox_size=v end)
    -- Avatar cosmetics are client-side only; they do not change the Roblox account avatar.
    local avatarPanel=makePanel(6,"right","Avatar")
    local avatarHighlightEnabled=false
    local avatarHighlightColor=Color3.fromRGB(190,90,255)
    local avatarHighlight
    local function updateAvatarHighlight()
        if avatarHighlight then pcall(function() avatarHighlight:Destroy() end); avatarHighlight=nil end
        local char=LP.Character
        if not avatarHighlightEnabled or not char then return end
        avatarHighlight=Instance.new("Highlight")
        avatarHighlight.Name="DaDaAvatarHighlight"
        avatarHighlight.FillColor=avatarHighlightColor
        avatarHighlight.OutlineColor=avatarHighlightColor
        avatarHighlight.FillTransparency=0.72
        avatarHighlight.OutlineTransparency=0.08
        avatarHighlight.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
        avatarHighlight.Parent=char
    end
    avatarPanel:Toggle("Avatar Glow",false,function(v)
        avatarHighlightEnabled=v
        updateAvatarHighlight()
        if v then notify("Avatar","Local avatar glow enabled") else notify("Avatar","Avatar glow disabled") end
    end,"DaDaAvatarGlow")
    avatarPanel:Dropdown("Glow Color",{"Purple","Red","Blue","Green","White","Gold"},"Purple",function(v)
        local colors={Purple=Color3.fromRGB(190,90,255),Red=Color3.fromRGB(255,65,80),Blue=Color3.fromRGB(70,155,255),Green=Color3.fromRGB(80,255,140),White=Color3.fromRGB(245,245,255),Gold=Color3.fromRGB(255,190,65)}
        avatarHighlightColor=colors[v] or colors.Purple
        if avatarHighlightEnabled then updateAvatarHighlight() end
    end)
    LP.CharacterAdded:Connect(function() task.wait(0.5); if avatarHighlightEnabled then updateAvatarHighlight() end end)

    -- Trade Helper: alert when a trade-related panel/prompt appears locally.
    local tradePanel=makePanel(6,"right","Trade Helper")
    local tradeHelperEnabled=false
    local lastTradeNotice=0
    local function scanTradeUI()
        if not tradeHelperEnabled then return end
        local pg=LP:FindFirstChildOfClass("PlayerGui")
        if not pg then return end
        for _,obj in ipairs(pg:GetDescendants()) do
            if (obj:IsA("GuiObject") and obj.Visible) or obj:IsA("ProximityPrompt") then
                local nm=(tostring(obj.Name).." "..tostring(obj.Parent and obj.Parent.Name or "")):lower()
                if nm:find("trade",1,true) or nm:find("exchange",1,true) then
                    if os.clock()-lastTradeNotice>8 then
                        lastTradeNotice=os.clock()
                        notify("Trade Helper","Trade interface detected")
                    end
                    return
                end
            end
        end
    end
    tradePanel:Toggle("Trade Alerts",false,function(v)
        tradeHelperEnabled=v
        if v then scanTradeUI(); notify("Trade Helper","Alerts enabled") else notify("Trade Helper","Alerts disabled") end
    end,"DaDaTradeHelper")
    tradePanel:Button("Check Trade UI",function()
        local old=tradeHelperEnabled
        tradeHelperEnabled=true
        scanTradeUI()
        tradeHelperEnabled=old
        if os.clock()-lastTradeNotice>1 then notify("Trade Helper","No trade interface detected") end
    end)
    task.spawn(function()
        while gui and gui.Parent do
            if tradeHelperEnabled then pcall(scanTradeUI) end
            task.wait(2)
        end
    end)

    local eB=makePanel(6,"right","Sounds")
    eB:Toggle("Gunshot Sound",false,function(v) SHF.gunshot_sound=v; if v then snd_preload(SHF.gunshot_sound_name); silenceOriginalGunshot() end end)
    eB:Dropdown("Gunshot Style",SHF.snd_list or {"mc bow"},SHF.gunshot_sound_name,function(v) SHF.gunshot_sound_name=v; snd_preload(v) end)
    eB:Slider("Gunshot Vol",1,0,10,function(v) SHF.gunshot_sound_vol=v end)
    eB:Toggle("Sheriff Kill Sound",false,function(v) SHF.sheriff_sound=v end)
    eB:Dropdown("Sheriff Sound",SHF.snd_list or {"mc bow"},SHF.sheriff_sound_name,function(v) SHF.sheriff_sound_name=v; snd_preload(v) end)
    eB:Slider("Sheriff Vol",1,0,10,function(v) SHF.sheriff_sound_vol=v end)
    eB:Toggle("Murder Kill Sound",false,function(v) SHF.kill_sound=v end)
    eB:Dropdown("Murder Sound",SHF.snd_list or {"skeet"},SHF.kill_sound_name,function(v) SHF.kill_sound_name=v; snd_preload(v) end)
    eB:Slider("Murder Vol",1,0,10,function(v) SHF.kill_sound_vol=v end)
    local eC=makePanel(6,"left","Combat Extras")
    eC:Toggle("No Recoil",false,function(v) SHF.no_recoil=v end)
    eC:Toggle("No Spread",false,function(v) SHF.no_spread=v end)
    eC:Toggle("Auto Reload",false,function(v) SHF.auto_reload=v end)
    eC:Toggle("Auto Click",false,function(v) SHF.auto_click=v end)
    eC:Slider("Click Delay",1,1,10,function(v) SHF.auto_click_delay=v/10 end)
    eC:Toggle("Auto Heal",false,function(v) SHF.auto_heal=v end)
    eC:Slider("Heal Threshold %",50,10,90,function(v) SHF.auto_heal_threshold=v end)
    eC:Toggle("Auto Dodge",false,function(v) SHF.auto_dodge=v end)
    eC:Slider("Dodge Range",20,5,50,function(v) SHF.auto_dodge_range=v end)
    eC:Toggle("Anti Swap",false,function(v) SHF.anti_swap=v end)
    eC:Toggle("Anti Void",false,function(v) SHF.anti_void=v end)
    eC:Toggle("Anti AFK",false,function(v) SHF.anti_afk=v end)
    eC:Toggle("Anti Trap",false,function(v) SHF.anti_trap=v end)
    eC:Toggle("Auto Respawn",false,function(v) SHF.auto_respawn=v end)
    eC:Slider("Respawn Delay",3,1,10,function(v) SHF.auto_respawn_delay=v end)
    local eD=makePanel(6,"right","Skins / Anims")
    eD:Dropdown("Gun Skin",{"None","Default","Golden","Rainbow","Neon","Dark","Blood"},"None",function(v) SHF.gun_skin=v end)
    eD:Dropdown("Knife Skin",{"None","Default","Golden","Neon","Blood","Shadow"},"None",function(v) SHF.knife_skin=v end)
    eD:Dropdown("Anim Pack",{"Default","Ninja","Zombie","Pirate","Robot"},"Default",function(v)
        SHF.anim_pack=v
        if v~="Default" and SHF.applyAnim then SHF.applyAnim(v) end
    end)
    eD:Toggle("Round Notify",false,function(v) SHF.round_notify=v end)
    eD:Toggle("Killer Notify",false,function(v) SHF.killer_notify=v end)

    -- ANIMATIONS (новая панель)
    local eE=makePanel(6,"right","Animations")
    eE:Dropdown("Category",{"all","idle","walk","run","jump","fall","climb","swim","swimidle"},"all",function(v)
        getgenv().DADA_ANIM_CAT = v
    end)
    eE:Dropdown("Animation",{"loading..."},"loading...",function(v)
        local fn = getgenv().DADA_ANIM_APPLY
        if fn then pcall(fn, v) end
    end)
    eE:Button("Reset Animations",function()
        local fn = getgenv().DADA_ANIM_RESET
        if fn then pcall(fn) end
    end)

    -- EMOTES (новая панель)
    local eF=makePanel(6,"left","Emotes")
    eF:Dropdown("Emote",{"loading..."},"loading...",function(v)
        local fn = getgenv().DADA_EMOTE_PLAY
        if fn then pcall(fn, v) end
    end)
    eF:Button("Stop Emote",function()
        local fn = getgenv().DADA_EMOTE_STOP
        if fn then pcall(fn) end
    end)

    -- CONFIG
    local cfgA=makePanel(7,"left","Config")
    cfgA:Dropdown("Theme",{"Halloween","Default","White","Blue","Pink","Purple","Green"},"Halloween",function(v)
        applyTheme(v)
        notify("Theme","Changed to "..v)
    end)
    cfgA:Toggle("Quick Menu",false,function(v) ST.quick=v end)
    cfgA:Dropdown("Quick Corner",{"Bottom-Right","Bottom-Left","Top-Right","Top-Left"},"Bottom-Right",function(v) ST.quick_corner=v end)
    cfgA:Slider("Quick Y Offset",280,50,600,function(v) ST.quick_offset_y=v end)
    cfgA:Button("Unload",function() if getgenv().DADA_UNLOAD then getgenv().DADA_UNLOAD() end end)
    local cfgB=makePanel(7,"right","World / Misc")
    cfgB:Toggle("Fake Position",false,function(v) SHF.fake_pos=v end)
    cfgB:Toggle("Movement Graph",false,function(v) SHF.mov_graph=v end)
    cfgB:Button("Version: v16.3")
    cfgB:Button("Notify Test",function() notify("DaDa v16.3","Test") end)

    -- MAP PRIORITY
    local cfgC=makePanel(7,"left","Map Priority")
    local mapList={}
    local mapDropdownBtn = Instance.new("TextButton")
    mapDropdownBtn.Size = UDim2.new(1,0,0,20)
    mapDropdownBtn.BackgroundColor3 = BG_ROW
    mapDropdownBtn.BackgroundTransparency = ROW_TRANS
    mapDropdownBtn.Text = "Priority: ALL (random)"
    mapDropdownBtn.TextColor3 = TEXT_MAIN
    mapDropdownBtn.TextSize = 10
    mapDropdownBtn.Font = Enum.Font.Gotham
    mapDropdownBtn.Parent = cfgC.body
    Instance.new("UICorner", mapDropdownBtn).CornerRadius = UDim.new(0,4)
    local function refreshMapList()
        mapList = {}
        for _,e in ipairs(workspace:GetDescendants()) do
            if e.Name == "MapName" and e:IsA("TextLabel") and e.Text ~= "" and e.Text ~= "MAP NAME" then
                local dup = false
                for _,m in ipairs(mapList) do if m == e.Text then dup = true; break end end
                if not dup then mapList[#mapList+1] = e.Text end
            end
        end
        table.sort(mapList)
        if #mapList == 0 then
            mapDropdownBtn.Text = "Priority: ALL (no maps yet)"
        end
    end
    local mapIdx = 0
    mapDropdownBtn.MouseButton1Click:Connect(function()
        refreshMapList()
        if #mapList == 0 then
            mapDropdownBtn.Text = "Priority: ALL (no maps yet)"
            return
        end
        mapIdx = mapIdx % (#mapList + 1)
        if mapIdx == 0 then
            mapDropdownBtn.Text = "Priority: ALL (random)"
            getgenv().DaDa_MapPriority = nil
            getgenv().DaDa_SelectedMapName = nil
            getgenv().DaDa_SelectedVoteModel = nil
        else
            local currentMap = mapList[mapIdx]
            mapDropdownBtn.Text = "Priority: "..currentMap
            getgenv().DaDa_MapPriority = currentMap
            getgenv().DaDa_SelectedMapName = currentMap
            getgenv().DaDa_SelectedVoteModel = nil
        end
        mapIdx = (mapIdx + 1) % (#mapList + 1)
    end)
    cfgC:Button("Refresh Map List", function()
        refreshMapList()
        mapDropdownBtn.Text = "Priority: ALL (random)"
        mapIdx = 0
        getgenv().DaDa_MapPriority = nil
    end)
    cfgC:Button("Reset Priority", function()
        getgenv().DaDa_MapPriority = nil
        mapDropdownBtn.Text = "Priority: ALL (random)"
        mapIdx = 0
    end)

    getgenv().DaDa_UIRegistry=uiRegistry

    -- TRACER
    do
        local tracerConn=nil
        local function tracerAttach()
            if tracerConn then return end
            local ok, remote = pcall(function()
                return ReplicatedStorage:WaitForChild("ClientServices"):WaitForChild("WeaponService"):WaitForChild("GunFired")
            end)
            if not ok or not remote then return end
            tracerConn = remote.OnClientEvent:Connect(function(gun, posA, posB)
                if not SHF.tracer then return end
                if typeof(posA)~="Vector3" or typeof(posB)~="Vector3" then return end
                local pA=Instance.new("Part")
                pA.Size=Vector3.new(0.05,0.05,0.05)
                pA.Position=posA
                pA.Anchored=true
                pA.CanCollide=false
                pA.Transparency=1
                pA.Parent=workspace
                local pB=Instance.new("Part")
                pB.Size=Vector3.new(0.05,0.05,0.05)
                pB.Position=posB
                pB.Anchored=true
                pB.CanCollide=false
                pB.Transparency=1
                pB.Parent=workspace
                local aA=Instance.new("Attachment",pA)
                local aB=Instance.new("Attachment",pB)
                local beam=Instance.new("Beam")
                beam.Attachment0=aA
                beam.Attachment1=aB
                beam.Width0=0.08
                beam.Width1=0.08
                beam.Color=ColorSequence.new(SHF.tracer_col)
                beam.FaceCamera=true
                beam.LightEmission=1
                beam.Transparency=NumberSequence.new(0)
                beam.Parent=pA
                task.wait(0.1)
                TweenService:Create(beam,TweenInfo.new(0.5),{Width0=0,Width1=0,Transparency=NumberSequence.new(1)}):Play()
                task.wait(0.6)
                pA:Destroy()
                pB:Destroy()
            end)
        end
        task.spawn(function() while task.wait(1) do if SHF.tracer and not tracerConn then tracerAttach() end end end)
    end

    -- CONFIG UI
    local configName = "default"
    local nameBox = Instance.new("TextBox")
    nameBox.Size = UDim2.new(1,0,0,20)
    nameBox.BackgroundColor3 = BG_ROW
    nameBox.BackgroundTransparency = ROW_TRANS
    nameBox.Text = "default"
    nameBox.PlaceholderText = "имя конфига"
    nameBox.TextColor3 = TEXT_MAIN
    nameBox.TextSize = 10
    nameBox.Font = Enum.Font.Gotham
    nameBox.ClearTextOnFocus = false
    nameBox.Parent = cfgA.body
    Instance.new("UICorner", nameBox).CornerRadius = UDim.new(0,4)
    nameBox.FocusLost:Connect(function()
        configName = nameBox.Text ~= "" and nameBox.Text or "default"
    end)
    cfgA:Button("  Save Config", function()
        local CFG = getgenv().DaDa_Config
        if CFG and CFG.save then pcall(CFG.save, configName) else notify("Config", "Система конфигов не загружена") end
    end)
    cfgA:Button("  Load Config", function()
        local CFG = getgenv().DaDa_Config
        if CFG and CFG.load then pcall(CFG.load, configName) else notify("Config", "Система конфигов не загружена") end
    end)
    cfgA:Button("  Delete Config", function()
        local CFG = getgenv().DaDa_Config
        if CFG and CFG.delete then pcall(CFG.delete, configName) else notify("Config", "Система конфигов не загружена") end
    end)
    cfgA:Button("  List Configs", function()
        local CFG = getgenv().DaDa_Config
        if not CFG then return end
        local list = CFG.list()
        if #list == 0 then
            notify("Configs", "Пусто")
        else
            notify("Configs", table.concat(list, ", "))
        end
    end)
    cfgA:Button("  Load Last", function()
        local CFG = getgenv().DaDa_Config
        if not CFG then return end
        local last = CFG.last()
        if last then CFG.load(last) else notify("Configs", "Нет последнего") end
    end)
    cfgA:Button("  Refresh Config List", function()
        local CFG = getgenv().DaDa_Config
        if not CFG or not CFG.list then notify("Configs", "Система не загружена"); return end
        local ok, list = pcall(CFG.list)
        if not ok or type(list) ~= "table" or #list == 0 then
            notify("Configs", "Конфиги не найдены")
        else
            notify("Configs", table.concat(list, ", "))
        end
    end)

    -- CROSSHAIR
    do
        local lines={}
        local rot=0
        RunService.RenderStepped:Connect(function(dt)
            if not SHF.crosshair then
                for i=1,#lines do lines[i].Visible=false end
                return
            end
            while #lines<8 do
                local l=Drawing.new("Line")
                l.Visible=false
                table.insert(lines,l)
            end
            local char=LP.Character
            local hasGun=char and char:FindFirstChild("Gun")
            if not hasGun then
                for i=1,#lines do lines[i].Visible=false end
                return
            end
            rot=(rot+dt*SHF.crosshair_rot*100)%360
            local mp=UIS:GetMouseLocation()
            local cx,cy=mp.X,mp.Y
            local rad=math.rad(rot)
            for i=1,4 do
                local a=rad+(i-1)*math.pi/2
                local li=(i-1)*2+1
                local oi=li+1
                local x1=cx+SHF.crosshair_gap*math.cos(a)
                local y1=cy+SHF.crosshair_gap*math.sin(a)
                local x2=cx+(SHF.crosshair_gap+SHF.crosshair_len)*math.cos(a)
                local y2=cy+(SHF.crosshair_gap+SHF.crosshair_len)*math.sin(a)
                lines[li].From=Vector2.new(x1,y1)
                lines[li].To=Vector2.new(x2,y2)
                lines[li].Color=SHF.crosshair_line_col
                lines[li].Thickness=SHF.crosshair_thick
                lines[li].Visible=true
                lines[oi].From=Vector2.new(x1-1,y1-1)
                lines[oi].To=Vector2.new(x2+1,y2+1)
                lines[oi].Color=SHF.crosshair_out_col
                lines[oi].Thickness=SHF.crosshair_thick+2
                lines[oi].Visible=true
            end
        end)
    end

    -- CHINA HAT
    do
        local rows={}
        local CH_SEG=32
        local CH_TAU=math.pi*2
        local CH_RAD=1.55
        local CH_H=0.82
        local cos_t={}; local sin_t={}
        for i=1,CH_SEG do
            local a=(i-1)/CH_SEG*CH_TAU
            cos_t[i]=math.cos(a)*CH_RAD
            sin_t[i]=math.sin(a)*CH_RAD
        end
        local function clearCH()
            for i=1,#rows do pcall(function() rows[i]:Remove() end) end
            table.clear(rows)
        end
        local function getRow(i)
            if rows[i] then return rows[i] end
            local r=Drawing.new("Square")
            r.Filled=true
            r.Thickness=0
            r.Transparency=0.72
            r.Visible=false
            r.ZIndex=1
            rows[i]=r
            return r
        end
        RunService.RenderStepped:Connect(function()
            if not SHF.china_hat then clearCH() return end
            local char=LP.Character
            local head=char and char:FindFirstChild("Head")
            if not head then clearCH() return end
            local cam=workspace.CurrentCamera
            if not cam then return end
            local view=cam.ViewportSize
            local hp=head.Position
            local baseY=hp.Y+head.Size.Y*0.5-0.02
            local center=Vector3.new(hp.X,baseY,hp.Z)
            local apex=cam:WorldToViewportPoint(center+Vector3.new(0,CH_H,0))
            if apex.Z<=0 then clearCH() return end
            local px,py={},{}; px[1],py[1]=apex.X,apex.Y
            for i=1,CH_SEG do
                local p=cam:WorldToViewportPoint(center+Vector3.new(cos_t[i],0,sin_t[i]))
                if p.Z<=0 then clearCH() return end
                px[i+1],py[i+1]=p.X,p.Y
            end
            local used=0
            for y0=math.max(0,math.floor(apex.Y)),math.min(view.Y,math.floor(apex.Y+50)) do
                local y=y0+0.5
                local left,right=math.huge,-math.huge
                for i=1,CH_SEG do
                    local ax,ay=px[i],py[i]
                    local bx,by=px[i+1],py[i+1]
                    if (ay<=y and by>y) or (by<=y and ay>y) then
                        local x=ax+(y-ay)*(bx-ax)/(by-ay)
                        if x<left then left=x end
                        if x>right then right=x end
                    end
                end
                if right-left>=2.5 then
                    used=used+1
                    local r=getRow(used)
                    r.Position=Vector2.new(left,y0)
                    r.Size=Vector2.new(right-left,1)
                    r.Color=SHF.china_hat_col
                    r.Visible=true
                end
            end
            for i=used+1,#rows do rows[i].Visible=false end
        end)
    end

    -- SELF CHAMS
    do
        local orig={}
        RunService.Stepped:Connect(function()
            if not SHF.self_chams then
                for p,d in pairs(orig) do if p.Parent then p.Material=d.m p.Color=d.c end end
                orig={}
                return
            end
            local char=LP.Character
            if not char then return end
            for _,p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") and p.Name~="HumanoidRootPart" then
                    if not orig[p] then orig[p]={m=p.Material,c=p.Color} end
                    p.Material=Enum.Material.ForceField
                    p.Color=SHF.self_chams_col
                end
            end
        end)
    end

    -- TOOL CHAMS
    do
        local orig={}
        RunService.Stepped:Connect(function()
            if not SHF.tool_chams then
                for p,d in pairs(orig) do if p.Parent then p.Material=d.m p.Color=d.c end end
                orig={}
                return
            end
            local char=LP.Character
            if not char then return end
            for _,t in ipairs(char:GetChildren()) do
                if t:IsA("Tool") then
                    for _,p in ipairs(t:GetDescendants()) do
                        if p:IsA("BasePart") then
                            if not orig[p] then orig[p]={m=p.Material,c=p.Color} end
                            p.Material=Enum.Material.ForceField
                            p.Color=SHF.tool_chams_col
                        end
                    end
                end
            end
        end)
    end

    -- LANDING CIRCLE
    do
        local lc_conn=nil
        local function lc_bind()
            if lc_conn then pcall(function() lc_conn:Disconnect() end) lc_conn=nil end
            local char=LP.Character
            local hum=char and char:FindFirstChildOfClass("Humanoid")
            if not hum then return end
            local air=false
            lc_conn=hum.StateChanged:Connect(function(_,state)
                if state==Enum.HumanoidStateType.Jumping or state==Enum.HumanoidStateType.Freefall then
                    air=true
                elseif state==Enum.HumanoidStateType.Landed and air then
                    air=false
                    if not SHF.landing_circle then return end
                    local root=char:FindFirstChild("HumanoidRootPart")
                    if not root then return end
                    local params=RaycastParams.new()
                    params.FilterType=Enum.RaycastFilterType.Exclude
                    params.FilterDescendantsInstances={char}
                    local hit=workspace:Raycast(root.Position+Vector3.new(0,1,0),Vector3.new(0,-20,0),params)
                    if not hit then return end
                    local p=hit.Position
                    local n=hit.Normal
                    local part=Instance.new("Part")
                    part.Anchored=true
                    part.CanCollide=false
                    part.CanQuery=false
                    part.CanTouch=false
                    part.CastShadow=false
                    part.Transparency=1
                    part.Size=Vector3.new(0.3,0.01,0.3)
                    part.CFrame=CFrame.lookAt(p+n*0.01,p+n*0.01+n)
                    part.Parent=workspace
                    local sg=Instance.new("SurfaceGui")
                    sg.Face=Enum.NormalId.Top
                    sg.AlwaysOnTop=true
                    sg.LightInfluence=0
                    sg.Parent=part
                    local img=Instance.new("ImageLabel")
                    img.BackgroundTransparency=1
                    img.Size=UDim2.fromScale(1,1)
                    img.Image="rbxassetid://7185003058"
                    img.ImageColor3=SHF.landing_circle_col
                    img.ImageTransparency=1-SHF.landing_circle_tr
                    img.Parent=sg
                    TweenService:Create(part,TweenInfo.new(SHF.landing_circle_dur,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Size=Vector3.new(6.4,0.01,6.4)}):Play()
                    TweenService:Create(img,TweenInfo.new(SHF.landing_circle_dur,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{ImageTransparency=1}):Play()
                    task.delay(SHF.landing_circle_dur+0.3,function() pcall(function() part:Destroy() end) end)
                end
            end)
        end
        SHF.lc_bind=lc_bind
        LP.CharacterAdded:Connect(function() task.wait(0.5) if SHF.landing_circle then lc_bind() end end)
    end

    -- GUN ESP
    do
        local guns={}
        RunService.RenderStepped:Connect(function()
            if not (SHF.gun_esp or SHF.gun_esp_hl or SHF.gun_esp_text) then
                for o,e in pairs(guns) do
                    if e.hl then pcall(function() e.hl:Destroy() end) end
                    if e.txt then pcall(function() e.txt:Remove() end) end
                end
                guns={}
                return
            end
            for _,o in ipairs(workspace:GetDescendants()) do
                if o.Name=="GunDrop" and o:IsA("BasePart") then
                    local e=guns[o]
                    if not e then
                        e={}
                        if SHF.gun_esp_hl then
                            local hl=Instance.new("Highlight")
                            hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
                            hl.FillTransparency=1
                            hl.OutlineColor=SHF.gun_esp_hl_col
                            hl.OutlineTransparency=0
                            hl.Adornee=o
                            hl.Parent=game:GetService("CoreGui")
                            e.hl=hl
                        end
                        if SHF.gun_esp_text then
                            local t=Drawing.new("Text")
                            t.Center=true
                            t.Outline=true
                            t.Size=13
                            e.txt=t
                        end
                        guns[o]=e
                    end
                    if e.txt then
                        local cam=workspace.CurrentCamera
                        local sp=cam:WorldToViewportPoint(o.Position)
                        if sp.Z>0 then
                            e.txt.Position=Vector2.new(sp.X,sp.Y)
                            e.txt.Text="Gun"
                            e.txt.Color=SHF.gun_esp_text_col
                            e.txt.Visible=true
                        else e.txt.Visible=false end
                    end
                end
            end
        end)
    end

    -- ASPECT RATIO
    do
        local ratioMult=CFrame.new(0,0,0,1,0,0,0,1,0,0,0,1)
        RunService:BindToRenderStep("DaDaAspect",Enum.RenderPriority.Camera.Value+1,function()
            if not SHF.aspect then return end
            local cam=workspace.CurrentCamera
            if cam then cam.CFrame=cam.CFrame*ratioMult end
        end)
        SHF.setAspect=function(v)
            SHF.aspect_val=v
            ratioMult=CFrame.new(0,0,0,1,0,0,0,v/100,0,0,0,1)
        end
    end

    -- FAKE POSITION
    do
        RunService.Heartbeat:Connect(function()
            local char=LP.Character
            local hrp=char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            if SHF.fake_pos then
                local rx=SHF.fake_pos_range_x*1e9
                local ry=SHF.fake_pos_range_y*1e9
                local rz=SHF.fake_pos_range_z*1e9
                local old=hrp.CFrame
                pcall(function()
                    hrp.CFrame=CFrame.new(
                        (math.random()*2-1)*rx,
                        -(math.random())*ry,
                        (math.random()*2-1)*rz
                    )
                end)
                task.wait()
                pcall(function() hrp.CFrame=old end)
            end
        end)
    end

    -- MOVEMENT GRAPH
    do
        local lines={}; local shadows={}; local history={}; local accum=0
        RunService.RenderStepped:Connect(function(dt)
            if not SHF.mov_graph then
                for i=1,#lines do lines[i].Visible=false shadows[i].Visible=false end
                return
            end
            local char=LP.Character
            local hrp=char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local vel=hrp.AssemblyLinearVelocity
            local sp=math.sqrt(vel.X*vel.X+vel.Z*vel.Z)
            accum=accum+dt
            if accum>=0.05 then
                accum=0
                table.insert(history,{t=os.clock(),v=sp})
                if #history>60 then table.remove(history,1) end
            end
            local cam=workspace.CurrentCamera
            local vp=cam.ViewportSize
            local w=280; local h=72; local cx=vp.X/2; local cy=vp.Y/2+180
            while #lines<#history do
                local l=Drawing.new("Line")
                l.Thickness=1
                l.Color=SHF.mov_graph_col
                l.Visible=false
                table.insert(lines,l)
                local s=Drawing.new("Line")
                s.Thickness=3
                s.Color=Color3.new(0,0,0)
                s.Visible=false
                table.insert(shadows,s)
            end
            for i=1,#history-1 do
                local a=history[i]
                local b=history[i+1]
                local ax=cx-w/2+(i/#history)*w
                local bx=cx-w/2+((i+1)/#history)*w
                local ay=cy-math.clamp(a.v/50,-1,1)*h/2
                local by=cy-math.clamp(b.v/50,-1,1)*h/2
                lines[i].From=Vector2.new(ax,ay)
                lines[i].To=Vector2.new(bx,by)
                lines[i].Visible=true
                shadows[i].From=Vector2.new(ax,ay)
                shadows[i].To=Vector2.new(bx,by)
                shadows[i].Visible=true
            end
        end)
    end

    -- AUTO MAP VOTE / VOTE DUPER: exact VotePad1/2/3 scanning + respawn loop
    do
        local workerId = 0
        local wasEnabled = false
        local loadingPause = false
        local namesBeforeLoading = nil
        local loadingConn = nil
        local lastChosenMap = nil

        local function normalizeMapName(value)
            value = tostring(value or "")
            value = value:gsub("^%s+", ""):gsub("%s+$", "")
            value = value:gsub("%s+", " ")
            return string.lower(value)
        end

        local function getLobby()
            -- Current game update: workspace.Lobby.VotePads.VotePad1...
            local lobby = workspace:FindFirstChild("Lobby")
            if lobby then return lobby end
            -- Compatibility fallback for older versions of the map hierarchy.
            return workspace:FindFirstChild("RegularLobby")
                or workspace:FindFirstChild("RegularLobby", true)
        end

        local function getPadMapName(pad)
            if not pad then return nil end
            local gui = pad:FindFirstChild("VoteInfoGui", true)
            local container = gui and gui:FindFirstChild("Container", true)
            local label = container and container:FindFirstChild("MapName", true)
            if label and (label:IsA("TextLabel") or label:IsA("TextButton") or label:IsA("TextBox")) then
                local value = tostring(label.Text or ""):gsub("^%s+", ""):gsub("%s+$", "")
                if value ~= "" and normalizeMapName(value) ~= "map name" then return value end
            end
            return nil
        end

        local function getPadPart(pad)
            if not pad then return nil end
            local namedPad = pad:FindFirstChild("Pad", true)
            if namedPad and namedPad:IsA("BasePart") then return namedPad end
            if pad:IsA("BasePart") then return pad end
            if pad:IsA("Model") and pad.PrimaryPart then return pad.PrimaryPart end
            return pad:FindFirstChildWhichIsA("BasePart", true)
        end

        local function scanVotePads()
            local lobby = getLobby()
            local result = {}
            if not lobby then return result end

            -- Updated hierarchy: workspace.Lobby.VotePads.VotePad1/2/3
            local padsRoot = lobby:FindFirstChild("VotePads")
                or lobby:FindFirstChild("VotePads", true)
            local searchRoot = padsRoot or lobby
            for i = 1, 3 do
                local pad = searchRoot:FindFirstChild("VotePad" .. i)
                if not pad then pad = searchRoot:FindFirstChild("VotePad" .. i, true) end
                if pad then
                    result[#result + 1] = {
                        instance = pad,
                        name = getPadMapName(pad),
                        part = getPadPart(pad),
                        slot = i,
                    }
                end
            end
            return result
        end

        local function currentNamesSignature()
            local pads = scanVotePads()
            local names = {}
            for i = 1, 3 do
                local found = ""
                for _, item in ipairs(pads) do
                    if item.slot == i then found = item.name or "" break end
                end
                names[i] = found
            end
            return names
        end

        local function anyNameChanged(before, now)
            -- Resume as soon as at least one of the three pad labels changes.
            -- The other two labels are allowed to keep the same map name.
            if not before or not now then return false end
            for i = 1, 3 do
                local oldName = normalizeMapName(before[i])
                local newName = normalizeMapName(now[i])
                if newName ~= "" and newName ~= "map name" and oldName ~= "" and oldName ~= "map name" and newName ~= oldName then
                    return true
                end
            end
            return false
        end

        local function selectedMapName()
            local chosen = getgenv().DaDa_SelectedMapName
                or getgenv().DaDa_MapPriority
                or lastChosenMap
            if chosen and tostring(chosen) ~= "" then
                lastChosenMap = tostring(chosen)
                return lastChosenMap
            end
            return nil
        end

        local function findSelectedPad()
            local chosen = selectedMapName()
            if not chosen then return nil end
            local wanted = normalizeMapName(chosen)
            for _, item in ipairs(scanVotePads()) do
                if item.name and item.part and normalizeMapName(item.name) == wanted then
                    return item
                end
            end
            return nil
        end

        local function isEnabled()
            return SHF.mapvote or SHF.mapvote_dupe
        end

        local function getCharacterParts(id)
            local start = os.clock()
            repeat
                if workerId ~= id or not isEnabled() or loadingPause then return nil end
                local character = LP.Character
                local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                local hrp = character and character:FindFirstChild("HumanoidRootPart")
                if humanoid and hrp and humanoid.Health > 0 then
                    return character, humanoid, hrp
                end
                task.wait(0.04)
            until os.clock() - start > 6
            return nil
        end

        local function runCycle(id)
            while workerId == id and isEnabled() do
                if loadingPause then
                    -- Resume once ANY one of the three MapName labels changes.
                    -- The remaining pads may still show the same map names.
                    local now = currentNamesSignature()
                    if anyNameChanged(namesBeforeLoading, now) then
                        loadingPause = false
                        namesBeforeLoading = nil
                        if notify then pcall(function() notify("Vote Duper", "Vote pads refreshed; resuming " .. tostring(selectedMapName() or "selected map")) end) end
                    else
                        task.wait(0.1)
                        continue
                    end
                end

                local chosen = selectedMapName()
                local target = findSelectedPad()
                if not target then
                    -- Selected map is not one of the current three choices: wait for the next refresh.
                    task.wait(0.12)
                    continue
                end

                local character, humanoid, hrp = getCharacterParts(id)
                if not character or not humanoid or not hrp then
                    task.wait(0.05)
                    continue
                end

                -- Match the requested reference behavior: go to the pad matching its MapName,
                -- allow the game to register the vote, then reset and repeat.
                pcall(function()
                    hrp.CFrame = target.part.CFrame + Vector3.new(0, 3.2, 0)
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                end)
                task.wait(0.12)

                if workerId ~= id or not isEnabled() or loadingPause then continue end
                -- Re-check the selection so tapping another map immediately redirects the loop.
                if normalizeMapName(selectedMapName()) ~= normalizeMapName(chosen) then continue end
                pcall(function() humanoid.Health = 0 end)
                local respawnStart = os.clock()
                repeat
                    if workerId ~= id or not isEnabled() or loadingPause then break end
                    local c = LP.Character
                    local h = c and c:FindFirstChildOfClass("Humanoid")
                    local r = c and c:FindFirstChild("HumanoidRootPart")
                    if h and r and h.Health > 0 then break end
                    task.wait(0.04)
                until os.clock() - respawnStart > 6
                task.wait(0.03)
            end
        end

        local function startWorker()
            workerId += 1
            local id = workerId
            task.spawn(function() runCycle(id) end)
        end

        RunService.Heartbeat:Connect(function()
            local on = isEnabled()
            if on and not wasEnabled then
                startWorker()
            elseif not on and wasEnabled then
                workerId += 1
            end
            wasEnabled = on
        end)

        task.spawn(function()
            local remotes = ReplicatedStorage:FindFirstChild("Remotes")
            local gameplay = remotes and remotes:FindFirstChild("Gameplay")
            local loadingMap = gameplay and (gameplay:FindFirstChild("LoadingMap") or gameplay:FindFirstChild("LoadingMAP"))
            if loadingMap and (loadingMap:IsA("RemoteEvent") or loadingMap:IsA("BindableEvent")) then
                local signal = loadingMap:IsA("RemoteEvent") and loadingMap.OnClientEvent or loadingMap.Event
                loadingConn = signal:Connect(function()
                    -- Snapshot labels when LoadingMap fires; pause until at least one label changes.
                    namesBeforeLoading = currentNamesSignature()
                    loadingPause = true
                end)
            end
        end)
    end
end
initMenu()

-- ============================================================
-- INIT 15: MAIN LOOP
-- ============================================================
local function initMainLoop()
    main_conn=RunService.Heartbeat:Connect(function()
        pcall(function()
            if _G.DaDa_SL_restore_origin then
                if _G.DaDa_SL_getForceAtt and _G.DaDa_SL_getForceAtt() then
                    if os.clock()-(_G.DaDa_SL_getForceStamp and _G.DaDa_SL_getForceStamp() or 0)>0.05 then
                        _G.DaDa_SL_restore_origin()
                    end
                end
            end
            local now=os.clock()
            if SL.enabled then
                SL_refresh()
                if _G.DaDa_SL_track then _G.DaDa_SL_track(now) end
                if _G.DaDa_SL_auto_step then _G.DaDa_SL_auto_step(now) end
                if SL_installHooks then pcall(SL_installHooks) end
            end
            getgun_step(now)
            esp_step()
            killaura_step()
            antifling_step()
            if triggerbot_step then pcall(triggerbot_step) end
            if knife_silent_step then pcall(knife_silent_step) end
        end)
    end)
end
initMainLoop()

-- ============================================================
-- INIT 16: QUICK MENU
-- ============================================================
local function initQuick()
    quick_gui=Instance.new("ScreenGui")
    quick_gui.Name="DaDaQuick_"..math.random(1000,9999)
    quick_gui.ResetOnSpawn=false
    quick_gui.IgnoreGuiInset=true
    quick_gui.DisplayOrder=99
    quick_gui.Enabled=false
    pcall(function() quick_gui.Parent=CoreGui end)
    if not quick_gui.Parent then quick_gui.Parent=LP:WaitForChild("PlayerGui") end
    local qholder=Instance.new("Frame")
    qholder.Size=UDim2.new(0,140,0,0)
    qholder.AutomaticSize=Enum.AutomaticSize.Y
    qholder.BackgroundTransparency=1
    qholder.Parent=quick_gui
    local qlist=Instance.new("UIListLayout",qholder)
    qlist.Padding=UDim.new(0,4)
    local qbuttons={}
    for i,feat in ipairs(ST.quick_features) do
        local b=Instance.new("TextButton")
        b.Size=UDim2.new(1,0,0,26)
        b.BackgroundColor3=BG_PANEL
        b.BackgroundTransparency=PANEL_TRANS
        b.Text=feat.name..": OFF"
        b.TextColor3=TEXT_DIM
        b.TextSize=11
        b.Font=Enum.Font.GothamBold
        b.LayoutOrder=i
        b.Parent=qholder
        Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)
        b.MouseButton1Click:Connect(function()
            local flag=feat.flag
            local new=not ST.quick_state[flag]
            ST.quick_state[flag]=new
            if flag=="silent" then
                SL.enabled=new
                if new then task.spawn(function() pcall(SL_installHooks); pcall(SL_refresh) end)
                else if _G.DaDa_SL_restore_origin then pcall(_G.DaDa_SL_restore_origin) end end
            elseif flag=="esp" then ST.esp_on=new
            elseif flag=="bhop" then ST.bhop=new
            elseif flag=="fly" then ST.fly=new
            elseif flag=="inf_jump" then ST.inf_jump=new end
            local reg=getgenv().DaDa_UIRegistry
            if reg and reg[flag] then pcall(reg[flag],new) end
        end)
        qbuttons[feat.name]=b
    end
    local function place_quick()
        local y=ST.quick_offset_y
        local c=ST.quick_corner
        if c=="Bottom-Right" then
            qholder.Position=UDim2.new(1,-150,1,-y)
            qlist.HorizontalAlignment=Enum.HorizontalAlignment.Right
        elseif c=="Bottom-Left" then
            qholder.Position=UDim2.new(0,10,1,-y)
            qlist.HorizontalAlignment=Enum.HorizontalAlignment.Left
        elseif c=="Top-Right" then
            qholder.Position=UDim2.new(1,-150,0,50)
            qlist.HorizontalAlignment=Enum.HorizontalAlignment.Right
        elseif c=="Top-Left" then
            qholder.Position=UDim2.new(0,10,0,50)
            qlist.HorizontalAlignment=Enum.HorizontalAlignment.Left
        end
    end
    place_quick()
    RunService.RenderStepped:Connect(function()
        if quick_gui then quick_gui.Enabled=ST.quick end
        if not ST.quick then return end
        place_quick()
        for _,f in ipairs(ST.quick_features) do
            local b=qbuttons[f.name]
            if b then
                local on=ST.quick_state[f.flag]
                b.Text=f.name..": "..(on and "ON" or "OFF")
                b.TextColor3=on and Color3.fromRGB(120,220,150) or TEXT_DIM
            end
        end
    end)
end
initQuick()

-- ============================================================
-- INIT 17: HUB
-- ============================================================
local function initHub()
    hubGui=Instance.new("ScreenGui")
    hubGui.Name="DaDaHub_"..math.random(1000,9999)
    hubGui.ResetOnSpawn=false
    hubGui.IgnoreGuiInset=true
    hubGui.DisplayOrder=100
    pcall(function() hubGui.Parent=CoreGui end)
    if not hubGui.Parent then hubGui.Parent=LP:WaitForChild("PlayerGui") end
    local hub=Instance.new("Frame")
    hub.Size=UDim2.new(0,260,0,22)
    hub.Position=UDim2.new(0.5,-130,0,6)
    hub.BackgroundColor3=Color3.fromRGB(0,0,0)
    hub.BackgroundTransparency=0.35
    hub.BorderSizePixel=0
    hub.Active=true
    hub.Parent=hubGui
    Instance.new("UICorner",hub).CornerRadius=UDim.new(0,5)
    local hubStroke=Instance.new("UIStroke",hub); hubStroke.Color=Color3.fromRGB(45,45,55)
    table.insert(themeUpdaters,function(t) hubStroke.Color=t.Accent end)
    local hubLayout=Instance.new("UIListLayout",hub)
    hubLayout.FillDirection=Enum.FillDirection.Horizontal
    hubLayout.Padding=UDim.new(0,6)
    hubLayout.VerticalAlignment=Enum.VerticalAlignment.Center
    hubLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center
    local hubPad=Instance.new("UIPadding",hub); hubPad.PaddingLeft=UDim.new(0,8); hubPad.PaddingRight=UDim.new(0,8)
    local function makeChip(order,text,color)
        local chip=Instance.new("Frame")
        chip.LayoutOrder=order
        chip.AutomaticSize=Enum.AutomaticSize.X
        chip.Size=UDim2.new(0,0,1,-4)
        chip.BackgroundTransparency=1
        chip.Parent=hub
        local lbl=Instance.new("TextLabel")
        lbl.Size=UDim2.new(0,0,1,0)
        lbl.AutomaticSize=Enum.AutomaticSize.X
        lbl.BackgroundTransparency=1
        lbl.Text=text
        lbl.TextColor3=color or Color3.fromRGB(220,220,230)
        lbl.TextSize=10
        lbl.Font=Enum.Font.GothamBold
        lbl.Parent=chip
        return lbl
    end
    makeChip(1,"DaDa v16.3",Color3.fromRGB(200,120,255))
    makeChip(2,(LP.DisplayName or LP.Name),Color3.fromRGB(200,180,255))
    local fpsChip=makeChip(3,"0 fps",Color3.fromRGB(180,180,190))
    local pingChip=makeChip(4,"0 ms",Color3.fromRGB(180,180,190))
    local fpsCount=0; local fpsLast=tick(); local pingSmooth=0; local pingSeen=false
    RunService.RenderStepped:Connect(function()
        fpsCount=fpsCount+1
        local t=tick()
        if t-fpsLast>=0.1 then
            local fps=math.floor(fpsCount/(t-fpsLast))
            fpsCount=0; fpsLast=t
            fpsChip.Text=fps.." fps"
            local ping=0
            pcall(function() ping=math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
            if pingSeen then pingSmooth=pingSmooth*0.7+ping*0.3 else pingSmooth=ping; pingSeen=true end
            pingChip.Text=math.floor(pingSmooth).." ms"
        end
    end)
    local hubDrag=false; local hubMoved=false; local hubDS; local hubSP
    hub.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            hubDrag=true; hubMoved=false; hubDS=input.Position; hubSP=hub.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if not hubDrag then return end
        if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then
            local delta=input.Position-hubDS
            if delta.Magnitude>5 then hubMoved=true end
            hub.Position=UDim2.new(hubSP.X.Scale,hubSP.X.Offset+delta.X,hubSP.Y.Scale,hubSP.Y.Offset+delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            if hubDrag and not hubMoved and win then win.Visible=not win.Visible end
            hubDrag=false
        end
    end)
end
initHub()

-- ============================================================
-- INIT 18: HOTBAR
-- ============================================================
local function initHotbar()
    hotbarGui=Instance.new("ScreenGui")
    hotbarGui.Name="DaDaHotbar_"..math.random(1000,9999)
    hotbarGui.ResetOnSpawn=false
    hotbarGui.IgnoreGuiInset=true
    hotbarGui.DisplayOrder=98
    hotbarGui.Enabled=false
    pcall(function() hotbarGui.Parent=CoreGui end)
    if not hotbarGui.Parent then hotbarGui.Parent=LP:WaitForChild("PlayerGui") end
    local bar=Instance.new("Frame")
    bar.Size=UDim2.new(0,0,0,28)
    bar.AutomaticSize=Enum.AutomaticSize.X
    bar.Position=UDim2.new(0.5,0,1,-40)
    bar.AnchorPoint=Vector2.new(0.5,1)
    bar.BackgroundColor3=Color3.fromRGB(0,0,0)
    bar.BackgroundTransparency=0.35
    bar.BorderSizePixel=0
    bar.Parent=hotbarGui
    Instance.new("UICorner",bar).CornerRadius=UDim.new(0,6)
    local barStroke=Instance.new("UIStroke",bar); barStroke.Color=Color3.fromRGB(45,45,55)
    table.insert(themeUpdaters,function(t) barStroke.Color=t.Accent end)
    local barList=Instance.new("UIListLayout",bar)
    barList.FillDirection=Enum.FillDirection.Horizontal
    barList.Padding=UDim.new(0,4)
    barList.VerticalAlignment=Enum.VerticalAlignment.Center
    Instance.new("UIPadding",bar).PaddingLeft=UDim.new(0,6)
    local padR=Instance.new("UIPadding",bar); padR.PaddingRight=UDim.new(0,6)
    local HOTKEYS={
        {key="Z",flag="silent",label="Silent"},
        {key="X",flag="esp",label="ESP"},
        {key="C",flag="bhop",label="Bhop"},
        {key="V",flag="fly",label="Fly"},
        {key="B",flag="inf_jump",label="InfJump"},
        {key="N",flag="getgun",label="GetGun"},
    }
    local hbBtns={}
    for i,hk in ipairs(HOTKEYS) do
        local b=Instance.new("TextButton")
        b.Size=UDim2.new(0,54,1,-6)
        b.BackgroundColor3=Color3.fromRGB(20,20,25)
        b.BackgroundTransparency=0.4
        b.Text="["..hk.key.."] "..hk.label
        b.TextColor3=Color3.fromRGB(180,180,190)
        b.TextSize=9
        b.Font=Enum.Font.GothamBold
        b.LayoutOrder=i
        b.Parent=bar
        Instance.new("UICorner",b).CornerRadius=UDim.new(0,4)
        table.insert(themeUpdaters,function(t) b.BackgroundColor3=t.Element end)
        local function toggle_hk()
            local on=not ST.quick_state[hk.flag]
            ST.quick_state[hk.flag]=on
            if hk.flag=="silent" then
                SL.enabled=on
                if on then task.spawn(function() pcall(SL_installHooks); pcall(SL_refresh) end)
                else if _G.DaDa_SL_restore_origin then pcall(_G.DaDa_SL_restore_origin) end end
            elseif hk.flag=="esp" then ST.esp_on=on
            elseif hk.flag=="bhop" then ST.bhop=on
            elseif hk.flag=="fly" then ST.fly=on
            elseif hk.flag=="inf_jump" then ST.inf_jump=on
            elseif hk.flag=="getgun" then ST.getgun=on end
            local reg=getgenv().DaDa_UIRegistry
            if reg and reg[hk.flag] then pcall(reg[hk.flag],on) end
        end
        b.MouseButton1Click:Connect(toggle_hk)
        UIS.InputBegan:Connect(function(input,gpe)
            if gpe then return end
            if not ST.quick then return end
            if input.KeyCode==Enum.KeyCode[hk.key] then toggle_hk() end
        end)
        hbBtns[hk.flag]=b
    end
    RunService.RenderStepped:Connect(function()
        if hotbarGui then hotbarGui.Enabled = ST.quick end
        if not ST.quick then return end
        for _,hk in ipairs(HOTKEYS) do
            local b=hbBtns[hk.flag]
            if b then
                local on=ST.quick_state[hk.flag]
                b.TextColor3=on and Color3.fromRGB(120,220,150) or Color3.fromRGB(180,180,190)
            end
        end
    end)
end
initHotbar()

-- ============================================================
-- INIT 19: HOTKEYS
-- ============================================================
local function initHotkeys()
    UIS.InputBegan:Connect(function(input,gpe)
        if gpe then return end
        if input.KeyCode==Enum.KeyCode.RightShift or input.KeyCode==Enum.KeyCode.Insert then
            if win then win.Visible=not win.Visible end
        elseif input.KeyCode==Enum.KeyCode.End then
            if getgenv().DADA_UNLOAD then pcall(getgenv().DADA_UNLOAD) end
        elseif input.KeyCode==Enum.KeyCode.Home then
            if SHF.clearAura then pcall(SHF.clearAura) end
            if SHF.clearAura2 then pcall(SHF.clearAura2) end
            if SHF.clearPremSky then pcall(SHF.clearPremSky) end
            if SHF.restoreShader then pcall(SHF.restoreShader) end
            notify("Reset","World restored")
        end
    end)
end
initHotkeys()

-- ============================================================
-- INIT 20: UNLOAD
-- ============================================================
getgenv().DADA_UNLOAD=function()
    SL.enabled=false; SL.auto_on=false; SL.force=false
    ST.getgun=false; ST.quick=false; ST.esp_on=false
    ST.fling_murder=false; ST.fling_sheriff=false
    ST.killaura=false; ST.autoknife=false; ST.antifling=false
    ST.auto_knife_throw=false; ST.fly=false; ST.noclip=false; ST.inf_jump=false
    ST.speed_hack=false; ST.jump_power=false; ST.bhop=false; ST.gravity=false
    ST.fullbright=false; ST.fov_changer=false; ST.world_color=false
    ST.char_transparency=false
    SHF.tracer=false; SHF.kill_sound=false; SHF.sheriff_sound=false; SHF.gunshot_sound=false
    SHF.shaders=false; SHF.fog=false; SHF.ambient=false; SHF.exposure=false
    SHF.prem_skybox=false; SHF.world_fx=false; SHF.aura=false
    if SHF.aura2Toggle then pcall(function() SHF.aura2Toggle(false) end) end
    if SHF.invis2Toggle then pcall(function() SHF.invis2Toggle(false) end) end
    if SHF._invisDisconnect then pcall(SHF._invisDisconnect) end
    if SHF._skinDisconnect then pcall(SHF._skinDisconnect) end
    if SHF._visualDisconnect then pcall(SHF._visualDisconnect) end
    SHF.invis=false
    if SHF.clearInvis then pcall(SHF.clearInvis) end
    SHF.crosshair=false; SHF.china_hat=false; SHF.self_chams=false
    SHF.tool_chams=false; SHF.landing_circle=false; SHF.gun_esp=false
    SHF.aspect=false; SHF.mapvote=false; SHF.fake_pos=false; SHF.mov_graph=false
    getgenv().SILENT_AIM_ACTIVE=false
    if _G.DaDa_SL_restore_origin then pcall(_G.DaDa_SL_restore_origin) end
    if SHF.clearAura then pcall(SHF.clearAura) end
    if SHF.clearPremSky then pcall(SHF.clearPremSky) end
    if getgenv().DaDa_apply_skybox then pcall(function() getgenv().DaDa_apply_skybox("Default") end) end
    if SHF.restoreShader then pcall(SHF.restoreShader) end
    if SHF.animReset then pcall(SHF.animReset) end
    if SHF.emoteUnload then pcall(SHF.emoteUnload) end
    if main_conn then pcall(function() main_conn:Disconnect() end) main_conn=nil end
    if gui then pcall(function() gui:Destroy() end) end
    if quick_gui then pcall(function() quick_gui:Destroy() end) end
    if hubGui then pcall(function() hubGui:Destroy() end) end
    if hotbarGui then pcall(function() hotbarGui:Destroy() end) end
    if notifGui then pcall(function() notifGui:Destroy() end) end
    getgenv().DaDa_UIRegistry = nil
    print("[DaDa v16.3] Unloaded")
end

-- ============================================================
-- INIT 21: LOADER GUARD
-- ============================================================
do
    if getgenv().DaDa_LOADED then
        pcall(function() getgenv().DADA_UNLOAD() end)
        task.wait(0.3)
    end
    getgenv().DaDa_LOADED=true
end

-- ============================================================
-- INIT 22: CONFIG SYSTEM
-- ============================================================
local function initConfigs()
    local CONFIG_DIR = "DaDa_configs/"
    local CONFIG_EXT = ".json"
    local CONFIG_LAST = "DaDa_configs/_last.txt"
    local can_read_write = type(isfile)=="function" and type(writefile)=="function" and type(readfile)=="function"
        and type(isfolder)=="function" and type(makefolder)=="function"
    local can_list = type(listfiles)=="function"
    local function ensure_dir()
        if not can_read_write then return false end
        local ok, exists = pcall(isfolder, CONFIG_DIR)
        if not ok or not exists then
            local made = pcall(makefolder, CONFIG_DIR)
            if not made then return false end
        end
        return true
    end
    local function safe_name(name)
        name = tostring(name or "default")
        name = name:gsub("[^%w_%- ]", ""):gsub("%s+", "_")
        name = name:sub(1, 40)
        if name == "" then name = "default" end
        return name
    end
    local function config_path(name)
        return CONFIG_DIR .. safe_name(name) .. CONFIG_EXT
    end
    local function snapshot()
        local data = { _version = "v16", _time = os.time() }
        for k, v in pairs(ST) do
            local t = type(v)
            if t == "number" or t == "string" or t == "boolean" then
                data["ST_"..k] = v
            end
        end
        for k, v in pairs(SHF) do
            local t = type(v)
            if t == "number" or t == "string" or t == "boolean" then
                data["SHF_"..k] = v
            elseif typeof(v) == "Color3" then
                data["SHF_"..k] = { v.R, v.G, v.B, _c = true }
            end
        end
        return data
    end
    local function restore(data)
        if type(data) ~= "table" then return false end
        for k, v in pairs(data) do
            local prefix = string.sub(k, 1, 3)
            local real_k = string.sub(k, 4)
            if prefix == "ST_" then
                ST[real_k] = v
            elseif prefix == "SHF_" then
                if type(v) == "table" and v._c then
                    SHF[real_k] = Color3.new(v[1], v[2], v[3])
                else
                    SHF[real_k] = v
                end
            end
        end
        local reg = getgenv().DaDa_UIRegistry
        if reg then
            for flag, setter in pairs(reg) do
                local v = nil
                if ST[flag] ~= nil then v = ST[flag] end
                if v == nil and SHF[flag] ~= nil then v = SHF[flag] end
                if v ~= nil then
                    pcall(setter, v)
                end
            end
        end
        return true
    end
    local CFG = {}
    function CFG.save(name)
        if not can_read_write or not ensure_dir() then
            if notify then notify("Config", "Файловое API недоступно") end
            return false
        end
        name = safe_name(name)
        local data = snapshot()
        local ok, raw = pcall(function()
            return game:GetService("HttpService"):JSONEncode(data)
        end)
        if not ok or type(raw) ~= "string" then
            if notify then notify("Config", "Ошибка encode") end
            return false
        end
        local ok2 = pcall(writefile, config_path(name), raw)
        if ok2 then
            pcall(writefile, CONFIG_LAST, name)
            if notify then notify("Config", "Сохранено: "..name) end
            return true
        else
            if notify then notify("Config", "Не сохранилось") end
            return false
        end
    end
    function CFG.load(name)
        if not can_read_write then
            if notify then notify("Config", "Файловое API недоступно") end
            return false
        end
        name = safe_name(name)
        local path = config_path(name)
        if not isfile(path) then
            if notify then notify("Config", "Не найдено: "..name) end
            return false
        end
        local ok, raw = pcall(readfile, path)
        if not ok or type(raw) ~= "string" then
            if notify then notify("Config", "Ошибка read") end
            return false
        end
        local ok2, data = pcall(function()
            return game:GetService("HttpService"):JSONDecode(raw)
        end)
        if not ok2 or type(data) ~= "table" then
            if notify then notify("Config", "Ошибка decode") end
            return false
        end
        local ok3 = restore(data)
        if ok3 then
            pcall(writefile, CONFIG_LAST, name)
            if notify then notify("Config", "Загружено: "..name) end
            return true
        end
        return false
    end
    function CFG.delete(name)
        if not can_read_write or type(delfile)~="function" then
            if notify then notify("Config", "Удаление файлов недоступно") end
            return false
        end
        name = safe_name(name)
        local path = config_path(name)
        local okFile, exists = pcall(isfile, path)
        if okFile and exists then
            local okDelete = pcall(delfile, path)
            if okDelete then
                if notify then notify("Config", "Удалено: "..name) end
                return true
            end
        end
        if notify then notify("Config", "Не удалось удалить") end
        return false
    end
    function CFG.list()
        local out = {}
        if not can_list or not ensure_dir() then return out end
        local ok, files = pcall(listfiles, CONFIG_DIR)
        if not ok or type(files) ~= "table" then return out end
        for _, path in ipairs(files) do
            local name = string.match(path, "([^/\\]+)"..CONFIG_EXT.."$")
            if name then out[#out+1] = name end
        end
        table.sort(out)
        return out
    end
    function CFG.last()
        if not can_read_write then return nil end
        local okFile, exists = pcall(isfile, CONFIG_LAST)
        if okFile and exists then
            local ok, name = pcall(readfile, CONFIG_LAST)
            if ok and type(name) == "string" and name ~= "" then return safe_name(name) end
        end
        return nil
    end
    function CFG.reset()
        if notify then notify("Config", "Требуется перезапуск для сброса") end
    end
    getgenv().DaDa_Config = CFG
    task.spawn(function()
        task.wait(3.5)
        local last = CFG.last()
        if last and isfile(config_path(last)) then
            CFG.load(last)
        end
    end)
end
initConfigs()

-- ============================================================
-- INIT 23: DOUBLE JUMP (по твоему коду)
-- ============================================================
do
    local UIS = game:GetService("UserInputService")
    local Players = game:GetService("Players")

    local player = Players.LocalPlayer
    local character
    local humanoid

    local enabled = false
    local jumps = 0
    local maxJumps = 2
    local jumpTick = tick()

    local function onCharacterAdded(newCharacter)
        character = newCharacter
        humanoid = character:WaitForChild("Humanoid")

        jumps = 0
        jumpTick = tick()

        humanoid.StateChanged:Connect(function(_, new)
            if new == Enum.HumanoidStateType.Landed
            or new == Enum.HumanoidStateType.Running
            or new == Enum.HumanoidStateType.RunningNoPhysics then
                jumps = 0
            end
        end)
    end

    UIS.JumpRequest:Connect(function()
        if not enabled then return end
        if not humanoid or humanoid.Health <= 0 then return end
        if jumps < maxJumps and tick() - jumpTick > 0.2 then
            jumpTick = tick()
            jumps += 1
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)

    player.CharacterAdded:Connect(onCharacterAdded)
    if player.Character then
        onCharacterAdded(player.Character)
    end

    getgenv().DADA_DOUBLEJUMP_TOGGLE = function(v)
        enabled = v and true or false
        if not enabled then jumps = 0 end
    end
end

-- ============================================================
-- INIT 24: ANIMATIONS + EMOTES
-- ============================================================
do
    local HttpService = game:GetService("HttpService")

    -- ==========================================================
    -- ANIMATIONS ENGINE
    -- ==========================================================
    do
        local cats = {
            {"Idle","idle"},{"Walk","walk"},{"Run","run"},{"Jump","jump"},
            {"Fall","fall"},{"Climb","climb"},{"Swim","swim"},{"Swim Idle","swimidle"}
        }
        local animItems, byName, mapCache, sel, origMap = {}, {}, {}, {}, {}
        local enabled, animConn = false, nil
        local fetched, pendingApply, applyToken = false, false, 0

        local function getParts()
            local char = LP.Character
            if not char then return end
            return char, char:FindFirstChildOfClass("Humanoid"), char:FindFirstChild("Animate")
        end

        local function stopTracks(hum)
            if not hum then return end
            for _, track in pairs(hum:GetPlayingAnimationTracks()) do
                pcall(function() track:Stop() end)
            end
        end

        local function refreshAnimate(animate, hum)
            if animate and hum and hum.MoveDirection.Magnitude == 0 then
                animate.Disabled = true
                animate.Disabled = false
            end
        end

        local function resolveMappings(data)
            local key = tostring(data.id)
            if mapCache[key] then return mapCache[key] end
            local bundled = data.bundledItems
            if type(bundled) ~= "table" then return nil end
            local mappings = {}
            for _, ids in pairs(bundled) do
                if type(ids) == "table" then
                    for _, assetId in pairs(ids) do
                        local ok, objs = pcall(game.GetObjects, game, "rbxassetid://"..assetId)
                        if ok and objs then
                            local function scan(parent, path)
                                for _, child in ipairs(parent:GetChildren()) do
                                    if child:IsA("Animation") then
                                        local parts = (path.."."..child.Name):split(".")
                                        mappings[#mappings+1] = {
                                            category = parts[#parts-1],
                                            name = parts[#parts],
                                            id = child.AnimationId
                                        }
                                    elseif #child:GetChildren() > 0 then
                                        scan(child, path.."."..child.Name)
                                    end
                                end
                            end
                            for _, o in ipairs(objs) do
                                scan(o, o.Name)
                                pcall(function() o:Destroy() end)
                            end
                        end
                    end
                end
            end
            mapCache[key] = mappings
            return mappings
        end

        local function catItems(data, folderName)
            local mappings = resolveMappings(data)
            if not mappings then return nil end
            local items = {}
            for _, m in ipairs(mappings) do
                if m.category and m.category:lower() == folderName then
                    items[m.name:lower()] = m.id
                end
            end
            return items
        end

        local function applyCat(animate, folderName, data)
            if not (animate and data) then return end
            local items = catItems(data, folderName)
            if not (items and next(items)) then return end
            local folder = animate:FindFirstChild(folderName)
            if not folder then return end
            local _, first = next(items)
            for _, a in ipairs(folder:GetChildren()) do
                if a:IsA("Animation") then
                    local id = items[a.Name:lower()] or first
                    if id then
                        if origMap[a] == nil then origMap[a] = a.AnimationId end
                        a.AnimationId = id
                        a.Parent = nil
                        a.Parent = folder
                    end
                end
            end
        end

        local function applyAll(animate)
            for _, c in ipairs(cats) do
                local name = sel[c[2]]
                if name and name ~= "none" and byName[name] then
                    applyCat(animate, c[2], byName[name])
                end
            end
        end

        local function restore()
            for a, id in pairs(origMap) do
                if a and a.Parent then
                    pcall(function()
                        local folder = a.Parent
                        a.AnimationId = id
                        a.Parent = nil
                        a.Parent = folder
                    end)
                end
            end
            origMap = {}
        end

        local function doApply()
            applyToken = applyToken + 1
            local token = applyToken
            task.spawn(function()
                local _, hum, animate = getParts()
                if not animate or token ~= applyToken then return end
                stopTracks(hum)
                restore()
                applyAll(animate)
                if token == applyToken then
                    refreshAnimate(animate, hum)
                end
            end)
        end

        local function requestApply()
            if not enabled then return end
            if not fetched then
                pendingApply = true
                return
            end
            doApply()
        end

        local function fetchAll()
            local urls = {
                "https://raw.githubusercontent.com/7yd7/sniper-Emote/refs/heads/test/AnimationSniper.json",
                "https://raw.githubusercontent.com/7yd7/sniper-Emote/refs/heads/test/AnimationSniperoffsale.json"
            }
            local seen = {}
            for _, url in ipairs(urls) do
                local ok, res = pcall(function()
                    local c = game:HttpGet(url)
                    return c ~= "" and HttpService:JSONDecode(c) or nil
                end)
                if ok and type(res) == "table" then
                    local list = res.data or res
                    for _, item in pairs(list) do
                        local id = tonumber(item.id)
                        if id and id > 0 and item.bundledItems and not seen[id] then
                            seen[id] = true
                            local nm = tostring(item.name or ("Animation_"..id))
                            if byName[nm] then nm = nm.." ["..id.."]" end
                            byName[nm] = {id = id, bundledItems = item.bundledItems}
                            animItems[#animItems+1] = {name = nm, id = id}
                        end
                    end
                end
            end
        end

        local function bind_respawn()
            if animConn then return end
            animConn = LP.CharacterAdded:Connect(function(c)
                c:WaitForChild("Humanoid")
                local animate = c:WaitForChild("Animate", 5)
                task.wait(0.3)
                if enabled and animate then
                    origMap = {}
                    requestApply()
                end
            end)
        end

        local function drop_respawn()
            if animConn then pcall(function() animConn:Disconnect() end) animConn = nil end
        end

        local function wipe_anims()
            local _, hum, animate = getParts()
            stopTracks(hum)
            restore()
            refreshAnimate(animate, hum)
        end

        SHF.animApply = function(name, catKey)
            if catKey == "all" then
                for _, c in ipairs(cats) do
                    if name then sel[c[2]] = name else sel[c[2]] = nil end
                end
            else
                if name then sel[catKey] = name else sel[catKey] = nil end
            end
            enabled = false
            for _, v in pairs(sel) do
                if v then enabled = true; break end
            end
            if enabled then
                bind_respawn()
                requestApply()
            else
                pendingApply = false
                applyToken = applyToken + 1
                drop_respawn()
                wipe_anims()
            end
        end
        SHF.animReset = function()
            for k in pairs(sel) do sel[k] = nil end
            SHF.animApply(nil, "all")
        end

        getgenv().DADA_ANIM_APPLY = function(name)
            local cat = getgenv().DADA_ANIM_CAT or "all"
            SHF.animApply(name, cat)
        end
        getgenv().DADA_ANIM_RESET = function()
            SHF.animReset()
        end

        task.spawn(function()
            fetchAll()
            fetched = true
            task.wait(1)
            if notify then pcall(notify, "Animations", "Загружено "..#animItems.." паков") end
        end)
    end

    -- ==========================================================
    -- EMOTES ENGINE
    -- ==========================================================
    do
        local emoteFile = "emotes.json"
        local statEmotes = {
            {"Griddy", "129149402922241"}
        }
        local custEmotes, emoteMap, emoteList, animCache = {}, {}, {}, {}
        local allList, allMap = {}, {}
        local curTrack, selId, custRaw, alive = nil, nil, nil, true

        local function parseCustom()
            if not (isfile and isfile(emoteFile)) then
                if custRaw ~= nil then custRaw, custEmotes = nil, {} return true end
                return false
            end
            local ok, raw = pcall(readfile, emoteFile)
            if not ok or raw == custRaw then return false end
            custRaw, custEmotes = raw, {}
            local dok, data = pcall(function() return HttpService:JSONDecode(raw) end)
            if dok and type(data) == "table" then
                for k, v in pairs(data) do
                    local name, id
                    if type(v) == "table" then
                        name, id = tostring(v.name or v[1] or k), tostring(v.id or v[2] or "")
                    else
                        name, id = tostring(k), tostring(v)
                    end
                    if name ~= "" and id ~= "" then
                        custEmotes[#custEmotes+1] = {name, id}
                    end
                end
            end
            return true
        end

        local function buildList()
            emoteMap, emoteList = {}, {}
            local function add(name, id)
                name = tostring(name)
                if emoteMap[name] then name = name.." ["..tostring(id).."]" end
                emoteMap[name] = tostring(id)
                emoteList[#emoteList+1] = {name = name, id = tonumber((tostring(id):gsub("%D", ""))) or id}
            end
            for _, e in ipairs(statEmotes) do add(e[1], e[2]) end
            for _, e in ipairs(custEmotes) do add(e[1], e[2]) end
            for _, e in ipairs(allList) do add(e.name, e.id) end
        end

        parseCustom()
        buildList()

        local function getHum()
            local char = LP.Character
            return char and char:FindFirstChildOfClass("Humanoid")
        end

        local function stopEmote()
            if curTrack then
                pcall(function() curTrack:Stop() end)
                curTrack = nil
            end
        end

        local function resolveId(id)
            if animCache[id] then return animCache[id] end
            if id:find("://") then animCache[id] = id return id end
            local raw = id:gsub("%D", "")
            local ok, objs = pcall(game.GetObjects, game, "rbxassetid://"..raw)
            if ok and type(objs) == "table" then
                local found
                local function scan(inst)
                    if found then return end
                    if inst:IsA("Animation") and inst.AnimationId ~= "" then
                        found = inst.AnimationId
                        return
                    end
                    for _, c in ipairs(inst:GetChildren()) do scan(c) end
                end
                for _, o in ipairs(objs) do
                    scan(o)
                    pcall(function() o:Destroy() end)
                end
                if found then animCache[id] = found return found end
            end
            local url = "rbxassetid://"..raw
            animCache[id] = url
            return url
        end

        local function playEmote()
            local hum = getHum()
            if not hum or not selId then return end
            stopEmote()
            local anim = Instance.new("Animation")
            anim.AnimationId = resolveId(selId)
            local ok, track = pcall(function() return hum:LoadAnimation(anim) end)
            anim:Destroy()
            if ok and track then
                track.Priority = Enum.AnimationPriority.Action
                track.Looped = true
                track:Play()
                curTrack = track
            end
        end

        local function fetchEmotes()
            local ok, res = pcall(function()
                local c = game:HttpGet("https://raw.githubusercontent.com/7yd7/sniper-Emote/refs/heads/test/EmoteSniper.json")
                return c ~= "" and HttpService:JSONDecode(c) or nil
            end)
            if ok and type(res) == "table" then
                local list = res.data or res
                local seen = {}
                for _, item in pairs(list) do
                    local id = tonumber(item.id)
                    if id and id > 0 and not seen[id] then
                        seen[id] = true
                        local nm = tostring(item.name or ("Emote_"..id))
                        if allMap[nm] then nm = nm.." ["..id.."]" end
                        allMap[nm] = tostring(id)
                        allList[#allList+1] = {name = nm, id = id}
                    end
                end
            end
        end

        SHF.emotePlay = function(name)
            if type(name) ~= "string" or name == "" then
                selId = nil
                stopEmote()
                return
            end
            selId = emoteMap[name]
            if selId then playEmote() else stopEmote() end
        end
        SHF.emoteStop = function()
            selId = nil
            stopEmote()
        end

        getgenv().DADA_EMOTE_PLAY = SHF.emotePlay
        getgenv().DADA_EMOTE_STOP = SHF.emoteStop

        local char_conn = LP.CharacterAdded:Connect(function()
            task.wait(1)
            if selId then playEmote() end
        end)

        task.spawn(function()
            fetchEmotes()
            buildList()
            if notify then pcall(notify, "Emotes", "Загружено "..#emoteList.." эмоций") end
        end)

        task.spawn(function()
            while alive and task.wait(3) do
                if parseCustom() then
                    buildList()
                end
            end
        end)

        SHF.emoteUnload = function()
            alive = false
            selId = nil
            stopEmote()
            if char_conn then pcall(function() char_conn:Disconnect() end) char_conn = nil end
        end
    end

    task.wait(1)
    if notify then pcall(notify, "DaDa", "Animations + Emotes загружены") end
end

notify("DaDa v16.3","здраствуй в царство воин")
print("[DaDa v16.3] кароч ку это значит то что скрипт загружен и тд кароч приятной игры")