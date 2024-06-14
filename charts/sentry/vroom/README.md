# 🐻‍❄️🔮 `noelware/vroom` Helm Chart
The **noelware/vroom** Helm chart is an unofficial Helm chart to deploy Sentry's [VROOM!](https://github.com/getsentry/vroom) service. This was made to allow external VROOM! services to be deployed with Noelware's Sentry Helm chart.

**VROOM!** allows Sentry to enable its profiling features, you can read more [here](https://docs.sentry.io/product/explore/profiling).

## Requirements
* Kubernetes v1.26 or higher
* Helm 3.12 or higher

## Installation
```shell
$ helm repo add noelware https://charts.noelware.org/~/noelware
$ helm install vroom noelware/vroom
```

## Parameters

### Global Parameters

Contains any global parameters that will affected all objects in the VROOM! Helm chart.

| Name                              | Description                                                                                                                                                                                              | Value           |
| --------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------- |
| `global.replicas`                 | Amount of replicas to use                                                                                                                                                                                | `1`             |
| `global.resources`                | Resource list to apply to all containers.                                                                                                                                                                | `{}`            |
| `global.fullNameOverride`         | String to fully override the Helm installation name for all objects                                                                                                                                      | `""`            |
| `global.nameOverride`             | String to override the Helm installation name for all objects, will be in conjunction with a prefix of `<install-name>-`                                                                                 | `""`            |
| `global.clusterDomain`            | Domain host that maps to the cluster                                                                                                                                                                     | `cluster.local` |
| `global.nodeSelector`             | Selector labels to apply to contraint the pods to specific nodes. Read more in the [Kubernetes documentation](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).    | `{}`            |
| `global.tolerations`              | List of all taints/tolerations to apply in conjunction with `global.affinity`. Read more in the [Kubernetes documentation](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration) | `[]`            |
| `global.affinity`                 | Map of all the affinity to apply to the spawned Pods. Read more in the [Kubernetes documentation](https://kubernetes.io/docs/tasks/configure-pod-container/assign-pods-nodes-using-node-affinity/).      | `{}`            |
| `global.annotations`              | Map of annotations to append to on all objects that this Helm chart creates.                                                                                                                             | `{}`            |
| `global.extraEnvVars`             | List of extra environment variables to append to all init/sidecar containers and normal containers.                                                                                                      | `[]`            |
| `global.initContainers`           | List of init containers to create.                                                                                                                                                                       | `[]`            |
| `global.podSecurityContext`       | Security context for all spawned Pods. Read more in the [Kubernetes documentation](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/).                                          | `{}`            |
| `global.containerSecurityContext` | Security context for all init, sidecar, and normal containers. Read more in the [Kubernetes documentation](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/).                  | `{}`            |
| `global.dnsPolicy`                | DNS policy for the pod.                                                                                                                                                                                  | `""`            |
| `global.dnsConfig`                | Configures the [DNS configuration](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/#pod-dns-config) for the pod.                                                                 | `{}`            |

### Docker Image Parameters

Parameters to modify the Docker image that is ran.

| Name               | Description                                                                                                     | Value             |
| ------------------ | --------------------------------------------------------------------------------------------------------------- | ----------------- |
| `image.pullPolicy` | [Pull policy](https://kubernetes.io/docs/concepts/containers/images/#image-pull-policy) when pulling the image. | `""`              |
| `image.registry`   | Registry URL to point to. For Docker Hub, use an empty string.                                                  | `""`              |
| `image.image`      | Image name.                                                                                                     | `getsentry/vroom` |
| `image.tag`        | The tag of the image. Keep this as a empty string if you wish to use the default app's version.                 | `""`              |
| `image.digest`     | Digest in the form of `<alg>:<hex>`, this will replace the `image.tag` property if this is not empty.           | `""`              |

### Service Account Parameters

| Name                                          | Description                                                                                | Value  |
| --------------------------------------------- | ------------------------------------------------------------------------------------------ | ------ |
| `serviceAccount.create`                       | Whether or not if the service account should be created for this Helm installation.        | `true` |
| `serviceAccount.annotations`                  | Any additional annotations to append to this ServiceAccount                                | `{}`   |
| `serviceAccount.name`                         | The name of the service account, this will be the Helm installation name if this is empty. | `""`   |
| `serviceAccount.automountServiceAccountToken` | whether if the service account token is mounted onto the containers                        | `true` |

### Deployment Parameters

| Name                                            | Description                                                                                                                         | Value  |
| ----------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------- | ------ |
| `deployment.strategy`                           | [Deployment strategy](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#strategy) when creating the deployment. | `{}`   |
| `deployment.startupProbe.enabled`               | whether or not to enable probing at startup.                                                                                        | `true` |
| `deployment.startupProbe.initialDelaySeconds`   | Delay in seconds on when to probe.                                                                                                  | `15`   |
| `deployment.startupProbe.timeoutSeconds`        | How long to wait for the probe to succeed.                                                                                          | `1`    |
| `deployment.startupProbe.periodSeconds`         | How often to perform probing (in seconds)                                                                                           | `10`   |
| `deployment.startupProbe.successThreshold`      | Minimum consecutive successes for the probe to considered successful.                                                               | `1`    |
| `deployment.startupProbe.failureThreshold`      | Minimum consecutive failures for the probe to considered successful.                                                                | `5`    |
| `deployment.readinessProbe.enabled`             | whether or not to enable the readiness probing                                                                                      | `true` |
| `deployment.readinessProbe.initialDelaySeconds` | Delay in seconds on when to probe.                                                                                                  | `15`   |
| `deployment.readinessProbe.timeoutSeconds`      | How long to wait for the probe to succeed.                                                                                          | `1`    |
| `deployment.readinessProbe.periodSeconds`       | How often to perform probing (in seconds)                                                                                           | `10`   |
| `deployment.readinessProbe.successThreshold`    | Minimum consecutive successes for the probe to considered successful.                                                               | `1`    |
| `deployment.readinessProbe.failureThreshold`    | Minimum consecutive failures for the probe to considered successful.                                                                | `5`    |
| `deployment.livenessProbe.enabled`              | whether or not to enable the liveness probing                                                                                       | `true` |
| `deployment.livenessProbe.initialDelaySeconds`  | Delay in seconds on when to probe.                                                                                                  | `15`   |
| `deployment.livenessProbe.timeoutSeconds`       | How long to wait for the probe to succeed.                                                                                          | `1`    |
| `deployment.livenessProbe.periodSeconds`        | How often to perform probing (in seconds)                                                                                           | `10`   |
| `deployment.livenessProbe.successThreshold`     | Minimum consecutive successes for the probe to considered successful.                                                               | `1`    |
| `deployment.livenessProbe.failureThreshold`     | Minimum consecutive failures for the probe to considered successful.                                                                | `5`    |

### Pod Disruption Budget

| Name                                 | Description                                                                                                                                             | Value   |
| ------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `podDisruptionBudget.enabled`        | Enables the use of a `PodDisruptionBudget`. Read more in the [Kubernetes documentation](https://kubernetes.io/docs/concepts/workloads/pods/disruptions) | `false` |
| `podDisruptionBudget.minAvailable`   | Minimum number (or percentage) of pods that should be remained scheduled                                                                                | `1`     |
| `podDisruptionBudget.maxUnavailable` | Maximum number (or percentage) of pods that maybe made unavaliable.                                                                                     | `nil`   |

### Service Parameters

Parameters to configure a [Kubernetes service](https://kubernetes.io/docs/concepts/services-networking/service/) to allow connectivity internally
or externally.

| Name                     | Description                                                                                                                                                        | Value       |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------- |
| `service.port`           | Port number to listen to.                                                                                                                                          | `8085`      |
| `service.clusterIP`      | IP to use for the cluster IP if `type` is `ClusterIP`.                                                                                                             | `""`        |
| `service.enabled`        | Whether or not if a Kubernetes service should be enabled.                                                                                                          | `true`      |
| `service.type`           | The [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types) to use.                                     | `ClusterIP` |
| `service.selectorLabels` | Selector to apply this Kubernetes service to                                                                                                                       | `{}`        |
| `service.externalName`   | The external name if `service.type` == `"ExternalName"`                                                                                                            | `nil`       |
| `service.loadBalancer`   | Load balancer configuration if `service.type` == `"LoadBalanacer"`                                                                                                 | `{}`        |
| `service.nodePort`       | Node port to expose, refer to the [Kubernetes documentation](https://kubernetes.io/docs/concepts/services-networking/service/#type-nodeport) for more information. | `""`        |
