-- More Options for Saints Row The Third: Lua half. Copy to <game>\SR3ModUI\mods\.
-- Adds BORDERLESS as a third choice of Options > Display > Display mode. The stock screen only knows
-- Full screen (1) and Windowed (2); borderless is "windowed" for the game, and MoreOptionsSRTT.asi removes
-- the window frame when the ini flag is set.
local ID_WINDOW_MODE = 6
local Sel = false		-- the row currently shows Borderless
local Fresh = false	-- the screen was just opened: derive the choice from the saved setting
local Busy = false	-- an apply is in flight (see below)
local Busy_at = 0

local function get_row()
	local l = ModUI.get_global("List")
	if l == nil then return nil end
	return l:get_data_from_id(ID_WINDOW_MODE)
end

ModUI.modify("display", function(data)
	for i = 1, #data do
		local it = data[i]
		if type(it) == "table" and it.id == ID_WINDOW_MODE and it.options ~= nil then
			if it.options[3] == nil then it.options[3] = "BORDERLESS" end
			if Fresh then
				Fresh = false
				Sel = (it.current_value == 2) and (ModUI.call("moreopts_get", "borderless") == 1)
			end
			if Sel and it.current_value == 2 then it.current_value = 3 end
		end
	end
end)

ModUI.wrap("pause_options_display_pc_init", function(orig, ...)
	Fresh = true
	Busy = false
	return orig(...)
end)

ModUI.wrap("options_display_nav_left_or_right", function(orig, direction)
	local l = ModUI.get_global("List")
	local was = l ~= nil and l:get_id() or nil
	local r = orig(direction)
	if was == ID_WINDOW_MODE then
		local it = get_row()
		if it ~= nil then Sel = (it.current_value == 3) end
	end
	return r
end)

-- One apply at a time. An apply starts a resolution change and a "keep these settings?" dialog with its own
-- timer thread; a second apply while that is pending overlaps them and can crash the game. So while one is
-- in flight further applies are ignored, until the dialog is answered (options_display_confirm) or 20 s pass.
local function now()
	local f = ModUI.get_global("vint_get_time_index")
	if f == nil then return 0 end
	return f()
end

ModUI.wrap("options_display_confirm", function(orig, ...)
	Busy = false
	local r = orig(...)		-- a "No" re-applies the old settings inside this call
	Busy = false
	return r
end)

local function clear_busy(orig, ...)
	Busy = false
	return orig(...)
end
ModUI.wrap("pause_options_display_pc_cleanup", clear_busy)

-- Apply: the game must see Windowed; we tell the plugin what the player really chose
ModUI.wrap("options_display_update_option_value", function(orig, ...)
	if Busy and now() - Busy_at < 20 then return end		-- an apply is already running: ignore this one
	Busy = true
	Busy_at = now()
	local it = get_row()
	local want = Sel
	if it ~= nil and want and it.current_value == 3 then it.current_value = 2 end
	ModUI.call("moreopts_set_borderless", want and 1 or 0)
	local r = orig(...)
	if it ~= nil and want then it.current_value = 3 end
	return r
end)

ModUI.wrap("options_display_revert", function(orig, ...)
	local r = orig(...)
	Fresh = true
	return r
end)
