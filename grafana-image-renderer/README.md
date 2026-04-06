# Grafana Image Renderer — Home Assistant Add-on

[![Grafana Logo](grafana.png)](https://grafana.com/oss/grafana/?plcmt=oss-nav)

Runs the [Grafana Image Renderer](https://github.com/grafana/grafana-image-renderer) service as a Home Assistant add-on. It provides headless Chromium-based rendering so Grafana can export panels and dashboards as PNG images, PDFs, and more.

## Installation

1. Navigate to **Settings → Add-ons → Add-on Store** in Home Assistant.
2. Click the three-dot menu (⋮) in the top right and select **Repositories**.
3. Add this repository URL and click **Add**.
4. Find **Grafana Image Renderer** in the store and click **Install**.

## Configuration

| Option | Default | Description |
|---|---|---|
| `auth_token` | `-` | Secret token that Grafana must send with every render request. Set the same value in Grafana's `GF_RENDERING_RENDERER_TOKEN`. Replace it with a randomly generate string. |
| `log_level` | `info` | Log verbosity: `trace`, `debug`, `info`, `warning`, or `error`. |
| `ignore_https_errors` | `false` | Set to `true` to ignore TLS certificate errors when the renderer fetches Grafana pages (useful for self-signed certificates). |

## Grafana configuration

**Environment variables (Docker / HA Grafana add-on):**

```
GF_RENDERING_SERVER_URL=http://<ha-ip>:8081/render
GF_RENDERING_RENDERER_TOKEN=<What you have entered in the addon-config>
```

**`grafana.ini`:**

```ini
[rendering]
server_url = http://<ha-ip>:8081/render
renderer_token = <What you have entered in the addon-config>
```

## Network

This addons does not expose a port by default but you can expose the image renderer port if you have grafana running on another machine.

## Resource requirements

The renderer uses a headless Chromium browser which can be memory-intensive.

## Supported architectures

| Architecture | Supported |
|---|---|
| `amd64` | ✅ |
| `aarch64` | ✅ |
