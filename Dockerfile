FROM ubuntu:jammy

LABEL version="1.0"
LABEL description="Creates a dnsmasq conf file for Lancache forwarding based on cache-domain data"

ENV WORK_DIR="/opt/app"
ENV CACHE_DOMAIN_GIT_URL="https://github.com/uklans/cache-domains.git"
ENV CACHE_DOMAIN_SCRIPTS_DIR="/tmp/cache_domain_scripts"
ENV DNSMASQD_DIR="/etc/dnsmasq.d"
ENV CROND_DIR="/etc/cron.d"
ENV LANCACHE_IP=""
ENV CRON_EXPRESSION="* * * * *"

WORKDIR $WORK_DIR

RUN \
  apt-get update && \
  apt-get -y install cron git jq

COPY scripts/ $WORK_DIR
COPY config.template.json $WORK_DIR

COPY cron/ $CROND_DIR
RUN chmod 0644 $CROND_DIR/cache-domain-generator
RUN crontab /etc/cron.d/cache-domain-generator

CMD sh start.sh
