# argocd-agent-principal

![Version: 0.2.0](https://img.shields.io/badge/Version-0.2.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v0.8.1](https://img.shields.io/badge/AppVersion-v0.8.1-informational?style=flat-square)

Helm chart for the ArgoCD Agent Principal component

**Homepage:** <https://github.com/argoproj-labs/argocd-agent>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Argo Project Maintainers |  | <https://github.com/argoproj-labs/argocd-agent> |

## Source Code

* <https://github.com/argoproj-labs/argocd-agent>

## Requirements

Kubernetes: `>=1.24.0-0`

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Affinity rules for pod scheduling |
| automountServiceAccountToken | bool | `true` | Automount API credentials for the Service Account into the pod. |
| deploymentAnnotations | object | `{}` | Annotations for the Deployment |
| dnsConfig | object | `{}` | DNS config for the Pod (only honored when dnsPolicy is "None") |
| dnsPolicy | string | `""` | DNS policy for the Pod (e.g. ClusterFirst, None) |
| extraEnv | list | `[]` |  |
| extraEnvVarsCM | list | `[]` |  |
| extraEnvVarsSecret | list | `[]` |  |
| extraVolumeMounts | list | `[]` |  |
| extraVolumes | list | `[]` |  |
| fullnameOverride | string | `""` | Override the full resource name |
| hostAliases | list | `[]` | Host aliases injected into /etc/hosts |
| image.pullPolicy | string | `"IfNotPresent"` | Image pull policy |
| image.repository | string | `"ghcr.io/argoproj-labs/argocd-agent/argocd-agent"` | Image repository |
| image.tag | string | `""` | Image tag |
| imagePullSecrets | list | `[]` | Image pull secrets |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"argocd-agent-principal.example.com"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"Prefix"` |  |
| ingress.tls | list | `[]` |  |
| nameOverride | string | `""` | Override the chart name |
| namespaceOverride | string | `""` | Override namespace to deploy the agent into. Leave empty to use the release namespace. |
| networkPolicy.customIngressRules | list | `[]` | Fully replace the generated ingress rules with a custom list. Useful when the built-in grpcIngress/redisProxyIngress/monitoring pattern does not fit. When set, all other ingress knobs above are ignored. |
| networkPolicy.egress | list | `[]` | Egress rules. When non-empty, "Egress" is added to policyTypes. |
| networkPolicy.enabled | bool | `false` | Whether to create a NetworkPolicy for the principal |
| networkPolicy.extraIngress | list | `[]` | Additional ingress rules appended to the generated NetworkPolicy. Each entry must be a valid NetworkPolicyIngressRule. |
| networkPolicy.extraPolicies | object | `{}` | Additional standalone NetworkPolicy resources. The map key becomes the name suffix (<fullname>-<key>); the value is the spec. Useful for layering per-tenant/per-source rules without forking the chart. |
| networkPolicy.grpcIngress | object | `{"from":[]}` | Ingress rule for the gRPC principal port (8443). `from` is a list of NetworkPolicyPeer entries. Leave empty to allow from anywhere — which is the right default when agents live outside this cluster and reach principal via LoadBalancer / Ingress / Gateway. For in-cluster agents or ingress-terminated setups, restrict to specific peers. |
| networkPolicy.monitoringNamespace | string | `"monitoring"` | Namespace label value for monitoring namespace (used for metrics/healthz ingress) |
| networkPolicy.redisProxyIngress | object | `{"from":[{"podSelector":{"matchLabels":{"app.kubernetes.io/part-of":"argocd"}}}]}` | Ingress rule for the Redis proxy port (6379). Defaults to allowing any pod labeled app.kubernetes.io/part-of=argocd within the cluster. |
| networkPolicy.resourceProxyIngress | object | `{"from":[]}` | Ingress rule for the Resource proxy port (9090). Applied only when service.resourceProxy.enabled is true. Empty = allow any source. |
| nodeSelector | object | `{}` | Node selector for scheduling the agent Pod. |
| params.allowedNamespaces | string | `""` | Comma-separated list of namespaces to watch (supports shell-style wildcards) |
| params.auth | string | `"mtls:CN=([^,]+)"` | Authentication method. Format: <method>:<config> Examples:   "mtls:CN=([^,]+)"   "userpass:/app/config/userpass/passwd"   "header:x-forwarded-client-cert:^.*URI=spiffe://[^/]+/ns/[^/]+/sa/([^,;]+)" |
| params.destinationBasedMapping | string | `"false"` | Use destination-based mapping (route apps to agents via spec.destination.name) |
| params.eventProcessors | string | `"10"` | Number of concurrent event processors |
| params.healthzPort | string | `"8003"` | Health check server port |
| params.jwt.allowGenerate | string | `"false"` | Allow the principal to auto-generate JWT signing key (dev only) |
| params.jwt.keyPath | string | `""` | Path to the JWT signing key (overrides secretName if set) |
| params.jwt.secretName | string | `"argocd-agent-jwt"` | Name of the secret containing the JWT signing key |
| params.keepAliveMinInterval | string | `"0"` | Drop agent connections that send keepalive pings more often than this interval |
| params.labelSelector | string | `""` | Kubernetes label selector to restrict which resources the principal watches. Used in hybrid architectures where a traditional app-controller coexists with the principal. |
| params.listenHost | string | `""` | Interface address to listen on. Empty string binds to all interfaces, which is the correct default when the gRPC service is exposed through a Kubernetes Service (LoadBalancer / NodePort / Ingress) and agents connect from outside the pod network. Use "127.0.0.1" only in service-mesh or mTLS-sidecar deployments where another local process terminates TLS — in those topologies binding to localhost prevents direct pod traffic. |
| params.listenPort | string | `"8443"` | gRPC server listen port |
| params.logFormat | string | `"text"` | Log format: text or json |
| params.logLevel | string | `"info"` | Log level: trace, debug, info, warn, error |
| params.metricsPort | string | `"8000"` | Metrics server port |
| params.namespace | string | `"argocd"` | Namespace the principal operates in |
| params.namespaceCreate.enable | string | `"false"` | Allow the principal to create namespaces for agents |
| params.namespaceCreate.labels | string | `""` | Labels to apply to created namespaces (comma-separated key=value pairs) |
| params.namespaceCreate.pattern | string | `""` | Regexp to restrict names of created namespaces |
| params.pprofPort | string | `"0"` | Port for pprof server (0 = disabled) |
| params.redis.caPath | string | `"/app/config/redis-tls/ca.crt"` | Path to CA certificate for verifying Redis TLS certificate |
| params.redis.caSecretName | string | `"argocd-redis-tls"` | Secret name containing CA certificate for verifying Redis TLS certificate |
| params.redis.compressionType | string | `"gzip"` | Compression type for Redis connection |
| params.redis.proxyServerTls.certPath | string | `"/app/config/redis-proxy-server-tls/tls.crt"` | Path to TLS certificate for Redis proxy server |
| params.redis.proxyServerTls.keyPath | string | `"/app/config/redis-proxy-server-tls/tls.key"` | Path to TLS private key for Redis proxy server |
| params.redis.proxyServerTls.secretName | string | `"argocd-redis-proxy-tls"` | Secret name containing TLS certificate and key for Redis proxy server |
| params.redis.serverAddress | string | `"argocd-redis:6379"` | Redis server address |
| params.redis.tls.enabled | string | `"false"` | Enable TLS for Redis connections |
| params.redis.tls.insecure | string | `"false"` | Skip verification of Redis TLS certificate (INSECURE - for development only) |
| params.resourceProxy.caPath | string | `""` | Path to the resource proxy CA cert |
| params.resourceProxy.caSecretName | string | `"argocd-agent-ca"` | Name of the secret containing the resource proxy CA cert |
| params.resourceProxy.enable | string | `"true"` | Enable the resource proxy |
| params.resourceProxy.secretName | string | `"argocd-agent-resource-proxy-tls"` | Name of the secret containing the resource proxy TLS cert/key |
| params.resourceProxy.tlsCertPath | string | `""` | Path to the resource proxy TLS cert |
| params.resourceProxy.tlsKeyPath | string | `""` | Path to the resource proxy TLS key |
| params.tls.allowGenerate | string | `"false"` | Allow the principal to auto-generate TLS cert/key (dev only) |
| params.tls.ciphersuites | string | `""` | Comma-separated list of TLS cipher suites (empty = Go defaults) |
| params.tls.clientCertMatchSubject | string | `"false"` | Match client cert subject to agent name |
| params.tls.clientCertRequire | string | `"false"` | Require client certificates from agents |
| params.tls.insecurePlaintext | string | `"false"` | Run gRPC without TLS (for service mesh / mTLS sidecar environments) |
| params.tls.maxVersion | string | `""` | Maximum TLS version (empty = use highest available) |
| params.tls.minVersion | string | `"tls1.3"` | Minimum TLS version: tls1.1, tls1.2, tls1.3 |
| params.tls.rootCaPath | string | `""` | Path to the root CA certificate (overrides rootCaSecretName if set) |
| params.tls.rootCaSecretName | string | `"argocd-agent-ca"` | Name of the secret containing the root CA certificate |
| params.tls.secretName | string | `"argocd-agent-principal-tls"` | Name of the secret containing the TLS cert and key |
| params.tls.serverCertPath | string | `""` | Path to the TLS certificate (overrides secretName if set) |
| params.tls.serverKeyPath | string | `""` | Path to the TLS private key (overrides secretName if set) |
| params.websocketEnable | string | `"false"` | Enable WebSocket for streaming events to agents |
| podAnnotations | object | `{}` | Annotations for the Pod |
| podDisruptionBudget.enabled | bool | `false` |  |
| podDisruptionBudget.minAvailable | int | `1` |  |
| podLabels | object | `{}` | Additional labels to add to the agent Pod. |
| podSecurityContext.fsGroup | int | `999` |  |
| podSecurityContext.fsGroupChangePolicy | string | `"OnRootMismatch"` |  |
| podSecurityContext.runAsGroup | int | `999` |  |
| podSecurityContext.runAsNonRoot | bool | `true` |  |
| podSecurityContext.runAsUser | int | `999` |  |
| podSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| priorityClassName | string | `""` | PriorityClassName for the agent Pod. |
| probes | object | `{"liveness":{"enabled":true,"failureThreshold":3,"httpGet":{"path":"/healthz","port":"healthz"},"initialDelaySeconds":10,"periodSeconds":10,"timeoutSeconds":2},"readiness":{"enabled":true,"failureThreshold":3,"httpGet":{"path":"/healthz","port":"healthz"},"initialDelaySeconds":5,"periodSeconds":10,"timeoutSeconds":2}}` | Liveness and readiness probe configuration. |
| probes.liveness.enabled | bool | `true` | Enable the liveness probe. |
| probes.liveness.failureThreshold | int | `3` | Failure threshold for liveness probe. |
| probes.liveness.initialDelaySeconds | int | `10` | Initial delay before the first liveness probe. |
| probes.liveness.periodSeconds | int | `10` | Frequency of liveness probes. |
| probes.liveness.timeoutSeconds | int | `2` | Timeout for liveness probe. |
| probes.readiness.enabled | bool | `true` | Enable the readiness probe. |
| probes.readiness.failureThreshold | int | `3` | Failure threshold for readiness probe. |
| probes.readiness.initialDelaySeconds | int | `5` | Initial delay before the first readiness probe. |
| probes.readiness.periodSeconds | int | `10` | Frequency of readiness probes. |
| probes.readiness.timeoutSeconds | int | `2` | Timeout for readiness probe. |
| progressDeadlineSeconds | int | `600` | Deployment progress deadline in seconds |
| rbac.create | bool | `true` | To create Role and RoleBinding |
| rbac.createClusterRole | bool | `false` | Whether to create ClusterRole and ClusterRoleBinding |
| redis.existingSecret | string | `"argocd-redis"` | Name of the secret containing the Redis auth password |
| redis.passwordKey | string | `"auth"` | Key within the secret |
| replicaCount | int | `1` | Number of replicas for the principal deployment |
| resources | object | `{"limits":{"cpu":"500m","memory":"256Mi"},"requests":{"cpu":"100m","memory":"128Mi"}}` | Resource requests and limits for the principal container |
| revisionHistoryLimit | int | `10` | Number of old ReplicaSets to retain |
| securityContext.allowPrivilegeEscalation | bool | `false` |  |
| securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| securityContext.privileged | bool | `false` |  |
| securityContext.readOnlyRootFilesystem | bool | `true` |  |
| securityContext.runAsGroup | int | `999` |  |
| securityContext.runAsNonRoot | bool | `true` |  |
| securityContext.runAsUser | int | `999` |  |
| securityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| service | object | `{"grpc":{"annotations":{},"loadBalancerIP":"","name":"","port":443,"type":"LoadBalancer"},"healthz":{"annotations":{},"enabled":true,"port":8003},"metrics":{"annotations":{},"enabled":true,"port":8000},"redisProxy":{"annotations":{},"enabled":true,"name":"","port":6379},"resourceProxy":{"annotations":{},"enabled":true,"name":"","port":9090}}` | Service configuration for metrics and healthz endpoints. |
| service.grpc.annotations | object | `{}` | Annotations for the gRPC service |
| service.grpc.loadBalancerIP | string | `""` | LoadBalancer IP (if type=LoadBalancer) |
| service.grpc.name | string | `""` | Override service name (defaults to chart fullname) |
| service.grpc.port | int | `443` | Port exposed by the service |
| service.grpc.type | string | `"LoadBalancer"` | Service type for the gRPC/principal service |
| service.healthz.enabled | bool | `true` | Whether to create the healthz service |
| service.metrics.enabled | bool | `true` | Whether to create the metrics service |
| service.redisProxy.enabled | bool | `true` | Whether to create the redis-proxy service |
| service.redisProxy.name | string | `""` | Override service name. Defaults to "<fullname>-redis-proxy". Set to "argocd-agent-redis-proxy" if consumers (e.g. argocd-server, argocd-application-controller) are configured to use the legacy name. |
| service.resourceProxy.enabled | bool | `true` | Whether to create the resource-proxy service |
| service.resourceProxy.name | string | `""` | Override service name. Defaults to "<fullname>-resource-proxy". |
| serviceAccount | object | `{"annotations":{},"create":true,"name":""}` | ServiceAccount configuration. |
| serviceAccount.annotations | object | `{}` | Annotations for the ServiceAccount |
| serviceAccount.create | bool | `true` | Whether to create a ServiceAccount |
| serviceAccount.name | string | `""` | Name of the ServiceAccount (defaults to chart fullname) |
| serviceMonitor | object | `{"additionalLabels":{},"annotations":{},"enabled":false,"honorLabels":false,"interval":"30s","metricRelabelings":[],"namespace":"","relabelings":[],"scheme":"","scrapeTimeout":"10s","tlsConfig":{}}` | Prometheus ServiceMonitor configuration. |
| serviceMonitor.additionalLabels | object | `{}` | Prometheus ServiceMonitor labels |
| serviceMonitor.annotations | object | `{}` | Prometheus ServiceMonitor annotations |
| serviceMonitor.enabled | bool | `false` | Whether to create a ServiceMonitor resource. |
| serviceMonitor.honorLabels | bool | `false` | When true, honorLabels preserves the metric’s labels when they collide with the target’s labels. |
| serviceMonitor.interval | string | `"30s"` | Prometheus scrape interval. Must be a valid duration string (e.g. "30s"). |
| serviceMonitor.metricRelabelings | list | `[]` | Prometheus [MetricRelabelConfigs] to apply to samples before ingestion |
| serviceMonitor.namespace | string | `""` | Namespace where the ServiceMonitor should be created. Defaults to release namespace. |
| serviceMonitor.relabelings | list | `[]` | Prometheus [RelabelConfigs] to apply to samples before scraping |
| serviceMonitor.scheme | string | `""` | Prometheus ServiceMonitor scheme |
| serviceMonitor.scrapeTimeout | string | `"10s"` | Prometheus scrape timeout. Must be a valid duration string (e.g. "10s"). |
| serviceMonitor.tlsConfig | object | `{}` | Prometheus ServiceMonitor tlsConfig |
| terminationGracePeriodSeconds | int | `30` | Grace period for pod termination (seconds) |
| tlsSecret.create | bool | `false` | Create the TLS secret (leave false if you manage it externally) |
| tlsSecret.crt | string | `""` | TLS certificate (PEM) |
| tlsSecret.key | string | `""` | TLS private key (PEM) |
| tlsSecret.secretName | string | `""` | Name of the secret (defaults to argocd-agent-principal-tls) |
| tolerations | list | `[]` | Tolerations for pod scheduling |
| topologySpreadConstraints | list | `[]` | Topology spread constraints for pod scheduling |
| updateStrategy | object | `{"rollingUpdate":{"maxSurge":"25%","maxUnavailable":"25%"},"type":"RollingUpdate"}` | Deployment update strategy |
| userpass.create | bool | `false` | Create the userpass secret. Only needed when params.auth uses "userpass:". |
| userpass.passwd | string | `""` | The passwd file contents (bcrypt-hashed credentials) |
| userpass.secretName | string | `""` | Name of the secret (defaults to argocd-agent-principal-userpass) |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
