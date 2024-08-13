# MySQLUpgradeLab
## これはMySQL 5.7から8.4までのアップグレードを経験するラボのページです。
## This is the Lab exercise about upgrading MySQL from 5.7 to 8.4.
##
## 環境 : 提供するVMインスタンスには、既にMySQL Server Enterprise Edition（5.7、8.0、8.4、9.0）と、Shell（8.0, 8.4, 9.0）のバイナリが含まれています。
## Environment : The VM instance provided already includes MySQL Server Enterprise Edition (5.7, 8.0, 8.4, 9.0), and Shell (8.0, 8.4, 9.0) binaries.
### /usr/localフォルダには、関連するtarパッケージに含まれるバイナリが配置されています。
### The /usr/local folder contains the binaries from corresponding tar packages.  
	MySQL 5.7 Home   : /usr/local/mysql57
	MySQL 8.0 Home   : /usr/local/mysql80
	MySQL Shell 8.0  : /usr/local/mysql80shell
 	MySQL 8.4 Home   : /usr/local/mysql84
	MySQL Shell 8.4  : /usr/local/mysql84shell
 	MySQL 8.4 Home   : /usr/local/mysql90
	MySQL Shell 8.4  : /usr/local/mysql90shell

## Data
	3310 : /home/mysql/data/3310
	3320 : /home/mysql/data/3320
	3330 : /home/mysql/data/3330

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
