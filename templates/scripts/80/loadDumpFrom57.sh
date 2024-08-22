#!/bin/bash

# MySQL Server 5.7 のダンプデータを MySQL Server 8.0 でロード
# 前回のロードが中途で終わっていてload-progress.*が残っていると、ロードが失敗するので削除
rm ${MYSQL_DIR}/dump/57/load-progress.*
# ignoreVersion オプションは、ダンプとロードの MySQL Server バージョンが異なっていても無視する設定
${MYSQL_DIR}/80sh/bin/mysqlsh root@localhost:3380 --js -e"util.loadDump('${MYSQL_DIR}/dump/57',{ignoreVersion:true});"
