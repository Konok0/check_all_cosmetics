local mod = get_mod("check_all_cosmetics")

mod:hook(CLASS.InventoryCosmeticsView, "_verify_items", function(func, self, source_items, owned_gear, ...)
	local selected_slot = self._selected_slot
	local selected_slot_name = selected_slot.name
	local verified_items = {}
	local owned_gear_by_master_id = {}

	if owned_gear then
		for gear_id, item in pairs(owned_gear) do
			local item_name = item.name
			owned_gear_by_master_id[item_name] = item
		end
	end

	for item_name, item in pairs(source_items) do
		local slots = item.slots

		if slots then
			for i = 1, #slots do
				local slot_name = slots[i]

				if selected_slot_name == slot_name then
					if owned_gear_by_master_id[item_name] then
						verified_items[item_name] = owned_gear_by_master_id[item_name]

						break
					end

					if item.always_owned or mod:get("mod_see") then
						verified_items[item_name] = item
					end
					
					break
				end
			end
		end
	end

	return verified_items
end)

mod:hook(CLASS.InventoryCosmeticsView, "_item_valid_by_current_profile", function(func, self, item, ...)
	local player = self._preview_player
	local profile = player:profile()
	local archetype = profile.archetype
	local lore = profile.lore
	local backstory = lore.backstory
	local crime = backstory.crime
	local archetype_name = archetype.name
	local breed_name = archetype.breed
	local breed_valid = not item.breeds or table.contains(item.breeds, breed_name)
	local crime_valid = not item.crimes or table.contains(item.crimes, crime)
	local no_crimes = item.crimes == nil or table.is_empty(item.crimes)
	local archetype_valid = not item.archetypes or table.contains(item.archetypes, archetype_name)

	if archetype_valid and breed_valid and (no_crimes or crime_valid) or mod:get("mod_filter") and not mod:get("mod_try") then
		return true
	end

	return false
end)

mod:hook(CLASS.CharacterCreate, "_verify_items", function(func, self, source_items, owned_gear, ...)
	local verified_items = {}
	local inventory_slots_array = self._inventory_slots_array
	local owned_gear_by_master_id = {}

	if owned_gear then
		for id, item in pairs(owned_gear) do
			owned_gear_by_master_id[item.masterDataInstance.id] = item
		end
	end

	for item_name, item in pairs(source_items) do
		local slots = item.slots

		if slots then
			for i = 1, #slots do
				local slot_name = slots[i]
				local is_fallback = self:_is_fallback_item(slot_name, item_name)

				if (table.contains(inventory_slots_array, slot_name) and (item.always_owned or owned_gear_by_master_id[item_name]) and not is_fallback) or mod:get("mod_see") then
					verified_items[item_name] = item
					break
				end
			end
		end
	end

	return verified_items
end)

mod:hook(CLASS.InventoryBackgroundView, "_equip_slot_item", function(func, self, slot_name, item, force_update, ...)
	func(self, slot_name, item, force_update, ...)	
	local presentation_loadout = self._preview_profile_equipped_items
	local current_loadout = self._current_profile_equipped_items
	local player_profile = self._presentation_profile
	
	if mod:get("mod_try") then
		presentation_loadout[slot_name] = item
		if player_profile then
			current_loadout[slot_name] = item
			self._invalid_slots[slot_name] = item
		end	
	end
end)

mod.is_in_hub = function()
    local game_mode = Managers.state.game_mode and Managers.state.game_mode:game_mode_name()

	return game_mode and (game_mode == "coop_complete_objective" or game_mode == "default" or game_mode == "prologue" or game_mode == "prologue_hub")
end

local _notify_current_state = function(setting, text_key)
    if not mod.is_in_hub() then
		if mod:get("mod_see") then
			mod:notify(mod:localize(text_key) .. ": " .. "ON")
		else	
			mod:notify(mod:localize(text_key) .. ": " .. "OFF")
		end
	end
end

local _notify_current_state_2 = function(setting, text_key)
    if not mod.is_in_hub() then
		if mod:get("mod_try")then
			mod:notify(mod:localize(text_key) .. ": " .. "ON")
		else	
			mod:notify(mod:localize(text_key) .. ": " .. "OFF")
		end
	end
end

mod.mod_see_on_off = function()	
    if not mod.is_in_hub() or not Managers.ui:chat_using_input() then
        mod:set("mod_see", not mod:get("mod_see"))
        mod._is_enabled = not mod._is_enabled
		_notify_current_state(mod._is_enabled, "mod_see")
    end
end

mod.mod_try_on_off = function()	
    if not mod.is_in_hub() or not Managers.ui:chat_using_input() then
        mod:set("mod_try", not mod:get("mod_try"))
        mod._is_enabled = not mod._is_enabled
		_notify_current_state_2(mod._is_enabled, "mod_try_notif")
    end
end



mod:hook_safe("InventoryCosmeticsView", "_preview_element", function(self, element)
local item = element.item
    local item_name = item.name
    if item then
        local widgets_by_name = self._widgets_by_name

        if mod:get("mod_see_sysname") then
            widgets_by_name.unlock_details.content.text = item_name
        end
    end
end)
