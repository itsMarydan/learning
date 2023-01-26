
{{/*
Create service host name
*/}}
{{- define "keycloak.service.host" -}}
{{- printf "keycloak-service." .Release.Namespace ".svc.cluster.local" }}
{{- end }}


