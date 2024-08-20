. ./scripts/comm.sh

${MYSQL_DIR}/80sh/bin/mysqlsh root@localhost:3357 --js -e"util.checkForServerUpgrade();"
