-- extended_protection/src/item_place_node.lua
-- Handle minetest.item_place_node
-- Copyright (C) 2024  1F616EMO
-- SPDX-License-Identifier: LGPL-3.0-or-later

local _int = extended_protection.internal
local logger = _int.logger:sublogger("item_place_node")

extended_protection.item_place_node_is_protected,
extended_protection.registered_on_item_place_node_protection_violation,
extended_protection.register_on_item_place_node_protection_violation,
extended_protection.record_on_item_place_node_protection_violation = _int.create_functions()

-- extended_protection.item_place_node_is_protected(itemstack, placer, pointed_thing) -> boolean
-- extended_protection.register_on_item_place_node_protection_violation(function(itemstack, placer, pointed_thing) end)

local old_item_place_node = minetest.item_place_node

function minetest.item_place_node(itemstack, placer, pointed_thing, param2, prevent_after_place)
    if extended_protection.item_place_node_is_protected(itemstack, placer, pointed_thing) then
        extended_protection.record_on_item_place_node_protection_violation(itemstack, placer, pointed_thing)
        return itemstack, nil
    end
    return old_item_place_node(itemstack, placer, pointed_thing, param2, prevent_after_place)
end

local function pointed_thing_to_string(pointed_thing)
    if pointed_thing.type == "nothing" then
        return "type=nothing"
    elseif pointed_thing.type == "node" then
        return string.format("type=node, under=%s, above=%s",
            minetest.pos_to_string(pointed_thing.under),
            minetest.pos_to_string(pointed_thing.above))
    elseif pointed_thing.type == "object" then
        return "type=object"
    end
    return "type=unknown"
end

extended_protection.register_on_item_place_node_protection_violation(function(itemstack, placer, pointed_thing)
    logger:action((placer and placer:is_player() and placer:get_player_name() or "A mod") ..
        " attempted to place " .. itemstack:to_string() .. " at " .. pointed_thing_to_string(pointed_thing))
end)