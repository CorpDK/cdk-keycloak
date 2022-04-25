#!/bin/bash
echo "env vars..."
echo $DATABASE_URL
export KC_DB_URL=jdbc:$DATABASE_URL
echo $KC_DB_URL
echo $PORT
echo "Starting up..."
/opt/keycloak/bin/kc.sh start --db-url=jdbc:$DATABASE_URL --http-port=$PORT