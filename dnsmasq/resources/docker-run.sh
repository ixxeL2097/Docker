#!/bin/bash

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