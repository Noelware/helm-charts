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

{{- define "registry.auth.pod" -}}
serviceAccountName: {{ include "registry.auth.serviceAccountName" . }}
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
        name: {{ default (printf "%s-config" (include "registry.auth.fullname" .)) .Values.deployment.existingConfigMap }}
    {{- if .Values.tls.enabled }}
    - name: rootbundle-tls
      secret:
        secretName: "docker-auth-rootbundle-tls"
    {{- end }}
    {{- if and .Values.ingress.tls .Values.ingress.selfSigned }}
    - name: server-tls
      secret:
        secretName: {{ printf "%s-server-tls" .Values.ingress.host }}
    {{- end }}
{{- with .Values.global.initContainers }}
initContainers:
    {{- . | toYaml }}
{{- end }}
containers:
    - name: {{ include "registry.auth.fullname" . }}
      image: {{ include "registry.auth.image" . }}
      imagePullPolicy: {{ .Values.image.pullPolicy }}
      resources: {{ default (include "registry.auth.defaultResourceLimits" .) .Values.global.resources | nindent 8 }}
      securityContext: {{ default (include "registry.auth.defaultContainerSecurityContext" .) .Values.global.containerSecurityContext | nindent 8 }}
      args:
        - "--v={{ .Values.deployment.logLevel }}"
        - -logtostderr
        - /data/config.yaml
      volumeMounts:
        - name: config
          mountPath: /data/config.yaml
          subPath: config.yaml
        {{- if .Values.tls.enabled }}
        - name: rootbundle-tls
          mountPath: /rootbundle/certs
          readOnly: true
        {{- end }}
        {{- if and .Values.ingress.tls .Values.ingress.selfSigned }}
        - name: server-tls
          mountPath: /server/certs
          readOnly: true
        {{- end }}
      ports:
        - name: http
          containerPort: {{ .Values.service.port }}
      {{- if .Values.global.extraEnvVars }}
      env:
      {{ include "common.tplvalues.render" (dict "value" .Values.global.extraEnvVars "context" $) | nindent 8 }}
      {{- end }}
      {{- if .Values.deployment.startupProbe.enabled }}
      startupProbe:
        httpGet:
            path: /
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
            path: /
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
            path: /
            port: {{ .Values.service.port }}
        initialDelaySeconds: {{ .Values.deployment.livenessProbe.initialDelaySeconds }}
        timeoutSeconds: {{ .Values.deployment.livenessProbe.timeoutSeconds }}
        periodSeconds: {{ .Values.deployment.livenessProbe.periodSeconds }}
        successThreshold: {{ .Values.deployment.livenessProbe.successThreshold }}
        failureThreshold: {{ .Values.deployment.livenessProbe.failureThreshold }}
      {{- end }}
{{- end -}}
