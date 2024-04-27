-- extended_protection/init.lua
-- Extended interaction restriction rule
-- Copyright (C) 2024  1F616EMO
-- SPDX-License-Identifier: LGPL-3.0-or-later

extended_protection = {}
extended_protection.internal = {}
extended_protection.internal.S = minetest.get_translator("extended_protection")
extended_protection.internal.logger = logging.logger("extended_protection")

local MP = minetest.get_modpath("extended_protection")
for _, name in ipairs({
    "functions",
    "item_place_node",
    "node_dig",
}) do
    dofile(MP .. "/src/" .. name .. ".lua")
end

