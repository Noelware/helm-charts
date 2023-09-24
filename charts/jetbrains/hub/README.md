# 🐻‍❄️🔮 noelware/jetbrains-hub
**noelware/jetbrains-hub** is our Helm chart for [JetBrains Hub](https://jetbrains.com/hub). This can be to be installed alongside [noelware/youtrack](https://charts.noelware.org/~/noelware/youtrack) if wanted.

## Requirements
* Kubernetes v1.24+
* Helm 3.10+

## Installation
```shell
$ helm repo add noelware https://charts.noelware.org/~/noelware
$ helm install hub noelware/jetbrains-hub
```

## Parameters

### Global Parameters

Contains any global parameters that will affected all objects in the `jetbrains-hub` Helm chart.

| Name                              | Description                                                                                                                                                                                              | Value           |
| --------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------- |
| `global.replicas`                 | Amount of replicas to spawn                                                                                                                                                                              | `1`             |
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

### Persistence Parameters

| Name                                | Description                                                                                                                                   | Value               |
| ----------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------- | ------------------- |
| `persistence.data.existingClaim`    | Existing PVC name to mount instead of the chart creating one.                                                                                 | `""`                |
| `persistence.data.storageClass`     | The storage class to use when creating the data's PVC.                                                                                        | `""`                |
| `persistence.data.annotations`      | Mapping of any extra annotations to append.                                                                                                   | `{}`                |
| `persistence.data.accessModes`      | List of [access modes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#access-modes) to use when creating the data PVC.       | `["ReadWriteMany"]` |
| `persistence.data.claimName`        | Name of the PVC to create, if `persistence.data.existingClaim` is not set to `true`.                                                          | `data`              |
| `persistence.data.selector`         | Mapping of the [selectors](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#selector) to filter when creating the data PVC.    | `{}`                |
| `persistence.data.size`             | Size of the PVC to provision.                                                                                                                 | `10Gi`              |
| `persistence.backups.existingClaim` | Existing PVC name to mount instead of the chart creating one.                                                                                 | `""`                |
| `persistence.backups.storageClass`  | The storage class to use when creating the backups PVC.                                                                                       | `""`                |
| `persistence.backups.annotations`   | Mapping of any extra annotations to append.                                                                                                   | `{}`                |
| `persistence.backups.accessModes`   | List of [access modes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#access-modes) to use when creating the backups PVC.    | `["ReadWriteMany"]` |
| `persistence.backups.claimName`     | Name of the PVC to create, if `persistence.data.existingClaim` is not set to `true`.                                                          | `backups`           |
| `persistence.backups.selector`      | Mapping of the [selectors](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#selector) to filter when creating the backups PVC. | `{}`                |
| `persistence.backups.size`          | Size of the PVC to provision.                                                                                                                 | `10Gi`              |
| `persistence.logs.existingClaim`    | Existing PVC name to mount instead of the chart creating one.                                                                                 | `""`                |
| `persistence.logs.storageClass`     | The storage class to use when creating the logs's PVC.                                                                                        | `""`                |
| `persistence.logs.annotations`      | Mapping of any extra annotations to append.                                                                                                   | `{}`                |
| `persistence.logs.accessModes`      | List of [access modes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#access-modes) to use when creating the logs PVC.       | `["ReadWriteMany"]` |
| `persistence.logs.claimName`        | Name of the PVC to create, if `persistence.data.existingClaim` is not set to `true`.                                                          | `logs`              |
| `persistence.logs.selector`         | Mapping of the [selectors](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#selector) to filter when creating the logs PVC.    | `{}`                |
| `persistence.logs.size`             | Size of the PVC to provision.                                                                                                                 | `5Gi`               |
| `persistence.conf.existingClaim`    | Existing PVC name to mount instead of the chart creating one.                                                                                 | `""`                |
| `persistence.conf.storageClass`     | The storage class to use when creating the conf's PVC.                                                                                        | `""`                |
| `persistence.conf.annotations`      | Mapping of any extra annotations to append.                                                                                                   | `{}`                |
| `persistence.conf.accessModes`      | List of [access modes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#access-modes) to use when creating the conf PVC.       | `["ReadWriteMany"]` |
| `persistence.conf.claimName`        | Name of the PVC to create, if `persistence.data.existingClaim` is not set to `true`.                                                          | `conf`              |
| `persistence.conf.selector`         | Mapping of the [selectors](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#selector) to filter when creating the conf PVC.    | `{}`                |
| `persistence.conf.size`             | Size of the PVC to provision.                                                                                                                 | `512Mi`             |

### Service Parameters

Parameters to configure a [Kubernetes service](https://kubernetes.io/docs/concepts/services-networking/service/) to allow external connections to your
JetBrains Hub instance.

| Name                     | Description                                                                                                                    | Value       |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------------------ | ----------- |
| `service.clusterIP`      | IP to use for the cluster IP if `type` is `ClusterIP`.                                                                         | `""`        |
| `service.enabled`        | Whether or not if a Kubernetes service should be enabled.                                                                      | `true`      |
| `service.type`           | The [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types) to use. | `ClusterIP` |
| `service.selectorLabels` | Selector to apply this Kubernetes service to                                                                                   | `{}`        |
| `service.port`           | The port that JetBrains Hub will listen on.                                                                                    | `8080`      |

### Configure Parameters

Parameters to use when configuring your JetBrains Hub installation. This will create a init container
that will append a mapping of all flags to passthrough.

| Name                | Description                                                                                      | Value                                                                             |
| ------------------- | ------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------- |
| `configure.enabled` | Whether of not the init container should be spawned.                                             | `true`                                                                            |
| `configure.flags`   | A list of flags to inject into the `hub configure` command. This can be used as a Helm template. | `-J-Dorg.eclipse.jetty.server.Request.maxFormKeys=10000 -J-Xmx1024m -no-browser
` |

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
| `ingress.extraHosts`  | List of extra hosts to add to the Ingress record.                                                                               | `[]`                     |
| `ingress.extraPaths`  | List of extra paths to add to the Ingress record.                                                                               | `[]`                     |
| `ingress.extraRules`  | Any extra rules to add to the Ingress record.                                                                                   | `[]`                     |
