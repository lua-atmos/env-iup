# Plan: Release env-iup v0.2 (atmos v0.7)

## STATUS (@ 2026-06-10): code migrated (steps 1-2); needs tests

Done: `init.lua` (`__atmos` + `meta` deleted; events
`{tag='close'|'action'|'value', h=self, v=...}`; clock
`emit(100*1000)`) + all 3 exs (`_s_`/`_ms_` + `{tag, h=<handle>}`
patterns). Adopted Option A: key on the iup HANDLE directly
(`h=self` / `h=but`); `.atm` proxy REMOVED. Phase-1 PASSED
(handle keying confirmed). README + `0.2-1` rockspec done.
Pending: `luarocks make`, Phase-2, commit + `v0.2` + ff main,
upload.

`env-iup` is at `v0.1` (atmos >= 0.6, uses the removed
`__atmos` metamethod). atmos `v0.7` is released; env-sdl
(`v0.2`), env-pico (`v0.3`), env-socket (`v0.2`) are migrated +
released and serve as reference. This migrates env-iup to v0.7
and cuts `v0.2`.

VERSION: `v0.2` (first bump after `v0.1`).

DEP NOTE: `exs/iup-net.lua` requires `atmos.env.socket` (just
released at v0.2) -> ensure env-socket is installed for tests.

## Context

env-iup keys widget events on the IUP HANDLE via a per-handle
`.atm` proxy table, matched by a custom `__atmos` metamethod,
with MULTI-ARG `emit`/`await`, and a manual `'clock'` emit.
v0.7 breaks all of it:

- `__atmos` REMOVED: no custom matching. Use core table
  patterns `{tag=..., h=...}` matched field-by-field via
  `M.is` (run.lua:617-630), consistent with env-socket.
- Events SINGLE-ARG: widget events become
  `{tag='close'|'action'|'value', h=<handle-id>, v=<data>}`.
- Clock: emit a BARE NUMBER in microseconds (no `'clock'`
  tag); timer fires every 100 ms -> `emit(100 * 1000)`.
- exs timers use constants `_s_`/`_ms_`.

Env API already OK: main body + `quit = iup.Close`, `mode`,
`step` (no `open`). Keep as-is.

## KEY DECISION: how to key the widget handle (`h=`) -- RESOLVED: A

Old `__atmos` compared `await.atm == emit_self.atm` (a table
stored on the widget), routing identity through `.atm`. But
iuplua caches ONE Lua wrapper per widget (keyed by the C
ihandle), so the callback `self` IS the same object as `but` --
the `.atm` indirection was defensive, not required.

- Option A (ADOPTED): key on the iup handle directly.
    - emit `{tag='action', h=self}` / await `{tag='action', h=but}`
    - `.atm` proxy removed entirely (cleaner exs + init).
    - assumes iuplua wrapper caching -> VERIFY in Phase-1.
- Option B (fallback): re-introduce `h.atm = {}` and key on
  `.atm` IF a click fails to match under A.

## Migration map (init.lua)

| old (v0.1)                          | new (v0.7)                          |
|-------------------------------------|-------------------------------------|
| `meta.__atmos = function ... end`   | DELETE whole `meta` table           |
| `h.atm = setmetatable({}, meta)`    | DELETE (key on handle directly)     |
| `emit(self.atm, 'close', ...)`      | `emit{tag='close', h=self}`         |
| `emit(self.atm, 'action', ...)`     | `emit{tag='action', h=self}`        |
| `emit(self.atm, 'value', ...)`      | `emit{tag='value', h=self, v=...}`  |
| `emit('clock', 100, M.now)`         | `emit(100 * 1000)` (bare us)        |

`M.now` stays ms (`M.now = M.now + 100`), still drives
`env.now`; just drop the extra emit args.

## Migration map (examples)

| file                  | old                       | new                                   |
|-----------------------|---------------------------|---------------------------------------|
| `exs/hello.lua`       | `clock{s=5}`              | `5 * _s_`                             |
| `exs/hello.lua`       | `clock{ms=500}`           | `500 * _ms_`                         |
| `exs/button-counter`  | `watching(dlg,'close',f)` | `watching({tag='close', h=dlg},f)`    |
| `exs/button-counter`  | `every(but,'action',f)`   | `every({tag='action', h=but},f)`      |
| `exs/iup-net`         | `clock{s=1}`              | `1 * _s_`                             |
| `exs/iup-net`         | `watching(dlg,'close',f)` | `watching({tag='close', h=dlg},f)`    |
| `exs/iup-net`         | `every(btn,'action',f)`   | `every({tag='action', h=btn},f)`      |

## Steps

Two test phases (mirror env-socket):
1. Local: `LUA_PATH` trick from README.
2. Global: `luarocks make`, then test.

1. [x] Migrate `init.lua` to v0.7 API (dropped `__atmos`/`meta`,
       table events `{tag,h,v}`, bare-us clock)
2. [x] Migrate exs (`hello`, `button-counter`, `iup-net`):
       `_s_`/`_ms_` + `{tag=..., h=.atm}` patterns
3. [x] Update `README.md` (version block + stable `v0.2`,
       `Dependencies: iuplua, atmos v0.7`, Events re-keyed)
4. [x] Phase 1 tests (local) -- all pass; Option A CONFIRMED
       (handle keying matches, `.atm` not needed)
    - [x] `exs/hello.lua`
    - [x] `exs/button-counter.lua`
    - [x] `exs/iup-net.lua` (needs env-socket installed)
5. [x] Created `atmos-env-iup-0.2-1.rockspec` (branch `v0.2`,
       `atmos ~> 0.7`); `-dev-1` already present
6. [ ] Make rockspec (`luarocks make`)
7. [ ] Phase 2 tests (global)
    - [ ] `exs/hello.lua`
    - [ ] `exs/button-counter.lua`
    - [ ] `exs/iup-net.lua`
8. [ ] Commit, push `main`
9. [ ] Create/update version branch `v0.2`, ff `main`, push
10. [ ] `luarocks upload atmos-env-iup-0.2-1.rockspec`

## Reference

- atmos plan: `atmos/.claude/plans/06-08-release-v0.7.md` (§4.4)
- env-socket (done): `env-socket/.claude/plans/06-10-release-v0.2.md`
  -- same `{tag=<sel>, h=<handle>, v=<data>}` event shape.
- env-sdl `__atmos`-drop note: table patterns + `until`.
