{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "userGroupOperator.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "userGroupOperator.fullname" -}}
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
{{- define "userGroupOperator.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "userGroupOperator.labels" -}}
helm.sh/chart: {{ include "userGroupOperator.chart" . }}
{{ include "userGroupOperator.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "userGroupOperator.selectorLabels" -}}
app.kubernetes.io/name: {{ include "userGroupOperator.name" . }}
{{-   if (ne .Release.Name "RELEASE-NAME") }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{-   end -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "userGroupOperator.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "userGroupOperator.name" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the namespace to use
*/}}
{{- define "userGroupOperator.namespaceName" -}}
{{- if .Values.namespace.create -}}
    {{ default (include "userGroupOperator.name" .) .Values.namespace.name }}
{{- else -}}
    {{ default "default" .Values.namespace.name }}
{{- end -}}
{{- end -}}

{{/*
Define the image to deploy
*/}}
{{- define "userGroupOperator.image" -}}
  {{- if eq .Values.image.tagOverride "-" -}}
    {{- .Values.image.repository -}}
  {{- else if .Values.image.tagOverride -}}
    {{- printf "%s:%s" .Values.image.repository .Values.image.tagOverride -}}
  {{- else -}}
    {{- printf "%s:v%s" .Values.image.repository .Chart.AppVersion -}}
  {{- end -}}
{{- end -}}
