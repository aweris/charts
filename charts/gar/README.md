gar
===
A Helm chart for Self Hosted Github Actions Runner

Current chart version is `0.1.0`

Source code can be found [here](https://github.com/aweris/github-actions-runner)

## Installation

### Add Helm repository

```shell
helm repo add aweris https://aweris.github.io/charts/
helm repo update
```

### Install chart

Create secret

```shell
kubectl create secret generic github-token --from-literal=GH_TOKEN=<PAT>
```

Create `values.yaml`

```yaml
runner:
  url: https://github.com/<your-repo-goes-here>
  labels:
    - foo
    - bar
  ghTokenSecret:
    key: GH_TOKEN
    name: github-token
```

Install chart

```shell
helm upgrade --install --values values.yaml runner aweris/gar
```

## Chart Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Affinity settings for pod assignment |
| dind.image.pullPolicy | string | `"Always"` | Image pull policy |
| dind.image.repository | string | `"docker"` | DinD image name |
| dind.image.tag | string | `"19.03-dind"` | DinD image tag |
| dind.resources | object | `{}` | [resources](#resources) |
| dind.securityContext | object | { privileged: true } | [securityContext](#securitycontext) |
| extraEnvs | list | `[]` | [extraEnvs](#extraenvs) |
| extraVolumeMounts | list | `[]` | [extraVolumeMounts](#extravolumemounts) |
| extraVolumes | list | `[]` | [extraVolumes](#extravolumes) |
| fullnameOverride | string | `""` | String to fully override gar.fullname template with a string |
| nameOverride | string | `""` | String to partially override gar.fullname template with a string (will prepend the release name) |
| nodeSelector | object | `{}` | Node labels for pod assignment |
| podSecurityContext | object | `{}` | [podSecurityContext](#podsecuritycontext) |
| replicaCount | int | `1` | Number of replicas of the runner pod |
| runner.additionalArgs | list | `[]` | [runner.additionalArgs](#runneradditionalargs) |
| runner.ghTokenSecret | object | `{}` | [runner.ghTokenSecret](#runnerghtokensecret) |
| runner.image.pullPolicy | string | `"Always"` | Image pull policy |
| runner.image.repository | string | `"aweris/gar"` | Github actions runner image name |
| runner.image.tag | string | `"2.169.1"` | Github actions runner image tag |
| runner.labels | list | `[]` | Custom labels for the runner |
| runner.name | string | `nil` | Name of the runner. If not set, new name generated |
| runner.resources | object | `{}` | [resources](#resources) |
| runner.securityContext | object | `{}` | [securityContext](#securitycontext) |
| runner.url | string | `nil` | Repository or Organization url for runner registration |
| runner.workdir | string | `"/gar/work"` | Working directory for the runner |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `nil` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| tolerations | list | `[]` | Toleration labels for pod assignment |

## Configuration Blocks

#### runner.ghTokenSecret

Secret name and key contains Personal access token for authenticate to GitHub

```yaml
ghTokenSecret:
  key: GH_TOKEN
  name: secret-resource
```

#### runner.additionalArgs

Additional arguments to be passed at gar's binary

```yaml
additionalArgs:
  - "--replace=false"
  - "--once"
```

#### resources

The [resources] to allocate for container. We usually recommend not to specify default resources and to leave this as a conscious
choice for the user. This also increases chances charts run on environments with little
resources, such as Minikube. For more info [Managing Resources for Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)

```yaml
resources:
  limits:
    cpu: 100m
    memory: 128Mi
  requests:
    cpu: 100m
    memory: 128Mi
```

#### securityContext

For more info [Security Context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/)

```yaml
securityContext:
  capabilities:
    drop:
    - ALL
  readOnlyRootFilesystem: true
  runAsNonRoot: true
  runAsUser: 1000
```

#### podSecurityContext

For more info [Set the security context for a Pod](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod)

```yaml
podSecurityContext:
  fsGroup: 2000
```

#### extraEnvs

Additional environment variables to set

```yaml
extraEnvs:
  - name: FOO
    valueFrom:
      secretKeyRef:
        key: FOO
        name: secret-resource
```

#### extraVolumeMounts

Additional volume mounts.

```yaml
extraVolumeMounts:
  - name: extra-vol
    mountPath: /var/lib/vol
    subPath: ""
    readOnly: true
```

#### extraVolumes

Additional volumes.

```yaml
extraVolumes:
  - name: extra-vol
    emptyDir: {}
  - name: secret-files
    secret:
      secretName: very-secret
```
