# ハンズオン手順1: MySQL Server アップグレードハンズオンの環境準備を行う

`/home/opc/mysql`の下で、`./scripts/handson/01_initForHandsOn.sh`を実行してください。

## 01-01: MySQL Server 5.7 の初期化と起動

実行するスクリプト `./scripts/57/initDB.sh`:

* scripts/57/initDB.sh
```
#!/bin/bash

# MySQL Server 5.7 のデータベースデータ初期化 (GTID、バイナリログ出力はデフォルト=OFF)
/home/opc/mysql/57/bin/mysqld --defaults-file=/home/opc/mysql/configs/my57.cnf --initialize-insecure
```

MySQL 設定ファイルの内容 `./configs/my57.cnf`:

* my57.cnf
```
[mysqld]
basedir=/home/opc/mysql/57                 # 実行ファイルの存在するフォルダ
datadir=/home/opc/mysql/data/57/data       # DBデータの格納されるフォルダ
port=3357                                  # サーバー待ち受けポート
socket=/tmp/my57.sock
log-error=/home/opc/mysql/data/57/my.error
```

続いて MySQL Server 5.7 の起動を行います

実行するスクリプト `./scripts/57/startDB.sh`:

* startDB.sh
```
#!/bin/bash

# MySQL Server 5.7 のデータベース常駐開始 (GTID、バイナリログ出力はデフォルト=OFF)
/home/opc/mysql/57/bin/mysqld --defaults-file=/home/opc/mysql/configs/my57.cnf &
```

MySQL Server 5.7が起動しました。
以後、`./scripts/57/connectDB.sh`で接続、`./scripts/57/stopDB.sh`で停止、`./scripts/57/startDB.sh`で起動できます。

各シェルの内容:

* connectDB.sh
```
#!/bin/bash

# MySQL Server 5.7 への MySQL Shell 接続
/home/opc/mysql/80sh/bin/mysqlsh root@localhost:3357
```

* stopDB.sh
```
#!/bin/bash

# MySQL Server 5.7 のデータベース停止
/home/opc/mysql/80sh/bin/mysqlsh root@localhost:3357 --sql -e"SHUTDOWN;"
```

## 01-02: アップグレード先である、MySQL Server 8.0 の初期化と起動

実行するスクリプト `./scripts/80/initDB.sh`,`./scripts/80/startDB.sh`:

* initDB.sh
```
#!/bin/bash

# MySQL Server 8.0 のデータベースデータ初期化 (GTID=ON)
/home/opc/mysql/80/bin/mysqld --defaults-file=/home/opc/mysql/configs/my80.cnf --initialize-insecure
```

* startDB.sh
```
#!/bin/bash

# MySQL Server 8.0 のデータベース常駐開始 (GTID=ON)
/home/opc/mysql/80/bin/mysqld --defaults-file=/home/opc/mysql/configs/my80.cnf &
```

MySQL 設定ファイルの内容 `./configs/my80.cnf`:

* my80.cnf
```
[mysqld]
basedir=/home/opc/mysql/80                 # 実行ファイルの存在するフォルダ
datadir=/home/opc/mysql/data/80/data       # DBデータの格納されるフォルダ
port=3380                                  # サーバー待ち受けポート
mysqlx-port=33800
socket=/tmp/my80.sock
mysqlx-socket=/tmp/my80x.socks
log-error=/home/opc/mysql/data/80/my.error
local_infile=on                            # loadDumpでローカルファイルシステムからの読み込みを許可する設定
enforce_gtid_consistency=on                # GTID整合性に違反するトランザクションを禁止する設定
gtid_mode=on                               # GTIDを用いる設定
server_id=80                               # サーバーごとに一意なID
# MySQL 8.0 以上ではバイナリログ出力がデフォルトのため、log_bin=on は不要
```

MySQL Server 8.0が起動しました。
以後、`./scripts/80/connectDB.sh`で接続、`./scripts/80/stopDB.sh`で停止、`./scripts/80/startDB.sh`で起動できます。

各シェルの内容:

* connectDB.sh
```
#!/bin/bash

# MySQL Server 8.0 への MySQL Shell 接続
/home/opc/mysql/80sh/bin/mysqlsh root@localhost:3380
```

* stopDB.sh
```
#!/bin/bash

# MySQL Server 8.0 のデータベース停止
/home/opc/mysql/80sh/bin/mysqlsh root@localhost:3380 --sql -e"SHUTDOWN;"
```

## 01-03: MySQL Server 5.7 にworldデータベースを読み込み

実行するスクリプト `./scripts/57/loadSQL.sh`:

* loadSQL.sh
```
#!/bin/bash

# MySQL Server 5.7 に world データベースを SQL から読み込み
/home/opc/mysql/80sh/bin/mysqlsh root@localhost:3357 --sql -e"source /home/opc/mysql/sql/world.sql;"
```

worldデータベースが生成できたことを確認します。

実行するスクリプト `./scripts/57/showDBs.sh`:

* showDBs.sh
```
#!/bin/bash

# MySQL Server 5.7 で Database の一覧を表示
/home/opc/mysql/80sh/bin/mysqlsh root@localhost:3357 --sql -e"SHOW DATABASES;"
```
| Database |
| ---- | 
| information_schema |
| mysql |
| performance_schema |
| sys |
| world |

データベース一覧に world が含まれていれば完了です。

[次の手順](./02_replicationFrom57To80.md)は、`./scripts/handson/02_replicationFrom57To80.sh` です。  
MySQL Server 5.7 から 8.0 への、データのダンプ/ロードとレプリケーションを通じたアップグレードをテストします。
