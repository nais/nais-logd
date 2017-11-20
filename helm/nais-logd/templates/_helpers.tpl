{{- define "nais-logd.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "nais-logd.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if ne .Chart.Name .Release.Name -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s" $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "nais-logd.fluentd.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if ne .Chart.Name .Release.Name -}}
{{- printf "%s-%s-%s" .Release.Name $name .Values.fluentd.name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" $name .Values.fluentd.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "nais-logd.kubewatch.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if ne .Chart.Name .Release.Name -}}
{{- printf "%s-%s-%s" .Release.Name $name .Values.kubewatch.name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" $name .Values.kubewatch.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
