# atmos-env-iup

An [Atmos][atmos] environment for graphical user interfaces (GUIs)
based on [IUP][iup] ([iup-lua][iup-lua]).

[atmos]:    https://github.com/lua-atmos/atmos/
[iup]:      https://www.tecgraf.puc-rio.br/iup/
[iup-lua]:  https://www.tecgraf.puc-rio.br/iup/en/basic/index.html

# Install

```
sudo luarocks --lua-version=5.4 install atmos-env-iup
```

# Run

```
lua5.4 <lua-path>/atmos/env/iup/exs/button-counter.lua
```

# Events

- `clock`
- `'action'`
- `'value'`
- `'close'`

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
