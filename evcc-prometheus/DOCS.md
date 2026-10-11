# EVCC Prometheus

Set `evcc_ws_url` to the WebSocket URL of your EVCC instance, such as `ws://49686a9f-evcc:7070/ws` or `wss://evcc.example.com/ws`.

Prometheus metrics are available at `http://<home-assistant-host>:9070/metrics`. The `/health` endpoint is used by the add-on watchdog. Change the host port in the add-on network settings if port `9070` is already in use.

`log_level` accepts `debug`, `info`, `warn`, or `error`. Set `go_metrics_enabled` to `false` to omit Go runtime and process metrics.

The add-on image is built locally from the multi-architecture `ghcr.io/cz-lucas/evcc-prometheus` image. The wrapper only translates Home Assistant options into the environment variables already supported by the exporter.

Full docs are here: [https://github.com/cz-lucas/evcc-prometheus](https://github.com/cz-lucas/evcc-prometheus)