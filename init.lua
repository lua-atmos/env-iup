local atmos = require "atmos"
require "atmos.util"

local iup = require("iuplua")

-------------------------------------------------------------------------------

local function iup_close (self, ...)
    emit{tag='close', h=self}
end

local function iup_action (self, ...)
    emit{tag='action', h=self}
end

local function iup_value (self, ...)
    emit{tag='value', h=self, v=...}
end

local iup_dialog = iup.dialog
function iup.dialog (...)
    local h = iup_dialog(...)
    h.close_cb = iup_close
    return h
end

local iup_button = iup.button
function iup.button (...)
    local h = iup_button(...)
    h.action = iup_action
    return h
end

local iup_text = iup.text
function iup.text (...)
    local h = iup_text(...)
    h.valuechanged_cb = iup_value
    return h
end

local iup_list = iup.list
function iup.list (...)
    local h = iup_list(...)
    h.valuechanged_cb = iup_value
    return h
end

-------------------------------------------------------------------------------

local M = {
    now = 0,
}

local timer = iup.timer{time=100}
function timer:action_cb()
    local cur = M.env.mode and M.env.mode.current
    if cur ~= 'secondary' then
        M.now = M.now + 100
        emit(100 * 1000)
    end
    return iup.DEFAULT
end
timer.run = "YES"

M.env = {
    mode = { primary=true, secondary=true },
    quit = iup.Close,
    step = function ()
        local cur = M.env.mode and M.env.mode.current
        if cur == 'secondary' then
            iup.LoopStep()
            iup.Flush()
        else
            iup.LoopStepWait()
        end
        return false
    end,
}

atmos.env(M.env)

return M
