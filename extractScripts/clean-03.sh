. ./common/comm.sh

CONFIG_DIR="$MYSQL_DIR/configs"
SCRIPT_DIR="$MYSQL_DIR/scripts"
DATA_DIR="$MYSQL_DIR/data"
DUMP_DIR="$MYSQL_DIR/dump"

$MYSQL_DIR/80sh/bin/mysqlsh root@localhost:3357 --sql -e"SHUTDOWN;"
$MYSQL_DIR/80sh/bin/mysqlsh root@localhost:3380 --sql -e"SHUTDOWN;"
$MYSQL_DIR/84sh/bin/mysqlsh root@localhost:3384 --sql -e"SHUTDOWN;"
$MYSQL_DIR/90sh/bin/mysqlsh root@localhost:3390 --sql -e"SHUTDOWN;"

rm -r $CONFIG_DIR
rm -r $SCRIPT_DIR
rm -r $DATA_DIR
rm -r $DUMP_DIR
