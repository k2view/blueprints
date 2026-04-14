{{/*
Resolve the namespace with the following priority:
  1. .Values.namespace.name
  2. .Release.Namespace, when not the implicit "default"
  3. .Release.Name
*/}}
{{- define "fabric.namespace" -}}
{{- $namespace := default dict .Values.namespace -}}
{{- if $namespace.name -}}
{{- $namespace.name -}}
{{- else if and .Release.Namespace (ne .Release.Namespace "default") -}}
{{- .Release.Namespace -}}
{{- else -}}
{{- .Release.Name -}}
{{- end -}}
{{- end -}}
