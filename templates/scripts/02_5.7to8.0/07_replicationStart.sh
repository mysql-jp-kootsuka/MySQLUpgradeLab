#!/bin/bash

${MYSQL_DIR}/80sh/bin/mysqlsh root@localhost:3380 --sql -e\\"START REPLICA USER=\\'root\\' PASSWORD=\\'\\'\\;\\"
sleep 1
${MYSQL_DIR}/80sh/bin/mysqlsh root@localhost:3380 --sql -e\\"SHOW REPLICA STATUS\\\\G\\"
