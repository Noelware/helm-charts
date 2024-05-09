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
Defines a generic PVC for JetBrains Hub.

Example:
    {{- include "hub.definePersistentVolumeClaim" (dict "persistence" .Values.persistence "context" . "name" "<name of pvc>") -}}
*/}}
{{- define "hub.definePersistentVolumeClaim" -}}
{{- if not (typeIs "string" .name) -}}
    {{ fail (printf "Name [%s] wanted 'string', received '%s'" .name (typeOf .name)) }}
{{- end -}}
{{- if not (hasKey .persistence .name) -}}
    {{ fail (printf ("unknown key: [%s]" .name)) }}
{{- end -}}

{{- $claim := get .persistence .name }}
{{- $existing := get $claim "existingClaim" }}
{{- $annotations := include "hub.annotations" (dict "external" (get $claim "annotations" | default dict) "Chart" .context.Chart "Values" .context.Values) }}

{{/* if (get($claim, "existingClaim") != "") */}}
{{- if not $existing }}
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
    name: {{ printf "%s-%s" (include "hub.fullname" .context) .name }}
    namespace: {{ .context.Release.Namespace }}
    labels:
        {{- include "hub.labels" .context | nindent 8 }}
    annotations:
        {{- $annotations | nindent 8 }}
spec:
    {{- if .persistence.storageClass }}
    storageClassName: {{ .persistence.storageClass | quote }}
    {{- end }}
    resources:
        requests:
            storage: {{ get $claim "size" }}
    accessModes:
    {{- with .persistence.accessModes -}}
        {{ toYaml . | nindent 8 }}
    {{- end }}
    {{ $selector := get $claim "selector" -}}
    {{- if $selector }}
    selector:
        {{- toYaml $selector | nindent 8 }}
    {{- end }}
{{- end -}}
{{- end -}}
