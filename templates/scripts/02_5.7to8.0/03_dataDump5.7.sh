#!/bin/bash




${MYSQL_DIR}/80sh/bin/mysqlsh root@localhost:3357 --js -e\\"util.dumpInstance('${MYSQL_DIR}/sql/57dump');\\"
