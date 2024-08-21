#!/bin/bash

rm ${MYSQL_DIR}/sql/57dump/load-progress.*
${MYSQL_DIR}/80sh/bin/mysqlsh root@localhost:3380 --js -e\\"util.loadDump\\('${MYSQL_DIR}/sql/57dump',{ignoreVersion:true})\\;\\"
