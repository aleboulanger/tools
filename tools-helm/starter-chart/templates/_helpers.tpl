{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "<service_name>.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
Truncate at 63 chars characters due to limitations of the DNS system.
*/}}
{{- define "<service_name>.fullname" -}}
{{- $name := (include "<service_name>.name" .) -}}
{{- printf "%s-%s" .Release.Name $name -}}
{{- end -}}

{{/*
Create a default chart name including the version number
*/}}
{{- define "<service_name>.chart" -}}
{{- $name := (include "<service_name>.name" .) -}}
{{- printf "%s-%s" $name .Chart.Version | replace "+" "_" -}}
{{- end -}}

{{/*
Define the docker registry key.
*/}}
{{- define "<service_name>.registryKey" -}}
{{- .Values.global.registryKey | default "talendregistry" }}
{{- end -}}

{{/*
Define labels which are used throughout the chart files
*/}}
{{- define "<service_name>.labels" -}}
app: {{ include "<service_name>.fullname" . }}
chart: {{ include "<service_name>.chart" . }}
release: {{ .Release.Name }}
heritage: {{ .Release.Service }}
{{- end -}}

{{/*
Define the docker image.
*/}}
{{- define "<service_name>.image" -}}
{{- $envValues := pluck .Values.global.env .Values | first }}
{{- $imageRepositoryName := pick $envValues "image.repositoryName" | default .Values.image.repositoryName -}}
{{- $imageTag := pick $envValues "image.tag" | default .Values.image.tag -}}
{{- printf "%s/%s/%s:%s" .Values.global.registry .Values.global.repositoryUser $imageRepositoryName $imageTag }}
{{- end -}}

{{/*
Define the default service name.
*/}}
{{- define "<service_name>.serviceName" -}}
{{- $envValues := pluck .Values.global.env .Values | first }}
{{- $serviceName := pick $envValues "service.name" | default .Values.service.name -}}
{{- $imageRepositoryName := pick $envValues "image.repositoryName" | default .Values.image.repositoryName -}}
{{- $serviceName | default $imageRepositoryName }}
{{- end -}}