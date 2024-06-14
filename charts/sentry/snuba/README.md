# 🐻‍❄️🔮 `noelware/snuba` Helm Chart
The **noelware/snuba** Helm chart is an unofficial Helm chart to deploy Sentry's [Snuba](https://github.com/getsentry/snuba) service. This was made to allow external Snuba services to be deployed with Noelware's Sentry Helm chart and to deploy Snuba outside of Sentry.

## Requirements
* Kubernetes v1.26 or higher
* Helm 3.12 or higher

## Installation
```shell
$ helm repo add noelware https://charts.noelware.org/~/noelware
$ helm install snuba noelware/snuba
```

## Parameters
