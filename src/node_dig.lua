-- extended_protection/src/node_dig.lua
-- Handle minetest.node_dig
-- Copyright (C) 2024  1F616EMO
-- SPDX-License-Identifier: LGPL-3.0-or-later

local _int = extended_protection.internal
local logger = _int.logger:sublogger("node_dig")

extended_protection.node_dig_is_protected,
extended_protection.registered_on_node_dig_protection_violation,
extended_protection.register_on_node_dig_protection_violation,
extended_protection.record_on_node_dig_protection_violation = _int.create_functions()

-- extended_protection.node_dig_is_protected(pos, node, digger) -> boolean
-- extended_protection.register_on_node_dig_protection_violation(function(pos, node, digger) end)

local old_node_dig = minetest.node_dig

function minetest.node_dig(pos, node, digger)
    if extended_protection.node_dig_is_protected(pos, node, digger) then
        extended_protection.record_on_node_dig_protection_violation(pos, node, digger)
        return
    end
    return old_node_dig(pos, node, digger)
end

function node_to_string(node)
    return string.format("%s, param1=%d, param2=%d",
        node.name, node.param1, node.param2)
end

extended_protection.register_on_node_dig_protection_violation(function(pos, node, digger)
    logger:action((digger and digger:is_player() and digger:get_player_name() or "A mod") ..
        " attempted to dig " .. node_to_string(node) .. " at " .. minetest.pos_to_string(pos))
end)
