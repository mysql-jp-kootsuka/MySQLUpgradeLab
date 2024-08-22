# MySQLUpgradeLab

これはMySQL 5.7から8.4までのアップグレードを経験するラボのページです。  
This is the Lab exercise about upgrading MySQL from 5.7 to 8.4.

## [環境構築](./extractScripts/extractEnv.md)

[ハンズオンワークショップ](https://eventreg.oracle.com/profile/web/index.cfm?PKwebID=0x883786abcd&source=DEVT240718P00002:ex:pev:::::&SC=:ex:pev:::::&pcode=DEVT240718P00002)では、環境構築済みのOCI (Oracle Cloud Inflastructure) コンピュート環境を提供します。  
その場合、提供するコンピュート環境では、既に環境構築されていますので、次に進み環境を確認してください。  

## [環境確認](./checkEnv.md)

提供するハンズオン環境を確認します。  

## ハンズオン手順

1. [MySQL Server アップグレードハンズオンの環境準備を行う](./mds/scripts/01_initForHandsOn.md)
1. [MySQL Server 5.7 から 8.0 への、データのダンプ/ロードとレプリケーションを通じたアップグレード](./mds/scripts/02_replicationFrom57To80.md)
1. [MySQL Server 8.0 から 8.4 への、CLONEプラグインとインプレースアップグレードのテスト](./mds/scripts/03_replicationFrom80To84.md)
