# Steam Deck Desktop Mode mouse-drift workaround

**A user-level workaround for unwanted cursor movement associated with Steam running in the background during Steam Deck Desktop Mode.**

No root privileges, SteamOS system-file edits, controller deadzone changes, or Gaming Mode changes are needed.

> **Important:** This is **not a general cure for hardware stick drift**. It deliberately **closes Steam in Desktop Mode**, which also disables Steam Input desktop mappings while Steam is closed. Do not use it if you need Steam or Steam-managed games running continuously in Desktop Mode.

## Why this exists

On a Steam Deck running KDE Plasma X11, we observed the cursor moving continuously without touching the controls. The movement persisted during initial input-isolation checks. Steam was found running silently in the background; after a graceful Steam shutdown, the cursor stayed stationary during repeated sampling. This establishes a reliable workaround in our environment, not a definitive diagnosis of the underlying cause.

**Observed on:** SteamOS with KDE Plasma 6.4.3 on X11 (October 15, 2026). Steam itself was started in KDE Desktop Mode with `-silent`. This is one environment and does not prove the underlying joystick/trackpad or Steam Input mapping is defective.

The manual Steam shutdown command was tested live. The autostart override and watcher were installed, but **fresh-login automatic operation and window-close detection still need independent field verification**.

## What it does

- **Desktop entry override:** `~/.config/autostart/steam.desktop` with `Hidden=true` prevents the KDE system-level Steam autostart entry from launching Steam silently in Desktop Mode.
- **KDE X11 autostart watcher:** After a brief startup delay, gracefully shuts down any Steam process left running at login. Later, if you manually open Steam and then close/hide its GUI, the watcher waits ~8 seconds and requests graceful shutdown.
- **Manual desktop shortcut:** **Stop Steam Mouse Drift** lets you shut down Steam on demand.
- **Graceful shutdown:** Uses `~/.local/share/Steam/ubuntu12_32/steam -shutdown`; does **not** forcibly kill Steam or change its controller layout.

### Caveats

- Tested only on **KDE X11**. The watcher uses `xdotool` and is **not intended for Wayland**. On newer SteamOS versions, Desktop Mode may default to Wayland; check `echo $XDG_SESSION_TYPE`.
- Closing **or minimizing Steam to the tray** is treated as closing it. Save progress and exit games before using the shortcut. The watcher might interfere with Desktop Mode games that hide the Steam window.
- Steam Deck's built-in controller/trackpad Desktop Mode actions can rely on Steam Input and may stop working when Steam exits. You may need an external mouse or keyboard to navigate Desktop Mode after exiting Steam. You can still launch Steam manually when needed.
- The KDE autostart override is scoped to the **desktop session**; it is **not a blanket ban on Steam in Gaming Mode**.
- This is a workaround, not a substitute for checking joystick deadzones, gyro mappings, external controllers, or hardware damage.

## Install (Steam Deck, Desktop Mode, X11)

From Konsole, clone the repository and run the installer:

```bash
git clone https://github.com/nxtode/steamdeck-desktop-mouse-drift-fix.git
cd steamdeck-desktop-mouse-drift-fix
./install.sh
```

The installer checks for existing files and refuses to overwrite them. **Do not blindly replace an existing custom Steam autostart override.** Requires `xdotool` (already available on our tested SteamOS installation). No `sudo`.

After installation, go back to Gaming Mode and enter **X11 Desktop Mode** again. If it works, Steam should not silently start, and closing Steam's window should shut down its remaining background process shortly afterward. You can also double-click **Stop Steam Mouse Drift** on the desktop at any time.

### Check

```bash
pgrep -ax steam || echo 'Steam is stopped'
pgrep -af steam-mouse-drift-watcher
```

To test: with Steam closed, move the cursor to the middle of the screen, release all controls, and check whether it stays still. Then start Steam, confirm a window appears, and close it; the background process should exit within about 8–10 seconds. The watcher is expected to start with KDE on the *next* Desktop Mode login (the installer does not launch it in the current session).

## Uninstall / rollback

From the repository folder:

```bash
./uninstall.sh
```

It removes only files still matching the release copies (modified files are left alone). Then log out and re-enter Desktop Mode. The standard KDE Steam autostart will be available again. No reboot or root privileges required.

If you prefer not to install, the one-time manual workaround is to close Steam via its menu or run:

```bash
~/.local/share/Steam/ubuntu12_32/steam -shutdown
```

## Prior discussions

- [Reddit: Steam open → drifting cursor; closing Steam stops it (May 2024)](https://www.reddit.com/r/SteamDeck/comments/1d2aj64/issues_with_steam_and_three_dot_buttons/)
- [Reddit: Twitchy Desktop Mode touchpads after sleep (June 2026)](https://www.reddit.com/r/SteamDeck/comments/1tyvxpz/twitchy_touchpads_in_desktop_mode_after_sleep/)

This project is not affiliated with Valve.
