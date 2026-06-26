# Prometheus Addon

## Overview

This addon allows you to run Prometheus directly within Home Assistant as an add-on. Prometheus is a powerful monitoring and alerting system that can scrape metrics from various targets and store them for analysis.

## Features

- Runs Prometheus directly in Home Assistant
- Based on the official `prom/prometheus:main` Docker image
- Configurable scrape interval and evaluation interval
- Configurable data retention period
- Persistent storage of metrics data in the SHARE folder
- Configuration file accessible via Home Assistant's File Editor addon
- Support for both amd64 and aarch64 architectures

## Installation

1. Add this repository to your Home Assistant add-on store
2. Navigate to the add-ons section
3. Search for "Prometheus"
4. Click install
5. Adjust configuration options as needed
6. Start the add-on

## Configuration

### Addon Options (Home Assistant UI)

Configure these options in the Home Assistant add-on settings:

- **log_level**: Set the log level (debug, info, warn, error) - Default: `info`
- **retention_days**: Number of days to retain metrics data - Default: `15`
- **evaluation_interval**: How often to evaluate alerting rules - Default: `15s`
- **scrape_interval**: How often to scrape targets for metrics - Default: `15s`

### Example Configuration

```yaml
log_level: info
retention_days: 30
evaluation_interval: 30s
scrape_interval: 30s
```

## Configuring Scrape Targets

Prometheus configuration is stored in the Home Assistant SHARE folder as a single point of config.

### Using File Editor

1. Install the "File editor" addon from Home Assistant add-ons
2. Navigate to the File editor
3. Edit `/share/prometheus/prometheus.yml`
4. Save your changes
5. Restart the Prometheus addon for changes to take effect

### Example prometheus.yml

```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s
  external_labels:
    monitor: 'homeassistant-prometheus'

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
  
  - job_name: 'my-service'
    static_configs:
      - targets: ['service-host:port']
```

## File Structure

- **prometheus.yml**: Main configuration file (edit via File Editor)
- **data/**: Time-series database storage (managed by Prometheus)

All files are stored in `/share/prometheus/` and persist across restarts and updates.

## Usage

Once the addon is running, Prometheus will be available at:

- **URL**: `http://<your-home-assistant-ip>:9090`
- **Port**: `9090/tcp`

## Support

For issues, questions, or contributions, please visit the [GitHub repository](https://github.com/cz-lucas/homeassistant-addons)

## License

MIT License
