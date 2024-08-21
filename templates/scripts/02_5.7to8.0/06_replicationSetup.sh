. ./scripts/comm.sh

${MYSQL_DIR}/80sh/bin/mysqlsh root@localhost:3380 --sql -e"CHANGE REPLICATION SOURCE TO SOURCE_HOST = 'localhost', SOURCE_PORT = 3357, SOURCE_AUTO_POSITION = 1, SOURCE_SSL = 1;"
