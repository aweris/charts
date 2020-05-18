{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "gar.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "gar.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "gar.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "gar.labels" -}}
helm.sh/chart: {{ include "gar.chart" . }}
{{ include "gar.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "gar.selectorLabels" -}}
app.kubernetes.io/name: {{ include "gar.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "gar.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "gar.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{- define "runner.labels" -}}
{{- join "," .Values.runner.labels }}
{{- end -}}

{{/*
Returns true, if new secret should created
*/}}
{{- define "github.createSecret" -}}
{{- if not .Values.runner.ghAuth.existingSecret -}}
{{ true }}
{{- end -}}
{{- end -}}

{{/*
Returns secret name for github authentication
*/}}
{{- define "github.secretName" -}}
{{- if include "github.createSecret" . -}}
{{ printf "%s-gh-auth" (include "gar.fullname" .)  }}
{{- else -}}
{{ .Values.runner.ghAuth.existingSecret }}
{{- end -}}
{{- end -}}
