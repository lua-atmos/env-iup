require "atmos.env.socket"
require "atmos.env.iup"

local txt = iup.text {
    value=0, readonly="YES", size="60",
}

local btn = iup.button {
    title="Count", size="60"
}

local dlg = iup.dialog {
    title="Counter", margin="10x10",
    iup.hbox { txt, btn; ngap="10" },
}

dlg:showxy(iup.CENTER, iup.CENTER)

loop(function ()
    do_spawn(function ()
        loop_on(1*_s_, function ()
            print'1s'
        end)
    end)
    watching({tag='close', h=dlg}, function ()
        loop_on({tag='action', h=btn}, function ()
            txt.value = txt.value + 1
        end)
    end)
end)
