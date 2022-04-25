#!/bin/bash
echo "env vars..."
echo "DB URL : " $DATABASE_URL
# export KC_DB_URL=jdbc:$DATABASE_URL
# echo "KC DB URL : " $KC_DB_URL
regex='^postgres://([a-zA-Z0-9_-]+):([a-zA-Z0-9]+)@([a-z0-9.-]+):([[:digit:]]+)/([a-zA-Z0-9_-]+)$'
if [[ $DATABASE_URL =~ $regex ]]; then
    export KC_DB_URL_HOST=${BASH_REMATCH[3]}
    export KC_DB_URL_PORT=${BASH_REMATCH[4]}
    export KC_DB_URL_DATABASE=${BASH_REMATCH[5]}
    export KC_DB_USERNAME=${BASH_REMATCH[1]}
    export KC_DB_PASSWORD=${BASH_REMATCH[2]}
fi
echo "KC DB URL HOST : " $KC_DB_URL_HOST
echo "KC DB URL PORT : " $KC_DB_URL_PORT
echo "KC DB URL DATABASE : " $KC_DB_URL_DATABASE
echo "KC DB USERNAME : " $KC_DB_USERNAME
echo "KC DB PASSWORD : " $KC_DB_PASSWORD
echo "Port : " $PORT
echo "Starting up..."
/opt/keycloak/bin/kc.sh start --http-port=$PORT
