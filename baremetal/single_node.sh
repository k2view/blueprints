#!/bin/bash

source ./bubbles.sh

function init() {
    DISTRIBUTION="Unknown"

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

function install_microk8s() {

case "$OS" in 
  linux) 
	    echo '''
        #!/bin/bash -x
        exec &>/tmp/install_microk8s.log 
        sudo apt update
        echo "vm.nr_hugepages=1024" | sudo tee -a /etc/sysctl.d/20-microk8s-hugepages.conf
        sysctl -w vm.nr_hugepages=1024
        sysctl -p
        sudo apt-get install -y  linux-modules-extra-$(uname -r)
        sudo modprobe nvme-tcp
        echo 'nvme-tcp' | sudo tee -a /etc/modules-load.d/microk8s-mayastor.conf
        sudo apt install snapd -y
        snap version
        sudo snap install microk8s --classic --channel=1.27
        sudo usermod -a -G microk8s ubuntu
        sudo chown -f -R ubuntu ~/.kube
        su - ubuntu
        microk8s status --wait-ready
      ''' > /tmp/install_microk8s_linux.sh
      chmod +x /tmp/install_microk8s_linux.sh
      
      BUBBLES_FG_COLOR="green" spinner  "Installing Kubernetes ..." -- bash -c "/tmp/install_microk8s_linux.sh"
      if microk8s status  | grep -q "microk8s is running" 
      then
        print_colored_bold "green" '√ Kubernetes installed successfully ...' 
      else
        print_colored_bold "red" 'x Kubernetes installation failed ...' 
      fi
      ;;
  MacOS)
      if brew list minikube &> /dev/null
      then
        minikube start 
      else
        brew install --cask docker#!/bin/bash

source ./bubbles.sh

function init() {
    DISTRIBUTION="Unknown"

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

function install_microk8s() {

case "$OS" in 
  linux) 
	    echo '''
        #!/bin/bash -x
        exec &>/tmp/install_microk8s.log 
        sudo apt update
        echo "vm.nr_hugepages=1024" | sudo tee -a /etc/sysctl.d/20-microk8s-hugepages.conf
        sysctl -w vm.nr_hugepages=1024
        sysctl -p
        sudo apt-get install -y  linux-modules-extra-$(uname -r)
        sudo modprobe nvme-tcp
        echo 'nvme-tcp' | sudo tee -a /etc/modules-load.d/microk8s-mayastor.conf
        sudo apt install snapd -y
        snap version
        sudo snap install microk8s --classic --channel=1.27
        sudo usermod -a -G microk8s ubuntu
        sudo chown -f -R ubuntu ~/.kube
        su - ubuntu
        microk8s status --wait-ready
      ''' > /tmp/install_microk8s_linux.sh
      chmod +x /tmp/install_microk8s_linux.sh
      
      BUBBLES_FG_COLOR="green" spinner  "Installing Kubernetes ..." -- bash -c "/tmp/install_microk8s_linux.sh"
      if microk8s status  | grep -q "microk8s is running" 
      then
        print_colored_bold "green" '√ Kubernetes installed successfully ...' 
      else
        print_colored_bold "red" 'x Kubernetes installation failed ...' 
      fi
      ;;
  MacOS)
      if brew list minikube &> /dev/null
      then
        [[ `minikube status | grep -c Running` -ne 3 ]] && minikube start
      else
        if [[ `uname -m` == "x86_64" ]]
        then 
          hyperkit -v &> /dev/null &&  spinner "cyan" -- brew install -q hyperkit
        else
          brew install -q --cask docker
          echo "-- Starting Docker.app, if necessary..."
          open -g -a Docker.app || exit
          # Wait for the server to start up, if applicable.
          i=0
          while ! docker system info &>/dev/null; do
            (( i++ == 0 )) && printf %s '-- Waiting for Docker to finish starting up...' || printf '.'
            sleep 1
          done
          (( i )) && printf '\n'
        fi
        # open /Applications/Docker.app
        brew install minikube
        brew install kubectl
        brew install helm
        minikube start
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


function configure_microk8s() {

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
"
echo ""
echo ""
case "$OS" in 
  linux) 

      echo '''
      #!/bin/bash -x
      exec &>/tmp/configure_microk8s.log
      microk8s kubectl cluster-info
      code=0
      for addon in dns ingress cert-manager storage registry metrics-server
      do
        microk8s enable $addon
        echo  "\t\t Installing ${addon} ..."
        ((code+=$?))
      done
      microk8s kubectl get all --all-namespaces
      microk8s kubectl get nodes
      echo $code > /tmp/configure_microk8s.code
      ''' > /tmp/configure_microk8s.sh
      chmod +x /tmp/configure_microk8s.sh
      BUBBLES_FG_COLOR="green" spinner "Configuring Kubernetes ..." -- bash -c "/tmp/configure_microk8s.sh"
      code=`cat /tmp/configure_microk8s.code`

      if [[ $code -eq 0 ]]
      then
        print_colored_bold "green" '√ Kubernetes Configured successfully ...'
      else
        print_colored_bold "red" 'x Kubernetes Configuration failed ...'
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
  echo; echo
  print_in_box "cyan" "Installing K2View Agent"
  echo

  print_colored_bold "cyan" "Enter Mailbox URL: "
  read MANAGER_URL 
  print_colored_bold "cyan"  "Enter Mailbox ID: "
  read MAILBOX_ID

  # MANAGER_URL=`$GUM input --prompt "Enter Mailbox URL: " --prompt.foreground=212 --placeholder "https://cloud-dev.k2view.com/api/mailbox"`

  # MAILBOX_ID=`$GUM input --prompt "Enter Mailbox ID: " --prompt.foreground=212 --placeholder "12345678-0123-0123-0123-123456789012"`

case "$OS" in 
 linux)
    echo """
      #!/bin/bash -x
      exec &>/tmp/k2_agent_install.log
      rm -rf blueprints || true
      git clone https://github.com/k2view/blueprints.git
      cd blueprints/helm/k2view-agent
      # microk8s kubectl create namespace k2view-agent
      helm install k2-agent . --set secrets.K2_MAILBOX_ID=\"$MAILBOX_ID\" --set secrets.K2_MANAGER_URL=\"$MANAGER_URL\"
      """ > /tmp/k2agent_install.sh
      chmod +x /tmp/k2agent_install.sh
      BUBBLES_FG_COLOR="green" spinner "Installing K2View Agent ..." -- bash -c "/tmp/k2agent_install.sh"
      sleep 5
      if microk8s kubectl get deploy k2view-agent | grep -q "k2view-agent   1/1"
      then
        print_colored_bold "green" '√ K2-Agent Deployed successfully ...'
      else
        print_colored_bold "red" 'x K2-Agent Deployment failed ...'
      fi

      ;;
  MacOS)
      rm -rf blueprints || true
      git clone https://github.com/k2view/blueprints.git
      cd blueprints/helm/k2view-agent
      helm uninstall k2-agent &>/dev/null || true
      while kubectl get ns k2view-agent &>/dev/null
      do
        print_colored_bold "cyan" "Updating K 2View Agent"
      helm install k2-agent . --set secrets.K2_MAILBOX_ID="$MAILBOX_ID" --set secrets.K2_MANAGER_URL="$MANAGER_URL" || true
      sleep 10
      if kubectl --namespace k2view-agent get deploy k2view-agent | grep -q "k2view-agent   1/1"
      then
        print_colored_bold "green" '√ K2-Agent Deployed successfully ...'
      else
        print_colored_bold "red" 'x K2-Agent Deployment failed ...'
      fi
      ;;
  esac 

}

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
  install_microk8s
  configure_microk8s
  install_k2agent
fi

        open /Applications/Docker.app
        brew install minikube
        brew install kubectl
        brew install helm
        minikube start --kubernetes-version=v1.26.3 
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


function configure_microk8s() {

echo ""
print_colored_bold "magenta" "The following tools will be installed:"
echo "\n
|Name            |Required |More info                                   |
|----------------|---------|--------------------------------------------|
|cert-manager    |Yes      |'https://cert-manager.io/'                  |
|NGINX Ingress   |Yes      |'https://docs.nginx.com/'                   |
|hostpath-storage|Yes      |                                            |
|docker registry |Yes      |'https://microk8s.io/docs/registry-built-in'|                           |
|metrics-server  |Yes      |                                            |
"
echo ""
echo ""
case "$OS" in 
  linux) 

      echo '''
      #!/bin/bash -x
      exec &>/tmp/configure_microk8s.log
      microk8s kubectl cluster-info
      code=0
      for addon in dns ingress cert-manager storage registry metrics-server
      do
        microk8s enable $addon
        echo  "\t\t Installing ${addon} ..."
        ((code+=$?))
      done
      microk8s kubectl get all --all-namespaces
      microk8s kubectl get nodes
      echo $code > /tmp/configure_microk8s.code
      ''' > /tmp/configure_microk8s.sh
      chmod +x /tmp/configure_microk8s.sh
      BUBBLES_FG_COLOR="green" spinner "Configuring Kubernetes ..." -- bash -c "/tmp/configure_microk8s.sh"
      code=`cat /tmp/configure_microk8s.code`

      if [[ $code -eq 0 ]]
      then
        print_colored_bold "green" '√ Kubernetes Configured successfully ...'
      else
        print_colored_bold "red" 'x Kubernetes Configuration failed ...'
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
  echo; echo
  print_in_box "cyan" "Installing K2View Agent"
  echo

  print_colored_bold "cyan" "Enter Mailbox URL: "
  read MANAGER_URL 
  print_colored_bold "cyan"  "Enter Mailbox ID: "
  read MAILBOX_ID

  # MANAGER_URL=`$GUM input --prompt "Enter Mailbox URL: " --prompt.foreground=212 --placeholder "https://cloud-dev.k2view.com/api/mailbox"`

  # MAILBOX_ID=`$GUM input --prompt "Enter Mailbox ID: " --prompt.foreground=212 --placeholder "12345678-0123-0123-0123-123456789012"`

case "$OS" in 
 linux)
    echo """
      #!/bin/bash -x
      exec &>/tmp/k2_agent_install.log
      rm -rf blueprints || true
      git clone https://github.com/k2view/blueprints.git
      cd blueprints/helm/k2view-agent
      # microk8s kubectl create namespace k2view-agent
      helm install k2-agent . --set secrets.K2_MAILBOX_ID=\"$MAILBOX_ID\" --set secrets.K2_MANAGER_URL=\"$MANAGER_URL\"
      """ > /tmp/k2agent_install.sh
      chmod +x /tmp/k2agent_install.sh
      BUBBLES_FG_COLOR="green" spinner "Installing K2View Agent ..." -- bash -c "/tmp/k2agent_install.sh"
      sleep 5
      if microk8s kubectl get deploy k2view-agent | grep -q "k2view-agent   1/1"
      then
        print_colored_bold "green" '√ K2-Agent Deployed successfully ...'
      else
        print_colored_bold "red" 'x K2-Agent Deployment failed ...'
      fi

      ;;
  MacOS)
      rm -rf blueprints || true
      git clone https://github.com/k2view/blueprints.git
      cd blueprints/helm/k2view-agent
      helm uninstall k2-agent &>/dev/null || true
      sleep 10
      helm install k2-agent . --set secrets.K2_MAILBOX_ID="$MAILBOX_ID" --set secrets.K2_MANAGER_URL="$MANAGER_URL" || true
      sleep 10
      if kubectl --namespace k2view-agent get deploy k2view-agent | grep -q "k2view-agent   1/1"
      then
        print_colored_bold "green" '√ K2-Agent Deployed successfully ...'
      else
        print_colored_bold "red" 'x K2-Agent Deployment failed ...'
      fi
      ;;
  esac 

}

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
  install_microk8s
  configure_microk8s
  install_k2agent
fi
