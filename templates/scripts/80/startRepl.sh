#!/bin/bash

# MySQL Server 8.0 でレプリケーションを開始
${MYSQL_DIR}/80sh/bin/mysqlsh root@localhost:3380 --sql -e"START REPLICA USER='root' PASSWORD='';"
