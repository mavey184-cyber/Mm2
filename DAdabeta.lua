local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DadaGui_" .. math.random(1000, 9999)
ScreenGui.ResetOnSpawn = false

pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local function ColorToHex(color)
    local r = math.clamp(math.floor(color.R * 255), 0, 255)
    local g = math.clamp(math.floor(color.G * 255), 0, 255)
    local b = math.clamp(math.floor(color.B * 255), 0, 255)
    return string.format("#%02X%02X%02X", r, g, b)
end

local function HexToColor(hex)
    hex = hex:gsub("#", "")
    if #hex == 6 then
        local r = tonumber(hex:sub(1, 2), 16)
        local g = tonumber(hex:sub(3, 4), 16)
        local b = tonumber(hex:sub(5, 6), 16)
        if r and g and b then
            return Color3.fromRGB(r, g, b)
        end
    end
    return nil
end

-- Кнопка открытия главного GUI
local OpenButton = Instance.new("TextButton")
OpenButton.Name = "OpenBtn"
OpenButton.Size = UDim2.new(0, 100, 0, 40)
OpenButton.Position = UDim2.new(0.05, 0, 0.4, 0)
OpenButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
OpenButton.Text = "Dada"
OpenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenButton.TextSize = 16
OpenButton.Font = Enum.Font.SourceSansBold
OpenButton.Active = true
OpenButton.Draggable = true
OpenButton.Parent = ScreenGui

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 8)
BtnCorner.Parent = OpenButton

local BtnStroke = Instance.new("UIStroke")
BtnStroke.Color = Color3.fromRGB(128, 128, 128)
BtnStroke.Thickness = 2
BtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
BtnStroke.Parent = OpenButton

-- Основное окно
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 550, 0, 400)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local FrameCorner = Instance.new("UICorner")
FrameCorner.CornerRadius = UDim.new(0, 12)
FrameCorner.Parent = MainFrame

local FrameStroke = Instance.new("UIStroke")
FrameStroke.Color = Color3.fromRGB(128, 128, 128)
FrameStroke.Thickness = 1.5
FrameStroke.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -50, 0, 45)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Dada Menu"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 22
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = MainFrame

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 35, 0, 35)
CloseButton.Position = UDim2.new(1, -40, 0, 5)
CloseButton.BackgroundTransparency = 1
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.TextSize = 22
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.Parent = MainFrame

-- Боковой контейнер (Вкладки)
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 130, 1, -55)
Sidebar.Position = UDim2.new(0, 10, 0, 45)
Sidebar.BackgroundTransparency = 1
Sidebar.Parent = MainFrame

local TabSelector = Instance.new("Frame")
TabSelector.Name = "TabSelector"
TabSelector.Size = UDim2.new(1, 0, 0, 40)
TabSelector.Position = UDim2.new(0, 0, 0, 0)
TabSelector.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TabSelector.BackgroundTransparency = 0.85
TabSelector.Parent = Sidebar

local SelectorCorner = Instance.new("UICorner")
SelectorCorner.CornerRadius = UDim.new(0, 8)
SelectorCorner.Parent = TabSelector

local SelectorStroke = Instance.new("UIStroke")
SelectorStroke.Color = Color3.fromRGB(255, 255, 255)
SelectorStroke.Transparency = 0.6
SelectorStroke.Thickness = 1
SelectorStroke.Parent = TabSelector

local PagesContainer = Instance.new("Frame")
PagesContainer.Name = "PagesContainer"
PagesContainer.Size = UDim2.new(1, -155, 1, -55)
PagesContainer.Position = UDim2.new(0, 145, 0, 45)
PagesContainer.BackgroundTransparency = 1
PagesContainer.Parent = MainFrame

local tabNames = {"Main", "Combat", "Visual", "Fling"}
local tabButtons = {}
local pages = {}
local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

for i, tabName in ipairs(tabNames) do
    local TabButton = Instance.new("TextButton")
    TabButton.Name = tabName .. "Tab"
    TabButton.Size = UDim2.new(1, 0, 0, 40)
    TabButton.Position = UDim2.new(0, 0, 0, (i - 1) * 45)
    TabButton.BackgroundTransparency = 1
    TabButton.Text = tabName
    TabButton.TextColor3 = i == 1 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150)
    TabButton.TextSize = 16
    TabButton.Font = Enum.Font.SourceSansBold
    TabButton.Parent = Sidebar
    tabButtons[i] = TabButton

    local Page = Instance.new("Frame")
    Page.Name = tabName .. "Page"
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = (i == 1)
    Page.Parent = PagesContainer
    pages[i] = Page

    TabButton.MouseButton1Click:Connect(function()
        pcall(function()
            TweenService:Create(TabSelector, tweenInfo, {Position = UDim2.new(0, 0, 0, (i - 1) * 45)}):Play()
            for btnIdx, btn in ipairs(tabButtons) do
                local targetColor = (btnIdx == i) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150)
                TweenService:Create(btn, tweenInfo, {TextColor3 = targetColor}):Play()
                pages[btnIdx].Visible = (btnIdx == i)
            end
        end)
    end)
end

local MainPage = pages[1]
local CombatPage = pages[2]

-- Колонки для Main вкладки
local LeftColumn = Instance.new("ScrollingFrame")
LeftColumn.Name = "LeftColumn"
LeftColumn.Size = UDim2.new(0.48, 0, 1, -10)
LeftColumn.BackgroundTransparency = 1
LeftColumn.ScrollBarThickness = 2
LeftColumn.Parent = MainPage

local LeftList = Instance.new("UIListLayout")
LeftList.SortOrder = Enum.SortOrder.LayoutOrder
LeftList.Padding = UDim.new(0, 10)
LeftList.Parent = LeftColumn

local RightColumn = Instance.new("ScrollingFrame")
RightColumn.Name = "RightColumn"
RightColumn.Size = UDim2.new(0.48, 0, 1, -10)
RightColumn.Position = UDim2.new(0.52, 0, 0, 0)
RightColumn.BackgroundTransparency = 1
RightColumn.ScrollBarThickness = 2
RightColumn.Parent = MainPage

local RightList = Instance.new("UIListLayout")
RightList.SortOrder = Enum.SortOrder.LayoutOrder
RightList.Padding = UDim.new(0, 10)
RightList.Parent = RightColumn

-- Колонки для Combat вкладки
local CombatLeftColumn = Instance.new("ScrollingFrame")
CombatLeftColumn.Name = "CombatLeftColumn"
CombatLeftColumn.Size = UDim2.new(0.48, 0, 1, -10)
CombatLeftColumn.BackgroundTransparency = 1
CombatLeftColumn.ScrollBarThickness = 2
CombatLeftColumn.Parent = CombatPage

local CombatLeftList = Instance.new("UIListLayout")
CombatLeftList.SortOrder = Enum.SortOrder.LayoutOrder
CombatLeftList.Padding = UDim.new(0, 10)
CombatLeftList.Parent = CombatLeftColumn

-- Настройки функций
local MovementSettings = {
    Noclip = false,
    InfJump = false,
    AntiFling = false,
    Fly = false,
    FlySpeed = 50,
    Bhop = false,
    BhopMaxSpeed = 80,
    Spin = false,
    SpinSpeed = 30,
    QuickMenu = false,
    QuickMenuCorner = "Bottom-Right",
    QuickMenuOffsetY = 280
}

local CombatSettings = {
    SilentAim = false,
    PredictionStrength = 10,
    ForceShoot = false,
    GetGun = false,
    GetGunMode = "Touch" -- "Touch", "Teleport", "PlayerTP"
}

local QuickBinds = {
    Noclip = Enum.KeyCode.Unknown,
    InfJump = Enum.KeyCode.Unknown,
    AntiFling = Enum.KeyCode.Unknown,
    Fly = Enum.KeyCode.Unknown,
    Bhop = Enum.KeyCode.Unknown,
    Spin = Enum.KeyCode.Unknown,
    SilentAim = Enum.KeyCode.Unknown
}

-- Конфигурация ESP
local EspSettings = { Enabled = false, Outline = false, Chams = false, Name = false, Meters = false, Line = false }
local XraySettings = { Enabled = false, Transparency = 0.5, ColorMode = false, Color = Color3.fromRGB(255, 0, 127) }
local GunEspSettings = { Enabled = false, Fill = true, Color = Color3.fromRGB(255, 255, 0) }
local BoxSettings = { Enabled = false, BoxType = "Box", BoxFill = false }
local GradientColors = { Top = Color3.fromRGB(255, 0, 0), Bottom = Color3.fromRGB(0, 0, 255) }
local FillColors = { Top = Color3.fromRGB(255, 0, 0), Bottom = Color3.fromRGB(0, 0, 255) }
local RoleColors = { Murderer = Color3.fromRGB(255, 0, 0), Sheriff = Color3.fromRGB(0, 0, 255), Hero = Color3.fromRGB(255, 255, 0), Innocent = Color3.fromRGB(0, 255, 0), Default = Color3.fromRGB(200, 200, 200) }

local toggleCallbacks = {}
local toggleVisualUpdaters = {}

local function CreateFeatureCard(titleText, layoutOrder, parentContainer)
    local Card = Instance.new("Frame")
    Card.Name = titleText .. "Card"
    Card.Size = UDim2.new(1, 0, 0, 40)
    Card.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Card.LayoutOrder = layoutOrder
    Card.Parent = parentContainer or LeftColumn

    local CardCorner = Instance.new("UICorner")
    CardCorner.CornerRadius = UDim.new(0, 8)
    CardCorner.Parent = Card

    local CardStroke = Instance.new("UIStroke")
    CardStroke.Color = Color3.fromRGB(60, 60, 60)
    CardStroke.Thickness = 1
    CardStroke.Parent = Card

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0, 100, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = titleText
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 16
    Label.Font = Enum.Font.SourceSansBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Card

    local SettingsBtn = Instance.new("TextButton")
    SettingsBtn.Name = "SettingsBtn"
    SettingsBtn.Size = UDim2.new(0, 26, 0, 26)
    SettingsBtn.Position = UDim2.new(1, -75, 0.5, -13)
    SettingsBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    SettingsBtn.Text = "-"
    SettingsBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    SettingsBtn.TextSize = 18
    SettingsBtn.Font = Enum.Font.SourceSansBold
    SettingsBtn.Parent = Card

    local SettingsBtnCorner = Instance.new("UICorner")
    SettingsBtnCorner.CornerRadius = UDim.new(0, 6)
    SettingsBtnCorner.Parent = SettingsBtn

    local ToggleBG = Instance.new("Frame")
    ToggleBG.Name = "ToggleBG"
    ToggleBG.Size = UDim2.new(0, 36, 0, 20)
    ToggleBG.Position = UDim2.new(1, -42, 0.5, -10)
    ToggleBG.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ToggleBG.Parent = Card

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(1, 0)
    ToggleCorner.Parent = ToggleBG

    local ToggleBall = Instance.new("Frame")
    ToggleBall.Name = "ToggleBall"
    ToggleBall.Size = UDim2.new(0, 16, 0, 16)
    ToggleBall.Position = UDim2.new(0, 2, 0.5, -8)
    ToggleBall.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
    ToggleBall.Parent = ToggleBG

    local BallCorner = Instance.new("UICorner")
    BallCorner.CornerRadius = UDim.new(1, 0)
    BallCorner.Parent = ToggleBall

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(1, 0, 1, 0)
    ToggleBtn.BackgroundTransparency = 1
    ToggleBtn.Text = ""
    ToggleBtn.Parent = ToggleBG

    local SubContainer = Instance.new("Frame")
    SubContainer.Name = titleText .. "SubContainer"
    SubContainer.Size = UDim2.new(1, 0, 0, 0)
    SubContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    SubContainer.Visible = false
    SubContainer.LayoutOrder = layoutOrder + 1
    SubContainer.Parent = parentContainer or LeftColumn

    local SubCorner = Instance.new("UICorner")
    SubCorner.CornerRadius = UDim.new(0, 8)
    SubCorner.Parent = SubContainer

    local SubStroke = Instance.new("UIStroke")
    SubStroke.Color = Color3.fromRGB(50, 50, 50)
    SubStroke.Thickness = 1
    SubStroke.Parent = SubContainer

    local SubList = Instance.new("UIListLayout")
    SubList.SortOrder = Enum.SortOrder.LayoutOrder
    SubList.Padding = UDim.new(0, 4)
    SubList.Parent = SubContainer

    local SubPadding = Instance.new("UIPadding")
    SubPadding.PaddingTop = UDim.new(0, 6)
    SubPadding.PaddingBottom = UDim.new(0, 6)
    SubPadding.PaddingLeft = UDim.new(0, 8)
    SubPadding.PaddingRight = UDim.new(0, 8)
    SubPadding.Parent = SubContainer

    SettingsBtn.MouseButton1Click:Connect(function()
        pcall(function()
            SubContainer.Visible = not SubContainer.Visible
        end)
    end)

    return Card, ToggleBtn, ToggleBall, ToggleBG, SubContainer, SubList
end

local function SetupToggleVisual(toggleBtn, toggleBall, toggleBG, configTable, configKey, callback)
    local function updateVisualState(state, animate)
        if animate == nil then animate = true end
        if state then
            if animate then
                TweenService:Create(toggleBall, tweenInfo, {Position = UDim2.new(1, -18, 0.5, -8), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
                TweenService:Create(toggleBG, tweenInfo, {BackgroundColor3 = Color3.fromRGB(80, 80, 80)}):Play()
            else
                toggleBall.Position = UDim2.new(1, -18, 0.5, -8)
                toggleBall.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                toggleBG.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            end
        else
            if animate then
                TweenService:Create(toggleBall, tweenInfo, {Position = UDim2.new(0, 2, 0.5, -8), BackgroundColor3 = Color3.fromRGB(128, 128, 128)}):Play()
                TweenService:Create(toggleBG, tweenInfo, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
            else
                toggleBall.Position = UDim2.new(0, 2, 0.5, -8)
                toggleBall.BackgroundColor3 = Color3.fromRGB(160, 160, 170)
                toggleBG.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            end
        end
    end

    toggleVisualUpdaters[configKey] = updateVisualState
    if callback then toggleCallbacks[configKey] = callback end

    toggleBtn.MouseButton1Click:Connect(function()
        pcall(function()
            configTable[configKey] = not configTable[configKey]
            updateVisualState(configTable[configKey], true)
            if callback then callback(configTable[configKey]) end
        end)
    end)
end

local function ToggleFeatureState(keyName)
    if MovementSettings[keyName] ~= nil then
        MovementSettings[keyName] = not MovementSettings[keyName]
        if toggleVisualUpdaters[keyName] then
            toggleVisualUpdaters[keyName](MovementSettings[keyName], true)
        end
        if toggleCallbacks[keyName] then
            toggleCallbacks[keyName](MovementSettings[keyName])
        end
    elseif CombatSettings[keyName] ~= nil then
        CombatSettings[keyName] = not CombatSettings[keyName]
        if toggleVisualUpdaters[keyName] then
            toggleVisualUpdaters[keyName](CombatSettings[keyName], true)
        end
        if toggleCallbacks[keyName] then
            toggleCallbacks[keyName](CombatSettings[keyName])
        end
    end
end

-- Слева карточки (Main)
local XrayCard, XrayToggleBtn, XrayToggleBall, XrayToggleBG, XraySubContainer, XraySubList = CreateFeatureCard("X-Ray", 1, LeftColumn)
local EspGunCard, EspGunToggleBtn, EspGunToggleBall, EspGunToggleBG, EspGunSubContainer, EspGunSubList = CreateFeatureCard("Esp Gun", 3, LeftColumn)
local EspCard, EspToggleBtn, EspToggleBall, EspToggleBG, EspSubContainer, EspSubList = CreateFeatureCard("ESP", 5, LeftColumn)
local BoxCard, BoxToggleBtn, BoxToggleBall, BoxToggleBG, BoxSubContainer, BoxSubList = CreateFeatureCard("Box ESP", 7, LeftColumn)

-- Справа карточки (Main)
local NoclipCard, NoclipToggleBtn, NoclipToggleBall, NoclipToggleBG = CreateFeatureCard("Noclip", 1, RightColumn)
local InfJumpCard, InfJumpToggleBtn, InfJumpToggleBall, InfJumpToggleBG = CreateFeatureCard("Inf Jump", 2, RightColumn)
local AntiFlingCard, AntiFlingToggleBtn, AntiFlingToggleBall, AntiFlingToggleBG = CreateFeatureCard("Anti-Fling", 3, RightColumn)
local FlyCard, FlyToggleBtn, FlyToggleBall, FlyToggleBG, FlySubContainer, FlySubList = CreateFeatureCard("Fly", 4, RightColumn)
local BhopCard, BhopToggleBtn, BhopToggleBall, BhopToggleBG, BhopSubContainer, BhopSubList = CreateFeatureCard("Bhop", 5, RightColumn)
local SpinCard, SpinToggleBtn, SpinToggleBall, SpinToggleBG, SpinSubContainer, SpinSubList = CreateFeatureCard("Spin", 6, RightColumn)
local QuickMenuCard, QuickMenuToggleBtn, QuickMenuToggleBall, QuickMenuToggleBG, QuickMenuSubContainer, QuickMenuSubList = CreateFeatureCard("Quick Menu", 7, RightColumn)

-- Карточки во вкладке Combat (Слева)
local SilentAimCard, SilentAimToggleBtn, SilentAimToggleBall, SilentAimToggleBG, SilentAimSubContainer, SilentAimSubList = CreateFeatureCard("Silent Aim", 1, CombatLeftColumn)
local ForceShootCard, ForceShootToggleBtn, ForceShootToggleBall, ForceShootToggleBG, ForceShootSubContainer, ForceShootSubList = CreateFeatureCard("Force Shoot", 2, CombatLeftColumn)
local GetGunCard, GetGunToggleBtn, GetGunToggleBall, GetGunToggleBG, GetGunSubContainer, GetGunSubList = CreateFeatureCard("Get Gun", 3, CombatLeftColumn)

SetupToggleVisual(NoclipToggleBtn, NoclipToggleBall, NoclipToggleBG, MovementSettings, "Noclip")
SetupToggleVisual(InfJumpToggleBtn, InfJumpToggleBall, InfJumpToggleBG, MovementSettings, "InfJump")
SetupToggleVisual(AntiFlingToggleBtn, AntiFlingToggleBall, AntiFlingToggleBG, MovementSettings, "AntiFling")
SetupToggleVisual(BhopToggleBtn, BhopToggleBall, BhopToggleBG, MovementSettings, "Bhop")
SetupToggleVisual(SpinToggleBtn, SpinToggleBall, SpinToggleBG, MovementSettings, "Spin")
SetupToggleVisual(SilentAimToggleBtn, SilentAimToggleBall, SilentAimToggleBG, CombatSettings, "SilentAim")
SetupToggleVisual(ForceShootToggleBtn, ForceShootToggleBall, ForceShootToggleBG, CombatSettings, "ForceShoot")
SetupToggleVisual(GetGunToggleBtn, GetGunToggleBall, GetGunToggleBG, CombatSettings, "GetGun")

local mapOriginalTransparencies, mapOriginalColors = {}, {}
local function ApplyXray()
    for _, part in ipairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and not part:IsDescendantOf(LocalPlayer.Character) and not part.Parent:FindFirstChild("Humanoid") then
            if XraySettings.Enabled then
                if not mapOriginalTransparencies[part] then
                    mapOriginalTransparencies[part] = part.LocalTransparencyModifier
                    mapOriginalColors[part] = part.Color
                end
                part.LocalTransparencyModifier = XraySettings.Transparency
                if XraySettings.ColorMode then
                    part.Color = XraySettings.Color
                else
                    if mapOriginalColors[part] then part.Color = mapOriginalColors[part] end
                end
            else
                if mapOriginalTransparencies[part] then
                    part.LocalTransparencyModifier = mapOriginalTransparencies[part]
                    mapOriginalTransparencies[part] = nil
                end
                if mapOriginalColors[part] then
                    part.Color = mapOriginalColors[part]
                    mapOriginalColors[part] = nil
                end
            end
        end
    end
end

SetupToggleVisual(XrayToggleBtn, XrayToggleBall, XrayToggleBG, XraySettings, "Enabled", function() ApplyXray() end)
SetupToggleVisual(EspGunToggleBtn, EspGunToggleBall, EspGunToggleBG, GunEspSettings, "Enabled")
SetupToggleVisual(EspToggleBtn, EspToggleBall, EspToggleBG, EspSettings, "Enabled")
SetupToggleVisual(BoxToggleBtn, BoxToggleBall, BoxToggleBG, BoxSettings, "Enabled")

local flyBodyVel, flyBodyGyro = nil, nil
local function ToggleFly(enabled)
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildWhichIsA("Humanoid")
    if not hrp or not hum then return end

    if enabled then
        flyBodyVel = Instance.new("BodyVelocity")
        flyBodyVel.Name = "DadaFlyVel"
        flyBodyVel.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        flyBodyVel.Velocity = Vector3.zero
        flyBodyVel.Parent = hrp

        flyBodyGyro = Instance.new("BodyGyro")
        flyBodyGyro.Name = "DadaFlyGyro"
        flyBodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        flyBodyGyro.CFrame = hrp.CFrame
        flyBodyGyro.Parent = hrp

        hum.PlatformStand = true
    else
        if flyBodyVel then flyBodyVel:Destroy(); flyBodyVel = nil end
        if flyBodyGyro then flyBodyGyro:Destroy(); flyBodyGyro = nil end
        hum.PlatformStand = false
    end
end

SetupToggleVisual(FlyToggleBtn, FlyToggleBall, FlyToggleBG, MovementSettings, "Fly", function(val)
    ToggleFly(val)
end)

local function CreateSubToggle(parentContainer, name, configTable, configKey, callback)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, -10, 0, 28)
    Row.BackgroundTransparency = 1
    Row.Parent = parentContainer

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.TextSize = 13
    Label.Font = Enum.Font.SourceSans
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Row

    local CheckBox = Instance.new("TextButton")
    CheckBox.Size = UDim2.new(0, 18, 0, 18)
    CheckBox.Position = UDim2.new(1, -20, 0.5, -9)
    CheckBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    CheckBox.Text = ""
    CheckBox.Parent = Row

    local CBCorner = Instance.new("UICorner")
    CBCorner.CornerRadius = UDim.new(0, 4)
    CBCorner.Parent = CheckBox

    CheckBox.MouseButton1Click:Connect(function()
        pcall(function()
            configTable[configKey] = not configTable[configKey]
            if configTable[configKey] then
                CheckBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                CheckBox.Text = "✓"
                CheckBox.TextColor3 = Color3.fromRGB(0, 0, 0)
            else
                CheckBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                CheckBox.Text = ""
            end
            if callback then callback() end
        end)
    end)
end

local function CreateSlider(parentContainer, name, minVal, maxVal, defaultVal, callback)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, -10, 0, 36)
    Row.BackgroundTransparency = 1
    Row.Parent = parentContainer

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 15)
    Label.BackgroundTransparency = 1
    Label.Text = name .. ": " .. tostring(math.floor(defaultVal))
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.TextSize = 12
    Label.Font = Enum.Font.SourceSans
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Row

    local SliderBG = Instance.new("Frame")
    SliderBG.Size = UDim2.new(1, 0, 0, 8)
    SliderBG.Position = UDim2.new(0, 0, 0, 20)
    SliderBG.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    SliderBG.Parent = Row

    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(1, 0)
    SliderCorner.Parent = SliderBG

    local startRatio = (defaultVal - minVal) / (maxVal - minVal)
    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new(startRatio, 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SliderFill.Parent = SliderBG

    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = SliderFill

    local dragging = false
    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - SliderBG.AbsolutePosition.X) / SliderBG.AbsoluteSize.X, 0, 1)
        SliderFill.Size = UDim2.new(pos, 0, 1, 0)
        local val = minVal + (maxVal - minVal) * pos
        Label.Text = name .. ": " .. tostring(math.floor(val))
        callback(val)
    end

    SliderBG.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateSlider(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)
end

-- Слайдеры
CreateSlider(SilentAimSubContainer, "Prediction Strength (%)", 0, 100, 10, function(val)
    CombatSettings.PredictionStrength = val
end)

CreateSlider(FlySubContainer, "Fly Speed", 10, 200, 50, function(val)
    MovementSettings.FlySpeed = val
end)

CreateSlider(BhopSubContainer, "Max Speed", 20, 200, 80, function(val)
    MovementSettings.BhopMaxSpeed = val
end)

CreateSlider(SpinSubContainer, "Spin Speed", 5, 100, 30, function(val)
    MovementSettings.SpinSpeed = val
end)

CreateSlider(QuickMenuSubContainer, "Menu Y Height", 50, 500, 280, function(val)
    MovementSettings.QuickMenuOffsetY = val
end)

CreateSlider(XraySubContainer, "Transparency", 0, 1, 0.5, function(val)
    XraySettings.Transparency = val
    if XraySettings.Enabled then ApplyXray() end
end)
CreateSubToggle(XraySubContainer, "Color Mode", XraySettings, "ColorMode", function()
    if XraySettings.Enabled then ApplyXray() end
end)

CreateSubToggle(EspGunSubContainer, "Gun Fill", GunEspSettings, "Fill")
CreateSubToggle(EspSubContainer, "Outline", EspSettings, "Outline")
CreateSubToggle(EspSubContainer, "Chams", EspSettings, "Chams")
CreateSubToggle(EspSubContainer, "Name", EspSettings, "Name")
CreateSubToggle(EspSubContainer, "Meters", EspSettings, "Meters")
CreateSubToggle(EspSubContainer, "Line", EspSettings, "Line")
CreateSubToggle(BoxSubContainer, "Box Fill", BoxSettings, "BoxFill")

-- Селектор режима для Get Gun (Touch / Teleport / PlayerTP)
local GetGunModeRow = Instance.new("Frame")
GetGunModeRow.Size = UDim2.new(1, -10, 0, 28)
GetGunModeRow.BackgroundTransparency = 1
GetGunModeRow.Parent = GetGunSubContainer

local GetGunModeLabel = Instance.new("TextLabel")
GetGunModeLabel.Size = UDim2.new(0.5, 0, 1, 0)
GetGunModeLabel.BackgroundTransparency = 1
GetGunModeLabel.Text = "Grab Mode"
GetGunModeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
GetGunModeLabel.TextSize = 12
GetGunModeLabel.Font = Enum.Font.SourceSans
GetGunModeLabel.TextXAlignment = Enum.TextXAlignment.Left
GetGunModeLabel.Parent = GetGunModeRow

local GetGunModeBtn = Instance.new("TextButton")
GetGunModeBtn.Size = UDim2.new(0, 90, 0, 20)
GetGunModeBtn.Position = UDim2.new(1, -90, 0.5, -10)
GetGunModeBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
GetGunModeBtn.Text = CombatSettings.GetGunMode
GetGunModeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
GetGunModeBtn.TextSize = 11
GetGunModeBtn.Font = Enum.Font.SourceSansBold
GetGunModeBtn.Parent = GetGunModeRow

local GetGunModeCorner = Instance.new("UICorner")
GetGunModeCorner.CornerRadius = UDim.new(0, 4)
GetGunModeCorner.Parent = GetGunModeBtn

local gunModes = {"Touch", "Teleport", "PlayerTP"}
GetGunModeBtn.MouseButton1Click:Connect(function()
    pcall(function()
        local idx = 1
        for i, m in ipairs(gunModes) do
            if m == CombatSettings.GetGunMode then idx = i break end
        end
        idx = (idx % #gunModes) + 1
        CombatSettings.GetGunMode = gunModes[idx]
        GetGunModeBtn.Text = gunModes[idx]
    end)
end)

-- Настройка биндов
local function CreateKeybindPicker(parentContainer, name, keyName)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, -10, 0, 28)
    Row.BackgroundTransparency = 1
    Row.Parent = parentContainer

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.6, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name .. " Key"
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.TextSize = 12
    Label.Font = Enum.Font.SourceSans
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Row

    local BindBtn = Instance.new("TextButton")
    BindBtn.Size = UDim2.new(0, 60, 0, 20)
    BindBtn.Position = UDim2.new(1, -60, 0.5, -10)
    BindBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    BindBtn.Text = QuickBinds[keyName] ~= Enum.KeyCode.Unknown and QuickBinds[keyName].Name or "None"
    BindBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    BindBtn.TextSize = 11
    BindBtn.Font = Enum.Font.SourceSansBold
    BindBtn.Parent = Row

    local BindCorner = Instance.new("UICorner")
    BindCorner.CornerRadius = UDim.new(0, 4)
    BindCorner.Parent = BindBtn

    BindBtn.MouseButton1Click:Connect(function()
        local conn
        conn = UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                if input.KeyCode == Enum.KeyCode.Escape then
                    QuickBinds[keyName] = Enum.KeyCode.Unknown
                    BindBtn.Text = "None"
                else
                    QuickBinds[keyName] = input.KeyCode
                    BindBtn.Text = input.KeyCode.Name
                end
                BindBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                conn:Disconnect()
            end
        end)
    end)
end

CreateKeybindPicker(QuickMenuSubContainer, "Noclip", "Noclip")
CreateKeybindPicker(QuickMenuSubContainer, "Inf Jump", "InfJump")
CreateKeybindPicker(QuickMenuSubContainer, "Anti-Fling", "AntiFling")
CreateKeybindPicker(QuickMenuSubContainer, "Fly", "Fly")
CreateKeybindPicker(QuickMenuSubContainer, "Bhop", "Bhop")
CreateKeybindPicker(QuickMenuSubContainer, "Spin", "Spin")
CreateKeybindPicker(QuickMenuSubContainer, "Silent Aim", "SilentAim")

local CornerRow = Instance.new("Frame")
CornerRow.Size = UDim2.new(1, -10, 0, 28)
CornerRow.BackgroundTransparency = 1
CornerRow.Parent = QuickMenuSubContainer

local CornerLabel = Instance.new("TextLabel")
CornerLabel.Size = UDim2.new(0.5, 0, 1, 0)
CornerLabel.BackgroundTransparency = 1
CornerLabel.Text = "Menu Corner"
CornerLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
CornerLabel.TextSize = 12
CornerLabel.Font = Enum.Font.SourceSans
CornerLabel.TextXAlignment = Enum.TextXAlignment.Left
CornerLabel.Parent = CornerRow

local CornerBtn = Instance.new("TextButton")
CornerBtn.Size = UDim2.new(0, 90, 0, 20)
CornerBtn.Position = UDim2.new(1, -90, 0.5, -10)
CornerBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
CornerBtn.Text = MovementSettings.QuickMenuCorner
CornerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CornerBtn.TextSize = 11
CornerBtn.Font = Enum.Font.SourceSansBold
CornerBtn.Parent = CornerRow

local CornerBtnCorner = Instance.new("UICorner")
CornerBtnCorner.CornerRadius = UDim.new(0, 4)
CornerBtnCorner.Parent = CornerBtn

local cornersList = {"Bottom-Right", "Bottom-Left", "Top-Right", "Top-Left"}
CornerBtn.MouseButton1Click:Connect(function()
    pcall(function()
        local idx = 1
        for i, c in ipairs(cornersList) do
            if c == MovementSettings.QuickMenuCorner then idx = i break end
        end
        idx = (idx % #cornersList) + 1
        MovementSettings.QuickMenuCorner = cornersList[idx]
        CornerBtn.Text = cornersList[idx]
    end)
end)

-- Быстрое меню
local QuickGuiFrame = Instance.new("Frame")
QuickGuiFrame.Name = "QuickGuiFrame"
QuickGuiFrame.Size = UDim2.new(0, 140, 0, 180)
QuickGuiFrame.BackgroundTransparency = 1
QuickGuiFrame.Visible = false
QuickGuiFrame.Parent = ScreenGui

local QuickUIList = Instance.new("UIListLayout")
QuickUIList.SortOrder = Enum.SortOrder.LayoutOrder
QuickUIList.Padding = UDim.new(0, 4)
QuickUIList.Parent = QuickGuiFrame

local quickFeatures = {"Noclip", "InfJump", "AntiFling", "Fly", "Bhop", "Spin"}
local quickButtons = {}

for idx, feat in ipairs(quickFeatures) do
    local QBtn = Instance.new("TextButton")
    QBtn.Name = feat .. "QBtn"
    QBtn.Size = UDim2.new(1, 0, 0, 25)
    QBtn.BackgroundTransparency = 1
    QBtn.Text = feat .. ": OFF"
    QBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    QBtn.TextSize = 13
    QBtn.Font = Enum.Font.SourceSansBold
    QBtn.TextXAlignment = Enum.TextXAlignment.Right
    QBtn.Parent = QuickGuiFrame

    local QStroke = Instance.new("UIStroke")
    QStroke.Color = Color3.fromRGB(0, 0, 0)
    QStroke.Thickness = 1.5
    QStroke.Parent = QBtn

    quickButtons[feat] = QBtn

    QBtn.MouseButton1Click:Connect(function()
        ToggleFeatureState(feat)
    end)
end

SetupToggleVisual(QuickMenuToggleBtn, QuickMenuToggleBall, QuickMenuToggleBG, MovementSettings, "QuickMenu", function(val)
    QuickGuiFrame.Visible = val
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        for feat, key in pairs(QuickBinds) do
            if key ~= Enum.KeyCode.Unknown and input.KeyCode == key then
                ToggleFeatureState(feat)
            end
        end
    end
end)

-- Color Picker Window
local ColorPickerFrame = Instance.new("Frame")
ColorPickerFrame.Name = "ColorPickerFrame"
ColorPickerFrame.Size = UDim2.new(0, 210, 0, 190)
ColorPickerFrame.Position = UDim2.new(0.5, -105, 0.5, -95)
ColorPickerFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ColorPickerFrame.Visible = false
ColorPickerFrame.Active = true
ColorPickerFrame.ZIndex = 100
ColorPickerFrame.Parent = ScreenGui

local PickerCorner = Instance.new("UICorner")
PickerCorner.CornerRadius = UDim.new(0, 8)
PickerCorner.Parent = ColorPickerFrame

local PickerStroke = Instance.new("UIStroke")
PickerStroke.Color = Color3.fromRGB(80, 80, 80)
PickerStroke.Thickness = 1.5
PickerStroke.Parent = ColorPickerFrame

local PickerTitle = Instance.new("TextLabel")
PickerTitle.Size = UDim2.new(1, -30, 0, 25)
PickerTitle.Position = UDim2.new(0, 10, 0, 2)
PickerTitle.BackgroundTransparency = 1
PickerTitle.Text = "Color Picker"
PickerTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
PickerTitle.TextSize = 14
PickerTitle.Font = Enum.Font.SourceSansBold
PickerTitle.TextXAlignment = Enum.TextXAlignment.Left
PickerTitle.ZIndex = 101
PickerTitle.Parent = ColorPickerFrame

local ClosePickerBtn = Instance.new("TextButton")
ClosePickerBtn.Size = UDim2.new(0, 20, 0, 20)
ClosePickerBtn.Position = UDim2.new(1, -22, 0, 3)
ClosePickerBtn.BackgroundTransparency = 1
ClosePickerBtn.Text = "X"
ClosePickerBtn.TextColor3 = Color3.fromRGB(200, 50, 50)
ClosePickerBtn.TextSize = 14
ClosePickerBtn.Font = Enum.Font.SourceSansBold
ClosePickerBtn.ZIndex = 101
ClosePickerBtn.Parent = ColorPickerFrame

local SVBase = Instance.new("Frame")
SVBase.Name = "SVBase"
SVBase.Size = UDim2.new(0, 110, 0, 110)
SVBase.Position = UDim2.new(0, 10, 0, 30)
SVBase.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
SVBase.ZIndex = 101
SVBase.Parent = ColorPickerFrame

local SVBaseCorner = Instance.new("UICorner")
SVBaseCorner.CornerRadius = UDim.new(0, 4)
SVBaseCorner.Parent = SVBase

local SaturationOverlay = Instance.new("Frame")
SaturationOverlay.Size = UDim2.new(1, 0, 1, 0)
SaturationOverlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SaturationOverlay.ZIndex = 102
SaturationOverlay.Parent = SVBase

local SatCorner = Instance.new("UICorner")
SatCorner.CornerRadius = UDim.new(0, 4)
SatCorner.Parent = SaturationOverlay

local SatGrad = Instance.new("UIGradient")
SatGrad.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)})
SatGrad.Parent = SaturationOverlay

local ValueOverlay = Instance.new("Frame")
ValueOverlay.Size = UDim2.new(1, 0, 1, 0)
ValueOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ValueOverlay.ZIndex = 103
ValueOverlay.Parent = SVBase

local ValCorner = Instance.new("UICorner")
ValCorner.CornerRadius = UDim.new(0, 4)
ValCorner.Parent = ValueOverlay

local ValGrad = Instance.new("UIGradient")
ValGrad.Rotation = 90
ValGrad.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)})
ValGrad.Parent = ValueOverlay

local PickerCursor = Instance.new("Frame")
PickerCursor.Size = UDim2.new(0, 8, 0, 8)
PickerCursor.AnchorPoint = Vector2.new(0.5, 0.5)
PickerCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
PickerCursor.ZIndex = 105
PickerCursor.Parent = SVBase

local CursorCorner = Instance.new("UICorner")
CursorCorner.CornerRadius = UDim.new(1, 0)
CursorCorner.Parent = PickerCursor

local CursorStroke = Instance.new("UIStroke")
CursorStroke.Color = Color3.fromRGB(0, 0, 0)
CursorStroke.Thickness = 1.5
CursorStroke.Parent = PickerCursor

local HueBar = Instance.new("Frame")
HueBar.Name = "HueBar"
HueBar.Size = UDim2.new(0, 16, 0, 110)
HueBar.Position = UDim2.new(0, 128, 0, 30)
HueBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
HueBar.ZIndex = 101
HueBar.Parent = ColorPickerFrame

local HueCorner = Instance.new("UICorner")
HueCorner.CornerRadius = UDim.new(0, 4)
HueCorner.Parent = HueBar

local HueGrad = Instance.new("UIGradient")
HueGrad.Rotation = 90
HueGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
    ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)),
    ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0))
})
HueGrad.Parent = HueBar

local HueSlider = Instance.new("Frame")
HueSlider.Size = UDim2.new(1, 4, 0, 4)
HueSlider.AnchorPoint = Vector2.new(0, 0.5)
HueSlider.Position = UDim2.new(0, -2, 0, 0)
HueSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
HueSlider.ZIndex = 104
HueSlider.Parent = HueBar

local HueSliderStroke = Instance.new("UIStroke")
HueSliderStroke.Color = Color3.fromRGB(0, 0, 0)
HueSliderStroke.Thickness = 1
HueSliderStroke.Parent = HueSlider

local PreviewBox = Instance.new("Frame")
PreviewBox.Size = UDim2.new(0, 45, 0, 25)
PreviewBox.Position = UDim2.new(0, 152, 0, 30)
PreviewBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
PreviewBox.ZIndex = 101
PreviewBox.Parent = ColorPickerFrame

local PreviewCorner = Instance.new("UICorner")
PreviewCorner.CornerRadius = UDim.new(0, 4)
PreviewCorner.Parent = PreviewBox

local HexInput = Instance.new("TextBox")
HexInput.Size = UDim2.new(0, 187, 0, 25)
HexInput.Position = UDim2.new(0, 10, 0, 150)
HexInput.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
HexInput.Text = "#FFFFFF"
HexInput.TextColor3 = Color3.fromRGB(255, 255, 255)
HexInput.TextSize = 13
HexInput.Font = Enum.Font.Code
HexInput.ZIndex = 101
HexInput.Parent = ColorPickerFrame

local HexCorner = Instance.new("UICorner")
HexCorner.CornerRadius = UDim.new(0, 4)
HexCorner.Parent = HexInput

local HexStroke = Instance.new("UIStroke")
HexStroke.Color = Color3.fromRGB(60, 60, 60)
HexStroke.Thickness = 1
HexStroke.Parent = HexInput

local currentTargetType = nil
local currentRoleTarget = nil
local currentButtonTarget = nil
local currH, currS, currV = 0, 1, 1

local function UpdateColorFromHSV()
    SVBase.BackgroundColor3 = Color3.fromHSV(currH, 1, 1)
    local finalColor = Color3.fromHSV(currH, currS, currV)
    PreviewBox.BackgroundColor3 = finalColor
    HexInput.Text = ColorToHex(finalColor)
    
    if currentTargetType == "Role" and currentRoleTarget then
        RoleColors[currentRoleTarget] = finalColor
    elseif currentTargetType == "GradTop" then
        GradientColors.Top = finalColor
    elseif currentTargetType == "GradBottom" then
        GradientColors.Bottom = finalColor
    elseif currentTargetType == "FillTop" then
        FillColors.Top = finalColor
    elseif currentTargetType == "FillBottom" then
        FillColors.Bottom = finalColor
    elseif currentTargetType == "XrayColor" then
        XraySettings.Color = finalColor
        if XraySettings.Enabled then ApplyXray() end
    elseif currentTargetType == "EspGunColor" then
        GunEspSettings.Color = finalColor
    end

    if currentButtonTarget then
        currentButtonTarget.BackgroundColor3 = finalColor
    end
end

local draggingHue, draggingSV = false, false

HueBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingHue = true
        local y = math.clamp(input.Position.Y - HueBar.AbsolutePosition.Y, 0, HueBar.AbsoluteSize.Y)
        currH = y / HueBar.AbsoluteSize.Y
        HueSlider.Position = UDim2.new(0, -2, 0, y)
        UpdateColorFromHSV()
    end
end)

SVBase.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingSV = true
        local x = math.clamp(input.Position.X - SVBase.AbsolutePosition.X, 0, SVBase.AbsoluteSize.X)
        local y = math.clamp(input.Position.Y - SVBase.AbsolutePosition.Y, 0, SVBase.AbsoluteSize.Y)
        currS = x / SVBase.AbsoluteSize.X
        currV = 1 - (y / SVBase.AbsoluteSize.Y)
        PickerCursor.Position = UDim2.new(0, x, 0, y)
        UpdateColorFromHSV()
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingHue = false
        draggingSV = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if draggingHue then
            local y = math.clamp(input.Position.Y - HueBar.AbsolutePosition.Y, 0, HueBar.AbsoluteSize.Y)
            currH = y / HueBar.AbsoluteSize.Y
            HueSlider.Position = UDim2.new(0, -2, 0, y)
            UpdateColorFromHSV()
        elseif draggingSV then
            local x = math.clamp(input.Position.X - SVBase.AbsolutePosition.X, 0, SVBase.AbsoluteSize.X)
            local y = math.clamp(input.Position.Y - SVBase.AbsolutePosition.Y, 0, SVBase.AbsoluteSize.Y)
            currS = x / SVBase.AbsoluteSize.X
            currV = 1 - (y / SVBase.AbsoluteSize.Y)
            PickerCursor.Position = UDim2.new(0, x, 0, y)
            UpdateColorFromHSV()
        end
    end
end)

HexInput.FocusLost:Connect(function()
    pcall(function()
        local color = HexToColor(HexInput.Text)
        if color then
            currH, currS, currV = Color3.toHSV(color)
            SVBase.BackgroundColor3 = Color3.fromHSV(currH, 1, 1)
            PreviewBox.BackgroundColor3 = color
            PickerCursor.Position = UDim2.new(currS, 0, 1 - currV, 0)
            HueSlider.Position = UDim2.new(0, -2, currH, 0)
            
            if currentTargetType == "Role" and currentRoleTarget then
                RoleColors[currentRoleTarget] = color
            elseif currentTargetType == "GradTop" then
                GradientColors.Top = color
            elseif currentTargetType == "GradBottom" then
                GradientColors.Bottom = color
            elseif currentTargetType == "FillTop" then
                FillColors.Top = color
            elseif currentTargetType == "FillBottom" then
                FillColors.Bottom = color
            elseif currentTargetType == "XrayColor" then
                XraySettings.Color = color
                if XraySettings.Enabled then ApplyXray() end
            elseif currentTargetType == "EspGunColor" then
                GunEspSettings.Color = color
            end

            if currentButtonTarget then
                currentButtonTarget.BackgroundColor3 = color
            end
        else
            HexInput.Text = ColorToHex(PreviewBox.BackgroundColor3)
        end
    end)
end)

ClosePickerBtn.MouseButton1Click:Connect(function()
    ColorPickerFrame.Visible = false
end)

local function CreateGenericColorPicker(parentContainer, labelName, targetType, initialColor, roleTarget)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, -10, 0, 30)
    Row.BackgroundTransparency = 1
    Row.Parent = parentContainer

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.6, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = labelName
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.TextSize = 13
    Label.Font = Enum.Font.SourceSans
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Row

    local ColorSquareBtn = Instance.new("TextButton")
    ColorSquareBtn.Size = UDim2.new(0, 20, 0, 20)
    ColorSquareBtn.Position = UDim2.new(1, -22, 0.5, -10)
    ColorSquareBtn.BackgroundColor3 = initialColor or Color3.fromRGB(255, 255, 255)
    ColorSquareBtn.Text = ""
    ColorSquareBtn.Parent = Row

    local SquareCorner = Instance.new("UICorner")
    SquareCorner.CornerRadius = UDim.new(0, 4)
    SquareCorner.Parent = ColorSquareBtn

    local SquareStroke = Instance.new("UIStroke")
    SquareStroke.Color = Color3.fromRGB(100, 100, 100)
    SquareStroke.Thickness = 1
    SquareStroke.Parent = ColorSquareBtn

    ColorSquareBtn.MouseButton1Click:Connect(function()
        pcall(function()
            currentTargetType = targetType
            currentRoleTarget = roleTarget
            currentButtonTarget = ColorSquareBtn
            
            local currentColor = ColorSquareBtn.BackgroundColor3
            currH, currS, currV = Color3.toHSV(currentColor)
            SVBase.BackgroundColor3 = Color3.fromHSV(currH, 1, 1)
            PreviewBox.BackgroundColor3 = currentColor
            HexInput.Text = ColorToHex(currentColor)
            PickerCursor.Position = UDim2.new(currS, 0, 1 - currV, 0)
            HueSlider.Position = UDim2.new(0, -2, currH, 0)
            PickerTitle.Text = labelName
            ColorPickerFrame.Visible = true
        end)
    end)
end

CreateGenericColorPicker(XraySubContainer, "X-Ray Object Color", "XrayColor", XraySettings.Color)
CreateGenericColorPicker(EspGunSubContainer, "Gun ESP Color", "EspGunColor", GunEspSettings.Color)
CreateGenericColorPicker(BoxSubContainer, "Box Top Color", "GradTop", GradientColors.Top)
CreateGenericColorPicker(BoxSubContainer, "Box Bottom Color", "GradBottom", GradientColors.Bottom)
CreateGenericColorPicker(BoxSubContainer, "Fill Top Color", "FillTop", FillColors.Top)
CreateGenericColorPicker(BoxSubContainer, "Fill Bottom Color", "FillBottom", FillColors.Bottom)

local function CreateRoleColorPicker(roleName)
    CreateGenericColorPicker(EspSubContainer, roleName .. " Color", "Role", RoleColors[roleName], roleName)
end

CreateRoleColorPicker("Murderer")
CreateRoleColorPicker("Sheriff")
CreateRoleColorPicker("Hero")
CreateRoleColorPicker("Innocent")

-- Динамическое обновление размеров и UI
RunService.Heartbeat:Connect(function()
    pcall(function()
        XraySubContainer.Size = UDim2.new(1, 0, 0, XraySubList.AbsoluteContentSize.Y + 12)
        EspGunSubContainer.Size = UDim2.new(1, 0, 0, EspGunSubList.AbsoluteContentSize.Y + 12)
        EspSubContainer.Size = UDim2.new(1, 0, 0, EspSubList.AbsoluteContentSize.Y + 12)
        BoxSubContainer.Size = UDim2.new(1, 0, 0, BoxSubList.AbsoluteContentSize.Y + 12)
        FlySubContainer.Size = UDim2.new(1, 0, 0, FlySubList.AbsoluteContentSize.Y + 12)
        BhopSubContainer.Size = UDim2.new(1, 0, 0, BhopSubList.AbsoluteContentSize.Y + 12)
        SpinSubContainer.Size = UDim2.new(1, 0, 0, SpinSubList.AbsoluteContentSize.Y + 12)
        QuickMenuSubContainer.Size = UDim2.new(1, 0, 0, QuickMenuSubList.AbsoluteContentSize.Y + 12)
        SilentAimSubContainer.Size = UDim2.new(1, 0, 0, SilentAimSubList.AbsoluteContentSize.Y + 12)
        ForceShootSubContainer.Size = UDim2.new(1, 0, 0, ForceShootSubList.AbsoluteContentSize.Y + 12)
        GetGunSubContainer.Size = UDim2.new(1, 0, 0, GetGunSubList.AbsoluteContentSize.Y + 12)

        LeftColumn.CanvasSize = UDim2.new(0, 0, 0, LeftList.AbsoluteContentSize.Y + 20)
        RightColumn.CanvasSize = UDim2.new(0, 0, 0, RightList.AbsoluteContentSize.Y + 20)
        CombatLeftColumn.CanvasSize = UDim2.new(0, 0, 0, CombatLeftList.AbsoluteContentSize.Y + 20)

        local yOffset = MovementSettings.QuickMenuOffsetY
        if MovementSettings.QuickMenuCorner == "Bottom-Right" then
            QuickGuiFrame.Position = UDim2.new(1, -150, 1, -yOffset)
            QuickUIList.HorizontalAlignment = Enum.HorizontalAlignment.Right
        elseif MovementSettings.QuickMenuCorner == "Bottom-Left" then
            QuickGuiFrame.Position = UDim2.new(0, 10, 1, -yOffset)
            QuickUIList.HorizontalAlignment = Enum.HorizontalAlignment.Left
        elseif MovementSettings.QuickMenuCorner == "Top-Right" then
            QuickGuiFrame.Position = UDim2.new(1, -150, 0, 50)
            QuickUIList.HorizontalAlignment = Enum.HorizontalAlignment.Right
        elseif MovementSettings.QuickMenuCorner == "Top-Left" then
            QuickGuiFrame.Position = UDim2.new(0, 10, 0, 50)
            QuickUIList.HorizontalAlignment = Enum.HorizontalAlignment.Left
        end

        for feat, qbtn in pairs(quickButtons) do
            local active = MovementSettings[feat] or CombatSettings[feat]
            qbtn.Text = feat .. ": " .. (active and "ON" or "OFF")
            qbtn.TextColor3 = active and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(200, 200, 200)
        end
    end)
end)

local function getRoles()
    local roles = {}
    pcall(function()
        local getPlayerData = ReplicatedStorage:FindFirstChild("GetPlayerData", true)
        if getPlayerData then
            local data = getPlayerData:InvokeServer()
            if type(data) == "table" then
                for plr, plrData in pairs(data) do
                    if not plrData.Dead then
                        roles[plr] = plrData.Role
                    end
                end
            end
        end
    end)
    return roles
end

-- LOGIC: Get Gun Auto (Touch / Teleport / PlayerTP)
local isTeleportingPlayer = false
RunService.Heartbeat:Connect(function()
    if CombatSettings.GetGun and LocalPlayer.Character and not isTeleportingPlayer then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local gun = workspace:FindFirstChild("GunDrop", true)
        if hrp and gun then
            if CombatSettings.GetGunMode == "Touch" then
                pcall(function()
                    if firetouchinterest then
                        firetouchinterest(hrp, gun, 0)
                        firetouchinterest(hrp, gun, 1)
                    else
                        gun.CFrame = hrp.CFrame
                    end
                end)
            elseif CombatSettings.GetGunMode == "Teleport" then
                pcall(function()
                    gun.CFrame = hrp.CFrame
                end)
            elseif CombatSettings.GetGunMode == "PlayerTP" then
                -- Телепортируем игрока к песту на миллисекунду, ТОЛЬКО если игрок НЕ Murderer
                local roles = getRoles()
                local myRole = roles[LocalPlayer.Name] or "Innocent"

                if myRole ~= "Murderer" then
                    isTeleportingPlayer = true
                    task.spawn(function()
                        pcall(function()
                            local oldCF = hrp.CFrame
                            hrp.CFrame = gun.CFrame
                            task.wait(0.08) -- Пауза для корректного подбора
                            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                LocalPlayer.Character.HumanoidRootPart.CFrame = oldCF
                            end
                        end)
                        task.wait(0.2)
                        isTeleportingPlayer = false
                    end)
                end
            end
        end
    end
end)

-- NOCLIP
RunService.Stepped:Connect(function()
    if MovementSettings.Noclip and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- BHOP & INF JUMP
local lastJumpTime = 0
local currentBhopSpeed = 16

UserInputService.JumpRequest:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildWhichIsA("Humanoid")
    if not hum then return end

    if MovementSettings.InfJump then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end

    if MovementSettings.Bhop then
        local now = tick()
        if now - lastJumpTime < 0.6 then
            currentBhopSpeed = math.min(currentBhopSpeed + 6, MovementSettings.BhopMaxSpeed)
        else
            currentBhopSpeed = 22
        end
        lastJumpTime = now
        hum.WalkSpeed = currentBhopSpeed
    end
end)

RunService.Heartbeat:Connect(function()
    if MovementSettings.Bhop and tick() - lastJumpTime > 0.6 then
        currentBhopSpeed = 16
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildWhichIsA("Humanoid")
            if hum and hum.WalkSpeed > 16 then
                hum.WalkSpeed = 16
            end
        end
    end
end)

-- Поиск Мардера для Silent Aim
local function getMurdererTorso()
    local roles = getRoles()
    for plrName, role in pairs(roles) do
        if role == "Murderer" then
            local plr = Players:FindFirstChild(plrName)
            if plr and plr.Character then
                local torso = plr.Character:FindFirstChild("Torso") or plr.Character:FindFirstChild("UpperTorso")
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                if torso and hrp then
                    return torso, hrp
                end
            end
        end
    end
    return nil, nil
end

-- HOOKMETAMETHOD ДЛЯ SILENT AIM И WALLSHOT (FORCE SHOOT)
local isCustomFiring = false
local rawNamecall

pcall(function()
    rawNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}

        if not checkcaller() and (method == "FireServer" or method == "fireServer") and CombatSettings.SilentAim and not isCustomFiring then
            if self.Name == "Shoot" then
                local torso, hrp = getMurdererTorso()
                if torso and hrp then
                    isCustomFiring = true

                    local originalOrigin = args[1]
                    local targetPos = torso.Position
                    
                    local velocity = hrp.AssemblyLinearVelocity or hrp.Velocity or Vector3.zero
                    if velocity.Magnitude > 0.5 and CombatSettings.PredictionStrength > 0 then
                        local factor = (CombatSettings.PredictionStrength / 100) * 0.2
                        targetPos = targetPos + (velocity * factor)
                    end

                    local finalOriginCFrame = originalOrigin
                    local targetCFrame = CFrame.new(targetPos)

                    -- Логика Wallshot из Saturn
                    if CombatSettings.ForceShoot then
                        local myPos = (originalOrigin and originalOrigin.Position) or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position) or Vector3.zero
                        local fireDir = (targetPos - myPos).Unit
                        if fireDir.Magnitude == 0 then fireDir = Vector3.new(0, 0, -1) end
                        
                        local wallshotOriginPos = targetPos - (fireDir * 2)
                        finalOriginCFrame = CFrame.new(wallshotOriginPos, targetPos)
                    end

                    self:FireServer(finalOriginCFrame, targetCFrame)
                    isCustomFiring = false
                    return nil
                end
            end
        end

        return rawNamecall(self, ...)
    end))
end)

local espCache = {}

local function createEspDrawings()
    local drawings = {
        Line = Drawing.new("Line"),
        Name = Drawing.new("Text"),
        Meters = Drawing.new("Text"),
        
        BoxTop = Drawing.new("Line"),
        BoxBottom = Drawing.new("Line"),
        BoxLeft = Drawing.new("Line"),
        BoxRight = Drawing.new("Line"),
        
        TL1 = Drawing.new("Square"), TL2 = Drawing.new("Square"),
        TR1 = Drawing.new("Square"), TR2 = Drawing.new("Square"),
        BL1 = Drawing.new("Square"), BL2 = Drawing.new("Square"),
        BR1 = Drawing.new("Square"), BR2 = Drawing.new("Square"),
        
        Fills = {}
    }

    local corners = {"TL1", "TL2", "TR1", "TR2", "BL1", "BL2", "BR1", "BR2"}
    for _, c in ipairs(corners) do
        drawings[c].Filled = true
        drawings[c].Thickness = 0
    end

    for i = 1, 12 do
        local fill = Drawing.new("Square")
        fill.Filled = true
        fill.Thickness = 0
        drawings.Fills[i] = fill
    end

    return drawings
end

local function removeEspDrawings(drawings)
    pcall(function()
        drawings.Line.Visible = false; drawings.Line:Remove()
        drawings.Name.Visible = false; drawings.Name:Remove()
        drawings.Meters.Visible = false; drawings.Meters:Remove()
        
        drawings.BoxTop.Visible = false; drawings.BoxTop:Remove()
        drawings.BoxBottom.Visible = false; drawings.BoxBottom:Remove()
        drawings.BoxLeft.Visible = false; drawings.BoxLeft:Remove()
        drawings.BoxRight.Visible = false; drawings.BoxRight:Remove()
        
        drawings.TL1.Visible = false; drawings.TL1:Remove()
        drawings.TL2.Visible = false; drawings.TL2:Remove()
        drawings.TR1.Visible = false; drawings.TR1:Remove()
        drawings.TR2.Visible = false; drawings.TR2:Remove()
        drawings.BL1.Visible = false; drawings.BL2.Visible = false
        drawings.BR1.Visible = false; drawings.BR2.Visible = false

        for _, fill in ipairs(drawings.Fills) do
            fill.Visible = false
            fill:Remove()
        end
    end)
end

local spinAngle = 0
RunService.Stepped:Connect(function(_, deltaTime)
    if MovementSettings.Spin and LocalPlayer.Character then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            spinAngle = (spinAngle + (MovementSettings.SpinSpeed * deltaTime * 10)) % 360
            local pos = hrp.Position
            hrp.CFrame = CFrame.new(pos) * CFrame.Angles(0, math.rad(spinAngle), 0)
        end
    end
end)

RunService:BindToRenderStep("DadaESP_Update", Enum.RenderPriority.Camera.Value + 1, function()
    local char = LocalPlayer.Character

    if MovementSettings.AntiFling then
        for _, otherPlr in ipairs(Players:GetPlayers()) do
            if otherPlr ~= LocalPlayer and otherPlr.Character then
                for _, part in ipairs(otherPlr.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                        part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
                    end
                end
            end
        end
    end

    if MovementSettings.Fly and char and flyBodyVel and flyBodyGyro then
        local hum = char:FindFirstChildWhichIsA("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hum and hrp then
            local camCF = Camera.CFrame
            local flyVec = Vector3.zero

            local moveX = 0
            local moveZ = 0

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveZ = moveZ + 1 end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveZ = moveZ - 1 end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveX = moveX + 1 end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveX = moveX - 1 end

            local mobDir = hum.MoveDirection
            if mobDir.Magnitude > 0 and moveX == 0 and moveZ == 0 then
                local forwardDot = mobDir:Dot(camCF.LookVector)
                local rightDot = mobDir:Dot(camCF.RightVector)
                flyVec = (camCF.LookVector * forwardDot + camCF.RightVector * rightDot) * MovementSettings.FlySpeed
            else
                local forwardVec = camCF.LookVector * moveZ
                local rightVec = camCF.RightVector * moveX
                local combined = forwardVec + rightVec
                if combined.Magnitude > 0 then
                    flyVec = combined.Unit * MovementSettings.FlySpeed
                end
            end

            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                flyVec = flyVec + Vector3.new(0, MovementSettings.FlySpeed, 0)
            elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                flyVec = flyVec - Vector3.new(0, MovementSettings.FlySpeed, 0)
            end

            flyBodyVel.Velocity = flyVec
            flyBodyGyro.CFrame = camCF
        end
    end

    local gun = workspace:FindFirstChild("GunDrop", true)
    if gun and GunEspSettings.Enabled then
        local highlight = gun:FindFirstChild("GunHighlight")
        if not highlight then
            highlight = Instance.new("Highlight")
            highlight.Name = "GunHighlight"
            highlight.Parent = gun
        end
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.FillColor = GunEspSettings.Color
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = GunEspSettings.Fill and 0.4 or 1
        highlight.OutlineTransparency = 0
        highlight.Enabled = true

        local esp = gun:FindFirstChild("GunEsp")
        if not esp then
            esp = Instance.new("BillboardGui")
            esp.Name = "GunEsp"
            esp.Adornee = gun
            esp.Size = UDim2.new(5, 0, 5, 0)
            esp.AlwaysOnTop = true
            esp.Parent = gun
            
            local text = Instance.new("TextLabel", esp)
            text.Name = "GunLabel"
            text.Size = UDim2.new(1, 0, 1, 0)
            text.BackgroundTransparency = 1
            text.TextStrokeTransparency = 0
            text.Font = Enum.Font.FredokaOne
            text.TextSize = 16
            text.Text = "Gun Drop"
        end
        local label = esp:FindFirstChild("GunLabel")
        if label then
            label.TextColor3 = GunEspSettings.Color
        end
    else
        if gun then
            if gun:FindFirstChild("GunHighlight") then gun.GunHighlight:Destroy() end
            if gun:FindFirstChild("GunEsp") then gun.GunEsp:Destroy() end
        end
    end

    if not EspSettings.Enabled and not BoxSettings.Enabled then
        for plr, drawings in pairs(espCache) do
            removeEspDrawings(drawings)
            espCache[plr] = nil
        end
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Character then
                local hl = plr.Character:FindFirstChild("DadaHighlight")
                if hl then hl:Destroy() end
            end
        end
        return
    end

    local rolesData = getRoles()

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local pChar = plr.Character
            local hrp = pChar.HumanoidRootPart
            local hrpPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)

            local role = rolesData[plr.Name] or "Default"
            local roleColor = RoleColors[role] or RoleColors.Default

            if not espCache[plr] then
                espCache[plr] = createEspDrawings()
            end

            local draw = espCache[plr]

            local highlight = pChar:FindFirstChild("DadaHighlight")
            if EspSettings.Enabled and (EspSettings.Chams or EspSettings.Outline) then
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "DadaHighlight"
                    highlight.Parent = pChar
                end

                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                highlight.FillTransparency = EspSettings.Chams and 0.5 or 1
                highlight.OutlineTransparency = EspSettings.Outline and 0 or 1
                highlight.FillColor = roleColor
                highlight.OutlineColor = roleColor
                highlight.Enabled = true
            elseif highlight then
                highlight.Enabled = false
            end

            if onScreen and hrpPos.Z > 0 and hrpPos.Z < 1000 then
                local cframe = hrp.CFrame
                local size = Vector3.new(4, 5.5, 2)
                local halfSize = size / 2

                local cornerOffsets = {
                    Vector3.new(-halfSize.X,  halfSize.Y, -halfSize.Z),
                    Vector3.new( halfSize.X,  halfSize.Y, -halfSize.Z),
                    Vector3.new(-halfSize.X, -halfSize.Y, -halfSize.Z),
                    Vector3.new( halfSize.X, -halfSize.Y, -halfSize.Z),
                    Vector3.new(-halfSize.X,  halfSize.Y,  halfSize.Z),
                    Vector3.new( halfSize.X,  halfSize.Y,  halfSize.Z),
                    Vector3.new(-halfSize.X, -halfSize.Y,  halfSize.Z),
                    Vector3.new( halfSize.X, -halfSize.Y,  halfSize.Z)
                }

                local minX, minY = math.huge, math.huge
                local maxX, maxY = -math.huge, -math.huge
                local allValid = true

                for _, offset in ipairs(cornerOffsets) do
                    local vPos, visible = Camera:WorldToViewportPoint((cframe * CFrame.new(offset)).Position)
                    if vPos.Z <= 0 then
                        allValid = false
                        break
                    end
                    if vPos.X < minX then minX = vPos.X end
                    if vPos.X > maxX then maxX = vPos.X end
                    if vPos.Y < minY then minY = vPos.Y end
                    if vPos.Y > maxY then maxY = vPos.Y end
                end

                local calcWidth = maxX - minX
                local calcHeight = maxY - minY

                if not allValid or minX >= maxX or minY >= maxY or calcWidth > Camera.ViewportSize.X or calcHeight > Camera.ViewportSize.Y or calcWidth < 2 or calcHeight < 2 then
                    draw.BoxTop.Visible = false; draw.BoxBottom.Visible = false
                    draw.BoxLeft.Visible = false; draw.BoxRight.Visible = false
                    draw.TL1.Visible = false; draw.TL2.Visible = false
                    draw.TR1.Visible = false; draw.TR2.Visible = false
                    draw.BL1.Visible = false; draw.BL2.Visible = false
                    draw.BR1.Visible = false; draw.BR2.Visible = false
                    for i = 1, 12 do draw.Fills[i].Visible = false end
                    draw.Line.Visible = false
                    draw.Name.Visible = false
                    draw.Meters.Visible = false
                else
                    local boxX = minX
                    local boxY = minY
                    local boxWidth = calcWidth
                    local boxHeight = calcHeight

                    if BoxSettings.Enabled then
                        if BoxSettings.BoxFill then
                            local sliceH = (boxHeight / 12)
                            for i = 1, 12 do
                                local fill = draw.Fills[i]
                                fill.Size = Vector2.new(boxWidth, sliceH + 0.6)
                                fill.Position = Vector2.new(boxX, boxY + (i - 1) * sliceH)
                                fill.Color = FillColors.Top:Lerp(FillColors.Bottom, (i - 0.5) / 12)
                                fill.Transparency = 0.35
                                fill.Visible = true
                            end
                        else
                            for i = 1, 12 do draw.Fills[i].Visible = false end
                        end

                        local cTop = GradientColors.Top
                        local cBottom = GradientColors.Bottom

                        if BoxSettings.BoxType == "Box" then
                            draw.TL1.Visible = false; draw.TL2.Visible = false
                            draw.TR1.Visible = false; draw.TR2.Visible = false
                            draw.BL1.Visible = false; draw.BL2.Visible = false
                            draw.BR1.Visible = false; draw.BR2.Visible = false

                            draw.BoxTop.From = Vector2.new(boxX, boxY)
                            draw.BoxTop.To = Vector2.new(boxX + boxWidth, boxY)
                            draw.BoxTop.Color = cTop
                            draw.BoxTop.Thickness = 1.5
                            draw.BoxTop.Visible = true

                            draw.BoxBottom.From = Vector2.new(boxX, boxY + boxHeight)
                            draw.BoxBottom.To = Vector2.new(boxX + boxWidth, boxY + boxHeight)
                            draw.BoxBottom.Color = cBottom
                            draw.BoxBottom.Thickness = 1.5
                            draw.BoxBottom.Visible = true

                            draw.BoxLeft.From = Vector2.new(boxX, boxY)
                            draw.BoxLeft.To = Vector2.new(boxX, boxY + boxHeight)
                            draw.BoxLeft.Color = cTop
                            draw.BoxLeft.Thickness = 1.5
                            draw.BoxLeft.Visible = true

                            draw.BoxRight.From = Vector2.new(boxX + boxWidth, boxY)
                            draw.BoxRight.To = Vector2.new(boxX + boxWidth, boxY + boxHeight)
                            draw.BoxRight.Color = cTop
                            draw.BoxRight.Thickness = 1.5
                            draw.BoxRight.Visible = true
                        elseif BoxSettings.BoxType == "Corners" then
                            draw.BoxTop.Visible = false; draw.BoxBottom.Visible = false
                            draw.BoxLeft.Visible = false; draw.BoxRight.Visible = false

                            local cornerLen = math.clamp(boxWidth * 0.25, 6, 22)
                            local t = 3.0

                            draw.TL1.Position = Vector2.new(boxX, boxY); draw.TL1.Size = Vector2.new(cornerLen, t); draw.TL1.Color = cTop; draw.TL1.Visible = true
                            draw.TL2.Position = Vector2.new(boxX, boxY); draw.TL2.Size = Vector2.new(t, cornerLen); draw.TL2.Color = cTop; draw.TL2.Visible = true

                            draw.TR1.Position = Vector2.new(boxX + boxWidth - cornerLen, boxY); draw.TR1.Size = Vector2.new(cornerLen, t); draw.TR1.Color = cTop; draw.TR1.Visible = true
                            draw.TR2.Position = Vector2.new(boxX + boxWidth - t, boxY); draw.TR2.Size = Vector2.new(t, cornerLen); draw.TR2.Color = cTop; draw.TR2.Visible = true

                            draw.BL1.Position = Vector2.new(boxX, boxY + boxHeight - t); draw.BL1.Size = Vector2.new(cornerLen, t); draw.BL1.Color = cBottom; draw.BL1.Visible = true
                            draw.BL2.Position = Vector2.new(boxX, boxY + boxHeight - cornerLen); draw.BL2.Size = Vector2.new(t, cornerLen); draw.BL2.Color = cBottom; draw.BL2.Visible = true

                            draw.BR1.Position = Vector2.new(boxX + boxWidth - cornerLen, boxY + boxHeight - t); draw.BR1.Size = Vector2.new(cornerLen, t); draw.BR1.Color = cBottom; draw.BR1.Visible = true
                            draw.BR2.Position = Vector2.new(boxX + boxWidth - t, boxY + boxHeight - cornerLen); draw.BR2.Size = Vector2.new(t, cornerLen); draw.BR2.Color = cBottom; draw.BR2.Visible = true
                        end
                    else
                        draw.BoxTop.Visible = false; draw.BoxBottom.Visible = false
                        draw.BoxLeft.Visible = false; draw.BoxRight.Visible = false
                        draw.TL1.Visible = false; draw.TL2.Visible = false
                        draw.TR1.Visible = false; draw.TR2.Visible = false
                        draw.BL1.Visible = false; draw.BL2.Visible = false
                        draw.BR1.Visible = false; draw.BR2.Visible = false
                        for i = 1, 12 do draw.Fills[i].Visible = false end
                    end

                    if EspSettings.Enabled and EspSettings.Line then
                        draw.Line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                        draw.Line.To = Vector2.new(hrpPos.X, hrpPos.Y)
                        draw.Line.Color = roleColor
                        draw.Line.Thickness = 1.5
                        draw.Line.Visible = true
                    else
                        draw.Line.Visible = false
                    end

                    if EspSettings.Enabled and EspSettings.Name then
                        draw.Name.Text = ("[%s] %s"):format(role, plr.Name)
                        draw.Name.Position = Vector2.new(hrpPos.X, boxY - 18)
                        draw.Name.Color = roleColor
                        draw.Name.Center = true
                        draw.Name.Outline = true
                        draw.Name.Size = 14
                        draw.Name.Visible = true
                    else
                        draw.Name.Visible = false
                    end

                    if EspSettings.Enabled and EspSettings.Meters then
                        local dist = math.floor((hrp.Position - Camera.CFrame.Position).Magnitude)
                        draw.Meters.Text = tostring(dist) .. "m"
                        draw.Meters.Position = Vector2.new(hrpPos.X, boxY + boxHeight + 2)
                        draw.Meters.Color = Color3.fromRGB(255, 255, 255)
                        draw.Meters.Center = true
                        draw.Meters.Outline = true
                        draw.Meters.Size = 12
                        draw.Meters.Visible = true
                    else
                        draw.Meters.Visible = false
                    end
                end
            else
                draw.BoxTop.Visible = false; draw.BoxBottom.Visible = false
                draw.BoxLeft.Visible = false; draw.BoxRight.Visible = false
                draw.TL1.Visible = false; draw.TL2.Visible = false
                draw.TR1.Visible = false; draw.TR2.Visible = false
                draw.BL1.Visible = false; draw.BL2.Visible = false
                draw.BR1.Visible = false; draw.BR2.Visible = false
                for i = 1, 12 do draw.Fills[i].Visible = false end
                draw.Line.Visible = false
                draw.Name.Visible = false
                draw.Meters.Visible = false
            end
        elseif espCache[plr] then
            removeEspDrawings(espCache[plr])
            espCache[plr] = nil
        end
    end
end)

Players.PlayerRemoving:Connect(function(plr)
    if espCache[plr] then
        removeEspDrawings(espCache[plr])
        espCache[plr] = nil
    end
end)

OpenButton.MouseButton1Click:Connect(function()
    pcall(function()
        MainFrame.Visible = not MainFrame.Visible
    end)
end)

CloseButton.MouseButton1Click:Connect(function()
    pcall(function()
        MainFrame.Visible = false
    end)
end)
