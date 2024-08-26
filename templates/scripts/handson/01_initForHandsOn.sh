. ./scripts/commons/functions.sh

cat << STEP1_1
# ハンズオン手順1: MySQL Server アップグレードハンズオンの環境準備を行う

## 01-01: MySQL Server 5.7 の初期化と起動

実行するスクリプト \`./scripts/57/initDB.sh\`:
STEP1_1

extractFile "scripts/57/initDB.sh"

cat << STEP1_2
MySQL 設定ファイルの内容 \`./configs/my57.cnf\`:
STEP1_2

extractFile "configs/my57.cnf"

waitRun

runAndTrapError "scripts/57/initDB.sh"

sleep 2

cat << STEP1_3
続いて MySQL Server 5.7 の起動を行います

実行するスクリプト \`./scripts/57/startDB.sh\`:
STEP1_3

extractFile "scripts/57/startDB.sh"

waitRun

runAndTrapError "scripts/57/startDB.sh"

cat << STEP1_4
MySQL Server 5.7が起動しました。
以後、\`./scripts/57/connectDB.sh\`で接続、\`./scripts/57/stopDB.sh\`で停止、\`./scripts/57/startDB.sh\`で起動できます。

各シェルの内容:
STEP1_4

extractFile "scripts/57/connectDB.sh"
extractFile "scripts/57/stopDB.sh"

sleep 4

cat << STEP1_5
## 01-02: アップグレード先である、MySQL Server 8.0 の初期化と起動

実行するスクリプト \`./scripts/80/initDB.sh\`,\`./scripts/80/startDB.sh\`:
STEP1_5

extractFile "scripts/80/initDB.sh"
extractFile "scripts/80/startDB.sh"

cat << STEP1_6
MySQL 設定ファイルの内容 \`./configs/my80.cnf\`:
STEP1_6

extractFile "configs/my80.cnf"

waitRun

runAndTrapError "scripts/80/initDB.sh"
runAndTrapError "scripts/80/startDB.sh"

cat << STEP1_7
MySQL Server 8.0が起動しました。
以後、\`./scripts/80/connectDB.sh\`で接続、\`./scripts/80/stopDB.sh\`で停止、\`./scripts/80/startDB.sh\`で起動できます。

各シェルの内容:
STEP1_7

extractFile "scripts/80/connectDB.sh"
extractFile "scripts/80/stopDB.sh"

sleep 4

cat << STEP1_8
## 01-03: MySQL Server 5.7 にworldデータベースを読み込み

実行するスクリプト \`./scripts/57/loadSQL.sh\`:
STEP1_8

extractFile "scripts/57/loadSQL.sh"

waitRun

runAndTrapError "scripts/57/loadSQL.sh"

cat << STEP1_9
worldデータベースが生成できたことを確認します。

実行するスクリプト \`./scripts/57/showDBs.sh\`:
STEP1_9

extractFile "scripts/57/showDBs.sh"

waitRun

runAndTrapError "scripts/57/showDBs.sh"

cat << STEP1_10
データベース一覧に world が含まれていれば完了です。

次の手順は、\`./scripts/handson/02_replicationFrom57To80.sh\` です。
MySQL Server 5.7 から 8.0 への、データのダンプ/ロードとレプリケーションを通じたアップグレードをテストします。
STEP1_10

exit 0
