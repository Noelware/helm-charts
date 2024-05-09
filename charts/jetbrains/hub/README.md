# 🐻‍❄️🔮 noelware/jetbrains-hub
**noelware/jetbrains-hub** is our Helm chart for [JetBrains Hub](https://jetbrains.com/hub). This can be to be installed alongside [noelware/youtrack](https://charts.noelware.org/~/noelware/youtrack) if wanted.

## Requirements
* Kubernetes v1.26 or higher
* Helm 3.12 or higher

## Installation
```shell
$ helm repo add noelware https://charts.noelware.org/~/noelware
$ helm install hub noelware/jetbrains-hub
```

## Parameters

### Global Parameters

Contains any global parameters that will affected all objects in the JetBrains Hub Helm chart.

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
| `global.baseUrl`                  | Base URL to use when configuring the Hub server                                                                                                                                                          | `""`            |

### Docker Image Parameters

Parameters to modify the Docker image that is ran.

| Name               | Description                                                                                                     | Value           |
| ------------------ | --------------------------------------------------------------------------------------------------------------- | --------------- |
| `image.pullPolicy` | [Pull policy](https://kubernetes.io/docs/concepts/containers/images/#image-pull-policy) when pulling the image. | `""`            |
| `image.registry`   | Registry URL to point to. For Docker Hub, use an empty string.                                                  | `""`            |
| `image.image`      | Image name.                                                                                                     | `jetbrains/hub` |
| `image.tag`        | The tag of the image. Keep this as a empty string if you wish to use the default app's version.                 | `""`            |
| `image.digest`     | Digest in the form of `<alg>:<hex>`, this will replace the `image.tag` property if this is not empty.           | `""`            |

### Service Account Parameters

| Name                         | Description                                                                                | Value  |
| ---------------------------- | ------------------------------------------------------------------------------------------ | ------ |
| `serviceAccount.create`      | Whether or not if the service account should be created for this Helm installation.        | `true` |
| `serviceAccount.annotations` | Any additional annotations to append to this ServiceAccount                                | `{}`   |
| `serviceAccount.name`        | The name of the service account, this will be the Helm installation name if this is empty. | `""`   |

### Deployment Parameters

| Name                        | Description                                                                                                                                                   | Value         |
| --------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------- |
| `deployment.configureFlags` | List of [JVM configuration flags](https://www.jetbrains.com/help/hub/configure-jvm-options.html) to use when configuring the installation of your Hub server. | `-J-Xmx1024m` |
| `deployment.strategy`       | The [Deployment strategy](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#strategy) when creating the deployment.                       | `{}`          |

### Persistence

| Name                       | Description                                                    | Value               |
| -------------------------- | -------------------------------------------------------------- | ------------------- |
| `persistence.accessModes`  | List of access modes when creating the Persistent Volume Claim | `["ReadWriteOnce"]` |
| `persistence.storageClass` | StorageClass for the PVC creation                              | `""`                |

### Backups Persistence

| Name                                | Description                                                                                                                                                                                                                                  | Value  |
| ----------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| `persistence.backups.existingClaim` | If any existing [`PersistentVolumeClaim`](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#persistentvolumeclaims) exists for `hub-backups`, then this can be referenced as the PVC and no new object will be created for it. | `""`   |
| `persistence.backups.selector`      | [Selectors](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#selector) to further filter the set of volumes.                                                                                                                  | `{}`   |
| `persistence.backups.annotations`   | Mapping of the annotations that will be merged with existing annotations for the PVC creation                                                                                                                                                | `{}`   |
| `persistence.backups.size`          | Storage request size for the PVC                                                                                                                                                                                                             | `10Gi` |

### Data Persistence

| Name                             | Description                                                                                                                                                                                                                                  | Value  |
| -------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| `persistence.data.existingClaim` | If any existing [`PersistentVolumeClaim`](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#persistentvolumeclaims) exists for `hub-backups`, then this can be referenced as the PVC and no new object will be created for it. | `""`   |
| `persistence.data.selector`      | [Selectors](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#selector) to further filter the set of volumes.                                                                                                                  | `{}`   |
| `persistence.data.annotations`   | Mapping of the annotations that will be merged with existing annotations for the PVC creation                                                                                                                                                | `{}`   |
| `persistence.data.size`          | Storage request size for the PVC                                                                                                                                                                                                             | `10Gi` |

### Logs Persistence

| Name                             | Description                                                                                                                                                                                                                               | Value |
| -------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----- |
| `persistence.logs.existingClaim` | If any existing [`PersistentVolumeClaim`](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#persistentvolumeclaims) exists for `hub-logs`, then this can be referenced as the PVC and no new object will be created for it. | `""`  |
| `persistence.logs.selector`      | [Selectors](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#selector) to further filter the set of volumes.                                                                                                               | `{}`  |
| `persistence.logs.annotations`   | Mapping of the annotations that will be merged with existing annotations for the PVC creation                                                                                                                                             | `{}`  |
| `persistence.logs.size`          | Storage request size for the PVC                                                                                                                                                                                                          | `5Gi` |

### Configuration Persistence

| Name                             | Description                                                                                                                                                                                                                               | Value   |
| -------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `persistence.conf.existingClaim` | If any existing [`PersistentVolumeClaim`](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#persistentvolumeclaims) exists for `hub-conf`, then this can be referenced as the PVC and no new object will be created for it. | `""`    |
| `persistence.conf.selector`      | [Selectors](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#selector) to further filter the set of volumes.                                                                                                               | `{}`    |
| `persistence.conf.annotations`   | Mapping of the annotations that will be merged with existing annotations for the PVC creation                                                                                                                                             | `{}`    |
| `persistence.conf.size`          | Storage request size for the PVC                                                                                                                                                                                                          | `512Mi` |

### Service Parameters

Parameters to configure a [Kubernetes service](https://kubernetes.io/docs/concepts/services-networking/service/) to allow external connections to your
Hub instance.

| Name                     | Description                                                                                                                                                             | Value       |
| ------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| `service.clusterIP`      | IP to use for the cluster IP if `type` is `ClusterIP`.                                                                                                                  | `""`        |
| `service.enabled`        | Whether or not if a Kubernetes service should be enabled.                                                                                                               | `true`      |
| `service.type`           | The [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types) to use.                                          | `ClusterIP` |
| `service.selectorLabels` | Selector to apply this Kubernetes service to                                                                                                                            | `{}`        |
| `service.port`           | The port that Hub will listen on.                                                                                                                                       | `8080`      |
| `service.externalName`   | If `service.type` == `"ExternalName"`, then this would be set as [`spec.externalName`](https://kubernetes.io/docs/concepts/services-networking/service/#externalname)   | `""`        |
| `service.loadBalancer`   | If `service.type` == `"LoadBalancer"`, then this would be set as [`status.loadBalancer`](https://kubernetes.io/docs/concepts/services-networking/service/#loadbalancer) | `{}`        |

### Ingress

[Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress) configuration.

| Name                  | Description                                                                                                                     | Value                    |
| --------------------- | ------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `ingress.className`   | Ingress class name to use.                                                                                                      | `""`                     |
| `ingress.enabled`     | Whether if Ingress record generation should be enabled or not.                                                                  | `false`                  |
| `ingress.pathType`    | Whatever [path type](https://kubernetes.io/docs/concepts/services-networking/ingress/#path-types) to use.                       | `ImplementationSpecific` |
| `ingress.hostname`    | Default host for the Ingress record.                                                                                            | `hub.local`              |
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
