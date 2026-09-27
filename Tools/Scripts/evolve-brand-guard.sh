#!/usr/bin/env bash
# Evolve Chat (APP-1) guard: fails when Element branding, element.io links, a placeholder map key, analytics or
# crash-reporting keys, or end-to-end encryption come back (the 2026-09-27 audit found the first three after the
# first rebrand, and a monthly upstream rebase can bring any of them back). Runs in seconds, before the build.
#   bash Tools/Scripts/evolve-brand-guard.sh
set -euo pipefail
cd "$(dirname "$0")/../.."
L=ElementX/Resources/Localizations
SETTINGS=ElementX/Sources/Application/Settings/AppSettings.swift
SECRETS=Components/Secrets/Secrets.swift
fail=0
bad() { printf 'BRAND GUARD: %s\n' "$1"; fail=1; }

# 1. The product name "Element X" in any language (permission prompts, call messages).
hits=$(grep -rn --include='*.strings' --include='*.stringsdict' 'Element X' "$L" || true)
[ -z "$hits" ] || bad "\"Element X\" in shipped strings:
$hits"

# 2. "Element" in English or Spanish, except keys for Element features this build never shows
#    (Element Call internals, Element Pro, Element Classic migration, the element.io server, Android-only text).
allow='^[^"]*"[a-z0-9_]*(element_call|element_pro|element_classic|element_dot_io|bluetooth_devices_disabled|missing_key_backup)[a-z0-9_]*"'
for f in "$L"/en.lproj/*.strings "$L"/es.lproj/*.strings; do
  hits=$(grep -n -w 'Element' "$f" | grep -v -E "$allow" || true)
  [ -z "$hits" ] || bad "\"Element\" in $f:
$hits"
done

# 3. Help and legal links must be Evolve's.
hits=$(grep -n 'https://element\.io' "$SETTINGS" || true)
[ -z "$hits" ] || bad "element.io link in $SETTINGS:
$hits"

# 4. Analytics, crash reporting, bug reports and the map key stay unset (nothing goes to Element; no broken
#    location sharing).
for key in sentryDSN sentryRustDSN postHogHost postHogAPIKey rageshakeURL mapLibreAPIKey; do
  grep -q -E "static let $key: String\? = nil" "$SECRETS" || bad "$key is set in $SECRETS"
done

# 5. No end-to-end encryption (D-05: company records).
grep -q 'let forceDisableE2EE: RemotePreference<Bool> = .init(true)' "$SETTINGS" || bad "forceDisableE2EE is not on in $SETTINGS"

[ "$fail" -eq 0 ] && echo "Brand guard: clean"
exit "$fail"
