FROM dave4272t/keycloak-builder:latest AS builder

FROM quay.io/keycloak/keycloak:latest

COPY --from=builder /opt/keycloak/ /opt/keycloak/

COPY --chown=1000:0 ./startup.sh /opt/keycloak/bin/startup.sh

RUN chown keycloak:root /opt/keycloak/bin/startup.sh && \
    chmod 777 /opt/keycloak/bin/startup.sh

COPY --from=builder /certificates/idp.corpdk.com.crt /certificates/idp.corpdk.com.crt
COPY --from=builder /certificates/idp.corpdk.com.key /certificates/idp.corpdk.com.key

RUN chown keycloak:root /certificates/idp.corpdk.com.crt && \
    chmod 644 /certificates/idp.corpdk.com.crt && \
    chown keycloak:root /certificates/idp.corpdk.com.key && \
    chmod 644 /certificates/idp.corpdk.com.key

ENV KC_HOSTNAME=localhost
ENV KC_HTTPS_CERTIFICATE_FILE=/certificates/idp.corpdk.com.crt
ENV KC_HTTPS_CERTIFICATE_KEY_FILE=/certificates/idp.corpdk.com.key

ENTRYPOINT ["/opt/keycloak/bin/startup.sh"]