#!/bin/bash
set -e

# Get options from Home Assistant
LOG_LEVEL=$(jq -r '.log_level // "info"' /data/options.json)
RETENTION_DAYS=$(jq -r '.retention_days // 15' /data/options.json)
EVALUATION_INTERVAL=$(jq -r '.evaluation_interval // "15s"' /data/options.json)
SCRAPE_INTERVAL=$(jq -r '.scrape_interval // "15s"' /data/options.json)

# Create share directory if it doesn't exist
mkdir -p /share/prometheus

# Generate default prometheus.yml in share if it doesn't exist
if [ ! -f /share/prometheus/prometheus.yml ]; then
    cat > /share/prometheus/prometheus.yml <<'EOF'
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
    echo "[Info] Created default prometheus.yml in /share/prometheus/"
fi

# Create symlink to share config (data directory for prometheus)
mkdir -p /prometheus
ln -sf /share/prometheus /prometheus/config

# Ensure prometheus data directory exists
mkdir -p /share/prometheus/data

# Set permissions
chown -R nobody:nogroup /share/prometheus

# Log startup
echo "[Info] Starting Prometheus..."
echo "[Info] Log Level: ${LOG_LEVEL}"
echo "[Info] Retention: ${RETENTION_DAYS} days"
echo "[Info] Evaluation Interval: ${EVALUATION_INTERVAL}"
echo "[Info] Scrape Interval: ${SCRAPE_INTERVAL}"
echo "[Info] Config: /share/prometheus/prometheus.yml"

# Start Prometheus with options
exec prometheus \
  --config.file=/share/prometheus/prometheus.yml \
  --storage.tsdb.path=/share/prometheus/data \
  --storage.tsdb.retention.time=${RETENTION_DAYS}d \
  --log.level=${LOG_LEVEL}
