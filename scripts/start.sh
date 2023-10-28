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

print_banner "configuring environment"
execute printenv > /etc/environment

print_banner "configuring cron"
execute sed -i -e "s/{CRON_EXPRESSION}/$CRON_EXPRESSION/g" "$CROND_DIR/cache-domain-generator"
execute crontab "$CROND_DIR/cache-domain-generator"
execute_wrap cat "$CROND_DIR/cache-domain-generator"
execute cron -f