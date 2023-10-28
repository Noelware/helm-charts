# 🐻‍❄️🔮 noelware/bazel-remote-cache
> *[Helm](https://helm.sh) chart for [buchgr/bazel-remote-cache](https://hub.docker.com/r/buchgr/bazel-remote-cache)*

This is Noelware's Helm chart for the [buchgr/bazel-remote-cache](https://hub.docker.com/r/buchgr/bazel-remote-cache) Docker image. Since we use Bazel to provide remote caching for CI and our team, this is a must need in our stack.

## Requirements
* Kubernetes v1.24+
* Helm 3.10+

## Installation
```shell
$ helm repo add noelware https://charts.noelware.org/~/noelware
$ helm install bazel-remote-cache noelware/bazel-remote-cache
```

## Parameters

### Global Parameters

| Name                              | Description                                                                                                                                                                                              | Value           |
| --------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------- |
| `global.replicas`                 | Amount of replicas to spawn                                                                                                                                                                              | `1`             |
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

| Name               | Description                                                                                                     | Value                       |
| ------------------ | --------------------------------------------------------------------------------------------------------------- | --------------------------- |
| `image.pullPolicy` | [Pull policy](https://kubernetes.io/docs/concepts/containers/images/#image-pull-policy) when pulling the image. | `""`                        |
| `image.registry`   | Registry URL to point to. For Docker Hub, use an empty string.                                                  | `""`                        |
| `image.image`      | Image name.                                                                                                     | `buchgr/bazel-remote-cache` |
| `image.tag`        | The tag of the image. Keep this as a empty string if you wish to use the default app's version.                 | `""`                        |
| `image.digest`     | Digest in the form of `<alg>:<hex>`, this will replace the `image.tag` property if this is not empty.           | `""`                        |

### Service Account Parameters

| Name                         | Description                                                                                | Value  |
| ---------------------------- | ------------------------------------------------------------------------------------------ | ------ |
| `serviceAccount.create`      | Whether or not if the service account should be created for this Helm installation.        | `true` |
| `serviceAccount.annotations` | Any additional annotations to append to this ServiceAccount                                | `{}`   |
| `serviceAccount.name`        | The name of the service account, this will be the Helm installation name if this is empty. | `""`   |

### Configuration Parameters

| Name                     | Description                                                                           | Value    |
| ------------------------ | ------------------------------------------------------------------------------------- | -------- |
| `config.existingMapName` | An existing ConfigMap that provides the configuration                                 | `""`     |
| `config.configKey`       | The configuration key to use in the ConfigMap, defaults to `config.yml`               | `""`     |
| `config.mapName`         | The name of the ConfigMap to create or update if `config.existingMapName` is not set. | `config` |

### Service Parameters

Parameters to configure a [Kubernetes service](https://kubernetes.io/docs/concepts/services-networking/service/) to allow external connections to your
Bazel Remote Cache instance

| Name                     | Description                                                                                                                    | Value       |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------------------ | ----------- |
| `service.clusterIP`      | IP to use for the cluster IP if `type` is `ClusterIP`.                                                                         | `""`        |
| `service.enabled`        | Whether or not if a Kubernetes service should be enabled.                                                                      | `true`      |
| `service.type`           | The [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types) to use. | `ClusterIP` |
| `service.selectorLabels` | Selector to apply this Kubernetes service to                                                                                   | `{}`        |
| `service.ports.http`     | HTTP port to listen on                                                                                                         | `8080`      |
| `service.ports.grpc`     | gRPC port to listen on                                                                                                         | `""`        |

### Ingress

[Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress) configuration.

| Name                  | Description                                                                                                                     | Value                    |
| --------------------- | ------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `ingress.className`   | Ingress class name to use.                                                                                                      | `""`                     |
| `ingress.enabled`     | Whether if Ingress record generation should be enabled or not.                                                                  | `false`                  |
| `ingress.pathType`    | Whatever [path type](https://kubernetes.io/docs/concepts/services-networking/ingress/#path-types) to use.                       | `ImplementationSpecific` |
| `ingress.hostname`    | Default host for the Ingress record.                                                                                            | `bazel-remote.local`     |
| `ingress.path`        | Default path for the Ingress record.                                                                                            | `/`                      |
| `ingress.annotations` | Additional annotations for the Ingress record. To enable certificate autogeneration, place the `cert-manager` annotations here. | `{}`                     |
| `ingress.extraHosts`  | List of extra hosts to add to the Ingress record.                                                                               | `[]`                     |
| `ingress.extraPaths`  | List of extra paths to add to the Ingress record.                                                                               | `[]`                     |
| `ingress.extraRules`  | Any extra rules to add to the Ingress record.                                                                                   | `[]`                     |
