#!/bin/bash

MSH=${MYSQL_DIR}/80sh/bin/mysqlsh
SRV=root@localhost:3357
OPT=\\"--sql\\"
SQL1=\\"source ${MYSQL_DIR}/sql/world.sql;\\"
SQL2=\\"SHOW DATABASES;\\"
COMMAND1=\\"\\$MSH \\$SRV \\$OPT -e\\\\\\"\\$SQL1\\\\\\"\\"
COMMAND2=\\"\\$MSH \\$SRV \\$OPT -e\\\\\\"\\$SQL2\\\\\\"\\"

echo \\"01-03: MySQL Server 5.7 にWORLDデータベースを読み込みます。\\"
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

echo \\"WORLDデータベースが生成できたことを確認します。\\"
echo \\"実行するスクリプト:\\"
echo \\"=====\\"
echo \\$COMMAND2
echo \\"=====\\"
echo \\"ENTER キーを押すと実行します:\\"
echo

read tmp
eval \\$COMMAND2
if [ $? -gt 0 ]; then
  echo \\"エラーが発生しました、環境を確認してください。\\"
  exit 1
fi

echo
echo \\"WORLDデータベースが含まれていれば、読み込みが完了しました。\\"
echo