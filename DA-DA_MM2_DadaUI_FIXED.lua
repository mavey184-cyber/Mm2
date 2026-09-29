-- DA-DA MM2 FIXED LOADER
-- Загружает актуальный файл с GitHub и чинит problematic equip() перед запуском.

local URL = "https://raw.githubusercontent.com/mavey184-cyber/Mm2/refs/heads/main/DA-DA_MM2_DadaUI.lua"

local okGet, src = pcall(function()
    return game:HttpGet(URL)
end)

if not okGet or type(src) ~= "string" then
    error("[DA-DA FIX] Не удалось загрузить основной файл: " .. tostring(src))
end

-- 1) Убираем опасную зависимость от ProfileData в equip().
local oldEquip = [[local function equip(entry)
		local ok, pd = pcall(function() return require(rstor.Modules.ProfileData) end)
		if ok and pd and pd.Weapons and pd.Weapons.Equipped then
			pd.Weapons.Equipped[entry.kind] = entry.id
		end
		pcall(function()
			rstor.Remotes.Inventory.Equip:FireServer(entry.id, "Weapons")
		end)
	end]]

local newEquip = [[local function equip(entry)
		if type(entry) ~= "table" then
			warn("[DA-DA] equip: invalid entry")
			return false
		end

		if not entry.id then
			warn("[DA-DA] equip: missing entry.id")
			return false
		end

		local ok, err = pcall(function()
			local remotes = rstor.Remotes
			local inventory = remotes and remotes:FindFirstChild("Inventory")
			local equipRemote = inventory and inventory:FindFirstChild("Equip")
			if not equipRemote then
				error("Inventory.Equip not found")
			end
			equipRemote:FireServer(entry.id, "Weapons")
		end)

		if not ok then
			warn("[DA-DA] Equip failed:", err)
			return false
		end
		return true
	end]]

if src:find(oldEquip, 1, true) then
    src = src:gsub(oldEquip, newEquip, 1)
else
    warn("[DA-DA FIX] equip() block не найден — возможно, GitHub-файл уже изменён.")
end

-- 2) Не прекращаем выполнение только потому, что внешняя dada_ui.lua недоступна.
local oldReturn = [[if type(lib) ~= "table" or type(lib.window) ~= "function" then
	return
end]]

local newReturn = [[if type(lib) ~= "table" or type(lib.window) ~= "function" then
	warn("[DA-DA] External dada_ui.lua unavailable — continuing with built-in UI")
	lib = {
		notify = function() end,
		popup = function() end,
		ask = function() return nil end,
		unload = function()
			local root = getgenv().DADA_SIDEBAR_ROOT
			if root then
				pcall(function() root:Destroy() end)
			end
		end,
		window = function() return nil end,
	}
end]]

if src:find(oldReturn, 1, true) then
    src = src:gsub(oldReturn, newReturn, 1)
end

local fn, err = loadstring(src, "@DA-DA_MM2_DadaUI_FIXED")
if not fn then
    error("[DA-DA FIX] Ошибка компиляции: " .. tostring(err))
end

local okRun, runErr = pcall(fn)
if not okRun then
    error("[DA-DA FIX] Ошибка запуска: " .. tostring(runErr))
end

print("[DA-DA FIX] Loaded")
