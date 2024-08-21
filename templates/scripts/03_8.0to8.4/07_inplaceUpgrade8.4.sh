#!/bin/bash

${MYSQL_DIR}/84sh/bin/mysqlsh root@localhost:3384 --sql -e\\"STOP REPLICA FOR CHANNEL \\'\\'\\;SHUTDOWN\\;\\"
sleep 1
${MYSQL_DIR}/84/bin/mysqld --defaults-file=${MYSQL_DIR}/configs/my84.cnf \\&
