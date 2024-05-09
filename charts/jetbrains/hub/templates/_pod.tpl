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

{{/* Describes the pod template for JetBrains Hub */}}
{{- define "hub.pod" -}}
serviceAccountName: {{ include "hub.serviceAccountName" . }}
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
    - name: data
      persistentVolumeClaim:
        claimName: {{ default (printf "%s-data" (include "hub.fullname" .)) .Values.persistence.data.existingClaim }}
    - name: logs
      persistentVolumeClaim:
        claimName: {{ default (printf "%s-logs" (include "hub.fullname" .)) .Values.persistence.logs.existingClaim }}
    - name: conf
      persistentVolumeClaim:
        claimName: {{ default (printf "%s-conf" (include "hub.fullname" .)) .Values.persistence.conf.existingClaim }}
    - name: backups
      persistentVolumeClaim:
        claimName: {{ default (printf "%s-backups" (include "hub.fullname" .)) .Values.persistence.backups.existingClaim }}
initContainers:
{{- if .Values.deployment.configureFlags }}
    - name: configure-instance
      image: {{ include "hub.image" . }}
      imagePullPolicy: {{ .Values.image.pullPolicy }}
      command: ["/run.sh"]
      args:
        - configure
        {{- range split " " .Values.deployment.configureFlags }}
        - {{ toYaml . | quote }}
        {{- end }}
        {{- if .Values.baseUrl }}
        - --hub-url={{ .Values.baseUrl }}
        {{- end }}
      volumeMounts:
        - name: data
          mountPath: /opt/hub/data
        - name: logs
          mountPath: /opt/hub/logs
        - name: conf
          mountPath: /opt/hub/conf
        - name: backups
          mountPath: /opt/hub/backups
{{- end }}
{{- with .Values.global.initContainers }}
    {{- toYaml . | nindent 4 }}
{{- end }}
containers:
    - name: {{ include "hub.fullname" . }}
      image: {{ include "hub.image" . }}
      imagePullPolicy: {{ .Values.image.pullPolicy }}
      resources: {{ default (include "hub.defaultResourceLimits" .) .Values.global.resources | nindent 8 }}
      securityContext: {{ default (include "hub.defaultContainerSecurityContext" .) .Values.global.containerSecurityContext | nindent 8 }}
      volumeMounts:
        - name: data
          mountPath: /opt/hub/data
        - name: logs
          mountPath: /opt/hub/logs
        - name: conf
          mountPath: /opt/hub/conf
        - name: backups
          mountPath: /opt/hub/backups
      ports:
        - name: http
          containerPort: {{ .Values.service.port }}
      {{- if .Values.global.extraEnvVars }}
      env:
      {{- include "common.tplvalues.render" (dict "value" .Values.global.extraEnvVars "context" $) | nindent 8 }}
      {{- end }}
{{- end -}}
