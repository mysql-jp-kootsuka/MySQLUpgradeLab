#!/bin/bash

# MySQL Server 8.4 でレプリケーションを開始
${MYSQL_DIR}/84sh/bin/mysqlsh root@localhost:3384 --sql -e"START REPLICA USER='root' PASSWORD='';"
