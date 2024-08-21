#!/bin/bash

BIN=${MYSQL_DIR}/57/bin/mysqld
CONF=${MYSQL_DIR}/configs/my57.cnf
COMMAND=\\"\\$BIN --defaults-file=\\$CONF &\\"

echo \\"01-01: MySQL Server 5.7 をスタートします\\"
echo \\"実行するスクリプト:\\"
echo \\$COMMAND
echo 
echo \\"ポート 3357 (設定ファイル内で指定) で待ち受ける MySQL Server 5.7 をスタートします\\"
echo
echo \\"ENTER キーを押すと実行します:\\"

read tmp
\\$COMMAND
