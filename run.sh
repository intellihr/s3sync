#!/usr/bin/env sh

if [ -n "$CRON_SCHEDULE" ]; then
  exec /opt/mantra "$CRON_SCHEDULE" /opt/sync.sh
else
  exec /opt/sync.sh
fi
