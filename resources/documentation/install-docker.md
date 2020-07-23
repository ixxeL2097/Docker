[Retour menu principal](../README.md)

# Install docker and docker-compose on CentOS 7
install dependencies
```bash
yum install -y yum-utils device-mapper-persistent-data lvm2
  ```
add repository
 ```bash
yum-config-manager -y --add-repo https://download.docker.com/linux/centos/docker-ce.repo
  ```
actually install docker
```bash
yum install -y docker-ce docker-ce-cli containerd.io
```
add current user to docker group
```bash
usermod -aG docker $(whoami)
```
enable docker at system start and start it
```bash
systemctl enable docker
systemctl start docker
```
add extra package repository
```bash
yum install -y epel-release
```
install development kit tools
```bash
yum -y install @development
```
install python 3 and pip installer
```bash
yum -y install centos-release-scl
yum -y install rh-python36
scl enable rh-python36 bash
yum -y install python3-pip
pip3 install --upgrade pip
```
install docker-compose
```bash
pip3 install docker-compose
```

# Docker behind a proxy

Follow official documentation :

- https://docs.docker.com/config/daemon/systemd/#httphttps-proxy

**/!\ WARNING : rootless mode instructions is not working for CentOS7 and RHEL 7 !**

1. Create a systemd drop-in directory for the docker service:

```
mkdir -p /etc/systemd/system/docker.service.d
```

2. Create a file named `/etc/systemd/system/docker.service.d/http-proxy.conf` that adds the HTTP_PROXY environment variable:

```
[Service]
Environment="HTTP_PROXY=http://proxy.example.com:80"
Environment="HTTPS_PROXY=https://proxy.example.com:443"
Environment="NO_PROXY=localhost,127.0.0.1,docker-registry.example.com,.corp"
```

3. Flush changes and restart Docker:

```
systemctl daemon-reload
systemctl restart docker
```

4. Verify that the configuration has been loaded and matches the changes you made, for example:

```
systemctl show --property=Environment docker
```

# Move docker's default registry

The standard data directory used for docker is `/var/lib/docker`, and since this directory will store all your images, volumes, etc. it can become quite large in a relative small amount of time.
you can check size :

```console
[root@vlvjfr01 ~]# df -Th /var/lib/docker
Filesystem                Type  Size  Used Avail Use% Mounted on
/dev/mapper/rootvg-lv_var xfs   2.0G  1.2G  875M  58% /var
```

Create a new partition:

```
fdisk /dev/sdd
mkfs.xfs -L docker /dev/sdd1
```

edit `/etc/fstab` and copy paste :

```
LABEL=docker    /docker xfs     defaults  1 1
```

Stop docker engine and edit `/etc/docker/daemon.json` file to register your new directory :

```console
[root@vlvjfr01 ~]# systemctl stop docker
[root@vlvjfr01 ~]# vi /etc/docker/daemon.json
[root@vlvjfr01 ~]# cat /etc/docker/daemon.json
{
 "graph": "/docker"
}
```

Start docker engine and test pulling image :

```
[root@vlvjfr01 ~]# systemctl start docker
[root@vlvjfr01 ~]# docker pull docker.bintray.io/jfrog/artifactory-pro:latest
latest: Pulling from jfrog/artifactory-pro
25e46ad006a2: Pull complete 
06ea0fb6fd44: Pull complete 
ec5405997a44: Pull complete 
c163ef759c66: Pull complete 
62fac5701b87: Pull complete 
22b2b3ba10f4: Pull complete 
a2a876277c7c: Pull complete 
ecceec5d51d1: Pull complete 
91d2b8d33213: Pull complete 
e544dceec389: Pull complete 
013d8beae8da: Pull complete 
Digest: sha256:81b9589868a8b81774997c9b02ecfac4ae27a0a4cf392cce35a3594d0233b74e
Status: Downloaded newer image for docker.bintray.io/jfrog/artifactory-pro:latest
docker.bintray.io/jfrog/artifactory-pro:latest
```


---------------------------------------------------------------------------------------------------------------------------------

[Retour menu principal](../README.md)

[Suivant](docker-CLI.md)
