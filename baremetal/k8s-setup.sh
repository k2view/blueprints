#!/usr/bin/env bash
main_pid=$$
date=$(date "+%Y%m%d%H%M%S")
self_name=$(basename "$0")
self_path=$(cd -- "$(dirname "${BASH_SOURCE[0]:-$0}")" >/dev/null 2>&1 && pwd)

# dynamic values can be set in a file 'k8s-setup.env' and it will overwrite any default
if [[ -f "$self_path/k8s-setup.env" ]]; then
  set -a
  . "$self_path/k8s-setup.env"
  set +a
fi

[[ -z "$no_prompt" ]] && no_prompt="false"

# configure K8s default values
[[ -z "$K8S_VERSION" ]] && K8S_VERSION="1.30"
[[ -z "$K8S_CALICO_VERSION" ]] && K8S_CALICO_VERSION="$(curl -I -s https://github.com/projectcalico/calico/releases/latest | awk -F '/' 'tolower($0) ~ /^location:/ { sub(/^v/,"",$NF); print substr($NF, 1, length($NF) - 1) }')"

# determine if script was invoked with sudo to change ownerships to the caller instead of root
if [[ $(id -u) -eq 0 ]]; then
  unset _sudo
  if [[ -n "$SUDO_USER" ]] && [[ -n "$SUDO_USER" ]]; then
    usr="$SUDO_USER"
    grp="$SUDO_GID"
  else
    usr=$(id -u)
    grp="$(id -g)"
  fi
else
  _sudo="sudo"
  usr="$LOGNAME"
  grp="$(id -g)"

  # check if user can run sudo command
  if ! sudo true; then
    echo "Cannot install without being sudo"
    exit 1
  fi
fi

# OS and distro/flavor checks
ID=$(. /etc/os-release && echo "$ID")
VERSION_ID=$(. /etc/os-release && echo "$VERSION_ID")
VERSION_MAJ="$(echo "$VERSION_ID" | sed 's/\..*//')"
case "$ID" in
  rocky|rhel)
    distro="rhel"
    install_cmd="yum"
    ;;
  ubuntu)
    distro="debian"
    install_cmd="apt"
    ;;
  *)
    echo "OS not supported"
    exit 1 ;;
esac

# install Git if not already installed
if ! git version >/dev/null 2>&1; then
  echo "Installing Git..."
  $_sudo $install_cmd install -y git
fi

# install required dependencies
echo "Installing dependencies..."
if [[ "$distro" == "rhel" ]]; then
  $_sudo yum install -y iproute-tc
elif [[ "$distro" == "debian" ]]; then
  $_sudo apt update
  $_sudo apt install -y apt-transport-https ca-certificates curl gpg

  if [[ ! -d "/etc/apt/keyrings" ]]; then
    $_sudo mkdir -p /etc/apt/keyrings
  fi
fi

# install containerd if required, but still proceeding if containerd can't be installed, assuming another container runtime was previously installed and configured
if ! systemctl is-active --quiet containerd; then
  echo "Installing containerd..."
  if [[ "$distro" == "rhel" ]]; then
    $_sudo yum install -y yum-utils
    $_sudo yum-config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
    if $_sudo test -f "/etc/yum.repos.d/docker-ce.repo"; then
      $_sudo sed -i "s/\$releasever/$VERSION_MAJ/" /etc/yum.repos.d/docker-ce.repo
    fi
    if ! $_sudo yum install -y containerd.io; then
      echo "Error during installation of containerd, aborting"
    fi
  elif [[ "$distro" == "debian" ]]; then
    $_sudo apt update
    $_sudo install -m 0755 -d /etc/apt/keyrings
    $_sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    $_sudo chmod a+r /etc/apt/keyrings/docker.asc
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | $_sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
    $_sudo apt update
    $_sudo apt install -y containerd.io
  fi

  # containerd service might start automatically after install, so stopping if needed
  if systemctl is-active --quiet containerd; then
    $_sudo systemctl stop containerd
  fi

  # load containerd default settings and configure systemd cgroup driver
  containerd config default | sed 's/SystemdCgroup = false/SystemdCgroup = true/' | $_sudo tee /etc/containerd/config.toml
  $_sudo systemctl enable --now containerd
fi

# install kubernetes if required
if ! systemctl is-active --quiet kubelet; then
  echo "Installing Kubernetes..."
  if [[ "$distro" == "rhel" ]]; then
    # disable SELinux
    $_sudo setenforce 0
    $_sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

    cat << EOF | $_sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v${K8S_VERSION}/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v${K8S_VERSION}/rpm/repodata/repomd.xml.key
exclude=kubelet kubeadm kubectl cri-tools kubernetes-cni
EOF
      
    $_sudo yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
  elif [[ "$distro" == "debian" ]]; then
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v${K8S_VERSION}/deb/Release.key | $_sudo gpg --batch --yes --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
    echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v${K8S_VERSION}/deb/ /" | $_sudo tee /etc/apt/sources.list.d/kubernetes.list

    $_sudo apt update
    $_sudo apt install -y kubelet kubeadm kubectl
    $_sudo apt-mark hold kubelet kubeadm kubectl
  fi
fi

# enable ip forwarding
if sysctl net.ipv4.ip_forward | grep ' = 0'; then
  echo "Configuring IPv4 packet forwarding..."
  echo "net.ipv4.ip_forward = 1" | $_sudo tee /etc/sysctl.d/k8s.conf
  $_sudo sysctl --system
fi

# deploy Kubernetes using kubeadm init or abort on fail
if ! systemctl is-active --quiet kubelet; then
  echo "Starting Kubernetes..."
  $_sudo systemctl enable --now kubelet
  if ! $_sudo kubeadm init; then
    err=$?
    echo "Error during execution of kubeadm init, aborting"
    exit $err
  fi
  
fi

# auto backup any existing kube config
if [[ -f "$HOME/.kube/config" ]]; then
  mv "$HOME/.kube/config" "$HOME/.kube/config.$date.bkp"
fi

# create kube config
mkdir -p "$HOME/.kube" && $_sudo cp /etc/kubernetes/admin.conf "$HOME/.kube/config" && $_sudo chown $usr:$grp "$HOME/.kube/config"

# if kube config and auto backup are the same, delete the auto backup
if [[ -f "$HOME/.kube/config" ]] && [[ -f "$HOME/.kube/config.$date.bkp" ]] && [[ "$(cat "$HOME/.kube/config")" == "$(cat "$HOME/.kube/config.$date.bkp")" ]]; then
  rm -f "$HOME/.kube/config.$date.bkp"
fi

# untaint node
kubectl taint nodes $(hostname) node-role.kubernetes.io/control-plane-

# attempt to retrieve the node IP, or use localhost instead
node_ip="$(kubectl get nodes -o jsonpath='{.items[?(.metadata.name=="'$(hostname)'")].status.addresses[?(@.type=="InternalIP")].address}')"
[[ -z "$node_ip" ]] && node_ip="127.0.0.1"

# deploy local storage
if kubectl get storageclasses 2>&1 | grep -q "No resources found"; then
  kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml
fi

# deploy container network interface
if ! kubectl get --all-namespaces deployments | grep -q calico-kube-controllers; then
  echo "Installing CNI..."
  kubectl apply -f "https://raw.githubusercontent.com/projectcalico/calico/v${K8S_CALICO_VERSION}/manifests/calico.yaml"
fi

# install Helm
if ! command -v helm >/dev/null; then
  echo "Installing Helm..."
  curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
fi

# deploy private registry
if [[ -f "$self_path/docker-registry.yaml" ]]; then
  if systemctl is-active --quiet containerd; then
    # add entry to etc-hosts
    if ! grep -qE '^[^#]*[[:space:]]+registry\.localhost([[:space:]]+|$)' /etc/hosts; then
      echo "$node_ip   registry.localhost # private registry" | $_sudo tee -a /etc/hosts >/dev/null
    fi

    if ! kubectl get namespace docker-registry >/dev/null 2>&1; then
      kubectl create namespace docker-registry
    fi
    kubectl apply -f $self_path/docker-registry.yaml --namespace docker-registry

    # set containerd config_path directory
    $_sudo sed -Ei '/^    \[plugins\."io\.containerd\.(grpc\.v1\.cri|cri\.v1\.images)"\.registry\]/,/^    \[|/s@config_path = ""@config_path = "/etc/containerd/certs.d"@' /etc/containerd/config.toml

    # configure registry.localhost endpoint to allow insecure connections
    if [[ ! -f /etc/containerd/certs.d/registry.localhost/hosts.toml ]]; then
      $_sudo mkdir -p /etc/containerd/certs.d/registry.localhost
      cat << EOF | $_sudo tee /etc/containerd/certs.d/registry.localhost/hosts.toml
server = "https://registry.localhost"
[host."https://registry.localhost"]
skip_verify = true
EOF
    fi

    $_sudo systemctl restart containerd
  else
    echo "At this moment, the only container runtime supported by private registry is containerd, not deploying private registry"
  fi
else
  echo "docker-registry.yaml not found, not deploying private registry"
fi

# configure load balancer default values
[[ -z "$LOADBALANCER_REPO" ]] && LOADBALANCER_REPO="https://metallb.github.io/metallb"
[[ -z "$LOADBALANCER_CHART" ]] && LOADBALANCER_CHART="metallb/metallb"
if [[ "$no_prompt" == "false" ]]; then
  echo "Configuring and installing cluster load balancer..."

  read -p "  - Enter MetalLB Helm repository [press Enter to use '$LOADBALANCER_REPO']: " input
  [[ -n "$input" ]] && LOADBALANCER_REPO="$input"
fi
# deploy load balancer
helm repo add metallb "$LOADBALANCER_REPO"
helm upgrade --install metallb --namespace metallb-system --create-namespace --wait "$LOADBALANCER_CHART"
cat << EOF | kubectl apply -f -
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: default
  namespace: metallb-system
spec:
  addresses:
  - $node_ip/32
---
apiVersion: metallb.io/v1beta1
kind: BGPAdvertisement
metadata:
  name: local
  namespace: metallb-system
spec:
  ipAddressPools:
  - default
  aggregationLength: 32
  localPref: 100
  communities:
  - 65535:65282
EOF

# configure ingress controller default values
[[ -z "$INGRESS_REPO" ]] && INGRESS_REPO="https://raw.githubusercontent.com/k2view/blueprints/main/helm/k2v-ingress"
[[ -z "$INGRESS_CHART" ]] && INGRESS_CHART="k2v-ingress/k2v-ingress"
[[ -z "$INGRESS_DOMAIN" ]] && domain_placeholder="no default, press Enter to skip - ie: k8scluster.example.com" || domain_placeholder="press Enter to use '$INGRESS_DOMAIN'"
[[ -z "$INGRESS_CERT" ]] && cert_placeholder="no default, press Enter to skip - ie: /path/to/file" || cert_placeholder="press Enter to use '$INGRESS_CERT'"
[[ -z "$INGRESS_KEY" ]] && key_placeholder="no default, press Enter to skip - ie: /path/to/file" || key_placeholder="press Enter to use '$INGRESS_KEY'"
if [[ "$no_prompt" == "false" ]]; then
  echo "Configuring and installing ingress controller..."

  read -p "  - Enter Ingress-NGINX Helm repository [press Enter to use '$INGRESS_REPO']: " input
  [[ -n "$input" ]] && INGRESS_REPO="$input"

  read -p "  - Enter cluster URL [$domain_placeholder]: " input
  [[ -n "$input" ]] && INGRESS_DOMAIN="$input"

  read -p "  - Enter SSL certificate to be used by the cluster [$cert_placeholder]: " input
  [[ -n "$input" ]] && INGRESS_CERT="$input"

  read -p "  - Enter SSL key to be used by the cluster [$key_placeholder]: " input
  [[ -n "$input" ]] && INGRESS_KEY="$input"
fi

# validate if parameters were passed with no blank values and build Helm command flags accordingly 
unset set_domain set_sslcrt set_sslkey set_sslsecret
[[ -n "$INGRESS_DOMAIN" ]] && set_domain="--set domain=$INGRESS_DOMAIN"
# tilde cannot be expanded when a variable is quoted, so convert ~ to value of $HOME to ensure path with whitespaces work properly
[[ -n "$INGRESS_CERT" ]] && { INGRESS_CERT=${INGRESS_CERT/\~\//$HOME/}; [[ -f "$INGRESS_CERT" ]] && set_sslcrt="--set tlsSecret.cert=$(base64 -w 0 "$INGRESS_CERT")" || echo "SSL certificate '$INGRESS_CERT' not found, not configuring SSL"; }
[[ -n "$INGRESS_KEY" ]] && { INGRESS_KEY=${INGRESS_KEY/\~\//$HOME/}; [[ -f "$INGRESS_KEY" ]] && set_sslkey="--set tlsSecret.key=$(base64 -w 0 "$INGRESS_KEY")" || echo "SSL key '$INGRESS_KEY' not found, not configuring SSL"; }
[[ -n "$set_sslcrt" ]] && [[ -n "$set_sslkey" ]] && set_sslsecret='--set ingress-nginx.controller.extraArgs.default-ssl-certificate=$(POD_NAMESPACE)/wildcard-certificate'

# deploy ingress controller
helm repo add k2v-ingress "$INGRESS_REPO"
helm upgrade --install ingress-nginx --namespace ingress-nginx --create-namespace $set_domain $set_sslkey $set_sslcrt $set_sslsecret "$INGRESS_CHART"

# configure k2view-agent default values
[[ -z "$K2_AGENT_REPO" ]] && K2_AGENT_REPO="https://raw.githubusercontent.com/k2view/blueprints/main/helm/k2view-agent"
[[ -z "$K2_AGENT_CHART" ]] && K2_AGENT_CHART="k2view-agent/k2view-agent"
[[ -z "$K2_MANAGER_URL" ]] && K2_MANAGER_URL="https://cloud.k2view.com/api/mailbox"
[[ -z "$K2_MAILBOX_ID" ]] && mailbox_placeholder="no default - this should be provided by K2view" || mailbox_placeholder="press Enter to use '$K2_MAILBOX_ID'"
if [[ "$no_prompt" == "false" ]]; then
  echo "Configuring K2view Agent..."

  read -p "  - Enter K2view Agent Helm repository [press Enter to use '$K2_AGENT_REPO']: " input
  [[ -n "$input" ]] && K2_AGENT_REPO="$input"

  read -p "  - Enter Mailbox URL [press Enter to use '$K2_MANAGER_URL']: " input
  [[ -n "$input" ]] && K2_MANAGER_URL="$input"

  read -p "  - Enter Mailbox ID [$mailbox_placeholder]: " input
  [[ -n "$input" ]] && K2_MAILBOX_ID="$input"
fi

# deploy k2view-agent if mailbox id is set
if [[ -n "$K2_MAILBOX_ID" ]]; then
  echo "Installing K2view Agent..."
  helm repo add k2view-agent "$K2_AGENT_REPO"
  helm upgrade --install k2view-agent --wait --set secrets.K2_MANAGER_URL="$K2_MANAGER_URL" --set secrets.K2_MAILBOX_ID="$K2_MAILBOX_ID" "$K2_AGENT_CHART"
else
  echo "No Mailbox ID provided, skipping K2view Agent installation"
fi
