require "atmos.env.iup"
require "iuplua"

local txt = iup.text { value=0, readonly="YES", size="60" }
local but = iup.button { title="Count", size="60" }
local dlg = iup.dialog {
    title  = "Button - Counter",
    margin = "10x10", 
    iup.hbox {
        txt, but,
        ngap = "10",
    },
}

dlg:showxy(iup.CENTER, iup.CENTER)

loop(function ()
    watching(dlg,'close', function ()
        every(but,'action', function ()
            txt.value = txt.value + 1
        end)
    end)
end)
