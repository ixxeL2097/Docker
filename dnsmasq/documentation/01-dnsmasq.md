# Install DNSMASQ with docker

dnsmasq in a docker container, configurable via a simple web UI.

Create a `dnsmasq.conf` file on the Docker host :

```
#dnsmasq config, for a complete example, see:
#  http://oss.segetech.com/intra/srv/dnsmasq.conf

user=dnsmasq
group=dnsmasq

#log all dns queries
#log-queries

#dont use hosts nameservers
#no-resolv

#use cloudflare as default nameservers, prefer 1^4
server=1.0.0.1
server=1.1.1.1
strict-order

#serve all .company queries using a specific nameserver
#server=/company/10.0.0.1

#interface=eth0

#explicitly define host-ip mappings
address=/fredcorp.com/192.168.0.150

#listen-address=::1,127.0.0.1,192.168.0.201

#conf-dir=/etc/dnsmasq.d,.rpmnew,.rpmsave,.rpmorig
```

systemd-resolved provides resolver services for Domain Name System (DNS) (including DNSSEC and DNS over TLS), Multicast DNS (mDNS) and Link-Local Multicast Name Resolution (LLMNR).

The resolver can be configured by editing `/etc/systemd/resolved.conf` and/or drop-in .conf files in `/etc/systemd/resolved.conf.d/`.

To use our dnsmasq container you either keep it running and specify your external IP address in docker port mapping (ex: 192.168.0.1:53:53/udp) or disable it :

```shell
systemctl stop systemd-resolved
```

On CentOS, you need to configure firewalld and add your docker interfaces :

```shell
firewall-cmd --permanent --zone=trusted --change-interface=docker0
firewall-cmd --reload
```

and also disable `SElinux` if you need to :

```shell
setenforce 0
```

Now you can execute your container :

```
docker run --name dnsmasq \
           --rm \
           -d \
           -p 53:53/udp \
           -p 5380:8080 \
           -v /root/docker-projects/dnsmasq/dnsmasq.conf:/etc/dnsmasq.conf \
           --log-opt "max-size=100m" \
           -e "HTTP_USER=dnsmasq" \
           -e "HTTP_PASS=dnsmasq" \
           jpillora/dnsmasq
```

Or you can use `docker-compose.yaml` file :

```yaml
version: '3'
services:
  dnsmasq:
    image: jpillora/dnsmasq
    container_name: dnsmasq
    restart: always
    environment:
     - HTTP_USER=${HTTP_USER}
     - HTTP_PASS=${HTTP_PASS}
    ports:
      - 53:53/udp
      - 53:53/tcp
      - 5380:8080
    volumes:
     - ${DATA_DIR}/dnsmasq.conf:/etc/dnsmasq.conf
     - /etc/localtime:/etc/localtime:ro
    logging:
      driver: "json-file"
      options:
        max-size: "100m"
        max-file: "3"
    networks:
     - dnsmasq
networks:
  dnsmasq:
    driver: bridge
    driver_opts:
      com.docker.network.bridge.name: "docker1"
      com.docker.network.bridge.mtu: "1500"
```

In this example, we add a new interface `docker1` so you need to update firewalld configuration :

```shell
firewall-cmd --permanent --zone=trusted --change-interface=docker1
firewall-cmd --reload
```

Start your container :

```shell
docker-compose up -d
```

If you want to tweak your docker-compose network configuration here are Docker documentation variables:

```
Option 	                                            Equivalent 	                    Description
com.docker.network.bridge.name 	                        - 	                        Bridge name to be used when creating the Linux bridge
com.docker.network.bridge.enable_ip_masquerade 	    --ip-masq 	                    Enable IP masquerading
com.docker.network.bridge.enable_icc 	            --icc 	                        Enable or Disable Inter Container Connectivity
com.docker.network.bridge.host_binding_ipv4 	    --ip 	                        Default IP when binding container ports
com.docker.network.driver.mtu 	                    --mtu 	                        Set the containers network MTU
com.docker.network.container_interface_prefix 	        - 	                        Set a custom prefix for container interfaces
```

Display used networks :

```shell
docker network ls
NETWORK ID          NAME                DRIVER              SCOPE
d17c994f96a5        bridge              bridge              local
c4120be90db0        host                host                local
4ac40631f43b        none                null                local
```

You can inspect network settings : 

```shell
docker network inspect bridge
```

Default docker network options : 

```json
"Options": {
            "com.docker.network.bridge.default_bridge": "true",
            "com.docker.network.bridge.enable_icc": "true",
            "com.docker.network.bridge.enable_ip_masquerade": "true",
            "com.docker.network.bridge.host_binding_ipv4": "0.0.0.0",
            "com.docker.network.bridge.name": "docker0",
            "com.docker.network.driver.mtu": "1500"
}
```

```
firewall-cmd --permanent --zone=trusted --change-interface=docker0
firewall-cmd --permanent --zone=trusted --change-interface=docker1
firewall-cmd --permanent --zone=trusted --add-port=4243/tcp
firewall-cmd --add-service=dns --permanent
firewall-cmd --add-service=dhcp --permanent
firewall-cmd --reload
```



