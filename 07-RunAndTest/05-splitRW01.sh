mysql -udemo -pdemo -h127.0.0.1 -P7450 -e "
select 'SELECT', @@port;
select 'for update', @@port for update;

create database if not exists mydb;
use mydb;

create table if not exists mydb.myrwtable (f1 int not null primary key, f2 varchar(20));

truncate table mydb.myrwtable;

insert into mydb.myrwtable values (1, @@port);
insert into mydb.myrwtable values (2, @@port);

select 'SELECT', myrwtable.*, @@port from mydb.myrwtable;
select 'for update', myrwtable.*, @@port from mydb.myrwtable for update;
"

