local mod = get_mod("check_all_cosmetics")

local mod_data = {
  name = mod:localize("mod_name"),
  description = mod:localize("mod_description"),
  is_togglable = true,
    options = {
        widgets = {
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
		}
	}
}

return mod_data
