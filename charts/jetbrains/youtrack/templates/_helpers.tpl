{{/*
~ 🐻‍❄️🔮 Noelware's Helm Charts: Curated catalog of Noelware's Helm charts.
~ Copyright (c) 2022-2023 Noelware, LLC. <team@noelware.org>
~
~ Permission is hereby granted, free of charge, to any person obtaining a copy
~ of this software and associated documentation files (the "Software"), to deal
~ in the Software without restriction, including without limitation the rights
~ to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
~ copies of the Software, and to permit persons to whom the Software is
~ furnished to do so, subject to the following conditions:
~
~ The above copyright notice and this permission notice shall be included in all
~ copies or substantial portions of the Software.
~
~ THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
~ IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
~ FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
~ AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
~ LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
~ OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
~ SOFTWARE.
*/}}

{{/*
Expand the name of the chart.
*/}}
{{- define "youtrack.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "youtrack.fullname" -}}
{{- if .Values.fullNameOverride -}}
{{- .Values.fullNameOverride | trunc 63 | trimSuffix "-" -}}
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
{{- define "youtrack.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "youtrack.labels" -}}
k8s.noelware.cloud/chart: {{ include "youtrack.chart" . }}
{{ include "youtrack.selectorLabels" . }}
{{- if .Chart.AppVersion }}
k8s.noelware.cloud/version: {{ .Chart.AppVersion | quote }}
{{- end }}
k8s.noelware.cloud/managed-by: Helm
{{- end }}

{{- define "youtrack.selectorLabels" -}}
k8s.noelware.cloud/name: {{ include "youtrack.name" . }}
k8s.noelware.cloud/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "youtrack.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "youtrack.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Default annotations
*/}}
{{- define "youtrack.annotations" -}}
k8s.noelware.cloud/component: issue-management
k8s.noelware.cloud/product: youtrack

{{- range $key, $val := .Values.global.annotations }}
    {{ $key }}: {{ $val | quote }}
{{- end }}
{{- end -}}

{{/*
Default Pod security context object
*/}}
{{- define "youtrack.defaultPodSecurityContext" -}}
enabled: true
fsGroup: 1001
seccompProfile:
  type: "RuntimeDefault"
{{- end -}}

{{/*
Default container security context object
*/}}
{{- define "youtrack.defaultContainerSecurityContext" -}}
enabled: true
runAsUser: 1001
runAsNonRoot: true
readOnlyRootFilesystem: false
allowPrivilegeEscalation: false
capabilities:
  drop: ["ALL"]
{{- end -}}
