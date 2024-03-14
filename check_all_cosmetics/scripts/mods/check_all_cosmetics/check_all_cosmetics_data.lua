local mod = get_mod("check_all_cosmetics")

local mod_data = {
  name = mod:localize("mod_name"),
  description = mod:localize("mod_description"),
  is_togglable = true,
    options = {
        widgets = {
            {
                setting_id = "mod_see_key",
                type = "keybind",
                default_value = {},
                keybind_trigger = "pressed",
                keybind_type = "function_call",
                function_name = "mod_see_on_off",
            },	
            {
                setting_id = "mod_see",
                type = "checkbox",
                default_value = false,
            },
            {
                setting_id = "mod_filter",
                type = "checkbox",
                default_value = false,
            },
            {
                setting_id = "mod_try",
                type = "checkbox",
                default_value = false,
            },
            {
                setting_id = "mod_try_key",
                type = "keybind",
                default_value = {},
                keybind_trigger = "pressed",
                keybind_type = "function_call",
                function_name = "mod_try_on_off",
            },	
            {
					setting_id = "mod_see_sysname",
					type = "checkbox",
					default_value = false,
            },
		}
	}
}

return mod_data
