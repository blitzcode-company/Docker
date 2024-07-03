#!/bin/bash

CONTAINER_NAME="mysql"
MYSQL_CMD="mysql -u root -proot -D blitzvideo -se \"SELECT secret FROM oauth_clients WHERE id = 1;\""
CLIENT_SECRET=$(sudo docker exec -ti $CONTAINER_NAME bash -c "$MYSQL_CMD" | tail -n 1 | tr -d '\r')
AUTH_SERVICE_FILE="Blitzvideo-Auth/src/app/servicios/auth.service.ts"

if [[ -f "$AUTH_SERVICE_FILE" ]]; then
    sed -i "s/client_secret: \".*\"/client_secret: \"$CLIENT_SECRET\"/" "$AUTH_SERVICE_FILE"
    echo "Actualizado $AUTH_SERVICE_FILE con client_secret: $CLIENT_SECRET"
else
    echo "Archivo $AUTH_SERVICE_FILE no encontrado."
fi
