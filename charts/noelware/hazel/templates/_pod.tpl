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

{{- define "hazel.pod" -}}
serviceAccountName: {{ include "hazel.serviceAccountName" . }}
{{- if .Values.global.affinity }}
affinity: {{- include "common.tplvalues.render" (dict "value" .Values.global.affinity "context" $) }}
{{- end }}
{{- if .Values.global.nodeSelector }}
nodeSelector: {{- include "common.tplvalues.render" (dict "value" .Values.global.nodeSelector "context" $) }}
{{- end }}
{{- if .Values.global.tolerations }}
tolerations: {{- include "common.tplvalues.render" (dict "value" .Values.global.tolerations "context" $) }}
{{- end }}
{{- if .Values.global.affinity }}
affinity: {{- include "common.tplvalues.render" (dict "value" .Values.global.affinity "context" $) }}
{{- end }}
{{- if .Values.global.dnsPolicy }}
dnsPolicy: {{ .Values.global.dnsPolicy }}
{{- end }}
{{- with .Values.global.dnsConfig }}
dnsConfig:
    {{ toYaml . | nindent 2 }}
{{- end }}
volumes:
    - name: config
      configMap:
        name: {{ default (printf "%s-config" (include "hazel.fullname" .)) .Values.config.existingMap }}
{{- if eq .Values.storage.kind "Filesystem" }}
    - name: data
      persistentVolumeClaim:
        claimName: {{ default (printf "%s-data" (include "hazel.fullname" .)) .Values.storage.filesystem.existingClaim }}
{{- end }}
{{- with .Values.global.initContainers }}
initContainers:
    {{- . | toYaml }}
{{- end }}
containers:
    - name: {{ include "hazel.fullname" . }}
      image: {{ include "hazel.image" . }}
      imagePullPolicy: {{ .Values.image.pullPolicy }}
      resources: {{ default (include "hazel.defaultResourceLimits" .) .Values.global.resources | nindent 8 }}
      securityContext: {{ default (include "hazel.defaultContainerSecurityContext" .) .Values.global.containerSecurityContext | nindent 8 }}
      volumeMounts:
        - name: config
          mountPath: /app/noelware/hazel/config/hazel.hcl
          subPath: hazel.hcl
        {{- if eq .Values.storage.kind "Filesystem" }}
        - name: data
          mountPath: /var/lib/noelware/hazel/data
        {{- end }}
      ports:
        - name: http
          containerPort: {{ .Values.service.port }}
      env:
        {{- if .Values.global.serverName }}
        - name: HAZEL_SERVER_NAME
          value: {{ .Values.global.serverName | quote }}
        {{- end }}
        {{- if.Values.global.extraEnvVars }}
        {{ include "common.tplvalues.render" (dict "value" .Values.global.extraEnvVars "context" $) | nindent 8 }}
        {{- end }}
      {{- if .Values.deployment.startupProbe.enabled }}
      startupProbe:
        httpGet:
            path: /heartbeat
            port: {{ .Values.service.port }}
        initialDelaySeconds: {{ .Values.deployment.startupProbe.initialDelaySeconds }}
        timeoutSeconds: {{ .Values.deployment.startupProbe.timeoutSeconds }}
        periodSeconds: {{ .Values.deployment.startupProbe.periodSeconds }}
        successThreshold: {{ .Values.deployment.startupProbe.successThreshold }}
        failureThreshold: {{ .Values.deployment.startupProbe.failureThreshold }}
      {{- end }}
      {{- if .Values.deployment.readinessProbe.enabled }}
      readinessProbe:
        httpGet:
            path: /heartbeat
            port: {{ .Values.service.port }}
        initialDelaySeconds: {{ .Values.deployment.readinessProbe.initialDelaySeconds }}
        timeoutSeconds: {{ .Values.deployment.readinessProbe.timeoutSeconds }}
        periodSeconds: {{ .Values.deployment.readinessProbe.periodSeconds }}
        successThreshold: {{ .Values.deployment.readinessProbe.successThreshold }}
        failureThreshold: {{ .Values.deployment.readinessProbe.failureThreshold }}
      {{- end }}
      {{- if .Values.deployment.livenessProbe.enabled }}
      livenessProbe:
        httpGet:
            path: /heartbeat
            port: {{ .Values.service.port }}
        initialDelaySeconds: {{ .Values.deployment.livenessProbe.initialDelaySeconds }}
        timeoutSeconds: {{ .Values.deployment.livenessProbe.timeoutSeconds }}
        periodSeconds: {{ .Values.deployment.livenessProbe.periodSeconds }}
        successThreshold: {{ .Values.deployment.livenessProbe.successThreshold }}
        failureThreshold: {{ .Values.deployment.livenessProbe.failureThreshold }}
      {{- end }}
{{- end -}}
