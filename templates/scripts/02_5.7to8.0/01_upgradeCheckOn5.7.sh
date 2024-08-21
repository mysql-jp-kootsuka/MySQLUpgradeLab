#!/bin/bash

MSH=${MYSQL_DIR}/80sh/bin/mysqlsh
SRV=root@localhost:3357
OPT=\\"--js\\"
SQL=\\"util.checkForServerUpgrade();\\"
COMMAND=\\"\\$MSH \\$SRV \\$OPT -e\\\\\\"\\$SQL\\\\\\"\\"

echo \\"02-02: MySQL Server 5.7 から 8.0 へのアップグレードの適合性をチェックします。\\"
echo \\"実行するスクリプト:\\"
echo \\"=====\\"
echo \\$COMMAND
echo \\"=====\\"
echo \\"ENTER キーを押すと実行します:\\"
echo

read tmp
eval \\$COMMAND
if [ $? -gt 0 ]; then
  echo \\"エラーが発生しました、環境を確認してください。\\"
  exit 1
fi

echo
echo \\"アップグレードチェッカーが完了しました。\\"
echo \\"Errors 項目がないかを確認してください。Notices, Warnings のみであればアップデート可能です。\\"
echo