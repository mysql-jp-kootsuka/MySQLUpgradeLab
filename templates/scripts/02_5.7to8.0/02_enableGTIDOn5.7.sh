#!/bin/bash

MSH=${MYSQL_DIR}/80sh/bin/mysqlsh
BIN=${MYSQL_DIR}/57/bin/mysqld
SRV=root@localhost:3357
CONF=${MYSQL_DIR}/configs/my57_gtid.cnf
OPT=\\"--sql\\"
SQL1=\\"SHOW VARIABLES LIKE '%gtid%';\\"
COMMAND1=\\"\\$MSH \\$SRV \\$OPT -e\\\\\\"\\$SQL1\\\\\\"\\"
COMMAND2=\\"\\$MSH \\$SRV \\$OPT -e\\\\\\"SHUTDOWN;\\\\\\"\\"
COMMAND3=\\"\\$BIN --defaults-file=\\$CONF &\\"

echo \\"02-02: MySQL Server 5.7 でGTID (グローバルトランザクション識別子) を有効化し、バイナリログを出力するよ
うにします。\\"
echo \\"GTIDがオンになっていると、レプリケーション設定時に、SOURCE_AUTO_POSITIONオプションでトランザクションの
場所が自動指定できます。\\"
echo \\"まず、現在のGTIDの設定 (enforce_gtid_consistency、gtid_mode) がオフであることを確認します。\\"
echo \\"実行するスクリプト:\\"
echo \\"=====\\"
echo \\$COMMAND1
echo \\"=====\\"
echo \\"ENTER キーを押すと実行します:\\"
echo

read tmp
eval \\$COMMAND1
if [ $? -gt 0 ]; then
  echo \\"エラーが発生しました、環境を確認してください。\\"
  exit 1
fi

echo \\"enforce_gtid_consistency、gtid_modeをオンにするために、設定ファイルを差し替えて再起動します。\\"
echo \\"実行するスクリプト:\\"
echo \\"=====\\"
echo \\$COMMAND2
echo \\"sleep 5\\"
echo \\$COMMAND3
echo \\"=====\\"
echo
echo \\"設定ファイルの内容: \\"
echo \\"=====\\"
cat \\$CONF
echo \\"=====\\"
echo
echo \\"ENTER キーを押すと実行します:\\"
echo

read tmp
eval \\"\\$COMMAND2;sleep 5;\\$COMMAND3\\"
if [ $? -gt 0 ]; then
  echo \\"エラーが発生しました、環境を確認してください。\\"
  exit 1
fi

echo \\"再起動したMySQL Server 5.7 でGTIDがオンになったのを確認します。\\"
echo \\"実行するスクリプト:\\"
echo \\"=====\\"
echo \\$COMMAND1
echo \\"=====\\"
echo \\"ENTER キーを押すと実行します:\\"
echo

read tmp
eval \\$COMMAND1
if [ $? -gt 0 ]; then
  echo \\"エラーが発生しました、環境を確認してください。\\"
  exit 1
fi

echo
echo \\"MySQL Server 5.7 で GTID がオンになり、バイナリログが出力されるようになりました。\\"
echo