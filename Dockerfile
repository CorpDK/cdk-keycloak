FROM dave4272t/keycloak-builder AS builder

FROM quay.io/keycloak/keycloak:latest

COPY --from=builder /opt/keycloak/ /opt/keycloak/

COPY ./startup.sh /startup.sh

ENV KC_HOSTNAME=localhost
ENV KC_HTTP_ENABLED=true

ENTRYPOINT ["/startup.sh"]