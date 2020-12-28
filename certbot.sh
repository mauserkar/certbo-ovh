#!/bin/bash

if [ ! -f /root/.ovhapi ]; then
    echo "dns_ovh_endpoint = ovh-eu" > /root/.ovhapi 
    echo "dns_ovh_application_key = $OVH_AKEY" >> /root/.ovhapi
    echo "dns_ovh_application_secret = $OVH_SECRET" >> /root/.ovhapi
    echo "dns_ovh_consumer_key = $OVH_CKEY" >> /root/.ovhapi
    chmod 600 /root/.ovhapi
fi

if [ ! -f /root/start.lock ]; then
    touch /root/start.lock
    /usr/local/bin/certbot certonly  \
        --dns-ovh \
        --dns-ovh-credentials /root/.ovhapi \
        --non-interactive \
        --agree-tos \
        --email $CERTBOT_EMAIL \
        -d $CERTBOT_DOMAIN \
        -d *.$CERTBOT_DOMAIN
    cron -f 8
fi

if [ -f /root/start.lock ]; then
    /usr/local/bin/certbot certonly \
        --dns-ovh \
        --dns-ovh-credentials /root/.ovhapi \
        --non-interactive \
        --agree-tos \ 
        --email $CERTBOT_EMAIL \
        -d $CERTBOT_DOMAIN \ 
        -d *.$CERTBOT_DOMAIN
fi
