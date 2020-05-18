gar
===
A Helm chart for Self Hosted Github Actions Runner

Current chart version is `0.1.1`

Source code can be found [here](https://github.com/aweris/github-actions-runner)

## Installation

### Add Helm repository

```shell
helm repo add aweris https://aweris.github.io/charts/
helm repo update
```

### Create Github Authentication Secret

- Create secret using personal access token

```shell
kubectl create secret generic github-auth --from-literal=pat=<PAT>
```


- Create secret using Github application credentials

```
kubectl create secret generic  github-auth --from-literal=appId=<Github Application ID> \
                                           --from-literal=installationId=<Github Application Installation ID> \
                                           --from-file=privateKey=<Path for the private key file>
```

### Install chart

Create `values.yaml`

```yaml
runner:
  url: https://github.com/<your-repo-goes-here>
  labels:
    - foo
    - bar
  ghAuth:
    existingSecret: github-auth
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
| dind.resources | object | `{}` | [Resources](#resources) |
| dind.securityContext | object | { privileged: true } | [Security Context](#security-context) |
| extraEnvs | list | `[]` | [Extra Environment Variables](#extra-environment-variables) |
| extraVolumeMounts | list | `[]` | [Extra Volume Mounts](#extra-volume-mounts) |
| extraVolumes | list | `[]` | [Extra Volumes](#extra-volumes) |
| fullnameOverride | string | `""` | String to fully override gar.fullname template with a string |
| nameOverride | string | `""` | String to partially override gar.fullname template with a string (will prepend the release name) |
| nodeSelector | object | `{}` | Node labels for pod assignment |
| podSecurityContext | object | `{}` | [Pod Security Context](#pod-security-context) |
| replicaCount | int | `1` | Number of replicas of the runner pod |
| runner.additionalArgs | list | `[]` | [Additional Arguments](#additional-arguments) |
| runner.ghAuth.appId | string | `nil` | Github Application ID. Value will overridden by `runner.ghAuth.existingSecret` |
| runner.ghAuth.existingSecret | string | `""` | Secret contains [Github authentication](#create-github-authentication-secret) for runner registration |
| runner.ghAuth.installationId | string | `nil` | Github application installation ID. Value will overridden by `runner.ghAuth.existingSecret` |
| runner.ghAuth.pat | string | `""` | Personal access token for Github Authentication. Value will overridden by `runner.ghAuth.existingSecret` |
| runner.ghAuth.privateKey | string | `""` | Private key for authenticate as Github application. Value will overridden by `runner.ghAuth.existingSecret` |
| runner.image.pullPolicy | string | `"Always"` | Image pull policy |
| runner.image.repository | string | `"aweris/gar"` | Github actions runner image name |
| runner.image.tag | string | `"2.262.1"` | Github actions runner image tag |
| runner.labels | list | `[]` | Custom labels for the runner |
| runner.name | string | `nil` | Name of the runner. If not set, new name generated |
| runner.resources | object | `{}` | [Resources](#resources) |
| runner.securityContext | object | `{}` | [Security Context](#security-context) |
| runner.url | string | `nil` | Repository or Organization url for runner registration |
| runner.workdir | string | `"/home/runner/work"` | Working directory for the runner |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `nil` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| tolerations | list | `[]` | Toleration labels for pod assignment |

## Configuration Blocks

#### Additional Arguments

Additional arguments to be passed at gar's binary

```yaml
additionalArgs:
  - "--replace=false"
  - "--once"
```

#### Resources

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

#### Security Context

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

#### Pod Security Context

For more info [Set the security context for a Pod](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod)

```yaml
podSecurityContext:
  fsGroup: 2000
```

#### Extra Environment Variables

Additional environment variables to set

```yaml
extraEnvs:
  - name: FOO
    valueFrom:
      secretKeyRef:
        key: FOO
        name: secret-resource
```

#### Extra Volume Mounts

Additional volume mounts.

```yaml
extraVolumeMounts:
  - name: extra-vol
    mountPath: /var/lib/vol
    subPath: ""
    readOnly: true
```

#### Extra Volumes

Additional volumes.

```yaml
extraVolumes:
  - name: extra-vol
    emptyDir: {}
  - name: secret-files
    secret:
      secretName: very-secret
```
