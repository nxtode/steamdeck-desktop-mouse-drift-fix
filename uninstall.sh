#!/usr/bin/env bash
set -euo pipefail
here=$(cd "$(dirname "$0")" && pwd)
if [ "$(id -un)" != 'deck' ] || [ "$HOME" != /home/deck ]; then
  echo 'Expected Steam Deck user /home/deck.' >&2; exit 1
fi
while IFS='|' read -r source target; do
  if [ -f "$target" ]; then
    if cmp -s "$here/$source" "$target"; then
      rm -- "$target"
      echo "Removed: $target"
    else
      echo "Skipped modified file: $target"
    fi
  fi
done <<EOF_LIST
scripts/stop-steam-mouse-drift|$HOME/.local/bin/stop-steam-mouse-drift
scripts/steam-mouse-drift-watcher|$HOME/.local/bin/steam-mouse-drift-watcher
autostart/steam.desktop|$HOME/.config/autostart/steam.desktop
autostart/steam-mouse-drift-watcher.desktop|$HOME/.config/autostart/steam-mouse-drift-watcher.desktop
autostart/stop-steam-mouse-drift.desktop|$HOME/Desktop/Stop Steam Mouse Drift.desktop
EOF_LIST
echo 'Log out and return to Desktop Mode to finish removing the watcher.'
