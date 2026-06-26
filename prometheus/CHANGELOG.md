# Changelog

## [1.0.0] - 2026-06-26

### Added
- Initial release of Prometheus addon for Home Assistant
- Support for amd64 and aarch64 architectures
- Configurable scrape interval, evaluation interval, and retention period
- Based on official `prom/prometheus:main` image
- Configuration stored in SHARE folder as single point of config
- Auto-creates default prometheus.yml on first run
- Accessible via Home Assistant File Editor addon
