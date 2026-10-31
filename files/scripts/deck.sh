#!/usr/bin/env bash

set -euo pipefail

# Pretty much all of this has been ripped from Bazzite. Shout out to them for doing the hard work.

# Make gamescope session executable
chmod +x /usr/share/gamescope-session-plus/gamescope-session-plus

# Steam bootstrap, so that the first boot into Gaming Mode works without a network
curl --retry 3 -fLo /usr/share/gamescope-session-plus/bootstrap_steam.tar.gz \
  https://large-package-sources.nobaraproject.org/bootstrap_steam.tar.gz
sed -i \
  -e 's|^export GAMESCOPE_SESSION_STEAM_BOOTSTRAP_ARCHIVE=.*$|export GAMESCOPE_SESSION_STEAM_BOOTSTRAP_ARCHIVE="/usr/share/gamescope-session-plus/bootstrap_steam.tar.gz"|' \
  -e 's|^export GAMESCOPE_SESSION_STEAM_BOOTSTRAP_DIR=.*$|export GAMESCOPE_SESSION_STEAM_BOOTSTRAP_DIR="${HOME}/.local/share"|' \
  /usr/share/gamescope-session-plus/sessions.d/steam

# OpenGamepadUI runs as an overlay on non-Valve handhelds only. On a Steam Deck, the session starts Steam only.
sed -i 's|^CLIENTCMD="opengamepadui --overlay-mode|/usr/libexec/hwsupport/non-valve-handheld-hardware \&\& CLIENTCMD="opengamepadui --accessibility disabled --overlay-mode --steam-input --steamos-manager --skip-update-pack|' \
  /usr/share/gamescope-session-plus/sessions.d/ogui-steam

# Power button handling in Gaming Mode
mkdir -p /usr/lib/systemd/user/gamescope-session-plus@ogui-steam.service.wants
ln -sf /usr/lib/systemd/user/steamos-powerbuttond.service \
  /usr/lib/systemd/user/gamescope-session-plus@ogui-steam.service.wants/

# steamos bullshit
sed -i 's|/usr/lib/|/usr/libexec/|g' /usr/share/steamos-manager/platform.toml
printf '\n[session]\ndesktop = "gnome.desktop"\n' >> /usr/share/steamos-manager/platform.toml
printf '[scx]\nscx_service = "scx_loader.service"\n' >> /usr/share/steamos-manager/platform.toml

# Logger aliases used by the SteamOS hardware scripts
for name in info notice warning; do
  ln -sf /usr/bin/steamos-logger "/usr/bin/steamos-${name}"
done

# acpid is off on handhelds. Remove the default event handlers.
find /etc/acpi/events -mindepth 1 -delete 2>/dev/null || true

# Steam Deck dock firmware updater
git clone --depth 1 https://gitlab.com/evlaV/jupiter-dock-updater-bin.git /tmp/jupiter-dock-updater-bin
mv /tmp/jupiter-dock-updater-bin/packaged/usr/lib/jupiter-dock-updater /usr/libexec/jupiter-dock-updater
rm -rf /tmp/jupiter-dock-updater-bin

# GNOME Desktop
# extest: lets Steam Input control the Wayland desktop
mkdir -p /usr/lib/extest
EXTEST_URL=$(curl -fsSL https://api.github.com/repos/ublue-os/extest/releases/latest \
  | jq -r '.assets[] | select(.name == "libextest.so").browser_download_url')
curl --retry 3 -fLo /usr/lib/extest/libextest.so "$EXTEST_URL"

# Start Steam with the wrapper, and start it silently at desktop login
sed -i 's@/usr/bin/steam@/usr/bin/bluebird-steam@g' /usr/share/applications/steam.desktop
mkdir -p /etc/xdg/autostart
sed 's@/usr/bin/bluebird-steam %U@/usr/bin/bluebird-steam -silent %U@g' \
  /usr/share/applications/steam.desktop > /etc/xdg/autostart/steam.desktop

# Extensions for handhelds
# tdp-control: TDP slider in the GNOME desktop for non-Valve handhelds
# block-caribou-36: stops the GNOME on-screen keyboard from fighting the Steam keyboard
EXT_DIR=/usr/share/gnome-shell/extensions
command -v glib-compile-schemas >/dev/null || dnf5 -y install glib2-devel
git clone --depth 1 https://github.com/OpenGamingCollective/gnome-shell-extension-tdp-control.git \
  "$EXT_DIR/tdp-control@opengamingcollective.org"
git clone --depth 1 https://github.com/ublue-os/bazzite-cariboublocker.git \
  "$EXT_DIR/block-caribou-36@lxylxy123456.ercli.dev"
for ext in tdp-control@opengamingcollective.org block-caribou-36@lxylxy123456.ercli.dev; do
  rm -rf "${EXT_DIR:?}/$ext/.git"
  if [[ -d "$EXT_DIR/$ext/schemas" ]]; then
    glib-compile-schemas "$EXT_DIR/$ext/schemas"
  fi
done