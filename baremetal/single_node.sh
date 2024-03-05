#!/bin/bash
DEBUG=0
INSTALL_CMD='yum'

main_pid=$$
date=$(date "+%Y%m%d%H%M%S")
self_name=$(basename "$0")
self_path=$(cd -- "$(dirname "${BASH_SOURCE[0]:-$0}")" >/dev/null 2>&1 && pwd)

source ./bubbles.sh

function configRollingText() {
  rollingTextFile="${1:-/$self_path/$self_name.$date.out}"
  touch $rollingTextFile && > $rollingTextFile

  sh -c 'tail -f '$rollingTextFile &
  tail_pid=0; sh -c "while ps -p $main_pid >/dev/null; do sleep 1; done; kill -9 $tail_pid &>/dev/null" &
}

function _microk8s() {
  microk8s="microk8s"
  if [[ "$DISTRO" =~ alma|centos|rocky|rhel|fedora ]]; then
    . /etc/profile.d/snapd.sh
    microk8s="sudo $snap_bin_path/microk8s"
  fi
}

function init() {
    installLogFile="$self_path/$self_name.$date.log"
    touch $installLogFile && > $installLogFile
    case "$(uname -s)" in
        Linux*)
            configRollingText
            DISTRO=$(sed -n 's/^ID=//p' /etc/os-release | sed -e 's/"//g' -e "s/'//g")
            case "$DISTRO" in
                alma|centos|rocky|rhel|fedora)
                    INSTALL_CMD="yum -y"
                    ;;
                ubuntu|debian)
                    INSTALL_CMD="apt -y"
                    ;;
                *)  DISTRO="Unknown" ;;
            esac
            OS="linux"
            print_colored_bold "green" "Installing $OS ($DISTRO) dependencies completed ...\n" | _tee $installLogFile
            ;;
        Darwin*)
            configRollingText $installLogFile
            OS="MacOS"
            DISTRO="$OS"
            INSTALL_CMD="brew"
            ;;
        *)  OS="Unknown" ;;
    esac  
    print_colored_bold "green" "Initializing Completed!\n" | _tee $installLogFile
}


function install_git() {
  if git version &> /dev/null
  then
    print_colored_bold "green" '√ Git Source Control Already Installed ...\n' | _tee $rollingTextFile
  else
    print_colored_bold "cyan" "Installing Git Source Control ..." | _tee $rollingTextFile
    echo "" && sudo $INSTALL_CMD install git &
    ( basic_spinner; echo ""; ) >> $rollingTextFile
    if git version &> /dev/null
    then
      print_colored_bold "green" '√ Git installed successfully ...\n' | _tee $rollingTextFile
    else
      print_colored_bold "red" 'x Git installation failed ...\n' | _tee $rollingTextFile
    fi
  fi
}

function install_docker() {
  case "$DISTRO" in
    ubuntu|debian)
      echo '''
      exec &>/tmp/install_docker.log 
      apt update
      apt install -y apt-transport-https ca-certificates curl software-properties-common
      curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/docker-archive-keyring.gpg >/dev/null
      add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
      apt update
      DEBIAN_FRONTEND=noninteractive apt install -y docker-ce 
      systemctl enable docker
      systemctl start docker
      ''' > /tmp/install_docker.sh
      chmod +x /tmp/install_docker.sh
      ;;
    alma|centos|rocky|rhel|fedora)
      echo '''
      sudo $INSTALL_CMD install yum-utils
      sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
      sudo $INSTALL_CMD install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
      sudo systemctl start docker
      ''' > /tmp/install_docker.sh
      chmod +x /tmp/install_docker.sh
      ;;
    esac

    print_colored_bold "cyan" "Installing Docker ..." | _tee $rollingTextFile
    echo "" && bash -c "/tmp/install_docker.sh" &
    ( basic_spinner; echo ""; ) >> $rollingTextFile
    if docker ps &> /dev/null
    then
          print_colored_bold "green" '√ Docker installed successfully ...\n' | _tee $rollingTextFile
    else
          print_colored_bold "red" 'x Docker installation failed ...\n' | _tee $rollingTextFile
    fi
}

function install_k8s_block1() {
  echo "vm.nr_hugepages=1024" | sudo tee -a /etc/sysctl.d/20-microk8s-hugepages.conf
  sudo sysctl -w vm.nr_hugepages=1024
  sudo sysctl -p
  local pkg
  case "$DISTRO" in
    alma|centos|rocky)
      pkg="kmod"
      sudo $INSTALL_CMD install epel-release
      ;;
    rhel)
      pkg="kmod"
      if ! sudo yum repolist enabled | grep -q "epel"; then
        print_colored_bold "red" "EPEL is required to install snapd. Please install it manually. Aborting!" | _tee $rollingTextFile
        exit 1
      fi
      ;;
    fedora) pkg="kmod" ;;
    ubuntu|debian)
      pkg="linux-modules-extra-$(uname -r)"
      sudo $INSTALL_CMD update
      ;;
  esac
  sudo $INSTALL_CMD install $pkg
  sudo modprobe nvme-tcp
  echo 'nvme-tcp' | sudo tee -a /etc/modules-load.d/microk8s-mayastor.conf
}

function install_k8s_block2() {
  sudo $INSTALL_CMD install snapd
  if [[ "$DISTRO" =~ alma|centos|rocky|rhel|fedora ]]; then
    sudo systemctl enable --now snapd.socket
    [[ ! -L "/snap" ]] && sudo ln -s /var/lib/snapd/snap /snap
  fi
}

function install_k8s_block3() {
  snap version
  sudo snap install microk8s --classic --channel=1.27
  if ! sudo snap list | grep -q "microk8s"; then
    print_colored_bold "red" ' x Kubernetes installation failed, will retry once in 30 seconds ...' | _tee $rollingTextFile
    sleep 30
    sudo snap install microk8s --classic --channel=1.27
  fi
  sudo usermod -a -G microk8s $USER
  sudo chown -f -R $USER ~/.kube

  sleep 10
  $microk8s status --wait-ready > /dev/null
  sleep 3
}

function install_k8s() {
case "$OS" in
  linux)
        if snap list microk8s &>/dev/null
        then
          print_colored_bold "cyan" '\n√ Kubernetes Already installed ... Skipping ... \n'
          return
        fi
        print_colored_bold "cyan" '\n√ Installing Kubernetes prerequisites ...' | _tee $rollingTextFile

        # Block for the spinner to work
        echo "" && install_k8s_block1 &
        basic_spinner >> $rollingTextFile

        print_colored_bold "cyan" '√ Installing Snap ...' | _tee $rollingTextFile
        echo "" && install_k8s_block2 &
        basic_spinner >> $rollingTextFile

        [[ -z "$microk8s" ]] && _microk8s

        print_colored_bold "cyan" '√ Installing Kubernetes ...' | _tee $rollingTextFile
        echo "" && install_k8s_block3 &
        basic_spinner >> $rollingTextFile

        if $microk8s status | grep -q "microk8s is running"
        then
          print_colored_bold "green" '√ Kubernetes installed successfully ...\n' | _tee $rollingTextFile
        else
          print_colored_bold "red" 'x Kubernetes installation failed ...\n' | _tee $rollingTextFile
          exit 1
        fi
        ;;
  MacOS)
      if [[ `minikube status | grep -c Running` -eq 3 ]] &> /dev/null
      then
        minikube status
      else
        get_input_with_default "Enter Cluster CPU Limits:" "2"
        local cpu_limit="${INPUT_WITH_DEFAULT}"
        get_input_with_default "Enter Cluster Memory (MB):" "4096"
        local memory_limit="${INPUT_WITH_DEFAULT}"
        if [[ `uname -m` == "x86_64" ]]
        then
          hyperkit -v &> /dev/null &&  spinner "cyan" -- brew install -q hyperkit
        else
          brew install -q --cask docker
          echo "-- Starting Docker.app, if necessary..."
          open -g -a Docker.app
          # Wait for the server to start up, if applicable.
          i=0
          while ! docker system info &>/dev/null; do
            (( i++ == 0 )) && printf %s '-- Waiting for Docker to finish starting up...' || printf '.'
            sleep 1
          done
          (( i )) && printf '\n'
        fi
        brew install minikube
        brew install kubectl
        brew install helm
        minikube start --memory=${memory_limit} --cpus=${cpu_limit}
      fi

      if minikube status  &> /dev/null
      then
        print_colored_bold "green" '√ Kubernetes installed successfully ...'
      else
        print_colored_bold "red" 'x Kubernetes installation failed ...'
      fi
    ;;
  esac
}


function configure_k8s() {
echo ""
print_colored_bold "cyan" "\nThe following tools will be installed:\n" | _tee $rollingTextFile
echo -e "
|Name            |Required |More info                                   |
|----------------|---------|--------------------------------------------|
|cert-manager    |Yes      |'https://cert-manager.io/'                  |
|NGINX Ingress   |Yes      |'https://docs.nginx.com/'                   |
|hostpath-storage|Yes      |                                            |
|docker registry |Yes      |'https://microk8s.io/docs/registry-built-in'|
|metrics-server  |Yes      |                                            |
" | _tee $rollingTextFile

case "$OS" in 
  linux) 
      [[ -z "$microk8s" ]] && _microk8s

      $microk8s kubectl cluster-info
      local code=0
      local addon_list="$($microk8s status --format short 2>/dev/null)"
      for addon in dns ingress cert-manager hostpath-storage registry metrics-server
      do
        if echo "$addon_list" | grep -q "^core/${addon}: disabled"
        then
           print_colored_bold "magenta"  "Installing ${addon} ...\n" | _tee $rollingTextFile
           $microk8s enable $addon
           ((code+=$?))
           if [[ "$addon" == "ingress" ]]; then
             $microk8s kubectl -n ingress get daemonset nginx-ingress-microk8s-controller -o json | sed 's/--ingress-class=public/--ingress-class=nginx/' | $microk8s kubectl apply -f -
             $microk8s kubectl rollout restart -n ingress daemonset.apps/nginx-ingress-microk8s-controller
           fi
           sleep 10
        else
           print_colored_bold "magenta"  "Addon ${addon} is already installed ... skipping ...\n" | _tee $rollingTextFile
        fi
      done
      if [[ $code -eq 0 ]]
      then
        print_colored_bold "green" '√ Kubernetes Configured successfully ....\n' | _tee $rollingTextFile
      else
        print_colored_bold "red" 'x Kubernetes Configuration failed ...\n' | _tee $rollingTextFile
      fi
      ;;
  MacOS)
    for addon in ingress metrics-server registry volumesnapshots csi-hostpath-driver
    do
      print_colored_bold "cyan" $addon
      minikube addons enable $addon
    done
    ;;
  esac
}

function presetup_k2agent() {
  get_input_with_default "K2View Helm Repository URL:" "https://github.com/k2view/blueprints.git"
  k2_agent_helm_repo="${INPUT_WITH_DEFAULT}"
  print_in_box "cyan" "Installing K2View Agent"
  get_input_with_default "Enter Mailbox URL" "https://cloud.k2view.com/api/mailbox"
  MANAGER_URL="${INPUT_WITH_DEFAULT}"
  get_input_with_default "Enter Mailbox ID" "no default - this should be provided by K2view"
  MAILBOX_ID="${INPUT_WITH_DEFAULT}"
}


function install_k2agent() {
  case "$OS" in 
  linux)  [[ -z "$microk8s" ]] && _microk8s
          local HELM="$microk8s helm"
          local KUBECTL="$microk8s kubectl"
          
          ;;
  MacOS)  local HELM="helm"
          local KUBECTL="minikube kubectl -- "
          ;;
  esac
  if $HELM ls | grep k2-agent
  then
    print_colored_bold "cyan" "√ K2-Agent is already installed ... skipping ...\n" | _tee $rollingTextFile
    return 0 
  fi

  set -x -e
  rm -rf blueprints || true
  git clone ${k2_agent_helm_repo}

  cd blueprints/helm/k2view-agent

  $HELM uninstall k2-agent &>/dev/null || true
  print_colored_bold "cyan" "Deploying K2View Agent\n" | _tee $rollingTextFile
  $HELM install k2-agent . --debug --wait --set secrets.K2_MAILBOX_ID="$MAILBOX_ID" --set secrets.K2_MANAGER_URL="$MANAGER_URL"
  set +x
  if $KUBECTL --namespace k2view-agent get deploy k2view-agent | grep -q "k2view-agent   1/1"
  then
    print_colored_bold "green" '√ K2-Agent Deployed successfully ...\n' | _tee $rollingTextFile
  else
    print_colored_bold "red" 'x K2-Agent Deployment failed ...\n' | _tee $rollingTextFile
  fi
}

# ==== Script Starts Here =====
cat ./static/logo.ans
echo ; echo

print_colored_bold "magenta" "The following tools will be installed:"
print_colored_bold "white" " "
echo "
|Name            |Required |More info                                   |
|----------------|---------|--------------------------------------------|
|Microk8s        |Yes      |'https://microk8s.io/'                      |
|Git             |Yes      |'https://git-scm.com/'                      |
|cert-manager    |Yes      |'https://cert-manager.io/'                  |
|NGINX Ingress   |Yes      |'https://docs.nginx.com/'                   |
|hostpath-storage|Yes      |                                            |
|docker registry |Yes      |'https://microk8s.io/docs/registry-built-in'|
|metrics-server  |Yes      |                                            |
|k2-agent        |Yes      |'helm/charts/k2view-agent'                  |
"  
if ! confirm "Installing Kubernetes Components"
then
    echo "Exiting ..."
    exit 1
fi

init

case "$OS" in 
linux)
        if ! git version &>/dev/null 
        then
          install_git &>> $installLogFile
        fi
        install_k8s &>> $installLogFile
        configure_k8s &>> $installLogFile
        presetup_k2agent
        install_k2agent &>> $installLogFile
        ;;
MacOS)
        if ! git version &>/dev/null 
        then
          install_git
        fi
        install_k8s
        configure_k8s
        presetup_k2agent
        install_k2agent
        ;;
esac

print_in_box "cyan" "Installation Completed - Continue in CloudManager" | _tee $installLogFile

echo "Full installation log: $installLogFile"
