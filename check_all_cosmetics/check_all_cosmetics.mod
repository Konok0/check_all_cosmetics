return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`check_all_cosmetics` encountered an error loading the Darktide Mod Framework.")

		new_mod("check_all_cosmetics", {
			mod_script       = "check_all_cosmetics/scripts/mods/check_all_cosmetics/check_all_cosmetics",
			mod_data         = "check_all_cosmetics/scripts/mods/check_all_cosmetics/check_all_cosmetics_data",
			mod_localization = "check_all_cosmetics/scripts/mods/check_all_cosmetics/check_all_cosmetics_localization",
		})
	end,
	packages = {},
}
