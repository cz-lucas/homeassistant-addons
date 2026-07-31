# Loki — Home Assistant Add-on

Runs [Grafana Loki](https://grafana.com/oss/loki/) as a Home Assistant add-on using the official Loki container image.

## Installation

1. Navigate to **Settings → Add-ons → Add-on Store** in Home Assistant.
2. Click the three-dot menu (⋮) in the top right and select **Repositories**.
3. Add this repository URL and click **Add**.
4. Find **Loki** in the store and click **Install**.

## Configuration

This add-on currently uses Loki's defaults from the official image.

## Network

Loki listens on port `3100` (TCP).

## Supported architectures

| Architecture | Supported |
|---|---|
| `amd64` | ✅ |
| `aarch64` | ✅ |
