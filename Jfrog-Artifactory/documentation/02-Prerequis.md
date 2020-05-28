[Main menu](../README.md)

## 2. Requirements

Here is the directory structure of Jfrog:

![](../pictures/directory-struct.png)

"*" : signigie que les répertoires sont personnalisables. 

Here is a classical directory layout for all Jfrog products :

![](../pictures/layout-directory.png)

Supported platforms are the following :

- Linux
  - Debian 8.x ou 9.x
  - CentOS / RHEL 6.x ou 7.x
  - Ubuntu 16.04 ou 18.04
- Windows Server 2008R2, 2016 ou 2019

Here you can find minimal requirements for Artifactory product :

![](../pictures/recommandations.png)

For Docker and docker-compose installation, Jfrog needs at least **Docker v18** and **Docker-Compose v1.24**.

Jfrog provide a flexible way to configure your système by using a simple yaml file ```system.yaml``` located in the ```$JFROG_HOME/<product>/var/etc``` directory of each product. This file provide controls over resources, security, BDD etc...
All possible configurations are available in the yaml template file located in ```$JFROG_HOME/<product>/var/etc/``` directory.

For **Artifactory** product, please take a look at the following templates :

- ```system.basic-template.yaml```
- ```system.full-template.yaml``` 

located in ```$JFROG_HOME/artifactory/var/etc/``` directory.

---------------------------------------------------------------------------------------------------------------------------------

[Main menu](../README.md)

[Next](03-Installation-version-free.md)
