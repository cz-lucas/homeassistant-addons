# Grafana Image Renderer — Home Assistant Add-on

Runs the [Grafana Image Renderer](https://github.com/grafana/grafana-image-renderer) service as a Home Assistant add-on. It provides headless Chromium-based rendering so Grafana can export panels and dashboards as PNG images, PDFs, and more.

## Installation

1. Navigate to **Settings → Add-ons → Add-on Store** in Home Assistant.
2. Click the three-dot menu (⋮) in the top right and select **Repositories**.
3. Add this repository URL and click **Add**.
4. Find **Grafana Image Renderer** in the store and click **Install**.

## Configuration

| Option | Default | Description |
|---|---|---|
| `auth_token` | `-` | Secret token that Grafana must send with every render request. Set the same value in Grafana's `GF_RENDERING_RENDERER_TOKEN`. Use `-` to keep the default open token for local-only setups. |
| `log_level` | `info` | Log verbosity: `trace`, `debug`, `info`, `warning`, or `error`. |
| `ignore_https_errors` | `false` | Set to `true` to ignore TLS certificate errors when the renderer fetches Grafana pages (useful for self-signed certificates). |

## Grafana configuration

After starting the add-on, point Grafana to the renderer. Replace `<ha-ip>` with your Home Assistant IP address.

**Environment variables (Docker / HA Grafana add-on):**

```
GF_RENDERING_SERVER_URL=http://<ha-ip>:8081/render
GF_RENDERING_RENDERER_TOKEN=-
```

**`grafana.ini`:**

```ini
[rendering]
server_url = http://<ha-ip>:8081/render
renderer_token = -
```

> If you changed `auth_token` from the default, use that value for `GF_RENDERING_RENDERER_TOKEN` / `renderer_token`.

## Network

The renderer listens on **port 8081** (TCP). Ensure your Grafana instance can reach Home Assistant on this port.

## Resource requirements

The renderer uses a headless Chromium browser which can be memory-intensive. Grafana recommends at least **16 GiB RAM** and **4 CPU cores** for production workloads. For typical home-lab usage (small dashboards, infrequent exports) much less is needed, but keep an eye on memory if your system is constrained.

## Supported architectures

| Architecture | Supported |
|---|---|
| `amd64` | ✅ |
| `aarch64` | ✅ |
