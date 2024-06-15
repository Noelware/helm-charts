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
    {{ include "registry.auth.name" . }}
*/}}
{{- define "registry.auth.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.

Example:
    {{ include "registry.auth.fullname" }}
*/}}
{{- define "registry.auth.fullname" -}}
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
    {{ include "registry.auth.chart" . }}
*/}}
{{- define "registry.auth.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels that are attached to each Kubernetes object spawned by the Helm chart.

Example:

    labels:
        {{- include "registry.auth.labels" . | nindent 8 }}
*/}}
{{- define "registry.auth.labels" -}}
{{ include "registry.auth.selectorLabels" . }}
k8s.noelware.cloud/managed-by: Helm
{{- end }}

{{- define "registry.auth.selectorLabels" -}}
k8s.noelware.cloud/name: {{ include "registry.auth.name" . }}
k8s.noelware.cloud/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use

Example:
    serviceAccountName: {{ include "registry.auth.serviceAccountName" . | quote }}
*/}}
{{- define "registry.auth.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "registry.auth.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Default annotations that are included in each Kubernetes object spawned by the Helm chart.

Example:

    annotations:
        # with no external annotations
        {{- include "registry.auth.annotations" (dict "context" .) }}

        # with external annotations
        {{- $annotations := dict "hello.world/uwu" "world" }}
        {{- include "registry.auth.annotations" (dict "external" $annotations "context" .) }}
*/}}
{{- define "registry.auth.annotations" -}}
k8s.noelware.cloud/component: authentication
k8s.noelware.cloud/product: docker-auth
k8s.noelware.cloud/part-of: cncf-distribution
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
{{- define "registry.auth.defaultPodSecurityContext" -}}
fsGroup: 1001
seccompProfile:
  type: "RuntimeDefault"
{{- end -}}

{{/*
Default container security context object
*/}}
{{- define "registry.auth.defaultContainerSecurityContext" -}}
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
{{- define "registry.auth.defaultResourceLimits" -}}
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
{{- define "registry.auth.image" -}}
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
