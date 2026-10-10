FROM ghcr.io/cz-lucas/evcc-prometheus:1.0.0

USER root
RUN apk add --no-cache curl jq

COPY run.sh /run.sh
RUN chmod 0555 /run.sh

USER exporter:exporter
ENTRYPOINT ["/run.sh"]