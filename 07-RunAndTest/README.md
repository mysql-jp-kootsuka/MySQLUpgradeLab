# Using MySQL InnoDB Cluster
1. Create User on R/W node
2. Running mysqlslap 
3. Creating New Router using existing Router Account



## Create User on R/W node
Login as root directly on the R/W node (assuming it is on 3310)
```
mysql -uroot -h127.0.0.1 -P3310 -e "
create user demo@'%' identified by 'demo';
grant all on *.* to demo@'%';
"
```

## Running mysqlslap
  * mysqlslap is to allow concurrent loading to db.  Executing the following command applies 50 concurrent SELECT operations to the InnoDB Cluster on R/W node thru MySQL Router.
```
mysqlslap -udemo -pdemo -h127.0.0.1 -P6446 --delimiter=";"  --create="CREATE TABLE a (b int not null primary key);INSERT INTO a VALUES (23)" --query="SELECT * FROM a" --concurrency=50 --iterations=200 &

```

## Checking the processlist from mysqlsh
  * Login thru mysqlsh
```
mysqlsh --uri gradmin:grpass@`hostname`:3310
```
  * watching query "show processlist"
```
\watch query "show processlist"
```

## Creating Router Account
  * Login thru mysqlsh
```
mysqlsh --uri gradmin:grpass@`hostname`:3310
```

  * Create Router Account - routeruser / routerpass
```
var x = dba.getCluster()
x.setupRouterAccount('routeruser', {password:'routerpass'})
```

  * Bootstrap another Router config and port (--conf-base-port=7446, --https=port=9443  and --acount routeruser).  Enter routerpass as password for routeruser.  Redefining the ports as such there is no conflict to default ports to the started mysqlrouter

```
cd ~/lab/InnoDBClusterLab/06-Router
mysqlrouter --conf-base-port=7446 --bootstrap gradmin:grpass@`hostname`:3310 --https-port=9443 --account=routeruser --force --directory myrouter-acct

```

  * Start up MySQL Router using 7446 port
```
cd ~/lab/InnoDBClusterLab/06-Router/myrouter-acct
./start.sh
```

  * Test with New MySQL Router
```
mysql -udemo -pdemo -h127.0.0.1 -P7446 -e "select @@hostname, @@port;"
```

  * Test with DEFAULT(6450) - 7450 split READ/WRITE port
```
mysql -udemo -pdemo -h127.0.0.1 -P7450 
```

  * Issue the following SQL
```
select @@port;
select @@port for update;

create database mydb;
user mydb;
create table mydb.myrwtable (f1 int not null primary key, f2 varchar(20));

insert into mydb.myrwtable(1, @@port);
insert into mydb.myrwtable(2, @@port);

select myrwtable.*, @@port from mydb.myrwtable;
select myrwtable.*, @@port from mydb.myrwtable for update;



  * Transaction once is started, the session goes to PRIMARY
```
begin;
select @@port;
commit;

select @@port;
```

  * Creating Temp table and the session will always be in PRIMARY

```
create temporary table mydb.mytmptable(f1 int not null primary key, f2 varchar(20));

insert into mydb.mytmptable values (1, @@port);

select @@port, mytmptable.* from mydb.mytmptable;
```
