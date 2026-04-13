{{/*
Resolve the namespace with the following priority:
  1. --namespace flag (.Release.Namespace), when not the implicit "default"
  2. .Values.namespace.name
  3. .Release.Name
*/}}
{{- define "fabric.namespace" -}}
{{- $namespace := default dict .Values.namespace -}}
{{- if and .Release.Namespace (ne .Release.Namespace "default") -}}
{{- .Release.Namespace -}}
{{- else -}}
{{- default .Release.Name $namespace.name -}}
{{- end -}}
{{- end -}}
