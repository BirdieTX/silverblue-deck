#!/usr/bin/env bash
set -euo pipefail

LISTS=${LISTS:-/usr/share/bluebird}
SCHEMAS=${SCHEMAS:-/usr/share/glib-2.0/schemas}
OUT="$SCHEMAS/zz2-bluebird-lists.gschema.override"

to_array() {
    local items joined
    mapfile -t items < <(grep -vE '^\s*(#|$)' "$1" | sed 's/^\s*//; s/\s*$//')
    printf -v joined "'%s', " "${items[@]}"
    printf '[%s]' "${joined%, }"
}

{
    printf '[org.gnome.shell]\n'
    printf 'enabled-extensions=%s\n\n' "$(to_array "$LISTS/extensions-enable")"
    printf '[org.gnome.shell.extensions.blur-my-shell.applications]\n'
    printf 'whitelist=%s\n' "$(to_array "$LISTS/blur-apps")"
} > "$OUT"

TEST=$(mktemp -d)
find "$SCHEMAS" -maxdepth 1 -type f ! -name '*.gschema.override' ! -name 'gschemas.compiled' -exec cp {} "$TEST" \;
cp "$OUT" "$TEST"
glib-compile-schemas --strict --targetdir="$TEST" "$TEST"
rm -rf "$TEST"

echo "Wrote $OUT"