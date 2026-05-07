# Unbound DNS Resolver

![Unbound Logo](https://nlnetlabs.nl/static/logos/Unbound/Unbound_FC_Shaded_cropped.png)

A validating, recursive, and caching DNS resolver for Home Assistant, based on [Unbound](https://nlnetlabs.nl/projects/unbound/about/) and Alpine Linux.

## Why Unbound?

Unbound is a trusted, high-performance DNS resolver that supports DNSSEC validation out of the box. It is commonly used as an upstream resolver for ad-blockers such as **AdGuard Home** or **Pi-hole**, allowing you to resolve DNS queries directly against the root servers without relying on a third-party DNS provider.

## Running alongside AdGuard Home

This addon listens on port **5335** by default, which avoids any conflict with AdGuard Home (port 53). Configure AdGuard Home to use `127.0.0.1:5335` as its upstream DNS server, and all queries forwarded from AdGuard Home will be resolved by Unbound.

```
Clients → AdGuard Home (port 53) → Unbound (port 5335) → Root DNS servers
```

## Configuration

```yaml
listen_port: 5335          # Port Unbound listens on (change if needed)
do_ipv4: true              # Enable IPv4 resolution
do_ipv6: true              # Enable IPv6 resolution
dnssec: true               # Validate DNSSEC signatures
prefetch: true             # Prefetch popular records before they expire
cache_min_ttl: 300         # Minimum TTL (seconds) for cached records
cache_max_ttl: 86400       # Maximum TTL (seconds) for cached records
num_threads: 1             # Number of worker threads
log_verbosity: 1           # 0 = silent, 1 = operational, 2-5 = debug
access_control_allow: "0.0.0.0/0"  # CIDR range allowed to query Unbound
custom_records: []         # Optional static DNS records
```

### Custom local records

You can inject static DNS entries (e.g. for local hostnames):

```yaml
custom_records:
  - name: "mynas.home.arpa."
    type: "A"
    value: "192.168.1.50"
  - name: "router.home.arpa."
    type: "AAAA"
    value: "fd00::1"
```

### Security note on `access_control_allow`

The default value `0.0.0.0/0` allows all hosts to query Unbound. In a typical Home Assistant setup this is fine because the port is only exposed to the host network. Restrict this to your LAN CIDR (e.g. `192.168.1.0/24`) if you expose the port externally.

## Support

Please open an issue at <https://github.com/cz-lucas/homeassistant-addons>.
