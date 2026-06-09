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

The entire config lives in `init.lua`. Current features:

**Input method auto-switch** — watches `hs.application.watcher.activated` events. When an app is foregrounded, a 0.1s deferred call switches to Chinese (WeType Pinyin) or English ABC based on a bundle ID allowlist (`chineseApps`). The delay prevents the OS/app from overriding the switch after Hammerspoon sets it.

Key constants:
- `IM_CHINESE` — `com.tencent.inputmethod.wetype.pinyin`
- `IM_ENGLISH` — `com.apple.keylayout.ABC`
- `chineseAppSet` — O(1) lookup table built from the `chineseApps` list

## Adding a New App Rule

1. Switch to the target app.
2. In Console: `hs.application.frontmostApplication():bundleID()`
3. Add the returned string to `chineseApps` (for Chinese) or leave it out (defaults to English).
4. Reload config.
