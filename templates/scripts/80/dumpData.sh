#!/bin/bash

# MySQL Shell 8.0 を用いて、MySQL Server 8.0 のインスタンスダンプを行う
${MYSQL_DIR}/80sh/bin/mysqlsh root@localhost:3380 --js -e"util.dumpInstance('${MYSQL_DIR}/dump/80');"
