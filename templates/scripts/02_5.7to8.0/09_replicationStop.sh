. ./scripts/comm.sh

${MYSQL_DIR}/80sh/bin/mysqlsh root@localhost:3380 --sql -e"STOP REPLICA FOR CHANNEL '';RESET REPLICA;"
