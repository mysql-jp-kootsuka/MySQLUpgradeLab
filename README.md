# MySQLUpgradeLab
## これはMySQL 5.7から8.4までのアップグレードを経験するラボのページです。
## This is the Lab exercise about upgrading MySQL from 5.7 to 8.4.
##
## 環境 : 提供するVMインスタンスには、既にMySQL Server Enterprise Edition（5.7、8.0、8.4、9.0）と、Shell（8.0, 8.4, 9.0）のバイナリが含まれています。
## Environment : The VM instance provided already includes MySQL Server Enterprise Edition (5.7, 8.0, 8.4, 9.0), and Shell (8.0, 8.4, 9.0) binaries.
### /usr/localフォルダには、関連するtarパッケージに含まれるバイナリが配置されています。
### The /usr/local folder contains the binaries from corresponding tar packages.  
	MySQL 5.7 Home   : /home/opc/mysql/57
	MySQL 8.0 Home   : /home/opc/mysql/80
	MySQL Shell 8.0  : /home/opc/mysql/80sh
 	MySQL 8.4 Home   : /home/opc/mysql/84
	MySQL Shell 8.4  : /home/opc/mysql/84sh
 	MySQL 9.0 Home   : /home/opc/mysql/90
	MySQL Shell 9.0  : /home/opc/mysql/90sh

## ポートとデータの場所
## Port & data location
	MySQL 5.7 :	3357 : 	/home/opc/mysql/data/57
	MySQL 8.0 : 	3380 :	/home/opc/mysql/data/80
	MySQL 8.4 :	3384 :	/home/opc/mysql/data/84
 	MySQL 9.0 : 	3390 : 	/home/opc/mysql/data/90


```
alias mysql57init='/home/opc/mysql/57/bin/mysqld --basedir=/home/opc/mysql/data/57 --initialize-insecure'
alias mysql57start='/home/opc/mysql/57/bin/mysqld --basedir=/home/opc/mysql/data/57 --port=3357 --socket=/tmp/mysql57.sock &'
alias mysql57stop='/home/opc/mysql/80sh/bin/mysqlsh root@127.0.0.1:3357 --sql -e"SHUTDOWN"'
alias mysql80init='/home/opc/mysql/80/bin/mysqld --basedir=/home/opc/mysql/data/80 --initialize-insecure'
alias mysql80start='/home/opc/mysql/80/bin/mysqld --basedir=/home/opc/mysql/data/80 --port=3380 --socket=/tmp/mysql80.sock &'
alias mysql80stop='/home/opc/mysql/80sh/bin/mysqlsh root@127.0.0.1:3380 --sql -e"SHUTDOWN"'
alias mysql84init='/home/opc/mysql/84/bin/mysqld --basedir=/home/opc/mysql/data/84 --initialize-insecure'
alias mysql84start='/home/opc/mysql/84/bin/mysqld --basedir=/home/opc/mysql/data/84 --port=3384 --socket=/tmp/mysql84.sock &'
alias mysql84stop='/home/opc/mysql/80sh/bin/mysqlsh root@127.0.0.1:3384 --sql -e"SHUTDOWN"'
alias mysql90init='/home/opc/mysql/90/bin/mysqld --basedir=/home/opc/mysql/data/90 --initialize-insecure'
alias mysql90start='/home/opc/mysql/90/bin/mysqld --basedir=/home/opc/mysql/data/90 --port=3390 --socket=/tmp/mysql90.sock &'
alias mysql90stop='/home/opc/mysql/80sh/bin/mysqlsh root@127.0.0.1:3390 --sql -e"SHUTDOWN"'
```

```
mysql/80sh/bin/mysqlsh root@localhost:3357 --sql -e"source /home/opc/mysql/sql/world.sql"

util.dumpInstance("/home/opc/mysql/data/57dump");

util.checkForServerUpgrade();

mysql/80sh/bin/mysqlsh --sql root@localhost:3357 -e"SET GLOBAL enforce_gtid_consistency = ON;SET GLOBAL gtid_mode = OFF_PERMISSIVE;SET GLOBAL gtid_mode = ON_PERMISSIVE;SET GLOBAL gtid_mode = ON;"
mysql/80sh/bin/mysqlsh --sql root@localhost:3380 -e"SET GLOBAL enforce_gtid_consistency = ON;SET GLOBAL gtid_mode = OFF_PERMISSIVE;SET GLOBAL gtid_mode = ON_PERMISSIVE;SET GLOBAL gtid_mode = ON;"
mysql/80sh/bin/mysqlsh --sql root@localhost:3384 -e"SET GLOBAL enforce_gtid_consistency = ON;SET GLOBAL gtid_mode = OFF_PERMISSIVE;SET GLOBAL gtid_mode = ON_PERMISSIVE;SET GLOBAL gtid_mode = ON;"
mysql/80sh/bin/mysqlsh --sql root@localhost:3390 -e"SET GLOBAL enforce_gtid_consistency = ON;SET GLOBAL gtid_mode = OFF_PERMISSIVE;SET GLOBAL gtid_mode = ON_PERMISSIVE;SET GLOBAL gtid_mode = ON;"

SET GLOBAL local_infile=ON;
util.loadDump("/home/opc/mysql/data/57dump", {ignoreVersion:true});

```

## Preparation
### Ensure there is no mysqld service running.  By default with the provided VM instance, there are 4 active mysql services running.
### Please login as opc and stop those services
1. login as opc
2. Stop the services
```
sudo systemctl stop mysqld@mysql01
sudo systemctl stop mysqld@mysql02
sudo systemctl stop mysqld@mysql03
sudo systemctl stop mysqld
```

3. Check if any mysqld is running
```
ps -ef|grep mysqld
```

4. Switch user to mysql
```
sudo su - mysql
```

5. Using git to clone InnoDB Cluster environment (mysql as user)
```
cd  /home/mysql
mkdir lab
cd lab
git clone https://github.com/ivanxma/InnoDBClusterLab
cd ~/lab/InnoDBClusterLab
```


## The exercise includes



1. Initialization of 3 servers (3310,3320, 3330) on the same VM
2. Configuration for GTID
3. Using MySQL Shell and  Configuring Group Replication Admin User & settings 
4. Creating InnoDB Cluster - 1 member, and add 2nd node using Incremental, and add 3rd node usign Clone
5. Administrating InnoDB Cluster
6. Bootstraping MySQL Router with InnoDB Cluster
7. Creating another 3 servers (3340, 3350, 3360) and building clusterset to link mycluster and mycluster2(3340,3350,3360)

[ベースイメージの構成]
- MySQL 5.7, 8.0, 8.4, MySQL Shell 8.0, 8.4の
   tarバイナリをダウンロード＆解凍済み
- MySQLサーバーの起動停止はサービスではなくコマンド(またはスクリプト)で
- 作業用スクリプトとコピペしてもらうコマンド集を格納

[シナリオ概要] (インスタンス作成やネットワークは別途)
MySQL 5.7から8.0へのバージョンの手順
0. MySQL Shell 8.0から5.7に接続しUpgrade Checkerでの非互換の確認
1. 5.7のデータのバックアップ
2. 8.0にバックアップデータをリストア
3. 5.7へ追いつくまでレプリケーション
4. 静止点を設けてクライアントからの接続切り替え

8.0 -> 8.0のレプリケーション環境でレプリカを8.4にバージョンアップ
※ クローンで8.0のレプリカ作成しレプリケーション
0. MySQL Shell 8.4からソースの8.0に接続しUpgrade Checkerでの非互換の確認
1. レプリカ8.0停止
2. 8.0のバイナリを8.4に入れ替え(※シンボリックリンクのきりかえ？)
3. レプリカ8.4を起動しソース8.0へ追いつくまでレプリケーション
