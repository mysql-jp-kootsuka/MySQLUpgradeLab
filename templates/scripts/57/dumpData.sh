#!/bin/bash

# MySQL Shell 8.0 を用いて、MySQL Server 5.7 のインスタンスダンプを行う
${MYSQL_DIR}/80sh/bin/mysqlsh root@localhost:3357 --js -e"util.dumpInstance('${MYSQL_DIR}/dump/57');"
