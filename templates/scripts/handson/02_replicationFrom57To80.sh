. ./scripts/commons/functions.sh

cat << STEP2_1
# ハンズオン手順2: MySQL Server 5.7 から 8.0 への、データのダンプ/ロードとレプリケーションを通じたアップグレード

## 02-01: MySQL Server 5.7 から 8.0 へのアップグレードの適合性をチェック

MySQL Shell 8.0 を用いて、アップグレードチェッカーを実行します。
(アップグレードチェッカーに関する情報は: https://dev.mysql.com/doc/mysql-shell/8.4/en/mysql-shell-utilities-upgrade.html)

実行するスクリプト \`./scripts/57/checkUpgradeTo80.sh\`:
STEP2_1

extractFile "scripts/57/checkUpgradeTo80.sh"

waitRun

runAndTrapError "scripts/57/checkUpgradeTo80.sh"

cat << STEP2_2
アップグレードチェッカーが完了しました。
Errors 項目がないかを確認してください。Notices, Warnings のみであればアップデート可能です。


STEP2_2

sleep 4

cat << STEP2_3
## 02-02: MySQL Server 5.7 でGTID (グローバルトランザクション識別子) を有効化

MySQL Server 5.7 でGTID (グローバルトランザクション識別子) を有効化し、バイナリログを出力するようにします。
GTIDがオンになっていると、レプリケーション設定時に、SOURCE_AUTO_POSITIONオプションでトランザクションの場所が自動指定できます。
(GTID に関する情報は: https://dev.mysql.com/doc/refman/8.4/en/replication-gtids-concepts.html)
まず、現在のGTIDの設定 (gtid_mode) がオフであることを確認します。

実行するスクリプト \`./scripts/57/checkGTIDVar.sh\`:
STEP2_3

extractFile "scripts/57/checkGTIDVar.sh"

waitRun

runAndTrapError "scripts/57/checkGTIDVar.sh"

sleep 2

cat << STEP2_4
enforce_gtid_consistency、gtid_modeをオンにするために、設定ファイルを差し替えて再起動します。

実行するスクリプト \`./scripts/57/stopDB.sh\`,\`./scripts/57/startDBwGTID.sh\`:
STEP2_4

extractFile "scripts/57/startDBwGTID.sh"

cat << STEP2_5
MySQL 設定ファイルの内容 \`./configs/my57_gtid.cnf\`:
STEP2_5

extractFile "configs/my57_gtid.cnf"

waitRun

runAndTrapError "scripts/57/stopDB.sh"
sleep 2
runAndTrapError "scripts/57/startDBwGTID.sh"
sleep 2
runAndTrapError "scripts/57/checkGTIDVar.sh"

cat << STEP2_5
GTID を有効にして MySQL Server 5.7 を再起動し、再度、\`./scripts/57/checkGTIDVar.sh\`を実行しました。
gtid_modeがオンになっていることを確認してください。

STEP2_5

sleep 4

cat << STEP2_6
## 02-03: MySQL Server 5.7 から MySQL Shell 8.0 でデータダンプを実施
(インスタンスダンプユーティリティに関する情報は: https://dev.mysql.com/doc/mysql-shell/8.4/en/mysql-shell-utilities-dump-instance-schema.html)

実行するスクリプト \`./scripts/57/dumpData.sh\`:
STEP2_6

extractFile "scripts/57/dumpData.sh"

waitRun

runAndTrapError "scripts/57/dumpData.sh"

sleep 4

cat << STEP2_7
## 02-04: MySQL Server 8.0 に MySQL Shell 8.0 で接続し、5.7 のデータダンプをロード
(ダンプロードユーティリティに関する情報は: https://dev.mysql.com/doc/mysql-shell/8.4/en/mysql-shell-utilities-load-dump.html)

実行するスクリプト \`./scripts/80/loadDumpFrom57.sh\`:
STEP2_7

extractFile "scripts/80/loadDumpFrom57.sh"

waitRun

runAndTrapError "scripts/80/loadDumpFrom57.sh"

sleep 4

cat << STEP2_8
## 02-05: MySQL Server 8.0 で、MySQL Server 5.7 をソースとするレプリケーションの設定と開始

MySQL Server 8.0 で MySQL Server 5.7 をソースとするレプリケーションを設定し、開始します。

実行するスクリプト \`./scripts/80/setUpReplFrom57.sh\`,\`./scripts/80/startRepl.sh\`:
STEP2_8

extractFile "scripts/80/setUpReplFrom57.sh"
extractFile "scripts/80/startRepl.sh"

waitRun

runAndTrapError "scripts/80/setUpReplFrom57.sh"
runAndTrapError "scripts/80/startRepl.sh"

sleep 4

cat << STEP2_9
## 02-06: レプリケーションの完成をテスト

以上でレプリケーションは完了しました。
レプリケーションが動作しているか確認するため、MySQL Server 5.7 でデータを更新し、MySQL Server 8.0 に更新が伝播するかを確認します。

実行するスクリプト \`./scripts/80/testReplFrom57.sh\`:
STEP2_9

extractFile "scripts/80/testReplFrom57.sh"

waitRun

runAndTrapError "scripts/80/testReplFrom57.sh"

cat << STEP2_10
検索結果として \`Tatebayashi JPN Gumma 75440\` が表示されれば正常に動いています。

STEP2_10

sleep 4

cat << STEP2_11
## 02-07: レプリケーション終了

レプリケーションが最新の更新まで伝播すれば、アプリケーションの接続先を MySQL Server 5.7 から 8.0 に変更し、レプリケーションを終了できます。

実行するスクリプト \`./scripts/80/stopRepl.sh\`, \`./scripts/80/resetRepl.sh\`:
STEP2_11

extractFile "scripts/80/stopRepl.sh"
extractFile "scripts/80/resetRepl.sh"

waitRun

runAndTrapError "scripts/80/stopRepl.sh"
runAndTrapError "scripts/80/resetRepl.sh"

cat << STEP2_12
以上で、MySQL Server 5.7 から 8.0 へのアップグレードが完了しました。

次の手順は、\`./scripts/handson/03_replicationFrom80To84.sh\` です。
MySQL Server 8.0 から 8.4 への、CLONEプラグインとインプレースアップグレードをテストします。
STEP2_12

exit 0
