#!/bin/bash


DOMAIN="lesson8.local"

SERVER_IP="192.168.56.10"



apt update

apt install -y ca-certificates openssl curl



echo "$SERVER_IP $DOMAIN www.$DOMAIN" >> /etc/hosts


openssl s_client \
-connect $DOMAIN:443 \
-showcerts </dev/null 2>/dev/null \
| openssl x509 \
-outform PEM \
> /usr/local/share/ca-certificates/$DOMAIN.crt



update-ca-certificates



echo "Certificate installed"
