# K2view Fabric Web Studio for Docker Compose
This **README** describes the Docker Compose runtime used to host K2view Fabric Web Studio. It covers prerequisites, setup, installation, configuration, and operation.
## Table of Contents

1. [Documentation](#documentation)
1. [About K2view Fabric Web Studio](#about-k2view-fabric-web-studio)
1. [What's New](#whats-new)
1. [The Components](#the-components)
1. [Prerequisites](#prerequisites)
1. [What's in this Package](#whats-in-this-package)
1. [Things to Configure](#things-to-configure)
1. [Proxy Configuration](#proxy-configuration)
1. [Things to Know](#things-to-know)
1. [Installation](#installation)
1. [Operating and Managing Fabric Web Studio for Docker Compose](#operating-and-managing-fabric-web-studio-for-docker-compose)
1. [Reference Information](#reference-information)
1. [Customizing Runtime Files Per Space](#customizing-runtime-files-per-space)

## Documentation

The latest documentation is located at this location: https://support.k2view.com/Academy/articles/98_maintenance_and_operational/Installations/Fabric_Web_Studio/version_2-1/README.html. This readme is not a substitute for K2view's documentation, where you will find additional information and instructions. 


## About K2view Fabric Web Studio

K2view Fabric Web Studio provides developers with a unified platform for designing, building, and managing data-driven solutions. The Docker Compose runtime supports multi-space development, allowing multiple developers to work concurrently in separate Fabric Spaces.

Developers benefit from Fabric's data management and orchestration capabilities, including real-time integration, testing, and debugging. These capabilities help accelerate project delivery and support collaboration across teams.

Fabric Web Studio supports the creation of multiple Fabric Spaces through simplified URL routing. Each Space is accessed using a URL context path (for example, `/spacename`) rather than a subdomain-based URL.

## What's New

**Version 2.2 incorporates a few updates**:

* Improved output when running Space diagnostic
* Validate the container runtime socket before launching the ingress component
* Check if the Space Profile configuration files have the appropriate permission and prevents Fabric container from starting if not properly set
* Space restart policy can be defined via environment variable `SPACE_RESTART_POLICY` (default: `no`)
* Traefik image is pinned to a major release instead of **latest**
* We improved the healthcheck of ingress components
* Fixed an issue related to Cassandra's persistent data
* Fixed a bug that could prevent upgrading Spaces version in some systems

**k2space.sh changes include**:

* New flag: `--version` can be used to check the version of K2view Fabric Web Studio for Docker Compose
* New command: `version` which is an alias to flag `--version`
* New flags in the `upgrade` subcommand: `--preserve-env=VAR_NAME` preserves the existing value of the specified whitelisted variable, while `--preserve-all-envs` preserves all whitelisted environment variables.
* Minor improvements and bug fixes.

## The Components

1. **Docker Compose Runtime**: Fabric Web Studio runs in a Docker Compose environment. Docker Engine and Docker Compose orchestrate Web Studio, the selected Fabric profile and embedded Fabric engine, and the Traefik reverse proxy. Together, these components support the creation and management of multiple Fabric Spaces.
2. **Fabric Image**: The Docker Compose runtime is certified to run specific Fabric releases that you can download from K2view's Container Registry.
3. **K2view Fabric Web Studio**: Available with four profiles, each of which embeds Fabric.
   1. **studio.config**. The default Web Studio profile embeds SQLite for its System DB.
   2. **studio_pg.config**. A generic Studio or TDM profile - Web Studio with PostgreSQL for use with its System DB and TDM.
   3. **studio_cass.config**. A TDM profile - Web Studio with Cassandra used for the System DB and TDM.
   4. **studio_pg_cass.config**. A TDM profile incorporating Apache Cassandra for its System DB and PostgreSQL for TDM tasks.
4. **Traefik Reverse Proxy**: Routes requests to the Fabric Spaces running within the Docker Compose environment at `http(s)://[host]/[spacename]/`.

## Prerequisites

The Docker Compose runtime for Fabric Web Studio has the following prerequisites.

### **Host Machine**

The supported processor architecture is **AMD64**. Fabric Web Studio does not support ARM-based processors.

The amount of memory required depends on your use case. **32GB RAM** is recommended for running Fabric Web Studio and its integrations. A **4GB heap** is allocated by default for each Fabric Space and can be overridden through configuration.

### **3rd Party Software**

1. **Git**: Install a Git client from https://git-scm.com/downloads and follow the instructions at https://git-scm.com/book/en/v2/Getting-Started-Installing-Git.
2. **Docker**: Install and run Docker using the instructions at https://docs.docker.com/engine/install/.
3. **Administrative rights**: Installing Docker and Docker Compose requires administrative rights on the machine:
   - Linux: root or sudo access.
   - Windows: administrator rights.
4. **Operating system**: The runtime requires Linux. Windows can be used with the Windows Subsystem for Linux (WSL) and a Linux distribution. See the Windows section below.
5. **Docker Compose**: Install the native Docker Compose plugin. Docker Desktop includes Docker Compose. See https://docs.docker.com/compose/install/. Do not use the Python-based `docker-compose` utility.

**K2view Software**

1. Installation requires Internet access to obtain Fabric images from the K2view Container Registry and, if using Git, to clone K2view's Blueprints.
2. A K2view Container Registry account is required to obtain the Fabric Studio image. Your K2view representative can arrange access.

**Internet Access is Required**

Internet access is required to perform this installation. You will need access to:

1. (Optional) `downloads.cloud.k2view.com` to [download](https://downloads.cloud.k2view.com/s/gyUKmanmwByJuAM/download) the distribution, or GitHub to clone K2view's Blueprints at https://github.com/k2view/blueprints.git.
2. K2view's Container Registry at https://docker.share.cloud.k2view.com.
3. K2view's Exchange if you plan to install TDM.

Refer to the "Docker Image Offline Package Download" section below for instructions on obtaining the necessary images in a disconnected environment.

## What's in this Package

1. `README.md` - This document.
2. `k2space.sh` - A Bash script used to create, list, and destroy Spaces defined by Web Studio profiles. It starts Fabric and the embedded Traefik reverse proxy, can allocate additional heap space, and can override the default Fabric version specified in `.env`.
3. `.env` - Defines Fabric and Git parameters.
4. `.env-tdm-sample-space` - A sample file containing parameters that override the defaults in `.env` for a Space named `tdm-sample-space`.
5. `common.config` - Defines Fabric and runtime configurations.
6. `Studio_*.config` - Fabric profiles to choose from.
7. YAML files - Configure the Fabric and Traefik services. Use `tls-config.yaml` to configure the TLS certificate and private key.

## Things to Configure

1. **Git configuration** - Described in Step 4 - Configuring Git and TLS.
2. **TLS certificate and private key configuration** - Optional. Traefik uses its own self-signed TLS certificate for HTTPS connections by default. To use your own certificate, refer to Step 4.

## Proxy Configuration

In environments where a forward proxy is configured on the host, Docker can automatically inject proxy environment variables into containers. If internal services inherit these variables, container-to-container traffic may be misrouted through the proxy, disrupting the deployment.
### How Proxy Handling Works

The Docker Compose configuration avoids unintended proxy inheritance by omitting proxy-related environment variables from services that do not require outbound access.

- **`cassandra`, `postgres`, and `init-fabric`** have no proxy-related environment variables defined. They communicate over the internal Docker network and do not require outbound access.
- **`fabric`** is the only service that may need outbound access (for example, to connect to external databases or APIs). It receives proxy settings passed from the host OS. Proxy variables can use lowercase (`http_proxy`, `https_proxy`, `no_proxy`) or uppercase (`HTTP_PROXY`, `HTTPS_PROXY`, `NO_PROXY`) names.

### Configuring Proxy for Fabric

Set the proxy variables on the host before running `k2space.sh`. No changes to `.env` or `compose.yaml` are required.

```bash
export http_proxy="http://proxy.example.com:3128"
export https_proxy="http://proxy.example.com:3128"
export no_proxy="localhost,127.0.0.1,.internal.example.com"
./k2space.sh create spacename
```

> **Note:** Lowercase variable names (`http_proxy`, `https_proxy`, `no_proxy`) take precedence over their uppercase equivalents in many Linux tools and runtimes, but both forms can be defined. If both forms are set to different values, the value used may depend on the application or runtime. To avoid unexpected behavior, set both forms to the same value.

### Disabling Proxy for Fabric

If Fabric should not use a proxy (for example, if all external sources are directly reachable), ensure the proxy variables are unset on the host before running `k2space.sh`:

```bash
unset http_proxy https_proxy HTTP_PROXY HTTPS_PROXY no_proxy NO_PROXY
./k2space.sh create spacename
```

## Things to Know

1. **Default administrator credentials**:
   - Username: `admin`
   - Password: `admin`

2. **Ports**: Traefik uses the following ports:

   | Protocol | Port | Description |
   | --- | ---: | --- |
   | HTTP | 8080 | Traefik dashboard |
   | HTTP | 80 | HTTP listener |
   | HTTPS | 443 | HTTPS listener |

3. **Your data files**: Persistent files created by Fabric Web Studio and the database instance are stored in the `persistent-data` folder under the installation directory (for example, `K2view/Studio/persistent-data`). Each Fabric Space's data is stored in `persistent-data/spacename`. The location of the persistent data directory is configured in `.env` and defaults to the Fabric Web Studio installation directory.

## Installation

Follow these steps to get Fabric Web Studio up and running using the **Docker Compose** runtime.

* Step 1: Install and validate Docker and Docker Compose
* Step 2: Setup
* Step 3: Download
* Step 4: Configure Git and TLS
* Step 5: Select a Fabric Blueprint Profile to Use
* Step 6: Log in to K2view's Container Registry
* Step 7: Create and Launch a Fabric Space
* Step 8: Access Web Studio

**Before you proceed, confirm that you have a K2view Container Registry account.**

You need credentials to access the K2view Container Registry. Your K2view account representative can arrange access. If you do not have an account, contact your K2view representative.

### **Step 1**: Install and Validate Docker and Docker Compose

If Docker is not already installed on your machine, refer to the Docker and Docker Compose installation topic at https://support.k2view.com/Academy/articles/98_maintenance_and_operational/Installations/Fabric_Web_Studio/version_2-1/README.html.

The recommended approach is to install Docker Desktop, which includes Docker Engine, Docker CLI, and Docker Compose. Alternatively, install Docker Engine and the native Docker Compose plugin separately. Follow the installation guide above to complete the setup and validate your environment.

### **Step 2**: Setup

You can download the distribution (recommended) or clone K2view's Blueprints using Git. The Blueprints contain the Fabric Web Studio Docker Compose runtime files and are hosted on GitHub (Internet access is required).

Whether you download or clone the files depends on the operating system you use. There are different instructions depending on whether you are using Linux or MacOS, than those for Microsoft Windows.

#### Using Linux or MacOS

*Select a Base Directory for your Download and Installation Directory Locations*

First, please select a location to download the distribution or clone the K2view Blueprint content. This *base* directory can also hold the Fabric Web Studio installation directory from which it will run. 

Use the *change directory* command on your shell to switch to the designated base directory:

```bash
cd [base directory]
```

*Create your Download and Installation Directory Location*

The location of this installation directory depends on your needs. On a Linux system, consider using `/opt/apps/` as a location for your applications. If you are installing on a Mac or Windows computer, the `/home/username` or `\users\username` directory, respectively, can be considered. 

Using a shell, create a "K2view" directory. You can also use the K2view directory to hold the K2view Fabric Web Studio Installation directory. We recommend using K2view for this directory.

```bash
mkdir K2view
```

#### Using Microsoft Windows

> Using a Linux file system is highly recommended when installing on Microsoft Windows. It can be installed with the Windows Subsystem for Linux (WSL) and a Linux distribution such as Ubuntu. Doing so avoids performance problems using Docker on a native Windows file system. Please refer to the <a href="https://support.k2view.com/Academy/articles/98_maintenance_and_operational/Installations/Fabric_Web_Studio/version_2-1/6-Docker-Compose.html">Docker and Docker Compose Installation</a> topic for instructions on how to install WSL and a Linux distribution.
>
> Not only should you avoid using the Windows file system, but you should also avoid using WSL's `/mnt/c` mounted Windows file system. Instead, use the file system of the Linux distribution you installed, e.g., `/home/username/K2view`, to download and install the configuration files and store the workspace data created by Fabric Web Studio. 

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

Using a shell, create a `K2view` directory to download K2view's Blueprints. You can also use the K2view directory to hold the K2view Fabric Web Studio Installation directory. We recommend using K2view for this directory.

```bash
mkdir K2view
```

### **Step 3**: Download

There are two options to obtain Fabric Web Studio: download a ZIP file or clone the content from K2view's Blueprints. Downloading the latest distribution, as described in Option 1, is recommended.

#### Option 1: Download The Latest Version of Fabric Web Studio for Docker Compose

Download the latest version of Fabric Web Studio for Docker Compose here: [studio-docker-latest](https://downloads.cloud.k2view.com/s/gyUKmanmwByJuAM/download).

Change to the `K2view` directory, copy `Studio-Docker-latest.zip` into it, extract the archive, and rename the extracted directory to `Studio`.

```bash
cd K2view
# copy Studio-Docker-latest.zip to this directory
# unzip Studio-Docker-latest.zip to this directory
```

The `Studio` directory contains the configuration files, YAML files, and `k2space.sh` script used to configure and create Fabric Web Studio Spaces. See "What's in this Package" above for details.

You can now skip to Step 4 to configure Git and TLS.

#### Option 2: Clone the K2view Blueprints

From your `K2view` directory, run the following command to clone K2view's Blueprints (this requires Git):

```bash
cd K2view
git clone https://github.com/k2view/blueprints.git
```

This creates a `blueprints` directory containing various subdirectories. The `Studio` subdirectory contains the Fabric Web Studio installation files.

#### Create an Installation Directory and Copy the Fabric Web Studio Files

We recommend running Fabric Web Studio from a `Studio` directory under `K2view`. From the `K2view` directory, copy the `blueprints/Studio/Docker` directory as `Studio`.

```bash
cp -r blueprints/Studio/Docker Studio
```

*Using Microsoft Windows PowerShell*

If you are using Windows, store the `Studio` directory in the Linux file system of your WSL distribution. See the Windows instructions in Step 2 for details.

```powershell
cp -r blueprints\Studio\Docker Studio
```

The `Studio` directory contains the configuration files, YAML files, and `k2space.sh` script used to configure and create Fabric Web Studio Spaces. See [What's in this Package](https://support.k2view.com/Academy/articles/98_maintenance_and_operational/Installations/Fabric_Web_Studio/version_2-1/Installation.html#whats-in-this-package) above for details.

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

If you perform this step after the initial installation, you must restart Fabric for these to take effect. In addition, you will also need to restart the ingress using this command:

```bash
./k2space.sh ingress restart
```

### **Step 5**: Select a Fabric Blueprint Profile to Use

There are four profiles, each of which embeds Fabric. The default profile is `studio`.

1. **studio**: The default Web Studio profile embeds SQLite as its System DB.
2. **studio_pg**: A generic Studio or TDM profile - Web Studio with PostgreSQL for its System DB and TDM.
3. **studio_cass**: A TDM profile - Web Studio with Cassandra for its System DB and TDM.
4. **studio_pg_cass**: A TDM profile incorporating Apache Cassandra for its System DB and PostgreSQL for TDM tasks.

When using the default `studio` profile, you do not need to specify the profile on the `k2space.sh` command line. Otherwise, specify one of the other profiles.

### **Step 6**: Log in to K2view's Container Registry

*Prerequisite*

Docker and its Compose extension must be installed, running, and configured on the server to perform this step.

Using the K2view Container Registry credentials provided to you, run the following command:

```bash
docker login -u [YourAccount] https://docker.share.cloud.k2view.com
```

You will be prompted to enter your password.

**Note**: The Docker login command requires Internet access to log in and pull K2view Fabric images from the K2view Container Registry at docker.share.cloud.k2view.com. 


#### Docker Image Offline Package Download


If your target machine **does not have Internet connectivity**, you can follow this **offline download procedure** to transfer the required image from another system. The Fabric image is approximately **2GB**, and its version must match the value specified in your local `.env` file.

By preloading the image locally, the `k2space.sh` script can create a Fabric Space without needing to download the image from the registry.

**Important:** You also must set `INGRESS_PULL_POLICY="never"` in the `.env` file.

#### Offline Image Transfer Procedure

**Save and compress the desired Fabric image on an online machine:**

```bash
docker save docker.share.cloud.k2view.com/k2view-images/fabric-studio:X.Y.Z_0 | gzip > k2view_fabric-studio_X.Y.Z_0.tar.gz
```

**Transfer the image file to your target (offline) machine:**

Use `scp`, USB, or any secure method to copy `k2view_fabric-studio_X.Y.Z_0.tar.gz` to the target environment.

**Load the image into Podman on the offline machine:**

```bash
docker load -i k2view_fabric-studio_X.Y.Z_0.tar.gz
```

This will make the image available to the local Podman image store.

> **Important**: Ensure that the image version matches the value in your `.env` file before executing `k2space.sh`. This ensures proper image resolution and prevents unnecessary fetch attempts.

**Use similar procedures to obtain the following:**

- Traefik Reverse Proxy:

```bash
  docker pull docker.io/library/traefik:v3
```

- Socat Relay:

```bash
  docker pull docker.io/alpine/socat:latest
```

- Database containers as required: Postgres 18.4 and optionally Cassandra 4.1.8 depending on your profile

```bash
  docker pull docker.io/library/postgres:18.4

  docker pull docker.io/library/cassandra:4.1.8
```

Then run `docker save` for each of the images, transfer to the server, and load using `docker load`.

### **Step 7**: Create and Launch a Fabric Space

#### **Space Name**

When creating a space, its name must consist of only lowercase alphanumeric characters, hyphens, and underscores and start with either a letter or a number. You cannot use uppercase characters. 

#### **Running****`k2space.sh`****on Microsoft Windows**

The `k2space.sh` file is a Bash script, and a Windows PowerShell-compatible version is not currently available. To run the script on Windows, you can use either **Git Bash** or **Git installed within WSL (Windows Subsystem for Linux)**.

Regardless of which option you choose, the script must be executed from within the **WSL filesystem**, rather than directly from the Windows filesystem.

- **Using Git Bash:** Start Git Bash and navigate to the script's location within the WSL filesystem. For example:bash
  ```bash
  cd //wsl.localhost/<WSL-distro-name>/home/<username>/<path-to-script>
  ```
  You can also open Git Bash from Windows Explorer by navigating to the script's directory, right-clicking within the Explorer window, selecting **Show more options**, and choosing **Open Git Bash here**. Ensure that the resulting shell is operating within the WSL filesystem before running the script.
- **Using Git within WSL:** Install Git in your WSL distribution using its package manager, open a WSL terminal, and navigate to the script's location using its Linux filesystem path. For example:bash
  ```bash
  cd /home/<username>/<path-to-script>
  ```

Once you are in the script's directory, execute it using:

bash

```bash
./k2space.sh COMMAND
```

**Note:** Although Git Bash can access the WSL filesystem through its network path, it does not provide a native Linux environment. If the script relies on Linux-specific utilities, permissions, or behavior, running it directly within WSL is recommended for the most reliable results.

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

You will download Fabric from the K2view Container Registry when creating your first Fabric Space. While this is happening, you should observe the following.

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

You can also connect to Fabric remotely using `https://[hostname or IP address]/spacename`.

> Traefik uses its own self-signed TLS certificate for HTTPS connections by default. To use a certificate created by your organization, see "Configuring TLS" above.

When presented with the login screen, enter:

- Username: `admin`
- Password: `admin`

If you can access Fabric Web Studio, the installation is complete.

## Operating and Managing Fabric Web Studio for Docker Compose

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

**Upgrading a Space**

You can upgrade the Studio version or Space parameters with the following command:

```bash
./k2space.sh upgrade [OPTIONS] spacename
```

The upgrade command recreates the existing Space using the current configuration. You can use it to change the Fabric version and Space parameters, such as the heap size and host-to-container port mappings.

By default, the recreated Space uses the values currently defined in `.env` and the applicable Space-specific environment file. To retain environment variable values from the existing Space instead, use one of the preservation options below. These options apply only to variables supported by the preservation mechanism (the whitelist is not listed here).

| Option | Description |
| --- | --- |
| `--heap=` | Overrides the default 4GB allocated heap size. |
| `--fabric-version=` | Overrides the Fabric version specified in `.env`. |
| `--preserve-env=VAR_NAME` | Preserves the existing Space's value for the specified whitelisted environment variable. |
| `--preserve-all-envs` | Preserves all whitelisted environment variables from the existing Space. |

For example, if `http_proxy` was set to `proxy.example.com:3128` when the Space was created and `.env` is later changed to `http_proxy=newproxy.example.com:3218`, an upgrade without a preservation option uses the new value. Use `--preserve-env=http_proxy` to retain the existing value, or `--preserve-all-envs` to retain all whitelisted values.

**Diagnosing a Space**

You can check the Space's health by running:

```bash
./k2space.sh check [OPTIONS] spacename
```

Along with the Space's health, this command also checks for the diagnostic of the ingress components. If any error is found in any subcomponent, ingress or supporting containers, and the flag --save is set, it will capture the logs of the problematic container. If the problem is with Studio, rather than capturing its container logs, it will copy files k2fabric.log and k2studio.err along with some other useful information. Those generated files can be provided to a K2view agent, where it will be used to determine the cause of issue.

Note: The check command allows the following flags:

| Option            | Description                                                  |
| ----------------- | ------------------------------------------------------------ |
| --save[=always]   | Use this flag to control if the diagnostic results should be saved. If you run without a value (or --save=true), it will only save if the diagnostic tool finds an error. Use --save=always to override this behavior |
| --package={tar|zip} | Creates an easy-to-share package in the desired format (requires the appropriate packages to be installed) |
| --path= | Destination folder to save the diagnostic files. Note: a subdir inside the specified path will be created as follows: (...path)/diagnostic-SPACENAME-TIMESTAMP/ and if flag is omitted, this subdirectory will be created nested to the k2space.sh script |
| --add-file=   | Additional file to be copied to the diagnostic output directory. This flag can be used multiple times, allowing several files to be copied |

**Destroying a Space**
Delete the Fabric Space "spacename". 

It will **not delete the persistent files** created by Web Studio and your database(s). You must manually delete them. These are located in the `persistent-data/spacename` directory.

Use: 
```bash
./k2space.sh destroy spacename
```

### Traefik
Many Traefik-related actions can be executed through `k2space.sh` by using command `ingress` and the desired subcommand. For actions not supported via `k2space.sh`, you may use `docker compose -f k2vingress-compose.yaml (...)`

```bash
Usage: `./k2space.sh ingress SUBCOMMAND`
```

#### Starting Traefik
Traefik starts automatically after you create your first Fabric Space. It will also check whenever a new Fabric Space is created. If it is not running, it will be started automatically.

Before initializing, Traefik will auto-update its image. This behavior can be changed by setting the environment variable `INGRESS_PULL_POLICY="never"` in the .env file (image will need to be pre-loaded with `docker pull` or `docker load` before starting)

> __Note:__ Traefik relies on the Docker network created during the creation of a Fabric Space. Therefore, it must be started __after__ the Fabric Space.

#### Restarting Traefik
To restart Traefik (e.g., after configuring your TLS certificates), run the command below:

```bash
./k2space.sh ingress restart
```
> __Note:__ This command not only restarts Traefik, but it actually completely recreates it

#### Diagnosing Traefik
Use this tool to find useful information if you are having issues when accessing your Space by running the command below:

```bash
./k2space.sh ingress check
```

#### Upgrading Traefik
Forces Traefik's image to be updated. This may cause Spaces to be temporarily unreachable while Traefik reload.

```bash
./k2space.sh ingress update
```

### Adding Users

You are ready to add users. You can experiment with the built-in System DB (for example, PostgreSQL or Cassandra). We recommend using alternative authentication providers rather than relying on the built-in providers.

To use the built-in authentication provider, navigate to the [Web Admin App](https://support.k2view.com/Academy/articles/30_web_framework/03_web_admin_application.html). Select the Security tab, then the Users tab to add a user. Select the Roles tab to create a role (for example, `User`), and assign Fabric permissions to that role.

K2view Fabric Web Studio for Docker Compose uses the underlying Fabric security capabilities and configurations. Fabric supports several authentication providers, each responsible for user authentication and management of user IDs and roles.

The supported authentication providers are described [here](https://support.k2view.com/Academy/articles/26_fabric_security/07_user_IAM_overview.html):

- **Fabric**: Fabric stores users' credentials in a system database table using PostgreSQL. Passwords are stored securely using salted password hashing. By default, Fabric uses a 32-byte salt. When Cassandra is used, the provider is referred to as Cassandra.
- **LDAP**: Fabric authentication is performed through LDAP integration, as described [here](https://support.k2view.com/Academy/articles/26_fabric_security/11_user_IAM_LDAP.html).
- **ADLDAP** (Microsoft Active Directory): Fabric authentication is performed through Active Directory integration, as described [here](https://support.k2view.com/Academy/articles/26_fabric_security/11_user_IAM_LDAP.html).
- **SAML**: Fabric authentication is performed through SAML IdP integration, as described [here](https://support.k2view.com/Academy/articles/26_fabric_security/09_user_IAM_SAML_fundamentals_and_terms.html). SAML enables single sign-on (SSO) with identity providers such as Microsoft Entra ID and Okta. See the [Microsoft Entra ID](https://support.k2view.com/Academy/articles/26_fabric_security/14_user_IAM_SAML_Azure_AD_setup.html) and [Okta](https://support.k2view.com/Academy/articles/26_fabric_security/15_user_IAM_SAML_Okta_setup.html) integration descriptions for details.

### Upgrading to a Later Fabric Version

K2view certifies specific versions. To obtain the list of supported Fabric versions, please create a K2view support ticket via the [My Tickets](https://k2view.freshdesk.com/a/dashboard/default) link from the [K2view Support Site](https://support.k2view.com/).

Before recreating a Space, push any project changes to Git so that your work is preserved. Then upgrade the existing Space to the desired certified Fabric version using `k2space.sh upgrade`:

```bash
./k2space.sh upgrade --fabric-version=VERSION spacename
```

Git is independent of the upgrade command; pushing changes is a precaution to avoid losing project work when the Space is recreated. 


## Reference Information

### k2space.sh OPTIONS Reference

Here are the command options for `k2space.sh`:

| Option            | Description                                                  |
| ----------------- | ------------------------------------------------------------ |
| --profile=        | Allows you to select the desired Fabric Space Profile        |
| --heap=           | Allows you to override the default 4GB allocated heap size   |
| --fabric-version= | Allows you to override the Fabric version specified in the .env file |
| --compose=        | Allows you to use a custom Docker Compose YAML file         |
| --env=            | Allows you to use a custom environment file |
| --project=        | Allows you to specify the Project's name |
| --git-authorship= | Allows you to set the Git AUTHOR and COMMITTER name and email. The value is to be passed in as "name:email". |


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

K2view Fabric Web Studio's Docker Compose runtime supports **per-Space configuration overrides** using custom `.env`, `compose.yaml`, and `.config` files. When a Space is created using `k2space.sh`, the runtime checks for files named for that Space and applies them as described below.

### File Customization Behavior

When creating a Space named, for example, `dcr210`:

- `.env` and `.config` files are appended to the base configuration, with matching values overriding the base values.
- A matching `compose.yaml` file completely replaces the default Compose file for that Space.

#### `.env` Customization

- The base `.env` file is always loaded first.
- If `.env-dcr210` exists, its values are appended to or override those in the base `.env` file.
- Use this file to set Space-specific parameters such as `MAX_HEAP`, `GIT_REPO`, or other custom variables.

#### `compose.yaml` Customization

- The default `compose.yaml` is loaded unless `compose-dcr210.yaml` exists.
- If `compose-dcr210.yaml` exists, it completely replaces the default `compose.yaml` for that Space.

#### `.config` Customization

- The base `common.config` file is always loaded.
- If `dcr210.config` exists, its values are appended to or override settings in `common.config`.
- Use this file to configure Space-specific Fabric runtime behavior, such as a custom System DB path or SSO settings.

### Manual Overrides

You can explicitly specify files when using `k2space.sh`:

```bash
./k2space.sh create --env=custom.env --compose=custom-compose.yaml --config=custom.config dcr210
```

When using `--env` or `--compose`, automatic detection of `.env-[spacename]` and `compose-[spacename].yaml` is skipped.

### Example Use Case

For a Space named `dcr210`, you might create:

- `.env-dcr210` to override heap size:

  ```env
  MAX_HEAP=8G
  ```

- `compose-dcr210.yaml` to expose an additional port (for example, JDBC port 5124):

  ```yaml
  ports:
    - "5124:5124"
  ```

- `dcr210.config` to point to a different System DB path or define SSO behavior:

  ```ini
  [System]
  db.path=/custom/path/system.db
  ```

This mechanism supports shared and isolated runtime customization for Fabric Web Studio Spaces, including multi-tenant development, QA, and demo environments.

## Upgrading this package

The Fabric Web Studio for Docker Compose package is updated periodically to add capabilities and support newer Fabric and Web Studio versions. Keeping the package current is important because operational capabilities, including Space upgrade functionality, may depend on changes delivered with the package.

Upgrading the package does **not** require recreating existing Spaces. Space data and configuration are maintained separately under the `persistent-data` directory and must be preserved during the package upgrade.

Detailed instructions are available [here](https://support.k2view.com/Academy/articles/98_installation_and_upgrade/Install_Fabric_Web_Studio_v2-1/Installation.html#upgrading-this-package). In general:

1. Back up customized files (such as `.env`, SSL certificates, and other configuration files).
2. Download and extract the new package.
3. Merge your customized files into the corresponding files distributed with the new package.
