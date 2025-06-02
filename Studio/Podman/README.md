# K2view Fabric Web Studio for Podman, Version 2.1
This **README** describes how to use **Podman Compose** container runtime to host K2view Fabric Web Studio. It outlines the setup, components, installation options, and features relevant to Podman-based container environments.

## Table of Contents

1. [Documentation](#documentation)
2. [About K2view Fabric Web Studio](#about-k2view-fabric-web-studio)
3. [What's New](#whats-new)
4. [The Components](#the-components)
5. [Prerequisites](#prerequisites)
6. [What's in this Package](#whats-in-this-package)
7. [Things to Configure](#things-to-configure)
8. [Things to Know](#things-to-know)
9. [Installation](#installation)
10. [Operating and Managing Fabric Web Studio](#operating-and-managing-fabric-web-studio)
11. [Reference Information](#reference-information)
12. [Customizing Runtime Files Per Space](#customizing-runtime-files-per-space)
13. [Podman Command Reference for Enterprise Linux Environments](#podman-command-reference-for-enterprise-linux-environments)

## Documentation

The latest documentation is located at this location: https://support.k2view.com/Academy/articles/98_maintenance_and_operational/Installations/Fabric_Web_Studio/version_2-1/README.html. This readme is not a substitute for K2view's documentation, where you will find additional information and instructions. 


## About K2view Fabric Web Studio

K2view Fabric Web Studio provides developers a unified platform for designing, building, and managing data-driven solutions. With Podman Compose, the platform supports multi-space development, allowing teams to work concurrently within isolated environments that mirror real-world use cases.

Developers benefit from a comprehensive suite of data orchestration and management tools that enable real-time integration, fast iteration cycles, streamlined testing, and advanced debugging. These capabilities help accelerate delivery and foster collaboration across teams.

Version 2.1 of K2view Fabric Web Studio for Podman supports the creation of multiple Fabric Spaces and introduces simplified routing using URL context paths instead of subdomain-based access—making the system easier to configure and use across development environments.

## What's New

**Version 2.1 incorporates a few updates**:

* Added support for Podman in addition to Docker Compose
* Upgrades the Fabric version to 8.2.4_3.
* The Heap size was increased to 4GB.
* We now use PROJECT_NAME to define the project name; previously, this field used the same value as the SPACE_NAME parameter.
* When creating a Space, we automatically load a custom .env, compose.yaml, and a .config based on the Space's name. Refer to the Configuring Runtime File Per Space section for details.
* Fabric port 5124 is now exposed for JDBC access to the host's database (using the host's random port, similar to 3213).
* Ability to define a Linux socket file via .env.
* We improved the healthcheck.

**New Release Location**

* The Docker Compose runtime release download was renamed as Studio-Docker-latest.zip.
* For Podman, the distribution is named Studio-Podman-latest.zip.

**k2space.sh changes include**:

* New flag: --project can be used to specify the Project name, overriding the value of PROJECT_NAME defined in the .env file.
* New flag: --env allows the use of a custom .env file. Note: when specifying the --env flag the .env / .env-spacename will not be used.
* Prevents a Space from being recreated if one exists. It will start instead.
* Minor improvements and bug fixes.

## The Components

1. **Podman Compose Setup**: Fabric Web Studio can be deployed using **Podman Compose**, which allows users to run Compose YAML files with Podman’s container engine. Podman Compose orchestrates the Web Studio environment—including a selected Fabric profile, an embedded Fabric engine, and a Traefik reverse proxy—enabling the creation of multiple, isolated Fabric Spaces. This setup offers a lightweight and daemonless alternative to Docker-based runtimes, fully aligned with Enterprise Linux practices. 
2. **Fabric Image**: The Podman Compose environment is certified to run specific Fabric releases you can download from K2view's Nexus Container Registry.
3. **K2view Fabric Web Studio**: Available with four profiles that each embeds Fabric.
   1. **studio.config**. The default Web Studio profile embeds SQLite for its System DB.
   2. **studio_pg.config**. A generic Studio or TDM profile - Web Studio with PostgreSQL for use with its System DB and TDM.
   3. **studio_cass.config**. A TDM profile - Web Studio with Cassandra used for the System DB and TDM.
   4. **studio_pg_cass.config**. A TDM profile incorporating Apache Cassandra for its System DB and PostgreSQL for TDM tasks.
4. **Traefik Reverse Proxy** allows you to route requests to your various Fabric Spaces running within your Docker Compose Runtime at http(s)://[host]/[spacename]/. 



## Prerequisites

The Podman Compose setup for Fabric Web Studio requires the following system prerequisites.

### **Host Machine**

- **Architecture**: The supported processor architecture is **AMD64**. Fabric Web Studio does **not support ARM-based processors**.
- **Memory**: A minimum of **32GB RAM** is recommended for running Podman, Fabric Web Studio, and related integrations. Each Fabric Space allocates a **4GB heap by default**, which can be overridden via configuration.

### **Enterprise Linux Required**

A supported **Enterprise Linux distribution** (e.g., RHEL, AlmaLinux, Rocky Linux, CentOS Stream) is required for running Podman in a production-grade configuration.

### **3rd Party Software**

1. **Git**:
    Install Git from https://git-scm.com/downloads and follow the platform-specific instructions provided at [Installing Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git).

2. **Podman**:
    Install Podman using your distribution's package manager. For example, on RHEL-based systems:

   ```bash
   sudo dnf install -y podman
   ```
   
   Refer to the official documentation at https://podman.io/getting-started/installation for complete installation steps.

3. **Podman Compose**:
    Install **Podman Compose** to support Compose YAML workflows. Use either:

   - DNF:

     ```bash
     sudo dnf install -y podman-compose
     ```
     
   - Or pip:

     ```bash
     pip3 install --user podman-compose
     ```

> **Note**:  Podman Compose provides native compatibility for Compose YAML files with Podman pods.

**K2view Software**

1. The installation presumes you have Internet access, so you can obtain Fabric images from the K2view Nexus Container Registry and perform a Git clone on your machine. 
2. To obtain a Fabric Studio docker image, you need a K2view Nexus account. Your K2view representative can arrange this for you. 

**Internet Access is Required**

Internet access is required to perform this installation. You will need access to:

1. (Optional) Github.com to clone K2view’s blueprints at https://github.com/k2view/blueprints.git

2. K2view’s Nexus Docker Image repository at https://docker.share.cloud.k2view.com

3. If you plan to install TDM, you need access to K2view’s Exchange.

Refer to the "Podman Offline Package Download" section below for instructions on obtaining the necessary images in a disconnected environment. 

## What's in this Package

1. README.md - This document
2. K2space.sh - A Bash shell script used to create, list, and destroy spaces defined by Web Studio profiles. This script is used to start Fabric and the embedded Traefik reverse proxy. It can allocate additional heap space if required and override the default Fabric version specified in the .env file.
3. .env file - define various Fabric and Git parameters
1. .env-tdmspace - a sample file with a set of parameters that will override the default configuration defined in the .env file that will apply to a Space named "tdmspace"
4. common.config file - define various Fabric and runtime configurations
5. Studio_*.config files - the Fabric Profiles to choose from
6. YAML files are used to configure the Fabric and Traefik services. You can use the tls-config.yaml file to configure the TLS certificate and private key. 


## Things to Configure
1. Git Configuration - This is described in Step 4 - Configuring Git and TLS
2. TLS Certificate and Private Key Configuration - Optional because Traefik uses its own self-signed TLS certificate for HTTPS connections by default.  One is created for you by default for the machine.  To provide your own, please refer to Step 4. 


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

3. Your Data Files
  - Please note that persistent files created by Fabric Web Studio and the database instance you install will store their data in the "persistent-data" folder of your installation directory (e.g., K2view/Studio/persistent-data). Your Fabric Space's data is stored in the persistent-data/spacename directory. The respective space's directory will contain data if you create multiple spaces.
   - The location of the persistent data directory is configured in the `.env` file and set by default to be in the Fabric Web Studio installation directory.

## Installation

Follow the steps below to get Fabric Web Studio up and running using the **Podman Compose** setup.

* Step 1: Install and Validate Podman and Podman Compose
* Step 2: Setup
* Step 3: Download
* Step 4: Configure Git and TLS
* Step 5: Select a Fabric Blueprint Profile to Use
* Step 6: Log in to K2view's Nexus Container Registry
* Step 7: Create and Launch a Fabric Space
* Step 8: Access Web Studio

**Before you proceed, confirm that you have a K2view Nexus Container Registry Account**

You need to obtain credentials to access the K2view Nexus. Your K2view account representative can arrange this for you. If you do not have access, please contact your K2view representative, who can provide steps to help you through this process.

### **Step 1**: Install and Validate Podman and Podman Compose 

If Podman is not already installed on your machine, refer to the **Podman and Podman Compose Installation** topic at https://support.k2view.com/Academy/articles/98_maintenance_and_operational/Installations/Fabric_Web_Studio/version_2-1/README.html.

The recommended approach is to install **Podman** using your Linux distribution's package manager. This will install the Podman engine and CLI tools. You must also install **Podman Compose**, which provides Compose YAML support for Podman-based environments.

Please follow the steps in the **Podman and Podman Compose Installation** guide to complete the installation and validate your setup. Please refer to https://support.k2view.com/Academy/articles/98_maintenance_and_operational/Installations/Fabric_Web_Studio/version_2-1/README.html.

### **Step 2**: Setup

You can download the distribution (recommended) or use Git, “clone” the K2view Blueprints to "download" them. These blueprints incorporate the Fabric Docker Compose Runtime installation files. The K2view Blueprints are hosted on GitHub.com (Internet access is required). 

Please note that persistent files created by Fabric Web Studio and the database instance you install will store their data in the "persistent-data" folder of your installation directory (e.g., K2view/Studio/persistent-data). Your Fabric Space's data is stored in the persistent-data/spacename directory. The respective space's directory will contain data if you create multiple spaces. The location of the persistent data directory is configured in the `.env` file and set by default to be in the Fabric Web Studio installation directory. This is a per-space configuration. 

*Select a Base Directory for your Download and Installation Directory Locations*

First, please select a location to download the distribution or clone the K2view Blueprint content. This *base* directory can also hold the Fabric Web Studio installation directory from which it will run. 

Use the *change directory* command on your shell to switch to the designated base directory:

```bash
cd [base directory]
```

*Create your Download and Installation Directory Location*

Using a shell, create a "K2view" directory. You can also use the K2view directory to hold the K2view Fabric Web Studio Installation directory. We recommend using K2view for this directory.

```bash
mkdir K2view
```

### **Step 3**: Download

There are two options to obtain Fabric Web Studio. You can download a zip file or clone the content from K2view's Blueprints. Downloading the latest distribution as described in Option 1 is recommended. 

#### Option 1: Download The Latest Version of Fabric Web Studio for Podman

You can download the latest version of Fabric Web Studio for Podman from this location: 

```bash
https://nexus.share.cloud.k2view.com/repository/k2view-download/web-studio/Studio-Podman-latest.zip
```

Then, change the directory to the K2view directory. Copy `Studio-Podman-latest.zip` to this directory, and unzip `Studio-Podman-latest.zip` to this directory. Then, rename the `Studio-Podman-latest.zip` directory as `Studio`.

```bash
cd K2view
# copy Studio-Podman-latest.zip to this directory
# unzip Studio-Podman-latest.zip to this directory
```

The Studio directory contains the configuration, YAML, and the `k2Space.sh` script files to configure and create your Fabric Web Studio spaces. Please refer to the What's in this Package topic above for details about these files. 

You can now skip to Step 4.

#### Option 2: Clone the K2view Blueprints 

Using a shell, change your directory to your K2view directory and run the following command to clone K2view Blueprints (this requires a prior installation of a Git client):

Using the prior example of the `K2view` directory:

```bash
cd K2view
git clone https://github.com/k2view/blueprints.git
```

This will create a `blueprints` directory with various subdirectories. The `Studio` subdirectory holds the Fabric Web Studio installation files. 

#### Create an Installation Directory and Copy the Fabric Web Studio Files

We recommend running Fabric Web Studio within the `Studio` directory of the `K2view` directory. From the K2view directory, copy the `blueprints/Studio` directory as `Studio`. 

From the K2view directory

```bash
cp -r blueprints/Studio/ Studio
```
The Studio directory contains the configuration, YAML, and the `k2Space.sh` script files to configure and create your Fabric Web Studio spaces. Please refer to the <a href="https://support.k2view.com/articles/98_maintenance_and_operational/Installations/Fabric_Web_Studio/version_2-1/Installation-podman.html#whats-in-this-package">What's in this Package</a> topic above for details about these files. 

### **Step 4**: Configure Git and TLS

#### Configuring Git

You should consider a few things, including configuring a Git repository for your project. Though not mandatory, it is a best practice to store your project files in Git (or in a Git-compliant code repository). 

You can configure it before the creation of Fabric Space via the .env file. You can do so after starting Fabric Web Studio using its built-in Git client. Perform this step within Fabric Web Studio.

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

1. **studio**. The default Web Studio profile embeds SQLite as its system database.
2. **studio_pg**. A generic Studio or TDM profile - Web Studio with PostgreSQL for use with its System DB and TDM.
3. **studio_cass**. A TDM profile - Web Studio with Cassandra used for the System DB and TDM.
4. **studio_pg_cass**. A TDM profile incorporating Apache Cassandra for its System DB and PostgreSQL for TDM tasks.

Using the default profile, 'studio', you will not need to provide the profile on the `k2space.sh` command line. Otherwise, you will need to enter one of the other profiles. 


### **Step 6**: Log in to K2view's Nexus Container Registry

*Prerequisite*

Podman must be installed and properly configured to access the container registry. If running in rootless mode, ensure the Podman socket is active.

Using the K2view Nexus Container Registry credentials provided to you, run the following command from the same directory where you performed the `git clone`:

```bash
podman login -u [YourAccount] https://docker.share.cloud.k2view.com
```

You will be prompted to enter your password.

Depending on your environment and user permissions, you may need to prepend `sudo` to the command on some Linux systems.

> Tip: You can verify a successful login by running `podman info` and confirming registry authentication.



To ensure the **Podman socket** is active in **rootless mode**, follow these steps:

#### Step-by-Step: Ensure Podman Socket is Active (Rootless Mode)

**Check the status of the socket**

```bash
systemctl --user status podman.socket
```

- If the service is **inactive** or **not found**, proceed to the next steps.

**Enable and start the socket**

```bash
systemctl --user enable --now podman.socket
```

This will:

- Enable the socket to start automatically on login
- Start the socket immediately



**Enable linger (so user services run after logout)**

```bash
loginctl enable-linger $USER
```

- This allows systemd user services (like the Podman socket) to run after the user logs out.
- This step is essential for non-interactive or headless environments.

**Verify the socket is now listening**

```bash
systemctl --user status podman.socket
```

You should see output like:

```bash
Active: active (listening)
```

### Podman Image Offline Package Download

The Podman login command and the `k2space.sh` bash shell script requires Internet access to log in and pull K2view Fabric images from the K2view Nexus Container Registry at docker.share.cloud.k2view.com.

If your target machine **does not have Internet connectivity**, you can follow this **offline download procedure** to transfer the required image from another system. The Fabric image is approximately **1.9GB**, and its version must match the value specified in your local `.env` file.

By preloading the image locally, the `k2space.sh` script can create a Fabric Space without needing to download the image from the registry.

#### Offline Image Transfer Procedure

**Save and compress the desired Fabric image on an online machine:**

```bash
podman save docker.share.cloud.k2view.com/k2view/fabric-studio:X.Y.Z_0 | gzip > k2view_fabric-studio_X.Y.Z_0.tar.gz
```

**Transfer the image file to your target (offline) machine:**

Use `scp`, USB, or any secure method to copy `k2view_fabric-studio_X.Y.Z_0.tar.gz` to the target environment.

**Load the image into Podman on the offline machine:**

```bash
podman load -i k2view_fabric-studio_X.Y.Z_0.tar.gz
```

This will make the image available to the local Podman image store.

> **Important**: Ensure that the image version matches the value in your `.env` file before executing `k2space.sh`. This ensures proper image resolution and prevents unnecessary fetch attempts.

### **Step 7**: Create and Launch a Fabric Space

#### **Space Name**

When creating a space, its name must consist of only lowercase alphanumeric characters, hyphens, and underscores and start with either a letter or a number. You cannot use uppercase characters. 

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
You may need to make `k2space.sh` executable on a Linux system, to do so, use the `chmod` command using:

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

You can also connect to Fabric remotely, using `https://[hostname or IP address]/spacename`.

> Traefik will default to using its own self-signed TLS certificates for HTTPS connections. The Certificate is created for you by default for the machine. If you want to use a certificate created by your organization, everything is pre-configured for you to do so. See the "Configuring TLS" topic above for instructions. 

When presented with the login screen, enter: 

  - Username: admin
  - Password: admin

If you access Fabric Web Studio, you have successfully installed it. 


## Operating and Managing Fabric Web Studio

### Fabric Spaces
This `k2space.sh` shell script makes it easy to create and delete Fabric. You can also use it to list and get information about existing Fabric Spaces using: 

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

After creating your first Space, you will need to wait for Fabric to come up. Unless it's up, you may get a 404 error if Traefik hasn't yet processed its new ingress rules, which may take a few seconds. Otherwise, you might get a 502 error if Traefik is ready but Fabric is not yet ready. Give it some time.

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
Traefik starts automatically after you create your first Fabric Space. It will also check whenever a new Fabric Space is created. If it is not running, it will be started automatically.

> __Note:__ Traefik relies on the Docker network created during the creation of a Fabric Space. Therefore, it must be started __after__ the Fabric Space.

#### Restarting Traefik
To restart Traefik (e.g., after configuring your TLS certificates),  run the command below:

```bash
podman compose -f k2vingress-compose.yaml restart
```

### Adding Users

You are ready to add users. You can experiment with the built-in System DB (e.g., Postgres or Cassandra data stores). We recommend using alternate authentication providers rather than using built-in providers. 

To use the built-in authentication provider, navigate to the [Web Admin App](https://support.k2view.com/Academy/articles/30_web_framework/03_web_admin_application.html). Select the Security tab. Select the Users tab and add a user. Select the Roles tab, create a new role (e.g., User), and then assign Fabric permissions to the newly created role. 

The K2view Fabric Web Studio for Podman employs underlying Fabric security capabilities and configurations. Fabric works with several authentication providers. Each authenticator is responsible for user authentication and managing user IDs and roles.

The following are the supported authentication providers as described [here](https://support.k2view.com/Academy/articles/26_fabric_security/07_user_IAM_overview.html). 

- **Fabric**: Fabric stores users' credentials in a System DB table using Postgres. Passwords are stored securely in this table using a salted password hashing technique. By default, Fabric is configured to use a 32-byte salt length. When Cassandra is used, the provider is named Cassandra.
- **LDAP**: Fabric authentication is performed via LDAP integration as described [here](https://support.k2view.com/Academy/articles/26_fabric_security/11_user_IAM_LDAP.html).
- **ADLDAP** (Microsoft Active Directory): Fabric authentication is performed via Active Directory integration as described [here](https://support.k2view.com/Academy/articles/26_fabric_security/11_user_IAM_LDAP.html).
- **SAML**:  Fabric authentication is performed via SAML IDP integration as described [here](https://support.k2view.com/Academy/articles/26_fabric_security/09_user_IAM_SAML_fundamentals_and_terms.html). SAML provides the means of offering an SSO experience to users using, for example, Microsoft Entra ID and Okta. See the [Microsoft Entra ID](https://support.k2view.com/Academy/articles/26_fabric_security/14_user_IAM_SAML_Azure_AD_setup.html) and [Okta](https://support.k2view.com/Academy/articles/26_fabric_security/15_user_IAM_SAML_Okta_setup.html) integration descriptions to learn more about Fabric SSO support. 

### Upgrading to a Later Fabric Version

K2view certifies specific versions. To obtain the list of supported Fabric versions, please create a K2view support ticket via the [My Tickets](https://k2view.freshdesk.com/a/dashboard/default) link from the [K2view Support Site](https://support.k2view.com/).

The approach is simple: 1) push all changes to Git, and 2) create a new Fabric Space with the desired certified version of Fabric. 

## Reference Information

### k2space.sh OPTIONS Reference

Here are the command options for `k2space.sh`:

| Option            | Description                                                  |
| ----------------- | ------------------------------------------------------------ |
| --profile=        | Allows you to select the desired Fabric Space Profile        |
| --heap=           | Allows you to override the default 4GB allocated heap size   |
| --fabric-version= | Allows you to override the Fabric version specified in the .env file |
| --compose=        | Allows you to use a custom Docker compose.yaml file         |
| --env=            | Allows you to use a custom Docker environment file |
| --project=            | Allows you to specify the Project's name |


The Fabric version is specified using the desired image tag. E.g., 8.2.4_3 

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



## Customizing Runtime Files Per Space

K2view Fabric Web Studio's Docker Compose Runtime supports **per-Space configuration overrides** using custom `.env`, `compose.yaml`, and `.config` files. When a new Fabric Space is created using the `k2space.sh` script, the runtime checks for specially named files corresponding to the Space name and applies them accordingly.

### File Customization Behavior

When creating a Space named, for example, `dcr210`, the following behavior applies:

- **`.env` and `.config` files** are **appended to** the base configuration.
- **`compose.yaml` files** are **overridden completely** if a matching file is found.

#### `.env` Customization

- The base `.env` file is always loaded first.
- If a file named `.env-dcr210` exists (where `dcr210` is the Space name), its values will be **appended to or override** those defined in the base `.env`.
- You can use this to set environment-specific parameters such as `MAX_HEAP`, `GIT_REPO`, or other custom variables.

#### `compose.yaml` Customization

- The default `compose.yaml` is loaded unless a file named `compose-dcr210.yaml` exists.
- If `compose-dcr210.yaml` exists  (where `dcr210` is the Space name), it will **completely replace** the default `compose.yaml` for that Space.

#### `.config` Customization

- The base `common.config` file is always loaded.
- If a file named `dcr210.config` exists (where `dcr210` is the Space name), its values will be **appended to or override** settings from `common.config`.
- This allows per-Space configuration of Fabric runtime behavior, such as a custom system DB path or SSO settings.

### Manual Overrides

You can also explicitly specify files when using the `k2space.sh` script:

```
./k2space.sh create --env=custom.env --compose=custom-compose.yaml --config=custom.config dcr210
```

When using the `--env` or `--compose` options, **automatic detection of `.env-[spacename]` and `compose-[spacename].yaml` is skipped**.

### Example Use Case

For a Space named `dcr210`, you might create:

- `.env-dcr210` to override heap size:

  ```env
  
  MAX_HEAP=8G
  ```

- `compose-dcr210.yaml` to expose an additional port (e.g., JDBC port 5124):

  ```yaml
  
  ports:
    - "5124:5124"
  ```

- `dcr210.config` to point to a different System DB path or define SSO behavior:

  ``` ini
  
  [System]
  db.path=/custom/path/system.db
  ```

This flexible mechanism supports both shared and isolated runtime customization for Fabric Web Studio Spaces, making it ideal for multi-tenant development, QA, or demo environments.





## Podman Command Reference for Enterprise Linux Environments

This reference document outlines the Podman CLI commands used by DevOps engineers to manage Fabric Web Studio environments on Enterprise Linux systems.


### 1. Container Management

#### List Containers
- `podman ps`  
  Lists all running containers.
- `podman ps -a`  
  Lists all containers, including stopped ones.

#### Start/Stop Containers
- `podman start <container>`  
  Starts a specific container.
- `podman stop <container>`  
  Stops a specific container.
- `podman stop -a`  
  Stops all containers.
- `podman stop --all`  
  Stops all containers.

#### Remove Containers
- `podman rm <container>`  
  Removes a specific container.
- `podman rm -f <container>`  
  Force removes a container.
- `podman rm -af`  
  Force removes all containers.

#### Inspect and Logs
- `podman logs <container>`  
  Displays logs for a container.
- `podman inspect <container>`  
  Shows low-level information about a container.
- `podman exec -it <container> <cmd>`  
  Executes a command inside a running container interactively.


### 2. Image and Registry Management
- `podman images`  
  Lists local container images.
- `podman pull <image>`  
  Pulls an image from a remote registry.
- `podman login -u <user> -p <password> <registry>`  
  Logs in to a container registry.


### 3. Pod Management

#### View Pods
- `podman pod ls`  
  Lists all pods.
- `podman pod ps`  
  Lists running pods.

#### Manage Pods
- `podman pod create`  
  Creates a new pod.
- `podman pod rm <pod>`  
  Removes a specified pod.
- `podman pod rm -f <pod>`  
  Force removes a pod.
- `podman pod rm -af`  
  Force removes all pods.

#### Logs and Inspection
- `podman pod logs <pod>`  
  Shows logs from all containers in a pod.
- `podman pod inspect <pod>`  
  Displays detailed info for a pod.


### 4. Network Management
- `podman network ls`  
  Lists existing networks.
- `podman network create <name>`  
  Creates a new container network.
- `podman network rm <name>`  
  Removes a specified network.
- `podman network rm -a`  
  Removes all networks.
- `podman network prune`  
  Removes unused networks.


### 5. System Utilities
- `podman version`  
  Shows the installed Podman version.
- `podman system reset`  
  Wipes all Podman data (containers, images, volumes).
- `podman system migrate`  
  Migrates container formats to the latest version.
- `podman volume prune`  
  Deletes all unused volumes.


### 6. Compose Support
- `podman compose -v`  
  Displays the version of Podman Compose (if installed).


### 7. Socket and Service Management
- `systemctl --user enable --now podman.socket`  
  Enables and starts Podman socket for rootless API access.
- `systemctl --user status podman.socket`  
  Checks the status of the Podman socket.
- `loginctl enable-linger <user>`  
  Enables lingering for systemd user services.
