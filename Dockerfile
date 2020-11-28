FROM python:stretch

RUN apt-get update && apt-get install -yy python3-pip cron
RUN pip install certbot
RUN pip install certbot-dns-ovh

COPY certbot.cron /etc/cron.d/cerbotCron
COPY certbot.logrotate /etc/logrotate.d/certbot
COPY certbot.sh /certbot-renew.sh
RUN chmod +x /certbot.sh

VOLUME [ "/etc/letsencrypt" ]

CMD [ "/certbot.sh" ]
