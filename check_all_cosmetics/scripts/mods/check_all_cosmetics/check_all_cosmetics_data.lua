local mod = get_mod("check_all_cosmetics")

local mod_data = {
  name = mod:localize("mod_name"),
  description = mod:localize("mod_description"),
  is_togglable = true,
    options = {
        widgets = {
			{
				setting_id = "mod_see_all",
				type = "dropdown",
				default_value = "mod_not_all",
				options = {
					{ text = "loc_not_all", value = "mod_not_all" },
					{ text = "loc_all", value = "mod_all" },
				},
			},
		}
	}
}

return mod_data
