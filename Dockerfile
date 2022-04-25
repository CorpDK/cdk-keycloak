FROM dave4272t/keycloak-builder AS builder

FROM quay.io/keycloak/keycloak:latest

COPY --from=builder /opt/keycloak/ /opt/keycloak/

COPY --chown=1000:0 ./startup.sh /opt/keycloak/bin/startup.sh

RUN chown keycloak:root /opt/keycloak/bin/startup.sh && \
    chmod 777 /opt/keycloak/bin/startup.sh

ENV KC_HOSTNAME=localhost
ENV KC_HTTP_ENABLED=true

ENTRYPOINT ["/opt/keycloak/bin/startup.sh"]