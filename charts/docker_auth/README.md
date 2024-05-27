# 🐻‍❄️🔮 noelware/docker-auth
**noelware/docker-auth** is a maintained Helm chart that uses the [`cesanta/docker_auth`](https://hub.docker.com/r/cesanta/docker_auth) image.

## Requirements
* Kubernetes v1.26 or higher
* Helm 3.12 or higher

## Installation
```shell
$ helm repo add noelware https://charts.noelware.org/~/noelware
$ helm install docker-auth noelware/docker-auth
```

## Parameters

### Global Parameters

Contains any global parameters that will affected all objects in the `cesanta/docker_auth` Helm chart.

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

| Name               | Description                                                                                                     | Value                 |
| ------------------ | --------------------------------------------------------------------------------------------------------------- | --------------------- |
| `image.pullPolicy` | [Pull policy](https://kubernetes.io/docs/concepts/containers/images/#image-pull-policy) when pulling the image. | `""`                  |
| `image.registry`   | Registry URL to point to. For Docker Hub, use an empty string.                                                  | `""`                  |
| `image.image`      | Image name.                                                                                                     | `cesanta/docker_auth` |
| `image.tag`        | The tag of the image. Keep this as a empty string if you wish to use the default app's version.                 | `""`                  |
| `image.digest`     | Digest in the form of `<alg>:<hex>`, this will replace the `image.tag` property if this is not empty.           | `""`                  |

### Service Account Parameters

| Name                         | Description                                                                                | Value  |
| ---------------------------- | ------------------------------------------------------------------------------------------ | ------ |
| `serviceAccount.create`      | Whether or not if the service account should be created for this Helm installation.        | `true` |
| `serviceAccount.annotations` | Any additional annotations to append to this ServiceAccount                                | `{}`   |
| `serviceAccount.name`        | The name of the service account, this will be the Helm installation name if this is empty. | `""`   |

### Pod Disruption Budget

| Name                                 | Description                                                                                                                                             | Value   |
| ------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `podDisruptionBudget.enabled`        | Enables the use of a `PodDisruptionBudget`. Read more in the [Kubernetes documentation](https://kubernetes.io/docs/concepts/workloads/pods/disruptions) | `false` |
| `podDisruptionBudget.minAvailable`   | Minimum number (or percentage) of pods that should be remained scheduled                                                                                | `1`     |
| `podDisruptionBudget.maxUnavailable` | Maximum number (or percentage) of pods that maybe made unavaliable.                                                                                     | `nil`   |

### Service Parameters

Parameters to configure a [Kubernetes service](https://kubernetes.io/docs/concepts/services-networking/service/) to allow external connections to your
Ume instance.

| Name                     | Description                                                                                                                                                        | Value       |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------- |
| `service.port`           | Port number to listen to.                                                                                                                                          | `8989`      |
| `service.clusterIP`      | IP to use for the cluster IP if `type` is `ClusterIP`.                                                                                                             | `""`        |
| `service.enabled`        | Whether or not if a Kubernetes service should be enabled.                                                                                                          | `true`      |
| `service.type`           | The [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types) to use.                                     | `ClusterIP` |
| `service.selectorLabels` | Selector to apply this Kubernetes service to                                                                                                                       | `{}`        |
| `service.externalName`   | The external name if `service.type` == `"ExternalName"`                                                                                                            | `nil`       |
| `service.loadBalancer`   | Load balancer configuration if `service.type` == `"LoadBalanacer"`                                                                                                 | `{}`        |
| `service.nodePort`       | Node port to expose, refer to the [Kubernetes documentation](https://kubernetes.io/docs/concepts/services-networking/service/#type-nodeport) for more information. | `""`        |

### Ingress

[Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress) configuration.

| Name                  | Description                                                                                                                     | Value                    |
| --------------------- | ------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `ingress.host`        | Hostname to your `docker_auth` instance                                                                                         | `docker-auth.local`      |
| `ingress.className`   | Ingress class name to use.                                                                                                      | `""`                     |
| `ingress.enabled`     | Whether if Ingress record generation should be enabled or not.                                                                  | `false`                  |
| `ingress.pathType`    | Whatever [path type](https://kubernetes.io/docs/concepts/services-networking/ingress/#path-types) to use.                       | `ImplementationSpecific` |
| `ingress.path`        | Default path for the Ingress record.                                                                                            | `/`                      |
| `ingress.annotations` | Additional annotations for the Ingress record. To enable certificate autogeneration, place the `cert-manager` annotations here. | `{}`                     |
| `ingress.extraRules`  | Any extra rules to add to the Ingress record.                                                                                   | `[]`                     |
| `ingress.extraTLS`    | Any TLS records to include in the ingress record.                                                                               | `[]`                     |

### ConfigMap

| Name                 | Description                                                      | Value |
| -------------------- | ---------------------------------------------------------------- | ----- |
| `config.existingMap` | Name of an existing `ConfigMap` that exposes a `hazel.hcl` block | `""`  |

### TLS

Describes how TLS should work when building the cert bundle for Docker Registry as token
servers require a TLS bundle to work.

| Name                                        | Description                                                                                                                                                                                                                                                                                                                              | Value               |
| ------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------- |
| `tls.enabled`                               | whether or not if TLS is enabled.                                                                                                                                                                                                                                                                                                        | `true`              |
| `tls.selfSigned`                            | whether or not to create a self-signed certidicate via Helm's [`genCA`](https://helm.sh/docs/chart_template_guide/function_list/#genca) Go template function. If `values.tls.certManager.enable` and `values.tls.selfSigned` is true, it'll create a self-signed [`Certificate`](https://cert-manager.io/docs/configuration/selfsigned/) | `false`             |
| `tls.certManager.enable`                    | whether or not to use `cert-manager` for creating a self-signed certificate.                                                                                                                                                                                                                                                             | `false`             |
| `tls.certManager.existingCertificate`       | if an existing `cert-manager.io/v1@Certificate` is used, then reference this (and optionally `tls.certManager.existingCertificateSecret`)                                                                                                                                                                                                | `""`                |
| `tls.certManager.existingCertificateSecret` | Secret name of the existing certificate. If this is empty and `tls.certManager.existingCertificate` exists, then it'll be `{tls.certManager.existingCertificate}-tls`.                                                                                                                                                                   | `""`                |
| `tls.certManager.issuerRef.name`            | name of the issuer to use                                                                                                                                                                                                                                                                                                                | `selfsigned-issuer` |
| `tls.certManager.issuerRef.kind`            | (optional) external issuer (`Issuer` = locally namespaced; `ClusterIssuer` = cluster-wide)                                                                                                                                                                                                                                               | `Issuer`            |
| `tls.certManager.issuerRef.group`           | (optional) external issuer's group                                                                                                                                                                                                                                                                                                       | `cert-manager.io`   |
| `tls.secret.existingSecret`                 | reference to an existing `Secret` that has `ca.crt` and `ca.key` data pairs.                                                                                                                                                                                                                                                             | `""`                |
| `tls.secret.crt`                            | the `ca.crt` value to use                                                                                                                                                                                                                                                                                                                | `""`                |
| `tls.secret.key`                            | the `ca.key` value to use.                                                                                                                                                                                                                                                                                                               | `""`                |
