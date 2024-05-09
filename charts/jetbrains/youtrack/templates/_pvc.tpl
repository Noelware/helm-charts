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
Defines a generic PVC for JetBrains YouTrack. It must have a section in .Values.persistence (persistent block in `values.yaml`).

Example:
    {{- include "youtrack.definePersistentVolumeClaim" (dict "Values" .Values "Chart" .Chart "Release" .Release "name" "<name of backup>") -}}
*/}}
{{- define "youtrack.definePersistentVolumeClaim" -}}
{{- if not (typeIs "string" .name) -}}
    {{ fail (printf "Name [%s] wanted 'string', received '%s'" .name (typeOf .name)) }}
{{- end -}}
{{- if not (hasKey .Values.persistence.existingClaims .name) -}}
    {{ fail (printf ("unknown key: [%s]" .name)) }}
{{- end -}}
{{ $claim := get .Values.persistence.existingClaims .name }}

apiVersion: v1
kind: PersistentVolumeClaim
metadata:
    name: {{ printf "%s-%s" (include "youtrack.fullname" .) .name }}
    namespace: {{ .Release.Namespace }}
    labels:
        {{- include "youtrack.labels" . | nindent 8 }}
    annotations:
        {{- include "youtrack.annotations" . | nindent 8 }}
spec:
    {{- if .Values.persistence.storageClass }}
    storageClassName: {{ .Values.persistence.storageClass | quote }}
    {{- end }}
    resources:
        requests:
            storage: {{ get .Values.persistence.sizes .name }}
    accessModes:
    {{- with .Values.persistence.accessModes -}}
        {{ toYaml . | nindent 8 }}
    {{- end }}
    {{ $selector := get .Values.persistence.selectors .name -}}
    {{- if $selector }}
    selector:
        {{- toYaml $selector | nindent 8 }}
    {{- end }}
{{- end -}}
