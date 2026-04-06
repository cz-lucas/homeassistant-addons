#!/bin/bash
set -e

OPTIONS_FILE="/data/options.json"

# Read options from Home Assistant, falling back to defaults
LOG_LEVEL=$(jq -r '.log_level // "info"' "${OPTIONS_FILE}")
AUTH_TOKEN=$(jq -r '.auth_token // "-"' "${OPTIONS_FILE}")
IGNORE_HTTPS_ERRORS=$(jq -r '.ignore_https_errors // false' "${OPTIONS_FILE}")
BROWSER_GPU=$(jq -r '.browser_gpu // false' "${OPTIONS_FILE}")
BROWSER_MAX_HEIGHT=$(jq -r '.browser_max_height // 3000' "${OPTIONS_FILE}")
BROWSER_MAX_WIDTH=$(jq -r '.browser_max_width // 3000' "${OPTIONS_FILE}")
BROWSER_MIN_HEIGHT=$(jq -r '.browser_min_height // 500' "${OPTIONS_FILE}")
BROWSER_MIN_WIDTH=$(jq -r '.browser_min_width // 1000' "${OPTIONS_FILE}")
BROWSER_PAGE_SCALE_FACTOR=$(jq -r '.browser_page_scale_factor // 1' "${OPTIONS_FILE}")
BROWSER_PORTRAIT=$(jq -r '.browser_portrait // false' "${OPTIONS_FILE}")
BROWSER_TIMEZONE=$(jq -r '.browser_timezone // "Etc/UTC"' "${OPTIONS_FILE}")

export LOG_LEVEL
export AUTH_TOKEN
export IGNORE_HTTPS_ERRORS
export HTTP_PORT=8081
export BROWSER_MAX_HEIGHT
export BROWSER_MAX_WIDTH
export BROWSER_MIN_HEIGHT
export BROWSER_MIN_WIDTH
export BROWSER_PAGE_SCALE_FACTOR
export BROWSER_PORTRAIT
export BROWSER_TIMEZONE
export TZ="${BROWSER_TIMEZONE}"

exec /usr/bin/grafana-image-renderer server
