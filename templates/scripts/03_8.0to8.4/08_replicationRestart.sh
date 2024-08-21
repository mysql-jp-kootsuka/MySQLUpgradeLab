#!/bin/bash

${MYSQL_DIR}/84sh/bin/mysqlsh root@localhost:3384 --sql -e"START REPLICA USER='root' PASSWORD='';"
sleep 1
${MYSQL_DIR}/84sh/bin/mysqlsh root@localhost:3384 --sql -e"SHOW REPLICA STATUS\G"
