# K2view-Ingress powered by [ingress-nginx](https://kubernetes.github.io/ingress-nginx/)

This chart bootstraps an ingress-nginx deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

On top of ingress-nginx, we are deploying the following resources:

- Ingress test, that can be used to validate inbound connectivity to your cluster
- Customized error pages, ensuring your devs / users will receive the appropriate feedback if a _Space_ is not working properly
- At cluster-level SSL certificate configuration, providing the convenience of configuring ingress-nginx only once with a wildcard SSL certificate that will cover all _Spaces_ created in your Kubernetes cluster[[1]](#1)

<a id='1'></a>[1] A wildcard SSL certificate must be issued prior to the deployment of this Helm chart. If any internal company policy prevents issuing a wildcard certificate, a SSL certificate having multiple entries in the _Subject Alternative Name_ can be used intead. Please consult with K2view how to configure the FQDNs correctly in this case

## Requirements

### ingress-nginx
Kubernetes: `>=1.21.0-0`

### K2view custom resources
Our custom resources can be deployed to virtually any version of ingress-nginx

## Get Repo Info

```console
helm repo add k2v-ingress https://nexus.share.cloud.k2view.com/repository/k2v-ingress
helm repo update
```

## Install Chart

**Important:** only helm3 is supported

```console
helm upgrade --install ingress-nginx --namespace ingress-nginx --create-namespace
```

The command deploys ingress-nginx on the Kubernetes cluster in the default configuration. In order to configure the ingress test, error pages and SSL certificate, some `values` must be specified. _See [configuration](#configuration) below._

### ingress test / error pages

A ingress will be created for each of those addons, therefore they required `domain: ` to be set in order to get deployed.

Defined in values.yaml
```yaml
domain: "cluster.example.com"
```

Or via CLI: `--set domain="cluster.example.com"`

### SSL certificate

A cluster-level SSL certificate (for ingresses using ingress-nginx as ingress class). Require `tlsSecret.cert:` and `tlsSecret.key:` to be set, which can be either the path to a file[[2]](#2) or a base64 encoded string.

<a id='2'></a>[2] Due to Helm restrictions, using a file instead of a base64-encoded string only works if doing a local install, not installing from a repo. In this case, the file must be in the chart's directory or nested to it. If using Helm repo (recommeded), you can use a subshell to read and encode it using `base64` command, as seem in example below

Defined in values.yaml
```yaml
tlsSecret:
  key: "<BASE64_ENCODED_STRING>"
  cert: "<BASE64_ENCODED_STRING>"

ingress-nginx:
  controller:
    extraArgs:
      default-ssl-certificate: $(POD_NAMESPACE)/wildcard-certificate
```

Or via CLI: `--set ingress-nginx.controller.extraArgs.default-ssl-certificate='$(POD_NAMESPACE)/wildcard-certificate' --set tlsSecret.key="<BASE64_ENCODED_STRING>" --set tlsSecret.cert="<BASE64_ENCODED_STRING>"`

Or via CLI reading the content of a file using a subshell:  `--set ingress-nginx.controller.extraArgs.default-ssl-certificate='$(POD_NAMESPACE)/wildcard-certificate' --set tlsSecret.key="$(base64 -w 0 /path/to/private.key)" --set tlsSecret.cert="$(base64 -w 0 /path/to/certificate.cer)"`

__Important:__ `ingress-nginx.controller.extraArgs.default-ssl-certificate` must be configure exactly as above. That will instruct ingress-nginx to use the TLS secret that's being created from values of key / cert. If setting it from the CLI, rmember to escape the dollar sign (or keep it inside single quotes), you don't want to expand, it need to be a literal _$_

### Cloud-specific annotations

In order to work correctly with your cloud provider, a few _annotations_ must be specified. Below are a few basic examples that will give you a working ingress controller. For a more detailed information, please consult with your cloud provider documentation

#### AWS

```yaml
ingress-nginx:
  controller:
    service:
      externalTrafficPolicy: Local
      annotations:
        service.beta.kubernetes.io/aws-load-balancer-type: nlb
        service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled: "true"
```

Or via CLI: `--set ingress-nginx.controller.service.annotations."service\.beta\.kubernetes\.io/aws-load-balancer-type"=nlb --set ingress-nginx.controller.service.annotations."service\.beta\.kubernetes\.io/aws-load-balancer-cross-zone-load-balancing-enabled"=true`

Additionally to the config above, if you would like to configure your the ingress controller to use AWS Certificate Manager, you must configure as below:

```yaml
ingress-nginx:
  controller:
    service:
      externalTrafficPolicy: Local
      annotations:
        service.beta.kubernetes.io/aws-load-balancer-ssl-cert: ACM_ARN
        service.beta.kubernetes.io/aws-load-balancer-ssl-ports: https
        service.beta.kubernetes.io/aws-load-balancer-backend-protocol: ssl
```

Or via CLI: `--set ingress-nginx.controller.service.annotations."service\.beta\.kubernetes\.io/aws-load-balancer-ssl-cert"=ACM_ARN --set ingress-nginx.controller.service.annotations."service\.beta\.kubernetes\.io/aws-load-balancer-ssl-ports"=https --set ingress-nginx.controller.service.annotations."service\.beta\.kubernetes\.io/aws-load-balancer-backend-protocol"=ssl`

> Don't forget to replace `ACM_ARN` by the value of the actual ARN, like `arn:aws:acm:REGION:ACCOUNT-ID:certificate/XXXXXX-XXXXXXX-XXXXXXX-XXXXXXXX`

#### Azure

```yaml
ingress-nginx:
  controller:
    service:
      externalTrafficPolicy: Local
      annotations:
        service.beta.kubernetes.io/azure-load-balancer-health-probe-request-path: /healthz
```

Or via CLI: `--set ingress-nginx.controller.service.externalTrafficPolicy=Local --set ingress-nginx.controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-health-probe-request-path"=/healthz`

Additionally to the config above, if you would like to restric access within a private network, you must configure as below:

```yaml
ingress-nginx:
  controller:
    service:
      loadBalancerIP: "1.2.3.4"
      annotations:
        service.beta.kubernetes.io/azure-load-balancer-internal: "true"
        
```

Or via CLI: `--set ingress-nginx.controller.service.loadBalancerIP=1.2.3.4 --set ingress-nginx.controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-internal"=true`

Where `1.2.3.4` is the IP you are assigning as your cluster's ingress. Make sure that this IP address isn't already in use within your virtual network. If you're using an existing virtual network and subnet, you must configure your AKS cluster with the correct permissions to manage the virtual network and subnet. More information can be found in [here](https://learn.microsoft.com/en-us/azure/aks/ingress-basic?tabs=azure-cli#create-an-ingress-controller-using-an-internal-ip-address)

#### GCP

```yaml
ingress-nginx:
  controller:
    service:
      externalTrafficPolicy: Local
```

Or via CLI: `--set ingress-nginx.controller.service.externalTrafficPolicy=Local`

Additionally to the config above, if you would like to restric access within a private network, you must configure as below:

```yaml
ingress-nginx:
  controller:
    service:
      loadBalancerIP: "1.2.3.4"
      annotations:
        cloud.google.com/load-balancer-type: Internal
        
```

Or via CLI: `--set ingress-nginx.controller.service.annotations."cloud\.google\.com/load-balancer-type"=Internal`