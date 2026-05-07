#!/bin/sh
set -e

OPTIONS_FILE="/data/options.json"
CONF_FILE="/etc/unbound/unbound.conf"
TMPL_FILE="/etc/unbound/unbound.conf.tmpl"
HINTS_FILE="/etc/unbound/root.hints"
ROOT_KEY="/etc/unbound/root.key"

# ---------------------------------------------------------------------------
# Read options
# ---------------------------------------------------------------------------
LISTEN_PORT=$(jq -r '.listen_port // 5335' "${OPTIONS_FILE}")
DO_IPV4=$(jq -r 'if .do_ipv4 then "yes" else "no" end' "${OPTIONS_FILE}")
DO_IPV6=$(jq -r 'if .do_ipv6 then "yes" else "no" end' "${OPTIONS_FILE}")
DNSSEC=$(jq -r '.dnssec // true' "${OPTIONS_FILE}")
PREFETCH=$(jq -r 'if .prefetch then "yes" else "no" end' "${OPTIONS_FILE}")
CACHE_MIN_TTL=$(jq -r '.cache_min_ttl // 300' "${OPTIONS_FILE}")
CACHE_MAX_TTL=$(jq -r '.cache_max_ttl // 86400' "${OPTIONS_FILE}")
NUM_THREADS=$(jq -r '.num_threads // 1' "${OPTIONS_FILE}")
LOG_VERBOSITY=$(jq -r '.log_verbosity // 1' "${OPTIONS_FILE}")
ACCESS_CONTROL_ALLOW=$(jq -r '.access_control_allow // "0.0.0.0/0"' "${OPTIONS_FILE}")
ACCESS_CONTROL_ALLOW_IPV6=$(jq -r '.access_control_allow_ipv6 // "::/0"' "${OPTIONS_FILE}")

# ---------------------------------------------------------------------------
# Fetch fresh root hints if not present or older than 30 days
# ---------------------------------------------------------------------------
if [ ! -f "${HINTS_FILE}" ] || [ "$(find "${HINTS_FILE}" -mtime +30 2>/dev/null)" ]; then
    echo "[unbound] Downloading root hints..."
    wget -q -O "${HINTS_FILE}" https://www.internic.net/domain/named.root || \
        echo "[unbound] Warning: could not download root hints; using cached copy if present."
fi

# ---------------------------------------------------------------------------
# Initialise DNSSEC trust anchor
# ---------------------------------------------------------------------------
if [ "${DNSSEC}" = "true" ]; then
    if [ ! -f "${ROOT_KEY}" ]; then
        echo "[unbound] Initialising DNSSEC root trust anchor..."
        unbound-anchor -a "${ROOT_KEY}" || true
    fi
fi

# ---------------------------------------------------------------------------
# Generate configuration from template
# ---------------------------------------------------------------------------
echo "[unbound] Generating configuration..."
sed \
    -e "s/__LOG_VERBOSITY__/${LOG_VERBOSITY}/g" \
    -e "s/__NUM_THREADS__/${NUM_THREADS}/g" \
    -e "s/__LISTEN_PORT__/${LISTEN_PORT}/g" \
    -e "s/__DO_IPV4__/${DO_IPV4}/g" \
    -e "s/__DO_IPV6__/${DO_IPV6}/g" \
    -e "s/__ACCESS_CONTROL_ALLOW__/${ACCESS_CONTROL_ALLOW}/g" \
    -e "s/__ACCESS_CONTROL_ALLOW_IPV6__/${ACCESS_CONTROL_ALLOW_IPV6}/g" \
    -e "s/__CACHE_MIN_TTL__/${CACHE_MIN_TTL}/g" \
    -e "s/__CACHE_MAX_TTL__/${CACHE_MAX_TTL}/g" \
    -e "s/__PREFETCH__/${PREFETCH}/g" \
    "${TMPL_FILE}" > "${CONF_FILE}"

# Append DNSSEC anchor line only when enabled
if [ "${DNSSEC}" != "true" ]; then
    sed -i 's|auto-trust-anchor-file:.*||g' "${CONF_FILE}"
fi

# ---------------------------------------------------------------------------
# Inject custom local-data records
# ---------------------------------------------------------------------------
RECORD_COUNT=$(jq '.custom_records | length' "${OPTIONS_FILE}")
if [ "${RECORD_COUNT}" -gt 0 ]; then
    echo "" >> "${CONF_FILE}"
    echo "    # Custom records" >> "${CONF_FILE}"
    i=0
    while [ "${i}" -lt "${RECORD_COUNT}" ]; do
        RECORD_NAME=$(jq -r ".custom_records[${i}].name" "${OPTIONS_FILE}")
        RECORD_TYPE=$(jq -r ".custom_records[${i}].type" "${OPTIONS_FILE}")
        RECORD_VALUE=$(jq -r ".custom_records[${i}].value" "${OPTIONS_FILE}")
        echo "    local-data: \"${RECORD_NAME} ${RECORD_TYPE} ${RECORD_VALUE}\"" >> "${CONF_FILE}"
        i=$((i + 1))
    done
fi

# Remove the placeholder comment line
sed -i '/# __CUSTOM_RECORDS__/d' "${CONF_FILE}"

# ---------------------------------------------------------------------------
# Validate and start
# ---------------------------------------------------------------------------
echo "[unbound] Validating configuration..."
unbound-checkconf "${CONF_FILE}"

echo "[unbound] Starting Unbound on port ${LISTEN_PORT} (IPv4=${DO_IPV4}, IPv6=${DO_IPV6})..."
exec unbound -d -c "${CONF_FILE}"
