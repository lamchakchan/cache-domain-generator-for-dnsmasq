#!/usr/bin/env bash

YELLOW="\033[1;33m"
CYAN="\033[0;36m"
NOCOLOR="\033[0m"

print_banner() {
  echo "$YELLOW
========================================================================
$1
========================================================================
$NOCOLOR"  
}

execute() {
  set -x
  "$@"
  { set +x; } 2>/dev/null
}

execute_wrap() {
  echo "$CYAN
------------------------------------------------------------------------"
  set -x
  "$@"
  { set +x; } 2>/dev/null
  echo "------------------------------------------------------------------------
$NOCOLOR"
}

if [ ! -d "$CACHE_DOMAIN_SCRIPTS_DIR" ]; then
  print_banner "creating cache-domain directory in ($CACHE_DOMAIN_SCRIPTS_DIR)"
  execute mkdir -p "$CACHE_DOMAIN_SCRIPTS_DIR"
fi

if [ ! -d "$DNSMASQD_DIR" ]; then
  print_banner "creating dnsmasq.d directory in ($DNSMASQD_DIR)"
  execute mkdir -p "$DNSMASQD_DIR"
fi

print_banner "pulling cache-domain from ($CACHE_DOMAIN_GIT_URL)"
execute sh -c "cd $CACHE_DOMAIN_SCRIPTS_DIR && git clone $CACHE_DOMAIN_GIT_URL ."

print_banner "seeding config.json files"
execute cp "$WORK_DIR/config.template.json" "$CACHE_DOMAIN_SCRIPTS_DIR/scripts/config.json"
execute sed -i -e "s/{NETWORK_ADDRESS}/$LANCACHE_IP/g" "$CACHE_DOMAIN_SCRIPTS_DIR/scripts/config.json"
execute_wrap cat "$CACHE_DOMAIN_SCRIPTS_DIR/scripts/config.json"

print_banner "generating dnsmasq.d configuration"
execute sh -c "cd $CACHE_DOMAIN_SCRIPTS_DIR/scripts && ./create-dnsmasq.sh"
execute sh -c "cd $CACHE_DOMAIN_SCRIPTS_DIR/scripts/output/dnsmasq/ && cat $CACHE_DOMAIN_SCRIPTS_DIR/scripts/output/dnsmasq/* > $DNSMASQD_DIR/99_lancache.conf"
execute_wrap cat "$DNSMASQD_DIR/99-lancache.conf"

# Clean up
print_banner "clean up"
execute rm -rf "$CACHE_DOMAIN_SCRIPTS_DIR"
