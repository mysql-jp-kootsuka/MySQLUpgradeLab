#!/bin/bash

# MySQL Shell 9.0 を用いて、MySQL Server 8.4 から 9.0 へのアップグレードチェックを行う
${MYSQL_DIR}/90sh/bin/mysqlsh root@localhost:3384 --js -e"util.checkForServerUpgrade();"
