-- extended_protection/src/functions.lua
-- Rules functions
-- Copyright (C) 2024  1F616EMO
-- SPDX-License-Identifier: LGPL-3.0-or-later

local _int = extended_protection.internal

local function rtn_false() return false end

function _int.create_functions()
    local callbacks = {}
    local function register_callback(func)
        callbacks[#callbacks+1] = func
    end
    local function run_callbacks(...)
        for _, func in ipairs(callbacks) do
            func(...)
        end
    end
    return rtn_false, callbacks, register_callback, run_callbacks
end
