# Squid Proxy

A Home Assistant addon that runs a [Squid](http://www.squid-cache.org/) caching proxy server with IPv4 and IPv6 support.

## Features

- Based on Alpine Linux
- Supports both IPv4 and IPv6
- Runs in host network mode
- Configurable path to `squid.conf` stored under the shared folder
- Automatically creates a default configuration if none exists

## Configuration

| Option | Default | Description |
|---|---|---|
| `config_path` | `/share/squid/squid.conf` | Absolute path to the Squid configuration file. The file and its parent directory are created automatically on first run if they do not exist. |

## Default behaviour

On first start, if the file at `config_path` does not exist, a sensible default `squid.conf` is written there. The default configuration:

- Listens on port **3128** (IPv4 and IPv6)
- Allows access from all RFC-1918 and RFC-4193 private address ranges
- Prefers IPv6 DNS resolution (`dns_v4_first off`)
- Stores cached data in `/var/cache/squid`

Edit the file at `config_path` to customise the proxy behaviour, then restart the addon to apply changes.

## Network

The addon uses **host network mode**, so Squid is directly accessible on port 3128 of your Home Assistant host without any port-mapping configuration.

## Support

<https://github.com/cz-lucas/homeassistant-addons>
