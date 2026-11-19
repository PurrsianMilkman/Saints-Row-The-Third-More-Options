# More Options for Saints Row The Third

Extra display settings for **Saints Row: The Third (PC, DX11)**, added to the game's own
**Options > Display** screen with [SR3 Mod UI](https://github.com/PurrsianMilkman/Saints-Row-The-Third-Mod-UI).
No game file is modified.

```
DISPLAY
  Resolutions        2560 x 1440
  Display mode       < BORDERLESS >     <- new third choice (was Full screen / Windowed)
  Preset             Custom
  ...
  Brightness
  FPS limit          < 60 >             <- new row
```

| Setting | What it does |
|---|---|
| **Display mode: Borderless** | Windowed without the title bar and frame, centred on its monitor (or filling it when the resolution matches the screen). Choose it, press Apply. Choosing Windowed or Full screen puts the frame back. |
| **FPS limit** | Off, 30, 60, 75, 90, 120, 144, 165 or 240. A frame limiter in the swap chain's `Present`; useful with V-Sync off. |

Settings are saved to **`MoreOptionsSRTT.ini`** next to the game executable (created on first start):

```
[Display]
Borderless=0
FpsLimit=0
```

The stock screen already has a **Shadow detail** row with an Off choice (it needs Preset = Custom), so there is no
separate shadow toggle yet. More graphics toggles are planned.

## Install

Requirements: `SaintsRowTheThird_DX11.exe`, an ASI loader (`dinput8.dll`, e.g. Ultimate ASI Loader) and
**SR3 Mod UI 2 or newer** installed first (see its README).

```
powershell -ExecutionPolicy Bypass -File install.ps1 -Game "<your Saints Row The Third folder>"
```

This copies `MoreOptionsSRTT.asi` and `SR3ModUI\mods\moreoptions.lua` into the game folder. Build the plugin
yourself with `build.bat` (Visual Studio 2022 Build Tools, x86). Remove it with `-Uninstall` (your
`MoreOptionsSRTT.ini` is kept). Log: `SR3ModUI.log` in the game folder (lines tagged `[moreoptions]`).

## Status

Tested in game (keyboard): the Borderless choice appears and applies, the FPS limit row saves to the ini, and pressing Apply
rapidly is safe (only one apply runs at a time; extra presses are ignored until the "keep these settings?" dialog is answered).
Not tested yet: mouse and controller on the new rows, other monitors, true full screen, Cancel/Revert of an unapplied
Borderless choice. Windowed Borderless is the only supported way to use it (exclusive full screen ignores it).

## How it works

`moreoptions.lua` adds the third choice to the Display mode row with `ModUI.modify`, tells the plugin what was chosen
when Apply runs (the game itself only ever sees "Windowed"), and the plugin restyles the game window (popup style, centred).
`MoreOptionsSRTT.asi` also hooks `IDXGISwapChain::Present` for the limiter and registers the FPS row with
`ModUI.AttachPage("moreopts_display", "display")`.

## License

MIT, see [LICENSE](LICENSE).

Your support is greatly appreciated. Nothing is paywalled: https://www.patreon.com/cw/Purrsian
