FROM quay.io/keycloak/keycloak:latest

LABEL name="Keycloak-builder"
LABEL description="Keycloak Optimized Builder"
LABEL author="Dave4272"

# cluster
#ENV KC_CACHE=ispn
#ENV KC_CACHE_CONFIG_FILE=/config/cache.xml
#ENV KC_CACHE_STACK=upd # tcp | udp | kubernetes | ec2 | azure | google

# db driver
ENV KC_DB=postgres

# keycloak features config
# Default enabled features:
# account-api     Account Management REST API
# account2        New Account Management Console
# authorization   Authorization Service
# ciba            OpenID Connect Client Initiated Backchannel Authentication (CIBA)
# client-policies Client configuration policies
# impersonation   Ability for admins to impersonate users
# par             OAuth 2.0 Pushed Authorization Requests (PAR)
# web-authn       W3C Web Authentication (WebAuthn)
#
#ENV KC_FEATURES_DISABLED=

# Default disabled features:
# Supported:
# docker          Docker Registry protocol

# Preview:
# admin-fine-grained-authz    Fine-Grained Admin Permissions
# declarative-user-profile    Configure user profiles using a declarative style
# openshift-integration       Extension to enable securing OpenShift
# scripts                     Write custom authenticators using JavaScript
# token-exchange              Token Exchange Service
#
#ENV KC_FEATURES=docker

# metrics
ENV KC_METRICS_ENABLED=true
ENV KC_HEALTH_ENABLED=true

# http
#ENV KC_HTTP_RELATIVE_PATH=/

# secrets vault
#ENV KC_VAULT=hashicorp

ENV KC_CACHE=local

RUN /opt/keycloak/bin/kc.sh build

RUN /opt/keycloak/bin/kc.sh show-config