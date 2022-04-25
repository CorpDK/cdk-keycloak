#!/bin/bash
echo "env vars..."
echo "DB URL : " $DATABASE_URL
export KC_DB_URL=jdbc:$DATABASE_URL
echo "KC DB URL : " $KC_DB_URL
echo "Port : " $PORT
echo "Starting up..."
/opt/keycloak/bin/kc.sh start --db-url=$KC_DB_URL --http-port=$PORT --verbose