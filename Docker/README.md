# Docker Compose for Fabric Studio
This repository contains Docker Compose configurations for different Fabric Studio use cases.

## Prerequisites
1. Docker - [Docker install guide](https://docs.docker.com/engine/install/)
2. Docker Compose - [Docker Compose install guide](https://docs.docker.com/compose/install/)
3. K2view Fabric or Studio images.

## docker-compose.yaml
This file defines and configures all the services needed for this use case. It specifies how these services are built, how they interact, and any volumes or networks they use.

### Environment
These parameters can be added to services.fabric.environment.
#### Git
GIT_TOKEN  - Token for cloning from GitHub repo. \
GIT_REPO   - GitHub repo URL (without https) to clone project from. \
GIT_BRANCH - The git branch to clone, default master. 

> will execute ```git clone --single-branch -b "${GIT_BRANCH}" "https://${GIT_TOKEN}@${GIT_REPO}" ```

#### Fabric
CONFIG_UPDATE_FILE     - Path to file to update config.ini, can override config that changed based on other env var. \
REMOVE_MODULES         - List of modules to remove, format module,module \
MONITORING             - Setup monitoring, default|true will setup default JMX and node exporter.

##### adminInitialCredentials
ADMIN_USER             - Init first admin user string in format "user/password" (will be written to adminInitialCredentials file).

#### Certificates
FABRIC_KEYSTORE_PATH   - Path for keystore that Fabric will use, default ~/.keystore \
FABRIC_KEYSTORE_PASS   - Password for keystore that Fabric will use \
FABRIC_TRUSTSTORE_PATH - Path for truststore that Fabric will use, default ${FABRIC_HOME}/config/.truststore \
FABRIC_TRUSTSTORE_PASS - Password for truststore that Fabric will use. \
ADD_CERTS_FILE         - List of certs to add, Format: addkey/addtrust|ALIAS|PATH for each line.


## .env
This file used to configure environment variables for the services defined in `docker-compose.yaml`.

## Initialization
Prepare directories for persistent volumes for the containers, setting the appropriate permissions for the application users.
```bash
# Create Fabric persistent directory and set permissions
mkdir -p ./fabric/workspace/ && chown 1000:1000 ./fabric/workspace/

# Create Neo4j persistent directory and set permissions
mkdir ./neo4j/ && chown 7474:7474 ./neo4j/

# Create PostgreSQL persistent directory and set permissions
mkdir ./postgres/ && chown root:root ./postgres/

# Create Cassandra persistent directory and set permissions
mkdir ./cassandra/ && chown root:root ./cassandra/
```

## studio.config
This configuration file is used for custom settings specific to this use case. \
Each line format "[section]|[key]|[value]|<{ADD|}>" to update config.ini


## Fabric studio
Docker compose for simple fabric studio with Neo4j for data discovery and SQLITE for system DB.

### Start space
```bash
cd fabric-studio
docker-compose --project-name space_name up -d
```

## Fabric studio pg
Docker compose for simple fabric studio with Neo4j for data discovery and Postgres for system DB and TDM.

### Start space
```bash
cd fabric-studio-pg
docker-compose --project-name space_name up -d
```

## Fabric studio cass
Docker compose for simple fabric studio with Neo4j for data discovery and Cassandra for system DB and TDM.

### Start space
```bash
cd fabric-studio-cass
docker-compose --project-name space_name up -d
```
