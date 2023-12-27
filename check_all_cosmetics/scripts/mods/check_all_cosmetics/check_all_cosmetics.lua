local mod = get_mod("check_all_cosmetics")
local CharacterCreate = require("scripts/utilities/character_create")
local InventoryWeaponCosmeticsView = require("scripts/ui/views/inventory_weapon_cosmetics_view/inventory_weapon_cosmetics_view")

mod:hook_origin("InventoryCosmeticsView", "_verify_items", function(self, source_items, owned_gear)
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

					if mod:get("mod_see_all") == "mod_all" then
						verified_items[item_name] = item
					elseif mod:get("mod_see_all") == "mod_not_all" and item.always_owned then
						verified_items[item_name] = item
					end
					
					break
				end
			end
		end
	end

	return verified_items
end)

mod:hook_origin("CharacterCreate", "_verify_items", function(self, source_items, owned_gear)
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

				if (table.contains(inventory_slots_array, slot_name) and (item.always_owned or owned_gear_by_master_id[item_name]) and not is_fallback) and mod:get("mod_see_all") == "mod_not_all" then
					verified_items[item_name] = item
					break
				elseif mod:get("mod_see_all") == "mod_all" then
					verified_items[item_name] = item
					break
				end
			end
		end
	end

	return verified_items
end)