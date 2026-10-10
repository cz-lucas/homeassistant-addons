#!/bin/sh
set -eu

: "${SUPERVISOR_TOKEN:?SUPERVISOR_TOKEN is not set}"

OPTIONS_JSON="$(
  curl -fsS \
    -H "Authorization: Bearer ${SUPERVISOR_TOKEN}" \
    http://supervisor/addons/self/info |
  jq -ce '.data.options'
)"

export EVCC_WS_URL="$(printf '%s' "$OPTIONS_JSON" | jq -er '.evcc_ws_url')"
export LOG_LEVEL="$(printf '%s' "$OPTIONS_JSON" | jq -er '.log_level')"
export GO_METRICS_ENABLED="$(printf '%s' "$OPTIONS_JSON" | jq -er '.go_metrics_enabled')"

exec /usr/local/bin/evcc-prometheus