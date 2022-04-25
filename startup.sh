#!/bin/bash
echo "env vars..."
echo $DATABASE_URL
echo $PORT
echo "Starting up..."
/opt/keycloak/bin/kc.sh start --db-url $DATABASE_URL --http-port $PORT