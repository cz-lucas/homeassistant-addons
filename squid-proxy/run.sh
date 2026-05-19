#!/usr/bin/with-contenv bashio

CONFIG_PATH=$(bashio::config 'config_path')
CONFIG_DIR=$(dirname "${CONFIG_PATH}")

# Create config directory if it doesn't exist
if ! mkdir -p "${CONFIG_DIR}"; then
    bashio::log.fatal "Failed to create config directory: ${CONFIG_DIR}"
    exit 1
fi

# Copy default config if the user-specified config doesn't exist
if [ ! -f "${CONFIG_PATH}" ]; then
    bashio::log.info "No config found at ${CONFIG_PATH}, copying default config..."
    cp /etc/squid/squid.conf.default "${CONFIG_PATH}"
fi

# Ensure squid cache directory is initialized
if [ ! -d /var/cache/squid/00 ]; then
    bashio::log.info "Initializing Squid cache directory..."
    squid -f "${CONFIG_PATH}" -z
fi

bashio::log.info "Starting Squid proxy with config: ${CONFIG_PATH}"
exec squid -f "${CONFIG_PATH}" -N
