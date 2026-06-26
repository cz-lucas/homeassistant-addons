#!/bin/bash
set -euo pipefail

OPTIONS_FILE="/data/options.json"
CONFIG_DIR="/share/prometheus"
CONFIG_FILE="${CONFIG_DIR}/prometheus.yml"
DATA_DIR="${CONFIG_DIR}/data"

LOG_LEVEL=$(jq -r '.log_level // "info"' "${OPTIONS_FILE}")
RETENTION_DAYS=$(jq -r '.retention_days // 15' "${OPTIONS_FILE}")

mkdir -p "${CONFIG_DIR}" "${DATA_DIR}"

if [ ! -f "${CONFIG_FILE}" ]; then
  cat > "${CONFIG_FILE}" <<'EOF'
global:
  scrape_interval: 15s
  evaluation_interval: 15s
  external_labels:
    monitor: 'homeassistant-prometheus'

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
EOF
  echo "[Info] Created default Prometheus config at ${CONFIG_FILE}"
fi

chown -R nobody:nogroup "${CONFIG_DIR}" || true

echo "[Info] Starting Prometheus..."
echo "[Info] Log Level: ${LOG_LEVEL}"
echo "[Info] Retention: ${RETENTION_DAYS} days"
echo "[Info] Config: ${CONFIG_FILE}"

exec prometheus \
  --config.file="${CONFIG_FILE}" \
  --storage.tsdb.path="${DATA_DIR}" \
  --storage.tsdb.retention.time="${RETENTION_DAYS}d" \
  --log.level="${LOG_LEVEL}"
