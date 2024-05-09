{{/*
~ 🐻‍❄️🔮 Noelware's Helm Charts: Curated catalog of Noelware's Helm charts.
~ Copyright (c) 2022-2024 Noelware, LLC. <team@noelware.org>
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

Example:
    {{ include "hazel.name" . }}
*/}}
{{- define "hazel.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.

Example:
    {{ include "hazel.fullname" }}
*/}}
{{- define "hazel.fullname" -}}
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

Example:
    {{ include "hazel.chart" . }}
*/}}
{{- define "hazel.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels that are attached to each Kubernetes object spawned by the Helm chart.

Example:

    labels:
        {{- include "hazel.labels" . | nindent 8 }}
*/}}
{{- define "hazel.labels" -}}
{{ include "hazel.selectorLabels" . }}
k8s.noelware.cloud/managed-by: Helm
{{- end }}

{{- define "hazel.selectorLabels" -}}
k8s.noelware.cloud/name: {{ include "hazel.name" . }}
k8s.noelware.cloud/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use

Example:
    serviceAccountName: {{ include "hazel.serviceAccountName" . | quote }}
*/}}
{{- define "hazel.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "hazel.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Default annotations that are included in each Kubernetes object spawned by the Helm chart.

Example:

    annotations:
        # with no external annotations
        {{- include "hazel.annotations" (dict "context" .) }}

        # with external annotations
        {{- $annotations := dict "hello.world/uwu" "world" }}
        {{- include "hazel.annotations" (dict "external" $annotations "context" .) }}
*/}}
{{- define "hazel.annotations" -}}
k8s.noelware.cloud/component: http-proxy
k8s.noelware.cloud/product: Hazel
{{- if .context.Chart.AppVersion }}
k8s.noelware.cloud/version: {{ .context.Chart.AppVersion | quote }}
{{- end }}

{{- $externalAnnotations := .external | default dict }}
{{/* "common.tplvalues.merge" conjoins as a YAML string, so we need to `fromYaml` for this to probably work (idk!) */}}
{{- $all := include "common.tplvalues.merge" (dict "values" (list $externalAnnotations .context.Values.global.annotations) "context" .context) | fromYaml }}

{{- range $key, $val := $all }}
    {{ $key }}: {{ $val | quote }}
{{- end -}}
{{- end -}}

{{/*
Default Pod security context object
*/}}
{{- define "hazel.defaultPodSecurityContext" -}}
fsGroup: 1001
seccompProfile:
  type: "RuntimeDefault"
{{- end -}}

{{/*
Default container security context object
*/}}
{{- define "hazel.defaultContainerSecurityContext" -}}
runAsUser: 1001
runAsNonRoot: true
readOnlyRootFilesystem: false
allowPrivilegeEscalation: false
capabilities:
  drop: ["ALL"]
{{- end -}}

{{/*
Default resource limits
*/}}
{{- define "hazel.defaultResourceLimits" -}}
limits:
    memory: 4Gi
    cpu: 1500m
requests:
    memory: 1Gi
    cpu: 500m
{{- end -}}

{{/*
Image definition for Hazel
*/}}
{{- define "hazel.image" -}}
{{/* define our variables */}}
{{- $registry := default "docker.io" .Values.image.registry -}}
{{- $repo := .Values.image.image -}}
{{- $tag := default .Chart.AppVersion .Values.image.tag -}}
{{- $sep := ":" -}}

{{- if .Values.image.digest }}
    {{- $tag := .Values.image.digest | toString -}}
    {{- $sep := "@" -}}
{{- end -}}

{{/* bring it all together */}}
{{- printf "%s/%s%s%s" $registry $repo $sep $tag -}}
{{- end -}}
