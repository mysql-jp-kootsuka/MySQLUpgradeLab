#!/bin/bash

# MySQL Server 5.7 に world データベースを SQL から読み込み
${MYSQL_DIR}/80sh/bin/mysqlsh root@localhost:3357 --sql -e"source ${MYSQL_DIR}/sql/world.sql;"
