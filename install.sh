#!/usr/bin/env bash
# Bloodfeed — SDDM Login — install.  ./install.sh
set -euo pipefail
HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
DST=/usr/share/sddm/themes/bloodfeed
[[ $EUID -eq 0 ]] || { echo "run with sudo: sudo ./install.sh" >&2; exit 1; }
rm -rf "$DST"; mkdir -p "$DST"
cp -r "$HERE"/{Main.qml,metadata.desktop,theme.conf,assets,fonts,preview.jpg} "$DST"/
chmod -R a+rX "$DST"
found=0
for f in /etc/sddm.conf /etc/sddm.conf.d/*.conf; do
    if [[ -f $f ]] && grep -q '^Current=' "$f"; then sed -i 's/^Current=.*/Current=bloodfeed/' "$f"; found=1; fi
done
(( found )) || { mkdir -p /etc/sddm.conf.d; printf '[Theme]\nCurrent=bloodfeed\n' > /etc/sddm.conf.d/bloodfeed.conf; }
echo "Installed. Test without logging out: sddm-greeter-qt6 --test-mode --theme $DST"
