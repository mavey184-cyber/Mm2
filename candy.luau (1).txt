do
    local Constant = 'LPH_NO_VIRTUALIZE'

    getfenv()[Constant] = getfenv()[Constant] or function(f)
        return f
    end
end

cloneref = cloneref or function(i)
    return i
end
gethui = gethui or get_hidden_gui
getcustomasset = getcustomasset or getsynasset
getgenv = getgenv or getfenv

local LOAD_ENV = LPH_NO_VIRTUALIZE(function()
    if game:GetService('RunService'):IsStudio() then
        local BaseWorkspace = game:GetService('ReplicatedFirst'):FindFirstChild('PRI_WORKSPACE') or Instance.new('Folder', game:GetService('ReplicatedFirst'))

        BaseWorkspace.Name = 'PRI\0.' .. tostring(string.char(math.random(50, 120))) .. tostring(string.char(math.random(50, 120))) .. tostring(string.char(math.random(50, 120))) .. tostring(string.char(math.random(50, 120))) .. tostring(string.char(math.random(50, 120))) .. tostring(string.char(math.random(50, 120)))

        local __get_path_c = function(path)
            return (string.find(path, '/', 1, true) and string.split(path, '/')) or (string.find(path, '\\', 1, true) and string.split(path, '\\')) or {path}
        end
        local __get_path = function(path)
            local main = __get_path_c(path)
            local block = BaseWorkspace

            for i, v in next, main do
                block = block[v]
            end

            return block
        end

        getgenv().readfile = function(path)
            local path: StringValue = __get_path(path)

            return path.Value
        end
        getgenv().isfile = function(path)
            local success, message = pcall(function()
                return __get_path(path)
            end)

            if success and not message:IsA('Folder') then
                return true
            end

            return false
        end
        getgenv().isfolder = function(path)
            local success, message = pcall(function()
                return __get_path(path)
            end)

            if success and message:IsA('Folder') then
                return true
            end

            return false
        end
        getgenv().writefile = function(path, content)
            local main = __get_path_c(path)
            local block = BaseWorkspace

            for i, v in next, main do
                local item = block:FindFirstChild(v)

                if not item then
                    local c = Instance.new('StringValue', block)

                    c.Name = tostring(v)
                    c.Value = content
                else
                    if item:IsA('StringValue') and tostring(item) == v then
                        item.Name = tostring(v)
                        item.Value = content
                    end

                    block = item
                end
            end
        end
        getgenv().listfiles = function(path)
            local fold = __get_path(path)
            local pa = {}

            for i, v in next, fold:GetChildren()do
                if v:IsA('StringValue') then
                    table.insert(pa, path .. '/' .. tostring(v))
                end
            end

            return pa
        end
        getgenv().makefolder = function(path)
            local main = __get_path_c(path)
            local block = BaseWorkspace

            for i, v in next, main do
                local item = block:FindFirstChild(v)

                if not item then
                    local c = Instance.new('Folder', block)

                    c.Name = tostring(v)
                else
                    block = item
                end
            end
        end
        getgenv().delfile = function(path)
            local main = __get_path_c(path)
            local block = BaseWorkspace

            for i, v in next, main do
                local item = block:FindFirstChild(v)

                if item and item:IsA('StringValue') then
                    item:Destroy()
                else
                    block = item
                end
            end
        end
    end
end)

LOAD_ENV()

writefile = writefile or getgenv().writefile
makefolder = makefolder or getgenv().makefolder
readfile = readfile or getgenv().readfile
delfolder = delfolder or getgenv().delfolder
delfile = delfile or getgenv().delfile
listfiles = listfiles or getgenv().listfiles
isfolder = isfolder or getgenv().isfolder
isfile = isfile or getgenv().isfile

local NeverLose = {}

NeverLose.BuiltInRegular = Font.new('rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json', Enum.FontWeight.Regular, Enum.FontStyle.Normal)
NeverLose.BuiltInBold = Font.new('rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json', Enum.FontWeight.Bold, Enum.FontStyle.Normal)
NeverLose.GlobalSignals = {}
NeverLose.UnloadEnabled = false

local cloneref: cloneref = cloneref or function(f)
    return f
end
local TweenService: TweenService = cloneref(game:GetService('TweenService'))
local UserInputService: UserInputService = cloneref(game:GetService('UserInputService'))
local TextService: TextService = cloneref(game:GetService('TextService'))
local RunService: RunService = cloneref(game:GetService('RunService'))
local GuiService: GuiService = cloneref(game:GetService('GuiService'))
local Players: Players = cloneref(game:GetService('Players'))
local HttpService: HttpService = cloneref(game:GetService('HttpService'))
local LocalPlayer: Player = Players.LocalPlayer
local CoreGui: PlayerGui = (gethui and gethui()) or (get_hidden_gui and get_hidden_gui()) or cloneref(game:FindFirstChild('CoreGui')) or cloneref(LocalPlayer.PlayerGui)
local Mouse: Mouse = LocalPlayer:GetMouse()
local CurrentCamera: Camera = cloneref(workspace.CurrentCamera)
local ProtectGui = protect_gui or protectgui or (syn and syn.protect_gui) or function(s)
    return s
end
local GlobalWindow = Instance.new('ScreenGui')
local ManualTween = TweenInfo.new(0.1)
local SlowyTween = TweenInfo.new(0.175)
local FastTween = TweenInfo.new(0.05)
local VSlowTween = TweenInfo.new(0.5, Enum.EasingStyle.Quint)
local Encryption = {}

NeverLose.UserProfile = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)

pcall(function()
    NeverLose.UserProfile = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
end)

NeverLose.RandomString = LPH_NO_VIRTUALIZE(function()
    return string.rep(string.char(math.random(1, 7)), math.random(1, 4)) .. string.rep(string.char(math.random(1, 7)), math.random(1, 4)) .. string.rep(string.char(math.random(1, 7)), math.random(1, 4)) .. string.rep(string.char(math.random(1, 7)), math.random(1, 4)) .. string.rep(string.char(math.random(1, 7)), math.random(1, 4)) .. string.rep(string.char(math.random(1, 7)), math.random(1, 4)) .. string.rep(string.char(math.random(1, 7)), math.random(1, 4)) .. string.rep(string.char(math.random(1, 7)), math.random(1, 4)) .. string.rep(string.char(math.random(1, 7)), math.random(1, 4)) .. string.rep(string.char(math.random(1, 7)), math.random(1, 4)) .. string.rep(string.char(math.random(1, 7)), math.random(1, 4))
end)

ProtectGui(GlobalWindow)

GlobalWindow.Name = NeverLose.RandomString()
GlobalWindow.IgnoreGuiInset = true
GlobalWindow.ZIndexBehavior = Enum.ZIndexBehavior.Global
GlobalWindow.ResetOnSpawn = false
GlobalWindow.DisplayOrder = 1000
GlobalWindow.Parent = CoreGui
NeverLose.Scales = {
    Small = UDim2.fromOffset(540, 380),
    Mobile = UDim2.fromOffset(640, 385),
    Default = UDim2.fromOffset(640, 480),
    Large = UDim2.fromOffset(800, 600),
}
NeverLose.IconColor = Color3.fromRGB(255, 255, 255)
NeverLose.ScreenGui = GlobalWindow
NeverLose.Flags = {}

local AccentColorValue = Color3.fromRGB(88, 140, 255)
local AccentBindings = setmetatable({}, {
    __mode = 'k',
})

function NeverLose:BindAccent(object, property)
    if typeof(object) ~= 'Instance' then
        return object
    end

    local prop = property or 'BackgroundColor3'
    local bound = AccentBindings[object]

    if not bound then
        bound = {}
        AccentBindings[object] = bound
    end

    bound[prop] = true

    pcall(function()
        object[prop] = AccentColorValue
    end)

    return object
end
function NeverLose:PushAccent(color)
    for object, bound in next, AccentBindings do
        if typeof(object) == 'Instance' and object.Parent ~= nil then
            for prop in next, bound do
                pcall(function()
                    object[prop] = color
                end)
            end
        else
            AccentBindings[object] = nil
        end
    end
end

setmetatable(NeverLose, {
    __index = function(self, key)
        if key == 'AccentColor' then
            return AccentColorValue
        end

        return nil
    end,
    __newindex = function(self, key, value)
        if key == 'AccentColor' then
            if typeof(value) == 'Color3' then
                AccentColorValue = value

                NeverLose:PushAccent(value)
            end

            return
        end

        rawset(self, key, value)
    end,
})

NeverLose.AllToolTips = {}
NeverLose.MainColor = Color3.fromRGB(9, 10, 14)
NeverLose.RegisiteryColor = {}
NeverLose.NameRegisitry = {}
NeverLose.IsMosueOverOtherFrame = false
NeverLose.GlobalLogo = ''
NeverLose.ImageColorMapping = ''

if getcustomasset then
    local dir = 'assets'

    if not isfolder(dir) then
        makefolder(dir)
    end

    pcall(function()
        if not isfile(dir .. '/logo.png') then
            local byte = game:HttpGet('https://raw.githubusercontent.com/shitarouse/ui/refs/heads/main/logo.png')

            writefile(dir .. '/logo.png', byte)
            task.wait()
        end
        if isfile(dir .. '/logo.png') then
            NeverLose.GlobalLogo = getcustomasset(dir .. '/logo.png')
        end
    end)
    pcall(function()
        if not isfile(dir .. '/saturation_value_gradient.png') then
            local byte = game:HttpGet('https://raw.githubusercontent.com/shitarouse/ui/refs/heads/main/saturation_value_gradient.png')

            writefile(dir .. '/saturation_value_gradient.png', byte)
            task.wait()
        end
        if isfile(dir .. '/saturation_value_gradient.png') then
            NeverLose.ImageColorMapping = getcustomasset(dir .. '/saturation_value_gradient.png')
        end
    end)
end

function NeverLose:AddSignal(RBXSignal)
    if NeverLose.UnloadEnabled then
        table.insert(NeverLose.GlobalSignals, RBXSignal)
    end

    return RBXSignal
end
function NeverLose:AddQuery(ItemRoot: Frame, Name: string)
    table.insert(NeverLose.NameRegisitry, {
        Root = ItemRoot,
        Idx = Name,
    })
end
function Encryption.new(data: string)
    local len = #data
    local encrypt_seed = ((len + 3782) % 111) + 1
    local bytes = table.create(len)
    local pos = 1

    while pos <= len do
        local stop = pos + 3071

        if stop > len then
            stop = len
        end

        local chunk = {
            string.byte(data, pos, stop),
        }

        for i = 1, #chunk do
            bytes[pos + i - 1] = chunk[i] + encrypt_seed
        end

        pos = stop + 1
    end

    local concatbyte = table.concat(bytes, '?')

    table.clear(bytes)

    return '{' .. tostring(encrypt_seed + 72667) .. '}?' .. concatbyte
end
function Encryption.reverse(data: string)
    local head = string.find(data, '?', 1, true)

    if not head then
        return ''
    end

    local seed = tonumber((string.gsub(string.sub(data, 1, head - 1), '[{}]', '')))

    if not seed then
        return ''
    end

    local real_seed = seed - 72667
    local ks = {}
    local n = 0
    local pos = head + 1
    local len = #data

    while pos <= len do
        local stop = string.find(data, '?', pos, true)
        local last = (stop or (len + 1)) - 1

        if last >= pos then
            local fake_byte = tonumber(string.sub(data, pos, last))

            if fake_byte then
                n = n + 1
                ks[n] = fake_byte - real_seed
            end
        end
        if not stop then
            break
        end

        pos = stop + 1
    end

    local out = table.create(math.ceil(n / 3072))
    local oi = 0
    local i = 1

    while i <= n do
        local stop = i + 3071

        if stop > n then
            stop = n
        end

        oi = oi + 1
        out[oi] = string.char(table.unpack(ks, i, stop))
        i = stop + 1
    end

    table.clear(ks)

    return table.concat(out)
end

do
    local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    local encMap = table.create(64)
    local decMap = {}

    for i = 1, 64 do
        local ch = string.sub(b, i, i)

        encMap[i - 1] = ch
        decMap[string.byte(ch)] = i - 1
    end

    local padTail = {
        '',
        '==',
        '=',
    }
    local rsh = bit32.rshift
    local bnd = bit32.band
    local lsh = bit32.lshift

    NeverLose.Base64Encode = LPH_NO_VIRTUALIZE(function(data)
        local len = #data
        local out = table.create(math.floor(len / 3) + 2)
        local oi = 0
        local i = 1

        while i + 2 <= len do
            local b1, b2, b3 = string.byte(data, i, i + 2)
            local v = b1 * 65536 + b2 * 256 + b3

            oi = oi + 1
            out[oi] = encMap[rsh(v, 18)] .. encMap[bnd(rsh(v, 12), 63)] .. encMap[bnd(rsh(v, 6), 63)] .. encMap[bnd(v, 63)]
            i = i + 3
        end

        local rest = len - i + 1

        if rest == 1 then
            local b1 = string.byte(data, i)

            out[oi + 1] = encMap[rsh(b1, 2)] .. encMap[lsh(bnd(b1, 3), 4)]
        elseif rest == 2 then
            local b1, b2 = string.byte(data, i, i + 1)

            out[oi + 1] = encMap[rsh(b1, 2)] .. encMap[lsh(bnd(b1, 3), 4) + rsh(b2, 4)] .. encMap[lsh(bnd(b2, 15), 2)]
        end

        return table.concat(out) .. padTail[len % 3 + 1]
    end)
    NeverLose.Base64Decode = LPH_NO_VIRTUALIZE(function(data)
        local len = #data
        local bytes = table.create(math.floor(len / 4) * 3 + 3)
        local n = 0
        local acc, bits = 0, 0

        for i = 1, len do
            local v = decMap[string.byte(data, i)]

            if v then
                acc = lsh(acc, 6) + v
                bits = bits + 6

                if bits >= 8 then
                    bits = bits - 8
                    n = n + 1
                    bytes[n] = bnd(rsh(acc, bits), 255)
                    acc = bnd(acc, lsh(1, bits) - 1)
                end
            end
        end

        local out = table.create(math.ceil(n / 3072))
        local oi = 0
        local i = 1

        while i <= n do
            local stop = i + 3071

            if stop > n then
                stop = n
            end

            oi = oi + 1
            out[oi] = string.char(table.unpack(bytes, i, stop))
            i = stop + 1
        end

        table.clear(bytes)

        return table.concat(out)
    end)
end

NeverLose.LoadIcon = LPH_NO_VIRTUALIZE(function()
    NeverLose.RobloxIcon = {
        ['3d-cube-arrow-left'] = '3d-cube-arrow-left',
        amazon = 'amazon',
        ['arm-left'] = 'arm-left',
        ['arm-right'] = 'arm-right',
        ['arrow-curl-to-left'] = 'arrow-curl-to-left',
        ['arrow-curl-to-right'] = 'arrow-curl-to-right',
        ['arrow-down-to-line'] = 'arrow-down-to-line',
        ['arrow-large-down'] = 'arrow-large-down',
        ['arrow-large-left'] = 'arrow-large-left',
        ['arrow-large-right'] = 'arrow-large-right',
        ['arrow-large-up'] = 'arrow-large-up',
        ['arrow-right-from-portrait-rectangle'] = 'arrow-right-from-portrait-rectangle',
        ['arrow-right-to-portrait-rectangle'] = 'arrow-right-to-portrait-rectangle',
        ['arrow-rotate-down-dashed'] = 'arrow-rotate-down-dashed',
        ['arrow-rotate-right'] = 'arrow-rotate-right',
        ['arrow-rotate-right-dashed'] = 'arrow-rotate-right-dashed',
        ['arrow-small-down'] = 'arrow-small-down',
        ['arrow-small-left'] = 'arrow-small-left',
        ['arrow-small-right'] = 'arrow-small-right',
        ['arrow-small-up'] = 'arrow-small-up',
        ['arrow-spin-clockwise'] = 'arrow-spin-clockwise',
        ['arrow-spin-clockwise-10'] = 'arrow-spin-clockwise-10',
        ['arrow-spin-clockwise-15'] = 'arrow-spin-clockwise-15',
        ['arrow-spin-clockwise-30'] = 'arrow-spin-clockwise-30',
        ['arrow-spin-counter-clockwise-10'] = 'arrow-spin-counter-clockwise-10',
        ['arrow-spin-counter-clockwise-15'] = 'arrow-spin-counter-clockwise-15',
        ['arrow-spin-counter-clockwise-30'] = 'arrow-spin-counter-clockwise-30',
        ['arrow-thick-to-left'] = 'arrow-thick-to-left',
        ['arrow-thick-to-right'] = 'arrow-thick-to-right',
        ['arrow-up-from-landscape-rectangle'] = 'arrow-up-from-landscape-rectangle',
        ['arrow-up-right-from-square'] = 'arrow-up-right-from-square',
        ['arrow-wide-short-down'] = 'arrow-wide-short-down',
        ['arrow-wide-short-left'] = 'arrow-wide-short-left',
        ['arrow-wide-short-right'] = 'arrow-wide-short-right',
        ['arrow-wide-short-up'] = 'arrow-wide-short-up',
        ['arrows-small-directional'] = 'arrows-small-directional',
        ['audio-wave-dotted-line'] = 'audio-wave-dotted-line',
        backpack = 'backpack',
        beard = 'beard',
        bell = 'bell',
        ['bell-clock'] = 'bell-clock',
        ['bell-plus'] = 'bell-plus',
        ['bell-slash'] = 'bell-slash',
        belt = 'belt',
        binoculars = 'binoculars',
        ['book-closed'] = 'book-closed',
        bookmark = 'bookmark',
        ['bow-tie'] = 'bow-tie',
        ['building-store'] = 'building-store',
        ['bullet-flying'] = 'bullet-flying',
        ['butterfly-wings'] = 'butterfly-wings',
        calendar = 'calendar',
        ['calendar-plus'] = 'calendar-plus',
        ['calendar-star'] = 'calendar-star',
        ['camera-small'] = 'camera-small',
        ['caret-small-down'] = 'caret-small-down',
        ['caret-small-left'] = 'caret-small-left',
        ['caret-small-right'] = 'caret-small-right',
        ['caret-small-up'] = 'caret-small-up',
        ['chain-link'] = 'chain-link',
        ['chart-four-vertical-bars'] = 'chart-four-vertical-bars',
        ['chart-line'] = 'chart-line',
        ['chart-pie'] = 'chart-pie',
        ['chart-scatter-plot'] = 'chart-scatter-plot',
        ['chart-three-vertical-bars'] = 'chart-three-vertical-bars',
        check = 'check',
        ['check-large'] = 'check-large',
        ['check-small'] = 'check-small',
        ['chevron-large-down'] = 'chevron-large-down',
        ['chevron-large-down-to-line'] = 'chevron-large-down-to-line',
        ['chevron-large-left'] = 'chevron-large-left',
        ['chevron-large-left-to-line'] = 'chevron-large-left-to-line',
        ['chevron-large-right'] = 'chevron-large-right',
        ['chevron-large-right-to-line'] = 'chevron-large-right-to-line',
        ['chevron-large-up'] = 'chevron-large-up',
        ['chevron-large-up-to-line'] = 'chevron-large-up-to-line',
        ['chevron-small-down'] = 'chevron-small-down',
        ['chevron-small-down-to-line'] = 'chevron-small-down-to-line',
        ['chevron-small-left'] = 'chevron-small-left',
        ['chevron-small-left-to-line'] = 'chevron-small-left-to-line',
        ['chevron-small-right'] = 'chevron-small-right',
        ['chevron-small-right-to-line'] = 'chevron-small-right-to-line',
        ['chevron-small-up'] = 'chevron-small-up',
        ['chevron-small-up-to-line'] = 'chevron-small-up-to-line',
        ['circle-check'] = 'circle-check',
        ['circle-i'] = 'circle-i',
        ['circle-minus'] = 'circle-minus',
        ['circle-person'] = 'circle-person',
        ['circle-person-three-horizontal-bars-wrapping-right'] = 'circle-person-three-horizontal-bars-wrapping-right',
        ['circle-play'] = 'circle-play',
        ['circle-plus'] = 'circle-plus',
        ['circle-question'] = 'circle-question',
        ['circle-slash'] = 'circle-slash',
        ['circle-star'] = 'circle-star',
        ['circle-three-dots-horizontal'] = 'circle-three-dots-horizontal',
        ['circle-three-dots-vertical'] = 'circle-three-dots-vertical',
        ['circle-x'] = 'circle-x',
        clock = 'clock',
        ['clock-dashed'] = 'clock-dashed',
        ['clock-spin-reverse'] = 'clock-spin-reverse',
        ['clock-spin-reverse-dashed'] = 'clock-spin-reverse-dashed',
        ['clothes-hanger'] = 'clothes-hanger',
        cloud = 'cloud',
        ['cloud-arrow-down'] = 'cloud-arrow-down',
        code = 'code',
        ['compact-makeup-brush'] = 'compact-makeup-brush',
        compass = 'compass',
        ['controller-with-cog'] = 'controller-with-cog',
        crop = 'crop',
        crosshairs = 'crosshairs',
        ['crosshairs-slash'] = 'crosshairs-slash',
        ['cube-vertexes'] = 'cube-vertexes',
        ['curved-rectangle-megaphone'] = 'curved-rectangle-megaphone',
        ['diagonal-line-pattern'] = 'diagonal-line-pattern',
        ['diagonal-line-pattern-sticker'] = 'diagonal-line-pattern-sticker',
        ['diamond-simplified'] = 'diamond-simplified',
        discord = 'discord',
        ['disguise-nose-glasses'] = 'disguise-nose-glasses',
        ['document-circle-slash'] = 'document-circle-slash',
        ['document-list-heart'] = 'document-list-heart',
        ['door-open-arrow-to-bottom-right'] = 'door-open-arrow-to-bottom-right',
        dress = 'dress',
        ['dual-arrows-horizontal'] = 'dual-arrows-horizontal',
        ['dual-arrows-to-corners'] = 'dual-arrows-to-corners',
        ['dual-arrows-vertical'] = 'dual-arrows-vertical',
        envelope = 'envelope',
        eraser = 'eraser',
        eye = 'eye',
        ['eye-slash'] = 'eye-slash',
        ['eye-with-eyeliner'] = 'eye-with-eyeliner',
        eyebrows = 'eyebrows',
        eyelashes = 'eyelashes',
        ['face-winking'] = 'face-winking',
        facebook = 'facebook',
        ['file-box'] = 'file-box',
        fingerprint = 'fingerprint',
        flag = 'flag',
        flame = 'flame',
        folder = 'folder',
        ['fountain-pen-nib'] = 'fountain-pen-nib',
        ['four-bars-horizontal-center-aligned'] = 'four-bars-horizontal-center-aligned',
        ['four-bars-horizontal-chevron-left'] = 'four-bars-horizontal-chevron-left',
        ['four-bars-horizontal-chevron-right'] = 'four-bars-horizontal-chevron-right',
        ['four-bars-horizontal-justified-aligned'] = 'four-bars-horizontal-justified-aligned',
        ['four-bars-horizontal-left-aligned'] = 'four-bars-horizontal-left-aligned',
        ['four-bars-horizontal-right-aligned'] = 'four-bars-horizontal-right-aligned',
        ['frame-bubble-slash'] = 'frame-bubble-slash',
        ['frame-bubble-soundwave'] = 'frame-bubble-soundwave',
        ['frame-camera'] = 'frame-camera',
        ['frame-camera-center'] = 'frame-camera-center',
        ['frame-collapsed'] = 'frame-collapsed',
        ['frame-corners'] = 'frame-corners',
        ['frame-expanded'] = 'frame-expanded',
        ['frame-face'] = 'frame-face',
        ['frame-person-torso'] = 'frame-person-torso',
        ['frame-record'] = 'frame-record',
        ['frame-single-bar-horizontal'] = 'frame-single-bar-horizontal',
        ['frame-soundwave'] = 'frame-soundwave',
        ['frame-video-camera'] = 'frame-video-camera',
        gear = 'gear',
        ['generic-dpad'] = 'generic-dpad',
        ['gift-box'] = 'gift-box',
        ['gift-card'] = 'gift-card',
        glasses = 'glasses',
        ['globe-detailed'] = 'globe-detailed',
        ['globe-simplified'] = 'globe-simplified',
        ['globe-simplipfied-speech-bubble'] = 'globe-simplipfied-speech-bubble',
        grid = 'grid',
        guilded = 'guilded',
        ['hack-week'] = 'hack-week',
        ['hammer-code'] = 'hammer-code',
        ['hand-curved-arrow-left'] = 'hand-curved-arrow-left',
        ['hand-dual-arrows'] = 'hand-dual-arrows',
        ['hand-ellipse'] = 'hand-ellipse',
        ['hand-half-ellipse'] = 'hand-half-ellipse',
        ['hand-two-arrows-horizontal'] = 'hand-two-arrows-horizontal',
        hashtag = 'hashtag',
        ['hat-fedora'] = 'hat-fedora',
        ['hat-toque'] = 'hat-toque',
        ['head-blank'] = 'head-blank',
        ['head-blush'] = 'head-blush',
        ['head-female'] = 'head-female',
        ['head-freckles'] = 'head-freckles',
        ['head-lips'] = 'head-lips',
        ['head-male'] = 'head-male',
        headphones = 'headphones',
        ['headphones-arrow-up'] = 'headphones-arrow-up',
        ['headphones-arrow-up-lock'] = 'headphones-arrow-up-lock',
        ['headphones-slash'] = 'headphones-slash',
        ['headphones-x'] = 'headphones-x',
        ['headphones-x-lock'] = 'headphones-x-lock',
        heart = 'heart',
        house = 'house',
        image = 'image',
        ['image-stacked'] = 'image-stacked',
        instagram = 'instagram',
        jacket = 'jacket',
        key = 'key',
        ['key-alt'] = 'key-alt',
        ['key-apostrophe'] = 'key-apostrophe',
        ['key-arrow-down'] = 'key-arrow-down',
        ['key-arrow-right'] = 'key-arrow-right',
        ['key-arrow-up'] = 'key-arrow-up',
        ['key-asterisk'] = 'key-asterisk',
        ['key-backspace'] = 'key-backspace',
        ['key-caps-lock'] = 'key-caps-lock',
        ['key-caret'] = 'key-caret',
        ['key-comma'] = 'key-comma',
        ['key-command'] = 'key-command',
        ['key-control'] = 'key-control',
        ['key-grave-accent'] = 'key-grave-accent',
        ['key-period'] = 'key-period',
        ['key-return'] = 'key-return',
        ['key-shift'] = 'key-shift',
        ['key-space'] = 'key-space',
        ['key-tab'] = 'key-tab',
        ['language-characters'] = 'language-characters',
        ['leg-left'] = 'leg-left',
        ['leg-right'] = 'leg-right',
        ['lightning-bolt'] = 'lightning-bolt',
        linkedin = 'linkedin',
        lips = 'lips',
        lipstick = 'lipstick',
        ['list-bulleted'] = 'list-bulleted',
        ['location-pin'] = 'location-pin',
        ['location-pin-map'] = 'location-pin-map',
        ['lock-closed'] = 'lock-closed',
        lollipop = 'lollipop',
        ['magnifying-glass'] = 'magnifying-glass',
        ['magnifying-glass-minus'] = 'magnifying-glass-minus',
        ['magnifying-glass-plus'] = 'magnifying-glass-plus',
        mascara = 'mascara',
        megaphone = 'megaphone',
        ['memory-card'] = 'memory-card',
        messenger = 'messenger',
        microphone = 'microphone',
        ['microphone-slash'] = 'microphone-slash',
        ['microphone-text-box'] = 'microphone-text-box',
        ['microphone-triangle-exclamation'] = 'microphone-triangle-exclamation',
        minus = 'minus',
        ['minus-small'] = 'minus-small',
        ['mirror-standing'] = 'mirror-standing',
        moments = 'moments',
        moon = 'moon',
        ['mouse-button-left'] = 'mouse-button-left',
        ['mouse-button-right'] = 'mouse-button-right',
        ['mouse-scrollwheel'] = 'mouse-scrollwheel',
        ['music-note'] = 'music-note',
        nebula = 'nebula',
        necklace = 'necklace',
        ['nine-dots-grid'] = 'nine-dots-grid',
        ninja = 'ninja',
        nose = 'nose',
        page = 'page',
        ['paint-brush'] = 'paint-brush',
        ['paint-bucket'] = 'paint-bucket',
        pants = 'pants',
        ['pants-2d-text'] = 'pants-2d-text',
        ['paper-airplane'] = 'paper-airplane',
        parrot = 'parrot',
        ['pause-large'] = 'pause-large',
        ['pause-small'] = 'pause-small',
        pencil = 'pencil',
        ['pencil-square'] = 'pencil-square',
        person = 'person',
        ['person-arrow-from-bottom-right'] = 'person-arrow-from-bottom-right',
        ['person-check'] = 'person-check',
        ['person-circle-slash'] = 'person-circle-slash',
        ['person-climbing'] = 'person-climbing',
        ['person-clock'] = 'person-clock',
        ['person-falling'] = 'person-falling',
        ['person-graduate'] = 'person-graduate',
        ['person-jumping'] = 'person-jumping',
        ['person-magnifying-glass'] = 'person-magnifying-glass',
        ['person-photo-camera'] = 'person-photo-camera',
        ['person-play'] = 'person-play',
        ['person-play-clock'] = 'person-play-clock',
        ['person-plus'] = 'person-plus',
        ['person-racing'] = 'person-racing',
        ['person-running'] = 'person-running',
        ['person-standing'] = 'person-standing',
        ['person-standing-arrow-reverse'] = 'person-standing-arrow-reverse',
        ['person-standing-dual-arrows-vertical'] = 'person-standing-dual-arrows-vertical',
        ['person-standing-gear'] = 'person-standing-gear',
        ['person-swimming'] = 'person-swimming',
        ['person-teleport'] = 'person-teleport',
        ['person-trash-can'] = 'person-trash-can',
        ['person-walking'] = 'person-walking',
        ['person-with-smaller-person'] = 'person-with-smaller-person',
        phone = 'phone',
        ['phone-down'] = 'phone-down',
        ['phone-plus'] = 'phone-plus',
        ['phone-volume'] = 'phone-volume',
        ['phone-x'] = 'phone-x',
        ['photo-camera'] = 'photo-camera',
        ['photo-camera-face'] = 'photo-camera-face',
        ['photo-camera-slash'] = 'photo-camera-slash',
        ['picture-in-picture'] = 'picture-in-picture',
        pig = 'pig',
        pin = 'pin',
        ['pin-slash'] = 'pin-slash',
        ['play-large'] = 'play-large',
        ['play-small'] = 'play-small',
        ['plus-large'] = 'plus-large',
        ['plus-small'] = 'plus-small',
        premium = 'premium',
        ['ps-circle'] = 'ps-circle',
        ['ps-dpad-down'] = 'ps-dpad-down',
        ['ps-dpad-left'] = 'ps-dpad-left',
        ['ps-dpad-right'] = 'ps-dpad-right',
        ['ps-dpad-up'] = 'ps-dpad-up',
        ['ps-l1'] = 'ps-l1',
        ['ps-l2'] = 'ps-l2',
        ['ps-l3'] = 'ps-l3',
        ['ps-r1'] = 'ps-r1',
        ['ps-r2'] = 'ps-r2',
        ['ps-r3'] = 'ps-r3',
        ['ps-square'] = 'ps-square',
        ['ps-stick-left'] = 'ps-stick-left',
        ['ps-stick-right'] = 'ps-stick-right',
        ['ps-triagle'] = 'ps-triagle',
        ['ps-x'] = 'ps-x',
        ['ps4-options'] = 'ps4-options',
        ['ps4-share'] = 'ps4-share',
        ['ps4-touchpad'] = 'ps4-touchpad',
        ['ps5-options'] = 'ps5-options',
        ['ps5-share'] = 'ps5-share',
        ['ps5-touchpad'] = 'ps5-touchpad',
        pumpkin = 'pumpkin',
        purse = 'purse',
        ['rectangle-list'] = 'rectangle-list',
        ['rectangle-numbers-counting'] = 'rectangle-numbers-counting',
        ['rectangle-person-with-three-horizontal-lines'] = 'rectangle-person-with-three-horizontal-lines',
        robux = 'robux',
        ['rosette-seven-point'] = 'rosette-seven-point',
        ['rosette-ten-point'] = 'rosette-ten-point',
        ['seven-point-rosette'] = 'seven-point-rosette',
        ['shield-check'] = 'shield-check',
        ['shield-lock'] = 'shield-lock',
        shirt = 'shirt',
        ['shirt-2d-text'] = 'shirt-2d-text',
        ['shirt-pants'] = 'shirt-pants',
        ['shoe-left'] = 'shoe-left',
        ['shoe-right'] = 'shoe-right',
        ['shopping-basket'] = 'shopping-basket',
        ['shopping-basket-check'] = 'shopping-basket-check',
        ['shopping-cart'] = 'shopping-cart',
        shorts = 'shorts',
        sidebar = 'sidebar',
        ['signal-exclamation'] = 'signal-exclamation',
        ['six-dots-two-column-grid'] = 'six-dots-two-column-grid',
        ['skip-end-large'] = 'skip-end-large',
        ['skip-end-small'] = 'skip-end-small',
        ['skip-next-large'] = 'skip-next-large',
        ['skip-next-small'] = 'skip-next-small',
        ['skip-previous-large'] = 'skip-previous-large',
        ['skip-previous-small'] = 'skip-previous-small',
        ['skip-start-large'] = 'skip-start-large',
        ['skip-start-small'] = 'skip-start-small',
        ['smartphone-portrait'] = 'smartphone-portrait',
        speaker = 'speaker',
        ['speaker-slash'] = 'speaker-slash',
        ['speaker-triangle-exclamation'] = 'speaker-triangle-exclamation',
        ['speaker-x'] = 'speaker-x',
        ['speech-bubble-align-center'] = 'speech-bubble-align-center',
        ['speech-bubble-align-left'] = 'speech-bubble-align-left',
        ['speech-bubble-exclamation'] = 'speech-bubble-exclamation',
        ['speech-bubble-round'] = 'speech-bubble-round',
        ['square-bone'] = 'square-bone',
        ['square-books'] = 'square-books',
        ['square-check'] = 'square-check',
        ['square-code'] = 'square-code',
        ['square-dashed-person-standing'] = 'square-dashed-person-standing',
        ['square-dual-arrows-horizontal'] = 'square-dual-arrows-horizontal',
        ['square-dual-arrows-to-corner'] = 'square-dual-arrows-to-corner',
        ['square-face-sound'] = 'square-face-sound',
        ['square-face-waving-hand'] = 'square-face-waving-hand',
        ['square-face-winking'] = 'square-face-winking',
        ['square-minus'] = 'square-minus',
        ['square-person'] = 'square-person',
        ['squares-grid-plus'] = 'squares-grid-plus',
        ['squares-grid-qr'] = 'squares-grid-qr',
        ['stacked-squares-arrow-down-left'] = 'stacked-squares-arrow-down-left',
        ['stacked-squares-arrow-up-right'] = 'stacked-squares-arrow-up-right',
        ['stacked-squares-plus'] = 'stacked-squares-plus',
        star = 'star',
        ['stop-large'] = 'stop-large',
        ['stop-small'] = 'stop-small',
        studio = 'studio',
        sun = 'sun',
        sweater = 'sweater',
        sword = 'sword',
        ['tag-sparkle'] = 'tag-sparkle',
        teletype = 'teletype',
        ['tencent-qq'] = 'tencent-qq',
        ['text-b-bold'] = 'text-b-bold',
        ['text-box-microphone'] = 'text-box-microphone',
        ['text-h-subscript-1'] = 'text-h-subscript-1',
        ['text-h-subscript-2'] = 'text-h-subscript-2',
        ['text-h-subscript-3'] = 'text-h-subscript-3',
        ['text-i-italic'] = 'text-i-italic',
        ['text-s-strikethrough'] = 'text-s-strikethrough',
        ['text-u-underline'] = 'text-u-underline',
        ['text-uppercase-a-lowercase-a'] = 'text-uppercase-a-lowercase-a',
        ['text-x-subscript-2'] = 'text-x-subscript-2',
        ['text-x-superscript-2'] = 'text-x-superscript-2',
        ['three-bars-horizontal'] = 'three-bars-horizontal',
        ['three-bars-horizontal-chevron-left'] = 'three-bars-horizontal-chevron-left',
        ['three-bars-horizontal-narrowing'] = 'three-bars-horizontal-narrowing',
        ['three-bars-horizontal-triangles-vertical'] = 'three-bars-horizontal-triangles-vertical',
        ['three-bars-vertical-triangles-horizontal'] = 'three-bars-vertical-triangles-horizontal',
        ['three-chevrons-enlarging-down'] = 'three-chevrons-enlarging-down',
        ['three-chevrons-enlarging-up'] = 'three-chevrons-enlarging-up',
        ['three-dots-horizontal'] = 'three-dots-horizontal',
        ['three-dots-vertical'] = 'three-dots-vertical',
        ['three-horizontal-bars-wrapping-right'] = 'three-horizontal-bars-wrapping-right',
        ['three-people'] = 'three-people',
        ['three-ring-note'] = 'three-ring-note',
        ['three-sliders-horizontal'] = 'three-sliders-horizontal',
        ['three-stacked-squares-tilted'] = 'three-stacked-squares-tilted',
        ['thumb-down'] = 'thumb-down',
        ['thumb-up'] = 'thumb-up',
        ['tik-tok'] = 'tik-tok',
        tilt = 'tilt',
        torso = 'torso',
        ['trash-can'] = 'trash-can',
        ['triangle-exclamation'] = 'triangle-exclamation',
        trophy = 'trophy',
        tshirt = 'tshirt',
        ['tshirt-2d-text'] = 'tshirt-2d-text',
        ['tshirt-dual-arrows'] = 'tshirt-dual-arrows',
        twitch = 'twitch',
        twitter = 'twitter',
        ['two-arrows-down-and-up'] = 'two-arrows-down-and-up',
        ['two-arrows-from-center'] = 'two-arrows-from-center',
        ['two-arrows-left-right'] = 'two-arrows-left-right',
        ['two-arrows-loop-clockwise'] = 'two-arrows-loop-clockwise',
        ['two-arrows-loop-clockwise-1'] = 'two-arrows-loop-clockwise-1',
        ['two-arrows-loop-clockwise-infinity'] = 'two-arrows-loop-clockwise-infinity',
        ['two-arrows-spin-clockwise'] = 'two-arrows-spin-clockwise',
        ['two-arrows-spin-clockwise-plus'] = 'two-arrows-spin-clockwise-plus',
        ['two-arrows-switch-right'] = 'two-arrows-switch-right',
        ['two-arrows-to-center'] = 'two-arrows-to-center',
        ['two-folders'] = 'two-folders',
        ['two-location-pins-connecting-arrow'] = 'two-location-pins-connecting-arrow',
        ['two-makeup-brushes'] = 'two-makeup-brushes',
        ['two-people'] = 'two-people',
        ['two-people-speech-bubble'] = 'two-people-speech-bubble',
        ['two-stacked-squares'] = 'two-stacked-squares',
        ['two-switches-horizontal'] = 'two-switches-horizontal',
        ['verified-backplate'] = 'verified-backplate',
        ['verified-check'] = 'verified-check',
        ['verified-mono'] = 'verified-mono',
        ['video-camera'] = 'video-camera',
        ['video-camera-arrow-to-bottom-left'] = 'video-camera-arrow-to-bottom-left',
        ['video-camera-arrow-to-top-right'] = 'video-camera-arrow-to-top-right',
        ['video-camera-slash'] = 'video-camera-slash',
        ['video-camera-triangle-exclamation'] = 'video-camera-triangle-exclamation',
        ['video-camera-x'] = 'video-camera-x',
        wallet = 'wallet',
        ['we-chat'] = 'we-chat',
        whatsapp = 'whatsapp',
        x = 'x',
        ['x-small'] = 'x-small',
        ['xbox-a'] = 'xbox-a',
        ['xbox-a-pressed'] = 'xbox-a-pressed',
        ['xbox-a-unpressed'] = 'xbox-a-unpressed',
        ['xbox-b'] = 'xbox-b',
        ['xbox-dpad'] = 'xbox-dpad',
        ['xbox-dpad-down'] = 'xbox-dpad-down',
        ['xbox-dpad-left'] = 'xbox-dpad-left',
        ['xbox-dpad-right'] = 'xbox-dpad-right',
        ['xbox-dpad-up'] = 'xbox-dpad-up',
        ['xbox-lb'] = 'xbox-lb',
        ['xbox-lt'] = 'xbox-lt',
        ['xbox-menu'] = 'xbox-menu',
        ['xbox-rb'] = 'xbox-rb',
        ['xbox-rt'] = 'xbox-rt',
        ['xbox-stick-left'] = 'xbox-stick-left',
        ['xbox-stick-left-directional'] = 'xbox-stick-left-directional',
        ['xbox-stick-left-horizontal'] = 'xbox-stick-left-horizontal',
        ['xbox-stick-left-vertical'] = 'xbox-stick-left-vertical',
        ['xbox-stick-right'] = 'xbox-stick-right',
        ['xbox-stick-right-directional'] = 'xbox-stick-right-directional',
        ['xbox-stick-right-horizontal'] = 'xbox-stick-right-horizontal',
        ['xbox-stick-right-vertical'] = 'xbox-stick-right-vertical',
        ['xbox-view'] = 'xbox-view',
        ['xbox-x'] = 'xbox-x',
        ['xbox-y'] = 'xbox-y',
        ['xr-headset'] = 'xr-headset',
        youtube = 'youtube',
    }
end)
NeverLose.IsMouseOverFrame = LPH_NO_VIRTUALIZE(function(self, Frame)
    if not Frame then
        return
    end
    if NeverLose.Global3DRenderMode then
        if Frame.GuiState == Enum.GuiState.Hover or Frame.GuiState == Enum.GuiState.Press then
            return true
        end

        return false
    end

    local AbsPos: Vector2, AbsSize: Vector2 = Frame.AbsolutePosition, Frame.AbsoluteSize

    if Mouse.X >= AbsPos.X and Mouse.X <= AbsPos.X + AbsSize.X and Mouse.Y >= AbsPos.Y and Mouse.Y <= AbsPos.Y + AbsSize.Y then
        return true
    end
end)
NeverLose.CreateSignal = LPH_NO_VIRTUALIZE(function(self, DefaultValue)
    local __cache = Instance.new('BindableEvent')
    local bind = {
        Value = DefaultValue,
        __event = __cache,
    }

    function bind:GetValue()
        return bind.Value
    end
    function bind:SetValue(f)
        bind.Value = f

        return __cache:Fire(f)
    end
    function bind:Connect(f)
        local signal = __cache.Event:Connect(f)

        NeverLose:AddSignal(signal)

        return signal
    end

    return bind
end)
NeverLose.SetIconMode = LPH_NO_VIRTUALIZE(function(self, Label: TextLabel, Icon: string)
    local useBold = string.lower(string.sub(Icon, -5)) == '-bold'

    if useBold then
        Label.Text = Icon:sub(1, -6)
        Label.FontFace = NeverLose.BuiltInBold
    else
        Label.Text = Icon
        Label.FontFace = NeverLose.BuiltInRegular
    end
end)

function NeverLose:GetIconFont(icon: string)
    local useBold = string.lower(string.sub(icon, -5)) == '-bold'

    if useBold then
        return NeverLose.BuiltInBold
    end

    return NeverLose.BuiltInRegular
end
function NeverLose:MoreThanHalfY(Value: number)
    return (NeverLose.ScreenGui.AbsoluteSize.Y / 2) < Value
end

NeverLose.IsStudio = RunService:IsStudio()
NeverLose.IsMobile = (function()
    local touch = UserInputService.TouchEnabled
    local keyboard = UserInputService.KeyboardEnabled
    local mouse = UserInputService.MouseEnabled
    local gamepad = UserInputService.GamepadEnabled
    local platform

    pcall(function()
        platform = UserInputService:GetPlatform()
    end)

    if platform == Enum.Platform.IOS or platform == Enum.Platform.Android then
        return true
    end
    if not touch then
        return false
    end
    if not keyboard and not mouse and not gamepad then
        return true
    end

    local name

    pcall(function()
        local resolver = identifyexecutor or getexecutorname

        if type(resolver) == 'function' then
            name = resolver()
        end
    end)

    if type(name) == 'string' then
        name = string.lower(name)

        local mobiles = {
            'delta',
            'codex',
            'fluxus',
            'arceus',
            'hydrogen',
            'trigon',
            'vega',
            'cryptic',
            'evon',
            'ronix',
            'argon',
            'krnl',
        }

        for _, tag in ipairs(mobiles)do
            if string.find(name, tag, 1, true) then
                return true
            end
        end
    end

    return false
end)()
NeverLose.ForceMobileButton = false
NeverLose.CreateInput = LPH_NO_VIRTUALIZE(function(self, Frame, Callback)
    local Button = Instance.new('ImageButton', Frame)

    Button.ZIndex = Frame.ZIndex + 10
    Button.Size = UDim2.fromScale(1, 1)
    Button.BackgroundTransparency = 1
    Button.ImageTransparency = 1
    Button.Image = 'rbxasset://textuers/translateIcon.png'

    if Callback then
        local bth_signal = Button.MouseButton1Click:Connect(Callback)

        return Button, bth_signal
    end

    return Button
end)
NeverLose.PlayAnimate = LPH_NO_VIRTUALIZE(function(Self, Info, Property)
    local Tween = TweenService:Create(Self, Info or TweenInfo.new(0.25), Property)

    Tween:Play()

    return Tween
end)
NeverLose.Drag = LPH_NO_VIRTUALIZE(function(InputFrame: Frame, MoveFrame: Frame, Speed: number)
    local dragToggle: boolean = false
    local dragStart: Vector3 = nil
    local startPos: UDim2 = nil
    local Tween = TweenInfo.new(Speed)
    local updateInput = function(input)
        local delta = input.Position - dragStart
        local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)

        if NeverLose.Global3DRenderMode then
            NeverLose.PlayAnimate(MoveFrame, Tween, {
                Position = UDim2.fromScale(0.5, 0.5),
            })
        else
            NeverLose.PlayAnimate(MoveFrame, Tween, {Position = position})
        end
    end

    NeverLose:AddSignal(InputFrame.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragToggle = true
            dragStart = input.Position
            startPos = MoveFrame.Position

            local input_end

            input_end = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragToggle = false

                    input_end:Disconnect()
                end
            end)
        end
    end))
    NeverLose:AddSignal(UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragToggle then
                updateInput(input)
            end
        end
    end))
end)
NeverLose.Rounding = LPH_NO_VIRTUALIZE(function(num, numDecimalPlaces)
    local mult = 10 ^ (numDecimalPlaces or 0)

    return math.floor(num * mult + 0.5) / mult
end)
NeverLose.ProcessParams = LPH_NO_VIRTUALIZE(function(self, Params, Fixed)
    Params = Params or {}

    local k = Params or {}

    for i, v in next, Fixed do
        k[i] = Params[i] or v
    end

    table.clear(Fixed)

    return k
end)
NeverLose.EnabledBlur = false
NeverLose.BlurModuleParent = workspace.CurrentCamera
NeverLose.FovModes = {
    Horizontal = false,
    Diagonal = (function()
        local ok, mode = pcall(function()
            return Enum.FieldOfViewMode.Diagonal
        end)

        if ok and mode then
            return mode
        end

        return false
    end)(),
    MaxAxis = (function()
        local ok, mode = pcall(function()
            return Enum.FieldOfViewMode.MaxAxis
        end)

        if ok and mode then
            return mode
        end

        return false
    end)(),
}
NeverLose.GetProjectionTangents = LPH_NO_VIRTUALIZE(function(Camera, Viewport)
    local Aspect = Viewport.X / Viewport.Y
    local Tangent = math.tan(math.rad(Camera.FieldOfView) / 2)
    local Mode = Camera.FieldOfViewMode
    local Modes = NeverLose.FovModes

    if Mode == Modes.Horizontal then
        return Tangent, Tangent / Aspect
    elseif Mode == Modes.Diagonal then
        local Normalizer = math.sqrt(Aspect * Aspect + 1)

        return Tangent * Aspect / Normalizer, Tangent / Normalizer
    elseif Mode == Modes.MaxAxis then
        if Aspect >= 1 then
            return Tangent, Tangent / Aspect
        end

        return Tangent * Aspect, Tangent
    end

    return Tangent * Aspect, Tangent
end)
NeverLose.GetCalculatePosition = LPH_NO_VIRTUALIZE(function(planePos, planeNormal, rayOrigin, rayDirection)
    local n = planeNormal
    local d = rayDirection
    local v = rayOrigin - planePos
    local num = (n.x * v.x) + (n.y * v.y) + (n.z * v.z)
    local den = (n.x * d.x) + (n.y * d.y) + (n.z * d.z)
    local a = -num / den

    return rayOrigin + (a * rayDirection)
end)
NeverLose.CreateBlurModule = LPH_NO_VIRTUALIZE(function(self, Frame, Signal, Force)
    if not NeverLose.EnabledBlur then
        return NeverLose:AddSignal(Instance.new('BindableEvent').Event:Connect(function()
            return 'nl'
        end))
    end

    local Part = Instance.new('Part', NeverLose.BlurModuleParent)
    local DepthOfField = Instance.new('DepthOfFieldEffect', cloneref(game:GetService('Lighting')))
    local BlockMesh = Instance.new('BlockMesh')

    BlockMesh.Parent = Part
    Part.Material = Enum.Material.Glass
    Part.Transparency = 1
    Part.Reflectance = 0
    Part.CastShadow = false
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CollisionGroup = 'Default'
    Part.Size = Vector3.new(1, 1, 1) * 0.01
    Part.Color = Color3.fromRGB(0, 0, 0)
    Part.LocalTransparencyModifier = 1
    DepthOfField.Enabled = true
    DepthOfField.FarIntensity = 0
    DepthOfField.FocusDistance = 0
    DepthOfField.InFocusRadius = 1000
    DepthOfField.NearIntensity = 1
    DepthOfField.Name = NeverLose.RandomString()
    Part.Name = NeverLose.RandomString()

    local disconnect
    local RenderState = nil
    local ResolveCamera = function()
        local Camera = workspace.CurrentCamera

        if Camera then
            return Camera
        end

        return CurrentCamera
    end
    local ResolveParent = function()
        local Parent = NeverLose.BlurModuleParent

        if typeof(Parent) ~= 'Instance' or Parent.Parent == nil then
            Parent = ResolveCamera()
            NeverLose.BlurModuleParent = Parent
        end

        return Parent
    end
    local UpdateFunction = function()
        local IsWindowActive = Signal:GetValue()

        if IsWindowActive and (Force or not NeverLose.Global3DRenderMode) then
            if RenderState ~= true then
                RenderState = true

                NeverLose.PlayAnimate(DepthOfField, TweenInfo.new(0.1), {NearIntensity = 1})

                Part.Transparency = 1
                Part.LocalTransparencyModifier = 1
                Part.Reflectance = 0
                Part.Size = Vector3.new(1, 1, 1) * 0.01
            end

            Part.Parent = ResolveParent()
        else
            if RenderState ~= false then
                RenderState = false

                NeverLose.PlayAnimate(DepthOfField, TweenInfo.new(0.1), {NearIntensity = 0})

                Part.Transparency = 1
                Part.LocalTransparencyModifier = 1
                Part.Size = Vector3.zero
            end

            Part.Parent = nil

            return false
        end
        if IsWindowActive then
            local Camera = ResolveCamera()

            if not Camera then
                return false
            end

            local RawCFrame = Camera.CFrame
            local RightAxis = RawCFrame.RightVector
            local UpAxis = RawCFrame.UpVector
            local StretchX = math.max(RightAxis.Magnitude, 0.001)
            local StretchY = math.max(UpAxis.Magnitude, 0.001)
            local BaseCFrame = CFrame.fromMatrix(RawCFrame.Position, RightAxis / StretchX, UpAxis / StretchY)
            local Viewport = Camera.ViewportSize

            if Viewport.X <= 0 or Viewport.Y <= 0 then
                return false
            end

            local Distance = 0.05 - Camera.NearPlaneZ
            local TanX, TanY = NeverLose.GetProjectionTangents(Camera, Viewport)
            local Inset = GuiService:GetGuiInset()
            local corner0 = Frame.AbsolutePosition + Inset
            local corner1 = corner0 + Frame.AbsoluteSize
            local pos0 = Vector3.new(((corner0.X / Viewport.X) * 2 - 1) * TanX * Distance / StretchX, (1 - (corner0.Y / Viewport.Y) * 2) * TanY * Distance / StretchY, -Distance)
            local pos1 = Vector3.new(((corner1.X / Viewport.X) * 2 - 1) * TanX * Distance / StretchX, (1 - (corner1.Y / Viewport.Y) * 2) * TanY * Distance / StretchY, -Distance)
            local size = pos1 - pos0
            local center = (pos0 + pos1) / 2

            BlockMesh.Offset = center
            BlockMesh.Scale = Vector3.new(math.abs(size.X), math.abs(size.Y), 0) / 0.0101
            Part.CFrame = BaseCFrame
            Part.Transparency = 1
            Part.LocalTransparencyModifier = 1
            Part.Reflectance = 0
        end
    end
    local rbxsignal = NeverLose:AddSignal(CurrentCamera:GetPropertyChangedSignal('CFrame'):Connect(UpdateFunction))
    local loopThread = NeverLose:AddSignal(UserInputService.InputChanged:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
            pcall(UpdateFunction)
        end
    end))
    local THREAD = task.spawn(function()
        while true do
            if Force then
                RunService.RenderStepped:Wait()
            else
                task.wait(0.1)
            end

            pcall(UpdateFunction)
        end
    end)
    local cframeHook
    local HookCamera = function()
        if cframeHook then
            cframeHook:Disconnect()

            cframeHook = nil
        end

        local Camera = ResolveCamera()

        if Camera then
            cframeHook = Camera:GetPropertyChangedSignal('CFrame'):Connect(UpdateFunction)
        end
    end

    HookCamera()

    local cameraSwap = NeverLose:AddSignal(workspace:GetPropertyChangedSignal('CurrentCamera'):Connect(function()
        RenderState = nil

        HookCamera()
        pcall(UpdateFunction)
    end))

    disconnect = function()
        rbxsignal:Disconnect()
        loopThread:Disconnect()
        cameraSwap:Disconnect()

        if cframeHook then
            cframeHook:Disconnect()

            cframeHook = nil
        end

        task.cancel(THREAD)
        Part:Destroy()
        DepthOfField:Destroy()
    end

    Frame.Destroying:Connect(disconnect)

    return rbxsignal
end)

local EmptyFunction = function() end

function NeverLose:RollingEffect(parent)
    local UIGradient = Instance.new('UIGradient')

    UIGradient.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 0.4),
        NumberSequenceKeypoint.new(1, 0),
    }
    UIGradient.Parent = parent

    return UIGradient
end
function NeverLose:CreateShadow(parent, RollingEffect)
    local Shadow = {}
    local UIShadowSafe85 = Instance.new('UIStroke')
    local UIShadowSafe65 = Instance.new('UIStroke')
    local UIShadowSafe50 = Instance.new('UIStroke')
    local UIShadowSafe45 = Instance.new('UIStroke')

    UIShadowSafe85.Thickness = 6
    UIShadowSafe85.Transparency = 1
    UIShadowSafe85.Parent = parent
    UIShadowSafe65.Thickness = 5
    UIShadowSafe65.Transparency = 1
    UIShadowSafe65.Parent = parent
    UIShadowSafe50.Thickness = 4
    UIShadowSafe50.Transparency = 1
    UIShadowSafe50.Parent = parent
    UIShadowSafe45.Thickness = 3
    UIShadowSafe45.Transparency = 1
    UIShadowSafe45.Parent = parent

    local RollingEffectThread
    local r1, r2, r3, r4

    if RollingEffect then
        r1 = NeverLose:RollingEffect(UIShadowSafe85)
        r2 = NeverLose:RollingEffect(UIShadowSafe65)
        r3 = NeverLose:RollingEffect(UIShadowSafe50)
        r4 = NeverLose:RollingEffect(UIShadowSafe45)
    end

    Shadow.Render = LPH_NO_VIRTUALIZE(function(self, value)
        if RollingEffectThread then
            task.cancel(RollingEffectThread)

            RollingEffectThread = nil
        end
        if value then
            NeverLose.PlayAnimate(UIShadowSafe85, SlowyTween, {Transparency = 0.9})
            NeverLose.PlayAnimate(UIShadowSafe65, SlowyTween, {Transparency = 0.9})
            NeverLose.PlayAnimate(UIShadowSafe50, SlowyTween, {Transparency = 0.9})
            NeverLose.PlayAnimate(UIShadowSafe45, SlowyTween, {Transparency = 0.9})

            if RollingEffect then
                RollingEffectThread = task.spawn(function()
                    local level = 20

                    while true do
                        task.wait(0.025)
                        NeverLose.PlayAnimate(r1, SlowyTween, {
                            Rotation = r1.Rotation + level,
                        })
                        NeverLose.PlayAnimate(r2, SlowyTween, {
                            Rotation = r2.Rotation + level,
                        })
                        NeverLose.PlayAnimate(r3, SlowyTween, {
                            Rotation = r3.Rotation + level,
                        })
                        NeverLose.PlayAnimate(r4, SlowyTween, {
                            Rotation = r4.Rotation + level,
                        })
                    end
                end)
            end
        else
            NeverLose.PlayAnimate(UIShadowSafe85, SlowyTween, {Transparency = 1})
            NeverLose.PlayAnimate(UIShadowSafe65, SlowyTween, {Transparency = 1})
            NeverLose.PlayAnimate(UIShadowSafe50, SlowyTween, {Transparency = 1})
            NeverLose.PlayAnimate(UIShadowSafe45, SlowyTween, {Transparency = 1})
        end
    end)

    return Shadow
end
function NeverLose:CreateOptionWindow(Frame: Frame, Zindex)
    Zindex = Zindex or 9

    local Window = {
        Signal = NeverLose:CreateSignal(false),
    }
    local OptionHandler = Instance.new('Frame')
    local UICorner = Instance.new('UICorner')
    local UIListLayout = Instance.new('UIListLayout')
    local UIStroke = Instance.new('UIStroke')
    local shadow = NeverLose:CreateShadow(OptionHandler)

    OptionHandler.Name = NeverLose.RandomString()
    OptionHandler.Parent = NeverLose.ScreenGui
    OptionHandler.AnchorPoint = Vector2.new(0, 0)
    OptionHandler.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
    OptionHandler.BackgroundTransparency = 0.035
    OptionHandler.BorderColor3 = Color3.fromRGB(0, 0, 0)
    OptionHandler.BorderSizePixel = 0
    OptionHandler.ClipsDescendants = true
    OptionHandler.Position = UDim2.new(255, 255, 255, 255)
    OptionHandler.Size = UDim2.new(0, 220, 0, 75)
    OptionHandler.ZIndex = Zindex + 9
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = OptionHandler
    UIListLayout.Parent = OptionHandler
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIStroke.Transparency = 0.65
    UIStroke.Color = Color3.fromRGB(45, 48, 58)
    UIStroke.Parent = OptionHandler

    NeverLose:AddSignal(UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(LPH_NO_VIRTUALIZE(function()
        NeverLose.PlayAnimate(OptionHandler, SlowyTween, {
            Size = UDim2.new(0, 220, 0, UIListLayout.AbsoluteContentSize.Y - 1),
        })
    end)))
    NeverLose:AddSignal(OptionHandler:GetPropertyChangedSignal('BackgroundTransparency'):Connect(LPH_NO_VIRTUALIZE(function()
        if OptionHandler.BackgroundTransparency > 0.9 then
            OptionHandler.Visible = false
            UIListLayout.Parent = nil
            OptionHandler.Parent = nil
        else
            OptionHandler.Visible = true
            UIListLayout.Parent = OptionHandler

            if NeverLose.Global3DRenderMode then
                OptionHandler.Parent = NeverLose.GlobalSurfaceGui
            else
                OptionHandler.Parent = NeverLose.ScreenGui
            end
        end
    end)))

    local FollowingThread
    local SetPosition = LPH_NO_VIRTUALIZE(function()
        if NeverLose:MoreThanHalfY(Frame.AbsolutePosition.Y + 65) then
            OptionHandler.AnchorPoint = Vector2.new(0, 1)
        else
            OptionHandler.AnchorPoint = Vector2.new(0, 0)
        end

        OptionHandler.Position = UDim2.fromOffset(Frame.AbsolutePosition.X + 18, Frame.AbsolutePosition.Y + 65)
    end)

    Window.SetRender = LPH_NO_VIRTUALIZE(function(value)
        if FollowingThread then
            task.cancel(FollowingThread)

            FollowingThread = nil
        end
        if value then
            SetPosition()
            NeverLose.PlayAnimate(OptionHandler, SlowyTween, {BackgroundTransparency = 0.035})
            NeverLose.PlayAnimate(UIStroke, SlowyTween, {Transparency = 0.65})
            shadow:Render(true)

            if NeverLose.Global3DRenderMode then
                OptionHandler.Parent = NeverLose.GlobalSurfaceGui
            else
                OptionHandler.Parent = NeverLose.ScreenGui
            end

            FollowingThread = task.spawn(function()
                while true do
                    task.wait()
                    SetPosition()
                end
            end)
        else
            NeverLose.PlayAnimate(OptionHandler, SlowyTween, {BackgroundTransparency = 1})
            NeverLose.PlayAnimate(UIStroke, SlowyTween, {Transparency = 1})
            shadow:Render(false)
        end
    end)

    Window.SetRender(false)
    Window.Signal:Connect(Window.SetRender)

    local Payback = NeverLose:RegisiterItem(OptionHandler, Window.Signal)

    Payback.Winbdow = Window
    Payback.Root = OptionHandler
    Payback.Signal = Window.Signal

    return Payback
end
function NeverLose:CreateColorPicker(HandleFrame: Frame)
    local ZIndex = HandleFrame.ZIndex
    local ColorPickerLib = {}
    local ColorPickerHandler = Instance.new('Frame')
    local UICorner = Instance.new('UICorner')
    local UIStroke = Instance.new('UIStroke')
    local SaViMap = Instance.new('Frame')
    local UICorner_2 = Instance.new('UICorner')
    local SatOverlay = Instance.new('Frame')
    local SatGradient = Instance.new('UIGradient')
    local ValOverlay = Instance.new('Frame')
    local ValGradient = Instance.new('UIGradient')
    local ColorZoneSelection = Instance.new('Frame')
    local UICorner_3 = Instance.new('UICorner')
    local UIStroke_2 = Instance.new('UIStroke')
    local ColorMap = Instance.new('Frame')
    local UIGradient = Instance.new('UIGradient')
    local UICorner_4 = Instance.new('UICorner')
    local ColorMapSelection = Instance.new('Frame')
    local UIStroke_3 = Instance.new('UIStroke')
    local UICorner_5 = Instance.new('UICorner')
    local RGBLabel = Instance.new('TextBox')
    local UICorner_6 = Instance.new('UICorner')
    local Shadow = NeverLose:CreateShadow(ColorPickerHandler)

    ColorPickerHandler.Name = NeverLose.RandomString()
    ColorPickerHandler.Parent = NeverLose.ScreenGui
    ColorPickerHandler.AnchorPoint = Vector2.new(0, 0)
    ColorPickerHandler.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
    ColorPickerHandler.BackgroundTransparency = 0.035
    ColorPickerHandler.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ColorPickerHandler.BorderSizePixel = 0
    ColorPickerHandler.ClipsDescendants = true
    ColorPickerHandler.Position = UDim2.new(255, 0, 255, 20)
    ColorPickerHandler.Size = UDim2.new(0, 200, 0, 240)
    ColorPickerHandler.ZIndex = ZIndex + 125

    NeverLose:AddSignal(ColorPickerHandler:GetPropertyChangedSignal('BackgroundTransparency'):Connect(LPH_NO_VIRTUALIZE(function()
        if ColorPickerHandler.BackgroundTransparency > 0.9 then
            ColorPickerHandler.Visible = false
            ColorPickerHandler.Parent = nil
        else
            ColorPickerHandler.Visible = true

            if NeverLose.Global3DRenderMode then
                ColorPickerHandler.Parent = NeverLose.GlobalSurfaceGui
            else
                ColorPickerHandler.Parent = NeverLose.ScreenGui
            end
        end
    end)))

    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = ColorPickerHandler
    UIStroke.Transparency = 0.65
    UIStroke.Color = Color3.fromRGB(45, 48, 58)
    UIStroke.Parent = ColorPickerHandler
    SaViMap.Name = NeverLose.RandomString()
    SaViMap.Parent = ColorPickerHandler
    SaViMap.AnchorPoint = Vector2.new(0.5, 0)
    SaViMap.BackgroundColor3 = Color3.fromRGB(255, 0, 4)
    SaViMap.BorderColor3 = Color3.fromRGB(0, 0, 0)
    SaViMap.BorderSizePixel = 0
    SaViMap.Position = UDim2.new(0.5, 0, 0, 5)
    SaViMap.Size = UDim2.new(0, 185, 0, 185)
    SaViMap.ZIndex = ZIndex + 126
    SaViMap.ClipsDescendants = true
    UICorner_2.CornerRadius = UDim.new(0, 5)
    UICorner_2.Parent = SaViMap
    SatOverlay.Name = NeverLose.RandomString()
    SatOverlay.Parent = SaViMap
    SatOverlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SatOverlay.BorderSizePixel = 0
    SatOverlay.Size = UDim2.fromScale(1, 1)
    SatOverlay.ZIndex = ZIndex + 126
    SatGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 1),
    })
    SatGradient.Parent = SatOverlay
    ValOverlay.Name = NeverLose.RandomString()
    ValOverlay.Parent = SaViMap
    ValOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    ValOverlay.BorderSizePixel = 0
    ValOverlay.Size = UDim2.fromScale(1, 1)
    ValOverlay.ZIndex = ZIndex + 126
    ValGradient.Rotation = 90
    ValGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(1, 0),
    })
    ValGradient.Parent = ValOverlay
    ColorZoneSelection.Name = NeverLose.RandomString()
    ColorZoneSelection.Parent = SaViMap
    ColorZoneSelection.AnchorPoint = Vector2.new(0.5, 0.5)
    ColorZoneSelection.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ColorZoneSelection.BackgroundTransparency = 1
    ColorZoneSelection.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ColorZoneSelection.BorderSizePixel = 0
    ColorZoneSelection.Position = UDim2.new(0.5, 0, 0.5, 0)
    ColorZoneSelection.Size = UDim2.new(0, 12, 0, 12)
    ColorZoneSelection.ZIndex = ZIndex + 128
    UICorner_3.CornerRadius = UDim.new(1, 0)
    UICorner_3.Parent = ColorZoneSelection
    UIStroke_2.Thickness = 2
    UIStroke_2.Color = Color3.fromRGB(255, 255, 255)
    UIStroke_2.Parent = ColorZoneSelection
    ColorMap.Name = NeverLose.RandomString()
    ColorMap.Parent = ColorPickerHandler
    ColorMap.AnchorPoint = Vector2.new(0.5, 0)
    ColorMap.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ColorMap.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ColorMap.BorderSizePixel = 0
    ColorMap.Position = UDim2.new(0.5, 0, 0, 200)
    ColorMap.Size = UDim2.new(1, -15, 0, 10)
    ColorMap.ZIndex = ZIndex + 126
    ColorMap.ClipsDescendants = true
    UIGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.1, Color3.fromRGB(255, 153, 0)),
        ColorSequenceKeypoint.new(0.2, Color3.fromRGB(203, 255, 0)),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(50, 255, 0)),
        ColorSequenceKeypoint.new(0.4, Color3.fromRGB(0, 255, 102)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
        ColorSequenceKeypoint.new(0.6, Color3.fromRGB(0, 101, 255)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(50, 0, 255)),
        ColorSequenceKeypoint.new(0.8, Color3.fromRGB(204, 0, 255)),
        ColorSequenceKeypoint.new(0.9, Color3.fromRGB(255, 0, 153)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
    }
    UIGradient.Parent = ColorMap
    UICorner_4.CornerRadius = UDim.new(0, 3)
    UICorner_4.Parent = ColorMap
    ColorMapSelection.Name = NeverLose.RandomString()
    ColorMapSelection.Parent = ColorMap
    ColorMapSelection.AnchorPoint = Vector2.new(0.5, 0.5)
    ColorMapSelection.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ColorMapSelection.BackgroundTransparency = 0
    ColorMapSelection.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ColorMapSelection.BorderSizePixel = 0
    ColorMapSelection.Position = UDim2.new(0, 0, 0.5, 0)
    ColorMapSelection.Size = UDim2.new(0, 12, 0, 12)
    ColorMapSelection.ZIndex = ZIndex + 127
    UIStroke_3.Thickness = 2
    UIStroke_3.Color = Color3.fromRGB(30, 30, 35)
    UIStroke_3.Parent = ColorMapSelection
    UICorner_5.CornerRadius = UDim.new(1, 0)
    UICorner_5.Parent = ColorMapSelection
    RGBLabel.Name = NeverLose.RandomString()
    RGBLabel.Parent = ColorPickerHandler
    RGBLabel.BackgroundColor3 = Color3.fromRGB(26, 28, 36)
    RGBLabel.BackgroundTransparency = 0.75
    RGBLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
    RGBLabel.BorderSizePixel = 0
    RGBLabel.Position = UDim2.new(0, 10, 0, 217)
    RGBLabel.Size = UDim2.new(1, -20, 0, 15)
    RGBLabel.ZIndex = ZIndex + 127
    RGBLabel.Font = Enum.Font.GothamBold
    RGBLabel.Text = '#FFFFFF'
    RGBLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    RGBLabel.TextSize = 12
    RGBLabel.TextTransparency = 0.4
    RGBLabel.TextXAlignment = Enum.TextXAlignment.Left
    RGBLabel.ClearTextOnFocus = false
    RGBLabel.TextEditable = true
    UICorner_6.CornerRadius = UDim.new(0, 4)
    UICorner_6.Parent = RGBLabel
    ColorPickerLib.SetRender = LPH_NO_VIRTUALIZE(function(value)
        if value then
            ColorPickerHandler.Position = UDim2.new(0, HandleFrame.AbsolutePosition.X + 20, 0, HandleFrame.AbsolutePosition.Y + 75)

            NeverLose.PlayAnimate(ColorPickerHandler, SlowyTween, {BackgroundTransparency = 0.035})
            NeverLose.PlayAnimate(UIStroke, SlowyTween, {Transparency = 0.65})
            NeverLose.PlayAnimate(SaViMap, SlowyTween, {BackgroundTransparency = 0})
            NeverLose.PlayAnimate(SatOverlay, SlowyTween, {BackgroundTransparency = 0})
            NeverLose.PlayAnimate(ValOverlay, SlowyTween, {BackgroundTransparency = 0})
            NeverLose.PlayAnimate(UIStroke_2, SlowyTween, {Transparency = 0})
            NeverLose.PlayAnimate(ColorMap, SlowyTween, {BackgroundTransparency = 0})
            NeverLose.PlayAnimate(UIStroke_3, SlowyTween, {Transparency = 0})
            NeverLose.PlayAnimate(ColorMapSelection, SlowyTween, {BackgroundTransparency = 0})
            NeverLose.PlayAnimate(RGBLabel, SlowyTween, {
                BackgroundTransparency = 0.75,
                TextTransparency = 0.4,
            })
            Shadow:Render(true)
        else
            NeverLose.PlayAnimate(ColorPickerHandler, SlowyTween, {BackgroundTransparency = 1})
            NeverLose.PlayAnimate(UIStroke, SlowyTween, {Transparency = 1})
            NeverLose.PlayAnimate(SaViMap, SlowyTween, {BackgroundTransparency = 1})
            NeverLose.PlayAnimate(SatOverlay, SlowyTween, {BackgroundTransparency = 1})
            NeverLose.PlayAnimate(ValOverlay, SlowyTween, {BackgroundTransparency = 1})
            NeverLose.PlayAnimate(UIStroke_2, SlowyTween, {Transparency = 1})
            NeverLose.PlayAnimate(ColorMap, SlowyTween, {BackgroundTransparency = 1})
            NeverLose.PlayAnimate(UIStroke_3, SlowyTween, {Transparency = 1})
            NeverLose.PlayAnimate(ColorMapSelection, SlowyTween, {BackgroundTransparency = 1})
            NeverLose.PlayAnimate(RGBLabel, SlowyTween, {
                BackgroundTransparency = 1,
                TextTransparency = 1,
            })
            Shadow:Render(false)
        end
    end)

    ColorPickerLib.SetRender(false)

    ColorPickerLib.Root = ColorPickerHandler
    ColorPickerLib.H = 0
    ColorPickerLib.S = 0
    ColorPickerLib.V = 1
    ColorPickerLib.Callback = EmptyFunction

    function ColorPickerLib:Update()
        local H = math.clamp(ColorPickerLib.H, 0, 1)
        local S = math.clamp(ColorPickerLib.S, 0, 1)
        local V = math.clamp(ColorPickerLib.V, 0, 1)

        ColorPickerLib.H = H
        ColorPickerLib.S = S
        ColorPickerLib.V = V

        local RealColor = Color3.fromHSV(H, S, V)

        NeverLose.PlayAnimate(ColorZoneSelection, ManualTween, {
            Position = UDim2.fromScale(S, 1 - V),
        })
        NeverLose.PlayAnimate(SaViMap, ManualTween, {
            BackgroundColor3 = Color3.fromHSV(H, 1, 1),
        })
        NeverLose.PlayAnimate(ColorMapSelection, ManualTween, {
            Position = UDim2.fromScale(H, 0.5),
        })

        RGBLabel.Text = '#' .. string.upper(RealColor:ToHex())

        ColorPickerLib.Callback(RealColor)
    end
    function ColorPickerLib:SetValue(Color)
        if typeof(Color) == 'string' then
            local ok, parsed = pcall(Color3.fromHex, Color)

            if ok and parsed then
                Color = parsed
            else
                return
            end
        end
        if typeof(Color) ~= 'Color3' then
            return
        end

        local H, S, V = Color:ToHSV()

        ColorPickerLib.H = H
        ColorPickerLib.S = S
        ColorPickerLib.V = V

        ColorPickerLib:Update()
    end

    NeverLose:AddSignal(RGBLabel.FocusLost:Connect(LPH_NO_VIRTUALIZE(function()
        local hex = RGBLabel.Text:gsub('%s', ''):gsub('#', '')

        if #hex == 6 and hex:match('^%x%x%x%x%x%x$') then
            ColorPickerLib:SetValue('#' .. hex)
        else
            ColorPickerLib:Update()
        end
    end)))

    ColorPickerLib.IsHold = false

    NeverLose:AddSignal(ColorPickerHandler.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            ColorPickerLib.IsHold = true
        end
    end))
    NeverLose:AddSignal(ColorPickerHandler.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            ColorPickerLib.IsHold = false
        end
    end))

    local function sampleHue(posX)
        local ColorY = ColorMap.AbsolutePosition.X
        local ColorYM = ColorY + ColorMap.AbsoluteSize.X

        if ColorYM <= ColorY then
            return
        end

        local Value = math.clamp(posX, ColorY, ColorYM)

        ColorPickerLib.H = (Value - ColorY) / (ColorYM - ColorY)

        ColorPickerLib:Update()
    end
    local function sampleSV(posX, posY)
        local PosX = SaViMap.AbsolutePosition.X
        local ScaleX = PosX + SaViMap.AbsoluteSize.X
        local PosY = SaViMap.AbsolutePosition.Y
        local ScaleY = PosY + SaViMap.AbsoluteSize.Y

        if ScaleX <= PosX or ScaleY <= PosY then
            return
        end

        local Value = math.clamp(posX, PosX, ScaleX)
        local Vals = math.clamp(posY, PosY, ScaleY)

        ColorPickerLib.S = (Value - PosX) / (ScaleX - PosX)
        ColorPickerLib.V = 1 - ((Vals - PosY) / (ScaleY - PosY))

        ColorPickerLib:Update()
    end

    NeverLose:AddSignal(ColorMap.InputBegan:Connect(LPH_NO_VIRTUALIZE(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            ColorPickerLib.IsHold = true

            sampleHue(Input.Position.X)

            while(UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or ColorPickerLib.IsHold) do
                task.wait()
                sampleHue(Mouse.X)
            end
        end
    end)))
    NeverLose:AddSignal(SaViMap.InputBegan:Connect(LPH_NO_VIRTUALIZE(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            ColorPickerLib.IsHold = true

            sampleSV(Input.Position.X, Input.Position.Y)

            while(UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or ColorPickerLib.IsHold) do
                task.wait()
                sampleSV(Mouse.X, Mouse.Y)
            end
        end
    end)))

    return ColorPickerLib
end

NeverLose.KeyEnum = {
    One = '1',
    Two = '2',
    Three = '3',
    Four = '4',
    Five = '5',
    Six = '6',
    Seven = '7',
    Eight = '8',
    Nine = '9',
    Zero = '0',
    Minus = '-',
    Plus = '+',
    BackSlash = '\\',
    Slash = '/',
    Period = '.',
    Semicolon = ';',
    Colon = ':',
    LeftControl = 'LCtrl',
    RightControl = 'RCtrl',
    LeftShift = 'LShift',
    RightShift = 'RShift',
    Return = 'Enter',
    LeftBracket = '[',
    RightBracket = ']',
    Quote = "'",
    Comma = ',',
    Equals = '=',
    LeftSuper = 'Super',
    RightSuper = 'Super',
    LeftAlt = 'LAlt',
    RightAlt = 'RAlt',
    Escape = 'Esc',
}
NeverLose.EnumReverse = {}

for i, v in next, NeverLose.KeyEnum do
    NeverLose.EnumReverse[v] = i
end

function NeverLose:KeyCodeToStr(K: Enum.KeyCode)
    if typeof(K) == 'string' then
        if NeverLose.KeyEnum[K] then
            return NeverLose.KeyEnum[K]
        end

        return K
    end

    return (NeverLose.KeyEnum[K.Name] or K.Name)
end
function NeverLose:StrToKeyCode(str: string)
    if NeverLose.EnumReverse[str] then
        return Enum.KeyCode[NeverLose.EnumReverse[str] ]
    end

    return Enum.KeyCode[str]
end
function NeverLose:CreateElementKeybind(Element, ElementType, GetValue, SetValue, Callback, FlagId, DisplayName, Signal, SliderInfo)
    if not NeverLose.ElementKeybinds then
        NeverLose.ElementKeybinds = {}
    end
    if not NeverLose.BindSignals then
        NeverLose.BindSignals = {}
    end

    local function trackBind(conn)
        table.insert(NeverLose.BindSignals, conn)

        return conn
    end

    local elementId = FlagId or Element.Name

    if not NeverLose.Flags.__ElementKeybinds then
        NeverLose.Flags.__ElementKeybinds = {
            GetValue = function()
                local out = {}

                for id, d in next, NeverLose.ElementKeybinds do
                    out[id] = {
                        Key = d.Key or false,
                        Mode = d.Mode,
                        SliderValue = d.SliderValue,
                    }
                end

                return out
            end,
            SetValue = function(_, data)
                if typeof(data) ~= 'table' then
                    return
                end

                for id, saved in next, data do
                    local d = NeverLose.ElementKeybinds[id]

                    if d then
                        if saved.Key and saved.Key ~= false then
                            d.Key = saved.Key
                        else
                            d.Key = nil
                        end
                        if saved.Mode then
                            d.Mode = saved.Mode
                        end
                        if saved.SliderValue ~= nil then
                            d.SliderValue = saved.SliderValue
                        end
                        if d.Refresh then
                            d.Refresh()
                        end
                    end
                end
            end,
        }
    end

    local KeybindData = NeverLose.ElementKeybinds[elementId] or {
        Type = ElementType,
        Key = nil,
        Mode = 'Toggle',
        SliderValue = (SliderInfo and SliderInfo.Min) or 0,
        SliderActive = false,
        OriginalValue = nil,
    }

    NeverLose.ElementKeybinds[elementId] = KeybindData
    KeybindData.Type = ElementType
    KeybindData.Name = DisplayName or elementId
    KeybindData.GetValue = GetValue

    if ElementType == 'Slider' and SliderInfo and KeybindData.SliderValue == nil then
        KeybindData.SliderValue = GetValue()
    end

    local BindMenu = Instance.new('Frame')
    local BindCorner = Instance.new('UICorner')
    local BindStroke = Instance.new('UIStroke')
    local Shadow = NeverLose:CreateShadow(BindMenu)

    BindMenu.Name = NeverLose.RandomString()
    BindMenu.Parent = NeverLose.ScreenGui
    BindMenu.AnchorPoint = Vector2.new(0, 0)
    BindMenu.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
    BindMenu.BackgroundTransparency = 1
    BindMenu.BorderSizePixel = 0
    BindMenu.ClipsDescendants = true
    BindMenu.Position = UDim2.new(255, 0, 255, 0)
    BindMenu.Size = UDim2.new(0, 0, 0, 0)
    BindMenu.Visible = false
    BindMenu.ZIndex = 400
    BindCorner.CornerRadius = UDim.new(0, 8)
    BindCorner.Parent = BindMenu
    BindStroke.Transparency = 0.65
    BindStroke.Color = Color3.fromRGB(45, 48, 58)
    BindStroke.Parent = BindMenu

    local PAD = 8
    local ROW_Y = 30
    local ROW_H = 18
    local DEL_W = 14
    local GAP = 6
    local KEY_W = 62
    local MODE_W = 58
    local hasMode = ElementType ~= 'Button'
    local hasSlider = ElementType == 'Slider' and SliderInfo ~= nil
    local titleText = tostring(KeybindData.Name)
    local titleWidth = TextService:GetTextSize(titleText, 11, Enum.Font.GothamBold, Vector2.new(math.huge, math.huge)).X
    local rowWidth = KEY_W + GAP + DEL_W

    if hasMode then
        rowWidth = rowWidth + MODE_W + GAP
    end

    local menuWidth = math.min(math.max(titleWidth + 2, rowWidth) + (PAD * 2), 226)
    local menuHeight = hasSlider and (ROW_Y + ROW_H + 7 + 16 + PAD) or (ROW_Y + ROW_H + PAD)
    local modeWidth = menuWidth - (PAD * 2) - KEY_W - (GAP * 2) - DEL_W
    local TitleLabel = Instance.new('TextLabel')

    TitleLabel.Name = NeverLose.RandomString()
    TitleLabel.Parent = BindMenu
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.BorderSizePixel = 0
    TitleLabel.ClipsDescendants = true
    TitleLabel.Position = UDim2.new(0, PAD, 0, 8)
    TitleLabel.Size = UDim2.new(1, -(PAD * 2), 0, 13)
    TitleLabel.ZIndex = 402
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = titleText
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 11
    TitleLabel.TextTransparency = 0.15
    TitleLabel.TextTruncate = Enum.TextTruncate.AtEnd
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local KeyBox = Instance.new('Frame')
    local KeyBoxCorner = Instance.new('UICorner')
    local KeyBoxStroke = Instance.new('UIStroke')
    local KeyText = Instance.new('TextLabel')

    KeyBox.Name = NeverLose.RandomString()
    KeyBox.Parent = BindMenu
    KeyBox.BackgroundColor3 = Color3.fromRGB(26, 28, 36)
    KeyBox.BorderSizePixel = 0
    KeyBox.ClipsDescendants = true
    KeyBox.Position = UDim2.new(0, PAD, 0, ROW_Y)
    KeyBox.Size = UDim2.new(0, KEY_W, 0, ROW_H)
    KeyBox.ZIndex = 402
    KeyBoxCorner.CornerRadius = UDim.new(0, 4)
    KeyBoxCorner.Parent = KeyBox
    KeyBoxStroke.Transparency = 0.65
    KeyBoxStroke.Color = Color3.fromRGB(45, 48, 58)
    KeyBoxStroke.Parent = KeyBox
    KeyText.Name = NeverLose.RandomString()
    KeyText.Parent = KeyBox
    KeyText.AnchorPoint = Vector2.new(0.5, 0.5)
    KeyText.BackgroundTransparency = 1
    KeyText.ClipsDescendants = true
    KeyText.Position = UDim2.new(0.5, 0, 0.5, 0)
    KeyText.Size = UDim2.new(1, 0, 1, 0)
    KeyText.ZIndex = 403
    KeyText.Font = Enum.Font.GothamMedium
    KeyText.Text = 'None'
    KeyText.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyText.TextSize = 10
    KeyText.TextTransparency = 0.4
    KeyText.TextTruncate = Enum.TextTruncate.AtEnd
    KeyText.TextXAlignment = Enum.TextXAlignment.Center

    local RemoveIcon = Instance.new('TextButton')

    RemoveIcon.Name = NeverLose.RandomString()
    RemoveIcon.Parent = BindMenu
    RemoveIcon.BackgroundTransparency = 1
    RemoveIcon.AutoButtonColor = false
    RemoveIcon.AnchorPoint = Vector2.new(0, 0.5)
    RemoveIcon.Position = UDim2.new(1, -(PAD + DEL_W), 0, ROW_Y + (ROW_H / 2))
    RemoveIcon.Size = UDim2.new(0, DEL_W, 0, DEL_W)
    RemoveIcon.ZIndex = 403
    RemoveIcon.FontFace = NeverLose.BuiltInBold
    RemoveIcon.Text = 'trash-can'
    RemoveIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
    RemoveIcon.TextSize = 12
    RemoveIcon.TextTransparency = 0.4

    local ModeDropdown
    local ModeListFrame
    local CloseModeMenu
    local menuOpen = false

    KeybindData.UpdateText = function()
        if KeybindData.Key then
            KeyText.Text = NeverLose:KeyCodeToStr(KeybindData.Key)
        else
            KeyText.Text = 'None'
        end
    end

    if hasMode then
        ModeDropdown = Instance.new('Frame')

        local ModeDropdownCorner = Instance.new('UICorner')
        local ModeDropdownStroke = Instance.new('UIStroke')
        local ModeDropdownIcon = Instance.new('TextLabel')
        local ModeDropdownLabel = Instance.new('TextLabel')

        ModeDropdown.Name = NeverLose.RandomString()
        ModeDropdown.Parent = BindMenu
        ModeDropdown.BackgroundColor3 = Color3.fromRGB(26, 28, 36)
        ModeDropdown.BorderSizePixel = 0
        ModeDropdown.ClipsDescendants = true
        ModeDropdown.Position = UDim2.new(0, PAD + KEY_W + GAP, 0, ROW_Y)
        ModeDropdown.Size = UDim2.new(0, modeWidth, 0, ROW_H)
        ModeDropdown.ZIndex = 402
        ModeDropdownCorner.CornerRadius = UDim.new(0, 4)
        ModeDropdownCorner.Parent = ModeDropdown
        ModeDropdownStroke.Transparency = 0.65
        ModeDropdownStroke.Color = Color3.fromRGB(45, 48, 58)
        ModeDropdownStroke.Parent = ModeDropdown
        ModeDropdownIcon.Name = NeverLose.RandomString()
        ModeDropdownIcon.Parent = ModeDropdown
        ModeDropdownIcon.AnchorPoint = Vector2.new(1, 0.5)
        ModeDropdownIcon.BackgroundTransparency = 1
        ModeDropdownIcon.Position = UDim2.new(1, -3, 0.5, 0)
        ModeDropdownIcon.Size = UDim2.new(0, 12, 0, 12)
        ModeDropdownIcon.ZIndex = 403
        ModeDropdownIcon.FontFace = NeverLose.BuiltInBold
        ModeDropdownIcon.Text = 'chevron-small-down'
        ModeDropdownIcon.TextColor3 = Color3.fromRGB(223, 223, 223)
        ModeDropdownIcon.TextSize = 11
        ModeDropdownIcon.TextTransparency = 0.35
        ModeDropdownLabel.Name = NeverLose.RandomString()
        ModeDropdownLabel.Parent = ModeDropdown
        ModeDropdownLabel.BackgroundTransparency = 1
        ModeDropdownLabel.ClipsDescendants = true
        ModeDropdownLabel.Position = UDim2.new(0, 6, 0, 0)
        ModeDropdownLabel.Size = UDim2.new(1, -19, 1, 0)
        ModeDropdownLabel.ZIndex = 403
        ModeDropdownLabel.Font = Enum.Font.GothamMedium
        ModeDropdownLabel.Text = KeybindData.Mode
        ModeDropdownLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        ModeDropdownLabel.TextSize = 10
        ModeDropdownLabel.TextTransparency = 0.4
        ModeDropdownLabel.TextXAlignment = Enum.TextXAlignment.Left

        local ModeDropdownHandler = Instance.new('Frame')
        local ModeDropdownHandlerCorner = Instance.new('UICorner')
        local ModeDropdownHandlerStroke = Instance.new('UIStroke')
        local ModeDropdownScroll = Instance.new('ScrollingFrame')
        local ModeDropdownList = Instance.new('UIListLayout')
        local ModeShadow = NeverLose:CreateShadow(ModeDropdownHandler)
        local ModeOpenSignal = NeverLose:CreateSignal(false)
        local ModeExtentSize = 0

        ModeDropdownHandler.Name = NeverLose.RandomString()
        ModeDropdownHandler.Parent = NeverLose.ScreenGui
        ModeDropdownHandler.AnchorPoint = Vector2.new(0.5, 0)
        ModeDropdownHandler.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
        ModeDropdownHandler.BackgroundTransparency = 0.5
        ModeDropdownHandler.BorderSizePixel = 0
        ModeDropdownHandler.ClipsDescendants = true
        ModeDropdownHandler.Position = UDim2.new(255, 255, 255, 255)
        ModeDropdownHandler.Size = UDim2.new(0, 70, 0, 55)
        ModeDropdownHandler.ZIndex = 500

        NeverLose:AddSignal(ModeDropdownHandler:GetPropertyChangedSignal('BackgroundTransparency'):Connect(LPH_NO_VIRTUALIZE(function()
            if ModeDropdownHandler.BackgroundTransparency > 0.9 then
                ModeDropdownHandler.Visible = false
                ModeDropdownHandler.Parent = nil
            else
                ModeDropdownHandler.Visible = true

                if NeverLose.Global3DRenderMode then
                    ModeDropdownHandler.Parent = NeverLose.GlobalSurfaceGui
                else
                    ModeDropdownHandler.Parent = NeverLose.ScreenGui
                end
            end
        end)))

        ModeDropdownHandlerCorner.CornerRadius = UDim.new(0, 10)
        ModeDropdownHandlerCorner.Parent = ModeDropdownHandler
        ModeDropdownHandlerStroke.Transparency = 0.65
        ModeDropdownHandlerStroke.Color = Color3.fromRGB(45, 48, 58)
        ModeDropdownHandlerStroke.Parent = ModeDropdownHandler
        ModeDropdownScroll.Name = NeverLose.RandomString()
        ModeDropdownScroll.Parent = ModeDropdownHandler
        ModeDropdownScroll.Active = true
        ModeDropdownScroll.AnchorPoint = Vector2.new(0.5, 0.5)
        ModeDropdownScroll.BackgroundTransparency = 1
        ModeDropdownScroll.BorderSizePixel = 0
        ModeDropdownScroll.Position = UDim2.new(0.5, 0, 0.5, 0)
        ModeDropdownScroll.Size = UDim2.new(1, -5, 1, -5)
        ModeDropdownScroll.ZIndex = 501
        ModeDropdownScroll.ScrollBarThickness = 0
        ModeDropdownList.Parent = ModeDropdownScroll
        ModeDropdownList.HorizontalAlignment = Enum.HorizontalAlignment.Center
        ModeDropdownList.SortOrder = Enum.SortOrder.LayoutOrder

        local function ModeHandlerSize()
            return UDim2.new(0, math.max(ModeDropdown.AbsoluteSize.X, ModeExtentSize + 30), 0, math.min(ModeDropdownList.AbsoluteContentSize.Y + 5, 250))
        end

        NeverLose:AddSignal(ModeDropdownList:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(LPH_NO_VIRTUALIZE(function()
            ModeDropdownScroll.CanvasSize = UDim2.fromOffset(0, ModeDropdownList.AbsoluteContentSize.Y)

            NeverLose.PlayAnimate(ModeDropdownHandler, SlowyTween, {
                Size = ModeHandlerSize(),
            })
        end)))

        local function createModeItem(text)
            local ItemFrame = Instance.new('Frame')
            local ItemLabel = Instance.new('TextLabel')
            local ItemCorner = Instance.new('UICorner')

            ItemFrame.Name = NeverLose.RandomString()
            ItemFrame.Parent = ModeDropdownScroll
            ItemFrame.BackgroundColor3 = Color3.fromRGB(29, 31, 38)
            ItemFrame.BackgroundTransparency = 1
            ItemFrame.BorderSizePixel = 0
            ItemFrame.Size = UDim2.new(1, 0, 0, 25)
            ItemFrame.ZIndex = 502
            ItemLabel.Name = NeverLose.RandomString()
            ItemLabel.Parent = ItemFrame
            ItemLabel.BackgroundTransparency = 1
            ItemLabel.BorderSizePixel = 0
            ItemLabel.Position = UDim2.new(0, 15, 0, 4)
            ItemLabel.Size = UDim2.new(0, 1, 0, 15)
            ItemLabel.ZIndex = 503
            ItemLabel.Font = Enum.Font.GothamMedium
            ItemLabel.Text = text
            ItemLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            ItemLabel.TextSize = 13
            ItemLabel.TextTransparency = 1
            ItemLabel.TextXAlignment = Enum.TextXAlignment.Left
            ItemCorner.CornerRadius = UDim.new(0, 10)
            ItemCorner.Parent = ItemFrame
            ModeExtentSize = math.max(ModeExtentSize, TextService:GetTextSize(text, ItemLabel.TextSize, ItemLabel.Font, Vector2.new(math.huge, math.huge)).X)

            return ItemFrame, ItemLabel
        end

        local ToggleItem, ToggleLabel = createModeItem('Toggle')
        local HoldItem, HoldLabel = createModeItem('Hold')
        local modeItems = {
            {
                Frame = ToggleItem,
                Label = ToggleLabel,
                Mode = 'Toggle',
            },
            {
                Frame = HoldItem,
                Label = HoldLabel,
                Mode = 'Hold',
            },
        }

        local function paintModes()
            for _, item in ipairs(modeItems)do
                if KeybindData.Mode == item.Mode then
                    NeverLose.PlayAnimate(item.Label, SlowyTween, {TextTransparency = 0.2})
                else
                    NeverLose.PlayAnimate(item.Label, SlowyTween, {TextTransparency = 0.5})
                end
            end
        end

        for _, item in ipairs(modeItems)do
            NeverLose:AddSignal(item.Frame.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
                NeverLose.PlayAnimate(item.Frame, SlowyTween, {BackgroundTransparency = 0.1})
            end)))
            NeverLose:AddSignal(item.Frame.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
                NeverLose.PlayAnimate(item.Frame, SlowyTween, {BackgroundTransparency = 1})
            end)))
            NeverLose:AddSignal(ModeOpenSignal:Connect(LPH_NO_VIRTUALIZE(function(value)
                if value then
                    paintModes()
                else
                    NeverLose.PlayAnimate(item.Label, SlowyTween, {TextTransparency = 1})
                end
            end)))
        end

        ModeListFrame = ModeDropdownHandler

        local modeListOpen = false
        local modeOutsideConn = nil

        local function SetModeRender(value)
            modeListOpen = value

            ModeOpenSignal:SetValue(value)

            if value then
                ModeShadow:Render(true)

                ModeDropdownHandler.Size = ModeHandlerSize()

                local absPos = ModeDropdown.AbsolutePosition
                local below = absPos.Y + ModeDropdown.AbsoluteSize.Y + 5

                if NeverLose:MoreThanHalfY(below) then
                    ModeDropdownHandler.AnchorPoint = Vector2.new(0.5, 1)
                    ModeDropdownHandler.Position = UDim2.fromOffset(absPos.X + (ModeDropdown.AbsoluteSize.X / 2), absPos.Y - 5)
                else
                    ModeDropdownHandler.AnchorPoint = Vector2.new(0.5, 0)
                    ModeDropdownHandler.Position = UDim2.fromOffset(absPos.X + (ModeDropdown.AbsoluteSize.X / 2), below)
                end

                NeverLose.PlayAnimate(ModeDropdownHandler, SlowyTween, {BackgroundTransparency = 0.035})
            else
                NeverLose.PlayAnimate(ModeDropdownHandler, SlowyTween, {BackgroundTransparency = 1})
                ModeShadow:Render(false)
            end
        end
        local function CloseModeList()
            if modeOutsideConn then
                modeOutsideConn:Disconnect()

                modeOutsideConn = nil
            end
            if not modeListOpen then
                return
            end

            SetModeRender(false)
        end
        local function OpenModeList()
            if modeOutsideConn then
                modeOutsideConn:Disconnect()

                modeOutsideConn = nil
            end

            SetModeRender(true)

            modeOutsideConn = UserInputService.InputBegan:Connect(LPH_NO_VIRTUALIZE(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    if not NeverLose:IsMouseOverFrame(ModeDropdownHandler) and not NeverLose:IsMouseOverFrame(ModeDropdown) then
                        CloseModeList()
                    end
                end
            end))
        end

        SetModeRender(false)

        CloseModeMenu = CloseModeList

        NeverLose:CreateInput(ModeDropdown, LPH_NO_VIRTUALIZE(function()
            if modeListOpen then
                CloseModeList()
            else
                OpenModeList()
            end
        end))

        for _, item in ipairs(modeItems)do
            NeverLose:CreateInput(item.Frame, LPH_NO_VIRTUALIZE(function()
                KeybindData.Mode = item.Mode
                ModeDropdownLabel.Text = item.Mode

                paintModes()
                CloseModeList()
            end))
        end

        KeybindData.UpdateMode = function()
            ModeDropdownLabel.Text = KeybindData.Mode

            if modeListOpen then
                paintModes()
            end
        end

        NeverLose:AddSignal(ModeDropdown.MouseEnter:Connect(function()
            NeverLose.PlayAnimate(ModeDropdownLabel, SlowyTween, {TextTransparency = 0.15})
        end))
        NeverLose:AddSignal(ModeDropdown.MouseLeave:Connect(function()
            NeverLose.PlayAnimate(ModeDropdownLabel, SlowyTween, {TextTransparency = 0.4})
        end))
    end

    RemoveIcon.MouseEnter:Connect(function()
        NeverLose.PlayAnimate(RemoveIcon, SlowyTween, {TextTransparency = 0})
    end)
    RemoveIcon.MouseLeave:Connect(function()
        NeverLose.PlayAnimate(RemoveIcon, SlowyTween, {TextTransparency = 0.4})
    end)
    RemoveIcon.MouseButton1Click:Connect(function()
        KeybindData.Key = nil
        KeybindData.SliderActive = false
        KeybindData.OriginalValue = nil

        KeybindData.UpdateText()
    end)

    local RefreshSlider

    if hasSlider then
        local sMin = SliderInfo.Min or 0
        local sMax = SliderInfo.Max or 100
        local sRound = SliderInfo.Rounding or 0
        local numW = TextService:GetTextSize(string.rep('0', sRound + #tostring(sMax) + 1), 10, Enum.Font.GothamMedium, Vector2.new(math.huge, math.huge)).X
        local valW = numW + 8
        local SContainer = Instance.new('Frame')

        SContainer.Name = NeverLose.RandomString()
        SContainer.Parent = BindMenu
        SContainer.BackgroundTransparency = 1
        SContainer.Position = UDim2.new(0, PAD, 0, ROW_Y + ROW_H + 7)
        SContainer.Size = UDim2.new(1, -(PAD * 2), 0, 16)
        SContainer.ZIndex = 402

        local ValueFrame = Instance.new('Frame')
        local ValueCorner = Instance.new('UICorner')
        local ValueStroke = Instance.new('UIStroke')
        local SLabel = Instance.new('TextBox')

        ValueFrame.Name = NeverLose.RandomString()
        ValueFrame.Parent = SContainer
        ValueFrame.AnchorPoint = Vector2.new(1, 0.5)
        ValueFrame.BackgroundColor3 = Color3.fromRGB(26, 28, 36)
        ValueFrame.BorderSizePixel = 0
        ValueFrame.ClipsDescendants = true
        ValueFrame.Position = UDim2.new(1, 0, 0.5, 0)
        ValueFrame.Size = UDim2.new(0, valW, 0, 16)
        ValueFrame.ZIndex = 402
        ValueCorner.CornerRadius = UDim.new(0, 4)
        ValueCorner.Parent = ValueFrame
        ValueStroke.Transparency = 0.65
        ValueStroke.Color = Color3.fromRGB(45, 48, 58)
        ValueStroke.Parent = ValueFrame
        SLabel.Name = NeverLose.RandomString()
        SLabel.Parent = ValueFrame
        SLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        SLabel.BackgroundTransparency = 1
        SLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
        SLabel.Size = UDim2.new(1, 0, 1, 0)
        SLabel.ZIndex = 403
        SLabel.Font = Enum.Font.GothamMedium
        SLabel.Text = tostring(KeybindData.SliderValue)
        SLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        SLabel.TextSize = 10
        SLabel.ClearTextOnFocus = false
        SLabel.TextTransparency = 0.35

        local SlideMain = Instance.new('Frame')

        SlideMain.Name = NeverLose.RandomString()
        SlideMain.Parent = SContainer
        SlideMain.AnchorPoint = Vector2.new(0, 0.5)
        SlideMain.BackgroundTransparency = 1
        SlideMain.Position = UDim2.new(0, 0, 0.5, 0)
        SlideMain.Size = UDim2.new(1, -(valW + 8), 0, 16)
        SlideMain.ZIndex = 402

        local SlideFrame = Instance.new('Frame')
        local SlideFrameCorner = Instance.new('UICorner')

        SlideFrame.Name = NeverLose.RandomString()
        SlideFrame.Parent = SlideMain
        SlideFrame.AnchorPoint = Vector2.new(0, 0.5)
        SlideFrame.BackgroundColor3 = Color3.fromRGB(30, 29, 36)
        SlideFrame.BorderSizePixel = 0
        SlideFrame.Position = UDim2.new(0, 0, 0.5, 0)
        SlideFrame.Size = UDim2.new(1, 0, 0, 5)
        SlideFrame.ZIndex = 402
        SlideFrameCorner.CornerRadius = UDim.new(1, 0)
        SlideFrameCorner.Parent = SlideFrame

        local SlideMoving = Instance.new('Frame')
        local SlideMovingCorner = Instance.new('UICorner')

        SlideMoving.Name = NeverLose.RandomString()
        SlideMoving.Parent = SlideFrame

        NeverLose:BindAccent(SlideMoving, 'BackgroundColor3')

        SlideMoving.BorderSizePixel = 0
        SlideMoving.Size = UDim2.new(0, 0, 1, 0)
        SlideMoving.ZIndex = 403
        SlideMovingCorner.CornerRadius = UDim.new(1, 0)
        SlideMovingCorner.Parent = SlideMoving

        local SKnob = Instance.new('Frame')
        local SKnobCorner = Instance.new('UICorner')

        SKnob.Name = NeverLose.RandomString()
        SKnob.Parent = SlideMoving
        SKnob.AnchorPoint = Vector2.new(1, 0.5)
        SKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        SKnob.BorderSizePixel = 0
        SKnob.Position = UDim2.new(1, 5, 0.5, 0)
        SKnob.Size = UDim2.new(0, 10, 0, 10)
        SKnob.ZIndex = 404
        SKnobCorner.CornerRadius = UDim.new(1, 0)
        SKnobCorner.Parent = SKnob
        RefreshSlider = function()
            local scale = 0

            if sMax ~= sMin then
                scale = math.clamp((KeybindData.SliderValue - sMin) / (sMax - sMin), 0, 1)
            end

            SlideMoving.Size = UDim2.new(scale, 0, 1, 0)
            SLabel.Text = tostring(KeybindData.SliderValue)
        end

        local dragging = false

        local function updateSlider(input)
            local scale = math.clamp(((input.Position.X) - SlideMain.AbsolutePosition.X) / SlideMain.AbsoluteSize.X, 0, 1)
            local value = NeverLose.Rounding(sMin + (sMax - sMin) * scale, sRound)

            KeybindData.SliderValue = value

            TweenService:Create(SlideMoving, ManualTween, {
                Size = UDim2.new(scale, 0, 1, 0),
            }):Play()

            SLabel.Text = tostring(value)
        end

        NeverLose:AddSignal(SlideMain.InputBegan:Connect(LPH_NO_VIRTUALIZE(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true

                updateSlider(input)
            end
        end)))
        NeverLose:AddSignal(SlideMain.InputEnded:Connect(LPH_NO_VIRTUALIZE(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)))
        NeverLose:AddSignal(UserInputService.InputChanged:Connect(LPH_NO_VIRTUALIZE(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                updateSlider(input)
            end
        end)))
        SLabel.FocusLost:Connect(LPH_NO_VIRTUALIZE(function()
            local parsed = NeverLose:ParseInput(SLabel.Text, true)

            if parsed then
                local clamped = math.clamp(parsed, sMin, sMax)

                KeybindData.SliderValue = NeverLose.Rounding(clamped, sRound)
            end

            RefreshSlider()
        end))
        RefreshSlider()
    end

    KeybindData.Refresh = function()
        if KeybindData.UpdateMode then
            KeybindData.UpdateMode()
        end

        KeybindData.UpdateText()

        if RefreshSlider then
            RefreshSlider()
        end
    end

    local IsBinding = false

    NeverLose:CreateInput(KeyBox, LPH_NO_VIRTUALIZE(function()
        if IsBinding then
            return
        end

        IsBinding = true
        KeyText.Text = '...'

        local Selected = nil

        while not Selected do
            local Key = UserInputService.InputBegan:Wait()

            if Key.KeyCode ~= Enum.KeyCode.Unknown then
                Selected = Key.KeyCode.Name
            elseif Key.UserInputType == Enum.UserInputType.MouseButton1 then
                Selected = 'MouseLeft'
            elseif Key.UserInputType == Enum.UserInputType.MouseButton2 then
                Selected = 'MouseRight'
            elseif Key.UserInputType == Enum.UserInputType.MouseButton3 then
                Selected = 'MouseMiddle'
            end
        end

        IsBinding = false
        KeybindData.Key = Selected

        KeybindData.UpdateText()
    end))

    local outsideConn = nil

    local function CloseMenu()
        if not menuOpen then
            return
        end

        menuOpen = false
        NeverLose.IsMosueOverOtherFrame = false

        if CloseModeMenu then
            CloseModeMenu()
        end
        if outsideConn then
            outsideConn:Disconnect()

            outsideConn = nil
        end
        if NeverLose.__OpenBindMenu == CloseMenu then
            NeverLose.__OpenBindMenu = nil
        end

        NeverLose.PlayAnimate(BindMenu, SlowyTween, {
            BackgroundTransparency = 1,
            Size = UDim2.new(0, menuWidth, 0, 0),
        })
        NeverLose.PlayAnimate(BindStroke, SlowyTween, {Transparency = 1})
        Shadow:Render(false)
        task.delay(0.2, function()
            if not menuOpen then
                BindMenu.Visible = false
            end
        end)
    end
    local function OpenMenu()
        if NeverLose.__OpenBindMenu and NeverLose.__OpenBindMenu ~= CloseMenu then
            NeverLose.__OpenBindMenu()
        end

        NeverLose.__OpenBindMenu = CloseMenu
        NeverLose.IsMosueOverOtherFrame = true

        KeybindData.Refresh()

        local viewport = CurrentCamera and CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
        local ePos, eSize = Element.AbsolutePosition, Element.AbsoluteSize
        local px = ePos.X + eSize.X + 8

        if px + menuWidth > viewport.X then
            px = ePos.X - menuWidth - 8
        end

        px = math.max(8, px)

        local py = ePos.Y + (eSize.Y / 2) - (menuHeight / 2)

        py = math.clamp(py, 8, math.max(8, viewport.Y - menuHeight - 8))
        BindMenu.Position = UDim2.fromOffset(px, py)
        BindMenu.Size = UDim2.new(0, menuWidth, 0, 0)
        BindMenu.Visible = true
        menuOpen = true

        NeverLose.PlayAnimate(BindMenu, SlowyTween, {
            BackgroundTransparency = 0.035,
            Size = UDim2.new(0, menuWidth, 0, menuHeight),
        })
        NeverLose.PlayAnimate(BindStroke, SlowyTween, {Transparency = 0.65})
        Shadow:Render(true)

        if outsideConn then
            outsideConn:Disconnect()
        end

        outsideConn = UserInputService.InputBegan:Connect(LPH_NO_VIRTUALIZE(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if ModeListFrame and ModeListFrame.Visible and NeverLose:IsMouseOverFrame(ModeListFrame) then
                    return
                end
                if not NeverLose:IsMouseOverFrame(BindMenu) and not NeverLose:IsMouseOverFrame(Element) then
                    CloseMenu()
                end
            end
        end))
    end

    local lastBindToggle = 0

    local function bindRight(frame)
        trackBind(NeverLose:AddSignal(frame.InputBegan:Connect(LPH_NO_VIRTUALIZE(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton2 then
                if os.clock() - lastBindToggle < 0.1 then
                    return
                end

                lastBindToggle = os.clock()

                if menuOpen then
                    CloseMenu()
                else
                    OpenMenu()
                end
            end
        end))))
    end

    bindRight(Element)

    for _, child in next, Element:GetDescendants()do
        if child:IsA('GuiObject') then
            bindRight(child)
        end
    end

    NeverLose:AddSignal(Element.DescendantAdded:Connect(LPH_NO_VIRTUALIZE(function(child)
        if child:IsA('GuiObject') then
            bindRight(child)
        end
    end)))

    if Signal then
        Signal:Connect(LPH_NO_VIRTUALIZE(function(value)
            if not value then
                CloseMenu()
            end
        end))
    end

    local IsHolding = false

    local function matches(input, isTyping)
        local k = KeybindData.Key

        if not k then
            return false
        end
        if k == 'MouseLeft' then
            return input.UserInputType == Enum.UserInputType.MouseButton1
        elseif k == 'MouseRight' then
            return input.UserInputType == Enum.UserInputType.MouseButton2
        elseif k == 'MouseMiddle' then
            return input.UserInputType == Enum.UserInputType.MouseButton3
        end
        if isTyping then
            return false
        end

        local ok, kc = pcall(NeverLose.StrToKeyCode, NeverLose, k)

        if ok and kc then
            return input.KeyCode == kc
        end

        return false
    end

    trackBind(NeverLose:AddSignal(UserInputService.InputBegan:Connect(LPH_NO_VIRTUALIZE(function(input, isTyping)
        if not matches(input, isTyping) then
            return
        end
        if ElementType == 'Button' then
            Callback()

            return
        end
        if KeybindData.Mode == 'Hold' then
            IsHolding = true
            KeybindData.Active = true

            if ElementType == 'Toggle' then
                SetValue(true)
            elseif ElementType == 'Slider' then
                if KeybindData.OriginalValue == nil then
                    KeybindData.OriginalValue = GetValue()
                end

                SetValue(KeybindData.SliderValue)
            end
        else
            if ElementType == 'Toggle' then
                SetValue(not GetValue())
            elseif ElementType == 'Slider' then
                if KeybindData.SliderActive then
                    if KeybindData.OriginalValue ~= nil then
                        SetValue(KeybindData.OriginalValue)

                        KeybindData.OriginalValue = nil
                    end

                    KeybindData.SliderActive = false
                    KeybindData.Active = false
                else
                    KeybindData.OriginalValue = GetValue()

                    SetValue(KeybindData.SliderValue)

                    KeybindData.SliderActive = true
                    KeybindData.Active = true
                end
            end
        end
    end))))
    trackBind(NeverLose:AddSignal(UserInputService.InputEnded:Connect(LPH_NO_VIRTUALIZE(function(input)
        if KeybindData.Mode ~= 'Hold' or not IsHolding then
            return
        end
        if not matches(input, false) then
            return
        end

        IsHolding = false
        KeybindData.Active = false

        if ElementType == 'Toggle' then
            SetValue(false)
        elseif ElementType == 'Slider' then
            if KeybindData.OriginalValue ~= nil then
                SetValue(KeybindData.OriginalValue)

                KeybindData.OriginalValue = nil
            end
        end
    end))))

    return KeybindData
end
function NeverLose:RegisiterHandler(Handler: Frame, Signal)
    local handle = {}
    local ZINdex = Handler.ZIndex

    function handle:AddToggle(Config)
        Config = NeverLose:ProcessParams(Config, {
            Default = false,
            Flag = nil,
            Callback = EmptyFunction,
        })

        local Toggle = Instance.new('Frame')
        local UICorner = Instance.new('UICorner')
        local Circle = Instance.new('Frame')
        local UICorner_2 = Instance.new('UICorner')

        Toggle.Name = NeverLose.RandomString()
        Toggle.Parent = Handler
        Toggle.BackgroundColor3 = Color3.fromRGB(10, 13, 21)
        Toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Toggle.BorderSizePixel = 0
        Toggle.ClipsDescendants = true
        Toggle.Size = UDim2.new(0, 30, 0, 18)
        Toggle.ZIndex = ZINdex + 13
        Toggle.LayoutOrder = -(#Handler:GetChildren() + 5)
        UICorner.CornerRadius = UDim.new(1, 0)
        UICorner.Parent = Toggle
        Circle.Name = NeverLose.RandomString()
        Circle.Parent = Toggle
        Circle.AnchorPoint = Vector2.new(0.5, 0.5)
        Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Circle.BackgroundTransparency = 0.5
        Circle.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Circle.BorderSizePixel = 0
        Circle.Position = UDim2.new(0.300000012, 0, 0.5, 0)
        Circle.Size = UDim2.new(0, 16, 0, 16)
        Circle.ZIndex = ZINdex + 14
        UICorner_2.CornerRadius = UDim.new(1, 0)
        UICorner_2.Parent = Circle

        local ToggleLib = {Root = Toggle}

        ToggleLib.SetUI = LPH_NO_VIRTUALIZE(function(value)
            if value then
                NeverLose.PlayAnimate(Toggle, SlowyTween, {
                    BackgroundTransparency = 0,
                    BackgroundColor3 = NeverLose.AccentColor,
                })
                NeverLose.PlayAnimate(Circle, SlowyTween, {
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 0,
                    Position = UDim2.new(0.7, 0, 0.5, 0),
                })
            else
                NeverLose.PlayAnimate(Toggle, SlowyTween, {
                    BackgroundTransparency = 0,
                    BackgroundColor3 = Color3.fromRGB(10, 13, 21),
                })
                NeverLose.PlayAnimate(Circle, SlowyTween, {
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 0.5,
                    Position = UDim2.new(0.300000012, 0, 0.5, 0),
                })
            end
        end)
        ToggleLib.SetVisible = LPH_NO_VIRTUALIZE(function(value)
            if value then
                ToggleLib.SetUI(Config.Default)
            else
                NeverLose.PlayAnimate(Toggle, SlowyTween, {
                    BackgroundTransparency = 1,
                    BackgroundColor3 = Color3.fromRGB(10, 13, 21),
                })
                NeverLose.PlayAnimate(Circle, SlowyTween, {
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.300000012, 0, 0.5, 0),
                })
            end
        end)

        ToggleLib.SetUI(Config.Default)
        ToggleLib.SetVisible(Signal:GetValue())
        NeverLose:CreateInput(Toggle, LPH_NO_VIRTUALIZE(function()
            Config.Default = not Config.Default

            ToggleLib.SetUI(Config.Default)
            Config.Callback(Config.Default)
        end))

        ToggleLib.Signal = Signal:Connect(ToggleLib.SetVisible)

        function ToggleLib:GetValue()
            return Config.Default
        end
        function ToggleLib:SetValue(v)
            Config.Default = v

            if Signal:GetValue() then
                ToggleLib.SetUI(Config.Default)
            end

            Config.Callback(Config.Default)
        end

        local BindName = handle.DisplayName

        if type(BindName) ~= 'string' or BindName == '' then
            BindName = Config.Flag or 'Keybind'
        end

        NeverLose:CreateElementKeybind(Handler.Parent or Toggle, 'Toggle', function()
            return ToggleLib:GetValue()
        end, function(v)
            ToggleLib:SetValue(v)
        end, EmptyFunction, Config.Flag, BindName, Signal)

        if Config.Flag then
            NeverLose.Flags[Config.Flag] = ToggleLib
        end

        return ToggleLib
    end
    function handle:AddSlider(Config)
        Config = NeverLose:ProcessParams(Config, {
            Default = 50,
            Min = 0,
            Max = 10,
            Type = '',
            Rounding = 0,
            Nums = {},
            Flag = nil,
            Size = 125,
            Callback = EmptyFunction,
        })

        local SliderLib = {}

        SliderLib.GetSize = LPH_NO_VIRTUALIZE(function()
            return (Config.Default - Config.Min) / (Config.Max - Config.Min)
        end)

        local FullNumSize = TextService:GetTextSize(string.rep('0', (Config.Rounding + #tostring(Config.Max)) + 1) .. tostring(Config.Type), 10, Enum.Font.GothamMedium, Vector2.new(math.huge, math.huge))

        SliderLib.MaximumSize = FullNumSize.X

        if Config.Nums then
            local nszie = 0

            for i, ns in next, Config.Nums do
                local size = TextService:GetTextSize(string.rep('m', string.len(tostring(ns))), 10, Enum.Font.GothamMedium, Vector2.new(math.huge, math.huge))

                if nszie < size.X then
                    nszie = size.X
                end
            end

            if SliderLib.MaximumSize < nszie then
                SliderLib.MaximumSize = nszie
            end
        end

        local Slider = Instance.new('Frame')
        local UICorner = Instance.new('UICorner')
        local ValueFrame = Instance.new('Frame')
        local UICorner_2 = Instance.new('UICorner')
        local UIStroke = Instance.new('UIStroke')
        local ValueLabel = Instance.new('TextBox')
        local SlideMain = Instance.new('Frame')
        local SlideFrame = Instance.new('Frame')
        local UICorner_3 = Instance.new('UICorner')
        local SlideMoving = Instance.new('Frame')
        local UICorner_4 = Instance.new('UICorner')
        local Frame = Instance.new('Frame')
        local UICorner_5 = Instance.new('UICorner')
        local boxSize = 2

        Slider.Name = NeverLose.RandomString()
        Slider.Parent = Handler
        Slider.BackgroundColor3 = Color3.fromRGB(26, 28, 36)
        Slider.BackgroundTransparency = 1
        Slider.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Slider.BorderSizePixel = 0
        Slider.ClipsDescendants = false
        Slider.Size = UDim2.new(0, Config.Size, 0, 18)
        Slider.ZIndex = ZINdex + 13
        Slider.LayoutOrder = -(#Handler:GetChildren() + 5)
        UICorner.CornerRadius = UDim.new(0, 4)
        UICorner.Parent = Slider
        ValueFrame.Name = NeverLose.RandomString()
        ValueFrame.Parent = Slider
        ValueFrame.AnchorPoint = Vector2.new(1, 0)
        ValueFrame.BackgroundColor3 = Color3.fromRGB(26, 28, 36)
        ValueFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
        ValueFrame.BorderSizePixel = 0
        ValueFrame.ClipsDescendants = true
        ValueFrame.Position = UDim2.new(1, 0, 0, 0)
        ValueFrame.Size = UDim2.new(0, SliderLib.MaximumSize + boxSize, 0, 18)
        ValueFrame.ZIndex = ZINdex + 13
        UICorner_2.CornerRadius = UDim.new(0, 4)
        UICorner_2.Parent = ValueFrame
        UIStroke.Transparency = 0.65
        UIStroke.Color = Color3.fromRGB(45, 48, 58)
        UIStroke.Parent = ValueFrame
        ValueLabel.Name = NeverLose.RandomString()
        ValueLabel.Parent = ValueFrame
        ValueLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        ValueLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ValueLabel.BackgroundTransparency = 1
        ValueLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
        ValueLabel.BorderSizePixel = 0
        ValueLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
        ValueLabel.Size = UDim2.new(1, 0, 1, 0)
        ValueLabel.ZIndex = ZINdex + 14
        ValueLabel.Font = Enum.Font.GothamMedium
        ValueLabel.Text = tostring(Config.Default) .. tostring(Config.Type)
        ValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        ValueLabel.TextSize = 10
        ValueLabel.ClearTextOnFocus = false
        ValueLabel.TextTransparency = 0.35
        SlideMain.Name = NeverLose.RandomString()
        SlideMain.Parent = Slider
        SlideMain.AnchorPoint = Vector2.new(0, 0.5)
        SlideMain.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        SlideMain.BackgroundTransparency = 1
        SlideMain.BorderColor3 = Color3.fromRGB(0, 0, 0)
        SlideMain.BorderSizePixel = 0
        SlideMain.Position = UDim2.new(0, 0, 0.5, 0)
        SlideMain.Size = UDim2.new(1, -((SliderLib.MaximumSize + 11)), 0, 18)
        SlideMain.ZIndex = ZINdex + 13
        SlideFrame.Name = NeverLose.RandomString()
        SlideFrame.Parent = SlideMain
        SlideFrame.AnchorPoint = Vector2.new(0, 0.5)
        SlideFrame.BackgroundColor3 = Color3.fromRGB(30, 29, 36)
        SlideFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
        SlideFrame.BorderSizePixel = 0
        SlideFrame.Position = UDim2.new(0, 0, 0.5, 0)
        SlideFrame.Size = UDim2.new(1, 0, 0, 5)
        SlideFrame.ZIndex = ZINdex + 13
        UICorner_3.CornerRadius = UDim.new(1, 0)
        UICorner_3.Parent = SlideFrame
        SlideMoving.Name = NeverLose.RandomString()
        SlideMoving.Parent = SlideFrame

        NeverLose:BindAccent(SlideMoving, 'BackgroundColor3')

        SlideMoving.BorderColor3 = Color3.fromRGB(0, 0, 0)
        SlideMoving.BorderSizePixel = 0
        SlideMoving.Size = UDim2.new(SliderLib.GetSize(), 0, 1, 0)
        SlideMoving.ZIndex = ZINdex + 14
        UICorner_4.CornerRadius = UDim.new(1, 0)
        UICorner_4.Parent = SlideMoving
        Frame.Parent = SlideMoving
        Frame.AnchorPoint = Vector2.new(1, 0.5)
        Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Frame.BorderSizePixel = 0
        Frame.Position = UDim2.new(1, 5, 0.5, 0)
        Frame.Size = UDim2.new(0, 10, 0, 10)
        Frame.ZIndex = ZINdex + 15
        UICorner_5.CornerRadius = UDim.new(1, 0)
        UICorner_5.Parent = Frame

        local LoadText = LPH_NO_VIRTUALIZE(function()
            if Config.Nums[Config.Default] then
                ValueLabel.Text = Config.Nums[Config.Default]
            else
                ValueLabel.Text = tostring(Config.Default) .. tostring(Config.Type)
            end
        end)

        ValueLabel.FocusLost:Connect(LPH_NO_VIRTUALIZE(function()
            local OutVal = NeverLose:ParseInput(ValueLabel.Text, true)

            if OutVal then
                local rx = math.clamp(OutVal, Config.Min, Config.Max)
                local Value = NeverLose.Rounding(rx, Config.Rounding)

                if Value then
                    Config.Default = Value

                    TweenService:Create(SlideMoving, ManualTween, {
                        Size = UDim2.new(SliderLib.GetSize(), 0, 1, 0),
                    }):Play()
                    LoadText()
                    Config.Callback(Config.Default)
                else
                    LoadText()
                end
            else
                LoadText()
            end
        end))

        SliderLib.SetRender = LPH_NO_VIRTUALIZE(function(value)
            if value then
                NeverLose.PlayAnimate(ValueFrame, SlowyTween, {
                    BackgroundTransparency = 0,
                    Size = UDim2.new(0, SliderLib.MaximumSize + boxSize, 0, 18),
                })
                NeverLose.PlayAnimate(UIStroke, SlowyTween, {Transparency = 0.65})
                NeverLose.PlayAnimate(ValueLabel, SlowyTween, {TextTransparency = 0.35})
                NeverLose.PlayAnimate(SlideFrame, SlowyTween, {BackgroundTransparency = 0})
                NeverLose.PlayAnimate(SlideMoving, SlowyTween, {
                    BackgroundTransparency = 0,
                    Size = UDim2.new(SliderLib.GetSize(), 0, 1, 0),
                })
                NeverLose.PlayAnimate(Frame, SlowyTween, {BackgroundTransparency = 0})
            else
                NeverLose.PlayAnimate(ValueFrame, SlowyTween, {BackgroundTransparency = 1})
                NeverLose.PlayAnimate(UIStroke, SlowyTween, {Transparency = 1})
                NeverLose.PlayAnimate(ValueLabel, SlowyTween, {TextTransparency = 1})
                NeverLose.PlayAnimate(SlideFrame, SlowyTween, {BackgroundTransparency = 1})
                NeverLose.PlayAnimate(SlideMoving, SlowyTween, {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 0, 1, 0),
                })
                NeverLose.PlayAnimate(Frame, SlowyTween, {BackgroundTransparency = 1})
            end
        end)

        SliderLib.SetRender(Signal:GetValue())

        SliderLib.Signal = Signal:Connect(SliderLib.SetRender)

        local Update = function(Input)
            local SizeScale = math.clamp((((Input.Position.X) - SlideMain.AbsolutePosition.X) / SlideMain.AbsoluteSize.X), 0, 1)
            local Main = ((Config.Max - Config.Min) * SizeScale) + Config.Min
            local Value = NeverLose.Rounding(Main, Config.Rounding)
            local PositionX = UDim2.fromScale(SizeScale, 1)
            local Size = ((Value - Config.Min) / (Config.Max - Config.Min)) + 0.02

            Config.Default = Value

            TweenService:Create(SlideMoving, ManualTween, {
                Size = UDim2.new(SliderLib.GetSize(), 0, 1, 0),
            }):Play()
            LoadText()
            Config.Callback(Value)
        end
        local IsHold = false

        do
            SlideMain.InputBegan:Connect(LPH_NO_VIRTUALIZE(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    IsHold = true

                    Update(Input)
                end
            end))
            SlideMain.InputEnded:Connect(LPH_NO_VIRTUALIZE(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    if UserInputService.TouchEnabled then
                        if not NeverLose:IsMouseOverFrame(SlideMain) then
                            IsHold = false
                        end
                    else
                        IsHold = false
                    end
                end
            end))
            UserInputService.InputChanged:Connect(LPH_NO_VIRTUALIZE(function(Input)
                if IsHold then
                    if (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
                        if UserInputService.TouchEnabled then
                            if not NeverLose:IsMouseOverFrame(SlideMain) then
                                IsHold = false
                            else
                                Update(Input)
                            end
                        else
                            Update(Input)
                        end
                    end
                end
            end))
        end

        function SliderLib:GetValue()
            return Config.Default
        end
        function SliderLib:SetValue(v)
            Config.Default = v

            if Signal:GetValue() then
                NeverLose.PlayAnimate(SlideMoving, SlowyTween, {
                    BackgroundTransparency = 0,
                    Size = UDim2.new(SliderLib.GetSize(), 0, 1, 0),
                })
            end

            LoadText()
            Config.Callback(Config.Default)
        end

        local BindName = handle.DisplayName

        if type(BindName) ~= 'string' or BindName == '' then
            BindName = Config.Flag or 'Keybind'
        end

        NeverLose:CreateElementKeybind(Handler.Parent or Slider, 'Slider', function()
            return SliderLib:GetValue()
        end, function(v)
            SliderLib:SetValue(v)
        end, EmptyFunction, Config.Flag, BindName, Signal, {
            Min = Config.Min,
            Max = Config.Max,
            Rounding = Config.Rounding,
        })

        if Config.Flag then
            NeverLose.Flags[Config.Flag] = SliderLib
        end

        return SliderLib
    end
    function handle:AddOption(GearIcon)
        local Option = Instance.new('Frame')
        local Icon = Instance.new('TextLabel')
        local UICorner = Instance.new('UICorner')

        Option.Name = NeverLose.RandomString()
        Option.Parent = Handler
        Option.BackgroundColor3 = Color3.fromRGB(39, 40, 49)
        Option.BackgroundTransparency = 1
        Option.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Option.BorderSizePixel = 0
        Option.ClipsDescendants = true
        Option.Size = UDim2.new(0, 20, 0, 18)
        Option.ZIndex = ZINdex + 13
        Option.LayoutOrder = -(#Handler:GetChildren() + 5)
        Icon.Name = NeverLose.RandomString()
        Icon.Parent = Option
        Icon.AnchorPoint = Vector2.new(0.5, 0.5)
        Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Icon.BackgroundTransparency = 1
        Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Icon.BorderSizePixel = 0
        Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
        Icon.Size = UDim2.new(1, 0, 1, 0)
        Icon.ZIndex = ZINdex + 14
        Icon.FontFace = NeverLose.BuiltInBold
        Icon.Text = (GearIcon == 1 and 'gear') or (GearIcon == 2 and 'chevron-large-right') or 'three-dots-horizontal'
        Icon.TextColor3 = Color3.fromRGB(223, 223, 223)
        Icon.TextSize = 16
        Icon.TextTransparency = 0.4
        Icon.TextWrapped = true
        UICorner.CornerRadius = UDim.new(0, 4)
        UICorner.Parent = Option

        local Window = NeverLose:CreateOptionWindow(Option, ZINdex + 13)
        local reciveSignal

        Window.SetRender = LPH_NO_VIRTUALIZE(function(value)
            if value then
                NeverLose.PlayAnimate(Icon, SlowyTween, {TextTransparency = 0.4})
            else
                NeverLose.PlayAnimate(Icon, SlowyTween, {TextTransparency = 1})
            end
        end)

        Window.SetRender(Signal:GetValue())
        Signal:Connect(Window.SetRender)
        Signal:Connect(LPH_NO_VIRTUALIZE(function(value)
            if not value then
                if reciveSignal then
                    reciveSignal:Disconnect()

                    reciveSignal = nil
                end

                Window.Signal:SetValue(false)
            end
        end))

        local bthg = NeverLose:CreateInput(Option, LPH_NO_VIRTUALIZE(function()
            if reciveSignal then
                reciveSignal:Disconnect()

                reciveSignal = nil
            end

            Window.Signal:SetValue(true)

            reciveSignal = UserInputService.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    if not NeverLose:IsMouseOverFrame(Window.Root) and not NeverLose:IsMouseOverFrame(Option) and not NeverLose.IsMosueOverOtherFrame then
                        if reciveSignal then
                            reciveSignal:Disconnect()

                            reciveSignal = nil
                        end

                        Window.Signal:SetValue(false)
                    end
                end
            end)
        end))

        NeverLose:AddSignal(bthg.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
            NeverLose.PlayAnimate(Option, SlowyTween, {BackgroundTransparency = 0.5})
            NeverLose.PlayAnimate(Icon, SlowyTween, {TextTransparency = 0.25})
        end)))
        NeverLose:AddSignal(bthg.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
            NeverLose.PlayAnimate(Option, SlowyTween, {BackgroundTransparency = 1})
            NeverLose.PlayAnimate(Icon, SlowyTween, {TextTransparency = 0.4})
        end)))

        return Window
    end
    function handle:AddColorPicker(Config)
        Config = NeverLose:ProcessParams(Config, {
            Default = Color3.fromRGB(255, 255, 255),
            Callback = EmptyFunction,
        })

        if typeof(Config.Default) == 'string' then
            Config.Default = Color3.fromHex(Config.Default:gsub('#', ''))
        end

        local ColorPickerLib = {}
        local ColorPicker = Instance.new('Frame')
        local UICorner = Instance.new('UICorner')
        local UIStroke = Instance.new('UIStroke')
        local ImageLabel = Instance.new('ImageLabel')
        local UICorner_2 = Instance.new('UICorner')

        ColorPicker.Name = NeverLose.RandomString()
        ColorPicker.Parent = Handler
        ColorPicker.BackgroundColor3 = Config.Default
        ColorPicker.BackgroundTransparency = 0
        ColorPicker.BorderColor3 = Color3.fromRGB(0, 0, 0)
        ColorPicker.BorderSizePixel = 0
        ColorPicker.ClipsDescendants = true
        ColorPicker.Size = UDim2.new(0, 18, 0, 18)
        ColorPicker.ZIndex = ZINdex + 13
        ColorPicker.LayoutOrder = -(#Handler:GetChildren() + 5)
        UICorner.CornerRadius = UDim.new(0, 4)
        UICorner.Parent = ColorPicker
        UIStroke.Transparency = 0.65
        UIStroke.Color = Color3.fromRGB(45, 48, 58)
        UIStroke.Parent = ColorPicker
        ImageLabel.Parent = ColorPicker
        ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
        ImageLabel.BorderSizePixel = 0
        ImageLabel.Size = UDim2.new(1, 0, 1, 0)
        ImageLabel.ZIndex = ZINdex + 11
        ImageLabel.Image = 'rbxasset://textures/meshPartFallback.png'
        ImageLabel.ImageTransparency = 0.9
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.ScaleType = Enum.ScaleType.Crop
        UICorner_2.CornerRadius = UDim.new(0, 4)
        UICorner_2.Parent = ImageLabel

        local BackendM = NeverLose:CreateColorPicker(ColorPicker)

        BackendM:SetValue(Config.Default)

        BackendM.Callback = function(color)
            ColorPicker.BackgroundColor3 = color
            Config.Default = color

            Config.Callback(Config.Default)
        end

        local signal

        NeverLose:CreateInput(ColorPicker, LPH_NO_VIRTUALIZE(function()
            if signal then
                signal:Disconnect()

                signal = nil
            end

            BackendM.SetRender(true)

            NeverLose.IsMosueOverOtherFrame = true
            signal = UserInputService.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    if not NeverLose:IsMouseOverFrame(ColorPicker) and not NeverLose:IsMouseOverFrame(BackendM.Root) then
                        if signal then
                            signal:Disconnect()

                            signal = nil
                        end

                        NeverLose.IsMosueOverOtherFrame = false

                        BackendM.SetRender(false)
                    end
                end
            end)
        end))
        Signal:Connect(LPH_NO_VIRTUALIZE(function(value)
            if not value then
                if signal then
                    signal:Disconnect()

                    signal = nil
                end

                NeverLose.IsMosueOverOtherFrame = false

                BackendM.SetRender(false)
            end
        end))

        ColorPickerLib.SetRender = LPH_NO_VIRTUALIZE(function(value)
            if value then
                NeverLose.PlayAnimate(ColorPicker, SlowyTween, {BackgroundTransparency = 0})
                NeverLose.PlayAnimate(UIStroke, SlowyTween, {Transparency = 0.65})
                NeverLose.PlayAnimate(ImageLabel, SlowyTween, {ImageTransparency = 0.9})
            else
                NeverLose.PlayAnimate(ColorPicker, SlowyTween, {BackgroundTransparency = 1})
                NeverLose.PlayAnimate(UIStroke, SlowyTween, {Transparency = 1})
                NeverLose.PlayAnimate(ImageLabel, SlowyTween, {ImageTransparency = 1})
            end
        end)

        ColorPickerLib.SetRender(Signal:GetValue())
        Signal:Connect(ColorPickerLib.SetRender)

        function ColorPickerLib:GetValue()
            return Config.Default
        end
        function ColorPickerLib:SetValue(v)
            Config.Default = v

            BackendM:SetValue(Config.Default)
        end

        if Config.Flag then
            NeverLose.Flags[Config.Flag] = ColorPickerLib
        end

        return ColorPickerLib
    end
    function handle:AddKeybind(Config)
        Config = NeverLose:ProcessParams(Config, {
            Default = nil,
            Blacklist = {},
            Callback = EmptyFunction,
            Flag = nil,
        })

        local KeybindLib = {}
        local Keybind = Instance.new('Frame')
        local UICorner = Instance.new('UICorner')
        local UIStroke = Instance.new('UIStroke')
        local ValueLabel = Instance.new('TextLabel')

        Keybind.Name = NeverLose.RandomString()
        Keybind.Parent = Handler
        Keybind.BackgroundColor3 = Color3.fromRGB(26, 28, 36)
        Keybind.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Keybind.BorderSizePixel = 0
        Keybind.ClipsDescendants = true
        Keybind.Size = UDim2.new(0, 45, 0, 18)
        Keybind.ZIndex = ZINdex + 13
        Keybind.LayoutOrder = -(#Handler:GetChildren() + 5)
        UICorner.CornerRadius = UDim.new(0, 4)
        UICorner.Parent = Keybind
        UIStroke.Transparency = 0.65
        UIStroke.Color = Color3.fromRGB(45, 48, 58)
        UIStroke.Parent = Keybind
        ValueLabel.Name = NeverLose.RandomString()
        ValueLabel.Parent = Keybind
        ValueLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        ValueLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ValueLabel.BackgroundTransparency = 1
        ValueLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
        ValueLabel.BorderSizePixel = 0
        ValueLabel.ClipsDescendants = true
        ValueLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
        ValueLabel.Size = UDim2.new(1, 0, 1, 0)
        ValueLabel.ZIndex = ZINdex + 14
        ValueLabel.Font = Enum.Font.GothamMedium
        ValueLabel.Text = NeverLose:KeyCodeToStr(Config.Default or 'None')
        ValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        ValueLabel.TextSize = 10
        ValueLabel.TextTransparency = 0.5
        KeybindLib.SetRender = LPH_NO_VIRTUALIZE(function(value)
            if value then
                NeverLose.PlayAnimate(Keybind, SlowyTween, {BackgroundTransparency = 0})
                NeverLose.PlayAnimate(UIStroke, SlowyTween, {Transparency = 0.65})
                NeverLose.PlayAnimate(ValueLabel, SlowyTween, {TextTransparency = 0.5})
            else
                NeverLose.PlayAnimate(Keybind, SlowyTween, {BackgroundTransparency = 1})
                NeverLose.PlayAnimate(UIStroke, SlowyTween, {Transparency = 1})
                NeverLose.PlayAnimate(ValueLabel, SlowyTween, {TextTransparency = 1})
            end
        end)

        function KeybindLib:Update()
            local size = TextService:GetTextSize(ValueLabel.Text, ValueLabel.TextSize, ValueLabel.Font, Vector2.new(math.huge, math.huge))

            NeverLose.PlayAnimate(Keybind, SlowyTween, {
                Size = UDim2.new(0, size.X + 7, 0, 18),
            })
        end

        local IsBlacklist = LPH_NO_VIRTUALIZE(function(v)
            return Config.Blacklist and (Config.Blacklist[v] or table.find(Config.Blacklist, v))
        end)

        KeybindLib:Update()
        KeybindLib.SetRender(Signal:GetValue())
        Signal:Connect(KeybindLib.SetRender)

        local IsBinding = false

        NeverLose:CreateInput(Keybind, function()
            if IsBinding then
                return
            end

            IsBinding = true
            ValueLabel.Text = '...'

            KeybindLib:Update()

            local Selected = nil

            while not Selected do
                local Key = UserInputService.InputBegan:Wait()

                if Key.KeyCode ~= Enum.KeyCode.Unknown and not IsBlacklist(Key.KeyCode) and not IsBlacklist(Key.KeyCode.Name) then
                    Selected = Key.KeyCode
                else
                    if Key.UserInputType == Enum.UserInputType.MouseButton1 and not IsBlacklist(Enum.UserInputType.MouseButton1) and not IsBlacklist('M1B') then
                        Selected = 'M1B'
                    elseif Key.UserInputType == Enum.UserInputType.MouseButton2 and not IsBlacklist(Enum.UserInputType.MouseButton2) and not IsBlacklist('M2B') then
                        Selected = 'M2B'
                    end
                end
            end

            IsBinding = false

            local KeyName = typeof(Selected) == 'string' and Selected or Selected.Name

            Config.Default = KeyName
            ValueLabel.Text = NeverLose:KeyCodeToStr(KeyName)

            KeybindLib:Update()
            Config.Callback(KeyName)
        end)

        function KeybindLib:GetValue()
            return Config.Default
        end
        function KeybindLib:SetValue(v)
            Config.Default = v
            ValueLabel.Text = NeverLose:KeyCodeToStr(v)

            KeybindLib:Update()
            Config.Callback(Config.Default)
        end

        if Config.Flag then
            NeverLose.Flags[Config.Flag] = KeybindLib
        end

        return KeybindLib
    end
    function handle:AddTextInput(Config)
        Config = NeverLose:ProcessParams(Config, {
            Default = '',
            Placeholder = 'Placeholder',
            Callback = print,
            Flag = nil,
            Size = 100,
            Numeric = false,
        })

        local TextBoxLib = {}
        local TextInput = Instance.new('Frame')
        local UICorner = Instance.new('UICorner')
        local UIStroke = Instance.new('UIStroke')
        local TextBox = Instance.new('TextBox')

        TextInput.Name = NeverLose.RandomString()
        TextInput.Parent = Handler
        TextInput.BackgroundColor3 = Color3.fromRGB(26, 28, 36)
        TextInput.BorderColor3 = Color3.fromRGB(0, 0, 0)
        TextInput.BorderSizePixel = 0
        TextInput.ClipsDescendants = true
        TextInput.Size = UDim2.new(0, Config.Size, 0, 18)
        TextInput.ZIndex = ZINdex + 13
        TextInput.LayoutOrder = -(#Handler:GetChildren() + 5)
        UICorner.CornerRadius = UDim.new(0, 4)
        UICorner.Parent = TextInput
        UIStroke.Transparency = 0.65
        UIStroke.Color = Color3.fromRGB(45, 48, 58)
        UIStroke.Parent = TextInput
        TextBox.Parent = TextInput
        TextBox.AnchorPoint = Vector2.new(0, 0.5)
        TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TextBox.BackgroundTransparency = 1
        TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
        TextBox.BorderSizePixel = 0
        TextBox.Position = UDim2.new(0, 5, 0.5, 0)
        TextBox.Size = UDim2.new(1, -5, 0, 17)
        TextBox.ZIndex = ZINdex + 14
        TextBox.ClearTextOnFocus = false
        TextBox.Font = Enum.Font.GothamMedium
        TextBox.PlaceholderText = Config.Placeholder
        TextBox.Text = tostring(Config.Default)
        TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextBox.TextSize = 11
        TextBox.TextTransparency = 0.35
        TextBox.TextXAlignment = Enum.TextXAlignment.Left
        TextBoxLib.SetRender = LPH_NO_VIRTUALIZE(function(value)
            if value then
                NeverLose.PlayAnimate(TextInput, SlowyTween, {BackgroundTransparency = 0})
                NeverLose.PlayAnimate(UIStroke, SlowyTween, {Transparency = 0.65})
                NeverLose.PlayAnimate(TextBox, SlowyTween, {TextTransparency = 0.35})
            else
                NeverLose.PlayAnimate(TextInput, SlowyTween, {BackgroundTransparency = 1})
                NeverLose.PlayAnimate(UIStroke, SlowyTween, {Transparency = 1})
                NeverLose.PlayAnimate(TextBox, SlowyTween, {TextTransparency = 1})
            end
        end)

        NeverLose:AddSignal(TextBox:GetPropertyChangedSignal('Text'):Connect(LPH_NO_VIRTUALIZE(function()
            local valout = NeverLose:ParseInput(TextBox.Text, Config.Numeric)

            if Config.Numeric then
                TextBox.Text = string.gsub(TextBox.Text, '[^0-9.]', '')
            end
            if valout then
                Config.Default = valout

                Config.Callback(valout)
            end
        end)))
        TextBoxLib.SetRender(Signal:GetValue())
        Signal:Connect(TextBoxLib.SetRender)

        function TextBoxLib:GetValue()
            return Config.Default
        end
        function TextBoxLib:SetValue(v)
            Config.Default = v
            TextBox.Text = tostring(v)

            Config.Callback(Config.Default)
        end

        if Config.Flag then
            NeverLose.Flags[Config.Flag] = TextBoxLib
        end

        return TextBoxLib
    end
    function handle:AddDropdown(Config)
        Config = NeverLose:ProcessParams(Config, {
            Default = nil,
            Values = {},
            Multi = false,
            Callback = EmptyFunction,
            AutoUpdate = false,
            Flag = nil,
            Size = 100,
        })
        Config.Default = NeverLose.ProcessDropdown(Config.Default)

        local Dropdown = Instance.new('Frame')
        local DropdownIcon = Instance.new('TextLabel')
        local UICorner = Instance.new('UICorner')
        local UIStroke = Instance.new('UIStroke')
        local BasedLabel = Instance.new('TextLabel')

        Dropdown.Name = NeverLose.RandomString()
        Dropdown.Parent = Handler
        Dropdown.BackgroundColor3 = Color3.fromRGB(26, 28, 36)
        Dropdown.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Dropdown.BorderSizePixel = 0
        Dropdown.ClipsDescendants = true
        Dropdown.Size = UDim2.new(0, Config.Size, 0, 18)
        Dropdown.ZIndex = ZINdex + 13
        Dropdown.LayoutOrder = -(#Handler:GetChildren() + 5)
        DropdownIcon.Name = NeverLose.RandomString()
        DropdownIcon.Parent = Dropdown
        DropdownIcon.AnchorPoint = Vector2.new(1, 0.5)
        DropdownIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        DropdownIcon.BackgroundTransparency = 1
        DropdownIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
        DropdownIcon.BorderSizePixel = 0
        DropdownIcon.Position = UDim2.new(1, -2, 0.5, 0)
        DropdownIcon.Size = UDim2.new(0, 18, 0, 18)
        DropdownIcon.ZIndex = ZINdex + 14
        DropdownIcon.FontFace = NeverLose.BuiltInBold
        DropdownIcon.Text = 'chevron-small-down'
        DropdownIcon.TextColor3 = Color3.fromRGB(223, 223, 223)
        DropdownIcon.TextSize = 16
        DropdownIcon.TextTransparency = 0.25
        DropdownIcon.TextWrapped = true
        UICorner.CornerRadius = UDim.new(0, 4)
        UICorner.Parent = Dropdown
        UIStroke.Transparency = 0.65
        UIStroke.Color = Color3.fromRGB(45, 48, 58)
        UIStroke.Parent = Dropdown
        BasedLabel.Name = NeverLose.RandomString()
        BasedLabel.Parent = Dropdown
        BasedLabel.AnchorPoint = Vector2.new(0, 0.5)
        BasedLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        BasedLabel.BackgroundTransparency = 1
        BasedLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
        BasedLabel.BorderSizePixel = 0
        BasedLabel.ClipsDescendants = true
        BasedLabel.Position = UDim2.new(0, 5, 0.5, 0)
        BasedLabel.Size = UDim2.new(1, -25, 0, 15)
        BasedLabel.ZIndex = ZINdex + 14
        BasedLabel.Font = Enum.Font.GothamMedium
        BasedLabel.Text = NeverLose.ParseDropdown(Config.Default)
        BasedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        BasedLabel.TextSize = 12
        BasedLabel.TextTransparency = 0.5
        BasedLabel.TextXAlignment = Enum.TextXAlignment.Left

        do
            local UIGradient = Instance.new('UIGradient')

            UIGradient.Transparency = NumberSequence.new{
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0.85, 0.23),
                NumberSequenceKeypoint.new(1, 1),
            }
            UIGradient.Parent = BasedLabel
        end

        NeverLose:AddSignal(Dropdown.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
            NeverLose.PlayAnimate(BasedLabel, SlowyTween, {TextTransparency = 0.2})
        end)))
        NeverLose:AddSignal(Dropdown.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
            NeverLose.PlayAnimate(BasedLabel, SlowyTween, {TextTransparency = 0.5})
        end)))

        local DropdownLib = {
            OpenSignal = NeverLose:CreateSignal(false),
            Signals = {},
            Refuse = {},
        }

        DropdownLib.SetRender = LPH_NO_VIRTUALIZE(function(value)
            if value then
                NeverLose.PlayAnimate(Dropdown, SlowyTween, {BackgroundTransparency = 0})
                NeverLose.PlayAnimate(DropdownIcon, SlowyTween, {TextTransparency = 0.25})
                NeverLose.PlayAnimate(UIStroke, SlowyTween, {Transparency = 0.65})
                NeverLose.PlayAnimate(BasedLabel, SlowyTween, {TextTransparency = 0.5})
            else
                NeverLose.PlayAnimate(Dropdown, SlowyTween, {BackgroundTransparency = 1})
                NeverLose.PlayAnimate(DropdownIcon, SlowyTween, {TextTransparency = 1})
                NeverLose.PlayAnimate(UIStroke, SlowyTween, {Transparency = 1})
                NeverLose.PlayAnimate(BasedLabel, SlowyTween, {TextTransparency = 1})
            end
        end)

        DropdownLib.SetRender(Signal:GetValue())
        Signal:Connect(DropdownLib.SetRender)

        DropdownLib.ExtentSize = 0

        do
            local DropdownHandler = Instance.new('Frame')
            local UICorner = Instance.new('UICorner')
            local UIStroke = Instance.new('UIStroke')
            local DropdownScrollFrame = Instance.new('ScrollingFrame')
            local UIListLayout = Instance.new('UIListLayout')
            local Shadow = NeverLose:CreateShadow(DropdownHandler)

            DropdownHandler.Name = NeverLose.RandomString()
            DropdownHandler.Parent = NeverLose.ScreenGui
            DropdownHandler.AnchorPoint = Vector2.new(0.5, 0)
            DropdownHandler.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
            DropdownHandler.BackgroundTransparency = 0.5
            DropdownHandler.BorderColor3 = Color3.fromRGB(0, 0, 0)
            DropdownHandler.BorderSizePixel = 0
            DropdownHandler.ClipsDescendants = true
            DropdownHandler.Position = UDim2.new(255, 255, 255, 255)
            DropdownHandler.Size = UDim2.new(0, 125, 0, 50)
            DropdownHandler.ZIndex = ZINdex + 125
            DropdownLib.BlockRoot = DropdownHandler

            NeverLose:AddSignal(DropdownHandler:GetPropertyChangedSignal('BackgroundTransparency'):Connect(function()
                if DropdownHandler.BackgroundTransparency > 0.9 then
                    DropdownHandler.Visible = false
                    DropdownHandler.Parent = nil
                else
                    DropdownHandler.Visible = true

                    if NeverLose.Global3DRenderMode then
                        DropdownHandler.Parent = NeverLose.GlobalSurfaceGui
                    else
                        DropdownHandler.Parent = NeverLose.ScreenGui
                    end
                end
            end))

            UICorner.CornerRadius = UDim.new(0, 10)
            UICorner.Parent = DropdownHandler
            UIStroke.Transparency = 0.65
            UIStroke.Color = Color3.fromRGB(45, 48, 58)
            UIStroke.Parent = DropdownHandler
            DropdownScrollFrame.Name = NeverLose.RandomString()
            DropdownScrollFrame.Parent = DropdownHandler
            DropdownScrollFrame.Active = true
            DropdownScrollFrame.AnchorPoint = Vector2.new(0.5, 0.5)
            DropdownScrollFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            DropdownScrollFrame.BackgroundTransparency = 1
            DropdownScrollFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
            DropdownScrollFrame.BorderSizePixel = 0
            DropdownScrollFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
            DropdownScrollFrame.Size = UDim2.new(1, -5, 1, -5)
            DropdownScrollFrame.ZIndex = ZINdex + 127
            DropdownScrollFrame.ScrollBarThickness = 0
            DropdownLib.RootItem = DropdownScrollFrame
            UIListLayout.Parent = DropdownScrollFrame
            UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

            NeverLose:AddSignal(UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(LPH_NO_VIRTUALIZE(function()
                DropdownScrollFrame.CanvasSize = UDim2.fromOffset(0, UIListLayout.AbsoluteContentSize.Y)

                NeverLose.PlayAnimate(DropdownHandler, SlowyTween, {
                    Size = UDim2.new(0, (Dropdown.AbsoluteSize.X + 5) + DropdownLib.ExtentSize, 0, math.min(UIListLayout.AbsoluteContentSize.Y + 5, 250)),
                })
            end)))

            local SetPosition = LPH_NO_VIRTUALIZE(function()
                if NeverLose:MoreThanHalfY(Dropdown.AbsolutePosition.Y + 85) then
                    DropdownHandler.AnchorPoint = Vector2.new(0.5, 1)
                else
                    DropdownHandler.AnchorPoint = Vector2.new(0.5, 0)
                end

                DropdownHandler.Position = UDim2.fromOffset(Dropdown.AbsolutePosition.X + (DropdownHandler.AbsoluteSize.X / 2), Dropdown.AbsolutePosition.Y + 85)
            end)

            DropdownLib.SetFrameRender = LPH_NO_VIRTUALIZE(function(value)
                DropdownLib.OpenSignal:SetValue(value)

                if value then
                    Shadow:Render(true)

                    DropdownHandler.Size = UDim2.new(0, (Dropdown.AbsoluteSize.X + 5) + DropdownLib.ExtentSize, 0, math.min(UIListLayout.AbsoluteContentSize.Y + 5, 250))

                    SetPosition()
                    NeverLose.PlayAnimate(DropdownHandler, SlowyTween, {BackgroundTransparency = 0.035})

                    if Config.AutoUpdate then
                        DropdownLib:Generate()
                    end
                else
                    NeverLose.PlayAnimate(DropdownHandler, SlowyTween, {BackgroundTransparency = 1})
                    Shadow:Render(false)
                end
            end)

            DropdownLib.SetFrameRender(false)
        end

        local SecureSignal

        NeverLose:CreateInput(Dropdown, LPH_NO_VIRTUALIZE(function()
            if SecureSignal then
                SecureSignal:Disconnect()

                SecureSignal = nil
            end

            DropdownLib.SetFrameRender(true)

            NeverLose.IsMosueOverOtherFrame = true
            SecureSignal = UserInputService.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    if not NeverLose:IsMouseOverFrame(DropdownLib.BlockRoot) and not NeverLose:IsMouseOverFrame(Dropdown) then
                        if SecureSignal then
                            SecureSignal:Disconnect()

                            SecureSignal = nil
                        end

                        NeverLose.IsMosueOverOtherFrame = false

                        DropdownLib.SetFrameRender(false)
                    end
                end
            end)
        end))
        Signal:Connect(LPH_NO_VIRTUALIZE(function(value)
            if not value then
                if SecureSignal then
                    SecureSignal:Disconnect()

                    SecureSignal = nil
                end

                NeverLose.IsMosueOverOtherFrame = false

                DropdownLib.SetFrameRender(false)
            end
        end))

        DropdownLib.IsMatch = LPH_NO_VIRTUALIZE(function(v1)
            if typeof(Config.Default) == 'table' then
                if Config.Default[v1] or table.find(Config.Default, v1) then
                    return true
                end
            end
            if Config.Default == v1 then
                return true
            end
        end)

        function DropdownLib:Generate()
            for i, v in next, DropdownLib.RootItem:GetChildren()do
                if v:IsA('Frame') then
                    v:Destroy()
                end
            end
            for i, v in next, DropdownLib.Signals do
                v:Disconnect()
            end

            table.clear(DropdownLib.Signals)
            table.clear(DropdownLib.Refuse)

            local Lastone

            for i, Value in next, Config.Values do
                local ItemFrame = Instance.new('Frame')
                local ItemLabel = Instance.new('TextLabel')
                local UICorner = Instance.new('UICorner')

                ItemFrame.Name = NeverLose.RandomString()
                ItemFrame.Parent = DropdownLib.RootItem
                ItemFrame.BackgroundColor3 = Color3.fromRGB(29, 31, 38)
                ItemFrame.BackgroundTransparency = 1
                ItemFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
                ItemFrame.BorderSizePixel = 0
                ItemFrame.Size = UDim2.new(1, 0, 0, 25)
                ItemFrame.ZIndex = ZINdex + 1258
                ItemLabel.Name = NeverLose.RandomString()
                ItemLabel.Parent = ItemFrame
                ItemLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ItemLabel.BackgroundTransparency = 1
                ItemLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
                ItemLabel.BorderSizePixel = 0
                ItemLabel.Position = UDim2.new(0, 15, 0, 4)
                ItemLabel.Size = UDim2.new(0, 1, 0, 15)
                ItemLabel.ZIndex = ZINdex + 1258
                ItemLabel.Font = Enum.Font.GothamMedium
                ItemLabel.Text = tostring(Value)
                ItemLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                ItemLabel.TextSize = 13
                ItemLabel.TextTransparency = 0.2
                ItemLabel.TextXAlignment = Enum.TextXAlignment.Left
                UICorner.CornerRadius = UDim.new(0, 10)
                UICorner.Parent = ItemFrame

                local sizetext = TextService:GetTextSize(ItemLabel.Text, ItemLabel.TextSize, ItemLabel.Font, Vector2.new(math.huge, math.huge))

                DropdownLib.ExtentSize = math.max(DropdownLib.ExtentSize, sizetext.X)

                local MIcon, MarkItem = nil, nil

                if Config.Multi then
                    local Icon = Instance.new('TextLabel')

                    Icon.Parent = ItemFrame
                    Icon.AnchorPoint = Vector2.new(0, 0.5)
                    Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    Icon.BackgroundTransparency = 1
                    Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
                    Icon.BorderSizePixel = 0
                    Icon.Position = UDim2.new(0, 5, 0.5, 0)
                    Icon.Size = UDim2.new(0, 20, 0, 20)
                    Icon.ZIndex = ZINdex + 1259
                    Icon.FontFace = NeverLose.BuiltInBold
                    Icon.Text = 'check'
                    Icon.TextColor3 = Color3.fromRGB(223, 223, 223)
                    Icon.TextSize = 18
                    Icon.TextTransparency = 1
                    Icon.TextWrapped = true

                    local VisiblewOfMult = LPH_NO_VIRTUALIZE(function()
                        if DropdownLib.IsMatch(Value) then
                            NeverLose.PlayAnimate(ItemLabel, VSlowTween, {
                                TextTransparency = 0.2,
                                Position = UDim2.new(0, 30, 0, 4),
                            })
                            NeverLose.PlayAnimate(Icon, vs, {TextTransparency = 0.25})

                            Lastone = ItemLabel
                        else
                            NeverLose.PlayAnimate(Icon, SlowyTween, {TextTransparency = 1})
                            NeverLose.PlayAnimate(ItemLabel, VSlowTween, {
                                TextTransparency = 0.5,
                                Position = UDim2.new(0, 15, 0, 4),
                            })
                        end
                    end)

                    MIcon = Icon
                    MarkItem = VisiblewOfMult
                else
                    local DefaultVisible = LPH_NO_VIRTUALIZE(function()
                        if DropdownLib.IsMatch(Value) then
                            NeverLose.PlayAnimate(ItemLabel, SlowyTween, {TextTransparency = 0.2})

                            Lastone = ItemLabel
                        else
                            NeverLose.PlayAnimate(ItemLabel, SlowyTween, {TextTransparency = 0.5})
                        end
                    end)

                    MarkItem = DefaultVisible
                end

                MarkItem()
                table.insert(DropdownLib.Refuse, MarkItem)
                table.insert(DropdownLib.Signals, ItemFrame.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
                    NeverLose.PlayAnimate(ItemFrame, SlowyTween, {BackgroundTransparency = 0.1})
                end)))
                table.insert(DropdownLib.Signals, ItemFrame.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
                    NeverLose.PlayAnimate(ItemFrame, SlowyTween, {BackgroundTransparency = 1})
                end)))
                table.insert(DropdownLib.Signals, DropdownLib.OpenSignal:Connect(LPH_NO_VIRTUALIZE(function(val)
                    if val then
                        MarkItem()
                    else
                        NeverLose.PlayAnimate(ItemLabel, SlowyTween, {TextTransparency = 1})

                        if MIcon then
                            NeverLose.PlayAnimate(MIcon, SlowyTween, {TextTransparency = 1})
                        end
                    end
                end)))

                if Config.Multi then
                    local _, bth_signal = NeverLose:CreateInput(ItemFrame, LPH_NO_VIRTUALIZE(function()
                        Config.Default[Value] = not Config.Default[Value]

                        MarkItem()

                        BasedLabel.Text = NeverLose.ParseDropdown(Config.Default)

                        Config.Callback(Config.Default)
                    end))

                    table.insert(DropdownLib.Signals, bth_signal)
                else
                    local _, bth_signal = NeverLose:CreateInput(ItemFrame, LPH_NO_VIRTUALIZE(function()
                        Config.Default = Value

                        for i, v in next, DropdownLib.Refuse do
                            task.spawn(v)
                        end

                        BasedLabel.Text = NeverLose.ParseDropdown(Config.Default)

                        Config.Callback(Config.Default)
                    end))

                    table.insert(DropdownLib.Signals, bth_signal)
                end
            end
        end

        DropdownLib:Generate()

        function DropdownLib:GetValue()
            return Config.Default
        end
        function DropdownLib:SetValue(v)
            Config.Default = v
            BasedLabel.Text = NeverLose.ParseDropdown(Config.Default)

            for i, v in next, DropdownLib.Refuse do
                task.spawn(v)
            end

            Config.Callback(Config.Default)
        end
        function DropdownLib:SetValues(a)
            Config.Values = a

            if not Config.AutoUpdate then
                DropdownLib:Generate()
            end
        end

        if Config.Flag then
            NeverLose.Flags[Config.Flag] = DropdownLib
        end

        return DropdownLib
    end

    return handle
end

NeverLose.ProcessDropdown = LPH_NO_VIRTUALIZE(function(value)
    if typeof(value) == 'table' then
        local data = {}

        for i, v in next, value do
            if typeof(v) == 'boolean' and typeof(i) ~= 'number' then
                data[i] = v
            else
                data[v] = true
            end
        end

        return data
    else
        return value
    end
end)
NeverLose.ParseDropdown = LPH_NO_VIRTUALIZE(function(value)
    if not value then
        return 'Select'
    end

    local Out

    if typeof(value) == 'table' then
        if #value > 0 then
            local x = {}

            for i, v in next, value do
                table.insert(x, tostring(v))
            end

            Out = table.concat(x, ' , ')

            table.clear(x)
        else
            local x = {}

            for i, v in next, value do
                if v == true then
                    table.insert(x, tostring(i))
                end
            end

            Out = table.concat(x, ' , ')

            table.clear(x)

            if not Out:byte() then
                Out = 'Select'
            end
        end
    else
        Out = tostring(value or 'Select')
    end

    return Out
end)

function NeverLose:ParseInput(Value, Numeric)
    if not Value then
        return (Numeric and nil) or ''
    end
    if Numeric then
        local out = string.gsub(tostring(Value), '[^0-9.%-]', '')

        if tonumber(out) then
            return tonumber(out)
        end

        return nil
    end

    return Value
end
function NeverLose:CreateToolTips(Container: Frame, Name: string, Content: string)
    local Tooltips = Instance.new('Frame')
    local UICorner = Instance.new('UICorner')
    local UIStroke = Instance.new('UIStroke')
    local TooltipName = Instance.new('TextLabel')
    local TooltipContent = Instance.new('TextLabel')
    local Shadow = NeverLose:CreateShadow(Tooltips)

    Tooltips.Name = NeverLose.RandomString()
    Tooltips.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
    Tooltips.BackgroundTransparency = 0.075
    Tooltips.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Tooltips.BorderSizePixel = 0
    Tooltips.ClipsDescendants = true
    Tooltips.Position = UDim2.new(255, 255, 255, 255)
    Tooltips.Size = UDim2.new(0, 0, 0, 0)
    Tooltips.ZIndex = 130
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = Tooltips
    UIStroke.Transparency = 0.65
    UIStroke.Color = Color3.fromRGB(45, 48, 58)
    UIStroke.Parent = Tooltips
    TooltipName.Name = NeverLose.RandomString()
    TooltipName.Parent = Tooltips
    TooltipName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TooltipName.BackgroundTransparency = 1
    TooltipName.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TooltipName.BorderSizePixel = 0
    TooltipName.Position = UDim2.new(0, 15, 0, 5)
    TooltipName.Size = UDim2.new(0, 1, 0, 20)
    TooltipName.ZIndex = 132
    TooltipName.Font = Enum.Font.GothamBold
    TooltipName.Text = Name
    TooltipName.TextColor3 = Color3.fromRGB(255, 255, 255)
    TooltipName.TextSize = 15
    TooltipName.TextXAlignment = Enum.TextXAlignment.Left
    TooltipContent.Name = NeverLose.RandomString()
    TooltipContent.Parent = Tooltips
    TooltipContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TooltipContent.BackgroundTransparency = 1
    TooltipContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TooltipContent.BorderSizePixel = 0
    TooltipContent.Position = UDim2.new(0, 15, 0, 30)
    TooltipContent.Size = UDim2.new(0, 1, 0, 15)
    TooltipContent.ZIndex = 132
    TooltipContent.Font = Enum.Font.GothamBold
    TooltipContent.Text = Content
    TooltipContent.TextColor3 = Color3.fromRGB(255, 255, 255)
    TooltipContent.TextSize = 12
    TooltipContent.TextTransparency = 0.65
    TooltipContent.TextXAlignment = Enum.TextXAlignment.Left
    TooltipContent.TextYAlignment = Enum.TextYAlignment.Top

    local ToolTip = {}

    ToolTip.Update = LPH_NO_VIRTUALIZE(function()
        local SizeName = TextService:GetTextSize(TooltipName.Text, TooltipName.TextSize, TooltipName.Font, Vector2.new(math.huge, math.huge))
        local SizeContent = TextService:GetTextSize(TooltipContent.Text, TooltipContent.TextSize, TooltipContent.Font, Vector2.new(math.huge, math.huge))
        local MaxX = math.max(SizeName.X, SizeContent.X) + 65
        local MaxY = SizeName.Y + SizeContent.Y + 30

        NeverLose.PlayAnimate(Tooltips, SlowyTween, {
            Size = UDim2.new(0, MaxX, 0, MaxY),
        })
    end)

    NeverLose:AddSignal(Tooltips:GetPropertyChangedSignal('BackgroundTransparency'):Connect(LPH_NO_VIRTUALIZE(function()
        if Tooltips.BackgroundTransparency > 0.9 then
            Tooltips.Visible = false
            Tooltips.Parent = nil
        else
            Tooltips.Visible = true

            if NeverLose.Global3DRenderMode then
                Tooltips.Parent = NeverLose.GlobalSurfaceGui
            else
                Tooltips.Parent = NeverLose.ScreenGui
            end
        end
    end)))

    ToolTip.SetRender = LPH_NO_VIRTUALIZE(function(value)
        if value then
            Tooltips.Position = UDim2.fromOffset(Container.AbsolutePosition.X + Container.AbsoluteSize.X, Container.AbsolutePosition.Y + (Container.AbsoluteSize.Y + 25))

            NeverLose.PlayAnimate(Tooltips, SlowyTween, {BackgroundTransparency = 0.075})
            NeverLose.PlayAnimate(UIStroke, SlowyTween, {Transparency = 0.65})
            NeverLose.PlayAnimate(TooltipName, SlowyTween, {TextTransparency = 0})
            NeverLose.PlayAnimate(TooltipContent, SlowyTween, {TextTransparency = 0.65})
            ToolTip.Update()
            Shadow:Render(true)
        else
            NeverLose.PlayAnimate(Tooltips, SlowyTween, {BackgroundTransparency = 1})
            NeverLose.PlayAnimate(UIStroke, SlowyTween, {Transparency = 1})
            NeverLose.PlayAnimate(TooltipName, SlowyTween, {TextTransparency = 1})
            NeverLose.PlayAnimate(TooltipContent, SlowyTween, {TextTransparency = 1})
            Shadow:Render(false)
        end
    end)

    ToolTip.SetRender(false)
    ToolTip.Update()
    table.insert(NeverLose.AllToolTips, ToolTip)

    local DelayThread
    local Shown = false
    local Generation = 0

    local function IsHovered()
        if not Container or not Container.Parent then
            return false
        end
        if not Container.Visible then
            return false
        end

        local size = Container.AbsoluteSize

        if size.X <= 0 or size.Y <= 0 then
            return false
        end

        return NeverLose:IsMouseOverFrame(Container) == true
    end
    local function CancelDelay()
        if DelayThread then
            pcall(task.cancel, DelayThread)

            DelayThread = nil
        end
    end

    ToolTip.Hide = LPH_NO_VIRTUALIZE(function()
        CancelDelay()

        Generation = Generation + 1

        if not Shown then
            return
        end

        Shown = false

        if NeverLose.__ActiveToolTip == ToolTip then
            NeverLose.__ActiveToolTip = nil
        end

        ToolTip.SetRender(false)
        ToolTip.Update()
    end)

    local function Show()
        if Shown then
            return
        end

        local previous = NeverLose.__ActiveToolTip

        if previous and previous ~= ToolTip and previous.Hide then
            pcall(previous.Hide)
        end

        Shown = true
        NeverLose.__ActiveToolTip = ToolTip

        ToolTip.SetRender(true)

        Generation = Generation + 1

        local token = Generation

        task.spawn(function()
            while Shown and token == Generation do
                task.wait(0.1)

                if token ~= Generation then
                    return
                end
                if not IsHovered() then
                    ToolTip.Hide()

                    return
                end
            end
        end)
    end

    NeverLose:AddSignal(Container.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
        CancelDelay()

        DelayThread = task.delay(1, function()
            DelayThread = nil

            if IsHovered() then
                Show()
            end
        end)
    end)))
    NeverLose:AddSignal(Container.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
        ToolTip.Hide()
    end)))
    NeverLose:AddSignal(Container:GetPropertyChangedSignal('Visible'):Connect(LPH_NO_VIRTUALIZE(function()
        if not Container.Visible then
            ToolTip.Hide()
        end
    end)))
    NeverLose:AddSignal(Container.AncestryChanged:Connect(LPH_NO_VIRTUALIZE(function()
        if not Container.Parent then
            ToolTip.Hide()
        end
    end)))

    return ToolTip
end
function NeverLose:RegisiterItem(Frame: Frame, Signel)
    local idx = {}
    local LayerIndex = Frame.ZIndex

    function idx:AddLabel(Name: string, Warp: boolean)
        local BasedFrame = Instance.new('Frame')
        local BasedLabel = Instance.new('TextLabel')
        local LineFrame = Instance.new('Frame')
        local BasedHandler = Instance.new('Frame')
        local UIListLayout = Instance.new('UIListLayout')
        local UICorner = Instance.new('UICorner')

        BasedFrame.Name = NeverLose.RandomString()
        BasedFrame.Parent = Frame
        BasedFrame.BackgroundColor3 = Color3.fromRGB(25, 27, 33)
        BasedFrame.BackgroundTransparency = 1
        BasedFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
        BasedFrame.BorderSizePixel = 0
        BasedFrame.Size = UDim2.new(1, 0, 0, 30)
        BasedFrame.ZIndex = LayerIndex + 8

        NeverLose:AddQuery(BasedFrame, Name)

        BasedLabel.Name = NeverLose.RandomString()
        BasedLabel.Parent = BasedFrame
        BasedLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        BasedLabel.BackgroundTransparency = 1
        BasedLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
        BasedLabel.BorderSizePixel = 0
        BasedLabel.Position = UDim2.new(0, 11, 0, 6)
        BasedLabel.Size = UDim2.new(0, 1, 0, 15)
        BasedLabel.ZIndex = LayerIndex + 9
        BasedLabel.Font = Enum.Font.GothamMedium
        BasedLabel.Text = Name
        BasedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        BasedLabel.TextSize = 13
        BasedLabel.TextTransparency = 0.35
        BasedLabel.TextXAlignment = Enum.TextXAlignment.Left
        LineFrame.Name = NeverLose.RandomString()
        LineFrame.Parent = BasedFrame
        LineFrame.AnchorPoint = Vector2.new(0.5, 1)
        LineFrame.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
        LineFrame.BackgroundTransparency = 0.65
        LineFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
        LineFrame.BorderSizePixel = 0
        LineFrame.Position = UDim2.new(0.5, 0, 1, 0)
        LineFrame.Size = UDim2.new(1, -20, 0, 1)
        LineFrame.ZIndex = LayerIndex + 11
        BasedHandler.Name = NeverLose.RandomString()
        BasedHandler.Parent = BasedFrame
        BasedHandler.AnchorPoint = Vector2.new(1, 0)
        BasedHandler.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        BasedHandler.BackgroundTransparency = 1
        BasedHandler.BorderColor3 = Color3.fromRGB(0, 0, 0)
        BasedHandler.BorderSizePixel = 0
        BasedHandler.Position = UDim2.new(1, -11, 0, 2)
        BasedHandler.Size = UDim2.new(1, -20, 0, 25)
        BasedHandler.ZIndex = LayerIndex + 12
        UIListLayout.Parent = BasedHandler
        UIListLayout.FillDirection = Enum.FillDirection.Horizontal
        UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        UIListLayout.Padding = UDim.new(0, 5)
        UICorner.CornerRadius = UDim.new(0, 10)
        UICorner.Parent = BasedFrame

        local UpdateWarp = LPH_NO_VIRTUALIZE(function()
            local size = TextService:GetTextSize(BasedLabel.Text, BasedLabel.TextSize, BasedLabel.Font, Vector2.new(math.huge, math.huge))

            NeverLose.PlayAnimate(BasedFrame, SlowyTween, {
                Size = UDim2.new(1, 0, 0, size.Y + 13),
            })

            BasedLabel.Size = UDim2.new(1, -35, 1, 0)
            BasedLabel.TextYAlignment = Enum.TextYAlignment.Top
        end)

        if Warp then
            UpdateWarp()
        end

        local handle = NeverLose:RegisiterHandler(BasedHandler, Signel)

        handle.Root = BasedFrame
        handle.DisplayName = Name
        handle.SetRender = LPH_NO_VIRTUALIZE(function(value)
            if value then
                NeverLose.PlayAnimate(BasedFrame, SlowyTween, {BackgroundTransparency = 1})
                NeverLose.PlayAnimate(BasedLabel, SlowyTween, {TextTransparency = 0.35})
                NeverLose.PlayAnimate(LineFrame, SlowyTween, {BackgroundTransparency = 0.65})
            else
                NeverLose.PlayAnimate(BasedFrame, SlowyTween, {BackgroundTransparency = 1})
                NeverLose.PlayAnimate(BasedLabel, SlowyTween, {TextTransparency = 1})
                NeverLose.PlayAnimate(LineFrame, SlowyTween, {BackgroundTransparency = 1})
            end
        end)

        function handle:SetVisible(val)
            BasedFrame.Visible = val
        end

        NeverLose:AddSignal(BasedFrame.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
            NeverLose.PlayAnimate(BasedFrame, SlowyTween, {BackgroundTransparency = 0.35})
            NeverLose.PlayAnimate(BasedLabel, SlowyTween, {TextTransparency = 0.25})
        end)))
        NeverLose:AddSignal(BasedFrame.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
            NeverLose.PlayAnimate(BasedFrame, SlowyTween, {BackgroundTransparency = 1})
            NeverLose.PlayAnimate(BasedLabel, SlowyTween, {TextTransparency = 0.35})
        end)))

        function handle:SetText(t)
            local oldtxt = BasedLabel.Text

            BasedLabel.Text = t

            if Warp and oldtxt ~= t then
                UpdateWarp()
            end
        end
        function handle:ToolTip(Content: string)
            handle.ToolTip = NeverLose:CreateToolTips(BasedFrame, Name, Content)

            return handle
        end

        handle.SetRender(Signel:GetValue())
        Signel:Connect(handle.SetRender)

        return handle
    end
    function idx:AddButton(Config)
        Config = NeverLose:ProcessParams(Config, {
            Icon = 'chevron-large-left',
            Name = 'Button',
            Callback = EmptyFunction,
            ToolTip = nil,
        })

        local Button = {}
        local ButtonFrame = Instance.new('Frame')
        local BasedLabel = Instance.new('TextLabel')
        local LineFrame = Instance.new('Frame')
        local UICorner = Instance.new('UICorner')
        local Icon = Instance.new('TextLabel')

        NeverLose:AddQuery(ButtonFrame, Config.Name)

        ButtonFrame.Name = NeverLose.RandomString()
        ButtonFrame.Parent = Frame
        ButtonFrame.BackgroundColor3 = Color3.fromRGB(25, 27, 33)
        ButtonFrame.BackgroundTransparency = 1
        ButtonFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
        ButtonFrame.BorderSizePixel = 0
        ButtonFrame.Size = UDim2.new(1, 0, 0, 30)
        ButtonFrame.ZIndex = LayerIndex + 8
        BasedLabel.Name = NeverLose.RandomString()
        BasedLabel.Parent = ButtonFrame
        BasedLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        BasedLabel.BackgroundTransparency = 1
        BasedLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
        BasedLabel.BorderSizePixel = 0
        BasedLabel.Position = UDim2.new(0, 35, 0, 6)
        BasedLabel.Size = UDim2.new(0, 1, 0, 15)
        BasedLabel.ZIndex = LayerIndex + 9
        BasedLabel.Font = Enum.Font.GothamMedium
        BasedLabel.Text = Config.Name
        BasedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        BasedLabel.TextSize = 13
        BasedLabel.TextTransparency = 0.2
        BasedLabel.TextXAlignment = Enum.TextXAlignment.Left
        LineFrame.Name = NeverLose.RandomString()
        LineFrame.Parent = ButtonFrame
        LineFrame.AnchorPoint = Vector2.new(0.5, 1)
        LineFrame.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
        LineFrame.BackgroundTransparency = 0.65
        LineFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
        LineFrame.BorderSizePixel = 0
        LineFrame.Position = UDim2.new(0.5, 0, 1, 0)
        LineFrame.Size = UDim2.new(1, -20, 0, 1)
        LineFrame.ZIndex = LayerIndex + 11
        UICorner.CornerRadius = UDim.new(0, 10)
        UICorner.Parent = ButtonFrame
        Icon.Name = NeverLose.RandomString()
        Icon.Parent = ButtonFrame
        Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Icon.BackgroundTransparency = 1
        Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Icon.BorderSizePixel = 0
        Icon.Position = UDim2.new(0, 11, 0, 5)
        Icon.Size = UDim2.new(0, 18, 0, 18)
        Icon.ZIndex = LayerIndex + 9
        Icon.FontFace = NeverLose.BuiltInBold
        Icon.Text = Config.Icon
        Icon.TextColor3 = Color3.fromRGB(223, 223, 223)
        Icon.TextSize = 16
        Icon.TextTransparency = 0.25
        Icon.TextWrapped = true

        local ButtonImage = nil
        local __btnIcon = tostring(Config.Icon)

        if string.match(__btnIcon, '^%d+$') then
            Icon.Text = ''
            ButtonImage = Instance.new('ImageLabel')
            ButtonImage.Name = NeverLose.RandomString()
            ButtonImage.Parent = ButtonFrame
            ButtonImage.BackgroundTransparency = 1
            ButtonImage.BorderSizePixel = 0
            ButtonImage.Position = Icon.Position
            ButtonImage.Size = Icon.Size
            ButtonImage.ZIndex = LayerIndex + 9
            ButtonImage.Image = 'rbxassetid://' .. __btnIcon
            ButtonImage.ImageColor3 = Color3.fromRGB(223, 223, 223)
            ButtonImage.ImageTransparency = 1
        end

        function Button:SetText(t)
            BasedLabel.Text = t
        end
        function Button:SetIcon(t)
            local s = tostring(t)

            if ButtonImage and string.match(s, '^%d+$') then
                ButtonImage.Image = 'rbxassetid://' .. s
            else
                Icon.Text = s
            end
        end

        local bth = NeverLose:CreateInput(ButtonFrame, LPH_NO_VIRTUALIZE(function()
            Config.Callback()
        end))

        NeverLose:AddSignal(bth.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
            NeverLose.PlayAnimate(ButtonFrame, SlowyTween, {BackgroundTransparency = 0.35})
        end)))
        NeverLose:AddSignal(bth.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
            NeverLose.PlayAnimate(ButtonFrame, SlowyTween, {BackgroundTransparency = 1})
        end)))

        Button.SetRender = LPH_NO_VIRTUALIZE(function(value)
            if value then
                NeverLose.PlayAnimate(ButtonFrame, SlowyTween, {BackgroundTransparency = 1})
                NeverLose.PlayAnimate(BasedLabel, SlowyTween, {TextTransparency = 0.2})
                NeverLose.PlayAnimate(LineFrame, SlowyTween, {BackgroundTransparency = 0.65})
                NeverLose.PlayAnimate(Icon, SlowyTween, {TextTransparency = 0.25})

                if ButtonImage then
                    NeverLose.PlayAnimate(ButtonImage, SlowyTween, {ImageTransparency = 0.25})
                end
            else
                NeverLose.PlayAnimate(ButtonFrame, SlowyTween, {BackgroundTransparency = 1})
                NeverLose.PlayAnimate(BasedLabel, SlowyTween, {TextTransparency = 1})
                NeverLose.PlayAnimate(LineFrame, SlowyTween, {BackgroundTransparency = 1})
                NeverLose.PlayAnimate(Icon, SlowyTween, {TextTransparency = 1})

                if ButtonImage then
                    NeverLose.PlayAnimate(ButtonImage, SlowyTween, {ImageTransparency = 1})
                end
            end
        end)

        if Config.ToolTip then
            Button.ToolTip = NeverLose:CreateToolTips(ButtonFrame, Config.Name, Config.ToolTip)
        end

        Button.SetRender(Signel:GetValue())
        Signel:Connect(Button.SetRender)
        NeverLose:CreateElementKeybind(ButtonFrame, 'Button', function() end, function() end, function()
            Config.Callback()
        end, Config.Name, Config.Name, Signel)

        return Button
    end
    function idx:AddUserFrame(Name: string, Profile: string, Expires: string)
        local UserFrame = Instance.new('Frame')
        local UserLabel = Instance.new('TextLabel')
        local LineFrame = Instance.new('Frame')
        local UICorner = Instance.new('UICorner')
        local LogoImage = Instance.new('ImageLabel')
        local UICorner_2 = Instance.new('UICorner')
        local UserStatusLabel = Instance.new('TextLabel')

        UserFrame.Name = NeverLose.RandomString()
        UserFrame.Parent = Frame
        UserFrame.BackgroundColor3 = Color3.fromRGB(25, 27, 33)
        UserFrame.BackgroundTransparency = 1
        UserFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
        UserFrame.BorderSizePixel = 0
        UserFrame.Size = UDim2.new(1, 0, 0, 60)
        UserFrame.ZIndex = LayerIndex + 8
        UserLabel.Name = NeverLose.RandomString()
        UserLabel.Parent = UserFrame
        UserLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        UserLabel.BackgroundTransparency = 1
        UserLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
        UserLabel.BorderSizePixel = 0
        UserLabel.Position = UDim2.new(0, 65, 0, 10)
        UserLabel.Size = UDim2.new(1, -35, 0, 15)
        UserLabel.ZIndex = LayerIndex + 9
        UserLabel.Font = Enum.Font.GothamMedium
        UserLabel.Text = Name or 'User'
        UserLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        UserLabel.TextSize = 13
        UserLabel.TextTransparency = 0.2
        UserLabel.TextXAlignment = Enum.TextXAlignment.Left
        LineFrame.Name = NeverLose.RandomString()
        LineFrame.Parent = UserFrame
        LineFrame.AnchorPoint = Vector2.new(0.5, 1)
        LineFrame.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
        LineFrame.BackgroundTransparency = 0.65
        LineFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
        LineFrame.BorderSizePixel = 0
        LineFrame.Position = UDim2.new(0.5, 0, 1, 0)
        LineFrame.Size = UDim2.new(1, -20, 0, 1)
        LineFrame.ZIndex = LayerIndex + 11
        UICorner.CornerRadius = UDim.new(0, 10)
        UICorner.Parent = UserFrame
        LogoImage.Name = NeverLose.RandomString()
        LogoImage.Parent = UserFrame
        LogoImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        LogoImage.BackgroundTransparency = 1
        LogoImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
        LogoImage.BorderSizePixel = 0
        LogoImage.Position = UDim2.new(0, 10, 0, 5)
        LogoImage.Size = UDim2.new(0, 45, 0, 45)
        LogoImage.ZIndex = LayerIndex + 9
        LogoImage.Image = Profile or 'rbxasset://textures/ui/clb_robux_20@3x.png'
        UICorner_2.CornerRadius = UDim.new(1, 0)
        UICorner_2.Parent = LogoImage
        UserStatusLabel.Name = NeverLose.RandomString()
        UserStatusLabel.Parent = UserFrame
        UserStatusLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        UserStatusLabel.BackgroundTransparency = 1
        UserStatusLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
        UserStatusLabel.BorderSizePixel = 0
        UserStatusLabel.Position = UDim2.new(0, 65, 0, 25)
        UserStatusLabel.Size = UDim2.new(1, -35, 0, 15)
        UserStatusLabel.ZIndex = LayerIndex + 9
        UserStatusLabel.Font = Enum.Font.GothamMedium
        UserStatusLabel.Text = Expires or 'Never'
        UserStatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        UserStatusLabel.TextSize = 13
        UserStatusLabel.TextTransparency = 0.2
        UserStatusLabel.TextXAlignment = Enum.TextXAlignment.Left

        local UserFrameItem = {}

        UserFrameItem.SetRender = LPH_NO_VIRTUALIZE(function(value)
            if value then
                NeverLose.PlayAnimate(UserLabel, SlowyTween, {TextTransparency = 0.2})
                NeverLose.PlayAnimate(LineFrame, SlowyTween, {BackgroundTransparency = 0.65})
                NeverLose.PlayAnimate(LogoImage, SlowyTween, {ImageTransparency = 0})
                NeverLose.PlayAnimate(UserStatusLabel, SlowyTween, {TextTransparency = 0.2})
            else
                NeverLose.PlayAnimate(UserLabel, SlowyTween, {TextTransparency = 1})
                NeverLose.PlayAnimate(LineFrame, SlowyTween, {BackgroundTransparency = 1})
                NeverLose.PlayAnimate(LogoImage, SlowyTween, {ImageTransparency = 1})
                NeverLose.PlayAnimate(UserStatusLabel, SlowyTween, {TextTransparency = 1})
            end
        end)

        UserFrameItem.SetRender(Signel:GetValue())
        Signel:Connect(UserFrameItem.SetRender)

        function UserFrameItem:SetUsername(name)
            UserLabel.Text = name or 'User'
        end
        function UserFrameItem:SetProfile(Profile)
            LogoImage.Image = Profile or 'rbxasset://textures/ui/clb_robux_20@3x.png'
        end
        function UserFrameItem:SetExpires(Exp)
            UserStatusLabel.Text = Exp or 'Never'
        end

        return UserFrameItem
    end
    function idx:AddCardGrid(Config)
        Config = NeverLose:ProcessParams(Config, {
            Values = {},
            Thumb = 'Asset',
            Height = 310,
            Callback = EmptyFunction,
            IsSelected = function()
                return false
            end,
            Options = nil,
            DefaultOption = nil,
            OptionChanged = nil,
            Flag = nil,
            SearchPlaceholder = 'Search...',
            EmptyIcon = 'circle-info',
        })

        local CardGridLib = {}
        local MAX_RENDER = 80
        local CARD_HEIGHT = 128
        local ZI = LayerIndex + 8
        local currentFilter = ''
        local lastValue = nil
        local optionValues = {}
        local paints = {}
        local renderSignals = {}
        local activePopup = nil
        local CardGridFrame = Instance.new('Frame')

        CardGridFrame.Name = NeverLose.RandomString()
        CardGridFrame.Parent = Frame
        CardGridFrame.BackgroundColor3 = Color3.fromRGB(25, 27, 33)
        CardGridFrame.BackgroundTransparency = 1
        CardGridFrame.BorderSizePixel = 0
        CardGridFrame.Size = UDim2.new(1, 0, 0, Config.Height)
        CardGridFrame.ZIndex = ZI

        local Search = Instance.new('Frame')

        Search.Name = NeverLose.RandomString()
        Search.Parent = CardGridFrame
        Search.BackgroundColor3 = Color3.fromRGB(26, 28, 36)
        Search.BackgroundTransparency = 1
        Search.BorderSizePixel = 0
        Search.ClipsDescendants = true
        Search.Position = UDim2.new(0, 10, 0, 8)
        Search.Size = UDim2.new(1, -20, 0, 22)
        Search.ZIndex = ZI + 2

        local SearchCorner = Instance.new('UICorner')

        SearchCorner.CornerRadius = UDim.new(0, 4)
        SearchCorner.Parent = Search

        local SearchStroke = Instance.new('UIStroke')

        SearchStroke.Transparency = 1
        SearchStroke.Color = Color3.fromRGB(45, 48, 58)
        SearchStroke.Parent = Search

        local SearchIcon = Instance.new('TextLabel')

        SearchIcon.Name = NeverLose.RandomString()
        SearchIcon.Parent = Search
        SearchIcon.AnchorPoint = Vector2.new(0, 0.5)
        SearchIcon.BackgroundTransparency = 1
        SearchIcon.Position = UDim2.new(0, 6, 0.5, 0)
        SearchIcon.Size = UDim2.new(0, 14, 0, 14)
        SearchIcon.ZIndex = ZI + 3
        SearchIcon.FontFace = NeverLose.BuiltInBold
        SearchIcon.Text = 'magnifying-glass'
        SearchIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
        SearchIcon.TextSize = 12
        SearchIcon.TextTransparency = 1

        local SearchBox = Instance.new('TextBox')

        SearchBox.Name = NeverLose.RandomString()
        SearchBox.Parent = Search
        SearchBox.AnchorPoint = Vector2.new(0, 0.5)
        SearchBox.BackgroundTransparency = 1
        SearchBox.BorderSizePixel = 0
        SearchBox.Position = UDim2.new(0, 24, 0.5, 0)
        SearchBox.Size = UDim2.new(1, -30, 0, 17)
        SearchBox.ZIndex = ZI + 3
        SearchBox.ClearTextOnFocus = false
        SearchBox.Font = Enum.Font.GothamMedium
        SearchBox.PlaceholderText = Config.SearchPlaceholder
        SearchBox.Text = ''
        SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        SearchBox.TextSize = 11
        SearchBox.TextTransparency = 1
        SearchBox.TextXAlignment = Enum.TextXAlignment.Left

        local Scroll = Instance.new('ScrollingFrame')

        Scroll.Name = NeverLose.RandomString()
        Scroll.Parent = CardGridFrame
        Scroll.Active = true
        Scroll.BackgroundTransparency = 1
        Scroll.BorderSizePixel = 0
        Scroll.Position = UDim2.new(0, 10, 0, 36)
        Scroll.Size = UDim2.new(1, -20, 1, -42)
        Scroll.ZIndex = ZI + 2
        Scroll.ScrollBarThickness = 2
        Scroll.ScrollBarImageColor3 = Color3.fromRGB(45, 48, 58)
        Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)

        local GridLayout = Instance.new('UIGridLayout')

        GridLayout.Parent = Scroll
        GridLayout.CellPadding = UDim2.fromOffset(6, 6)
        GridLayout.CellSize = UDim2.new(0.5, -3, 0, CARD_HEIGHT)
        GridLayout.FillDirection = Enum.FillDirection.Horizontal
        GridLayout.FillDirectionMaxCells = 2
        GridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        GridLayout.SortOrder = Enum.SortOrder.LayoutOrder

        NeverLose:AddSignal(GridLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(LPH_NO_VIRTUALIZE(function()
            Scroll.CanvasSize = UDim2.fromOffset(0, GridLayout.AbsoluteContentSize.Y)
        end)))

        local function track(signal)
            NeverLose:AddSignal(signal)
            table.insert(renderSignals, signal)

            return signal
        end
        local function clearRenderSignals()
            for _, signal in ipairs(renderSignals)do
                pcall(function()
                    signal:Disconnect()
                end)
            end

            table.clear(renderSignals)
        end
        local function keyOf(item)
            if type(item) == 'table' and item.name ~= nil then
                return tostring(item.name)
            end

            return tostring(item)
        end
        local function displayOf(item)
            if type(item) == 'table' and item.display ~= nil then
                return tostring(item.display)
            end

            return keyOf(item)
        end
        local function optionsOf(item)
            local source = type(item) == 'table' and item.options or nil

            if source == nil then
                source = Config.Options
            end
            if type(source) == 'function' then
                local ok, result = pcall(source, item)

                source = ok and result or nil
            end
            if type(source) == 'table' and #source == 0 then
                local mapped = source[keyOf(item)]

                if type(mapped) == 'function' then
                    local ok, result = pcall(mapped, item)

                    mapped = ok and result or nil
                end
                if type(mapped) == 'table' then
                    source = mapped
                end
            end

            local result = {}

            if type(source) == 'table' then
                for _, option in ipairs(source)do
                    table.insert(result, option)
                end
            end

            return result
        end
        local function defaultOptionOf(item, options)
            local key = keyOf(item)

            if optionValues[key] ~= nil then
                return optionValues[key]
            end

            local value = type(item) == 'table' and item.option or nil

            if value == nil then
                value = Config.DefaultOption

                if type(value) == 'function' then
                    local ok, result = pcall(value, item)

                    value = ok and result or nil
                elseif type(value) == 'table' then
                    value = value[key]
                end
            end
            if value == nil then
                value = options[1]
            end

            optionValues[key] = value

            return value
        end
        local function imageOf(item)
            if type(item) ~= 'table' then
                return ''
            end
            if item.image ~= nil then
                return tostring(item.image)
            end
            if item.thumbnail ~= nil then
                return tostring(item.thumbnail)
            end
            if item.id ~= nil then
                return 'rbxthumb://type=' .. tostring(Config.Thumb) .. '&id=' .. tostring(item.id) .. '&w=420&h=420'
            end

            return ''
        end
        local function selected(item, option)
            if type(Config.IsSelected) ~= 'function' then
                return false
            end

            local ok, result = pcall(Config.IsSelected, item, option)

            return ok and result == true
        end
        local function closePopup()
            if not activePopup then
                return
            end

            local popup = activePopup

            activePopup = nil

            for _, signal in ipairs(popup.Signals)do
                pcall(function()
                    signal:Disconnect()
                end)
            end

            if popup.Root then
                popup.Root:Destroy()
            end

            NeverLose.IsMosueOverOtherFrame = false
        end
        local function openPopup(item, options, Dropdown, BasedLabel, paint)
            closePopup()

            local Popup = Instance.new('Frame')

            Popup.Name = NeverLose.RandomString()
            Popup.Parent = NeverLose.Global3DRenderMode and NeverLose.GlobalSurfaceGui or NeverLose.ScreenGui
            Popup.AnchorPoint = Vector2.new(0.5, 0)
            Popup.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
            Popup.BackgroundTransparency = 1
            Popup.BorderSizePixel = 0
            Popup.ClipsDescendants = true
            Popup.ZIndex = 500

            local width = math.max(Dropdown.AbsoluteSize.X, 110)

            for _, option in ipairs(options)do
                local textSize = TextService:GetTextSize(tostring(option), 11, Enum.Font.GothamMedium, Vector2.new(math.huge, 16))

                width = math.max(width, textSize.X + 24)
            end

            local height = math.min(#options * 25 + 4, 180)

            Popup.Size = UDim2.fromOffset(width, height)

            local below = Dropdown.AbsolutePosition.Y + Dropdown.AbsoluteSize.Y + 4

            if NeverLose:MoreThanHalfY(below + height) then
                Popup.AnchorPoint = Vector2.new(0.5, 1)
                Popup.Position = UDim2.fromOffset(Dropdown.AbsolutePosition.X + Dropdown.AbsoluteSize.X / 2, Dropdown.AbsolutePosition.Y - 4)
            else
                Popup.AnchorPoint = Vector2.new(0.5, 0)
                Popup.Position = UDim2.fromOffset(Dropdown.AbsolutePosition.X + Dropdown.AbsoluteSize.X / 2, below)
            end

            local PopupCorner = Instance.new('UICorner')

            PopupCorner.CornerRadius = UDim.new(0, 8)
            PopupCorner.Parent = Popup

            local PopupStroke = Instance.new('UIStroke')

            PopupStroke.Transparency = 0.65
            PopupStroke.Color = Color3.fromRGB(45, 48, 58)
            PopupStroke.Parent = Popup

            local Shadow = NeverLose:CreateShadow(Popup)

            Shadow:Render(true)

            local PopupScroll = Instance.new('ScrollingFrame')

            PopupScroll.Name = NeverLose.RandomString()
            PopupScroll.Parent = Popup
            PopupScroll.Active = true
            PopupScroll.AnchorPoint = Vector2.new(0.5, 0.5)
            PopupScroll.BackgroundTransparency = 1
            PopupScroll.BorderSizePixel = 0
            PopupScroll.Position = UDim2.fromScale(0.5, 0.5)
            PopupScroll.Size = UDim2.new(1, -4, 1, -4)
            PopupScroll.ZIndex = 502
            PopupScroll.ScrollBarThickness = 2
            PopupScroll.ScrollBarImageColor3 = Color3.fromRGB(45, 48, 58)
            PopupScroll.CanvasSize = UDim2.fromOffset(0, #options * 25)

            local PopupLayout = Instance.new('UIListLayout')

            PopupLayout.Parent = PopupScroll
            PopupLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            PopupLayout.SortOrder = Enum.SortOrder.LayoutOrder

            local popupData = {
                Root = Popup,
                Signals = {},
            }

            activePopup = popupData
            NeverLose.IsMosueOverOtherFrame = true

            for _, option in ipairs(options)do
                local value = option
                local OptionFrame = Instance.new('Frame')

                OptionFrame.Name = NeverLose.RandomString()
                OptionFrame.Parent = PopupScroll
                OptionFrame.BackgroundColor3 = Color3.fromRGB(29, 31, 38)
                OptionFrame.BackgroundTransparency = 1
                OptionFrame.BorderSizePixel = 0
                OptionFrame.Size = UDim2.new(1, 0, 0, 25)
                OptionFrame.ZIndex = 503

                local OptionCorner = Instance.new('UICorner')

                OptionCorner.CornerRadius = UDim.new(0, 6)
                OptionCorner.Parent = OptionFrame

                local OptionLabel = Instance.new('TextLabel')

                OptionLabel.Name = NeverLose.RandomString()
                OptionLabel.Parent = OptionFrame
                OptionLabel.BackgroundTransparency = 1
                OptionLabel.BorderSizePixel = 0
                OptionLabel.Position = UDim2.new(0, 8, 0, 0)
                OptionLabel.Size = UDim2.new(1, -16, 1, 0)
                OptionLabel.ZIndex = 504
                OptionLabel.Font = Enum.Font.GothamMedium
                OptionLabel.Text = tostring(value)
                OptionLabel.TextColor3 = optionValues[keyOf(item)] == value and NeverLose.AccentColor or Color3.fromRGB(255, 255, 255)
                OptionLabel.TextSize = 11
                OptionLabel.TextTransparency = optionValues[keyOf(item)] == value and 0.1 or 0.45
                OptionLabel.TextTruncate = Enum.TextTruncate.AtEnd
                OptionLabel.TextXAlignment = Enum.TextXAlignment.Left

                local _, optionSignal = NeverLose:CreateInput(OptionFrame, LPH_NO_VIRTUALIZE(function()
                    optionValues[keyOf(item)] = value
                    BasedLabel.Text = tostring(value)

                    if type(Config.OptionChanged) == 'function' then
                        Config.OptionChanged(item, value)
                    end

                    paint()
                    closePopup()
                end))

                table.insert(popupData.Signals, NeverLose:AddSignal(optionSignal))
                table.insert(popupData.Signals, NeverLose:AddSignal(OptionFrame.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
                    NeverLose.PlayAnimate(OptionFrame, SlowyTween, {BackgroundTransparency = 0.1})
                end))))
                table.insert(popupData.Signals, NeverLose:AddSignal(OptionFrame.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
                    NeverLose.PlayAnimate(OptionFrame, SlowyTween, {BackgroundTransparency = 1})
                end))))
            end

            local outsideSignal

            outsideSignal = UserInputService.InputBegan:Connect(LPH_NO_VIRTUALIZE(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    if activePopup == popupData and not NeverLose:IsMouseOverFrame(Popup) and not NeverLose:IsMouseOverFrame(Dropdown) then
                        closePopup()
                    end
                end
            end))

            table.insert(popupData.Signals, NeverLose:AddSignal(outsideSignal))
            NeverLose.PlayAnimate(Popup, SlowyTween, {BackgroundTransparency = 0.035})
        end
        local function makeCard(item)
            local key = keyOf(item)
            local options = optionsOf(item)
            local option = defaultOptionOf(item, options)
            local Card = Instance.new('Frame')

            Card.Name = NeverLose.RandomString()
            Card.Parent = Scroll
            Card.BackgroundColor3 = Color3.fromRGB(26, 28, 36)
            Card.BackgroundTransparency = 0
            Card.BorderSizePixel = 0
            Card.ClipsDescendants = true
            Card.Size = UDim2.new(0.5, -3, 0, CARD_HEIGHT)
            Card.ZIndex = ZI + 3

            local CardCorner = Instance.new('UICorner')

            CardCorner.CornerRadius = UDim.new(0, 7)
            CardCorner.Parent = Card

            local CardStroke = Instance.new('UIStroke')

            CardStroke.Transparency = 0.72
            CardStroke.Color = Color3.fromRGB(45, 48, 58)
            CardStroke.Parent = Card

            local AccentBar = Instance.new('Frame')

            AccentBar.Name = NeverLose.RandomString()
            AccentBar.Parent = Card
            AccentBar.BackgroundColor3 = NeverLose.AccentColor
            AccentBar.BackgroundTransparency = 1
            AccentBar.BorderSizePixel = 0
            AccentBar.Position = UDim2.new(0, 0, 0, 10)
            AccentBar.Size = UDim2.new(0, 2, 1, -20)
            AccentBar.ZIndex = ZI + 5

            local BarCorner = Instance.new('UICorner')

            BarCorner.CornerRadius = UDim.new(1, 0)
            BarCorner.Parent = AccentBar

            local Thumbnail = Instance.new('ImageLabel')

            Thumbnail.Name = NeverLose.RandomString()
            Thumbnail.Parent = Card
            Thumbnail.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
            Thumbnail.BorderSizePixel = 0
            Thumbnail.Position = UDim2.new(0, 6, 0, 6)
            Thumbnail.Size = UDim2.new(1, -12, 0, 68)
            Thumbnail.ZIndex = ZI + 4
            Thumbnail.Image = imageOf(item)
            Thumbnail.ScaleType = Enum.ScaleType.Crop

            local ThumbnailCorner = Instance.new('UICorner')

            ThumbnailCorner.CornerRadius = UDim.new(0, 5)
            ThumbnailCorner.Parent = Thumbnail

            local Title = Instance.new('TextLabel')

            Title.Name = NeverLose.RandomString()
            Title.Parent = Card
            Title.BackgroundTransparency = 1
            Title.BorderSizePixel = 0
            Title.Position = UDim2.new(0, 7, 0, 78)
            Title.Size = UDim2.new(1, -14, 0, 15)
            Title.ZIndex = ZI + 5
            Title.Font = Enum.Font.GothamMedium
            Title.Text = displayOf(item)
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.TextSize = 11
            Title.TextTransparency = 0.25
            Title.TextTruncate = Enum.TextTruncate.AtEnd
            Title.TextXAlignment = Enum.TextXAlignment.Left

            local Dropdown = nil
            local paint

            if #options > 0 then
                Dropdown = Instance.new('Frame')
                Dropdown.Name = NeverLose.RandomString()
                Dropdown.Parent = Card
                Dropdown.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
                Dropdown.BorderSizePixel = 0
                Dropdown.ClipsDescendants = true
                Dropdown.Position = UDim2.new(0, 6, 0, 101)
                Dropdown.Size = UDim2.new(1, -12, 0, 20)
                Dropdown.ZIndex = ZI + 14

                local DropdownCorner = Instance.new('UICorner')

                DropdownCorner.CornerRadius = UDim.new(0, 4)
                DropdownCorner.Parent = Dropdown

                local DropdownStroke = Instance.new('UIStroke')

                DropdownStroke.Transparency = 0.65
                DropdownStroke.Color = Color3.fromRGB(45, 48, 58)
                DropdownStroke.Parent = Dropdown

                local BasedLabel = Instance.new('TextLabel')

                BasedLabel.Name = NeverLose.RandomString()
                BasedLabel.Parent = Dropdown
                BasedLabel.BackgroundTransparency = 1
                BasedLabel.BorderSizePixel = 0
                BasedLabel.Position = UDim2.new(0, 6, 0, 0)
                BasedLabel.Size = UDim2.new(1, -25, 1, 0)
                BasedLabel.ZIndex = ZI + 15
                BasedLabel.Font = Enum.Font.GothamMedium
                BasedLabel.Text = option ~= nil and tostring(option) or 'Select'
                BasedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                BasedLabel.TextSize = 10
                BasedLabel.TextTransparency = 0.4
                BasedLabel.TextTruncate = Enum.TextTruncate.AtEnd
                BasedLabel.TextXAlignment = Enum.TextXAlignment.Left

                local DropdownIcon = Instance.new('TextLabel')

                DropdownIcon.Name = NeverLose.RandomString()
                DropdownIcon.Parent = Dropdown
                DropdownIcon.AnchorPoint = Vector2.new(1, 0.5)
                DropdownIcon.BackgroundTransparency = 1
                DropdownIcon.Position = UDim2.new(1, -3, 0.5, 0)
                DropdownIcon.Size = UDim2.fromOffset(15, 15)
                DropdownIcon.ZIndex = ZI + 15
                DropdownIcon.FontFace = NeverLose.BuiltInBold
                DropdownIcon.Text = 'chevron-small-down'
                DropdownIcon.TextColor3 = Color3.fromRGB(223, 223, 223)
                DropdownIcon.TextSize = 14
                DropdownIcon.TextTransparency = 0.3

                local _, dropdownSignal = NeverLose:CreateInput(Dropdown, LPH_NO_VIRTUALIZE(function()
                    openPopup(item, options, Dropdown, BasedLabel, paint)
                end))

                track(dropdownSignal)
                track(Dropdown.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
                    NeverLose.PlayAnimate(BasedLabel, SlowyTween, {TextTransparency = 0.15})
                end)))
                track(Dropdown.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
                    NeverLose.PlayAnimate(BasedLabel, SlowyTween, {TextTransparency = 0.4})
                end)))
            else
                local StatusIcon = Instance.new('TextLabel')

                StatusIcon.Name = NeverLose.RandomString()
                StatusIcon.Parent = Card
                StatusIcon.AnchorPoint = Vector2.new(0, 0.5)
                StatusIcon.BackgroundTransparency = 1
                StatusIcon.Position = UDim2.new(0, 7, 0, 110)
                StatusIcon.Size = UDim2.fromOffset(14, 14)
                StatusIcon.ZIndex = ZI + 5
                StatusIcon.FontFace = NeverLose.BuiltInBold
                StatusIcon.Text = type(item) == 'table' and tostring(item.icon or Config.EmptyIcon) or tostring(Config.EmptyIcon)
                StatusIcon.TextColor3 = Color3.fromRGB(223, 223, 223)
                StatusIcon.TextSize = 11
                StatusIcon.TextTransparency = 0.45

                local StatusLabel = Instance.new('TextLabel')

                StatusLabel.Name = NeverLose.RandomString()
                StatusLabel.Parent = Card
                StatusLabel.AnchorPoint = Vector2.new(0, 0.5)
                StatusLabel.BackgroundTransparency = 1
                StatusLabel.BorderSizePixel = 0
                StatusLabel.Position = UDim2.new(0, 24, 0, 110)
                StatusLabel.Size = UDim2.new(1, -31, 0, 14)
                StatusLabel.ZIndex = ZI + 5
                StatusLabel.Font = Enum.Font.GothamMedium
                StatusLabel.Text = type(item) == 'table' and tostring(item.status or 'Available') or 'Available'
                StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                StatusLabel.TextSize = 10
                StatusLabel.TextTransparency = 0.5
                StatusLabel.TextTruncate = Enum.TextTruncate.AtEnd
                StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
            end

            paint = LPH_NO_VIRTUALIZE(function()
                local currentOption = optionValues[key]

                if selected(item, currentOption) then
                    NeverLose.PlayAnimate(CardStroke, SlowyTween, {
                        Transparency = 0.15,
                        Color = NeverLose.AccentColor,
                    })
                    NeverLose.PlayAnimate(AccentBar, SlowyTween, {BackgroundTransparency = 0})
                    NeverLose.PlayAnimate(Title, SlowyTween, {
                        TextTransparency = 0,
                        TextColor3 = NeverLose.AccentColor,
                    })
                else
                    NeverLose.PlayAnimate(CardStroke, SlowyTween, {
                        Transparency = 0.72,
                        Color = Color3.fromRGB(45, 48, 58),
                    })
                    NeverLose.PlayAnimate(AccentBar, SlowyTween, {BackgroundTransparency = 1})
                    NeverLose.PlayAnimate(Title, SlowyTween, {
                        TextTransparency = 0.25,
                        TextColor3 = Color3.fromRGB(255, 255, 255),
                    })
                end
            end)

            table.insert(paints, paint)
            paint()

            local cardButton, cardSignal = NeverLose:CreateInput(Card, LPH_NO_VIRTUALIZE(function()
                if Dropdown and NeverLose:IsMouseOverFrame(Dropdown) then
                    return
                end

                lastValue = key

                Config.Callback(item, optionValues[key])

                for _, repaint in ipairs(paints)do
                    repaint()
                end
            end))

            cardButton.ZIndex = ZI + 10

            track(cardSignal)
            track(cardButton.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
                NeverLose.PlayAnimate(Card, SlowyTween, {BackgroundTransparency = 0.08})
            end)))
            track(cardButton.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
                NeverLose.PlayAnimate(Card, SlowyTween, {BackgroundTransparency = 0})
            end)))
        end
        local function render(filter)
            currentFilter = filter or ''

            closePopup()
            clearRenderSignals()

            for _, child in ipairs(Scroll:GetChildren())do
                if not child:IsA('UIGridLayout') then
                    child:Destroy()
                end
            end

            table.clear(paints)

            local loweredFilter = string.lower(currentFilter)
            local count = 0

            for _, item in ipairs(Config.Values)do
                local key = keyOf(item)
                local display = displayOf(item)

                if loweredFilter == '' or string.find(string.lower(key), loweredFilter, 1, true) or string.find(string.lower(display), loweredFilter, 1, true) then
                    count = count + 1

                    if count > MAX_RENDER then
                        break
                    end

                    makeCard(item)
                end
            end
        end

        local searchDelay = 0

        NeverLose:AddSignal(SearchBox:GetPropertyChangedSignal('Text'):Connect(LPH_NO_VIRTUALIZE(function()
            searchDelay = tick()

            local this = searchDelay

            task.delay(0.2, function()
                if this == searchDelay then
                    render(SearchBox.Text)
                end
            end)
        end)))

        CardGridLib.SetRender = LPH_NO_VIRTUALIZE(function(value)
            CardGridFrame.Visible = value

            if value then
                NeverLose.PlayAnimate(Search, SlowyTween, {BackgroundTransparency = 0})
                NeverLose.PlayAnimate(SearchStroke, SlowyTween, {Transparency = 0.65})
                NeverLose.PlayAnimate(SearchBox, SlowyTween, {TextTransparency = 0.35})
                NeverLose.PlayAnimate(SearchIcon, SlowyTween, {TextTransparency = 0.35})
            else
                closePopup()
                NeverLose.PlayAnimate(Search, SlowyTween, {BackgroundTransparency = 1})
                NeverLose.PlayAnimate(SearchStroke, SlowyTween, {Transparency = 1})
                NeverLose.PlayAnimate(SearchBox, SlowyTween, {TextTransparency = 1})
                NeverLose.PlayAnimate(SearchIcon, SlowyTween, {TextTransparency = 1})
            end
        end)

        render()
        CardGridLib.SetRender(Signel:GetValue())
        Signel:Connect(CardGridLib.SetRender)

        function CardGridLib:Refresh()
            render(currentFilter)
        end
        function CardGridLib:SetValues(values)
            Config.Values = values or {}

            render(currentFilter)
        end
        function CardGridLib:SetData(values)
            Config.Values = values or {}

            render(currentFilter)
        end
        function CardGridLib:GetValue()
            return lastValue
        end
        function CardGridLib:SetValue(value)
            for _, item in ipairs(Config.Values)do
                if keyOf(item) == tostring(value) then
                    lastValue = keyOf(item)

                    local currentOption = defaultOptionOf(item, optionsOf(item))

                    Config.Callback(item, currentOption)

                    for _, paint in ipairs(paints)do
                        paint()
                    end

                    return
                end
            end
        end

        if Config.Flag then
            NeverLose.Flags[Config.Flag] = CardGridLib
        end

        return CardGridLib
    end
    function idx:AddList(Config)
        Config = NeverLose:ProcessParams(Config, {
            Name = 'LIST',
            Values = {},
            Multi = false,
            Default = nil,
            Thumb = 'Asset',
            Callback = EmptyFunction,
            Height = 250,
            Flag = nil,
        })

        if Config.Default == nil then
            Config.Default = (Config.Multi and {}) or nil
        end

        local ListLib = {}
        local MAX_RENDER = 100
        local ZI = LayerIndex + 8
        local currentFilter = ''
        local ListFrame = Instance.new('Frame')

        ListFrame.Name = NeverLose.RandomString()
        ListFrame.Parent = Frame
        ListFrame.BackgroundColor3 = Color3.fromRGB(25, 27, 33)
        ListFrame.BackgroundTransparency = 1
        ListFrame.BorderSizePixel = 0
        ListFrame.Size = UDim2.new(1, 0, 0, Config.Height)
        ListFrame.ZIndex = ZI

        local Search = Instance.new('Frame')

        Search.Name = NeverLose.RandomString()
        Search.Parent = ListFrame
        Search.BackgroundColor3 = Color3.fromRGB(26, 28, 36)
        Search.BackgroundTransparency = 1
        Search.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Search.BorderSizePixel = 0
        Search.ClipsDescendants = true
        Search.Position = UDim2.new(0, 10, 0, 8)
        Search.Size = UDim2.new(1, -20, 0, 20)
        Search.ZIndex = ZI + 2

        local SearchCorner = Instance.new('UICorner')

        SearchCorner.CornerRadius = UDim.new(0, 4)
        SearchCorner.Parent = Search

        local SearchStroke = Instance.new('UIStroke')

        SearchStroke.Transparency = 1
        SearchStroke.Color = Color3.fromRGB(45, 48, 58)
        SearchStroke.Parent = Search

        local SearchIcon = Instance.new('TextLabel')

        SearchIcon.Name = NeverLose.RandomString()
        SearchIcon.Parent = Search
        SearchIcon.AnchorPoint = Vector2.new(0, 0.5)
        SearchIcon.BackgroundTransparency = 1
        SearchIcon.Position = UDim2.new(0, 5, 0.5, 0)
        SearchIcon.Size = UDim2.new(0, 14, 0, 14)
        SearchIcon.ZIndex = ZI + 3
        SearchIcon.FontFace = NeverLose.BuiltInBold
        SearchIcon.Text = 'magnifying-glass'
        SearchIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
        SearchIcon.TextSize = 12
        SearchIcon.TextTransparency = 1
        SearchIcon.TextWrapped = true

        local SearchBox = Instance.new('TextBox')

        SearchBox.Name = NeverLose.RandomString()
        SearchBox.Parent = Search
        SearchBox.AnchorPoint = Vector2.new(0, 0.5)
        SearchBox.BackgroundTransparency = 1
        SearchBox.BorderSizePixel = 0
        SearchBox.Position = UDim2.new(0, 23, 0.5, 0)
        SearchBox.Size = UDim2.new(1, -28, 0, 17)
        SearchBox.ZIndex = ZI + 3
        SearchBox.ClearTextOnFocus = false
        SearchBox.Font = Enum.Font.GothamMedium
        SearchBox.PlaceholderText = 'Search...'
        SearchBox.Text = ''
        SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        SearchBox.TextSize = 11
        SearchBox.TextTransparency = 1
        SearchBox.TextXAlignment = Enum.TextXAlignment.Left

        local Scroll = Instance.new('ScrollingFrame')

        Scroll.Name = NeverLose.RandomString()
        Scroll.Parent = ListFrame
        Scroll.Active = true
        Scroll.BackgroundTransparency = 1
        Scroll.BorderSizePixel = 0
        Scroll.Position = UDim2.new(0, 10, 0, 34)
        Scroll.Size = UDim2.new(1, -20, 1, -40)
        Scroll.ZIndex = ZI + 2
        Scroll.ScrollBarThickness = 2
        Scroll.ScrollBarImageColor3 = Color3.fromRGB(45, 48, 58)
        Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)

        local ScrollLayout = Instance.new('UIListLayout')

        ScrollLayout.Parent = Scroll
        ScrollLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        ScrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ScrollLayout.Padding = UDim.new(0, 3)

        NeverLose:AddSignal(ScrollLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(LPH_NO_VIRTUALIZE(function()
            Scroll.CanvasSize = UDim2.fromOffset(0, ScrollLayout.AbsoluteContentSize.Y)
        end)))

        local paints = {}

        local function keyOf(item)
            return (type(item) == 'table' and tostring(item.name)) or tostring(item)
        end
        local function isSelected(key)
            if Config.Multi then
                if type(Config.Default) ~= 'table' then
                    return false
                end

                return Config.Default[key] == true or table.find(Config.Default, key) ~= nil
            end

            return Config.Default == key
        end
        local function makeItem(item)
            local key = keyOf(item)
            local display = (type(item) == 'table' and item.display) and tostring(item.display) or key
            local ItemBtn = Instance.new('Frame')

            ItemBtn.Name = NeverLose.RandomString()
            ItemBtn.Parent = Scroll
            ItemBtn.BackgroundColor3 = Color3.fromRGB(26, 28, 36)
            ItemBtn.BackgroundTransparency = 1
            ItemBtn.BorderSizePixel = 0
            ItemBtn.ClipsDescendants = true
            ItemBtn.Size = UDim2.new(1, -2, 0, 30)
            ItemBtn.ZIndex = ZI + 3

            local ItemCorner = Instance.new('UICorner')

            ItemCorner.CornerRadius = UDim.new(0, 6)
            ItemCorner.Parent = ItemBtn

            local Avatar = Instance.new('ImageLabel')

            Avatar.Name = NeverLose.RandomString()
            Avatar.Parent = ItemBtn
            Avatar.AnchorPoint = Vector2.new(0, 0.5)
            Avatar.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
            Avatar.BorderSizePixel = 0
            Avatar.Position = UDim2.new(0, 4, 0.5, 0)
            Avatar.Size = UDim2.new(0, 24, 0, 24)
            Avatar.ZIndex = ZI + 4
            Avatar.ScaleType = Enum.ScaleType.Fit
            Avatar.Image = (type(item) == 'table' and item.image) or ((type(item) == 'table' and item.id) and ('rbxthumb://type=' .. Config.Thumb .. '&id=' .. tostring(item.id) .. '&w=150&h=150')) or ''

            local AvatarCorner = Instance.new('UICorner')

            AvatarCorner.CornerRadius = UDim.new(0, 4)
            AvatarCorner.Parent = Avatar

            local NameLabel = Instance.new('TextLabel')

            NameLabel.Name = NeverLose.RandomString()
            NameLabel.Parent = ItemBtn
            NameLabel.BackgroundTransparency = 1
            NameLabel.BorderSizePixel = 0
            NameLabel.ZIndex = ZI + 4
            NameLabel.Font = Enum.Font.GothamMedium
            NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            NameLabel.TextSize = 12
            NameLabel.TextTransparency = 0.35
            NameLabel.TextXAlignment = Enum.TextXAlignment.Left
            NameLabel.TextTruncate = Enum.TextTruncate.AtEnd

            local hasSub = (type(item) == 'table' and item.display ~= nil)

            if hasSub then
                NameLabel.Position = UDim2.new(0, 34, 0, 3)
                NameLabel.Size = UDim2.new(1, -40, 0, 14)
                NameLabel.Text = display

                local SubLabel = Instance.new('TextLabel')

                SubLabel.Name = NeverLose.RandomString()
                SubLabel.Parent = ItemBtn
                SubLabel.BackgroundTransparency = 1
                SubLabel.BorderSizePixel = 0
                SubLabel.Position = UDim2.new(0, 34, 0, 16)
                SubLabel.Size = UDim2.new(1, -40, 0, 11)
                SubLabel.ZIndex = ZI + 4
                SubLabel.Font = Enum.Font.GothamMedium
                SubLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                SubLabel.TextSize = 11
                SubLabel.TextTransparency = 0.55
                SubLabel.TextXAlignment = Enum.TextXAlignment.Left
                SubLabel.TextTruncate = Enum.TextTruncate.AtEnd
                SubLabel.Text = '@' .. key
            else
                NameLabel.AnchorPoint = Vector2.new(0, 0.5)
                NameLabel.Position = UDim2.new(0, 34, 0.5, 0)
                NameLabel.Size = UDim2.new(1, -40, 1, 0)
                NameLabel.Text = display
            end

            local function paint()
                if isSelected(key) then
                    NameLabel.TextColor3 = NeverLose.AccentColor
                    NameLabel.TextTransparency = 0
                else
                    NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                    NameLabel.TextTransparency = 0.35
                end
            end

            paint()
            table.insert(paints, paint)

            local btn = NeverLose:CreateInput(ItemBtn, LPH_NO_VIRTUALIZE(function()
                if Config.Multi then
                    if type(Config.Default) ~= 'table' then
                        Config.Default = {}
                    end

                    Config.Default[key] = not Config.Default[key]

                    paint()
                    Config.Callback(Config.Default)
                else
                    Config.Default = key

                    for _, p in ipairs(paints)do
                        p()
                    end

                    Config.Callback(Config.Default)
                end
            end))

            NeverLose:AddSignal(btn.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
                NeverLose.PlayAnimate(ItemBtn, SlowyTween, {BackgroundTransparency = 0.85})
            end)))
            NeverLose:AddSignal(btn.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
                NeverLose.PlayAnimate(ItemBtn, SlowyTween, {BackgroundTransparency = 1})
            end)))
        end
        local function render(filter)
            currentFilter = filter or ''

            for _, c in ipairs(Scroll:GetChildren())do
                if not c:IsA('UIListLayout') then
                    c:Destroy()
                end
            end

            table.clear(paints)

            local f = string.lower(currentFilter)
            local count = 0

            for _, item in ipairs(Config.Values)do
                local key = keyOf(item)
                local display = (type(item) == 'table' and item.display) and tostring(item.display) or key

                if f == '' or string.find(string.lower(display), f, 1, true) or string.find(string.lower(key), f, 1, true) then
                    count = count + 1

                    if count > MAX_RENDER then
                        break
                    end

                    makeItem(item)
                end
            end
        end

        local searchDelay = 0

        NeverLose:AddSignal(SearchBox:GetPropertyChangedSignal('Text'):Connect(LPH_NO_VIRTUALIZE(function()
            searchDelay = tick()

            local this = searchDelay

            task.delay(0.2, function()
                if this == searchDelay then
                    render(SearchBox.Text)
                end
            end)
        end)))

        ListLib.SetRender = LPH_NO_VIRTUALIZE(function(value)
            ListFrame.Visible = value

            if value then
                NeverLose.PlayAnimate(Search, SlowyTween, {BackgroundTransparency = 0})
                NeverLose.PlayAnimate(SearchStroke, SlowyTween, {Transparency = 0.65})
                NeverLose.PlayAnimate(SearchBox, SlowyTween, {TextTransparency = 0.35})
                NeverLose.PlayAnimate(SearchIcon, SlowyTween, {TextTransparency = 0.35})
            else
                NeverLose.PlayAnimate(Search, SlowyTween, {BackgroundTransparency = 1})
                NeverLose.PlayAnimate(SearchStroke, SlowyTween, {Transparency = 1})
                NeverLose.PlayAnimate(SearchBox, SlowyTween, {TextTransparency = 1})
                NeverLose.PlayAnimate(SearchIcon, SlowyTween, {TextTransparency = 1})
            end
        end)

        render()
        ListLib.SetRender(Signel:GetValue())
        Signel:Connect(ListLib.SetRender)

        function ListLib:Refresh()
            render(currentFilter)
        end
        function ListLib:SetValues(v)
            Config.Values = v or {}

            render(currentFilter)
        end
        function ListLib:SetData(v)
            Config.Values = v or {}

            render(currentFilter)
        end
        function ListLib:SetDefault(v)
            Config.Default = v

            for _, p in ipairs(paints)do
                p()
            end
        end
        function ListLib:SetValue(v)
            Config.Default = v

            for _, p in ipairs(paints)do
                p()
            end

            Config.Callback(Config.Default)
        end
        function ListLib:GetValue()
            return Config.Default
        end

        if Config.Flag then
            NeverLose.Flags[Config.Flag] = ListLib
        end

        return ListLib
    end
    function idx:AddImagePicker(rizz)
        rizz = NeverLose:ProcessParams(rizz, {
            Values = {},
            Columns = 3,
            Ratio = 1,
            Height = 230,
            Default = nil,
            Flag = nil,
            Callback = EmptyFunction,
        })
        local sigma = {}
        local etazh = LayerIndex + 8
        local kolonki = math.max(1, rizz.Columns)
        local babe = rizz.Default and tostring(rizz.Default)
        local palevo = Signel:GetValue()
        local zoopark = {}
        local skibidi = 0
        local bober = Instance.new('Frame')
        local shlepa = Instance.new('ScrollingFrame')
        local podushka = Instance.new('UIPadding')
        local tetris = Instance.new('UIGridLayout')
        bober.Name = NeverLose.RandomString()
        bober.Parent = Frame
        bober.BackgroundTransparency = 1
        bober.BorderSizePixel = 0
        bober.Size = UDim2.new(1, 0, 0, 16)
        bober.ZIndex = etazh
        shlepa.Name = NeverLose.RandomString()
        shlepa.Parent = bober
        shlepa.Active = true
        shlepa.BackgroundTransparency = 1
        shlepa.BorderSizePixel = 0
        shlepa.Position = UDim2.fromOffset(8, 6)
        shlepa.Size = UDim2.new(1, -16, 1, -12)
        shlepa.ZIndex = etazh + 2
        shlepa.CanvasSize = UDim2.new()
        shlepa.ScrollingDirection = Enum.ScrollingDirection.Y
        shlepa.ScrollBarThickness = 2
        shlepa.ScrollBarImageColor3 = Color3.fromRGB(45, 48, 58)
        shlepa.ScrollBarImageTransparency = palevo and 0 or 1
        podushka.PaddingTop = UDim.new(0, 2)
        podushka.PaddingBottom = UDim.new(0, 2)
        podushka.PaddingLeft = UDim.new(0, 2)
        podushka.PaddingRight = UDim.new(0, 2)
        podushka.Parent = shlepa
        tetris.Parent = shlepa
        tetris.CellPadding = UDim2.fromOffset(6, 6)
        tetris.FillDirectionMaxCells = kolonki
        tetris.HorizontalAlignment = Enum.HorizontalAlignment.Center
        tetris.SortOrder = Enum.SortOrder.LayoutOrder
        local function mewing()
            local tolstyak = math.max(1, math.floor((shlepa.AbsoluteSize.X - 4 - 6 * (kolonki - 1)) / kolonki))
            tetris.CellSize = UDim2.fromOffset(tolstyak, math.floor(tolstyak / rizz.Ratio))
        end
        local function kasha(salo)
            local grechka = 5381
            for i = 1, #salo do
                grechka = (grechka * 33 + string.byte(salo, i)) % 4294967296
            end
            return string.format('%08x', grechka)
        end
        local function gazan(portal, fotka)
            if not getcustomasset then
                return
            end
            if not isfolder('assets/pics') then
                makefolder('assets/pics')
            end
            local zanachka = 'assets/pics/' .. kasha(portal)
            local tropinka = (isfile(zanachka .. '.png') and zanachka .. '.png') or (isfile(zanachka .. '.jpg') and zanachka .. '.jpg')
            if not tropinka then
                local syrok = game:HttpGet(portal)
                local hvost = (string.sub(syrok, 1, 4) == '\137PNG' and '.png') or (string.sub(syrok, 1, 2) == '\255\216' and '.jpg')
                if not hvost then
                    return
                end
                tropinka = zanachka .. hvost
                writefile(tropinka, syrok)
            end
            fotka.Image = getcustomasset(tropinka)
        end
        local function sixseven(nechto, fotka)
            local shnurok = tostring(nechto or '')
            if string.match(shnurok, '^%d+$') then
                fotka.Image = 'rbxthumb://type=Asset&id=' .. shnurok .. '&w=420&h=420'
            elseif string.match(shnurok, '^https?://') and not string.find(shnurok, 'roblox.com', 1, true) then
                task.spawn(gazan, shnurok, fotka)
            else
                fotka.Image = shnurok
            end
        end
        local function yatebebudkuslomayu(klichka)
            local chel = zoopark[klichka]
            if chel then
                zoopark[klichka] = nil
                chel.tushka:Destroy()
            end
        end
        local function rozhay(pasport)
            local klichka = tostring(pasport.name)
            local chel = {pasport = pasport, sus = false}
            local furry = Instance.new('Frame')
            local ushki = Instance.new('UICorner')
            local aura = Instance.new('UIStroke')
            local npc = Instance.new('TextLabel')
            local fotka = Instance.new('ImageLabel')
            local kruglyash = Instance.new('UICorner')
            local tyma = Instance.new('Frame')
            local bublik = Instance.new('UICorner')
            local vaporwave = Instance.new('UIGradient')
            local tablichka = Instance.new('TextLabel')
            local based = Instance.new('Frame')
            local ponchik = Instance.new('UICorner')
            local kaif = Instance.new('TextLabel')
            yatebebudkuslomayu(klichka)
            skibidi = skibidi + 1
            chel.tushka = furry
            furry.Name = NeverLose.RandomString()
            furry.Parent = shlepa
            furry.BackgroundColor3 = Color3.fromRGB(26, 28, 36)
            furry.BackgroundTransparency = 1
            furry.BorderSizePixel = 0
            furry.LayoutOrder = skibidi
            furry.ZIndex = etazh + 3
            ushki.CornerRadius = UDim.new(0, 6)
            ushki.Parent = furry
            aura.Color = Color3.fromRGB(45, 48, 58)
            aura.Transparency = 1
            aura.Parent = furry
            npc.Name = NeverLose.RandomString()
            npc.Parent = furry
            npc.AnchorPoint = Vector2.new(0.5, 0.5)
            npc.BackgroundTransparency = 1
            npc.Position = UDim2.fromScale(0.5, 0.5)
            npc.Size = UDim2.fromOffset(20, 20)
            npc.ZIndex = etazh + 4
            npc.FontFace = NeverLose.BuiltInBold
            npc.Text = 'image'
            npc.TextColor3 = Color3.fromRGB(255, 255, 255)
            npc.TextSize = 18
            npc.TextTransparency = 1
            fotka.Name = NeverLose.RandomString()
            fotka.Parent = furry
            fotka.BackgroundTransparency = 1
            fotka.BorderSizePixel = 0
            fotka.Size = UDim2.fromScale(1, 1)
            fotka.ZIndex = etazh + 5
            fotka.ScaleType = Enum.ScaleType.Crop
            fotka.ImageTransparency = 1
            kruglyash.CornerRadius = UDim.new(0, 6)
            kruglyash.Parent = fotka
            tyma.Name = NeverLose.RandomString()
            tyma.Parent = furry
            tyma.AnchorPoint = Vector2.new(0, 1)
            tyma.BackgroundColor3 = Color3.fromRGB(9, 10, 14)
            tyma.BackgroundTransparency = 1
            tyma.BorderSizePixel = 0
            tyma.Position = UDim2.fromScale(0, 1)
            tyma.Size = UDim2.new(1, 0, 0, 24)
            tyma.ZIndex = etazh + 6
            bublik.CornerRadius = UDim.new(0, 6)
            bublik.Parent = tyma
            vaporwave.Rotation = 90
            vaporwave.Transparency = NumberSequence.new(1, 0.15)
            vaporwave.Parent = tyma
            tablichka.Name = NeverLose.RandomString()
            tablichka.Parent = furry
            tablichka.AnchorPoint = Vector2.new(0, 1)
            tablichka.BackgroundTransparency = 1
            tablichka.BorderSizePixel = 0
            tablichka.Position = UDim2.new(0, 6, 1, -4)
            tablichka.Size = UDim2.new(1, -12, 0, 12)
            tablichka.ZIndex = etazh + 7
            tablichka.Font = Enum.Font.GothamMedium
            tablichka.Text = klichka
            tablichka.TextColor3 = Color3.fromRGB(255, 255, 255)
            tablichka.TextSize = 11
            tablichka.TextTransparency = 1
            tablichka.TextTruncate = Enum.TextTruncate.AtEnd
            tablichka.TextXAlignment = Enum.TextXAlignment.Left
            based.Name = NeverLose.RandomString()
            based.Parent = furry
            based.AnchorPoint = Vector2.new(1, 0)
            based.BackgroundTransparency = 1
            based.BorderSizePixel = 0
            based.Position = UDim2.new(1, -5, 0, 5)
            based.Size = UDim2.fromOffset(16, 16)
            based.ZIndex = etazh + 7
            ponchik.CornerRadius = UDim.new(1, 0)
            ponchik.Parent = based
            kaif.Name = NeverLose.RandomString()
            kaif.Parent = based
            kaif.BackgroundTransparency = 1
            kaif.Size = UDim2.fromScale(1, 1)
            kaif.ZIndex = etazh + 8
            kaif.FontFace = NeverLose.BuiltInBold
            kaif.Text = 'check'
            kaif.TextColor3 = Color3.fromRGB(255, 255, 255)
            kaif.TextSize = 12
            kaif.TextTransparency = 1
            NeverLose:BindAccent(based, 'BackgroundColor3')
            sixseven(pasport.image, fotka)
            function chel.makeup()
                local neo = palevo and babe == klichka
                local sus = palevo and chel.sus
                NeverLose.PlayAnimate(furry, SlowyTween, {BackgroundTransparency = palevo and 0 or 1})
                NeverLose.PlayAnimate(aura, SlowyTween, {
                    Color = neo and NeverLose.AccentColor or Color3.fromRGB(45, 48, 58),
                    Transparency = (neo and 0) or (sus and 0.35) or (palevo and 0.65) or 1,
                })
                NeverLose.PlayAnimate(npc, SlowyTween, {TextTransparency = palevo and 0.8 or 1})
                NeverLose.PlayAnimate(fotka, SlowyTween, {ImageTransparency = ((neo or sus) and 0) or (palevo and 0.2) or 1})
                NeverLose.PlayAnimate(tyma, SlowyTween, {BackgroundTransparency = palevo and 0 or 1})
                NeverLose.PlayAnimate(tablichka, SlowyTween, {TextTransparency = ((neo or sus) and 0) or (palevo and 0.3) or 1})
                NeverLose.PlayAnimate(based, SlowyTween, {BackgroundTransparency = neo and 0 or 1})
                NeverLose.PlayAnimate(kaif, SlowyTween, {TextTransparency = neo and 0 or 1})
            end
            local tyk = NeverLose:CreateInput(furry, function()
                sigma:SetValue(klichka)
            end)
            NeverLose:AddSignal(tyk.MouseEnter:Connect(function()
                chel.sus = true
                chel.makeup()
            end))
            NeverLose:AddSignal(tyk.MouseLeave:Connect(function()
                chel.sus = false
                chel.makeup()
            end))
            zoopark[klichka] = chel
            chel.makeup()
        end
        function sigma.SetRender(nado)
            palevo = nado
            NeverLose.PlayAnimate(shlepa, SlowyTween, {ScrollBarImageTransparency = nado and 0 or 1})
            for _, chel in next, zoopark do
                chel.makeup()
            end
        end
        function sigma:Add(pasport)
            rozhay(pasport)
        end
        function sigma:Remove(klichka)
            yatebebudkuslomayu(tostring(klichka))
        end
        function sigma:SetValues(tusovka)
            for klichka in next, zoopark do
                yatebebudkuslomayu(klichka)
            end
            for _, pasport in ipairs(tusovka or {}) do
                rozhay(pasport)
            end
        end
        function sigma:GetValue()
            return babe
        end
        function sigma:SetValue(crush)
            local chel = zoopark[tostring(crush)]
            if not chel then
                return
            end
            local byvshaya = zoopark[babe]
            babe = tostring(crush)
            if byvshaya then
                byvshaya.makeup()
            end
            chel.makeup()
            if chel.pasport.callback then
                chel.pasport.callback(chel.pasport)
            end
            rizz.Callback(babe, chel.pasport)
        end
        NeverLose:AddSignal(shlepa:GetPropertyChangedSignal('AbsoluteSize'):Connect(mewing))
        NeverLose:AddSignal(tetris:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
            local dylda = tetris.AbsoluteContentSize.Y + 4
            shlepa.CanvasSize = UDim2.fromOffset(0, dylda)
            bober.Size = UDim2.new(1, 0, 0, math.min(dylda + 12, rizz.Height))
        end))
        mewing()
        sigma:SetValues(rizz.Values)
        Signel:Connect(sigma.SetRender)
        if rizz.Flag then
            NeverLose.Flags[rizz.Flag] = sigma
        end
        return sigma
    end

    return idx
end
function NeverLose:CreateWindow(Config)
    Config = NeverLose:ProcessParams(Config, {
        Logo = NeverLose.GlobalLogo,
        Name = 'Shitaro',
        Content = 'Murder Mustery 2',
        Size = UDim2.new(0, 640, 0, 480),
        ConfigFolder = 'ShitaroCfg',
        Enable3DRenderer = false,
        Keybind = 'Insert',
    })

    if NeverLose.IsMobile then
        Config.Size = NeverLose.Scales.Small
    end

    local Window = {
        Logo = Config.Logo,
        Name = Config.Name,
        Content = Config.Content,
        Size = Config.Size,
        ConfigFolder = Config.ConfigFolder,
        Signal = NeverLose:CreateSignal(true),
        Tabs = {},
        CurrentTab = 1,
        Keybind = Config.Keybind,
        Enable3DRenderer = Config.Enable3DRenderer,
    }

    NeverLose.GlobalLogo = Window.Logo

    local Logging = NeverLose:CreateLogger()

    if not isfolder(Window.ConfigFolder) then
        makefolder(Window.ConfigFolder)
    end

    local WindowFrame = Instance.new('Frame')
    local UICorner = Instance.new('UICorner')
    local LeftMenuFrame = Instance.new('Frame')
    local HeadFrame = Instance.new('Frame')
    local LogoImage = Instance.new('ImageLabel')
    local UICorner_2 = Instance.new('UICorner')
    local WindowName = Instance.new('TextLabel')
    local WindowContent = Instance.new('TextLabel')
    local LineFrame = Instance.new('Frame')
    local LeftScrollingFrame = Instance.new('ScrollingFrame')
    local UIListLayout = Instance.new('UIListLayout')
    local BottomFrame = Instance.new('Frame')
    local AccountProfile = Instance.new('ImageLabel')
    local UICorner_3 = Instance.new('UICorner')
    local AccountName = Instance.new('TextLabel')
    local ExpireLabel = Instance.new('TextLabel')
    local LineFrame_2 = Instance.new('Frame')
    local UserSettingButton = Instance.new('TextLabel')
    local RightMenuFrame = Instance.new('Frame')
    local UIStroke = Instance.new('UIStroke')
    local UICorner_4 = Instance.new('UICorner')
    local RightHeader = Instance.new('Frame')
    local LineFrame_3 = Instance.new('Frame')
    local ConfigFrame = Instance.new('Frame')
    local UIStroke_2 = Instance.new('UIStroke')
    local UICorner_5 = Instance.new('UICorner')
    local ConfigIcon = Instance.new('TextLabel')
    local LineFrame_4 = Instance.new('Frame')
    local ConfigName = Instance.new('TextLabel')
    local ConfigBthIcon = Instance.new('TextLabel')
    local SearchFrame = Instance.new('Frame')
    local SearchIcon = Instance.new('TextLabel')
    local SearchBox = Instance.new('TextBox')
    local TabContainer = Instance.new('Frame')

    WindowFrame.Name = NeverLose.RandomString()
    WindowFrame.Parent = NeverLose.ScreenGui
    WindowFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    WindowFrame.BackgroundColor3 = Color3.fromRGB(9, 10, 14)
    WindowFrame.BackgroundTransparency = 0.04
    WindowFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    WindowFrame.BorderSizePixel = 0
    WindowFrame.ClipsDescendants = true
    WindowFrame.Position = UDim2.new(255, 0, 255, 0)
    WindowFrame.Size = Window.Size
    WindowFrame.Active = true

    if not NeverLose.EnabledBlur then
        WindowFrame.BackgroundTransparency = 0.02
    end

    local BackgroundLayer
    local BackgroundAnimation
    local BackgroundAnimationToken = 0
    local BackgroundAnimationRunning = false
    local FuryEnabled = true
    local FuryScale = 0.8
    local animationAssets = {}

    local function UpdateBackgroundAnimationPosition()
        if not BackgroundAnimation or not WindowFrame.Parent then
            return
        end

        local absolutePosition = WindowFrame.AbsolutePosition
        local absoluteSize = WindowFrame.AbsoluteSize
        local baseSize = math.min(absoluteSize.Y * 0.72, absoluteSize.X * 0.55)
        local imageSize = math.floor(baseSize * FuryScale)

        BackgroundAnimation.Size = UDim2.fromOffset(imageSize, imageSize)
        BackgroundAnimation.Position = UDim2.fromOffset(absolutePosition.X + absoluteSize.X + math.floor(imageSize * 0.06), absolutePosition.Y + math.floor(imageSize * 0.38))
    end

    if getcustomasset then
        for index = 1, 3 do
            local assetOk, asset = pcall(getcustomasset, 'assets/fury_round_' .. index .. '.png')

            if assetOk and asset then
                table.insert(animationAssets, asset)
            end
        end

        if #animationAssets == 3 then
            if NeverLose.ScreenGui.DisplayOrder < 1 then
                NeverLose.ScreenGui.DisplayOrder = 1
            end

            BackgroundLayer = Instance.new('ScreenGui')
            BackgroundLayer.Name = NeverLose.RandomString()
            BackgroundLayer.IgnoreGuiInset = true
            BackgroundLayer.ResetOnSpawn = false
            BackgroundLayer.DisplayOrder = NeverLose.ScreenGui.DisplayOrder - 1
            BackgroundLayer.ZIndexBehavior = Enum.ZIndexBehavior.Global
            BackgroundLayer.Enabled = false

            ProtectGui(BackgroundLayer)

            BackgroundLayer.Parent = CoreGui
            BackgroundAnimation = Instance.new('ImageLabel')
            BackgroundAnimation.Name = NeverLose.RandomString()
            BackgroundAnimation.Parent = BackgroundLayer
            BackgroundAnimation.Active = false
            BackgroundAnimation.AnchorPoint = Vector2.new(1, 1)
            BackgroundAnimation.BackgroundTransparency = 1
            BackgroundAnimation.BorderSizePixel = 0
            BackgroundAnimation.Image = animationAssets[1]
            BackgroundAnimation.ImageRectOffset = Vector2.new(0, 0)
            BackgroundAnimation.ImageRectSize = Vector2.new(256, 256)
            BackgroundAnimation.ScaleType = Enum.ScaleType.Fit
            BackgroundAnimation.ZIndex = 1

            local backgroundCorner = Instance.new('UICorner')

            backgroundCorner.CornerRadius = UDim.new(0.16, 0)
            backgroundCorner.Parent = BackgroundAnimation

            NeverLose:AddSignal(WindowFrame:GetPropertyChangedSignal('AbsolutePosition'):Connect(UpdateBackgroundAnimationPosition))
            NeverLose:AddSignal(WindowFrame:GetPropertyChangedSignal('AbsoluteSize'):Connect(UpdateBackgroundAnimationPosition))
            NeverLose:AddSignal(NeverLose.ScreenGui.Destroying:Connect(function()
                if BackgroundLayer then
                    BackgroundLayer:Destroy()

                    BackgroundLayer = nil
                    BackgroundAnimation = nil
                end
            end))
            task.defer(UpdateBackgroundAnimationPosition)
            task.spawn(function()
                pcall(function()
                    game:GetService('ContentProvider'):PreloadAsync(animationAssets)
                end)
            end)
        end
    end

    local function SetBackgroundAnimationState(windowVisible)
        local enabled = windowVisible and FuryEnabled

        if not BackgroundAnimation or not BackgroundLayer then
            return
        end

        BackgroundLayer.Enabled = enabled

        if BackgroundAnimationRunning == enabled then
            return
        end

        BackgroundAnimationRunning = enabled

        BackgroundAnimationToken += 1

        local token = BackgroundAnimationToken

        if not enabled then
            return
        end

        task.spawn(function()
            local frame = 0

            while BackgroundAnimation and BackgroundLayer and BackgroundLayer.Enabled and BackgroundAnimationToken == token do
                local sheetIndex = math.floor(frame / 12) + 1
                local localFrame = frame % 12
                local row = math.floor(localFrame / 4)
                local column = localFrame % 4

                if BackgroundAnimation.Image ~= animationAssets[sheetIndex] then
                    BackgroundAnimation.Image = animationAssets[sheetIndex]
                end

                BackgroundAnimation.ImageRectOffset = Vector2.new(column * 256, row * 256)
                frame = (frame + 1) % 36

                task.wait(8.333333333333333E-2)
            end
        end)
    end

    function Window:SetFuryEnabled(value)
        FuryEnabled = value == true

        SetBackgroundAnimationState(Window.Signal:GetValue())
    end
    function Window:SetFuryScale(value)
        local scale = tonumber(value)

        if not scale or scale ~= scale then
            return
        end

        FuryScale = math.clamp(scale, 0.4, 1.25)

        UpdateBackgroundAnimationPosition()
    end

    NeverLose:AddSignal(Window.Signal:Connect(SetBackgroundAnimationState))
    task.delay(0.25, function()
        SetBackgroundAnimationState(Window.Signal:GetValue())
    end)

    local renderParentWindow = LPH_NO_VIRTUALIZE(function()
        if Window.__3DRender then
            if WindowFrame.BackgroundTransparency > 0.9 then
                WindowFrame.Visible = false
                WindowFrame.Parent = nil
            else
                WindowFrame.Visible = true

                NeverLose.PlayAnimate(WindowFrame, VSlowTween, {
                    Position = UDim2.fromScale(0.5, 0.5),
                })

                WindowFrame.Parent = Window.SurfaceGui
            end
        else
            if WindowFrame.Parent ~= NeverLose.ScreenGui then
                WindowFrame.Parent = NeverLose.ScreenGui
            end

            WindowFrame.Visible = WindowFrame.BackgroundTransparency <= 0.9
        end
    end)

    NeverLose:AddSignal(WindowFrame:GetPropertyChangedSignal('BackgroundTransparency'):Connect(renderParentWindow))

    Window.SetRender = LPH_NO_VIRTUALIZE(function(self, value)
        if value then
            NeverLose.PlayAnimate(WindowFrame, SlowyTween, {
                BackgroundTransparency = (NeverLose.EnabledBlur and 0.055) or 0.0255,
                Size = Window.Size,
            })
            NeverLose.PlayAnimate(LogoImage, SlowyTween, {ImageTransparency = 0})
            NeverLose.PlayAnimate(WindowName, SlowyTween, {TextTransparency = 0})
            NeverLose.PlayAnimate(WindowContent, SlowyTween, {TextTransparency = 0.65})
            NeverLose.PlayAnimate(LineFrame, SlowyTween, {BackgroundTransparency = 0.65})
            NeverLose.PlayAnimate(AccountProfile, SlowyTween, {ImageTransparency = 0})
            NeverLose.PlayAnimate(AccountName, SlowyTween, {TextTransparency = 0})
            NeverLose.PlayAnimate(ExpireLabel, SlowyTween, {TextTransparency = 0.65})
            NeverLose.PlayAnimate(LineFrame_2, SlowyTween, {BackgroundTransparency = 0.65})
            NeverLose.PlayAnimate(UserSettingButton, SlowyTween, {TextTransparency = 0.5})
            NeverLose.PlayAnimate(RightMenuFrame, SlowyTween, {BackgroundTransparency = 0.6})
            NeverLose.PlayAnimate(UIStroke, SlowyTween, {Transparency = 0.65})
            NeverLose.PlayAnimate(LineFrame_3, SlowyTween, {BackgroundTransparency = 0.65})
            NeverLose.PlayAnimate(ConfigFrame, SlowyTween, {BackgroundTransparency = 0.75})
            NeverLose.PlayAnimate(UIStroke_2, SlowyTween, {Transparency = 0.65})
            NeverLose.PlayAnimate(ConfigIcon, SlowyTween, {TextTransparency = 0.25})
            NeverLose.PlayAnimate(LineFrame_4, SlowyTween, {BackgroundTransparency = 0.65})
            NeverLose.PlayAnimate(ConfigName, SlowyTween, {TextTransparency = 0.35})
            NeverLose.PlayAnimate(ConfigBthIcon, SlowyTween, {TextTransparency = 0.25})
            NeverLose.PlayAnimate(SearchIcon, SlowyTween, {TextTransparency = 0.25})
            NeverLose.PlayAnimate(SearchBox, SlowyTween, {TextTransparency = 0.35})
            Window.Shadow:Render(true)
        else
            for _, tooltip in ipairs(NeverLose.AllToolTips)do
                pcall(function()
                    if tooltip.Hide then
                        tooltip.Hide()
                    else
                        tooltip.SetRender(false)
                    end
                end)
            end

            NeverLose.PlayAnimate(WindowFrame, SlowyTween, {
                BackgroundTransparency = 1,
                Size = Window.Size + UDim2.fromOffset(-15, -15),
            })
            NeverLose.PlayAnimate(LogoImage, SlowyTween, {ImageTransparency = 1})
            NeverLose.PlayAnimate(WindowName, SlowyTween, {TextTransparency = 1})
            NeverLose.PlayAnimate(WindowContent, SlowyTween, {TextTransparency = 1})
            NeverLose.PlayAnimate(LineFrame, SlowyTween, {BackgroundTransparency = 1})
            NeverLose.PlayAnimate(AccountProfile, SlowyTween, {ImageTransparency = 1})
            NeverLose.PlayAnimate(AccountName, SlowyTween, {TextTransparency = 1})
            NeverLose.PlayAnimate(ExpireLabel, SlowyTween, {TextTransparency = 1})
            NeverLose.PlayAnimate(LineFrame_2, SlowyTween, {BackgroundTransparency = 1})
            NeverLose.PlayAnimate(UserSettingButton, SlowyTween, {TextTransparency = 1})
            NeverLose.PlayAnimate(RightMenuFrame, SlowyTween, {BackgroundTransparency = 1})
            NeverLose.PlayAnimate(UIStroke, SlowyTween, {Transparency = 1})
            NeverLose.PlayAnimate(LineFrame_3, SlowyTween, {BackgroundTransparency = 1})
            NeverLose.PlayAnimate(ConfigFrame, SlowyTween, {BackgroundTransparency = 1})
            NeverLose.PlayAnimate(UIStroke_2, SlowyTween, {Transparency = 1})
            NeverLose.PlayAnimate(ConfigIcon, SlowyTween, {TextTransparency = 1})
            NeverLose.PlayAnimate(LineFrame_4, SlowyTween, {BackgroundTransparency = 1})
            NeverLose.PlayAnimate(ConfigName, SlowyTween, {TextTransparency = 1})
            NeverLose.PlayAnimate(ConfigBthIcon, SlowyTween, {TextTransparency = 1})
            NeverLose.PlayAnimate(SearchIcon, SlowyTween, {TextTransparency = 1})
            NeverLose.PlayAnimate(SearchBox, SlowyTween, {TextTransparency = 1})
            Window.Shadow:Render(false)
        end
    end)
    Window.Shadow = NeverLose:CreateShadow(WindowFrame)

    Window.Shadow:Render(false)
    task.delay(0.25, function()
        WindowFrame.Position = UDim2.new(0.5, 0, 0.5, 0)

        Window:SetRender(true)
        NeverLose:AddSignal(Window.Signal:Connect(LPH_NO_VIRTUALIZE(function(...)
            Window:SetRender(...)
        end)))
    end)

    if NeverLose.EnabledBlur then
        NeverLose:CreateBlurModule(WindowFrame, Window.Signal)
    end

    do
        local Frame = Instance.new('Frame')

        Frame.Parent = WindowFrame
        Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Frame.BorderSizePixel = 0
        Frame.Size = UDim2.new(1, 0, 0, 50)
        Frame.ZIndex = 7
        Frame.BackgroundTransparency = 1

        NeverLose.Drag(Frame, WindowFrame, 0.15)
    end

    UICorner.CornerRadius = UDim.new(0, 14)
    UICorner.Parent = WindowFrame

    local WindowStroke = Instance.new('UIStroke')

    WindowStroke.Color = Color3.fromRGB(40, 44, 56)
    WindowStroke.Transparency = 0.55
    WindowStroke.Thickness = 1.2
    WindowStroke.Parent = WindowFrame
    LeftMenuFrame.Name = NeverLose.RandomString()
    LeftMenuFrame.Parent = WindowFrame
    LeftMenuFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    LeftMenuFrame.BackgroundTransparency = 1
    LeftMenuFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    LeftMenuFrame.BorderSizePixel = 0
    LeftMenuFrame.Size = UDim2.new(0, 180, 1, 0)
    HeadFrame.Name = NeverLose.RandomString()
    HeadFrame.Parent = LeftMenuFrame
    HeadFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    HeadFrame.BackgroundTransparency = 1
    HeadFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    HeadFrame.BorderSizePixel = 0
    HeadFrame.Size = UDim2.new(1, 0, 0, 50)
    HeadFrame.ZIndex = 7
    LogoImage.Name = NeverLose.RandomString()
    LogoImage.Parent = HeadFrame
    LogoImage.AnchorPoint = Vector2.new(0, 0.5)
    LogoImage.BackgroundColor3 = Color3.fromRGB(20, 22, 28)
    LogoImage.BackgroundTransparency = 0
    LogoImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
    LogoImage.BorderSizePixel = 0
    LogoImage.Position = UDim2.new(0, 12, 0.5, 0)
    LogoImage.Size = UDim2.new(0, 34, 0, 34)
    LogoImage.ZIndex = 7
    LogoImage.Image = Window.Logo
    LogoImage.ImageColor3 = NeverLose.IconColor
    LogoImage.ScaleType = Enum.ScaleType.Fit
    UICorner_2.CornerRadius = UDim.new(0, 8)
    UICorner_2.Parent = LogoImage

    local LogoStroke = Instance.new('UIStroke')

    LogoStroke.Color = Color3.fromRGB(50, 55, 70)
    LogoStroke.Transparency = 0.5
    LogoStroke.Thickness = 1
    LogoStroke.Parent = LogoImage
    WindowName.Name = NeverLose.RandomString()
    WindowName.Parent = HeadFrame
    WindowName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    WindowName.BackgroundTransparency = 1
    WindowName.BorderColor3 = Color3.fromRGB(0, 0, 0)
    WindowName.BorderSizePixel = 0
    WindowName.Position = UDim2.new(0, 54, 0, 6)
    WindowName.Size = UDim2.new(1, -64, 0, 20)
    WindowName.ZIndex = 7
    WindowName.Font = Enum.Font.GothamBold
    WindowName.Text = Window.Name
    WindowName.TextColor3 = Color3.fromRGB(245, 247, 252)
    WindowName.TextSize = 16
    WindowName.TextXAlignment = Enum.TextXAlignment.Left
    WindowName.TextTruncate = Enum.TextTruncate.AtEnd
    WindowContent.Name = NeverLose.RandomString()
    WindowContent.Parent = HeadFrame
    WindowContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    WindowContent.BackgroundTransparency = 1
    WindowContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
    WindowContent.BorderSizePixel = 0
    WindowContent.Position = UDim2.new(0, 54, 0, 26)
    WindowContent.Size = UDim2.new(1, -64, 0, 14)
    WindowContent.ZIndex = 7
    WindowContent.Font = Enum.Font.Gotham
    WindowContent.Text = Window.Content
    WindowContent.TextColor3 = Color3.fromRGB(160, 168, 185)
    WindowContent.TextSize = 11
    WindowContent.TextTransparency = 0.25
    WindowContent.TextXAlignment = Enum.TextXAlignment.Left
    WindowContent.TextTruncate = Enum.TextTruncate.AtEnd
    LineFrame.Name = NeverLose.RandomString()
    LineFrame.Parent = HeadFrame
    LineFrame.AnchorPoint = Vector2.new(0.5, 1)
    LineFrame.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
    LineFrame.BackgroundTransparency = 0.55
    LineFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    LineFrame.BorderSizePixel = 0
    LineFrame.Position = UDim2.new(0.5, 0, 1, 0)
    LineFrame.Size = UDim2.new(1, -10, 0, 1)
    LineFrame.ZIndex = 5
    LeftScrollingFrame.Name = NeverLose.RandomString()
    LeftScrollingFrame.Parent = LeftMenuFrame
    LeftScrollingFrame.Active = true
    LeftScrollingFrame.AnchorPoint = Vector2.new(0.5, 0)
    LeftScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    LeftScrollingFrame.BackgroundTransparency = 1
    LeftScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    LeftScrollingFrame.BorderSizePixel = 0
    LeftScrollingFrame.Position = UDim2.new(0.5, 0, 0, 58)
    LeftScrollingFrame.Size = UDim2.new(1, -10, 1, -122)
    LeftScrollingFrame.ZIndex = 7
    LeftScrollingFrame.ScrollBarThickness = 0
    UIListLayout.Parent = LeftScrollingFrame
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 5)

    NeverLose:AddSignal(UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(LPH_NO_VIRTUALIZE(function()
        LeftScrollingFrame.CanvasSize = UDim2.fromOffset(0, UIListLayout.AbsoluteContentSize.Y + 1)
    end)))

    BottomFrame.Name = NeverLose.RandomString()
    BottomFrame.Parent = LeftMenuFrame
    BottomFrame.AnchorPoint = Vector2.new(0, 1)
    BottomFrame.BackgroundColor3 = Color3.fromRGB(12, 13, 18)
    BottomFrame.BackgroundTransparency = 0.35
    BottomFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    BottomFrame.BorderSizePixel = 0
    BottomFrame.Position = UDim2.new(0, 0, 1, 0)
    BottomFrame.Size = UDim2.new(1, 0, 0, 58)
    BottomFrame.ZIndex = 7
    BottomFrame.ClipsDescendants = true

    local BottomCorner = Instance.new('UICorner')

    BottomCorner.CornerRadius = UDim.new(0, 0)
    BottomCorner.Parent = BottomFrame

    local BottomStroke = Instance.new('UIStroke')

    BottomStroke.Color = Color3.fromRGB(45, 48, 58)
    BottomStroke.Transparency = 0.7
    BottomStroke.Thickness = 1
    BottomStroke.Parent = BottomFrame
    AccountProfile.Name = NeverLose.RandomString()
    AccountProfile.Parent = BottomFrame
    AccountProfile.AnchorPoint = Vector2.new(0, 0.5)
    AccountProfile.BackgroundColor3 = Color3.fromRGB(20, 22, 28)
    AccountProfile.BackgroundTransparency = 0
    AccountProfile.BorderColor3 = Color3.fromRGB(0, 0, 0)
    AccountProfile.BorderSizePixel = 0
    AccountProfile.Position = UDim2.new(0, 12, 0.5, 0)
    AccountProfile.Size = UDim2.new(0, 36, 0, 36)
    AccountProfile.ZIndex = 8
    AccountProfile.ScaleType = Enum.ScaleType.Crop
    AccountProfile.Image = NeverLose.UserProfile or ''
    UICorner_3.CornerRadius = UDim.new(1, 0)
    UICorner_3.Parent = AccountProfile

    local AvatarStroke = Instance.new('UIStroke')

    AvatarStroke.Color = Color3.fromRGB(55, 60, 75)
    AvatarStroke.Transparency = 0.45
    AvatarStroke.Thickness = 1.25
    AvatarStroke.Parent = AccountProfile
    AccountName.Name = NeverLose.RandomString()
    AccountName.Parent = BottomFrame
    AccountName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    AccountName.BackgroundTransparency = 1
    AccountName.BorderColor3 = Color3.fromRGB(0, 0, 0)
    AccountName.BorderSizePixel = 0
    AccountName.Position = UDim2.new(0, 56, 0, 10)
    AccountName.Size = UDim2.new(1, -90, 0, 18)
    AccountName.ZIndex = 8
    AccountName.Font = Enum.Font.GothamBold
    AccountName.Text = LocalPlayer.DisplayName or LocalPlayer.Name
    AccountName.TextColor3 = Color3.fromRGB(240, 242, 248)
    AccountName.TextSize = 13
    AccountName.TextXAlignment = Enum.TextXAlignment.Left
    AccountName.TextTruncate = Enum.TextTruncate.AtEnd
    AccountName.TextTransparency = 0.05
    ExpireLabel.Name = NeverLose.RandomString()
    ExpireLabel.Parent = BottomFrame
    ExpireLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ExpireLabel.BackgroundTransparency = 1
    ExpireLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ExpireLabel.BorderSizePixel = 0
    ExpireLabel.Position = UDim2.new(0, 56, 0, 28)
    ExpireLabel.Size = UDim2.new(1, -90, 0, 14)
    ExpireLabel.ZIndex = 8
    ExpireLabel.Font = Enum.Font.Gotham
    ExpireLabel.Text = 'Lifetime'
    ExpireLabel.TextColor3 = NeverLose.AccentColor
    ExpireLabel.TextSize = 11
    ExpireLabel.TextTransparency = 0.15
    ExpireLabel.TextXAlignment = Enum.TextXAlignment.Left
    LineFrame_2.Name = NeverLose.RandomString()
    LineFrame_2.Parent = BottomFrame
    LineFrame_2.AnchorPoint = Vector2.new(0.5, 0)
    LineFrame_2.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
    LineFrame_2.BackgroundTransparency = 0.55
    LineFrame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
    LineFrame_2.BorderSizePixel = 0
    LineFrame_2.Position = UDim2.new(0.5, 0, 0, 0)
    LineFrame_2.Size = UDim2.new(1, -8, 0, 1)
    LineFrame_2.ZIndex = 6
    UserSettingButton.Name = NeverLose.RandomString()
    UserSettingButton.Parent = BottomFrame
    UserSettingButton.AnchorPoint = Vector2.new(1, 0.5)
    UserSettingButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    UserSettingButton.BackgroundTransparency = 1
    UserSettingButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
    UserSettingButton.BorderSizePixel = 0
    UserSettingButton.Position = UDim2.new(1, -10, 0.5, 0)
    UserSettingButton.Size = UDim2.new(0, 22, 0, 22)
    UserSettingButton.ZIndex = 8
    UserSettingButton.FontFace = NeverLose.BuiltInBold
    UserSettingButton.Text = 'chevron-large-right'
    UserSettingButton.TextColor3 = Color3.fromRGB(180, 185, 200)
    UserSettingButton.TextSize = 14
    UserSettingButton.TextTransparency = 0.35

    NeverLose:AddSignal(BottomFrame.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
        NeverLose.PlayAnimate(UserSettingButton, SlowyTween, {
            TextTransparency = 0.05,
            TextColor3 = NeverLose.AccentColor,
        })
        NeverLose.PlayAnimate(BottomFrame, SlowyTween, {BackgroundTransparency = 0.2})
    end)))
    NeverLose:AddSignal(BottomFrame.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
        NeverLose.PlayAnimate(UserSettingButton, SlowyTween, {
            TextTransparency = 0.35,
            TextColor3 = Color3.fromRGB(180, 185, 200),
        })
        NeverLose.PlayAnimate(BottomFrame, SlowyTween, {BackgroundTransparency = 0.35})
    end)))

    RightMenuFrame.Name = NeverLose.RandomString()
    RightMenuFrame.Parent = WindowFrame
    RightMenuFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 13)
    RightMenuFrame.BackgroundTransparency = 0.6
    RightMenuFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    RightMenuFrame.BorderSizePixel = 0
    RightMenuFrame.ClipsDescendants = true
    RightMenuFrame.Position = UDim2.new(0, 180, 0, 0)
    RightMenuFrame.Size = UDim2.new(1, -180, 1, 0)
    RightMenuFrame.ZIndex = 8
    UIStroke.Transparency = 0.6
    UIStroke.Color = Color3.fromRGB(38, 42, 54)
    UIStroke.Thickness = 1
    UIStroke.Parent = RightMenuFrame
    UICorner_4.CornerRadius = UDim.new(0, 12)
    UICorner_4.Parent = RightMenuFrame
    RightHeader.Name = NeverLose.RandomString()
    RightHeader.Parent = RightMenuFrame
    RightHeader.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    RightHeader.BackgroundTransparency = 1
    RightHeader.BorderColor3 = Color3.fromRGB(0, 0, 0)
    RightHeader.BorderSizePixel = 0
    RightHeader.Size = UDim2.new(1, 0, 0, 50)
    RightHeader.ZIndex = 9
    LineFrame_3.Name = NeverLose.RandomString()
    LineFrame_3.Parent = RightHeader
    LineFrame_3.AnchorPoint = Vector2.new(0.5, 1)
    LineFrame_3.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
    LineFrame_3.BackgroundTransparency = 0.65
    LineFrame_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
    LineFrame_3.BorderSizePixel = 0
    LineFrame_3.Position = UDim2.new(0.5, 0, 1, 0)
    LineFrame_3.Size = UDim2.new(1, -10, 0, 1)
    LineFrame_3.ZIndex = 9
    ConfigFrame.Name = NeverLose.RandomString()
    ConfigFrame.Parent = RightHeader
    ConfigFrame.AnchorPoint = Vector2.new(0, 0.5)
    ConfigFrame.BackgroundColor3 = Color3.fromRGB(13, 17, 22)
    ConfigFrame.BackgroundTransparency = 0.75
    ConfigFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ConfigFrame.BorderSizePixel = 0
    ConfigFrame.Position = UDim2.new(0, 10, 0.5, 0)
    ConfigFrame.Size = UDim2.new(0, 115, 0, 30)
    ConfigFrame.ZIndex = 9
    UIStroke_2.Transparency = 0.65
    UIStroke_2.Color = Color3.fromRGB(45, 48, 58)
    UIStroke_2.Parent = ConfigFrame
    UICorner_5.CornerRadius = UDim.new(0, 4)
    UICorner_5.Parent = ConfigFrame
    ConfigIcon.Name = NeverLose.RandomString()
    ConfigIcon.Parent = ConfigFrame
    ConfigIcon.AnchorPoint = Vector2.new(0, 0.5)
    ConfigIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ConfigIcon.BackgroundTransparency = 1
    ConfigIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ConfigIcon.BorderSizePixel = 0
    ConfigIcon.Position = UDim2.new(0, 2, 0.5, 0)
    ConfigIcon.Size = UDim2.new(0, 25, 0, 25)
    ConfigIcon.ZIndex = 9
    ConfigIcon.FontFace = NeverLose.BuiltInBold
    ConfigIcon.Text = 'floppy-disk'
    ConfigIcon.TextColor3 = Color3.fromRGB(223, 223, 223)
    ConfigIcon.TextSize = 16
    ConfigIcon.TextTransparency = 0.25
    ConfigIcon.TextWrapped = true
    LineFrame_4.Name = NeverLose.RandomString()
    LineFrame_4.Parent = ConfigFrame
    LineFrame_4.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
    LineFrame_4.BackgroundTransparency = 0.65
    LineFrame_4.BorderColor3 = Color3.fromRGB(0, 0, 0)
    LineFrame_4.BorderSizePixel = 0
    LineFrame_4.Position = UDim2.new(0, 30, 0, 0)
    LineFrame_4.Size = UDim2.new(0, 1, 1, 0)
    ConfigName.Name = NeverLose.RandomString()
    ConfigName.Parent = ConfigFrame
    ConfigName.AnchorPoint = Vector2.new(0, 0.5)
    ConfigName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ConfigName.BackgroundTransparency = 1
    ConfigName.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ConfigName.BorderSizePixel = 0
    ConfigName.Position = UDim2.new(0, 40, 0.5, 0)
    ConfigName.Size = UDim2.new(1, -7, 0, 15)
    ConfigName.ZIndex = 9
    ConfigName.Font = Enum.Font.GothamMedium
    ConfigName.Text = 'Default'
    ConfigName.TextColor3 = Color3.fromRGB(255, 255, 255)
    ConfigName.TextSize = 12
    ConfigName.TextTransparency = 0.35
    ConfigName.TextXAlignment = Enum.TextXAlignment.Left
    ConfigBthIcon.Name = NeverLose.RandomString()
    ConfigBthIcon.Parent = ConfigFrame
    ConfigBthIcon.AnchorPoint = Vector2.new(1, 0.5)
    ConfigBthIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ConfigBthIcon.BackgroundTransparency = 1
    ConfigBthIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ConfigBthIcon.BorderSizePixel = 0
    ConfigBthIcon.Position = UDim2.new(1, -2, 0.5, 0)
    ConfigBthIcon.Size = UDim2.new(0, 25, 0, 25)
    ConfigBthIcon.ZIndex = 9
    ConfigBthIcon.FontFace = NeverLose.BuiltInBold
    ConfigBthIcon.Text = 'chevron-small-down'
    ConfigBthIcon.TextColor3 = Color3.fromRGB(223, 223, 223)
    ConfigBthIcon.TextSize = 16
    ConfigBthIcon.TextTransparency = 0.25
    ConfigBthIcon.TextWrapped = true
    SearchFrame.Name = NeverLose.RandomString()
    SearchFrame.Parent = RightHeader
    SearchFrame.AnchorPoint = Vector2.new(1, 0.5)
    SearchFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SearchFrame.BackgroundTransparency = 1
    SearchFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    SearchFrame.BorderSizePixel = 0
    SearchFrame.ClipsDescendants = true
    SearchFrame.Position = UDim2.new(1, -10, 0.5, 0)
    SearchFrame.Size = UDim2.new(0, 30, 0, 30)
    SearchFrame.ZIndex = 12
    SearchIcon.Name = NeverLose.RandomString()
    SearchIcon.Parent = SearchFrame
    SearchIcon.AnchorPoint = Vector2.new(0, 0.5)
    SearchIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SearchIcon.BackgroundTransparency = 1
    SearchIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
    SearchIcon.BorderSizePixel = 0
    SearchIcon.Position = UDim2.new(0, 2, 0.5, 0)
    SearchIcon.Size = UDim2.new(0, 25, 0, 25)
    SearchIcon.ZIndex = 12
    SearchIcon.FontFace = NeverLose.BuiltInBold
    SearchIcon.Text = 'magnifying-glass'
    SearchIcon.TextColor3 = Color3.fromRGB(223, 223, 223)
    SearchIcon.TextSize = 14
    SearchIcon.TextTransparency = 0.45
    SearchIcon.TextWrapped = true
    SearchBox.Name = NeverLose.RandomString()
    SearchBox.Parent = SearchFrame
    SearchBox.AnchorPoint = Vector2.new(0, 0.5)
    SearchBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SearchBox.BackgroundTransparency = 1
    SearchBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
    SearchBox.BorderSizePixel = 0
    SearchBox.Position = UDim2.new(0, 35, 0.5, 0)
    SearchBox.Size = UDim2.new(1, -35, 0, 25)
    SearchBox.ZIndex = 12
    SearchBox.ClearTextOnFocus = false
    SearchBox.Font = Enum.Font.GothamMedium
    SearchBox.PlaceholderText = 'Search'
    SearchBox.Text = ''
    SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    SearchBox.TextSize = 13
    SearchBox.TextTransparency = 1
    SearchBox.TextXAlignment = Enum.TextXAlignment.Left
    TabContainer.Name = NeverLose.RandomString()
    TabContainer.Parent = RightMenuFrame
    TabContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TabContainer.BackgroundTransparency = 1
    TabContainer.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TabContainer.BorderSizePixel = 0
    TabContainer.ClipsDescendants = true
    TabContainer.Position = UDim2.new(0, 0, 0, 50)
    TabContainer.Size = UDim2.new(1, 0, 1, -50)
    TabContainer.ZIndex = 5

    do
        Window.Searching = false

        local Input = NeverLose:CreateInput(SearchIcon, LPH_NO_VIRTUALIZE(function()
            Window.Searching = not Window.Searching

            if Window.Searching then
                NeverLose.PlayAnimate(SearchFrame, VSlowTween, {
                    Size = UDim2.new(0, 220, 0, 30),
                })
                NeverLose.PlayAnimate(SearchIcon, SlowyTween, {TextTransparency = 0.25})
                NeverLose.PlayAnimate(SearchBox, VSlowTween, {TextTransparency = 0.35})
            else
                NeverLose.PlayAnimate(SearchFrame, VSlowTween, {
                    Size = UDim2.new(0, 30, 0, 30),
                })
                NeverLose.PlayAnimate(SearchIcon, SlowyTween, {TextTransparency = 0.45})
                NeverLose.PlayAnimate(SearchBox, SlowyTween, {TextTransparency = 1})

                SearchBox.Text = ''
            end
        end))
        local wati_for_finish = tick()
        local last_thread
        local max_time = 0.2

        NeverLose:AddSignal(SearchBox:GetPropertyChangedSignal('Text'):Connect(LPH_NO_VIRTUALIZE(function()
            if not SearchBox.Text:byte() then
                for i, v in next, NeverLose.NameRegisitry do
                    v.Root.Visible = true
                end

                return
            end

            wati_for_finish = tick()

            if last_thread then
                task.cancel(last_thread)

                last_thread = nil
            end

            last_thread = task.delay(max_time, function()
                if SearchBox.Text:byte() and (tick() - wati_for_finish) > max_time then
                    for i, v in next, NeverLose.NameRegisitry do
                        if string.find(string.lower(v.Idx), string.lower(SearchBox.Text), 1, true) then
                            v.Root.Visible = true
                        else
                            v.Root.Visible = false
                        end
                    end
                end
            end)
        end)))
        NeverLose:AddSignal(Input.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
            NeverLose.PlayAnimate(SearchIcon, SlowyTween, {TextTransparency = 0.25})
        end)))
        NeverLose:AddSignal(Input.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
            if Window.Searching then
                NeverLose.PlayAnimate(SearchIcon, SlowyTween, {TextTransparency = 0.25})
            else
                NeverLose.PlayAnimate(SearchIcon, SlowyTween, {TextTransparency = 0.45})
            end
        end)))
    end

    if Window.Enable3DRenderer then
        local Part = Instance.new('Part')

        Part.Name = NeverLose.RandomString()
        Part.Anchored = true
        Part.Transparency = 1
        Part.CanCollide = false
        Part.CanTouch = false
        Part.AudioCanCollide = false
        Part.CollisionGroup = NeverLose.RandomString()
        Part.CFrame = CFrame.new(0, 0, 0)
        Part.Size = Vector3.zero

        local SurfaceGui = Instance.new('SurfaceGui')

        SurfaceGui.Parent = NeverLose.ScreenGui
        SurfaceGui.Adornee = Part
        SurfaceGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        SurfaceGui.AlwaysOnTop = true
        SurfaceGui.LightInfluence = 1
        SurfaceGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
        SurfaceGui.SizingMode = Enum.SurfaceGuiSizingMode.FixedSize
        SurfaceGui.PixelsPerStud = 40
        Window.SurfaceGui = SurfaceGui
        NeverLose.GlobalSurfaceGui = SurfaceGui

        local PerfectScale = Vector2.new(1920, 1380)

        Window.Load3DBlock = LPH_NO_VIRTUALIZE(function()
            if not Window.Signal:GetValue() then
                local _, OnScreen = CurrentCamera:WorldToViewportPoint(Part.Position)

                if OnScreen then
                    NeverLose.PlayAnimate(Part, VSlowTween, {
                        CFrame = CurrentCamera.CFrame * CFrame.new(0, 0, -15) * CFrame.Angles(0, math.rad(180), 0),
                    })
                end

                return
            end

            local Dimensions = 50
            local XY_Incom = Vector2.new(PerfectScale.X + 5, PerfectScale.Y * 1.35) / (Dimensions / 2)
            local PerfectDistance = XY_Incom.Magnitude
            local SizeIndicator = PerfectDistance / 1.35

            Part.Parent = NeverLose.BlurModuleParent or workspace

            NeverLose.PlayAnimate(Part, VSlowTween, {
                CFrame = (CurrentCamera.CFrame * CFrame.new(0, 0, -25)) * CFrame.Angles(0, math.rad(180), 0),
            })

            Part.Size = Vector3.new(PerfectScale.X / SizeIndicator, PerfectScale.Y / SizeIndicator, 0)
        end)

        function Window:Set3DRender(val)
            Window.__3DRender = val
            NeverLose.Global3DRenderMode = val

            if val then
                Window.Load3DBlock()
            else
                Part.Parent = nil
            end

            renderParentWindow()
        end
    end

    function Window:AddTabLabel(Name: string)
        local TabLabel = Instance.new('TextLabel')

        TabLabel.Name = NeverLose.RandomString()
        TabLabel.Parent = LeftScrollingFrame
        TabLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TabLabel.BackgroundTransparency = 1
        TabLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
        TabLabel.BorderSizePixel = 0
        TabLabel.Size = UDim2.new(1, -7, 0, 15)
        TabLabel.ZIndex = 8
        TabLabel.Font = Enum.Font.GothamMedium
        TabLabel.Text = Name
        TabLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabLabel.TextSize = 11
        TabLabel.TextTransparency = 0.5
        TabLabel.TextXAlignment = Enum.TextXAlignment.Left

        local SetRender = LPH_NO_VIRTUALIZE(function(val)
            if val then
                NeverLose.PlayAnimate(TabLabel, SlowyTween, {TextTransparency = 0.5})
            else
                NeverLose.PlayAnimate(TabLabel, SlowyTween, {TextTransparency = 1})
            end
        end)

        SetRender(Window.Signal:GetValue())

        return Window.Signal:Connect(SetRender)
    end
    function Window:AddTab(Config)
        Config = NeverLose:ProcessParams(Config, {
            Icon = 'crosshairs',
            Name = 'Tab',
            Type = 'Double',
        })

        local Tab = {
            Signal = NeverLose:CreateSignal(false),
        }
        local TabButton = Instance.new('Frame')
        local UICorner = Instance.new('UICorner')
        local TabIcon = Instance.new('TextLabel')
        local TabContentLabel = Instance.new('TextLabel')

        Tab.Idx = TabButton
        TabButton.Name = NeverLose.RandomString()
        TabButton.Parent = LeftScrollingFrame
        TabButton.BackgroundColor3 = Color3.fromRGB(41, 45, 49)
        TabButton.BackgroundTransparency = 0.5
        TabButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
        TabButton.BorderSizePixel = 0
        TabButton.Size = UDim2.new(1, -1, 0, 30)
        TabButton.ZIndex = 8
        UICorner.CornerRadius = UDim.new(0, 6)
        UICorner.Parent = TabButton
        TabIcon.Name = NeverLose.RandomString()
        TabIcon.Parent = TabButton
        TabIcon.AnchorPoint = Vector2.new(0, 0.5)
        TabIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TabIcon.BackgroundTransparency = 1
        TabIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
        TabIcon.BorderSizePixel = 0
        TabIcon.Position = UDim2.new(0, 2, 0.5, 0)
        TabIcon.Size = UDim2.new(0, 25, 0, 25)
        TabIcon.ZIndex = 9
        TabIcon.FontFace = NeverLose.BuiltInBold

        local __tabIcon = tostring(Config.Icon)
        local TabImage = nil

        if string.match(__tabIcon, '^%d+$') then
            TabIcon.Text = ''
            TabImage = Instance.new('ImageLabel')
            TabImage.Name = NeverLose.RandomString()
            TabImage.Parent = TabButton
            TabImage.AnchorPoint = Vector2.new(0, 0.5)
            TabImage.BackgroundTransparency = 1
            TabImage.BorderSizePixel = 0
            TabImage.Position = UDim2.new(0, 4, 0.5, 0)
            TabImage.Size = UDim2.new(0, 20, 0, 20)
            TabImage.ZIndex = 9
            TabImage.Image = 'rbxassetid://' .. __tabIcon
            TabImage.ImageColor3 = Color3.fromRGB(252, 252, 252)
            TabImage.ImageTransparency = 1
        else
            TabIcon.Text = __tabIcon
        end

        TabIcon.TextColor3 = NeverLose.AccentColor
        TabIcon.TextSize = 16
        TabIcon.TextWrapped = true
        TabContentLabel.Name = NeverLose.RandomString()
        TabContentLabel.Parent = TabButton
        TabContentLabel.AnchorPoint = Vector2.new(0, 0.5)
        TabContentLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TabContentLabel.BackgroundTransparency = 1
        TabContentLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
        TabContentLabel.BorderSizePixel = 0
        TabContentLabel.Position = UDim2.new(0, 30, 0.5, 0)
        TabContentLabel.Size = UDim2.new(1, -7, 0, 15)
        TabContentLabel.ZIndex = 9
        TabContentLabel.Font = Enum.Font.GothamMedium
        TabContentLabel.Text = Config.Name
        TabContentLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabContentLabel.TextSize = 12
        TabContentLabel.TextXAlignment = Enum.TextXAlignment.Left

        local TabFrame = Instance.new('Frame')
        local LeftScroll = Instance.new('ScrollingFrame')
        local UIListLayout = Instance.new('UIListLayout')
        local RightScroll = Instance.new('ScrollingFrame')
        local UIListLayout_2 = Instance.new('UIListLayout')

        TabFrame.Name = NeverLose.RandomString()
        TabFrame.Parent = TabContainer
        TabFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        TabFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TabFrame.BackgroundTransparency = 1
        TabFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
        TabFrame.BorderSizePixel = 0
        TabFrame.ClipsDescendants = true
        TabFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        TabFrame.Size = UDim2.new(1, 0, 1, 0)
        TabFrame.Visible = false
        LeftScroll.Name = NeverLose.RandomString()
        LeftScroll.Parent = TabFrame
        LeftScroll.Active = true
        LeftScroll.AnchorPoint = Vector2.new(0.5, 0.5)
        LeftScroll.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        LeftScroll.BackgroundTransparency = 1
        LeftScroll.BorderColor3 = Color3.fromRGB(0, 0, 0)
        LeftScroll.BorderSizePixel = 0
        LeftScroll.ClipsDescendants = false
        LeftScroll.Position = UDim2.new(0.25, 0, 0.5, 0)
        LeftScroll.Size = UDim2.new(0.5, 0, 1, -5)
        LeftScroll.ScrollBarThickness = 0
        UIListLayout.Parent = LeftScroll
        UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.Padding = UDim.new(0, 5)

        NeverLose:AddSignal(UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(LPH_NO_VIRTUALIZE(function()
            LeftScroll.CanvasSize = UDim2.fromOffset(0, UIListLayout.AbsoluteContentSize.Y + 1)
        end)))

        RightScroll.Name = NeverLose.RandomString()
        RightScroll.Parent = TabFrame
        RightScroll.Active = true
        RightScroll.AnchorPoint = Vector2.new(0.5, 0.5)
        RightScroll.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        RightScroll.BackgroundTransparency = 1
        RightScroll.BorderColor3 = Color3.fromRGB(0, 0, 0)
        RightScroll.BorderSizePixel = 0
        RightScroll.ClipsDescendants = false
        RightScroll.Position = UDim2.new(0.75, 0, 0.5, 0)
        RightScroll.Size = UDim2.new(0.5, 0, 1, -5)
        RightScroll.ScrollBarThickness = 0
        UIListLayout_2.Parent = RightScroll
        UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout_2.Padding = UDim.new(0, 5)

        if Config.Type == 'Single' then
            UIListLayout_2:Destroy()
            RightScroll:Destroy()

            RightScroll = LeftScroll
            UIListLayout_2 = UIListLayout
            LeftScroll.Size = UDim2.new(1, 0, 1, -5)
            LeftScroll.Position = UDim2.new(0.5, 0, 0.5, 0)
        else
            NeverLose:AddSignal(UIListLayout_2:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(LPH_NO_VIRTUALIZE(function()
                RightScroll.CanvasSize = UDim2.fromOffset(0, UIListLayout_2.AbsoluteContentSize.Y + 1)
            end)))
        end

        NeverLose:AddSignal(TabIcon:GetPropertyChangedSignal('TextTransparency'):Connect(LPH_NO_VIRTUALIZE(function()
            TabFrame.Visible = TabIcon.TextTransparency <= 0.4
        end)))

        Tab.SetValue = LPH_NO_VIRTUALIZE(function(value)
            if Tab.__elrendered ~= value then
                Tab.__elrendered = value

                Tab.Signal:SetValue(value)
            end
            if value then
                TabFrame.Visible = true

                NeverLose.PlayAnimate(TabButton, SlowyTween, {BackgroundTransparency = 0.5})
                NeverLose.PlayAnimate(TabIcon, SlowyTween, {
                    TextTransparency = 0,
                    TextColor3 = NeverLose.AccentColor,
                })

                if TabImage then
                    NeverLose.PlayAnimate(TabImage, SlowyTween, {
                        ImageTransparency = 0,
                        ImageColor3 = NeverLose.AccentColor,
                    })
                end

                NeverLose.PlayAnimate(TabContentLabel, SlowyTween, {TextTransparency = 0})
            else
                NeverLose.PlayAnimate(TabButton, SlowyTween, {BackgroundTransparency = 1})
                NeverLose.PlayAnimate(TabIcon, SlowyTween, {
                    TextTransparency = 0.5,
                    TextColor3 = Color3.fromRGB(252, 252, 252),
                })

                if TabImage then
                    NeverLose.PlayAnimate(TabImage, SlowyTween, {
                        ImageTransparency = 0.5,
                        ImageColor3 = Color3.fromRGB(252, 252, 252),
                    })
                end

                NeverLose.PlayAnimate(TabContentLabel, SlowyTween, {TextTransparency = 0.5})
            end
        end)

        table.insert(Window.Tabs, Tab)

        if Window.Tabs[Window.CurrentTab] == Tab then
            Tab.SetValue(true)
        else
            Tab.SetValue(false)
        end

        local over = NeverLose:CreateInput(TabButton, LPH_NO_VIRTUALIZE(function()
            for i, v in next, Window.Tabs do
                if v.Idx == TabButton then
                    v.SetValue(true)

                    Window.CurrentTab = i
                else
                    v.SetValue(false)
                end
            end
        end))

        NeverLose:AddSignal(over.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
            if Window.Tabs[Window.CurrentTab] == Tab then
                NeverLose.PlayAnimate(TabButton, SlowyTween, {BackgroundTransparency = 0.5})
            else
                NeverLose.PlayAnimate(TabButton, SlowyTween, {BackgroundTransparency = 0.8})
            end
        end)))
        NeverLose:AddSignal(over.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
            if Window.Tabs[Window.CurrentTab] == Tab then
                NeverLose.PlayAnimate(TabButton, SlowyTween, {BackgroundTransparency = 0.5})
            else
                NeverLose.PlayAnimate(TabButton, SlowyTween, {BackgroundTransparency = 1})
            end
        end)))
        Window.Signal:Connect(LPH_NO_VIRTUALIZE(function(value)
            if value then
                if Window.Tabs[Window.CurrentTab] == Tab then
                    Tab.SetValue(true)
                else
                    Tab.SetValue(false)
                end
            else
                Tab.SetValue(false)
                NeverLose.PlayAnimate(TabButton, SlowyTween, {BackgroundTransparency = 1})
                NeverLose.PlayAnimate(TabIcon, SlowyTween, {TextTransparency = 1})

                if TabImage then
                    NeverLose.PlayAnimate(TabImage, SlowyTween, {ImageTransparency = 1})
                end

                NeverLose.PlayAnimate(TabContentLabel, SlowyTween, {TextTransparency = 1})
            end
        end))

        function Tab:AddSection(Config)
            Config = NeverLose:ProcessParams(Config, {
                Name = 'SECTION',
                Position = 'left',
            })

            local SectionFrame = Instance.new('Frame')
            local SectionLabel = Instance.new('TextLabel')
            local SectionHandler = Instance.new('Frame')
            local UIStroke = Instance.new('UIStroke')
            local UICorner = Instance.new('UICorner')
            local UIListLayout = Instance.new('UIListLayout')

            SectionFrame.Name = NeverLose.RandomString()
            SectionFrame.Parent = (string.lower(Config.Position) == 'left' and LeftScroll) or RightScroll
            SectionFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SectionFrame.BackgroundTransparency = 1
            SectionFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
            SectionFrame.BorderSizePixel = 0
            SectionFrame.ClipsDescendants = true
            SectionFrame.Size = UDim2.new(1, -5, 0, 0)
            SectionFrame.ZIndex = 9
            SectionLabel.Name = NeverLose.RandomString()
            SectionLabel.Parent = SectionFrame
            SectionLabel.AnchorPoint = Vector2.new(0.5, 0)
            SectionLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SectionLabel.BackgroundTransparency = 1
            SectionLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
            SectionLabel.BorderSizePixel = 0
            SectionLabel.Position = UDim2.new(0.5, 0, 0, 0)
            SectionLabel.Size = UDim2.new(1, -35, 0, 15)
            SectionLabel.ZIndex = 9
            SectionLabel.Font = Enum.Font.GothamMedium
            SectionLabel.Text = Config.Name
            SectionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            SectionLabel.TextSize = 11
            SectionLabel.TextTransparency = 0.5
            SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
            SectionHandler.Name = NeverLose.RandomString()
            SectionHandler.Parent = SectionFrame
            SectionHandler.AnchorPoint = Vector2.new(0.5, 0)
            SectionHandler.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
            SectionHandler.BackgroundTransparency = 0.5
            SectionHandler.BorderColor3 = Color3.fromRGB(0, 0, 0)
            SectionHandler.BorderSizePixel = 0
            SectionHandler.ClipsDescendants = true
            SectionHandler.Position = UDim2.new(0.5, 0, 0, 20)
            SectionHandler.Size = UDim2.new(1, -10, 1, -21)
            SectionHandler.ZIndex = 9
            UIStroke.Transparency = 0.65
            UIStroke.Color = Color3.fromRGB(45, 48, 58)
            UIStroke.Parent = SectionHandler
            UICorner.CornerRadius = UDim.new(0, 10)
            UICorner.Parent = SectionHandler
            UIListLayout.Parent = SectionHandler
            UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

            UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(LPH_NO_VIRTUALIZE(function()
                if UIListLayout.AbsoluteContentSize.Y <= 1 then
                    NeverLose.PlayAnimate(SectionFrame, VSlowTween, {
                        Size = UDim2.new(1, -5, 0, 0),
                    })
                else
                    NeverLose.PlayAnimate(SectionFrame, VSlowTween, {
                        Size = UDim2.new(1, -5, 0, UIListLayout.AbsoluteContentSize.Y + 19.5),
                    })
                end
            end))

            local Section = NeverLose:RegisiterItem(SectionHandler, Tab.Signal)

            Section.SetRender = LPH_NO_VIRTUALIZE(function(value)
                if value then
                    NeverLose.PlayAnimate(SectionLabel, SlowyTween, {TextTransparency = 0.5})
                    NeverLose.PlayAnimate(SectionHandler, SlowyTween, {BackgroundTransparency = 0.5})
                    NeverLose.PlayAnimate(UIStroke, SlowyTween, {Transparency = 0.65})
                else
                    NeverLose.PlayAnimate(SectionLabel, SlowyTween, {TextTransparency = 1})
                    NeverLose.PlayAnimate(SectionHandler, SlowyTween, {BackgroundTransparency = 1})
                    NeverLose.PlayAnimate(UIStroke, SlowyTween, {Transparency = 1})
                end
            end)

            Section.SetRender(Tab.Signal:GetValue())
            Tab.Signal:Connect(Section.SetRender)

            return Section
        end

        return Tab
    end
    function Window:_InitConfig()
        local ConfigSignal = NeverLose:CreateSignal(false)
        local ConfigLib = {Signals = {}}

        Window.ConfigLib = ConfigLib

        local ConfigMenu = Instance.new('Frame')
        local UICorner = Instance.new('UICorner')
        local UIListLayout = Instance.new('UIListLayout')
        local UIStroke = Instance.new('UIStroke')
        local InputFrame = Instance.new('Frame')
        local BasedLabel = Instance.new('TextLabel')
        local LineFrame = Instance.new('Frame')
        local BasedHandler = Instance.new('Frame')
        local UIListLayout_2 = Instance.new('UIListLayout')
        local TextInput = Instance.new('Frame')
        local UICorner_2 = Instance.new('UICorner')
        local UIStroke_2 = Instance.new('UIStroke')
        local TextBox = Instance.new('TextBox')
        local LoadConfig = Instance.new('Frame')
        local Icon = Instance.new('TextLabel')
        local UICorner_3 = Instance.new('UICorner')
        local UICorner_4 = Instance.new('UICorner')
        local shadow = NeverLose:CreateShadow(ConfigMenu)

        ConfigLib.SetRender = LPH_NO_VIRTUALIZE(function(value)
            if value then
                ConfigMenu.Position = UDim2.fromOffset(ConfigFrame.AbsolutePosition.X + 110, ConfigFrame.AbsolutePosition.Y + 96)

                NeverLose.PlayAnimate(ConfigMenu, SlowyTween, {
                    BackgroundTransparency = 0.035,
                    Position = UDim2.fromOffset(ConfigFrame.AbsolutePosition.X + 110, ConfigFrame.AbsolutePosition.Y + 95),
                })
                NeverLose.PlayAnimate(UIStroke, SlowyTween, {Transparency = 0.65})
                NeverLose.PlayAnimate(BasedLabel, SlowyTween, {TextTransparency = 0.2})
                NeverLose.PlayAnimate(UIStroke_2, SlowyTween, {Transparency = 0.65})
                NeverLose.PlayAnimate(LineFrame, SlowyTween, {BackgroundTransparency = 0.65})
                NeverLose.PlayAnimate(TextInput, SlowyTween, {BackgroundTransparency = 0})
                NeverLose.PlayAnimate(TextBox, SlowyTween, {TextTransparency = 0.35})
                NeverLose.PlayAnimate(Icon, SlowyTween, {TextTransparency = 0.35})
                NeverLose.PlayAnimate(ConfigBthIcon, SlowyTween, {Rotation = 180})
                shadow:Render(true)
            else
                NeverLose.PlayAnimate(ConfigBthIcon, SlowyTween, {Rotation = 0})
                NeverLose.PlayAnimate(ConfigMenu, SlowyTween, {
                    BackgroundTransparency = 1,
                    Position = UDim2.fromOffset(ConfigFrame.AbsolutePosition.X + 110, ConfigFrame.AbsolutePosition.Y + 96),
                })
                NeverLose.PlayAnimate(UIStroke_2, SlowyTween, {Transparency = 1})
                NeverLose.PlayAnimate(UIStroke, SlowyTween, {Transparency = 1})
                NeverLose.PlayAnimate(BasedLabel, SlowyTween, {TextTransparency = 1})
                NeverLose.PlayAnimate(LineFrame, SlowyTween, {BackgroundTransparency = 1})
                NeverLose.PlayAnimate(TextInput, SlowyTween, {BackgroundTransparency = 1})
                NeverLose.PlayAnimate(TextBox, SlowyTween, {TextTransparency = 1})
                NeverLose.PlayAnimate(Icon, SlowyTween, {TextTransparency = 1})
                shadow:Render(false)
            end
        end)

        NeverLose:AddSignal(ConfigMenu:GetPropertyChangedSignal('BackgroundTransparency'):Connect(LPH_NO_VIRTUALIZE(function()
            if ConfigMenu.BackgroundTransparency > 0.9 then
                ConfigMenu.Visible = false
                UIListLayout.Parent = nil
                ConfigMenu.Parent = nil
            else
                ConfigMenu.Visible = true
                UIListLayout.Parent = ConfigMenu

                if NeverLose.Global3DRenderMode then
                    ConfigMenu.Parent = NeverLose.GlobalSurfaceGui
                else
                    ConfigMenu.Parent = NeverLose.ScreenGui
                end
            end
        end)))

        ConfigMenu.Name = NeverLose.RandomString()
        ConfigMenu.Parent = NeverLose.ScreenGui
        ConfigMenu.AnchorPoint = Vector2.new(0.5, 0)
        ConfigMenu.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
        ConfigMenu.BackgroundTransparency = 0.035
        ConfigMenu.BorderColor3 = Color3.fromRGB(0, 0, 0)
        ConfigMenu.BorderSizePixel = 0
        ConfigMenu.ClipsDescendants = true
        ConfigMenu.Position = UDim2.new(255, 255, 255, 255)
        ConfigMenu.Size = UDim2.new(0, 220, 0, 110)
        ConfigMenu.ZIndex = 151
        UICorner.CornerRadius = UDim.new(0, 10)
        UICorner.Parent = ConfigMenu
        UIListLayout.Parent = ConfigMenu
        UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.Padding = UDim.new(0, 4)
        UIStroke.Transparency = 0.65
        UIStroke.Color = Color3.fromRGB(45, 48, 58)
        UIStroke.Parent = ConfigMenu
        InputFrame.Name = NeverLose.RandomString()
        InputFrame.Parent = ConfigMenu
        InputFrame.BackgroundColor3 = Color3.fromRGB(25, 27, 33)
        InputFrame.BackgroundTransparency = 1
        InputFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
        InputFrame.BorderSizePixel = 0
        InputFrame.Size = UDim2.new(1, 0, 0, 30)
        InputFrame.ZIndex = 154
        BasedLabel.Name = NeverLose.RandomString()
        BasedLabel.Parent = InputFrame
        BasedLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        BasedLabel.BackgroundTransparency = 1
        BasedLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
        BasedLabel.BorderSizePixel = 0
        BasedLabel.Position = UDim2.new(0, 11, 0, 6)
        BasedLabel.Size = UDim2.new(0, 1, 0, 15)
        BasedLabel.ZIndex = 154
        BasedLabel.Font = Enum.Font.GothamMedium
        BasedLabel.Text = 'Config'
        BasedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        BasedLabel.TextSize = 13
        BasedLabel.TextTransparency = 0.2
        BasedLabel.TextXAlignment = Enum.TextXAlignment.Left
        LineFrame.Name = NeverLose.RandomString()
        LineFrame.Parent = InputFrame
        LineFrame.AnchorPoint = Vector2.new(0.5, 1)
        LineFrame.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
        LineFrame.BackgroundTransparency = 0.65
        LineFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
        LineFrame.BorderSizePixel = 0
        LineFrame.Position = UDim2.new(0.5, 0, 1, 0)
        LineFrame.Size = UDim2.new(1, -20, 0, 1)
        LineFrame.ZIndex = 154
        BasedHandler.Name = NeverLose.RandomString()
        BasedHandler.Parent = InputFrame
        BasedHandler.AnchorPoint = Vector2.new(1, 0)
        BasedHandler.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        BasedHandler.BackgroundTransparency = 1
        BasedHandler.BorderColor3 = Color3.fromRGB(0, 0, 0)
        BasedHandler.BorderSizePixel = 0
        BasedHandler.Position = UDim2.new(1, -11, 0, 2)
        BasedHandler.Size = UDim2.new(1, -20, 0, 25)
        BasedHandler.ZIndex = 154
        UIListLayout_2.Parent = BasedHandler
        UIListLayout_2.FillDirection = Enum.FillDirection.Horizontal
        UIListLayout_2.HorizontalAlignment = Enum.HorizontalAlignment.Right
        UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout_2.VerticalAlignment = Enum.VerticalAlignment.Center
        UIListLayout_2.Padding = UDim.new(0, 5)

        NeverLose:AddSignal(UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(LPH_NO_VIRTUALIZE(function()
            if #ConfigLib.Signals <= 0 then
                NeverLose.PlayAnimate(ConfigMenu, SlowyTween, {
                    Size = UDim2.new(0, 220, 0, UIListLayout.AbsoluteContentSize.Y + 0),
                })
            else
                NeverLose.PlayAnimate(ConfigMenu, SlowyTween, {
                    Size = UDim2.new(0, 220, 0, UIListLayout.AbsoluteContentSize.Y + 5),
                })
            end
        end)))

        TextInput.Name = NeverLose.RandomString()
        TextInput.Parent = BasedHandler
        TextInput.BackgroundColor3 = Color3.fromRGB(26, 28, 36)
        TextInput.BorderColor3 = Color3.fromRGB(0, 0, 0)
        TextInput.BorderSizePixel = 0
        TextInput.ClipsDescendants = true
        TextInput.Size = UDim2.new(0, 100, 0, 18)
        TextInput.ZIndex = 154
        UICorner_2.CornerRadius = UDim.new(0, 4)
        UICorner_2.Parent = TextInput
        UIStroke_2.Transparency = 0.65
        UIStroke_2.Color = Color3.fromRGB(45, 48, 58)
        UIStroke_2.Parent = TextInput
        TextBox.Parent = TextInput
        TextBox.AnchorPoint = Vector2.new(0, 0.5)
        TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TextBox.BackgroundTransparency = 1
        TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
        TextBox.BorderSizePixel = 0
        TextBox.Position = UDim2.new(0, 5, 0.5, 0)
        TextBox.Size = UDim2.new(1, -5, 0, 17)
        TextBox.ZIndex = 154
        TextBox.ClearTextOnFocus = false
        TextBox.Font = Enum.Font.GothamMedium
        TextBox.PlaceholderText = 'Config Name ...'
        TextBox.Text = ''
        TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextBox.TextSize = 11
        TextBox.TextTransparency = 0.35
        TextBox.TextXAlignment = Enum.TextXAlignment.Left
        LoadConfig.Name = NeverLose.RandomString()
        LoadConfig.Parent = BasedHandler
        LoadConfig.BackgroundColor3 = Color3.fromRGB(39, 40, 49)
        LoadConfig.BackgroundTransparency = 1
        LoadConfig.BorderColor3 = Color3.fromRGB(0, 0, 0)
        LoadConfig.BorderSizePixel = 0
        LoadConfig.ClipsDescendants = true
        LoadConfig.Size = UDim2.new(0, 20, 0, 18)
        LoadConfig.ZIndex = 153
        Icon.Name = NeverLose.RandomString()
        Icon.Parent = LoadConfig
        Icon.AnchorPoint = Vector2.new(0.5, 0.5)
        Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Icon.BackgroundTransparency = 1
        Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Icon.BorderSizePixel = 0
        Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
        Icon.Size = UDim2.new(1, 0, 1, 0)
        Icon.ZIndex = 153
        Icon.FontFace = NeverLose.BuiltInBold
        Icon.Text = 'plus-large'
        Icon.TextColor3 = Color3.fromRGB(223, 223, 223)
        Icon.TextSize = 16
        Icon.TextTransparency = 0.35
        Icon.TextWrapped = true
        UICorner_3.CornerRadius = UDim.new(0, 4)
        UICorner_3.Parent = LoadConfig
        UICorner_4.CornerRadius = UDim.new(0, 10)
        UICorner_4.Parent = InputFrame

        local OpenButton = Instance.new('TextButton')
        local UICorner = Instance.new('UICorner')

        OpenButton.Name = NeverLose.RandomString()
        OpenButton.Parent = ConfigFrame
        OpenButton.AnchorPoint = Vector2.new(0, 0.5)
        OpenButton.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
        OpenButton.BackgroundTransparency = 1
        OpenButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
        OpenButton.BorderSizePixel = 0
        OpenButton.Position = UDim2.new(0, 31, 0.5, 0)
        OpenButton.Size = UDim2.new(1, -31, 1, 0)
        OpenButton.ZIndex = 10
        OpenButton.Font = Enum.Font.SourceSans
        OpenButton.Text = ''
        OpenButton.TextColor3 = Color3.fromRGB(0, 0, 0)
        OpenButton.TextSize = 14
        UICorner.CornerRadius = UDim.new(0, 4)
        UICorner.Parent = OpenButton

        ConfigLib.SetRender(false)
        ConfigSignal:Connect(ConfigLib.SetRender)

        ConfigLib.UnsafeThread = nil
        ConfigLib.SelectedConfig = 'Default'

        local UpdateSize = LPH_NO_VIRTUALIZE(function()
            local size = TextService:GetTextSize(ConfigName.Text, ConfigName.TextSize, ConfigName.Font, Vector2.new(math.huge, math.huge))

            NeverLose.PlayAnimate(ConfigFrame, SlowyTween, {
                Size = UDim2.fromOffset(size.X + 75, 30),
            })
        end)

        UpdateSize()

        function ConfigLib:GetData(performance)
            local ikc = {}
            local cd = 0

            for Flag, v in next, NeverLose.Flags do
                if v and v.GetValue then
                    local data = v:GetValue()

                    if typeof(data) == 'Color3' then
                        table.insert(ikc, {
                            Idx = Flag,
                            Value = data:ToHex(),
                        })
                    else
                        table.insert(ikc, {
                            Idx = Flag,
                            Value = data,
                        })
                    end
                end
                if performance then
                    if cd % 35 == 1 then
                        task.wait()
                    end
                end

                cd += 1
            end

            local positions = {}

            if NeverLose.__WatermarkCache and NeverLose.__WatermarkCache.Root then
                local wm = NeverLose.__WatermarkCache.Root

                positions.Watermark = {
                    X = {
                        Scale = wm.Position.X.Scale,
                        Offset = wm.Position.X.Offset,
                    },
                    Y = {
                        Scale = wm.Position.Y.Scale,
                        Offset = wm.Position.Y.Offset,
                    },
                }
            end
            if NeverLose.__KeyListCache and NeverLose.__KeyListCache.Root then
                local kl = NeverLose.__KeyListCache.Root

                positions.KeyList = {
                    X = {
                        Scale = kl.Position.X.Scale,
                        Offset = kl.Position.X.Offset,
                    },
                    Y = {
                        Scale = kl.Position.Y.Scale,
                        Offset = kl.Position.Y.Offset,
                    },
                }
            end
            if NeverLose.__MobileButtonCache and NeverLose.__MobileButtonCache.Root then
                local mb = NeverLose.__MobileButtonCache.Root

                positions.MobileButton = {
                    X = {
                        Scale = mb.Position.X.Scale,
                        Offset = mb.Position.X.Offset,
                    },
                    Y = {
                        Scale = mb.Position.Y.Scale,
                        Offset = mb.Position.Y.Offset,
                    },
                }
            end

            return NeverLose.Base64Encode(Encryption.new(HttpService:JSONEncode({
                Flags = ikc,
                Positions = positions,
            })))
        end
        function ConfigLib:LoadData(data)
            local decoded = HttpService:JSONDecode(Encryption.reverse(NeverLose.Base64Decode(data)))
            local coded = decoded.Flags or decoded
            local positions = decoded.Positions
            local pending = {}

            for i, v in next, coded do
                if v.Idx and NeverLose.Flags[v.Idx] then
                    table.insert(pending, v)
                end
            end

            table.sort(pending, function(a, b)
                return tostring(a.Idx) < tostring(b.Idx)
            end)

            local dispatched = 0

            for i, v in ipairs(pending)do
                local element = NeverLose.Flags[v.Idx]
                local value = v.Value

                task.spawn(function()
                    pcall(function()
                        element:SetValue(value)
                    end)
                end)

                dispatched += 1

                if dispatched % 25 == 0 then
                    task.wait()
                end
            end

            table.clear(pending)

            if positions then
                if positions.Watermark and NeverLose.__WatermarkCache and NeverLose.__WatermarkCache.Root then
                    local wm = NeverLose.__WatermarkCache.Root
                    local pos = positions.Watermark

                    wm.Position = UDim2.new(pos.X.Scale, pos.X.Offset, pos.Y.Scale, pos.Y.Offset)
                end
                if positions.KeyList and NeverLose.__KeyListCache and NeverLose.__KeyListCache.Root then
                    local kl = NeverLose.__KeyListCache.Root
                    local pos = positions.KeyList

                    kl.Position = UDim2.new(pos.X.Scale, pos.X.Offset, pos.Y.Scale, pos.Y.Offset)
                end
                if positions.MobileButton and NeverLose.__MobileButtonCache and NeverLose.__MobileButtonCache.Root then
                    local mb = NeverLose.__MobileButtonCache.Root
                    local pos = positions.MobileButton

                    mb.Position = UDim2.new(pos.X.Scale, pos.X.Offset, pos.Y.Scale, pos.Y.Offset)
                end
            end
        end
        function ConfigLib:RefreshConfig(force)
            if not isfolder(Window.ConfigFolder) then
                makefolder(Window.ConfigFolder)
            end
            if not isfile(Window.ConfigFolder .. '/Default') then
                writefile(Window.ConfigFolder .. '/Default', ConfigLib:GetData())
            end

            local ConfigList = {}

            for i, v in next, listfiles(Window.ConfigFolder)do
                local name = string.sub(v, #Window.ConfigFolder + 2)

                table.insert(ConfigList, name)
            end

            table.sort(ConfigList)

            local signature = table.concat(ConfigList, '\0')

            if force ~= true and ConfigLib.__Signature == signature then
                table.clear(ConfigList)

                return false
            end

            ConfigLib.__Signature = signature

            for i, v in next, ConfigMenu:GetChildren()do
                if v:GetAttribute('ConfigItem') then
                    v:Destroy()
                end
            end
            for i, v in next, ConfigLib.Signals do
                v:Disconnect()
            end

            table.clear(ConfigLib.Signals)

            for i, ConfigNameStr in next, ConfigList do
                local ConfigItemFrame = Instance.new('Frame')
                local BasedHandler = Instance.new('Frame')
                local UIListLayout = Instance.new('UIListLayout')
                local DeleteConfig = Instance.new('Frame')
                local Icon = Instance.new('TextLabel')
                local UICorner = Instance.new('UICorner')
                local LoadConfig = Instance.new('Frame')
                local Icon_2 = Instance.new('TextLabel')
                local UICorner_2 = Instance.new('UICorner')
                local UICorner_3 = Instance.new('UICorner')
                local BasedLabel = Instance.new('TextLabel')
                local UIStroke = Instance.new('UIStroke')

                ConfigItemFrame.Name = NeverLose.RandomString()
                ConfigItemFrame.Parent = ConfigMenu
                ConfigItemFrame.BackgroundColor3 = Color3.fromRGB(21, 20, 27)
                ConfigItemFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
                ConfigItemFrame.BorderSizePixel = 0
                ConfigItemFrame.Size = UDim2.new(1, -10, 0, 30)
                ConfigItemFrame.ZIndex = 153

                ConfigItemFrame:SetAttribute('ConfigItem', true)

                BasedHandler.Name = NeverLose.RandomString()
                BasedHandler.Parent = ConfigItemFrame
                BasedHandler.AnchorPoint = Vector2.new(1, 0)
                BasedHandler.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                BasedHandler.BackgroundTransparency = 1
                BasedHandler.BorderColor3 = Color3.fromRGB(0, 0, 0)
                BasedHandler.BorderSizePixel = 0
                BasedHandler.Position = UDim2.new(1, -11, 0, 2)
                BasedHandler.Size = UDim2.new(1, -20, 0, 25)
                BasedHandler.ZIndex = 153
                UIListLayout.Parent = BasedHandler
                UIListLayout.FillDirection = Enum.FillDirection.Horizontal
                UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
                UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
                UIListLayout.Padding = UDim.new(0, 5)
                DeleteConfig.Name = NeverLose.RandomString()
                DeleteConfig.Parent = BasedHandler
                DeleteConfig.BackgroundColor3 = Color3.fromRGB(39, 40, 49)
                DeleteConfig.BackgroundTransparency = 1
                DeleteConfig.BorderColor3 = Color3.fromRGB(0, 0, 0)
                DeleteConfig.BorderSizePixel = 0
                DeleteConfig.ClipsDescendants = true
                DeleteConfig.Size = UDim2.new(0, 20, 0, 18)
                DeleteConfig.ZIndex = 153
                Icon.Name = NeverLose.RandomString()
                Icon.Parent = DeleteConfig
                Icon.AnchorPoint = Vector2.new(0.5, 0.5)
                Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Icon.BackgroundTransparency = 1
                Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Icon.BorderSizePixel = 0
                Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
                Icon.Size = UDim2.new(1, 0, 1, 0)
                Icon.ZIndex = 153
                Icon.FontFace = NeverLose.BuiltInBold
                Icon.Text = 'trash-can'
                Icon.TextColor3 = Color3.fromRGB(223, 223, 223)
                Icon.TextSize = 16
                Icon.TextTransparency = 0.4
                Icon.TextWrapped = true
                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = DeleteConfig
                LoadConfig.Name = NeverLose.RandomString()
                LoadConfig.Parent = BasedHandler
                LoadConfig.BackgroundColor3 = Color3.fromRGB(39, 40, 49)
                LoadConfig.BackgroundTransparency = 1
                LoadConfig.BorderColor3 = Color3.fromRGB(0, 0, 0)
                LoadConfig.BorderSizePixel = 0
                LoadConfig.ClipsDescendants = true
                LoadConfig.Size = UDim2.new(0, 20, 0, 18)
                LoadConfig.ZIndex = 153
                Icon_2.Name = NeverLose.RandomString()
                Icon_2.Parent = LoadConfig
                Icon_2.AnchorPoint = Vector2.new(0.5, 0.5)
                Icon_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Icon_2.BackgroundTransparency = 1
                Icon_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Icon_2.BorderSizePixel = 0
                Icon_2.Position = UDim2.new(0.5, 0, 0.5, 0)
                Icon_2.Size = UDim2.new(1, 0, 1, 0)
                Icon_2.ZIndex = 153
                Icon_2.FontFace = NeverLose.BuiltInBold
                Icon_2.Text = 'arrow-right-from-portrait-rectangle'
                Icon_2.TextColor3 = Color3.fromRGB(223, 223, 223)
                Icon_2.TextSize = 16
                Icon_2.TextTransparency = 0.4
                Icon_2.TextWrapped = true
                UICorner_2.CornerRadius = UDim.new(0, 4)
                UICorner_2.Parent = LoadConfig
                UICorner_3.CornerRadius = UDim.new(0, 5)
                UICorner_3.Parent = ConfigItemFrame
                BasedLabel.Name = NeverLose.RandomString()
                BasedLabel.Parent = ConfigItemFrame
                BasedLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                BasedLabel.BackgroundTransparency = 1
                BasedLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
                BasedLabel.BorderSizePixel = 0
                BasedLabel.Position = UDim2.new(0, 11, 0, 7)
                BasedLabel.Size = UDim2.new(0, 1, 0, 15)
                BasedLabel.ZIndex = 153
                BasedLabel.Font = Enum.Font.GothamMedium
                BasedLabel.Text = ConfigNameStr
                BasedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                BasedLabel.TextSize = 13
                BasedLabel.TextTransparency = 0.2
                BasedLabel.TextXAlignment = Enum.TextXAlignment.Left
                UIStroke.Transparency = 0.5
                UIStroke.Color = Color3.fromRGB(45, 48, 58)
                UIStroke.Parent = ConfigItemFrame

                local Render = LPH_NO_VIRTUALIZE(function(rst)
                    if rst then
                        NeverLose.PlayAnimate(ConfigItemFrame, SlowyTween, {BackgroundTransparency = 0})
                        NeverLose.PlayAnimate(Icon, SlowyTween, {TextTransparency = 0.4})
                        NeverLose.PlayAnimate(Icon_2, SlowyTween, {TextTransparency = 0.4})
                        NeverLose.PlayAnimate(BasedLabel, SlowyTween, {TextTransparency = 0.2})
                        NeverLose.PlayAnimate(UIStroke, SlowyTween, {Transparency = 0.5})
                    else
                        NeverLose.PlayAnimate(ConfigItemFrame, SlowyTween, {BackgroundTransparency = 1})
                        NeverLose.PlayAnimate(Icon, SlowyTween, {TextTransparency = 1})
                        NeverLose.PlayAnimate(Icon_2, SlowyTween, {TextTransparency = 1})
                        NeverLose.PlayAnimate(BasedLabel, SlowyTween, {TextTransparency = 1})
                        NeverLose.PlayAnimate(UIStroke, SlowyTween, {Transparency = 1})
                    end
                end)

                Render(ConfigSignal:GetValue())
                table.insert(ConfigLib.Signals, ConfigSignal:Connect(Render))
                table.insert(ConfigLib.Signals, ConfigItemFrame.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
                    NeverLose.PlayAnimate(UIStroke, SlowyTween, {Transparency = 0.25})
                end)))
                table.insert(ConfigLib.Signals, ConfigItemFrame.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
                    NeverLose.PlayAnimate(UIStroke, SlowyTween, {Transparency = 0.5})
                end)))

                local deleter, signal = NeverLose:CreateInput(DeleteConfig, function()
                    if ConfigNameStr == 'Default' then
                        Logging.new('trash-can', "You can't delete default config!", 3.5)

                        return
                    end

                    delfile(Window.ConfigFolder .. '/' .. ConfigNameStr)
                    UpdateSize()
                    ConfigLib:RefreshConfig()
                    Logging.new('trash-can', 'Deleted ' .. tostring(ConfigNameStr), 3.5)
                end)
                local _, load_signal = NeverLose:CreateInput(LoadConfig, function()
                    local path = Window.ConfigFolder .. '/' .. ConfigNameStr

                    if isfile(path) then
                        local data = readfile(path)

                        ConfigLib:LoadData(data)

                        ConfigLib.SelectedConfig = ConfigNameStr
                        ConfigName.Text = ConfigNameStr

                        UpdateSize()
                        ConfigLib:RefreshConfig()
                        Logging.new('folder', 'Loaded ' .. tostring(ConfigNameStr), 3.5)
                    end
                end)

                table.insert(ConfigLib.Signals, signal)
                table.insert(ConfigLib.Signals, load_signal)
                table.insert(ConfigLib.Signals, deleter.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
                    NeverLose.PlayAnimate(Icon, SlowyTween, {
                        TextTransparency = 0.2,
                        TextColor3 = Color3.fromRGB(223, 125, 125),
                    })
                end)))
                table.insert(ConfigLib.Signals, deleter.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
                    NeverLose.PlayAnimate(Icon, SlowyTween, {
                        TextTransparency = 0.4,
                        TextColor3 = Color3.fromRGB(223, 223, 223),
                    })
                end)))
                table.insert(ConfigLib.Signals, LoadConfig.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
                    NeverLose.PlayAnimate(Icon_2, SlowyTween, {
                        TextTransparency = 0.2,
                        TextColor3 = NeverLose.AccentColor,
                    })
                end)))
                table.insert(ConfigLib.Signals, LoadConfig.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
                    NeverLose.PlayAnimate(Icon_2, SlowyTween, {
                        TextTransparency = 0.4,
                        TextColor3 = Color3.fromRGB(223, 223, 223),
                    })
                end)))
            end

            table.clear(ConfigList)
        end

        task.delay(1, function()
            if ConfigLib.SelectedConfig == 'Default' then
                local path = Window.ConfigFolder .. '/Default'
                local ConfigNameStr = 'Default'

                if isfile(path) then
                    local data = readfile(path)

                    ConfigLib:LoadData(data)

                    ConfigLib.SelectedConfig = ConfigNameStr
                    ConfigName.Text = ConfigNameStr

                    UpdateSize()
                    ConfigLib:RefreshConfig()
                    Logging.new('folder', 'Loaded Default Config', 3.5)
                    task.spawn(function()
                        local last_saved = nil

                        while true do
                            task.wait(5.75)

                            if isfile(path) and ConfigLib.SelectedConfig == 'Default' then
                                local fresh = ConfigLib:GetData(true)

                                if fresh ~= last_saved then
                                    last_saved = fresh

                                    task.wait()
                                    writefile(Window.ConfigFolder .. '/Default', fresh)
                                end
                            end
                        end
                    end)
                end
            end
        end)

        local hover_write = NeverLose:CreateInput(ConfigIcon, function()
            local path = Window.ConfigFolder .. '/' .. (ConfigLib.SelectedConfig or 'Default')

            if isfile(path) then
                writefile(Window.ConfigFolder .. '/' .. (ConfigLib.SelectedConfig or 'Default'), ConfigLib:GetData())
                Logging.new('folder', 'Saved ' .. tostring(ConfigLib.SelectedConfig), 3.5)
            end
        end)

        NeverLose:AddSignal(hover_write.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
            NeverLose.PlayAnimate(ConfigIcon, SlowyTween, {TextTransparency = 0.1})
        end)))
        NeverLose:AddSignal(hover_write.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
            NeverLose.PlayAnimate(ConfigIcon, SlowyTween, {TextTransparency = 0.25})
        end)))

        local mv = NeverLose:CreateInput(LoadConfig, function()
            local cfg_name = TextBox.Text

            if cfg_name and cfg_name:byte() and not cfg_name:find('/', 1, true) and not cfg_name:find('\\', 1, true) then
                cfg_name = string.sub(cfg_name, 1, 24)

                writefile(Window.ConfigFolder .. '/' .. cfg_name, ConfigLib:GetData())

                ConfigLib.SelectedConfig = cfg_name
                ConfigName.Text = cfg_name

                Logging.new('folder', 'Created ' .. tostring(cfg_name), 3.5)

                TextBox.Text = ''

                UpdateSize()
                ConfigLib:RefreshConfig()
            end
        end)

        NeverLose:AddSignal(mv.MouseEnter:Connect(function()
            NeverLose.PlayAnimate(Icon, SlowyTween, {TextTransparency = 0.1})
        end))
        NeverLose:AddSignal(mv.MouseLeave:Connect(function()
            NeverLose.PlayAnimate(Icon, SlowyTween, {TextTransparency = 0.35})
        end))
        ConfigLib:RefreshConfig(true)
        ConfigSignal:Connect(LPH_NO_VIRTUALIZE(function(value)
            if not value or ConfigLib.__Watcher then
                return
            end

            ConfigLib.__Watcher = true

            task.spawn(function()
                pcall(function()
                    ConfigLib:RefreshConfig()
                end)

                while ConfigSignal:GetValue() do
                    task.wait(1.5)

                    if not ConfigSignal:GetValue() then
                        break
                    end

                    local ok = pcall(function()
                        ConfigLib:RefreshConfig()
                    end)

                    if not ok then
                        break
                    end
                end

                ConfigLib.__Watcher = nil
            end)
        end))
        OpenButton.MouseButton1Click:Connect(LPH_NO_VIRTUALIZE(function()
            if ConfigLib.UnsafeThread then
                ConfigLib.UnsafeThread:Disconnect()

                ConfigLib.UnsafeThread = nil
            end

            ConfigSignal:SetValue(true)

            ConfigLib.UnsafeThread = UserInputService.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    if not NeverLose:IsMouseOverFrame(ConfigMenu) then
                        if ConfigLib.UnsafeThread then
                            ConfigLib.UnsafeThread:Disconnect()

                            ConfigLib.UnsafeThread = nil
                        end

                        ConfigSignal:SetValue(false)
                    end
                end
            end)
        end))
        Window.Signal:Connect(LPH_NO_VIRTUALIZE(function(value)
            if not value then
                if ConfigLib.UnsafeThread then
                    ConfigLib.UnsafeThread:Disconnect()

                    ConfigLib.UnsafeThread = nil
                end

                ConfigSignal:SetValue(false)
            end
        end))

        return ConfigLib
    end

    Window:_InitConfig()

    local UserSettings = NeverLose:CreateOptionWindow(BottomFrame, BottomFrame.ZIndex + 13)
    local reciveSignal

    NeverLose:CreateInput(BottomFrame, LPH_NO_VIRTUALIZE(function()
        if reciveSignal then
            reciveSignal:Disconnect()

            reciveSignal = nil
        end

        UserSettings.Signal:SetValue(true)

        reciveSignal = UserInputService.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                if not NeverLose:IsMouseOverFrame(UserSettings.Root) and not NeverLose:IsMouseOverFrame(BottomFrame) and not NeverLose.IsMosueOverOtherFrame then
                    if reciveSignal then
                        reciveSignal:Disconnect()

                        reciveSignal = nil
                    end

                    UserSettings.Signal:SetValue(false)
                end
            end
        end)
    end))
    Window.Signal:Connect(LPH_NO_VIRTUALIZE(function(value)
        if not value then
            if reciveSignal then
                reciveSignal:Disconnect()

                reciveSignal = nil
            end

            UserSettings.Signal:SetValue(false)
        end
    end))

    Window.UserSettings = UserSettings

    function Window:SetAccount(Config)
        Config = NeverLose:ProcessParams(Config, {
            Profile = NeverLose.UserProfile,
            Username = LocalPlayer.DisplayName or LocalPlayer.Name,
            Expires = 'Lifetime',
        })
        AccountName.Text = Config.Username
        AccountProfile.Image = Config.Profile
        ExpireLabel.Text = Config.Expires
        ExpireLabel.TextColor3 = NeverLose.AccentColor
        Window.Username = Config.Username or Window.Username
        Window.Profile = Config.Profile or Window.Profile
        Window.Expires = Config.Expires or Window.Expires

        if Window.UserSettings.UserFrame then
            Window.UserSettings.UserFrame:SetUsername(Window.Username)
            Window.UserSettings.UserFrame:SetProfile(Window.Profile)
            Window.UserSettings.UserFrame:SetExpires(Window.Expires)
        else
            Window.UserSettings.UserFrame = UserSettings:AddUserFrame(Window.Username, Window.Profile, Window.Expires)
        end
    end
    function Window:SetSize(newsize)
        Window.Size = newsize

        if Window.Signal:GetValue() then
            NeverLose.PlayAnimate(WindowFrame, VSlowTween, {
                Size = Window.Size,
            })
        end
    end

    Window:SetAccount()
    NeverLose:AddSignal(UserInputService.InputBegan:Connect(LPH_NO_VIRTUALIZE(function(value, ISTYPING)
        if value.KeyCode == Window.Keybind or value.KeyCode.Name == Window.Keybind then
            if not ISTYPING then
                Window:ToggleInterface()
            end
        end
    end)))

    function Window:ToggleInterface()
        Window.Signal:SetValue(not Window.Signal:GetValue())

        if Window.__3DRender then
            Window.Load3DBlock()
        end
    end
    function Window:MobileButton()
        if NeverLose.__MobileButtonCache then
            return NeverLose.__MobileButtonCache
        end

        local Handle = {}
        local Diameter = NeverLose.IsMobile and 46 or 42
        local Button = Instance.new('ImageButton')
        local UICorner = Instance.new('UICorner')
        local Ring = Instance.new('UIStroke')
        local RingGradient = Instance.new('UIGradient')
        local Shadow = NeverLose:CreateShadow(Button)
        local LogoAsset = Window.Logo

        if type(LogoAsset) ~= 'string' or LogoAsset == '' then
            LogoAsset = NeverLose.GlobalLogo
        end
        if type(LogoAsset) ~= 'string' or LogoAsset == '' then
            LogoAsset = 'rbxasset://textures/ui/VerifiedBadgeNameIcon.png'
        end

        Button.Name = NeverLose.RandomString()
        Button.Parent = NeverLose.ScreenGui
        Button.AnchorPoint = Vector2.new(0, 0)
        Button.AutoButtonColor = false
        Button.BackgroundColor3 = Color3.fromRGB(13, 13, 18)
        Button.BackgroundTransparency = 1
        Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Button.BorderSizePixel = 0
        Button.ClipsDescendants = true
        Button.Image = LogoAsset
        Button.ImageTransparency = 0.05
        Button.ScaleType = Enum.ScaleType.Crop
        Button.Position = UDim2.new(0, 18, 0.5, -math.floor(Diameter / 2))
        Button.Size = UDim2.fromOffset(Diameter, Diameter)
        Button.ZIndex = 40
        UICorner.CornerRadius = UDim.new(1, 0)
        UICorner.Parent = Button
        Ring.Thickness = 1.4
        Ring.Transparency = 0.4
        Ring.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        Ring.Parent = Button

        NeverLose:BindAccent(Ring, 'Color')

        RingGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.85),
            NumberSequenceKeypoint.new(0.5, 0),
            NumberSequenceKeypoint.new(1, 0.85),
        })
        RingGradient.Parent = Ring

        local function ClampPosition(position)
            local viewport = NeverLose.ScreenGui.AbsoluteSize

            if viewport.X <= 0 or viewport.Y <= 0 then
                return position
            end

            local x = position.X.Scale * viewport.X + position.X.Offset
            local y = position.Y.Scale * viewport.Y + position.Y.Offset

            x = math.clamp(x, 6, math.max(6, viewport.X - Diameter - 6))
            y = math.clamp(y, 6, math.max(6, viewport.Y - Diameter - 6))

            return UDim2.fromOffset(math.floor(x), math.floor(y))
        end
        local function SetPressed(value)
            NeverLose.PlayAnimate(Button, FastTween, {
                ImageTransparency = value and 0.25 or 0.05,
            })
        end
        local function SetActive(value)
            NeverLose.PlayAnimate(Ring, SlowyTween, {
                Thickness = value and 2 or 1.4,
                Transparency = value and 0.1 or 0.4,
            })
        end

        local dragging = false
        local moved = false
        local dragStart, startPos

        NeverLose:AddSignal(Button.InputBegan:Connect(LPH_NO_VIRTUALIZE(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                moved = false
                dragStart = input.Position
                startPos = Button.Position

                SetPressed(true)
            end
        end)))
        NeverLose:AddSignal(UserInputService.InputChanged:Connect(LPH_NO_VIRTUALIZE(function(input)
            if not dragging then
                return
            end
            if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then
                return
            end

            local delta = input.Position - dragStart

            if math.abs(delta.X) > 4 or math.abs(delta.Y) > 4 then
                moved = true
            end

            Button.Position = ClampPosition(UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y))
        end)))
        NeverLose:AddSignal(UserInputService.InputEnded:Connect(LPH_NO_VIRTUALIZE(function(input)
            if not dragging then
                return
            end
            if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
                return
            end

            dragging = false

            SetPressed(false)

            if not moved then
                Window:ToggleInterface()
            end
        end)))
        NeverLose:AddSignal(Button.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
            if dragging then
                return
            end

            NeverLose.PlayAnimate(Ring, SlowyTween, {Transparency = 0.15})
        end)))
        NeverLose:AddSignal(Button.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
            if dragging then
                return
            end

            NeverLose.PlayAnimate(Ring, SlowyTween, {
                Transparency = Window.Signal:GetValue() and 0.1 or 0.4,
            })
        end)))
        NeverLose:AddSignal(NeverLose.ScreenGui:GetPropertyChangedSignal('AbsoluteSize'):Connect(LPH_NO_VIRTUALIZE(function()
            Button.Position = ClampPosition(Button.Position)
        end)))

        local SpinThread = task.spawn(function()
            while true do
                task.wait(0.05)

                RingGradient.Rotation = (RingGradient.Rotation + 4) % 360
            end
        end)

        Button.Destroying:Connect(LPH_NO_VIRTUALIZE(function()
            if SpinThread then
                task.cancel(SpinThread)

                SpinThread = nil
            end
        end))
        SetActive(Window.Signal:GetValue())
        NeverLose:AddSignal(Window.Signal:Connect(SetActive))
        Shadow:Render(true)

        Handle.Root = Button
        Handle.Status = true

        function Handle:SetRender(value)
            Handle.Status = value and true or false
            Button.Visible = Handle.Status

            Shadow:Render(Handle.Status)
        end

        NeverLose.__MobileButtonCache = Handle

        return Handle
    end

    if NeverLose.IsMobile or NeverLose.ForceMobileButton then
        pcall(function()
            Window:MobileButton()
        end)
    end

    function Window:Watermark()
        if NeverLose.__WatermarkCache then
            return NeverLose.__WatermarkCache
        end

        local Watermark_lb = {}
        local Watermark = Instance.new('Frame')
        local UICorner = Instance.new('UICorner')
        local UIListLayout = Instance.new('UIListLayout')
        local Shadow = NeverLose:CreateShadow(Watermark)
        local WatermarkBlur = NeverLose:CreateSignal(true)
        local previousWatermarkBlurState = NeverLose.EnabledBlur

        NeverLose.EnabledBlur = true

        local watermarkBlurCreated = pcall(function()
            NeverLose:CreateBlurModule(Watermark, WatermarkBlur, true)
        end)

        NeverLose.EnabledBlur = previousWatermarkBlurState

        if not watermarkBlurCreated then
            WatermarkBlur:SetValue(false)
        end

        Watermark.Name = NeverLose.RandomString()
        Watermark.Parent = NeverLose.ScreenGui
        Watermark.AnchorPoint = Vector2.new(1, 0)
        Watermark.BackgroundColor3 = Color3.fromRGB(13, 13, 18)
        Watermark.BackgroundTransparency = 0.38
        Watermark.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Watermark.BorderSizePixel = 0
        Watermark.ClipsDescendants = true
        Watermark.Position = UDim2.new(1, -10, 0, 10)
        Watermark.Size = UDim2.new(0, 120, 0, 30)
        Watermark.ZIndex = 16
        UICorner.CornerRadius = UDim.new(0, 25)
        UICorner.Parent = Watermark
        UIListLayout.Parent = Watermark
        UIListLayout.FillDirection = Enum.FillDirection.Horizontal
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right

        local empty_space = Instance.new('Frame')

        empty_space.Size = UDim2.fromOffset(15, 0)
        empty_space.BackgroundTransparency = 1
        empty_space.Parent = Watermark
        empty_space.LayoutOrder = 5

        Watermark:GetPropertyChangedSignal('BackgroundTransparency'):Connect(LPH_NO_VIRTUALIZE(function()
            if Watermark.BackgroundTransparency > 0.9 then
                Watermark.Visible = false
                Watermark.Parent = nil
            else
                Watermark.Parent = NeverLose.ScreenGui
                Watermark.Visible = true
            end
        end))
        UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(LPH_NO_VIRTUALIZE(function()
            NeverLose.PlayAnimate(Watermark, SlowyTween, {
                Size = UDim2.new(0, UIListLayout.AbsoluteContentSize.X + 5, 0, 30),
            })
        end))

        local dragging = false
        local dragStart, startPos

        Watermark.InputBegan:Connect(LPH_NO_VIRTUALIZE(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = Watermark.Position
            end
        end))
        NeverLose:AddSignal(UserInputService.InputChanged:Connect(LPH_NO_VIRTUALIZE(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)

                NeverLose.PlayAnimate(Watermark, SlowyTween, {Position = position})
            end
        end)))
        NeverLose:AddSignal(UserInputService.InputEnded:Connect(LPH_NO_VIRTUALIZE(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)))

        NeverLose.__WatermarkCache = Watermark_lb

        Shadow:Render(true)

        Watermark_lb.Renders = {}
        Watermark_lb.Status = true
        Watermark_lb.Root = Watermark

        function Watermark_lb:SetRender(value)
            Watermark_lb.Status = value

            WatermarkBlur:SetValue(value)

            if value then
                NeverLose.PlayAnimate(Watermark, SlowyTween, {BackgroundTransparency = 0.38})
                Shadow:Render(true)

                for i, v in next, Watermark_lb.Renders do
                    pcall(v, true)
                end
            else
                NeverLose.PlayAnimate(Watermark, SlowyTween, {BackgroundTransparency = 1})
                Shadow:Render(false)

                for i, v in next, Watermark_lb.Renders do
                    pcall(v, false)
                end
            end
        end
        function Watermark_lb:AddBlock(IconStr, Name)
            local InnerBlock = {}
            local Frame = Instance.new('Frame')
            local Content = Instance.new('TextLabel')
            local Icon = Instance.new('TextLabel')

            Frame.Parent = Watermark
            Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Frame.BackgroundTransparency = 1
            Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Frame.BorderSizePixel = 0
            Frame.Size = UDim2.new(0, 50, 0, 30)
            Content.Name = NeverLose.RandomString()
            Content.Parent = Frame
            Content.AnchorPoint = Vector2.new(0, 0.5)
            Content.BackgroundColor3 = Color3.fromRGB(186, 186, 186)
            Content.BackgroundTransparency = 1
            Content.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Content.BorderSizePixel = 0

            local NoIcon = (IconStr == nil or IconStr == '')
            local TextOffset = NoIcon and 12 or 35
            local TextPad = (NoIcon and 12) or 0

            Content.Position = UDim2.new(0, TextOffset, 0.5, 0)
            Content.Size = UDim2.new(0, 1, 0, 25)
            Content.ZIndex = 17
            Content.Font = Enum.Font.GothamBold
            Content.Text = Name
            Content.TextColor3 = Color3.fromRGB(186, 186, 186)
            Content.TextSize = 15
            Content.TextTransparency = 0.2
            Content.TextXAlignment = Enum.TextXAlignment.Left
            Icon.Name = NeverLose.RandomString()
            Icon.Parent = Frame
            Icon.AnchorPoint = Vector2.new(0, 0.5)
            Icon.BackgroundColor3 = Color3.fromRGB(186, 186, 186)
            Icon.BackgroundTransparency = 1
            Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Icon.BorderSizePixel = 0
            Icon.Position = UDim2.new(0, 10, 0.5, 0)
            Icon.Size = UDim2.new(0, 20, 0, 20)
            Icon.ZIndex = 17
            Icon.FontFace = NeverLose.BuiltInBold
            Icon.Text = IconStr
            Icon.TextColor3 = NeverLose.AccentColor
            Icon.TextSize = 18
            Icon.TextTransparency = 0.25
            Icon.TextWrapped = true

            local IconImage
            local IconAsset = string.match(tostring(IconStr), '^rbxassetid://(%d+)$') or string.match(tostring(IconStr), '^(%d+)$')

            if IconAsset then
                Icon.Text = ''
                IconImage = Instance.new('ImageLabel')
                IconImage.Name = NeverLose.RandomString()
                IconImage.Parent = Frame
                IconImage.AnchorPoint = Vector2.new(0, 0.5)
                IconImage.BackgroundTransparency = 1
                IconImage.BorderSizePixel = 0
                IconImage.Position = UDim2.new(0, 10, 0.5, 0)
                IconImage.Size = UDim2.new(0, 19, 0, 19)
                IconImage.ZIndex = 17
                IconImage.Image = 'rbxassetid://' .. IconAsset
                IconImage.ImageTransparency = 0.25

                NeverLose:BindAccent(IconImage, 'ImageColor3')
            end

            InnerBlock.Update = LPH_NO_VIRTUALIZE(function(value)
                local size = TextService:GetTextSize(Content.Text, Content.TextSize, Content.Font, Vector2.new(math.huge, math.huge))

                if InnerBlock.Visible then
                    NeverLose.PlayAnimate(Frame, VSlowTween, {
                        Size = UDim2.new(0, size.X + TextOffset + TextPad, 0, 30),
                    })
                else
                    NeverLose.PlayAnimate(Frame, VSlowTween, {
                        Size = UDim2.new(0, 0, 0, 30),
                    })
                end
            end)
            InnerBlock.Visible = true

            InnerBlock.Update()

            function InnerBlock:SetVisible(v)
                InnerBlock.Visible = v

                if Watermark_lb.Status then
                    InnerBlock.SetRender(v)
                end

                InnerBlock.Update()
            end

            InnerBlock.SetRender = LPH_NO_VIRTUALIZE(function(value)
                if value and InnerBlock.Visible then
                    NeverLose.PlayAnimate(Content, SlowyTween, {TextTransparency = 0.2})
                    NeverLose.PlayAnimate(Icon, SlowyTween, {TextTransparency = 0.25})

                    if IconImage then
                        NeverLose.PlayAnimate(IconImage, SlowyTween, {ImageTransparency = 0.25})
                    end
                else
                    NeverLose.PlayAnimate(Content, SlowyTween, {TextTransparency = 1})
                    NeverLose.PlayAnimate(Icon, SlowyTween, {TextTransparency = 1})

                    if IconImage then
                        NeverLose.PlayAnimate(IconImage, SlowyTween, {ImageTransparency = 1})
                    end
                end
            end)

            table.insert(Watermark_lb.Renders, InnerBlock.SetRender)

            function InnerBlock:SetText(t)
                Content.Text = t

                InnerBlock.Update()
            end
            function InnerBlock:Input(func)
                local c, s = NeverLose:CreateInput(Frame, func)

                return s
            end

            return InnerBlock
        end

        return Watermark_lb
    end
    function Window:KeyList()
        if NeverLose.__KeyListCache then
            return NeverLose.__KeyListCache
        end

        local KeyListLib = {}
        local KeyListTween = TweenInfo.new(0.32, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        local KeyListFadeTween = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local Container = Instance.new('Frame')
        local ContainerList = Instance.new('UIListLayout')

        Container.Name = NeverLose.RandomString()
        Container.Parent = NeverLose.ScreenGui
        Container.AnchorPoint = Vector2.new(0, 0.5)
        Container.BackgroundTransparency = 1
        Container.Position = UDim2.new(0, 16, 0.5, 0)
        Container.Size = UDim2.new(0, 0, 0, 0)
        Container.AutomaticSize = Enum.AutomaticSize.XY
        Container.ZIndex = 16
        ContainerList.FillDirection = Enum.FillDirection.Vertical
        ContainerList.HorizontalAlignment = Enum.HorizontalAlignment.Left
        ContainerList.SortOrder = Enum.SortOrder.LayoutOrder
        ContainerList.Padding = UDim.new(0, 0)
        ContainerList.Parent = Container

        local function makeCard(parent, order)
            local card = Instance.new('Frame')
            local corner = Instance.new('UICorner')
            local stroke = Instance.new('UIStroke')
            local shadow = NeverLose:CreateShadow(card)

            card.Name = NeverLose.RandomString()
            card.Parent = parent
            card.BackgroundColor3 = Color3.fromRGB(8, 8, 13)
            card.BackgroundTransparency = 1
            card.BorderSizePixel = 0
            card.ClipsDescendants = true
            card.Size = UDim2.new(0, 0, 0, 0)
            card.ZIndex = 17
            card.LayoutOrder = order
            corner.CornerRadius = UDim.new(0, 6)
            corner.Parent = card
            stroke.Transparency = 1
            stroke.Color = Color3.fromRGB(45, 48, 58)
            stroke.Parent = card

            local cardBlur = NeverLose:CreateSignal(false)

            NeverLose:CreateBlurModule(card, cardBlur)

            return card, stroke, shadow, cardBlur
        end

        local HeaderCard, HeaderStroke, HeaderShadow, HeaderBlur = makeCard(Container, 0)
        local HeaderPadding = Instance.new('UIPadding')

        HeaderPadding.PaddingLeft = UDim.new(0, 12)
        HeaderPadding.PaddingRight = UDim.new(0, 14)
        HeaderPadding.Parent = HeaderCard

        local HeaderLayout = Instance.new('UIListLayout')

        HeaderLayout.FillDirection = Enum.FillDirection.Horizontal
        HeaderLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        HeaderLayout.SortOrder = Enum.SortOrder.LayoutOrder
        HeaderLayout.Padding = UDim.new(0, 8)
        HeaderLayout.Parent = HeaderCard

        local HeaderIcon = Instance.new('ImageLabel')

        HeaderIcon.Name = NeverLose.RandomString()
        HeaderIcon.Parent = HeaderCard
        HeaderIcon.BackgroundTransparency = 1
        HeaderIcon.Size = UDim2.new(0, 15, 0, 15)
        HeaderIcon.Image = 'rbxassetid://121978468376124'
        HeaderIcon.ImageColor3 = NeverLose.AccentColor
        HeaderIcon.ImageTransparency = 1
        HeaderIcon.ZIndex = 18
        HeaderIcon.LayoutOrder = 1

        local HeaderTitle = Instance.new('TextLabel')

        HeaderTitle.Name = NeverLose.RandomString()
        HeaderTitle.Parent = HeaderCard
        HeaderTitle.AutomaticSize = Enum.AutomaticSize.X
        HeaderTitle.BackgroundTransparency = 1
        HeaderTitle.Size = UDim2.new(0, 0, 0, 16)
        HeaderTitle.ZIndex = 18
        HeaderTitle.Font = Enum.Font.GothamBold
        HeaderTitle.Text = 'HotKeys'
        HeaderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        HeaderTitle.TextSize = 13
        HeaderTitle.TextTransparency = 1
        HeaderTitle.LayoutOrder = 2

        local headerContentWidth = 49 + TextService:GetTextSize('HotKeys', 13, Enum.Font.GothamBold, Vector2.new(math.huge, math.huge)).X
        local entries = {}
        local shown = false
        local panelToken = 0
        local orderCounter = 1
        local headerWidth, headerShown

        local function makeTumbler(parent)
            local t = Instance.new('Frame')
            local tc = Instance.new('UICorner')
            local circle = Instance.new('Frame')
            local cc = Instance.new('UICorner')

            t.Name = NeverLose.RandomString()
            t.Parent = parent
            t.AnchorPoint = Vector2.new(0.5, 0.5)
            t.BackgroundColor3 = Color3.fromRGB(10, 13, 21)
            t.BorderSizePixel = 0
            t.Position = UDim2.new(0.5, 0, 0.5, 0)
            t.Size = UDim2.new(0, 26, 0, 14)
            t.ZIndex = 303
            tc.CornerRadius = UDim.new(1, 0)
            tc.Parent = t
            circle.Name = NeverLose.RandomString()
            circle.Parent = t
            circle.AnchorPoint = Vector2.new(0.5, 0.5)
            circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            circle.BackgroundTransparency = 0.5
            circle.BorderSizePixel = 0
            circle.Position = UDim2.new(0.3, 0, 0.5, 0)
            circle.Size = UDim2.new(0, 10, 0, 10)
            circle.ZIndex = 304
            cc.CornerRadius = UDim.new(1, 0)
            cc.Parent = circle

            local state

            return {
                set = function(on)
                    on = on and true or false

                    if state == on then
                        return
                    end

                    state = on

                    if on then
                        NeverLose.PlayAnimate(t, KeyListFadeTween, {
                            BackgroundColor3 = NeverLose.AccentColor,
                        })
                        NeverLose.PlayAnimate(circle, KeyListFadeTween, {
                            Position = UDim2.new(0.7, 0, 0.5, 0),
                            BackgroundTransparency = 0,
                        })
                    else
                        NeverLose.PlayAnimate(t, KeyListFadeTween, {
                            BackgroundColor3 = Color3.fromRGB(10, 13, 21),
                        })
                        NeverLose.PlayAnimate(circle, KeyListFadeTween, {
                            Position = UDim2.new(0.3, 0, 0.5, 0),
                            BackgroundTransparency = 0.5,
                        })
                    end
                end,
            }
        end
        local function createEntry(kb)
            orderCounter = orderCounter + 1

            local hasTumbler = (kb.Type == 'Toggle' or kb.Type == 'Slider')
            local e = {}

            e.Cards = {}

            local Row = Instance.new('Frame')
            local RowLayout = Instance.new('UIListLayout')

            Row.Name = NeverLose.RandomString()
            Row.Parent = Container
            Row.BackgroundTransparency = 1
            Row.Size = UDim2.new(0, 0, 0, 0)
            Row.ZIndex = 17
            Row.LayoutOrder = orderCounter
            RowLayout.FillDirection = Enum.FillDirection.Horizontal
            RowLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
            RowLayout.SortOrder = Enum.SortOrder.LayoutOrder
            RowLayout.Padding = UDim.new(0, 5)
            RowLayout.Parent = Row
            e.Row = Row

            if hasTumbler then
                local TumblerCard, TumblerStroke, TumblerShadow, TumblerBlur = makeCard(Row, 1)

                TumblerCard.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
                TumblerCard.Size = UDim2.new(0, 34, 0, 0)
                e.Tumbler = makeTumbler(TumblerCard)
                e.TumblerEntry = {
                    TumblerCard,
                    TumblerStroke,
                    TumblerShadow,
                    34,
                    TumblerBlur,
                }

                table.insert(e.Cards, e.TumblerEntry)
            end

            local InfoCard, InfoStroke, InfoShadow, InfoBlur = makeCard(Row, 2)

            e.InfoEntry = {
                InfoCard,
                InfoStroke,
                InfoShadow,
                0,
                InfoBlur,
            }
            e.InfoCard = InfoCard

            table.insert(e.Cards, e.InfoEntry)

            local InfoPadding = Instance.new('UIPadding')

            InfoPadding.PaddingLeft = UDim.new(0, 10)
            InfoPadding.PaddingRight = UDim.new(0, 10)
            InfoPadding.Parent = InfoCard

            local InfoLayout = Instance.new('UIListLayout')

            InfoLayout.FillDirection = Enum.FillDirection.Horizontal
            InfoLayout.VerticalAlignment = Enum.VerticalAlignment.Center
            InfoLayout.SortOrder = Enum.SortOrder.LayoutOrder
            InfoLayout.Padding = UDim.new(0, 10)
            InfoLayout.Parent = InfoCard

            local NameLabel = Instance.new('TextLabel')

            NameLabel.Name = NeverLose.RandomString()
            NameLabel.Parent = InfoCard
            NameLabel.AutomaticSize = Enum.AutomaticSize.X
            NameLabel.BackgroundTransparency = 1
            NameLabel.Size = UDim2.new(0, 0, 0, 16)
            NameLabel.ZIndex = 303
            NameLabel.Font = Enum.Font.GothamBold
            NameLabel.Text = tostring(kb.Name)
            NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            NameLabel.TextTransparency = 1
            NameLabel.TextSize = 12
            NameLabel.LayoutOrder = 1

            local ValueLabel

            if kb.Type == 'Slider' then
                ValueLabel = Instance.new('TextLabel')
                ValueLabel.Name = NeverLose.RandomString()
                ValueLabel.Parent = InfoCard
                ValueLabel.AutomaticSize = Enum.AutomaticSize.X
                ValueLabel.BackgroundTransparency = 1
                ValueLabel.Size = UDim2.new(0, 0, 0, 16)
                ValueLabel.ZIndex = 303
                ValueLabel.Font = Enum.Font.GothamBold
                ValueLabel.Text = ''
                ValueLabel.TextColor3 = Color3.fromRGB(235, 235, 235)
                ValueLabel.TextTransparency = 1
                ValueLabel.TextSize = 12
                ValueLabel.LayoutOrder = 2
            end

            local KeyLabel = Instance.new('TextLabel')

            KeyLabel.Name = NeverLose.RandomString()
            KeyLabel.Parent = InfoCard
            KeyLabel.AutomaticSize = Enum.AutomaticSize.X
            KeyLabel.BackgroundTransparency = 1
            KeyLabel.Size = UDim2.new(0, 0, 0, 16)
            KeyLabel.ZIndex = 303
            KeyLabel.Font = Enum.Font.GothamBold
            KeyLabel.Text = ''
            KeyLabel.TextColor3 = NeverLose.AccentColor
            KeyLabel.TextTransparency = 1
            KeyLabel.TextSize = 12
            KeyLabel.LayoutOrder = 3
            e.Name = NameLabel
            e.Key = KeyLabel
            e.Value = ValueLabel
            e.Labels = {NameLabel}

            if ValueLabel then
                table.insert(e.Labels, ValueLabel)
            end

            table.insert(e.Labels, KeyLabel)

            return e
        end
        local function syncWidth(e)
            local width = 20

            for _, label in ipairs(e.Labels)do
                width = width + TextService:GetTextSize(label.Text, label.TextSize, label.Font, Vector2.new(math.huge, math.huge)).X
            end

            width = math.ceil(width + ((#e.Labels - 1) * 10))

            if width == e.InfoWidth then
                return
            end

            e.InfoWidth = width
            e.InfoEntry[4] = width
            e.TotalWidth = width + (e.TumblerEntry and (e.TumblerEntry[4] + 5) or 0)

            if e.Opened and not e.Closing then
                NeverLose.PlayAnimate(e.InfoCard, KeyListTween, {
                    Size = UDim2.new(0, width, 0, 28),
                })
                NeverLose.PlayAnimate(e.Row, KeyListTween, {
                    Size = UDim2.new(0, e.TotalWidth, 0, 38),
                })
            else
                e.Row.Size = UDim2.new(0, e.TotalWidth, 0, e.Row.Size.Y.Offset)
            end
        end
        local function animateIn(e)
            e.AnimationToken = (e.AnimationToken or 0) + 1

            local token = e.AnimationToken
            local firstFrame = not e.Initialized

            e.Initialized = true
            e.Closing = false
            e.Opened = true

            local function play()
                if token ~= e.AnimationToken or e.Closing or not e.Row or not e.Row.Parent then
                    return
                end

                NeverLose.PlayAnimate(e.Row, KeyListTween, {
                    Size = UDim2.new(0, e.TotalWidth, 0, 38),
                })

                for _, c in next, e.Cards do
                    NeverLose.PlayAnimate(c[1], KeyListTween, {
                        Size = UDim2.new(0, c[4], 0, 28),
                        BackgroundTransparency = 0.2,
                    })
                    NeverLose.PlayAnimate(c[2], KeyListFadeTween, {Transparency = 0.65})
                    c[3]:Render(true)
                    c[5]:SetValue(true)
                end

                NeverLose.PlayAnimate(e.Name, KeyListFadeTween, {TextTransparency = 0.1})
                NeverLose.PlayAnimate(e.Key, KeyListFadeTween, {TextTransparency = 0.15})

                if e.Value then
                    NeverLose.PlayAnimate(e.Value, KeyListFadeTween, {TextTransparency = 0.15})
                end
            end

            if firstFrame then
                task.spawn(function()
                    RunService.Heartbeat:Wait()
                    play()
                end)
            else
                play()
            end
        end
        local function animateOut(e, completed)
            if e.Closing then
                return
            end

            e.AnimationToken = (e.AnimationToken or 0) + 1

            local token = e.AnimationToken

            e.Closing = true
            e.Opened = false

            NeverLose.PlayAnimate(e.Row, KeyListTween, {
                Size = UDim2.new(0, e.TotalWidth or 0, 0, 0),
            })

            for _, c in next, e.Cards do
                NeverLose.PlayAnimate(c[1], KeyListTween, {
                    Size = UDim2.new(0, c[4], 0, 0),
                    BackgroundTransparency = 1,
                })
                NeverLose.PlayAnimate(c[2], KeyListFadeTween, {Transparency = 1})
                c[3]:Render(false)
            end

            NeverLose.PlayAnimate(e.Name, KeyListFadeTween, {TextTransparency = 1})
            NeverLose.PlayAnimate(e.Key, KeyListFadeTween, {TextTransparency = 1})

            if e.Value then
                NeverLose.PlayAnimate(e.Value, KeyListFadeTween, {TextTransparency = 1})
            end

            task.delay(0.34, function()
                if token ~= e.AnimationToken or not e.Closing then
                    return
                end

                for _, c in next, e.Cards do
                    c[5]:SetValue(false)
                end

                if e.Row and e.Row.Parent then
                    e.Row:Destroy()
                end
                if completed then
                    completed()
                end
            end)
        end
        local function showPanel()
            panelToken = panelToken + 1
            shown = true

            HeaderBlur:SetValue(true)
            NeverLose.PlayAnimate(HeaderCard, KeyListFadeTween, {BackgroundTransparency = 0.2})
            NeverLose.PlayAnimate(HeaderStroke, KeyListFadeTween, {Transparency = 0.65})
            HeaderShadow:Render(true)
            NeverLose.PlayAnimate(HeaderTitle, KeyListFadeTween, {TextTransparency = 0})
            NeverLose.PlayAnimate(HeaderIcon, KeyListFadeTween, {ImageTransparency = 0})
        end
        local function hidePanel()
            panelToken = panelToken + 1

            local token = panelToken

            shown = false

            NeverLose.PlayAnimate(HeaderCard, KeyListFadeTween, {BackgroundTransparency = 1})
            NeverLose.PlayAnimate(HeaderStroke, KeyListFadeTween, {Transparency = 1})
            HeaderShadow:Render(false)
            NeverLose.PlayAnimate(HeaderTitle, KeyListFadeTween, {TextTransparency = 1})
            NeverLose.PlayAnimate(HeaderIcon, KeyListFadeTween, {ImageTransparency = 1})
            task.delay(0.34, function()
                if token == panelToken and not shown then
                    HeaderBlur:SetValue(false)
                end
            end)
        end
        local function updateEntry(e, kb)
            e.Name.Text = tostring(kb.Name)
            e.Key.Text = NeverLose:KeyCodeToStr(kb.Key)

            if e.Value then
                e.Value.Text = tostring(kb.SliderValue)
            end

            syncWidth(e)

            if kb.Type == 'Toggle' then
                local on = false

                pcall(function()
                    on = kb.GetValue() and true or false
                end)

                if e.Tumbler then
                    e.Tumbler.set(on)
                end
            elseif kb.Type == 'Slider' then
                if e.Tumbler then
                    e.Tumbler.set(kb.Active and true or false)
                end
            end
        end
        local function refresh()
            local count = 0
            local visited = {}
            local registry = NeverLose.ElementKeybinds or {}

            for id, kb in next, registry do
                visited[id] = true

                if kb.Key then
                    count = count + 1

                    local e = entries[id]

                    if not e then
                        e = createEntry(kb)
                        entries[id] = e

                        updateEntry(e, kb)
                        animateIn(e)
                    else
                        updateEntry(e, kb)

                        if e.Closing then
                            animateIn(e)
                        end
                    end
                elseif entries[id] and not entries[id].Closing then
                    local entryId = id
                    local closingEntry = entries[id]

                    animateOut(closingEntry, function()
                        if entries[entryId] == closingEntry then
                            entries[entryId] = nil
                        end
                    end)
                end
            end
            for id, e in next, entries do
                if not visited[id] and not e.Closing then
                    local entryId = id
                    local closingEntry = e

                    animateOut(closingEntry, function()
                        if entries[entryId] == closingEntry then
                            entries[entryId] = nil
                        end
                    end)
                end
            end

            if count > 0 and not shown then
                showPanel()
            elseif count == 0 and shown then
                hidePanel()
            end

            local maxW = headerContentWidth

            for _, e in next, entries do
                if e.TotalWidth and e.TotalWidth > maxW then
                    maxW = e.TotalWidth
                end
            end

            if maxW ~= headerWidth or shown ~= headerShown then
                headerWidth = maxW
                headerShown = shown

                NeverLose.PlayAnimate(HeaderCard, KeyListTween, {
                    Size = UDim2.new(0, maxW, 0, shown and 30 or 0),
                })
            end
        end

        local dragging = false
        local dragStart, startPos

        HeaderCard.InputBegan:Connect(LPH_NO_VIRTUALIZE(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = Container.Position
            end
        end))
        NeverLose:AddSignal(UserInputService.InputChanged:Connect(LPH_NO_VIRTUALIZE(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)

                NeverLose.PlayAnimate(Container, SlowyTween, {Position = position})
            end
        end)))
        NeverLose:AddSignal(UserInputService.InputEnded:Connect(LPH_NO_VIRTUALIZE(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)))
        task.spawn(function()
            while Container.Parent do
                pcall(refresh)
                task.wait(0.15)
            end
        end)

        NeverLose.__KeyListCache = KeyListLib
        KeyListLib.Root = Container

        return KeyListLib
    end

    Window:SetRender(false)

    return Window
end
function NeverLose:CreateNotification()
    if NeverLose.__Notification_Cache then
        return NeverLose.__Notification_Cache
    end

    local Notifier = {}
    local Notification = Instance.new('Frame')
    local UIListLayout = Instance.new('UIListLayout')

    Notification.Name = NeverLose.RandomString()
    Notification.Parent = NeverLose.ScreenGui
    Notification.AnchorPoint = Vector2.new(1, 0)
    Notification.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Notification.BackgroundTransparency = 1
    Notification.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Notification.BorderSizePixel = 0
    Notification.Position = UDim2.new(1, -25, 0, 25)
    Notification.Size = UDim2.new(0, 25, 0, 25)
    UIListLayout.Parent = Notification
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 0)
    NeverLose.__Notification_Cache = Notifier

    function Notifier.new(Config)
        Config = NeverLose:ProcessParams(Config, {
            Title = 'Notification',
            Content = 'Hello World!',
            Logo = NeverLose.GlobalLogo or 'rbxasset://textures/ui/VerifiedBadgeNameIcon.png',
            Duration = 5,
        })

        if NeverLose.__WatermarkCache then
            NeverLose.PlayAnimate(Notification, SlowyTween, {
                Position = UDim2.new(1, -25, 0, 55),
            })
        end

        local ContainerFrame = Instance.new('Frame')
        local NotifyFrame = Instance.new('Frame')
        local UICorner = Instance.new('UICorner')
        local UIStroke = Instance.new('UIStroke')
        local LogoImage = Instance.new('ImageLabel')
        local UICorner_2 = Instance.new('UICorner')
        local NotifyName = Instance.new('TextLabel')
        local NotifyContent = Instance.new('TextLabel')
        local shadow = NeverLose:CreateShadow(NotifyFrame, true)

        ContainerFrame.Name = NeverLose.RandomString()
        ContainerFrame.Parent = Notification
        ContainerFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ContainerFrame.BackgroundTransparency = 1
        ContainerFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
        ContainerFrame.BorderSizePixel = 0
        ContainerFrame.Size = UDim2.new(0, 0, 0, 100)
        NotifyFrame.Name = NeverLose.RandomString()
        NotifyFrame.Parent = ContainerFrame
        NotifyFrame.AnchorPoint = Vector2.new(1, 0)
        NotifyFrame.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
        NotifyFrame.BackgroundTransparency = 0.075
        NotifyFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
        NotifyFrame.BorderSizePixel = 0
        NotifyFrame.ClipsDescendants = true
        NotifyFrame.Position = UDim2.new(0, 750, 0, 0)
        NotifyFrame.Size = UDim2.new(0, 220, 0, 55)
        NotifyFrame.ZIndex = 130
        UICorner.CornerRadius = UDim.new(0, 10)
        UICorner.Parent = NotifyFrame
        UIStroke.Transparency = 0.65
        UIStroke.Color = Color3.fromRGB(45, 48, 58)
        UIStroke.Parent = NotifyFrame
        LogoImage.Name = NeverLose.RandomString()
        LogoImage.Parent = NotifyFrame
        LogoImage.AnchorPoint = Vector2.new(0, 0.5)
        LogoImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        LogoImage.BackgroundTransparency = 1
        LogoImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
        LogoImage.BorderSizePixel = 0
        LogoImage.Position = UDim2.new(0, 10, 0.5, 0)
        LogoImage.Size = UDim2.new(0, 35, 0, 35)
        LogoImage.ZIndex = 131
        LogoImage.Image = Config.Logo
        LogoImage.ImageColor3 = NeverLose.IconColor
        UICorner_2.CornerRadius = UDim.new(0, 7)
        UICorner_2.Parent = LogoImage
        NotifyName.Name = NeverLose.RandomString()
        NotifyName.Parent = NotifyFrame
        NotifyName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        NotifyName.BackgroundTransparency = 1
        NotifyName.BorderColor3 = Color3.fromRGB(0, 0, 0)
        NotifyName.BorderSizePixel = 0
        NotifyName.Position = UDim2.new(0, 50, 0, 7)
        NotifyName.Size = UDim2.new(0, 200, 0, 20)
        NotifyName.ZIndex = 132
        NotifyName.Font = Enum.Font.GothamBold
        NotifyName.Text = Config.Title
        NotifyName.TextColor3 = Color3.fromRGB(255, 255, 255)
        NotifyName.TextSize = 17
        NotifyName.TextXAlignment = Enum.TextXAlignment.Left
        NotifyContent.Name = NeverLose.RandomString()
        NotifyContent.Parent = NotifyFrame
        NotifyContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        NotifyContent.BackgroundTransparency = 1
        NotifyContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
        NotifyContent.BorderSizePixel = 0
        NotifyContent.Position = UDim2.new(0, 50, 0, 28)
        NotifyContent.Size = UDim2.new(0, 200, 0, 15)
        NotifyContent.ZIndex = 132
        NotifyContent.Font = Enum.Font.GothamBold
        NotifyContent.Text = Config.Content
        NotifyContent.TextColor3 = Color3.fromRGB(255, 255, 255)
        NotifyContent.TextSize = 12
        NotifyContent.TextTransparency = 0.65
        NotifyContent.TextXAlignment = Enum.TextXAlignment.Left

        local Size1 = TextService:GetTextSize(NotifyName.Text, NotifyName.TextSize, NotifyName.Font, Vector2.new(math.huge, math.huge))
        local Size2 = TextService:GetTextSize(NotifyContent.Text, NotifyContent.TextSize, NotifyContent.Font, Vector2.new(math.huge, math.huge))
        local MainSize = math.max(Size1.X, Size2.X)

        NotifyFrame.Size = UDim2.new(0, MainSize + 65, 0, 55)

        shadow:Render(true)
        NeverLose.PlayAnimate(NotifyFrame, VSlowTween, {
            Position = UDim2.new(1, 0, 0, 0),
        })

        ContainerFrame.Size = UDim2.new(0, 0, 0, 65)

        task.delay(Config.Duration or 5, LPH_NO_VIRTUALIZE(function()
            if NeverLose.__WatermarkCache then
                NeverLose.PlayAnimate(Notification, SlowyTween, {
                    Position = UDim2.new(1, -25, 0, 55),
                })
            end

            shadow:Render(false)
            NeverLose.PlayAnimate(NotifyFrame, SlowyTween, {BackgroundTransparency = 1})
            NeverLose.PlayAnimate(UIStroke, SlowyTween, {Transparency = 1})
            NeverLose.PlayAnimate(LogoImage, SlowyTween, {ImageTransparency = 1})
            NeverLose.PlayAnimate(NotifyName, SlowyTween, {TextTransparency = 1})
            NeverLose.PlayAnimate(NotifyContent, SlowyTween, {TextTransparency = 1})
            task.wait(0.125)
            NeverLose.PlayAnimate(ContainerFrame, SlowyTween, {
                Size = UDim2.new(0, 0, 0, 0),
            })
            task.wait(0.125)
            ContainerFrame:Destroy()
        end))
    end

    return Notifier
end
function NeverLose:CreateLogger()
    if NeverLose.__LogSystem then
        return NeverLose.__LogSystem
    end

    local Logging = {}
    local existingLog = NeverLose.ScreenGui:FindFirstChild('NeverLoseNotifications')

    if existingLog then
        existingLog:Destroy()
    end

    local Log = Instance.new('Frame')
    local UIListLayout = Instance.new('UIListLayout')

    Log.Name = 'NeverLoseNotifications'
    Log.Parent = NeverLose.ScreenGui
    Log.AnchorPoint = Vector2.new(0, 0)
    Log.BackgroundTransparency = 1
    Log.BorderSizePixel = 0
    Log.Position = UDim2.new(0, 16, 0, 62)
    Log.Size = UDim2.new(1, -32, 0, 0)
    Log.ZIndex = 129
    UIListLayout.Parent = Log
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 12)
    NeverLose.__LogSystem = Logging

    local function resolveColor(message, supplied)
        if typeof(supplied) == 'Color3' then
            return supplied
        end

        local lowered = string.lower(message)

        if string.find(lowered, 'miss', 1, true) or string.find(lowered, 'success', 1, true) then
            return Color3.fromRGB(118, 224, 158)
        end
        if string.find(lowered, 'hit', 1, true) or string.find(lowered, 'killed', 1, true) or string.find(lowered, 'error', 1, true) or string.find(lowered, 'not found', 1, true) then
            return Color3.fromRGB(232, 78, 100)
        end

        return NeverLose.AccentColor
    end
    local function getPlainText(text)
        local result = string.gsub(text, '<[^>]->', '')

        result = string.gsub(result, '&lt;', '<')
        result = string.gsub(result, '&gt;', '>')
        result = string.gsub(result, '&amp;', '&')
        result = string.gsub(result, '&quot;', '"')

        return result
    end
    local function toRichColor(color)
        return string.format('rgb(%d,%d,%d)', math.floor(color.R * 255 + 0.5), math.floor(color.G * 255 + 0.5), math.floor(color.B * 255 + 0.5))
    end
    local function escapeRich(text)
        local result = string.gsub(text, '&', '&amp;')

        result = string.gsub(result, '<', '&lt;')
        result = string.gsub(result, '>', '&gt;')

        return result
    end
    local function highlight(message, color)
        if string.find(message, '<', 1, true) then
            return message
        end

        local tint = toRichColor(color)
        local result = escapeRich(message)
        local hits = 0
        local count

        local function wrap(value)
            return '<font color="' .. tint .. '">' .. value .. '</font>'
        end

        result, count = string.gsub(result, '([Hh]it by )(.-)( in the )', function(a, b, c)
            return a .. wrap(b) .. c
        end)
        hits = hits + count
        result, count = string.gsub(result, '(in the )(%a+)( for )', function(a, b, c)
            return a .. wrap(b) .. c
        end)
        hits = hits + count
        result, count = string.gsub(result, '(for )(%d+)( damage)', function(a, b, c)
            return a .. wrap(b) .. c
        end)
        hits = hits + count
        result, count = string.gsub(result, '@([%w_%.%-]+)', function(a)
            return wrap(a)
        end)
        hits = hits + count

        if hits == 0 then
            result, count = string.gsub(result, '(due to )([^%.]+)$', function(a, b)
                return a .. wrap(b)
            end)
            hits = hits + count
        end
        if hits == 0 then
            result, count = string.gsub(result, '([Kk]illed )(.+)$', function(a, b)
                return a .. wrap(b)
            end)
            hits = hits + count
        end
        if hits == 0 then
            result, count = string.gsub(result, '(now )(.+)$', function(a, b)
                return a .. wrap(b)
            end)
            hits = hits + count
        end
        if hits == 0 then
            result = string.gsub(result, '%d+', wrap)
        end

        return result
    end

    function Logging.new(IconStr, Message, Duration, Color)
        if type(IconStr) == 'table' then
            local config = IconStr

            IconStr = config.Icon
            Message = config.Message or config.Title or config.Content
            Duration = config.Duration
            Color = config.Color or config.Accent
        end

        Duration = tonumber(Duration) or 3
        Message = tostring(Message or 'Log')
        IconStr = tostring(IconStr or 'crosshairs')
        Color = resolveColor(Message, Color)

        local LogFrame = Instance.new('Frame')
        local UICorner = Instance.new('UICorner')
        local Line = Instance.new('Frame')
        local LineCorner = Instance.new('UICorner')
        local LineGradient = Instance.new('UIGradient')
        local IconHolder = Instance.new('Frame')
        local IconCorner = Instance.new('UICorner')
        local IconStroke = Instance.new('UIStroke')
        local Icon = Instance.new('TextLabel')
        local LogContent = Instance.new('TextLabel')
        local Shadow = NeverLose:CreateShadow(LogFrame)
        local plainText = getPlainText(Message)
        local toastHeight = 34
        local measured = TextService:GetTextSize(plainText, 15, Enum.Font.GothamBold, Vector2.new(10000, toastHeight))
        local viewportWidth = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize.X or 1280
        local targetWidth = math.clamp(math.ceil(measured.X) + 62, 117, math.max(117, viewportWidth - 40))

        LogFrame.Name = 'NeverLoseNotification'
        LogFrame.Parent = Log
        LogFrame.BackgroundColor3 = Color3.fromRGB(13, 13, 18)
        LogFrame.BackgroundTransparency = 1
        LogFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
        LogFrame.BorderSizePixel = 0
        LogFrame.ClipsDescendants = true
        LogFrame.Size = UDim2.new(0, 0, 0, toastHeight)
        LogFrame.ZIndex = 130
        UICorner.CornerRadius = UDim.new(1, 0)
        UICorner.Parent = LogFrame
        Line.Name = 'AccentLine'
        Line.Parent = LogFrame
        Line.BackgroundColor3 = Color
        Line.BackgroundTransparency = 1
        Line.BorderSizePixel = 0
        Line.AnchorPoint = Vector2.new(0, 0.5)
        Line.Position = UDim2.new(0, 7, 0.5, 0)
        Line.Size = UDim2.new(0, 3, 1, -12)
        Line.ZIndex = 134
        LineCorner.CornerRadius = UDim.new(1, 0)
        LineCorner.Parent = Line
        LineGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color:Lerp(Color3.fromRGB(255, 255, 255), 0.4)),
            ColorSequenceKeypoint.new(0.5, Color),
            ColorSequenceKeypoint.new(1, Color:Lerp(Color3.fromRGB(0, 0, 0), 0.3)),
        })
        LineGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.6),
            NumberSequenceKeypoint.new(0.5, 0),
            NumberSequenceKeypoint.new(1, 0.6),
        })
        LineGradient.Rotation = 90
        LineGradient.Parent = Line
        IconHolder.Name = 'StatusIcon'
        IconHolder.Parent = LogFrame
        IconHolder.AnchorPoint = Vector2.new(0, 0.5)
        IconHolder.BackgroundColor3 = Color
        IconHolder.BackgroundTransparency = 1
        IconHolder.BorderSizePixel = 0
        IconHolder.Position = UDim2.new(0, 20, 0.5, 0)
        IconHolder.Size = UDim2.new(0, 18, 0, 18)
        IconHolder.ZIndex = 133
        IconCorner.CornerRadius = UDim.new(1, 0)
        IconCorner.Parent = IconHolder
        IconStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        IconStroke.Color = Color
        IconStroke.Thickness = 1.35
        IconStroke.Transparency = 1
        IconStroke.Parent = IconHolder
        Icon.Name = 'Glyph'
        Icon.Parent = IconHolder
        Icon.BackgroundTransparency = 1
        Icon.BorderSizePixel = 0
        Icon.Position = UDim2.new(0, 2, 0, 2)
        Icon.Size = UDim2.new(1, -4, 1, -4)
        Icon.ZIndex = 135
        Icon.FontFace = NeverLose.BuiltInBold
        Icon.Text = IconStr
        Icon.TextColor3 = Color
        Icon.TextSize = 12
        Icon.TextTransparency = 1
        Icon.TextWrapped = true

        local LogImage
        local assetId = string.match(IconStr, '^rbxassetid://(%d+)$') or string.match(IconStr, '^(%d+)$')

        if assetId then
            Icon.Text = ''
            IconStroke.Enabled = false
            LogImage = Instance.new('ImageLabel')
            LogImage.Name = 'Image'
            LogImage.Parent = IconHolder
            LogImage.BackgroundTransparency = 1
            LogImage.BorderSizePixel = 0
            LogImage.Position = UDim2.new(0, 0, 0, 0)
            LogImage.Size = UDim2.new(1, 0, 1, 0)
            LogImage.ZIndex = 135
            LogImage.Image = 'rbxassetid://' .. assetId
            LogImage.ImageColor3 = Color
            LogImage.ImageTransparency = 1
        end

        LogContent.Name = 'Message'
        LogContent.Parent = LogFrame
        LogContent.BackgroundTransparency = 1
        LogContent.BorderSizePixel = 0
        LogContent.Position = UDim2.new(0, 50, 0, 0)
        LogContent.Size = UDim2.new(1, -62, 1, 0)
        LogContent.ZIndex = 133
        LogContent.Font = Enum.Font.GothamBold
        LogContent.RichText = true
        LogContent.Text = highlight(Message, Color)
        LogContent.TextColor3 = Color3.fromRGB(210, 214, 222)
        LogContent.TextSize = 15
        LogContent.TextStrokeColor3 = Color3.fromRGB(218, 221, 228)
        LogContent.TextStrokeTransparency = 1
        LogContent.TextTransparency = 1
        LogContent.TextTruncate = Enum.TextTruncate.AtEnd
        LogContent.TextXAlignment = Enum.TextXAlignment.Left
        LogContent.TextYAlignment = Enum.TextYAlignment.Center

        local blurSignal = NeverLose:CreateSignal(true)
        local previousBlurState = NeverLose.EnabledBlur

        NeverLose.EnabledBlur = true

        local blurCreated = pcall(function()
            NeverLose:CreateBlurModule(LogFrame, blurSignal, true)
        end)

        NeverLose.EnabledBlur = previousBlurState

        if not blurCreated then
            blurSignal:SetValue(false)
        end

        Shadow:Render(true)
        NeverLose.PlayAnimate(LogFrame, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, targetWidth, 0, toastHeight),
            BackgroundTransparency = 0.38,
        })
        task.delay(0.06, LPH_NO_VIRTUALIZE(function()
            if not LogFrame.Parent then
                return
            end

            NeverLose.PlayAnimate(Line, SlowyTween, {BackgroundTransparency = 0.08})
            NeverLose.PlayAnimate(IconHolder, SlowyTween, {BackgroundTransparency = 0.88})
            NeverLose.PlayAnimate(IconStroke, SlowyTween, {Transparency = 0.12})
            NeverLose.PlayAnimate(Icon, SlowyTween, {TextTransparency = 0.08})
            NeverLose.PlayAnimate(LogContent, SlowyTween, {
                TextTransparency = 0.05,
                TextStrokeTransparency = 1,
            })

            if LogImage then
                NeverLose.PlayAnimate(LogImage, SlowyTween, {ImageTransparency = 0.06})
            end

            task.wait(Duration)

            if not LogFrame.Parent then
                return
            end

            blurSignal:SetValue(false)
            Shadow:Render(false)
            NeverLose.PlayAnimate(Line, SlowyTween, {BackgroundTransparency = 1})
            NeverLose.PlayAnimate(IconHolder, SlowyTween, {BackgroundTransparency = 1})
            NeverLose.PlayAnimate(IconStroke, SlowyTween, {Transparency = 1})
            NeverLose.PlayAnimate(Icon, SlowyTween, {TextTransparency = 1})
            NeverLose.PlayAnimate(LogContent, SlowyTween, {
                TextTransparency = 1,
                TextStrokeTransparency = 1,
            })

            if LogImage then
                NeverLose.PlayAnimate(LogImage, SlowyTween, {ImageTransparency = 1})
            end

            NeverLose.PlayAnimate(LogFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 0, 0, toastHeight),
                BackgroundTransparency = 1,
            })
            task.wait(0.22)
            LogFrame:Destroy()
        end))
    end

    return Logging
end
function NeverLose:CreateIndicator()
    local IndicatorFrame = Instance.new('Frame')
    local UIListLayout = Instance.new('UIListLayout')

    IndicatorFrame.Name = NeverLose.RandomString()
    IndicatorFrame.Parent = NeverLose.ScreenGui
    IndicatorFrame.AnchorPoint = Vector2.new(0, 0.5)
    IndicatorFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    IndicatorFrame.BackgroundTransparency = 1
    IndicatorFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    IndicatorFrame.BorderSizePixel = 0
    IndicatorFrame.Position = UDim2.new(0, 15, 0.5, 0)
    IndicatorFrame.Size = UDim2.new(0, 100, 0, 100)
    IndicatorFrame.ZIndex = 15
    UIListLayout.Parent = IndicatorFrame
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 10)

    local Indicators = {}

    Indicators.Color = {
        Red = Color3.fromRGB(255, 102, 105),
        Green = Color3.fromRGB(135, 255, 143),
        White = Color3.fromRGB(186, 186, 186),
    }
    Indicators.Root = IndicatorFrame

    function Indicators.new(Config)
        Config = NeverLose:ProcessParams(Config, {
            Name = 'Indicator',
            Icon = 'crosshairs',
            Color = 'Red',
        })

        local Indicator = {
            CurrentColor = Config.Color,
            Visible = false,
        }
        local IndicatorItem = Instance.new('Frame')
        local UICorner = Instance.new('UICorner')
        local Line = Instance.new('Frame')
        local UICorner_2 = Instance.new('UICorner')
        local UIGradient = Instance.new('UIGradient')
        local Icon = Instance.new('TextLabel')
        local Content = Instance.new('TextLabel')
        local Shadow = NeverLose:CreateShadow(IndicatorItem)

        IndicatorItem.Name = NeverLose.RandomString()
        IndicatorItem.BackgroundColor3 = Color3.fromRGB(8, 8, 13)
        IndicatorItem.BackgroundTransparency = 1
        IndicatorItem.BorderColor3 = Color3.fromRGB(0, 0, 0)
        IndicatorItem.BorderSizePixel = 0
        IndicatorItem.ClipsDescendants = true
        IndicatorItem.Size = UDim2.new(0, 85, 0, 40)
        IndicatorItem.ZIndex = 16
        IndicatorItem.Visible = false

        IndicatorItem:GetPropertyChangedSignal('BackgroundTransparency'):Connect(LPH_NO_VIRTUALIZE(function()
            if IndicatorItem.BackgroundTransparency > 0.9 then
                IndicatorItem.Parent = nil
                IndicatorItem.Visible = false
            else
                IndicatorItem.Parent = IndicatorFrame
                IndicatorItem.Visible = true
            end
        end))

        UICorner.CornerRadius = UDim.new(0, 25)
        UICorner.Parent = IndicatorItem
        Line.Name = NeverLose.RandomString()
        Line.Parent = IndicatorItem
        Line.AnchorPoint = Vector2.new(0, 0.5)
        Line.BackgroundColor3 = Color3.fromRGB(186, 186, 186)
        Line.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Line.BorderSizePixel = 0
        Line.Position = UDim2.new(0, 2, 0.5, 0)
        Line.BackgroundTransparency = 1
        Line.Size = UDim2.new(0, 3, 0.649999976, 0)
        Line.ZIndex = 17
        UICorner_2.CornerRadius = UDim.new(0, 25)
        UICorner_2.Parent = Line
        UIGradient.Rotation = 90
        UIGradient.Transparency = NumberSequence.new{
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.5, 0),
            NumberSequenceKeypoint.new(1, 1),
        }
        UIGradient.Parent = Line
        Icon.Name = NeverLose.RandomString()
        Icon.Parent = IndicatorItem
        Icon.AnchorPoint = Vector2.new(0, 0.5)
        Icon.BackgroundColor3 = Color3.fromRGB(186, 186, 186)
        Icon.BackgroundTransparency = 1
        Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Icon.BorderSizePixel = 0
        Icon.Position = UDim2.new(0, 10, 0.5, 0)
        Icon.Size = UDim2.new(0, 25, 0, 25)
        Icon.ZIndex = 17
        Icon.FontFace = NeverLose.BuiltInBold
        Icon.Text = Config.Icon
        Icon.TextColor3 = Color3.fromRGB(186, 186, 186)
        Icon.TextSize = 21
        Icon.TextTransparency = 1
        Icon.TextWrapped = true
        Content.Name = NeverLose.RandomString()
        Content.Parent = IndicatorItem
        Content.AnchorPoint = Vector2.new(0, 0.5)
        Content.BackgroundColor3 = Color3.fromRGB(186, 186, 186)
        Content.BackgroundTransparency = 1
        Content.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Content.BorderSizePixel = 0
        Content.Position = UDim2.new(0, 40, 0.5, 0)
        Content.Size = UDim2.new(1, -40, 0, 25)
        Content.ZIndex = 17
        Content.Font = Enum.Font.GothamBold
        Content.Text = Config.Name
        Content.TextColor3 = Color3.fromRGB(186, 186, 186)
        Content.TextSize = 20
        Content.TextTransparency = 1
        Content.TextXAlignment = Enum.TextXAlignment.Left
        Indicator.Update = LPH_NO_VIRTUALIZE(function()
            local text = TextService:GetTextSize(Content.Text, Content.TextSize, Content.Font, Vector2.new(math.huge, math.huge))

            NeverLose.PlayAnimate(IndicatorItem, SlowyTween, {
                Size = UDim2.new(0, text.X + 60, 0, 40),
            })
        end)
        Indicator.SetRender = LPH_NO_VIRTUALIZE(function(self, value)
            Indicator.Visible = value

            if value then
                NeverLose.PlayAnimate(IndicatorItem, SlowyTween, {BackgroundTransparency = 0.2})
                NeverLose.PlayAnimate(Line, SlowyTween, {
                    BackgroundTransparency = 0,
                    BackgroundColor3 = Indicators.Color[Indicator.CurrentColor],
                })
                NeverLose.PlayAnimate(Icon, VSlowTween, {
                    TextTransparency = 0.25,
                    TextColor3 = Indicators.Color[Indicator.CurrentColor],
                })
                NeverLose.PlayAnimate(Content, VSlowTween, {
                    TextTransparency = 0.2,
                    TextColor3 = Indicators.Color[Indicator.CurrentColor],
                })
                Shadow:Render(true)
            else
                NeverLose.PlayAnimate(IndicatorItem, SlowyTween, {BackgroundTransparency = 1})
                NeverLose.PlayAnimate(Line, SlowyTween, {
                    BackgroundTransparency = 1,
                    BackgroundColor3 = Indicators.Color[Indicator.CurrentColor],
                })
                NeverLose.PlayAnimate(Icon, VSlowTween, {
                    TextTransparency = 1,
                    TextColor3 = Indicators.Color[Indicator.CurrentColor],
                })
                NeverLose.PlayAnimate(Content, VSlowTween, {
                    TextTransparency = 1,
                    TextColor3 = Indicators.Color[Indicator.CurrentColor],
                })
                Shadow:Render(false)
            end

            Indicator.Update()
        end)

        Indicator.Update()
        Indicator:SetRender(false)

        function Indicator:SetColor(new_color)
            Indicator.CurrentColor = new_color

            if Indicator.Visible then
                Indicator:SetRender(true)
            end
        end
        function Indicator:SetText(name)
            Config.Name = name
            Content.Text = Config.Name

            Indicator.Update()
        end

        return Indicator
    end

    return Indicators
end
function NeverLose:Unload()
    if not NeverLose.UnloadEnabled then
        return
    end

    NeverLose.ScreenGui:Destroy()

    for i, v in next, NeverLose.GlobalSignals do
        pcall(v.Disconnect, v)
    end

    if NeverLose.BindSignals then
        for i, v in next, NeverLose.BindSignals do
            pcall(v.Disconnect, v)
        end

        table.clear(NeverLose.BindSignals)
    end
end

getgenv().__NL_CURRENT_TEST = NeverLose

return NeverLose
