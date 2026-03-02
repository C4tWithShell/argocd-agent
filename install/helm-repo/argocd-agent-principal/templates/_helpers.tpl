{{/*
Expand the name of the chart.
*/}}
{{- define "argocd-agent-principal.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "argocd-agent-principal.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart label.
*/}}
{{- define "argocd-agent-principal.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "argocd-agent-principal.labels" -}}
helm.sh/chart: {{ include "argocd-agent-principal.chart" . }}
app.kubernetes.io/part-of: argocd-agent
app.kubernetes.io/component: principal
{{ include "argocd-agent-principal.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "argocd-agent-principal.selectorLabels" -}}
app.kubernetes.io/name: {{ include "argocd-agent-principal.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
ServiceAccount name
*/}}
{{- define "argocd-agent-principal.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "argocd-agent-principal.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Expand the namespace of the release.
*/}}
{{- define "argocd-agent-principal.namespace" -}}
{{- default .Release.Namespace .Values.namespaceOverride | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/*
Image reference
*/}}
{{- define "argocd-agent-principal.image" -}}
{{- $tag := default .Chart.AppVersion .Values.image.tag }}
{{- printf "%s:%s" .Values.image.repository $tag }}
{{- end }}

{{/*
Userpass secret name
*/}}
{{- define "argocd-agent-principal.userpassSecretName" -}}
{{- default (printf "%s-userpass" (include "argocd-agent-principal.fullname" .)) .Values.userpass.secretName }}
{{- end }}

{{/*
TLS secret name
*/}}
{{- define "argocd-agent-principal.tlsSecretName" -}}
{{- default (printf "%s-tls" (include "argocd-agent-principal.fullname" .)) .Values.tlsSecret.secretName }}
{{- end }}
