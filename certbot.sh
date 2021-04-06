#!/bin/bash

if [ ! -f /root/.ovhapi ]; then
    echo "dns_ovh_endpoint = ovh-eu" > /root/.ovhapi 
    echo "dns_ovh_application_key = $OVH_AKEY" >> /root/.ovhapi
    echo "dns_ovh_application_secret = $OVH_SECRET" >> /root/.ovhapi
    echo "dns_ovh_consumer_key = $OVH_CKEY" >> /root/.ovhapi
    chmod 600 /root/.ovhapi
fi

CHECKEMPTYFOLDER=$(test -z "$(ls -A /etc/letsencrypt)"; echo $?)

if [ ! -f /root/start.lock ] && [ $CHECKEMPTYFOLDER -eq 0 ]; then
    touch /root/start.lock
    echo "### Creating cert: $(date +%H%M%S-%d%m%Y) ###"
    /usr/local/bin/certbot certonly  \
        --dns-ovh \
        --dns-ovh-credentials /root/.ovhapi \
        --dns-ovh-propagation-seconds 70 \
        --non-interactive \
        --agree-tos \
        --email "$CERTBOT_EMAIL" \
        -d "$CERTBOT_DOMAIN" \
        -d "*.$CERTBOT_DOMAIN"
    if [ $? -eq 0 ]; then
        echo "### cron start: $(date +%H%M%S-%d%m%Y) ###"
        cron -f 8
    else
        echo "### Fail to create cert: $(date +%H%M%S-%d%m%Y) ###"
        exit 1
    fi
fi

if [ -f /root/start.lock ] ; then
    echo "### Renew cert: $(date +%H%M%S-%d%m%Y) ###"
    /usr/local/bin/certbot certonly \
        --dns-ovh \
        --dns-ovh-credentials /root/.ovhapi \
        --dns-ovh-propagation-seconds 70 \
        --non-interactive \
        --agree-tos \
        --email "$CERTBOT_EMAIL" \
        -d "$CERTBOT_DOMAIN" \
        -d "*.$CERTBOT_DOMAIN"
fi
