#!/bin/bash

if [ ! -d /var/log/apache2 ]; then
  mkdir -p /var/log/apache2
fi

LOGFILES="/var/log/apache2/access.log /var/log/apache2/error.log"

touch $LOGFILES

exec tail -f $LOGFILES &
exec "$@"
