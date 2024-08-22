#!/bin/bash

# MySQL Server 5.7 で Database の一覧を表示
${MYSQL_DIR}/80sh/bin/mysqlsh root@localhost:3357 --sql -e"SHOW DATABASES;"
