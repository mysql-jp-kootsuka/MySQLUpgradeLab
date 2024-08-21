#!/bin/bash

${MYSQL_DIR}/84sh/bin/mysqlsh root@localhost:3384 --sql -e"CHANGE REPLICATION SOURCE TO SOURCE_HOST = 'localhost', SOURCE_PORT = 3380, SOURCE_AUTO_POSITION = 1, SOURCE_SSL = 1;"
sleep 1
${MYSQL_DIR}/84sh/bin/mysqlsh root@localhost:3384 --sql -e"START REPLICA USER = 'root' PASSWORD='';"
sleep 1
${MYSQL_DIR}/84sh/bin/mysqlsh root@localhost:3384 --sql -e"SHOW REPLICA STATUS\G"
