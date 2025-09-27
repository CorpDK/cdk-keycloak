ARG KEYCLOAK_VERSION=26.3.4

FROM quay.io/keycloak/keycloak:${KEYCLOAK_VERSION} AS builder

# Build-time environment variables
ENV KC_DB=postgres \
    KC_FEATURES=docker \
    KC_HTTP_ENABLED=true \
    KC_METRICS_ENABLED=true \
    KC_EVENT_METRICS_USER_ENABLED=true

# checkov:skip=CKV_DOCKER_4: ADD is appropriate for remote URLs
# ADD --chown=keycloak:keycloak https://github.com/klausbetz/apple-identity-provider-keycloak/releases/download/1.7.1/apple-identity-provider-1.7.1.jar /opt/keycloak/providers/apple-identity-provider-1.7.1.jar
# checkov:skip=CKV_DOCKER_4: ADD is appropriate for remote URLs
# ADD --chown=keycloak:keycloak https://github.com/wadahiro/keycloak-discord/releases/download/v0.5.0/keycloak-discord-0.5.0.jar /opt/keycloak/providers/keycloak-discord-0.5.0.jar
# COPY /theme/keywind /opt/keycloak/themes/keywind

RUN /opt/keycloak/bin/kc.sh build && /opt/keycloak/bin/kc.sh show-config

FROM quay.io/keycloak/keycloak:${KEYCLOAK_VERSION}

LABEL name="CorpDK Keycloak"
LABEL description="Keycloak Customized for CorpDK"
LABEL author="Debraj Kundu <kundu.webdav@gmail.com>"

# COPY java.config /etc/crypto-policies/back-ends/java.config

COPY --from=builder /opt/keycloak/ /opt/keycloak/

USER keycloak

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD /opt/keycloak/bin/kc.sh show-config || exit 1

ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]

CMD ["start", "--optimized"]
