# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a [Hammerspoon](https://www.hammerspoon.org/) configuration for macOS automation. Hammerspoon exposes macOS APIs via a Lua scripting bridge. The entry point is `init.lua`, which is loaded automatically on startup.

## Reload & Debug

After editing `init.lua`, reload the config:
- **Menu bar**: Hammerspoon icon → Reload Config
- **Console**: open Hammerspoon Console and run `hs.reload()`
- **Hotkey** (if configured): bound reload shortcut

To inspect values at runtime, use the Hammerspoon Console (not a terminal):
```lua
hs.keycodes.currentSourceID()                          -- current input source
hs.application.frontmostApplication():bundleID()       -- frontmost app bundle ID
```

## Architecture

The config is a chezmoi template: edit `init.lua.tmpl` in the dotfiles repo, not
`~/.hammerspoon/init.lua`, which is generated output. Current features:

**Input method auto-switch** — subscribes to `hs.window.filter.windowFocused`. When a window is focused, a 0.1s deferred call switches to Chinese (WeType Pinyin) or English ABC based on a bundle ID allowlist (`chineseApps`). The delay prevents the OS/app from overriding the switch after Hammerspoon sets it; the callback re-checks that the frontmost app is still the same one before acting, so rapid window switching cannot apply a stale bundle ID.

**Switch hint** — `showHint` draws a translucent capsule in the top-right corner via `hs.canvas` (`hs.alert` only supports center/top/bottom).

Key constants:
- `IM_CHINESE` — `com.tencent.inputmethod.wetype.pinyin`
- `IM_ENGLISH` — `com.apple.keylayout.ABC`
- `chineseAppSet` — O(1) lookup table built from the `chineseApps` list

## Adding a New App Rule

The allowlist is not in this repo — it doubles as an inventory of installed
software, so it lives in machine-local chezmoi data.

1. Switch to the target app.
2. In Console: `hs.application.frontmostApplication():bundleID()`
3. Append the returned string to `~/.config/chezmoi/chezmoi.toml`:

   ```toml
   [[data.chineseApps]]
     id = "com.example.App"
     comment = "App"
   ```

   Apps left out of the list default to English.
4. `chezmoi apply`, then Reload Config.
