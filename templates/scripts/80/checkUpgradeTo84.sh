#!/bin/bash

# MySQL Shell 8.4 を用いて、MySQL Server 8.0 から 8.4 へのアップグレードチェックを行う
${MYSQL_DIR}/84sh/bin/mysqlsh root@localhost:3380 --js -e"util.checkForServerUpgrade();"
