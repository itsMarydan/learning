#! /bin/bash

k create sa spike-auth
k create secret generic spike-client --from-literal=client_id=spike-client --from-literal=client_secret=ZQ37y3neF2pxeoShSpN5mFF3gnfofbcm

kubectl patch serviceaccount spike-auth -p '{"secrets": [{"name": "spike-client"}]}'





PWD:74036b4820c548f380d5c1b41d25e990



USER:admin
PWD:befb3b340a284e08a60913d5d683edd3

export TOKEN=$(curl \
  -sk \
  --data "username=molowu&password=molowu&grant_type=password&client_id=demo-client&client_secret=DoN1Q0SbUa8JEo0eRytfVwDtu96nW9ig" \
  https://keycloak.centralizer.io/realms/demo/protocol/openid-connect/token \
  | jq ".access_token")

curl -i http://demo.centralizer.io/ -H "Authorization: Bearer $TOKEN"
curl -i http://localhost:8080/api/v1/token/payload -H "Authorization: Bearer $TOKEN"


 export TOKEN=$(curl \
  -sk \
  --data "username=molowu&password=molowu&grant_type=password&client_id=demo-client&client_secret=DoN1Q0SbUa8JEo0eRytfVwDtu96nW9ig" \
  https://keycloak.centralizer.io/realms/demo/protocol/openid-connect/token \
  | python -c "import sys, json; print(json.load(sys.stdin)['access_token'])")

Warning: using deprecated filter name "envoy.http_connection_manager"; use "envoy.filters.network.http_connection_manager" instead
Warning: Envoy filter: unknown field "config" in envoy.extensions.filters.network.http_connection_manager.v3.HttpFilter
envoyfilter.networking.istio.io/keycloak-auth created