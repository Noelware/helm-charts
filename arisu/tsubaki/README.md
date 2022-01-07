# Tsubaki Helm Chart
This helm chart is to configure and run the Tsubaki [Docker image](https://hub.docker.com/r/arisuland/tsubaki)!

- [**Requirements**](#requirements)
- [**Installation**](#installation)
- [**Configuration**](#configuration)

## Requirements
- **Kubernetes** >=v1.22
- [**Helm**](https://helm.sh) >=3.x

## Installation
### 1. Pull in our repository
```sh
$ helm repo add https://charts.floof.gay/noelware
```

### 2. Install the chart
```sh
$ helm install tsubaki arisu/tsubaki
```

## Configuration

| Name | Description | Default |
| ---- | ----------- | ------- |
| **`replicaCount`** | How many replicas should the StatefulSet should use | 2 |
| **`image.registry`** | The registry to use when pulling down the image. | [`docker.io`](https://hub.docker.com) |
| **`image.repository`** | The repository to pull from | [`arisuland/tsubaki`](https://hub.docker.com/r/arisuland/tsubaki) |
| **`image.tag`** | Returns the tag version to use. | `{chart-version}` |
| **`image.pullPolicy`** | Returns the pull policy to use. | `IfNotPresent` |
| **`image.pullSecrets`** | A list of pull secrets to use, if any. | `[]` |
| **`nameOverride`** | 	Overrides the chart name for resources. If not set the name will default to .Chart.Name | `""` |
| **`fullNameOverride`** | Overrides the full name of the resources. If not set the name will default to " `.Release.Name` - `.Values.nameOverride or Chart.Name` " | `""` |
| **`serviceAccount.create`** | Specifies whether a service account should be created | `true` |
| **`serviceAccount.annotations`** | Annotations to add to the service account | `{}` |
| **`serviceAccount.name`** | The name of the service account to use. If not set and create is true, a name is generated using the fullname template | `""`
| **`podAnnotations`** | List of annotations to add on the pods. | `{}` |
| **`podSecurityContext`** | Sets up the [security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod) for each Tsubaki-managed pod. | `{}` |
| **`securityContext`** | Sets up the [security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod) for the container. | `{}` |
| **`service.type`** | Returns the service type to use when creating the service. | `ClusterIP` |
| **`service.port`** | Returns the port to expose when the service is created. | `17093` |
| **`service.loadBalancerIP`** | Returns the load balancer IP to use. | `""` |
| **`service.nodePort`** | Returns the node port to expose. | `""` |
| **`service.labels`** | Extra labels to add to the service. | `{}` |
| **`service.annotations`** | Extra annotations to add to the service. | `{}` |
| **`ingress.enabled`** | Implements a ingress class to expost Tsubaki outside of the cluster. | `false` |
| **`ingress.className`** | Returns the ingress class to use. | `""` |
| **`ingress.annotations`** | Extra annotations to add to the ingress. | `{}` |
| **`ingress.hosts`** | A list of hosts to expose. | See [values.yaml](./values.yaml) |
| **`ingress.tls`** | A list of TLS certificates for the ingress. | `[]` |
| **`resources`** | Allows you to set the [resources](https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/) for the StatefulSet | See [values.yaml](./values.yaml) |
| **`autoscaling.enabled`** | Implements a [HorizontalPodAutoscaler](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/) object for autoscaling. | `false`
| **`autoscaling.minReplicas`** | Minimum of replicas to use for the HPA. | `1` |
| **`autoscaling.maxReplicas`** | Maximum of replicas to use for the HPA. | `1` |
| **`autoscaling.targetCPUUtilizationPercentage`** | The CPU utilizing percentage to use for scaling. | `80%` |
| **`autoscaling.targetMemoryUtilizationPercentage`** | The memory utilizing percentage to use for scaling. | `80%` |
| **`nodeSelector`** | Configures a [NodeSelector](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#nodeselector) to target specific nodes to this Tsubaki instance. | `{}` |
| **`tolerations`** | Configures [tolerations](https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/) | `[]` |
| **`affinity`** | Configures [affinity](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity) | `{}` |
| **`configs`** | List of configuration files (`config.yml`, `.env`) to implement into a ConfigMap. | See [values.yaml](./values.yaml) |
| **`readinessProbe`** | Adds a readiness probe object into the StatefulSet object. | See [values.yaml](./values.yaml) |
| **`readinessProbe.failureThreshold`** | When a probe fails, Kubernetes will try failureThreshold times before giving up. Giving up in case of liveness probe means restarting the container. In case of readiness probe the Pod will be marked Unready. | `3` |
| **`readinessProbe.initialDelaySeconds`** | Number of seconds after the container has started before liveness or readiness probes are initiated | `10` |
| **`readinessProbe.periodSeconds`** | How often (in seconds) to perform the probe. | `10` |
| **`readinessProbe.successThreshold`** | Minimum consecutive successes for the probe to be considered successful after having failed. | `3` |
| **`readinessProbe.timeoutSeconds`** | Number of seconds after which the probe times out | `5` |
| **`livenessProbe`** | Adds a liveness probe object into the StatefulSet object. | See [values.yaml](./values.yaml) |
| **`livenessProbe.failureThreshold`** | When a probe fails, Kubernetes will try failureThreshold times before giving up. Giving up in case of liveness probe means restarting the container. In case of readiness probe the Pod will be marked Unready. | `3` |
| **`livenessProbe.initialDelaySeconds`** | Number of seconds after the container has started before liveness or readiness probes are initiated | `10` |
| **`livenessProbe.periodSeconds`** | How often (in seconds) to perform the probe. | `10` |
| **`livenessProbe.successThreshold`** | Minimum consecutive successes for the probe to be considered successful after having failed. | `3` |
| **`livenessProbe.timeoutSeconds`** | Number of seconds after which the probe times out | `5` |
