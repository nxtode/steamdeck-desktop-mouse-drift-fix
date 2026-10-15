#!/usr/bin/env bash
# Steam Deck default user is 'deck'. No sudo; modify user configuration only.
set -euo pipefail
here=$(cd "$(dirname "$0")" && pwd)
if [ "$(id -un)" != 'deck' ] || [ "$HOME" != /home/deck ]; then
  echo 'This release targets the stock Steam Deck user /home/deck.' >&2
  exit 1
fi
if ! command -v xdotool >/dev/null; then
  echo 'xdotool is required for the X11-only window watcher.' >&2
  exit 1
fi
files=(
  "$HOME/.local/bin/stop-steam-mouse-drift"
  "$HOME/.local/bin/steam-mouse-drift-watcher"
  "$HOME/.config/autostart/steam.desktop"
  "$HOME/.config/autostart/steam-mouse-drift-watcher.desktop"
  "$HOME/Desktop/Stop Steam Mouse Drift.desktop"
)
for file in "${files[@]}"; do
  if [ -e "$file" ]; then
    echo "File already exists; refusing to overwrite: $file" >&2
    echo 'Review the existing setup and back it up before installing.' >&2
    exit 1
  fi
done
mkdir -p "$HOME/.local/bin" "$HOME/.config/autostart" "$HOME/Desktop"
install -m 700 "$here/scripts/stop-steam-mouse-drift" "${files[0]}"
install -m 700 "$here/scripts/steam-mouse-drift-watcher" "${files[1]}"
install -m 644 "$here/autostart/steam.desktop" "${files[2]}"
install -m 644 "$here/autostart/steam-mouse-drift-watcher.desktop" "${files[3]}"
install -m 755 "$here/autostart/stop-steam-mouse-drift.desktop" "${files[4]}"
echo 'Installed. Return to Gaming Mode, then re-enter X11 Desktop Mode.'
echo 'Warning: closing or minimizing Steam to the tray will shut Steam down.'
