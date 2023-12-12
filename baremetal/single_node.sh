#!/bin/bash

source ./bubbles.sh

function init() {
    case "$(uname -s)" in
        Linux*)     OS=linux
                    print_colored_bold "green" "Installing $OS dependencies completed ..."
                    ;;
        Darwin*)    OS=MacOS ;;
        *)      OS="Unknown" ;;
    esac  
    print_colored_bold "green" "Initializing Completed! "
}


function install_git(){
 if git version &> /dev/null
 then
  print_colored_bold "green" '√ Git Source Control Already Installed ...'
 else
   case "$OS" in
    linux) 
      BUBBLES_FG_COLOR="green" spinner "Installing Git Source Control ..." -- apt install -y git
      ;;
    MacOS) 
      BUBBLES_FG_COLOR="green" spinner "Installing Git Source Control ..." -- brew install git 
      ;;
    esac
   if git version &> /dev/null
   then
        print_colored_bold "green" '√ Git installed successfully ...'
   else
        print_colored_bold "red" 'x Git installation failed ...'
   fi
 fi
}

function install_docker() {
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
    BUBBLES_FG_COLOR="green" spinner "Installing Docker ..." -- bash -c "/tmp/install_docker.sh"
    if docker ps &> /dev/null
    then
           print_colored_bold "green" '√ Docker installed successfully ...' 
    else
           print_colored_bold "red" 'x Docker installation failed ...' 
    fi
}

function install_k8s() {
case "$OS" in 
  linux) 
        if snap list microk8s &>/dev/null
        then
          print_colored_bold "cyan" '\n√ Kubernetes Already installed ... Skipping ... \n' 
          return 
        fi
        print_colored_bold "cyan" '\n√ Installing Kubernetes ... \n' 
        sudo apt update
        echo "vm.nr_hugepages=1024" | sudo tee -a /etc/sysctl.d/20-microk8s-hugepages.conf
        sudo sysctl -w vm.nr_hugepages=1024
        sudo sysctl -p
        sudo apt-get install -y  linux-modules-extra-$(uname -r)
        sudo modprobe nvme-tcp
        echo 'nvme-tcp' | sudo tee -a /etc/modules-load.d/microk8s-mayastor.conf
        sudo apt install snapd -y
        snap version
        sudo snap install microk8s --classic --channel=1.27
        sudo usermod -a -G microk8s $USER
        sudo chown -f -R $USER ~/.kube
        sudo microk8s status --wait-ready > /dev/null

        if microk8s status | grep -q "microk8s is running" 
        then
          print_colored_bold "green" '\n√ Kubernetes installed successfully ...\n' 
        else
          print_colored_bold "red" '\x Kubernetes installation failed ...\n' 
        fi
        ;;
  MacOS)
      if brew list minikube &> /dev/null
      then
        [[ `minikube status | grep -c Running` -ne 3 ]] && \\
             minikube start --memory=${memory_limit} --cpu=${cpu_limit}
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
        minikube start --memory=${memory_limit} --cpu=${cpu_limit}
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
print_colored_bold "magenta" "The following tools will be installed:"
echo -e "\n
|Name            |Required |More info                                   |
|----------------|---------|--------------------------------------------|
|cert-manager    |Yes      |'https://cert-manager.io/'                  |
|NGINX Ingress   |Yes      |'https://docs.nginx.com/'                   |
|hostpath-storage|Yes      |                                            |
|docker registry |Yes      |'https://microk8s.io/docs/registry-built-in'|                           |
|metrics-server  |Yes      |                                            |
\n\n"

case "$OS" in 
  linux) 
      microk8s kubectl cluster-info
      local code=0
      for addon in dns ingress cert-manager storage registry metrics-server
      do
        if ! microk8s kubectl get pods --all-namespaces 2>/dev/null | grep -q ${addon}
        then
           print_colored_bold "magenta"  "\nInstalling ${addon} ..."
           microk8s enable $addon
           ((code+=$?))
        else
           print_colored_bold "magenta"  "\nAddon ${addon} is already installed ... skipping ..."
        fi
      done
      if [[ $code -eq 0 ]]
      then
        print_colored_bold "green" '\n√ Kubernetes Configured successfully ....\n'
      else
        print_colored_bold "red" '\nx Kubernetes Configuration failed ...\n'
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


function install_k2agent() {

  get_input_with_default "K2View Helm Repository URL:" "https://github.com/k2view/blueprints.git"
  local k2_agent_helm_repo="${INPUT_WITH_DEFAULT}"
  print_in_box "cyan" "\n\nInstalling K2View Agent\n"
  get_input_with_default "Enter Mailbox URL" "https://cloud.k2view.com/api/mailbox"
  local MANAGER_URL="${INPUT_WITH_DEFAULT}"
  get_input_with_default "Enter Mailbox ID" "no default"
  local MAILBOX_ID="${INPUT_WITH_DEFAULT}"
  rm -rf blueprints || true
  git clone ${k2_agent_helm_repo}
  cd blueprints/helm/k2view-agent
  microk8s helm uninstall k2-agent &>/dev/null || true
  print_colored_bold "cyan" "Updating K 2View Agent"
  microk8s helm install k2-agent . --wait --set secrets.K2_MAILBOX_ID="$MAILBOX_ID" --set secrets.K2_MANAGER_URL="$MANAGER_URL" 
  if microk8s kubectl --namespace k2view-agent get deploy k2view-agent | grep -q "k2view-agent   1/1"
  then
    print_colored_bold "green" '√ K2-Agent Deployed successfully ...'
  else
    print_colored_bold "red" 'x K2-Agent Deployment failed ...'
  fi
}

# ==== Script Starts Here =====

clear
cat ./static/logo.ans
init
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
|docker registry |Yes      |'https://microk8s.io/docs/registry-built-in'|                           |
|metrics-server  |Yes      |                                            |
|k2-agent        |Yes      |'helm/charts/k2view-agent'                  |
"  

if ! confirm "Installing Kubernetes Components"
then
    echo "Exiting ..."
    exit 1
else
  if ! git version >/dev/null 
  then
    install_git
  fi
  install_k8s
  configure_k8s
  install_k2agent
fi
