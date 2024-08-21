# Docker compose for Fabric studio
This repository contains Docker Compose configurations for different Fabric Studio use cases.

## Pre-requisites
1. Docker - [Docker install guide](https://docs.docker.com/engine/install/)
2. Docker compose - [docker-compose install guide](https://docs.docker.com/compose/install/)

## docker-compose.yaml
This file defines and configures all the services needed for this use case. It specifies how these services are built, how they interact, and any volumes or networks they use.

### environment
This parameters can be added to services.fabric.environment .
#### Git
GIT_TOKEN  - Token for clone from github repo. \
GIT_REPO   - Github repo url (without https) to clone project from. \
GIT_BRANCH - The git branch to clone, default master. 

> will execute ```git clone --single-branch -b "${GIT_BRANCH}" "https://${GIT_TOKEN}@${GIT_REPO}" ```

#### Fabric
CONFIG_UPDATE_FILE     - Path to file to update config.ini, can overide conf that changed based on other env var. \
REMOVE_MODULES         - List of modules to remove, format module,module \
MONITORING             - setup monitoring, default|true will setup default jmx and node exporter.

##### adminInitialCredentials
ADMIN_USER             - Init first admin user string in format "user/password" (will be written to adminInitialCredentials file).

#### certificates
FABRIC_KEYSTORE_PATH   - Path for key store that Fabric will use, default ~/.keystore \
FABRIC_KEYSTORE_PASS   - Password for key store that Fabric will use, default "Q1w2e3r4t5" \
FABRIC_TRUSTSTORE_PATH - Path for trust store that Fabric will use, default ${FABRIC_HOME}/config/.truststore \
FABRIC_TRUSTSTORE_PASS - Password for trust store that Fabric will use, default "changeit". \
ADD_CERTS_FILE         - List of certs to add, Format: addkey/addtrust|ALIAS|PATH for each line.


## .env
This is a dotenv file used to configure environment variables for the services defined in `docker-compose.yaml`.

## studio.config
This configuration file is used for custom settings specific to this use case. \
Each line format "[section]|[key]|[value]|<{ADD|}>" to update config.ini


## Fabric studio
Docker compose for simple fabric studio with Neo4j for data discovery and SQLITE for system DB
### Start space
```bash
cd fabric-studio
docker-compose --project-name space_name up -d
```

## Fabric studio pg
Docker compose for simple fabric studio with Neo4j for data discovery and PG for system DB and TDM
### Start space
```bash
cd fabric-studio-pg
docker-compose --project-name space_name up -d
```
