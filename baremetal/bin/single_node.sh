#!/bin/bash

export FORGROUND="#04B575"
GUM="../tools/linux/gum"

function rotating_prompt() {
  # Define a set of rotating characters
  ROTATING_CHARS="/-\|"
  local i=0
  tput civis
  while true; do
    printf "\r%c" "${ROTATING_CHARS:$i:1}"
    sleep 0.1
    ((i = (i + 1) % 4))
  done
}

function init() {
    # echo '''
    echo "Installing dependencies ..."
    DISTRIBUTION="Unknown"

    case "$(uname -s)" in
        Linux*)     OS=linux
                    GUM="../tools/linux/gum"
    		            echo "Installing $OS dependencies completed ..."
		                ;;
	
        Darwin*)    OS=MacOS
                    brew install gum &> /tmp/gum.installer.log
                    GUM="$(which gum)"
                ;;
        *)      OS="Unknown" ;;
    esac
  
    echo "Initializing Completed! "
  #  ''' > /tmp/init.sh
    # chmod +x /tmp/init.sh 
    # $GUM spin --show-output --spinner meter --title "Initialzing Installer  ..." -- bash -c "bash /tmp/init.sh"
    if [[ -x $GUM ]] 
    then
	   $GUM style --foreground "#00ff00" '√ Initialzing Completed Successfully ...' 
    else
	   $GUM style --foreground "#ff0000" 'x Initialzing Failed ...' 
    fi
}

function get_confirmation() {
	$GUM style --foreground=212 --border double --align center --width 50 --margin "1 1" --padding "1 1" "$1"
        $GUM confirm --affirmative="Proceed" --negative="Leave" # --prompt.foreground="#04B575" --selected.background="#04B575"
}


function install_git(){
 if git version &> /dev/null
 then
   $GUM style --foreground "#00ff00" '√ Git Source Control Already Installed ...'
 else
   case "$OS" in
    linux) 
      $GUM spin --show-output --spinner meter --title "Installing Git Source Control ..." -- apt install -y git
      ;;
    MacOS) 
      $GUM spin --show-output --spinner meter --title "Installing Git Source Control ..." -- brew install git 
      ;;
    esac
   if git version &> /dev/null
   then
           $GUM style --foreground "#00ff00" '√ Git installed successfully ...'
   else
           $GUM style --foreground "#ff0000" 'x Git installation failed ...'
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
    $GUM spin --show-output --spinner meter --title "Installing Docker ..." -- bash -c "/tmp/install_docker.sh"
    if docker ps &> /dev/null
    then
	   $GUM style --foreground "#00ff00" '√ Docker installed successfully ...' 
    else
	   $GUM style --foreground "#ff0000" 'x Docker installation failed ...' 
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
      $GUM spin --show-output --spinner meter --title "Installing Kubernetes ..." -- bash -c "/tmp/install_microk8s_linux.sh"
      if microk8s status  | grep -q "microk8s is running" 
      then
        $GUM style --foreground "#00ff00" '√ Kubernetes installed successfully ...' 
      else
        $GUM style --foreground "#ff0000" 'x Kubernetes installation failed ...' 
      fi
      ;;
  MacOS)
    echo '''
      #!/bin/bash -x
      exec &>/tmp/install_microk8s_mac.log 
      
      if ! brew list microk8s &> /dev/null
      then
        brew install kubectl
        brew install helm
        brew install ubuntu/microk8s/microk8s     
        multipass set local.driver=qemu
        microk8s install -y
        microk8s status --wait-ready
        if [ -r ~/.kube/config ]
        then       
          cp -p ~/.kube/config ~/.kube/config.backup.$$
          microk8s config >> ~/.kube/config
        else
          mkdir -p ~/.kube || true
          microk8s config >> ~/.kube/config
        fi
      fi

    ''' > /tmp/install_microk8s_mac.sh
    chmod +x /tmp/install_microk8s_mac.sh
    $GUM spin --show-output --spinner meter --title "Installing Kubernetes ..." -- bash -c "/tmp/install_microk8s_mac.sh"
    if microk8s status  | grep -q "microk8s is running" 
    then
      $GUM style --foreground "#00ff00" '√ Kubernetes installed successfully ...' 
    else
      $GUM style --foreground "#ff0000" 'x Kubernetes installation failed ...' 
    fi
    ;;
  esac
}


function configure_microk8s() {

echo ""
echo "## The following tools will be installed:
|Name            |Required |More info                                   |
|----------------|---------|--------------------------------------------|
|cert-manager    |Yes      |'https://cert-manager.io/'                  |
|NGINX Ingress   |Yes      |'https://docs.nginx.com/'                   |
|hostpath-storage|Yes      |                                            |
|docker registry |Yes      |'https://microk8s.io/docs/registry-built-in'|                           |
|metrics-server  |Yes      |                                            |

"  | $GUM format --type markdown

echo ""
echo ""
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
$GUM spin --show-output --spinner meter --title "Configuring Kubernetes ..." -- bash -c "/tmp/configure_microk8s.sh"
code=`cat /tmp/configure_microk8s.code`

if [[ $code -eq 0 ]]
then
  $GUM style --foreground "#00ff00" '√ Kubernetes Configured successfully ...'
else
  $GUM style --foreground "#ff0000" 'x Kubernetes Configuration failed ...'
fi
}


function install_k2agent() {
  $GUM style --foreground=212 --border double --align center --width 50 --margin "1 1" --padding "1 1" "Installing K2View Agent"

  MANAGER_URL=`$GUM input --prompt "Enter Mailbox URL: " --prompt.foreground=212 --placeholder "https://cloud-dev.k2view.com/api/mailbox"`

  MAILBOX_ID=`$GUM input --prompt "Enter Mailbox ID: " --prompt.foreground=212 --placeholder "12345678-0123-0123-0123-123456789012"`

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

  $GUM spin --show-output --spinner meter --title "Installing K2View Agent ..." -- bash -c "/tmp/k2agent_install.sh"

  sleep 5
  if microk8s kubectl get deploy k2view-agent | grep -q "k2view-agent   1/1"
  then
    $GUM style --foreground "#00ff00" '√ K2-Agent Deployed successfully ...'
  else
    $GUM style --foreground "#ff0000" 'x K2-Agent Deployment failed ...'
  fi

}

clear
init
cat ../static/logo.ans
echo ; echo

echo "## The following tools will be installed:
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
"  | $GUM format --type markdown

if ! get_confirmation "Installing Kubernetes Components"
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