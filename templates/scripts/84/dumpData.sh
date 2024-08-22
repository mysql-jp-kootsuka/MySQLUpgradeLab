#!/bin/bash

# MySQL Shell 8.4 を用いて、MySQL Server 8.4 のインスタンスダンプを行う
${MYSQL_DIR}/84sh/bin/mysqlsh root@localhost:3384 --js -e"util.dumpInstance('${MYSQL_DIR}/dump/84');"
