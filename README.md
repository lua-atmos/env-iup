# atmos-env-iup

An [Atmos][atmos] environment for graphical user interfaces (GUIs)
based on [IUP][iup] ([iup-lua][iup-lua]).

[atmos]:    https://github.com/lua-atmos/atmos/
[iup]:      https://www.tecgraf.puc-rio.br/iup/
[iup-lua]:  https://www.tecgraf.puc-rio.br/iup/en/basic/index.html

[
    [`v0.2`](https://github.com/lua-atmos/env-iup/tree/v0.2)  |
    [`v0.1`](https://github.com/lua-atmos/env-iup/tree/v0.1)
]

Stable branch is [`v0.2`](https://github.com/lua-atmos/env-iup/tree/v0.2).

# Install

```
sudo luarocks --lua-version=5.4 install atmos-env-iup
```

Dependencies: `iuplua`, `atmos v0.7`

# Run

```
lua5.4 <lua-path>/atmos/env/iup/exs/button-counter.lua
```

# Events

- clock: bare-number microseconds (core `'clock'` primitive)
- widget events: `{ tag='action'|'value'|'close', h=<handle>, v=<data> }`
    - `every{ tag='action', h=but }` -- this widget
    - `await{ tag='close', h=dlg }` -- dialog close
    - `h` is the IUP handle itself (`iup.button{}` / `iup.dialog{}`)

# Source

Assumes this directory structure:

```
.
├── atmos/
├── env-iup/
└── f-streams/
```

```bash
LUA_PATH="../f-streams/?/init.lua;../atmos/?.lua;../atmos/?/init.lua;;" lua5.4 exs/button-counter.lua
```
