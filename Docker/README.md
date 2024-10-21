# Docker Compose for Fabric Studio
This repository contains Docker Compose required to run Fabric Studio. We also provide an 'easy-to-launch' script along with the [_K2view-ingress_](#k2vingress-composeyaml), a secondary Docker Compose file that helps managing multiple _Spaces_ (Fabric Studio instances) with user-friendly connectivity endpoints

## Pre-requisites
1. Docker (with Compose plugin) - [Docker install guide](https://docs.docker.com/engine/install/)
2. Preload the Fabric image

> Fabric images can be pulled from K2view's registry. Alternatively, offline images might be provided for cases in which the host does not have internet connectivity. Contact K2view to request Nexus credentials or to get offline images


## k2vingress-compose.yaml
This Docker Compose file deploys the necessary resources to run an application proxy that makes easy to access your _Spaces_. Instead of keeping tracking of all those random ports, you can just hit http://localhost/space-name/ and Traefik will take you there!

### Starting Traefik
Traefik will start automatically right after you create your first _Space_ but it will also check whenever a new _Space_ is created, if not running it will start it again

> __Note:__ Traefik relies on a Docker network that gets created during a _Space_ creation, therefore Traefik must be started __after__ the _Space_

### Restarting Traefik
To restart Traefik (i.e. after adding your own SSL certificates), just run the command below:

```bash
docker compose -f k2vingress-compose.yaml restart
```

### SSL certificate

By default, Traefik will use its own self-signed TLS certificates for HTTPS connections. If you want to use your own certificate, everything is already pre-configure, you just need to create a subdirectory `ssl-certs` and place your certificate[[1]](#1) (must be named `cert.cer`) and private key (must be named `cert.key`) inside it. After that, just uncomment the parameters `certFile` and `keyFile` in the file `tls-config.yaml`

> <a id='1'></a>[1] The TLS certificate must be in PEM format and it should contain the server certificate and the root certificate (plus all intermediate certificates, if any)


## compose.yaml
This file defines and configures all the services needed for the desired use case. It specifies how these services are built, how they interact with each other, and any volumes or networks they use

### environment
This parameters can be added to services.fabric.environment
#### Git
GIT_TOKEN  - Token for clone fron github repo \
GIT_REPO   - Github repo url (without https) to clone project from \
GIT_BRANCH - The git branch to clone, default master 

> will execute `git clone --single-branch -b "${GIT_BRANCH}" "https://${GIT_TOKEN}@${GIT_REPO}"`

#### Fabric
CONFIG_UPDATE_FILE     - Path to file to update config.ini, can overide conf that changed based on other env var \
REMOVE_MODULES         - List of modules to remove, format module,module \
MONITORING             - setup monitoring, default|true will setup default jmx and node exporter

##### adminInitialCredentials
ADMIN_USER             - Init first admin user string in format "user/password" (will be written to adminInitialCredentials file)

#### certificates
FABRIC_KEYSTORE_PATH   - Path for key store that Fabric will use, default ~/.keystore \
FABRIC_KEYSTORE_PASS   - Password for key store that Fabric will use, default "Q1w2e3r4t5" \
FABRIC_TRUSTSTORE_PATH - Path for trust store that Fabric will use, default ${FABRIC_HOME}/config/.truststore \
FABRIC_TRUSTSTORE_PASS - Password for trust store that Fabric will use, default "changeit" \
ADD_CERTS_FILE         - List of certs to add, Format: addkey/addtrust|ALIAS|PATH for each line


## .env
This is a dotenv file used to configure environment variables for the services defined in `compose.yaml` and `k2vingress-compose.yaml`


## .config files
These configuration files contain required or custom settings used by Fabric \
Each line format "[section]|[key]|[value]|<{ADD|}>" to update config.ini

### common.config
Contains settings that will be applied that are common to all use cases

### studio*.config
Contains profile-specific settings


## Space Profiles and its use case

### studio (general use)
The default profile, launches Fabric Studio with SQLite as System DB \
The standard _Space_ can be created by simple running `docker compose up -d`. If you planning on running multiple _Spaces_, just use our [`k2space.sh`](#k2spacesh) script as below:

```bash
./k2space.sh create space-name
```

### studio_pg (the TDM profile)
Fabric Studio with PostgreSQL as System DB and TDM

```bash
./k2space.sh create --profile=studio_pg space-name
```

### studio_pg_cass (the TDM profile with Apache Cassandra)
Fabric Studio with Apache Cassandra as System DB and PostgreSQL for TDM tasks

```bash
./k2space.sh create --profile=studio_pg_cass space-name
```


## k2space.sh
This tool makes easy creating and deleting _Spaces_. You can also use to list and get information of all existing _Spaces_

Usage: `./k2space.sh COMMAND [OPTIONS] SPACE_NAME`

The following COMMANDs can be used:

### list 
```bash
./k2space.sh list
```
List all _Spaces_, and some information like profile, state (running / stopped), Fabric Studio port and the URL that can be used to access Fabric Studio if Traefik is running

### create
```bash
./k2space.sh create [--profile=profile-name] space-name
```
Launch a _Space_ "space-name" (optionally, with the selected _Space Profile_)

### destroy
```bash
./k2space.sh destroy space-name
```
Delete the _Space_ "space-name". For security reasons, it will not delete the persistent files used by Fabric Studio (and databases). Those will have to be manually deleted (they are located in `persisten-data/space-name`)


## Ports
### Fabric
A random port will be assigned to each instance of tje Fabric Studio web UI and will bind to the container port 3213

### Traefik (ingress)
In order to facilitate accessing the _Space_ by its name, we provide infrastructure required by [Traefik](https://traefik.io/traefik/), a reverse proxy that uses the following ports:
| Protocol | Port | Description |
|----------|------|-------------|
| HTTP     | 8080 | Traefik dashboard |
| HTTP     |   80 | HTTP listener     |
| HTTPS    |  443 | HTTPS listener    |

## fabric-init container

This temporary container is used to set the proper ownership of the persistent-data's _Space_ folder. After it's execution, it should exit automatically
