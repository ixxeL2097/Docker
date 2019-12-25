# Docker
General repo for docker scripts
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
