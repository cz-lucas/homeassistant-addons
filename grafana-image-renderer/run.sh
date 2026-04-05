#!/bin/bash
set -e

OPTIONS_FILE="/data/options.json"

# Read options from Home Assistant, falling back to defaults
LOG_LEVEL=$(jq -r '.log_level // "info"' "${OPTIONS_FILE}")
AUTH_TOKEN=$(jq -r '.auth_token // "-"' "${OPTIONS_FILE}")
IGNORE_HTTPS_ERRORS=$(jq -r '.ignore_https_errors // false' "${OPTIONS_FILE}")

export LOG_LEVEL
export AUTH_TOKEN
export IGNORE_HTTPS_ERRORS
export HTTP_PORT=8081

exec /usr/bin/grafana-image-renderer server
