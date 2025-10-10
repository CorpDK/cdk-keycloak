ARG KEYCLOAK_VERSION=26.3.4

FROM quay.io/phasetwo/phasetwo-keycloak:${KEYCLOAK_VERSION} AS phasetwo

FROM quay.io/keycloak/keycloak:${KEYCLOAK_VERSION} AS builder

# Build-time environment variables
ENV KC_DB=postgres \
    KC_EVENT_METRICS_USER_ENABLED=true \
    KC_FEATURES=docker \
    KC_HEALTH_ENABLED=true \
    KC_METRICS_ENABLED=true

# checkov:skip=CKV_DOCKER_4: ADD is appropriate for remote URLs
# ADD --chown=keycloak:keycloak https://github.com/wadahiro/keycloak-discord/releases/download/v0.5.0/keycloak-discord-0.5.0.jar /opt/keycloak/providers/keycloak-discord-0.5.0.jar
# COPY /theme/keywind /opt/keycloak/themes/keywind

# Phase 2 Providers
COPY --from=phasetwo --chown=keycloak:keycloak /opt/keycloak/providers/dnsjava-dnsjava-*.jar /opt/keycloak/providers/
COPY --from=phasetwo --chown=keycloak:keycloak /opt/keycloak/providers/io.phasetwo-phasetwo-admin-portal-*.jar /opt/keycloak/providers/
COPY --from=phasetwo --chown=keycloak:keycloak /opt/keycloak/providers/io.phasetwo-phasetwo-idp-wizard-*.jar /opt/keycloak/providers/
COPY --from=phasetwo --chown=keycloak:keycloak /opt/keycloak/providers/io.phasetwo.keycloak-keycloak-events-*.jar /opt/keycloak/providers/
COPY --from=phasetwo --chown=keycloak:keycloak /opt/keycloak/providers/io.phasetwo.keycloak-keycloak-magic-link-*.jar /opt/keycloak/providers/
COPY --from=phasetwo --chown=keycloak:keycloak /opt/keycloak/providers/io.phasetwo.keycloak-keycloak-orgs-*.jar /opt/keycloak/providers/
COPY --from=phasetwo --chown=keycloak:keycloak /opt/keycloak/providers/io.phasetwo.keycloak-keycloak-themes-*.jar /opt/keycloak/providers/
COPY --from=phasetwo --chown=keycloak:keycloak /opt/keycloak/providers/org.wildfly.client-wildfly-client-config-*.jar /opt/keycloak/providers/
COPY --from=phasetwo --chown=keycloak:keycloak /opt/keycloak/providers/phasetwo-admin-ui-*.jar /opt/keycloak/providers/

# Additional Providers
# checkov:skip=CKV_DOCKER_4: ADD is appropriate for remote URLs
ADD --chown=keycloak:keycloak https://github.com/klausbetz/apple-identity-provider-keycloak/releases/download/1.16.0/apple-identity-provider-1.16.0.jar /opt/keycloak/providers/apple-identity-provider-1.16.0.jar


RUN /opt/keycloak/bin/kc.sh build && /opt/keycloak/bin/kc.sh show-config

FROM quay.io/keycloak/keycloak:${KEYCLOAK_VERSION}

ARG KEYCLOAK_VERSION=${KEYCLOAK_VERSION}

LABEL org.opencontainers.image.title="CorpDK Keycloak"
LABEL org.opencontainers.image.description="Keycloak ${KEYCLOAK_VERSION} with Phase Two enterprise extensions and Apple Identity Provider"
LABEL org.opencontainers.image.vendor="CorpDK"
LABEL org.opencontainers.image.authors="Debraj Kundu <kundu.webdav@gmail.com>"
LABEL org.opencontainers.image.version="${KEYCLOAK_VERSION}"
LABEL org.opencontainers.image.base.name="quay.io/keycloak/keycloak:${KEYCLOAK_VERSION}"
LABEL org.opencontainers.image.source="https://github.com/CorpDK/cdk-keycloak"

# Runtime environment variables
ENV JAVA_OPTS_APPEND="-Djava.net.preferIPv4Stack=false -Djava.net.preferIPv6Addresses=true" \
    KC_CACHE_EMBEDDED_MTLS_ENABLED=false \
    KC_CACHE_METRICS_HISTOGRAMS_ENABLED=true \
    KC_DB_POOL_INITIAL_SIZE=0 \
    KC_DB_POOL_MAX_SIZE=10 \
    KC_DB_POOL_MIN_SIZE=1 \
    KC_DB_URL_PORT=5432 \
    KC_DB_URL_PROPERTIES="?sslmode=require" \
    KC_HOSTNAME_BACKCHANNEL_DYNAMIC=true \
    KC_HTTP_ENABLED=true \
    KC_HTTP_MAX_QUEUED_REQUESTS=100 \
    KC_HTTP_METRICS_HISTOGRAMS_ENABLED=true \
    KC_PROXY_HEADERS=xforwarded \
    QUARKUS_TRANSACTION_MANAGER_ENABLE_RECOVERY=true

# COPY java.config /etc/crypto-policies/back-ends/java.config

COPY --from=builder /opt/keycloak/ /opt/keycloak/

USER keycloak

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD /opt/keycloak/bin/kc.sh show-config || exit 1

ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]

CMD ["start", "--optimized"]
