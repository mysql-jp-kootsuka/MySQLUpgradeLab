#!/bin/bash

BIN=${MYSQL_DIR}/80/bin/mysqld
CONF=${MYSQL_DIR}/configs/my80.cnf
COMMAND1=\\"\\$BIN --defaults-file=\\$CONF --initialize-insecure\\"
COMMAND2=\\"\\$BIN --defaults-file=\\$CONF &\\"

echo \\"01-02: MySQL Server 8.0 の初期化を行います\\"
echo \\"実行するスクリプト:\\"
echo \\$COMMAND1
echo 
echo \\"MySQL 8.0 (\\$BIN) を、設定ファイル (\\$CONF) を用いて初期化します。\\"
echo
echo \\"設定ファイルの内容: \\"
cat \\$CONF
echo
echo \\"ENTER キーを押すと実行します:\\"

read tmp
\\$COMMAND1 || echo \\"エラーが発生しました、環境を確認してください。\\" && exit 1

echo \\"続いて MySQL Server 8.0 の起動を行います\\"
echo \\"実行するスクリプト:\\"
echo \\$COMMAND2

echo \\"ENTER キーを押すと実行します:\\"

read tmp
\\$COMMAND2 || echo \\"エラーが発生しました、環境を確認してください。\\" && exit 1

echo \\"MySQL Server 8.0 の起動が完了しました。\\"
