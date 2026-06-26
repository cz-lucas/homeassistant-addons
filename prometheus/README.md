# Prometheus Addon

## Overview

This addon runs Prometheus in Home Assistant using the official `prom/prometheus:main` image.

## Configuration model

Prometheus is configured through a single file in the Home Assistant SHARE folder:

- `/share/prometheus/prometheus.yml`

If the file does not exist on first start, the addon creates a sensible default automatically.

This means the config file in SHARE is the single source of truth for Prometheus scrape configuration.

## Addon options

The addon UI only controls a small set of runtime options:

- `log_level`
- `retention_days`

## Using the config file

You can edit `/share/prometheus/prometheus.yml` with the Home Assistant File editor addon or any other tool that can access the SHARE folder.

Example:

```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
```

## Files used by the addon

- `/share/prometheus/prometheus.yml` - Prometheus config
- `/share/prometheus/data/` - Prometheus TSDB storage

## Usage

After installation, Prometheus is available on port `9090`.
