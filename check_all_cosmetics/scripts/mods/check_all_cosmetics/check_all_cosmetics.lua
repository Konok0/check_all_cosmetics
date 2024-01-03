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

					if mod:get("mod_see") then
						verified_items[item_name] = item
					elseif item.always_owned then
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

	if archetype_valid and breed_valid and (no_crimes or crime_valid) then
		return true
	elseif mod:get("mod_filter") then
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

				if (table.contains(inventory_slots_array, slot_name) and (item.always_owned or owned_gear_by_master_id[item_name]) and not is_fallback) then
					verified_items[item_name] = item
					break
				elseif mod:get("mod_see") then
					verified_items[item_name] = item
					break
				end
			end
		end
	end

	return verified_items
end)
