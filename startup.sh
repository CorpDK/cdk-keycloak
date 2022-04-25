#!/bin/bash
echo "env vars..."
echo "DB URL : " $DATABASE_URL
export KC_DB_URL=jdbc:$
regex='^postgres://([a-zA-Z0-9_-]+):([a-zA-Z0-9]+)@([a-z0-9.-]+):([[:digit:]]+)/([a-zA-Z0-9_-]+)$'
export DB_ADDR=${BASH_REMATCH[3]}
export DB_PORT=${BASH_REMATCH[4]}
export DB_DATABASE=${BASH_REMATCH[5]}
export DB_USER=${BASH_REMATCH[1]}
export DB_PASSWORD=${BASH_REMATCH[2]}

echo "DB_ADDR=$DB_ADDR, DB_PORT=$DB_PORT, DB_DATABASE=$DB_DATABASE, DB_USER=$DB_USER, DB_PASSWORD=$DB_PASSWORD"
echo "KC DB URL : " $KC_DB_URL
echo "Port : " $PORT
echo "Starting up..."
/opt/keycloak/bin/kc.sh start --db-url=$KC_DB_URL --http-port=$PORT
