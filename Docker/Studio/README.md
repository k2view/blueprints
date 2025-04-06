# Docker Compose Runtime for K2view Fabric Web Studio, Version 2.0
This **README** describes the Docker Compose Runtime used to host K2view Fabric Web Studio. It covers setup, components, installation options, and features. 

**About K2view Fabric Web Studio**

K2view Fabric Web Studio provides developers with a unified platform for designing, building, and managing data-driven solutions. The Docker Compose Runtime's multi-space capability enables the creation of data management applications supporting multiple developers.  Developers benefit from robust data management and orchestration tools for real-time integration, seamless testing, and debugging features that accelerate project completion and deliver collaborative functionality that supports multiple users. 

Docker Compose Runtime for K2view Fabric Web Studio, Version 2.0, supports multiple space creation and provides a simplified URL for accessing Fabric Spaces using a URL context rather than a subdomain-based URL. 

## The Components

1. **Docker Compose Runtime**: Fabric Web Studio can be installed within a Docker Compose Runtime environment. Docker and its Compose plugin provide the ability to run Web Studio for which three profiles can be selected, an embedded Fabric engine, and a Traefic reverse proxy, that combined provide the means to create multiple Fabric Spaces within the Docker Compose Runtime. 
2. **Fabric Image**: The Docker Compose Runtime is certified to run specific Fabric releases you can download from K2view's Nexus Container Registry.
3. **K2view Fabric Web Studio**: Available with four profiles that each embeds Fabric.
   1. **studio.config**. The default Web Studio profile embeds SQLite for its System DB.
   2. **studio_pg.config**. A generic Studio or TDM profile - Web Studio with PostgreSQL for use with its System DB and TDM.
   3. **studio_cass.config**. A TDM profile - Web Studio with Cassandra used for the System DB and TDM.
   4. **studio_pg_cass.config**. A TDM profile incorporating Apache Cassandra for its System DB and PostgreSQL for TDM tasks.
4. **Traefik Reverse Proxy** allows you to route requests to your various Fabric Spaces running within your Docker Compose Runtime at http(s)://[host]/[spacename]/. 

## Prerequisites

The Docker Compose Runtime for Fabric Services has specific prerequisites. 

**Host Machine**

The supported processor architecture is AMD64.  Fabric does not support ARM-based processors.

The amount of RAM you need will depend on your use case. 32GB of memory should suffice to run your Docker Compose Runtime for Fabric Web Studio and the necessary integration. A 2GB Heap is allocated by default, which can be overridden. 

**3rd Party Software**

1. You need to install a Git client on the computer by downloading and installing it. You can download it from https://git-scm.com/downloads and follow the instructions provided at https://git-scm.com/book/en/v2/Getting-Started-Installing-Git

2. You need to install and run Docker, which you can download from https://docs.docker.com/engine/install/.
3. To install Docker and Docker Compose, which will host Docker Compose Runtime for Fabric Services, you need to have administrative rights on the machine:
   1. Linux: root or sudo access granting you administrative rights
   2. Windows: you need administrator rights on your machine

4. The Docker Compose Runtime for Fabric Services requires Linux. You can also use Microsoft Windows if you use the Windows Subsystem for Linux (WSL) in conjunction with a Linux distribution. Instructions are provided in the document’s Windows section. 
5. You need to install the Docker Compose Plugin. Please note that if you install Docker Desktop, Docker Compose is bundled. See https://docs.docker.com/compose/install/. Please use the native Docker Compose plugin and not the Python-based docker-compose utility. 

**K2view Software**

1. The installation presumes you have Internet access, so you can obtain Fabric images from the K2view Nexus Container Registry and perform a Git clone on your machine. 
2. To obtain a Fabric Studio docker image, you need a K2view Nexus account. Your K2view representative can arrange this for you. 

**Internet Access is Required**

Internet access is required to perform this installation. You will need access to:

1. Github.com to clone K2view’s blueprints at https://github.com/k2view/blueprints.git
2. K2view’s Nexus Docker Image repository at https://docker.share.cloud.k2view.com
3. If you plan to install TDM, you need access to K2view’s Exchange.

## Documentation
The latest documentation is located at this location https://support.k2view.com/Academy/articles/98_maintenance_and_operational/Installations/dcr_web_studio/version2/About.html. 

## What's in this Package

1. README.md - This document
2. K2space.sh - A Bash shell script used to create, list, and destroy spaces defined by Web Studio profiles. This script is used to start Fabric and the embedded Traefik reverse proxy. It can allocate additional heap space if required and override the default Fabric version specified in the .env file.
3. .env file - define various Fabric and Git parameters
4. common.config file - define various Fabric and runtime configurations
5. Studio_*.config files - the Fabric Profiles to choose from
6. YAML files are used to configure the Fabric and Traefik services. You can use the tls-config.yaml file to configure the TLS certificate and private key. 


## Things to Configure
1. Git Configuration - This is described in Step 5 - Configuring Git and TLS
2. TLS Certificate and Private Key Configuration - Optional because Traefik uses its own self-signed TLS certificate for HTTPS connections by default.  One is created for you by default for the machine.  To provide your own, please refer to Step 5. 


## Things to Know
1. Default administrator credentials are

   1. Username: admin
   2. Password: admin

2. Ports: Traefik employs the following ports:

   | Protocol | Port | Description       |
   | -------- | ---- | ----------------- |
   | HTTP     | 8080 | Traefik dashboard |
   | HTTP     | 80   | HTTP listener     |
   | HTTPS    | 443  | HTTPS listener    |


## Installation

There are five steps to get Fabric Web Studio up and running within the Fabric Docker Compose Runtime environment.

* Step 1: Install and Validate Docker and Docker Compose Runtime
* Step 2: Download the K2view Blueprints
* Step 3: Download
* Step 4: Configure Git and TLS
* Step 5: Select a Fabric Blueprint Profile to Use
* Step 6: Log in to K2view's Nexus Container Registry
* Step 7: Create and Launch a Fabric Space
* Step 8: Access Web Studio
* Docker Image Offline Package Download

**Before you proceed, confirm that you have a K2view Nexus Container Registry Account**

You need to obtain credentials to access the K2view Nexus. Your K2view account representative can arrange this for you. If you do not have access, please contact your K2view representative, who can provide steps to help you through this process.

### **Step 1**: Install and Validate Docker and Docker Compose Runtime

If Docker has not already been installed on your machine, please refer to the <a href="/articles/98_maintenance_and_operational/Installations/dcr_web_studio/version2/6-Docker-Compose.html">Docker and Docker Compose Installation</a> topic. 

The easiest and recommended way to get Docker Compose is to install Docker Desktop. Docker Desktop includes Docker Compose, Docker Engine, and Docker CLI, and all prerequisites for Compose. Please also refer to the <a href="/articles/98_maintenance_and_operational/Installations/dcr_web_studio/version2/6-Docker-Compose.html">Docker and Docker Compose Installation</a> topic.

### **Step 2**: Download the K2view Blueprints

After installing a Git client on your machine, you must “clone” the K2view Blueprints to "download" them. These blueprints incorporate the Fabric Docker Compose Runtime installation files. The K2view Blueprints are hosted on GitHub.com (Internet access is required). 

Where you clone the files depends on the operating system you use. There are different instructions depending if you are using Linux or MacOS, than those for Microsoft Windows.

Please note that persistent files created by Fabric Web Studio and the database instance you install will host their data in your installation directory's "persistent-data" folder (e.g., K2view/Studio/persistent-data). Your Fabric Space's data is stored in the persistent-data/spacename directory. The respective space's directory will contain data if you create multiple spaces. The location of the persistent data directory is configured in the `.env` file and set by default to be in the Fabric Web Studio installation directory. This is a per-space configuration. 

#### Using Linux or MacOS

*Select a Base Directory for your Download and Installation Directory Locations*

First, please select a location to download the K2view Blueprint content. This *base* directory can also hold the Fabric Web Studio installation directory from where it will run. 

Use the *change directory* command on your shell to switch to the designated base directory:

```bash
cd [base directory]
```

*Create your Download and Installation Directory Location*

Using a shell, create a "K2view" directory to download K2view's Blueprints. You can also use the K2view directory to hold the K2view Fabric Web Studio Installation directory. We recommend the use of K2view for this directory.

```bash
mkdir K2view
```

#### Using Microsoft Windows

> Using a Linux file system is highly recommended if you're installing on Microsoft Windows. It can be installed with the Windows subsystem for Linux (WSL) and a Linux distribution such as Ubuntu. Doing so avoids performance problems using Docker on a native Windows file system. Please refer to the <a href="/articles/98_maintenance_and_operational/Installations/dcr_web_studio/version2/6-Docker-Compose.html">Docker and Docker Compose Installation</a> topic for instructions on how to install WSL and a Linux distribution.
>
> Not only should you avoid using the Windows file system, but you should also avoid using WSL's `/mnt/c` mounted Windows file system. Instead, you should use the file system of the Linux distribution you installed, e.g., `/home/username/K2view`, to download and install the configuration files and hold the workspace data created by Fabric Web Studio. 

#### Create the Base Directory

*Identify the Name of your WSL Linux Distribution*

First, find the path to your Linux distribution's location (e.g., Ubuntu used in these examples) by running `wsl --list` to obtain its name and then changing to its directory. If you enabled Windows Explorer navigation when you installed WSL, you can navigate directly to it under Explorer's "Linux" sidebar icon.

```bash
wsl --list
```
This will return the following. Ubuntu will be shown if you installed it as your Linux distribution. 

```bash
Windows Subsystem for Linux Distributions:
docker-desktop (Default)
Ubuntu
```

*Change Directory to your Linux WSL Distribution*

Then, change directory to `\\wsl$\[distributionName]` - in this example "Ubuntu"

```bash
cd \\wsl$\Ubuntu
```

*Select a Base Directory for your Download and Installation Directory Locations*

Please select a directory where you will download the K2view Blueprints and install Fabric Web Studio. You can use your home directory in `\\wsl$\ubuntu\home\[username]`. For example:

```bash
cd \\wsl$\Ubuntu\home\[username]
```

*Create your Download and Installation Directory Locations*

Using a shell, create a `K2view` directory to download K2view's Blueprints. You can also use the K2view directory to hold the K2view Fabric Web Studio Installation directory. We recommend the use of K2view for this directory.

```bash
mkdir K2view
```

### **Step 3**: Download

There are two options to obtain the Docker Compose Runtime for Fabric Web Studio. You can download a zip file or clone the content from K2view's Blueprints.

#### Option: Download The Latest Version of Docker Compose Runtime for Fabric Web Studio

You can download the latest version of Docker Compose Runtime for Fabric Web Studio from this location: 

```bash
https://nexus.share.cloud.k2view.com/repository/k2view-download/web-studio/Studio-latest.zip
```

Then, change the directory to the K2view directory. Copy `Studio-latest.zip` to this directory, and unzip `Studio-latest.zip` to this directory. Then rename the `Studio-latest.zip` directory as `Studio`.

```bash
cd K2view
# copy Studio-latest.zip to this directory
# unzip Studio-latest.zip to this directory
```

The Studio directory contains the configuration, YAML, and the K2Space.sh script files to configure and create your Fabric Web Studio spaces. Please refer to the <a href="/articles/98_maintenance_and_operational/Installations/dcr_web_studio/version2/Installation.html#whats-in-this-package">What's in this Package</a> topic above for details about these files. 

You can now skip to Step 4.

#### Option: Clone the K2view Blueprints 

Using a shell, change your directory to your K2view directory and run the following command to clone K2view Blueprints (this requires a prior installation of a Git client):

Using the prior example of the `K2view` directory:

```bash
cd K2view
git clone https://github.com/k2view/blueprints.git
```

This will create a `blueprints` directory with various subdirectories. The `Studio` subdirectory holds the Fabric Web Studio installation files. 

#### Create an Installation Directory and Copy the Fabric Web Studio Files

We recommend running Fabric Web Studio within the `Studio` directory of the `K2view` directory. From the K2view directory, copy the `blueprints/Studio` directory as `Studio`. 

*Using Linux or MacOS*

From the K2view directory

```bash
cp -r blueprints/Studio/ Studio
```
*Using the Microsoft Windows PowerShell*

You must use the Linux file system to hold the Studio directory if using Microsoft Windows. Please review <a href="/articles/98_maintenance_and_operational/Installations/dcr_web_studio/version2/Installation.html#step-2-download-the-k2view-blueprints">Step 2's</a> "Using Microsoft Windows" section for details.  

```bash
cp -r blueprints\Studio\ Studio
```

The Studio directory contains the configuration, YAML, and the K2Space.sh script files to configure and create your Fabric Web Studio spaces. Please refer to the <a href="/articles/98_maintenance_and_operational/Installations/dcr_web_studio/version2/Installation.html#whats-in-this-package">What's in this Package</a> topic above for details about these files. 

### **Step 4**: Configure Git and TLS

#### Configuring Git

You should consider a few things, including configuring a Git repository for your project. Though not mandatory, it is a best practice to store your project files in Git (or in a Git-compliant code repository). 

You can configure it before the creation of Fabric Space via the .env file. You can do so after starting Fabric Web Studio using its built-in Git client. Performing this step within Fabric Web Studio.

**Configuring Git before Creating your Fabric Space**

To do this, you must provide a token, a path to your Git repository, and the appropriate branch. You can create your initial space without this configuration. However, to configure it later, you must configure these values and recreate your space. 

To configure Git, open the .env file and specify the following in the Git Integration section:

  - **GIT_REPO** - the Git repository URI to clone and store your project data. 
    - **Important Note: Please do not prepend "HTTPS://" before the repository's URI**.

  - **GIT_BRANCH** - the Git branch to use; the default is 'master'.
  - **GIT_TOKEN** - the token used to authenticate to your Git repository.  
  - **GIT_USERNAME** - the user name used to authenticate to your Git repository.

Fabric Web Studio will use these parameters to run an initial clone and Git operations. The initial clone performed will be: 

```bash
git clone --single-branch -b "${GIT_BRANCH}" "https://${GIT_TOKEN}@${GIT_REPO}"
```

#### Configuring TLS

Traefik will use its own self-signed TLS certificates for HTTPS connections by default. The Certificate is created for you by default for the machine. If you want to use a certificate created by your organization, everything is pre-configured for you to do so. You need to open the `ssl-certs` directory within the installation package's directory (e.g., `K2view/Studio`), where you will find the `ssl-certs` directory and replace the certificate and private key files. 

These files must be named `cert.cer` and `cert.key`, respectively. The TLS certificate must be in PEM format and contain the server, root, and intermediate certificates, should they exist.

If you perform this step after the initial installation, you must restart Fabric for these to take effect.

### **Step 5**: Select a Fabric Blueprint Profile to Use

There are four profiles, each of which embeds Fabric. The default is 'studio'.  

1. **studio**. The default Web Studio profile embeds SQLite for its System DB.
2. **studio_pg**. A generic Studio or TDM profile - Web Studio with PostgreSQL for use with its System DB and TDM.
3. **studio_cass**. A TDM profile - Web Studio with Cassandra used for the System DB and TDM.
4. **studio_pg_cass**. A TDM profile incorporating Apache Cassandra for its System DB and PostgreSQL for TDM tasks.

Using the default profile, 'studio', you will not need to provide the profile on the `k2space.sh` command line. Otherwise, you will need to enter one of the other profiles. 


### **Step 6**: Log in to K2view's Nexus Container Registry

*Prerequisite*

Docker and its Compose extension must be running on the server to perform this step. 

Using the K2view Nexus Container Registry account provided to you, run the following command from the same directory that you have performed the git clone command \- please note that you need to use sudo on some Linux systems depending on your permissions:

```bash
docker login -u [YourAccount] https://docker.share.cloud.k2view.com
```

You will be asked to enter your password.

## Docker Image Offline Package Download

The Docker login command and the `k2space.sh` bash shell script require Internet access to log in and pull K2view Fabric images from the K2view Nexus Container Registry at docker.share.cloud.k2view.com.

Should you not have Internet connectivity, you can use this Docker Image Offline Package Download procedure to download the file on a separate machine and copy it to the local installation directory. The file, a Docker Image, is about 1.9GB in size. The version of the image depends on what is configured in the `.env` file. You will need to download the same version.

Following this procedure, when the `k2space.sh` script runs, the expected file will have already been loaded on the local machine and will not need to be downloaded from the Internet.

Here is the flow:
1. Save / compress the desired Image tag:

`docker save docker.share.cloud.k2view.com/k2view/fabric-studio:8.1.7_22 | gzip > k2view_fabric-studio_8.1.7_22.tar.gz`

2. Copy the `k2view_fabric-studio_8.1.7_22.tar.gz` file to the target machine.

3. On the target machine, load the image locally:

`docker load -i k2view_fabric-studio_8.1.7_22.tar.gz`

Doing this before you run the first `k2space.sh` command ensures the file will be present on your system to create your first space and avoids downloading the file from the Internet.

**Note**: The Docker login command and the k2space.sh bash shell script require Internet access to log in and pull K2view Fabric images from the K2view Nexus Container Registry at docker.share.cloud.k2view.com. 

### **Step 7**: Create and Launch a Fabric Space

#### **Space Naming**

When creating a space, its name must consist of only lowercase alphanumeric characters, hyphens, and underscores and start with either a letter or a number. You cannot use uppercase characters. 

#### **Running k2space.sh on Microsoft Windows**

The `k2space.sh` file is a `bash` script. A Windows PowerShell-compatible script is not yet available. To run the `k2space.sh` script, start the `Git Bash` applications offered by Git. Using `Git Bash` you can run the script after you change the directory to its location. 

If you have Git integration enabled within Windows Explorer, you can start `Git Bash` from Windows Explorer by navigating to the script's directory, right-clicking within the Explorer's window, and selecting 'Show more options'. This will display an 'Open Git Bash here' menu item that can be used to start `Git Bash` to run `k2start.sh`. 

#### Create Spaces on Your Server

First, change the directory to your Installation directory, e.g., `Studio`

```bash
cd Studio
```

**Ensuring you have Read-Other Permission on all .config files on Linux**
You may need to have Read-Other permissions on the .config files on a Linux system. To do so use the `chmod 644 [file]` command using:

```bash
 chmod 644 *.config
```

**Ensuring you have Execute Permission on Linux**
You may need to make k2space.sh executable on a Linux system to do so use the `chmod` command using:

```bash
 chmod 700 k2space.sh
```

**Running the k2space.sh Script**
You can create multiple Fabric spaces on your server. To do so, use the `k2space.sh` script as shown here. 

 > On some Linux systems, you may need to prefix the command with `sudo`.

```bash
 ./k2space.sh create [--profile=profile-name] spacename
```

You can omit passing in a `-- profile` parameter to use the default profile, 'studio'. 

```bash
 ./k2space.sh create spacename
```

Otherwise, please use the following --profile commands:

1. **studio_pg**. A generic Studio or TDM profile - Web Studio with PostgreSQL for use with its System DB and TDM. 
   
```bash
 ./k2space.sh create --profile=studio_pg spacename
```

2. **studio_cass**. A TDM profile - Web Studio with Cassandra used for the System DB and TDM. 
   
```bash
 ./k2space.sh create --profile=studio_cass spacename
```

3. **studio_pg_cass**. A TDM profile incorporating Apache Cassandra for its System. 

```bash
 ./k2space.sh create --profile=studio_pg_cass spacename
```

#### The Initial Installation

You will download Fabric from the K2view Nexus Container Registry when creating your first Fabric Space. While this is happening, you should observe the following.

```bash
$ ./k2space.sh create myspace
[+] Running 0/3
 - fabric Pulling                                    177.1s
 - init-fabric [⡀] 318.8MB / 1.964GB Pulling         177.1s
   - e7a390e229e3 Downloading [========> ]  318.8MB/1.964GB   
```


### **Step 8**: Access Web Studio

You have completed the installation and are ready to access Fabric Web Studio over HTTP or HTTPS.

Open a browser and connect to `http://localhost/spacename`. 

You can also connect to Fabric remotely, using `https://[hostname or ip address]/spacename`.

> Traefik will default use its own self-signed TLS certificates for HTTPS connections. The Certificate is created for you by default for the machine. If you want to use a certificate created by your organization, everything is pre-configured for you to do so. See the "Configuring TLS" topic above for instructions. 

When presented with the login screen, enter: 

  - Username: admin
  - Password: admin

If you access Fabric Web Studio, you have successfully installed it. 


## Operating and Managing Docker Compose Runtime for Fabric Web Studio

### Fabric Spaces
This k2space.sh shell script makes it easy to create and delete Fabric. You can also use it to list and get information about existing Fabric Spaces using: 

```bash
Usage: `./k2space.sh COMMAND [OPTIONS] SPACE_NAME`
```

**Listing your Spaces**
List all Fabric Spaces, and some information like profile, state (running / stopped), Web Studio port, and the URL that can be used to access Web Studio if Traefik is running.

Use: 
```bash
./k2space.sh list
```

**Creating Additional Spaces**
Launch a Fabric Space "spacename" (optionally, with the selected Space Profile).

Use: 
```bash
./k2space.sh create [--profile=profile-name] spacename
```

After creating your first Space, you will need to wait for Fabric to come up. Unless it up you may get a 404 error if Traefik hasn't yet processed its new ingress rules which may take a few seconds. Otherwise, you might get a 502 error if Traefik is ready but Fabric is not yet ready. Give it some time.

```bash
docker compose -f k2vingress-compose.yaml restart
```

**Starting a Space**

To start a Fabric space use: 

```bash
./k2space.sh start spacename
```

**Stopping a Space**

To stop a Fabric space use: 

```bash
./k2space.sh stop spacename
```

**Destroying a Space**
Delete the Fabric Space "spacename". 

It will **not delete the persistent files** created by Web Studio and your database(s). You must manually delete them. These are located in the `persistent-data/spacename` directory.

Use: 
```bash
./k2space.sh destroy spacename
```

### Traefik
#### Starting Traefik
Traefik starts automatically after you create your first Fabric Space. It will also check whenever a new Fabric Space is created. If it is not running it will be started automatically.

> __Note:__ Traefik relies on the Docker network created during the creation of a Fabric Space. Therefore, It must be started __after__ the Fabric Space.

#### Restarting Traefik
To restart Traefik (e.g., after configuring your TSL certificates)  run the command below:

```bash
docker compose -f k2vingress-compose.yaml restart
```

### Adding Users

You are ready to add users. You can experiment with the built-in System DB (e.g., Postgres or Cassandra data stores). We recommend using alternate authentication providers rather than using built-in providers. 

To use the built-in authentication provider, navigate to the [Web Admin App](https://support.k2view.com/Academy/articles/30_web_framework/03_web_admin_application.html). Select the Security tab. Select the Users tab and add a user. Select the Roles tab, create a new role (e.g., User), and then assign Fabric permissions to the newly created role. 

The Docker Compose Runtime for K2view Fabric Web Studio employs underlying Fabric security capabilities and configurations. Fabric works with several authentication providers. Each authenticator is responsible for user authentication and managing user IDs and roles.

Following are the supported authentication providers as described [here](https://support.k2view.com/Academy/articles/26_fabric_security/07_user_IAM_overview.html). 

- **Fabric**: Fabric stores users' credentials in a System DB table using Postgres. Passwords are stored securely in this table using a salted password hashing technique. By default, Fabric is configured to use a 32-byte salt length. When Cassandra is used, the provider is named Cassandra.
- **LDAP**: Fabric authentication is performed via LDAP integration as described [here](https://support.k2view.com/Academy/articles/26_fabric_security/11_user_IAM_LDAP.html).
- **ADLDAP** (Microsoft Active Directory): Fabric authentication is performed via Active Directory integration as described [here](https://support.k2view.com/Academy/articles/26_fabric_security/11_user_IAM_LDAP.html).
- **SAML**:  Fabric authentication is performed via SAML IDP integration as described [here](https://support.k2view.com/Academy/articles/26_fabric_security/09_user_IAM_SAML_fundamentals_and_terms.html). SAML provides the means of offering an SSO experience to users using, for example, Microsoft Entra ID and Okta. See the [Microsoft Entra ID](https://support.k2view.com/Academy/articles/26_fabric_security/14_user_IAM_SAML_Azure_AD_setup.html) and [Okta](https://support.k2view.com/Academy/articles/26_fabric_security/15_user_IAM_SAML_Okta_setup.html) integration descriptions to learn more about Fabric SSO support. 

### Upgrading to a Later Fabric Version

K2view certifies specific versions. To obtain the list of supported Fabric versions, please create a K2view support ticket via the [My Tickets](https://k2view.freshdesk.com/a/dashboard/default) link from the [K2view Support Site](https://support.k2view.com/).

The approach is simple: 1) push all changes to Git, and 2) create a new Fabric Space with the desired certified version of Fabric. 

## Reference Information

### k2space.sh OPTIONS Reference

Here are the command options for k2space.sh:

| Option            | Description                                                  |
| ----------------- | ------------------------------------------------------------ |
| --profile=        | Allows you to select the desired Fabric Space Profile        |
| --heap=           | Allows you to override the default 2GB allocated heap size   |
| --fabric-version= | Allows you to override the Fabric version specified in the .env file |
| --compose=        | Allows user to use a custom Docker compose.yaml file         |

The Fabric version is specified using major.minor Fabric version identifiers. E.g., 8.1.6_5. 

### .config File Format
These configuration files contain required or custom settings used by Fabric. Configure  parameters as if you were editing any "ini" file to update config.ini

```ini
[section1]
key1=value1
key2=value2

[section2]
key1=value1
key2=value2
```

### About the fabric-init Container

This temporary container sets the proper ownership of the persistent data's _Space_ folder. After its execution, it should exit automatically.
