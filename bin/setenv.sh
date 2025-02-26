#!/bin/bash

# setenv.sh
if [ -f "/mnt/secrets-store/mysql-secrets/mysql-password" ]; 
then
export MYSQL_PASSWORD=$(cat /mnt/secrets-store/mysql-secrets/mysql-password)
fi

export CATALINA_OPTS="$CATALINA_OPTS -DMYSQL_PASSWORD=$MYSQL_PASSWORD"
