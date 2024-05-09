# 🐻‍❄️🔮 noelware/jetbrains-youtrack
**noelware/jetbrains-youtrack** is our Helm chart for our internal issue tracker, [YouTrack](https://jetbrains.com/youtrack).

* [Documentation](https://www.jetbrains.com/help/youtrack/server/introduction-to-youtrack-server.html)

## Requirements
* Kubernetes v1.26 or higher
* Helm 3.12 or higher

## Installation
```shell
$ helm repo add noelware https://charts.noelware.org/~/noelware
$ helm install youtrack noelware/youtrack
```

## Parameters

### Global Parameters

Contains any global parameters that will affected all objects in the JetBrains YouTrack Helm chart.

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
| `global.baseUrl`                  | Base URL to use when configuring the YouTrack server                                                                                                                                                     | `""`            |

### Docker Image Parameters

Parameters to modify the Docker image that is ran.

| Name               | Description                                                                                                     | Value                |
| ------------------ | --------------------------------------------------------------------------------------------------------------- | -------------------- |
| `image.pullPolicy` | [Pull policy](https://kubernetes.io/docs/concepts/containers/images/#image-pull-policy) when pulling the image. | `""`                 |
| `image.registry`   | Registry URL to point to. For Docker Hub, use an empty string.                                                  | `""`                 |
| `image.image`      | Image name.                                                                                                     | `jetbrains/youtrack` |
| `image.tag`        | The tag of the image. Keep this as a empty string if you wish to use the default app's version.                 | `""`                 |
| `image.digest`     | Digest in the form of `<alg>:<hex>`, this will replace the `image.tag` property if this is not empty.           | `""`                 |

### Service Account Parameters

| Name                         | Description                                                                                | Value  |
| ---------------------------- | ------------------------------------------------------------------------------------------ | ------ |
| `serviceAccount.create`      | Whether or not if the service account should be created for this Helm installation.        | `true` |
| `serviceAccount.annotations` | Any additional annotations to append to this ServiceAccount                                | `{}`   |
| `serviceAccount.name`        | The name of the service account, this will be the Helm installation name if this is empty. | `""`   |

### Deployment Parameters

| Name                        | Description                                                                                                                                                                                    | Value                                                                |
| --------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------- |
| `deployment.configureFlags` | List of [JVM configuration flags](https://www.jetbrains.com/help/youtrack/server/configure-jvm-options.html#set-jvm-options) to use when configuring the installation of your YouTrack server. | `-J-Dorg.eclipse.jetty.server.Request.maxFormKeys=10000 -J-Xmx1024m` |
| `deployment.strategy`       | The [Deployment strategy](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#strategy) when creating the deployment.                                                        | `{}`                                                                 |

### Persistence

| Name                                 | Description                                                                                                                                   | Value               |
| ------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------- | ------------------- |
| `persistence.accessModes`            | List of access modes when creating the Persistent Volume Claim                                                                                | `["ReadWriteOnce"]` |
| `persistence.storageClass`           | StorageClass for the PVC creation                                                                                                             | `""`                |
| `persistence.existingClaims.backups` | If there is any existing backup PVC, then this is where you reference it.                                                                     | `""`                |
| `persistence.existingClaims.data`    | If there is any existing data PVC, then this is where you reference it.                                                                       | `""`                |
| `persistence.existingClaims.logs`    | If there is any existing logs PVC, then this is where you reference it.                                                                       | `""`                |
| `persistence.existingClaims.conf`    | If there is any existing config PVC, then this is where you reference it.                                                                     | `""`                |
| `persistence.selectors.backups`      | Mapping of the [selectors](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#selector) to filter when creating the backups PVC. | `{}`                |
| `persistence.selectors.data`         | Mapping of the [selectors](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#selector) to filter when creating the data PVC.    | `{}`                |
| `persistence.selectors.conf`         | Mapping of the [selectors](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#selector) to filter when creating the conf PVC.    | `{}`                |
| `persistence.selectors.logs`         | Mapping of the [selectors](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#selector) to filter when creating the logs PVC.    | `{}`                |
| `persistence.sizes.backups`          | Size of the backups PVC                                                                                                                       | `10Gi`              |
| `persistence.sizes.data`             | Size of the data PVC                                                                                                                          | `10Gi`              |
| `persistence.sizes.logs`             | Size of the logs PVC                                                                                                                          | `5Gi`               |
| `persistence.sizes.conf`             | Size of the config PVC                                                                                                                        | `512Mi`             |

### Service Parameters

Parameters to configure a [Kubernetes service](https://kubernetes.io/docs/concepts/services-networking/service/) to allow external connections to your
YouTrack instance.

| Name                     | Description                                                                                                                                                             | Value       |
| ------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| `service.clusterIP`      | IP to use for the cluster IP if `type` is `ClusterIP`.                                                                                                                  | `""`        |
| `service.enabled`        | Whether or not if a Kubernetes service should be enabled.                                                                                                               | `true`      |
| `service.type`           | The [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types) to use.                                          | `ClusterIP` |
| `service.selectorLabels` | Selector to apply this Kubernetes service to                                                                                                                            | `{}`        |
| `service.port`           | The port that YouTrack will listen on.                                                                                                                                  | `8080`      |
| `service.externalName`   | If `service.type` == `"ExternalName"`, then this would be set as [`spec.externalName`](https://kubernetes.io/docs/concepts/services-networking/service/#externalname)   | `""`        |
| `service.loadBalancer`   | If `service.type` == `"LoadBalancer"`, then this would be set as [`status.loadBalancer`](https://kubernetes.io/docs/concepts/services-networking/service/#loadbalancer) | `{}`        |

### Ingress

[Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress) configuration.

| Name                  | Description                                                                                                                     | Value                    |
| --------------------- | ------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `ingress.className`   | Ingress class name to use.                                                                                                      | `""`                     |
| `ingress.enabled`     | Whether if Ingress record generation should be enabled or not.                                                                  | `false`                  |
| `ingress.pathType`    | Whatever [path type](https://kubernetes.io/docs/concepts/services-networking/ingress/#path-types) to use.                       | `ImplementationSpecific` |
| `ingress.hostname`    | Default host for the Ingress record.                                                                                            | `youtrack.local`         |
| `ingress.path`        | Default path for the Ingress record.                                                                                            | `/`                      |
| `ingress.annotations` | Additional annotations for the Ingress record. To enable certificate autogeneration, place the `cert-manager` annotations here. | `{}`                     |
| `ingress.extraPaths`  | List of extra paths to add to the Ingress record.                                                                               | `[]`                     |
| `ingress.extraRules`  | Any extra rules to add to the Ingress record.                                                                                   | `[]`                     |

### Pod Disruption Budget

| Name                                 | Description                                                                                                                                             | Value   |
| ------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `podDisruptionBudget.enabled`        | Enables the use of a `PodDisruptionBudget`. Read more in the [Kubernetes documentation](https://kubernetes.io/docs/concepts/workloads/pods/disruptions) | `false` |
| `podDisruptionBudget.minAvailable`   | Minimum number (or percentage) of pods that should be remained scheduled                                                                                | `1`     |
| `podDisruptionBudget.maxUnavailable` | Maximum number (or percentage) of pods that maybe made unavaliable.                                                                                     | `nil`   |

### Subcharts


### JetBrains Hub

| Name                   | Description                                                                | Value   |
| ---------------------- | -------------------------------------------------------------------------- | ------- |
| `external.hub.enabled` | whether or not if the JetBrains Hub chart by Noelware should also be used. | `false` |
